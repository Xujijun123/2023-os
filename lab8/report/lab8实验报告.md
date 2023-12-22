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



![](./命令.png)

![](./makeqemu.png)

![](./makegrade.png)