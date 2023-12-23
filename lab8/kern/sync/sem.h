#ifndef __KERN_SYNC_SEM_H__
#define __KERN_SYNC_SEM_H__

#include <defs.h>
#include <atomic.h>
#include <wait.h>

typedef struct {
    /*信号量value来控制访问的次序以及允许访问的数量。
    通常将 value 初始化为资源可用的数量， 每次线程或进程访问该资源时将 value 减一，离开该资源时将 value 加一。
    当 value 为 0 时，其他线程或进程需要等待进程离开资源后才能访问。*/
    int value;
    wait_queue_t wait_queue;//等待该信号量的线程或进程的队列
} semaphore_t;//信号量结构体

void sem_init(semaphore_t *sem, int value);
void up(semaphore_t *sem);
void down(semaphore_t *sem);
bool try_down(semaphore_t *sem);

#endif /* !__KERN_SYNC_SEM_H__ */

