
obj/__user_spin.out：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000800020 <__panic>:
  800020:	715d                	addi	sp,sp,-80
  800022:	e822                	sd	s0,16(sp)
  800024:	fc3e                	sd	a5,56(sp)
  800026:	8432                	mv	s0,a2
  800028:	103c                	addi	a5,sp,40
  80002a:	862e                	mv	a2,a1
  80002c:	85aa                	mv	a1,a0
  80002e:	00000517          	auipc	a0,0x0
  800032:	78250513          	addi	a0,a0,1922 # 8007b0 <main+0xd0>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	13e000ef          	jal	ra,800180 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	110000ef          	jal	ra,80015a <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	7c250513          	addi	a0,a0,1986 # 800810 <main+0x130>
  800056:	12a000ef          	jal	ra,800180 <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	216000ef          	jal	ra,800272 <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00000517          	auipc	a0,0x0
  800072:	76250513          	addi	a0,a0,1890 # 8007d0 <main+0xf0>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	0fe000ef          	jal	ra,800180 <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	0d0000ef          	jal	ra,80015a <vcprintf>
  80008e:	00000517          	auipc	a0,0x0
  800092:	78250513          	addi	a0,a0,1922 # 800810 <main+0x130>
  800096:	0ea000ef          	jal	ra,800180 <cprintf>
  80009a:	60e2                	ld	ra,24(sp)
  80009c:	6442                	ld	s0,16(sp)
  80009e:	6161                	addi	sp,sp,80
  8000a0:	8082                	ret

00000000008000a2 <syscall>:
  8000a2:	7175                	addi	sp,sp,-144
  8000a4:	f8ba                	sd	a4,112(sp)
  8000a6:	e0ba                	sd	a4,64(sp)
  8000a8:	0118                	addi	a4,sp,128
  8000aa:	e42a                	sd	a0,8(sp)
  8000ac:	ecae                	sd	a1,88(sp)
  8000ae:	f0b2                	sd	a2,96(sp)
  8000b0:	f4b6                	sd	a3,104(sp)
  8000b2:	fcbe                	sd	a5,120(sp)
  8000b4:	e142                	sd	a6,128(sp)
  8000b6:	e546                	sd	a7,136(sp)
  8000b8:	f42e                	sd	a1,40(sp)
  8000ba:	f832                	sd	a2,48(sp)
  8000bc:	fc36                	sd	a3,56(sp)
  8000be:	f03a                	sd	a4,32(sp)
  8000c0:	e4be                	sd	a5,72(sp)
  8000c2:	4522                	lw	a0,8(sp)
  8000c4:	55a2                	lw	a1,40(sp)
  8000c6:	5642                	lw	a2,48(sp)
  8000c8:	56e2                	lw	a3,56(sp)
  8000ca:	4706                	lw	a4,64(sp)
  8000cc:	47a6                	lw	a5,72(sp)
  8000ce:	00000073          	ecall
  8000d2:	ce2a                	sw	a0,28(sp)
  8000d4:	4572                	lw	a0,28(sp)
  8000d6:	6149                	addi	sp,sp,144
  8000d8:	8082                	ret

00000000008000da <sys_exit>:
  8000da:	85aa                	mv	a1,a0
  8000dc:	4505                	li	a0,1
  8000de:	fc5ff06f          	j	8000a2 <syscall>

00000000008000e2 <sys_fork>:
  8000e2:	4509                	li	a0,2
  8000e4:	fbfff06f          	j	8000a2 <syscall>

00000000008000e8 <sys_wait>:
  8000e8:	862e                	mv	a2,a1
  8000ea:	85aa                	mv	a1,a0
  8000ec:	450d                	li	a0,3
  8000ee:	fb5ff06f          	j	8000a2 <syscall>

00000000008000f2 <sys_yield>:
  8000f2:	4529                	li	a0,10
  8000f4:	fafff06f          	j	8000a2 <syscall>

00000000008000f8 <sys_kill>:
  8000f8:	85aa                	mv	a1,a0
  8000fa:	4531                	li	a0,12
  8000fc:	fa7ff06f          	j	8000a2 <syscall>

0000000000800100 <sys_putc>:
  800100:	85aa                	mv	a1,a0
  800102:	4579                	li	a0,30
  800104:	f9fff06f          	j	8000a2 <syscall>

0000000000800108 <sys_open>:
  800108:	862e                	mv	a2,a1
  80010a:	85aa                	mv	a1,a0
  80010c:	06400513          	li	a0,100
  800110:	f93ff06f          	j	8000a2 <syscall>

0000000000800114 <sys_close>:
  800114:	85aa                	mv	a1,a0
  800116:	06500513          	li	a0,101
  80011a:	f89ff06f          	j	8000a2 <syscall>

000000000080011e <sys_dup>:
  80011e:	862e                	mv	a2,a1
  800120:	85aa                	mv	a1,a0
  800122:	08200513          	li	a0,130
  800126:	f7dff06f          	j	8000a2 <syscall>

000000000080012a <_start>:
  80012a:	0d4000ef          	jal	ra,8001fe <umain>
  80012e:	a001                	j	80012e <_start+0x4>

0000000000800130 <open>:
  800130:	1582                	slli	a1,a1,0x20
  800132:	9181                	srli	a1,a1,0x20
  800134:	fd5ff06f          	j	800108 <sys_open>

