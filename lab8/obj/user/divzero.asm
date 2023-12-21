
obj/__user_divzero.out：     文件格式 elf64-littleriscv


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
  800032:	6ba50513          	addi	a0,a0,1722 # 8006e8 <main+0x36>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	120000ef          	jal	ra,800162 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	0f2000ef          	jal	ra,80013c <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	6fa50513          	addi	a0,a0,1786 # 800748 <main+0x96>
  800056:	10c000ef          	jal	ra,800162 <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	1f8000ef          	jal	ra,800254 <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00000517          	auipc	a0,0x0
  800072:	69a50513          	addi	a0,a0,1690 # 800708 <main+0x56>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	0e0000ef          	jal	ra,800162 <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	0b2000ef          	jal	ra,80013c <vcprintf>
  80008e:	00000517          	auipc	a0,0x0
  800092:	6ba50513          	addi	a0,a0,1722 # 800748 <main+0x96>
  800096:	0cc000ef          	jal	ra,800162 <cprintf>
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

00000000008000e2 <sys_putc>:
  8000e2:	85aa                	mv	a1,a0
  8000e4:	4579                	li	a0,30
  8000e6:	fbdff06f          	j	8000a2 <syscall>

00000000008000ea <sys_open>:
  8000ea:	862e                	mv	a2,a1
  8000ec:	85aa                	mv	a1,a0
  8000ee:	06400513          	li	a0,100
  8000f2:	fb1ff06f          	j	8000a2 <syscall>

00000000008000f6 <sys_close>:
  8000f6:	85aa                	mv	a1,a0
  8000f8:	06500513          	li	a0,101
  8000fc:	fa7ff06f          	j	8000a2 <syscall>

0000000000800100 <sys_dup>:
  800100:	862e                	mv	a2,a1
  800102:	85aa                	mv	a1,a0
  800104:	08200513          	li	a0,130
  800108:	f9bff06f          	j	8000a2 <syscall>

000000000080010c <_start>:
  80010c:	0d4000ef          	jal	ra,8001e0 <umain>
  800110:	a001                	j	800110 <_start+0x4>

0000000000800112 <open>:
  800112:	1582                	slli	a1,a1,0x20
  800114:	9181                	srli	a1,a1,0x20
  800116:	fd5ff06f          	j	8000ea <sys_open>

000000000080011a <close>:
  80011a:	fddff06f          	j	8000f6 <sys_close>

000000000080011e <dup2>:
  80011e:	fe3ff06f          	j	800100 <sys_dup>

0000000000800122 <cputch>:
  800122:	1141                	addi	sp,sp,-16
  800124:	e022                	sd	s0,0(sp)
  800126:	e406                	sd	ra,8(sp)
  800128:	842e                	mv	s0,a1
  80012a:	fb9ff0ef          	jal	ra,8000e2 <sys_putc>
  80012e:	401c                	lw	a5,0(s0)
  800130:	60a2                	ld	ra,8(sp)
  800132:	2785                	addiw	a5,a5,1
  800134:	c01c                	sw	a5,0(s0)
  800136:	6402                	ld	s0,0(sp)
  800138:	0141                	addi	sp,sp,16
  80013a:	8082                	ret

000000000080013c <vcprintf>:
  80013c:	1101                	addi	sp,sp,-32
  80013e:	872e                	mv	a4,a1
  800140:	75dd                	lui	a1,0xffff7
  800142:	86aa                	mv	a3,a0
  800144:	0070                	addi	a2,sp,12
  800146:	00000517          	auipc	a0,0x0
  80014a:	fdc50513          	addi	a0,a0,-36 # 800122 <cputch>
  80014e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <zero+0xffffffffff7f5ad9>
  800152:	ec06                	sd	ra,24(sp)
  800154:	c602                	sw	zero,12(sp)
  800156:	1b0000ef          	jal	ra,800306 <vprintfmt>
  80015a:	60e2                	ld	ra,24(sp)
  80015c:	4532                	lw	a0,12(sp)
  80015e:	6105                	addi	sp,sp,32
  800160:	8082                	ret

