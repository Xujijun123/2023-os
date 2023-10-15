
bin/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200000:	c02052b7          	lui	t0,0xc0205
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
ffffffffc0200028:	c0205137          	lui	sp,0xc0205

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


int kern_init(void) {
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc0200036:	00006517          	auipc	a0,0x6
ffffffffc020003a:	fda50513          	addi	a0,a0,-38 # ffffffffc0206010 <edata>
ffffffffc020003e:	00006617          	auipc	a2,0x6
ffffffffc0200042:	43a60613          	addi	a2,a2,1082 # ffffffffc0206478 <end>
int kern_init(void) {
ffffffffc0200046:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200048:	8e09                	sub	a2,a2,a0
ffffffffc020004a:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020004c:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020004e:	608010ef          	jal	ra,ffffffffc0201656 <memset>
    cons_init();  // init the console
ffffffffc0200052:	3fa000ef          	jal	ra,ffffffffc020044c <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200056:	00002517          	auipc	a0,0x2
ffffffffc020005a:	b2250513          	addi	a0,a0,-1246 # ffffffffc0201b78 <etext+0x4>
ffffffffc020005e:	08c000ef          	jal	ra,ffffffffc02000ea <cputs>

    print_kerninfo();
ffffffffc0200062:	138000ef          	jal	ra,ffffffffc020019a <print_kerninfo>

    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200066:	400000ef          	jal	ra,ffffffffc0200466 <idt_init>
    pmm_init();  // init physical memory management
ffffffffc020006a:	127000ef          	jal	ra,ffffffffc0200990 <pmm_init>

    clock_init();   // init clock interrupt
ffffffffc020006e:	39a000ef          	jal	ra,ffffffffc0200408 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200072:	3e8000ef          	jal	ra,ffffffffc020045a <intr_enable>


    /* do nothing */
    while (1)
        ;
ffffffffc0200076:	a001                	j	ffffffffc0200076 <kern_init+0x40>

ffffffffc0200078 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc0200078:	1141                	addi	sp,sp,-16
ffffffffc020007a:	e022                	sd	s0,0(sp)
ffffffffc020007c:	e406                	sd	ra,8(sp)
ffffffffc020007e:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200080:	3ce000ef          	jal	ra,ffffffffc020044e <cons_putc>
    (*cnt) ++;
ffffffffc0200084:	401c                	lw	a5,0(s0)
}
ffffffffc0200086:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc0200088:	2785                	addiw	a5,a5,1
ffffffffc020008a:	c01c                	sw	a5,0(s0)
}
ffffffffc020008c:	6402                	ld	s0,0(sp)
ffffffffc020008e:	0141                	addi	sp,sp,16
ffffffffc0200090:	8082                	ret

ffffffffc0200092 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc0200092:	1101                	addi	sp,sp,-32
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200094:	86ae                	mv	a3,a1
ffffffffc0200096:	862a                	mv	a2,a0
ffffffffc0200098:	006c                	addi	a1,sp,12
ffffffffc020009a:	00000517          	auipc	a0,0x0
ffffffffc020009e:	fde50513          	addi	a0,a0,-34 # ffffffffc0200078 <cputch>
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000a2:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000a4:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000a6:	62e010ef          	jal	ra,ffffffffc02016d4 <vprintfmt>
    return cnt;
}
ffffffffc02000aa:	60e2                	ld	ra,24(sp)
ffffffffc02000ac:	4532                	lw	a0,12(sp)
ffffffffc02000ae:	6105                	addi	sp,sp,32
ffffffffc02000b0:	8082                	ret

ffffffffc02000b2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000b2:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000b4:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000b8:	f42e                	sd	a1,40(sp)
ffffffffc02000ba:	f832                	sd	a2,48(sp)
ffffffffc02000bc:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000be:	862a                	mv	a2,a0
ffffffffc02000c0:	004c                	addi	a1,sp,4
ffffffffc02000c2:	00000517          	auipc	a0,0x0
ffffffffc02000c6:	fb650513          	addi	a0,a0,-74 # ffffffffc0200078 <cputch>
ffffffffc02000ca:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
ffffffffc02000cc:	ec06                	sd	ra,24(sp)
ffffffffc02000ce:	e0ba                	sd	a4,64(sp)
ffffffffc02000d0:	e4be                	sd	a5,72(sp)
ffffffffc02000d2:	e8c2                	sd	a6,80(sp)
ffffffffc02000d4:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000d6:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000d8:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000da:	5fa010ef          	jal	ra,ffffffffc02016d4 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02000de:	60e2                	ld	ra,24(sp)
ffffffffc02000e0:	4512                	lw	a0,4(sp)
ffffffffc02000e2:	6125                	addi	sp,sp,96
ffffffffc02000e4:	8082                	ret

ffffffffc02000e6 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc02000e6:	3680006f          	j	ffffffffc020044e <cons_putc>

ffffffffc02000ea <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc02000ea:	1101                	addi	sp,sp,-32
ffffffffc02000ec:	e822                	sd	s0,16(sp)
ffffffffc02000ee:	ec06                	sd	ra,24(sp)
ffffffffc02000f0:	e426                	sd	s1,8(sp)
ffffffffc02000f2:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc02000f4:	00054503          	lbu	a0,0(a0)
ffffffffc02000f8:	c51d                	beqz	a0,ffffffffc0200126 <cputs+0x3c>
ffffffffc02000fa:	0405                	addi	s0,s0,1
ffffffffc02000fc:	4485                	li	s1,1
ffffffffc02000fe:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200100:	34e000ef          	jal	ra,ffffffffc020044e <cons_putc>
    (*cnt) ++;
ffffffffc0200104:	008487bb          	addw	a5,s1,s0
    while ((c = *str ++) != '\0') {
ffffffffc0200108:	0405                	addi	s0,s0,1
ffffffffc020010a:	fff44503          	lbu	a0,-1(s0)
ffffffffc020010e:	f96d                	bnez	a0,ffffffffc0200100 <cputs+0x16>
ffffffffc0200110:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200114:	4529                	li	a0,10
ffffffffc0200116:	338000ef          	jal	ra,ffffffffc020044e <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020011a:	8522                	mv	a0,s0
ffffffffc020011c:	60e2                	ld	ra,24(sp)
ffffffffc020011e:	6442                	ld	s0,16(sp)
ffffffffc0200120:	64a2                	ld	s1,8(sp)
ffffffffc0200122:	6105                	addi	sp,sp,32
ffffffffc0200124:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc0200126:	4405                	li	s0,1
ffffffffc0200128:	b7f5                	j	ffffffffc0200114 <cputs+0x2a>

ffffffffc020012a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc020012a:	1141                	addi	sp,sp,-16
ffffffffc020012c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020012e:	328000ef          	jal	ra,ffffffffc0200456 <cons_getc>
ffffffffc0200132:	dd75                	beqz	a0,ffffffffc020012e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200134:	60a2                	ld	ra,8(sp)
ffffffffc0200136:	0141                	addi	sp,sp,16
ffffffffc0200138:	8082                	ret

ffffffffc020013a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020013a:	00006317          	auipc	t1,0x6
ffffffffc020013e:	2d630313          	addi	t1,t1,726 # ffffffffc0206410 <is_panic>
ffffffffc0200142:	00032303          	lw	t1,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200146:	715d                	addi	sp,sp,-80
ffffffffc0200148:	ec06                	sd	ra,24(sp)
ffffffffc020014a:	e822                	sd	s0,16(sp)
ffffffffc020014c:	f436                	sd	a3,40(sp)
ffffffffc020014e:	f83a                	sd	a4,48(sp)
ffffffffc0200150:	fc3e                	sd	a5,56(sp)
ffffffffc0200152:	e0c2                	sd	a6,64(sp)
ffffffffc0200154:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200156:	02031c63          	bnez	t1,ffffffffc020018e <__panic+0x54>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020015a:	4785                	li	a5,1
ffffffffc020015c:	8432                	mv	s0,a2
ffffffffc020015e:	00006717          	auipc	a4,0x6
ffffffffc0200162:	2af72923          	sw	a5,690(a4) # ffffffffc0206410 <is_panic>

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200166:	862e                	mv	a2,a1
    va_start(ap, fmt);
ffffffffc0200168:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020016a:	85aa                	mv	a1,a0
ffffffffc020016c:	00002517          	auipc	a0,0x2
ffffffffc0200170:	a2c50513          	addi	a0,a0,-1492 # ffffffffc0201b98 <etext+0x24>
    va_start(ap, fmt);
ffffffffc0200174:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200176:	f3dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020017a:	65a2                	ld	a1,8(sp)
ffffffffc020017c:	8522                	mv	a0,s0
ffffffffc020017e:	f15ff0ef          	jal	ra,ffffffffc0200092 <vcprintf>
    cprintf("\n");
ffffffffc0200182:	00002517          	auipc	a0,0x2
ffffffffc0200186:	b2e50513          	addi	a0,a0,-1234 # ffffffffc0201cb0 <etext+0x13c>
ffffffffc020018a:	f29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020018e:	2d2000ef          	jal	ra,ffffffffc0200460 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200192:	4501                	li	a0,0
ffffffffc0200194:	132000ef          	jal	ra,ffffffffc02002c6 <kmonitor>
ffffffffc0200198:	bfed                	j	ffffffffc0200192 <__panic+0x58>

ffffffffc020019a <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020019a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020019c:	00002517          	auipc	a0,0x2
ffffffffc02001a0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0201be8 <etext+0x74>
void print_kerninfo(void) {
ffffffffc02001a4:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001a6:	f0dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001aa:	00000597          	auipc	a1,0x0
ffffffffc02001ae:	e8c58593          	addi	a1,a1,-372 # ffffffffc0200036 <kern_init>
ffffffffc02001b2:	00002517          	auipc	a0,0x2
ffffffffc02001b6:	a5650513          	addi	a0,a0,-1450 # ffffffffc0201c08 <etext+0x94>
ffffffffc02001ba:	ef9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001be:	00002597          	auipc	a1,0x2
ffffffffc02001c2:	9b658593          	addi	a1,a1,-1610 # ffffffffc0201b74 <etext>
ffffffffc02001c6:	00002517          	auipc	a0,0x2
ffffffffc02001ca:	a6250513          	addi	a0,a0,-1438 # ffffffffc0201c28 <etext+0xb4>
ffffffffc02001ce:	ee5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001d2:	00006597          	auipc	a1,0x6
ffffffffc02001d6:	e3e58593          	addi	a1,a1,-450 # ffffffffc0206010 <edata>
ffffffffc02001da:	00002517          	auipc	a0,0x2
ffffffffc02001de:	a6e50513          	addi	a0,a0,-1426 # ffffffffc0201c48 <etext+0xd4>
ffffffffc02001e2:	ed1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001e6:	00006597          	auipc	a1,0x6
ffffffffc02001ea:	29258593          	addi	a1,a1,658 # ffffffffc0206478 <end>
ffffffffc02001ee:	00002517          	auipc	a0,0x2
ffffffffc02001f2:	a7a50513          	addi	a0,a0,-1414 # ffffffffc0201c68 <etext+0xf4>
ffffffffc02001f6:	ebdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001fa:	00006597          	auipc	a1,0x6
ffffffffc02001fe:	67d58593          	addi	a1,a1,1661 # ffffffffc0206877 <end+0x3ff>
ffffffffc0200202:	00000797          	auipc	a5,0x0
ffffffffc0200206:	e3478793          	addi	a5,a5,-460 # ffffffffc0200036 <kern_init>
ffffffffc020020a:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020020e:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200212:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200214:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200218:	95be                	add	a1,a1,a5
ffffffffc020021a:	85a9                	srai	a1,a1,0xa
ffffffffc020021c:	00002517          	auipc	a0,0x2
ffffffffc0200220:	a6c50513          	addi	a0,a0,-1428 # ffffffffc0201c88 <etext+0x114>
}
ffffffffc0200224:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200226:	e8dff06f          	j	ffffffffc02000b2 <cprintf>

ffffffffc020022a <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc020022a:	1141                	addi	sp,sp,-16

    panic("Not Implemented!");
ffffffffc020022c:	00002617          	auipc	a2,0x2
ffffffffc0200230:	98c60613          	addi	a2,a2,-1652 # ffffffffc0201bb8 <etext+0x44>
ffffffffc0200234:	04e00593          	li	a1,78
ffffffffc0200238:	00002517          	auipc	a0,0x2
ffffffffc020023c:	99850513          	addi	a0,a0,-1640 # ffffffffc0201bd0 <etext+0x5c>
void print_stackframe(void) {
ffffffffc0200240:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200242:	ef9ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200246 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200246:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200248:	00002617          	auipc	a2,0x2
ffffffffc020024c:	b5060613          	addi	a2,a2,-1200 # ffffffffc0201d98 <commands+0xe0>
ffffffffc0200250:	00002597          	auipc	a1,0x2
ffffffffc0200254:	b6858593          	addi	a1,a1,-1176 # ffffffffc0201db8 <commands+0x100>
ffffffffc0200258:	00002517          	auipc	a0,0x2
ffffffffc020025c:	b6850513          	addi	a0,a0,-1176 # ffffffffc0201dc0 <commands+0x108>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200260:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200262:	e51ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200266:	00002617          	auipc	a2,0x2
ffffffffc020026a:	b6a60613          	addi	a2,a2,-1174 # ffffffffc0201dd0 <commands+0x118>
ffffffffc020026e:	00002597          	auipc	a1,0x2
ffffffffc0200272:	b8a58593          	addi	a1,a1,-1142 # ffffffffc0201df8 <commands+0x140>
ffffffffc0200276:	00002517          	auipc	a0,0x2
ffffffffc020027a:	b4a50513          	addi	a0,a0,-1206 # ffffffffc0201dc0 <commands+0x108>
ffffffffc020027e:	e35ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc0200282:	00002617          	auipc	a2,0x2
ffffffffc0200286:	b8660613          	addi	a2,a2,-1146 # ffffffffc0201e08 <commands+0x150>
ffffffffc020028a:	00002597          	auipc	a1,0x2
ffffffffc020028e:	b9e58593          	addi	a1,a1,-1122 # ffffffffc0201e28 <commands+0x170>
ffffffffc0200292:	00002517          	auipc	a0,0x2
ffffffffc0200296:	b2e50513          	addi	a0,a0,-1234 # ffffffffc0201dc0 <commands+0x108>
ffffffffc020029a:	e19ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    }
    return 0;
}
ffffffffc020029e:	60a2                	ld	ra,8(sp)
ffffffffc02002a0:	4501                	li	a0,0
ffffffffc02002a2:	0141                	addi	sp,sp,16
ffffffffc02002a4:	8082                	ret

ffffffffc02002a6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a6:	1141                	addi	sp,sp,-16
ffffffffc02002a8:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002aa:	ef1ff0ef          	jal	ra,ffffffffc020019a <print_kerninfo>
    return 0;
}
ffffffffc02002ae:	60a2                	ld	ra,8(sp)
ffffffffc02002b0:	4501                	li	a0,0
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	8082                	ret

ffffffffc02002b6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002b6:	1141                	addi	sp,sp,-16
ffffffffc02002b8:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002ba:	f71ff0ef          	jal	ra,ffffffffc020022a <print_stackframe>
    return 0;
}
ffffffffc02002be:	60a2                	ld	ra,8(sp)
ffffffffc02002c0:	4501                	li	a0,0
ffffffffc02002c2:	0141                	addi	sp,sp,16
ffffffffc02002c4:	8082                	ret

