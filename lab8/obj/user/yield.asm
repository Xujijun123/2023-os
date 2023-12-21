
obj/__user_yield.out：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000800020 <__warn>:
  800020:	715d                	addi	sp,sp,-80
  800022:	e822                	sd	s0,16(sp)
  800024:	fc3e                	sd	a5,56(sp)
  800026:	8432                	mv	s0,a2
  800028:	103c                	addi	a5,sp,40
  80002a:	862e                	mv	a2,a1
  80002c:	85aa                	mv	a1,a0
  80002e:	00000517          	auipc	a0,0x0
  800032:	6ea50513          	addi	a0,a0,1770 # 800718 <main+0x92>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	0ec000ef          	jal	ra,80012e <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	0be000ef          	jal	ra,800108 <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	70a50513          	addi	a0,a0,1802 # 800758 <main+0xd2>
  800056:	0d8000ef          	jal	ra,80012e <cprintf>
  80005a:	60e2                	ld	ra,24(sp)
  80005c:	6442                	ld	s0,16(sp)
  80005e:	6161                	addi	sp,sp,80
  800060:	8082                	ret

0000000000800062 <syscall>:
  800062:	7175                	addi	sp,sp,-144
  800064:	f8ba                	sd	a4,112(sp)
  800066:	e0ba                	sd	a4,64(sp)
  800068:	0118                	addi	a4,sp,128
  80006a:	e42a                	sd	a0,8(sp)
  80006c:	ecae                	sd	a1,88(sp)
  80006e:	f0b2                	sd	a2,96(sp)
  800070:	f4b6                	sd	a3,104(sp)
  800072:	fcbe                	sd	a5,120(sp)
  800074:	e142                	sd	a6,128(sp)
  800076:	e546                	sd	a7,136(sp)
  800078:	f42e                	sd	a1,40(sp)
  80007a:	f832                	sd	a2,48(sp)
  80007c:	fc36                	sd	a3,56(sp)
  80007e:	f03a                	sd	a4,32(sp)
  800080:	e4be                	sd	a5,72(sp)
  800082:	4522                	lw	a0,8(sp)
  800084:	55a2                	lw	a1,40(sp)
  800086:	5642                	lw	a2,48(sp)
  800088:	56e2                	lw	a3,56(sp)
  80008a:	4706                	lw	a4,64(sp)
  80008c:	47a6                	lw	a5,72(sp)
  80008e:	00000073          	ecall
  800092:	ce2a                	sw	a0,28(sp)
  800094:	4572                	lw	a0,28(sp)
  800096:	6149                	addi	sp,sp,144
  800098:	8082                	ret

000000000080009a <sys_exit>:
  80009a:	85aa                	mv	a1,a0
  80009c:	4505                	li	a0,1
  80009e:	fc5ff06f          	j	800062 <syscall>

00000000008000a2 <sys_yield>:
  8000a2:	4529                	li	a0,10
  8000a4:	fbfff06f          	j	800062 <syscall>

00000000008000a8 <sys_getpid>:
  8000a8:	4549                	li	a0,18
  8000aa:	fb9ff06f          	j	800062 <syscall>

00000000008000ae <sys_putc>:
  8000ae:	85aa                	mv	a1,a0
  8000b0:	4579                	li	a0,30
  8000b2:	fb1ff06f          	j	800062 <syscall>

00000000008000b6 <sys_open>:
  8000b6:	862e                	mv	a2,a1
  8000b8:	85aa                	mv	a1,a0
  8000ba:	06400513          	li	a0,100
  8000be:	fa5ff06f          	j	800062 <syscall>

00000000008000c2 <sys_close>:
  8000c2:	85aa                	mv	a1,a0
  8000c4:	06500513          	li	a0,101
  8000c8:	f9bff06f          	j	800062 <syscall>

00000000008000cc <sys_dup>:
  8000cc:	862e                	mv	a2,a1
  8000ce:	85aa                	mv	a1,a0
  8000d0:	08200513          	li	a0,130
  8000d4:	f8fff06f          	j	800062 <syscall>

00000000008000d8 <_start>:
  8000d8:	0d4000ef          	jal	ra,8001ac <umain>
  8000dc:	a001                	j	8000dc <_start+0x4>

00000000008000de <open>:
  8000de:	1582                	slli	a1,a1,0x20
  8000e0:	9181                	srli	a1,a1,0x20
  8000e2:	fd5ff06f          	j	8000b6 <sys_open>

00000000008000e6 <close>:
  8000e6:	fddff06f          	j	8000c2 <sys_close>

00000000008000ea <dup2>:
  8000ea:	fe3ff06f          	j	8000cc <sys_dup>