0000000000800162 <cprintf>:
  800162:	711d                	addi	sp,sp,-96
  800164:	02810313          	addi	t1,sp,40
  800168:	f42e                	sd	a1,40(sp)
  80016a:	75dd                	lui	a1,0xffff7
  80016c:	f832                	sd	a2,48(sp)
  80016e:	fc36                	sd	a3,56(sp)
  800170:	e0ba                	sd	a4,64(sp)
  800172:	86aa                	mv	a3,a0
  800174:	0050                	addi	a2,sp,4
  800176:	00000517          	auipc	a0,0x0
  80017a:	fac50513          	addi	a0,a0,-84 # 800122 <cputch>
  80017e:	871a                	mv	a4,t1
  800180:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <zero+0xffffffffff7f5ad9>
  800184:	ec06                	sd	ra,24(sp)
  800186:	e4be                	sd	a5,72(sp)
  800188:	e8c2                	sd	a6,80(sp)
  80018a:	ecc6                	sd	a7,88(sp)
  80018c:	e41a                	sd	t1,8(sp)
  80018e:	c202                	sw	zero,4(sp)
  800190:	176000ef          	jal	ra,800306 <vprintfmt>
  800194:	60e2                	ld	ra,24(sp)
  800196:	4512                	lw	a0,4(sp)
  800198:	6125                	addi	sp,sp,96
  80019a:	8082                	ret

000000000080019c <initfd>:
  80019c:	1101                	addi	sp,sp,-32
  80019e:	87ae                	mv	a5,a1
  8001a0:	e426                	sd	s1,8(sp)
  8001a2:	85b2                	mv	a1,a2
  8001a4:	84aa                	mv	s1,a0
  8001a6:	853e                	mv	a0,a5
  8001a8:	e822                	sd	s0,16(sp)
  8001aa:	ec06                	sd	ra,24(sp)
  8001ac:	f67ff0ef          	jal	ra,800112 <open>
  8001b0:	842a                	mv	s0,a0
  8001b2:	00054463          	bltz	a0,8001ba <initfd+0x1e>
  8001b6:	00951863          	bne	a0,s1,8001c6 <initfd+0x2a>
  8001ba:	8522                	mv	a0,s0
  8001bc:	60e2                	ld	ra,24(sp)
  8001be:	6442                	ld	s0,16(sp)
  8001c0:	64a2                	ld	s1,8(sp)
  8001c2:	6105                	addi	sp,sp,32
  8001c4:	8082                	ret
  8001c6:	8526                	mv	a0,s1
  8001c8:	f53ff0ef          	jal	ra,80011a <close>
  8001cc:	85a6                	mv	a1,s1
  8001ce:	8522                	mv	a0,s0
  8001d0:	f4fff0ef          	jal	ra,80011e <dup2>
  8001d4:	84aa                	mv	s1,a0
  8001d6:	8522                	mv	a0,s0
  8001d8:	f43ff0ef          	jal	ra,80011a <close>
  8001dc:	8426                	mv	s0,s1
  8001de:	bff1                	j	8001ba <initfd+0x1e>

00000000008001e0 <umain>:
  8001e0:	1101                	addi	sp,sp,-32
  8001e2:	e822                	sd	s0,16(sp)
  8001e4:	e426                	sd	s1,8(sp)
  8001e6:	842a                	mv	s0,a0
  8001e8:	84ae                	mv	s1,a1
  8001ea:	4601                	li	a2,0
  8001ec:	00000597          	auipc	a1,0x0
  8001f0:	53c58593          	addi	a1,a1,1340 # 800728 <main+0x76>
  8001f4:	4501                	li	a0,0
  8001f6:	ec06                	sd	ra,24(sp)
  8001f8:	fa5ff0ef          	jal	ra,80019c <initfd>
  8001fc:	02054263          	bltz	a0,800220 <umain+0x40>
  800200:	4605                	li	a2,1
  800202:	00000597          	auipc	a1,0x0
  800206:	56658593          	addi	a1,a1,1382 # 800768 <main+0xb6>
  80020a:	4505                	li	a0,1
  80020c:	f91ff0ef          	jal	ra,80019c <initfd>
  800210:	02054563          	bltz	a0,80023a <umain+0x5a>
  800214:	85a6                	mv	a1,s1
  800216:	8522                	mv	a0,s0
  800218:	49a000ef          	jal	ra,8006b2 <main>
  80021c:	038000ef          	jal	ra,800254 <exit>
  800220:	86aa                	mv	a3,a0
  800222:	00000617          	auipc	a2,0x0
  800226:	50e60613          	addi	a2,a2,1294 # 800730 <main+0x7e>
  80022a:	45e9                	li	a1,26
  80022c:	00000517          	auipc	a0,0x0
  800230:	52450513          	addi	a0,a0,1316 # 800750 <main+0x9e>
  800234:	e2dff0ef          	jal	ra,800060 <__warn>
  800238:	b7e1                	j	800200 <umain+0x20>
  80023a:	86aa                	mv	a3,a0
  80023c:	00000617          	auipc	a2,0x0
  800240:	53460613          	addi	a2,a2,1332 # 800770 <main+0xbe>
  800244:	45f5                	li	a1,29
  800246:	00000517          	auipc	a0,0x0
  80024a:	50a50513          	addi	a0,a0,1290 # 800750 <main+0x9e>
  80024e:	e13ff0ef          	jal	ra,800060 <__warn>
  800252:	b7c9                	j	800214 <umain+0x34>

