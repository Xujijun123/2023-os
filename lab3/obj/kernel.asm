
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02092b7          	lui	t0,0xc0209
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc0200004:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200008:	01e31313          	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc020000c:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200010:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc0200014:	fff0031b          	addiw	t1,zero,-1
ffffffffc0200018:	03f31313          	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc020001c:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200020:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200024:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc0200028:	c0209137          	lui	sp,0xc0209

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc020002c:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200030:	03628293          	addi	t0,t0,54 # ffffffffc0200036 <kern_init>
    jr t0
ffffffffc0200034:	8282                	jr	t0

ffffffffc0200036 <kern_init>:


int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200036:	0000a517          	auipc	a0,0xa
ffffffffc020003a:	00a50513          	addi	a0,a0,10 # ffffffffc020a040 <edata>
ffffffffc020003e:	00011617          	auipc	a2,0x11
ffffffffc0200042:	56260613          	addi	a2,a2,1378 # ffffffffc02115a0 <end>
kern_init(void) {
ffffffffc0200046:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200048:	8e09                	sub	a2,a2,a0
ffffffffc020004a:	4581                	li	a1,0
kern_init(void) {
ffffffffc020004c:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004e:	5c1030ef          	jal	ra,ffffffffc0203e0e <memset>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200052:	00004597          	auipc	a1,0x4
ffffffffc0200056:	29e58593          	addi	a1,a1,670 # ffffffffc02042f0 <etext+0x2>
ffffffffc020005a:	00004517          	auipc	a0,0x4
ffffffffc020005e:	2b650513          	addi	a0,a0,694 # ffffffffc0204310 <etext+0x22>
ffffffffc0200062:	05c000ef          	jal	ra,ffffffffc02000be <cprintf>

    print_kerninfo();
ffffffffc0200066:	100000ef          	jal	ra,ffffffffc0200166 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc020006a:	73b000ef          	jal	ra,ffffffffc0200fa4 <pmm_init>

    idt_init();                 // init interrupt descriptor table
ffffffffc020006e:	504000ef          	jal	ra,ffffffffc0200572 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc0200072:	609010ef          	jal	ra,ffffffffc0201e7a <vmm_init>

    ide_init();                 // init ide devices
ffffffffc0200076:	35e000ef          	jal	ra,ffffffffc02003d4 <ide_init>
    swap_init();                // init swap
ffffffffc020007a:	440020ef          	jal	ra,ffffffffc02024ba <swap_init>

    clock_init();               // init clock interrupt
ffffffffc020007e:	3ae000ef          	jal	ra,ffffffffc020042c <clock_init>
    // intr_enable();              // enable irq interrupt



    /* do nothing */
    while (1);
ffffffffc0200082:	a001                	j	ffffffffc0200082 <kern_init+0x4c>

ffffffffc0200084 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200084:	1141                	addi	sp,sp,-16
ffffffffc0200086:	e022                	sd	s0,0(sp)
ffffffffc0200088:	e406                	sd	ra,8(sp)
ffffffffc020008a:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020008c:	3f6000ef          	jal	ra,ffffffffc0200482 <cons_putc>
    (*cnt) ++;
ffffffffc0200090:	401c                	lw	a5,0(s0)
}
ffffffffc0200092:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200094:	2785                	addiw	a5,a5,1
ffffffffc0200096:	c01c                	sw	a5,0(s0)
}
ffffffffc0200098:	6402                	ld	s0,0(sp)
ffffffffc020009a:	0141                	addi	sp,sp,16
ffffffffc020009c:	8082                	ret

ffffffffc020009e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc020009e:	1101                	addi	sp,sp,-32
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a0:	86ae                	mv	a3,a1
ffffffffc02000a2:	862a                	mv	a2,a0
ffffffffc02000a4:	006c                	addi	a1,sp,12
ffffffffc02000a6:	00000517          	auipc	a0,0x0
ffffffffc02000aa:	fde50513          	addi	a0,a0,-34 # ffffffffc0200084 <cputch>
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000ae:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000b0:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000b2:	5f3030ef          	jal	ra,ffffffffc0203ea4 <vprintfmt>
    return cnt;
}
ffffffffc02000b6:	60e2                	ld	ra,24(sp)
ffffffffc02000b8:	4532                	lw	a0,12(sp)
ffffffffc02000ba:	6105                	addi	sp,sp,32
ffffffffc02000bc:	8082                	ret

ffffffffc02000be <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000be:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000c0:	02810313          	addi	t1,sp,40 # ffffffffc0209028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000c4:	f42e                	sd	a1,40(sp)
ffffffffc02000c6:	f832                	sd	a2,48(sp)
ffffffffc02000c8:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ca:	862a                	mv	a2,a0
ffffffffc02000cc:	004c                	addi	a1,sp,4
ffffffffc02000ce:	00000517          	auipc	a0,0x0
ffffffffc02000d2:	fb650513          	addi	a0,a0,-74 # ffffffffc0200084 <cputch>
ffffffffc02000d6:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc02000d8:	ec06                	sd	ra,24(sp)
ffffffffc02000da:	e0ba                	sd	a4,64(sp)
ffffffffc02000dc:	e4be                	sd	a5,72(sp)
ffffffffc02000de:	e8c2                	sd	a6,80(sp)
ffffffffc02000e0:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000e2:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000e4:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e6:	5bf030ef          	jal	ra,ffffffffc0203ea4 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000ea:	60e2                	ld	ra,24(sp)
ffffffffc02000ec:	4512                	lw	a0,4(sp)
ffffffffc02000ee:	6125                	addi	sp,sp,96
ffffffffc02000f0:	8082                	ret

ffffffffc02000f2 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000f2:	3900006f          	j	ffffffffc0200482 <cons_putc>

ffffffffc02000f6 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc02000f6:	1141                	addi	sp,sp,-16
ffffffffc02000f8:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02000fa:	3be000ef          	jal	ra,ffffffffc02004b8 <cons_getc>
ffffffffc02000fe:	dd75                	beqz	a0,ffffffffc02000fa <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200100:	60a2                	ld	ra,8(sp)
ffffffffc0200102:	0141                	addi	sp,sp,16
ffffffffc0200104:	8082                	ret

ffffffffc0200106 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200106:	00011317          	auipc	t1,0x11
ffffffffc020010a:	33a30313          	addi	t1,t1,826 # ffffffffc0211440 <is_panic>
ffffffffc020010e:	00032303          	lw	t1,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200112:	715d                	addi	sp,sp,-80
ffffffffc0200114:	ec06                	sd	ra,24(sp)
ffffffffc0200116:	e822                	sd	s0,16(sp)
ffffffffc0200118:	f436                	sd	a3,40(sp)
ffffffffc020011a:	f83a                	sd	a4,48(sp)
ffffffffc020011c:	fc3e                	sd	a5,56(sp)
ffffffffc020011e:	e0c2                	sd	a6,64(sp)
ffffffffc0200120:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200122:	02031c63          	bnez	t1,ffffffffc020015a <__panic+0x54>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200126:	4785                	li	a5,1
ffffffffc0200128:	8432                	mv	s0,a2
ffffffffc020012a:	00011717          	auipc	a4,0x11
ffffffffc020012e:	30f72b23          	sw	a5,790(a4) # ffffffffc0211440 <is_panic>

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200132:	862e                	mv	a2,a1
    va_start(ap, fmt);
ffffffffc0200134:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200136:	85aa                	mv	a1,a0
ffffffffc0200138:	00004517          	auipc	a0,0x4
ffffffffc020013c:	1e050513          	addi	a0,a0,480 # ffffffffc0204318 <etext+0x2a>
    va_start(ap, fmt);
ffffffffc0200140:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200142:	f7dff0ef          	jal	ra,ffffffffc02000be <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200146:	65a2                	ld	a1,8(sp)
ffffffffc0200148:	8522                	mv	a0,s0
ffffffffc020014a:	f55ff0ef          	jal	ra,ffffffffc020009e <vcprintf>
    cprintf("\n");
ffffffffc020014e:	00005517          	auipc	a0,0x5
ffffffffc0200152:	fda50513          	addi	a0,a0,-38 # ffffffffc0205128 <commands+0xcf0>
ffffffffc0200156:	f69ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020015a:	3a0000ef          	jal	ra,ffffffffc02004fa <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020015e:	4501                	li	a0,0
ffffffffc0200160:	132000ef          	jal	ra,ffffffffc0200292 <kmonitor>
ffffffffc0200164:	bfed                	j	ffffffffc020015e <__panic+0x58>

ffffffffc0200166 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200166:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200168:	00004517          	auipc	a0,0x4
ffffffffc020016c:	20050513          	addi	a0,a0,512 # ffffffffc0204368 <etext+0x7a>
void print_kerninfo(void) {
ffffffffc0200170:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200172:	f4dff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200176:	00000597          	auipc	a1,0x0
ffffffffc020017a:	ec058593          	addi	a1,a1,-320 # ffffffffc0200036 <kern_init>
ffffffffc020017e:	00004517          	auipc	a0,0x4
ffffffffc0200182:	20a50513          	addi	a0,a0,522 # ffffffffc0204388 <etext+0x9a>
ffffffffc0200186:	f39ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020018a:	00004597          	auipc	a1,0x4
ffffffffc020018e:	16458593          	addi	a1,a1,356 # ffffffffc02042ee <etext>
ffffffffc0200192:	00004517          	auipc	a0,0x4
ffffffffc0200196:	21650513          	addi	a0,a0,534 # ffffffffc02043a8 <etext+0xba>
ffffffffc020019a:	f25ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020019e:	0000a597          	auipc	a1,0xa
ffffffffc02001a2:	ea258593          	addi	a1,a1,-350 # ffffffffc020a040 <edata>
ffffffffc02001a6:	00004517          	auipc	a0,0x4
ffffffffc02001aa:	22250513          	addi	a0,a0,546 # ffffffffc02043c8 <etext+0xda>
ffffffffc02001ae:	f11ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc02001b2:	00011597          	auipc	a1,0x11
ffffffffc02001b6:	3ee58593          	addi	a1,a1,1006 # ffffffffc02115a0 <end>
ffffffffc02001ba:	00004517          	auipc	a0,0x4
ffffffffc02001be:	22e50513          	addi	a0,a0,558 # ffffffffc02043e8 <etext+0xfa>
ffffffffc02001c2:	efdff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001c6:	00011597          	auipc	a1,0x11
ffffffffc02001ca:	7d958593          	addi	a1,a1,2009 # ffffffffc021199f <end+0x3ff>
ffffffffc02001ce:	00000797          	auipc	a5,0x0
ffffffffc02001d2:	e6878793          	addi	a5,a5,-408 # ffffffffc0200036 <kern_init>
ffffffffc02001d6:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001da:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001de:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001e0:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001e4:	95be                	add	a1,a1,a5
ffffffffc02001e6:	85a9                	srai	a1,a1,0xa
ffffffffc02001e8:	00004517          	auipc	a0,0x4
ffffffffc02001ec:	22050513          	addi	a0,a0,544 # ffffffffc0204408 <etext+0x11a>
}
ffffffffc02001f0:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001f2:	ecdff06f          	j	ffffffffc02000be <cprintf>

ffffffffc02001f6 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001f6:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc02001f8:	00004617          	auipc	a2,0x4
ffffffffc02001fc:	14060613          	addi	a2,a2,320 # ffffffffc0204338 <etext+0x4a>
ffffffffc0200200:	04e00593          	li	a1,78
ffffffffc0200204:	00004517          	auipc	a0,0x4
ffffffffc0200208:	14c50513          	addi	a0,a0,332 # ffffffffc0204350 <etext+0x62>
void print_stackframe(void) {
ffffffffc020020c:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020020e:	ef9ff0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0200212 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200212:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200214:	00004617          	auipc	a2,0x4
ffffffffc0200218:	2fc60613          	addi	a2,a2,764 # ffffffffc0204510 <commands+0xd8>
ffffffffc020021c:	00004597          	auipc	a1,0x4
ffffffffc0200220:	31458593          	addi	a1,a1,788 # ffffffffc0204530 <commands+0xf8>
ffffffffc0200224:	00004517          	auipc	a0,0x4
ffffffffc0200228:	31450513          	addi	a0,a0,788 # ffffffffc0204538 <commands+0x100>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020022c:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020022e:	e91ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0200232:	00004617          	auipc	a2,0x4
ffffffffc0200236:	31660613          	addi	a2,a2,790 # ffffffffc0204548 <commands+0x110>
ffffffffc020023a:	00004597          	auipc	a1,0x4
ffffffffc020023e:	33658593          	addi	a1,a1,822 # ffffffffc0204570 <commands+0x138>
ffffffffc0200242:	00004517          	auipc	a0,0x4
ffffffffc0200246:	2f650513          	addi	a0,a0,758 # ffffffffc0204538 <commands+0x100>
ffffffffc020024a:	e75ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc020024e:	00004617          	auipc	a2,0x4
ffffffffc0200252:	33260613          	addi	a2,a2,818 # ffffffffc0204580 <commands+0x148>
ffffffffc0200256:	00004597          	auipc	a1,0x4
ffffffffc020025a:	34a58593          	addi	a1,a1,842 # ffffffffc02045a0 <commands+0x168>
ffffffffc020025e:	00004517          	auipc	a0,0x4
ffffffffc0200262:	2da50513          	addi	a0,a0,730 # ffffffffc0204538 <commands+0x100>
ffffffffc0200266:	e59ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    }
    return 0;
}
ffffffffc020026a:	60a2                	ld	ra,8(sp)
ffffffffc020026c:	4501                	li	a0,0
ffffffffc020026e:	0141                	addi	sp,sp,16
ffffffffc0200270:	8082                	ret

ffffffffc0200272 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200272:	1141                	addi	sp,sp,-16
ffffffffc0200274:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200276:	ef1ff0ef          	jal	ra,ffffffffc0200166 <print_kerninfo>
    return 0;
}
ffffffffc020027a:	60a2                	ld	ra,8(sp)
ffffffffc020027c:	4501                	li	a0,0
ffffffffc020027e:	0141                	addi	sp,sp,16
ffffffffc0200280:	8082                	ret

ffffffffc0200282 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200282:	1141                	addi	sp,sp,-16
ffffffffc0200284:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200286:	f71ff0ef          	jal	ra,ffffffffc02001f6 <print_stackframe>
    return 0;
}
ffffffffc020028a:	60a2                	ld	ra,8(sp)
ffffffffc020028c:	4501                	li	a0,0
ffffffffc020028e:	0141                	addi	sp,sp,16
ffffffffc0200290:	8082                	ret

ffffffffc0200292 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200292:	7115                	addi	sp,sp,-224
ffffffffc0200294:	e962                	sd	s8,144(sp)
ffffffffc0200296:	8c2a                	mv	s8,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200298:	00004517          	auipc	a0,0x4
ffffffffc020029c:	1e850513          	addi	a0,a0,488 # ffffffffc0204480 <commands+0x48>
kmonitor(struct trapframe *tf) {
ffffffffc02002a0:	ed86                	sd	ra,216(sp)
ffffffffc02002a2:	e9a2                	sd	s0,208(sp)
ffffffffc02002a4:	e5a6                	sd	s1,200(sp)
ffffffffc02002a6:	e1ca                	sd	s2,192(sp)
ffffffffc02002a8:	fd4e                	sd	s3,184(sp)
ffffffffc02002aa:	f952                	sd	s4,176(sp)
ffffffffc02002ac:	f556                	sd	s5,168(sp)
ffffffffc02002ae:	f15a                	sd	s6,160(sp)
ffffffffc02002b0:	ed5e                	sd	s7,152(sp)
ffffffffc02002b2:	e566                	sd	s9,136(sp)
ffffffffc02002b4:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002b6:	e09ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002ba:	00004517          	auipc	a0,0x4
ffffffffc02002be:	1ee50513          	addi	a0,a0,494 # ffffffffc02044a8 <commands+0x70>
ffffffffc02002c2:	dfdff0ef          	jal	ra,ffffffffc02000be <cprintf>
    if (tf != NULL) {
ffffffffc02002c6:	000c0563          	beqz	s8,ffffffffc02002d0 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002ca:	8562                	mv	a0,s8
ffffffffc02002cc:	492000ef          	jal	ra,ffffffffc020075e <print_trapframe>
ffffffffc02002d0:	00004c97          	auipc	s9,0x4
ffffffffc02002d4:	168c8c93          	addi	s9,s9,360 # ffffffffc0204438 <commands>
        if ((buf = readline("")) != NULL) {
ffffffffc02002d8:	00005997          	auipc	s3,0x5
ffffffffc02002dc:	68098993          	addi	s3,s3,1664 # ffffffffc0205958 <commands+0x1520>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002e0:	00004917          	auipc	s2,0x4
ffffffffc02002e4:	1f090913          	addi	s2,s2,496 # ffffffffc02044d0 <commands+0x98>
        if (argc == MAXARGS - 1) {
ffffffffc02002e8:	4a3d                	li	s4,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002ea:	00004b17          	auipc	s6,0x4
ffffffffc02002ee:	1eeb0b13          	addi	s6,s6,494 # ffffffffc02044d8 <commands+0xa0>
    if (argc == 0) {
ffffffffc02002f2:	00004a97          	auipc	s5,0x4
ffffffffc02002f6:	23ea8a93          	addi	s5,s5,574 # ffffffffc0204530 <commands+0xf8>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002fa:	4b8d                	li	s7,3
        if ((buf = readline("")) != NULL) {
ffffffffc02002fc:	854e                	mv	a0,s3
ffffffffc02002fe:	733030ef          	jal	ra,ffffffffc0204230 <readline>
ffffffffc0200302:	842a                	mv	s0,a0
ffffffffc0200304:	dd65                	beqz	a0,ffffffffc02002fc <kmonitor+0x6a>
ffffffffc0200306:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020030a:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020030c:	c999                	beqz	a1,ffffffffc0200322 <kmonitor+0x90>
ffffffffc020030e:	854a                	mv	a0,s2
ffffffffc0200310:	2e1030ef          	jal	ra,ffffffffc0203df0 <strchr>
ffffffffc0200314:	c925                	beqz	a0,ffffffffc0200384 <kmonitor+0xf2>
            *buf ++ = '\0';
ffffffffc0200316:	00144583          	lbu	a1,1(s0)
ffffffffc020031a:	00040023          	sb	zero,0(s0)
ffffffffc020031e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200320:	f5fd                	bnez	a1,ffffffffc020030e <kmonitor+0x7c>
    if (argc == 0) {
ffffffffc0200322:	dce9                	beqz	s1,ffffffffc02002fc <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200324:	6582                	ld	a1,0(sp)
ffffffffc0200326:	00004d17          	auipc	s10,0x4
ffffffffc020032a:	112d0d13          	addi	s10,s10,274 # ffffffffc0204438 <commands>
    if (argc == 0) {
ffffffffc020032e:	8556                	mv	a0,s5
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200330:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200332:	0d61                	addi	s10,s10,24
ffffffffc0200334:	293030ef          	jal	ra,ffffffffc0203dc6 <strcmp>
ffffffffc0200338:	c919                	beqz	a0,ffffffffc020034e <kmonitor+0xbc>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020033a:	2405                	addiw	s0,s0,1
ffffffffc020033c:	09740463          	beq	s0,s7,ffffffffc02003c4 <kmonitor+0x132>
ffffffffc0200340:	000d3503          	ld	a0,0(s10)
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200344:	6582                	ld	a1,0(sp)
ffffffffc0200346:	0d61                	addi	s10,s10,24
ffffffffc0200348:	27f030ef          	jal	ra,ffffffffc0203dc6 <strcmp>
ffffffffc020034c:	f57d                	bnez	a0,ffffffffc020033a <kmonitor+0xa8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020034e:	00141793          	slli	a5,s0,0x1
ffffffffc0200352:	97a2                	add	a5,a5,s0
ffffffffc0200354:	078e                	slli	a5,a5,0x3
ffffffffc0200356:	97e6                	add	a5,a5,s9
ffffffffc0200358:	6b9c                	ld	a5,16(a5)
ffffffffc020035a:	8662                	mv	a2,s8
ffffffffc020035c:	002c                	addi	a1,sp,8
ffffffffc020035e:	fff4851b          	addiw	a0,s1,-1
ffffffffc0200362:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200364:	f8055ce3          	bgez	a0,ffffffffc02002fc <kmonitor+0x6a>
}
ffffffffc0200368:	60ee                	ld	ra,216(sp)
ffffffffc020036a:	644e                	ld	s0,208(sp)
ffffffffc020036c:	64ae                	ld	s1,200(sp)
ffffffffc020036e:	690e                	ld	s2,192(sp)
ffffffffc0200370:	79ea                	ld	s3,184(sp)
ffffffffc0200372:	7a4a                	ld	s4,176(sp)
ffffffffc0200374:	7aaa                	ld	s5,168(sp)
ffffffffc0200376:	7b0a                	ld	s6,160(sp)
ffffffffc0200378:	6bea                	ld	s7,152(sp)
ffffffffc020037a:	6c4a                	ld	s8,144(sp)
ffffffffc020037c:	6caa                	ld	s9,136(sp)
ffffffffc020037e:	6d0a                	ld	s10,128(sp)
ffffffffc0200380:	612d                	addi	sp,sp,224
ffffffffc0200382:	8082                	ret
        if (*buf == '\0') {
ffffffffc0200384:	00044783          	lbu	a5,0(s0)
ffffffffc0200388:	dfc9                	beqz	a5,ffffffffc0200322 <kmonitor+0x90>
        if (argc == MAXARGS - 1) {
ffffffffc020038a:	03448863          	beq	s1,s4,ffffffffc02003ba <kmonitor+0x128>
        argv[argc ++] = buf;
ffffffffc020038e:	00349793          	slli	a5,s1,0x3
ffffffffc0200392:	0118                	addi	a4,sp,128
ffffffffc0200394:	97ba                	add	a5,a5,a4
ffffffffc0200396:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020039a:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020039e:	2485                	addiw	s1,s1,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a0:	e591                	bnez	a1,ffffffffc02003ac <kmonitor+0x11a>
ffffffffc02003a2:	b749                	j	ffffffffc0200324 <kmonitor+0x92>
            buf ++;
ffffffffc02003a4:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a6:	00044583          	lbu	a1,0(s0)
ffffffffc02003aa:	ddad                	beqz	a1,ffffffffc0200324 <kmonitor+0x92>
ffffffffc02003ac:	854a                	mv	a0,s2
ffffffffc02003ae:	243030ef          	jal	ra,ffffffffc0203df0 <strchr>
ffffffffc02003b2:	d96d                	beqz	a0,ffffffffc02003a4 <kmonitor+0x112>
ffffffffc02003b4:	00044583          	lbu	a1,0(s0)
ffffffffc02003b8:	bf91                	j	ffffffffc020030c <kmonitor+0x7a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ba:	45c1                	li	a1,16
ffffffffc02003bc:	855a                	mv	a0,s6
ffffffffc02003be:	d01ff0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc02003c2:	b7f1                	j	ffffffffc020038e <kmonitor+0xfc>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003c4:	6582                	ld	a1,0(sp)
ffffffffc02003c6:	00004517          	auipc	a0,0x4
ffffffffc02003ca:	13250513          	addi	a0,a0,306 # ffffffffc02044f8 <commands+0xc0>
ffffffffc02003ce:	cf1ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    return 0;
ffffffffc02003d2:	b72d                	j	ffffffffc02002fc <kmonitor+0x6a>

ffffffffc02003d4 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02003d4:	8082                	ret

ffffffffc02003d6 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02003d6:	00253513          	sltiu	a0,a0,2
ffffffffc02003da:	8082                	ret

ffffffffc02003dc <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02003dc:	03800513          	li	a0,56
ffffffffc02003e0:	8082                	ret

ffffffffc02003e2 <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003e2:	0000a797          	auipc	a5,0xa
ffffffffc02003e6:	c5e78793          	addi	a5,a5,-930 # ffffffffc020a040 <edata>
ffffffffc02003ea:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02003ee:	1141                	addi	sp,sp,-16
ffffffffc02003f0:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003f2:	95be                	add	a1,a1,a5
ffffffffc02003f4:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc02003f8:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02003fa:	227030ef          	jal	ra,ffffffffc0203e20 <memcpy>
    return 0;
}
ffffffffc02003fe:	60a2                	ld	ra,8(sp)
ffffffffc0200400:	4501                	li	a0,0
ffffffffc0200402:	0141                	addi	sp,sp,16
ffffffffc0200404:	8082                	ret

ffffffffc0200406 <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
ffffffffc0200406:	8732                	mv	a4,a2
    int iobase = secno * SECTSIZE;
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200408:	0095979b          	slliw	a5,a1,0x9
ffffffffc020040c:	0000a517          	auipc	a0,0xa
ffffffffc0200410:	c3450513          	addi	a0,a0,-972 # ffffffffc020a040 <edata>
                   size_t nsecs) {
ffffffffc0200414:	1141                	addi	sp,sp,-16
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200416:	00969613          	slli	a2,a3,0x9
ffffffffc020041a:	85ba                	mv	a1,a4
ffffffffc020041c:	953e                	add	a0,a0,a5
                   size_t nsecs) {
ffffffffc020041e:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200420:	201030ef          	jal	ra,ffffffffc0203e20 <memcpy>
    return 0;
}
ffffffffc0200424:	60a2                	ld	ra,8(sp)
ffffffffc0200426:	4501                	li	a0,0
ffffffffc0200428:	0141                	addi	sp,sp,16
ffffffffc020042a:	8082                	ret

ffffffffc020042c <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020042c:	67e1                	lui	a5,0x18
ffffffffc020042e:	6a078793          	addi	a5,a5,1696 # 186a0 <BASE_ADDRESS-0xffffffffc01e7960>
ffffffffc0200432:	00011717          	auipc	a4,0x11
ffffffffc0200436:	00f73b23          	sd	a5,22(a4) # ffffffffc0211448 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020043a:	c0102573          	rdtime	a0
static inline void sbi_set_timer(uint64_t stime_value)
{
#if __riscv_xlen == 32
	SBI_CALL_2(SBI_SET_TIMER, stime_value, stime_value >> 32);
#else
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020043e:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200440:	953e                	add	a0,a0,a5
ffffffffc0200442:	4601                	li	a2,0
ffffffffc0200444:	4881                	li	a7,0
ffffffffc0200446:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc020044a:	02000793          	li	a5,32
ffffffffc020044e:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200452:	00004517          	auipc	a0,0x4
ffffffffc0200456:	15e50513          	addi	a0,a0,350 # ffffffffc02045b0 <commands+0x178>
    ticks = 0;
ffffffffc020045a:	00011797          	auipc	a5,0x11
ffffffffc020045e:	0007bf23          	sd	zero,30(a5) # ffffffffc0211478 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200462:	c5dff06f          	j	ffffffffc02000be <cprintf>

ffffffffc0200466 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200466:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020046a:	00011797          	auipc	a5,0x11
ffffffffc020046e:	fde78793          	addi	a5,a5,-34 # ffffffffc0211448 <timebase>
ffffffffc0200472:	639c                	ld	a5,0(a5)
ffffffffc0200474:	4581                	li	a1,0
ffffffffc0200476:	4601                	li	a2,0
ffffffffc0200478:	953e                	add	a0,a0,a5
ffffffffc020047a:	4881                	li	a7,0
ffffffffc020047c:	00000073          	ecall
ffffffffc0200480:	8082                	ret

ffffffffc0200482 <cons_putc>:
#include <intr.h>
#include <mmu.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200482:	100027f3          	csrr	a5,sstatus
ffffffffc0200486:	8b89                	andi	a5,a5,2
ffffffffc0200488:	0ff57513          	andi	a0,a0,255
ffffffffc020048c:	e799                	bnez	a5,ffffffffc020049a <cons_putc+0x18>
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020048e:	4581                	li	a1,0
ffffffffc0200490:	4601                	li	a2,0
ffffffffc0200492:	4885                	li	a7,1
ffffffffc0200494:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200498:	8082                	ret

/* cons_init - initializes the console devices */
void cons_init(void) {}

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc020049a:	1101                	addi	sp,sp,-32
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02004a0:	05a000ef          	jal	ra,ffffffffc02004fa <intr_disable>
ffffffffc02004a4:	6522                	ld	a0,8(sp)
ffffffffc02004a6:	4581                	li	a1,0
ffffffffc02004a8:	4601                	li	a2,0
ffffffffc02004aa:	4885                	li	a7,1
ffffffffc02004ac:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02004b0:	60e2                	ld	ra,24(sp)
ffffffffc02004b2:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02004b4:	0400006f          	j	ffffffffc02004f4 <intr_enable>

ffffffffc02004b8 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02004b8:	100027f3          	csrr	a5,sstatus
ffffffffc02004bc:	8b89                	andi	a5,a5,2
ffffffffc02004be:	eb89                	bnez	a5,ffffffffc02004d0 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02004c0:	4501                	li	a0,0
ffffffffc02004c2:	4581                	li	a1,0
ffffffffc02004c4:	4601                	li	a2,0
ffffffffc02004c6:	4889                	li	a7,2
ffffffffc02004c8:	00000073          	ecall
ffffffffc02004cc:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02004ce:	8082                	ret
int cons_getc(void) {
ffffffffc02004d0:	1101                	addi	sp,sp,-32
ffffffffc02004d2:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02004d4:	026000ef          	jal	ra,ffffffffc02004fa <intr_disable>
ffffffffc02004d8:	4501                	li	a0,0
ffffffffc02004da:	4581                	li	a1,0
ffffffffc02004dc:	4601                	li	a2,0
ffffffffc02004de:	4889                	li	a7,2
ffffffffc02004e0:	00000073          	ecall
ffffffffc02004e4:	2501                	sext.w	a0,a0
ffffffffc02004e6:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02004e8:	00c000ef          	jal	ra,ffffffffc02004f4 <intr_enable>
}
ffffffffc02004ec:	60e2                	ld	ra,24(sp)
ffffffffc02004ee:	6522                	ld	a0,8(sp)
ffffffffc02004f0:	6105                	addi	sp,sp,32
ffffffffc02004f2:	8082                	ret

ffffffffc02004f4 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004f4:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02004f8:	8082                	ret

ffffffffc02004fa <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02004fa:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02004fe:	8082                	ret

ffffffffc0200500 <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200500:	10053783          	ld	a5,256(a0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc0200504:	1141                	addi	sp,sp,-16
ffffffffc0200506:	e022                	sd	s0,0(sp)
ffffffffc0200508:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020050a:	1007f793          	andi	a5,a5,256
static int pgfault_handler(struct trapframe *tf) {
ffffffffc020050e:	842a                	mv	s0,a0
    cprintf("page fault at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc0200510:	11053583          	ld	a1,272(a0)
ffffffffc0200514:	05500613          	li	a2,85
ffffffffc0200518:	c399                	beqz	a5,ffffffffc020051e <pgfault_handler+0x1e>
ffffffffc020051a:	04b00613          	li	a2,75
ffffffffc020051e:	11843703          	ld	a4,280(s0)
ffffffffc0200522:	47bd                	li	a5,15
ffffffffc0200524:	05700693          	li	a3,87
ffffffffc0200528:	00f70463          	beq	a4,a5,ffffffffc0200530 <pgfault_handler+0x30>
ffffffffc020052c:	05200693          	li	a3,82
ffffffffc0200530:	00004517          	auipc	a0,0x4
ffffffffc0200534:	37850513          	addi	a0,a0,888 # ffffffffc02048a8 <commands+0x470>
ffffffffc0200538:	b87ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc020053c:	00011797          	auipc	a5,0x11
ffffffffc0200540:	f7478793          	addi	a5,a5,-140 # ffffffffc02114b0 <check_mm_struct>
ffffffffc0200544:	6388                	ld	a0,0(a5)
ffffffffc0200546:	c911                	beqz	a0,ffffffffc020055a <pgfault_handler+0x5a>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200548:	11043603          	ld	a2,272(s0)
ffffffffc020054c:	11843583          	ld	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc0200550:	6402                	ld	s0,0(sp)
ffffffffc0200552:	60a2                	ld	ra,8(sp)
ffffffffc0200554:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200556:	6630106f          	j	ffffffffc02023b8 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc020055a:	00004617          	auipc	a2,0x4
ffffffffc020055e:	36e60613          	addi	a2,a2,878 # ffffffffc02048c8 <commands+0x490>
ffffffffc0200562:	07800593          	li	a1,120
ffffffffc0200566:	00004517          	auipc	a0,0x4
ffffffffc020056a:	37a50513          	addi	a0,a0,890 # ffffffffc02048e0 <commands+0x4a8>
ffffffffc020056e:	b99ff0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0200572 <idt_init>:
    write_csr(sscratch, 0);
ffffffffc0200572:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc0200576:	00000797          	auipc	a5,0x0
ffffffffc020057a:	49a78793          	addi	a5,a5,1178 # ffffffffc0200a10 <__alltraps>
ffffffffc020057e:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SIE);
ffffffffc0200582:	100167f3          	csrrsi	a5,sstatus,2
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200586:	000407b7          	lui	a5,0x40
ffffffffc020058a:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020058e:	8082                	ret

ffffffffc0200590 <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200590:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200592:	1141                	addi	sp,sp,-16
ffffffffc0200594:	e022                	sd	s0,0(sp)
ffffffffc0200596:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200598:	00004517          	auipc	a0,0x4
ffffffffc020059c:	36050513          	addi	a0,a0,864 # ffffffffc02048f8 <commands+0x4c0>
void print_regs(struct pushregs *gpr) {
ffffffffc02005a0:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02005a2:	b1dff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02005a6:	640c                	ld	a1,8(s0)
ffffffffc02005a8:	00004517          	auipc	a0,0x4
ffffffffc02005ac:	36850513          	addi	a0,a0,872 # ffffffffc0204910 <commands+0x4d8>
ffffffffc02005b0:	b0fff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02005b4:	680c                	ld	a1,16(s0)
ffffffffc02005b6:	00004517          	auipc	a0,0x4
ffffffffc02005ba:	37250513          	addi	a0,a0,882 # ffffffffc0204928 <commands+0x4f0>
ffffffffc02005be:	b01ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02005c2:	6c0c                	ld	a1,24(s0)
ffffffffc02005c4:	00004517          	auipc	a0,0x4
ffffffffc02005c8:	37c50513          	addi	a0,a0,892 # ffffffffc0204940 <commands+0x508>
ffffffffc02005cc:	af3ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02005d0:	700c                	ld	a1,32(s0)
ffffffffc02005d2:	00004517          	auipc	a0,0x4
ffffffffc02005d6:	38650513          	addi	a0,a0,902 # ffffffffc0204958 <commands+0x520>
ffffffffc02005da:	ae5ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02005de:	740c                	ld	a1,40(s0)
ffffffffc02005e0:	00004517          	auipc	a0,0x4
ffffffffc02005e4:	39050513          	addi	a0,a0,912 # ffffffffc0204970 <commands+0x538>
ffffffffc02005e8:	ad7ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02005ec:	780c                	ld	a1,48(s0)
ffffffffc02005ee:	00004517          	auipc	a0,0x4
ffffffffc02005f2:	39a50513          	addi	a0,a0,922 # ffffffffc0204988 <commands+0x550>
ffffffffc02005f6:	ac9ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02005fa:	7c0c                	ld	a1,56(s0)
ffffffffc02005fc:	00004517          	auipc	a0,0x4
ffffffffc0200600:	3a450513          	addi	a0,a0,932 # ffffffffc02049a0 <commands+0x568>
ffffffffc0200604:	abbff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200608:	602c                	ld	a1,64(s0)
ffffffffc020060a:	00004517          	auipc	a0,0x4
ffffffffc020060e:	3ae50513          	addi	a0,a0,942 # ffffffffc02049b8 <commands+0x580>
ffffffffc0200612:	aadff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200616:	642c                	ld	a1,72(s0)
ffffffffc0200618:	00004517          	auipc	a0,0x4
ffffffffc020061c:	3b850513          	addi	a0,a0,952 # ffffffffc02049d0 <commands+0x598>
ffffffffc0200620:	a9fff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200624:	682c                	ld	a1,80(s0)
ffffffffc0200626:	00004517          	auipc	a0,0x4
ffffffffc020062a:	3c250513          	addi	a0,a0,962 # ffffffffc02049e8 <commands+0x5b0>
ffffffffc020062e:	a91ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200632:	6c2c                	ld	a1,88(s0)
ffffffffc0200634:	00004517          	auipc	a0,0x4
ffffffffc0200638:	3cc50513          	addi	a0,a0,972 # ffffffffc0204a00 <commands+0x5c8>
ffffffffc020063c:	a83ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200640:	702c                	ld	a1,96(s0)
ffffffffc0200642:	00004517          	auipc	a0,0x4
ffffffffc0200646:	3d650513          	addi	a0,a0,982 # ffffffffc0204a18 <commands+0x5e0>
ffffffffc020064a:	a75ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020064e:	742c                	ld	a1,104(s0)
ffffffffc0200650:	00004517          	auipc	a0,0x4
ffffffffc0200654:	3e050513          	addi	a0,a0,992 # ffffffffc0204a30 <commands+0x5f8>
ffffffffc0200658:	a67ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020065c:	782c                	ld	a1,112(s0)
ffffffffc020065e:	00004517          	auipc	a0,0x4
ffffffffc0200662:	3ea50513          	addi	a0,a0,1002 # ffffffffc0204a48 <commands+0x610>
ffffffffc0200666:	a59ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020066a:	7c2c                	ld	a1,120(s0)
ffffffffc020066c:	00004517          	auipc	a0,0x4
ffffffffc0200670:	3f450513          	addi	a0,a0,1012 # ffffffffc0204a60 <commands+0x628>
ffffffffc0200674:	a4bff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200678:	604c                	ld	a1,128(s0)
ffffffffc020067a:	00004517          	auipc	a0,0x4
ffffffffc020067e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0204a78 <commands+0x640>
ffffffffc0200682:	a3dff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200686:	644c                	ld	a1,136(s0)
ffffffffc0200688:	00004517          	auipc	a0,0x4
ffffffffc020068c:	40850513          	addi	a0,a0,1032 # ffffffffc0204a90 <commands+0x658>
ffffffffc0200690:	a2fff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200694:	684c                	ld	a1,144(s0)
ffffffffc0200696:	00004517          	auipc	a0,0x4
ffffffffc020069a:	41250513          	addi	a0,a0,1042 # ffffffffc0204aa8 <commands+0x670>
ffffffffc020069e:	a21ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc02006a2:	6c4c                	ld	a1,152(s0)
ffffffffc02006a4:	00004517          	auipc	a0,0x4
ffffffffc02006a8:	41c50513          	addi	a0,a0,1052 # ffffffffc0204ac0 <commands+0x688>
ffffffffc02006ac:	a13ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc02006b0:	704c                	ld	a1,160(s0)
ffffffffc02006b2:	00004517          	auipc	a0,0x4
ffffffffc02006b6:	42650513          	addi	a0,a0,1062 # ffffffffc0204ad8 <commands+0x6a0>
ffffffffc02006ba:	a05ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02006be:	744c                	ld	a1,168(s0)
ffffffffc02006c0:	00004517          	auipc	a0,0x4
ffffffffc02006c4:	43050513          	addi	a0,a0,1072 # ffffffffc0204af0 <commands+0x6b8>
ffffffffc02006c8:	9f7ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02006cc:	784c                	ld	a1,176(s0)
ffffffffc02006ce:	00004517          	auipc	a0,0x4
ffffffffc02006d2:	43a50513          	addi	a0,a0,1082 # ffffffffc0204b08 <commands+0x6d0>
ffffffffc02006d6:	9e9ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02006da:	7c4c                	ld	a1,184(s0)
ffffffffc02006dc:	00004517          	auipc	a0,0x4
ffffffffc02006e0:	44450513          	addi	a0,a0,1092 # ffffffffc0204b20 <commands+0x6e8>
ffffffffc02006e4:	9dbff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02006e8:	606c                	ld	a1,192(s0)
ffffffffc02006ea:	00004517          	auipc	a0,0x4
ffffffffc02006ee:	44e50513          	addi	a0,a0,1102 # ffffffffc0204b38 <commands+0x700>
ffffffffc02006f2:	9cdff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02006f6:	646c                	ld	a1,200(s0)
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	45850513          	addi	a0,a0,1112 # ffffffffc0204b50 <commands+0x718>
ffffffffc0200700:	9bfff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200704:	686c                	ld	a1,208(s0)
ffffffffc0200706:	00004517          	auipc	a0,0x4
ffffffffc020070a:	46250513          	addi	a0,a0,1122 # ffffffffc0204b68 <commands+0x730>
ffffffffc020070e:	9b1ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200712:	6c6c                	ld	a1,216(s0)
ffffffffc0200714:	00004517          	auipc	a0,0x4
ffffffffc0200718:	46c50513          	addi	a0,a0,1132 # ffffffffc0204b80 <commands+0x748>
ffffffffc020071c:	9a3ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200720:	706c                	ld	a1,224(s0)
ffffffffc0200722:	00004517          	auipc	a0,0x4
ffffffffc0200726:	47650513          	addi	a0,a0,1142 # ffffffffc0204b98 <commands+0x760>
ffffffffc020072a:	995ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc020072e:	746c                	ld	a1,232(s0)
ffffffffc0200730:	00004517          	auipc	a0,0x4
ffffffffc0200734:	48050513          	addi	a0,a0,1152 # ffffffffc0204bb0 <commands+0x778>
ffffffffc0200738:	987ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc020073c:	786c                	ld	a1,240(s0)
ffffffffc020073e:	00004517          	auipc	a0,0x4
ffffffffc0200742:	48a50513          	addi	a0,a0,1162 # ffffffffc0204bc8 <commands+0x790>
ffffffffc0200746:	979ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020074a:	7c6c                	ld	a1,248(s0)
}
ffffffffc020074c:	6402                	ld	s0,0(sp)
ffffffffc020074e:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200750:	00004517          	auipc	a0,0x4
ffffffffc0200754:	49050513          	addi	a0,a0,1168 # ffffffffc0204be0 <commands+0x7a8>
}
ffffffffc0200758:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020075a:	965ff06f          	j	ffffffffc02000be <cprintf>

ffffffffc020075e <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc020075e:	1141                	addi	sp,sp,-16
ffffffffc0200760:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200762:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200764:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200766:	00004517          	auipc	a0,0x4
ffffffffc020076a:	49250513          	addi	a0,a0,1170 # ffffffffc0204bf8 <commands+0x7c0>
void print_trapframe(struct trapframe *tf) {
ffffffffc020076e:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200770:	94fff0ef          	jal	ra,ffffffffc02000be <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200774:	8522                	mv	a0,s0
ffffffffc0200776:	e1bff0ef          	jal	ra,ffffffffc0200590 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc020077a:	10043583          	ld	a1,256(s0)
ffffffffc020077e:	00004517          	auipc	a0,0x4
ffffffffc0200782:	49250513          	addi	a0,a0,1170 # ffffffffc0204c10 <commands+0x7d8>
ffffffffc0200786:	939ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc020078a:	10843583          	ld	a1,264(s0)
ffffffffc020078e:	00004517          	auipc	a0,0x4
ffffffffc0200792:	49a50513          	addi	a0,a0,1178 # ffffffffc0204c28 <commands+0x7f0>
ffffffffc0200796:	929ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc020079a:	11043583          	ld	a1,272(s0)
ffffffffc020079e:	00004517          	auipc	a0,0x4
ffffffffc02007a2:	4a250513          	addi	a0,a0,1186 # ffffffffc0204c40 <commands+0x808>
ffffffffc02007a6:	919ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007aa:	11843583          	ld	a1,280(s0)
}
ffffffffc02007ae:	6402                	ld	s0,0(sp)
ffffffffc02007b0:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007b2:	00004517          	auipc	a0,0x4
ffffffffc02007b6:	4a650513          	addi	a0,a0,1190 # ffffffffc0204c58 <commands+0x820>
}
ffffffffc02007ba:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02007bc:	903ff06f          	j	ffffffffc02000be <cprintf>

ffffffffc02007c0 <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02007c0:	11853783          	ld	a5,280(a0)
ffffffffc02007c4:	577d                	li	a4,-1
ffffffffc02007c6:	8305                	srli	a4,a4,0x1
ffffffffc02007c8:	8ff9                	and	a5,a5,a4
    switch (cause) {
ffffffffc02007ca:	472d                	li	a4,11
ffffffffc02007cc:	06f76f63          	bltu	a4,a5,ffffffffc020084a <interrupt_handler+0x8a>
ffffffffc02007d0:	00004717          	auipc	a4,0x4
ffffffffc02007d4:	dfc70713          	addi	a4,a4,-516 # ffffffffc02045cc <commands+0x194>
ffffffffc02007d8:	078a                	slli	a5,a5,0x2
ffffffffc02007da:	97ba                	add	a5,a5,a4
ffffffffc02007dc:	439c                	lw	a5,0(a5)
ffffffffc02007de:	97ba                	add	a5,a5,a4
ffffffffc02007e0:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02007e2:	00004517          	auipc	a0,0x4
ffffffffc02007e6:	07650513          	addi	a0,a0,118 # ffffffffc0204858 <commands+0x420>
ffffffffc02007ea:	8d5ff06f          	j	ffffffffc02000be <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02007ee:	00004517          	auipc	a0,0x4
ffffffffc02007f2:	04a50513          	addi	a0,a0,74 # ffffffffc0204838 <commands+0x400>
ffffffffc02007f6:	8c9ff06f          	j	ffffffffc02000be <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02007fa:	00004517          	auipc	a0,0x4
ffffffffc02007fe:	ffe50513          	addi	a0,a0,-2 # ffffffffc02047f8 <commands+0x3c0>
ffffffffc0200802:	8bdff06f          	j	ffffffffc02000be <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200806:	00004517          	auipc	a0,0x4
ffffffffc020080a:	01250513          	addi	a0,a0,18 # ffffffffc0204818 <commands+0x3e0>
ffffffffc020080e:	8b1ff06f          	j	ffffffffc02000be <cprintf>
            break;
        case IRQ_U_EXT:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_EXT:
            cprintf("Supervisor external interrupt\n");
ffffffffc0200812:	00004517          	auipc	a0,0x4
ffffffffc0200816:	07650513          	addi	a0,a0,118 # ffffffffc0204888 <commands+0x450>
ffffffffc020081a:	8a5ff06f          	j	ffffffffc02000be <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc020081e:	1141                	addi	sp,sp,-16
ffffffffc0200820:	e406                	sd	ra,8(sp)
            clock_set_next_event();
ffffffffc0200822:	c45ff0ef          	jal	ra,ffffffffc0200466 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc0200826:	00011797          	auipc	a5,0x11
ffffffffc020082a:	c5278793          	addi	a5,a5,-942 # ffffffffc0211478 <ticks>
ffffffffc020082e:	639c                	ld	a5,0(a5)
ffffffffc0200830:	06400713          	li	a4,100
ffffffffc0200834:	0785                	addi	a5,a5,1
ffffffffc0200836:	02e7f733          	remu	a4,a5,a4
ffffffffc020083a:	00011697          	auipc	a3,0x11
ffffffffc020083e:	c2f6bf23          	sd	a5,-962(a3) # ffffffffc0211478 <ticks>
ffffffffc0200842:	c711                	beqz	a4,ffffffffc020084e <interrupt_handler+0x8e>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200844:	60a2                	ld	ra,8(sp)
ffffffffc0200846:	0141                	addi	sp,sp,16
ffffffffc0200848:	8082                	ret
            print_trapframe(tf);
ffffffffc020084a:	f15ff06f          	j	ffffffffc020075e <print_trapframe>
}
ffffffffc020084e:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200850:	06400593          	li	a1,100
ffffffffc0200854:	00004517          	auipc	a0,0x4
ffffffffc0200858:	02450513          	addi	a0,a0,36 # ffffffffc0204878 <commands+0x440>
}
ffffffffc020085c:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc020085e:	861ff06f          	j	ffffffffc02000be <cprintf>

ffffffffc0200862 <exception_handler>:


void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc0200862:	11853783          	ld	a5,280(a0)
ffffffffc0200866:	473d                	li	a4,15
ffffffffc0200868:	16f76563          	bltu	a4,a5,ffffffffc02009d2 <exception_handler+0x170>
ffffffffc020086c:	00004717          	auipc	a4,0x4
ffffffffc0200870:	d9070713          	addi	a4,a4,-624 # ffffffffc02045fc <commands+0x1c4>
ffffffffc0200874:	078a                	slli	a5,a5,0x2
ffffffffc0200876:	97ba                	add	a5,a5,a4
ffffffffc0200878:	439c                	lw	a5,0(a5)
void exception_handler(struct trapframe *tf) {
ffffffffc020087a:	1101                	addi	sp,sp,-32
ffffffffc020087c:	e822                	sd	s0,16(sp)
ffffffffc020087e:	ec06                	sd	ra,24(sp)
ffffffffc0200880:	e426                	sd	s1,8(sp)
    switch (tf->cause) {
ffffffffc0200882:	97ba                	add	a5,a5,a4
ffffffffc0200884:	842a                	mv	s0,a0
ffffffffc0200886:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc0200888:	00004517          	auipc	a0,0x4
ffffffffc020088c:	f5850513          	addi	a0,a0,-168 # ffffffffc02047e0 <commands+0x3a8>
ffffffffc0200890:	82fff0ef          	jal	ra,ffffffffc02000be <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200894:	8522                	mv	a0,s0
ffffffffc0200896:	c6bff0ef          	jal	ra,ffffffffc0200500 <pgfault_handler>
ffffffffc020089a:	84aa                	mv	s1,a0
ffffffffc020089c:	12051d63          	bnez	a0,ffffffffc02009d6 <exception_handler+0x174>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc02008a0:	60e2                	ld	ra,24(sp)
ffffffffc02008a2:	6442                	ld	s0,16(sp)
ffffffffc02008a4:	64a2                	ld	s1,8(sp)
ffffffffc02008a6:	6105                	addi	sp,sp,32
ffffffffc02008a8:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc02008aa:	00004517          	auipc	a0,0x4
ffffffffc02008ae:	d9650513          	addi	a0,a0,-618 # ffffffffc0204640 <commands+0x208>
}
ffffffffc02008b2:	6442                	ld	s0,16(sp)
ffffffffc02008b4:	60e2                	ld	ra,24(sp)
ffffffffc02008b6:	64a2                	ld	s1,8(sp)
ffffffffc02008b8:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc02008ba:	805ff06f          	j	ffffffffc02000be <cprintf>
ffffffffc02008be:	00004517          	auipc	a0,0x4
ffffffffc02008c2:	da250513          	addi	a0,a0,-606 # ffffffffc0204660 <commands+0x228>
ffffffffc02008c6:	b7f5                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc02008c8:	00004517          	auipc	a0,0x4
ffffffffc02008cc:	db850513          	addi	a0,a0,-584 # ffffffffc0204680 <commands+0x248>
ffffffffc02008d0:	b7cd                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc02008d2:	00004517          	auipc	a0,0x4
ffffffffc02008d6:	dc650513          	addi	a0,a0,-570 # ffffffffc0204698 <commands+0x260>
ffffffffc02008da:	bfe1                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Load address misaligned\n");
ffffffffc02008dc:	00004517          	auipc	a0,0x4
ffffffffc02008e0:	dcc50513          	addi	a0,a0,-564 # ffffffffc02046a8 <commands+0x270>
ffffffffc02008e4:	b7f9                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc02008e6:	00004517          	auipc	a0,0x4
ffffffffc02008ea:	de250513          	addi	a0,a0,-542 # ffffffffc02046c8 <commands+0x290>
ffffffffc02008ee:	fd0ff0ef          	jal	ra,ffffffffc02000be <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02008f2:	8522                	mv	a0,s0
ffffffffc02008f4:	c0dff0ef          	jal	ra,ffffffffc0200500 <pgfault_handler>
ffffffffc02008f8:	84aa                	mv	s1,a0
ffffffffc02008fa:	d15d                	beqz	a0,ffffffffc02008a0 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02008fc:	8522                	mv	a0,s0
ffffffffc02008fe:	e61ff0ef          	jal	ra,ffffffffc020075e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200902:	86a6                	mv	a3,s1
ffffffffc0200904:	00004617          	auipc	a2,0x4
ffffffffc0200908:	ddc60613          	addi	a2,a2,-548 # ffffffffc02046e0 <commands+0x2a8>
ffffffffc020090c:	0ca00593          	li	a1,202
ffffffffc0200910:	00004517          	auipc	a0,0x4
ffffffffc0200914:	fd050513          	addi	a0,a0,-48 # ffffffffc02048e0 <commands+0x4a8>
ffffffffc0200918:	feeff0ef          	jal	ra,ffffffffc0200106 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc020091c:	00004517          	auipc	a0,0x4
ffffffffc0200920:	de450513          	addi	a0,a0,-540 # ffffffffc0204700 <commands+0x2c8>
ffffffffc0200924:	b779                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc0200926:	00004517          	auipc	a0,0x4
ffffffffc020092a:	df250513          	addi	a0,a0,-526 # ffffffffc0204718 <commands+0x2e0>
ffffffffc020092e:	f90ff0ef          	jal	ra,ffffffffc02000be <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200932:	8522                	mv	a0,s0
ffffffffc0200934:	bcdff0ef          	jal	ra,ffffffffc0200500 <pgfault_handler>
ffffffffc0200938:	84aa                	mv	s1,a0
ffffffffc020093a:	d13d                	beqz	a0,ffffffffc02008a0 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc020093c:	8522                	mv	a0,s0
ffffffffc020093e:	e21ff0ef          	jal	ra,ffffffffc020075e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200942:	86a6                	mv	a3,s1
ffffffffc0200944:	00004617          	auipc	a2,0x4
ffffffffc0200948:	d9c60613          	addi	a2,a2,-612 # ffffffffc02046e0 <commands+0x2a8>
ffffffffc020094c:	0d400593          	li	a1,212
ffffffffc0200950:	00004517          	auipc	a0,0x4
ffffffffc0200954:	f9050513          	addi	a0,a0,-112 # ffffffffc02048e0 <commands+0x4a8>
ffffffffc0200958:	faeff0ef          	jal	ra,ffffffffc0200106 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc020095c:	00004517          	auipc	a0,0x4
ffffffffc0200960:	dd450513          	addi	a0,a0,-556 # ffffffffc0204730 <commands+0x2f8>
ffffffffc0200964:	b7b9                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc0200966:	00004517          	auipc	a0,0x4
ffffffffc020096a:	dea50513          	addi	a0,a0,-534 # ffffffffc0204750 <commands+0x318>
ffffffffc020096e:	b791                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc0200970:	00004517          	auipc	a0,0x4
ffffffffc0200974:	e0050513          	addi	a0,a0,-512 # ffffffffc0204770 <commands+0x338>
ffffffffc0200978:	bf2d                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc020097a:	00004517          	auipc	a0,0x4
ffffffffc020097e:	e1650513          	addi	a0,a0,-490 # ffffffffc0204790 <commands+0x358>
ffffffffc0200982:	bf05                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200984:	00004517          	auipc	a0,0x4
ffffffffc0200988:	e2c50513          	addi	a0,a0,-468 # ffffffffc02047b0 <commands+0x378>
ffffffffc020098c:	b71d                	j	ffffffffc02008b2 <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc020098e:	00004517          	auipc	a0,0x4
ffffffffc0200992:	e3a50513          	addi	a0,a0,-454 # ffffffffc02047c8 <commands+0x390>
ffffffffc0200996:	f28ff0ef          	jal	ra,ffffffffc02000be <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc020099a:	8522                	mv	a0,s0
ffffffffc020099c:	b65ff0ef          	jal	ra,ffffffffc0200500 <pgfault_handler>
ffffffffc02009a0:	84aa                	mv	s1,a0
ffffffffc02009a2:	ee050fe3          	beqz	a0,ffffffffc02008a0 <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02009a6:	8522                	mv	a0,s0
ffffffffc02009a8:	db7ff0ef          	jal	ra,ffffffffc020075e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009ac:	86a6                	mv	a3,s1
ffffffffc02009ae:	00004617          	auipc	a2,0x4
ffffffffc02009b2:	d3260613          	addi	a2,a2,-718 # ffffffffc02046e0 <commands+0x2a8>
ffffffffc02009b6:	0ea00593          	li	a1,234
ffffffffc02009ba:	00004517          	auipc	a0,0x4
ffffffffc02009be:	f2650513          	addi	a0,a0,-218 # ffffffffc02048e0 <commands+0x4a8>
ffffffffc02009c2:	f44ff0ef          	jal	ra,ffffffffc0200106 <__panic>
}
ffffffffc02009c6:	6442                	ld	s0,16(sp)
ffffffffc02009c8:	60e2                	ld	ra,24(sp)
ffffffffc02009ca:	64a2                	ld	s1,8(sp)
ffffffffc02009cc:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc02009ce:	d91ff06f          	j	ffffffffc020075e <print_trapframe>
ffffffffc02009d2:	d8dff06f          	j	ffffffffc020075e <print_trapframe>
                print_trapframe(tf);
ffffffffc02009d6:	8522                	mv	a0,s0
ffffffffc02009d8:	d87ff0ef          	jal	ra,ffffffffc020075e <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009dc:	86a6                	mv	a3,s1
ffffffffc02009de:	00004617          	auipc	a2,0x4
ffffffffc02009e2:	d0260613          	addi	a2,a2,-766 # ffffffffc02046e0 <commands+0x2a8>
ffffffffc02009e6:	0f100593          	li	a1,241
ffffffffc02009ea:	00004517          	auipc	a0,0x4
ffffffffc02009ee:	ef650513          	addi	a0,a0,-266 # ffffffffc02048e0 <commands+0x4a8>
ffffffffc02009f2:	f14ff0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc02009f6 <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc02009f6:	11853783          	ld	a5,280(a0)
ffffffffc02009fa:	0007c463          	bltz	a5,ffffffffc0200a02 <trap+0xc>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc02009fe:	e65ff06f          	j	ffffffffc0200862 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200a02:	dbfff06f          	j	ffffffffc02007c0 <interrupt_handler>
	...

ffffffffc0200a10 <__alltraps>:
    .endm

    .align 4
    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200a10:	14011073          	csrw	sscratch,sp
ffffffffc0200a14:	712d                	addi	sp,sp,-288
ffffffffc0200a16:	e406                	sd	ra,8(sp)
ffffffffc0200a18:	ec0e                	sd	gp,24(sp)
ffffffffc0200a1a:	f012                	sd	tp,32(sp)
ffffffffc0200a1c:	f416                	sd	t0,40(sp)
ffffffffc0200a1e:	f81a                	sd	t1,48(sp)
ffffffffc0200a20:	fc1e                	sd	t2,56(sp)
ffffffffc0200a22:	e0a2                	sd	s0,64(sp)
ffffffffc0200a24:	e4a6                	sd	s1,72(sp)
ffffffffc0200a26:	e8aa                	sd	a0,80(sp)
ffffffffc0200a28:	ecae                	sd	a1,88(sp)
ffffffffc0200a2a:	f0b2                	sd	a2,96(sp)
ffffffffc0200a2c:	f4b6                	sd	a3,104(sp)
ffffffffc0200a2e:	f8ba                	sd	a4,112(sp)
ffffffffc0200a30:	fcbe                	sd	a5,120(sp)
ffffffffc0200a32:	e142                	sd	a6,128(sp)
ffffffffc0200a34:	e546                	sd	a7,136(sp)
ffffffffc0200a36:	e94a                	sd	s2,144(sp)
ffffffffc0200a38:	ed4e                	sd	s3,152(sp)
ffffffffc0200a3a:	f152                	sd	s4,160(sp)
ffffffffc0200a3c:	f556                	sd	s5,168(sp)
ffffffffc0200a3e:	f95a                	sd	s6,176(sp)
ffffffffc0200a40:	fd5e                	sd	s7,184(sp)
ffffffffc0200a42:	e1e2                	sd	s8,192(sp)
ffffffffc0200a44:	e5e6                	sd	s9,200(sp)
ffffffffc0200a46:	e9ea                	sd	s10,208(sp)
ffffffffc0200a48:	edee                	sd	s11,216(sp)
ffffffffc0200a4a:	f1f2                	sd	t3,224(sp)
ffffffffc0200a4c:	f5f6                	sd	t4,232(sp)
ffffffffc0200a4e:	f9fa                	sd	t5,240(sp)
ffffffffc0200a50:	fdfe                	sd	t6,248(sp)
ffffffffc0200a52:	14002473          	csrr	s0,sscratch
ffffffffc0200a56:	100024f3          	csrr	s1,sstatus
ffffffffc0200a5a:	14102973          	csrr	s2,sepc
ffffffffc0200a5e:	143029f3          	csrr	s3,stval
ffffffffc0200a62:	14202a73          	csrr	s4,scause
ffffffffc0200a66:	e822                	sd	s0,16(sp)
ffffffffc0200a68:	e226                	sd	s1,256(sp)
ffffffffc0200a6a:	e64a                	sd	s2,264(sp)
ffffffffc0200a6c:	ea4e                	sd	s3,272(sp)
ffffffffc0200a6e:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200a70:	850a                	mv	a0,sp
    jal trap
ffffffffc0200a72:	f85ff0ef          	jal	ra,ffffffffc02009f6 <trap>

ffffffffc0200a76 <__trapret>:
    // sp should be the same as before "jal trap"
    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200a76:	6492                	ld	s1,256(sp)
ffffffffc0200a78:	6932                	ld	s2,264(sp)
ffffffffc0200a7a:	10049073          	csrw	sstatus,s1
ffffffffc0200a7e:	14191073          	csrw	sepc,s2
ffffffffc0200a82:	60a2                	ld	ra,8(sp)
ffffffffc0200a84:	61e2                	ld	gp,24(sp)
ffffffffc0200a86:	7202                	ld	tp,32(sp)
ffffffffc0200a88:	72a2                	ld	t0,40(sp)
ffffffffc0200a8a:	7342                	ld	t1,48(sp)
ffffffffc0200a8c:	73e2                	ld	t2,56(sp)
ffffffffc0200a8e:	6406                	ld	s0,64(sp)
ffffffffc0200a90:	64a6                	ld	s1,72(sp)
ffffffffc0200a92:	6546                	ld	a0,80(sp)
ffffffffc0200a94:	65e6                	ld	a1,88(sp)
ffffffffc0200a96:	7606                	ld	a2,96(sp)
ffffffffc0200a98:	76a6                	ld	a3,104(sp)
ffffffffc0200a9a:	7746                	ld	a4,112(sp)
ffffffffc0200a9c:	77e6                	ld	a5,120(sp)
ffffffffc0200a9e:	680a                	ld	a6,128(sp)
ffffffffc0200aa0:	68aa                	ld	a7,136(sp)
ffffffffc0200aa2:	694a                	ld	s2,144(sp)
ffffffffc0200aa4:	69ea                	ld	s3,152(sp)
ffffffffc0200aa6:	7a0a                	ld	s4,160(sp)
ffffffffc0200aa8:	7aaa                	ld	s5,168(sp)
ffffffffc0200aaa:	7b4a                	ld	s6,176(sp)
ffffffffc0200aac:	7bea                	ld	s7,184(sp)
ffffffffc0200aae:	6c0e                	ld	s8,192(sp)
ffffffffc0200ab0:	6cae                	ld	s9,200(sp)
ffffffffc0200ab2:	6d4e                	ld	s10,208(sp)
ffffffffc0200ab4:	6dee                	ld	s11,216(sp)
ffffffffc0200ab6:	7e0e                	ld	t3,224(sp)
ffffffffc0200ab8:	7eae                	ld	t4,232(sp)
ffffffffc0200aba:	7f4e                	ld	t5,240(sp)
ffffffffc0200abc:	7fee                	ld	t6,248(sp)
ffffffffc0200abe:	6142                	ld	sp,16(sp)
    // go back from supervisor call
    sret
ffffffffc0200ac0:	10200073          	sret
	...

ffffffffc0200ad0 <pa2page.part.4>:

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0200ad0:	1141                	addi	sp,sp,-16
    if (PPN(pa) >= npage) {
        panic("pa2page called with invalid pa");
ffffffffc0200ad2:	00004617          	auipc	a2,0x4
ffffffffc0200ad6:	21e60613          	addi	a2,a2,542 # ffffffffc0204cf0 <commands+0x8b8>
ffffffffc0200ada:	06500593          	li	a1,101
ffffffffc0200ade:	00004517          	auipc	a0,0x4
ffffffffc0200ae2:	23250513          	addi	a0,a0,562 # ffffffffc0204d10 <commands+0x8d8>
static inline struct Page *pa2page(uintptr_t pa) {
ffffffffc0200ae6:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0200ae8:	e1eff0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0200aec <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0200aec:	715d                	addi	sp,sp,-80
ffffffffc0200aee:	e0a2                	sd	s0,64(sp)
ffffffffc0200af0:	fc26                	sd	s1,56(sp)
ffffffffc0200af2:	f84a                	sd	s2,48(sp)
ffffffffc0200af4:	f44e                	sd	s3,40(sp)
ffffffffc0200af6:	f052                	sd	s4,32(sp)
ffffffffc0200af8:	ec56                	sd	s5,24(sp)
ffffffffc0200afa:	e486                	sd	ra,72(sp)
ffffffffc0200afc:	842a                	mv	s0,a0
ffffffffc0200afe:	00011497          	auipc	s1,0x11
ffffffffc0200b02:	98248493          	addi	s1,s1,-1662 # ffffffffc0211480 <pmm_manager>
    while (1) {
        local_intr_save(intr_flag);
        { page = pmm_manager->alloc_pages(n); }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200b06:	4985                	li	s3,1
ffffffffc0200b08:	00011a17          	auipc	s4,0x11
ffffffffc0200b0c:	968a0a13          	addi	s4,s4,-1688 # ffffffffc0211470 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0200b10:	0005091b          	sext.w	s2,a0
ffffffffc0200b14:	00011a97          	auipc	s5,0x11
ffffffffc0200b18:	99ca8a93          	addi	s5,s5,-1636 # ffffffffc02114b0 <check_mm_struct>
ffffffffc0200b1c:	a00d                	j	ffffffffc0200b3e <alloc_pages+0x52>
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0200b1e:	609c                	ld	a5,0(s1)
ffffffffc0200b20:	6f9c                	ld	a5,24(a5)
ffffffffc0200b22:	9782                	jalr	a5
        swap_out(check_mm_struct, n, 0);
ffffffffc0200b24:	4601                	li	a2,0
ffffffffc0200b26:	85ca                	mv	a1,s2
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200b28:	ed0d                	bnez	a0,ffffffffc0200b62 <alloc_pages+0x76>
ffffffffc0200b2a:	0289ec63          	bltu	s3,s0,ffffffffc0200b62 <alloc_pages+0x76>
ffffffffc0200b2e:	000a2783          	lw	a5,0(s4)
ffffffffc0200b32:	2781                	sext.w	a5,a5
ffffffffc0200b34:	c79d                	beqz	a5,ffffffffc0200b62 <alloc_pages+0x76>
        swap_out(check_mm_struct, n, 0);
ffffffffc0200b36:	000ab503          	ld	a0,0(s5)
ffffffffc0200b3a:	040020ef          	jal	ra,ffffffffc0202b7a <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0200b42:	8b89                	andi	a5,a5,2
        { page = pmm_manager->alloc_pages(n); }
ffffffffc0200b44:	8522                	mv	a0,s0
ffffffffc0200b46:	dfe1                	beqz	a5,ffffffffc0200b1e <alloc_pages+0x32>
        intr_disable();
ffffffffc0200b48:	9b3ff0ef          	jal	ra,ffffffffc02004fa <intr_disable>
ffffffffc0200b4c:	609c                	ld	a5,0(s1)
ffffffffc0200b4e:	8522                	mv	a0,s0
ffffffffc0200b50:	6f9c                	ld	a5,24(a5)
ffffffffc0200b52:	9782                	jalr	a5
ffffffffc0200b54:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200b56:	99fff0ef          	jal	ra,ffffffffc02004f4 <intr_enable>
ffffffffc0200b5a:	6522                	ld	a0,8(sp)
        swap_out(check_mm_struct, n, 0);
ffffffffc0200b5c:	4601                	li	a2,0
ffffffffc0200b5e:	85ca                	mv	a1,s2
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200b60:	d569                	beqz	a0,ffffffffc0200b2a <alloc_pages+0x3e>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0200b62:	60a6                	ld	ra,72(sp)
ffffffffc0200b64:	6406                	ld	s0,64(sp)
ffffffffc0200b66:	74e2                	ld	s1,56(sp)
ffffffffc0200b68:	7942                	ld	s2,48(sp)
ffffffffc0200b6a:	79a2                	ld	s3,40(sp)
ffffffffc0200b6c:	7a02                	ld	s4,32(sp)
ffffffffc0200b6e:	6ae2                	ld	s5,24(sp)
ffffffffc0200b70:	6161                	addi	sp,sp,80
ffffffffc0200b72:	8082                	ret

ffffffffc0200b74 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200b74:	100027f3          	csrr	a5,sstatus
ffffffffc0200b78:	8b89                	andi	a5,a5,2
ffffffffc0200b7a:	eb89                	bnez	a5,ffffffffc0200b8c <free_pages+0x18>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;

    local_intr_save(intr_flag);
    { pmm_manager->free_pages(base, n); }
ffffffffc0200b7c:	00011797          	auipc	a5,0x11
ffffffffc0200b80:	90478793          	addi	a5,a5,-1788 # ffffffffc0211480 <pmm_manager>
ffffffffc0200b84:	639c                	ld	a5,0(a5)
ffffffffc0200b86:	0207b303          	ld	t1,32(a5)
ffffffffc0200b8a:	8302                	jr	t1
void free_pages(struct Page *base, size_t n) {
ffffffffc0200b8c:	1101                	addi	sp,sp,-32
ffffffffc0200b8e:	ec06                	sd	ra,24(sp)
ffffffffc0200b90:	e822                	sd	s0,16(sp)
ffffffffc0200b92:	e426                	sd	s1,8(sp)
ffffffffc0200b94:	842a                	mv	s0,a0
ffffffffc0200b96:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200b98:	963ff0ef          	jal	ra,ffffffffc02004fa <intr_disable>
    { pmm_manager->free_pages(base, n); }
ffffffffc0200b9c:	00011797          	auipc	a5,0x11
ffffffffc0200ba0:	8e478793          	addi	a5,a5,-1820 # ffffffffc0211480 <pmm_manager>
ffffffffc0200ba4:	639c                	ld	a5,0(a5)
ffffffffc0200ba6:	85a6                	mv	a1,s1
ffffffffc0200ba8:	8522                	mv	a0,s0
ffffffffc0200baa:	739c                	ld	a5,32(a5)
ffffffffc0200bac:	9782                	jalr	a5
    local_intr_restore(intr_flag);
}
ffffffffc0200bae:	6442                	ld	s0,16(sp)
ffffffffc0200bb0:	60e2                	ld	ra,24(sp)
ffffffffc0200bb2:	64a2                	ld	s1,8(sp)
ffffffffc0200bb4:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200bb6:	93fff06f          	j	ffffffffc02004f4 <intr_enable>

ffffffffc0200bba <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200bba:	100027f3          	csrr	a5,sstatus
ffffffffc0200bbe:	8b89                	andi	a5,a5,2
ffffffffc0200bc0:	eb89                	bnez	a5,ffffffffc0200bd2 <nr_free_pages+0x18>
// of current free memory
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0200bc2:	00011797          	auipc	a5,0x11
ffffffffc0200bc6:	8be78793          	addi	a5,a5,-1858 # ffffffffc0211480 <pmm_manager>
ffffffffc0200bca:	639c                	ld	a5,0(a5)
ffffffffc0200bcc:	0287b303          	ld	t1,40(a5)
ffffffffc0200bd0:	8302                	jr	t1
size_t nr_free_pages(void) {
ffffffffc0200bd2:	1141                	addi	sp,sp,-16
ffffffffc0200bd4:	e406                	sd	ra,8(sp)
ffffffffc0200bd6:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200bd8:	923ff0ef          	jal	ra,ffffffffc02004fa <intr_disable>
    { ret = pmm_manager->nr_free_pages(); }
ffffffffc0200bdc:	00011797          	auipc	a5,0x11
ffffffffc0200be0:	8a478793          	addi	a5,a5,-1884 # ffffffffc0211480 <pmm_manager>
ffffffffc0200be4:	639c                	ld	a5,0(a5)
ffffffffc0200be6:	779c                	ld	a5,40(a5)
ffffffffc0200be8:	9782                	jalr	a5
ffffffffc0200bea:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200bec:	909ff0ef          	jal	ra,ffffffffc02004f4 <intr_enable>
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0200bf0:	8522                	mv	a0,s0
ffffffffc0200bf2:	60a2                	ld	ra,8(sp)
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	0141                	addi	sp,sp,16
ffffffffc0200bf8:	8082                	ret

ffffffffc0200bfa <get_pte>:
// parameter:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200bfa:	715d                	addi	sp,sp,-80
ffffffffc0200bfc:	fc26                	sd	s1,56(sp)
     *   PTE_W           0x002                   // page table/directory entry
     * flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry
     * flags bit : User can access
     */
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0200bfe:	01e5d493          	srli	s1,a1,0x1e
ffffffffc0200c02:	1ff4f493          	andi	s1,s1,511
ffffffffc0200c06:	048e                	slli	s1,s1,0x3
ffffffffc0200c08:	94aa                	add	s1,s1,a0
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200c0a:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200c0c:	f84a                	sd	s2,48(sp)
ffffffffc0200c0e:	f44e                	sd	s3,40(sp)
ffffffffc0200c10:	f052                	sd	s4,32(sp)
ffffffffc0200c12:	e486                	sd	ra,72(sp)
ffffffffc0200c14:	e0a2                	sd	s0,64(sp)
ffffffffc0200c16:	ec56                	sd	s5,24(sp)
ffffffffc0200c18:	e85a                	sd	s6,16(sp)
ffffffffc0200c1a:	e45e                	sd	s7,8(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200c1c:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200c20:	892e                	mv	s2,a1
ffffffffc0200c22:	8a32                	mv	s4,a2
ffffffffc0200c24:	00011997          	auipc	s3,0x11
ffffffffc0200c28:	83498993          	addi	s3,s3,-1996 # ffffffffc0211458 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200c2c:	e3c9                	bnez	a5,ffffffffc0200cae <get_pte+0xb4>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0200c2e:	16060163          	beqz	a2,ffffffffc0200d90 <get_pte+0x196>
ffffffffc0200c32:	4505                	li	a0,1
ffffffffc0200c34:	eb9ff0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0200c38:	842a                	mv	s0,a0
ffffffffc0200c3a:	14050b63          	beqz	a0,ffffffffc0200d90 <get_pte+0x196>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c3e:	00011b97          	auipc	s7,0x11
ffffffffc0200c42:	85ab8b93          	addi	s7,s7,-1958 # ffffffffc0211498 <pages>
ffffffffc0200c46:	000bb503          	ld	a0,0(s7)
ffffffffc0200c4a:	00004797          	auipc	a5,0x4
ffffffffc0200c4e:	02678793          	addi	a5,a5,38 # ffffffffc0204c70 <commands+0x838>
ffffffffc0200c52:	0007bb03          	ld	s6,0(a5)
ffffffffc0200c56:	40a40533          	sub	a0,s0,a0
ffffffffc0200c5a:	850d                	srai	a0,a0,0x3
ffffffffc0200c5c:	03650533          	mul	a0,a0,s6
    return pa2page(PDE_ADDR(pde));
}

static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200c60:	4785                	li	a5,1
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200c62:	00010997          	auipc	s3,0x10
ffffffffc0200c66:	7f698993          	addi	s3,s3,2038 # ffffffffc0211458 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c6a:	00080ab7          	lui	s5,0x80
ffffffffc0200c6e:	0009b703          	ld	a4,0(s3)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200c72:	c01c                	sw	a5,0(s0)
ffffffffc0200c74:	57fd                	li	a5,-1
ffffffffc0200c76:	83b1                	srli	a5,a5,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c78:	9556                	add	a0,a0,s5
ffffffffc0200c7a:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200c7c:	0532                	slli	a0,a0,0xc
ffffffffc0200c7e:	16e7f063          	bleu	a4,a5,ffffffffc0200dde <get_pte+0x1e4>
ffffffffc0200c82:	00011797          	auipc	a5,0x11
ffffffffc0200c86:	80678793          	addi	a5,a5,-2042 # ffffffffc0211488 <va_pa_offset>
ffffffffc0200c8a:	639c                	ld	a5,0(a5)
ffffffffc0200c8c:	6605                	lui	a2,0x1
ffffffffc0200c8e:	4581                	li	a1,0
ffffffffc0200c90:	953e                	add	a0,a0,a5
ffffffffc0200c92:	17c030ef          	jal	ra,ffffffffc0203e0e <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200c96:	000bb683          	ld	a3,0(s7)
ffffffffc0200c9a:	40d406b3          	sub	a3,s0,a3
ffffffffc0200c9e:	868d                	srai	a3,a3,0x3
ffffffffc0200ca0:	036686b3          	mul	a3,a3,s6
ffffffffc0200ca4:	96d6                	add	a3,a3,s5

static inline void flush_tlb() { asm volatile("sfence.vma"); }

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200ca6:	06aa                	slli	a3,a3,0xa
ffffffffc0200ca8:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0200cac:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0200cae:	77fd                	lui	a5,0xfffff
ffffffffc0200cb0:	068a                	slli	a3,a3,0x2
ffffffffc0200cb2:	0009b703          	ld	a4,0(s3)
ffffffffc0200cb6:	8efd                	and	a3,a3,a5
ffffffffc0200cb8:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200cbc:	0ce7fc63          	bleu	a4,a5,ffffffffc0200d94 <get_pte+0x19a>
ffffffffc0200cc0:	00010a97          	auipc	s5,0x10
ffffffffc0200cc4:	7c8a8a93          	addi	s5,s5,1992 # ffffffffc0211488 <va_pa_offset>
ffffffffc0200cc8:	000ab403          	ld	s0,0(s5)
ffffffffc0200ccc:	01595793          	srli	a5,s2,0x15
ffffffffc0200cd0:	1ff7f793          	andi	a5,a5,511
ffffffffc0200cd4:	96a2                	add	a3,a3,s0
ffffffffc0200cd6:	00379413          	slli	s0,a5,0x3
ffffffffc0200cda:	9436                	add	s0,s0,a3
//    pde_t *pdep0 = &((pde_t *)(PDE_ADDR(*pdep1)))[PDX0(la)];
    if (!(*pdep0 & PTE_V)) {
ffffffffc0200cdc:	6014                	ld	a3,0(s0)
ffffffffc0200cde:	0016f793          	andi	a5,a3,1
ffffffffc0200ce2:	ebbd                	bnez	a5,ffffffffc0200d58 <get_pte+0x15e>
    	struct Page *page;
    	if (!create || (page = alloc_page()) == NULL) {
ffffffffc0200ce4:	0a0a0663          	beqz	s4,ffffffffc0200d90 <get_pte+0x196>
ffffffffc0200ce8:	4505                	li	a0,1
ffffffffc0200cea:	e03ff0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0200cee:	84aa                	mv	s1,a0
ffffffffc0200cf0:	c145                	beqz	a0,ffffffffc0200d90 <get_pte+0x196>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200cf2:	00010b97          	auipc	s7,0x10
ffffffffc0200cf6:	7a6b8b93          	addi	s7,s7,1958 # ffffffffc0211498 <pages>
ffffffffc0200cfa:	000bb503          	ld	a0,0(s7)
ffffffffc0200cfe:	00004797          	auipc	a5,0x4
ffffffffc0200d02:	f7278793          	addi	a5,a5,-142 # ffffffffc0204c70 <commands+0x838>
ffffffffc0200d06:	0007bb03          	ld	s6,0(a5)
ffffffffc0200d0a:	40a48533          	sub	a0,s1,a0
ffffffffc0200d0e:	850d                	srai	a0,a0,0x3
ffffffffc0200d10:	03650533          	mul	a0,a0,s6
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200d14:	4785                	li	a5,1
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d16:	00080a37          	lui	s4,0x80
    		return NULL;
    	}
    	set_page_ref(page, 1);
    	uintptr_t pa = page2pa(page);
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200d1a:	0009b703          	ld	a4,0(s3)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0200d1e:	c09c                	sw	a5,0(s1)
ffffffffc0200d20:	57fd                	li	a5,-1
ffffffffc0200d22:	83b1                	srli	a5,a5,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d24:	9552                	add	a0,a0,s4
ffffffffc0200d26:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d28:	0532                	slli	a0,a0,0xc
ffffffffc0200d2a:	08e7fd63          	bleu	a4,a5,ffffffffc0200dc4 <get_pte+0x1ca>
ffffffffc0200d2e:	000ab783          	ld	a5,0(s5)
ffffffffc0200d32:	6605                	lui	a2,0x1
ffffffffc0200d34:	4581                	li	a1,0
ffffffffc0200d36:	953e                	add	a0,a0,a5
ffffffffc0200d38:	0d6030ef          	jal	ra,ffffffffc0203e0e <memset>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d3c:	000bb683          	ld	a3,0(s7)
ffffffffc0200d40:	40d486b3          	sub	a3,s1,a3
ffffffffc0200d44:	868d                	srai	a3,a3,0x3
ffffffffc0200d46:	036686b3          	mul	a3,a3,s6
ffffffffc0200d4a:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200d4c:	06aa                	slli	a3,a3,0xa
ffffffffc0200d4e:	0116e693          	ori	a3,a3,17
 //   	memset(pa, 0, PGSIZE);
    	*pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0200d52:	e014                	sd	a3,0(s0)
ffffffffc0200d54:	0009b703          	ld	a4,0(s3)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0200d58:	068a                	slli	a3,a3,0x2
ffffffffc0200d5a:	757d                	lui	a0,0xfffff
ffffffffc0200d5c:	8ee9                	and	a3,a3,a0
ffffffffc0200d5e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200d62:	04e7f563          	bleu	a4,a5,ffffffffc0200dac <get_pte+0x1b2>
ffffffffc0200d66:	000ab503          	ld	a0,0(s5)
ffffffffc0200d6a:	00c95793          	srli	a5,s2,0xc
ffffffffc0200d6e:	1ff7f793          	andi	a5,a5,511
ffffffffc0200d72:	96aa                	add	a3,a3,a0
ffffffffc0200d74:	00379513          	slli	a0,a5,0x3
ffffffffc0200d78:	9536                	add	a0,a0,a3
}
ffffffffc0200d7a:	60a6                	ld	ra,72(sp)
ffffffffc0200d7c:	6406                	ld	s0,64(sp)
ffffffffc0200d7e:	74e2                	ld	s1,56(sp)
ffffffffc0200d80:	7942                	ld	s2,48(sp)
ffffffffc0200d82:	79a2                	ld	s3,40(sp)
ffffffffc0200d84:	7a02                	ld	s4,32(sp)
ffffffffc0200d86:	6ae2                	ld	s5,24(sp)
ffffffffc0200d88:	6b42                	ld	s6,16(sp)
ffffffffc0200d8a:	6ba2                	ld	s7,8(sp)
ffffffffc0200d8c:	6161                	addi	sp,sp,80
ffffffffc0200d8e:	8082                	ret
            return NULL;
ffffffffc0200d90:	4501                	li	a0,0
ffffffffc0200d92:	b7e5                	j	ffffffffc0200d7a <get_pte+0x180>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0200d94:	00004617          	auipc	a2,0x4
ffffffffc0200d98:	ee460613          	addi	a2,a2,-284 # ffffffffc0204c78 <commands+0x840>
ffffffffc0200d9c:	10200593          	li	a1,258
ffffffffc0200da0:	00004517          	auipc	a0,0x4
ffffffffc0200da4:	f0050513          	addi	a0,a0,-256 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0200da8:	b5eff0ef          	jal	ra,ffffffffc0200106 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0200dac:	00004617          	auipc	a2,0x4
ffffffffc0200db0:	ecc60613          	addi	a2,a2,-308 # ffffffffc0204c78 <commands+0x840>
ffffffffc0200db4:	10f00593          	li	a1,271
ffffffffc0200db8:	00004517          	auipc	a0,0x4
ffffffffc0200dbc:	ee850513          	addi	a0,a0,-280 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0200dc0:	b46ff0ef          	jal	ra,ffffffffc0200106 <__panic>
    	memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200dc4:	86aa                	mv	a3,a0
ffffffffc0200dc6:	00004617          	auipc	a2,0x4
ffffffffc0200dca:	eb260613          	addi	a2,a2,-334 # ffffffffc0204c78 <commands+0x840>
ffffffffc0200dce:	10b00593          	li	a1,267
ffffffffc0200dd2:	00004517          	auipc	a0,0x4
ffffffffc0200dd6:	ece50513          	addi	a0,a0,-306 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0200dda:	b2cff0ef          	jal	ra,ffffffffc0200106 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200dde:	86aa                	mv	a3,a0
ffffffffc0200de0:	00004617          	auipc	a2,0x4
ffffffffc0200de4:	e9860613          	addi	a2,a2,-360 # ffffffffc0204c78 <commands+0x840>
ffffffffc0200de8:	0ff00593          	li	a1,255
ffffffffc0200dec:	00004517          	auipc	a0,0x4
ffffffffc0200df0:	eb450513          	addi	a0,a0,-332 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0200df4:	b12ff0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0200df8 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0200df8:	1141                	addi	sp,sp,-16
ffffffffc0200dfa:	e022                	sd	s0,0(sp)
ffffffffc0200dfc:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200dfe:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0200e00:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200e02:	df9ff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
    if (ptep_store != NULL) {
ffffffffc0200e06:	c011                	beqz	s0,ffffffffc0200e0a <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0200e08:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0200e0a:	c521                	beqz	a0,ffffffffc0200e52 <get_page+0x5a>
ffffffffc0200e0c:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0200e0e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0200e10:	0017f713          	andi	a4,a5,1
ffffffffc0200e14:	e709                	bnez	a4,ffffffffc0200e1e <get_page+0x26>
}
ffffffffc0200e16:	60a2                	ld	ra,8(sp)
ffffffffc0200e18:	6402                	ld	s0,0(sp)
ffffffffc0200e1a:	0141                	addi	sp,sp,16
ffffffffc0200e1c:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0200e1e:	00010717          	auipc	a4,0x10
ffffffffc0200e22:	63a70713          	addi	a4,a4,1594 # ffffffffc0211458 <npage>
ffffffffc0200e26:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0200e28:	078a                	slli	a5,a5,0x2
ffffffffc0200e2a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200e2c:	02e7f863          	bleu	a4,a5,ffffffffc0200e5c <get_page+0x64>
    return &pages[PPN(pa) - nbase];
ffffffffc0200e30:	fff80537          	lui	a0,0xfff80
ffffffffc0200e34:	97aa                	add	a5,a5,a0
ffffffffc0200e36:	00010697          	auipc	a3,0x10
ffffffffc0200e3a:	66268693          	addi	a3,a3,1634 # ffffffffc0211498 <pages>
ffffffffc0200e3e:	6288                	ld	a0,0(a3)
ffffffffc0200e40:	60a2                	ld	ra,8(sp)
ffffffffc0200e42:	6402                	ld	s0,0(sp)
ffffffffc0200e44:	00379713          	slli	a4,a5,0x3
ffffffffc0200e48:	97ba                	add	a5,a5,a4
ffffffffc0200e4a:	078e                	slli	a5,a5,0x3
ffffffffc0200e4c:	953e                	add	a0,a0,a5
ffffffffc0200e4e:	0141                	addi	sp,sp,16
ffffffffc0200e50:	8082                	ret
ffffffffc0200e52:	60a2                	ld	ra,8(sp)
ffffffffc0200e54:	6402                	ld	s0,0(sp)
    return NULL;
ffffffffc0200e56:	4501                	li	a0,0
}
ffffffffc0200e58:	0141                	addi	sp,sp,16
ffffffffc0200e5a:	8082                	ret
ffffffffc0200e5c:	c75ff0ef          	jal	ra,ffffffffc0200ad0 <pa2page.part.4>

ffffffffc0200e60 <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0200e60:	1141                	addi	sp,sp,-16
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200e62:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0200e64:	e406                	sd	ra,8(sp)
ffffffffc0200e66:	e022                	sd	s0,0(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200e68:	d93ff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
    if (ptep != NULL) {
ffffffffc0200e6c:	c511                	beqz	a0,ffffffffc0200e78 <page_remove+0x18>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0200e6e:	611c                	ld	a5,0(a0)
ffffffffc0200e70:	842a                	mv	s0,a0
ffffffffc0200e72:	0017f713          	andi	a4,a5,1
ffffffffc0200e76:	e709                	bnez	a4,ffffffffc0200e80 <page_remove+0x20>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0200e78:	60a2                	ld	ra,8(sp)
ffffffffc0200e7a:	6402                	ld	s0,0(sp)
ffffffffc0200e7c:	0141                	addi	sp,sp,16
ffffffffc0200e7e:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0200e80:	00010717          	auipc	a4,0x10
ffffffffc0200e84:	5d870713          	addi	a4,a4,1496 # ffffffffc0211458 <npage>
ffffffffc0200e88:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0200e8a:	078a                	slli	a5,a5,0x2
ffffffffc0200e8c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200e8e:	04e7f063          	bleu	a4,a5,ffffffffc0200ece <page_remove+0x6e>
    return &pages[PPN(pa) - nbase];
ffffffffc0200e92:	fff80737          	lui	a4,0xfff80
ffffffffc0200e96:	97ba                	add	a5,a5,a4
ffffffffc0200e98:	00010717          	auipc	a4,0x10
ffffffffc0200e9c:	60070713          	addi	a4,a4,1536 # ffffffffc0211498 <pages>
ffffffffc0200ea0:	6308                	ld	a0,0(a4)
ffffffffc0200ea2:	00379713          	slli	a4,a5,0x3
ffffffffc0200ea6:	97ba                	add	a5,a5,a4
ffffffffc0200ea8:	078e                	slli	a5,a5,0x3
ffffffffc0200eaa:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0200eac:	411c                	lw	a5,0(a0)
ffffffffc0200eae:	fff7871b          	addiw	a4,a5,-1
ffffffffc0200eb2:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0200eb4:	cb09                	beqz	a4,ffffffffc0200ec6 <page_remove+0x66>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0200eb6:	00043023          	sd	zero,0(s0)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0200eba:	12000073          	sfence.vma
}
ffffffffc0200ebe:	60a2                	ld	ra,8(sp)
ffffffffc0200ec0:	6402                	ld	s0,0(sp)
ffffffffc0200ec2:	0141                	addi	sp,sp,16
ffffffffc0200ec4:	8082                	ret
            free_page(page);
ffffffffc0200ec6:	4585                	li	a1,1
ffffffffc0200ec8:	cadff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
ffffffffc0200ecc:	b7ed                	j	ffffffffc0200eb6 <page_remove+0x56>
ffffffffc0200ece:	c03ff0ef          	jal	ra,ffffffffc0200ad0 <pa2page.part.4>

ffffffffc0200ed2 <page_insert>:
//  page:  the Page which need to map
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
// note: PT is changed, so the TLB need to be invalidate
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0200ed2:	7179                	addi	sp,sp,-48
ffffffffc0200ed4:	87b2                	mv	a5,a2
ffffffffc0200ed6:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0200ed8:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0200eda:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0200edc:	85be                	mv	a1,a5
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0200ede:	ec26                	sd	s1,24(sp)
ffffffffc0200ee0:	f406                	sd	ra,40(sp)
ffffffffc0200ee2:	e84a                	sd	s2,16(sp)
ffffffffc0200ee4:	e44e                	sd	s3,8(sp)
ffffffffc0200ee6:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0200ee8:	d13ff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
    if (ptep == NULL) {
ffffffffc0200eec:	c945                	beqz	a0,ffffffffc0200f9c <page_insert+0xca>
    page->ref += 1;
ffffffffc0200eee:	4014                	lw	a3,0(s0)
        return -E_NO_MEM;
    }
    page_ref_inc(page);
    if (*ptep & PTE_V) {
ffffffffc0200ef0:	611c                	ld	a5,0(a0)
ffffffffc0200ef2:	892a                	mv	s2,a0
ffffffffc0200ef4:	0016871b          	addiw	a4,a3,1
ffffffffc0200ef8:	c018                	sw	a4,0(s0)
ffffffffc0200efa:	0017f713          	andi	a4,a5,1
ffffffffc0200efe:	e339                	bnez	a4,ffffffffc0200f44 <page_insert+0x72>
ffffffffc0200f00:	00010797          	auipc	a5,0x10
ffffffffc0200f04:	59878793          	addi	a5,a5,1432 # ffffffffc0211498 <pages>
ffffffffc0200f08:	639c                	ld	a5,0(a5)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200f0a:	00004717          	auipc	a4,0x4
ffffffffc0200f0e:	d6670713          	addi	a4,a4,-666 # ffffffffc0204c70 <commands+0x838>
ffffffffc0200f12:	40f407b3          	sub	a5,s0,a5
ffffffffc0200f16:	6300                	ld	s0,0(a4)
ffffffffc0200f18:	878d                	srai	a5,a5,0x3
ffffffffc0200f1a:	000806b7          	lui	a3,0x80
ffffffffc0200f1e:	028787b3          	mul	a5,a5,s0
ffffffffc0200f22:	97b6                	add	a5,a5,a3
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200f24:	07aa                	slli	a5,a5,0xa
ffffffffc0200f26:	8fc5                	or	a5,a5,s1
ffffffffc0200f28:	0017e793          	ori	a5,a5,1
            page_ref_dec(page);
        } else {
            page_remove_pte(pgdir, la, ptep);
        }
    }
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0200f2c:	00f93023          	sd	a5,0(s2)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0200f30:	12000073          	sfence.vma
    tlb_invalidate(pgdir, la);
    return 0;
ffffffffc0200f34:	4501                	li	a0,0
}
ffffffffc0200f36:	70a2                	ld	ra,40(sp)
ffffffffc0200f38:	7402                	ld	s0,32(sp)
ffffffffc0200f3a:	64e2                	ld	s1,24(sp)
ffffffffc0200f3c:	6942                	ld	s2,16(sp)
ffffffffc0200f3e:	69a2                	ld	s3,8(sp)
ffffffffc0200f40:	6145                	addi	sp,sp,48
ffffffffc0200f42:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0200f44:	00010717          	auipc	a4,0x10
ffffffffc0200f48:	51470713          	addi	a4,a4,1300 # ffffffffc0211458 <npage>
ffffffffc0200f4c:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0200f4e:	00279513          	slli	a0,a5,0x2
ffffffffc0200f52:	8131                	srli	a0,a0,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200f54:	04e57663          	bleu	a4,a0,ffffffffc0200fa0 <page_insert+0xce>
    return &pages[PPN(pa) - nbase];
ffffffffc0200f58:	fff807b7          	lui	a5,0xfff80
ffffffffc0200f5c:	953e                	add	a0,a0,a5
ffffffffc0200f5e:	00010997          	auipc	s3,0x10
ffffffffc0200f62:	53a98993          	addi	s3,s3,1338 # ffffffffc0211498 <pages>
ffffffffc0200f66:	0009b783          	ld	a5,0(s3)
ffffffffc0200f6a:	00351713          	slli	a4,a0,0x3
ffffffffc0200f6e:	953a                	add	a0,a0,a4
ffffffffc0200f70:	050e                	slli	a0,a0,0x3
ffffffffc0200f72:	953e                	add	a0,a0,a5
        if (p == page) {
ffffffffc0200f74:	00a40e63          	beq	s0,a0,ffffffffc0200f90 <page_insert+0xbe>
    page->ref -= 1;
ffffffffc0200f78:	411c                	lw	a5,0(a0)
ffffffffc0200f7a:	fff7871b          	addiw	a4,a5,-1
ffffffffc0200f7e:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0200f80:	cb11                	beqz	a4,ffffffffc0200f94 <page_insert+0xc2>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0200f82:	00093023          	sd	zero,0(s2)
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0200f86:	12000073          	sfence.vma
ffffffffc0200f8a:	0009b783          	ld	a5,0(s3)
ffffffffc0200f8e:	bfb5                	j	ffffffffc0200f0a <page_insert+0x38>
    page->ref -= 1;
ffffffffc0200f90:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0200f92:	bfa5                	j	ffffffffc0200f0a <page_insert+0x38>
            free_page(page);
ffffffffc0200f94:	4585                	li	a1,1
ffffffffc0200f96:	bdfff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
ffffffffc0200f9a:	b7e5                	j	ffffffffc0200f82 <page_insert+0xb0>
        return -E_NO_MEM;
ffffffffc0200f9c:	5571                	li	a0,-4
ffffffffc0200f9e:	bf61                	j	ffffffffc0200f36 <page_insert+0x64>
ffffffffc0200fa0:	b31ff0ef          	jal	ra,ffffffffc0200ad0 <pa2page.part.4>

ffffffffc0200fa4 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0200fa4:	00005797          	auipc	a5,0x5
ffffffffc0200fa8:	dac78793          	addi	a5,a5,-596 # ffffffffc0205d50 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200fac:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0200fae:	711d                	addi	sp,sp,-96
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200fb0:	00004517          	auipc	a0,0x4
ffffffffc0200fb4:	d8850513          	addi	a0,a0,-632 # ffffffffc0204d38 <commands+0x900>
void pmm_init(void) {
ffffffffc0200fb8:	ec86                	sd	ra,88(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0200fba:	00010717          	auipc	a4,0x10
ffffffffc0200fbe:	4cf73323          	sd	a5,1222(a4) # ffffffffc0211480 <pmm_manager>
void pmm_init(void) {
ffffffffc0200fc2:	e8a2                	sd	s0,80(sp)
ffffffffc0200fc4:	e4a6                	sd	s1,72(sp)
ffffffffc0200fc6:	e0ca                	sd	s2,64(sp)
ffffffffc0200fc8:	fc4e                	sd	s3,56(sp)
ffffffffc0200fca:	f852                	sd	s4,48(sp)
ffffffffc0200fcc:	f456                	sd	s5,40(sp)
ffffffffc0200fce:	f05a                	sd	s6,32(sp)
ffffffffc0200fd0:	ec5e                	sd	s7,24(sp)
ffffffffc0200fd2:	e862                	sd	s8,16(sp)
ffffffffc0200fd4:	e466                	sd	s9,8(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0200fd6:	00010417          	auipc	s0,0x10
ffffffffc0200fda:	4aa40413          	addi	s0,s0,1194 # ffffffffc0211480 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200fde:	8e0ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    pmm_manager->init();
ffffffffc0200fe2:	601c                	ld	a5,0(s0)
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0200fe4:	49c5                	li	s3,17
ffffffffc0200fe6:	40100a13          	li	s4,1025
    pmm_manager->init();
ffffffffc0200fea:	679c                	ld	a5,8(a5)
ffffffffc0200fec:	00010497          	auipc	s1,0x10
ffffffffc0200ff0:	46c48493          	addi	s1,s1,1132 # ffffffffc0211458 <npage>
ffffffffc0200ff4:	00010917          	auipc	s2,0x10
ffffffffc0200ff8:	4a490913          	addi	s2,s2,1188 # ffffffffc0211498 <pages>
ffffffffc0200ffc:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0200ffe:	57f5                	li	a5,-3
ffffffffc0201000:	07fa                	slli	a5,a5,0x1e
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc0201002:	07e006b7          	lui	a3,0x7e00
ffffffffc0201006:	01b99613          	slli	a2,s3,0x1b
ffffffffc020100a:	015a1593          	slli	a1,s4,0x15
ffffffffc020100e:	00004517          	auipc	a0,0x4
ffffffffc0201012:	d4250513          	addi	a0,a0,-702 # ffffffffc0204d50 <commands+0x918>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201016:	00010717          	auipc	a4,0x10
ffffffffc020101a:	46f73923          	sd	a5,1138(a4) # ffffffffc0211488 <va_pa_offset>
    cprintf("membegin %llx memend %llx mem_size %llx\n",mem_begin, mem_end, mem_size);
ffffffffc020101e:	8a0ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("physcial memory map:\n");
ffffffffc0201022:	00004517          	auipc	a0,0x4
ffffffffc0201026:	d5e50513          	addi	a0,a0,-674 # ffffffffc0204d80 <commands+0x948>
ffffffffc020102a:	894ff0ef          	jal	ra,ffffffffc02000be <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc020102e:	01b99693          	slli	a3,s3,0x1b
ffffffffc0201032:	16fd                	addi	a3,a3,-1
ffffffffc0201034:	015a1613          	slli	a2,s4,0x15
ffffffffc0201038:	07e005b7          	lui	a1,0x7e00
ffffffffc020103c:	00004517          	auipc	a0,0x4
ffffffffc0201040:	d5c50513          	addi	a0,a0,-676 # ffffffffc0204d98 <commands+0x960>
ffffffffc0201044:	87aff0ef          	jal	ra,ffffffffc02000be <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201048:	777d                	lui	a4,0xfffff
ffffffffc020104a:	00011797          	auipc	a5,0x11
ffffffffc020104e:	55578793          	addi	a5,a5,1365 # ffffffffc021259f <end+0xfff>
ffffffffc0201052:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0201054:	00088737          	lui	a4,0x88
ffffffffc0201058:	00010697          	auipc	a3,0x10
ffffffffc020105c:	40e6b023          	sd	a4,1024(a3) # ffffffffc0211458 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201060:	00010717          	auipc	a4,0x10
ffffffffc0201064:	42f73c23          	sd	a5,1080(a4) # ffffffffc0211498 <pages>
ffffffffc0201068:	4681                	li	a3,0
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020106a:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020106c:	4585                	li	a1,1
ffffffffc020106e:	fff80637          	lui	a2,0xfff80
ffffffffc0201072:	a019                	j	ffffffffc0201078 <pmm_init+0xd4>
ffffffffc0201074:	00093783          	ld	a5,0(s2)
        SetPageReserved(pages + i);
ffffffffc0201078:	97b6                	add	a5,a5,a3
ffffffffc020107a:	07a1                	addi	a5,a5,8
ffffffffc020107c:	40b7b02f          	amoor.d	zero,a1,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201080:	609c                	ld	a5,0(s1)
ffffffffc0201082:	0705                	addi	a4,a4,1
ffffffffc0201084:	04868693          	addi	a3,a3,72
ffffffffc0201088:	00c78533          	add	a0,a5,a2
ffffffffc020108c:	fea764e3          	bltu	a4,a0,ffffffffc0201074 <pmm_init+0xd0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201090:	00093503          	ld	a0,0(s2)
ffffffffc0201094:	00379693          	slli	a3,a5,0x3
ffffffffc0201098:	96be                	add	a3,a3,a5
ffffffffc020109a:	fdc00737          	lui	a4,0xfdc00
ffffffffc020109e:	972a                	add	a4,a4,a0
ffffffffc02010a0:	068e                	slli	a3,a3,0x3
ffffffffc02010a2:	96ba                	add	a3,a3,a4
ffffffffc02010a4:	c0200737          	lui	a4,0xc0200
ffffffffc02010a8:	58e6ea63          	bltu	a3,a4,ffffffffc020163c <pmm_init+0x698>
ffffffffc02010ac:	00010997          	auipc	s3,0x10
ffffffffc02010b0:	3dc98993          	addi	s3,s3,988 # ffffffffc0211488 <va_pa_offset>
ffffffffc02010b4:	0009b703          	ld	a4,0(s3)
    if (freemem < mem_end) {
ffffffffc02010b8:	45c5                	li	a1,17
ffffffffc02010ba:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02010bc:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc02010be:	44b6ef63          	bltu	a3,a1,ffffffffc020151c <pmm_init+0x578>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc02010c2:	601c                	ld	a5,0(s0)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc02010c4:	00010417          	auipc	s0,0x10
ffffffffc02010c8:	38c40413          	addi	s0,s0,908 # ffffffffc0211450 <boot_pgdir>
    pmm_manager->check();
ffffffffc02010cc:	7b9c                	ld	a5,48(a5)
ffffffffc02010ce:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02010d0:	00004517          	auipc	a0,0x4
ffffffffc02010d4:	d1850513          	addi	a0,a0,-744 # ffffffffc0204de8 <commands+0x9b0>
ffffffffc02010d8:	fe7fe0ef          	jal	ra,ffffffffc02000be <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc02010dc:	00008697          	auipc	a3,0x8
ffffffffc02010e0:	f2468693          	addi	a3,a3,-220 # ffffffffc0209000 <boot_page_table_sv39>
ffffffffc02010e4:	00010797          	auipc	a5,0x10
ffffffffc02010e8:	36d7b623          	sd	a3,876(a5) # ffffffffc0211450 <boot_pgdir>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc02010ec:	c02007b7          	lui	a5,0xc0200
ffffffffc02010f0:	0ef6ece3          	bltu	a3,a5,ffffffffc02019e8 <pmm_init+0xa44>
ffffffffc02010f4:	0009b783          	ld	a5,0(s3)
ffffffffc02010f8:	8e9d                	sub	a3,a3,a5
ffffffffc02010fa:	00010797          	auipc	a5,0x10
ffffffffc02010fe:	38d7bb23          	sd	a3,918(a5) # ffffffffc0211490 <boot_cr3>
    // assert(npage <= KMEMSIZE / PGSIZE);
    // The memory starts at 2GB in RISC-V
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();
ffffffffc0201102:	ab9ff0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0201106:	6098                	ld	a4,0(s1)
ffffffffc0201108:	c80007b7          	lui	a5,0xc8000
ffffffffc020110c:	83b1                	srli	a5,a5,0xc
    nr_free_store=nr_free_pages();
ffffffffc020110e:	8a2a                	mv	s4,a0
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0201110:	0ae7ece3          	bltu	a5,a4,ffffffffc02019c8 <pmm_init+0xa24>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0201114:	6008                	ld	a0,0(s0)
ffffffffc0201116:	4c050363          	beqz	a0,ffffffffc02015dc <pmm_init+0x638>
ffffffffc020111a:	6785                	lui	a5,0x1
ffffffffc020111c:	17fd                	addi	a5,a5,-1
ffffffffc020111e:	8fe9                	and	a5,a5,a0
ffffffffc0201120:	2781                	sext.w	a5,a5
ffffffffc0201122:	4a079d63          	bnez	a5,ffffffffc02015dc <pmm_init+0x638>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0201126:	4601                	li	a2,0
ffffffffc0201128:	4581                	li	a1,0
ffffffffc020112a:	ccfff0ef          	jal	ra,ffffffffc0200df8 <get_page>
ffffffffc020112e:	4c051763          	bnez	a0,ffffffffc02015fc <pmm_init+0x658>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc0201132:	4505                	li	a0,1
ffffffffc0201134:	9b9ff0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0201138:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc020113a:	6008                	ld	a0,0(s0)
ffffffffc020113c:	4681                	li	a3,0
ffffffffc020113e:	4601                	li	a2,0
ffffffffc0201140:	85d6                	mv	a1,s5
ffffffffc0201142:	d91ff0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
ffffffffc0201146:	52051763          	bnez	a0,ffffffffc0201674 <pmm_init+0x6d0>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc020114a:	6008                	ld	a0,0(s0)
ffffffffc020114c:	4601                	li	a2,0
ffffffffc020114e:	4581                	li	a1,0
ffffffffc0201150:	aabff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
ffffffffc0201154:	50050063          	beqz	a0,ffffffffc0201654 <pmm_init+0x6b0>
    assert(pte2page(*ptep) == p1);
ffffffffc0201158:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc020115a:	0017f713          	andi	a4,a5,1
ffffffffc020115e:	46070363          	beqz	a4,ffffffffc02015c4 <pmm_init+0x620>
    if (PPN(pa) >= npage) {
ffffffffc0201162:	6090                	ld	a2,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201164:	078a                	slli	a5,a5,0x2
ffffffffc0201166:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201168:	44c7f063          	bleu	a2,a5,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc020116c:	fff80737          	lui	a4,0xfff80
ffffffffc0201170:	97ba                	add	a5,a5,a4
ffffffffc0201172:	00379713          	slli	a4,a5,0x3
ffffffffc0201176:	00093683          	ld	a3,0(s2)
ffffffffc020117a:	97ba                	add	a5,a5,a4
ffffffffc020117c:	078e                	slli	a5,a5,0x3
ffffffffc020117e:	97b6                	add	a5,a5,a3
ffffffffc0201180:	5efa9463          	bne	s5,a5,ffffffffc0201768 <pmm_init+0x7c4>
    assert(page_ref(p1) == 1);
ffffffffc0201184:	000aab83          	lw	s7,0(s5)
ffffffffc0201188:	4785                	li	a5,1
ffffffffc020118a:	5afb9f63          	bne	s7,a5,ffffffffc0201748 <pmm_init+0x7a4>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc020118e:	6008                	ld	a0,0(s0)
ffffffffc0201190:	76fd                	lui	a3,0xfffff
ffffffffc0201192:	611c                	ld	a5,0(a0)
ffffffffc0201194:	078a                	slli	a5,a5,0x2
ffffffffc0201196:	8ff5                	and	a5,a5,a3
ffffffffc0201198:	00c7d713          	srli	a4,a5,0xc
ffffffffc020119c:	58c77963          	bleu	a2,a4,ffffffffc020172e <pmm_init+0x78a>
ffffffffc02011a0:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02011a4:	97e2                	add	a5,a5,s8
ffffffffc02011a6:	0007bb03          	ld	s6,0(a5) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc02011aa:	0b0a                	slli	s6,s6,0x2
ffffffffc02011ac:	00db7b33          	and	s6,s6,a3
ffffffffc02011b0:	00cb5793          	srli	a5,s6,0xc
ffffffffc02011b4:	56c7f063          	bleu	a2,a5,ffffffffc0201714 <pmm_init+0x770>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02011b8:	4601                	li	a2,0
ffffffffc02011ba:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02011bc:	9b62                	add	s6,s6,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02011be:	a3dff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02011c2:	0b21                	addi	s6,s6,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02011c4:	53651863          	bne	a0,s6,ffffffffc02016f4 <pmm_init+0x750>

    p2 = alloc_page();
ffffffffc02011c8:	4505                	li	a0,1
ffffffffc02011ca:	923ff0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc02011ce:	8b2a                	mv	s6,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02011d0:	6008                	ld	a0,0(s0)
ffffffffc02011d2:	46d1                	li	a3,20
ffffffffc02011d4:	6605                	lui	a2,0x1
ffffffffc02011d6:	85da                	mv	a1,s6
ffffffffc02011d8:	cfbff0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
ffffffffc02011dc:	4e051c63          	bnez	a0,ffffffffc02016d4 <pmm_init+0x730>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02011e0:	6008                	ld	a0,0(s0)
ffffffffc02011e2:	4601                	li	a2,0
ffffffffc02011e4:	6585                	lui	a1,0x1
ffffffffc02011e6:	a15ff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
ffffffffc02011ea:	4c050563          	beqz	a0,ffffffffc02016b4 <pmm_init+0x710>
    assert(*ptep & PTE_U);
ffffffffc02011ee:	611c                	ld	a5,0(a0)
ffffffffc02011f0:	0107f713          	andi	a4,a5,16
ffffffffc02011f4:	4a070063          	beqz	a4,ffffffffc0201694 <pmm_init+0x6f0>
    assert(*ptep & PTE_W);
ffffffffc02011f8:	8b91                	andi	a5,a5,4
ffffffffc02011fa:	66078763          	beqz	a5,ffffffffc0201868 <pmm_init+0x8c4>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc02011fe:	6008                	ld	a0,0(s0)
ffffffffc0201200:	611c                	ld	a5,0(a0)
ffffffffc0201202:	8bc1                	andi	a5,a5,16
ffffffffc0201204:	64078263          	beqz	a5,ffffffffc0201848 <pmm_init+0x8a4>
    assert(page_ref(p2) == 1);
ffffffffc0201208:	000b2783          	lw	a5,0(s6)
ffffffffc020120c:	61779e63          	bne	a5,s7,ffffffffc0201828 <pmm_init+0x884>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0201210:	4681                	li	a3,0
ffffffffc0201212:	6605                	lui	a2,0x1
ffffffffc0201214:	85d6                	mv	a1,s5
ffffffffc0201216:	cbdff0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
ffffffffc020121a:	5e051763          	bnez	a0,ffffffffc0201808 <pmm_init+0x864>
    assert(page_ref(p1) == 2);
ffffffffc020121e:	000aa703          	lw	a4,0(s5)
ffffffffc0201222:	4789                	li	a5,2
ffffffffc0201224:	5cf71263          	bne	a4,a5,ffffffffc02017e8 <pmm_init+0x844>
    assert(page_ref(p2) == 0);
ffffffffc0201228:	000b2783          	lw	a5,0(s6)
ffffffffc020122c:	58079e63          	bnez	a5,ffffffffc02017c8 <pmm_init+0x824>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0201230:	6008                	ld	a0,0(s0)
ffffffffc0201232:	4601                	li	a2,0
ffffffffc0201234:	6585                	lui	a1,0x1
ffffffffc0201236:	9c5ff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
ffffffffc020123a:	56050763          	beqz	a0,ffffffffc02017a8 <pmm_init+0x804>
    assert(pte2page(*ptep) == p1);
ffffffffc020123e:	6114                	ld	a3,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0201240:	0016f793          	andi	a5,a3,1
ffffffffc0201244:	38078063          	beqz	a5,ffffffffc02015c4 <pmm_init+0x620>
    if (PPN(pa) >= npage) {
ffffffffc0201248:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020124a:	00269793          	slli	a5,a3,0x2
ffffffffc020124e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201250:	34e7fc63          	bleu	a4,a5,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc0201254:	fff80737          	lui	a4,0xfff80
ffffffffc0201258:	97ba                	add	a5,a5,a4
ffffffffc020125a:	00379713          	slli	a4,a5,0x3
ffffffffc020125e:	00093603          	ld	a2,0(s2)
ffffffffc0201262:	97ba                	add	a5,a5,a4
ffffffffc0201264:	078e                	slli	a5,a5,0x3
ffffffffc0201266:	97b2                	add	a5,a5,a2
ffffffffc0201268:	52fa9063          	bne	s5,a5,ffffffffc0201788 <pmm_init+0x7e4>
    assert((*ptep & PTE_U) == 0);
ffffffffc020126c:	8ac1                	andi	a3,a3,16
ffffffffc020126e:	6e069d63          	bnez	a3,ffffffffc0201968 <pmm_init+0x9c4>

    page_remove(boot_pgdir, 0x0);
ffffffffc0201272:	6008                	ld	a0,0(s0)
ffffffffc0201274:	4581                	li	a1,0
ffffffffc0201276:	bebff0ef          	jal	ra,ffffffffc0200e60 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020127a:	000aa703          	lw	a4,0(s5)
ffffffffc020127e:	4785                	li	a5,1
ffffffffc0201280:	6cf71463          	bne	a4,a5,ffffffffc0201948 <pmm_init+0x9a4>
    assert(page_ref(p2) == 0);
ffffffffc0201284:	000b2783          	lw	a5,0(s6)
ffffffffc0201288:	6a079063          	bnez	a5,ffffffffc0201928 <pmm_init+0x984>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc020128c:	6008                	ld	a0,0(s0)
ffffffffc020128e:	6585                	lui	a1,0x1
ffffffffc0201290:	bd1ff0ef          	jal	ra,ffffffffc0200e60 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0201294:	000aa783          	lw	a5,0(s5)
ffffffffc0201298:	66079863          	bnez	a5,ffffffffc0201908 <pmm_init+0x964>
    assert(page_ref(p2) == 0);
ffffffffc020129c:	000b2783          	lw	a5,0(s6)
ffffffffc02012a0:	70079463          	bnez	a5,ffffffffc02019a8 <pmm_init+0xa04>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc02012a4:	00043b03          	ld	s6,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc02012a8:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02012aa:	000b3783          	ld	a5,0(s6)
ffffffffc02012ae:	078a                	slli	a5,a5,0x2
ffffffffc02012b0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02012b2:	2eb7fb63          	bleu	a1,a5,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc02012b6:	fff80737          	lui	a4,0xfff80
ffffffffc02012ba:	973e                	add	a4,a4,a5
ffffffffc02012bc:	00371793          	slli	a5,a4,0x3
ffffffffc02012c0:	00093603          	ld	a2,0(s2)
ffffffffc02012c4:	97ba                	add	a5,a5,a4
ffffffffc02012c6:	078e                	slli	a5,a5,0x3
ffffffffc02012c8:	00f60733          	add	a4,a2,a5
ffffffffc02012cc:	4314                	lw	a3,0(a4)
ffffffffc02012ce:	4705                	li	a4,1
ffffffffc02012d0:	6ae69c63          	bne	a3,a4,ffffffffc0201988 <pmm_init+0x9e4>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02012d4:	00004a97          	auipc	s5,0x4
ffffffffc02012d8:	99ca8a93          	addi	s5,s5,-1636 # ffffffffc0204c70 <commands+0x838>
ffffffffc02012dc:	000ab703          	ld	a4,0(s5)
ffffffffc02012e0:	4037d693          	srai	a3,a5,0x3
ffffffffc02012e4:	00080bb7          	lui	s7,0x80
ffffffffc02012e8:	02e686b3          	mul	a3,a3,a4
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02012ec:	577d                	li	a4,-1
ffffffffc02012ee:	8331                	srli	a4,a4,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc02012f0:	96de                	add	a3,a3,s7
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02012f2:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02012f4:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02012f6:	2ab77b63          	bleu	a1,a4,ffffffffc02015ac <pmm_init+0x608>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02012fa:	0009b783          	ld	a5,0(s3)
ffffffffc02012fe:	96be                	add	a3,a3,a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0201300:	629c                	ld	a5,0(a3)
ffffffffc0201302:	078a                	slli	a5,a5,0x2
ffffffffc0201304:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201306:	2ab7f163          	bleu	a1,a5,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc020130a:	417787b3          	sub	a5,a5,s7
ffffffffc020130e:	00379513          	slli	a0,a5,0x3
ffffffffc0201312:	97aa                	add	a5,a5,a0
ffffffffc0201314:	00379513          	slli	a0,a5,0x3
ffffffffc0201318:	9532                	add	a0,a0,a2
ffffffffc020131a:	4585                	li	a1,1
ffffffffc020131c:	859ff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0201320:	000b3503          	ld	a0,0(s6)
    if (PPN(pa) >= npage) {
ffffffffc0201324:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201326:	050a                	slli	a0,a0,0x2
ffffffffc0201328:	8131                	srli	a0,a0,0xc
    if (PPN(pa) >= npage) {
ffffffffc020132a:	26f57f63          	bleu	a5,a0,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc020132e:	417507b3          	sub	a5,a0,s7
ffffffffc0201332:	00379513          	slli	a0,a5,0x3
ffffffffc0201336:	00093703          	ld	a4,0(s2)
ffffffffc020133a:	953e                	add	a0,a0,a5
ffffffffc020133c:	050e                	slli	a0,a0,0x3
    free_page(pde2page(pd1[0]));
ffffffffc020133e:	4585                	li	a1,1
ffffffffc0201340:	953a                	add	a0,a0,a4
ffffffffc0201342:	833ff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    boot_pgdir[0] = 0;
ffffffffc0201346:	601c                	ld	a5,0(s0)
ffffffffc0201348:	0007b023          	sd	zero,0(a5)

    assert(nr_free_store==nr_free_pages());
ffffffffc020134c:	86fff0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc0201350:	2caa1663          	bne	s4,a0,ffffffffc020161c <pmm_init+0x678>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0201354:	00004517          	auipc	a0,0x4
ffffffffc0201358:	dbc50513          	addi	a0,a0,-580 # ffffffffc0205110 <commands+0xcd8>
ffffffffc020135c:	d63fe0ef          	jal	ra,ffffffffc02000be <cprintf>
static void check_boot_pgdir(void) {
    size_t nr_free_store;
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();
ffffffffc0201360:	85bff0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201364:	6098                	ld	a4,0(s1)
ffffffffc0201366:	c02007b7          	lui	a5,0xc0200
    nr_free_store=nr_free_pages();
ffffffffc020136a:	8b2a                	mv	s6,a0
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc020136c:	00c71693          	slli	a3,a4,0xc
ffffffffc0201370:	1cd7fd63          	bleu	a3,a5,ffffffffc020154a <pmm_init+0x5a6>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201374:	83b1                	srli	a5,a5,0xc
ffffffffc0201376:	6008                	ld	a0,0(s0)
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201378:	c0200a37          	lui	s4,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020137c:	1ce7f963          	bleu	a4,a5,ffffffffc020154e <pmm_init+0x5aa>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201380:	7c7d                	lui	s8,0xfffff
ffffffffc0201382:	6b85                	lui	s7,0x1
ffffffffc0201384:	a029                	j	ffffffffc020138e <pmm_init+0x3ea>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201386:	00ca5713          	srli	a4,s4,0xc
ffffffffc020138a:	1cf77263          	bleu	a5,a4,ffffffffc020154e <pmm_init+0x5aa>
ffffffffc020138e:	0009b583          	ld	a1,0(s3)
ffffffffc0201392:	4601                	li	a2,0
ffffffffc0201394:	95d2                	add	a1,a1,s4
ffffffffc0201396:	865ff0ef          	jal	ra,ffffffffc0200bfa <get_pte>
ffffffffc020139a:	1c050763          	beqz	a0,ffffffffc0201568 <pmm_init+0x5c4>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020139e:	611c                	ld	a5,0(a0)
ffffffffc02013a0:	078a                	slli	a5,a5,0x2
ffffffffc02013a2:	0187f7b3          	and	a5,a5,s8
ffffffffc02013a6:	1f479163          	bne	a5,s4,ffffffffc0201588 <pmm_init+0x5e4>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02013aa:	609c                	ld	a5,0(s1)
ffffffffc02013ac:	9a5e                	add	s4,s4,s7
ffffffffc02013ae:	6008                	ld	a0,0(s0)
ffffffffc02013b0:	00c79713          	slli	a4,a5,0xc
ffffffffc02013b4:	fcea69e3          	bltu	s4,a4,ffffffffc0201386 <pmm_init+0x3e2>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc02013b8:	611c                	ld	a5,0(a0)
ffffffffc02013ba:	6a079363          	bnez	a5,ffffffffc0201a60 <pmm_init+0xabc>

    struct Page *p;
    p = alloc_page();
ffffffffc02013be:	4505                	li	a0,1
ffffffffc02013c0:	f2cff0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc02013c4:	8a2a                	mv	s4,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02013c6:	6008                	ld	a0,0(s0)
ffffffffc02013c8:	4699                	li	a3,6
ffffffffc02013ca:	10000613          	li	a2,256
ffffffffc02013ce:	85d2                	mv	a1,s4
ffffffffc02013d0:	b03ff0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
ffffffffc02013d4:	66051663          	bnez	a0,ffffffffc0201a40 <pmm_init+0xa9c>
    assert(page_ref(p) == 1);
ffffffffc02013d8:	000a2703          	lw	a4,0(s4) # ffffffffc0200000 <kern_entry>
ffffffffc02013dc:	4785                	li	a5,1
ffffffffc02013de:	64f71163          	bne	a4,a5,ffffffffc0201a20 <pmm_init+0xa7c>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02013e2:	6008                	ld	a0,0(s0)
ffffffffc02013e4:	6b85                	lui	s7,0x1
ffffffffc02013e6:	4699                	li	a3,6
ffffffffc02013e8:	100b8613          	addi	a2,s7,256 # 1100 <BASE_ADDRESS-0xffffffffc01fef00>
ffffffffc02013ec:	85d2                	mv	a1,s4
ffffffffc02013ee:	ae5ff0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
ffffffffc02013f2:	60051763          	bnez	a0,ffffffffc0201a00 <pmm_init+0xa5c>
    assert(page_ref(p) == 2);
ffffffffc02013f6:	000a2703          	lw	a4,0(s4)
ffffffffc02013fa:	4789                	li	a5,2
ffffffffc02013fc:	4ef71663          	bne	a4,a5,ffffffffc02018e8 <pmm_init+0x944>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0201400:	00004597          	auipc	a1,0x4
ffffffffc0201404:	e4858593          	addi	a1,a1,-440 # ffffffffc0205248 <commands+0xe10>
ffffffffc0201408:	10000513          	li	a0,256
ffffffffc020140c:	1a9020ef          	jal	ra,ffffffffc0203db4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201410:	100b8593          	addi	a1,s7,256
ffffffffc0201414:	10000513          	li	a0,256
ffffffffc0201418:	1af020ef          	jal	ra,ffffffffc0203dc6 <strcmp>
ffffffffc020141c:	4a051663          	bnez	a0,ffffffffc02018c8 <pmm_init+0x924>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201420:	00093683          	ld	a3,0(s2)
ffffffffc0201424:	000abc83          	ld	s9,0(s5)
ffffffffc0201428:	00080c37          	lui	s8,0x80
ffffffffc020142c:	40da06b3          	sub	a3,s4,a3
ffffffffc0201430:	868d                	srai	a3,a3,0x3
ffffffffc0201432:	039686b3          	mul	a3,a3,s9
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201436:	5afd                	li	s5,-1
ffffffffc0201438:	609c                	ld	a5,0(s1)
ffffffffc020143a:	00cada93          	srli	s5,s5,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020143e:	96e2                	add	a3,a3,s8
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201440:	0156f733          	and	a4,a3,s5
    return page2ppn(page) << PGSHIFT;
ffffffffc0201444:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201446:	16f77363          	bleu	a5,a4,ffffffffc02015ac <pmm_init+0x608>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020144a:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc020144e:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201452:	96be                	add	a3,a3,a5
ffffffffc0201454:	10068023          	sb	zero,256(a3) # fffffffffffff100 <end+0x3fdedb60>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201458:	119020ef          	jal	ra,ffffffffc0203d70 <strlen>
ffffffffc020145c:	44051663          	bnez	a0,ffffffffc02018a8 <pmm_init+0x904>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0201460:	00043b83          	ld	s7,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0201464:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201466:	000bb783          	ld	a5,0(s7)
ffffffffc020146a:	078a                	slli	a5,a5,0x2
ffffffffc020146c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020146e:	12e7fd63          	bleu	a4,a5,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc0201472:	418787b3          	sub	a5,a5,s8
ffffffffc0201476:	00379693          	slli	a3,a5,0x3
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020147a:	96be                	add	a3,a3,a5
ffffffffc020147c:	039686b3          	mul	a3,a3,s9
ffffffffc0201480:	96e2                	add	a3,a3,s8
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201482:	0156fab3          	and	s5,a3,s5
    return page2ppn(page) << PGSHIFT;
ffffffffc0201486:	06b2                	slli	a3,a3,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201488:	12eaf263          	bleu	a4,s5,ffffffffc02015ac <pmm_init+0x608>
ffffffffc020148c:	0009b983          	ld	s3,0(s3)
    free_page(p);
ffffffffc0201490:	4585                	li	a1,1
ffffffffc0201492:	8552                	mv	a0,s4
ffffffffc0201494:	99b6                	add	s3,s3,a3
ffffffffc0201496:	edeff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc020149a:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage) {
ffffffffc020149e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02014a0:	078a                	slli	a5,a5,0x2
ffffffffc02014a2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02014a4:	10e7f263          	bleu	a4,a5,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc02014a8:	fff809b7          	lui	s3,0xfff80
ffffffffc02014ac:	97ce                	add	a5,a5,s3
ffffffffc02014ae:	00379513          	slli	a0,a5,0x3
ffffffffc02014b2:	00093703          	ld	a4,0(s2)
ffffffffc02014b6:	97aa                	add	a5,a5,a0
ffffffffc02014b8:	00379513          	slli	a0,a5,0x3
    free_page(pde2page(pd0[0]));
ffffffffc02014bc:	953a                	add	a0,a0,a4
ffffffffc02014be:	4585                	li	a1,1
ffffffffc02014c0:	eb4ff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc02014c4:	000bb503          	ld	a0,0(s7)
    if (PPN(pa) >= npage) {
ffffffffc02014c8:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02014ca:	050a                	slli	a0,a0,0x2
ffffffffc02014cc:	8131                	srli	a0,a0,0xc
    if (PPN(pa) >= npage) {
ffffffffc02014ce:	0cf57d63          	bleu	a5,a0,ffffffffc02015a8 <pmm_init+0x604>
    return &pages[PPN(pa) - nbase];
ffffffffc02014d2:	013507b3          	add	a5,a0,s3
ffffffffc02014d6:	00379513          	slli	a0,a5,0x3
ffffffffc02014da:	00093703          	ld	a4,0(s2)
ffffffffc02014de:	953e                	add	a0,a0,a5
ffffffffc02014e0:	050e                	slli	a0,a0,0x3
    free_page(pde2page(pd1[0]));
ffffffffc02014e2:	4585                	li	a1,1
ffffffffc02014e4:	953a                	add	a0,a0,a4
ffffffffc02014e6:	e8eff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    boot_pgdir[0] = 0;
ffffffffc02014ea:	601c                	ld	a5,0(s0)
ffffffffc02014ec:	0007b023          	sd	zero,0(a5) # ffffffffc0200000 <kern_entry>

    assert(nr_free_store==nr_free_pages());
ffffffffc02014f0:	ecaff0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc02014f4:	38ab1a63          	bne	s6,a0,ffffffffc0201888 <pmm_init+0x8e4>
}
ffffffffc02014f8:	6446                	ld	s0,80(sp)
ffffffffc02014fa:	60e6                	ld	ra,88(sp)
ffffffffc02014fc:	64a6                	ld	s1,72(sp)
ffffffffc02014fe:	6906                	ld	s2,64(sp)
ffffffffc0201500:	79e2                	ld	s3,56(sp)
ffffffffc0201502:	7a42                	ld	s4,48(sp)
ffffffffc0201504:	7aa2                	ld	s5,40(sp)
ffffffffc0201506:	7b02                	ld	s6,32(sp)
ffffffffc0201508:	6be2                	ld	s7,24(sp)
ffffffffc020150a:	6c42                	ld	s8,16(sp)
ffffffffc020150c:	6ca2                	ld	s9,8(sp)

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc020150e:	00004517          	auipc	a0,0x4
ffffffffc0201512:	db250513          	addi	a0,a0,-590 # ffffffffc02052c0 <commands+0xe88>
}
ffffffffc0201516:	6125                	addi	sp,sp,96
    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0201518:	ba7fe06f          	j	ffffffffc02000be <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020151c:	6705                	lui	a4,0x1
ffffffffc020151e:	177d                	addi	a4,a4,-1
ffffffffc0201520:	96ba                	add	a3,a3,a4
    if (PPN(pa) >= npage) {
ffffffffc0201522:	00c6d713          	srli	a4,a3,0xc
ffffffffc0201526:	08f77163          	bleu	a5,a4,ffffffffc02015a8 <pmm_init+0x604>
    pmm_manager->init_memmap(base, n);
ffffffffc020152a:	00043803          	ld	a6,0(s0)
    return &pages[PPN(pa) - nbase];
ffffffffc020152e:	9732                	add	a4,a4,a2
ffffffffc0201530:	00371793          	slli	a5,a4,0x3
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201534:	767d                	lui	a2,0xfffff
ffffffffc0201536:	8ef1                	and	a3,a3,a2
ffffffffc0201538:	97ba                	add	a5,a5,a4
    pmm_manager->init_memmap(base, n);
ffffffffc020153a:	01083703          	ld	a4,16(a6)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020153e:	8d95                	sub	a1,a1,a3
ffffffffc0201540:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0201542:	81b1                	srli	a1,a1,0xc
ffffffffc0201544:	953e                	add	a0,a0,a5
ffffffffc0201546:	9702                	jalr	a4
ffffffffc0201548:	bead                	j	ffffffffc02010c2 <pmm_init+0x11e>
ffffffffc020154a:	6008                	ld	a0,0(s0)
ffffffffc020154c:	b5b5                	j	ffffffffc02013b8 <pmm_init+0x414>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020154e:	86d2                	mv	a3,s4
ffffffffc0201550:	00003617          	auipc	a2,0x3
ffffffffc0201554:	72860613          	addi	a2,a2,1832 # ffffffffc0204c78 <commands+0x840>
ffffffffc0201558:	1cd00593          	li	a1,461
ffffffffc020155c:	00003517          	auipc	a0,0x3
ffffffffc0201560:	74450513          	addi	a0,a0,1860 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201564:	ba3fe0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0201568:	00004697          	auipc	a3,0x4
ffffffffc020156c:	bc868693          	addi	a3,a3,-1080 # ffffffffc0205130 <commands+0xcf8>
ffffffffc0201570:	00004617          	auipc	a2,0x4
ffffffffc0201574:	8b860613          	addi	a2,a2,-1864 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201578:	1cd00593          	li	a1,461
ffffffffc020157c:	00003517          	auipc	a0,0x3
ffffffffc0201580:	72450513          	addi	a0,a0,1828 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201584:	b83fe0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201588:	00004697          	auipc	a3,0x4
ffffffffc020158c:	be868693          	addi	a3,a3,-1048 # ffffffffc0205170 <commands+0xd38>
ffffffffc0201590:	00004617          	auipc	a2,0x4
ffffffffc0201594:	89860613          	addi	a2,a2,-1896 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201598:	1ce00593          	li	a1,462
ffffffffc020159c:	00003517          	auipc	a0,0x3
ffffffffc02015a0:	70450513          	addi	a0,a0,1796 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02015a4:	b63fe0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc02015a8:	d28ff0ef          	jal	ra,ffffffffc0200ad0 <pa2page.part.4>
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc02015ac:	00003617          	auipc	a2,0x3
ffffffffc02015b0:	6cc60613          	addi	a2,a2,1740 # ffffffffc0204c78 <commands+0x840>
ffffffffc02015b4:	06a00593          	li	a1,106
ffffffffc02015b8:	00003517          	auipc	a0,0x3
ffffffffc02015bc:	75850513          	addi	a0,a0,1880 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc02015c0:	b47fe0ef          	jal	ra,ffffffffc0200106 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02015c4:	00004617          	auipc	a2,0x4
ffffffffc02015c8:	93c60613          	addi	a2,a2,-1732 # ffffffffc0204f00 <commands+0xac8>
ffffffffc02015cc:	07000593          	li	a1,112
ffffffffc02015d0:	00003517          	auipc	a0,0x3
ffffffffc02015d4:	74050513          	addi	a0,a0,1856 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc02015d8:	b2ffe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02015dc:	00004697          	auipc	a3,0x4
ffffffffc02015e0:	86468693          	addi	a3,a3,-1948 # ffffffffc0204e40 <commands+0xa08>
ffffffffc02015e4:	00004617          	auipc	a2,0x4
ffffffffc02015e8:	84460613          	addi	a2,a2,-1980 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02015ec:	19300593          	li	a1,403
ffffffffc02015f0:	00003517          	auipc	a0,0x3
ffffffffc02015f4:	6b050513          	addi	a0,a0,1712 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02015f8:	b0ffe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02015fc:	00004697          	auipc	a3,0x4
ffffffffc0201600:	87c68693          	addi	a3,a3,-1924 # ffffffffc0204e78 <commands+0xa40>
ffffffffc0201604:	00004617          	auipc	a2,0x4
ffffffffc0201608:	82460613          	addi	a2,a2,-2012 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020160c:	19400593          	li	a1,404
ffffffffc0201610:	00003517          	auipc	a0,0x3
ffffffffc0201614:	69050513          	addi	a0,a0,1680 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201618:	aeffe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc020161c:	00004697          	auipc	a3,0x4
ffffffffc0201620:	ad468693          	addi	a3,a3,-1324 # ffffffffc02050f0 <commands+0xcb8>
ffffffffc0201624:	00004617          	auipc	a2,0x4
ffffffffc0201628:	80460613          	addi	a2,a2,-2044 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020162c:	1c000593          	li	a1,448
ffffffffc0201630:	00003517          	auipc	a0,0x3
ffffffffc0201634:	67050513          	addi	a0,a0,1648 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201638:	acffe0ef          	jal	ra,ffffffffc0200106 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020163c:	00003617          	auipc	a2,0x3
ffffffffc0201640:	78460613          	addi	a2,a2,1924 # ffffffffc0204dc0 <commands+0x988>
ffffffffc0201644:	07700593          	li	a1,119
ffffffffc0201648:	00003517          	auipc	a0,0x3
ffffffffc020164c:	65850513          	addi	a0,a0,1624 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201650:	ab7fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0201654:	00004697          	auipc	a3,0x4
ffffffffc0201658:	87c68693          	addi	a3,a3,-1924 # ffffffffc0204ed0 <commands+0xa98>
ffffffffc020165c:	00003617          	auipc	a2,0x3
ffffffffc0201660:	7cc60613          	addi	a2,a2,1996 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201664:	19a00593          	li	a1,410
ffffffffc0201668:	00003517          	auipc	a0,0x3
ffffffffc020166c:	63850513          	addi	a0,a0,1592 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201670:	a97fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0201674:	00004697          	auipc	a3,0x4
ffffffffc0201678:	82c68693          	addi	a3,a3,-2004 # ffffffffc0204ea0 <commands+0xa68>
ffffffffc020167c:	00003617          	auipc	a2,0x3
ffffffffc0201680:	7ac60613          	addi	a2,a2,1964 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201684:	19800593          	li	a1,408
ffffffffc0201688:	00003517          	auipc	a0,0x3
ffffffffc020168c:	61850513          	addi	a0,a0,1560 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201690:	a77fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0201694:	00004697          	auipc	a3,0x4
ffffffffc0201698:	95468693          	addi	a3,a3,-1708 # ffffffffc0204fe8 <commands+0xbb0>
ffffffffc020169c:	00003617          	auipc	a2,0x3
ffffffffc02016a0:	78c60613          	addi	a2,a2,1932 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02016a4:	1a500593          	li	a1,421
ffffffffc02016a8:	00003517          	auipc	a0,0x3
ffffffffc02016ac:	5f850513          	addi	a0,a0,1528 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02016b0:	a57fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02016b4:	00004697          	auipc	a3,0x4
ffffffffc02016b8:	90468693          	addi	a3,a3,-1788 # ffffffffc0204fb8 <commands+0xb80>
ffffffffc02016bc:	00003617          	auipc	a2,0x3
ffffffffc02016c0:	76c60613          	addi	a2,a2,1900 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02016c4:	1a400593          	li	a1,420
ffffffffc02016c8:	00003517          	auipc	a0,0x3
ffffffffc02016cc:	5d850513          	addi	a0,a0,1496 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02016d0:	a37fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02016d4:	00004697          	auipc	a3,0x4
ffffffffc02016d8:	8ac68693          	addi	a3,a3,-1876 # ffffffffc0204f80 <commands+0xb48>
ffffffffc02016dc:	00003617          	auipc	a2,0x3
ffffffffc02016e0:	74c60613          	addi	a2,a2,1868 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02016e4:	1a300593          	li	a1,419
ffffffffc02016e8:	00003517          	auipc	a0,0x3
ffffffffc02016ec:	5b850513          	addi	a0,a0,1464 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02016f0:	a17fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc02016f4:	00004697          	auipc	a3,0x4
ffffffffc02016f8:	86468693          	addi	a3,a3,-1948 # ffffffffc0204f58 <commands+0xb20>
ffffffffc02016fc:	00003617          	auipc	a2,0x3
ffffffffc0201700:	72c60613          	addi	a2,a2,1836 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201704:	1a000593          	li	a1,416
ffffffffc0201708:	00003517          	auipc	a0,0x3
ffffffffc020170c:	59850513          	addi	a0,a0,1432 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201710:	9f7fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201714:	86da                	mv	a3,s6
ffffffffc0201716:	00003617          	auipc	a2,0x3
ffffffffc020171a:	56260613          	addi	a2,a2,1378 # ffffffffc0204c78 <commands+0x840>
ffffffffc020171e:	19f00593          	li	a1,415
ffffffffc0201722:	00003517          	auipc	a0,0x3
ffffffffc0201726:	57e50513          	addi	a0,a0,1406 # ffffffffc0204ca0 <commands+0x868>
ffffffffc020172a:	9ddfe0ef          	jal	ra,ffffffffc0200106 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc020172e:	86be                	mv	a3,a5
ffffffffc0201730:	00003617          	auipc	a2,0x3
ffffffffc0201734:	54860613          	addi	a2,a2,1352 # ffffffffc0204c78 <commands+0x840>
ffffffffc0201738:	19e00593          	li	a1,414
ffffffffc020173c:	00003517          	auipc	a0,0x3
ffffffffc0201740:	56450513          	addi	a0,a0,1380 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201744:	9c3fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0201748:	00003697          	auipc	a3,0x3
ffffffffc020174c:	7f868693          	addi	a3,a3,2040 # ffffffffc0204f40 <commands+0xb08>
ffffffffc0201750:	00003617          	auipc	a2,0x3
ffffffffc0201754:	6d860613          	addi	a2,a2,1752 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201758:	19c00593          	li	a1,412
ffffffffc020175c:	00003517          	auipc	a0,0x3
ffffffffc0201760:	54450513          	addi	a0,a0,1348 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201764:	9a3fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201768:	00003697          	auipc	a3,0x3
ffffffffc020176c:	7c068693          	addi	a3,a3,1984 # ffffffffc0204f28 <commands+0xaf0>
ffffffffc0201770:	00003617          	auipc	a2,0x3
ffffffffc0201774:	6b860613          	addi	a2,a2,1720 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201778:	19b00593          	li	a1,411
ffffffffc020177c:	00003517          	auipc	a0,0x3
ffffffffc0201780:	52450513          	addi	a0,a0,1316 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201784:	983fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201788:	00003697          	auipc	a3,0x3
ffffffffc020178c:	7a068693          	addi	a3,a3,1952 # ffffffffc0204f28 <commands+0xaf0>
ffffffffc0201790:	00003617          	auipc	a2,0x3
ffffffffc0201794:	69860613          	addi	a2,a2,1688 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201798:	1ae00593          	li	a1,430
ffffffffc020179c:	00003517          	auipc	a0,0x3
ffffffffc02017a0:	50450513          	addi	a0,a0,1284 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02017a4:	963fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02017a8:	00004697          	auipc	a3,0x4
ffffffffc02017ac:	81068693          	addi	a3,a3,-2032 # ffffffffc0204fb8 <commands+0xb80>
ffffffffc02017b0:	00003617          	auipc	a2,0x3
ffffffffc02017b4:	67860613          	addi	a2,a2,1656 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02017b8:	1ad00593          	li	a1,429
ffffffffc02017bc:	00003517          	auipc	a0,0x3
ffffffffc02017c0:	4e450513          	addi	a0,a0,1252 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02017c4:	943fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02017c8:	00004697          	auipc	a3,0x4
ffffffffc02017cc:	8b868693          	addi	a3,a3,-1864 # ffffffffc0205080 <commands+0xc48>
ffffffffc02017d0:	00003617          	auipc	a2,0x3
ffffffffc02017d4:	65860613          	addi	a2,a2,1624 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02017d8:	1ac00593          	li	a1,428
ffffffffc02017dc:	00003517          	auipc	a0,0x3
ffffffffc02017e0:	4c450513          	addi	a0,a0,1220 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02017e4:	923fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02017e8:	00004697          	auipc	a3,0x4
ffffffffc02017ec:	88068693          	addi	a3,a3,-1920 # ffffffffc0205068 <commands+0xc30>
ffffffffc02017f0:	00003617          	auipc	a2,0x3
ffffffffc02017f4:	63860613          	addi	a2,a2,1592 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02017f8:	1ab00593          	li	a1,427
ffffffffc02017fc:	00003517          	auipc	a0,0x3
ffffffffc0201800:	4a450513          	addi	a0,a0,1188 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201804:	903fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0201808:	00004697          	auipc	a3,0x4
ffffffffc020180c:	83068693          	addi	a3,a3,-2000 # ffffffffc0205038 <commands+0xc00>
ffffffffc0201810:	00003617          	auipc	a2,0x3
ffffffffc0201814:	61860613          	addi	a2,a2,1560 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201818:	1aa00593          	li	a1,426
ffffffffc020181c:	00003517          	auipc	a0,0x3
ffffffffc0201820:	48450513          	addi	a0,a0,1156 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201824:	8e3fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0201828:	00003697          	auipc	a3,0x3
ffffffffc020182c:	7f868693          	addi	a3,a3,2040 # ffffffffc0205020 <commands+0xbe8>
ffffffffc0201830:	00003617          	auipc	a2,0x3
ffffffffc0201834:	5f860613          	addi	a2,a2,1528 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201838:	1a800593          	li	a1,424
ffffffffc020183c:	00003517          	auipc	a0,0x3
ffffffffc0201840:	46450513          	addi	a0,a0,1124 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201844:	8c3fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0201848:	00003697          	auipc	a3,0x3
ffffffffc020184c:	7c068693          	addi	a3,a3,1984 # ffffffffc0205008 <commands+0xbd0>
ffffffffc0201850:	00003617          	auipc	a2,0x3
ffffffffc0201854:	5d860613          	addi	a2,a2,1496 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201858:	1a700593          	li	a1,423
ffffffffc020185c:	00003517          	auipc	a0,0x3
ffffffffc0201860:	44450513          	addi	a0,a0,1092 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201864:	8a3fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0201868:	00003697          	auipc	a3,0x3
ffffffffc020186c:	79068693          	addi	a3,a3,1936 # ffffffffc0204ff8 <commands+0xbc0>
ffffffffc0201870:	00003617          	auipc	a2,0x3
ffffffffc0201874:	5b860613          	addi	a2,a2,1464 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201878:	1a600593          	li	a1,422
ffffffffc020187c:	00003517          	auipc	a0,0x3
ffffffffc0201880:	42450513          	addi	a0,a0,1060 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201884:	883fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0201888:	00004697          	auipc	a3,0x4
ffffffffc020188c:	86868693          	addi	a3,a3,-1944 # ffffffffc02050f0 <commands+0xcb8>
ffffffffc0201890:	00003617          	auipc	a2,0x3
ffffffffc0201894:	59860613          	addi	a2,a2,1432 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201898:	1e800593          	li	a1,488
ffffffffc020189c:	00003517          	auipc	a0,0x3
ffffffffc02018a0:	40450513          	addi	a0,a0,1028 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02018a4:	863fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02018a8:	00004697          	auipc	a3,0x4
ffffffffc02018ac:	9f068693          	addi	a3,a3,-1552 # ffffffffc0205298 <commands+0xe60>
ffffffffc02018b0:	00003617          	auipc	a2,0x3
ffffffffc02018b4:	57860613          	addi	a2,a2,1400 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02018b8:	1e000593          	li	a1,480
ffffffffc02018bc:	00003517          	auipc	a0,0x3
ffffffffc02018c0:	3e450513          	addi	a0,a0,996 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02018c4:	843fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02018c8:	00004697          	auipc	a3,0x4
ffffffffc02018cc:	99868693          	addi	a3,a3,-1640 # ffffffffc0205260 <commands+0xe28>
ffffffffc02018d0:	00003617          	auipc	a2,0x3
ffffffffc02018d4:	55860613          	addi	a2,a2,1368 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02018d8:	1dd00593          	li	a1,477
ffffffffc02018dc:	00003517          	auipc	a0,0x3
ffffffffc02018e0:	3c450513          	addi	a0,a0,964 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02018e4:	823fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p) == 2);
ffffffffc02018e8:	00004697          	auipc	a3,0x4
ffffffffc02018ec:	94868693          	addi	a3,a3,-1720 # ffffffffc0205230 <commands+0xdf8>
ffffffffc02018f0:	00003617          	auipc	a2,0x3
ffffffffc02018f4:	53860613          	addi	a2,a2,1336 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02018f8:	1d900593          	li	a1,473
ffffffffc02018fc:	00003517          	auipc	a0,0x3
ffffffffc0201900:	3a450513          	addi	a0,a0,932 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201904:	803fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0201908:	00003697          	auipc	a3,0x3
ffffffffc020190c:	7a868693          	addi	a3,a3,1960 # ffffffffc02050b0 <commands+0xc78>
ffffffffc0201910:	00003617          	auipc	a2,0x3
ffffffffc0201914:	51860613          	addi	a2,a2,1304 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201918:	1b600593          	li	a1,438
ffffffffc020191c:	00003517          	auipc	a0,0x3
ffffffffc0201920:	38450513          	addi	a0,a0,900 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201924:	fe2fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201928:	00003697          	auipc	a3,0x3
ffffffffc020192c:	75868693          	addi	a3,a3,1880 # ffffffffc0205080 <commands+0xc48>
ffffffffc0201930:	00003617          	auipc	a2,0x3
ffffffffc0201934:	4f860613          	addi	a2,a2,1272 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201938:	1b300593          	li	a1,435
ffffffffc020193c:	00003517          	auipc	a0,0x3
ffffffffc0201940:	36450513          	addi	a0,a0,868 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201944:	fc2fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0201948:	00003697          	auipc	a3,0x3
ffffffffc020194c:	5f868693          	addi	a3,a3,1528 # ffffffffc0204f40 <commands+0xb08>
ffffffffc0201950:	00003617          	auipc	a2,0x3
ffffffffc0201954:	4d860613          	addi	a2,a2,1240 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201958:	1b200593          	li	a1,434
ffffffffc020195c:	00003517          	auipc	a0,0x3
ffffffffc0201960:	34450513          	addi	a0,a0,836 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201964:	fa2fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0201968:	00003697          	auipc	a3,0x3
ffffffffc020196c:	73068693          	addi	a3,a3,1840 # ffffffffc0205098 <commands+0xc60>
ffffffffc0201970:	00003617          	auipc	a2,0x3
ffffffffc0201974:	4b860613          	addi	a2,a2,1208 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201978:	1af00593          	li	a1,431
ffffffffc020197c:	00003517          	auipc	a0,0x3
ffffffffc0201980:	32450513          	addi	a0,a0,804 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201984:	f82fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0201988:	00003697          	auipc	a3,0x3
ffffffffc020198c:	74068693          	addi	a3,a3,1856 # ffffffffc02050c8 <commands+0xc90>
ffffffffc0201990:	00003617          	auipc	a2,0x3
ffffffffc0201994:	49860613          	addi	a2,a2,1176 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201998:	1b900593          	li	a1,441
ffffffffc020199c:	00003517          	auipc	a0,0x3
ffffffffc02019a0:	30450513          	addi	a0,a0,772 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02019a4:	f62fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02019a8:	00003697          	auipc	a3,0x3
ffffffffc02019ac:	6d868693          	addi	a3,a3,1752 # ffffffffc0205080 <commands+0xc48>
ffffffffc02019b0:	00003617          	auipc	a2,0x3
ffffffffc02019b4:	47860613          	addi	a2,a2,1144 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02019b8:	1b700593          	li	a1,439
ffffffffc02019bc:	00003517          	auipc	a0,0x3
ffffffffc02019c0:	2e450513          	addi	a0,a0,740 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02019c4:	f42fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02019c8:	00003697          	auipc	a3,0x3
ffffffffc02019cc:	44068693          	addi	a3,a3,1088 # ffffffffc0204e08 <commands+0x9d0>
ffffffffc02019d0:	00003617          	auipc	a2,0x3
ffffffffc02019d4:	45860613          	addi	a2,a2,1112 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02019d8:	19200593          	li	a1,402
ffffffffc02019dc:	00003517          	auipc	a0,0x3
ffffffffc02019e0:	2c450513          	addi	a0,a0,708 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02019e4:	f22fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc02019e8:	00003617          	auipc	a2,0x3
ffffffffc02019ec:	3d860613          	addi	a2,a2,984 # ffffffffc0204dc0 <commands+0x988>
ffffffffc02019f0:	0bd00593          	li	a1,189
ffffffffc02019f4:	00003517          	auipc	a0,0x3
ffffffffc02019f8:	2ac50513          	addi	a0,a0,684 # ffffffffc0204ca0 <commands+0x868>
ffffffffc02019fc:	f0afe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201a00:	00003697          	auipc	a3,0x3
ffffffffc0201a04:	7f068693          	addi	a3,a3,2032 # ffffffffc02051f0 <commands+0xdb8>
ffffffffc0201a08:	00003617          	auipc	a2,0x3
ffffffffc0201a0c:	42060613          	addi	a2,a2,1056 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201a10:	1d800593          	li	a1,472
ffffffffc0201a14:	00003517          	auipc	a0,0x3
ffffffffc0201a18:	28c50513          	addi	a0,a0,652 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201a1c:	eeafe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0201a20:	00003697          	auipc	a3,0x3
ffffffffc0201a24:	7b868693          	addi	a3,a3,1976 # ffffffffc02051d8 <commands+0xda0>
ffffffffc0201a28:	00003617          	auipc	a2,0x3
ffffffffc0201a2c:	40060613          	addi	a2,a2,1024 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201a30:	1d700593          	li	a1,471
ffffffffc0201a34:	00003517          	auipc	a0,0x3
ffffffffc0201a38:	26c50513          	addi	a0,a0,620 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201a3c:	ecafe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201a40:	00003697          	auipc	a3,0x3
ffffffffc0201a44:	76068693          	addi	a3,a3,1888 # ffffffffc02051a0 <commands+0xd68>
ffffffffc0201a48:	00003617          	auipc	a2,0x3
ffffffffc0201a4c:	3e060613          	addi	a2,a2,992 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201a50:	1d600593          	li	a1,470
ffffffffc0201a54:	00003517          	auipc	a0,0x3
ffffffffc0201a58:	24c50513          	addi	a0,a0,588 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201a5c:	eaafe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0201a60:	00003697          	auipc	a3,0x3
ffffffffc0201a64:	72868693          	addi	a3,a3,1832 # ffffffffc0205188 <commands+0xd50>
ffffffffc0201a68:	00003617          	auipc	a2,0x3
ffffffffc0201a6c:	3c060613          	addi	a2,a2,960 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201a70:	1d200593          	li	a1,466
ffffffffc0201a74:	00003517          	auipc	a0,0x3
ffffffffc0201a78:	22c50513          	addi	a0,a0,556 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201a7c:	e8afe0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0201a80 <tlb_invalidate>:
static inline void flush_tlb() { asm volatile("sfence.vma"); }
ffffffffc0201a80:	12000073          	sfence.vma
void tlb_invalidate(pde_t *pgdir, uintptr_t la) { flush_tlb(); }
ffffffffc0201a84:	8082                	ret

ffffffffc0201a86 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0201a86:	7179                	addi	sp,sp,-48
ffffffffc0201a88:	e84a                	sd	s2,16(sp)
ffffffffc0201a8a:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0201a8c:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0201a8e:	f022                	sd	s0,32(sp)
ffffffffc0201a90:	ec26                	sd	s1,24(sp)
ffffffffc0201a92:	e44e                	sd	s3,8(sp)
ffffffffc0201a94:	f406                	sd	ra,40(sp)
ffffffffc0201a96:	84ae                	mv	s1,a1
ffffffffc0201a98:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0201a9a:	852ff0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0201a9e:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0201aa0:	cd19                	beqz	a0,ffffffffc0201abe <pgdir_alloc_page+0x38>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0201aa2:	85aa                	mv	a1,a0
ffffffffc0201aa4:	86ce                	mv	a3,s3
ffffffffc0201aa6:	8626                	mv	a2,s1
ffffffffc0201aa8:	854a                	mv	a0,s2
ffffffffc0201aaa:	c28ff0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
ffffffffc0201aae:	ed39                	bnez	a0,ffffffffc0201b0c <pgdir_alloc_page+0x86>
        if (swap_init_ok) {
ffffffffc0201ab0:	00010797          	auipc	a5,0x10
ffffffffc0201ab4:	9c078793          	addi	a5,a5,-1600 # ffffffffc0211470 <swap_init_ok>
ffffffffc0201ab8:	439c                	lw	a5,0(a5)
ffffffffc0201aba:	2781                	sext.w	a5,a5
ffffffffc0201abc:	eb89                	bnez	a5,ffffffffc0201ace <pgdir_alloc_page+0x48>
}
ffffffffc0201abe:	8522                	mv	a0,s0
ffffffffc0201ac0:	70a2                	ld	ra,40(sp)
ffffffffc0201ac2:	7402                	ld	s0,32(sp)
ffffffffc0201ac4:	64e2                	ld	s1,24(sp)
ffffffffc0201ac6:	6942                	ld	s2,16(sp)
ffffffffc0201ac8:	69a2                	ld	s3,8(sp)
ffffffffc0201aca:	6145                	addi	sp,sp,48
ffffffffc0201acc:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0201ace:	00010797          	auipc	a5,0x10
ffffffffc0201ad2:	9e278793          	addi	a5,a5,-1566 # ffffffffc02114b0 <check_mm_struct>
ffffffffc0201ad6:	6388                	ld	a0,0(a5)
ffffffffc0201ad8:	4681                	li	a3,0
ffffffffc0201ada:	8622                	mv	a2,s0
ffffffffc0201adc:	85a6                	mv	a1,s1
ffffffffc0201ade:	08c010ef          	jal	ra,ffffffffc0202b6a <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0201ae2:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0201ae4:	e024                	sd	s1,64(s0)
            assert(page_ref(page) == 1);
ffffffffc0201ae6:	4785                	li	a5,1
ffffffffc0201ae8:	fcf70be3          	beq	a4,a5,ffffffffc0201abe <pgdir_alloc_page+0x38>
ffffffffc0201aec:	00003697          	auipc	a3,0x3
ffffffffc0201af0:	23468693          	addi	a3,a3,564 # ffffffffc0204d20 <commands+0x8e8>
ffffffffc0201af4:	00003617          	auipc	a2,0x3
ffffffffc0201af8:	33460613          	addi	a2,a2,820 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201afc:	17a00593          	li	a1,378
ffffffffc0201b00:	00003517          	auipc	a0,0x3
ffffffffc0201b04:	1a050513          	addi	a0,a0,416 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201b08:	dfefe0ef          	jal	ra,ffffffffc0200106 <__panic>
            free_page(page);
ffffffffc0201b0c:	8522                	mv	a0,s0
ffffffffc0201b0e:	4585                	li	a1,1
ffffffffc0201b10:	864ff0ef          	jal	ra,ffffffffc0200b74 <free_pages>
            return NULL;
ffffffffc0201b14:	4401                	li	s0,0
ffffffffc0201b16:	b765                	j	ffffffffc0201abe <pgdir_alloc_page+0x38>

ffffffffc0201b18 <kmalloc>:
}

void *kmalloc(size_t n) {
ffffffffc0201b18:	1141                	addi	sp,sp,-16
    void *ptr = NULL;
    struct Page *base = NULL;
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0201b1a:	67d5                	lui	a5,0x15
void *kmalloc(size_t n) {
ffffffffc0201b1c:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0201b1e:	fff50713          	addi	a4,a0,-1
ffffffffc0201b22:	17f9                	addi	a5,a5,-2
ffffffffc0201b24:	04e7ee63          	bltu	a5,a4,ffffffffc0201b80 <kmalloc+0x68>
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0201b28:	6785                	lui	a5,0x1
ffffffffc0201b2a:	17fd                	addi	a5,a5,-1
ffffffffc0201b2c:	953e                	add	a0,a0,a5
    base = alloc_pages(num_pages);
ffffffffc0201b2e:	8131                	srli	a0,a0,0xc
ffffffffc0201b30:	fbdfe0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
    assert(base != NULL);
ffffffffc0201b34:	c159                	beqz	a0,ffffffffc0201bba <kmalloc+0xa2>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201b36:	00010797          	auipc	a5,0x10
ffffffffc0201b3a:	96278793          	addi	a5,a5,-1694 # ffffffffc0211498 <pages>
ffffffffc0201b3e:	639c                	ld	a5,0(a5)
ffffffffc0201b40:	8d1d                	sub	a0,a0,a5
ffffffffc0201b42:	00003797          	auipc	a5,0x3
ffffffffc0201b46:	12e78793          	addi	a5,a5,302 # ffffffffc0204c70 <commands+0x838>
ffffffffc0201b4a:	6394                	ld	a3,0(a5)
ffffffffc0201b4c:	850d                	srai	a0,a0,0x3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201b4e:	00010797          	auipc	a5,0x10
ffffffffc0201b52:	90a78793          	addi	a5,a5,-1782 # ffffffffc0211458 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201b56:	02d50533          	mul	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201b5a:	6398                	ld	a4,0(a5)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201b5c:	000806b7          	lui	a3,0x80
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201b60:	57fd                	li	a5,-1
ffffffffc0201b62:	83b1                	srli	a5,a5,0xc
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0201b64:	9536                	add	a0,a0,a3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201b66:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b68:	0532                	slli	a0,a0,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0201b6a:	02e7fb63          	bleu	a4,a5,ffffffffc0201ba0 <kmalloc+0x88>
ffffffffc0201b6e:	00010797          	auipc	a5,0x10
ffffffffc0201b72:	91a78793          	addi	a5,a5,-1766 # ffffffffc0211488 <va_pa_offset>
ffffffffc0201b76:	639c                	ld	a5,0(a5)
    ptr = page2kva(base);
    return ptr;
}
ffffffffc0201b78:	60a2                	ld	ra,8(sp)
ffffffffc0201b7a:	953e                	add	a0,a0,a5
ffffffffc0201b7c:	0141                	addi	sp,sp,16
ffffffffc0201b7e:	8082                	ret
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0201b80:	00003697          	auipc	a3,0x3
ffffffffc0201b84:	14068693          	addi	a3,a3,320 # ffffffffc0204cc0 <commands+0x888>
ffffffffc0201b88:	00003617          	auipc	a2,0x3
ffffffffc0201b8c:	2a060613          	addi	a2,a2,672 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201b90:	1f000593          	li	a1,496
ffffffffc0201b94:	00003517          	auipc	a0,0x3
ffffffffc0201b98:	10c50513          	addi	a0,a0,268 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201b9c:	d6afe0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0201ba0:	86aa                	mv	a3,a0
ffffffffc0201ba2:	00003617          	auipc	a2,0x3
ffffffffc0201ba6:	0d660613          	addi	a2,a2,214 # ffffffffc0204c78 <commands+0x840>
ffffffffc0201baa:	06a00593          	li	a1,106
ffffffffc0201bae:	00003517          	auipc	a0,0x3
ffffffffc0201bb2:	16250513          	addi	a0,a0,354 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc0201bb6:	d50fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(base != NULL);
ffffffffc0201bba:	00003697          	auipc	a3,0x3
ffffffffc0201bbe:	12668693          	addi	a3,a3,294 # ffffffffc0204ce0 <commands+0x8a8>
ffffffffc0201bc2:	00003617          	auipc	a2,0x3
ffffffffc0201bc6:	26660613          	addi	a2,a2,614 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201bca:	1f300593          	li	a1,499
ffffffffc0201bce:	00003517          	auipc	a0,0x3
ffffffffc0201bd2:	0d250513          	addi	a0,a0,210 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201bd6:	d30fe0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0201bda <kfree>:

void kfree(void *ptr, size_t n) {
ffffffffc0201bda:	1141                	addi	sp,sp,-16
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0201bdc:	67d5                	lui	a5,0x15
void kfree(void *ptr, size_t n) {
ffffffffc0201bde:	e406                	sd	ra,8(sp)
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0201be0:	fff58713          	addi	a4,a1,-1
ffffffffc0201be4:	17f9                	addi	a5,a5,-2
ffffffffc0201be6:	04e7eb63          	bltu	a5,a4,ffffffffc0201c3c <kfree+0x62>
    assert(ptr != NULL);
ffffffffc0201bea:	c941                	beqz	a0,ffffffffc0201c7a <kfree+0xa0>
    struct Page *base = NULL;
    int num_pages = (n + PGSIZE - 1) / PGSIZE;
ffffffffc0201bec:	6785                	lui	a5,0x1
ffffffffc0201bee:	17fd                	addi	a5,a5,-1
ffffffffc0201bf0:	95be                	add	a1,a1,a5
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0201bf2:	c02007b7          	lui	a5,0xc0200
ffffffffc0201bf6:	81b1                	srli	a1,a1,0xc
ffffffffc0201bf8:	06f56463          	bltu	a0,a5,ffffffffc0201c60 <kfree+0x86>
ffffffffc0201bfc:	00010797          	auipc	a5,0x10
ffffffffc0201c00:	88c78793          	addi	a5,a5,-1908 # ffffffffc0211488 <va_pa_offset>
ffffffffc0201c04:	639c                	ld	a5,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0201c06:	00010717          	auipc	a4,0x10
ffffffffc0201c0a:	85270713          	addi	a4,a4,-1966 # ffffffffc0211458 <npage>
ffffffffc0201c0e:	6318                	ld	a4,0(a4)
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0201c10:	40f507b3          	sub	a5,a0,a5
    if (PPN(pa) >= npage) {
ffffffffc0201c14:	83b1                	srli	a5,a5,0xc
ffffffffc0201c16:	04e7f363          	bleu	a4,a5,ffffffffc0201c5c <kfree+0x82>
    return &pages[PPN(pa) - nbase];
ffffffffc0201c1a:	fff80537          	lui	a0,0xfff80
ffffffffc0201c1e:	97aa                	add	a5,a5,a0
ffffffffc0201c20:	00010697          	auipc	a3,0x10
ffffffffc0201c24:	87868693          	addi	a3,a3,-1928 # ffffffffc0211498 <pages>
ffffffffc0201c28:	6288                	ld	a0,0(a3)
ffffffffc0201c2a:	00379713          	slli	a4,a5,0x3
    base = kva2page(ptr);
    free_pages(base, num_pages);
}
ffffffffc0201c2e:	60a2                	ld	ra,8(sp)
ffffffffc0201c30:	97ba                	add	a5,a5,a4
ffffffffc0201c32:	078e                	slli	a5,a5,0x3
    free_pages(base, num_pages);
ffffffffc0201c34:	953e                	add	a0,a0,a5
}
ffffffffc0201c36:	0141                	addi	sp,sp,16
    free_pages(base, num_pages);
ffffffffc0201c38:	f3dfe06f          	j	ffffffffc0200b74 <free_pages>
    assert(n > 0 && n < 1024 * 0124);
ffffffffc0201c3c:	00003697          	auipc	a3,0x3
ffffffffc0201c40:	08468693          	addi	a3,a3,132 # ffffffffc0204cc0 <commands+0x888>
ffffffffc0201c44:	00003617          	auipc	a2,0x3
ffffffffc0201c48:	1e460613          	addi	a2,a2,484 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201c4c:	1f900593          	li	a1,505
ffffffffc0201c50:	00003517          	auipc	a0,0x3
ffffffffc0201c54:	05050513          	addi	a0,a0,80 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201c58:	caefe0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0201c5c:	e75fe0ef          	jal	ra,ffffffffc0200ad0 <pa2page.part.4>
static inline struct Page *kva2page(void *kva) { return pa2page(PADDR(kva)); }
ffffffffc0201c60:	86aa                	mv	a3,a0
ffffffffc0201c62:	00003617          	auipc	a2,0x3
ffffffffc0201c66:	15e60613          	addi	a2,a2,350 # ffffffffc0204dc0 <commands+0x988>
ffffffffc0201c6a:	06c00593          	li	a1,108
ffffffffc0201c6e:	00003517          	auipc	a0,0x3
ffffffffc0201c72:	0a250513          	addi	a0,a0,162 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc0201c76:	c90fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(ptr != NULL);
ffffffffc0201c7a:	00003697          	auipc	a3,0x3
ffffffffc0201c7e:	03668693          	addi	a3,a3,54 # ffffffffc0204cb0 <commands+0x878>
ffffffffc0201c82:	00003617          	auipc	a2,0x3
ffffffffc0201c86:	1a660613          	addi	a2,a2,422 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201c8a:	1fa00593          	li	a1,506
ffffffffc0201c8e:	00003517          	auipc	a0,0x3
ffffffffc0201c92:	01250513          	addi	a0,a0,18 # ffffffffc0204ca0 <commands+0x868>
ffffffffc0201c96:	c70fe0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0201c9a <check_vma_overlap.isra.0.part.1>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0201c9a:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0201c9c:	00003697          	auipc	a3,0x3
ffffffffc0201ca0:	64468693          	addi	a3,a3,1604 # ffffffffc02052e0 <commands+0xea8>
ffffffffc0201ca4:	00003617          	auipc	a2,0x3
ffffffffc0201ca8:	18460613          	addi	a2,a2,388 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201cac:	07d00593          	li	a1,125
ffffffffc0201cb0:	00003517          	auipc	a0,0x3
ffffffffc0201cb4:	65050513          	addi	a0,a0,1616 # ffffffffc0205300 <commands+0xec8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0201cb8:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0201cba:	c4cfe0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0201cbe <mm_create>:
mm_create(void) {
ffffffffc0201cbe:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201cc0:	03000513          	li	a0,48
mm_create(void) {
ffffffffc0201cc4:	e022                	sd	s0,0(sp)
ffffffffc0201cc6:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201cc8:	e51ff0ef          	jal	ra,ffffffffc0201b18 <kmalloc>
ffffffffc0201ccc:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0201cce:	c115                	beqz	a0,ffffffffc0201cf2 <mm_create+0x34>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201cd0:	0000f797          	auipc	a5,0xf
ffffffffc0201cd4:	7a078793          	addi	a5,a5,1952 # ffffffffc0211470 <swap_init_ok>
ffffffffc0201cd8:	439c                	lw	a5,0(a5)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201cda:	e408                	sd	a0,8(s0)
ffffffffc0201cdc:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0201cde:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0201ce2:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0201ce6:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201cea:	2781                	sext.w	a5,a5
ffffffffc0201cec:	eb81                	bnez	a5,ffffffffc0201cfc <mm_create+0x3e>
        else mm->sm_priv = NULL;
ffffffffc0201cee:	02053423          	sd	zero,40(a0)
}
ffffffffc0201cf2:	8522                	mv	a0,s0
ffffffffc0201cf4:	60a2                	ld	ra,8(sp)
ffffffffc0201cf6:	6402                	ld	s0,0(sp)
ffffffffc0201cf8:	0141                	addi	sp,sp,16
ffffffffc0201cfa:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201cfc:	65f000ef          	jal	ra,ffffffffc0202b5a <swap_init_mm>
}
ffffffffc0201d00:	8522                	mv	a0,s0
ffffffffc0201d02:	60a2                	ld	ra,8(sp)
ffffffffc0201d04:	6402                	ld	s0,0(sp)
ffffffffc0201d06:	0141                	addi	sp,sp,16
ffffffffc0201d08:	8082                	ret

ffffffffc0201d0a <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0201d0a:	1101                	addi	sp,sp,-32
ffffffffc0201d0c:	e04a                	sd	s2,0(sp)
ffffffffc0201d0e:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201d10:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint_t vm_flags) {
ffffffffc0201d14:	e822                	sd	s0,16(sp)
ffffffffc0201d16:	e426                	sd	s1,8(sp)
ffffffffc0201d18:	ec06                	sd	ra,24(sp)
ffffffffc0201d1a:	84ae                	mv	s1,a1
ffffffffc0201d1c:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201d1e:	dfbff0ef          	jal	ra,ffffffffc0201b18 <kmalloc>
    if (vma != NULL) {
ffffffffc0201d22:	c509                	beqz	a0,ffffffffc0201d2c <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0201d24:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201d28:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201d2a:	ed00                	sd	s0,24(a0)
}
ffffffffc0201d2c:	60e2                	ld	ra,24(sp)
ffffffffc0201d2e:	6442                	ld	s0,16(sp)
ffffffffc0201d30:	64a2                	ld	s1,8(sp)
ffffffffc0201d32:	6902                	ld	s2,0(sp)
ffffffffc0201d34:	6105                	addi	sp,sp,32
ffffffffc0201d36:	8082                	ret

ffffffffc0201d38 <find_vma>:
    if (mm != NULL) {
ffffffffc0201d38:	c51d                	beqz	a0,ffffffffc0201d66 <find_vma+0x2e>
        vma = mm->mmap_cache;
ffffffffc0201d3a:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0201d3c:	c781                	beqz	a5,ffffffffc0201d44 <find_vma+0xc>
ffffffffc0201d3e:	6798                	ld	a4,8(a5)
ffffffffc0201d40:	02e5f663          	bleu	a4,a1,ffffffffc0201d6c <find_vma+0x34>
                list_entry_t *list = &(mm->mmap_list), *le = list;
ffffffffc0201d44:	87aa                	mv	a5,a0
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201d46:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0201d48:	00f50f63          	beq	a0,a5,ffffffffc0201d66 <find_vma+0x2e>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0201d4c:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201d50:	fee5ebe3          	bltu	a1,a4,ffffffffc0201d46 <find_vma+0xe>
ffffffffc0201d54:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201d58:	fee5f7e3          	bleu	a4,a1,ffffffffc0201d46 <find_vma+0xe>
                    vma = le2vma(le, list_link);
ffffffffc0201d5c:	1781                	addi	a5,a5,-32
        if (vma != NULL) {
ffffffffc0201d5e:	c781                	beqz	a5,ffffffffc0201d66 <find_vma+0x2e>
            mm->mmap_cache = vma;
ffffffffc0201d60:	e91c                	sd	a5,16(a0)
}
ffffffffc0201d62:	853e                	mv	a0,a5
ffffffffc0201d64:	8082                	ret
    struct vma_struct *vma = NULL;
ffffffffc0201d66:	4781                	li	a5,0
}
ffffffffc0201d68:	853e                	mv	a0,a5
ffffffffc0201d6a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0201d6c:	6b98                	ld	a4,16(a5)
ffffffffc0201d6e:	fce5fbe3          	bleu	a4,a1,ffffffffc0201d44 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0201d72:	e91c                	sd	a5,16(a0)
    return vma;
ffffffffc0201d74:	b7fd                	j	ffffffffc0201d62 <find_vma+0x2a>

ffffffffc0201d76 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201d76:	6590                	ld	a2,8(a1)
ffffffffc0201d78:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0201d7c:	1141                	addi	sp,sp,-16
ffffffffc0201d7e:	e406                	sd	ra,8(sp)
ffffffffc0201d80:	872a                	mv	a4,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201d82:	01066863          	bltu	a2,a6,ffffffffc0201d92 <insert_vma_struct+0x1c>
ffffffffc0201d86:	a8b9                	j	ffffffffc0201de4 <insert_vma_struct+0x6e>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0201d88:	fe87b683          	ld	a3,-24(a5)
ffffffffc0201d8c:	04d66763          	bltu	a2,a3,ffffffffc0201dda <insert_vma_struct+0x64>
ffffffffc0201d90:	873e                	mv	a4,a5
ffffffffc0201d92:	671c                	ld	a5,8(a4)
        while ((le = list_next(le)) != list) {
ffffffffc0201d94:	fef51ae3          	bne	a0,a5,ffffffffc0201d88 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0201d98:	02a70463          	beq	a4,a0,ffffffffc0201dc0 <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0201d9c:	ff073683          	ld	a3,-16(a4)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201da0:	fe873883          	ld	a7,-24(a4)
ffffffffc0201da4:	08d8f063          	bleu	a3,a7,ffffffffc0201e24 <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201da8:	04d66e63          	bltu	a2,a3,ffffffffc0201e04 <insert_vma_struct+0x8e>
    }
    if (le_next != list) {
ffffffffc0201dac:	00f50a63          	beq	a0,a5,ffffffffc0201dc0 <insert_vma_struct+0x4a>
ffffffffc0201db0:	fe87b683          	ld	a3,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201db4:	0506e863          	bltu	a3,a6,ffffffffc0201e04 <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0201db8:	ff07b603          	ld	a2,-16(a5)
ffffffffc0201dbc:	02c6f263          	bleu	a2,a3,ffffffffc0201de0 <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc0201dc0:	5114                	lw	a3,32(a0)
    vma->vm_mm = mm;
ffffffffc0201dc2:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0201dc4:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201dc8:	e390                	sd	a2,0(a5)
ffffffffc0201dca:	e710                	sd	a2,8(a4)
}
ffffffffc0201dcc:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0201dce:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0201dd0:	f198                	sd	a4,32(a1)
    mm->map_count ++;
ffffffffc0201dd2:	2685                	addiw	a3,a3,1
ffffffffc0201dd4:	d114                	sw	a3,32(a0)
}
ffffffffc0201dd6:	0141                	addi	sp,sp,16
ffffffffc0201dd8:	8082                	ret
    if (le_prev != list) {
ffffffffc0201dda:	fca711e3          	bne	a4,a0,ffffffffc0201d9c <insert_vma_struct+0x26>
ffffffffc0201dde:	bfd9                	j	ffffffffc0201db4 <insert_vma_struct+0x3e>
ffffffffc0201de0:	ebbff0ef          	jal	ra,ffffffffc0201c9a <check_vma_overlap.isra.0.part.1>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201de4:	00003697          	auipc	a3,0x3
ffffffffc0201de8:	5dc68693          	addi	a3,a3,1500 # ffffffffc02053c0 <commands+0xf88>
ffffffffc0201dec:	00003617          	auipc	a2,0x3
ffffffffc0201df0:	03c60613          	addi	a2,a2,60 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201df4:	08400593          	li	a1,132
ffffffffc0201df8:	00003517          	auipc	a0,0x3
ffffffffc0201dfc:	50850513          	addi	a0,a0,1288 # ffffffffc0205300 <commands+0xec8>
ffffffffc0201e00:	b06fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201e04:	00003697          	auipc	a3,0x3
ffffffffc0201e08:	5fc68693          	addi	a3,a3,1532 # ffffffffc0205400 <commands+0xfc8>
ffffffffc0201e0c:	00003617          	auipc	a2,0x3
ffffffffc0201e10:	01c60613          	addi	a2,a2,28 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201e14:	07c00593          	li	a1,124
ffffffffc0201e18:	00003517          	auipc	a0,0x3
ffffffffc0201e1c:	4e850513          	addi	a0,a0,1256 # ffffffffc0205300 <commands+0xec8>
ffffffffc0201e20:	ae6fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201e24:	00003697          	auipc	a3,0x3
ffffffffc0201e28:	5bc68693          	addi	a3,a3,1468 # ffffffffc02053e0 <commands+0xfa8>
ffffffffc0201e2c:	00003617          	auipc	a2,0x3
ffffffffc0201e30:	ffc60613          	addi	a2,a2,-4 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201e34:	07b00593          	li	a1,123
ffffffffc0201e38:	00003517          	auipc	a0,0x3
ffffffffc0201e3c:	4c850513          	addi	a0,a0,1224 # ffffffffc0205300 <commands+0xec8>
ffffffffc0201e40:	ac6fe0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0201e44 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
ffffffffc0201e44:	1141                	addi	sp,sp,-16
ffffffffc0201e46:	e022                	sd	s0,0(sp)
ffffffffc0201e48:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0201e4a:	6508                	ld	a0,8(a0)
ffffffffc0201e4c:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc0201e4e:	00a40e63          	beq	s0,a0,ffffffffc0201e6a <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0201e52:	6118                	ld	a4,0(a0)
ffffffffc0201e54:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
ffffffffc0201e56:	03000593          	li	a1,48
ffffffffc0201e5a:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201e5c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201e5e:	e398                	sd	a4,0(a5)
ffffffffc0201e60:	d7bff0ef          	jal	ra,ffffffffc0201bda <kfree>
    return listelm->next;
ffffffffc0201e64:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0201e66:	fea416e3          	bne	s0,a0,ffffffffc0201e52 <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0201e6a:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0201e6c:	6402                	ld	s0,0(sp)
ffffffffc0201e6e:	60a2                	ld	ra,8(sp)
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0201e70:	03000593          	li	a1,48
}
ffffffffc0201e74:	0141                	addi	sp,sp,16
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
ffffffffc0201e76:	d65ff06f          	j	ffffffffc0201bda <kfree>

ffffffffc0201e7a <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0201e7a:	715d                	addi	sp,sp,-80
ffffffffc0201e7c:	e486                	sd	ra,72(sp)
ffffffffc0201e7e:	e0a2                	sd	s0,64(sp)
ffffffffc0201e80:	fc26                	sd	s1,56(sp)
ffffffffc0201e82:	f84a                	sd	s2,48(sp)
ffffffffc0201e84:	f052                	sd	s4,32(sp)
ffffffffc0201e86:	f44e                	sd	s3,40(sp)
ffffffffc0201e88:	ec56                	sd	s5,24(sp)
ffffffffc0201e8a:	e85a                	sd	s6,16(sp)
ffffffffc0201e8c:	e45e                	sd	s7,8(sp)
}

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0201e8e:	d2dfe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc0201e92:	892a                	mv	s2,a0
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0201e94:	d27fe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc0201e98:	8a2a                	mv	s4,a0

    struct mm_struct *mm = mm_create();
ffffffffc0201e9a:	e25ff0ef          	jal	ra,ffffffffc0201cbe <mm_create>
    assert(mm != NULL);
ffffffffc0201e9e:	842a                	mv	s0,a0
ffffffffc0201ea0:	03200493          	li	s1,50
ffffffffc0201ea4:	e919                	bnez	a0,ffffffffc0201eba <vmm_init+0x40>
ffffffffc0201ea6:	aeed                	j	ffffffffc02022a0 <vmm_init+0x426>
        vma->vm_start = vm_start;
ffffffffc0201ea8:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201eaa:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201eac:	00053c23          	sd	zero,24(a0)

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0201eb0:	14ed                	addi	s1,s1,-5
ffffffffc0201eb2:	8522                	mv	a0,s0
ffffffffc0201eb4:	ec3ff0ef          	jal	ra,ffffffffc0201d76 <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0201eb8:	c88d                	beqz	s1,ffffffffc0201eea <vmm_init+0x70>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201eba:	03000513          	li	a0,48
ffffffffc0201ebe:	c5bff0ef          	jal	ra,ffffffffc0201b18 <kmalloc>
ffffffffc0201ec2:	85aa                	mv	a1,a0
ffffffffc0201ec4:	00248793          	addi	a5,s1,2
    if (vma != NULL) {
ffffffffc0201ec8:	f165                	bnez	a0,ffffffffc0201ea8 <vmm_init+0x2e>
        assert(vma != NULL);
ffffffffc0201eca:	00003697          	auipc	a3,0x3
ffffffffc0201ece:	77e68693          	addi	a3,a3,1918 # ffffffffc0205648 <commands+0x1210>
ffffffffc0201ed2:	00003617          	auipc	a2,0x3
ffffffffc0201ed6:	f5660613          	addi	a2,a2,-170 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201eda:	0ce00593          	li	a1,206
ffffffffc0201ede:	00003517          	auipc	a0,0x3
ffffffffc0201ee2:	42250513          	addi	a0,a0,1058 # ffffffffc0205300 <commands+0xec8>
ffffffffc0201ee6:	a20fe0ef          	jal	ra,ffffffffc0200106 <__panic>
    for (i = step1; i >= 1; i --) {
ffffffffc0201eea:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0201eee:	1f900993          	li	s3,505
ffffffffc0201ef2:	a819                	j	ffffffffc0201f08 <vmm_init+0x8e>
        vma->vm_start = vm_start;
ffffffffc0201ef4:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201ef6:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201ef8:	00053c23          	sd	zero,24(a0)
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0201efc:	0495                	addi	s1,s1,5
ffffffffc0201efe:	8522                	mv	a0,s0
ffffffffc0201f00:	e77ff0ef          	jal	ra,ffffffffc0201d76 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0201f04:	03348a63          	beq	s1,s3,ffffffffc0201f38 <vmm_init+0xbe>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201f08:	03000513          	li	a0,48
ffffffffc0201f0c:	c0dff0ef          	jal	ra,ffffffffc0201b18 <kmalloc>
ffffffffc0201f10:	85aa                	mv	a1,a0
ffffffffc0201f12:	00248793          	addi	a5,s1,2
    if (vma != NULL) {
ffffffffc0201f16:	fd79                	bnez	a0,ffffffffc0201ef4 <vmm_init+0x7a>
        assert(vma != NULL);
ffffffffc0201f18:	00003697          	auipc	a3,0x3
ffffffffc0201f1c:	73068693          	addi	a3,a3,1840 # ffffffffc0205648 <commands+0x1210>
ffffffffc0201f20:	00003617          	auipc	a2,0x3
ffffffffc0201f24:	f0860613          	addi	a2,a2,-248 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0201f28:	0d400593          	li	a1,212
ffffffffc0201f2c:	00003517          	auipc	a0,0x3
ffffffffc0201f30:	3d450513          	addi	a0,a0,980 # ffffffffc0205300 <commands+0xec8>
ffffffffc0201f34:	9d2fe0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0201f38:	6418                	ld	a4,8(s0)
ffffffffc0201f3a:	479d                	li	a5,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc0201f3c:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0201f40:	2ae40063          	beq	s0,a4,ffffffffc02021e0 <vmm_init+0x366>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0201f44:	fe873603          	ld	a2,-24(a4)
ffffffffc0201f48:	ffe78693          	addi	a3,a5,-2
ffffffffc0201f4c:	20d61a63          	bne	a2,a3,ffffffffc0202160 <vmm_init+0x2e6>
ffffffffc0201f50:	ff073683          	ld	a3,-16(a4)
ffffffffc0201f54:	20d79663          	bne	a5,a3,ffffffffc0202160 <vmm_init+0x2e6>
ffffffffc0201f58:	0795                	addi	a5,a5,5
ffffffffc0201f5a:	6718                	ld	a4,8(a4)
    for (i = 1; i <= step2; i ++) {
ffffffffc0201f5c:	feb792e3          	bne	a5,a1,ffffffffc0201f40 <vmm_init+0xc6>
ffffffffc0201f60:	499d                	li	s3,7
ffffffffc0201f62:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0201f64:	1f900b93          	li	s7,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0201f68:	85a6                	mv	a1,s1
ffffffffc0201f6a:	8522                	mv	a0,s0
ffffffffc0201f6c:	dcdff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
ffffffffc0201f70:	8b2a                	mv	s6,a0
        assert(vma1 != NULL);
ffffffffc0201f72:	2e050763          	beqz	a0,ffffffffc0202260 <vmm_init+0x3e6>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc0201f76:	00148593          	addi	a1,s1,1
ffffffffc0201f7a:	8522                	mv	a0,s0
ffffffffc0201f7c:	dbdff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
ffffffffc0201f80:	8aaa                	mv	s5,a0
        assert(vma2 != NULL);
ffffffffc0201f82:	2a050f63          	beqz	a0,ffffffffc0202240 <vmm_init+0x3c6>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc0201f86:	85ce                	mv	a1,s3
ffffffffc0201f88:	8522                	mv	a0,s0
ffffffffc0201f8a:	dafff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
        assert(vma3 == NULL);
ffffffffc0201f8e:	28051963          	bnez	a0,ffffffffc0202220 <vmm_init+0x3a6>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0201f92:	00348593          	addi	a1,s1,3
ffffffffc0201f96:	8522                	mv	a0,s0
ffffffffc0201f98:	da1ff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
        assert(vma4 == NULL);
ffffffffc0201f9c:	26051263          	bnez	a0,ffffffffc0202200 <vmm_init+0x386>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0201fa0:	00448593          	addi	a1,s1,4
ffffffffc0201fa4:	8522                	mv	a0,s0
ffffffffc0201fa6:	d93ff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
        assert(vma5 == NULL);
ffffffffc0201faa:	2c051b63          	bnez	a0,ffffffffc0202280 <vmm_init+0x406>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0201fae:	008b3783          	ld	a5,8(s6)
ffffffffc0201fb2:	1c979763          	bne	a5,s1,ffffffffc0202180 <vmm_init+0x306>
ffffffffc0201fb6:	010b3783          	ld	a5,16(s6)
ffffffffc0201fba:	1d379363          	bne	a5,s3,ffffffffc0202180 <vmm_init+0x306>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0201fbe:	008ab783          	ld	a5,8(s5)
ffffffffc0201fc2:	1c979f63          	bne	a5,s1,ffffffffc02021a0 <vmm_init+0x326>
ffffffffc0201fc6:	010ab783          	ld	a5,16(s5)
ffffffffc0201fca:	1d379b63          	bne	a5,s3,ffffffffc02021a0 <vmm_init+0x326>
ffffffffc0201fce:	0495                	addi	s1,s1,5
ffffffffc0201fd0:	0995                	addi	s3,s3,5
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0201fd2:	f9749be3          	bne	s1,s7,ffffffffc0201f68 <vmm_init+0xee>
ffffffffc0201fd6:	4491                	li	s1,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0201fd8:	59fd                	li	s3,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0201fda:	85a6                	mv	a1,s1
ffffffffc0201fdc:	8522                	mv	a0,s0
ffffffffc0201fde:	d5bff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
ffffffffc0201fe2:	0004859b          	sext.w	a1,s1
        if (vma_below_5 != NULL ) {
ffffffffc0201fe6:	c90d                	beqz	a0,ffffffffc0202018 <vmm_init+0x19e>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0201fe8:	6914                	ld	a3,16(a0)
ffffffffc0201fea:	6510                	ld	a2,8(a0)
ffffffffc0201fec:	00003517          	auipc	a0,0x3
ffffffffc0201ff0:	54450513          	addi	a0,a0,1348 # ffffffffc0205530 <commands+0x10f8>
ffffffffc0201ff4:	8cafe0ef          	jal	ra,ffffffffc02000be <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0201ff8:	00003697          	auipc	a3,0x3
ffffffffc0201ffc:	56068693          	addi	a3,a3,1376 # ffffffffc0205558 <commands+0x1120>
ffffffffc0202000:	00003617          	auipc	a2,0x3
ffffffffc0202004:	e2860613          	addi	a2,a2,-472 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202008:	0f600593          	li	a1,246
ffffffffc020200c:	00003517          	auipc	a0,0x3
ffffffffc0202010:	2f450513          	addi	a0,a0,756 # ffffffffc0205300 <commands+0xec8>
ffffffffc0202014:	8f2fe0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0202018:	14fd                	addi	s1,s1,-1
    for (i =4; i>=0; i--) {
ffffffffc020201a:	fd3490e3          	bne	s1,s3,ffffffffc0201fda <vmm_init+0x160>
    }

    mm_destroy(mm);
ffffffffc020201e:	8522                	mv	a0,s0
ffffffffc0202020:	e25ff0ef          	jal	ra,ffffffffc0201e44 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0202024:	b97fe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc0202028:	28aa1c63          	bne	s4,a0,ffffffffc02022c0 <vmm_init+0x446>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc020202c:	00003517          	auipc	a0,0x3
ffffffffc0202030:	56c50513          	addi	a0,a0,1388 # ffffffffc0205598 <commands+0x1160>
ffffffffc0202034:	88afe0ef          	jal	ra,ffffffffc02000be <cprintf>

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
	// char *name = "check_pgfault";
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0202038:	b83fe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc020203c:	89aa                	mv	s3,a0

    check_mm_struct = mm_create();
ffffffffc020203e:	c81ff0ef          	jal	ra,ffffffffc0201cbe <mm_create>
ffffffffc0202042:	0000f797          	auipc	a5,0xf
ffffffffc0202046:	46a7b723          	sd	a0,1134(a5) # ffffffffc02114b0 <check_mm_struct>
ffffffffc020204a:	842a                	mv	s0,a0

    assert(check_mm_struct != NULL);
ffffffffc020204c:	2a050a63          	beqz	a0,ffffffffc0202300 <vmm_init+0x486>
    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202050:	0000f797          	auipc	a5,0xf
ffffffffc0202054:	40078793          	addi	a5,a5,1024 # ffffffffc0211450 <boot_pgdir>
ffffffffc0202058:	6384                	ld	s1,0(a5)
    assert(pgdir[0] == 0);
ffffffffc020205a:	609c                	ld	a5,0(s1)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc020205c:	ed04                	sd	s1,24(a0)
    assert(pgdir[0] == 0);
ffffffffc020205e:	32079d63          	bnez	a5,ffffffffc0202398 <vmm_init+0x51e>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202062:	03000513          	li	a0,48
ffffffffc0202066:	ab3ff0ef          	jal	ra,ffffffffc0201b18 <kmalloc>
ffffffffc020206a:	8a2a                	mv	s4,a0
    if (vma != NULL) {
ffffffffc020206c:	14050a63          	beqz	a0,ffffffffc02021c0 <vmm_init+0x346>
        vma->vm_end = vm_end;
ffffffffc0202070:	002007b7          	lui	a5,0x200
ffffffffc0202074:	00fa3823          	sd	a5,16(s4)
        vma->vm_flags = vm_flags;
ffffffffc0202078:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);

    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc020207a:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc020207c:	00fa3c23          	sd	a5,24(s4)
    insert_vma_struct(mm, vma);
ffffffffc0202080:	8522                	mv	a0,s0
        vma->vm_start = vm_start;
ffffffffc0202082:	000a3423          	sd	zero,8(s4)
    insert_vma_struct(mm, vma);
ffffffffc0202086:	cf1ff0ef          	jal	ra,ffffffffc0201d76 <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc020208a:	10000593          	li	a1,256
ffffffffc020208e:	8522                	mv	a0,s0
ffffffffc0202090:	ca9ff0ef          	jal	ra,ffffffffc0201d38 <find_vma>
ffffffffc0202094:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc0202098:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc020209c:	2aaa1263          	bne	s4,a0,ffffffffc0202340 <vmm_init+0x4c6>
        *(char *)(addr + i) = i;
ffffffffc02020a0:	00f78023          	sb	a5,0(a5) # 200000 <BASE_ADDRESS-0xffffffffc0000000>
        sum += i;
ffffffffc02020a4:	0785                	addi	a5,a5,1
    for (i = 0; i < 100; i ++) {
ffffffffc02020a6:	fee79de3          	bne	a5,a4,ffffffffc02020a0 <vmm_init+0x226>
        sum += i;
ffffffffc02020aa:	6705                	lui	a4,0x1
    for (i = 0; i < 100; i ++) {
ffffffffc02020ac:	10000793          	li	a5,256
        sum += i;
ffffffffc02020b0:	35670713          	addi	a4,a4,854 # 1356 <BASE_ADDRESS-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc02020b4:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc02020b8:	0007c683          	lbu	a3,0(a5)
ffffffffc02020bc:	0785                	addi	a5,a5,1
ffffffffc02020be:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc02020c0:	fec79ce3          	bne	a5,a2,ffffffffc02020b8 <vmm_init+0x23e>
    }
    assert(sum == 0);
ffffffffc02020c4:	2a071a63          	bnez	a4,ffffffffc0202378 <vmm_init+0x4fe>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc02020c8:	4581                	li	a1,0
ffffffffc02020ca:	8526                	mv	a0,s1
ffffffffc02020cc:	d95fe0ef          	jal	ra,ffffffffc0200e60 <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc02020d0:	609c                	ld	a5,0(s1)
    if (PPN(pa) >= npage) {
ffffffffc02020d2:	0000f717          	auipc	a4,0xf
ffffffffc02020d6:	38670713          	addi	a4,a4,902 # ffffffffc0211458 <npage>
ffffffffc02020da:	6318                	ld	a4,0(a4)
    return pa2page(PDE_ADDR(pde));
ffffffffc02020dc:	078a                	slli	a5,a5,0x2
ffffffffc02020de:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02020e0:	28e7f063          	bleu	a4,a5,ffffffffc0202360 <vmm_init+0x4e6>
    return &pages[PPN(pa) - nbase];
ffffffffc02020e4:	00004717          	auipc	a4,0x4
ffffffffc02020e8:	01c70713          	addi	a4,a4,28 # ffffffffc0206100 <nbase>
ffffffffc02020ec:	6318                	ld	a4,0(a4)
ffffffffc02020ee:	0000f697          	auipc	a3,0xf
ffffffffc02020f2:	3aa68693          	addi	a3,a3,938 # ffffffffc0211498 <pages>
ffffffffc02020f6:	6288                	ld	a0,0(a3)
ffffffffc02020f8:	8f99                	sub	a5,a5,a4
ffffffffc02020fa:	00379713          	slli	a4,a5,0x3
ffffffffc02020fe:	97ba                	add	a5,a5,a4
ffffffffc0202100:	078e                	slli	a5,a5,0x3

    free_page(pde2page(pgdir[0]));
ffffffffc0202102:	953e                	add	a0,a0,a5
ffffffffc0202104:	4585                	li	a1,1
ffffffffc0202106:	a6ffe0ef          	jal	ra,ffffffffc0200b74 <free_pages>

    pgdir[0] = 0;
ffffffffc020210a:	0004b023          	sd	zero,0(s1)

    mm->pgdir = NULL;
    mm_destroy(mm);
ffffffffc020210e:	8522                	mv	a0,s0
    mm->pgdir = NULL;
ffffffffc0202110:	00043c23          	sd	zero,24(s0)
    mm_destroy(mm);
ffffffffc0202114:	d31ff0ef          	jal	ra,ffffffffc0201e44 <mm_destroy>

    check_mm_struct = NULL;
    nr_free_pages_store--;	// szx : Sv39第二级页表多占了一个内存页，所以执行此操作
ffffffffc0202118:	19fd                	addi	s3,s3,-1
    check_mm_struct = NULL;
ffffffffc020211a:	0000f797          	auipc	a5,0xf
ffffffffc020211e:	3807bb23          	sd	zero,918(a5) # ffffffffc02114b0 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0202122:	a99fe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc0202126:	1aa99d63          	bne	s3,a0,ffffffffc02022e0 <vmm_init+0x466>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc020212a:	00003517          	auipc	a0,0x3
ffffffffc020212e:	4e650513          	addi	a0,a0,1254 # ffffffffc0205610 <commands+0x11d8>
ffffffffc0202132:	f8dfd0ef          	jal	ra,ffffffffc02000be <cprintf>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0202136:	a85fe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
    nr_free_pages_store--;	// szx : Sv39三级页表多占一个内存页，所以执行此操作
ffffffffc020213a:	197d                	addi	s2,s2,-1
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc020213c:	1ea91263          	bne	s2,a0,ffffffffc0202320 <vmm_init+0x4a6>
}
ffffffffc0202140:	6406                	ld	s0,64(sp)
ffffffffc0202142:	60a6                	ld	ra,72(sp)
ffffffffc0202144:	74e2                	ld	s1,56(sp)
ffffffffc0202146:	7942                	ld	s2,48(sp)
ffffffffc0202148:	79a2                	ld	s3,40(sp)
ffffffffc020214a:	7a02                	ld	s4,32(sp)
ffffffffc020214c:	6ae2                	ld	s5,24(sp)
ffffffffc020214e:	6b42                	ld	s6,16(sp)
ffffffffc0202150:	6ba2                	ld	s7,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202152:	00003517          	auipc	a0,0x3
ffffffffc0202156:	4de50513          	addi	a0,a0,1246 # ffffffffc0205630 <commands+0x11f8>
}
ffffffffc020215a:	6161                	addi	sp,sp,80
    cprintf("check_vmm() succeeded.\n");
ffffffffc020215c:	f63fd06f          	j	ffffffffc02000be <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202160:	00003697          	auipc	a3,0x3
ffffffffc0202164:	2e868693          	addi	a3,a3,744 # ffffffffc0205448 <commands+0x1010>
ffffffffc0202168:	00003617          	auipc	a2,0x3
ffffffffc020216c:	cc060613          	addi	a2,a2,-832 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202170:	0dd00593          	li	a1,221
ffffffffc0202174:	00003517          	auipc	a0,0x3
ffffffffc0202178:	18c50513          	addi	a0,a0,396 # ffffffffc0205300 <commands+0xec8>
ffffffffc020217c:	f8bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0202180:	00003697          	auipc	a3,0x3
ffffffffc0202184:	35068693          	addi	a3,a3,848 # ffffffffc02054d0 <commands+0x1098>
ffffffffc0202188:	00003617          	auipc	a2,0x3
ffffffffc020218c:	ca060613          	addi	a2,a2,-864 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202190:	0ed00593          	li	a1,237
ffffffffc0202194:	00003517          	auipc	a0,0x3
ffffffffc0202198:	16c50513          	addi	a0,a0,364 # ffffffffc0205300 <commands+0xec8>
ffffffffc020219c:	f6bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc02021a0:	00003697          	auipc	a3,0x3
ffffffffc02021a4:	36068693          	addi	a3,a3,864 # ffffffffc0205500 <commands+0x10c8>
ffffffffc02021a8:	00003617          	auipc	a2,0x3
ffffffffc02021ac:	c8060613          	addi	a2,a2,-896 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02021b0:	0ee00593          	li	a1,238
ffffffffc02021b4:	00003517          	auipc	a0,0x3
ffffffffc02021b8:	14c50513          	addi	a0,a0,332 # ffffffffc0205300 <commands+0xec8>
ffffffffc02021bc:	f4bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(vma != NULL);
ffffffffc02021c0:	00003697          	auipc	a3,0x3
ffffffffc02021c4:	48868693          	addi	a3,a3,1160 # ffffffffc0205648 <commands+0x1210>
ffffffffc02021c8:	00003617          	auipc	a2,0x3
ffffffffc02021cc:	c6060613          	addi	a2,a2,-928 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02021d0:	11100593          	li	a1,273
ffffffffc02021d4:	00003517          	auipc	a0,0x3
ffffffffc02021d8:	12c50513          	addi	a0,a0,300 # ffffffffc0205300 <commands+0xec8>
ffffffffc02021dc:	f2bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc02021e0:	00003697          	auipc	a3,0x3
ffffffffc02021e4:	25068693          	addi	a3,a3,592 # ffffffffc0205430 <commands+0xff8>
ffffffffc02021e8:	00003617          	auipc	a2,0x3
ffffffffc02021ec:	c4060613          	addi	a2,a2,-960 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02021f0:	0db00593          	li	a1,219
ffffffffc02021f4:	00003517          	auipc	a0,0x3
ffffffffc02021f8:	10c50513          	addi	a0,a0,268 # ffffffffc0205300 <commands+0xec8>
ffffffffc02021fc:	f0bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma4 == NULL);
ffffffffc0202200:	00003697          	auipc	a3,0x3
ffffffffc0202204:	2b068693          	addi	a3,a3,688 # ffffffffc02054b0 <commands+0x1078>
ffffffffc0202208:	00003617          	auipc	a2,0x3
ffffffffc020220c:	c2060613          	addi	a2,a2,-992 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202210:	0e900593          	li	a1,233
ffffffffc0202214:	00003517          	auipc	a0,0x3
ffffffffc0202218:	0ec50513          	addi	a0,a0,236 # ffffffffc0205300 <commands+0xec8>
ffffffffc020221c:	eebfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma3 == NULL);
ffffffffc0202220:	00003697          	auipc	a3,0x3
ffffffffc0202224:	28068693          	addi	a3,a3,640 # ffffffffc02054a0 <commands+0x1068>
ffffffffc0202228:	00003617          	auipc	a2,0x3
ffffffffc020222c:	c0060613          	addi	a2,a2,-1024 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202230:	0e700593          	li	a1,231
ffffffffc0202234:	00003517          	auipc	a0,0x3
ffffffffc0202238:	0cc50513          	addi	a0,a0,204 # ffffffffc0205300 <commands+0xec8>
ffffffffc020223c:	ecbfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma2 != NULL);
ffffffffc0202240:	00003697          	auipc	a3,0x3
ffffffffc0202244:	25068693          	addi	a3,a3,592 # ffffffffc0205490 <commands+0x1058>
ffffffffc0202248:	00003617          	auipc	a2,0x3
ffffffffc020224c:	be060613          	addi	a2,a2,-1056 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202250:	0e500593          	li	a1,229
ffffffffc0202254:	00003517          	auipc	a0,0x3
ffffffffc0202258:	0ac50513          	addi	a0,a0,172 # ffffffffc0205300 <commands+0xec8>
ffffffffc020225c:	eabfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma1 != NULL);
ffffffffc0202260:	00003697          	auipc	a3,0x3
ffffffffc0202264:	22068693          	addi	a3,a3,544 # ffffffffc0205480 <commands+0x1048>
ffffffffc0202268:	00003617          	auipc	a2,0x3
ffffffffc020226c:	bc060613          	addi	a2,a2,-1088 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202270:	0e300593          	li	a1,227
ffffffffc0202274:	00003517          	auipc	a0,0x3
ffffffffc0202278:	08c50513          	addi	a0,a0,140 # ffffffffc0205300 <commands+0xec8>
ffffffffc020227c:	e8bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        assert(vma5 == NULL);
ffffffffc0202280:	00003697          	auipc	a3,0x3
ffffffffc0202284:	24068693          	addi	a3,a3,576 # ffffffffc02054c0 <commands+0x1088>
ffffffffc0202288:	00003617          	auipc	a2,0x3
ffffffffc020228c:	ba060613          	addi	a2,a2,-1120 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202290:	0eb00593          	li	a1,235
ffffffffc0202294:	00003517          	auipc	a0,0x3
ffffffffc0202298:	06c50513          	addi	a0,a0,108 # ffffffffc0205300 <commands+0xec8>
ffffffffc020229c:	e6bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(mm != NULL);
ffffffffc02022a0:	00003697          	auipc	a3,0x3
ffffffffc02022a4:	18068693          	addi	a3,a3,384 # ffffffffc0205420 <commands+0xfe8>
ffffffffc02022a8:	00003617          	auipc	a2,0x3
ffffffffc02022ac:	b8060613          	addi	a2,a2,-1152 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02022b0:	0c700593          	li	a1,199
ffffffffc02022b4:	00003517          	auipc	a0,0x3
ffffffffc02022b8:	04c50513          	addi	a0,a0,76 # ffffffffc0205300 <commands+0xec8>
ffffffffc02022bc:	e4bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02022c0:	00003697          	auipc	a3,0x3
ffffffffc02022c4:	2b068693          	addi	a3,a3,688 # ffffffffc0205570 <commands+0x1138>
ffffffffc02022c8:	00003617          	auipc	a2,0x3
ffffffffc02022cc:	b6060613          	addi	a2,a2,-1184 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02022d0:	0fb00593          	li	a1,251
ffffffffc02022d4:	00003517          	auipc	a0,0x3
ffffffffc02022d8:	02c50513          	addi	a0,a0,44 # ffffffffc0205300 <commands+0xec8>
ffffffffc02022dc:	e2bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02022e0:	00003697          	auipc	a3,0x3
ffffffffc02022e4:	29068693          	addi	a3,a3,656 # ffffffffc0205570 <commands+0x1138>
ffffffffc02022e8:	00003617          	auipc	a2,0x3
ffffffffc02022ec:	b4060613          	addi	a2,a2,-1216 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02022f0:	12e00593          	li	a1,302
ffffffffc02022f4:	00003517          	auipc	a0,0x3
ffffffffc02022f8:	00c50513          	addi	a0,a0,12 # ffffffffc0205300 <commands+0xec8>
ffffffffc02022fc:	e0bfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0202300:	00003697          	auipc	a3,0x3
ffffffffc0202304:	2b868693          	addi	a3,a3,696 # ffffffffc02055b8 <commands+0x1180>
ffffffffc0202308:	00003617          	auipc	a2,0x3
ffffffffc020230c:	b2060613          	addi	a2,a2,-1248 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202310:	10a00593          	li	a1,266
ffffffffc0202314:	00003517          	auipc	a0,0x3
ffffffffc0202318:	fec50513          	addi	a0,a0,-20 # ffffffffc0205300 <commands+0xec8>
ffffffffc020231c:	debfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0202320:	00003697          	auipc	a3,0x3
ffffffffc0202324:	25068693          	addi	a3,a3,592 # ffffffffc0205570 <commands+0x1138>
ffffffffc0202328:	00003617          	auipc	a2,0x3
ffffffffc020232c:	b0060613          	addi	a2,a2,-1280 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202330:	0bd00593          	li	a1,189
ffffffffc0202334:	00003517          	auipc	a0,0x3
ffffffffc0202338:	fcc50513          	addi	a0,a0,-52 # ffffffffc0205300 <commands+0xec8>
ffffffffc020233c:	dcbfd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0202340:	00003697          	auipc	a3,0x3
ffffffffc0202344:	2a068693          	addi	a3,a3,672 # ffffffffc02055e0 <commands+0x11a8>
ffffffffc0202348:	00003617          	auipc	a2,0x3
ffffffffc020234c:	ae060613          	addi	a2,a2,-1312 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202350:	11600593          	li	a1,278
ffffffffc0202354:	00003517          	auipc	a0,0x3
ffffffffc0202358:	fac50513          	addi	a0,a0,-84 # ffffffffc0205300 <commands+0xec8>
ffffffffc020235c:	dabfd0ef          	jal	ra,ffffffffc0200106 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202360:	00003617          	auipc	a2,0x3
ffffffffc0202364:	99060613          	addi	a2,a2,-1648 # ffffffffc0204cf0 <commands+0x8b8>
ffffffffc0202368:	06500593          	li	a1,101
ffffffffc020236c:	00003517          	auipc	a0,0x3
ffffffffc0202370:	9a450513          	addi	a0,a0,-1628 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc0202374:	d93fd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(sum == 0);
ffffffffc0202378:	00003697          	auipc	a3,0x3
ffffffffc020237c:	28868693          	addi	a3,a3,648 # ffffffffc0205600 <commands+0x11c8>
ffffffffc0202380:	00003617          	auipc	a2,0x3
ffffffffc0202384:	aa860613          	addi	a2,a2,-1368 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202388:	12000593          	li	a1,288
ffffffffc020238c:	00003517          	auipc	a0,0x3
ffffffffc0202390:	f7450513          	addi	a0,a0,-140 # ffffffffc0205300 <commands+0xec8>
ffffffffc0202394:	d73fd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0202398:	00003697          	auipc	a3,0x3
ffffffffc020239c:	23868693          	addi	a3,a3,568 # ffffffffc02055d0 <commands+0x1198>
ffffffffc02023a0:	00003617          	auipc	a2,0x3
ffffffffc02023a4:	a8860613          	addi	a2,a2,-1400 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02023a8:	10d00593          	li	a1,269
ffffffffc02023ac:	00003517          	auipc	a0,0x3
ffffffffc02023b0:	f5450513          	addi	a0,a0,-172 # ffffffffc0205300 <commands+0xec8>
ffffffffc02023b4:	d53fd0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc02023b8 <do_pgfault>:
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
    extern list_entry_t *curr_ptr;
    cprintf("curr_ptr %p\n", (void*)curr_ptr);
ffffffffc02023b8:	0000f797          	auipc	a5,0xf
ffffffffc02023bc:	1e078793          	addi	a5,a5,480 # ffffffffc0211598 <curr_ptr>
ffffffffc02023c0:	638c                	ld	a1,0(a5)
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc02023c2:	7139                	addi	sp,sp,-64
ffffffffc02023c4:	f426                	sd	s1,40(sp)
ffffffffc02023c6:	84aa                	mv	s1,a0
    cprintf("curr_ptr %p\n", (void*)curr_ptr);
ffffffffc02023c8:	00003517          	auipc	a0,0x3
ffffffffc02023cc:	f4850513          	addi	a0,a0,-184 # ffffffffc0205310 <commands+0xed8>
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc02023d0:	fc06                	sd	ra,56(sp)
ffffffffc02023d2:	f822                	sd	s0,48(sp)
ffffffffc02023d4:	f04a                	sd	s2,32(sp)
ffffffffc02023d6:	8432                	mv	s0,a2
ffffffffc02023d8:	ec4e                	sd	s3,24(sp)
    cprintf("curr_ptr %p\n", (void*)curr_ptr);
ffffffffc02023da:	ce5fd0ef          	jal	ra,ffffffffc02000be <cprintf>
    
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc02023de:	85a2                	mv	a1,s0
ffffffffc02023e0:	8526                	mv	a0,s1
ffffffffc02023e2:	957ff0ef          	jal	ra,ffffffffc0201d38 <find_vma>

    pgfault_num++;
ffffffffc02023e6:	0000f797          	auipc	a5,0xf
ffffffffc02023ea:	07a78793          	addi	a5,a5,122 # ffffffffc0211460 <pgfault_num>
ffffffffc02023ee:	439c                	lw	a5,0(a5)
ffffffffc02023f0:	2785                	addiw	a5,a5,1
ffffffffc02023f2:	0000f717          	auipc	a4,0xf
ffffffffc02023f6:	06f72723          	sw	a5,110(a4) # ffffffffc0211460 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc02023fa:	c559                	beqz	a0,ffffffffc0202488 <do_pgfault+0xd0>
ffffffffc02023fc:	651c                	ld	a5,8(a0)
ffffffffc02023fe:	08f46563          	bltu	s0,a5,ffffffffc0202488 <do_pgfault+0xd0>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0202402:	6d1c                	ld	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc0202404:	49c1                	li	s3,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0202406:	8b89                	andi	a5,a5,2
ffffffffc0202408:	efb9                	bnez	a5,ffffffffc0202466 <do_pgfault+0xae>
        perm |= (PTE_R | PTE_W);
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc020240a:	767d                	lui	a2,0xfffff
    *   mm->pgdir : the PDT of these vma
    *
    */


    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc020240c:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc020240e:	8c71                	and	s0,s0,a2
    ptep = get_pte(mm->pgdir, addr, 1);  //(1) try to find a pte, if pte's
ffffffffc0202410:	85a2                	mv	a1,s0
ffffffffc0202412:	4605                	li	a2,1
ffffffffc0202414:	fe6fe0ef          	jal	ra,ffffffffc0200bfa <get_pte>
                                         //PT(Page Table) isn't existed, then
                                         //create a PT.
    if (*ptep == 0) {
ffffffffc0202418:	610c                	ld	a1,0(a0)
ffffffffc020241a:	c9a1                	beqz	a1,ffffffffc020246a <do_pgfault+0xb2>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc020241c:	0000f797          	auipc	a5,0xf
ffffffffc0202420:	05478793          	addi	a5,a5,84 # ffffffffc0211470 <swap_init_ok>
ffffffffc0202424:	439c                	lw	a5,0(a5)
ffffffffc0202426:	2781                	sext.w	a5,a5
ffffffffc0202428:	cbad                	beqz	a5,ffffffffc020249a <do_pgfault+0xe2>
            //(2) According to the mm,
            //addr AND page, setup the
            //map of phy addr <--->
            //logical addr
            //(3) make the page swappable.
            if(swap_in(mm,addr,&page)!=0)
ffffffffc020242a:	0030                	addi	a2,sp,8
ffffffffc020242c:	85a2                	mv	a1,s0
ffffffffc020242e:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc0202430:	e402                	sd	zero,8(sp)
            if(swap_in(mm,addr,&page)!=0)
ffffffffc0202432:	05d000ef          	jal	ra,ffffffffc0202c8e <swap_in>
ffffffffc0202436:	892a                	mv	s2,a0
ffffffffc0202438:	e92d                	bnez	a0,ffffffffc02024aa <do_pgfault+0xf2>
            {
                cprintf("swap_in in do_pgfault failed\n");
                goto failed;
            }
            page_insert(mm->pgdir,page,addr,perm);
ffffffffc020243a:	65a2                	ld	a1,8(sp)
ffffffffc020243c:	6c88                	ld	a0,24(s1)
ffffffffc020243e:	86ce                	mv	a3,s3
ffffffffc0202440:	8622                	mv	a2,s0
ffffffffc0202442:	a91fe0ef          	jal	ra,ffffffffc0200ed2 <page_insert>
            swap_map_swappable(mm,addr,page,1);
ffffffffc0202446:	6622                	ld	a2,8(sp)
ffffffffc0202448:	4685                	li	a3,1
ffffffffc020244a:	85a2                	mv	a1,s0
ffffffffc020244c:	8526                	mv	a0,s1
ffffffffc020244e:	71c000ef          	jal	ra,ffffffffc0202b6a <swap_map_swappable>
            page->pra_vaddr = addr;
ffffffffc0202452:	67a2                	ld	a5,8(sp)
ffffffffc0202454:	e3a0                	sd	s0,64(a5)
   }

   ret = 0;
failed:
    return ret;
}
ffffffffc0202456:	70e2                	ld	ra,56(sp)
ffffffffc0202458:	7442                	ld	s0,48(sp)
ffffffffc020245a:	854a                	mv	a0,s2
ffffffffc020245c:	74a2                	ld	s1,40(sp)
ffffffffc020245e:	7902                	ld	s2,32(sp)
ffffffffc0202460:	69e2                	ld	s3,24(sp)
ffffffffc0202462:	6121                	addi	sp,sp,64
ffffffffc0202464:	8082                	ret
        perm |= (PTE_R | PTE_W);
ffffffffc0202466:	49d9                	li	s3,22
ffffffffc0202468:	b74d                	j	ffffffffc020240a <do_pgfault+0x52>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc020246a:	6c88                	ld	a0,24(s1)
ffffffffc020246c:	864e                	mv	a2,s3
ffffffffc020246e:	85a2                	mv	a1,s0
ffffffffc0202470:	e16ff0ef          	jal	ra,ffffffffc0201a86 <pgdir_alloc_page>
   ret = 0;
ffffffffc0202474:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0202476:	f165                	bnez	a0,ffffffffc0202456 <do_pgfault+0x9e>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0202478:	00003517          	auipc	a0,0x3
ffffffffc020247c:	ed850513          	addi	a0,a0,-296 # ffffffffc0205350 <commands+0xf18>
ffffffffc0202480:	c3ffd0ef          	jal	ra,ffffffffc02000be <cprintf>
    ret = -E_NO_MEM;
ffffffffc0202484:	5971                	li	s2,-4
            goto failed;
ffffffffc0202486:	bfc1                	j	ffffffffc0202456 <do_pgfault+0x9e>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0202488:	85a2                	mv	a1,s0
ffffffffc020248a:	00003517          	auipc	a0,0x3
ffffffffc020248e:	e9650513          	addi	a0,a0,-362 # ffffffffc0205320 <commands+0xee8>
ffffffffc0202492:	c2dfd0ef          	jal	ra,ffffffffc02000be <cprintf>
    int ret = -E_INVAL;
ffffffffc0202496:	5975                	li	s2,-3
        goto failed;
ffffffffc0202498:	bf7d                	j	ffffffffc0202456 <do_pgfault+0x9e>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc020249a:	00003517          	auipc	a0,0x3
ffffffffc020249e:	efe50513          	addi	a0,a0,-258 # ffffffffc0205398 <commands+0xf60>
ffffffffc02024a2:	c1dfd0ef          	jal	ra,ffffffffc02000be <cprintf>
    ret = -E_NO_MEM;
ffffffffc02024a6:	5971                	li	s2,-4
            goto failed;
ffffffffc02024a8:	b77d                	j	ffffffffc0202456 <do_pgfault+0x9e>
                cprintf("swap_in in do_pgfault failed\n");
ffffffffc02024aa:	00003517          	auipc	a0,0x3
ffffffffc02024ae:	ece50513          	addi	a0,a0,-306 # ffffffffc0205378 <commands+0xf40>
ffffffffc02024b2:	c0dfd0ef          	jal	ra,ffffffffc02000be <cprintf>
    ret = -E_NO_MEM;
ffffffffc02024b6:	5971                	li	s2,-4
ffffffffc02024b8:	bf79                	j	ffffffffc0202456 <do_pgfault+0x9e>

ffffffffc02024ba <swap_init>:
unsigned int swap_in_seq_no[MAX_SEQ_NO],swap_out_seq_no[MAX_SEQ_NO];

static void check_swap(void);

int swap_init(void)
{
ffffffffc02024ba:	7135                	addi	sp,sp,-160
ffffffffc02024bc:	ed06                	sd	ra,152(sp)
ffffffffc02024be:	e922                	sd	s0,144(sp)
ffffffffc02024c0:	e526                	sd	s1,136(sp)
ffffffffc02024c2:	e14a                	sd	s2,128(sp)
ffffffffc02024c4:	fcce                	sd	s3,120(sp)
ffffffffc02024c6:	f8d2                	sd	s4,112(sp)
ffffffffc02024c8:	f4d6                	sd	s5,104(sp)
ffffffffc02024ca:	f0da                	sd	s6,96(sp)
ffffffffc02024cc:	ecde                	sd	s7,88(sp)
ffffffffc02024ce:	e8e2                	sd	s8,80(sp)
ffffffffc02024d0:	e4e6                	sd	s9,72(sp)
ffffffffc02024d2:	e0ea                	sd	s10,64(sp)
ffffffffc02024d4:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc02024d6:	716010ef          	jal	ra,ffffffffc0203bec <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc02024da:	0000f797          	auipc	a5,0xf
ffffffffc02024de:	06678793          	addi	a5,a5,102 # ffffffffc0211540 <max_swap_offset>
ffffffffc02024e2:	6394                	ld	a3,0(a5)
ffffffffc02024e4:	010007b7          	lui	a5,0x1000
ffffffffc02024e8:	17e1                	addi	a5,a5,-8
ffffffffc02024ea:	ff968713          	addi	a4,a3,-7
ffffffffc02024ee:	42e7ea63          	bltu	a5,a4,ffffffffc0202922 <swap_init+0x468>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc02024f2:	00008797          	auipc	a5,0x8
ffffffffc02024f6:	b0e78793          	addi	a5,a5,-1266 # ffffffffc020a000 <swap_manager_clock>
     int r = sm->init();
ffffffffc02024fa:	6798                	ld	a4,8(a5)
     sm = &swap_manager_clock;//use first in first out Page Replacement Algorithm
ffffffffc02024fc:	0000f697          	auipc	a3,0xf
ffffffffc0202500:	f6f6b623          	sd	a5,-148(a3) # ffffffffc0211468 <sm>
     int r = sm->init();
ffffffffc0202504:	9702                	jalr	a4
ffffffffc0202506:	8b2a                	mv	s6,a0
     
     if (r == 0)
ffffffffc0202508:	c10d                	beqz	a0,ffffffffc020252a <swap_init+0x70>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc020250a:	60ea                	ld	ra,152(sp)
ffffffffc020250c:	644a                	ld	s0,144(sp)
ffffffffc020250e:	855a                	mv	a0,s6
ffffffffc0202510:	64aa                	ld	s1,136(sp)
ffffffffc0202512:	690a                	ld	s2,128(sp)
ffffffffc0202514:	79e6                	ld	s3,120(sp)
ffffffffc0202516:	7a46                	ld	s4,112(sp)
ffffffffc0202518:	7aa6                	ld	s5,104(sp)
ffffffffc020251a:	7b06                	ld	s6,96(sp)
ffffffffc020251c:	6be6                	ld	s7,88(sp)
ffffffffc020251e:	6c46                	ld	s8,80(sp)
ffffffffc0202520:	6ca6                	ld	s9,72(sp)
ffffffffc0202522:	6d06                	ld	s10,64(sp)
ffffffffc0202524:	7de2                	ld	s11,56(sp)
ffffffffc0202526:	610d                	addi	sp,sp,160
ffffffffc0202528:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020252a:	0000f797          	auipc	a5,0xf
ffffffffc020252e:	f3e78793          	addi	a5,a5,-194 # ffffffffc0211468 <sm>
ffffffffc0202532:	639c                	ld	a5,0(a5)
ffffffffc0202534:	00003517          	auipc	a0,0x3
ffffffffc0202538:	1a450513          	addi	a0,a0,420 # ffffffffc02056d8 <commands+0x12a0>
ffffffffc020253c:	0000f417          	auipc	s0,0xf
ffffffffc0202540:	04440413          	addi	s0,s0,68 # ffffffffc0211580 <free_area>
ffffffffc0202544:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0202546:	4785                	li	a5,1
ffffffffc0202548:	0000f717          	auipc	a4,0xf
ffffffffc020254c:	f2f72423          	sw	a5,-216(a4) # ffffffffc0211470 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202550:	b6ffd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202554:	641c                	ld	a5,8(s0)
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202556:	2e878a63          	beq	a5,s0,ffffffffc020284a <swap_init+0x390>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020255a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020255e:	8305                	srli	a4,a4,0x1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0202560:	8b05                	andi	a4,a4,1
ffffffffc0202562:	2e070863          	beqz	a4,ffffffffc0202852 <swap_init+0x398>
     int ret, count = 0, total = 0, i;
ffffffffc0202566:	4481                	li	s1,0
ffffffffc0202568:	4901                	li	s2,0
ffffffffc020256a:	a031                	j	ffffffffc0202576 <swap_init+0xbc>
ffffffffc020256c:	fe87b703          	ld	a4,-24(a5)
        assert(PageProperty(p));
ffffffffc0202570:	8b09                	andi	a4,a4,2
ffffffffc0202572:	2e070063          	beqz	a4,ffffffffc0202852 <swap_init+0x398>
        count ++, total += p->property;
ffffffffc0202576:	ff87a703          	lw	a4,-8(a5)
ffffffffc020257a:	679c                	ld	a5,8(a5)
ffffffffc020257c:	2905                	addiw	s2,s2,1
ffffffffc020257e:	9cb9                	addw	s1,s1,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202580:	fe8796e3          	bne	a5,s0,ffffffffc020256c <swap_init+0xb2>
ffffffffc0202584:	89a6                	mv	s3,s1
     }
     assert(total == nr_free_pages());
ffffffffc0202586:	e34fe0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc020258a:	5b351863          	bne	a0,s3,ffffffffc0202b3a <swap_init+0x680>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc020258e:	8626                	mv	a2,s1
ffffffffc0202590:	85ca                	mv	a1,s2
ffffffffc0202592:	00003517          	auipc	a0,0x3
ffffffffc0202596:	18e50513          	addi	a0,a0,398 # ffffffffc0205720 <commands+0x12e8>
ffffffffc020259a:	b25fd0ef          	jal	ra,ffffffffc02000be <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc020259e:	f20ff0ef          	jal	ra,ffffffffc0201cbe <mm_create>
ffffffffc02025a2:	8baa                	mv	s7,a0
     assert(mm != NULL);
ffffffffc02025a4:	50050b63          	beqz	a0,ffffffffc0202aba <swap_init+0x600>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc02025a8:	0000f797          	auipc	a5,0xf
ffffffffc02025ac:	f0878793          	addi	a5,a5,-248 # ffffffffc02114b0 <check_mm_struct>
ffffffffc02025b0:	639c                	ld	a5,0(a5)
ffffffffc02025b2:	52079463          	bnez	a5,ffffffffc0202ada <swap_init+0x620>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02025b6:	0000f797          	auipc	a5,0xf
ffffffffc02025ba:	e9a78793          	addi	a5,a5,-358 # ffffffffc0211450 <boot_pgdir>
ffffffffc02025be:	6398                	ld	a4,0(a5)
     check_mm_struct = mm;
ffffffffc02025c0:	0000f797          	auipc	a5,0xf
ffffffffc02025c4:	eea7b823          	sd	a0,-272(a5) # ffffffffc02114b0 <check_mm_struct>
     assert(pgdir[0] == 0);
ffffffffc02025c8:	631c                	ld	a5,0(a4)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02025ca:	ec3a                	sd	a4,24(sp)
ffffffffc02025cc:	ed18                	sd	a4,24(a0)
     assert(pgdir[0] == 0);
ffffffffc02025ce:	52079663          	bnez	a5,ffffffffc0202afa <swap_init+0x640>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc02025d2:	6599                	lui	a1,0x6
ffffffffc02025d4:	460d                	li	a2,3
ffffffffc02025d6:	6505                	lui	a0,0x1
ffffffffc02025d8:	f32ff0ef          	jal	ra,ffffffffc0201d0a <vma_create>
ffffffffc02025dc:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc02025de:	52050e63          	beqz	a0,ffffffffc0202b1a <swap_init+0x660>

     insert_vma_struct(mm, vma);
ffffffffc02025e2:	855e                	mv	a0,s7
ffffffffc02025e4:	f92ff0ef          	jal	ra,ffffffffc0201d76 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc02025e8:	00003517          	auipc	a0,0x3
ffffffffc02025ec:	17850513          	addi	a0,a0,376 # ffffffffc0205760 <commands+0x1328>
ffffffffc02025f0:	acffd0ef          	jal	ra,ffffffffc02000be <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc02025f4:	018bb503          	ld	a0,24(s7)
ffffffffc02025f8:	4605                	li	a2,1
ffffffffc02025fa:	6585                	lui	a1,0x1
ffffffffc02025fc:	dfefe0ef          	jal	ra,ffffffffc0200bfa <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0202600:	40050d63          	beqz	a0,ffffffffc0202a1a <swap_init+0x560>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202604:	00003517          	auipc	a0,0x3
ffffffffc0202608:	1ac50513          	addi	a0,a0,428 # ffffffffc02057b0 <commands+0x1378>
ffffffffc020260c:	0000fa17          	auipc	s4,0xf
ffffffffc0202610:	eaca0a13          	addi	s4,s4,-340 # ffffffffc02114b8 <check_rp>
ffffffffc0202614:	aabfd0ef          	jal	ra,ffffffffc02000be <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202618:	0000fa97          	auipc	s5,0xf
ffffffffc020261c:	ec0a8a93          	addi	s5,s5,-320 # ffffffffc02114d8 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202620:	89d2                	mv	s3,s4
          check_rp[i] = alloc_page();
ffffffffc0202622:	4505                	li	a0,1
ffffffffc0202624:	cc8fe0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202628:	00a9b023          	sd	a0,0(s3) # fffffffffff80000 <end+0x3fd6ea60>
          assert(check_rp[i] != NULL );
ffffffffc020262c:	2a050b63          	beqz	a0,ffffffffc02028e2 <swap_init+0x428>
ffffffffc0202630:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0202632:	8b89                	andi	a5,a5,2
ffffffffc0202634:	28079763          	bnez	a5,ffffffffc02028c2 <swap_init+0x408>
ffffffffc0202638:	09a1                	addi	s3,s3,8
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020263a:	ff5994e3          	bne	s3,s5,ffffffffc0202622 <swap_init+0x168>
     }
     list_entry_t free_list_store = free_list;
ffffffffc020263e:	601c                	ld	a5,0(s0)
ffffffffc0202640:	00843983          	ld	s3,8(s0)
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
ffffffffc0202644:	0000fd17          	auipc	s10,0xf
ffffffffc0202648:	e74d0d13          	addi	s10,s10,-396 # ffffffffc02114b8 <check_rp>
     list_entry_t free_list_store = free_list;
ffffffffc020264c:	f03e                	sd	a5,32(sp)
     unsigned int nr_free_store = nr_free;
ffffffffc020264e:	481c                	lw	a5,16(s0)
ffffffffc0202650:	f43e                	sd	a5,40(sp)
    elm->prev = elm->next = elm;
ffffffffc0202652:	0000f797          	auipc	a5,0xf
ffffffffc0202656:	f287bb23          	sd	s0,-202(a5) # ffffffffc0211588 <free_area+0x8>
ffffffffc020265a:	0000f797          	auipc	a5,0xf
ffffffffc020265e:	f287b323          	sd	s0,-218(a5) # ffffffffc0211580 <free_area>
     nr_free = 0;
ffffffffc0202662:	0000f797          	auipc	a5,0xf
ffffffffc0202666:	f207a723          	sw	zero,-210(a5) # ffffffffc0211590 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc020266a:	000d3503          	ld	a0,0(s10)
ffffffffc020266e:	4585                	li	a1,1
ffffffffc0202670:	0d21                	addi	s10,s10,8
ffffffffc0202672:	d02fe0ef          	jal	ra,ffffffffc0200b74 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202676:	ff5d1ae3          	bne	s10,s5,ffffffffc020266a <swap_init+0x1b0>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc020267a:	01042d03          	lw	s10,16(s0)
ffffffffc020267e:	4791                	li	a5,4
ffffffffc0202680:	36fd1d63          	bne	s10,a5,ffffffffc02029fa <swap_init+0x540>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0202684:	00003517          	auipc	a0,0x3
ffffffffc0202688:	1b450513          	addi	a0,a0,436 # ffffffffc0205838 <commands+0x1400>
ffffffffc020268c:	a33fd0ef          	jal	ra,ffffffffc02000be <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202690:	6685                	lui	a3,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0202692:	0000f797          	auipc	a5,0xf
ffffffffc0202696:	dc07a723          	sw	zero,-562(a5) # ffffffffc0211460 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc020269a:	4629                	li	a2,10
     pgfault_num=0;
ffffffffc020269c:	0000f797          	auipc	a5,0xf
ffffffffc02026a0:	dc478793          	addi	a5,a5,-572 # ffffffffc0211460 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02026a4:	00c68023          	sb	a2,0(a3) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc02026a8:	4398                	lw	a4,0(a5)
ffffffffc02026aa:	4585                	li	a1,1
ffffffffc02026ac:	2701                	sext.w	a4,a4
ffffffffc02026ae:	30b71663          	bne	a4,a1,ffffffffc02029ba <swap_init+0x500>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc02026b2:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==1);
ffffffffc02026b6:	4394                	lw	a3,0(a5)
ffffffffc02026b8:	2681                	sext.w	a3,a3
ffffffffc02026ba:	32e69063          	bne	a3,a4,ffffffffc02029da <swap_init+0x520>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc02026be:	6689                	lui	a3,0x2
ffffffffc02026c0:	462d                	li	a2,11
ffffffffc02026c2:	00c68023          	sb	a2,0(a3) # 2000 <BASE_ADDRESS-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc02026c6:	4398                	lw	a4,0(a5)
ffffffffc02026c8:	4589                	li	a1,2
ffffffffc02026ca:	2701                	sext.w	a4,a4
ffffffffc02026cc:	26b71763          	bne	a4,a1,ffffffffc020293a <swap_init+0x480>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc02026d0:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==2);
ffffffffc02026d4:	4394                	lw	a3,0(a5)
ffffffffc02026d6:	2681                	sext.w	a3,a3
ffffffffc02026d8:	28e69163          	bne	a3,a4,ffffffffc020295a <swap_init+0x4a0>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc02026dc:	668d                	lui	a3,0x3
ffffffffc02026de:	4631                	li	a2,12
ffffffffc02026e0:	00c68023          	sb	a2,0(a3) # 3000 <BASE_ADDRESS-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc02026e4:	4398                	lw	a4,0(a5)
ffffffffc02026e6:	458d                	li	a1,3
ffffffffc02026e8:	2701                	sext.w	a4,a4
ffffffffc02026ea:	28b71863          	bne	a4,a1,ffffffffc020297a <swap_init+0x4c0>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc02026ee:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==3);
ffffffffc02026f2:	4394                	lw	a3,0(a5)
ffffffffc02026f4:	2681                	sext.w	a3,a3
ffffffffc02026f6:	2ae69263          	bne	a3,a4,ffffffffc020299a <swap_init+0x4e0>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc02026fa:	6691                	lui	a3,0x4
ffffffffc02026fc:	4635                	li	a2,13
ffffffffc02026fe:	00c68023          	sb	a2,0(a3) # 4000 <BASE_ADDRESS-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc0202702:	4398                	lw	a4,0(a5)
ffffffffc0202704:	2701                	sext.w	a4,a4
ffffffffc0202706:	33a71a63          	bne	a4,s10,ffffffffc0202a3a <swap_init+0x580>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc020270a:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==4);
ffffffffc020270e:	439c                	lw	a5,0(a5)
ffffffffc0202710:	2781                	sext.w	a5,a5
ffffffffc0202712:	34e79463          	bne	a5,a4,ffffffffc0202a5a <swap_init+0x5a0>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0202716:	481c                	lw	a5,16(s0)
ffffffffc0202718:	36079163          	bnez	a5,ffffffffc0202a7a <swap_init+0x5c0>
ffffffffc020271c:	0000f797          	auipc	a5,0xf
ffffffffc0202720:	dbc78793          	addi	a5,a5,-580 # ffffffffc02114d8 <swap_in_seq_no>
ffffffffc0202724:	0000f717          	auipc	a4,0xf
ffffffffc0202728:	ddc70713          	addi	a4,a4,-548 # ffffffffc0211500 <swap_out_seq_no>
ffffffffc020272c:	0000f617          	auipc	a2,0xf
ffffffffc0202730:	dd460613          	addi	a2,a2,-556 # ffffffffc0211500 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0202734:	56fd                	li	a3,-1
ffffffffc0202736:	c394                	sw	a3,0(a5)
ffffffffc0202738:	c314                	sw	a3,0(a4)
ffffffffc020273a:	0791                	addi	a5,a5,4
ffffffffc020273c:	0711                	addi	a4,a4,4
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc020273e:	fec79ce3          	bne	a5,a2,ffffffffc0202736 <swap_init+0x27c>
ffffffffc0202742:	0000f697          	auipc	a3,0xf
ffffffffc0202746:	e1e68693          	addi	a3,a3,-482 # ffffffffc0211560 <check_ptep>
ffffffffc020274a:	0000f817          	auipc	a6,0xf
ffffffffc020274e:	d6e80813          	addi	a6,a6,-658 # ffffffffc02114b8 <check_rp>
ffffffffc0202752:	6c05                	lui	s8,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202754:	0000fc97          	auipc	s9,0xf
ffffffffc0202758:	d04c8c93          	addi	s9,s9,-764 # ffffffffc0211458 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020275c:	0000fd97          	auipc	s11,0xf
ffffffffc0202760:	d3cd8d93          	addi	s11,s11,-708 # ffffffffc0211498 <pages>
ffffffffc0202764:	00004d17          	auipc	s10,0x4
ffffffffc0202768:	99cd0d13          	addi	s10,s10,-1636 # ffffffffc0206100 <nbase>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020276c:	6562                	ld	a0,24(sp)
         check_ptep[i]=0;
ffffffffc020276e:	0006b023          	sd	zero,0(a3)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202772:	4601                	li	a2,0
ffffffffc0202774:	85e2                	mv	a1,s8
ffffffffc0202776:	e842                	sd	a6,16(sp)
         check_ptep[i]=0;
ffffffffc0202778:	e436                	sd	a3,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020277a:	c80fe0ef          	jal	ra,ffffffffc0200bfa <get_pte>
ffffffffc020277e:	66a2                	ld	a3,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc0202780:	6842                	ld	a6,16(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202782:	e288                	sd	a0,0(a3)
         assert(check_ptep[i] != NULL);
ffffffffc0202784:	16050f63          	beqz	a0,ffffffffc0202902 <swap_init+0x448>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202788:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc020278a:	0017f613          	andi	a2,a5,1
ffffffffc020278e:	10060263          	beqz	a2,ffffffffc0202892 <swap_init+0x3d8>
    if (PPN(pa) >= npage) {
ffffffffc0202792:	000cb603          	ld	a2,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202796:	078a                	slli	a5,a5,0x2
ffffffffc0202798:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020279a:	10c7f863          	bleu	a2,a5,ffffffffc02028aa <swap_init+0x3f0>
    return &pages[PPN(pa) - nbase];
ffffffffc020279e:	000d3603          	ld	a2,0(s10)
ffffffffc02027a2:	000db583          	ld	a1,0(s11)
ffffffffc02027a6:	00083503          	ld	a0,0(a6)
ffffffffc02027aa:	8f91                	sub	a5,a5,a2
ffffffffc02027ac:	00379613          	slli	a2,a5,0x3
ffffffffc02027b0:	97b2                	add	a5,a5,a2
ffffffffc02027b2:	078e                	slli	a5,a5,0x3
ffffffffc02027b4:	97ae                	add	a5,a5,a1
ffffffffc02027b6:	0af51e63          	bne	a0,a5,ffffffffc0202872 <swap_init+0x3b8>
ffffffffc02027ba:	6785                	lui	a5,0x1
ffffffffc02027bc:	9c3e                	add	s8,s8,a5
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02027be:	6795                	lui	a5,0x5
ffffffffc02027c0:	06a1                	addi	a3,a3,8
ffffffffc02027c2:	0821                	addi	a6,a6,8
ffffffffc02027c4:	fafc14e3          	bne	s8,a5,ffffffffc020276c <swap_init+0x2b2>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc02027c8:	00003517          	auipc	a0,0x3
ffffffffc02027cc:	12850513          	addi	a0,a0,296 # ffffffffc02058f0 <commands+0x14b8>
ffffffffc02027d0:	8effd0ef          	jal	ra,ffffffffc02000be <cprintf>
    int ret = sm->check_swap();
ffffffffc02027d4:	0000f797          	auipc	a5,0xf
ffffffffc02027d8:	c9478793          	addi	a5,a5,-876 # ffffffffc0211468 <sm>
ffffffffc02027dc:	639c                	ld	a5,0(a5)
ffffffffc02027de:	7f9c                	ld	a5,56(a5)
ffffffffc02027e0:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc02027e2:	2a051c63          	bnez	a0,ffffffffc0202a9a <swap_init+0x5e0>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc02027e6:	000a3503          	ld	a0,0(s4)
ffffffffc02027ea:	4585                	li	a1,1
ffffffffc02027ec:	0a21                	addi	s4,s4,8
ffffffffc02027ee:	b86fe0ef          	jal	ra,ffffffffc0200b74 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02027f2:	ff5a1ae3          	bne	s4,s5,ffffffffc02027e6 <swap_init+0x32c>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
ffffffffc02027f6:	855e                	mv	a0,s7
ffffffffc02027f8:	e4cff0ef          	jal	ra,ffffffffc0201e44 <mm_destroy>
         
     nr_free = nr_free_store;
ffffffffc02027fc:	77a2                	ld	a5,40(sp)
ffffffffc02027fe:	0000f717          	auipc	a4,0xf
ffffffffc0202802:	d8f72923          	sw	a5,-622(a4) # ffffffffc0211590 <free_area+0x10>
     free_list = free_list_store;
ffffffffc0202806:	7782                	ld	a5,32(sp)
ffffffffc0202808:	0000f717          	auipc	a4,0xf
ffffffffc020280c:	d6f73c23          	sd	a5,-648(a4) # ffffffffc0211580 <free_area>
ffffffffc0202810:	0000f797          	auipc	a5,0xf
ffffffffc0202814:	d737bc23          	sd	s3,-648(a5) # ffffffffc0211588 <free_area+0x8>

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202818:	00898a63          	beq	s3,s0,ffffffffc020282c <swap_init+0x372>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc020281c:	ff89a783          	lw	a5,-8(s3)
    return listelm->next;
ffffffffc0202820:	0089b983          	ld	s3,8(s3)
ffffffffc0202824:	397d                	addiw	s2,s2,-1
ffffffffc0202826:	9c9d                	subw	s1,s1,a5
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202828:	fe899ae3          	bne	s3,s0,ffffffffc020281c <swap_init+0x362>
     }
     cprintf("count is %d, total is %d\n",count,total);
ffffffffc020282c:	8626                	mv	a2,s1
ffffffffc020282e:	85ca                	mv	a1,s2
ffffffffc0202830:	00003517          	auipc	a0,0x3
ffffffffc0202834:	0f050513          	addi	a0,a0,240 # ffffffffc0205920 <commands+0x14e8>
ffffffffc0202838:	887fd0ef          	jal	ra,ffffffffc02000be <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
ffffffffc020283c:	00003517          	auipc	a0,0x3
ffffffffc0202840:	10450513          	addi	a0,a0,260 # ffffffffc0205940 <commands+0x1508>
ffffffffc0202844:	87bfd0ef          	jal	ra,ffffffffc02000be <cprintf>
ffffffffc0202848:	b1c9                	j	ffffffffc020250a <swap_init+0x50>
     int ret, count = 0, total = 0, i;
ffffffffc020284a:	4481                	li	s1,0
ffffffffc020284c:	4901                	li	s2,0
     while ((le = list_next(le)) != &free_list) {
ffffffffc020284e:	4981                	li	s3,0
ffffffffc0202850:	bb1d                	j	ffffffffc0202586 <swap_init+0xcc>
        assert(PageProperty(p));
ffffffffc0202852:	00003697          	auipc	a3,0x3
ffffffffc0202856:	e9e68693          	addi	a3,a3,-354 # ffffffffc02056f0 <commands+0x12b8>
ffffffffc020285a:	00002617          	auipc	a2,0x2
ffffffffc020285e:	5ce60613          	addi	a2,a2,1486 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202862:	0b900593          	li	a1,185
ffffffffc0202866:	00003517          	auipc	a0,0x3
ffffffffc020286a:	e6250513          	addi	a0,a0,-414 # ffffffffc02056c8 <commands+0x1290>
ffffffffc020286e:	899fd0ef          	jal	ra,ffffffffc0200106 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202872:	00003697          	auipc	a3,0x3
ffffffffc0202876:	05668693          	addi	a3,a3,86 # ffffffffc02058c8 <commands+0x1490>
ffffffffc020287a:	00002617          	auipc	a2,0x2
ffffffffc020287e:	5ae60613          	addi	a2,a2,1454 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202882:	0f900593          	li	a1,249
ffffffffc0202886:	00003517          	auipc	a0,0x3
ffffffffc020288a:	e4250513          	addi	a0,a0,-446 # ffffffffc02056c8 <commands+0x1290>
ffffffffc020288e:	879fd0ef          	jal	ra,ffffffffc0200106 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0202892:	00002617          	auipc	a2,0x2
ffffffffc0202896:	66e60613          	addi	a2,a2,1646 # ffffffffc0204f00 <commands+0xac8>
ffffffffc020289a:	07000593          	li	a1,112
ffffffffc020289e:	00002517          	auipc	a0,0x2
ffffffffc02028a2:	47250513          	addi	a0,a0,1138 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc02028a6:	861fd0ef          	jal	ra,ffffffffc0200106 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02028aa:	00002617          	auipc	a2,0x2
ffffffffc02028ae:	44660613          	addi	a2,a2,1094 # ffffffffc0204cf0 <commands+0x8b8>
ffffffffc02028b2:	06500593          	li	a1,101
ffffffffc02028b6:	00002517          	auipc	a0,0x2
ffffffffc02028ba:	45a50513          	addi	a0,a0,1114 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc02028be:	849fd0ef          	jal	ra,ffffffffc0200106 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc02028c2:	00003697          	auipc	a3,0x3
ffffffffc02028c6:	f2e68693          	addi	a3,a3,-210 # ffffffffc02057f0 <commands+0x13b8>
ffffffffc02028ca:	00002617          	auipc	a2,0x2
ffffffffc02028ce:	55e60613          	addi	a2,a2,1374 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02028d2:	0da00593          	li	a1,218
ffffffffc02028d6:	00003517          	auipc	a0,0x3
ffffffffc02028da:	df250513          	addi	a0,a0,-526 # ffffffffc02056c8 <commands+0x1290>
ffffffffc02028de:	829fd0ef          	jal	ra,ffffffffc0200106 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc02028e2:	00003697          	auipc	a3,0x3
ffffffffc02028e6:	ef668693          	addi	a3,a3,-266 # ffffffffc02057d8 <commands+0x13a0>
ffffffffc02028ea:	00002617          	auipc	a2,0x2
ffffffffc02028ee:	53e60613          	addi	a2,a2,1342 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02028f2:	0d900593          	li	a1,217
ffffffffc02028f6:	00003517          	auipc	a0,0x3
ffffffffc02028fa:	dd250513          	addi	a0,a0,-558 # ffffffffc02056c8 <commands+0x1290>
ffffffffc02028fe:	809fd0ef          	jal	ra,ffffffffc0200106 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc0202902:	00003697          	auipc	a3,0x3
ffffffffc0202906:	fae68693          	addi	a3,a3,-82 # ffffffffc02058b0 <commands+0x1478>
ffffffffc020290a:	00002617          	auipc	a2,0x2
ffffffffc020290e:	51e60613          	addi	a2,a2,1310 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202912:	0f800593          	li	a1,248
ffffffffc0202916:	00003517          	auipc	a0,0x3
ffffffffc020291a:	db250513          	addi	a0,a0,-590 # ffffffffc02056c8 <commands+0x1290>
ffffffffc020291e:	fe8fd0ef          	jal	ra,ffffffffc0200106 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0202922:	00003617          	auipc	a2,0x3
ffffffffc0202926:	d8660613          	addi	a2,a2,-634 # ffffffffc02056a8 <commands+0x1270>
ffffffffc020292a:	02600593          	li	a1,38
ffffffffc020292e:	00003517          	auipc	a0,0x3
ffffffffc0202932:	d9a50513          	addi	a0,a0,-614 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202936:	fd0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==2);
ffffffffc020293a:	00003697          	auipc	a3,0x3
ffffffffc020293e:	f3668693          	addi	a3,a3,-202 # ffffffffc0205870 <commands+0x1438>
ffffffffc0202942:	00002617          	auipc	a2,0x2
ffffffffc0202946:	4e660613          	addi	a2,a2,1254 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020294a:	09400593          	li	a1,148
ffffffffc020294e:	00003517          	auipc	a0,0x3
ffffffffc0202952:	d7a50513          	addi	a0,a0,-646 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202956:	fb0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==2);
ffffffffc020295a:	00003697          	auipc	a3,0x3
ffffffffc020295e:	f1668693          	addi	a3,a3,-234 # ffffffffc0205870 <commands+0x1438>
ffffffffc0202962:	00002617          	auipc	a2,0x2
ffffffffc0202966:	4c660613          	addi	a2,a2,1222 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020296a:	09600593          	li	a1,150
ffffffffc020296e:	00003517          	auipc	a0,0x3
ffffffffc0202972:	d5a50513          	addi	a0,a0,-678 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202976:	f90fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==3);
ffffffffc020297a:	00003697          	auipc	a3,0x3
ffffffffc020297e:	f0668693          	addi	a3,a3,-250 # ffffffffc0205880 <commands+0x1448>
ffffffffc0202982:	00002617          	auipc	a2,0x2
ffffffffc0202986:	4a660613          	addi	a2,a2,1190 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020298a:	09800593          	li	a1,152
ffffffffc020298e:	00003517          	auipc	a0,0x3
ffffffffc0202992:	d3a50513          	addi	a0,a0,-710 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202996:	f70fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==3);
ffffffffc020299a:	00003697          	auipc	a3,0x3
ffffffffc020299e:	ee668693          	addi	a3,a3,-282 # ffffffffc0205880 <commands+0x1448>
ffffffffc02029a2:	00002617          	auipc	a2,0x2
ffffffffc02029a6:	48660613          	addi	a2,a2,1158 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02029aa:	09a00593          	li	a1,154
ffffffffc02029ae:	00003517          	auipc	a0,0x3
ffffffffc02029b2:	d1a50513          	addi	a0,a0,-742 # ffffffffc02056c8 <commands+0x1290>
ffffffffc02029b6:	f50fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==1);
ffffffffc02029ba:	00003697          	auipc	a3,0x3
ffffffffc02029be:	ea668693          	addi	a3,a3,-346 # ffffffffc0205860 <commands+0x1428>
ffffffffc02029c2:	00002617          	auipc	a2,0x2
ffffffffc02029c6:	46660613          	addi	a2,a2,1126 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02029ca:	09000593          	li	a1,144
ffffffffc02029ce:	00003517          	auipc	a0,0x3
ffffffffc02029d2:	cfa50513          	addi	a0,a0,-774 # ffffffffc02056c8 <commands+0x1290>
ffffffffc02029d6:	f30fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==1);
ffffffffc02029da:	00003697          	auipc	a3,0x3
ffffffffc02029de:	e8668693          	addi	a3,a3,-378 # ffffffffc0205860 <commands+0x1428>
ffffffffc02029e2:	00002617          	auipc	a2,0x2
ffffffffc02029e6:	44660613          	addi	a2,a2,1094 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02029ea:	09200593          	li	a1,146
ffffffffc02029ee:	00003517          	auipc	a0,0x3
ffffffffc02029f2:	cda50513          	addi	a0,a0,-806 # ffffffffc02056c8 <commands+0x1290>
ffffffffc02029f6:	f10fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02029fa:	00003697          	auipc	a3,0x3
ffffffffc02029fe:	e1668693          	addi	a3,a3,-490 # ffffffffc0205810 <commands+0x13d8>
ffffffffc0202a02:	00002617          	auipc	a2,0x2
ffffffffc0202a06:	42660613          	addi	a2,a2,1062 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202a0a:	0e700593          	li	a1,231
ffffffffc0202a0e:	00003517          	auipc	a0,0x3
ffffffffc0202a12:	cba50513          	addi	a0,a0,-838 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202a16:	ef0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0202a1a:	00003697          	auipc	a3,0x3
ffffffffc0202a1e:	d7e68693          	addi	a3,a3,-642 # ffffffffc0205798 <commands+0x1360>
ffffffffc0202a22:	00002617          	auipc	a2,0x2
ffffffffc0202a26:	40660613          	addi	a2,a2,1030 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202a2a:	0d400593          	li	a1,212
ffffffffc0202a2e:	00003517          	auipc	a0,0x3
ffffffffc0202a32:	c9a50513          	addi	a0,a0,-870 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202a36:	ed0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==4);
ffffffffc0202a3a:	00003697          	auipc	a3,0x3
ffffffffc0202a3e:	e5668693          	addi	a3,a3,-426 # ffffffffc0205890 <commands+0x1458>
ffffffffc0202a42:	00002617          	auipc	a2,0x2
ffffffffc0202a46:	3e660613          	addi	a2,a2,998 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202a4a:	09c00593          	li	a1,156
ffffffffc0202a4e:	00003517          	auipc	a0,0x3
ffffffffc0202a52:	c7a50513          	addi	a0,a0,-902 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202a56:	eb0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgfault_num==4);
ffffffffc0202a5a:	00003697          	auipc	a3,0x3
ffffffffc0202a5e:	e3668693          	addi	a3,a3,-458 # ffffffffc0205890 <commands+0x1458>
ffffffffc0202a62:	00002617          	auipc	a2,0x2
ffffffffc0202a66:	3c660613          	addi	a2,a2,966 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202a6a:	09e00593          	li	a1,158
ffffffffc0202a6e:	00003517          	auipc	a0,0x3
ffffffffc0202a72:	c5a50513          	addi	a0,a0,-934 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202a76:	e90fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert( nr_free == 0);         
ffffffffc0202a7a:	00003697          	auipc	a3,0x3
ffffffffc0202a7e:	e2668693          	addi	a3,a3,-474 # ffffffffc02058a0 <commands+0x1468>
ffffffffc0202a82:	00002617          	auipc	a2,0x2
ffffffffc0202a86:	3a660613          	addi	a2,a2,934 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202a8a:	0f000593          	li	a1,240
ffffffffc0202a8e:	00003517          	auipc	a0,0x3
ffffffffc0202a92:	c3a50513          	addi	a0,a0,-966 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202a96:	e70fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(ret==0);
ffffffffc0202a9a:	00003697          	auipc	a3,0x3
ffffffffc0202a9e:	e7e68693          	addi	a3,a3,-386 # ffffffffc0205918 <commands+0x14e0>
ffffffffc0202aa2:	00002617          	auipc	a2,0x2
ffffffffc0202aa6:	38660613          	addi	a2,a2,902 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202aaa:	0ff00593          	li	a1,255
ffffffffc0202aae:	00003517          	auipc	a0,0x3
ffffffffc0202ab2:	c1a50513          	addi	a0,a0,-998 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202ab6:	e50fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(mm != NULL);
ffffffffc0202aba:	00003697          	auipc	a3,0x3
ffffffffc0202abe:	96668693          	addi	a3,a3,-1690 # ffffffffc0205420 <commands+0xfe8>
ffffffffc0202ac2:	00002617          	auipc	a2,0x2
ffffffffc0202ac6:	36660613          	addi	a2,a2,870 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202aca:	0c100593          	li	a1,193
ffffffffc0202ace:	00003517          	auipc	a0,0x3
ffffffffc0202ad2:	bfa50513          	addi	a0,a0,-1030 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202ad6:	e30fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0202ada:	00003697          	auipc	a3,0x3
ffffffffc0202ade:	c6e68693          	addi	a3,a3,-914 # ffffffffc0205748 <commands+0x1310>
ffffffffc0202ae2:	00002617          	auipc	a2,0x2
ffffffffc0202ae6:	34660613          	addi	a2,a2,838 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202aea:	0c400593          	li	a1,196
ffffffffc0202aee:	00003517          	auipc	a0,0x3
ffffffffc0202af2:	bda50513          	addi	a0,a0,-1062 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202af6:	e10fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0202afa:	00003697          	auipc	a3,0x3
ffffffffc0202afe:	ad668693          	addi	a3,a3,-1322 # ffffffffc02055d0 <commands+0x1198>
ffffffffc0202b02:	00002617          	auipc	a2,0x2
ffffffffc0202b06:	32660613          	addi	a2,a2,806 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202b0a:	0c900593          	li	a1,201
ffffffffc0202b0e:	00003517          	auipc	a0,0x3
ffffffffc0202b12:	bba50513          	addi	a0,a0,-1094 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202b16:	df0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(vma != NULL);
ffffffffc0202b1a:	00003697          	auipc	a3,0x3
ffffffffc0202b1e:	b2e68693          	addi	a3,a3,-1234 # ffffffffc0205648 <commands+0x1210>
ffffffffc0202b22:	00002617          	auipc	a2,0x2
ffffffffc0202b26:	30660613          	addi	a2,a2,774 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202b2a:	0cc00593          	li	a1,204
ffffffffc0202b2e:	00003517          	auipc	a0,0x3
ffffffffc0202b32:	b9a50513          	addi	a0,a0,-1126 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202b36:	dd0fd0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(total == nr_free_pages());
ffffffffc0202b3a:	00003697          	auipc	a3,0x3
ffffffffc0202b3e:	bc668693          	addi	a3,a3,-1082 # ffffffffc0205700 <commands+0x12c8>
ffffffffc0202b42:	00002617          	auipc	a2,0x2
ffffffffc0202b46:	2e660613          	addi	a2,a2,742 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202b4a:	0bc00593          	li	a1,188
ffffffffc0202b4e:	00003517          	auipc	a0,0x3
ffffffffc0202b52:	b7a50513          	addi	a0,a0,-1158 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202b56:	db0fd0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0202b5a <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0202b5a:	0000f797          	auipc	a5,0xf
ffffffffc0202b5e:	90e78793          	addi	a5,a5,-1778 # ffffffffc0211468 <sm>
ffffffffc0202b62:	639c                	ld	a5,0(a5)
ffffffffc0202b64:	0107b303          	ld	t1,16(a5)
ffffffffc0202b68:	8302                	jr	t1

ffffffffc0202b6a <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0202b6a:	0000f797          	auipc	a5,0xf
ffffffffc0202b6e:	8fe78793          	addi	a5,a5,-1794 # ffffffffc0211468 <sm>
ffffffffc0202b72:	639c                	ld	a5,0(a5)
ffffffffc0202b74:	0207b303          	ld	t1,32(a5)
ffffffffc0202b78:	8302                	jr	t1

ffffffffc0202b7a <swap_out>:
{
ffffffffc0202b7a:	711d                	addi	sp,sp,-96
ffffffffc0202b7c:	ec86                	sd	ra,88(sp)
ffffffffc0202b7e:	e8a2                	sd	s0,80(sp)
ffffffffc0202b80:	e4a6                	sd	s1,72(sp)
ffffffffc0202b82:	e0ca                	sd	s2,64(sp)
ffffffffc0202b84:	fc4e                	sd	s3,56(sp)
ffffffffc0202b86:	f852                	sd	s4,48(sp)
ffffffffc0202b88:	f456                	sd	s5,40(sp)
ffffffffc0202b8a:	f05a                	sd	s6,32(sp)
ffffffffc0202b8c:	ec5e                	sd	s7,24(sp)
ffffffffc0202b8e:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0202b90:	cde9                	beqz	a1,ffffffffc0202c6a <swap_out+0xf0>
ffffffffc0202b92:	8ab2                	mv	s5,a2
ffffffffc0202b94:	892a                	mv	s2,a0
ffffffffc0202b96:	8a2e                	mv	s4,a1
ffffffffc0202b98:	4401                	li	s0,0
ffffffffc0202b9a:	0000f997          	auipc	s3,0xf
ffffffffc0202b9e:	8ce98993          	addi	s3,s3,-1842 # ffffffffc0211468 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202ba2:	00003b17          	auipc	s6,0x3
ffffffffc0202ba6:	e1eb0b13          	addi	s6,s6,-482 # ffffffffc02059c0 <commands+0x1588>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202baa:	00003b97          	auipc	s7,0x3
ffffffffc0202bae:	dfeb8b93          	addi	s7,s7,-514 # ffffffffc02059a8 <commands+0x1570>
ffffffffc0202bb2:	a825                	j	ffffffffc0202bea <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202bb4:	67a2                	ld	a5,8(sp)
ffffffffc0202bb6:	8626                	mv	a2,s1
ffffffffc0202bb8:	85a2                	mv	a1,s0
ffffffffc0202bba:	63b4                	ld	a3,64(a5)
ffffffffc0202bbc:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0202bbe:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0202bc0:	82b1                	srli	a3,a3,0xc
ffffffffc0202bc2:	0685                	addi	a3,a3,1
ffffffffc0202bc4:	cfafd0ef          	jal	ra,ffffffffc02000be <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202bc8:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0202bca:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0202bcc:	613c                	ld	a5,64(a0)
ffffffffc0202bce:	83b1                	srli	a5,a5,0xc
ffffffffc0202bd0:	0785                	addi	a5,a5,1
ffffffffc0202bd2:	07a2                	slli	a5,a5,0x8
ffffffffc0202bd4:	00fc3023          	sd	a5,0(s8) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
                    free_page(page);
ffffffffc0202bd8:	f9dfd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0202bdc:	01893503          	ld	a0,24(s2)
ffffffffc0202be0:	85a6                	mv	a1,s1
ffffffffc0202be2:	e9ffe0ef          	jal	ra,ffffffffc0201a80 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0202be6:	048a0d63          	beq	s4,s0,ffffffffc0202c40 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0202bea:	0009b783          	ld	a5,0(s3)
ffffffffc0202bee:	8656                	mv	a2,s5
ffffffffc0202bf0:	002c                	addi	a1,sp,8
ffffffffc0202bf2:	7b9c                	ld	a5,48(a5)
ffffffffc0202bf4:	854a                	mv	a0,s2
ffffffffc0202bf6:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0202bf8:	e12d                	bnez	a0,ffffffffc0202c5a <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0202bfa:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202bfc:	01893503          	ld	a0,24(s2)
ffffffffc0202c00:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0202c02:	63a4                	ld	s1,64(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202c04:	85a6                	mv	a1,s1
ffffffffc0202c06:	ff5fd0ef          	jal	ra,ffffffffc0200bfa <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0202c0a:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0202c0c:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0202c0e:	8b85                	andi	a5,a5,1
ffffffffc0202c10:	cfb9                	beqz	a5,ffffffffc0202c6e <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0202c12:	65a2                	ld	a1,8(sp)
ffffffffc0202c14:	61bc                	ld	a5,64(a1)
ffffffffc0202c16:	83b1                	srli	a5,a5,0xc
ffffffffc0202c18:	00178513          	addi	a0,a5,1
ffffffffc0202c1c:	0522                	slli	a0,a0,0x8
ffffffffc0202c1e:	0ac010ef          	jal	ra,ffffffffc0203cca <swapfs_write>
ffffffffc0202c22:	d949                	beqz	a0,ffffffffc0202bb4 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0202c24:	855e                	mv	a0,s7
ffffffffc0202c26:	c98fd0ef          	jal	ra,ffffffffc02000be <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0202c2a:	0009b783          	ld	a5,0(s3)
ffffffffc0202c2e:	6622                	ld	a2,8(sp)
ffffffffc0202c30:	4681                	li	a3,0
ffffffffc0202c32:	739c                	ld	a5,32(a5)
ffffffffc0202c34:	85a6                	mv	a1,s1
ffffffffc0202c36:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0202c38:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0202c3a:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0202c3c:	fa8a17e3          	bne	s4,s0,ffffffffc0202bea <swap_out+0x70>
}
ffffffffc0202c40:	8522                	mv	a0,s0
ffffffffc0202c42:	60e6                	ld	ra,88(sp)
ffffffffc0202c44:	6446                	ld	s0,80(sp)
ffffffffc0202c46:	64a6                	ld	s1,72(sp)
ffffffffc0202c48:	6906                	ld	s2,64(sp)
ffffffffc0202c4a:	79e2                	ld	s3,56(sp)
ffffffffc0202c4c:	7a42                	ld	s4,48(sp)
ffffffffc0202c4e:	7aa2                	ld	s5,40(sp)
ffffffffc0202c50:	7b02                	ld	s6,32(sp)
ffffffffc0202c52:	6be2                	ld	s7,24(sp)
ffffffffc0202c54:	6c42                	ld	s8,16(sp)
ffffffffc0202c56:	6125                	addi	sp,sp,96
ffffffffc0202c58:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0202c5a:	85a2                	mv	a1,s0
ffffffffc0202c5c:	00003517          	auipc	a0,0x3
ffffffffc0202c60:	d0450513          	addi	a0,a0,-764 # ffffffffc0205960 <commands+0x1528>
ffffffffc0202c64:	c5afd0ef          	jal	ra,ffffffffc02000be <cprintf>
                  break;
ffffffffc0202c68:	bfe1                	j	ffffffffc0202c40 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0202c6a:	4401                	li	s0,0
ffffffffc0202c6c:	bfd1                	j	ffffffffc0202c40 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0202c6e:	00003697          	auipc	a3,0x3
ffffffffc0202c72:	d2268693          	addi	a3,a3,-734 # ffffffffc0205990 <commands+0x1558>
ffffffffc0202c76:	00002617          	auipc	a2,0x2
ffffffffc0202c7a:	1b260613          	addi	a2,a2,434 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202c7e:	06500593          	li	a1,101
ffffffffc0202c82:	00003517          	auipc	a0,0x3
ffffffffc0202c86:	a4650513          	addi	a0,a0,-1466 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202c8a:	c7cfd0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0202c8e <swap_in>:
{
ffffffffc0202c8e:	7179                	addi	sp,sp,-48
ffffffffc0202c90:	e84a                	sd	s2,16(sp)
ffffffffc0202c92:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0202c94:	4505                	li	a0,1
{
ffffffffc0202c96:	ec26                	sd	s1,24(sp)
ffffffffc0202c98:	e44e                	sd	s3,8(sp)
ffffffffc0202c9a:	f406                	sd	ra,40(sp)
ffffffffc0202c9c:	f022                	sd	s0,32(sp)
ffffffffc0202c9e:	84ae                	mv	s1,a1
ffffffffc0202ca0:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0202ca2:	e4bfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
     assert(result!=NULL);
ffffffffc0202ca6:	c129                	beqz	a0,ffffffffc0202ce8 <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0202ca8:	842a                	mv	s0,a0
ffffffffc0202caa:	01893503          	ld	a0,24(s2)
ffffffffc0202cae:	4601                	li	a2,0
ffffffffc0202cb0:	85a6                	mv	a1,s1
ffffffffc0202cb2:	f49fd0ef          	jal	ra,ffffffffc0200bfa <get_pte>
ffffffffc0202cb6:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0202cb8:	6108                	ld	a0,0(a0)
ffffffffc0202cba:	85a2                	mv	a1,s0
ffffffffc0202cbc:	769000ef          	jal	ra,ffffffffc0203c24 <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0202cc0:	00093583          	ld	a1,0(s2)
ffffffffc0202cc4:	8626                	mv	a2,s1
ffffffffc0202cc6:	00003517          	auipc	a0,0x3
ffffffffc0202cca:	9a250513          	addi	a0,a0,-1630 # ffffffffc0205668 <commands+0x1230>
ffffffffc0202cce:	81a1                	srli	a1,a1,0x8
ffffffffc0202cd0:	beefd0ef          	jal	ra,ffffffffc02000be <cprintf>
}
ffffffffc0202cd4:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0202cd6:	0089b023          	sd	s0,0(s3)
}
ffffffffc0202cda:	7402                	ld	s0,32(sp)
ffffffffc0202cdc:	64e2                	ld	s1,24(sp)
ffffffffc0202cde:	6942                	ld	s2,16(sp)
ffffffffc0202ce0:	69a2                	ld	s3,8(sp)
ffffffffc0202ce2:	4501                	li	a0,0
ffffffffc0202ce4:	6145                	addi	sp,sp,48
ffffffffc0202ce6:	8082                	ret
     assert(result!=NULL);
ffffffffc0202ce8:	00003697          	auipc	a3,0x3
ffffffffc0202cec:	97068693          	addi	a3,a3,-1680 # ffffffffc0205658 <commands+0x1220>
ffffffffc0202cf0:	00002617          	auipc	a2,0x2
ffffffffc0202cf4:	13860613          	addi	a2,a2,312 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0202cf8:	07b00593          	li	a1,123
ffffffffc0202cfc:	00003517          	auipc	a0,0x3
ffffffffc0202d00:	9cc50513          	addi	a0,a0,-1588 # ffffffffc02056c8 <commands+0x1290>
ffffffffc0202d04:	c02fd0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0202d08 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0202d08:	0000f797          	auipc	a5,0xf
ffffffffc0202d0c:	87878793          	addi	a5,a5,-1928 # ffffffffc0211580 <free_area>
ffffffffc0202d10:	e79c                	sd	a5,8(a5)
ffffffffc0202d12:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0202d14:	0007a823          	sw	zero,16(a5)
}
ffffffffc0202d18:	8082                	ret

ffffffffc0202d1a <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0202d1a:	0000f517          	auipc	a0,0xf
ffffffffc0202d1e:	87656503          	lwu	a0,-1930(a0) # ffffffffc0211590 <free_area+0x10>
ffffffffc0202d22:	8082                	ret

ffffffffc0202d24 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0202d24:	715d                	addi	sp,sp,-80
ffffffffc0202d26:	f84a                	sd	s2,48(sp)
    return listelm->next;
ffffffffc0202d28:	0000f917          	auipc	s2,0xf
ffffffffc0202d2c:	85890913          	addi	s2,s2,-1960 # ffffffffc0211580 <free_area>
ffffffffc0202d30:	00893783          	ld	a5,8(s2)
ffffffffc0202d34:	e486                	sd	ra,72(sp)
ffffffffc0202d36:	e0a2                	sd	s0,64(sp)
ffffffffc0202d38:	fc26                	sd	s1,56(sp)
ffffffffc0202d3a:	f44e                	sd	s3,40(sp)
ffffffffc0202d3c:	f052                	sd	s4,32(sp)
ffffffffc0202d3e:	ec56                	sd	s5,24(sp)
ffffffffc0202d40:	e85a                	sd	s6,16(sp)
ffffffffc0202d42:	e45e                	sd	s7,8(sp)
ffffffffc0202d44:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202d46:	31278f63          	beq	a5,s2,ffffffffc0203064 <default_check+0x340>
ffffffffc0202d4a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202d4e:	8305                	srli	a4,a4,0x1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0202d50:	8b05                	andi	a4,a4,1
ffffffffc0202d52:	30070d63          	beqz	a4,ffffffffc020306c <default_check+0x348>
    int count = 0, total = 0;
ffffffffc0202d56:	4401                	li	s0,0
ffffffffc0202d58:	4481                	li	s1,0
ffffffffc0202d5a:	a031                	j	ffffffffc0202d66 <default_check+0x42>
ffffffffc0202d5c:	fe87b703          	ld	a4,-24(a5)
        assert(PageProperty(p));
ffffffffc0202d60:	8b09                	andi	a4,a4,2
ffffffffc0202d62:	30070563          	beqz	a4,ffffffffc020306c <default_check+0x348>
        count ++, total += p->property;
ffffffffc0202d66:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202d6a:	679c                	ld	a5,8(a5)
ffffffffc0202d6c:	2485                	addiw	s1,s1,1
ffffffffc0202d6e:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202d70:	ff2796e3          	bne	a5,s2,ffffffffc0202d5c <default_check+0x38>
ffffffffc0202d74:	89a2                	mv	s3,s0
    }
    assert(total == nr_free_pages());
ffffffffc0202d76:	e45fd0ef          	jal	ra,ffffffffc0200bba <nr_free_pages>
ffffffffc0202d7a:	75351963          	bne	a0,s3,ffffffffc02034cc <default_check+0x7a8>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0202d7e:	4505                	li	a0,1
ffffffffc0202d80:	d6dfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202d84:	8a2a                	mv	s4,a0
ffffffffc0202d86:	48050363          	beqz	a0,ffffffffc020320c <default_check+0x4e8>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202d8a:	4505                	li	a0,1
ffffffffc0202d8c:	d61fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202d90:	89aa                	mv	s3,a0
ffffffffc0202d92:	74050d63          	beqz	a0,ffffffffc02034ec <default_check+0x7c8>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202d96:	4505                	li	a0,1
ffffffffc0202d98:	d55fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202d9c:	8aaa                	mv	s5,a0
ffffffffc0202d9e:	4e050763          	beqz	a0,ffffffffc020328c <default_check+0x568>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0202da2:	2f3a0563          	beq	s4,s3,ffffffffc020308c <default_check+0x368>
ffffffffc0202da6:	2eaa0363          	beq	s4,a0,ffffffffc020308c <default_check+0x368>
ffffffffc0202daa:	2ea98163          	beq	s3,a0,ffffffffc020308c <default_check+0x368>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0202dae:	000a2783          	lw	a5,0(s4)
ffffffffc0202db2:	2e079d63          	bnez	a5,ffffffffc02030ac <default_check+0x388>
ffffffffc0202db6:	0009a783          	lw	a5,0(s3)
ffffffffc0202dba:	2e079963          	bnez	a5,ffffffffc02030ac <default_check+0x388>
ffffffffc0202dbe:	411c                	lw	a5,0(a0)
ffffffffc0202dc0:	2e079663          	bnez	a5,ffffffffc02030ac <default_check+0x388>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202dc4:	0000e797          	auipc	a5,0xe
ffffffffc0202dc8:	6d478793          	addi	a5,a5,1748 # ffffffffc0211498 <pages>
ffffffffc0202dcc:	639c                	ld	a5,0(a5)
ffffffffc0202dce:	00002717          	auipc	a4,0x2
ffffffffc0202dd2:	ea270713          	addi	a4,a4,-350 # ffffffffc0204c70 <commands+0x838>
ffffffffc0202dd6:	630c                	ld	a1,0(a4)
ffffffffc0202dd8:	40fa0733          	sub	a4,s4,a5
ffffffffc0202ddc:	870d                	srai	a4,a4,0x3
ffffffffc0202dde:	02b70733          	mul	a4,a4,a1
ffffffffc0202de2:	00003697          	auipc	a3,0x3
ffffffffc0202de6:	31e68693          	addi	a3,a3,798 # ffffffffc0206100 <nbase>
ffffffffc0202dea:	6290                	ld	a2,0(a3)
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0202dec:	0000e697          	auipc	a3,0xe
ffffffffc0202df0:	66c68693          	addi	a3,a3,1644 # ffffffffc0211458 <npage>
ffffffffc0202df4:	6294                	ld	a3,0(a3)
ffffffffc0202df6:	06b2                	slli	a3,a3,0xc
ffffffffc0202df8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202dfa:	0732                	slli	a4,a4,0xc
ffffffffc0202dfc:	2cd77863          	bleu	a3,a4,ffffffffc02030cc <default_check+0x3a8>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202e00:	40f98733          	sub	a4,s3,a5
ffffffffc0202e04:	870d                	srai	a4,a4,0x3
ffffffffc0202e06:	02b70733          	mul	a4,a4,a1
ffffffffc0202e0a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e0c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0202e0e:	4ed77f63          	bleu	a3,a4,ffffffffc020330c <default_check+0x5e8>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0202e12:	40f507b3          	sub	a5,a0,a5
ffffffffc0202e16:	878d                	srai	a5,a5,0x3
ffffffffc0202e18:	02b787b3          	mul	a5,a5,a1
ffffffffc0202e1c:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202e1e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0202e20:	34d7f663          	bleu	a3,a5,ffffffffc020316c <default_check+0x448>
    assert(alloc_page() == NULL);
ffffffffc0202e24:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0202e26:	00093c03          	ld	s8,0(s2)
ffffffffc0202e2a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0202e2e:	01092b03          	lw	s6,16(s2)
    elm->prev = elm->next = elm;
ffffffffc0202e32:	0000e797          	auipc	a5,0xe
ffffffffc0202e36:	7527bb23          	sd	s2,1878(a5) # ffffffffc0211588 <free_area+0x8>
ffffffffc0202e3a:	0000e797          	auipc	a5,0xe
ffffffffc0202e3e:	7527b323          	sd	s2,1862(a5) # ffffffffc0211580 <free_area>
    nr_free = 0;
ffffffffc0202e42:	0000e797          	auipc	a5,0xe
ffffffffc0202e46:	7407a723          	sw	zero,1870(a5) # ffffffffc0211590 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0202e4a:	ca3fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202e4e:	2e051f63          	bnez	a0,ffffffffc020314c <default_check+0x428>
    free_page(p0);
ffffffffc0202e52:	4585                	li	a1,1
ffffffffc0202e54:	8552                	mv	a0,s4
ffffffffc0202e56:	d1ffd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    free_page(p1);
ffffffffc0202e5a:	4585                	li	a1,1
ffffffffc0202e5c:	854e                	mv	a0,s3
ffffffffc0202e5e:	d17fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    free_page(p2);
ffffffffc0202e62:	4585                	li	a1,1
ffffffffc0202e64:	8556                	mv	a0,s5
ffffffffc0202e66:	d0ffd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    assert(nr_free == 3);
ffffffffc0202e6a:	01092703          	lw	a4,16(s2)
ffffffffc0202e6e:	478d                	li	a5,3
ffffffffc0202e70:	2af71e63          	bne	a4,a5,ffffffffc020312c <default_check+0x408>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0202e74:	4505                	li	a0,1
ffffffffc0202e76:	c77fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202e7a:	89aa                	mv	s3,a0
ffffffffc0202e7c:	28050863          	beqz	a0,ffffffffc020310c <default_check+0x3e8>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202e80:	4505                	li	a0,1
ffffffffc0202e82:	c6bfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202e86:	8aaa                	mv	s5,a0
ffffffffc0202e88:	3e050263          	beqz	a0,ffffffffc020326c <default_check+0x548>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202e8c:	4505                	li	a0,1
ffffffffc0202e8e:	c5ffd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202e92:	8a2a                	mv	s4,a0
ffffffffc0202e94:	3a050c63          	beqz	a0,ffffffffc020324c <default_check+0x528>
    assert(alloc_page() == NULL);
ffffffffc0202e98:	4505                	li	a0,1
ffffffffc0202e9a:	c53fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202e9e:	38051763          	bnez	a0,ffffffffc020322c <default_check+0x508>
    free_page(p0);
ffffffffc0202ea2:	4585                	li	a1,1
ffffffffc0202ea4:	854e                	mv	a0,s3
ffffffffc0202ea6:	ccffd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0202eaa:	00893783          	ld	a5,8(s2)
ffffffffc0202eae:	23278f63          	beq	a5,s2,ffffffffc02030ec <default_check+0x3c8>
    assert((p = alloc_page()) == p0);
ffffffffc0202eb2:	4505                	li	a0,1
ffffffffc0202eb4:	c39fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202eb8:	32a99a63          	bne	s3,a0,ffffffffc02031ec <default_check+0x4c8>
    assert(alloc_page() == NULL);
ffffffffc0202ebc:	4505                	li	a0,1
ffffffffc0202ebe:	c2ffd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202ec2:	30051563          	bnez	a0,ffffffffc02031cc <default_check+0x4a8>
    assert(nr_free == 0);
ffffffffc0202ec6:	01092783          	lw	a5,16(s2)
ffffffffc0202eca:	2e079163          	bnez	a5,ffffffffc02031ac <default_check+0x488>
    free_page(p);
ffffffffc0202ece:	854e                	mv	a0,s3
ffffffffc0202ed0:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0202ed2:	0000e797          	auipc	a5,0xe
ffffffffc0202ed6:	6b87b723          	sd	s8,1710(a5) # ffffffffc0211580 <free_area>
ffffffffc0202eda:	0000e797          	auipc	a5,0xe
ffffffffc0202ede:	6b77b723          	sd	s7,1710(a5) # ffffffffc0211588 <free_area+0x8>
    nr_free = nr_free_store;
ffffffffc0202ee2:	0000e797          	auipc	a5,0xe
ffffffffc0202ee6:	6b67a723          	sw	s6,1710(a5) # ffffffffc0211590 <free_area+0x10>
    free_page(p);
ffffffffc0202eea:	c8bfd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    free_page(p1);
ffffffffc0202eee:	4585                	li	a1,1
ffffffffc0202ef0:	8556                	mv	a0,s5
ffffffffc0202ef2:	c83fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    free_page(p2);
ffffffffc0202ef6:	4585                	li	a1,1
ffffffffc0202ef8:	8552                	mv	a0,s4
ffffffffc0202efa:	c7bfd0ef          	jal	ra,ffffffffc0200b74 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0202efe:	4515                	li	a0,5
ffffffffc0202f00:	bedfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202f04:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0202f06:	28050363          	beqz	a0,ffffffffc020318c <default_check+0x468>
ffffffffc0202f0a:	651c                	ld	a5,8(a0)
ffffffffc0202f0c:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0202f0e:	8b85                	andi	a5,a5,1
ffffffffc0202f10:	54079e63          	bnez	a5,ffffffffc020346c <default_check+0x748>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0202f14:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0202f16:	00093b03          	ld	s6,0(s2)
ffffffffc0202f1a:	00893a83          	ld	s5,8(s2)
ffffffffc0202f1e:	0000e797          	auipc	a5,0xe
ffffffffc0202f22:	6727b123          	sd	s2,1634(a5) # ffffffffc0211580 <free_area>
ffffffffc0202f26:	0000e797          	auipc	a5,0xe
ffffffffc0202f2a:	6727b123          	sd	s2,1634(a5) # ffffffffc0211588 <free_area+0x8>
    assert(alloc_page() == NULL);
ffffffffc0202f2e:	bbffd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202f32:	50051d63          	bnez	a0,ffffffffc020344c <default_check+0x728>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0202f36:	09098a13          	addi	s4,s3,144
ffffffffc0202f3a:	8552                	mv	a0,s4
ffffffffc0202f3c:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0202f3e:	01092b83          	lw	s7,16(s2)
    nr_free = 0;
ffffffffc0202f42:	0000e797          	auipc	a5,0xe
ffffffffc0202f46:	6407a723          	sw	zero,1614(a5) # ffffffffc0211590 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0202f4a:	c2bfd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0202f4e:	4511                	li	a0,4
ffffffffc0202f50:	b9dfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202f54:	4c051c63          	bnez	a0,ffffffffc020342c <default_check+0x708>
ffffffffc0202f58:	0989b783          	ld	a5,152(s3)
ffffffffc0202f5c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0202f5e:	8b85                	andi	a5,a5,1
ffffffffc0202f60:	4a078663          	beqz	a5,ffffffffc020340c <default_check+0x6e8>
ffffffffc0202f64:	0a89a703          	lw	a4,168(s3)
ffffffffc0202f68:	478d                	li	a5,3
ffffffffc0202f6a:	4af71163          	bne	a4,a5,ffffffffc020340c <default_check+0x6e8>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0202f6e:	450d                	li	a0,3
ffffffffc0202f70:	b7dfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202f74:	8c2a                	mv	s8,a0
ffffffffc0202f76:	46050b63          	beqz	a0,ffffffffc02033ec <default_check+0x6c8>
    assert(alloc_page() == NULL);
ffffffffc0202f7a:	4505                	li	a0,1
ffffffffc0202f7c:	b71fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202f80:	44051663          	bnez	a0,ffffffffc02033cc <default_check+0x6a8>
    assert(p0 + 2 == p1);
ffffffffc0202f84:	438a1463          	bne	s4,s8,ffffffffc02033ac <default_check+0x688>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0202f88:	4585                	li	a1,1
ffffffffc0202f8a:	854e                	mv	a0,s3
ffffffffc0202f8c:	be9fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    free_pages(p1, 3);
ffffffffc0202f90:	458d                	li	a1,3
ffffffffc0202f92:	8552                	mv	a0,s4
ffffffffc0202f94:	be1fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
ffffffffc0202f98:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0202f9c:	04898c13          	addi	s8,s3,72
ffffffffc0202fa0:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0202fa2:	8b85                	andi	a5,a5,1
ffffffffc0202fa4:	3e078463          	beqz	a5,ffffffffc020338c <default_check+0x668>
ffffffffc0202fa8:	0189a703          	lw	a4,24(s3)
ffffffffc0202fac:	4785                	li	a5,1
ffffffffc0202fae:	3cf71f63          	bne	a4,a5,ffffffffc020338c <default_check+0x668>
ffffffffc0202fb2:	008a3783          	ld	a5,8(s4)
ffffffffc0202fb6:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0202fb8:	8b85                	andi	a5,a5,1
ffffffffc0202fba:	3a078963          	beqz	a5,ffffffffc020336c <default_check+0x648>
ffffffffc0202fbe:	018a2703          	lw	a4,24(s4)
ffffffffc0202fc2:	478d                	li	a5,3
ffffffffc0202fc4:	3af71463          	bne	a4,a5,ffffffffc020336c <default_check+0x648>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0202fc8:	4505                	li	a0,1
ffffffffc0202fca:	b23fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202fce:	36a99f63          	bne	s3,a0,ffffffffc020334c <default_check+0x628>
    free_page(p0);
ffffffffc0202fd2:	4585                	li	a1,1
ffffffffc0202fd4:	ba1fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0202fd8:	4509                	li	a0,2
ffffffffc0202fda:	b13fd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202fde:	34aa1763          	bne	s4,a0,ffffffffc020332c <default_check+0x608>

    free_pages(p0, 2);
ffffffffc0202fe2:	4589                	li	a1,2
ffffffffc0202fe4:	b91fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    free_page(p2);
ffffffffc0202fe8:	4585                	li	a1,1
ffffffffc0202fea:	8562                	mv	a0,s8
ffffffffc0202fec:	b89fd0ef          	jal	ra,ffffffffc0200b74 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0202ff0:	4515                	li	a0,5
ffffffffc0202ff2:	afbfd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0202ff6:	89aa                	mv	s3,a0
ffffffffc0202ff8:	48050a63          	beqz	a0,ffffffffc020348c <default_check+0x768>
    assert(alloc_page() == NULL);
ffffffffc0202ffc:	4505                	li	a0,1
ffffffffc0202ffe:	aeffd0ef          	jal	ra,ffffffffc0200aec <alloc_pages>
ffffffffc0203002:	2e051563          	bnez	a0,ffffffffc02032ec <default_check+0x5c8>

    assert(nr_free == 0);
ffffffffc0203006:	01092783          	lw	a5,16(s2)
ffffffffc020300a:	2c079163          	bnez	a5,ffffffffc02032cc <default_check+0x5a8>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc020300e:	4595                	li	a1,5
ffffffffc0203010:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0203012:	0000e797          	auipc	a5,0xe
ffffffffc0203016:	5777af23          	sw	s7,1406(a5) # ffffffffc0211590 <free_area+0x10>
    free_list = free_list_store;
ffffffffc020301a:	0000e797          	auipc	a5,0xe
ffffffffc020301e:	5767b323          	sd	s6,1382(a5) # ffffffffc0211580 <free_area>
ffffffffc0203022:	0000e797          	auipc	a5,0xe
ffffffffc0203026:	5757b323          	sd	s5,1382(a5) # ffffffffc0211588 <free_area+0x8>
    free_pages(p0, 5);
ffffffffc020302a:	b4bfd0ef          	jal	ra,ffffffffc0200b74 <free_pages>
    return listelm->next;
ffffffffc020302e:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203032:	01278963          	beq	a5,s2,ffffffffc0203044 <default_check+0x320>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0203036:	ff87a703          	lw	a4,-8(a5)
ffffffffc020303a:	679c                	ld	a5,8(a5)
ffffffffc020303c:	34fd                	addiw	s1,s1,-1
ffffffffc020303e:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203040:	ff279be3          	bne	a5,s2,ffffffffc0203036 <default_check+0x312>
    }
    assert(count == 0);
ffffffffc0203044:	26049463          	bnez	s1,ffffffffc02032ac <default_check+0x588>
    assert(total == 0);
ffffffffc0203048:	46041263          	bnez	s0,ffffffffc02034ac <default_check+0x788>
}
ffffffffc020304c:	60a6                	ld	ra,72(sp)
ffffffffc020304e:	6406                	ld	s0,64(sp)
ffffffffc0203050:	74e2                	ld	s1,56(sp)
ffffffffc0203052:	7942                	ld	s2,48(sp)
ffffffffc0203054:	79a2                	ld	s3,40(sp)
ffffffffc0203056:	7a02                	ld	s4,32(sp)
ffffffffc0203058:	6ae2                	ld	s5,24(sp)
ffffffffc020305a:	6b42                	ld	s6,16(sp)
ffffffffc020305c:	6ba2                	ld	s7,8(sp)
ffffffffc020305e:	6c02                	ld	s8,0(sp)
ffffffffc0203060:	6161                	addi	sp,sp,80
ffffffffc0203062:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203064:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0203066:	4401                	li	s0,0
ffffffffc0203068:	4481                	li	s1,0
ffffffffc020306a:	b331                	j	ffffffffc0202d76 <default_check+0x52>
        assert(PageProperty(p));
ffffffffc020306c:	00002697          	auipc	a3,0x2
ffffffffc0203070:	68468693          	addi	a3,a3,1668 # ffffffffc02056f0 <commands+0x12b8>
ffffffffc0203074:	00002617          	auipc	a2,0x2
ffffffffc0203078:	db460613          	addi	a2,a2,-588 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020307c:	0f000593          	li	a1,240
ffffffffc0203080:	00003517          	auipc	a0,0x3
ffffffffc0203084:	98050513          	addi	a0,a0,-1664 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203088:	87efd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020308c:	00003697          	auipc	a3,0x3
ffffffffc0203090:	9ec68693          	addi	a3,a3,-1556 # ffffffffc0205a78 <commands+0x1640>
ffffffffc0203094:	00002617          	auipc	a2,0x2
ffffffffc0203098:	d9460613          	addi	a2,a2,-620 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020309c:	0bd00593          	li	a1,189
ffffffffc02030a0:	00003517          	auipc	a0,0x3
ffffffffc02030a4:	96050513          	addi	a0,a0,-1696 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02030a8:	85efd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02030ac:	00003697          	auipc	a3,0x3
ffffffffc02030b0:	9f468693          	addi	a3,a3,-1548 # ffffffffc0205aa0 <commands+0x1668>
ffffffffc02030b4:	00002617          	auipc	a2,0x2
ffffffffc02030b8:	d7460613          	addi	a2,a2,-652 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02030bc:	0be00593          	li	a1,190
ffffffffc02030c0:	00003517          	auipc	a0,0x3
ffffffffc02030c4:	94050513          	addi	a0,a0,-1728 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02030c8:	83efd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02030cc:	00003697          	auipc	a3,0x3
ffffffffc02030d0:	a1468693          	addi	a3,a3,-1516 # ffffffffc0205ae0 <commands+0x16a8>
ffffffffc02030d4:	00002617          	auipc	a2,0x2
ffffffffc02030d8:	d5460613          	addi	a2,a2,-684 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02030dc:	0c000593          	li	a1,192
ffffffffc02030e0:	00003517          	auipc	a0,0x3
ffffffffc02030e4:	92050513          	addi	a0,a0,-1760 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02030e8:	81efd0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02030ec:	00003697          	auipc	a3,0x3
ffffffffc02030f0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc0205b68 <commands+0x1730>
ffffffffc02030f4:	00002617          	auipc	a2,0x2
ffffffffc02030f8:	d3460613          	addi	a2,a2,-716 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02030fc:	0d900593          	li	a1,217
ffffffffc0203100:	00003517          	auipc	a0,0x3
ffffffffc0203104:	90050513          	addi	a0,a0,-1792 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203108:	ffffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020310c:	00003697          	auipc	a3,0x3
ffffffffc0203110:	90c68693          	addi	a3,a3,-1780 # ffffffffc0205a18 <commands+0x15e0>
ffffffffc0203114:	00002617          	auipc	a2,0x2
ffffffffc0203118:	d1460613          	addi	a2,a2,-748 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020311c:	0d200593          	li	a1,210
ffffffffc0203120:	00003517          	auipc	a0,0x3
ffffffffc0203124:	8e050513          	addi	a0,a0,-1824 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203128:	fdffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free == 3);
ffffffffc020312c:	00003697          	auipc	a3,0x3
ffffffffc0203130:	a2c68693          	addi	a3,a3,-1492 # ffffffffc0205b58 <commands+0x1720>
ffffffffc0203134:	00002617          	auipc	a2,0x2
ffffffffc0203138:	cf460613          	addi	a2,a2,-780 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020313c:	0d000593          	li	a1,208
ffffffffc0203140:	00003517          	auipc	a0,0x3
ffffffffc0203144:	8c050513          	addi	a0,a0,-1856 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203148:	fbffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020314c:	00003697          	auipc	a3,0x3
ffffffffc0203150:	9f468693          	addi	a3,a3,-1548 # ffffffffc0205b40 <commands+0x1708>
ffffffffc0203154:	00002617          	auipc	a2,0x2
ffffffffc0203158:	cd460613          	addi	a2,a2,-812 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020315c:	0cb00593          	li	a1,203
ffffffffc0203160:	00003517          	auipc	a0,0x3
ffffffffc0203164:	8a050513          	addi	a0,a0,-1888 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203168:	f9ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020316c:	00003697          	auipc	a3,0x3
ffffffffc0203170:	9b468693          	addi	a3,a3,-1612 # ffffffffc0205b20 <commands+0x16e8>
ffffffffc0203174:	00002617          	auipc	a2,0x2
ffffffffc0203178:	cb460613          	addi	a2,a2,-844 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020317c:	0c200593          	li	a1,194
ffffffffc0203180:	00003517          	auipc	a0,0x3
ffffffffc0203184:	88050513          	addi	a0,a0,-1920 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203188:	f7ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(p0 != NULL);
ffffffffc020318c:	00003697          	auipc	a3,0x3
ffffffffc0203190:	a1468693          	addi	a3,a3,-1516 # ffffffffc0205ba0 <commands+0x1768>
ffffffffc0203194:	00002617          	auipc	a2,0x2
ffffffffc0203198:	c9460613          	addi	a2,a2,-876 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020319c:	0f800593          	li	a1,248
ffffffffc02031a0:	00003517          	auipc	a0,0x3
ffffffffc02031a4:	86050513          	addi	a0,a0,-1952 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02031a8:	f5ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free == 0);
ffffffffc02031ac:	00002697          	auipc	a3,0x2
ffffffffc02031b0:	6f468693          	addi	a3,a3,1780 # ffffffffc02058a0 <commands+0x1468>
ffffffffc02031b4:	00002617          	auipc	a2,0x2
ffffffffc02031b8:	c7460613          	addi	a2,a2,-908 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02031bc:	0df00593          	li	a1,223
ffffffffc02031c0:	00003517          	auipc	a0,0x3
ffffffffc02031c4:	84050513          	addi	a0,a0,-1984 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02031c8:	f3ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02031cc:	00003697          	auipc	a3,0x3
ffffffffc02031d0:	97468693          	addi	a3,a3,-1676 # ffffffffc0205b40 <commands+0x1708>
ffffffffc02031d4:	00002617          	auipc	a2,0x2
ffffffffc02031d8:	c5460613          	addi	a2,a2,-940 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02031dc:	0dd00593          	li	a1,221
ffffffffc02031e0:	00003517          	auipc	a0,0x3
ffffffffc02031e4:	82050513          	addi	a0,a0,-2016 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02031e8:	f1ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02031ec:	00003697          	auipc	a3,0x3
ffffffffc02031f0:	99468693          	addi	a3,a3,-1644 # ffffffffc0205b80 <commands+0x1748>
ffffffffc02031f4:	00002617          	auipc	a2,0x2
ffffffffc02031f8:	c3460613          	addi	a2,a2,-972 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02031fc:	0dc00593          	li	a1,220
ffffffffc0203200:	00003517          	auipc	a0,0x3
ffffffffc0203204:	80050513          	addi	a0,a0,-2048 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203208:	efffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020320c:	00003697          	auipc	a3,0x3
ffffffffc0203210:	80c68693          	addi	a3,a3,-2036 # ffffffffc0205a18 <commands+0x15e0>
ffffffffc0203214:	00002617          	auipc	a2,0x2
ffffffffc0203218:	c1460613          	addi	a2,a2,-1004 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020321c:	0b900593          	li	a1,185
ffffffffc0203220:	00002517          	auipc	a0,0x2
ffffffffc0203224:	7e050513          	addi	a0,a0,2016 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203228:	edffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020322c:	00003697          	auipc	a3,0x3
ffffffffc0203230:	91468693          	addi	a3,a3,-1772 # ffffffffc0205b40 <commands+0x1708>
ffffffffc0203234:	00002617          	auipc	a2,0x2
ffffffffc0203238:	bf460613          	addi	a2,a2,-1036 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020323c:	0d600593          	li	a1,214
ffffffffc0203240:	00002517          	auipc	a0,0x2
ffffffffc0203244:	7c050513          	addi	a0,a0,1984 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203248:	ebffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020324c:	00003697          	auipc	a3,0x3
ffffffffc0203250:	80c68693          	addi	a3,a3,-2036 # ffffffffc0205a58 <commands+0x1620>
ffffffffc0203254:	00002617          	auipc	a2,0x2
ffffffffc0203258:	bd460613          	addi	a2,a2,-1068 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020325c:	0d400593          	li	a1,212
ffffffffc0203260:	00002517          	auipc	a0,0x2
ffffffffc0203264:	7a050513          	addi	a0,a0,1952 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203268:	e9ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020326c:	00002697          	auipc	a3,0x2
ffffffffc0203270:	7cc68693          	addi	a3,a3,1996 # ffffffffc0205a38 <commands+0x1600>
ffffffffc0203274:	00002617          	auipc	a2,0x2
ffffffffc0203278:	bb460613          	addi	a2,a2,-1100 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020327c:	0d300593          	li	a1,211
ffffffffc0203280:	00002517          	auipc	a0,0x2
ffffffffc0203284:	78050513          	addi	a0,a0,1920 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203288:	e7ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020328c:	00002697          	auipc	a3,0x2
ffffffffc0203290:	7cc68693          	addi	a3,a3,1996 # ffffffffc0205a58 <commands+0x1620>
ffffffffc0203294:	00002617          	auipc	a2,0x2
ffffffffc0203298:	b9460613          	addi	a2,a2,-1132 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020329c:	0bb00593          	li	a1,187
ffffffffc02032a0:	00002517          	auipc	a0,0x2
ffffffffc02032a4:	76050513          	addi	a0,a0,1888 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02032a8:	e5ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(count == 0);
ffffffffc02032ac:	00003697          	auipc	a3,0x3
ffffffffc02032b0:	a4468693          	addi	a3,a3,-1468 # ffffffffc0205cf0 <commands+0x18b8>
ffffffffc02032b4:	00002617          	auipc	a2,0x2
ffffffffc02032b8:	b7460613          	addi	a2,a2,-1164 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02032bc:	12500593          	li	a1,293
ffffffffc02032c0:	00002517          	auipc	a0,0x2
ffffffffc02032c4:	74050513          	addi	a0,a0,1856 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02032c8:	e3ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(nr_free == 0);
ffffffffc02032cc:	00002697          	auipc	a3,0x2
ffffffffc02032d0:	5d468693          	addi	a3,a3,1492 # ffffffffc02058a0 <commands+0x1468>
ffffffffc02032d4:	00002617          	auipc	a2,0x2
ffffffffc02032d8:	b5460613          	addi	a2,a2,-1196 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02032dc:	11a00593          	li	a1,282
ffffffffc02032e0:	00002517          	auipc	a0,0x2
ffffffffc02032e4:	72050513          	addi	a0,a0,1824 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02032e8:	e1ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02032ec:	00003697          	auipc	a3,0x3
ffffffffc02032f0:	85468693          	addi	a3,a3,-1964 # ffffffffc0205b40 <commands+0x1708>
ffffffffc02032f4:	00002617          	auipc	a2,0x2
ffffffffc02032f8:	b3460613          	addi	a2,a2,-1228 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02032fc:	11800593          	li	a1,280
ffffffffc0203300:	00002517          	auipc	a0,0x2
ffffffffc0203304:	70050513          	addi	a0,a0,1792 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203308:	dfffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020330c:	00002697          	auipc	a3,0x2
ffffffffc0203310:	7f468693          	addi	a3,a3,2036 # ffffffffc0205b00 <commands+0x16c8>
ffffffffc0203314:	00002617          	auipc	a2,0x2
ffffffffc0203318:	b1460613          	addi	a2,a2,-1260 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020331c:	0c100593          	li	a1,193
ffffffffc0203320:	00002517          	auipc	a0,0x2
ffffffffc0203324:	6e050513          	addi	a0,a0,1760 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203328:	ddffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc020332c:	00003697          	auipc	a3,0x3
ffffffffc0203330:	98468693          	addi	a3,a3,-1660 # ffffffffc0205cb0 <commands+0x1878>
ffffffffc0203334:	00002617          	auipc	a2,0x2
ffffffffc0203338:	af460613          	addi	a2,a2,-1292 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020333c:	11200593          	li	a1,274
ffffffffc0203340:	00002517          	auipc	a0,0x2
ffffffffc0203344:	6c050513          	addi	a0,a0,1728 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203348:	dbffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020334c:	00003697          	auipc	a3,0x3
ffffffffc0203350:	94468693          	addi	a3,a3,-1724 # ffffffffc0205c90 <commands+0x1858>
ffffffffc0203354:	00002617          	auipc	a2,0x2
ffffffffc0203358:	ad460613          	addi	a2,a2,-1324 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020335c:	11000593          	li	a1,272
ffffffffc0203360:	00002517          	auipc	a0,0x2
ffffffffc0203364:	6a050513          	addi	a0,a0,1696 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203368:	d9ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020336c:	00003697          	auipc	a3,0x3
ffffffffc0203370:	8fc68693          	addi	a3,a3,-1796 # ffffffffc0205c68 <commands+0x1830>
ffffffffc0203374:	00002617          	auipc	a2,0x2
ffffffffc0203378:	ab460613          	addi	a2,a2,-1356 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020337c:	10e00593          	li	a1,270
ffffffffc0203380:	00002517          	auipc	a0,0x2
ffffffffc0203384:	68050513          	addi	a0,a0,1664 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203388:	d7ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020338c:	00003697          	auipc	a3,0x3
ffffffffc0203390:	8b468693          	addi	a3,a3,-1868 # ffffffffc0205c40 <commands+0x1808>
ffffffffc0203394:	00002617          	auipc	a2,0x2
ffffffffc0203398:	a9460613          	addi	a2,a2,-1388 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020339c:	10d00593          	li	a1,269
ffffffffc02033a0:	00002517          	auipc	a0,0x2
ffffffffc02033a4:	66050513          	addi	a0,a0,1632 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02033a8:	d5ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(p0 + 2 == p1);
ffffffffc02033ac:	00003697          	auipc	a3,0x3
ffffffffc02033b0:	88468693          	addi	a3,a3,-1916 # ffffffffc0205c30 <commands+0x17f8>
ffffffffc02033b4:	00002617          	auipc	a2,0x2
ffffffffc02033b8:	a7460613          	addi	a2,a2,-1420 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02033bc:	10800593          	li	a1,264
ffffffffc02033c0:	00002517          	auipc	a0,0x2
ffffffffc02033c4:	64050513          	addi	a0,a0,1600 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02033c8:	d3ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02033cc:	00002697          	auipc	a3,0x2
ffffffffc02033d0:	77468693          	addi	a3,a3,1908 # ffffffffc0205b40 <commands+0x1708>
ffffffffc02033d4:	00002617          	auipc	a2,0x2
ffffffffc02033d8:	a5460613          	addi	a2,a2,-1452 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02033dc:	10700593          	li	a1,263
ffffffffc02033e0:	00002517          	auipc	a0,0x2
ffffffffc02033e4:	62050513          	addi	a0,a0,1568 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02033e8:	d1ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02033ec:	00003697          	auipc	a3,0x3
ffffffffc02033f0:	82468693          	addi	a3,a3,-2012 # ffffffffc0205c10 <commands+0x17d8>
ffffffffc02033f4:	00002617          	auipc	a2,0x2
ffffffffc02033f8:	a3460613          	addi	a2,a2,-1484 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02033fc:	10600593          	li	a1,262
ffffffffc0203400:	00002517          	auipc	a0,0x2
ffffffffc0203404:	60050513          	addi	a0,a0,1536 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203408:	cfffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020340c:	00002697          	auipc	a3,0x2
ffffffffc0203410:	7d468693          	addi	a3,a3,2004 # ffffffffc0205be0 <commands+0x17a8>
ffffffffc0203414:	00002617          	auipc	a2,0x2
ffffffffc0203418:	a1460613          	addi	a2,a2,-1516 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020341c:	10500593          	li	a1,261
ffffffffc0203420:	00002517          	auipc	a0,0x2
ffffffffc0203424:	5e050513          	addi	a0,a0,1504 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203428:	cdffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020342c:	00002697          	auipc	a3,0x2
ffffffffc0203430:	79c68693          	addi	a3,a3,1948 # ffffffffc0205bc8 <commands+0x1790>
ffffffffc0203434:	00002617          	auipc	a2,0x2
ffffffffc0203438:	9f460613          	addi	a2,a2,-1548 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020343c:	10400593          	li	a1,260
ffffffffc0203440:	00002517          	auipc	a0,0x2
ffffffffc0203444:	5c050513          	addi	a0,a0,1472 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203448:	cbffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020344c:	00002697          	auipc	a3,0x2
ffffffffc0203450:	6f468693          	addi	a3,a3,1780 # ffffffffc0205b40 <commands+0x1708>
ffffffffc0203454:	00002617          	auipc	a2,0x2
ffffffffc0203458:	9d460613          	addi	a2,a2,-1580 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020345c:	0fe00593          	li	a1,254
ffffffffc0203460:	00002517          	auipc	a0,0x2
ffffffffc0203464:	5a050513          	addi	a0,a0,1440 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203468:	c9ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(!PageProperty(p0));
ffffffffc020346c:	00002697          	auipc	a3,0x2
ffffffffc0203470:	74468693          	addi	a3,a3,1860 # ffffffffc0205bb0 <commands+0x1778>
ffffffffc0203474:	00002617          	auipc	a2,0x2
ffffffffc0203478:	9b460613          	addi	a2,a2,-1612 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020347c:	0f900593          	li	a1,249
ffffffffc0203480:	00002517          	auipc	a0,0x2
ffffffffc0203484:	58050513          	addi	a0,a0,1408 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203488:	c7ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020348c:	00003697          	auipc	a3,0x3
ffffffffc0203490:	84468693          	addi	a3,a3,-1980 # ffffffffc0205cd0 <commands+0x1898>
ffffffffc0203494:	00002617          	auipc	a2,0x2
ffffffffc0203498:	99460613          	addi	a2,a2,-1644 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020349c:	11700593          	li	a1,279
ffffffffc02034a0:	00002517          	auipc	a0,0x2
ffffffffc02034a4:	56050513          	addi	a0,a0,1376 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02034a8:	c5ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(total == 0);
ffffffffc02034ac:	00003697          	auipc	a3,0x3
ffffffffc02034b0:	85468693          	addi	a3,a3,-1964 # ffffffffc0205d00 <commands+0x18c8>
ffffffffc02034b4:	00002617          	auipc	a2,0x2
ffffffffc02034b8:	97460613          	addi	a2,a2,-1676 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02034bc:	12600593          	li	a1,294
ffffffffc02034c0:	00002517          	auipc	a0,0x2
ffffffffc02034c4:	54050513          	addi	a0,a0,1344 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02034c8:	c3ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(total == nr_free_pages());
ffffffffc02034cc:	00002697          	auipc	a3,0x2
ffffffffc02034d0:	23468693          	addi	a3,a3,564 # ffffffffc0205700 <commands+0x12c8>
ffffffffc02034d4:	00002617          	auipc	a2,0x2
ffffffffc02034d8:	95460613          	addi	a2,a2,-1708 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02034dc:	0f300593          	li	a1,243
ffffffffc02034e0:	00002517          	auipc	a0,0x2
ffffffffc02034e4:	52050513          	addi	a0,a0,1312 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02034e8:	c1ffc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02034ec:	00002697          	auipc	a3,0x2
ffffffffc02034f0:	54c68693          	addi	a3,a3,1356 # ffffffffc0205a38 <commands+0x1600>
ffffffffc02034f4:	00002617          	auipc	a2,0x2
ffffffffc02034f8:	93460613          	addi	a2,a2,-1740 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02034fc:	0ba00593          	li	a1,186
ffffffffc0203500:	00002517          	auipc	a0,0x2
ffffffffc0203504:	50050513          	addi	a0,a0,1280 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203508:	bfffc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc020350c <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc020350c:	1141                	addi	sp,sp,-16
ffffffffc020350e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203510:	18058063          	beqz	a1,ffffffffc0203690 <default_free_pages+0x184>
    for (; p != base + n; p ++) {
ffffffffc0203514:	00359693          	slli	a3,a1,0x3
ffffffffc0203518:	96ae                	add	a3,a3,a1
ffffffffc020351a:	068e                	slli	a3,a3,0x3
ffffffffc020351c:	96aa                	add	a3,a3,a0
ffffffffc020351e:	02d50d63          	beq	a0,a3,ffffffffc0203558 <default_free_pages+0x4c>
ffffffffc0203522:	651c                	ld	a5,8(a0)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203524:	8b85                	andi	a5,a5,1
ffffffffc0203526:	14079563          	bnez	a5,ffffffffc0203670 <default_free_pages+0x164>
ffffffffc020352a:	651c                	ld	a5,8(a0)
ffffffffc020352c:	8385                	srli	a5,a5,0x1
ffffffffc020352e:	8b85                	andi	a5,a5,1
ffffffffc0203530:	14079063          	bnez	a5,ffffffffc0203670 <default_free_pages+0x164>
ffffffffc0203534:	87aa                	mv	a5,a0
ffffffffc0203536:	a809                	j	ffffffffc0203548 <default_free_pages+0x3c>
ffffffffc0203538:	6798                	ld	a4,8(a5)
ffffffffc020353a:	8b05                	andi	a4,a4,1
ffffffffc020353c:	12071a63          	bnez	a4,ffffffffc0203670 <default_free_pages+0x164>
ffffffffc0203540:	6798                	ld	a4,8(a5)
ffffffffc0203542:	8b09                	andi	a4,a4,2
ffffffffc0203544:	12071663          	bnez	a4,ffffffffc0203670 <default_free_pages+0x164>
        p->flags = 0;
ffffffffc0203548:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020354c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0203550:	04878793          	addi	a5,a5,72
ffffffffc0203554:	fed792e3          	bne	a5,a3,ffffffffc0203538 <default_free_pages+0x2c>
    base->property = n;
ffffffffc0203558:	2581                	sext.w	a1,a1
ffffffffc020355a:	cd0c                	sw	a1,24(a0)
    SetPageProperty(base);
ffffffffc020355c:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203560:	4789                	li	a5,2
ffffffffc0203562:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0203566:	0000e697          	auipc	a3,0xe
ffffffffc020356a:	01a68693          	addi	a3,a3,26 # ffffffffc0211580 <free_area>
ffffffffc020356e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0203570:	669c                	ld	a5,8(a3)
ffffffffc0203572:	9db9                	addw	a1,a1,a4
ffffffffc0203574:	0000e717          	auipc	a4,0xe
ffffffffc0203578:	00b72e23          	sw	a1,28(a4) # ffffffffc0211590 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc020357c:	08d78f63          	beq	a5,a3,ffffffffc020361a <default_free_pages+0x10e>
            struct Page* page = le2page(le, page_link);
ffffffffc0203580:	fe078713          	addi	a4,a5,-32
ffffffffc0203584:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0203586:	4801                	li	a6,0
ffffffffc0203588:	02050613          	addi	a2,a0,32
            if (base < page) {
ffffffffc020358c:	00e56a63          	bltu	a0,a4,ffffffffc02035a0 <default_free_pages+0x94>
    return listelm->next;
ffffffffc0203590:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0203592:	02d70563          	beq	a4,a3,ffffffffc02035bc <default_free_pages+0xb0>
        while ((le = list_next(le)) != &free_list) {
ffffffffc0203596:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0203598:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc020359c:	fee57ae3          	bleu	a4,a0,ffffffffc0203590 <default_free_pages+0x84>
ffffffffc02035a0:	00080663          	beqz	a6,ffffffffc02035ac <default_free_pages+0xa0>
ffffffffc02035a4:	0000e817          	auipc	a6,0xe
ffffffffc02035a8:	fcb83e23          	sd	a1,-36(a6) # ffffffffc0211580 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc02035ac:	638c                	ld	a1,0(a5)
    prev->next = next->prev = elm;
ffffffffc02035ae:	e390                	sd	a2,0(a5)
ffffffffc02035b0:	e590                	sd	a2,8(a1)
    elm->next = next;
ffffffffc02035b2:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc02035b4:	f10c                	sd	a1,32(a0)
    if (le != &free_list) {
ffffffffc02035b6:	02d59163          	bne	a1,a3,ffffffffc02035d8 <default_free_pages+0xcc>
ffffffffc02035ba:	a091                	j	ffffffffc02035fe <default_free_pages+0xf2>
    prev->next = next->prev = elm;
ffffffffc02035bc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02035be:	f514                	sd	a3,40(a0)
ffffffffc02035c0:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02035c2:	f11c                	sd	a5,32(a0)
                list_add(le, &(base->page_link));
ffffffffc02035c4:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02035c6:	00d70563          	beq	a4,a3,ffffffffc02035d0 <default_free_pages+0xc4>
ffffffffc02035ca:	4805                	li	a6,1
ffffffffc02035cc:	87ba                	mv	a5,a4
ffffffffc02035ce:	b7e9                	j	ffffffffc0203598 <default_free_pages+0x8c>
ffffffffc02035d0:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02035d2:	85be                	mv	a1,a5
    if (le != &free_list) {
ffffffffc02035d4:	02d78163          	beq	a5,a3,ffffffffc02035f6 <default_free_pages+0xea>
        if (p + p->property == base) {
ffffffffc02035d8:	ff85a803          	lw	a6,-8(a1) # ff8 <BASE_ADDRESS-0xffffffffc01ff008>
        p = le2page(le, page_link);
ffffffffc02035dc:	fe058613          	addi	a2,a1,-32
        if (p + p->property == base) {
ffffffffc02035e0:	02081713          	slli	a4,a6,0x20
ffffffffc02035e4:	9301                	srli	a4,a4,0x20
ffffffffc02035e6:	00371793          	slli	a5,a4,0x3
ffffffffc02035ea:	97ba                	add	a5,a5,a4
ffffffffc02035ec:	078e                	slli	a5,a5,0x3
ffffffffc02035ee:	97b2                	add	a5,a5,a2
ffffffffc02035f0:	02f50e63          	beq	a0,a5,ffffffffc020362c <default_free_pages+0x120>
ffffffffc02035f4:	751c                	ld	a5,40(a0)
    if (le != &free_list) {
ffffffffc02035f6:	fe078713          	addi	a4,a5,-32
ffffffffc02035fa:	00d78d63          	beq	a5,a3,ffffffffc0203614 <default_free_pages+0x108>
        if (base + base->property == p) {
ffffffffc02035fe:	4d0c                	lw	a1,24(a0)
ffffffffc0203600:	02059613          	slli	a2,a1,0x20
ffffffffc0203604:	9201                	srli	a2,a2,0x20
ffffffffc0203606:	00361693          	slli	a3,a2,0x3
ffffffffc020360a:	96b2                	add	a3,a3,a2
ffffffffc020360c:	068e                	slli	a3,a3,0x3
ffffffffc020360e:	96aa                	add	a3,a3,a0
ffffffffc0203610:	04d70063          	beq	a4,a3,ffffffffc0203650 <default_free_pages+0x144>
}
ffffffffc0203614:	60a2                	ld	ra,8(sp)
ffffffffc0203616:	0141                	addi	sp,sp,16
ffffffffc0203618:	8082                	ret
ffffffffc020361a:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc020361c:	02050713          	addi	a4,a0,32
    prev->next = next->prev = elm;
ffffffffc0203620:	e398                	sd	a4,0(a5)
ffffffffc0203622:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0203624:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0203626:	f11c                	sd	a5,32(a0)
}
ffffffffc0203628:	0141                	addi	sp,sp,16
ffffffffc020362a:	8082                	ret
            p->property += base->property;
ffffffffc020362c:	4d1c                	lw	a5,24(a0)
ffffffffc020362e:	0107883b          	addw	a6,a5,a6
ffffffffc0203632:	ff05ac23          	sw	a6,-8(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203636:	57f5                	li	a5,-3
ffffffffc0203638:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020363c:	02053803          	ld	a6,32(a0)
ffffffffc0203640:	7518                	ld	a4,40(a0)
            base = p;
ffffffffc0203642:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc0203644:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc0203648:	659c                	ld	a5,8(a1)
ffffffffc020364a:	01073023          	sd	a6,0(a4)
ffffffffc020364e:	b765                	j	ffffffffc02035f6 <default_free_pages+0xea>
            base->property += p->property;
ffffffffc0203650:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203654:	fe878693          	addi	a3,a5,-24
ffffffffc0203658:	9db9                	addw	a1,a1,a4
ffffffffc020365a:	cd0c                	sw	a1,24(a0)
ffffffffc020365c:	5775                	li	a4,-3
ffffffffc020365e:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203662:	6398                	ld	a4,0(a5)
ffffffffc0203664:	679c                	ld	a5,8(a5)
}
ffffffffc0203666:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0203668:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020366a:	e398                	sd	a4,0(a5)
ffffffffc020366c:	0141                	addi	sp,sp,16
ffffffffc020366e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203670:	00002697          	auipc	a3,0x2
ffffffffc0203674:	6a068693          	addi	a3,a3,1696 # ffffffffc0205d10 <commands+0x18d8>
ffffffffc0203678:	00001617          	auipc	a2,0x1
ffffffffc020367c:	7b060613          	addi	a2,a2,1968 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203680:	08300593          	li	a1,131
ffffffffc0203684:	00002517          	auipc	a0,0x2
ffffffffc0203688:	37c50513          	addi	a0,a0,892 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc020368c:	a7bfc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(n > 0);
ffffffffc0203690:	00002697          	auipc	a3,0x2
ffffffffc0203694:	6a868693          	addi	a3,a3,1704 # ffffffffc0205d38 <commands+0x1900>
ffffffffc0203698:	00001617          	auipc	a2,0x1
ffffffffc020369c:	79060613          	addi	a2,a2,1936 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02036a0:	08000593          	li	a1,128
ffffffffc02036a4:	00002517          	auipc	a0,0x2
ffffffffc02036a8:	35c50513          	addi	a0,a0,860 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc02036ac:	a5bfc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc02036b0 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02036b0:	cd51                	beqz	a0,ffffffffc020374c <default_alloc_pages+0x9c>
    if (n > nr_free) {
ffffffffc02036b2:	0000e597          	auipc	a1,0xe
ffffffffc02036b6:	ece58593          	addi	a1,a1,-306 # ffffffffc0211580 <free_area>
ffffffffc02036ba:	0105a803          	lw	a6,16(a1)
ffffffffc02036be:	862a                	mv	a2,a0
ffffffffc02036c0:	02081793          	slli	a5,a6,0x20
ffffffffc02036c4:	9381                	srli	a5,a5,0x20
ffffffffc02036c6:	00a7ee63          	bltu	a5,a0,ffffffffc02036e2 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02036ca:	87ae                	mv	a5,a1
ffffffffc02036cc:	a801                	j	ffffffffc02036dc <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc02036ce:	ff87a703          	lw	a4,-8(a5)
ffffffffc02036d2:	02071693          	slli	a3,a4,0x20
ffffffffc02036d6:	9281                	srli	a3,a3,0x20
ffffffffc02036d8:	00c6f763          	bleu	a2,a3,ffffffffc02036e6 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02036dc:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02036de:	feb798e3          	bne	a5,a1,ffffffffc02036ce <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02036e2:	4501                	li	a0,0
}
ffffffffc02036e4:	8082                	ret
        struct Page *p = le2page(le, page_link);
ffffffffc02036e6:	fe078513          	addi	a0,a5,-32
    if (page != NULL) {
ffffffffc02036ea:	dd6d                	beqz	a0,ffffffffc02036e4 <default_alloc_pages+0x34>
    return listelm->prev;
ffffffffc02036ec:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02036f0:	0087b303          	ld	t1,8(a5)
    prev->next = next;
ffffffffc02036f4:	00060e1b          	sext.w	t3,a2
ffffffffc02036f8:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02036fc:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0203700:	02d67b63          	bleu	a3,a2,ffffffffc0203736 <default_alloc_pages+0x86>
            struct Page *p = page + n;
ffffffffc0203704:	00361693          	slli	a3,a2,0x3
ffffffffc0203708:	96b2                	add	a3,a3,a2
ffffffffc020370a:	068e                	slli	a3,a3,0x3
ffffffffc020370c:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc020370e:	41c7073b          	subw	a4,a4,t3
ffffffffc0203712:	ce98                	sw	a4,24(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203714:	00868613          	addi	a2,a3,8
ffffffffc0203718:	4709                	li	a4,2
ffffffffc020371a:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020371e:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0203722:	02068613          	addi	a2,a3,32
    prev->next = next->prev = elm;
ffffffffc0203726:	0105a803          	lw	a6,16(a1)
ffffffffc020372a:	e310                	sd	a2,0(a4)
ffffffffc020372c:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0203730:	f698                	sd	a4,40(a3)
    elm->prev = prev;
ffffffffc0203732:	0316b023          	sd	a7,32(a3)
        nr_free -= n;
ffffffffc0203736:	41c8083b          	subw	a6,a6,t3
ffffffffc020373a:	0000e717          	auipc	a4,0xe
ffffffffc020373e:	e5072b23          	sw	a6,-426(a4) # ffffffffc0211590 <free_area+0x10>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203742:	5775                	li	a4,-3
ffffffffc0203744:	17a1                	addi	a5,a5,-24
ffffffffc0203746:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc020374a:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc020374c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc020374e:	00002697          	auipc	a3,0x2
ffffffffc0203752:	5ea68693          	addi	a3,a3,1514 # ffffffffc0205d38 <commands+0x1900>
ffffffffc0203756:	00001617          	auipc	a2,0x1
ffffffffc020375a:	6d260613          	addi	a2,a2,1746 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020375e:	06200593          	li	a1,98
ffffffffc0203762:	00002517          	auipc	a0,0x2
ffffffffc0203766:	29e50513          	addi	a0,a0,670 # ffffffffc0205a00 <commands+0x15c8>
default_alloc_pages(size_t n) {
ffffffffc020376a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020376c:	99bfc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203770 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0203770:	1141                	addi	sp,sp,-16
ffffffffc0203772:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203774:	c1fd                	beqz	a1,ffffffffc020385a <default_init_memmap+0xea>
    for (; p != base + n; p ++) {
ffffffffc0203776:	00359693          	slli	a3,a1,0x3
ffffffffc020377a:	96ae                	add	a3,a3,a1
ffffffffc020377c:	068e                	slli	a3,a3,0x3
ffffffffc020377e:	96aa                	add	a3,a3,a0
ffffffffc0203780:	02d50463          	beq	a0,a3,ffffffffc02037a8 <default_init_memmap+0x38>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0203784:	6518                	ld	a4,8(a0)
        assert(PageReserved(p));
ffffffffc0203786:	87aa                	mv	a5,a0
ffffffffc0203788:	8b05                	andi	a4,a4,1
ffffffffc020378a:	e709                	bnez	a4,ffffffffc0203794 <default_init_memmap+0x24>
ffffffffc020378c:	a07d                	j	ffffffffc020383a <default_init_memmap+0xca>
ffffffffc020378e:	6798                	ld	a4,8(a5)
ffffffffc0203790:	8b05                	andi	a4,a4,1
ffffffffc0203792:	c745                	beqz	a4,ffffffffc020383a <default_init_memmap+0xca>
        p->flags = p->property = 0;
ffffffffc0203794:	0007ac23          	sw	zero,24(a5)
ffffffffc0203798:	0007b423          	sd	zero,8(a5)
ffffffffc020379c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02037a0:	04878793          	addi	a5,a5,72
ffffffffc02037a4:	fed795e3          	bne	a5,a3,ffffffffc020378e <default_init_memmap+0x1e>
    base->property = n;
ffffffffc02037a8:	2581                	sext.w	a1,a1
ffffffffc02037aa:	cd0c                	sw	a1,24(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02037ac:	4789                	li	a5,2
ffffffffc02037ae:	00850713          	addi	a4,a0,8
ffffffffc02037b2:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02037b6:	0000e697          	auipc	a3,0xe
ffffffffc02037ba:	dca68693          	addi	a3,a3,-566 # ffffffffc0211580 <free_area>
ffffffffc02037be:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02037c0:	669c                	ld	a5,8(a3)
ffffffffc02037c2:	9db9                	addw	a1,a1,a4
ffffffffc02037c4:	0000e717          	auipc	a4,0xe
ffffffffc02037c8:	dcb72623          	sw	a1,-564(a4) # ffffffffc0211590 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc02037cc:	04d78a63          	beq	a5,a3,ffffffffc0203820 <default_init_memmap+0xb0>
            struct Page* page = le2page(le, page_link);
ffffffffc02037d0:	fe078713          	addi	a4,a5,-32
ffffffffc02037d4:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02037d6:	4801                	li	a6,0
ffffffffc02037d8:	02050613          	addi	a2,a0,32
            if (base < page) {
ffffffffc02037dc:	00e56a63          	bltu	a0,a4,ffffffffc02037f0 <default_init_memmap+0x80>
    return listelm->next;
ffffffffc02037e0:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02037e2:	02d70563          	beq	a4,a3,ffffffffc020380c <default_init_memmap+0x9c>
        while ((le = list_next(le)) != &free_list) {
ffffffffc02037e6:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02037e8:	fe078713          	addi	a4,a5,-32
            if (base < page) {
ffffffffc02037ec:	fee57ae3          	bleu	a4,a0,ffffffffc02037e0 <default_init_memmap+0x70>
ffffffffc02037f0:	00080663          	beqz	a6,ffffffffc02037fc <default_init_memmap+0x8c>
ffffffffc02037f4:	0000e717          	auipc	a4,0xe
ffffffffc02037f8:	d8b73623          	sd	a1,-628(a4) # ffffffffc0211580 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc02037fc:	6398                	ld	a4,0(a5)
}
ffffffffc02037fe:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0203800:	e390                	sd	a2,0(a5)
ffffffffc0203802:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0203804:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc0203806:	f118                	sd	a4,32(a0)
ffffffffc0203808:	0141                	addi	sp,sp,16
ffffffffc020380a:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020380c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020380e:	f514                	sd	a3,40(a0)
ffffffffc0203810:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0203812:	f11c                	sd	a5,32(a0)
                list_add(le, &(base->page_link));
ffffffffc0203814:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0203816:	00d70e63          	beq	a4,a3,ffffffffc0203832 <default_init_memmap+0xc2>
ffffffffc020381a:	4805                	li	a6,1
ffffffffc020381c:	87ba                	mv	a5,a4
ffffffffc020381e:	b7e9                	j	ffffffffc02037e8 <default_init_memmap+0x78>
}
ffffffffc0203820:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0203822:	02050713          	addi	a4,a0,32
    prev->next = next->prev = elm;
ffffffffc0203826:	e398                	sd	a4,0(a5)
ffffffffc0203828:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020382a:	f51c                	sd	a5,40(a0)
    elm->prev = prev;
ffffffffc020382c:	f11c                	sd	a5,32(a0)
}
ffffffffc020382e:	0141                	addi	sp,sp,16
ffffffffc0203830:	8082                	ret
ffffffffc0203832:	60a2                	ld	ra,8(sp)
ffffffffc0203834:	e290                	sd	a2,0(a3)
ffffffffc0203836:	0141                	addi	sp,sp,16
ffffffffc0203838:	8082                	ret
        assert(PageReserved(p));
ffffffffc020383a:	00002697          	auipc	a3,0x2
ffffffffc020383e:	50668693          	addi	a3,a3,1286 # ffffffffc0205d40 <commands+0x1908>
ffffffffc0203842:	00001617          	auipc	a2,0x1
ffffffffc0203846:	5e660613          	addi	a2,a2,1510 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020384a:	04900593          	li	a1,73
ffffffffc020384e:	00002517          	auipc	a0,0x2
ffffffffc0203852:	1b250513          	addi	a0,a0,434 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203856:	8b1fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(n > 0);
ffffffffc020385a:	00002697          	auipc	a3,0x2
ffffffffc020385e:	4de68693          	addi	a3,a3,1246 # ffffffffc0205d38 <commands+0x1900>
ffffffffc0203862:	00001617          	auipc	a2,0x1
ffffffffc0203866:	5c660613          	addi	a2,a2,1478 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc020386a:	04600593          	li	a1,70
ffffffffc020386e:	00002517          	auipc	a0,0x2
ffffffffc0203872:	19250513          	addi	a0,a0,402 # ffffffffc0205a00 <commands+0x15c8>
ffffffffc0203876:	891fc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc020387a <_clock_init_mm>:
    elm->prev = elm->next = elm;
ffffffffc020387a:	0000e797          	auipc	a5,0xe
ffffffffc020387e:	c2678793          	addi	a5,a5,-986 # ffffffffc02114a0 <pra_list_head>
     // 初始化pra_list_head为空链表
     // 初始化当前指针curr_ptr指向pra_list_head，表示当前页面替换位置为链表头
     // 将mm的私有成员指针指向pra_list_head，用于后续的页面替换算法操作
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     list_init(&pra_list_head);
     curr_ptr=mm->sm_priv=&pra_list_head;
ffffffffc0203882:	f51c                	sd	a5,40(a0)
ffffffffc0203884:	e79c                	sd	a5,8(a5)
ffffffffc0203886:	e39c                	sd	a5,0(a5)
ffffffffc0203888:	0000e717          	auipc	a4,0xe
ffffffffc020388c:	d0f73823          	sd	a5,-752(a4) # ffffffffc0211598 <curr_ptr>
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc0203890:	4501                	li	a0,0
ffffffffc0203892:	8082                	ret

ffffffffc0203894 <_clock_init>:

static int
_clock_init(void)
{
    return 0;
}
ffffffffc0203894:	4501                	li	a0,0
ffffffffc0203896:	8082                	ret

ffffffffc0203898 <_clock_set_unswappable>:

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc0203898:	4501                	li	a0,0
ffffffffc020389a:	8082                	ret

ffffffffc020389c <_clock_tick_event>:

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc020389c:	4501                	li	a0,0
ffffffffc020389e:	8082                	ret

ffffffffc02038a0 <_clock_check_swap>:
_clock_check_swap(void) {
ffffffffc02038a0:	1141                	addi	sp,sp,-16
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02038a2:	678d                	lui	a5,0x3
ffffffffc02038a4:	4731                	li	a4,12
_clock_check_swap(void) {
ffffffffc02038a6:	e406                	sd	ra,8(sp)
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02038a8:	00e78023          	sb	a4,0(a5) # 3000 <BASE_ADDRESS-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc02038ac:	0000e797          	auipc	a5,0xe
ffffffffc02038b0:	bb478793          	addi	a5,a5,-1100 # ffffffffc0211460 <pgfault_num>
ffffffffc02038b4:	4398                	lw	a4,0(a5)
ffffffffc02038b6:	4691                	li	a3,4
ffffffffc02038b8:	2701                	sext.w	a4,a4
ffffffffc02038ba:	08d71f63          	bne	a4,a3,ffffffffc0203958 <_clock_check_swap+0xb8>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02038be:	6685                	lui	a3,0x1
ffffffffc02038c0:	4629                	li	a2,10
ffffffffc02038c2:	00c68023          	sb	a2,0(a3) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc02038c6:	4394                	lw	a3,0(a5)
ffffffffc02038c8:	2681                	sext.w	a3,a3
ffffffffc02038ca:	20e69763          	bne	a3,a4,ffffffffc0203ad8 <_clock_check_swap+0x238>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02038ce:	6711                	lui	a4,0x4
ffffffffc02038d0:	4635                	li	a2,13
ffffffffc02038d2:	00c70023          	sb	a2,0(a4) # 4000 <BASE_ADDRESS-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc02038d6:	4398                	lw	a4,0(a5)
ffffffffc02038d8:	2701                	sext.w	a4,a4
ffffffffc02038da:	1cd71f63          	bne	a4,a3,ffffffffc0203ab8 <_clock_check_swap+0x218>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02038de:	6689                	lui	a3,0x2
ffffffffc02038e0:	462d                	li	a2,11
ffffffffc02038e2:	00c68023          	sb	a2,0(a3) # 2000 <BASE_ADDRESS-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc02038e6:	4394                	lw	a3,0(a5)
ffffffffc02038e8:	2681                	sext.w	a3,a3
ffffffffc02038ea:	1ae69763          	bne	a3,a4,ffffffffc0203a98 <_clock_check_swap+0x1f8>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc02038ee:	6715                	lui	a4,0x5
ffffffffc02038f0:	46b9                	li	a3,14
ffffffffc02038f2:	00d70023          	sb	a3,0(a4) # 5000 <BASE_ADDRESS-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc02038f6:	4398                	lw	a4,0(a5)
ffffffffc02038f8:	4695                	li	a3,5
ffffffffc02038fa:	2701                	sext.w	a4,a4
ffffffffc02038fc:	16d71e63          	bne	a4,a3,ffffffffc0203a78 <_clock_check_swap+0x1d8>
    assert(pgfault_num==5);
ffffffffc0203900:	4394                	lw	a3,0(a5)
ffffffffc0203902:	2681                	sext.w	a3,a3
ffffffffc0203904:	14e69a63          	bne	a3,a4,ffffffffc0203a58 <_clock_check_swap+0x1b8>
    assert(pgfault_num==5);
ffffffffc0203908:	4398                	lw	a4,0(a5)
ffffffffc020390a:	2701                	sext.w	a4,a4
ffffffffc020390c:	12d71663          	bne	a4,a3,ffffffffc0203a38 <_clock_check_swap+0x198>
    assert(pgfault_num==5);
ffffffffc0203910:	4394                	lw	a3,0(a5)
ffffffffc0203912:	2681                	sext.w	a3,a3
ffffffffc0203914:	10e69263          	bne	a3,a4,ffffffffc0203a18 <_clock_check_swap+0x178>
    assert(pgfault_num==5);
ffffffffc0203918:	4398                	lw	a4,0(a5)
ffffffffc020391a:	2701                	sext.w	a4,a4
ffffffffc020391c:	0cd71e63          	bne	a4,a3,ffffffffc02039f8 <_clock_check_swap+0x158>
    assert(pgfault_num==5);
ffffffffc0203920:	4394                	lw	a3,0(a5)
ffffffffc0203922:	2681                	sext.w	a3,a3
ffffffffc0203924:	0ae69a63          	bne	a3,a4,ffffffffc02039d8 <_clock_check_swap+0x138>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0203928:	6715                	lui	a4,0x5
ffffffffc020392a:	46b9                	li	a3,14
ffffffffc020392c:	00d70023          	sb	a3,0(a4) # 5000 <BASE_ADDRESS-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc0203930:	4398                	lw	a4,0(a5)
ffffffffc0203932:	4695                	li	a3,5
ffffffffc0203934:	2701                	sext.w	a4,a4
ffffffffc0203936:	08d71163          	bne	a4,a3,ffffffffc02039b8 <_clock_check_swap+0x118>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc020393a:	6705                	lui	a4,0x1
ffffffffc020393c:	00074683          	lbu	a3,0(a4) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc0203940:	4729                	li	a4,10
ffffffffc0203942:	04e69b63          	bne	a3,a4,ffffffffc0203998 <_clock_check_swap+0xf8>
    assert(pgfault_num==6);
ffffffffc0203946:	439c                	lw	a5,0(a5)
ffffffffc0203948:	4719                	li	a4,6
ffffffffc020394a:	2781                	sext.w	a5,a5
ffffffffc020394c:	02e79663          	bne	a5,a4,ffffffffc0203978 <_clock_check_swap+0xd8>
}
ffffffffc0203950:	60a2                	ld	ra,8(sp)
ffffffffc0203952:	4501                	li	a0,0
ffffffffc0203954:	0141                	addi	sp,sp,16
ffffffffc0203956:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0203958:	00002697          	auipc	a3,0x2
ffffffffc020395c:	f3868693          	addi	a3,a3,-200 # ffffffffc0205890 <commands+0x1458>
ffffffffc0203960:	00001617          	auipc	a2,0x1
ffffffffc0203964:	4c860613          	addi	a2,a2,1224 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203968:	08e00593          	li	a1,142
ffffffffc020396c:	00002517          	auipc	a0,0x2
ffffffffc0203970:	43450513          	addi	a0,a0,1076 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203974:	f92fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==6);
ffffffffc0203978:	00002697          	auipc	a3,0x2
ffffffffc020397c:	47868693          	addi	a3,a3,1144 # ffffffffc0205df0 <default_pmm_manager+0xa0>
ffffffffc0203980:	00001617          	auipc	a2,0x1
ffffffffc0203984:	4a860613          	addi	a2,a2,1192 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203988:	0a500593          	li	a1,165
ffffffffc020398c:	00002517          	auipc	a0,0x2
ffffffffc0203990:	41450513          	addi	a0,a0,1044 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203994:	f72fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0203998:	00002697          	auipc	a3,0x2
ffffffffc020399c:	43068693          	addi	a3,a3,1072 # ffffffffc0205dc8 <default_pmm_manager+0x78>
ffffffffc02039a0:	00001617          	auipc	a2,0x1
ffffffffc02039a4:	48860613          	addi	a2,a2,1160 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02039a8:	0a300593          	li	a1,163
ffffffffc02039ac:	00002517          	auipc	a0,0x2
ffffffffc02039b0:	3f450513          	addi	a0,a0,1012 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc02039b4:	f52fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc02039b8:	00002697          	auipc	a3,0x2
ffffffffc02039bc:	40068693          	addi	a3,a3,1024 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc02039c0:	00001617          	auipc	a2,0x1
ffffffffc02039c4:	46860613          	addi	a2,a2,1128 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02039c8:	0a200593          	li	a1,162
ffffffffc02039cc:	00002517          	auipc	a0,0x2
ffffffffc02039d0:	3d450513          	addi	a0,a0,980 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc02039d4:	f32fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc02039d8:	00002697          	auipc	a3,0x2
ffffffffc02039dc:	3e068693          	addi	a3,a3,992 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc02039e0:	00001617          	auipc	a2,0x1
ffffffffc02039e4:	44860613          	addi	a2,a2,1096 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc02039e8:	0a000593          	li	a1,160
ffffffffc02039ec:	00002517          	auipc	a0,0x2
ffffffffc02039f0:	3b450513          	addi	a0,a0,948 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc02039f4:	f12fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc02039f8:	00002697          	auipc	a3,0x2
ffffffffc02039fc:	3c068693          	addi	a3,a3,960 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc0203a00:	00001617          	auipc	a2,0x1
ffffffffc0203a04:	42860613          	addi	a2,a2,1064 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203a08:	09e00593          	li	a1,158
ffffffffc0203a0c:	00002517          	auipc	a0,0x2
ffffffffc0203a10:	39450513          	addi	a0,a0,916 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203a14:	ef2fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc0203a18:	00002697          	auipc	a3,0x2
ffffffffc0203a1c:	3a068693          	addi	a3,a3,928 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc0203a20:	00001617          	auipc	a2,0x1
ffffffffc0203a24:	40860613          	addi	a2,a2,1032 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203a28:	09c00593          	li	a1,156
ffffffffc0203a2c:	00002517          	auipc	a0,0x2
ffffffffc0203a30:	37450513          	addi	a0,a0,884 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203a34:	ed2fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc0203a38:	00002697          	auipc	a3,0x2
ffffffffc0203a3c:	38068693          	addi	a3,a3,896 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc0203a40:	00001617          	auipc	a2,0x1
ffffffffc0203a44:	3e860613          	addi	a2,a2,1000 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203a48:	09a00593          	li	a1,154
ffffffffc0203a4c:	00002517          	auipc	a0,0x2
ffffffffc0203a50:	35450513          	addi	a0,a0,852 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203a54:	eb2fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc0203a58:	00002697          	auipc	a3,0x2
ffffffffc0203a5c:	36068693          	addi	a3,a3,864 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc0203a60:	00001617          	auipc	a2,0x1
ffffffffc0203a64:	3c860613          	addi	a2,a2,968 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203a68:	09800593          	li	a1,152
ffffffffc0203a6c:	00002517          	auipc	a0,0x2
ffffffffc0203a70:	33450513          	addi	a0,a0,820 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203a74:	e92fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==5);
ffffffffc0203a78:	00002697          	auipc	a3,0x2
ffffffffc0203a7c:	34068693          	addi	a3,a3,832 # ffffffffc0205db8 <default_pmm_manager+0x68>
ffffffffc0203a80:	00001617          	auipc	a2,0x1
ffffffffc0203a84:	3a860613          	addi	a2,a2,936 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203a88:	09600593          	li	a1,150
ffffffffc0203a8c:	00002517          	auipc	a0,0x2
ffffffffc0203a90:	31450513          	addi	a0,a0,788 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203a94:	e72fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==4);
ffffffffc0203a98:	00002697          	auipc	a3,0x2
ffffffffc0203a9c:	df868693          	addi	a3,a3,-520 # ffffffffc0205890 <commands+0x1458>
ffffffffc0203aa0:	00001617          	auipc	a2,0x1
ffffffffc0203aa4:	38860613          	addi	a2,a2,904 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203aa8:	09400593          	li	a1,148
ffffffffc0203aac:	00002517          	auipc	a0,0x2
ffffffffc0203ab0:	2f450513          	addi	a0,a0,756 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203ab4:	e52fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==4);
ffffffffc0203ab8:	00002697          	auipc	a3,0x2
ffffffffc0203abc:	dd868693          	addi	a3,a3,-552 # ffffffffc0205890 <commands+0x1458>
ffffffffc0203ac0:	00001617          	auipc	a2,0x1
ffffffffc0203ac4:	36860613          	addi	a2,a2,872 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203ac8:	09200593          	li	a1,146
ffffffffc0203acc:	00002517          	auipc	a0,0x2
ffffffffc0203ad0:	2d450513          	addi	a0,a0,724 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203ad4:	e32fc0ef          	jal	ra,ffffffffc0200106 <__panic>
    assert(pgfault_num==4);
ffffffffc0203ad8:	00002697          	auipc	a3,0x2
ffffffffc0203adc:	db868693          	addi	a3,a3,-584 # ffffffffc0205890 <commands+0x1458>
ffffffffc0203ae0:	00001617          	auipc	a2,0x1
ffffffffc0203ae4:	34860613          	addi	a2,a2,840 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203ae8:	09000593          	li	a1,144
ffffffffc0203aec:	00002517          	auipc	a0,0x2
ffffffffc0203af0:	2b450513          	addi	a0,a0,692 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203af4:	e12fc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203af8 <_clock_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0203af8:	7508                	ld	a0,40(a0)
{
ffffffffc0203afa:	1141                	addi	sp,sp,-16
ffffffffc0203afc:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc0203afe:	c539                	beqz	a0,ffffffffc0203b4c <_clock_swap_out_victim+0x54>
     assert(in_tick==0);
ffffffffc0203b00:	e635                	bnez	a2,ffffffffc0203b6c <_clock_swap_out_victim+0x74>
ffffffffc0203b02:	0000e797          	auipc	a5,0xe
ffffffffc0203b06:	a9678793          	addi	a5,a5,-1386 # ffffffffc0211598 <curr_ptr>
ffffffffc0203b0a:	639c                	ld	a5,0(a5)
ffffffffc0203b0c:	a039                	j	ffffffffc0203b1a <_clock_swap_out_victim+0x22>
        if(page->visited==0)
ffffffffc0203b0e:	fe07b603          	ld	a2,-32(a5)
ffffffffc0203b12:	ce01                	beqz	a2,ffffffffc0203b2a <_clock_swap_out_victim+0x32>
            page->visited=0;
ffffffffc0203b14:	fe07b023          	sd	zero,-32(a5)
    while (1) {
ffffffffc0203b18:	87b6                	mv	a5,a3
    return listelm->next;
ffffffffc0203b1a:	6798                	ld	a4,8(a5)
        if(curr_ptr==head)
ffffffffc0203b1c:	86ba                	mv	a3,a4
ffffffffc0203b1e:	fee518e3          	bne	a0,a4,ffffffffc0203b0e <_clock_swap_out_victim+0x16>
        if(page->visited==0)
ffffffffc0203b22:	fe07b603          	ld	a2,-32(a5)
ffffffffc0203b26:	6514                	ld	a3,8(a0)
ffffffffc0203b28:	f675                	bnez	a2,ffffffffc0203b14 <_clock_swap_out_victim+0x1c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203b2a:	6390                	ld	a2,0(a5)
ffffffffc0203b2c:	0000e517          	auipc	a0,0xe
ffffffffc0203b30:	a6d53623          	sd	a3,-1428(a0) # ffffffffc0211598 <curr_ptr>
            page->visited=1;
ffffffffc0203b34:	4685                	li	a3,1
ffffffffc0203b36:	fed7b023          	sd	a3,-32(a5)
    prev->next = next;
ffffffffc0203b3a:	e618                	sd	a4,8(a2)
}
ffffffffc0203b3c:	60a2                	ld	ra,8(sp)
    next->prev = prev;
ffffffffc0203b3e:	e310                	sd	a2,0(a4)
        struct Page *page=le2page(le,pra_page_link);
ffffffffc0203b40:	fd078793          	addi	a5,a5,-48
            *ptr_page=page;
ffffffffc0203b44:	e19c                	sd	a5,0(a1)
}
ffffffffc0203b46:	4501                	li	a0,0
ffffffffc0203b48:	0141                	addi	sp,sp,16
ffffffffc0203b4a:	8082                	ret
         assert(head != NULL);
ffffffffc0203b4c:	00002697          	auipc	a3,0x2
ffffffffc0203b50:	2dc68693          	addi	a3,a3,732 # ffffffffc0205e28 <default_pmm_manager+0xd8>
ffffffffc0203b54:	00001617          	auipc	a2,0x1
ffffffffc0203b58:	2d460613          	addi	a2,a2,724 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203b5c:	04900593          	li	a1,73
ffffffffc0203b60:	00002517          	auipc	a0,0x2
ffffffffc0203b64:	24050513          	addi	a0,a0,576 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203b68:	d9efc0ef          	jal	ra,ffffffffc0200106 <__panic>
     assert(in_tick==0);
ffffffffc0203b6c:	00002697          	auipc	a3,0x2
ffffffffc0203b70:	2cc68693          	addi	a3,a3,716 # ffffffffc0205e38 <default_pmm_manager+0xe8>
ffffffffc0203b74:	00001617          	auipc	a2,0x1
ffffffffc0203b78:	2b460613          	addi	a2,a2,692 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203b7c:	04a00593          	li	a1,74
ffffffffc0203b80:	00002517          	auipc	a0,0x2
ffffffffc0203b84:	22050513          	addi	a0,a0,544 # ffffffffc0205da0 <default_pmm_manager+0x50>
ffffffffc0203b88:	d7efc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203b8c <_clock_map_swappable>:
    list_entry_t *entry=&(page->pra_page_link);
ffffffffc0203b8c:	03060793          	addi	a5,a2,48
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0203b90:	cf85                	beqz	a5,ffffffffc0203bc8 <_clock_map_swappable+0x3c>
ffffffffc0203b92:	0000e717          	auipc	a4,0xe
ffffffffc0203b96:	a0670713          	addi	a4,a4,-1530 # ffffffffc0211598 <curr_ptr>
ffffffffc0203b9a:	6318                	ld	a4,0(a4)
ffffffffc0203b9c:	c715                	beqz	a4,ffffffffc0203bc8 <_clock_map_swappable+0x3c>
    __list_add(elm, listelm, listelm->next);
ffffffffc0203b9e:	0000e717          	auipc	a4,0xe
ffffffffc0203ba2:	90270713          	addi	a4,a4,-1790 # ffffffffc02114a0 <pra_list_head>
ffffffffc0203ba6:	6714                	ld	a3,8(a4)
}
ffffffffc0203ba8:	4501                	li	a0,0
    prev->next = next->prev = elm;
ffffffffc0203baa:	e29c                	sd	a5,0(a3)
    curr_ptr=list_prev(&pra_list_head);
ffffffffc0203bac:	630c                	ld	a1,0(a4)
ffffffffc0203bae:	0000e817          	auipc	a6,0xe
ffffffffc0203bb2:	8ef83d23          	sd	a5,-1798(a6) # ffffffffc02114a8 <pra_list_head+0x8>
    elm->next = next;
ffffffffc0203bb6:	fe14                	sd	a3,56(a2)
ffffffffc0203bb8:	0000e797          	auipc	a5,0xe
ffffffffc0203bbc:	9eb7b023          	sd	a1,-1568(a5) # ffffffffc0211598 <curr_ptr>
    page->visited=1;
ffffffffc0203bc0:	4785                	li	a5,1
    elm->prev = prev;
ffffffffc0203bc2:	fa18                	sd	a4,48(a2)
ffffffffc0203bc4:	ea1c                	sd	a5,16(a2)
}
ffffffffc0203bc6:	8082                	ret
{
ffffffffc0203bc8:	1141                	addi	sp,sp,-16
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0203bca:	00002697          	auipc	a3,0x2
ffffffffc0203bce:	23668693          	addi	a3,a3,566 # ffffffffc0205e00 <default_pmm_manager+0xb0>
ffffffffc0203bd2:	00001617          	auipc	a2,0x1
ffffffffc0203bd6:	25660613          	addi	a2,a2,598 # ffffffffc0204e28 <commands+0x9f0>
ffffffffc0203bda:	03600593          	li	a1,54
ffffffffc0203bde:	00002517          	auipc	a0,0x2
ffffffffc0203be2:	1c250513          	addi	a0,a0,450 # ffffffffc0205da0 <default_pmm_manager+0x50>
{
ffffffffc0203be6:	e406                	sd	ra,8(sp)
    assert(entry != NULL && curr_ptr != NULL);
ffffffffc0203be8:	d1efc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203bec <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0203bec:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203bee:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0203bf0:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0203bf2:	fe4fc0ef          	jal	ra,ffffffffc02003d6 <ide_device_valid>
ffffffffc0203bf6:	cd01                	beqz	a0,ffffffffc0203c0e <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203bf8:	4505                	li	a0,1
ffffffffc0203bfa:	fe2fc0ef          	jal	ra,ffffffffc02003dc <ide_device_size>
}
ffffffffc0203bfe:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0203c00:	810d                	srli	a0,a0,0x3
ffffffffc0203c02:	0000e797          	auipc	a5,0xe
ffffffffc0203c06:	92a7bf23          	sd	a0,-1730(a5) # ffffffffc0211540 <max_swap_offset>
}
ffffffffc0203c0a:	0141                	addi	sp,sp,16
ffffffffc0203c0c:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0203c0e:	00002617          	auipc	a2,0x2
ffffffffc0203c12:	25260613          	addi	a2,a2,594 # ffffffffc0205e60 <default_pmm_manager+0x110>
ffffffffc0203c16:	45b5                	li	a1,13
ffffffffc0203c18:	00002517          	auipc	a0,0x2
ffffffffc0203c1c:	26850513          	addi	a0,a0,616 # ffffffffc0205e80 <default_pmm_manager+0x130>
ffffffffc0203c20:	ce6fc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203c24 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0203c24:	1141                	addi	sp,sp,-16
ffffffffc0203c26:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203c28:	00855793          	srli	a5,a0,0x8
ffffffffc0203c2c:	c7b5                	beqz	a5,ffffffffc0203c98 <swapfs_read+0x74>
ffffffffc0203c2e:	0000e717          	auipc	a4,0xe
ffffffffc0203c32:	91270713          	addi	a4,a4,-1774 # ffffffffc0211540 <max_swap_offset>
ffffffffc0203c36:	6318                	ld	a4,0(a4)
ffffffffc0203c38:	06e7f063          	bleu	a4,a5,ffffffffc0203c98 <swapfs_read+0x74>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203c3c:	0000e717          	auipc	a4,0xe
ffffffffc0203c40:	85c70713          	addi	a4,a4,-1956 # ffffffffc0211498 <pages>
ffffffffc0203c44:	6310                	ld	a2,0(a4)
ffffffffc0203c46:	00001717          	auipc	a4,0x1
ffffffffc0203c4a:	02a70713          	addi	a4,a4,42 # ffffffffc0204c70 <commands+0x838>
ffffffffc0203c4e:	00002697          	auipc	a3,0x2
ffffffffc0203c52:	4b268693          	addi	a3,a3,1202 # ffffffffc0206100 <nbase>
ffffffffc0203c56:	40c58633          	sub	a2,a1,a2
ffffffffc0203c5a:	630c                	ld	a1,0(a4)
ffffffffc0203c5c:	860d                	srai	a2,a2,0x3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c5e:	0000d717          	auipc	a4,0xd
ffffffffc0203c62:	7fa70713          	addi	a4,a4,2042 # ffffffffc0211458 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203c66:	02b60633          	mul	a2,a2,a1
ffffffffc0203c6a:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203c6e:	629c                	ld	a5,0(a3)
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c70:	6318                	ld	a4,0(a4)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203c72:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c74:	57fd                	li	a5,-1
ffffffffc0203c76:	83b1                	srli	a5,a5,0xc
ffffffffc0203c78:	8ff1                	and	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0203c7a:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203c7c:	02e7fa63          	bleu	a4,a5,ffffffffc0203cb0 <swapfs_read+0x8c>
ffffffffc0203c80:	0000e797          	auipc	a5,0xe
ffffffffc0203c84:	80878793          	addi	a5,a5,-2040 # ffffffffc0211488 <va_pa_offset>
ffffffffc0203c88:	639c                	ld	a5,0(a5)
}
ffffffffc0203c8a:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203c8c:	46a1                	li	a3,8
ffffffffc0203c8e:	963e                	add	a2,a2,a5
ffffffffc0203c90:	4505                	li	a0,1
}
ffffffffc0203c92:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203c94:	f4efc06f          	j	ffffffffc02003e2 <ide_read_secs>
ffffffffc0203c98:	86aa                	mv	a3,a0
ffffffffc0203c9a:	00002617          	auipc	a2,0x2
ffffffffc0203c9e:	1fe60613          	addi	a2,a2,510 # ffffffffc0205e98 <default_pmm_manager+0x148>
ffffffffc0203ca2:	45d1                	li	a1,20
ffffffffc0203ca4:	00002517          	auipc	a0,0x2
ffffffffc0203ca8:	1dc50513          	addi	a0,a0,476 # ffffffffc0205e80 <default_pmm_manager+0x130>
ffffffffc0203cac:	c5afc0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0203cb0:	86b2                	mv	a3,a2
ffffffffc0203cb2:	06a00593          	li	a1,106
ffffffffc0203cb6:	00001617          	auipc	a2,0x1
ffffffffc0203cba:	fc260613          	addi	a2,a2,-62 # ffffffffc0204c78 <commands+0x840>
ffffffffc0203cbe:	00001517          	auipc	a0,0x1
ffffffffc0203cc2:	05250513          	addi	a0,a0,82 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc0203cc6:	c40fc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203cca <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0203cca:	1141                	addi	sp,sp,-16
ffffffffc0203ccc:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203cce:	00855793          	srli	a5,a0,0x8
ffffffffc0203cd2:	c7b5                	beqz	a5,ffffffffc0203d3e <swapfs_write+0x74>
ffffffffc0203cd4:	0000e717          	auipc	a4,0xe
ffffffffc0203cd8:	86c70713          	addi	a4,a4,-1940 # ffffffffc0211540 <max_swap_offset>
ffffffffc0203cdc:	6318                	ld	a4,0(a4)
ffffffffc0203cde:	06e7f063          	bleu	a4,a5,ffffffffc0203d3e <swapfs_write+0x74>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203ce2:	0000d717          	auipc	a4,0xd
ffffffffc0203ce6:	7b670713          	addi	a4,a4,1974 # ffffffffc0211498 <pages>
ffffffffc0203cea:	6310                	ld	a2,0(a4)
ffffffffc0203cec:	00001717          	auipc	a4,0x1
ffffffffc0203cf0:	f8470713          	addi	a4,a4,-124 # ffffffffc0204c70 <commands+0x838>
ffffffffc0203cf4:	00002697          	auipc	a3,0x2
ffffffffc0203cf8:	40c68693          	addi	a3,a3,1036 # ffffffffc0206100 <nbase>
ffffffffc0203cfc:	40c58633          	sub	a2,a1,a2
ffffffffc0203d00:	630c                	ld	a1,0(a4)
ffffffffc0203d02:	860d                	srai	a2,a2,0x3
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203d04:	0000d717          	auipc	a4,0xd
ffffffffc0203d08:	75470713          	addi	a4,a4,1876 # ffffffffc0211458 <npage>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203d0c:	02b60633          	mul	a2,a2,a1
ffffffffc0203d10:	0037959b          	slliw	a1,a5,0x3
ffffffffc0203d14:	629c                	ld	a5,0(a3)
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203d16:	6318                	ld	a4,0(a4)
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0203d18:	963e                	add	a2,a2,a5
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203d1a:	57fd                	li	a5,-1
ffffffffc0203d1c:	83b1                	srli	a5,a5,0xc
ffffffffc0203d1e:	8ff1                	and	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0203d20:	0632                	slli	a2,a2,0xc
static inline void *page2kva(struct Page *page) { return KADDR(page2pa(page)); }
ffffffffc0203d22:	02e7fa63          	bleu	a4,a5,ffffffffc0203d56 <swapfs_write+0x8c>
ffffffffc0203d26:	0000d797          	auipc	a5,0xd
ffffffffc0203d2a:	76278793          	addi	a5,a5,1890 # ffffffffc0211488 <va_pa_offset>
ffffffffc0203d2e:	639c                	ld	a5,0(a5)
}
ffffffffc0203d30:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203d32:	46a1                	li	a3,8
ffffffffc0203d34:	963e                	add	a2,a2,a5
ffffffffc0203d36:	4505                	li	a0,1
}
ffffffffc0203d38:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0203d3a:	eccfc06f          	j	ffffffffc0200406 <ide_write_secs>
ffffffffc0203d3e:	86aa                	mv	a3,a0
ffffffffc0203d40:	00002617          	auipc	a2,0x2
ffffffffc0203d44:	15860613          	addi	a2,a2,344 # ffffffffc0205e98 <default_pmm_manager+0x148>
ffffffffc0203d48:	45e5                	li	a1,25
ffffffffc0203d4a:	00002517          	auipc	a0,0x2
ffffffffc0203d4e:	13650513          	addi	a0,a0,310 # ffffffffc0205e80 <default_pmm_manager+0x130>
ffffffffc0203d52:	bb4fc0ef          	jal	ra,ffffffffc0200106 <__panic>
ffffffffc0203d56:	86b2                	mv	a3,a2
ffffffffc0203d58:	06a00593          	li	a1,106
ffffffffc0203d5c:	00001617          	auipc	a2,0x1
ffffffffc0203d60:	f1c60613          	addi	a2,a2,-228 # ffffffffc0204c78 <commands+0x840>
ffffffffc0203d64:	00001517          	auipc	a0,0x1
ffffffffc0203d68:	fac50513          	addi	a0,a0,-84 # ffffffffc0204d10 <commands+0x8d8>
ffffffffc0203d6c:	b9afc0ef          	jal	ra,ffffffffc0200106 <__panic>

ffffffffc0203d70 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203d70:	00054783          	lbu	a5,0(a0)
ffffffffc0203d74:	cb91                	beqz	a5,ffffffffc0203d88 <strlen+0x18>
    size_t cnt = 0;
ffffffffc0203d76:	4781                	li	a5,0
        cnt ++;
ffffffffc0203d78:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc0203d7a:	00f50733          	add	a4,a0,a5
ffffffffc0203d7e:	00074703          	lbu	a4,0(a4)
ffffffffc0203d82:	fb7d                	bnez	a4,ffffffffc0203d78 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0203d84:	853e                	mv	a0,a5
ffffffffc0203d86:	8082                	ret
    size_t cnt = 0;
ffffffffc0203d88:	4781                	li	a5,0
}
ffffffffc0203d8a:	853e                	mv	a0,a5
ffffffffc0203d8c:	8082                	ret

ffffffffc0203d8e <strnlen>:
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203d8e:	c185                	beqz	a1,ffffffffc0203dae <strnlen+0x20>
ffffffffc0203d90:	00054783          	lbu	a5,0(a0)
ffffffffc0203d94:	cf89                	beqz	a5,ffffffffc0203dae <strnlen+0x20>
    size_t cnt = 0;
ffffffffc0203d96:	4781                	li	a5,0
ffffffffc0203d98:	a021                	j	ffffffffc0203da0 <strnlen+0x12>
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203d9a:	00074703          	lbu	a4,0(a4)
ffffffffc0203d9e:	c711                	beqz	a4,ffffffffc0203daa <strnlen+0x1c>
        cnt ++;
ffffffffc0203da0:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203da2:	00f50733          	add	a4,a0,a5
ffffffffc0203da6:	fef59ae3          	bne	a1,a5,ffffffffc0203d9a <strnlen+0xc>
    }
    return cnt;
}
ffffffffc0203daa:	853e                	mv	a0,a5
ffffffffc0203dac:	8082                	ret
    size_t cnt = 0;
ffffffffc0203dae:	4781                	li	a5,0
}
ffffffffc0203db0:	853e                	mv	a0,a5
ffffffffc0203db2:	8082                	ret

ffffffffc0203db4 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203db4:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203db6:	0585                	addi	a1,a1,1
ffffffffc0203db8:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203dbc:	0785                	addi	a5,a5,1
ffffffffc0203dbe:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203dc2:	fb75                	bnez	a4,ffffffffc0203db6 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203dc4:	8082                	ret

ffffffffc0203dc6 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203dc6:	00054783          	lbu	a5,0(a0)
ffffffffc0203dca:	0005c703          	lbu	a4,0(a1)
ffffffffc0203dce:	cb91                	beqz	a5,ffffffffc0203de2 <strcmp+0x1c>
ffffffffc0203dd0:	00e79c63          	bne	a5,a4,ffffffffc0203de8 <strcmp+0x22>
        s1 ++, s2 ++;
ffffffffc0203dd4:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203dd6:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
ffffffffc0203dda:	0585                	addi	a1,a1,1
ffffffffc0203ddc:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203de0:	fbe5                	bnez	a5,ffffffffc0203dd0 <strcmp+0xa>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203de2:	4501                	li	a0,0
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203de4:	9d19                	subw	a0,a0,a4
ffffffffc0203de6:	8082                	ret
ffffffffc0203de8:	0007851b          	sext.w	a0,a5
ffffffffc0203dec:	9d19                	subw	a0,a0,a4
ffffffffc0203dee:	8082                	ret

ffffffffc0203df0 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203df0:	00054783          	lbu	a5,0(a0)
ffffffffc0203df4:	cb91                	beqz	a5,ffffffffc0203e08 <strchr+0x18>
        if (*s == c) {
ffffffffc0203df6:	00b79563          	bne	a5,a1,ffffffffc0203e00 <strchr+0x10>
ffffffffc0203dfa:	a809                	j	ffffffffc0203e0c <strchr+0x1c>
ffffffffc0203dfc:	00b78763          	beq	a5,a1,ffffffffc0203e0a <strchr+0x1a>
            return (char *)s;
        }
        s ++;
ffffffffc0203e00:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203e02:	00054783          	lbu	a5,0(a0)
ffffffffc0203e06:	fbfd                	bnez	a5,ffffffffc0203dfc <strchr+0xc>
    }
    return NULL;
ffffffffc0203e08:	4501                	li	a0,0
}
ffffffffc0203e0a:	8082                	ret
ffffffffc0203e0c:	8082                	ret

ffffffffc0203e0e <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203e0e:	ca01                	beqz	a2,ffffffffc0203e1e <memset+0x10>
ffffffffc0203e10:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203e12:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203e14:	0785                	addi	a5,a5,1
ffffffffc0203e16:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203e1a:	fec79de3          	bne	a5,a2,ffffffffc0203e14 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203e1e:	8082                	ret

ffffffffc0203e20 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203e20:	ca19                	beqz	a2,ffffffffc0203e36 <memcpy+0x16>
ffffffffc0203e22:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203e24:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203e26:	0585                	addi	a1,a1,1
ffffffffc0203e28:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203e2c:	0785                	addi	a5,a5,1
ffffffffc0203e2e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203e32:	fec59ae3          	bne	a1,a2,ffffffffc0203e26 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203e36:	8082                	ret

ffffffffc0203e38 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203e38:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203e3c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203e3e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203e42:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203e44:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203e48:	f022                	sd	s0,32(sp)
ffffffffc0203e4a:	ec26                	sd	s1,24(sp)
ffffffffc0203e4c:	e84a                	sd	s2,16(sp)
ffffffffc0203e4e:	f406                	sd	ra,40(sp)
ffffffffc0203e50:	e44e                	sd	s3,8(sp)
ffffffffc0203e52:	84aa                	mv	s1,a0
ffffffffc0203e54:	892e                	mv	s2,a1
ffffffffc0203e56:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203e5a:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
ffffffffc0203e5c:	03067e63          	bleu	a6,a2,ffffffffc0203e98 <printnum+0x60>
ffffffffc0203e60:	89be                	mv	s3,a5
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203e62:	00805763          	blez	s0,ffffffffc0203e70 <printnum+0x38>
ffffffffc0203e66:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203e68:	85ca                	mv	a1,s2
ffffffffc0203e6a:	854e                	mv	a0,s3
ffffffffc0203e6c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203e6e:	fc65                	bnez	s0,ffffffffc0203e66 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203e70:	1a02                	slli	s4,s4,0x20
ffffffffc0203e72:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203e76:	00002797          	auipc	a5,0x2
ffffffffc0203e7a:	1d278793          	addi	a5,a5,466 # ffffffffc0206048 <error_string+0x38>
ffffffffc0203e7e:	9a3e                	add	s4,s4,a5
}
ffffffffc0203e80:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203e82:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203e86:	70a2                	ld	ra,40(sp)
ffffffffc0203e88:	69a2                	ld	s3,8(sp)
ffffffffc0203e8a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203e8c:	85ca                	mv	a1,s2
ffffffffc0203e8e:	8326                	mv	t1,s1
}
ffffffffc0203e90:	6942                	ld	s2,16(sp)
ffffffffc0203e92:	64e2                	ld	s1,24(sp)
ffffffffc0203e94:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203e96:	8302                	jr	t1
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203e98:	03065633          	divu	a2,a2,a6
ffffffffc0203e9c:	8722                	mv	a4,s0
ffffffffc0203e9e:	f9bff0ef          	jal	ra,ffffffffc0203e38 <printnum>
ffffffffc0203ea2:	b7f9                	j	ffffffffc0203e70 <printnum+0x38>

ffffffffc0203ea4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203ea4:	7119                	addi	sp,sp,-128
ffffffffc0203ea6:	f4a6                	sd	s1,104(sp)
ffffffffc0203ea8:	f0ca                	sd	s2,96(sp)
ffffffffc0203eaa:	e8d2                	sd	s4,80(sp)
ffffffffc0203eac:	e4d6                	sd	s5,72(sp)
ffffffffc0203eae:	e0da                	sd	s6,64(sp)
ffffffffc0203eb0:	fc5e                	sd	s7,56(sp)
ffffffffc0203eb2:	f862                	sd	s8,48(sp)
ffffffffc0203eb4:	f06a                	sd	s10,32(sp)
ffffffffc0203eb6:	fc86                	sd	ra,120(sp)
ffffffffc0203eb8:	f8a2                	sd	s0,112(sp)
ffffffffc0203eba:	ecce                	sd	s3,88(sp)
ffffffffc0203ebc:	f466                	sd	s9,40(sp)
ffffffffc0203ebe:	ec6e                	sd	s11,24(sp)
ffffffffc0203ec0:	892a                	mv	s2,a0
ffffffffc0203ec2:	84ae                	mv	s1,a1
ffffffffc0203ec4:	8d32                	mv	s10,a2
ffffffffc0203ec6:	8ab6                	mv	s5,a3
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0203ec8:	5b7d                	li	s6,-1
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203eca:	00002a17          	auipc	s4,0x2
ffffffffc0203ece:	feea0a13          	addi	s4,s4,-18 # ffffffffc0205eb8 <default_pmm_manager+0x168>
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203ed2:	05e00b93          	li	s7,94
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203ed6:	00002c17          	auipc	s8,0x2
ffffffffc0203eda:	13ac0c13          	addi	s8,s8,314 # ffffffffc0206010 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203ede:	000d4503          	lbu	a0,0(s10)
ffffffffc0203ee2:	02500793          	li	a5,37
ffffffffc0203ee6:	001d0413          	addi	s0,s10,1
ffffffffc0203eea:	00f50e63          	beq	a0,a5,ffffffffc0203f06 <vprintfmt+0x62>
            if (ch == '\0') {
ffffffffc0203eee:	c521                	beqz	a0,ffffffffc0203f36 <vprintfmt+0x92>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203ef0:	02500993          	li	s3,37
ffffffffc0203ef4:	a011                	j	ffffffffc0203ef8 <vprintfmt+0x54>
            if (ch == '\0') {
ffffffffc0203ef6:	c121                	beqz	a0,ffffffffc0203f36 <vprintfmt+0x92>
            putch(ch, putdat);
ffffffffc0203ef8:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203efa:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203efc:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203efe:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203f02:	ff351ae3          	bne	a0,s3,ffffffffc0203ef6 <vprintfmt+0x52>
ffffffffc0203f06:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203f0a:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203f0e:	4981                	li	s3,0
ffffffffc0203f10:	4801                	li	a6,0
        width = precision = -1;
ffffffffc0203f12:	5cfd                	li	s9,-1
ffffffffc0203f14:	5dfd                	li	s11,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f16:	05500593          	li	a1,85
                if (ch < '0' || ch > '9') {
ffffffffc0203f1a:	4525                	li	a0,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f1c:	fdd6069b          	addiw	a3,a2,-35
ffffffffc0203f20:	0ff6f693          	andi	a3,a3,255
ffffffffc0203f24:	00140d13          	addi	s10,s0,1
ffffffffc0203f28:	20d5e563          	bltu	a1,a3,ffffffffc0204132 <vprintfmt+0x28e>
ffffffffc0203f2c:	068a                	slli	a3,a3,0x2
ffffffffc0203f2e:	96d2                	add	a3,a3,s4
ffffffffc0203f30:	4294                	lw	a3,0(a3)
ffffffffc0203f32:	96d2                	add	a3,a3,s4
ffffffffc0203f34:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203f36:	70e6                	ld	ra,120(sp)
ffffffffc0203f38:	7446                	ld	s0,112(sp)
ffffffffc0203f3a:	74a6                	ld	s1,104(sp)
ffffffffc0203f3c:	7906                	ld	s2,96(sp)
ffffffffc0203f3e:	69e6                	ld	s3,88(sp)
ffffffffc0203f40:	6a46                	ld	s4,80(sp)
ffffffffc0203f42:	6aa6                	ld	s5,72(sp)
ffffffffc0203f44:	6b06                	ld	s6,64(sp)
ffffffffc0203f46:	7be2                	ld	s7,56(sp)
ffffffffc0203f48:	7c42                	ld	s8,48(sp)
ffffffffc0203f4a:	7ca2                	ld	s9,40(sp)
ffffffffc0203f4c:	7d02                	ld	s10,32(sp)
ffffffffc0203f4e:	6de2                	ld	s11,24(sp)
ffffffffc0203f50:	6109                	addi	sp,sp,128
ffffffffc0203f52:	8082                	ret
    if (lflag >= 2) {
ffffffffc0203f54:	4705                	li	a4,1
ffffffffc0203f56:	008a8593          	addi	a1,s5,8
ffffffffc0203f5a:	01074463          	blt	a4,a6,ffffffffc0203f62 <vprintfmt+0xbe>
    else if (lflag) {
ffffffffc0203f5e:	26080363          	beqz	a6,ffffffffc02041c4 <vprintfmt+0x320>
        return va_arg(*ap, unsigned long);
ffffffffc0203f62:	000ab603          	ld	a2,0(s5)
ffffffffc0203f66:	46c1                	li	a3,16
ffffffffc0203f68:	8aae                	mv	s5,a1
ffffffffc0203f6a:	a06d                	j	ffffffffc0204014 <vprintfmt+0x170>
            goto reswitch;
ffffffffc0203f6c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0203f70:	4985                	li	s3,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203f72:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203f74:	b765                	j	ffffffffc0203f1c <vprintfmt+0x78>
            putch(va_arg(ap, int), putdat);
ffffffffc0203f76:	000aa503          	lw	a0,0(s5)
ffffffffc0203f7a:	85a6                	mv	a1,s1
ffffffffc0203f7c:	0aa1                	addi	s5,s5,8
ffffffffc0203f7e:	9902                	jalr	s2
            break;
ffffffffc0203f80:	bfb9                	j	ffffffffc0203ede <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203f82:	4705                	li	a4,1
ffffffffc0203f84:	008a8993          	addi	s3,s5,8
ffffffffc0203f88:	01074463          	blt	a4,a6,ffffffffc0203f90 <vprintfmt+0xec>
    else if (lflag) {
ffffffffc0203f8c:	22080463          	beqz	a6,ffffffffc02041b4 <vprintfmt+0x310>
        return va_arg(*ap, long);
ffffffffc0203f90:	000ab403          	ld	s0,0(s5)
            if ((long long)num < 0) {
ffffffffc0203f94:	24044463          	bltz	s0,ffffffffc02041dc <vprintfmt+0x338>
            num = getint(&ap, lflag);
ffffffffc0203f98:	8622                	mv	a2,s0
ffffffffc0203f9a:	8ace                	mv	s5,s3
ffffffffc0203f9c:	46a9                	li	a3,10
ffffffffc0203f9e:	a89d                	j	ffffffffc0204014 <vprintfmt+0x170>
            err = va_arg(ap, int);
ffffffffc0203fa0:	000aa783          	lw	a5,0(s5)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203fa4:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0203fa6:	0aa1                	addi	s5,s5,8
            if (err < 0) {
ffffffffc0203fa8:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203fac:	8fb5                	xor	a5,a5,a3
ffffffffc0203fae:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203fb2:	1ad74363          	blt	a4,a3,ffffffffc0204158 <vprintfmt+0x2b4>
ffffffffc0203fb6:	00369793          	slli	a5,a3,0x3
ffffffffc0203fba:	97e2                	add	a5,a5,s8
ffffffffc0203fbc:	639c                	ld	a5,0(a5)
ffffffffc0203fbe:	18078d63          	beqz	a5,ffffffffc0204158 <vprintfmt+0x2b4>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203fc2:	86be                	mv	a3,a5
ffffffffc0203fc4:	00002617          	auipc	a2,0x2
ffffffffc0203fc8:	13460613          	addi	a2,a2,308 # ffffffffc02060f8 <error_string+0xe8>
ffffffffc0203fcc:	85a6                	mv	a1,s1
ffffffffc0203fce:	854a                	mv	a0,s2
ffffffffc0203fd0:	240000ef          	jal	ra,ffffffffc0204210 <printfmt>
ffffffffc0203fd4:	b729                	j	ffffffffc0203ede <vprintfmt+0x3a>
            lflag ++;
ffffffffc0203fd6:	00144603          	lbu	a2,1(s0)
ffffffffc0203fda:	2805                	addiw	a6,a6,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203fdc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203fde:	bf3d                	j	ffffffffc0203f1c <vprintfmt+0x78>
    if (lflag >= 2) {
ffffffffc0203fe0:	4705                	li	a4,1
ffffffffc0203fe2:	008a8593          	addi	a1,s5,8
ffffffffc0203fe6:	01074463          	blt	a4,a6,ffffffffc0203fee <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0203fea:	1e080263          	beqz	a6,ffffffffc02041ce <vprintfmt+0x32a>
        return va_arg(*ap, unsigned long);
ffffffffc0203fee:	000ab603          	ld	a2,0(s5)
ffffffffc0203ff2:	46a1                	li	a3,8
ffffffffc0203ff4:	8aae                	mv	s5,a1
ffffffffc0203ff6:	a839                	j	ffffffffc0204014 <vprintfmt+0x170>
            putch('0', putdat);
ffffffffc0203ff8:	03000513          	li	a0,48
ffffffffc0203ffc:	85a6                	mv	a1,s1
ffffffffc0203ffe:	e03e                	sd	a5,0(sp)
ffffffffc0204000:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0204002:	85a6                	mv	a1,s1
ffffffffc0204004:	07800513          	li	a0,120
ffffffffc0204008:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020400a:	0aa1                	addi	s5,s5,8
ffffffffc020400c:	ff8ab603          	ld	a2,-8(s5)
            goto number;
ffffffffc0204010:	6782                	ld	a5,0(sp)
ffffffffc0204012:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204014:	876e                	mv	a4,s11
ffffffffc0204016:	85a6                	mv	a1,s1
ffffffffc0204018:	854a                	mv	a0,s2
ffffffffc020401a:	e1fff0ef          	jal	ra,ffffffffc0203e38 <printnum>
            break;
ffffffffc020401e:	b5c1                	j	ffffffffc0203ede <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204020:	000ab603          	ld	a2,0(s5)
ffffffffc0204024:	0aa1                	addi	s5,s5,8
ffffffffc0204026:	1c060663          	beqz	a2,ffffffffc02041f2 <vprintfmt+0x34e>
            if (width > 0 && padc != '-') {
ffffffffc020402a:	00160413          	addi	s0,a2,1
ffffffffc020402e:	17b05c63          	blez	s11,ffffffffc02041a6 <vprintfmt+0x302>
ffffffffc0204032:	02d00593          	li	a1,45
ffffffffc0204036:	14b79263          	bne	a5,a1,ffffffffc020417a <vprintfmt+0x2d6>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020403a:	00064783          	lbu	a5,0(a2)
ffffffffc020403e:	0007851b          	sext.w	a0,a5
ffffffffc0204042:	c905                	beqz	a0,ffffffffc0204072 <vprintfmt+0x1ce>
ffffffffc0204044:	000cc563          	bltz	s9,ffffffffc020404e <vprintfmt+0x1aa>
ffffffffc0204048:	3cfd                	addiw	s9,s9,-1
ffffffffc020404a:	036c8263          	beq	s9,s6,ffffffffc020406e <vprintfmt+0x1ca>
                    putch('?', putdat);
ffffffffc020404e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204050:	18098463          	beqz	s3,ffffffffc02041d8 <vprintfmt+0x334>
ffffffffc0204054:	3781                	addiw	a5,a5,-32
ffffffffc0204056:	18fbf163          	bleu	a5,s7,ffffffffc02041d8 <vprintfmt+0x334>
                    putch('?', putdat);
ffffffffc020405a:	03f00513          	li	a0,63
ffffffffc020405e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204060:	0405                	addi	s0,s0,1
ffffffffc0204062:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204066:	3dfd                	addiw	s11,s11,-1
ffffffffc0204068:	0007851b          	sext.w	a0,a5
ffffffffc020406c:	fd61                	bnez	a0,ffffffffc0204044 <vprintfmt+0x1a0>
            for (; width > 0; width --) {
ffffffffc020406e:	e7b058e3          	blez	s11,ffffffffc0203ede <vprintfmt+0x3a>
ffffffffc0204072:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204074:	85a6                	mv	a1,s1
ffffffffc0204076:	02000513          	li	a0,32
ffffffffc020407a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020407c:	e60d81e3          	beqz	s11,ffffffffc0203ede <vprintfmt+0x3a>
ffffffffc0204080:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204082:	85a6                	mv	a1,s1
ffffffffc0204084:	02000513          	li	a0,32
ffffffffc0204088:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020408a:	fe0d94e3          	bnez	s11,ffffffffc0204072 <vprintfmt+0x1ce>
ffffffffc020408e:	bd81                	j	ffffffffc0203ede <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204090:	4705                	li	a4,1
ffffffffc0204092:	008a8593          	addi	a1,s5,8
ffffffffc0204096:	01074463          	blt	a4,a6,ffffffffc020409e <vprintfmt+0x1fa>
    else if (lflag) {
ffffffffc020409a:	12080063          	beqz	a6,ffffffffc02041ba <vprintfmt+0x316>
        return va_arg(*ap, unsigned long);
ffffffffc020409e:	000ab603          	ld	a2,0(s5)
ffffffffc02040a2:	46a9                	li	a3,10
ffffffffc02040a4:	8aae                	mv	s5,a1
ffffffffc02040a6:	b7bd                	j	ffffffffc0204014 <vprintfmt+0x170>
ffffffffc02040a8:	00144603          	lbu	a2,1(s0)
            padc = '-';
ffffffffc02040ac:	02d00793          	li	a5,45
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040b0:	846a                	mv	s0,s10
ffffffffc02040b2:	b5ad                	j	ffffffffc0203f1c <vprintfmt+0x78>
            putch(ch, putdat);
ffffffffc02040b4:	85a6                	mv	a1,s1
ffffffffc02040b6:	02500513          	li	a0,37
ffffffffc02040ba:	9902                	jalr	s2
            break;
ffffffffc02040bc:	b50d                	j	ffffffffc0203ede <vprintfmt+0x3a>
            precision = va_arg(ap, int);
ffffffffc02040be:	000aac83          	lw	s9,0(s5)
            goto process_precision;
ffffffffc02040c2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02040c6:	0aa1                	addi	s5,s5,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040c8:	846a                	mv	s0,s10
            if (width < 0)
ffffffffc02040ca:	e40dd9e3          	bgez	s11,ffffffffc0203f1c <vprintfmt+0x78>
                width = precision, precision = -1;
ffffffffc02040ce:	8de6                	mv	s11,s9
ffffffffc02040d0:	5cfd                	li	s9,-1
ffffffffc02040d2:	b5a9                	j	ffffffffc0203f1c <vprintfmt+0x78>
            goto reswitch;
ffffffffc02040d4:	00144603          	lbu	a2,1(s0)
            padc = '0';
ffffffffc02040d8:	03000793          	li	a5,48
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040dc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02040de:	bd3d                	j	ffffffffc0203f1c <vprintfmt+0x78>
                precision = precision * 10 + ch - '0';
ffffffffc02040e0:	fd060c9b          	addiw	s9,a2,-48
                ch = *fmt;
ffffffffc02040e4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02040e8:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02040ea:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02040ee:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc02040f2:	fcd56ce3          	bltu	a0,a3,ffffffffc02040ca <vprintfmt+0x226>
            for (precision = 0; ; ++ fmt) {
ffffffffc02040f6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02040f8:	002c969b          	slliw	a3,s9,0x2
                ch = *fmt;
ffffffffc02040fc:	00044603          	lbu	a2,0(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204100:	0196873b          	addw	a4,a3,s9
ffffffffc0204104:	0017171b          	slliw	a4,a4,0x1
ffffffffc0204108:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
ffffffffc020410c:	fd06069b          	addiw	a3,a2,-48
                precision = precision * 10 + ch - '0';
ffffffffc0204110:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0204114:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204118:	fcd57fe3          	bleu	a3,a0,ffffffffc02040f6 <vprintfmt+0x252>
ffffffffc020411c:	b77d                	j	ffffffffc02040ca <vprintfmt+0x226>
            if (width < 0)
ffffffffc020411e:	fffdc693          	not	a3,s11
ffffffffc0204122:	96fd                	srai	a3,a3,0x3f
ffffffffc0204124:	00ddfdb3          	and	s11,s11,a3
ffffffffc0204128:	00144603          	lbu	a2,1(s0)
ffffffffc020412c:	2d81                	sext.w	s11,s11
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020412e:	846a                	mv	s0,s10
ffffffffc0204130:	b3f5                	j	ffffffffc0203f1c <vprintfmt+0x78>
            putch('%', putdat);
ffffffffc0204132:	85a6                	mv	a1,s1
ffffffffc0204134:	02500513          	li	a0,37
ffffffffc0204138:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020413a:	fff44703          	lbu	a4,-1(s0)
ffffffffc020413e:	02500793          	li	a5,37
ffffffffc0204142:	8d22                	mv	s10,s0
ffffffffc0204144:	d8f70de3          	beq	a4,a5,ffffffffc0203ede <vprintfmt+0x3a>
ffffffffc0204148:	02500713          	li	a4,37
ffffffffc020414c:	1d7d                	addi	s10,s10,-1
ffffffffc020414e:	fffd4783          	lbu	a5,-1(s10)
ffffffffc0204152:	fee79de3          	bne	a5,a4,ffffffffc020414c <vprintfmt+0x2a8>
ffffffffc0204156:	b361                	j	ffffffffc0203ede <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204158:	00002617          	auipc	a2,0x2
ffffffffc020415c:	f9060613          	addi	a2,a2,-112 # ffffffffc02060e8 <error_string+0xd8>
ffffffffc0204160:	85a6                	mv	a1,s1
ffffffffc0204162:	854a                	mv	a0,s2
ffffffffc0204164:	0ac000ef          	jal	ra,ffffffffc0204210 <printfmt>
ffffffffc0204168:	bb9d                	j	ffffffffc0203ede <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020416a:	00002617          	auipc	a2,0x2
ffffffffc020416e:	f7660613          	addi	a2,a2,-138 # ffffffffc02060e0 <error_string+0xd0>
            if (width > 0 && padc != '-') {
ffffffffc0204172:	00002417          	auipc	s0,0x2
ffffffffc0204176:	f6f40413          	addi	s0,s0,-145 # ffffffffc02060e1 <error_string+0xd1>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020417a:	8532                	mv	a0,a2
ffffffffc020417c:	85e6                	mv	a1,s9
ffffffffc020417e:	e032                	sd	a2,0(sp)
ffffffffc0204180:	e43e                	sd	a5,8(sp)
ffffffffc0204182:	c0dff0ef          	jal	ra,ffffffffc0203d8e <strnlen>
ffffffffc0204186:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020418a:	6602                	ld	a2,0(sp)
ffffffffc020418c:	01b05d63          	blez	s11,ffffffffc02041a6 <vprintfmt+0x302>
ffffffffc0204190:	67a2                	ld	a5,8(sp)
ffffffffc0204192:	2781                	sext.w	a5,a5
ffffffffc0204194:	e43e                	sd	a5,8(sp)
                    putch(padc, putdat);
ffffffffc0204196:	6522                	ld	a0,8(sp)
ffffffffc0204198:	85a6                	mv	a1,s1
ffffffffc020419a:	e032                	sd	a2,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020419c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020419e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02041a0:	6602                	ld	a2,0(sp)
ffffffffc02041a2:	fe0d9ae3          	bnez	s11,ffffffffc0204196 <vprintfmt+0x2f2>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02041a6:	00064783          	lbu	a5,0(a2)
ffffffffc02041aa:	0007851b          	sext.w	a0,a5
ffffffffc02041ae:	e8051be3          	bnez	a0,ffffffffc0204044 <vprintfmt+0x1a0>
ffffffffc02041b2:	b335                	j	ffffffffc0203ede <vprintfmt+0x3a>
        return va_arg(*ap, int);
ffffffffc02041b4:	000aa403          	lw	s0,0(s5)
ffffffffc02041b8:	bbf1                	j	ffffffffc0203f94 <vprintfmt+0xf0>
        return va_arg(*ap, unsigned int);
ffffffffc02041ba:	000ae603          	lwu	a2,0(s5)
ffffffffc02041be:	46a9                	li	a3,10
ffffffffc02041c0:	8aae                	mv	s5,a1
ffffffffc02041c2:	bd89                	j	ffffffffc0204014 <vprintfmt+0x170>
ffffffffc02041c4:	000ae603          	lwu	a2,0(s5)
ffffffffc02041c8:	46c1                	li	a3,16
ffffffffc02041ca:	8aae                	mv	s5,a1
ffffffffc02041cc:	b5a1                	j	ffffffffc0204014 <vprintfmt+0x170>
ffffffffc02041ce:	000ae603          	lwu	a2,0(s5)
ffffffffc02041d2:	46a1                	li	a3,8
ffffffffc02041d4:	8aae                	mv	s5,a1
ffffffffc02041d6:	bd3d                	j	ffffffffc0204014 <vprintfmt+0x170>
                    putch(ch, putdat);
ffffffffc02041d8:	9902                	jalr	s2
ffffffffc02041da:	b559                	j	ffffffffc0204060 <vprintfmt+0x1bc>
                putch('-', putdat);
ffffffffc02041dc:	85a6                	mv	a1,s1
ffffffffc02041de:	02d00513          	li	a0,45
ffffffffc02041e2:	e03e                	sd	a5,0(sp)
ffffffffc02041e4:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02041e6:	8ace                	mv	s5,s3
ffffffffc02041e8:	40800633          	neg	a2,s0
ffffffffc02041ec:	46a9                	li	a3,10
ffffffffc02041ee:	6782                	ld	a5,0(sp)
ffffffffc02041f0:	b515                	j	ffffffffc0204014 <vprintfmt+0x170>
            if (width > 0 && padc != '-') {
ffffffffc02041f2:	01b05663          	blez	s11,ffffffffc02041fe <vprintfmt+0x35a>
ffffffffc02041f6:	02d00693          	li	a3,45
ffffffffc02041fa:	f6d798e3          	bne	a5,a3,ffffffffc020416a <vprintfmt+0x2c6>
ffffffffc02041fe:	00002417          	auipc	s0,0x2
ffffffffc0204202:	ee340413          	addi	s0,s0,-285 # ffffffffc02060e1 <error_string+0xd1>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204206:	02800513          	li	a0,40
ffffffffc020420a:	02800793          	li	a5,40
ffffffffc020420e:	bd1d                	j	ffffffffc0204044 <vprintfmt+0x1a0>

ffffffffc0204210 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204210:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204212:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204216:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204218:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020421a:	ec06                	sd	ra,24(sp)
ffffffffc020421c:	f83a                	sd	a4,48(sp)
ffffffffc020421e:	fc3e                	sd	a5,56(sp)
ffffffffc0204220:	e0c2                	sd	a6,64(sp)
ffffffffc0204222:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204224:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204226:	c7fff0ef          	jal	ra,ffffffffc0203ea4 <vprintfmt>
}
ffffffffc020422a:	60e2                	ld	ra,24(sp)
ffffffffc020422c:	6161                	addi	sp,sp,80
ffffffffc020422e:	8082                	ret

ffffffffc0204230 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0204230:	715d                	addi	sp,sp,-80
ffffffffc0204232:	e486                	sd	ra,72(sp)
ffffffffc0204234:	e0a2                	sd	s0,64(sp)
ffffffffc0204236:	fc26                	sd	s1,56(sp)
ffffffffc0204238:	f84a                	sd	s2,48(sp)
ffffffffc020423a:	f44e                	sd	s3,40(sp)
ffffffffc020423c:	f052                	sd	s4,32(sp)
ffffffffc020423e:	ec56                	sd	s5,24(sp)
ffffffffc0204240:	e85a                	sd	s6,16(sp)
ffffffffc0204242:	e45e                	sd	s7,8(sp)
    if (prompt != NULL) {
ffffffffc0204244:	c901                	beqz	a0,ffffffffc0204254 <readline+0x24>
        cprintf("%s", prompt);
ffffffffc0204246:	85aa                	mv	a1,a0
ffffffffc0204248:	00002517          	auipc	a0,0x2
ffffffffc020424c:	eb050513          	addi	a0,a0,-336 # ffffffffc02060f8 <error_string+0xe8>
ffffffffc0204250:	e6ffb0ef          	jal	ra,ffffffffc02000be <cprintf>
readline(const char *prompt) {
ffffffffc0204254:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204256:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0204258:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc020425a:	4aa9                	li	s5,10
ffffffffc020425c:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc020425e:	0000db97          	auipc	s7,0xd
ffffffffc0204262:	de2b8b93          	addi	s7,s7,-542 # ffffffffc0211040 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204266:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc020426a:	e8dfb0ef          	jal	ra,ffffffffc02000f6 <getchar>
ffffffffc020426e:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0204270:	00054b63          	bltz	a0,ffffffffc0204286 <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0204274:	00a95b63          	ble	a0,s2,ffffffffc020428a <readline+0x5a>
ffffffffc0204278:	029a5463          	ble	s1,s4,ffffffffc02042a0 <readline+0x70>
        c = getchar();
ffffffffc020427c:	e7bfb0ef          	jal	ra,ffffffffc02000f6 <getchar>
ffffffffc0204280:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0204282:	fe0559e3          	bgez	a0,ffffffffc0204274 <readline+0x44>
            return NULL;
ffffffffc0204286:	4501                	li	a0,0
ffffffffc0204288:	a099                	j	ffffffffc02042ce <readline+0x9e>
        else if (c == '\b' && i > 0) {
ffffffffc020428a:	03341463          	bne	s0,s3,ffffffffc02042b2 <readline+0x82>
ffffffffc020428e:	e8b9                	bnez	s1,ffffffffc02042e4 <readline+0xb4>
        c = getchar();
ffffffffc0204290:	e67fb0ef          	jal	ra,ffffffffc02000f6 <getchar>
ffffffffc0204294:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0204296:	fe0548e3          	bltz	a0,ffffffffc0204286 <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020429a:	fea958e3          	ble	a0,s2,ffffffffc020428a <readline+0x5a>
ffffffffc020429e:	4481                	li	s1,0
            cputchar(c);
ffffffffc02042a0:	8522                	mv	a0,s0
ffffffffc02042a2:	e51fb0ef          	jal	ra,ffffffffc02000f2 <cputchar>
            buf[i ++] = c;
ffffffffc02042a6:	009b87b3          	add	a5,s7,s1
ffffffffc02042aa:	00878023          	sb	s0,0(a5)
ffffffffc02042ae:	2485                	addiw	s1,s1,1
ffffffffc02042b0:	bf6d                	j	ffffffffc020426a <readline+0x3a>
        else if (c == '\n' || c == '\r') {
ffffffffc02042b2:	01540463          	beq	s0,s5,ffffffffc02042ba <readline+0x8a>
ffffffffc02042b6:	fb641ae3          	bne	s0,s6,ffffffffc020426a <readline+0x3a>
            cputchar(c);
ffffffffc02042ba:	8522                	mv	a0,s0
ffffffffc02042bc:	e37fb0ef          	jal	ra,ffffffffc02000f2 <cputchar>
            buf[i] = '\0';
ffffffffc02042c0:	0000d517          	auipc	a0,0xd
ffffffffc02042c4:	d8050513          	addi	a0,a0,-640 # ffffffffc0211040 <buf>
ffffffffc02042c8:	94aa                	add	s1,s1,a0
ffffffffc02042ca:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02042ce:	60a6                	ld	ra,72(sp)
ffffffffc02042d0:	6406                	ld	s0,64(sp)
ffffffffc02042d2:	74e2                	ld	s1,56(sp)
ffffffffc02042d4:	7942                	ld	s2,48(sp)
ffffffffc02042d6:	79a2                	ld	s3,40(sp)
ffffffffc02042d8:	7a02                	ld	s4,32(sp)
ffffffffc02042da:	6ae2                	ld	s5,24(sp)
ffffffffc02042dc:	6b42                	ld	s6,16(sp)
ffffffffc02042de:	6ba2                	ld	s7,8(sp)
ffffffffc02042e0:	6161                	addi	sp,sp,80
ffffffffc02042e2:	8082                	ret
            cputchar(c);
ffffffffc02042e4:	4521                	li	a0,8
ffffffffc02042e6:	e0dfb0ef          	jal	ra,ffffffffc02000f2 <cputchar>
            i --;
ffffffffc02042ea:	34fd                	addiw	s1,s1,-1
ffffffffc02042ec:	bfbd                	j	ffffffffc020426a <readline+0x3a>
