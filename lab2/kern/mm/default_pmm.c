#include <pmm.h>
#include <list.h>
#include <string.h>
#include <default_pmm.h>

/* In the first fit algorithm, the allocator keeps a list of free blocks (known as the free list) and,
   on receiving a request for memory, scans along the list for the first block that is large enough to
   satisfy the request. If the chosen block is significantly larger than that requested, then it is 
   usually split, and the remainder added to the list as another free block.
   Please see Page 196~198, Section 8.2 of Yan Wei Min's chinese book "Data Structure -- C programming language"
*/
// you should rewrite functions: default_init,default_init_memmap,default_alloc_pages, default_free_pages.
/*
 * Details of FFMA
 * (1) Prepare: In order to implement the First-Fit Mem Alloc (FFMA), we should manage the free mem block use some list.
 *              The struct free_area_t is used for the management of free mem blocks. At first you should
 *              be familiar to the struct list in list.h. struct list is a simple doubly linked list implementation.
 *              You should know howto USE: list_init, list_add(list_add_after), list_add_before, list_del, list_next, list_prev
 *              Another tricky method is to transform a general list struct to a special struct (such as struct page):
 *              you can find some MACRO: le2page (in memlayout.h), (in future labs: le2vma (in vmm.h), le2proc (in proc.h),etc.)
 * (2) default_init: you can reuse the  demo default_init fun to init the free_list and set nr_free to 0.
 *              free_list is used to record the free mem blocks. nr_free is the total number for free mem blocks.
 * (3) default_init_memmap:  CALL GRAPH: kern_init --> pmm_init-->page_init-->init_memmap--> pmm_manager->init_memmap
 *              This fun is used to init a free block (with parameter: addr_base, page_number).
 *              First you should init each page (in memlayout.h) in this free block, include:
 *                  p->flags should be set bit PG_property (means this page is valid. In pmm_init fun (in pmm.c),
 *                  the bit PG_reserved is setted in p->flags)
 *                  if this page  is free and is not the first page of free block, p->property should be set to 0.
 *                  if this page  is free and is the first page of free block, p->property should be set to total num of block.
 *                  p->ref should be 0, because now p is free and no reference.
 *                  We can use p->page_link to link this page to free_list, (such as: list_add_before(&free_list, &(p->page_link)); )
 *              Finally, we should sum the number of free mem block: nr_free+=n
 * (4) default_alloc_pages: search find a first free block (block size >=n) in free list and reszie the free block, return the addr
 *              of malloced block.
 *              (4.1) So you should search freelist like this:
 *                       list_entry_t le = &free_list;
 *                       while((le=list_next(le)) != &free_list) {
 *                       ....
 *                 (4.1.1) In while loop, get the struct page and check the p->property (record the num of free block) >=n?
 *                       struct Page *p = le2page(le, page_link);
 *                       if(p->property >= n){ ...
 *                 (4.1.2) If we find this p, then it' means we find a free block(block size >=n), and the first n pages can be malloced.
 *                     Some flag bits of this page should be setted: PG_reserved =1, PG_property =0
 *                     unlink the pages from free_list
 *                     (4.1.2.1) If (p->property >n), we should re-caluclate number of the the rest of this free block,
 *                           (such as: le2page(le,page_link))->property = p->property - n;)
 *                 (4.1.3)  re-caluclate nr_free (number of the the rest of all free block)
 *                 (4.1.4)  return p
 *               (4.2) If we can not find a free block (block size >=n), then return NULL
 * (5) default_free_pages: relink the pages into  free list, maybe merge small free blocks into big free blocks.
 *               (5.1) according the base addr of withdrawed blocks, search free list, find the correct position
 *                     (from low to high addr), and insert the pages. (may use list_next, le2page, list_add_before)
 *               (5.2) reset the fields of pages, such as p->ref, p->flags (PageProperty)
 *               (5.3) try to merge low addr or high addr blocks. Notice: should change some pages's p->property correctly.
 */
free_area_t free_area;

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)
//结构体 free_area_t 用于管理空闲内存块
static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
//初始化 free_list 并将 nr_free 设置为 0。free_list 用于记录空闲内存块，nr_free 是空闲内存块的总数。
static void
//调用图，kern_init -> pmm_init -> page_init -> init_memmap -> pmm_manager->init_memmap
//用于空闲快的初始化
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;  // 确保页面已被标记为保留（已分配或不可用）
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0; 
        //如果此页面是空闲的且不是空闲块的第一页，则 p->property 应该设置为 0。
        //如果此页面是空闲的且是空闲块的第一页，则 p->property 应该设置为块的总数
        set_page_ref(p, 0); //设置为0，无引用
    }
    base->property = n; //第一页，设为块数n
    SetPageProperty(base);
    nr_free += n;
    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link));// 如果free_list为空,直接将该空闲块添加到free_list
    } else {
        list_entry_t* le = &free_list;// 从free_list头开始遍历
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link);//获取当前页面
            if (base < page) {
                list_add_before(le, &(base->page_link));// 如果基地址小于当前页面的地0址，将该空闲块插入到当前页面之前
                break;
            } else if (list_next(le) == &free_list) {// 如果已经遍历到最后一个页面，// 将该空闲块添加到最后
                list_add(le, &(base->page_link));
            }
        }
    }
}

