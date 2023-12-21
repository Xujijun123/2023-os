
obj/__user_forktest.out：     文件格式 elf64-littleriscv


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
  800032:	74a50513          	addi	a0,a0,1866 # 800778 <main+0xaa>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	130000ef          	jal	ra,800172 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	102000ef          	jal	ra,80014c <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	78a50513          	addi	a0,a0,1930 # 8007d8 <main+0x10a>
  800056:	11c000ef          	jal	ra,800172 <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	208000ef          	jal	ra,800264 <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00000517          	auipc	a0,0x0
  800072:	72a50513          	addi	a0,a0,1834 # 800798 <main+0xca>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	0f0000ef          	jal	ra,800172 <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	0c2000ef          	jal	ra,80014c <vcprintf>
  80008e:	00000517          	auipc	a0,0x0
  800092:	74a50513          	addi	a0,a0,1866 # 8007d8 <main+0x10a>
  800096:	0dc000ef          	jal	ra,800172 <cprintf>
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

00000000008000f2 <sys_putc>:
  8000f2:	85aa                	mv	a1,a0
  8000f4:	4579                	li	a0,30
  8000f6:	fadff06f          	j	8000a2 <syscall>

00000000008000fa <sys_open>:
  8000fa:	862e                	mv	a2,a1
  8000fc:	85aa                	mv	a1,a0
  8000fe:	06400513          	li	a0,100
  800102:	fa1ff06f          	j	8000a2 <syscall>

0000000000800106 <sys_close>:
  800106:	85aa                	mv	a1,a0
  800108:	06500513          	li	a0,101
  80010c:	f97ff06f          	j	8000a2 <syscall>

0000000000800110 <sys_dup>:
  800110:	862e                	mv	a2,a1
  800112:	85aa                	mv	a1,a0
  800114:	08200513          	li	a0,130
  800118:	f8bff06f          	j	8000a2 <syscall>

000000000080011c <_start>:
  80011c:	0d4000ef          	jal	ra,8001f0 <umain>
  800120:	a001                	j	800120 <_start+0x4>

0000000000800122 <open>:
  800122:	1582                	slli	a1,a1,0x20
  800124:	9181                	srli	a1,a1,0x20
  800126:	fd5ff06f          	j	8000fa <sys_open>

000000000080012a <close>:
  80012a:	fddff06f          	j	800106 <sys_close>

000000000080012e <dup2>:
  80012e:	fe3ff06f          	j	800110 <sys_dup>

0000000000800132 <cputch>:
  800132:	1141                	addi	sp,sp,-16
  800134:	e022                	sd	s0,0(sp)
  800136:	e406                	sd	ra,8(sp)
  800138:	842e                	mv	s0,a1
  80013a:	fb9ff0ef          	jal	ra,8000f2 <sys_putc>
  80013e:	401c                	lw	a5,0(s0)
  800140:	60a2                	ld	ra,8(sp)
  800142:	2785                	addiw	a5,a5,1
  800144:	c01c                	sw	a5,0(s0)
  800146:	6402                	ld	s0,0(sp)
  800148:	0141                	addi	sp,sp,16
  80014a:	8082                	ret

000000000080014c <vcprintf>:
  80014c:	1101                	addi	sp,sp,-32
  80014e:	872e                	mv	a4,a1
  800150:	75dd                	lui	a1,0xffff7
  800152:	86aa                	mv	a3,a0
  800154:	0070                	addi	a2,sp,12
  800156:	00000517          	auipc	a0,0x0
  80015a:	fdc50513          	addi	a0,a0,-36 # 800132 <cputch>
  80015e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6149>
  800162:	ec06                	sd	ra,24(sp)
  800164:	c602                	sw	zero,12(sp)
  800166:	1bc000ef          	jal	ra,800322 <vprintfmt>
  80016a:	60e2                	ld	ra,24(sp)
  80016c:	4532                	lw	a0,12(sp)
  80016e:	6105                	addi	sp,sp,32
  800170:	8082                	ret

0000000000800172 <cprintf>:
  800172:	711d                	addi	sp,sp,-96
  800174:	02810313          	addi	t1,sp,40
  800178:	f42e                	sd	a1,40(sp)
  80017a:	75dd                	lui	a1,0xffff7
  80017c:	f832                	sd	a2,48(sp)
  80017e:	fc36                	sd	a3,56(sp)
  800180:	e0ba                	sd	a4,64(sp)
  800182:	86aa                	mv	a3,a0
  800184:	0050                	addi	a2,sp,4
  800186:	00000517          	auipc	a0,0x0
  80018a:	fac50513          	addi	a0,a0,-84 # 800132 <cputch>
  80018e:	871a                	mv	a4,t1
  800190:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6149>
  800194:	ec06                	sd	ra,24(sp)
  800196:	e4be                	sd	a5,72(sp)
  800198:	e8c2                	sd	a6,80(sp)
  80019a:	ecc6                	sd	a7,88(sp)
  80019c:	e41a                	sd	t1,8(sp)
  80019e:	c202                	sw	zero,4(sp)
  8001a0:	182000ef          	jal	ra,800322 <vprintfmt>
  8001a4:	60e2                	ld	ra,24(sp)
  8001a6:	4512                	lw	a0,4(sp)
  8001a8:	6125                	addi	sp,sp,96
  8001aa:	8082                	ret

