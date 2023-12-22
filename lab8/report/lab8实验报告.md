# 练习0：填写已有实验

本实验的代码合并要用到lab6的相关代码

```c
proc.c/alloc_proc()
{
    ...
         proc->rq = NULL;
        list_init(&(proc->run_link));
        proc->time_slice = 0;
        proc->lab6_run_pool.left = proc->lab6_run_pool.right = proc->lab6_run_pool.parent = NULL;
        proc->lab6_stride = 0;
        proc->lab6_priority = 0;
        
        proc->filesp = NULL;
}
```

```c
default_sched_stride.c/proc_stride_comp_f(void *a, void *b){
   	 struct proc_struct *p = le2proc(a, lab6_run_pool);
     struct proc_struct *q = le2proc(b, lab6_run_pool);
     int32_t c = p->lab6_stride - q->lab6_stride;
     if (c > 0) return 1;
     else if (c == 0) return 0;
     else return -1;
}

stride_init(struct run_queue *rq) {//开始初始化运行队列，并初始化当前的运行队，然后设置当前运行队列内进程数目为0
     list_init(&(rq->run_list));//初始化调度器类
     rq->lab6_run_pool = NULL;//对斜堆进行初始化，表示有限队列为空
     rq->proc_num = 0;//设置运行队列为空
}

stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {//将进程 proc 添加到运行队列 rq 中。这个函数根据宏定义 USE_SKEW_HEAP 的状态，使用不同的方式将进程添加到运行队列中
#if USE_SKEW_HEAP
     rq->lab6_run_pool =
          skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);//将进程 proc 插入到斜堆 rq->lab6_run_pool 中，按照给定的比较函数 proc_stride_comp_f 进行排序
#else//如果宏定义 USE_SKEW_HEAP 未被定义，表明使用链表作为调度算法的数据结构
     assert(list_empty(&(proc->run_link)));//确保进程的 run_link 指针为空，以确保进程不在其他运行队列中
     list_add_before(&(rq->run_list), &(proc->run_link));//将进程 proc 添加到运行队列 rq 的末尾
#endif
     if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice) {//检查进程的时间片（time slice）是否符合预期。
          proc->time_slice = rq->max_time_slice;//将该进程剩余时间置为时间片大小
     }
     proc->rq = rq;//将进程的 rq 指针指向当前运行队列 rq，表示该进程被加入到该运行队列中
     rq->proc_num ++;//增加运行队列 rq 中进程数量的计数器
}

stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {//将进程 proc 从运行队列 rq 中移除
#if USE_SKEW_HEAP
     rq->lab6_run_pool =
          skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);//删除斜堆中的指定进程
#else
     assert(!list_empty(&(proc->run_link)) && proc->rq == rq);
     list_del_init(&(proc->run_link));
#endif
     proc->rq = NULL;
     rq->proc_num --;//维护就绪队列中的进程总数
}

stride_pick_next(struct run_queue *rq) {//从运行队列 rq 中选择下一个要执行的进程,根据stride算法，只需要选择stride值最小的进程，即斜堆的根节点对应的进程即可
#if USE_SKEW_HEAP
     if (rq->lab6_run_pool == NULL) return NULL;
     struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);//选择 stride 值最小的进程
#else
  	 list_entry_t *le = list_next(&(rq->run_list));

     if (le == &rq->run_list)
          return NULL;
     
     struct proc_struct *p = le2proc(le, run_link);
     le = list_next(le);
     while (le != &rq->run_list)
     {
          struct proc_struct *q = le2proc(le, run_link);
          if ((int32_t)(p->lab6_stride - q->lab6_stride) > 0)
               p = q;
          le = list_next(le);
     }
    
#endif
     if (p->lab6_priority == 0)//优先级为 0
          p->lab6_stride += BIG_STRIDE;//步长设置为最大值
     else p->lab6_stride += BIG_STRIDE / p->lab6_priority;//步长设置为优先级的倒数，更新该进程的 stride 值
     return p;
}

stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {//时钟中断
     if (proc->time_slice > 0) {//到达时间片
          proc->time_slice --;//执行进程的时间片 time_slice 减一
     }
     if (proc->time_slice == 0) {//时间片为 0
          proc->need_resched = 1;//设置此进程成员变量 need_resched 标识为 1，进程需要调度
     }
}
```

# 练习1: 完成读文件操作的实现（需要编码）

```c
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    if ((blkoff = offset % SFS_BLKSIZE) != 0) {
        size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            goto out;
        }
        alen += size;
        if (nblks == 0) {
            goto out;
        }
        buf += size;
        blkno ++;
        nblks --;
    }

    size = SFS_BLKSIZE;
    
    while (nblks != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
            goto out;
        }
        alen += size; 
        buf += size; 
        blkno ++; 
        nblks --;
    }

    if ((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            goto out;
        }
        alen += size;
    }
}
```

- **对齐处理**

  ```c
  if ((blkoff = offset % SFS_BLKSIZE) != 0) {//判断offset是否对其，bloff为块内偏移量
      size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
      //size是需要读写的长度
      if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {//获取映射块
          goto out;
      }
      if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {//读写对应块
          goto out;
      }
      alen += size;//更新，如果没有块就跳出
      if (nblks == 0) {
          goto out;
      }
      buf += size;
      blkno ++;
      nblks --;
  }
  ```

- **对齐块读写**

  ```c
  size = SFS_BLKSIZE;
      
  while (nblks != 0) {//处理对齐的块，循环读写每个块
      if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
          goto out;
      }
      if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
          goto out;
      }
      alen += size; //更新alen，移动缓冲区指针和块号，继续处理下一个块
      buf += size; 
      blkno ++; 
      nblks --;
  }
  ```

