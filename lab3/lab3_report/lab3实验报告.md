### 练习1：理解基于FIFO的页面替换算法

在下列呈现中为了体现逻辑关系，采取了嵌套方式，在此罗列出所有函数

```c
1.swap_init(void);
2.swapfs_init(void);
3._fifo_init(void);
4._fifo_init_mm(struct mm_struct *mm);
5._fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in);
6.swap_out();
7._fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick);
8.swapfs_write(swap_entry_t entry, struct Page *page);
9.tlb_invalidate(pde_t *pgdir, uintptr_t la);
10.swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result);
11.swapfs_read(swap_entry_t entry, struct Page *page);
12.*get_pte(pde_t *pgdir, uintptr_t la, bool create);
```

1. `swap_init(void):`初始化swap，选择算法

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

2. `mm_create()->swap_init_mm()->init_mm()=&fifo_init_mm()`初始化FIFO算法的mm结构

   ```c
   static int _fifo_init_mm(struct mm_struct *mm)
   {     
        list_init(&pra_list_head);//初始化一个链表，pra_list_head 是链表头
        mm->sm_priv = &pra_list_head; //mm 结构的 sm_priv 字段设置为&pra_list_head，sm_priv 是内存管理结构 mm 的私有字段，用于存储与特定页面置换算法相关的信息
        return 0;
   }
   ```

3. `swap_map_swappable()->map_swappable()=&fifo_map_swappable` 将最近可达的页面放入FIFO队列，表示被访问过

   ```c
   static int _fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
   {
       list_entry_t *head=(list_entry_t*) mm->sm_priv;// 获取链表头指针
       list_entry_t *entry=&(page->pra_page_link);//获取要添加的节点
    
       assert(entry != NULL && head != NULL); //断言，entry和head不为空，避免错误
       //record the page access situlation
       list_add(head, entry);//将最近可达的页面放到链表的末尾
       return 0;
   }
   ```

4. `swap_out()`

   - `swap_out_victim()= &_fifo_swap_out_victim`找到FIFO队列最早被访问的页面，从队列中移除，置换出去

   ```c
   static int _fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
   {
        list_entry_t *head=(list_entry_t*) mm->sm_priv;
            assert(head != NULL);
        assert(in_tick==0);
   
       list_entry_t* entry = list_prev(head);//从队列头（head）取出链表中最早到达的页面（即最早进入队列的页面）的链表项 entry
       if (entry != head) {
           list_del(entry);
           *ptr_page = le2page(entry, pra_page_link);
       } else {
           *ptr_page = NULL; //如果链表为空（即 entry == head），表示没有可以被置换的页面，因此将 *ptr_page 设置为 NULL
       }
       return 0;
   }
   ```

   - `swapfs_write()`将页面数据写入磁盘交换文件
   - `tlb_invalidate()`使TLB失效，确保页表项被更新

5. `swap_in()`将页面数据从磁盘读取到内存中

   - `alloc_page`分配空闲物理页
   - `get_pte()`获取`addr`对应的页表项
   - `swapfs_read()`从磁盘交换文件中读取数据存储到物理页中

### 练习2：深入理解不同分页模式的工作原理
1. `get_pte()` 函数中有两段形式类似的代码，结合sv32，sv39，sv48的异同，解释这两段代码为什么如此相像。
     - 页表结构相似：sv32、sv39和sv48都采用了多级页表结构，页表层级不同，但不同格式下的页表结构相似。第一段代码通过一级页表项（pdep1）查找二级页表项（pdep0），第二段代码通过二级页表项（pdep0）查找三级页表项。
     - 代码逻辑相似：
       - 检查页表项是否存在：两段代码都通过检查页表项的`PTE_V`标志来判断页表项是否存在。如果页表项不存在，需要进行页表项的分配和初始化。
       - 页表项的分配和初始化：两段代码都在页表项不存在时，通过调用`alloc_page()`函数分配一个物理页，并设置页表项的引用计数。然后通过`memset()`函数或类似的方式将物理页清零，创建页表项并写入相应的地址。
2. 目前 `get_pte()` 函数将页表项的查找和页表项的分配合并在一个函数里，你认为这种写法好吗？有没有必要把两个功能拆开？</br>
   - `get_pte()` 函数将查找和分配合并在一个函数中，可以减少代码的复杂性和冗余,并且可以减少函数调用和内存访问的次数，从而提高函数的执行效率和性能。
   - 在某些情况下，可能只需要查找页表项而不需要分配新的页表项，或者只需要分配新的页表项而不需要查找。拆分成两个函数可以提供更大的灵活性和可扩展性。



### 练习3：给未被映射的地址映射上物理页

