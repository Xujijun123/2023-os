#include <assert.h>
#include <defs.h>
#include <fs.h>
#include <ide.h>
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}//页面换入和换出的硬盘（通常称为 swap 硬盘）的初始化
#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }//ideno是否为有效的IDE设备

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }//ide设备的大小

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {//从ide中读取扇区域
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
    return 0;
}

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {//向IDE中写入扇区域
    int iobase = secno * SECTSIZE;
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
    return 0;
}