- **不对齐部分处理**

  ```c
  if ((size = endpos % SFS_BLKSIZE) != 0) {//文件末尾的不足一个块的部分
      if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
          goto out;
      }
      if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
          goto out;
      }
      alen += size;
  }
  ```

# 练习2: 完成基于文件系统的执行程序机制的实现（需要编码）

# 扩展练习 Challenge1：完成基于“UNIX的PIPE机制”的设计方案

# 扩展练习 Challenge2：完成基于“UNIX的软连接和硬连接机制”的设计方案

> 如果要在 `ucore` 里加入 `UNIX` 的软连接和硬连接机制，至少需要定义哪些数据结构和接口？（接口给出语义即可，不必具体实现。数据结构的设计应当给出一个（或多个）具体的 `C`语言 `struct`定义。在网络上查找相关的 `Linux` 资料和实现，请在实验报告中给出设计实现 `UNIX`的软连接和硬连接机制 的概要设方案，你的设计应当体现出对可能出现的同步互斥问题的处理。

软连接和硬连接允许文件在文件系统中的多个位置共享相同的物理存储空间或者引用相同的文件。对于实现这两种链接机制，需要考虑以下设计方面：

### 1. Inode 结构的扩展：

在 UNIX 文件系统中，每个文件都有一个相应的 inode（索引节点），用于存储文件的元数据信息。为了支持链接机制，需要对 inode 结构进行扩展，以存储链接相关的信息。

### 2. 硬链接和软链接的区别：

- **硬链接**：
  - 硬链接是文件系统中同一个文件的多个名称。多个文件名都指向同一个 inode，并且在文件系统中没有区别对待它们。每个硬链接都有一个独立的目录项，删除一个硬链接并不会影响其他链接。
  - 在设计中，需要考虑对 inode 结构的扩展，以记录连接到该 inode 的硬链接数量。
- **软链接**：
  - 软链接是一个特殊的文件，它包含指向另一个文件或目录的路径名。软链接类似于快捷方式，在打开时被解析为实际文件或目录。
  - 在设计中，需要为软链接引入新的数据结构以存储软链接的目标路径信息。

### 扩展的 Inode 结构和链接结构：

- **Inode 扩展结构**（`inode_extension`）：
  - 包含链接计数器（`nlinks`），记录连接到该 inode 的硬链接数量。
  - 包含指向软链接结构的指针，用于存储软链接的目标路径信息。
- **软链接结构**（`symlink`）：
  - 包含一个字符数组来存储软链接的目标路径。

### 接口和操作：

- **创建链接**：
  - 创建硬链接：增加链接计数器，将新链接与现有 inode 关联。
  - 创建软链接：存储软链接信息，并创建一个指向目标路径的符号链接。
- **删除链接**：
  - 删除硬链接：减少链接计数器，如果计数器为零则释放 inode。
  - 删除软链接：从文件系统中删除软链接。
- **读取链接信息**：
  - 读取硬链接：获取链接计数器的值。
  - 读取软链接：读取软链接的目标路径。
- **修改链接计数器**：
  - 对连接计数器进行递增和递减操作需要确保同步访问，避免并发修改导致的问题。

### 同步与异常处理：

- **同步机制**：
  - 引入信号量、互斥锁等同步机制，确保对链接操作的原子性和线程安全性。
- **异常情况处理**：
  - 处理链接目标不存在、软链接路径无效或其他异常情况，以确保链接操作的可靠性和安全性。

### 数据结构

```c
#define MAX_PATH_LENGTH 256
#define MAX_INODE_EXTENSIONS 1000  // 假设最多有1000个扩展inode结构

// 软链接结构
struct symlink {
    char target_path[MAX_PATH_LENGTH];  // 软链接的目标路径
};

// 扩展的Inode结构
struct inode_extension {
    int nlinks;  // 被链接计数
    struct symlink *symlink;  // 指向软链接结构的指针
};

// Inode结构
struct inode {
    // 其他 inode 相关信息...
    
    // 连接计数器，用于记录硬链接数
    int link_count;

    // 指向扩展信息的指针
    struct inode_extension *extension;

    // 锁，用于同步访问和修改 inode 结构
    struct semaphore inode_lock;
    
    // 其他属性...
};
```

### 接口代码

```c
//创建硬链接
int create_hard_link(const char* existing_path, const char* new_link_path) {
    // 通过 existing_path 找到相应的 inode
    
    // 分配一个新的目录项，指向相同的 inode
    
    // 增加链接计数器
    
    return 0; // 返回成功或失败的状态码
}

//创建软连接
int create_soft_link(const char* target_path, const char* link_path) {
    // 创建一个新的 inode
    
    // 分配一个新的目录项，指向新的 inode
    
    // 存储软链接信息到 inode 的扩展结构中
    
    return 0; // 返回成功或失败的状态码
}

//删除链接
int unlink(const char* path) {
    // 通过 path 找到相应的 inode
    
    // 如果是硬链接，则减少链接计数器
    // 如果是软链接，则释放相关资源
    
    // 删除对应的目录项
    
    return 0; // 返回成功或失败的状态码
}

//读取链接的目标路径
ssize_t readlink(const char* path, char* buf, size_t bufsize) {
    // 通过 path 找到相应的 inode
    
    // 如果是软链接，读取目标路径信息到 buf 中
    
    return 0; // 返回读取的字节数或错误码
}

```



![](./命令.png)

![](./makeqemu.png)

![](./makegrade.png)