0000000000800254 <exit>:
  800254:	1141                	addi	sp,sp,-16
  800256:	e406                	sd	ra,8(sp)
  800258:	e83ff0ef          	jal	ra,8000da <sys_exit>
  80025c:	00000517          	auipc	a0,0x0
  800260:	53450513          	addi	a0,a0,1332 # 800790 <main+0xde>
  800264:	effff0ef          	jal	ra,800162 <cprintf>
  800268:	a001                	j	800268 <exit+0x14>

000000000080026a <strnlen>:
  80026a:	c185                	beqz	a1,80028a <strnlen+0x20>
  80026c:	00054783          	lbu	a5,0(a0)
  800270:	cf89                	beqz	a5,80028a <strnlen+0x20>
  800272:	4781                	li	a5,0
  800274:	a021                	j	80027c <strnlen+0x12>
  800276:	00074703          	lbu	a4,0(a4)
  80027a:	c711                	beqz	a4,800286 <strnlen+0x1c>
  80027c:	0785                	addi	a5,a5,1
  80027e:	00f50733          	add	a4,a0,a5
  800282:	fef59ae3          	bne	a1,a5,800276 <strnlen+0xc>
  800286:	853e                	mv	a0,a5
  800288:	8082                	ret
  80028a:	4781                	li	a5,0
  80028c:	853e                	mv	a0,a5
  80028e:	8082                	ret

0000000000800290 <printnum>:
  800290:	02071893          	slli	a7,a4,0x20
  800294:	7139                	addi	sp,sp,-64
  800296:	0208d893          	srli	a7,a7,0x20
  80029a:	e456                	sd	s5,8(sp)
  80029c:	0316fab3          	remu	s5,a3,a7
  8002a0:	f822                	sd	s0,48(sp)
  8002a2:	f426                	sd	s1,40(sp)
  8002a4:	f04a                	sd	s2,32(sp)
  8002a6:	ec4e                	sd	s3,24(sp)
  8002a8:	fc06                	sd	ra,56(sp)
  8002aa:	e852                	sd	s4,16(sp)
  8002ac:	84aa                	mv	s1,a0
  8002ae:	89ae                	mv	s3,a1
  8002b0:	8932                	mv	s2,a2
  8002b2:	fff7841b          	addiw	s0,a5,-1
  8002b6:	2a81                	sext.w	s5,s5
  8002b8:	0516f163          	bleu	a7,a3,8002fa <printnum+0x6a>
  8002bc:	8a42                	mv	s4,a6
  8002be:	00805863          	blez	s0,8002ce <printnum+0x3e>
  8002c2:	347d                	addiw	s0,s0,-1
  8002c4:	864e                	mv	a2,s3
  8002c6:	85ca                	mv	a1,s2
  8002c8:	8552                	mv	a0,s4
  8002ca:	9482                	jalr	s1
  8002cc:	f87d                	bnez	s0,8002c2 <printnum+0x32>
  8002ce:	1a82                	slli	s5,s5,0x20
  8002d0:	020ada93          	srli	s5,s5,0x20
  8002d4:	00000797          	auipc	a5,0x0
  8002d8:	6f478793          	addi	a5,a5,1780 # 8009c8 <error_string+0xc8>
  8002dc:	9abe                	add	s5,s5,a5
  8002de:	7442                	ld	s0,48(sp)
  8002e0:	000ac503          	lbu	a0,0(s5)
  8002e4:	70e2                	ld	ra,56(sp)
  8002e6:	6a42                	ld	s4,16(sp)
  8002e8:	6aa2                	ld	s5,8(sp)
  8002ea:	864e                	mv	a2,s3
  8002ec:	85ca                	mv	a1,s2
  8002ee:	69e2                	ld	s3,24(sp)
  8002f0:	7902                	ld	s2,32(sp)
  8002f2:	8326                	mv	t1,s1
  8002f4:	74a2                	ld	s1,40(sp)
  8002f6:	6121                	addi	sp,sp,64
  8002f8:	8302                	jr	t1
  8002fa:	0316d6b3          	divu	a3,a3,a7
  8002fe:	87a2                	mv	a5,s0
  800300:	f91ff0ef          	jal	ra,800290 <printnum>
  800304:	b7e9                	j	8002ce <printnum+0x3e>