00000000008000ee <cputch>:
  8000ee:	1141                	addi	sp,sp,-16
  8000f0:	e022                	sd	s0,0(sp)
  8000f2:	e406                	sd	ra,8(sp)
  8000f4:	842e                	mv	s0,a1
  8000f6:	fb9ff0ef          	jal	ra,8000ae <sys_putc>
  8000fa:	401c                	lw	a5,0(s0)
  8000fc:	60a2                	ld	ra,8(sp)
  8000fe:	2785                	addiw	a5,a5,1
  800100:	c01c                	sw	a5,0(s0)
  800102:	6402                	ld	s0,0(sp)
  800104:	0141                	addi	sp,sp,16
  800106:	8082                	ret

0000000000800108 <vcprintf>:
  800108:	1101                	addi	sp,sp,-32
  80010a:	872e                	mv	a4,a1
  80010c:	75dd                	lui	a1,0xffff7
  80010e:	86aa                	mv	a3,a0
  800110:	0070                	addi	a2,sp,12
  800112:	00000517          	auipc	a0,0x0
  800116:	fdc50513          	addi	a0,a0,-36 # 8000ee <cputch>
  80011a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f61c9>
  80011e:	ec06                	sd	ra,24(sp)
  800120:	c602                	sw	zero,12(sp)
  800122:	1b8000ef          	jal	ra,8002da <vprintfmt>
  800126:	60e2                	ld	ra,24(sp)
  800128:	4532                	lw	a0,12(sp)
  80012a:	6105                	addi	sp,sp,32
  80012c:	8082                	ret

000000000080012e <cprintf>:
  80012e:	711d                	addi	sp,sp,-96
  800130:	02810313          	addi	t1,sp,40
  800134:	f42e                	sd	a1,40(sp)
  800136:	75dd                	lui	a1,0xffff7
  800138:	f832                	sd	a2,48(sp)
  80013a:	fc36                	sd	a3,56(sp)
  80013c:	e0ba                	sd	a4,64(sp)
  80013e:	86aa                	mv	a3,a0
  800140:	0050                	addi	a2,sp,4
  800142:	00000517          	auipc	a0,0x0
  800146:	fac50513          	addi	a0,a0,-84 # 8000ee <cputch>
  80014a:	871a                	mv	a4,t1
  80014c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f61c9>
  800150:	ec06                	sd	ra,24(sp)
  800152:	e4be                	sd	a5,72(sp)
  800154:	e8c2                	sd	a6,80(sp)
  800156:	ecc6                	sd	a7,88(sp)
  800158:	e41a                	sd	t1,8(sp)
  80015a:	c202                	sw	zero,4(sp)
  80015c:	17e000ef          	jal	ra,8002da <vprintfmt>
  800160:	60e2                	ld	ra,24(sp)
  800162:	4512                	lw	a0,4(sp)
  800164:	6125                	addi	sp,sp,96
  800166:	8082                	ret

0000000000800168 <initfd>:
  800168:	1101                	addi	sp,sp,-32
  80016a:	87ae                	mv	a5,a1
  80016c:	e426                	sd	s1,8(sp)
  80016e:	85b2                	mv	a1,a2
  800170:	84aa                	mv	s1,a0
  800172:	853e                	mv	a0,a5
  800174:	e822                	sd	s0,16(sp)
  800176:	ec06                	sd	ra,24(sp)
  800178:	f67ff0ef          	jal	ra,8000de <open>
  80017c:	842a                	mv	s0,a0
  80017e:	00054463          	bltz	a0,800186 <initfd+0x1e>
  800182:	00951863          	bne	a0,s1,800192 <initfd+0x2a>
  800186:	8522                	mv	a0,s0
  800188:	60e2                	ld	ra,24(sp)
  80018a:	6442                	ld	s0,16(sp)
  80018c:	64a2                	ld	s1,8(sp)
  80018e:	6105                	addi	sp,sp,32
  800190:	8082                	ret
  800192:	8526                	mv	a0,s1
  800194:	f53ff0ef          	jal	ra,8000e6 <close>
  800198:	85a6                	mv	a1,s1
  80019a:	8522                	mv	a0,s0
  80019c:	f4fff0ef          	jal	ra,8000ea <dup2>
  8001a0:	84aa                	mv	s1,a0
  8001a2:	8522                	mv	a0,s0
  8001a4:	f43ff0ef          	jal	ra,8000e6 <close>
  8001a8:	8426                	mv	s0,s1
  8001aa:	bff1                	j	800186 <initfd+0x1e>