static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);  // 确保 n 大于 0，否则无效的分配请求
    if (n > nr_free) {
        return NULL;  // 如果需要分配的页面数量大于空闲页面总数，则无法分配，返回 NULL
    }
    struct Page *page = NULL;  // 初始化一个指向分配的页面的指针
    list_entry_t *le = &free_list;  // 从 free_list 的头部开始遍历链表
    while ((le = list_next(le)) != &free_list) {
        // 遍历 free_list 中的每一个页面
        struct Page *p = le2page(le, page_link);
        if (p->property >= n) {
            // 找到第一个拥有足够多页面的空闲块
            page = p;
            break;
        }
    }
    if (page != NULL) {
        list_entry_t* prev = list_prev(&(page->page_link));  // 获取当前页面的前一个页面
        list_del(&(page->page_link));  // 从 free_list 中移除当前页面
        if (page->property > n) {
            // 如果当前页面的空闲页面数量大于所需的页面数量
            struct Page *p = page + n;  // 计算剩余页面的起始位置
            p->property = page->property - n;  // 更新剩余页面的 property 值
            SetPageProperty(p);  // 设置剩余页面的属性
            list_add(prev, &(p->page_link));  // 将剩余页面插入到链表中
        }
        nr_free -= n;  // 减去分配的页面数量，更新空闲页面总数
        ClearPageProperty(page);  // 清除当前页面的属性，表示已被分配
        return page;  // 返回分配的页面
    }
    return NULL;  // 如果没有找到足够多的页面来分配，则返回 NULL
}

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0); // 确保要释放的页面数量大于0

    struct Page *p = base; // 创建指向起始页面的指针
    for (; p != base + n; p++) {
        assert(!PageReserved(p) && !PageProperty(p)); // 确保页面不是保留页面并且不是属性页面
        p->flags = 0; // 清除页面的标志位
        set_page_ref(p, 0); // 将页面引用计数设置为0
    }
    base->property = n; // 设置页面的属性为n
    SetPageProperty(base); // 设置页面的属性标志
    nr_free += n; // 增加可用页面的数量

    if (list_empty(&free_list)) {
        list_add(&free_list, &(base->page_link)); // 如果可用页面链表为空，将当前页面添加到链表中
    } else {
        list_entry_t* le = &free_list;
        while ((le = list_next(le)) != &free_list) {
            struct Page* page = le2page(le, page_link); // 获取链表中的页面
            if (base < page) {
                list_add_before(le, &(base->page_link)); // 如果当前页面应该插入到该页面之前，就插入
                break;
            } else if (list_next(le) == &free_list) {
                list_add(le, &(base->page_link)); // 如果当前页面应该插入到链表末尾，就插入
            }
        }
    }

    list_entry_t* le = list_prev(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);  //base代表要释放的物理页面中的第一个页面。这是一个指向 struct Page 结构的指针
        if (p + p->property == base) { // 如果前一个页面与当前页面相邻
            p->property += base->property; // 合并它们的属性
            ClearPageProperty(base); // 清除当前页面的属性标志
            list_del(&(base->page_link)); // 从可用页面链表中删除当前页面
            base = p; // 更新当前页面为合并后的页面
        }
    }

    le = list_next(&(base->page_link));
    if (le != &free_list) {
        p = le2page(le, page_link);
        if (base + base->property == p) { // 如果当前页面与后一个页面相邻
            base->property += p->property; // 合并它们的属性
            ClearPageProperty(p); // 清除后一个页面的属性标志
            list_del(&(p->page_link)); // 从可用页面链表中删除后一个页面
        }
    }
}


static size_t
default_nr_free_pages(void) {
    return nr_free;
}

static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nr_free == 3);

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(alloc_page() == NULL);

    free_page(p0);
    assert(!list_empty(&free_list));

    struct Page *p;
    assert((p = alloc_page()) == p0);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    free_list = free_list_store;
    nr_free = nr_free_store;

    free_page(p);
    free_page(p1);
    free_page(p2);
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
    assert(p0 != NULL);
    assert(!PageProperty(p0));

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
    assert(alloc_pages(4) == NULL);
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
    assert((p1 = alloc_pages(3)) != NULL);
    assert(alloc_page() == NULL);
    assert(p0 + 2 == p1);

    p2 = p0 + 1;
    free_page(p0);
    free_pages(p1, 3);
    assert(PageProperty(p0) && p0->property == 1);
    assert(PageProperty(p1) && p1->property == 3);

    assert((p0 = alloc_page()) == p2 - 1);
    free_page(p0);
    assert((p0 = alloc_pages(2)) == p2 + 1);

    free_pages(p0, 2);
    free_page(p2);

    assert((p0 = alloc_pages(5)) != NULL);
    assert(alloc_page() == NULL);

    assert(nr_free == 0);
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
    assert(total == 0);
}
//这个结构体在
const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = default_init,
    .init_memmap = default_init_memmap,
    .alloc_pages = default_alloc_pages,
    .free_pages = default_free_pages,
    .nr_free_pages = default_nr_free_pages,
    .check = default_check,
};