0000000000800306 <vprintfmt>:
  800306:	7119                	addi	sp,sp,-128
  800308:	f4a6                	sd	s1,104(sp)
  80030a:	f0ca                	sd	s2,96(sp)
  80030c:	ecce                	sd	s3,88(sp)
  80030e:	e4d6                	sd	s5,72(sp)
  800310:	e0da                	sd	s6,64(sp)
  800312:	fc5e                	sd	s7,56(sp)
  800314:	f862                	sd	s8,48(sp)
  800316:	ec6e                	sd	s11,24(sp)
  800318:	fc86                	sd	ra,120(sp)
  80031a:	f8a2                	sd	s0,112(sp)
  80031c:	e8d2                	sd	s4,80(sp)
  80031e:	f466                	sd	s9,40(sp)
  800320:	f06a                	sd	s10,32(sp)
  800322:	89aa                	mv	s3,a0
  800324:	892e                	mv	s2,a1
  800326:	84b2                	mv	s1,a2
  800328:	8db6                	mv	s11,a3
  80032a:	8b3a                	mv	s6,a4
  80032c:	5bfd                	li	s7,-1
  80032e:	00000a97          	auipc	s5,0x0
  800332:	476a8a93          	addi	s5,s5,1142 # 8007a4 <main+0xf2>
  800336:	05e00c13          	li	s8,94
  80033a:	000dc503          	lbu	a0,0(s11)
  80033e:	02500793          	li	a5,37
  800342:	001d8413          	addi	s0,s11,1
  800346:	00f50f63          	beq	a0,a5,800364 <vprintfmt+0x5e>
  80034a:	c529                	beqz	a0,800394 <vprintfmt+0x8e>
  80034c:	02500a13          	li	s4,37
  800350:	a011                	j	800354 <vprintfmt+0x4e>
  800352:	c129                	beqz	a0,800394 <vprintfmt+0x8e>
  800354:	864a                	mv	a2,s2
  800356:	85a6                	mv	a1,s1
  800358:	0405                	addi	s0,s0,1
  80035a:	9982                	jalr	s3
  80035c:	fff44503          	lbu	a0,-1(s0)
  800360:	ff4519e3          	bne	a0,s4,800352 <vprintfmt+0x4c>
  800364:	00044603          	lbu	a2,0(s0)
  800368:	02000813          	li	a6,32
  80036c:	4a01                	li	s4,0
  80036e:	4881                	li	a7,0
  800370:	5d7d                	li	s10,-1
  800372:	5cfd                	li	s9,-1
  800374:	05500593          	li	a1,85
  800378:	4525                	li	a0,9
  80037a:	fdd6071b          	addiw	a4,a2,-35
  80037e:	0ff77713          	andi	a4,a4,255
  800382:	00140d93          	addi	s11,s0,1
  800386:	22e5e363          	bltu	a1,a4,8005ac <vprintfmt+0x2a6>
  80038a:	070a                	slli	a4,a4,0x2
  80038c:	9756                	add	a4,a4,s5
  80038e:	4318                	lw	a4,0(a4)
  800390:	9756                	add	a4,a4,s5
  800392:	8702                	jr	a4
  800394:	70e6                	ld	ra,120(sp)
  800396:	7446                	ld	s0,112(sp)
  800398:	74a6                	ld	s1,104(sp)
  80039a:	7906                	ld	s2,96(sp)
  80039c:	69e6                	ld	s3,88(sp)
  80039e:	6a46                	ld	s4,80(sp)
  8003a0:	6aa6                	ld	s5,72(sp)
  8003a2:	6b06                	ld	s6,64(sp)
  8003a4:	7be2                	ld	s7,56(sp)
  8003a6:	7c42                	ld	s8,48(sp)
  8003a8:	7ca2                	ld	s9,40(sp)
  8003aa:	7d02                	ld	s10,32(sp)
  8003ac:	6de2                	ld	s11,24(sp)
  8003ae:	6109                	addi	sp,sp,128
  8003b0:	8082                	ret
  8003b2:	4705                	li	a4,1
  8003b4:	008b0613          	addi	a2,s6,8
  8003b8:	01174463          	blt	a4,a7,8003c0 <vprintfmt+0xba>
  8003bc:	28088563          	beqz	a7,800646 <vprintfmt+0x340>
  8003c0:	000b3683          	ld	a3,0(s6)
  8003c4:	4741                	li	a4,16
  8003c6:	8b32                	mv	s6,a2
  8003c8:	a86d                	j	800482 <vprintfmt+0x17c>
  8003ca:	00144603          	lbu	a2,1(s0)
  8003ce:	4a05                	li	s4,1
  8003d0:	846e                	mv	s0,s11
  8003d2:	b765                	j	80037a <vprintfmt+0x74>
  8003d4:	000b2503          	lw	a0,0(s6)
  8003d8:	864a                	mv	a2,s2
  8003da:	85a6                	mv	a1,s1
  8003dc:	0b21                	addi	s6,s6,8
  8003de:	9982                	jalr	s3
  8003e0:	bfa9                	j	80033a <vprintfmt+0x34>
  8003e2:	4705                	li	a4,1
  8003e4:	008b0a13          	addi	s4,s6,8
  8003e8:	01174463          	blt	a4,a7,8003f0 <vprintfmt+0xea>
  8003ec:	24088563          	beqz	a7,800636 <vprintfmt+0x330>
  8003f0:	000b3403          	ld	s0,0(s6)
  8003f4:	26044563          	bltz	s0,80065e <vprintfmt+0x358>
  8003f8:	86a2                	mv	a3,s0
  8003fa:	8b52                	mv	s6,s4
  8003fc:	4729                	li	a4,10
  8003fe:	a051                	j	800482 <vprintfmt+0x17c>
  800400:	000b2783          	lw	a5,0(s6)
  800404:	46e1                	li	a3,24
  800406:	0b21                	addi	s6,s6,8
  800408:	41f7d71b          	sraiw	a4,a5,0x1f
  80040c:	8fb9                	xor	a5,a5,a4
  80040e:	40e7873b          	subw	a4,a5,a4
  800412:	1ce6c163          	blt	a3,a4,8005d4 <vprintfmt+0x2ce>
  800416:	00371793          	slli	a5,a4,0x3
  80041a:	00000697          	auipc	a3,0x0
  80041e:	4e668693          	addi	a3,a3,1254 # 800900 <error_string>
  800422:	97b6                	add	a5,a5,a3
  800424:	639c                	ld	a5,0(a5)
  800426:	1a078763          	beqz	a5,8005d4 <vprintfmt+0x2ce>
  80042a:	873e                	mv	a4,a5
  80042c:	00000697          	auipc	a3,0x0
  800430:	7a468693          	addi	a3,a3,1956 # 800bd0 <error_string+0x2d0>
  800434:	8626                	mv	a2,s1
  800436:	85ca                	mv	a1,s2
  800438:	854e                	mv	a0,s3
  80043a:	25a000ef          	jal	ra,800694 <printfmt>
  80043e:	bdf5                	j	80033a <vprintfmt+0x34>
  800440:	00144603          	lbu	a2,1(s0)
  800444:	2885                	addiw	a7,a7,1
  800446:	846e                	mv	s0,s11
  800448:	bf0d                	j	80037a <vprintfmt+0x74>
  80044a:	4705                	li	a4,1
  80044c:	008b0613          	addi	a2,s6,8
  800450:	01174463          	blt	a4,a7,800458 <vprintfmt+0x152>
  800454:	1e088e63          	beqz	a7,800650 <vprintfmt+0x34a>
  800458:	000b3683          	ld	a3,0(s6)
  80045c:	4721                	li	a4,8
  80045e:	8b32                	mv	s6,a2
  800460:	a00d                	j	800482 <vprintfmt+0x17c>
  800462:	03000513          	li	a0,48
  800466:	864a                	mv	a2,s2
  800468:	85a6                	mv	a1,s1
  80046a:	e042                	sd	a6,0(sp)
  80046c:	9982                	jalr	s3
  80046e:	864a                	mv	a2,s2
  800470:	85a6                	mv	a1,s1
  800472:	07800513          	li	a0,120
  800476:	9982                	jalr	s3
  800478:	0b21                	addi	s6,s6,8
  80047a:	ff8b3683          	ld	a3,-8(s6)
  80047e:	6802                	ld	a6,0(sp)
  800480:	4741                	li	a4,16
  800482:	87e6                	mv	a5,s9
  800484:	8626                	mv	a2,s1
  800486:	85ca                	mv	a1,s2
  800488:	854e                	mv	a0,s3
  80048a:	e07ff0ef          	jal	ra,800290 <printnum>
  80048e:	b575                	j	80033a <vprintfmt+0x34>
  800490:	000b3703          	ld	a4,0(s6)
  800494:	0b21                	addi	s6,s6,8
  800496:	1e070063          	beqz	a4,800676 <vprintfmt+0x370>
  80049a:	00170413          	addi	s0,a4,1
  80049e:	19905563          	blez	s9,800628 <vprintfmt+0x322>
  8004a2:	02d00613          	li	a2,45
  8004a6:	14c81963          	bne	a6,a2,8005f8 <vprintfmt+0x2f2>
  8004aa:	00074703          	lbu	a4,0(a4)
  8004ae:	0007051b          	sext.w	a0,a4
  8004b2:	c90d                	beqz	a0,8004e4 <vprintfmt+0x1de>
  8004b4:	000d4563          	bltz	s10,8004be <vprintfmt+0x1b8>
  8004b8:	3d7d                	addiw	s10,s10,-1
  8004ba:	037d0363          	beq	s10,s7,8004e0 <vprintfmt+0x1da>
  8004be:	864a                	mv	a2,s2
  8004c0:	85a6                	mv	a1,s1
  8004c2:	180a0c63          	beqz	s4,80065a <vprintfmt+0x354>
  8004c6:	3701                	addiw	a4,a4,-32
  8004c8:	18ec7963          	bleu	a4,s8,80065a <vprintfmt+0x354>
  8004cc:	03f00513          	li	a0,63
  8004d0:	9982                	jalr	s3
  8004d2:	0405                	addi	s0,s0,1
  8004d4:	fff44703          	lbu	a4,-1(s0)
  8004d8:	3cfd                	addiw	s9,s9,-1
  8004da:	0007051b          	sext.w	a0,a4
  8004de:	f979                	bnez	a0,8004b4 <vprintfmt+0x1ae>
  8004e0:	e5905de3          	blez	s9,80033a <vprintfmt+0x34>
  8004e4:	3cfd                	addiw	s9,s9,-1
  8004e6:	864a                	mv	a2,s2
  8004e8:	85a6                	mv	a1,s1
  8004ea:	02000513          	li	a0,32
  8004ee:	9982                	jalr	s3
  8004f0:	e40c85e3          	beqz	s9,80033a <vprintfmt+0x34>
  8004f4:	3cfd                	addiw	s9,s9,-1
  8004f6:	864a                	mv	a2,s2
  8004f8:	85a6                	mv	a1,s1
  8004fa:	02000513          	li	a0,32
  8004fe:	9982                	jalr	s3
  800500:	fe0c92e3          	bnez	s9,8004e4 <vprintfmt+0x1de>
  800504:	bd1d                	j	80033a <vprintfmt+0x34>
  800506:	4705                	li	a4,1
  800508:	008b0613          	addi	a2,s6,8
  80050c:	01174463          	blt	a4,a7,800514 <vprintfmt+0x20e>
  800510:	12088663          	beqz	a7,80063c <vprintfmt+0x336>
  800514:	000b3683          	ld	a3,0(s6)
  800518:	4729                	li	a4,10
  80051a:	8b32                	mv	s6,a2
  80051c:	b79d                	j	800482 <vprintfmt+0x17c>
  80051e:	00144603          	lbu	a2,1(s0)
  800522:	02d00813          	li	a6,45
  800526:	846e                	mv	s0,s11
  800528:	bd89                	j	80037a <vprintfmt+0x74>
  80052a:	864a                	mv	a2,s2
  80052c:	85a6                	mv	a1,s1
  80052e:	02500513          	li	a0,37
  800532:	9982                	jalr	s3
  800534:	b519                	j	80033a <vprintfmt+0x34>
  800536:	000b2d03          	lw	s10,0(s6)
  80053a:	00144603          	lbu	a2,1(s0)
  80053e:	0b21                	addi	s6,s6,8
  800540:	846e                	mv	s0,s11
  800542:	e20cdce3          	bgez	s9,80037a <vprintfmt+0x74>
  800546:	8cea                	mv	s9,s10
  800548:	5d7d                	li	s10,-1
  80054a:	bd05                	j	80037a <vprintfmt+0x74>
  80054c:	00144603          	lbu	a2,1(s0)
  800550:	03000813          	li	a6,48
  800554:	846e                	mv	s0,s11
  800556:	b515                	j	80037a <vprintfmt+0x74>
  800558:	fd060d1b          	addiw	s10,a2,-48
  80055c:	00144603          	lbu	a2,1(s0)
  800560:	846e                	mv	s0,s11
  800562:	fd06071b          	addiw	a4,a2,-48
  800566:	0006031b          	sext.w	t1,a2
  80056a:	fce56ce3          	bltu	a0,a4,800542 <vprintfmt+0x23c>
  80056e:	0405                	addi	s0,s0,1
  800570:	002d171b          	slliw	a4,s10,0x2
  800574:	00044603          	lbu	a2,0(s0)
  800578:	01a706bb          	addw	a3,a4,s10
  80057c:	0016969b          	slliw	a3,a3,0x1
  800580:	006686bb          	addw	a3,a3,t1
  800584:	fd06071b          	addiw	a4,a2,-48
  800588:	fd068d1b          	addiw	s10,a3,-48
  80058c:	0006031b          	sext.w	t1,a2
  800590:	fce57fe3          	bleu	a4,a0,80056e <vprintfmt+0x268>
  800594:	b77d                	j	800542 <vprintfmt+0x23c>
  800596:	fffcc713          	not	a4,s9
  80059a:	977d                	srai	a4,a4,0x3f
  80059c:	00ecf7b3          	and	a5,s9,a4
  8005a0:	00144603          	lbu	a2,1(s0)
  8005a4:	00078c9b          	sext.w	s9,a5
  8005a8:	846e                	mv	s0,s11
  8005aa:	bbc1                	j	80037a <vprintfmt+0x74>
  8005ac:	864a                	mv	a2,s2
  8005ae:	85a6                	mv	a1,s1
  8005b0:	02500513          	li	a0,37
  8005b4:	9982                	jalr	s3
  8005b6:	fff44703          	lbu	a4,-1(s0)
  8005ba:	02500793          	li	a5,37
  8005be:	8da2                	mv	s11,s0
  8005c0:	d6f70de3          	beq	a4,a5,80033a <vprintfmt+0x34>
  8005c4:	02500713          	li	a4,37
  8005c8:	1dfd                	addi	s11,s11,-1
  8005ca:	fffdc783          	lbu	a5,-1(s11)
  8005ce:	fee79de3          	bne	a5,a4,8005c8 <vprintfmt+0x2c2>
  8005d2:	b3a5                	j	80033a <vprintfmt+0x34>
  8005d4:	00000697          	auipc	a3,0x0
  8005d8:	5ec68693          	addi	a3,a3,1516 # 800bc0 <error_string+0x2c0>
  8005dc:	8626                	mv	a2,s1
  8005de:	85ca                	mv	a1,s2
  8005e0:	854e                	mv	a0,s3
  8005e2:	0b2000ef          	jal	ra,800694 <printfmt>
  8005e6:	bb91                	j	80033a <vprintfmt+0x34>
  8005e8:	00000717          	auipc	a4,0x0
  8005ec:	5d070713          	addi	a4,a4,1488 # 800bb8 <error_string+0x2b8>
  8005f0:	00000417          	auipc	s0,0x0
  8005f4:	5c940413          	addi	s0,s0,1481 # 800bb9 <error_string+0x2b9>
  8005f8:	853a                	mv	a0,a4
  8005fa:	85ea                	mv	a1,s10
  8005fc:	e03a                	sd	a4,0(sp)
  8005fe:	e442                	sd	a6,8(sp)
  800600:	c6bff0ef          	jal	ra,80026a <strnlen>
  800604:	40ac8cbb          	subw	s9,s9,a0
  800608:	6702                	ld	a4,0(sp)
  80060a:	01905f63          	blez	s9,800628 <vprintfmt+0x322>
  80060e:	6822                	ld	a6,8(sp)
  800610:	0008079b          	sext.w	a5,a6
  800614:	e43e                	sd	a5,8(sp)
  800616:	6522                	ld	a0,8(sp)
  800618:	864a                	mv	a2,s2
  80061a:	85a6                	mv	a1,s1
  80061c:	e03a                	sd	a4,0(sp)
  80061e:	3cfd                	addiw	s9,s9,-1
  800620:	9982                	jalr	s3
  800622:	6702                	ld	a4,0(sp)
  800624:	fe0c99e3          	bnez	s9,800616 <vprintfmt+0x310>
  800628:	00074703          	lbu	a4,0(a4)
  80062c:	0007051b          	sext.w	a0,a4
  800630:	e80512e3          	bnez	a0,8004b4 <vprintfmt+0x1ae>
  800634:	b319                	j	80033a <vprintfmt+0x34>
  800636:	000b2403          	lw	s0,0(s6)
  80063a:	bb6d                	j	8003f4 <vprintfmt+0xee>
  80063c:	000b6683          	lwu	a3,0(s6)
  800640:	4729                	li	a4,10
  800642:	8b32                	mv	s6,a2
  800644:	bd3d                	j	800482 <vprintfmt+0x17c>
  800646:	000b6683          	lwu	a3,0(s6)
  80064a:	4741                	li	a4,16
  80064c:	8b32                	mv	s6,a2
  80064e:	bd15                	j	800482 <vprintfmt+0x17c>
  800650:	000b6683          	lwu	a3,0(s6)
  800654:	4721                	li	a4,8
  800656:	8b32                	mv	s6,a2
  800658:	b52d                	j	800482 <vprintfmt+0x17c>
  80065a:	9982                	jalr	s3
  80065c:	bd9d                	j	8004d2 <vprintfmt+0x1cc>
  80065e:	864a                	mv	a2,s2
  800660:	85a6                	mv	a1,s1
  800662:	02d00513          	li	a0,45
  800666:	e042                	sd	a6,0(sp)
  800668:	9982                	jalr	s3
  80066a:	8b52                	mv	s6,s4
  80066c:	408006b3          	neg	a3,s0
  800670:	4729                	li	a4,10
  800672:	6802                	ld	a6,0(sp)
  800674:	b539                	j	800482 <vprintfmt+0x17c>
  800676:	01905663          	blez	s9,800682 <vprintfmt+0x37c>
  80067a:	02d00713          	li	a4,45
  80067e:	f6e815e3          	bne	a6,a4,8005e8 <vprintfmt+0x2e2>
  800682:	00000417          	auipc	s0,0x0
  800686:	53740413          	addi	s0,s0,1335 # 800bb9 <error_string+0x2b9>
  80068a:	02800513          	li	a0,40
  80068e:	02800713          	li	a4,40
  800692:	b50d                	j	8004b4 <vprintfmt+0x1ae>