00000000008001ac <initfd>:
  8001ac:	1101                	addi	sp,sp,-32
  8001ae:	87ae                	mv	a5,a1
  8001b0:	e426                	sd	s1,8(sp)
  8001b2:	85b2                	mv	a1,a2
  8001b4:	84aa                	mv	s1,a0
  8001b6:	853e                	mv	a0,a5
  8001b8:	e822                	sd	s0,16(sp)
  8001ba:	ec06                	sd	ra,24(sp)
  8001bc:	f67ff0ef          	jal	ra,800122 <open>
  8001c0:	842a                	mv	s0,a0
  8001c2:	00054463          	bltz	a0,8001ca <initfd+0x1e>
  8001c6:	00951863          	bne	a0,s1,8001d6 <initfd+0x2a>
  8001ca:	8522                	mv	a0,s0
  8001cc:	60e2                	ld	ra,24(sp)
  8001ce:	6442                	ld	s0,16(sp)
  8001d0:	64a2                	ld	s1,8(sp)
  8001d2:	6105                	addi	sp,sp,32
  8001d4:	8082                	ret
  8001d6:	8526                	mv	a0,s1
  8001d8:	f53ff0ef          	jal	ra,80012a <close>
  8001dc:	85a6                	mv	a1,s1
  8001de:	8522                	mv	a0,s0
  8001e0:	f4fff0ef          	jal	ra,80012e <dup2>
  8001e4:	84aa                	mv	s1,a0
  8001e6:	8522                	mv	a0,s0
  8001e8:	f43ff0ef          	jal	ra,80012a <close>
  8001ec:	8426                	mv	s0,s1
  8001ee:	bff1                	j	8001ca <initfd+0x1e>

00000000008001f0 <umain>:
  8001f0:	1101                	addi	sp,sp,-32
  8001f2:	e822                	sd	s0,16(sp)
  8001f4:	e426                	sd	s1,8(sp)
  8001f6:	842a                	mv	s0,a0
  8001f8:	84ae                	mv	s1,a1
  8001fa:	4601                	li	a2,0
  8001fc:	00000597          	auipc	a1,0x0
  800200:	5bc58593          	addi	a1,a1,1468 # 8007b8 <main+0xea>
  800204:	4501                	li	a0,0
  800206:	ec06                	sd	ra,24(sp)
  800208:	fa5ff0ef          	jal	ra,8001ac <initfd>
  80020c:	02054263          	bltz	a0,800230 <umain+0x40>
  800210:	4605                	li	a2,1
  800212:	00000597          	auipc	a1,0x0
  800216:	5e658593          	addi	a1,a1,1510 # 8007f8 <main+0x12a>
  80021a:	4505                	li	a0,1
  80021c:	f91ff0ef          	jal	ra,8001ac <initfd>
  800220:	02054563          	bltz	a0,80024a <umain+0x5a>
  800224:	85a6                	mv	a1,s1
  800226:	8522                	mv	a0,s0
  800228:	4a6000ef          	jal	ra,8006ce <main>
  80022c:	038000ef          	jal	ra,800264 <exit>
  800230:	86aa                	mv	a3,a0
  800232:	00000617          	auipc	a2,0x0
  800236:	58e60613          	addi	a2,a2,1422 # 8007c0 <main+0xf2>
  80023a:	45e9                	li	a1,26
  80023c:	00000517          	auipc	a0,0x0
  800240:	5a450513          	addi	a0,a0,1444 # 8007e0 <main+0x112>
  800244:	e1dff0ef          	jal	ra,800060 <__warn>
  800248:	b7e1                	j	800210 <umain+0x20>
  80024a:	86aa                	mv	a3,a0
  80024c:	00000617          	auipc	a2,0x0
  800250:	5b460613          	addi	a2,a2,1460 # 800800 <main+0x132>
  800254:	45f5                	li	a1,29
  800256:	00000517          	auipc	a0,0x0
  80025a:	58a50513          	addi	a0,a0,1418 # 8007e0 <main+0x112>
  80025e:	e03ff0ef          	jal	ra,800060 <__warn>
  800262:	b7c9                	j	800224 <umain+0x34>