ffffffffc02002c6 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002c6:	7115                	addi	sp,sp,-224
ffffffffc02002c8:	e962                	sd	s8,144(sp)
ffffffffc02002ca:	8c2a                	mv	s8,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002cc:	00002517          	auipc	a0,0x2
ffffffffc02002d0:	a3450513          	addi	a0,a0,-1484 # ffffffffc0201d00 <commands+0x48>
kmonitor(struct trapframe *tf) {
ffffffffc02002d4:	ed86                	sd	ra,216(sp)
ffffffffc02002d6:	e9a2                	sd	s0,208(sp)
ffffffffc02002d8:	e5a6                	sd	s1,200(sp)
ffffffffc02002da:	e1ca                	sd	s2,192(sp)
ffffffffc02002dc:	fd4e                	sd	s3,184(sp)
ffffffffc02002de:	f952                	sd	s4,176(sp)
ffffffffc02002e0:	f556                	sd	s5,168(sp)
ffffffffc02002e2:	f15a                	sd	s6,160(sp)
ffffffffc02002e4:	ed5e                	sd	s7,152(sp)
ffffffffc02002e6:	e566                	sd	s9,136(sp)
ffffffffc02002e8:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002ea:	dc9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002ee:	00002517          	auipc	a0,0x2
ffffffffc02002f2:	a3a50513          	addi	a0,a0,-1478 # ffffffffc0201d28 <commands+0x70>
ffffffffc02002f6:	dbdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    if (tf != NULL) {
ffffffffc02002fa:	000c0563          	beqz	s8,ffffffffc0200304 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002fe:	8562                	mv	a0,s8
ffffffffc0200300:	346000ef          	jal	ra,ffffffffc0200646 <print_trapframe>
ffffffffc0200304:	00002c97          	auipc	s9,0x2
ffffffffc0200308:	9b4c8c93          	addi	s9,s9,-1612 # ffffffffc0201cb8 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020030c:	00002997          	auipc	s3,0x2
ffffffffc0200310:	a4498993          	addi	s3,s3,-1468 # ffffffffc0201d50 <commands+0x98>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200314:	00002917          	auipc	s2,0x2
ffffffffc0200318:	a4490913          	addi	s2,s2,-1468 # ffffffffc0201d58 <commands+0xa0>
        if (argc == MAXARGS - 1) {
ffffffffc020031c:	4a3d                	li	s4,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020031e:	00002b17          	auipc	s6,0x2
ffffffffc0200322:	a42b0b13          	addi	s6,s6,-1470 # ffffffffc0201d60 <commands+0xa8>
    if (argc == 0) {
ffffffffc0200326:	00002a97          	auipc	s5,0x2
ffffffffc020032a:	a92a8a93          	addi	s5,s5,-1390 # ffffffffc0201db8 <commands+0x100>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020032e:	4b8d                	li	s7,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200330:	854e                	mv	a0,s3
ffffffffc0200332:	784010ef          	jal	ra,ffffffffc0201ab6 <readline>
ffffffffc0200336:	842a                	mv	s0,a0
ffffffffc0200338:	dd65                	beqz	a0,ffffffffc0200330 <kmonitor+0x6a>
ffffffffc020033a:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020033e:	4481                	li	s1,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200340:	c999                	beqz	a1,ffffffffc0200356 <kmonitor+0x90>
ffffffffc0200342:	854a                	mv	a0,s2
ffffffffc0200344:	2f4010ef          	jal	ra,ffffffffc0201638 <strchr>
ffffffffc0200348:	c925                	beqz	a0,ffffffffc02003b8 <kmonitor+0xf2>
            *buf ++ = '\0';
ffffffffc020034a:	00144583          	lbu	a1,1(s0)
ffffffffc020034e:	00040023          	sb	zero,0(s0)
ffffffffc0200352:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200354:	f5fd                	bnez	a1,ffffffffc0200342 <kmonitor+0x7c>
    if (argc == 0) {
ffffffffc0200356:	dce9                	beqz	s1,ffffffffc0200330 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200358:	6582                	ld	a1,0(sp)
ffffffffc020035a:	00002d17          	auipc	s10,0x2
ffffffffc020035e:	95ed0d13          	addi	s10,s10,-1698 # ffffffffc0201cb8 <commands>
    if (argc == 0) {
ffffffffc0200362:	8556                	mv	a0,s5
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200364:	4401                	li	s0,0
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200366:	0d61                	addi	s10,s10,24
ffffffffc0200368:	2a6010ef          	jal	ra,ffffffffc020160e <strcmp>
ffffffffc020036c:	c919                	beqz	a0,ffffffffc0200382 <kmonitor+0xbc>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020036e:	2405                	addiw	s0,s0,1
ffffffffc0200370:	09740463          	beq	s0,s7,ffffffffc02003f8 <kmonitor+0x132>
ffffffffc0200374:	000d3503          	ld	a0,0(s10)
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200378:	6582                	ld	a1,0(sp)
ffffffffc020037a:	0d61                	addi	s10,s10,24
ffffffffc020037c:	292010ef          	jal	ra,ffffffffc020160e <strcmp>
ffffffffc0200380:	f57d                	bnez	a0,ffffffffc020036e <kmonitor+0xa8>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200382:	00141793          	slli	a5,s0,0x1
ffffffffc0200386:	97a2                	add	a5,a5,s0
ffffffffc0200388:	078e                	slli	a5,a5,0x3
ffffffffc020038a:	97e6                	add	a5,a5,s9
ffffffffc020038c:	6b9c                	ld	a5,16(a5)
ffffffffc020038e:	8662                	mv	a2,s8
ffffffffc0200390:	002c                	addi	a1,sp,8
ffffffffc0200392:	fff4851b          	addiw	a0,s1,-1
ffffffffc0200396:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200398:	f8055ce3          	bgez	a0,ffffffffc0200330 <kmonitor+0x6a>
}
ffffffffc020039c:	60ee                	ld	ra,216(sp)
ffffffffc020039e:	644e                	ld	s0,208(sp)
ffffffffc02003a0:	64ae                	ld	s1,200(sp)
ffffffffc02003a2:	690e                	ld	s2,192(sp)
ffffffffc02003a4:	79ea                	ld	s3,184(sp)
ffffffffc02003a6:	7a4a                	ld	s4,176(sp)
ffffffffc02003a8:	7aaa                	ld	s5,168(sp)
ffffffffc02003aa:	7b0a                	ld	s6,160(sp)
ffffffffc02003ac:	6bea                	ld	s7,152(sp)
ffffffffc02003ae:	6c4a                	ld	s8,144(sp)
ffffffffc02003b0:	6caa                	ld	s9,136(sp)
ffffffffc02003b2:	6d0a                	ld	s10,128(sp)
ffffffffc02003b4:	612d                	addi	sp,sp,224
ffffffffc02003b6:	8082                	ret
        if (*buf == '\0') {
ffffffffc02003b8:	00044783          	lbu	a5,0(s0)
ffffffffc02003bc:	dfc9                	beqz	a5,ffffffffc0200356 <kmonitor+0x90>
        if (argc == MAXARGS - 1) {
ffffffffc02003be:	03448863          	beq	s1,s4,ffffffffc02003ee <kmonitor+0x128>
        argv[argc ++] = buf;
ffffffffc02003c2:	00349793          	slli	a5,s1,0x3
ffffffffc02003c6:	0118                	addi	a4,sp,128
ffffffffc02003c8:	97ba                	add	a5,a5,a4
ffffffffc02003ca:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003ce:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003d2:	2485                	addiw	s1,s1,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003d4:	e591                	bnez	a1,ffffffffc02003e0 <kmonitor+0x11a>
ffffffffc02003d6:	b749                	j	ffffffffc0200358 <kmonitor+0x92>
            buf ++;
ffffffffc02003d8:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003da:	00044583          	lbu	a1,0(s0)
ffffffffc02003de:	ddad                	beqz	a1,ffffffffc0200358 <kmonitor+0x92>
ffffffffc02003e0:	854a                	mv	a0,s2
ffffffffc02003e2:	256010ef          	jal	ra,ffffffffc0201638 <strchr>
ffffffffc02003e6:	d96d                	beqz	a0,ffffffffc02003d8 <kmonitor+0x112>
ffffffffc02003e8:	00044583          	lbu	a1,0(s0)
ffffffffc02003ec:	bf91                	j	ffffffffc0200340 <kmonitor+0x7a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ee:	45c1                	li	a1,16
ffffffffc02003f0:	855a                	mv	a0,s6
ffffffffc02003f2:	cc1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
ffffffffc02003f6:	b7f1                	j	ffffffffc02003c2 <kmonitor+0xfc>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003f8:	6582                	ld	a1,0(sp)
ffffffffc02003fa:	00002517          	auipc	a0,0x2
ffffffffc02003fe:	98650513          	addi	a0,a0,-1658 # ffffffffc0201d80 <commands+0xc8>
ffffffffc0200402:	cb1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    return 0;
ffffffffc0200406:	b72d                	j	ffffffffc0200330 <kmonitor+0x6a>

ffffffffc0200408 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200408:	1141                	addi	sp,sp,-16
ffffffffc020040a:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc020040c:	02000793          	li	a5,32
ffffffffc0200410:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200414:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200418:	67e1                	lui	a5,0x18
ffffffffc020041a:	6a078793          	addi	a5,a5,1696 # 186a0 <BASE_ADDRESS-0xffffffffc01e7960>
ffffffffc020041e:	953e                	add	a0,a0,a5
ffffffffc0200420:	65c010ef          	jal	ra,ffffffffc0201a7c <sbi_set_timer>
}
ffffffffc0200424:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200426:	00006797          	auipc	a5,0x6
ffffffffc020042a:	0007b923          	sd	zero,18(a5) # ffffffffc0206438 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020042e:	00002517          	auipc	a0,0x2
ffffffffc0200432:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0201e38 <commands+0x180>
}
ffffffffc0200436:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200438:	c7bff06f          	j	ffffffffc02000b2 <cprintf>

ffffffffc020043c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020043c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200440:	67e1                	lui	a5,0x18
ffffffffc0200442:	6a078793          	addi	a5,a5,1696 # 186a0 <BASE_ADDRESS-0xffffffffc01e7960>
ffffffffc0200446:	953e                	add	a0,a0,a5
ffffffffc0200448:	6340106f          	j	ffffffffc0201a7c <sbi_set_timer>

ffffffffc020044c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020044c:	8082                	ret

ffffffffc020044e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020044e:	0ff57513          	andi	a0,a0,255
ffffffffc0200452:	60e0106f          	j	ffffffffc0201a60 <sbi_console_putchar>

ffffffffc0200456 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200456:	6420106f          	j	ffffffffc0201a98 <sbi_console_getchar>

ffffffffc020045a <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020045a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020045e:	8082                	ret

ffffffffc0200460 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200460:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200464:	8082                	ret

ffffffffc0200466 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200466:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc020046a:	00000797          	auipc	a5,0x0
ffffffffc020046e:	3a678793          	addi	a5,a5,934 # ffffffffc0200810 <__alltraps>
ffffffffc0200472:	10579073          	csrw	stvec,a5
}
ffffffffc0200476:	8082                	ret

ffffffffc0200478 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200478:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc020047a:	1141                	addi	sp,sp,-16
ffffffffc020047c:	e022                	sd	s0,0(sp)
ffffffffc020047e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200480:	00002517          	auipc	a0,0x2
ffffffffc0200484:	b6850513          	addi	a0,a0,-1176 # ffffffffc0201fe8 <commands+0x330>
void print_regs(struct pushregs *gpr) {
ffffffffc0200488:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020048a:	c29ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020048e:	640c                	ld	a1,8(s0)
ffffffffc0200490:	00002517          	auipc	a0,0x2
ffffffffc0200494:	b7050513          	addi	a0,a0,-1168 # ffffffffc0202000 <commands+0x348>
ffffffffc0200498:	c1bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020049c:	680c                	ld	a1,16(s0)
ffffffffc020049e:	00002517          	auipc	a0,0x2
ffffffffc02004a2:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0202018 <commands+0x360>
ffffffffc02004a6:	c0dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc02004aa:	6c0c                	ld	a1,24(s0)
ffffffffc02004ac:	00002517          	auipc	a0,0x2
ffffffffc02004b0:	b8450513          	addi	a0,a0,-1148 # ffffffffc0202030 <commands+0x378>
ffffffffc02004b4:	bffff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc02004b8:	700c                	ld	a1,32(s0)
ffffffffc02004ba:	00002517          	auipc	a0,0x2
ffffffffc02004be:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0202048 <commands+0x390>
ffffffffc02004c2:	bf1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02004c6:	740c                	ld	a1,40(s0)
ffffffffc02004c8:	00002517          	auipc	a0,0x2
ffffffffc02004cc:	b9850513          	addi	a0,a0,-1128 # ffffffffc0202060 <commands+0x3a8>
ffffffffc02004d0:	be3ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02004d4:	780c                	ld	a1,48(s0)
ffffffffc02004d6:	00002517          	auipc	a0,0x2
ffffffffc02004da:	ba250513          	addi	a0,a0,-1118 # ffffffffc0202078 <commands+0x3c0>
ffffffffc02004de:	bd5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02004e2:	7c0c                	ld	a1,56(s0)
ffffffffc02004e4:	00002517          	auipc	a0,0x2
ffffffffc02004e8:	bac50513          	addi	a0,a0,-1108 # ffffffffc0202090 <commands+0x3d8>
ffffffffc02004ec:	bc7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02004f0:	602c                	ld	a1,64(s0)
ffffffffc02004f2:	00002517          	auipc	a0,0x2
ffffffffc02004f6:	bb650513          	addi	a0,a0,-1098 # ffffffffc02020a8 <commands+0x3f0>
ffffffffc02004fa:	bb9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02004fe:	642c                	ld	a1,72(s0)
ffffffffc0200500:	00002517          	auipc	a0,0x2
ffffffffc0200504:	bc050513          	addi	a0,a0,-1088 # ffffffffc02020c0 <commands+0x408>
ffffffffc0200508:	babff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc020050c:	682c                	ld	a1,80(s0)
ffffffffc020050e:	00002517          	auipc	a0,0x2
ffffffffc0200512:	bca50513          	addi	a0,a0,-1078 # ffffffffc02020d8 <commands+0x420>
ffffffffc0200516:	b9dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc020051a:	6c2c                	ld	a1,88(s0)
ffffffffc020051c:	00002517          	auipc	a0,0x2
ffffffffc0200520:	bd450513          	addi	a0,a0,-1068 # ffffffffc02020f0 <commands+0x438>
ffffffffc0200524:	b8fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200528:	702c                	ld	a1,96(s0)
ffffffffc020052a:	00002517          	auipc	a0,0x2
ffffffffc020052e:	bde50513          	addi	a0,a0,-1058 # ffffffffc0202108 <commands+0x450>
ffffffffc0200532:	b81ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200536:	742c                	ld	a1,104(s0)
ffffffffc0200538:	00002517          	auipc	a0,0x2
ffffffffc020053c:	be850513          	addi	a0,a0,-1048 # ffffffffc0202120 <commands+0x468>
ffffffffc0200540:	b73ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200544:	782c                	ld	a1,112(s0)
ffffffffc0200546:	00002517          	auipc	a0,0x2
ffffffffc020054a:	bf250513          	addi	a0,a0,-1038 # ffffffffc0202138 <commands+0x480>
ffffffffc020054e:	b65ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200552:	7c2c                	ld	a1,120(s0)
ffffffffc0200554:	00002517          	auipc	a0,0x2
ffffffffc0200558:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0202150 <commands+0x498>
ffffffffc020055c:	b57ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200560:	604c                	ld	a1,128(s0)
ffffffffc0200562:	00002517          	auipc	a0,0x2
ffffffffc0200566:	c0650513          	addi	a0,a0,-1018 # ffffffffc0202168 <commands+0x4b0>
ffffffffc020056a:	b49ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020056e:	644c                	ld	a1,136(s0)
ffffffffc0200570:	00002517          	auipc	a0,0x2
ffffffffc0200574:	c1050513          	addi	a0,a0,-1008 # ffffffffc0202180 <commands+0x4c8>
ffffffffc0200578:	b3bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020057c:	684c                	ld	a1,144(s0)
ffffffffc020057e:	00002517          	auipc	a0,0x2
ffffffffc0200582:	c1a50513          	addi	a0,a0,-998 # ffffffffc0202198 <commands+0x4e0>
ffffffffc0200586:	b2dff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020058a:	6c4c                	ld	a1,152(s0)
ffffffffc020058c:	00002517          	auipc	a0,0x2
ffffffffc0200590:	c2450513          	addi	a0,a0,-988 # ffffffffc02021b0 <commands+0x4f8>
ffffffffc0200594:	b1fff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200598:	704c                	ld	a1,160(s0)
ffffffffc020059a:	00002517          	auipc	a0,0x2
ffffffffc020059e:	c2e50513          	addi	a0,a0,-978 # ffffffffc02021c8 <commands+0x510>
ffffffffc02005a2:	b11ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc02005a6:	744c                	ld	a1,168(s0)
ffffffffc02005a8:	00002517          	auipc	a0,0x2
ffffffffc02005ac:	c3850513          	addi	a0,a0,-968 # ffffffffc02021e0 <commands+0x528>
ffffffffc02005b0:	b03ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc02005b4:	784c                	ld	a1,176(s0)
ffffffffc02005b6:	00002517          	auipc	a0,0x2
ffffffffc02005ba:	c4250513          	addi	a0,a0,-958 # ffffffffc02021f8 <commands+0x540>
ffffffffc02005be:	af5ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc02005c2:	7c4c                	ld	a1,184(s0)
ffffffffc02005c4:	00002517          	auipc	a0,0x2
ffffffffc02005c8:	c4c50513          	addi	a0,a0,-948 # ffffffffc0202210 <commands+0x558>
ffffffffc02005cc:	ae7ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02005d0:	606c                	ld	a1,192(s0)
ffffffffc02005d2:	00002517          	auipc	a0,0x2
ffffffffc02005d6:	c5650513          	addi	a0,a0,-938 # ffffffffc0202228 <commands+0x570>
ffffffffc02005da:	ad9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02005de:	646c                	ld	a1,200(s0)
ffffffffc02005e0:	00002517          	auipc	a0,0x2
ffffffffc02005e4:	c6050513          	addi	a0,a0,-928 # ffffffffc0202240 <commands+0x588>
ffffffffc02005e8:	acbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02005ec:	686c                	ld	a1,208(s0)
ffffffffc02005ee:	00002517          	auipc	a0,0x2
ffffffffc02005f2:	c6a50513          	addi	a0,a0,-918 # ffffffffc0202258 <commands+0x5a0>
ffffffffc02005f6:	abdff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02005fa:	6c6c                	ld	a1,216(s0)
ffffffffc02005fc:	00002517          	auipc	a0,0x2
ffffffffc0200600:	c7450513          	addi	a0,a0,-908 # ffffffffc0202270 <commands+0x5b8>
ffffffffc0200604:	aafff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200608:	706c                	ld	a1,224(s0)
ffffffffc020060a:	00002517          	auipc	a0,0x2
ffffffffc020060e:	c7e50513          	addi	a0,a0,-898 # ffffffffc0202288 <commands+0x5d0>
ffffffffc0200612:	aa1ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200616:	746c                	ld	a1,232(s0)
ffffffffc0200618:	00002517          	auipc	a0,0x2
ffffffffc020061c:	c8850513          	addi	a0,a0,-888 # ffffffffc02022a0 <commands+0x5e8>
ffffffffc0200620:	a93ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200624:	786c                	ld	a1,240(s0)
ffffffffc0200626:	00002517          	auipc	a0,0x2
ffffffffc020062a:	c9250513          	addi	a0,a0,-878 # ffffffffc02022b8 <commands+0x600>
ffffffffc020062e:	a85ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200632:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200634:	6402                	ld	s0,0(sp)
ffffffffc0200636:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200638:	00002517          	auipc	a0,0x2
ffffffffc020063c:	c9850513          	addi	a0,a0,-872 # ffffffffc02022d0 <commands+0x618>
}
ffffffffc0200640:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200642:	a71ff06f          	j	ffffffffc02000b2 <cprintf>

ffffffffc0200646 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200646:	1141                	addi	sp,sp,-16
ffffffffc0200648:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc020064a:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc020064c:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc020064e:	00002517          	auipc	a0,0x2
ffffffffc0200652:	c9a50513          	addi	a0,a0,-870 # ffffffffc02022e8 <commands+0x630>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200656:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200658:	a5bff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    print_regs(&tf->gpr);
ffffffffc020065c:	8522                	mv	a0,s0
ffffffffc020065e:	e1bff0ef          	jal	ra,ffffffffc0200478 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200662:	10043583          	ld	a1,256(s0)
ffffffffc0200666:	00002517          	auipc	a0,0x2
ffffffffc020066a:	c9a50513          	addi	a0,a0,-870 # ffffffffc0202300 <commands+0x648>
ffffffffc020066e:	a45ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200672:	10843583          	ld	a1,264(s0)
ffffffffc0200676:	00002517          	auipc	a0,0x2
ffffffffc020067a:	ca250513          	addi	a0,a0,-862 # ffffffffc0202318 <commands+0x660>
ffffffffc020067e:	a35ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200682:	11043583          	ld	a1,272(s0)
ffffffffc0200686:	00002517          	auipc	a0,0x2
ffffffffc020068a:	caa50513          	addi	a0,a0,-854 # ffffffffc0202330 <commands+0x678>
ffffffffc020068e:	a25ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200692:	11843583          	ld	a1,280(s0)
}
ffffffffc0200696:	6402                	ld	s0,0(sp)
ffffffffc0200698:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc020069a:	00002517          	auipc	a0,0x2
ffffffffc020069e:	cae50513          	addi	a0,a0,-850 # ffffffffc0202348 <commands+0x690>
}
ffffffffc02006a2:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc02006a4:	a0fff06f          	j	ffffffffc02000b2 <cprintf>

ffffffffc02006a8 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc02006a8:	11853783          	ld	a5,280(a0)
ffffffffc02006ac:	577d                	li	a4,-1
ffffffffc02006ae:	8305                	srli	a4,a4,0x1
ffffffffc02006b0:	8ff9                	and	a5,a5,a4
    switch (cause) {
ffffffffc02006b2:	472d                	li	a4,11
ffffffffc02006b4:	08f76563          	bltu	a4,a5,ffffffffc020073e <interrupt_handler+0x96>
ffffffffc02006b8:	00001717          	auipc	a4,0x1
ffffffffc02006bc:	79c70713          	addi	a4,a4,1948 # ffffffffc0201e54 <commands+0x19c>
ffffffffc02006c0:	078a                	slli	a5,a5,0x2
ffffffffc02006c2:	97ba                	add	a5,a5,a4
ffffffffc02006c4:	439c                	lw	a5,0(a5)
ffffffffc02006c6:	97ba                	add	a5,a5,a4
ffffffffc02006c8:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc02006ca:	00002517          	auipc	a0,0x2
ffffffffc02006ce:	8b650513          	addi	a0,a0,-1866 # ffffffffc0201f80 <commands+0x2c8>
ffffffffc02006d2:	9e1ff06f          	j	ffffffffc02000b2 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc02006d6:	00002517          	auipc	a0,0x2
ffffffffc02006da:	88a50513          	addi	a0,a0,-1910 # ffffffffc0201f60 <commands+0x2a8>
ffffffffc02006de:	9d5ff06f          	j	ffffffffc02000b2 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc02006e2:	00002517          	auipc	a0,0x2
ffffffffc02006e6:	83e50513          	addi	a0,a0,-1986 # ffffffffc0201f20 <commands+0x268>
ffffffffc02006ea:	9c9ff06f          	j	ffffffffc02000b2 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc02006ee:	00002517          	auipc	a0,0x2
ffffffffc02006f2:	8b250513          	addi	a0,a0,-1870 # ffffffffc0201fa0 <commands+0x2e8>
ffffffffc02006f6:	9bdff06f          	j	ffffffffc02000b2 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc02006fa:	1141                	addi	sp,sp,-16
ffffffffc02006fc:	e406                	sd	ra,8(sp)
            // read-only." -- privileged spec1.9.1, 4.1.4, p59
            // In fact, Call sbi_set_timer will clear STIP, or you can clear it
            // directly.
            // cprintf("Supervisor timer interrupt\n");
            // clear_csr(sip, SIP_STIP);
            clock_set_next_event();
ffffffffc02006fe:	d3fff0ef          	jal	ra,ffffffffc020043c <clock_set_next_event>
            if (++ticks % TICK_NUM == 0) {
ffffffffc0200702:	00006797          	auipc	a5,0x6
ffffffffc0200706:	d3678793          	addi	a5,a5,-714 # ffffffffc0206438 <ticks>
ffffffffc020070a:	639c                	ld	a5,0(a5)
ffffffffc020070c:	06400713          	li	a4,100
ffffffffc0200710:	0785                	addi	a5,a5,1
ffffffffc0200712:	02e7f733          	remu	a4,a5,a4
ffffffffc0200716:	00006697          	auipc	a3,0x6
ffffffffc020071a:	d2f6b123          	sd	a5,-734(a3) # ffffffffc0206438 <ticks>
ffffffffc020071e:	c315                	beqz	a4,ffffffffc0200742 <interrupt_handler+0x9a>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200720:	60a2                	ld	ra,8(sp)
ffffffffc0200722:	0141                	addi	sp,sp,16
ffffffffc0200724:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200726:	00002517          	auipc	a0,0x2
ffffffffc020072a:	8a250513          	addi	a0,a0,-1886 # ffffffffc0201fc8 <commands+0x310>
ffffffffc020072e:	985ff06f          	j	ffffffffc02000b2 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200732:	00002517          	auipc	a0,0x2
ffffffffc0200736:	80e50513          	addi	a0,a0,-2034 # ffffffffc0201f40 <commands+0x288>
ffffffffc020073a:	979ff06f          	j	ffffffffc02000b2 <cprintf>
            print_trapframe(tf);
ffffffffc020073e:	f09ff06f          	j	ffffffffc0200646 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200742:	06400593          	li	a1,100
ffffffffc0200746:	00002517          	auipc	a0,0x2
ffffffffc020074a:	87250513          	addi	a0,a0,-1934 # ffffffffc0201fb8 <commands+0x300>
ffffffffc020074e:	965ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
                num_ticks++;
ffffffffc0200752:	00006797          	auipc	a5,0x6
ffffffffc0200756:	cc678793          	addi	a5,a5,-826 # ffffffffc0206418 <num_ticks>
ffffffffc020075a:	639c                	ld	a5,0(a5)
ffffffffc020075c:	0785                	addi	a5,a5,1
ffffffffc020075e:	00006717          	auipc	a4,0x6
ffffffffc0200762:	caf73d23          	sd	a5,-838(a4) # ffffffffc0206418 <num_ticks>
ffffffffc0200766:	bf6d                	j	ffffffffc0200720 <interrupt_handler+0x78>

ffffffffc0200768 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200768:	11853783          	ld	a5,280(a0)
ffffffffc020076c:	472d                	li	a4,11
ffffffffc020076e:	02f76863          	bltu	a4,a5,ffffffffc020079e <exception_handler+0x36>
ffffffffc0200772:	4705                	li	a4,1
ffffffffc0200774:	00f71733          	sll	a4,a4,a5
ffffffffc0200778:	6785                	lui	a5,0x1
ffffffffc020077a:	17cd                	addi	a5,a5,-13
ffffffffc020077c:	8ff9                	and	a5,a5,a4
ffffffffc020077e:	ef99                	bnez	a5,ffffffffc020079c <exception_handler+0x34>
void exception_handler(struct trapframe *tf) {
ffffffffc0200780:	1141                	addi	sp,sp,-16
ffffffffc0200782:	e022                	sd	s0,0(sp)
ffffffffc0200784:	e406                	sd	ra,8(sp)
ffffffffc0200786:	00877793          	andi	a5,a4,8
ffffffffc020078a:	842a                	mv	s0,a0
ffffffffc020078c:	e3b1                	bnez	a5,ffffffffc02007d0 <exception_handler+0x68>
ffffffffc020078e:	8b11                	andi	a4,a4,4
ffffffffc0200790:	eb09                	bnez	a4,ffffffffc02007a2 <exception_handler+0x3a>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200792:	6402                	ld	s0,0(sp)
ffffffffc0200794:	60a2                	ld	ra,8(sp)
ffffffffc0200796:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc0200798:	eafff06f          	j	ffffffffc0200646 <print_trapframe>
ffffffffc020079c:	8082                	ret
ffffffffc020079e:	ea9ff06f          	j	ffffffffc0200646 <print_trapframe>
            cprintf("Exception type: Illegal instruction\n");//输出指令异常类型
ffffffffc02007a2:	00001517          	auipc	a0,0x1
ffffffffc02007a6:	6e650513          	addi	a0,a0,1766 # ffffffffc0201e88 <commands+0x1d0>
ffffffffc02007aa:	909ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
	    	cprintf("Illegal instruction caught at 0x%016llx\n", tf->epc); //输出异常指令地址
ffffffffc02007ae:	10843583          	ld	a1,264(s0)
ffffffffc02007b2:	00001517          	auipc	a0,0x1
ffffffffc02007b6:	6fe50513          	addi	a0,a0,1790 # ffffffffc0201eb0 <commands+0x1f8>
ffffffffc02007ba:	8f9ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
            tf->epc += 4;// 更新 epc 寄存器以继续执行下一条指令
ffffffffc02007be:	10843783          	ld	a5,264(s0)
}
ffffffffc02007c2:	60a2                	ld	ra,8(sp)
            tf->epc += 4;// 更新 epc 寄存器以继续执行下一条指令
ffffffffc02007c4:	0791                	addi	a5,a5,4
ffffffffc02007c6:	10f43423          	sd	a5,264(s0)
}
ffffffffc02007ca:	6402                	ld	s0,0(sp)
ffffffffc02007cc:	0141                	addi	sp,sp,16
ffffffffc02007ce:	8082                	ret
            cprintf("Exception type: breakpoint\n"); //输出指令异常类型
ffffffffc02007d0:	00001517          	auipc	a0,0x1
ffffffffc02007d4:	71050513          	addi	a0,a0,1808 # ffffffffc0201ee0 <commands+0x228>
ffffffffc02007d8:	8dbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
	        cprintf("ebreak caught at 0x%016llx\n", tf->epc);	//输出异常指令地址
ffffffffc02007dc:	10843583          	ld	a1,264(s0)
ffffffffc02007e0:	00001517          	auipc	a0,0x1
ffffffffc02007e4:	72050513          	addi	a0,a0,1824 # ffffffffc0201f00 <commands+0x248>
ffffffffc02007e8:	8cbff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
            tf->epc += 2;  // 更新 epc 寄存器以继续执行下一条指令 +2
ffffffffc02007ec:	10843783          	ld	a5,264(s0)
}
ffffffffc02007f0:	60a2                	ld	ra,8(sp)
            tf->epc += 2;  // 更新 epc 寄存器以继续执行下一条指令 +2
ffffffffc02007f2:	0789                	addi	a5,a5,2
ffffffffc02007f4:	10f43423          	sd	a5,264(s0)
}
ffffffffc02007f8:	6402                	ld	s0,0(sp)
ffffffffc02007fa:	0141                	addi	sp,sp,16
ffffffffc02007fc:	8082                	ret

ffffffffc02007fe <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc02007fe:	11853783          	ld	a5,280(a0)
ffffffffc0200802:	0007c463          	bltz	a5,ffffffffc020080a <trap+0xc>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200806:	f63ff06f          	j	ffffffffc0200768 <exception_handler>
        interrupt_handler(tf);
ffffffffc020080a:	e9fff06f          	j	ffffffffc02006a8 <interrupt_handler>
	...

ffffffffc0200810 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200810:	14011073          	csrw	sscratch,sp
ffffffffc0200814:	712d                	addi	sp,sp,-288
ffffffffc0200816:	e002                	sd	zero,0(sp)
ffffffffc0200818:	e406                	sd	ra,8(sp)
ffffffffc020081a:	ec0e                	sd	gp,24(sp)
ffffffffc020081c:	f012                	sd	tp,32(sp)
ffffffffc020081e:	f416                	sd	t0,40(sp)
ffffffffc0200820:	f81a                	sd	t1,48(sp)
ffffffffc0200822:	fc1e                	sd	t2,56(sp)
ffffffffc0200824:	e0a2                	sd	s0,64(sp)
ffffffffc0200826:	e4a6                	sd	s1,72(sp)
ffffffffc0200828:	e8aa                	sd	a0,80(sp)
ffffffffc020082a:	ecae                	sd	a1,88(sp)
ffffffffc020082c:	f0b2                	sd	a2,96(sp)
ffffffffc020082e:	f4b6                	sd	a3,104(sp)
ffffffffc0200830:	f8ba                	sd	a4,112(sp)
ffffffffc0200832:	fcbe                	sd	a5,120(sp)
ffffffffc0200834:	e142                	sd	a6,128(sp)
ffffffffc0200836:	e546                	sd	a7,136(sp)
ffffffffc0200838:	e94a                	sd	s2,144(sp)
ffffffffc020083a:	ed4e                	sd	s3,152(sp)
ffffffffc020083c:	f152                	sd	s4,160(sp)
ffffffffc020083e:	f556                	sd	s5,168(sp)
ffffffffc0200840:	f95a                	sd	s6,176(sp)
ffffffffc0200842:	fd5e                	sd	s7,184(sp)
ffffffffc0200844:	e1e2                	sd	s8,192(sp)
ffffffffc0200846:	e5e6                	sd	s9,200(sp)
ffffffffc0200848:	e9ea                	sd	s10,208(sp)
ffffffffc020084a:	edee                	sd	s11,216(sp)
ffffffffc020084c:	f1f2                	sd	t3,224(sp)
ffffffffc020084e:	f5f6                	sd	t4,232(sp)
ffffffffc0200850:	f9fa                	sd	t5,240(sp)
ffffffffc0200852:	fdfe                	sd	t6,248(sp)
ffffffffc0200854:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200858:	100024f3          	csrr	s1,sstatus
ffffffffc020085c:	14102973          	csrr	s2,sepc
ffffffffc0200860:	143029f3          	csrr	s3,stval
ffffffffc0200864:	14202a73          	csrr	s4,scause
ffffffffc0200868:	e822                	sd	s0,16(sp)
ffffffffc020086a:	e226                	sd	s1,256(sp)
ffffffffc020086c:	e64a                	sd	s2,264(sp)
ffffffffc020086e:	ea4e                	sd	s3,272(sp)
ffffffffc0200870:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200872:	850a                	mv	a0,sp
    jal trap
ffffffffc0200874:	f8bff0ef          	jal	ra,ffffffffc02007fe <trap>

ffffffffc0200878 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200878:	6492                	ld	s1,256(sp)
ffffffffc020087a:	6932                	ld	s2,264(sp)
ffffffffc020087c:	10049073          	csrw	sstatus,s1
ffffffffc0200880:	14191073          	csrw	sepc,s2
ffffffffc0200884:	60a2                	ld	ra,8(sp)
ffffffffc0200886:	61e2                	ld	gp,24(sp)
ffffffffc0200888:	7202                	ld	tp,32(sp)
ffffffffc020088a:	72a2                	ld	t0,40(sp)
ffffffffc020088c:	7342                	ld	t1,48(sp)
ffffffffc020088e:	73e2                	ld	t2,56(sp)
ffffffffc0200890:	6406                	ld	s0,64(sp)
ffffffffc0200892:	64a6                	ld	s1,72(sp)
ffffffffc0200894:	6546                	ld	a0,80(sp)
ffffffffc0200896:	65e6                	ld	a1,88(sp)
ffffffffc0200898:	7606                	ld	a2,96(sp)
ffffffffc020089a:	76a6                	ld	a3,104(sp)
ffffffffc020089c:	7746                	ld	a4,112(sp)
ffffffffc020089e:	77e6                	ld	a5,120(sp)
ffffffffc02008a0:	680a                	ld	a6,128(sp)
ffffffffc02008a2:	68aa                	ld	a7,136(sp)
ffffffffc02008a4:	694a                	ld	s2,144(sp)
ffffffffc02008a6:	69ea                	ld	s3,152(sp)
ffffffffc02008a8:	7a0a                	ld	s4,160(sp)
ffffffffc02008aa:	7aaa                	ld	s5,168(sp)
ffffffffc02008ac:	7b4a                	ld	s6,176(sp)
ffffffffc02008ae:	7bea                	ld	s7,184(sp)
ffffffffc02008b0:	6c0e                	ld	s8,192(sp)
ffffffffc02008b2:	6cae                	ld	s9,200(sp)
ffffffffc02008b4:	6d4e                	ld	s10,208(sp)
ffffffffc02008b6:	6dee                	ld	s11,216(sp)
ffffffffc02008b8:	7e0e                	ld	t3,224(sp)
ffffffffc02008ba:	7eae                	ld	t4,232(sp)
ffffffffc02008bc:	7f4e                	ld	t5,240(sp)
ffffffffc02008be:	7fee                	ld	t6,248(sp)
ffffffffc02008c0:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc02008c2:	10200073          	sret

ffffffffc02008c6 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008c6:	100027f3          	csrr	a5,sstatus
ffffffffc02008ca:	8b89                	andi	a5,a5,2
ffffffffc02008cc:	eb89                	bnez	a5,ffffffffc02008de <alloc_pages+0x18>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02008ce:	00006797          	auipc	a5,0x6
ffffffffc02008d2:	b7a78793          	addi	a5,a5,-1158 # ffffffffc0206448 <pmm_manager>
ffffffffc02008d6:	639c                	ld	a5,0(a5)
ffffffffc02008d8:	0187b303          	ld	t1,24(a5)
ffffffffc02008dc:	8302                	jr	t1
struct Page *alloc_pages(size_t n) {
ffffffffc02008de:	1141                	addi	sp,sp,-16
ffffffffc02008e0:	e406                	sd	ra,8(sp)
ffffffffc02008e2:	e022                	sd	s0,0(sp)
ffffffffc02008e4:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02008e6:	b7bff0ef          	jal	ra,ffffffffc0200460 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02008ea:	00006797          	auipc	a5,0x6
ffffffffc02008ee:	b5e78793          	addi	a5,a5,-1186 # ffffffffc0206448 <pmm_manager>
ffffffffc02008f2:	639c                	ld	a5,0(a5)
ffffffffc02008f4:	8522                	mv	a0,s0
ffffffffc02008f6:	6f9c                	ld	a5,24(a5)
ffffffffc02008f8:	9782                	jalr	a5
ffffffffc02008fa:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02008fc:	b5fff0ef          	jal	ra,ffffffffc020045a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0200900:	8522                	mv	a0,s0
ffffffffc0200902:	60a2                	ld	ra,8(sp)
ffffffffc0200904:	6402                	ld	s0,0(sp)
ffffffffc0200906:	0141                	addi	sp,sp,16
ffffffffc0200908:	8082                	ret

ffffffffc020090a <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020090a:	100027f3          	csrr	a5,sstatus
ffffffffc020090e:	8b89                	andi	a5,a5,2
ffffffffc0200910:	eb89                	bnez	a5,ffffffffc0200922 <free_pages+0x18>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200912:	00006797          	auipc	a5,0x6
ffffffffc0200916:	b3678793          	addi	a5,a5,-1226 # ffffffffc0206448 <pmm_manager>
ffffffffc020091a:	639c                	ld	a5,0(a5)
ffffffffc020091c:	0207b303          	ld	t1,32(a5)
ffffffffc0200920:	8302                	jr	t1
void free_pages(struct Page *base, size_t n) {
ffffffffc0200922:	1101                	addi	sp,sp,-32
ffffffffc0200924:	ec06                	sd	ra,24(sp)
ffffffffc0200926:	e822                	sd	s0,16(sp)
ffffffffc0200928:	e426                	sd	s1,8(sp)
ffffffffc020092a:	842a                	mv	s0,a0
ffffffffc020092c:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc020092e:	b33ff0ef          	jal	ra,ffffffffc0200460 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200932:	00006797          	auipc	a5,0x6
ffffffffc0200936:	b1678793          	addi	a5,a5,-1258 # ffffffffc0206448 <pmm_manager>
ffffffffc020093a:	639c                	ld	a5,0(a5)
ffffffffc020093c:	85a6                	mv	a1,s1
ffffffffc020093e:	8522                	mv	a0,s0
ffffffffc0200940:	739c                	ld	a5,32(a5)
ffffffffc0200942:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200944:	6442                	ld	s0,16(sp)
ffffffffc0200946:	60e2                	ld	ra,24(sp)
ffffffffc0200948:	64a2                	ld	s1,8(sp)
ffffffffc020094a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020094c:	b0fff06f          	j	ffffffffc020045a <intr_enable>

ffffffffc0200950 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200950:	100027f3          	csrr	a5,sstatus
ffffffffc0200954:	8b89                	andi	a5,a5,2
ffffffffc0200956:	eb89                	bnez	a5,ffffffffc0200968 <nr_free_pages+0x18>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200958:	00006797          	auipc	a5,0x6
ffffffffc020095c:	af078793          	addi	a5,a5,-1296 # ffffffffc0206448 <pmm_manager>
ffffffffc0200960:	639c                	ld	a5,0(a5)
ffffffffc0200962:	0287b303          	ld	t1,40(a5)
ffffffffc0200966:	8302                	jr	t1
size_t nr_free_pages(void) {
ffffffffc0200968:	1141                	addi	sp,sp,-16
ffffffffc020096a:	e406                	sd	ra,8(sp)
ffffffffc020096c:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020096e:	af3ff0ef          	jal	ra,ffffffffc0200460 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0200972:	00006797          	auipc	a5,0x6
ffffffffc0200976:	ad678793          	addi	a5,a5,-1322 # ffffffffc0206448 <pmm_manager>
ffffffffc020097a:	639c                	ld	a5,0(a5)
ffffffffc020097c:	779c                	ld	a5,40(a5)
ffffffffc020097e:	9782                	jalr	a5
ffffffffc0200980:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200982:	ad9ff0ef          	jal	ra,ffffffffc020045a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0200986:	8522                	mv	a0,s0
ffffffffc0200988:	60a2                	ld	ra,8(sp)
ffffffffc020098a:	6402                	ld	s0,0(sp)
ffffffffc020098c:	0141                	addi	sp,sp,16
ffffffffc020098e:	8082                	ret

ffffffffc0200990 <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0200990:	00002797          	auipc	a5,0x2
ffffffffc0200994:	e3078793          	addi	a5,a5,-464 # ffffffffc02027c0 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200998:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020099a:	1101                	addi	sp,sp,-32
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020099c:	00002517          	auipc	a0,0x2
ffffffffc02009a0:	9c450513          	addi	a0,a0,-1596 # ffffffffc0202360 <commands+0x6a8>
void pmm_init(void) {
ffffffffc02009a4:	ec06                	sd	ra,24(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02009a6:	00006717          	auipc	a4,0x6
ffffffffc02009aa:	aaf73123          	sd	a5,-1374(a4) # ffffffffc0206448 <pmm_manager>
void pmm_init(void) {
ffffffffc02009ae:	e822                	sd	s0,16(sp)
ffffffffc02009b0:	e426                	sd	s1,8(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc02009b2:	00006417          	auipc	s0,0x6
ffffffffc02009b6:	a9640413          	addi	s0,s0,-1386 # ffffffffc0206448 <pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02009ba:	ef8ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pmm_manager->init();
ffffffffc02009be:	601c                	ld	a5,0(s0)
ffffffffc02009c0:	679c                	ld	a5,8(a5)
ffffffffc02009c2:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02009c4:	57f5                	li	a5,-3
ffffffffc02009c6:	07fa                	slli	a5,a5,0x1e
    cprintf("physcial memory map:\n");
ffffffffc02009c8:	00002517          	auipc	a0,0x2
ffffffffc02009cc:	9b050513          	addi	a0,a0,-1616 # ffffffffc0202378 <commands+0x6c0>
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02009d0:	00006717          	auipc	a4,0x6
ffffffffc02009d4:	a8f73023          	sd	a5,-1408(a4) # ffffffffc0206450 <va_pa_offset>
    cprintf("physcial memory map:\n");
ffffffffc02009d8:	edaff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02009dc:	46c5                	li	a3,17
ffffffffc02009de:	06ee                	slli	a3,a3,0x1b
ffffffffc02009e0:	40100613          	li	a2,1025
ffffffffc02009e4:	16fd                	addi	a3,a3,-1
ffffffffc02009e6:	0656                	slli	a2,a2,0x15
ffffffffc02009e8:	07e005b7          	lui	a1,0x7e00
ffffffffc02009ec:	00002517          	auipc	a0,0x2
ffffffffc02009f0:	9a450513          	addi	a0,a0,-1628 # ffffffffc0202390 <commands+0x6d8>
ffffffffc02009f4:	ebeff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02009f8:	777d                	lui	a4,0xfffff
ffffffffc02009fa:	00007797          	auipc	a5,0x7
ffffffffc02009fe:	a7d78793          	addi	a5,a5,-1411 # ffffffffc0207477 <end+0xfff>
ffffffffc0200a02:	8ff9                	and	a5,a5,a4
    npage = maxpa / PGSIZE;
ffffffffc0200a04:	00088737          	lui	a4,0x88
ffffffffc0200a08:	00006697          	auipc	a3,0x6
ffffffffc0200a0c:	a0e6bc23          	sd	a4,-1512(a3) # ffffffffc0206420 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200a10:	4601                	li	a2,0
ffffffffc0200a12:	00006717          	auipc	a4,0x6
ffffffffc0200a16:	a4f73323          	sd	a5,-1466(a4) # ffffffffc0206458 <pages>
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200a1a:	4681                	li	a3,0
ffffffffc0200a1c:	00006897          	auipc	a7,0x6
ffffffffc0200a20:	a0488893          	addi	a7,a7,-1532 # ffffffffc0206420 <npage>
ffffffffc0200a24:	00006597          	auipc	a1,0x6
ffffffffc0200a28:	a3458593          	addi	a1,a1,-1484 # ffffffffc0206458 <pages>
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200a2c:	4805                	li	a6,1
ffffffffc0200a2e:	fff80537          	lui	a0,0xfff80
ffffffffc0200a32:	a011                	j	ffffffffc0200a36 <pmm_init+0xa6>
ffffffffc0200a34:	619c                	ld	a5,0(a1)
        SetPageReserved(pages + i);
ffffffffc0200a36:	97b2                	add	a5,a5,a2
ffffffffc0200a38:	07a1                	addi	a5,a5,8
ffffffffc0200a3a:	4107b02f          	amoor.d	zero,a6,(a5)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200a3e:	0008b703          	ld	a4,0(a7)
ffffffffc0200a42:	0685                	addi	a3,a3,1
ffffffffc0200a44:	02860613          	addi	a2,a2,40
ffffffffc0200a48:	00a707b3          	add	a5,a4,a0
ffffffffc0200a4c:	fef6e4e3          	bltu	a3,a5,ffffffffc0200a34 <pmm_init+0xa4>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a50:	6190                	ld	a2,0(a1)
ffffffffc0200a52:	00271793          	slli	a5,a4,0x2
ffffffffc0200a56:	97ba                	add	a5,a5,a4
ffffffffc0200a58:	fec006b7          	lui	a3,0xfec00
ffffffffc0200a5c:	078e                	slli	a5,a5,0x3
ffffffffc0200a5e:	96b2                	add	a3,a3,a2
ffffffffc0200a60:	96be                	add	a3,a3,a5
ffffffffc0200a62:	c02007b7          	lui	a5,0xc0200
ffffffffc0200a66:	08f6e863          	bltu	a3,a5,ffffffffc0200af6 <pmm_init+0x166>
ffffffffc0200a6a:	00006497          	auipc	s1,0x6
ffffffffc0200a6e:	9e648493          	addi	s1,s1,-1562 # ffffffffc0206450 <va_pa_offset>
ffffffffc0200a72:	609c                	ld	a5,0(s1)
    if (freemem < mem_end) {
ffffffffc0200a74:	45c5                	li	a1,17
ffffffffc0200a76:	05ee                	slli	a1,a1,0x1b
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200a78:	8e9d                	sub	a3,a3,a5
    if (freemem < mem_end) {
ffffffffc0200a7a:	04b6e963          	bltu	a3,a1,ffffffffc0200acc <pmm_init+0x13c>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}


static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200a7e:	601c                	ld	a5,0(s0)
ffffffffc0200a80:	7b9c                	ld	a5,48(a5)
ffffffffc0200a82:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200a84:	00002517          	auipc	a0,0x2
ffffffffc0200a88:	9a450513          	addi	a0,a0,-1628 # ffffffffc0202428 <commands+0x770>
ffffffffc0200a8c:	e26ff0ef          	jal	ra,ffffffffc02000b2 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200a90:	00004697          	auipc	a3,0x4
ffffffffc0200a94:	57068693          	addi	a3,a3,1392 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0200a98:	00006797          	auipc	a5,0x6
ffffffffc0200a9c:	98d7b823          	sd	a3,-1648(a5) # ffffffffc0206428 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200aa0:	c02007b7          	lui	a5,0xc0200
ffffffffc0200aa4:	06f6e563          	bltu	a3,a5,ffffffffc0200b0e <pmm_init+0x17e>
ffffffffc0200aa8:	609c                	ld	a5,0(s1)
}
ffffffffc0200aaa:	6442                	ld	s0,16(sp)
ffffffffc0200aac:	60e2                	ld	ra,24(sp)
ffffffffc0200aae:	64a2                	ld	s1,8(sp)
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200ab0:	85b6                	mv	a1,a3
    satp_physical = PADDR(satp_virtual);
ffffffffc0200ab2:	8e9d                	sub	a3,a3,a5
ffffffffc0200ab4:	00006797          	auipc	a5,0x6
ffffffffc0200ab8:	98d7b623          	sd	a3,-1652(a5) # ffffffffc0206440 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200abc:	00002517          	auipc	a0,0x2
ffffffffc0200ac0:	98c50513          	addi	a0,a0,-1652 # ffffffffc0202448 <commands+0x790>
ffffffffc0200ac4:	8636                	mv	a2,a3
}
ffffffffc0200ac6:	6105                	addi	sp,sp,32
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200ac8:	deaff06f          	j	ffffffffc02000b2 <cprintf>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200acc:	6785                	lui	a5,0x1
ffffffffc0200ace:	17fd                	addi	a5,a5,-1
ffffffffc0200ad0:	96be                	add	a3,a3,a5
ffffffffc0200ad2:	77fd                	lui	a5,0xfffff
ffffffffc0200ad4:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200ad6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200ada:	04e7f663          	bleu	a4,a5,ffffffffc0200b26 <pmm_init+0x196>
    pmm_manager->init_memmap(base, n);
ffffffffc0200ade:	6018                	ld	a4,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200ae0:	97aa                	add	a5,a5,a0
ffffffffc0200ae2:	00279513          	slli	a0,a5,0x2
ffffffffc0200ae6:	953e                	add	a0,a0,a5
ffffffffc0200ae8:	6b1c                	ld	a5,16(a4)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200aea:	8d95                	sub	a1,a1,a3
ffffffffc0200aec:	050e                	slli	a0,a0,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200aee:	81b1                	srli	a1,a1,0xc
ffffffffc0200af0:	9532                	add	a0,a0,a2
ffffffffc0200af2:	9782                	jalr	a5
ffffffffc0200af4:	b769                	j	ffffffffc0200a7e <pmm_init+0xee>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200af6:	00002617          	auipc	a2,0x2
ffffffffc0200afa:	8ca60613          	addi	a2,a2,-1846 # ffffffffc02023c0 <commands+0x708>
ffffffffc0200afe:	06e00593          	li	a1,110
ffffffffc0200b02:	00002517          	auipc	a0,0x2
ffffffffc0200b06:	8e650513          	addi	a0,a0,-1818 # ffffffffc02023e8 <commands+0x730>
ffffffffc0200b0a:	e30ff0ef          	jal	ra,ffffffffc020013a <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200b0e:	00002617          	auipc	a2,0x2
ffffffffc0200b12:	8b260613          	addi	a2,a2,-1870 # ffffffffc02023c0 <commands+0x708>
ffffffffc0200b16:	08700593          	li	a1,135
ffffffffc0200b1a:	00002517          	auipc	a0,0x2
ffffffffc0200b1e:	8ce50513          	addi	a0,a0,-1842 # ffffffffc02023e8 <commands+0x730>
ffffffffc0200b22:	e18ff0ef          	jal	ra,ffffffffc020013a <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0200b26:	00002617          	auipc	a2,0x2
ffffffffc0200b2a:	8d260613          	addi	a2,a2,-1838 # ffffffffc02023f8 <commands+0x740>
ffffffffc0200b2e:	06b00593          	li	a1,107
ffffffffc0200b32:	00002517          	auipc	a0,0x2
ffffffffc0200b36:	8e650513          	addi	a0,a0,-1818 # ffffffffc0202418 <commands+0x760>
ffffffffc0200b3a:	e00ff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200b3e <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200b3e:	00006797          	auipc	a5,0x6
ffffffffc0200b42:	92278793          	addi	a5,a5,-1758 # ffffffffc0206460 <free_area>
ffffffffc0200b46:	e79c                	sd	a5,8(a5)
ffffffffc0200b48:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200b4a:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200b4e:	8082                	ret

ffffffffc0200b50 <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200b50:	00006517          	auipc	a0,0x6
ffffffffc0200b54:	92056503          	lwu	a0,-1760(a0) # ffffffffc0206470 <free_area+0x10>
ffffffffc0200b58:	8082                	ret

ffffffffc0200b5a <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc0200b5a:	c15d                	beqz	a0,ffffffffc0200c00 <best_fit_alloc_pages+0xa6>
    if (n > nr_free) {
ffffffffc0200b5c:	00006617          	auipc	a2,0x6
ffffffffc0200b60:	90460613          	addi	a2,a2,-1788 # ffffffffc0206460 <free_area>
ffffffffc0200b64:	01062803          	lw	a6,16(a2)
ffffffffc0200b68:	86aa                	mv	a3,a0
ffffffffc0200b6a:	02081793          	slli	a5,a6,0x20
ffffffffc0200b6e:	9381                	srli	a5,a5,0x20
ffffffffc0200b70:	08a7e663          	bltu	a5,a0,ffffffffc0200bfc <best_fit_alloc_pages+0xa2>
    size_t min_size = nr_free + 1;
ffffffffc0200b74:	0018059b          	addiw	a1,a6,1
ffffffffc0200b78:	1582                	slli	a1,a1,0x20
ffffffffc0200b7a:	9181                	srli	a1,a1,0x20
    list_entry_t *le = &free_list;
ffffffffc0200b7c:	87b2                	mv	a5,a2
    struct Page *page = NULL;
ffffffffc0200b7e:	4501                	li	a0,0
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200b80:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) !=  &free_list) {
ffffffffc0200b82:	00c78e63          	beq	a5,a2,ffffffffc0200b9e <best_fit_alloc_pages+0x44>
        if (p->property >= n && p->property < min_size) {
ffffffffc0200b86:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0200b8a:	fed76be3          	bltu	a4,a3,ffffffffc0200b80 <best_fit_alloc_pages+0x26>
ffffffffc0200b8e:	feb779e3          	bleu	a1,a4,ffffffffc0200b80 <best_fit_alloc_pages+0x26>
        struct Page *p = le2page(le, page_link);
ffffffffc0200b92:	fe878513          	addi	a0,a5,-24
ffffffffc0200b96:	679c                	ld	a5,8(a5)
ffffffffc0200b98:	85ba                	mv	a1,a4
    while ((le = list_next(le)) !=  &free_list) {
ffffffffc0200b9a:	fec796e3          	bne	a5,a2,ffffffffc0200b86 <best_fit_alloc_pages+0x2c>
    if (page != NULL) {
ffffffffc0200b9e:	c125                	beqz	a0,ffffffffc0200bfe <best_fit_alloc_pages+0xa4>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200ba0:	7118                	ld	a4,32(a0)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0200ba2:	6d10                	ld	a2,24(a0)
        if (page->property > n) {
ffffffffc0200ba4:	490c                	lw	a1,16(a0)
ffffffffc0200ba6:	0006889b          	sext.w	a7,a3
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200baa:	e618                	sd	a4,8(a2)
    next->prev = prev;
ffffffffc0200bac:	e310                	sd	a2,0(a4)
ffffffffc0200bae:	02059713          	slli	a4,a1,0x20
ffffffffc0200bb2:	9301                	srli	a4,a4,0x20
ffffffffc0200bb4:	02e6f863          	bleu	a4,a3,ffffffffc0200be4 <best_fit_alloc_pages+0x8a>
            struct Page *p = page + n;
ffffffffc0200bb8:	00269713          	slli	a4,a3,0x2
ffffffffc0200bbc:	9736                	add	a4,a4,a3
ffffffffc0200bbe:	070e                	slli	a4,a4,0x3
ffffffffc0200bc0:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0200bc2:	411585bb          	subw	a1,a1,a7
ffffffffc0200bc6:	cb0c                	sw	a1,16(a4)
ffffffffc0200bc8:	4689                	li	a3,2
ffffffffc0200bca:	00870593          	addi	a1,a4,8
ffffffffc0200bce:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200bd2:	6614                	ld	a3,8(a2)
            list_add(prev, &(p->page_link));
ffffffffc0200bd4:	01870593          	addi	a1,a4,24
    prev->next = next->prev = elm;
ffffffffc0200bd8:	0107a803          	lw	a6,16(a5)
ffffffffc0200bdc:	e28c                	sd	a1,0(a3)
ffffffffc0200bde:	e60c                	sd	a1,8(a2)
    elm->next = next;
ffffffffc0200be0:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0200be2:	ef10                	sd	a2,24(a4)
        nr_free -= n;
ffffffffc0200be4:	4118083b          	subw	a6,a6,a7
ffffffffc0200be8:	00006797          	auipc	a5,0x6
ffffffffc0200bec:	8907a423          	sw	a6,-1912(a5) # ffffffffc0206470 <free_area+0x10>
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200bf0:	57f5                	li	a5,-3
ffffffffc0200bf2:	00850713          	addi	a4,a0,8
ffffffffc0200bf6:	60f7302f          	amoand.d	zero,a5,(a4)
ffffffffc0200bfa:	8082                	ret
        return NULL;
ffffffffc0200bfc:	4501                	li	a0,0
}
ffffffffc0200bfe:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc0200c00:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200c02:	00002697          	auipc	a3,0x2
ffffffffc0200c06:	88668693          	addi	a3,a3,-1914 # ffffffffc0202488 <commands+0x7d0>
ffffffffc0200c0a:	00002617          	auipc	a2,0x2
ffffffffc0200c0e:	88660613          	addi	a2,a2,-1914 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200c12:	06e00593          	li	a1,110
ffffffffc0200c16:	00002517          	auipc	a0,0x2
ffffffffc0200c1a:	89250513          	addi	a0,a0,-1902 # ffffffffc02024a8 <commands+0x7f0>
best_fit_alloc_pages(size_t n) {
ffffffffc0200c1e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200c20:	d1aff0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0200c24 <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200c24:	715d                	addi	sp,sp,-80
ffffffffc0200c26:	f84a                	sd	s2,48(sp)
    return listelm->next;
ffffffffc0200c28:	00006917          	auipc	s2,0x6
ffffffffc0200c2c:	83890913          	addi	s2,s2,-1992 # ffffffffc0206460 <free_area>
ffffffffc0200c30:	00893783          	ld	a5,8(s2)
ffffffffc0200c34:	e486                	sd	ra,72(sp)
ffffffffc0200c36:	e0a2                	sd	s0,64(sp)
ffffffffc0200c38:	fc26                	sd	s1,56(sp)
ffffffffc0200c3a:	f44e                	sd	s3,40(sp)
ffffffffc0200c3c:	f052                	sd	s4,32(sp)
ffffffffc0200c3e:	ec56                	sd	s5,24(sp)
ffffffffc0200c40:	e85a                	sd	s6,16(sp)
ffffffffc0200c42:	e45e                	sd	s7,8(sp)
ffffffffc0200c44:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c46:	2d278363          	beq	a5,s2,ffffffffc0200f0c <best_fit_check+0x2e8>
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200c4a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0200c4e:	8305                	srli	a4,a4,0x1
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200c50:	8b05                	andi	a4,a4,1
ffffffffc0200c52:	2c070163          	beqz	a4,ffffffffc0200f14 <best_fit_check+0x2f0>
    int count = 0, total = 0;
ffffffffc0200c56:	4401                	li	s0,0
ffffffffc0200c58:	4481                	li	s1,0
ffffffffc0200c5a:	a031                	j	ffffffffc0200c66 <best_fit_check+0x42>
ffffffffc0200c5c:	ff07b703          	ld	a4,-16(a5)
        assert(PageProperty(p));
ffffffffc0200c60:	8b09                	andi	a4,a4,2
ffffffffc0200c62:	2a070963          	beqz	a4,ffffffffc0200f14 <best_fit_check+0x2f0>
        count ++, total += p->property;
ffffffffc0200c66:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200c6a:	679c                	ld	a5,8(a5)
ffffffffc0200c6c:	2485                	addiw	s1,s1,1
ffffffffc0200c6e:	9c39                	addw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200c70:	ff2796e3          	bne	a5,s2,ffffffffc0200c5c <best_fit_check+0x38>
ffffffffc0200c74:	89a2                	mv	s3,s0
    }
    assert(total == nr_free_pages());
ffffffffc0200c76:	cdbff0ef          	jal	ra,ffffffffc0200950 <nr_free_pages>
ffffffffc0200c7a:	37351d63          	bne	a0,s3,ffffffffc0200ff4 <best_fit_check+0x3d0>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200c7e:	4505                	li	a0,1
ffffffffc0200c80:	c47ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200c84:	8a2a                	mv	s4,a0
ffffffffc0200c86:	3a050763          	beqz	a0,ffffffffc0201034 <best_fit_check+0x410>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200c8a:	4505                	li	a0,1
ffffffffc0200c8c:	c3bff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200c90:	89aa                	mv	s3,a0
ffffffffc0200c92:	38050163          	beqz	a0,ffffffffc0201014 <best_fit_check+0x3f0>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200c96:	4505                	li	a0,1
ffffffffc0200c98:	c2fff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200c9c:	8aaa                	mv	s5,a0
ffffffffc0200c9e:	30050b63          	beqz	a0,ffffffffc0200fb4 <best_fit_check+0x390>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200ca2:	293a0963          	beq	s4,s3,ffffffffc0200f34 <best_fit_check+0x310>
ffffffffc0200ca6:	28aa0763          	beq	s4,a0,ffffffffc0200f34 <best_fit_check+0x310>
ffffffffc0200caa:	28a98563          	beq	s3,a0,ffffffffc0200f34 <best_fit_check+0x310>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200cae:	000a2783          	lw	a5,0(s4)
ffffffffc0200cb2:	2a079163          	bnez	a5,ffffffffc0200f54 <best_fit_check+0x330>
ffffffffc0200cb6:	0009a783          	lw	a5,0(s3)
ffffffffc0200cba:	28079d63          	bnez	a5,ffffffffc0200f54 <best_fit_check+0x330>
ffffffffc0200cbe:	411c                	lw	a5,0(a0)
ffffffffc0200cc0:	28079a63          	bnez	a5,ffffffffc0200f54 <best_fit_check+0x330>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200cc4:	00005797          	auipc	a5,0x5
ffffffffc0200cc8:	79478793          	addi	a5,a5,1940 # ffffffffc0206458 <pages>
ffffffffc0200ccc:	639c                	ld	a5,0(a5)
ffffffffc0200cce:	00001717          	auipc	a4,0x1
ffffffffc0200cd2:	7f270713          	addi	a4,a4,2034 # ffffffffc02024c0 <commands+0x808>
ffffffffc0200cd6:	630c                	ld	a1,0(a4)
ffffffffc0200cd8:	40fa0733          	sub	a4,s4,a5
ffffffffc0200cdc:	870d                	srai	a4,a4,0x3
ffffffffc0200cde:	02b70733          	mul	a4,a4,a1
ffffffffc0200ce2:	00002697          	auipc	a3,0x2
ffffffffc0200ce6:	d7668693          	addi	a3,a3,-650 # ffffffffc0202a58 <nbase>
ffffffffc0200cea:	6290                	ld	a2,0(a3)
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200cec:	00005697          	auipc	a3,0x5
ffffffffc0200cf0:	73468693          	addi	a3,a3,1844 # ffffffffc0206420 <npage>
ffffffffc0200cf4:	6294                	ld	a3,0(a3)
ffffffffc0200cf6:	06b2                	slli	a3,a3,0xc
ffffffffc0200cf8:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200cfa:	0732                	slli	a4,a4,0xc
ffffffffc0200cfc:	26d77c63          	bleu	a3,a4,ffffffffc0200f74 <best_fit_check+0x350>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d00:	40f98733          	sub	a4,s3,a5
ffffffffc0200d04:	870d                	srai	a4,a4,0x3
ffffffffc0200d06:	02b70733          	mul	a4,a4,a1
ffffffffc0200d0a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d0c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200d0e:	42d77363          	bleu	a3,a4,ffffffffc0201134 <best_fit_check+0x510>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200d12:	40f507b3          	sub	a5,a0,a5
ffffffffc0200d16:	878d                	srai	a5,a5,0x3
ffffffffc0200d18:	02b787b3          	mul	a5,a5,a1
ffffffffc0200d1c:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200d1e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200d20:	3ed7fa63          	bleu	a3,a5,ffffffffc0201114 <best_fit_check+0x4f0>
    assert(alloc_page() == NULL);
ffffffffc0200d24:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200d26:	00093c03          	ld	s8,0(s2)
ffffffffc0200d2a:	00893b83          	ld	s7,8(s2)
    unsigned int nr_free_store = nr_free;
ffffffffc0200d2e:	01092b03          	lw	s6,16(s2)
    elm->prev = elm->next = elm;
ffffffffc0200d32:	00005797          	auipc	a5,0x5
ffffffffc0200d36:	7327bb23          	sd	s2,1846(a5) # ffffffffc0206468 <free_area+0x8>
ffffffffc0200d3a:	00005797          	auipc	a5,0x5
ffffffffc0200d3e:	7327b323          	sd	s2,1830(a5) # ffffffffc0206460 <free_area>
    nr_free = 0;
ffffffffc0200d42:	00005797          	auipc	a5,0x5
ffffffffc0200d46:	7207a723          	sw	zero,1838(a5) # ffffffffc0206470 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200d4a:	b7dff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200d4e:	3a051363          	bnez	a0,ffffffffc02010f4 <best_fit_check+0x4d0>
    free_page(p0);
ffffffffc0200d52:	4585                	li	a1,1
ffffffffc0200d54:	8552                	mv	a0,s4
ffffffffc0200d56:	bb5ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    free_page(p1);
ffffffffc0200d5a:	4585                	li	a1,1
ffffffffc0200d5c:	854e                	mv	a0,s3
ffffffffc0200d5e:	badff0ef          	jal	ra,ffffffffc020090a <free_pages>
    free_page(p2);
ffffffffc0200d62:	4585                	li	a1,1
ffffffffc0200d64:	8556                	mv	a0,s5
ffffffffc0200d66:	ba5ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    assert(nr_free == 3);
ffffffffc0200d6a:	01092703          	lw	a4,16(s2)
ffffffffc0200d6e:	478d                	li	a5,3
ffffffffc0200d70:	36f71263          	bne	a4,a5,ffffffffc02010d4 <best_fit_check+0x4b0>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200d74:	4505                	li	a0,1
ffffffffc0200d76:	b51ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200d7a:	89aa                	mv	s3,a0
ffffffffc0200d7c:	32050c63          	beqz	a0,ffffffffc02010b4 <best_fit_check+0x490>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200d80:	4505                	li	a0,1
ffffffffc0200d82:	b45ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200d86:	8aaa                	mv	s5,a0
ffffffffc0200d88:	30050663          	beqz	a0,ffffffffc0201094 <best_fit_check+0x470>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200d8c:	4505                	li	a0,1
ffffffffc0200d8e:	b39ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200d92:	8a2a                	mv	s4,a0
ffffffffc0200d94:	2e050063          	beqz	a0,ffffffffc0201074 <best_fit_check+0x450>
    assert(alloc_page() == NULL);
ffffffffc0200d98:	4505                	li	a0,1
ffffffffc0200d9a:	b2dff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200d9e:	2a051b63          	bnez	a0,ffffffffc0201054 <best_fit_check+0x430>
    free_page(p0);
ffffffffc0200da2:	4585                	li	a1,1
ffffffffc0200da4:	854e                	mv	a0,s3
ffffffffc0200da6:	b65ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200daa:	00893783          	ld	a5,8(s2)
ffffffffc0200dae:	1f278363          	beq	a5,s2,ffffffffc0200f94 <best_fit_check+0x370>
    assert((p = alloc_page()) == p0);
ffffffffc0200db2:	4505                	li	a0,1
ffffffffc0200db4:	b13ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200db8:	54a99e63          	bne	s3,a0,ffffffffc0201314 <best_fit_check+0x6f0>
    assert(alloc_page() == NULL);
ffffffffc0200dbc:	4505                	li	a0,1
ffffffffc0200dbe:	b09ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200dc2:	52051963          	bnez	a0,ffffffffc02012f4 <best_fit_check+0x6d0>
    assert(nr_free == 0);
ffffffffc0200dc6:	01092783          	lw	a5,16(s2)
ffffffffc0200dca:	50079563          	bnez	a5,ffffffffc02012d4 <best_fit_check+0x6b0>
    free_page(p);
ffffffffc0200dce:	854e                	mv	a0,s3
ffffffffc0200dd0:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200dd2:	00005797          	auipc	a5,0x5
ffffffffc0200dd6:	6987b723          	sd	s8,1678(a5) # ffffffffc0206460 <free_area>
ffffffffc0200dda:	00005797          	auipc	a5,0x5
ffffffffc0200dde:	6977b723          	sd	s7,1678(a5) # ffffffffc0206468 <free_area+0x8>
    nr_free = nr_free_store;
ffffffffc0200de2:	00005797          	auipc	a5,0x5
ffffffffc0200de6:	6967a723          	sw	s6,1678(a5) # ffffffffc0206470 <free_area+0x10>
    free_page(p);
ffffffffc0200dea:	b21ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    free_page(p1);
ffffffffc0200dee:	4585                	li	a1,1
ffffffffc0200df0:	8556                	mv	a0,s5
ffffffffc0200df2:	b19ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    free_page(p2);
ffffffffc0200df6:	4585                	li	a1,1
ffffffffc0200df8:	8552                	mv	a0,s4
ffffffffc0200dfa:	b11ff0ef          	jal	ra,ffffffffc020090a <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200dfe:	4515                	li	a0,5
ffffffffc0200e00:	ac7ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200e04:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200e06:	4a050763          	beqz	a0,ffffffffc02012b4 <best_fit_check+0x690>
ffffffffc0200e0a:	651c                	ld	a5,8(a0)
ffffffffc0200e0c:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200e0e:	8b85                	andi	a5,a5,1
ffffffffc0200e10:	48079263          	bnez	a5,ffffffffc0201294 <best_fit_check+0x670>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200e14:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e16:	00093b03          	ld	s6,0(s2)
ffffffffc0200e1a:	00893a83          	ld	s5,8(s2)
ffffffffc0200e1e:	00005797          	auipc	a5,0x5
ffffffffc0200e22:	6527b123          	sd	s2,1602(a5) # ffffffffc0206460 <free_area>
ffffffffc0200e26:	00005797          	auipc	a5,0x5
ffffffffc0200e2a:	6527b123          	sd	s2,1602(a5) # ffffffffc0206468 <free_area+0x8>
    assert(alloc_page() == NULL);
ffffffffc0200e2e:	a99ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200e32:	44051163          	bnez	a0,ffffffffc0201274 <best_fit_check+0x650>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200e36:	4589                	li	a1,2
ffffffffc0200e38:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200e3c:	01092b83          	lw	s7,16(s2)
    free_pages(p0 + 4, 1);
ffffffffc0200e40:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200e44:	00005797          	auipc	a5,0x5
ffffffffc0200e48:	6207a623          	sw	zero,1580(a5) # ffffffffc0206470 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200e4c:	abfff0ef          	jal	ra,ffffffffc020090a <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200e50:	8562                	mv	a0,s8
ffffffffc0200e52:	4585                	li	a1,1
ffffffffc0200e54:	ab7ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200e58:	4511                	li	a0,4
ffffffffc0200e5a:	a6dff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200e5e:	3e051b63          	bnez	a0,ffffffffc0201254 <best_fit_check+0x630>
ffffffffc0200e62:	0309b783          	ld	a5,48(s3)
ffffffffc0200e66:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200e68:	8b85                	andi	a5,a5,1
ffffffffc0200e6a:	3c078563          	beqz	a5,ffffffffc0201234 <best_fit_check+0x610>
ffffffffc0200e6e:	0389a703          	lw	a4,56(s3)
ffffffffc0200e72:	4789                	li	a5,2
ffffffffc0200e74:	3cf71063          	bne	a4,a5,ffffffffc0201234 <best_fit_check+0x610>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200e78:	4505                	li	a0,1
ffffffffc0200e7a:	a4dff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200e7e:	8a2a                	mv	s4,a0
ffffffffc0200e80:	38050a63          	beqz	a0,ffffffffc0201214 <best_fit_check+0x5f0>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200e84:	4509                	li	a0,2
ffffffffc0200e86:	a41ff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200e8a:	36050563          	beqz	a0,ffffffffc02011f4 <best_fit_check+0x5d0>
    assert(p0 + 4 == p1);
ffffffffc0200e8e:	354c1363          	bne	s8,s4,ffffffffc02011d4 <best_fit_check+0x5b0>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200e92:	854e                	mv	a0,s3
ffffffffc0200e94:	4595                	li	a1,5
ffffffffc0200e96:	a75ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200e9a:	4515                	li	a0,5
ffffffffc0200e9c:	a2bff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200ea0:	89aa                	mv	s3,a0
ffffffffc0200ea2:	30050963          	beqz	a0,ffffffffc02011b4 <best_fit_check+0x590>
    assert(alloc_page() == NULL);
ffffffffc0200ea6:	4505                	li	a0,1
ffffffffc0200ea8:	a1fff0ef          	jal	ra,ffffffffc02008c6 <alloc_pages>
ffffffffc0200eac:	2e051463          	bnez	a0,ffffffffc0201194 <best_fit_check+0x570>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200eb0:	01092783          	lw	a5,16(s2)
ffffffffc0200eb4:	2c079063          	bnez	a5,ffffffffc0201174 <best_fit_check+0x550>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200eb8:	4595                	li	a1,5
ffffffffc0200eba:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200ebc:	00005797          	auipc	a5,0x5
ffffffffc0200ec0:	5b77aa23          	sw	s7,1460(a5) # ffffffffc0206470 <free_area+0x10>
    free_list = free_list_store;
ffffffffc0200ec4:	00005797          	auipc	a5,0x5
ffffffffc0200ec8:	5967be23          	sd	s6,1436(a5) # ffffffffc0206460 <free_area>
ffffffffc0200ecc:	00005797          	auipc	a5,0x5
ffffffffc0200ed0:	5957be23          	sd	s5,1436(a5) # ffffffffc0206468 <free_area+0x8>
    free_pages(p0, 5);
ffffffffc0200ed4:	a37ff0ef          	jal	ra,ffffffffc020090a <free_pages>
    return listelm->next;
ffffffffc0200ed8:	00893783          	ld	a5,8(s2)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200edc:	01278963          	beq	a5,s2,ffffffffc0200eee <best_fit_check+0x2ca>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200ee0:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200ee4:	679c                	ld	a5,8(a5)
ffffffffc0200ee6:	34fd                	addiw	s1,s1,-1
ffffffffc0200ee8:	9c19                	subw	s0,s0,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200eea:	ff279be3          	bne	a5,s2,ffffffffc0200ee0 <best_fit_check+0x2bc>
    }
    assert(count == 0);
ffffffffc0200eee:	26049363          	bnez	s1,ffffffffc0201154 <best_fit_check+0x530>
    assert(total == 0);
ffffffffc0200ef2:	e06d                	bnez	s0,ffffffffc0200fd4 <best_fit_check+0x3b0>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200ef4:	60a6                	ld	ra,72(sp)
ffffffffc0200ef6:	6406                	ld	s0,64(sp)
ffffffffc0200ef8:	74e2                	ld	s1,56(sp)
ffffffffc0200efa:	7942                	ld	s2,48(sp)
ffffffffc0200efc:	79a2                	ld	s3,40(sp)
ffffffffc0200efe:	7a02                	ld	s4,32(sp)
ffffffffc0200f00:	6ae2                	ld	s5,24(sp)
ffffffffc0200f02:	6b42                	ld	s6,16(sp)
ffffffffc0200f04:	6ba2                	ld	s7,8(sp)
ffffffffc0200f06:	6c02                	ld	s8,0(sp)
ffffffffc0200f08:	6161                	addi	sp,sp,80
ffffffffc0200f0a:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f0c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0200f0e:	4401                	li	s0,0
ffffffffc0200f10:	4481                	li	s1,0
ffffffffc0200f12:	b395                	j	ffffffffc0200c76 <best_fit_check+0x52>
        assert(PageProperty(p));
ffffffffc0200f14:	00001697          	auipc	a3,0x1
ffffffffc0200f18:	5b468693          	addi	a3,a3,1460 # ffffffffc02024c8 <commands+0x810>
ffffffffc0200f1c:	00001617          	auipc	a2,0x1
ffffffffc0200f20:	57460613          	addi	a2,a2,1396 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200f24:	10f00593          	li	a1,271
ffffffffc0200f28:	00001517          	auipc	a0,0x1
ffffffffc0200f2c:	58050513          	addi	a0,a0,1408 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200f30:	a0aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200f34:	00001697          	auipc	a3,0x1
ffffffffc0200f38:	62468693          	addi	a3,a3,1572 # ffffffffc0202558 <commands+0x8a0>
ffffffffc0200f3c:	00001617          	auipc	a2,0x1
ffffffffc0200f40:	55460613          	addi	a2,a2,1364 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200f44:	0db00593          	li	a1,219
ffffffffc0200f48:	00001517          	auipc	a0,0x1
ffffffffc0200f4c:	56050513          	addi	a0,a0,1376 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200f50:	9eaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200f54:	00001697          	auipc	a3,0x1
ffffffffc0200f58:	62c68693          	addi	a3,a3,1580 # ffffffffc0202580 <commands+0x8c8>
ffffffffc0200f5c:	00001617          	auipc	a2,0x1
ffffffffc0200f60:	53460613          	addi	a2,a2,1332 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200f64:	0dc00593          	li	a1,220
ffffffffc0200f68:	00001517          	auipc	a0,0x1
ffffffffc0200f6c:	54050513          	addi	a0,a0,1344 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200f70:	9caff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200f74:	00001697          	auipc	a3,0x1
ffffffffc0200f78:	64c68693          	addi	a3,a3,1612 # ffffffffc02025c0 <commands+0x908>
ffffffffc0200f7c:	00001617          	auipc	a2,0x1
ffffffffc0200f80:	51460613          	addi	a2,a2,1300 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200f84:	0de00593          	li	a1,222
ffffffffc0200f88:	00001517          	auipc	a0,0x1
ffffffffc0200f8c:	52050513          	addi	a0,a0,1312 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200f90:	9aaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0200f94:	00001697          	auipc	a3,0x1
ffffffffc0200f98:	6b468693          	addi	a3,a3,1716 # ffffffffc0202648 <commands+0x990>
ffffffffc0200f9c:	00001617          	auipc	a2,0x1
ffffffffc0200fa0:	4f460613          	addi	a2,a2,1268 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200fa4:	0f700593          	li	a1,247
ffffffffc0200fa8:	00001517          	auipc	a0,0x1
ffffffffc0200fac:	50050513          	addi	a0,a0,1280 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200fb0:	98aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200fb4:	00001697          	auipc	a3,0x1
ffffffffc0200fb8:	58468693          	addi	a3,a3,1412 # ffffffffc0202538 <commands+0x880>
ffffffffc0200fbc:	00001617          	auipc	a2,0x1
ffffffffc0200fc0:	4d460613          	addi	a2,a2,1236 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200fc4:	0d900593          	li	a1,217
ffffffffc0200fc8:	00001517          	auipc	a0,0x1
ffffffffc0200fcc:	4e050513          	addi	a0,a0,1248 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200fd0:	96aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == 0);
ffffffffc0200fd4:	00001697          	auipc	a3,0x1
ffffffffc0200fd8:	7a468693          	addi	a3,a3,1956 # ffffffffc0202778 <commands+0xac0>
ffffffffc0200fdc:	00001617          	auipc	a2,0x1
ffffffffc0200fe0:	4b460613          	addi	a2,a2,1204 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0200fe4:	15100593          	li	a1,337
ffffffffc0200fe8:	00001517          	auipc	a0,0x1
ffffffffc0200fec:	4c050513          	addi	a0,a0,1216 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0200ff0:	94aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(total == nr_free_pages());
ffffffffc0200ff4:	00001697          	auipc	a3,0x1
ffffffffc0200ff8:	4e468693          	addi	a3,a3,1252 # ffffffffc02024d8 <commands+0x820>
ffffffffc0200ffc:	00001617          	auipc	a2,0x1
ffffffffc0201000:	49460613          	addi	a2,a2,1172 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201004:	11200593          	li	a1,274
ffffffffc0201008:	00001517          	auipc	a0,0x1
ffffffffc020100c:	4a050513          	addi	a0,a0,1184 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201010:	92aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201014:	00001697          	auipc	a3,0x1
ffffffffc0201018:	50468693          	addi	a3,a3,1284 # ffffffffc0202518 <commands+0x860>
ffffffffc020101c:	00001617          	auipc	a2,0x1
ffffffffc0201020:	47460613          	addi	a2,a2,1140 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201024:	0d800593          	li	a1,216
ffffffffc0201028:	00001517          	auipc	a0,0x1
ffffffffc020102c:	48050513          	addi	a0,a0,1152 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201030:	90aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201034:	00001697          	auipc	a3,0x1
ffffffffc0201038:	4c468693          	addi	a3,a3,1220 # ffffffffc02024f8 <commands+0x840>
ffffffffc020103c:	00001617          	auipc	a2,0x1
ffffffffc0201040:	45460613          	addi	a2,a2,1108 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201044:	0d700593          	li	a1,215
ffffffffc0201048:	00001517          	auipc	a0,0x1
ffffffffc020104c:	46050513          	addi	a0,a0,1120 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201050:	8eaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201054:	00001697          	auipc	a3,0x1
ffffffffc0201058:	5cc68693          	addi	a3,a3,1484 # ffffffffc0202620 <commands+0x968>
ffffffffc020105c:	00001617          	auipc	a2,0x1
ffffffffc0201060:	43460613          	addi	a2,a2,1076 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201064:	0f400593          	li	a1,244
ffffffffc0201068:	00001517          	auipc	a0,0x1
ffffffffc020106c:	44050513          	addi	a0,a0,1088 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201070:	8caff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201074:	00001697          	auipc	a3,0x1
ffffffffc0201078:	4c468693          	addi	a3,a3,1220 # ffffffffc0202538 <commands+0x880>
ffffffffc020107c:	00001617          	auipc	a2,0x1
ffffffffc0201080:	41460613          	addi	a2,a2,1044 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201084:	0f200593          	li	a1,242
ffffffffc0201088:	00001517          	auipc	a0,0x1
ffffffffc020108c:	42050513          	addi	a0,a0,1056 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201090:	8aaff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201094:	00001697          	auipc	a3,0x1
ffffffffc0201098:	48468693          	addi	a3,a3,1156 # ffffffffc0202518 <commands+0x860>
ffffffffc020109c:	00001617          	auipc	a2,0x1
ffffffffc02010a0:	3f460613          	addi	a2,a2,1012 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02010a4:	0f100593          	li	a1,241
ffffffffc02010a8:	00001517          	auipc	a0,0x1
ffffffffc02010ac:	40050513          	addi	a0,a0,1024 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02010b0:	88aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010b4:	00001697          	auipc	a3,0x1
ffffffffc02010b8:	44468693          	addi	a3,a3,1092 # ffffffffc02024f8 <commands+0x840>
ffffffffc02010bc:	00001617          	auipc	a2,0x1
ffffffffc02010c0:	3d460613          	addi	a2,a2,980 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02010c4:	0f000593          	li	a1,240
ffffffffc02010c8:	00001517          	auipc	a0,0x1
ffffffffc02010cc:	3e050513          	addi	a0,a0,992 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02010d0:	86aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 3);
ffffffffc02010d4:	00001697          	auipc	a3,0x1
ffffffffc02010d8:	56468693          	addi	a3,a3,1380 # ffffffffc0202638 <commands+0x980>
ffffffffc02010dc:	00001617          	auipc	a2,0x1
ffffffffc02010e0:	3b460613          	addi	a2,a2,948 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02010e4:	0ee00593          	li	a1,238
ffffffffc02010e8:	00001517          	auipc	a0,0x1
ffffffffc02010ec:	3c050513          	addi	a0,a0,960 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02010f0:	84aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02010f4:	00001697          	auipc	a3,0x1
ffffffffc02010f8:	52c68693          	addi	a3,a3,1324 # ffffffffc0202620 <commands+0x968>
ffffffffc02010fc:	00001617          	auipc	a2,0x1
ffffffffc0201100:	39460613          	addi	a2,a2,916 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201104:	0e900593          	li	a1,233
ffffffffc0201108:	00001517          	auipc	a0,0x1
ffffffffc020110c:	3a050513          	addi	a0,a0,928 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201110:	82aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201114:	00001697          	auipc	a3,0x1
ffffffffc0201118:	4ec68693          	addi	a3,a3,1260 # ffffffffc0202600 <commands+0x948>
ffffffffc020111c:	00001617          	auipc	a2,0x1
ffffffffc0201120:	37460613          	addi	a2,a2,884 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201124:	0e000593          	li	a1,224
ffffffffc0201128:	00001517          	auipc	a0,0x1
ffffffffc020112c:	38050513          	addi	a0,a0,896 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201130:	80aff0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201134:	00001697          	auipc	a3,0x1
ffffffffc0201138:	4ac68693          	addi	a3,a3,1196 # ffffffffc02025e0 <commands+0x928>
ffffffffc020113c:	00001617          	auipc	a2,0x1
ffffffffc0201140:	35460613          	addi	a2,a2,852 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201144:	0df00593          	li	a1,223
ffffffffc0201148:	00001517          	auipc	a0,0x1
ffffffffc020114c:	36050513          	addi	a0,a0,864 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201150:	febfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(count == 0);
ffffffffc0201154:	00001697          	auipc	a3,0x1
ffffffffc0201158:	61468693          	addi	a3,a3,1556 # ffffffffc0202768 <commands+0xab0>
ffffffffc020115c:	00001617          	auipc	a2,0x1
ffffffffc0201160:	33460613          	addi	a2,a2,820 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201164:	15000593          	li	a1,336
ffffffffc0201168:	00001517          	auipc	a0,0x1
ffffffffc020116c:	34050513          	addi	a0,a0,832 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201170:	fcbfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc0201174:	00001697          	auipc	a3,0x1
ffffffffc0201178:	50c68693          	addi	a3,a3,1292 # ffffffffc0202680 <commands+0x9c8>
ffffffffc020117c:	00001617          	auipc	a2,0x1
ffffffffc0201180:	31460613          	addi	a2,a2,788 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201184:	14500593          	li	a1,325
ffffffffc0201188:	00001517          	auipc	a0,0x1
ffffffffc020118c:	32050513          	addi	a0,a0,800 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201190:	fabfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201194:	00001697          	auipc	a3,0x1
ffffffffc0201198:	48c68693          	addi	a3,a3,1164 # ffffffffc0202620 <commands+0x968>
ffffffffc020119c:	00001617          	auipc	a2,0x1
ffffffffc02011a0:	2f460613          	addi	a2,a2,756 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02011a4:	13f00593          	li	a1,319
ffffffffc02011a8:	00001517          	auipc	a0,0x1
ffffffffc02011ac:	30050513          	addi	a0,a0,768 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02011b0:	f8bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02011b4:	00001697          	auipc	a3,0x1
ffffffffc02011b8:	59468693          	addi	a3,a3,1428 # ffffffffc0202748 <commands+0xa90>
ffffffffc02011bc:	00001617          	auipc	a2,0x1
ffffffffc02011c0:	2d460613          	addi	a2,a2,724 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02011c4:	13e00593          	li	a1,318
ffffffffc02011c8:	00001517          	auipc	a0,0x1
ffffffffc02011cc:	2e050513          	addi	a0,a0,736 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02011d0:	f6bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 + 4 == p1);
ffffffffc02011d4:	00001697          	auipc	a3,0x1
ffffffffc02011d8:	56468693          	addi	a3,a3,1380 # ffffffffc0202738 <commands+0xa80>
ffffffffc02011dc:	00001617          	auipc	a2,0x1
ffffffffc02011e0:	2b460613          	addi	a2,a2,692 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02011e4:	13600593          	li	a1,310
ffffffffc02011e8:	00001517          	auipc	a0,0x1
ffffffffc02011ec:	2c050513          	addi	a0,a0,704 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02011f0:	f4bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc02011f4:	00001697          	auipc	a3,0x1
ffffffffc02011f8:	52c68693          	addi	a3,a3,1324 # ffffffffc0202720 <commands+0xa68>
ffffffffc02011fc:	00001617          	auipc	a2,0x1
ffffffffc0201200:	29460613          	addi	a2,a2,660 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201204:	13500593          	li	a1,309
ffffffffc0201208:	00001517          	auipc	a0,0x1
ffffffffc020120c:	2a050513          	addi	a0,a0,672 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201210:	f2bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0201214:	00001697          	auipc	a3,0x1
ffffffffc0201218:	4ec68693          	addi	a3,a3,1260 # ffffffffc0202700 <commands+0xa48>
ffffffffc020121c:	00001617          	auipc	a2,0x1
ffffffffc0201220:	27460613          	addi	a2,a2,628 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201224:	13400593          	li	a1,308
ffffffffc0201228:	00001517          	auipc	a0,0x1
ffffffffc020122c:	28050513          	addi	a0,a0,640 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201230:	f0bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0201234:	00001697          	auipc	a3,0x1
ffffffffc0201238:	49c68693          	addi	a3,a3,1180 # ffffffffc02026d0 <commands+0xa18>
ffffffffc020123c:	00001617          	auipc	a2,0x1
ffffffffc0201240:	25460613          	addi	a2,a2,596 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201244:	13200593          	li	a1,306
ffffffffc0201248:	00001517          	auipc	a0,0x1
ffffffffc020124c:	26050513          	addi	a0,a0,608 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201250:	eebfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201254:	00001697          	auipc	a3,0x1
ffffffffc0201258:	46468693          	addi	a3,a3,1124 # ffffffffc02026b8 <commands+0xa00>
ffffffffc020125c:	00001617          	auipc	a2,0x1
ffffffffc0201260:	23460613          	addi	a2,a2,564 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201264:	13100593          	li	a1,305
ffffffffc0201268:	00001517          	auipc	a0,0x1
ffffffffc020126c:	24050513          	addi	a0,a0,576 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201270:	ecbfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201274:	00001697          	auipc	a3,0x1
ffffffffc0201278:	3ac68693          	addi	a3,a3,940 # ffffffffc0202620 <commands+0x968>
ffffffffc020127c:	00001617          	auipc	a2,0x1
ffffffffc0201280:	21460613          	addi	a2,a2,532 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201284:	12500593          	li	a1,293
ffffffffc0201288:	00001517          	auipc	a0,0x1
ffffffffc020128c:	22050513          	addi	a0,a0,544 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201290:	eabfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(!PageProperty(p0));
ffffffffc0201294:	00001697          	auipc	a3,0x1
ffffffffc0201298:	40c68693          	addi	a3,a3,1036 # ffffffffc02026a0 <commands+0x9e8>
ffffffffc020129c:	00001617          	auipc	a2,0x1
ffffffffc02012a0:	1f460613          	addi	a2,a2,500 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02012a4:	11c00593          	li	a1,284
ffffffffc02012a8:	00001517          	auipc	a0,0x1
ffffffffc02012ac:	20050513          	addi	a0,a0,512 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02012b0:	e8bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(p0 != NULL);
ffffffffc02012b4:	00001697          	auipc	a3,0x1
ffffffffc02012b8:	3dc68693          	addi	a3,a3,988 # ffffffffc0202690 <commands+0x9d8>
ffffffffc02012bc:	00001617          	auipc	a2,0x1
ffffffffc02012c0:	1d460613          	addi	a2,a2,468 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02012c4:	11b00593          	li	a1,283
ffffffffc02012c8:	00001517          	auipc	a0,0x1
ffffffffc02012cc:	1e050513          	addi	a0,a0,480 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02012d0:	e6bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(nr_free == 0);
ffffffffc02012d4:	00001697          	auipc	a3,0x1
ffffffffc02012d8:	3ac68693          	addi	a3,a3,940 # ffffffffc0202680 <commands+0x9c8>
ffffffffc02012dc:	00001617          	auipc	a2,0x1
ffffffffc02012e0:	1b460613          	addi	a2,a2,436 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02012e4:	0fd00593          	li	a1,253
ffffffffc02012e8:	00001517          	auipc	a0,0x1
ffffffffc02012ec:	1c050513          	addi	a0,a0,448 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02012f0:	e4bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02012f4:	00001697          	auipc	a3,0x1
ffffffffc02012f8:	32c68693          	addi	a3,a3,812 # ffffffffc0202620 <commands+0x968>
ffffffffc02012fc:	00001617          	auipc	a2,0x1
ffffffffc0201300:	19460613          	addi	a2,a2,404 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201304:	0fb00593          	li	a1,251
ffffffffc0201308:	00001517          	auipc	a0,0x1
ffffffffc020130c:	1a050513          	addi	a0,a0,416 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201310:	e2bfe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201314:	00001697          	auipc	a3,0x1
ffffffffc0201318:	34c68693          	addi	a3,a3,844 # ffffffffc0202660 <commands+0x9a8>
ffffffffc020131c:	00001617          	auipc	a2,0x1
ffffffffc0201320:	17460613          	addi	a2,a2,372 # ffffffffc0202490 <commands+0x7d8>
ffffffffc0201324:	0fa00593          	li	a1,250
ffffffffc0201328:	00001517          	auipc	a0,0x1
ffffffffc020132c:	18050513          	addi	a0,a0,384 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc0201330:	e0bfe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc0201334 <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc0201334:	1141                	addi	sp,sp,-16
ffffffffc0201336:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201338:	18058063          	beqz	a1,ffffffffc02014b8 <best_fit_free_pages+0x184>
    for (; p != base + n; p ++) {
ffffffffc020133c:	00259693          	slli	a3,a1,0x2
ffffffffc0201340:	96ae                	add	a3,a3,a1
ffffffffc0201342:	068e                	slli	a3,a3,0x3
ffffffffc0201344:	96aa                	add	a3,a3,a0
ffffffffc0201346:	02d50d63          	beq	a0,a3,ffffffffc0201380 <best_fit_free_pages+0x4c>
ffffffffc020134a:	651c                	ld	a5,8(a0)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020134c:	8b85                	andi	a5,a5,1
ffffffffc020134e:	14079563          	bnez	a5,ffffffffc0201498 <best_fit_free_pages+0x164>
ffffffffc0201352:	651c                	ld	a5,8(a0)
ffffffffc0201354:	8385                	srli	a5,a5,0x1
ffffffffc0201356:	8b85                	andi	a5,a5,1
ffffffffc0201358:	14079063          	bnez	a5,ffffffffc0201498 <best_fit_free_pages+0x164>
ffffffffc020135c:	87aa                	mv	a5,a0
ffffffffc020135e:	a809                	j	ffffffffc0201370 <best_fit_free_pages+0x3c>
ffffffffc0201360:	6798                	ld	a4,8(a5)
ffffffffc0201362:	8b05                	andi	a4,a4,1
ffffffffc0201364:	12071a63          	bnez	a4,ffffffffc0201498 <best_fit_free_pages+0x164>
ffffffffc0201368:	6798                	ld	a4,8(a5)
ffffffffc020136a:	8b09                	andi	a4,a4,2
ffffffffc020136c:	12071663          	bnez	a4,ffffffffc0201498 <best_fit_free_pages+0x164>
        p->flags = 0;
ffffffffc0201370:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201374:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201378:	02878793          	addi	a5,a5,40
ffffffffc020137c:	fed792e3          	bne	a5,a3,ffffffffc0201360 <best_fit_free_pages+0x2c>
    base->property=n;
ffffffffc0201380:	2581                	sext.w	a1,a1
ffffffffc0201382:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201384:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201388:	4789                	li	a5,2
ffffffffc020138a:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free+=n;
ffffffffc020138e:	00005697          	auipc	a3,0x5
ffffffffc0201392:	0d268693          	addi	a3,a3,210 # ffffffffc0206460 <free_area>
ffffffffc0201396:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201398:	669c                	ld	a5,8(a3)
ffffffffc020139a:	9db9                	addw	a1,a1,a4
ffffffffc020139c:	00005717          	auipc	a4,0x5
ffffffffc02013a0:	0cb72a23          	sw	a1,212(a4) # ffffffffc0206470 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc02013a4:	08d78f63          	beq	a5,a3,ffffffffc0201442 <best_fit_free_pages+0x10e>
            struct Page* page = le2page(le, page_link);
ffffffffc02013a8:	fe878713          	addi	a4,a5,-24
ffffffffc02013ac:	628c                	ld	a1,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02013ae:	4801                	li	a6,0
ffffffffc02013b0:	01850613          	addi	a2,a0,24
            if (base < page) {
ffffffffc02013b4:	00e56a63          	bltu	a0,a4,ffffffffc02013c8 <best_fit_free_pages+0x94>
    return listelm->next;
ffffffffc02013b8:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02013ba:	02d70563          	beq	a4,a3,ffffffffc02013e4 <best_fit_free_pages+0xb0>
        while ((le = list_next(le)) != &free_list) {
ffffffffc02013be:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02013c0:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02013c4:	fee57ae3          	bleu	a4,a0,ffffffffc02013b8 <best_fit_free_pages+0x84>
ffffffffc02013c8:	00080663          	beqz	a6,ffffffffc02013d4 <best_fit_free_pages+0xa0>
ffffffffc02013cc:	00005817          	auipc	a6,0x5
ffffffffc02013d0:	08b83a23          	sd	a1,148(a6) # ffffffffc0206460 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc02013d4:	638c                	ld	a1,0(a5)
    prev->next = next->prev = elm;
ffffffffc02013d6:	e390                	sd	a2,0(a5)
ffffffffc02013d8:	e590                	sd	a2,8(a1)
    elm->next = next;
ffffffffc02013da:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02013dc:	ed0c                	sd	a1,24(a0)
    if (le != &free_list) {
ffffffffc02013de:	02d59163          	bne	a1,a3,ffffffffc0201400 <best_fit_free_pages+0xcc>
ffffffffc02013e2:	a091                	j	ffffffffc0201426 <best_fit_free_pages+0xf2>
    prev->next = next->prev = elm;
ffffffffc02013e4:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02013e6:	f114                	sd	a3,32(a0)
ffffffffc02013e8:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02013ea:	ed1c                	sd	a5,24(a0)
                list_add(le, &(base->page_link));
ffffffffc02013ec:	85b2                	mv	a1,a2
        while ((le = list_next(le)) != &free_list) {
ffffffffc02013ee:	00d70563          	beq	a4,a3,ffffffffc02013f8 <best_fit_free_pages+0xc4>
ffffffffc02013f2:	4805                	li	a6,1
ffffffffc02013f4:	87ba                	mv	a5,a4
ffffffffc02013f6:	b7e9                	j	ffffffffc02013c0 <best_fit_free_pages+0x8c>
ffffffffc02013f8:	e290                	sd	a2,0(a3)
    return listelm->prev;
ffffffffc02013fa:	85be                	mv	a1,a5
    if (le != &free_list) {
ffffffffc02013fc:	02d78163          	beq	a5,a3,ffffffffc020141e <best_fit_free_pages+0xea>
        if (p + p->property == base)
ffffffffc0201400:	ff85a803          	lw	a6,-8(a1)
        p = le2page(le, page_link);
ffffffffc0201404:	fe858613          	addi	a2,a1,-24
        if (p + p->property == base)
ffffffffc0201408:	02081713          	slli	a4,a6,0x20
ffffffffc020140c:	9301                	srli	a4,a4,0x20
ffffffffc020140e:	00271793          	slli	a5,a4,0x2
ffffffffc0201412:	97ba                	add	a5,a5,a4
ffffffffc0201414:	078e                	slli	a5,a5,0x3
ffffffffc0201416:	97b2                	add	a5,a5,a2
ffffffffc0201418:	02f50e63          	beq	a0,a5,ffffffffc0201454 <best_fit_free_pages+0x120>
ffffffffc020141c:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc020141e:	fe878713          	addi	a4,a5,-24
ffffffffc0201422:	00d78d63          	beq	a5,a3,ffffffffc020143c <best_fit_free_pages+0x108>
        if (base + base->property == p) {
ffffffffc0201426:	490c                	lw	a1,16(a0)
ffffffffc0201428:	02059613          	slli	a2,a1,0x20
ffffffffc020142c:	9201                	srli	a2,a2,0x20
ffffffffc020142e:	00261693          	slli	a3,a2,0x2
ffffffffc0201432:	96b2                	add	a3,a3,a2
ffffffffc0201434:	068e                	slli	a3,a3,0x3
ffffffffc0201436:	96aa                	add	a3,a3,a0
ffffffffc0201438:	04d70063          	beq	a4,a3,ffffffffc0201478 <best_fit_free_pages+0x144>
}
ffffffffc020143c:	60a2                	ld	ra,8(sp)
ffffffffc020143e:	0141                	addi	sp,sp,16
ffffffffc0201440:	8082                	ret
ffffffffc0201442:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201444:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201448:	e398                	sd	a4,0(a5)
ffffffffc020144a:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc020144c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020144e:	ed1c                	sd	a5,24(a0)
}
ffffffffc0201450:	0141                	addi	sp,sp,16
ffffffffc0201452:	8082                	ret
            p->property += base->property;
ffffffffc0201454:	491c                	lw	a5,16(a0)
ffffffffc0201456:	0107883b          	addw	a6,a5,a6
ffffffffc020145a:	ff05ac23          	sw	a6,-8(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020145e:	57f5                	li	a5,-3
ffffffffc0201460:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201464:	01853803          	ld	a6,24(a0)
ffffffffc0201468:	7118                	ld	a4,32(a0)
            base=p;
ffffffffc020146a:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc020146c:	00e83423          	sd	a4,8(a6)
    next->prev = prev;
ffffffffc0201470:	659c                	ld	a5,8(a1)
ffffffffc0201472:	01073023          	sd	a6,0(a4)
ffffffffc0201476:	b765                	j	ffffffffc020141e <best_fit_free_pages+0xea>
            base->property += p->property;
ffffffffc0201478:	ff87a703          	lw	a4,-8(a5)
ffffffffc020147c:	ff078693          	addi	a3,a5,-16
ffffffffc0201480:	9db9                	addw	a1,a1,a4
ffffffffc0201482:	c90c                	sw	a1,16(a0)
ffffffffc0201484:	5775                	li	a4,-3
ffffffffc0201486:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020148a:	6398                	ld	a4,0(a5)
ffffffffc020148c:	679c                	ld	a5,8(a5)
}
ffffffffc020148e:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201490:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0201492:	e398                	sd	a4,0(a5)
ffffffffc0201494:	0141                	addi	sp,sp,16
ffffffffc0201496:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201498:	00001697          	auipc	a3,0x1
ffffffffc020149c:	2f068693          	addi	a3,a3,752 # ffffffffc0202788 <commands+0xad0>
ffffffffc02014a0:	00001617          	auipc	a2,0x1
ffffffffc02014a4:	ff060613          	addi	a2,a2,-16 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02014a8:	09600593          	li	a1,150
ffffffffc02014ac:	00001517          	auipc	a0,0x1
ffffffffc02014b0:	ffc50513          	addi	a0,a0,-4 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02014b4:	c87fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02014b8:	00001697          	auipc	a3,0x1
ffffffffc02014bc:	fd068693          	addi	a3,a3,-48 # ffffffffc0202488 <commands+0x7d0>
ffffffffc02014c0:	00001617          	auipc	a2,0x1
ffffffffc02014c4:	fd060613          	addi	a2,a2,-48 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02014c8:	09300593          	li	a1,147
ffffffffc02014cc:	00001517          	auipc	a0,0x1
ffffffffc02014d0:	fdc50513          	addi	a0,a0,-36 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02014d4:	c67fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02014d8 <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc02014d8:	1141                	addi	sp,sp,-16
ffffffffc02014da:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02014dc:	c5f5                	beqz	a1,ffffffffc02015c8 <best_fit_init_memmap+0xf0>
    for (; p != base + n; p ++) {
ffffffffc02014de:	00259693          	slli	a3,a1,0x2
ffffffffc02014e2:	96ae                	add	a3,a3,a1
ffffffffc02014e4:	068e                	slli	a3,a3,0x3
ffffffffc02014e6:	96aa                	add	a3,a3,a0
ffffffffc02014e8:	02d50463          	beq	a0,a3,ffffffffc0201510 <best_fit_init_memmap+0x38>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02014ec:	6518                	ld	a4,8(a0)
        assert(PageReserved(p));
ffffffffc02014ee:	87aa                	mv	a5,a0
ffffffffc02014f0:	8b05                	andi	a4,a4,1
ffffffffc02014f2:	e709                	bnez	a4,ffffffffc02014fc <best_fit_init_memmap+0x24>
ffffffffc02014f4:	a855                	j	ffffffffc02015a8 <best_fit_init_memmap+0xd0>
ffffffffc02014f6:	6798                	ld	a4,8(a5)
ffffffffc02014f8:	8b05                	andi	a4,a4,1
ffffffffc02014fa:	c75d                	beqz	a4,ffffffffc02015a8 <best_fit_init_memmap+0xd0>
        p->flags = p->property = 0;
ffffffffc02014fc:	0007a823          	sw	zero,16(a5)
ffffffffc0201500:	0007b423          	sd	zero,8(a5)
ffffffffc0201504:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201508:	02878793          	addi	a5,a5,40
ffffffffc020150c:	fed795e3          	bne	a5,a3,ffffffffc02014f6 <best_fit_init_memmap+0x1e>
    base->property = n;
ffffffffc0201510:	2581                	sext.w	a1,a1
ffffffffc0201512:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201514:	4789                	li	a5,2
ffffffffc0201516:	00850713          	addi	a4,a0,8
ffffffffc020151a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020151e:	00005617          	auipc	a2,0x5
ffffffffc0201522:	f4260613          	addi	a2,a2,-190 # ffffffffc0206460 <free_area>
ffffffffc0201526:	4a18                	lw	a4,16(a2)
    return list->next == list;
ffffffffc0201528:	661c                	ld	a5,8(a2)
ffffffffc020152a:	9db9                	addw	a1,a1,a4
ffffffffc020152c:	00005717          	auipc	a4,0x5
ffffffffc0201530:	f4b72223          	sw	a1,-188(a4) # ffffffffc0206470 <free_area+0x10>
    if (list_empty(&free_list)) {
ffffffffc0201534:	04c78d63          	beq	a5,a2,ffffffffc020158e <best_fit_init_memmap+0xb6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201538:	fe878713          	addi	a4,a5,-24
ffffffffc020153c:	00063803          	ld	a6,0(a2)
    if (list_empty(&free_list)) {
ffffffffc0201540:	4881                	li	a7,0
                list_add(le, &(p->page_link));
ffffffffc0201542:	01868593          	addi	a1,a3,24
            if (base < page)
ffffffffc0201546:	00e56a63          	bltu	a0,a4,ffffffffc020155a <best_fit_init_memmap+0x82>
    return listelm->next;
ffffffffc020154a:	6798                	ld	a4,8(a5)
            else if(list_next(le) == &free_list)
ffffffffc020154c:	02c70763          	beq	a4,a2,ffffffffc020157a <best_fit_init_memmap+0xa2>
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201550:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201552:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201556:	fee57ae3          	bleu	a4,a0,ffffffffc020154a <best_fit_init_memmap+0x72>
ffffffffc020155a:	00088663          	beqz	a7,ffffffffc0201566 <best_fit_init_memmap+0x8e>
ffffffffc020155e:	00005717          	auipc	a4,0x5
ffffffffc0201562:	f1073123          	sd	a6,-254(a4) # ffffffffc0206460 <free_area>
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201566:	6398                	ld	a4,0(a5)
                list_add_before(le, &(base->page_link));
ffffffffc0201568:	01850693          	addi	a3,a0,24
    prev->next = next->prev = elm;
ffffffffc020156c:	e394                	sd	a3,0(a5)
}
ffffffffc020156e:	60a2                	ld	ra,8(sp)
ffffffffc0201570:	e714                	sd	a3,8(a4)
    elm->next = next;
ffffffffc0201572:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201574:	ed18                	sd	a4,24(a0)
ffffffffc0201576:	0141                	addi	sp,sp,16
ffffffffc0201578:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020157a:	e78c                	sd	a1,8(a5)
    elm->next = next;
ffffffffc020157c:	f290                	sd	a2,32(a3)
ffffffffc020157e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201580:	ee9c                	sd	a5,24(a3)
                list_add(le, &(p->page_link));
ffffffffc0201582:	882e                	mv	a6,a1
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201584:	00c70e63          	beq	a4,a2,ffffffffc02015a0 <best_fit_init_memmap+0xc8>
ffffffffc0201588:	4885                	li	a7,1
ffffffffc020158a:	87ba                	mv	a5,a4
ffffffffc020158c:	b7d9                	j	ffffffffc0201552 <best_fit_init_memmap+0x7a>
}
ffffffffc020158e:	60a2                	ld	ra,8(sp)
        list_add(&free_list, &(base->page_link));
ffffffffc0201590:	01850713          	addi	a4,a0,24
    prev->next = next->prev = elm;
ffffffffc0201594:	e398                	sd	a4,0(a5)
ffffffffc0201596:	e798                	sd	a4,8(a5)
    elm->next = next;
ffffffffc0201598:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020159a:	ed1c                	sd	a5,24(a0)
}
ffffffffc020159c:	0141                	addi	sp,sp,16
ffffffffc020159e:	8082                	ret
ffffffffc02015a0:	60a2                	ld	ra,8(sp)
ffffffffc02015a2:	e20c                	sd	a1,0(a2)
ffffffffc02015a4:	0141                	addi	sp,sp,16
ffffffffc02015a6:	8082                	ret
        assert(PageReserved(p));
ffffffffc02015a8:	00001697          	auipc	a3,0x1
ffffffffc02015ac:	20868693          	addi	a3,a3,520 # ffffffffc02027b0 <commands+0xaf8>
ffffffffc02015b0:	00001617          	auipc	a2,0x1
ffffffffc02015b4:	ee060613          	addi	a2,a2,-288 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02015b8:	04a00593          	li	a1,74
ffffffffc02015bc:	00001517          	auipc	a0,0x1
ffffffffc02015c0:	eec50513          	addi	a0,a0,-276 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02015c4:	b77fe0ef          	jal	ra,ffffffffc020013a <__panic>
    assert(n > 0);
ffffffffc02015c8:	00001697          	auipc	a3,0x1
ffffffffc02015cc:	ec068693          	addi	a3,a3,-320 # ffffffffc0202488 <commands+0x7d0>
ffffffffc02015d0:	00001617          	auipc	a2,0x1
ffffffffc02015d4:	ec060613          	addi	a2,a2,-320 # ffffffffc0202490 <commands+0x7d8>
ffffffffc02015d8:	04700593          	li	a1,71
ffffffffc02015dc:	00001517          	auipc	a0,0x1
ffffffffc02015e0:	ecc50513          	addi	a0,a0,-308 # ffffffffc02024a8 <commands+0x7f0>
ffffffffc02015e4:	b57fe0ef          	jal	ra,ffffffffc020013a <__panic>

ffffffffc02015e8 <strnlen>:
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
ffffffffc02015e8:	c185                	beqz	a1,ffffffffc0201608 <strnlen+0x20>
ffffffffc02015ea:	00054783          	lbu	a5,0(a0)
ffffffffc02015ee:	cf89                	beqz	a5,ffffffffc0201608 <strnlen+0x20>
    size_t cnt = 0;
ffffffffc02015f0:	4781                	li	a5,0
ffffffffc02015f2:	a021                	j	ffffffffc02015fa <strnlen+0x12>
    while (cnt < len && *s ++ != '\0') {
ffffffffc02015f4:	00074703          	lbu	a4,0(a4)
ffffffffc02015f8:	c711                	beqz	a4,ffffffffc0201604 <strnlen+0x1c>
        cnt ++;
ffffffffc02015fa:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02015fc:	00f50733          	add	a4,a0,a5
ffffffffc0201600:	fef59ae3          	bne	a1,a5,ffffffffc02015f4 <strnlen+0xc>
    }
    return cnt;
}
ffffffffc0201604:	853e                	mv	a0,a5
ffffffffc0201606:	8082                	ret
    size_t cnt = 0;
ffffffffc0201608:	4781                	li	a5,0
}
ffffffffc020160a:	853e                	mv	a0,a5
ffffffffc020160c:	8082                	ret

ffffffffc020160e <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020160e:	00054783          	lbu	a5,0(a0)
ffffffffc0201612:	0005c703          	lbu	a4,0(a1)
ffffffffc0201616:	cb91                	beqz	a5,ffffffffc020162a <strcmp+0x1c>
ffffffffc0201618:	00e79c63          	bne	a5,a4,ffffffffc0201630 <strcmp+0x22>
        s1 ++, s2 ++;
ffffffffc020161c:	0505                	addi	a0,a0,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020161e:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
ffffffffc0201622:	0585                	addi	a1,a1,1
ffffffffc0201624:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201628:	fbe5                	bnez	a5,ffffffffc0201618 <strcmp+0xa>
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020162a:	4501                	li	a0,0
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc020162c:	9d19                	subw	a0,a0,a4
ffffffffc020162e:	8082                	ret
ffffffffc0201630:	0007851b          	sext.w	a0,a5
ffffffffc0201634:	9d19                	subw	a0,a0,a4
ffffffffc0201636:	8082                	ret

ffffffffc0201638 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201638:	00054783          	lbu	a5,0(a0)
ffffffffc020163c:	cb91                	beqz	a5,ffffffffc0201650 <strchr+0x18>
        if (*s == c) {
ffffffffc020163e:	00b79563          	bne	a5,a1,ffffffffc0201648 <strchr+0x10>
ffffffffc0201642:	a809                	j	ffffffffc0201654 <strchr+0x1c>
ffffffffc0201644:	00b78763          	beq	a5,a1,ffffffffc0201652 <strchr+0x1a>
            return (char *)s;
        }
        s ++;
ffffffffc0201648:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc020164a:	00054783          	lbu	a5,0(a0)
ffffffffc020164e:	fbfd                	bnez	a5,ffffffffc0201644 <strchr+0xc>
    }
    return NULL;
ffffffffc0201650:	4501                	li	a0,0
}
ffffffffc0201652:	8082                	ret
ffffffffc0201654:	8082                	ret

ffffffffc0201656 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201656:	ca01                	beqz	a2,ffffffffc0201666 <memset+0x10>
ffffffffc0201658:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc020165a:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc020165c:	0785                	addi	a5,a5,1
ffffffffc020165e:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201662:	fec79de3          	bne	a5,a2,ffffffffc020165c <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201666:	8082                	ret

ffffffffc0201668 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201668:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020166c:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020166e:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201672:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201674:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201678:	f022                	sd	s0,32(sp)
ffffffffc020167a:	ec26                	sd	s1,24(sp)
ffffffffc020167c:	e84a                	sd	s2,16(sp)
ffffffffc020167e:	f406                	sd	ra,40(sp)
ffffffffc0201680:	e44e                	sd	s3,8(sp)
ffffffffc0201682:	84aa                	mv	s1,a0
ffffffffc0201684:	892e                	mv	s2,a1
ffffffffc0201686:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020168a:	2a01                	sext.w	s4,s4

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
ffffffffc020168c:	03067e63          	bleu	a6,a2,ffffffffc02016c8 <printnum+0x60>
ffffffffc0201690:	89be                	mv	s3,a5
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201692:	00805763          	blez	s0,ffffffffc02016a0 <printnum+0x38>
ffffffffc0201696:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201698:	85ca                	mv	a1,s2
ffffffffc020169a:	854e                	mv	a0,s3
ffffffffc020169c:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020169e:	fc65                	bnez	s0,ffffffffc0201696 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02016a0:	1a02                	slli	s4,s4,0x20
ffffffffc02016a2:	020a5a13          	srli	s4,s4,0x20
ffffffffc02016a6:	00001797          	auipc	a5,0x1
ffffffffc02016aa:	2fa78793          	addi	a5,a5,762 # ffffffffc02029a0 <error_string+0x38>
ffffffffc02016ae:	9a3e                	add	s4,s4,a5
}
ffffffffc02016b0:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02016b2:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02016b6:	70a2                	ld	ra,40(sp)
ffffffffc02016b8:	69a2                	ld	s3,8(sp)
ffffffffc02016ba:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02016bc:	85ca                	mv	a1,s2
ffffffffc02016be:	8326                	mv	t1,s1
}
ffffffffc02016c0:	6942                	ld	s2,16(sp)
ffffffffc02016c2:	64e2                	ld	s1,24(sp)
ffffffffc02016c4:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02016c6:	8302                	jr	t1
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02016c8:	03065633          	divu	a2,a2,a6
ffffffffc02016cc:	8722                	mv	a4,s0
ffffffffc02016ce:	f9bff0ef          	jal	ra,ffffffffc0201668 <printnum>
ffffffffc02016d2:	b7f9                	j	ffffffffc02016a0 <printnum+0x38>

ffffffffc02016d4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02016d4:	7119                	addi	sp,sp,-128
ffffffffc02016d6:	f4a6                	sd	s1,104(sp)
ffffffffc02016d8:	f0ca                	sd	s2,96(sp)
ffffffffc02016da:	e8d2                	sd	s4,80(sp)
ffffffffc02016dc:	e4d6                	sd	s5,72(sp)
ffffffffc02016de:	e0da                	sd	s6,64(sp)
ffffffffc02016e0:	fc5e                	sd	s7,56(sp)
ffffffffc02016e2:	f862                	sd	s8,48(sp)
ffffffffc02016e4:	f06a                	sd	s10,32(sp)
ffffffffc02016e6:	fc86                	sd	ra,120(sp)
ffffffffc02016e8:	f8a2                	sd	s0,112(sp)
ffffffffc02016ea:	ecce                	sd	s3,88(sp)
ffffffffc02016ec:	f466                	sd	s9,40(sp)
ffffffffc02016ee:	ec6e                	sd	s11,24(sp)
ffffffffc02016f0:	892a                	mv	s2,a0
ffffffffc02016f2:	84ae                	mv	s1,a1
ffffffffc02016f4:	8d32                	mv	s10,a2
ffffffffc02016f6:	8ab6                	mv	s5,a3
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02016f8:	5b7d                	li	s6,-1
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02016fa:	00001a17          	auipc	s4,0x1
ffffffffc02016fe:	116a0a13          	addi	s4,s4,278 # ffffffffc0202810 <best_fit_pmm_manager+0x50>
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201702:	05e00b93          	li	s7,94
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201706:	00001c17          	auipc	s8,0x1
ffffffffc020170a:	262c0c13          	addi	s8,s8,610 # ffffffffc0202968 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020170e:	000d4503          	lbu	a0,0(s10)
ffffffffc0201712:	02500793          	li	a5,37
ffffffffc0201716:	001d0413          	addi	s0,s10,1
ffffffffc020171a:	00f50e63          	beq	a0,a5,ffffffffc0201736 <vprintfmt+0x62>
            if (ch == '\0') {
ffffffffc020171e:	c521                	beqz	a0,ffffffffc0201766 <vprintfmt+0x92>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201720:	02500993          	li	s3,37
ffffffffc0201724:	a011                	j	ffffffffc0201728 <vprintfmt+0x54>
            if (ch == '\0') {
ffffffffc0201726:	c121                	beqz	a0,ffffffffc0201766 <vprintfmt+0x92>
            putch(ch, putdat);
ffffffffc0201728:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020172a:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020172c:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020172e:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201732:	ff351ae3          	bne	a0,s3,ffffffffc0201726 <vprintfmt+0x52>
ffffffffc0201736:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020173a:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc020173e:	4981                	li	s3,0
ffffffffc0201740:	4801                	li	a6,0
        width = precision = -1;
ffffffffc0201742:	5cfd                	li	s9,-1
ffffffffc0201744:	5dfd                	li	s11,-1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201746:	05500593          	li	a1,85
                if (ch < '0' || ch > '9') {
ffffffffc020174a:	4525                	li	a0,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020174c:	fdd6069b          	addiw	a3,a2,-35
ffffffffc0201750:	0ff6f693          	andi	a3,a3,255
ffffffffc0201754:	00140d13          	addi	s10,s0,1
ffffffffc0201758:	20d5e563          	bltu	a1,a3,ffffffffc0201962 <vprintfmt+0x28e>
ffffffffc020175c:	068a                	slli	a3,a3,0x2
ffffffffc020175e:	96d2                	add	a3,a3,s4
ffffffffc0201760:	4294                	lw	a3,0(a3)
ffffffffc0201762:	96d2                	add	a3,a3,s4
ffffffffc0201764:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201766:	70e6                	ld	ra,120(sp)
ffffffffc0201768:	7446                	ld	s0,112(sp)
ffffffffc020176a:	74a6                	ld	s1,104(sp)
ffffffffc020176c:	7906                	ld	s2,96(sp)
ffffffffc020176e:	69e6                	ld	s3,88(sp)
ffffffffc0201770:	6a46                	ld	s4,80(sp)
ffffffffc0201772:	6aa6                	ld	s5,72(sp)
ffffffffc0201774:	6b06                	ld	s6,64(sp)
ffffffffc0201776:	7be2                	ld	s7,56(sp)
ffffffffc0201778:	7c42                	ld	s8,48(sp)
ffffffffc020177a:	7ca2                	ld	s9,40(sp)
ffffffffc020177c:	7d02                	ld	s10,32(sp)
ffffffffc020177e:	6de2                	ld	s11,24(sp)
ffffffffc0201780:	6109                	addi	sp,sp,128
ffffffffc0201782:	8082                	ret
    if (lflag >= 2) {
ffffffffc0201784:	4705                	li	a4,1
ffffffffc0201786:	008a8593          	addi	a1,s5,8
ffffffffc020178a:	01074463          	blt	a4,a6,ffffffffc0201792 <vprintfmt+0xbe>
    else if (lflag) {
ffffffffc020178e:	26080363          	beqz	a6,ffffffffc02019f4 <vprintfmt+0x320>
        return va_arg(*ap, unsigned long);
ffffffffc0201792:	000ab603          	ld	a2,0(s5)
ffffffffc0201796:	46c1                	li	a3,16
ffffffffc0201798:	8aae                	mv	s5,a1
ffffffffc020179a:	a06d                	j	ffffffffc0201844 <vprintfmt+0x170>
            goto reswitch;
ffffffffc020179c:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc02017a0:	4985                	li	s3,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02017a2:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02017a4:	b765                	j	ffffffffc020174c <vprintfmt+0x78>
            putch(va_arg(ap, int), putdat);
ffffffffc02017a6:	000aa503          	lw	a0,0(s5)
ffffffffc02017aa:	85a6                	mv	a1,s1
ffffffffc02017ac:	0aa1                	addi	s5,s5,8
ffffffffc02017ae:	9902                	jalr	s2
            break;
ffffffffc02017b0:	bfb9                	j	ffffffffc020170e <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02017b2:	4705                	li	a4,1
ffffffffc02017b4:	008a8993          	addi	s3,s5,8
ffffffffc02017b8:	01074463          	blt	a4,a6,ffffffffc02017c0 <vprintfmt+0xec>
    else if (lflag) {
ffffffffc02017bc:	22080463          	beqz	a6,ffffffffc02019e4 <vprintfmt+0x310>
        return va_arg(*ap, long);
ffffffffc02017c0:	000ab403          	ld	s0,0(s5)
            if ((long long)num < 0) {
ffffffffc02017c4:	24044463          	bltz	s0,ffffffffc0201a0c <vprintfmt+0x338>
            num = getint(&ap, lflag);
ffffffffc02017c8:	8622                	mv	a2,s0
ffffffffc02017ca:	8ace                	mv	s5,s3
ffffffffc02017cc:	46a9                	li	a3,10
ffffffffc02017ce:	a89d                	j	ffffffffc0201844 <vprintfmt+0x170>
            err = va_arg(ap, int);
ffffffffc02017d0:	000aa783          	lw	a5,0(s5)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02017d4:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc02017d6:	0aa1                	addi	s5,s5,8
            if (err < 0) {
ffffffffc02017d8:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc02017dc:	8fb5                	xor	a5,a5,a3
ffffffffc02017de:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02017e2:	1ad74363          	blt	a4,a3,ffffffffc0201988 <vprintfmt+0x2b4>
ffffffffc02017e6:	00369793          	slli	a5,a3,0x3
ffffffffc02017ea:	97e2                	add	a5,a5,s8
ffffffffc02017ec:	639c                	ld	a5,0(a5)
ffffffffc02017ee:	18078d63          	beqz	a5,ffffffffc0201988 <vprintfmt+0x2b4>
                printfmt(putch, putdat, "%s", p);
ffffffffc02017f2:	86be                	mv	a3,a5
ffffffffc02017f4:	00001617          	auipc	a2,0x1
ffffffffc02017f8:	25c60613          	addi	a2,a2,604 # ffffffffc0202a50 <error_string+0xe8>
ffffffffc02017fc:	85a6                	mv	a1,s1
ffffffffc02017fe:	854a                	mv	a0,s2
ffffffffc0201800:	240000ef          	jal	ra,ffffffffc0201a40 <printfmt>
ffffffffc0201804:	b729                	j	ffffffffc020170e <vprintfmt+0x3a>
            lflag ++;
ffffffffc0201806:	00144603          	lbu	a2,1(s0)
ffffffffc020180a:	2805                	addiw	a6,a6,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020180c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020180e:	bf3d                	j	ffffffffc020174c <vprintfmt+0x78>
    if (lflag >= 2) {
ffffffffc0201810:	4705                	li	a4,1
ffffffffc0201812:	008a8593          	addi	a1,s5,8
ffffffffc0201816:	01074463          	blt	a4,a6,ffffffffc020181e <vprintfmt+0x14a>
    else if (lflag) {
ffffffffc020181a:	1e080263          	beqz	a6,ffffffffc02019fe <vprintfmt+0x32a>
        return va_arg(*ap, unsigned long);
ffffffffc020181e:	000ab603          	ld	a2,0(s5)
ffffffffc0201822:	46a1                	li	a3,8
ffffffffc0201824:	8aae                	mv	s5,a1
ffffffffc0201826:	a839                	j	ffffffffc0201844 <vprintfmt+0x170>
            putch('0', putdat);
ffffffffc0201828:	03000513          	li	a0,48
ffffffffc020182c:	85a6                	mv	a1,s1
ffffffffc020182e:	e03e                	sd	a5,0(sp)
ffffffffc0201830:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201832:	85a6                	mv	a1,s1
ffffffffc0201834:	07800513          	li	a0,120
ffffffffc0201838:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020183a:	0aa1                	addi	s5,s5,8
ffffffffc020183c:	ff8ab603          	ld	a2,-8(s5)
            goto number;
ffffffffc0201840:	6782                	ld	a5,0(sp)
ffffffffc0201842:	46c1                	li	a3,16
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201844:	876e                	mv	a4,s11
ffffffffc0201846:	85a6                	mv	a1,s1
ffffffffc0201848:	854a                	mv	a0,s2
ffffffffc020184a:	e1fff0ef          	jal	ra,ffffffffc0201668 <printnum>
            break;
ffffffffc020184e:	b5c1                	j	ffffffffc020170e <vprintfmt+0x3a>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201850:	000ab603          	ld	a2,0(s5)
ffffffffc0201854:	0aa1                	addi	s5,s5,8
ffffffffc0201856:	1c060663          	beqz	a2,ffffffffc0201a22 <vprintfmt+0x34e>
            if (width > 0 && padc != '-') {
ffffffffc020185a:	00160413          	addi	s0,a2,1
ffffffffc020185e:	17b05c63          	blez	s11,ffffffffc02019d6 <vprintfmt+0x302>
ffffffffc0201862:	02d00593          	li	a1,45
ffffffffc0201866:	14b79263          	bne	a5,a1,ffffffffc02019aa <vprintfmt+0x2d6>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020186a:	00064783          	lbu	a5,0(a2)
ffffffffc020186e:	0007851b          	sext.w	a0,a5
ffffffffc0201872:	c905                	beqz	a0,ffffffffc02018a2 <vprintfmt+0x1ce>
ffffffffc0201874:	000cc563          	bltz	s9,ffffffffc020187e <vprintfmt+0x1aa>
ffffffffc0201878:	3cfd                	addiw	s9,s9,-1
ffffffffc020187a:	036c8263          	beq	s9,s6,ffffffffc020189e <vprintfmt+0x1ca>
                    putch('?', putdat);
ffffffffc020187e:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201880:	18098463          	beqz	s3,ffffffffc0201a08 <vprintfmt+0x334>
ffffffffc0201884:	3781                	addiw	a5,a5,-32
ffffffffc0201886:	18fbf163          	bleu	a5,s7,ffffffffc0201a08 <vprintfmt+0x334>
                    putch('?', putdat);
ffffffffc020188a:	03f00513          	li	a0,63
ffffffffc020188e:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201890:	0405                	addi	s0,s0,1
ffffffffc0201892:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201896:	3dfd                	addiw	s11,s11,-1
ffffffffc0201898:	0007851b          	sext.w	a0,a5
ffffffffc020189c:	fd61                	bnez	a0,ffffffffc0201874 <vprintfmt+0x1a0>
            for (; width > 0; width --) {
ffffffffc020189e:	e7b058e3          	blez	s11,ffffffffc020170e <vprintfmt+0x3a>
ffffffffc02018a2:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02018a4:	85a6                	mv	a1,s1
ffffffffc02018a6:	02000513          	li	a0,32
ffffffffc02018aa:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02018ac:	e60d81e3          	beqz	s11,ffffffffc020170e <vprintfmt+0x3a>
ffffffffc02018b0:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02018b2:	85a6                	mv	a1,s1
ffffffffc02018b4:	02000513          	li	a0,32
ffffffffc02018b8:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02018ba:	fe0d94e3          	bnez	s11,ffffffffc02018a2 <vprintfmt+0x1ce>
ffffffffc02018be:	bd81                	j	ffffffffc020170e <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02018c0:	4705                	li	a4,1
ffffffffc02018c2:	008a8593          	addi	a1,s5,8
ffffffffc02018c6:	01074463          	blt	a4,a6,ffffffffc02018ce <vprintfmt+0x1fa>
    else if (lflag) {
ffffffffc02018ca:	12080063          	beqz	a6,ffffffffc02019ea <vprintfmt+0x316>
        return va_arg(*ap, unsigned long);
ffffffffc02018ce:	000ab603          	ld	a2,0(s5)
ffffffffc02018d2:	46a9                	li	a3,10
ffffffffc02018d4:	8aae                	mv	s5,a1
ffffffffc02018d6:	b7bd                	j	ffffffffc0201844 <vprintfmt+0x170>
ffffffffc02018d8:	00144603          	lbu	a2,1(s0)
            padc = '-';
ffffffffc02018dc:	02d00793          	li	a5,45
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02018e0:	846a                	mv	s0,s10
ffffffffc02018e2:	b5ad                	j	ffffffffc020174c <vprintfmt+0x78>
            putch(ch, putdat);
ffffffffc02018e4:	85a6                	mv	a1,s1
ffffffffc02018e6:	02500513          	li	a0,37
ffffffffc02018ea:	9902                	jalr	s2
            break;
ffffffffc02018ec:	b50d                	j	ffffffffc020170e <vprintfmt+0x3a>
            precision = va_arg(ap, int);
ffffffffc02018ee:	000aac83          	lw	s9,0(s5)
            goto process_precision;
ffffffffc02018f2:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02018f6:	0aa1                	addi	s5,s5,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02018f8:	846a                	mv	s0,s10
            if (width < 0)
ffffffffc02018fa:	e40dd9e3          	bgez	s11,ffffffffc020174c <vprintfmt+0x78>
                width = precision, precision = -1;
ffffffffc02018fe:	8de6                	mv	s11,s9
ffffffffc0201900:	5cfd                	li	s9,-1
ffffffffc0201902:	b5a9                	j	ffffffffc020174c <vprintfmt+0x78>
            goto reswitch;
ffffffffc0201904:	00144603          	lbu	a2,1(s0)
            padc = '0';
ffffffffc0201908:	03000793          	li	a5,48
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020190c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020190e:	bd3d                	j	ffffffffc020174c <vprintfmt+0x78>
                precision = precision * 10 + ch - '0';
ffffffffc0201910:	fd060c9b          	addiw	s9,a2,-48
                ch = *fmt;
ffffffffc0201914:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201918:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020191a:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020191e:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201922:	fcd56ce3          	bltu	a0,a3,ffffffffc02018fa <vprintfmt+0x226>
            for (precision = 0; ; ++ fmt) {
ffffffffc0201926:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201928:	002c969b          	slliw	a3,s9,0x2
                ch = *fmt;
ffffffffc020192c:	00044603          	lbu	a2,0(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201930:	0196873b          	addw	a4,a3,s9
ffffffffc0201934:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201938:	0117073b          	addw	a4,a4,a7
                if (ch < '0' || ch > '9') {
ffffffffc020193c:	fd06069b          	addiw	a3,a2,-48
                precision = precision * 10 + ch - '0';
ffffffffc0201940:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
ffffffffc0201944:	0006089b          	sext.w	a7,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201948:	fcd57fe3          	bleu	a3,a0,ffffffffc0201926 <vprintfmt+0x252>
ffffffffc020194c:	b77d                	j	ffffffffc02018fa <vprintfmt+0x226>
            if (width < 0)
ffffffffc020194e:	fffdc693          	not	a3,s11
ffffffffc0201952:	96fd                	srai	a3,a3,0x3f
ffffffffc0201954:	00ddfdb3          	and	s11,s11,a3
ffffffffc0201958:	00144603          	lbu	a2,1(s0)
ffffffffc020195c:	2d81                	sext.w	s11,s11
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020195e:	846a                	mv	s0,s10
ffffffffc0201960:	b3f5                	j	ffffffffc020174c <vprintfmt+0x78>
            putch('%', putdat);
ffffffffc0201962:	85a6                	mv	a1,s1
ffffffffc0201964:	02500513          	li	a0,37
ffffffffc0201968:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020196a:	fff44703          	lbu	a4,-1(s0)
ffffffffc020196e:	02500793          	li	a5,37
ffffffffc0201972:	8d22                	mv	s10,s0
ffffffffc0201974:	d8f70de3          	beq	a4,a5,ffffffffc020170e <vprintfmt+0x3a>
ffffffffc0201978:	02500713          	li	a4,37
ffffffffc020197c:	1d7d                	addi	s10,s10,-1
ffffffffc020197e:	fffd4783          	lbu	a5,-1(s10)
ffffffffc0201982:	fee79de3          	bne	a5,a4,ffffffffc020197c <vprintfmt+0x2a8>
ffffffffc0201986:	b361                	j	ffffffffc020170e <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201988:	00001617          	auipc	a2,0x1
ffffffffc020198c:	0b860613          	addi	a2,a2,184 # ffffffffc0202a40 <error_string+0xd8>
ffffffffc0201990:	85a6                	mv	a1,s1
ffffffffc0201992:	854a                	mv	a0,s2
ffffffffc0201994:	0ac000ef          	jal	ra,ffffffffc0201a40 <printfmt>
ffffffffc0201998:	bb9d                	j	ffffffffc020170e <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020199a:	00001617          	auipc	a2,0x1
ffffffffc020199e:	09e60613          	addi	a2,a2,158 # ffffffffc0202a38 <error_string+0xd0>
            if (width > 0 && padc != '-') {
ffffffffc02019a2:	00001417          	auipc	s0,0x1
ffffffffc02019a6:	09740413          	addi	s0,s0,151 # ffffffffc0202a39 <error_string+0xd1>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02019aa:	8532                	mv	a0,a2
ffffffffc02019ac:	85e6                	mv	a1,s9
ffffffffc02019ae:	e032                	sd	a2,0(sp)
ffffffffc02019b0:	e43e                	sd	a5,8(sp)
ffffffffc02019b2:	c37ff0ef          	jal	ra,ffffffffc02015e8 <strnlen>
ffffffffc02019b6:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02019ba:	6602                	ld	a2,0(sp)
ffffffffc02019bc:	01b05d63          	blez	s11,ffffffffc02019d6 <vprintfmt+0x302>
ffffffffc02019c0:	67a2                	ld	a5,8(sp)
ffffffffc02019c2:	2781                	sext.w	a5,a5
ffffffffc02019c4:	e43e                	sd	a5,8(sp)
                    putch(padc, putdat);
ffffffffc02019c6:	6522                	ld	a0,8(sp)
ffffffffc02019c8:	85a6                	mv	a1,s1
ffffffffc02019ca:	e032                	sd	a2,0(sp)
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02019cc:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02019ce:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02019d0:	6602                	ld	a2,0(sp)
ffffffffc02019d2:	fe0d9ae3          	bnez	s11,ffffffffc02019c6 <vprintfmt+0x2f2>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02019d6:	00064783          	lbu	a5,0(a2)
ffffffffc02019da:	0007851b          	sext.w	a0,a5
ffffffffc02019de:	e8051be3          	bnez	a0,ffffffffc0201874 <vprintfmt+0x1a0>
ffffffffc02019e2:	b335                	j	ffffffffc020170e <vprintfmt+0x3a>
        return va_arg(*ap, int);
ffffffffc02019e4:	000aa403          	lw	s0,0(s5)
ffffffffc02019e8:	bbf1                	j	ffffffffc02017c4 <vprintfmt+0xf0>
        return va_arg(*ap, unsigned int);
ffffffffc02019ea:	000ae603          	lwu	a2,0(s5)
ffffffffc02019ee:	46a9                	li	a3,10
ffffffffc02019f0:	8aae                	mv	s5,a1
ffffffffc02019f2:	bd89                	j	ffffffffc0201844 <vprintfmt+0x170>
ffffffffc02019f4:	000ae603          	lwu	a2,0(s5)
ffffffffc02019f8:	46c1                	li	a3,16
ffffffffc02019fa:	8aae                	mv	s5,a1
ffffffffc02019fc:	b5a1                	j	ffffffffc0201844 <vprintfmt+0x170>
ffffffffc02019fe:	000ae603          	lwu	a2,0(s5)
ffffffffc0201a02:	46a1                	li	a3,8
ffffffffc0201a04:	8aae                	mv	s5,a1
ffffffffc0201a06:	bd3d                	j	ffffffffc0201844 <vprintfmt+0x170>
                    putch(ch, putdat);
ffffffffc0201a08:	9902                	jalr	s2
ffffffffc0201a0a:	b559                	j	ffffffffc0201890 <vprintfmt+0x1bc>
                putch('-', putdat);
ffffffffc0201a0c:	85a6                	mv	a1,s1
ffffffffc0201a0e:	02d00513          	li	a0,45
ffffffffc0201a12:	e03e                	sd	a5,0(sp)
ffffffffc0201a14:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201a16:	8ace                	mv	s5,s3
ffffffffc0201a18:	40800633          	neg	a2,s0
ffffffffc0201a1c:	46a9                	li	a3,10
ffffffffc0201a1e:	6782                	ld	a5,0(sp)
ffffffffc0201a20:	b515                	j	ffffffffc0201844 <vprintfmt+0x170>
            if (width > 0 && padc != '-') {
ffffffffc0201a22:	01b05663          	blez	s11,ffffffffc0201a2e <vprintfmt+0x35a>
ffffffffc0201a26:	02d00693          	li	a3,45
ffffffffc0201a2a:	f6d798e3          	bne	a5,a3,ffffffffc020199a <vprintfmt+0x2c6>
ffffffffc0201a2e:	00001417          	auipc	s0,0x1
ffffffffc0201a32:	00b40413          	addi	s0,s0,11 # ffffffffc0202a39 <error_string+0xd1>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201a36:	02800513          	li	a0,40
ffffffffc0201a3a:	02800793          	li	a5,40
ffffffffc0201a3e:	bd1d                	j	ffffffffc0201874 <vprintfmt+0x1a0>

ffffffffc0201a40 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201a40:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201a42:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201a46:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201a48:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201a4a:	ec06                	sd	ra,24(sp)
ffffffffc0201a4c:	f83a                	sd	a4,48(sp)
ffffffffc0201a4e:	fc3e                	sd	a5,56(sp)
ffffffffc0201a50:	e0c2                	sd	a6,64(sp)
ffffffffc0201a52:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201a54:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201a56:	c7fff0ef          	jal	ra,ffffffffc02016d4 <vprintfmt>
}
ffffffffc0201a5a:	60e2                	ld	ra,24(sp)
ffffffffc0201a5c:	6161                	addi	sp,sp,80
ffffffffc0201a5e:	8082                	ret

ffffffffc0201a60 <sbi_console_putchar>:
    );
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
ffffffffc0201a60:	00004797          	auipc	a5,0x4
ffffffffc0201a64:	5a878793          	addi	a5,a5,1448 # ffffffffc0206008 <SBI_CONSOLE_PUTCHAR>
    __asm__ volatile (
ffffffffc0201a68:	6398                	ld	a4,0(a5)
ffffffffc0201a6a:	4781                	li	a5,0
ffffffffc0201a6c:	88ba                	mv	a7,a4
ffffffffc0201a6e:	852a                	mv	a0,a0
ffffffffc0201a70:	85be                	mv	a1,a5
ffffffffc0201a72:	863e                	mv	a2,a5
ffffffffc0201a74:	00000073          	ecall
ffffffffc0201a78:	87aa                	mv	a5,a0
}
ffffffffc0201a7a:	8082                	ret

ffffffffc0201a7c <sbi_set_timer>:

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
ffffffffc0201a7c:	00005797          	auipc	a5,0x5
ffffffffc0201a80:	9b478793          	addi	a5,a5,-1612 # ffffffffc0206430 <SBI_SET_TIMER>
    __asm__ volatile (
ffffffffc0201a84:	6398                	ld	a4,0(a5)
ffffffffc0201a86:	4781                	li	a5,0
ffffffffc0201a88:	88ba                	mv	a7,a4
ffffffffc0201a8a:	852a                	mv	a0,a0
ffffffffc0201a8c:	85be                	mv	a1,a5
ffffffffc0201a8e:	863e                	mv	a2,a5
ffffffffc0201a90:	00000073          	ecall
ffffffffc0201a94:	87aa                	mv	a5,a0
}
ffffffffc0201a96:	8082                	ret

ffffffffc0201a98 <sbi_console_getchar>:

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
ffffffffc0201a98:	00004797          	auipc	a5,0x4
ffffffffc0201a9c:	56878793          	addi	a5,a5,1384 # ffffffffc0206000 <SBI_CONSOLE_GETCHAR>
    __asm__ volatile (
ffffffffc0201aa0:	639c                	ld	a5,0(a5)
ffffffffc0201aa2:	4501                	li	a0,0
ffffffffc0201aa4:	88be                	mv	a7,a5
ffffffffc0201aa6:	852a                	mv	a0,a0
ffffffffc0201aa8:	85aa                	mv	a1,a0
ffffffffc0201aaa:	862a                	mv	a2,a0
ffffffffc0201aac:	00000073          	ecall
ffffffffc0201ab0:	852a                	mv	a0,a0
ffffffffc0201ab2:	2501                	sext.w	a0,a0
ffffffffc0201ab4:	8082                	ret

ffffffffc0201ab6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201ab6:	715d                	addi	sp,sp,-80
ffffffffc0201ab8:	e486                	sd	ra,72(sp)
ffffffffc0201aba:	e0a2                	sd	s0,64(sp)
ffffffffc0201abc:	fc26                	sd	s1,56(sp)
ffffffffc0201abe:	f84a                	sd	s2,48(sp)
ffffffffc0201ac0:	f44e                	sd	s3,40(sp)
ffffffffc0201ac2:	f052                	sd	s4,32(sp)
ffffffffc0201ac4:	ec56                	sd	s5,24(sp)
ffffffffc0201ac6:	e85a                	sd	s6,16(sp)
ffffffffc0201ac8:	e45e                	sd	s7,8(sp)
    if (prompt != NULL) {
ffffffffc0201aca:	c901                	beqz	a0,ffffffffc0201ada <readline+0x24>
        cprintf("%s", prompt);
ffffffffc0201acc:	85aa                	mv	a1,a0
ffffffffc0201ace:	00001517          	auipc	a0,0x1
ffffffffc0201ad2:	f8250513          	addi	a0,a0,-126 # ffffffffc0202a50 <error_string+0xe8>
ffffffffc0201ad6:	ddcfe0ef          	jal	ra,ffffffffc02000b2 <cprintf>
readline(const char *prompt) {
ffffffffc0201ada:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201adc:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201ade:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201ae0:	4aa9                	li	s5,10
ffffffffc0201ae2:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201ae4:	00004b97          	auipc	s7,0x4
ffffffffc0201ae8:	52cb8b93          	addi	s7,s7,1324 # ffffffffc0206010 <edata>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201aec:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201af0:	e3afe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201af4:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0201af6:	00054b63          	bltz	a0,ffffffffc0201b0c <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201afa:	00a95b63          	ble	a0,s2,ffffffffc0201b10 <readline+0x5a>
ffffffffc0201afe:	029a5463          	ble	s1,s4,ffffffffc0201b26 <readline+0x70>
        c = getchar();
ffffffffc0201b02:	e28fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201b06:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0201b08:	fe0559e3          	bgez	a0,ffffffffc0201afa <readline+0x44>
            return NULL;
ffffffffc0201b0c:	4501                	li	a0,0
ffffffffc0201b0e:	a099                	j	ffffffffc0201b54 <readline+0x9e>
        else if (c == '\b' && i > 0) {
ffffffffc0201b10:	03341463          	bne	s0,s3,ffffffffc0201b38 <readline+0x82>
ffffffffc0201b14:	e8b9                	bnez	s1,ffffffffc0201b6a <readline+0xb4>
        c = getchar();
ffffffffc0201b16:	e14fe0ef          	jal	ra,ffffffffc020012a <getchar>
ffffffffc0201b1a:	842a                	mv	s0,a0
        if (c < 0) {
ffffffffc0201b1c:	fe0548e3          	bltz	a0,ffffffffc0201b0c <readline+0x56>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201b20:	fea958e3          	ble	a0,s2,ffffffffc0201b10 <readline+0x5a>
ffffffffc0201b24:	4481                	li	s1,0
            cputchar(c);
ffffffffc0201b26:	8522                	mv	a0,s0
ffffffffc0201b28:	dbefe0ef          	jal	ra,ffffffffc02000e6 <cputchar>
            buf[i ++] = c;
ffffffffc0201b2c:	009b87b3          	add	a5,s7,s1
ffffffffc0201b30:	00878023          	sb	s0,0(a5)
ffffffffc0201b34:	2485                	addiw	s1,s1,1
ffffffffc0201b36:	bf6d                	j	ffffffffc0201af0 <readline+0x3a>
        else if (c == '\n' || c == '\r') {
ffffffffc0201b38:	01540463          	beq	s0,s5,ffffffffc0201b40 <readline+0x8a>
ffffffffc0201b3c:	fb641ae3          	bne	s0,s6,ffffffffc0201af0 <readline+0x3a>
            cputchar(c);
ffffffffc0201b40:	8522                	mv	a0,s0
ffffffffc0201b42:	da4fe0ef          	jal	ra,ffffffffc02000e6 <cputchar>
            buf[i] = '\0';
ffffffffc0201b46:	00004517          	auipc	a0,0x4
ffffffffc0201b4a:	4ca50513          	addi	a0,a0,1226 # ffffffffc0206010 <edata>
ffffffffc0201b4e:	94aa                	add	s1,s1,a0
ffffffffc0201b50:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0201b54:	60a6                	ld	ra,72(sp)
ffffffffc0201b56:	6406                	ld	s0,64(sp)
ffffffffc0201b58:	74e2                	ld	s1,56(sp)
ffffffffc0201b5a:	7942                	ld	s2,48(sp)
ffffffffc0201b5c:	79a2                	ld	s3,40(sp)
ffffffffc0201b5e:	7a02                	ld	s4,32(sp)
ffffffffc0201b60:	6ae2                	ld	s5,24(sp)
ffffffffc0201b62:	6b42                	ld	s6,16(sp)
ffffffffc0201b64:	6ba2                	ld	s7,8(sp)
ffffffffc0201b66:	6161                	addi	sp,sp,80
ffffffffc0201b68:	8082                	ret
            cputchar(c);
ffffffffc0201b6a:	4521                	li	a0,8
ffffffffc0201b6c:	d7afe0ef          	jal	ra,ffffffffc02000e6 <cputchar>
            i --;
ffffffffc0201b70:	34fd                	addiw	s1,s1,-1
ffffffffc0201b72:	bfbd                	j	ffffffffc0201af0 <readline+0x3a>