0000000000800138 <close>:
  800138:	fddff06f          	j	800114 <sys_close>

000000000080013c <dup2>:
  80013c:	fe3ff06f          	j	80011e <sys_dup>

0000000000800140 <cputch>:
  800140:	1141                	addi	sp,sp,-16
  800142:	e022                	sd	s0,0(sp)
  800144:	e406                	sd	ra,8(sp)
  800146:	842e                	mv	s0,a1
  800148:	fb9ff0ef          	jal	ra,800100 <sys_putc>
  80014c:	401c                	lw	a5,0(s0)
  80014e:	60a2                	ld	ra,8(sp)
  800150:	2785                	addiw	a5,a5,1
  800152:	c01c                	sw	a5,0(s0)
  800154:	6402                	ld	s0,0(sp)
  800156:	0141                	addi	sp,sp,16
  800158:	8082                	ret

000000000080015a <vcprintf>:
  80015a:	1101                	addi	sp,sp,-32
  80015c:	872e                	mv	a4,a1
  80015e:	75dd                	lui	a1,0xffff7
  800160:	86aa                	mv	a3,a0
  800162:	0070                	addi	a2,sp,12
  800164:	00000517          	auipc	a0,0x0
  800168:	fdc50513          	addi	a0,a0,-36 # 800140 <cputch>
  80016c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6111>
  800170:	ec06                	sd	ra,24(sp)
  800172:	c602                	sw	zero,12(sp)
  800174:	1c0000ef          	jal	ra,800334 <vprintfmt>
  800178:	60e2                	ld	ra,24(sp)
  80017a:	4532                	lw	a0,12(sp)
  80017c:	6105                	addi	sp,sp,32
  80017e:	8082                	ret

0000000000800180 <cprintf>:
  800180:	711d                	addi	sp,sp,-96
  800182:	02810313          	addi	t1,sp,40
  800186:	f42e                	sd	a1,40(sp)
  800188:	75dd                	lui	a1,0xffff7
  80018a:	f832                	sd	a2,48(sp)
  80018c:	fc36                	sd	a3,56(sp)
  80018e:	e0ba                	sd	a4,64(sp)
  800190:	86aa                	mv	a3,a0
  800192:	0050                	addi	a2,sp,4
  800194:	00000517          	auipc	a0,0x0
  800198:	fac50513          	addi	a0,a0,-84 # 800140 <cputch>
  80019c:	871a                	mv	a4,t1
  80019e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6111>
  8001a2:	ec06                	sd	ra,24(sp)
  8001a4:	e4be                	sd	a5,72(sp)
  8001a6:	e8c2                	sd	a6,80(sp)
  8001a8:	ecc6                	sd	a7,88(sp)
  8001aa:	e41a                	sd	t1,8(sp)
  8001ac:	c202                	sw	zero,4(sp)
  8001ae:	186000ef          	jal	ra,800334 <vprintfmt>
  8001b2:	60e2                	ld	ra,24(sp)
  8001b4:	4512                	lw	a0,4(sp)
  8001b6:	6125                	addi	sp,sp,96
  8001b8:	8082                	ret

00000000008001ba <initfd>:
  8001ba:	1101                	addi	sp,sp,-32
  8001bc:	87ae                	mv	a5,a1
  8001be:	e426                	sd	s1,8(sp)
  8001c0:	85b2                	mv	a1,a2
  8001c2:	84aa                	mv	s1,a0
  8001c4:	853e                	mv	a0,a5
  8001c6:	e822                	sd	s0,16(sp)
  8001c8:	ec06                	sd	ra,24(sp)
  8001ca:	f67ff0ef          	jal	ra,800130 <open>
  8001ce:	842a                	mv	s0,a0
  8001d0:	00054463          	bltz	a0,8001d8 <initfd+0x1e>
  8001d4:	00951863          	bne	a0,s1,8001e4 <initfd+0x2a>
  8001d8:	8522                	mv	a0,s0
  8001da:	60e2                	ld	ra,24(sp)
  8001dc:	6442                	ld	s0,16(sp)
  8001de:	64a2                	ld	s1,8(sp)
  8001e0:	6105                	addi	sp,sp,32
  8001e2:	8082                	ret
  8001e4:	8526                	mv	a0,s1
  8001e6:	f53ff0ef          	jal	ra,800138 <close>
  8001ea:	85a6                	mv	a1,s1
  8001ec:	8522                	mv	a0,s0
  8001ee:	f4fff0ef          	jal	ra,80013c <dup2>
  8001f2:	84aa                	mv	s1,a0
  8001f4:	8522                	mv	a0,s0
  8001f6:	f43ff0ef          	jal	ra,800138 <close>
  8001fa:	8426                	mv	s0,s1
  8001fc:	bff1                	j	8001d8 <initfd+0x1e>