0000000000800264 <exit>:
  800264:	1141                	addi	sp,sp,-16
  800266:	e406                	sd	ra,8(sp)
  800268:	e73ff0ef          	jal	ra,8000da <sys_exit>
  80026c:	00000517          	auipc	a0,0x0
  800270:	5b450513          	addi	a0,a0,1460 # 800820 <main+0x152>
  800274:	effff0ef          	jal	ra,800172 <cprintf>
  800278:	a001                	j	800278 <exit+0x14>

000000000080027a <fork>:
  80027a:	e69ff06f          	j	8000e2 <sys_fork>

000000000080027e <wait>:
  80027e:	4581                	li	a1,0
  800280:	4501                	li	a0,0
  800282:	e67ff06f          	j	8000e8 <sys_wait>

0000000000800286 <strnlen>:
  800286:	c185                	beqz	a1,8002a6 <strnlen+0x20>
  800288:	00054783          	lbu	a5,0(a0)
  80028c:	cf89                	beqz	a5,8002a6 <strnlen+0x20>
  80028e:	4781                	li	a5,0
  800290:	a021                	j	800298 <strnlen+0x12>
  800292:	00074703          	lbu	a4,0(a4)
  800296:	c711                	beqz	a4,8002a2 <strnlen+0x1c>
  800298:	0785                	addi	a5,a5,1
  80029a:	00f50733          	add	a4,a0,a5
  80029e:	fef59ae3          	bne	a1,a5,800292 <strnlen+0xc>
  8002a2:	853e                	mv	a0,a5
  8002a4:	8082                	ret
  8002a6:	4781                	li	a5,0
  8002a8:	853e                	mv	a0,a5
  8002aa:	8082                	ret

00000000008002ac <printnum>:
  8002ac:	02071893          	slli	a7,a4,0x20
  8002b0:	7139                	addi	sp,sp,-64
  8002b2:	0208d893          	srli	a7,a7,0x20
  8002b6:	e456                	sd	s5,8(sp)
  8002b8:	0316fab3          	remu	s5,a3,a7
  8002bc:	f822                	sd	s0,48(sp)
  8002be:	f426                	sd	s1,40(sp)
  8002c0:	f04a                	sd	s2,32(sp)
  8002c2:	ec4e                	sd	s3,24(sp)
  8002c4:	fc06                	sd	ra,56(sp)
  8002c6:	e852                	sd	s4,16(sp)
  8002c8:	84aa                	mv	s1,a0
  8002ca:	89ae                	mv	s3,a1
  8002cc:	8932                	mv	s2,a2
  8002ce:	fff7841b          	addiw	s0,a5,-1
  8002d2:	2a81                	sext.w	s5,s5
  8002d4:	0516f163          	bleu	a7,a3,800316 <printnum+0x6a>
  8002d8:	8a42                	mv	s4,a6
  8002da:	00805863          	blez	s0,8002ea <printnum+0x3e>
  8002de:	347d                	addiw	s0,s0,-1
  8002e0:	864e                	mv	a2,s3
  8002e2:	85ca                	mv	a1,s2
  8002e4:	8552                	mv	a0,s4
  8002e6:	9482                	jalr	s1
  8002e8:	f87d                	bnez	s0,8002de <printnum+0x32>
  8002ea:	1a82                	slli	s5,s5,0x20
  8002ec:	020ada93          	srli	s5,s5,0x20
  8002f0:	00000797          	auipc	a5,0x0
  8002f4:	76878793          	addi	a5,a5,1896 # 800a58 <error_string+0xc8>
  8002f8:	9abe                	add	s5,s5,a5
  8002fa:	7442                	ld	s0,48(sp)
  8002fc:	000ac503          	lbu	a0,0(s5)
  800300:	70e2                	ld	ra,56(sp)
  800302:	6a42                	ld	s4,16(sp)
  800304:	6aa2                	ld	s5,8(sp)
  800306:	864e                	mv	a2,s3
  800308:	85ca                	mv	a1,s2
  80030a:	69e2                	ld	s3,24(sp)
  80030c:	7902                	ld	s2,32(sp)
  80030e:	8326                	mv	t1,s1
  800310:	74a2                	ld	s1,40(sp)
  800312:	6121                	addi	sp,sp,64
  800314:	8302                	jr	t1
  800316:	0316d6b3          	divu	a3,a3,a7
  80031a:	87a2                	mv	a5,s0
  80031c:	f91ff0ef          	jal	ra,8002ac <printnum>
  800320:	b7e9                	j	8002ea <printnum+0x3e>