00000000008001ac <umain>:
  8001ac:	1101                	addi	sp,sp,-32
  8001ae:	e822                	sd	s0,16(sp)
  8001b0:	e426                	sd	s1,8(sp)
  8001b2:	842a                	mv	s0,a0
  8001b4:	84ae                	mv	s1,a1
  8001b6:	4601                	li	a2,0
  8001b8:	00000597          	auipc	a1,0x0
  8001bc:	58058593          	addi	a1,a1,1408 # 800738 <main+0xb2>
  8001c0:	4501                	li	a0,0
  8001c2:	ec06                	sd	ra,24(sp)
  8001c4:	fa5ff0ef          	jal	ra,800168 <initfd>
  8001c8:	02054263          	bltz	a0,8001ec <umain+0x40>
  8001cc:	4605                	li	a2,1
  8001ce:	00000597          	auipc	a1,0x0
  8001d2:	5aa58593          	addi	a1,a1,1450 # 800778 <main+0xf2>
  8001d6:	4505                	li	a0,1
  8001d8:	f91ff0ef          	jal	ra,800168 <initfd>
  8001dc:	02054563          	bltz	a0,800206 <umain+0x5a>
  8001e0:	85a6                	mv	a1,s1
  8001e2:	8522                	mv	a0,s0
  8001e4:	4a2000ef          	jal	ra,800686 <main>
  8001e8:	038000ef          	jal	ra,800220 <exit>
  8001ec:	86aa                	mv	a3,a0
  8001ee:	00000617          	auipc	a2,0x0
  8001f2:	55260613          	addi	a2,a2,1362 # 800740 <main+0xba>
  8001f6:	45e9                	li	a1,26
  8001f8:	00000517          	auipc	a0,0x0
  8001fc:	56850513          	addi	a0,a0,1384 # 800760 <main+0xda>
  800200:	e21ff0ef          	jal	ra,800020 <__warn>
  800204:	b7e1                	j	8001cc <umain+0x20>
  800206:	86aa                	mv	a3,a0
  800208:	00000617          	auipc	a2,0x0
  80020c:	57860613          	addi	a2,a2,1400 # 800780 <main+0xfa>
  800210:	45f5                	li	a1,29
  800212:	00000517          	auipc	a0,0x0
  800216:	54e50513          	addi	a0,a0,1358 # 800760 <main+0xda>
  80021a:	e07ff0ef          	jal	ra,800020 <__warn>
  80021e:	b7c9                	j	8001e0 <umain+0x34>

0000000000800220 <exit>:
  800220:	1141                	addi	sp,sp,-16
  800222:	e406                	sd	ra,8(sp)
  800224:	e77ff0ef          	jal	ra,80009a <sys_exit>
  800228:	00000517          	auipc	a0,0x0
  80022c:	57850513          	addi	a0,a0,1400 # 8007a0 <main+0x11a>
  800230:	effff0ef          	jal	ra,80012e <cprintf>
  800234:	a001                	j	800234 <exit+0x14>

0000000000800236 <yield>:
  800236:	e6dff06f          	j	8000a2 <sys_yield>

000000000080023a <getpid>:
  80023a:	e6fff06f          	j	8000a8 <sys_getpid>

000000000080023e <strnlen>:
  80023e:	c185                	beqz	a1,80025e <strnlen+0x20>
  800240:	00054783          	lbu	a5,0(a0)
  800244:	cf89                	beqz	a5,80025e <strnlen+0x20>
  800246:	4781                	li	a5,0
  800248:	a021                	j	800250 <strnlen+0x12>
  80024a:	00074703          	lbu	a4,0(a4)
  80024e:	c711                	beqz	a4,80025a <strnlen+0x1c>
  800250:	0785                	addi	a5,a5,1
  800252:	00f50733          	add	a4,a0,a5
  800256:	fef59ae3          	bne	a1,a5,80024a <strnlen+0xc>
  80025a:	853e                	mv	a0,a5
  80025c:	8082                	ret
  80025e:	4781                	li	a5,0
  800260:	853e                	mv	a0,a5
  800262:	8082                	ret

