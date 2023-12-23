#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <kmalloc.h>
#include <list.h>
#include <fs.h>
#include <vfs.h>
#include <dev.h>
#include <sfs.h>
#include <inode.h>
#include <iobuf.h>
#include <bitmap.h>
#include <error.h>
#include <assert.h>
#include <proc.h>
/*
 * sfs_sync - sync sfs's superblock and freemap in memroy into disk
 */
static int
sfs_sync(struct fs *fs) {
    struct sfs_fs *sfs = fsop_info(fs, sfs);
    lock_sfs_fs(sfs);
    {
        list_entry_t *list = &(sfs->inode_list), *le = list;
        while ((le = list_next(le)) != list) {
            struct sfs_inode *sin = le2sin(le, inode_link);
            vop_fsync(info2node(sin, sfs_inode));
        }
    }
    unlock_sfs_fs(sfs);

    int ret;
    if (sfs->super_dirty) {
        sfs->super_dirty = 0;
        if ((ret = sfs_sync_super(sfs)) != 0) {
            sfs->super_dirty = 1;
            return ret;
        }
        if ((ret = sfs_sync_freemap(sfs)) != 0) {
            sfs->super_dirty = 1;
            return ret;
        }
    }
    return 0;
}

/*
 * sfs_get_root - get the root directory inode  from disk (SFS_BLKN_ROOT,1)
 */
static struct inode *
sfs_get_root(struct fs *fs) {
    struct inode *node;
    int ret;
    if ((ret = sfs_load_inode(fsop_info(fs, sfs), &node, SFS_BLKN_ROOT)) != 0) {
        panic("load sfs root failed: %e", ret);
    }
    return node;
}

/*
 * sfs_unmount - unmount sfs, and free the memorys contain sfs->freemap/sfs_buffer/hash_liskt and sfs itself.
 */
static int
sfs_unmount(struct fs *fs) {
    struct sfs_fs *sfs = fsop_info(fs, sfs);
    if (!list_empty(&(sfs->inode_list))) {
        return -E_BUSY;
    }
    assert(!sfs->super_dirty);
    bitmap_destroy(sfs->freemap);
    kfree(sfs->sfs_buffer);
    kfree(sfs->hash_list);
    kfree(sfs);
    return 0;
}

/*
 * sfs_cleanup - when sfs failed, then should call this function to sync sfs by calling sfs_sync
 *
 * NOTICE: nouse now.
 */
static void
sfs_cleanup(struct fs *fs) {
    struct sfs_fs *sfs = fsop_info(fs, sfs);
    uint32_t blocks = sfs->super.blocks, unused_blocks = sfs->super.unused_blocks;
    cprintf("sfs: cleanup: '%s' (%d/%d/%d)\n", sfs->super.info,
            blocks - unused_blocks, unused_blocks, blocks);
    int i, ret;
    for (i = 0; i < 32; i ++) {
        if ((ret = fsop_sync(fs)) == 0) {
            break;
        }
    }
    if (ret != 0) {
        warn("sfs: sync error: '%s': %e.\n", sfs->super.info, ret);
    }
}

/*
 * sfs_init_read - used in sfs_do_mount to read disk block(blkno, 1) directly.
 *
 * @dev:        the block device
 * @blkno:      the NO. of disk block
 * @blk_buffer: the buffer used for read
 *
 *      (1) init iobuf
 *      (2) read dev into iobuf
 */
static int
sfs_init_read(struct device *dev, uint32_t blkno, void *blk_buffer) {
    struct iobuf __iob, *iob = iobuf_init(&__iob, blk_buffer, SFS_BLKSIZE, blkno * SFS_BLKSIZE);
    return dop_io(dev, iob, 0);
}

/*
 * sfs_init_freemap - used in sfs_do_mount to read freemap data info in disk block(blkno, nblks) directly.
 *
 * @dev:        the block device
 * @bitmap:     the bitmap in memroy
 * @blkno:      the NO. of disk block
 * @nblks:      Rd number of disk block
 * @blk_buffer: the buffer used for read
 *
 *      (1) get data addr in bitmap
 *      (2) read dev into iobuf
 */
static int
sfs_init_freemap(struct device *dev, struct bitmap *freemap, uint32_t blkno, uint32_t nblks, void *blk_buffer) {
    size_t len;
    void *data = bitmap_getdata(freemap, &len);
    assert(data != NULL && len == nblks * SFS_BLKSIZE);
    while (nblks != 0) {
        int ret;
        if ((ret = sfs_init_read(dev, blkno, data)) != 0) {
            return ret;
        }
        blkno ++, nblks --, data += SFS_BLKSIZE;
    }
    return 0;
}