0000000000800322 <vprintfmt>:
  800322:	7119                	addi	sp,sp,-128
  800324:	f4a6                	sd	s1,104(sp)
  800326:	f0ca                	sd	s2,96(sp)
  800328:	ecce                	sd	s3,88(sp)
  80032a:	e4d6                	sd	s5,72(sp)
  80032c:	e0da                	sd	s6,64(sp)
  80032e:	fc5e                	sd	s7,56(sp)
  800330:	f862                	sd	s8,48(sp)
  800332:	ec6e                	sd	s11,24(sp)
  800334:	fc86                	sd	ra,120(sp)
  800336:	f8a2                	sd	s0,112(sp)
  800338:	e8d2                	sd	s4,80(sp)
  80033a:	f466                	sd	s9,40(sp)
  80033c:	f06a                	sd	s10,32(sp)
  80033e:	89aa                	mv	s3,a0
  800340:	892e                	mv	s2,a1
  800342:	84b2                	mv	s1,a2
  800344:	8db6                	mv	s11,a3
  800346:	8b3a                	mv	s6,a4
  800348:	5bfd                	li	s7,-1
  80034a:	00000a97          	auipc	s5,0x0
  80034e:	4eaa8a93          	addi	s5,s5,1258 # 800834 <main+0x166>
  800352:	05e00c13          	li	s8,94
  800356:	000dc503          	lbu	a0,0(s11)
  80035a:	02500793          	li	a5,37
  80035e:	001d8413          	addi	s0,s11,1
  800362:	00f50f63          	beq	a0,a5,800380 <vprintfmt+0x5e>
  800366:	c529                	beqz	a0,8003b0 <vprintfmt+0x8e>
  800368:	02500a13          	li	s4,37
  80036c:	a011                	j	800370 <vprintfmt+0x4e>
  80036e:	c129                	beqz	a0,8003b0 <vprintfmt+0x8e>
  800370:	864a                	mv	a2,s2
  800372:	85a6                	mv	a1,s1
  800374:	0405                	addi	s0,s0,1
  800376:	9982                	jalr	s3
  800378:	fff44503          	lbu	a0,-1(s0)
  80037c:	ff4519e3          	bne	a0,s4,80036e <vprintfmt+0x4c>
  800380:	00044603          	lbu	a2,0(s0)
  800384:	02000813          	li	a6,32
  800388:	4a01                	li	s4,0
  80038a:	4881                	li	a7,0
  80038c:	5d7d                	li	s10,-1
  80038e:	5cfd                	li	s9,-1
  800390:	05500593          	li	a1,85
  800394:	4525                	li	a0,9
  800396:	fdd6071b          	addiw	a4,a2,-35
  80039a:	0ff77713          	andi	a4,a4,255
  80039e:	00140d93          	addi	s11,s0,1
  8003a2:	22e5e363          	bltu	a1,a4,8005c8 <vprintfmt+0x2a6>
  8003a6:	070a                	slli	a4,a4,0x2
  8003a8:	9756                	add	a4,a4,s5
  8003aa:	4318                	lw	a4,0(a4)
  8003ac:	9756                	add	a4,a4,s5
  8003ae:	8702                	jr	a4
  8003b0:	70e6                	ld	ra,120(sp)
  8003b2:	7446                	ld	s0,112(sp)
  8003b4:	74a6                	ld	s1,104(sp)
  8003b6:	7906                	ld	s2,96(sp)
  8003b8:	69e6                	ld	s3,88(sp)
  8003ba:	6a46                	ld	s4,80(sp)
  8003bc:	6aa6                	ld	s5,72(sp)
  8003be:	6b06                	ld	s6,64(sp)
  8003c0:	7be2                	ld	s7,56(sp)
  8003c2:	7c42                	ld	s8,48(sp)
  8003c4:	7ca2                	ld	s9,40(sp)
  8003c6:	7d02                	ld	s10,32(sp)
  8003c8:	6de2                	ld	s11,24(sp)
  8003ca:	6109                	addi	sp,sp,128
  8003cc:	8082                	ret
  8003ce:	4705                	li	a4,1
  8003d0:	008b0613          	addi	a2,s6,8
  8003d4:	01174463          	blt	a4,a7,8003dc <vprintfmt+0xba>
  8003d8:	28088563          	beqz	a7,800662 <vprintfmt+0x340>
  8003dc:	000b3683          	ld	a3,0(s6)
  8003e0:	4741                	li	a4,16
  8003e2:	8b32                	mv	s6,a2
  8003e4:	a86d                	j	80049e <vprintfmt+0x17c>
  8003e6:	00144603          	lbu	a2,1(s0)
  8003ea:	4a05                	li	s4,1
  8003ec:	846e                	mv	s0,s11
  8003ee:	b765                	j	800396 <vprintfmt+0x74>
  8003f0:	000b2503          	lw	a0,0(s6)
  8003f4:	864a                	mv	a2,s2
  8003f6:	85a6                	mv	a1,s1
  8003f8:	0b21                	addi	s6,s6,8
  8003fa:	9982                	jalr	s3
  8003fc:	bfa9                	j	800356 <vprintfmt+0x34>
  8003fe:	4705                	li	a4,1
  800400:	008b0a13          	addi	s4,s6,8
  800404:	01174463          	blt	a4,a7,80040c <vprintfmt+0xea>
  800408:	24088563          	beqz	a7,800652 <vprintfmt+0x330>
  80040c:	000b3403          	ld	s0,0(s6)
  800410:	26044563          	bltz	s0,80067a <vprintfmt+0x358>
  800414:	86a2                	mv	a3,s0
  800416:	8b52                	mv	s6,s4
  800418:	4729                	li	a4,10
  80041a:	a051                	j	80049e <vprintfmt+0x17c>
  80041c:	000b2783          	lw	a5,0(s6)
  800420:	46e1                	li	a3,24
  800422:	0b21                	addi	s6,s6,8
  800424:	41f7d71b          	sraiw	a4,a5,0x1f
  800428:	8fb9                	xor	a5,a5,a4
  80042a:	40e7873b          	subw	a4,a5,a4
  80042e:	1ce6c163          	blt	a3,a4,8005f0 <vprintfmt+0x2ce>
  800432:	00371793          	slli	a5,a4,0x3
  800436:	00000697          	auipc	a3,0x0
  80043a:	55a68693          	addi	a3,a3,1370 # 800990 <error_string>
  80043e:	97b6                	add	a5,a5,a3
  800440:	639c                	ld	a5,0(a5)
  800442:	1a078763          	beqz	a5,8005f0 <vprintfmt+0x2ce>
  800446:	873e                	mv	a4,a5
  800448:	00001697          	auipc	a3,0x1
  80044c:	81868693          	addi	a3,a3,-2024 # 800c60 <error_string+0x2d0>
  800450:	8626                	mv	a2,s1
  800452:	85ca                	mv	a1,s2
  800454:	854e                	mv	a0,s3
  800456:	25a000ef          	jal	ra,8006b0 <printfmt>
  80045a:	bdf5                	j	800356 <vprintfmt+0x34>
  80045c:	00144603          	lbu	a2,1(s0)
  800460:	2885                	addiw	a7,a7,1
  800462:	846e                	mv	s0,s11
  800464:	bf0d                	j	800396 <vprintfmt+0x74>
  800466:	4705                	li	a4,1
  800468:	008b0613          	addi	a2,s6,8
  80046c:	01174463          	blt	a4,a7,800474 <vprintfmt+0x152>
  800470:	1e088e63          	beqz	a7,80066c <vprintfmt+0x34a>
  800474:	000b3683          	ld	a3,0(s6)
  800478:	4721                	li	a4,8
  80047a:	8b32                	mv	s6,a2
  80047c:	a00d                	j	80049e <vprintfmt+0x17c>
  80047e:	03000513          	li	a0,48
  800482:	864a                	mv	a2,s2
  800484:	85a6                	mv	a1,s1
  800486:	e042                	sd	a6,0(sp)
  800488:	9982                	jalr	s3
  80048a:	864a                	mv	a2,s2
  80048c:	85a6                	mv	a1,s1
  80048e:	07800513          	li	a0,120
  800492:	9982                	jalr	s3
  800494:	0b21                	addi	s6,s6,8
  800496:	ff8b3683          	ld	a3,-8(s6)
  80049a:	6802                	ld	a6,0(sp)
  80049c:	4741                	li	a4,16
  80049e:	87e6                	mv	a5,s9
  8004a0:	8626                	mv	a2,s1
  8004a2:	85ca                	mv	a1,s2
  8004a4:	854e                	mv	a0,s3
  8004a6:	e07ff0ef          	jal	ra,8002ac <printnum>
  8004aa:	b575                	j	800356 <vprintfmt+0x34>
  8004ac:	000b3703          	ld	a4,0(s6)
  8004b0:	0b21                	addi	s6,s6,8
  8004b2:	1e070063          	beqz	a4,800692 <vprintfmt+0x370>
  8004b6:	00170413          	addi	s0,a4,1
  8004ba:	19905563          	blez	s9,800644 <vprintfmt+0x322>
  8004be:	02d00613          	li	a2,45
  8004c2:	14c81963          	bne	a6,a2,800614 <vprintfmt+0x2f2>
  8004c6:	00074703          	lbu	a4,0(a4)
  8004ca:	0007051b          	sext.w	a0,a4
  8004ce:	c90d                	beqz	a0,800500 <vprintfmt+0x1de>
  8004d0:	000d4563          	bltz	s10,8004da <vprintfmt+0x1b8>
  8004d4:	3d7d                	addiw	s10,s10,-1
  8004d6:	037d0363          	beq	s10,s7,8004fc <vprintfmt+0x1da>
  8004da:	864a                	mv	a2,s2
  8004dc:	85a6                	mv	a1,s1
  8004de:	180a0c63          	beqz	s4,800676 <vprintfmt+0x354>
  8004e2:	3701                	addiw	a4,a4,-32
  8004e4:	18ec7963          	bleu	a4,s8,800676 <vprintfmt+0x354>
  8004e8:	03f00513          	li	a0,63
  8004ec:	9982                	jalr	s3
  8004ee:	0405                	addi	s0,s0,1
  8004f0:	fff44703          	lbu	a4,-1(s0)
  8004f4:	3cfd                	addiw	s9,s9,-1
  8004f6:	0007051b          	sext.w	a0,a4
  8004fa:	f979                	bnez	a0,8004d0 <vprintfmt+0x1ae>
  8004fc:	e5905de3          	blez	s9,800356 <vprintfmt+0x34>
  800500:	3cfd                	addiw	s9,s9,-1
  800502:	864a                	mv	a2,s2
  800504:	85a6                	mv	a1,s1
  800506:	02000513          	li	a0,32
  80050a:	9982                	jalr	s3
  80050c:	e40c85e3          	beqz	s9,800356 <vprintfmt+0x34>
  800510:	3cfd                	addiw	s9,s9,-1
  800512:	864a                	mv	a2,s2
  800514:	85a6                	mv	a1,s1
  800516:	02000513          	li	a0,32
  80051a:	9982                	jalr	s3
  80051c:	fe0c92e3          	bnez	s9,800500 <vprintfmt+0x1de>
  800520:	bd1d                	j	800356 <vprintfmt+0x34>
  800522:	4705                	li	a4,1
  800524:	008b0613          	addi	a2,s6,8
  800528:	01174463          	blt	a4,a7,800530 <vprintfmt+0x20e>
  80052c:	12088663          	beqz	a7,800658 <vprintfmt+0x336>
  800530:	000b3683          	ld	a3,0(s6)
  800534:	4729                	li	a4,10
  800536:	8b32                	mv	s6,a2
  800538:	b79d                	j	80049e <vprintfmt+0x17c>
  80053a:	00144603          	lbu	a2,1(s0)
  80053e:	02d00813          	li	a6,45
  800542:	846e                	mv	s0,s11
  800544:	bd89                	j	800396 <vprintfmt+0x74>
  800546:	864a                	mv	a2,s2
  800548:	85a6                	mv	a1,s1
  80054a:	02500513          	li	a0,37
  80054e:	9982                	jalr	s3
  800550:	b519                	j	800356 <vprintfmt+0x34>
  800552:	000b2d03          	lw	s10,0(s6)
  800556:	00144603          	lbu	a2,1(s0)
  80055a:	0b21                	addi	s6,s6,8
  80055c:	846e                	mv	s0,s11
  80055e:	e20cdce3          	bgez	s9,800396 <vprintfmt+0x74>
  800562:	8cea                	mv	s9,s10
  800564:	5d7d                	li	s10,-1
  800566:	bd05                	j	800396 <vprintfmt+0x74>
  800568:	00144603          	lbu	a2,1(s0)
  80056c:	03000813          	li	a6,48
  800570:	846e                	mv	s0,s11
  800572:	b515                	j	800396 <vprintfmt+0x74>
  800574:	fd060d1b          	addiw	s10,a2,-48
  800578:	00144603          	lbu	a2,1(s0)
  80057c:	846e                	mv	s0,s11
  80057e:	fd06071b          	addiw	a4,a2,-48
  800582:	0006031b          	sext.w	t1,a2
  800586:	fce56ce3          	bltu	a0,a4,80055e <vprintfmt+0x23c>
  80058a:	0405                	addi	s0,s0,1
  80058c:	002d171b          	slliw	a4,s10,0x2
  800590:	00044603          	lbu	a2,0(s0)
  800594:	01a706bb          	addw	a3,a4,s10
  800598:	0016969b          	slliw	a3,a3,0x1
  80059c:	006686bb          	addw	a3,a3,t1
  8005a0:	fd06071b          	addiw	a4,a2,-48
  8005a4:	fd068d1b          	addiw	s10,a3,-48
  8005a8:	0006031b          	sext.w	t1,a2
  8005ac:	fce57fe3          	bleu	a4,a0,80058a <vprintfmt+0x268>
  8005b0:	b77d                	j	80055e <vprintfmt+0x23c>
  8005b2:	fffcc713          	not	a4,s9
  8005b6:	977d                	srai	a4,a4,0x3f
  8005b8:	00ecf7b3          	and	a5,s9,a4
  8005bc:	00144603          	lbu	a2,1(s0)
  8005c0:	00078c9b          	sext.w	s9,a5
  8005c4:	846e                	mv	s0,s11
  8005c6:	bbc1                	j	800396 <vprintfmt+0x74>
  8005c8:	864a                	mv	a2,s2
  8005ca:	85a6                	mv	a1,s1
  8005cc:	02500513          	li	a0,37
  8005d0:	9982                	jalr	s3
  8005d2:	fff44703          	lbu	a4,-1(s0)
  8005d6:	02500793          	li	a5,37
  8005da:	8da2                	mv	s11,s0
  8005dc:	d6f70de3          	beq	a4,a5,800356 <vprintfmt+0x34>
  8005e0:	02500713          	li	a4,37
  8005e4:	1dfd                	addi	s11,s11,-1
  8005e6:	fffdc783          	lbu	a5,-1(s11)
  8005ea:	fee79de3          	bne	a5,a4,8005e4 <vprintfmt+0x2c2>
  8005ee:	b3a5                	j	800356 <vprintfmt+0x34>
  8005f0:	00000697          	auipc	a3,0x0
  8005f4:	66068693          	addi	a3,a3,1632 # 800c50 <error_string+0x2c0>
  8005f8:	8626                	mv	a2,s1
  8005fa:	85ca                	mv	a1,s2
  8005fc:	854e                	mv	a0,s3
  8005fe:	0b2000ef          	jal	ra,8006b0 <printfmt>
  800602:	bb91                	j	800356 <vprintfmt+0x34>
  800604:	00000717          	auipc	a4,0x0
  800608:	64470713          	addi	a4,a4,1604 # 800c48 <error_string+0x2b8>
  80060c:	00000417          	auipc	s0,0x0
  800610:	63d40413          	addi	s0,s0,1597 # 800c49 <error_string+0x2b9>
  800614:	853a                	mv	a0,a4
  800616:	85ea                	mv	a1,s10
  800618:	e03a                	sd	a4,0(sp)
  80061a:	e442                	sd	a6,8(sp)
  80061c:	c6bff0ef          	jal	ra,800286 <strnlen>
  800620:	40ac8cbb          	subw	s9,s9,a0
  800624:	6702                	ld	a4,0(sp)
  800626:	01905f63          	blez	s9,800644 <vprintfmt+0x322>
  80062a:	6822                	ld	a6,8(sp)
  80062c:	0008079b          	sext.w	a5,a6
  800630:	e43e                	sd	a5,8(sp)
  800632:	6522                	ld	a0,8(sp)
  800634:	864a                	mv	a2,s2
  800636:	85a6                	mv	a1,s1
  800638:	e03a                	sd	a4,0(sp)
  80063a:	3cfd                	addiw	s9,s9,-1
  80063c:	9982                	jalr	s3
  80063e:	6702                	ld	a4,0(sp)
  800640:	fe0c99e3          	bnez	s9,800632 <vprintfmt+0x310>
  800644:	00074703          	lbu	a4,0(a4)
  800648:	0007051b          	sext.w	a0,a4
  80064c:	e80512e3          	bnez	a0,8004d0 <vprintfmt+0x1ae>
  800650:	b319                	j	800356 <vprintfmt+0x34>
  800652:	000b2403          	lw	s0,0(s6)
  800656:	bb6d                	j	800410 <vprintfmt+0xee>
  800658:	000b6683          	lwu	a3,0(s6)
  80065c:	4729                	li	a4,10
  80065e:	8b32                	mv	s6,a2
  800660:	bd3d                	j	80049e <vprintfmt+0x17c>
  800662:	000b6683          	lwu	a3,0(s6)
  800666:	4741                	li	a4,16
  800668:	8b32                	mv	s6,a2
  80066a:	bd15                	j	80049e <vprintfmt+0x17c>
  80066c:	000b6683          	lwu	a3,0(s6)
  800670:	4721                	li	a4,8
  800672:	8b32                	mv	s6,a2
  800674:	b52d                	j	80049e <vprintfmt+0x17c>
  800676:	9982                	jalr	s3
  800678:	bd9d                	j	8004ee <vprintfmt+0x1cc>
  80067a:	864a                	mv	a2,s2
  80067c:	85a6                	mv	a1,s1
  80067e:	02d00513          	li	a0,45
  800682:	e042                	sd	a6,0(sp)
  800684:	9982                	jalr	s3
  800686:	8b52                	mv	s6,s4
  800688:	408006b3          	neg	a3,s0
  80068c:	4729                	li	a4,10
  80068e:	6802                	ld	a6,0(sp)
  800690:	b539                	j	80049e <vprintfmt+0x17c>
  800692:	01905663          	blez	s9,80069e <vprintfmt+0x37c>
  800696:	02d00713          	li	a4,45
  80069a:	f6e815e3          	bne	a6,a4,800604 <vprintfmt+0x2e2>
  80069e:	00000417          	auipc	s0,0x0
  8006a2:	5ab40413          	addi	s0,s0,1451 # 800c49 <error_string+0x2b9>
  8006a6:	02800513          	li	a0,40
  8006aa:	02800713          	li	a4,40
  8006ae:	b50d                	j	8004d0 <vprintfmt+0x1ae>

