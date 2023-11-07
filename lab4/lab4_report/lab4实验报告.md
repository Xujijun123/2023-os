# 练习1：分配并初始化一个进程块（需要编码）

# 练习2：为新创建的内核线程分配资源（需要编码）

# 练习3：编写proc_run 函数（需要编码）

```c
void
proc_run(struct proc_struct *proc) {
    if (proc != current) {

        bool intr_flag; //保存当前中断状态
        struct proc_struct *prev = current, *next = proc; //分别表示当前进程和要切换到的进程
        local_intr_save(intr_flag);
        
        current = proc; //切换到目标进程
        lcr3(next->cr3); //修改控制寄存器CR3的值，更新页表，切换到next进程的地址空间
        switch_to(&(prev->context), &(next->context));//执行实际的上下文切换操作。这个函数将保存当前进程的上下文，并加载下一个进程的上下文，实现进程切换
        local_intr_restore(intr_flag); //还原中断状态
    }
}
```

## 问：在本实验的执行过程中，创建且运行了几个内核线程？

创建并运行了两个内核线程

1. 创建第0个内核线程`idleproc`(完成内核中各个子系统的初始化)：

   在初始化内核时，`init.c::kern_init()`函数调用`proc::proc_init`函数，`proc_init`函数创建了一个内核线程。当前的执行上下文（从`kern_init` 启动至今）就可以看成是`uCore`内核（也可看做是内核进程）中的一个内核线程的上下文。为此，`uCore`通过给当前执行的上下文分配一个进程控制块以及对它进行相应初始化，将其打造成第0个内核线程 -- `idleproc`

   1. 初始化进程链表，调用`alloc_proc`通过`kmalloc`函数获得`proc_struct`结构的一块内存块，作为第0个进程控制块，并初始化，但把某些值设为特殊值

      ```c
       proc->state = PROC_UNINIT;  //设置进程为“初始”态
       proc->pid = -1;             //设置进程pid的未初始化值
       proc->cr3 = boot_cr3;       //使用内核页目录表的基址,即设置为在uCore内核页表的起始地址boot_cr3
      ```

   2. `proc_init`函数对`idleproc`内核线程初始化

      ```c
      idleproc->pid = 0; 
      idleproc->state = PROC_RUNNABLE;
      //第二条语句改变了idleproc的状态,可被运行
      idleproc->kstack = (uintptr_t)bootstack;
      //设置所使用内核栈的起始地址，后面的内核栈需要分配
      idleproc->need_resched = 1;
      //把idleproc->need_resched设置为“1”，结合idleproc的执行主体--cpu_idle函数的实现，可以清楚看出如果当前idleproc在执行，则只要此标志为1，马上就调用schedule函数要求调度器切换其他进程执行
      set_proc_name(idleproc, "idle");
      ```

2. 创建第 1 个内核线程 `initproc`

   - 通过调用`kernel_thread`函数创建了一个内核线程`init_main`。`kernel_thread`函数采用了局部变量`tf`来放置保存内核线程的临时中断帧，并把中断帧的指针传递给`do_fork`函数，而`do_fork`函数会调用`copy_thread`函数来在新创建的进程内核栈上专门给进程的中断帧分配一块空间
   - 给中断帧分配完空间后，就需要构造新进程的中断帧，具体过程是：首先给`tf`进行清零初始化，随后设置设置内核线程的参数和函数指针。要特别注意对`tf.status`的赋值过程，其读取`sstatus`寄存器的值，然后根据特定的位操作，设置`SPP`和`SPIE`位，并同时清除`SIE`位，从而实现特权级别切换、保留中断使能状态并禁用中断的操作。

​	在这个实验中，内核线程`init_main`函数只进行了简单的字符串输出，但在后续的实验可以根据线程的功能需求来设计特定的线程

![](./make_qemu)

![](./make_grade)