00000000008001fe <umain>:
  8001fe:	1101                	addi	sp,sp,-32
  800200:	e822                	sd	s0,16(sp)
  800202:	e426                	sd	s1,8(sp)
  800204:	842a                	mv	s0,a0
  800206:	84ae                	mv	s1,a1
  800208:	4601                	li	a2,0
  80020a:	00000597          	auipc	a1,0x0
  80020e:	5e658593          	addi	a1,a1,1510 # 8007f0 <main+0x110>
  800212:	4501                	li	a0,0
  800214:	ec06                	sd	ra,24(sp)
  800216:	fa5ff0ef          	jal	ra,8001ba <initfd>
  80021a:	02054263          	bltz	a0,80023e <umain+0x40>
  80021e:	4605                	li	a2,1
  800220:	00000597          	auipc	a1,0x0
  800224:	61058593          	addi	a1,a1,1552 # 800830 <main+0x150>
  800228:	4505                	li	a0,1
  80022a:	f91ff0ef          	jal	ra,8001ba <initfd>
  80022e:	02054563          	bltz	a0,800258 <umain+0x5a>
  800232:	85a6                	mv	a1,s1
  800234:	8522                	mv	a0,s0
  800236:	4aa000ef          	jal	ra,8006e0 <main>
  80023a:	038000ef          	jal	ra,800272 <exit>
  80023e:	86aa                	mv	a3,a0
  800240:	00000617          	auipc	a2,0x0
  800244:	5b860613          	addi	a2,a2,1464 # 8007f8 <main+0x118>
  800248:	45e9                	li	a1,26
  80024a:	00000517          	auipc	a0,0x0
  80024e:	5ce50513          	addi	a0,a0,1486 # 800818 <main+0x138>
  800252:	e0fff0ef          	jal	ra,800060 <__warn>
  800256:	b7e1                	j	80021e <umain+0x20>
  800258:	86aa                	mv	a3,a0
  80025a:	00000617          	auipc	a2,0x0
  80025e:	5de60613          	addi	a2,a2,1502 # 800838 <main+0x158>
  800262:	45f5                	li	a1,29
  800264:	00000517          	auipc	a0,0x0
  800268:	5b450513          	addi	a0,a0,1460 # 800818 <main+0x138>
  80026c:	df5ff0ef          	jal	ra,800060 <__warn>
  800270:	b7c9                	j	800232 <umain+0x34>

0000000000800272 <exit>:
  800272:	1141                	addi	sp,sp,-16
  800274:	e406                	sd	ra,8(sp)
  800276:	e65ff0ef          	jal	ra,8000da <sys_exit>
  80027a:	00000517          	auipc	a0,0x0
  80027e:	5de50513          	addi	a0,a0,1502 # 800858 <main+0x178>
  800282:	effff0ef          	jal	ra,800180 <cprintf>
  800286:	a001                	j	800286 <exit+0x14>

0000000000800288 <fork>:
  800288:	e5bff06f          	j	8000e2 <sys_fork>

000000000080028c <waitpid>:
  80028c:	e5dff06f          	j	8000e8 <sys_wait>

0000000000800290 <yield>:
  800290:	e63ff06f          	j	8000f2 <sys_yield>

0000000000800294 <kill>:
  800294:	e65ff06f          	j	8000f8 <sys_kill>

0000000000800298 <strnlen>:
  800298:	c185                	beqz	a1,8002b8 <strnlen+0x20>
  80029a:	00054783          	lbu	a5,0(a0)
  80029e:	cf89                	beqz	a5,8002b8 <strnlen+0x20>
  8002a0:	4781                	li	a5,0
  8002a2:	a021                	j	8002aa <strnlen+0x12>
  8002a4:	00074703          	lbu	a4,0(a4)
  8002a8:	c711                	beqz	a4,8002b4 <strnlen+0x1c>
  8002aa:	0785                	addi	a5,a5,1
  8002ac:	00f50733          	add	a4,a0,a5
  8002b0:	fef59ae3          	bne	a1,a5,8002a4 <strnlen+0xc>
  8002b4:	853e                	mv	a0,a5
  8002b6:	8082                	ret
  8002b8:	4781                	li	a5,0
  8002ba:	853e                	mv	a0,a5
  8002bc:	8082                	ret