0000000000800694 <printfmt>:
  800694:	7139                	addi	sp,sp,-64
  800696:	02010313          	addi	t1,sp,32
  80069a:	f03a                	sd	a4,32(sp)
  80069c:	871a                	mv	a4,t1
  80069e:	ec06                	sd	ra,24(sp)
  8006a0:	f43e                	sd	a5,40(sp)
  8006a2:	f842                	sd	a6,48(sp)
  8006a4:	fc46                	sd	a7,56(sp)
  8006a6:	e41a                	sd	t1,8(sp)
  8006a8:	c5fff0ef          	jal	ra,800306 <vprintfmt>
  8006ac:	60e2                	ld	ra,24(sp)
  8006ae:	6121                	addi	sp,sp,64
  8006b0:	8082                	ret

00000000008006b2 <main>:
  8006b2:	00001797          	auipc	a5,0x1
  8006b6:	94e78793          	addi	a5,a5,-1714 # 801000 <zero>
  8006ba:	439c                	lw	a5,0(a5)
  8006bc:	4585                	li	a1,1
  8006be:	1141                	addi	sp,sp,-16
  8006c0:	02f5c5bb          	divw	a1,a1,a5
  8006c4:	00000517          	auipc	a0,0x0
  8006c8:	51450513          	addi	a0,a0,1300 # 800bd8 <error_string+0x2d8>
  8006cc:	e406                	sd	ra,8(sp)
  8006ce:	a95ff0ef          	jal	ra,800162 <cprintf>
  8006d2:	00000617          	auipc	a2,0x0
  8006d6:	51660613          	addi	a2,a2,1302 # 800be8 <error_string+0x2e8>
  8006da:	45a5                	li	a1,9
  8006dc:	00000517          	auipc	a0,0x0
  8006e0:	51c50513          	addi	a0,a0,1308 # 800bf8 <error_string+0x2f8>
  8006e4:	93dff0ef          	jal	ra,800020 <__panic>