//sfs_do_mount函数定义
/*
sfs_do_mount - 挂载 SFS 文件系统。
@dev：包含 SFS 文件系统的块设备
@fs_store：内存中的 fs 结构体
*/
/*函数的功能是将SFS（Simple File System）文件系统挂载到指定的设备上。
具体实现过程包括读取设备中的超级块、空闲块位图等SFS文件系统的元数据信息，以及分配和初始化散列链表等数据结构。该函数会根据设备的块大小检查SFS块大小是否相同，
并将SFS文件系统的元数据信息存储在所指向的sfs_fs结构体中，以便后续使用。如果函数执行成功，会返回0；否则，会返回-1。*/
static int
sfs_do_mount(struct device *dev, struct fs **fs_store) {
    static_assert(SFS_BLKSIZE >= sizeof(struct sfs_super));
    static_assert(SFS_BLKSIZE >= sizeof(struct sfs_disk_inode));
    static_assert(SFS_BLKSIZE >= sizeof(struct sfs_disk_entry));

    if (dev->d_blocksize != SFS_BLKSIZE) {//检查设备的块大小是否与SFS块大小相同
        return -E_NA_DEV;
    }

    /* allocate fs structure */
    //分配并初始化一个fs结构体，并将所指向的sfs_fs结构体的dev字段设置为传入的设备。
    struct fs *fs;
    if ((fs = alloc_fs(sfs)) == NULL) {
        return -E_NO_MEM;
    }
    struct sfs_fs *sfs = fsop_info(fs, sfs);
    sfs->dev = dev;

    int ret = -E_NO_MEM;

    //分配SFS块大小的内存作为sfs_buffer，并将前面刚初始化的sfs的sfs_buffer字段设置为该内存地址。
    void *sfs_buffer;
    if ((sfs->sfs_buffer = sfs_buffer = kmalloc(SFS_BLKSIZE)) == NULL) {
        goto failed_cleanup_fs;
    }

    /* load and check superblock */
    //将超级块读取到sfs_buffer中
    if ((ret = sfs_init_read(dev, SFS_BLKN_SUPER, sfs_buffer)) != 0) {
        goto failed_cleanup_sfs_buffer;
    }
    ret = -E_INVAL;
    //检查超级块的魔数是否与SFS_MAGIC相同。即磁盘镜像是否是合法
    struct sfs_super *super = sfs_buffer;
    if (super->magic != SFS_MAGIC) {
        cprintf("sfs: wrong magic in superblock. (%08x should be %08x).\n",
                super->magic, SFS_MAGIC);
        goto failed_cleanup_sfs_buffer;
    }
    if (super->blocks > dev->d_blocks) {//超级块中的块数是否小于或等于设备的块数
        cprintf("sfs: fs has %u blocks, device has %u blocks.\n",
                super->blocks, dev->d_blocks);
        goto failed_cleanup_sfs_buffer;
    }
    //将超级块中的文件系统信息字符串末尾设置为’\0’，并将所指向的sfs_fs结构体的super字段设置为超级块的内容。
    super->info[SFS_MAX_INFO_LEN] = '\0';
    sfs->super = *super;

    ret = -E_NO_MEM;

    uint32_t i;

    /* alloc and initialize hash list */
    //分配和初始化散列链表
    list_entry_t *hash_list;
    if ((sfs->hash_list = hash_list = kmalloc(sizeof(list_entry_t) * SFS_HLIST_SIZE)) == NULL) {
        //分配用于存储散列链表的内存，并将所指向的sfs_fs结构体的hash_list字段设置为该内存地址。然后，将散列链表的各个槽初始化为空。
        goto failed_cleanup_sfs_buffer;
    }
    for (i = 0; i < SFS_HLIST_SIZE; i ++) {
        list_init(hash_list + i);
    }

    /* load and check freemap */
    //读取并检查空闲块位图
    struct bitmap *freemap;
    uint32_t freemap_size_nbits = sfs_freemap_bits(super);
    if ((sfs->freemap = freemap = bitmap_create(freemap_size_nbits)) == NULL) {//计算出空闲块位图所需的位数，为它分配内存；并将所指向的sfs_fs结构体的freemap字段设置为该位图
        goto failed_cleanup_hash_list;
    }
    uint32_t freemap_size_nblks = sfs_freemap_blocks(super);
    if ((ret = sfs_init_freemap(dev, freemap, SFS_BLKN_FREEMAP, freemap_size_nblks, sfs_buffer)) != 0) {//读取空闲块位图的内容，并检查返回值是否为0
        goto failed_cleanup_freemap;
    }

    uint32_t blocks = sfs->super.blocks, unused_blocks = 0;
    for (i = 0; i < freemap_size_nbits; i ++) {//计算文件系统的总块数和未使用块数，并进行断言检查未使用块数是否与超级块中的值相等。
        if (bitmap_test(freemap, i)) {
            unused_blocks ++;
        }
    }
    assert(unused_blocks == sfs->super.unused_blocks);

    /* and other fields */
    sfs->super_dirty = 0;
    sem_init(&(sfs->fs_sem), 1);
    sem_init(&(sfs->io_sem), 1);
    sem_init(&(sfs->mutex_sem), 1);
    list_init(&(sfs->inode_list));
    cprintf("sfs: mount: '%s' (%d/%d/%d)\n", sfs->super.info,
            blocks - unused_blocks, unused_blocks, blocks);

    /* link addr of sync/get_root/unmount/cleanup funciton  fs's function pointers*/
    fs->fs_sync = sfs_sync;
    fs->fs_get_root = sfs_get_root;
    fs->fs_unmount = sfs_unmount;
    fs->fs_cleanup = sfs_cleanup;
    *fs_store = fs;
    return 0;

failed_cleanup_freemap:
    bitmap_destroy(freemap);
failed_cleanup_hash_list:
    kfree(hash_list);
failed_cleanup_sfs_buffer:
    kfree(sfs_buffer);
failed_cleanup_fs:
    kfree(fs);
    return ret;
}

int
sfs_mount(const char *devname) {
    return vfs_mount(devname, sfs_do_mount);
}