00000000008002be <printnum>:
  8002be:	02071893          	slli	a7,a4,0x20
  8002c2:	7139                	addi	sp,sp,-64
  8002c4:	0208d893          	srli	a7,a7,0x20
  8002c8:	e456                	sd	s5,8(sp)
  8002ca:	0316fab3          	remu	s5,a3,a7
  8002ce:	f822                	sd	s0,48(sp)
  8002d0:	f426                	sd	s1,40(sp)
  8002d2:	f04a                	sd	s2,32(sp)
  8002d4:	ec4e                	sd	s3,24(sp)
  8002d6:	fc06                	sd	ra,56(sp)
  8002d8:	e852                	sd	s4,16(sp)
  8002da:	84aa                	mv	s1,a0
  8002dc:	89ae                	mv	s3,a1
  8002de:	8932                	mv	s2,a2
  8002e0:	fff7841b          	addiw	s0,a5,-1
  8002e4:	2a81                	sext.w	s5,s5
  8002e6:	0516f163          	bleu	a7,a3,800328 <printnum+0x6a>
  8002ea:	8a42                	mv	s4,a6
  8002ec:	00805863          	blez	s0,8002fc <printnum+0x3e>
  8002f0:	347d                	addiw	s0,s0,-1
  8002f2:	864e                	mv	a2,s3
  8002f4:	85ca                	mv	a1,s2
  8002f6:	8552                	mv	a0,s4
  8002f8:	9482                	jalr	s1
  8002fa:	f87d                	bnez	s0,8002f0 <printnum+0x32>
  8002fc:	1a82                	slli	s5,s5,0x20
  8002fe:	020ada93          	srli	s5,s5,0x20
  800302:	00000797          	auipc	a5,0x0
  800306:	78e78793          	addi	a5,a5,1934 # 800a90 <error_string+0xc8>
  80030a:	9abe                	add	s5,s5,a5
  80030c:	7442                	ld	s0,48(sp)
  80030e:	000ac503          	lbu	a0,0(s5)
  800312:	70e2                	ld	ra,56(sp)
  800314:	6a42                	ld	s4,16(sp)
  800316:	6aa2                	ld	s5,8(sp)
  800318:	864e                	mv	a2,s3
  80031a:	85ca                	mv	a1,s2
  80031c:	69e2                	ld	s3,24(sp)
  80031e:	7902                	ld	s2,32(sp)
  800320:	8326                	mv	t1,s1
  800322:	74a2                	ld	s1,40(sp)
  800324:	6121                	addi	sp,sp,64
  800326:	8302                	jr	t1
  800328:	0316d6b3          	divu	a3,a3,a7
  80032c:	87a2                	mv	a5,s0
  80032e:	f91ff0ef          	jal	ra,8002be <printnum>
  800332:	b7e9                	j	8002fc <printnum+0x3e>

