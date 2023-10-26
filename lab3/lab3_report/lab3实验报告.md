### 练习1：理解基于FIFO的页面替换算法

1. `swap_init(void):`

   - `swapfs_init();`初始化交换文件系统

     - ```c
       //kern/fs/swapfs.c
       swapfs_init(void) {
           static_assert((PGSIZE % SECTSIZE) == 0); //静态断言，判断页大小是否能被扇区大小整除
           if (!ide_device_valid(SWAP_DEV_NO)) { //检查交换设备是否有效
               panic("swap fs isn't available.\n");
           }
           max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE); //计算最大偏移量
       }
       ```

   - `sm = &swap_manager_fifo;`选择目的算法

   - `int r = sm->init();`初始化FIFO的内部数据`.init`，主要是判断这个算法是否存在，并被调用

2. 

### 练习2：深入理解不同分页模式的工作原理

### 练习3：给未被映射的地址映射上物理页

### 练习4：补充完成Clock页替换算法

### 练习5：阅读代码和实现手册，理解页表映射方式相关知识