0000000000800264 <printnum>:
  800264:	02071893          	slli	a7,a4,0x20
  800268:	7139                	addi	sp,sp,-64
  80026a:	0208d893          	srli	a7,a7,0x20
  80026e:	e456                	sd	s5,8(sp)
  800270:	0316fab3          	remu	s5,a3,a7
  800274:	f822                	sd	s0,48(sp)
  800276:	f426                	sd	s1,40(sp)
  800278:	f04a                	sd	s2,32(sp)
  80027a:	ec4e                	sd	s3,24(sp)
  80027c:	fc06                	sd	ra,56(sp)
  80027e:	e852                	sd	s4,16(sp)
  800280:	84aa                	mv	s1,a0
  800282:	89ae                	mv	s3,a1
  800284:	8932                	mv	s2,a2
  800286:	fff7841b          	addiw	s0,a5,-1
  80028a:	2a81                	sext.w	s5,s5
  80028c:	0516f163          	bleu	a7,a3,8002ce <printnum+0x6a>
  800290:	8a42                	mv	s4,a6
  800292:	00805863          	blez	s0,8002a2 <printnum+0x3e>
  800296:	347d                	addiw	s0,s0,-1
  800298:	864e                	mv	a2,s3
  80029a:	85ca                	mv	a1,s2
  80029c:	8552                	mv	a0,s4
  80029e:	9482                	jalr	s1
  8002a0:	f87d                	bnez	s0,800296 <printnum+0x32>
  8002a2:	1a82                	slli	s5,s5,0x20
  8002a4:	020ada93          	srli	s5,s5,0x20
  8002a8:	00000797          	auipc	a5,0x0
  8002ac:	73078793          	addi	a5,a5,1840 # 8009d8 <error_string+0xc8>
  8002b0:	9abe                	add	s5,s5,a5
  8002b2:	7442                	ld	s0,48(sp)
  8002b4:	000ac503          	lbu	a0,0(s5)
  8002b8:	70e2                	ld	ra,56(sp)
  8002ba:	6a42                	ld	s4,16(sp)
  8002bc:	6aa2                	ld	s5,8(sp)
  8002be:	864e                	mv	a2,s3
  8002c0:	85ca                	mv	a1,s2
  8002c2:	69e2                	ld	s3,24(sp)
  8002c4:	7902                	ld	s2,32(sp)
  8002c6:	8326                	mv	t1,s1
  8002c8:	74a2                	ld	s1,40(sp)
  8002ca:	6121                	addi	sp,sp,64
  8002cc:	8302                	jr	t1
  8002ce:	0316d6b3          	divu	a3,a3,a7
  8002d2:	87a2                	mv	a5,s0
  8002d4:	f91ff0ef          	jal	ra,800264 <printnum>
  8002d8:	b7e9                	j	8002a2 <printnum+0x3e>