0000000000800334 <vprintfmt>:
  800334:	7119                	addi	sp,sp,-128
  800336:	f4a6                	sd	s1,104(sp)
  800338:	f0ca                	sd	s2,96(sp)
  80033a:	ecce                	sd	s3,88(sp)
  80033c:	e4d6                	sd	s5,72(sp)
  80033e:	e0da                	sd	s6,64(sp)
  800340:	fc5e                	sd	s7,56(sp)
  800342:	f862                	sd	s8,48(sp)
  800344:	ec6e                	sd	s11,24(sp)
  800346:	fc86                	sd	ra,120(sp)
  800348:	f8a2                	sd	s0,112(sp)
  80034a:	e8d2                	sd	s4,80(sp)
  80034c:	f466                	sd	s9,40(sp)
  80034e:	f06a                	sd	s10,32(sp)
  800350:	89aa                	mv	s3,a0
  800352:	892e                	mv	s2,a1
  800354:	84b2                	mv	s1,a2
  800356:	8db6                	mv	s11,a3
  800358:	8b3a                	mv	s6,a4
  80035a:	5bfd                	li	s7,-1
  80035c:	00000a97          	auipc	s5,0x0
  800360:	510a8a93          	addi	s5,s5,1296 # 80086c <main+0x18c>
  800364:	05e00c13          	li	s8,94
  800368:	000dc503          	lbu	a0,0(s11)
  80036c:	02500793          	li	a5,37
  800370:	001d8413          	addi	s0,s11,1
  800374:	00f50f63          	beq	a0,a5,800392 <vprintfmt+0x5e>
  800378:	c529                	beqz	a0,8003c2 <vprintfmt+0x8e>
  80037a:	02500a13          	li	s4,37
  80037e:	a011                	j	800382 <vprintfmt+0x4e>
  800380:	c129                	beqz	a0,8003c2 <vprintfmt+0x8e>
  800382:	864a                	mv	a2,s2
  800384:	85a6                	mv	a1,s1
  800386:	0405                	addi	s0,s0,1
  800388:	9982                	jalr	s3
  80038a:	fff44503          	lbu	a0,-1(s0)
  80038e:	ff4519e3          	bne	a0,s4,800380 <vprintfmt+0x4c>
  800392:	00044603          	lbu	a2,0(s0)
  800396:	02000813          	li	a6,32
  80039a:	4a01                	li	s4,0
  80039c:	4881                	li	a7,0
  80039e:	5d7d                	li	s10,-1
  8003a0:	5cfd                	li	s9,-1
  8003a2:	05500593          	li	a1,85
  8003a6:	4525                	li	a0,9
  8003a8:	fdd6071b          	addiw	a4,a2,-35
  8003ac:	0ff77713          	andi	a4,a4,255
  8003b0:	00140d93          	addi	s11,s0,1
  8003b4:	22e5e363          	bltu	a1,a4,8005da <vprintfmt+0x2a6>
  8003b8:	070a                	slli	a4,a4,0x2
  8003ba:	9756                	add	a4,a4,s5
  8003bc:	4318                	lw	a4,0(a4)
  8003be:	9756                	add	a4,a4,s5
  8003c0:	8702                	jr	a4
  8003c2:	70e6                	ld	ra,120(sp)
  8003c4:	7446                	ld	s0,112(sp)
  8003c6:	74a6                	ld	s1,104(sp)
  8003c8:	7906                	ld	s2,96(sp)
  8003ca:	69e6                	ld	s3,88(sp)
  8003cc:	6a46                	ld	s4,80(sp)
  8003ce:	6aa6                	ld	s5,72(sp)
  8003d0:	6b06                	ld	s6,64(sp)
  8003d2:	7be2                	ld	s7,56(sp)
  8003d4:	7c42                	ld	s8,48(sp)
  8003d6:	7ca2                	ld	s9,40(sp)
  8003d8:	7d02                	ld	s10,32(sp)
  8003da:	6de2                	ld	s11,24(sp)
  8003dc:	6109                	addi	sp,sp,128
  8003de:	8082                	ret
  8003e0:	4705                	li	a4,1
  8003e2:	008b0613          	addi	a2,s6,8
  8003e6:	01174463          	blt	a4,a7,8003ee <vprintfmt+0xba>
  8003ea:	28088563          	beqz	a7,800674 <vprintfmt+0x340>
  8003ee:	000b3683          	ld	a3,0(s6)
  8003f2:	4741                	li	a4,16
  8003f4:	8b32                	mv	s6,a2
  8003f6:	a86d                	j	8004b0 <vprintfmt+0x17c>
  8003f8:	00144603          	lbu	a2,1(s0)
  8003fc:	4a05                	li	s4,1
  8003fe:	846e                	mv	s0,s11
  800400:	b765                	j	8003a8 <vprintfmt+0x74>
  800402:	000b2503          	lw	a0,0(s6)
  800406:	864a                	mv	a2,s2
  800408:	85a6                	mv	a1,s1
  80040a:	0b21                	addi	s6,s6,8
  80040c:	9982                	jalr	s3
  80040e:	bfa9                	j	800368 <vprintfmt+0x34>
  800410:	4705                	li	a4,1
  800412:	008b0a13          	addi	s4,s6,8
  800416:	01174463          	blt	a4,a7,80041e <vprintfmt+0xea>
  80041a:	24088563          	beqz	a7,800664 <vprintfmt+0x330>
  80041e:	000b3403          	ld	s0,0(s6)
  800422:	26044563          	bltz	s0,80068c <vprintfmt+0x358>
  800426:	86a2                	mv	a3,s0
  800428:	8b52                	mv	s6,s4
  80042a:	4729                	li	a4,10
  80042c:	a051                	j	8004b0 <vprintfmt+0x17c>
  80042e:	000b2783          	lw	a5,0(s6)
  800432:	46e1                	li	a3,24
  800434:	0b21                	addi	s6,s6,8
  800436:	41f7d71b          	sraiw	a4,a5,0x1f
  80043a:	8fb9                	xor	a5,a5,a4
  80043c:	40e7873b          	subw	a4,a5,a4
  800440:	1ce6c163          	blt	a3,a4,800602 <vprintfmt+0x2ce>
  800444:	00371793          	slli	a5,a4,0x3
  800448:	00000697          	auipc	a3,0x0
  80044c:	58068693          	addi	a3,a3,1408 # 8009c8 <error_string>
  800450:	97b6                	add	a5,a5,a3
  800452:	639c                	ld	a5,0(a5)
  800454:	1a078763          	beqz	a5,800602 <vprintfmt+0x2ce>
  800458:	873e                	mv	a4,a5
  80045a:	00001697          	auipc	a3,0x1
  80045e:	83e68693          	addi	a3,a3,-1986 # 800c98 <error_string+0x2d0>
  800462:	8626                	mv	a2,s1
  800464:	85ca                	mv	a1,s2
  800466:	854e                	mv	a0,s3
  800468:	25a000ef          	jal	ra,8006c2 <printfmt>
  80046c:	bdf5                	j	800368 <vprintfmt+0x34>
  80046e:	00144603          	lbu	a2,1(s0)
  800472:	2885                	addiw	a7,a7,1
  800474:	846e                	mv	s0,s11
  800476:	bf0d                	j	8003a8 <vprintfmt+0x74>
  800478:	4705                	li	a4,1
  80047a:	008b0613          	addi	a2,s6,8
  80047e:	01174463          	blt	a4,a7,800486 <vprintfmt+0x152>
  800482:	1e088e63          	beqz	a7,80067e <vprintfmt+0x34a>
  800486:	000b3683          	ld	a3,0(s6)
  80048a:	4721                	li	a4,8
  80048c:	8b32                	mv	s6,a2
  80048e:	a00d                	j	8004b0 <vprintfmt+0x17c>
  800490:	03000513          	li	a0,48
  800494:	864a                	mv	a2,s2
  800496:	85a6                	mv	a1,s1
  800498:	e042                	sd	a6,0(sp)
  80049a:	9982                	jalr	s3
  80049c:	864a                	mv	a2,s2
  80049e:	85a6                	mv	a1,s1
  8004a0:	07800513          	li	a0,120
  8004a4:	9982                	jalr	s3
  8004a6:	0b21                	addi	s6,s6,8
  8004a8:	ff8b3683          	ld	a3,-8(s6)
  8004ac:	6802                	ld	a6,0(sp)
  8004ae:	4741                	li	a4,16
  8004b0:	87e6                	mv	a5,s9
  8004b2:	8626                	mv	a2,s1
  8004b4:	85ca                	mv	a1,s2
  8004b6:	854e                	mv	a0,s3
  8004b8:	e07ff0ef          	jal	ra,8002be <printnum>
  8004bc:	b575                	j	800368 <vprintfmt+0x34>
  8004be:	000b3703          	ld	a4,0(s6)
  8004c2:	0b21                	addi	s6,s6,8
  8004c4:	1e070063          	beqz	a4,8006a4 <vprintfmt+0x370>
  8004c8:	00170413          	addi	s0,a4,1
  8004cc:	19905563          	blez	s9,800656 <vprintfmt+0x322>
  8004d0:	02d00613          	li	a2,45
  8004d4:	14c81963          	bne	a6,a2,800626 <vprintfmt+0x2f2>
  8004d8:	00074703          	lbu	a4,0(a4)
  8004dc:	0007051b          	sext.w	a0,a4
  8004e0:	c90d                	beqz	a0,800512 <vprintfmt+0x1de>
  8004e2:	000d4563          	bltz	s10,8004ec <vprintfmt+0x1b8>
  8004e6:	3d7d                	addiw	s10,s10,-1
  8004e8:	037d0363          	beq	s10,s7,80050e <vprintfmt+0x1da>
  8004ec:	864a                	mv	a2,s2
  8004ee:	85a6                	mv	a1,s1
  8004f0:	180a0c63          	beqz	s4,800688 <vprintfmt+0x354>
  8004f4:	3701                	addiw	a4,a4,-32
  8004f6:	18ec7963          	bleu	a4,s8,800688 <vprintfmt+0x354>
  8004fa:	03f00513          	li	a0,63
  8004fe:	9982                	jalr	s3
  800500:	0405                	addi	s0,s0,1
  800502:	fff44703          	lbu	a4,-1(s0)
  800506:	3cfd                	addiw	s9,s9,-1
  800508:	0007051b          	sext.w	a0,a4
  80050c:	f979                	bnez	a0,8004e2 <vprintfmt+0x1ae>
  80050e:	e5905de3          	blez	s9,800368 <vprintfmt+0x34>
  800512:	3cfd                	addiw	s9,s9,-1
  800514:	864a                	mv	a2,s2
  800516:	85a6                	mv	a1,s1
  800518:	02000513          	li	a0,32
  80051c:	9982                	jalr	s3
  80051e:	e40c85e3          	beqz	s9,800368 <vprintfmt+0x34>
  800522:	3cfd                	addiw	s9,s9,-1
  800524:	864a                	mv	a2,s2
  800526:	85a6                	mv	a1,s1
  800528:	02000513          	li	a0,32
  80052c:	9982                	jalr	s3
  80052e:	fe0c92e3          	bnez	s9,800512 <vprintfmt+0x1de>
  800532:	bd1d                	j	800368 <vprintfmt+0x34>
  800534:	4705                	li	a4,1
  800536:	008b0613          	addi	a2,s6,8
  80053a:	01174463          	blt	a4,a7,800542 <vprintfmt+0x20e>
  80053e:	12088663          	beqz	a7,80066a <vprintfmt+0x336>
  800542:	000b3683          	ld	a3,0(s6)
  800546:	4729                	li	a4,10
  800548:	8b32                	mv	s6,a2
  80054a:	b79d                	j	8004b0 <vprintfmt+0x17c>
  80054c:	00144603          	lbu	a2,1(s0)
  800550:	02d00813          	li	a6,45
  800554:	846e                	mv	s0,s11
  800556:	bd89                	j	8003a8 <vprintfmt+0x74>
  800558:	864a                	mv	a2,s2
  80055a:	85a6                	mv	a1,s1
  80055c:	02500513          	li	a0,37
  800560:	9982                	jalr	s3
  800562:	b519                	j	800368 <vprintfmt+0x34>
  800564:	000b2d03          	lw	s10,0(s6)
  800568:	00144603          	lbu	a2,1(s0)
  80056c:	0b21                	addi	s6,s6,8
  80056e:	846e                	mv	s0,s11
  800570:	e20cdce3          	bgez	s9,8003a8 <vprintfmt+0x74>
  800574:	8cea                	mv	s9,s10
  800576:	5d7d                	li	s10,-1
  800578:	bd05                	j	8003a8 <vprintfmt+0x74>
  80057a:	00144603          	lbu	a2,1(s0)
  80057e:	03000813          	li	a6,48
  800582:	846e                	mv	s0,s11
  800584:	b515                	j	8003a8 <vprintfmt+0x74>
  800586:	fd060d1b          	addiw	s10,a2,-48
  80058a:	00144603          	lbu	a2,1(s0)
  80058e:	846e                	mv	s0,s11
  800590:	fd06071b          	addiw	a4,a2,-48
  800594:	0006031b          	sext.w	t1,a2
  800598:	fce56ce3          	bltu	a0,a4,800570 <vprintfmt+0x23c>
  80059c:	0405                	addi	s0,s0,1
  80059e:	002d171b          	slliw	a4,s10,0x2
  8005a2:	00044603          	lbu	a2,0(s0)
  8005a6:	01a706bb          	addw	a3,a4,s10
  8005aa:	0016969b          	slliw	a3,a3,0x1
  8005ae:	006686bb          	addw	a3,a3,t1
  8005b2:	fd06071b          	addiw	a4,a2,-48
  8005b6:	fd068d1b          	addiw	s10,a3,-48
  8005ba:	0006031b          	sext.w	t1,a2
  8005be:	fce57fe3          	bleu	a4,a0,80059c <vprintfmt+0x268>
  8005c2:	b77d                	j	800570 <vprintfmt+0x23c>
  8005c4:	fffcc713          	not	a4,s9
  8005c8:	977d                	srai	a4,a4,0x3f
  8005ca:	00ecf7b3          	and	a5,s9,a4
  8005ce:	00144603          	lbu	a2,1(s0)
  8005d2:	00078c9b          	sext.w	s9,a5
  8005d6:	846e                	mv	s0,s11
  8005d8:	bbc1                	j	8003a8 <vprintfmt+0x74>
  8005da:	864a                	mv	a2,s2
  8005dc:	85a6                	mv	a1,s1
  8005de:	02500513          	li	a0,37
  8005e2:	9982                	jalr	s3
  8005e4:	fff44703          	lbu	a4,-1(s0)
  8005e8:	02500793          	li	a5,37
  8005ec:	8da2                	mv	s11,s0
  8005ee:	d6f70de3          	beq	a4,a5,800368 <vprintfmt+0x34>
  8005f2:	02500713          	li	a4,37
  8005f6:	1dfd                	addi	s11,s11,-1
  8005f8:	fffdc783          	lbu	a5,-1(s11)
  8005fc:	fee79de3          	bne	a5,a4,8005f6 <vprintfmt+0x2c2>
  800600:	b3a5                	j	800368 <vprintfmt+0x34>
  800602:	00000697          	auipc	a3,0x0
  800606:	68668693          	addi	a3,a3,1670 # 800c88 <error_string+0x2c0>
  80060a:	8626                	mv	a2,s1
  80060c:	85ca                	mv	a1,s2
  80060e:	854e                	mv	a0,s3
  800610:	0b2000ef          	jal	ra,8006c2 <printfmt>
  800614:	bb91                	j	800368 <vprintfmt+0x34>
  800616:	00000717          	auipc	a4,0x0
  80061a:	66a70713          	addi	a4,a4,1642 # 800c80 <error_string+0x2b8>
  80061e:	00000417          	auipc	s0,0x0
  800622:	66340413          	addi	s0,s0,1635 # 800c81 <error_string+0x2b9>
  800626:	853a                	mv	a0,a4
  800628:	85ea                	mv	a1,s10
  80062a:	e03a                	sd	a4,0(sp)
  80062c:	e442                	sd	a6,8(sp)
  80062e:	c6bff0ef          	jal	ra,800298 <strnlen>
  800632:	40ac8cbb          	subw	s9,s9,a0
  800636:	6702                	ld	a4,0(sp)
  800638:	01905f63          	blez	s9,800656 <vprintfmt+0x322>
  80063c:	6822                	ld	a6,8(sp)
  80063e:	0008079b          	sext.w	a5,a6
  800642:	e43e                	sd	a5,8(sp)
  800644:	6522                	ld	a0,8(sp)
  800646:	864a                	mv	a2,s2
  800648:	85a6                	mv	a1,s1
  80064a:	e03a                	sd	a4,0(sp)
  80064c:	3cfd                	addiw	s9,s9,-1
  80064e:	9982                	jalr	s3
  800650:	6702                	ld	a4,0(sp)
  800652:	fe0c99e3          	bnez	s9,800644 <vprintfmt+0x310>
  800656:	00074703          	lbu	a4,0(a4)
  80065a:	0007051b          	sext.w	a0,a4
  80065e:	e80512e3          	bnez	a0,8004e2 <vprintfmt+0x1ae>
  800662:	b319                	j	800368 <vprintfmt+0x34>
  800664:	000b2403          	lw	s0,0(s6)
  800668:	bb6d                	j	800422 <vprintfmt+0xee>
  80066a:	000b6683          	lwu	a3,0(s6)
  80066e:	4729                	li	a4,10
  800670:	8b32                	mv	s6,a2
  800672:	bd3d                	j	8004b0 <vprintfmt+0x17c>
  800674:	000b6683          	lwu	a3,0(s6)
  800678:	4741                	li	a4,16
  80067a:	8b32                	mv	s6,a2
  80067c:	bd15                	j	8004b0 <vprintfmt+0x17c>
  80067e:	000b6683          	lwu	a3,0(s6)
  800682:	4721                	li	a4,8
  800684:	8b32                	mv	s6,a2
  800686:	b52d                	j	8004b0 <vprintfmt+0x17c>
  800688:	9982                	jalr	s3
  80068a:	bd9d                	j	800500 <vprintfmt+0x1cc>
  80068c:	864a                	mv	a2,s2
  80068e:	85a6                	mv	a1,s1
  800690:	02d00513          	li	a0,45
  800694:	e042                	sd	a6,0(sp)
  800696:	9982                	jalr	s3
  800698:	8b52                	mv	s6,s4
  80069a:	408006b3          	neg	a3,s0
  80069e:	4729                	li	a4,10
  8006a0:	6802                	ld	a6,0(sp)
  8006a2:	b539                	j	8004b0 <vprintfmt+0x17c>
  8006a4:	01905663          	blez	s9,8006b0 <vprintfmt+0x37c>
  8006a8:	02d00713          	li	a4,45
  8006ac:	f6e815e3          	bne	a6,a4,800616 <vprintfmt+0x2e2>
  8006b0:	00000417          	auipc	s0,0x0
  8006b4:	5d140413          	addi	s0,s0,1489 # 800c81 <error_string+0x2b9>
  8006b8:	02800513          	li	a0,40
  8006bc:	02800713          	li	a4,40
  8006c0:	b50d                	j	8004e2 <vprintfmt+0x1ae>