1. 代码（`do_pgfault（mm/vmm.c）`）

   ```c
   int do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
      …………
       } else {
           /*LAB3 EXERCISE 3: YOUR CODE*/
           if (swap_init_ok) {
               struct Page *page = NULL;
              
               if(swap_in(mm,addr,&page)!=0)//将磁盘上的页面内容加载到内存中，存储在page里，若返回值不为0，意味着换入失败
               {
                   cprintf("swap_in in do_pgfault failed\n");
                   goto failed;
               }
               page_insert(mm->pgdir,page,addr,perm);//将刚刚加载的物理页 page 插入到当前进程的页表 pgdir 中，与虚拟地址 addr 建立映射关系
               swap_map_swappable(mm,addr,page,1);//将页面标记为可交换
               page->pra_vaddr = addr;//将页面结构 page 中的 pra_vaddr 字段设置为虚拟地址 addr，以表示这个页面是由访问异常加载的
           } else {
               cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
               goto failed;
           }
      }
     …………
   }	
   ```

2. 请描述页目录项（Page Directory Entry）和页表项（Page Table Entry）中组成部分对ucore实现页替换算法的潜在用处

   - **PDE：**PDE为ucore管理和维护内存提供了结构上的支持
     - **多级页表管理：**利用多级页表机制，使得4GB的地址空间映射到物理内存上，多级列表帮助ucore管理更大的内存空间
     - **内存隔离：**通过设置PDE，ucore为不同的进程分配不同的页表，也就实现了不同进程数据彼此独立
   - **PTE：**
     - **存在位（Present Bit）**：存在位表示一个虚拟页是否当前存在于物理内存中。在页替换算法中，如果某个虚拟页需要被替换出去，可以通过将存在位设置为0来表示该虚拟页不再存在于内存中。
     - **访问位（Accessed Bit）**：访问位用于记录虚拟页的访问情况。在一些页替换算法中，如Clock算法，访问位用于判断虚拟页的访问情况，有助于识别哪些页面被频繁访问，哪些可以被替换出去。
     - **修改位（Dirty Bit）**：修改位表示虚拟页的内容是否被修改过。在页替换算法中，如果虚拟页被修改过，需要将其写回磁盘或交换空间，以确保数据的一致性。修改位可以帮助算法决定哪些页面需要写回。
     - **页面帧号（Page Frame Number）**：页面帧号字段指示虚拟页对应的物理页框号。在页替换算法中，需要根据这个字段确定哪个物理页被替换出去，以便将新的虚拟页加载到相同的物理页框。
     - **权限位（Protection Bits）**：权限位用于指定虚拟页的读写权限。在某些页替换算法中，需要检查虚拟页的权限，以决定是否可以替换出去。如果虚拟页是只读的，通常不会被替换出去。

3. 如果ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

   - **触发异常**：当程序访问一个虚拟内存地址，而相应的页表项标志位（Present Bit）表示该虚拟页不在物理内存中（存在位为0）时，硬件会触发页访问异常。
   - **保存上下文**：硬件会自动保存当前进程的上下文，包括程序计数器（PC）和其他寄存器的值。
   - **转入异常处理程序**：硬件将控制权传递给操作系统内核的缺页异常处理程序。
   - **处理缺页异常**：缺页异常处理程序会根据虚拟地址和当前进程的页表等信息，确定页面调度策略，选择一个物理页来替换或加载进程所需的虚拟页。
   - **更新页表**：在处理缺页时，操作系统会更新页表，将虚拟页映射到新的物理页框中，以满足进程对虚拟内存的访问需求。
   - **回复上下文**：处理完缺页异常后，硬件会恢复之前保存的进程上下文，继续执行导致缺页异常的指令。

4. 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？

   - Page数据结构通常表示物理页框，每个Page结构对应一个物理页。
   - 页表中的页目录项（Page Directory Entry）和页表项（Page Table Entry）包含了关于虚拟页与物理页的映射信息。
   - 通过这些映射信息，操作系统可以找到虚拟页对应的物理页框，将虚拟地址转化为物理地址，或者反之。




### 练习4：补充完成Clock页替换算法