00000000008002da <vprintfmt>:
  8002da:	7119                	addi	sp,sp,-128
  8002dc:	f4a6                	sd	s1,104(sp)
  8002de:	f0ca                	sd	s2,96(sp)
  8002e0:	ecce                	sd	s3,88(sp)
  8002e2:	e4d6                	sd	s5,72(sp)
  8002e4:	e0da                	sd	s6,64(sp)
  8002e6:	fc5e                	sd	s7,56(sp)
  8002e8:	f862                	sd	s8,48(sp)
  8002ea:	ec6e                	sd	s11,24(sp)
  8002ec:	fc86                	sd	ra,120(sp)
  8002ee:	f8a2                	sd	s0,112(sp)
  8002f0:	e8d2                	sd	s4,80(sp)
  8002f2:	f466                	sd	s9,40(sp)
  8002f4:	f06a                	sd	s10,32(sp)
  8002f6:	89aa                	mv	s3,a0
  8002f8:	892e                	mv	s2,a1
  8002fa:	84b2                	mv	s1,a2
  8002fc:	8db6                	mv	s11,a3
  8002fe:	8b3a                	mv	s6,a4
  800300:	5bfd                	li	s7,-1
  800302:	00000a97          	auipc	s5,0x0
  800306:	4b2a8a93          	addi	s5,s5,1202 # 8007b4 <main+0x12e>
  80030a:	05e00c13          	li	s8,94
  80030e:	000dc503          	lbu	a0,0(s11)
  800312:	02500793          	li	a5,37
  800316:	001d8413          	addi	s0,s11,1
  80031a:	00f50f63          	beq	a0,a5,800338 <vprintfmt+0x5e>
  80031e:	c529                	beqz	a0,800368 <vprintfmt+0x8e>
  800320:	02500a13          	li	s4,37
  800324:	a011                	j	800328 <vprintfmt+0x4e>
  800326:	c129                	beqz	a0,800368 <vprintfmt+0x8e>
  800328:	864a                	mv	a2,s2
  80032a:	85a6                	mv	a1,s1
  80032c:	0405                	addi	s0,s0,1
  80032e:	9982                	jalr	s3
  800330:	fff44503          	lbu	a0,-1(s0)
  800334:	ff4519e3          	bne	a0,s4,800326 <vprintfmt+0x4c>
  800338:	00044603          	lbu	a2,0(s0)
  80033c:	02000813          	li	a6,32
  800340:	4a01                	li	s4,0
  800342:	4881                	li	a7,0
  800344:	5d7d                	li	s10,-1
  800346:	5cfd                	li	s9,-1
  800348:	05500593          	li	a1,85
  80034c:	4525                	li	a0,9
  80034e:	fdd6071b          	addiw	a4,a2,-35
  800352:	0ff77713          	andi	a4,a4,255
  800356:	00140d93          	addi	s11,s0,1
  80035a:	22e5e363          	bltu	a1,a4,800580 <vprintfmt+0x2a6>
  80035e:	070a                	slli	a4,a4,0x2
  800360:	9756                	add	a4,a4,s5
  800362:	4318                	lw	a4,0(a4)
  800364:	9756                	add	a4,a4,s5
  800366:	8702                	jr	a4
  800368:	70e6                	ld	ra,120(sp)
  80036a:	7446                	ld	s0,112(sp)
  80036c:	74a6                	ld	s1,104(sp)
  80036e:	7906                	ld	s2,96(sp)
  800370:	69e6                	ld	s3,88(sp)
  800372:	6a46                	ld	s4,80(sp)
  800374:	6aa6                	ld	s5,72(sp)
  800376:	6b06                	ld	s6,64(sp)
  800378:	7be2                	ld	s7,56(sp)
  80037a:	7c42                	ld	s8,48(sp)
  80037c:	7ca2                	ld	s9,40(sp)
  80037e:	7d02                	ld	s10,32(sp)
  800380:	6de2                	ld	s11,24(sp)
  800382:	6109                	addi	sp,sp,128
  800384:	8082                	ret
  800386:	4705                	li	a4,1
  800388:	008b0613          	addi	a2,s6,8
  80038c:	01174463          	blt	a4,a7,800394 <vprintfmt+0xba>
  800390:	28088563          	beqz	a7,80061a <vprintfmt+0x340>
  800394:	000b3683          	ld	a3,0(s6)
  800398:	4741                	li	a4,16
  80039a:	8b32                	mv	s6,a2
  80039c:	a86d                	j	800456 <vprintfmt+0x17c>
  80039e:	00144603          	lbu	a2,1(s0)
  8003a2:	4a05                	li	s4,1
  8003a4:	846e                	mv	s0,s11
  8003a6:	b765                	j	80034e <vprintfmt+0x74>
  8003a8:	000b2503          	lw	a0,0(s6)
  8003ac:	864a                	mv	a2,s2
  8003ae:	85a6                	mv	a1,s1
  8003b0:	0b21                	addi	s6,s6,8
  8003b2:	9982                	jalr	s3
  8003b4:	bfa9                	j	80030e <vprintfmt+0x34>
  8003b6:	4705                	li	a4,1
  8003b8:	008b0a13          	addi	s4,s6,8
  8003bc:	01174463          	blt	a4,a7,8003c4 <vprintfmt+0xea>
  8003c0:	24088563          	beqz	a7,80060a <vprintfmt+0x330>
  8003c4:	000b3403          	ld	s0,0(s6)
  8003c8:	26044563          	bltz	s0,800632 <vprintfmt+0x358>
  8003cc:	86a2                	mv	a3,s0
  8003ce:	8b52                	mv	s6,s4
  8003d0:	4729                	li	a4,10
  8003d2:	a051                	j	800456 <vprintfmt+0x17c>
  8003d4:	000b2783          	lw	a5,0(s6)
  8003d8:	46e1                	li	a3,24
  8003da:	0b21                	addi	s6,s6,8
  8003dc:	41f7d71b          	sraiw	a4,a5,0x1f
  8003e0:	8fb9                	xor	a5,a5,a4
  8003e2:	40e7873b          	subw	a4,a5,a4
  8003e6:	1ce6c163          	blt	a3,a4,8005a8 <vprintfmt+0x2ce>
  8003ea:	00371793          	slli	a5,a4,0x3
  8003ee:	00000697          	auipc	a3,0x0
  8003f2:	52268693          	addi	a3,a3,1314 # 800910 <error_string>
  8003f6:	97b6                	add	a5,a5,a3
  8003f8:	639c                	ld	a5,0(a5)
  8003fa:	1a078763          	beqz	a5,8005a8 <vprintfmt+0x2ce>
  8003fe:	873e                	mv	a4,a5
  800400:	00000697          	auipc	a3,0x0
  800404:	7e068693          	addi	a3,a3,2016 # 800be0 <error_string+0x2d0>
  800408:	8626                	mv	a2,s1
  80040a:	85ca                	mv	a1,s2
  80040c:	854e                	mv	a0,s3
  80040e:	25a000ef          	jal	ra,800668 <printfmt>
  800412:	bdf5                	j	80030e <vprintfmt+0x34>
  800414:	00144603          	lbu	a2,1(s0)
  800418:	2885                	addiw	a7,a7,1
  80041a:	846e                	mv	s0,s11
  80041c:	bf0d                	j	80034e <vprintfmt+0x74>
  80041e:	4705                	li	a4,1
  800420:	008b0613          	addi	a2,s6,8
  800424:	01174463          	blt	a4,a7,80042c <vprintfmt+0x152>
  800428:	1e088e63          	beqz	a7,800624 <vprintfmt+0x34a>
  80042c:	000b3683          	ld	a3,0(s6)
  800430:	4721                	li	a4,8
  800432:	8b32                	mv	s6,a2
  800434:	a00d                	j	800456 <vprintfmt+0x17c>
  800436:	03000513          	li	a0,48
  80043a:	864a                	mv	a2,s2
  80043c:	85a6                	mv	a1,s1
  80043e:	e042                	sd	a6,0(sp)
  800440:	9982                	jalr	s3
  800442:	864a                	mv	a2,s2
  800444:	85a6                	mv	a1,s1
  800446:	07800513          	li	a0,120
  80044a:	9982                	jalr	s3
  80044c:	0b21                	addi	s6,s6,8
  80044e:	ff8b3683          	ld	a3,-8(s6)
  800452:	6802                	ld	a6,0(sp)
  800454:	4741                	li	a4,16
  800456:	87e6                	mv	a5,s9
  800458:	8626                	mv	a2,s1
  80045a:	85ca                	mv	a1,s2
  80045c:	854e                	mv	a0,s3
  80045e:	e07ff0ef          	jal	ra,800264 <printnum>
  800462:	b575                	j	80030e <vprintfmt+0x34>
  800464:	000b3703          	ld	a4,0(s6)
  800468:	0b21                	addi	s6,s6,8
  80046a:	1e070063          	beqz	a4,80064a <vprintfmt+0x370>
  80046e:	00170413          	addi	s0,a4,1
  800472:	19905563          	blez	s9,8005fc <vprintfmt+0x322>
  800476:	02d00613          	li	a2,45
  80047a:	14c81963          	bne	a6,a2,8005cc <vprintfmt+0x2f2>
  80047e:	00074703          	lbu	a4,0(a4)
  800482:	0007051b          	sext.w	a0,a4
  800486:	c90d                	beqz	a0,8004b8 <vprintfmt+0x1de>
  800488:	000d4563          	bltz	s10,800492 <vprintfmt+0x1b8>
  80048c:	3d7d                	addiw	s10,s10,-1
  80048e:	037d0363          	beq	s10,s7,8004b4 <vprintfmt+0x1da>
  800492:	864a                	mv	a2,s2
  800494:	85a6                	mv	a1,s1
  800496:	180a0c63          	beqz	s4,80062e <vprintfmt+0x354>
  80049a:	3701                	addiw	a4,a4,-32
  80049c:	18ec7963          	bleu	a4,s8,80062e <vprintfmt+0x354>
  8004a0:	03f00513          	li	a0,63
  8004a4:	9982                	jalr	s3
  8004a6:	0405                	addi	s0,s0,1
  8004a8:	fff44703          	lbu	a4,-1(s0)
  8004ac:	3cfd                	addiw	s9,s9,-1
  8004ae:	0007051b          	sext.w	a0,a4
  8004b2:	f979                	bnez	a0,800488 <vprintfmt+0x1ae>
  8004b4:	e5905de3          	blez	s9,80030e <vprintfmt+0x34>
  8004b8:	3cfd                	addiw	s9,s9,-1
  8004ba:	864a                	mv	a2,s2
  8004bc:	85a6                	mv	a1,s1
  8004be:	02000513          	li	a0,32
  8004c2:	9982                	jalr	s3
  8004c4:	e40c85e3          	beqz	s9,80030e <vprintfmt+0x34>
  8004c8:	3cfd                	addiw	s9,s9,-1
  8004ca:	864a                	mv	a2,s2
  8004cc:	85a6                	mv	a1,s1
  8004ce:	02000513          	li	a0,32
  8004d2:	9982                	jalr	s3
  8004d4:	fe0c92e3          	bnez	s9,8004b8 <vprintfmt+0x1de>
  8004d8:	bd1d                	j	80030e <vprintfmt+0x34>
  8004da:	4705                	li	a4,1
  8004dc:	008b0613          	addi	a2,s6,8
  8004e0:	01174463          	blt	a4,a7,8004e8 <vprintfmt+0x20e>
  8004e4:	12088663          	beqz	a7,800610 <vprintfmt+0x336>
  8004e8:	000b3683          	ld	a3,0(s6)
  8004ec:	4729                	li	a4,10
  8004ee:	8b32                	mv	s6,a2
  8004f0:	b79d                	j	800456 <vprintfmt+0x17c>
  8004f2:	00144603          	lbu	a2,1(s0)
  8004f6:	02d00813          	li	a6,45
  8004fa:	846e                	mv	s0,s11
  8004fc:	bd89                	j	80034e <vprintfmt+0x74>
  8004fe:	864a                	mv	a2,s2
  800500:	85a6                	mv	a1,s1
  800502:	02500513          	li	a0,37
  800506:	9982                	jalr	s3
  800508:	b519                	j	80030e <vprintfmt+0x34>
  80050a:	000b2d03          	lw	s10,0(s6)
  80050e:	00144603          	lbu	a2,1(s0)
  800512:	0b21                	addi	s6,s6,8
  800514:	846e                	mv	s0,s11
  800516:	e20cdce3          	bgez	s9,80034e <vprintfmt+0x74>
  80051a:	8cea                	mv	s9,s10
  80051c:	5d7d                	li	s10,-1
  80051e:	bd05                	j	80034e <vprintfmt+0x74>
  800520:	00144603          	lbu	a2,1(s0)
  800524:	03000813          	li	a6,48
  800528:	846e                	mv	s0,s11
  80052a:	b515                	j	80034e <vprintfmt+0x74>
  80052c:	fd060d1b          	addiw	s10,a2,-48
  800530:	00144603          	lbu	a2,1(s0)
  800534:	846e                	mv	s0,s11
  800536:	fd06071b          	addiw	a4,a2,-48
  80053a:	0006031b          	sext.w	t1,a2
  80053e:	fce56ce3          	bltu	a0,a4,800516 <vprintfmt+0x23c>
  800542:	0405                	addi	s0,s0,1
  800544:	002d171b          	slliw	a4,s10,0x2
  800548:	00044603          	lbu	a2,0(s0)
  80054c:	01a706bb          	addw	a3,a4,s10
  800550:	0016969b          	slliw	a3,a3,0x1
  800554:	006686bb          	addw	a3,a3,t1
  800558:	fd06071b          	addiw	a4,a2,-48
  80055c:	fd068d1b          	addiw	s10,a3,-48
  800560:	0006031b          	sext.w	t1,a2
  800564:	fce57fe3          	bleu	a4,a0,800542 <vprintfmt+0x268>
  800568:	b77d                	j	800516 <vprintfmt+0x23c>
  80056a:	fffcc713          	not	a4,s9
  80056e:	977d                	srai	a4,a4,0x3f
  800570:	00ecf7b3          	and	a5,s9,a4
  800574:	00144603          	lbu	a2,1(s0)
  800578:	00078c9b          	sext.w	s9,a5
  80057c:	846e                	mv	s0,s11
  80057e:	bbc1                	j	80034e <vprintfmt+0x74>
  800580:	864a                	mv	a2,s2
  800582:	85a6                	mv	a1,s1
  800584:	02500513          	li	a0,37
  800588:	9982                	jalr	s3
  80058a:	fff44703          	lbu	a4,-1(s0)
  80058e:	02500793          	li	a5,37
  800592:	8da2                	mv	s11,s0
  800594:	d6f70de3          	beq	a4,a5,80030e <vprintfmt+0x34>
  800598:	02500713          	li	a4,37
  80059c:	1dfd                	addi	s11,s11,-1
  80059e:	fffdc783          	lbu	a5,-1(s11)
  8005a2:	fee79de3          	bne	a5,a4,80059c <vprintfmt+0x2c2>
  8005a6:	b3a5                	j	80030e <vprintfmt+0x34>
  8005a8:	00000697          	auipc	a3,0x0
  8005ac:	62868693          	addi	a3,a3,1576 # 800bd0 <error_string+0x2c0>
  8005b0:	8626                	mv	a2,s1
  8005b2:	85ca                	mv	a1,s2
  8005b4:	854e                	mv	a0,s3
  8005b6:	0b2000ef          	jal	ra,800668 <printfmt>
  8005ba:	bb91                	j	80030e <vprintfmt+0x34>
  8005bc:	00000717          	auipc	a4,0x0
  8005c0:	60c70713          	addi	a4,a4,1548 # 800bc8 <error_string+0x2b8>
  8005c4:	00000417          	auipc	s0,0x0
  8005c8:	60540413          	addi	s0,s0,1541 # 800bc9 <error_string+0x2b9>
  8005cc:	853a                	mv	a0,a4
  8005ce:	85ea                	mv	a1,s10
  8005d0:	e03a                	sd	a4,0(sp)
  8005d2:	e442                	sd	a6,8(sp)
  8005d4:	c6bff0ef          	jal	ra,80023e <strnlen>
  8005d8:	40ac8cbb          	subw	s9,s9,a0
  8005dc:	6702                	ld	a4,0(sp)
  8005de:	01905f63          	blez	s9,8005fc <vprintfmt+0x322>
  8005e2:	6822                	ld	a6,8(sp)
  8005e4:	0008079b          	sext.w	a5,a6
  8005e8:	e43e                	sd	a5,8(sp)
  8005ea:	6522                	ld	a0,8(sp)
  8005ec:	864a                	mv	a2,s2
  8005ee:	85a6                	mv	a1,s1
  8005f0:	e03a                	sd	a4,0(sp)
  8005f2:	3cfd                	addiw	s9,s9,-1
  8005f4:	9982                	jalr	s3
  8005f6:	6702                	ld	a4,0(sp)
  8005f8:	fe0c99e3          	bnez	s9,8005ea <vprintfmt+0x310>
  8005fc:	00074703          	lbu	a4,0(a4)
  800600:	0007051b          	sext.w	a0,a4
  800604:	e80512e3          	bnez	a0,800488 <vprintfmt+0x1ae>
  800608:	b319                	j	80030e <vprintfmt+0x34>
  80060a:	000b2403          	lw	s0,0(s6)
  80060e:	bb6d                	j	8003c8 <vprintfmt+0xee>
  800610:	000b6683          	lwu	a3,0(s6)
  800614:	4729                	li	a4,10
  800616:	8b32                	mv	s6,a2
  800618:	bd3d                	j	800456 <vprintfmt+0x17c>
  80061a:	000b6683          	lwu	a3,0(s6)
  80061e:	4741                	li	a4,16
  800620:	8b32                	mv	s6,a2
  800622:	bd15                	j	800456 <vprintfmt+0x17c>
  800624:	000b6683          	lwu	a3,0(s6)
  800628:	4721                	li	a4,8
  80062a:	8b32                	mv	s6,a2
  80062c:	b52d                	j	800456 <vprintfmt+0x17c>
  80062e:	9982                	jalr	s3
  800630:	bd9d                	j	8004a6 <vprintfmt+0x1cc>
  800632:	864a                	mv	a2,s2
  800634:	85a6                	mv	a1,s1
  800636:	02d00513          	li	a0,45
  80063a:	e042                	sd	a6,0(sp)
  80063c:	9982                	jalr	s3
  80063e:	8b52                	mv	s6,s4
  800640:	408006b3          	neg	a3,s0
  800644:	4729                	li	a4,10
  800646:	6802                	ld	a6,0(sp)
  800648:	b539                	j	800456 <vprintfmt+0x17c>
  80064a:	01905663          	blez	s9,800656 <vprintfmt+0x37c>
  80064e:	02d00713          	li	a4,45
  800652:	f6e815e3          	bne	a6,a4,8005bc <vprintfmt+0x2e2>
  800656:	00000417          	auipc	s0,0x0
  80065a:	57340413          	addi	s0,s0,1395 # 800bc9 <error_string+0x2b9>
  80065e:	02800513          	li	a0,40
  800662:	02800713          	li	a4,40
  800666:	b50d                	j	800488 <vprintfmt+0x1ae>

