
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c020b2b7          	lui	t0,0xc020b
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
ffffffffc0200028:	c020b137          	lui	sp,0xc020b

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
ffffffffc0200036:	000a1517          	auipc	a0,0xa1
ffffffffc020003a:	0da50513          	addi	a0,a0,218 # ffffffffc02a1110 <edata>
ffffffffc020003e:	000ac617          	auipc	a2,0xac
ffffffffc0200042:	66260613          	addi	a2,a2,1634 # ffffffffc02ac6a0 <end>
kern_init(void) {
ffffffffc0200046:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200048:	8e09                	sub	a2,a2,a0
ffffffffc020004a:	4581                	li	a1,0
kern_init(void) {
ffffffffc020004c:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004e:	1b0060ef          	jal	ra,ffffffffc02061fe <memset>
    cons_init();                // init the console
ffffffffc0200052:	58e000ef          	jal	ra,ffffffffc02005e0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc0200056:	00006597          	auipc	a1,0x6
ffffffffc020005a:	5e258593          	addi	a1,a1,1506 # ffffffffc0206638 <etext>
ffffffffc020005e:	00006517          	auipc	a0,0x6
ffffffffc0200062:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206658 <etext+0x20>
ffffffffc0200066:	06a000ef          	jal	ra,ffffffffc02000d0 <cprintf>

    print_kerninfo();
ffffffffc020006a:	25a000ef          	jal	ra,ffffffffc02002c4 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
ffffffffc020006e:	5e6010ef          	jal	ra,ffffffffc0201654 <pmm_init>

    pic_init();                 // init interrupt controller
ffffffffc0200072:	5e2000ef          	jal	ra,ffffffffc0200654 <pic_init>
    idt_init();                 // init interrupt descriptor table
ffffffffc0200076:	5ec000ef          	jal	ra,ffffffffc0200662 <idt_init>

    vmm_init();                 // init virtual memory management
ffffffffc020007a:	2db020ef          	jal	ra,ffffffffc0202b54 <vmm_init>
    proc_init();                // init process table
ffffffffc020007e:	58b050ef          	jal	ra,ffffffffc0205e08 <proc_init>
    
    ide_init();                 // init ide devices
ffffffffc0200082:	4b0000ef          	jal	ra,ffffffffc0200532 <ide_init>
    swap_init();                // init swap
ffffffffc0200086:	642030ef          	jal	ra,ffffffffc02036c8 <swap_init>

    clock_init();               // init clock interrupt
ffffffffc020008a:	500000ef          	jal	ra,ffffffffc020058a <clock_init>
    intr_enable();              // enable irq interrupt
ffffffffc020008e:	5c8000ef          	jal	ra,ffffffffc0200656 <intr_enable>
    
    cpu_idle();                 // run idle process
ffffffffc0200092:	6c3050ef          	jal	ra,ffffffffc0205f54 <cpu_idle>

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
ffffffffc020009e:	544000ef          	jal	ra,ffffffffc02005e2 <cons_putc>
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
ffffffffc02000c4:	1d0060ef          	jal	ra,ffffffffc0206294 <vprintfmt>
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
ffffffffc02000d2:	02810313          	addi	t1,sp,40 # ffffffffc020b028 <boot_page_table_sv39+0x28>
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
ffffffffc02000f8:	19c060ef          	jal	ra,ffffffffc0206294 <vprintfmt>
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
ffffffffc0200104:	4de0006f          	j	ffffffffc02005e2 <cons_putc>

ffffffffc0200108 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200108:	1101                	addi	sp,sp,-32
ffffffffc020010a:	e822                	sd	s0,16(sp)
ffffffffc020010c:	ec06                	sd	ra,24(sp)
ffffffffc020010e:	e426                	sd	s1,8(sp)
ffffffffc0200110:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200112:	00054503          	lbu	a0,0(a0)
ffffffffc0200116:	c51d                	beqz	a0,ffffffffc0200144 <cputs+0x3c>
ffffffffc0200118:	0405                	addi	s0,s0,1
ffffffffc020011a:	4485                	li	s1,1
ffffffffc020011c:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc020011e:	4c4000ef          	jal	ra,ffffffffc02005e2 <cons_putc>
    (*cnt) ++;
ffffffffc0200122:	008487bb          	addw	a5,s1,s0
    while ((c = *str ++) != '\0') {
ffffffffc0200126:	0405                	addi	s0,s0,1
ffffffffc0200128:	fff44503          	lbu	a0,-1(s0)
ffffffffc020012c:	f96d                	bnez	a0,ffffffffc020011e <cputs+0x16>
ffffffffc020012e:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200132:	4529                	li	a0,10
ffffffffc0200134:	4ae000ef          	jal	ra,ffffffffc02005e2 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200138:	8522                	mv	a0,s0
ffffffffc020013a:	60e2                	ld	ra,24(sp)
ffffffffc020013c:	6442                	ld	s0,16(sp)
ffffffffc020013e:	64a2                	ld	s1,8(sp)
ffffffffc0200140:	6105                	addi	sp,sp,32
ffffffffc0200142:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc0200144:	4405                	li	s0,1
ffffffffc0200146:	b7f5                	j	ffffffffc0200132 <cputs+0x2a>

ffffffffc0200148 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200148:	1141                	addi	sp,sp,-16
ffffffffc020014a:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020014c:	4cc000ef          	jal	ra,ffffffffc0200618 <cons_getc>
ffffffffc0200150:	dd75                	beqz	a0,ffffffffc020014c <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200152:	60a2                	ld	ra,8(sp)
ffffffffc0200154:	0141                	addi	sp,sp,16
ffffffffc0200156:	8082                	ret

ffffffffc0200158 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0200158:	715d                	addi	sp,sp,-80
ffffffffc020015a:	e486                	sd	ra,72(sp)
ffffffffc020015c:	e0a2                	sd	s0,64(sp)
ffffffffc020015e:	fc26                	sd	s1,56(sp)
ffffffffc0200160:	f84a                	sd	s2,48(sp)
ffffffffc0200162:	f44e                	sd	s3,40(sp)
ffffffffc0200164:	f052                	sd	s4,32(sp)
ffffffffc0200166:	ec56                	sd	s5,24(sp)
ffffffffc0200168:	e85a                	sd	s6,16(sp)
ffffffffc020016a:	e45e                	sd	s7,8(sp)
    if (prompt != NULL) {
ffffffffc020016c:	c901                	beqz	a0,ffffffffc020017c <readline+0x24>
        cprintf("%s", prompt);
ffffffffc020016e:	85aa                	mv	a1,a0
ffffffffc0200170:	00006517          	auipc	a0,0x6
ffffffffc0200174:	4f050513          	addi	a0,a0,1264 # ffffffffc0206660 <etext+0x28>
ffffffffc0200178:	f59ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
readline(const char *prompt) {
ffffffffc020017c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020017e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200180:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200182:	4aa9                	li	s5,10
ffffffffc0200184:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0200186:	000a1b97          	auipc	s7,0xa1
ffffffffc020018a:	f8ab8b93          	addi	s7,s7,-118 # ffffffffc02a1110 <edata>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020018e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0200192:	fb7ff0ef          	jal	ra,ffffffffc0200148 <getchar>
ffffffffc0200196:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0200198:	00054b63          	bltz	a0,ffffffffc02001ae <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020019c:	00a95b63          	ble	a0,s2,ffffffffc02001b2 <readline+0x5a>
ffffffffc02001a0:	029a5463          	ble	s1,s4,ffffffffc02001c8 <readline+0x70>
        c = getchar();
ffffffffc02001a4:	fa5ff0ef          	jal	ra,ffffffffc0200148 <getchar>
ffffffffc02001a8:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc02001aa:	fe0559e3          	bgez	a0,ffffffffc020019c <readline+0x44>
            return NULL;
ffffffffc02001ae:	4501                	li	a0,0
ffffffffc02001b0:	a099                	j	ffffffffc02001f6 <readline+0x9e>
        else if (c == '\b' && i > 0) {
ffffffffc02001b2:	03341463          	bne	s0,s3,ffffffffc02001da <readline+0x82>
ffffffffc02001b6:	e8b9                	bnez	s1,ffffffffc020020c <readline+0xb4>
        c = getchar();
ffffffffc02001b8:	f91ff0ef          	jal	ra,ffffffffc0200148 <getchar>
ffffffffc02001bc:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc02001be:	fe0548e3          	bltz	a0,ffffffffc02001ae <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001c2:	fea958e3          	ble	a0,s2,ffffffffc02001b2 <readline+0x5a>
ffffffffc02001c6:	4481                	li	s1,0
            cputchar(c);
ffffffffc02001c8:	8522                	mv	a0,s0
ffffffffc02001ca:	f3bff0ef          	jal	ra,ffffffffc0200104 <cputchar>
            buf[i ++] = c;
ffffffffc02001ce:	009b87b3          	add	a5,s7,s1
ffffffffc02001d2:	00878023          	sb	s0,0(a5)
ffffffffc02001d6:	2485                	addiw	s1,s1,1
ffffffffc02001d8:	bf6d                	j	ffffffffc0200192 <readline+0x3a>
        else if (c == '\n' || c == '\r') {
ffffffffc02001da:	01540463          	beq	s0,s5,ffffffffc02001e2 <readline+0x8a>
ffffffffc02001de:	fb641ae3          	bne	s0,s6,ffffffffc0200192 <readline+0x3a>
            cputchar(c);
ffffffffc02001e2:	8522                	mv	a0,s0
ffffffffc02001e4:	f21ff0ef          	jal	ra,ffffffffc0200104 <cputchar>
            buf[i] = '\0';
ffffffffc02001e8:	000a1517          	auipc	a0,0xa1
ffffffffc02001ec:	f2850513          	addi	a0,a0,-216 # ffffffffc02a1110 <edata>
ffffffffc02001f0:	94aa                	add	s1,s1,a0
ffffffffc02001f2:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02001f6:	60a6                	ld	ra,72(sp)
ffffffffc02001f8:	6406                	ld	s0,64(sp)
ffffffffc02001fa:	74e2                	ld	s1,56(sp)
ffffffffc02001fc:	7942                	ld	s2,48(sp)
ffffffffc02001fe:	79a2                	ld	s3,40(sp)
ffffffffc0200200:	7a02                	ld	s4,32(sp)
ffffffffc0200202:	6ae2                	ld	s5,24(sp)
ffffffffc0200204:	6b42                	ld	s6,16(sp)
ffffffffc0200206:	6ba2                	ld	s7,8(sp)
ffffffffc0200208:	6161                	addi	sp,sp,80
ffffffffc020020a:	8082                	ret
            cputchar(c);
ffffffffc020020c:	4521                	li	a0,8
ffffffffc020020e:	ef7ff0ef          	jal	ra,ffffffffc0200104 <cputchar>
            i --;
ffffffffc0200212:	34fd                	addiw	s1,s1,-1
ffffffffc0200214:	bfbd                	j	ffffffffc0200192 <readline+0x3a>

ffffffffc0200216 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200216:	000ac317          	auipc	t1,0xac
ffffffffc020021a:	2fa30313          	addi	t1,t1,762 # ffffffffc02ac510 <is_panic>
ffffffffc020021e:	00033303          	ld	t1,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200222:	715d                	addi	sp,sp,-80
ffffffffc0200224:	ec06                	sd	ra,24(sp)
ffffffffc0200226:	e822                	sd	s0,16(sp)
ffffffffc0200228:	f436                	sd	a3,40(sp)
ffffffffc020022a:	f83a                	sd	a4,48(sp)
ffffffffc020022c:	fc3e                	sd	a5,56(sp)
ffffffffc020022e:	e0c2                	sd	a6,64(sp)
ffffffffc0200230:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200232:	02031c63          	bnez	t1,ffffffffc020026a <__panic+0x54>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200236:	4785                	li	a5,1
ffffffffc0200238:	8432                	mv	s0,a2
ffffffffc020023a:	000ac717          	auipc	a4,0xac
ffffffffc020023e:	2cf73b23          	sd	a5,726(a4) # ffffffffc02ac510 <is_panic>

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200242:	862e                	mv	a2,a1
    va_start(ap, fmt);
ffffffffc0200244:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200246:	85aa                	mv	a1,a0
ffffffffc0200248:	00006517          	auipc	a0,0x6
ffffffffc020024c:	42050513          	addi	a0,a0,1056 # ffffffffc0206668 <etext+0x30>
    va_start(ap, fmt);
ffffffffc0200250:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200252:	e7fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200256:	65a2                	ld	a1,8(sp)
ffffffffc0200258:	8522                	mv	a0,s0
ffffffffc020025a:	e57ff0ef          	jal	ra,ffffffffc02000b0 <vcprintf>
    cprintf("\n");
ffffffffc020025e:	00007517          	auipc	a0,0x7
ffffffffc0200262:	1f250513          	addi	a0,a0,498 # ffffffffc0207450 <commands+0xca8>
ffffffffc0200266:	e6bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc020026a:	4501                	li	a0,0
ffffffffc020026c:	4581                	li	a1,0
ffffffffc020026e:	4601                	li	a2,0
ffffffffc0200270:	48a1                	li	a7,8
ffffffffc0200272:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc0200276:	3e6000ef          	jal	ra,ffffffffc020065c <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc020027a:	4501                	li	a0,0
ffffffffc020027c:	174000ef          	jal	ra,ffffffffc02003f0 <kmonitor>
ffffffffc0200280:	bfed                	j	ffffffffc020027a <__panic+0x64>

ffffffffc0200282 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200282:	715d                	addi	sp,sp,-80
ffffffffc0200284:	e822                	sd	s0,16(sp)
ffffffffc0200286:	fc3e                	sd	a5,56(sp)
ffffffffc0200288:	8432                	mv	s0,a2
    va_list ap;
    va_start(ap, fmt);
ffffffffc020028a:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020028c:	862e                	mv	a2,a1
ffffffffc020028e:	85aa                	mv	a1,a0
ffffffffc0200290:	00006517          	auipc	a0,0x6
ffffffffc0200294:	3f850513          	addi	a0,a0,1016 # ffffffffc0206688 <etext+0x50>
__warn(const char *file, int line, const char *fmt, ...) {
ffffffffc0200298:	ec06                	sd	ra,24(sp)
ffffffffc020029a:	f436                	sd	a3,40(sp)
ffffffffc020029c:	f83a                	sd	a4,48(sp)
ffffffffc020029e:	e0c2                	sd	a6,64(sp)
ffffffffc02002a0:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02002a2:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02002a4:	e2dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02002a8:	65a2                	ld	a1,8(sp)
ffffffffc02002aa:	8522                	mv	a0,s0
ffffffffc02002ac:	e05ff0ef          	jal	ra,ffffffffc02000b0 <vcprintf>
    cprintf("\n");
ffffffffc02002b0:	00007517          	auipc	a0,0x7
ffffffffc02002b4:	1a050513          	addi	a0,a0,416 # ffffffffc0207450 <commands+0xca8>
ffffffffc02002b8:	e19ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    va_end(ap);
}
ffffffffc02002bc:	60e2                	ld	ra,24(sp)
ffffffffc02002be:	6442                	ld	s0,16(sp)
ffffffffc02002c0:	6161                	addi	sp,sp,80
ffffffffc02002c2:	8082                	ret

ffffffffc02002c4 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc02002c4:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02002c6:	00006517          	auipc	a0,0x6
ffffffffc02002ca:	41250513          	addi	a0,a0,1042 # ffffffffc02066d8 <etext+0xa0>
void print_kerninfo(void) {
ffffffffc02002ce:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02002d0:	e01ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02002d4:	00000597          	auipc	a1,0x0
ffffffffc02002d8:	d6258593          	addi	a1,a1,-670 # ffffffffc0200036 <kern_init>
ffffffffc02002dc:	00006517          	auipc	a0,0x6
ffffffffc02002e0:	41c50513          	addi	a0,a0,1052 # ffffffffc02066f8 <etext+0xc0>
ffffffffc02002e4:	dedff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02002e8:	00006597          	auipc	a1,0x6
ffffffffc02002ec:	35058593          	addi	a1,a1,848 # ffffffffc0206638 <etext>
ffffffffc02002f0:	00006517          	auipc	a0,0x6
ffffffffc02002f4:	42850513          	addi	a0,a0,1064 # ffffffffc0206718 <etext+0xe0>
ffffffffc02002f8:	dd9ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc02002fc:	000a1597          	auipc	a1,0xa1
ffffffffc0200300:	e1458593          	addi	a1,a1,-492 # ffffffffc02a1110 <edata>
ffffffffc0200304:	00006517          	auipc	a0,0x6
ffffffffc0200308:	43450513          	addi	a0,a0,1076 # ffffffffc0206738 <etext+0x100>
ffffffffc020030c:	dc5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200310:	000ac597          	auipc	a1,0xac
ffffffffc0200314:	39058593          	addi	a1,a1,912 # ffffffffc02ac6a0 <end>
ffffffffc0200318:	00006517          	auipc	a0,0x6
ffffffffc020031c:	44050513          	addi	a0,a0,1088 # ffffffffc0206758 <etext+0x120>
ffffffffc0200320:	db1ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200324:	000ac597          	auipc	a1,0xac
ffffffffc0200328:	77b58593          	addi	a1,a1,1915 # ffffffffc02aca9f <end+0x3ff>
ffffffffc020032c:	00000797          	auipc	a5,0x0
ffffffffc0200330:	d0a78793          	addi	a5,a5,-758 # ffffffffc0200036 <kern_init>
ffffffffc0200334:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200338:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020033c:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020033e:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200342:	95be                	add	a1,a1,a5
ffffffffc0200344:	85a9                	srai	a1,a1,0xa
ffffffffc0200346:	00006517          	auipc	a0,0x6
ffffffffc020034a:	43250513          	addi	a0,a0,1074 # ffffffffc0206778 <etext+0x140>
}
ffffffffc020034e:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200350:	d81ff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc0200354 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200354:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200356:	00006617          	auipc	a2,0x6
ffffffffc020035a:	35260613          	addi	a2,a2,850 # ffffffffc02066a8 <etext+0x70>
ffffffffc020035e:	04d00593          	li	a1,77
ffffffffc0200362:	00006517          	auipc	a0,0x6
ffffffffc0200366:	35e50513          	addi	a0,a0,862 # ffffffffc02066c0 <etext+0x88>
void print_stackframe(void) {
ffffffffc020036a:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc020036c:	eabff0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0200370 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200370:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200372:	00006617          	auipc	a2,0x6
ffffffffc0200376:	51660613          	addi	a2,a2,1302 # ffffffffc0206888 <commands+0xe0>
ffffffffc020037a:	00006597          	auipc	a1,0x6
ffffffffc020037e:	52e58593          	addi	a1,a1,1326 # ffffffffc02068a8 <commands+0x100>
ffffffffc0200382:	00006517          	auipc	a0,0x6
ffffffffc0200386:	52e50513          	addi	a0,a0,1326 # ffffffffc02068b0 <commands+0x108>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020038a:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020038c:	d45ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0200390:	00006617          	auipc	a2,0x6
ffffffffc0200394:	53060613          	addi	a2,a2,1328 # ffffffffc02068c0 <commands+0x118>
ffffffffc0200398:	00006597          	auipc	a1,0x6
ffffffffc020039c:	55058593          	addi	a1,a1,1360 # ffffffffc02068e8 <commands+0x140>
ffffffffc02003a0:	00006517          	auipc	a0,0x6
ffffffffc02003a4:	51050513          	addi	a0,a0,1296 # ffffffffc02068b0 <commands+0x108>
ffffffffc02003a8:	d29ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc02003ac:	00006617          	auipc	a2,0x6
ffffffffc02003b0:	54c60613          	addi	a2,a2,1356 # ffffffffc02068f8 <commands+0x150>
ffffffffc02003b4:	00006597          	auipc	a1,0x6
ffffffffc02003b8:	56458593          	addi	a1,a1,1380 # ffffffffc0206918 <commands+0x170>
ffffffffc02003bc:	00006517          	auipc	a0,0x6
ffffffffc02003c0:	4f450513          	addi	a0,a0,1268 # ffffffffc02068b0 <commands+0x108>
ffffffffc02003c4:	d0dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    }
    return 0;
}
ffffffffc02003c8:	60a2                	ld	ra,8(sp)
ffffffffc02003ca:	4501                	li	a0,0
ffffffffc02003cc:	0141                	addi	sp,sp,16
ffffffffc02003ce:	8082                	ret

ffffffffc02003d0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02003d0:	1141                	addi	sp,sp,-16
ffffffffc02003d2:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02003d4:	ef1ff0ef          	jal	ra,ffffffffc02002c4 <print_kerninfo>
    return 0;
}
ffffffffc02003d8:	60a2                	ld	ra,8(sp)
ffffffffc02003da:	4501                	li	a0,0
ffffffffc02003dc:	0141                	addi	sp,sp,16
ffffffffc02003de:	8082                	ret

ffffffffc02003e0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02003e0:	1141                	addi	sp,sp,-16
ffffffffc02003e2:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02003e4:	f71ff0ef          	jal	ra,ffffffffc0200354 <print_stackframe>
    return 0;
}
ffffffffc02003e8:	60a2                	ld	ra,8(sp)
ffffffffc02003ea:	4501                	li	a0,0
ffffffffc02003ec:	0141                	addi	sp,sp,16
ffffffffc02003ee:	8082                	ret

ffffffffc02003f0 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02003f0:	7115                	addi	sp,sp,-224
ffffffffc02003f2:	e962                	sd	s8,144(sp)
ffffffffc02003f4:	8c2a                	mv	s8,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02003f6:	00006517          	auipc	a0,0x6
ffffffffc02003fa:	3fa50513          	addi	a0,a0,1018 # ffffffffc02067f0 <commands+0x48>
kmonitor(struct trapframe *tf) {
ffffffffc02003fe:	ed86                	sd	ra,216(sp)
ffffffffc0200400:	e9a2                	sd	s0,208(sp)
ffffffffc0200402:	e5a6                	sd	s1,200(sp)
ffffffffc0200404:	e1ca                	sd	s2,192(sp)
ffffffffc0200406:	fd4e                	sd	s3,184(sp)
ffffffffc0200408:	f952                	sd	s4,176(sp)
ffffffffc020040a:	f556                	sd	s5,168(sp)
ffffffffc020040c:	f15a                	sd	s6,160(sp)
ffffffffc020040e:	ed5e                	sd	s7,152(sp)
ffffffffc0200410:	e566                	sd	s9,136(sp)
ffffffffc0200412:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200414:	cbdff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200418:	00006517          	auipc	a0,0x6
ffffffffc020041c:	40050513          	addi	a0,a0,1024 # ffffffffc0206818 <commands+0x70>
ffffffffc0200420:	cb1ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    if (tf != NULL) {
ffffffffc0200424:	000c0563          	beqz	s8,ffffffffc020042e <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200428:	8562                	mv	a0,s8
ffffffffc020042a:	420000ef          	jal	ra,ffffffffc020084a <print_trapframe>
ffffffffc020042e:	00006c97          	auipc	s9,0x6
ffffffffc0200432:	37ac8c93          	addi	s9,s9,890 # ffffffffc02067a8 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200436:	00006997          	auipc	s3,0x6
ffffffffc020043a:	40a98993          	addi	s3,s3,1034 # ffffffffc0206840 <commands+0x98>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020043e:	00006917          	auipc	s2,0x6
ffffffffc0200442:	40a90913          	addi	s2,s2,1034 # ffffffffc0206848 <commands+0xa0>
        if (argc == MAXARGS - 1) {
ffffffffc0200446:	4a3d                	li	s4,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200448:	00006b17          	auipc	s6,0x6
ffffffffc020044c:	408b0b13          	addi	s6,s6,1032 # ffffffffc0206850 <commands+0xa8>
    if (argc == 0) {
ffffffffc0200450:	00006a97          	auipc	s5,0x6
ffffffffc0200454:	458a8a93          	addi	s5,s5,1112 # ffffffffc02068a8 <commands+0x100>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200458:	4b8d                	li	s7,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020045a:	854e                	mv	a0,s3
ffffffffc020045c:	cfdff0ef          	jal	ra,ffffffffc0200158 <readline>
ffffffffc0200460:	842a                	mv	s0,a0
ffffffffc0200462:	dd65                	beqz	a0,ffffffffc020045a <kmonitor+0x6a>
ffffffffc0200464:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200468:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020046a:	c999                	beqz	a1,ffffffffc0200480 <kmonitor+0x90>
ffffffffc020046c:	854a                	mv	a0,s2
ffffffffc020046e:	573050ef          	jal	ra,ffffffffc02061e0 <strchr>
ffffffffc0200472:	c925                	beqz	a0,ffffffffc02004e2 <kmonitor+0xf2>
            *buf ++ = '\0';
ffffffffc0200474:	00144583          	lbu	a1,1(s0)
ffffffffc0200478:	00040023          	sb	zero,0(s0)
ffffffffc020047c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020047e:	f5fd                	bnez	a1,ffffffffc020046c <kmonitor+0x7c>
    if (argc == 0) {
ffffffffc0200480:	dce9                	beqz	s1,ffffffffc020045a <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200482:	6582                	ld	a1,0(sp)
ffffffffc0200484:	00006d17          	auipc	s10,0x6
ffffffffc0200488:	324d0d13          	addi	s10,s10,804 # ffffffffc02067a8 <commands>
    if (argc == 0) {
ffffffffc020048c:	8556                	mv	a0,s5
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020048e:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200490:	0d61                	addi	s10,s10,24
ffffffffc0200492:	525050ef          	jal	ra,ffffffffc02061b6 <strcmp>
ffffffffc0200496:	c919                	beqz	a0,ffffffffc02004ac <kmonitor+0xbc>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200498:	2405                	addiw	s0,s0,1
ffffffffc020049a:	09740463          	beq	s0,s7,ffffffffc0200522 <kmonitor+0x132>
ffffffffc020049e:	000d3503          	ld	a0,0(s10)
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02004a2:	6582                	ld	a1,0(sp)
ffffffffc02004a4:	0d61                	addi	s10,s10,24
ffffffffc02004a6:	511050ef          	jal	ra,ffffffffc02061b6 <strcmp>
ffffffffc02004aa:	f57d                	bnez	a0,ffffffffc0200498 <kmonitor+0xa8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02004ac:	00141793          	slli	a5,s0,0x1
ffffffffc02004b0:	97a2                	add	a5,a5,s0
ffffffffc02004b2:	078e                	slli	a5,a5,0x3
ffffffffc02004b4:	97e6                	add	a5,a5,s9
ffffffffc02004b6:	6b9c                	ld	a5,16(a5)
ffffffffc02004b8:	8662                	mv	a2,s8
ffffffffc02004ba:	002c                	addi	a1,sp,8
ffffffffc02004bc:	fff4851b          	addiw	a0,s1,-1
ffffffffc02004c0:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02004c2:	f8055ce3          	bgez	a0,ffffffffc020045a <kmonitor+0x6a>
}
ffffffffc02004c6:	60ee                	ld	ra,216(sp)
ffffffffc02004c8:	644e                	ld	s0,208(sp)
ffffffffc02004ca:	64ae                	ld	s1,200(sp)
ffffffffc02004cc:	690e                	ld	s2,192(sp)
ffffffffc02004ce:	79ea                	ld	s3,184(sp)
ffffffffc02004d0:	7a4a                	ld	s4,176(sp)
ffffffffc02004d2:	7aaa                	ld	s5,168(sp)
ffffffffc02004d4:	7b0a                	ld	s6,160(sp)
ffffffffc02004d6:	6bea                	ld	s7,152(sp)
ffffffffc02004d8:	6c4a                	ld	s8,144(sp)
ffffffffc02004da:	6caa                	ld	s9,136(sp)
ffffffffc02004dc:	6d0a                	ld	s10,128(sp)
ffffffffc02004de:	612d                	addi	sp,sp,224
ffffffffc02004e0:	8082                	ret
        if (*buf == '\0') {
ffffffffc02004e2:	00044783          	lbu	a5,0(s0)
ffffffffc02004e6:	dfc9                	beqz	a5,ffffffffc0200480 <kmonitor+0x90>
        if (argc == MAXARGS - 1) {
ffffffffc02004e8:	03448863          	beq	s1,s4,ffffffffc0200518 <kmonitor+0x128>
        argv[argc ++] = buf;
ffffffffc02004ec:	00349793          	slli	a5,s1,0x3
ffffffffc02004f0:	0118                	addi	a4,sp,128
ffffffffc02004f2:	97ba                	add	a5,a5,a4
ffffffffc02004f4:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02004f8:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02004fc:	2485                	addiw	s1,s1,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02004fe:	e591                	bnez	a1,ffffffffc020050a <kmonitor+0x11a>
ffffffffc0200500:	b749                	j	ffffffffc0200482 <kmonitor+0x92>
            buf ++;
ffffffffc0200502:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200504:	00044583          	lbu	a1,0(s0)
ffffffffc0200508:	ddad                	beqz	a1,ffffffffc0200482 <kmonitor+0x92>
ffffffffc020050a:	854a                	mv	a0,s2
ffffffffc020050c:	4d5050ef          	jal	ra,ffffffffc02061e0 <strchr>
ffffffffc0200510:	d96d                	beqz	a0,ffffffffc0200502 <kmonitor+0x112>
ffffffffc0200512:	00044583          	lbu	a1,0(s0)
ffffffffc0200516:	bf91                	j	ffffffffc020046a <kmonitor+0x7a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200518:	45c1                	li	a1,16
ffffffffc020051a:	855a                	mv	a0,s6
ffffffffc020051c:	bb5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0200520:	b7f1                	j	ffffffffc02004ec <kmonitor+0xfc>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200522:	6582                	ld	a1,0(sp)
ffffffffc0200524:	00006517          	auipc	a0,0x6
ffffffffc0200528:	34c50513          	addi	a0,a0,844 # ffffffffc0206870 <commands+0xc8>
ffffffffc020052c:	ba5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    return 0;
ffffffffc0200530:	b72d                	j	ffffffffc020045a <kmonitor+0x6a>

ffffffffc0200532 <ide_init>:
#include <stdio.h>
#include <string.h>
#include <trap.h>
#include <riscv.h>

void ide_init(void) {}
ffffffffc0200532:	8082                	ret

ffffffffc0200534 <ide_device_valid>:

#define MAX_IDE 2
#define MAX_DISK_NSECS 56
static char ide[MAX_DISK_NSECS * SECTSIZE];

bool ide_device_valid(unsigned short ideno) { return ideno < MAX_IDE; }
ffffffffc0200534:	00253513          	sltiu	a0,a0,2
ffffffffc0200538:	8082                	ret

ffffffffc020053a <ide_device_size>:

size_t ide_device_size(unsigned short ideno) { return MAX_DISK_NSECS; }
ffffffffc020053a:	03800513          	li	a0,56
ffffffffc020053e:	8082                	ret

ffffffffc0200540 <ide_read_secs>:

int ide_read_secs(unsigned short ideno, uint32_t secno, void *dst,
                  size_t nsecs) {
    int iobase = secno * SECTSIZE;
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc0200540:	000a1797          	auipc	a5,0xa1
ffffffffc0200544:	fd078793          	addi	a5,a5,-48 # ffffffffc02a1510 <ide>
ffffffffc0200548:	0095959b          	slliw	a1,a1,0x9
                  size_t nsecs) {
ffffffffc020054c:	1141                	addi	sp,sp,-16
ffffffffc020054e:	8532                	mv	a0,a2
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc0200550:	95be                	add	a1,a1,a5
ffffffffc0200552:	00969613          	slli	a2,a3,0x9
                  size_t nsecs) {
ffffffffc0200556:	e406                	sd	ra,8(sp)
    memcpy(dst, &ide[iobase], nsecs * SECTSIZE);
ffffffffc0200558:	4b9050ef          	jal	ra,ffffffffc0206210 <memcpy>
    return 0;
}
ffffffffc020055c:	60a2                	ld	ra,8(sp)
ffffffffc020055e:	4501                	li	a0,0
ffffffffc0200560:	0141                	addi	sp,sp,16
ffffffffc0200562:	8082                	ret

ffffffffc0200564 <ide_write_secs>:

int ide_write_secs(unsigned short ideno, uint32_t secno, const void *src,
                   size_t nsecs) {
ffffffffc0200564:	8732                	mv	a4,a2
    int iobase = secno * SECTSIZE;
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200566:	0095979b          	slliw	a5,a1,0x9
ffffffffc020056a:	000a1517          	auipc	a0,0xa1
ffffffffc020056e:	fa650513          	addi	a0,a0,-90 # ffffffffc02a1510 <ide>
                   size_t nsecs) {
ffffffffc0200572:	1141                	addi	sp,sp,-16
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc0200574:	00969613          	slli	a2,a3,0x9
ffffffffc0200578:	85ba                	mv	a1,a4
ffffffffc020057a:	953e                	add	a0,a0,a5
                   size_t nsecs) {
ffffffffc020057c:	e406                	sd	ra,8(sp)
    memcpy(&ide[iobase], src, nsecs * SECTSIZE);
ffffffffc020057e:	493050ef          	jal	ra,ffffffffc0206210 <memcpy>
    return 0;
}
ffffffffc0200582:	60a2                	ld	ra,8(sp)
ffffffffc0200584:	4501                	li	a0,0
ffffffffc0200586:	0141                	addi	sp,sp,16
ffffffffc0200588:	8082                	ret

ffffffffc020058a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020058a:	67e1                	lui	a5,0x18
ffffffffc020058c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xdc18>
ffffffffc0200590:	000ac717          	auipc	a4,0xac
ffffffffc0200594:	f8f73423          	sd	a5,-120(a4) # ffffffffc02ac518 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200598:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020059c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020059e:	953e                	add	a0,a0,a5
ffffffffc02005a0:	4601                	li	a2,0
ffffffffc02005a2:	4881                	li	a7,0
ffffffffc02005a4:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc02005a8:	02000793          	li	a5,32
ffffffffc02005ac:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc02005b0:	00006517          	auipc	a0,0x6
ffffffffc02005b4:	37850513          	addi	a0,a0,888 # ffffffffc0206928 <commands+0x180>
    ticks = 0;
ffffffffc02005b8:	000ac797          	auipc	a5,0xac
ffffffffc02005bc:	fa07bc23          	sd	zero,-72(a5) # ffffffffc02ac570 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02005c0:	b11ff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc02005c4 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02005c4:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02005c8:	000ac797          	auipc	a5,0xac
ffffffffc02005cc:	f5078793          	addi	a5,a5,-176 # ffffffffc02ac518 <timebase>
ffffffffc02005d0:	639c                	ld	a5,0(a5)
ffffffffc02005d2:	4581                	li	a1,0
ffffffffc02005d4:	4601                	li	a2,0
ffffffffc02005d6:	953e                	add	a0,a0,a5
ffffffffc02005d8:	4881                	li	a7,0
ffffffffc02005da:	00000073          	ecall
ffffffffc02005de:	8082                	ret

ffffffffc02005e0 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02005e0:	8082                	ret

ffffffffc02005e2 <cons_putc>:
#include <sched.h>
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02005e2:	100027f3          	csrr	a5,sstatus
ffffffffc02005e6:	8b89                	andi	a5,a5,2
ffffffffc02005e8:	0ff57513          	andi	a0,a0,255
ffffffffc02005ec:	e799                	bnez	a5,ffffffffc02005fa <cons_putc+0x18>
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02005ee:	4581                	li	a1,0
ffffffffc02005f0:	4601                	li	a2,0
ffffffffc02005f2:	4885                	li	a7,1
ffffffffc02005f4:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02005f8:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005fa:	1101                	addi	sp,sp,-32
ffffffffc02005fc:	ec06                	sd	ra,24(sp)
ffffffffc02005fe:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200600:	05c000ef          	jal	ra,ffffffffc020065c <intr_disable>
ffffffffc0200604:	6522                	ld	a0,8(sp)
ffffffffc0200606:	4581                	li	a1,0
ffffffffc0200608:	4601                	li	a2,0
ffffffffc020060a:	4885                	li	a7,1
ffffffffc020060c:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200610:	60e2                	ld	ra,24(sp)
ffffffffc0200612:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200614:	0420006f          	j	ffffffffc0200656 <intr_enable>

ffffffffc0200618 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200618:	100027f3          	csrr	a5,sstatus
ffffffffc020061c:	8b89                	andi	a5,a5,2
ffffffffc020061e:	eb89                	bnez	a5,ffffffffc0200630 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200620:	4501                	li	a0,0
ffffffffc0200622:	4581                	li	a1,0
ffffffffc0200624:	4601                	li	a2,0
ffffffffc0200626:	4889                	li	a7,2
ffffffffc0200628:	00000073          	ecall
ffffffffc020062c:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc020062e:	8082                	ret
int cons_getc(void) {
ffffffffc0200630:	1101                	addi	sp,sp,-32
ffffffffc0200632:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200634:	028000ef          	jal	ra,ffffffffc020065c <intr_disable>
ffffffffc0200638:	4501                	li	a0,0
ffffffffc020063a:	4581                	li	a1,0
ffffffffc020063c:	4601                	li	a2,0
ffffffffc020063e:	4889                	li	a7,2
ffffffffc0200640:	00000073          	ecall
ffffffffc0200644:	2501                	sext.w	a0,a0
ffffffffc0200646:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200648:	00e000ef          	jal	ra,ffffffffc0200656 <intr_enable>
}
ffffffffc020064c:	60e2                	ld	ra,24(sp)
ffffffffc020064e:	6522                	ld	a0,8(sp)
ffffffffc0200650:	6105                	addi	sp,sp,32
ffffffffc0200652:	8082                	ret

ffffffffc0200654 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200654:	8082                	ret

ffffffffc0200656 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200656:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020065a:	8082                	ret

ffffffffc020065c <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020065c:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200660:	8082                	ret

ffffffffc0200662 <idt_init>:
void
idt_init(void) {
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200662:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200666:	00000797          	auipc	a5,0x0
ffffffffc020066a:	67a78793          	addi	a5,a5,1658 # ffffffffc0200ce0 <__alltraps>
ffffffffc020066e:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200672:	000407b7          	lui	a5,0x40
ffffffffc0200676:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc020067a:	8082                	ret

ffffffffc020067c <print_regs>:
    cprintf("  tval 0x%08x\n", tf->tval);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs* gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020067c:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs* gpr) {
ffffffffc020067e:	1141                	addi	sp,sp,-16
ffffffffc0200680:	e022                	sd	s0,0(sp)
ffffffffc0200682:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200684:	00006517          	auipc	a0,0x6
ffffffffc0200688:	5ec50513          	addi	a0,a0,1516 # ffffffffc0206c70 <commands+0x4c8>
void print_regs(struct pushregs* gpr) {
ffffffffc020068c:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020068e:	a43ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200692:	640c                	ld	a1,8(s0)
ffffffffc0200694:	00006517          	auipc	a0,0x6
ffffffffc0200698:	5f450513          	addi	a0,a0,1524 # ffffffffc0206c88 <commands+0x4e0>
ffffffffc020069c:	a35ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02006a0:	680c                	ld	a1,16(s0)
ffffffffc02006a2:	00006517          	auipc	a0,0x6
ffffffffc02006a6:	5fe50513          	addi	a0,a0,1534 # ffffffffc0206ca0 <commands+0x4f8>
ffffffffc02006aa:	a27ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02006ae:	6c0c                	ld	a1,24(s0)
ffffffffc02006b0:	00006517          	auipc	a0,0x6
ffffffffc02006b4:	60850513          	addi	a0,a0,1544 # ffffffffc0206cb8 <commands+0x510>
ffffffffc02006b8:	a19ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02006bc:	700c                	ld	a1,32(s0)
ffffffffc02006be:	00006517          	auipc	a0,0x6
ffffffffc02006c2:	61250513          	addi	a0,a0,1554 # ffffffffc0206cd0 <commands+0x528>
ffffffffc02006c6:	a0bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02006ca:	740c                	ld	a1,40(s0)
ffffffffc02006cc:	00006517          	auipc	a0,0x6
ffffffffc02006d0:	61c50513          	addi	a0,a0,1564 # ffffffffc0206ce8 <commands+0x540>
ffffffffc02006d4:	9fdff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02006d8:	780c                	ld	a1,48(s0)
ffffffffc02006da:	00006517          	auipc	a0,0x6
ffffffffc02006de:	62650513          	addi	a0,a0,1574 # ffffffffc0206d00 <commands+0x558>
ffffffffc02006e2:	9efff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02006e6:	7c0c                	ld	a1,56(s0)
ffffffffc02006e8:	00006517          	auipc	a0,0x6
ffffffffc02006ec:	63050513          	addi	a0,a0,1584 # ffffffffc0206d18 <commands+0x570>
ffffffffc02006f0:	9e1ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02006f4:	602c                	ld	a1,64(s0)
ffffffffc02006f6:	00006517          	auipc	a0,0x6
ffffffffc02006fa:	63a50513          	addi	a0,a0,1594 # ffffffffc0206d30 <commands+0x588>
ffffffffc02006fe:	9d3ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200702:	642c                	ld	a1,72(s0)
ffffffffc0200704:	00006517          	auipc	a0,0x6
ffffffffc0200708:	64450513          	addi	a0,a0,1604 # ffffffffc0206d48 <commands+0x5a0>
ffffffffc020070c:	9c5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200710:	682c                	ld	a1,80(s0)
ffffffffc0200712:	00006517          	auipc	a0,0x6
ffffffffc0200716:	64e50513          	addi	a0,a0,1614 # ffffffffc0206d60 <commands+0x5b8>
ffffffffc020071a:	9b7ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020071e:	6c2c                	ld	a1,88(s0)
ffffffffc0200720:	00006517          	auipc	a0,0x6
ffffffffc0200724:	65850513          	addi	a0,a0,1624 # ffffffffc0206d78 <commands+0x5d0>
ffffffffc0200728:	9a9ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc020072c:	702c                	ld	a1,96(s0)
ffffffffc020072e:	00006517          	auipc	a0,0x6
ffffffffc0200732:	66250513          	addi	a0,a0,1634 # ffffffffc0206d90 <commands+0x5e8>
ffffffffc0200736:	99bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020073a:	742c                	ld	a1,104(s0)
ffffffffc020073c:	00006517          	auipc	a0,0x6
ffffffffc0200740:	66c50513          	addi	a0,a0,1644 # ffffffffc0206da8 <commands+0x600>
ffffffffc0200744:	98dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200748:	782c                	ld	a1,112(s0)
ffffffffc020074a:	00006517          	auipc	a0,0x6
ffffffffc020074e:	67650513          	addi	a0,a0,1654 # ffffffffc0206dc0 <commands+0x618>
ffffffffc0200752:	97fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200756:	7c2c                	ld	a1,120(s0)
ffffffffc0200758:	00006517          	auipc	a0,0x6
ffffffffc020075c:	68050513          	addi	a0,a0,1664 # ffffffffc0206dd8 <commands+0x630>
ffffffffc0200760:	971ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200764:	604c                	ld	a1,128(s0)
ffffffffc0200766:	00006517          	auipc	a0,0x6
ffffffffc020076a:	68a50513          	addi	a0,a0,1674 # ffffffffc0206df0 <commands+0x648>
ffffffffc020076e:	963ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200772:	644c                	ld	a1,136(s0)
ffffffffc0200774:	00006517          	auipc	a0,0x6
ffffffffc0200778:	69450513          	addi	a0,a0,1684 # ffffffffc0206e08 <commands+0x660>
ffffffffc020077c:	955ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200780:	684c                	ld	a1,144(s0)
ffffffffc0200782:	00006517          	auipc	a0,0x6
ffffffffc0200786:	69e50513          	addi	a0,a0,1694 # ffffffffc0206e20 <commands+0x678>
ffffffffc020078a:	947ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020078e:	6c4c                	ld	a1,152(s0)
ffffffffc0200790:	00006517          	auipc	a0,0x6
ffffffffc0200794:	6a850513          	addi	a0,a0,1704 # ffffffffc0206e38 <commands+0x690>
ffffffffc0200798:	939ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc020079c:	704c                	ld	a1,160(s0)
ffffffffc020079e:	00006517          	auipc	a0,0x6
ffffffffc02007a2:	6b250513          	addi	a0,a0,1714 # ffffffffc0206e50 <commands+0x6a8>
ffffffffc02007a6:	92bff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02007aa:	744c                	ld	a1,168(s0)
ffffffffc02007ac:	00006517          	auipc	a0,0x6
ffffffffc02007b0:	6bc50513          	addi	a0,a0,1724 # ffffffffc0206e68 <commands+0x6c0>
ffffffffc02007b4:	91dff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02007b8:	784c                	ld	a1,176(s0)
ffffffffc02007ba:	00006517          	auipc	a0,0x6
ffffffffc02007be:	6c650513          	addi	a0,a0,1734 # ffffffffc0206e80 <commands+0x6d8>
ffffffffc02007c2:	90fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02007c6:	7c4c                	ld	a1,184(s0)
ffffffffc02007c8:	00006517          	auipc	a0,0x6
ffffffffc02007cc:	6d050513          	addi	a0,a0,1744 # ffffffffc0206e98 <commands+0x6f0>
ffffffffc02007d0:	901ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02007d4:	606c                	ld	a1,192(s0)
ffffffffc02007d6:	00006517          	auipc	a0,0x6
ffffffffc02007da:	6da50513          	addi	a0,a0,1754 # ffffffffc0206eb0 <commands+0x708>
ffffffffc02007de:	8f3ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02007e2:	646c                	ld	a1,200(s0)
ffffffffc02007e4:	00006517          	auipc	a0,0x6
ffffffffc02007e8:	6e450513          	addi	a0,a0,1764 # ffffffffc0206ec8 <commands+0x720>
ffffffffc02007ec:	8e5ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02007f0:	686c                	ld	a1,208(s0)
ffffffffc02007f2:	00006517          	auipc	a0,0x6
ffffffffc02007f6:	6ee50513          	addi	a0,a0,1774 # ffffffffc0206ee0 <commands+0x738>
ffffffffc02007fa:	8d7ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02007fe:	6c6c                	ld	a1,216(s0)
ffffffffc0200800:	00006517          	auipc	a0,0x6
ffffffffc0200804:	6f850513          	addi	a0,a0,1784 # ffffffffc0206ef8 <commands+0x750>
ffffffffc0200808:	8c9ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc020080c:	706c                	ld	a1,224(s0)
ffffffffc020080e:	00006517          	auipc	a0,0x6
ffffffffc0200812:	70250513          	addi	a0,a0,1794 # ffffffffc0206f10 <commands+0x768>
ffffffffc0200816:	8bbff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc020081a:	746c                	ld	a1,232(s0)
ffffffffc020081c:	00006517          	auipc	a0,0x6
ffffffffc0200820:	70c50513          	addi	a0,a0,1804 # ffffffffc0206f28 <commands+0x780>
ffffffffc0200824:	8adff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200828:	786c                	ld	a1,240(s0)
ffffffffc020082a:	00006517          	auipc	a0,0x6
ffffffffc020082e:	71650513          	addi	a0,a0,1814 # ffffffffc0206f40 <commands+0x798>
ffffffffc0200832:	89fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200836:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200838:	6402                	ld	s0,0(sp)
ffffffffc020083a:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc020083c:	00006517          	auipc	a0,0x6
ffffffffc0200840:	71c50513          	addi	a0,a0,1820 # ffffffffc0206f58 <commands+0x7b0>
}
ffffffffc0200844:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200846:	88bff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc020084a <print_trapframe>:
print_trapframe(struct trapframe *tf) {
ffffffffc020084a:	1141                	addi	sp,sp,-16
ffffffffc020084c:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020084e:	85aa                	mv	a1,a0
print_trapframe(struct trapframe *tf) {
ffffffffc0200850:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200852:	00006517          	auipc	a0,0x6
ffffffffc0200856:	71e50513          	addi	a0,a0,1822 # ffffffffc0206f70 <commands+0x7c8>
print_trapframe(struct trapframe *tf) {
ffffffffc020085a:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020085c:	875ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200860:	8522                	mv	a0,s0
ffffffffc0200862:	e1bff0ef          	jal	ra,ffffffffc020067c <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200866:	10043583          	ld	a1,256(s0)
ffffffffc020086a:	00006517          	auipc	a0,0x6
ffffffffc020086e:	71e50513          	addi	a0,a0,1822 # ffffffffc0206f88 <commands+0x7e0>
ffffffffc0200872:	85fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200876:	10843583          	ld	a1,264(s0)
ffffffffc020087a:	00006517          	auipc	a0,0x6
ffffffffc020087e:	72650513          	addi	a0,a0,1830 # ffffffffc0206fa0 <commands+0x7f8>
ffffffffc0200882:	84fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200886:	11043583          	ld	a1,272(s0)
ffffffffc020088a:	00006517          	auipc	a0,0x6
ffffffffc020088e:	72e50513          	addi	a0,a0,1838 # ffffffffc0206fb8 <commands+0x810>
ffffffffc0200892:	83fff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200896:	11843583          	ld	a1,280(s0)
}
ffffffffc020089a:	6402                	ld	s0,0(sp)
ffffffffc020089c:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020089e:	00006517          	auipc	a0,0x6
ffffffffc02008a2:	72a50513          	addi	a0,a0,1834 # ffffffffc0206fc8 <commands+0x820>
}
ffffffffc02008a6:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02008a8:	829ff06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc02008ac <pgfault_handler>:
            trap_in_kernel(tf) ? 'K' : 'U',
            tf->cause == CAUSE_STORE_PAGE_FAULT ? 'W' : 'R');
}

static int
pgfault_handler(struct trapframe *tf) {
ffffffffc02008ac:	1101                	addi	sp,sp,-32
ffffffffc02008ae:	e426                	sd	s1,8(sp)
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
ffffffffc02008b0:	000ac497          	auipc	s1,0xac
ffffffffc02008b4:	cf848493          	addi	s1,s1,-776 # ffffffffc02ac5a8 <check_mm_struct>
ffffffffc02008b8:	609c                	ld	a5,0(s1)
pgfault_handler(struct trapframe *tf) {
ffffffffc02008ba:	e822                	sd	s0,16(sp)
ffffffffc02008bc:	ec06                	sd	ra,24(sp)
ffffffffc02008be:	842a                	mv	s0,a0
    if(check_mm_struct !=NULL) { //used for test check_swap
ffffffffc02008c0:	cbbd                	beqz	a5,ffffffffc0200936 <pgfault_handler+0x8a>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02008c2:	10053783          	ld	a5,256(a0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008c6:	11053583          	ld	a1,272(a0)
ffffffffc02008ca:	04b00613          	li	a2,75
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc02008ce:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02008d2:	cba1                	beqz	a5,ffffffffc0200922 <pgfault_handler+0x76>
ffffffffc02008d4:	11843703          	ld	a4,280(s0)
ffffffffc02008d8:	47bd                	li	a5,15
ffffffffc02008da:	05700693          	li	a3,87
ffffffffc02008de:	00f70463          	beq	a4,a5,ffffffffc02008e6 <pgfault_handler+0x3a>
ffffffffc02008e2:	05200693          	li	a3,82
ffffffffc02008e6:	00006517          	auipc	a0,0x6
ffffffffc02008ea:	30a50513          	addi	a0,a0,778 # ffffffffc0206bf0 <commands+0x448>
ffffffffc02008ee:	fe2ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            print_pgfault(tf);
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
ffffffffc02008f2:	6088                	ld	a0,0(s1)
ffffffffc02008f4:	c129                	beqz	a0,ffffffffc0200936 <pgfault_handler+0x8a>
        assert(current == idleproc);
ffffffffc02008f6:	000ac797          	auipc	a5,0xac
ffffffffc02008fa:	c5a78793          	addi	a5,a5,-934 # ffffffffc02ac550 <current>
ffffffffc02008fe:	6398                	ld	a4,0(a5)
ffffffffc0200900:	000ac797          	auipc	a5,0xac
ffffffffc0200904:	c5878793          	addi	a5,a5,-936 # ffffffffc02ac558 <idleproc>
ffffffffc0200908:	639c                	ld	a5,0(a5)
ffffffffc020090a:	04f71763          	bne	a4,a5,ffffffffc0200958 <pgfault_handler+0xac>
            print_pgfault(tf);
            panic("unhandled page fault.\n");
        }
        mm = current->mm;
    }
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc020090e:	11043603          	ld	a2,272(s0)
ffffffffc0200912:	11843583          	ld	a1,280(s0)
}
ffffffffc0200916:	6442                	ld	s0,16(sp)
ffffffffc0200918:	60e2                	ld	ra,24(sp)
ffffffffc020091a:	64a2                	ld	s1,8(sp)
ffffffffc020091c:	6105                	addi	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc020091e:	77c0206f          	j	ffffffffc020309a <do_pgfault>
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200922:	11843703          	ld	a4,280(s0)
ffffffffc0200926:	47bd                	li	a5,15
ffffffffc0200928:	05500613          	li	a2,85
ffffffffc020092c:	05700693          	li	a3,87
ffffffffc0200930:	faf719e3          	bne	a4,a5,ffffffffc02008e2 <pgfault_handler+0x36>
ffffffffc0200934:	bf4d                	j	ffffffffc02008e6 <pgfault_handler+0x3a>
        if (current == NULL) {
ffffffffc0200936:	000ac797          	auipc	a5,0xac
ffffffffc020093a:	c1a78793          	addi	a5,a5,-998 # ffffffffc02ac550 <current>
ffffffffc020093e:	639c                	ld	a5,0(a5)
ffffffffc0200940:	cf85                	beqz	a5,ffffffffc0200978 <pgfault_handler+0xcc>
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200942:	11043603          	ld	a2,272(s0)
ffffffffc0200946:	11843583          	ld	a1,280(s0)
}
ffffffffc020094a:	6442                	ld	s0,16(sp)
ffffffffc020094c:	60e2                	ld	ra,24(sp)
ffffffffc020094e:	64a2                	ld	s1,8(sp)
        mm = current->mm;
ffffffffc0200950:	7788                	ld	a0,40(a5)
}
ffffffffc0200952:	6105                	addi	sp,sp,32
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200954:	7460206f          	j	ffffffffc020309a <do_pgfault>
        assert(current == idleproc);
ffffffffc0200958:	00006697          	auipc	a3,0x6
ffffffffc020095c:	2b868693          	addi	a3,a3,696 # ffffffffc0206c10 <commands+0x468>
ffffffffc0200960:	00006617          	auipc	a2,0x6
ffffffffc0200964:	2c860613          	addi	a2,a2,712 # ffffffffc0206c28 <commands+0x480>
ffffffffc0200968:	06b00593          	li	a1,107
ffffffffc020096c:	00006517          	auipc	a0,0x6
ffffffffc0200970:	2d450513          	addi	a0,a0,724 # ffffffffc0206c40 <commands+0x498>
ffffffffc0200974:	8a3ff0ef          	jal	ra,ffffffffc0200216 <__panic>
            print_trapframe(tf);
ffffffffc0200978:	8522                	mv	a0,s0
ffffffffc020097a:	ed1ff0ef          	jal	ra,ffffffffc020084a <print_trapframe>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020097e:	10043783          	ld	a5,256(s0)
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc0200982:	11043583          	ld	a1,272(s0)
ffffffffc0200986:	04b00613          	li	a2,75
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc020098a:	1007f793          	andi	a5,a5,256
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc020098e:	e399                	bnez	a5,ffffffffc0200994 <pgfault_handler+0xe8>
ffffffffc0200990:	05500613          	li	a2,85
ffffffffc0200994:	11843703          	ld	a4,280(s0)
ffffffffc0200998:	47bd                	li	a5,15
ffffffffc020099a:	02f70663          	beq	a4,a5,ffffffffc02009c6 <pgfault_handler+0x11a>
ffffffffc020099e:	05200693          	li	a3,82
ffffffffc02009a2:	00006517          	auipc	a0,0x6
ffffffffc02009a6:	24e50513          	addi	a0,a0,590 # ffffffffc0206bf0 <commands+0x448>
ffffffffc02009aa:	f26ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            panic("unhandled page fault.\n");
ffffffffc02009ae:	00006617          	auipc	a2,0x6
ffffffffc02009b2:	2aa60613          	addi	a2,a2,682 # ffffffffc0206c58 <commands+0x4b0>
ffffffffc02009b6:	07200593          	li	a1,114
ffffffffc02009ba:	00006517          	auipc	a0,0x6
ffffffffc02009be:	28650513          	addi	a0,a0,646 # ffffffffc0206c40 <commands+0x498>
ffffffffc02009c2:	855ff0ef          	jal	ra,ffffffffc0200216 <__panic>
    cprintf("page fault at 0x%08x: %c/%c\n", tf->tval,
ffffffffc02009c6:	05700693          	li	a3,87
ffffffffc02009ca:	bfe1                	j	ffffffffc02009a2 <pgfault_handler+0xf6>

ffffffffc02009cc <interrupt_handler>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02009cc:	11853783          	ld	a5,280(a0)
ffffffffc02009d0:	577d                	li	a4,-1
ffffffffc02009d2:	8305                	srli	a4,a4,0x1
ffffffffc02009d4:	8ff9                	and	a5,a5,a4
    switch (cause) {
ffffffffc02009d6:	472d                	li	a4,11
ffffffffc02009d8:	08f76763          	bltu	a4,a5,ffffffffc0200a66 <interrupt_handler+0x9a>
ffffffffc02009dc:	00006717          	auipc	a4,0x6
ffffffffc02009e0:	f6870713          	addi	a4,a4,-152 # ffffffffc0206944 <commands+0x19c>
ffffffffc02009e4:	078a                	slli	a5,a5,0x2
ffffffffc02009e6:	97ba                	add	a5,a5,a4
ffffffffc02009e8:	439c                	lw	a5,0(a5)
ffffffffc02009ea:	97ba                	add	a5,a5,a4
ffffffffc02009ec:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02009ee:	00006517          	auipc	a0,0x6
ffffffffc02009f2:	1c250513          	addi	a0,a0,450 # ffffffffc0206bb0 <commands+0x408>
ffffffffc02009f6:	edaff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02009fa:	00006517          	auipc	a0,0x6
ffffffffc02009fe:	19650513          	addi	a0,a0,406 # ffffffffc0206b90 <commands+0x3e8>
ffffffffc0200a02:	eceff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200a06:	00006517          	auipc	a0,0x6
ffffffffc0200a0a:	14a50513          	addi	a0,a0,330 # ffffffffc0206b50 <commands+0x3a8>
ffffffffc0200a0e:	ec2ff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200a12:	00006517          	auipc	a0,0x6
ffffffffc0200a16:	15e50513          	addi	a0,a0,350 # ffffffffc0206b70 <commands+0x3c8>
ffffffffc0200a1a:	eb6ff06f          	j	ffffffffc02000d0 <cprintf>
            break;
        case IRQ_U_EXT:
            cprintf("User software interrupt\n");
            break;
        case IRQ_S_EXT:
            cprintf("Supervisor external interrupt\n");
ffffffffc0200a1e:	00006517          	auipc	a0,0x6
ffffffffc0200a22:	1b250513          	addi	a0,a0,434 # ffffffffc0206bd0 <commands+0x428>
ffffffffc0200a26:	eaaff06f          	j	ffffffffc02000d0 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200a2a:	1141                	addi	sp,sp,-16
ffffffffc0200a2c:	e406                	sd	ra,8(sp)
            clock_set_next_event();
ffffffffc0200a2e:	b97ff0ef          	jal	ra,ffffffffc02005c4 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0 && current) {
ffffffffc0200a32:	000ac797          	auipc	a5,0xac
ffffffffc0200a36:	b3e78793          	addi	a5,a5,-1218 # ffffffffc02ac570 <ticks>
ffffffffc0200a3a:	639c                	ld	a5,0(a5)
ffffffffc0200a3c:	06400713          	li	a4,100
ffffffffc0200a40:	0785                	addi	a5,a5,1
ffffffffc0200a42:	02e7f733          	remu	a4,a5,a4
ffffffffc0200a46:	000ac697          	auipc	a3,0xac
ffffffffc0200a4a:	b2f6b523          	sd	a5,-1238(a3) # ffffffffc02ac570 <ticks>
ffffffffc0200a4e:	eb09                	bnez	a4,ffffffffc0200a60 <interrupt_handler+0x94>
ffffffffc0200a50:	000ac797          	auipc	a5,0xac
ffffffffc0200a54:	b0078793          	addi	a5,a5,-1280 # ffffffffc02ac550 <current>
ffffffffc0200a58:	639c                	ld	a5,0(a5)
ffffffffc0200a5a:	c399                	beqz	a5,ffffffffc0200a60 <interrupt_handler+0x94>
                current->need_resched = 1;
ffffffffc0200a5c:	4705                	li	a4,1
ffffffffc0200a5e:	ef98                	sd	a4,24(a5)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200a60:	60a2                	ld	ra,8(sp)
ffffffffc0200a62:	0141                	addi	sp,sp,16
ffffffffc0200a64:	8082                	ret
            print_trapframe(tf);
ffffffffc0200a66:	de5ff06f          	j	ffffffffc020084a <print_trapframe>

ffffffffc0200a6a <exception_handler>:
void kernel_execve_ret(struct trapframe *tf,uintptr_t kstacktop);
void exception_handler(struct trapframe *tf) {
    int ret;
    switch (tf->cause) {
ffffffffc0200a6a:	11853783          	ld	a5,280(a0)
ffffffffc0200a6e:	473d                	li	a4,15
ffffffffc0200a70:	1af76e63          	bltu	a4,a5,ffffffffc0200c2c <exception_handler+0x1c2>
ffffffffc0200a74:	00006717          	auipc	a4,0x6
ffffffffc0200a78:	f0070713          	addi	a4,a4,-256 # ffffffffc0206974 <commands+0x1cc>
ffffffffc0200a7c:	078a                	slli	a5,a5,0x2
ffffffffc0200a7e:	97ba                	add	a5,a5,a4
ffffffffc0200a80:	439c                	lw	a5,0(a5)
void exception_handler(struct trapframe *tf) {
ffffffffc0200a82:	1101                	addi	sp,sp,-32
ffffffffc0200a84:	e822                	sd	s0,16(sp)
ffffffffc0200a86:	ec06                	sd	ra,24(sp)
ffffffffc0200a88:	e426                	sd	s1,8(sp)
    switch (tf->cause) {
ffffffffc0200a8a:	97ba                	add	a5,a5,a4
ffffffffc0200a8c:	842a                	mv	s0,a0
ffffffffc0200a8e:	8782                	jr	a5
            //cprintf("Environment call from U-mode\n");
            tf->epc += 4;
            syscall();
            break;
        case CAUSE_SUPERVISOR_ECALL:
            cprintf("Environment call from S-mode\n");
ffffffffc0200a90:	00006517          	auipc	a0,0x6
ffffffffc0200a94:	01850513          	addi	a0,a0,24 # ffffffffc0206aa8 <commands+0x300>
ffffffffc0200a98:	e38ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            tf->epc += 4;
ffffffffc0200a9c:	10843783          	ld	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200aa0:	60e2                	ld	ra,24(sp)
ffffffffc0200aa2:	64a2                	ld	s1,8(sp)
            tf->epc += 4;
ffffffffc0200aa4:	0791                	addi	a5,a5,4
ffffffffc0200aa6:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200aaa:	6442                	ld	s0,16(sp)
ffffffffc0200aac:	6105                	addi	sp,sp,32
            syscall();
ffffffffc0200aae:	6320506f          	j	ffffffffc02060e0 <syscall>
            cprintf("Environment call from H-mode\n");
ffffffffc0200ab2:	00006517          	auipc	a0,0x6
ffffffffc0200ab6:	01650513          	addi	a0,a0,22 # ffffffffc0206ac8 <commands+0x320>
}
ffffffffc0200aba:	6442                	ld	s0,16(sp)
ffffffffc0200abc:	60e2                	ld	ra,24(sp)
ffffffffc0200abe:	64a2                	ld	s1,8(sp)
ffffffffc0200ac0:	6105                	addi	sp,sp,32
            cprintf("Instruction access fault\n");
ffffffffc0200ac2:	e0eff06f          	j	ffffffffc02000d0 <cprintf>
            cprintf("Environment call from M-mode\n");
ffffffffc0200ac6:	00006517          	auipc	a0,0x6
ffffffffc0200aca:	02250513          	addi	a0,a0,34 # ffffffffc0206ae8 <commands+0x340>
ffffffffc0200ace:	b7f5                	j	ffffffffc0200aba <exception_handler+0x50>
            cprintf("Instruction page fault\n");
ffffffffc0200ad0:	00006517          	auipc	a0,0x6
ffffffffc0200ad4:	03850513          	addi	a0,a0,56 # ffffffffc0206b08 <commands+0x360>
ffffffffc0200ad8:	b7cd                	j	ffffffffc0200aba <exception_handler+0x50>
            cprintf("Load page fault\n");
ffffffffc0200ada:	00006517          	auipc	a0,0x6
ffffffffc0200ade:	04650513          	addi	a0,a0,70 # ffffffffc0206b20 <commands+0x378>
ffffffffc0200ae2:	deeff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200ae6:	8522                	mv	a0,s0
ffffffffc0200ae8:	dc5ff0ef          	jal	ra,ffffffffc02008ac <pgfault_handler>
ffffffffc0200aec:	84aa                	mv	s1,a0
ffffffffc0200aee:	14051163          	bnez	a0,ffffffffc0200c30 <exception_handler+0x1c6>
}
ffffffffc0200af2:	60e2                	ld	ra,24(sp)
ffffffffc0200af4:	6442                	ld	s0,16(sp)
ffffffffc0200af6:	64a2                	ld	s1,8(sp)
ffffffffc0200af8:	6105                	addi	sp,sp,32
ffffffffc0200afa:	8082                	ret
            cprintf("Store/AMO page fault\n");
ffffffffc0200afc:	00006517          	auipc	a0,0x6
ffffffffc0200b00:	03c50513          	addi	a0,a0,60 # ffffffffc0206b38 <commands+0x390>
ffffffffc0200b04:	dccff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200b08:	8522                	mv	a0,s0
ffffffffc0200b0a:	da3ff0ef          	jal	ra,ffffffffc02008ac <pgfault_handler>
ffffffffc0200b0e:	84aa                	mv	s1,a0
ffffffffc0200b10:	d16d                	beqz	a0,ffffffffc0200af2 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200b12:	8522                	mv	a0,s0
ffffffffc0200b14:	d37ff0ef          	jal	ra,ffffffffc020084a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200b18:	86a6                	mv	a3,s1
ffffffffc0200b1a:	00006617          	auipc	a2,0x6
ffffffffc0200b1e:	f3e60613          	addi	a2,a2,-194 # ffffffffc0206a58 <commands+0x2b0>
ffffffffc0200b22:	0f800593          	li	a1,248
ffffffffc0200b26:	00006517          	auipc	a0,0x6
ffffffffc0200b2a:	11a50513          	addi	a0,a0,282 # ffffffffc0206c40 <commands+0x498>
ffffffffc0200b2e:	ee8ff0ef          	jal	ra,ffffffffc0200216 <__panic>
            cprintf("Instruction address misaligned\n");
ffffffffc0200b32:	00006517          	auipc	a0,0x6
ffffffffc0200b36:	e8650513          	addi	a0,a0,-378 # ffffffffc02069b8 <commands+0x210>
ffffffffc0200b3a:	b741                	j	ffffffffc0200aba <exception_handler+0x50>
            cprintf("Instruction access fault\n");
ffffffffc0200b3c:	00006517          	auipc	a0,0x6
ffffffffc0200b40:	e9c50513          	addi	a0,a0,-356 # ffffffffc02069d8 <commands+0x230>
ffffffffc0200b44:	bf9d                	j	ffffffffc0200aba <exception_handler+0x50>
            cprintf("Illegal instruction\n");
ffffffffc0200b46:	00006517          	auipc	a0,0x6
ffffffffc0200b4a:	eb250513          	addi	a0,a0,-334 # ffffffffc02069f8 <commands+0x250>
ffffffffc0200b4e:	b7b5                	j	ffffffffc0200aba <exception_handler+0x50>
            cprintf("Breakpoint\n");
ffffffffc0200b50:	00006517          	auipc	a0,0x6
ffffffffc0200b54:	ec050513          	addi	a0,a0,-320 # ffffffffc0206a10 <commands+0x268>
ffffffffc0200b58:	d78ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if(tf->gpr.a7 == 10){
ffffffffc0200b5c:	6458                	ld	a4,136(s0)
ffffffffc0200b5e:	47a9                	li	a5,10
ffffffffc0200b60:	f8f719e3          	bne	a4,a5,ffffffffc0200af2 <exception_handler+0x88>
                tf->epc += 4;
ffffffffc0200b64:	10843783          	ld	a5,264(s0)
ffffffffc0200b68:	0791                	addi	a5,a5,4
ffffffffc0200b6a:	10f43423          	sd	a5,264(s0)
                syscall();
ffffffffc0200b6e:	572050ef          	jal	ra,ffffffffc02060e0 <syscall>
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b72:	000ac797          	auipc	a5,0xac
ffffffffc0200b76:	9de78793          	addi	a5,a5,-1570 # ffffffffc02ac550 <current>
ffffffffc0200b7a:	639c                	ld	a5,0(a5)
ffffffffc0200b7c:	8522                	mv	a0,s0
}
ffffffffc0200b7e:	6442                	ld	s0,16(sp)
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b80:	6b9c                	ld	a5,16(a5)
}
ffffffffc0200b82:	60e2                	ld	ra,24(sp)
ffffffffc0200b84:	64a2                	ld	s1,8(sp)
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b86:	6589                	lui	a1,0x2
ffffffffc0200b88:	95be                	add	a1,a1,a5
}
ffffffffc0200b8a:	6105                	addi	sp,sp,32
                kernel_execve_ret(tf,current->kstack+KSTACKSIZE);
ffffffffc0200b8c:	2220006f          	j	ffffffffc0200dae <kernel_execve_ret>
            cprintf("Load address misaligned\n");
ffffffffc0200b90:	00006517          	auipc	a0,0x6
ffffffffc0200b94:	e9050513          	addi	a0,a0,-368 # ffffffffc0206a20 <commands+0x278>
ffffffffc0200b98:	b70d                	j	ffffffffc0200aba <exception_handler+0x50>
            cprintf("Load access fault\n");
ffffffffc0200b9a:	00006517          	auipc	a0,0x6
ffffffffc0200b9e:	ea650513          	addi	a0,a0,-346 # ffffffffc0206a40 <commands+0x298>
ffffffffc0200ba2:	d2eff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200ba6:	8522                	mv	a0,s0
ffffffffc0200ba8:	d05ff0ef          	jal	ra,ffffffffc02008ac <pgfault_handler>
ffffffffc0200bac:	84aa                	mv	s1,a0
ffffffffc0200bae:	d131                	beqz	a0,ffffffffc0200af2 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200bb0:	8522                	mv	a0,s0
ffffffffc0200bb2:	c99ff0ef          	jal	ra,ffffffffc020084a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200bb6:	86a6                	mv	a3,s1
ffffffffc0200bb8:	00006617          	auipc	a2,0x6
ffffffffc0200bbc:	ea060613          	addi	a2,a2,-352 # ffffffffc0206a58 <commands+0x2b0>
ffffffffc0200bc0:	0cd00593          	li	a1,205
ffffffffc0200bc4:	00006517          	auipc	a0,0x6
ffffffffc0200bc8:	07c50513          	addi	a0,a0,124 # ffffffffc0206c40 <commands+0x498>
ffffffffc0200bcc:	e4aff0ef          	jal	ra,ffffffffc0200216 <__panic>
            cprintf("Store/AMO access fault\n");
ffffffffc0200bd0:	00006517          	auipc	a0,0x6
ffffffffc0200bd4:	ec050513          	addi	a0,a0,-320 # ffffffffc0206a90 <commands+0x2e8>
ffffffffc0200bd8:	cf8ff0ef          	jal	ra,ffffffffc02000d0 <cprintf>
            if ((ret = pgfault_handler(tf)) != 0) {
ffffffffc0200bdc:	8522                	mv	a0,s0
ffffffffc0200bde:	ccfff0ef          	jal	ra,ffffffffc02008ac <pgfault_handler>
ffffffffc0200be2:	84aa                	mv	s1,a0
ffffffffc0200be4:	f00507e3          	beqz	a0,ffffffffc0200af2 <exception_handler+0x88>
                print_trapframe(tf);
ffffffffc0200be8:	8522                	mv	a0,s0
ffffffffc0200bea:	c61ff0ef          	jal	ra,ffffffffc020084a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200bee:	86a6                	mv	a3,s1
ffffffffc0200bf0:	00006617          	auipc	a2,0x6
ffffffffc0200bf4:	e6860613          	addi	a2,a2,-408 # ffffffffc0206a58 <commands+0x2b0>
ffffffffc0200bf8:	0d700593          	li	a1,215
ffffffffc0200bfc:	00006517          	auipc	a0,0x6
ffffffffc0200c00:	04450513          	addi	a0,a0,68 # ffffffffc0206c40 <commands+0x498>
ffffffffc0200c04:	e12ff0ef          	jal	ra,ffffffffc0200216 <__panic>
}
ffffffffc0200c08:	6442                	ld	s0,16(sp)
ffffffffc0200c0a:	60e2                	ld	ra,24(sp)
ffffffffc0200c0c:	64a2                	ld	s1,8(sp)
ffffffffc0200c0e:	6105                	addi	sp,sp,32
            print_trapframe(tf);
ffffffffc0200c10:	c3bff06f          	j	ffffffffc020084a <print_trapframe>
            panic("AMO address misaligned\n");
ffffffffc0200c14:	00006617          	auipc	a2,0x6
ffffffffc0200c18:	e6460613          	addi	a2,a2,-412 # ffffffffc0206a78 <commands+0x2d0>
ffffffffc0200c1c:	0d100593          	li	a1,209
ffffffffc0200c20:	00006517          	auipc	a0,0x6
ffffffffc0200c24:	02050513          	addi	a0,a0,32 # ffffffffc0206c40 <commands+0x498>
ffffffffc0200c28:	deeff0ef          	jal	ra,ffffffffc0200216 <__panic>
            print_trapframe(tf);
ffffffffc0200c2c:	c1fff06f          	j	ffffffffc020084a <print_trapframe>
                print_trapframe(tf);
ffffffffc0200c30:	8522                	mv	a0,s0
ffffffffc0200c32:	c19ff0ef          	jal	ra,ffffffffc020084a <print_trapframe>
                panic("handle pgfault failed. %e\n", ret);
ffffffffc0200c36:	86a6                	mv	a3,s1
ffffffffc0200c38:	00006617          	auipc	a2,0x6
ffffffffc0200c3c:	e2060613          	addi	a2,a2,-480 # ffffffffc0206a58 <commands+0x2b0>
ffffffffc0200c40:	0f100593          	li	a1,241
ffffffffc0200c44:	00006517          	auipc	a0,0x6
ffffffffc0200c48:	ffc50513          	addi	a0,a0,-4 # ffffffffc0206c40 <commands+0x498>
ffffffffc0200c4c:	dcaff0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0200c50 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
ffffffffc0200c50:	1101                	addi	sp,sp,-32
ffffffffc0200c52:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
//    cputs("some trap");
    if (current == NULL) {
ffffffffc0200c54:	000ac417          	auipc	s0,0xac
ffffffffc0200c58:	8fc40413          	addi	s0,s0,-1796 # ffffffffc02ac550 <current>
ffffffffc0200c5c:	6018                	ld	a4,0(s0)
trap(struct trapframe *tf) {
ffffffffc0200c5e:	ec06                	sd	ra,24(sp)
ffffffffc0200c60:	e426                	sd	s1,8(sp)
ffffffffc0200c62:	e04a                	sd	s2,0(sp)
ffffffffc0200c64:	11853683          	ld	a3,280(a0)
    if (current == NULL) {
ffffffffc0200c68:	cf1d                	beqz	a4,ffffffffc0200ca6 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200c6a:	10053483          	ld	s1,256(a0)
        trap_dispatch(tf);
    } else {
        struct trapframe *otf = current->tf;
ffffffffc0200c6e:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200c72:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200c74:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200c78:	0206c463          	bltz	a3,ffffffffc0200ca0 <trap+0x50>
        exception_handler(tf);
ffffffffc0200c7c:	defff0ef          	jal	ra,ffffffffc0200a6a <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200c80:	601c                	ld	a5,0(s0)
ffffffffc0200c82:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel) {
ffffffffc0200c86:	e499                	bnez	s1,ffffffffc0200c94 <trap+0x44>
            if (current->flags & PF_EXITING) {
ffffffffc0200c88:	0b07a703          	lw	a4,176(a5)
ffffffffc0200c8c:	8b05                	andi	a4,a4,1
ffffffffc0200c8e:	e339                	bnez	a4,ffffffffc0200cd4 <trap+0x84>
                do_exit(-E_KILLED);
            }
            if (current->need_resched) {
ffffffffc0200c90:	6f9c                	ld	a5,24(a5)
ffffffffc0200c92:	eb95                	bnez	a5,ffffffffc0200cc6 <trap+0x76>
                schedule();
            }
        }
    }
}
ffffffffc0200c94:	60e2                	ld	ra,24(sp)
ffffffffc0200c96:	6442                	ld	s0,16(sp)
ffffffffc0200c98:	64a2                	ld	s1,8(sp)
ffffffffc0200c9a:	6902                	ld	s2,0(sp)
ffffffffc0200c9c:	6105                	addi	sp,sp,32
ffffffffc0200c9e:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200ca0:	d2dff0ef          	jal	ra,ffffffffc02009cc <interrupt_handler>
ffffffffc0200ca4:	bff1                	j	ffffffffc0200c80 <trap+0x30>
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200ca6:	0006c963          	bltz	a3,ffffffffc0200cb8 <trap+0x68>
}
ffffffffc0200caa:	6442                	ld	s0,16(sp)
ffffffffc0200cac:	60e2                	ld	ra,24(sp)
ffffffffc0200cae:	64a2                	ld	s1,8(sp)
ffffffffc0200cb0:	6902                	ld	s2,0(sp)
ffffffffc0200cb2:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200cb4:	db7ff06f          	j	ffffffffc0200a6a <exception_handler>
}
ffffffffc0200cb8:	6442                	ld	s0,16(sp)
ffffffffc0200cba:	60e2                	ld	ra,24(sp)
ffffffffc0200cbc:	64a2                	ld	s1,8(sp)
ffffffffc0200cbe:	6902                	ld	s2,0(sp)
ffffffffc0200cc0:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200cc2:	d0bff06f          	j	ffffffffc02009cc <interrupt_handler>
}
ffffffffc0200cc6:	6442                	ld	s0,16(sp)
ffffffffc0200cc8:	60e2                	ld	ra,24(sp)
ffffffffc0200cca:	64a2                	ld	s1,8(sp)
ffffffffc0200ccc:	6902                	ld	s2,0(sp)
ffffffffc0200cce:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200cd0:	31a0506f          	j	ffffffffc0205fea <schedule>
                do_exit(-E_KILLED);
ffffffffc0200cd4:	555d                	li	a0,-9
ffffffffc0200cd6:	778040ef          	jal	ra,ffffffffc020544e <do_exit>
ffffffffc0200cda:	601c                	ld	a5,0(s0)
ffffffffc0200cdc:	bf55                	j	ffffffffc0200c90 <trap+0x40>
	...

ffffffffc0200ce0 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200ce0:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200ce4:	00011463          	bnez	sp,ffffffffc0200cec <__alltraps+0xc>
ffffffffc0200ce8:	14002173          	csrr	sp,sscratch
ffffffffc0200cec:	712d                	addi	sp,sp,-288
ffffffffc0200cee:	e002                	sd	zero,0(sp)
ffffffffc0200cf0:	e406                	sd	ra,8(sp)
ffffffffc0200cf2:	ec0e                	sd	gp,24(sp)
ffffffffc0200cf4:	f012                	sd	tp,32(sp)
ffffffffc0200cf6:	f416                	sd	t0,40(sp)
ffffffffc0200cf8:	f81a                	sd	t1,48(sp)
ffffffffc0200cfa:	fc1e                	sd	t2,56(sp)
ffffffffc0200cfc:	e0a2                	sd	s0,64(sp)
ffffffffc0200cfe:	e4a6                	sd	s1,72(sp)
ffffffffc0200d00:	e8aa                	sd	a0,80(sp)
ffffffffc0200d02:	ecae                	sd	a1,88(sp)
ffffffffc0200d04:	f0b2                	sd	a2,96(sp)
ffffffffc0200d06:	f4b6                	sd	a3,104(sp)
ffffffffc0200d08:	f8ba                	sd	a4,112(sp)
ffffffffc0200d0a:	fcbe                	sd	a5,120(sp)
ffffffffc0200d0c:	e142                	sd	a6,128(sp)
ffffffffc0200d0e:	e546                	sd	a7,136(sp)
ffffffffc0200d10:	e94a                	sd	s2,144(sp)
ffffffffc0200d12:	ed4e                	sd	s3,152(sp)
ffffffffc0200d14:	f152                	sd	s4,160(sp)
ffffffffc0200d16:	f556                	sd	s5,168(sp)
ffffffffc0200d18:	f95a                	sd	s6,176(sp)
ffffffffc0200d1a:	fd5e                	sd	s7,184(sp)
ffffffffc0200d1c:	e1e2                	sd	s8,192(sp)
ffffffffc0200d1e:	e5e6                	sd	s9,200(sp)
ffffffffc0200d20:	e9ea                	sd	s10,208(sp)
ffffffffc0200d22:	edee                	sd	s11,216(sp)
ffffffffc0200d24:	f1f2                	sd	t3,224(sp)
ffffffffc0200d26:	f5f6                	sd	t4,232(sp)
ffffffffc0200d28:	f9fa                	sd	t5,240(sp)
ffffffffc0200d2a:	fdfe                	sd	t6,248(sp)
ffffffffc0200d2c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200d30:	100024f3          	csrr	s1,sstatus
ffffffffc0200d34:	14102973          	csrr	s2,sepc
ffffffffc0200d38:	143029f3          	csrr	s3,stval
ffffffffc0200d3c:	14202a73          	csrr	s4,scause
ffffffffc0200d40:	e822                	sd	s0,16(sp)
ffffffffc0200d42:	e226                	sd	s1,256(sp)
ffffffffc0200d44:	e64a                	sd	s2,264(sp)
ffffffffc0200d46:	ea4e                	sd	s3,272(sp)
ffffffffc0200d48:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d4a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d4c:	f05ff0ef          	jal	ra,ffffffffc0200c50 <trap>

ffffffffc0200d50 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d50:	6492                	ld	s1,256(sp)
ffffffffc0200d52:	6932                	ld	s2,264(sp)
ffffffffc0200d54:	1004f413          	andi	s0,s1,256
ffffffffc0200d58:	e401                	bnez	s0,ffffffffc0200d60 <__trapret+0x10>
ffffffffc0200d5a:	1200                	addi	s0,sp,288
ffffffffc0200d5c:	14041073          	csrw	sscratch,s0
ffffffffc0200d60:	10049073          	csrw	sstatus,s1
ffffffffc0200d64:	14191073          	csrw	sepc,s2
ffffffffc0200d68:	60a2                	ld	ra,8(sp)
ffffffffc0200d6a:	61e2                	ld	gp,24(sp)
ffffffffc0200d6c:	7202                	ld	tp,32(sp)
ffffffffc0200d6e:	72a2                	ld	t0,40(sp)
ffffffffc0200d70:	7342                	ld	t1,48(sp)
ffffffffc0200d72:	73e2                	ld	t2,56(sp)
ffffffffc0200d74:	6406                	ld	s0,64(sp)
ffffffffc0200d76:	64a6                	ld	s1,72(sp)
ffffffffc0200d78:	6546                	ld	a0,80(sp)
ffffffffc0200d7a:	65e6                	ld	a1,88(sp)
ffffffffc0200d7c:	7606                	ld	a2,96(sp)
ffffffffc0200d7e:	76a6                	ld	a3,104(sp)
ffffffffc0200d80:	7746                	ld	a4,112(sp)
ffffffffc0200d82:	77e6                	ld	a5,120(sp)
ffffffffc0200d84:	680a                	ld	a6,128(sp)
ffffffffc0200d86:	68aa                	ld	a7,136(sp)
ffffffffc0200d88:	694a                	ld	s2,144(sp)
ffffffffc0200d8a:	69ea                	ld	s3,152(sp)
ffffffffc0200d8c:	7a0a                	ld	s4,160(sp)
ffffffffc0200d8e:	7aaa                	ld	s5,168(sp)
ffffffffc0200d90:	7b4a                	ld	s6,176(sp)
ffffffffc0200d92:	7bea                	ld	s7,184(sp)
ffffffffc0200d94:	6c0e                	ld	s8,192(sp)
ffffffffc0200d96:	6cae                	ld	s9,200(sp)
ffffffffc0200d98:	6d4e                	ld	s10,208(sp)
ffffffffc0200d9a:	6dee                	ld	s11,216(sp)
ffffffffc0200d9c:	7e0e                	ld	t3,224(sp)
ffffffffc0200d9e:	7eae                	ld	t4,232(sp)
ffffffffc0200da0:	7f4e                	ld	t5,240(sp)
ffffffffc0200da2:	7fee                	ld	t6,248(sp)
ffffffffc0200da4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200da6:	10200073          	sret

ffffffffc0200daa <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200daa:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200dac:	b755                	j	ffffffffc0200d50 <__trapret>

ffffffffc0200dae <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200dae:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x76a8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200db2:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200db6:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200dba:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200dbe:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200dc2:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200dc6:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200dca:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200dce:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200dd2:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200dd4:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200dd6:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200dd8:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200dda:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200ddc:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200dde:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200de0:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200de2:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200de4:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200de6:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200de8:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200dea:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200dec:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200dee:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200df0:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200df2:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200df4:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200df6:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200df8:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200dfa:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200dfc:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200dfe:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200e00:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200e02:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200e04:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200e06:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200e08:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200e0a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200e0c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200e0e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200e10:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200e12:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200e14:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200e16:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200e18:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200e1a:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200e1c:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200e1e:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200e20:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200e22:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200e24:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200e26:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200e28:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200e2a:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200e2c:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200e2e:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200e30:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200e32:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200e34:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200e36:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200e38:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200e3a:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200e3c:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200e3e:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200e40:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200e42:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200e44:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200e46:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200e48:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200e4a:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200e4c:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200e4e:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200e50:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200e52:	812e                	mv	sp,a1
ffffffffc0200e54:	bdf5                	j	ffffffffc0200d50 <__trapret>

ffffffffc0200e56 <pa2page.part.4>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
ffffffffc0200e56:	1141                	addi	sp,sp,-16
    if (PPN(pa) >= npage) {
        panic("pa2page called with invalid pa");
ffffffffc0200e58:	00006617          	auipc	a2,0x6
ffffffffc0200e5c:	1f060613          	addi	a2,a2,496 # ffffffffc0207048 <commands+0x8a0>
ffffffffc0200e60:	06200593          	li	a1,98
ffffffffc0200e64:	00006517          	auipc	a0,0x6
ffffffffc0200e68:	20450513          	addi	a0,a0,516 # ffffffffc0207068 <commands+0x8c0>
pa2page(uintptr_t pa) {
ffffffffc0200e6c:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0200e6e:	ba8ff0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0200e72 <alloc_pages>:
    pmm_manager->init_memmap(base, n);
}

// alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE
// memory
struct Page *alloc_pages(size_t n) {
ffffffffc0200e72:	715d                	addi	sp,sp,-80
ffffffffc0200e74:	e0a2                	sd	s0,64(sp)
ffffffffc0200e76:	fc26                	sd	s1,56(sp)
ffffffffc0200e78:	f84a                	sd	s2,48(sp)
ffffffffc0200e7a:	f44e                	sd	s3,40(sp)
ffffffffc0200e7c:	f052                	sd	s4,32(sp)
ffffffffc0200e7e:	ec56                	sd	s5,24(sp)
ffffffffc0200e80:	e486                	sd	ra,72(sp)
ffffffffc0200e82:	842a                	mv	s0,a0
ffffffffc0200e84:	000ab497          	auipc	s1,0xab
ffffffffc0200e88:	6f448493          	addi	s1,s1,1780 # ffffffffc02ac578 <pmm_manager>
        {
            page = pmm_manager->alloc_pages(n);
        }
        local_intr_restore(intr_flag);

        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200e8c:	4985                	li	s3,1
ffffffffc0200e8e:	000aba17          	auipc	s4,0xab
ffffffffc0200e92:	6baa0a13          	addi	s4,s4,1722 # ffffffffc02ac548 <swap_init_ok>

        extern struct mm_struct *check_mm_struct;
        // cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
        swap_out(check_mm_struct, n, 0);
ffffffffc0200e96:	0005091b          	sext.w	s2,a0
ffffffffc0200e9a:	000aba97          	auipc	s5,0xab
ffffffffc0200e9e:	70ea8a93          	addi	s5,s5,1806 # ffffffffc02ac5a8 <check_mm_struct>
ffffffffc0200ea2:	a00d                	j	ffffffffc0200ec4 <alloc_pages+0x52>
            page = pmm_manager->alloc_pages(n);
ffffffffc0200ea4:	609c                	ld	a5,0(s1)
ffffffffc0200ea6:	6f9c                	ld	a5,24(a5)
ffffffffc0200ea8:	9782                	jalr	a5
        swap_out(check_mm_struct, n, 0);
ffffffffc0200eaa:	4601                	li	a2,0
ffffffffc0200eac:	85ca                	mv	a1,s2
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200eae:	ed0d                	bnez	a0,ffffffffc0200ee8 <alloc_pages+0x76>
ffffffffc0200eb0:	0289ec63          	bltu	s3,s0,ffffffffc0200ee8 <alloc_pages+0x76>
ffffffffc0200eb4:	000a2783          	lw	a5,0(s4)
ffffffffc0200eb8:	2781                	sext.w	a5,a5
ffffffffc0200eba:	c79d                	beqz	a5,ffffffffc0200ee8 <alloc_pages+0x76>
        swap_out(check_mm_struct, n, 0);
ffffffffc0200ebc:	000ab503          	ld	a0,0(s5)
ffffffffc0200ec0:	7a9020ef          	jal	ra,ffffffffc0203e68 <swap_out>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200ec4:	100027f3          	csrr	a5,sstatus
ffffffffc0200ec8:	8b89                	andi	a5,a5,2
            page = pmm_manager->alloc_pages(n);
ffffffffc0200eca:	8522                	mv	a0,s0
ffffffffc0200ecc:	dfe1                	beqz	a5,ffffffffc0200ea4 <alloc_pages+0x32>
        intr_disable();
ffffffffc0200ece:	f8eff0ef          	jal	ra,ffffffffc020065c <intr_disable>
ffffffffc0200ed2:	609c                	ld	a5,0(s1)
ffffffffc0200ed4:	8522                	mv	a0,s0
ffffffffc0200ed6:	6f9c                	ld	a5,24(a5)
ffffffffc0200ed8:	9782                	jalr	a5
ffffffffc0200eda:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200edc:	f7aff0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc0200ee0:	6522                	ld	a0,8(sp)
        swap_out(check_mm_struct, n, 0);
ffffffffc0200ee2:	4601                	li	a2,0
ffffffffc0200ee4:	85ca                	mv	a1,s2
        if (page != NULL || n > 1 || swap_init_ok == 0) break;
ffffffffc0200ee6:	d569                	beqz	a0,ffffffffc0200eb0 <alloc_pages+0x3e>
    }
    // cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
}
ffffffffc0200ee8:	60a6                	ld	ra,72(sp)
ffffffffc0200eea:	6406                	ld	s0,64(sp)
ffffffffc0200eec:	74e2                	ld	s1,56(sp)
ffffffffc0200eee:	7942                	ld	s2,48(sp)
ffffffffc0200ef0:	79a2                	ld	s3,40(sp)
ffffffffc0200ef2:	7a02                	ld	s4,32(sp)
ffffffffc0200ef4:	6ae2                	ld	s5,24(sp)
ffffffffc0200ef6:	6161                	addi	sp,sp,80
ffffffffc0200ef8:	8082                	ret

ffffffffc0200efa <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200efa:	100027f3          	csrr	a5,sstatus
ffffffffc0200efe:	8b89                	andi	a5,a5,2
ffffffffc0200f00:	eb89                	bnez	a5,ffffffffc0200f12 <free_pages+0x18>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200f02:	000ab797          	auipc	a5,0xab
ffffffffc0200f06:	67678793          	addi	a5,a5,1654 # ffffffffc02ac578 <pmm_manager>
ffffffffc0200f0a:	639c                	ld	a5,0(a5)
ffffffffc0200f0c:	0207b303          	ld	t1,32(a5)
ffffffffc0200f10:	8302                	jr	t1
void free_pages(struct Page *base, size_t n) {
ffffffffc0200f12:	1101                	addi	sp,sp,-32
ffffffffc0200f14:	ec06                	sd	ra,24(sp)
ffffffffc0200f16:	e822                	sd	s0,16(sp)
ffffffffc0200f18:	e426                	sd	s1,8(sp)
ffffffffc0200f1a:	842a                	mv	s0,a0
ffffffffc0200f1c:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200f1e:	f3eff0ef          	jal	ra,ffffffffc020065c <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200f22:	000ab797          	auipc	a5,0xab
ffffffffc0200f26:	65678793          	addi	a5,a5,1622 # ffffffffc02ac578 <pmm_manager>
ffffffffc0200f2a:	639c                	ld	a5,0(a5)
ffffffffc0200f2c:	85a6                	mv	a1,s1
ffffffffc0200f2e:	8522                	mv	a0,s0
ffffffffc0200f30:	739c                	ld	a5,32(a5)
ffffffffc0200f32:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200f34:	6442                	ld	s0,16(sp)
ffffffffc0200f36:	60e2                	ld	ra,24(sp)
ffffffffc0200f38:	64a2                	ld	s1,8(sp)
ffffffffc0200f3a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200f3c:	f1aff06f          	j	ffffffffc0200656 <intr_enable>

ffffffffc0200f40 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200f40:	100027f3          	csrr	a5,sstatus
ffffffffc0200f44:	8b89                	andi	a5,a5,2
ffffffffc0200f46:	eb89                	bnez	a5,ffffffffc0200f58 <nr_free_pages+0x18>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200f48:	000ab797          	auipc	a5,0xab
ffffffffc0200f4c:	63078793          	addi	a5,a5,1584 # ffffffffc02ac578 <pmm_manager>
ffffffffc0200f50:	639c                	ld	a5,0(a5)
ffffffffc0200f52:	0287b303          	ld	t1,40(a5)
ffffffffc0200f56:	8302                	jr	t1
size_t nr_free_pages(void) {
ffffffffc0200f58:	1141                	addi	sp,sp,-16
ffffffffc0200f5a:	e406                	sd	ra,8(sp)
ffffffffc0200f5c:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200f5e:	efeff0ef          	jal	ra,ffffffffc020065c <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0200f62:	000ab797          	auipc	a5,0xab
ffffffffc0200f66:	61678793          	addi	a5,a5,1558 # ffffffffc02ac578 <pmm_manager>
ffffffffc0200f6a:	639c                	ld	a5,0(a5)
ffffffffc0200f6c:	779c                	ld	a5,40(a5)
ffffffffc0200f6e:	9782                	jalr	a5
ffffffffc0200f70:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200f72:	ee4ff0ef          	jal	ra,ffffffffc0200656 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0200f76:	8522                	mv	a0,s0
ffffffffc0200f78:	60a2                	ld	ra,8(sp)
ffffffffc0200f7a:	6402                	ld	s0,0(sp)
ffffffffc0200f7c:	0141                	addi	sp,sp,16
ffffffffc0200f7e:	8082                	ret

ffffffffc0200f80 <get_pte>:
// parameter:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200f80:	7139                	addi	sp,sp,-64
ffffffffc0200f82:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0200f84:	01e5d493          	srli	s1,a1,0x1e
ffffffffc0200f88:	1ff4f493          	andi	s1,s1,511
ffffffffc0200f8c:	048e                	slli	s1,s1,0x3
ffffffffc0200f8e:	94aa                	add	s1,s1,a0
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200f90:	6094                	ld	a3,0(s1)
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200f92:	f04a                	sd	s2,32(sp)
ffffffffc0200f94:	ec4e                	sd	s3,24(sp)
ffffffffc0200f96:	e852                	sd	s4,16(sp)
ffffffffc0200f98:	fc06                	sd	ra,56(sp)
ffffffffc0200f9a:	f822                	sd	s0,48(sp)
ffffffffc0200f9c:	e456                	sd	s5,8(sp)
ffffffffc0200f9e:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200fa0:	0016f793          	andi	a5,a3,1
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create) {
ffffffffc0200fa4:	892e                	mv	s2,a1
ffffffffc0200fa6:	8a32                	mv	s4,a2
ffffffffc0200fa8:	000ab997          	auipc	s3,0xab
ffffffffc0200fac:	58098993          	addi	s3,s3,1408 # ffffffffc02ac528 <npage>
    if (!(*pdep1 & PTE_V)) {
ffffffffc0200fb0:	e7bd                	bnez	a5,ffffffffc020101e <get_pte+0x9e>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0200fb2:	12060c63          	beqz	a2,ffffffffc02010ea <get_pte+0x16a>
ffffffffc0200fb6:	4505                	li	a0,1
ffffffffc0200fb8:	ebbff0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0200fbc:	842a                	mv	s0,a0
ffffffffc0200fbe:	12050663          	beqz	a0,ffffffffc02010ea <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0200fc2:	000abb17          	auipc	s6,0xab
ffffffffc0200fc6:	5ceb0b13          	addi	s6,s6,1486 # ffffffffc02ac590 <pages>
ffffffffc0200fca:	000b3503          	ld	a0,0(s6)
    return page->ref;
}

static inline void
set_page_ref(struct Page *page, int val) {
    page->ref = val;
ffffffffc0200fce:	4785                	li	a5,1
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200fd0:	000ab997          	auipc	s3,0xab
ffffffffc0200fd4:	55898993          	addi	s3,s3,1368 # ffffffffc02ac528 <npage>
    return page - pages + nbase;
ffffffffc0200fd8:	40a40533          	sub	a0,s0,a0
ffffffffc0200fdc:	00080ab7          	lui	s5,0x80
ffffffffc0200fe0:	8519                	srai	a0,a0,0x6
ffffffffc0200fe2:	0009b703          	ld	a4,0(s3)
    page->ref = val;
ffffffffc0200fe6:	c01c                	sw	a5,0(s0)
ffffffffc0200fe8:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0200fea:	9556                	add	a0,a0,s5
ffffffffc0200fec:	83b1                	srli	a5,a5,0xc
ffffffffc0200fee:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ff0:	0532                	slli	a0,a0,0xc
ffffffffc0200ff2:	14e7f363          	bleu	a4,a5,ffffffffc0201138 <get_pte+0x1b8>
ffffffffc0200ff6:	000ab797          	auipc	a5,0xab
ffffffffc0200ffa:	58a78793          	addi	a5,a5,1418 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0200ffe:	639c                	ld	a5,0(a5)
ffffffffc0201000:	6605                	lui	a2,0x1
ffffffffc0201002:	4581                	li	a1,0
ffffffffc0201004:	953e                	add	a0,a0,a5
ffffffffc0201006:	1f8050ef          	jal	ra,ffffffffc02061fe <memset>
    return page - pages + nbase;
ffffffffc020100a:	000b3683          	ld	a3,0(s6)
ffffffffc020100e:	40d406b3          	sub	a3,s0,a3
ffffffffc0201012:	8699                	srai	a3,a3,0x6
ffffffffc0201014:	96d6                	add	a3,a3,s5
  asm volatile("sfence.vma");
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type) {
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201016:	06aa                	slli	a3,a3,0xa
ffffffffc0201018:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020101c:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020101e:	77fd                	lui	a5,0xfffff
ffffffffc0201020:	068a                	slli	a3,a3,0x2
ffffffffc0201022:	0009b703          	ld	a4,0(s3)
ffffffffc0201026:	8efd                	and	a3,a3,a5
ffffffffc0201028:	00c6d793          	srli	a5,a3,0xc
ffffffffc020102c:	0ce7f163          	bleu	a4,a5,ffffffffc02010ee <get_pte+0x16e>
ffffffffc0201030:	000aba97          	auipc	s5,0xab
ffffffffc0201034:	550a8a93          	addi	s5,s5,1360 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0201038:	000ab403          	ld	s0,0(s5)
ffffffffc020103c:	01595793          	srli	a5,s2,0x15
ffffffffc0201040:	1ff7f793          	andi	a5,a5,511
ffffffffc0201044:	96a2                	add	a3,a3,s0
ffffffffc0201046:	00379413          	slli	s0,a5,0x3
ffffffffc020104a:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V)) {
ffffffffc020104c:	6014                	ld	a3,0(s0)
ffffffffc020104e:	0016f793          	andi	a5,a3,1
ffffffffc0201052:	e3ad                	bnez	a5,ffffffffc02010b4 <get_pte+0x134>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
ffffffffc0201054:	080a0b63          	beqz	s4,ffffffffc02010ea <get_pte+0x16a>
ffffffffc0201058:	4505                	li	a0,1
ffffffffc020105a:	e19ff0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020105e:	84aa                	mv	s1,a0
ffffffffc0201060:	c549                	beqz	a0,ffffffffc02010ea <get_pte+0x16a>
    return page - pages + nbase;
ffffffffc0201062:	000abb17          	auipc	s6,0xab
ffffffffc0201066:	52eb0b13          	addi	s6,s6,1326 # ffffffffc02ac590 <pages>
ffffffffc020106a:	000b3503          	ld	a0,0(s6)
    page->ref = val;
ffffffffc020106e:	4785                	li	a5,1
    return page - pages + nbase;
ffffffffc0201070:	00080a37          	lui	s4,0x80
ffffffffc0201074:	40a48533          	sub	a0,s1,a0
ffffffffc0201078:	8519                	srai	a0,a0,0x6
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020107a:	0009b703          	ld	a4,0(s3)
    page->ref = val;
ffffffffc020107e:	c09c                	sw	a5,0(s1)
ffffffffc0201080:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0201082:	9552                	add	a0,a0,s4
ffffffffc0201084:	83b1                	srli	a5,a5,0xc
ffffffffc0201086:	8fe9                	and	a5,a5,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0201088:	0532                	slli	a0,a0,0xc
ffffffffc020108a:	08e7fa63          	bleu	a4,a5,ffffffffc020111e <get_pte+0x19e>
ffffffffc020108e:	000ab783          	ld	a5,0(s5)
ffffffffc0201092:	6605                	lui	a2,0x1
ffffffffc0201094:	4581                	li	a1,0
ffffffffc0201096:	953e                	add	a0,a0,a5
ffffffffc0201098:	166050ef          	jal	ra,ffffffffc02061fe <memset>
    return page - pages + nbase;
ffffffffc020109c:	000b3683          	ld	a3,0(s6)
ffffffffc02010a0:	40d486b3          	sub	a3,s1,a3
ffffffffc02010a4:	8699                	srai	a3,a3,0x6
ffffffffc02010a6:	96d2                	add	a3,a3,s4
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02010a8:	06aa                	slli	a3,a3,0xa
ffffffffc02010aa:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02010ae:	e014                	sd	a3,0(s0)
ffffffffc02010b0:	0009b703          	ld	a4,0(s3)
        }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02010b4:	068a                	slli	a3,a3,0x2
ffffffffc02010b6:	757d                	lui	a0,0xfffff
ffffffffc02010b8:	8ee9                	and	a3,a3,a0
ffffffffc02010ba:	00c6d793          	srli	a5,a3,0xc
ffffffffc02010be:	04e7f463          	bleu	a4,a5,ffffffffc0201106 <get_pte+0x186>
ffffffffc02010c2:	000ab503          	ld	a0,0(s5)
ffffffffc02010c6:	00c95793          	srli	a5,s2,0xc
ffffffffc02010ca:	1ff7f793          	andi	a5,a5,511
ffffffffc02010ce:	96aa                	add	a3,a3,a0
ffffffffc02010d0:	00379513          	slli	a0,a5,0x3
ffffffffc02010d4:	9536                	add	a0,a0,a3
}
ffffffffc02010d6:	70e2                	ld	ra,56(sp)
ffffffffc02010d8:	7442                	ld	s0,48(sp)
ffffffffc02010da:	74a2                	ld	s1,40(sp)
ffffffffc02010dc:	7902                	ld	s2,32(sp)
ffffffffc02010de:	69e2                	ld	s3,24(sp)
ffffffffc02010e0:	6a42                	ld	s4,16(sp)
ffffffffc02010e2:	6aa2                	ld	s5,8(sp)
ffffffffc02010e4:	6b02                	ld	s6,0(sp)
ffffffffc02010e6:	6121                	addi	sp,sp,64
ffffffffc02010e8:	8082                	ret
            return NULL;
ffffffffc02010ea:	4501                	li	a0,0
ffffffffc02010ec:	b7ed                	j	ffffffffc02010d6 <get_pte+0x156>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02010ee:	00006617          	auipc	a2,0x6
ffffffffc02010f2:	f2260613          	addi	a2,a2,-222 # ffffffffc0207010 <commands+0x868>
ffffffffc02010f6:	0e300593          	li	a1,227
ffffffffc02010fa:	00006517          	auipc	a0,0x6
ffffffffc02010fe:	f3e50513          	addi	a0,a0,-194 # ffffffffc0207038 <commands+0x890>
ffffffffc0201102:	914ff0ef          	jal	ra,ffffffffc0200216 <__panic>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201106:	00006617          	auipc	a2,0x6
ffffffffc020110a:	f0a60613          	addi	a2,a2,-246 # ffffffffc0207010 <commands+0x868>
ffffffffc020110e:	0ee00593          	li	a1,238
ffffffffc0201112:	00006517          	auipc	a0,0x6
ffffffffc0201116:	f2650513          	addi	a0,a0,-218 # ffffffffc0207038 <commands+0x890>
ffffffffc020111a:	8fcff0ef          	jal	ra,ffffffffc0200216 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020111e:	86aa                	mv	a3,a0
ffffffffc0201120:	00006617          	auipc	a2,0x6
ffffffffc0201124:	ef060613          	addi	a2,a2,-272 # ffffffffc0207010 <commands+0x868>
ffffffffc0201128:	0eb00593          	li	a1,235
ffffffffc020112c:	00006517          	auipc	a0,0x6
ffffffffc0201130:	f0c50513          	addi	a0,a0,-244 # ffffffffc0207038 <commands+0x890>
ffffffffc0201134:	8e2ff0ef          	jal	ra,ffffffffc0200216 <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201138:	86aa                	mv	a3,a0
ffffffffc020113a:	00006617          	auipc	a2,0x6
ffffffffc020113e:	ed660613          	addi	a2,a2,-298 # ffffffffc0207010 <commands+0x868>
ffffffffc0201142:	0df00593          	li	a1,223
ffffffffc0201146:	00006517          	auipc	a0,0x6
ffffffffc020114a:	ef250513          	addi	a0,a0,-270 # ffffffffc0207038 <commands+0x890>
ffffffffc020114e:	8c8ff0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0201152 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc0201152:	1141                	addi	sp,sp,-16
ffffffffc0201154:	e022                	sd	s0,0(sp)
ffffffffc0201156:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201158:	4601                	li	a2,0
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
ffffffffc020115a:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020115c:	e25ff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
    if (ptep_store != NULL) {
ffffffffc0201160:	c011                	beqz	s0,ffffffffc0201164 <get_page+0x12>
        *ptep_store = ptep;
ffffffffc0201162:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc0201164:	c129                	beqz	a0,ffffffffc02011a6 <get_page+0x54>
ffffffffc0201166:	611c                	ld	a5,0(a0)
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201168:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V) {
ffffffffc020116a:	0017f713          	andi	a4,a5,1
ffffffffc020116e:	e709                	bnez	a4,ffffffffc0201178 <get_page+0x26>
}
ffffffffc0201170:	60a2                	ld	ra,8(sp)
ffffffffc0201172:	6402                	ld	s0,0(sp)
ffffffffc0201174:	0141                	addi	sp,sp,16
ffffffffc0201176:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0201178:	000ab717          	auipc	a4,0xab
ffffffffc020117c:	3b070713          	addi	a4,a4,944 # ffffffffc02ac528 <npage>
ffffffffc0201180:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201182:	078a                	slli	a5,a5,0x2
ffffffffc0201184:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201186:	02e7f563          	bleu	a4,a5,ffffffffc02011b0 <get_page+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc020118a:	000ab717          	auipc	a4,0xab
ffffffffc020118e:	40670713          	addi	a4,a4,1030 # ffffffffc02ac590 <pages>
ffffffffc0201192:	6308                	ld	a0,0(a4)
ffffffffc0201194:	60a2                	ld	ra,8(sp)
ffffffffc0201196:	6402                	ld	s0,0(sp)
ffffffffc0201198:	fff80737          	lui	a4,0xfff80
ffffffffc020119c:	97ba                	add	a5,a5,a4
ffffffffc020119e:	079a                	slli	a5,a5,0x6
ffffffffc02011a0:	953e                	add	a0,a0,a5
ffffffffc02011a2:	0141                	addi	sp,sp,16
ffffffffc02011a4:	8082                	ret
ffffffffc02011a6:	60a2                	ld	ra,8(sp)
ffffffffc02011a8:	6402                	ld	s0,0(sp)
    return NULL;
ffffffffc02011aa:	4501                	li	a0,0
}
ffffffffc02011ac:	0141                	addi	sp,sp,16
ffffffffc02011ae:	8082                	ret
ffffffffc02011b0:	ca7ff0ef          	jal	ra,ffffffffc0200e56 <pa2page.part.4>

ffffffffc02011b4 <unmap_range>:
        *ptep = 0;                  //(5) clear second page table entry
        tlb_invalidate(pgdir, la);  //(6) flush tlb
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc02011b4:	711d                	addi	sp,sp,-96
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02011b6:	00c5e7b3          	or	a5,a1,a2
void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc02011ba:	ec86                	sd	ra,88(sp)
ffffffffc02011bc:	e8a2                	sd	s0,80(sp)
ffffffffc02011be:	e4a6                	sd	s1,72(sp)
ffffffffc02011c0:	e0ca                	sd	s2,64(sp)
ffffffffc02011c2:	fc4e                	sd	s3,56(sp)
ffffffffc02011c4:	f852                	sd	s4,48(sp)
ffffffffc02011c6:	f456                	sd	s5,40(sp)
ffffffffc02011c8:	f05a                	sd	s6,32(sp)
ffffffffc02011ca:	ec5e                	sd	s7,24(sp)
ffffffffc02011cc:	e862                	sd	s8,16(sp)
ffffffffc02011ce:	e466                	sd	s9,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02011d0:	03479713          	slli	a4,a5,0x34
ffffffffc02011d4:	eb71                	bnez	a4,ffffffffc02012a8 <unmap_range+0xf4>
    assert(USER_ACCESS(start, end));
ffffffffc02011d6:	002007b7          	lui	a5,0x200
ffffffffc02011da:	842e                	mv	s0,a1
ffffffffc02011dc:	0af5e663          	bltu	a1,a5,ffffffffc0201288 <unmap_range+0xd4>
ffffffffc02011e0:	8932                	mv	s2,a2
ffffffffc02011e2:	0ac5f363          	bleu	a2,a1,ffffffffc0201288 <unmap_range+0xd4>
ffffffffc02011e6:	4785                	li	a5,1
ffffffffc02011e8:	07fe                	slli	a5,a5,0x1f
ffffffffc02011ea:	08c7ef63          	bltu	a5,a2,ffffffffc0201288 <unmap_range+0xd4>
ffffffffc02011ee:	89aa                	mv	s3,a0
            continue;
        }
        if (*ptep != 0) {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02011f0:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage) {
ffffffffc02011f2:	000abc97          	auipc	s9,0xab
ffffffffc02011f6:	336c8c93          	addi	s9,s9,822 # ffffffffc02ac528 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02011fa:	000abc17          	auipc	s8,0xab
ffffffffc02011fe:	396c0c13          	addi	s8,s8,918 # ffffffffc02ac590 <pages>
ffffffffc0201202:	fff80bb7          	lui	s7,0xfff80
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0201206:	00200b37          	lui	s6,0x200
ffffffffc020120a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020120e:	4601                	li	a2,0
ffffffffc0201210:	85a2                	mv	a1,s0
ffffffffc0201212:	854e                	mv	a0,s3
ffffffffc0201214:	d6dff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0201218:	84aa                	mv	s1,a0
        if (ptep == NULL) {
ffffffffc020121a:	cd21                	beqz	a0,ffffffffc0201272 <unmap_range+0xbe>
        if (*ptep != 0) {
ffffffffc020121c:	611c                	ld	a5,0(a0)
ffffffffc020121e:	e38d                	bnez	a5,ffffffffc0201240 <unmap_range+0x8c>
        start += PGSIZE;
ffffffffc0201220:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0201222:	ff2466e3          	bltu	s0,s2,ffffffffc020120e <unmap_range+0x5a>
}
ffffffffc0201226:	60e6                	ld	ra,88(sp)
ffffffffc0201228:	6446                	ld	s0,80(sp)
ffffffffc020122a:	64a6                	ld	s1,72(sp)
ffffffffc020122c:	6906                	ld	s2,64(sp)
ffffffffc020122e:	79e2                	ld	s3,56(sp)
ffffffffc0201230:	7a42                	ld	s4,48(sp)
ffffffffc0201232:	7aa2                	ld	s5,40(sp)
ffffffffc0201234:	7b02                	ld	s6,32(sp)
ffffffffc0201236:	6be2                	ld	s7,24(sp)
ffffffffc0201238:	6c42                	ld	s8,16(sp)
ffffffffc020123a:	6ca2                	ld	s9,8(sp)
ffffffffc020123c:	6125                	addi	sp,sp,96
ffffffffc020123e:	8082                	ret
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0201240:	0017f713          	andi	a4,a5,1
ffffffffc0201244:	df71                	beqz	a4,ffffffffc0201220 <unmap_range+0x6c>
    if (PPN(pa) >= npage) {
ffffffffc0201246:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020124a:	078a                	slli	a5,a5,0x2
ffffffffc020124c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020124e:	06e7fd63          	bleu	a4,a5,ffffffffc02012c8 <unmap_range+0x114>
    return &pages[PPN(pa) - nbase];
ffffffffc0201252:	000c3503          	ld	a0,0(s8)
ffffffffc0201256:	97de                	add	a5,a5,s7
ffffffffc0201258:	079a                	slli	a5,a5,0x6
ffffffffc020125a:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020125c:	411c                	lw	a5,0(a0)
ffffffffc020125e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201262:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0201264:	cf11                	beqz	a4,ffffffffc0201280 <unmap_range+0xcc>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0201266:	0004b023          	sd	zero,0(s1)
}

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la) {
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020126a:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc020126e:	9452                	add	s0,s0,s4
ffffffffc0201270:	bf4d                	j	ffffffffc0201222 <unmap_range+0x6e>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0201272:	945a                	add	s0,s0,s6
ffffffffc0201274:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0201278:	d45d                	beqz	s0,ffffffffc0201226 <unmap_range+0x72>
ffffffffc020127a:	f9246ae3          	bltu	s0,s2,ffffffffc020120e <unmap_range+0x5a>
ffffffffc020127e:	b765                	j	ffffffffc0201226 <unmap_range+0x72>
            free_page(page);
ffffffffc0201280:	4585                	li	a1,1
ffffffffc0201282:	c79ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
ffffffffc0201286:	b7c5                	j	ffffffffc0201266 <unmap_range+0xb2>
    assert(USER_ACCESS(start, end));
ffffffffc0201288:	00006697          	auipc	a3,0x6
ffffffffc020128c:	3b068693          	addi	a3,a3,944 # ffffffffc0207638 <commands+0xe90>
ffffffffc0201290:	00006617          	auipc	a2,0x6
ffffffffc0201294:	99860613          	addi	a2,a2,-1640 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201298:	11000593          	li	a1,272
ffffffffc020129c:	00006517          	auipc	a0,0x6
ffffffffc02012a0:	d9c50513          	addi	a0,a0,-612 # ffffffffc0207038 <commands+0x890>
ffffffffc02012a4:	f73fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02012a8:	00006697          	auipc	a3,0x6
ffffffffc02012ac:	36068693          	addi	a3,a3,864 # ffffffffc0207608 <commands+0xe60>
ffffffffc02012b0:	00006617          	auipc	a2,0x6
ffffffffc02012b4:	97860613          	addi	a2,a2,-1672 # ffffffffc0206c28 <commands+0x480>
ffffffffc02012b8:	10f00593          	li	a1,271
ffffffffc02012bc:	00006517          	auipc	a0,0x6
ffffffffc02012c0:	d7c50513          	addi	a0,a0,-644 # ffffffffc0207038 <commands+0x890>
ffffffffc02012c4:	f53fe0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc02012c8:	b8fff0ef          	jal	ra,ffffffffc0200e56 <pa2page.part.4>

ffffffffc02012cc <exit_range>:
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc02012cc:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02012ce:	00c5e7b3          	or	a5,a1,a2
void exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
ffffffffc02012d2:	fc86                	sd	ra,120(sp)
ffffffffc02012d4:	f8a2                	sd	s0,112(sp)
ffffffffc02012d6:	f4a6                	sd	s1,104(sp)
ffffffffc02012d8:	f0ca                	sd	s2,96(sp)
ffffffffc02012da:	ecce                	sd	s3,88(sp)
ffffffffc02012dc:	e8d2                	sd	s4,80(sp)
ffffffffc02012de:	e4d6                	sd	s5,72(sp)
ffffffffc02012e0:	e0da                	sd	s6,64(sp)
ffffffffc02012e2:	fc5e                	sd	s7,56(sp)
ffffffffc02012e4:	f862                	sd	s8,48(sp)
ffffffffc02012e6:	f466                	sd	s9,40(sp)
ffffffffc02012e8:	f06a                	sd	s10,32(sp)
ffffffffc02012ea:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02012ec:	03479713          	slli	a4,a5,0x34
ffffffffc02012f0:	1c071163          	bnez	a4,ffffffffc02014b2 <exit_range+0x1e6>
    assert(USER_ACCESS(start, end));
ffffffffc02012f4:	002007b7          	lui	a5,0x200
ffffffffc02012f8:	20f5e563          	bltu	a1,a5,ffffffffc0201502 <exit_range+0x236>
ffffffffc02012fc:	8b32                	mv	s6,a2
ffffffffc02012fe:	20c5f263          	bleu	a2,a1,ffffffffc0201502 <exit_range+0x236>
ffffffffc0201302:	4785                	li	a5,1
ffffffffc0201304:	07fe                	slli	a5,a5,0x1f
ffffffffc0201306:	1ec7ee63          	bltu	a5,a2,ffffffffc0201502 <exit_range+0x236>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020130a:	c00009b7          	lui	s3,0xc0000
ffffffffc020130e:	400007b7          	lui	a5,0x40000
ffffffffc0201312:	0135f9b3          	and	s3,a1,s3
ffffffffc0201316:	99be                	add	s3,s3,a5
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0201318:	c0000337          	lui	t1,0xc0000
ffffffffc020131c:	00698933          	add	s2,s3,t1
ffffffffc0201320:	01e95913          	srli	s2,s2,0x1e
ffffffffc0201324:	1ff97913          	andi	s2,s2,511
ffffffffc0201328:	8e2a                	mv	t3,a0
ffffffffc020132a:	090e                	slli	s2,s2,0x3
ffffffffc020132c:	9972                	add	s2,s2,t3
ffffffffc020132e:	00093b83          	ld	s7,0(s2)
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0201332:	ffe004b7          	lui	s1,0xffe00
    return KADDR(page2pa(page));
ffffffffc0201336:	5dfd                	li	s11,-1
        if (pde1&PTE_V){
ffffffffc0201338:	001bf793          	andi	a5,s7,1
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc020133c:	8ced                	and	s1,s1,a1
    if (PPN(pa) >= npage) {
ffffffffc020133e:	000abd17          	auipc	s10,0xab
ffffffffc0201342:	1ead0d13          	addi	s10,s10,490 # ffffffffc02ac528 <npage>
    return KADDR(page2pa(page));
ffffffffc0201346:	00cddd93          	srli	s11,s11,0xc
ffffffffc020134a:	000ab717          	auipc	a4,0xab
ffffffffc020134e:	23670713          	addi	a4,a4,566 # ffffffffc02ac580 <va_pa_offset>
    return &pages[PPN(pa) - nbase];
ffffffffc0201352:	000abe97          	auipc	t4,0xab
ffffffffc0201356:	23ee8e93          	addi	t4,t4,574 # ffffffffc02ac590 <pages>
        if (pde1&PTE_V){
ffffffffc020135a:	e79d                	bnez	a5,ffffffffc0201388 <exit_range+0xbc>
    } while (d1start != 0 && d1start < end);
ffffffffc020135c:	12098963          	beqz	s3,ffffffffc020148e <exit_range+0x1c2>
ffffffffc0201360:	400007b7          	lui	a5,0x40000
ffffffffc0201364:	84ce                	mv	s1,s3
ffffffffc0201366:	97ce                	add	a5,a5,s3
ffffffffc0201368:	1369f363          	bleu	s6,s3,ffffffffc020148e <exit_range+0x1c2>
ffffffffc020136c:	89be                	mv	s3,a5
        pde1 = pgdir[PDX1(d1start)];
ffffffffc020136e:	00698933          	add	s2,s3,t1
ffffffffc0201372:	01e95913          	srli	s2,s2,0x1e
ffffffffc0201376:	1ff97913          	andi	s2,s2,511
ffffffffc020137a:	090e                	slli	s2,s2,0x3
ffffffffc020137c:	9972                	add	s2,s2,t3
ffffffffc020137e:	00093b83          	ld	s7,0(s2)
        if (pde1&PTE_V){
ffffffffc0201382:	001bf793          	andi	a5,s7,1
ffffffffc0201386:	dbf9                	beqz	a5,ffffffffc020135c <exit_range+0x90>
    if (PPN(pa) >= npage) {
ffffffffc0201388:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020138c:	0b8a                	slli	s7,s7,0x2
ffffffffc020138e:	00cbdb93          	srli	s7,s7,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201392:	14fbfc63          	bleu	a5,s7,ffffffffc02014ea <exit_range+0x21e>
    return &pages[PPN(pa) - nbase];
ffffffffc0201396:	fff80ab7          	lui	s5,0xfff80
ffffffffc020139a:	9ade                	add	s5,s5,s7
    return page - pages + nbase;
ffffffffc020139c:	000806b7          	lui	a3,0x80
ffffffffc02013a0:	96d6                	add	a3,a3,s5
ffffffffc02013a2:	006a9593          	slli	a1,s5,0x6
    return KADDR(page2pa(page));
ffffffffc02013a6:	01b6f633          	and	a2,a3,s11
    return page - pages + nbase;
ffffffffc02013aa:	e42e                	sd	a1,8(sp)
    return page2ppn(page) << PGSHIFT;
ffffffffc02013ac:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02013ae:	12f67263          	bleu	a5,a2,ffffffffc02014d2 <exit_range+0x206>
ffffffffc02013b2:	00073a03          	ld	s4,0(a4)
            free_pd0 = 1;
ffffffffc02013b6:	4c85                	li	s9,1
    return &pages[PPN(pa) - nbase];
ffffffffc02013b8:	fff808b7          	lui	a7,0xfff80
    return KADDR(page2pa(page));
ffffffffc02013bc:	9a36                	add	s4,s4,a3
    return page - pages + nbase;
ffffffffc02013be:	00080837          	lui	a6,0x80
ffffffffc02013c2:	6a85                	lui	s5,0x1
                d0start += PTSIZE;
ffffffffc02013c4:	00200c37          	lui	s8,0x200
ffffffffc02013c8:	a801                	j	ffffffffc02013d8 <exit_range+0x10c>
                    free_pd0 = 0;
ffffffffc02013ca:	4c81                	li	s9,0
                d0start += PTSIZE;
ffffffffc02013cc:	94e2                	add	s1,s1,s8
            } while (d0start != 0 && d0start < d1start+PDSIZE && d0start < end);
ffffffffc02013ce:	c0d9                	beqz	s1,ffffffffc0201454 <exit_range+0x188>
ffffffffc02013d0:	0934f263          	bleu	s3,s1,ffffffffc0201454 <exit_range+0x188>
ffffffffc02013d4:	0d64fc63          	bleu	s6,s1,ffffffffc02014ac <exit_range+0x1e0>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02013d8:	0154d413          	srli	s0,s1,0x15
ffffffffc02013dc:	1ff47413          	andi	s0,s0,511
ffffffffc02013e0:	040e                	slli	s0,s0,0x3
ffffffffc02013e2:	9452                	add	s0,s0,s4
ffffffffc02013e4:	601c                	ld	a5,0(s0)
                if (pde0&PTE_V) {
ffffffffc02013e6:	0017f693          	andi	a3,a5,1
ffffffffc02013ea:	d2e5                	beqz	a3,ffffffffc02013ca <exit_range+0xfe>
    if (PPN(pa) >= npage) {
ffffffffc02013ec:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02013f0:	00279513          	slli	a0,a5,0x2
ffffffffc02013f4:	8131                	srli	a0,a0,0xc
    if (PPN(pa) >= npage) {
ffffffffc02013f6:	0eb57a63          	bleu	a1,a0,ffffffffc02014ea <exit_range+0x21e>
    return &pages[PPN(pa) - nbase];
ffffffffc02013fa:	9546                	add	a0,a0,a7
    return page - pages + nbase;
ffffffffc02013fc:	010506b3          	add	a3,a0,a6
    return KADDR(page2pa(page));
ffffffffc0201400:	01b6f7b3          	and	a5,a3,s11
    return page - pages + nbase;
ffffffffc0201404:	051a                	slli	a0,a0,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0201406:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201408:	0cb7f563          	bleu	a1,a5,ffffffffc02014d2 <exit_range+0x206>
ffffffffc020140c:	631c                	ld	a5,0(a4)
ffffffffc020140e:	96be                	add	a3,a3,a5
                    for (int i = 0;i <NPTEENTRY;i++)
ffffffffc0201410:	015685b3          	add	a1,a3,s5
                        if (pt[i]&PTE_V){
ffffffffc0201414:	629c                	ld	a5,0(a3)
ffffffffc0201416:	8b85                	andi	a5,a5,1
ffffffffc0201418:	fbd5                	bnez	a5,ffffffffc02013cc <exit_range+0x100>
ffffffffc020141a:	06a1                	addi	a3,a3,8
                    for (int i = 0;i <NPTEENTRY;i++)
ffffffffc020141c:	fed59ce3          	bne	a1,a3,ffffffffc0201414 <exit_range+0x148>
    return &pages[PPN(pa) - nbase];
ffffffffc0201420:	000eb783          	ld	a5,0(t4)
                        free_page(pde2page(pde0));
ffffffffc0201424:	4585                	li	a1,1
ffffffffc0201426:	e072                	sd	t3,0(sp)
ffffffffc0201428:	953e                	add	a0,a0,a5
ffffffffc020142a:	ad1ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
                d0start += PTSIZE;
ffffffffc020142e:	94e2                	add	s1,s1,s8
                        pd0[PDX0(d0start)] = 0;
ffffffffc0201430:	00043023          	sd	zero,0(s0)
ffffffffc0201434:	000abe97          	auipc	t4,0xab
ffffffffc0201438:	15ce8e93          	addi	t4,t4,348 # ffffffffc02ac590 <pages>
ffffffffc020143c:	6e02                	ld	t3,0(sp)
ffffffffc020143e:	c0000337          	lui	t1,0xc0000
ffffffffc0201442:	fff808b7          	lui	a7,0xfff80
ffffffffc0201446:	00080837          	lui	a6,0x80
ffffffffc020144a:	000ab717          	auipc	a4,0xab
ffffffffc020144e:	13670713          	addi	a4,a4,310 # ffffffffc02ac580 <va_pa_offset>
            } while (d0start != 0 && d0start < d1start+PDSIZE && d0start < end);
ffffffffc0201452:	fcbd                	bnez	s1,ffffffffc02013d0 <exit_range+0x104>
            if (free_pd0) {
ffffffffc0201454:	f00c84e3          	beqz	s9,ffffffffc020135c <exit_range+0x90>
    if (PPN(pa) >= npage) {
ffffffffc0201458:	000d3783          	ld	a5,0(s10)
ffffffffc020145c:	e072                	sd	t3,0(sp)
ffffffffc020145e:	08fbf663          	bleu	a5,s7,ffffffffc02014ea <exit_range+0x21e>
    return &pages[PPN(pa) - nbase];
ffffffffc0201462:	000eb503          	ld	a0,0(t4)
                free_page(pde2page(pde1));
ffffffffc0201466:	67a2                	ld	a5,8(sp)
ffffffffc0201468:	4585                	li	a1,1
ffffffffc020146a:	953e                	add	a0,a0,a5
ffffffffc020146c:	a8fff0ef          	jal	ra,ffffffffc0200efa <free_pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0201470:	00093023          	sd	zero,0(s2)
ffffffffc0201474:	000ab717          	auipc	a4,0xab
ffffffffc0201478:	10c70713          	addi	a4,a4,268 # ffffffffc02ac580 <va_pa_offset>
ffffffffc020147c:	c0000337          	lui	t1,0xc0000
ffffffffc0201480:	6e02                	ld	t3,0(sp)
ffffffffc0201482:	000abe97          	auipc	t4,0xab
ffffffffc0201486:	10ee8e93          	addi	t4,t4,270 # ffffffffc02ac590 <pages>
    } while (d1start != 0 && d1start < end);
ffffffffc020148a:	ec099be3          	bnez	s3,ffffffffc0201360 <exit_range+0x94>
}
ffffffffc020148e:	70e6                	ld	ra,120(sp)
ffffffffc0201490:	7446                	ld	s0,112(sp)
ffffffffc0201492:	74a6                	ld	s1,104(sp)
ffffffffc0201494:	7906                	ld	s2,96(sp)
ffffffffc0201496:	69e6                	ld	s3,88(sp)
ffffffffc0201498:	6a46                	ld	s4,80(sp)
ffffffffc020149a:	6aa6                	ld	s5,72(sp)
ffffffffc020149c:	6b06                	ld	s6,64(sp)
ffffffffc020149e:	7be2                	ld	s7,56(sp)
ffffffffc02014a0:	7c42                	ld	s8,48(sp)
ffffffffc02014a2:	7ca2                	ld	s9,40(sp)
ffffffffc02014a4:	7d02                	ld	s10,32(sp)
ffffffffc02014a6:	6de2                	ld	s11,24(sp)
ffffffffc02014a8:	6109                	addi	sp,sp,128
ffffffffc02014aa:	8082                	ret
            if (free_pd0) {
ffffffffc02014ac:	ea0c8ae3          	beqz	s9,ffffffffc0201360 <exit_range+0x94>
ffffffffc02014b0:	b765                	j	ffffffffc0201458 <exit_range+0x18c>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02014b2:	00006697          	auipc	a3,0x6
ffffffffc02014b6:	15668693          	addi	a3,a3,342 # ffffffffc0207608 <commands+0xe60>
ffffffffc02014ba:	00005617          	auipc	a2,0x5
ffffffffc02014be:	76e60613          	addi	a2,a2,1902 # ffffffffc0206c28 <commands+0x480>
ffffffffc02014c2:	12000593          	li	a1,288
ffffffffc02014c6:	00006517          	auipc	a0,0x6
ffffffffc02014ca:	b7250513          	addi	a0,a0,-1166 # ffffffffc0207038 <commands+0x890>
ffffffffc02014ce:	d49fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    return KADDR(page2pa(page));
ffffffffc02014d2:	00006617          	auipc	a2,0x6
ffffffffc02014d6:	b3e60613          	addi	a2,a2,-1218 # ffffffffc0207010 <commands+0x868>
ffffffffc02014da:	06900593          	li	a1,105
ffffffffc02014de:	00006517          	auipc	a0,0x6
ffffffffc02014e2:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02014e6:	d31fe0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02014ea:	00006617          	auipc	a2,0x6
ffffffffc02014ee:	b5e60613          	addi	a2,a2,-1186 # ffffffffc0207048 <commands+0x8a0>
ffffffffc02014f2:	06200593          	li	a1,98
ffffffffc02014f6:	00006517          	auipc	a0,0x6
ffffffffc02014fa:	b7250513          	addi	a0,a0,-1166 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02014fe:	d19fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0201502:	00006697          	auipc	a3,0x6
ffffffffc0201506:	13668693          	addi	a3,a3,310 # ffffffffc0207638 <commands+0xe90>
ffffffffc020150a:	00005617          	auipc	a2,0x5
ffffffffc020150e:	71e60613          	addi	a2,a2,1822 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201512:	12100593          	li	a1,289
ffffffffc0201516:	00006517          	auipc	a0,0x6
ffffffffc020151a:	b2250513          	addi	a0,a0,-1246 # ffffffffc0207038 <commands+0x890>
ffffffffc020151e:	cf9fe0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0201522 <page_remove>:
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201522:	1101                	addi	sp,sp,-32
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201524:	4601                	li	a2,0
void page_remove(pde_t *pgdir, uintptr_t la) {
ffffffffc0201526:	e426                	sd	s1,8(sp)
ffffffffc0201528:	ec06                	sd	ra,24(sp)
ffffffffc020152a:	e822                	sd	s0,16(sp)
ffffffffc020152c:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020152e:	a53ff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
    if (ptep != NULL) {
ffffffffc0201532:	c511                	beqz	a0,ffffffffc020153e <page_remove+0x1c>
    if (*ptep & PTE_V) {  //(1) check if this page table entry is
ffffffffc0201534:	611c                	ld	a5,0(a0)
ffffffffc0201536:	842a                	mv	s0,a0
ffffffffc0201538:	0017f713          	andi	a4,a5,1
ffffffffc020153c:	e711                	bnez	a4,ffffffffc0201548 <page_remove+0x26>
}
ffffffffc020153e:	60e2                	ld	ra,24(sp)
ffffffffc0201540:	6442                	ld	s0,16(sp)
ffffffffc0201542:	64a2                	ld	s1,8(sp)
ffffffffc0201544:	6105                	addi	sp,sp,32
ffffffffc0201546:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc0201548:	000ab717          	auipc	a4,0xab
ffffffffc020154c:	fe070713          	addi	a4,a4,-32 # ffffffffc02ac528 <npage>
ffffffffc0201550:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201552:	078a                	slli	a5,a5,0x2
ffffffffc0201554:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201556:	02e7fe63          	bleu	a4,a5,ffffffffc0201592 <page_remove+0x70>
    return &pages[PPN(pa) - nbase];
ffffffffc020155a:	000ab717          	auipc	a4,0xab
ffffffffc020155e:	03670713          	addi	a4,a4,54 # ffffffffc02ac590 <pages>
ffffffffc0201562:	6308                	ld	a0,0(a4)
ffffffffc0201564:	fff80737          	lui	a4,0xfff80
ffffffffc0201568:	97ba                	add	a5,a5,a4
ffffffffc020156a:	079a                	slli	a5,a5,0x6
ffffffffc020156c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020156e:	411c                	lw	a5,0(a0)
ffffffffc0201570:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201574:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0201576:	cb11                	beqz	a4,ffffffffc020158a <page_remove+0x68>
        *ptep = 0;                  //(5) clear second page table entry
ffffffffc0201578:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020157c:	12048073          	sfence.vma	s1
}
ffffffffc0201580:	60e2                	ld	ra,24(sp)
ffffffffc0201582:	6442                	ld	s0,16(sp)
ffffffffc0201584:	64a2                	ld	s1,8(sp)
ffffffffc0201586:	6105                	addi	sp,sp,32
ffffffffc0201588:	8082                	ret
            free_page(page);
ffffffffc020158a:	4585                	li	a1,1
ffffffffc020158c:	96fff0ef          	jal	ra,ffffffffc0200efa <free_pages>
ffffffffc0201590:	b7e5                	j	ffffffffc0201578 <page_remove+0x56>
ffffffffc0201592:	8c5ff0ef          	jal	ra,ffffffffc0200e56 <pa2page.part.4>

ffffffffc0201596 <page_insert>:
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc0201596:	7179                	addi	sp,sp,-48
ffffffffc0201598:	e44e                	sd	s3,8(sp)
ffffffffc020159a:	89b2                	mv	s3,a2
ffffffffc020159c:	f022                	sd	s0,32(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020159e:	4605                	li	a2,1
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc02015a0:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02015a2:	85ce                	mv	a1,s3
int page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
ffffffffc02015a4:	ec26                	sd	s1,24(sp)
ffffffffc02015a6:	f406                	sd	ra,40(sp)
ffffffffc02015a8:	e84a                	sd	s2,16(sp)
ffffffffc02015aa:	e052                	sd	s4,0(sp)
ffffffffc02015ac:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02015ae:	9d3ff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
    if (ptep == NULL) {
ffffffffc02015b2:	cd49                	beqz	a0,ffffffffc020164c <page_insert+0xb6>
    page->ref += 1;
ffffffffc02015b4:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V) {
ffffffffc02015b6:	611c                	ld	a5,0(a0)
ffffffffc02015b8:	892a                	mv	s2,a0
ffffffffc02015ba:	0016871b          	addiw	a4,a3,1
ffffffffc02015be:	c018                	sw	a4,0(s0)
ffffffffc02015c0:	0017f713          	andi	a4,a5,1
ffffffffc02015c4:	ef05                	bnez	a4,ffffffffc02015fc <page_insert+0x66>
ffffffffc02015c6:	000ab797          	auipc	a5,0xab
ffffffffc02015ca:	fca78793          	addi	a5,a5,-54 # ffffffffc02ac590 <pages>
ffffffffc02015ce:	6398                	ld	a4,0(a5)
    return page - pages + nbase;
ffffffffc02015d0:	8c19                	sub	s0,s0,a4
ffffffffc02015d2:	000806b7          	lui	a3,0x80
ffffffffc02015d6:	8419                	srai	s0,s0,0x6
ffffffffc02015d8:	9436                	add	s0,s0,a3
  return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02015da:	042a                	slli	s0,s0,0xa
ffffffffc02015dc:	8c45                	or	s0,s0,s1
ffffffffc02015de:	00146413          	ori	s0,s0,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02015e2:	00893023          	sd	s0,0(s2)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02015e6:	12098073          	sfence.vma	s3
    return 0;
ffffffffc02015ea:	4501                	li	a0,0
}
ffffffffc02015ec:	70a2                	ld	ra,40(sp)
ffffffffc02015ee:	7402                	ld	s0,32(sp)
ffffffffc02015f0:	64e2                	ld	s1,24(sp)
ffffffffc02015f2:	6942                	ld	s2,16(sp)
ffffffffc02015f4:	69a2                	ld	s3,8(sp)
ffffffffc02015f6:	6a02                	ld	s4,0(sp)
ffffffffc02015f8:	6145                	addi	sp,sp,48
ffffffffc02015fa:	8082                	ret
    if (PPN(pa) >= npage) {
ffffffffc02015fc:	000ab717          	auipc	a4,0xab
ffffffffc0201600:	f2c70713          	addi	a4,a4,-212 # ffffffffc02ac528 <npage>
ffffffffc0201604:	6318                	ld	a4,0(a4)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201606:	078a                	slli	a5,a5,0x2
ffffffffc0201608:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020160a:	04e7f363          	bleu	a4,a5,ffffffffc0201650 <page_insert+0xba>
    return &pages[PPN(pa) - nbase];
ffffffffc020160e:	000aba17          	auipc	s4,0xab
ffffffffc0201612:	f82a0a13          	addi	s4,s4,-126 # ffffffffc02ac590 <pages>
ffffffffc0201616:	000a3703          	ld	a4,0(s4)
ffffffffc020161a:	fff80537          	lui	a0,0xfff80
ffffffffc020161e:	953e                	add	a0,a0,a5
ffffffffc0201620:	051a                	slli	a0,a0,0x6
ffffffffc0201622:	953a                	add	a0,a0,a4
        if (p == page) {
ffffffffc0201624:	00a40a63          	beq	s0,a0,ffffffffc0201638 <page_insert+0xa2>
    page->ref -= 1;
ffffffffc0201628:	411c                	lw	a5,0(a0)
ffffffffc020162a:	fff7869b          	addiw	a3,a5,-1
ffffffffc020162e:	c114                	sw	a3,0(a0)
        if (page_ref(page) ==
ffffffffc0201630:	c691                	beqz	a3,ffffffffc020163c <page_insert+0xa6>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201632:	12098073          	sfence.vma	s3
ffffffffc0201636:	bf69                	j	ffffffffc02015d0 <page_insert+0x3a>
ffffffffc0201638:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc020163a:	bf59                	j	ffffffffc02015d0 <page_insert+0x3a>
            free_page(page);
ffffffffc020163c:	4585                	li	a1,1
ffffffffc020163e:	8bdff0ef          	jal	ra,ffffffffc0200efa <free_pages>
ffffffffc0201642:	000a3703          	ld	a4,0(s4)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201646:	12098073          	sfence.vma	s3
ffffffffc020164a:	b759                	j	ffffffffc02015d0 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020164c:	5571                	li	a0,-4
ffffffffc020164e:	bf79                	j	ffffffffc02015ec <page_insert+0x56>
ffffffffc0201650:	807ff0ef          	jal	ra,ffffffffc0200e56 <pa2page.part.4>

ffffffffc0201654 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201654:	00007797          	auipc	a5,0x7
ffffffffc0201658:	d1478793          	addi	a5,a5,-748 # ffffffffc0208368 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020165c:	638c                	ld	a1,0(a5)
void pmm_init(void) {
ffffffffc020165e:	715d                	addi	sp,sp,-80
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201660:	00006517          	auipc	a0,0x6
ffffffffc0201664:	a3050513          	addi	a0,a0,-1488 # ffffffffc0207090 <commands+0x8e8>
void pmm_init(void) {
ffffffffc0201668:	e486                	sd	ra,72(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020166a:	000ab717          	auipc	a4,0xab
ffffffffc020166e:	f0f73723          	sd	a5,-242(a4) # ffffffffc02ac578 <pmm_manager>
void pmm_init(void) {
ffffffffc0201672:	e0a2                	sd	s0,64(sp)
ffffffffc0201674:	fc26                	sd	s1,56(sp)
ffffffffc0201676:	f84a                	sd	s2,48(sp)
ffffffffc0201678:	f44e                	sd	s3,40(sp)
ffffffffc020167a:	f052                	sd	s4,32(sp)
ffffffffc020167c:	ec56                	sd	s5,24(sp)
ffffffffc020167e:	e85a                	sd	s6,16(sp)
ffffffffc0201680:	e45e                	sd	s7,8(sp)
ffffffffc0201682:	e062                	sd	s8,0(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0201684:	000ab417          	auipc	s0,0xab
ffffffffc0201688:	ef440413          	addi	s0,s0,-268 # ffffffffc02ac578 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020168c:	a45fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    pmm_manager->init();
ffffffffc0201690:	601c                	ld	a5,0(s0)
ffffffffc0201692:	000ab497          	auipc	s1,0xab
ffffffffc0201696:	e9648493          	addi	s1,s1,-362 # ffffffffc02ac528 <npage>
ffffffffc020169a:	000ab917          	auipc	s2,0xab
ffffffffc020169e:	ef690913          	addi	s2,s2,-266 # ffffffffc02ac590 <pages>
ffffffffc02016a2:	679c                	ld	a5,8(a5)
ffffffffc02016a4:	9782                	jalr	a5
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc02016a6:	57f5                	li	a5,-3
ffffffffc02016a8:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc02016aa:	00006517          	auipc	a0,0x6
ffffffffc02016ae:	9fe50513          	addi	a0,a0,-1538 # ffffffffc02070a8 <commands+0x900>
    va_pa_offset = KERNBASE - 0x80200000;
ffffffffc02016b2:	000ab717          	auipc	a4,0xab
ffffffffc02016b6:	ecf73723          	sd	a5,-306(a4) # ffffffffc02ac580 <va_pa_offset>
    cprintf("physcial memory map:\n");
ffffffffc02016ba:	a17fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02016be:	46c5                	li	a3,17
ffffffffc02016c0:	06ee                	slli	a3,a3,0x1b
ffffffffc02016c2:	40100613          	li	a2,1025
ffffffffc02016c6:	16fd                	addi	a3,a3,-1
ffffffffc02016c8:	0656                	slli	a2,a2,0x15
ffffffffc02016ca:	07e005b7          	lui	a1,0x7e00
ffffffffc02016ce:	00006517          	auipc	a0,0x6
ffffffffc02016d2:	9f250513          	addi	a0,a0,-1550 # ffffffffc02070c0 <commands+0x918>
ffffffffc02016d6:	9fbfe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02016da:	777d                	lui	a4,0xfffff
ffffffffc02016dc:	000ac797          	auipc	a5,0xac
ffffffffc02016e0:	fc378793          	addi	a5,a5,-61 # ffffffffc02ad69f <end+0xfff>
ffffffffc02016e4:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc02016e6:	00088737          	lui	a4,0x88
ffffffffc02016ea:	000ab697          	auipc	a3,0xab
ffffffffc02016ee:	e2e6bf23          	sd	a4,-450(a3) # ffffffffc02ac528 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02016f2:	000ab717          	auipc	a4,0xab
ffffffffc02016f6:	e8f73f23          	sd	a5,-354(a4) # ffffffffc02ac590 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02016fa:	4701                	li	a4,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02016fc:	4685                	li	a3,1
ffffffffc02016fe:	fff80837          	lui	a6,0xfff80
ffffffffc0201702:	a019                	j	ffffffffc0201708 <pmm_init+0xb4>
ffffffffc0201704:	00093783          	ld	a5,0(s2)
        SetPageReserved(pages + i);
ffffffffc0201708:	00671613          	slli	a2,a4,0x6
ffffffffc020170c:	97b2                	add	a5,a5,a2
ffffffffc020170e:	07a1                	addi	a5,a5,8
ffffffffc0201710:	40d7b02f          	amoor.d	zero,a3,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201714:	6090                	ld	a2,0(s1)
ffffffffc0201716:	0705                	addi	a4,a4,1
ffffffffc0201718:	010607b3          	add	a5,a2,a6
ffffffffc020171c:	fef764e3          	bltu	a4,a5,ffffffffc0201704 <pmm_init+0xb0>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201720:	00093503          	ld	a0,0(s2)
ffffffffc0201724:	fe0007b7          	lui	a5,0xfe000
ffffffffc0201728:	00661693          	slli	a3,a2,0x6
ffffffffc020172c:	97aa                	add	a5,a5,a0
ffffffffc020172e:	96be                	add	a3,a3,a5
ffffffffc0201730:	c02007b7          	lui	a5,0xc0200
ffffffffc0201734:	7af6ed63          	bltu	a3,a5,ffffffffc0201eee <pmm_init+0x89a>
ffffffffc0201738:	000ab997          	auipc	s3,0xab
ffffffffc020173c:	e4898993          	addi	s3,s3,-440 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0201740:	0009b583          	ld	a1,0(s3)
    if (freemem < mem_end) {
ffffffffc0201744:	47c5                	li	a5,17
ffffffffc0201746:	07ee                	slli	a5,a5,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201748:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end) {
ffffffffc020174a:	02f6f763          	bleu	a5,a3,ffffffffc0201778 <pmm_init+0x124>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020174e:	6585                	lui	a1,0x1
ffffffffc0201750:	15fd                	addi	a1,a1,-1
ffffffffc0201752:	96ae                	add	a3,a3,a1
    if (PPN(pa) >= npage) {
ffffffffc0201754:	00c6d713          	srli	a4,a3,0xc
ffffffffc0201758:	48c77a63          	bleu	a2,a4,ffffffffc0201bec <pmm_init+0x598>
    pmm_manager->init_memmap(base, n);
ffffffffc020175c:	6010                	ld	a2,0(s0)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020175e:	75fd                	lui	a1,0xfffff
ffffffffc0201760:	8eed                	and	a3,a3,a1
    return &pages[PPN(pa) - nbase];
ffffffffc0201762:	9742                	add	a4,a4,a6
    pmm_manager->init_memmap(base, n);
ffffffffc0201764:	6a10                	ld	a2,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201766:	40d786b3          	sub	a3,a5,a3
ffffffffc020176a:	071a                	slli	a4,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc020176c:	00c6d593          	srli	a1,a3,0xc
ffffffffc0201770:	953a                	add	a0,a0,a4
ffffffffc0201772:	9602                	jalr	a2
ffffffffc0201774:	0009b583          	ld	a1,0(s3)
    cprintf("vapaofset is %llu\n",va_pa_offset);
ffffffffc0201778:	00006517          	auipc	a0,0x6
ffffffffc020177c:	99850513          	addi	a0,a0,-1640 # ffffffffc0207110 <commands+0x968>
ffffffffc0201780:	951fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>

    return page;
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201784:	601c                	ld	a5,0(s0)
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc0201786:	000ab417          	auipc	s0,0xab
ffffffffc020178a:	d9a40413          	addi	s0,s0,-614 # ffffffffc02ac520 <boot_pgdir>
    pmm_manager->check();
ffffffffc020178e:	7b9c                	ld	a5,48(a5)
ffffffffc0201790:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0201792:	00006517          	auipc	a0,0x6
ffffffffc0201796:	99650513          	addi	a0,a0,-1642 # ffffffffc0207128 <commands+0x980>
ffffffffc020179a:	937fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    boot_pgdir = (pte_t*)boot_page_table_sv39;
ffffffffc020179e:	0000a697          	auipc	a3,0xa
ffffffffc02017a2:	86268693          	addi	a3,a3,-1950 # ffffffffc020b000 <boot_page_table_sv39>
ffffffffc02017a6:	000ab797          	auipc	a5,0xab
ffffffffc02017aa:	d6d7bd23          	sd	a3,-646(a5) # ffffffffc02ac520 <boot_pgdir>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc02017ae:	c02007b7          	lui	a5,0xc0200
ffffffffc02017b2:	10f6eae3          	bltu	a3,a5,ffffffffc02020c6 <pmm_init+0xa72>
ffffffffc02017b6:	0009b783          	ld	a5,0(s3)
ffffffffc02017ba:	8e9d                	sub	a3,a3,a5
ffffffffc02017bc:	000ab797          	auipc	a5,0xab
ffffffffc02017c0:	dcd7b623          	sd	a3,-564(a5) # ffffffffc02ac588 <boot_cr3>
    // assert(npage <= KMEMSIZE / PGSIZE);
    // The memory starts at 2GB in RISC-V
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store=nr_free_pages();
ffffffffc02017c4:	f7cff0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02017c8:	6098                	ld	a4,0(s1)
ffffffffc02017ca:	c80007b7          	lui	a5,0xc8000
ffffffffc02017ce:	83b1                	srli	a5,a5,0xc
    nr_free_store=nr_free_pages();
ffffffffc02017d0:	8a2a                	mv	s4,a0
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02017d2:	0ce7eae3          	bltu	a5,a4,ffffffffc02020a6 <pmm_init+0xa52>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc02017d6:	6008                	ld	a0,0(s0)
ffffffffc02017d8:	44050463          	beqz	a0,ffffffffc0201c20 <pmm_init+0x5cc>
ffffffffc02017dc:	6785                	lui	a5,0x1
ffffffffc02017de:	17fd                	addi	a5,a5,-1
ffffffffc02017e0:	8fe9                	and	a5,a5,a0
ffffffffc02017e2:	2781                	sext.w	a5,a5
ffffffffc02017e4:	42079e63          	bnez	a5,ffffffffc0201c20 <pmm_init+0x5cc>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc02017e8:	4601                	li	a2,0
ffffffffc02017ea:	4581                	li	a1,0
ffffffffc02017ec:	967ff0ef          	jal	ra,ffffffffc0201152 <get_page>
ffffffffc02017f0:	78051b63          	bnez	a0,ffffffffc0201f86 <pmm_init+0x932>

    struct Page *p1, *p2;
    p1 = alloc_page();
ffffffffc02017f4:	4505                	li	a0,1
ffffffffc02017f6:	e7cff0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02017fa:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc02017fc:	6008                	ld	a0,0(s0)
ffffffffc02017fe:	4681                	li	a3,0
ffffffffc0201800:	4601                	li	a2,0
ffffffffc0201802:	85d6                	mv	a1,s5
ffffffffc0201804:	d93ff0ef          	jal	ra,ffffffffc0201596 <page_insert>
ffffffffc0201808:	7a051f63          	bnez	a0,ffffffffc0201fc6 <pmm_init+0x972>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc020180c:	6008                	ld	a0,0(s0)
ffffffffc020180e:	4601                	li	a2,0
ffffffffc0201810:	4581                	li	a1,0
ffffffffc0201812:	f6eff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0201816:	78050863          	beqz	a0,ffffffffc0201fa6 <pmm_init+0x952>
    assert(pte2page(*ptep) == p1);
ffffffffc020181a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc020181c:	0017f713          	andi	a4,a5,1
ffffffffc0201820:	3e070463          	beqz	a4,ffffffffc0201c08 <pmm_init+0x5b4>
    if (PPN(pa) >= npage) {
ffffffffc0201824:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201826:	078a                	slli	a5,a5,0x2
ffffffffc0201828:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020182a:	3ce7f163          	bleu	a4,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc020182e:	00093683          	ld	a3,0(s2)
ffffffffc0201832:	fff80637          	lui	a2,0xfff80
ffffffffc0201836:	97b2                	add	a5,a5,a2
ffffffffc0201838:	079a                	slli	a5,a5,0x6
ffffffffc020183a:	97b6                	add	a5,a5,a3
ffffffffc020183c:	72fa9563          	bne	s5,a5,ffffffffc0201f66 <pmm_init+0x912>
    assert(page_ref(p1) == 1);
ffffffffc0201840:	000aab83          	lw	s7,0(s5) # 1000 <_binary_obj___user_faultread_out_size-0x8588>
ffffffffc0201844:	4785                	li	a5,1
ffffffffc0201846:	70fb9063          	bne	s7,a5,ffffffffc0201f46 <pmm_init+0x8f2>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc020184a:	6008                	ld	a0,0(s0)
ffffffffc020184c:	76fd                	lui	a3,0xfffff
ffffffffc020184e:	611c                	ld	a5,0(a0)
ffffffffc0201850:	078a                	slli	a5,a5,0x2
ffffffffc0201852:	8ff5                	and	a5,a5,a3
ffffffffc0201854:	00c7d613          	srli	a2,a5,0xc
ffffffffc0201858:	66e67e63          	bleu	a4,a2,ffffffffc0201ed4 <pmm_init+0x880>
ffffffffc020185c:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201860:	97e2                	add	a5,a5,s8
ffffffffc0201862:	0007bb03          	ld	s6,0(a5) # 1000 <_binary_obj___user_faultread_out_size-0x8588>
ffffffffc0201866:	0b0a                	slli	s6,s6,0x2
ffffffffc0201868:	00db7b33          	and	s6,s6,a3
ffffffffc020186c:	00cb5793          	srli	a5,s6,0xc
ffffffffc0201870:	56e7f863          	bleu	a4,a5,ffffffffc0201de0 <pmm_init+0x78c>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201874:	4601                	li	a2,0
ffffffffc0201876:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201878:	9b62                	add	s6,s6,s8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc020187a:	f06ff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020187e:	0b21                	addi	s6,s6,8
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201880:	55651063          	bne	a0,s6,ffffffffc0201dc0 <pmm_init+0x76c>

    p2 = alloc_page();
ffffffffc0201884:	4505                	li	a0,1
ffffffffc0201886:	decff0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020188a:	8b2a                	mv	s6,a0
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020188c:	6008                	ld	a0,0(s0)
ffffffffc020188e:	46d1                	li	a3,20
ffffffffc0201890:	6605                	lui	a2,0x1
ffffffffc0201892:	85da                	mv	a1,s6
ffffffffc0201894:	d03ff0ef          	jal	ra,ffffffffc0201596 <page_insert>
ffffffffc0201898:	50051463          	bnez	a0,ffffffffc0201da0 <pmm_init+0x74c>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc020189c:	6008                	ld	a0,0(s0)
ffffffffc020189e:	4601                	li	a2,0
ffffffffc02018a0:	6585                	lui	a1,0x1
ffffffffc02018a2:	edeff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc02018a6:	4c050d63          	beqz	a0,ffffffffc0201d80 <pmm_init+0x72c>
    assert(*ptep & PTE_U);
ffffffffc02018aa:	611c                	ld	a5,0(a0)
ffffffffc02018ac:	0107f713          	andi	a4,a5,16
ffffffffc02018b0:	4a070863          	beqz	a4,ffffffffc0201d60 <pmm_init+0x70c>
    assert(*ptep & PTE_W);
ffffffffc02018b4:	8b91                	andi	a5,a5,4
ffffffffc02018b6:	48078563          	beqz	a5,ffffffffc0201d40 <pmm_init+0x6ec>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc02018ba:	6008                	ld	a0,0(s0)
ffffffffc02018bc:	611c                	ld	a5,0(a0)
ffffffffc02018be:	8bc1                	andi	a5,a5,16
ffffffffc02018c0:	46078063          	beqz	a5,ffffffffc0201d20 <pmm_init+0x6cc>
    assert(page_ref(p2) == 1);
ffffffffc02018c4:	000b2783          	lw	a5,0(s6) # 200000 <_binary_obj___user_exit_out_size+0x1f5578>
ffffffffc02018c8:	43779c63          	bne	a5,s7,ffffffffc0201d00 <pmm_init+0x6ac>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc02018cc:	4681                	li	a3,0
ffffffffc02018ce:	6605                	lui	a2,0x1
ffffffffc02018d0:	85d6                	mv	a1,s5
ffffffffc02018d2:	cc5ff0ef          	jal	ra,ffffffffc0201596 <page_insert>
ffffffffc02018d6:	40051563          	bnez	a0,ffffffffc0201ce0 <pmm_init+0x68c>
    assert(page_ref(p1) == 2);
ffffffffc02018da:	000aa703          	lw	a4,0(s5)
ffffffffc02018de:	4789                	li	a5,2
ffffffffc02018e0:	3ef71063          	bne	a4,a5,ffffffffc0201cc0 <pmm_init+0x66c>
    assert(page_ref(p2) == 0);
ffffffffc02018e4:	000b2783          	lw	a5,0(s6)
ffffffffc02018e8:	3a079c63          	bnez	a5,ffffffffc0201ca0 <pmm_init+0x64c>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc02018ec:	6008                	ld	a0,0(s0)
ffffffffc02018ee:	4601                	li	a2,0
ffffffffc02018f0:	6585                	lui	a1,0x1
ffffffffc02018f2:	e8eff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc02018f6:	38050563          	beqz	a0,ffffffffc0201c80 <pmm_init+0x62c>
    assert(pte2page(*ptep) == p1);
ffffffffc02018fa:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc02018fc:	00177793          	andi	a5,a4,1
ffffffffc0201900:	30078463          	beqz	a5,ffffffffc0201c08 <pmm_init+0x5b4>
    if (PPN(pa) >= npage) {
ffffffffc0201904:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201906:	00271793          	slli	a5,a4,0x2
ffffffffc020190a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020190c:	2ed7f063          	bleu	a3,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201910:	00093683          	ld	a3,0(s2)
ffffffffc0201914:	fff80637          	lui	a2,0xfff80
ffffffffc0201918:	97b2                	add	a5,a5,a2
ffffffffc020191a:	079a                	slli	a5,a5,0x6
ffffffffc020191c:	97b6                	add	a5,a5,a3
ffffffffc020191e:	32fa9163          	bne	s5,a5,ffffffffc0201c40 <pmm_init+0x5ec>
    assert((*ptep & PTE_U) == 0);
ffffffffc0201922:	8b41                	andi	a4,a4,16
ffffffffc0201924:	70071163          	bnez	a4,ffffffffc0202026 <pmm_init+0x9d2>

    page_remove(boot_pgdir, 0x0);
ffffffffc0201928:	6008                	ld	a0,0(s0)
ffffffffc020192a:	4581                	li	a1,0
ffffffffc020192c:	bf7ff0ef          	jal	ra,ffffffffc0201522 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0201930:	000aa703          	lw	a4,0(s5)
ffffffffc0201934:	4785                	li	a5,1
ffffffffc0201936:	6cf71863          	bne	a4,a5,ffffffffc0202006 <pmm_init+0x9b2>
    assert(page_ref(p2) == 0);
ffffffffc020193a:	000b2783          	lw	a5,0(s6)
ffffffffc020193e:	6a079463          	bnez	a5,ffffffffc0201fe6 <pmm_init+0x992>

    page_remove(boot_pgdir, PGSIZE);
ffffffffc0201942:	6008                	ld	a0,0(s0)
ffffffffc0201944:	6585                	lui	a1,0x1
ffffffffc0201946:	bddff0ef          	jal	ra,ffffffffc0201522 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc020194a:	000aa783          	lw	a5,0(s5)
ffffffffc020194e:	50079363          	bnez	a5,ffffffffc0201e54 <pmm_init+0x800>
    assert(page_ref(p2) == 0);
ffffffffc0201952:	000b2783          	lw	a5,0(s6)
ffffffffc0201956:	4c079f63          	bnez	a5,ffffffffc0201e34 <pmm_init+0x7e0>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc020195a:	00043a83          	ld	s5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc020195e:	6090                	ld	a2,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201960:	000ab783          	ld	a5,0(s5)
ffffffffc0201964:	078a                	slli	a5,a5,0x2
ffffffffc0201966:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201968:	28c7f263          	bleu	a2,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc020196c:	fff80737          	lui	a4,0xfff80
ffffffffc0201970:	00093503          	ld	a0,0(s2)
ffffffffc0201974:	97ba                	add	a5,a5,a4
ffffffffc0201976:	079a                	slli	a5,a5,0x6
ffffffffc0201978:	00f50733          	add	a4,a0,a5
ffffffffc020197c:	4314                	lw	a3,0(a4)
ffffffffc020197e:	4705                	li	a4,1
ffffffffc0201980:	48e69a63          	bne	a3,a4,ffffffffc0201e14 <pmm_init+0x7c0>
    return page - pages + nbase;
ffffffffc0201984:	8799                	srai	a5,a5,0x6
ffffffffc0201986:	00080b37          	lui	s6,0x80
    return KADDR(page2pa(page));
ffffffffc020198a:	577d                	li	a4,-1
    return page - pages + nbase;
ffffffffc020198c:	97da                	add	a5,a5,s6
    return KADDR(page2pa(page));
ffffffffc020198e:	8331                	srli	a4,a4,0xc
ffffffffc0201990:	8f7d                	and	a4,a4,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0201992:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0201994:	46c77363          	bleu	a2,a4,ffffffffc0201dfa <pmm_init+0x7a6>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0201998:	0009b683          	ld	a3,0(s3)
ffffffffc020199c:	97b6                	add	a5,a5,a3
    return pa2page(PDE_ADDR(pde));
ffffffffc020199e:	639c                	ld	a5,0(a5)
ffffffffc02019a0:	078a                	slli	a5,a5,0x2
ffffffffc02019a2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02019a4:	24c7f463          	bleu	a2,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc02019a8:	416787b3          	sub	a5,a5,s6
ffffffffc02019ac:	079a                	slli	a5,a5,0x6
ffffffffc02019ae:	953e                	add	a0,a0,a5
ffffffffc02019b0:	4585                	li	a1,1
ffffffffc02019b2:	d48ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc02019b6:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage) {
ffffffffc02019ba:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02019bc:	078a                	slli	a5,a5,0x2
ffffffffc02019be:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02019c0:	22e7f663          	bleu	a4,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc02019c4:	00093503          	ld	a0,0(s2)
ffffffffc02019c8:	416787b3          	sub	a5,a5,s6
ffffffffc02019cc:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc02019ce:	953e                	add	a0,a0,a5
ffffffffc02019d0:	4585                	li	a1,1
ffffffffc02019d2:	d28ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
    boot_pgdir[0] = 0;
ffffffffc02019d6:	601c                	ld	a5,0(s0)
ffffffffc02019d8:	0007b023          	sd	zero,0(a5)
  asm volatile("sfence.vma");
ffffffffc02019dc:	12000073          	sfence.vma
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc02019e0:	d60ff0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
ffffffffc02019e4:	68aa1163          	bne	s4,a0,ffffffffc0202066 <pmm_init+0xa12>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02019e8:	00006517          	auipc	a0,0x6
ffffffffc02019ec:	a5050513          	addi	a0,a0,-1456 # ffffffffc0207438 <commands+0xc90>
ffffffffc02019f0:	ee0fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
static void check_boot_pgdir(void) {
    size_t nr_free_store;
    pte_t *ptep;
    int i;

    nr_free_store=nr_free_pages();
ffffffffc02019f4:	d4cff0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc02019f8:	6098                	ld	a4,0(s1)
ffffffffc02019fa:	c02007b7          	lui	a5,0xc0200
    nr_free_store=nr_free_pages();
ffffffffc02019fe:	8a2a                	mv	s4,a0
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201a00:	00c71693          	slli	a3,a4,0xc
ffffffffc0201a04:	18d7f563          	bleu	a3,a5,ffffffffc0201b8e <pmm_init+0x53a>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201a08:	83b1                	srli	a5,a5,0xc
ffffffffc0201a0a:	6008                	ld	a0,0(s0)
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201a0c:	c0200ab7          	lui	s5,0xc0200
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201a10:	1ae7f163          	bleu	a4,a5,ffffffffc0201bb2 <pmm_init+0x55e>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201a14:	7bfd                	lui	s7,0xfffff
ffffffffc0201a16:	6b05                	lui	s6,0x1
ffffffffc0201a18:	a029                	j	ffffffffc0201a22 <pmm_init+0x3ce>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201a1a:	00cad713          	srli	a4,s5,0xc
ffffffffc0201a1e:	18f77a63          	bleu	a5,a4,ffffffffc0201bb2 <pmm_init+0x55e>
ffffffffc0201a22:	0009b583          	ld	a1,0(s3)
ffffffffc0201a26:	4601                	li	a2,0
ffffffffc0201a28:	95d6                	add	a1,a1,s5
ffffffffc0201a2a:	d56ff0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0201a2e:	16050263          	beqz	a0,ffffffffc0201b92 <pmm_init+0x53e>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201a32:	611c                	ld	a5,0(a0)
ffffffffc0201a34:	078a                	slli	a5,a5,0x2
ffffffffc0201a36:	0177f7b3          	and	a5,a5,s7
ffffffffc0201a3a:	19579963          	bne	a5,s5,ffffffffc0201bcc <pmm_init+0x578>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE) {
ffffffffc0201a3e:	609c                	ld	a5,0(s1)
ffffffffc0201a40:	9ada                	add	s5,s5,s6
ffffffffc0201a42:	6008                	ld	a0,0(s0)
ffffffffc0201a44:	00c79713          	slli	a4,a5,0xc
ffffffffc0201a48:	fceae9e3          	bltu	s5,a4,ffffffffc0201a1a <pmm_init+0x3c6>
    }


    assert(boot_pgdir[0] == 0);
ffffffffc0201a4c:	611c                	ld	a5,0(a0)
ffffffffc0201a4e:	62079c63          	bnez	a5,ffffffffc0202086 <pmm_init+0xa32>

    struct Page *p;
    p = alloc_page();
ffffffffc0201a52:	4505                	li	a0,1
ffffffffc0201a54:	c1eff0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0201a58:	8aaa                	mv	s5,a0
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201a5a:	6008                	ld	a0,0(s0)
ffffffffc0201a5c:	4699                	li	a3,6
ffffffffc0201a5e:	10000613          	li	a2,256
ffffffffc0201a62:	85d6                	mv	a1,s5
ffffffffc0201a64:	b33ff0ef          	jal	ra,ffffffffc0201596 <page_insert>
ffffffffc0201a68:	1e051c63          	bnez	a0,ffffffffc0201c60 <pmm_init+0x60c>
    assert(page_ref(p) == 1);
ffffffffc0201a6c:	000aa703          	lw	a4,0(s5) # ffffffffc0200000 <kern_entry>
ffffffffc0201a70:	4785                	li	a5,1
ffffffffc0201a72:	44f71163          	bne	a4,a5,ffffffffc0201eb4 <pmm_init+0x860>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201a76:	6008                	ld	a0,0(s0)
ffffffffc0201a78:	6b05                	lui	s6,0x1
ffffffffc0201a7a:	4699                	li	a3,6
ffffffffc0201a7c:	100b0613          	addi	a2,s6,256 # 1100 <_binary_obj___user_faultread_out_size-0x8488>
ffffffffc0201a80:	85d6                	mv	a1,s5
ffffffffc0201a82:	b15ff0ef          	jal	ra,ffffffffc0201596 <page_insert>
ffffffffc0201a86:	40051763          	bnez	a0,ffffffffc0201e94 <pmm_init+0x840>
    assert(page_ref(p) == 2);
ffffffffc0201a8a:	000aa703          	lw	a4,0(s5)
ffffffffc0201a8e:	4789                	li	a5,2
ffffffffc0201a90:	3ef71263          	bne	a4,a5,ffffffffc0201e74 <pmm_init+0x820>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0201a94:	00006597          	auipc	a1,0x6
ffffffffc0201a98:	adc58593          	addi	a1,a1,-1316 # ffffffffc0207570 <commands+0xdc8>
ffffffffc0201a9c:	10000513          	li	a0,256
ffffffffc0201aa0:	704040ef          	jal	ra,ffffffffc02061a4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201aa4:	100b0593          	addi	a1,s6,256
ffffffffc0201aa8:	10000513          	li	a0,256
ffffffffc0201aac:	70a040ef          	jal	ra,ffffffffc02061b6 <strcmp>
ffffffffc0201ab0:	44051b63          	bnez	a0,ffffffffc0201f06 <pmm_init+0x8b2>
    return page - pages + nbase;
ffffffffc0201ab4:	00093683          	ld	a3,0(s2)
ffffffffc0201ab8:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0201abc:	5b7d                	li	s6,-1
    return page - pages + nbase;
ffffffffc0201abe:	40da86b3          	sub	a3,s5,a3
ffffffffc0201ac2:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0201ac4:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0201ac6:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0201ac8:	00cb5b13          	srli	s6,s6,0xc
ffffffffc0201acc:	0166f733          	and	a4,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0201ad0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201ad2:	10f77f63          	bleu	a5,a4,ffffffffc0201bf0 <pmm_init+0x59c>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201ad6:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201ada:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201ade:	96be                	add	a3,a3,a5
ffffffffc0201ae0:	10068023          	sb	zero,256(a3) # fffffffffffff100 <end+0x3fd52a60>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201ae4:	67c040ef          	jal	ra,ffffffffc0206160 <strlen>
ffffffffc0201ae8:	54051f63          	bnez	a0,ffffffffc0202046 <pmm_init+0x9f2>

    pde_t *pd1=boot_pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0201aec:	00043b83          	ld	s7,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0201af0:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201af2:	000bb683          	ld	a3,0(s7) # fffffffffffff000 <end+0x3fd52960>
ffffffffc0201af6:	068a                	slli	a3,a3,0x2
ffffffffc0201af8:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201afa:	0ef6f963          	bleu	a5,a3,ffffffffc0201bec <pmm_init+0x598>
    return KADDR(page2pa(page));
ffffffffc0201afe:	0166fb33          	and	s6,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b02:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201b04:	0efb7663          	bleu	a5,s6,ffffffffc0201bf0 <pmm_init+0x59c>
ffffffffc0201b08:	0009b983          	ld	s3,0(s3)
    free_page(p);
ffffffffc0201b0c:	4585                	li	a1,1
ffffffffc0201b0e:	8556                	mv	a0,s5
ffffffffc0201b10:	99b6                	add	s3,s3,a3
ffffffffc0201b12:	be8ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0201b16:	0009b783          	ld	a5,0(s3)
    if (PPN(pa) >= npage) {
ffffffffc0201b1a:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201b1c:	078a                	slli	a5,a5,0x2
ffffffffc0201b1e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201b20:	0ce7f663          	bleu	a4,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201b24:	00093503          	ld	a0,0(s2)
ffffffffc0201b28:	fff809b7          	lui	s3,0xfff80
ffffffffc0201b2c:	97ce                	add	a5,a5,s3
ffffffffc0201b2e:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd0[0]));
ffffffffc0201b30:	953e                	add	a0,a0,a5
ffffffffc0201b32:	4585                	li	a1,1
ffffffffc0201b34:	bc6ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0201b38:	000bb783          	ld	a5,0(s7)
    if (PPN(pa) >= npage) {
ffffffffc0201b3c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201b3e:	078a                	slli	a5,a5,0x2
ffffffffc0201b40:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0201b42:	0ae7f563          	bleu	a4,a5,ffffffffc0201bec <pmm_init+0x598>
    return &pages[PPN(pa) - nbase];
ffffffffc0201b46:	00093503          	ld	a0,0(s2)
ffffffffc0201b4a:	97ce                	add	a5,a5,s3
ffffffffc0201b4c:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc0201b4e:	953e                	add	a0,a0,a5
ffffffffc0201b50:	4585                	li	a1,1
ffffffffc0201b52:	ba8ff0ef          	jal	ra,ffffffffc0200efa <free_pages>
    boot_pgdir[0] = 0;
ffffffffc0201b56:	601c                	ld	a5,0(s0)
ffffffffc0201b58:	0007b023          	sd	zero,0(a5) # ffffffffc0200000 <kern_entry>
  asm volatile("sfence.vma");
ffffffffc0201b5c:	12000073          	sfence.vma
    flush_tlb();

    assert(nr_free_store==nr_free_pages());
ffffffffc0201b60:	be0ff0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
ffffffffc0201b64:	3caa1163          	bne	s4,a0,ffffffffc0201f26 <pmm_init+0x8d2>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0201b68:	00006517          	auipc	a0,0x6
ffffffffc0201b6c:	a8050513          	addi	a0,a0,-1408 # ffffffffc02075e8 <commands+0xe40>
ffffffffc0201b70:	d60fe0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc0201b74:	6406                	ld	s0,64(sp)
ffffffffc0201b76:	60a6                	ld	ra,72(sp)
ffffffffc0201b78:	74e2                	ld	s1,56(sp)
ffffffffc0201b7a:	7942                	ld	s2,48(sp)
ffffffffc0201b7c:	79a2                	ld	s3,40(sp)
ffffffffc0201b7e:	7a02                	ld	s4,32(sp)
ffffffffc0201b80:	6ae2                	ld	s5,24(sp)
ffffffffc0201b82:	6b42                	ld	s6,16(sp)
ffffffffc0201b84:	6ba2                	ld	s7,8(sp)
ffffffffc0201b86:	6c02                	ld	s8,0(sp)
ffffffffc0201b88:	6161                	addi	sp,sp,80
    kmalloc_init();
ffffffffc0201b8a:	13b0106f          	j	ffffffffc02034c4 <kmalloc_init>
ffffffffc0201b8e:	6008                	ld	a0,0(s0)
ffffffffc0201b90:	bd75                	j	ffffffffc0201a4c <pmm_init+0x3f8>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201b92:	00006697          	auipc	a3,0x6
ffffffffc0201b96:	8c668693          	addi	a3,a3,-1850 # ffffffffc0207458 <commands+0xcb0>
ffffffffc0201b9a:	00005617          	auipc	a2,0x5
ffffffffc0201b9e:	08e60613          	addi	a2,a2,142 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201ba2:	22700593          	li	a1,551
ffffffffc0201ba6:	00005517          	auipc	a0,0x5
ffffffffc0201baa:	49250513          	addi	a0,a0,1170 # ffffffffc0207038 <commands+0x890>
ffffffffc0201bae:	e68fe0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0201bb2:	86d6                	mv	a3,s5
ffffffffc0201bb4:	00005617          	auipc	a2,0x5
ffffffffc0201bb8:	45c60613          	addi	a2,a2,1116 # ffffffffc0207010 <commands+0x868>
ffffffffc0201bbc:	22700593          	li	a1,551
ffffffffc0201bc0:	00005517          	auipc	a0,0x5
ffffffffc0201bc4:	47850513          	addi	a0,a0,1144 # ffffffffc0207038 <commands+0x890>
ffffffffc0201bc8:	e4efe0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201bcc:	00006697          	auipc	a3,0x6
ffffffffc0201bd0:	8cc68693          	addi	a3,a3,-1844 # ffffffffc0207498 <commands+0xcf0>
ffffffffc0201bd4:	00005617          	auipc	a2,0x5
ffffffffc0201bd8:	05460613          	addi	a2,a2,84 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201bdc:	22800593          	li	a1,552
ffffffffc0201be0:	00005517          	auipc	a0,0x5
ffffffffc0201be4:	45850513          	addi	a0,a0,1112 # ffffffffc0207038 <commands+0x890>
ffffffffc0201be8:	e2efe0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0201bec:	a6aff0ef          	jal	ra,ffffffffc0200e56 <pa2page.part.4>
    return KADDR(page2pa(page));
ffffffffc0201bf0:	00005617          	auipc	a2,0x5
ffffffffc0201bf4:	42060613          	addi	a2,a2,1056 # ffffffffc0207010 <commands+0x868>
ffffffffc0201bf8:	06900593          	li	a1,105
ffffffffc0201bfc:	00005517          	auipc	a0,0x5
ffffffffc0201c00:	46c50513          	addi	a0,a0,1132 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0201c04:	e12fe0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0201c08:	00005617          	auipc	a2,0x5
ffffffffc0201c0c:	62060613          	addi	a2,a2,1568 # ffffffffc0207228 <commands+0xa80>
ffffffffc0201c10:	07400593          	li	a1,116
ffffffffc0201c14:	00005517          	auipc	a0,0x5
ffffffffc0201c18:	45450513          	addi	a0,a0,1108 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0201c1c:	dfafe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
ffffffffc0201c20:	00005697          	auipc	a3,0x5
ffffffffc0201c24:	54868693          	addi	a3,a3,1352 # ffffffffc0207168 <commands+0x9c0>
ffffffffc0201c28:	00005617          	auipc	a2,0x5
ffffffffc0201c2c:	00060613          	mv	a2,a2
ffffffffc0201c30:	1eb00593          	li	a1,491
ffffffffc0201c34:	00005517          	auipc	a0,0x5
ffffffffc0201c38:	40450513          	addi	a0,a0,1028 # ffffffffc0207038 <commands+0x890>
ffffffffc0201c3c:	ddafe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201c40:	00005697          	auipc	a3,0x5
ffffffffc0201c44:	61068693          	addi	a3,a3,1552 # ffffffffc0207250 <commands+0xaa8>
ffffffffc0201c48:	00005617          	auipc	a2,0x5
ffffffffc0201c4c:	fe060613          	addi	a2,a2,-32 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201c50:	20700593          	li	a1,519
ffffffffc0201c54:	00005517          	auipc	a0,0x5
ffffffffc0201c58:	3e450513          	addi	a0,a0,996 # ffffffffc0207038 <commands+0x890>
ffffffffc0201c5c:	dbafe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201c60:	00006697          	auipc	a3,0x6
ffffffffc0201c64:	86868693          	addi	a3,a3,-1944 # ffffffffc02074c8 <commands+0xd20>
ffffffffc0201c68:	00005617          	auipc	a2,0x5
ffffffffc0201c6c:	fc060613          	addi	a2,a2,-64 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201c70:	23000593          	li	a1,560
ffffffffc0201c74:	00005517          	auipc	a0,0x5
ffffffffc0201c78:	3c450513          	addi	a0,a0,964 # ffffffffc0207038 <commands+0x890>
ffffffffc0201c7c:	d9afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0201c80:	00005697          	auipc	a3,0x5
ffffffffc0201c84:	66068693          	addi	a3,a3,1632 # ffffffffc02072e0 <commands+0xb38>
ffffffffc0201c88:	00005617          	auipc	a2,0x5
ffffffffc0201c8c:	fa060613          	addi	a2,a2,-96 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201c90:	20600593          	li	a1,518
ffffffffc0201c94:	00005517          	auipc	a0,0x5
ffffffffc0201c98:	3a450513          	addi	a0,a0,932 # ffffffffc0207038 <commands+0x890>
ffffffffc0201c9c:	d7afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201ca0:	00005697          	auipc	a3,0x5
ffffffffc0201ca4:	70868693          	addi	a3,a3,1800 # ffffffffc02073a8 <commands+0xc00>
ffffffffc0201ca8:	00005617          	auipc	a2,0x5
ffffffffc0201cac:	f8060613          	addi	a2,a2,-128 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201cb0:	20500593          	li	a1,517
ffffffffc0201cb4:	00005517          	auipc	a0,0x5
ffffffffc0201cb8:	38450513          	addi	a0,a0,900 # ffffffffc0207038 <commands+0x890>
ffffffffc0201cbc:	d5afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0201cc0:	00005697          	auipc	a3,0x5
ffffffffc0201cc4:	6d068693          	addi	a3,a3,1744 # ffffffffc0207390 <commands+0xbe8>
ffffffffc0201cc8:	00005617          	auipc	a2,0x5
ffffffffc0201ccc:	f6060613          	addi	a2,a2,-160 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201cd0:	20400593          	li	a1,516
ffffffffc0201cd4:	00005517          	auipc	a0,0x5
ffffffffc0201cd8:	36450513          	addi	a0,a0,868 # ffffffffc0207038 <commands+0x890>
ffffffffc0201cdc:	d3afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
ffffffffc0201ce0:	00005697          	auipc	a3,0x5
ffffffffc0201ce4:	68068693          	addi	a3,a3,1664 # ffffffffc0207360 <commands+0xbb8>
ffffffffc0201ce8:	00005617          	auipc	a2,0x5
ffffffffc0201cec:	f4060613          	addi	a2,a2,-192 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201cf0:	20300593          	li	a1,515
ffffffffc0201cf4:	00005517          	auipc	a0,0x5
ffffffffc0201cf8:	34450513          	addi	a0,a0,836 # ffffffffc0207038 <commands+0x890>
ffffffffc0201cfc:	d1afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0201d00:	00005697          	auipc	a3,0x5
ffffffffc0201d04:	64868693          	addi	a3,a3,1608 # ffffffffc0207348 <commands+0xba0>
ffffffffc0201d08:	00005617          	auipc	a2,0x5
ffffffffc0201d0c:	f2060613          	addi	a2,a2,-224 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201d10:	20100593          	li	a1,513
ffffffffc0201d14:	00005517          	auipc	a0,0x5
ffffffffc0201d18:	32450513          	addi	a0,a0,804 # ffffffffc0207038 <commands+0x890>
ffffffffc0201d1c:	cfafe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(boot_pgdir[0] & PTE_U);
ffffffffc0201d20:	00005697          	auipc	a3,0x5
ffffffffc0201d24:	61068693          	addi	a3,a3,1552 # ffffffffc0207330 <commands+0xb88>
ffffffffc0201d28:	00005617          	auipc	a2,0x5
ffffffffc0201d2c:	f0060613          	addi	a2,a2,-256 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201d30:	20000593          	li	a1,512
ffffffffc0201d34:	00005517          	auipc	a0,0x5
ffffffffc0201d38:	30450513          	addi	a0,a0,772 # ffffffffc0207038 <commands+0x890>
ffffffffc0201d3c:	cdafe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(*ptep & PTE_W);
ffffffffc0201d40:	00005697          	auipc	a3,0x5
ffffffffc0201d44:	5e068693          	addi	a3,a3,1504 # ffffffffc0207320 <commands+0xb78>
ffffffffc0201d48:	00005617          	auipc	a2,0x5
ffffffffc0201d4c:	ee060613          	addi	a2,a2,-288 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201d50:	1ff00593          	li	a1,511
ffffffffc0201d54:	00005517          	auipc	a0,0x5
ffffffffc0201d58:	2e450513          	addi	a0,a0,740 # ffffffffc0207038 <commands+0x890>
ffffffffc0201d5c:	cbafe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(*ptep & PTE_U);
ffffffffc0201d60:	00005697          	auipc	a3,0x5
ffffffffc0201d64:	5b068693          	addi	a3,a3,1456 # ffffffffc0207310 <commands+0xb68>
ffffffffc0201d68:	00005617          	auipc	a2,0x5
ffffffffc0201d6c:	ec060613          	addi	a2,a2,-320 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201d70:	1fe00593          	li	a1,510
ffffffffc0201d74:	00005517          	auipc	a0,0x5
ffffffffc0201d78:	2c450513          	addi	a0,a0,708 # ffffffffc0207038 <commands+0x890>
ffffffffc0201d7c:	c9afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
ffffffffc0201d80:	00005697          	auipc	a3,0x5
ffffffffc0201d84:	56068693          	addi	a3,a3,1376 # ffffffffc02072e0 <commands+0xb38>
ffffffffc0201d88:	00005617          	auipc	a2,0x5
ffffffffc0201d8c:	ea060613          	addi	a2,a2,-352 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201d90:	1fd00593          	li	a1,509
ffffffffc0201d94:	00005517          	auipc	a0,0x5
ffffffffc0201d98:	2a450513          	addi	a0,a0,676 # ffffffffc0207038 <commands+0x890>
ffffffffc0201d9c:	c7afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0201da0:	00005697          	auipc	a3,0x5
ffffffffc0201da4:	50868693          	addi	a3,a3,1288 # ffffffffc02072a8 <commands+0xb00>
ffffffffc0201da8:	00005617          	auipc	a2,0x5
ffffffffc0201dac:	e8060613          	addi	a2,a2,-384 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201db0:	1fc00593          	li	a1,508
ffffffffc0201db4:	00005517          	auipc	a0,0x5
ffffffffc0201db8:	28450513          	addi	a0,a0,644 # ffffffffc0207038 <commands+0x890>
ffffffffc0201dbc:	c5afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
ffffffffc0201dc0:	00005697          	auipc	a3,0x5
ffffffffc0201dc4:	4c068693          	addi	a3,a3,1216 # ffffffffc0207280 <commands+0xad8>
ffffffffc0201dc8:	00005617          	auipc	a2,0x5
ffffffffc0201dcc:	e6060613          	addi	a2,a2,-416 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201dd0:	1f900593          	li	a1,505
ffffffffc0201dd4:	00005517          	auipc	a0,0x5
ffffffffc0201dd8:	26450513          	addi	a0,a0,612 # ffffffffc0207038 <commands+0x890>
ffffffffc0201ddc:	c3afe0ef          	jal	ra,ffffffffc0200216 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201de0:	86da                	mv	a3,s6
ffffffffc0201de2:	00005617          	auipc	a2,0x5
ffffffffc0201de6:	22e60613          	addi	a2,a2,558 # ffffffffc0207010 <commands+0x868>
ffffffffc0201dea:	1f800593          	li	a1,504
ffffffffc0201dee:	00005517          	auipc	a0,0x5
ffffffffc0201df2:	24a50513          	addi	a0,a0,586 # ffffffffc0207038 <commands+0x890>
ffffffffc0201df6:	c20fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    return KADDR(page2pa(page));
ffffffffc0201dfa:	86be                	mv	a3,a5
ffffffffc0201dfc:	00005617          	auipc	a2,0x5
ffffffffc0201e00:	21460613          	addi	a2,a2,532 # ffffffffc0207010 <commands+0x868>
ffffffffc0201e04:	06900593          	li	a1,105
ffffffffc0201e08:	00005517          	auipc	a0,0x5
ffffffffc0201e0c:	26050513          	addi	a0,a0,608 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0201e10:	c06fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
ffffffffc0201e14:	00005697          	auipc	a3,0x5
ffffffffc0201e18:	5dc68693          	addi	a3,a3,1500 # ffffffffc02073f0 <commands+0xc48>
ffffffffc0201e1c:	00005617          	auipc	a2,0x5
ffffffffc0201e20:	e0c60613          	addi	a2,a2,-500 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201e24:	21200593          	li	a1,530
ffffffffc0201e28:	00005517          	auipc	a0,0x5
ffffffffc0201e2c:	21050513          	addi	a0,a0,528 # ffffffffc0207038 <commands+0x890>
ffffffffc0201e30:	be6fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201e34:	00005697          	auipc	a3,0x5
ffffffffc0201e38:	57468693          	addi	a3,a3,1396 # ffffffffc02073a8 <commands+0xc00>
ffffffffc0201e3c:	00005617          	auipc	a2,0x5
ffffffffc0201e40:	dec60613          	addi	a2,a2,-532 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201e44:	21000593          	li	a1,528
ffffffffc0201e48:	00005517          	auipc	a0,0x5
ffffffffc0201e4c:	1f050513          	addi	a0,a0,496 # ffffffffc0207038 <commands+0x890>
ffffffffc0201e50:	bc6fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0201e54:	00005697          	auipc	a3,0x5
ffffffffc0201e58:	58468693          	addi	a3,a3,1412 # ffffffffc02073d8 <commands+0xc30>
ffffffffc0201e5c:	00005617          	auipc	a2,0x5
ffffffffc0201e60:	dcc60613          	addi	a2,a2,-564 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201e64:	20f00593          	li	a1,527
ffffffffc0201e68:	00005517          	auipc	a0,0x5
ffffffffc0201e6c:	1d050513          	addi	a0,a0,464 # ffffffffc0207038 <commands+0x890>
ffffffffc0201e70:	ba6fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p) == 2);
ffffffffc0201e74:	00005697          	auipc	a3,0x5
ffffffffc0201e78:	6e468693          	addi	a3,a3,1764 # ffffffffc0207558 <commands+0xdb0>
ffffffffc0201e7c:	00005617          	auipc	a2,0x5
ffffffffc0201e80:	dac60613          	addi	a2,a2,-596 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201e84:	23300593          	li	a1,563
ffffffffc0201e88:	00005517          	auipc	a0,0x5
ffffffffc0201e8c:	1b050513          	addi	a0,a0,432 # ffffffffc0207038 <commands+0x890>
ffffffffc0201e90:	b86fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201e94:	00005697          	auipc	a3,0x5
ffffffffc0201e98:	68468693          	addi	a3,a3,1668 # ffffffffc0207518 <commands+0xd70>
ffffffffc0201e9c:	00005617          	auipc	a2,0x5
ffffffffc0201ea0:	d8c60613          	addi	a2,a2,-628 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201ea4:	23200593          	li	a1,562
ffffffffc0201ea8:	00005517          	auipc	a0,0x5
ffffffffc0201eac:	19050513          	addi	a0,a0,400 # ffffffffc0207038 <commands+0x890>
ffffffffc0201eb0:	b66fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p) == 1);
ffffffffc0201eb4:	00005697          	auipc	a3,0x5
ffffffffc0201eb8:	64c68693          	addi	a3,a3,1612 # ffffffffc0207500 <commands+0xd58>
ffffffffc0201ebc:	00005617          	auipc	a2,0x5
ffffffffc0201ec0:	d6c60613          	addi	a2,a2,-660 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201ec4:	23100593          	li	a1,561
ffffffffc0201ec8:	00005517          	auipc	a0,0x5
ffffffffc0201ecc:	17050513          	addi	a0,a0,368 # ffffffffc0207038 <commands+0x890>
ffffffffc0201ed0:	b46fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir[0]));
ffffffffc0201ed4:	86be                	mv	a3,a5
ffffffffc0201ed6:	00005617          	auipc	a2,0x5
ffffffffc0201eda:	13a60613          	addi	a2,a2,314 # ffffffffc0207010 <commands+0x868>
ffffffffc0201ede:	1f700593          	li	a1,503
ffffffffc0201ee2:	00005517          	auipc	a0,0x5
ffffffffc0201ee6:	15650513          	addi	a0,a0,342 # ffffffffc0207038 <commands+0x890>
ffffffffc0201eea:	b2cfe0ef          	jal	ra,ffffffffc0200216 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201eee:	00005617          	auipc	a2,0x5
ffffffffc0201ef2:	1fa60613          	addi	a2,a2,506 # ffffffffc02070e8 <commands+0x940>
ffffffffc0201ef6:	07f00593          	li	a1,127
ffffffffc0201efa:	00005517          	auipc	a0,0x5
ffffffffc0201efe:	13e50513          	addi	a0,a0,318 # ffffffffc0207038 <commands+0x890>
ffffffffc0201f02:	b14fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201f06:	00005697          	auipc	a3,0x5
ffffffffc0201f0a:	68268693          	addi	a3,a3,1666 # ffffffffc0207588 <commands+0xde0>
ffffffffc0201f0e:	00005617          	auipc	a2,0x5
ffffffffc0201f12:	d1a60613          	addi	a2,a2,-742 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201f16:	23700593          	li	a1,567
ffffffffc0201f1a:	00005517          	auipc	a0,0x5
ffffffffc0201f1e:	11e50513          	addi	a0,a0,286 # ffffffffc0207038 <commands+0x890>
ffffffffc0201f22:	af4fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0201f26:	00005697          	auipc	a3,0x5
ffffffffc0201f2a:	4f268693          	addi	a3,a3,1266 # ffffffffc0207418 <commands+0xc70>
ffffffffc0201f2e:	00005617          	auipc	a2,0x5
ffffffffc0201f32:	cfa60613          	addi	a2,a2,-774 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201f36:	24300593          	li	a1,579
ffffffffc0201f3a:	00005517          	auipc	a0,0x5
ffffffffc0201f3e:	0fe50513          	addi	a0,a0,254 # ffffffffc0207038 <commands+0x890>
ffffffffc0201f42:	ad4fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0201f46:	00005697          	auipc	a3,0x5
ffffffffc0201f4a:	32268693          	addi	a3,a3,802 # ffffffffc0207268 <commands+0xac0>
ffffffffc0201f4e:	00005617          	auipc	a2,0x5
ffffffffc0201f52:	cda60613          	addi	a2,a2,-806 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201f56:	1f500593          	li	a1,501
ffffffffc0201f5a:	00005517          	auipc	a0,0x5
ffffffffc0201f5e:	0de50513          	addi	a0,a0,222 # ffffffffc0207038 <commands+0x890>
ffffffffc0201f62:	ab4fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201f66:	00005697          	auipc	a3,0x5
ffffffffc0201f6a:	2ea68693          	addi	a3,a3,746 # ffffffffc0207250 <commands+0xaa8>
ffffffffc0201f6e:	00005617          	auipc	a2,0x5
ffffffffc0201f72:	cba60613          	addi	a2,a2,-838 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201f76:	1f400593          	li	a1,500
ffffffffc0201f7a:	00005517          	auipc	a0,0x5
ffffffffc0201f7e:	0be50513          	addi	a0,a0,190 # ffffffffc0207038 <commands+0x890>
ffffffffc0201f82:	a94fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
ffffffffc0201f86:	00005697          	auipc	a3,0x5
ffffffffc0201f8a:	21a68693          	addi	a3,a3,538 # ffffffffc02071a0 <commands+0x9f8>
ffffffffc0201f8e:	00005617          	auipc	a2,0x5
ffffffffc0201f92:	c9a60613          	addi	a2,a2,-870 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201f96:	1ec00593          	li	a1,492
ffffffffc0201f9a:	00005517          	auipc	a0,0x5
ffffffffc0201f9e:	09e50513          	addi	a0,a0,158 # ffffffffc0207038 <commands+0x890>
ffffffffc0201fa2:	a74fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
ffffffffc0201fa6:	00005697          	auipc	a3,0x5
ffffffffc0201faa:	25268693          	addi	a3,a3,594 # ffffffffc02071f8 <commands+0xa50>
ffffffffc0201fae:	00005617          	auipc	a2,0x5
ffffffffc0201fb2:	c7a60613          	addi	a2,a2,-902 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201fb6:	1f300593          	li	a1,499
ffffffffc0201fba:	00005517          	auipc	a0,0x5
ffffffffc0201fbe:	07e50513          	addi	a0,a0,126 # ffffffffc0207038 <commands+0x890>
ffffffffc0201fc2:	a54fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
ffffffffc0201fc6:	00005697          	auipc	a3,0x5
ffffffffc0201fca:	20268693          	addi	a3,a3,514 # ffffffffc02071c8 <commands+0xa20>
ffffffffc0201fce:	00005617          	auipc	a2,0x5
ffffffffc0201fd2:	c5a60613          	addi	a2,a2,-934 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201fd6:	1f000593          	li	a1,496
ffffffffc0201fda:	00005517          	auipc	a0,0x5
ffffffffc0201fde:	05e50513          	addi	a0,a0,94 # ffffffffc0207038 <commands+0x890>
ffffffffc0201fe2:	a34fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201fe6:	00005697          	auipc	a3,0x5
ffffffffc0201fea:	3c268693          	addi	a3,a3,962 # ffffffffc02073a8 <commands+0xc00>
ffffffffc0201fee:	00005617          	auipc	a2,0x5
ffffffffc0201ff2:	c3a60613          	addi	a2,a2,-966 # ffffffffc0206c28 <commands+0x480>
ffffffffc0201ff6:	20c00593          	li	a1,524
ffffffffc0201ffa:	00005517          	auipc	a0,0x5
ffffffffc0201ffe:	03e50513          	addi	a0,a0,62 # ffffffffc0207038 <commands+0x890>
ffffffffc0202002:	a14fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202006:	00005697          	auipc	a3,0x5
ffffffffc020200a:	26268693          	addi	a3,a3,610 # ffffffffc0207268 <commands+0xac0>
ffffffffc020200e:	00005617          	auipc	a2,0x5
ffffffffc0202012:	c1a60613          	addi	a2,a2,-998 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202016:	20b00593          	li	a1,523
ffffffffc020201a:	00005517          	auipc	a0,0x5
ffffffffc020201e:	01e50513          	addi	a0,a0,30 # ffffffffc0207038 <commands+0x890>
ffffffffc0202022:	9f4fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202026:	00005697          	auipc	a3,0x5
ffffffffc020202a:	39a68693          	addi	a3,a3,922 # ffffffffc02073c0 <commands+0xc18>
ffffffffc020202e:	00005617          	auipc	a2,0x5
ffffffffc0202032:	bfa60613          	addi	a2,a2,-1030 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202036:	20800593          	li	a1,520
ffffffffc020203a:	00005517          	auipc	a0,0x5
ffffffffc020203e:	ffe50513          	addi	a0,a0,-2 # ffffffffc0207038 <commands+0x890>
ffffffffc0202042:	9d4fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202046:	00005697          	auipc	a3,0x5
ffffffffc020204a:	57a68693          	addi	a3,a3,1402 # ffffffffc02075c0 <commands+0xe18>
ffffffffc020204e:	00005617          	auipc	a2,0x5
ffffffffc0202052:	bda60613          	addi	a2,a2,-1062 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202056:	23a00593          	li	a1,570
ffffffffc020205a:	00005517          	auipc	a0,0x5
ffffffffc020205e:	fde50513          	addi	a0,a0,-34 # ffffffffc0207038 <commands+0x890>
ffffffffc0202062:	9b4fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_free_store==nr_free_pages());
ffffffffc0202066:	00005697          	auipc	a3,0x5
ffffffffc020206a:	3b268693          	addi	a3,a3,946 # ffffffffc0207418 <commands+0xc70>
ffffffffc020206e:	00005617          	auipc	a2,0x5
ffffffffc0202072:	bba60613          	addi	a2,a2,-1094 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202076:	21a00593          	li	a1,538
ffffffffc020207a:	00005517          	auipc	a0,0x5
ffffffffc020207e:	fbe50513          	addi	a0,a0,-66 # ffffffffc0207038 <commands+0x890>
ffffffffc0202082:	994fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(boot_pgdir[0] == 0);
ffffffffc0202086:	00005697          	auipc	a3,0x5
ffffffffc020208a:	42a68693          	addi	a3,a3,1066 # ffffffffc02074b0 <commands+0xd08>
ffffffffc020208e:	00005617          	auipc	a2,0x5
ffffffffc0202092:	b9a60613          	addi	a2,a2,-1126 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202096:	22c00593          	li	a1,556
ffffffffc020209a:	00005517          	auipc	a0,0x5
ffffffffc020209e:	f9e50513          	addi	a0,a0,-98 # ffffffffc0207038 <commands+0x890>
ffffffffc02020a2:	974fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02020a6:	00005697          	auipc	a3,0x5
ffffffffc02020aa:	0a268693          	addi	a3,a3,162 # ffffffffc0207148 <commands+0x9a0>
ffffffffc02020ae:	00005617          	auipc	a2,0x5
ffffffffc02020b2:	b7a60613          	addi	a2,a2,-1158 # ffffffffc0206c28 <commands+0x480>
ffffffffc02020b6:	1ea00593          	li	a1,490
ffffffffc02020ba:	00005517          	auipc	a0,0x5
ffffffffc02020be:	f7e50513          	addi	a0,a0,-130 # ffffffffc0207038 <commands+0x890>
ffffffffc02020c2:	954fe0ef          	jal	ra,ffffffffc0200216 <__panic>
    boot_cr3 = PADDR(boot_pgdir);
ffffffffc02020c6:	00005617          	auipc	a2,0x5
ffffffffc02020ca:	02260613          	addi	a2,a2,34 # ffffffffc02070e8 <commands+0x940>
ffffffffc02020ce:	0c100593          	li	a1,193
ffffffffc02020d2:	00005517          	auipc	a0,0x5
ffffffffc02020d6:	f6650513          	addi	a0,a0,-154 # ffffffffc0207038 <commands+0x890>
ffffffffc02020da:	93cfe0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02020de <copy_range>:
               bool share) {
ffffffffc02020de:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020e0:	00d667b3          	or	a5,a2,a3
               bool share) {
ffffffffc02020e4:	f486                	sd	ra,104(sp)
ffffffffc02020e6:	f0a2                	sd	s0,96(sp)
ffffffffc02020e8:	eca6                	sd	s1,88(sp)
ffffffffc02020ea:	e8ca                	sd	s2,80(sp)
ffffffffc02020ec:	e4ce                	sd	s3,72(sp)
ffffffffc02020ee:	e0d2                	sd	s4,64(sp)
ffffffffc02020f0:	fc56                	sd	s5,56(sp)
ffffffffc02020f2:	f85a                	sd	s6,48(sp)
ffffffffc02020f4:	f45e                	sd	s7,40(sp)
ffffffffc02020f6:	f062                	sd	s8,32(sp)
ffffffffc02020f8:	ec66                	sd	s9,24(sp)
ffffffffc02020fa:	e86a                	sd	s10,16(sp)
ffffffffc02020fc:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02020fe:	03479713          	slli	a4,a5,0x34
ffffffffc0202102:	1e071863          	bnez	a4,ffffffffc02022f2 <copy_range+0x214>
    assert(USER_ACCESS(start, end));
ffffffffc0202106:	002007b7          	lui	a5,0x200
ffffffffc020210a:	8432                	mv	s0,a2
ffffffffc020210c:	16f66b63          	bltu	a2,a5,ffffffffc0202282 <copy_range+0x1a4>
ffffffffc0202110:	84b6                	mv	s1,a3
ffffffffc0202112:	16d67863          	bleu	a3,a2,ffffffffc0202282 <copy_range+0x1a4>
ffffffffc0202116:	4785                	li	a5,1
ffffffffc0202118:	07fe                	slli	a5,a5,0x1f
ffffffffc020211a:	16d7e463          	bltu	a5,a3,ffffffffc0202282 <copy_range+0x1a4>
ffffffffc020211e:	5a7d                	li	s4,-1
ffffffffc0202120:	8aaa                	mv	s5,a0
ffffffffc0202122:	892e                	mv	s2,a1
        start += PGSIZE;
ffffffffc0202124:	6985                	lui	s3,0x1
    if (PPN(pa) >= npage) {
ffffffffc0202126:	000aac17          	auipc	s8,0xaa
ffffffffc020212a:	402c0c13          	addi	s8,s8,1026 # ffffffffc02ac528 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020212e:	000aab97          	auipc	s7,0xaa
ffffffffc0202132:	462b8b93          	addi	s7,s7,1122 # ffffffffc02ac590 <pages>
    return page - pages + nbase;
ffffffffc0202136:	00080b37          	lui	s6,0x80
    return KADDR(page2pa(page));
ffffffffc020213a:	00ca5a13          	srli	s4,s4,0xc
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc020213e:	4601                	li	a2,0
ffffffffc0202140:	85a2                	mv	a1,s0
ffffffffc0202142:	854a                	mv	a0,s2
ffffffffc0202144:	e3dfe0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0202148:	8caa                	mv	s9,a0
        if (ptep == NULL) {
ffffffffc020214a:	c17d                	beqz	a0,ffffffffc0202230 <copy_range+0x152>
        if (*ptep & PTE_V) {
ffffffffc020214c:	611c                	ld	a5,0(a0)
ffffffffc020214e:	8b85                	andi	a5,a5,1
ffffffffc0202150:	e785                	bnez	a5,ffffffffc0202178 <copy_range+0x9a>
        start += PGSIZE;
ffffffffc0202152:	944e                	add	s0,s0,s3
    } while (start != 0 && start < end);
ffffffffc0202154:	fe9465e3          	bltu	s0,s1,ffffffffc020213e <copy_range+0x60>
    return 0;
ffffffffc0202158:	4501                	li	a0,0
}
ffffffffc020215a:	70a6                	ld	ra,104(sp)
ffffffffc020215c:	7406                	ld	s0,96(sp)
ffffffffc020215e:	64e6                	ld	s1,88(sp)
ffffffffc0202160:	6946                	ld	s2,80(sp)
ffffffffc0202162:	69a6                	ld	s3,72(sp)
ffffffffc0202164:	6a06                	ld	s4,64(sp)
ffffffffc0202166:	7ae2                	ld	s5,56(sp)
ffffffffc0202168:	7b42                	ld	s6,48(sp)
ffffffffc020216a:	7ba2                	ld	s7,40(sp)
ffffffffc020216c:	7c02                	ld	s8,32(sp)
ffffffffc020216e:	6ce2                	ld	s9,24(sp)
ffffffffc0202170:	6d42                	ld	s10,16(sp)
ffffffffc0202172:	6da2                	ld	s11,8(sp)
ffffffffc0202174:	6165                	addi	sp,sp,112
ffffffffc0202176:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL) {
ffffffffc0202178:	4605                	li	a2,1
ffffffffc020217a:	85a2                	mv	a1,s0
ffffffffc020217c:	8556                	mv	a0,s5
ffffffffc020217e:	e03fe0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0202182:	c169                	beqz	a0,ffffffffc0202244 <copy_range+0x166>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0202184:	000cb783          	ld	a5,0(s9)
    if (!(pte & PTE_V)) {
ffffffffc0202188:	0017f713          	andi	a4,a5,1
ffffffffc020218c:	01f7fc93          	andi	s9,a5,31
ffffffffc0202190:	14070563          	beqz	a4,ffffffffc02022da <copy_range+0x1fc>
    if (PPN(pa) >= npage) {
ffffffffc0202194:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202198:	078a                	slli	a5,a5,0x2
ffffffffc020219a:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc020219e:	12d77263          	bleu	a3,a4,ffffffffc02022c2 <copy_range+0x1e4>
    return &pages[PPN(pa) - nbase];
ffffffffc02021a2:	000bb783          	ld	a5,0(s7)
ffffffffc02021a6:	fff806b7          	lui	a3,0xfff80
ffffffffc02021aa:	9736                	add	a4,a4,a3
ffffffffc02021ac:	071a                	slli	a4,a4,0x6
            struct Page *npage = alloc_page();
ffffffffc02021ae:	4505                	li	a0,1
ffffffffc02021b0:	00e78db3          	add	s11,a5,a4
ffffffffc02021b4:	cbffe0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02021b8:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc02021ba:	0a0d8463          	beqz	s11,ffffffffc0202262 <copy_range+0x184>
            assert(npage != NULL);
ffffffffc02021be:	c175                	beqz	a0,ffffffffc02022a2 <copy_range+0x1c4>
    return page - pages + nbase;
ffffffffc02021c0:	000bb703          	ld	a4,0(s7)
    return KADDR(page2pa(page));
ffffffffc02021c4:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc02021c8:	40ed86b3          	sub	a3,s11,a4
ffffffffc02021cc:	8699                	srai	a3,a3,0x6
ffffffffc02021ce:	96da                	add	a3,a3,s6
    return KADDR(page2pa(page));
ffffffffc02021d0:	0146f7b3          	and	a5,a3,s4
    return page2ppn(page) << PGSHIFT;
ffffffffc02021d4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02021d6:	06c7fa63          	bleu	a2,a5,ffffffffc020224a <copy_range+0x16c>
    return page - pages + nbase;
ffffffffc02021da:	40e507b3          	sub	a5,a0,a4
    return KADDR(page2pa(page));
ffffffffc02021de:	000aa717          	auipc	a4,0xaa
ffffffffc02021e2:	3a270713          	addi	a4,a4,930 # ffffffffc02ac580 <va_pa_offset>
ffffffffc02021e6:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc02021e8:	8799                	srai	a5,a5,0x6
ffffffffc02021ea:	97da                	add	a5,a5,s6
    return KADDR(page2pa(page));
ffffffffc02021ec:	0147f733          	and	a4,a5,s4
ffffffffc02021f0:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02021f4:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02021f6:	04c77963          	bleu	a2,a4,ffffffffc0202248 <copy_range+0x16a>
            memcpy(kva_dst, kva_src, PGSIZE);
ffffffffc02021fa:	6605                	lui	a2,0x1
ffffffffc02021fc:	953e                	add	a0,a0,a5
ffffffffc02021fe:	012040ef          	jal	ra,ffffffffc0206210 <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0202202:	86e6                	mv	a3,s9
ffffffffc0202204:	8622                	mv	a2,s0
ffffffffc0202206:	85ea                	mv	a1,s10
ffffffffc0202208:	8556                	mv	a0,s5
ffffffffc020220a:	b8cff0ef          	jal	ra,ffffffffc0201596 <page_insert>
            assert(ret == 0);
ffffffffc020220e:	d131                	beqz	a0,ffffffffc0202152 <copy_range+0x74>
ffffffffc0202210:	00005697          	auipc	a3,0x5
ffffffffc0202214:	df068693          	addi	a3,a3,-528 # ffffffffc0207000 <commands+0x858>
ffffffffc0202218:	00005617          	auipc	a2,0x5
ffffffffc020221c:	a1060613          	addi	a2,a2,-1520 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202220:	18c00593          	li	a1,396
ffffffffc0202224:	00005517          	auipc	a0,0x5
ffffffffc0202228:	e1450513          	addi	a0,a0,-492 # ffffffffc0207038 <commands+0x890>
ffffffffc020222c:	febfd0ef          	jal	ra,ffffffffc0200216 <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202230:	002007b7          	lui	a5,0x200
ffffffffc0202234:	943e                	add	s0,s0,a5
ffffffffc0202236:	ffe007b7          	lui	a5,0xffe00
ffffffffc020223a:	8c7d                	and	s0,s0,a5
    } while (start != 0 && start < end);
ffffffffc020223c:	dc11                	beqz	s0,ffffffffc0202158 <copy_range+0x7a>
ffffffffc020223e:	f09460e3          	bltu	s0,s1,ffffffffc020213e <copy_range+0x60>
ffffffffc0202242:	bf19                	j	ffffffffc0202158 <copy_range+0x7a>
                return -E_NO_MEM;
ffffffffc0202244:	5571                	li	a0,-4
ffffffffc0202246:	bf11                	j	ffffffffc020215a <copy_range+0x7c>
ffffffffc0202248:	86be                	mv	a3,a5
ffffffffc020224a:	00005617          	auipc	a2,0x5
ffffffffc020224e:	dc660613          	addi	a2,a2,-570 # ffffffffc0207010 <commands+0x868>
ffffffffc0202252:	06900593          	li	a1,105
ffffffffc0202256:	00005517          	auipc	a0,0x5
ffffffffc020225a:	e1250513          	addi	a0,a0,-494 # ffffffffc0207068 <commands+0x8c0>
ffffffffc020225e:	fb9fd0ef          	jal	ra,ffffffffc0200216 <__panic>
            assert(page != NULL);
ffffffffc0202262:	00005697          	auipc	a3,0x5
ffffffffc0202266:	d7e68693          	addi	a3,a3,-642 # ffffffffc0206fe0 <commands+0x838>
ffffffffc020226a:	00005617          	auipc	a2,0x5
ffffffffc020226e:	9be60613          	addi	a2,a2,-1602 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202272:	17200593          	li	a1,370
ffffffffc0202276:	00005517          	auipc	a0,0x5
ffffffffc020227a:	dc250513          	addi	a0,a0,-574 # ffffffffc0207038 <commands+0x890>
ffffffffc020227e:	f99fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0202282:	00005697          	auipc	a3,0x5
ffffffffc0202286:	3b668693          	addi	a3,a3,950 # ffffffffc0207638 <commands+0xe90>
ffffffffc020228a:	00005617          	auipc	a2,0x5
ffffffffc020228e:	99e60613          	addi	a2,a2,-1634 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202292:	15e00593          	li	a1,350
ffffffffc0202296:	00005517          	auipc	a0,0x5
ffffffffc020229a:	da250513          	addi	a0,a0,-606 # ffffffffc0207038 <commands+0x890>
ffffffffc020229e:	f79fd0ef          	jal	ra,ffffffffc0200216 <__panic>
            assert(npage != NULL);
ffffffffc02022a2:	00005697          	auipc	a3,0x5
ffffffffc02022a6:	d4e68693          	addi	a3,a3,-690 # ffffffffc0206ff0 <commands+0x848>
ffffffffc02022aa:	00005617          	auipc	a2,0x5
ffffffffc02022ae:	97e60613          	addi	a2,a2,-1666 # ffffffffc0206c28 <commands+0x480>
ffffffffc02022b2:	17300593          	li	a1,371
ffffffffc02022b6:	00005517          	auipc	a0,0x5
ffffffffc02022ba:	d8250513          	addi	a0,a0,-638 # ffffffffc0207038 <commands+0x890>
ffffffffc02022be:	f59fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02022c2:	00005617          	auipc	a2,0x5
ffffffffc02022c6:	d8660613          	addi	a2,a2,-634 # ffffffffc0207048 <commands+0x8a0>
ffffffffc02022ca:	06200593          	li	a1,98
ffffffffc02022ce:	00005517          	auipc	a0,0x5
ffffffffc02022d2:	d9a50513          	addi	a0,a0,-614 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02022d6:	f41fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02022da:	00005617          	auipc	a2,0x5
ffffffffc02022de:	f4e60613          	addi	a2,a2,-178 # ffffffffc0207228 <commands+0xa80>
ffffffffc02022e2:	07400593          	li	a1,116
ffffffffc02022e6:	00005517          	auipc	a0,0x5
ffffffffc02022ea:	d8250513          	addi	a0,a0,-638 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02022ee:	f29fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022f2:	00005697          	auipc	a3,0x5
ffffffffc02022f6:	31668693          	addi	a3,a3,790 # ffffffffc0207608 <commands+0xe60>
ffffffffc02022fa:	00005617          	auipc	a2,0x5
ffffffffc02022fe:	92e60613          	addi	a2,a2,-1746 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202302:	15d00593          	li	a1,349
ffffffffc0202306:	00005517          	auipc	a0,0x5
ffffffffc020230a:	d3250513          	addi	a0,a0,-718 # ffffffffc0207038 <commands+0x890>
ffffffffc020230e:	f09fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202312 <tlb_invalidate>:
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202312:	12058073          	sfence.vma	a1
}
ffffffffc0202316:	8082                	ret

ffffffffc0202318 <pgdir_alloc_page>:
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202318:	7179                	addi	sp,sp,-48
ffffffffc020231a:	e84a                	sd	s2,16(sp)
ffffffffc020231c:	892a                	mv	s2,a0
    struct Page *page = alloc_page();
ffffffffc020231e:	4505                	li	a0,1
struct Page *pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
ffffffffc0202320:	f022                	sd	s0,32(sp)
ffffffffc0202322:	ec26                	sd	s1,24(sp)
ffffffffc0202324:	e44e                	sd	s3,8(sp)
ffffffffc0202326:	f406                	sd	ra,40(sp)
ffffffffc0202328:	84ae                	mv	s1,a1
ffffffffc020232a:	89b2                	mv	s3,a2
    struct Page *page = alloc_page();
ffffffffc020232c:	b47fe0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0202330:	842a                	mv	s0,a0
    if (page != NULL) {
ffffffffc0202332:	cd1d                	beqz	a0,ffffffffc0202370 <pgdir_alloc_page+0x58>
        if (page_insert(pgdir, page, la, perm) != 0) {
ffffffffc0202334:	85aa                	mv	a1,a0
ffffffffc0202336:	86ce                	mv	a3,s3
ffffffffc0202338:	8626                	mv	a2,s1
ffffffffc020233a:	854a                	mv	a0,s2
ffffffffc020233c:	a5aff0ef          	jal	ra,ffffffffc0201596 <page_insert>
ffffffffc0202340:	e121                	bnez	a0,ffffffffc0202380 <pgdir_alloc_page+0x68>
        if (swap_init_ok) {
ffffffffc0202342:	000aa797          	auipc	a5,0xaa
ffffffffc0202346:	20678793          	addi	a5,a5,518 # ffffffffc02ac548 <swap_init_ok>
ffffffffc020234a:	439c                	lw	a5,0(a5)
ffffffffc020234c:	2781                	sext.w	a5,a5
ffffffffc020234e:	c38d                	beqz	a5,ffffffffc0202370 <pgdir_alloc_page+0x58>
            if (check_mm_struct != NULL) {
ffffffffc0202350:	000aa797          	auipc	a5,0xaa
ffffffffc0202354:	25878793          	addi	a5,a5,600 # ffffffffc02ac5a8 <check_mm_struct>
ffffffffc0202358:	6388                	ld	a0,0(a5)
ffffffffc020235a:	c919                	beqz	a0,ffffffffc0202370 <pgdir_alloc_page+0x58>
                swap_map_swappable(check_mm_struct, la, page, 0);
ffffffffc020235c:	4681                	li	a3,0
ffffffffc020235e:	8622                	mv	a2,s0
ffffffffc0202360:	85a6                	mv	a1,s1
ffffffffc0202362:	2f7010ef          	jal	ra,ffffffffc0203e58 <swap_map_swappable>
                assert(page_ref(page) == 1);
ffffffffc0202366:	4018                	lw	a4,0(s0)
                page->pra_vaddr = la;
ffffffffc0202368:	fc04                	sd	s1,56(s0)
                assert(page_ref(page) == 1);
ffffffffc020236a:	4785                	li	a5,1
ffffffffc020236c:	02f71063          	bne	a4,a5,ffffffffc020238c <pgdir_alloc_page+0x74>
}
ffffffffc0202370:	8522                	mv	a0,s0
ffffffffc0202372:	70a2                	ld	ra,40(sp)
ffffffffc0202374:	7402                	ld	s0,32(sp)
ffffffffc0202376:	64e2                	ld	s1,24(sp)
ffffffffc0202378:	6942                	ld	s2,16(sp)
ffffffffc020237a:	69a2                	ld	s3,8(sp)
ffffffffc020237c:	6145                	addi	sp,sp,48
ffffffffc020237e:	8082                	ret
            free_page(page);
ffffffffc0202380:	8522                	mv	a0,s0
ffffffffc0202382:	4585                	li	a1,1
ffffffffc0202384:	b77fe0ef          	jal	ra,ffffffffc0200efa <free_pages>
            return NULL;
ffffffffc0202388:	4401                	li	s0,0
ffffffffc020238a:	b7dd                	j	ffffffffc0202370 <pgdir_alloc_page+0x58>
                assert(page_ref(page) == 1);
ffffffffc020238c:	00005697          	auipc	a3,0x5
ffffffffc0202390:	cec68693          	addi	a3,a3,-788 # ffffffffc0207078 <commands+0x8d0>
ffffffffc0202394:	00005617          	auipc	a2,0x5
ffffffffc0202398:	89460613          	addi	a2,a2,-1900 # ffffffffc0206c28 <commands+0x480>
ffffffffc020239c:	1cb00593          	li	a1,459
ffffffffc02023a0:	00005517          	auipc	a0,0x5
ffffffffc02023a4:	c9850513          	addi	a0,a0,-872 # ffffffffc0207038 <commands+0x890>
ffffffffc02023a8:	e6ffd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02023ac <_fifo_init_mm>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc02023ac:	000aa797          	auipc	a5,0xaa
ffffffffc02023b0:	1ec78793          	addi	a5,a5,492 # ffffffffc02ac598 <pra_list_head>
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
ffffffffc02023b4:	f51c                	sd	a5,40(a0)
ffffffffc02023b6:	e79c                	sd	a5,8(a5)
ffffffffc02023b8:	e39c                	sd	a5,0(a5)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
ffffffffc02023ba:	4501                	li	a0,0
ffffffffc02023bc:	8082                	ret

ffffffffc02023be <_fifo_init>:

static int
_fifo_init(void)
{
    return 0;
}
ffffffffc02023be:	4501                	li	a0,0
ffffffffc02023c0:	8082                	ret

ffffffffc02023c2 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}
ffffffffc02023c2:	4501                	li	a0,0
ffffffffc02023c4:	8082                	ret

ffffffffc02023c6 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
ffffffffc02023c6:	4501                	li	a0,0
ffffffffc02023c8:	8082                	ret

ffffffffc02023ca <_fifo_check_swap>:
_fifo_check_swap(void) {
ffffffffc02023ca:	711d                	addi	sp,sp,-96
ffffffffc02023cc:	fc4e                	sd	s3,56(sp)
ffffffffc02023ce:	f852                	sd	s4,48(sp)
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02023d0:	00005517          	auipc	a0,0x5
ffffffffc02023d4:	28050513          	addi	a0,a0,640 # ffffffffc0207650 <commands+0xea8>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02023d8:	698d                	lui	s3,0x3
ffffffffc02023da:	4a31                	li	s4,12
_fifo_check_swap(void) {
ffffffffc02023dc:	e8a2                	sd	s0,80(sp)
ffffffffc02023de:	e4a6                	sd	s1,72(sp)
ffffffffc02023e0:	ec86                	sd	ra,88(sp)
ffffffffc02023e2:	e0ca                	sd	s2,64(sp)
ffffffffc02023e4:	f456                	sd	s5,40(sp)
ffffffffc02023e6:	f05a                	sd	s6,32(sp)
ffffffffc02023e8:	ec5e                	sd	s7,24(sp)
ffffffffc02023ea:	e862                	sd	s8,16(sp)
ffffffffc02023ec:	e466                	sd	s9,8(sp)
    assert(pgfault_num==4);
ffffffffc02023ee:	000aa417          	auipc	s0,0xaa
ffffffffc02023f2:	14240413          	addi	s0,s0,322 # ffffffffc02ac530 <pgfault_num>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02023f6:	cdbfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02023fa:	01498023          	sb	s4,0(s3) # 3000 <_binary_obj___user_faultread_out_size-0x6588>
    assert(pgfault_num==4);
ffffffffc02023fe:	4004                	lw	s1,0(s0)
ffffffffc0202400:	4791                	li	a5,4
ffffffffc0202402:	2481                	sext.w	s1,s1
ffffffffc0202404:	14f49963          	bne	s1,a5,ffffffffc0202556 <_fifo_check_swap+0x18c>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202408:	00005517          	auipc	a0,0x5
ffffffffc020240c:	29850513          	addi	a0,a0,664 # ffffffffc02076a0 <commands+0xef8>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202410:	6a85                	lui	s5,0x1
ffffffffc0202412:	4b29                	li	s6,10
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202414:	cbdfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc0202418:	016a8023          	sb	s6,0(s5) # 1000 <_binary_obj___user_faultread_out_size-0x8588>
    assert(pgfault_num==4);
ffffffffc020241c:	00042903          	lw	s2,0(s0)
ffffffffc0202420:	2901                	sext.w	s2,s2
ffffffffc0202422:	2a991a63          	bne	s2,s1,ffffffffc02026d6 <_fifo_check_swap+0x30c>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0202426:	00005517          	auipc	a0,0x5
ffffffffc020242a:	2a250513          	addi	a0,a0,674 # ffffffffc02076c8 <commands+0xf20>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc020242e:	6b91                	lui	s7,0x4
ffffffffc0202430:	4c35                	li	s8,13
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc0202432:	c9ffd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc0202436:	018b8023          	sb	s8,0(s7) # 4000 <_binary_obj___user_faultread_out_size-0x5588>
    assert(pgfault_num==4);
ffffffffc020243a:	4004                	lw	s1,0(s0)
ffffffffc020243c:	2481                	sext.w	s1,s1
ffffffffc020243e:	27249c63          	bne	s1,s2,ffffffffc02026b6 <_fifo_check_swap+0x2ec>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc0202442:	00005517          	auipc	a0,0x5
ffffffffc0202446:	2ae50513          	addi	a0,a0,686 # ffffffffc02076f0 <commands+0xf48>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc020244a:	6909                	lui	s2,0x2
ffffffffc020244c:	4cad                	li	s9,11
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020244e:	c83fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202452:	01990023          	sb	s9,0(s2) # 2000 <_binary_obj___user_faultread_out_size-0x7588>
    assert(pgfault_num==4);
ffffffffc0202456:	401c                	lw	a5,0(s0)
ffffffffc0202458:	2781                	sext.w	a5,a5
ffffffffc020245a:	22979e63          	bne	a5,s1,ffffffffc0202696 <_fifo_check_swap+0x2cc>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc020245e:	00005517          	auipc	a0,0x5
ffffffffc0202462:	2ba50513          	addi	a0,a0,698 # ffffffffc0207718 <commands+0xf70>
ffffffffc0202466:	c6bfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc020246a:	6795                	lui	a5,0x5
ffffffffc020246c:	4739                	li	a4,14
ffffffffc020246e:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_faultread_out_size-0x4588>
    assert(pgfault_num==5);
ffffffffc0202472:	4004                	lw	s1,0(s0)
ffffffffc0202474:	4795                	li	a5,5
ffffffffc0202476:	2481                	sext.w	s1,s1
ffffffffc0202478:	1ef49f63          	bne	s1,a5,ffffffffc0202676 <_fifo_check_swap+0x2ac>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc020247c:	00005517          	auipc	a0,0x5
ffffffffc0202480:	27450513          	addi	a0,a0,628 # ffffffffc02076f0 <commands+0xf48>
ffffffffc0202484:	c4dfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc0202488:	01990023          	sb	s9,0(s2)
    assert(pgfault_num==5);
ffffffffc020248c:	401c                	lw	a5,0(s0)
ffffffffc020248e:	2781                	sext.w	a5,a5
ffffffffc0202490:	1c979363          	bne	a5,s1,ffffffffc0202656 <_fifo_check_swap+0x28c>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc0202494:	00005517          	auipc	a0,0x5
ffffffffc0202498:	20c50513          	addi	a0,a0,524 # ffffffffc02076a0 <commands+0xef8>
ffffffffc020249c:	c35fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
ffffffffc02024a0:	016a8023          	sb	s6,0(s5)
    assert(pgfault_num==6);
ffffffffc02024a4:	401c                	lw	a5,0(s0)
ffffffffc02024a6:	4719                	li	a4,6
ffffffffc02024a8:	2781                	sext.w	a5,a5
ffffffffc02024aa:	18e79663          	bne	a5,a4,ffffffffc0202636 <_fifo_check_swap+0x26c>
    cprintf("write Virt Page b in fifo_check_swap\n");
ffffffffc02024ae:	00005517          	auipc	a0,0x5
ffffffffc02024b2:	24250513          	addi	a0,a0,578 # ffffffffc02076f0 <commands+0xf48>
ffffffffc02024b6:	c1bfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
ffffffffc02024ba:	01990023          	sb	s9,0(s2)
    assert(pgfault_num==7);
ffffffffc02024be:	401c                	lw	a5,0(s0)
ffffffffc02024c0:	471d                	li	a4,7
ffffffffc02024c2:	2781                	sext.w	a5,a5
ffffffffc02024c4:	14e79963          	bne	a5,a4,ffffffffc0202616 <_fifo_check_swap+0x24c>
    cprintf("write Virt Page c in fifo_check_swap\n");
ffffffffc02024c8:	00005517          	auipc	a0,0x5
ffffffffc02024cc:	18850513          	addi	a0,a0,392 # ffffffffc0207650 <commands+0xea8>
ffffffffc02024d0:	c01fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
ffffffffc02024d4:	01498023          	sb	s4,0(s3)
    assert(pgfault_num==8);
ffffffffc02024d8:	401c                	lw	a5,0(s0)
ffffffffc02024da:	4721                	li	a4,8
ffffffffc02024dc:	2781                	sext.w	a5,a5
ffffffffc02024de:	10e79c63          	bne	a5,a4,ffffffffc02025f6 <_fifo_check_swap+0x22c>
    cprintf("write Virt Page d in fifo_check_swap\n");
ffffffffc02024e2:	00005517          	auipc	a0,0x5
ffffffffc02024e6:	1e650513          	addi	a0,a0,486 # ffffffffc02076c8 <commands+0xf20>
ffffffffc02024ea:	be7fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
ffffffffc02024ee:	018b8023          	sb	s8,0(s7)
    assert(pgfault_num==9);
ffffffffc02024f2:	401c                	lw	a5,0(s0)
ffffffffc02024f4:	4725                	li	a4,9
ffffffffc02024f6:	2781                	sext.w	a5,a5
ffffffffc02024f8:	0ce79f63          	bne	a5,a4,ffffffffc02025d6 <_fifo_check_swap+0x20c>
    cprintf("write Virt Page e in fifo_check_swap\n");
ffffffffc02024fc:	00005517          	auipc	a0,0x5
ffffffffc0202500:	21c50513          	addi	a0,a0,540 # ffffffffc0207718 <commands+0xf70>
ffffffffc0202504:	bcdfd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
ffffffffc0202508:	6795                	lui	a5,0x5
ffffffffc020250a:	4739                	li	a4,14
ffffffffc020250c:	00e78023          	sb	a4,0(a5) # 5000 <_binary_obj___user_faultread_out_size-0x4588>
    assert(pgfault_num==10);
ffffffffc0202510:	4004                	lw	s1,0(s0)
ffffffffc0202512:	47a9                	li	a5,10
ffffffffc0202514:	2481                	sext.w	s1,s1
ffffffffc0202516:	0af49063          	bne	s1,a5,ffffffffc02025b6 <_fifo_check_swap+0x1ec>
    cprintf("write Virt Page a in fifo_check_swap\n");
ffffffffc020251a:	00005517          	auipc	a0,0x5
ffffffffc020251e:	18650513          	addi	a0,a0,390 # ffffffffc02076a0 <commands+0xef8>
ffffffffc0202522:	baffd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202526:	6785                	lui	a5,0x1
ffffffffc0202528:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_obj___user_faultread_out_size-0x8588>
ffffffffc020252c:	06979563          	bne	a5,s1,ffffffffc0202596 <_fifo_check_swap+0x1cc>
    assert(pgfault_num==11);
ffffffffc0202530:	401c                	lw	a5,0(s0)
ffffffffc0202532:	472d                	li	a4,11
ffffffffc0202534:	2781                	sext.w	a5,a5
ffffffffc0202536:	04e79063          	bne	a5,a4,ffffffffc0202576 <_fifo_check_swap+0x1ac>
}
ffffffffc020253a:	60e6                	ld	ra,88(sp)
ffffffffc020253c:	6446                	ld	s0,80(sp)
ffffffffc020253e:	64a6                	ld	s1,72(sp)
ffffffffc0202540:	6906                	ld	s2,64(sp)
ffffffffc0202542:	79e2                	ld	s3,56(sp)
ffffffffc0202544:	7a42                	ld	s4,48(sp)
ffffffffc0202546:	7aa2                	ld	s5,40(sp)
ffffffffc0202548:	7b02                	ld	s6,32(sp)
ffffffffc020254a:	6be2                	ld	s7,24(sp)
ffffffffc020254c:	6c42                	ld	s8,16(sp)
ffffffffc020254e:	6ca2                	ld	s9,8(sp)
ffffffffc0202550:	4501                	li	a0,0
ffffffffc0202552:	6125                	addi	sp,sp,96
ffffffffc0202554:	8082                	ret
    assert(pgfault_num==4);
ffffffffc0202556:	00005697          	auipc	a3,0x5
ffffffffc020255a:	12268693          	addi	a3,a3,290 # ffffffffc0207678 <commands+0xed0>
ffffffffc020255e:	00004617          	auipc	a2,0x4
ffffffffc0202562:	6ca60613          	addi	a2,a2,1738 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202566:	05100593          	li	a1,81
ffffffffc020256a:	00005517          	auipc	a0,0x5
ffffffffc020256e:	11e50513          	addi	a0,a0,286 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202572:	ca5fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==11);
ffffffffc0202576:	00005697          	auipc	a3,0x5
ffffffffc020257a:	25268693          	addi	a3,a3,594 # ffffffffc02077c8 <commands+0x1020>
ffffffffc020257e:	00004617          	auipc	a2,0x4
ffffffffc0202582:	6aa60613          	addi	a2,a2,1706 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202586:	07300593          	li	a1,115
ffffffffc020258a:	00005517          	auipc	a0,0x5
ffffffffc020258e:	0fe50513          	addi	a0,a0,254 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202592:	c85fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(*(unsigned char *)0x1000 == 0x0a);
ffffffffc0202596:	00005697          	auipc	a3,0x5
ffffffffc020259a:	20a68693          	addi	a3,a3,522 # ffffffffc02077a0 <commands+0xff8>
ffffffffc020259e:	00004617          	auipc	a2,0x4
ffffffffc02025a2:	68a60613          	addi	a2,a2,1674 # ffffffffc0206c28 <commands+0x480>
ffffffffc02025a6:	07100593          	li	a1,113
ffffffffc02025aa:	00005517          	auipc	a0,0x5
ffffffffc02025ae:	0de50513          	addi	a0,a0,222 # ffffffffc0207688 <commands+0xee0>
ffffffffc02025b2:	c65fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==10);
ffffffffc02025b6:	00005697          	auipc	a3,0x5
ffffffffc02025ba:	1da68693          	addi	a3,a3,474 # ffffffffc0207790 <commands+0xfe8>
ffffffffc02025be:	00004617          	auipc	a2,0x4
ffffffffc02025c2:	66a60613          	addi	a2,a2,1642 # ffffffffc0206c28 <commands+0x480>
ffffffffc02025c6:	06f00593          	li	a1,111
ffffffffc02025ca:	00005517          	auipc	a0,0x5
ffffffffc02025ce:	0be50513          	addi	a0,a0,190 # ffffffffc0207688 <commands+0xee0>
ffffffffc02025d2:	c45fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==9);
ffffffffc02025d6:	00005697          	auipc	a3,0x5
ffffffffc02025da:	1aa68693          	addi	a3,a3,426 # ffffffffc0207780 <commands+0xfd8>
ffffffffc02025de:	00004617          	auipc	a2,0x4
ffffffffc02025e2:	64a60613          	addi	a2,a2,1610 # ffffffffc0206c28 <commands+0x480>
ffffffffc02025e6:	06c00593          	li	a1,108
ffffffffc02025ea:	00005517          	auipc	a0,0x5
ffffffffc02025ee:	09e50513          	addi	a0,a0,158 # ffffffffc0207688 <commands+0xee0>
ffffffffc02025f2:	c25fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==8);
ffffffffc02025f6:	00005697          	auipc	a3,0x5
ffffffffc02025fa:	17a68693          	addi	a3,a3,378 # ffffffffc0207770 <commands+0xfc8>
ffffffffc02025fe:	00004617          	auipc	a2,0x4
ffffffffc0202602:	62a60613          	addi	a2,a2,1578 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202606:	06900593          	li	a1,105
ffffffffc020260a:	00005517          	auipc	a0,0x5
ffffffffc020260e:	07e50513          	addi	a0,a0,126 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202612:	c05fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==7);
ffffffffc0202616:	00005697          	auipc	a3,0x5
ffffffffc020261a:	14a68693          	addi	a3,a3,330 # ffffffffc0207760 <commands+0xfb8>
ffffffffc020261e:	00004617          	auipc	a2,0x4
ffffffffc0202622:	60a60613          	addi	a2,a2,1546 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202626:	06600593          	li	a1,102
ffffffffc020262a:	00005517          	auipc	a0,0x5
ffffffffc020262e:	05e50513          	addi	a0,a0,94 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202632:	be5fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==6);
ffffffffc0202636:	00005697          	auipc	a3,0x5
ffffffffc020263a:	11a68693          	addi	a3,a3,282 # ffffffffc0207750 <commands+0xfa8>
ffffffffc020263e:	00004617          	auipc	a2,0x4
ffffffffc0202642:	5ea60613          	addi	a2,a2,1514 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202646:	06300593          	li	a1,99
ffffffffc020264a:	00005517          	auipc	a0,0x5
ffffffffc020264e:	03e50513          	addi	a0,a0,62 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202652:	bc5fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==5);
ffffffffc0202656:	00005697          	auipc	a3,0x5
ffffffffc020265a:	0ea68693          	addi	a3,a3,234 # ffffffffc0207740 <commands+0xf98>
ffffffffc020265e:	00004617          	auipc	a2,0x4
ffffffffc0202662:	5ca60613          	addi	a2,a2,1482 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202666:	06000593          	li	a1,96
ffffffffc020266a:	00005517          	auipc	a0,0x5
ffffffffc020266e:	01e50513          	addi	a0,a0,30 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202672:	ba5fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==5);
ffffffffc0202676:	00005697          	auipc	a3,0x5
ffffffffc020267a:	0ca68693          	addi	a3,a3,202 # ffffffffc0207740 <commands+0xf98>
ffffffffc020267e:	00004617          	auipc	a2,0x4
ffffffffc0202682:	5aa60613          	addi	a2,a2,1450 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202686:	05d00593          	li	a1,93
ffffffffc020268a:	00005517          	auipc	a0,0x5
ffffffffc020268e:	ffe50513          	addi	a0,a0,-2 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202692:	b85fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==4);
ffffffffc0202696:	00005697          	auipc	a3,0x5
ffffffffc020269a:	fe268693          	addi	a3,a3,-30 # ffffffffc0207678 <commands+0xed0>
ffffffffc020269e:	00004617          	auipc	a2,0x4
ffffffffc02026a2:	58a60613          	addi	a2,a2,1418 # ffffffffc0206c28 <commands+0x480>
ffffffffc02026a6:	05a00593          	li	a1,90
ffffffffc02026aa:	00005517          	auipc	a0,0x5
ffffffffc02026ae:	fde50513          	addi	a0,a0,-34 # ffffffffc0207688 <commands+0xee0>
ffffffffc02026b2:	b65fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==4);
ffffffffc02026b6:	00005697          	auipc	a3,0x5
ffffffffc02026ba:	fc268693          	addi	a3,a3,-62 # ffffffffc0207678 <commands+0xed0>
ffffffffc02026be:	00004617          	auipc	a2,0x4
ffffffffc02026c2:	56a60613          	addi	a2,a2,1386 # ffffffffc0206c28 <commands+0x480>
ffffffffc02026c6:	05700593          	li	a1,87
ffffffffc02026ca:	00005517          	auipc	a0,0x5
ffffffffc02026ce:	fbe50513          	addi	a0,a0,-66 # ffffffffc0207688 <commands+0xee0>
ffffffffc02026d2:	b45fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgfault_num==4);
ffffffffc02026d6:	00005697          	auipc	a3,0x5
ffffffffc02026da:	fa268693          	addi	a3,a3,-94 # ffffffffc0207678 <commands+0xed0>
ffffffffc02026de:	00004617          	auipc	a2,0x4
ffffffffc02026e2:	54a60613          	addi	a2,a2,1354 # ffffffffc0206c28 <commands+0x480>
ffffffffc02026e6:	05400593          	li	a1,84
ffffffffc02026ea:	00005517          	auipc	a0,0x5
ffffffffc02026ee:	f9e50513          	addi	a0,a0,-98 # ffffffffc0207688 <commands+0xee0>
ffffffffc02026f2:	b25fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02026f6 <_fifo_swap_out_victim>:
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc02026f6:	751c                	ld	a5,40(a0)
{
ffffffffc02026f8:	1141                	addi	sp,sp,-16
ffffffffc02026fa:	e406                	sd	ra,8(sp)
         assert(head != NULL);
ffffffffc02026fc:	cf91                	beqz	a5,ffffffffc0202718 <_fifo_swap_out_victim+0x22>
     assert(in_tick==0);
ffffffffc02026fe:	ee0d                	bnez	a2,ffffffffc0202738 <_fifo_swap_out_victim+0x42>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0202700:	679c                	ld	a5,8(a5)
}
ffffffffc0202702:	60a2                	ld	ra,8(sp)
ffffffffc0202704:	4501                	li	a0,0
    __list_del(listelm->prev, listelm->next);
ffffffffc0202706:	6394                	ld	a3,0(a5)
ffffffffc0202708:	6798                	ld	a4,8(a5)
    *ptr_page = le2page(entry, pra_page_link);
ffffffffc020270a:	fd878793          	addi	a5,a5,-40
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020270e:	e698                	sd	a4,8(a3)
    next->prev = prev;
ffffffffc0202710:	e314                	sd	a3,0(a4)
ffffffffc0202712:	e19c                	sd	a5,0(a1)
}
ffffffffc0202714:	0141                	addi	sp,sp,16
ffffffffc0202716:	8082                	ret
         assert(head != NULL);
ffffffffc0202718:	00005697          	auipc	a3,0x5
ffffffffc020271c:	0e068693          	addi	a3,a3,224 # ffffffffc02077f8 <commands+0x1050>
ffffffffc0202720:	00004617          	auipc	a2,0x4
ffffffffc0202724:	50860613          	addi	a2,a2,1288 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202728:	04100593          	li	a1,65
ffffffffc020272c:	00005517          	auipc	a0,0x5
ffffffffc0202730:	f5c50513          	addi	a0,a0,-164 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202734:	ae3fd0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(in_tick==0);
ffffffffc0202738:	00005697          	auipc	a3,0x5
ffffffffc020273c:	0d068693          	addi	a3,a3,208 # ffffffffc0207808 <commands+0x1060>
ffffffffc0202740:	00004617          	auipc	a2,0x4
ffffffffc0202744:	4e860613          	addi	a2,a2,1256 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202748:	04200593          	li	a1,66
ffffffffc020274c:	00005517          	auipc	a0,0x5
ffffffffc0202750:	f3c50513          	addi	a0,a0,-196 # ffffffffc0207688 <commands+0xee0>
ffffffffc0202754:	ac3fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202758 <_fifo_map_swappable>:
    list_entry_t *entry=&(page->pra_page_link);
ffffffffc0202758:	02860713          	addi	a4,a2,40
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
ffffffffc020275c:	751c                	ld	a5,40(a0)
    assert(entry != NULL && head != NULL);
ffffffffc020275e:	cb09                	beqz	a4,ffffffffc0202770 <_fifo_map_swappable+0x18>
ffffffffc0202760:	cb81                	beqz	a5,ffffffffc0202770 <_fifo_map_swappable+0x18>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202762:	6394                	ld	a3,0(a5)
    prev->next = next->prev = elm;
ffffffffc0202764:	e398                	sd	a4,0(a5)
}
ffffffffc0202766:	4501                	li	a0,0
ffffffffc0202768:	e698                	sd	a4,8(a3)
    elm->next = next;
ffffffffc020276a:	fa1c                	sd	a5,48(a2)
    elm->prev = prev;
ffffffffc020276c:	f614                	sd	a3,40(a2)
ffffffffc020276e:	8082                	ret
{
ffffffffc0202770:	1141                	addi	sp,sp,-16
    assert(entry != NULL && head != NULL);
ffffffffc0202772:	00005697          	auipc	a3,0x5
ffffffffc0202776:	06668693          	addi	a3,a3,102 # ffffffffc02077d8 <commands+0x1030>
ffffffffc020277a:	00004617          	auipc	a2,0x4
ffffffffc020277e:	4ae60613          	addi	a2,a2,1198 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202782:	03200593          	li	a1,50
ffffffffc0202786:	00005517          	auipc	a0,0x5
ffffffffc020278a:	f0250513          	addi	a0,a0,-254 # ffffffffc0207688 <commands+0xee0>
{
ffffffffc020278e:	e406                	sd	ra,8(sp)
    assert(entry != NULL && head != NULL);
ffffffffc0202790:	a87fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202794 <check_vma_overlap.isra.0.part.1>:
}


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc0202794:	1141                	addi	sp,sp,-16
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202796:	00005697          	auipc	a3,0x5
ffffffffc020279a:	09a68693          	addi	a3,a3,154 # ffffffffc0207830 <commands+0x1088>
ffffffffc020279e:	00004617          	auipc	a2,0x4
ffffffffc02027a2:	48a60613          	addi	a2,a2,1162 # ffffffffc0206c28 <commands+0x480>
ffffffffc02027a6:	06d00593          	li	a1,109
ffffffffc02027aa:	00005517          	auipc	a0,0x5
ffffffffc02027ae:	0a650513          	addi	a0,a0,166 # ffffffffc0207850 <commands+0x10a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
ffffffffc02027b2:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02027b4:	a63fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02027b8 <mm_create>:
mm_create(void) {
ffffffffc02027b8:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02027ba:	04000513          	li	a0,64
mm_create(void) {
ffffffffc02027be:	e022                	sd	s0,0(sp)
ffffffffc02027c0:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02027c2:	527000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc02027c6:	842a                	mv	s0,a0
    if (mm != NULL) {
ffffffffc02027c8:	c515                	beqz	a0,ffffffffc02027f4 <mm_create+0x3c>
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02027ca:	000aa797          	auipc	a5,0xaa
ffffffffc02027ce:	d7e78793          	addi	a5,a5,-642 # ffffffffc02ac548 <swap_init_ok>
ffffffffc02027d2:	439c                	lw	a5,0(a5)
    elm->prev = elm->next = elm;
ffffffffc02027d4:	e408                	sd	a0,8(s0)
ffffffffc02027d6:	e008                	sd	a0,0(s0)
        mm->mmap_cache = NULL;
ffffffffc02027d8:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc02027dc:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02027e0:	02052023          	sw	zero,32(a0)
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02027e4:	2781                	sext.w	a5,a5
ffffffffc02027e6:	ef81                	bnez	a5,ffffffffc02027fe <mm_create+0x46>
        else mm->sm_priv = NULL;
ffffffffc02027e8:	02053423          	sd	zero,40(a0)
    return mm->mm_count;
}

static inline void
set_mm_count(struct mm_struct *mm, int val) {
    mm->mm_count = val;
ffffffffc02027ec:	02042823          	sw	zero,48(s0)

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
    *lock = 0;
ffffffffc02027f0:	02043c23          	sd	zero,56(s0)
}
ffffffffc02027f4:	8522                	mv	a0,s0
ffffffffc02027f6:	60a2                	ld	ra,8(sp)
ffffffffc02027f8:	6402                	ld	s0,0(sp)
ffffffffc02027fa:	0141                	addi	sp,sp,16
ffffffffc02027fc:	8082                	ret
        if (swap_init_ok) swap_init_mm(mm);
ffffffffc02027fe:	64a010ef          	jal	ra,ffffffffc0203e48 <swap_init_mm>
ffffffffc0202802:	b7ed                	j	ffffffffc02027ec <mm_create+0x34>

ffffffffc0202804 <vma_create>:
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc0202804:	1101                	addi	sp,sp,-32
ffffffffc0202806:	e04a                	sd	s2,0(sp)
ffffffffc0202808:	892a                	mv	s2,a0
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc020280a:	03000513          	li	a0,48
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
ffffffffc020280e:	e822                	sd	s0,16(sp)
ffffffffc0202810:	e426                	sd	s1,8(sp)
ffffffffc0202812:	ec06                	sd	ra,24(sp)
ffffffffc0202814:	84ae                	mv	s1,a1
ffffffffc0202816:	8432                	mv	s0,a2
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202818:	4d1000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
    if (vma != NULL) {
ffffffffc020281c:	c509                	beqz	a0,ffffffffc0202826 <vma_create+0x22>
        vma->vm_start = vm_start;
ffffffffc020281e:	01253423          	sd	s2,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202822:	e904                	sd	s1,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202824:	cd00                	sw	s0,24(a0)
}
ffffffffc0202826:	60e2                	ld	ra,24(sp)
ffffffffc0202828:	6442                	ld	s0,16(sp)
ffffffffc020282a:	64a2                	ld	s1,8(sp)
ffffffffc020282c:	6902                	ld	s2,0(sp)
ffffffffc020282e:	6105                	addi	sp,sp,32
ffffffffc0202830:	8082                	ret

ffffffffc0202832 <find_vma>:
    if (mm != NULL) {
ffffffffc0202832:	c51d                	beqz	a0,ffffffffc0202860 <find_vma+0x2e>
        vma = mm->mmap_cache;
ffffffffc0202834:	691c                	ld	a5,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202836:	c781                	beqz	a5,ffffffffc020283e <find_vma+0xc>
ffffffffc0202838:	6798                	ld	a4,8(a5)
ffffffffc020283a:	02e5f663          	bleu	a4,a1,ffffffffc0202866 <find_vma+0x34>
                list_entry_t *list = &(mm->mmap_list), *le = list;
ffffffffc020283e:	87aa                	mv	a5,a0
    return listelm->next;
ffffffffc0202840:	679c                	ld	a5,8(a5)
                while ((le = list_next(le)) != list) {
ffffffffc0202842:	00f50f63          	beq	a0,a5,ffffffffc0202860 <find_vma+0x2e>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
ffffffffc0202846:	fe87b703          	ld	a4,-24(a5)
ffffffffc020284a:	fee5ebe3          	bltu	a1,a4,ffffffffc0202840 <find_vma+0xe>
ffffffffc020284e:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202852:	fee5f7e3          	bleu	a4,a1,ffffffffc0202840 <find_vma+0xe>
                    vma = le2vma(le, list_link);
ffffffffc0202856:	1781                	addi	a5,a5,-32
        if (vma != NULL) {
ffffffffc0202858:	c781                	beqz	a5,ffffffffc0202860 <find_vma+0x2e>
            mm->mmap_cache = vma;
ffffffffc020285a:	e91c                	sd	a5,16(a0)
}
ffffffffc020285c:	853e                	mv	a0,a5
ffffffffc020285e:	8082                	ret
    struct vma_struct *vma = NULL;
ffffffffc0202860:	4781                	li	a5,0
}
ffffffffc0202862:	853e                	mv	a0,a5
ffffffffc0202864:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
ffffffffc0202866:	6b98                	ld	a4,16(a5)
ffffffffc0202868:	fce5fbe3          	bleu	a4,a1,ffffffffc020283e <find_vma+0xc>
            mm->mmap_cache = vma;
ffffffffc020286c:	e91c                	sd	a5,16(a0)
    return vma;
ffffffffc020286e:	b7fd                	j	ffffffffc020285c <find_vma+0x2a>

ffffffffc0202870 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202870:	6590                	ld	a2,8(a1)
ffffffffc0202872:	0105b803          	ld	a6,16(a1)
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
ffffffffc0202876:	1141                	addi	sp,sp,-16
ffffffffc0202878:	e406                	sd	ra,8(sp)
ffffffffc020287a:	872a                	mv	a4,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc020287c:	01066863          	bltu	a2,a6,ffffffffc020288c <insert_vma_struct+0x1c>
ffffffffc0202880:	a8b9                	j	ffffffffc02028de <insert_vma_struct+0x6e>
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
ffffffffc0202882:	fe87b683          	ld	a3,-24(a5)
ffffffffc0202886:	04d66763          	bltu	a2,a3,ffffffffc02028d4 <insert_vma_struct+0x64>
ffffffffc020288a:	873e                	mv	a4,a5
ffffffffc020288c:	671c                	ld	a5,8(a4)
        while ((le = list_next(le)) != list) {
ffffffffc020288e:	fef51ae3          	bne	a0,a5,ffffffffc0202882 <insert_vma_struct+0x12>
        }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list) {
ffffffffc0202892:	02a70463          	beq	a4,a0,ffffffffc02028ba <insert_vma_struct+0x4a>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202896:	ff073683          	ld	a3,-16(a4)
    assert(prev->vm_start < prev->vm_end);
ffffffffc020289a:	fe873883          	ld	a7,-24(a4)
ffffffffc020289e:	08d8f063          	bleu	a3,a7,ffffffffc020291e <insert_vma_struct+0xae>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02028a2:	04d66e63          	bltu	a2,a3,ffffffffc02028fe <insert_vma_struct+0x8e>
    }
    if (le_next != list) {
ffffffffc02028a6:	00f50a63          	beq	a0,a5,ffffffffc02028ba <insert_vma_struct+0x4a>
ffffffffc02028aa:	fe87b683          	ld	a3,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02028ae:	0506e863          	bltu	a3,a6,ffffffffc02028fe <insert_vma_struct+0x8e>
    assert(next->vm_start < next->vm_end);
ffffffffc02028b2:	ff07b603          	ld	a2,-16(a5)
ffffffffc02028b6:	02c6f263          	bleu	a2,a3,ffffffffc02028da <insert_vma_struct+0x6a>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count ++;
ffffffffc02028ba:	5114                	lw	a3,32(a0)
    vma->vm_mm = mm;
ffffffffc02028bc:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02028be:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02028c2:	e390                	sd	a2,0(a5)
ffffffffc02028c4:	e710                	sd	a2,8(a4)
}
ffffffffc02028c6:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02028c8:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02028ca:	f198                	sd	a4,32(a1)
    mm->map_count ++;
ffffffffc02028cc:	2685                	addiw	a3,a3,1
ffffffffc02028ce:	d114                	sw	a3,32(a0)
}
ffffffffc02028d0:	0141                	addi	sp,sp,16
ffffffffc02028d2:	8082                	ret
    if (le_prev != list) {
ffffffffc02028d4:	fca711e3          	bne	a4,a0,ffffffffc0202896 <insert_vma_struct+0x26>
ffffffffc02028d8:	bfd9                	j	ffffffffc02028ae <insert_vma_struct+0x3e>
ffffffffc02028da:	ebbff0ef          	jal	ra,ffffffffc0202794 <check_vma_overlap.isra.0.part.1>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02028de:	00005697          	auipc	a3,0x5
ffffffffc02028e2:	08268693          	addi	a3,a3,130 # ffffffffc0207960 <commands+0x11b8>
ffffffffc02028e6:	00004617          	auipc	a2,0x4
ffffffffc02028ea:	34260613          	addi	a2,a2,834 # ffffffffc0206c28 <commands+0x480>
ffffffffc02028ee:	07400593          	li	a1,116
ffffffffc02028f2:	00005517          	auipc	a0,0x5
ffffffffc02028f6:	f5e50513          	addi	a0,a0,-162 # ffffffffc0207850 <commands+0x10a8>
ffffffffc02028fa:	91dfd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02028fe:	00005697          	auipc	a3,0x5
ffffffffc0202902:	0a268693          	addi	a3,a3,162 # ffffffffc02079a0 <commands+0x11f8>
ffffffffc0202906:	00004617          	auipc	a2,0x4
ffffffffc020290a:	32260613          	addi	a2,a2,802 # ffffffffc0206c28 <commands+0x480>
ffffffffc020290e:	06c00593          	li	a1,108
ffffffffc0202912:	00005517          	auipc	a0,0x5
ffffffffc0202916:	f3e50513          	addi	a0,a0,-194 # ffffffffc0207850 <commands+0x10a8>
ffffffffc020291a:	8fdfd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020291e:	00005697          	auipc	a3,0x5
ffffffffc0202922:	06268693          	addi	a3,a3,98 # ffffffffc0207980 <commands+0x11d8>
ffffffffc0202926:	00004617          	auipc	a2,0x4
ffffffffc020292a:	30260613          	addi	a2,a2,770 # ffffffffc0206c28 <commands+0x480>
ffffffffc020292e:	06b00593          	li	a1,107
ffffffffc0202932:	00005517          	auipc	a0,0x5
ffffffffc0202936:	f1e50513          	addi	a0,a0,-226 # ffffffffc0207850 <commands+0x10a8>
ffffffffc020293a:	8ddfd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc020293e <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);
ffffffffc020293e:	591c                	lw	a5,48(a0)
mm_destroy(struct mm_struct *mm) {
ffffffffc0202940:	1141                	addi	sp,sp,-16
ffffffffc0202942:	e406                	sd	ra,8(sp)
ffffffffc0202944:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0202946:	e78d                	bnez	a5,ffffffffc0202970 <mm_destroy+0x32>
ffffffffc0202948:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc020294a:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
ffffffffc020294c:	00a40c63          	beq	s0,a0,ffffffffc0202964 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202950:	6118                	ld	a4,0(a0)
ffffffffc0202952:	651c                	ld	a5,8(a0)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
ffffffffc0202954:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0202956:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202958:	e398                	sd	a4,0(a5)
ffffffffc020295a:	44b000ef          	jal	ra,ffffffffc02035a4 <kfree>
    return listelm->next;
ffffffffc020295e:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list) {
ffffffffc0202960:	fea418e3          	bne	s0,a0,ffffffffc0202950 <mm_destroy+0x12>
    }
    kfree(mm); //kfree mm
ffffffffc0202964:	8522                	mv	a0,s0
    mm=NULL;
}
ffffffffc0202966:	6402                	ld	s0,0(sp)
ffffffffc0202968:	60a2                	ld	ra,8(sp)
ffffffffc020296a:	0141                	addi	sp,sp,16
    kfree(mm); //kfree mm
ffffffffc020296c:	4390006f          	j	ffffffffc02035a4 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0202970:	00005697          	auipc	a3,0x5
ffffffffc0202974:	05068693          	addi	a3,a3,80 # ffffffffc02079c0 <commands+0x1218>
ffffffffc0202978:	00004617          	auipc	a2,0x4
ffffffffc020297c:	2b060613          	addi	a2,a2,688 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202980:	09400593          	li	a1,148
ffffffffc0202984:	00005517          	auipc	a0,0x5
ffffffffc0202988:	ecc50513          	addi	a0,a0,-308 # ffffffffc0207850 <commands+0x10a8>
ffffffffc020298c:	88bfd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202990 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202990:	6785                	lui	a5,0x1
       struct vma_struct **vma_store) {
ffffffffc0202992:	7139                	addi	sp,sp,-64
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0202994:	17fd                	addi	a5,a5,-1
ffffffffc0202996:	787d                	lui	a6,0xfffff
       struct vma_struct **vma_store) {
ffffffffc0202998:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020299a:	00f60433          	add	s0,a2,a5
       struct vma_struct **vma_store) {
ffffffffc020299e:	f426                	sd	s1,40(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02029a0:	942e                	add	s0,s0,a1
       struct vma_struct **vma_store) {
ffffffffc02029a2:	fc06                	sd	ra,56(sp)
ffffffffc02029a4:	f04a                	sd	s2,32(sp)
ffffffffc02029a6:	ec4e                	sd	s3,24(sp)
ffffffffc02029a8:	e852                	sd	s4,16(sp)
ffffffffc02029aa:	e456                	sd	s5,8(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02029ac:	0105f4b3          	and	s1,a1,a6
    if (!USER_ACCESS(start, end)) {
ffffffffc02029b0:	002007b7          	lui	a5,0x200
ffffffffc02029b4:	01047433          	and	s0,s0,a6
ffffffffc02029b8:	06f4e363          	bltu	s1,a5,ffffffffc0202a1e <mm_map+0x8e>
ffffffffc02029bc:	0684f163          	bleu	s0,s1,ffffffffc0202a1e <mm_map+0x8e>
ffffffffc02029c0:	4785                	li	a5,1
ffffffffc02029c2:	07fe                	slli	a5,a5,0x1f
ffffffffc02029c4:	0487ed63          	bltu	a5,s0,ffffffffc0202a1e <mm_map+0x8e>
ffffffffc02029c8:	89aa                	mv	s3,a0
ffffffffc02029ca:	8a3a                	mv	s4,a4
ffffffffc02029cc:	8ab6                	mv	s5,a3
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02029ce:	c931                	beqz	a0,ffffffffc0202a22 <mm_map+0x92>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
ffffffffc02029d0:	85a6                	mv	a1,s1
ffffffffc02029d2:	e61ff0ef          	jal	ra,ffffffffc0202832 <find_vma>
ffffffffc02029d6:	c501                	beqz	a0,ffffffffc02029de <mm_map+0x4e>
ffffffffc02029d8:	651c                	ld	a5,8(a0)
ffffffffc02029da:	0487e263          	bltu	a5,s0,ffffffffc0202a1e <mm_map+0x8e>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02029de:	03000513          	li	a0,48
ffffffffc02029e2:	307000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc02029e6:	892a                	mv	s2,a0
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02029e8:	5571                	li	a0,-4
    if (vma != NULL) {
ffffffffc02029ea:	02090163          	beqz	s2,ffffffffc0202a0c <mm_map+0x7c>

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02029ee:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02029f0:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02029f4:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02029f8:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02029fc:	85ca                	mv	a1,s2
ffffffffc02029fe:	e73ff0ef          	jal	ra,ffffffffc0202870 <insert_vma_struct>
    if (vma_store != NULL) {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0202a02:	4501                	li	a0,0
    if (vma_store != NULL) {
ffffffffc0202a04:	000a0463          	beqz	s4,ffffffffc0202a0c <mm_map+0x7c>
        *vma_store = vma;
ffffffffc0202a08:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0202a0c:	70e2                	ld	ra,56(sp)
ffffffffc0202a0e:	7442                	ld	s0,48(sp)
ffffffffc0202a10:	74a2                	ld	s1,40(sp)
ffffffffc0202a12:	7902                	ld	s2,32(sp)
ffffffffc0202a14:	69e2                	ld	s3,24(sp)
ffffffffc0202a16:	6a42                	ld	s4,16(sp)
ffffffffc0202a18:	6aa2                	ld	s5,8(sp)
ffffffffc0202a1a:	6121                	addi	sp,sp,64
ffffffffc0202a1c:	8082                	ret
        return -E_INVAL;
ffffffffc0202a1e:	5575                	li	a0,-3
ffffffffc0202a20:	b7f5                	j	ffffffffc0202a0c <mm_map+0x7c>
    assert(mm != NULL);
ffffffffc0202a22:	00005697          	auipc	a3,0x5
ffffffffc0202a26:	fb668693          	addi	a3,a3,-74 # ffffffffc02079d8 <commands+0x1230>
ffffffffc0202a2a:	00004617          	auipc	a2,0x4
ffffffffc0202a2e:	1fe60613          	addi	a2,a2,510 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202a32:	0a700593          	li	a1,167
ffffffffc0202a36:	00005517          	auipc	a0,0x5
ffffffffc0202a3a:	e1a50513          	addi	a0,a0,-486 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202a3e:	fd8fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202a42 <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
ffffffffc0202a42:	7139                	addi	sp,sp,-64
ffffffffc0202a44:	fc06                	sd	ra,56(sp)
ffffffffc0202a46:	f822                	sd	s0,48(sp)
ffffffffc0202a48:	f426                	sd	s1,40(sp)
ffffffffc0202a4a:	f04a                	sd	s2,32(sp)
ffffffffc0202a4c:	ec4e                	sd	s3,24(sp)
ffffffffc0202a4e:	e852                	sd	s4,16(sp)
ffffffffc0202a50:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0202a52:	c535                	beqz	a0,ffffffffc0202abe <dup_mmap+0x7c>
ffffffffc0202a54:	892a                	mv	s2,a0
ffffffffc0202a56:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0202a58:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0202a5a:	e59d                	bnez	a1,ffffffffc0202a88 <dup_mmap+0x46>
ffffffffc0202a5c:	a08d                	j	ffffffffc0202abe <dup_mmap+0x7c>
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
        if (nvma == NULL) {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0202a5e:	85aa                	mv	a1,a0
        vma->vm_start = vm_start;
ffffffffc0202a60:	0157b423          	sd	s5,8(a5) # 200008 <_binary_obj___user_exit_out_size+0x1f5580>
        insert_vma_struct(to, nvma);
ffffffffc0202a64:	854a                	mv	a0,s2
        vma->vm_end = vm_end;
ffffffffc0202a66:	0147b823          	sd	s4,16(a5)
        vma->vm_flags = vm_flags;
ffffffffc0202a6a:	0137ac23          	sw	s3,24(a5)
        insert_vma_struct(to, nvma);
ffffffffc0202a6e:	e03ff0ef          	jal	ra,ffffffffc0202870 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
ffffffffc0202a72:	ff043683          	ld	a3,-16(s0)
ffffffffc0202a76:	fe843603          	ld	a2,-24(s0)
ffffffffc0202a7a:	6c8c                	ld	a1,24(s1)
ffffffffc0202a7c:	01893503          	ld	a0,24(s2)
ffffffffc0202a80:	4701                	li	a4,0
ffffffffc0202a82:	e5cff0ef          	jal	ra,ffffffffc02020de <copy_range>
ffffffffc0202a86:	e105                	bnez	a0,ffffffffc0202aa6 <dup_mmap+0x64>
    return listelm->prev;
ffffffffc0202a88:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list) {
ffffffffc0202a8a:	02848863          	beq	s1,s0,ffffffffc0202aba <dup_mmap+0x78>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202a8e:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0202a92:	fe843a83          	ld	s5,-24(s0)
ffffffffc0202a96:	ff043a03          	ld	s4,-16(s0)
ffffffffc0202a9a:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202a9e:	24b000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc0202aa2:	87aa                	mv	a5,a0
    if (vma != NULL) {
ffffffffc0202aa4:	fd4d                	bnez	a0,ffffffffc0202a5e <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0202aa6:	5571                	li	a0,-4
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0202aa8:	70e2                	ld	ra,56(sp)
ffffffffc0202aaa:	7442                	ld	s0,48(sp)
ffffffffc0202aac:	74a2                	ld	s1,40(sp)
ffffffffc0202aae:	7902                	ld	s2,32(sp)
ffffffffc0202ab0:	69e2                	ld	s3,24(sp)
ffffffffc0202ab2:	6a42                	ld	s4,16(sp)
ffffffffc0202ab4:	6aa2                	ld	s5,8(sp)
ffffffffc0202ab6:	6121                	addi	sp,sp,64
ffffffffc0202ab8:	8082                	ret
    return 0;
ffffffffc0202aba:	4501                	li	a0,0
ffffffffc0202abc:	b7f5                	j	ffffffffc0202aa8 <dup_mmap+0x66>
    assert(to != NULL && from != NULL);
ffffffffc0202abe:	00005697          	auipc	a3,0x5
ffffffffc0202ac2:	e6268693          	addi	a3,a3,-414 # ffffffffc0207920 <commands+0x1178>
ffffffffc0202ac6:	00004617          	auipc	a2,0x4
ffffffffc0202aca:	16260613          	addi	a2,a2,354 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202ace:	0c000593          	li	a1,192
ffffffffc0202ad2:	00005517          	auipc	a0,0x5
ffffffffc0202ad6:	d7e50513          	addi	a0,a0,-642 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202ada:	f3cfd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202ade <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
ffffffffc0202ade:	1101                	addi	sp,sp,-32
ffffffffc0202ae0:	ec06                	sd	ra,24(sp)
ffffffffc0202ae2:	e822                	sd	s0,16(sp)
ffffffffc0202ae4:	e426                	sd	s1,8(sp)
ffffffffc0202ae6:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202ae8:	c531                	beqz	a0,ffffffffc0202b34 <exit_mmap+0x56>
ffffffffc0202aea:	591c                	lw	a5,48(a0)
ffffffffc0202aec:	84aa                	mv	s1,a0
ffffffffc0202aee:	e3b9                	bnez	a5,ffffffffc0202b34 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0202af0:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0202af2:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
ffffffffc0202af6:	02850663          	beq	a0,s0,ffffffffc0202b22 <exit_mmap+0x44>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202afa:	ff043603          	ld	a2,-16(s0)
ffffffffc0202afe:	fe843583          	ld	a1,-24(s0)
ffffffffc0202b02:	854a                	mv	a0,s2
ffffffffc0202b04:	eb0fe0ef          	jal	ra,ffffffffc02011b4 <unmap_range>
ffffffffc0202b08:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0202b0a:	fe8498e3          	bne	s1,s0,ffffffffc0202afa <exit_mmap+0x1c>
ffffffffc0202b0e:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list) {
ffffffffc0202b10:	00848c63          	beq	s1,s0,ffffffffc0202b28 <exit_mmap+0x4a>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202b14:	ff043603          	ld	a2,-16(s0)
ffffffffc0202b18:	fe843583          	ld	a1,-24(s0)
ffffffffc0202b1c:	854a                	mv	a0,s2
ffffffffc0202b1e:	faefe0ef          	jal	ra,ffffffffc02012cc <exit_range>
ffffffffc0202b22:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list) {
ffffffffc0202b24:	fe8498e3          	bne	s1,s0,ffffffffc0202b14 <exit_mmap+0x36>
    }
}
ffffffffc0202b28:	60e2                	ld	ra,24(sp)
ffffffffc0202b2a:	6442                	ld	s0,16(sp)
ffffffffc0202b2c:	64a2                	ld	s1,8(sp)
ffffffffc0202b2e:	6902                	ld	s2,0(sp)
ffffffffc0202b30:	6105                	addi	sp,sp,32
ffffffffc0202b32:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202b34:	00005697          	auipc	a3,0x5
ffffffffc0202b38:	e0c68693          	addi	a3,a3,-500 # ffffffffc0207940 <commands+0x1198>
ffffffffc0202b3c:	00004617          	auipc	a2,0x4
ffffffffc0202b40:	0ec60613          	addi	a2,a2,236 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202b44:	0d600593          	li	a1,214
ffffffffc0202b48:	00005517          	auipc	a0,0x5
ffffffffc0202b4c:	d0850513          	addi	a0,a0,-760 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202b50:	ec6fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0202b54 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
ffffffffc0202b54:	7139                	addi	sp,sp,-64
ffffffffc0202b56:	f822                	sd	s0,48(sp)
ffffffffc0202b58:	f426                	sd	s1,40(sp)
ffffffffc0202b5a:	fc06                	sd	ra,56(sp)
ffffffffc0202b5c:	f04a                	sd	s2,32(sp)
ffffffffc0202b5e:	ec4e                	sd	s3,24(sp)
ffffffffc0202b60:	e852                	sd	s4,16(sp)
ffffffffc0202b62:	e456                	sd	s5,8(sp)

static void
check_vma_struct(void) {
    // size_t nr_free_pages_store = nr_free_pages();

    struct mm_struct *mm = mm_create();
ffffffffc0202b64:	c55ff0ef          	jal	ra,ffffffffc02027b8 <mm_create>
    assert(mm != NULL);
ffffffffc0202b68:	842a                	mv	s0,a0
ffffffffc0202b6a:	03200493          	li	s1,50
ffffffffc0202b6e:	e919                	bnez	a0,ffffffffc0202b84 <vmm_init+0x30>
ffffffffc0202b70:	a989                	j	ffffffffc0202fc2 <vmm_init+0x46e>
        vma->vm_start = vm_start;
ffffffffc0202b72:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202b74:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202b76:	00052c23          	sw	zero,24(a0)

    int i;
    for (i = step1; i >= 1; i --) {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202b7a:	14ed                	addi	s1,s1,-5
ffffffffc0202b7c:	8522                	mv	a0,s0
ffffffffc0202b7e:	cf3ff0ef          	jal	ra,ffffffffc0202870 <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
ffffffffc0202b82:	c88d                	beqz	s1,ffffffffc0202bb4 <vmm_init+0x60>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202b84:	03000513          	li	a0,48
ffffffffc0202b88:	161000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc0202b8c:	85aa                	mv	a1,a0
ffffffffc0202b8e:	00248793          	addi	a5,s1,2
    if (vma != NULL) {
ffffffffc0202b92:	f165                	bnez	a0,ffffffffc0202b72 <vmm_init+0x1e>
        assert(vma != NULL);
ffffffffc0202b94:	00005697          	auipc	a3,0x5
ffffffffc0202b98:	06c68693          	addi	a3,a3,108 # ffffffffc0207c00 <commands+0x1458>
ffffffffc0202b9c:	00004617          	auipc	a2,0x4
ffffffffc0202ba0:	08c60613          	addi	a2,a2,140 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202ba4:	11300593          	li	a1,275
ffffffffc0202ba8:	00005517          	auipc	a0,0x5
ffffffffc0202bac:	ca850513          	addi	a0,a0,-856 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202bb0:	e66fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    for (i = step1; i >= 1; i --) {
ffffffffc0202bb4:	03700493          	li	s1,55
    }

    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0202bb8:	1f900913          	li	s2,505
ffffffffc0202bbc:	a819                	j	ffffffffc0202bd2 <vmm_init+0x7e>
        vma->vm_start = vm_start;
ffffffffc0202bbe:	e504                	sd	s1,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202bc0:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202bc2:	00052c23          	sw	zero,24(a0)
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202bc6:	0495                	addi	s1,s1,5
ffffffffc0202bc8:	8522                	mv	a0,s0
ffffffffc0202bca:	ca7ff0ef          	jal	ra,ffffffffc0202870 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
ffffffffc0202bce:	03248a63          	beq	s1,s2,ffffffffc0202c02 <vmm_init+0xae>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202bd2:	03000513          	li	a0,48
ffffffffc0202bd6:	113000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc0202bda:	85aa                	mv	a1,a0
ffffffffc0202bdc:	00248793          	addi	a5,s1,2
    if (vma != NULL) {
ffffffffc0202be0:	fd79                	bnez	a0,ffffffffc0202bbe <vmm_init+0x6a>
        assert(vma != NULL);
ffffffffc0202be2:	00005697          	auipc	a3,0x5
ffffffffc0202be6:	01e68693          	addi	a3,a3,30 # ffffffffc0207c00 <commands+0x1458>
ffffffffc0202bea:	00004617          	auipc	a2,0x4
ffffffffc0202bee:	03e60613          	addi	a2,a2,62 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202bf2:	11900593          	li	a1,281
ffffffffc0202bf6:	00005517          	auipc	a0,0x5
ffffffffc0202bfa:	c5a50513          	addi	a0,a0,-934 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202bfe:	e18fd0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0202c02:	6418                	ld	a4,8(s0)
ffffffffc0202c04:	479d                	li	a5,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
ffffffffc0202c06:	1fb00593          	li	a1,507
        assert(le != &(mm->mmap_list));
ffffffffc0202c0a:	2ee40063          	beq	s0,a4,ffffffffc0202eea <vmm_init+0x396>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202c0e:	fe873603          	ld	a2,-24(a4)
ffffffffc0202c12:	ffe78693          	addi	a3,a5,-2
ffffffffc0202c16:	24d61a63          	bne	a2,a3,ffffffffc0202e6a <vmm_init+0x316>
ffffffffc0202c1a:	ff073683          	ld	a3,-16(a4)
ffffffffc0202c1e:	24f69663          	bne	a3,a5,ffffffffc0202e6a <vmm_init+0x316>
ffffffffc0202c22:	0795                	addi	a5,a5,5
ffffffffc0202c24:	6718                	ld	a4,8(a4)
    for (i = 1; i <= step2; i ++) {
ffffffffc0202c26:	feb792e3          	bne	a5,a1,ffffffffc0202c0a <vmm_init+0xb6>
ffffffffc0202c2a:	491d                	li	s2,7
ffffffffc0202c2c:	4495                	li	s1,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0202c2e:	1f900a93          	li	s5,505
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202c32:	85a6                	mv	a1,s1
ffffffffc0202c34:	8522                	mv	a0,s0
ffffffffc0202c36:	bfdff0ef          	jal	ra,ffffffffc0202832 <find_vma>
ffffffffc0202c3a:	8a2a                	mv	s4,a0
        assert(vma1 != NULL);
ffffffffc0202c3c:	30050763          	beqz	a0,ffffffffc0202f4a <vmm_init+0x3f6>
        struct vma_struct *vma2 = find_vma(mm, i+1);
ffffffffc0202c40:	00148593          	addi	a1,s1,1
ffffffffc0202c44:	8522                	mv	a0,s0
ffffffffc0202c46:	bedff0ef          	jal	ra,ffffffffc0202832 <find_vma>
ffffffffc0202c4a:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202c4c:	2c050f63          	beqz	a0,ffffffffc0202f2a <vmm_init+0x3d6>
        struct vma_struct *vma3 = find_vma(mm, i+2);
ffffffffc0202c50:	85ca                	mv	a1,s2
ffffffffc0202c52:	8522                	mv	a0,s0
ffffffffc0202c54:	bdfff0ef          	jal	ra,ffffffffc0202832 <find_vma>
        assert(vma3 == NULL);
ffffffffc0202c58:	2a051963          	bnez	a0,ffffffffc0202f0a <vmm_init+0x3b6>
        struct vma_struct *vma4 = find_vma(mm, i+3);
ffffffffc0202c5c:	00348593          	addi	a1,s1,3
ffffffffc0202c60:	8522                	mv	a0,s0
ffffffffc0202c62:	bd1ff0ef          	jal	ra,ffffffffc0202832 <find_vma>
        assert(vma4 == NULL);
ffffffffc0202c66:	32051263          	bnez	a0,ffffffffc0202f8a <vmm_init+0x436>
        struct vma_struct *vma5 = find_vma(mm, i+4);
ffffffffc0202c6a:	00448593          	addi	a1,s1,4
ffffffffc0202c6e:	8522                	mv	a0,s0
ffffffffc0202c70:	bc3ff0ef          	jal	ra,ffffffffc0202832 <find_vma>
        assert(vma5 == NULL);
ffffffffc0202c74:	2e051b63          	bnez	a0,ffffffffc0202f6a <vmm_init+0x416>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0202c78:	008a3783          	ld	a5,8(s4)
ffffffffc0202c7c:	20979763          	bne	a5,s1,ffffffffc0202e8a <vmm_init+0x336>
ffffffffc0202c80:	010a3783          	ld	a5,16(s4)
ffffffffc0202c84:	21279363          	bne	a5,s2,ffffffffc0202e8a <vmm_init+0x336>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0202c88:	0089b783          	ld	a5,8(s3)
ffffffffc0202c8c:	20979f63          	bne	a5,s1,ffffffffc0202eaa <vmm_init+0x356>
ffffffffc0202c90:	0109b783          	ld	a5,16(s3)
ffffffffc0202c94:	21279b63          	bne	a5,s2,ffffffffc0202eaa <vmm_init+0x356>
ffffffffc0202c98:	0495                	addi	s1,s1,5
ffffffffc0202c9a:	0915                	addi	s2,s2,5
    for (i = 5; i <= 5 * step2; i +=5) {
ffffffffc0202c9c:	f9549be3          	bne	s1,s5,ffffffffc0202c32 <vmm_init+0xde>
ffffffffc0202ca0:	4491                	li	s1,4
    }

    for (i =4; i>=0; i--) {
ffffffffc0202ca2:	597d                	li	s2,-1
        struct vma_struct *vma_below_5= find_vma(mm,i);
ffffffffc0202ca4:	85a6                	mv	a1,s1
ffffffffc0202ca6:	8522                	mv	a0,s0
ffffffffc0202ca8:	b8bff0ef          	jal	ra,ffffffffc0202832 <find_vma>
ffffffffc0202cac:	0004859b          	sext.w	a1,s1
        if (vma_below_5 != NULL ) {
ffffffffc0202cb0:	c90d                	beqz	a0,ffffffffc0202ce2 <vmm_init+0x18e>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
ffffffffc0202cb2:	6914                	ld	a3,16(a0)
ffffffffc0202cb4:	6510                	ld	a2,8(a0)
ffffffffc0202cb6:	00005517          	auipc	a0,0x5
ffffffffc0202cba:	e3250513          	addi	a0,a0,-462 # ffffffffc0207ae8 <commands+0x1340>
ffffffffc0202cbe:	c12fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0202cc2:	00005697          	auipc	a3,0x5
ffffffffc0202cc6:	e4e68693          	addi	a3,a3,-434 # ffffffffc0207b10 <commands+0x1368>
ffffffffc0202cca:	00004617          	auipc	a2,0x4
ffffffffc0202cce:	f5e60613          	addi	a2,a2,-162 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202cd2:	13b00593          	li	a1,315
ffffffffc0202cd6:	00005517          	auipc	a0,0x5
ffffffffc0202cda:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202cde:	d38fd0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0202ce2:	14fd                	addi	s1,s1,-1
    for (i =4; i>=0; i--) {
ffffffffc0202ce4:	fd2490e3          	bne	s1,s2,ffffffffc0202ca4 <vmm_init+0x150>
    }

    mm_destroy(mm);
ffffffffc0202ce8:	8522                	mv	a0,s0
ffffffffc0202cea:	c55ff0ef          	jal	ra,ffffffffc020293e <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0202cee:	00005517          	auipc	a0,0x5
ffffffffc0202cf2:	e3a50513          	addi	a0,a0,-454 # ffffffffc0207b28 <commands+0x1380>
ffffffffc0202cf6:	bdafd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0202cfa:	a46fe0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
ffffffffc0202cfe:	89aa                	mv	s3,a0

    check_mm_struct = mm_create();
ffffffffc0202d00:	ab9ff0ef          	jal	ra,ffffffffc02027b8 <mm_create>
ffffffffc0202d04:	000aa797          	auipc	a5,0xaa
ffffffffc0202d08:	8aa7b223          	sd	a0,-1884(a5) # ffffffffc02ac5a8 <check_mm_struct>
ffffffffc0202d0c:	84aa                	mv	s1,a0
    assert(check_mm_struct != NULL);
ffffffffc0202d0e:	36050663          	beqz	a0,ffffffffc020307a <vmm_init+0x526>

    struct mm_struct *mm = check_mm_struct;
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202d12:	000aa797          	auipc	a5,0xaa
ffffffffc0202d16:	80e78793          	addi	a5,a5,-2034 # ffffffffc02ac520 <boot_pgdir>
ffffffffc0202d1a:	0007b903          	ld	s2,0(a5)
    assert(pgdir[0] == 0);
ffffffffc0202d1e:	00093783          	ld	a5,0(s2)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc0202d22:	01253c23          	sd	s2,24(a0)
    assert(pgdir[0] == 0);
ffffffffc0202d26:	2c079e63          	bnez	a5,ffffffffc0203002 <vmm_init+0x4ae>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202d2a:	03000513          	li	a0,48
ffffffffc0202d2e:	7ba000ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc0202d32:	842a                	mv	s0,a0
    if (vma != NULL) {
ffffffffc0202d34:	18050b63          	beqz	a0,ffffffffc0202eca <vmm_init+0x376>
        vma->vm_end = vm_end;
ffffffffc0202d38:	002007b7          	lui	a5,0x200
ffffffffc0202d3c:	e81c                	sd	a5,16(s0)
        vma->vm_flags = vm_flags;
ffffffffc0202d3e:	4789                	li	a5,2

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
    assert(vma != NULL);

    insert_vma_struct(mm, vma);
ffffffffc0202d40:	85aa                	mv	a1,a0
        vma->vm_flags = vm_flags;
ffffffffc0202d42:	cc1c                	sw	a5,24(s0)
    insert_vma_struct(mm, vma);
ffffffffc0202d44:	8526                	mv	a0,s1
        vma->vm_start = vm_start;
ffffffffc0202d46:	00043423          	sd	zero,8(s0)
    insert_vma_struct(mm, vma);
ffffffffc0202d4a:	b27ff0ef          	jal	ra,ffffffffc0202870 <insert_vma_struct>

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);
ffffffffc0202d4e:	10000593          	li	a1,256
ffffffffc0202d52:	8526                	mv	a0,s1
ffffffffc0202d54:	adfff0ef          	jal	ra,ffffffffc0202832 <find_vma>
ffffffffc0202d58:	10000793          	li	a5,256

    int i, sum = 0;

    for (i = 0; i < 100; i ++) {
ffffffffc0202d5c:	16400713          	li	a4,356
    assert(find_vma(mm, addr) == vma);
ffffffffc0202d60:	2ca41163          	bne	s0,a0,ffffffffc0203022 <vmm_init+0x4ce>
        *(char *)(addr + i) = i;
ffffffffc0202d64:	00f78023          	sb	a5,0(a5) # 200000 <_binary_obj___user_exit_out_size+0x1f5578>
        sum += i;
ffffffffc0202d68:	0785                	addi	a5,a5,1
    for (i = 0; i < 100; i ++) {
ffffffffc0202d6a:	fee79de3          	bne	a5,a4,ffffffffc0202d64 <vmm_init+0x210>
        sum += i;
ffffffffc0202d6e:	6705                	lui	a4,0x1
    for (i = 0; i < 100; i ++) {
ffffffffc0202d70:	10000793          	li	a5,256
        sum += i;
ffffffffc0202d74:	35670713          	addi	a4,a4,854 # 1356 <_binary_obj___user_faultread_out_size-0x8232>
    }
    for (i = 0; i < 100; i ++) {
ffffffffc0202d78:	16400613          	li	a2,356
        sum -= *(char *)(addr + i);
ffffffffc0202d7c:	0007c683          	lbu	a3,0(a5)
ffffffffc0202d80:	0785                	addi	a5,a5,1
ffffffffc0202d82:	9f15                	subw	a4,a4,a3
    for (i = 0; i < 100; i ++) {
ffffffffc0202d84:	fec79ce3          	bne	a5,a2,ffffffffc0202d7c <vmm_init+0x228>
    }

    assert(sum == 0);
ffffffffc0202d88:	2c071963          	bnez	a4,ffffffffc020305a <vmm_init+0x506>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d8c:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0202d90:	000a9a97          	auipc	s5,0xa9
ffffffffc0202d94:	798a8a93          	addi	s5,s5,1944 # ffffffffc02ac528 <npage>
ffffffffc0202d98:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d9c:	078a                	slli	a5,a5,0x2
ffffffffc0202d9e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202da0:	20e7f563          	bleu	a4,a5,ffffffffc0202faa <vmm_init+0x456>
    return &pages[PPN(pa) - nbase];
ffffffffc0202da4:	00006697          	auipc	a3,0x6
ffffffffc0202da8:	f8c68693          	addi	a3,a3,-116 # ffffffffc0208d30 <nbase>
ffffffffc0202dac:	0006ba03          	ld	s4,0(a3)
ffffffffc0202db0:	414786b3          	sub	a3,a5,s4
ffffffffc0202db4:	069a                	slli	a3,a3,0x6
    return page - pages + nbase;
ffffffffc0202db6:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202db8:	57fd                	li	a5,-1
    return page - pages + nbase;
ffffffffc0202dba:	96d2                	add	a3,a3,s4
    return KADDR(page2pa(page));
ffffffffc0202dbc:	83b1                	srli	a5,a5,0xc
ffffffffc0202dbe:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202dc0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202dc2:	28e7f063          	bleu	a4,a5,ffffffffc0203042 <vmm_init+0x4ee>
ffffffffc0202dc6:	000a9797          	auipc	a5,0xa9
ffffffffc0202dca:	7ba78793          	addi	a5,a5,1978 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0202dce:	6380                	ld	s0,0(a5)

    pde_t *pd1=pgdir,*pd0=page2kva(pde2page(pgdir[0]));
    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
ffffffffc0202dd0:	4581                	li	a1,0
ffffffffc0202dd2:	854a                	mv	a0,s2
ffffffffc0202dd4:	9436                	add	s0,s0,a3
ffffffffc0202dd6:	f4cfe0ef          	jal	ra,ffffffffc0201522 <page_remove>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202dda:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage) {
ffffffffc0202ddc:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202de0:	078a                	slli	a5,a5,0x2
ffffffffc0202de2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202de4:	1ce7f363          	bleu	a4,a5,ffffffffc0202faa <vmm_init+0x456>
    return &pages[PPN(pa) - nbase];
ffffffffc0202de8:	000a9417          	auipc	s0,0xa9
ffffffffc0202dec:	7a840413          	addi	s0,s0,1960 # ffffffffc02ac590 <pages>
ffffffffc0202df0:	6008                	ld	a0,0(s0)
ffffffffc0202df2:	414787b3          	sub	a5,a5,s4
ffffffffc0202df6:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd0[0]));
ffffffffc0202df8:	953e                	add	a0,a0,a5
ffffffffc0202dfa:	4585                	li	a1,1
ffffffffc0202dfc:	8fefe0ef          	jal	ra,ffffffffc0200efa <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e00:	00093783          	ld	a5,0(s2)
    if (PPN(pa) >= npage) {
ffffffffc0202e04:	000ab703          	ld	a4,0(s5)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202e08:	078a                	slli	a5,a5,0x2
ffffffffc0202e0a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0202e0c:	18e7ff63          	bleu	a4,a5,ffffffffc0202faa <vmm_init+0x456>
    return &pages[PPN(pa) - nbase];
ffffffffc0202e10:	6008                	ld	a0,0(s0)
ffffffffc0202e12:	414787b3          	sub	a5,a5,s4
ffffffffc0202e16:	079a                	slli	a5,a5,0x6
    free_page(pde2page(pd1[0]));
ffffffffc0202e18:	4585                	li	a1,1
ffffffffc0202e1a:	953e                	add	a0,a0,a5
ffffffffc0202e1c:	8defe0ef          	jal	ra,ffffffffc0200efa <free_pages>
    pgdir[0] = 0;
ffffffffc0202e20:	00093023          	sd	zero,0(s2)
  asm volatile("sfence.vma");
ffffffffc0202e24:	12000073          	sfence.vma
    flush_tlb();

    mm->pgdir = NULL;
ffffffffc0202e28:	0004bc23          	sd	zero,24(s1)
    mm_destroy(mm);
ffffffffc0202e2c:	8526                	mv	a0,s1
ffffffffc0202e2e:	b11ff0ef          	jal	ra,ffffffffc020293e <mm_destroy>
    check_mm_struct = NULL;
ffffffffc0202e32:	000a9797          	auipc	a5,0xa9
ffffffffc0202e36:	7607bb23          	sd	zero,1910(a5) # ffffffffc02ac5a8 <check_mm_struct>

    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0202e3a:	906fe0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
ffffffffc0202e3e:	1aa99263          	bne	s3,a0,ffffffffc0202fe2 <vmm_init+0x48e>

    cprintf("check_pgfault() succeeded!\n");
ffffffffc0202e42:	00005517          	auipc	a0,0x5
ffffffffc0202e46:	d8650513          	addi	a0,a0,-634 # ffffffffc0207bc8 <commands+0x1420>
ffffffffc0202e4a:	a86fd0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc0202e4e:	7442                	ld	s0,48(sp)
ffffffffc0202e50:	70e2                	ld	ra,56(sp)
ffffffffc0202e52:	74a2                	ld	s1,40(sp)
ffffffffc0202e54:	7902                	ld	s2,32(sp)
ffffffffc0202e56:	69e2                	ld	s3,24(sp)
ffffffffc0202e58:	6a42                	ld	s4,16(sp)
ffffffffc0202e5a:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202e5c:	00005517          	auipc	a0,0x5
ffffffffc0202e60:	d8c50513          	addi	a0,a0,-628 # ffffffffc0207be8 <commands+0x1440>
}
ffffffffc0202e64:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202e66:	a6afd06f          	j	ffffffffc02000d0 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202e6a:	00005697          	auipc	a3,0x5
ffffffffc0202e6e:	b9668693          	addi	a3,a3,-1130 # ffffffffc0207a00 <commands+0x1258>
ffffffffc0202e72:	00004617          	auipc	a2,0x4
ffffffffc0202e76:	db660613          	addi	a2,a2,-586 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202e7a:	12200593          	li	a1,290
ffffffffc0202e7e:	00005517          	auipc	a0,0x5
ffffffffc0202e82:	9d250513          	addi	a0,a0,-1582 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202e86:	b90fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
ffffffffc0202e8a:	00005697          	auipc	a3,0x5
ffffffffc0202e8e:	bfe68693          	addi	a3,a3,-1026 # ffffffffc0207a88 <commands+0x12e0>
ffffffffc0202e92:	00004617          	auipc	a2,0x4
ffffffffc0202e96:	d9660613          	addi	a2,a2,-618 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202e9a:	13200593          	li	a1,306
ffffffffc0202e9e:	00005517          	auipc	a0,0x5
ffffffffc0202ea2:	9b250513          	addi	a0,a0,-1614 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202ea6:	b70fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
ffffffffc0202eaa:	00005697          	auipc	a3,0x5
ffffffffc0202eae:	c0e68693          	addi	a3,a3,-1010 # ffffffffc0207ab8 <commands+0x1310>
ffffffffc0202eb2:	00004617          	auipc	a2,0x4
ffffffffc0202eb6:	d7660613          	addi	a2,a2,-650 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202eba:	13300593          	li	a1,307
ffffffffc0202ebe:	00005517          	auipc	a0,0x5
ffffffffc0202ec2:	99250513          	addi	a0,a0,-1646 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202ec6:	b50fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(vma != NULL);
ffffffffc0202eca:	00005697          	auipc	a3,0x5
ffffffffc0202ece:	d3668693          	addi	a3,a3,-714 # ffffffffc0207c00 <commands+0x1458>
ffffffffc0202ed2:	00004617          	auipc	a2,0x4
ffffffffc0202ed6:	d5660613          	addi	a2,a2,-682 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202eda:	15200593          	li	a1,338
ffffffffc0202ede:	00005517          	auipc	a0,0x5
ffffffffc0202ee2:	97250513          	addi	a0,a0,-1678 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202ee6:	b30fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0202eea:	00005697          	auipc	a3,0x5
ffffffffc0202eee:	afe68693          	addi	a3,a3,-1282 # ffffffffc02079e8 <commands+0x1240>
ffffffffc0202ef2:	00004617          	auipc	a2,0x4
ffffffffc0202ef6:	d3660613          	addi	a2,a2,-714 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202efa:	12000593          	li	a1,288
ffffffffc0202efe:	00005517          	auipc	a0,0x5
ffffffffc0202f02:	95250513          	addi	a0,a0,-1710 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202f06:	b10fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma3 == NULL);
ffffffffc0202f0a:	00005697          	auipc	a3,0x5
ffffffffc0202f0e:	b4e68693          	addi	a3,a3,-1202 # ffffffffc0207a58 <commands+0x12b0>
ffffffffc0202f12:	00004617          	auipc	a2,0x4
ffffffffc0202f16:	d1660613          	addi	a2,a2,-746 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202f1a:	12c00593          	li	a1,300
ffffffffc0202f1e:	00005517          	auipc	a0,0x5
ffffffffc0202f22:	93250513          	addi	a0,a0,-1742 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202f26:	af0fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma2 != NULL);
ffffffffc0202f2a:	00005697          	auipc	a3,0x5
ffffffffc0202f2e:	b1e68693          	addi	a3,a3,-1250 # ffffffffc0207a48 <commands+0x12a0>
ffffffffc0202f32:	00004617          	auipc	a2,0x4
ffffffffc0202f36:	cf660613          	addi	a2,a2,-778 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202f3a:	12a00593          	li	a1,298
ffffffffc0202f3e:	00005517          	auipc	a0,0x5
ffffffffc0202f42:	91250513          	addi	a0,a0,-1774 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202f46:	ad0fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma1 != NULL);
ffffffffc0202f4a:	00005697          	auipc	a3,0x5
ffffffffc0202f4e:	aee68693          	addi	a3,a3,-1298 # ffffffffc0207a38 <commands+0x1290>
ffffffffc0202f52:	00004617          	auipc	a2,0x4
ffffffffc0202f56:	cd660613          	addi	a2,a2,-810 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202f5a:	12800593          	li	a1,296
ffffffffc0202f5e:	00005517          	auipc	a0,0x5
ffffffffc0202f62:	8f250513          	addi	a0,a0,-1806 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202f66:	ab0fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma5 == NULL);
ffffffffc0202f6a:	00005697          	auipc	a3,0x5
ffffffffc0202f6e:	b0e68693          	addi	a3,a3,-1266 # ffffffffc0207a78 <commands+0x12d0>
ffffffffc0202f72:	00004617          	auipc	a2,0x4
ffffffffc0202f76:	cb660613          	addi	a2,a2,-842 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202f7a:	13000593          	li	a1,304
ffffffffc0202f7e:	00005517          	auipc	a0,0x5
ffffffffc0202f82:	8d250513          	addi	a0,a0,-1838 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202f86:	a90fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        assert(vma4 == NULL);
ffffffffc0202f8a:	00005697          	auipc	a3,0x5
ffffffffc0202f8e:	ade68693          	addi	a3,a3,-1314 # ffffffffc0207a68 <commands+0x12c0>
ffffffffc0202f92:	00004617          	auipc	a2,0x4
ffffffffc0202f96:	c9660613          	addi	a2,a2,-874 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202f9a:	12e00593          	li	a1,302
ffffffffc0202f9e:	00005517          	auipc	a0,0x5
ffffffffc0202fa2:	8b250513          	addi	a0,a0,-1870 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202fa6:	a70fd0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0202faa:	00004617          	auipc	a2,0x4
ffffffffc0202fae:	09e60613          	addi	a2,a2,158 # ffffffffc0207048 <commands+0x8a0>
ffffffffc0202fb2:	06200593          	li	a1,98
ffffffffc0202fb6:	00004517          	auipc	a0,0x4
ffffffffc0202fba:	0b250513          	addi	a0,a0,178 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0202fbe:	a58fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(mm != NULL);
ffffffffc0202fc2:	00005697          	auipc	a3,0x5
ffffffffc0202fc6:	a1668693          	addi	a3,a3,-1514 # ffffffffc02079d8 <commands+0x1230>
ffffffffc0202fca:	00004617          	auipc	a2,0x4
ffffffffc0202fce:	c5e60613          	addi	a2,a2,-930 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202fd2:	10c00593          	li	a1,268
ffffffffc0202fd6:	00005517          	auipc	a0,0x5
ffffffffc0202fda:	87a50513          	addi	a0,a0,-1926 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202fde:	a38fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_free_pages_store == nr_free_pages());
ffffffffc0202fe2:	00005697          	auipc	a3,0x5
ffffffffc0202fe6:	bbe68693          	addi	a3,a3,-1090 # ffffffffc0207ba0 <commands+0x13f8>
ffffffffc0202fea:	00004617          	auipc	a2,0x4
ffffffffc0202fee:	c3e60613          	addi	a2,a2,-962 # ffffffffc0206c28 <commands+0x480>
ffffffffc0202ff2:	17000593          	li	a1,368
ffffffffc0202ff6:	00005517          	auipc	a0,0x5
ffffffffc0202ffa:	85a50513          	addi	a0,a0,-1958 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0202ffe:	a18fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgdir[0] == 0);
ffffffffc0203002:	00005697          	auipc	a3,0x5
ffffffffc0203006:	b5e68693          	addi	a3,a3,-1186 # ffffffffc0207b60 <commands+0x13b8>
ffffffffc020300a:	00004617          	auipc	a2,0x4
ffffffffc020300e:	c1e60613          	addi	a2,a2,-994 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203012:	14f00593          	li	a1,335
ffffffffc0203016:	00005517          	auipc	a0,0x5
ffffffffc020301a:	83a50513          	addi	a0,a0,-1990 # ffffffffc0207850 <commands+0x10a8>
ffffffffc020301e:	9f8fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(find_vma(mm, addr) == vma);
ffffffffc0203022:	00005697          	auipc	a3,0x5
ffffffffc0203026:	b4e68693          	addi	a3,a3,-1202 # ffffffffc0207b70 <commands+0x13c8>
ffffffffc020302a:	00004617          	auipc	a2,0x4
ffffffffc020302e:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203032:	15700593          	li	a1,343
ffffffffc0203036:	00005517          	auipc	a0,0x5
ffffffffc020303a:	81a50513          	addi	a0,a0,-2022 # ffffffffc0207850 <commands+0x10a8>
ffffffffc020303e:	9d8fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203042:	00004617          	auipc	a2,0x4
ffffffffc0203046:	fce60613          	addi	a2,a2,-50 # ffffffffc0207010 <commands+0x868>
ffffffffc020304a:	06900593          	li	a1,105
ffffffffc020304e:	00004517          	auipc	a0,0x4
ffffffffc0203052:	01a50513          	addi	a0,a0,26 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0203056:	9c0fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(sum == 0);
ffffffffc020305a:	00005697          	auipc	a3,0x5
ffffffffc020305e:	b3668693          	addi	a3,a3,-1226 # ffffffffc0207b90 <commands+0x13e8>
ffffffffc0203062:	00004617          	auipc	a2,0x4
ffffffffc0203066:	bc660613          	addi	a2,a2,-1082 # ffffffffc0206c28 <commands+0x480>
ffffffffc020306a:	16300593          	li	a1,355
ffffffffc020306e:	00004517          	auipc	a0,0x4
ffffffffc0203072:	7e250513          	addi	a0,a0,2018 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0203076:	9a0fd0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(check_mm_struct != NULL);
ffffffffc020307a:	00005697          	auipc	a3,0x5
ffffffffc020307e:	ace68693          	addi	a3,a3,-1330 # ffffffffc0207b48 <commands+0x13a0>
ffffffffc0203082:	00004617          	auipc	a2,0x4
ffffffffc0203086:	ba660613          	addi	a2,a2,-1114 # ffffffffc0206c28 <commands+0x480>
ffffffffc020308a:	14b00593          	li	a1,331
ffffffffc020308e:	00004517          	auipc	a0,0x4
ffffffffc0203092:	7c250513          	addi	a0,a0,1986 # ffffffffc0207850 <commands+0x10a8>
ffffffffc0203096:	980fd0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc020309a <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc020309a:	7139                	addi	sp,sp,-64
    
    int ret = -E_INVAL;
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc020309c:	85b2                	mv	a1,a2
do_pgfault(struct mm_struct *mm, uint_t error_code, uintptr_t addr) {
ffffffffc020309e:	f822                	sd	s0,48(sp)
ffffffffc02030a0:	f426                	sd	s1,40(sp)
ffffffffc02030a2:	fc06                	sd	ra,56(sp)
ffffffffc02030a4:	f04a                	sd	s2,32(sp)
ffffffffc02030a6:	ec4e                	sd	s3,24(sp)
ffffffffc02030a8:	8432                	mv	s0,a2
ffffffffc02030aa:	84aa                	mv	s1,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc02030ac:	f86ff0ef          	jal	ra,ffffffffc0202832 <find_vma>

    pgfault_num++;
ffffffffc02030b0:	000a9797          	auipc	a5,0xa9
ffffffffc02030b4:	48078793          	addi	a5,a5,1152 # ffffffffc02ac530 <pgfault_num>
ffffffffc02030b8:	439c                	lw	a5,0(a5)
ffffffffc02030ba:	2785                	addiw	a5,a5,1
ffffffffc02030bc:	000a9717          	auipc	a4,0xa9
ffffffffc02030c0:	46f72a23          	sw	a5,1140(a4) # ffffffffc02ac530 <pgfault_num>
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
ffffffffc02030c4:	c555                	beqz	a0,ffffffffc0203170 <do_pgfault+0xd6>
ffffffffc02030c6:	651c                	ld	a5,8(a0)
ffffffffc02030c8:	0af46463          	bltu	s0,a5,ffffffffc0203170 <do_pgfault+0xd6>
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_WRITE) {
ffffffffc02030cc:	4d1c                	lw	a5,24(a0)
    uint32_t perm = PTE_U;
ffffffffc02030ce:	49c1                	li	s3,16
    if (vma->vm_flags & VM_WRITE) {
ffffffffc02030d0:	8b89                	andi	a5,a5,2
ffffffffc02030d2:	e3a5                	bnez	a5,ffffffffc0203132 <do_pgfault+0x98>
        perm |= READ_WRITE;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02030d4:	767d                	lui	a2,0xfffff

    pte_t *ptep=NULL;
  
    // try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    // (notice the 3th parameter '1')
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc02030d6:	6c88                	ld	a0,24(s1)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc02030d8:	8c71                	and	s0,s0,a2
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL) {
ffffffffc02030da:	85a2                	mv	a1,s0
ffffffffc02030dc:	4605                	li	a2,1
ffffffffc02030de:	ea3fd0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc02030e2:	c945                	beqz	a0,ffffffffc0203192 <do_pgfault+0xf8>
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }
    
    if (*ptep == 0) { // if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
ffffffffc02030e4:	610c                	ld	a1,0(a0)
ffffffffc02030e6:	c5b5                	beqz	a1,ffffffffc0203152 <do_pgfault+0xb8>
        *    swap_in(mm, addr, &page) : 分配一个内存页，然后根据
        *    PTE中的swap条目的addr，找到磁盘页的地址，将磁盘页的内容读入这个内存页
        *    page_insert ： 建立一个Page的phy addr与线性addr la的映射
        *    swap_map_swappable ： 设置页面可交换
        */
        if (swap_init_ok) {
ffffffffc02030e8:	000a9797          	auipc	a5,0xa9
ffffffffc02030ec:	46078793          	addi	a5,a5,1120 # ffffffffc02ac548 <swap_init_ok>
ffffffffc02030f0:	439c                	lw	a5,0(a5)
ffffffffc02030f2:	2781                	sext.w	a5,a5
ffffffffc02030f4:	c7d9                	beqz	a5,ffffffffc0203182 <do_pgfault+0xe8>
            //map of phy addr <--->
            //logical addr
            //(3) make the page swappable.
            
            // 将addr线性地址对应的物理页数据从磁盘交换到物理内存中(令Page指针指向交换成功后的物理页)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc02030f6:	0030                	addi	a2,sp,8
ffffffffc02030f8:	85a2                	mv	a1,s0
ffffffffc02030fa:	8526                	mv	a0,s1
            struct Page *page = NULL;
ffffffffc02030fc:	e402                	sd	zero,8(sp)
            if ((ret = swap_in(mm, addr, &page)) != 0) {
ffffffffc02030fe:	67f000ef          	jal	ra,ffffffffc0203f7c <swap_in>
ffffffffc0203102:	892a                	mv	s2,a0
ffffffffc0203104:	e90d                	bnez	a0,ffffffffc0203136 <do_pgfault+0x9c>
                // swap_in返回值不为0，表示换入失败
                cprintf("do_pgfault：swap_in failed\n");
                goto failed;
            }    
            // 将交换进来的page页与mm->padir页表中对应addr的二级页表项建立映射关系(perm标识这个二级页表的各个权限位)
            page_insert(mm->pgdir, page, addr, perm);
ffffffffc0203106:	65a2                	ld	a1,8(sp)
ffffffffc0203108:	6c88                	ld	a0,24(s1)
ffffffffc020310a:	86ce                	mv	a3,s3
ffffffffc020310c:	8622                	mv	a2,s0
ffffffffc020310e:	c88fe0ef          	jal	ra,ffffffffc0201596 <page_insert>
            
            // 当前page是为可交换的，将其加入全局虚拟内存交换管理器的管理
            swap_map_swappable(mm, addr, page, 1);
ffffffffc0203112:	6622                	ld	a2,8(sp)
ffffffffc0203114:	4685                	li	a3,1
ffffffffc0203116:	85a2                	mv	a1,s0
ffffffffc0203118:	8526                	mv	a0,s1
ffffffffc020311a:	53f000ef          	jal	ra,ffffffffc0203e58 <swap_map_swappable>

            page->pra_vaddr = addr;
ffffffffc020311e:	67a2                	ld	a5,8(sp)
ffffffffc0203120:	ff80                	sd	s0,56(a5)
        }
   }
   ret = 0;
failed:
    return ret;
}
ffffffffc0203122:	70e2                	ld	ra,56(sp)
ffffffffc0203124:	7442                	ld	s0,48(sp)
ffffffffc0203126:	854a                	mv	a0,s2
ffffffffc0203128:	74a2                	ld	s1,40(sp)
ffffffffc020312a:	7902                	ld	s2,32(sp)
ffffffffc020312c:	69e2                	ld	s3,24(sp)
ffffffffc020312e:	6121                	addi	sp,sp,64
ffffffffc0203130:	8082                	ret
        perm |= READ_WRITE;
ffffffffc0203132:	49dd                	li	s3,23
ffffffffc0203134:	b745                	j	ffffffffc02030d4 <do_pgfault+0x3a>
                cprintf("do_pgfault：swap_in failed\n");
ffffffffc0203136:	00004517          	auipc	a0,0x4
ffffffffc020313a:	7a250513          	addi	a0,a0,1954 # ffffffffc02078d8 <commands+0x1130>
ffffffffc020313e:	f93fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc0203142:	70e2                	ld	ra,56(sp)
ffffffffc0203144:	7442                	ld	s0,48(sp)
ffffffffc0203146:	854a                	mv	a0,s2
ffffffffc0203148:	74a2                	ld	s1,40(sp)
ffffffffc020314a:	7902                	ld	s2,32(sp)
ffffffffc020314c:	69e2                	ld	s3,24(sp)
ffffffffc020314e:	6121                	addi	sp,sp,64
ffffffffc0203150:	8082                	ret
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc0203152:	6c88                	ld	a0,24(s1)
ffffffffc0203154:	864e                	mv	a2,s3
ffffffffc0203156:	85a2                	mv	a1,s0
ffffffffc0203158:	9c0ff0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
   ret = 0;
ffffffffc020315c:	4901                	li	s2,0
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
ffffffffc020315e:	f171                	bnez	a0,ffffffffc0203122 <do_pgfault+0x88>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0203160:	00004517          	auipc	a0,0x4
ffffffffc0203164:	75050513          	addi	a0,a0,1872 # ffffffffc02078b0 <commands+0x1108>
ffffffffc0203168:	f69fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc020316c:	5971                	li	s2,-4
            goto failed;
ffffffffc020316e:	bf55                	j	ffffffffc0203122 <do_pgfault+0x88>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0203170:	85a2                	mv	a1,s0
ffffffffc0203172:	00004517          	auipc	a0,0x4
ffffffffc0203176:	6ee50513          	addi	a0,a0,1774 # ffffffffc0207860 <commands+0x10b8>
ffffffffc020317a:	f57fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    int ret = -E_INVAL;
ffffffffc020317e:	5975                	li	s2,-3
        goto failed;
ffffffffc0203180:	b74d                	j	ffffffffc0203122 <do_pgfault+0x88>
            cprintf("no swap_init_ok but ptep is %x, failed\n", *ptep);
ffffffffc0203182:	00004517          	auipc	a0,0x4
ffffffffc0203186:	77650513          	addi	a0,a0,1910 # ffffffffc02078f8 <commands+0x1150>
ffffffffc020318a:	f47fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc020318e:	5971                	li	s2,-4
            goto failed;
ffffffffc0203190:	bf49                	j	ffffffffc0203122 <do_pgfault+0x88>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc0203192:	00004517          	auipc	a0,0x4
ffffffffc0203196:	6fe50513          	addi	a0,a0,1790 # ffffffffc0207890 <commands+0x10e8>
ffffffffc020319a:	f37fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    ret = -E_NO_MEM;
ffffffffc020319e:	5971                	li	s2,-4
        goto failed;
ffffffffc02031a0:	b749                	j	ffffffffc0203122 <do_pgfault+0x88>

ffffffffc02031a2 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
ffffffffc02031a2:	7179                	addi	sp,sp,-48
ffffffffc02031a4:	f022                	sd	s0,32(sp)
ffffffffc02031a6:	f406                	sd	ra,40(sp)
ffffffffc02031a8:	ec26                	sd	s1,24(sp)
ffffffffc02031aa:	e84a                	sd	s2,16(sp)
ffffffffc02031ac:	e44e                	sd	s3,8(sp)
ffffffffc02031ae:	e052                	sd	s4,0(sp)
ffffffffc02031b0:	842e                	mv	s0,a1
    if (mm != NULL) {
ffffffffc02031b2:	c135                	beqz	a0,ffffffffc0203216 <user_mem_check+0x74>
        if (!USER_ACCESS(addr, addr + len)) {
ffffffffc02031b4:	002007b7          	lui	a5,0x200
ffffffffc02031b8:	04f5e663          	bltu	a1,a5,ffffffffc0203204 <user_mem_check+0x62>
ffffffffc02031bc:	00c584b3          	add	s1,a1,a2
ffffffffc02031c0:	0495f263          	bleu	s1,a1,ffffffffc0203204 <user_mem_check+0x62>
ffffffffc02031c4:	4785                	li	a5,1
ffffffffc02031c6:	07fe                	slli	a5,a5,0x1f
ffffffffc02031c8:	0297ee63          	bltu	a5,s1,ffffffffc0203204 <user_mem_check+0x62>
ffffffffc02031cc:	892a                	mv	s2,a0
ffffffffc02031ce:	89b6                	mv	s3,a3
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK)) {
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc02031d0:	6a05                	lui	s4,0x1
ffffffffc02031d2:	a821                	j	ffffffffc02031ea <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc02031d4:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc02031d8:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc02031da:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc02031dc:	c685                	beqz	a3,ffffffffc0203204 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK)) {
ffffffffc02031de:	c399                	beqz	a5,ffffffffc02031e4 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
ffffffffc02031e0:	02e46263          	bltu	s0,a4,ffffffffc0203204 <user_mem_check+0x62>
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc02031e4:	6900                	ld	s0,16(a0)
        while (start < end) {
ffffffffc02031e6:	04947663          	bleu	s1,s0,ffffffffc0203232 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
ffffffffc02031ea:	85a2                	mv	a1,s0
ffffffffc02031ec:	854a                	mv	a0,s2
ffffffffc02031ee:	e44ff0ef          	jal	ra,ffffffffc0202832 <find_vma>
ffffffffc02031f2:	c909                	beqz	a0,ffffffffc0203204 <user_mem_check+0x62>
ffffffffc02031f4:	6518                	ld	a4,8(a0)
ffffffffc02031f6:	00e46763          	bltu	s0,a4,ffffffffc0203204 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
ffffffffc02031fa:	4d1c                	lw	a5,24(a0)
ffffffffc02031fc:	fc099ce3          	bnez	s3,ffffffffc02031d4 <user_mem_check+0x32>
ffffffffc0203200:	8b85                	andi	a5,a5,1
ffffffffc0203202:	f3ed                	bnez	a5,ffffffffc02031e4 <user_mem_check+0x42>
            return 0;
ffffffffc0203204:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203206:	70a2                	ld	ra,40(sp)
ffffffffc0203208:	7402                	ld	s0,32(sp)
ffffffffc020320a:	64e2                	ld	s1,24(sp)
ffffffffc020320c:	6942                	ld	s2,16(sp)
ffffffffc020320e:	69a2                	ld	s3,8(sp)
ffffffffc0203210:	6a02                	ld	s4,0(sp)
ffffffffc0203212:	6145                	addi	sp,sp,48
ffffffffc0203214:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203216:	c02007b7          	lui	a5,0xc0200
ffffffffc020321a:	4501                	li	a0,0
ffffffffc020321c:	fef5e5e3          	bltu	a1,a5,ffffffffc0203206 <user_mem_check+0x64>
ffffffffc0203220:	962e                	add	a2,a2,a1
ffffffffc0203222:	fec5f2e3          	bleu	a2,a1,ffffffffc0203206 <user_mem_check+0x64>
ffffffffc0203226:	c8000537          	lui	a0,0xc8000
ffffffffc020322a:	0505                	addi	a0,a0,1
ffffffffc020322c:	00a63533          	sltu	a0,a2,a0
ffffffffc0203230:	bfd9                	j	ffffffffc0203206 <user_mem_check+0x64>
        return 1;
ffffffffc0203232:	4505                	li	a0,1
ffffffffc0203234:	bfc9                	j	ffffffffc0203206 <user_mem_check+0x64>

ffffffffc0203236 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0203236:	c125                	beqz	a0,ffffffffc0203296 <slob_free+0x60>
		return;

	if (size)
ffffffffc0203238:	e1a5                	bnez	a1,ffffffffc0203298 <slob_free+0x62>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020323a:	100027f3          	csrr	a5,sstatus
ffffffffc020323e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203240:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203242:	e3bd                	bnez	a5,ffffffffc02032a8 <slob_free+0x72>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0203244:	0009e797          	auipc	a5,0x9e
ffffffffc0203248:	ebc78793          	addi	a5,a5,-324 # ffffffffc02a1100 <slobfree>
ffffffffc020324c:	639c                	ld	a5,0(a5)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc020324e:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0203250:	00a7fa63          	bleu	a0,a5,ffffffffc0203264 <slob_free+0x2e>
ffffffffc0203254:	00e56c63          	bltu	a0,a4,ffffffffc020326c <slob_free+0x36>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0203258:	00e7fa63          	bleu	a4,a5,ffffffffc020326c <slob_free+0x36>
    return 0;
ffffffffc020325c:	87ba                	mv	a5,a4
ffffffffc020325e:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0203260:	fea7eae3          	bltu	a5,a0,ffffffffc0203254 <slob_free+0x1e>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0203264:	fee7ece3          	bltu	a5,a4,ffffffffc020325c <slob_free+0x26>
ffffffffc0203268:	fee57ae3          	bleu	a4,a0,ffffffffc020325c <slob_free+0x26>
			break;

	if (b + b->units == cur->next) {
ffffffffc020326c:	4110                	lw	a2,0(a0)
ffffffffc020326e:	00461693          	slli	a3,a2,0x4
ffffffffc0203272:	96aa                	add	a3,a3,a0
ffffffffc0203274:	08d70b63          	beq	a4,a3,ffffffffc020330a <slob_free+0xd4>
		b->units += cur->next->units;
		b->next = cur->next->next;
	} else
		b->next = cur->next;

	if (cur + cur->units == b) {
ffffffffc0203278:	4394                	lw	a3,0(a5)
		b->next = cur->next;
ffffffffc020327a:	e518                	sd	a4,8(a0)
	if (cur + cur->units == b) {
ffffffffc020327c:	00469713          	slli	a4,a3,0x4
ffffffffc0203280:	973e                	add	a4,a4,a5
ffffffffc0203282:	08e50f63          	beq	a0,a4,ffffffffc0203320 <slob_free+0xea>
		cur->units += b->units;
		cur->next = b->next;
	} else
		cur->next = b;
ffffffffc0203286:	e788                	sd	a0,8(a5)

	slobfree = cur;
ffffffffc0203288:	0009e717          	auipc	a4,0x9e
ffffffffc020328c:	e6f73c23          	sd	a5,-392(a4) # ffffffffc02a1100 <slobfree>
    if (flag) {
ffffffffc0203290:	c199                	beqz	a1,ffffffffc0203296 <slob_free+0x60>
        intr_enable();
ffffffffc0203292:	bc4fd06f          	j	ffffffffc0200656 <intr_enable>
ffffffffc0203296:	8082                	ret
		b->units = SLOB_UNITS(size);
ffffffffc0203298:	05bd                	addi	a1,a1,15
ffffffffc020329a:	8191                	srli	a1,a1,0x4
ffffffffc020329c:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020329e:	100027f3          	csrr	a5,sstatus
ffffffffc02032a2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02032a4:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02032a6:	dfd9                	beqz	a5,ffffffffc0203244 <slob_free+0xe>
{
ffffffffc02032a8:	1101                	addi	sp,sp,-32
ffffffffc02032aa:	e42a                	sd	a0,8(sp)
ffffffffc02032ac:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02032ae:	baefd0ef          	jal	ra,ffffffffc020065c <intr_disable>
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02032b2:	0009e797          	auipc	a5,0x9e
ffffffffc02032b6:	e4e78793          	addi	a5,a5,-434 # ffffffffc02a1100 <slobfree>
ffffffffc02032ba:	639c                	ld	a5,0(a5)
        return 1;
ffffffffc02032bc:	6522                	ld	a0,8(sp)
ffffffffc02032be:	4585                	li	a1,1
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02032c0:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02032c2:	00a7fa63          	bleu	a0,a5,ffffffffc02032d6 <slob_free+0xa0>
ffffffffc02032c6:	00e56c63          	bltu	a0,a4,ffffffffc02032de <slob_free+0xa8>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02032ca:	00e7fa63          	bleu	a4,a5,ffffffffc02032de <slob_free+0xa8>
    return 0;
ffffffffc02032ce:	87ba                	mv	a5,a4
ffffffffc02032d0:	6798                	ld	a4,8(a5)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02032d2:	fea7eae3          	bltu	a5,a0,ffffffffc02032c6 <slob_free+0x90>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02032d6:	fee7ece3          	bltu	a5,a4,ffffffffc02032ce <slob_free+0x98>
ffffffffc02032da:	fee57ae3          	bleu	a4,a0,ffffffffc02032ce <slob_free+0x98>
	if (b + b->units == cur->next) {
ffffffffc02032de:	4110                	lw	a2,0(a0)
ffffffffc02032e0:	00461693          	slli	a3,a2,0x4
ffffffffc02032e4:	96aa                	add	a3,a3,a0
ffffffffc02032e6:	04d70763          	beq	a4,a3,ffffffffc0203334 <slob_free+0xfe>
		b->next = cur->next;
ffffffffc02032ea:	e518                	sd	a4,8(a0)
	if (cur + cur->units == b) {
ffffffffc02032ec:	4394                	lw	a3,0(a5)
ffffffffc02032ee:	00469713          	slli	a4,a3,0x4
ffffffffc02032f2:	973e                	add	a4,a4,a5
ffffffffc02032f4:	04e50663          	beq	a0,a4,ffffffffc0203340 <slob_free+0x10a>
		cur->next = b;
ffffffffc02032f8:	e788                	sd	a0,8(a5)
	slobfree = cur;
ffffffffc02032fa:	0009e717          	auipc	a4,0x9e
ffffffffc02032fe:	e0f73323          	sd	a5,-506(a4) # ffffffffc02a1100 <slobfree>
    if (flag) {
ffffffffc0203302:	e58d                	bnez	a1,ffffffffc020332c <slob_free+0xf6>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0203304:	60e2                	ld	ra,24(sp)
ffffffffc0203306:	6105                	addi	sp,sp,32
ffffffffc0203308:	8082                	ret
		b->units += cur->next->units;
ffffffffc020330a:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc020330c:	6718                	ld	a4,8(a4)
		b->units += cur->next->units;
ffffffffc020330e:	9e35                	addw	a2,a2,a3
ffffffffc0203310:	c110                	sw	a2,0(a0)
	if (cur + cur->units == b) {
ffffffffc0203312:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0203314:	e518                	sd	a4,8(a0)
	if (cur + cur->units == b) {
ffffffffc0203316:	00469713          	slli	a4,a3,0x4
ffffffffc020331a:	973e                	add	a4,a4,a5
ffffffffc020331c:	f6e515e3          	bne	a0,a4,ffffffffc0203286 <slob_free+0x50>
		cur->units += b->units;
ffffffffc0203320:	4118                	lw	a4,0(a0)
		cur->next = b->next;
ffffffffc0203322:	6510                	ld	a2,8(a0)
		cur->units += b->units;
ffffffffc0203324:	9eb9                	addw	a3,a3,a4
ffffffffc0203326:	c394                	sw	a3,0(a5)
		cur->next = b->next;
ffffffffc0203328:	e790                	sd	a2,8(a5)
ffffffffc020332a:	bfb9                	j	ffffffffc0203288 <slob_free+0x52>
}
ffffffffc020332c:	60e2                	ld	ra,24(sp)
ffffffffc020332e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0203330:	b26fd06f          	j	ffffffffc0200656 <intr_enable>
		b->units += cur->next->units;
ffffffffc0203334:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0203336:	6718                	ld	a4,8(a4)
		b->units += cur->next->units;
ffffffffc0203338:	9e35                	addw	a2,a2,a3
ffffffffc020333a:	c110                	sw	a2,0(a0)
		b->next = cur->next->next;
ffffffffc020333c:	e518                	sd	a4,8(a0)
ffffffffc020333e:	b77d                	j	ffffffffc02032ec <slob_free+0xb6>
		cur->units += b->units;
ffffffffc0203340:	4118                	lw	a4,0(a0)
		cur->next = b->next;
ffffffffc0203342:	6510                	ld	a2,8(a0)
		cur->units += b->units;
ffffffffc0203344:	9eb9                	addw	a3,a3,a4
ffffffffc0203346:	c394                	sw	a3,0(a5)
		cur->next = b->next;
ffffffffc0203348:	e790                	sd	a2,8(a5)
ffffffffc020334a:	bf45                	j	ffffffffc02032fa <slob_free+0xc4>

ffffffffc020334c <__slob_get_free_pages.isra.0>:
  struct Page * page = alloc_pages(1 << order);
ffffffffc020334c:	4785                	li	a5,1
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020334e:	1141                	addi	sp,sp,-16
  struct Page * page = alloc_pages(1 << order);
ffffffffc0203350:	00a7953b          	sllw	a0,a5,a0
static void* __slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0203354:	e406                	sd	ra,8(sp)
  struct Page * page = alloc_pages(1 << order);
ffffffffc0203356:	b1dfd0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
  if(!page)
ffffffffc020335a:	c139                	beqz	a0,ffffffffc02033a0 <__slob_get_free_pages.isra.0+0x54>
    return page - pages + nbase;
ffffffffc020335c:	000a9797          	auipc	a5,0xa9
ffffffffc0203360:	23478793          	addi	a5,a5,564 # ffffffffc02ac590 <pages>
ffffffffc0203364:	6394                	ld	a3,0(a5)
ffffffffc0203366:	00006797          	auipc	a5,0x6
ffffffffc020336a:	9ca78793          	addi	a5,a5,-1590 # ffffffffc0208d30 <nbase>
    return KADDR(page2pa(page));
ffffffffc020336e:	000a9717          	auipc	a4,0xa9
ffffffffc0203372:	1ba70713          	addi	a4,a4,442 # ffffffffc02ac528 <npage>
    return page - pages + nbase;
ffffffffc0203376:	40d506b3          	sub	a3,a0,a3
ffffffffc020337a:	6388                	ld	a0,0(a5)
ffffffffc020337c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020337e:	57fd                	li	a5,-1
ffffffffc0203380:	6318                	ld	a4,0(a4)
    return page - pages + nbase;
ffffffffc0203382:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc0203384:	83b1                	srli	a5,a5,0xc
ffffffffc0203386:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203388:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020338a:	00e7ff63          	bleu	a4,a5,ffffffffc02033a8 <__slob_get_free_pages.isra.0+0x5c>
ffffffffc020338e:	000a9797          	auipc	a5,0xa9
ffffffffc0203392:	1f278793          	addi	a5,a5,498 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0203396:	6388                	ld	a0,0(a5)
}
ffffffffc0203398:	60a2                	ld	ra,8(sp)
ffffffffc020339a:	9536                	add	a0,a0,a3
ffffffffc020339c:	0141                	addi	sp,sp,16
ffffffffc020339e:	8082                	ret
ffffffffc02033a0:	60a2                	ld	ra,8(sp)
    return NULL;
ffffffffc02033a2:	4501                	li	a0,0
}
ffffffffc02033a4:	0141                	addi	sp,sp,16
ffffffffc02033a6:	8082                	ret
ffffffffc02033a8:	00004617          	auipc	a2,0x4
ffffffffc02033ac:	c6860613          	addi	a2,a2,-920 # ffffffffc0207010 <commands+0x868>
ffffffffc02033b0:	06900593          	li	a1,105
ffffffffc02033b4:	00004517          	auipc	a0,0x4
ffffffffc02033b8:	cb450513          	addi	a0,a0,-844 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02033bc:	e5bfc0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02033c0 <slob_alloc.isra.1.constprop.3>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02033c0:	7179                	addi	sp,sp,-48
ffffffffc02033c2:	f406                	sd	ra,40(sp)
ffffffffc02033c4:	f022                	sd	s0,32(sp)
ffffffffc02033c6:	ec26                	sd	s1,24(sp)
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02033c8:	01050713          	addi	a4,a0,16
ffffffffc02033cc:	6785                	lui	a5,0x1
ffffffffc02033ce:	0cf77b63          	bleu	a5,a4,ffffffffc02034a4 <slob_alloc.isra.1.constprop.3+0xe4>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02033d2:	00f50413          	addi	s0,a0,15
ffffffffc02033d6:	8011                	srli	s0,s0,0x4
ffffffffc02033d8:	2401                	sext.w	s0,s0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02033da:	10002673          	csrr	a2,sstatus
ffffffffc02033de:	8a09                	andi	a2,a2,2
ffffffffc02033e0:	ea5d                	bnez	a2,ffffffffc0203496 <slob_alloc.isra.1.constprop.3+0xd6>
	prev = slobfree;
ffffffffc02033e2:	0009e497          	auipc	s1,0x9e
ffffffffc02033e6:	d1e48493          	addi	s1,s1,-738 # ffffffffc02a1100 <slobfree>
ffffffffc02033ea:	6094                	ld	a3,0(s1)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02033ec:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02033ee:	4398                	lw	a4,0(a5)
ffffffffc02033f0:	0a875763          	ble	s0,a4,ffffffffc020349e <slob_alloc.isra.1.constprop.3+0xde>
		if (cur == slobfree) {
ffffffffc02033f4:	00f68a63          	beq	a3,a5,ffffffffc0203408 <slob_alloc.isra.1.constprop.3+0x48>
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc02033f8:	6788                	ld	a0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc02033fa:	4118                	lw	a4,0(a0)
ffffffffc02033fc:	02875763          	ble	s0,a4,ffffffffc020342a <slob_alloc.isra.1.constprop.3+0x6a>
ffffffffc0203400:	6094                	ld	a3,0(s1)
ffffffffc0203402:	87aa                	mv	a5,a0
		if (cur == slobfree) {
ffffffffc0203404:	fef69ae3          	bne	a3,a5,ffffffffc02033f8 <slob_alloc.isra.1.constprop.3+0x38>
    if (flag) {
ffffffffc0203408:	ea39                	bnez	a2,ffffffffc020345e <slob_alloc.isra.1.constprop.3+0x9e>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc020340a:	4501                	li	a0,0
ffffffffc020340c:	f41ff0ef          	jal	ra,ffffffffc020334c <__slob_get_free_pages.isra.0>
			if (!cur)
ffffffffc0203410:	cd29                	beqz	a0,ffffffffc020346a <slob_alloc.isra.1.constprop.3+0xaa>
			slob_free(cur, PAGE_SIZE);
ffffffffc0203412:	6585                	lui	a1,0x1
ffffffffc0203414:	e23ff0ef          	jal	ra,ffffffffc0203236 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203418:	10002673          	csrr	a2,sstatus
ffffffffc020341c:	8a09                	andi	a2,a2,2
ffffffffc020341e:	ea1d                	bnez	a2,ffffffffc0203454 <slob_alloc.isra.1.constprop.3+0x94>
			cur = slobfree;
ffffffffc0203420:	609c                	ld	a5,0(s1)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
ffffffffc0203422:	6788                	ld	a0,8(a5)
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc0203424:	4118                	lw	a4,0(a0)
ffffffffc0203426:	fc874de3          	blt	a4,s0,ffffffffc0203400 <slob_alloc.isra.1.constprop.3+0x40>
			if (cur->units == units) /* exact fit? */
ffffffffc020342a:	04e40663          	beq	s0,a4,ffffffffc0203476 <slob_alloc.isra.1.constprop.3+0xb6>
				prev->next = cur + units;
ffffffffc020342e:	00441693          	slli	a3,s0,0x4
ffffffffc0203432:	96aa                	add	a3,a3,a0
ffffffffc0203434:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0203436:	650c                	ld	a1,8(a0)
				prev->next->units = cur->units - units;
ffffffffc0203438:	9f01                	subw	a4,a4,s0
ffffffffc020343a:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc020343c:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc020343e:	c100                	sw	s0,0(a0)
			slobfree = prev;
ffffffffc0203440:	0009e717          	auipc	a4,0x9e
ffffffffc0203444:	ccf73023          	sd	a5,-832(a4) # ffffffffc02a1100 <slobfree>
    if (flag) {
ffffffffc0203448:	ee15                	bnez	a2,ffffffffc0203484 <slob_alloc.isra.1.constprop.3+0xc4>
}
ffffffffc020344a:	70a2                	ld	ra,40(sp)
ffffffffc020344c:	7402                	ld	s0,32(sp)
ffffffffc020344e:	64e2                	ld	s1,24(sp)
ffffffffc0203450:	6145                	addi	sp,sp,48
ffffffffc0203452:	8082                	ret
        intr_disable();
ffffffffc0203454:	a08fd0ef          	jal	ra,ffffffffc020065c <intr_disable>
ffffffffc0203458:	4605                	li	a2,1
			cur = slobfree;
ffffffffc020345a:	609c                	ld	a5,0(s1)
ffffffffc020345c:	b7d9                	j	ffffffffc0203422 <slob_alloc.isra.1.constprop.3+0x62>
        intr_enable();
ffffffffc020345e:	9f8fd0ef          	jal	ra,ffffffffc0200656 <intr_enable>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0203462:	4501                	li	a0,0
ffffffffc0203464:	ee9ff0ef          	jal	ra,ffffffffc020334c <__slob_get_free_pages.isra.0>
			if (!cur)
ffffffffc0203468:	f54d                	bnez	a0,ffffffffc0203412 <slob_alloc.isra.1.constprop.3+0x52>
}
ffffffffc020346a:	70a2                	ld	ra,40(sp)
ffffffffc020346c:	7402                	ld	s0,32(sp)
ffffffffc020346e:	64e2                	ld	s1,24(sp)
				return 0;
ffffffffc0203470:	4501                	li	a0,0
}
ffffffffc0203472:	6145                	addi	sp,sp,48
ffffffffc0203474:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0203476:	6518                	ld	a4,8(a0)
ffffffffc0203478:	e798                	sd	a4,8(a5)
			slobfree = prev;
ffffffffc020347a:	0009e717          	auipc	a4,0x9e
ffffffffc020347e:	c8f73323          	sd	a5,-890(a4) # ffffffffc02a1100 <slobfree>
    if (flag) {
ffffffffc0203482:	d661                	beqz	a2,ffffffffc020344a <slob_alloc.isra.1.constprop.3+0x8a>
ffffffffc0203484:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0203486:	9d0fd0ef          	jal	ra,ffffffffc0200656 <intr_enable>
}
ffffffffc020348a:	70a2                	ld	ra,40(sp)
ffffffffc020348c:	7402                	ld	s0,32(sp)
ffffffffc020348e:	6522                	ld	a0,8(sp)
ffffffffc0203490:	64e2                	ld	s1,24(sp)
ffffffffc0203492:	6145                	addi	sp,sp,48
ffffffffc0203494:	8082                	ret
        intr_disable();
ffffffffc0203496:	9c6fd0ef          	jal	ra,ffffffffc020065c <intr_disable>
ffffffffc020349a:	4605                	li	a2,1
ffffffffc020349c:	b799                	j	ffffffffc02033e2 <slob_alloc.isra.1.constprop.3+0x22>
		if (cur->units >= units + delta) { /* room enough? */
ffffffffc020349e:	853e                	mv	a0,a5
ffffffffc02034a0:	87b6                	mv	a5,a3
ffffffffc02034a2:	b761                	j	ffffffffc020342a <slob_alloc.isra.1.constprop.3+0x6a>
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
ffffffffc02034a4:	00004697          	auipc	a3,0x4
ffffffffc02034a8:	78c68693          	addi	a3,a3,1932 # ffffffffc0207c30 <commands+0x1488>
ffffffffc02034ac:	00003617          	auipc	a2,0x3
ffffffffc02034b0:	77c60613          	addi	a2,a2,1916 # ffffffffc0206c28 <commands+0x480>
ffffffffc02034b4:	06400593          	li	a1,100
ffffffffc02034b8:	00004517          	auipc	a0,0x4
ffffffffc02034bc:	79850513          	addi	a0,a0,1944 # ffffffffc0207c50 <commands+0x14a8>
ffffffffc02034c0:	d57fc0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02034c4 <kmalloc_init>:
slob_init(void) {
  cprintf("use SLOB allocator\n");
}

inline void 
kmalloc_init(void) {
ffffffffc02034c4:	1141                	addi	sp,sp,-16
  cprintf("use SLOB allocator\n");
ffffffffc02034c6:	00004517          	auipc	a0,0x4
ffffffffc02034ca:	7a250513          	addi	a0,a0,1954 # ffffffffc0207c68 <commands+0x14c0>
kmalloc_init(void) {
ffffffffc02034ce:	e406                	sd	ra,8(sp)
  cprintf("use SLOB allocator\n");
ffffffffc02034d0:	c01fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    slob_init();
    cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc02034d4:	60a2                	ld	ra,8(sp)
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc02034d6:	00004517          	auipc	a0,0x4
ffffffffc02034da:	73a50513          	addi	a0,a0,1850 # ffffffffc0207c10 <commands+0x1468>
}
ffffffffc02034de:	0141                	addi	sp,sp,16
    cprintf("kmalloc_init() succeeded!\n");
ffffffffc02034e0:	bf1fc06f          	j	ffffffffc02000d0 <cprintf>

ffffffffc02034e4 <kallocated>:
}

size_t
kallocated(void) {
   return slob_allocated();
}
ffffffffc02034e4:	4501                	li	a0,0
ffffffffc02034e6:	8082                	ret

ffffffffc02034e8 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc02034e8:	1101                	addi	sp,sp,-32
ffffffffc02034ea:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02034ec:	6905                	lui	s2,0x1
{
ffffffffc02034ee:	e822                	sd	s0,16(sp)
ffffffffc02034f0:	ec06                	sd	ra,24(sp)
ffffffffc02034f2:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02034f4:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8599>
{
ffffffffc02034f8:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT) {
ffffffffc02034fa:	04a7fc63          	bleu	a0,a5,ffffffffc0203552 <kmalloc+0x6a>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc02034fe:	4561                	li	a0,24
ffffffffc0203500:	ec1ff0ef          	jal	ra,ffffffffc02033c0 <slob_alloc.isra.1.constprop.3>
ffffffffc0203504:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0203506:	cd21                	beqz	a0,ffffffffc020355e <kmalloc+0x76>
	bb->order = find_order(size);
ffffffffc0203508:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc020350c:	4501                	li	a0,0
	for ( ; size > 4096 ; size >>=1)
ffffffffc020350e:	00f95763          	ble	a5,s2,ffffffffc020351c <kmalloc+0x34>
ffffffffc0203512:	6705                	lui	a4,0x1
ffffffffc0203514:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0203516:	2505                	addiw	a0,a0,1
	for ( ; size > 4096 ; size >>=1)
ffffffffc0203518:	fef74ee3          	blt	a4,a5,ffffffffc0203514 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc020351c:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc020351e:	e2fff0ef          	jal	ra,ffffffffc020334c <__slob_get_free_pages.isra.0>
ffffffffc0203522:	e488                	sd	a0,8(s1)
ffffffffc0203524:	842a                	mv	s0,a0
	if (bb->pages) {
ffffffffc0203526:	c935                	beqz	a0,ffffffffc020359a <kmalloc+0xb2>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203528:	100027f3          	csrr	a5,sstatus
ffffffffc020352c:	8b89                	andi	a5,a5,2
ffffffffc020352e:	e3a1                	bnez	a5,ffffffffc020356e <kmalloc+0x86>
		bb->next = bigblocks;
ffffffffc0203530:	000a9797          	auipc	a5,0xa9
ffffffffc0203534:	00878793          	addi	a5,a5,8 # ffffffffc02ac538 <bigblocks>
ffffffffc0203538:	639c                	ld	a5,0(a5)
		bigblocks = bb;
ffffffffc020353a:	000a9717          	auipc	a4,0xa9
ffffffffc020353e:	fe973f23          	sd	s1,-2(a4) # ffffffffc02ac538 <bigblocks>
		bb->next = bigblocks;
ffffffffc0203542:	e89c                	sd	a5,16(s1)
  return __kmalloc(size, 0);
}
ffffffffc0203544:	8522                	mv	a0,s0
ffffffffc0203546:	60e2                	ld	ra,24(sp)
ffffffffc0203548:	6442                	ld	s0,16(sp)
ffffffffc020354a:	64a2                	ld	s1,8(sp)
ffffffffc020354c:	6902                	ld	s2,0(sp)
ffffffffc020354e:	6105                	addi	sp,sp,32
ffffffffc0203550:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0203552:	0541                	addi	a0,a0,16
ffffffffc0203554:	e6dff0ef          	jal	ra,ffffffffc02033c0 <slob_alloc.isra.1.constprop.3>
		return m ? (void *)(m + 1) : 0;
ffffffffc0203558:	01050413          	addi	s0,a0,16
ffffffffc020355c:	f565                	bnez	a0,ffffffffc0203544 <kmalloc+0x5c>
ffffffffc020355e:	4401                	li	s0,0
}
ffffffffc0203560:	8522                	mv	a0,s0
ffffffffc0203562:	60e2                	ld	ra,24(sp)
ffffffffc0203564:	6442                	ld	s0,16(sp)
ffffffffc0203566:	64a2                	ld	s1,8(sp)
ffffffffc0203568:	6902                	ld	s2,0(sp)
ffffffffc020356a:	6105                	addi	sp,sp,32
ffffffffc020356c:	8082                	ret
        intr_disable();
ffffffffc020356e:	8eefd0ef          	jal	ra,ffffffffc020065c <intr_disable>
		bb->next = bigblocks;
ffffffffc0203572:	000a9797          	auipc	a5,0xa9
ffffffffc0203576:	fc678793          	addi	a5,a5,-58 # ffffffffc02ac538 <bigblocks>
ffffffffc020357a:	639c                	ld	a5,0(a5)
		bigblocks = bb;
ffffffffc020357c:	000a9717          	auipc	a4,0xa9
ffffffffc0203580:	fa973e23          	sd	s1,-68(a4) # ffffffffc02ac538 <bigblocks>
		bb->next = bigblocks;
ffffffffc0203584:	e89c                	sd	a5,16(s1)
        intr_enable();
ffffffffc0203586:	8d0fd0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc020358a:	6480                	ld	s0,8(s1)
}
ffffffffc020358c:	60e2                	ld	ra,24(sp)
ffffffffc020358e:	64a2                	ld	s1,8(sp)
ffffffffc0203590:	8522                	mv	a0,s0
ffffffffc0203592:	6442                	ld	s0,16(sp)
ffffffffc0203594:	6902                	ld	s2,0(sp)
ffffffffc0203596:	6105                	addi	sp,sp,32
ffffffffc0203598:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc020359a:	45e1                	li	a1,24
ffffffffc020359c:	8526                	mv	a0,s1
ffffffffc020359e:	c99ff0ef          	jal	ra,ffffffffc0203236 <slob_free>
  return __kmalloc(size, 0);
ffffffffc02035a2:	b74d                	j	ffffffffc0203544 <kmalloc+0x5c>

ffffffffc02035a4 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc02035a4:	c175                	beqz	a0,ffffffffc0203688 <kfree+0xe4>
{
ffffffffc02035a6:	1101                	addi	sp,sp,-32
ffffffffc02035a8:	e426                	sd	s1,8(sp)
ffffffffc02035aa:	ec06                	sd	ra,24(sp)
ffffffffc02035ac:	e822                	sd	s0,16(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
ffffffffc02035ae:	03451793          	slli	a5,a0,0x34
ffffffffc02035b2:	84aa                	mv	s1,a0
ffffffffc02035b4:	eb8d                	bnez	a5,ffffffffc02035e6 <kfree+0x42>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02035b6:	100027f3          	csrr	a5,sstatus
ffffffffc02035ba:	8b89                	andi	a5,a5,2
ffffffffc02035bc:	efc9                	bnez	a5,ffffffffc0203656 <kfree+0xb2>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc02035be:	000a9797          	auipc	a5,0xa9
ffffffffc02035c2:	f7a78793          	addi	a5,a5,-134 # ffffffffc02ac538 <bigblocks>
ffffffffc02035c6:	6394                	ld	a3,0(a5)
ffffffffc02035c8:	ce99                	beqz	a3,ffffffffc02035e6 <kfree+0x42>
			if (bb->pages == block) {
ffffffffc02035ca:	669c                	ld	a5,8(a3)
ffffffffc02035cc:	6a80                	ld	s0,16(a3)
ffffffffc02035ce:	0af50e63          	beq	a0,a5,ffffffffc020368a <kfree+0xe6>
    return 0;
ffffffffc02035d2:	4601                	li	a2,0
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc02035d4:	c801                	beqz	s0,ffffffffc02035e4 <kfree+0x40>
			if (bb->pages == block) {
ffffffffc02035d6:	6418                	ld	a4,8(s0)
ffffffffc02035d8:	681c                	ld	a5,16(s0)
ffffffffc02035da:	00970f63          	beq	a4,s1,ffffffffc02035f8 <kfree+0x54>
ffffffffc02035de:	86a2                	mv	a3,s0
ffffffffc02035e0:	843e                	mv	s0,a5
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc02035e2:	f875                	bnez	s0,ffffffffc02035d6 <kfree+0x32>
    if (flag) {
ffffffffc02035e4:	e659                	bnez	a2,ffffffffc0203672 <kfree+0xce>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc02035e6:	6442                	ld	s0,16(sp)
ffffffffc02035e8:	60e2                	ld	ra,24(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02035ea:	ff048513          	addi	a0,s1,-16
}
ffffffffc02035ee:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02035f0:	4581                	li	a1,0
}
ffffffffc02035f2:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02035f4:	c43ff06f          	j	ffffffffc0203236 <slob_free>
				*last = bb->next;
ffffffffc02035f8:	ea9c                	sd	a5,16(a3)
ffffffffc02035fa:	e641                	bnez	a2,ffffffffc0203682 <kfree+0xde>
    return pa2page(PADDR(kva));
ffffffffc02035fc:	c02007b7          	lui	a5,0xc0200
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0203600:	4018                	lw	a4,0(s0)
ffffffffc0203602:	08f4ea63          	bltu	s1,a5,ffffffffc0203696 <kfree+0xf2>
ffffffffc0203606:	000a9797          	auipc	a5,0xa9
ffffffffc020360a:	f7a78793          	addi	a5,a5,-134 # ffffffffc02ac580 <va_pa_offset>
ffffffffc020360e:	6394                	ld	a3,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0203610:	000a9797          	auipc	a5,0xa9
ffffffffc0203614:	f1878793          	addi	a5,a5,-232 # ffffffffc02ac528 <npage>
ffffffffc0203618:	639c                	ld	a5,0(a5)
    return pa2page(PADDR(kva));
ffffffffc020361a:	8c95                	sub	s1,s1,a3
    if (PPN(pa) >= npage) {
ffffffffc020361c:	80b1                	srli	s1,s1,0xc
ffffffffc020361e:	08f4f963          	bleu	a5,s1,ffffffffc02036b0 <kfree+0x10c>
    return &pages[PPN(pa) - nbase];
ffffffffc0203622:	00005797          	auipc	a5,0x5
ffffffffc0203626:	70e78793          	addi	a5,a5,1806 # ffffffffc0208d30 <nbase>
ffffffffc020362a:	639c                	ld	a5,0(a5)
ffffffffc020362c:	000a9697          	auipc	a3,0xa9
ffffffffc0203630:	f6468693          	addi	a3,a3,-156 # ffffffffc02ac590 <pages>
ffffffffc0203634:	6288                	ld	a0,0(a3)
ffffffffc0203636:	8c9d                	sub	s1,s1,a5
ffffffffc0203638:	049a                	slli	s1,s1,0x6
  free_pages(kva2page(kva), 1 << order);
ffffffffc020363a:	4585                	li	a1,1
ffffffffc020363c:	9526                	add	a0,a0,s1
ffffffffc020363e:	00e595bb          	sllw	a1,a1,a4
ffffffffc0203642:	8b9fd0ef          	jal	ra,ffffffffc0200efa <free_pages>
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0203646:	8522                	mv	a0,s0
}
ffffffffc0203648:	6442                	ld	s0,16(sp)
ffffffffc020364a:	60e2                	ld	ra,24(sp)
ffffffffc020364c:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc020364e:	45e1                	li	a1,24
}
ffffffffc0203650:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0203652:	be5ff06f          	j	ffffffffc0203236 <slob_free>
        intr_disable();
ffffffffc0203656:	806fd0ef          	jal	ra,ffffffffc020065c <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
ffffffffc020365a:	000a9797          	auipc	a5,0xa9
ffffffffc020365e:	ede78793          	addi	a5,a5,-290 # ffffffffc02ac538 <bigblocks>
ffffffffc0203662:	6394                	ld	a3,0(a5)
ffffffffc0203664:	c699                	beqz	a3,ffffffffc0203672 <kfree+0xce>
			if (bb->pages == block) {
ffffffffc0203666:	669c                	ld	a5,8(a3)
ffffffffc0203668:	6a80                	ld	s0,16(a3)
ffffffffc020366a:	00f48763          	beq	s1,a5,ffffffffc0203678 <kfree+0xd4>
        return 1;
ffffffffc020366e:	4605                	li	a2,1
ffffffffc0203670:	b795                	j	ffffffffc02035d4 <kfree+0x30>
        intr_enable();
ffffffffc0203672:	fe5fc0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc0203676:	bf85                	j	ffffffffc02035e6 <kfree+0x42>
				*last = bb->next;
ffffffffc0203678:	000a9797          	auipc	a5,0xa9
ffffffffc020367c:	ec87b023          	sd	s0,-320(a5) # ffffffffc02ac538 <bigblocks>
ffffffffc0203680:	8436                	mv	s0,a3
ffffffffc0203682:	fd5fc0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc0203686:	bf9d                	j	ffffffffc02035fc <kfree+0x58>
ffffffffc0203688:	8082                	ret
ffffffffc020368a:	000a9797          	auipc	a5,0xa9
ffffffffc020368e:	ea87b723          	sd	s0,-338(a5) # ffffffffc02ac538 <bigblocks>
ffffffffc0203692:	8436                	mv	s0,a3
ffffffffc0203694:	b7a5                	j	ffffffffc02035fc <kfree+0x58>
    return pa2page(PADDR(kva));
ffffffffc0203696:	86a6                	mv	a3,s1
ffffffffc0203698:	00004617          	auipc	a2,0x4
ffffffffc020369c:	a5060613          	addi	a2,a2,-1456 # ffffffffc02070e8 <commands+0x940>
ffffffffc02036a0:	06e00593          	li	a1,110
ffffffffc02036a4:	00004517          	auipc	a0,0x4
ffffffffc02036a8:	9c450513          	addi	a0,a0,-1596 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02036ac:	b6bfc0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02036b0:	00004617          	auipc	a2,0x4
ffffffffc02036b4:	99860613          	addi	a2,a2,-1640 # ffffffffc0207048 <commands+0x8a0>
ffffffffc02036b8:	06200593          	li	a1,98
ffffffffc02036bc:	00004517          	auipc	a0,0x4
ffffffffc02036c0:	9ac50513          	addi	a0,a0,-1620 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02036c4:	b53fc0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02036c8 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
ffffffffc02036c8:	7135                	addi	sp,sp,-160
ffffffffc02036ca:	ed06                	sd	ra,152(sp)
ffffffffc02036cc:	e922                	sd	s0,144(sp)
ffffffffc02036ce:	e526                	sd	s1,136(sp)
ffffffffc02036d0:	e14a                	sd	s2,128(sp)
ffffffffc02036d2:	fcce                	sd	s3,120(sp)
ffffffffc02036d4:	f8d2                	sd	s4,112(sp)
ffffffffc02036d6:	f4d6                	sd	s5,104(sp)
ffffffffc02036d8:	f0da                	sd	s6,96(sp)
ffffffffc02036da:	ecde                	sd	s7,88(sp)
ffffffffc02036dc:	e8e2                	sd	s8,80(sp)
ffffffffc02036de:	e4e6                	sd	s9,72(sp)
ffffffffc02036e0:	e0ea                	sd	s10,64(sp)
ffffffffc02036e2:	fc6e                	sd	s11,56(sp)
     swapfs_init();
ffffffffc02036e4:	460010ef          	jal	ra,ffffffffc0204b44 <swapfs_init>

     // Since the IDE is faked, it can only store 7 pages at most to pass the test
     if (!(7 <= max_swap_offset &&
ffffffffc02036e8:	000a9797          	auipc	a5,0xa9
ffffffffc02036ec:	f5078793          	addi	a5,a5,-176 # ffffffffc02ac638 <max_swap_offset>
ffffffffc02036f0:	6394                	ld	a3,0(a5)
ffffffffc02036f2:	010007b7          	lui	a5,0x1000
ffffffffc02036f6:	17e1                	addi	a5,a5,-8
ffffffffc02036f8:	ff968713          	addi	a4,a3,-7
ffffffffc02036fc:	4ae7ee63          	bltu	a5,a4,ffffffffc0203bb8 <swap_init+0x4f0>
        max_swap_offset < MAX_SWAP_OFFSET_LIMIT)) {
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
     }
     

     sm = &swap_manager_fifo;
ffffffffc0203700:	0009e797          	auipc	a5,0x9e
ffffffffc0203704:	9b078793          	addi	a5,a5,-1616 # ffffffffc02a10b0 <swap_manager_fifo>
     int r = sm->init();
ffffffffc0203708:	6798                	ld	a4,8(a5)
     sm = &swap_manager_fifo;
ffffffffc020370a:	000a9697          	auipc	a3,0xa9
ffffffffc020370e:	e2f6bb23          	sd	a5,-458(a3) # ffffffffc02ac540 <sm>
     int r = sm->init();
ffffffffc0203712:	9702                	jalr	a4
ffffffffc0203714:	8aaa                	mv	s5,a0
     
     if (r == 0)
ffffffffc0203716:	c10d                	beqz	a0,ffffffffc0203738 <swap_init+0x70>
          cprintf("SWAP: manager = %s\n", sm->name);
          check_swap();
     }

     return r;
}
ffffffffc0203718:	60ea                	ld	ra,152(sp)
ffffffffc020371a:	644a                	ld	s0,144(sp)
ffffffffc020371c:	8556                	mv	a0,s5
ffffffffc020371e:	64aa                	ld	s1,136(sp)
ffffffffc0203720:	690a                	ld	s2,128(sp)
ffffffffc0203722:	79e6                	ld	s3,120(sp)
ffffffffc0203724:	7a46                	ld	s4,112(sp)
ffffffffc0203726:	7aa6                	ld	s5,104(sp)
ffffffffc0203728:	7b06                	ld	s6,96(sp)
ffffffffc020372a:	6be6                	ld	s7,88(sp)
ffffffffc020372c:	6c46                	ld	s8,80(sp)
ffffffffc020372e:	6ca6                	ld	s9,72(sp)
ffffffffc0203730:	6d06                	ld	s10,64(sp)
ffffffffc0203732:	7de2                	ld	s11,56(sp)
ffffffffc0203734:	610d                	addi	sp,sp,160
ffffffffc0203736:	8082                	ret
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc0203738:	000a9797          	auipc	a5,0xa9
ffffffffc020373c:	e0878793          	addi	a5,a5,-504 # ffffffffc02ac540 <sm>
ffffffffc0203740:	639c                	ld	a5,0(a5)
ffffffffc0203742:	00004517          	auipc	a0,0x4
ffffffffc0203746:	5be50513          	addi	a0,a0,1470 # ffffffffc0207d00 <commands+0x1558>
ffffffffc020374a:	000a9417          	auipc	s0,0xa9
ffffffffc020374e:	f2e40413          	addi	s0,s0,-210 # ffffffffc02ac678 <free_area>
ffffffffc0203752:	638c                	ld	a1,0(a5)
          swap_init_ok = 1;
ffffffffc0203754:	4785                	li	a5,1
ffffffffc0203756:	000a9717          	auipc	a4,0xa9
ffffffffc020375a:	def72923          	sw	a5,-526(a4) # ffffffffc02ac548 <swap_init_ok>
          cprintf("SWAP: manager = %s\n", sm->name);
ffffffffc020375e:	973fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0203762:	641c                	ld	a5,8(s0)
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0203764:	36878e63          	beq	a5,s0,ffffffffc0203ae0 <swap_init+0x418>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0203768:	ff07b703          	ld	a4,-16(a5)
ffffffffc020376c:	8305                	srli	a4,a4,0x1
ffffffffc020376e:	8b05                	andi	a4,a4,1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0203770:	36070c63          	beqz	a4,ffffffffc0203ae8 <swap_init+0x420>
     int ret, count = 0, total = 0, i;
ffffffffc0203774:	4481                	li	s1,0
ffffffffc0203776:	4901                	li	s2,0
ffffffffc0203778:	a031                	j	ffffffffc0203784 <swap_init+0xbc>
ffffffffc020377a:	ff07b703          	ld	a4,-16(a5)
        assert(PageProperty(p));
ffffffffc020377e:	8b09                	andi	a4,a4,2
ffffffffc0203780:	36070463          	beqz	a4,ffffffffc0203ae8 <swap_init+0x420>
        count ++, total += p->property;
ffffffffc0203784:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203788:	679c                	ld	a5,8(a5)
ffffffffc020378a:	2905                	addiw	s2,s2,1
ffffffffc020378c:	9cb9                	addw	s1,s1,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc020378e:	fe8796e3          	bne	a5,s0,ffffffffc020377a <swap_init+0xb2>
ffffffffc0203792:	89a6                	mv	s3,s1
     }
     assert(total == nr_free_pages());
ffffffffc0203794:	facfd0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
ffffffffc0203798:	69351863          	bne	a0,s3,ffffffffc0203e28 <swap_init+0x760>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
ffffffffc020379c:	8626                	mv	a2,s1
ffffffffc020379e:	85ca                	mv	a1,s2
ffffffffc02037a0:	00004517          	auipc	a0,0x4
ffffffffc02037a4:	5a850513          	addi	a0,a0,1448 # ffffffffc0207d48 <commands+0x15a0>
ffffffffc02037a8:	929fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
ffffffffc02037ac:	80cff0ef          	jal	ra,ffffffffc02027b8 <mm_create>
ffffffffc02037b0:	8baa                	mv	s7,a0
     assert(mm != NULL);
ffffffffc02037b2:	60050b63          	beqz	a0,ffffffffc0203dc8 <swap_init+0x700>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
ffffffffc02037b6:	000a9797          	auipc	a5,0xa9
ffffffffc02037ba:	df278793          	addi	a5,a5,-526 # ffffffffc02ac5a8 <check_mm_struct>
ffffffffc02037be:	639c                	ld	a5,0(a5)
ffffffffc02037c0:	62079463          	bnez	a5,ffffffffc0203de8 <swap_init+0x720>

     check_mm_struct = mm;

     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02037c4:	000a9797          	auipc	a5,0xa9
ffffffffc02037c8:	d5c78793          	addi	a5,a5,-676 # ffffffffc02ac520 <boot_pgdir>
ffffffffc02037cc:	0007bb03          	ld	s6,0(a5)
     check_mm_struct = mm;
ffffffffc02037d0:	000a9797          	auipc	a5,0xa9
ffffffffc02037d4:	dca7bc23          	sd	a0,-552(a5) # ffffffffc02ac5a8 <check_mm_struct>
     assert(pgdir[0] == 0);
ffffffffc02037d8:	000b3783          	ld	a5,0(s6) # 80000 <_binary_obj___user_exit_out_size+0x75578>
     pde_t *pgdir = mm->pgdir = boot_pgdir;
ffffffffc02037dc:	01653c23          	sd	s6,24(a0)
     assert(pgdir[0] == 0);
ffffffffc02037e0:	4e079863          	bnez	a5,ffffffffc0203cd0 <swap_init+0x608>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
ffffffffc02037e4:	6599                	lui	a1,0x6
ffffffffc02037e6:	460d                	li	a2,3
ffffffffc02037e8:	6505                	lui	a0,0x1
ffffffffc02037ea:	81aff0ef          	jal	ra,ffffffffc0202804 <vma_create>
ffffffffc02037ee:	85aa                	mv	a1,a0
     assert(vma != NULL);
ffffffffc02037f0:	50050063          	beqz	a0,ffffffffc0203cf0 <swap_init+0x628>

     insert_vma_struct(mm, vma);
ffffffffc02037f4:	855e                	mv	a0,s7
ffffffffc02037f6:	87aff0ef          	jal	ra,ffffffffc0202870 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
ffffffffc02037fa:	00004517          	auipc	a0,0x4
ffffffffc02037fe:	58e50513          	addi	a0,a0,1422 # ffffffffc0207d88 <commands+0x15e0>
ffffffffc0203802:	8cffc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
ffffffffc0203806:	018bb503          	ld	a0,24(s7)
ffffffffc020380a:	4605                	li	a2,1
ffffffffc020380c:	6585                	lui	a1,0x1
ffffffffc020380e:	f72fd0ef          	jal	ra,ffffffffc0200f80 <get_pte>
     assert(temp_ptep!= NULL);
ffffffffc0203812:	4e050f63          	beqz	a0,ffffffffc0203d10 <swap_init+0x648>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0203816:	00004517          	auipc	a0,0x4
ffffffffc020381a:	5c250513          	addi	a0,a0,1474 # ffffffffc0207dd8 <commands+0x1630>
ffffffffc020381e:	000a9997          	auipc	s3,0xa9
ffffffffc0203822:	d9298993          	addi	s3,s3,-622 # ffffffffc02ac5b0 <check_rp>
ffffffffc0203826:	8abfc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020382a:	000a9a17          	auipc	s4,0xa9
ffffffffc020382e:	da6a0a13          	addi	s4,s4,-602 # ffffffffc02ac5d0 <swap_in_seq_no>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
ffffffffc0203832:	8c4e                	mv	s8,s3
          check_rp[i] = alloc_page();
ffffffffc0203834:	4505                	li	a0,1
ffffffffc0203836:	e3cfd0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020383a:	00ac3023          	sd	a0,0(s8)
          assert(check_rp[i] != NULL );
ffffffffc020383e:	32050d63          	beqz	a0,ffffffffc0203b78 <swap_init+0x4b0>
ffffffffc0203842:	651c                	ld	a5,8(a0)
          assert(!PageProperty(check_rp[i]));
ffffffffc0203844:	8b89                	andi	a5,a5,2
ffffffffc0203846:	30079963          	bnez	a5,ffffffffc0203b58 <swap_init+0x490>
ffffffffc020384a:	0c21                	addi	s8,s8,8
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc020384c:	ff4c14e3          	bne	s8,s4,ffffffffc0203834 <swap_init+0x16c>
     }
     list_entry_t free_list_store = free_list;
ffffffffc0203850:	601c                	ld	a5,0(s0)
     assert(list_empty(&free_list));
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
ffffffffc0203852:	000a9c17          	auipc	s8,0xa9
ffffffffc0203856:	d5ec0c13          	addi	s8,s8,-674 # ffffffffc02ac5b0 <check_rp>
     list_entry_t free_list_store = free_list;
ffffffffc020385a:	ec3e                	sd	a5,24(sp)
ffffffffc020385c:	641c                	ld	a5,8(s0)
ffffffffc020385e:	f03e                	sd	a5,32(sp)
     unsigned int nr_free_store = nr_free;
ffffffffc0203860:	481c                	lw	a5,16(s0)
ffffffffc0203862:	f43e                	sd	a5,40(sp)
    elm->prev = elm->next = elm;
ffffffffc0203864:	000a9797          	auipc	a5,0xa9
ffffffffc0203868:	e087be23          	sd	s0,-484(a5) # ffffffffc02ac680 <free_area+0x8>
ffffffffc020386c:	000a9797          	auipc	a5,0xa9
ffffffffc0203870:	e087b623          	sd	s0,-500(a5) # ffffffffc02ac678 <free_area>
     nr_free = 0;
ffffffffc0203874:	000a9797          	auipc	a5,0xa9
ffffffffc0203878:	e007aa23          	sw	zero,-492(a5) # ffffffffc02ac688 <free_area+0x10>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
        free_pages(check_rp[i],1);
ffffffffc020387c:	000c3503          	ld	a0,0(s8)
ffffffffc0203880:	4585                	li	a1,1
ffffffffc0203882:	0c21                	addi	s8,s8,8
ffffffffc0203884:	e76fd0ef          	jal	ra,ffffffffc0200efa <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0203888:	ff4c1ae3          	bne	s8,s4,ffffffffc020387c <swap_init+0x1b4>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc020388c:	01042c03          	lw	s8,16(s0)
ffffffffc0203890:	4791                	li	a5,4
ffffffffc0203892:	50fc1b63          	bne	s8,a5,ffffffffc0203da8 <swap_init+0x6e0>
     
     cprintf("set up init env for check_swap begin!\n");
ffffffffc0203896:	00004517          	auipc	a0,0x4
ffffffffc020389a:	5ca50513          	addi	a0,a0,1482 # ffffffffc0207e60 <commands+0x16b8>
ffffffffc020389e:	833fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02038a2:	6685                	lui	a3,0x1
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
ffffffffc02038a4:	000a9797          	auipc	a5,0xa9
ffffffffc02038a8:	c807a623          	sw	zero,-884(a5) # ffffffffc02ac530 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02038ac:	4629                	li	a2,10
     pgfault_num=0;
ffffffffc02038ae:	000a9797          	auipc	a5,0xa9
ffffffffc02038b2:	c8278793          	addi	a5,a5,-894 # ffffffffc02ac530 <pgfault_num>
     *(unsigned char *)0x1000 = 0x0a;
ffffffffc02038b6:	00c68023          	sb	a2,0(a3) # 1000 <_binary_obj___user_faultread_out_size-0x8588>
     assert(pgfault_num==1);
ffffffffc02038ba:	4398                	lw	a4,0(a5)
ffffffffc02038bc:	4585                	li	a1,1
ffffffffc02038be:	2701                	sext.w	a4,a4
ffffffffc02038c0:	38b71863          	bne	a4,a1,ffffffffc0203c50 <swap_init+0x588>
     *(unsigned char *)0x1010 = 0x0a;
ffffffffc02038c4:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==1);
ffffffffc02038c8:	4394                	lw	a3,0(a5)
ffffffffc02038ca:	2681                	sext.w	a3,a3
ffffffffc02038cc:	3ae69263          	bne	a3,a4,ffffffffc0203c70 <swap_init+0x5a8>
     *(unsigned char *)0x2000 = 0x0b;
ffffffffc02038d0:	6689                	lui	a3,0x2
ffffffffc02038d2:	462d                	li	a2,11
ffffffffc02038d4:	00c68023          	sb	a2,0(a3) # 2000 <_binary_obj___user_faultread_out_size-0x7588>
     assert(pgfault_num==2);
ffffffffc02038d8:	4398                	lw	a4,0(a5)
ffffffffc02038da:	4589                	li	a1,2
ffffffffc02038dc:	2701                	sext.w	a4,a4
ffffffffc02038de:	2eb71963          	bne	a4,a1,ffffffffc0203bd0 <swap_init+0x508>
     *(unsigned char *)0x2010 = 0x0b;
ffffffffc02038e2:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==2);
ffffffffc02038e6:	4394                	lw	a3,0(a5)
ffffffffc02038e8:	2681                	sext.w	a3,a3
ffffffffc02038ea:	30e69363          	bne	a3,a4,ffffffffc0203bf0 <swap_init+0x528>
     *(unsigned char *)0x3000 = 0x0c;
ffffffffc02038ee:	668d                	lui	a3,0x3
ffffffffc02038f0:	4631                	li	a2,12
ffffffffc02038f2:	00c68023          	sb	a2,0(a3) # 3000 <_binary_obj___user_faultread_out_size-0x6588>
     assert(pgfault_num==3);
ffffffffc02038f6:	4398                	lw	a4,0(a5)
ffffffffc02038f8:	458d                	li	a1,3
ffffffffc02038fa:	2701                	sext.w	a4,a4
ffffffffc02038fc:	30b71a63          	bne	a4,a1,ffffffffc0203c10 <swap_init+0x548>
     *(unsigned char *)0x3010 = 0x0c;
ffffffffc0203900:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==3);
ffffffffc0203904:	4394                	lw	a3,0(a5)
ffffffffc0203906:	2681                	sext.w	a3,a3
ffffffffc0203908:	32e69463          	bne	a3,a4,ffffffffc0203c30 <swap_init+0x568>
     *(unsigned char *)0x4000 = 0x0d;
ffffffffc020390c:	6691                	lui	a3,0x4
ffffffffc020390e:	4635                	li	a2,13
ffffffffc0203910:	00c68023          	sb	a2,0(a3) # 4000 <_binary_obj___user_faultread_out_size-0x5588>
     assert(pgfault_num==4);
ffffffffc0203914:	4398                	lw	a4,0(a5)
ffffffffc0203916:	2701                	sext.w	a4,a4
ffffffffc0203918:	37871c63          	bne	a4,s8,ffffffffc0203c90 <swap_init+0x5c8>
     *(unsigned char *)0x4010 = 0x0d;
ffffffffc020391c:	00c68823          	sb	a2,16(a3)
     assert(pgfault_num==4);
ffffffffc0203920:	439c                	lw	a5,0(a5)
ffffffffc0203922:	2781                	sext.w	a5,a5
ffffffffc0203924:	38e79663          	bne	a5,a4,ffffffffc0203cb0 <swap_init+0x5e8>
     
     check_content_set();
     assert( nr_free == 0);         
ffffffffc0203928:	481c                	lw	a5,16(s0)
ffffffffc020392a:	40079363          	bnez	a5,ffffffffc0203d30 <swap_init+0x668>
ffffffffc020392e:	000a9797          	auipc	a5,0xa9
ffffffffc0203932:	ca278793          	addi	a5,a5,-862 # ffffffffc02ac5d0 <swap_in_seq_no>
ffffffffc0203936:	000a9717          	auipc	a4,0xa9
ffffffffc020393a:	cc270713          	addi	a4,a4,-830 # ffffffffc02ac5f8 <swap_out_seq_no>
ffffffffc020393e:	000a9617          	auipc	a2,0xa9
ffffffffc0203942:	cba60613          	addi	a2,a2,-838 # ffffffffc02ac5f8 <swap_out_seq_no>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
ffffffffc0203946:	56fd                	li	a3,-1
ffffffffc0203948:	c394                	sw	a3,0(a5)
ffffffffc020394a:	c314                	sw	a3,0(a4)
ffffffffc020394c:	0791                	addi	a5,a5,4
ffffffffc020394e:	0711                	addi	a4,a4,4
     for(i = 0; i<MAX_SEQ_NO ; i++) 
ffffffffc0203950:	fef61ce3          	bne	a2,a5,ffffffffc0203948 <swap_init+0x280>
ffffffffc0203954:	000a9697          	auipc	a3,0xa9
ffffffffc0203958:	d0468693          	addi	a3,a3,-764 # ffffffffc02ac658 <check_ptep>
ffffffffc020395c:	000a9817          	auipc	a6,0xa9
ffffffffc0203960:	c5480813          	addi	a6,a6,-940 # ffffffffc02ac5b0 <check_rp>
ffffffffc0203964:	6d05                	lui	s10,0x1
    if (PPN(pa) >= npage) {
ffffffffc0203966:	000a9c97          	auipc	s9,0xa9
ffffffffc020396a:	bc2c8c93          	addi	s9,s9,-1086 # ffffffffc02ac528 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020396e:	00005d97          	auipc	s11,0x5
ffffffffc0203972:	3c2d8d93          	addi	s11,s11,962 # ffffffffc0208d30 <nbase>
ffffffffc0203976:	000a9c17          	auipc	s8,0xa9
ffffffffc020397a:	c1ac0c13          	addi	s8,s8,-998 # ffffffffc02ac590 <pages>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         check_ptep[i]=0;
ffffffffc020397e:	0006b023          	sd	zero,0(a3)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0203982:	4601                	li	a2,0
ffffffffc0203984:	85ea                	mv	a1,s10
ffffffffc0203986:	855a                	mv	a0,s6
ffffffffc0203988:	e842                	sd	a6,16(sp)
         check_ptep[i]=0;
ffffffffc020398a:	e436                	sd	a3,8(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc020398c:	df4fd0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0203990:	66a2                	ld	a3,8(sp)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
ffffffffc0203992:	6842                	ld	a6,16(sp)
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
ffffffffc0203994:	e288                	sd	a0,0(a3)
         assert(check_ptep[i] != NULL);
ffffffffc0203996:	20050163          	beqz	a0,ffffffffc0203b98 <swap_init+0x4d0>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc020399a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V)) {
ffffffffc020399c:	0017f613          	andi	a2,a5,1
ffffffffc02039a0:	1a060063          	beqz	a2,ffffffffc0203b40 <swap_init+0x478>
    if (PPN(pa) >= npage) {
ffffffffc02039a4:	000cb603          	ld	a2,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02039a8:	078a                	slli	a5,a5,0x2
ffffffffc02039aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc02039ac:	14c7fe63          	bleu	a2,a5,ffffffffc0203b08 <swap_init+0x440>
    return &pages[PPN(pa) - nbase];
ffffffffc02039b0:	000db703          	ld	a4,0(s11)
ffffffffc02039b4:	000c3603          	ld	a2,0(s8)
ffffffffc02039b8:	00083583          	ld	a1,0(a6)
ffffffffc02039bc:	8f99                	sub	a5,a5,a4
ffffffffc02039be:	079a                	slli	a5,a5,0x6
ffffffffc02039c0:	e43a                	sd	a4,8(sp)
ffffffffc02039c2:	97b2                	add	a5,a5,a2
ffffffffc02039c4:	14f59e63          	bne	a1,a5,ffffffffc0203b20 <swap_init+0x458>
ffffffffc02039c8:	6785                	lui	a5,0x1
ffffffffc02039ca:	9d3e                	add	s10,s10,a5
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc02039cc:	6795                	lui	a5,0x5
ffffffffc02039ce:	06a1                	addi	a3,a3,8
ffffffffc02039d0:	0821                	addi	a6,a6,8
ffffffffc02039d2:	fafd16e3          	bne	s10,a5,ffffffffc020397e <swap_init+0x2b6>
         assert((*check_ptep[i] & PTE_V));          
     }
     cprintf("set up init env for check_swap over!\n");
ffffffffc02039d6:	00004517          	auipc	a0,0x4
ffffffffc02039da:	53250513          	addi	a0,a0,1330 # ffffffffc0207f08 <commands+0x1760>
ffffffffc02039de:	ef2fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    int ret = sm->check_swap();
ffffffffc02039e2:	000a9797          	auipc	a5,0xa9
ffffffffc02039e6:	b5e78793          	addi	a5,a5,-1186 # ffffffffc02ac540 <sm>
ffffffffc02039ea:	639c                	ld	a5,0(a5)
ffffffffc02039ec:	7f9c                	ld	a5,56(a5)
ffffffffc02039ee:	9782                	jalr	a5
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
ffffffffc02039f0:	40051c63          	bnez	a0,ffffffffc0203e08 <swap_init+0x740>

     nr_free = nr_free_store;
ffffffffc02039f4:	77a2                	ld	a5,40(sp)
ffffffffc02039f6:	000a9717          	auipc	a4,0xa9
ffffffffc02039fa:	c8f72923          	sw	a5,-878(a4) # ffffffffc02ac688 <free_area+0x10>
     free_list = free_list_store;
ffffffffc02039fe:	67e2                	ld	a5,24(sp)
ffffffffc0203a00:	000a9717          	auipc	a4,0xa9
ffffffffc0203a04:	c6f73c23          	sd	a5,-904(a4) # ffffffffc02ac678 <free_area>
ffffffffc0203a08:	7782                	ld	a5,32(sp)
ffffffffc0203a0a:	000a9717          	auipc	a4,0xa9
ffffffffc0203a0e:	c6f73b23          	sd	a5,-906(a4) # ffffffffc02ac680 <free_area+0x8>

     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
         free_pages(check_rp[i],1);
ffffffffc0203a12:	0009b503          	ld	a0,0(s3)
ffffffffc0203a16:	4585                	li	a1,1
ffffffffc0203a18:	09a1                	addi	s3,s3,8
ffffffffc0203a1a:	ce0fd0ef          	jal	ra,ffffffffc0200efa <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
ffffffffc0203a1e:	ff499ae3          	bne	s3,s4,ffffffffc0203a12 <swap_init+0x34a>
     } 

     //free_page(pte2page(*temp_ptep));

     mm->pgdir = NULL;
ffffffffc0203a22:	000bbc23          	sd	zero,24(s7)
     mm_destroy(mm);
ffffffffc0203a26:	855e                	mv	a0,s7
ffffffffc0203a28:	f17fe0ef          	jal	ra,ffffffffc020293e <mm_destroy>
     check_mm_struct = NULL;

     pde_t *pd1=pgdir,*pd0=page2kva(pde2page(boot_pgdir[0]));
ffffffffc0203a2c:	000a9797          	auipc	a5,0xa9
ffffffffc0203a30:	af478793          	addi	a5,a5,-1292 # ffffffffc02ac520 <boot_pgdir>
ffffffffc0203a34:	639c                	ld	a5,0(a5)
     check_mm_struct = NULL;
ffffffffc0203a36:	000a9697          	auipc	a3,0xa9
ffffffffc0203a3a:	b606b923          	sd	zero,-1166(a3) # ffffffffc02ac5a8 <check_mm_struct>
    if (PPN(pa) >= npage) {
ffffffffc0203a3e:	000cb703          	ld	a4,0(s9)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203a42:	6394                	ld	a3,0(a5)
ffffffffc0203a44:	068a                	slli	a3,a3,0x2
ffffffffc0203a46:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203a48:	0ce6f063          	bleu	a4,a3,ffffffffc0203b08 <swap_init+0x440>
    return &pages[PPN(pa) - nbase];
ffffffffc0203a4c:	67a2                	ld	a5,8(sp)
ffffffffc0203a4e:	000c3503          	ld	a0,0(s8)
ffffffffc0203a52:	8e9d                	sub	a3,a3,a5
ffffffffc0203a54:	069a                	slli	a3,a3,0x6
    return page - pages + nbase;
ffffffffc0203a56:	8699                	srai	a3,a3,0x6
ffffffffc0203a58:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0203a5a:	57fd                	li	a5,-1
ffffffffc0203a5c:	83b1                	srli	a5,a5,0xc
ffffffffc0203a5e:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0203a60:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203a62:	2ee7f763          	bleu	a4,a5,ffffffffc0203d50 <swap_init+0x688>
     free_page(pde2page(pd0[0]));
ffffffffc0203a66:	000a9797          	auipc	a5,0xa9
ffffffffc0203a6a:	b1a78793          	addi	a5,a5,-1254 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0203a6e:	639c                	ld	a5,0(a5)
ffffffffc0203a70:	96be                	add	a3,a3,a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0203a72:	629c                	ld	a5,0(a3)
ffffffffc0203a74:	078a                	slli	a5,a5,0x2
ffffffffc0203a76:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203a78:	08e7f863          	bleu	a4,a5,ffffffffc0203b08 <swap_init+0x440>
    return &pages[PPN(pa) - nbase];
ffffffffc0203a7c:	69a2                	ld	s3,8(sp)
ffffffffc0203a7e:	4585                	li	a1,1
ffffffffc0203a80:	413787b3          	sub	a5,a5,s3
ffffffffc0203a84:	079a                	slli	a5,a5,0x6
ffffffffc0203a86:	953e                	add	a0,a0,a5
ffffffffc0203a88:	c72fd0ef          	jal	ra,ffffffffc0200efa <free_pages>
    return pa2page(PDE_ADDR(pde));
ffffffffc0203a8c:	000b3783          	ld	a5,0(s6)
    if (PPN(pa) >= npage) {
ffffffffc0203a90:	000cb703          	ld	a4,0(s9)
    return pa2page(PDE_ADDR(pde));
ffffffffc0203a94:	078a                	slli	a5,a5,0x2
ffffffffc0203a96:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage) {
ffffffffc0203a98:	06e7f863          	bleu	a4,a5,ffffffffc0203b08 <swap_init+0x440>
    return &pages[PPN(pa) - nbase];
ffffffffc0203a9c:	000c3503          	ld	a0,0(s8)
ffffffffc0203aa0:	413787b3          	sub	a5,a5,s3
ffffffffc0203aa4:	079a                	slli	a5,a5,0x6
     free_page(pde2page(pd1[0]));
ffffffffc0203aa6:	4585                	li	a1,1
ffffffffc0203aa8:	953e                	add	a0,a0,a5
ffffffffc0203aaa:	c50fd0ef          	jal	ra,ffffffffc0200efa <free_pages>
     pgdir[0] = 0;
ffffffffc0203aae:	000b3023          	sd	zero,0(s6)
  asm volatile("sfence.vma");
ffffffffc0203ab2:	12000073          	sfence.vma
    return listelm->next;
ffffffffc0203ab6:	641c                	ld	a5,8(s0)
     flush_tlb();

     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
ffffffffc0203ab8:	00878963          	beq	a5,s0,ffffffffc0203aca <swap_init+0x402>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
ffffffffc0203abc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203ac0:	679c                	ld	a5,8(a5)
ffffffffc0203ac2:	397d                	addiw	s2,s2,-1
ffffffffc0203ac4:	9c99                	subw	s1,s1,a4
     while ((le = list_next(le)) != &free_list) {
ffffffffc0203ac6:	fe879be3          	bne	a5,s0,ffffffffc0203abc <swap_init+0x3f4>
     }
     assert(count==0);
ffffffffc0203aca:	28091f63          	bnez	s2,ffffffffc0203d68 <swap_init+0x6a0>
     assert(total==0);
ffffffffc0203ace:	2a049d63          	bnez	s1,ffffffffc0203d88 <swap_init+0x6c0>

     cprintf("check_swap() succeeded!\n");
ffffffffc0203ad2:	00004517          	auipc	a0,0x4
ffffffffc0203ad6:	48650513          	addi	a0,a0,1158 # ffffffffc0207f58 <commands+0x17b0>
ffffffffc0203ada:	df6fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0203ade:	b92d                	j	ffffffffc0203718 <swap_init+0x50>
     int ret, count = 0, total = 0, i;
ffffffffc0203ae0:	4481                	li	s1,0
ffffffffc0203ae2:	4901                	li	s2,0
     while ((le = list_next(le)) != &free_list) {
ffffffffc0203ae4:	4981                	li	s3,0
ffffffffc0203ae6:	b17d                	j	ffffffffc0203794 <swap_init+0xcc>
        assert(PageProperty(p));
ffffffffc0203ae8:	00004697          	auipc	a3,0x4
ffffffffc0203aec:	23068693          	addi	a3,a3,560 # ffffffffc0207d18 <commands+0x1570>
ffffffffc0203af0:	00003617          	auipc	a2,0x3
ffffffffc0203af4:	13860613          	addi	a2,a2,312 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203af8:	0bc00593          	li	a1,188
ffffffffc0203afc:	00004517          	auipc	a0,0x4
ffffffffc0203b00:	1f450513          	addi	a0,a0,500 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203b04:	f12fc0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203b08:	00003617          	auipc	a2,0x3
ffffffffc0203b0c:	54060613          	addi	a2,a2,1344 # ffffffffc0207048 <commands+0x8a0>
ffffffffc0203b10:	06200593          	li	a1,98
ffffffffc0203b14:	00003517          	auipc	a0,0x3
ffffffffc0203b18:	55450513          	addi	a0,a0,1364 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0203b1c:	efafc0ef          	jal	ra,ffffffffc0200216 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
ffffffffc0203b20:	00004697          	auipc	a3,0x4
ffffffffc0203b24:	3c068693          	addi	a3,a3,960 # ffffffffc0207ee0 <commands+0x1738>
ffffffffc0203b28:	00003617          	auipc	a2,0x3
ffffffffc0203b2c:	10060613          	addi	a2,a2,256 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203b30:	0fc00593          	li	a1,252
ffffffffc0203b34:	00004517          	auipc	a0,0x4
ffffffffc0203b38:	1bc50513          	addi	a0,a0,444 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203b3c:	edafc0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pte2page called with invalid pte");
ffffffffc0203b40:	00003617          	auipc	a2,0x3
ffffffffc0203b44:	6e860613          	addi	a2,a2,1768 # ffffffffc0207228 <commands+0xa80>
ffffffffc0203b48:	07400593          	li	a1,116
ffffffffc0203b4c:	00003517          	auipc	a0,0x3
ffffffffc0203b50:	51c50513          	addi	a0,a0,1308 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0203b54:	ec2fc0ef          	jal	ra,ffffffffc0200216 <__panic>
          assert(!PageProperty(check_rp[i]));
ffffffffc0203b58:	00004697          	auipc	a3,0x4
ffffffffc0203b5c:	2c068693          	addi	a3,a3,704 # ffffffffc0207e18 <commands+0x1670>
ffffffffc0203b60:	00003617          	auipc	a2,0x3
ffffffffc0203b64:	0c860613          	addi	a2,a2,200 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203b68:	0dd00593          	li	a1,221
ffffffffc0203b6c:	00004517          	auipc	a0,0x4
ffffffffc0203b70:	18450513          	addi	a0,a0,388 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203b74:	ea2fc0ef          	jal	ra,ffffffffc0200216 <__panic>
          assert(check_rp[i] != NULL );
ffffffffc0203b78:	00004697          	auipc	a3,0x4
ffffffffc0203b7c:	28868693          	addi	a3,a3,648 # ffffffffc0207e00 <commands+0x1658>
ffffffffc0203b80:	00003617          	auipc	a2,0x3
ffffffffc0203b84:	0a860613          	addi	a2,a2,168 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203b88:	0dc00593          	li	a1,220
ffffffffc0203b8c:	00004517          	auipc	a0,0x4
ffffffffc0203b90:	16450513          	addi	a0,a0,356 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203b94:	e82fc0ef          	jal	ra,ffffffffc0200216 <__panic>
         assert(check_ptep[i] != NULL);
ffffffffc0203b98:	00004697          	auipc	a3,0x4
ffffffffc0203b9c:	33068693          	addi	a3,a3,816 # ffffffffc0207ec8 <commands+0x1720>
ffffffffc0203ba0:	00003617          	auipc	a2,0x3
ffffffffc0203ba4:	08860613          	addi	a2,a2,136 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203ba8:	0fb00593          	li	a1,251
ffffffffc0203bac:	00004517          	auipc	a0,0x4
ffffffffc0203bb0:	14450513          	addi	a0,a0,324 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203bb4:	e62fc0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("bad max_swap_offset %08x.\n", max_swap_offset);
ffffffffc0203bb8:	00004617          	auipc	a2,0x4
ffffffffc0203bbc:	11860613          	addi	a2,a2,280 # ffffffffc0207cd0 <commands+0x1528>
ffffffffc0203bc0:	02800593          	li	a1,40
ffffffffc0203bc4:	00004517          	auipc	a0,0x4
ffffffffc0203bc8:	12c50513          	addi	a0,a0,300 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203bcc:	e4afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==2);
ffffffffc0203bd0:	00004697          	auipc	a3,0x4
ffffffffc0203bd4:	2c868693          	addi	a3,a3,712 # ffffffffc0207e98 <commands+0x16f0>
ffffffffc0203bd8:	00003617          	auipc	a2,0x3
ffffffffc0203bdc:	05060613          	addi	a2,a2,80 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203be0:	09700593          	li	a1,151
ffffffffc0203be4:	00004517          	auipc	a0,0x4
ffffffffc0203be8:	10c50513          	addi	a0,a0,268 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203bec:	e2afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==2);
ffffffffc0203bf0:	00004697          	auipc	a3,0x4
ffffffffc0203bf4:	2a868693          	addi	a3,a3,680 # ffffffffc0207e98 <commands+0x16f0>
ffffffffc0203bf8:	00003617          	auipc	a2,0x3
ffffffffc0203bfc:	03060613          	addi	a2,a2,48 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203c00:	09900593          	li	a1,153
ffffffffc0203c04:	00004517          	auipc	a0,0x4
ffffffffc0203c08:	0ec50513          	addi	a0,a0,236 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203c0c:	e0afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==3);
ffffffffc0203c10:	00004697          	auipc	a3,0x4
ffffffffc0203c14:	29868693          	addi	a3,a3,664 # ffffffffc0207ea8 <commands+0x1700>
ffffffffc0203c18:	00003617          	auipc	a2,0x3
ffffffffc0203c1c:	01060613          	addi	a2,a2,16 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203c20:	09b00593          	li	a1,155
ffffffffc0203c24:	00004517          	auipc	a0,0x4
ffffffffc0203c28:	0cc50513          	addi	a0,a0,204 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203c2c:	deafc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==3);
ffffffffc0203c30:	00004697          	auipc	a3,0x4
ffffffffc0203c34:	27868693          	addi	a3,a3,632 # ffffffffc0207ea8 <commands+0x1700>
ffffffffc0203c38:	00003617          	auipc	a2,0x3
ffffffffc0203c3c:	ff060613          	addi	a2,a2,-16 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203c40:	09d00593          	li	a1,157
ffffffffc0203c44:	00004517          	auipc	a0,0x4
ffffffffc0203c48:	0ac50513          	addi	a0,a0,172 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203c4c:	dcafc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==1);
ffffffffc0203c50:	00004697          	auipc	a3,0x4
ffffffffc0203c54:	23868693          	addi	a3,a3,568 # ffffffffc0207e88 <commands+0x16e0>
ffffffffc0203c58:	00003617          	auipc	a2,0x3
ffffffffc0203c5c:	fd060613          	addi	a2,a2,-48 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203c60:	09300593          	li	a1,147
ffffffffc0203c64:	00004517          	auipc	a0,0x4
ffffffffc0203c68:	08c50513          	addi	a0,a0,140 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203c6c:	daafc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==1);
ffffffffc0203c70:	00004697          	auipc	a3,0x4
ffffffffc0203c74:	21868693          	addi	a3,a3,536 # ffffffffc0207e88 <commands+0x16e0>
ffffffffc0203c78:	00003617          	auipc	a2,0x3
ffffffffc0203c7c:	fb060613          	addi	a2,a2,-80 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203c80:	09500593          	li	a1,149
ffffffffc0203c84:	00004517          	auipc	a0,0x4
ffffffffc0203c88:	06c50513          	addi	a0,a0,108 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203c8c:	d8afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==4);
ffffffffc0203c90:	00004697          	auipc	a3,0x4
ffffffffc0203c94:	9e868693          	addi	a3,a3,-1560 # ffffffffc0207678 <commands+0xed0>
ffffffffc0203c98:	00003617          	auipc	a2,0x3
ffffffffc0203c9c:	f9060613          	addi	a2,a2,-112 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203ca0:	09f00593          	li	a1,159
ffffffffc0203ca4:	00004517          	auipc	a0,0x4
ffffffffc0203ca8:	04c50513          	addi	a0,a0,76 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203cac:	d6afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgfault_num==4);
ffffffffc0203cb0:	00004697          	auipc	a3,0x4
ffffffffc0203cb4:	9c868693          	addi	a3,a3,-1592 # ffffffffc0207678 <commands+0xed0>
ffffffffc0203cb8:	00003617          	auipc	a2,0x3
ffffffffc0203cbc:	f7060613          	addi	a2,a2,-144 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203cc0:	0a100593          	li	a1,161
ffffffffc0203cc4:	00004517          	auipc	a0,0x4
ffffffffc0203cc8:	02c50513          	addi	a0,a0,44 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203ccc:	d4afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(pgdir[0] == 0);
ffffffffc0203cd0:	00004697          	auipc	a3,0x4
ffffffffc0203cd4:	e9068693          	addi	a3,a3,-368 # ffffffffc0207b60 <commands+0x13b8>
ffffffffc0203cd8:	00003617          	auipc	a2,0x3
ffffffffc0203cdc:	f5060613          	addi	a2,a2,-176 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203ce0:	0cc00593          	li	a1,204
ffffffffc0203ce4:	00004517          	auipc	a0,0x4
ffffffffc0203ce8:	00c50513          	addi	a0,a0,12 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203cec:	d2afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(vma != NULL);
ffffffffc0203cf0:	00004697          	auipc	a3,0x4
ffffffffc0203cf4:	f1068693          	addi	a3,a3,-240 # ffffffffc0207c00 <commands+0x1458>
ffffffffc0203cf8:	00003617          	auipc	a2,0x3
ffffffffc0203cfc:	f3060613          	addi	a2,a2,-208 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203d00:	0cf00593          	li	a1,207
ffffffffc0203d04:	00004517          	auipc	a0,0x4
ffffffffc0203d08:	fec50513          	addi	a0,a0,-20 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203d0c:	d0afc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(temp_ptep!= NULL);
ffffffffc0203d10:	00004697          	auipc	a3,0x4
ffffffffc0203d14:	0b068693          	addi	a3,a3,176 # ffffffffc0207dc0 <commands+0x1618>
ffffffffc0203d18:	00003617          	auipc	a2,0x3
ffffffffc0203d1c:	f1060613          	addi	a2,a2,-240 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203d20:	0d700593          	li	a1,215
ffffffffc0203d24:	00004517          	auipc	a0,0x4
ffffffffc0203d28:	fcc50513          	addi	a0,a0,-52 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203d2c:	ceafc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert( nr_free == 0);         
ffffffffc0203d30:	00004697          	auipc	a3,0x4
ffffffffc0203d34:	18868693          	addi	a3,a3,392 # ffffffffc0207eb8 <commands+0x1710>
ffffffffc0203d38:	00003617          	auipc	a2,0x3
ffffffffc0203d3c:	ef060613          	addi	a2,a2,-272 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203d40:	0f300593          	li	a1,243
ffffffffc0203d44:	00004517          	auipc	a0,0x4
ffffffffc0203d48:	fac50513          	addi	a0,a0,-84 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203d4c:	ccafc0ef          	jal	ra,ffffffffc0200216 <__panic>
    return KADDR(page2pa(page));
ffffffffc0203d50:	00003617          	auipc	a2,0x3
ffffffffc0203d54:	2c060613          	addi	a2,a2,704 # ffffffffc0207010 <commands+0x868>
ffffffffc0203d58:	06900593          	li	a1,105
ffffffffc0203d5c:	00003517          	auipc	a0,0x3
ffffffffc0203d60:	30c50513          	addi	a0,a0,780 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0203d64:	cb2fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(count==0);
ffffffffc0203d68:	00004697          	auipc	a3,0x4
ffffffffc0203d6c:	1d068693          	addi	a3,a3,464 # ffffffffc0207f38 <commands+0x1790>
ffffffffc0203d70:	00003617          	auipc	a2,0x3
ffffffffc0203d74:	eb860613          	addi	a2,a2,-328 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203d78:	11d00593          	li	a1,285
ffffffffc0203d7c:	00004517          	auipc	a0,0x4
ffffffffc0203d80:	f7450513          	addi	a0,a0,-140 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203d84:	c92fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(total==0);
ffffffffc0203d88:	00004697          	auipc	a3,0x4
ffffffffc0203d8c:	1c068693          	addi	a3,a3,448 # ffffffffc0207f48 <commands+0x17a0>
ffffffffc0203d90:	00003617          	auipc	a2,0x3
ffffffffc0203d94:	e9860613          	addi	a2,a2,-360 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203d98:	11e00593          	li	a1,286
ffffffffc0203d9c:	00004517          	auipc	a0,0x4
ffffffffc0203da0:	f5450513          	addi	a0,a0,-172 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203da4:	c72fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
ffffffffc0203da8:	00004697          	auipc	a3,0x4
ffffffffc0203dac:	09068693          	addi	a3,a3,144 # ffffffffc0207e38 <commands+0x1690>
ffffffffc0203db0:	00003617          	auipc	a2,0x3
ffffffffc0203db4:	e7860613          	addi	a2,a2,-392 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203db8:	0ea00593          	li	a1,234
ffffffffc0203dbc:	00004517          	auipc	a0,0x4
ffffffffc0203dc0:	f3450513          	addi	a0,a0,-204 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203dc4:	c52fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(mm != NULL);
ffffffffc0203dc8:	00004697          	auipc	a3,0x4
ffffffffc0203dcc:	c1068693          	addi	a3,a3,-1008 # ffffffffc02079d8 <commands+0x1230>
ffffffffc0203dd0:	00003617          	auipc	a2,0x3
ffffffffc0203dd4:	e5860613          	addi	a2,a2,-424 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203dd8:	0c400593          	li	a1,196
ffffffffc0203ddc:	00004517          	auipc	a0,0x4
ffffffffc0203de0:	f1450513          	addi	a0,a0,-236 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203de4:	c32fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(check_mm_struct == NULL);
ffffffffc0203de8:	00004697          	auipc	a3,0x4
ffffffffc0203dec:	f8868693          	addi	a3,a3,-120 # ffffffffc0207d70 <commands+0x15c8>
ffffffffc0203df0:	00003617          	auipc	a2,0x3
ffffffffc0203df4:	e3860613          	addi	a2,a2,-456 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203df8:	0c700593          	li	a1,199
ffffffffc0203dfc:	00004517          	auipc	a0,0x4
ffffffffc0203e00:	ef450513          	addi	a0,a0,-268 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203e04:	c12fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(ret==0);
ffffffffc0203e08:	00004697          	auipc	a3,0x4
ffffffffc0203e0c:	12868693          	addi	a3,a3,296 # ffffffffc0207f30 <commands+0x1788>
ffffffffc0203e10:	00003617          	auipc	a2,0x3
ffffffffc0203e14:	e1860613          	addi	a2,a2,-488 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203e18:	10200593          	li	a1,258
ffffffffc0203e1c:	00004517          	auipc	a0,0x4
ffffffffc0203e20:	ed450513          	addi	a0,a0,-300 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203e24:	bf2fc0ef          	jal	ra,ffffffffc0200216 <__panic>
     assert(total == nr_free_pages());
ffffffffc0203e28:	00004697          	auipc	a3,0x4
ffffffffc0203e2c:	f0068693          	addi	a3,a3,-256 # ffffffffc0207d28 <commands+0x1580>
ffffffffc0203e30:	00003617          	auipc	a2,0x3
ffffffffc0203e34:	df860613          	addi	a2,a2,-520 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203e38:	0bf00593          	li	a1,191
ffffffffc0203e3c:	00004517          	auipc	a0,0x4
ffffffffc0203e40:	eb450513          	addi	a0,a0,-332 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203e44:	bd2fc0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0203e48 <swap_init_mm>:
     return sm->init_mm(mm);
ffffffffc0203e48:	000a8797          	auipc	a5,0xa8
ffffffffc0203e4c:	6f878793          	addi	a5,a5,1784 # ffffffffc02ac540 <sm>
ffffffffc0203e50:	639c                	ld	a5,0(a5)
ffffffffc0203e52:	0107b303          	ld	t1,16(a5)
ffffffffc0203e56:	8302                	jr	t1

ffffffffc0203e58 <swap_map_swappable>:
     return sm->map_swappable(mm, addr, page, swap_in);
ffffffffc0203e58:	000a8797          	auipc	a5,0xa8
ffffffffc0203e5c:	6e878793          	addi	a5,a5,1768 # ffffffffc02ac540 <sm>
ffffffffc0203e60:	639c                	ld	a5,0(a5)
ffffffffc0203e62:	0207b303          	ld	t1,32(a5)
ffffffffc0203e66:	8302                	jr	t1

ffffffffc0203e68 <swap_out>:
{
ffffffffc0203e68:	711d                	addi	sp,sp,-96
ffffffffc0203e6a:	ec86                	sd	ra,88(sp)
ffffffffc0203e6c:	e8a2                	sd	s0,80(sp)
ffffffffc0203e6e:	e4a6                	sd	s1,72(sp)
ffffffffc0203e70:	e0ca                	sd	s2,64(sp)
ffffffffc0203e72:	fc4e                	sd	s3,56(sp)
ffffffffc0203e74:	f852                	sd	s4,48(sp)
ffffffffc0203e76:	f456                	sd	s5,40(sp)
ffffffffc0203e78:	f05a                	sd	s6,32(sp)
ffffffffc0203e7a:	ec5e                	sd	s7,24(sp)
ffffffffc0203e7c:	e862                	sd	s8,16(sp)
     for (i = 0; i != n; ++ i)
ffffffffc0203e7e:	cde9                	beqz	a1,ffffffffc0203f58 <swap_out+0xf0>
ffffffffc0203e80:	8ab2                	mv	s5,a2
ffffffffc0203e82:	892a                	mv	s2,a0
ffffffffc0203e84:	8a2e                	mv	s4,a1
ffffffffc0203e86:	4401                	li	s0,0
ffffffffc0203e88:	000a8997          	auipc	s3,0xa8
ffffffffc0203e8c:	6b898993          	addi	s3,s3,1720 # ffffffffc02ac540 <sm>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203e90:	00004b17          	auipc	s6,0x4
ffffffffc0203e94:	148b0b13          	addi	s6,s6,328 # ffffffffc0207fd8 <commands+0x1830>
                    cprintf("SWAP: failed to save\n");
ffffffffc0203e98:	00004b97          	auipc	s7,0x4
ffffffffc0203e9c:	128b8b93          	addi	s7,s7,296 # ffffffffc0207fc0 <commands+0x1818>
ffffffffc0203ea0:	a825                	j	ffffffffc0203ed8 <swap_out+0x70>
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203ea2:	67a2                	ld	a5,8(sp)
ffffffffc0203ea4:	8626                	mv	a2,s1
ffffffffc0203ea6:	85a2                	mv	a1,s0
ffffffffc0203ea8:	7f94                	ld	a3,56(a5)
ffffffffc0203eaa:	855a                	mv	a0,s6
     for (i = 0; i != n; ++ i)
ffffffffc0203eac:	2405                	addiw	s0,s0,1
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
ffffffffc0203eae:	82b1                	srli	a3,a3,0xc
ffffffffc0203eb0:	0685                	addi	a3,a3,1
ffffffffc0203eb2:	a1efc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0203eb6:	6522                	ld	a0,8(sp)
                    free_page(page);
ffffffffc0203eb8:	4585                	li	a1,1
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
ffffffffc0203eba:	7d1c                	ld	a5,56(a0)
ffffffffc0203ebc:	83b1                	srli	a5,a5,0xc
ffffffffc0203ebe:	0785                	addi	a5,a5,1
ffffffffc0203ec0:	07a2                	slli	a5,a5,0x8
ffffffffc0203ec2:	00fc3023          	sd	a5,0(s8)
                    free_page(page);
ffffffffc0203ec6:	834fd0ef          	jal	ra,ffffffffc0200efa <free_pages>
          tlb_invalidate(mm->pgdir, v);
ffffffffc0203eca:	01893503          	ld	a0,24(s2)
ffffffffc0203ece:	85a6                	mv	a1,s1
ffffffffc0203ed0:	c42fe0ef          	jal	ra,ffffffffc0202312 <tlb_invalidate>
     for (i = 0; i != n; ++ i)
ffffffffc0203ed4:	048a0d63          	beq	s4,s0,ffffffffc0203f2e <swap_out+0xc6>
          int r = sm->swap_out_victim(mm, &page, in_tick);
ffffffffc0203ed8:	0009b783          	ld	a5,0(s3)
ffffffffc0203edc:	8656                	mv	a2,s5
ffffffffc0203ede:	002c                	addi	a1,sp,8
ffffffffc0203ee0:	7b9c                	ld	a5,48(a5)
ffffffffc0203ee2:	854a                	mv	a0,s2
ffffffffc0203ee4:	9782                	jalr	a5
          if (r != 0) {
ffffffffc0203ee6:	e12d                	bnez	a0,ffffffffc0203f48 <swap_out+0xe0>
          v=page->pra_vaddr; 
ffffffffc0203ee8:	67a2                	ld	a5,8(sp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203eea:	01893503          	ld	a0,24(s2)
ffffffffc0203eee:	4601                	li	a2,0
          v=page->pra_vaddr; 
ffffffffc0203ef0:	7f84                	ld	s1,56(a5)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203ef2:	85a6                	mv	a1,s1
ffffffffc0203ef4:	88cfd0ef          	jal	ra,ffffffffc0200f80 <get_pte>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203ef8:	611c                	ld	a5,0(a0)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
ffffffffc0203efa:	8c2a                	mv	s8,a0
          assert((*ptep & PTE_V) != 0);
ffffffffc0203efc:	8b85                	andi	a5,a5,1
ffffffffc0203efe:	cfb9                	beqz	a5,ffffffffc0203f5c <swap_out+0xf4>
          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
ffffffffc0203f00:	65a2                	ld	a1,8(sp)
ffffffffc0203f02:	7d9c                	ld	a5,56(a1)
ffffffffc0203f04:	83b1                	srli	a5,a5,0xc
ffffffffc0203f06:	00178513          	addi	a0,a5,1
ffffffffc0203f0a:	0522                	slli	a0,a0,0x8
ffffffffc0203f0c:	509000ef          	jal	ra,ffffffffc0204c14 <swapfs_write>
ffffffffc0203f10:	d949                	beqz	a0,ffffffffc0203ea2 <swap_out+0x3a>
                    cprintf("SWAP: failed to save\n");
ffffffffc0203f12:	855e                	mv	a0,s7
ffffffffc0203f14:	9bcfc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203f18:	0009b783          	ld	a5,0(s3)
ffffffffc0203f1c:	6622                	ld	a2,8(sp)
ffffffffc0203f1e:	4681                	li	a3,0
ffffffffc0203f20:	739c                	ld	a5,32(a5)
ffffffffc0203f22:	85a6                	mv	a1,s1
ffffffffc0203f24:	854a                	mv	a0,s2
     for (i = 0; i != n; ++ i)
ffffffffc0203f26:	2405                	addiw	s0,s0,1
                    sm->map_swappable(mm, v, page, 0);
ffffffffc0203f28:	9782                	jalr	a5
     for (i = 0; i != n; ++ i)
ffffffffc0203f2a:	fa8a17e3          	bne	s4,s0,ffffffffc0203ed8 <swap_out+0x70>
}
ffffffffc0203f2e:	8522                	mv	a0,s0
ffffffffc0203f30:	60e6                	ld	ra,88(sp)
ffffffffc0203f32:	6446                	ld	s0,80(sp)
ffffffffc0203f34:	64a6                	ld	s1,72(sp)
ffffffffc0203f36:	6906                	ld	s2,64(sp)
ffffffffc0203f38:	79e2                	ld	s3,56(sp)
ffffffffc0203f3a:	7a42                	ld	s4,48(sp)
ffffffffc0203f3c:	7aa2                	ld	s5,40(sp)
ffffffffc0203f3e:	7b02                	ld	s6,32(sp)
ffffffffc0203f40:	6be2                	ld	s7,24(sp)
ffffffffc0203f42:	6c42                	ld	s8,16(sp)
ffffffffc0203f44:	6125                	addi	sp,sp,96
ffffffffc0203f46:	8082                	ret
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
ffffffffc0203f48:	85a2                	mv	a1,s0
ffffffffc0203f4a:	00004517          	auipc	a0,0x4
ffffffffc0203f4e:	02e50513          	addi	a0,a0,46 # ffffffffc0207f78 <commands+0x17d0>
ffffffffc0203f52:	97efc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
                  break;
ffffffffc0203f56:	bfe1                	j	ffffffffc0203f2e <swap_out+0xc6>
     for (i = 0; i != n; ++ i)
ffffffffc0203f58:	4401                	li	s0,0
ffffffffc0203f5a:	bfd1                	j	ffffffffc0203f2e <swap_out+0xc6>
          assert((*ptep & PTE_V) != 0);
ffffffffc0203f5c:	00004697          	auipc	a3,0x4
ffffffffc0203f60:	04c68693          	addi	a3,a3,76 # ffffffffc0207fa8 <commands+0x1800>
ffffffffc0203f64:	00003617          	auipc	a2,0x3
ffffffffc0203f68:	cc460613          	addi	a2,a2,-828 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203f6c:	06800593          	li	a1,104
ffffffffc0203f70:	00004517          	auipc	a0,0x4
ffffffffc0203f74:	d8050513          	addi	a0,a0,-640 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203f78:	a9efc0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0203f7c <swap_in>:
{
ffffffffc0203f7c:	7179                	addi	sp,sp,-48
ffffffffc0203f7e:	e84a                	sd	s2,16(sp)
ffffffffc0203f80:	892a                	mv	s2,a0
     struct Page *result = alloc_page();
ffffffffc0203f82:	4505                	li	a0,1
{
ffffffffc0203f84:	ec26                	sd	s1,24(sp)
ffffffffc0203f86:	e44e                	sd	s3,8(sp)
ffffffffc0203f88:	f406                	sd	ra,40(sp)
ffffffffc0203f8a:	f022                	sd	s0,32(sp)
ffffffffc0203f8c:	84ae                	mv	s1,a1
ffffffffc0203f8e:	89b2                	mv	s3,a2
     struct Page *result = alloc_page();
ffffffffc0203f90:	ee3fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
     assert(result!=NULL);
ffffffffc0203f94:	c129                	beqz	a0,ffffffffc0203fd6 <swap_in+0x5a>
     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
ffffffffc0203f96:	842a                	mv	s0,a0
ffffffffc0203f98:	01893503          	ld	a0,24(s2)
ffffffffc0203f9c:	4601                	li	a2,0
ffffffffc0203f9e:	85a6                	mv	a1,s1
ffffffffc0203fa0:	fe1fc0ef          	jal	ra,ffffffffc0200f80 <get_pte>
ffffffffc0203fa4:	892a                	mv	s2,a0
     if ((r = swapfs_read((*ptep), result)) != 0)
ffffffffc0203fa6:	6108                	ld	a0,0(a0)
ffffffffc0203fa8:	85a2                	mv	a1,s0
ffffffffc0203faa:	3d3000ef          	jal	ra,ffffffffc0204b7c <swapfs_read>
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
ffffffffc0203fae:	00093583          	ld	a1,0(s2)
ffffffffc0203fb2:	8626                	mv	a2,s1
ffffffffc0203fb4:	00004517          	auipc	a0,0x4
ffffffffc0203fb8:	cdc50513          	addi	a0,a0,-804 # ffffffffc0207c90 <commands+0x14e8>
ffffffffc0203fbc:	81a1                	srli	a1,a1,0x8
ffffffffc0203fbe:	912fc0ef          	jal	ra,ffffffffc02000d0 <cprintf>
}
ffffffffc0203fc2:	70a2                	ld	ra,40(sp)
     *ptr_result=result;
ffffffffc0203fc4:	0089b023          	sd	s0,0(s3)
}
ffffffffc0203fc8:	7402                	ld	s0,32(sp)
ffffffffc0203fca:	64e2                	ld	s1,24(sp)
ffffffffc0203fcc:	6942                	ld	s2,16(sp)
ffffffffc0203fce:	69a2                	ld	s3,8(sp)
ffffffffc0203fd0:	4501                	li	a0,0
ffffffffc0203fd2:	6145                	addi	sp,sp,48
ffffffffc0203fd4:	8082                	ret
     assert(result!=NULL);
ffffffffc0203fd6:	00004697          	auipc	a3,0x4
ffffffffc0203fda:	caa68693          	addi	a3,a3,-854 # ffffffffc0207c80 <commands+0x14d8>
ffffffffc0203fde:	00003617          	auipc	a2,0x3
ffffffffc0203fe2:	c4a60613          	addi	a2,a2,-950 # ffffffffc0206c28 <commands+0x480>
ffffffffc0203fe6:	07e00593          	li	a1,126
ffffffffc0203fea:	00004517          	auipc	a0,0x4
ffffffffc0203fee:	d0650513          	addi	a0,a0,-762 # ffffffffc0207cf0 <commands+0x1548>
ffffffffc0203ff2:	a24fc0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0203ff6 <default_init>:
    elm->prev = elm->next = elm;
ffffffffc0203ff6:	000a8797          	auipc	a5,0xa8
ffffffffc0203ffa:	68278793          	addi	a5,a5,1666 # ffffffffc02ac678 <free_area>
ffffffffc0203ffe:	e79c                	sd	a5,8(a5)
ffffffffc0204000:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0204002:	0007a823          	sw	zero,16(a5)
}
ffffffffc0204006:	8082                	ret

ffffffffc0204008 <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0204008:	000a8517          	auipc	a0,0xa8
ffffffffc020400c:	68056503          	lwu	a0,1664(a0) # ffffffffc02ac688 <free_area+0x10>
ffffffffc0204010:	8082                	ret

ffffffffc0204012 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0204012:	715d                	addi	sp,sp,-80
ffffffffc0204014:	f84a                	sd	s2,48(sp)
    return listelm->next;
ffffffffc0204016:	000a8917          	auipc	s2,0xa8
ffffffffc020401a:	66290913          	addi	s2,s2,1634 # ffffffffc02ac678 <free_area>
ffffffffc020401e:	00893783          	ld	a5,8(s2)
ffffffffc0204022:	e486                	sd	ra,72(sp)
ffffffffc0204024:	e0a2                	sd	s0,64(sp)
ffffffffc0204026:	fc26                	sd	s1,56(sp)
ffffffffc0204028:	f44e                	sd	s3,40(sp)
ffffffffc020402a:	f052                	sd	s4,32(sp)
ffffffffc020402c:	ec56                	sd	s5,24(sp)
ffffffffc020402e:	e85a                	sd	s6,16(sp)
ffffffffc0204030:	e45e                	sd	s7,8(sp)
ffffffffc0204032:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0204034:	31278463          	beq	a5,s2,ffffffffc020433c <default_check+0x32a>
ffffffffc0204038:	ff07b703          	ld	a4,-16(a5)
ffffffffc020403c:	8305                	srli	a4,a4,0x1
ffffffffc020403e:	8b05                	andi	a4,a4,1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0204040:	30070263          	beqz	a4,ffffffffc0204344 <default_check+0x332>
    int count = 0, total = 0;
ffffffffc0204044:	4401                	li	s0,0
ffffffffc0204046:	4481                	li	s1,0
ffffffffc0204048:	a031                	j	ffffffffc0204054 <default_check+0x42>
ffffffffc020404a:	ff07b703          	ld	a4,-16(a5)
        assert(PageProperty(p));
ffffffffc020404e:	8b09                	andi	a4,a4,2
ffffffffc0204050:	2e070a63          	beqz	a4,ffffffffc0204344 <default_check+0x332>
        count ++, total += p->property;
ffffffffc0204054:	ff87a703          	lw	a4,-8(a5)
ffffffffc0204058:	679c                	ld	a5,8(a5)
ffffffffc020405a:	2485                	addiw	s1,s1,1
ffffffffc020405c:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc020405e:	ff2796e3          	bne	a5,s2,ffffffffc020404a <default_check+0x38>
ffffffffc0204062:	89a2                	mv	s3,s0
    }
    assert(total == nr_free_pages());
ffffffffc0204064:	eddfc0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
ffffffffc0204068:	73351e63          	bne	a0,s3,ffffffffc02047a4 <default_check+0x792>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020406c:	4505                	li	a0,1
ffffffffc020406e:	e05fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204072:	8a2a                	mv	s4,a0
ffffffffc0204074:	46050863          	beqz	a0,ffffffffc02044e4 <default_check+0x4d2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0204078:	4505                	li	a0,1
ffffffffc020407a:	df9fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020407e:	89aa                	mv	s3,a0
ffffffffc0204080:	74050263          	beqz	a0,ffffffffc02047c4 <default_check+0x7b2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0204084:	4505                	li	a0,1
ffffffffc0204086:	dedfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020408a:	8aaa                	mv	s5,a0
ffffffffc020408c:	4c050c63          	beqz	a0,ffffffffc0204564 <default_check+0x552>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0204090:	2d3a0a63          	beq	s4,s3,ffffffffc0204364 <default_check+0x352>
ffffffffc0204094:	2caa0863          	beq	s4,a0,ffffffffc0204364 <default_check+0x352>
ffffffffc0204098:	2ca98663          	beq	s3,a0,ffffffffc0204364 <default_check+0x352>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020409c:	000a2783          	lw	a5,0(s4)
ffffffffc02040a0:	2e079263          	bnez	a5,ffffffffc0204384 <default_check+0x372>
ffffffffc02040a4:	0009a783          	lw	a5,0(s3)
ffffffffc02040a8:	2c079e63          	bnez	a5,ffffffffc0204384 <default_check+0x372>
ffffffffc02040ac:	411c                	lw	a5,0(a0)
ffffffffc02040ae:	2c079b63          	bnez	a5,ffffffffc0204384 <default_check+0x372>
    return page - pages + nbase;
ffffffffc02040b2:	000a8797          	auipc	a5,0xa8
ffffffffc02040b6:	4de78793          	addi	a5,a5,1246 # ffffffffc02ac590 <pages>
ffffffffc02040ba:	639c                	ld	a5,0(a5)
ffffffffc02040bc:	00005717          	auipc	a4,0x5
ffffffffc02040c0:	c7470713          	addi	a4,a4,-908 # ffffffffc0208d30 <nbase>
ffffffffc02040c4:	6310                	ld	a2,0(a4)
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02040c6:	000a8717          	auipc	a4,0xa8
ffffffffc02040ca:	46270713          	addi	a4,a4,1122 # ffffffffc02ac528 <npage>
ffffffffc02040ce:	6314                	ld	a3,0(a4)
ffffffffc02040d0:	40fa0733          	sub	a4,s4,a5
ffffffffc02040d4:	8719                	srai	a4,a4,0x6
ffffffffc02040d6:	9732                	add	a4,a4,a2
ffffffffc02040d8:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02040da:	0732                	slli	a4,a4,0xc
ffffffffc02040dc:	2cd77463          	bleu	a3,a4,ffffffffc02043a4 <default_check+0x392>
    return page - pages + nbase;
ffffffffc02040e0:	40f98733          	sub	a4,s3,a5
ffffffffc02040e4:	8719                	srai	a4,a4,0x6
ffffffffc02040e6:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02040e8:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02040ea:	4ed77d63          	bleu	a3,a4,ffffffffc02045e4 <default_check+0x5d2>
    return page - pages + nbase;
ffffffffc02040ee:	40f507b3          	sub	a5,a0,a5
ffffffffc02040f2:	8799                	srai	a5,a5,0x6
ffffffffc02040f4:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02040f6:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02040f8:	34d7f663          	bleu	a3,a5,ffffffffc0204444 <default_check+0x432>
    assert(alloc_page() == NULL);
ffffffffc02040fc:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02040fe:	00093c03          	ld	s8,0(s2)
ffffffffc0204102:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0204106:	01092b03          	lw	s6,16(s2)
    elm->prev = elm->next = elm;
ffffffffc020410a:	000a8797          	auipc	a5,0xa8
ffffffffc020410e:	5727bb23          	sd	s2,1398(a5) # ffffffffc02ac680 <free_area+0x8>
ffffffffc0204112:	000a8797          	auipc	a5,0xa8
ffffffffc0204116:	5727b323          	sd	s2,1382(a5) # ffffffffc02ac678 <free_area>
    nr_free = 0;
ffffffffc020411a:	000a8797          	auipc	a5,0xa8
ffffffffc020411e:	5607a723          	sw	zero,1390(a5) # ffffffffc02ac688 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0204122:	d51fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204126:	2e051f63          	bnez	a0,ffffffffc0204424 <default_check+0x412>
    free_page(p0);
ffffffffc020412a:	4585                	li	a1,1
ffffffffc020412c:	8552                	mv	a0,s4
ffffffffc020412e:	dcdfc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    free_page(p1);
ffffffffc0204132:	4585                	li	a1,1
ffffffffc0204134:	854e                	mv	a0,s3
ffffffffc0204136:	dc5fc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    free_page(p2);
ffffffffc020413a:	4585                	li	a1,1
ffffffffc020413c:	8556                	mv	a0,s5
ffffffffc020413e:	dbdfc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    assert(nr_free == 3);
ffffffffc0204142:	01092703          	lw	a4,16(s2)
ffffffffc0204146:	478d                	li	a5,3
ffffffffc0204148:	2af71e63          	bne	a4,a5,ffffffffc0204404 <default_check+0x3f2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020414c:	4505                	li	a0,1
ffffffffc020414e:	d25fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204152:	89aa                	mv	s3,a0
ffffffffc0204154:	28050863          	beqz	a0,ffffffffc02043e4 <default_check+0x3d2>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0204158:	4505                	li	a0,1
ffffffffc020415a:	d19fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020415e:	8aaa                	mv	s5,a0
ffffffffc0204160:	3e050263          	beqz	a0,ffffffffc0204544 <default_check+0x532>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0204164:	4505                	li	a0,1
ffffffffc0204166:	d0dfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020416a:	8a2a                	mv	s4,a0
ffffffffc020416c:	3a050c63          	beqz	a0,ffffffffc0204524 <default_check+0x512>
    assert(alloc_page() == NULL);
ffffffffc0204170:	4505                	li	a0,1
ffffffffc0204172:	d01fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204176:	38051763          	bnez	a0,ffffffffc0204504 <default_check+0x4f2>
    free_page(p0);
ffffffffc020417a:	4585                	li	a1,1
ffffffffc020417c:	854e                	mv	a0,s3
ffffffffc020417e:	d7dfc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0204182:	00893783          	ld	a5,8(s2)
ffffffffc0204186:	23278f63          	beq	a5,s2,ffffffffc02043c4 <default_check+0x3b2>
    assert((p = alloc_page()) == p0);
ffffffffc020418a:	4505                	li	a0,1
ffffffffc020418c:	ce7fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204190:	32a99a63          	bne	s3,a0,ffffffffc02044c4 <default_check+0x4b2>
    assert(alloc_page() == NULL);
ffffffffc0204194:	4505                	li	a0,1
ffffffffc0204196:	cddfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020419a:	30051563          	bnez	a0,ffffffffc02044a4 <default_check+0x492>
    assert(nr_free == 0);
ffffffffc020419e:	01092783          	lw	a5,16(s2)
ffffffffc02041a2:	2e079163          	bnez	a5,ffffffffc0204484 <default_check+0x472>
    free_page(p);
ffffffffc02041a6:	854e                	mv	a0,s3
ffffffffc02041a8:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02041aa:	000a8797          	auipc	a5,0xa8
ffffffffc02041ae:	4d87b723          	sd	s8,1230(a5) # ffffffffc02ac678 <free_area>
ffffffffc02041b2:	000a8797          	auipc	a5,0xa8
ffffffffc02041b6:	4d77b723          	sd	s7,1230(a5) # ffffffffc02ac680 <free_area+0x8>
    nr_free = nr_free_store;
ffffffffc02041ba:	000a8797          	auipc	a5,0xa8
ffffffffc02041be:	4d67a723          	sw	s6,1230(a5) # ffffffffc02ac688 <free_area+0x10>
    free_page(p);
ffffffffc02041c2:	d39fc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    free_page(p1);
ffffffffc02041c6:	4585                	li	a1,1
ffffffffc02041c8:	8556                	mv	a0,s5
ffffffffc02041ca:	d31fc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    free_page(p2);
ffffffffc02041ce:	4585                	li	a1,1
ffffffffc02041d0:	8552                	mv	a0,s4
ffffffffc02041d2:	d29fc0ef          	jal	ra,ffffffffc0200efa <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02041d6:	4515                	li	a0,5
ffffffffc02041d8:	c9bfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02041dc:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02041de:	28050363          	beqz	a0,ffffffffc0204464 <default_check+0x452>
ffffffffc02041e2:	651c                	ld	a5,8(a0)
ffffffffc02041e4:	8385                	srli	a5,a5,0x1
ffffffffc02041e6:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02041e8:	54079e63          	bnez	a5,ffffffffc0204744 <default_check+0x732>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02041ec:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02041ee:	00093b03          	ld	s6,0(s2)
ffffffffc02041f2:	00893a83          	ld	s5,8(s2)
ffffffffc02041f6:	000a8797          	auipc	a5,0xa8
ffffffffc02041fa:	4927b123          	sd	s2,1154(a5) # ffffffffc02ac678 <free_area>
ffffffffc02041fe:	000a8797          	auipc	a5,0xa8
ffffffffc0204202:	4927b123          	sd	s2,1154(a5) # ffffffffc02ac680 <free_area+0x8>
    assert(alloc_page() == NULL);
ffffffffc0204206:	c6dfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020420a:	50051d63          	bnez	a0,ffffffffc0204724 <default_check+0x712>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020420e:	08098a13          	addi	s4,s3,128
ffffffffc0204212:	8552                	mv	a0,s4
ffffffffc0204214:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0204216:	01092b83          	lw	s7,16(s2)
    nr_free = 0;
ffffffffc020421a:	000a8797          	auipc	a5,0xa8
ffffffffc020421e:	4607a723          	sw	zero,1134(a5) # ffffffffc02ac688 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0204222:	cd9fc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0204226:	4511                	li	a0,4
ffffffffc0204228:	c4bfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020422c:	4c051c63          	bnez	a0,ffffffffc0204704 <default_check+0x6f2>
ffffffffc0204230:	0889b783          	ld	a5,136(s3)
ffffffffc0204234:	8385                	srli	a5,a5,0x1
ffffffffc0204236:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0204238:	4a078663          	beqz	a5,ffffffffc02046e4 <default_check+0x6d2>
ffffffffc020423c:	0909a703          	lw	a4,144(s3)
ffffffffc0204240:	478d                	li	a5,3
ffffffffc0204242:	4af71163          	bne	a4,a5,ffffffffc02046e4 <default_check+0x6d2>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0204246:	450d                	li	a0,3
ffffffffc0204248:	c2bfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc020424c:	8c2a                	mv	s8,a0
ffffffffc020424e:	46050b63          	beqz	a0,ffffffffc02046c4 <default_check+0x6b2>
    assert(alloc_page() == NULL);
ffffffffc0204252:	4505                	li	a0,1
ffffffffc0204254:	c1ffc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204258:	44051663          	bnez	a0,ffffffffc02046a4 <default_check+0x692>
    assert(p0 + 2 == p1);
ffffffffc020425c:	438a1463          	bne	s4,s8,ffffffffc0204684 <default_check+0x672>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0204260:	4585                	li	a1,1
ffffffffc0204262:	854e                	mv	a0,s3
ffffffffc0204264:	c97fc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    free_pages(p1, 3);
ffffffffc0204268:	458d                	li	a1,3
ffffffffc020426a:	8552                	mv	a0,s4
ffffffffc020426c:	c8ffc0ef          	jal	ra,ffffffffc0200efa <free_pages>
ffffffffc0204270:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0204274:	04098c13          	addi	s8,s3,64
ffffffffc0204278:	8385                	srli	a5,a5,0x1
ffffffffc020427a:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020427c:	3e078463          	beqz	a5,ffffffffc0204664 <default_check+0x652>
ffffffffc0204280:	0109a703          	lw	a4,16(s3)
ffffffffc0204284:	4785                	li	a5,1
ffffffffc0204286:	3cf71f63          	bne	a4,a5,ffffffffc0204664 <default_check+0x652>
ffffffffc020428a:	008a3783          	ld	a5,8(s4)
ffffffffc020428e:	8385                	srli	a5,a5,0x1
ffffffffc0204290:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0204292:	3a078963          	beqz	a5,ffffffffc0204644 <default_check+0x632>
ffffffffc0204296:	010a2703          	lw	a4,16(s4)
ffffffffc020429a:	478d                	li	a5,3
ffffffffc020429c:	3af71463          	bne	a4,a5,ffffffffc0204644 <default_check+0x632>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02042a0:	4505                	li	a0,1
ffffffffc02042a2:	bd1fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02042a6:	36a99f63          	bne	s3,a0,ffffffffc0204624 <default_check+0x612>
    free_page(p0);
ffffffffc02042aa:	4585                	li	a1,1
ffffffffc02042ac:	c4ffc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02042b0:	4509                	li	a0,2
ffffffffc02042b2:	bc1fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02042b6:	34aa1763          	bne	s4,a0,ffffffffc0204604 <default_check+0x5f2>

    free_pages(p0, 2);
ffffffffc02042ba:	4589                	li	a1,2
ffffffffc02042bc:	c3ffc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    free_page(p2);
ffffffffc02042c0:	4585                	li	a1,1
ffffffffc02042c2:	8562                	mv	a0,s8
ffffffffc02042c4:	c37fc0ef          	jal	ra,ffffffffc0200efa <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02042c8:	4515                	li	a0,5
ffffffffc02042ca:	ba9fc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02042ce:	89aa                	mv	s3,a0
ffffffffc02042d0:	48050a63          	beqz	a0,ffffffffc0204764 <default_check+0x752>
    assert(alloc_page() == NULL);
ffffffffc02042d4:	4505                	li	a0,1
ffffffffc02042d6:	b9dfc0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc02042da:	2e051563          	bnez	a0,ffffffffc02045c4 <default_check+0x5b2>

    assert(nr_free == 0);
ffffffffc02042de:	01092783          	lw	a5,16(s2)
ffffffffc02042e2:	2c079163          	bnez	a5,ffffffffc02045a4 <default_check+0x592>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02042e6:	4595                	li	a1,5
ffffffffc02042e8:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02042ea:	000a8797          	auipc	a5,0xa8
ffffffffc02042ee:	3977af23          	sw	s7,926(a5) # ffffffffc02ac688 <free_area+0x10>
    free_list = free_list_store;
ffffffffc02042f2:	000a8797          	auipc	a5,0xa8
ffffffffc02042f6:	3967b323          	sd	s6,902(a5) # ffffffffc02ac678 <free_area>
ffffffffc02042fa:	000a8797          	auipc	a5,0xa8
ffffffffc02042fe:	3957b323          	sd	s5,902(a5) # ffffffffc02ac680 <free_area+0x8>
    free_pages(p0, 5);
ffffffffc0204302:	bf9fc0ef          	jal	ra,ffffffffc0200efa <free_pages>
    return listelm->next;
ffffffffc0204306:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc020430a:	01278963          	beq	a5,s2,ffffffffc020431c <default_check+0x30a>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc020430e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0204312:	679c                	ld	a5,8(a5)
ffffffffc0204314:	34fd                	addiw	s1,s1,-1
ffffffffc0204316:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0204318:	ff279be3          	bne	a5,s2,ffffffffc020430e <default_check+0x2fc>
    }
    assert(count == 0);
ffffffffc020431c:	26049463          	bnez	s1,ffffffffc0204584 <default_check+0x572>
    assert(total == 0);
ffffffffc0204320:	46041263          	bnez	s0,ffffffffc0204784 <default_check+0x772>
}
ffffffffc0204324:	60a6                	ld	ra,72(sp)
ffffffffc0204326:	6406                	ld	s0,64(sp)
ffffffffc0204328:	74e2                	ld	s1,56(sp)
ffffffffc020432a:	7942                	ld	s2,48(sp)
ffffffffc020432c:	79a2                	ld	s3,40(sp)
ffffffffc020432e:	7a02                	ld	s4,32(sp)
ffffffffc0204330:	6ae2                	ld	s5,24(sp)
ffffffffc0204332:	6b42                	ld	s6,16(sp)
ffffffffc0204334:	6ba2                	ld	s7,8(sp)
ffffffffc0204336:	6c02                	ld	s8,0(sp)
ffffffffc0204338:	6161                	addi	sp,sp,80
ffffffffc020433a:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc020433c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020433e:	4401                	li	s0,0
ffffffffc0204340:	4481                	li	s1,0
ffffffffc0204342:	b30d                	j	ffffffffc0204064 <default_check+0x52>
        assert(PageProperty(p));
ffffffffc0204344:	00004697          	auipc	a3,0x4
ffffffffc0204348:	9d468693          	addi	a3,a3,-1580 # ffffffffc0207d18 <commands+0x1570>
ffffffffc020434c:	00003617          	auipc	a2,0x3
ffffffffc0204350:	8dc60613          	addi	a2,a2,-1828 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204354:	0f000593          	li	a1,240
ffffffffc0204358:	00004517          	auipc	a0,0x4
ffffffffc020435c:	cc050513          	addi	a0,a0,-832 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204360:	eb7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0204364:	00004697          	auipc	a3,0x4
ffffffffc0204368:	d2c68693          	addi	a3,a3,-724 # ffffffffc0208090 <commands+0x18e8>
ffffffffc020436c:	00003617          	auipc	a2,0x3
ffffffffc0204370:	8bc60613          	addi	a2,a2,-1860 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204374:	0bd00593          	li	a1,189
ffffffffc0204378:	00004517          	auipc	a0,0x4
ffffffffc020437c:	ca050513          	addi	a0,a0,-864 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204380:	e97fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0204384:	00004697          	auipc	a3,0x4
ffffffffc0204388:	d3468693          	addi	a3,a3,-716 # ffffffffc02080b8 <commands+0x1910>
ffffffffc020438c:	00003617          	auipc	a2,0x3
ffffffffc0204390:	89c60613          	addi	a2,a2,-1892 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204394:	0be00593          	li	a1,190
ffffffffc0204398:	00004517          	auipc	a0,0x4
ffffffffc020439c:	c8050513          	addi	a0,a0,-896 # ffffffffc0208018 <commands+0x1870>
ffffffffc02043a0:	e77fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02043a4:	00004697          	auipc	a3,0x4
ffffffffc02043a8:	d5468693          	addi	a3,a3,-684 # ffffffffc02080f8 <commands+0x1950>
ffffffffc02043ac:	00003617          	auipc	a2,0x3
ffffffffc02043b0:	87c60613          	addi	a2,a2,-1924 # ffffffffc0206c28 <commands+0x480>
ffffffffc02043b4:	0c000593          	li	a1,192
ffffffffc02043b8:	00004517          	auipc	a0,0x4
ffffffffc02043bc:	c6050513          	addi	a0,a0,-928 # ffffffffc0208018 <commands+0x1870>
ffffffffc02043c0:	e57fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02043c4:	00004697          	auipc	a3,0x4
ffffffffc02043c8:	dbc68693          	addi	a3,a3,-580 # ffffffffc0208180 <commands+0x19d8>
ffffffffc02043cc:	00003617          	auipc	a2,0x3
ffffffffc02043d0:	85c60613          	addi	a2,a2,-1956 # ffffffffc0206c28 <commands+0x480>
ffffffffc02043d4:	0d900593          	li	a1,217
ffffffffc02043d8:	00004517          	auipc	a0,0x4
ffffffffc02043dc:	c4050513          	addi	a0,a0,-960 # ffffffffc0208018 <commands+0x1870>
ffffffffc02043e0:	e37fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02043e4:	00004697          	auipc	a3,0x4
ffffffffc02043e8:	c4c68693          	addi	a3,a3,-948 # ffffffffc0208030 <commands+0x1888>
ffffffffc02043ec:	00003617          	auipc	a2,0x3
ffffffffc02043f0:	83c60613          	addi	a2,a2,-1988 # ffffffffc0206c28 <commands+0x480>
ffffffffc02043f4:	0d200593          	li	a1,210
ffffffffc02043f8:	00004517          	auipc	a0,0x4
ffffffffc02043fc:	c2050513          	addi	a0,a0,-992 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204400:	e17fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_free == 3);
ffffffffc0204404:	00004697          	auipc	a3,0x4
ffffffffc0204408:	d6c68693          	addi	a3,a3,-660 # ffffffffc0208170 <commands+0x19c8>
ffffffffc020440c:	00003617          	auipc	a2,0x3
ffffffffc0204410:	81c60613          	addi	a2,a2,-2020 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204414:	0d000593          	li	a1,208
ffffffffc0204418:	00004517          	auipc	a0,0x4
ffffffffc020441c:	c0050513          	addi	a0,a0,-1024 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204420:	df7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0204424:	00004697          	auipc	a3,0x4
ffffffffc0204428:	d3468693          	addi	a3,a3,-716 # ffffffffc0208158 <commands+0x19b0>
ffffffffc020442c:	00002617          	auipc	a2,0x2
ffffffffc0204430:	7fc60613          	addi	a2,a2,2044 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204434:	0cb00593          	li	a1,203
ffffffffc0204438:	00004517          	auipc	a0,0x4
ffffffffc020443c:	be050513          	addi	a0,a0,-1056 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204440:	dd7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0204444:	00004697          	auipc	a3,0x4
ffffffffc0204448:	cf468693          	addi	a3,a3,-780 # ffffffffc0208138 <commands+0x1990>
ffffffffc020444c:	00002617          	auipc	a2,0x2
ffffffffc0204450:	7dc60613          	addi	a2,a2,2012 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204454:	0c200593          	li	a1,194
ffffffffc0204458:	00004517          	auipc	a0,0x4
ffffffffc020445c:	bc050513          	addi	a0,a0,-1088 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204460:	db7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(p0 != NULL);
ffffffffc0204464:	00004697          	auipc	a3,0x4
ffffffffc0204468:	d5468693          	addi	a3,a3,-684 # ffffffffc02081b8 <commands+0x1a10>
ffffffffc020446c:	00002617          	auipc	a2,0x2
ffffffffc0204470:	7bc60613          	addi	a2,a2,1980 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204474:	0f800593          	li	a1,248
ffffffffc0204478:	00004517          	auipc	a0,0x4
ffffffffc020447c:	ba050513          	addi	a0,a0,-1120 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204480:	d97fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_free == 0);
ffffffffc0204484:	00004697          	auipc	a3,0x4
ffffffffc0204488:	a3468693          	addi	a3,a3,-1484 # ffffffffc0207eb8 <commands+0x1710>
ffffffffc020448c:	00002617          	auipc	a2,0x2
ffffffffc0204490:	79c60613          	addi	a2,a2,1948 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204494:	0df00593          	li	a1,223
ffffffffc0204498:	00004517          	auipc	a0,0x4
ffffffffc020449c:	b8050513          	addi	a0,a0,-1152 # ffffffffc0208018 <commands+0x1870>
ffffffffc02044a0:	d77fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02044a4:	00004697          	auipc	a3,0x4
ffffffffc02044a8:	cb468693          	addi	a3,a3,-844 # ffffffffc0208158 <commands+0x19b0>
ffffffffc02044ac:	00002617          	auipc	a2,0x2
ffffffffc02044b0:	77c60613          	addi	a2,a2,1916 # ffffffffc0206c28 <commands+0x480>
ffffffffc02044b4:	0dd00593          	li	a1,221
ffffffffc02044b8:	00004517          	auipc	a0,0x4
ffffffffc02044bc:	b6050513          	addi	a0,a0,-1184 # ffffffffc0208018 <commands+0x1870>
ffffffffc02044c0:	d57fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02044c4:	00004697          	auipc	a3,0x4
ffffffffc02044c8:	cd468693          	addi	a3,a3,-812 # ffffffffc0208198 <commands+0x19f0>
ffffffffc02044cc:	00002617          	auipc	a2,0x2
ffffffffc02044d0:	75c60613          	addi	a2,a2,1884 # ffffffffc0206c28 <commands+0x480>
ffffffffc02044d4:	0dc00593          	li	a1,220
ffffffffc02044d8:	00004517          	auipc	a0,0x4
ffffffffc02044dc:	b4050513          	addi	a0,a0,-1216 # ffffffffc0208018 <commands+0x1870>
ffffffffc02044e0:	d37fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02044e4:	00004697          	auipc	a3,0x4
ffffffffc02044e8:	b4c68693          	addi	a3,a3,-1204 # ffffffffc0208030 <commands+0x1888>
ffffffffc02044ec:	00002617          	auipc	a2,0x2
ffffffffc02044f0:	73c60613          	addi	a2,a2,1852 # ffffffffc0206c28 <commands+0x480>
ffffffffc02044f4:	0b900593          	li	a1,185
ffffffffc02044f8:	00004517          	auipc	a0,0x4
ffffffffc02044fc:	b2050513          	addi	a0,a0,-1248 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204500:	d17fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0204504:	00004697          	auipc	a3,0x4
ffffffffc0204508:	c5468693          	addi	a3,a3,-940 # ffffffffc0208158 <commands+0x19b0>
ffffffffc020450c:	00002617          	auipc	a2,0x2
ffffffffc0204510:	71c60613          	addi	a2,a2,1820 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204514:	0d600593          	li	a1,214
ffffffffc0204518:	00004517          	auipc	a0,0x4
ffffffffc020451c:	b0050513          	addi	a0,a0,-1280 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204520:	cf7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0204524:	00004697          	auipc	a3,0x4
ffffffffc0204528:	b4c68693          	addi	a3,a3,-1204 # ffffffffc0208070 <commands+0x18c8>
ffffffffc020452c:	00002617          	auipc	a2,0x2
ffffffffc0204530:	6fc60613          	addi	a2,a2,1788 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204534:	0d400593          	li	a1,212
ffffffffc0204538:	00004517          	auipc	a0,0x4
ffffffffc020453c:	ae050513          	addi	a0,a0,-1312 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204540:	cd7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0204544:	00004697          	auipc	a3,0x4
ffffffffc0204548:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0208050 <commands+0x18a8>
ffffffffc020454c:	00002617          	auipc	a2,0x2
ffffffffc0204550:	6dc60613          	addi	a2,a2,1756 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204554:	0d300593          	li	a1,211
ffffffffc0204558:	00004517          	auipc	a0,0x4
ffffffffc020455c:	ac050513          	addi	a0,a0,-1344 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204560:	cb7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0204564:	00004697          	auipc	a3,0x4
ffffffffc0204568:	b0c68693          	addi	a3,a3,-1268 # ffffffffc0208070 <commands+0x18c8>
ffffffffc020456c:	00002617          	auipc	a2,0x2
ffffffffc0204570:	6bc60613          	addi	a2,a2,1724 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204574:	0bb00593          	li	a1,187
ffffffffc0204578:	00004517          	auipc	a0,0x4
ffffffffc020457c:	aa050513          	addi	a0,a0,-1376 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204580:	c97fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(count == 0);
ffffffffc0204584:	00004697          	auipc	a3,0x4
ffffffffc0204588:	d8468693          	addi	a3,a3,-636 # ffffffffc0208308 <commands+0x1b60>
ffffffffc020458c:	00002617          	auipc	a2,0x2
ffffffffc0204590:	69c60613          	addi	a2,a2,1692 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204594:	12500593          	li	a1,293
ffffffffc0204598:	00004517          	auipc	a0,0x4
ffffffffc020459c:	a8050513          	addi	a0,a0,-1408 # ffffffffc0208018 <commands+0x1870>
ffffffffc02045a0:	c77fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_free == 0);
ffffffffc02045a4:	00004697          	auipc	a3,0x4
ffffffffc02045a8:	91468693          	addi	a3,a3,-1772 # ffffffffc0207eb8 <commands+0x1710>
ffffffffc02045ac:	00002617          	auipc	a2,0x2
ffffffffc02045b0:	67c60613          	addi	a2,a2,1660 # ffffffffc0206c28 <commands+0x480>
ffffffffc02045b4:	11a00593          	li	a1,282
ffffffffc02045b8:	00004517          	auipc	a0,0x4
ffffffffc02045bc:	a6050513          	addi	a0,a0,-1440 # ffffffffc0208018 <commands+0x1870>
ffffffffc02045c0:	c57fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02045c4:	00004697          	auipc	a3,0x4
ffffffffc02045c8:	b9468693          	addi	a3,a3,-1132 # ffffffffc0208158 <commands+0x19b0>
ffffffffc02045cc:	00002617          	auipc	a2,0x2
ffffffffc02045d0:	65c60613          	addi	a2,a2,1628 # ffffffffc0206c28 <commands+0x480>
ffffffffc02045d4:	11800593          	li	a1,280
ffffffffc02045d8:	00004517          	auipc	a0,0x4
ffffffffc02045dc:	a4050513          	addi	a0,a0,-1472 # ffffffffc0208018 <commands+0x1870>
ffffffffc02045e0:	c37fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02045e4:	00004697          	auipc	a3,0x4
ffffffffc02045e8:	b3468693          	addi	a3,a3,-1228 # ffffffffc0208118 <commands+0x1970>
ffffffffc02045ec:	00002617          	auipc	a2,0x2
ffffffffc02045f0:	63c60613          	addi	a2,a2,1596 # ffffffffc0206c28 <commands+0x480>
ffffffffc02045f4:	0c100593          	li	a1,193
ffffffffc02045f8:	00004517          	auipc	a0,0x4
ffffffffc02045fc:	a2050513          	addi	a0,a0,-1504 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204600:	c17fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0204604:	00004697          	auipc	a3,0x4
ffffffffc0204608:	cc468693          	addi	a3,a3,-828 # ffffffffc02082c8 <commands+0x1b20>
ffffffffc020460c:	00002617          	auipc	a2,0x2
ffffffffc0204610:	61c60613          	addi	a2,a2,1564 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204614:	11200593          	li	a1,274
ffffffffc0204618:	00004517          	auipc	a0,0x4
ffffffffc020461c:	a0050513          	addi	a0,a0,-1536 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204620:	bf7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0204624:	00004697          	auipc	a3,0x4
ffffffffc0204628:	c8468693          	addi	a3,a3,-892 # ffffffffc02082a8 <commands+0x1b00>
ffffffffc020462c:	00002617          	auipc	a2,0x2
ffffffffc0204630:	5fc60613          	addi	a2,a2,1532 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204634:	11000593          	li	a1,272
ffffffffc0204638:	00004517          	auipc	a0,0x4
ffffffffc020463c:	9e050513          	addi	a0,a0,-1568 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204640:	bd7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0204644:	00004697          	auipc	a3,0x4
ffffffffc0204648:	c3c68693          	addi	a3,a3,-964 # ffffffffc0208280 <commands+0x1ad8>
ffffffffc020464c:	00002617          	auipc	a2,0x2
ffffffffc0204650:	5dc60613          	addi	a2,a2,1500 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204654:	10e00593          	li	a1,270
ffffffffc0204658:	00004517          	auipc	a0,0x4
ffffffffc020465c:	9c050513          	addi	a0,a0,-1600 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204660:	bb7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0204664:	00004697          	auipc	a3,0x4
ffffffffc0204668:	bf468693          	addi	a3,a3,-1036 # ffffffffc0208258 <commands+0x1ab0>
ffffffffc020466c:	00002617          	auipc	a2,0x2
ffffffffc0204670:	5bc60613          	addi	a2,a2,1468 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204674:	10d00593          	li	a1,269
ffffffffc0204678:	00004517          	auipc	a0,0x4
ffffffffc020467c:	9a050513          	addi	a0,a0,-1632 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204680:	b97fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(p0 + 2 == p1);
ffffffffc0204684:	00004697          	auipc	a3,0x4
ffffffffc0204688:	bc468693          	addi	a3,a3,-1084 # ffffffffc0208248 <commands+0x1aa0>
ffffffffc020468c:	00002617          	auipc	a2,0x2
ffffffffc0204690:	59c60613          	addi	a2,a2,1436 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204694:	10800593          	li	a1,264
ffffffffc0204698:	00004517          	auipc	a0,0x4
ffffffffc020469c:	98050513          	addi	a0,a0,-1664 # ffffffffc0208018 <commands+0x1870>
ffffffffc02046a0:	b77fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02046a4:	00004697          	auipc	a3,0x4
ffffffffc02046a8:	ab468693          	addi	a3,a3,-1356 # ffffffffc0208158 <commands+0x19b0>
ffffffffc02046ac:	00002617          	auipc	a2,0x2
ffffffffc02046b0:	57c60613          	addi	a2,a2,1404 # ffffffffc0206c28 <commands+0x480>
ffffffffc02046b4:	10700593          	li	a1,263
ffffffffc02046b8:	00004517          	auipc	a0,0x4
ffffffffc02046bc:	96050513          	addi	a0,a0,-1696 # ffffffffc0208018 <commands+0x1870>
ffffffffc02046c0:	b57fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02046c4:	00004697          	auipc	a3,0x4
ffffffffc02046c8:	b6468693          	addi	a3,a3,-1180 # ffffffffc0208228 <commands+0x1a80>
ffffffffc02046cc:	00002617          	auipc	a2,0x2
ffffffffc02046d0:	55c60613          	addi	a2,a2,1372 # ffffffffc0206c28 <commands+0x480>
ffffffffc02046d4:	10600593          	li	a1,262
ffffffffc02046d8:	00004517          	auipc	a0,0x4
ffffffffc02046dc:	94050513          	addi	a0,a0,-1728 # ffffffffc0208018 <commands+0x1870>
ffffffffc02046e0:	b37fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02046e4:	00004697          	auipc	a3,0x4
ffffffffc02046e8:	b1468693          	addi	a3,a3,-1260 # ffffffffc02081f8 <commands+0x1a50>
ffffffffc02046ec:	00002617          	auipc	a2,0x2
ffffffffc02046f0:	53c60613          	addi	a2,a2,1340 # ffffffffc0206c28 <commands+0x480>
ffffffffc02046f4:	10500593          	li	a1,261
ffffffffc02046f8:	00004517          	auipc	a0,0x4
ffffffffc02046fc:	92050513          	addi	a0,a0,-1760 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204700:	b17fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0204704:	00004697          	auipc	a3,0x4
ffffffffc0204708:	adc68693          	addi	a3,a3,-1316 # ffffffffc02081e0 <commands+0x1a38>
ffffffffc020470c:	00002617          	auipc	a2,0x2
ffffffffc0204710:	51c60613          	addi	a2,a2,1308 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204714:	10400593          	li	a1,260
ffffffffc0204718:	00004517          	auipc	a0,0x4
ffffffffc020471c:	90050513          	addi	a0,a0,-1792 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204720:	af7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(alloc_page() == NULL);
ffffffffc0204724:	00004697          	auipc	a3,0x4
ffffffffc0204728:	a3468693          	addi	a3,a3,-1484 # ffffffffc0208158 <commands+0x19b0>
ffffffffc020472c:	00002617          	auipc	a2,0x2
ffffffffc0204730:	4fc60613          	addi	a2,a2,1276 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204734:	0fe00593          	li	a1,254
ffffffffc0204738:	00004517          	auipc	a0,0x4
ffffffffc020473c:	8e050513          	addi	a0,a0,-1824 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204740:	ad7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(!PageProperty(p0));
ffffffffc0204744:	00004697          	auipc	a3,0x4
ffffffffc0204748:	a8468693          	addi	a3,a3,-1404 # ffffffffc02081c8 <commands+0x1a20>
ffffffffc020474c:	00002617          	auipc	a2,0x2
ffffffffc0204750:	4dc60613          	addi	a2,a2,1244 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204754:	0f900593          	li	a1,249
ffffffffc0204758:	00004517          	auipc	a0,0x4
ffffffffc020475c:	8c050513          	addi	a0,a0,-1856 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204760:	ab7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0204764:	00004697          	auipc	a3,0x4
ffffffffc0204768:	b8468693          	addi	a3,a3,-1148 # ffffffffc02082e8 <commands+0x1b40>
ffffffffc020476c:	00002617          	auipc	a2,0x2
ffffffffc0204770:	4bc60613          	addi	a2,a2,1212 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204774:	11700593          	li	a1,279
ffffffffc0204778:	00004517          	auipc	a0,0x4
ffffffffc020477c:	8a050513          	addi	a0,a0,-1888 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204780:	a97fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(total == 0);
ffffffffc0204784:	00004697          	auipc	a3,0x4
ffffffffc0204788:	b9468693          	addi	a3,a3,-1132 # ffffffffc0208318 <commands+0x1b70>
ffffffffc020478c:	00002617          	auipc	a2,0x2
ffffffffc0204790:	49c60613          	addi	a2,a2,1180 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204794:	12600593          	li	a1,294
ffffffffc0204798:	00004517          	auipc	a0,0x4
ffffffffc020479c:	88050513          	addi	a0,a0,-1920 # ffffffffc0208018 <commands+0x1870>
ffffffffc02047a0:	a77fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(total == nr_free_pages());
ffffffffc02047a4:	00003697          	auipc	a3,0x3
ffffffffc02047a8:	58468693          	addi	a3,a3,1412 # ffffffffc0207d28 <commands+0x1580>
ffffffffc02047ac:	00002617          	auipc	a2,0x2
ffffffffc02047b0:	47c60613          	addi	a2,a2,1148 # ffffffffc0206c28 <commands+0x480>
ffffffffc02047b4:	0f300593          	li	a1,243
ffffffffc02047b8:	00004517          	auipc	a0,0x4
ffffffffc02047bc:	86050513          	addi	a0,a0,-1952 # ffffffffc0208018 <commands+0x1870>
ffffffffc02047c0:	a57fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02047c4:	00004697          	auipc	a3,0x4
ffffffffc02047c8:	88c68693          	addi	a3,a3,-1908 # ffffffffc0208050 <commands+0x18a8>
ffffffffc02047cc:	00002617          	auipc	a2,0x2
ffffffffc02047d0:	45c60613          	addi	a2,a2,1116 # ffffffffc0206c28 <commands+0x480>
ffffffffc02047d4:	0ba00593          	li	a1,186
ffffffffc02047d8:	00004517          	auipc	a0,0x4
ffffffffc02047dc:	84050513          	addi	a0,a0,-1984 # ffffffffc0208018 <commands+0x1870>
ffffffffc02047e0:	a37fb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02047e4 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02047e4:	1141                	addi	sp,sp,-16
ffffffffc02047e6:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02047e8:	16058e63          	beqz	a1,ffffffffc0204964 <default_free_pages+0x180>
    for (; p != base + n; p ++) {
ffffffffc02047ec:	00659693          	slli	a3,a1,0x6
ffffffffc02047f0:	96aa                	add	a3,a3,a0
ffffffffc02047f2:	02d50d63          	beq	a0,a3,ffffffffc020482c <default_free_pages+0x48>
ffffffffc02047f6:	651c                	ld	a5,8(a0)
ffffffffc02047f8:	8b85                	andi	a5,a5,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02047fa:	14079563          	bnez	a5,ffffffffc0204944 <default_free_pages+0x160>
ffffffffc02047fe:	651c                	ld	a5,8(a0)
ffffffffc0204800:	8385                	srli	a5,a5,0x1
ffffffffc0204802:	8b85                	andi	a5,a5,1
ffffffffc0204804:	14079063          	bnez	a5,ffffffffc0204944 <default_free_pages+0x160>
ffffffffc0204808:	87aa                	mv	a5,a0
ffffffffc020480a:	a809                	j	ffffffffc020481c <default_free_pages+0x38>
ffffffffc020480c:	6798                	ld	a4,8(a5)
ffffffffc020480e:	8b05                	andi	a4,a4,1
ffffffffc0204810:	12071a63          	bnez	a4,ffffffffc0204944 <default_free_pages+0x160>
ffffffffc0204814:	6798                	ld	a4,8(a5)
ffffffffc0204816:	8b09                	andi	a4,a4,2
ffffffffc0204818:	12071663          	bnez	a4,ffffffffc0204944 <default_free_pages+0x160>
        p->flags = 0;
ffffffffc020481c:	0007b423          	sd	zero,8(a5)
    page->ref = val;
ffffffffc0204820:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0204824:	04078793          	addi	a5,a5,64
ffffffffc0204828:	fed792e3          	bne	a5,a3,ffffffffc020480c <default_free_pages+0x28>
    base->property = n;
ffffffffc020482c:	2581                	sext.w	a1,a1
ffffffffc020482e:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0204830:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204834:	4789                	li	a5,2
ffffffffc0204836:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc020483a:	000a8697          	auipc	a3,0xa8
ffffffffc020483e:	e3e68693          	addi	a3,a3,-450 # ffffffffc02ac678 <free_area>
ffffffffc0204842:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0204844:	669c                	ld	a5,8(a3)
ffffffffc0204846:	9db9                	addw	a1,a1,a4
ffffffffc0204848:	000a8717          	auipc	a4,0xa8
ffffffffc020484c:	e4b72023          	sw	a1,-448(a4) # ffffffffc02ac688 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc0204850:	0cd78163          	beq	a5,a3,ffffffffc0204912 <default_free_pages+0x12e>
            struct Page* page = le2page(le, page_link);
ffffffffc0204854:	fe878713          	addi	a4,a5,-24
ffffffffc0204858:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020485a:	4801                	li	a6,0
ffffffffc020485c:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0204860:	00e56a63          	bltu	a0,a4,ffffffffc0204874 <default_free_pages+0x90>
    return listelm->next;
ffffffffc0204864:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0204866:	04d70f63          	beq	a4,a3,ffffffffc02048c4 <default_free_pages+0xe0>
        while ((le = list_next(le)) != &free_list) {
ffffffffc020486a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020486c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0204870:	fee57ae3          	bleu	a4,a0,ffffffffc0204864 <default_free_pages+0x80>
ffffffffc0204874:	00080663          	beqz	a6,ffffffffc0204880 <default_free_pages+0x9c>
ffffffffc0204878:	000a8817          	auipc	a6,0xa8
ffffffffc020487c:	e0b83023          	sd	a1,-512(a6) # ffffffffc02ac678 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0204880:	638c                	ld	a1,0(a5)
    prev->next = next->prev = elm;
ffffffffc0204882:	e390                	sd	a2,0(a5)
ffffffffc0204884:	e590                	sd	a2,8(a1)
    elm->next = next;
ffffffffc0204886:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0204888:	ed0c                	sd	a1,24(a0)
    if (le != &free_list) {
ffffffffc020488a:	06d58a63          	beq	a1,a3,ffffffffc02048fe <default_free_pages+0x11a>
        if (p + p->property == base) {
ffffffffc020488e:	ff85a603          	lw	a2,-8(a1) # ff8 <_binary_obj___user_faultread_out_size-0x8590>
        p = le2page(le, page_link);
ffffffffc0204892:	fe858713          	addi	a4,a1,-24
        if (p + p->property == base) {
ffffffffc0204896:	02061793          	slli	a5,a2,0x20
ffffffffc020489a:	83e9                	srli	a5,a5,0x1a
ffffffffc020489c:	97ba                	add	a5,a5,a4
ffffffffc020489e:	04f51b63          	bne	a0,a5,ffffffffc02048f4 <default_free_pages+0x110>
            p->property += base->property;
ffffffffc02048a2:	491c                	lw	a5,16(a0)
ffffffffc02048a4:	9e3d                	addw	a2,a2,a5
ffffffffc02048a6:	fec5ac23          	sw	a2,-8(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02048aa:	57f5                	li	a5,-3
ffffffffc02048ac:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02048b0:	01853803          	ld	a6,24(a0)
ffffffffc02048b4:	7110                	ld	a2,32(a0)
            base = p;
ffffffffc02048b6:	853a                	mv	a0,a4
    prev->next = next;
ffffffffc02048b8:	00c83423          	sd	a2,8(a6)
    next->prev = prev;
ffffffffc02048bc:	659c                	ld	a5,8(a1)
ffffffffc02048be:	01063023          	sd	a6,0(a2)
ffffffffc02048c2:	a815                	j	ffffffffc02048f6 <default_free_pages+0x112>
    prev->next = next->prev = elm;
ffffffffc02048c4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02048c6:	f114                	sd	a3,32(a0)
ffffffffc02048c8:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02048ca:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02048cc:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02048ce:	00d70563          	beq	a4,a3,ffffffffc02048d8 <default_free_pages+0xf4>
ffffffffc02048d2:	4805                	li	a6,1
ffffffffc02048d4:	87ba                	mv	a5,a4
ffffffffc02048d6:	bf59                	j	ffffffffc020486c <default_free_pages+0x88>
ffffffffc02048d8:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02048da:	85be                	mv	a1,a5
    if (le != &free_list) {
ffffffffc02048dc:	00d78d63          	beq	a5,a3,ffffffffc02048f6 <default_free_pages+0x112>
        if (p + p->property == base) {
ffffffffc02048e0:	ff85a603          	lw	a2,-8(a1)
        p = le2page(le, page_link);
ffffffffc02048e4:	fe858713          	addi	a4,a1,-24
        if (p + p->property == base) {
ffffffffc02048e8:	02061793          	slli	a5,a2,0x20
ffffffffc02048ec:	83e9                	srli	a5,a5,0x1a
ffffffffc02048ee:	97ba                	add	a5,a5,a4
ffffffffc02048f0:	faf509e3          	beq	a0,a5,ffffffffc02048a2 <default_free_pages+0xbe>
ffffffffc02048f4:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc02048f6:	fe878713          	addi	a4,a5,-24
ffffffffc02048fa:	00d78963          	beq	a5,a3,ffffffffc020490c <default_free_pages+0x128>
        if (base + base->property == p) {
ffffffffc02048fe:	4910                	lw	a2,16(a0)
ffffffffc0204900:	02061693          	slli	a3,a2,0x20
ffffffffc0204904:	82e9                	srli	a3,a3,0x1a
ffffffffc0204906:	96aa                	add	a3,a3,a0
ffffffffc0204908:	00d70e63          	beq	a4,a3,ffffffffc0204924 <default_free_pages+0x140>
}
ffffffffc020490c:	60a2                	ld	ra,8(sp)
ffffffffc020490e:	0141                	addi	sp,sp,16
ffffffffc0204910:	8082                	ret
ffffffffc0204912:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0204914:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0204918:	e398                	sd	a4,0(a5)
ffffffffc020491a:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020491c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020491e:	ed1c                	sd	a5,24(a0)
}
ffffffffc0204920:	0141                	addi	sp,sp,16
ffffffffc0204922:	8082                	ret
            base->property += p->property;
ffffffffc0204924:	ff87a703          	lw	a4,-8(a5)
ffffffffc0204928:	ff078693          	addi	a3,a5,-16
ffffffffc020492c:	9e39                	addw	a2,a2,a4
ffffffffc020492e:	c910                	sw	a2,16(a0)
ffffffffc0204930:	5775                	li	a4,-3
ffffffffc0204932:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204936:	6398                	ld	a4,0(a5)
ffffffffc0204938:	679c                	ld	a5,8(a5)
}
ffffffffc020493a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020493c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020493e:	e398                	sd	a4,0(a5)
ffffffffc0204940:	0141                	addi	sp,sp,16
ffffffffc0204942:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0204944:	00004697          	auipc	a3,0x4
ffffffffc0204948:	9e468693          	addi	a3,a3,-1564 # ffffffffc0208328 <commands+0x1b80>
ffffffffc020494c:	00002617          	auipc	a2,0x2
ffffffffc0204950:	2dc60613          	addi	a2,a2,732 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204954:	08300593          	li	a1,131
ffffffffc0204958:	00003517          	auipc	a0,0x3
ffffffffc020495c:	6c050513          	addi	a0,a0,1728 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204960:	8b7fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(n > 0);
ffffffffc0204964:	00004697          	auipc	a3,0x4
ffffffffc0204968:	9ec68693          	addi	a3,a3,-1556 # ffffffffc0208350 <commands+0x1ba8>
ffffffffc020496c:	00002617          	auipc	a2,0x2
ffffffffc0204970:	2bc60613          	addi	a2,a2,700 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204974:	08000593          	li	a1,128
ffffffffc0204978:	00003517          	auipc	a0,0x3
ffffffffc020497c:	6a050513          	addi	a0,a0,1696 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204980:	897fb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204984 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0204984:	c959                	beqz	a0,ffffffffc0204a1a <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc0204986:	000a8597          	auipc	a1,0xa8
ffffffffc020498a:	cf258593          	addi	a1,a1,-782 # ffffffffc02ac678 <free_area>
ffffffffc020498e:	0105a803          	lw	a6,16(a1)
ffffffffc0204992:	862a                	mv	a2,a0
ffffffffc0204994:	02081793          	slli	a5,a6,0x20
ffffffffc0204998:	9381                	srli	a5,a5,0x20
ffffffffc020499a:	00a7ee63          	bltu	a5,a0,ffffffffc02049b6 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020499e:	87ae                	mv	a5,a1
ffffffffc02049a0:	a801                	j	ffffffffc02049b0 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc02049a2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02049a6:	02071693          	slli	a3,a4,0x20
ffffffffc02049aa:	9281                	srli	a3,a3,0x20
ffffffffc02049ac:	00c6f763          	bleu	a2,a3,ffffffffc02049ba <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02049b0:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc02049b2:	feb798e3          	bne	a5,a1,ffffffffc02049a2 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02049b6:	4501                	li	a0,0
}
ffffffffc02049b8:	8082                	ret
        struct Page *p = le2page(le, page_link);
ffffffffc02049ba:	fe878513          	addi	a0,a5,-24
    if (page != NULL) {
ffffffffc02049be:	dd6d                	beqz	a0,ffffffffc02049b8 <default_alloc_pages+0x34>
    return listelm->prev;
ffffffffc02049c0:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02049c4:	0087b303          	ld	t1,8(a5)
    prev->next = next;
ffffffffc02049c8:	00060e1b          	sext.w	t3,a2
ffffffffc02049cc:	0068b423          	sd	t1,8(a7) # fffffffffff80008 <end+0x3fcd3968>
    next->prev = prev;
ffffffffc02049d0:	01133023          	sd	a7,0(t1) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff5578>
        if (page->property > n) {
ffffffffc02049d4:	02d67863          	bleu	a3,a2,ffffffffc0204a04 <default_alloc_pages+0x80>
            struct Page *p = page + n;
ffffffffc02049d8:	061a                	slli	a2,a2,0x6
ffffffffc02049da:	962a                	add	a2,a2,a0
            p->property = page->property - n;
ffffffffc02049dc:	41c7073b          	subw	a4,a4,t3
ffffffffc02049e0:	ca18                	sw	a4,16(a2)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02049e2:	00860693          	addi	a3,a2,8
ffffffffc02049e6:	4709                	li	a4,2
ffffffffc02049e8:	40e6b02f          	amoor.d	zero,a4,(a3)
    __list_add(elm, listelm, listelm->next);
ffffffffc02049ec:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02049f0:	01860693          	addi	a3,a2,24
    prev->next = next->prev = elm;
ffffffffc02049f4:	0105a803          	lw	a6,16(a1)
ffffffffc02049f8:	e314                	sd	a3,0(a4)
ffffffffc02049fa:	00d8b423          	sd	a3,8(a7)
    elm->next = next;
ffffffffc02049fe:	f218                	sd	a4,32(a2)
    elm->prev = prev;
ffffffffc0204a00:	01163c23          	sd	a7,24(a2)
        nr_free -= n;
ffffffffc0204a04:	41c8083b          	subw	a6,a6,t3
ffffffffc0204a08:	000a8717          	auipc	a4,0xa8
ffffffffc0204a0c:	c9072023          	sw	a6,-896(a4) # ffffffffc02ac688 <free_area+0x10>
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0204a10:	5775                	li	a4,-3
ffffffffc0204a12:	17c1                	addi	a5,a5,-16
ffffffffc0204a14:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0204a18:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0204a1a:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0204a1c:	00004697          	auipc	a3,0x4
ffffffffc0204a20:	93468693          	addi	a3,a3,-1740 # ffffffffc0208350 <commands+0x1ba8>
ffffffffc0204a24:	00002617          	auipc	a2,0x2
ffffffffc0204a28:	20460613          	addi	a2,a2,516 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204a2c:	06200593          	li	a1,98
ffffffffc0204a30:	00003517          	auipc	a0,0x3
ffffffffc0204a34:	5e850513          	addi	a0,a0,1512 # ffffffffc0208018 <commands+0x1870>
default_alloc_pages(size_t n) {
ffffffffc0204a38:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0204a3a:	fdcfb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204a3e <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0204a3e:	1141                	addi	sp,sp,-16
ffffffffc0204a40:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0204a42:	c1ed                	beqz	a1,ffffffffc0204b24 <default_init_memmap+0xe6>
    for (; p != base + n; p ++) {
ffffffffc0204a44:	00659693          	slli	a3,a1,0x6
ffffffffc0204a48:	96aa                	add	a3,a3,a0
ffffffffc0204a4a:	02d50463          	beq	a0,a3,ffffffffc0204a72 <default_init_memmap+0x34>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0204a4e:	6518                	ld	a4,8(a0)
        assert(PageReserved(p));
ffffffffc0204a50:	87aa                	mv	a5,a0
ffffffffc0204a52:	8b05                	andi	a4,a4,1
ffffffffc0204a54:	e709                	bnez	a4,ffffffffc0204a5e <default_init_memmap+0x20>
ffffffffc0204a56:	a07d                	j	ffffffffc0204b04 <default_init_memmap+0xc6>
ffffffffc0204a58:	6798                	ld	a4,8(a5)
ffffffffc0204a5a:	8b05                	andi	a4,a4,1
ffffffffc0204a5c:	c745                	beqz	a4,ffffffffc0204b04 <default_init_memmap+0xc6>
        p->flags = p->property = 0;
ffffffffc0204a5e:	0007a823          	sw	zero,16(a5)
ffffffffc0204a62:	0007b423          	sd	zero,8(a5)
ffffffffc0204a66:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0204a6a:	04078793          	addi	a5,a5,64
ffffffffc0204a6e:	fed795e3          	bne	a5,a3,ffffffffc0204a58 <default_init_memmap+0x1a>
    base->property = n;
ffffffffc0204a72:	2581                	sext.w	a1,a1
ffffffffc0204a74:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204a76:	4789                	li	a5,2
ffffffffc0204a78:	00850713          	addi	a4,a0,8
ffffffffc0204a7c:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0204a80:	000a8697          	auipc	a3,0xa8
ffffffffc0204a84:	bf868693          	addi	a3,a3,-1032 # ffffffffc02ac678 <free_area>
ffffffffc0204a88:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0204a8a:	669c                	ld	a5,8(a3)
ffffffffc0204a8c:	9db9                	addw	a1,a1,a4
ffffffffc0204a8e:	000a8717          	auipc	a4,0xa8
ffffffffc0204a92:	beb72d23          	sw	a1,-1030(a4) # ffffffffc02ac688 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc0204a96:	04d78a63          	beq	a5,a3,ffffffffc0204aea <default_init_memmap+0xac>
            struct Page* page = le2page(le, page_link);
ffffffffc0204a9a:	fe878713          	addi	a4,a5,-24
ffffffffc0204a9e:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0204aa0:	4801                	li	a6,0
ffffffffc0204aa2:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc0204aa6:	00e56a63          	bltu	a0,a4,ffffffffc0204aba <default_init_memmap+0x7c>
    return listelm->next;
ffffffffc0204aaa:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0204aac:	02d70563          	beq	a4,a3,ffffffffc0204ad6 <default_init_memmap+0x98>
        while ((le = list_next(le)) != &free_list) {
ffffffffc0204ab0:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0204ab2:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0204ab6:	fee57ae3          	bleu	a4,a0,ffffffffc0204aaa <default_init_memmap+0x6c>
ffffffffc0204aba:	00080663          	beqz	a6,ffffffffc0204ac6 <default_init_memmap+0x88>
ffffffffc0204abe:	000a8717          	auipc	a4,0xa8
ffffffffc0204ac2:	bab73d23          	sd	a1,-1094(a4) # ffffffffc02ac678 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0204ac6:	6398                	ld	a4,0(a5)
}
ffffffffc0204ac8:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0204aca:	e390                	sd	a2,0(a5)
ffffffffc0204acc:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0204ace:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0204ad0:	ed18                	sd	a4,24(a0)
ffffffffc0204ad2:	0141                	addi	sp,sp,16
ffffffffc0204ad4:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0204ad6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0204ad8:	f114                	sd	a3,32(a0)
ffffffffc0204ada:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0204adc:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc0204ade:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc0204ae0:	00d70e63          	beq	a4,a3,ffffffffc0204afc <default_init_memmap+0xbe>
ffffffffc0204ae4:	4805                	li	a6,1
ffffffffc0204ae6:	87ba                	mv	a5,a4
ffffffffc0204ae8:	b7e9                	j	ffffffffc0204ab2 <default_init_memmap+0x74>
}
ffffffffc0204aea:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0204aec:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0204af0:	e398                	sd	a4,0(a5)
ffffffffc0204af2:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0204af4:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0204af6:	ed1c                	sd	a5,24(a0)
}
ffffffffc0204af8:	0141                	addi	sp,sp,16
ffffffffc0204afa:	8082                	ret
ffffffffc0204afc:	60a2                	ld	ra,8(sp)
ffffffffc0204afe:	e290                	sd	a2,0(a3)
ffffffffc0204b00:	0141                	addi	sp,sp,16
ffffffffc0204b02:	8082                	ret
        assert(PageReserved(p));
ffffffffc0204b04:	00004697          	auipc	a3,0x4
ffffffffc0204b08:	85468693          	addi	a3,a3,-1964 # ffffffffc0208358 <commands+0x1bb0>
ffffffffc0204b0c:	00002617          	auipc	a2,0x2
ffffffffc0204b10:	11c60613          	addi	a2,a2,284 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204b14:	04900593          	li	a1,73
ffffffffc0204b18:	00003517          	auipc	a0,0x3
ffffffffc0204b1c:	50050513          	addi	a0,a0,1280 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204b20:	ef6fb0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(n > 0);
ffffffffc0204b24:	00004697          	auipc	a3,0x4
ffffffffc0204b28:	82c68693          	addi	a3,a3,-2004 # ffffffffc0208350 <commands+0x1ba8>
ffffffffc0204b2c:	00002617          	auipc	a2,0x2
ffffffffc0204b30:	0fc60613          	addi	a2,a2,252 # ffffffffc0206c28 <commands+0x480>
ffffffffc0204b34:	04600593          	li	a1,70
ffffffffc0204b38:	00003517          	auipc	a0,0x3
ffffffffc0204b3c:	4e050513          	addi	a0,a0,1248 # ffffffffc0208018 <commands+0x1870>
ffffffffc0204b40:	ed6fb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204b44 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
ffffffffc0204b44:	1141                	addi	sp,sp,-16
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0204b46:	4505                	li	a0,1
swapfs_init(void) {
ffffffffc0204b48:	e406                	sd	ra,8(sp)
    if (!ide_device_valid(SWAP_DEV_NO)) {
ffffffffc0204b4a:	9ebfb0ef          	jal	ra,ffffffffc0200534 <ide_device_valid>
ffffffffc0204b4e:	cd01                	beqz	a0,ffffffffc0204b66 <swapfs_init+0x22>
        panic("swap fs isn't available.\n");
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204b50:	4505                	li	a0,1
ffffffffc0204b52:	9e9fb0ef          	jal	ra,ffffffffc020053a <ide_device_size>
}
ffffffffc0204b56:	60a2                	ld	ra,8(sp)
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
ffffffffc0204b58:	810d                	srli	a0,a0,0x3
ffffffffc0204b5a:	000a8797          	auipc	a5,0xa8
ffffffffc0204b5e:	aca7bf23          	sd	a0,-1314(a5) # ffffffffc02ac638 <max_swap_offset>
}
ffffffffc0204b62:	0141                	addi	sp,sp,16
ffffffffc0204b64:	8082                	ret
        panic("swap fs isn't available.\n");
ffffffffc0204b66:	00004617          	auipc	a2,0x4
ffffffffc0204b6a:	85260613          	addi	a2,a2,-1966 # ffffffffc02083b8 <default_pmm_manager+0x50>
ffffffffc0204b6e:	45b5                	li	a1,13
ffffffffc0204b70:	00004517          	auipc	a0,0x4
ffffffffc0204b74:	86850513          	addi	a0,a0,-1944 # ffffffffc02083d8 <default_pmm_manager+0x70>
ffffffffc0204b78:	e9efb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204b7c <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
ffffffffc0204b7c:	1141                	addi	sp,sp,-16
ffffffffc0204b7e:	e406                	sd	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204b80:	00855793          	srli	a5,a0,0x8
ffffffffc0204b84:	cfb9                	beqz	a5,ffffffffc0204be2 <swapfs_read+0x66>
ffffffffc0204b86:	000a8717          	auipc	a4,0xa8
ffffffffc0204b8a:	ab270713          	addi	a4,a4,-1358 # ffffffffc02ac638 <max_swap_offset>
ffffffffc0204b8e:	6318                	ld	a4,0(a4)
ffffffffc0204b90:	04e7f963          	bleu	a4,a5,ffffffffc0204be2 <swapfs_read+0x66>
    return page - pages + nbase;
ffffffffc0204b94:	000a8717          	auipc	a4,0xa8
ffffffffc0204b98:	9fc70713          	addi	a4,a4,-1540 # ffffffffc02ac590 <pages>
ffffffffc0204b9c:	6310                	ld	a2,0(a4)
ffffffffc0204b9e:	00004717          	auipc	a4,0x4
ffffffffc0204ba2:	19270713          	addi	a4,a4,402 # ffffffffc0208d30 <nbase>
    return KADDR(page2pa(page));
ffffffffc0204ba6:	000a8697          	auipc	a3,0xa8
ffffffffc0204baa:	98268693          	addi	a3,a3,-1662 # ffffffffc02ac528 <npage>
    return page - pages + nbase;
ffffffffc0204bae:	40c58633          	sub	a2,a1,a2
ffffffffc0204bb2:	630c                	ld	a1,0(a4)
ffffffffc0204bb4:	8619                	srai	a2,a2,0x6
    return KADDR(page2pa(page));
ffffffffc0204bb6:	577d                	li	a4,-1
ffffffffc0204bb8:	6294                	ld	a3,0(a3)
    return page - pages + nbase;
ffffffffc0204bba:	962e                	add	a2,a2,a1
    return KADDR(page2pa(page));
ffffffffc0204bbc:	8331                	srli	a4,a4,0xc
ffffffffc0204bbe:	8f71                	and	a4,a4,a2
ffffffffc0204bc0:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bc4:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0204bc6:	02d77a63          	bleu	a3,a4,ffffffffc0204bfa <swapfs_read+0x7e>
ffffffffc0204bca:	000a8797          	auipc	a5,0xa8
ffffffffc0204bce:	9b678793          	addi	a5,a5,-1610 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0204bd2:	639c                	ld	a5,0(a5)
}
ffffffffc0204bd4:	60a2                	ld	ra,8(sp)
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204bd6:	46a1                	li	a3,8
ffffffffc0204bd8:	963e                	add	a2,a2,a5
ffffffffc0204bda:	4505                	li	a0,1
}
ffffffffc0204bdc:	0141                	addi	sp,sp,16
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204bde:	963fb06f          	j	ffffffffc0200540 <ide_read_secs>
ffffffffc0204be2:	86aa                	mv	a3,a0
ffffffffc0204be4:	00004617          	auipc	a2,0x4
ffffffffc0204be8:	80c60613          	addi	a2,a2,-2036 # ffffffffc02083f0 <default_pmm_manager+0x88>
ffffffffc0204bec:	45d1                	li	a1,20
ffffffffc0204bee:	00003517          	auipc	a0,0x3
ffffffffc0204bf2:	7ea50513          	addi	a0,a0,2026 # ffffffffc02083d8 <default_pmm_manager+0x70>
ffffffffc0204bf6:	e20fb0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0204bfa:	86b2                	mv	a3,a2
ffffffffc0204bfc:	06900593          	li	a1,105
ffffffffc0204c00:	00002617          	auipc	a2,0x2
ffffffffc0204c04:	41060613          	addi	a2,a2,1040 # ffffffffc0207010 <commands+0x868>
ffffffffc0204c08:	00002517          	auipc	a0,0x2
ffffffffc0204c0c:	46050513          	addi	a0,a0,1120 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0204c10:	e06fb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204c14 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
ffffffffc0204c14:	1141                	addi	sp,sp,-16
ffffffffc0204c16:	e406                	sd	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c18:	00855793          	srli	a5,a0,0x8
ffffffffc0204c1c:	cfb9                	beqz	a5,ffffffffc0204c7a <swapfs_write+0x66>
ffffffffc0204c1e:	000a8717          	auipc	a4,0xa8
ffffffffc0204c22:	a1a70713          	addi	a4,a4,-1510 # ffffffffc02ac638 <max_swap_offset>
ffffffffc0204c26:	6318                	ld	a4,0(a4)
ffffffffc0204c28:	04e7f963          	bleu	a4,a5,ffffffffc0204c7a <swapfs_write+0x66>
    return page - pages + nbase;
ffffffffc0204c2c:	000a8717          	auipc	a4,0xa8
ffffffffc0204c30:	96470713          	addi	a4,a4,-1692 # ffffffffc02ac590 <pages>
ffffffffc0204c34:	6310                	ld	a2,0(a4)
ffffffffc0204c36:	00004717          	auipc	a4,0x4
ffffffffc0204c3a:	0fa70713          	addi	a4,a4,250 # ffffffffc0208d30 <nbase>
    return KADDR(page2pa(page));
ffffffffc0204c3e:	000a8697          	auipc	a3,0xa8
ffffffffc0204c42:	8ea68693          	addi	a3,a3,-1814 # ffffffffc02ac528 <npage>
    return page - pages + nbase;
ffffffffc0204c46:	40c58633          	sub	a2,a1,a2
ffffffffc0204c4a:	630c                	ld	a1,0(a4)
ffffffffc0204c4c:	8619                	srai	a2,a2,0x6
    return KADDR(page2pa(page));
ffffffffc0204c4e:	577d                	li	a4,-1
ffffffffc0204c50:	6294                	ld	a3,0(a3)
    return page - pages + nbase;
ffffffffc0204c52:	962e                	add	a2,a2,a1
    return KADDR(page2pa(page));
ffffffffc0204c54:	8331                	srli	a4,a4,0xc
ffffffffc0204c56:	8f71                	and	a4,a4,a2
ffffffffc0204c58:	0037959b          	slliw	a1,a5,0x3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c5c:	0632                	slli	a2,a2,0xc
    return KADDR(page2pa(page));
ffffffffc0204c5e:	02d77a63          	bleu	a3,a4,ffffffffc0204c92 <swapfs_write+0x7e>
ffffffffc0204c62:	000a8797          	auipc	a5,0xa8
ffffffffc0204c66:	91e78793          	addi	a5,a5,-1762 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0204c6a:	639c                	ld	a5,0(a5)
}
ffffffffc0204c6c:	60a2                	ld	ra,8(sp)
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c6e:	46a1                	li	a3,8
ffffffffc0204c70:	963e                	add	a2,a2,a5
ffffffffc0204c72:	4505                	li	a0,1
}
ffffffffc0204c74:	0141                	addi	sp,sp,16
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
ffffffffc0204c76:	8effb06f          	j	ffffffffc0200564 <ide_write_secs>
ffffffffc0204c7a:	86aa                	mv	a3,a0
ffffffffc0204c7c:	00003617          	auipc	a2,0x3
ffffffffc0204c80:	77460613          	addi	a2,a2,1908 # ffffffffc02083f0 <default_pmm_manager+0x88>
ffffffffc0204c84:	45e5                	li	a1,25
ffffffffc0204c86:	00003517          	auipc	a0,0x3
ffffffffc0204c8a:	75250513          	addi	a0,a0,1874 # ffffffffc02083d8 <default_pmm_manager+0x70>
ffffffffc0204c8e:	d88fb0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0204c92:	86b2                	mv	a3,a2
ffffffffc0204c94:	06900593          	li	a1,105
ffffffffc0204c98:	00002617          	auipc	a2,0x2
ffffffffc0204c9c:	37860613          	addi	a2,a2,888 # ffffffffc0207010 <commands+0x868>
ffffffffc0204ca0:	00002517          	auipc	a0,0x2
ffffffffc0204ca4:	3c850513          	addi	a0,a0,968 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0204ca8:	d6efb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204cac <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0204cac:	8526                	mv	a0,s1
	jalr s0
ffffffffc0204cae:	9402                	jalr	s0

	jal do_exit
ffffffffc0204cb0:	79e000ef          	jal	ra,ffffffffc020544e <do_exit>

ffffffffc0204cb4 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204cb4:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204cb8:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204cbc:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204cbe:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204cc0:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204cc4:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204cc8:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204ccc:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204cd0:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204cd4:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0204cd8:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0204cdc:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0204ce0:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0204ce4:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0204ce8:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0204cec:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0204cf0:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0204cf2:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0204cf4:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0204cf8:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0204cfc:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0204d00:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0204d04:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0204d08:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0204d0c:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0204d10:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0204d14:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0204d18:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0204d1c:	8082                	ret

ffffffffc0204d1e <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
ffffffffc0204d1e:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204d20:	10800513          	li	a0,264
alloc_proc(void) {
ffffffffc0204d24:	e022                	sd	s0,0(sp)
ffffffffc0204d26:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0204d28:	fc0fe0ef          	jal	ra,ffffffffc02034e8 <kmalloc>
ffffffffc0204d2c:	842a                	mv	s0,a0
    if (proc != NULL) {
ffffffffc0204d2e:	cd29                	beqz	a0,ffffffffc0204d88 <alloc_proc+0x6a>
     /*
     * below fields(add in LAB5) in proc_struct need to be initialized  
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
     */
            proc->state = PROC_UNINIT; //未初始化
ffffffffc0204d30:	57fd                	li	a5,-1
ffffffffc0204d32:	1782                	slli	a5,a5,0x20
ffffffffc0204d34:	e11c                	sd	a5,0(a0)
            proc->runs = 0; //进程的运行次数，未开始运行
            proc->kstack = 0; //进程的内核栈地址
            proc->need_resched = 0; //是否需要重新调度，0表示不需要
            proc->parent = NULL; //父进程
            proc->mm = NULL; //进程内存管理结构，未分配地址空间
            memset(&(proc->context), 0, sizeof(struct context)); //进程上下文
ffffffffc0204d36:	07000613          	li	a2,112
ffffffffc0204d3a:	4581                	li	a1,0
            proc->runs = 0; //进程的运行次数，未开始运行
ffffffffc0204d3c:	00052423          	sw	zero,8(a0)
            proc->kstack = 0; //进程的内核栈地址
ffffffffc0204d40:	00053823          	sd	zero,16(a0)
            proc->need_resched = 0; //是否需要重新调度，0表示不需要
ffffffffc0204d44:	00053c23          	sd	zero,24(a0)
            proc->parent = NULL; //父进程
ffffffffc0204d48:	02053023          	sd	zero,32(a0)
            proc->mm = NULL; //进程内存管理结构，未分配地址空间
ffffffffc0204d4c:	02053423          	sd	zero,40(a0)
            memset(&(proc->context), 0, sizeof(struct context)); //进程上下文
ffffffffc0204d50:	03050513          	addi	a0,a0,48
ffffffffc0204d54:	4aa010ef          	jal	ra,ffffffffc02061fe <memset>
            proc->tf = NULL;//指向中断帧的指针
            proc->cr3 = boot_cr3;//存储进程的页目录表基址
ffffffffc0204d58:	000a8797          	auipc	a5,0xa8
ffffffffc0204d5c:	83078793          	addi	a5,a5,-2000 # ffffffffc02ac588 <boot_cr3>
ffffffffc0204d60:	639c                	ld	a5,0(a5)
            proc->tf = NULL;//指向中断帧的指针
ffffffffc0204d62:	0a043023          	sd	zero,160(s0)
            //初始化为ucore启动时建立好的内核虚拟空间的页目录表首地址`boot_cr3`（在`kern/mm/pmm.c`的`pmm_init`函数中初始化）
            proc->flags = 0; //进程标志位
ffffffffc0204d66:	0a042823          	sw	zero,176(s0)
            proc->cr3 = boot_cr3;//存储进程的页目录表基址
ffffffffc0204d6a:	f45c                	sd	a5,168(s0)
            memset(proc->name, 0, PROC_NAME_LEN);//进程名
ffffffffc0204d6c:	463d                	li	a2,15
ffffffffc0204d6e:	4581                	li	a1,0
ffffffffc0204d70:	0b440513          	addi	a0,s0,180
ffffffffc0204d74:	48a010ef          	jal	ra,ffffffffc02061fe <memset>


            proc->wait_state = 0; //等待状态
ffffffffc0204d78:	0e042623          	sw	zero,236(s0)
            proc->cptr = proc->yptr = proc->optr = NULL; //设置指针
ffffffffc0204d7c:	10043023          	sd	zero,256(s0)
ffffffffc0204d80:	0e043c23          	sd	zero,248(s0)
ffffffffc0204d84:	0e043823          	sd	zero,240(s0)
    }
    return proc;
}
ffffffffc0204d88:	8522                	mv	a0,s0
ffffffffc0204d8a:	60a2                	ld	ra,8(sp)
ffffffffc0204d8c:	6402                	ld	s0,0(sp)
ffffffffc0204d8e:	0141                	addi	sp,sp,16
ffffffffc0204d90:	8082                	ret

ffffffffc0204d92 <forkret>:
// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
    forkrets(current->tf);
ffffffffc0204d92:	000a7797          	auipc	a5,0xa7
ffffffffc0204d96:	7be78793          	addi	a5,a5,1982 # ffffffffc02ac550 <current>
ffffffffc0204d9a:	639c                	ld	a5,0(a5)
ffffffffc0204d9c:	73c8                	ld	a0,160(a5)
ffffffffc0204d9e:	80cfc06f          	j	ffffffffc0200daa <forkrets>

ffffffffc0204da2 <user_main>:

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204da2:	000a7797          	auipc	a5,0xa7
ffffffffc0204da6:	7ae78793          	addi	a5,a5,1966 # ffffffffc02ac550 <current>
ffffffffc0204daa:	639c                	ld	a5,0(a5)
user_main(void *arg) {
ffffffffc0204dac:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204dae:	00004617          	auipc	a2,0x4
ffffffffc0204db2:	a5260613          	addi	a2,a2,-1454 # ffffffffc0208800 <default_pmm_manager+0x498>
ffffffffc0204db6:	43cc                	lw	a1,4(a5)
ffffffffc0204db8:	00004517          	auipc	a0,0x4
ffffffffc0204dbc:	a5850513          	addi	a0,a0,-1448 # ffffffffc0208810 <default_pmm_manager+0x4a8>
user_main(void *arg) {
ffffffffc0204dc0:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
ffffffffc0204dc2:	b0efb0ef          	jal	ra,ffffffffc02000d0 <cprintf>
ffffffffc0204dc6:	00004797          	auipc	a5,0x4
ffffffffc0204dca:	a3a78793          	addi	a5,a5,-1478 # ffffffffc0208800 <default_pmm_manager+0x498>
ffffffffc0204dce:	3fe05717          	auipc	a4,0x3fe05
ffffffffc0204dd2:	51a70713          	addi	a4,a4,1306 # a2e8 <_binary_obj___user_forktest_out_size>
ffffffffc0204dd6:	e43a                	sd	a4,8(sp)
    int64_t ret=0, len = strlen(name);
ffffffffc0204dd8:	853e                	mv	a0,a5
ffffffffc0204dda:	00089717          	auipc	a4,0x89
ffffffffc0204dde:	86e70713          	addi	a4,a4,-1938 # ffffffffc028d648 <_binary_obj___user_forktest_out_start>
ffffffffc0204de2:	f03a                	sd	a4,32(sp)
ffffffffc0204de4:	f43e                	sd	a5,40(sp)
ffffffffc0204de6:	e802                	sd	zero,16(sp)
ffffffffc0204de8:	378010ef          	jal	ra,ffffffffc0206160 <strlen>
ffffffffc0204dec:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0204dee:	4511                	li	a0,4
ffffffffc0204df0:	55a2                	lw	a1,40(sp)
ffffffffc0204df2:	4662                	lw	a2,24(sp)
ffffffffc0204df4:	5682                	lw	a3,32(sp)
ffffffffc0204df6:	4722                	lw	a4,8(sp)
ffffffffc0204df8:	48a9                	li	a7,10
ffffffffc0204dfa:	9002                	ebreak
ffffffffc0204dfc:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0204dfe:	65c2                	ld	a1,16(sp)
ffffffffc0204e00:	00004517          	auipc	a0,0x4
ffffffffc0204e04:	a3850513          	addi	a0,a0,-1480 # ffffffffc0208838 <default_pmm_manager+0x4d0>
ffffffffc0204e08:	ac8fb0ef          	jal	ra,ffffffffc02000d0 <cprintf>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
ffffffffc0204e0c:	00004617          	auipc	a2,0x4
ffffffffc0204e10:	a3c60613          	addi	a2,a2,-1476 # ffffffffc0208848 <default_pmm_manager+0x4e0>
ffffffffc0204e14:	35200593          	li	a1,850
ffffffffc0204e18:	00004517          	auipc	a0,0x4
ffffffffc0204e1c:	a5050513          	addi	a0,a0,-1456 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0204e20:	bf6fb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204e24 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0204e24:	6d14                	ld	a3,24(a0)
put_pgdir(struct mm_struct *mm) {
ffffffffc0204e26:	1141                	addi	sp,sp,-16
ffffffffc0204e28:	e406                	sd	ra,8(sp)
ffffffffc0204e2a:	c02007b7          	lui	a5,0xc0200
ffffffffc0204e2e:	04f6e263          	bltu	a3,a5,ffffffffc0204e72 <put_pgdir+0x4e>
ffffffffc0204e32:	000a7797          	auipc	a5,0xa7
ffffffffc0204e36:	74e78793          	addi	a5,a5,1870 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0204e3a:	6388                	ld	a0,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0204e3c:	000a7797          	auipc	a5,0xa7
ffffffffc0204e40:	6ec78793          	addi	a5,a5,1772 # ffffffffc02ac528 <npage>
ffffffffc0204e44:	639c                	ld	a5,0(a5)
    return pa2page(PADDR(kva));
ffffffffc0204e46:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage) {
ffffffffc0204e48:	82b1                	srli	a3,a3,0xc
ffffffffc0204e4a:	04f6f063          	bleu	a5,a3,ffffffffc0204e8a <put_pgdir+0x66>
    return &pages[PPN(pa) - nbase];
ffffffffc0204e4e:	00004797          	auipc	a5,0x4
ffffffffc0204e52:	ee278793          	addi	a5,a5,-286 # ffffffffc0208d30 <nbase>
ffffffffc0204e56:	639c                	ld	a5,0(a5)
ffffffffc0204e58:	000a7717          	auipc	a4,0xa7
ffffffffc0204e5c:	73870713          	addi	a4,a4,1848 # ffffffffc02ac590 <pages>
ffffffffc0204e60:	6308                	ld	a0,0(a4)
}
ffffffffc0204e62:	60a2                	ld	ra,8(sp)
ffffffffc0204e64:	8e9d                	sub	a3,a3,a5
ffffffffc0204e66:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0204e68:	4585                	li	a1,1
ffffffffc0204e6a:	9536                	add	a0,a0,a3
}
ffffffffc0204e6c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204e6e:	88cfc06f          	j	ffffffffc0200efa <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0204e72:	00002617          	auipc	a2,0x2
ffffffffc0204e76:	27660613          	addi	a2,a2,630 # ffffffffc02070e8 <commands+0x940>
ffffffffc0204e7a:	06e00593          	li	a1,110
ffffffffc0204e7e:	00002517          	auipc	a0,0x2
ffffffffc0204e82:	1ea50513          	addi	a0,a0,490 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0204e86:	b90fb0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204e8a:	00002617          	auipc	a2,0x2
ffffffffc0204e8e:	1be60613          	addi	a2,a2,446 # ffffffffc0207048 <commands+0x8a0>
ffffffffc0204e92:	06200593          	li	a1,98
ffffffffc0204e96:	00002517          	auipc	a0,0x2
ffffffffc0204e9a:	1d250513          	addi	a0,a0,466 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0204e9e:	b78fb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204ea2 <setup_pgdir>:
setup_pgdir(struct mm_struct *mm) {
ffffffffc0204ea2:	1101                	addi	sp,sp,-32
ffffffffc0204ea4:	e426                	sd	s1,8(sp)
ffffffffc0204ea6:	84aa                	mv	s1,a0
    if ((page = alloc_page()) == NULL) {
ffffffffc0204ea8:	4505                	li	a0,1
setup_pgdir(struct mm_struct *mm) {
ffffffffc0204eaa:	ec06                	sd	ra,24(sp)
ffffffffc0204eac:	e822                	sd	s0,16(sp)
    if ((page = alloc_page()) == NULL) {
ffffffffc0204eae:	fc5fb0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
ffffffffc0204eb2:	c125                	beqz	a0,ffffffffc0204f12 <setup_pgdir+0x70>
    return page - pages + nbase;
ffffffffc0204eb4:	000a7797          	auipc	a5,0xa7
ffffffffc0204eb8:	6dc78793          	addi	a5,a5,1756 # ffffffffc02ac590 <pages>
ffffffffc0204ebc:	6394                	ld	a3,0(a5)
ffffffffc0204ebe:	00004797          	auipc	a5,0x4
ffffffffc0204ec2:	e7278793          	addi	a5,a5,-398 # ffffffffc0208d30 <nbase>
ffffffffc0204ec6:	6380                	ld	s0,0(a5)
ffffffffc0204ec8:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204ecc:	000a7717          	auipc	a4,0xa7
ffffffffc0204ed0:	65c70713          	addi	a4,a4,1628 # ffffffffc02ac528 <npage>
    return page - pages + nbase;
ffffffffc0204ed4:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204ed6:	57fd                	li	a5,-1
ffffffffc0204ed8:	6318                	ld	a4,0(a4)
    return page - pages + nbase;
ffffffffc0204eda:	96a2                	add	a3,a3,s0
    return KADDR(page2pa(page));
ffffffffc0204edc:	83b1                	srli	a5,a5,0xc
ffffffffc0204ede:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ee0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204ee2:	02e7fa63          	bleu	a4,a5,ffffffffc0204f16 <setup_pgdir+0x74>
ffffffffc0204ee6:	000a7797          	auipc	a5,0xa7
ffffffffc0204eea:	69a78793          	addi	a5,a5,1690 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0204eee:	6380                	ld	s0,0(a5)
    memcpy(pgdir, boot_pgdir, PGSIZE);
ffffffffc0204ef0:	000a7797          	auipc	a5,0xa7
ffffffffc0204ef4:	63078793          	addi	a5,a5,1584 # ffffffffc02ac520 <boot_pgdir>
ffffffffc0204ef8:	638c                	ld	a1,0(a5)
ffffffffc0204efa:	9436                	add	s0,s0,a3
ffffffffc0204efc:	6605                	lui	a2,0x1
ffffffffc0204efe:	8522                	mv	a0,s0
ffffffffc0204f00:	310010ef          	jal	ra,ffffffffc0206210 <memcpy>
    return 0;
ffffffffc0204f04:	4501                	li	a0,0
    mm->pgdir = pgdir;
ffffffffc0204f06:	ec80                	sd	s0,24(s1)
}
ffffffffc0204f08:	60e2                	ld	ra,24(sp)
ffffffffc0204f0a:	6442                	ld	s0,16(sp)
ffffffffc0204f0c:	64a2                	ld	s1,8(sp)
ffffffffc0204f0e:	6105                	addi	sp,sp,32
ffffffffc0204f10:	8082                	ret
        return -E_NO_MEM;
ffffffffc0204f12:	5571                	li	a0,-4
ffffffffc0204f14:	bfd5                	j	ffffffffc0204f08 <setup_pgdir+0x66>
ffffffffc0204f16:	00002617          	auipc	a2,0x2
ffffffffc0204f1a:	0fa60613          	addi	a2,a2,250 # ffffffffc0207010 <commands+0x868>
ffffffffc0204f1e:	06900593          	li	a1,105
ffffffffc0204f22:	00002517          	auipc	a0,0x2
ffffffffc0204f26:	14650513          	addi	a0,a0,326 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0204f2a:	aecfb0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0204f2e <set_proc_name>:
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc0204f2e:	1101                	addi	sp,sp,-32
ffffffffc0204f30:	e822                	sd	s0,16(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f32:	0b450413          	addi	s0,a0,180
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc0204f36:	e426                	sd	s1,8(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f38:	4641                	li	a2,16
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc0204f3a:	84ae                	mv	s1,a1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f3c:	8522                	mv	a0,s0
ffffffffc0204f3e:	4581                	li	a1,0
set_proc_name(struct proc_struct *proc, const char *name) {
ffffffffc0204f40:	ec06                	sd	ra,24(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f42:	2bc010ef          	jal	ra,ffffffffc02061fe <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f46:	8522                	mv	a0,s0
}
ffffffffc0204f48:	6442                	ld	s0,16(sp)
ffffffffc0204f4a:	60e2                	ld	ra,24(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f4c:	85a6                	mv	a1,s1
}
ffffffffc0204f4e:	64a2                	ld	s1,8(sp)
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f50:	463d                	li	a2,15
}
ffffffffc0204f52:	6105                	addi	sp,sp,32
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f54:	2bc0106f          	j	ffffffffc0206210 <memcpy>

ffffffffc0204f58 <proc_run>:
proc_run(struct proc_struct *proc) {
ffffffffc0204f58:	1101                	addi	sp,sp,-32
    if (proc != current) {
ffffffffc0204f5a:	000a7797          	auipc	a5,0xa7
ffffffffc0204f5e:	5f678793          	addi	a5,a5,1526 # ffffffffc02ac550 <current>
proc_run(struct proc_struct *proc) {
ffffffffc0204f62:	e426                	sd	s1,8(sp)
    if (proc != current) {
ffffffffc0204f64:	6384                	ld	s1,0(a5)
proc_run(struct proc_struct *proc) {
ffffffffc0204f66:	ec06                	sd	ra,24(sp)
ffffffffc0204f68:	e822                	sd	s0,16(sp)
ffffffffc0204f6a:	e04a                	sd	s2,0(sp)
    if (proc != current) {
ffffffffc0204f6c:	02a48b63          	beq	s1,a0,ffffffffc0204fa2 <proc_run+0x4a>
ffffffffc0204f70:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204f72:	100027f3          	csrr	a5,sstatus
ffffffffc0204f76:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204f78:	4901                	li	s2,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0204f7a:	e3a9                	bnez	a5,ffffffffc0204fbc <proc_run+0x64>

#define barrier() __asm__ __volatile__ ("fence" ::: "memory")

static inline void
lcr3(unsigned long cr3) {
    write_csr(satp, 0x8000000000000000 | (cr3 >> RISCV_PGSHIFT));
ffffffffc0204f7c:	745c                	ld	a5,168(s0)
        current = proc; //切换
ffffffffc0204f7e:	000a7717          	auipc	a4,0xa7
ffffffffc0204f82:	5c873923          	sd	s0,1490(a4) # ffffffffc02ac550 <current>
ffffffffc0204f86:	577d                	li	a4,-1
ffffffffc0204f88:	177e                	slli	a4,a4,0x3f
ffffffffc0204f8a:	83b1                	srli	a5,a5,0xc
ffffffffc0204f8c:	8fd9                	or	a5,a5,a4
ffffffffc0204f8e:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(next->context));
ffffffffc0204f92:	03040593          	addi	a1,s0,48
ffffffffc0204f96:	03048513          	addi	a0,s1,48
ffffffffc0204f9a:	d1bff0ef          	jal	ra,ffffffffc0204cb4 <switch_to>
    if (flag) {
ffffffffc0204f9e:	00091863          	bnez	s2,ffffffffc0204fae <proc_run+0x56>
}
ffffffffc0204fa2:	60e2                	ld	ra,24(sp)
ffffffffc0204fa4:	6442                	ld	s0,16(sp)
ffffffffc0204fa6:	64a2                	ld	s1,8(sp)
ffffffffc0204fa8:	6902                	ld	s2,0(sp)
ffffffffc0204faa:	6105                	addi	sp,sp,32
ffffffffc0204fac:	8082                	ret
ffffffffc0204fae:	6442                	ld	s0,16(sp)
ffffffffc0204fb0:	60e2                	ld	ra,24(sp)
ffffffffc0204fb2:	64a2                	ld	s1,8(sp)
ffffffffc0204fb4:	6902                	ld	s2,0(sp)
ffffffffc0204fb6:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0204fb8:	e9efb06f          	j	ffffffffc0200656 <intr_enable>
        intr_disable();
ffffffffc0204fbc:	ea0fb0ef          	jal	ra,ffffffffc020065c <intr_disable>
        return 1;
ffffffffc0204fc0:	4905                	li	s2,1
ffffffffc0204fc2:	bf6d                	j	ffffffffc0204f7c <proc_run+0x24>

ffffffffc0204fc4 <find_proc>:
    if (0 < pid && pid < MAX_PID) {
ffffffffc0204fc4:	0005071b          	sext.w	a4,a0
ffffffffc0204fc8:	6789                	lui	a5,0x2
ffffffffc0204fca:	fff7069b          	addiw	a3,a4,-1
ffffffffc0204fce:	17f9                	addi	a5,a5,-2
ffffffffc0204fd0:	04d7e063          	bltu	a5,a3,ffffffffc0205010 <find_proc+0x4c>
find_proc(int pid) {
ffffffffc0204fd4:	1141                	addi	sp,sp,-16
ffffffffc0204fd6:	e022                	sd	s0,0(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204fd8:	45a9                	li	a1,10
ffffffffc0204fda:	842a                	mv	s0,a0
ffffffffc0204fdc:	853a                	mv	a0,a4
find_proc(int pid) {
ffffffffc0204fde:	e406                	sd	ra,8(sp)
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204fe0:	640010ef          	jal	ra,ffffffffc0206620 <hash32>
ffffffffc0204fe4:	02051693          	slli	a3,a0,0x20
ffffffffc0204fe8:	82f1                	srli	a3,a3,0x1c
ffffffffc0204fea:	000a3517          	auipc	a0,0xa3
ffffffffc0204fee:	52650513          	addi	a0,a0,1318 # ffffffffc02a8510 <hash_list>
ffffffffc0204ff2:	96aa                	add	a3,a3,a0
ffffffffc0204ff4:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list) {
ffffffffc0204ff6:	a029                	j	ffffffffc0205000 <find_proc+0x3c>
            if (proc->pid == pid) {
ffffffffc0204ff8:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x765c>
ffffffffc0204ffc:	00870c63          	beq	a4,s0,ffffffffc0205014 <find_proc+0x50>
    return listelm->next;
ffffffffc0205000:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list) {
ffffffffc0205002:	fef69be3          	bne	a3,a5,ffffffffc0204ff8 <find_proc+0x34>
}
ffffffffc0205006:	60a2                	ld	ra,8(sp)
ffffffffc0205008:	6402                	ld	s0,0(sp)
    return NULL;
ffffffffc020500a:	4501                	li	a0,0
}
ffffffffc020500c:	0141                	addi	sp,sp,16
ffffffffc020500e:	8082                	ret
    return NULL;
ffffffffc0205010:	4501                	li	a0,0
}
ffffffffc0205012:	8082                	ret
ffffffffc0205014:	60a2                	ld	ra,8(sp)
ffffffffc0205016:	6402                	ld	s0,0(sp)
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205018:	f2878513          	addi	a0,a5,-216
}
ffffffffc020501c:	0141                	addi	sp,sp,16
ffffffffc020501e:	8082                	ret

ffffffffc0205020 <do_fork>:
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0205020:	7159                	addi	sp,sp,-112
ffffffffc0205022:	e0d2                	sd	s4,64(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0205024:	000a7a17          	auipc	s4,0xa7
ffffffffc0205028:	544a0a13          	addi	s4,s4,1348 # ffffffffc02ac568 <nr_process>
ffffffffc020502c:	000a2703          	lw	a4,0(s4)
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
ffffffffc0205030:	f486                	sd	ra,104(sp)
ffffffffc0205032:	f0a2                	sd	s0,96(sp)
ffffffffc0205034:	eca6                	sd	s1,88(sp)
ffffffffc0205036:	e8ca                	sd	s2,80(sp)
ffffffffc0205038:	e4ce                	sd	s3,72(sp)
ffffffffc020503a:	fc56                	sd	s5,56(sp)
ffffffffc020503c:	f85a                	sd	s6,48(sp)
ffffffffc020503e:	f45e                	sd	s7,40(sp)
ffffffffc0205040:	f062                	sd	s8,32(sp)
ffffffffc0205042:	ec66                	sd	s9,24(sp)
ffffffffc0205044:	e86a                	sd	s10,16(sp)
ffffffffc0205046:	e46e                	sd	s11,8(sp)
    if (nr_process >= MAX_PROCESS) {
ffffffffc0205048:	6785                	lui	a5,0x1
ffffffffc020504a:	30f75b63          	ble	a5,a4,ffffffffc0205360 <do_fork+0x340>
ffffffffc020504e:	89aa                	mv	s3,a0
ffffffffc0205050:	892e                	mv	s2,a1
ffffffffc0205052:	84b2                	mv	s1,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc0205054:	ccbff0ef          	jal	ra,ffffffffc0204d1e <alloc_proc>
ffffffffc0205058:	842a                	mv	s0,a0
ffffffffc020505a:	2e050563          	beqz	a0,ffffffffc0205344 <do_fork+0x324>
    proc->parent = current;//新创建的进程的父进程指向当前进程
ffffffffc020505e:	000a7c17          	auipc	s8,0xa7
ffffffffc0205062:	4f2c0c13          	addi	s8,s8,1266 # ffffffffc02ac550 <current>
ffffffffc0205066:	000c3783          	ld	a5,0(s8)
    assert(current->wait_state == 0);  
ffffffffc020506a:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_obj___user_faultread_out_size-0x849c>
    proc->parent = current;//新创建的进程的父进程指向当前进程
ffffffffc020506e:	f11c                	sd	a5,32(a0)
    assert(current->wait_state == 0);  
ffffffffc0205070:	30071663          	bnez	a4,ffffffffc020537c <do_fork+0x35c>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0205074:	4509                	li	a0,2
ffffffffc0205076:	dfdfb0ef          	jal	ra,ffffffffc0200e72 <alloc_pages>
    if (page != NULL) {
ffffffffc020507a:	2c050263          	beqz	a0,ffffffffc020533e <do_fork+0x31e>
    return page - pages + nbase;
ffffffffc020507e:	000a7a97          	auipc	s5,0xa7
ffffffffc0205082:	512a8a93          	addi	s5,s5,1298 # ffffffffc02ac590 <pages>
ffffffffc0205086:	000ab683          	ld	a3,0(s5)
ffffffffc020508a:	00004b17          	auipc	s6,0x4
ffffffffc020508e:	ca6b0b13          	addi	s6,s6,-858 # ffffffffc0208d30 <nbase>
ffffffffc0205092:	000b3783          	ld	a5,0(s6)
ffffffffc0205096:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc020509a:	000a7b97          	auipc	s7,0xa7
ffffffffc020509e:	48eb8b93          	addi	s7,s7,1166 # ffffffffc02ac528 <npage>
    return page - pages + nbase;
ffffffffc02050a2:	8699                	srai	a3,a3,0x6
ffffffffc02050a4:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc02050a6:	000bb703          	ld	a4,0(s7)
ffffffffc02050aa:	57fd                	li	a5,-1
ffffffffc02050ac:	83b1                	srli	a5,a5,0xc
ffffffffc02050ae:	8ff5                	and	a5,a5,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02050b0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02050b2:	2ae7f963          	bleu	a4,a5,ffffffffc0205364 <do_fork+0x344>
ffffffffc02050b6:	000a7c97          	auipc	s9,0xa7
ffffffffc02050ba:	4cac8c93          	addi	s9,s9,1226 # ffffffffc02ac580 <va_pa_offset>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc02050be:	000c3703          	ld	a4,0(s8)
ffffffffc02050c2:	000cb783          	ld	a5,0(s9)
ffffffffc02050c6:	02873c03          	ld	s8,40(a4)
ffffffffc02050ca:	96be                	add	a3,a3,a5
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02050cc:	e814                	sd	a3,16(s0)
    if (oldmm == NULL) {
ffffffffc02050ce:	020c0863          	beqz	s8,ffffffffc02050fe <do_fork+0xde>
    if (clone_flags & CLONE_VM) {
ffffffffc02050d2:	1009f993          	andi	s3,s3,256
ffffffffc02050d6:	1e098263          	beqz	s3,ffffffffc02052ba <do_fork+0x29a>
}

static inline int
mm_count_inc(struct mm_struct *mm) {
    mm->mm_count += 1;
ffffffffc02050da:	030c2703          	lw	a4,48(s8)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc02050de:	018c3783          	ld	a5,24(s8)
ffffffffc02050e2:	c02006b7          	lui	a3,0xc0200
ffffffffc02050e6:	2705                	addiw	a4,a4,1
ffffffffc02050e8:	02ec2823          	sw	a4,48(s8)
    proc->mm = mm;
ffffffffc02050ec:	03843423          	sd	s8,40(s0)
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc02050f0:	2ad7e663          	bltu	a5,a3,ffffffffc020539c <do_fork+0x37c>
ffffffffc02050f4:	000cb703          	ld	a4,0(s9)
ffffffffc02050f8:	6814                	ld	a3,16(s0)
ffffffffc02050fa:	8f99                	sub	a5,a5,a4
ffffffffc02050fc:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02050fe:	6789                	lui	a5,0x2
ffffffffc0205100:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x76a8>
ffffffffc0205104:	96be                	add	a3,a3,a5
ffffffffc0205106:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc0205108:	87b6                	mv	a5,a3
ffffffffc020510a:	12048813          	addi	a6,s1,288
ffffffffc020510e:	6088                	ld	a0,0(s1)
ffffffffc0205110:	648c                	ld	a1,8(s1)
ffffffffc0205112:	6890                	ld	a2,16(s1)
ffffffffc0205114:	6c98                	ld	a4,24(s1)
ffffffffc0205116:	e388                	sd	a0,0(a5)
ffffffffc0205118:	e78c                	sd	a1,8(a5)
ffffffffc020511a:	eb90                	sd	a2,16(a5)
ffffffffc020511c:	ef98                	sd	a4,24(a5)
ffffffffc020511e:	02048493          	addi	s1,s1,32
ffffffffc0205122:	02078793          	addi	a5,a5,32
ffffffffc0205126:	ff0494e3          	bne	s1,a6,ffffffffc020510e <do_fork+0xee>
    proc->tf->gpr.a0 = 0;
ffffffffc020512a:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x1a>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020512e:	12090f63          	beqz	s2,ffffffffc020526c <do_fork+0x24c>
ffffffffc0205132:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0205136:	00000797          	auipc	a5,0x0
ffffffffc020513a:	c5c78793          	addi	a5,a5,-932 # ffffffffc0204d92 <forkret>
ffffffffc020513e:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0205140:	fc14                	sd	a3,56(s0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205142:	100027f3          	csrr	a5,sstatus
ffffffffc0205146:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205148:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020514a:	14079063          	bnez	a5,ffffffffc020528a <do_fork+0x26a>
    if (++ last_pid >= MAX_PID) {
ffffffffc020514e:	0009c797          	auipc	a5,0x9c
ffffffffc0205152:	fba78793          	addi	a5,a5,-70 # ffffffffc02a1108 <last_pid.1691>
ffffffffc0205156:	439c                	lw	a5,0(a5)
ffffffffc0205158:	6709                	lui	a4,0x2
ffffffffc020515a:	0017851b          	addiw	a0,a5,1
ffffffffc020515e:	0009c697          	auipc	a3,0x9c
ffffffffc0205162:	faa6a523          	sw	a0,-86(a3) # ffffffffc02a1108 <last_pid.1691>
ffffffffc0205166:	14e55363          	ble	a4,a0,ffffffffc02052ac <do_fork+0x28c>
    if (last_pid >= next_safe) {
ffffffffc020516a:	0009c797          	auipc	a5,0x9c
ffffffffc020516e:	fa278793          	addi	a5,a5,-94 # ffffffffc02a110c <next_safe.1690>
ffffffffc0205172:	439c                	lw	a5,0(a5)
ffffffffc0205174:	000a7617          	auipc	a2,0xa7
ffffffffc0205178:	51c60613          	addi	a2,a2,1308 # ffffffffc02ac690 <proc_list>
ffffffffc020517c:	06f54163          	blt	a0,a5,ffffffffc02051de <do_fork+0x1be>
        next_safe = MAX_PID;
ffffffffc0205180:	6789                	lui	a5,0x2
ffffffffc0205182:	0009c717          	auipc	a4,0x9c
ffffffffc0205186:	f8f72523          	sw	a5,-118(a4) # ffffffffc02a110c <next_safe.1690>
ffffffffc020518a:	4801                	li	a6,0
ffffffffc020518c:	87aa                	mv	a5,a0
ffffffffc020518e:	000a7617          	auipc	a2,0xa7
ffffffffc0205192:	50260613          	addi	a2,a2,1282 # ffffffffc02ac690 <proc_list>
    repeat:
ffffffffc0205196:	6309                	lui	t1,0x2
ffffffffc0205198:	88c2                	mv	a7,a6
ffffffffc020519a:	6589                	lui	a1,0x2
        le = list;
ffffffffc020519c:	000a7697          	auipc	a3,0xa7
ffffffffc02051a0:	4f468693          	addi	a3,a3,1268 # ffffffffc02ac690 <proc_list>
ffffffffc02051a4:	6694                	ld	a3,8(a3)
        while ((le = list_next(le)) != list) {
ffffffffc02051a6:	00c68f63          	beq	a3,a2,ffffffffc02051c4 <do_fork+0x1a4>
            if (proc->pid == last_pid) {
ffffffffc02051aa:	f3c6a703          	lw	a4,-196(a3)
ffffffffc02051ae:	0ae78a63          	beq	a5,a4,ffffffffc0205262 <do_fork+0x242>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
ffffffffc02051b2:	fee7d9e3          	ble	a4,a5,ffffffffc02051a4 <do_fork+0x184>
ffffffffc02051b6:	feb757e3          	ble	a1,a4,ffffffffc02051a4 <do_fork+0x184>
ffffffffc02051ba:	6694                	ld	a3,8(a3)
ffffffffc02051bc:	85ba                	mv	a1,a4
ffffffffc02051be:	4885                	li	a7,1
        while ((le = list_next(le)) != list) {
ffffffffc02051c0:	fec695e3          	bne	a3,a2,ffffffffc02051aa <do_fork+0x18a>
ffffffffc02051c4:	00080763          	beqz	a6,ffffffffc02051d2 <do_fork+0x1b2>
ffffffffc02051c8:	0009c717          	auipc	a4,0x9c
ffffffffc02051cc:	f4f72023          	sw	a5,-192(a4) # ffffffffc02a1108 <last_pid.1691>
ffffffffc02051d0:	853e                	mv	a0,a5
ffffffffc02051d2:	00088663          	beqz	a7,ffffffffc02051de <do_fork+0x1be>
ffffffffc02051d6:	0009c797          	auipc	a5,0x9c
ffffffffc02051da:	f2b7ab23          	sw	a1,-202(a5) # ffffffffc02a110c <next_safe.1690>
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc02051de:	7018                	ld	a4,32(s0)
    __list_add(elm, listelm, listelm->next);
ffffffffc02051e0:	6614                	ld	a3,8(a2)
    list_add(&proc_list, &(proc->list_link));
ffffffffc02051e2:	0c840593          	addi	a1,s0,200
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc02051e6:	7b7c                	ld	a5,240(a4)
    proc->pid = get_pid();
ffffffffc02051e8:	c048                	sw	a0,4(s0)
    prev->next = next->prev = elm;
ffffffffc02051ea:	e28c                	sd	a1,0(a3)
ffffffffc02051ec:	000a7817          	auipc	a6,0xa7
ffffffffc02051f0:	4ab83623          	sd	a1,1196(a6) # ffffffffc02ac698 <proc_list+0x8>
    elm->next = next;
ffffffffc02051f4:	e874                	sd	a3,208(s0)
    elm->prev = prev;
ffffffffc02051f6:	e470                	sd	a2,200(s0)
    proc->yptr = NULL;
ffffffffc02051f8:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL) {
ffffffffc02051fc:	10f43023          	sd	a5,256(s0)
ffffffffc0205200:	c391                	beqz	a5,ffffffffc0205204 <do_fork+0x1e4>
        proc->optr->yptr = proc;
ffffffffc0205202:	ffe0                	sd	s0,248(a5)
    nr_process ++;
ffffffffc0205204:	000a2783          	lw	a5,0(s4)
    proc->parent->cptr = proc;
ffffffffc0205208:	fb60                	sd	s0,240(a4)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020520a:	45a9                	li	a1,10
    nr_process ++;
ffffffffc020520c:	2785                	addiw	a5,a5,1
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020520e:	2501                	sext.w	a0,a0
    nr_process ++;
ffffffffc0205210:	000a7717          	auipc	a4,0xa7
ffffffffc0205214:	34f72c23          	sw	a5,856(a4) # ffffffffc02ac568 <nr_process>
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0205218:	408010ef          	jal	ra,ffffffffc0206620 <hash32>
ffffffffc020521c:	1502                	slli	a0,a0,0x20
ffffffffc020521e:	000a3797          	auipc	a5,0xa3
ffffffffc0205222:	2f278793          	addi	a5,a5,754 # ffffffffc02a8510 <hash_list>
ffffffffc0205226:	8171                	srli	a0,a0,0x1c
ffffffffc0205228:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc020522a:	651c                	ld	a5,8(a0)
ffffffffc020522c:	0d840713          	addi	a4,s0,216
    prev->next = next->prev = elm;
ffffffffc0205230:	e398                	sd	a4,0(a5)
ffffffffc0205232:	e518                	sd	a4,8(a0)
    elm->next = next;
ffffffffc0205234:	f07c                	sd	a5,224(s0)
    elm->prev = prev;
ffffffffc0205236:	ec68                	sd	a0,216(s0)
    if (flag) {
ffffffffc0205238:	10049863          	bnez	s1,ffffffffc0205348 <do_fork+0x328>
    wakeup_proc(proc); //状态设为PROC_RUNNABLE，可调度
ffffffffc020523c:	8522                	mv	a0,s0
ffffffffc020523e:	531000ef          	jal	ra,ffffffffc0205f6e <wakeup_proc>
    ret = proc->pid; //返回值为pid，创建成功
ffffffffc0205242:	4048                	lw	a0,4(s0)
}
ffffffffc0205244:	70a6                	ld	ra,104(sp)
ffffffffc0205246:	7406                	ld	s0,96(sp)
ffffffffc0205248:	64e6                	ld	s1,88(sp)
ffffffffc020524a:	6946                	ld	s2,80(sp)
ffffffffc020524c:	69a6                	ld	s3,72(sp)
ffffffffc020524e:	6a06                	ld	s4,64(sp)
ffffffffc0205250:	7ae2                	ld	s5,56(sp)
ffffffffc0205252:	7b42                	ld	s6,48(sp)
ffffffffc0205254:	7ba2                	ld	s7,40(sp)
ffffffffc0205256:	7c02                	ld	s8,32(sp)
ffffffffc0205258:	6ce2                	ld	s9,24(sp)
ffffffffc020525a:	6d42                	ld	s10,16(sp)
ffffffffc020525c:	6da2                	ld	s11,8(sp)
ffffffffc020525e:	6165                	addi	sp,sp,112
ffffffffc0205260:	8082                	ret
                if (++ last_pid >= next_safe) {
ffffffffc0205262:	2785                	addiw	a5,a5,1
ffffffffc0205264:	0eb7d563          	ble	a1,a5,ffffffffc020534e <do_fork+0x32e>
ffffffffc0205268:	4805                	li	a6,1
ffffffffc020526a:	bf2d                	j	ffffffffc02051a4 <do_fork+0x184>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020526c:	8936                	mv	s2,a3
ffffffffc020526e:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0205272:	00000797          	auipc	a5,0x0
ffffffffc0205276:	b2078793          	addi	a5,a5,-1248 # ffffffffc0204d92 <forkret>
ffffffffc020527a:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc020527c:	fc14                	sd	a3,56(s0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020527e:	100027f3          	csrr	a5,sstatus
ffffffffc0205282:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205284:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205286:	ec0784e3          	beqz	a5,ffffffffc020514e <do_fork+0x12e>
        intr_disable();
ffffffffc020528a:	bd2fb0ef          	jal	ra,ffffffffc020065c <intr_disable>
    if (++ last_pid >= MAX_PID) {
ffffffffc020528e:	0009c797          	auipc	a5,0x9c
ffffffffc0205292:	e7a78793          	addi	a5,a5,-390 # ffffffffc02a1108 <last_pid.1691>
ffffffffc0205296:	439c                	lw	a5,0(a5)
ffffffffc0205298:	6709                	lui	a4,0x2
        return 1;
ffffffffc020529a:	4485                	li	s1,1
ffffffffc020529c:	0017851b          	addiw	a0,a5,1
ffffffffc02052a0:	0009c697          	auipc	a3,0x9c
ffffffffc02052a4:	e6a6a423          	sw	a0,-408(a3) # ffffffffc02a1108 <last_pid.1691>
ffffffffc02052a8:	ece541e3          	blt	a0,a4,ffffffffc020516a <do_fork+0x14a>
        last_pid = 1;
ffffffffc02052ac:	4785                	li	a5,1
ffffffffc02052ae:	0009c717          	auipc	a4,0x9c
ffffffffc02052b2:	e4f72d23          	sw	a5,-422(a4) # ffffffffc02a1108 <last_pid.1691>
ffffffffc02052b6:	4505                	li	a0,1
ffffffffc02052b8:	b5e1                	j	ffffffffc0205180 <do_fork+0x160>
    if ((mm = mm_create()) == NULL) {
ffffffffc02052ba:	cfefd0ef          	jal	ra,ffffffffc02027b8 <mm_create>
ffffffffc02052be:	8d2a                	mv	s10,a0
ffffffffc02052c0:	c539                	beqz	a0,ffffffffc020530e <do_fork+0x2ee>
    if (setup_pgdir(mm) != 0) {
ffffffffc02052c2:	be1ff0ef          	jal	ra,ffffffffc0204ea2 <setup_pgdir>
ffffffffc02052c6:	e949                	bnez	a0,ffffffffc0205358 <do_fork+0x338>
}

static inline void
lock_mm(struct mm_struct *mm) {
    if (mm != NULL) {
        lock(&(mm->mm_lock));
ffffffffc02052c8:	038c0d93          	addi	s11,s8,56
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02052cc:	4785                	li	a5,1
ffffffffc02052ce:	40fdb7af          	amoor.d	a5,a5,(s11)
ffffffffc02052d2:	8b85                	andi	a5,a5,1
ffffffffc02052d4:	4985                	li	s3,1
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
ffffffffc02052d6:	c799                	beqz	a5,ffffffffc02052e4 <do_fork+0x2c4>
        schedule();
ffffffffc02052d8:	513000ef          	jal	ra,ffffffffc0205fea <schedule>
ffffffffc02052dc:	413db7af          	amoor.d	a5,s3,(s11)
ffffffffc02052e0:	8b85                	andi	a5,a5,1
    while (!try_lock(lock)) {
ffffffffc02052e2:	fbfd                	bnez	a5,ffffffffc02052d8 <do_fork+0x2b8>
        ret = dup_mmap(mm, oldmm);
ffffffffc02052e4:	85e2                	mv	a1,s8
ffffffffc02052e6:	856a                	mv	a0,s10
ffffffffc02052e8:	f5afd0ef          	jal	ra,ffffffffc0202a42 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02052ec:	57f9                	li	a5,-2
ffffffffc02052ee:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02052f2:	8b85                	andi	a5,a5,1
    }
}

static inline void
unlock(lock_t *lock) {
    if (!test_and_clear_bit(0, lock)) {
ffffffffc02052f4:	c3e9                	beqz	a5,ffffffffc02053b6 <do_fork+0x396>
    if (ret != 0) {
ffffffffc02052f6:	8c6a                	mv	s8,s10
ffffffffc02052f8:	de0501e3          	beqz	a0,ffffffffc02050da <do_fork+0xba>
    exit_mmap(mm);
ffffffffc02052fc:	856a                	mv	a0,s10
ffffffffc02052fe:	fe0fd0ef          	jal	ra,ffffffffc0202ade <exit_mmap>
    put_pgdir(mm);
ffffffffc0205302:	856a                	mv	a0,s10
ffffffffc0205304:	b21ff0ef          	jal	ra,ffffffffc0204e24 <put_pgdir>
    mm_destroy(mm);
ffffffffc0205308:	856a                	mv	a0,s10
ffffffffc020530a:	e34fd0ef          	jal	ra,ffffffffc020293e <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020530e:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0205310:	c02007b7          	lui	a5,0xc0200
ffffffffc0205314:	0cf6e963          	bltu	a3,a5,ffffffffc02053e6 <do_fork+0x3c6>
ffffffffc0205318:	000cb783          	ld	a5,0(s9)
    if (PPN(pa) >= npage) {
ffffffffc020531c:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc0205320:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage) {
ffffffffc0205324:	83b1                	srli	a5,a5,0xc
ffffffffc0205326:	0ae7f463          	bleu	a4,a5,ffffffffc02053ce <do_fork+0x3ae>
    return &pages[PPN(pa) - nbase];
ffffffffc020532a:	000b3703          	ld	a4,0(s6)
ffffffffc020532e:	000ab503          	ld	a0,0(s5)
ffffffffc0205332:	4589                	li	a1,2
ffffffffc0205334:	8f99                	sub	a5,a5,a4
ffffffffc0205336:	079a                	slli	a5,a5,0x6
ffffffffc0205338:	953e                	add	a0,a0,a5
ffffffffc020533a:	bc1fb0ef          	jal	ra,ffffffffc0200efa <free_pages>
    kfree(proc);
ffffffffc020533e:	8522                	mv	a0,s0
ffffffffc0205340:	a64fe0ef          	jal	ra,ffffffffc02035a4 <kfree>
    ret = -E_NO_MEM;
ffffffffc0205344:	5571                	li	a0,-4
    return ret;
ffffffffc0205346:	bdfd                	j	ffffffffc0205244 <do_fork+0x224>
        intr_enable();
ffffffffc0205348:	b0efb0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc020534c:	bdc5                	j	ffffffffc020523c <do_fork+0x21c>
                    if (last_pid >= MAX_PID) {
ffffffffc020534e:	0067c363          	blt	a5,t1,ffffffffc0205354 <do_fork+0x334>
                        last_pid = 1;
ffffffffc0205352:	4785                	li	a5,1
                    goto repeat;
ffffffffc0205354:	4805                	li	a6,1
ffffffffc0205356:	b589                	j	ffffffffc0205198 <do_fork+0x178>
    mm_destroy(mm);
ffffffffc0205358:	856a                	mv	a0,s10
ffffffffc020535a:	de4fd0ef          	jal	ra,ffffffffc020293e <mm_destroy>
ffffffffc020535e:	bf45                	j	ffffffffc020530e <do_fork+0x2ee>
    int ret = -E_NO_FREE_PROC;
ffffffffc0205360:	556d                	li	a0,-5
ffffffffc0205362:	b5cd                	j	ffffffffc0205244 <do_fork+0x224>
    return KADDR(page2pa(page));
ffffffffc0205364:	00002617          	auipc	a2,0x2
ffffffffc0205368:	cac60613          	addi	a2,a2,-852 # ffffffffc0207010 <commands+0x868>
ffffffffc020536c:	06900593          	li	a1,105
ffffffffc0205370:	00002517          	auipc	a0,0x2
ffffffffc0205374:	cf850513          	addi	a0,a0,-776 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0205378:	e9ffa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(current->wait_state == 0);  
ffffffffc020537c:	00003697          	auipc	a3,0x3
ffffffffc0205380:	25c68693          	addi	a3,a3,604 # ffffffffc02085d8 <default_pmm_manager+0x270>
ffffffffc0205384:	00002617          	auipc	a2,0x2
ffffffffc0205388:	8a460613          	addi	a2,a2,-1884 # ffffffffc0206c28 <commands+0x480>
ffffffffc020538c:	1b500593          	li	a1,437
ffffffffc0205390:	00003517          	auipc	a0,0x3
ffffffffc0205394:	4d850513          	addi	a0,a0,1240 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205398:	e7ffa0ef          	jal	ra,ffffffffc0200216 <__panic>
    proc->cr3 = PADDR(mm->pgdir);
ffffffffc020539c:	86be                	mv	a3,a5
ffffffffc020539e:	00002617          	auipc	a2,0x2
ffffffffc02053a2:	d4a60613          	addi	a2,a2,-694 # ffffffffc02070e8 <commands+0x940>
ffffffffc02053a6:	16700593          	li	a1,359
ffffffffc02053aa:	00003517          	auipc	a0,0x3
ffffffffc02053ae:	4be50513          	addi	a0,a0,1214 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc02053b2:	e65fa0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("Unlock failed.\n");
ffffffffc02053b6:	00003617          	auipc	a2,0x3
ffffffffc02053ba:	24260613          	addi	a2,a2,578 # ffffffffc02085f8 <default_pmm_manager+0x290>
ffffffffc02053be:	03100593          	li	a1,49
ffffffffc02053c2:	00003517          	auipc	a0,0x3
ffffffffc02053c6:	24650513          	addi	a0,a0,582 # ffffffffc0208608 <default_pmm_manager+0x2a0>
ffffffffc02053ca:	e4dfa0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02053ce:	00002617          	auipc	a2,0x2
ffffffffc02053d2:	c7a60613          	addi	a2,a2,-902 # ffffffffc0207048 <commands+0x8a0>
ffffffffc02053d6:	06200593          	li	a1,98
ffffffffc02053da:	00002517          	auipc	a0,0x2
ffffffffc02053de:	c8e50513          	addi	a0,a0,-882 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02053e2:	e35fa0ef          	jal	ra,ffffffffc0200216 <__panic>
    return pa2page(PADDR(kva));
ffffffffc02053e6:	00002617          	auipc	a2,0x2
ffffffffc02053ea:	d0260613          	addi	a2,a2,-766 # ffffffffc02070e8 <commands+0x940>
ffffffffc02053ee:	06e00593          	li	a1,110
ffffffffc02053f2:	00002517          	auipc	a0,0x2
ffffffffc02053f6:	c7650513          	addi	a0,a0,-906 # ffffffffc0207068 <commands+0x8c0>
ffffffffc02053fa:	e1dfa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc02053fe <kernel_thread>:
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc02053fe:	7129                	addi	sp,sp,-320
ffffffffc0205400:	fa22                	sd	s0,304(sp)
ffffffffc0205402:	f626                	sd	s1,296(sp)
ffffffffc0205404:	f24a                	sd	s2,288(sp)
ffffffffc0205406:	84ae                	mv	s1,a1
ffffffffc0205408:	892a                	mv	s2,a0
ffffffffc020540a:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020540c:	4581                	li	a1,0
ffffffffc020540e:	12000613          	li	a2,288
ffffffffc0205412:	850a                	mv	a0,sp
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
ffffffffc0205414:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0205416:	5e9000ef          	jal	ra,ffffffffc02061fe <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020541a:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020541c:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc020541e:	100027f3          	csrr	a5,sstatus
ffffffffc0205422:	edd7f793          	andi	a5,a5,-291
ffffffffc0205426:	1207e793          	ori	a5,a5,288
ffffffffc020542a:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020542c:	860a                	mv	a2,sp
ffffffffc020542e:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0205432:	00000797          	auipc	a5,0x0
ffffffffc0205436:	87a78793          	addi	a5,a5,-1926 # ffffffffc0204cac <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020543a:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020543c:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020543e:	be3ff0ef          	jal	ra,ffffffffc0205020 <do_fork>
}
ffffffffc0205442:	70f2                	ld	ra,312(sp)
ffffffffc0205444:	7452                	ld	s0,304(sp)
ffffffffc0205446:	74b2                	ld	s1,296(sp)
ffffffffc0205448:	7912                	ld	s2,288(sp)
ffffffffc020544a:	6131                	addi	sp,sp,320
ffffffffc020544c:	8082                	ret

ffffffffc020544e <do_exit>:
do_exit(int error_code) {
ffffffffc020544e:	7179                	addi	sp,sp,-48
ffffffffc0205450:	e84a                	sd	s2,16(sp)
    if (current == idleproc) {
ffffffffc0205452:	000a7717          	auipc	a4,0xa7
ffffffffc0205456:	10670713          	addi	a4,a4,262 # ffffffffc02ac558 <idleproc>
ffffffffc020545a:	000a7917          	auipc	s2,0xa7
ffffffffc020545e:	0f690913          	addi	s2,s2,246 # ffffffffc02ac550 <current>
ffffffffc0205462:	00093783          	ld	a5,0(s2)
ffffffffc0205466:	6318                	ld	a4,0(a4)
do_exit(int error_code) {
ffffffffc0205468:	f406                	sd	ra,40(sp)
ffffffffc020546a:	f022                	sd	s0,32(sp)
ffffffffc020546c:	ec26                	sd	s1,24(sp)
ffffffffc020546e:	e44e                	sd	s3,8(sp)
ffffffffc0205470:	e052                	sd	s4,0(sp)
    if (current == idleproc) {
ffffffffc0205472:	0ce78c63          	beq	a5,a4,ffffffffc020554a <do_exit+0xfc>
    if (current == initproc) {
ffffffffc0205476:	000a7417          	auipc	s0,0xa7
ffffffffc020547a:	0ea40413          	addi	s0,s0,234 # ffffffffc02ac560 <initproc>
ffffffffc020547e:	6018                	ld	a4,0(s0)
ffffffffc0205480:	0ee78b63          	beq	a5,a4,ffffffffc0205576 <do_exit+0x128>
    struct mm_struct *mm = current->mm;
ffffffffc0205484:	7784                	ld	s1,40(a5)
ffffffffc0205486:	89aa                	mv	s3,a0
    if (mm != NULL) {
ffffffffc0205488:	c48d                	beqz	s1,ffffffffc02054b2 <do_exit+0x64>
        lcr3(boot_cr3);
ffffffffc020548a:	000a7797          	auipc	a5,0xa7
ffffffffc020548e:	0fe78793          	addi	a5,a5,254 # ffffffffc02ac588 <boot_cr3>
ffffffffc0205492:	639c                	ld	a5,0(a5)
ffffffffc0205494:	577d                	li	a4,-1
ffffffffc0205496:	177e                	slli	a4,a4,0x3f
ffffffffc0205498:	83b1                	srli	a5,a5,0xc
ffffffffc020549a:	8fd9                	or	a5,a5,a4
ffffffffc020549c:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc02054a0:	589c                	lw	a5,48(s1)
ffffffffc02054a2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02054a6:	d898                	sw	a4,48(s1)
        if (mm_count_dec(mm) == 0) {
ffffffffc02054a8:	cf4d                	beqz	a4,ffffffffc0205562 <do_exit+0x114>
        current->mm = NULL;
ffffffffc02054aa:	00093783          	ld	a5,0(s2)
ffffffffc02054ae:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc02054b2:	00093783          	ld	a5,0(s2)
ffffffffc02054b6:	470d                	li	a4,3
ffffffffc02054b8:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc02054ba:	0f37a423          	sw	s3,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02054be:	100027f3          	csrr	a5,sstatus
ffffffffc02054c2:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02054c4:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02054c6:	e7e1                	bnez	a5,ffffffffc020558e <do_exit+0x140>
        proc = current->parent;
ffffffffc02054c8:	00093703          	ld	a4,0(s2)
        if (proc->wait_state == WT_CHILD) {
ffffffffc02054cc:	800007b7          	lui	a5,0x80000
ffffffffc02054d0:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc02054d2:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD) {
ffffffffc02054d4:	0ec52703          	lw	a4,236(a0)
ffffffffc02054d8:	0af70f63          	beq	a4,a5,ffffffffc0205596 <do_exit+0x148>
ffffffffc02054dc:	00093683          	ld	a3,0(s2)
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02054e0:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02054e4:	448d                	li	s1,3
                if (initproc->wait_state == WT_CHILD) {
ffffffffc02054e6:	0985                	addi	s3,s3,1
        while (current->cptr != NULL) {
ffffffffc02054e8:	7afc                	ld	a5,240(a3)
ffffffffc02054ea:	cb95                	beqz	a5,ffffffffc020551e <do_exit+0xd0>
            current->cptr = proc->optr;
ffffffffc02054ec:	1007b703          	ld	a4,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff5678>
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02054f0:	6008                	ld	a0,0(s0)
            current->cptr = proc->optr;
ffffffffc02054f2:	faf8                	sd	a4,240(a3)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02054f4:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02054f6:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL) {
ffffffffc02054fa:	10e7b023          	sd	a4,256(a5)
ffffffffc02054fe:	c311                	beqz	a4,ffffffffc0205502 <do_exit+0xb4>
                initproc->cptr->yptr = proc;
ffffffffc0205500:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0205502:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc0205504:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc0205506:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0205508:	fe9710e3          	bne	a4,s1,ffffffffc02054e8 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD) {
ffffffffc020550c:	0ec52783          	lw	a5,236(a0)
ffffffffc0205510:	fd379ce3          	bne	a5,s3,ffffffffc02054e8 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc0205514:	25b000ef          	jal	ra,ffffffffc0205f6e <wakeup_proc>
ffffffffc0205518:	00093683          	ld	a3,0(s2)
ffffffffc020551c:	b7f1                	j	ffffffffc02054e8 <do_exit+0x9a>
    if (flag) {
ffffffffc020551e:	020a1363          	bnez	s4,ffffffffc0205544 <do_exit+0xf6>
    schedule();
ffffffffc0205522:	2c9000ef          	jal	ra,ffffffffc0205fea <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc0205526:	00093783          	ld	a5,0(s2)
ffffffffc020552a:	00003617          	auipc	a2,0x3
ffffffffc020552e:	08e60613          	addi	a2,a2,142 # ffffffffc02085b8 <default_pmm_manager+0x250>
ffffffffc0205532:	20900593          	li	a1,521
ffffffffc0205536:	43d4                	lw	a3,4(a5)
ffffffffc0205538:	00003517          	auipc	a0,0x3
ffffffffc020553c:	33050513          	addi	a0,a0,816 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205540:	cd7fa0ef          	jal	ra,ffffffffc0200216 <__panic>
        intr_enable();
ffffffffc0205544:	912fb0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc0205548:	bfe9                	j	ffffffffc0205522 <do_exit+0xd4>
        panic("idleproc exit.\n");
ffffffffc020554a:	00003617          	auipc	a2,0x3
ffffffffc020554e:	04e60613          	addi	a2,a2,78 # ffffffffc0208598 <default_pmm_manager+0x230>
ffffffffc0205552:	1dd00593          	li	a1,477
ffffffffc0205556:	00003517          	auipc	a0,0x3
ffffffffc020555a:	31250513          	addi	a0,a0,786 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc020555e:	cb9fa0ef          	jal	ra,ffffffffc0200216 <__panic>
            exit_mmap(mm);
ffffffffc0205562:	8526                	mv	a0,s1
ffffffffc0205564:	d7afd0ef          	jal	ra,ffffffffc0202ade <exit_mmap>
            put_pgdir(mm);
ffffffffc0205568:	8526                	mv	a0,s1
ffffffffc020556a:	8bbff0ef          	jal	ra,ffffffffc0204e24 <put_pgdir>
            mm_destroy(mm);
ffffffffc020556e:	8526                	mv	a0,s1
ffffffffc0205570:	bcefd0ef          	jal	ra,ffffffffc020293e <mm_destroy>
ffffffffc0205574:	bf1d                	j	ffffffffc02054aa <do_exit+0x5c>
        panic("initproc exit.\n");
ffffffffc0205576:	00003617          	auipc	a2,0x3
ffffffffc020557a:	03260613          	addi	a2,a2,50 # ffffffffc02085a8 <default_pmm_manager+0x240>
ffffffffc020557e:	1e000593          	li	a1,480
ffffffffc0205582:	00003517          	auipc	a0,0x3
ffffffffc0205586:	2e650513          	addi	a0,a0,742 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc020558a:	c8dfa0ef          	jal	ra,ffffffffc0200216 <__panic>
        intr_disable();
ffffffffc020558e:	8cefb0ef          	jal	ra,ffffffffc020065c <intr_disable>
        return 1;
ffffffffc0205592:	4a05                	li	s4,1
ffffffffc0205594:	bf15                	j	ffffffffc02054c8 <do_exit+0x7a>
            wakeup_proc(proc);
ffffffffc0205596:	1d9000ef          	jal	ra,ffffffffc0205f6e <wakeup_proc>
ffffffffc020559a:	b789                	j	ffffffffc02054dc <do_exit+0x8e>

ffffffffc020559c <do_wait.part.1>:
do_wait(int pid, int *code_store) {
ffffffffc020559c:	7139                	addi	sp,sp,-64
ffffffffc020559e:	e852                	sd	s4,16(sp)
        current->wait_state = WT_CHILD;
ffffffffc02055a0:	80000a37          	lui	s4,0x80000
do_wait(int pid, int *code_store) {
ffffffffc02055a4:	f426                	sd	s1,40(sp)
ffffffffc02055a6:	f04a                	sd	s2,32(sp)
ffffffffc02055a8:	ec4e                	sd	s3,24(sp)
ffffffffc02055aa:	e456                	sd	s5,8(sp)
ffffffffc02055ac:	e05a                	sd	s6,0(sp)
ffffffffc02055ae:	fc06                	sd	ra,56(sp)
ffffffffc02055b0:	f822                	sd	s0,48(sp)
ffffffffc02055b2:	89aa                	mv	s3,a0
ffffffffc02055b4:	8b2e                	mv	s6,a1
        proc = current->cptr;
ffffffffc02055b6:	000a7917          	auipc	s2,0xa7
ffffffffc02055ba:	f9a90913          	addi	s2,s2,-102 # ffffffffc02ac550 <current>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02055be:	448d                	li	s1,3
        current->state = PROC_SLEEPING;
ffffffffc02055c0:	4a85                	li	s5,1
        current->wait_state = WT_CHILD;
ffffffffc02055c2:	2a05                	addiw	s4,s4,1
    if (pid != 0) {
ffffffffc02055c4:	02098f63          	beqz	s3,ffffffffc0205602 <do_wait.part.1+0x66>
        proc = find_proc(pid);
ffffffffc02055c8:	854e                	mv	a0,s3
ffffffffc02055ca:	9fbff0ef          	jal	ra,ffffffffc0204fc4 <find_proc>
ffffffffc02055ce:	842a                	mv	s0,a0
        if (proc != NULL && proc->parent == current) {
ffffffffc02055d0:	12050063          	beqz	a0,ffffffffc02056f0 <do_wait.part.1+0x154>
ffffffffc02055d4:	00093703          	ld	a4,0(s2)
ffffffffc02055d8:	711c                	ld	a5,32(a0)
ffffffffc02055da:	10e79b63          	bne	a5,a4,ffffffffc02056f0 <do_wait.part.1+0x154>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc02055de:	411c                	lw	a5,0(a0)
ffffffffc02055e0:	02978c63          	beq	a5,s1,ffffffffc0205618 <do_wait.part.1+0x7c>
        current->state = PROC_SLEEPING;
ffffffffc02055e4:	01572023          	sw	s5,0(a4)
        current->wait_state = WT_CHILD;
ffffffffc02055e8:	0f472623          	sw	s4,236(a4)
        schedule();
ffffffffc02055ec:	1ff000ef          	jal	ra,ffffffffc0205fea <schedule>
        if (current->flags & PF_EXITING) {
ffffffffc02055f0:	00093783          	ld	a5,0(s2)
ffffffffc02055f4:	0b07a783          	lw	a5,176(a5)
ffffffffc02055f8:	8b85                	andi	a5,a5,1
ffffffffc02055fa:	d7e9                	beqz	a5,ffffffffc02055c4 <do_wait.part.1+0x28>
            do_exit(-E_KILLED);
ffffffffc02055fc:	555d                	li	a0,-9
ffffffffc02055fe:	e51ff0ef          	jal	ra,ffffffffc020544e <do_exit>
        proc = current->cptr;
ffffffffc0205602:	00093703          	ld	a4,0(s2)
ffffffffc0205606:	7b60                	ld	s0,240(a4)
        for (; proc != NULL; proc = proc->optr) {
ffffffffc0205608:	e409                	bnez	s0,ffffffffc0205612 <do_wait.part.1+0x76>
ffffffffc020560a:	a0dd                	j	ffffffffc02056f0 <do_wait.part.1+0x154>
ffffffffc020560c:	10043403          	ld	s0,256(s0)
ffffffffc0205610:	d871                	beqz	s0,ffffffffc02055e4 <do_wait.part.1+0x48>
            if (proc->state == PROC_ZOMBIE) {
ffffffffc0205612:	401c                	lw	a5,0(s0)
ffffffffc0205614:	fe979ce3          	bne	a5,s1,ffffffffc020560c <do_wait.part.1+0x70>
    if (proc == idleproc || proc == initproc) {
ffffffffc0205618:	000a7797          	auipc	a5,0xa7
ffffffffc020561c:	f4078793          	addi	a5,a5,-192 # ffffffffc02ac558 <idleproc>
ffffffffc0205620:	639c                	ld	a5,0(a5)
ffffffffc0205622:	0c878d63          	beq	a5,s0,ffffffffc02056fc <do_wait.part.1+0x160>
ffffffffc0205626:	000a7797          	auipc	a5,0xa7
ffffffffc020562a:	f3a78793          	addi	a5,a5,-198 # ffffffffc02ac560 <initproc>
ffffffffc020562e:	639c                	ld	a5,0(a5)
ffffffffc0205630:	0cf40663          	beq	s0,a5,ffffffffc02056fc <do_wait.part.1+0x160>
    if (code_store != NULL) {
ffffffffc0205634:	000b0663          	beqz	s6,ffffffffc0205640 <do_wait.part.1+0xa4>
        *code_store = proc->exit_code;
ffffffffc0205638:	0e842783          	lw	a5,232(s0)
ffffffffc020563c:	00fb2023          	sw	a5,0(s6)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205640:	100027f3          	csrr	a5,sstatus
ffffffffc0205644:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205646:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205648:	e7d5                	bnez	a5,ffffffffc02056f4 <do_wait.part.1+0x158>
    __list_del(listelm->prev, listelm->next);
ffffffffc020564a:	6c70                	ld	a2,216(s0)
ffffffffc020564c:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL) {
ffffffffc020564e:	10043703          	ld	a4,256(s0)
ffffffffc0205652:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0205654:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0205656:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0205658:	6470                	ld	a2,200(s0)
ffffffffc020565a:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc020565c:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020565e:	e290                	sd	a2,0(a3)
ffffffffc0205660:	c319                	beqz	a4,ffffffffc0205666 <do_wait.part.1+0xca>
        proc->optr->yptr = proc->yptr;
ffffffffc0205662:	ff7c                	sd	a5,248(a4)
ffffffffc0205664:	7c7c                	ld	a5,248(s0)
    if (proc->yptr != NULL) {
ffffffffc0205666:	c3d1                	beqz	a5,ffffffffc02056ea <do_wait.part.1+0x14e>
        proc->yptr->optr = proc->optr;
ffffffffc0205668:	10e7b023          	sd	a4,256(a5)
    nr_process --;
ffffffffc020566c:	000a7797          	auipc	a5,0xa7
ffffffffc0205670:	efc78793          	addi	a5,a5,-260 # ffffffffc02ac568 <nr_process>
ffffffffc0205674:	439c                	lw	a5,0(a5)
ffffffffc0205676:	37fd                	addiw	a5,a5,-1
ffffffffc0205678:	000a7717          	auipc	a4,0xa7
ffffffffc020567c:	eef72823          	sw	a5,-272(a4) # ffffffffc02ac568 <nr_process>
    if (flag) {
ffffffffc0205680:	e1b5                	bnez	a1,ffffffffc02056e4 <do_wait.part.1+0x148>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0205682:	6814                	ld	a3,16(s0)
ffffffffc0205684:	c02007b7          	lui	a5,0xc0200
ffffffffc0205688:	0af6e263          	bltu	a3,a5,ffffffffc020572c <do_wait.part.1+0x190>
ffffffffc020568c:	000a7797          	auipc	a5,0xa7
ffffffffc0205690:	ef478793          	addi	a5,a5,-268 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0205694:	6398                	ld	a4,0(a5)
    if (PPN(pa) >= npage) {
ffffffffc0205696:	000a7797          	auipc	a5,0xa7
ffffffffc020569a:	e9278793          	addi	a5,a5,-366 # ffffffffc02ac528 <npage>
ffffffffc020569e:	639c                	ld	a5,0(a5)
    return pa2page(PADDR(kva));
ffffffffc02056a0:	8e99                	sub	a3,a3,a4
    if (PPN(pa) >= npage) {
ffffffffc02056a2:	82b1                	srli	a3,a3,0xc
ffffffffc02056a4:	06f6f863          	bleu	a5,a3,ffffffffc0205714 <do_wait.part.1+0x178>
    return &pages[PPN(pa) - nbase];
ffffffffc02056a8:	00003797          	auipc	a5,0x3
ffffffffc02056ac:	68878793          	addi	a5,a5,1672 # ffffffffc0208d30 <nbase>
ffffffffc02056b0:	639c                	ld	a5,0(a5)
ffffffffc02056b2:	000a7717          	auipc	a4,0xa7
ffffffffc02056b6:	ede70713          	addi	a4,a4,-290 # ffffffffc02ac590 <pages>
ffffffffc02056ba:	6308                	ld	a0,0(a4)
ffffffffc02056bc:	8e9d                	sub	a3,a3,a5
ffffffffc02056be:	069a                	slli	a3,a3,0x6
ffffffffc02056c0:	9536                	add	a0,a0,a3
ffffffffc02056c2:	4589                	li	a1,2
ffffffffc02056c4:	837fb0ef          	jal	ra,ffffffffc0200efa <free_pages>
    kfree(proc);
ffffffffc02056c8:	8522                	mv	a0,s0
ffffffffc02056ca:	edbfd0ef          	jal	ra,ffffffffc02035a4 <kfree>
    return 0;
ffffffffc02056ce:	4501                	li	a0,0
}
ffffffffc02056d0:	70e2                	ld	ra,56(sp)
ffffffffc02056d2:	7442                	ld	s0,48(sp)
ffffffffc02056d4:	74a2                	ld	s1,40(sp)
ffffffffc02056d6:	7902                	ld	s2,32(sp)
ffffffffc02056d8:	69e2                	ld	s3,24(sp)
ffffffffc02056da:	6a42                	ld	s4,16(sp)
ffffffffc02056dc:	6aa2                	ld	s5,8(sp)
ffffffffc02056de:	6b02                	ld	s6,0(sp)
ffffffffc02056e0:	6121                	addi	sp,sp,64
ffffffffc02056e2:	8082                	ret
        intr_enable();
ffffffffc02056e4:	f73fa0ef          	jal	ra,ffffffffc0200656 <intr_enable>
ffffffffc02056e8:	bf69                	j	ffffffffc0205682 <do_wait.part.1+0xe6>
       proc->parent->cptr = proc->optr;
ffffffffc02056ea:	701c                	ld	a5,32(s0)
ffffffffc02056ec:	fbf8                	sd	a4,240(a5)
ffffffffc02056ee:	bfbd                	j	ffffffffc020566c <do_wait.part.1+0xd0>
    return -E_BAD_PROC;
ffffffffc02056f0:	5579                	li	a0,-2
ffffffffc02056f2:	bff9                	j	ffffffffc02056d0 <do_wait.part.1+0x134>
        intr_disable();
ffffffffc02056f4:	f69fa0ef          	jal	ra,ffffffffc020065c <intr_disable>
        return 1;
ffffffffc02056f8:	4585                	li	a1,1
ffffffffc02056fa:	bf81                	j	ffffffffc020564a <do_wait.part.1+0xae>
        panic("wait idleproc or initproc.\n");
ffffffffc02056fc:	00003617          	auipc	a2,0x3
ffffffffc0205700:	f2460613          	addi	a2,a2,-220 # ffffffffc0208620 <default_pmm_manager+0x2b8>
ffffffffc0205704:	30000593          	li	a1,768
ffffffffc0205708:	00003517          	auipc	a0,0x3
ffffffffc020570c:	16050513          	addi	a0,a0,352 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205710:	b07fa0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0205714:	00002617          	auipc	a2,0x2
ffffffffc0205718:	93460613          	addi	a2,a2,-1740 # ffffffffc0207048 <commands+0x8a0>
ffffffffc020571c:	06200593          	li	a1,98
ffffffffc0205720:	00002517          	auipc	a0,0x2
ffffffffc0205724:	94850513          	addi	a0,a0,-1720 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0205728:	aeffa0ef          	jal	ra,ffffffffc0200216 <__panic>
    return pa2page(PADDR(kva));
ffffffffc020572c:	00002617          	auipc	a2,0x2
ffffffffc0205730:	9bc60613          	addi	a2,a2,-1604 # ffffffffc02070e8 <commands+0x940>
ffffffffc0205734:	06e00593          	li	a1,110
ffffffffc0205738:	00002517          	auipc	a0,0x2
ffffffffc020573c:	93050513          	addi	a0,a0,-1744 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0205740:	ad7fa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0205744 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
ffffffffc0205744:	1141                	addi	sp,sp,-16
ffffffffc0205746:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0205748:	ff8fb0ef          	jal	ra,ffffffffc0200f40 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc020574c:	d99fd0ef          	jal	ra,ffffffffc02034e4 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0205750:	4601                	li	a2,0
ffffffffc0205752:	4581                	li	a1,0
ffffffffc0205754:	fffff517          	auipc	a0,0xfffff
ffffffffc0205758:	64e50513          	addi	a0,a0,1614 # ffffffffc0204da2 <user_main>
ffffffffc020575c:	ca3ff0ef          	jal	ra,ffffffffc02053fe <kernel_thread>
    if (pid <= 0) {
ffffffffc0205760:	00a04563          	bgtz	a0,ffffffffc020576a <init_main+0x26>
ffffffffc0205764:	a841                	j	ffffffffc02057f4 <init_main+0xb0>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
ffffffffc0205766:	085000ef          	jal	ra,ffffffffc0205fea <schedule>
    if (code_store != NULL) {
ffffffffc020576a:	4581                	li	a1,0
ffffffffc020576c:	4501                	li	a0,0
ffffffffc020576e:	e2fff0ef          	jal	ra,ffffffffc020559c <do_wait.part.1>
    while (do_wait(0, NULL) == 0) {
ffffffffc0205772:	d975                	beqz	a0,ffffffffc0205766 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0205774:	00003517          	auipc	a0,0x3
ffffffffc0205778:	eec50513          	addi	a0,a0,-276 # ffffffffc0208660 <default_pmm_manager+0x2f8>
ffffffffc020577c:	955fa0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0205780:	000a7797          	auipc	a5,0xa7
ffffffffc0205784:	de078793          	addi	a5,a5,-544 # ffffffffc02ac560 <initproc>
ffffffffc0205788:	639c                	ld	a5,0(a5)
ffffffffc020578a:	7bf8                	ld	a4,240(a5)
ffffffffc020578c:	e721                	bnez	a4,ffffffffc02057d4 <init_main+0x90>
ffffffffc020578e:	7ff8                	ld	a4,248(a5)
ffffffffc0205790:	e331                	bnez	a4,ffffffffc02057d4 <init_main+0x90>
ffffffffc0205792:	1007b703          	ld	a4,256(a5)
ffffffffc0205796:	ef1d                	bnez	a4,ffffffffc02057d4 <init_main+0x90>
    assert(nr_process == 2);
ffffffffc0205798:	000a7717          	auipc	a4,0xa7
ffffffffc020579c:	dd070713          	addi	a4,a4,-560 # ffffffffc02ac568 <nr_process>
ffffffffc02057a0:	4314                	lw	a3,0(a4)
ffffffffc02057a2:	4709                	li	a4,2
ffffffffc02057a4:	0ae69463          	bne	a3,a4,ffffffffc020584c <init_main+0x108>
    return listelm->next;
ffffffffc02057a8:	000a7697          	auipc	a3,0xa7
ffffffffc02057ac:	ee868693          	addi	a3,a3,-280 # ffffffffc02ac690 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc02057b0:	6698                	ld	a4,8(a3)
ffffffffc02057b2:	0c878793          	addi	a5,a5,200
ffffffffc02057b6:	06f71b63          	bne	a4,a5,ffffffffc020582c <init_main+0xe8>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02057ba:	629c                	ld	a5,0(a3)
ffffffffc02057bc:	04f71863          	bne	a4,a5,ffffffffc020580c <init_main+0xc8>

    cprintf("init check memory pass.\n");
ffffffffc02057c0:	00003517          	auipc	a0,0x3
ffffffffc02057c4:	f8850513          	addi	a0,a0,-120 # ffffffffc0208748 <default_pmm_manager+0x3e0>
ffffffffc02057c8:	909fa0ef          	jal	ra,ffffffffc02000d0 <cprintf>
    return 0;
}
ffffffffc02057cc:	60a2                	ld	ra,8(sp)
ffffffffc02057ce:	4501                	li	a0,0
ffffffffc02057d0:	0141                	addi	sp,sp,16
ffffffffc02057d2:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02057d4:	00003697          	auipc	a3,0x3
ffffffffc02057d8:	eb468693          	addi	a3,a3,-332 # ffffffffc0208688 <default_pmm_manager+0x320>
ffffffffc02057dc:	00001617          	auipc	a2,0x1
ffffffffc02057e0:	44c60613          	addi	a2,a2,1100 # ffffffffc0206c28 <commands+0x480>
ffffffffc02057e4:	36500593          	li	a1,869
ffffffffc02057e8:	00003517          	auipc	a0,0x3
ffffffffc02057ec:	08050513          	addi	a0,a0,128 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc02057f0:	a27fa0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("create user_main failed.\n");
ffffffffc02057f4:	00003617          	auipc	a2,0x3
ffffffffc02057f8:	e4c60613          	addi	a2,a2,-436 # ffffffffc0208640 <default_pmm_manager+0x2d8>
ffffffffc02057fc:	35d00593          	li	a1,861
ffffffffc0205800:	00003517          	auipc	a0,0x3
ffffffffc0205804:	06850513          	addi	a0,a0,104 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205808:	a0ffa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020580c:	00003697          	auipc	a3,0x3
ffffffffc0205810:	f0c68693          	addi	a3,a3,-244 # ffffffffc0208718 <default_pmm_manager+0x3b0>
ffffffffc0205814:	00001617          	auipc	a2,0x1
ffffffffc0205818:	41460613          	addi	a2,a2,1044 # ffffffffc0206c28 <commands+0x480>
ffffffffc020581c:	36800593          	li	a1,872
ffffffffc0205820:	00003517          	auipc	a0,0x3
ffffffffc0205824:	04850513          	addi	a0,a0,72 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205828:	9effa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020582c:	00003697          	auipc	a3,0x3
ffffffffc0205830:	ebc68693          	addi	a3,a3,-324 # ffffffffc02086e8 <default_pmm_manager+0x380>
ffffffffc0205834:	00001617          	auipc	a2,0x1
ffffffffc0205838:	3f460613          	addi	a2,a2,1012 # ffffffffc0206c28 <commands+0x480>
ffffffffc020583c:	36700593          	li	a1,871
ffffffffc0205840:	00003517          	auipc	a0,0x3
ffffffffc0205844:	02850513          	addi	a0,a0,40 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205848:	9cffa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(nr_process == 2);
ffffffffc020584c:	00003697          	auipc	a3,0x3
ffffffffc0205850:	e8c68693          	addi	a3,a3,-372 # ffffffffc02086d8 <default_pmm_manager+0x370>
ffffffffc0205854:	00001617          	auipc	a2,0x1
ffffffffc0205858:	3d460613          	addi	a2,a2,980 # ffffffffc0206c28 <commands+0x480>
ffffffffc020585c:	36600593          	li	a1,870
ffffffffc0205860:	00003517          	auipc	a0,0x3
ffffffffc0205864:	00850513          	addi	a0,a0,8 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205868:	9affa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc020586c <do_execve>:
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc020586c:	7135                	addi	sp,sp,-160
ffffffffc020586e:	f8d2                	sd	s4,112(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205870:	000a7a17          	auipc	s4,0xa7
ffffffffc0205874:	ce0a0a13          	addi	s4,s4,-800 # ffffffffc02ac550 <current>
ffffffffc0205878:	000a3783          	ld	a5,0(s4)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc020587c:	e14a                	sd	s2,128(sp)
ffffffffc020587e:	e922                	sd	s0,144(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0205880:	0287b903          	ld	s2,40(a5)
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0205884:	fcce                	sd	s3,120(sp)
ffffffffc0205886:	f0da                	sd	s6,96(sp)
ffffffffc0205888:	89aa                	mv	s3,a0
ffffffffc020588a:	842e                	mv	s0,a1
ffffffffc020588c:	8b32                	mv	s6,a2
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc020588e:	4681                	li	a3,0
ffffffffc0205890:	862e                	mv	a2,a1
ffffffffc0205892:	85aa                	mv	a1,a0
ffffffffc0205894:	854a                	mv	a0,s2
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
ffffffffc0205896:	ed06                	sd	ra,152(sp)
ffffffffc0205898:	e526                	sd	s1,136(sp)
ffffffffc020589a:	f4d6                	sd	s5,104(sp)
ffffffffc020589c:	ecde                	sd	s7,88(sp)
ffffffffc020589e:	e8e2                	sd	s8,80(sp)
ffffffffc02058a0:	e4e6                	sd	s9,72(sp)
ffffffffc02058a2:	e0ea                	sd	s10,64(sp)
ffffffffc02058a4:	fc6e                	sd	s11,56(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
ffffffffc02058a6:	8fdfd0ef          	jal	ra,ffffffffc02031a2 <user_mem_check>
ffffffffc02058aa:	40050663          	beqz	a0,ffffffffc0205cb6 <do_execve+0x44a>
    memset(local_name, 0, sizeof(local_name));
ffffffffc02058ae:	4641                	li	a2,16
ffffffffc02058b0:	4581                	li	a1,0
ffffffffc02058b2:	1008                	addi	a0,sp,32
ffffffffc02058b4:	14b000ef          	jal	ra,ffffffffc02061fe <memset>
    memcpy(local_name, name, len);
ffffffffc02058b8:	47bd                	li	a5,15
ffffffffc02058ba:	8622                	mv	a2,s0
ffffffffc02058bc:	0687ee63          	bltu	a5,s0,ffffffffc0205938 <do_execve+0xcc>
ffffffffc02058c0:	85ce                	mv	a1,s3
ffffffffc02058c2:	1008                	addi	a0,sp,32
ffffffffc02058c4:	14d000ef          	jal	ra,ffffffffc0206210 <memcpy>
    if (mm != NULL) {
ffffffffc02058c8:	06090f63          	beqz	s2,ffffffffc0205946 <do_execve+0xda>
        cputs("mm != NULL");
ffffffffc02058cc:	00002517          	auipc	a0,0x2
ffffffffc02058d0:	10c50513          	addi	a0,a0,268 # ffffffffc02079d8 <commands+0x1230>
ffffffffc02058d4:	835fa0ef          	jal	ra,ffffffffc0200108 <cputs>
        lcr3(boot_cr3);
ffffffffc02058d8:	000a7797          	auipc	a5,0xa7
ffffffffc02058dc:	cb078793          	addi	a5,a5,-848 # ffffffffc02ac588 <boot_cr3>
ffffffffc02058e0:	639c                	ld	a5,0(a5)
ffffffffc02058e2:	577d                	li	a4,-1
ffffffffc02058e4:	177e                	slli	a4,a4,0x3f
ffffffffc02058e6:	83b1                	srli	a5,a5,0xc
ffffffffc02058e8:	8fd9                	or	a5,a5,a4
ffffffffc02058ea:	18079073          	csrw	satp,a5
ffffffffc02058ee:	03092783          	lw	a5,48(s2)
ffffffffc02058f2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02058f6:	02e92823          	sw	a4,48(s2)
        if (mm_count_dec(mm) == 0) {
ffffffffc02058fa:	28070d63          	beqz	a4,ffffffffc0205b94 <do_execve+0x328>
        current->mm = NULL;
ffffffffc02058fe:	000a3783          	ld	a5,0(s4)
ffffffffc0205902:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL) {
ffffffffc0205906:	eb3fc0ef          	jal	ra,ffffffffc02027b8 <mm_create>
ffffffffc020590a:	892a                	mv	s2,a0
ffffffffc020590c:	c135                	beqz	a0,ffffffffc0205970 <do_execve+0x104>
    if (setup_pgdir(mm) != 0) {
ffffffffc020590e:	d94ff0ef          	jal	ra,ffffffffc0204ea2 <setup_pgdir>
ffffffffc0205912:	e931                	bnez	a0,ffffffffc0205966 <do_execve+0xfa>
    if (elf->e_magic != ELF_MAGIC) {
ffffffffc0205914:	000b2703          	lw	a4,0(s6)
ffffffffc0205918:	464c47b7          	lui	a5,0x464c4
ffffffffc020591c:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b9af7>
ffffffffc0205920:	04f70a63          	beq	a4,a5,ffffffffc0205974 <do_execve+0x108>
    put_pgdir(mm);
ffffffffc0205924:	854a                	mv	a0,s2
ffffffffc0205926:	cfeff0ef          	jal	ra,ffffffffc0204e24 <put_pgdir>
    mm_destroy(mm);
ffffffffc020592a:	854a                	mv	a0,s2
ffffffffc020592c:	812fd0ef          	jal	ra,ffffffffc020293e <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0205930:	59e1                	li	s3,-8
    do_exit(ret);
ffffffffc0205932:	854e                	mv	a0,s3
ffffffffc0205934:	b1bff0ef          	jal	ra,ffffffffc020544e <do_exit>
    memcpy(local_name, name, len);
ffffffffc0205938:	463d                	li	a2,15
ffffffffc020593a:	85ce                	mv	a1,s3
ffffffffc020593c:	1008                	addi	a0,sp,32
ffffffffc020593e:	0d3000ef          	jal	ra,ffffffffc0206210 <memcpy>
    if (mm != NULL) {
ffffffffc0205942:	f80915e3          	bnez	s2,ffffffffc02058cc <do_execve+0x60>
    if (current->mm != NULL) {
ffffffffc0205946:	000a3783          	ld	a5,0(s4)
ffffffffc020594a:	779c                	ld	a5,40(a5)
ffffffffc020594c:	dfcd                	beqz	a5,ffffffffc0205906 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc020594e:	00003617          	auipc	a2,0x3
ffffffffc0205952:	ac260613          	addi	a2,a2,-1342 # ffffffffc0208410 <default_pmm_manager+0xa8>
ffffffffc0205956:	21300593          	li	a1,531
ffffffffc020595a:	00003517          	auipc	a0,0x3
ffffffffc020595e:	f0e50513          	addi	a0,a0,-242 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205962:	8b5fa0ef          	jal	ra,ffffffffc0200216 <__panic>
    mm_destroy(mm);
ffffffffc0205966:	854a                	mv	a0,s2
ffffffffc0205968:	fd7fc0ef          	jal	ra,ffffffffc020293e <mm_destroy>
    int ret = -E_NO_MEM;
ffffffffc020596c:	59f1                	li	s3,-4
ffffffffc020596e:	b7d1                	j	ffffffffc0205932 <do_execve+0xc6>
ffffffffc0205970:	59f1                	li	s3,-4
ffffffffc0205972:	b7c1                	j	ffffffffc0205932 <do_execve+0xc6>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0205974:	038b5703          	lhu	a4,56(s6)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0205978:	020b3403          	ld	s0,32(s6)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020597c:	00371793          	slli	a5,a4,0x3
ffffffffc0205980:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0205982:	945a                	add	s0,s0,s6
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0205984:	078e                	slli	a5,a5,0x3
ffffffffc0205986:	97a2                	add	a5,a5,s0
ffffffffc0205988:	ec3e                	sd	a5,24(sp)
    for (; ph < ph_end; ph ++) {
ffffffffc020598a:	02f47b63          	bleu	a5,s0,ffffffffc02059c0 <do_execve+0x154>
    return KADDR(page2pa(page));
ffffffffc020598e:	5bfd                	li	s7,-1
ffffffffc0205990:	00cbd793          	srli	a5,s7,0xc
    return page - pages + nbase;
ffffffffc0205994:	000a7d97          	auipc	s11,0xa7
ffffffffc0205998:	bfcd8d93          	addi	s11,s11,-1028 # ffffffffc02ac590 <pages>
ffffffffc020599c:	00003d17          	auipc	s10,0x3
ffffffffc02059a0:	394d0d13          	addi	s10,s10,916 # ffffffffc0208d30 <nbase>
    return KADDR(page2pa(page));
ffffffffc02059a4:	e43e                	sd	a5,8(sp)
ffffffffc02059a6:	000a7c97          	auipc	s9,0xa7
ffffffffc02059aa:	b82c8c93          	addi	s9,s9,-1150 # ffffffffc02ac528 <npage>
        if (ph->p_type != ELF_PT_LOAD) {
ffffffffc02059ae:	4018                	lw	a4,0(s0)
ffffffffc02059b0:	4785                	li	a5,1
ffffffffc02059b2:	0ef70f63          	beq	a4,a5,ffffffffc0205ab0 <do_execve+0x244>
    for (; ph < ph_end; ph ++) {
ffffffffc02059b6:	67e2                	ld	a5,24(sp)
ffffffffc02059b8:	03840413          	addi	s0,s0,56
ffffffffc02059bc:	fef469e3          	bltu	s0,a5,ffffffffc02059ae <do_execve+0x142>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
ffffffffc02059c0:	4701                	li	a4,0
ffffffffc02059c2:	46ad                	li	a3,11
ffffffffc02059c4:	00100637          	lui	a2,0x100
ffffffffc02059c8:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02059cc:	854a                	mv	a0,s2
ffffffffc02059ce:	fc3fc0ef          	jal	ra,ffffffffc0202990 <mm_map>
ffffffffc02059d2:	89aa                	mv	s3,a0
ffffffffc02059d4:	1a051663          	bnez	a0,ffffffffc0205b80 <do_execve+0x314>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc02059d8:	01893503          	ld	a0,24(s2)
ffffffffc02059dc:	467d                	li	a2,31
ffffffffc02059de:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02059e2:	937fc0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
ffffffffc02059e6:	36050463          	beqz	a0,ffffffffc0205d4e <do_execve+0x4e2>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc02059ea:	01893503          	ld	a0,24(s2)
ffffffffc02059ee:	467d                	li	a2,31
ffffffffc02059f0:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02059f4:	925fc0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
ffffffffc02059f8:	32050b63          	beqz	a0,ffffffffc0205d2e <do_execve+0x4c2>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc02059fc:	01893503          	ld	a0,24(s2)
ffffffffc0205a00:	467d                	li	a2,31
ffffffffc0205a02:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0205a06:	913fc0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
ffffffffc0205a0a:	30050263          	beqz	a0,ffffffffc0205d0e <do_execve+0x4a2>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0205a0e:	01893503          	ld	a0,24(s2)
ffffffffc0205a12:	467d                	li	a2,31
ffffffffc0205a14:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0205a18:	901fc0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
ffffffffc0205a1c:	2c050963          	beqz	a0,ffffffffc0205cee <do_execve+0x482>
    mm->mm_count += 1;
ffffffffc0205a20:	03092783          	lw	a5,48(s2)
    current->mm = mm;
ffffffffc0205a24:	000a3603          	ld	a2,0(s4)
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0205a28:	01893683          	ld	a3,24(s2)
ffffffffc0205a2c:	2785                	addiw	a5,a5,1
ffffffffc0205a2e:	02f92823          	sw	a5,48(s2)
    current->mm = mm;
ffffffffc0205a32:	03263423          	sd	s2,40(a2) # 100028 <_binary_obj___user_exit_out_size+0xf55a0>
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0205a36:	c02007b7          	lui	a5,0xc0200
ffffffffc0205a3a:	28f6ee63          	bltu	a3,a5,ffffffffc0205cd6 <do_execve+0x46a>
ffffffffc0205a3e:	000a7797          	auipc	a5,0xa7
ffffffffc0205a42:	b4278793          	addi	a5,a5,-1214 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0205a46:	639c                	ld	a5,0(a5)
ffffffffc0205a48:	577d                	li	a4,-1
ffffffffc0205a4a:	177e                	slli	a4,a4,0x3f
ffffffffc0205a4c:	8e9d                	sub	a3,a3,a5
ffffffffc0205a4e:	00c6d793          	srli	a5,a3,0xc
ffffffffc0205a52:	f654                	sd	a3,168(a2)
ffffffffc0205a54:	8fd9                	or	a5,a5,a4
ffffffffc0205a56:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0205a5a:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0205a5c:	4581                	li	a1,0
ffffffffc0205a5e:	12000613          	li	a2,288
ffffffffc0205a62:	8522                	mv	a0,s0
ffffffffc0205a64:	79a000ef          	jal	ra,ffffffffc02061fe <memset>
    tf->epc = elf->e_entry;
ffffffffc0205a68:	018b3703          	ld	a4,24(s6)
    tf->gpr.sp = USTACKTOP;
ffffffffc0205a6c:	4785                	li	a5,1
ffffffffc0205a6e:	07fe                	slli	a5,a5,0x1f
ffffffffc0205a70:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0205a72:	10e43423          	sd	a4,264(s0)
    tf->status = (read_csr(sstatus) | SSTATUS_SPIE ) & ~SSTATUS_SPP;
ffffffffc0205a76:	100027f3          	csrr	a5,sstatus
ffffffffc0205a7a:	edf7f793          	andi	a5,a5,-289
    set_proc_name(current, local_name);
ffffffffc0205a7e:	000a3503          	ld	a0,0(s4)
    tf->status = (read_csr(sstatus) | SSTATUS_SPIE ) & ~SSTATUS_SPP;
ffffffffc0205a82:	0207e793          	ori	a5,a5,32
ffffffffc0205a86:	10f43023          	sd	a5,256(s0)
    set_proc_name(current, local_name);
ffffffffc0205a8a:	100c                	addi	a1,sp,32
ffffffffc0205a8c:	ca2ff0ef          	jal	ra,ffffffffc0204f2e <set_proc_name>
}
ffffffffc0205a90:	60ea                	ld	ra,152(sp)
ffffffffc0205a92:	644a                	ld	s0,144(sp)
ffffffffc0205a94:	854e                	mv	a0,s3
ffffffffc0205a96:	64aa                	ld	s1,136(sp)
ffffffffc0205a98:	690a                	ld	s2,128(sp)
ffffffffc0205a9a:	79e6                	ld	s3,120(sp)
ffffffffc0205a9c:	7a46                	ld	s4,112(sp)
ffffffffc0205a9e:	7aa6                	ld	s5,104(sp)
ffffffffc0205aa0:	7b06                	ld	s6,96(sp)
ffffffffc0205aa2:	6be6                	ld	s7,88(sp)
ffffffffc0205aa4:	6c46                	ld	s8,80(sp)
ffffffffc0205aa6:	6ca6                	ld	s9,72(sp)
ffffffffc0205aa8:	6d06                	ld	s10,64(sp)
ffffffffc0205aaa:	7de2                	ld	s11,56(sp)
ffffffffc0205aac:	610d                	addi	sp,sp,160
ffffffffc0205aae:	8082                	ret
        if (ph->p_filesz > ph->p_memsz) {
ffffffffc0205ab0:	7410                	ld	a2,40(s0)
ffffffffc0205ab2:	701c                	ld	a5,32(s0)
ffffffffc0205ab4:	20f66363          	bltu	a2,a5,ffffffffc0205cba <do_execve+0x44e>
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc0205ab8:	405c                	lw	a5,4(s0)
ffffffffc0205aba:	0017f693          	andi	a3,a5,1
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0205abe:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
ffffffffc0205ac2:	068a                	slli	a3,a3,0x2
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0205ac4:	0e071263          	bnez	a4,ffffffffc0205ba8 <do_execve+0x33c>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0205ac8:	4745                	li	a4,17
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0205aca:	8b91                	andi	a5,a5,4
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0205acc:	e03a                	sd	a4,0(sp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0205ace:	c789                	beqz	a5,ffffffffc0205ad8 <do_execve+0x26c>
        if (vm_flags & VM_READ) perm |= PTE_R;
ffffffffc0205ad0:	47cd                	li	a5,19
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0205ad2:	0016e693          	ori	a3,a3,1
        if (vm_flags & VM_READ) perm |= PTE_R;
ffffffffc0205ad6:	e03e                	sd	a5,0(sp)
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc0205ad8:	0026f793          	andi	a5,a3,2
ffffffffc0205adc:	efe1                	bnez	a5,ffffffffc0205bb4 <do_execve+0x348>
        if (vm_flags & VM_EXEC) perm |= PTE_X;
ffffffffc0205ade:	0046f793          	andi	a5,a3,4
ffffffffc0205ae2:	c789                	beqz	a5,ffffffffc0205aec <do_execve+0x280>
ffffffffc0205ae4:	6782                	ld	a5,0(sp)
ffffffffc0205ae6:	0087e793          	ori	a5,a5,8
ffffffffc0205aea:	e03e                	sd	a5,0(sp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
ffffffffc0205aec:	680c                	ld	a1,16(s0)
ffffffffc0205aee:	4701                	li	a4,0
ffffffffc0205af0:	854a                	mv	a0,s2
ffffffffc0205af2:	e9ffc0ef          	jal	ra,ffffffffc0202990 <mm_map>
ffffffffc0205af6:	89aa                	mv	s3,a0
ffffffffc0205af8:	e541                	bnez	a0,ffffffffc0205b80 <do_execve+0x314>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205afa:	01043b83          	ld	s7,16(s0)
        end = ph->p_va + ph->p_filesz;
ffffffffc0205afe:	02043983          	ld	s3,32(s0)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205b02:	00843a83          	ld	s5,8(s0)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205b06:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0205b08:	99de                	add	s3,s3,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0205b0a:	9ada                	add	s5,s5,s6
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0205b0c:	00fbfc33          	and	s8,s7,a5
        while (start < end) {
ffffffffc0205b10:	053bef63          	bltu	s7,s3,ffffffffc0205b6e <do_execve+0x302>
ffffffffc0205b14:	aa79                	j	ffffffffc0205cb2 <do_execve+0x446>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205b16:	6785                	lui	a5,0x1
ffffffffc0205b18:	418b8533          	sub	a0,s7,s8
ffffffffc0205b1c:	9c3e                	add	s8,s8,a5
ffffffffc0205b1e:	417c0833          	sub	a6,s8,s7
            if (end < la) {
ffffffffc0205b22:	0189f463          	bleu	s8,s3,ffffffffc0205b2a <do_execve+0x2be>
                size -= la - end;
ffffffffc0205b26:	41798833          	sub	a6,s3,s7
    return page - pages + nbase;
ffffffffc0205b2a:	000db683          	ld	a3,0(s11)
ffffffffc0205b2e:	000d3583          	ld	a1,0(s10)
    return KADDR(page2pa(page));
ffffffffc0205b32:	67a2                	ld	a5,8(sp)
    return page - pages + nbase;
ffffffffc0205b34:	40d486b3          	sub	a3,s1,a3
ffffffffc0205b38:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0205b3a:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0205b3e:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0205b40:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205b44:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205b46:	16c5fc63          	bleu	a2,a1,ffffffffc0205cbe <do_execve+0x452>
ffffffffc0205b4a:	000a7797          	auipc	a5,0xa7
ffffffffc0205b4e:	a3678793          	addi	a5,a5,-1482 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0205b52:	0007b883          	ld	a7,0(a5)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0205b56:	85d6                	mv	a1,s5
ffffffffc0205b58:	8642                	mv	a2,a6
ffffffffc0205b5a:	96c6                	add	a3,a3,a7
ffffffffc0205b5c:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0205b5e:	9bc2                	add	s7,s7,a6
ffffffffc0205b60:	e842                	sd	a6,16(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0205b62:	6ae000ef          	jal	ra,ffffffffc0206210 <memcpy>
            start += size, from += size;
ffffffffc0205b66:	6842                	ld	a6,16(sp)
ffffffffc0205b68:	9ac2                	add	s5,s5,a6
        while (start < end) {
ffffffffc0205b6a:	053bf863          	bleu	s3,s7,ffffffffc0205bba <do_execve+0x34e>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0205b6e:	01893503          	ld	a0,24(s2)
ffffffffc0205b72:	6602                	ld	a2,0(sp)
ffffffffc0205b74:	85e2                	mv	a1,s8
ffffffffc0205b76:	fa2fc0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
ffffffffc0205b7a:	84aa                	mv	s1,a0
ffffffffc0205b7c:	fd49                	bnez	a0,ffffffffc0205b16 <do_execve+0x2aa>
        ret = -E_NO_MEM;
ffffffffc0205b7e:	59f1                	li	s3,-4
    exit_mmap(mm);
ffffffffc0205b80:	854a                	mv	a0,s2
ffffffffc0205b82:	f5dfc0ef          	jal	ra,ffffffffc0202ade <exit_mmap>
    put_pgdir(mm);
ffffffffc0205b86:	854a                	mv	a0,s2
ffffffffc0205b88:	a9cff0ef          	jal	ra,ffffffffc0204e24 <put_pgdir>
    mm_destroy(mm);
ffffffffc0205b8c:	854a                	mv	a0,s2
ffffffffc0205b8e:	db1fc0ef          	jal	ra,ffffffffc020293e <mm_destroy>
    return ret;
ffffffffc0205b92:	b345                	j	ffffffffc0205932 <do_execve+0xc6>
            exit_mmap(mm);
ffffffffc0205b94:	854a                	mv	a0,s2
ffffffffc0205b96:	f49fc0ef          	jal	ra,ffffffffc0202ade <exit_mmap>
            put_pgdir(mm);
ffffffffc0205b9a:	854a                	mv	a0,s2
ffffffffc0205b9c:	a88ff0ef          	jal	ra,ffffffffc0204e24 <put_pgdir>
            mm_destroy(mm);
ffffffffc0205ba0:	854a                	mv	a0,s2
ffffffffc0205ba2:	d9dfc0ef          	jal	ra,ffffffffc020293e <mm_destroy>
ffffffffc0205ba6:	bba1                	j	ffffffffc02058fe <do_execve+0x92>
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0205ba8:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0205bac:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
ffffffffc0205bae:	2681                	sext.w	a3,a3
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
ffffffffc0205bb0:	f20790e3          	bnez	a5,ffffffffc0205ad0 <do_execve+0x264>
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
ffffffffc0205bb4:	47dd                	li	a5,23
ffffffffc0205bb6:	e03e                	sd	a5,0(sp)
ffffffffc0205bb8:	b71d                	j	ffffffffc0205ade <do_execve+0x272>
ffffffffc0205bba:	01043983          	ld	s3,16(s0)
        end = ph->p_va + ph->p_memsz;
ffffffffc0205bbe:	7414                	ld	a3,40(s0)
ffffffffc0205bc0:	99b6                	add	s3,s3,a3
        if (start < la) {
ffffffffc0205bc2:	098bf163          	bleu	s8,s7,ffffffffc0205c44 <do_execve+0x3d8>
            if (start == end) {
ffffffffc0205bc6:	df7988e3          	beq	s3,s7,ffffffffc02059b6 <do_execve+0x14a>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0205bca:	6505                	lui	a0,0x1
ffffffffc0205bcc:	955e                	add	a0,a0,s7
ffffffffc0205bce:	41850533          	sub	a0,a0,s8
                size -= la - end;
ffffffffc0205bd2:	41798ab3          	sub	s5,s3,s7
            if (end < la) {
ffffffffc0205bd6:	0d89fb63          	bleu	s8,s3,ffffffffc0205cac <do_execve+0x440>
    return page - pages + nbase;
ffffffffc0205bda:	000db683          	ld	a3,0(s11)
ffffffffc0205bde:	000d3583          	ld	a1,0(s10)
    return KADDR(page2pa(page));
ffffffffc0205be2:	67a2                	ld	a5,8(sp)
    return page - pages + nbase;
ffffffffc0205be4:	40d486b3          	sub	a3,s1,a3
ffffffffc0205be8:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0205bea:	000cb603          	ld	a2,0(s9)
    return page - pages + nbase;
ffffffffc0205bee:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc0205bf0:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205bf4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205bf6:	0cc5f463          	bleu	a2,a1,ffffffffc0205cbe <do_execve+0x452>
ffffffffc0205bfa:	000a7617          	auipc	a2,0xa7
ffffffffc0205bfe:	98660613          	addi	a2,a2,-1658 # ffffffffc02ac580 <va_pa_offset>
ffffffffc0205c02:	00063803          	ld	a6,0(a2)
            memset(page2kva(page) + off, 0, size);
ffffffffc0205c06:	4581                	li	a1,0
ffffffffc0205c08:	8656                	mv	a2,s5
ffffffffc0205c0a:	96c2                	add	a3,a3,a6
ffffffffc0205c0c:	9536                	add	a0,a0,a3
ffffffffc0205c0e:	5f0000ef          	jal	ra,ffffffffc02061fe <memset>
            start += size;
ffffffffc0205c12:	017a8733          	add	a4,s5,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0205c16:	0389f463          	bleu	s8,s3,ffffffffc0205c3e <do_execve+0x3d2>
ffffffffc0205c1a:	d8e98ee3          	beq	s3,a4,ffffffffc02059b6 <do_execve+0x14a>
ffffffffc0205c1e:	00003697          	auipc	a3,0x3
ffffffffc0205c22:	81a68693          	addi	a3,a3,-2022 # ffffffffc0208438 <default_pmm_manager+0xd0>
ffffffffc0205c26:	00001617          	auipc	a2,0x1
ffffffffc0205c2a:	00260613          	addi	a2,a2,2 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205c2e:	26800593          	li	a1,616
ffffffffc0205c32:	00003517          	auipc	a0,0x3
ffffffffc0205c36:	c3650513          	addi	a0,a0,-970 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205c3a:	ddcfa0ef          	jal	ra,ffffffffc0200216 <__panic>
ffffffffc0205c3e:	ff8710e3          	bne	a4,s8,ffffffffc0205c1e <do_execve+0x3b2>
ffffffffc0205c42:	8be2                	mv	s7,s8
ffffffffc0205c44:	000a7a97          	auipc	s5,0xa7
ffffffffc0205c48:	93ca8a93          	addi	s5,s5,-1732 # ffffffffc02ac580 <va_pa_offset>
        while (start < end) {
ffffffffc0205c4c:	053be763          	bltu	s7,s3,ffffffffc0205c9a <do_execve+0x42e>
ffffffffc0205c50:	b39d                	j	ffffffffc02059b6 <do_execve+0x14a>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0205c52:	6785                	lui	a5,0x1
ffffffffc0205c54:	418b8533          	sub	a0,s7,s8
ffffffffc0205c58:	9c3e                	add	s8,s8,a5
ffffffffc0205c5a:	417c0633          	sub	a2,s8,s7
            if (end < la) {
ffffffffc0205c5e:	0189f463          	bleu	s8,s3,ffffffffc0205c66 <do_execve+0x3fa>
                size -= la - end;
ffffffffc0205c62:	41798633          	sub	a2,s3,s7
    return page - pages + nbase;
ffffffffc0205c66:	000db683          	ld	a3,0(s11)
ffffffffc0205c6a:	000d3803          	ld	a6,0(s10)
    return KADDR(page2pa(page));
ffffffffc0205c6e:	67a2                	ld	a5,8(sp)
    return page - pages + nbase;
ffffffffc0205c70:	40d486b3          	sub	a3,s1,a3
ffffffffc0205c74:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0205c76:	000cb583          	ld	a1,0(s9)
    return page - pages + nbase;
ffffffffc0205c7a:	96c2                	add	a3,a3,a6
    return KADDR(page2pa(page));
ffffffffc0205c7c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0205c80:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0205c82:	02b87e63          	bleu	a1,a6,ffffffffc0205cbe <do_execve+0x452>
ffffffffc0205c86:	000ab803          	ld	a6,0(s5)
            start += size;
ffffffffc0205c8a:	9bb2                	add	s7,s7,a2
            memset(page2kva(page) + off, 0, size);
ffffffffc0205c8c:	4581                	li	a1,0
ffffffffc0205c8e:	96c2                	add	a3,a3,a6
ffffffffc0205c90:	9536                	add	a0,a0,a3
ffffffffc0205c92:	56c000ef          	jal	ra,ffffffffc02061fe <memset>
        while (start < end) {
ffffffffc0205c96:	d33bf0e3          	bleu	s3,s7,ffffffffc02059b6 <do_execve+0x14a>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
ffffffffc0205c9a:	01893503          	ld	a0,24(s2)
ffffffffc0205c9e:	6602                	ld	a2,0(sp)
ffffffffc0205ca0:	85e2                	mv	a1,s8
ffffffffc0205ca2:	e76fc0ef          	jal	ra,ffffffffc0202318 <pgdir_alloc_page>
ffffffffc0205ca6:	84aa                	mv	s1,a0
ffffffffc0205ca8:	f54d                	bnez	a0,ffffffffc0205c52 <do_execve+0x3e6>
ffffffffc0205caa:	bdd1                	j	ffffffffc0205b7e <do_execve+0x312>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0205cac:	417c0ab3          	sub	s5,s8,s7
ffffffffc0205cb0:	b72d                	j	ffffffffc0205bda <do_execve+0x36e>
        while (start < end) {
ffffffffc0205cb2:	89de                	mv	s3,s7
ffffffffc0205cb4:	b729                	j	ffffffffc0205bbe <do_execve+0x352>
        return -E_INVAL;
ffffffffc0205cb6:	59f5                	li	s3,-3
ffffffffc0205cb8:	bbe1                	j	ffffffffc0205a90 <do_execve+0x224>
            ret = -E_INVAL_ELF;
ffffffffc0205cba:	59e1                	li	s3,-8
ffffffffc0205cbc:	b5d1                	j	ffffffffc0205b80 <do_execve+0x314>
ffffffffc0205cbe:	00001617          	auipc	a2,0x1
ffffffffc0205cc2:	35260613          	addi	a2,a2,850 # ffffffffc0207010 <commands+0x868>
ffffffffc0205cc6:	06900593          	li	a1,105
ffffffffc0205cca:	00001517          	auipc	a0,0x1
ffffffffc0205cce:	39e50513          	addi	a0,a0,926 # ffffffffc0207068 <commands+0x8c0>
ffffffffc0205cd2:	d44fa0ef          	jal	ra,ffffffffc0200216 <__panic>
    current->cr3 = PADDR(mm->pgdir);
ffffffffc0205cd6:	00001617          	auipc	a2,0x1
ffffffffc0205cda:	41260613          	addi	a2,a2,1042 # ffffffffc02070e8 <commands+0x940>
ffffffffc0205cde:	28300593          	li	a1,643
ffffffffc0205ce2:	00003517          	auipc	a0,0x3
ffffffffc0205ce6:	b8650513          	addi	a0,a0,-1146 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205cea:	d2cfa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
ffffffffc0205cee:	00003697          	auipc	a3,0x3
ffffffffc0205cf2:	86268693          	addi	a3,a3,-1950 # ffffffffc0208550 <default_pmm_manager+0x1e8>
ffffffffc0205cf6:	00001617          	auipc	a2,0x1
ffffffffc0205cfa:	f3260613          	addi	a2,a2,-206 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205cfe:	27e00593          	li	a1,638
ffffffffc0205d02:	00003517          	auipc	a0,0x3
ffffffffc0205d06:	b6650513          	addi	a0,a0,-1178 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205d0a:	d0cfa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
ffffffffc0205d0e:	00002697          	auipc	a3,0x2
ffffffffc0205d12:	7fa68693          	addi	a3,a3,2042 # ffffffffc0208508 <default_pmm_manager+0x1a0>
ffffffffc0205d16:	00001617          	auipc	a2,0x1
ffffffffc0205d1a:	f1260613          	addi	a2,a2,-238 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205d1e:	27d00593          	li	a1,637
ffffffffc0205d22:	00003517          	auipc	a0,0x3
ffffffffc0205d26:	b4650513          	addi	a0,a0,-1210 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205d2a:	cecfa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
ffffffffc0205d2e:	00002697          	auipc	a3,0x2
ffffffffc0205d32:	79268693          	addi	a3,a3,1938 # ffffffffc02084c0 <default_pmm_manager+0x158>
ffffffffc0205d36:	00001617          	auipc	a2,0x1
ffffffffc0205d3a:	ef260613          	addi	a2,a2,-270 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205d3e:	27c00593          	li	a1,636
ffffffffc0205d42:	00003517          	auipc	a0,0x3
ffffffffc0205d46:	b2650513          	addi	a0,a0,-1242 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205d4a:	cccfa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
ffffffffc0205d4e:	00002697          	auipc	a3,0x2
ffffffffc0205d52:	72a68693          	addi	a3,a3,1834 # ffffffffc0208478 <default_pmm_manager+0x110>
ffffffffc0205d56:	00001617          	auipc	a2,0x1
ffffffffc0205d5a:	ed260613          	addi	a2,a2,-302 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205d5e:	27b00593          	li	a1,635
ffffffffc0205d62:	00003517          	auipc	a0,0x3
ffffffffc0205d66:	b0650513          	addi	a0,a0,-1274 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205d6a:	cacfa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0205d6e <do_yield>:
    current->need_resched = 1;
ffffffffc0205d6e:	000a6797          	auipc	a5,0xa6
ffffffffc0205d72:	7e278793          	addi	a5,a5,2018 # ffffffffc02ac550 <current>
ffffffffc0205d76:	639c                	ld	a5,0(a5)
ffffffffc0205d78:	4705                	li	a4,1
}
ffffffffc0205d7a:	4501                	li	a0,0
    current->need_resched = 1;
ffffffffc0205d7c:	ef98                	sd	a4,24(a5)
}
ffffffffc0205d7e:	8082                	ret

ffffffffc0205d80 <do_wait>:
do_wait(int pid, int *code_store) {
ffffffffc0205d80:	1101                	addi	sp,sp,-32
ffffffffc0205d82:	e822                	sd	s0,16(sp)
ffffffffc0205d84:	e426                	sd	s1,8(sp)
ffffffffc0205d86:	ec06                	sd	ra,24(sp)
ffffffffc0205d88:	842e                	mv	s0,a1
ffffffffc0205d8a:	84aa                	mv	s1,a0
    if (code_store != NULL) {
ffffffffc0205d8c:	cd81                	beqz	a1,ffffffffc0205da4 <do_wait+0x24>
    struct mm_struct *mm = current->mm;
ffffffffc0205d8e:	000a6797          	auipc	a5,0xa6
ffffffffc0205d92:	7c278793          	addi	a5,a5,1986 # ffffffffc02ac550 <current>
ffffffffc0205d96:	639c                	ld	a5,0(a5)
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
ffffffffc0205d98:	4685                	li	a3,1
ffffffffc0205d9a:	4611                	li	a2,4
ffffffffc0205d9c:	7788                	ld	a0,40(a5)
ffffffffc0205d9e:	c04fd0ef          	jal	ra,ffffffffc02031a2 <user_mem_check>
ffffffffc0205da2:	c909                	beqz	a0,ffffffffc0205db4 <do_wait+0x34>
ffffffffc0205da4:	85a2                	mv	a1,s0
}
ffffffffc0205da6:	6442                	ld	s0,16(sp)
ffffffffc0205da8:	60e2                	ld	ra,24(sp)
ffffffffc0205daa:	8526                	mv	a0,s1
ffffffffc0205dac:	64a2                	ld	s1,8(sp)
ffffffffc0205dae:	6105                	addi	sp,sp,32
ffffffffc0205db0:	fecff06f          	j	ffffffffc020559c <do_wait.part.1>
ffffffffc0205db4:	60e2                	ld	ra,24(sp)
ffffffffc0205db6:	6442                	ld	s0,16(sp)
ffffffffc0205db8:	64a2                	ld	s1,8(sp)
ffffffffc0205dba:	5575                	li	a0,-3
ffffffffc0205dbc:	6105                	addi	sp,sp,32
ffffffffc0205dbe:	8082                	ret

ffffffffc0205dc0 <do_kill>:
do_kill(int pid) {
ffffffffc0205dc0:	1141                	addi	sp,sp,-16
ffffffffc0205dc2:	e406                	sd	ra,8(sp)
ffffffffc0205dc4:	e022                	sd	s0,0(sp)
    if ((proc = find_proc(pid)) != NULL) {
ffffffffc0205dc6:	9feff0ef          	jal	ra,ffffffffc0204fc4 <find_proc>
ffffffffc0205dca:	cd0d                	beqz	a0,ffffffffc0205e04 <do_kill+0x44>
        if (!(proc->flags & PF_EXITING)) {
ffffffffc0205dcc:	0b052703          	lw	a4,176(a0)
ffffffffc0205dd0:	00177693          	andi	a3,a4,1
ffffffffc0205dd4:	e695                	bnez	a3,ffffffffc0205e00 <do_kill+0x40>
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc0205dd6:	0ec52683          	lw	a3,236(a0)
            proc->flags |= PF_EXITING;
ffffffffc0205dda:	00176713          	ori	a4,a4,1
ffffffffc0205dde:	0ae52823          	sw	a4,176(a0)
            return 0;
ffffffffc0205de2:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED) {
ffffffffc0205de4:	0006c763          	bltz	a3,ffffffffc0205df2 <do_kill+0x32>
}
ffffffffc0205de8:	8522                	mv	a0,s0
ffffffffc0205dea:	60a2                	ld	ra,8(sp)
ffffffffc0205dec:	6402                	ld	s0,0(sp)
ffffffffc0205dee:	0141                	addi	sp,sp,16
ffffffffc0205df0:	8082                	ret
                wakeup_proc(proc);
ffffffffc0205df2:	17c000ef          	jal	ra,ffffffffc0205f6e <wakeup_proc>
}
ffffffffc0205df6:	8522                	mv	a0,s0
ffffffffc0205df8:	60a2                	ld	ra,8(sp)
ffffffffc0205dfa:	6402                	ld	s0,0(sp)
ffffffffc0205dfc:	0141                	addi	sp,sp,16
ffffffffc0205dfe:	8082                	ret
        return -E_KILLED;
ffffffffc0205e00:	545d                	li	s0,-9
ffffffffc0205e02:	b7dd                	j	ffffffffc0205de8 <do_kill+0x28>
    return -E_INVAL;
ffffffffc0205e04:	5475                	li	s0,-3
ffffffffc0205e06:	b7cd                	j	ffffffffc0205de8 <do_kill+0x28>

ffffffffc0205e08 <proc_init>:
    elm->prev = elm->next = elm;
ffffffffc0205e08:	000a7797          	auipc	a5,0xa7
ffffffffc0205e0c:	88878793          	addi	a5,a5,-1912 # ffffffffc02ac690 <proc_list>

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
ffffffffc0205e10:	1101                	addi	sp,sp,-32
ffffffffc0205e12:	000a7717          	auipc	a4,0xa7
ffffffffc0205e16:	88f73323          	sd	a5,-1914(a4) # ffffffffc02ac698 <proc_list+0x8>
ffffffffc0205e1a:	000a7717          	auipc	a4,0xa7
ffffffffc0205e1e:	86f73b23          	sd	a5,-1930(a4) # ffffffffc02ac690 <proc_list>
ffffffffc0205e22:	ec06                	sd	ra,24(sp)
ffffffffc0205e24:	e822                	sd	s0,16(sp)
ffffffffc0205e26:	e426                	sd	s1,8(sp)
ffffffffc0205e28:	000a2797          	auipc	a5,0xa2
ffffffffc0205e2c:	6e878793          	addi	a5,a5,1768 # ffffffffc02a8510 <hash_list>
ffffffffc0205e30:	000a6717          	auipc	a4,0xa6
ffffffffc0205e34:	6e070713          	addi	a4,a4,1760 # ffffffffc02ac510 <is_panic>
ffffffffc0205e38:	e79c                	sd	a5,8(a5)
ffffffffc0205e3a:	e39c                	sd	a5,0(a5)
ffffffffc0205e3c:	07c1                	addi	a5,a5,16
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
ffffffffc0205e3e:	fee79de3          	bne	a5,a4,ffffffffc0205e38 <proc_init+0x30>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
ffffffffc0205e42:	eddfe0ef          	jal	ra,ffffffffc0204d1e <alloc_proc>
ffffffffc0205e46:	000a6717          	auipc	a4,0xa6
ffffffffc0205e4a:	70a73923          	sd	a0,1810(a4) # ffffffffc02ac558 <idleproc>
ffffffffc0205e4e:	000a6497          	auipc	s1,0xa6
ffffffffc0205e52:	70a48493          	addi	s1,s1,1802 # ffffffffc02ac558 <idleproc>
ffffffffc0205e56:	c559                	beqz	a0,ffffffffc0205ee4 <proc_init+0xdc>
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0205e58:	4709                	li	a4,2
ffffffffc0205e5a:	e118                	sd	a4,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
    idleproc->need_resched = 1;
ffffffffc0205e5c:	4405                	li	s0,1
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205e5e:	00003717          	auipc	a4,0x3
ffffffffc0205e62:	1a270713          	addi	a4,a4,418 # ffffffffc0209000 <bootstack>
    set_proc_name(idleproc, "idle");
ffffffffc0205e66:	00003597          	auipc	a1,0x3
ffffffffc0205e6a:	91a58593          	addi	a1,a1,-1766 # ffffffffc0208780 <default_pmm_manager+0x418>
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205e6e:	e918                	sd	a4,16(a0)
    idleproc->need_resched = 1;
ffffffffc0205e70:	ed00                	sd	s0,24(a0)
    set_proc_name(idleproc, "idle");
ffffffffc0205e72:	8bcff0ef          	jal	ra,ffffffffc0204f2e <set_proc_name>
    nr_process ++;
ffffffffc0205e76:	000a6797          	auipc	a5,0xa6
ffffffffc0205e7a:	6f278793          	addi	a5,a5,1778 # ffffffffc02ac568 <nr_process>
ffffffffc0205e7e:	439c                	lw	a5,0(a5)

    current = idleproc;
ffffffffc0205e80:	6098                	ld	a4,0(s1)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205e82:	4601                	li	a2,0
    nr_process ++;
ffffffffc0205e84:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205e86:	4581                	li	a1,0
ffffffffc0205e88:	00000517          	auipc	a0,0x0
ffffffffc0205e8c:	8bc50513          	addi	a0,a0,-1860 # ffffffffc0205744 <init_main>
    nr_process ++;
ffffffffc0205e90:	000a6697          	auipc	a3,0xa6
ffffffffc0205e94:	6cf6ac23          	sw	a5,1752(a3) # ffffffffc02ac568 <nr_process>
    current = idleproc;
ffffffffc0205e98:	000a6797          	auipc	a5,0xa6
ffffffffc0205e9c:	6ae7bc23          	sd	a4,1720(a5) # ffffffffc02ac550 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0205ea0:	d5eff0ef          	jal	ra,ffffffffc02053fe <kernel_thread>
    if (pid <= 0) {
ffffffffc0205ea4:	08a05c63          	blez	a0,ffffffffc0205f3c <proc_init+0x134>
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0205ea8:	91cff0ef          	jal	ra,ffffffffc0204fc4 <find_proc>
    set_proc_name(initproc, "init");
ffffffffc0205eac:	00003597          	auipc	a1,0x3
ffffffffc0205eb0:	8fc58593          	addi	a1,a1,-1796 # ffffffffc02087a8 <default_pmm_manager+0x440>
    initproc = find_proc(pid);
ffffffffc0205eb4:	000a6797          	auipc	a5,0xa6
ffffffffc0205eb8:	6aa7b623          	sd	a0,1708(a5) # ffffffffc02ac560 <initproc>
    set_proc_name(initproc, "init");
ffffffffc0205ebc:	872ff0ef          	jal	ra,ffffffffc0204f2e <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205ec0:	609c                	ld	a5,0(s1)
ffffffffc0205ec2:	cfa9                	beqz	a5,ffffffffc0205f1c <proc_init+0x114>
ffffffffc0205ec4:	43dc                	lw	a5,4(a5)
ffffffffc0205ec6:	ebb9                	bnez	a5,ffffffffc0205f1c <proc_init+0x114>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205ec8:	000a6797          	auipc	a5,0xa6
ffffffffc0205ecc:	69878793          	addi	a5,a5,1688 # ffffffffc02ac560 <initproc>
ffffffffc0205ed0:	639c                	ld	a5,0(a5)
ffffffffc0205ed2:	c78d                	beqz	a5,ffffffffc0205efc <proc_init+0xf4>
ffffffffc0205ed4:	43dc                	lw	a5,4(a5)
ffffffffc0205ed6:	02879363          	bne	a5,s0,ffffffffc0205efc <proc_init+0xf4>
}
ffffffffc0205eda:	60e2                	ld	ra,24(sp)
ffffffffc0205edc:	6442                	ld	s0,16(sp)
ffffffffc0205ede:	64a2                	ld	s1,8(sp)
ffffffffc0205ee0:	6105                	addi	sp,sp,32
ffffffffc0205ee2:	8082                	ret
        panic("cannot alloc idleproc.\n");
ffffffffc0205ee4:	00003617          	auipc	a2,0x3
ffffffffc0205ee8:	88460613          	addi	a2,a2,-1916 # ffffffffc0208768 <default_pmm_manager+0x400>
ffffffffc0205eec:	37a00593          	li	a1,890
ffffffffc0205ef0:	00003517          	auipc	a0,0x3
ffffffffc0205ef4:	97850513          	addi	a0,a0,-1672 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205ef8:	b1efa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205efc:	00003697          	auipc	a3,0x3
ffffffffc0205f00:	8dc68693          	addi	a3,a3,-1828 # ffffffffc02087d8 <default_pmm_manager+0x470>
ffffffffc0205f04:	00001617          	auipc	a2,0x1
ffffffffc0205f08:	d2460613          	addi	a2,a2,-732 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205f0c:	38f00593          	li	a1,911
ffffffffc0205f10:	00003517          	auipc	a0,0x3
ffffffffc0205f14:	95850513          	addi	a0,a0,-1704 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205f18:	afefa0ef          	jal	ra,ffffffffc0200216 <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205f1c:	00003697          	auipc	a3,0x3
ffffffffc0205f20:	89468693          	addi	a3,a3,-1900 # ffffffffc02087b0 <default_pmm_manager+0x448>
ffffffffc0205f24:	00001617          	auipc	a2,0x1
ffffffffc0205f28:	d0460613          	addi	a2,a2,-764 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205f2c:	38e00593          	li	a1,910
ffffffffc0205f30:	00003517          	auipc	a0,0x3
ffffffffc0205f34:	93850513          	addi	a0,a0,-1736 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205f38:	adefa0ef          	jal	ra,ffffffffc0200216 <__panic>
        panic("create init_main failed.\n");
ffffffffc0205f3c:	00003617          	auipc	a2,0x3
ffffffffc0205f40:	84c60613          	addi	a2,a2,-1972 # ffffffffc0208788 <default_pmm_manager+0x420>
ffffffffc0205f44:	38800593          	li	a1,904
ffffffffc0205f48:	00003517          	auipc	a0,0x3
ffffffffc0205f4c:	92050513          	addi	a0,a0,-1760 # ffffffffc0208868 <default_pmm_manager+0x500>
ffffffffc0205f50:	ac6fa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0205f54 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
ffffffffc0205f54:	1141                	addi	sp,sp,-16
ffffffffc0205f56:	e022                	sd	s0,0(sp)
ffffffffc0205f58:	e406                	sd	ra,8(sp)
ffffffffc0205f5a:	000a6417          	auipc	s0,0xa6
ffffffffc0205f5e:	5f640413          	addi	s0,s0,1526 # ffffffffc02ac550 <current>
    while (1) {
        if (current->need_resched) {
ffffffffc0205f62:	6018                	ld	a4,0(s0)
ffffffffc0205f64:	6f1c                	ld	a5,24(a4)
ffffffffc0205f66:	dffd                	beqz	a5,ffffffffc0205f64 <cpu_idle+0x10>
            schedule();
ffffffffc0205f68:	082000ef          	jal	ra,ffffffffc0205fea <schedule>
ffffffffc0205f6c:	bfdd                	j	ffffffffc0205f62 <cpu_idle+0xe>

ffffffffc0205f6e <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205f6e:	4118                	lw	a4,0(a0)
wakeup_proc(struct proc_struct *proc) {
ffffffffc0205f70:	1101                	addi	sp,sp,-32
ffffffffc0205f72:	ec06                	sd	ra,24(sp)
ffffffffc0205f74:	e822                	sd	s0,16(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205f76:	478d                	li	a5,3
ffffffffc0205f78:	04f70a63          	beq	a4,a5,ffffffffc0205fcc <wakeup_proc+0x5e>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205f7c:	100027f3          	csrr	a5,sstatus
ffffffffc0205f80:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205f82:	4401                	li	s0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205f84:	ef8d                	bnez	a5,ffffffffc0205fbe <wakeup_proc+0x50>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE) {
ffffffffc0205f86:	4789                	li	a5,2
ffffffffc0205f88:	00f70f63          	beq	a4,a5,ffffffffc0205fa6 <wakeup_proc+0x38>
            proc->state = PROC_RUNNABLE;
ffffffffc0205f8c:	c11c                	sw	a5,0(a0)
            proc->wait_state = 0;
ffffffffc0205f8e:	0e052623          	sw	zero,236(a0)
    if (flag) {
ffffffffc0205f92:	e409                	bnez	s0,ffffffffc0205f9c <wakeup_proc+0x2e>
        else {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205f94:	60e2                	ld	ra,24(sp)
ffffffffc0205f96:	6442                	ld	s0,16(sp)
ffffffffc0205f98:	6105                	addi	sp,sp,32
ffffffffc0205f9a:	8082                	ret
ffffffffc0205f9c:	6442                	ld	s0,16(sp)
ffffffffc0205f9e:	60e2                	ld	ra,24(sp)
ffffffffc0205fa0:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205fa2:	eb4fa06f          	j	ffffffffc0200656 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205fa6:	00003617          	auipc	a2,0x3
ffffffffc0205faa:	91260613          	addi	a2,a2,-1774 # ffffffffc02088b8 <default_pmm_manager+0x550>
ffffffffc0205fae:	45c9                	li	a1,18
ffffffffc0205fb0:	00003517          	auipc	a0,0x3
ffffffffc0205fb4:	8f050513          	addi	a0,a0,-1808 # ffffffffc02088a0 <default_pmm_manager+0x538>
ffffffffc0205fb8:	acafa0ef          	jal	ra,ffffffffc0200282 <__warn>
ffffffffc0205fbc:	bfd9                	j	ffffffffc0205f92 <wakeup_proc+0x24>
ffffffffc0205fbe:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0205fc0:	e9cfa0ef          	jal	ra,ffffffffc020065c <intr_disable>
        return 1;
ffffffffc0205fc4:	6522                	ld	a0,8(sp)
ffffffffc0205fc6:	4405                	li	s0,1
ffffffffc0205fc8:	4118                	lw	a4,0(a0)
ffffffffc0205fca:	bf75                	j	ffffffffc0205f86 <wakeup_proc+0x18>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205fcc:	00003697          	auipc	a3,0x3
ffffffffc0205fd0:	8b468693          	addi	a3,a3,-1868 # ffffffffc0208880 <default_pmm_manager+0x518>
ffffffffc0205fd4:	00001617          	auipc	a2,0x1
ffffffffc0205fd8:	c5460613          	addi	a2,a2,-940 # ffffffffc0206c28 <commands+0x480>
ffffffffc0205fdc:	45a5                	li	a1,9
ffffffffc0205fde:	00003517          	auipc	a0,0x3
ffffffffc0205fe2:	8c250513          	addi	a0,a0,-1854 # ffffffffc02088a0 <default_pmm_manager+0x538>
ffffffffc0205fe6:	a30fa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0205fea <schedule>:

void
schedule(void) {
ffffffffc0205fea:	1141                	addi	sp,sp,-16
ffffffffc0205fec:	e406                	sd	ra,8(sp)
ffffffffc0205fee:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0205ff0:	100027f3          	csrr	a5,sstatus
ffffffffc0205ff4:	8b89                	andi	a5,a5,2
ffffffffc0205ff6:	4401                	li	s0,0
ffffffffc0205ff8:	e3d1                	bnez	a5,ffffffffc020607c <schedule+0x92>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0205ffa:	000a6797          	auipc	a5,0xa6
ffffffffc0205ffe:	55678793          	addi	a5,a5,1366 # ffffffffc02ac550 <current>
ffffffffc0206002:	0007b883          	ld	a7,0(a5)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0206006:	000a6797          	auipc	a5,0xa6
ffffffffc020600a:	55278793          	addi	a5,a5,1362 # ffffffffc02ac558 <idleproc>
ffffffffc020600e:	6388                	ld	a0,0(a5)
        current->need_resched = 0;
ffffffffc0206010:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0206014:	04a88e63          	beq	a7,a0,ffffffffc0206070 <schedule+0x86>
ffffffffc0206018:	0c888693          	addi	a3,a7,200
ffffffffc020601c:	000a6617          	auipc	a2,0xa6
ffffffffc0206020:	67460613          	addi	a2,a2,1652 # ffffffffc02ac690 <proc_list>
        le = last;
ffffffffc0206024:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0206026:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0206028:	4809                	li	a6,2
    return listelm->next;
ffffffffc020602a:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc020602c:	00c78863          	beq	a5,a2,ffffffffc020603c <schedule+0x52>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0206030:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0206034:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0206038:	01070463          	beq	a4,a6,ffffffffc0206040 <schedule+0x56>
                    break;
                }
            }
        } while (le != last);
ffffffffc020603c:	fef697e3          	bne	a3,a5,ffffffffc020602a <schedule+0x40>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0206040:	c589                	beqz	a1,ffffffffc020604a <schedule+0x60>
ffffffffc0206042:	4198                	lw	a4,0(a1)
ffffffffc0206044:	4789                	li	a5,2
ffffffffc0206046:	00f70e63          	beq	a4,a5,ffffffffc0206062 <schedule+0x78>
            next = idleproc;
        }
        next->runs ++;
ffffffffc020604a:	451c                	lw	a5,8(a0)
ffffffffc020604c:	2785                	addiw	a5,a5,1
ffffffffc020604e:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0206050:	00a88463          	beq	a7,a0,ffffffffc0206058 <schedule+0x6e>
            proc_run(next);
ffffffffc0206054:	f05fe0ef          	jal	ra,ffffffffc0204f58 <proc_run>
    if (flag) {
ffffffffc0206058:	e419                	bnez	s0,ffffffffc0206066 <schedule+0x7c>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020605a:	60a2                	ld	ra,8(sp)
ffffffffc020605c:	6402                	ld	s0,0(sp)
ffffffffc020605e:	0141                	addi	sp,sp,16
ffffffffc0206060:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0206062:	852e                	mv	a0,a1
ffffffffc0206064:	b7dd                	j	ffffffffc020604a <schedule+0x60>
}
ffffffffc0206066:	6402                	ld	s0,0(sp)
ffffffffc0206068:	60a2                	ld	ra,8(sp)
ffffffffc020606a:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020606c:	deafa06f          	j	ffffffffc0200656 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0206070:	000a6617          	auipc	a2,0xa6
ffffffffc0206074:	62060613          	addi	a2,a2,1568 # ffffffffc02ac690 <proc_list>
ffffffffc0206078:	86b2                	mv	a3,a2
ffffffffc020607a:	b76d                	j	ffffffffc0206024 <schedule+0x3a>
        intr_disable();
ffffffffc020607c:	de0fa0ef          	jal	ra,ffffffffc020065c <intr_disable>
        return 1;
ffffffffc0206080:	4405                	li	s0,1
ffffffffc0206082:	bfa5                	j	ffffffffc0205ffa <schedule+0x10>

ffffffffc0206084 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0206084:	000a6797          	auipc	a5,0xa6
ffffffffc0206088:	4cc78793          	addi	a5,a5,1228 # ffffffffc02ac550 <current>
ffffffffc020608c:	639c                	ld	a5,0(a5)
}
ffffffffc020608e:	43c8                	lw	a0,4(a5)
ffffffffc0206090:	8082                	ret

ffffffffc0206092 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0206092:	4501                	li	a0,0
ffffffffc0206094:	8082                	ret

ffffffffc0206096 <sys_putc>:
    cputchar(c);
ffffffffc0206096:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0206098:	1141                	addi	sp,sp,-16
ffffffffc020609a:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc020609c:	868fa0ef          	jal	ra,ffffffffc0200104 <cputchar>
}
ffffffffc02060a0:	60a2                	ld	ra,8(sp)
ffffffffc02060a2:	4501                	li	a0,0
ffffffffc02060a4:	0141                	addi	sp,sp,16
ffffffffc02060a6:	8082                	ret

ffffffffc02060a8 <sys_kill>:
    return do_kill(pid);
ffffffffc02060a8:	4108                	lw	a0,0(a0)
ffffffffc02060aa:	d17ff06f          	j	ffffffffc0205dc0 <do_kill>

ffffffffc02060ae <sys_yield>:
    return do_yield();
ffffffffc02060ae:	cc1ff06f          	j	ffffffffc0205d6e <do_yield>

ffffffffc02060b2 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc02060b2:	6d14                	ld	a3,24(a0)
ffffffffc02060b4:	6910                	ld	a2,16(a0)
ffffffffc02060b6:	650c                	ld	a1,8(a0)
ffffffffc02060b8:	6108                	ld	a0,0(a0)
ffffffffc02060ba:	fb2ff06f          	j	ffffffffc020586c <do_execve>

ffffffffc02060be <sys_wait>:
    return do_wait(pid, store);
ffffffffc02060be:	650c                	ld	a1,8(a0)
ffffffffc02060c0:	4108                	lw	a0,0(a0)
ffffffffc02060c2:	cbfff06f          	j	ffffffffc0205d80 <do_wait>

ffffffffc02060c6 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc02060c6:	000a6797          	auipc	a5,0xa6
ffffffffc02060ca:	48a78793          	addi	a5,a5,1162 # ffffffffc02ac550 <current>
ffffffffc02060ce:	639c                	ld	a5,0(a5)
    return do_fork(0, stack, tf);
ffffffffc02060d0:	4501                	li	a0,0
    struct trapframe *tf = current->tf;
ffffffffc02060d2:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02060d4:	6a0c                	ld	a1,16(a2)
ffffffffc02060d6:	f4bfe06f          	j	ffffffffc0205020 <do_fork>

ffffffffc02060da <sys_exit>:
    return do_exit(error_code);
ffffffffc02060da:	4108                	lw	a0,0(a0)
ffffffffc02060dc:	b72ff06f          	j	ffffffffc020544e <do_exit>

ffffffffc02060e0 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02060e0:	715d                	addi	sp,sp,-80
ffffffffc02060e2:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02060e4:	000a6497          	auipc	s1,0xa6
ffffffffc02060e8:	46c48493          	addi	s1,s1,1132 # ffffffffc02ac550 <current>
ffffffffc02060ec:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02060ee:	e0a2                	sd	s0,64(sp)
ffffffffc02060f0:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02060f2:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02060f4:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02060f6:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02060f8:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02060fc:	0327ee63          	bltu	a5,s2,ffffffffc0206138 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc0206100:	00391713          	slli	a4,s2,0x3
ffffffffc0206104:	00003797          	auipc	a5,0x3
ffffffffc0206108:	81c78793          	addi	a5,a5,-2020 # ffffffffc0208920 <syscalls>
ffffffffc020610c:	97ba                	add	a5,a5,a4
ffffffffc020610e:	639c                	ld	a5,0(a5)
ffffffffc0206110:	c785                	beqz	a5,ffffffffc0206138 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc0206112:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc0206114:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc0206116:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc0206118:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc020611a:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc020611c:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc020611e:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc0206120:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc0206122:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc0206124:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0206126:	0028                	addi	a0,sp,8
ffffffffc0206128:	9782                	jalr	a5
ffffffffc020612a:	e828                	sd	a0,80(s0)
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc020612c:	60a6                	ld	ra,72(sp)
ffffffffc020612e:	6406                	ld	s0,64(sp)
ffffffffc0206130:	74e2                	ld	s1,56(sp)
ffffffffc0206132:	7942                	ld	s2,48(sp)
ffffffffc0206134:	6161                	addi	sp,sp,80
ffffffffc0206136:	8082                	ret
    print_trapframe(tf);
ffffffffc0206138:	8522                	mv	a0,s0
ffffffffc020613a:	f10fa0ef          	jal	ra,ffffffffc020084a <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc020613e:	609c                	ld	a5,0(s1)
ffffffffc0206140:	86ca                	mv	a3,s2
ffffffffc0206142:	00002617          	auipc	a2,0x2
ffffffffc0206146:	79660613          	addi	a2,a2,1942 # ffffffffc02088d8 <default_pmm_manager+0x570>
ffffffffc020614a:	43d8                	lw	a4,4(a5)
ffffffffc020614c:	06300593          	li	a1,99
ffffffffc0206150:	0b478793          	addi	a5,a5,180
ffffffffc0206154:	00002517          	auipc	a0,0x2
ffffffffc0206158:	7b450513          	addi	a0,a0,1972 # ffffffffc0208908 <default_pmm_manager+0x5a0>
ffffffffc020615c:	8bafa0ef          	jal	ra,ffffffffc0200216 <__panic>

ffffffffc0206160 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0206160:	00054783          	lbu	a5,0(a0)
ffffffffc0206164:	cb91                	beqz	a5,ffffffffc0206178 <strlen+0x18>
    size_t cnt = 0;
ffffffffc0206166:	4781                	li	a5,0
        cnt ++;
ffffffffc0206168:	0785                	addi	a5,a5,1
    while (*s ++ != '\0') {
ffffffffc020616a:	00f50733          	add	a4,a0,a5
ffffffffc020616e:	00074703          	lbu	a4,0(a4)
ffffffffc0206172:	fb7d                	bnez	a4,ffffffffc0206168 <strlen+0x8>
    }
    return cnt;
}
ffffffffc0206174:	853e                	mv	a0,a5
ffffffffc0206176:	8082                	ret
    size_t cnt = 0;
ffffffffc0206178:	4781                	li	a5,0
}
ffffffffc020617a:	853e                	mv	a0,a5
ffffffffc020617c:	8082                	ret

ffffffffc020617e <strnlen>:
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
ffffffffc020617e:	c185                	beqz	a1,ffffffffc020619e <strnlen+0x20>
ffffffffc0206180:	00054783          	lbu	a5,0(a0)
ffffffffc0206184:	cf89                	beqz	a5,ffffffffc020619e <strnlen+0x20>
    size_t cnt = 0;
ffffffffc0206186:	4781                	li	a5,0
ffffffffc0206188:	a021                	j	ffffffffc0206190 <strnlen+0x12>
    while (cnt < len && *s ++ != '\0') {
ffffffffc020618a:	00074703          	lbu	a4,0(a4)
ffffffffc020618e:	c711                	beqz	a4,ffffffffc020619a <strnlen+0x1c>
        cnt ++;
ffffffffc0206190:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0206192:	00f50733          	add	a4,a0,a5
ffffffffc0206196:	fef59ae3          	bne	a1,a5,ffffffffc020618a <strnlen+0xc>
    }
    return cnt;
}
ffffffffc020619a:	853e                	mv	a0,a5
ffffffffc020619c:	8082                	ret
    size_t cnt = 0;
ffffffffc020619e:	4781                	li	a5,0
}
ffffffffc02061a0:	853e                	mv	a0,a5
ffffffffc02061a2:	8082                	ret

ffffffffc02061a4 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02061a4:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02061a6:	0585                	addi	a1,a1,1
ffffffffc02061a8:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02061ac:	0785                	addi	a5,a5,1
ffffffffc02061ae:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02061b2:	fb75                	bnez	a4,ffffffffc02061a6 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02061b4:	8082                	ret

ffffffffc02061b6 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02061b6:	00054783          	lbu	a5,0(a0)
ffffffffc02061ba:	0005c703          	lbu	a4,0(a1)
ffffffffc02061be:	cb91                	beqz	a5,ffffffffc02061d2 <strcmp+0x1c>
ffffffffc02061c0:	00e79c63          	bne	a5,a4,ffffffffc02061d8 <strcmp+0x22>
        s1 ++, s2 ++;
ffffffffc02061c4:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02061c6:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
ffffffffc02061ca:	0585                	addi	a1,a1,1
ffffffffc02061cc:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02061d0:	fbe5                	bnez	a5,ffffffffc02061c0 <strcmp+0xa>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02061d2:	4501                	li	a0,0
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc02061d4:	9d19                	subw	a0,a0,a4
ffffffffc02061d6:	8082                	ret
ffffffffc02061d8:	0007851b          	sext.w	a0,a5
ffffffffc02061dc:	9d19                	subw	a0,a0,a4
ffffffffc02061de:	8082                	ret

ffffffffc02061e0 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02061e0:	00054783          	lbu	a5,0(a0)
ffffffffc02061e4:	cb91                	beqz	a5,ffffffffc02061f8 <strchr+0x18>
        if (*s == c) {
ffffffffc02061e6:	00b79563          	bne	a5,a1,ffffffffc02061f0 <strchr+0x10>
ffffffffc02061ea:	a809                	j	ffffffffc02061fc <strchr+0x1c>
ffffffffc02061ec:	00b78763          	beq	a5,a1,ffffffffc02061fa <strchr+0x1a>
            return (char *)s;
        }
        s ++;
ffffffffc02061f0:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02061f2:	00054783          	lbu	a5,0(a0)
ffffffffc02061f6:	fbfd                	bnez	a5,ffffffffc02061ec <strchr+0xc>
    }
    return NULL;
ffffffffc02061f8:	4501                	li	a0,0
}
ffffffffc02061fa:	8082                	ret
ffffffffc02061fc:	8082                	ret

ffffffffc02061fe <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02061fe:	ca01                	beqz	a2,ffffffffc020620e <memset+0x10>
ffffffffc0206200:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0206202:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0206204:	0785                	addi	a5,a5,1
ffffffffc0206206:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc020620a:	fec79de3          	bne	a5,a2,ffffffffc0206204 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020620e:	8082                	ret

ffffffffc0206210 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0206210:	ca19                	beqz	a2,ffffffffc0206226 <memcpy+0x16>
ffffffffc0206212:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0206214:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0206216:	0585                	addi	a1,a1,1
ffffffffc0206218:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020621c:	0785                	addi	a5,a5,1
ffffffffc020621e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0206222:	fec59ae3          	bne	a1,a2,ffffffffc0206216 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0206226:	8082                	ret

ffffffffc0206228 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0206228:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020622c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020622e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0206232:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0206234:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0206238:	f022                	sd	s0,32(sp)
ffffffffc020623a:	ec26                	sd	s1,24(sp)
ffffffffc020623c:	e84a                	sd	s2,16(sp)
ffffffffc020623e:	f406                	sd	ra,40(sp)
ffffffffc0206240:	e44e                	sd	s3,8(sp)
ffffffffc0206242:	84aa                	mv	s1,a0
ffffffffc0206244:	892e                	mv	s2,a1
ffffffffc0206246:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020624a:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
ffffffffc020624c:	03067e63          	bleu	a6,a2,ffffffffc0206288 <printnum+0x60>
ffffffffc0206250:	89be                	mv	s3,a5
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0206252:	00805763          	blez	s0,ffffffffc0206260 <printnum+0x38>
ffffffffc0206256:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0206258:	85ca                	mv	a1,s2
ffffffffc020625a:	854e                	mv	a0,s3
ffffffffc020625c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020625e:	fc65                	bnez	s0,ffffffffc0206256 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0206260:	1a02                	slli	s4,s4,0x20
ffffffffc0206262:	020a5a13          	srli	s4,s4,0x20
ffffffffc0206266:	00003797          	auipc	a5,0x3
ffffffffc020626a:	9da78793          	addi	a5,a5,-1574 # ffffffffc0208c40 <error_string+0xc8>
ffffffffc020626e:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0206270:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0206272:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0206276:	70a2                	ld	ra,40(sp)
ffffffffc0206278:	69a2                	ld	s3,8(sp)
ffffffffc020627a:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020627c:	85ca                	mv	a1,s2
ffffffffc020627e:	8326                	mv	t1,s1
}
ffffffffc0206280:	6942                	ld	s2,16(sp)
ffffffffc0206282:	64e2                	ld	s1,24(sp)
ffffffffc0206284:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0206286:	8302                	jr	t1
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0206288:	03065633          	divu	a2,a2,a6
ffffffffc020628c:	8722                	mv	a4,s0
ffffffffc020628e:	f9bff0ef          	jal	ra,ffffffffc0206228 <printnum>
ffffffffc0206292:	b7f9                	j	ffffffffc0206260 <printnum+0x38>

ffffffffc0206294 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0206294:	7119                	addi	sp,sp,-128
ffffffffc0206296:	f4a6                	sd	s1,104(sp)
ffffffffc0206298:	f0ca                	sd	s2,96(sp)
ffffffffc020629a:	e8d2                	sd	s4,80(sp)
ffffffffc020629c:	e4d6                	sd	s5,72(sp)
ffffffffc020629e:	e0da                	sd	s6,64(sp)
ffffffffc02062a0:	fc5e                	sd	s7,56(sp)
ffffffffc02062a2:	f862                	sd	s8,48(sp)
ffffffffc02062a4:	f06a                	sd	s10,32(sp)
ffffffffc02062a6:	fc86                	sd	ra,120(sp)
ffffffffc02062a8:	f8a2                	sd	s0,112(sp)
ffffffffc02062aa:	ecce                	sd	s3,88(sp)
ffffffffc02062ac:	f466                	sd	s9,40(sp)
ffffffffc02062ae:	ec6e                	sd	s11,24(sp)
ffffffffc02062b0:	892a                	mv	s2,a0
ffffffffc02062b2:	84ae                	mv	s1,a1
ffffffffc02062b4:	8d32                	mv	s10,a2
ffffffffc02062b6:	8ab6                	mv	s5,a3
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02062b8:	5b7d                	li	s6,-1
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02062ba:	00002a17          	auipc	s4,0x2
ffffffffc02062be:	766a0a13          	addi	s4,s4,1894 # ffffffffc0208a20 <syscalls+0x100>
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02062c2:	05e00b93          	li	s7,94
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02062c6:	00003c17          	auipc	s8,0x3
ffffffffc02062ca:	8b2c0c13          	addi	s8,s8,-1870 # ffffffffc0208b78 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02062ce:	000d4503          	lbu	a0,0(s10)
ffffffffc02062d2:	02500793          	li	a5,37
ffffffffc02062d6:	001d0413          	addi	s0,s10,1
ffffffffc02062da:	00f50e63          	beq	a0,a5,ffffffffc02062f6 <vprintfmt+0x62>
            if (ch == '\0') {
ffffffffc02062de:	c521                	beqz	a0,ffffffffc0206326 <vprintfmt+0x92>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02062e0:	02500993          	li	s3,37
ffffffffc02062e4:	a011                	j	ffffffffc02062e8 <vprintfmt+0x54>
            if (ch == '\0') {
ffffffffc02062e6:	c121                	beqz	a0,ffffffffc0206326 <vprintfmt+0x92>
            putch(ch, putdat);
ffffffffc02062e8:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02062ea:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02062ec:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02062ee:	fff44503          	lbu	a0,-1(s0)
ffffffffc02062f2:	ff351ae3          	bne	a0,s3,ffffffffc02062e6 <vprintfmt+0x52>
ffffffffc02062f6:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02062fa:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02062fe:	4981                	li	s3,0
ffffffffc0206300:	4801                	li	a6,0
        width = precision = -1;
ffffffffc0206302:	5cfd                	li	s9,-1
ffffffffc0206304:	5dfd                	li	s11,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206306:	05500593          	li	a1,85
                if (ch < '0' || ch > '9') {
ffffffffc020630a:	4525                	li	a0,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020630c:	fdd6069b          	addiw	a3,a2,-35
ffffffffc0206310:	0ff6f693          	andi	a3,a3,255
ffffffffc0206314:	00140d13          	addi	s10,s0,1
ffffffffc0206318:	20d5e563          	bltu	a1,a3,ffffffffc0206522 <vprintfmt+0x28e>
ffffffffc020631c:	068a                	slli	a3,a3,0x2
ffffffffc020631e:	96d2                	add	a3,a3,s4
ffffffffc0206320:	4294                	lw	a3,0(a3)
ffffffffc0206322:	96d2                	add	a3,a3,s4
ffffffffc0206324:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0206326:	70e6                	ld	ra,120(sp)
ffffffffc0206328:	7446                	ld	s0,112(sp)
ffffffffc020632a:	74a6                	ld	s1,104(sp)
ffffffffc020632c:	7906                	ld	s2,96(sp)
ffffffffc020632e:	69e6                	ld	s3,88(sp)
ffffffffc0206330:	6a46                	ld	s4,80(sp)
ffffffffc0206332:	6aa6                	ld	s5,72(sp)
ffffffffc0206334:	6b06                	ld	s6,64(sp)
ffffffffc0206336:	7be2                	ld	s7,56(sp)
ffffffffc0206338:	7c42                	ld	s8,48(sp)
ffffffffc020633a:	7ca2                	ld	s9,40(sp)
ffffffffc020633c:	7d02                	ld	s10,32(sp)
ffffffffc020633e:	6de2                	ld	s11,24(sp)
ffffffffc0206340:	6109                	addi	sp,sp,128
ffffffffc0206342:	8082                	ret
    if (lflag >= 2) {
ffffffffc0206344:	4705                	li	a4,1
ffffffffc0206346:	008a8593          	addi	a1,s5,8
ffffffffc020634a:	01074463          	blt	a4,a6,ffffffffc0206352 <vprintfmt+0xbe>
    else if (lflag) {
ffffffffc020634e:	26080363          	beqz	a6,ffffffffc02065b4 <vprintfmt+0x320>
        return va_arg(*ap, unsigned long);
ffffffffc0206352:	000ab603          	ld	a2,0(s5)
ffffffffc0206356:	46c1                	li	a3,16
ffffffffc0206358:	8aae                	mv	s5,a1
ffffffffc020635a:	a06d                	j	ffffffffc0206404 <vprintfmt+0x170>
            goto reswitch;
ffffffffc020635c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0206360:	4985                	li	s3,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0206362:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0206364:	b765                	j	ffffffffc020630c <vprintfmt+0x78>
            putch(va_arg(ap, int), putdat);
ffffffffc0206366:	000aa503          	lw	a0,0(s5)
ffffffffc020636a:	85a6                	mv	a1,s1
ffffffffc020636c:	0aa1                	addi	s5,s5,8
ffffffffc020636e:	9902                	jalr	s2
            break;
ffffffffc0206370:	bfb9                	j	ffffffffc02062ce <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0206372:	4705                	li	a4,1
ffffffffc0206374:	008a8993          	addi	s3,s5,8
ffffffffc0206378:	01074463          	blt	a4,a6,ffffffffc0206380 <vprintfmt+0xec>
    else if (lflag) {
ffffffffc020637c:	22080463          	beqz	a6,ffffffffc02065a4 <vprintfmt+0x310>
        return va_arg(*ap, long);
ffffffffc0206380:	000ab403          	ld	s0,0(s5)
            if ((long long)num < 0) {
ffffffffc0206384:	24044463          	bltz	s0,ffffffffc02065cc <vprintfmt+0x338>
            num = getint(&ap, lflag);
ffffffffc0206388:	8622                	mv	a2,s0
ffffffffc020638a:	8ace                	mv	s5,s3
ffffffffc020638c:	46a9                	li	a3,10
ffffffffc020638e:	a89d                	j	ffffffffc0206404 <vprintfmt+0x170>
            err = va_arg(ap, int);
ffffffffc0206390:	000aa783          	lw	a5,0(s5)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0206394:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0206396:	0aa1                	addi	s5,s5,8
            if (err < 0) {
ffffffffc0206398:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc020639c:	8fb5                	xor	a5,a5,a3
ffffffffc020639e:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02063a2:	1ad74363          	blt	a4,a3,ffffffffc0206548 <vprintfmt+0x2b4>
ffffffffc02063a6:	00369793          	slli	a5,a3,0x3
ffffffffc02063aa:	97e2                	add	a5,a5,s8
ffffffffc02063ac:	639c                	ld	a5,0(a5)
ffffffffc02063ae:	18078d63          	beqz	a5,ffffffffc0206548 <vprintfmt+0x2b4>
                printfmt(putch, putdat, "%s", p);
ffffffffc02063b2:	86be                	mv	a3,a5
ffffffffc02063b4:	00000617          	auipc	a2,0x0
ffffffffc02063b8:	2ac60613          	addi	a2,a2,684 # ffffffffc0206660 <etext+0x28>
ffffffffc02063bc:	85a6                	mv	a1,s1
ffffffffc02063be:	854a                	mv	a0,s2
ffffffffc02063c0:	240000ef          	jal	ra,ffffffffc0206600 <printfmt>
ffffffffc02063c4:	b729                	j	ffffffffc02062ce <vprintfmt+0x3a>
            lflag ++;
ffffffffc02063c6:	00144603          	lbu	a2,1(s0)
ffffffffc02063ca:	2805                	addiw	a6,a6,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02063cc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02063ce:	bf3d                	j	ffffffffc020630c <vprintfmt+0x78>
    if (lflag >= 2) {
ffffffffc02063d0:	4705                	li	a4,1
ffffffffc02063d2:	008a8593          	addi	a1,s5,8
ffffffffc02063d6:	01074463          	blt	a4,a6,ffffffffc02063de <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc02063da:	1e080263          	beqz	a6,ffffffffc02065be <vprintfmt+0x32a>
        return va_arg(*ap, unsigned long);
ffffffffc02063de:	000ab603          	ld	a2,0(s5)
ffffffffc02063e2:	46a1                	li	a3,8
ffffffffc02063e4:	8aae                	mv	s5,a1
ffffffffc02063e6:	a839                	j	ffffffffc0206404 <vprintfmt+0x170>
            putch('0', putdat);
ffffffffc02063e8:	03000513          	li	a0,48
ffffffffc02063ec:	85a6                	mv	a1,s1
ffffffffc02063ee:	e03e                	sd	a5,0(sp)
ffffffffc02063f0:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02063f2:	85a6                	mv	a1,s1
ffffffffc02063f4:	07800513          	li	a0,120
ffffffffc02063f8:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02063fa:	0aa1                	addi	s5,s5,8
ffffffffc02063fc:	ff8ab603          	ld	a2,-8(s5)
            goto number;
ffffffffc0206400:	6782                	ld	a5,0(sp)
ffffffffc0206402:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0206404:	876e                	mv	a4,s11
ffffffffc0206406:	85a6                	mv	a1,s1
ffffffffc0206408:	854a                	mv	a0,s2
ffffffffc020640a:	e1fff0ef          	jal	ra,ffffffffc0206228 <printnum>
            break;
ffffffffc020640e:	b5c1                	j	ffffffffc02062ce <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0206410:	000ab603          	ld	a2,0(s5)
ffffffffc0206414:	0aa1                	addi	s5,s5,8
ffffffffc0206416:	1c060663          	beqz	a2,ffffffffc02065e2 <vprintfmt+0x34e>
            if (width > 0 && padc != '-') {
ffffffffc020641a:	00160413          	addi	s0,a2,1
ffffffffc020641e:	17b05c63          	blez	s11,ffffffffc0206596 <vprintfmt+0x302>
ffffffffc0206422:	02d00593          	li	a1,45
ffffffffc0206426:	14b79263          	bne	a5,a1,ffffffffc020656a <vprintfmt+0x2d6>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020642a:	00064783          	lbu	a5,0(a2)
ffffffffc020642e:	0007851b          	sext.w	a0,a5
ffffffffc0206432:	c905                	beqz	a0,ffffffffc0206462 <vprintfmt+0x1ce>
ffffffffc0206434:	000cc563          	bltz	s9,ffffffffc020643e <vprintfmt+0x1aa>
ffffffffc0206438:	3cfd                	addiw	s9,s9,-1
ffffffffc020643a:	036c8263          	beq	s9,s6,ffffffffc020645e <vprintfmt+0x1ca>
                    putch('?', putdat);
ffffffffc020643e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0206440:	18098463          	beqz	s3,ffffffffc02065c8 <vprintfmt+0x334>
ffffffffc0206444:	3781                	addiw	a5,a5,-32
ffffffffc0206446:	18fbf163          	bleu	a5,s7,ffffffffc02065c8 <vprintfmt+0x334>
                    putch('?', putdat);
ffffffffc020644a:	03f00513          	li	a0,63
ffffffffc020644e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206450:	0405                	addi	s0,s0,1
ffffffffc0206452:	fff44783          	lbu	a5,-1(s0)
ffffffffc0206456:	3dfd                	addiw	s11,s11,-1
ffffffffc0206458:	0007851b          	sext.w	a0,a5
ffffffffc020645c:	fd61                	bnez	a0,ffffffffc0206434 <vprintfmt+0x1a0>
            for (; width > 0; width --) {
ffffffffc020645e:	e7b058e3          	blez	s11,ffffffffc02062ce <vprintfmt+0x3a>
ffffffffc0206462:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0206464:	85a6                	mv	a1,s1
ffffffffc0206466:	02000513          	li	a0,32
ffffffffc020646a:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020646c:	e60d81e3          	beqz	s11,ffffffffc02062ce <vprintfmt+0x3a>
ffffffffc0206470:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0206472:	85a6                	mv	a1,s1
ffffffffc0206474:	02000513          	li	a0,32
ffffffffc0206478:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc020647a:	fe0d94e3          	bnez	s11,ffffffffc0206462 <vprintfmt+0x1ce>
ffffffffc020647e:	bd81                	j	ffffffffc02062ce <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0206480:	4705                	li	a4,1
ffffffffc0206482:	008a8593          	addi	a1,s5,8
ffffffffc0206486:	01074463          	blt	a4,a6,ffffffffc020648e <vprintfmt+0x1fa>
    else if (lflag) {
ffffffffc020648a:	12080063          	beqz	a6,ffffffffc02065aa <vprintfmt+0x316>
        return va_arg(*ap, unsigned long);
ffffffffc020648e:	000ab603          	ld	a2,0(s5)
ffffffffc0206492:	46a9                	li	a3,10
ffffffffc0206494:	8aae                	mv	s5,a1
ffffffffc0206496:	b7bd                	j	ffffffffc0206404 <vprintfmt+0x170>
ffffffffc0206498:	00144603          	lbu	a2,1(s0)
            padc = '-';
ffffffffc020649c:	02d00793          	li	a5,45
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02064a0:	846a                	mv	s0,s10
ffffffffc02064a2:	b5ad                	j	ffffffffc020630c <vprintfmt+0x78>
            putch(ch, putdat);
ffffffffc02064a4:	85a6                	mv	a1,s1
ffffffffc02064a6:	02500513          	li	a0,37
ffffffffc02064aa:	9902                	jalr	s2
            break;
ffffffffc02064ac:	b50d                	j	ffffffffc02062ce <vprintfmt+0x3a>
            precision = va_arg(ap, int);
ffffffffc02064ae:	000aac83          	lw	s9,0(s5)
            goto process_precision;
ffffffffc02064b2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02064b6:	0aa1                	addi	s5,s5,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02064b8:	846a                	mv	s0,s10
            if (width < 0)
ffffffffc02064ba:	e40dd9e3          	bgez	s11,ffffffffc020630c <vprintfmt+0x78>
                width = precision, precision = -1;
ffffffffc02064be:	8de6                	mv	s11,s9
ffffffffc02064c0:	5cfd                	li	s9,-1
ffffffffc02064c2:	b5a9                	j	ffffffffc020630c <vprintfmt+0x78>
            goto reswitch;
ffffffffc02064c4:	00144603          	lbu	a2,1(s0)
            padc = '0';
ffffffffc02064c8:	03000793          	li	a5,48
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02064cc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02064ce:	bd3d                	j	ffffffffc020630c <vprintfmt+0x78>
                precision = precision * 10 + ch - '0';
ffffffffc02064d0:	fd060c9b          	addiw	s9,a2,-48
                ch = *fmt;
ffffffffc02064d4:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02064d8:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02064da:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02064de:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc02064e2:	fcd56ce3          	bltu	a0,a3,ffffffffc02064ba <vprintfmt+0x226>
            for (precision = 0; ; ++ fmt) {
ffffffffc02064e6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02064e8:	002c969b          	slliw	a3,s9,0x2
                ch = *fmt;
ffffffffc02064ec:	00044603          	lbu	a2,0(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02064f0:	0196873b          	addw	a4,a3,s9
ffffffffc02064f4:	0017171b          	slliw	a4,a4,0x1
ffffffffc02064f8:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
ffffffffc02064fc:	fd06069b          	addiw	a3,a2,-48
                precision = precision * 10 + ch - '0';
ffffffffc0206500:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0206504:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc0206508:	fcd57fe3          	bleu	a3,a0,ffffffffc02064e6 <vprintfmt+0x252>
ffffffffc020650c:	b77d                	j	ffffffffc02064ba <vprintfmt+0x226>
            if (width < 0)
ffffffffc020650e:	fffdc693          	not	a3,s11
ffffffffc0206512:	96fd                	srai	a3,a3,0x3f
ffffffffc0206514:	00ddfdb3          	and	s11,s11,a3
ffffffffc0206518:	00144603          	lbu	a2,1(s0)
ffffffffc020651c:	2d81                	sext.w	s11,s11
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020651e:	846a                	mv	s0,s10
ffffffffc0206520:	b3f5                	j	ffffffffc020630c <vprintfmt+0x78>
            putch('%', putdat);
ffffffffc0206522:	85a6                	mv	a1,s1
ffffffffc0206524:	02500513          	li	a0,37
ffffffffc0206528:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020652a:	fff44703          	lbu	a4,-1(s0)
ffffffffc020652e:	02500793          	li	a5,37
ffffffffc0206532:	8d22                	mv	s10,s0
ffffffffc0206534:	d8f70de3          	beq	a4,a5,ffffffffc02062ce <vprintfmt+0x3a>
ffffffffc0206538:	02500713          	li	a4,37
ffffffffc020653c:	1d7d                	addi	s10,s10,-1
ffffffffc020653e:	fffd4783          	lbu	a5,-1(s10)
ffffffffc0206542:	fee79de3          	bne	a5,a4,ffffffffc020653c <vprintfmt+0x2a8>
ffffffffc0206546:	b361                	j	ffffffffc02062ce <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0206548:	00002617          	auipc	a2,0x2
ffffffffc020654c:	7d860613          	addi	a2,a2,2008 # ffffffffc0208d20 <error_string+0x1a8>
ffffffffc0206550:	85a6                	mv	a1,s1
ffffffffc0206552:	854a                	mv	a0,s2
ffffffffc0206554:	0ac000ef          	jal	ra,ffffffffc0206600 <printfmt>
ffffffffc0206558:	bb9d                	j	ffffffffc02062ce <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020655a:	00002617          	auipc	a2,0x2
ffffffffc020655e:	7be60613          	addi	a2,a2,1982 # ffffffffc0208d18 <error_string+0x1a0>
            if (width > 0 && padc != '-') {
ffffffffc0206562:	00002417          	auipc	s0,0x2
ffffffffc0206566:	7b740413          	addi	s0,s0,1975 # ffffffffc0208d19 <error_string+0x1a1>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020656a:	8532                	mv	a0,a2
ffffffffc020656c:	85e6                	mv	a1,s9
ffffffffc020656e:	e032                	sd	a2,0(sp)
ffffffffc0206570:	e43e                	sd	a5,8(sp)
ffffffffc0206572:	c0dff0ef          	jal	ra,ffffffffc020617e <strnlen>
ffffffffc0206576:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020657a:	6602                	ld	a2,0(sp)
ffffffffc020657c:	01b05d63          	blez	s11,ffffffffc0206596 <vprintfmt+0x302>
ffffffffc0206580:	67a2                	ld	a5,8(sp)
ffffffffc0206582:	2781                	sext.w	a5,a5
ffffffffc0206584:	e43e                	sd	a5,8(sp)
                    putch(padc, putdat);
ffffffffc0206586:	6522                	ld	a0,8(sp)
ffffffffc0206588:	85a6                	mv	a1,s1
ffffffffc020658a:	e032                	sd	a2,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020658c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020658e:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0206590:	6602                	ld	a2,0(sp)
ffffffffc0206592:	fe0d9ae3          	bnez	s11,ffffffffc0206586 <vprintfmt+0x2f2>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0206596:	00064783          	lbu	a5,0(a2)
ffffffffc020659a:	0007851b          	sext.w	a0,a5
ffffffffc020659e:	e8051be3          	bnez	a0,ffffffffc0206434 <vprintfmt+0x1a0>
ffffffffc02065a2:	b335                	j	ffffffffc02062ce <vprintfmt+0x3a>
        return va_arg(*ap, int);
ffffffffc02065a4:	000aa403          	lw	s0,0(s5)
ffffffffc02065a8:	bbf1                	j	ffffffffc0206384 <vprintfmt+0xf0>
        return va_arg(*ap, unsigned int);
ffffffffc02065aa:	000ae603          	lwu	a2,0(s5)
ffffffffc02065ae:	46a9                	li	a3,10
ffffffffc02065b0:	8aae                	mv	s5,a1
ffffffffc02065b2:	bd89                	j	ffffffffc0206404 <vprintfmt+0x170>
ffffffffc02065b4:	000ae603          	lwu	a2,0(s5)
ffffffffc02065b8:	46c1                	li	a3,16
ffffffffc02065ba:	8aae                	mv	s5,a1
ffffffffc02065bc:	b5a1                	j	ffffffffc0206404 <vprintfmt+0x170>
ffffffffc02065be:	000ae603          	lwu	a2,0(s5)
ffffffffc02065c2:	46a1                	li	a3,8
ffffffffc02065c4:	8aae                	mv	s5,a1
ffffffffc02065c6:	bd3d                	j	ffffffffc0206404 <vprintfmt+0x170>
                    putch(ch, putdat);
ffffffffc02065c8:	9902                	jalr	s2
ffffffffc02065ca:	b559                	j	ffffffffc0206450 <vprintfmt+0x1bc>
                putch('-', putdat);
ffffffffc02065cc:	85a6                	mv	a1,s1
ffffffffc02065ce:	02d00513          	li	a0,45
ffffffffc02065d2:	e03e                	sd	a5,0(sp)
ffffffffc02065d4:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02065d6:	8ace                	mv	s5,s3
ffffffffc02065d8:	40800633          	neg	a2,s0
ffffffffc02065dc:	46a9                	li	a3,10
ffffffffc02065de:	6782                	ld	a5,0(sp)
ffffffffc02065e0:	b515                	j	ffffffffc0206404 <vprintfmt+0x170>
            if (width > 0 && padc != '-') {
ffffffffc02065e2:	01b05663          	blez	s11,ffffffffc02065ee <vprintfmt+0x35a>
ffffffffc02065e6:	02d00693          	li	a3,45
ffffffffc02065ea:	f6d798e3          	bne	a5,a3,ffffffffc020655a <vprintfmt+0x2c6>
ffffffffc02065ee:	00002417          	auipc	s0,0x2
ffffffffc02065f2:	72b40413          	addi	s0,s0,1835 # ffffffffc0208d19 <error_string+0x1a1>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02065f6:	02800513          	li	a0,40
ffffffffc02065fa:	02800793          	li	a5,40
ffffffffc02065fe:	bd1d                	j	ffffffffc0206434 <vprintfmt+0x1a0>

ffffffffc0206600 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206600:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0206602:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0206606:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0206608:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020660a:	ec06                	sd	ra,24(sp)
ffffffffc020660c:	f83a                	sd	a4,48(sp)
ffffffffc020660e:	fc3e                	sd	a5,56(sp)
ffffffffc0206610:	e0c2                	sd	a6,64(sp)
ffffffffc0206612:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0206614:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0206616:	c7fff0ef          	jal	ra,ffffffffc0206294 <vprintfmt>
}
ffffffffc020661a:	60e2                	ld	ra,24(sp)
ffffffffc020661c:	6161                	addi	sp,sp,80
ffffffffc020661e:	8082                	ret

ffffffffc0206620 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0206620:	9e3707b7          	lui	a5,0x9e370
ffffffffc0206624:	2785                	addiw	a5,a5,1
ffffffffc0206626:	02f5053b          	mulw	a0,a0,a5
    return (hash >> (32 - bits));
ffffffffc020662a:	02000793          	li	a5,32
ffffffffc020662e:	40b785bb          	subw	a1,a5,a1
}
ffffffffc0206632:	00b5553b          	srlw	a0,a0,a1
ffffffffc0206636:	8082                	ret
