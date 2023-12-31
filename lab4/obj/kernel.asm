
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc0200028:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc020002c:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200030:	03628293          	addi	t0,t0,54 # ffffffffc0200036 <kern_init>
    jr t0
ffffffffc0200034:	8282                	jr	t0

ffffffffc0200036 <kern_init>:
void grade_backtrace(void);

int
kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200036:	0000b517          	auipc	a0,0xb
ffffffffc020003a:	02a50513          	addi	a0,a0,42 # ffffffffc020b060 <edata>
ffffffffc020003e:	00016617          	auipc	a2,0x16
ffffffffc0200042:	5c260613          	addi	a2,a2,1474 # ffffffffc0216600 <end>
kern_init(void) {
ffffffffc0200046:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200048:	8e09                	sub	a2,a2,a0
ffffffffc020004a:	4581                	li	a1,0
kern_init(void) {
ffffffffc020004c:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004e:	243040ef          	jal	ra,ffffffffc0204a90 <memset>

    cons_init();                // init the console
ffffffffc0200052:	50c000ef          	jal	ra,ffffffffc020055e <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200056:	00005597          	auipc	a1,0x5
ffffffffc020005a:	eaa58593          	addi	a1,a1,-342 # ffffffffc0204f00 <etext+0x6>
ffffffffc020005e:	00005517          	auipc	a0,0x5
ffffffffc0200062:	ec250513          	addi	a0,a0,-318 # ffffffffc0204f20 <etext+0x26>
ffffffffc0200066:	06a000ef          	jal	ra,ffffffffc02000d0 <cprintf>

    print_kerninfo();
ffffffffc020006a:	1cc000ef          	jal	ra,ffffffffc0200236 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc020006e:	7c1000ef          	jal	ra,ffffffffc020102e <pmm_init>

    pic_init();                 // init interrupt controller
ffffffffc0200072:	560000ef          	jal	ra,ffffffffc02005d2 <pic_init>
    idt_init();                 // init interrupt descriptor table
ffffffffc0200076:	5dc000ef          	jal	ra,ffffffffc0200652 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020007a:	096020ef          	jal	ra,ffffffffc0202110 <vmm_init>
    proc_init();                // init process table
ffffffffc020007e:	698040ef          	jal	ra,ffffffffc0204716 <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc0200082:	42e000ef          	jal	ra,ffffffffc02004b0 <ide_init>
    swap_init();                // init swap
ffffffffc0200086:	367020ef          	jal	ra,ffffffffc0202bec <swap_init>

    clock_init();               // init clock interrupt
ffffffffc020008a:	47e000ef          	jal	ra,ffffffffc0200508 <clock_init>
    intr_enable();              // enable irq interrupt
ffffffffc020008e:	546000ef          	jal	ra,ffffffffc02005d4 <intr_enable>

    cpu_idle();                 // run idle process
ffffffffc0200092:	079040ef          	jal	ra,ffffffffc020490a <cpu_idle>

ffffffffc0200096 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200096:	1141                	addi	sp,sp,-16
ffffffffc0200098:	e022                	sd	s0,0(sp)
ffffffffc020009a:	e406                	sd	ra,8(sp)
ffffffffc020009c:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc020009e:	4c2000ef          	jal	ra,ffffffffc0200560 <cons_putc>
    (*cnt) ++;
ffffffffc02000a2:	401c                	lw	a5,0(s0)
}
ffffffffc02000a4:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc02000a6:	2785                	addiw	a5,a5,1
ffffffffc02000a8:	c01c                	sw	a5,0(s0)
}
ffffffffc02000aa:	6402                	ld	s0,0(sp)
ffffffffc02000ac:	0141                	addi	sp,sp,16
ffffffffc02000ae:	8082                	ret

ffffffffc02000b0 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000b0:	1101                	addi	sp,sp,-32
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000b2:	86ae                	mv	a3,a1
ffffffffc02000b4:	862a                	mv	a2,a0
ffffffffc02000b6:	006c                	addi	a1,sp,12
ffffffffc02000b8:	00000517          	auipc	a0,0x0
ffffffffc02000bc:	fde50513          	addi	a0,a0,-34 # ffffffffc0200096 <cputch>
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000c0:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000c2:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c4:	293040ef          	jal	ra,ffffffffc0204b56 <vprintfmt>
    return cnt;
}
ffffffffc02000c8:	60e2                	ld	ra,24(sp)
ffffffffc02000ca:	4532                	lw	a0,12(sp)
ffffffffc02000cc:	6105                	addi	sp,sp,32
ffffffffc02000ce:	8082                	ret

ffffffffc02000d0 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000d0:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000d2:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000d6:	f42e                	sd	a1,40(sp)
ffffffffc02000d8:	f832                	sd	a2,48(sp)
ffffffffc02000da:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000dc:	862a                	mv	a2,a0
ffffffffc02000de:	004c                	addi	a1,sp,4
ffffffffc02000e0:	00000517          	auipc	a0,0x0
ffffffffc02000e4:	fb650513          	addi	a0,a0,-74 # ffffffffc0200096 <cputch>
ffffffffc02000e8:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc02000ea:	ec06                	sd	ra,24(sp)
ffffffffc02000ec:	e0ba                	sd	a4,64(sp)
ffffffffc02000ee:	e4be                	sd	a5,72(sp)
ffffffffc02000f0:	e8c2                	sd	a6,80(sp)
ffffffffc02000f2:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000f4:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000f6:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000f8:	25f040ef          	jal	ra,ffffffffc0204b56 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000fc:	60e2                	ld	ra,24(sp)
ffffffffc02000fe:	4512                	lw	a0,4(sp)
ffffffffc0200100:	6125                	addi	sp,sp,96
ffffffffc0200102:	8082                	ret

ffffffffc0200104 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc0200104:	45c0006f          	j	ffffffffc0200560 <cons_putc>

ffffffffc0200108 <getchar>:
    return cnt;
}

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200108:	1141                	addi	sp,sp,-16
ffffffffc020010a:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020010c:	48a000ef          	jal	ra,ffffffffc0200596 <cons_getc>
ffffffffc0200110:	dd75                	beqz	a0,ffffffffc020010c <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200112:	60a2                	ld	ra,8(sp)
ffffffffc0200114:	0141                	addi	sp,sp,16
ffffffffc0200116:	8082                	ret

ffffffffc0200118 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0200118:	715d                	addi	sp,sp,-80
ffffffffc020011a:	e486                	sd	ra,72(sp)
ffffffffc020011c:	e0a2                	sd	s0,64(sp)
ffffffffc020011e:	fc26                	sd	s1,56(sp)
ffffffffc0200120:	f84a                	sd	s2,48(sp)
ffffffffc0200122:	f44e                	sd	s3,40(sp)
ffffffffc0200124:	f052                	sd	s4,32(sp)
ffffffffc0200126:	ec56                	sd	s5,24(sp)
ffffffffc0200128:	e85a                	sd	s6,16(sp)
ffffffffc020012a:	e45e                	sd	s7,8(sp)
    if (prompt != NULL) {
ffffffffc020012c:	c901                	beqz	a0,ffffffffc020013c <readline+0x24>
        cprintf("%s", prompt);
ffffffffc020012e:	85aa                	mv	a1,a0
ffffffffc0200130:	00005517          	auipc	a0,0x5
ffffffffc0200134:	df850513          	addi	a0,a0,-520 # ffffffffc0204f28 <etext+0x2e>
ffffffffc0200138:	f99ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
readline(const char *prompt) {
ffffffffc020013c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020013e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200140:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200142:	4aa9                	li	s5,10
ffffffffc0200144:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0200146:	0000bb97          	auipc	s7,0xb
ffffffffc020014a:	f1ab8b93          	addi	s7,s7,-230 # ffffffffc020b060 <edata>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020014e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0200152:	fb7ff0ef          	jal	ra,ffffffffc0200108 <getchar>
ffffffffc0200156:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0200158:	00054b63          	bltz	a0,ffffffffc020016e <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020015c:	00a95b63          	ble	a0,s2,ffffffffc0200172 <readline+0x5a>
ffffffffc0200160:	029a5463          	ble	s1,s4,ffffffffc0200188 <readline+0x70>
        c = getchar();
ffffffffc0200164:	fa5ff0ef          	jal	ra,ffffffffc0200108 <getchar>
ffffffffc0200168:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc020016a:	fe0559e3          	bgez	a0,ffffffffc020015c <readline+0x44>
            return NULL;
ffffffffc020016e:	4501                	li	a0,0
ffffffffc0200170:	a099                	j	ffffffffc02001b6 <readline+0x9e>
        else if (c == '\b' && i > 0) {
ffffffffc0200172:	03341463          	bne	s0,s3,ffffffffc020019a <readline+0x82>
ffffffffc0200176:	e8b9                	bnez	s1,ffffffffc02001cc <readline+0xb4>
        c = getchar();
ffffffffc0200178:	f91ff0ef          	jal	ra,ffffffffc0200108 <getchar>
ffffffffc020017c:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc020017e:	fe0548e3          	bltz	a0,ffffffffc020016e <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200182:	fea958e3          	ble	a0,s2,ffffffffc0200172 <readline+0x5a>
ffffffffc0200186:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200188:	8522                	mv	a0,s0
ffffffffc020018a:	f7bff0ef          	jal	ra,ffffffffc0200104 <cputchar>
            buf[i ++] = c;
ffffffffc020018e:	009b87b3          	add	a5,s7,s1
ffffffffc0200192:	00878023          	sb	s0,0(a5)
ffffffffc0200196:	2485                	addiw	s1,s1,1
ffffffffc0200198:	bf6d                	j	ffffffffc0200152 <readline+0x3a>
        else if (c == '\n' || c == '\r') {
ffffffffc020019a:	01540463          	beq	s0,s5,ffffffffc02001a2 <readline+0x8a>
ffffffffc020019e:	fb641ae3          	bne	s0,s6,ffffffffc0200152 <readline+0x3a>
            cputchar(c);
ffffffffc02001a2:	8522                	mv	a0,s0
ffffffffc02001a4:	f61ff0ef          	jal	ra,ffffffffc0200104 <cputchar>
            buf[i] = '\0';
ffffffffc02001a8:	0000b517          	auipc	a0,0xb
ffffffffc02001ac:	eb850513          	addi	a0,a0,-328 # ffffffffc020b060 <edata>
ffffffffc02001b0:	94aa                	add	s1,s1,a0
ffffffffc02001b2:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02001b6:	60a6                	ld	ra,72(sp)
ffffffffc02001b8:	6406                	ld	s0,64(sp)
ffffffffc02001ba:	74e2                	ld	s1,56(sp)
ffffffffc02001bc:	7942                	ld	s2,48(sp)
ffffffffc02001be:	79a2                	ld	s3,40(sp)
ffffffffc02001c0:	7a02                	ld	s4,32(sp)
ffffffffc02001c2:	6ae2                	ld	s5,24(sp)
ffffffffc02001c4:	6b42                	ld	s6,16(sp)
ffffffffc02001c6:	6ba2                	ld	s7,8(sp)
ffffffffc02001c8:	6161                	addi	sp,sp,80
ffffffffc02001ca:	8082                	ret
            cputchar(c);
ffffffffc02001cc:	4521                	li	a0,8
ffffffffc02001ce:	f37ff0ef          	jal	ra,ffffffffc0200104 <cputchar>
            i --;
ffffffffc02001d2:	34fd                	addiw	s1,s1,-1
ffffffffc02001d4:	bfbd                	j	ffffffffc0200152 <readline+0x3a>

ffffffffc02001d6 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001d6:	00016317          	auipc	t1,0x16
ffffffffc02001da:	29a30313          	addi	t1,t1,666 # ffffffffc0216470 <is_panic>
ffffffffc02001de:	00032303          	lw	t1,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001e2:	715d                	addi	sp,sp,-80
ffffffffc02001e4:	ec06                	sd	ra,24(sp)
ffffffffc02001e6:	e822                	sd	s0,16(sp)
ffffffffc02001e8:	f436                	sd	a3,40(sp)
ffffffffc02001ea:	f83a                	sd	a4,48(sp)
ffffffffc02001ec:	fc3e                	sd	a5,56(sp)
ffffffffc02001ee:	e0c2                	sd	a6,64(sp)
ffffffffc02001f0:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001f2:	02031c63          	bnez	t1,ffffffffc020022a <__panic+0x54>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02001f6:	4785                	li	a5,1
ffffffffc02001f8:	8432                	mv	s0,a2
ffffffffc02001fa:	00016717          	auipc	a4,0x16
ffffffffc02001fe:	26f72b23          	sw	a5,630(a4) # ffffffffc0216470 <is_panic>

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200202:	862e                	mv	a2,a1
    va_start(ap, fmt);
ffffffffc0200204:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200206:	85aa                	mv	a1,a0
ffffffffc0200208:	00005517          	auipc	a0,0x5
ffffffffc020020c:	d2850513          	addi	a0,a0,-728 # ffffffffc0204f30 <etext+0x36>
    va_start(ap, fmt);
ffffffffc0200210:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200212:	ebfff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200216:	65a2                	ld	a1,8(sp)
ffffffffc0200218:	8522                	mv	a0,s0
ffffffffc020021a:	e97ff0ef          	jal	ra,ffffffffc02000b0 <vcprintf>
    cprintf("\n");
ffffffffc020021e:	00006517          	auipc	a0,0x6
ffffffffc0200222:	aca50513          	addi	a0,a0,-1334 # ffffffffc0205ce8 <commands+0xc98>
ffffffffc0200226:	eabff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020022a:	3b0000ef          	jal	ra,ffffffffc02005da <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020022e:	4501                	li	a0,0
ffffffffc0200230:	132000ef          	jal	ra,ffffffffc0200362 <kmonitor>
ffffffffc0200234:	bfed                	j	ffffffffc020022e <__panic+0x58>

ffffffffc0200236 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200236:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200238:	00005517          	auipc	a0,0x5
ffffffffc020023c:	d4850513          	addi	a0,a0,-696 # ffffffffc0204f80 <etext+0x86>
void print_kerninfo(void) {
ffffffffc0200240:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200242:	e8fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc0200246:	00000597          	auipc	a1,0x0
ffffffffc020024a:	df058593          	addi	a1,a1,-528 # ffffffffc0200036 <kern_init>
ffffffffc020024e:	00005517          	auipc	a0,0x5
ffffffffc0200252:	d5250513          	addi	a0,a0,-686 # ffffffffc0204fa0 <etext+0xa6>
ffffffffc0200256:	e7bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020025a:	00005597          	auipc	a1,0x5
ffffffffc020025e:	ca058593          	addi	a1,a1,-864 # ffffffffc0204efa <etext>
ffffffffc0200262:	00005517          	auipc	a0,0x5
ffffffffc0200266:	d5e50513          	addi	a0,a0,-674 # ffffffffc0204fc0 <etext+0xc6>
ffffffffc020026a:	e67ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc020026e:	0000b597          	auipc	a1,0xb
ffffffffc0200272:	df258593          	addi	a1,a1,-526 # ffffffffc020b060 <edata>
ffffffffc0200276:	00005517          	auipc	a0,0x5
ffffffffc020027a:	d6a50513          	addi	a0,a0,-662 # ffffffffc0204fe0 <etext+0xe6>
ffffffffc020027e:	e53ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200282:	00016597          	auipc	a1,0x16
ffffffffc0200286:	37e58593          	addi	a1,a1,894 # ffffffffc0216600 <end>
ffffffffc020028a:	00005517          	auipc	a0,0x5
ffffffffc020028e:	d7650513          	addi	a0,a0,-650 # ffffffffc0205000 <etext+0x106>
ffffffffc0200292:	e3fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200296:	00016597          	auipc	a1,0x16
ffffffffc020029a:	76958593          	addi	a1,a1,1897 # ffffffffc02169ff <end+0x3ff>
ffffffffc020029e:	00000797          	auipc	a5,0x0
ffffffffc02002a2:	d9878793          	addi	a5,a5,-616 # ffffffffc0200036 <kern_init>
ffffffffc02002a6:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002aa:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02002ae:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b0:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002b4:	95be                	add	a1,a1,a5
ffffffffc02002b6:	85a9                	srai	a1,a1,0xa
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	d6850513          	addi	a0,a0,-664 # ffffffffc0205020 <etext+0x126>
}
ffffffffc02002c0:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002c2:	e0fff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc02002c6 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	c8860613          	addi	a2,a2,-888 # ffffffffc0204f50 <etext+0x56>
ffffffffc02002d0:	04d00593          	li	a1,77
ffffffffc02002d4:	00005517          	auipc	a0,0x5
ffffffffc02002d8:	c9450513          	addi	a0,a0,-876 # ffffffffc0204f68 <etext+0x6e>
void print_stackframe(void) {
ffffffffc02002dc:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002de:	ef9ff0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc02002e2 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e2:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e4:	00005617          	auipc	a2,0x5
ffffffffc02002e8:	e4c60613          	addi	a2,a2,-436 # ffffffffc0205130 <commands+0xe0>
ffffffffc02002ec:	00005597          	auipc	a1,0x5
ffffffffc02002f0:	e6458593          	addi	a1,a1,-412 # ffffffffc0205150 <commands+0x100>
ffffffffc02002f4:	00005517          	auipc	a0,0x5
ffffffffc02002f8:	e6450513          	addi	a0,a0,-412 # ffffffffc0205158 <commands+0x108>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002fc:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002fe:	dd3ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	e6660613          	addi	a2,a2,-410 # ffffffffc0205168 <commands+0x118>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	e8658593          	addi	a1,a1,-378 # ffffffffc0205190 <commands+0x140>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	e4650513          	addi	a0,a0,-442 # ffffffffc0205158 <commands+0x108>
ffffffffc020031a:	db7ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc020031e:	00005617          	auipc	a2,0x5
ffffffffc0200322:	e8260613          	addi	a2,a2,-382 # ffffffffc02051a0 <commands+0x150>
ffffffffc0200326:	00005597          	auipc	a1,0x5
ffffffffc020032a:	e9a58593          	addi	a1,a1,-358 # ffffffffc02051c0 <commands+0x170>
ffffffffc020032e:	00005517          	auipc	a0,0x5
ffffffffc0200332:	e2a50513          	addi	a0,a0,-470 # ffffffffc0205158 <commands+0x108>
ffffffffc0200336:	d9bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    }
    return 0;
}
ffffffffc020033a:	60a2                	ld	ra,8(sp)
ffffffffc020033c:	4501                	li	a0,0
ffffffffc020033e:	0141                	addi	sp,sp,16
ffffffffc0200340:	8082                	ret

ffffffffc0200342 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200342:	1141                	addi	sp,sp,-16
ffffffffc0200344:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200346:	ef1ff0ef          	jal	ra,ffffffffc0200236 <print_kerninfo>
    return 0;
}
ffffffffc020034a:	60a2                	ld	ra,8(sp)
ffffffffc020034c:	4501                	li	a0,0
ffffffffc020034e:	0141                	addi	sp,sp,16
ffffffffc0200350:	8082                	ret

ffffffffc0200352 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200352:	1141                	addi	sp,sp,-16
ffffffffc0200354:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200356:	f71ff0ef          	jal	ra,ffffffffc02002c6 <print_stackframe>
    return 0;
}
ffffffffc020035a:	60a2                	ld	ra,8(sp)
ffffffffc020035c:	4501                	li	a0,0
ffffffffc020035e:	0141                	addi	sp,sp,16
ffffffffc0200360:	8082                	ret

ffffffffc0200362 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200362:	7115                	addi	sp,sp,-224
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	8c2a                	mv	s8,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200368:	00005517          	auipc	a0,0x5
ffffffffc020036c:	d3050513          	addi	a0,a0,-720 # ffffffffc0205098 <commands+0x48>
kmonitor(struct trapframe *tf) {
ffffffffc0200370:	ed86                	sd	ra,216(sp)
ffffffffc0200372:	e9a2                	sd	s0,208(sp)
ffffffffc0200374:	e5a6                	sd	s1,200(sp)
ffffffffc0200376:	e1ca                	sd	s2,192(sp)
ffffffffc0200378:	fd4e                	sd	s3,184(sp)
ffffffffc020037a:	f952                	sd	s4,176(sp)
ffffffffc020037c:	f556                	sd	s5,168(sp)
ffffffffc020037e:	f15a                	sd	s6,160(sp)
ffffffffc0200380:	ed5e                	sd	s7,152(sp)
ffffffffc0200382:	e566                	sd	s9,136(sp)
ffffffffc0200384:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200386:	d4bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020038a:	00005517          	auipc	a0,0x5
ffffffffc020038e:	d3650513          	addi	a0,a0,-714 # ffffffffc02050c0 <commands+0x70>
ffffffffc0200392:	d3fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    if (tf != NULL) {
ffffffffc0200396:	000c0563          	beqz	s8,ffffffffc02003a0 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020039a:	8562                	mv	a0,s8
ffffffffc020039c:	49e000ef          	jal	ra,ffffffffc020083a <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02003a0:	4501                	li	a0,0
ffffffffc02003a2:	4581                	li	a1,0
ffffffffc02003a4:	4601                	li	a2,0
ffffffffc02003a6:	48a1                	li	a7,8
ffffffffc02003a8:	00000073          	ecall
ffffffffc02003ac:	00005c97          	auipc	s9,0x5
ffffffffc02003b0:	ca4c8c93          	addi	s9,s9,-860 # ffffffffc0205050 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003b4:	00005997          	auipc	s3,0x5
ffffffffc02003b8:	d3498993          	addi	s3,s3,-716 # ffffffffc02050e8 <commands+0x98>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003bc:	00005917          	auipc	s2,0x5
ffffffffc02003c0:	d3490913          	addi	s2,s2,-716 # ffffffffc02050f0 <commands+0xa0>
        if (argc == MAXARGS - 1) {
ffffffffc02003c4:	4a3d                	li	s4,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003c6:	00005b17          	auipc	s6,0x5
ffffffffc02003ca:	d32b0b13          	addi	s6,s6,-718 # ffffffffc02050f8 <commands+0xa8>
    if (argc == 0) {
ffffffffc02003ce:	00005a97          	auipc	s5,0x5
ffffffffc02003d2:	d82a8a93          	addi	s5,s5,-638 # ffffffffc0205150 <commands+0x100>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d6:	4b8d                	li	s7,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003d8:	854e                	mv	a0,s3
ffffffffc02003da:	d3fff0ef          	jal	ra,ffffffffc0200118 <readline>
ffffffffc02003de:	842a                	mv	s0,a0
ffffffffc02003e0:	dd65                	beqz	a0,ffffffffc02003d8 <kmonitor+0x76>
ffffffffc02003e2:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003e6:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003e8:	c999                	beqz	a1,ffffffffc02003fe <kmonitor+0x9c>
ffffffffc02003ea:	854a                	mv	a0,s2
ffffffffc02003ec:	686040ef          	jal	ra,ffffffffc0204a72 <strchr>
ffffffffc02003f0:	c925                	beqz	a0,ffffffffc0200460 <kmonitor+0xfe>
            *buf ++ = '\0';
ffffffffc02003f2:	00144583          	lbu	a1,1(s0)
ffffffffc02003f6:	00040023          	sb	zero,0(s0)
ffffffffc02003fa:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003fc:	f5fd                	bnez	a1,ffffffffc02003ea <kmonitor+0x88>
    if (argc == 0) {
ffffffffc02003fe:	dce9                	beqz	s1,ffffffffc02003d8 <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200400:	6582                	ld	a1,0(sp)
ffffffffc0200402:	00005d17          	auipc	s10,0x5
ffffffffc0200406:	c4ed0d13          	addi	s10,s10,-946 # ffffffffc0205050 <commands>
    if (argc == 0) {
ffffffffc020040a:	8556                	mv	a0,s5
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020040c:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020040e:	0d61                	addi	s10,s10,24
ffffffffc0200410:	638040ef          	jal	ra,ffffffffc0204a48 <strcmp>
ffffffffc0200414:	c919                	beqz	a0,ffffffffc020042a <kmonitor+0xc8>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200416:	2405                	addiw	s0,s0,1
ffffffffc0200418:	09740463          	beq	s0,s7,ffffffffc02004a0 <kmonitor+0x13e>
ffffffffc020041c:	000d3503          	ld	a0,0(s10)
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200420:	6582                	ld	a1,0(sp)
ffffffffc0200422:	0d61                	addi	s10,s10,24
ffffffffc0200424:	624040ef          	jal	ra,ffffffffc0204a48 <strcmp>
ffffffffc0200428:	f57d                	bnez	a0,ffffffffc0200416 <kmonitor+0xb4>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020042a:	00141793          	slli	a5,s0,0x1
ffffffffc020042e:	97a2                	add	a5,a5,s0
ffffffffc0200430:	078e                	slli	a5,a5,0x3
ffffffffc0200432:	97e6                	add	a5,a5,s9
ffffffffc0200434:	6b9c                	ld	a5,16(a5)
ffffffffc0200436:	8662                	mv	a2,s8
ffffffffc0200438:	002c                	addi	a1,sp,8
ffffffffc020043a:	fff4851b          	addiw	a0,s1,-1
ffffffffc020043e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200440:	f8055ce3          	bgez	a0,ffffffffc02003d8 <kmonitor+0x76>
}
ffffffffc0200444:	60ee                	ld	ra,216(sp)
ffffffffc0200446:	644e                	ld	s0,208(sp)
ffffffffc0200448:	64ae                	ld	s1,200(sp)
ffffffffc020044a:	690e                	ld	s2,192(sp)
ffffffffc020044c:	79ea                	ld	s3,184(sp)
ffffffffc020044e:	7a4a                	ld	s4,176(sp)
ffffffffc0200450:	7aaa                	ld	s5,168(sp)
ffffffffc0200452:	7b0a                	ld	s6,160(sp)
ffffffffc0200454:	6bea                	ld	s7,152(sp)
ffffffffc0200456:	6c4a                	ld	s8,144(sp)
ffffffffc0200458:	6caa                	ld	s9,136(sp)
ffffffffc020045a:	6d0a                	ld	s10,128(sp)
ffffffffc020045c:	612d                	addi	sp,sp,224
ffffffffc020045e:	8082                	ret
        if (*buf == '\0') {
ffffffffc0200460:	00044783          	lbu	a5,0(s0)
ffffffffc0200464:	dfc9                	beqz	a5,ffffffffc02003fe <kmonitor+0x9c>
        if (argc == MAXARGS - 1) {
ffffffffc0200466:	03448863          	beq	s1,s4,ffffffffc0200496 <kmonitor+0x134>
        argv[argc ++] = buf;
ffffffffc020046a:	00349793          	slli	a5,s1,0x3
ffffffffc020046e:	0118                	addi	a4,sp,128
ffffffffc0200470:	97ba                	add	a5,a5,a4
ffffffffc0200472:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200476:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020047a:	2485                	addiw	s1,s1,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020047c:	e591                	bnez	a1,ffffffffc0200488 <kmonitor+0x126>
ffffffffc020047e:	b749                	j	ffffffffc0200400 <kmonitor+0x9e>
            buf ++;
ffffffffc0200480:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200482:	00044583          	lbu	a1,0(s0)
ffffffffc0200486:	ddad                	beqz	a1,ffffffffc0200400 <kmonitor+0x9e>
ffffffffc0200488:	854a                	mv	a0,s2
ffffffffc020048a:	5e8040ef          	jal	ra,ffffffffc0204a72 <strchr>
ffffffffc020048e:	d96d                	beqz	a0,ffffffffc0200480 <kmonitor+0x11e>
ffffffffc0200490:	00044583          	lbu	a1,0(s0)
ffffffffc0200494:	bf91                	j	ffffffffc02003e8 <kmonitor+0x86>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200496:	45c1                	li	a1,16
ffffffffc0200498:	855a                	mv	a0,s6
ffffffffc020049a:	c37ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc020049e:	b7f1                	j	ffffffffc020046a <kmonitor+0x108>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02004a0:	6582                	ld	a1,0(sp)
ffffffffc02004a2:	00005517          	auipc	a0,0x5
ffffffffc02004a6:	c7650513          	addi	a0,a0,-906 # ffffffffc0205118 <commands+0xc8>
ffffffffc02004aa:	c27ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    return 0;
ffffffffc02004ae:	b72d                	j	ffffffffc02003d8 <kmonitor+0x76>

ffffffffc02004b0 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc02004b0:	8082                	ret

ffffffffc02004b2 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc02004b2:	00253513          	sltiu	a0,a0,2
ffffffffc02004b6:	8082                	ret

ffffffffc02004b8 <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc02004b8:	03800513          	li	a0,56
ffffffffc02004bc:	8082                	ret

ffffffffc02004be <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02004be:	0000b797          	auipc	a5,0xb
ffffffffc02004c2:	fa278793          	addi	a5,a5,-94 # ffffffffc020b460 <ide>
ffffffffc02004c6:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc02004ca:	1141                	addi	sp,sp,-16
ffffffffc02004cc:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02004ce:	95be                	add	a1,a1,a5
ffffffffc02004d0:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc02004d4:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc02004d6:	5cc040ef          	jal	ra,ffffffffc0204aa2 <memcpy>
    return 0;
}
ffffffffc02004da:	60a2                	ld	ra,8(sp)
ffffffffc02004dc:	4501                	li	a0,0
ffffffffc02004de:	0141                	addi	sp,sp,16
ffffffffc02004e0:	8082                	ret

ffffffffc02004e2 <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
ffffffffc02004e2:	8732                	mv	a4,a2
    int iobase = secno * SECTSIZE;
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02004e4:	0095979b          	slliw	a5,a1,0x9
ffffffffc02004e8:	0000b517          	auipc	a0,0xb
ffffffffc02004ec:	f7850513          	addi	a0,a0,-136 # ffffffffc020b460 <ide>
                   size_t nsecs) {
ffffffffc02004f0:	1141                	addi	sp,sp,-16
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02004f2:	00969613          	slli	a2,a3,0x9
ffffffffc02004f6:	85ba                	mv	a1,a4
ffffffffc02004f8:	953e                	add	a0,a0,a5
                   size_t nsecs) {
ffffffffc02004fa:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc02004fc:	5a6040ef          	jal	ra,ffffffffc0204aa2 <memcpy>
    return 0;
}
ffffffffc0200500:	60a2                	ld	ra,8(sp)
ffffffffc0200502:	4501                	li	a0,0
ffffffffc0200504:	0141                	addi	sp,sp,16
ffffffffc0200506:	8082                	ret

ffffffffc0200508 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200508:	67e1                	lui	a5,0x18
ffffffffc020050a:	6a078793          	addi	a5,a5,1696 # 186a0 <BASE_ADDRESS-0xffffffffc01e7960>
ffffffffc020050e:	00016717          	auipc	a4,0x16
ffffffffc0200512:	f6f73523          	sd	a5,-150(a4) # ffffffffc0216478 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200516:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020051a:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020051c:	953e                	add	a0,a0,a5
ffffffffc020051e:	4601                	li	a2,0
ffffffffc0200520:	4881                	li	a7,0
ffffffffc0200522:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200526:	02000793          	li	a5,32
ffffffffc020052a:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020052e:	00005517          	auipc	a0,0x5
ffffffffc0200532:	ca250513          	addi	a0,a0,-862 # ffffffffc02051d0 <commands+0x180>
    ticks = 0;
ffffffffc0200536:	00016797          	auipc	a5,0x16
ffffffffc020053a:	f807bd23          	sd	zero,-102(a5) # ffffffffc02164d0 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020053e:	b93ff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc0200542 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200542:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200546:	00016797          	auipc	a5,0x16
ffffffffc020054a:	f3278793          	addi	a5,a5,-206 # ffffffffc0216478 <timebase>
ffffffffc020054e:	639c                	ld	a5,0(a5)
ffffffffc0200550:	4581                	li	a1,0
ffffffffc0200552:	4601                	li	a2,0
ffffffffc0200554:	953e                	add	a0,a0,a5
ffffffffc0200556:	4881                	li	a7,0
ffffffffc0200558:	00000073          	ecall
ffffffffc020055c:	8082                	ret

ffffffffc020055e <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020055e:	8082                	ret

ffffffffc0200560 <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200560:	100027f3          	csrr	a5,sstatus
ffffffffc0200564:	8b89                	andi	a5,a5,2
ffffffffc0200566:	0ff57513          	andi	a0,a0,255
ffffffffc020056a:	e799                	bnez	a5,ffffffffc0200578 <cons_putc+0x18>
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc020056c:	4581                	li	a1,0
ffffffffc020056e:	4601                	li	a2,0
ffffffffc0200570:	4885                	li	a7,1
ffffffffc0200572:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200576:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200578:	1101                	addi	sp,sp,-32
ffffffffc020057a:	ec06                	sd	ra,24(sp)
ffffffffc020057c:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020057e:	05c000ef          	jal	ra,ffffffffc02005da <intr_disable>
ffffffffc0200582:	6522                	ld	a0,8(sp)
ffffffffc0200584:	4581                	li	a1,0
ffffffffc0200586:	4601                	li	a2,0
ffffffffc0200588:	4885                	li	a7,1
ffffffffc020058a:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc020058e:	60e2                	ld	ra,24(sp)
ffffffffc0200590:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200592:	0420006f          	j	ffffffffc02005d4 <intr_enable>

ffffffffc0200596 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200596:	100027f3          	csrr	a5,sstatus
ffffffffc020059a:	8b89                	andi	a5,a5,2
ffffffffc020059c:	eb89                	bnez	a5,ffffffffc02005ae <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020059e:	4501                	li	a0,0
ffffffffc02005a0:	4581                	li	a1,0
ffffffffc02005a2:	4601                	li	a2,0
ffffffffc02005a4:	4889                	li	a7,2
ffffffffc02005a6:	00000073          	ecall
ffffffffc02005aa:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005ac:	8082                	ret
int cons_getc(void) {
ffffffffc02005ae:	1101                	addi	sp,sp,-32
ffffffffc02005b0:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005b2:	028000ef          	jal	ra,ffffffffc02005da <intr_disable>
ffffffffc02005b6:	4501                	li	a0,0
ffffffffc02005b8:	4581                	li	a1,0
ffffffffc02005ba:	4601                	li	a2,0
ffffffffc02005bc:	4889                	li	a7,2
ffffffffc02005be:	00000073          	ecall
ffffffffc02005c2:	2501                	sext.w	a0,a0
ffffffffc02005c4:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005c6:	00e000ef          	jal	ra,ffffffffc02005d4 <intr_enable>
}
ffffffffc02005ca:	60e2                	ld	ra,24(sp)
ffffffffc02005cc:	6522                	ld	a0,8(sp)
ffffffffc02005ce:	6105                	addi	sp,sp,32
ffffffffc02005d0:	8082                	ret

ffffffffc02005d2 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02005d2:	8082                	ret

ffffffffc02005d4 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02005d4:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02005d8:	8082                	ret

ffffffffc02005da <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02005da:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02005de:	8082                	ret

ffffffffc02005e0 <pgfault_handler>:
    set_csr(sstatus, SSTATUS_SUM);
}

/* trap_in_kernel - test if trap happened in kernel */
bool trap_in_kernel(struct trapframe *tf) {
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02005e0:	10053783          	ld	a5,256(a0)
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int pgfault_handler(struct trapframe *tf) {
ffffffffc02005e4:	1141                	addi	sp,sp,-16
ffffffffc02005e6:	e022                	sd	s0,0(sp)
ffffffffc02005e8:	e406                	sd	ra,8(sp)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02005ea:	1007f793          	andi	a5,a5,256
static int pgfault_handler(struct trapframe *tf) {
ffffffffc02005ee:	842a                	mv	s0,a0
    cprintf("page falut at 0x%08x: %c/%c\n", tf->badvaddr,
ffffffffc02005f0:	11053583          	ld	a1,272(a0)
ffffffffc02005f4:	05500613          	li	a2,85
ffffffffc02005f8:	c399                	beqz	a5,ffffffffc02005fe <pgfault_handler+0x1e>
ffffffffc02005fa:	04b00613          	li	a2,75
ffffffffc02005fe:	11843703          	ld	a4,280(s0)
ffffffffc0200602:	47bd                	li	a5,15
ffffffffc0200604:	05700693          	li	a3,87
ffffffffc0200608:	00f70463          	beq	a4,a5,ffffffffc0200610 <pgfault_handler+0x30>
ffffffffc020060c:	05200693          	li	a3,82
ffffffffc0200610:	00005517          	auipc	a0,0x5
ffffffffc0200614:	eb850513          	addi	a0,a0,-328 # ffffffffc02054c8 <commands+0x478>
ffffffffc0200618:	ab9ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
ffffffffc020061c:	00016797          	auipc	a5,0x16
ffffffffc0200620:	eec78793          	addi	a5,a5,-276 # ffffffffc0216508 <check_mm_struct>
ffffffffc0200624:	6388                	ld	a0,0(a5)
ffffffffc0200626:	c911                	beqz	a0,ffffffffc020063a <pgfault_handler+0x5a>
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200628:	11043603          	ld	a2,272(s0)
ffffffffc020062c:	11842583          	lw	a1,280(s0)
    }
    panic("unhandled page fault.\n");
}
ffffffffc0200630:	6402                	ld	s0,0(sp)
ffffffffc0200632:	60a2                	ld	ra,8(sp)
ffffffffc0200634:	0141                	addi	sp,sp,16
        return do_pgfault(check_mm_struct, tf->cause, tf->badvaddr);
ffffffffc0200636:	0200206f          	j	ffffffffc0202656 <do_pgfault>
    panic("unhandled page fault.\n");
ffffffffc020063a:	00005617          	auipc	a2,0x5
ffffffffc020063e:	eae60613          	addi	a2,a2,-338 # ffffffffc02054e8 <commands+0x498>
ffffffffc0200642:	06200593          	li	a1,98
ffffffffc0200646:	00005517          	auipc	a0,0x5
ffffffffc020064a:	eba50513          	addi	a0,a0,-326 # ffffffffc0205500 <commands+0x4b0>
ffffffffc020064e:	b89ff0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0200652 <idt_init>:
    write_csr(sscratch, 0);
ffffffffc0200652:	14005073          	csrwi	sscratch,0
    write_csr(stvec, &__alltraps);
ffffffffc0200656:	00000797          	auipc	a5,0x0
ffffffffc020065a:	48e78793          	addi	a5,a5,1166 # ffffffffc0200ae4 <__alltraps>
ffffffffc020065e:	10579073          	csrw	stvec,a5
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200662:	000407b7          	lui	a5,0x40
ffffffffc0200666:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020066a:	8082                	ret

ffffffffc020066c <print_regs>:
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020066c:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc020066e:	1141                	addi	sp,sp,-16
ffffffffc0200670:	e022                	sd	s0,0(sp)
ffffffffc0200672:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200674:	00005517          	auipc	a0,0x5
ffffffffc0200678:	ea450513          	addi	a0,a0,-348 # ffffffffc0205518 <commands+0x4c8>
void print_regs(struct pushregs *gpr) {
ffffffffc020067c:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020067e:	a53ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200682:	640c                	ld	a1,8(s0)
ffffffffc0200684:	00005517          	auipc	a0,0x5
ffffffffc0200688:	eac50513          	addi	a0,a0,-340 # ffffffffc0205530 <commands+0x4e0>
ffffffffc020068c:	a45ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200690:	680c                	ld	a1,16(s0)
ffffffffc0200692:	00005517          	auipc	a0,0x5
ffffffffc0200696:	eb650513          	addi	a0,a0,-330 # ffffffffc0205548 <commands+0x4f8>
ffffffffc020069a:	a37ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020069e:	6c0c                	ld	a1,24(s0)
ffffffffc02006a0:	00005517          	auipc	a0,0x5
ffffffffc02006a4:	ec050513          	addi	a0,a0,-320 # ffffffffc0205560 <commands+0x510>
ffffffffc02006a8:	a29ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02006ac:	700c                	ld	a1,32(s0)
ffffffffc02006ae:	00005517          	auipc	a0,0x5
ffffffffc02006b2:	eca50513          	addi	a0,a0,-310 # ffffffffc0205578 <commands+0x528>
ffffffffc02006b6:	a1bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02006ba:	740c                	ld	a1,40(s0)
ffffffffc02006bc:	00005517          	auipc	a0,0x5
ffffffffc02006c0:	ed450513          	addi	a0,a0,-300 # ffffffffc0205590 <commands+0x540>
ffffffffc02006c4:	a0dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02006c8:	780c                	ld	a1,48(s0)
ffffffffc02006ca:	00005517          	auipc	a0,0x5
ffffffffc02006ce:	ede50513          	addi	a0,a0,-290 # ffffffffc02055a8 <commands+0x558>
ffffffffc02006d2:	9ffff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02006d6:	7c0c                	ld	a1,56(s0)
ffffffffc02006d8:	00005517          	auipc	a0,0x5
ffffffffc02006dc:	ee850513          	addi	a0,a0,-280 # ffffffffc02055c0 <commands+0x570>
ffffffffc02006e0:	9f1ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02006e4:	602c                	ld	a1,64(s0)
ffffffffc02006e6:	00005517          	auipc	a0,0x5
ffffffffc02006ea:	ef250513          	addi	a0,a0,-270 # ffffffffc02055d8 <commands+0x588>
ffffffffc02006ee:	9e3ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02006f2:	642c                	ld	a1,72(s0)
ffffffffc02006f4:	00005517          	auipc	a0,0x5
ffffffffc02006f8:	efc50513          	addi	a0,a0,-260 # ffffffffc02055f0 <commands+0x5a0>
ffffffffc02006fc:	9d5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200700:	682c                	ld	a1,80(s0)
ffffffffc0200702:	00005517          	auipc	a0,0x5
ffffffffc0200706:	f0650513          	addi	a0,a0,-250 # ffffffffc0205608 <commands+0x5b8>
ffffffffc020070a:	9c7ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020070e:	6c2c                	ld	a1,88(s0)
ffffffffc0200710:	00005517          	auipc	a0,0x5
ffffffffc0200714:	f1050513          	addi	a0,a0,-240 # ffffffffc0205620 <commands+0x5d0>
ffffffffc0200718:	9b9ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc020071c:	702c                	ld	a1,96(s0)
ffffffffc020071e:	00005517          	auipc	a0,0x5
ffffffffc0200722:	f1a50513          	addi	a0,a0,-230 # ffffffffc0205638 <commands+0x5e8>
ffffffffc0200726:	9abff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020072a:	742c                	ld	a1,104(s0)
ffffffffc020072c:	00005517          	auipc	a0,0x5
ffffffffc0200730:	f2450513          	addi	a0,a0,-220 # ffffffffc0205650 <commands+0x600>
ffffffffc0200734:	99dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200738:	782c                	ld	a1,112(s0)
ffffffffc020073a:	00005517          	auipc	a0,0x5
ffffffffc020073e:	f2e50513          	addi	a0,a0,-210 # ffffffffc0205668 <commands+0x618>
ffffffffc0200742:	98fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200746:	7c2c                	ld	a1,120(s0)
ffffffffc0200748:	00005517          	auipc	a0,0x5
ffffffffc020074c:	f3850513          	addi	a0,a0,-200 # ffffffffc0205680 <commands+0x630>
ffffffffc0200750:	981ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200754:	604c                	ld	a1,128(s0)
ffffffffc0200756:	00005517          	auipc	a0,0x5
ffffffffc020075a:	f4250513          	addi	a0,a0,-190 # ffffffffc0205698 <commands+0x648>
ffffffffc020075e:	973ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200762:	644c                	ld	a1,136(s0)
ffffffffc0200764:	00005517          	auipc	a0,0x5
ffffffffc0200768:	f4c50513          	addi	a0,a0,-180 # ffffffffc02056b0 <commands+0x660>
ffffffffc020076c:	965ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200770:	684c                	ld	a1,144(s0)
ffffffffc0200772:	00005517          	auipc	a0,0x5
ffffffffc0200776:	f5650513          	addi	a0,a0,-170 # ffffffffc02056c8 <commands+0x678>
ffffffffc020077a:	957ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020077e:	6c4c                	ld	a1,152(s0)
ffffffffc0200780:	00005517          	auipc	a0,0x5
ffffffffc0200784:	f6050513          	addi	a0,a0,-160 # ffffffffc02056e0 <commands+0x690>
ffffffffc0200788:	949ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc020078c:	704c                	ld	a1,160(s0)
ffffffffc020078e:	00005517          	auipc	a0,0x5
ffffffffc0200792:	f6a50513          	addi	a0,a0,-150 # ffffffffc02056f8 <commands+0x6a8>
ffffffffc0200796:	93bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc020079a:	744c                	ld	a1,168(s0)
ffffffffc020079c:	00005517          	auipc	a0,0x5
ffffffffc02007a0:	f7450513          	addi	a0,a0,-140 # ffffffffc0205710 <commands+0x6c0>
ffffffffc02007a4:	92dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02007a8:	784c                	ld	a1,176(s0)
ffffffffc02007aa:	00005517          	auipc	a0,0x5
ffffffffc02007ae:	f7e50513          	addi	a0,a0,-130 # ffffffffc0205728 <commands+0x6d8>
ffffffffc02007b2:	91fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02007b6:	7c4c                	ld	a1,184(s0)
ffffffffc02007b8:	00005517          	auipc	a0,0x5
ffffffffc02007bc:	f8850513          	addi	a0,a0,-120 # ffffffffc0205740 <commands+0x6f0>
ffffffffc02007c0:	911ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02007c4:	606c                	ld	a1,192(s0)
ffffffffc02007c6:	00005517          	auipc	a0,0x5
ffffffffc02007ca:	f9250513          	addi	a0,a0,-110 # ffffffffc0205758 <commands+0x708>
ffffffffc02007ce:	903ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02007d2:	646c                	ld	a1,200(s0)
ffffffffc02007d4:	00005517          	auipc	a0,0x5
ffffffffc02007d8:	f9c50513          	addi	a0,a0,-100 # ffffffffc0205770 <commands+0x720>
ffffffffc02007dc:	8f5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02007e0:	686c                	ld	a1,208(s0)
ffffffffc02007e2:	00005517          	auipc	a0,0x5
ffffffffc02007e6:	fa650513          	addi	a0,a0,-90 # ffffffffc0205788 <commands+0x738>
ffffffffc02007ea:	8e7ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02007ee:	6c6c                	ld	a1,216(s0)
ffffffffc02007f0:	00005517          	auipc	a0,0x5
ffffffffc02007f4:	fb050513          	addi	a0,a0,-80 # ffffffffc02057a0 <commands+0x750>
ffffffffc02007f8:	8d9ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02007fc:	706c                	ld	a1,224(s0)
ffffffffc02007fe:	00005517          	auipc	a0,0x5
ffffffffc0200802:	fba50513          	addi	a0,a0,-70 # ffffffffc02057b8 <commands+0x768>
ffffffffc0200806:	8cbff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc020080a:	746c                	ld	a1,232(s0)
ffffffffc020080c:	00005517          	auipc	a0,0x5
ffffffffc0200810:	fc450513          	addi	a0,a0,-60 # ffffffffc02057d0 <commands+0x780>
ffffffffc0200814:	8bdff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200818:	786c                	ld	a1,240(s0)
ffffffffc020081a:	00005517          	auipc	a0,0x5
ffffffffc020081e:	fce50513          	addi	a0,a0,-50 # ffffffffc02057e8 <commands+0x798>
ffffffffc0200822:	8afff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200826:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200828:	6402                	ld	s0,0(sp)
ffffffffc020082a:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020082c:	00005517          	auipc	a0,0x5
ffffffffc0200830:	fd450513          	addi	a0,a0,-44 # ffffffffc0205800 <commands+0x7b0>
}
ffffffffc0200834:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200836:	89bff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc020083a <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc020083a:	1141                	addi	sp,sp,-16
ffffffffc020083c:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020083e:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200840:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200842:	00005517          	auipc	a0,0x5
ffffffffc0200846:	fd650513          	addi	a0,a0,-42 # ffffffffc0205818 <commands+0x7c8>
void print_trapframe(struct trapframe *tf) {
ffffffffc020084a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020084c:	885ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200850:	8522                	mv	a0,s0
ffffffffc0200852:	e1bff0ef          	jal	ra,ffffffffc020066c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200856:	10043583          	ld	a1,256(s0)
ffffffffc020085a:	00005517          	auipc	a0,0x5
ffffffffc020085e:	fd650513          	addi	a0,a0,-42 # ffffffffc0205830 <commands+0x7e0>
ffffffffc0200862:	86fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200866:	10843583          	ld	a1,264(s0)
ffffffffc020086a:	00005517          	auipc	a0,0x5
ffffffffc020086e:	fde50513          	addi	a0,a0,-34 # ffffffffc0205848 <commands+0x7f8>
ffffffffc0200872:	85fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200876:	11043583          	ld	a1,272(s0)
ffffffffc020087a:	00005517          	auipc	a0,0x5
ffffffffc020087e:	fe650513          	addi	a0,a0,-26 # ffffffffc0205860 <commands+0x810>
ffffffffc0200882:	84fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200886:	11843583          	ld	a1,280(s0)
}
ffffffffc020088a:	6402                	ld	s0,0(sp)
ffffffffc020088c:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020088e:	00005517          	auipc	a0,0x5
ffffffffc0200892:	fea50513          	addi	a0,a0,-22 # ffffffffc0205878 <commands+0x828>
}
ffffffffc0200896:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200898:	839ff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc020089c <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc020089c:	11853783          	ld	a5,280(a0)
ffffffffc02008a0:	577d                	li	a4,-1
ffffffffc02008a2:	8305                	srli	a4,a4,0x1
ffffffffc02008a4:	8ff9                	and	a5,a5,a4
    switch (cause) {
ffffffffc02008a6:	472d                	li	a4,11
ffffffffc02008a8:	06f76f63          	bltu	a4,a5,ffffffffc0200926 <interrupt_handler+0x8a>
ffffffffc02008ac:	00005717          	auipc	a4,0x5
ffffffffc02008b0:	94070713          	addi	a4,a4,-1728 # ffffffffc02051ec <commands+0x19c>
ffffffffc02008b4:	078a                	slli	a5,a5,0x2
ffffffffc02008b6:	97ba                	add	a5,a5,a4
ffffffffc02008b8:	439c                	lw	a5,0(a5)
ffffffffc02008ba:	97ba                	add	a5,a5,a4
ffffffffc02008bc:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02008be:	00005517          	auipc	a0,0x5
ffffffffc02008c2:	bba50513          	addi	a0,a0,-1094 # ffffffffc0205478 <commands+0x428>
ffffffffc02008c6:	80bff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02008ca:	00005517          	auipc	a0,0x5
ffffffffc02008ce:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0205458 <commands+0x408>
ffffffffc02008d2:	ffeff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02008d6:	00005517          	auipc	a0,0x5
ffffffffc02008da:	b4250513          	addi	a0,a0,-1214 # ffffffffc0205418 <commands+0x3c8>
ffffffffc02008de:	ff2ff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc02008e2:	00005517          	auipc	a0,0x5
ffffffffc02008e6:	b5650513          	addi	a0,a0,-1194 # ffffffffc0205438 <commands+0x3e8>
ffffffffc02008ea:	fe6ff06f          	j	ffffffffc02000d0 <cprintf>
            break;
        case IRQ_U_EXT:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_EXT:
            cprintf("Supervisor external interrupt\n");
ffffffffc02008ee:	00005517          	auipc	a0,0x5
ffffffffc02008f2:	bba50513          	addi	a0,a0,-1094 # ffffffffc02054a8 <commands+0x458>
ffffffffc02008f6:	fdaff06f          	j	ffffffffc02000d0 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02008fa:	1141                	addi	sp,sp,-16
ffffffffc02008fc:	e406                	sd	ra,8(sp)
            clock_set_next_event();
ffffffffc02008fe:	c45ff0ef          	jal	ra,ffffffffc0200542 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc0200902:	00016797          	auipc	a5,0x16
ffffffffc0200906:	bce78793          	addi	a5,a5,-1074 # ffffffffc02164d0 <ticks>
ffffffffc020090a:	639c                	ld	a5,0(a5)
ffffffffc020090c:	06400713          	li	a4,100
ffffffffc0200910:	0785                	addi	a5,a5,1
ffffffffc0200912:	02e7f733          	remu	a4,a5,a4
ffffffffc0200916:	00016697          	auipc	a3,0x16
ffffffffc020091a:	baf6bd23          	sd	a5,-1094(a3) # ffffffffc02164d0 <ticks>
ffffffffc020091e:	c711                	beqz	a4,ffffffffc020092a <interrupt_handler+0x8e>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200920:	60a2                	ld	ra,8(sp)
ffffffffc0200922:	0141                	addi	sp,sp,16
ffffffffc0200924:	8082                	ret
            print_trapframe(tf);
ffffffffc0200926:	f15ff06f          	j	ffffffffc020083a <print_trapframe>
}
ffffffffc020092a:	60a2                	ld	ra,8(sp)
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc020092c:	06400593          	li	a1,100
ffffffffc0200930:	00005517          	auipc	a0,0x5
ffffffffc0200934:	b6850513          	addi	a0,a0,-1176 # ffffffffc0205498 <commands+0x448>
}
ffffffffc0200938:	0141                	addi	sp,sp,16
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc020093a:	f96ff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc020093e <exception_handler>:

void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc020093e:	11853783          	ld	a5,280(a0)
ffffffffc0200942:	473d                	li	a4,15
ffffffffc0200944:	16f76563          	bltu	a4,a5,ffffffffc0200aae <exception_handler+0x170>
ffffffffc0200948:	00005717          	auipc	a4,0x5
ffffffffc020094c:	8d470713          	addi	a4,a4,-1836 # ffffffffc020521c <commands+0x1cc>
ffffffffc0200950:	078a                	slli	a5,a5,0x2
ffffffffc0200952:	97ba                	add	a5,a5,a4
ffffffffc0200954:	439c                	lw	a5,0(a5)
void exception_handler(struct trapframe *tf) {
ffffffffc0200956:	1101                	addi	sp,sp,-32
ffffffffc0200958:	e822                	sd	s0,16(sp)
ffffffffc020095a:	ec06                	sd	ra,24(sp)
ffffffffc020095c:	e426                	sd	s1,8(sp)
    switch (tf->cause) {
ffffffffc020095e:	97ba                	add	a5,a5,a4
ffffffffc0200960:	842a                	mv	s0,a0
ffffffffc0200962:	8782                	jr	a5
                print_trapframe(tf);
                panic("handle pgfault failed. %e\n", ret);
            }
            break;
        case CAUSE_STORE_PAGE_FAULT:
            cprintf("Store/AMO page fault\n");
ffffffffc0200964:	00005517          	auipc	a0,0x5
ffffffffc0200968:	a9c50513          	addi	a0,a0,-1380 # ffffffffc0205400 <commands+0x3b0>
ffffffffc020096c:	f64ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200970:	8522                	mv	a0,s0
ffffffffc0200972:	c6fff0ef          	jal	ra,ffffffffc02005e0 <pgfault_handler>
ffffffffc0200976:	84aa                	mv	s1,a0
ffffffffc0200978:	12051d63          	bnez	a0,ffffffffc0200ab2 <exception_handler+0x174>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc020097c:	60e2                	ld	ra,24(sp)
ffffffffc020097e:	6442                	ld	s0,16(sp)
ffffffffc0200980:	64a2                	ld	s1,8(sp)
ffffffffc0200982:	6105                	addi	sp,sp,32
ffffffffc0200984:	8082                	ret
            cprintf("Instruction address misaligned\n");
ffffffffc0200986:	00005517          	auipc	a0,0x5
ffffffffc020098a:	8da50513          	addi	a0,a0,-1830 # ffffffffc0205260 <commands+0x210>
}
ffffffffc020098e:	6442                	ld	s0,16(sp)
ffffffffc0200990:	60e2                	ld	ra,24(sp)
ffffffffc0200992:	64a2                	ld	s1,8(sp)
ffffffffc0200994:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc0200996:	f3aff06f          	j	ffffffffc02000d0 <cprintf>
ffffffffc020099a:	00005517          	auipc	a0,0x5
ffffffffc020099e:	8e650513          	addi	a0,a0,-1818 # ffffffffc0205280 <commands+0x230>
ffffffffc02009a2:	b7f5                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc02009a4:	00005517          	auipc	a0,0x5
ffffffffc02009a8:	8fc50513          	addi	a0,a0,-1796 # ffffffffc02052a0 <commands+0x250>
ffffffffc02009ac:	b7cd                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc02009ae:	00005517          	auipc	a0,0x5
ffffffffc02009b2:	90a50513          	addi	a0,a0,-1782 # ffffffffc02052b8 <commands+0x268>
ffffffffc02009b6:	bfe1                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Load address misaligned\n");
ffffffffc02009b8:	00005517          	auipc	a0,0x5
ffffffffc02009bc:	91050513          	addi	a0,a0,-1776 # ffffffffc02052c8 <commands+0x278>
ffffffffc02009c0:	b7f9                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc02009c2:	00005517          	auipc	a0,0x5
ffffffffc02009c6:	92650513          	addi	a0,a0,-1754 # ffffffffc02052e8 <commands+0x298>
ffffffffc02009ca:	f06ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc02009ce:	8522                	mv	a0,s0
ffffffffc02009d0:	c11ff0ef          	jal	ra,ffffffffc02005e0 <pgfault_handler>
ffffffffc02009d4:	84aa                	mv	s1,a0
ffffffffc02009d6:	d15d                	beqz	a0,ffffffffc020097c <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc02009d8:	8522                	mv	a0,s0
ffffffffc02009da:	e61ff0ef          	jal	ra,ffffffffc020083a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc02009de:	86a6                	mv	a3,s1
ffffffffc02009e0:	00005617          	auipc	a2,0x5
ffffffffc02009e4:	92060613          	addi	a2,a2,-1760 # ffffffffc0205300 <commands+0x2b0>
ffffffffc02009e8:	0b300593          	li	a1,179
ffffffffc02009ec:	00005517          	auipc	a0,0x5
ffffffffc02009f0:	b1450513          	addi	a0,a0,-1260 # ffffffffc0205500 <commands+0x4b0>
ffffffffc02009f4:	fe2ff0ef          	jal	ra,ffffffffc02001d6 <__panic>
            cprintf("AMO address misaligned\n");
ffffffffc02009f8:	00005517          	auipc	a0,0x5
ffffffffc02009fc:	92850513          	addi	a0,a0,-1752 # ffffffffc0205320 <commands+0x2d0>
ffffffffc0200a00:	b779                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Store/AMO access fault\n");
ffffffffc0200a02:	00005517          	auipc	a0,0x5
ffffffffc0200a06:	93650513          	addi	a0,a0,-1738 # ffffffffc0205338 <commands+0x2e8>
ffffffffc0200a0a:	ec6ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200a0e:	8522                	mv	a0,s0
ffffffffc0200a10:	bd1ff0ef          	jal	ra,ffffffffc02005e0 <pgfault_handler>
ffffffffc0200a14:	84aa                	mv	s1,a0
ffffffffc0200a16:	d13d                	beqz	a0,ffffffffc020097c <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200a18:	8522                	mv	a0,s0
ffffffffc0200a1a:	e21ff0ef          	jal	ra,ffffffffc020083a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a1e:	86a6                	mv	a3,s1
ffffffffc0200a20:	00005617          	auipc	a2,0x5
ffffffffc0200a24:	8e060613          	addi	a2,a2,-1824 # ffffffffc0205300 <commands+0x2b0>
ffffffffc0200a28:	0bd00593          	li	a1,189
ffffffffc0200a2c:	00005517          	auipc	a0,0x5
ffffffffc0200a30:	ad450513          	addi	a0,a0,-1324 # ffffffffc0205500 <commands+0x4b0>
ffffffffc0200a34:	fa2ff0ef          	jal	ra,ffffffffc02001d6 <__panic>
            cprintf("Environment call from U-mode\n");
ffffffffc0200a38:	00005517          	auipc	a0,0x5
ffffffffc0200a3c:	91850513          	addi	a0,a0,-1768 # ffffffffc0205350 <commands+0x300>
ffffffffc0200a40:	b7b9                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Environment call from S-mode\n");
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	92e50513          	addi	a0,a0,-1746 # ffffffffc0205370 <commands+0x320>
ffffffffc0200a4a:	b791                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Environment call from H-mode\n");
ffffffffc0200a4c:	00005517          	auipc	a0,0x5
ffffffffc0200a50:	94450513          	addi	a0,a0,-1724 # ffffffffc0205390 <commands+0x340>
ffffffffc0200a54:	bf2d                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Environment call from M-mode\n");
ffffffffc0200a56:	00005517          	auipc	a0,0x5
ffffffffc0200a5a:	95a50513          	addi	a0,a0,-1702 # ffffffffc02053b0 <commands+0x360>
ffffffffc0200a5e:	bf05                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200a60:	00005517          	auipc	a0,0x5
ffffffffc0200a64:	97050513          	addi	a0,a0,-1680 # ffffffffc02053d0 <commands+0x380>
ffffffffc0200a68:	b71d                	j	ffffffffc020098e <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200a6a:	00005517          	auipc	a0,0x5
ffffffffc0200a6e:	97e50513          	addi	a0,a0,-1666 # ffffffffc02053e8 <commands+0x398>
ffffffffc0200a72:	e5eff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200a76:	8522                	mv	a0,s0
ffffffffc0200a78:	b69ff0ef          	jal	ra,ffffffffc02005e0 <pgfault_handler>
ffffffffc0200a7c:	84aa                	mv	s1,a0
ffffffffc0200a7e:	ee050fe3          	beqz	a0,ffffffffc020097c <exception_handler+0x3e>
                print_trapframe(tf);
ffffffffc0200a82:	8522                	mv	a0,s0
ffffffffc0200a84:	db7ff0ef          	jal	ra,ffffffffc020083a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200a88:	86a6                	mv	a3,s1
ffffffffc0200a8a:	00005617          	auipc	a2,0x5
ffffffffc0200a8e:	87660613          	addi	a2,a2,-1930 # ffffffffc0205300 <commands+0x2b0>
ffffffffc0200a92:	0d300593          	li	a1,211
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	a6a50513          	addi	a0,a0,-1430 # ffffffffc0205500 <commands+0x4b0>
ffffffffc0200a9e:	f38ff0ef          	jal	ra,ffffffffc02001d6 <__panic>
}
ffffffffc0200aa2:	6442                	ld	s0,16(sp)
ffffffffc0200aa4:	60e2                	ld	ra,24(sp)
ffffffffc0200aa6:	64a2                	ld	s1,8(sp)
ffffffffc0200aa8:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200aaa:	d91ff06f          	j	ffffffffc020083a <print_trapframe>
ffffffffc0200aae:	d8dff06f          	j	ffffffffc020083a <print_trapframe>
                print_trapframe(tf);
ffffffffc0200ab2:	8522                	mv	a0,s0
ffffffffc0200ab4:	d87ff0ef          	jal	ra,ffffffffc020083a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200ab8:	86a6                	mv	a3,s1
ffffffffc0200aba:	00005617          	auipc	a2,0x5
ffffffffc0200abe:	84660613          	addi	a2,a2,-1978 # ffffffffc0205300 <commands+0x2b0>
ffffffffc0200ac2:	0da00593          	li	a1,218
ffffffffc0200ac6:	00005517          	auipc	a0,0x5
ffffffffc0200aca:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0205500 <commands+0x4b0>
ffffffffc0200ace:	f08ff0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0200ad2 <trap>:
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf) {
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200ad2:	11853783          	ld	a5,280(a0)
ffffffffc0200ad6:	0007c463          	bltz	a5,ffffffffc0200ade <trap+0xc>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200ada:	e65ff06f          	j	ffffffffc020093e <exception_handler>
        interrupt_handler(tf);
ffffffffc0200ade:	dbfff06f          	j	ffffffffc020089c <interrupt_handler>
	...

ffffffffc0200ae4 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200ae4:	14011073          	csrw	sscratch,sp
ffffffffc0200ae8:	712d                	addi	sp,sp,-288
ffffffffc0200aea:	e406                	sd	ra,8(sp)
ffffffffc0200aec:	ec0e                	sd	gp,24(sp)
ffffffffc0200aee:	f012                	sd	tp,32(sp)
ffffffffc0200af0:	f416                	sd	t0,40(sp)
ffffffffc0200af2:	f81a                	sd	t1,48(sp)
ffffffffc0200af4:	fc1e                	sd	t2,56(sp)
ffffffffc0200af6:	e0a2                	sd	s0,64(sp)
ffffffffc0200af8:	e4a6                	sd	s1,72(sp)
ffffffffc0200afa:	e8aa                	sd	a0,80(sp)
ffffffffc0200afc:	ecae                	sd	a1,88(sp)
ffffffffc0200afe:	f0b2                	sd	a2,96(sp)
ffffffffc0200b00:	f4b6                	sd	a3,104(sp)
ffffffffc0200b02:	f8ba                	sd	a4,112(sp)
ffffffffc0200b04:	fcbe                	sd	a5,120(sp)
ffffffffc0200b06:	e142                	sd	a6,128(sp)
ffffffffc0200b08:	e546                	sd	a7,136(sp)
ffffffffc0200b0a:	e94a                	sd	s2,144(sp)
ffffffffc0200b0c:	ed4e                	sd	s3,152(sp)
ffffffffc0200b0e:	f152                	sd	s4,160(sp)
ffffffffc0200b10:	f556                	sd	s5,168(sp)
ffffffffc0200b12:	f95a                	sd	s6,176(sp)
ffffffffc0200b14:	fd5e                	sd	s7,184(sp)
ffffffffc0200b16:	e1e2                	sd	s8,192(sp)
ffffffffc0200b18:	e5e6                	sd	s9,200(sp)
ffffffffc0200b1a:	e9ea                	sd	s10,208(sp)
ffffffffc0200b1c:	edee                	sd	s11,216(sp)
ffffffffc0200b1e:	f1f2                	sd	t3,224(sp)
ffffffffc0200b20:	f5f6                	sd	t4,232(sp)
ffffffffc0200b22:	f9fa                	sd	t5,240(sp)
ffffffffc0200b24:	fdfe                	sd	t6,248(sp)
ffffffffc0200b26:	14002473          	csrr	s0,sscratch
ffffffffc0200b2a:	100024f3          	csrr	s1,sstatus
ffffffffc0200b2e:	14102973          	csrr	s2,sepc
ffffffffc0200b32:	143029f3          	csrr	s3,stval
ffffffffc0200b36:	14202a73          	csrr	s4,scause
ffffffffc0200b3a:	e822                	sd	s0,16(sp)
ffffffffc0200b3c:	e226                	sd	s1,256(sp)
ffffffffc0200b3e:	e64a                	sd	s2,264(sp)
ffffffffc0200b40:	ea4e                	sd	s3,272(sp)
ffffffffc0200b42:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200b44:	850a                	mv	a0,sp
    jal trap
ffffffffc0200b46:	f8dff0ef          	jal	ra,ffffffffc0200ad2 <trap>

ffffffffc0200b4a <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200b4a:	6492                	ld	s1,256(sp)
ffffffffc0200b4c:	6932                	ld	s2,264(sp)
ffffffffc0200b4e:	10049073          	csrw	sstatus,s1
ffffffffc0200b52:	14191073          	csrw	sepc,s2
ffffffffc0200b56:	60a2                	ld	ra,8(sp)
ffffffffc0200b58:	61e2                	ld	gp,24(sp)
ffffffffc0200b5a:	7202                	ld	tp,32(sp)
ffffffffc0200b5c:	72a2                	ld	t0,40(sp)
ffffffffc0200b5e:	7342                	ld	t1,48(sp)
ffffffffc0200b60:	73e2                	ld	t2,56(sp)
ffffffffc0200b62:	6406                	ld	s0,64(sp)
ffffffffc0200b64:	64a6                	ld	s1,72(sp)
ffffffffc0200b66:	6546                	ld	a0,80(sp)
ffffffffc0200b68:	65e6                	ld	a1,88(sp)
ffffffffc0200b6a:	7606                	ld	a2,96(sp)
ffffffffc0200b6c:	76a6                	ld	a3,104(sp)
ffffffffc0200b6e:	7746                	ld	a4,112(sp)
ffffffffc0200b70:	77e6                	ld	a5,120(sp)
ffffffffc0200b72:	680a                	ld	a6,128(sp)
ffffffffc0200b74:	68aa                	ld	a7,136(sp)
ffffffffc0200b76:	694a                	ld	s2,144(sp)
ffffffffc0200b78:	69ea                	ld	s3,152(sp)
ffffffffc0200b7a:	7a0a                	ld	s4,160(sp)
ffffffffc0200b7c:	7aaa                	ld	s5,168(sp)
ffffffffc0200b7e:	7b4a                	ld	s6,176(sp)
ffffffffc0200b80:	7bea                	ld	s7,184(sp)
ffffffffc0200b82:	6c0e                	ld	s8,192(sp)
ffffffffc0200b84:	6cae                	ld	s9,200(sp)
ffffffffc0200b86:	6d4e                	ld	s10,208(sp)
ffffffffc0200b88:	6dee                	ld	s11,216(sp)
ffffffffc0200b8a:	7e0e                	ld	t3,224(sp)
ffffffffc0200b8c:	7eae                	ld	t4,232(sp)
ffffffffc0200b8e:	7f4e                	ld	t5,240(sp)
ffffffffc0200b90:	7fee                	ld	t6,248(sp)
ffffffffc0200b92:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200b94:	10200073          	sret

ffffffffc0200b98 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200b98:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200b9a:	bf45                	j	ffffffffc0200b4a <__trapret>
	...

ffffffffc0200b9e <pa2page.part.4>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
ffffffffc0200b9e:	1141                	addi	sp,sp,-16
    if (PPN(pa) >= npage) {
        panic("pa2page called with invalid pa");
ffffffffc0200ba0:	00005617          	auipc	a2,0x5
ffffffffc0200ba4:	d2860613          	addi	a2,a2,-728 # ffffffffc02058c8 <commands+0x878>
ffffffffc0200ba8:	06300593          	li	a1,99
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	d3c50513          	addi	a0,a0,-708 # ffffffffc02058e8 <commands+0x898>
pa2page(uintptr_t pa) {
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0200bb6:	e20ff0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0200bba <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0200bba:	715d                	addi	sp,sp,-80
ffffffffc0200bbc:	e0a2                	sd	s0,64(sp)
ffffffffc0200bbe:	fc26                	sd	s1,56(sp)
ffffffffc0200bc0:	f84a                	sd	s2,48(sp)
ffffffffc0200bc2:	f44e                	sd	s3,40(sp)
ffffffffc0200bc4:	f052                	sd	s4,32(sp)
ffffffffc0200bc6:	ec56                	sd	s5,24(sp)
ffffffffc0200bc8:	e486                	sd	ra,72(sp)
ffffffffc0200bca:	842a                	mv	s0,a0
ffffffffc0200bcc:	00016497          	auipc	s1,0x16
ffffffffc0200bd0:	90c48493          	addi	s1,s1,-1780 # ffffffffc02164d8 <pmm_manager>
        {
            page = pmm_manager->alloc_pages(n);
        }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200bd4:	4985                	li	s3,1
ffffffffc0200bd6:	00016a17          	auipc	s4,0x16
ffffffffc0200bda:	8d2a0a13          	addi	s4,s4,-1838 # ffffffffc02164a8 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0200bde:	0005091b          	sext.w	s2,a0
ffffffffc0200be2:	00016a97          	auipc	s5,0x16
ffffffffc0200be6:	926a8a93          	addi	s5,s5,-1754 # ffffffffc0216508 <check_mm_struct>
ffffffffc0200bea:	a00d                	j	ffffffffc0200c0c <alloc_pages+0x52>
            page = pmm_manager->alloc_pages(n);
ffffffffc0200bec:	609c                	ld	a5,0(s1)
ffffffffc0200bee:	6f9c                	ld	a5,24(a5)
ffffffffc0200bf0:	9782                	jalr	a5
        swap_out(check_mm_struct, n, 0);
ffffffffc0200bf2:	4601                	li	a2,0
ffffffffc0200bf4:	85ca                	mv	a1,s2
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200bf6:	ed0d                	bnez	a0,ffffffffc0200c30 <alloc_pages+0x76>
ffffffffc0200bf8:	0289ec63          	bltu	s3,s0,ffffffffc0200c30 <alloc_pages+0x76>
ffffffffc0200bfc:	000a2783          	lw	a5,0(s4)
ffffffffc0200c00:	2781                	sext.w	a5,a5
ffffffffc0200c02:	c79d                	beqz	a5,ffffffffc0200c30 <alloc_pages+0x76>
        swap_out(check_mm_struct, n, 0);
ffffffffc0200c04:	000ab503          	ld	a0,0(s5)
ffffffffc0200c08:	778020ef          	jal	ra,ffffffffc0203380 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200c0c:	100027f3          	csrr	a5,sstatus
ffffffffc0200c10:	8b89                	andi	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0200c12:	8522                	mv	a0,s0
ffffffffc0200c14:	dfe1                	beqz	a5,ffffffffc0200bec <alloc_pages+0x32>
        intr_disable();
ffffffffc0200c16:	9c5ff0ef          	jal	ra,ffffffffc02005da <intr_disable>
ffffffffc0200c1a:	609c                	ld	a5,0(s1)
ffffffffc0200c1c:	8522                	mv	a0,s0
ffffffffc0200c1e:	6f9c                	ld	a5,24(a5)
ffffffffc0200c20:	9782                	jalr	a5
ffffffffc0200c22:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200c24:	9b1ff0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
ffffffffc0200c28:	6522                	ld	a0,8(sp)
        swap_out(check_mm_struct, n, 0);
ffffffffc0200c2a:	4601                	li	a2,0
ffffffffc0200c2c:	85ca                	mv	a1,s2
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200c2e:	d569                	beqz	a0,ffffffffc0200bf8 <alloc_pages+0x3e>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0200c30:	60a6                	ld	ra,72(sp)
ffffffffc0200c32:	6406                	ld	s0,64(sp)
ffffffffc0200c34:	74e2                	ld	s1,56(sp)
ffffffffc0200c36:	7942                	ld	s2,48(sp)
ffffffffc0200c38:	79a2                	ld	s3,40(sp)
ffffffffc0200c3a:	7a02                	ld	s4,32(sp)
ffffffffc0200c3c:	6ae2                	ld	s5,24(sp)
ffffffffc0200c3e:	6161                	addi	sp,sp,80
ffffffffc0200c40:	8082                	ret

ffffffffc0200c42 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200c42:	100027f3          	csrr	a5,sstatus
ffffffffc0200c46:	8b89                	andi	a5,a5,2
ffffffffc0200c48:	eb89                	bnez	a5,ffffffffc0200c5a <free_pages+0x18>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200c4a:	00016797          	auipc	a5,0x16
ffffffffc0200c4e:	88e78793          	addi	a5,a5,-1906 # ffffffffc02164d8 <pmm_manager>
ffffffffc0200c52:	639c                	ld	a5,0(a5)
ffffffffc0200c54:	0207b303          	ld	t1,32(a5)
ffffffffc0200c58:	8302                	jr	t1
void free_pages(struct Page *base, size_t n) {
ffffffffc0200c5a:	1101                	addi	sp,sp,-32
ffffffffc0200c5c:	ec06                	sd	ra,24(sp)
ffffffffc0200c5e:	e822                	sd	s0,16(sp)
ffffffffc0200c60:	e426                	sd	s1,8(sp)
ffffffffc0200c62:	842a                	mv	s0,a0
ffffffffc0200c64:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200c66:	975ff0ef          	jal	ra,ffffffffc02005da <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200c6a:	00016797          	auipc	a5,0x16
ffffffffc0200c6e:	86e78793          	addi	a5,a5,-1938 # ffffffffc02164d8 <pmm_manager>
ffffffffc0200c72:	639c                	ld	a5,0(a5)
ffffffffc0200c74:	85a6                	mv	a1,s1
ffffffffc0200c76:	8522                	mv	a0,s0
ffffffffc0200c78:	739c                	ld	a5,32(a5)
ffffffffc0200c7a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200c7c:	6442                	ld	s0,16(sp)
ffffffffc0200c7e:	60e2                	ld	ra,24(sp)
ffffffffc0200c80:	64a2                	ld	s1,8(sp)
ffffffffc0200c82:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200c84:	951ff06f          	j	ffffffffc02005d4 <intr_enable>

ffffffffc0200c88 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200c88:	100027f3          	csrr	a5,sstatus
ffffffffc0200c8c:	8b89                	andi	a5,a5,2
ffffffffc0200c8e:	eb89                	bnez	a5,ffffffffc0200ca0 <nr_free_pages+0x18>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200c90:	00016797          	auipc	a5,0x16
ffffffffc0200c94:	84878793          	addi	a5,a5,-1976 # ffffffffc02164d8 <pmm_manager>
ffffffffc0200c98:	639c                	ld	a5,0(a5)
ffffffffc0200c9a:	0287b303          	ld	t1,40(a5)
ffffffffc0200c9e:	8302                	jr	t1
size_t nr_free_pages(void) {
ffffffffc0200ca0:	1141                	addi	sp,sp,-16
ffffffffc0200ca2:	e406                	sd	ra,8(sp)
ffffffffc0200ca4:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200ca6:	935ff0ef          	jal	ra,ffffffffc02005da <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0200caa:	00016797          	auipc	a5,0x16
ffffffffc0200cae:	82e78793          	addi	a5,a5,-2002 # ffffffffc02164d8 <pmm_manager>
ffffffffc0200cb2:	639c                	ld	a5,0(a5)
ffffffffc0200cb4:	779c                	ld	a5,40(a5)
ffffffffc0200cb6:	9782                	jalr	a5
ffffffffc0200cb8:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200cba:	91bff0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0200cbe:	8522                	mv	a0,s0
ffffffffc0200cc0:	60a2                	ld	ra,8(sp)
ffffffffc0200cc2:	6402                	ld	s0,0(sp)
ffffffffc0200cc4:	0141                	addi	sp,sp,16
ffffffffc0200cc6:	8082                	ret

ffffffffc0200cc8 <get_pte>:
// parameter:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200cc8:	7139                	addi	sp,sp,-64
ffffffffc0200cca:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0200ccc:	01e5d493          	srli	s1,a1,0x1e
ffffffffc0200cd0:	1ff4f493          	andi	s1,s1,511
ffffffffc0200cd4:	048e                	slli	s1,s1,0x3
ffffffffc0200cd6:	94aa                	add	s1,s1,a0
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200cd8:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200cda:	f04a                	sd	s2,32(sp)
ffffffffc0200cdc:	ec4e                	sd	s3,24(sp)
ffffffffc0200cde:	e852                	sd	s4,16(sp)
ffffffffc0200ce0:	fc06                	sd	ra,56(sp)
ffffffffc0200ce2:	f822                	sd	s0,48(sp)
ffffffffc0200ce4:	e456                	sd	s5,8(sp)
ffffffffc0200ce6:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200ce8:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200cec:	892e                	mv	s2,a1
ffffffffc0200cee:	8a32                	mv	s4,a2
ffffffffc0200cf0:	00015997          	auipc	s3,0x15
ffffffffc0200cf4:	79898993          	addi	s3,s3,1944 # ffffffffc0216488 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200cf8:	e7bd                	bnez	a5,ffffffffc0200d66 <get_pte+0x9e>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0200cfa:	12060c63          	beqz	a2,ffffffffc0200e32 <get_pte+0x16a>
ffffffffc0200cfe:	4505                	li	a0,1
ffffffffc0200d00:	ebbff0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0200d04:	842a                	mv	s0,a0
ffffffffc0200d06:	12050663          	beqz	a0,ffffffffc0200e32 <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0200d0a:	00015b17          	auipc	s6,0x15
ffffffffc0200d0e:	7e6b0b13          	addi	s6,s6,2022 # ffffffffc02164f0 <pages>
ffffffffc0200d12:	000b3503          	ld	a0,0(s6)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc0200d16:	4785                	li	a5,1
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200d18:	00015997          	auipc	s3,0x15
ffffffffc0200d1c:	77098993          	addi	s3,s3,1904 # ffffffffc0216488 <npage>
    return page - pages + nbase;
ffffffffc0200d20:	40a40533          	sub	a0,s0,a0
ffffffffc0200d24:	00080ab7          	lui	s5,0x80
ffffffffc0200d28:	8519                	srai	a0,a0,0x6
ffffffffc0200d2a:	0009b703          	ld	a4,0(s3)
    page->ref = val;
ffffffffc0200d2e:	c01c                	sw	a5,0(s0)
ffffffffc0200d30:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0200d32:	9556                	add	a0,a0,s5
ffffffffc0200d34:	83b1                	srli	a5,a5,0xc
ffffffffc0200d36:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d38:	0532                	slli	a0,a0,0xc
ffffffffc0200d3a:	14e7f363          	bleu	a4,a5,ffffffffc0200e80 <get_pte+0x1b8>
ffffffffc0200d3e:	00015797          	auipc	a5,0x15
ffffffffc0200d42:	7a278793          	addi	a5,a5,1954 # ffffffffc02164e0 <va_pa_offset>
ffffffffc0200d46:	639c                	ld	a5,0(a5)
ffffffffc0200d48:	6605                	lui	a2,0x1
ffffffffc0200d4a:	4581                	li	a1,0
ffffffffc0200d4c:	953e                	add	a0,a0,a5
ffffffffc0200d4e:	543030ef          	jal	ra,ffffffffc0204a90 <memset>
    return page - pages + nbase;
ffffffffc0200d52:	000b3683          	ld	a3,0(s6)
ffffffffc0200d56:	40d406b3          	sub	a3,s0,a3
ffffffffc0200d5a:	8699                	srai	a3,a3,0x6
ffffffffc0200d5c:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vma");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200d5e:	06aa                	slli	a3,a3,0xa
ffffffffc0200d60:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0200d64:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0200d66:	77fd                	lui	a5,0xfffff
ffffffffc0200d68:	068a                	slli	a3,a3,0x2
ffffffffc0200d6a:	0009b703          	ld	a4,0(s3)
ffffffffc0200d6e:	8efd                	and	a3,a3,a5
ffffffffc0200d70:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200d74:	0ce7f163          	bleu	a4,a5,ffffffffc0200e36 <get_pte+0x16e>
ffffffffc0200d78:	00015a97          	auipc	s5,0x15
ffffffffc0200d7c:	768a8a93          	addi	s5,s5,1896 # ffffffffc02164e0 <va_pa_offset>
ffffffffc0200d80:	000ab403          	ld	s0,0(s5)
ffffffffc0200d84:	01595793          	srli	a5,s2,0x15
ffffffffc0200d88:	1ff7f793          	andi	a5,a5,511
ffffffffc0200d8c:	96a2                	add	a3,a3,s0
ffffffffc0200d8e:	00379413          	slli	s0,a5,0x3
ffffffffc0200d92:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V)) {
ffffffffc0200d94:	6014                	ld	a3,0(s0)
ffffffffc0200d96:	0016f793          	andi	a5,a3,1
ffffffffc0200d9a:	e3ad                	bnez	a5,ffffffffc0200dfc <get_pte+0x134>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0200d9c:	080a0b63          	beqz	s4,ffffffffc0200e32 <get_pte+0x16a>
ffffffffc0200da0:	4505                	li	a0,1
ffffffffc0200da2:	e19ff0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0200da6:	84aa                	mv	s1,a0
ffffffffc0200da8:	c549                	beqz	a0,ffffffffc0200e32 <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0200daa:	00015b17          	auipc	s6,0x15
ffffffffc0200dae:	746b0b13          	addi	s6,s6,1862 # ffffffffc02164f0 <pages>
ffffffffc0200db2:	000b3503          	ld	a0,0(s6)
    page->ref = val;
ffffffffc0200db6:	4785                	li	a5,1
    return page - pages + nbase;
ffffffffc0200db8:	00080a37          	lui	s4,0x80
ffffffffc0200dbc:	40a48533          	sub	a0,s1,a0
ffffffffc0200dc0:	8519                	srai	a0,a0,0x6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200dc2:	0009b703          	ld	a4,0(s3)
    page->ref = val;
ffffffffc0200dc6:	c09c                	sw	a5,0(s1)
ffffffffc0200dc8:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0200dca:	9552                	add	a0,a0,s4
ffffffffc0200dcc:	83b1                	srli	a5,a5,0xc
ffffffffc0200dce:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200dd0:	0532                	slli	a0,a0,0xc
ffffffffc0200dd2:	08e7fa63          	bleu	a4,a5,ffffffffc0200e66 <get_pte+0x19e>
ffffffffc0200dd6:	000ab783          	ld	a5,0(s5)
ffffffffc0200dda:	6605                	lui	a2,0x1
ffffffffc0200ddc:	4581                	li	a1,0
ffffffffc0200dde:	953e                	add	a0,a0,a5
ffffffffc0200de0:	4b1030ef          	jal	ra,ffffffffc0204a90 <memset>
    return page - pages + nbase;
ffffffffc0200de4:	000b3683          	ld	a3,0(s6)
ffffffffc0200de8:	40d486b3          	sub	a3,s1,a3
ffffffffc0200dec:	8699                	srai	a3,a3,0x6
ffffffffc0200dee:	96d2                	add	a3,a3,s4
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200df0:	06aa                	slli	a3,a3,0xa
ffffffffc0200df2:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0200df6:	e014                	sd	a3,0(s0)
ffffffffc0200df8:	0009b703          	ld	a4,0(s3)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0200dfc:	068a                	slli	a3,a3,0x2
ffffffffc0200dfe:	757d                	lui	a0,0xfffff
ffffffffc0200e00:	8ee9                	and	a3,a3,a0
ffffffffc0200e02:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200e06:	04e7f463          	bleu	a4,a5,ffffffffc0200e4e <get_pte+0x186>
ffffffffc0200e0a:	000ab503          	ld	a0,0(s5)
ffffffffc0200e0e:	00c95793          	srli	a5,s2,0xc
ffffffffc0200e12:	1ff7f793          	andi	a5,a5,511
ffffffffc0200e16:	96aa                	add	a3,a3,a0
ffffffffc0200e18:	00379513          	slli	a0,a5,0x3
ffffffffc0200e1c:	9536                	add	a0,a0,a3
}
ffffffffc0200e1e:	70e2                	ld	ra,56(sp)
ffffffffc0200e20:	7442                	ld	s0,48(sp)
ffffffffc0200e22:	74a2                	ld	s1,40(sp)
ffffffffc0200e24:	7902                	ld	s2,32(sp)
ffffffffc0200e26:	69e2                	ld	s3,24(sp)
ffffffffc0200e28:	6a42                	ld	s4,16(sp)
ffffffffc0200e2a:	6aa2                	ld	s5,8(sp)
ffffffffc0200e2c:	6b02                	ld	s6,0(sp)
ffffffffc0200e2e:	6121                	addi	sp,sp,64
ffffffffc0200e30:	8082                	ret
            return NULL;
ffffffffc0200e32:	4501                	li	a0,0
ffffffffc0200e34:	b7ed                	j	ffffffffc0200e1e <get_pte+0x156>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0200e36:	00005617          	auipc	a2,0x5
ffffffffc0200e3a:	a5a60613          	addi	a2,a2,-1446 # ffffffffc0205890 <commands+0x840>
ffffffffc0200e3e:	0e400593          	li	a1,228
ffffffffc0200e42:	00005517          	auipc	a0,0x5
ffffffffc0200e46:	a7650513          	addi	a0,a0,-1418 # ffffffffc02058b8 <commands+0x868>
ffffffffc0200e4a:	b8cff0ef          	jal	ra,ffffffffc02001d6 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0200e4e:	00005617          	auipc	a2,0x5
ffffffffc0200e52:	a4260613          	addi	a2,a2,-1470 # ffffffffc0205890 <commands+0x840>
ffffffffc0200e56:	0ef00593          	li	a1,239
ffffffffc0200e5a:	00005517          	auipc	a0,0x5
ffffffffc0200e5e:	a5e50513          	addi	a0,a0,-1442 # ffffffffc02058b8 <commands+0x868>
ffffffffc0200e62:	b74ff0ef          	jal	ra,ffffffffc02001d6 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200e66:	86aa                	mv	a3,a0
ffffffffc0200e68:	00005617          	auipc	a2,0x5
ffffffffc0200e6c:	a2860613          	addi	a2,a2,-1496 # ffffffffc0205890 <commands+0x840>
ffffffffc0200e70:	0ec00593          	li	a1,236
ffffffffc0200e74:	00005517          	auipc	a0,0x5
ffffffffc0200e78:	a4450513          	addi	a0,a0,-1468 # ffffffffc02058b8 <commands+0x868>
ffffffffc0200e7c:	b5aff0ef          	jal	ra,ffffffffc02001d6 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200e80:	86aa                	mv	a3,a0
ffffffffc0200e82:	00005617          	auipc	a2,0x5
ffffffffc0200e86:	a0e60613          	addi	a2,a2,-1522 # ffffffffc0205890 <commands+0x840>
ffffffffc0200e8a:	0e100593          	li	a1,225
ffffffffc0200e8e:	00005517          	auipc	a0,0x5
ffffffffc0200e92:	a2a50513          	addi	a0,a0,-1494 # ffffffffc02058b8 <commands+0x868>
ffffffffc0200e96:	b40ff0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0200e9a <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0200e9a:	1141                	addi	sp,sp,-16
ffffffffc0200e9c:	e022                	sd	s0,0(sp)
ffffffffc0200e9e:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200ea0:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0200ea2:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200ea4:	e25ff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0200ea8:	c011                	beqz	s0,ffffffffc0200eac <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0200eaa:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0200eac:	c129                	beqz	a0,ffffffffc0200eee <get_page+0x54>
ffffffffc0200eae:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0200eb0:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0200eb2:	0017f713          	andi	a4,a5,1
ffffffffc0200eb6:	e709                	bnez	a4,ffffffffc0200ec0 <get_page+0x26>
}
ffffffffc0200eb8:	60a2                	ld	ra,8(sp)
ffffffffc0200eba:	6402                	ld	s0,0(sp)
ffffffffc0200ebc:	0141                	addi	sp,sp,16
ffffffffc0200ebe:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0200ec0:	00015717          	auipc	a4,0x15
ffffffffc0200ec4:	5c870713          	addi	a4,a4,1480 # ffffffffc0216488 <npage>
ffffffffc0200ec8:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0200eca:	078a                	slli	a5,a5,0x2
ffffffffc0200ecc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200ece:	02e7f563          	bleu	a4,a5,ffffffffc0200ef8 <get_page+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0200ed2:	00015717          	auipc	a4,0x15
ffffffffc0200ed6:	61e70713          	addi	a4,a4,1566 # ffffffffc02164f0 <pages>
ffffffffc0200eda:	6308                	ld	a0,0(a4)
ffffffffc0200edc:	60a2                	ld	ra,8(sp)
ffffffffc0200ede:	6402                	ld	s0,0(sp)
ffffffffc0200ee0:	fff80737          	lui	a4,0xfff80
ffffffffc0200ee4:	97ba                	add	a5,a5,a4
ffffffffc0200ee6:	079a                	slli	a5,a5,0x6
ffffffffc0200ee8:	953e                	add	a0,a0,a5
ffffffffc0200eea:	0141                	addi	sp,sp,16
ffffffffc0200eec:	8082                	ret
ffffffffc0200eee:	60a2                	ld	ra,8(sp)
ffffffffc0200ef0:	6402                	ld	s0,0(sp)
    return NULL;
ffffffffc0200ef2:	4501                	li	a0,0
}
ffffffffc0200ef4:	0141                	addi	sp,sp,16
ffffffffc0200ef6:	8082                	ret
ffffffffc0200ef8:	ca7ff0ef          	jal	ra,ffffffffc0200b9e <pa2page.part.4>

ffffffffc0200efc <page_remove>:
    }
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0200efc:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200efe:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0200f00:	e426                	sd	s1,8(sp)
ffffffffc0200f02:	ec06                	sd	ra,24(sp)
ffffffffc0200f04:	e822                	sd	s0,16(sp)
ffffffffc0200f06:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0200f08:	dc1ff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
    if (ptep != NULL) {
ffffffffc0200f0c:	c511                	beqz	a0,ffffffffc0200f18 <page_remove+0x1c>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0200f0e:	611c                	ld	a5,0(a0)
ffffffffc0200f10:	842a                	mv	s0,a0
ffffffffc0200f12:	0017f713          	andi	a4,a5,1
ffffffffc0200f16:	e711                	bnez	a4,ffffffffc0200f22 <page_remove+0x26>
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0200f18:	60e2                	ld	ra,24(sp)
ffffffffc0200f1a:	6442                	ld	s0,16(sp)
ffffffffc0200f1c:	64a2                	ld	s1,8(sp)
ffffffffc0200f1e:	6105                	addi	sp,sp,32
ffffffffc0200f20:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0200f22:	00015717          	auipc	a4,0x15
ffffffffc0200f26:	56670713          	addi	a4,a4,1382 # ffffffffc0216488 <npage>
ffffffffc0200f2a:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0200f2c:	078a                	slli	a5,a5,0x2
ffffffffc0200f2e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200f30:	02e7fe63          	bleu	a4,a5,ffffffffc0200f6c <page_remove+0x70>
    return &pages[PPN(pa) - nbase];
ffffffffc0200f34:	00015717          	auipc	a4,0x15
ffffffffc0200f38:	5bc70713          	addi	a4,a4,1468 # ffffffffc02164f0 <pages>
ffffffffc0200f3c:	6308                	ld	a0,0(a4)
ffffffffc0200f3e:	fff80737          	lui	a4,0xfff80
ffffffffc0200f42:	97ba                	add	a5,a5,a4
ffffffffc0200f44:	079a                	slli	a5,a5,0x6
ffffffffc0200f46:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0200f48:	411c                	lw	a5,0(a0)
ffffffffc0200f4a:	fff7871b          	addiw	a4,a5,-1
ffffffffc0200f4e:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0200f50:	cb11                	beqz	a4,ffffffffc0200f64 <page_remove+0x68>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0200f52:	00043023          	sd	zero,0(s0)
// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0200f56:	12048073          	sfence.vma	s1
}
ffffffffc0200f5a:	60e2                	ld	ra,24(sp)
ffffffffc0200f5c:	6442                	ld	s0,16(sp)
ffffffffc0200f5e:	64a2                	ld	s1,8(sp)
ffffffffc0200f60:	6105                	addi	sp,sp,32
ffffffffc0200f62:	8082                	ret
            free_page(page);
ffffffffc0200f64:	4585                	li	a1,1
ffffffffc0200f66:	cddff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
ffffffffc0200f6a:	b7e5                	j	ffffffffc0200f52 <page_remove+0x56>
ffffffffc0200f6c:	c33ff0ef          	jal	ra,ffffffffc0200b9e <pa2page.part.4>

ffffffffc0200f70 <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0200f70:	7179                	addi	sp,sp,-48
ffffffffc0200f72:	e44e                	sd	s3,8(sp)
ffffffffc0200f74:	89b2                	mv	s3,a2
ffffffffc0200f76:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0200f78:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0200f7a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0200f7c:	85ce                	mv	a1,s3
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0200f7e:	ec26                	sd	s1,24(sp)
ffffffffc0200f80:	f406                	sd	ra,40(sp)
ffffffffc0200f82:	e84a                	sd	s2,16(sp)
ffffffffc0200f84:	e052                	sd	s4,0(sp)
ffffffffc0200f86:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0200f88:	d41ff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
    if (ptep == NULL) {
ffffffffc0200f8c:	cd49                	beqz	a0,ffffffffc0201026 <page_insert+0xb6>
    page->ref += 1;
ffffffffc0200f8e:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc0200f90:	611c                	ld	a5,0(a0)
ffffffffc0200f92:	892a                	mv	s2,a0
ffffffffc0200f94:	0016871b          	addiw	a4,a3,1
ffffffffc0200f98:	c018                	sw	a4,0(s0)
ffffffffc0200f9a:	0017f713          	andi	a4,a5,1
ffffffffc0200f9e:	ef05                	bnez	a4,ffffffffc0200fd6 <page_insert+0x66>
ffffffffc0200fa0:	00015797          	auipc	a5,0x15
ffffffffc0200fa4:	55078793          	addi	a5,a5,1360 # ffffffffc02164f0 <pages>
ffffffffc0200fa8:	6398                	ld	a4,0(a5)
    return page - pages + nbase;
ffffffffc0200faa:	8c19                	sub	s0,s0,a4
ffffffffc0200fac:	000806b7          	lui	a3,0x80
ffffffffc0200fb0:	8419                	srai	s0,s0,0x6
ffffffffc0200fb2:	9436                	add	s0,s0,a3
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200fb4:	042a                	slli	s0,s0,0xa
ffffffffc0200fb6:	8c45                	or	s0,s0,s1
ffffffffc0200fb8:	00146413          	ori	s0,s0,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0200fbc:	00893023          	sd	s0,0(s2)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0200fc0:	12098073          	sfence.vma	s3
    return 0;
ffffffffc0200fc4:	4501                	li	a0,0
}
ffffffffc0200fc6:	70a2                	ld	ra,40(sp)
ffffffffc0200fc8:	7402                	ld	s0,32(sp)
ffffffffc0200fca:	64e2                	ld	s1,24(sp)
ffffffffc0200fcc:	6942                	ld	s2,16(sp)
ffffffffc0200fce:	69a2                	ld	s3,8(sp)
ffffffffc0200fd0:	6a02                	ld	s4,0(sp)
ffffffffc0200fd2:	6145                	addi	sp,sp,48
ffffffffc0200fd4:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0200fd6:	00015717          	auipc	a4,0x15
ffffffffc0200fda:	4b270713          	addi	a4,a4,1202 # ffffffffc0216488 <npage>
ffffffffc0200fde:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0200fe0:	078a                	slli	a5,a5,0x2
ffffffffc0200fe2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0200fe4:	04e7f363          	bleu	a4,a5,ffffffffc020102a <page_insert+0xba>
    return &pages[PPN(pa) - nbase];
ffffffffc0200fe8:	00015a17          	auipc	s4,0x15
ffffffffc0200fec:	508a0a13          	addi	s4,s4,1288 # ffffffffc02164f0 <pages>
ffffffffc0200ff0:	000a3703          	ld	a4,0(s4)
ffffffffc0200ff4:	fff80537          	lui	a0,0xfff80
ffffffffc0200ff8:	953e                	add	a0,a0,a5
ffffffffc0200ffa:	051a                	slli	a0,a0,0x6
ffffffffc0200ffc:	953a                	add	a0,a0,a4
        if (p == page) {
ffffffffc0200ffe:	00a40a63          	beq	s0,a0,ffffffffc0201012 <page_insert+0xa2>
    page->ref -= 1;
ffffffffc0201002:	411c                	lw	a5,0(a0)
ffffffffc0201004:	fff7869b          	addiw	a3,a5,-1
ffffffffc0201008:	c114                	sw	a3,0(a0)
        if (page_ref(page) ==
ffffffffc020100a:	c691                	beqz	a3,ffffffffc0201016 <page_insert+0xa6>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020100c:	12098073          	sfence.vma	s3
ffffffffc0201010:	bf69                	j	ffffffffc0200faa <page_insert+0x3a>
ffffffffc0201012:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0201014:	bf59                	j	ffffffffc0200faa <page_insert+0x3a>
            free_page(page);
ffffffffc0201016:	4585                	li	a1,1
ffffffffc0201018:	c2bff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
ffffffffc020101c:	000a3703          	ld	a4,0(s4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201020:	12098073          	sfence.vma	s3
ffffffffc0201024:	b759                	j	ffffffffc0200faa <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0201026:	5571                	li	a0,-4
ffffffffc0201028:	bf79                	j	ffffffffc0200fc6 <page_insert+0x56>
ffffffffc020102a:	b75ff0ef          	jal	ra,ffffffffc0200b9e <pa2page.part.4>

ffffffffc020102e <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020102e:	00006797          	auipc	a5,0x6
ffffffffc0201032:	b3278793          	addi	a5,a5,-1230 # ffffffffc0206b60 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201036:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc0201038:	715d                	addi	sp,sp,-80
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020103a:	00005517          	auipc	a0,0x5
ffffffffc020103e:	8d650513          	addi	a0,a0,-1834 # ffffffffc0205910 <commands+0x8c0>
void pmm_init(void) {
ffffffffc0201042:	e486                	sd	ra,72(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201044:	00015717          	auipc	a4,0x15
ffffffffc0201048:	48f73a23          	sd	a5,1172(a4) # ffffffffc02164d8 <pmm_manager>
void pmm_init(void) {
ffffffffc020104c:	e0a2                	sd	s0,64(sp)
ffffffffc020104e:	fc26                	sd	s1,56(sp)
ffffffffc0201050:	f84a                	sd	s2,48(sp)
ffffffffc0201052:	f44e                	sd	s3,40(sp)
ffffffffc0201054:	f052                	sd	s4,32(sp)
ffffffffc0201056:	ec56                	sd	s5,24(sp)
ffffffffc0201058:	e85a                	sd	s6,16(sp)
ffffffffc020105a:	e45e                	sd	s7,8(sp)
ffffffffc020105c:	e062                	sd	s8,0(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020105e:	00015417          	auipc	s0,0x15
ffffffffc0201062:	47a40413          	addi	s0,s0,1146 # ffffffffc02164d8 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201066:	86aff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    pmm_manager->init();
ffffffffc020106a:	601c                	ld	a5,0(s0)
ffffffffc020106c:	00015497          	auipc	s1,0x15
ffffffffc0201070:	41c48493          	addi	s1,s1,1052 # ffffffffc0216488 <npage>
ffffffffc0201074:	00015917          	auipc	s2,0x15
ffffffffc0201078:	47c90913          	addi	s2,s2,1148 # ffffffffc02164f0 <pages>
ffffffffc020107c:	679c                	ld	a5,8(a5)
ffffffffc020107e:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc0201080:	57f5                	li	a5,-3
ffffffffc0201082:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc0201084:	00005517          	auipc	a0,0x5
ffffffffc0201088:	8a450513          	addi	a0,a0,-1884 # ffffffffc0205928 <commands+0x8d8>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc020108c:	00015717          	auipc	a4,0x15
ffffffffc0201090:	44f73a23          	sd	a5,1108(a4) # ffffffffc02164e0 <va_pa_offset>
    cprintf("physcial memory map:\n");
ffffffffc0201094:	83cff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201098:	46c5                	li	a3,17
ffffffffc020109a:	06ee                	slli	a3,a3,0x1b
ffffffffc020109c:	40100613          	li	a2,1025
ffffffffc02010a0:	16fd                	addi	a3,a3,-1
ffffffffc02010a2:	0656                	slli	a2,a2,0x15
ffffffffc02010a4:	07e005b7          	lui	a1,0x7e00
ffffffffc02010a8:	00005517          	auipc	a0,0x5
ffffffffc02010ac:	89850513          	addi	a0,a0,-1896 # ffffffffc0205940 <commands+0x8f0>
ffffffffc02010b0:	820ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02010b4:	777d                	lui	a4,0xfffff
ffffffffc02010b6:	00016797          	auipc	a5,0x16
ffffffffc02010ba:	54978793          	addi	a5,a5,1353 # ffffffffc02175ff <end+0xfff>
ffffffffc02010be:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc02010c0:	00088737          	lui	a4,0x88
ffffffffc02010c4:	00015697          	auipc	a3,0x15
ffffffffc02010c8:	3ce6b223          	sd	a4,964(a3) # ffffffffc0216488 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02010cc:	00015717          	auipc	a4,0x15
ffffffffc02010d0:	42f73223          	sd	a5,1060(a4) # ffffffffc02164f0 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010d4:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02010d6:	4685                	li	a3,1
ffffffffc02010d8:	fff80837          	lui	a6,0xfff80
ffffffffc02010dc:	a019                	j	ffffffffc02010e2 <pmm_init+0xb4>
ffffffffc02010de:	00093783          	ld	a5,0(s2)
        SetPageReserved(pages + i);
ffffffffc02010e2:	00671613          	slli	a2,a4,0x6
ffffffffc02010e6:	97b2                	add	a5,a5,a2
ffffffffc02010e8:	07a1                	addi	a5,a5,8
ffffffffc02010ea:	40d7b02f          	amoor.d	zero,a3,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02010ee:	6090                	ld	a2,0(s1)
ffffffffc02010f0:	0705                	addi	a4,a4,1
ffffffffc02010f2:	010607b3          	add	a5,a2,a6
ffffffffc02010f6:	fef764e3          	bltu	a4,a5,ffffffffc02010de <pmm_init+0xb0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02010fa:	00093503          	ld	a0,0(s2)
ffffffffc02010fe:	fe0007b7          	lui	a5,0xfe000
ffffffffc0201102:	00661693          	slli	a3,a2,0x6
ffffffffc0201106:	97aa                	add	a5,a5,a0
ffffffffc0201108:	96be                	add	a3,a3,a5
ffffffffc020110a:	c02007b7          	lui	a5,0xc0200
ffffffffc020110e:	7af6ed63          	bltu	a3,a5,ffffffffc02018c8 <pmm_init+0x89a>
ffffffffc0201112:	00015997          	auipc	s3,0x15
ffffffffc0201116:	3ce98993          	addi	s3,s3,974 # ffffffffc02164e0 <va_pa_offset>
ffffffffc020111a:	0009b583          	ld	a1,0(s3)
    if (freemem < mem_end) {
ffffffffc020111e:	47c5                	li	a5,17
ffffffffc0201120:	07ee                	slli	a5,a5,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201122:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end) {
ffffffffc0201124:	02f6f763          	bleu	a5,a3,ffffffffc0201152 <pmm_init+0x124>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201128:	6585                	lui	a1,0x1
ffffffffc020112a:	15fd                	addi	a1,a1,-1
ffffffffc020112c:	96ae                	add	a3,a3,a1
    if (PPN(pa) >= npage) {
ffffffffc020112e:	00c6d713          	srli	a4,a3,0xc
ffffffffc0201132:	48c77a63          	bleu	a2,a4,ffffffffc02015c6 <pmm_init+0x598>
    pmm_manager->init_memmap(base, n);
ffffffffc0201136:	6010                	ld	a2,0(s0)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201138:	75fd                	lui	a1,0xfffff
ffffffffc020113a:	8eed                	and	a3,a3,a1
    return &pages[PPN(pa) - nbase];
ffffffffc020113c:	9742                	add	a4,a4,a6
    pmm_manager->init_memmap(base, n);
ffffffffc020113e:	6a10                	ld	a2,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201140:	40d786b3          	sub	a3,a5,a3
ffffffffc0201144:	071a                	slli	a4,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0201146:	00c6d593          	srli	a1,a3,0xc
ffffffffc020114a:	953a                	add	a0,a0,a4
ffffffffc020114c:	9602                	jalr	a2
ffffffffc020114e:	0009b583          	ld	a1,0(s3)
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0201152:	00005517          	auipc	a0,0x5
ffffffffc0201156:	83e50513          	addi	a0,a0,-1986 # ffffffffc0205990 <commands+0x940>
ffffffffc020115a:	f77fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020115e:	601c                	ld	a5,0(s0)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201160:	00015417          	auipc	s0,0x15
ffffffffc0201164:	32040413          	addi	s0,s0,800 # ffffffffc0216480 <boot_pgdir>
    pmm_manager->check();
ffffffffc0201168:	7b9c                	ld	a5,48(a5)
ffffffffc020116a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020116c:	00005517          	auipc	a0,0x5
ffffffffc0201170:	83c50513          	addi	a0,a0,-1988 # ffffffffc02059a8 <commands+0x958>
ffffffffc0201174:	f5dfe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201178:	00009697          	auipc	a3,0x9
ffffffffc020117c:	e8868693          	addi	a3,a3,-376 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0201180:	00015797          	auipc	a5,0x15
ffffffffc0201184:	30d7b023          	sd	a3,768(a5) # ffffffffc0216480 <boot_pgdir>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201188:	c02007b7          	lui	a5,0xc0200
ffffffffc020118c:	10f6eae3          	bltu	a3,a5,ffffffffc0201aa0 <pmm_init+0xa72>
ffffffffc0201190:	0009b783          	ld	a5,0(s3)
ffffffffc0201194:	8e9d                	sub	a3,a3,a5
ffffffffc0201196:	00015797          	auipc	a5,0x15
ffffffffc020119a:	34d7b923          	sd	a3,850(a5) # ffffffffc02164e8 <boot_cr3>
    // assert(npage <= KMEMSIZE / PGSIZE);
    // The memory starts at 2GB in RISC-V
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();
ffffffffc020119e:	aebff0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02011a2:	6098                	ld	a4,0(s1)
ffffffffc02011a4:	c80007b7          	lui	a5,0xc8000
ffffffffc02011a8:	83b1                	srli	a5,a5,0xc
    nr_free_store=nr_free_pages();
ffffffffc02011aa:	8a2a                	mv	s4,a0
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02011ac:	0ce7eae3          	bltu	a5,a4,ffffffffc0201a80 <pmm_init+0xa52>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02011b0:	6008                	ld	a0,0(s0)
ffffffffc02011b2:	44050463          	beqz	a0,ffffffffc02015fa <pmm_init+0x5cc>
ffffffffc02011b6:	6785                	lui	a5,0x1
ffffffffc02011b8:	17fd                	addi	a5,a5,-1
ffffffffc02011ba:	8fe9                	and	a5,a5,a0
ffffffffc02011bc:	2781                	sext.w	a5,a5
ffffffffc02011be:	42079e63          	bnez	a5,ffffffffc02015fa <pmm_init+0x5cc>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02011c2:	4601                	li	a2,0
ffffffffc02011c4:	4581                	li	a1,0
ffffffffc02011c6:	cd5ff0ef          	jal	ra,ffffffffc0200e9a <get_page>
ffffffffc02011ca:	78051b63          	bnez	a0,ffffffffc0201960 <pmm_init+0x932>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc02011ce:	4505                	li	a0,1
ffffffffc02011d0:	9ebff0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02011d4:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02011d6:	6008                	ld	a0,0(s0)
ffffffffc02011d8:	4681                	li	a3,0
ffffffffc02011da:	4601                	li	a2,0
ffffffffc02011dc:	85d6                	mv	a1,s5
ffffffffc02011de:	d93ff0ef          	jal	ra,ffffffffc0200f70 <page_insert>
ffffffffc02011e2:	7a051f63          	bnez	a0,ffffffffc02019a0 <pmm_init+0x972>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc02011e6:	6008                	ld	a0,0(s0)
ffffffffc02011e8:	4601                	li	a2,0
ffffffffc02011ea:	4581                	li	a1,0
ffffffffc02011ec:	addff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc02011f0:	78050863          	beqz	a0,ffffffffc0201980 <pmm_init+0x952>
    assert(pte2page(*ptep) == p1);
ffffffffc02011f4:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02011f6:	0017f713          	andi	a4,a5,1
ffffffffc02011fa:	3e070463          	beqz	a4,ffffffffc02015e2 <pmm_init+0x5b4>
    if (PPN(pa) >= npage) {
ffffffffc02011fe:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201200:	078a                	slli	a5,a5,0x2
ffffffffc0201202:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201204:	3ce7f163          	bleu	a4,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201208:	00093683          	ld	a3,0(s2)
ffffffffc020120c:	fff80637          	lui	a2,0xfff80
ffffffffc0201210:	97b2                	add	a5,a5,a2
ffffffffc0201212:	079a                	slli	a5,a5,0x6
ffffffffc0201214:	97b6                	add	a5,a5,a3
ffffffffc0201216:	72fa9563          	bne	s5,a5,ffffffffc0201940 <pmm_init+0x912>
    assert(page_ref(p1) == 1);
ffffffffc020121a:	000aab83          	lw	s7,0(s5)
ffffffffc020121e:	4785                	li	a5,1
ffffffffc0201220:	70fb9063          	bne	s7,a5,ffffffffc0201920 <pmm_init+0x8f2>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0201224:	6008                	ld	a0,0(s0)
ffffffffc0201226:	76fd                	lui	a3,0xfffff
ffffffffc0201228:	611c                	ld	a5,0(a0)
ffffffffc020122a:	078a                	slli	a5,a5,0x2
ffffffffc020122c:	8ff5                	and	a5,a5,a3
ffffffffc020122e:	00c7d613          	srli	a2,a5,0xc
ffffffffc0201232:	66e67e63          	bleu	a4,a2,ffffffffc02018ae <pmm_init+0x880>
ffffffffc0201236:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020123a:	97e2                	add	a5,a5,s8
ffffffffc020123c:	0007bb03          	ld	s6,0(a5) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc0201240:	0b0a                	slli	s6,s6,0x2
ffffffffc0201242:	00db7b33          	and	s6,s6,a3
ffffffffc0201246:	00cb5793          	srli	a5,s6,0xc
ffffffffc020124a:	56e7f863          	bleu	a4,a5,ffffffffc02017ba <pmm_init+0x78c>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020124e:	4601                	li	a2,0
ffffffffc0201250:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201252:	9b62                	add	s6,s6,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201254:	a75ff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201258:	0b21                	addi	s6,s6,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020125a:	55651063          	bne	a0,s6,ffffffffc020179a <pmm_init+0x76c>

    p2 = alloc_page();
ffffffffc020125e:	4505                	li	a0,1
ffffffffc0201260:	95bff0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0201264:	8b2a                	mv	s6,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0201266:	6008                	ld	a0,0(s0)
ffffffffc0201268:	46d1                	li	a3,20
ffffffffc020126a:	6605                	lui	a2,0x1
ffffffffc020126c:	85da                	mv	a1,s6
ffffffffc020126e:	d03ff0ef          	jal	ra,ffffffffc0200f70 <page_insert>
ffffffffc0201272:	50051463          	bnez	a0,ffffffffc020177a <pmm_init+0x74c>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0201276:	6008                	ld	a0,0(s0)
ffffffffc0201278:	4601                	li	a2,0
ffffffffc020127a:	6585                	lui	a1,0x1
ffffffffc020127c:	a4dff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc0201280:	4c050d63          	beqz	a0,ffffffffc020175a <pmm_init+0x72c>
    assert(*ptep & PTE_U);
ffffffffc0201284:	611c                	ld	a5,0(a0)
ffffffffc0201286:	0107f713          	andi	a4,a5,16
ffffffffc020128a:	4a070863          	beqz	a4,ffffffffc020173a <pmm_init+0x70c>
    assert(*ptep & PTE_W);
ffffffffc020128e:	8b91                	andi	a5,a5,4
ffffffffc0201290:	48078563          	beqz	a5,ffffffffc020171a <pmm_init+0x6ec>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0201294:	6008                	ld	a0,0(s0)
ffffffffc0201296:	611c                	ld	a5,0(a0)
ffffffffc0201298:	8bc1                	andi	a5,a5,16
ffffffffc020129a:	46078063          	beqz	a5,ffffffffc02016fa <pmm_init+0x6cc>
    assert(page_ref(p2) == 1);
ffffffffc020129e:	000b2783          	lw	a5,0(s6)
ffffffffc02012a2:	43779c63          	bne	a5,s7,ffffffffc02016da <pmm_init+0x6ac>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02012a6:	4681                	li	a3,0
ffffffffc02012a8:	6605                	lui	a2,0x1
ffffffffc02012aa:	85d6                	mv	a1,s5
ffffffffc02012ac:	cc5ff0ef          	jal	ra,ffffffffc0200f70 <page_insert>
ffffffffc02012b0:	40051563          	bnez	a0,ffffffffc02016ba <pmm_init+0x68c>
    assert(page_ref(p1) == 2);
ffffffffc02012b4:	000aa703          	lw	a4,0(s5)
ffffffffc02012b8:	4789                	li	a5,2
ffffffffc02012ba:	3ef71063          	bne	a4,a5,ffffffffc020169a <pmm_init+0x66c>
    assert(page_ref(p2) == 0);
ffffffffc02012be:	000b2783          	lw	a5,0(s6)
ffffffffc02012c2:	3a079c63          	bnez	a5,ffffffffc020167a <pmm_init+0x64c>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02012c6:	6008                	ld	a0,0(s0)
ffffffffc02012c8:	4601                	li	a2,0
ffffffffc02012ca:	6585                	lui	a1,0x1
ffffffffc02012cc:	9fdff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc02012d0:	38050563          	beqz	a0,ffffffffc020165a <pmm_init+0x62c>
    assert(pte2page(*ptep) == p1);
ffffffffc02012d4:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02012d6:	00177793          	andi	a5,a4,1
ffffffffc02012da:	30078463          	beqz	a5,ffffffffc02015e2 <pmm_init+0x5b4>
    if (PPN(pa) >= npage) {
ffffffffc02012de:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02012e0:	00271793          	slli	a5,a4,0x2
ffffffffc02012e4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02012e6:	2ed7f063          	bleu	a3,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc02012ea:	00093683          	ld	a3,0(s2)
ffffffffc02012ee:	fff80637          	lui	a2,0xfff80
ffffffffc02012f2:	97b2                	add	a5,a5,a2
ffffffffc02012f4:	079a                	slli	a5,a5,0x6
ffffffffc02012f6:	97b6                	add	a5,a5,a3
ffffffffc02012f8:	32fa9163          	bne	s5,a5,ffffffffc020161a <pmm_init+0x5ec>
    assert((*ptep & PTE_U) == 0);
ffffffffc02012fc:	8b41                	andi	a4,a4,16
ffffffffc02012fe:	70071163          	bnez	a4,ffffffffc0201a00 <pmm_init+0x9d2>

    page_remove(boot_pgdir, 0x0);
ffffffffc0201302:	6008                	ld	a0,0(s0)
ffffffffc0201304:	4581                	li	a1,0
ffffffffc0201306:	bf7ff0ef          	jal	ra,ffffffffc0200efc <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020130a:	000aa703          	lw	a4,0(s5)
ffffffffc020130e:	4785                	li	a5,1
ffffffffc0201310:	6cf71863          	bne	a4,a5,ffffffffc02019e0 <pmm_init+0x9b2>
    assert(page_ref(p2) == 0);
ffffffffc0201314:	000b2783          	lw	a5,0(s6)
ffffffffc0201318:	6a079463          	bnez	a5,ffffffffc02019c0 <pmm_init+0x992>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc020131c:	6008                	ld	a0,0(s0)
ffffffffc020131e:	6585                	lui	a1,0x1
ffffffffc0201320:	bddff0ef          	jal	ra,ffffffffc0200efc <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0201324:	000aa783          	lw	a5,0(s5)
ffffffffc0201328:	50079363          	bnez	a5,ffffffffc020182e <pmm_init+0x800>
    assert(page_ref(p2) == 0);
ffffffffc020132c:	000b2783          	lw	a5,0(s6)
ffffffffc0201330:	4c079f63          	bnez	a5,ffffffffc020180e <pmm_init+0x7e0>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0201334:	00043a83          	ld	s5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0201338:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020133a:	000ab783          	ld	a5,0(s5)
ffffffffc020133e:	078a                	slli	a5,a5,0x2
ffffffffc0201340:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201342:	28c7f263          	bleu	a2,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201346:	fff80737          	lui	a4,0xfff80
ffffffffc020134a:	00093503          	ld	a0,0(s2)
ffffffffc020134e:	97ba                	add	a5,a5,a4
ffffffffc0201350:	079a                	slli	a5,a5,0x6
ffffffffc0201352:	00f50733          	add	a4,a0,a5
ffffffffc0201356:	4314                	lw	a3,0(a4)
ffffffffc0201358:	4705                	li	a4,1
ffffffffc020135a:	48e69a63          	bne	a3,a4,ffffffffc02017ee <pmm_init+0x7c0>
    return page - pages + nbase;
ffffffffc020135e:	8799                	srai	a5,a5,0x6
ffffffffc0201360:	00080b37          	lui	s6,0x80
    return KADDR(page2pa(page));
ffffffffc0201364:	577d                	li	a4,-1
    return page - pages + nbase;
ffffffffc0201366:	97da                	add	a5,a5,s6
    return KADDR(page2pa(page));
ffffffffc0201368:	8331                	srli	a4,a4,0xc
ffffffffc020136a:	8f7d                	and	a4,a4,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc020136c:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc020136e:	46c77363          	bleu	a2,a4,ffffffffc02017d4 <pmm_init+0x7a6>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0201372:	0009b683          	ld	a3,0(s3)
ffffffffc0201376:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc0201378:	639c                	ld	a5,0(a5)
ffffffffc020137a:	078a                	slli	a5,a5,0x2
ffffffffc020137c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020137e:	24c7f463          	bleu	a2,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201382:	416787b3          	sub	a5,a5,s6
ffffffffc0201386:	079a                	slli	a5,a5,0x6
ffffffffc0201388:	953e                	add	a0,a0,a5
ffffffffc020138a:	4585                	li	a1,1
ffffffffc020138c:	8b7ff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0201390:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage) {
ffffffffc0201394:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201396:	078a                	slli	a5,a5,0x2
ffffffffc0201398:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020139a:	22e7f663          	bleu	a4,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc020139e:	00093503          	ld	a0,0(s2)
ffffffffc02013a2:	416787b3          	sub	a5,a5,s6
ffffffffc02013a6:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc02013a8:	953e                	add	a0,a0,a5
ffffffffc02013aa:	4585                	li	a1,1
ffffffffc02013ac:	897ff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    boot_pgdir[0] = 0;
ffffffffc02013b0:	601c                	ld	a5,0(s0)
ffffffffc02013b2:	0007b023          	sd	zero,0(a5)
  asm volatile("sfence.vma");
ffffffffc02013b6:	12000073          	sfence.vma
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc02013ba:	8cfff0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>
ffffffffc02013be:	68aa1163          	bne	s4,a0,ffffffffc0201a40 <pmm_init+0xa12>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02013c2:	00005517          	auipc	a0,0x5
ffffffffc02013c6:	90e50513          	addi	a0,a0,-1778 # ffffffffc0205cd0 <commands+0xc80>
ffffffffc02013ca:	d07fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
static void check_boot_pgdir(void) {
    size_t nr_free_store;
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();
ffffffffc02013ce:	8bbff0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02013d2:	6098                	ld	a4,0(s1)
ffffffffc02013d4:	c02007b7          	lui	a5,0xc0200
    nr_free_store=nr_free_pages();
ffffffffc02013d8:	8a2a                	mv	s4,a0
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02013da:	00c71693          	slli	a3,a4,0xc
ffffffffc02013de:	18d7f563          	bleu	a3,a5,ffffffffc0201568 <pmm_init+0x53a>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02013e2:	83b1                	srli	a5,a5,0xc
ffffffffc02013e4:	6008                	ld	a0,0(s0)
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02013e6:	c0200ab7          	lui	s5,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02013ea:	1ae7f163          	bleu	a4,a5,ffffffffc020158c <pmm_init+0x55e>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02013ee:	7bfd                	lui	s7,0xfffff
ffffffffc02013f0:	6b05                	lui	s6,0x1
ffffffffc02013f2:	a029                	j	ffffffffc02013fc <pmm_init+0x3ce>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02013f4:	00cad713          	srli	a4,s5,0xc
ffffffffc02013f8:	18f77a63          	bleu	a5,a4,ffffffffc020158c <pmm_init+0x55e>
ffffffffc02013fc:	0009b583          	ld	a1,0(s3)
ffffffffc0201400:	4601                	li	a2,0
ffffffffc0201402:	95d6                	add	a1,a1,s5
ffffffffc0201404:	8c5ff0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc0201408:	16050263          	beqz	a0,ffffffffc020156c <pmm_init+0x53e>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020140c:	611c                	ld	a5,0(a0)
ffffffffc020140e:	078a                	slli	a5,a5,0x2
ffffffffc0201410:	0177f7b3          	and	a5,a5,s7
ffffffffc0201414:	19579963          	bne	a5,s5,ffffffffc02015a6 <pmm_init+0x578>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201418:	609c                	ld	a5,0(s1)
ffffffffc020141a:	9ada                	add	s5,s5,s6
ffffffffc020141c:	6008                	ld	a0,0(s0)
ffffffffc020141e:	00c79713          	slli	a4,a5,0xc
ffffffffc0201422:	fceae9e3          	bltu	s5,a4,ffffffffc02013f4 <pmm_init+0x3c6>
    }

    assert(boot_pgdir[0] == 0);
ffffffffc0201426:	611c                	ld	a5,0(a0)
ffffffffc0201428:	62079c63          	bnez	a5,ffffffffc0201a60 <pmm_init+0xa32>

    struct Page *p;
    p = alloc_page();
ffffffffc020142c:	4505                	li	a0,1
ffffffffc020142e:	f8cff0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0201432:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201434:	6008                	ld	a0,0(s0)
ffffffffc0201436:	4699                	li	a3,6
ffffffffc0201438:	10000613          	li	a2,256
ffffffffc020143c:	85d6                	mv	a1,s5
ffffffffc020143e:	b33ff0ef          	jal	ra,ffffffffc0200f70 <page_insert>
ffffffffc0201442:	1e051c63          	bnez	a0,ffffffffc020163a <pmm_init+0x60c>
    assert(page_ref(p) == 1);
ffffffffc0201446:	000aa703          	lw	a4,0(s5) # ffffffffc0200000 <kern_entry>
ffffffffc020144a:	4785                	li	a5,1
ffffffffc020144c:	44f71163          	bne	a4,a5,ffffffffc020188e <pmm_init+0x860>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201450:	6008                	ld	a0,0(s0)
ffffffffc0201452:	6b05                	lui	s6,0x1
ffffffffc0201454:	4699                	li	a3,6
ffffffffc0201456:	100b0613          	addi	a2,s6,256 # 1100 <BASE_ADDRESS-0xffffffffc01fef00>
ffffffffc020145a:	85d6                	mv	a1,s5
ffffffffc020145c:	b15ff0ef          	jal	ra,ffffffffc0200f70 <page_insert>
ffffffffc0201460:	40051763          	bnez	a0,ffffffffc020186e <pmm_init+0x840>
    assert(page_ref(p) == 2);
ffffffffc0201464:	000aa703          	lw	a4,0(s5)
ffffffffc0201468:	4789                	li	a5,2
ffffffffc020146a:	3ef71263          	bne	a4,a5,ffffffffc020184e <pmm_init+0x820>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc020146e:	00005597          	auipc	a1,0x5
ffffffffc0201472:	99a58593          	addi	a1,a1,-1638 # ffffffffc0205e08 <commands+0xdb8>
ffffffffc0201476:	10000513          	li	a0,256
ffffffffc020147a:	5bc030ef          	jal	ra,ffffffffc0204a36 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc020147e:	100b0593          	addi	a1,s6,256
ffffffffc0201482:	10000513          	li	a0,256
ffffffffc0201486:	5c2030ef          	jal	ra,ffffffffc0204a48 <strcmp>
ffffffffc020148a:	44051b63          	bnez	a0,ffffffffc02018e0 <pmm_init+0x8b2>
    return page - pages + nbase;
ffffffffc020148e:	00093683          	ld	a3,0(s2)
ffffffffc0201492:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0201496:	5b7d                	li	s6,-1
    return page - pages + nbase;
ffffffffc0201498:	40da86b3          	sub	a3,s5,a3
ffffffffc020149c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020149e:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc02014a0:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc02014a2:	00cb5b13          	srli	s6,s6,0xc
ffffffffc02014a6:	0166f733          	and	a4,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02014aa:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02014ac:	10f77f63          	bleu	a5,a4,ffffffffc02015ca <pmm_init+0x59c>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02014b0:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02014b4:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02014b8:	96be                	add	a3,a3,a5
ffffffffc02014ba:	10068023          	sb	zero,256(a3) # fffffffffffff100 <end+0x3fde8b00>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02014be:	534030ef          	jal	ra,ffffffffc02049f2 <strlen>
ffffffffc02014c2:	54051f63          	bnez	a0,ffffffffc0201a20 <pmm_init+0x9f2>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc02014c6:	00043b83          	ld	s7,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc02014ca:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02014cc:	000bb683          	ld	a3,0(s7) # fffffffffffff000 <end+0x3fde8a00>
ffffffffc02014d0:	068a                	slli	a3,a3,0x2
ffffffffc02014d2:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc02014d4:	0ef6f963          	bleu	a5,a3,ffffffffc02015c6 <pmm_init+0x598>
    return KADDR(page2pa(page));
ffffffffc02014d8:	0166fb33          	and	s6,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02014dc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02014de:	0efb7663          	bleu	a5,s6,ffffffffc02015ca <pmm_init+0x59c>
ffffffffc02014e2:	0009b983          	ld	s3,0(s3)
    free_page(p);
ffffffffc02014e6:	4585                	li	a1,1
ffffffffc02014e8:	8556                	mv	a0,s5
ffffffffc02014ea:	99b6                	add	s3,s3,a3
ffffffffc02014ec:	f56ff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc02014f0:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage) {
ffffffffc02014f4:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02014f6:	078a                	slli	a5,a5,0x2
ffffffffc02014f8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02014fa:	0ce7f663          	bleu	a4,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc02014fe:	00093503          	ld	a0,0(s2)
ffffffffc0201502:	fff809b7          	lui	s3,0xfff80
ffffffffc0201506:	97ce                	add	a5,a5,s3
ffffffffc0201508:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd0[0]));
ffffffffc020150a:	953e                	add	a0,a0,a5
ffffffffc020150c:	4585                	li	a1,1
ffffffffc020150e:	f34ff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0201512:	000bb783          	ld	a5,0(s7)
    if (PPN(pa) >= npage) {
ffffffffc0201516:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201518:	078a                	slli	a5,a5,0x2
ffffffffc020151a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020151c:	0ae7f563          	bleu	a4,a5,ffffffffc02015c6 <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201520:	00093503          	ld	a0,0(s2)
ffffffffc0201524:	97ce                	add	a5,a5,s3
ffffffffc0201526:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc0201528:	953e                	add	a0,a0,a5
ffffffffc020152a:	4585                	li	a1,1
ffffffffc020152c:	f16ff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    boot_pgdir[0] = 0;
ffffffffc0201530:	601c                	ld	a5,0(s0)
ffffffffc0201532:	0007b023          	sd	zero,0(a5) # ffffffffc0200000 <kern_entry>
  asm volatile("sfence.vma");
ffffffffc0201536:	12000073          	sfence.vma
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc020153a:	f4eff0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>
ffffffffc020153e:	3caa1163          	bne	s4,a0,ffffffffc0201900 <pmm_init+0x8d2>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0201542:	00005517          	auipc	a0,0x5
ffffffffc0201546:	93e50513          	addi	a0,a0,-1730 # ffffffffc0205e80 <commands+0xe30>
ffffffffc020154a:	b87fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc020154e:	6406                	ld	s0,64(sp)
ffffffffc0201550:	60a6                	ld	ra,72(sp)
ffffffffc0201552:	74e2                	ld	s1,56(sp)
ffffffffc0201554:	7942                	ld	s2,48(sp)
ffffffffc0201556:	79a2                	ld	s3,40(sp)
ffffffffc0201558:	7a02                	ld	s4,32(sp)
ffffffffc020155a:	6ae2                	ld	s5,24(sp)
ffffffffc020155c:	6b42                	ld	s6,16(sp)
ffffffffc020155e:	6ba2                	ld	s7,8(sp)
ffffffffc0201560:	6c02                	ld	s8,0(sp)
ffffffffc0201562:	6161                	addi	sp,sp,80
    kmalloc_init();
ffffffffc0201564:	4880106f          	j	ffffffffc02029ec <kmalloc_init>
ffffffffc0201568:	6008                	ld	a0,0(s0)
ffffffffc020156a:	bd75                	j	ffffffffc0201426 <pmm_init+0x3f8>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc020156c:	00004697          	auipc	a3,0x4
ffffffffc0201570:	78468693          	addi	a3,a3,1924 # ffffffffc0205cf0 <commands+0xca0>
ffffffffc0201574:	00004617          	auipc	a2,0x4
ffffffffc0201578:	47460613          	addi	a2,a2,1140 # ffffffffc02059e8 <commands+0x998>
ffffffffc020157c:	19d00593          	li	a1,413
ffffffffc0201580:	00004517          	auipc	a0,0x4
ffffffffc0201584:	33850513          	addi	a0,a0,824 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201588:	c4ffe0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc020158c:	86d6                	mv	a3,s5
ffffffffc020158e:	00004617          	auipc	a2,0x4
ffffffffc0201592:	30260613          	addi	a2,a2,770 # ffffffffc0205890 <commands+0x840>
ffffffffc0201596:	19d00593          	li	a1,413
ffffffffc020159a:	00004517          	auipc	a0,0x4
ffffffffc020159e:	31e50513          	addi	a0,a0,798 # ffffffffc02058b8 <commands+0x868>
ffffffffc02015a2:	c35fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02015a6:	00004697          	auipc	a3,0x4
ffffffffc02015aa:	78a68693          	addi	a3,a3,1930 # ffffffffc0205d30 <commands+0xce0>
ffffffffc02015ae:	00004617          	auipc	a2,0x4
ffffffffc02015b2:	43a60613          	addi	a2,a2,1082 # ffffffffc02059e8 <commands+0x998>
ffffffffc02015b6:	19e00593          	li	a1,414
ffffffffc02015ba:	00004517          	auipc	a0,0x4
ffffffffc02015be:	2fe50513          	addi	a0,a0,766 # ffffffffc02058b8 <commands+0x868>
ffffffffc02015c2:	c15fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc02015c6:	dd8ff0ef          	jal	ra,ffffffffc0200b9e <pa2page.part.4>
    return KADDR(page2pa(page));
ffffffffc02015ca:	00004617          	auipc	a2,0x4
ffffffffc02015ce:	2c660613          	addi	a2,a2,710 # ffffffffc0205890 <commands+0x840>
ffffffffc02015d2:	06a00593          	li	a1,106
ffffffffc02015d6:	00004517          	auipc	a0,0x4
ffffffffc02015da:	31250513          	addi	a0,a0,786 # ffffffffc02058e8 <commands+0x898>
ffffffffc02015de:	bf9fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02015e2:	00004617          	auipc	a2,0x4
ffffffffc02015e6:	4de60613          	addi	a2,a2,1246 # ffffffffc0205ac0 <commands+0xa70>
ffffffffc02015ea:	07500593          	li	a1,117
ffffffffc02015ee:	00004517          	auipc	a0,0x4
ffffffffc02015f2:	2fa50513          	addi	a0,a0,762 # ffffffffc02058e8 <commands+0x898>
ffffffffc02015f6:	be1fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02015fa:	00004697          	auipc	a3,0x4
ffffffffc02015fe:	40668693          	addi	a3,a3,1030 # ffffffffc0205a00 <commands+0x9b0>
ffffffffc0201602:	00004617          	auipc	a2,0x4
ffffffffc0201606:	3e660613          	addi	a2,a2,998 # ffffffffc02059e8 <commands+0x998>
ffffffffc020160a:	16100593          	li	a1,353
ffffffffc020160e:	00004517          	auipc	a0,0x4
ffffffffc0201612:	2aa50513          	addi	a0,a0,682 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201616:	bc1fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020161a:	00004697          	auipc	a3,0x4
ffffffffc020161e:	4ce68693          	addi	a3,a3,1230 # ffffffffc0205ae8 <commands+0xa98>
ffffffffc0201622:	00004617          	auipc	a2,0x4
ffffffffc0201626:	3c660613          	addi	a2,a2,966 # ffffffffc02059e8 <commands+0x998>
ffffffffc020162a:	17d00593          	li	a1,381
ffffffffc020162e:	00004517          	auipc	a0,0x4
ffffffffc0201632:	28a50513          	addi	a0,a0,650 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201636:	ba1fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc020163a:	00004697          	auipc	a3,0x4
ffffffffc020163e:	72668693          	addi	a3,a3,1830 # ffffffffc0205d60 <commands+0xd10>
ffffffffc0201642:	00004617          	auipc	a2,0x4
ffffffffc0201646:	3a660613          	addi	a2,a2,934 # ffffffffc02059e8 <commands+0x998>
ffffffffc020164a:	1a500593          	li	a1,421
ffffffffc020164e:	00004517          	auipc	a0,0x4
ffffffffc0201652:	26a50513          	addi	a0,a0,618 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201656:	b81fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020165a:	00004697          	auipc	a3,0x4
ffffffffc020165e:	51e68693          	addi	a3,a3,1310 # ffffffffc0205b78 <commands+0xb28>
ffffffffc0201662:	00004617          	auipc	a2,0x4
ffffffffc0201666:	38660613          	addi	a2,a2,902 # ffffffffc02059e8 <commands+0x998>
ffffffffc020166a:	17c00593          	li	a1,380
ffffffffc020166e:	00004517          	auipc	a0,0x4
ffffffffc0201672:	24a50513          	addi	a0,a0,586 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201676:	b61fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020167a:	00004697          	auipc	a3,0x4
ffffffffc020167e:	5c668693          	addi	a3,a3,1478 # ffffffffc0205c40 <commands+0xbf0>
ffffffffc0201682:	00004617          	auipc	a2,0x4
ffffffffc0201686:	36660613          	addi	a2,a2,870 # ffffffffc02059e8 <commands+0x998>
ffffffffc020168a:	17b00593          	li	a1,379
ffffffffc020168e:	00004517          	auipc	a0,0x4
ffffffffc0201692:	22a50513          	addi	a0,a0,554 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201696:	b41fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc020169a:	00004697          	auipc	a3,0x4
ffffffffc020169e:	58e68693          	addi	a3,a3,1422 # ffffffffc0205c28 <commands+0xbd8>
ffffffffc02016a2:	00004617          	auipc	a2,0x4
ffffffffc02016a6:	34660613          	addi	a2,a2,838 # ffffffffc02059e8 <commands+0x998>
ffffffffc02016aa:	17a00593          	li	a1,378
ffffffffc02016ae:	00004517          	auipc	a0,0x4
ffffffffc02016b2:	20a50513          	addi	a0,a0,522 # ffffffffc02058b8 <commands+0x868>
ffffffffc02016b6:	b21fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02016ba:	00004697          	auipc	a3,0x4
ffffffffc02016be:	53e68693          	addi	a3,a3,1342 # ffffffffc0205bf8 <commands+0xba8>
ffffffffc02016c2:	00004617          	auipc	a2,0x4
ffffffffc02016c6:	32660613          	addi	a2,a2,806 # ffffffffc02059e8 <commands+0x998>
ffffffffc02016ca:	17900593          	li	a1,377
ffffffffc02016ce:	00004517          	auipc	a0,0x4
ffffffffc02016d2:	1ea50513          	addi	a0,a0,490 # ffffffffc02058b8 <commands+0x868>
ffffffffc02016d6:	b01fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02016da:	00004697          	auipc	a3,0x4
ffffffffc02016de:	50668693          	addi	a3,a3,1286 # ffffffffc0205be0 <commands+0xb90>
ffffffffc02016e2:	00004617          	auipc	a2,0x4
ffffffffc02016e6:	30660613          	addi	a2,a2,774 # ffffffffc02059e8 <commands+0x998>
ffffffffc02016ea:	17700593          	li	a1,375
ffffffffc02016ee:	00004517          	auipc	a0,0x4
ffffffffc02016f2:	1ca50513          	addi	a0,a0,458 # ffffffffc02058b8 <commands+0x868>
ffffffffc02016f6:	ae1fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc02016fa:	00004697          	auipc	a3,0x4
ffffffffc02016fe:	4ce68693          	addi	a3,a3,1230 # ffffffffc0205bc8 <commands+0xb78>
ffffffffc0201702:	00004617          	auipc	a2,0x4
ffffffffc0201706:	2e660613          	addi	a2,a2,742 # ffffffffc02059e8 <commands+0x998>
ffffffffc020170a:	17600593          	li	a1,374
ffffffffc020170e:	00004517          	auipc	a0,0x4
ffffffffc0201712:	1aa50513          	addi	a0,a0,426 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201716:	ac1fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(*ptep & PTE_W);
ffffffffc020171a:	00004697          	auipc	a3,0x4
ffffffffc020171e:	49e68693          	addi	a3,a3,1182 # ffffffffc0205bb8 <commands+0xb68>
ffffffffc0201722:	00004617          	auipc	a2,0x4
ffffffffc0201726:	2c660613          	addi	a2,a2,710 # ffffffffc02059e8 <commands+0x998>
ffffffffc020172a:	17500593          	li	a1,373
ffffffffc020172e:	00004517          	auipc	a0,0x4
ffffffffc0201732:	18a50513          	addi	a0,a0,394 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201736:	aa1fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(*ptep & PTE_U);
ffffffffc020173a:	00004697          	auipc	a3,0x4
ffffffffc020173e:	46e68693          	addi	a3,a3,1134 # ffffffffc0205ba8 <commands+0xb58>
ffffffffc0201742:	00004617          	auipc	a2,0x4
ffffffffc0201746:	2a660613          	addi	a2,a2,678 # ffffffffc02059e8 <commands+0x998>
ffffffffc020174a:	17400593          	li	a1,372
ffffffffc020174e:	00004517          	auipc	a0,0x4
ffffffffc0201752:	16a50513          	addi	a0,a0,362 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201756:	a81fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020175a:	00004697          	auipc	a3,0x4
ffffffffc020175e:	41e68693          	addi	a3,a3,1054 # ffffffffc0205b78 <commands+0xb28>
ffffffffc0201762:	00004617          	auipc	a2,0x4
ffffffffc0201766:	28660613          	addi	a2,a2,646 # ffffffffc02059e8 <commands+0x998>
ffffffffc020176a:	17300593          	li	a1,371
ffffffffc020176e:	00004517          	auipc	a0,0x4
ffffffffc0201772:	14a50513          	addi	a0,a0,330 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201776:	a61fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020177a:	00004697          	auipc	a3,0x4
ffffffffc020177e:	3c668693          	addi	a3,a3,966 # ffffffffc0205b40 <commands+0xaf0>
ffffffffc0201782:	00004617          	auipc	a2,0x4
ffffffffc0201786:	26660613          	addi	a2,a2,614 # ffffffffc02059e8 <commands+0x998>
ffffffffc020178a:	17200593          	li	a1,370
ffffffffc020178e:	00004517          	auipc	a0,0x4
ffffffffc0201792:	12a50513          	addi	a0,a0,298 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201796:	a41fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020179a:	00004697          	auipc	a3,0x4
ffffffffc020179e:	37e68693          	addi	a3,a3,894 # ffffffffc0205b18 <commands+0xac8>
ffffffffc02017a2:	00004617          	auipc	a2,0x4
ffffffffc02017a6:	24660613          	addi	a2,a2,582 # ffffffffc02059e8 <commands+0x998>
ffffffffc02017aa:	16f00593          	li	a1,367
ffffffffc02017ae:	00004517          	auipc	a0,0x4
ffffffffc02017b2:	10a50513          	addi	a0,a0,266 # ffffffffc02058b8 <commands+0x868>
ffffffffc02017b6:	a21fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02017ba:	86da                	mv	a3,s6
ffffffffc02017bc:	00004617          	auipc	a2,0x4
ffffffffc02017c0:	0d460613          	addi	a2,a2,212 # ffffffffc0205890 <commands+0x840>
ffffffffc02017c4:	16e00593          	li	a1,366
ffffffffc02017c8:	00004517          	auipc	a0,0x4
ffffffffc02017cc:	0f050513          	addi	a0,a0,240 # ffffffffc02058b8 <commands+0x868>
ffffffffc02017d0:	a07fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    return KADDR(page2pa(page));
ffffffffc02017d4:	86be                	mv	a3,a5
ffffffffc02017d6:	00004617          	auipc	a2,0x4
ffffffffc02017da:	0ba60613          	addi	a2,a2,186 # ffffffffc0205890 <commands+0x840>
ffffffffc02017de:	06a00593          	li	a1,106
ffffffffc02017e2:	00004517          	auipc	a0,0x4
ffffffffc02017e6:	10650513          	addi	a0,a0,262 # ffffffffc02058e8 <commands+0x898>
ffffffffc02017ea:	9edfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc02017ee:	00004697          	auipc	a3,0x4
ffffffffc02017f2:	49a68693          	addi	a3,a3,1178 # ffffffffc0205c88 <commands+0xc38>
ffffffffc02017f6:	00004617          	auipc	a2,0x4
ffffffffc02017fa:	1f260613          	addi	a2,a2,498 # ffffffffc02059e8 <commands+0x998>
ffffffffc02017fe:	18800593          	li	a1,392
ffffffffc0201802:	00004517          	auipc	a0,0x4
ffffffffc0201806:	0b650513          	addi	a0,a0,182 # ffffffffc02058b8 <commands+0x868>
ffffffffc020180a:	9cdfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020180e:	00004697          	auipc	a3,0x4
ffffffffc0201812:	43268693          	addi	a3,a3,1074 # ffffffffc0205c40 <commands+0xbf0>
ffffffffc0201816:	00004617          	auipc	a2,0x4
ffffffffc020181a:	1d260613          	addi	a2,a2,466 # ffffffffc02059e8 <commands+0x998>
ffffffffc020181e:	18600593          	li	a1,390
ffffffffc0201822:	00004517          	auipc	a0,0x4
ffffffffc0201826:	09650513          	addi	a0,a0,150 # ffffffffc02058b8 <commands+0x868>
ffffffffc020182a:	9adfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc020182e:	00004697          	auipc	a3,0x4
ffffffffc0201832:	44268693          	addi	a3,a3,1090 # ffffffffc0205c70 <commands+0xc20>
ffffffffc0201836:	00004617          	auipc	a2,0x4
ffffffffc020183a:	1b260613          	addi	a2,a2,434 # ffffffffc02059e8 <commands+0x998>
ffffffffc020183e:	18500593          	li	a1,389
ffffffffc0201842:	00004517          	auipc	a0,0x4
ffffffffc0201846:	07650513          	addi	a0,a0,118 # ffffffffc02058b8 <commands+0x868>
ffffffffc020184a:	98dfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p) == 2);
ffffffffc020184e:	00004697          	auipc	a3,0x4
ffffffffc0201852:	5a268693          	addi	a3,a3,1442 # ffffffffc0205df0 <commands+0xda0>
ffffffffc0201856:	00004617          	auipc	a2,0x4
ffffffffc020185a:	19260613          	addi	a2,a2,402 # ffffffffc02059e8 <commands+0x998>
ffffffffc020185e:	1a800593          	li	a1,424
ffffffffc0201862:	00004517          	auipc	a0,0x4
ffffffffc0201866:	05650513          	addi	a0,a0,86 # ffffffffc02058b8 <commands+0x868>
ffffffffc020186a:	96dfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc020186e:	00004697          	auipc	a3,0x4
ffffffffc0201872:	54268693          	addi	a3,a3,1346 # ffffffffc0205db0 <commands+0xd60>
ffffffffc0201876:	00004617          	auipc	a2,0x4
ffffffffc020187a:	17260613          	addi	a2,a2,370 # ffffffffc02059e8 <commands+0x998>
ffffffffc020187e:	1a700593          	li	a1,423
ffffffffc0201882:	00004517          	auipc	a0,0x4
ffffffffc0201886:	03650513          	addi	a0,a0,54 # ffffffffc02058b8 <commands+0x868>
ffffffffc020188a:	94dfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p) == 1);
ffffffffc020188e:	00004697          	auipc	a3,0x4
ffffffffc0201892:	50a68693          	addi	a3,a3,1290 # ffffffffc0205d98 <commands+0xd48>
ffffffffc0201896:	00004617          	auipc	a2,0x4
ffffffffc020189a:	15260613          	addi	a2,a2,338 # ffffffffc02059e8 <commands+0x998>
ffffffffc020189e:	1a600593          	li	a1,422
ffffffffc02018a2:	00004517          	auipc	a0,0x4
ffffffffc02018a6:	01650513          	addi	a0,a0,22 # ffffffffc02058b8 <commands+0x868>
ffffffffc02018aa:	92dfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc02018ae:	86be                	mv	a3,a5
ffffffffc02018b0:	00004617          	auipc	a2,0x4
ffffffffc02018b4:	fe060613          	addi	a2,a2,-32 # ffffffffc0205890 <commands+0x840>
ffffffffc02018b8:	16d00593          	li	a1,365
ffffffffc02018bc:	00004517          	auipc	a0,0x4
ffffffffc02018c0:	ffc50513          	addi	a0,a0,-4 # ffffffffc02058b8 <commands+0x868>
ffffffffc02018c4:	913fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018c8:	00004617          	auipc	a2,0x4
ffffffffc02018cc:	0a060613          	addi	a2,a2,160 # ffffffffc0205968 <commands+0x918>
ffffffffc02018d0:	07f00593          	li	a1,127
ffffffffc02018d4:	00004517          	auipc	a0,0x4
ffffffffc02018d8:	fe450513          	addi	a0,a0,-28 # ffffffffc02058b8 <commands+0x868>
ffffffffc02018dc:	8fbfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02018e0:	00004697          	auipc	a3,0x4
ffffffffc02018e4:	54068693          	addi	a3,a3,1344 # ffffffffc0205e20 <commands+0xdd0>
ffffffffc02018e8:	00004617          	auipc	a2,0x4
ffffffffc02018ec:	10060613          	addi	a2,a2,256 # ffffffffc02059e8 <commands+0x998>
ffffffffc02018f0:	1ac00593          	li	a1,428
ffffffffc02018f4:	00004517          	auipc	a0,0x4
ffffffffc02018f8:	fc450513          	addi	a0,a0,-60 # ffffffffc02058b8 <commands+0x868>
ffffffffc02018fc:	8dbfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0201900:	00004697          	auipc	a3,0x4
ffffffffc0201904:	3b068693          	addi	a3,a3,944 # ffffffffc0205cb0 <commands+0xc60>
ffffffffc0201908:	00004617          	auipc	a2,0x4
ffffffffc020190c:	0e060613          	addi	a2,a2,224 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201910:	1b800593          	li	a1,440
ffffffffc0201914:	00004517          	auipc	a0,0x4
ffffffffc0201918:	fa450513          	addi	a0,a0,-92 # ffffffffc02058b8 <commands+0x868>
ffffffffc020191c:	8bbfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0201920:	00004697          	auipc	a3,0x4
ffffffffc0201924:	1e068693          	addi	a3,a3,480 # ffffffffc0205b00 <commands+0xab0>
ffffffffc0201928:	00004617          	auipc	a2,0x4
ffffffffc020192c:	0c060613          	addi	a2,a2,192 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201930:	16b00593          	li	a1,363
ffffffffc0201934:	00004517          	auipc	a0,0x4
ffffffffc0201938:	f8450513          	addi	a0,a0,-124 # ffffffffc02058b8 <commands+0x868>
ffffffffc020193c:	89bfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201940:	00004697          	auipc	a3,0x4
ffffffffc0201944:	1a868693          	addi	a3,a3,424 # ffffffffc0205ae8 <commands+0xa98>
ffffffffc0201948:	00004617          	auipc	a2,0x4
ffffffffc020194c:	0a060613          	addi	a2,a2,160 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201950:	16a00593          	li	a1,362
ffffffffc0201954:	00004517          	auipc	a0,0x4
ffffffffc0201958:	f6450513          	addi	a0,a0,-156 # ffffffffc02058b8 <commands+0x868>
ffffffffc020195c:	87bfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0201960:	00004697          	auipc	a3,0x4
ffffffffc0201964:	0d868693          	addi	a3,a3,216 # ffffffffc0205a38 <commands+0x9e8>
ffffffffc0201968:	00004617          	auipc	a2,0x4
ffffffffc020196c:	08060613          	addi	a2,a2,128 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201970:	16200593          	li	a1,354
ffffffffc0201974:	00004517          	auipc	a0,0x4
ffffffffc0201978:	f4450513          	addi	a0,a0,-188 # ffffffffc02058b8 <commands+0x868>
ffffffffc020197c:	85bfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0201980:	00004697          	auipc	a3,0x4
ffffffffc0201984:	11068693          	addi	a3,a3,272 # ffffffffc0205a90 <commands+0xa40>
ffffffffc0201988:	00004617          	auipc	a2,0x4
ffffffffc020198c:	06060613          	addi	a2,a2,96 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201990:	16900593          	li	a1,361
ffffffffc0201994:	00004517          	auipc	a0,0x4
ffffffffc0201998:	f2450513          	addi	a0,a0,-220 # ffffffffc02058b8 <commands+0x868>
ffffffffc020199c:	83bfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02019a0:	00004697          	auipc	a3,0x4
ffffffffc02019a4:	0c068693          	addi	a3,a3,192 # ffffffffc0205a60 <commands+0xa10>
ffffffffc02019a8:	00004617          	auipc	a2,0x4
ffffffffc02019ac:	04060613          	addi	a2,a2,64 # ffffffffc02059e8 <commands+0x998>
ffffffffc02019b0:	16600593          	li	a1,358
ffffffffc02019b4:	00004517          	auipc	a0,0x4
ffffffffc02019b8:	f0450513          	addi	a0,a0,-252 # ffffffffc02058b8 <commands+0x868>
ffffffffc02019bc:	81bfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02019c0:	00004697          	auipc	a3,0x4
ffffffffc02019c4:	28068693          	addi	a3,a3,640 # ffffffffc0205c40 <commands+0xbf0>
ffffffffc02019c8:	00004617          	auipc	a2,0x4
ffffffffc02019cc:	02060613          	addi	a2,a2,32 # ffffffffc02059e8 <commands+0x998>
ffffffffc02019d0:	18200593          	li	a1,386
ffffffffc02019d4:	00004517          	auipc	a0,0x4
ffffffffc02019d8:	ee450513          	addi	a0,a0,-284 # ffffffffc02058b8 <commands+0x868>
ffffffffc02019dc:	ffafe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02019e0:	00004697          	auipc	a3,0x4
ffffffffc02019e4:	12068693          	addi	a3,a3,288 # ffffffffc0205b00 <commands+0xab0>
ffffffffc02019e8:	00004617          	auipc	a2,0x4
ffffffffc02019ec:	00060613          	mv	a2,a2
ffffffffc02019f0:	18100593          	li	a1,385
ffffffffc02019f4:	00004517          	auipc	a0,0x4
ffffffffc02019f8:	ec450513          	addi	a0,a0,-316 # ffffffffc02058b8 <commands+0x868>
ffffffffc02019fc:	fdafe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0201a00:	00004697          	auipc	a3,0x4
ffffffffc0201a04:	25868693          	addi	a3,a3,600 # ffffffffc0205c58 <commands+0xc08>
ffffffffc0201a08:	00004617          	auipc	a2,0x4
ffffffffc0201a0c:	fe060613          	addi	a2,a2,-32 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201a10:	17e00593          	li	a1,382
ffffffffc0201a14:	00004517          	auipc	a0,0x4
ffffffffc0201a18:	ea450513          	addi	a0,a0,-348 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201a1c:	fbafe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201a20:	00004697          	auipc	a3,0x4
ffffffffc0201a24:	43868693          	addi	a3,a3,1080 # ffffffffc0205e58 <commands+0xe08>
ffffffffc0201a28:	00004617          	auipc	a2,0x4
ffffffffc0201a2c:	fc060613          	addi	a2,a2,-64 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201a30:	1af00593          	li	a1,431
ffffffffc0201a34:	00004517          	auipc	a0,0x4
ffffffffc0201a38:	e8450513          	addi	a0,a0,-380 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201a3c:	f9afe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0201a40:	00004697          	auipc	a3,0x4
ffffffffc0201a44:	27068693          	addi	a3,a3,624 # ffffffffc0205cb0 <commands+0xc60>
ffffffffc0201a48:	00004617          	auipc	a2,0x4
ffffffffc0201a4c:	fa060613          	addi	a2,a2,-96 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201a50:	19000593          	li	a1,400
ffffffffc0201a54:	00004517          	auipc	a0,0x4
ffffffffc0201a58:	e6450513          	addi	a0,a0,-412 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201a5c:	f7afe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0201a60:	00004697          	auipc	a3,0x4
ffffffffc0201a64:	2e868693          	addi	a3,a3,744 # ffffffffc0205d48 <commands+0xcf8>
ffffffffc0201a68:	00004617          	auipc	a2,0x4
ffffffffc0201a6c:	f8060613          	addi	a2,a2,-128 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201a70:	1a100593          	li	a1,417
ffffffffc0201a74:	00004517          	auipc	a0,0x4
ffffffffc0201a78:	e4450513          	addi	a0,a0,-444 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201a7c:	f5afe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0201a80:	00004697          	auipc	a3,0x4
ffffffffc0201a84:	f4868693          	addi	a3,a3,-184 # ffffffffc02059c8 <commands+0x978>
ffffffffc0201a88:	00004617          	auipc	a2,0x4
ffffffffc0201a8c:	f6060613          	addi	a2,a2,-160 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201a90:	16000593          	li	a1,352
ffffffffc0201a94:	00004517          	auipc	a0,0x4
ffffffffc0201a98:	e2450513          	addi	a0,a0,-476 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201a9c:	f3afe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc0201aa0:	00004617          	auipc	a2,0x4
ffffffffc0201aa4:	ec860613          	addi	a2,a2,-312 # ffffffffc0205968 <commands+0x918>
ffffffffc0201aa8:	0c300593          	li	a1,195
ffffffffc0201aac:	00004517          	auipc	a0,0x4
ffffffffc0201ab0:	e0c50513          	addi	a0,a0,-500 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201ab4:	f22fe0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0201ab8 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201ab8:	12058073          	sfence.vma	a1
}
ffffffffc0201abc:	8082                	ret

ffffffffc0201abe <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0201abe:	7179                	addi	sp,sp,-48
ffffffffc0201ac0:	e84a                	sd	s2,16(sp)
ffffffffc0201ac2:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc0201ac4:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0201ac6:	f022                	sd	s0,32(sp)
ffffffffc0201ac8:	ec26                	sd	s1,24(sp)
ffffffffc0201aca:	e44e                	sd	s3,8(sp)
ffffffffc0201acc:	f406                	sd	ra,40(sp)
ffffffffc0201ace:	84ae                	mv	s1,a1
ffffffffc0201ad0:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc0201ad2:	8e8ff0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0201ad6:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0201ad8:	cd19                	beqz	a0,ffffffffc0201af6 <pgdir_alloc_page+0x38>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0201ada:	85aa                	mv	a1,a0
ffffffffc0201adc:	86ce                	mv	a3,s3
ffffffffc0201ade:	8626                	mv	a2,s1
ffffffffc0201ae0:	854a                	mv	a0,s2
ffffffffc0201ae2:	c8eff0ef          	jal	ra,ffffffffc0200f70 <page_insert>
ffffffffc0201ae6:	ed39                	bnez	a0,ffffffffc0201b44 <pgdir_alloc_page+0x86>
        if (swap_init_ok) {
ffffffffc0201ae8:	00015797          	auipc	a5,0x15
ffffffffc0201aec:	9c078793          	addi	a5,a5,-1600 # ffffffffc02164a8 <swap_init_ok>
ffffffffc0201af0:	439c                	lw	a5,0(a5)
ffffffffc0201af2:	2781                	sext.w	a5,a5
ffffffffc0201af4:	eb89                	bnez	a5,ffffffffc0201b06 <pgdir_alloc_page+0x48>
}
ffffffffc0201af6:	8522                	mv	a0,s0
ffffffffc0201af8:	70a2                	ld	ra,40(sp)
ffffffffc0201afa:	7402                	ld	s0,32(sp)
ffffffffc0201afc:	64e2                	ld	s1,24(sp)
ffffffffc0201afe:	6942                	ld	s2,16(sp)
ffffffffc0201b00:	69a2                	ld	s3,8(sp)
ffffffffc0201b02:	6145                	addi	sp,sp,48
ffffffffc0201b04:	8082                	ret
            swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc0201b06:	00015797          	auipc	a5,0x15
ffffffffc0201b0a:	a0278793          	addi	a5,a5,-1534 # ffffffffc0216508 <check_mm_struct>
ffffffffc0201b0e:	6388                	ld	a0,0(a5)
ffffffffc0201b10:	4681                	li	a3,0
ffffffffc0201b12:	8622                	mv	a2,s0
ffffffffc0201b14:	85a6                	mv	a1,s1
ffffffffc0201b16:	05b010ef          	jal	ra,ffffffffc0203370 <swap_map_swappable>
            assert(page_ref(page) == 1);
ffffffffc0201b1a:	4018                	lw	a4,0(s0)
            page->pra_vaddr = la;
ffffffffc0201b1c:	fc04                	sd	s1,56(s0)
            assert(page_ref(page) == 1);
ffffffffc0201b1e:	4785                	li	a5,1
ffffffffc0201b20:	fcf70be3          	beq	a4,a5,ffffffffc0201af6 <pgdir_alloc_page+0x38>
ffffffffc0201b24:	00004697          	auipc	a3,0x4
ffffffffc0201b28:	dd468693          	addi	a3,a3,-556 # ffffffffc02058f8 <commands+0x8a8>
ffffffffc0201b2c:	00004617          	auipc	a2,0x4
ffffffffc0201b30:	ebc60613          	addi	a2,a2,-324 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201b34:	14800593          	li	a1,328
ffffffffc0201b38:	00004517          	auipc	a0,0x4
ffffffffc0201b3c:	d8050513          	addi	a0,a0,-640 # ffffffffc02058b8 <commands+0x868>
ffffffffc0201b40:	e96fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
            free_page(page);
ffffffffc0201b44:	8522                	mv	a0,s0
ffffffffc0201b46:	4585                	li	a1,1
ffffffffc0201b48:	8faff0ef          	jal	ra,ffffffffc0200c42 <free_pages>
            return NULL;
ffffffffc0201b4c:	4401                	li	s0,0
ffffffffc0201b4e:	b765                	j	ffffffffc0201af6 <pgdir_alloc_page+0x38>

ffffffffc0201b50 <_fifo_init_mm>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201b50:	00015797          	auipc	a5,0x15
ffffffffc0201b54:	9a878793          	addi	a5,a5,-1624 # ffffffffc02164f8 <pra_list_head>
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc0201b58:	f51c                	sd	a5,40(a0)
ffffffffc0201b5a:	e79c                	sd	a5,8(a5)
ffffffffc0201b5c:	e39c                	sd	a5,0(a5)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc0201b5e:	4501                	li	a0,0
ffffffffc0201b60:	8082                	ret

ffffffffc0201b62 <_fifo_init>:

static int
_fifo_init(void)
{
    return 0;
}
ffffffffc0201b62:	4501                	li	a0,0
ffffffffc0201b64:	8082                	ret

ffffffffc0201b66 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc0201b66:	4501                	li	a0,0
ffffffffc0201b68:	8082                	ret

ffffffffc0201b6a <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc0201b6a:	4501                	li	a0,0
ffffffffc0201b6c:	8082                	ret

ffffffffc0201b6e <_fifo_check_swap>:
_fifo_check_swap(void) {
ffffffffc0201b6e:	711d                	addi	sp,sp,-96
ffffffffc0201b70:	fc4e                	sd	s3,56(sp)
ffffffffc0201b72:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0201b74:	00004517          	auipc	a0,0x4
ffffffffc0201b78:	32c50513          	addi	a0,a0,812 # ffffffffc0205ea0 <commands+0xe50>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0201b7c:	698d                	lui	s3,0x3
ffffffffc0201b7e:	4a31                	li	s4,12
_fifo_check_swap(void) {
ffffffffc0201b80:	e8a2                	sd	s0,80(sp)
ffffffffc0201b82:	e4a6                	sd	s1,72(sp)
ffffffffc0201b84:	ec86                	sd	ra,88(sp)
ffffffffc0201b86:	e0ca                	sd	s2,64(sp)
ffffffffc0201b88:	f456                	sd	s5,40(sp)
ffffffffc0201b8a:	f05a                	sd	s6,32(sp)
ffffffffc0201b8c:	ec5e                	sd	s7,24(sp)
ffffffffc0201b8e:	e862                	sd	s8,16(sp)
ffffffffc0201b90:	e466                	sd	s9,8(sp)
    assert(pgfault_num==4);
ffffffffc0201b92:	00015417          	auipc	s0,0x15
ffffffffc0201b96:	8fe40413          	addi	s0,s0,-1794 # ffffffffc0216490 <pgfault_num>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0201b9a:	d36fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0201b9e:	01498023          	sb	s4,0(s3) # 3000 <BASE_ADDRESS-0xffffffffc01fd000>
    assert(pgfault_num==4);
ffffffffc0201ba2:	4004                	lw	s1,0(s0)
ffffffffc0201ba4:	4791                	li	a5,4
ffffffffc0201ba6:	2481                	sext.w	s1,s1
ffffffffc0201ba8:	14f49963          	bne	s1,a5,ffffffffc0201cfa <_fifo_check_swap+0x18c>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0201bac:	00004517          	auipc	a0,0x4
ffffffffc0201bb0:	34450513          	addi	a0,a0,836 # ffffffffc0205ef0 <commands+0xea0>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0201bb4:	6a85                	lui	s5,0x1
ffffffffc0201bb6:	4b29                	li	s6,10
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0201bb8:	d18fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0201bbc:	016a8023          	sb	s6,0(s5) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
    assert(pgfault_num==4);
ffffffffc0201bc0:	00042903          	lw	s2,0(s0)
ffffffffc0201bc4:	2901                	sext.w	s2,s2
ffffffffc0201bc6:	2a991a63          	bne	s2,s1,ffffffffc0201e7a <_fifo_check_swap+0x30c>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0201bca:	00004517          	auipc	a0,0x4
ffffffffc0201bce:	34e50513          	addi	a0,a0,846 # ffffffffc0205f18 <commands+0xec8>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0201bd2:	6b91                	lui	s7,0x4
ffffffffc0201bd4:	4c35                	li	s8,13
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0201bd6:	cfafe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0201bda:	018b8023          	sb	s8,0(s7) # 4000 <BASE_ADDRESS-0xffffffffc01fc000>
    assert(pgfault_num==4);
ffffffffc0201bde:	4004                	lw	s1,0(s0)
ffffffffc0201be0:	2481                	sext.w	s1,s1
ffffffffc0201be2:	27249c63          	bne	s1,s2,ffffffffc0201e5a <_fifo_check_swap+0x2ec>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0201be6:	00004517          	auipc	a0,0x4
ffffffffc0201bea:	35a50513          	addi	a0,a0,858 # ffffffffc0205f40 <commands+0xef0>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201bee:	6909                	lui	s2,0x2
ffffffffc0201bf0:	4cad                	li	s9,11
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0201bf2:	cdefe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201bf6:	01990023          	sb	s9,0(s2) # 2000 <BASE_ADDRESS-0xffffffffc01fe000>
    assert(pgfault_num==4);
ffffffffc0201bfa:	401c                	lw	a5,0(s0)
ffffffffc0201bfc:	2781                	sext.w	a5,a5
ffffffffc0201bfe:	22979e63          	bne	a5,s1,ffffffffc0201e3a <_fifo_check_swap+0x2cc>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc0201c02:	00004517          	auipc	a0,0x4
ffffffffc0201c06:	36650513          	addi	a0,a0,870 # ffffffffc0205f68 <commands+0xf18>
ffffffffc0201c0a:	cc6fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0201c0e:	6795                	lui	a5,0x5
ffffffffc0201c10:	4739                	li	a4,14
ffffffffc0201c12:	00e78023          	sb	a4,0(a5) # 5000 <BASE_ADDRESS-0xffffffffc01fb000>
    assert(pgfault_num==5);
ffffffffc0201c16:	4004                	lw	s1,0(s0)
ffffffffc0201c18:	4795                	li	a5,5
ffffffffc0201c1a:	2481                	sext.w	s1,s1
ffffffffc0201c1c:	1ef49f63          	bne	s1,a5,ffffffffc0201e1a <_fifo_check_swap+0x2ac>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0201c20:	00004517          	auipc	a0,0x4
ffffffffc0201c24:	32050513          	addi	a0,a0,800 # ffffffffc0205f40 <commands+0xef0>
ffffffffc0201c28:	ca8fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201c2c:	01990023          	sb	s9,0(s2)
    assert(pgfault_num==5);
ffffffffc0201c30:	401c                	lw	a5,0(s0)
ffffffffc0201c32:	2781                	sext.w	a5,a5
ffffffffc0201c34:	1c979363          	bne	a5,s1,ffffffffc0201dfa <_fifo_check_swap+0x28c>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0201c38:	00004517          	auipc	a0,0x4
ffffffffc0201c3c:	2b850513          	addi	a0,a0,696 # ffffffffc0205ef0 <commands+0xea0>
ffffffffc0201c40:	c90fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0201c44:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc0201c48:	401c                	lw	a5,0(s0)
ffffffffc0201c4a:	4719                	li	a4,6
ffffffffc0201c4c:	2781                	sext.w	a5,a5
ffffffffc0201c4e:	18e79663          	bne	a5,a4,ffffffffc0201dda <_fifo_check_swap+0x26c>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0201c52:	00004517          	auipc	a0,0x4
ffffffffc0201c56:	2ee50513          	addi	a0,a0,750 # ffffffffc0205f40 <commands+0xef0>
ffffffffc0201c5a:	c76fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0201c5e:	01990023          	sb	s9,0(s2)
    assert(pgfault_num==7);
ffffffffc0201c62:	401c                	lw	a5,0(s0)
ffffffffc0201c64:	471d                	li	a4,7
ffffffffc0201c66:	2781                	sext.w	a5,a5
ffffffffc0201c68:	14e79963          	bne	a5,a4,ffffffffc0201dba <_fifo_check_swap+0x24c>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc0201c6c:	00004517          	auipc	a0,0x4
ffffffffc0201c70:	23450513          	addi	a0,a0,564 # ffffffffc0205ea0 <commands+0xe50>
ffffffffc0201c74:	c5cfe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc0201c78:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc0201c7c:	401c                	lw	a5,0(s0)
ffffffffc0201c7e:	4721                	li	a4,8
ffffffffc0201c80:	2781                	sext.w	a5,a5
ffffffffc0201c82:	10e79c63          	bne	a5,a4,ffffffffc0201d9a <_fifo_check_swap+0x22c>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0201c86:	00004517          	auipc	a0,0x4
ffffffffc0201c8a:	29250513          	addi	a0,a0,658 # ffffffffc0205f18 <commands+0xec8>
ffffffffc0201c8e:	c42fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0201c92:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc0201c96:	401c                	lw	a5,0(s0)
ffffffffc0201c98:	4725                	li	a4,9
ffffffffc0201c9a:	2781                	sext.w	a5,a5
ffffffffc0201c9c:	0ce79f63          	bne	a5,a4,ffffffffc0201d7a <_fifo_check_swap+0x20c>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc0201ca0:	00004517          	auipc	a0,0x4
ffffffffc0201ca4:	2c850513          	addi	a0,a0,712 # ffffffffc0205f68 <commands+0xf18>
ffffffffc0201ca8:	c28fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0201cac:	6795                	lui	a5,0x5
ffffffffc0201cae:	4739                	li	a4,14
ffffffffc0201cb0:	00e78023          	sb	a4,0(a5) # 5000 <BASE_ADDRESS-0xffffffffc01fb000>
    assert(pgfault_num==10);
ffffffffc0201cb4:	4004                	lw	s1,0(s0)
ffffffffc0201cb6:	47a9                	li	a5,10
ffffffffc0201cb8:	2481                	sext.w	s1,s1
ffffffffc0201cba:	0af49063          	bne	s1,a5,ffffffffc0201d5a <_fifo_check_swap+0x1ec>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0201cbe:	00004517          	auipc	a0,0x4
ffffffffc0201cc2:	23250513          	addi	a0,a0,562 # ffffffffc0205ef0 <commands+0xea0>
ffffffffc0201cc6:	c0afe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0201cca:	6785                	lui	a5,0x1
ffffffffc0201ccc:	0007c783          	lbu	a5,0(a5) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc0201cd0:	06979563          	bne	a5,s1,ffffffffc0201d3a <_fifo_check_swap+0x1cc>
    assert(pgfault_num==11);
ffffffffc0201cd4:	401c                	lw	a5,0(s0)
ffffffffc0201cd6:	472d                	li	a4,11
ffffffffc0201cd8:	2781                	sext.w	a5,a5
ffffffffc0201cda:	04e79063          	bne	a5,a4,ffffffffc0201d1a <_fifo_check_swap+0x1ac>
}
ffffffffc0201cde:	60e6                	ld	ra,88(sp)
ffffffffc0201ce0:	6446                	ld	s0,80(sp)
ffffffffc0201ce2:	64a6                	ld	s1,72(sp)
ffffffffc0201ce4:	6906                	ld	s2,64(sp)
ffffffffc0201ce6:	79e2                	ld	s3,56(sp)
ffffffffc0201ce8:	7a42                	ld	s4,48(sp)
ffffffffc0201cea:	7aa2                	ld	s5,40(sp)
ffffffffc0201cec:	7b02                	ld	s6,32(sp)
ffffffffc0201cee:	6be2                	ld	s7,24(sp)
ffffffffc0201cf0:	6c42                	ld	s8,16(sp)
ffffffffc0201cf2:	6ca2                	ld	s9,8(sp)
ffffffffc0201cf4:	4501                	li	a0,0
ffffffffc0201cf6:	6125                	addi	sp,sp,96
ffffffffc0201cf8:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0201cfa:	00004697          	auipc	a3,0x4
ffffffffc0201cfe:	1ce68693          	addi	a3,a3,462 # ffffffffc0205ec8 <commands+0xe78>
ffffffffc0201d02:	00004617          	auipc	a2,0x4
ffffffffc0201d06:	ce660613          	addi	a2,a2,-794 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201d0a:	05100593          	li	a1,81
ffffffffc0201d0e:	00004517          	auipc	a0,0x4
ffffffffc0201d12:	1ca50513          	addi	a0,a0,458 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201d16:	cc0fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==11);
ffffffffc0201d1a:	00004697          	auipc	a3,0x4
ffffffffc0201d1e:	2fe68693          	addi	a3,a3,766 # ffffffffc0206018 <commands+0xfc8>
ffffffffc0201d22:	00004617          	auipc	a2,0x4
ffffffffc0201d26:	cc660613          	addi	a2,a2,-826 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201d2a:	07300593          	li	a1,115
ffffffffc0201d2e:	00004517          	auipc	a0,0x4
ffffffffc0201d32:	1aa50513          	addi	a0,a0,426 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201d36:	ca0fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0201d3a:	00004697          	auipc	a3,0x4
ffffffffc0201d3e:	2b668693          	addi	a3,a3,694 # ffffffffc0205ff0 <commands+0xfa0>
ffffffffc0201d42:	00004617          	auipc	a2,0x4
ffffffffc0201d46:	ca660613          	addi	a2,a2,-858 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201d4a:	07100593          	li	a1,113
ffffffffc0201d4e:	00004517          	auipc	a0,0x4
ffffffffc0201d52:	18a50513          	addi	a0,a0,394 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201d56:	c80fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==10);
ffffffffc0201d5a:	00004697          	auipc	a3,0x4
ffffffffc0201d5e:	28668693          	addi	a3,a3,646 # ffffffffc0205fe0 <commands+0xf90>
ffffffffc0201d62:	00004617          	auipc	a2,0x4
ffffffffc0201d66:	c8660613          	addi	a2,a2,-890 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201d6a:	06f00593          	li	a1,111
ffffffffc0201d6e:	00004517          	auipc	a0,0x4
ffffffffc0201d72:	16a50513          	addi	a0,a0,362 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201d76:	c60fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==9);
ffffffffc0201d7a:	00004697          	auipc	a3,0x4
ffffffffc0201d7e:	25668693          	addi	a3,a3,598 # ffffffffc0205fd0 <commands+0xf80>
ffffffffc0201d82:	00004617          	auipc	a2,0x4
ffffffffc0201d86:	c6660613          	addi	a2,a2,-922 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201d8a:	06c00593          	li	a1,108
ffffffffc0201d8e:	00004517          	auipc	a0,0x4
ffffffffc0201d92:	14a50513          	addi	a0,a0,330 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201d96:	c40fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==8);
ffffffffc0201d9a:	00004697          	auipc	a3,0x4
ffffffffc0201d9e:	22668693          	addi	a3,a3,550 # ffffffffc0205fc0 <commands+0xf70>
ffffffffc0201da2:	00004617          	auipc	a2,0x4
ffffffffc0201da6:	c4660613          	addi	a2,a2,-954 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201daa:	06900593          	li	a1,105
ffffffffc0201dae:	00004517          	auipc	a0,0x4
ffffffffc0201db2:	12a50513          	addi	a0,a0,298 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201db6:	c20fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==7);
ffffffffc0201dba:	00004697          	auipc	a3,0x4
ffffffffc0201dbe:	1f668693          	addi	a3,a3,502 # ffffffffc0205fb0 <commands+0xf60>
ffffffffc0201dc2:	00004617          	auipc	a2,0x4
ffffffffc0201dc6:	c2660613          	addi	a2,a2,-986 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201dca:	06600593          	li	a1,102
ffffffffc0201dce:	00004517          	auipc	a0,0x4
ffffffffc0201dd2:	10a50513          	addi	a0,a0,266 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201dd6:	c00fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==6);
ffffffffc0201dda:	00004697          	auipc	a3,0x4
ffffffffc0201dde:	1c668693          	addi	a3,a3,454 # ffffffffc0205fa0 <commands+0xf50>
ffffffffc0201de2:	00004617          	auipc	a2,0x4
ffffffffc0201de6:	c0660613          	addi	a2,a2,-1018 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201dea:	06300593          	li	a1,99
ffffffffc0201dee:	00004517          	auipc	a0,0x4
ffffffffc0201df2:	0ea50513          	addi	a0,a0,234 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201df6:	be0fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==5);
ffffffffc0201dfa:	00004697          	auipc	a3,0x4
ffffffffc0201dfe:	19668693          	addi	a3,a3,406 # ffffffffc0205f90 <commands+0xf40>
ffffffffc0201e02:	00004617          	auipc	a2,0x4
ffffffffc0201e06:	be660613          	addi	a2,a2,-1050 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201e0a:	06000593          	li	a1,96
ffffffffc0201e0e:	00004517          	auipc	a0,0x4
ffffffffc0201e12:	0ca50513          	addi	a0,a0,202 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201e16:	bc0fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==5);
ffffffffc0201e1a:	00004697          	auipc	a3,0x4
ffffffffc0201e1e:	17668693          	addi	a3,a3,374 # ffffffffc0205f90 <commands+0xf40>
ffffffffc0201e22:	00004617          	auipc	a2,0x4
ffffffffc0201e26:	bc660613          	addi	a2,a2,-1082 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201e2a:	05d00593          	li	a1,93
ffffffffc0201e2e:	00004517          	auipc	a0,0x4
ffffffffc0201e32:	0aa50513          	addi	a0,a0,170 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201e36:	ba0fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==4);
ffffffffc0201e3a:	00004697          	auipc	a3,0x4
ffffffffc0201e3e:	08e68693          	addi	a3,a3,142 # ffffffffc0205ec8 <commands+0xe78>
ffffffffc0201e42:	00004617          	auipc	a2,0x4
ffffffffc0201e46:	ba660613          	addi	a2,a2,-1114 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201e4a:	05a00593          	li	a1,90
ffffffffc0201e4e:	00004517          	auipc	a0,0x4
ffffffffc0201e52:	08a50513          	addi	a0,a0,138 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201e56:	b80fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==4);
ffffffffc0201e5a:	00004697          	auipc	a3,0x4
ffffffffc0201e5e:	06e68693          	addi	a3,a3,110 # ffffffffc0205ec8 <commands+0xe78>
ffffffffc0201e62:	00004617          	auipc	a2,0x4
ffffffffc0201e66:	b8660613          	addi	a2,a2,-1146 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201e6a:	05700593          	li	a1,87
ffffffffc0201e6e:	00004517          	auipc	a0,0x4
ffffffffc0201e72:	06a50513          	addi	a0,a0,106 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201e76:	b60fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgfault_num==4);
ffffffffc0201e7a:	00004697          	auipc	a3,0x4
ffffffffc0201e7e:	04e68693          	addi	a3,a3,78 # ffffffffc0205ec8 <commands+0xe78>
ffffffffc0201e82:	00004617          	auipc	a2,0x4
ffffffffc0201e86:	b6660613          	addi	a2,a2,-1178 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201e8a:	05400593          	li	a1,84
ffffffffc0201e8e:	00004517          	auipc	a0,0x4
ffffffffc0201e92:	04a50513          	addi	a0,a0,74 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201e96:	b40fe0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0201e9a <_fifo_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0201e9a:	751c                	ld	a5,40(a0)
{
ffffffffc0201e9c:	1141                	addi	sp,sp,-16
ffffffffc0201e9e:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc0201ea0:	cf91                	beqz	a5,ffffffffc0201ebc <_fifo_swap_out_victim+0x22>
     assert(in_tick==0);
ffffffffc0201ea2:	ee0d                	bnez	a2,ffffffffc0201edc <_fifo_swap_out_victim+0x42>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201ea4:	679c                	ld	a5,8(a5)
}
ffffffffc0201ea6:	60a2                	ld	ra,8(sp)
ffffffffc0201ea8:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0201eaa:	6394                	ld	a3,0(a5)
ffffffffc0201eac:	6798                	ld	a4,8(a5)
    *ptr_page = le2page(entry, pra_page_link);
ffffffffc0201eae:	fd878793          	addi	a5,a5,-40
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201eb2:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0201eb4:	e314                	sd	a3,0(a4)
ffffffffc0201eb6:	e19c                	sd	a5,0(a1)
}
ffffffffc0201eb8:	0141                	addi	sp,sp,16
ffffffffc0201eba:	8082                	ret
         assert(head != NULL);
ffffffffc0201ebc:	00004697          	auipc	a3,0x4
ffffffffc0201ec0:	18c68693          	addi	a3,a3,396 # ffffffffc0206048 <commands+0xff8>
ffffffffc0201ec4:	00004617          	auipc	a2,0x4
ffffffffc0201ec8:	b2460613          	addi	a2,a2,-1244 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201ecc:	04100593          	li	a1,65
ffffffffc0201ed0:	00004517          	auipc	a0,0x4
ffffffffc0201ed4:	00850513          	addi	a0,a0,8 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201ed8:	afefe0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(in_tick==0);
ffffffffc0201edc:	00004697          	auipc	a3,0x4
ffffffffc0201ee0:	17c68693          	addi	a3,a3,380 # ffffffffc0206058 <commands+0x1008>
ffffffffc0201ee4:	00004617          	auipc	a2,0x4
ffffffffc0201ee8:	b0460613          	addi	a2,a2,-1276 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201eec:	04200593          	li	a1,66
ffffffffc0201ef0:	00004517          	auipc	a0,0x4
ffffffffc0201ef4:	fe850513          	addi	a0,a0,-24 # ffffffffc0205ed8 <commands+0xe88>
ffffffffc0201ef8:	adefe0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0201efc <_fifo_map_swappable>:
    list_entry_t *entry=&(page->pra_page_link);
ffffffffc0201efc:	02860713          	addi	a4,a2,40
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc0201f00:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc0201f02:	cb09                	beqz	a4,ffffffffc0201f14 <_fifo_map_swappable+0x18>
ffffffffc0201f04:	cb81                	beqz	a5,ffffffffc0201f14 <_fifo_map_swappable+0x18>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201f06:	6394                	ld	a3,0(a5)
    prev->next = next->prev = elm;
ffffffffc0201f08:	e398                	sd	a4,0(a5)
}
ffffffffc0201f0a:	4501                	li	a0,0
ffffffffc0201f0c:	e698                	sd	a4,8(a3)
    elm->next = next;
ffffffffc0201f0e:	fa1c                	sd	a5,48(a2)
    elm->prev = prev;
ffffffffc0201f10:	f614                	sd	a3,40(a2)
ffffffffc0201f12:	8082                	ret
{
ffffffffc0201f14:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc0201f16:	00004697          	auipc	a3,0x4
ffffffffc0201f1a:	11268693          	addi	a3,a3,274 # ffffffffc0206028 <commands+0xfd8>
ffffffffc0201f1e:	00004617          	auipc	a2,0x4
ffffffffc0201f22:	aca60613          	addi	a2,a2,-1334 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201f26:	03200593          	li	a1,50
ffffffffc0201f2a:	00004517          	auipc	a0,0x4
ffffffffc0201f2e:	fae50513          	addi	a0,a0,-82 # ffffffffc0205ed8 <commands+0xe88>
{
ffffffffc0201f32:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc0201f34:	aa2fe0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0201f38 <check_vma_overlap.isra.0.part.1>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0201f38:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0201f3a:	00004697          	auipc	a3,0x4
ffffffffc0201f3e:	14668693          	addi	a3,a3,326 # ffffffffc0206080 <commands+0x1030>
ffffffffc0201f42:	00004617          	auipc	a2,0x4
ffffffffc0201f46:	aa660613          	addi	a2,a2,-1370 # ffffffffc02059e8 <commands+0x998>
ffffffffc0201f4a:	07e00593          	li	a1,126
ffffffffc0201f4e:	00004517          	auipc	a0,0x4
ffffffffc0201f52:	15250513          	addi	a0,a0,338 # ffffffffc02060a0 <commands+0x1050>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0201f56:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0201f58:	a7efe0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0201f5c <mm_create>:
mm_create(void) {
ffffffffc0201f5c:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201f5e:	03000513          	li	a0,48
mm_create(void) {
ffffffffc0201f62:	e022                	sd	s0,0(sp)
ffffffffc0201f64:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0201f66:	2a7000ef          	jal	ra,ffffffffc0202a0c <kmalloc>
ffffffffc0201f6a:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc0201f6c:	c115                	beqz	a0,ffffffffc0201f90 <mm_create+0x34>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201f6e:	00014797          	auipc	a5,0x14
ffffffffc0201f72:	53a78793          	addi	a5,a5,1338 # ffffffffc02164a8 <swap_init_ok>
ffffffffc0201f76:	439c                	lw	a5,0(a5)
    elm->prev = elm->next = elm;
ffffffffc0201f78:	e408                	sd	a0,8(s0)
ffffffffc0201f7a:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc0201f7c:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0201f80:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0201f84:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201f88:	2781                	sext.w	a5,a5
ffffffffc0201f8a:	eb81                	bnez	a5,ffffffffc0201f9a <mm_create+0x3e>
        else mm->sm_priv = NULL;
ffffffffc0201f8c:	02053423          	sd	zero,40(a0)
}
ffffffffc0201f90:	8522                	mv	a0,s0
ffffffffc0201f92:	60a2                	ld	ra,8(sp)
ffffffffc0201f94:	6402                	ld	s0,0(sp)
ffffffffc0201f96:	0141                	addi	sp,sp,16
ffffffffc0201f98:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc0201f9a:	3c6010ef          	jal	ra,ffffffffc0203360 <swap_init_mm>
}
ffffffffc0201f9e:	8522                	mv	a0,s0
ffffffffc0201fa0:	60a2                	ld	ra,8(sp)
ffffffffc0201fa2:	6402                	ld	s0,0(sp)
ffffffffc0201fa4:	0141                	addi	sp,sp,16
ffffffffc0201fa6:	8082                	ret

ffffffffc0201fa8 <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc0201fa8:	1101                	addi	sp,sp,-32
ffffffffc0201faa:	e04a                	sd	s2,0(sp)
ffffffffc0201fac:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201fae:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc0201fb2:	e822                	sd	s0,16(sp)
ffffffffc0201fb4:	e426                	sd	s1,8(sp)
ffffffffc0201fb6:	ec06                	sd	ra,24(sp)
ffffffffc0201fb8:	84ae                	mv	s1,a1
ffffffffc0201fba:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0201fbc:	251000ef          	jal	ra,ffffffffc0202a0c <kmalloc>
    if (vma != NULL) {
ffffffffc0201fc0:	c509                	beqz	a0,ffffffffc0201fca <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc0201fc2:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc0201fc6:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0201fc8:	cd00                	sw	s0,24(a0)
}
ffffffffc0201fca:	60e2                	ld	ra,24(sp)
ffffffffc0201fcc:	6442                	ld	s0,16(sp)
ffffffffc0201fce:	64a2                	ld	s1,8(sp)
ffffffffc0201fd0:	6902                	ld	s2,0(sp)
ffffffffc0201fd2:	6105                	addi	sp,sp,32
ffffffffc0201fd4:	8082                	ret

ffffffffc0201fd6 <find_vma>:
    if (mm != NULL) {
ffffffffc0201fd6:	c51d                	beqz	a0,ffffffffc0202004 <find_vma+0x2e>
        vma = mm->mmap_cache;
ffffffffc0201fd8:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0201fda:	c781                	beqz	a5,ffffffffc0201fe2 <find_vma+0xc>
ffffffffc0201fdc:	6798                	ld	a4,8(a5)
ffffffffc0201fde:	02e5f663          	bleu	a4,a1,ffffffffc020200a <find_vma+0x34>
                list_entry_t *list = &(mm->mmap_list), *le = list;
ffffffffc0201fe2:	87aa                	mv	a5,a0
    return listelm->next;
ffffffffc0201fe4:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0201fe6:	00f50f63          	beq	a0,a5,ffffffffc0202004 <find_vma+0x2e>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0201fea:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201fee:	fee5ebe3          	bltu	a1,a4,ffffffffc0201fe4 <find_vma+0xe>
ffffffffc0201ff2:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201ff6:	fee5f7e3          	bleu	a4,a1,ffffffffc0201fe4 <find_vma+0xe>
                    vma = le2vma(le, list_link);
ffffffffc0201ffa:	1781                	addi	a5,a5,-32
        if (vma != NULL) {
ffffffffc0201ffc:	c781                	beqz	a5,ffffffffc0202004 <find_vma+0x2e>
            mm->mmap_cache = vma;
ffffffffc0201ffe:	e91c                	sd	a5,16(a0)
}
ffffffffc0202000:	853e                	mv	a0,a5
ffffffffc0202002:	8082                	ret
    struct vma_struct *vma = NULL;
ffffffffc0202004:	4781                	li	a5,0
}
ffffffffc0202006:	853e                	mv	a0,a5
ffffffffc0202008:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc020200a:	6b98                	ld	a4,16(a5)
ffffffffc020200c:	fce5fbe3          	bleu	a4,a1,ffffffffc0201fe2 <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc0202010:	e91c                	sd	a5,16(a0)
    return vma;
ffffffffc0202012:	b7fd                	j	ffffffffc0202000 <find_vma+0x2a>

ffffffffc0202014 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202014:	6590                	ld	a2,8(a1)
ffffffffc0202016:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc020201a:	1141                	addi	sp,sp,-16
ffffffffc020201c:	e406                	sd	ra,8(sp)
ffffffffc020201e:	872a                	mv	a4,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202020:	01066863          	bltu	a2,a6,ffffffffc0202030 <insert_vma_struct+0x1c>
ffffffffc0202024:	a8b9                	j	ffffffffc0202082 <insert_vma_struct+0x6e>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202026:	fe87b683          	ld	a3,-24(a5)
ffffffffc020202a:	04d66763          	bltu	a2,a3,ffffffffc0202078 <insert_vma_struct+0x64>
ffffffffc020202e:	873e                	mv	a4,a5
ffffffffc0202030:	671c                	ld	a5,8(a4)
        while ((le = list_next(le)) != list) {
ffffffffc0202032:	fef51ae3          	bne	a0,a5,ffffffffc0202026 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0202036:	02a70463          	beq	a4,a0,ffffffffc020205e <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020203a:	ff073683          	ld	a3,-16(a4) # 7fff0 <BASE_ADDRESS-0xffffffffc0180010>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020203e:	fe873883          	ld	a7,-24(a4)
ffffffffc0202042:	08d8f063          	bleu	a3,a7,ffffffffc02020c2 <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202046:	04d66e63          	bltu	a2,a3,ffffffffc02020a2 <insert_vma_struct+0x8e>
    }
    if (le_next != list) {
ffffffffc020204a:	00f50a63          	beq	a0,a5,ffffffffc020205e <insert_vma_struct+0x4a>
ffffffffc020204e:	fe87b683          	ld	a3,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202052:	0506e863          	bltu	a3,a6,ffffffffc02020a2 <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc0202056:	ff07b603          	ld	a2,-16(a5)
ffffffffc020205a:	02c6f263          	bleu	a2,a3,ffffffffc020207e <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc020205e:	5114                	lw	a3,32(a0)
    vma->vm_mm = mm;
ffffffffc0202060:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202062:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202066:	e390                	sd	a2,0(a5)
ffffffffc0202068:	e710                	sd	a2,8(a4)
}
ffffffffc020206a:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc020206c:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc020206e:	f198                	sd	a4,32(a1)
    mm->map_count ++;
ffffffffc0202070:	2685                	addiw	a3,a3,1
ffffffffc0202072:	d114                	sw	a3,32(a0)
}
ffffffffc0202074:	0141                	addi	sp,sp,16
ffffffffc0202076:	8082                	ret
    if (le_prev != list) {
ffffffffc0202078:	fca711e3          	bne	a4,a0,ffffffffc020203a <insert_vma_struct+0x26>
ffffffffc020207c:	bfd9                	j	ffffffffc0202052 <insert_vma_struct+0x3e>
ffffffffc020207e:	ebbff0ef          	jal	ra,ffffffffc0201f38 <check_vma_overlap.isra.0.part.1>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202082:	00004697          	auipc	a3,0x4
ffffffffc0202086:	0ee68693          	addi	a3,a3,238 # ffffffffc0206170 <commands+0x1120>
ffffffffc020208a:	00004617          	auipc	a2,0x4
ffffffffc020208e:	95e60613          	addi	a2,a2,-1698 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202092:	08500593          	li	a1,133
ffffffffc0202096:	00004517          	auipc	a0,0x4
ffffffffc020209a:	00a50513          	addi	a0,a0,10 # ffffffffc02060a0 <commands+0x1050>
ffffffffc020209e:	938fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02020a2:	00004697          	auipc	a3,0x4
ffffffffc02020a6:	10e68693          	addi	a3,a3,270 # ffffffffc02061b0 <commands+0x1160>
ffffffffc02020aa:	00004617          	auipc	a2,0x4
ffffffffc02020ae:	93e60613          	addi	a2,a2,-1730 # ffffffffc02059e8 <commands+0x998>
ffffffffc02020b2:	07d00593          	li	a1,125
ffffffffc02020b6:	00004517          	auipc	a0,0x4
ffffffffc02020ba:	fea50513          	addi	a0,a0,-22 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02020be:	918fe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02020c2:	00004697          	auipc	a3,0x4
ffffffffc02020c6:	0ce68693          	addi	a3,a3,206 # ffffffffc0206190 <commands+0x1140>
ffffffffc02020ca:	00004617          	auipc	a2,0x4
ffffffffc02020ce:	91e60613          	addi	a2,a2,-1762 # ffffffffc02059e8 <commands+0x998>
ffffffffc02020d2:	07c00593          	li	a1,124
ffffffffc02020d6:	00004517          	auipc	a0,0x4
ffffffffc02020da:	fca50513          	addi	a0,a0,-54 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02020de:	8f8fe0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc02020e2 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
ffffffffc02020e2:	1141                	addi	sp,sp,-16
ffffffffc02020e4:	e022                	sd	s0,0(sp)
ffffffffc02020e6:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02020e8:	6508                	ld	a0,8(a0)
ffffffffc02020ea:	e406                	sd	ra,8(sp)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc02020ec:	00a40c63          	beq	s0,a0,ffffffffc0202104 <mm_destroy+0x22>
    __list_del(listelm->prev, listelm->next);
ffffffffc02020f0:	6118                	ld	a4,0(a0)
ffffffffc02020f2:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc02020f4:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02020f6:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02020f8:	e398                	sd	a4,0(a5)
ffffffffc02020fa:	1cf000ef          	jal	ra,ffffffffc0202ac8 <kfree>
    return listelm->next;
ffffffffc02020fe:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0202100:	fea418e3          	bne	s0,a0,ffffffffc02020f0 <mm_destroy+0xe>
    }
    kfree(mm); //kfree mm
ffffffffc0202104:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0202106:	6402                	ld	s0,0(sp)
ffffffffc0202108:	60a2                	ld	ra,8(sp)
ffffffffc020210a:	0141                	addi	sp,sp,16
    kfree(mm); //kfree mm
ffffffffc020210c:	1bd0006f          	j	ffffffffc0202ac8 <kfree>

ffffffffc0202110 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0202110:	7139                	addi	sp,sp,-64
ffffffffc0202112:	f822                	sd	s0,48(sp)
ffffffffc0202114:	f426                	sd	s1,40(sp)
ffffffffc0202116:	fc06                	sd	ra,56(sp)
ffffffffc0202118:	f04a                	sd	s2,32(sp)
ffffffffc020211a:	ec4e                	sd	s3,24(sp)
ffffffffc020211c:	e852                	sd	s4,16(sp)
ffffffffc020211e:	e456                	sd	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
}

static void
check_vma_struct(void) {
    struct mm_struct *mm = mm_create();
ffffffffc0202120:	e3dff0ef          	jal	ra,ffffffffc0201f5c <mm_create>
    assert(mm != NULL);
ffffffffc0202124:	842a                	mv	s0,a0
ffffffffc0202126:	03200493          	li	s1,50
ffffffffc020212a:	e919                	bnez	a0,ffffffffc0202140 <vmm_init+0x30>
ffffffffc020212c:	a989                	j	ffffffffc020257e <vmm_init+0x46e>
        vma->vm_start = vm_start;
ffffffffc020212e:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202130:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202132:	00052c23          	sw	zero,24(a0)

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202136:	14ed                	addi	s1,s1,-5
ffffffffc0202138:	8522                	mv	a0,s0
ffffffffc020213a:	edbff0ef          	jal	ra,ffffffffc0202014 <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc020213e:	c88d                	beqz	s1,ffffffffc0202170 <vmm_init+0x60>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202140:	03000513          	li	a0,48
ffffffffc0202144:	0c9000ef          	jal	ra,ffffffffc0202a0c <kmalloc>
ffffffffc0202148:	85aa                	mv	a1,a0
ffffffffc020214a:	00248793          	addi	a5,s1,2
    if (vma != NULL) {
ffffffffc020214e:	f165                	bnez	a0,ffffffffc020212e <vmm_init+0x1e>
        assert(vma != NULL);
ffffffffc0202150:	00004697          	auipc	a3,0x4
ffffffffc0202154:	2a868693          	addi	a3,a3,680 # ffffffffc02063f8 <commands+0x13a8>
ffffffffc0202158:	00004617          	auipc	a2,0x4
ffffffffc020215c:	89060613          	addi	a2,a2,-1904 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202160:	0c900593          	li	a1,201
ffffffffc0202164:	00004517          	auipc	a0,0x4
ffffffffc0202168:	f3c50513          	addi	a0,a0,-196 # ffffffffc02060a0 <commands+0x1050>
ffffffffc020216c:	86afe0ef          	jal	ra,ffffffffc02001d6 <__panic>
    for (i = step1; i >= 1; i --) {
ffffffffc0202170:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0202174:	1f900913          	li	s2,505
ffffffffc0202178:	a819                	j	ffffffffc020218e <vmm_init+0x7e>
        vma->vm_start = vm_start;
ffffffffc020217a:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc020217c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020217e:	00052c23          	sw	zero,24(a0)
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202182:	0495                	addi	s1,s1,5
ffffffffc0202184:	8522                	mv	a0,s0
ffffffffc0202186:	e8fff0ef          	jal	ra,ffffffffc0202014 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc020218a:	03248a63          	beq	s1,s2,ffffffffc02021be <vmm_init+0xae>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020218e:	03000513          	li	a0,48
ffffffffc0202192:	07b000ef          	jal	ra,ffffffffc0202a0c <kmalloc>
ffffffffc0202196:	85aa                	mv	a1,a0
ffffffffc0202198:	00248793          	addi	a5,s1,2
    if (vma != NULL) {
ffffffffc020219c:	fd79                	bnez	a0,ffffffffc020217a <vmm_init+0x6a>
        assert(vma != NULL);
ffffffffc020219e:	00004697          	auipc	a3,0x4
ffffffffc02021a2:	25a68693          	addi	a3,a3,602 # ffffffffc02063f8 <commands+0x13a8>
ffffffffc02021a6:	00004617          	auipc	a2,0x4
ffffffffc02021aa:	84260613          	addi	a2,a2,-1982 # ffffffffc02059e8 <commands+0x998>
ffffffffc02021ae:	0cf00593          	li	a1,207
ffffffffc02021b2:	00004517          	auipc	a0,0x4
ffffffffc02021b6:	eee50513          	addi	a0,a0,-274 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02021ba:	81cfe0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc02021be:	6418                	ld	a4,8(s0)
ffffffffc02021c0:	479d                	li	a5,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc02021c2:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc02021c6:	2ee40063          	beq	s0,a4,ffffffffc02024a6 <vmm_init+0x396>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02021ca:	fe873603          	ld	a2,-24(a4)
ffffffffc02021ce:	ffe78693          	addi	a3,a5,-2
ffffffffc02021d2:	24d61a63          	bne	a2,a3,ffffffffc0202426 <vmm_init+0x316>
ffffffffc02021d6:	ff073683          	ld	a3,-16(a4)
ffffffffc02021da:	24f69663          	bne	a3,a5,ffffffffc0202426 <vmm_init+0x316>
ffffffffc02021de:	0795                	addi	a5,a5,5
ffffffffc02021e0:	6718                	ld	a4,8(a4)
    for (i = 1; i <= step2; i ++) {
ffffffffc02021e2:	feb792e3          	bne	a5,a1,ffffffffc02021c6 <vmm_init+0xb6>
ffffffffc02021e6:	491d                	li	s2,7
ffffffffc02021e8:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc02021ea:	1f900a93          	li	s5,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc02021ee:	85a6                	mv	a1,s1
ffffffffc02021f0:	8522                	mv	a0,s0
ffffffffc02021f2:	de5ff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
ffffffffc02021f6:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc02021f8:	30050763          	beqz	a0,ffffffffc0202506 <vmm_init+0x3f6>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc02021fc:	00148593          	addi	a1,s1,1
ffffffffc0202200:	8522                	mv	a0,s0
ffffffffc0202202:	dd5ff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
ffffffffc0202206:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202208:	2c050f63          	beqz	a0,ffffffffc02024e6 <vmm_init+0x3d6>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc020220c:	85ca                	mv	a1,s2
ffffffffc020220e:	8522                	mv	a0,s0
ffffffffc0202210:	dc7ff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
        assert(vma3 == NULL);
ffffffffc0202214:	2a051963          	bnez	a0,ffffffffc02024c6 <vmm_init+0x3b6>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0202218:	00348593          	addi	a1,s1,3
ffffffffc020221c:	8522                	mv	a0,s0
ffffffffc020221e:	db9ff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
        assert(vma4 == NULL);
ffffffffc0202222:	32051263          	bnez	a0,ffffffffc0202546 <vmm_init+0x436>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0202226:	00448593          	addi	a1,s1,4
ffffffffc020222a:	8522                	mv	a0,s0
ffffffffc020222c:	dabff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
        assert(vma5 == NULL);
ffffffffc0202230:	2e051b63          	bnez	a0,ffffffffc0202526 <vmm_init+0x416>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0202234:	008a3783          	ld	a5,8(s4)
ffffffffc0202238:	20979763          	bne	a5,s1,ffffffffc0202446 <vmm_init+0x336>
ffffffffc020223c:	010a3783          	ld	a5,16(s4)
ffffffffc0202240:	21279363          	bne	a5,s2,ffffffffc0202446 <vmm_init+0x336>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0202244:	0089b783          	ld	a5,8(s3)
ffffffffc0202248:	20979f63          	bne	a5,s1,ffffffffc0202466 <vmm_init+0x356>
ffffffffc020224c:	0109b783          	ld	a5,16(s3)
ffffffffc0202250:	21279b63          	bne	a5,s2,ffffffffc0202466 <vmm_init+0x356>
ffffffffc0202254:	0495                	addi	s1,s1,5
ffffffffc0202256:	0915                	addi	s2,s2,5
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0202258:	f9549be3          	bne	s1,s5,ffffffffc02021ee <vmm_init+0xde>
ffffffffc020225c:	4491                	li	s1,4
    }

    for (i =4; i>=0; i--) {
ffffffffc020225e:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0202260:	85a6                	mv	a1,s1
ffffffffc0202262:	8522                	mv	a0,s0
ffffffffc0202264:	d73ff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
ffffffffc0202268:	0004859b          	sext.w	a1,s1
        if (vma_below_5 != NULL ) {
ffffffffc020226c:	c90d                	beqz	a0,ffffffffc020229e <vmm_init+0x18e>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc020226e:	6914                	ld	a3,16(a0)
ffffffffc0202270:	6510                	ld	a2,8(a0)
ffffffffc0202272:	00004517          	auipc	a0,0x4
ffffffffc0202276:	06e50513          	addi	a0,a0,110 # ffffffffc02062e0 <commands+0x1290>
ffffffffc020227a:	e57fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc020227e:	00004697          	auipc	a3,0x4
ffffffffc0202282:	08a68693          	addi	a3,a3,138 # ffffffffc0206308 <commands+0x12b8>
ffffffffc0202286:	00003617          	auipc	a2,0x3
ffffffffc020228a:	76260613          	addi	a2,a2,1890 # ffffffffc02059e8 <commands+0x998>
ffffffffc020228e:	0f100593          	li	a1,241
ffffffffc0202292:	00004517          	auipc	a0,0x4
ffffffffc0202296:	e0e50513          	addi	a0,a0,-498 # ffffffffc02060a0 <commands+0x1050>
ffffffffc020229a:	f3dfd0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc020229e:	14fd                	addi	s1,s1,-1
    for (i =4; i>=0; i--) {
ffffffffc02022a0:	fd2490e3          	bne	s1,s2,ffffffffc0202260 <vmm_init+0x150>
    }

    mm_destroy(mm);
ffffffffc02022a4:	8522                	mv	a0,s0
ffffffffc02022a6:	e3dff0ef          	jal	ra,ffffffffc02020e2 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc02022aa:	00004517          	auipc	a0,0x4
ffffffffc02022ae:	07650513          	addi	a0,a0,118 # ffffffffc0206320 <commands+0x12d0>
ffffffffc02022b2:	e1ffd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc02022b6:	9d3fe0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>
ffffffffc02022ba:	89aa                	mv	s3,a0

    check_mm_struct = mm_create();
ffffffffc02022bc:	ca1ff0ef          	jal	ra,ffffffffc0201f5c <mm_create>
ffffffffc02022c0:	00014797          	auipc	a5,0x14
ffffffffc02022c4:	24a7b423          	sd	a0,584(a5) # ffffffffc0216508 <check_mm_struct>
ffffffffc02022c8:	84aa                	mv	s1,a0
    assert(check_mm_struct != NULL);
ffffffffc02022ca:	36050663          	beqz	a0,ffffffffc0202636 <vmm_init+0x526>

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02022ce:	00014797          	auipc	a5,0x14
ffffffffc02022d2:	1b278793          	addi	a5,a5,434 # ffffffffc0216480 <boot_pgdir>
ffffffffc02022d6:	0007b903          	ld	s2,0(a5)
    assert(pgdir[0] == 0);
ffffffffc02022da:	00093783          	ld	a5,0(s2)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02022de:	01253c23          	sd	s2,24(a0)
    assert(pgdir[0] == 0);
ffffffffc02022e2:	2c079e63          	bnez	a5,ffffffffc02025be <vmm_init+0x4ae>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02022e6:	03000513          	li	a0,48
ffffffffc02022ea:	722000ef          	jal	ra,ffffffffc0202a0c <kmalloc>
ffffffffc02022ee:	842a                	mv	s0,a0
    if (vma != NULL) {
ffffffffc02022f0:	18050b63          	beqz	a0,ffffffffc0202486 <vmm_init+0x376>
        vma->vm_end = vm_end;
ffffffffc02022f4:	002007b7          	lui	a5,0x200
ffffffffc02022f8:	e81c                	sd	a5,16(s0)
        vma->vm_flags = vm_flags;
ffffffffc02022fa:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc02022fc:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc02022fe:	cc1c                	sw	a5,24(s0)
    insert_vma_struct(mm, vma);
ffffffffc0202300:	8526                	mv	a0,s1
        vma->vm_start = vm_start;
ffffffffc0202302:	00043423          	sd	zero,8(s0)
    insert_vma_struct(mm, vma);
ffffffffc0202306:	d0fff0ef          	jal	ra,ffffffffc0202014 <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc020230a:	10000593          	li	a1,256
ffffffffc020230e:	8526                	mv	a0,s1
ffffffffc0202310:	cc7ff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>
ffffffffc0202314:	10000793          	li	a5,256

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
ffffffffc0202318:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc020231c:	2ca41163          	bne	s0,a0,ffffffffc02025de <vmm_init+0x4ce>
        *(char *)(addr + i) = i;
ffffffffc0202320:	00f78023          	sb	a5,0(a5) # 200000 <BASE_ADDRESS-0xffffffffc0000000>
        sum += i;
ffffffffc0202324:	0785                	addi	a5,a5,1
    for (i = 0; i < 100; i ++) {
ffffffffc0202326:	fee79de3          	bne	a5,a4,ffffffffc0202320 <vmm_init+0x210>
        sum += i;
ffffffffc020232a:	6705                	lui	a4,0x1
    for (i = 0; i < 100; i ++) {
ffffffffc020232c:	10000793          	li	a5,256
        sum += i;
ffffffffc0202330:	35670713          	addi	a4,a4,854 # 1356 <BASE_ADDRESS-0xffffffffc01fecaa>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0202334:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc0202338:	0007c683          	lbu	a3,0(a5)
ffffffffc020233c:	0785                	addi	a5,a5,1
ffffffffc020233e:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0202340:	fec79ce3          	bne	a5,a2,ffffffffc0202338 <vmm_init+0x228>
    }
    assert(sum == 0);
ffffffffc0202344:	2c071963          	bnez	a4,ffffffffc0202616 <vmm_init+0x506>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202348:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc020234c:	00014a97          	auipc	s5,0x14
ffffffffc0202350:	13ca8a93          	addi	s5,s5,316 # ffffffffc0216488 <npage>
ffffffffc0202354:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202358:	078a                	slli	a5,a5,0x2
ffffffffc020235a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020235c:	20e7f563          	bleu	a4,a5,ffffffffc0202566 <vmm_init+0x456>
    return &pages[PPN(pa) - nbase];
ffffffffc0202360:	00005697          	auipc	a3,0x5
ffffffffc0202364:	ca068693          	addi	a3,a3,-864 # ffffffffc0207000 <nbase>
ffffffffc0202368:	0006ba03          	ld	s4,0(a3)
ffffffffc020236c:	414786b3          	sub	a3,a5,s4
ffffffffc0202370:	069a                	slli	a3,a3,0x6
    return page - pages + nbase;
ffffffffc0202372:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202374:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0202376:	96d2                	add	a3,a3,s4
    return KADDR(page2pa(page));
ffffffffc0202378:	83b1                	srli	a5,a5,0xc
ffffffffc020237a:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020237c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020237e:	28e7f063          	bleu	a4,a5,ffffffffc02025fe <vmm_init+0x4ee>
ffffffffc0202382:	00014797          	auipc	a5,0x14
ffffffffc0202386:	15e78793          	addi	a5,a5,350 # ffffffffc02164e0 <va_pa_offset>
ffffffffc020238a:	6380                	ld	s0,0(a5)

    pde_t *pd1=pgdir,*pd0=page2kva(pde2page(pgdir[0]));
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc020238c:	4581                	li	a1,0
ffffffffc020238e:	854a                	mv	a0,s2
ffffffffc0202390:	9436                	add	s0,s0,a3
ffffffffc0202392:	b6bfe0ef          	jal	ra,ffffffffc0200efc <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202396:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0202398:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc020239c:	078a                	slli	a5,a5,0x2
ffffffffc020239e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02023a0:	1ce7f363          	bleu	a4,a5,ffffffffc0202566 <vmm_init+0x456>
    return &pages[PPN(pa) - nbase];
ffffffffc02023a4:	00014417          	auipc	s0,0x14
ffffffffc02023a8:	14c40413          	addi	s0,s0,332 # ffffffffc02164f0 <pages>
ffffffffc02023ac:	6008                	ld	a0,0(s0)
ffffffffc02023ae:	414787b3          	sub	a5,a5,s4
ffffffffc02023b2:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd0[0]));
ffffffffc02023b4:	953e                	add	a0,a0,a5
ffffffffc02023b6:	4585                	li	a1,1
ffffffffc02023b8:	88bfe0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc02023bc:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc02023c0:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023c4:	078a                	slli	a5,a5,0x2
ffffffffc02023c6:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02023c8:	18e7ff63          	bleu	a4,a5,ffffffffc0202566 <vmm_init+0x456>
    return &pages[PPN(pa) - nbase];
ffffffffc02023cc:	6008                	ld	a0,0(s0)
ffffffffc02023ce:	414787b3          	sub	a5,a5,s4
ffffffffc02023d2:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc02023d4:	4585                	li	a1,1
ffffffffc02023d6:	953e                	add	a0,a0,a5
ffffffffc02023d8:	86bfe0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    pgdir[0] = 0;
ffffffffc02023dc:	00093023          	sd	zero,0(s2)
  asm volatile("sfence.vma");
ffffffffc02023e0:	12000073          	sfence.vma
    flush_tlb();

    mm->pgdir = NULL;
ffffffffc02023e4:	0004bc23          	sd	zero,24(s1)
    mm_destroy(mm);
ffffffffc02023e8:	8526                	mv	a0,s1
ffffffffc02023ea:	cf9ff0ef          	jal	ra,ffffffffc02020e2 <mm_destroy>
    check_mm_struct = NULL;
ffffffffc02023ee:	00014797          	auipc	a5,0x14
ffffffffc02023f2:	1007bd23          	sd	zero,282(a5) # ffffffffc0216508 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc02023f6:	893fe0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>
ffffffffc02023fa:	1aa99263          	bne	s3,a0,ffffffffc020259e <vmm_init+0x48e>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc02023fe:	00004517          	auipc	a0,0x4
ffffffffc0202402:	fc250513          	addi	a0,a0,-62 # ffffffffc02063c0 <commands+0x1370>
ffffffffc0202406:	ccbfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc020240a:	7442                	ld	s0,48(sp)
ffffffffc020240c:	70e2                	ld	ra,56(sp)
ffffffffc020240e:	74a2                	ld	s1,40(sp)
ffffffffc0202410:	7902                	ld	s2,32(sp)
ffffffffc0202412:	69e2                	ld	s3,24(sp)
ffffffffc0202414:	6a42                	ld	s4,16(sp)
ffffffffc0202416:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202418:	00004517          	auipc	a0,0x4
ffffffffc020241c:	fc850513          	addi	a0,a0,-56 # ffffffffc02063e0 <commands+0x1390>
}
ffffffffc0202420:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202422:	caffd06f          	j	ffffffffc02000d0 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202426:	00004697          	auipc	a3,0x4
ffffffffc020242a:	dd268693          	addi	a3,a3,-558 # ffffffffc02061f8 <commands+0x11a8>
ffffffffc020242e:	00003617          	auipc	a2,0x3
ffffffffc0202432:	5ba60613          	addi	a2,a2,1466 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202436:	0d800593          	li	a1,216
ffffffffc020243a:	00004517          	auipc	a0,0x4
ffffffffc020243e:	c6650513          	addi	a0,a0,-922 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202442:	d95fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0202446:	00004697          	auipc	a3,0x4
ffffffffc020244a:	e3a68693          	addi	a3,a3,-454 # ffffffffc0206280 <commands+0x1230>
ffffffffc020244e:	00003617          	auipc	a2,0x3
ffffffffc0202452:	59a60613          	addi	a2,a2,1434 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202456:	0e800593          	li	a1,232
ffffffffc020245a:	00004517          	auipc	a0,0x4
ffffffffc020245e:	c4650513          	addi	a0,a0,-954 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202462:	d75fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0202466:	00004697          	auipc	a3,0x4
ffffffffc020246a:	e4a68693          	addi	a3,a3,-438 # ffffffffc02062b0 <commands+0x1260>
ffffffffc020246e:	00003617          	auipc	a2,0x3
ffffffffc0202472:	57a60613          	addi	a2,a2,1402 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202476:	0e900593          	li	a1,233
ffffffffc020247a:	00004517          	auipc	a0,0x4
ffffffffc020247e:	c2650513          	addi	a0,a0,-986 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202482:	d55fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(vma != NULL);
ffffffffc0202486:	00004697          	auipc	a3,0x4
ffffffffc020248a:	f7268693          	addi	a3,a3,-142 # ffffffffc02063f8 <commands+0x13a8>
ffffffffc020248e:	00003617          	auipc	a2,0x3
ffffffffc0202492:	55a60613          	addi	a2,a2,1370 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202496:	10800593          	li	a1,264
ffffffffc020249a:	00004517          	auipc	a0,0x4
ffffffffc020249e:	c0650513          	addi	a0,a0,-1018 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02024a2:	d35fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc02024a6:	00004697          	auipc	a3,0x4
ffffffffc02024aa:	d3a68693          	addi	a3,a3,-710 # ffffffffc02061e0 <commands+0x1190>
ffffffffc02024ae:	00003617          	auipc	a2,0x3
ffffffffc02024b2:	53a60613          	addi	a2,a2,1338 # ffffffffc02059e8 <commands+0x998>
ffffffffc02024b6:	0d600593          	li	a1,214
ffffffffc02024ba:	00004517          	auipc	a0,0x4
ffffffffc02024be:	be650513          	addi	a0,a0,-1050 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02024c2:	d15fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma3 == NULL);
ffffffffc02024c6:	00004697          	auipc	a3,0x4
ffffffffc02024ca:	d8a68693          	addi	a3,a3,-630 # ffffffffc0206250 <commands+0x1200>
ffffffffc02024ce:	00003617          	auipc	a2,0x3
ffffffffc02024d2:	51a60613          	addi	a2,a2,1306 # ffffffffc02059e8 <commands+0x998>
ffffffffc02024d6:	0e200593          	li	a1,226
ffffffffc02024da:	00004517          	auipc	a0,0x4
ffffffffc02024de:	bc650513          	addi	a0,a0,-1082 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02024e2:	cf5fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma2 != NULL);
ffffffffc02024e6:	00004697          	auipc	a3,0x4
ffffffffc02024ea:	d5a68693          	addi	a3,a3,-678 # ffffffffc0206240 <commands+0x11f0>
ffffffffc02024ee:	00003617          	auipc	a2,0x3
ffffffffc02024f2:	4fa60613          	addi	a2,a2,1274 # ffffffffc02059e8 <commands+0x998>
ffffffffc02024f6:	0e000593          	li	a1,224
ffffffffc02024fa:	00004517          	auipc	a0,0x4
ffffffffc02024fe:	ba650513          	addi	a0,a0,-1114 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202502:	cd5fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma1 != NULL);
ffffffffc0202506:	00004697          	auipc	a3,0x4
ffffffffc020250a:	d2a68693          	addi	a3,a3,-726 # ffffffffc0206230 <commands+0x11e0>
ffffffffc020250e:	00003617          	auipc	a2,0x3
ffffffffc0202512:	4da60613          	addi	a2,a2,1242 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202516:	0de00593          	li	a1,222
ffffffffc020251a:	00004517          	auipc	a0,0x4
ffffffffc020251e:	b8650513          	addi	a0,a0,-1146 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202522:	cb5fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma5 == NULL);
ffffffffc0202526:	00004697          	auipc	a3,0x4
ffffffffc020252a:	d4a68693          	addi	a3,a3,-694 # ffffffffc0206270 <commands+0x1220>
ffffffffc020252e:	00003617          	auipc	a2,0x3
ffffffffc0202532:	4ba60613          	addi	a2,a2,1210 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202536:	0e600593          	li	a1,230
ffffffffc020253a:	00004517          	auipc	a0,0x4
ffffffffc020253e:	b6650513          	addi	a0,a0,-1178 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202542:	c95fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        assert(vma4 == NULL);
ffffffffc0202546:	00004697          	auipc	a3,0x4
ffffffffc020254a:	d1a68693          	addi	a3,a3,-742 # ffffffffc0206260 <commands+0x1210>
ffffffffc020254e:	00003617          	auipc	a2,0x3
ffffffffc0202552:	49a60613          	addi	a2,a2,1178 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202556:	0e400593          	li	a1,228
ffffffffc020255a:	00004517          	auipc	a0,0x4
ffffffffc020255e:	b4650513          	addi	a0,a0,-1210 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202562:	c75fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202566:	00003617          	auipc	a2,0x3
ffffffffc020256a:	36260613          	addi	a2,a2,866 # ffffffffc02058c8 <commands+0x878>
ffffffffc020256e:	06300593          	li	a1,99
ffffffffc0202572:	00003517          	auipc	a0,0x3
ffffffffc0202576:	37650513          	addi	a0,a0,886 # ffffffffc02058e8 <commands+0x898>
ffffffffc020257a:	c5dfd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(mm != NULL);
ffffffffc020257e:	00004697          	auipc	a3,0x4
ffffffffc0202582:	c5268693          	addi	a3,a3,-942 # ffffffffc02061d0 <commands+0x1180>
ffffffffc0202586:	00003617          	auipc	a2,0x3
ffffffffc020258a:	46260613          	addi	a2,a2,1122 # ffffffffc02059e8 <commands+0x998>
ffffffffc020258e:	0c200593          	li	a1,194
ffffffffc0202592:	00004517          	auipc	a0,0x4
ffffffffc0202596:	b0e50513          	addi	a0,a0,-1266 # ffffffffc02060a0 <commands+0x1050>
ffffffffc020259a:	c3dfd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc020259e:	00004697          	auipc	a3,0x4
ffffffffc02025a2:	dfa68693          	addi	a3,a3,-518 # ffffffffc0206398 <commands+0x1348>
ffffffffc02025a6:	00003617          	auipc	a2,0x3
ffffffffc02025aa:	44260613          	addi	a2,a2,1090 # ffffffffc02059e8 <commands+0x998>
ffffffffc02025ae:	12400593          	li	a1,292
ffffffffc02025b2:	00004517          	auipc	a0,0x4
ffffffffc02025b6:	aee50513          	addi	a0,a0,-1298 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02025ba:	c1dfd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(pgdir[0] == 0);
ffffffffc02025be:	00004697          	auipc	a3,0x4
ffffffffc02025c2:	d9a68693          	addi	a3,a3,-614 # ffffffffc0206358 <commands+0x1308>
ffffffffc02025c6:	00003617          	auipc	a2,0x3
ffffffffc02025ca:	42260613          	addi	a2,a2,1058 # ffffffffc02059e8 <commands+0x998>
ffffffffc02025ce:	10500593          	li	a1,261
ffffffffc02025d2:	00004517          	auipc	a0,0x4
ffffffffc02025d6:	ace50513          	addi	a0,a0,-1330 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02025da:	bfdfd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc02025de:	00004697          	auipc	a3,0x4
ffffffffc02025e2:	d8a68693          	addi	a3,a3,-630 # ffffffffc0206368 <commands+0x1318>
ffffffffc02025e6:	00003617          	auipc	a2,0x3
ffffffffc02025ea:	40260613          	addi	a2,a2,1026 # ffffffffc02059e8 <commands+0x998>
ffffffffc02025ee:	10d00593          	li	a1,269
ffffffffc02025f2:	00004517          	auipc	a0,0x4
ffffffffc02025f6:	aae50513          	addi	a0,a0,-1362 # ffffffffc02060a0 <commands+0x1050>
ffffffffc02025fa:	bddfd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    return KADDR(page2pa(page));
ffffffffc02025fe:	00003617          	auipc	a2,0x3
ffffffffc0202602:	29260613          	addi	a2,a2,658 # ffffffffc0205890 <commands+0x840>
ffffffffc0202606:	06a00593          	li	a1,106
ffffffffc020260a:	00003517          	auipc	a0,0x3
ffffffffc020260e:	2de50513          	addi	a0,a0,734 # ffffffffc02058e8 <commands+0x898>
ffffffffc0202612:	bc5fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(sum == 0);
ffffffffc0202616:	00004697          	auipc	a3,0x4
ffffffffc020261a:	d7268693          	addi	a3,a3,-654 # ffffffffc0206388 <commands+0x1338>
ffffffffc020261e:	00003617          	auipc	a2,0x3
ffffffffc0202622:	3ca60613          	addi	a2,a2,970 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202626:	11700593          	li	a1,279
ffffffffc020262a:	00004517          	auipc	a0,0x4
ffffffffc020262e:	a7650513          	addi	a0,a0,-1418 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202632:	ba5fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc0202636:	00004697          	auipc	a3,0x4
ffffffffc020263a:	d0a68693          	addi	a3,a3,-758 # ffffffffc0206340 <commands+0x12f0>
ffffffffc020263e:	00003617          	auipc	a2,0x3
ffffffffc0202642:	3aa60613          	addi	a2,a2,938 # ffffffffc02059e8 <commands+0x998>
ffffffffc0202646:	10100593          	li	a1,257
ffffffffc020264a:	00004517          	auipc	a0,0x4
ffffffffc020264e:	a5650513          	addi	a0,a0,-1450 # ffffffffc02060a0 <commands+0x1050>
ffffffffc0202652:	b85fd0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0202656 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
ffffffffc0202656:	7139                	addi	sp,sp,-64
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0202658:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
ffffffffc020265a:	f822                	sd	s0,48(sp)
ffffffffc020265c:	f426                	sd	s1,40(sp)
ffffffffc020265e:	fc06                	sd	ra,56(sp)
ffffffffc0202660:	f04a                	sd	s2,32(sp)
ffffffffc0202662:	ec4e                	sd	s3,24(sp)
ffffffffc0202664:	8432                	mv	s0,a2
ffffffffc0202666:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0202668:	96fff0ef          	jal	ra,ffffffffc0201fd6 <find_vma>

    pgfault_num++;
ffffffffc020266c:	00014797          	auipc	a5,0x14
ffffffffc0202670:	e2478793          	addi	a5,a5,-476 # ffffffffc0216490 <pgfault_num>
ffffffffc0202674:	439c                	lw	a5,0(a5)
ffffffffc0202676:	2785                	addiw	a5,a5,1
ffffffffc0202678:	00014717          	auipc	a4,0x14
ffffffffc020267c:	e0f72c23          	sw	a5,-488(a4) # ffffffffc0216490 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc0202680:	c555                	beqz	a0,ffffffffc020272c <do_pgfault+0xd6>
ffffffffc0202682:	651c                	ld	a5,8(a0)
ffffffffc0202684:	0af46463          	bltu	s0,a5,ffffffffc020272c <do_pgfault+0xd6>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc0202688:	4d1c                	lw	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc020268a:	49c1                	li	s3,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc020268c:	8b89                	andi	a5,a5,2
ffffffffc020268e:	e3a5                	bnez	a5,ffffffffc02026ee <do_pgfault+0x98>
        perm |= READ_WRITE;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0202690:	767d                	lui	a2,0xfffff

    pte_t *ptep=NULL;
  
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0202692:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0202694:	8c71                	and	s0,s0,a2
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc0202696:	85a2                	mv	a1,s0
ffffffffc0202698:	4605                	li	a2,1
ffffffffc020269a:	e2efe0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc020269e:	c945                	beqz	a0,ffffffffc020274e <do_pgfault+0xf8>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc02026a0:	610c                	ld	a1,0(a0)
ffffffffc02026a2:	c5b5                	beqz	a1,ffffffffc020270e <do_pgfault+0xb8>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc02026a4:	00014797          	auipc	a5,0x14
ffffffffc02026a8:	e0478793          	addi	a5,a5,-508 # ffffffffc02164a8 <swap_init_ok>
ffffffffc02026ac:	439c                	lw	a5,0(a5)
ffffffffc02026ae:	2781                	sext.w	a5,a5
ffffffffc02026b0:	c7d9                	beqz	a5,ffffffffc020273e <do_pgfault+0xe8>
            //map of phy addr <--->
            //logical addr
            //(3) make the page swappable.
            
            // 将addr线性地址对应的物理页数据从磁盘交换到物理内存中(令Page指针指向交换成功后的物理页)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc02026b2:	0030                	addi	a2,sp,8
ffffffffc02026b4:	85a2                	mv	a1,s0
ffffffffc02026b6:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc02026b8:	e402                	sd	zero,8(sp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc02026ba:	5db000ef          	jal	ra,ffffffffc0203494 <swap_in>
ffffffffc02026be:	892a                	mv	s2,a0
ffffffffc02026c0:	e90d                	bnez	a0,ffffffffc02026f2 <do_pgfault+0x9c>
                // swap_in返回值不为0，表示换入失败
                cprintf("do_pgfault：swap_in failed\n");
                goto failed;
            }    
            // 将交换进来的page页与mm->padir页表中对应addr的二级页表项建立映射关系(perm标识这个二级页表的各个权限位)
            page_insert(mm->pgdir, page, addr, perm);
ffffffffc02026c2:	65a2                	ld	a1,8(sp)
ffffffffc02026c4:	6c88                	ld	a0,24(s1)
ffffffffc02026c6:	86ce                	mv	a3,s3
ffffffffc02026c8:	8622                	mv	a2,s0
ffffffffc02026ca:	8a7fe0ef          	jal	ra,ffffffffc0200f70 <page_insert>
            
            // 当前page是为可交换的，将其加入全局虚拟内存交换管理器的管理
            swap_map_swappable(mm, addr, page, 1);
ffffffffc02026ce:	6622                	ld	a2,8(sp)
ffffffffc02026d0:	4685                	li	a3,1
ffffffffc02026d2:	85a2                	mv	a1,s0
ffffffffc02026d4:	8526                	mv	a0,s1
ffffffffc02026d6:	49b000ef          	jal	ra,ffffffffc0203370 <swap_map_swappable>

            page->pra_vaddr = addr;
ffffffffc02026da:	67a2                	ld	a5,8(sp)
ffffffffc02026dc:	ff80                	sd	s0,56(a5)
   }

   ret = 0;
failed:
    return ret;
}
ffffffffc02026de:	70e2                	ld	ra,56(sp)
ffffffffc02026e0:	7442                	ld	s0,48(sp)
ffffffffc02026e2:	854a                	mv	a0,s2
ffffffffc02026e4:	74a2                	ld	s1,40(sp)
ffffffffc02026e6:	7902                	ld	s2,32(sp)
ffffffffc02026e8:	69e2                	ld	s3,24(sp)
ffffffffc02026ea:	6121                	addi	sp,sp,64
ffffffffc02026ec:	8082                	ret
        perm |= READ_WRITE;
ffffffffc02026ee:	49dd                	li	s3,23
ffffffffc02026f0:	b745                	j	ffffffffc0202690 <do_pgfault+0x3a>
                cprintf("do_pgfault：swap_in failed\n");
ffffffffc02026f2:	00004517          	auipc	a0,0x4
ffffffffc02026f6:	a3650513          	addi	a0,a0,-1482 # ffffffffc0206128 <commands+0x10d8>
ffffffffc02026fa:	9d7fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc02026fe:	70e2                	ld	ra,56(sp)
ffffffffc0202700:	7442                	ld	s0,48(sp)
ffffffffc0202702:	854a                	mv	a0,s2
ffffffffc0202704:	74a2                	ld	s1,40(sp)
ffffffffc0202706:	7902                	ld	s2,32(sp)
ffffffffc0202708:	69e2                	ld	s3,24(sp)
ffffffffc020270a:	6121                	addi	sp,sp,64
ffffffffc020270c:	8082                	ret
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc020270e:	6c88                	ld	a0,24(s1)
ffffffffc0202710:	864e                	mv	a2,s3
ffffffffc0202712:	85a2                	mv	a1,s0
ffffffffc0202714:	baaff0ef          	jal	ra,ffffffffc0201abe <pgdir_alloc_page>
   ret = 0;
ffffffffc0202718:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc020271a:	f171                	bnez	a0,ffffffffc02026de <do_pgfault+0x88>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc020271c:	00004517          	auipc	a0,0x4
ffffffffc0202720:	9e450513          	addi	a0,a0,-1564 # ffffffffc0206100 <commands+0x10b0>
ffffffffc0202724:	9adfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0202728:	5971                	li	s2,-4
            goto failed;
ffffffffc020272a:	bf55                	j	ffffffffc02026de <do_pgfault+0x88>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc020272c:	85a2                	mv	a1,s0
ffffffffc020272e:	00004517          	auipc	a0,0x4
ffffffffc0202732:	98250513          	addi	a0,a0,-1662 # ffffffffc02060b0 <commands+0x1060>
ffffffffc0202736:	99bfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    int ret = -E_INVAL;
ffffffffc020273a:	5975                	li	s2,-3
        goto failed;
ffffffffc020273c:	b74d                	j	ffffffffc02026de <do_pgfault+0x88>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc020273e:	00004517          	auipc	a0,0x4
ffffffffc0202742:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0206148 <commands+0x10f8>
ffffffffc0202746:	98bfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc020274a:	5971                	li	s2,-4
            goto failed;
ffffffffc020274c:	bf49                	j	ffffffffc02026de <do_pgfault+0x88>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc020274e:	00004517          	auipc	a0,0x4
ffffffffc0202752:	99250513          	addi	a0,a0,-1646 # ffffffffc02060e0 <commands+0x1090>
ffffffffc0202756:	97bfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc020275a:	5971                	li	s2,-4
        goto failed;
ffffffffc020275c:	b749                	j	ffffffffc02026de <do_pgfault+0x88>

ffffffffc020275e <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc020275e:	c125                	beqz	a0,ffffffffc02027be <slob_free+0x60>
		return;

	if (size)
ffffffffc0202760:	e1a5                	bnez	a1,ffffffffc02027c0 <slob_free+0x62>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202762:	100027f3          	csrr	a5,sstatus
ffffffffc0202766:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0202768:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020276a:	e3bd                	bnez	a5,ffffffffc02027d0 <slob_free+0x72>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020276c:	00009797          	auipc	a5,0x9
ffffffffc0202770:	8e478793          	addi	a5,a5,-1820 # ffffffffc020b050 <slobfree>
ffffffffc0202774:	639c                	ld	a5,0(a5)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0202776:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0202778:	00a7fa63          	bleu	a0,a5,ffffffffc020278c <slob_free+0x2e>
ffffffffc020277c:	00e56c63          	bltu	a0,a4,ffffffffc0202794 <slob_free+0x36>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0202780:	00e7fa63          	bleu	a4,a5,ffffffffc0202794 <slob_free+0x36>
    return 0;
ffffffffc0202784:	87ba                	mv	a5,a4
ffffffffc0202786:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0202788:	fea7eae3          	bltu	a5,a0,ffffffffc020277c <slob_free+0x1e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020278c:	fee7ece3          	bltu	a5,a4,ffffffffc0202784 <slob_free+0x26>
ffffffffc0202790:	fee57ae3          	bleu	a4,a0,ffffffffc0202784 <slob_free+0x26>
			break;

	if (b + b->units == cur->next) {
ffffffffc0202794:	4110                	lw	a2,0(a0)
ffffffffc0202796:	00461693          	slli	a3,a2,0x4
ffffffffc020279a:	96aa                	add	a3,a3,a0
ffffffffc020279c:	08d70b63          	beq	a4,a3,ffffffffc0202832 <slob_free+0xd4>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc02027a0:	4394                	lw	a3,0(a5)
		b->next = cur->next;
ffffffffc02027a2:	e518                	sd	a4,8(a0)
	if (cur + cur->units == b) {
ffffffffc02027a4:	00469713          	slli	a4,a3,0x4
ffffffffc02027a8:	973e                	add	a4,a4,a5
ffffffffc02027aa:	08e50f63          	beq	a0,a4,ffffffffc0202848 <slob_free+0xea>
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;
ffffffffc02027ae:	e788                	sd	a0,8(a5)

	slobfree = cur;
ffffffffc02027b0:	00009717          	auipc	a4,0x9
ffffffffc02027b4:	8af73023          	sd	a5,-1888(a4) # ffffffffc020b050 <slobfree>
    if (flag) {
ffffffffc02027b8:	c199                	beqz	a1,ffffffffc02027be <slob_free+0x60>
        intr_enable();
ffffffffc02027ba:	e1bfd06f          	j	ffffffffc02005d4 <intr_enable>
ffffffffc02027be:	8082                	ret
		b->units = SLOB_UNITS(size);
ffffffffc02027c0:	05bd                	addi	a1,a1,15
ffffffffc02027c2:	8191                	srli	a1,a1,0x4
ffffffffc02027c4:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02027c6:	100027f3          	csrr	a5,sstatus
ffffffffc02027ca:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02027cc:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02027ce:	dfd9                	beqz	a5,ffffffffc020276c <slob_free+0xe>
{
ffffffffc02027d0:	1101                	addi	sp,sp,-32
ffffffffc02027d2:	e42a                	sd	a0,8(sp)
ffffffffc02027d4:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02027d6:	e05fd0ef          	jal	ra,ffffffffc02005da <intr_disable>
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02027da:	00009797          	auipc	a5,0x9
ffffffffc02027de:	87678793          	addi	a5,a5,-1930 # ffffffffc020b050 <slobfree>
ffffffffc02027e2:	639c                	ld	a5,0(a5)
        return 1;
ffffffffc02027e4:	6522                	ld	a0,8(sp)
ffffffffc02027e6:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02027e8:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02027ea:	00a7fa63          	bleu	a0,a5,ffffffffc02027fe <slob_free+0xa0>
ffffffffc02027ee:	00e56c63          	bltu	a0,a4,ffffffffc0202806 <slob_free+0xa8>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02027f2:	00e7fa63          	bleu	a4,a5,ffffffffc0202806 <slob_free+0xa8>
    return 0;
ffffffffc02027f6:	87ba                	mv	a5,a4
ffffffffc02027f8:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02027fa:	fea7eae3          	bltu	a5,a0,ffffffffc02027ee <slob_free+0x90>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02027fe:	fee7ece3          	bltu	a5,a4,ffffffffc02027f6 <slob_free+0x98>
ffffffffc0202802:	fee57ae3          	bleu	a4,a0,ffffffffc02027f6 <slob_free+0x98>
	if (b + b->units == cur->next) {
ffffffffc0202806:	4110                	lw	a2,0(a0)
ffffffffc0202808:	00461693          	slli	a3,a2,0x4
ffffffffc020280c:	96aa                	add	a3,a3,a0
ffffffffc020280e:	04d70763          	beq	a4,a3,ffffffffc020285c <slob_free+0xfe>
		b->next = cur->next;
ffffffffc0202812:	e518                	sd	a4,8(a0)
	if (cur + cur->units == b) {
ffffffffc0202814:	4394                	lw	a3,0(a5)
ffffffffc0202816:	00469713          	slli	a4,a3,0x4
ffffffffc020281a:	973e                	add	a4,a4,a5
ffffffffc020281c:	04e50663          	beq	a0,a4,ffffffffc0202868 <slob_free+0x10a>
		cur->next = b;
ffffffffc0202820:	e788                	sd	a0,8(a5)
	slobfree = cur;
ffffffffc0202822:	00009717          	auipc	a4,0x9
ffffffffc0202826:	82f73723          	sd	a5,-2002(a4) # ffffffffc020b050 <slobfree>
    if (flag) {
ffffffffc020282a:	e58d                	bnez	a1,ffffffffc0202854 <slob_free+0xf6>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc020282c:	60e2                	ld	ra,24(sp)
ffffffffc020282e:	6105                	addi	sp,sp,32
ffffffffc0202830:	8082                	ret
		b->units += cur->next->units;
ffffffffc0202832:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0202834:	6718                	ld	a4,8(a4)
		b->units += cur->next->units;
ffffffffc0202836:	9e35                	addw	a2,a2,a3
ffffffffc0202838:	c110                	sw	a2,0(a0)
	if (cur + cur->units == b) {
ffffffffc020283a:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc020283c:	e518                	sd	a4,8(a0)
	if (cur + cur->units == b) {
ffffffffc020283e:	00469713          	slli	a4,a3,0x4
ffffffffc0202842:	973e                	add	a4,a4,a5
ffffffffc0202844:	f6e515e3          	bne	a0,a4,ffffffffc02027ae <slob_free+0x50>
		cur->units += b->units;
ffffffffc0202848:	4118                	lw	a4,0(a0)
		cur->next = b->next;
ffffffffc020284a:	6510                	ld	a2,8(a0)
		cur->units += b->units;
ffffffffc020284c:	9eb9                	addw	a3,a3,a4
ffffffffc020284e:	c394                	sw	a3,0(a5)
		cur->next = b->next;
ffffffffc0202850:	e790                	sd	a2,8(a5)
ffffffffc0202852:	bfb9                	j	ffffffffc02027b0 <slob_free+0x52>
}
ffffffffc0202854:	60e2                	ld	ra,24(sp)
ffffffffc0202856:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0202858:	d7dfd06f          	j	ffffffffc02005d4 <intr_enable>
		b->units += cur->next->units;
ffffffffc020285c:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc020285e:	6718                	ld	a4,8(a4)
		b->units += cur->next->units;
ffffffffc0202860:	9e35                	addw	a2,a2,a3
ffffffffc0202862:	c110                	sw	a2,0(a0)
		b->next = cur->next->next;
ffffffffc0202864:	e518                	sd	a4,8(a0)
ffffffffc0202866:	b77d                	j	ffffffffc0202814 <slob_free+0xb6>
		cur->units += b->units;
ffffffffc0202868:	4118                	lw	a4,0(a0)
		cur->next = b->next;
ffffffffc020286a:	6510                	ld	a2,8(a0)
		cur->units += b->units;
ffffffffc020286c:	9eb9                	addw	a3,a3,a4
ffffffffc020286e:	c394                	sw	a3,0(a5)
		cur->next = b->next;
ffffffffc0202870:	e790                	sd	a2,8(a5)
ffffffffc0202872:	bf45                	j	ffffffffc0202822 <slob_free+0xc4>

ffffffffc0202874 <__slob_get_free_pages.isra.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc0202874:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0202876:	1141                	addi	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc0202878:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020287c:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc020287e:	b3cfe0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
  if(!page)
ffffffffc0202882:	c139                	beqz	a0,ffffffffc02028c8 <__slob_get_free_pages.isra.0+0x54>
    return page - pages + nbase;
ffffffffc0202884:	00014797          	auipc	a5,0x14
ffffffffc0202888:	c6c78793          	addi	a5,a5,-916 # ffffffffc02164f0 <pages>
ffffffffc020288c:	6394                	ld	a3,0(a5)
ffffffffc020288e:	00004797          	auipc	a5,0x4
ffffffffc0202892:	77278793          	addi	a5,a5,1906 # ffffffffc0207000 <nbase>
    return KADDR(page2pa(page));
ffffffffc0202896:	00014717          	auipc	a4,0x14
ffffffffc020289a:	bf270713          	addi	a4,a4,-1038 # ffffffffc0216488 <npage>
    return page - pages + nbase;
ffffffffc020289e:	40d506b3          	sub	a3,a0,a3
ffffffffc02028a2:	6388                	ld	a0,0(a5)
ffffffffc02028a4:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02028a6:	57fd                	li	a5,-1
ffffffffc02028a8:	6318                	ld	a4,0(a4)
    return page - pages + nbase;
ffffffffc02028aa:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc02028ac:	83b1                	srli	a5,a5,0xc
ffffffffc02028ae:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02028b0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02028b2:	00e7ff63          	bleu	a4,a5,ffffffffc02028d0 <__slob_get_free_pages.isra.0+0x5c>
ffffffffc02028b6:	00014797          	auipc	a5,0x14
ffffffffc02028ba:	c2a78793          	addi	a5,a5,-982 # ffffffffc02164e0 <va_pa_offset>
ffffffffc02028be:	6388                	ld	a0,0(a5)
}
ffffffffc02028c0:	60a2                	ld	ra,8(sp)
ffffffffc02028c2:	9536                	add	a0,a0,a3
ffffffffc02028c4:	0141                	addi	sp,sp,16
ffffffffc02028c6:	8082                	ret
ffffffffc02028c8:	60a2                	ld	ra,8(sp)
    return NULL;
ffffffffc02028ca:	4501                	li	a0,0
}
ffffffffc02028cc:	0141                	addi	sp,sp,16
ffffffffc02028ce:	8082                	ret
ffffffffc02028d0:	00003617          	auipc	a2,0x3
ffffffffc02028d4:	fc060613          	addi	a2,a2,-64 # ffffffffc0205890 <commands+0x840>
ffffffffc02028d8:	06a00593          	li	a1,106
ffffffffc02028dc:	00003517          	auipc	a0,0x3
ffffffffc02028e0:	00c50513          	addi	a0,a0,12 # ffffffffc02058e8 <commands+0x898>
ffffffffc02028e4:	8f3fd0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc02028e8 <slob_alloc.isra.1.constprop.3>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02028e8:	7179                	addi	sp,sp,-48
ffffffffc02028ea:	f406                	sd	ra,40(sp)
ffffffffc02028ec:	f022                	sd	s0,32(sp)
ffffffffc02028ee:	ec26                	sd	s1,24(sp)
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02028f0:	01050713          	addi	a4,a0,16
ffffffffc02028f4:	6785                	lui	a5,0x1
ffffffffc02028f6:	0cf77b63          	bleu	a5,a4,ffffffffc02029cc <slob_alloc.isra.1.constprop.3+0xe4>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02028fa:	00f50413          	addi	s0,a0,15
ffffffffc02028fe:	8011                	srli	s0,s0,0x4
ffffffffc0202900:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202902:	10002673          	csrr	a2,sstatus
ffffffffc0202906:	8a09                	andi	a2,a2,2
ffffffffc0202908:	ea5d                	bnez	a2,ffffffffc02029be <slob_alloc.isra.1.constprop.3+0xd6>
	prev = slobfree;
ffffffffc020290a:	00008497          	auipc	s1,0x8
ffffffffc020290e:	74648493          	addi	s1,s1,1862 # ffffffffc020b050 <slobfree>
ffffffffc0202912:	6094                	ld	a3,0(s1)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0202914:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0202916:	4398                	lw	a4,0(a5)
ffffffffc0202918:	0a875763          	ble	s0,a4,ffffffffc02029c6 <slob_alloc.isra.1.constprop.3+0xde>
		if (cur == slobfree) {
ffffffffc020291c:	00f68a63          	beq	a3,a5,ffffffffc0202930 <slob_alloc.isra.1.constprop.3+0x48>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0202920:	6788                	ld	a0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0202922:	4118                	lw	a4,0(a0)
ffffffffc0202924:	02875763          	ble	s0,a4,ffffffffc0202952 <slob_alloc.isra.1.constprop.3+0x6a>
ffffffffc0202928:	6094                	ld	a3,0(s1)
ffffffffc020292a:	87aa                	mv	a5,a0
		if (cur == slobfree) {
ffffffffc020292c:	fef69ae3          	bne	a3,a5,ffffffffc0202920 <slob_alloc.isra.1.constprop.3+0x38>
    if (flag) {
ffffffffc0202930:	ea39                	bnez	a2,ffffffffc0202986 <slob_alloc.isra.1.constprop.3+0x9e>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0202932:	4501                	li	a0,0
ffffffffc0202934:	f41ff0ef          	jal	ra,ffffffffc0202874 <__slob_get_free_pages.isra.0>
			if (!cur)
ffffffffc0202938:	cd29                	beqz	a0,ffffffffc0202992 <slob_alloc.isra.1.constprop.3+0xaa>
			slob_free(cur, PAGE_SIZE);
ffffffffc020293a:	6585                	lui	a1,0x1
ffffffffc020293c:	e23ff0ef          	jal	ra,ffffffffc020275e <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202940:	10002673          	csrr	a2,sstatus
ffffffffc0202944:	8a09                	andi	a2,a2,2
ffffffffc0202946:	ea1d                	bnez	a2,ffffffffc020297c <slob_alloc.isra.1.constprop.3+0x94>
			cur = slobfree;
ffffffffc0202948:	609c                	ld	a5,0(s1)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc020294a:	6788                	ld	a0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020294c:	4118                	lw	a4,0(a0)
ffffffffc020294e:	fc874de3          	blt	a4,s0,ffffffffc0202928 <slob_alloc.isra.1.constprop.3+0x40>
			if (cur->units == units) /* exact fit? */
ffffffffc0202952:	04e40663          	beq	s0,a4,ffffffffc020299e <slob_alloc.isra.1.constprop.3+0xb6>
				prev->next = cur + units;
ffffffffc0202956:	00441693          	slli	a3,s0,0x4
ffffffffc020295a:	96aa                	add	a3,a3,a0
ffffffffc020295c:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc020295e:	650c                	ld	a1,8(a0)
				prev->next->units = cur->units - units;
ffffffffc0202960:	9f01                	subw	a4,a4,s0
ffffffffc0202962:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0202964:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0202966:	c100                	sw	s0,0(a0)
			slobfree = prev;
ffffffffc0202968:	00008717          	auipc	a4,0x8
ffffffffc020296c:	6ef73423          	sd	a5,1768(a4) # ffffffffc020b050 <slobfree>
    if (flag) {
ffffffffc0202970:	ee15                	bnez	a2,ffffffffc02029ac <slob_alloc.isra.1.constprop.3+0xc4>
}
ffffffffc0202972:	70a2                	ld	ra,40(sp)
ffffffffc0202974:	7402                	ld	s0,32(sp)
ffffffffc0202976:	64e2                	ld	s1,24(sp)
ffffffffc0202978:	6145                	addi	sp,sp,48
ffffffffc020297a:	8082                	ret
        intr_disable();
ffffffffc020297c:	c5ffd0ef          	jal	ra,ffffffffc02005da <intr_disable>
ffffffffc0202980:	4605                	li	a2,1
			cur = slobfree;
ffffffffc0202982:	609c                	ld	a5,0(s1)
ffffffffc0202984:	b7d9                	j	ffffffffc020294a <slob_alloc.isra.1.constprop.3+0x62>
        intr_enable();
ffffffffc0202986:	c4ffd0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc020298a:	4501                	li	a0,0
ffffffffc020298c:	ee9ff0ef          	jal	ra,ffffffffc0202874 <__slob_get_free_pages.isra.0>
			if (!cur)
ffffffffc0202990:	f54d                	bnez	a0,ffffffffc020293a <slob_alloc.isra.1.constprop.3+0x52>
}
ffffffffc0202992:	70a2                	ld	ra,40(sp)
ffffffffc0202994:	7402                	ld	s0,32(sp)
ffffffffc0202996:	64e2                	ld	s1,24(sp)
				return 0;
ffffffffc0202998:	4501                	li	a0,0
}
ffffffffc020299a:	6145                	addi	sp,sp,48
ffffffffc020299c:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc020299e:	6518                	ld	a4,8(a0)
ffffffffc02029a0:	e798                	sd	a4,8(a5)
			slobfree = prev;
ffffffffc02029a2:	00008717          	auipc	a4,0x8
ffffffffc02029a6:	6af73723          	sd	a5,1710(a4) # ffffffffc020b050 <slobfree>
    if (flag) {
ffffffffc02029aa:	d661                	beqz	a2,ffffffffc0202972 <slob_alloc.isra.1.constprop.3+0x8a>
ffffffffc02029ac:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02029ae:	c27fd0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
}
ffffffffc02029b2:	70a2                	ld	ra,40(sp)
ffffffffc02029b4:	7402                	ld	s0,32(sp)
ffffffffc02029b6:	6522                	ld	a0,8(sp)
ffffffffc02029b8:	64e2                	ld	s1,24(sp)
ffffffffc02029ba:	6145                	addi	sp,sp,48
ffffffffc02029bc:	8082                	ret
        intr_disable();
ffffffffc02029be:	c1dfd0ef          	jal	ra,ffffffffc02005da <intr_disable>
ffffffffc02029c2:	4605                	li	a2,1
ffffffffc02029c4:	b799                	j	ffffffffc020290a <slob_alloc.isra.1.constprop.3+0x22>
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02029c6:	853e                	mv	a0,a5
ffffffffc02029c8:	87b6                	mv	a5,a3
ffffffffc02029ca:	b761                	j	ffffffffc0202952 <slob_alloc.isra.1.constprop.3+0x6a>
	assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02029cc:	00004697          	auipc	a3,0x4
ffffffffc02029d0:	a5c68693          	addi	a3,a3,-1444 # ffffffffc0206428 <commands+0x13d8>
ffffffffc02029d4:	00003617          	auipc	a2,0x3
ffffffffc02029d8:	01460613          	addi	a2,a2,20 # ffffffffc02059e8 <commands+0x998>
ffffffffc02029dc:	06300593          	li	a1,99
ffffffffc02029e0:	00004517          	auipc	a0,0x4
ffffffffc02029e4:	a6850513          	addi	a0,a0,-1432 # ffffffffc0206448 <commands+0x13f8>
ffffffffc02029e8:	feefd0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc02029ec <kmalloc_init>:
slob_init(void) {
  cprintf("use SLOB allocator\n");
}

inline void 
kmalloc_init(void) {
ffffffffc02029ec:	1141                	addi	sp,sp,-16
  cprintf("use SLOB allocator\n");
ffffffffc02029ee:	00004517          	auipc	a0,0x4
ffffffffc02029f2:	a7250513          	addi	a0,a0,-1422 # ffffffffc0206460 <commands+0x1410>
kmalloc_init(void) {
ffffffffc02029f6:	e406                	sd	ra,8(sp)
  cprintf("use SLOB allocator\n");
ffffffffc02029f8:	ed8fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    slob_init();
    cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc02029fc:	60a2                	ld	ra,8(sp)
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc02029fe:	00004517          	auipc	a0,0x4
ffffffffc0202a02:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0206408 <commands+0x13b8>
}
ffffffffc0202a06:	0141                	addi	sp,sp,16
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc0202a08:	ec8fd06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc0202a0c <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0202a0c:	1101                	addi	sp,sp,-32
ffffffffc0202a0e:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0202a10:	6905                	lui	s2,0x1
{
ffffffffc0202a12:	e822                	sd	s0,16(sp)
ffffffffc0202a14:	ec06                	sd	ra,24(sp)
ffffffffc0202a16:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0202a18:	fef90793          	addi	a5,s2,-17 # fef <BASE_ADDRESS-0xffffffffc01ff011>
{
ffffffffc0202a1c:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc0202a1e:	04a7fc63          	bleu	a0,a5,ffffffffc0202a76 <kmalloc+0x6a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0202a22:	4561                	li	a0,24
ffffffffc0202a24:	ec5ff0ef          	jal	ra,ffffffffc02028e8 <slob_alloc.isra.1.constprop.3>
ffffffffc0202a28:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0202a2a:	cd21                	beqz	a0,ffffffffc0202a82 <kmalloc+0x76>
	bb->order = find_order(size);
ffffffffc0202a2c:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0202a30:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc0202a32:	00f95763          	ble	a5,s2,ffffffffc0202a40 <kmalloc+0x34>
ffffffffc0202a36:	6705                	lui	a4,0x1
ffffffffc0202a38:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0202a3a:	2505                	addiw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc0202a3c:	fef74ee3          	blt	a4,a5,ffffffffc0202a38 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0202a40:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0202a42:	e33ff0ef          	jal	ra,ffffffffc0202874 <__slob_get_free_pages.isra.0>
ffffffffc0202a46:	e488                	sd	a0,8(s1)
ffffffffc0202a48:	842a                	mv	s0,a0
	if (bb->pages) {
ffffffffc0202a4a:	c935                	beqz	a0,ffffffffc0202abe <kmalloc+0xb2>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202a4c:	100027f3          	csrr	a5,sstatus
ffffffffc0202a50:	8b89                	andi	a5,a5,2
ffffffffc0202a52:	e3a1                	bnez	a5,ffffffffc0202a92 <kmalloc+0x86>
		bb->next = bigblocks;
ffffffffc0202a54:	00014797          	auipc	a5,0x14
ffffffffc0202a58:	a4478793          	addi	a5,a5,-1468 # ffffffffc0216498 <bigblocks>
ffffffffc0202a5c:	639c                	ld	a5,0(a5)
		bigblocks = bb;
ffffffffc0202a5e:	00014717          	auipc	a4,0x14
ffffffffc0202a62:	a2973d23          	sd	s1,-1478(a4) # ffffffffc0216498 <bigblocks>
		bb->next = bigblocks;
ffffffffc0202a66:	e89c                	sd	a5,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc0202a68:	8522                	mv	a0,s0
ffffffffc0202a6a:	60e2                	ld	ra,24(sp)
ffffffffc0202a6c:	6442                	ld	s0,16(sp)
ffffffffc0202a6e:	64a2                	ld	s1,8(sp)
ffffffffc0202a70:	6902                	ld	s2,0(sp)
ffffffffc0202a72:	6105                	addi	sp,sp,32
ffffffffc0202a74:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0202a76:	0541                	addi	a0,a0,16
ffffffffc0202a78:	e71ff0ef          	jal	ra,ffffffffc02028e8 <slob_alloc.isra.1.constprop.3>
		return m ? (void *)(m + 1) : 0;
ffffffffc0202a7c:	01050413          	addi	s0,a0,16
ffffffffc0202a80:	f565                	bnez	a0,ffffffffc0202a68 <kmalloc+0x5c>
ffffffffc0202a82:	4401                	li	s0,0
}
ffffffffc0202a84:	8522                	mv	a0,s0
ffffffffc0202a86:	60e2                	ld	ra,24(sp)
ffffffffc0202a88:	6442                	ld	s0,16(sp)
ffffffffc0202a8a:	64a2                	ld	s1,8(sp)
ffffffffc0202a8c:	6902                	ld	s2,0(sp)
ffffffffc0202a8e:	6105                	addi	sp,sp,32
ffffffffc0202a90:	8082                	ret
        intr_disable();
ffffffffc0202a92:	b49fd0ef          	jal	ra,ffffffffc02005da <intr_disable>
		bb->next = bigblocks;
ffffffffc0202a96:	00014797          	auipc	a5,0x14
ffffffffc0202a9a:	a0278793          	addi	a5,a5,-1534 # ffffffffc0216498 <bigblocks>
ffffffffc0202a9e:	639c                	ld	a5,0(a5)
		bigblocks = bb;
ffffffffc0202aa0:	00014717          	auipc	a4,0x14
ffffffffc0202aa4:	9e973c23          	sd	s1,-1544(a4) # ffffffffc0216498 <bigblocks>
		bb->next = bigblocks;
ffffffffc0202aa8:	e89c                	sd	a5,16(s1)
        intr_enable();
ffffffffc0202aaa:	b2bfd0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
ffffffffc0202aae:	6480                	ld	s0,8(s1)
}
ffffffffc0202ab0:	60e2                	ld	ra,24(sp)
ffffffffc0202ab2:	64a2                	ld	s1,8(sp)
ffffffffc0202ab4:	8522                	mv	a0,s0
ffffffffc0202ab6:	6442                	ld	s0,16(sp)
ffffffffc0202ab8:	6902                	ld	s2,0(sp)
ffffffffc0202aba:	6105                	addi	sp,sp,32
ffffffffc0202abc:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0202abe:	45e1                	li	a1,24
ffffffffc0202ac0:	8526                	mv	a0,s1
ffffffffc0202ac2:	c9dff0ef          	jal	ra,ffffffffc020275e <slob_free>
  return __kmalloc(size, 0);
ffffffffc0202ac6:	b74d                	j	ffffffffc0202a68 <kmalloc+0x5c>

ffffffffc0202ac8 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0202ac8:	c175                	beqz	a0,ffffffffc0202bac <kfree+0xe4>
{
ffffffffc0202aca:	1101                	addi	sp,sp,-32
ffffffffc0202acc:	e426                	sd	s1,8(sp)
ffffffffc0202ace:	ec06                	sd	ra,24(sp)
ffffffffc0202ad0:	e822                	sd	s0,16(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc0202ad2:	03451793          	slli	a5,a0,0x34
ffffffffc0202ad6:	84aa                	mv	s1,a0
ffffffffc0202ad8:	eb8d                	bnez	a5,ffffffffc0202b0a <kfree+0x42>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202ada:	100027f3          	csrr	a5,sstatus
ffffffffc0202ade:	8b89                	andi	a5,a5,2
ffffffffc0202ae0:	efc9                	bnez	a5,ffffffffc0202b7a <kfree+0xb2>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0202ae2:	00014797          	auipc	a5,0x14
ffffffffc0202ae6:	9b678793          	addi	a5,a5,-1610 # ffffffffc0216498 <bigblocks>
ffffffffc0202aea:	6394                	ld	a3,0(a5)
ffffffffc0202aec:	ce99                	beqz	a3,ffffffffc0202b0a <kfree+0x42>
			if (bb->pages == block) {
ffffffffc0202aee:	669c                	ld	a5,8(a3)
ffffffffc0202af0:	6a80                	ld	s0,16(a3)
ffffffffc0202af2:	0af50e63          	beq	a0,a5,ffffffffc0202bae <kfree+0xe6>
    return 0;
ffffffffc0202af6:	4601                	li	a2,0
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0202af8:	c801                	beqz	s0,ffffffffc0202b08 <kfree+0x40>
			if (bb->pages == block) {
ffffffffc0202afa:	6418                	ld	a4,8(s0)
ffffffffc0202afc:	681c                	ld	a5,16(s0)
ffffffffc0202afe:	00970f63          	beq	a4,s1,ffffffffc0202b1c <kfree+0x54>
ffffffffc0202b02:	86a2                	mv	a3,s0
ffffffffc0202b04:	843e                	mv	s0,a5
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0202b06:	f875                	bnez	s0,ffffffffc0202afa <kfree+0x32>
    if (flag) {
ffffffffc0202b08:	e659                	bnez	a2,ffffffffc0202b96 <kfree+0xce>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0202b0a:	6442                	ld	s0,16(sp)
ffffffffc0202b0c:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0202b0e:	ff048513          	addi	a0,s1,-16
}
ffffffffc0202b12:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0202b14:	4581                	li	a1,0
}
ffffffffc0202b16:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0202b18:	c47ff06f          	j	ffffffffc020275e <slob_free>
				*last = bb->next;
ffffffffc0202b1c:	ea9c                	sd	a5,16(a3)
ffffffffc0202b1e:	e641                	bnez	a2,ffffffffc0202ba6 <kfree+0xde>
    return pa2page(PADDR(kva));
ffffffffc0202b20:	c02007b7          	lui	a5,0xc0200
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0202b24:	4018                	lw	a4,0(s0)
ffffffffc0202b26:	08f4ea63          	bltu	s1,a5,ffffffffc0202bba <kfree+0xf2>
ffffffffc0202b2a:	00014797          	auipc	a5,0x14
ffffffffc0202b2e:	9b678793          	addi	a5,a5,-1610 # ffffffffc02164e0 <va_pa_offset>
ffffffffc0202b32:	6394                	ld	a3,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0202b34:	00014797          	auipc	a5,0x14
ffffffffc0202b38:	95478793          	addi	a5,a5,-1708 # ffffffffc0216488 <npage>
ffffffffc0202b3c:	639c                	ld	a5,0(a5)
    return pa2page(PADDR(kva));
ffffffffc0202b3e:	8c95                	sub	s1,s1,a3
    if (PPN(pa) >= npage) {
ffffffffc0202b40:	80b1                	srli	s1,s1,0xc
ffffffffc0202b42:	08f4f963          	bleu	a5,s1,ffffffffc0202bd4 <kfree+0x10c>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b46:	00004797          	auipc	a5,0x4
ffffffffc0202b4a:	4ba78793          	addi	a5,a5,1210 # ffffffffc0207000 <nbase>
ffffffffc0202b4e:	639c                	ld	a5,0(a5)
ffffffffc0202b50:	00014697          	auipc	a3,0x14
ffffffffc0202b54:	9a068693          	addi	a3,a3,-1632 # ffffffffc02164f0 <pages>
ffffffffc0202b58:	6288                	ld	a0,0(a3)
ffffffffc0202b5a:	8c9d                	sub	s1,s1,a5
ffffffffc0202b5c:	049a                	slli	s1,s1,0x6
  free_pages(kva2page(kva), 1 << order);
ffffffffc0202b5e:	4585                	li	a1,1
ffffffffc0202b60:	9526                	add	a0,a0,s1
ffffffffc0202b62:	00e595bb          	sllw	a1,a1,a4
ffffffffc0202b66:	8dcfe0ef          	jal	ra,ffffffffc0200c42 <free_pages>
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0202b6a:	8522                	mv	a0,s0
}
ffffffffc0202b6c:	6442                	ld	s0,16(sp)
ffffffffc0202b6e:	60e2                	ld	ra,24(sp)
ffffffffc0202b70:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0202b72:	45e1                	li	a1,24
}
ffffffffc0202b74:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0202b76:	be9ff06f          	j	ffffffffc020275e <slob_free>
        intr_disable();
ffffffffc0202b7a:	a61fd0ef          	jal	ra,ffffffffc02005da <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc0202b7e:	00014797          	auipc	a5,0x14
ffffffffc0202b82:	91a78793          	addi	a5,a5,-1766 # ffffffffc0216498 <bigblocks>
ffffffffc0202b86:	6394                	ld	a3,0(a5)
ffffffffc0202b88:	c699                	beqz	a3,ffffffffc0202b96 <kfree+0xce>
			if (bb->pages == block) {
ffffffffc0202b8a:	669c                	ld	a5,8(a3)
ffffffffc0202b8c:	6a80                	ld	s0,16(a3)
ffffffffc0202b8e:	00f48763          	beq	s1,a5,ffffffffc0202b9c <kfree+0xd4>
        return 1;
ffffffffc0202b92:	4605                	li	a2,1
ffffffffc0202b94:	b795                	j	ffffffffc0202af8 <kfree+0x30>
        intr_enable();
ffffffffc0202b96:	a3ffd0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
ffffffffc0202b9a:	bf85                	j	ffffffffc0202b0a <kfree+0x42>
				*last = bb->next;
ffffffffc0202b9c:	00014797          	auipc	a5,0x14
ffffffffc0202ba0:	8e87be23          	sd	s0,-1796(a5) # ffffffffc0216498 <bigblocks>
ffffffffc0202ba4:	8436                	mv	s0,a3
ffffffffc0202ba6:	a2ffd0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
ffffffffc0202baa:	bf9d                	j	ffffffffc0202b20 <kfree+0x58>
ffffffffc0202bac:	8082                	ret
ffffffffc0202bae:	00014797          	auipc	a5,0x14
ffffffffc0202bb2:	8e87b523          	sd	s0,-1814(a5) # ffffffffc0216498 <bigblocks>
ffffffffc0202bb6:	8436                	mv	s0,a3
ffffffffc0202bb8:	b7a5                	j	ffffffffc0202b20 <kfree+0x58>
    return pa2page(PADDR(kva));
ffffffffc0202bba:	86a6                	mv	a3,s1
ffffffffc0202bbc:	00003617          	auipc	a2,0x3
ffffffffc0202bc0:	dac60613          	addi	a2,a2,-596 # ffffffffc0205968 <commands+0x918>
ffffffffc0202bc4:	06f00593          	li	a1,111
ffffffffc0202bc8:	00003517          	auipc	a0,0x3
ffffffffc0202bcc:	d2050513          	addi	a0,a0,-736 # ffffffffc02058e8 <commands+0x898>
ffffffffc0202bd0:	e06fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202bd4:	00003617          	auipc	a2,0x3
ffffffffc0202bd8:	cf460613          	addi	a2,a2,-780 # ffffffffc02058c8 <commands+0x878>
ffffffffc0202bdc:	06300593          	li	a1,99
ffffffffc0202be0:	00003517          	auipc	a0,0x3
ffffffffc0202be4:	d0850513          	addi	a0,a0,-760 # ffffffffc02058e8 <commands+0x898>
ffffffffc0202be8:	deefd0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0202bec <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc0202bec:	7135                	addi	sp,sp,-160
ffffffffc0202bee:	ed06                	sd	ra,152(sp)
ffffffffc0202bf0:	e922                	sd	s0,144(sp)
ffffffffc0202bf2:	e526                	sd	s1,136(sp)
ffffffffc0202bf4:	e14a                	sd	s2,128(sp)
ffffffffc0202bf6:	fcce                	sd	s3,120(sp)
ffffffffc0202bf8:	f8d2                	sd	s4,112(sp)
ffffffffc0202bfa:	f4d6                	sd	s5,104(sp)
ffffffffc0202bfc:	f0da                	sd	s6,96(sp)
ffffffffc0202bfe:	ecde                	sd	s7,88(sp)
ffffffffc0202c00:	e8e2                	sd	s8,80(sp)
ffffffffc0202c02:	e4e6                	sd	s9,72(sp)
ffffffffc0202c04:	e0ea                	sd	s10,64(sp)
ffffffffc0202c06:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc0202c08:	454010ef          	jal	ra,ffffffffc020405c <swapfs_init>
     // if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
     // {
     //      panic("bad max_swap_offset %08x.\n", max_swap_offset);
     // }
     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc0202c0c:	00014797          	auipc	a5,0x14
ffffffffc0202c10:	98c78793          	addi	a5,a5,-1652 # ffffffffc0216598 <max_swap_offset>
ffffffffc0202c14:	6394                	ld	a3,0(a5)
ffffffffc0202c16:	010007b7          	lui	a5,0x1000
ffffffffc0202c1a:	17e1                	addi	a5,a5,-8
ffffffffc0202c1c:	ff968713          	addi	a4,a3,-7
ffffffffc0202c20:	4ae7e863          	bltu	a5,a4,ffffffffc02030d0 <swap_init+0x4e4>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }

     sm = &swap_manager_fifo;
ffffffffc0202c24:	00008797          	auipc	a5,0x8
ffffffffc0202c28:	3dc78793          	addi	a5,a5,988 # ffffffffc020b000 <swap_manager_fifo>
     int r = sm->init();
ffffffffc0202c2c:	6798                	ld	a4,8(a5)
     sm = &swap_manager_fifo;
ffffffffc0202c2e:	00014697          	auipc	a3,0x14
ffffffffc0202c32:	86f6b923          	sd	a5,-1934(a3) # ffffffffc02164a0 <sm>
     int r = sm->init();
ffffffffc0202c36:	9702                	jalr	a4
ffffffffc0202c38:	8aaa                	mv	s5,a0
     
     if (r == 0)
ffffffffc0202c3a:	c10d                	beqz	a0,ffffffffc0202c5c <swap_init+0x70>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc0202c3c:	60ea                	ld	ra,152(sp)
ffffffffc0202c3e:	644a                	ld	s0,144(sp)
ffffffffc0202c40:	8556                	mv	a0,s5
ffffffffc0202c42:	64aa                	ld	s1,136(sp)
ffffffffc0202c44:	690a                	ld	s2,128(sp)
ffffffffc0202c46:	79e6                	ld	s3,120(sp)
ffffffffc0202c48:	7a46                	ld	s4,112(sp)
ffffffffc0202c4a:	7aa6                	ld	s5,104(sp)
ffffffffc0202c4c:	7b06                	ld	s6,96(sp)
ffffffffc0202c4e:	6be6                	ld	s7,88(sp)
ffffffffc0202c50:	6c46                	ld	s8,80(sp)
ffffffffc0202c52:	6ca6                	ld	s9,72(sp)
ffffffffc0202c54:	6d06                	ld	s10,64(sp)
ffffffffc0202c56:	7de2                	ld	s11,56(sp)
ffffffffc0202c58:	610d                	addi	sp,sp,160
ffffffffc0202c5a:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202c5c:	00014797          	auipc	a5,0x14
ffffffffc0202c60:	84478793          	addi	a5,a5,-1980 # ffffffffc02164a0 <sm>
ffffffffc0202c64:	639c                	ld	a5,0(a5)
ffffffffc0202c66:	00004517          	auipc	a0,0x4
ffffffffc0202c6a:	89250513          	addi	a0,a0,-1902 # ffffffffc02064f8 <commands+0x14a8>
ffffffffc0202c6e:	00014417          	auipc	s0,0x14
ffffffffc0202c72:	96a40413          	addi	s0,s0,-1686 # ffffffffc02165d8 <free_area>
ffffffffc0202c76:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0202c78:	4785                	li	a5,1
ffffffffc0202c7a:	00014717          	auipc	a4,0x14
ffffffffc0202c7e:	82f72723          	sw	a5,-2002(a4) # ffffffffc02164a8 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0202c82:	c4efd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0202c86:	641c                	ld	a5,8(s0)
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202c88:	36878863          	beq	a5,s0,ffffffffc0202ff8 <swap_init+0x40c>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0202c8c:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202c90:	8305                	srli	a4,a4,0x1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0202c92:	8b05                	andi	a4,a4,1
ffffffffc0202c94:	36070663          	beqz	a4,ffffffffc0203000 <swap_init+0x414>
     int ret, count = 0, total = 0, i;
ffffffffc0202c98:	4481                	li	s1,0
ffffffffc0202c9a:	4901                	li	s2,0
ffffffffc0202c9c:	a031                	j	ffffffffc0202ca8 <swap_init+0xbc>
ffffffffc0202c9e:	ff07b703          	ld	a4,-16(a5)
        assert(PageProperty(p));
ffffffffc0202ca2:	8b09                	andi	a4,a4,2
ffffffffc0202ca4:	34070e63          	beqz	a4,ffffffffc0203000 <swap_init+0x414>
        count ++, total += p->property;
ffffffffc0202ca8:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202cac:	679c                	ld	a5,8(a5)
ffffffffc0202cae:	2905                	addiw	s2,s2,1
ffffffffc0202cb0:	9cb9                	addw	s1,s1,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202cb2:	fe8796e3          	bne	a5,s0,ffffffffc0202c9e <swap_init+0xb2>
ffffffffc0202cb6:	89a6                	mv	s3,s1
     }
     assert(total == nr_free_pages());
ffffffffc0202cb8:	fd1fd0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>
ffffffffc0202cbc:	69351263          	bne	a0,s3,ffffffffc0203340 <swap_init+0x754>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc0202cc0:	8626                	mv	a2,s1
ffffffffc0202cc2:	85ca                	mv	a1,s2
ffffffffc0202cc4:	00004517          	auipc	a0,0x4
ffffffffc0202cc8:	87c50513          	addi	a0,a0,-1924 # ffffffffc0206540 <commands+0x14f0>
ffffffffc0202ccc:	c04fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc0202cd0:	a8cff0ef          	jal	ra,ffffffffc0201f5c <mm_create>
ffffffffc0202cd4:	8baa                	mv	s7,a0
     assert(mm != NULL);
ffffffffc0202cd6:	60050563          	beqz	a0,ffffffffc02032e0 <swap_init+0x6f4>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc0202cda:	00014797          	auipc	a5,0x14
ffffffffc0202cde:	82e78793          	addi	a5,a5,-2002 # ffffffffc0216508 <check_mm_struct>
ffffffffc0202ce2:	639c                	ld	a5,0(a5)
ffffffffc0202ce4:	60079e63          	bnez	a5,ffffffffc0203300 <swap_init+0x714>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202ce8:	00013797          	auipc	a5,0x13
ffffffffc0202cec:	79878793          	addi	a5,a5,1944 # ffffffffc0216480 <boot_pgdir>
ffffffffc0202cf0:	0007bb03          	ld	s6,0(a5)
     check_mm_struct = mm;
ffffffffc0202cf4:	00014797          	auipc	a5,0x14
ffffffffc0202cf8:	80a7ba23          	sd	a0,-2028(a5) # ffffffffc0216508 <check_mm_struct>
     assert(pgdir[0] == 0);
ffffffffc0202cfc:	000b3783          	ld	a5,0(s6)
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202d00:	01653c23          	sd	s6,24(a0)
     assert(pgdir[0] == 0);
ffffffffc0202d04:	4e079263          	bnez	a5,ffffffffc02031e8 <swap_init+0x5fc>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc0202d08:	6599                	lui	a1,0x6
ffffffffc0202d0a:	460d                	li	a2,3
ffffffffc0202d0c:	6505                	lui	a0,0x1
ffffffffc0202d0e:	a9aff0ef          	jal	ra,ffffffffc0201fa8 <vma_create>
ffffffffc0202d12:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc0202d14:	4e050a63          	beqz	a0,ffffffffc0203208 <swap_init+0x61c>

     insert_vma_struct(mm, vma);
ffffffffc0202d18:	855e                	mv	a0,s7
ffffffffc0202d1a:	afaff0ef          	jal	ra,ffffffffc0202014 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc0202d1e:	00004517          	auipc	a0,0x4
ffffffffc0202d22:	86250513          	addi	a0,a0,-1950 # ffffffffc0206580 <commands+0x1530>
ffffffffc0202d26:	baafd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0202d2a:	018bb503          	ld	a0,24(s7)
ffffffffc0202d2e:	4605                	li	a2,1
ffffffffc0202d30:	6585                	lui	a1,0x1
ffffffffc0202d32:	f97fd0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0202d36:	4e050963          	beqz	a0,ffffffffc0203228 <swap_init+0x63c>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202d3a:	00004517          	auipc	a0,0x4
ffffffffc0202d3e:	89650513          	addi	a0,a0,-1898 # ffffffffc02065d0 <commands+0x1580>
ffffffffc0202d42:	00013997          	auipc	s3,0x13
ffffffffc0202d46:	7ce98993          	addi	s3,s3,1998 # ffffffffc0216510 <check_rp>
ffffffffc0202d4a:	b86fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202d4e:	00013a17          	auipc	s4,0x13
ffffffffc0202d52:	7e2a0a13          	addi	s4,s4,2018 # ffffffffc0216530 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0202d56:	8c4e                	mv	s8,s3
          check_rp[i] = alloc_page();
ffffffffc0202d58:	4505                	li	a0,1
ffffffffc0202d5a:	e61fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0202d5e:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc0202d62:	32050763          	beqz	a0,ffffffffc0203090 <swap_init+0x4a4>
ffffffffc0202d66:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0202d68:	8b89                	andi	a5,a5,2
ffffffffc0202d6a:	30079363          	bnez	a5,ffffffffc0203070 <swap_init+0x484>
ffffffffc0202d6e:	0c21                	addi	s8,s8,8
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202d70:	ff4c14e3          	bne	s8,s4,ffffffffc0202d58 <swap_init+0x16c>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0202d74:	601c                	ld	a5,0(s0)
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
ffffffffc0202d76:	00013c17          	auipc	s8,0x13
ffffffffc0202d7a:	79ac0c13          	addi	s8,s8,1946 # ffffffffc0216510 <check_rp>
     list_entry_t free_list_store = free_list;
ffffffffc0202d7e:	ec3e                	sd	a5,24(sp)
ffffffffc0202d80:	641c                	ld	a5,8(s0)
ffffffffc0202d82:	f03e                	sd	a5,32(sp)
     unsigned int nr_free_store = nr_free;
ffffffffc0202d84:	481c                	lw	a5,16(s0)
ffffffffc0202d86:	f43e                	sd	a5,40(sp)
    elm->prev = elm->next = elm;
ffffffffc0202d88:	00014797          	auipc	a5,0x14
ffffffffc0202d8c:	8487bc23          	sd	s0,-1960(a5) # ffffffffc02165e0 <free_area+0x8>
ffffffffc0202d90:	00014797          	auipc	a5,0x14
ffffffffc0202d94:	8487b423          	sd	s0,-1976(a5) # ffffffffc02165d8 <free_area>
     nr_free = 0;
ffffffffc0202d98:	00014797          	auipc	a5,0x14
ffffffffc0202d9c:	8407a823          	sw	zero,-1968(a5) # ffffffffc02165e8 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc0202da0:	000c3503          	ld	a0,0(s8)
ffffffffc0202da4:	4585                	li	a1,1
ffffffffc0202da6:	0c21                	addi	s8,s8,8
ffffffffc0202da8:	e9bfd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202dac:	ff4c1ae3          	bne	s8,s4,ffffffffc0202da0 <swap_init+0x1b4>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0202db0:	01042c03          	lw	s8,16(s0)
ffffffffc0202db4:	4791                	li	a5,4
ffffffffc0202db6:	50fc1563          	bne	s8,a5,ffffffffc02032c0 <swap_init+0x6d4>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0202dba:	00004517          	auipc	a0,0x4
ffffffffc0202dbe:	89e50513          	addi	a0,a0,-1890 # ffffffffc0206658 <commands+0x1608>
ffffffffc0202dc2:	b0efd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202dc6:	6685                	lui	a3,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc0202dc8:	00013797          	auipc	a5,0x13
ffffffffc0202dcc:	6c07a423          	sw	zero,1736(a5) # ffffffffc0216490 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202dd0:	4629                	li	a2,10
     pgfault_num=0;
ffffffffc0202dd2:	00013797          	auipc	a5,0x13
ffffffffc0202dd6:	6be78793          	addi	a5,a5,1726 # ffffffffc0216490 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202dda:	00c68023          	sb	a2,0(a3) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
     assert(pgfault_num==1);
ffffffffc0202dde:	4398                	lw	a4,0(a5)
ffffffffc0202de0:	4585                	li	a1,1
ffffffffc0202de2:	2701                	sext.w	a4,a4
ffffffffc0202de4:	38b71263          	bne	a4,a1,ffffffffc0203168 <swap_init+0x57c>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc0202de8:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==1);
ffffffffc0202dec:	4394                	lw	a3,0(a5)
ffffffffc0202dee:	2681                	sext.w	a3,a3
ffffffffc0202df0:	38e69c63          	bne	a3,a4,ffffffffc0203188 <swap_init+0x59c>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202df4:	6689                	lui	a3,0x2
ffffffffc0202df6:	462d                	li	a2,11
ffffffffc0202df8:	00c68023          	sb	a2,0(a3) # 2000 <BASE_ADDRESS-0xffffffffc01fe000>
     assert(pgfault_num==2);
ffffffffc0202dfc:	4398                	lw	a4,0(a5)
ffffffffc0202dfe:	4589                	li	a1,2
ffffffffc0202e00:	2701                	sext.w	a4,a4
ffffffffc0202e02:	2eb71363          	bne	a4,a1,ffffffffc02030e8 <swap_init+0x4fc>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc0202e06:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==2);
ffffffffc0202e0a:	4394                	lw	a3,0(a5)
ffffffffc0202e0c:	2681                	sext.w	a3,a3
ffffffffc0202e0e:	2ee69d63          	bne	a3,a4,ffffffffc0203108 <swap_init+0x51c>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc0202e12:	668d                	lui	a3,0x3
ffffffffc0202e14:	4631                	li	a2,12
ffffffffc0202e16:	00c68023          	sb	a2,0(a3) # 3000 <BASE_ADDRESS-0xffffffffc01fd000>
     assert(pgfault_num==3);
ffffffffc0202e1a:	4398                	lw	a4,0(a5)
ffffffffc0202e1c:	458d                	li	a1,3
ffffffffc0202e1e:	2701                	sext.w	a4,a4
ffffffffc0202e20:	30b71463          	bne	a4,a1,ffffffffc0203128 <swap_init+0x53c>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0202e24:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==3);
ffffffffc0202e28:	4394                	lw	a3,0(a5)
ffffffffc0202e2a:	2681                	sext.w	a3,a3
ffffffffc0202e2c:	30e69e63          	bne	a3,a4,ffffffffc0203148 <swap_init+0x55c>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202e30:	6691                	lui	a3,0x4
ffffffffc0202e32:	4635                	li	a2,13
ffffffffc0202e34:	00c68023          	sb	a2,0(a3) # 4000 <BASE_ADDRESS-0xffffffffc01fc000>
     assert(pgfault_num==4);
ffffffffc0202e38:	4398                	lw	a4,0(a5)
ffffffffc0202e3a:	2701                	sext.w	a4,a4
ffffffffc0202e3c:	37871663          	bne	a4,s8,ffffffffc02031a8 <swap_init+0x5bc>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc0202e40:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==4);
ffffffffc0202e44:	439c                	lw	a5,0(a5)
ffffffffc0202e46:	2781                	sext.w	a5,a5
ffffffffc0202e48:	38e79063          	bne	a5,a4,ffffffffc02031c8 <swap_init+0x5dc>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0202e4c:	481c                	lw	a5,16(s0)
ffffffffc0202e4e:	3e079d63          	bnez	a5,ffffffffc0203248 <swap_init+0x65c>
ffffffffc0202e52:	00013797          	auipc	a5,0x13
ffffffffc0202e56:	6de78793          	addi	a5,a5,1758 # ffffffffc0216530 <swap_in_seq_no>
ffffffffc0202e5a:	00013717          	auipc	a4,0x13
ffffffffc0202e5e:	6fe70713          	addi	a4,a4,1790 # ffffffffc0216558 <swap_out_seq_no>
ffffffffc0202e62:	00013617          	auipc	a2,0x13
ffffffffc0202e66:	6f660613          	addi	a2,a2,1782 # ffffffffc0216558 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0202e6a:	56fd                	li	a3,-1
ffffffffc0202e6c:	c394                	sw	a3,0(a5)
ffffffffc0202e6e:	c314                	sw	a3,0(a4)
ffffffffc0202e70:	0791                	addi	a5,a5,4
ffffffffc0202e72:	0711                	addi	a4,a4,4
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc0202e74:	fef61ce3          	bne	a2,a5,ffffffffc0202e6c <swap_init+0x280>
ffffffffc0202e78:	00013697          	auipc	a3,0x13
ffffffffc0202e7c:	74068693          	addi	a3,a3,1856 # ffffffffc02165b8 <check_ptep>
ffffffffc0202e80:	00013817          	auipc	a6,0x13
ffffffffc0202e84:	69080813          	addi	a6,a6,1680 # ffffffffc0216510 <check_rp>
ffffffffc0202e88:	6d05                	lui	s10,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202e8a:	00013c97          	auipc	s9,0x13
ffffffffc0202e8e:	5fec8c93          	addi	s9,s9,1534 # ffffffffc0216488 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e92:	00004d97          	auipc	s11,0x4
ffffffffc0202e96:	16ed8d93          	addi	s11,s11,366 # ffffffffc0207000 <nbase>
ffffffffc0202e9a:	00013c17          	auipc	s8,0x13
ffffffffc0202e9e:	656c0c13          	addi	s8,s8,1622 # ffffffffc02164f0 <pages>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc0202ea2:	0006b023          	sd	zero,0(a3)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202ea6:	4601                	li	a2,0
ffffffffc0202ea8:	85ea                	mv	a1,s10
ffffffffc0202eaa:	855a                	mv	a0,s6
ffffffffc0202eac:	e842                	sd	a6,16(sp)
         check_ptep[i]=0;
ffffffffc0202eae:	e436                	sd	a3,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202eb0:	e19fd0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc0202eb4:	66a2                	ld	a3,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc0202eb6:	6842                	ld	a6,16(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0202eb8:	e288                	sd	a0,0(a3)
         assert(check_ptep[i] != NULL);
ffffffffc0202eba:	1e050b63          	beqz	a0,ffffffffc02030b0 <swap_init+0x4c4>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0202ebe:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc0202ec0:	0017f613          	andi	a2,a5,1
ffffffffc0202ec4:	18060a63          	beqz	a2,ffffffffc0203058 <swap_init+0x46c>
    if (PPN(pa) >= npage) {
ffffffffc0202ec8:	000cb603          	ld	a2,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202ecc:	078a                	slli	a5,a5,0x2
ffffffffc0202ece:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202ed0:	14c7f863          	bleu	a2,a5,ffffffffc0203020 <swap_init+0x434>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ed4:	000db703          	ld	a4,0(s11)
ffffffffc0202ed8:	000c3603          	ld	a2,0(s8)
ffffffffc0202edc:	00083583          	ld	a1,0(a6)
ffffffffc0202ee0:	8f99                	sub	a5,a5,a4
ffffffffc0202ee2:	079a                	slli	a5,a5,0x6
ffffffffc0202ee4:	e43a                	sd	a4,8(sp)
ffffffffc0202ee6:	97b2                	add	a5,a5,a2
ffffffffc0202ee8:	14f59863          	bne	a1,a5,ffffffffc0203038 <swap_init+0x44c>
ffffffffc0202eec:	6785                	lui	a5,0x1
ffffffffc0202eee:	9d3e                	add	s10,s10,a5
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202ef0:	6795                	lui	a5,0x5
ffffffffc0202ef2:	06a1                	addi	a3,a3,8
ffffffffc0202ef4:	0821                	addi	a6,a6,8
ffffffffc0202ef6:	fafd16e3          	bne	s10,a5,ffffffffc0202ea2 <swap_init+0x2b6>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc0202efa:	00004517          	auipc	a0,0x4
ffffffffc0202efe:	80650513          	addi	a0,a0,-2042 # ffffffffc0206700 <commands+0x16b0>
ffffffffc0202f02:	9cefd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    int ret = sm->check_swap();
ffffffffc0202f06:	00013797          	auipc	a5,0x13
ffffffffc0202f0a:	59a78793          	addi	a5,a5,1434 # ffffffffc02164a0 <sm>
ffffffffc0202f0e:	639c                	ld	a5,0(a5)
ffffffffc0202f10:	7f9c                	ld	a5,56(a5)
ffffffffc0202f12:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc0202f14:	40051663          	bnez	a0,ffffffffc0203320 <swap_init+0x734>

     nr_free = nr_free_store;
ffffffffc0202f18:	77a2                	ld	a5,40(sp)
ffffffffc0202f1a:	00013717          	auipc	a4,0x13
ffffffffc0202f1e:	6cf72723          	sw	a5,1742(a4) # ffffffffc02165e8 <free_area+0x10>
     free_list = free_list_store;
ffffffffc0202f22:	67e2                	ld	a5,24(sp)
ffffffffc0202f24:	00013717          	auipc	a4,0x13
ffffffffc0202f28:	6af73a23          	sd	a5,1716(a4) # ffffffffc02165d8 <free_area>
ffffffffc0202f2c:	7782                	ld	a5,32(sp)
ffffffffc0202f2e:	00013717          	auipc	a4,0x13
ffffffffc0202f32:	6af73923          	sd	a5,1714(a4) # ffffffffc02165e0 <free_area+0x8>

     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc0202f36:	0009b503          	ld	a0,0(s3)
ffffffffc0202f3a:	4585                	li	a1,1
ffffffffc0202f3c:	09a1                	addi	s3,s3,8
ffffffffc0202f3e:	d05fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0202f42:	ff499ae3          	bne	s3,s4,ffffffffc0202f36 <swap_init+0x34a>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
ffffffffc0202f46:	855e                	mv	a0,s7
ffffffffc0202f48:	99aff0ef          	jal	ra,ffffffffc02020e2 <mm_destroy>

     pde_t *pd1=pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0202f4c:	00013797          	auipc	a5,0x13
ffffffffc0202f50:	53478793          	addi	a5,a5,1332 # ffffffffc0216480 <boot_pgdir>
ffffffffc0202f54:	639c                	ld	a5,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0202f56:	000cb703          	ld	a4,0(s9)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f5a:	6394                	ld	a3,0(a5)
ffffffffc0202f5c:	068a                	slli	a3,a3,0x2
ffffffffc0202f5e:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202f60:	0ce6f063          	bleu	a4,a3,ffffffffc0203020 <swap_init+0x434>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f64:	67a2                	ld	a5,8(sp)
ffffffffc0202f66:	000c3503          	ld	a0,0(s8)
ffffffffc0202f6a:	8e9d                	sub	a3,a3,a5
ffffffffc0202f6c:	069a                	slli	a3,a3,0x6
    return page - pages + nbase;
ffffffffc0202f6e:	8699                	srai	a3,a3,0x6
ffffffffc0202f70:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0202f72:	57fd                	li	a5,-1
ffffffffc0202f74:	83b1                	srli	a5,a5,0xc
ffffffffc0202f76:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202f78:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202f7a:	2ee7f763          	bleu	a4,a5,ffffffffc0203268 <swap_init+0x67c>
     free_page(pde2page(pd0[0]));
ffffffffc0202f7e:	00013797          	auipc	a5,0x13
ffffffffc0202f82:	56278793          	addi	a5,a5,1378 # ffffffffc02164e0 <va_pa_offset>
ffffffffc0202f86:	639c                	ld	a5,0(a5)
ffffffffc0202f88:	96be                	add	a3,a3,a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202f8a:	629c                	ld	a5,0(a3)
ffffffffc0202f8c:	078a                	slli	a5,a5,0x2
ffffffffc0202f8e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202f90:	08e7f863          	bleu	a4,a5,ffffffffc0203020 <swap_init+0x434>
    return &pages[PPN(pa) - nbase];
ffffffffc0202f94:	69a2                	ld	s3,8(sp)
ffffffffc0202f96:	4585                	li	a1,1
ffffffffc0202f98:	413787b3          	sub	a5,a5,s3
ffffffffc0202f9c:	079a                	slli	a5,a5,0x6
ffffffffc0202f9e:	953e                	add	a0,a0,a5
ffffffffc0202fa0:	ca3fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202fa4:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage) {
ffffffffc0202fa8:	000cb703          	ld	a4,0(s9)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202fac:	078a                	slli	a5,a5,0x2
ffffffffc0202fae:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202fb0:	06e7f863          	bleu	a4,a5,ffffffffc0203020 <swap_init+0x434>
    return &pages[PPN(pa) - nbase];
ffffffffc0202fb4:	000c3503          	ld	a0,0(s8)
ffffffffc0202fb8:	413787b3          	sub	a5,a5,s3
ffffffffc0202fbc:	079a                	slli	a5,a5,0x6
     free_page(pde2page(pd1[0]));
ffffffffc0202fbe:	4585                	li	a1,1
ffffffffc0202fc0:	953e                	add	a0,a0,a5
ffffffffc0202fc2:	c81fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
     pgdir[0] = 0;
ffffffffc0202fc6:	000b3023          	sd	zero,0(s6)
  asm volatile("sfence.vma");
ffffffffc0202fca:	12000073          	sfence.vma
    return listelm->next;
ffffffffc0202fce:	641c                	ld	a5,8(s0)
     flush_tlb();

     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202fd0:	00878963          	beq	a5,s0,ffffffffc0202fe2 <swap_init+0x3f6>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc0202fd4:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202fd8:	679c                	ld	a5,8(a5)
ffffffffc0202fda:	397d                	addiw	s2,s2,-1
ffffffffc0202fdc:	9c99                	subw	s1,s1,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202fde:	fe879be3          	bne	a5,s0,ffffffffc0202fd4 <swap_init+0x3e8>
     }
     assert(count==0);
ffffffffc0202fe2:	28091f63          	bnez	s2,ffffffffc0203280 <swap_init+0x694>
     assert(total==0);
ffffffffc0202fe6:	2a049d63          	bnez	s1,ffffffffc02032a0 <swap_init+0x6b4>

     cprintf("check_swap() succeeded!\n");
ffffffffc0202fea:	00003517          	auipc	a0,0x3
ffffffffc0202fee:	76650513          	addi	a0,a0,1894 # ffffffffc0206750 <commands+0x1700>
ffffffffc0202ff2:	8defd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0202ff6:	b199                	j	ffffffffc0202c3c <swap_init+0x50>
     int ret, count = 0, total = 0, i;
ffffffffc0202ff8:	4481                	li	s1,0
ffffffffc0202ffa:	4901                	li	s2,0
     while ((le = list_next(le)) != &free_list) {
ffffffffc0202ffc:	4981                	li	s3,0
ffffffffc0202ffe:	b96d                	j	ffffffffc0202cb8 <swap_init+0xcc>
        assert(PageProperty(p));
ffffffffc0203000:	00003697          	auipc	a3,0x3
ffffffffc0203004:	51068693          	addi	a3,a3,1296 # ffffffffc0206510 <commands+0x14c0>
ffffffffc0203008:	00003617          	auipc	a2,0x3
ffffffffc020300c:	9e060613          	addi	a2,a2,-1568 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203010:	0bd00593          	li	a1,189
ffffffffc0203014:	00003517          	auipc	a0,0x3
ffffffffc0203018:	4d450513          	addi	a0,a0,1236 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020301c:	9bafd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203020:	00003617          	auipc	a2,0x3
ffffffffc0203024:	8a860613          	addi	a2,a2,-1880 # ffffffffc02058c8 <commands+0x878>
ffffffffc0203028:	06300593          	li	a1,99
ffffffffc020302c:	00003517          	auipc	a0,0x3
ffffffffc0203030:	8bc50513          	addi	a0,a0,-1860 # ffffffffc02058e8 <commands+0x898>
ffffffffc0203034:	9a2fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0203038:	00003697          	auipc	a3,0x3
ffffffffc020303c:	6a068693          	addi	a3,a3,1696 # ffffffffc02066d8 <commands+0x1688>
ffffffffc0203040:	00003617          	auipc	a2,0x3
ffffffffc0203044:	9a860613          	addi	a2,a2,-1624 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203048:	0fd00593          	li	a1,253
ffffffffc020304c:	00003517          	auipc	a0,0x3
ffffffffc0203050:	49c50513          	addi	a0,a0,1180 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203054:	982fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203058:	00003617          	auipc	a2,0x3
ffffffffc020305c:	a6860613          	addi	a2,a2,-1432 # ffffffffc0205ac0 <commands+0xa70>
ffffffffc0203060:	07500593          	li	a1,117
ffffffffc0203064:	00003517          	auipc	a0,0x3
ffffffffc0203068:	88450513          	addi	a0,a0,-1916 # ffffffffc02058e8 <commands+0x898>
ffffffffc020306c:	96afd0ef          	jal	ra,ffffffffc02001d6 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0203070:	00003697          	auipc	a3,0x3
ffffffffc0203074:	5a068693          	addi	a3,a3,1440 # ffffffffc0206610 <commands+0x15c0>
ffffffffc0203078:	00003617          	auipc	a2,0x3
ffffffffc020307c:	97060613          	addi	a2,a2,-1680 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203080:	0de00593          	li	a1,222
ffffffffc0203084:	00003517          	auipc	a0,0x3
ffffffffc0203088:	46450513          	addi	a0,a0,1124 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020308c:	94afd0ef          	jal	ra,ffffffffc02001d6 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0203090:	00003697          	auipc	a3,0x3
ffffffffc0203094:	56868693          	addi	a3,a3,1384 # ffffffffc02065f8 <commands+0x15a8>
ffffffffc0203098:	00003617          	auipc	a2,0x3
ffffffffc020309c:	95060613          	addi	a2,a2,-1712 # ffffffffc02059e8 <commands+0x998>
ffffffffc02030a0:	0dd00593          	li	a1,221
ffffffffc02030a4:	00003517          	auipc	a0,0x3
ffffffffc02030a8:	44450513          	addi	a0,a0,1092 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02030ac:	92afd0ef          	jal	ra,ffffffffc02001d6 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc02030b0:	00003697          	auipc	a3,0x3
ffffffffc02030b4:	61068693          	addi	a3,a3,1552 # ffffffffc02066c0 <commands+0x1670>
ffffffffc02030b8:	00003617          	auipc	a2,0x3
ffffffffc02030bc:	93060613          	addi	a2,a2,-1744 # ffffffffc02059e8 <commands+0x998>
ffffffffc02030c0:	0fc00593          	li	a1,252
ffffffffc02030c4:	00003517          	auipc	a0,0x3
ffffffffc02030c8:	42450513          	addi	a0,a0,1060 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02030cc:	90afd0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc02030d0:	00003617          	auipc	a2,0x3
ffffffffc02030d4:	3f860613          	addi	a2,a2,1016 # ffffffffc02064c8 <commands+0x1478>
ffffffffc02030d8:	02a00593          	li	a1,42
ffffffffc02030dc:	00003517          	auipc	a0,0x3
ffffffffc02030e0:	40c50513          	addi	a0,a0,1036 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02030e4:	8f2fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==2);
ffffffffc02030e8:	00003697          	auipc	a3,0x3
ffffffffc02030ec:	5a868693          	addi	a3,a3,1448 # ffffffffc0206690 <commands+0x1640>
ffffffffc02030f0:	00003617          	auipc	a2,0x3
ffffffffc02030f4:	8f860613          	addi	a2,a2,-1800 # ffffffffc02059e8 <commands+0x998>
ffffffffc02030f8:	09800593          	li	a1,152
ffffffffc02030fc:	00003517          	auipc	a0,0x3
ffffffffc0203100:	3ec50513          	addi	a0,a0,1004 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203104:	8d2fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==2);
ffffffffc0203108:	00003697          	auipc	a3,0x3
ffffffffc020310c:	58868693          	addi	a3,a3,1416 # ffffffffc0206690 <commands+0x1640>
ffffffffc0203110:	00003617          	auipc	a2,0x3
ffffffffc0203114:	8d860613          	addi	a2,a2,-1832 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203118:	09a00593          	li	a1,154
ffffffffc020311c:	00003517          	auipc	a0,0x3
ffffffffc0203120:	3cc50513          	addi	a0,a0,972 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203124:	8b2fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==3);
ffffffffc0203128:	00003697          	auipc	a3,0x3
ffffffffc020312c:	57868693          	addi	a3,a3,1400 # ffffffffc02066a0 <commands+0x1650>
ffffffffc0203130:	00003617          	auipc	a2,0x3
ffffffffc0203134:	8b860613          	addi	a2,a2,-1864 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203138:	09c00593          	li	a1,156
ffffffffc020313c:	00003517          	auipc	a0,0x3
ffffffffc0203140:	3ac50513          	addi	a0,a0,940 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203144:	892fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==3);
ffffffffc0203148:	00003697          	auipc	a3,0x3
ffffffffc020314c:	55868693          	addi	a3,a3,1368 # ffffffffc02066a0 <commands+0x1650>
ffffffffc0203150:	00003617          	auipc	a2,0x3
ffffffffc0203154:	89860613          	addi	a2,a2,-1896 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203158:	09e00593          	li	a1,158
ffffffffc020315c:	00003517          	auipc	a0,0x3
ffffffffc0203160:	38c50513          	addi	a0,a0,908 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203164:	872fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==1);
ffffffffc0203168:	00003697          	auipc	a3,0x3
ffffffffc020316c:	51868693          	addi	a3,a3,1304 # ffffffffc0206680 <commands+0x1630>
ffffffffc0203170:	00003617          	auipc	a2,0x3
ffffffffc0203174:	87860613          	addi	a2,a2,-1928 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203178:	09400593          	li	a1,148
ffffffffc020317c:	00003517          	auipc	a0,0x3
ffffffffc0203180:	36c50513          	addi	a0,a0,876 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203184:	852fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==1);
ffffffffc0203188:	00003697          	auipc	a3,0x3
ffffffffc020318c:	4f868693          	addi	a3,a3,1272 # ffffffffc0206680 <commands+0x1630>
ffffffffc0203190:	00003617          	auipc	a2,0x3
ffffffffc0203194:	85860613          	addi	a2,a2,-1960 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203198:	09600593          	li	a1,150
ffffffffc020319c:	00003517          	auipc	a0,0x3
ffffffffc02031a0:	34c50513          	addi	a0,a0,844 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02031a4:	832fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==4);
ffffffffc02031a8:	00003697          	auipc	a3,0x3
ffffffffc02031ac:	d2068693          	addi	a3,a3,-736 # ffffffffc0205ec8 <commands+0xe78>
ffffffffc02031b0:	00003617          	auipc	a2,0x3
ffffffffc02031b4:	83860613          	addi	a2,a2,-1992 # ffffffffc02059e8 <commands+0x998>
ffffffffc02031b8:	0a000593          	li	a1,160
ffffffffc02031bc:	00003517          	auipc	a0,0x3
ffffffffc02031c0:	32c50513          	addi	a0,a0,812 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02031c4:	812fd0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgfault_num==4);
ffffffffc02031c8:	00003697          	auipc	a3,0x3
ffffffffc02031cc:	d0068693          	addi	a3,a3,-768 # ffffffffc0205ec8 <commands+0xe78>
ffffffffc02031d0:	00003617          	auipc	a2,0x3
ffffffffc02031d4:	81860613          	addi	a2,a2,-2024 # ffffffffc02059e8 <commands+0x998>
ffffffffc02031d8:	0a200593          	li	a1,162
ffffffffc02031dc:	00003517          	auipc	a0,0x3
ffffffffc02031e0:	30c50513          	addi	a0,a0,780 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02031e4:	ff3fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(pgdir[0] == 0);
ffffffffc02031e8:	00003697          	auipc	a3,0x3
ffffffffc02031ec:	17068693          	addi	a3,a3,368 # ffffffffc0206358 <commands+0x1308>
ffffffffc02031f0:	00002617          	auipc	a2,0x2
ffffffffc02031f4:	7f860613          	addi	a2,a2,2040 # ffffffffc02059e8 <commands+0x998>
ffffffffc02031f8:	0cd00593          	li	a1,205
ffffffffc02031fc:	00003517          	auipc	a0,0x3
ffffffffc0203200:	2ec50513          	addi	a0,a0,748 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203204:	fd3fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(vma != NULL);
ffffffffc0203208:	00003697          	auipc	a3,0x3
ffffffffc020320c:	1f068693          	addi	a3,a3,496 # ffffffffc02063f8 <commands+0x13a8>
ffffffffc0203210:	00002617          	auipc	a2,0x2
ffffffffc0203214:	7d860613          	addi	a2,a2,2008 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203218:	0d000593          	li	a1,208
ffffffffc020321c:	00003517          	auipc	a0,0x3
ffffffffc0203220:	2cc50513          	addi	a0,a0,716 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203224:	fb3fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0203228:	00003697          	auipc	a3,0x3
ffffffffc020322c:	39068693          	addi	a3,a3,912 # ffffffffc02065b8 <commands+0x1568>
ffffffffc0203230:	00002617          	auipc	a2,0x2
ffffffffc0203234:	7b860613          	addi	a2,a2,1976 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203238:	0d800593          	li	a1,216
ffffffffc020323c:	00003517          	auipc	a0,0x3
ffffffffc0203240:	2ac50513          	addi	a0,a0,684 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203244:	f93fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert( nr_free == 0);         
ffffffffc0203248:	00003697          	auipc	a3,0x3
ffffffffc020324c:	46868693          	addi	a3,a3,1128 # ffffffffc02066b0 <commands+0x1660>
ffffffffc0203250:	00002617          	auipc	a2,0x2
ffffffffc0203254:	79860613          	addi	a2,a2,1944 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203258:	0f400593          	li	a1,244
ffffffffc020325c:	00003517          	auipc	a0,0x3
ffffffffc0203260:	28c50513          	addi	a0,a0,652 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203264:	f73fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203268:	00002617          	auipc	a2,0x2
ffffffffc020326c:	62860613          	addi	a2,a2,1576 # ffffffffc0205890 <commands+0x840>
ffffffffc0203270:	06a00593          	li	a1,106
ffffffffc0203274:	00002517          	auipc	a0,0x2
ffffffffc0203278:	67450513          	addi	a0,a0,1652 # ffffffffc02058e8 <commands+0x898>
ffffffffc020327c:	f5bfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(count==0);
ffffffffc0203280:	00003697          	auipc	a3,0x3
ffffffffc0203284:	4b068693          	addi	a3,a3,1200 # ffffffffc0206730 <commands+0x16e0>
ffffffffc0203288:	00002617          	auipc	a2,0x2
ffffffffc020328c:	76060613          	addi	a2,a2,1888 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203290:	11c00593          	li	a1,284
ffffffffc0203294:	00003517          	auipc	a0,0x3
ffffffffc0203298:	25450513          	addi	a0,a0,596 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020329c:	f3bfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(total==0);
ffffffffc02032a0:	00003697          	auipc	a3,0x3
ffffffffc02032a4:	4a068693          	addi	a3,a3,1184 # ffffffffc0206740 <commands+0x16f0>
ffffffffc02032a8:	00002617          	auipc	a2,0x2
ffffffffc02032ac:	74060613          	addi	a2,a2,1856 # ffffffffc02059e8 <commands+0x998>
ffffffffc02032b0:	11d00593          	li	a1,285
ffffffffc02032b4:	00003517          	auipc	a0,0x3
ffffffffc02032b8:	23450513          	addi	a0,a0,564 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02032bc:	f1bfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc02032c0:	00003697          	auipc	a3,0x3
ffffffffc02032c4:	37068693          	addi	a3,a3,880 # ffffffffc0206630 <commands+0x15e0>
ffffffffc02032c8:	00002617          	auipc	a2,0x2
ffffffffc02032cc:	72060613          	addi	a2,a2,1824 # ffffffffc02059e8 <commands+0x998>
ffffffffc02032d0:	0eb00593          	li	a1,235
ffffffffc02032d4:	00003517          	auipc	a0,0x3
ffffffffc02032d8:	21450513          	addi	a0,a0,532 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02032dc:	efbfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(mm != NULL);
ffffffffc02032e0:	00003697          	auipc	a3,0x3
ffffffffc02032e4:	ef068693          	addi	a3,a3,-272 # ffffffffc02061d0 <commands+0x1180>
ffffffffc02032e8:	00002617          	auipc	a2,0x2
ffffffffc02032ec:	70060613          	addi	a2,a2,1792 # ffffffffc02059e8 <commands+0x998>
ffffffffc02032f0:	0c500593          	li	a1,197
ffffffffc02032f4:	00003517          	auipc	a0,0x3
ffffffffc02032f8:	1f450513          	addi	a0,a0,500 # ffffffffc02064e8 <commands+0x1498>
ffffffffc02032fc:	edbfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0203300:	00003697          	auipc	a3,0x3
ffffffffc0203304:	26868693          	addi	a3,a3,616 # ffffffffc0206568 <commands+0x1518>
ffffffffc0203308:	00002617          	auipc	a2,0x2
ffffffffc020330c:	6e060613          	addi	a2,a2,1760 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203310:	0c800593          	li	a1,200
ffffffffc0203314:	00003517          	auipc	a0,0x3
ffffffffc0203318:	1d450513          	addi	a0,a0,468 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020331c:	ebbfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(ret==0);
ffffffffc0203320:	00003697          	auipc	a3,0x3
ffffffffc0203324:	40868693          	addi	a3,a3,1032 # ffffffffc0206728 <commands+0x16d8>
ffffffffc0203328:	00002617          	auipc	a2,0x2
ffffffffc020332c:	6c060613          	addi	a2,a2,1728 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203330:	10300593          	li	a1,259
ffffffffc0203334:	00003517          	auipc	a0,0x3
ffffffffc0203338:	1b450513          	addi	a0,a0,436 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020333c:	e9bfc0ef          	jal	ra,ffffffffc02001d6 <__panic>
     assert(total == nr_free_pages());
ffffffffc0203340:	00003697          	auipc	a3,0x3
ffffffffc0203344:	1e068693          	addi	a3,a3,480 # ffffffffc0206520 <commands+0x14d0>
ffffffffc0203348:	00002617          	auipc	a2,0x2
ffffffffc020334c:	6a060613          	addi	a2,a2,1696 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203350:	0c000593          	li	a1,192
ffffffffc0203354:	00003517          	auipc	a0,0x3
ffffffffc0203358:	19450513          	addi	a0,a0,404 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020335c:	e7bfc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0203360 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0203360:	00013797          	auipc	a5,0x13
ffffffffc0203364:	14078793          	addi	a5,a5,320 # ffffffffc02164a0 <sm>
ffffffffc0203368:	639c                	ld	a5,0(a5)
ffffffffc020336a:	0107b303          	ld	t1,16(a5)
ffffffffc020336e:	8302                	jr	t1

ffffffffc0203370 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0203370:	00013797          	auipc	a5,0x13
ffffffffc0203374:	13078793          	addi	a5,a5,304 # ffffffffc02164a0 <sm>
ffffffffc0203378:	639c                	ld	a5,0(a5)
ffffffffc020337a:	0207b303          	ld	t1,32(a5)
ffffffffc020337e:	8302                	jr	t1

ffffffffc0203380 <swap_out>:
{
ffffffffc0203380:	711d                	addi	sp,sp,-96
ffffffffc0203382:	ec86                	sd	ra,88(sp)
ffffffffc0203384:	e8a2                	sd	s0,80(sp)
ffffffffc0203386:	e4a6                	sd	s1,72(sp)
ffffffffc0203388:	e0ca                	sd	s2,64(sp)
ffffffffc020338a:	fc4e                	sd	s3,56(sp)
ffffffffc020338c:	f852                	sd	s4,48(sp)
ffffffffc020338e:	f456                	sd	s5,40(sp)
ffffffffc0203390:	f05a                	sd	s6,32(sp)
ffffffffc0203392:	ec5e                	sd	s7,24(sp)
ffffffffc0203394:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0203396:	cde9                	beqz	a1,ffffffffc0203470 <swap_out+0xf0>
ffffffffc0203398:	8ab2                	mv	s5,a2
ffffffffc020339a:	892a                	mv	s2,a0
ffffffffc020339c:	8a2e                	mv	s4,a1
ffffffffc020339e:	4401                	li	s0,0
ffffffffc02033a0:	00013997          	auipc	s3,0x13
ffffffffc02033a4:	10098993          	addi	s3,s3,256 # ffffffffc02164a0 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02033a8:	00003b17          	auipc	s6,0x3
ffffffffc02033ac:	428b0b13          	addi	s6,s6,1064 # ffffffffc02067d0 <commands+0x1780>
                    cprintf("SWAP: failed to save\n");
ffffffffc02033b0:	00003b97          	auipc	s7,0x3
ffffffffc02033b4:	408b8b93          	addi	s7,s7,1032 # ffffffffc02067b8 <commands+0x1768>
ffffffffc02033b8:	a825                	j	ffffffffc02033f0 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02033ba:	67a2                	ld	a5,8(sp)
ffffffffc02033bc:	8626                	mv	a2,s1
ffffffffc02033be:	85a2                	mv	a1,s0
ffffffffc02033c0:	7f94                	ld	a3,56(a5)
ffffffffc02033c2:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc02033c4:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc02033c6:	82b1                	srli	a3,a3,0xc
ffffffffc02033c8:	0685                	addi	a3,a3,1
ffffffffc02033ca:	d07fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc02033ce:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc02033d0:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc02033d2:	7d1c                	ld	a5,56(a0)
ffffffffc02033d4:	83b1                	srli	a5,a5,0xc
ffffffffc02033d6:	0785                	addi	a5,a5,1
ffffffffc02033d8:	07a2                	slli	a5,a5,0x8
ffffffffc02033da:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc02033de:	865fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc02033e2:	01893503          	ld	a0,24(s2)
ffffffffc02033e6:	85a6                	mv	a1,s1
ffffffffc02033e8:	ed0fe0ef          	jal	ra,ffffffffc0201ab8 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc02033ec:	048a0d63          	beq	s4,s0,ffffffffc0203446 <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc02033f0:	0009b783          	ld	a5,0(s3)
ffffffffc02033f4:	8656                	mv	a2,s5
ffffffffc02033f6:	002c                	addi	a1,sp,8
ffffffffc02033f8:	7b9c                	ld	a5,48(a5)
ffffffffc02033fa:	854a                	mv	a0,s2
ffffffffc02033fc:	9782                	jalr	a5
          if (r != 0) {
ffffffffc02033fe:	e12d                	bnez	a0,ffffffffc0203460 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0203400:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203402:	01893503          	ld	a0,24(s2)
ffffffffc0203406:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0203408:	7f84                	ld	s1,56(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc020340a:	85a6                	mv	a1,s1
ffffffffc020340c:	8bdfd0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203410:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203412:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0203414:	8b85                	andi	a5,a5,1
ffffffffc0203416:	cfb9                	beqz	a5,ffffffffc0203474 <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0203418:	65a2                	ld	a1,8(sp)
ffffffffc020341a:	7d9c                	ld	a5,56(a1)
ffffffffc020341c:	83b1                	srli	a5,a5,0xc
ffffffffc020341e:	00178513          	addi	a0,a5,1
ffffffffc0203422:	0522                	slli	a0,a0,0x8
ffffffffc0203424:	509000ef          	jal	ra,ffffffffc020412c <swapfs_write>
ffffffffc0203428:	d949                	beqz	a0,ffffffffc02033ba <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc020342a:	855e                	mv	a0,s7
ffffffffc020342c:	ca5fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203430:	0009b783          	ld	a5,0(s3)
ffffffffc0203434:	6622                	ld	a2,8(sp)
ffffffffc0203436:	4681                	li	a3,0
ffffffffc0203438:	739c                	ld	a5,32(a5)
ffffffffc020343a:	85a6                	mv	a1,s1
ffffffffc020343c:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc020343e:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203440:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0203442:	fa8a17e3          	bne	s4,s0,ffffffffc02033f0 <swap_out+0x70>
}
ffffffffc0203446:	8522                	mv	a0,s0
ffffffffc0203448:	60e6                	ld	ra,88(sp)
ffffffffc020344a:	6446                	ld	s0,80(sp)
ffffffffc020344c:	64a6                	ld	s1,72(sp)
ffffffffc020344e:	6906                	ld	s2,64(sp)
ffffffffc0203450:	79e2                	ld	s3,56(sp)
ffffffffc0203452:	7a42                	ld	s4,48(sp)
ffffffffc0203454:	7aa2                	ld	s5,40(sp)
ffffffffc0203456:	7b02                	ld	s6,32(sp)
ffffffffc0203458:	6be2                	ld	s7,24(sp)
ffffffffc020345a:	6c42                	ld	s8,16(sp)
ffffffffc020345c:	6125                	addi	sp,sp,96
ffffffffc020345e:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0203460:	85a2                	mv	a1,s0
ffffffffc0203462:	00003517          	auipc	a0,0x3
ffffffffc0203466:	30e50513          	addi	a0,a0,782 # ffffffffc0206770 <commands+0x1720>
ffffffffc020346a:	c67fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
                  break;
ffffffffc020346e:	bfe1                	j	ffffffffc0203446 <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0203470:	4401                	li	s0,0
ffffffffc0203472:	bfd1                	j	ffffffffc0203446 <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203474:	00003697          	auipc	a3,0x3
ffffffffc0203478:	32c68693          	addi	a3,a3,812 # ffffffffc02067a0 <commands+0x1750>
ffffffffc020347c:	00002617          	auipc	a2,0x2
ffffffffc0203480:	56c60613          	addi	a2,a2,1388 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203484:	06900593          	li	a1,105
ffffffffc0203488:	00003517          	auipc	a0,0x3
ffffffffc020348c:	06050513          	addi	a0,a0,96 # ffffffffc02064e8 <commands+0x1498>
ffffffffc0203490:	d47fc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0203494 <swap_in>:
{
ffffffffc0203494:	7179                	addi	sp,sp,-48
ffffffffc0203496:	e84a                	sd	s2,16(sp)
ffffffffc0203498:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc020349a:	4505                	li	a0,1
{
ffffffffc020349c:	ec26                	sd	s1,24(sp)
ffffffffc020349e:	e44e                	sd	s3,8(sp)
ffffffffc02034a0:	f406                	sd	ra,40(sp)
ffffffffc02034a2:	f022                	sd	s0,32(sp)
ffffffffc02034a4:	84ae                	mv	s1,a1
ffffffffc02034a6:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc02034a8:	f12fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
     assert(result!=NULL);
ffffffffc02034ac:	c129                	beqz	a0,ffffffffc02034ee <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc02034ae:	842a                	mv	s0,a0
ffffffffc02034b0:	01893503          	ld	a0,24(s2)
ffffffffc02034b4:	4601                	li	a2,0
ffffffffc02034b6:	85a6                	mv	a1,s1
ffffffffc02034b8:	811fd0ef          	jal	ra,ffffffffc0200cc8 <get_pte>
ffffffffc02034bc:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc02034be:	6108                	ld	a0,0(a0)
ffffffffc02034c0:	85a2                	mv	a1,s0
ffffffffc02034c2:	3d3000ef          	jal	ra,ffffffffc0204094 <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc02034c6:	00093583          	ld	a1,0(s2)
ffffffffc02034ca:	8626                	mv	a2,s1
ffffffffc02034cc:	00003517          	auipc	a0,0x3
ffffffffc02034d0:	fbc50513          	addi	a0,a0,-68 # ffffffffc0206488 <commands+0x1438>
ffffffffc02034d4:	81a1                	srli	a1,a1,0x8
ffffffffc02034d6:	bfbfc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc02034da:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc02034dc:	0089b023          	sd	s0,0(s3)
}
ffffffffc02034e0:	7402                	ld	s0,32(sp)
ffffffffc02034e2:	64e2                	ld	s1,24(sp)
ffffffffc02034e4:	6942                	ld	s2,16(sp)
ffffffffc02034e6:	69a2                	ld	s3,8(sp)
ffffffffc02034e8:	4501                	li	a0,0
ffffffffc02034ea:	6145                	addi	sp,sp,48
ffffffffc02034ec:	8082                	ret
     assert(result!=NULL);
ffffffffc02034ee:	00003697          	auipc	a3,0x3
ffffffffc02034f2:	f8a68693          	addi	a3,a3,-118 # ffffffffc0206478 <commands+0x1428>
ffffffffc02034f6:	00002617          	auipc	a2,0x2
ffffffffc02034fa:	4f260613          	addi	a2,a2,1266 # ffffffffc02059e8 <commands+0x998>
ffffffffc02034fe:	07f00593          	li	a1,127
ffffffffc0203502:	00003517          	auipc	a0,0x3
ffffffffc0203506:	fe650513          	addi	a0,a0,-26 # ffffffffc02064e8 <commands+0x1498>
ffffffffc020350a:	ccdfc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc020350e <default_init>:
    elm->prev = elm->next = elm;
ffffffffc020350e:	00013797          	auipc	a5,0x13
ffffffffc0203512:	0ca78793          	addi	a5,a5,202 # ffffffffc02165d8 <free_area>
ffffffffc0203516:	e79c                	sd	a5,8(a5)
ffffffffc0203518:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc020351a:	0007a823          	sw	zero,16(a5)
}
ffffffffc020351e:	8082                	ret

ffffffffc0203520 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0203520:	00013517          	auipc	a0,0x13
ffffffffc0203524:	0c856503          	lwu	a0,200(a0) # ffffffffc02165e8 <free_area+0x10>
ffffffffc0203528:	8082                	ret

ffffffffc020352a <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc020352a:	715d                	addi	sp,sp,-80
ffffffffc020352c:	f84a                	sd	s2,48(sp)
    return listelm->next;
ffffffffc020352e:	00013917          	auipc	s2,0x13
ffffffffc0203532:	0aa90913          	addi	s2,s2,170 # ffffffffc02165d8 <free_area>
ffffffffc0203536:	00893783          	ld	a5,8(s2)
ffffffffc020353a:	e486                	sd	ra,72(sp)
ffffffffc020353c:	e0a2                	sd	s0,64(sp)
ffffffffc020353e:	fc26                	sd	s1,56(sp)
ffffffffc0203540:	f44e                	sd	s3,40(sp)
ffffffffc0203542:	f052                	sd	s4,32(sp)
ffffffffc0203544:	ec56                	sd	s5,24(sp)
ffffffffc0203546:	e85a                	sd	s6,16(sp)
ffffffffc0203548:	e45e                	sd	s7,8(sp)
ffffffffc020354a:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc020354c:	31278463          	beq	a5,s2,ffffffffc0203854 <default_check+0x32a>
ffffffffc0203550:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203554:	8305                	srli	a4,a4,0x1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0203556:	8b05                	andi	a4,a4,1
ffffffffc0203558:	30070263          	beqz	a4,ffffffffc020385c <default_check+0x332>
    int count = 0, total = 0;
ffffffffc020355c:	4401                	li	s0,0
ffffffffc020355e:	4481                	li	s1,0
ffffffffc0203560:	a031                	j	ffffffffc020356c <default_check+0x42>
ffffffffc0203562:	ff07b703          	ld	a4,-16(a5)
        assert(PageProperty(p));
ffffffffc0203566:	8b09                	andi	a4,a4,2
ffffffffc0203568:	2e070a63          	beqz	a4,ffffffffc020385c <default_check+0x332>
        count ++, total += p->property;
ffffffffc020356c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203570:	679c                	ld	a5,8(a5)
ffffffffc0203572:	2485                	addiw	s1,s1,1
ffffffffc0203574:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203576:	ff2796e3          	bne	a5,s2,ffffffffc0203562 <default_check+0x38>
ffffffffc020357a:	89a2                	mv	s3,s0
    }
    assert(total == nr_free_pages());
ffffffffc020357c:	f0cfd0ef          	jal	ra,ffffffffc0200c88 <nr_free_pages>
ffffffffc0203580:	73351e63          	bne	a0,s3,ffffffffc0203cbc <default_check+0x792>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0203584:	4505                	li	a0,1
ffffffffc0203586:	e34fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc020358a:	8a2a                	mv	s4,a0
ffffffffc020358c:	46050863          	beqz	a0,ffffffffc02039fc <default_check+0x4d2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0203590:	4505                	li	a0,1
ffffffffc0203592:	e28fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203596:	89aa                	mv	s3,a0
ffffffffc0203598:	74050263          	beqz	a0,ffffffffc0203cdc <default_check+0x7b2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020359c:	4505                	li	a0,1
ffffffffc020359e:	e1cfd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02035a2:	8aaa                	mv	s5,a0
ffffffffc02035a4:	4c050c63          	beqz	a0,ffffffffc0203a7c <default_check+0x552>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02035a8:	2d3a0a63          	beq	s4,s3,ffffffffc020387c <default_check+0x352>
ffffffffc02035ac:	2caa0863          	beq	s4,a0,ffffffffc020387c <default_check+0x352>
ffffffffc02035b0:	2ca98663          	beq	s3,a0,ffffffffc020387c <default_check+0x352>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02035b4:	000a2783          	lw	a5,0(s4)
ffffffffc02035b8:	2e079263          	bnez	a5,ffffffffc020389c <default_check+0x372>
ffffffffc02035bc:	0009a783          	lw	a5,0(s3)
ffffffffc02035c0:	2c079e63          	bnez	a5,ffffffffc020389c <default_check+0x372>
ffffffffc02035c4:	411c                	lw	a5,0(a0)
ffffffffc02035c6:	2c079b63          	bnez	a5,ffffffffc020389c <default_check+0x372>
    return page - pages + nbase;
ffffffffc02035ca:	00013797          	auipc	a5,0x13
ffffffffc02035ce:	f2678793          	addi	a5,a5,-218 # ffffffffc02164f0 <pages>
ffffffffc02035d2:	639c                	ld	a5,0(a5)
ffffffffc02035d4:	00004717          	auipc	a4,0x4
ffffffffc02035d8:	a2c70713          	addi	a4,a4,-1492 # ffffffffc0207000 <nbase>
ffffffffc02035dc:	6310                	ld	a2,0(a4)
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02035de:	00013717          	auipc	a4,0x13
ffffffffc02035e2:	eaa70713          	addi	a4,a4,-342 # ffffffffc0216488 <npage>
ffffffffc02035e6:	6314                	ld	a3,0(a4)
ffffffffc02035e8:	40fa0733          	sub	a4,s4,a5
ffffffffc02035ec:	8719                	srai	a4,a4,0x6
ffffffffc02035ee:	9732                	add	a4,a4,a2
ffffffffc02035f0:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02035f2:	0732                	slli	a4,a4,0xc
ffffffffc02035f4:	2cd77463          	bleu	a3,a4,ffffffffc02038bc <default_check+0x392>
    return page - pages + nbase;
ffffffffc02035f8:	40f98733          	sub	a4,s3,a5
ffffffffc02035fc:	8719                	srai	a4,a4,0x6
ffffffffc02035fe:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0203600:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0203602:	4ed77d63          	bleu	a3,a4,ffffffffc0203afc <default_check+0x5d2>
    return page - pages + nbase;
ffffffffc0203606:	40f507b3          	sub	a5,a0,a5
ffffffffc020360a:	8799                	srai	a5,a5,0x6
ffffffffc020360c:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020360e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0203610:	34d7f663          	bleu	a3,a5,ffffffffc020395c <default_check+0x432>
    assert(alloc_page() == NULL);
ffffffffc0203614:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0203616:	00093c03          	ld	s8,0(s2)
ffffffffc020361a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc020361e:	01092b03          	lw	s6,16(s2)
    elm->prev = elm->next = elm;
ffffffffc0203622:	00013797          	auipc	a5,0x13
ffffffffc0203626:	fb27bf23          	sd	s2,-66(a5) # ffffffffc02165e0 <free_area+0x8>
ffffffffc020362a:	00013797          	auipc	a5,0x13
ffffffffc020362e:	fb27b723          	sd	s2,-82(a5) # ffffffffc02165d8 <free_area>
    nr_free = 0;
ffffffffc0203632:	00013797          	auipc	a5,0x13
ffffffffc0203636:	fa07ab23          	sw	zero,-74(a5) # ffffffffc02165e8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc020363a:	d80fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc020363e:	2e051f63          	bnez	a0,ffffffffc020393c <default_check+0x412>
    free_page(p0);
ffffffffc0203642:	4585                	li	a1,1
ffffffffc0203644:	8552                	mv	a0,s4
ffffffffc0203646:	dfcfd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    free_page(p1);
ffffffffc020364a:	4585                	li	a1,1
ffffffffc020364c:	854e                	mv	a0,s3
ffffffffc020364e:	df4fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    free_page(p2);
ffffffffc0203652:	4585                	li	a1,1
ffffffffc0203654:	8556                	mv	a0,s5
ffffffffc0203656:	decfd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    assert(nr_free == 3);
ffffffffc020365a:	01092703          	lw	a4,16(s2)
ffffffffc020365e:	478d                	li	a5,3
ffffffffc0203660:	2af71e63          	bne	a4,a5,ffffffffc020391c <default_check+0x3f2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0203664:	4505                	li	a0,1
ffffffffc0203666:	d54fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc020366a:	89aa                	mv	s3,a0
ffffffffc020366c:	28050863          	beqz	a0,ffffffffc02038fc <default_check+0x3d2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0203670:	4505                	li	a0,1
ffffffffc0203672:	d48fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203676:	8aaa                	mv	s5,a0
ffffffffc0203678:	3e050263          	beqz	a0,ffffffffc0203a5c <default_check+0x532>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020367c:	4505                	li	a0,1
ffffffffc020367e:	d3cfd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203682:	8a2a                	mv	s4,a0
ffffffffc0203684:	3a050c63          	beqz	a0,ffffffffc0203a3c <default_check+0x512>
    assert(alloc_page() == NULL);
ffffffffc0203688:	4505                	li	a0,1
ffffffffc020368a:	d30fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc020368e:	38051763          	bnez	a0,ffffffffc0203a1c <default_check+0x4f2>
    free_page(p0);
ffffffffc0203692:	4585                	li	a1,1
ffffffffc0203694:	854e                	mv	a0,s3
ffffffffc0203696:	dacfd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc020369a:	00893783          	ld	a5,8(s2)
ffffffffc020369e:	23278f63          	beq	a5,s2,ffffffffc02038dc <default_check+0x3b2>
    assert((p = alloc_page()) == p0);
ffffffffc02036a2:	4505                	li	a0,1
ffffffffc02036a4:	d16fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02036a8:	32a99a63          	bne	s3,a0,ffffffffc02039dc <default_check+0x4b2>
    assert(alloc_page() == NULL);
ffffffffc02036ac:	4505                	li	a0,1
ffffffffc02036ae:	d0cfd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02036b2:	30051563          	bnez	a0,ffffffffc02039bc <default_check+0x492>
    assert(nr_free == 0);
ffffffffc02036b6:	01092783          	lw	a5,16(s2)
ffffffffc02036ba:	2e079163          	bnez	a5,ffffffffc020399c <default_check+0x472>
    free_page(p);
ffffffffc02036be:	854e                	mv	a0,s3
ffffffffc02036c0:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02036c2:	00013797          	auipc	a5,0x13
ffffffffc02036c6:	f187bb23          	sd	s8,-234(a5) # ffffffffc02165d8 <free_area>
ffffffffc02036ca:	00013797          	auipc	a5,0x13
ffffffffc02036ce:	f177bb23          	sd	s7,-234(a5) # ffffffffc02165e0 <free_area+0x8>
    nr_free = nr_free_store;
ffffffffc02036d2:	00013797          	auipc	a5,0x13
ffffffffc02036d6:	f167ab23          	sw	s6,-234(a5) # ffffffffc02165e8 <free_area+0x10>
    free_page(p);
ffffffffc02036da:	d68fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    free_page(p1);
ffffffffc02036de:	4585                	li	a1,1
ffffffffc02036e0:	8556                	mv	a0,s5
ffffffffc02036e2:	d60fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    free_page(p2);
ffffffffc02036e6:	4585                	li	a1,1
ffffffffc02036e8:	8552                	mv	a0,s4
ffffffffc02036ea:	d58fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02036ee:	4515                	li	a0,5
ffffffffc02036f0:	ccafd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02036f4:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02036f6:	28050363          	beqz	a0,ffffffffc020397c <default_check+0x452>
ffffffffc02036fa:	651c                	ld	a5,8(a0)
ffffffffc02036fc:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc02036fe:	8b85                	andi	a5,a5,1
ffffffffc0203700:	54079e63          	bnez	a5,ffffffffc0203c5c <default_check+0x732>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0203704:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0203706:	00093b03          	ld	s6,0(s2)
ffffffffc020370a:	00893a83          	ld	s5,8(s2)
ffffffffc020370e:	00013797          	auipc	a5,0x13
ffffffffc0203712:	ed27b523          	sd	s2,-310(a5) # ffffffffc02165d8 <free_area>
ffffffffc0203716:	00013797          	auipc	a5,0x13
ffffffffc020371a:	ed27b523          	sd	s2,-310(a5) # ffffffffc02165e0 <free_area+0x8>
    assert(alloc_page() == NULL);
ffffffffc020371e:	c9cfd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203722:	50051d63          	bnez	a0,ffffffffc0203c3c <default_check+0x712>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0203726:	08098a13          	addi	s4,s3,128
ffffffffc020372a:	8552                	mv	a0,s4
ffffffffc020372c:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020372e:	01092b83          	lw	s7,16(s2)
    nr_free = 0;
ffffffffc0203732:	00013797          	auipc	a5,0x13
ffffffffc0203736:	ea07ab23          	sw	zero,-330(a5) # ffffffffc02165e8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020373a:	d08fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc020373e:	4511                	li	a0,4
ffffffffc0203740:	c7afd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203744:	4c051c63          	bnez	a0,ffffffffc0203c1c <default_check+0x6f2>
ffffffffc0203748:	0889b783          	ld	a5,136(s3)
ffffffffc020374c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020374e:	8b85                	andi	a5,a5,1
ffffffffc0203750:	4a078663          	beqz	a5,ffffffffc0203bfc <default_check+0x6d2>
ffffffffc0203754:	0909a703          	lw	a4,144(s3)
ffffffffc0203758:	478d                	li	a5,3
ffffffffc020375a:	4af71163          	bne	a4,a5,ffffffffc0203bfc <default_check+0x6d2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020375e:	450d                	li	a0,3
ffffffffc0203760:	c5afd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203764:	8c2a                	mv	s8,a0
ffffffffc0203766:	46050b63          	beqz	a0,ffffffffc0203bdc <default_check+0x6b2>
    assert(alloc_page() == NULL);
ffffffffc020376a:	4505                	li	a0,1
ffffffffc020376c:	c4efd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc0203770:	44051663          	bnez	a0,ffffffffc0203bbc <default_check+0x692>
    assert(p0 + 2 == p1);
ffffffffc0203774:	438a1463          	bne	s4,s8,ffffffffc0203b9c <default_check+0x672>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0203778:	4585                	li	a1,1
ffffffffc020377a:	854e                	mv	a0,s3
ffffffffc020377c:	cc6fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    free_pages(p1, 3);
ffffffffc0203780:	458d                	li	a1,3
ffffffffc0203782:	8552                	mv	a0,s4
ffffffffc0203784:	cbefd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
ffffffffc0203788:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020378c:	04098c13          	addi	s8,s3,64
ffffffffc0203790:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0203792:	8b85                	andi	a5,a5,1
ffffffffc0203794:	3e078463          	beqz	a5,ffffffffc0203b7c <default_check+0x652>
ffffffffc0203798:	0109a703          	lw	a4,16(s3)
ffffffffc020379c:	4785                	li	a5,1
ffffffffc020379e:	3cf71f63          	bne	a4,a5,ffffffffc0203b7c <default_check+0x652>
ffffffffc02037a2:	008a3783          	ld	a5,8(s4)
ffffffffc02037a6:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02037a8:	8b85                	andi	a5,a5,1
ffffffffc02037aa:	3a078963          	beqz	a5,ffffffffc0203b5c <default_check+0x632>
ffffffffc02037ae:	010a2703          	lw	a4,16(s4)
ffffffffc02037b2:	478d                	li	a5,3
ffffffffc02037b4:	3af71463          	bne	a4,a5,ffffffffc0203b5c <default_check+0x632>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02037b8:	4505                	li	a0,1
ffffffffc02037ba:	c00fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02037be:	36a99f63          	bne	s3,a0,ffffffffc0203b3c <default_check+0x612>
    free_page(p0);
ffffffffc02037c2:	4585                	li	a1,1
ffffffffc02037c4:	c7efd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02037c8:	4509                	li	a0,2
ffffffffc02037ca:	bf0fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02037ce:	34aa1763          	bne	s4,a0,ffffffffc0203b1c <default_check+0x5f2>

    free_pages(p0, 2);
ffffffffc02037d2:	4589                	li	a1,2
ffffffffc02037d4:	c6efd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    free_page(p2);
ffffffffc02037d8:	4585                	li	a1,1
ffffffffc02037da:	8562                	mv	a0,s8
ffffffffc02037dc:	c66fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02037e0:	4515                	li	a0,5
ffffffffc02037e2:	bd8fd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02037e6:	89aa                	mv	s3,a0
ffffffffc02037e8:	48050a63          	beqz	a0,ffffffffc0203c7c <default_check+0x752>
    assert(alloc_page() == NULL);
ffffffffc02037ec:	4505                	li	a0,1
ffffffffc02037ee:	bccfd0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
ffffffffc02037f2:	2e051563          	bnez	a0,ffffffffc0203adc <default_check+0x5b2>

    assert(nr_free == 0);
ffffffffc02037f6:	01092783          	lw	a5,16(s2)
ffffffffc02037fa:	2c079163          	bnez	a5,ffffffffc0203abc <default_check+0x592>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02037fe:	4595                	li	a1,5
ffffffffc0203800:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0203802:	00013797          	auipc	a5,0x13
ffffffffc0203806:	df77a323          	sw	s7,-538(a5) # ffffffffc02165e8 <free_area+0x10>
    free_list = free_list_store;
ffffffffc020380a:	00013797          	auipc	a5,0x13
ffffffffc020380e:	dd67b723          	sd	s6,-562(a5) # ffffffffc02165d8 <free_area>
ffffffffc0203812:	00013797          	auipc	a5,0x13
ffffffffc0203816:	dd57b723          	sd	s5,-562(a5) # ffffffffc02165e0 <free_area+0x8>
    free_pages(p0, 5);
ffffffffc020381a:	c28fd0ef          	jal	ra,ffffffffc0200c42 <free_pages>
    return listelm->next;
ffffffffc020381e:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203822:	01278963          	beq	a5,s2,ffffffffc0203834 <default_check+0x30a>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0203826:	ff87a703          	lw	a4,-8(a5)
ffffffffc020382a:	679c                	ld	a5,8(a5)
ffffffffc020382c:	34fd                	addiw	s1,s1,-1
ffffffffc020382e:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203830:	ff279be3          	bne	a5,s2,ffffffffc0203826 <default_check+0x2fc>
    }
    assert(count == 0);
ffffffffc0203834:	26049463          	bnez	s1,ffffffffc0203a9c <default_check+0x572>
    assert(total == 0);
ffffffffc0203838:	46041263          	bnez	s0,ffffffffc0203c9c <default_check+0x772>
}
ffffffffc020383c:	60a6                	ld	ra,72(sp)
ffffffffc020383e:	6406                	ld	s0,64(sp)
ffffffffc0203840:	74e2                	ld	s1,56(sp)
ffffffffc0203842:	7942                	ld	s2,48(sp)
ffffffffc0203844:	79a2                	ld	s3,40(sp)
ffffffffc0203846:	7a02                	ld	s4,32(sp)
ffffffffc0203848:	6ae2                	ld	s5,24(sp)
ffffffffc020384a:	6b42                	ld	s6,16(sp)
ffffffffc020384c:	6ba2                	ld	s7,8(sp)
ffffffffc020384e:	6c02                	ld	s8,0(sp)
ffffffffc0203850:	6161                	addi	sp,sp,80
ffffffffc0203852:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203854:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0203856:	4401                	li	s0,0
ffffffffc0203858:	4481                	li	s1,0
ffffffffc020385a:	b30d                	j	ffffffffc020357c <default_check+0x52>
        assert(PageProperty(p));
ffffffffc020385c:	00003697          	auipc	a3,0x3
ffffffffc0203860:	cb468693          	addi	a3,a3,-844 # ffffffffc0206510 <commands+0x14c0>
ffffffffc0203864:	00002617          	auipc	a2,0x2
ffffffffc0203868:	18460613          	addi	a2,a2,388 # ffffffffc02059e8 <commands+0x998>
ffffffffc020386c:	0f000593          	li	a1,240
ffffffffc0203870:	00003517          	auipc	a0,0x3
ffffffffc0203874:	fa050513          	addi	a0,a0,-96 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203878:	95ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020387c:	00003697          	auipc	a3,0x3
ffffffffc0203880:	00c68693          	addi	a3,a3,12 # ffffffffc0206888 <commands+0x1838>
ffffffffc0203884:	00002617          	auipc	a2,0x2
ffffffffc0203888:	16460613          	addi	a2,a2,356 # ffffffffc02059e8 <commands+0x998>
ffffffffc020388c:	0bd00593          	li	a1,189
ffffffffc0203890:	00003517          	auipc	a0,0x3
ffffffffc0203894:	f8050513          	addi	a0,a0,-128 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203898:	93ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020389c:	00003697          	auipc	a3,0x3
ffffffffc02038a0:	01468693          	addi	a3,a3,20 # ffffffffc02068b0 <commands+0x1860>
ffffffffc02038a4:	00002617          	auipc	a2,0x2
ffffffffc02038a8:	14460613          	addi	a2,a2,324 # ffffffffc02059e8 <commands+0x998>
ffffffffc02038ac:	0be00593          	li	a1,190
ffffffffc02038b0:	00003517          	auipc	a0,0x3
ffffffffc02038b4:	f6050513          	addi	a0,a0,-160 # ffffffffc0206810 <commands+0x17c0>
ffffffffc02038b8:	91ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02038bc:	00003697          	auipc	a3,0x3
ffffffffc02038c0:	03468693          	addi	a3,a3,52 # ffffffffc02068f0 <commands+0x18a0>
ffffffffc02038c4:	00002617          	auipc	a2,0x2
ffffffffc02038c8:	12460613          	addi	a2,a2,292 # ffffffffc02059e8 <commands+0x998>
ffffffffc02038cc:	0c000593          	li	a1,192
ffffffffc02038d0:	00003517          	auipc	a0,0x3
ffffffffc02038d4:	f4050513          	addi	a0,a0,-192 # ffffffffc0206810 <commands+0x17c0>
ffffffffc02038d8:	8fffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02038dc:	00003697          	auipc	a3,0x3
ffffffffc02038e0:	09c68693          	addi	a3,a3,156 # ffffffffc0206978 <commands+0x1928>
ffffffffc02038e4:	00002617          	auipc	a2,0x2
ffffffffc02038e8:	10460613          	addi	a2,a2,260 # ffffffffc02059e8 <commands+0x998>
ffffffffc02038ec:	0d900593          	li	a1,217
ffffffffc02038f0:	00003517          	auipc	a0,0x3
ffffffffc02038f4:	f2050513          	addi	a0,a0,-224 # ffffffffc0206810 <commands+0x17c0>
ffffffffc02038f8:	8dffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02038fc:	00003697          	auipc	a3,0x3
ffffffffc0203900:	f2c68693          	addi	a3,a3,-212 # ffffffffc0206828 <commands+0x17d8>
ffffffffc0203904:	00002617          	auipc	a2,0x2
ffffffffc0203908:	0e460613          	addi	a2,a2,228 # ffffffffc02059e8 <commands+0x998>
ffffffffc020390c:	0d200593          	li	a1,210
ffffffffc0203910:	00003517          	auipc	a0,0x3
ffffffffc0203914:	f0050513          	addi	a0,a0,-256 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203918:	8bffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(nr_free == 3);
ffffffffc020391c:	00003697          	auipc	a3,0x3
ffffffffc0203920:	04c68693          	addi	a3,a3,76 # ffffffffc0206968 <commands+0x1918>
ffffffffc0203924:	00002617          	auipc	a2,0x2
ffffffffc0203928:	0c460613          	addi	a2,a2,196 # ffffffffc02059e8 <commands+0x998>
ffffffffc020392c:	0d000593          	li	a1,208
ffffffffc0203930:	00003517          	auipc	a0,0x3
ffffffffc0203934:	ee050513          	addi	a0,a0,-288 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203938:	89ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020393c:	00003697          	auipc	a3,0x3
ffffffffc0203940:	01468693          	addi	a3,a3,20 # ffffffffc0206950 <commands+0x1900>
ffffffffc0203944:	00002617          	auipc	a2,0x2
ffffffffc0203948:	0a460613          	addi	a2,a2,164 # ffffffffc02059e8 <commands+0x998>
ffffffffc020394c:	0cb00593          	li	a1,203
ffffffffc0203950:	00003517          	auipc	a0,0x3
ffffffffc0203954:	ec050513          	addi	a0,a0,-320 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203958:	87ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020395c:	00003697          	auipc	a3,0x3
ffffffffc0203960:	fd468693          	addi	a3,a3,-44 # ffffffffc0206930 <commands+0x18e0>
ffffffffc0203964:	00002617          	auipc	a2,0x2
ffffffffc0203968:	08460613          	addi	a2,a2,132 # ffffffffc02059e8 <commands+0x998>
ffffffffc020396c:	0c200593          	li	a1,194
ffffffffc0203970:	00003517          	auipc	a0,0x3
ffffffffc0203974:	ea050513          	addi	a0,a0,-352 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203978:	85ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(p0 != NULL);
ffffffffc020397c:	00003697          	auipc	a3,0x3
ffffffffc0203980:	03468693          	addi	a3,a3,52 # ffffffffc02069b0 <commands+0x1960>
ffffffffc0203984:	00002617          	auipc	a2,0x2
ffffffffc0203988:	06460613          	addi	a2,a2,100 # ffffffffc02059e8 <commands+0x998>
ffffffffc020398c:	0f800593          	li	a1,248
ffffffffc0203990:	00003517          	auipc	a0,0x3
ffffffffc0203994:	e8050513          	addi	a0,a0,-384 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203998:	83ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(nr_free == 0);
ffffffffc020399c:	00003697          	auipc	a3,0x3
ffffffffc02039a0:	d1468693          	addi	a3,a3,-748 # ffffffffc02066b0 <commands+0x1660>
ffffffffc02039a4:	00002617          	auipc	a2,0x2
ffffffffc02039a8:	04460613          	addi	a2,a2,68 # ffffffffc02059e8 <commands+0x998>
ffffffffc02039ac:	0df00593          	li	a1,223
ffffffffc02039b0:	00003517          	auipc	a0,0x3
ffffffffc02039b4:	e6050513          	addi	a0,a0,-416 # ffffffffc0206810 <commands+0x17c0>
ffffffffc02039b8:	81ffc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02039bc:	00003697          	auipc	a3,0x3
ffffffffc02039c0:	f9468693          	addi	a3,a3,-108 # ffffffffc0206950 <commands+0x1900>
ffffffffc02039c4:	00002617          	auipc	a2,0x2
ffffffffc02039c8:	02460613          	addi	a2,a2,36 # ffffffffc02059e8 <commands+0x998>
ffffffffc02039cc:	0dd00593          	li	a1,221
ffffffffc02039d0:	00003517          	auipc	a0,0x3
ffffffffc02039d4:	e4050513          	addi	a0,a0,-448 # ffffffffc0206810 <commands+0x17c0>
ffffffffc02039d8:	ffefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02039dc:	00003697          	auipc	a3,0x3
ffffffffc02039e0:	fb468693          	addi	a3,a3,-76 # ffffffffc0206990 <commands+0x1940>
ffffffffc02039e4:	00002617          	auipc	a2,0x2
ffffffffc02039e8:	00460613          	addi	a2,a2,4 # ffffffffc02059e8 <commands+0x998>
ffffffffc02039ec:	0dc00593          	li	a1,220
ffffffffc02039f0:	00003517          	auipc	a0,0x3
ffffffffc02039f4:	e2050513          	addi	a0,a0,-480 # ffffffffc0206810 <commands+0x17c0>
ffffffffc02039f8:	fdefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02039fc:	00003697          	auipc	a3,0x3
ffffffffc0203a00:	e2c68693          	addi	a3,a3,-468 # ffffffffc0206828 <commands+0x17d8>
ffffffffc0203a04:	00002617          	auipc	a2,0x2
ffffffffc0203a08:	fe460613          	addi	a2,a2,-28 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203a0c:	0b900593          	li	a1,185
ffffffffc0203a10:	00003517          	auipc	a0,0x3
ffffffffc0203a14:	e0050513          	addi	a0,a0,-512 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203a18:	fbefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0203a1c:	00003697          	auipc	a3,0x3
ffffffffc0203a20:	f3468693          	addi	a3,a3,-204 # ffffffffc0206950 <commands+0x1900>
ffffffffc0203a24:	00002617          	auipc	a2,0x2
ffffffffc0203a28:	fc460613          	addi	a2,a2,-60 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203a2c:	0d600593          	li	a1,214
ffffffffc0203a30:	00003517          	auipc	a0,0x3
ffffffffc0203a34:	de050513          	addi	a0,a0,-544 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203a38:	f9efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0203a3c:	00003697          	auipc	a3,0x3
ffffffffc0203a40:	e2c68693          	addi	a3,a3,-468 # ffffffffc0206868 <commands+0x1818>
ffffffffc0203a44:	00002617          	auipc	a2,0x2
ffffffffc0203a48:	fa460613          	addi	a2,a2,-92 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203a4c:	0d400593          	li	a1,212
ffffffffc0203a50:	00003517          	auipc	a0,0x3
ffffffffc0203a54:	dc050513          	addi	a0,a0,-576 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203a58:	f7efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0203a5c:	00003697          	auipc	a3,0x3
ffffffffc0203a60:	dec68693          	addi	a3,a3,-532 # ffffffffc0206848 <commands+0x17f8>
ffffffffc0203a64:	00002617          	auipc	a2,0x2
ffffffffc0203a68:	f8460613          	addi	a2,a2,-124 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203a6c:	0d300593          	li	a1,211
ffffffffc0203a70:	00003517          	auipc	a0,0x3
ffffffffc0203a74:	da050513          	addi	a0,a0,-608 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203a78:	f5efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0203a7c:	00003697          	auipc	a3,0x3
ffffffffc0203a80:	dec68693          	addi	a3,a3,-532 # ffffffffc0206868 <commands+0x1818>
ffffffffc0203a84:	00002617          	auipc	a2,0x2
ffffffffc0203a88:	f6460613          	addi	a2,a2,-156 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203a8c:	0bb00593          	li	a1,187
ffffffffc0203a90:	00003517          	auipc	a0,0x3
ffffffffc0203a94:	d8050513          	addi	a0,a0,-640 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203a98:	f3efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(count == 0);
ffffffffc0203a9c:	00003697          	auipc	a3,0x3
ffffffffc0203aa0:	06468693          	addi	a3,a3,100 # ffffffffc0206b00 <commands+0x1ab0>
ffffffffc0203aa4:	00002617          	auipc	a2,0x2
ffffffffc0203aa8:	f4460613          	addi	a2,a2,-188 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203aac:	12500593          	li	a1,293
ffffffffc0203ab0:	00003517          	auipc	a0,0x3
ffffffffc0203ab4:	d6050513          	addi	a0,a0,-672 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203ab8:	f1efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(nr_free == 0);
ffffffffc0203abc:	00003697          	auipc	a3,0x3
ffffffffc0203ac0:	bf468693          	addi	a3,a3,-1036 # ffffffffc02066b0 <commands+0x1660>
ffffffffc0203ac4:	00002617          	auipc	a2,0x2
ffffffffc0203ac8:	f2460613          	addi	a2,a2,-220 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203acc:	11a00593          	li	a1,282
ffffffffc0203ad0:	00003517          	auipc	a0,0x3
ffffffffc0203ad4:	d4050513          	addi	a0,a0,-704 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203ad8:	efefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0203adc:	00003697          	auipc	a3,0x3
ffffffffc0203ae0:	e7468693          	addi	a3,a3,-396 # ffffffffc0206950 <commands+0x1900>
ffffffffc0203ae4:	00002617          	auipc	a2,0x2
ffffffffc0203ae8:	f0460613          	addi	a2,a2,-252 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203aec:	11800593          	li	a1,280
ffffffffc0203af0:	00003517          	auipc	a0,0x3
ffffffffc0203af4:	d2050513          	addi	a0,a0,-736 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203af8:	edefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0203afc:	00003697          	auipc	a3,0x3
ffffffffc0203b00:	e1468693          	addi	a3,a3,-492 # ffffffffc0206910 <commands+0x18c0>
ffffffffc0203b04:	00002617          	auipc	a2,0x2
ffffffffc0203b08:	ee460613          	addi	a2,a2,-284 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203b0c:	0c100593          	li	a1,193
ffffffffc0203b10:	00003517          	auipc	a0,0x3
ffffffffc0203b14:	d0050513          	addi	a0,a0,-768 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203b18:	ebefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0203b1c:	00003697          	auipc	a3,0x3
ffffffffc0203b20:	fa468693          	addi	a3,a3,-92 # ffffffffc0206ac0 <commands+0x1a70>
ffffffffc0203b24:	00002617          	auipc	a2,0x2
ffffffffc0203b28:	ec460613          	addi	a2,a2,-316 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203b2c:	11200593          	li	a1,274
ffffffffc0203b30:	00003517          	auipc	a0,0x3
ffffffffc0203b34:	ce050513          	addi	a0,a0,-800 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203b38:	e9efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0203b3c:	00003697          	auipc	a3,0x3
ffffffffc0203b40:	f6468693          	addi	a3,a3,-156 # ffffffffc0206aa0 <commands+0x1a50>
ffffffffc0203b44:	00002617          	auipc	a2,0x2
ffffffffc0203b48:	ea460613          	addi	a2,a2,-348 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203b4c:	11000593          	li	a1,272
ffffffffc0203b50:	00003517          	auipc	a0,0x3
ffffffffc0203b54:	cc050513          	addi	a0,a0,-832 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203b58:	e7efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0203b5c:	00003697          	auipc	a3,0x3
ffffffffc0203b60:	f1c68693          	addi	a3,a3,-228 # ffffffffc0206a78 <commands+0x1a28>
ffffffffc0203b64:	00002617          	auipc	a2,0x2
ffffffffc0203b68:	e8460613          	addi	a2,a2,-380 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203b6c:	10e00593          	li	a1,270
ffffffffc0203b70:	00003517          	auipc	a0,0x3
ffffffffc0203b74:	ca050513          	addi	a0,a0,-864 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203b78:	e5efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0203b7c:	00003697          	auipc	a3,0x3
ffffffffc0203b80:	ed468693          	addi	a3,a3,-300 # ffffffffc0206a50 <commands+0x1a00>
ffffffffc0203b84:	00002617          	auipc	a2,0x2
ffffffffc0203b88:	e6460613          	addi	a2,a2,-412 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203b8c:	10d00593          	li	a1,269
ffffffffc0203b90:	00003517          	auipc	a0,0x3
ffffffffc0203b94:	c8050513          	addi	a0,a0,-896 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203b98:	e3efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0203b9c:	00003697          	auipc	a3,0x3
ffffffffc0203ba0:	ea468693          	addi	a3,a3,-348 # ffffffffc0206a40 <commands+0x19f0>
ffffffffc0203ba4:	00002617          	auipc	a2,0x2
ffffffffc0203ba8:	e4460613          	addi	a2,a2,-444 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203bac:	10800593          	li	a1,264
ffffffffc0203bb0:	00003517          	auipc	a0,0x3
ffffffffc0203bb4:	c6050513          	addi	a0,a0,-928 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203bb8:	e1efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0203bbc:	00003697          	auipc	a3,0x3
ffffffffc0203bc0:	d9468693          	addi	a3,a3,-620 # ffffffffc0206950 <commands+0x1900>
ffffffffc0203bc4:	00002617          	auipc	a2,0x2
ffffffffc0203bc8:	e2460613          	addi	a2,a2,-476 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203bcc:	10700593          	li	a1,263
ffffffffc0203bd0:	00003517          	auipc	a0,0x3
ffffffffc0203bd4:	c4050513          	addi	a0,a0,-960 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203bd8:	dfefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0203bdc:	00003697          	auipc	a3,0x3
ffffffffc0203be0:	e4468693          	addi	a3,a3,-444 # ffffffffc0206a20 <commands+0x19d0>
ffffffffc0203be4:	00002617          	auipc	a2,0x2
ffffffffc0203be8:	e0460613          	addi	a2,a2,-508 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203bec:	10600593          	li	a1,262
ffffffffc0203bf0:	00003517          	auipc	a0,0x3
ffffffffc0203bf4:	c2050513          	addi	a0,a0,-992 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203bf8:	ddefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0203bfc:	00003697          	auipc	a3,0x3
ffffffffc0203c00:	df468693          	addi	a3,a3,-524 # ffffffffc02069f0 <commands+0x19a0>
ffffffffc0203c04:	00002617          	auipc	a2,0x2
ffffffffc0203c08:	de460613          	addi	a2,a2,-540 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203c0c:	10500593          	li	a1,261
ffffffffc0203c10:	00003517          	auipc	a0,0x3
ffffffffc0203c14:	c0050513          	addi	a0,a0,-1024 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203c18:	dbefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0203c1c:	00003697          	auipc	a3,0x3
ffffffffc0203c20:	dbc68693          	addi	a3,a3,-580 # ffffffffc02069d8 <commands+0x1988>
ffffffffc0203c24:	00002617          	auipc	a2,0x2
ffffffffc0203c28:	dc460613          	addi	a2,a2,-572 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203c2c:	10400593          	li	a1,260
ffffffffc0203c30:	00003517          	auipc	a0,0x3
ffffffffc0203c34:	be050513          	addi	a0,a0,-1056 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203c38:	d9efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0203c3c:	00003697          	auipc	a3,0x3
ffffffffc0203c40:	d1468693          	addi	a3,a3,-748 # ffffffffc0206950 <commands+0x1900>
ffffffffc0203c44:	00002617          	auipc	a2,0x2
ffffffffc0203c48:	da460613          	addi	a2,a2,-604 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203c4c:	0fe00593          	li	a1,254
ffffffffc0203c50:	00003517          	auipc	a0,0x3
ffffffffc0203c54:	bc050513          	addi	a0,a0,-1088 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203c58:	d7efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(!PageProperty(p0));
ffffffffc0203c5c:	00003697          	auipc	a3,0x3
ffffffffc0203c60:	d6468693          	addi	a3,a3,-668 # ffffffffc02069c0 <commands+0x1970>
ffffffffc0203c64:	00002617          	auipc	a2,0x2
ffffffffc0203c68:	d8460613          	addi	a2,a2,-636 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203c6c:	0f900593          	li	a1,249
ffffffffc0203c70:	00003517          	auipc	a0,0x3
ffffffffc0203c74:	ba050513          	addi	a0,a0,-1120 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203c78:	d5efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0203c7c:	00003697          	auipc	a3,0x3
ffffffffc0203c80:	e6468693          	addi	a3,a3,-412 # ffffffffc0206ae0 <commands+0x1a90>
ffffffffc0203c84:	00002617          	auipc	a2,0x2
ffffffffc0203c88:	d6460613          	addi	a2,a2,-668 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203c8c:	11700593          	li	a1,279
ffffffffc0203c90:	00003517          	auipc	a0,0x3
ffffffffc0203c94:	b8050513          	addi	a0,a0,-1152 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203c98:	d3efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(total == 0);
ffffffffc0203c9c:	00003697          	auipc	a3,0x3
ffffffffc0203ca0:	e7468693          	addi	a3,a3,-396 # ffffffffc0206b10 <commands+0x1ac0>
ffffffffc0203ca4:	00002617          	auipc	a2,0x2
ffffffffc0203ca8:	d4460613          	addi	a2,a2,-700 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203cac:	12600593          	li	a1,294
ffffffffc0203cb0:	00003517          	auipc	a0,0x3
ffffffffc0203cb4:	b6050513          	addi	a0,a0,-1184 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203cb8:	d1efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(total == nr_free_pages());
ffffffffc0203cbc:	00003697          	auipc	a3,0x3
ffffffffc0203cc0:	86468693          	addi	a3,a3,-1948 # ffffffffc0206520 <commands+0x14d0>
ffffffffc0203cc4:	00002617          	auipc	a2,0x2
ffffffffc0203cc8:	d2460613          	addi	a2,a2,-732 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203ccc:	0f300593          	li	a1,243
ffffffffc0203cd0:	00003517          	auipc	a0,0x3
ffffffffc0203cd4:	b4050513          	addi	a0,a0,-1216 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203cd8:	cfefc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0203cdc:	00003697          	auipc	a3,0x3
ffffffffc0203ce0:	b6c68693          	addi	a3,a3,-1172 # ffffffffc0206848 <commands+0x17f8>
ffffffffc0203ce4:	00002617          	auipc	a2,0x2
ffffffffc0203ce8:	d0460613          	addi	a2,a2,-764 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203cec:	0ba00593          	li	a1,186
ffffffffc0203cf0:	00003517          	auipc	a0,0x3
ffffffffc0203cf4:	b2050513          	addi	a0,a0,-1248 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203cf8:	cdefc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0203cfc <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0203cfc:	1141                	addi	sp,sp,-16
ffffffffc0203cfe:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203d00:	16058e63          	beqz	a1,ffffffffc0203e7c <default_free_pages+0x180>
    for (; p != base + n; p ++) {
ffffffffc0203d04:	00659693          	slli	a3,a1,0x6
ffffffffc0203d08:	96aa                	add	a3,a3,a0
ffffffffc0203d0a:	02d50d63          	beq	a0,a3,ffffffffc0203d44 <default_free_pages+0x48>
ffffffffc0203d0e:	651c                	ld	a5,8(a0)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203d10:	8b85                	andi	a5,a5,1
ffffffffc0203d12:	14079563          	bnez	a5,ffffffffc0203e5c <default_free_pages+0x160>
ffffffffc0203d16:	651c                	ld	a5,8(a0)
ffffffffc0203d18:	8385                	srli	a5,a5,0x1
ffffffffc0203d1a:	8b85                	andi	a5,a5,1
ffffffffc0203d1c:	14079063          	bnez	a5,ffffffffc0203e5c <default_free_pages+0x160>
ffffffffc0203d20:	87aa                	mv	a5,a0
ffffffffc0203d22:	a809                	j	ffffffffc0203d34 <default_free_pages+0x38>
ffffffffc0203d24:	6798                	ld	a4,8(a5)
ffffffffc0203d26:	8b05                	andi	a4,a4,1
ffffffffc0203d28:	12071a63          	bnez	a4,ffffffffc0203e5c <default_free_pages+0x160>
ffffffffc0203d2c:	6798                	ld	a4,8(a5)
ffffffffc0203d2e:	8b09                	andi	a4,a4,2
ffffffffc0203d30:	12071663          	bnez	a4,ffffffffc0203e5c <default_free_pages+0x160>
        p->flags = 0;
ffffffffc0203d34:	0007b423          	sd	zero,8(a5)
    page->ref = val;
ffffffffc0203d38:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0203d3c:	04078793          	addi	a5,a5,64
ffffffffc0203d40:	fed792e3          	bne	a5,a3,ffffffffc0203d24 <default_free_pages+0x28>
    base->property = n;
ffffffffc0203d44:	2581                	sext.w	a1,a1
ffffffffc0203d46:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0203d48:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203d4c:	4789                	li	a5,2
ffffffffc0203d4e:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0203d52:	00013697          	auipc	a3,0x13
ffffffffc0203d56:	88668693          	addi	a3,a3,-1914 # ffffffffc02165d8 <free_area>
ffffffffc0203d5a:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0203d5c:	669c                	ld	a5,8(a3)
ffffffffc0203d5e:	9db9                	addw	a1,a1,a4
ffffffffc0203d60:	00013717          	auipc	a4,0x13
ffffffffc0203d64:	88b72423          	sw	a1,-1912(a4) # ffffffffc02165e8 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc0203d68:	0cd78163          	beq	a5,a3,ffffffffc0203e2a <default_free_pages+0x12e>
            struct Page* page = le2page(le, page_link);
ffffffffc0203d6c:	fe878713          	addi	a4,a5,-24
ffffffffc0203d70:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0203d72:	4801                	li	a6,0
ffffffffc0203d74:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0203d78:	00e56a63          	bltu	a0,a4,ffffffffc0203d8c <default_free_pages+0x90>
    return listelm->next;
ffffffffc0203d7c:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0203d7e:	04d70f63          	beq	a4,a3,ffffffffc0203ddc <default_free_pages+0xe0>
        while ((le = list_next(le)) != &free_list) {
ffffffffc0203d82:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0203d84:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0203d88:	fee57ae3          	bleu	a4,a0,ffffffffc0203d7c <default_free_pages+0x80>
ffffffffc0203d8c:	00080663          	beqz	a6,ffffffffc0203d98 <default_free_pages+0x9c>
ffffffffc0203d90:	00013817          	auipc	a6,0x13
ffffffffc0203d94:	84b83423          	sd	a1,-1976(a6) # ffffffffc02165d8 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0203d98:	638c                	ld	a1,0(a5)
    prev->next = next->prev = elm;
ffffffffc0203d9a:	e390                	sd	a2,0(a5)
ffffffffc0203d9c:	e590                	sd	a2,8(a1)
    elm->next = next;
ffffffffc0203d9e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203da0:	ed0c                	sd	a1,24(a0)
    if (le != &free_list) {
ffffffffc0203da2:	06d58a63          	beq	a1,a3,ffffffffc0203e16 <default_free_pages+0x11a>
        if (p + p->property == base) {
ffffffffc0203da6:	ff85a603          	lw	a2,-8(a1) # ff8 <BASE_ADDRESS-0xffffffffc01ff008>
        p = le2page(le, page_link);
ffffffffc0203daa:	fe858713          	addi	a4,a1,-24
        if (p + p->property == base) {
ffffffffc0203dae:	02061793          	slli	a5,a2,0x20
ffffffffc0203db2:	83e9                	srli	a5,a5,0x1a
ffffffffc0203db4:	97ba                	add	a5,a5,a4
ffffffffc0203db6:	04f51b63          	bne	a0,a5,ffffffffc0203e0c <default_free_pages+0x110>
            p->property += base->property;
ffffffffc0203dba:	491c                	lw	a5,16(a0)
ffffffffc0203dbc:	9e3d                	addw	a2,a2,a5
ffffffffc0203dbe:	fec5ac23          	sw	a2,-8(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203dc2:	57f5                	li	a5,-3
ffffffffc0203dc4:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203dc8:	01853803          	ld	a6,24(a0)
ffffffffc0203dcc:	7110                	ld	a2,32(a0)
            base = p;
ffffffffc0203dce:	853a                	mv	a0,a4
    prev->next = next;
ffffffffc0203dd0:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc0203dd4:	659c                	ld	a5,8(a1)
ffffffffc0203dd6:	01063023          	sd	a6,0(a2)
ffffffffc0203dda:	a815                	j	ffffffffc0203e0e <default_free_pages+0x112>
    prev->next = next->prev = elm;
ffffffffc0203ddc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0203dde:	f114                	sd	a3,32(a0)
ffffffffc0203de0:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0203de2:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0203de4:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0203de6:	00d70563          	beq	a4,a3,ffffffffc0203df0 <default_free_pages+0xf4>
ffffffffc0203dea:	4805                	li	a6,1
ffffffffc0203dec:	87ba                	mv	a5,a4
ffffffffc0203dee:	bf59                	j	ffffffffc0203d84 <default_free_pages+0x88>
ffffffffc0203df0:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc0203df2:	85be                	mv	a1,a5
    if (le != &free_list) {
ffffffffc0203df4:	00d78d63          	beq	a5,a3,ffffffffc0203e0e <default_free_pages+0x112>
        if (p + p->property == base) {
ffffffffc0203df8:	ff85a603          	lw	a2,-8(a1)
        p = le2page(le, page_link);
ffffffffc0203dfc:	fe858713          	addi	a4,a1,-24
        if (p + p->property == base) {
ffffffffc0203e00:	02061793          	slli	a5,a2,0x20
ffffffffc0203e04:	83e9                	srli	a5,a5,0x1a
ffffffffc0203e06:	97ba                	add	a5,a5,a4
ffffffffc0203e08:	faf509e3          	beq	a0,a5,ffffffffc0203dba <default_free_pages+0xbe>
ffffffffc0203e0c:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0203e0e:	fe878713          	addi	a4,a5,-24
ffffffffc0203e12:	00d78963          	beq	a5,a3,ffffffffc0203e24 <default_free_pages+0x128>
        if (base + base->property == p) {
ffffffffc0203e16:	4910                	lw	a2,16(a0)
ffffffffc0203e18:	02061693          	slli	a3,a2,0x20
ffffffffc0203e1c:	82e9                	srli	a3,a3,0x1a
ffffffffc0203e1e:	96aa                	add	a3,a3,a0
ffffffffc0203e20:	00d70e63          	beq	a4,a3,ffffffffc0203e3c <default_free_pages+0x140>
}
ffffffffc0203e24:	60a2                	ld	ra,8(sp)
ffffffffc0203e26:	0141                	addi	sp,sp,16
ffffffffc0203e28:	8082                	ret
ffffffffc0203e2a:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0203e2c:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0203e30:	e398                	sd	a4,0(a5)
ffffffffc0203e32:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0203e34:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203e36:	ed1c                	sd	a5,24(a0)
}
ffffffffc0203e38:	0141                	addi	sp,sp,16
ffffffffc0203e3a:	8082                	ret
            base->property += p->property;
ffffffffc0203e3c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203e40:	ff078693          	addi	a3,a5,-16
ffffffffc0203e44:	9e39                	addw	a2,a2,a4
ffffffffc0203e46:	c910                	sw	a2,16(a0)
ffffffffc0203e48:	5775                	li	a4,-3
ffffffffc0203e4a:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203e4e:	6398                	ld	a4,0(a5)
ffffffffc0203e50:	679c                	ld	a5,8(a5)
}
ffffffffc0203e52:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0203e54:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203e56:	e398                	sd	a4,0(a5)
ffffffffc0203e58:	0141                	addi	sp,sp,16
ffffffffc0203e5a:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203e5c:	00003697          	auipc	a3,0x3
ffffffffc0203e60:	cc468693          	addi	a3,a3,-828 # ffffffffc0206b20 <commands+0x1ad0>
ffffffffc0203e64:	00002617          	auipc	a2,0x2
ffffffffc0203e68:	b8460613          	addi	a2,a2,-1148 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203e6c:	08300593          	li	a1,131
ffffffffc0203e70:	00003517          	auipc	a0,0x3
ffffffffc0203e74:	9a050513          	addi	a0,a0,-1632 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203e78:	b5efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(n > 0);
ffffffffc0203e7c:	00003697          	auipc	a3,0x3
ffffffffc0203e80:	ccc68693          	addi	a3,a3,-820 # ffffffffc0206b48 <commands+0x1af8>
ffffffffc0203e84:	00002617          	auipc	a2,0x2
ffffffffc0203e88:	b6460613          	addi	a2,a2,-1180 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203e8c:	08000593          	li	a1,128
ffffffffc0203e90:	00003517          	auipc	a0,0x3
ffffffffc0203e94:	98050513          	addi	a0,a0,-1664 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0203e98:	b3efc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0203e9c <default_alloc_pages>:
    assert(n > 0);
ffffffffc0203e9c:	c959                	beqz	a0,ffffffffc0203f32 <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc0203e9e:	00012597          	auipc	a1,0x12
ffffffffc0203ea2:	73a58593          	addi	a1,a1,1850 # ffffffffc02165d8 <free_area>
ffffffffc0203ea6:	0105a803          	lw	a6,16(a1)
ffffffffc0203eaa:	862a                	mv	a2,a0
ffffffffc0203eac:	02081793          	slli	a5,a6,0x20
ffffffffc0203eb0:	9381                	srli	a5,a5,0x20
ffffffffc0203eb2:	00a7ee63          	bltu	a5,a0,ffffffffc0203ece <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0203eb6:	87ae                	mv	a5,a1
ffffffffc0203eb8:	a801                	j	ffffffffc0203ec8 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0203eba:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203ebe:	02071693          	slli	a3,a4,0x20
ffffffffc0203ec2:	9281                	srli	a3,a3,0x20
ffffffffc0203ec4:	00c6f763          	bleu	a2,a3,ffffffffc0203ed2 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0203ec8:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203eca:	feb798e3          	bne	a5,a1,ffffffffc0203eba <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0203ece:	4501                	li	a0,0
}
ffffffffc0203ed0:	8082                	ret
        struct Page *p = le2page(le, page_link);
ffffffffc0203ed2:	fe878513          	addi	a0,a5,-24
    if (page != NULL) {
ffffffffc0203ed6:	dd6d                	beqz	a0,ffffffffc0203ed0 <default_alloc_pages+0x34>
    return listelm->prev;
ffffffffc0203ed8:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203edc:	0087b303          	ld	t1,8(a5)
    prev->next = next;
ffffffffc0203ee0:	00060e1b          	sext.w	t3,a2
ffffffffc0203ee4:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc0203ee8:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0203eec:	02d67863          	bleu	a3,a2,ffffffffc0203f1c <default_alloc_pages+0x80>
            struct Page *p = page + n;
ffffffffc0203ef0:	061a                	slli	a2,a2,0x6
ffffffffc0203ef2:	962a                	add	a2,a2,a0
            p->property = page->property - n;
ffffffffc0203ef4:	41c7073b          	subw	a4,a4,t3
ffffffffc0203ef8:	ca18                	sw	a4,16(a2)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203efa:	00860693          	addi	a3,a2,8
ffffffffc0203efe:	4709                	li	a4,2
ffffffffc0203f00:	40e6b02f          	amoor.d	zero,a4,(a3)
    __list_add(elm, listelm, listelm->next);
ffffffffc0203f04:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0203f08:	01860693          	addi	a3,a2,24
    prev->next = next->prev = elm;
ffffffffc0203f0c:	0105a803          	lw	a6,16(a1)
ffffffffc0203f10:	e314                	sd	a3,0(a4)
ffffffffc0203f12:	00d8b423          	sd	a3,8(a7)
    elm->next = next;
ffffffffc0203f16:	f218                	sd	a4,32(a2)
    elm->prev = prev;
ffffffffc0203f18:	01163c23          	sd	a7,24(a2)
        nr_free -= n;
ffffffffc0203f1c:	41c8083b          	subw	a6,a6,t3
ffffffffc0203f20:	00012717          	auipc	a4,0x12
ffffffffc0203f24:	6d072423          	sw	a6,1736(a4) # ffffffffc02165e8 <free_area+0x10>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203f28:	5775                	li	a4,-3
ffffffffc0203f2a:	17c1                	addi	a5,a5,-16
ffffffffc0203f2c:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0203f30:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0203f32:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0203f34:	00003697          	auipc	a3,0x3
ffffffffc0203f38:	c1468693          	addi	a3,a3,-1004 # ffffffffc0206b48 <commands+0x1af8>
ffffffffc0203f3c:	00002617          	auipc	a2,0x2
ffffffffc0203f40:	aac60613          	addi	a2,a2,-1364 # ffffffffc02059e8 <commands+0x998>
ffffffffc0203f44:	06200593          	li	a1,98
ffffffffc0203f48:	00003517          	auipc	a0,0x3
ffffffffc0203f4c:	8c850513          	addi	a0,a0,-1848 # ffffffffc0206810 <commands+0x17c0>
default_alloc_pages(size_t n) {
ffffffffc0203f50:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203f52:	a84fc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0203f56 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0203f56:	1141                	addi	sp,sp,-16
ffffffffc0203f58:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203f5a:	c1ed                	beqz	a1,ffffffffc020403c <default_init_memmap+0xe6>
    for (; p != base + n; p ++) {
ffffffffc0203f5c:	00659693          	slli	a3,a1,0x6
ffffffffc0203f60:	96aa                	add	a3,a3,a0
ffffffffc0203f62:	02d50463          	beq	a0,a3,ffffffffc0203f8a <default_init_memmap+0x34>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0203f66:	6518                	ld	a4,8(a0)
        assert(PageReserved(p));
ffffffffc0203f68:	87aa                	mv	a5,a0
ffffffffc0203f6a:	8b05                	andi	a4,a4,1
ffffffffc0203f6c:	e709                	bnez	a4,ffffffffc0203f76 <default_init_memmap+0x20>
ffffffffc0203f6e:	a07d                	j	ffffffffc020401c <default_init_memmap+0xc6>
ffffffffc0203f70:	6798                	ld	a4,8(a5)
ffffffffc0203f72:	8b05                	andi	a4,a4,1
ffffffffc0203f74:	c745                	beqz	a4,ffffffffc020401c <default_init_memmap+0xc6>
        p->flags = p->property = 0;
ffffffffc0203f76:	0007a823          	sw	zero,16(a5)
ffffffffc0203f7a:	0007b423          	sd	zero,8(a5)
ffffffffc0203f7e:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0203f82:	04078793          	addi	a5,a5,64
ffffffffc0203f86:	fed795e3          	bne	a5,a3,ffffffffc0203f70 <default_init_memmap+0x1a>
    base->property = n;
ffffffffc0203f8a:	2581                	sext.w	a1,a1
ffffffffc0203f8c:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203f8e:	4789                	li	a5,2
ffffffffc0203f90:	00850713          	addi	a4,a0,8
ffffffffc0203f94:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0203f98:	00012697          	auipc	a3,0x12
ffffffffc0203f9c:	64068693          	addi	a3,a3,1600 # ffffffffc02165d8 <free_area>
ffffffffc0203fa0:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0203fa2:	669c                	ld	a5,8(a3)
ffffffffc0203fa4:	9db9                	addw	a1,a1,a4
ffffffffc0203fa6:	00012717          	auipc	a4,0x12
ffffffffc0203faa:	64b72123          	sw	a1,1602(a4) # ffffffffc02165e8 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc0203fae:	04d78a63          	beq	a5,a3,ffffffffc0204002 <default_init_memmap+0xac>
            struct Page* page = le2page(le, page_link);
ffffffffc0203fb2:	fe878713          	addi	a4,a5,-24
ffffffffc0203fb6:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0203fb8:	4801                	li	a6,0
ffffffffc0203fba:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0203fbe:	00e56a63          	bltu	a0,a4,ffffffffc0203fd2 <default_init_memmap+0x7c>
    return listelm->next;
ffffffffc0203fc2:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0203fc4:	02d70563          	beq	a4,a3,ffffffffc0203fee <default_init_memmap+0x98>
        while ((le = list_next(le)) != &free_list) {
ffffffffc0203fc8:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0203fca:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0203fce:	fee57ae3          	bleu	a4,a0,ffffffffc0203fc2 <default_init_memmap+0x6c>
ffffffffc0203fd2:	00080663          	beqz	a6,ffffffffc0203fde <default_init_memmap+0x88>
ffffffffc0203fd6:	00012717          	auipc	a4,0x12
ffffffffc0203fda:	60b73123          	sd	a1,1538(a4) # ffffffffc02165d8 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0203fde:	6398                	ld	a4,0(a5)
}
ffffffffc0203fe0:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0203fe2:	e390                	sd	a2,0(a5)
ffffffffc0203fe4:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0203fe6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203fe8:	ed18                	sd	a4,24(a0)
ffffffffc0203fea:	0141                	addi	sp,sp,16
ffffffffc0203fec:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0203fee:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0203ff0:	f114                	sd	a3,32(a0)
ffffffffc0203ff2:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0203ff4:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0203ff6:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0203ff8:	00d70e63          	beq	a4,a3,ffffffffc0204014 <default_init_memmap+0xbe>
ffffffffc0203ffc:	4805                	li	a6,1
ffffffffc0203ffe:	87ba                	mv	a5,a4
ffffffffc0204000:	b7e9                	j	ffffffffc0203fca <default_init_memmap+0x74>
}
ffffffffc0204002:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0204004:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0204008:	e398                	sd	a4,0(a5)
ffffffffc020400a:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020400c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020400e:	ed1c                	sd	a5,24(a0)
}
ffffffffc0204010:	0141                	addi	sp,sp,16
ffffffffc0204012:	8082                	ret
ffffffffc0204014:	60a2                	ld	ra,8(sp)
ffffffffc0204016:	e290                	sd	a2,0(a3)
ffffffffc0204018:	0141                	addi	sp,sp,16
ffffffffc020401a:	8082                	ret
        assert(PageReserved(p));
ffffffffc020401c:	00003697          	auipc	a3,0x3
ffffffffc0204020:	b3468693          	addi	a3,a3,-1228 # ffffffffc0206b50 <commands+0x1b00>
ffffffffc0204024:	00002617          	auipc	a2,0x2
ffffffffc0204028:	9c460613          	addi	a2,a2,-1596 # ffffffffc02059e8 <commands+0x998>
ffffffffc020402c:	04900593          	li	a1,73
ffffffffc0204030:	00002517          	auipc	a0,0x2
ffffffffc0204034:	7e050513          	addi	a0,a0,2016 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0204038:	99efc0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(n > 0);
ffffffffc020403c:	00003697          	auipc	a3,0x3
ffffffffc0204040:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0206b48 <commands+0x1af8>
ffffffffc0204044:	00002617          	auipc	a2,0x2
ffffffffc0204048:	9a460613          	addi	a2,a2,-1628 # ffffffffc02059e8 <commands+0x998>
ffffffffc020404c:	04600593          	li	a1,70
ffffffffc0204050:	00002517          	auipc	a0,0x2
ffffffffc0204054:	7c050513          	addi	a0,a0,1984 # ffffffffc0206810 <commands+0x17c0>
ffffffffc0204058:	97efc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc020405c <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc020405c:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc020405e:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0204060:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0204062:	c50fc0ef          	jal	ra,ffffffffc02004b2 <ide_device_valid>
ffffffffc0204066:	cd01                	beqz	a0,ffffffffc020407e <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204068:	4505                	li	a0,1
ffffffffc020406a:	c4efc0ef          	jal	ra,ffffffffc02004b8 <ide_device_size>
}
ffffffffc020406e:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204070:	810d                	srli	a0,a0,0x3
ffffffffc0204072:	00012797          	auipc	a5,0x12
ffffffffc0204076:	52a7b323          	sd	a0,1318(a5) # ffffffffc0216598 <max_swap_offset>
}
ffffffffc020407a:	0141                	addi	sp,sp,16
ffffffffc020407c:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc020407e:	00003617          	auipc	a2,0x3
ffffffffc0204082:	b3260613          	addi	a2,a2,-1230 # ffffffffc0206bb0 <default_pmm_manager+0x50>
ffffffffc0204086:	45b5                	li	a1,13
ffffffffc0204088:	00003517          	auipc	a0,0x3
ffffffffc020408c:	b4850513          	addi	a0,a0,-1208 # ffffffffc0206bd0 <default_pmm_manager+0x70>
ffffffffc0204090:	946fc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0204094 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0204094:	1141                	addi	sp,sp,-16
ffffffffc0204096:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204098:	00855793          	srli	a5,a0,0x8
ffffffffc020409c:	cfb9                	beqz	a5,ffffffffc02040fa <swapfs_read+0x66>
ffffffffc020409e:	00012717          	auipc	a4,0x12
ffffffffc02040a2:	4fa70713          	addi	a4,a4,1274 # ffffffffc0216598 <max_swap_offset>
ffffffffc02040a6:	6318                	ld	a4,0(a4)
ffffffffc02040a8:	04e7f963          	bleu	a4,a5,ffffffffc02040fa <swapfs_read+0x66>
    return page - pages + nbase;
ffffffffc02040ac:	00012717          	auipc	a4,0x12
ffffffffc02040b0:	44470713          	addi	a4,a4,1092 # ffffffffc02164f0 <pages>
ffffffffc02040b4:	6310                	ld	a2,0(a4)
ffffffffc02040b6:	00003717          	auipc	a4,0x3
ffffffffc02040ba:	f4a70713          	addi	a4,a4,-182 # ffffffffc0207000 <nbase>
    return KADDR(page2pa(page));
ffffffffc02040be:	00012697          	auipc	a3,0x12
ffffffffc02040c2:	3ca68693          	addi	a3,a3,970 # ffffffffc0216488 <npage>
    return page - pages + nbase;
ffffffffc02040c6:	40c58633          	sub	a2,a1,a2
ffffffffc02040ca:	630c                	ld	a1,0(a4)
ffffffffc02040cc:	8619                	srai	a2,a2,0x6
    return KADDR(page2pa(page));
ffffffffc02040ce:	577d                	li	a4,-1
ffffffffc02040d0:	6294                	ld	a3,0(a3)
    return page - pages + nbase;
ffffffffc02040d2:	962e                	add	a2,a2,a1
    return KADDR(page2pa(page));
ffffffffc02040d4:	8331                	srli	a4,a4,0xc
ffffffffc02040d6:	8f71                	and	a4,a4,a2
ffffffffc02040d8:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc02040dc:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc02040de:	02d77a63          	bleu	a3,a4,ffffffffc0204112 <swapfs_read+0x7e>
ffffffffc02040e2:	00012797          	auipc	a5,0x12
ffffffffc02040e6:	3fe78793          	addi	a5,a5,1022 # ffffffffc02164e0 <va_pa_offset>
ffffffffc02040ea:	639c                	ld	a5,0(a5)
}
ffffffffc02040ec:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02040ee:	46a1                	li	a3,8
ffffffffc02040f0:	963e                	add	a2,a2,a5
ffffffffc02040f2:	4505                	li	a0,1
}
ffffffffc02040f4:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc02040f6:	bc8fc06f          	j	ffffffffc02004be <ide_read_secs>
ffffffffc02040fa:	86aa                	mv	a3,a0
ffffffffc02040fc:	00003617          	auipc	a2,0x3
ffffffffc0204100:	aec60613          	addi	a2,a2,-1300 # ffffffffc0206be8 <default_pmm_manager+0x88>
ffffffffc0204104:	45d1                	li	a1,20
ffffffffc0204106:	00003517          	auipc	a0,0x3
ffffffffc020410a:	aca50513          	addi	a0,a0,-1334 # ffffffffc0206bd0 <default_pmm_manager+0x70>
ffffffffc020410e:	8c8fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc0204112:	86b2                	mv	a3,a2
ffffffffc0204114:	06a00593          	li	a1,106
ffffffffc0204118:	00001617          	auipc	a2,0x1
ffffffffc020411c:	77860613          	addi	a2,a2,1912 # ffffffffc0205890 <commands+0x840>
ffffffffc0204120:	00001517          	auipc	a0,0x1
ffffffffc0204124:	7c850513          	addi	a0,a0,1992 # ffffffffc02058e8 <commands+0x898>
ffffffffc0204128:	8aefc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc020412c <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc020412c:	1141                	addi	sp,sp,-16
ffffffffc020412e:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204130:	00855793          	srli	a5,a0,0x8
ffffffffc0204134:	cfb9                	beqz	a5,ffffffffc0204192 <swapfs_write+0x66>
ffffffffc0204136:	00012717          	auipc	a4,0x12
ffffffffc020413a:	46270713          	addi	a4,a4,1122 # ffffffffc0216598 <max_swap_offset>
ffffffffc020413e:	6318                	ld	a4,0(a4)
ffffffffc0204140:	04e7f963          	bleu	a4,a5,ffffffffc0204192 <swapfs_write+0x66>
    return page - pages + nbase;
ffffffffc0204144:	00012717          	auipc	a4,0x12
ffffffffc0204148:	3ac70713          	addi	a4,a4,940 # ffffffffc02164f0 <pages>
ffffffffc020414c:	6310                	ld	a2,0(a4)
ffffffffc020414e:	00003717          	auipc	a4,0x3
ffffffffc0204152:	eb270713          	addi	a4,a4,-334 # ffffffffc0207000 <nbase>
    return KADDR(page2pa(page));
ffffffffc0204156:	00012697          	auipc	a3,0x12
ffffffffc020415a:	33268693          	addi	a3,a3,818 # ffffffffc0216488 <npage>
    return page - pages + nbase;
ffffffffc020415e:	40c58633          	sub	a2,a1,a2
ffffffffc0204162:	630c                	ld	a1,0(a4)
ffffffffc0204164:	8619                	srai	a2,a2,0x6
    return KADDR(page2pa(page));
ffffffffc0204166:	577d                	li	a4,-1
ffffffffc0204168:	6294                	ld	a3,0(a3)
    return page - pages + nbase;
ffffffffc020416a:	962e                	add	a2,a2,a1
    return KADDR(page2pa(page));
ffffffffc020416c:	8331                	srli	a4,a4,0xc
ffffffffc020416e:	8f71                	and	a4,a4,a2
ffffffffc0204170:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204174:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0204176:	02d77a63          	bleu	a3,a4,ffffffffc02041aa <swapfs_write+0x7e>
ffffffffc020417a:	00012797          	auipc	a5,0x12
ffffffffc020417e:	36678793          	addi	a5,a5,870 # ffffffffc02164e0 <va_pa_offset>
ffffffffc0204182:	639c                	ld	a5,0(a5)
}
ffffffffc0204184:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204186:	46a1                	li	a3,8
ffffffffc0204188:	963e                	add	a2,a2,a5
ffffffffc020418a:	4505                	li	a0,1
}
ffffffffc020418c:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc020418e:	b54fc06f          	j	ffffffffc02004e2 <ide_write_secs>
ffffffffc0204192:	86aa                	mv	a3,a0
ffffffffc0204194:	00003617          	auipc	a2,0x3
ffffffffc0204198:	a5460613          	addi	a2,a2,-1452 # ffffffffc0206be8 <default_pmm_manager+0x88>
ffffffffc020419c:	45e5                	li	a1,25
ffffffffc020419e:	00003517          	auipc	a0,0x3
ffffffffc02041a2:	a3250513          	addi	a0,a0,-1486 # ffffffffc0206bd0 <default_pmm_manager+0x70>
ffffffffc02041a6:	830fc0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc02041aa:	86b2                	mv	a3,a2
ffffffffc02041ac:	06a00593          	li	a1,106
ffffffffc02041b0:	00001617          	auipc	a2,0x1
ffffffffc02041b4:	6e060613          	addi	a2,a2,1760 # ffffffffc0205890 <commands+0x840>
ffffffffc02041b8:	00001517          	auipc	a0,0x1
ffffffffc02041bc:	73050513          	addi	a0,a0,1840 # ffffffffc02058e8 <commands+0x898>
ffffffffc02041c0:	816fc0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc02041c4 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc02041c4:	8526                	mv	a0,s1
	jalr s0
ffffffffc02041c6:	9402                	jalr	s0

	jal do_exit
ffffffffc02041c8:	532000ef          	jal	ra,ffffffffc02046fa <do_exit>

ffffffffc02041cc <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02041cc:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02041d0:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02041d4:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02041d6:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02041d8:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02041dc:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02041e0:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02041e4:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02041e8:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02041ec:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02041f0:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02041f4:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02041f8:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02041fc:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204200:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204204:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204208:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020420a:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020420c:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204210:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204214:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0204218:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020421c:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204220:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204224:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204228:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020422c:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204230:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204234:	8082                	ret

ffffffffc0204236 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc0204236:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204238:	0e800513          	li	a0,232
alloc_proc(void) {
ffffffffc020423c:	e022                	sd	s0,0(sp)
ffffffffc020423e:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204240:	fccfe0ef          	jal	ra,ffffffffc0202a0c <kmalloc>
ffffffffc0204244:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc0204246:	c529                	beqz	a0,ffffffffc0204290 <alloc_proc+0x5a>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT; //未初始化
ffffffffc0204248:	57fd                	li	a5,-1
ffffffffc020424a:	1782                	slli	a5,a5,0x20
ffffffffc020424c:	e11c                	sd	a5,0(a0)
        proc->runs = 0; //进程的运行次数，未开始运行
        proc->kstack = 0; //进程的内核栈地址
        proc->need_resched = 0; //是否需要重新调度，0表示不需要
        proc->parent = NULL; //父进程
        proc->mm = NULL; //进程内存管理结构，未分配地址空间
        memset(&(proc->context), 0, sizeof(struct context)); //进程上下文
ffffffffc020424e:	07000613          	li	a2,112
ffffffffc0204252:	4581                	li	a1,0
        proc->runs = 0; //进程的运行次数，未开始运行
ffffffffc0204254:	00052423          	sw	zero,8(a0)
        proc->kstack = 0; //进程的内核栈地址
ffffffffc0204258:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0; //是否需要重新调度，0表示不需要
ffffffffc020425c:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL; //父进程
ffffffffc0204260:	02053023          	sd	zero,32(a0)
        proc->mm = NULL; //进程内存管理结构，未分配地址空间
ffffffffc0204264:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context)); //进程上下文
ffffffffc0204268:	03050513          	addi	a0,a0,48
ffffffffc020426c:	025000ef          	jal	ra,ffffffffc0204a90 <memset>
        proc->tf = NULL;//指向中断帧的指针
        proc->cr3 = boot_cr3;//存储进程的页目录表基址
ffffffffc0204270:	00012797          	auipc	a5,0x12
ffffffffc0204274:	27878793          	addi	a5,a5,632 # ffffffffc02164e8 <boot_cr3>
ffffffffc0204278:	639c                	ld	a5,0(a5)
        proc->tf = NULL;//指向中断帧的指针
ffffffffc020427a:	0a043023          	sd	zero,160(s0)
        //初始化为ucore启动时建立好的内核虚拟空间的页目录表首地址`boot_cr3`（在`kern/mm/pmm.c`的`pmm_init`函数中初始化）
        proc->flags = 0; //进程标志位
ffffffffc020427e:	0a042823          	sw	zero,176(s0)
        proc->cr3 = boot_cr3;//存储进程的页目录表基址
ffffffffc0204282:	f45c                	sd	a5,168(s0)
        memset(proc->name, 0, PROC_NAME_LEN);//进程名
ffffffffc0204284:	463d                	li	a2,15
ffffffffc0204286:	4581                	li	a1,0
ffffffffc0204288:	0b440513          	addi	a0,s0,180
ffffffffc020428c:	005000ef          	jal	ra,ffffffffc0204a90 <memset>

    }
    return proc;
}
ffffffffc0204290:	8522                	mv	a0,s0
ffffffffc0204292:	60a2                	ld	ra,8(sp)
ffffffffc0204294:	6402                	ld	s0,0(sp)
ffffffffc0204296:	0141                	addi	sp,sp,16
ffffffffc0204298:	8082                	ret

ffffffffc020429a <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc020429a:	00012797          	auipc	a5,0x12
ffffffffc020429e:	21678793          	addi	a5,a5,534 # ffffffffc02164b0 <current>
ffffffffc02042a2:	639c                	ld	a5,0(a5)
ffffffffc02042a4:	73c8                	ld	a0,160(a5)
ffffffffc02042a6:	8f3fc06f          	j	ffffffffc0200b98 <forkrets>

ffffffffc02042aa <set_proc_name>:
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc02042aa:	1101                	addi	sp,sp,-32
ffffffffc02042ac:	e822                	sd	s0,16(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02042ae:	0b450413          	addi	s0,a0,180
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc02042b2:	e426                	sd	s1,8(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02042b4:	4641                	li	a2,16
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc02042b6:	84ae                	mv	s1,a1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02042b8:	8522                	mv	a0,s0
ffffffffc02042ba:	4581                	li	a1,0
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc02042bc:	ec06                	sd	ra,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02042be:	7d2000ef          	jal	ra,ffffffffc0204a90 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02042c2:	8522                	mv	a0,s0
}
ffffffffc02042c4:	6442                	ld	s0,16(sp)
ffffffffc02042c6:	60e2                	ld	ra,24(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02042c8:	85a6                	mv	a1,s1
}
ffffffffc02042ca:	64a2                	ld	s1,8(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02042cc:	463d                	li	a2,15
}
ffffffffc02042ce:	6105                	addi	sp,sp,32
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02042d0:	7d20006f          	j	ffffffffc0204aa2 <memcpy>

ffffffffc02042d4 <get_proc_name>:
get_proc_name(struct proc_struct *proc) {
ffffffffc02042d4:	1101                	addi	sp,sp,-32
ffffffffc02042d6:	e822                	sd	s0,16(sp)
    memset(name, 0, sizeof(name));
ffffffffc02042d8:	00012417          	auipc	s0,0x12
ffffffffc02042dc:	18840413          	addi	s0,s0,392 # ffffffffc0216460 <name.1565>
get_proc_name(struct proc_struct *proc) {
ffffffffc02042e0:	e426                	sd	s1,8(sp)
    memset(name, 0, sizeof(name));
ffffffffc02042e2:	4641                	li	a2,16
get_proc_name(struct proc_struct *proc) {
ffffffffc02042e4:	84aa                	mv	s1,a0
    memset(name, 0, sizeof(name));
ffffffffc02042e6:	4581                	li	a1,0
ffffffffc02042e8:	8522                	mv	a0,s0
get_proc_name(struct proc_struct *proc) {
ffffffffc02042ea:	ec06                	sd	ra,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc02042ec:	7a4000ef          	jal	ra,ffffffffc0204a90 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02042f0:	8522                	mv	a0,s0
}
ffffffffc02042f2:	6442                	ld	s0,16(sp)
ffffffffc02042f4:	60e2                	ld	ra,24(sp)
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02042f6:	0b448593          	addi	a1,s1,180
}
ffffffffc02042fa:	64a2                	ld	s1,8(sp)
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02042fc:	463d                	li	a2,15
}
ffffffffc02042fe:	6105                	addi	sp,sp,32
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc0204300:	7a20006f          	j	ffffffffc0204aa2 <memcpy>

ffffffffc0204304 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204304:	00012797          	auipc	a5,0x12
ffffffffc0204308:	1ac78793          	addi	a5,a5,428 # ffffffffc02164b0 <current>
ffffffffc020430c:	639c                	ld	a5,0(a5)
init_main(void *arg) {
ffffffffc020430e:	1101                	addi	sp,sp,-32
ffffffffc0204310:	e426                	sd	s1,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204312:	43c4                	lw	s1,4(a5)
init_main(void *arg) {
ffffffffc0204314:	e822                	sd	s0,16(sp)
ffffffffc0204316:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0204318:	853e                	mv	a0,a5
init_main(void *arg) {
ffffffffc020431a:	ec06                	sd	ra,24(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020431c:	fb9ff0ef          	jal	ra,ffffffffc02042d4 <get_proc_name>
ffffffffc0204320:	862a                	mv	a2,a0
ffffffffc0204322:	85a6                	mv	a1,s1
ffffffffc0204324:	00003517          	auipc	a0,0x3
ffffffffc0204328:	92c50513          	addi	a0,a0,-1748 # ffffffffc0206c50 <default_pmm_manager+0xf0>
ffffffffc020432c:	da5fb0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc0204330:	85a2                	mv	a1,s0
ffffffffc0204332:	00003517          	auipc	a0,0x3
ffffffffc0204336:	94650513          	addi	a0,a0,-1722 # ffffffffc0206c78 <default_pmm_manager+0x118>
ffffffffc020433a:	d97fb0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc020433e:	00003517          	auipc	a0,0x3
ffffffffc0204342:	94a50513          	addi	a0,a0,-1718 # ffffffffc0206c88 <default_pmm_manager+0x128>
ffffffffc0204346:	d8bfb0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    return 0;
}
ffffffffc020434a:	60e2                	ld	ra,24(sp)
ffffffffc020434c:	6442                	ld	s0,16(sp)
ffffffffc020434e:	64a2                	ld	s1,8(sp)
ffffffffc0204350:	4501                	li	a0,0
ffffffffc0204352:	6105                	addi	sp,sp,32
ffffffffc0204354:	8082                	ret

ffffffffc0204356 <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc0204356:	1101                	addi	sp,sp,-32
    if (proc != current) {
ffffffffc0204358:	00012797          	auipc	a5,0x12
ffffffffc020435c:	15878793          	addi	a5,a5,344 # ffffffffc02164b0 <current>
proc_run(struct proc_struct *proc) {
ffffffffc0204360:	e426                	sd	s1,8(sp)
    if (proc != current) {
ffffffffc0204362:	6384                	ld	s1,0(a5)
proc_run(struct proc_struct *proc) {
ffffffffc0204364:	ec06                	sd	ra,24(sp)
ffffffffc0204366:	e822                	sd	s0,16(sp)
ffffffffc0204368:	e04a                	sd	s2,0(sp)
    if (proc != current) {
ffffffffc020436a:	02a48c63          	beq	s1,a0,ffffffffc02043a2 <proc_run+0x4c>
ffffffffc020436e:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204370:	100027f3          	csrr	a5,sstatus
ffffffffc0204374:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204376:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204378:	e3b1                	bnez	a5,ffffffffc02043bc <proc_run+0x66>
        lcr3(next->cr3); 
ffffffffc020437a:	745c                	ld	a5,168(s0)
        current = proc; //切换
ffffffffc020437c:	00012717          	auipc	a4,0x12
ffffffffc0204380:	12873a23          	sd	s0,308(a4) # ffffffffc02164b0 <current>

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned int cr3) {
    write_csr(sptbr, SATP32_MODE | (cr3 >> RISCV_PGSHIFT));
ffffffffc0204384:	80000737          	lui	a4,0x80000
ffffffffc0204388:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc020438c:	8fd9                	or	a5,a5,a4
ffffffffc020438e:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));
ffffffffc0204392:	03040593          	addi	a1,s0,48
ffffffffc0204396:	03048513          	addi	a0,s1,48
ffffffffc020439a:	e33ff0ef          	jal	ra,ffffffffc02041cc <switch_to>
    if (flag) {
ffffffffc020439e:	00091863          	bnez	s2,ffffffffc02043ae <proc_run+0x58>
}
ffffffffc02043a2:	60e2                	ld	ra,24(sp)
ffffffffc02043a4:	6442                	ld	s0,16(sp)
ffffffffc02043a6:	64a2                	ld	s1,8(sp)
ffffffffc02043a8:	6902                	ld	s2,0(sp)
ffffffffc02043aa:	6105                	addi	sp,sp,32
ffffffffc02043ac:	8082                	ret
ffffffffc02043ae:	6442                	ld	s0,16(sp)
ffffffffc02043b0:	60e2                	ld	ra,24(sp)
ffffffffc02043b2:	64a2                	ld	s1,8(sp)
ffffffffc02043b4:	6902                	ld	s2,0(sp)
ffffffffc02043b6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02043b8:	a1cfc06f          	j	ffffffffc02005d4 <intr_enable>
        intr_disable();
ffffffffc02043bc:	a1efc0ef          	jal	ra,ffffffffc02005da <intr_disable>
        return 1;
ffffffffc02043c0:	4905                	li	s2,1
ffffffffc02043c2:	bf65                	j	ffffffffc020437a <proc_run+0x24>

ffffffffc02043c4 <find_proc>:
    if (0 < pid && pid < MAX_PID) {
ffffffffc02043c4:	0005071b          	sext.w	a4,a0
ffffffffc02043c8:	6789                	lui	a5,0x2
ffffffffc02043ca:	fff7069b          	addiw	a3,a4,-1
ffffffffc02043ce:	17f9                	addi	a5,a5,-2
ffffffffc02043d0:	04d7e063          	bltu	a5,a3,ffffffffc0204410 <find_proc+0x4c>
find_proc(int pid) {
ffffffffc02043d4:	1141                	addi	sp,sp,-16
ffffffffc02043d6:	e022                	sd	s0,0(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02043d8:	45a9                	li	a1,10
ffffffffc02043da:	842a                	mv	s0,a0
ffffffffc02043dc:	853a                	mv	a0,a4
find_proc(int pid) {
ffffffffc02043de:	e406                	sd	ra,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02043e0:	303000ef          	jal	ra,ffffffffc0204ee2 <hash32>
ffffffffc02043e4:	02051693          	slli	a3,a0,0x20
ffffffffc02043e8:	82f1                	srli	a3,a3,0x1c
ffffffffc02043ea:	0000e517          	auipc	a0,0xe
ffffffffc02043ee:	07650513          	addi	a0,a0,118 # ffffffffc0212460 <hash_list>
ffffffffc02043f2:	96aa                	add	a3,a3,a0
ffffffffc02043f4:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc02043f6:	a029                	j	ffffffffc0204400 <find_proc+0x3c>
            if (proc->pid == pid) {
ffffffffc02043f8:	f2c7a703          	lw	a4,-212(a5) # 1f2c <BASE_ADDRESS-0xffffffffc01fe0d4>
ffffffffc02043fc:	00870c63          	beq	a4,s0,ffffffffc0204414 <find_proc+0x50>
    return listelm->next;
ffffffffc0204400:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0204402:	fef69be3          	bne	a3,a5,ffffffffc02043f8 <find_proc+0x34>
}
ffffffffc0204406:	60a2                	ld	ra,8(sp)
ffffffffc0204408:	6402                	ld	s0,0(sp)
    return NULL;
ffffffffc020440a:	4501                	li	a0,0
}
ffffffffc020440c:	0141                	addi	sp,sp,16
ffffffffc020440e:	8082                	ret
    return NULL;
ffffffffc0204410:	4501                	li	a0,0
}
ffffffffc0204412:	8082                	ret
ffffffffc0204414:	60a2                	ld	ra,8(sp)
ffffffffc0204416:	6402                	ld	s0,0(sp)
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204418:	f2878513          	addi	a0,a5,-216
}
ffffffffc020441c:	0141                	addi	sp,sp,16
ffffffffc020441e:	8082                	ret

ffffffffc0204420 <do_fork>:
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0204420:	7179                	addi	sp,sp,-48
ffffffffc0204422:	e84a                	sd	s2,16(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0204424:	00012917          	auipc	s2,0x12
ffffffffc0204428:	0a490913          	addi	s2,s2,164 # ffffffffc02164c8 <nr_process>
ffffffffc020442c:	00092703          	lw	a4,0(s2)
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0204430:	f406                	sd	ra,40(sp)
ffffffffc0204432:	f022                	sd	s0,32(sp)
ffffffffc0204434:	ec26                	sd	s1,24(sp)
ffffffffc0204436:	e44e                	sd	s3,8(sp)
ffffffffc0204438:	e052                	sd	s4,0(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc020443a:	6785                	lui	a5,0x1
ffffffffc020443c:	22f75763          	ble	a5,a4,ffffffffc020466a <do_fork+0x24a>
ffffffffc0204440:	89ae                	mv	s3,a1
ffffffffc0204442:	84b2                	mv	s1,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0204444:	df3ff0ef          	jal	ra,ffffffffc0204236 <alloc_proc>
ffffffffc0204448:	842a                	mv	s0,a0
ffffffffc020444a:	22050263          	beqz	a0,ffffffffc020466e <do_fork+0x24e>
    proc->parent = current;//新创建的进程的父进程指向当前进程
ffffffffc020444e:	00012a17          	auipc	s4,0x12
ffffffffc0204452:	062a0a13          	addi	s4,s4,98 # ffffffffc02164b0 <current>
ffffffffc0204456:	000a3783          	ld	a5,0(s4)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020445a:	4509                	li	a0,2
    proc->parent = current;//新创建的进程的父进程指向当前进程
ffffffffc020445c:	f01c                	sd	a5,32(s0)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020445e:	f5cfc0ef          	jal	ra,ffffffffc0200bba <alloc_pages>
    if (page != NULL) {
ffffffffc0204462:	1e050f63          	beqz	a0,ffffffffc0204660 <do_fork+0x240>
    return page - pages + nbase;
ffffffffc0204466:	00012797          	auipc	a5,0x12
ffffffffc020446a:	08a78793          	addi	a5,a5,138 # ffffffffc02164f0 <pages>
ffffffffc020446e:	6394                	ld	a3,0(a5)
ffffffffc0204470:	00003797          	auipc	a5,0x3
ffffffffc0204474:	b9078793          	addi	a5,a5,-1136 # ffffffffc0207000 <nbase>
    return KADDR(page2pa(page));
ffffffffc0204478:	00012717          	auipc	a4,0x12
ffffffffc020447c:	01070713          	addi	a4,a4,16 # ffffffffc0216488 <npage>
    return page - pages + nbase;
ffffffffc0204480:	40d506b3          	sub	a3,a0,a3
ffffffffc0204484:	6388                	ld	a0,0(a5)
ffffffffc0204486:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204488:	57fd                	li	a5,-1
ffffffffc020448a:	6318                	ld	a4,0(a4)
    return page - pages + nbase;
ffffffffc020448c:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc020448e:	83b1                	srli	a5,a5,0xc
ffffffffc0204490:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204492:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204494:	1ee7ff63          	bleu	a4,a5,ffffffffc0204692 <do_fork+0x272>
    assert(current->mm == NULL);
ffffffffc0204498:	000a3783          	ld	a5,0(s4)
ffffffffc020449c:	00012717          	auipc	a4,0x12
ffffffffc02044a0:	04470713          	addi	a4,a4,68 # ffffffffc02164e0 <va_pa_offset>
ffffffffc02044a4:	6318                	ld	a4,0(a4)
ffffffffc02044a6:	779c                	ld	a5,40(a5)
ffffffffc02044a8:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02044aa:	e814                	sd	a3,16(s0)
    assert(current->mm == NULL);
ffffffffc02044ac:	1c079363          	bnez	a5,ffffffffc0204672 <do_fork+0x252>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02044b0:	6789                	lui	a5,0x2
ffffffffc02044b2:	ee078793          	addi	a5,a5,-288 # 1ee0 <BASE_ADDRESS-0xffffffffc01fe120>
ffffffffc02044b6:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02044b8:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02044ba:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc02044bc:	87b6                	mv	a5,a3
ffffffffc02044be:	12048893          	addi	a7,s1,288
ffffffffc02044c2:	00063803          	ld	a6,0(a2)
ffffffffc02044c6:	6608                	ld	a0,8(a2)
ffffffffc02044c8:	6a0c                	ld	a1,16(a2)
ffffffffc02044ca:	6e18                	ld	a4,24(a2)
ffffffffc02044cc:	0107b023          	sd	a6,0(a5)
ffffffffc02044d0:	e788                	sd	a0,8(a5)
ffffffffc02044d2:	eb8c                	sd	a1,16(a5)
ffffffffc02044d4:	ef98                	sd	a4,24(a5)
ffffffffc02044d6:	02060613          	addi	a2,a2,32
ffffffffc02044da:	02078793          	addi	a5,a5,32
ffffffffc02044de:	ff1612e3          	bne	a2,a7,ffffffffc02044c2 <do_fork+0xa2>
    proc->tf->gpr.a0 = 0;
ffffffffc02044e2:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02044e6:	10098e63          	beqz	s3,ffffffffc0204602 <do_fork+0x1e2>
ffffffffc02044ea:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02044ee:	00000797          	auipc	a5,0x0
ffffffffc02044f2:	dac78793          	addi	a5,a5,-596 # ffffffffc020429a <forkret>
ffffffffc02044f6:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02044f8:	fc14                	sd	a3,56(s0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02044fa:	100027f3          	csrr	a5,sstatus
ffffffffc02044fe:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204500:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204502:	10079f63          	bnez	a5,ffffffffc0204620 <do_fork+0x200>
    if (++ last_pid >= MAX_PID) {
ffffffffc0204506:	00007797          	auipc	a5,0x7
ffffffffc020450a:	b5278793          	addi	a5,a5,-1198 # ffffffffc020b058 <last_pid.1575>
ffffffffc020450e:	439c                	lw	a5,0(a5)
ffffffffc0204510:	6709                	lui	a4,0x2
ffffffffc0204512:	0017851b          	addiw	a0,a5,1
ffffffffc0204516:	00007697          	auipc	a3,0x7
ffffffffc020451a:	b4a6a123          	sw	a0,-1214(a3) # ffffffffc020b058 <last_pid.1575>
ffffffffc020451e:	12e55263          	ble	a4,a0,ffffffffc0204642 <do_fork+0x222>
    if (last_pid >= next_safe) {
ffffffffc0204522:	00007797          	auipc	a5,0x7
ffffffffc0204526:	b3a78793          	addi	a5,a5,-1222 # ffffffffc020b05c <next_safe.1574>
ffffffffc020452a:	439c                	lw	a5,0(a5)
ffffffffc020452c:	00012497          	auipc	s1,0x12
ffffffffc0204530:	0c448493          	addi	s1,s1,196 # ffffffffc02165f0 <proc_list>
ffffffffc0204534:	06f54063          	blt	a0,a5,ffffffffc0204594 <do_fork+0x174>
        next_safe = MAX_PID;
ffffffffc0204538:	6789                	lui	a5,0x2
ffffffffc020453a:	00007717          	auipc	a4,0x7
ffffffffc020453e:	b2f72123          	sw	a5,-1246(a4) # ffffffffc020b05c <next_safe.1574>
ffffffffc0204542:	4581                	li	a1,0
ffffffffc0204544:	87aa                	mv	a5,a0
ffffffffc0204546:	00012497          	auipc	s1,0x12
ffffffffc020454a:	0aa48493          	addi	s1,s1,170 # ffffffffc02165f0 <proc_list>
    repeat:
ffffffffc020454e:	6889                	lui	a7,0x2
ffffffffc0204550:	882e                	mv	a6,a1
ffffffffc0204552:	6609                	lui	a2,0x2
        le = list;
ffffffffc0204554:	00012697          	auipc	a3,0x12
ffffffffc0204558:	09c68693          	addi	a3,a3,156 # ffffffffc02165f0 <proc_list>
ffffffffc020455c:	6694                	ld	a3,8(a3)
        while ((le = list_next(le)) != list) {
ffffffffc020455e:	00968f63          	beq	a3,s1,ffffffffc020457c <do_fork+0x15c>
            if (proc->pid == last_pid) {
ffffffffc0204562:	f3c6a703          	lw	a4,-196(a3)
ffffffffc0204566:	08e78963          	beq	a5,a4,ffffffffc02045f8 <do_fork+0x1d8>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc020456a:	fee7d9e3          	ble	a4,a5,ffffffffc020455c <do_fork+0x13c>
ffffffffc020456e:	fec757e3          	ble	a2,a4,ffffffffc020455c <do_fork+0x13c>
ffffffffc0204572:	6694                	ld	a3,8(a3)
ffffffffc0204574:	863a                	mv	a2,a4
ffffffffc0204576:	4805                	li	a6,1
        while ((le = list_next(le)) != list) {
ffffffffc0204578:	fe9695e3          	bne	a3,s1,ffffffffc0204562 <do_fork+0x142>
ffffffffc020457c:	c591                	beqz	a1,ffffffffc0204588 <do_fork+0x168>
ffffffffc020457e:	00007717          	auipc	a4,0x7
ffffffffc0204582:	acf72d23          	sw	a5,-1318(a4) # ffffffffc020b058 <last_pid.1575>
ffffffffc0204586:	853e                	mv	a0,a5
ffffffffc0204588:	00080663          	beqz	a6,ffffffffc0204594 <do_fork+0x174>
ffffffffc020458c:	00007797          	auipc	a5,0x7
ffffffffc0204590:	acc7a823          	sw	a2,-1328(a5) # ffffffffc020b05c <next_safe.1574>
        proc->pid = get_pid(); //分配id
ffffffffc0204594:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204596:	45a9                	li	a1,10
ffffffffc0204598:	2501                	sext.w	a0,a0
ffffffffc020459a:	149000ef          	jal	ra,ffffffffc0204ee2 <hash32>
ffffffffc020459e:	1502                	slli	a0,a0,0x20
ffffffffc02045a0:	0000e797          	auipc	a5,0xe
ffffffffc02045a4:	ec078793          	addi	a5,a5,-320 # ffffffffc0212460 <hash_list>
ffffffffc02045a8:	8171                	srli	a0,a0,0x1c
ffffffffc02045aa:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02045ac:	6510                	ld	a2,8(a0)
ffffffffc02045ae:	0d840793          	addi	a5,s0,216
ffffffffc02045b2:	6494                	ld	a3,8(s1)
        nr_process ++;//进程计数器++
ffffffffc02045b4:	00092703          	lw	a4,0(s2)
    prev->next = next->prev = elm;
ffffffffc02045b8:	e21c                	sd	a5,0(a2)
ffffffffc02045ba:	e51c                	sd	a5,8(a0)
    elm->next = next;
ffffffffc02045bc:	f070                	sd	a2,224(s0)
        list_add(&proc_list, &(proc->list_link)); //加入进程列表
ffffffffc02045be:	0c840793          	addi	a5,s0,200
    elm->prev = prev;
ffffffffc02045c2:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc02045c4:	e29c                	sd	a5,0(a3)
        nr_process ++;//进程计数器++
ffffffffc02045c6:	2705                	addiw	a4,a4,1
ffffffffc02045c8:	00012617          	auipc	a2,0x12
ffffffffc02045cc:	02f63823          	sd	a5,48(a2) # ffffffffc02165f8 <proc_list+0x8>
    elm->next = next;
ffffffffc02045d0:	e874                	sd	a3,208(s0)
    elm->prev = prev;
ffffffffc02045d2:	e464                	sd	s1,200(s0)
ffffffffc02045d4:	00012797          	auipc	a5,0x12
ffffffffc02045d8:	eee7aa23          	sw	a4,-268(a5) # ffffffffc02164c8 <nr_process>
    if (flag) {
ffffffffc02045dc:	06099a63          	bnez	s3,ffffffffc0204650 <do_fork+0x230>
    wakeup_proc(proc); //状态设为PROC_RUNNABLE，可调度
ffffffffc02045e0:	8522                	mv	a0,s0
ffffffffc02045e2:	344000ef          	jal	ra,ffffffffc0204926 <wakeup_proc>
    ret = proc->pid; //返回值为pif，创建成功
ffffffffc02045e6:	4048                	lw	a0,4(s0)
}
ffffffffc02045e8:	70a2                	ld	ra,40(sp)
ffffffffc02045ea:	7402                	ld	s0,32(sp)
ffffffffc02045ec:	64e2                	ld	s1,24(sp)
ffffffffc02045ee:	6942                	ld	s2,16(sp)
ffffffffc02045f0:	69a2                	ld	s3,8(sp)
ffffffffc02045f2:	6a02                	ld	s4,0(sp)
ffffffffc02045f4:	6145                	addi	sp,sp,48
ffffffffc02045f6:	8082                	ret
                if (++ last_pid >= next_safe) {
ffffffffc02045f8:	2785                	addiw	a5,a5,1
ffffffffc02045fa:	04c7de63          	ble	a2,a5,ffffffffc0204656 <do_fork+0x236>
ffffffffc02045fe:	4585                	li	a1,1
ffffffffc0204600:	bfb1                	j	ffffffffc020455c <do_fork+0x13c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204602:	89b6                	mv	s3,a3
ffffffffc0204604:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204608:	00000797          	auipc	a5,0x0
ffffffffc020460c:	c9278793          	addi	a5,a5,-878 # ffffffffc020429a <forkret>
ffffffffc0204610:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204612:	fc14                	sd	a3,56(s0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204614:	100027f3          	csrr	a5,sstatus
ffffffffc0204618:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020461a:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020461c:	ee0785e3          	beqz	a5,ffffffffc0204506 <do_fork+0xe6>
        intr_disable();
ffffffffc0204620:	fbbfb0ef          	jal	ra,ffffffffc02005da <intr_disable>
    if (++ last_pid >= MAX_PID) {
ffffffffc0204624:	00007797          	auipc	a5,0x7
ffffffffc0204628:	a3478793          	addi	a5,a5,-1484 # ffffffffc020b058 <last_pid.1575>
ffffffffc020462c:	439c                	lw	a5,0(a5)
ffffffffc020462e:	6709                	lui	a4,0x2
        return 1;
ffffffffc0204630:	4985                	li	s3,1
ffffffffc0204632:	0017851b          	addiw	a0,a5,1
ffffffffc0204636:	00007697          	auipc	a3,0x7
ffffffffc020463a:	a2a6a123          	sw	a0,-1502(a3) # ffffffffc020b058 <last_pid.1575>
ffffffffc020463e:	eee542e3          	blt	a0,a4,ffffffffc0204522 <do_fork+0x102>
        last_pid = 1;
ffffffffc0204642:	4785                	li	a5,1
ffffffffc0204644:	00007717          	auipc	a4,0x7
ffffffffc0204648:	a0f72a23          	sw	a5,-1516(a4) # ffffffffc020b058 <last_pid.1575>
ffffffffc020464c:	4505                	li	a0,1
ffffffffc020464e:	b5ed                	j	ffffffffc0204538 <do_fork+0x118>
        intr_enable();
ffffffffc0204650:	f85fb0ef          	jal	ra,ffffffffc02005d4 <intr_enable>
ffffffffc0204654:	b771                	j	ffffffffc02045e0 <do_fork+0x1c0>
                    if (last_pid >= MAX_PID) {
ffffffffc0204656:	0117c363          	blt	a5,a7,ffffffffc020465c <do_fork+0x23c>
                        last_pid = 1;
ffffffffc020465a:	4785                	li	a5,1
                    goto repeat;
ffffffffc020465c:	4585                	li	a1,1
ffffffffc020465e:	bdcd                	j	ffffffffc0204550 <do_fork+0x130>
    kfree(proc);
ffffffffc0204660:	8522                	mv	a0,s0
ffffffffc0204662:	c66fe0ef          	jal	ra,ffffffffc0202ac8 <kfree>
    ret = -E_NO_MEM;
ffffffffc0204666:	5571                	li	a0,-4
    goto fork_out;
ffffffffc0204668:	b741                	j	ffffffffc02045e8 <do_fork+0x1c8>
    int ret = -E_NO_FREE_PROC;
ffffffffc020466a:	556d                	li	a0,-5
ffffffffc020466c:	bfb5                	j	ffffffffc02045e8 <do_fork+0x1c8>
    ret = -E_NO_MEM;
ffffffffc020466e:	5571                	li	a0,-4
ffffffffc0204670:	bfa5                	j	ffffffffc02045e8 <do_fork+0x1c8>
    assert(current->mm == NULL);
ffffffffc0204672:	00002697          	auipc	a3,0x2
ffffffffc0204676:	5ae68693          	addi	a3,a3,1454 # ffffffffc0206c20 <default_pmm_manager+0xc0>
ffffffffc020467a:	00001617          	auipc	a2,0x1
ffffffffc020467e:	36e60613          	addi	a2,a2,878 # ffffffffc02059e8 <commands+0x998>
ffffffffc0204682:	10800593          	li	a1,264
ffffffffc0204686:	00002517          	auipc	a0,0x2
ffffffffc020468a:	5b250513          	addi	a0,a0,1458 # ffffffffc0206c38 <default_pmm_manager+0xd8>
ffffffffc020468e:	b49fb0ef          	jal	ra,ffffffffc02001d6 <__panic>
ffffffffc0204692:	00001617          	auipc	a2,0x1
ffffffffc0204696:	1fe60613          	addi	a2,a2,510 # ffffffffc0205890 <commands+0x840>
ffffffffc020469a:	06a00593          	li	a1,106
ffffffffc020469e:	00001517          	auipc	a0,0x1
ffffffffc02046a2:	24a50513          	addi	a0,a0,586 # ffffffffc02058e8 <commands+0x898>
ffffffffc02046a6:	b31fb0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc02046aa <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02046aa:	7129                	addi	sp,sp,-320
ffffffffc02046ac:	fa22                	sd	s0,304(sp)
ffffffffc02046ae:	f626                	sd	s1,296(sp)
ffffffffc02046b0:	f24a                	sd	s2,288(sp)
ffffffffc02046b2:	84ae                	mv	s1,a1
ffffffffc02046b4:	892a                	mv	s2,a0
ffffffffc02046b6:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046b8:	4581                	li	a1,0
ffffffffc02046ba:	12000613          	li	a2,288
ffffffffc02046be:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02046c0:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046c2:	3ce000ef          	jal	ra,ffffffffc0204a90 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02046c6:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02046c8:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02046ca:	100027f3          	csrr	a5,sstatus
ffffffffc02046ce:	edd7f793          	andi	a5,a5,-291
ffffffffc02046d2:	1207e793          	ori	a5,a5,288
ffffffffc02046d6:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046d8:	860a                	mv	a2,sp
ffffffffc02046da:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046de:	00000797          	auipc	a5,0x0
ffffffffc02046e2:	ae678793          	addi	a5,a5,-1306 # ffffffffc02041c4 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046e6:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046e8:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046ea:	d37ff0ef          	jal	ra,ffffffffc0204420 <do_fork>
}
ffffffffc02046ee:	70f2                	ld	ra,312(sp)
ffffffffc02046f0:	7452                	ld	s0,304(sp)
ffffffffc02046f2:	74b2                	ld	s1,296(sp)
ffffffffc02046f4:	7912                	ld	s2,288(sp)
ffffffffc02046f6:	6131                	addi	sp,sp,320
ffffffffc02046f8:	8082                	ret

ffffffffc02046fa <do_exit>:
do_exit(int error_code) {
ffffffffc02046fa:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc02046fc:	00002617          	auipc	a2,0x2
ffffffffc0204700:	50c60613          	addi	a2,a2,1292 # ffffffffc0206c08 <default_pmm_manager+0xa8>
ffffffffc0204704:	17000593          	li	a1,368
ffffffffc0204708:	00002517          	auipc	a0,0x2
ffffffffc020470c:	53050513          	addi	a0,a0,1328 # ffffffffc0206c38 <default_pmm_manager+0xd8>
do_exit(int error_code) {
ffffffffc0204710:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc0204712:	ac5fb0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0204716 <proc_init>:
    elm->prev = elm->next = elm;
ffffffffc0204716:	00012797          	auipc	a5,0x12
ffffffffc020471a:	eda78793          	addi	a5,a5,-294 # ffffffffc02165f0 <proc_list>

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc020471e:	1101                	addi	sp,sp,-32
ffffffffc0204720:	00012717          	auipc	a4,0x12
ffffffffc0204724:	ecf73c23          	sd	a5,-296(a4) # ffffffffc02165f8 <proc_list+0x8>
ffffffffc0204728:	00012717          	auipc	a4,0x12
ffffffffc020472c:	ecf73423          	sd	a5,-312(a4) # ffffffffc02165f0 <proc_list>
ffffffffc0204730:	ec06                	sd	ra,24(sp)
ffffffffc0204732:	e822                	sd	s0,16(sp)
ffffffffc0204734:	e426                	sd	s1,8(sp)
ffffffffc0204736:	e04a                	sd	s2,0(sp)
ffffffffc0204738:	0000e797          	auipc	a5,0xe
ffffffffc020473c:	d2878793          	addi	a5,a5,-728 # ffffffffc0212460 <hash_list>
ffffffffc0204740:	00012717          	auipc	a4,0x12
ffffffffc0204744:	d2070713          	addi	a4,a4,-736 # ffffffffc0216460 <name.1565>
ffffffffc0204748:	e79c                	sd	a5,8(a5)
ffffffffc020474a:	e39c                	sd	a5,0(a5)
ffffffffc020474c:	07c1                	addi	a5,a5,16
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc020474e:	fee79de3          	bne	a5,a4,ffffffffc0204748 <proc_init+0x32>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0204752:	ae5ff0ef          	jal	ra,ffffffffc0204236 <alloc_proc>
ffffffffc0204756:	00012797          	auipc	a5,0x12
ffffffffc020475a:	d6a7b123          	sd	a0,-670(a5) # ffffffffc02164b8 <idleproc>
ffffffffc020475e:	00012417          	auipc	s0,0x12
ffffffffc0204762:	d5a40413          	addi	s0,s0,-678 # ffffffffc02164b8 <idleproc>
ffffffffc0204766:	12050a63          	beqz	a0,ffffffffc020489a <proc_init+0x184>
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc020476a:	07000513          	li	a0,112
ffffffffc020476e:	a9efe0ef          	jal	ra,ffffffffc0202a0c <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0204772:	07000613          	li	a2,112
ffffffffc0204776:	4581                	li	a1,0
    int *context_mem = (int*) kmalloc(sizeof(struct context));
ffffffffc0204778:	84aa                	mv	s1,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020477a:	316000ef          	jal	ra,ffffffffc0204a90 <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc020477e:	6008                	ld	a0,0(s0)
ffffffffc0204780:	85a6                	mv	a1,s1
ffffffffc0204782:	07000613          	li	a2,112
ffffffffc0204786:	03050513          	addi	a0,a0,48
ffffffffc020478a:	330000ef          	jal	ra,ffffffffc0204aba <memcmp>
ffffffffc020478e:	892a                	mv	s2,a0

    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc0204790:	453d                	li	a0,15
ffffffffc0204792:	a7afe0ef          	jal	ra,ffffffffc0202a0c <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0204796:	463d                	li	a2,15
ffffffffc0204798:	4581                	li	a1,0
    int *proc_name_mem = (int*) kmalloc(PROC_NAME_LEN);
ffffffffc020479a:	84aa                	mv	s1,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc020479c:	2f4000ef          	jal	ra,ffffffffc0204a90 <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc02047a0:	6008                	ld	a0,0(s0)
ffffffffc02047a2:	463d                	li	a2,15
ffffffffc02047a4:	85a6                	mv	a1,s1
ffffffffc02047a6:	0b450513          	addi	a0,a0,180
ffffffffc02047aa:	310000ef          	jal	ra,ffffffffc0204aba <memcmp>

    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc02047ae:	601c                	ld	a5,0(s0)
ffffffffc02047b0:	00012717          	auipc	a4,0x12
ffffffffc02047b4:	d3870713          	addi	a4,a4,-712 # ffffffffc02164e8 <boot_cr3>
ffffffffc02047b8:	6318                	ld	a4,0(a4)
ffffffffc02047ba:	77d4                	ld	a3,168(a5)
ffffffffc02047bc:	08e68e63          	beq	a3,a4,ffffffffc0204858 <proc_init+0x142>
        cprintf("alloc_proc() correct!\n");

    }
    
    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc02047c0:	4709                	li	a4,2
ffffffffc02047c2:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02047c4:	00004717          	auipc	a4,0x4
ffffffffc02047c8:	83c70713          	addi	a4,a4,-1988 # ffffffffc0208000 <bootstack>
ffffffffc02047cc:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc02047ce:	4705                	li	a4,1
ffffffffc02047d0:	cf98                	sw	a4,24(a5)
    set_proc_name(idleproc, "idle");
ffffffffc02047d2:	00002597          	auipc	a1,0x2
ffffffffc02047d6:	50658593          	addi	a1,a1,1286 # ffffffffc0206cd8 <default_pmm_manager+0x178>
ffffffffc02047da:	853e                	mv	a0,a5
ffffffffc02047dc:	acfff0ef          	jal	ra,ffffffffc02042aa <set_proc_name>
    nr_process ++;
ffffffffc02047e0:	00012797          	auipc	a5,0x12
ffffffffc02047e4:	ce878793          	addi	a5,a5,-792 # ffffffffc02164c8 <nr_process>
ffffffffc02047e8:	439c                	lw	a5,0(a5)

    current = idleproc;
ffffffffc02047ea:	6018                	ld	a4,0(s0)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02047ec:	4601                	li	a2,0
    nr_process ++;
ffffffffc02047ee:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02047f0:	00002597          	auipc	a1,0x2
ffffffffc02047f4:	4f058593          	addi	a1,a1,1264 # ffffffffc0206ce0 <default_pmm_manager+0x180>
ffffffffc02047f8:	00000517          	auipc	a0,0x0
ffffffffc02047fc:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0204304 <init_main>
    nr_process ++;
ffffffffc0204800:	00012697          	auipc	a3,0x12
ffffffffc0204804:	ccf6a423          	sw	a5,-824(a3) # ffffffffc02164c8 <nr_process>
    current = idleproc;
ffffffffc0204808:	00012797          	auipc	a5,0x12
ffffffffc020480c:	cae7b423          	sd	a4,-856(a5) # ffffffffc02164b0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0204810:	e9bff0ef          	jal	ra,ffffffffc02046aa <kernel_thread>
    if (pid <= 0) {
ffffffffc0204814:	0ca05f63          	blez	a0,ffffffffc02048f2 <proc_init+0x1dc>
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204818:	badff0ef          	jal	ra,ffffffffc02043c4 <find_proc>
    set_proc_name(initproc, "init");
ffffffffc020481c:	00002597          	auipc	a1,0x2
ffffffffc0204820:	4f458593          	addi	a1,a1,1268 # ffffffffc0206d10 <default_pmm_manager+0x1b0>
    initproc = find_proc(pid);
ffffffffc0204824:	00012797          	auipc	a5,0x12
ffffffffc0204828:	c8a7be23          	sd	a0,-868(a5) # ffffffffc02164c0 <initproc>
    set_proc_name(initproc, "init");
ffffffffc020482c:	a7fff0ef          	jal	ra,ffffffffc02042aa <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204830:	601c                	ld	a5,0(s0)
ffffffffc0204832:	c3c5                	beqz	a5,ffffffffc02048d2 <proc_init+0x1bc>
ffffffffc0204834:	43dc                	lw	a5,4(a5)
ffffffffc0204836:	efd1                	bnez	a5,ffffffffc02048d2 <proc_init+0x1bc>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204838:	00012797          	auipc	a5,0x12
ffffffffc020483c:	c8878793          	addi	a5,a5,-888 # ffffffffc02164c0 <initproc>
ffffffffc0204840:	639c                	ld	a5,0(a5)
ffffffffc0204842:	cba5                	beqz	a5,ffffffffc02048b2 <proc_init+0x19c>
ffffffffc0204844:	43d8                	lw	a4,4(a5)
ffffffffc0204846:	4785                	li	a5,1
ffffffffc0204848:	06f71563          	bne	a4,a5,ffffffffc02048b2 <proc_init+0x19c>
}
ffffffffc020484c:	60e2                	ld	ra,24(sp)
ffffffffc020484e:	6442                	ld	s0,16(sp)
ffffffffc0204850:	64a2                	ld	s1,8(sp)
ffffffffc0204852:	6902                	ld	s2,0(sp)
ffffffffc0204854:	6105                	addi	sp,sp,32
ffffffffc0204856:	8082                	ret
    if(idleproc->cr3 == boot_cr3 && idleproc->tf == NULL && !context_init_flag
ffffffffc0204858:	73d8                	ld	a4,160(a5)
ffffffffc020485a:	f33d                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
ffffffffc020485c:	f60912e3          	bnez	s2,ffffffffc02047c0 <proc_init+0xaa>
        && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0
ffffffffc0204860:	6394                	ld	a3,0(a5)
ffffffffc0204862:	577d                	li	a4,-1
ffffffffc0204864:	1702                	slli	a4,a4,0x20
ffffffffc0204866:	f4e69de3          	bne	a3,a4,ffffffffc02047c0 <proc_init+0xaa>
ffffffffc020486a:	4798                	lw	a4,8(a5)
ffffffffc020486c:	fb31                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
        && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL
ffffffffc020486e:	6b98                	ld	a4,16(a5)
ffffffffc0204870:	fb21                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
ffffffffc0204872:	4f98                	lw	a4,24(a5)
ffffffffc0204874:	2701                	sext.w	a4,a4
ffffffffc0204876:	f729                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
ffffffffc0204878:	7398                	ld	a4,32(a5)
ffffffffc020487a:	f339                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
        && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag
ffffffffc020487c:	7798                	ld	a4,40(a5)
ffffffffc020487e:	f329                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
ffffffffc0204880:	0b07a703          	lw	a4,176(a5)
ffffffffc0204884:	8f49                	or	a4,a4,a0
ffffffffc0204886:	2701                	sext.w	a4,a4
ffffffffc0204888:	ff05                	bnez	a4,ffffffffc02047c0 <proc_init+0xaa>
        cprintf("alloc_proc() correct!\n");
ffffffffc020488a:	00002517          	auipc	a0,0x2
ffffffffc020488e:	43650513          	addi	a0,a0,1078 # ffffffffc0206cc0 <default_pmm_manager+0x160>
ffffffffc0204892:	83ffb0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0204896:	601c                	ld	a5,0(s0)
ffffffffc0204898:	b725                	j	ffffffffc02047c0 <proc_init+0xaa>
        panic("cannot alloc idleproc.\n");
ffffffffc020489a:	00002617          	auipc	a2,0x2
ffffffffc020489e:	40e60613          	addi	a2,a2,1038 # ffffffffc0206ca8 <default_pmm_manager+0x148>
ffffffffc02048a2:	18800593          	li	a1,392
ffffffffc02048a6:	00002517          	auipc	a0,0x2
ffffffffc02048aa:	39250513          	addi	a0,a0,914 # ffffffffc0206c38 <default_pmm_manager+0xd8>
ffffffffc02048ae:	929fb0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02048b2:	00002697          	auipc	a3,0x2
ffffffffc02048b6:	48e68693          	addi	a3,a3,1166 # ffffffffc0206d40 <default_pmm_manager+0x1e0>
ffffffffc02048ba:	00001617          	auipc	a2,0x1
ffffffffc02048be:	12e60613          	addi	a2,a2,302 # ffffffffc02059e8 <commands+0x998>
ffffffffc02048c2:	1af00593          	li	a1,431
ffffffffc02048c6:	00002517          	auipc	a0,0x2
ffffffffc02048ca:	37250513          	addi	a0,a0,882 # ffffffffc0206c38 <default_pmm_manager+0xd8>
ffffffffc02048ce:	909fb0ef          	jal	ra,ffffffffc02001d6 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02048d2:	00002697          	auipc	a3,0x2
ffffffffc02048d6:	44668693          	addi	a3,a3,1094 # ffffffffc0206d18 <default_pmm_manager+0x1b8>
ffffffffc02048da:	00001617          	auipc	a2,0x1
ffffffffc02048de:	10e60613          	addi	a2,a2,270 # ffffffffc02059e8 <commands+0x998>
ffffffffc02048e2:	1ae00593          	li	a1,430
ffffffffc02048e6:	00002517          	auipc	a0,0x2
ffffffffc02048ea:	35250513          	addi	a0,a0,850 # ffffffffc0206c38 <default_pmm_manager+0xd8>
ffffffffc02048ee:	8e9fb0ef          	jal	ra,ffffffffc02001d6 <__panic>
        panic("create init_main failed.\n");
ffffffffc02048f2:	00002617          	auipc	a2,0x2
ffffffffc02048f6:	3fe60613          	addi	a2,a2,1022 # ffffffffc0206cf0 <default_pmm_manager+0x190>
ffffffffc02048fa:	1a800593          	li	a1,424
ffffffffc02048fe:	00002517          	auipc	a0,0x2
ffffffffc0204902:	33a50513          	addi	a0,a0,826 # ffffffffc0206c38 <default_pmm_manager+0xd8>
ffffffffc0204906:	8d1fb0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc020490a <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc020490a:	1141                	addi	sp,sp,-16
ffffffffc020490c:	e022                	sd	s0,0(sp)
ffffffffc020490e:	e406                	sd	ra,8(sp)
ffffffffc0204910:	00012417          	auipc	s0,0x12
ffffffffc0204914:	ba040413          	addi	s0,s0,-1120 # ffffffffc02164b0 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc0204918:	6018                	ld	a4,0(s0)
ffffffffc020491a:	4f1c                	lw	a5,24(a4)
ffffffffc020491c:	2781                	sext.w	a5,a5
ffffffffc020491e:	dff5                	beqz	a5,ffffffffc020491a <cpu_idle+0x10>
            schedule();
ffffffffc0204920:	038000ef          	jal	ra,ffffffffc0204958 <schedule>
ffffffffc0204924:	bfd5                	j	ffffffffc0204918 <cpu_idle+0xe>

ffffffffc0204926 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0204926:	411c                	lw	a5,0(a0)
ffffffffc0204928:	4705                	li	a4,1
ffffffffc020492a:	37f9                	addiw	a5,a5,-2
ffffffffc020492c:	00f77563          	bleu	a5,a4,ffffffffc0204936 <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc0204930:	4789                	li	a5,2
ffffffffc0204932:	c11c                	sw	a5,0(a0)
ffffffffc0204934:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc0204936:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0204938:	00002697          	auipc	a3,0x2
ffffffffc020493c:	43068693          	addi	a3,a3,1072 # ffffffffc0206d68 <default_pmm_manager+0x208>
ffffffffc0204940:	00001617          	auipc	a2,0x1
ffffffffc0204944:	0a860613          	addi	a2,a2,168 # ffffffffc02059e8 <commands+0x998>
ffffffffc0204948:	45a5                	li	a1,9
ffffffffc020494a:	00002517          	auipc	a0,0x2
ffffffffc020494e:	45e50513          	addi	a0,a0,1118 # ffffffffc0206da8 <default_pmm_manager+0x248>
wakeup_proc(struct proc_struct *proc) {
ffffffffc0204952:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0204954:	883fb0ef          	jal	ra,ffffffffc02001d6 <__panic>

ffffffffc0204958 <schedule>:
}

void
schedule(void) {
ffffffffc0204958:	1141                	addi	sp,sp,-16
ffffffffc020495a:	e406                	sd	ra,8(sp)
ffffffffc020495c:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020495e:	100027f3          	csrr	a5,sstatus
ffffffffc0204962:	8b89                	andi	a5,a5,2
ffffffffc0204964:	4401                	li	s0,0
ffffffffc0204966:	e3d1                	bnez	a5,ffffffffc02049ea <schedule+0x92>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0204968:	00012797          	auipc	a5,0x12
ffffffffc020496c:	b4878793          	addi	a5,a5,-1208 # ffffffffc02164b0 <current>
ffffffffc0204970:	0007b883          	ld	a7,0(a5)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0204974:	00012797          	auipc	a5,0x12
ffffffffc0204978:	b4478793          	addi	a5,a5,-1212 # ffffffffc02164b8 <idleproc>
ffffffffc020497c:	6388                	ld	a0,0(a5)
        current->need_resched = 0;
ffffffffc020497e:	0008ac23          	sw	zero,24(a7) # 2018 <BASE_ADDRESS-0xffffffffc01fdfe8>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0204982:	04a88e63          	beq	a7,a0,ffffffffc02049de <schedule+0x86>
ffffffffc0204986:	0c888693          	addi	a3,a7,200
ffffffffc020498a:	00012617          	auipc	a2,0x12
ffffffffc020498e:	c6660613          	addi	a2,a2,-922 # ffffffffc02165f0 <proc_list>
        le = last;
ffffffffc0204992:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0204994:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0204996:	4809                	li	a6,2
    return listelm->next;
ffffffffc0204998:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc020499a:	00c78863          	beq	a5,a2,ffffffffc02049aa <schedule+0x52>
                if (next->state == PROC_RUNNABLE) {
ffffffffc020499e:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02049a2:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc02049a6:	01070463          	beq	a4,a6,ffffffffc02049ae <schedule+0x56>
                    break;
                }
            }
        } while (le != last);
ffffffffc02049aa:	fef697e3          	bne	a3,a5,ffffffffc0204998 <schedule+0x40>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc02049ae:	c589                	beqz	a1,ffffffffc02049b8 <schedule+0x60>
ffffffffc02049b0:	4198                	lw	a4,0(a1)
ffffffffc02049b2:	4789                	li	a5,2
ffffffffc02049b4:	00f70e63          	beq	a4,a5,ffffffffc02049d0 <schedule+0x78>
            next = idleproc;
        }
        next->runs ++;
ffffffffc02049b8:	451c                	lw	a5,8(a0)
ffffffffc02049ba:	2785                	addiw	a5,a5,1
ffffffffc02049bc:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc02049be:	00a88463          	beq	a7,a0,ffffffffc02049c6 <schedule+0x6e>
            proc_run(next);
ffffffffc02049c2:	995ff0ef          	jal	ra,ffffffffc0204356 <proc_run>
    if (flag) {
ffffffffc02049c6:	e419                	bnez	s0,ffffffffc02049d4 <schedule+0x7c>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02049c8:	60a2                	ld	ra,8(sp)
ffffffffc02049ca:	6402                	ld	s0,0(sp)
ffffffffc02049cc:	0141                	addi	sp,sp,16
ffffffffc02049ce:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc02049d0:	852e                	mv	a0,a1
ffffffffc02049d2:	b7dd                	j	ffffffffc02049b8 <schedule+0x60>
}
ffffffffc02049d4:	6402                	ld	s0,0(sp)
ffffffffc02049d6:	60a2                	ld	ra,8(sp)
ffffffffc02049d8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02049da:	bfbfb06f          	j	ffffffffc02005d4 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02049de:	00012617          	auipc	a2,0x12
ffffffffc02049e2:	c1260613          	addi	a2,a2,-1006 # ffffffffc02165f0 <proc_list>
ffffffffc02049e6:	86b2                	mv	a3,a2
ffffffffc02049e8:	b76d                	j	ffffffffc0204992 <schedule+0x3a>
        intr_disable();
ffffffffc02049ea:	bf1fb0ef          	jal	ra,ffffffffc02005da <intr_disable>
        return 1;
ffffffffc02049ee:	4405                	li	s0,1
ffffffffc02049f0:	bfa5                	j	ffffffffc0204968 <schedule+0x10>

ffffffffc02049f2 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02049f2:	00054783          	lbu	a5,0(a0)
ffffffffc02049f6:	cb91                	beqz	a5,ffffffffc0204a0a <strlen+0x18>
    size_t cnt = 0;
ffffffffc02049f8:	4781                	li	a5,0
        cnt ++;
ffffffffc02049fa:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc02049fc:	00f50733          	add	a4,a0,a5
ffffffffc0204a00:	00074703          	lbu	a4,0(a4)
ffffffffc0204a04:	fb7d                	bnez	a4,ffffffffc02049fa <strlen+0x8>
    }
    return cnt;
}
ffffffffc0204a06:	853e                	mv	a0,a5
ffffffffc0204a08:	8082                	ret
    size_t cnt = 0;
ffffffffc0204a0a:	4781                	li	a5,0
}
ffffffffc0204a0c:	853e                	mv	a0,a5
ffffffffc0204a0e:	8082                	ret

ffffffffc0204a10 <strnlen>:
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204a10:	c185                	beqz	a1,ffffffffc0204a30 <strnlen+0x20>
ffffffffc0204a12:	00054783          	lbu	a5,0(a0)
ffffffffc0204a16:	cf89                	beqz	a5,ffffffffc0204a30 <strnlen+0x20>
    size_t cnt = 0;
ffffffffc0204a18:	4781                	li	a5,0
ffffffffc0204a1a:	a021                	j	ffffffffc0204a22 <strnlen+0x12>
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204a1c:	00074703          	lbu	a4,0(a4)
ffffffffc0204a20:	c711                	beqz	a4,ffffffffc0204a2c <strnlen+0x1c>
        cnt ++;
ffffffffc0204a22:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0204a24:	00f50733          	add	a4,a0,a5
ffffffffc0204a28:	fef59ae3          	bne	a1,a5,ffffffffc0204a1c <strnlen+0xc>
    }
    return cnt;
}
ffffffffc0204a2c:	853e                	mv	a0,a5
ffffffffc0204a2e:	8082                	ret
    size_t cnt = 0;
ffffffffc0204a30:	4781                	li	a5,0
}
ffffffffc0204a32:	853e                	mv	a0,a5
ffffffffc0204a34:	8082                	ret

ffffffffc0204a36 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0204a36:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0204a38:	0585                	addi	a1,a1,1
ffffffffc0204a3a:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0204a3e:	0785                	addi	a5,a5,1
ffffffffc0204a40:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0204a44:	fb75                	bnez	a4,ffffffffc0204a38 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0204a46:	8082                	ret

ffffffffc0204a48 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204a48:	00054783          	lbu	a5,0(a0)
ffffffffc0204a4c:	0005c703          	lbu	a4,0(a1)
ffffffffc0204a50:	cb91                	beqz	a5,ffffffffc0204a64 <strcmp+0x1c>
ffffffffc0204a52:	00e79c63          	bne	a5,a4,ffffffffc0204a6a <strcmp+0x22>
        s1 ++, s2 ++;
ffffffffc0204a56:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204a58:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
ffffffffc0204a5c:	0585                	addi	a1,a1,1
ffffffffc0204a5e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0204a62:	fbe5                	bnez	a5,ffffffffc0204a52 <strcmp+0xa>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204a64:	4501                	li	a0,0
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0204a66:	9d19                	subw	a0,a0,a4
ffffffffc0204a68:	8082                	ret
ffffffffc0204a6a:	0007851b          	sext.w	a0,a5
ffffffffc0204a6e:	9d19                	subw	a0,a0,a4
ffffffffc0204a70:	8082                	ret

ffffffffc0204a72 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0204a72:	00054783          	lbu	a5,0(a0)
ffffffffc0204a76:	cb91                	beqz	a5,ffffffffc0204a8a <strchr+0x18>
        if (*s == c) {
ffffffffc0204a78:	00b79563          	bne	a5,a1,ffffffffc0204a82 <strchr+0x10>
ffffffffc0204a7c:	a809                	j	ffffffffc0204a8e <strchr+0x1c>
ffffffffc0204a7e:	00b78763          	beq	a5,a1,ffffffffc0204a8c <strchr+0x1a>
            return (char *)s;
        }
        s ++;
ffffffffc0204a82:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0204a84:	00054783          	lbu	a5,0(a0)
ffffffffc0204a88:	fbfd                	bnez	a5,ffffffffc0204a7e <strchr+0xc>
    }
    return NULL;
ffffffffc0204a8a:	4501                	li	a0,0
}
ffffffffc0204a8c:	8082                	ret
ffffffffc0204a8e:	8082                	ret

ffffffffc0204a90 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0204a90:	ca01                	beqz	a2,ffffffffc0204aa0 <memset+0x10>
ffffffffc0204a92:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0204a94:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0204a96:	0785                	addi	a5,a5,1
ffffffffc0204a98:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0204a9c:	fec79de3          	bne	a5,a2,ffffffffc0204a96 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0204aa0:	8082                	ret

ffffffffc0204aa2 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0204aa2:	ca19                	beqz	a2,ffffffffc0204ab8 <memcpy+0x16>
ffffffffc0204aa4:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0204aa6:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0204aa8:	0585                	addi	a1,a1,1
ffffffffc0204aaa:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0204aae:	0785                	addi	a5,a5,1
ffffffffc0204ab0:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0204ab4:	fec59ae3          	bne	a1,a2,ffffffffc0204aa8 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0204ab8:	8082                	ret

ffffffffc0204aba <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0204aba:	c21d                	beqz	a2,ffffffffc0204ae0 <memcmp+0x26>
        if (*s1 != *s2) {
ffffffffc0204abc:	00054783          	lbu	a5,0(a0)
ffffffffc0204ac0:	0005c703          	lbu	a4,0(a1)
ffffffffc0204ac4:	962a                	add	a2,a2,a0
ffffffffc0204ac6:	00f70963          	beq	a4,a5,ffffffffc0204ad8 <memcmp+0x1e>
ffffffffc0204aca:	a829                	j	ffffffffc0204ae4 <memcmp+0x2a>
ffffffffc0204acc:	00054783          	lbu	a5,0(a0)
ffffffffc0204ad0:	0005c703          	lbu	a4,0(a1)
ffffffffc0204ad4:	00e79863          	bne	a5,a4,ffffffffc0204ae4 <memcmp+0x2a>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0204ad8:	0505                	addi	a0,a0,1
ffffffffc0204ada:	0585                	addi	a1,a1,1
    while (n -- > 0) {
ffffffffc0204adc:	fea618e3          	bne	a2,a0,ffffffffc0204acc <memcmp+0x12>
    }
    return 0;
ffffffffc0204ae0:	4501                	li	a0,0
}
ffffffffc0204ae2:	8082                	ret
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0204ae4:	40e7853b          	subw	a0,a5,a4
ffffffffc0204ae8:	8082                	ret

ffffffffc0204aea <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0204aea:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204aee:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0204af0:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204af4:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0204af6:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0204afa:	f022                	sd	s0,32(sp)
ffffffffc0204afc:	ec26                	sd	s1,24(sp)
ffffffffc0204afe:	e84a                	sd	s2,16(sp)
ffffffffc0204b00:	f406                	sd	ra,40(sp)
ffffffffc0204b02:	e44e                	sd	s3,8(sp)
ffffffffc0204b04:	84aa                	mv	s1,a0
ffffffffc0204b06:	892e                	mv	s2,a1
ffffffffc0204b08:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0204b0c:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
ffffffffc0204b0e:	03067e63          	bleu	a6,a2,ffffffffc0204b4a <printnum+0x60>
ffffffffc0204b12:	89be                	mv	s3,a5
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0204b14:	00805763          	blez	s0,ffffffffc0204b22 <printnum+0x38>
ffffffffc0204b18:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0204b1a:	85ca                	mv	a1,s2
ffffffffc0204b1c:	854e                	mv	a0,s3
ffffffffc0204b1e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0204b20:	fc65                	bnez	s0,ffffffffc0204b18 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204b22:	1a02                	slli	s4,s4,0x20
ffffffffc0204b24:	020a5a13          	srli	s4,s4,0x20
ffffffffc0204b28:	00002797          	auipc	a5,0x2
ffffffffc0204b2c:	42878793          	addi	a5,a5,1064 # ffffffffc0206f50 <error_string+0x38>
ffffffffc0204b30:	9a3e                	add	s4,s4,a5
}
ffffffffc0204b32:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204b34:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0204b38:	70a2                	ld	ra,40(sp)
ffffffffc0204b3a:	69a2                	ld	s3,8(sp)
ffffffffc0204b3c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204b3e:	85ca                	mv	a1,s2
ffffffffc0204b40:	8326                	mv	t1,s1
}
ffffffffc0204b42:	6942                	ld	s2,16(sp)
ffffffffc0204b44:	64e2                	ld	s1,24(sp)
ffffffffc0204b46:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0204b48:	8302                	jr	t1
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0204b4a:	03065633          	divu	a2,a2,a6
ffffffffc0204b4e:	8722                	mv	a4,s0
ffffffffc0204b50:	f9bff0ef          	jal	ra,ffffffffc0204aea <printnum>
ffffffffc0204b54:	b7f9                	j	ffffffffc0204b22 <printnum+0x38>

ffffffffc0204b56 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0204b56:	7119                	addi	sp,sp,-128
ffffffffc0204b58:	f4a6                	sd	s1,104(sp)
ffffffffc0204b5a:	f0ca                	sd	s2,96(sp)
ffffffffc0204b5c:	e8d2                	sd	s4,80(sp)
ffffffffc0204b5e:	e4d6                	sd	s5,72(sp)
ffffffffc0204b60:	e0da                	sd	s6,64(sp)
ffffffffc0204b62:	fc5e                	sd	s7,56(sp)
ffffffffc0204b64:	f862                	sd	s8,48(sp)
ffffffffc0204b66:	f06a                	sd	s10,32(sp)
ffffffffc0204b68:	fc86                	sd	ra,120(sp)
ffffffffc0204b6a:	f8a2                	sd	s0,112(sp)
ffffffffc0204b6c:	ecce                	sd	s3,88(sp)
ffffffffc0204b6e:	f466                	sd	s9,40(sp)
ffffffffc0204b70:	ec6e                	sd	s11,24(sp)
ffffffffc0204b72:	892a                	mv	s2,a0
ffffffffc0204b74:	84ae                	mv	s1,a1
ffffffffc0204b76:	8d32                	mv	s10,a2
ffffffffc0204b78:	8ab6                	mv	s5,a3
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0204b7a:	5b7d                	li	s6,-1
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204b7c:	00002a17          	auipc	s4,0x2
ffffffffc0204b80:	244a0a13          	addi	s4,s4,580 # ffffffffc0206dc0 <default_pmm_manager+0x260>
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204b84:	05e00b93          	li	s7,94
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204b88:	00002c17          	auipc	s8,0x2
ffffffffc0204b8c:	390c0c13          	addi	s8,s8,912 # ffffffffc0206f18 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204b90:	000d4503          	lbu	a0,0(s10) # 1000 <BASE_ADDRESS-0xffffffffc01ff000>
ffffffffc0204b94:	02500793          	li	a5,37
ffffffffc0204b98:	001d0413          	addi	s0,s10,1
ffffffffc0204b9c:	00f50e63          	beq	a0,a5,ffffffffc0204bb8 <vprintfmt+0x62>
            if (ch == '\0') {
ffffffffc0204ba0:	c521                	beqz	a0,ffffffffc0204be8 <vprintfmt+0x92>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204ba2:	02500993          	li	s3,37
ffffffffc0204ba6:	a011                	j	ffffffffc0204baa <vprintfmt+0x54>
            if (ch == '\0') {
ffffffffc0204ba8:	c121                	beqz	a0,ffffffffc0204be8 <vprintfmt+0x92>
            putch(ch, putdat);
ffffffffc0204baa:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204bac:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0204bae:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0204bb0:	fff44503          	lbu	a0,-1(s0)
ffffffffc0204bb4:	ff351ae3          	bne	a0,s3,ffffffffc0204ba8 <vprintfmt+0x52>
ffffffffc0204bb8:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0204bbc:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0204bc0:	4981                	li	s3,0
ffffffffc0204bc2:	4801                	li	a6,0
        width = precision = -1;
ffffffffc0204bc4:	5cfd                	li	s9,-1
ffffffffc0204bc6:	5dfd                	li	s11,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204bc8:	05500593          	li	a1,85
                if (ch < '0' || ch > '9') {
ffffffffc0204bcc:	4525                	li	a0,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204bce:	fdd6069b          	addiw	a3,a2,-35
ffffffffc0204bd2:	0ff6f693          	andi	a3,a3,255
ffffffffc0204bd6:	00140d13          	addi	s10,s0,1
ffffffffc0204bda:	20d5e563          	bltu	a1,a3,ffffffffc0204de4 <vprintfmt+0x28e>
ffffffffc0204bde:	068a                	slli	a3,a3,0x2
ffffffffc0204be0:	96d2                	add	a3,a3,s4
ffffffffc0204be2:	4294                	lw	a3,0(a3)
ffffffffc0204be4:	96d2                	add	a3,a3,s4
ffffffffc0204be6:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0204be8:	70e6                	ld	ra,120(sp)
ffffffffc0204bea:	7446                	ld	s0,112(sp)
ffffffffc0204bec:	74a6                	ld	s1,104(sp)
ffffffffc0204bee:	7906                	ld	s2,96(sp)
ffffffffc0204bf0:	69e6                	ld	s3,88(sp)
ffffffffc0204bf2:	6a46                	ld	s4,80(sp)
ffffffffc0204bf4:	6aa6                	ld	s5,72(sp)
ffffffffc0204bf6:	6b06                	ld	s6,64(sp)
ffffffffc0204bf8:	7be2                	ld	s7,56(sp)
ffffffffc0204bfa:	7c42                	ld	s8,48(sp)
ffffffffc0204bfc:	7ca2                	ld	s9,40(sp)
ffffffffc0204bfe:	7d02                	ld	s10,32(sp)
ffffffffc0204c00:	6de2                	ld	s11,24(sp)
ffffffffc0204c02:	6109                	addi	sp,sp,128
ffffffffc0204c04:	8082                	ret
    if (lflag >= 2) {
ffffffffc0204c06:	4705                	li	a4,1
ffffffffc0204c08:	008a8593          	addi	a1,s5,8
ffffffffc0204c0c:	01074463          	blt	a4,a6,ffffffffc0204c14 <vprintfmt+0xbe>
    else if (lflag) {
ffffffffc0204c10:	26080363          	beqz	a6,ffffffffc0204e76 <vprintfmt+0x320>
        return va_arg(*ap, unsigned long);
ffffffffc0204c14:	000ab603          	ld	a2,0(s5)
ffffffffc0204c18:	46c1                	li	a3,16
ffffffffc0204c1a:	8aae                	mv	s5,a1
ffffffffc0204c1c:	a06d                	j	ffffffffc0204cc6 <vprintfmt+0x170>
            goto reswitch;
ffffffffc0204c1e:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0204c22:	4985                	li	s3,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204c24:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204c26:	b765                	j	ffffffffc0204bce <vprintfmt+0x78>
            putch(va_arg(ap, int), putdat);
ffffffffc0204c28:	000aa503          	lw	a0,0(s5)
ffffffffc0204c2c:	85a6                	mv	a1,s1
ffffffffc0204c2e:	0aa1                	addi	s5,s5,8
ffffffffc0204c30:	9902                	jalr	s2
            break;
ffffffffc0204c32:	bfb9                	j	ffffffffc0204b90 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204c34:	4705                	li	a4,1
ffffffffc0204c36:	008a8993          	addi	s3,s5,8
ffffffffc0204c3a:	01074463          	blt	a4,a6,ffffffffc0204c42 <vprintfmt+0xec>
    else if (lflag) {
ffffffffc0204c3e:	22080463          	beqz	a6,ffffffffc0204e66 <vprintfmt+0x310>
        return va_arg(*ap, long);
ffffffffc0204c42:	000ab403          	ld	s0,0(s5)
            if ((long long)num < 0) {
ffffffffc0204c46:	24044463          	bltz	s0,ffffffffc0204e8e <vprintfmt+0x338>
            num = getint(&ap, lflag);
ffffffffc0204c4a:	8622                	mv	a2,s0
ffffffffc0204c4c:	8ace                	mv	s5,s3
ffffffffc0204c4e:	46a9                	li	a3,10
ffffffffc0204c50:	a89d                	j	ffffffffc0204cc6 <vprintfmt+0x170>
            err = va_arg(ap, int);
ffffffffc0204c52:	000aa783          	lw	a5,0(s5)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204c56:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0204c58:	0aa1                	addi	s5,s5,8
            if (err < 0) {
ffffffffc0204c5a:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0204c5e:	8fb5                	xor	a5,a5,a3
ffffffffc0204c60:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0204c64:	1ad74363          	blt	a4,a3,ffffffffc0204e0a <vprintfmt+0x2b4>
ffffffffc0204c68:	00369793          	slli	a5,a3,0x3
ffffffffc0204c6c:	97e2                	add	a5,a5,s8
ffffffffc0204c6e:	639c                	ld	a5,0(a5)
ffffffffc0204c70:	18078d63          	beqz	a5,ffffffffc0204e0a <vprintfmt+0x2b4>
                printfmt(putch, putdat, "%s", p);
ffffffffc0204c74:	86be                	mv	a3,a5
ffffffffc0204c76:	00000617          	auipc	a2,0x0
ffffffffc0204c7a:	2b260613          	addi	a2,a2,690 # ffffffffc0204f28 <etext+0x2e>
ffffffffc0204c7e:	85a6                	mv	a1,s1
ffffffffc0204c80:	854a                	mv	a0,s2
ffffffffc0204c82:	240000ef          	jal	ra,ffffffffc0204ec2 <printfmt>
ffffffffc0204c86:	b729                	j	ffffffffc0204b90 <vprintfmt+0x3a>
            lflag ++;
ffffffffc0204c88:	00144603          	lbu	a2,1(s0)
ffffffffc0204c8c:	2805                	addiw	a6,a6,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204c8e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204c90:	bf3d                	j	ffffffffc0204bce <vprintfmt+0x78>
    if (lflag >= 2) {
ffffffffc0204c92:	4705                	li	a4,1
ffffffffc0204c94:	008a8593          	addi	a1,s5,8
ffffffffc0204c98:	01074463          	blt	a4,a6,ffffffffc0204ca0 <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc0204c9c:	1e080263          	beqz	a6,ffffffffc0204e80 <vprintfmt+0x32a>
        return va_arg(*ap, unsigned long);
ffffffffc0204ca0:	000ab603          	ld	a2,0(s5)
ffffffffc0204ca4:	46a1                	li	a3,8
ffffffffc0204ca6:	8aae                	mv	s5,a1
ffffffffc0204ca8:	a839                	j	ffffffffc0204cc6 <vprintfmt+0x170>
            putch('0', putdat);
ffffffffc0204caa:	03000513          	li	a0,48
ffffffffc0204cae:	85a6                	mv	a1,s1
ffffffffc0204cb0:	e03e                	sd	a5,0(sp)
ffffffffc0204cb2:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0204cb4:	85a6                	mv	a1,s1
ffffffffc0204cb6:	07800513          	li	a0,120
ffffffffc0204cba:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0204cbc:	0aa1                	addi	s5,s5,8
ffffffffc0204cbe:	ff8ab603          	ld	a2,-8(s5)
            goto number;
ffffffffc0204cc2:	6782                	ld	a5,0(sp)
ffffffffc0204cc4:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0204cc6:	876e                	mv	a4,s11
ffffffffc0204cc8:	85a6                	mv	a1,s1
ffffffffc0204cca:	854a                	mv	a0,s2
ffffffffc0204ccc:	e1fff0ef          	jal	ra,ffffffffc0204aea <printnum>
            break;
ffffffffc0204cd0:	b5c1                	j	ffffffffc0204b90 <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0204cd2:	000ab603          	ld	a2,0(s5)
ffffffffc0204cd6:	0aa1                	addi	s5,s5,8
ffffffffc0204cd8:	1c060663          	beqz	a2,ffffffffc0204ea4 <vprintfmt+0x34e>
            if (width > 0 && padc != '-') {
ffffffffc0204cdc:	00160413          	addi	s0,a2,1
ffffffffc0204ce0:	17b05c63          	blez	s11,ffffffffc0204e58 <vprintfmt+0x302>
ffffffffc0204ce4:	02d00593          	li	a1,45
ffffffffc0204ce8:	14b79263          	bne	a5,a1,ffffffffc0204e2c <vprintfmt+0x2d6>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204cec:	00064783          	lbu	a5,0(a2)
ffffffffc0204cf0:	0007851b          	sext.w	a0,a5
ffffffffc0204cf4:	c905                	beqz	a0,ffffffffc0204d24 <vprintfmt+0x1ce>
ffffffffc0204cf6:	000cc563          	bltz	s9,ffffffffc0204d00 <vprintfmt+0x1aa>
ffffffffc0204cfa:	3cfd                	addiw	s9,s9,-1
ffffffffc0204cfc:	036c8263          	beq	s9,s6,ffffffffc0204d20 <vprintfmt+0x1ca>
                    putch('?', putdat);
ffffffffc0204d00:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0204d02:	18098463          	beqz	s3,ffffffffc0204e8a <vprintfmt+0x334>
ffffffffc0204d06:	3781                	addiw	a5,a5,-32
ffffffffc0204d08:	18fbf163          	bleu	a5,s7,ffffffffc0204e8a <vprintfmt+0x334>
                    putch('?', putdat);
ffffffffc0204d0c:	03f00513          	li	a0,63
ffffffffc0204d10:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204d12:	0405                	addi	s0,s0,1
ffffffffc0204d14:	fff44783          	lbu	a5,-1(s0)
ffffffffc0204d18:	3dfd                	addiw	s11,s11,-1
ffffffffc0204d1a:	0007851b          	sext.w	a0,a5
ffffffffc0204d1e:	fd61                	bnez	a0,ffffffffc0204cf6 <vprintfmt+0x1a0>
            for (; width > 0; width --) {
ffffffffc0204d20:	e7b058e3          	blez	s11,ffffffffc0204b90 <vprintfmt+0x3a>
ffffffffc0204d24:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204d26:	85a6                	mv	a1,s1
ffffffffc0204d28:	02000513          	li	a0,32
ffffffffc0204d2c:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0204d2e:	e60d81e3          	beqz	s11,ffffffffc0204b90 <vprintfmt+0x3a>
ffffffffc0204d32:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0204d34:	85a6                	mv	a1,s1
ffffffffc0204d36:	02000513          	li	a0,32
ffffffffc0204d3a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0204d3c:	fe0d94e3          	bnez	s11,ffffffffc0204d24 <vprintfmt+0x1ce>
ffffffffc0204d40:	bd81                	j	ffffffffc0204b90 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0204d42:	4705                	li	a4,1
ffffffffc0204d44:	008a8593          	addi	a1,s5,8
ffffffffc0204d48:	01074463          	blt	a4,a6,ffffffffc0204d50 <vprintfmt+0x1fa>
    else if (lflag) {
ffffffffc0204d4c:	12080063          	beqz	a6,ffffffffc0204e6c <vprintfmt+0x316>
        return va_arg(*ap, unsigned long);
ffffffffc0204d50:	000ab603          	ld	a2,0(s5)
ffffffffc0204d54:	46a9                	li	a3,10
ffffffffc0204d56:	8aae                	mv	s5,a1
ffffffffc0204d58:	b7bd                	j	ffffffffc0204cc6 <vprintfmt+0x170>
ffffffffc0204d5a:	00144603          	lbu	a2,1(s0)
            padc = '-';
ffffffffc0204d5e:	02d00793          	li	a5,45
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204d62:	846a                	mv	s0,s10
ffffffffc0204d64:	b5ad                	j	ffffffffc0204bce <vprintfmt+0x78>
            putch(ch, putdat);
ffffffffc0204d66:	85a6                	mv	a1,s1
ffffffffc0204d68:	02500513          	li	a0,37
ffffffffc0204d6c:	9902                	jalr	s2
            break;
ffffffffc0204d6e:	b50d                	j	ffffffffc0204b90 <vprintfmt+0x3a>
            precision = va_arg(ap, int);
ffffffffc0204d70:	000aac83          	lw	s9,0(s5)
            goto process_precision;
ffffffffc0204d74:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0204d78:	0aa1                	addi	s5,s5,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204d7a:	846a                	mv	s0,s10
            if (width < 0)
ffffffffc0204d7c:	e40dd9e3          	bgez	s11,ffffffffc0204bce <vprintfmt+0x78>
                width = precision, precision = -1;
ffffffffc0204d80:	8de6                	mv	s11,s9
ffffffffc0204d82:	5cfd                	li	s9,-1
ffffffffc0204d84:	b5a9                	j	ffffffffc0204bce <vprintfmt+0x78>
            goto reswitch;
ffffffffc0204d86:	00144603          	lbu	a2,1(s0)
            padc = '0';
ffffffffc0204d8a:	03000793          	li	a5,48
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204d8e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0204d90:	bd3d                	j	ffffffffc0204bce <vprintfmt+0x78>
                precision = precision * 10 + ch - '0';
ffffffffc0204d92:	fd060c9b          	addiw	s9,a2,-48
                ch = *fmt;
ffffffffc0204d96:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204d9a:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0204d9c:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0204da0:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204da4:	fcd56ce3          	bltu	a0,a3,ffffffffc0204d7c <vprintfmt+0x226>
            for (precision = 0; ; ++ fmt) {
ffffffffc0204da8:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0204daa:	002c969b          	slliw	a3,s9,0x2
                ch = *fmt;
ffffffffc0204dae:	00044603          	lbu	a2,0(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0204db2:	0196873b          	addw	a4,a3,s9
ffffffffc0204db6:	0017171b          	slliw	a4,a4,0x1
ffffffffc0204dba:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
ffffffffc0204dbe:	fd06069b          	addiw	a3,a2,-48
                precision = precision * 10 + ch - '0';
ffffffffc0204dc2:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0204dc6:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc0204dca:	fcd57fe3          	bleu	a3,a0,ffffffffc0204da8 <vprintfmt+0x252>
ffffffffc0204dce:	b77d                	j	ffffffffc0204d7c <vprintfmt+0x226>
            if (width < 0)
ffffffffc0204dd0:	fffdc693          	not	a3,s11
ffffffffc0204dd4:	96fd                	srai	a3,a3,0x3f
ffffffffc0204dd6:	00ddfdb3          	and	s11,s11,a3
ffffffffc0204dda:	00144603          	lbu	a2,1(s0)
ffffffffc0204dde:	2d81                	sext.w	s11,s11
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0204de0:	846a                	mv	s0,s10
ffffffffc0204de2:	b3f5                	j	ffffffffc0204bce <vprintfmt+0x78>
            putch('%', putdat);
ffffffffc0204de4:	85a6                	mv	a1,s1
ffffffffc0204de6:	02500513          	li	a0,37
ffffffffc0204dea:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0204dec:	fff44703          	lbu	a4,-1(s0)
ffffffffc0204df0:	02500793          	li	a5,37
ffffffffc0204df4:	8d22                	mv	s10,s0
ffffffffc0204df6:	d8f70de3          	beq	a4,a5,ffffffffc0204b90 <vprintfmt+0x3a>
ffffffffc0204dfa:	02500713          	li	a4,37
ffffffffc0204dfe:	1d7d                	addi	s10,s10,-1
ffffffffc0204e00:	fffd4783          	lbu	a5,-1(s10)
ffffffffc0204e04:	fee79de3          	bne	a5,a4,ffffffffc0204dfe <vprintfmt+0x2a8>
ffffffffc0204e08:	b361                	j	ffffffffc0204b90 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0204e0a:	00002617          	auipc	a2,0x2
ffffffffc0204e0e:	1e660613          	addi	a2,a2,486 # ffffffffc0206ff0 <error_string+0xd8>
ffffffffc0204e12:	85a6                	mv	a1,s1
ffffffffc0204e14:	854a                	mv	a0,s2
ffffffffc0204e16:	0ac000ef          	jal	ra,ffffffffc0204ec2 <printfmt>
ffffffffc0204e1a:	bb9d                	j	ffffffffc0204b90 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0204e1c:	00002617          	auipc	a2,0x2
ffffffffc0204e20:	1cc60613          	addi	a2,a2,460 # ffffffffc0206fe8 <error_string+0xd0>
            if (width > 0 && padc != '-') {
ffffffffc0204e24:	00002417          	auipc	s0,0x2
ffffffffc0204e28:	1c540413          	addi	s0,s0,453 # ffffffffc0206fe9 <error_string+0xd1>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204e2c:	8532                	mv	a0,a2
ffffffffc0204e2e:	85e6                	mv	a1,s9
ffffffffc0204e30:	e032                	sd	a2,0(sp)
ffffffffc0204e32:	e43e                	sd	a5,8(sp)
ffffffffc0204e34:	bddff0ef          	jal	ra,ffffffffc0204a10 <strnlen>
ffffffffc0204e38:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0204e3c:	6602                	ld	a2,0(sp)
ffffffffc0204e3e:	01b05d63          	blez	s11,ffffffffc0204e58 <vprintfmt+0x302>
ffffffffc0204e42:	67a2                	ld	a5,8(sp)
ffffffffc0204e44:	2781                	sext.w	a5,a5
ffffffffc0204e46:	e43e                	sd	a5,8(sp)
                    putch(padc, putdat);
ffffffffc0204e48:	6522                	ld	a0,8(sp)
ffffffffc0204e4a:	85a6                	mv	a1,s1
ffffffffc0204e4c:	e032                	sd	a2,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204e4e:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0204e50:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0204e52:	6602                	ld	a2,0(sp)
ffffffffc0204e54:	fe0d9ae3          	bnez	s11,ffffffffc0204e48 <vprintfmt+0x2f2>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204e58:	00064783          	lbu	a5,0(a2)
ffffffffc0204e5c:	0007851b          	sext.w	a0,a5
ffffffffc0204e60:	e8051be3          	bnez	a0,ffffffffc0204cf6 <vprintfmt+0x1a0>
ffffffffc0204e64:	b335                	j	ffffffffc0204b90 <vprintfmt+0x3a>
        return va_arg(*ap, int);
ffffffffc0204e66:	000aa403          	lw	s0,0(s5)
ffffffffc0204e6a:	bbf1                	j	ffffffffc0204c46 <vprintfmt+0xf0>
        return va_arg(*ap, unsigned int);
ffffffffc0204e6c:	000ae603          	lwu	a2,0(s5)
ffffffffc0204e70:	46a9                	li	a3,10
ffffffffc0204e72:	8aae                	mv	s5,a1
ffffffffc0204e74:	bd89                	j	ffffffffc0204cc6 <vprintfmt+0x170>
ffffffffc0204e76:	000ae603          	lwu	a2,0(s5)
ffffffffc0204e7a:	46c1                	li	a3,16
ffffffffc0204e7c:	8aae                	mv	s5,a1
ffffffffc0204e7e:	b5a1                	j	ffffffffc0204cc6 <vprintfmt+0x170>
ffffffffc0204e80:	000ae603          	lwu	a2,0(s5)
ffffffffc0204e84:	46a1                	li	a3,8
ffffffffc0204e86:	8aae                	mv	s5,a1
ffffffffc0204e88:	bd3d                	j	ffffffffc0204cc6 <vprintfmt+0x170>
                    putch(ch, putdat);
ffffffffc0204e8a:	9902                	jalr	s2
ffffffffc0204e8c:	b559                	j	ffffffffc0204d12 <vprintfmt+0x1bc>
                putch('-', putdat);
ffffffffc0204e8e:	85a6                	mv	a1,s1
ffffffffc0204e90:	02d00513          	li	a0,45
ffffffffc0204e94:	e03e                	sd	a5,0(sp)
ffffffffc0204e96:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0204e98:	8ace                	mv	s5,s3
ffffffffc0204e9a:	40800633          	neg	a2,s0
ffffffffc0204e9e:	46a9                	li	a3,10
ffffffffc0204ea0:	6782                	ld	a5,0(sp)
ffffffffc0204ea2:	b515                	j	ffffffffc0204cc6 <vprintfmt+0x170>
            if (width > 0 && padc != '-') {
ffffffffc0204ea4:	01b05663          	blez	s11,ffffffffc0204eb0 <vprintfmt+0x35a>
ffffffffc0204ea8:	02d00693          	li	a3,45
ffffffffc0204eac:	f6d798e3          	bne	a5,a3,ffffffffc0204e1c <vprintfmt+0x2c6>
ffffffffc0204eb0:	00002417          	auipc	s0,0x2
ffffffffc0204eb4:	13940413          	addi	s0,s0,313 # ffffffffc0206fe9 <error_string+0xd1>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0204eb8:	02800513          	li	a0,40
ffffffffc0204ebc:	02800793          	li	a5,40
ffffffffc0204ec0:	bd1d                	j	ffffffffc0204cf6 <vprintfmt+0x1a0>

ffffffffc0204ec2 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204ec2:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0204ec4:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204ec8:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204eca:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0204ecc:	ec06                	sd	ra,24(sp)
ffffffffc0204ece:	f83a                	sd	a4,48(sp)
ffffffffc0204ed0:	fc3e                	sd	a5,56(sp)
ffffffffc0204ed2:	e0c2                	sd	a6,64(sp)
ffffffffc0204ed4:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0204ed6:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0204ed8:	c7fff0ef          	jal	ra,ffffffffc0204b56 <vprintfmt>
}
ffffffffc0204edc:	60e2                	ld	ra,24(sp)
ffffffffc0204ede:	6161                	addi	sp,sp,80
ffffffffc0204ee0:	8082                	ret

ffffffffc0204ee2 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0204ee2:	9e3707b7          	lui	a5,0x9e370
ffffffffc0204ee6:	2785                	addiw	a5,a5,1
ffffffffc0204ee8:	02f5053b          	mulw	a0,a0,a5
    return (hash >> (32 - bits));
ffffffffc0204eec:	02000793          	li	a5,32
ffffffffc0204ef0:	40b785bb          	subw	a1,a5,a1
}
ffffffffc0204ef4:	00b5553b          	srlw	a0,a0,a1
ffffffffc0204ef8:	8082                	ret