00000000008006c2 <printfmt>:
  8006c2:	7139                	addi	sp,sp,-64
  8006c4:	02010313          	addi	t1,sp,32
  8006c8:	f03a                	sd	a4,32(sp)
  8006ca:	871a                	mv	a4,t1
  8006cc:	ec06                	sd	ra,24(sp)
  8006ce:	f43e                	sd	a5,40(sp)
  8006d0:	f842                	sd	a6,48(sp)
  8006d2:	fc46                	sd	a7,56(sp)
  8006d4:	e41a                	sd	t1,8(sp)
  8006d6:	c5fff0ef          	jal	ra,800334 <vprintfmt>
  8006da:	60e2                	ld	ra,24(sp)
  8006dc:	6121                	addi	sp,sp,64
  8006de:	8082                	ret

00000000008006e0 <main>:
  8006e0:	1141                	addi	sp,sp,-16
  8006e2:	00000517          	auipc	a0,0x0
  8006e6:	5be50513          	addi	a0,a0,1470 # 800ca0 <error_string+0x2d8>
  8006ea:	e406                	sd	ra,8(sp)
  8006ec:	e022                	sd	s0,0(sp)
  8006ee:	a93ff0ef          	jal	ra,800180 <cprintf>
  8006f2:	b97ff0ef          	jal	ra,800288 <fork>
  8006f6:	e901                	bnez	a0,800706 <main+0x26>
  8006f8:	00000517          	auipc	a0,0x0
  8006fc:	5d050513          	addi	a0,a0,1488 # 800cc8 <error_string+0x300>
  800700:	a81ff0ef          	jal	ra,800180 <cprintf>
  800704:	a001                	j	800704 <main+0x24>
  800706:	842a                	mv	s0,a0
  800708:	00000517          	auipc	a0,0x0
  80070c:	5e050513          	addi	a0,a0,1504 # 800ce8 <error_string+0x320>
  800710:	a71ff0ef          	jal	ra,800180 <cprintf>
  800714:	b7dff0ef          	jal	ra,800290 <yield>
  800718:	b79ff0ef          	jal	ra,800290 <yield>
  80071c:	b75ff0ef          	jal	ra,800290 <yield>
  800720:	00000517          	auipc	a0,0x0
  800724:	5f050513          	addi	a0,a0,1520 # 800d10 <error_string+0x348>
  800728:	a59ff0ef          	jal	ra,800180 <cprintf>
  80072c:	8522                	mv	a0,s0
  80072e:	b67ff0ef          	jal	ra,800294 <kill>
  800732:	ed31                	bnez	a0,80078e <main+0xae>
  800734:	4581                	li	a1,0
  800736:	00000517          	auipc	a0,0x0
  80073a:	64250513          	addi	a0,a0,1602 # 800d78 <error_string+0x3b0>
  80073e:	a43ff0ef          	jal	ra,800180 <cprintf>
  800742:	4581                	li	a1,0
  800744:	8522                	mv	a0,s0
  800746:	b47ff0ef          	jal	ra,80028c <waitpid>
  80074a:	e11d                	bnez	a0,800770 <main+0x90>
  80074c:	4581                	li	a1,0
  80074e:	00000517          	auipc	a0,0x0
  800752:	66250513          	addi	a0,a0,1634 # 800db0 <error_string+0x3e8>
  800756:	a2bff0ef          	jal	ra,800180 <cprintf>
  80075a:	00000517          	auipc	a0,0x0
  80075e:	66e50513          	addi	a0,a0,1646 # 800dc8 <error_string+0x400>
  800762:	a1fff0ef          	jal	ra,800180 <cprintf>
  800766:	60a2                	ld	ra,8(sp)
  800768:	6402                	ld	s0,0(sp)
  80076a:	4501                	li	a0,0
  80076c:	0141                	addi	sp,sp,16
  80076e:	8082                	ret
  800770:	00000697          	auipc	a3,0x0
  800774:	62068693          	addi	a3,a3,1568 # 800d90 <error_string+0x3c8>
  800778:	00000617          	auipc	a2,0x0
  80077c:	5d860613          	addi	a2,a2,1496 # 800d50 <error_string+0x388>
  800780:	45dd                	li	a1,23
  800782:	00000517          	auipc	a0,0x0
  800786:	5e650513          	addi	a0,a0,1510 # 800d68 <error_string+0x3a0>
  80078a:	897ff0ef          	jal	ra,800020 <__panic>
  80078e:	00000697          	auipc	a3,0x0
  800792:	5aa68693          	addi	a3,a3,1450 # 800d38 <error_string+0x370>
  800796:	00000617          	auipc	a2,0x0
  80079a:	5ba60613          	addi	a2,a2,1466 # 800d50 <error_string+0x388>
  80079e:	45d1                	li	a1,20
  8007a0:	00000517          	auipc	a0,0x0
  8007a4:	5c850513          	addi	a0,a0,1480 # 800d68 <error_string+0x3a0>
  8007a8:	879ff0ef          	jal	ra,800020 <__panic>