00000000008006b0 <printfmt>:
  8006b0:	7139                	addi	sp,sp,-64
  8006b2:	02010313          	addi	t1,sp,32
  8006b6:	f03a                	sd	a4,32(sp)
  8006b8:	871a                	mv	a4,t1
  8006ba:	ec06                	sd	ra,24(sp)
  8006bc:	f43e                	sd	a5,40(sp)
  8006be:	f842                	sd	a6,48(sp)
  8006c0:	fc46                	sd	a7,56(sp)
  8006c2:	e41a                	sd	t1,8(sp)
  8006c4:	c5fff0ef          	jal	ra,800322 <vprintfmt>
  8006c8:	60e2                	ld	ra,24(sp)
  8006ca:	6121                	addi	sp,sp,64
  8006cc:	8082                	ret

00000000008006ce <main>:
  8006ce:	1101                	addi	sp,sp,-32
  8006d0:	e822                	sd	s0,16(sp)
  8006d2:	e426                	sd	s1,8(sp)
  8006d4:	ec06                	sd	ra,24(sp)
  8006d6:	4401                	li	s0,0
  8006d8:	02000493          	li	s1,32
  8006dc:	b9fff0ef          	jal	ra,80027a <fork>
  8006e0:	cd05                	beqz	a0,800718 <main+0x4a>
  8006e2:	06a05063          	blez	a0,800742 <main+0x74>
  8006e6:	2405                	addiw	s0,s0,1
  8006e8:	fe941ae3          	bne	s0,s1,8006dc <main+0xe>
  8006ec:	02000413          	li	s0,32
  8006f0:	b8fff0ef          	jal	ra,80027e <wait>
  8006f4:	ed05                	bnez	a0,80072c <main+0x5e>
  8006f6:	347d                	addiw	s0,s0,-1
  8006f8:	fc65                	bnez	s0,8006f0 <main+0x22>
  8006fa:	b85ff0ef          	jal	ra,80027e <wait>
  8006fe:	c12d                	beqz	a0,800760 <main+0x92>
  800700:	00000517          	auipc	a0,0x0
  800704:	5d850513          	addi	a0,a0,1496 # 800cd8 <error_string+0x348>
  800708:	a6bff0ef          	jal	ra,800172 <cprintf>
  80070c:	60e2                	ld	ra,24(sp)
  80070e:	6442                	ld	s0,16(sp)
  800710:	64a2                	ld	s1,8(sp)
  800712:	4501                	li	a0,0
  800714:	6105                	addi	sp,sp,32
  800716:	8082                	ret
  800718:	85a2                	mv	a1,s0
  80071a:	00000517          	auipc	a0,0x0
  80071e:	54e50513          	addi	a0,a0,1358 # 800c68 <error_string+0x2d8>
  800722:	a51ff0ef          	jal	ra,800172 <cprintf>
  800726:	4501                	li	a0,0
  800728:	b3dff0ef          	jal	ra,800264 <exit>
  80072c:	00000617          	auipc	a2,0x0
  800730:	57c60613          	addi	a2,a2,1404 # 800ca8 <error_string+0x318>
  800734:	45dd                	li	a1,23
  800736:	00000517          	auipc	a0,0x0
  80073a:	56250513          	addi	a0,a0,1378 # 800c98 <error_string+0x308>
  80073e:	8e3ff0ef          	jal	ra,800020 <__panic>
  800742:	00000697          	auipc	a3,0x0
  800746:	53668693          	addi	a3,a3,1334 # 800c78 <error_string+0x2e8>
  80074a:	00000617          	auipc	a2,0x0
  80074e:	53660613          	addi	a2,a2,1334 # 800c80 <error_string+0x2f0>
  800752:	45b9                	li	a1,14
  800754:	00000517          	auipc	a0,0x0
  800758:	54450513          	addi	a0,a0,1348 # 800c98 <error_string+0x308>
  80075c:	8c5ff0ef          	jal	ra,800020 <__panic>
  800760:	00000617          	auipc	a2,0x0
  800764:	56060613          	addi	a2,a2,1376 # 800cc0 <error_string+0x330>
  800768:	45f1                	li	a1,28
  80076a:	00000517          	auipc	a0,0x0
  80076e:	52e50513          	addi	a0,a0,1326 # 800c98 <error_string+0x308>
  800772:	8afff0ef          	jal	ra,800020 <__panic>