0000000000800668 <printfmt>:
  800668:	7139                	addi	sp,sp,-64
  80066a:	02010313          	addi	t1,sp,32
  80066e:	f03a                	sd	a4,32(sp)
  800670:	871a                	mv	a4,t1
  800672:	ec06                	sd	ra,24(sp)
  800674:	f43e                	sd	a5,40(sp)
  800676:	f842                	sd	a6,48(sp)
  800678:	fc46                	sd	a7,56(sp)
  80067a:	e41a                	sd	t1,8(sp)
  80067c:	c5fff0ef          	jal	ra,8002da <vprintfmt>
  800680:	60e2                	ld	ra,24(sp)
  800682:	6121                	addi	sp,sp,64
  800684:	8082                	ret

0000000000800686 <main>:
  800686:	1101                	addi	sp,sp,-32
  800688:	ec06                	sd	ra,24(sp)
  80068a:	e822                	sd	s0,16(sp)
  80068c:	e426                	sd	s1,8(sp)
  80068e:	e04a                	sd	s2,0(sp)
  800690:	babff0ef          	jal	ra,80023a <getpid>
  800694:	85aa                	mv	a1,a0
  800696:	00000517          	auipc	a0,0x0
  80069a:	55250513          	addi	a0,a0,1362 # 800be8 <error_string+0x2d8>
  80069e:	a91ff0ef          	jal	ra,80012e <cprintf>
  8006a2:	4401                	li	s0,0
  8006a4:	00000917          	auipc	s2,0x0
  8006a8:	56490913          	addi	s2,s2,1380 # 800c08 <error_string+0x2f8>
  8006ac:	4495                	li	s1,5
  8006ae:	b89ff0ef          	jal	ra,800236 <yield>
  8006b2:	b89ff0ef          	jal	ra,80023a <getpid>
  8006b6:	8622                	mv	a2,s0
  8006b8:	85aa                	mv	a1,a0
  8006ba:	2405                	addiw	s0,s0,1
  8006bc:	854a                	mv	a0,s2
  8006be:	a71ff0ef          	jal	ra,80012e <cprintf>
  8006c2:	fe9416e3          	bne	s0,s1,8006ae <main+0x28>
  8006c6:	b75ff0ef          	jal	ra,80023a <getpid>
  8006ca:	85aa                	mv	a1,a0
  8006cc:	00000517          	auipc	a0,0x0
  8006d0:	56450513          	addi	a0,a0,1380 # 800c30 <error_string+0x320>
  8006d4:	a5bff0ef          	jal	ra,80012e <cprintf>
  8006d8:	00000517          	auipc	a0,0x0
  8006dc:	57850513          	addi	a0,a0,1400 # 800c50 <error_string+0x340>
  8006e0:	a4fff0ef          	jal	ra,80012e <cprintf>
  8006e4:	60e2                	ld	ra,24(sp)
  8006e6:	6442                	ld	s0,16(sp)
  8006e8:	64a2                	ld	s1,8(sp)
  8006ea:	6902                	ld	s2,0(sp)
  8006ec:	4501                	li	a0,0
  8006ee:	6105                	addi	sp,sp,32
  8006f0:	8082                	ret