1. 代码（`mm/swap_clock.c`）

   - `_clock_init_mm(struct mm_struct *mm)`

     ``` c
     _clock_init_mm(struct mm_struct *mm)
     {           
         /*LAB3 EXERCISE 4: YOUR CODE*/ 
          list_init(&pra_list_head);     // 初始化pra_list_head为空链表
          curr_ptr=mm->sm_priv=&pra_list_head;     
         // 初始化当前指针curr_ptr指向pra_list_head，表示当前页面替换位置为链表头
         // 将mm的私有成员指针指向pra_list_head，用于后续的页面替换算法操作
          return 0;
     }
     ```

   - `_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)`

     ```c
     _clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
     {
         list_entry_t *entry=&(page->pra_page_link);
         assert(entry != NULL && curr_ptr != NULL);
           /*LAB3 EXERCISE 4: YOUR CODE*/ 
         list_add(&pra_list_head,entry);    // 将页面page插入到页面链表pra_list_head的末尾
         curr_ptr=list_prev(&pra_list_head);//更新当前页面指针 curr_ptr，指向链表中上一个页面
         page->visited=1;    // 将页面的visited标志置为1，表示该页面已被访问
         
         return 0;
     }
     ```

   - `_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)`

     ```c
     _clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
     {
          list_entry_t *head=(list_entry_t*) mm->sm_priv;
          assert(head != NULL);
          assert(in_tick==0);
          while (1) {
             /*LAB3 EXERCISE 4: YOUR CODE*/ 
             list_entry_t *le=curr_ptr;
             curr_ptr=list_next(curr_ptr);
             if(curr_ptr==head)
             {
                 curr_ptr=list_next(head);
             }//遍历页面链表pra_list_head
             struct Page *page=le2page(le,pra_page_link); // 获取当前页面对应的Page结构指针
             if(page->visited==0)
             {
                 page->visited=1;
                 list_del(&(page->pra_page_link));
                 *ptr_page=page;
                 return 0;
             }   // 如果当前页面未被访问，则将该页面从页面链表中删除，并将该页面指针赋值给ptr_page作为换出页面
             else{
                 page->visited=0;
             }// 如果当前页面已被访问，则将visited标志置为0，表示该页面已被重新访问
         }
         return 0;
     }
     ```

   - `vmm.c/do_pgfault`

     ```c
     extern list_entry_t *curr_ptr;
     cprintf("curr_ptr %p\n", (void*)curr_ptr);//指定格式输出
     ```

2. 设计实现过程

   1. 在`_clock_init_mm`中初始化要使用的空列表，并将当前指针和私有成员指针都指向这个列表头（列表）

   2. 在`_clock_map_swappable`中将页面插入到列表的末尾，并将其设置为已访问，并且更新`curr_ptr`使其指向链表的上一个页面

   3. 在`_clock_swap_out_victim`中循环遍历整个列表，找到未被访问的页面，执行换出操作，如果重新访问，则`visited`置0，循环直到找到符合要求的页面

      ![](./make_grade.jpg)

      ![](./make-qemu.jpg)

3. 比较Clock页替换算法和FIFO算法的不同

   1. **替换策略**：
      - **FIFO算法**：FIFO算法采用最简单的替换策略，即选择最早进入内存的页面进行替换。这是一个非常直观的策略，但它可能导致"Belady's Anomaly"，即在内存容量不足时，增加页面数并不总是减少缺页中断次数。
      - **Clock页替换算法**：Clock算法是一种改进型的FIFO算法，它引入了页面访问位的概念。它不仅考虑了页面的进入时间，还考虑了页面的访问情况。它在选择页面替换时，会检查页面的访问位，如果访问位为0，表示页面很可能未被访问，将其替换出去；如果访问位为1，表示页面被访问过，将其访问位重置为0，然后继续查找下一页。这可以更好地反映页面的使用情况，减少"Belady's Anomaly"的影响。
   2. **数据结构**：
      - **FIFO算法**：FIFO算法通常使用队列数据结构，最早进入内存的页面在队列头部，最后进入内存的页面在队列尾部。
      - **Clock页替换算法**：Clock算法使用页面链表，页面链表按照页面进入内存的顺序排列，并且通过访问位来进行调整。
   3. **实现**：
      - **FIFO算法**：FIFO算法实现非常简单，只需要维护一个队列，并在需要替换页面时，将队列头部的页面替换出去。
      - **Clock页替换算法**：Clock算法的实现相对复杂一些，需要考虑页面的访问位，以及如何在页面链表中找到合适的替换页面。它通常需要两次遍历页面链表：第一次查找未被访问的页面，第二次进行替换。需要额外的数据结构来表示页面的访问位。
   4. **性能**：
      - **FIFO算法**：FIFO算法的性能相对较差，容易受"Belady's Anomaly"的影响，可能导致缺页中断次数剧烈增加。
      - **Clock页替换算法**：Clock算法相对于FIFO算法来说，性能更好，因为它考虑了页面的访问情况，更有可能保留常被访问的页面，减少缺页中断次数。

### 练习5：阅读代码和实现手册，理解页表映射方式相关知识