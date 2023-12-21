
obj/__user_faultread.out：     文件格式 elf64-littleriscv


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
  800032:	66a50513          	addi	a0,a0,1642 # 800698 <main+0x26>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	0e0000ef          	jal	ra,800122 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	0b2000ef          	jal	ra,8000fc <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	68a50513          	addi	a0,a0,1674 # 8006d8 <main+0x66>
  800056:	0cc000ef          	jal	ra,800122 <cprintf>
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

00000000008000a2 <sys_putc>:
  8000a2:	85aa                	mv	a1,a0
  8000a4:	4579                	li	a0,30
  8000a6:	fbdff06f          	j	800062 <syscall>

00000000008000aa <sys_open>:
  8000aa:	862e                	mv	a2,a1
  8000ac:	85aa                	mv	a1,a0
  8000ae:	06400513          	li	a0,100
  8000b2:	fb1ff06f          	j	800062 <syscall>

00000000008000b6 <sys_close>:
  8000b6:	85aa                	mv	a1,a0
  8000b8:	06500513          	li	a0,101
  8000bc:	fa7ff06f          	j	800062 <syscall>

00000000008000c0 <sys_dup>:
  8000c0:	862e                	mv	a2,a1
  8000c2:	85aa                	mv	a1,a0
  8000c4:	08200513          	li	a0,130
  8000c8:	f9bff06f          	j	800062 <syscall>

00000000008000cc <_start>:
  8000cc:	0d4000ef          	jal	ra,8001a0 <umain>
  8000d0:	a001                	j	8000d0 <_start+0x4>

00000000008000d2 <open>:
  8000d2:	1582                	slli	a1,a1,0x20
  8000d4:	9181                	srli	a1,a1,0x20
  8000d6:	fd5ff06f          	j	8000aa <sys_open>

00000000008000da <close>:
  8000da:	fddff06f          	j	8000b6 <sys_close>

00000000008000de <dup2>:
  8000de:	fe3ff06f          	j	8000c0 <sys_dup>

00000000008000e2 <cputch>:
  8000e2:	1141                	addi	sp,sp,-16
  8000e4:	e022                	sd	s0,0(sp)
  8000e6:	e406                	sd	ra,8(sp)
  8000e8:	842e                	mv	s0,a1
  8000ea:	fb9ff0ef          	jal	ra,8000a2 <sys_putc>
  8000ee:	401c                	lw	a5,0(s0)
  8000f0:	60a2                	ld	ra,8(sp)
  8000f2:	2785                	addiw	a5,a5,1
  8000f4:	c01c                	sw	a5,0(s0)
  8000f6:	6402                	ld	s0,0(sp)
  8000f8:	0141                	addi	sp,sp,16
  8000fa:	8082                	ret

00000000008000fc <vcprintf>:
  8000fc:	1101                	addi	sp,sp,-32
  8000fe:	872e                	mv	a4,a1
  800100:	75dd                	lui	a1,0xffff7
  800102:	86aa                	mv	a3,a0
  800104:	0070                	addi	a2,sp,12
  800106:	00000517          	auipc	a0,0x0
  80010a:	fdc50513          	addi	a0,a0,-36 # 8000e2 <cputch>
  80010e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6249>
  800112:	ec06                	sd	ra,24(sp)
  800114:	c602                	sw	zero,12(sp)
  800116:	1b0000ef          	jal	ra,8002c6 <vprintfmt>
  80011a:	60e2                	ld	ra,24(sp)
  80011c:	4532                	lw	a0,12(sp)
  80011e:	6105                	addi	sp,sp,32
  800120:	8082                	ret

0000000000800122 <cprintf>:
  800122:	711d                	addi	sp,sp,-96
  800124:	02810313          	addi	t1,sp,40
  800128:	f42e                	sd	a1,40(sp)
  80012a:	75dd                	lui	a1,0xffff7
  80012c:	f832                	sd	a2,48(sp)
  80012e:	fc36                	sd	a3,56(sp)
  800130:	e0ba                	sd	a4,64(sp)
  800132:	86aa                	mv	a3,a0
  800134:	0050                	addi	a2,sp,4
  800136:	00000517          	auipc	a0,0x0
  80013a:	fac50513          	addi	a0,a0,-84 # 8000e2 <cputch>
  80013e:	871a                	mv	a4,t1
  800140:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6249>
  800144:	ec06                	sd	ra,24(sp)
  800146:	e4be                	sd	a5,72(sp)
  800148:	e8c2                	sd	a6,80(sp)
  80014a:	ecc6                	sd	a7,88(sp)
  80014c:	e41a                	sd	t1,8(sp)
  80014e:	c202                	sw	zero,4(sp)
  800150:	176000ef          	jal	ra,8002c6 <vprintfmt>
  800154:	60e2                	ld	ra,24(sp)
  800156:	4512                	lw	a0,4(sp)
  800158:	6125                	addi	sp,sp,96
  80015a:	8082                	ret

000000000080015c <initfd>:
  80015c:	1101                	addi	sp,sp,-32
  80015e:	87ae                	mv	a5,a1
  800160:	e426                	sd	s1,8(sp)
  800162:	85b2                	mv	a1,a2
  800164:	84aa                	mv	s1,a0
  800166:	853e                	mv	a0,a5
  800168:	e822                	sd	s0,16(sp)
  80016a:	ec06                	sd	ra,24(sp)
  80016c:	f67ff0ef          	jal	ra,8000d2 <open>
  800170:	842a                	mv	s0,a0
  800172:	00054463          	bltz	a0,80017a <initfd+0x1e>
  800176:	00951863          	bne	a0,s1,800186 <initfd+0x2a>
  80017a:	8522                	mv	a0,s0
  80017c:	60e2                	ld	ra,24(sp)
  80017e:	6442                	ld	s0,16(sp)
  800180:	64a2                	ld	s1,8(sp)
  800182:	6105                	addi	sp,sp,32
  800184:	8082                	ret
  800186:	8526                	mv	a0,s1
  800188:	f53ff0ef          	jal	ra,8000da <close>
  80018c:	85a6                	mv	a1,s1
  80018e:	8522                	mv	a0,s0
  800190:	f4fff0ef          	jal	ra,8000de <dup2>
  800194:	84aa                	mv	s1,a0
  800196:	8522                	mv	a0,s0
  800198:	f43ff0ef          	jal	ra,8000da <close>
  80019c:	8426                	mv	s0,s1
  80019e:	bff1                	j	80017a <initfd+0x1e>

00000000008001a0 <umain>:
  8001a0:	1101                	addi	sp,sp,-32
  8001a2:	e822                	sd	s0,16(sp)
  8001a4:	e426                	sd	s1,8(sp)
  8001a6:	842a                	mv	s0,a0
  8001a8:	84ae                	mv	s1,a1
  8001aa:	4601                	li	a2,0
  8001ac:	00000597          	auipc	a1,0x0
  8001b0:	50c58593          	addi	a1,a1,1292 # 8006b8 <main+0x46>
  8001b4:	4501                	li	a0,0
  8001b6:	ec06                	sd	ra,24(sp)
  8001b8:	fa5ff0ef          	jal	ra,80015c <initfd>
  8001bc:	02054263          	bltz	a0,8001e0 <umain+0x40>
  8001c0:	4605                	li	a2,1
  8001c2:	00000597          	auipc	a1,0x0
  8001c6:	53658593          	addi	a1,a1,1334 # 8006f8 <main+0x86>
  8001ca:	4505                	li	a0,1
  8001cc:	f91ff0ef          	jal	ra,80015c <initfd>
  8001d0:	02054563          	bltz	a0,8001fa <umain+0x5a>
  8001d4:	85a6                	mv	a1,s1
  8001d6:	8522                	mv	a0,s0
  8001d8:	49a000ef          	jal	ra,800672 <main>
  8001dc:	038000ef          	jal	ra,800214 <exit>
  8001e0:	86aa                	mv	a3,a0
  8001e2:	00000617          	auipc	a2,0x0
  8001e6:	4de60613          	addi	a2,a2,1246 # 8006c0 <main+0x4e>
  8001ea:	45e9                	li	a1,26
  8001ec:	00000517          	auipc	a0,0x0
  8001f0:	4f450513          	addi	a0,a0,1268 # 8006e0 <main+0x6e>
  8001f4:	e2dff0ef          	jal	ra,800020 <__warn>
  8001f8:	b7e1                	j	8001c0 <umain+0x20>
  8001fa:	86aa                	mv	a3,a0
  8001fc:	00000617          	auipc	a2,0x0
  800200:	50460613          	addi	a2,a2,1284 # 800700 <main+0x8e>
  800204:	45f5                	li	a1,29
  800206:	00000517          	auipc	a0,0x0
  80020a:	4da50513          	addi	a0,a0,1242 # 8006e0 <main+0x6e>
  80020e:	e13ff0ef          	jal	ra,800020 <__warn>
  800212:	b7c9                	j	8001d4 <umain+0x34>

0000000000800214 <exit>:
  800214:	1141                	addi	sp,sp,-16
  800216:	e406                	sd	ra,8(sp)
  800218:	e83ff0ef          	jal	ra,80009a <sys_exit>
  80021c:	00000517          	auipc	a0,0x0
  800220:	50450513          	addi	a0,a0,1284 # 800720 <main+0xae>
  800224:	effff0ef          	jal	ra,800122 <cprintf>
  800228:	a001                	j	800228 <exit+0x14>

000000000080022a <strnlen>:
  80022a:	c185                	beqz	a1,80024a <strnlen+0x20>
  80022c:	00054783          	lbu	a5,0(a0)
  800230:	cf89                	beqz	a5,80024a <strnlen+0x20>
  800232:	4781                	li	a5,0
  800234:	a021                	j	80023c <strnlen+0x12>
  800236:	00074703          	lbu	a4,0(a4)
  80023a:	c711                	beqz	a4,800246 <strnlen+0x1c>
  80023c:	0785                	addi	a5,a5,1
  80023e:	00f50733          	add	a4,a0,a5
  800242:	fef59ae3          	bne	a1,a5,800236 <strnlen+0xc>
  800246:	853e                	mv	a0,a5
  800248:	8082                	ret
  80024a:	4781                	li	a5,0
  80024c:	853e                	mv	a0,a5
  80024e:	8082                	ret

0000000000800250 <printnum>:
  800250:	02071893          	slli	a7,a4,0x20
  800254:	7139                	addi	sp,sp,-64
  800256:	0208d893          	srli	a7,a7,0x20
  80025a:	e456                	sd	s5,8(sp)
  80025c:	0316fab3          	remu	s5,a3,a7
  800260:	f822                	sd	s0,48(sp)
  800262:	f426                	sd	s1,40(sp)
  800264:	f04a                	sd	s2,32(sp)
  800266:	ec4e                	sd	s3,24(sp)
  800268:	fc06                	sd	ra,56(sp)
  80026a:	e852                	sd	s4,16(sp)
  80026c:	84aa                	mv	s1,a0
  80026e:	89ae                	mv	s3,a1
  800270:	8932                	mv	s2,a2
  800272:	fff7841b          	addiw	s0,a5,-1
  800276:	2a81                	sext.w	s5,s5
  800278:	0516f163          	bleu	a7,a3,8002ba <printnum+0x6a>
  80027c:	8a42                	mv	s4,a6
  80027e:	00805863          	blez	s0,80028e <printnum+0x3e>
  800282:	347d                	addiw	s0,s0,-1
  800284:	864e                	mv	a2,s3
  800286:	85ca                	mv	a1,s2
  800288:	8552                	mv	a0,s4
  80028a:	9482                	jalr	s1
  80028c:	f87d                	bnez	s0,800282 <printnum+0x32>
  80028e:	1a82                	slli	s5,s5,0x20
  800290:	020ada93          	srli	s5,s5,0x20
  800294:	00000797          	auipc	a5,0x0
  800298:	6c478793          	addi	a5,a5,1732 # 800958 <error_string+0xc8>
  80029c:	9abe                	add	s5,s5,a5
  80029e:	7442                	ld	s0,48(sp)
  8002a0:	000ac503          	lbu	a0,0(s5)
  8002a4:	70e2                	ld	ra,56(sp)
  8002a6:	6a42                	ld	s4,16(sp)
  8002a8:	6aa2                	ld	s5,8(sp)
  8002aa:	864e                	mv	a2,s3
  8002ac:	85ca                	mv	a1,s2
  8002ae:	69e2                	ld	s3,24(sp)
  8002b0:	7902                	ld	s2,32(sp)
  8002b2:	8326                	mv	t1,s1
  8002b4:	74a2                	ld	s1,40(sp)
  8002b6:	6121                	addi	sp,sp,64
  8002b8:	8302                	jr	t1
  8002ba:	0316d6b3          	divu	a3,a3,a7
  8002be:	87a2                	mv	a5,s0
  8002c0:	f91ff0ef          	jal	ra,800250 <printnum>
  8002c4:	b7e9                	j	80028e <printnum+0x3e>

00000000008002c6 <vprintfmt>:
  8002c6:	7119                	addi	sp,sp,-128
  8002c8:	f4a6                	sd	s1,104(sp)
  8002ca:	f0ca                	sd	s2,96(sp)
  8002cc:	ecce                	sd	s3,88(sp)
  8002ce:	e4d6                	sd	s5,72(sp)
  8002d0:	e0da                	sd	s6,64(sp)
  8002d2:	fc5e                	sd	s7,56(sp)
  8002d4:	f862                	sd	s8,48(sp)
  8002d6:	ec6e                	sd	s11,24(sp)
  8002d8:	fc86                	sd	ra,120(sp)
  8002da:	f8a2                	sd	s0,112(sp)
  8002dc:	e8d2                	sd	s4,80(sp)
  8002de:	f466                	sd	s9,40(sp)
  8002e0:	f06a                	sd	s10,32(sp)
  8002e2:	89aa                	mv	s3,a0
  8002e4:	892e                	mv	s2,a1
  8002e6:	84b2                	mv	s1,a2
  8002e8:	8db6                	mv	s11,a3
  8002ea:	8b3a                	mv	s6,a4
  8002ec:	5bfd                	li	s7,-1
  8002ee:	00000a97          	auipc	s5,0x0
  8002f2:	446a8a93          	addi	s5,s5,1094 # 800734 <main+0xc2>
  8002f6:	05e00c13          	li	s8,94
  8002fa:	000dc503          	lbu	a0,0(s11)
  8002fe:	02500793          	li	a5,37
  800302:	001d8413          	addi	s0,s11,1
  800306:	00f50f63          	beq	a0,a5,800324 <vprintfmt+0x5e>
  80030a:	c529                	beqz	a0,800354 <vprintfmt+0x8e>
  80030c:	02500a13          	li	s4,37
  800310:	a011                	j	800314 <vprintfmt+0x4e>
  800312:	c129                	beqz	a0,800354 <vprintfmt+0x8e>
  800314:	864a                	mv	a2,s2
  800316:	85a6                	mv	a1,s1
  800318:	0405                	addi	s0,s0,1
  80031a:	9982                	jalr	s3
  80031c:	fff44503          	lbu	a0,-1(s0)
  800320:	ff4519e3          	bne	a0,s4,800312 <vprintfmt+0x4c>
  800324:	00044603          	lbu	a2,0(s0)
  800328:	02000813          	li	a6,32
  80032c:	4a01                	li	s4,0
  80032e:	4881                	li	a7,0
  800330:	5d7d                	li	s10,-1
  800332:	5cfd                	li	s9,-1
  800334:	05500593          	li	a1,85
  800338:	4525                	li	a0,9
  80033a:	fdd6071b          	addiw	a4,a2,-35
  80033e:	0ff77713          	andi	a4,a4,255
  800342:	00140d93          	addi	s11,s0,1
  800346:	22e5e363          	bltu	a1,a4,80056c <vprintfmt+0x2a6>
  80034a:	070a                	slli	a4,a4,0x2
  80034c:	9756                	add	a4,a4,s5
  80034e:	4318                	lw	a4,0(a4)
  800350:	9756                	add	a4,a4,s5
  800352:	8702                	jr	a4
  800354:	70e6                	ld	ra,120(sp)
  800356:	7446                	ld	s0,112(sp)
  800358:	74a6                	ld	s1,104(sp)
  80035a:	7906                	ld	s2,96(sp)
  80035c:	69e6                	ld	s3,88(sp)
  80035e:	6a46                	ld	s4,80(sp)
  800360:	6aa6                	ld	s5,72(sp)
  800362:	6b06                	ld	s6,64(sp)
  800364:	7be2                	ld	s7,56(sp)
  800366:	7c42                	ld	s8,48(sp)
  800368:	7ca2                	ld	s9,40(sp)
  80036a:	7d02                	ld	s10,32(sp)
  80036c:	6de2                	ld	s11,24(sp)
  80036e:	6109                	addi	sp,sp,128
  800370:	8082                	ret
  800372:	4705                	li	a4,1
  800374:	008b0613          	addi	a2,s6,8
  800378:	01174463          	blt	a4,a7,800380 <vprintfmt+0xba>
  80037c:	28088563          	beqz	a7,800606 <vprintfmt+0x340>
  800380:	000b3683          	ld	a3,0(s6)
  800384:	4741                	li	a4,16
  800386:	8b32                	mv	s6,a2
  800388:	a86d                	j	800442 <vprintfmt+0x17c>
  80038a:	00144603          	lbu	a2,1(s0)
  80038e:	4a05                	li	s4,1
  800390:	846e                	mv	s0,s11
  800392:	b765                	j	80033a <vprintfmt+0x74>
  800394:	000b2503          	lw	a0,0(s6)
  800398:	864a                	mv	a2,s2
  80039a:	85a6                	mv	a1,s1
  80039c:	0b21                	addi	s6,s6,8
  80039e:	9982                	jalr	s3
  8003a0:	bfa9                	j	8002fa <vprintfmt+0x34>
  8003a2:	4705                	li	a4,1
  8003a4:	008b0a13          	addi	s4,s6,8
  8003a8:	01174463          	blt	a4,a7,8003b0 <vprintfmt+0xea>
  8003ac:	24088563          	beqz	a7,8005f6 <vprintfmt+0x330>
  8003b0:	000b3403          	ld	s0,0(s6)
  8003b4:	26044563          	bltz	s0,80061e <vprintfmt+0x358>
  8003b8:	86a2                	mv	a3,s0
  8003ba:	8b52                	mv	s6,s4
  8003bc:	4729                	li	a4,10
  8003be:	a051                	j	800442 <vprintfmt+0x17c>
  8003c0:	000b2783          	lw	a5,0(s6)
  8003c4:	46e1                	li	a3,24
  8003c6:	0b21                	addi	s6,s6,8
  8003c8:	41f7d71b          	sraiw	a4,a5,0x1f
  8003cc:	8fb9                	xor	a5,a5,a4
  8003ce:	40e7873b          	subw	a4,a5,a4
  8003d2:	1ce6c163          	blt	a3,a4,800594 <vprintfmt+0x2ce>
  8003d6:	00371793          	slli	a5,a4,0x3
  8003da:	00000697          	auipc	a3,0x0
  8003de:	4b668693          	addi	a3,a3,1206 # 800890 <error_string>
  8003e2:	97b6                	add	a5,a5,a3
  8003e4:	639c                	ld	a5,0(a5)
  8003e6:	1a078763          	beqz	a5,800594 <vprintfmt+0x2ce>
  8003ea:	873e                	mv	a4,a5
  8003ec:	00000697          	auipc	a3,0x0
  8003f0:	77468693          	addi	a3,a3,1908 # 800b60 <error_string+0x2d0>
  8003f4:	8626                	mv	a2,s1
  8003f6:	85ca                	mv	a1,s2
  8003f8:	854e                	mv	a0,s3
  8003fa:	25a000ef          	jal	ra,800654 <printfmt>
  8003fe:	bdf5                	j	8002fa <vprintfmt+0x34>
  800400:	00144603          	lbu	a2,1(s0)
  800404:	2885                	addiw	a7,a7,1
  800406:	846e                	mv	s0,s11
  800408:	bf0d                	j	80033a <vprintfmt+0x74>
  80040a:	4705                	li	a4,1
  80040c:	008b0613          	addi	a2,s6,8
  800410:	01174463          	blt	a4,a7,800418 <vprintfmt+0x152>
  800414:	1e088e63          	beqz	a7,800610 <vprintfmt+0x34a>
  800418:	000b3683          	ld	a3,0(s6)
  80041c:	4721                	li	a4,8
  80041e:	8b32                	mv	s6,a2
  800420:	a00d                	j	800442 <vprintfmt+0x17c>
  800422:	03000513          	li	a0,48
  800426:	864a                	mv	a2,s2
  800428:	85a6                	mv	a1,s1
  80042a:	e042                	sd	a6,0(sp)
  80042c:	9982                	jalr	s3
  80042e:	864a                	mv	a2,s2
  800430:	85a6                	mv	a1,s1
  800432:	07800513          	li	a0,120
  800436:	9982                	jalr	s3
  800438:	0b21                	addi	s6,s6,8
  80043a:	ff8b3683          	ld	a3,-8(s6)
  80043e:	6802                	ld	a6,0(sp)
  800440:	4741                	li	a4,16
  800442:	87e6                	mv	a5,s9
  800444:	8626                	mv	a2,s1
  800446:	85ca                	mv	a1,s2
  800448:	854e                	mv	a0,s3
  80044a:	e07ff0ef          	jal	ra,800250 <printnum>
  80044e:	b575                	j	8002fa <vprintfmt+0x34>
  800450:	000b3703          	ld	a4,0(s6)
  800454:	0b21                	addi	s6,s6,8
  800456:	1e070063          	beqz	a4,800636 <vprintfmt+0x370>
  80045a:	00170413          	addi	s0,a4,1
  80045e:	19905563          	blez	s9,8005e8 <vprintfmt+0x322>
  800462:	02d00613          	li	a2,45
  800466:	14c81963          	bne	a6,a2,8005b8 <vprintfmt+0x2f2>
  80046a:	00074703          	lbu	a4,0(a4)
  80046e:	0007051b          	sext.w	a0,a4
  800472:	c90d                	beqz	a0,8004a4 <vprintfmt+0x1de>
  800474:	000d4563          	bltz	s10,80047e <vprintfmt+0x1b8>
  800478:	3d7d                	addiw	s10,s10,-1
  80047a:	037d0363          	beq	s10,s7,8004a0 <vprintfmt+0x1da>
  80047e:	864a                	mv	a2,s2
  800480:	85a6                	mv	a1,s1
  800482:	180a0c63          	beqz	s4,80061a <vprintfmt+0x354>
  800486:	3701                	addiw	a4,a4,-32
  800488:	18ec7963          	bleu	a4,s8,80061a <vprintfmt+0x354>
  80048c:	03f00513          	li	a0,63
  800490:	9982                	jalr	s3
  800492:	0405                	addi	s0,s0,1
  800494:	fff44703          	lbu	a4,-1(s0)
  800498:	3cfd                	addiw	s9,s9,-1
  80049a:	0007051b          	sext.w	a0,a4
  80049e:	f979                	bnez	a0,800474 <vprintfmt+0x1ae>
  8004a0:	e5905de3          	blez	s9,8002fa <vprintfmt+0x34>
  8004a4:	3cfd                	addiw	s9,s9,-1
  8004a6:	864a                	mv	a2,s2
  8004a8:	85a6                	mv	a1,s1
  8004aa:	02000513          	li	a0,32
  8004ae:	9982                	jalr	s3
  8004b0:	e40c85e3          	beqz	s9,8002fa <vprintfmt+0x34>
  8004b4:	3cfd                	addiw	s9,s9,-1
  8004b6:	864a                	mv	a2,s2
  8004b8:	85a6                	mv	a1,s1
  8004ba:	02000513          	li	a0,32
  8004be:	9982                	jalr	s3
  8004c0:	fe0c92e3          	bnez	s9,8004a4 <vprintfmt+0x1de>
  8004c4:	bd1d                	j	8002fa <vprintfmt+0x34>
  8004c6:	4705                	li	a4,1
  8004c8:	008b0613          	addi	a2,s6,8
  8004cc:	01174463          	blt	a4,a7,8004d4 <vprintfmt+0x20e>
  8004d0:	12088663          	beqz	a7,8005fc <vprintfmt+0x336>
  8004d4:	000b3683          	ld	a3,0(s6)
  8004d8:	4729                	li	a4,10
  8004da:	8b32                	mv	s6,a2
  8004dc:	b79d                	j	800442 <vprintfmt+0x17c>
  8004de:	00144603          	lbu	a2,1(s0)
  8004e2:	02d00813          	li	a6,45
  8004e6:	846e                	mv	s0,s11
  8004e8:	bd89                	j	80033a <vprintfmt+0x74>
  8004ea:	864a                	mv	a2,s2
  8004ec:	85a6                	mv	a1,s1
  8004ee:	02500513          	li	a0,37
  8004f2:	9982                	jalr	s3
  8004f4:	b519                	j	8002fa <vprintfmt+0x34>
  8004f6:	000b2d03          	lw	s10,0(s6)
  8004fa:	00144603          	lbu	a2,1(s0)
  8004fe:	0b21                	addi	s6,s6,8
  800500:	846e                	mv	s0,s11
  800502:	e20cdce3          	bgez	s9,80033a <vprintfmt+0x74>
  800506:	8cea                	mv	s9,s10
  800508:	5d7d                	li	s10,-1
  80050a:	bd05                	j	80033a <vprintfmt+0x74>
  80050c:	00144603          	lbu	a2,1(s0)
  800510:	03000813          	li	a6,48
  800514:	846e                	mv	s0,s11
  800516:	b515                	j	80033a <vprintfmt+0x74>
  800518:	fd060d1b          	addiw	s10,a2,-48
  80051c:	00144603          	lbu	a2,1(s0)
  800520:	846e                	mv	s0,s11
  800522:	fd06071b          	addiw	a4,a2,-48
  800526:	0006031b          	sext.w	t1,a2
  80052a:	fce56ce3          	bltu	a0,a4,800502 <vprintfmt+0x23c>
  80052e:	0405                	addi	s0,s0,1
  800530:	002d171b          	slliw	a4,s10,0x2
  800534:	00044603          	lbu	a2,0(s0)
  800538:	01a706bb          	addw	a3,a4,s10
  80053c:	0016969b          	slliw	a3,a3,0x1
  800540:	006686bb          	addw	a3,a3,t1
  800544:	fd06071b          	addiw	a4,a2,-48
  800548:	fd068d1b          	addiw	s10,a3,-48
  80054c:	0006031b          	sext.w	t1,a2
  800550:	fce57fe3          	bleu	a4,a0,80052e <vprintfmt+0x268>
  800554:	b77d                	j	800502 <vprintfmt+0x23c>
  800556:	fffcc713          	not	a4,s9
  80055a:	977d                	srai	a4,a4,0x3f
  80055c:	00ecf7b3          	and	a5,s9,a4
  800560:	00144603          	lbu	a2,1(s0)
  800564:	00078c9b          	sext.w	s9,a5
  800568:	846e                	mv	s0,s11
  80056a:	bbc1                	j	80033a <vprintfmt+0x74>
  80056c:	864a                	mv	a2,s2
  80056e:	85a6                	mv	a1,s1
  800570:	02500513          	li	a0,37
  800574:	9982                	jalr	s3
  800576:	fff44703          	lbu	a4,-1(s0)
  80057a:	02500793          	li	a5,37
  80057e:	8da2                	mv	s11,s0
  800580:	d6f70de3          	beq	a4,a5,8002fa <vprintfmt+0x34>
  800584:	02500713          	li	a4,37
  800588:	1dfd                	addi	s11,s11,-1
  80058a:	fffdc783          	lbu	a5,-1(s11)
  80058e:	fee79de3          	bne	a5,a4,800588 <vprintfmt+0x2c2>
  800592:	b3a5                	j	8002fa <vprintfmt+0x34>
  800594:	00000697          	auipc	a3,0x0
  800598:	5bc68693          	addi	a3,a3,1468 # 800b50 <error_string+0x2c0>
  80059c:	8626                	mv	a2,s1
  80059e:	85ca                	mv	a1,s2
  8005a0:	854e                	mv	a0,s3
  8005a2:	0b2000ef          	jal	ra,800654 <printfmt>
  8005a6:	bb91                	j	8002fa <vprintfmt+0x34>
  8005a8:	00000717          	auipc	a4,0x0
  8005ac:	5a070713          	addi	a4,a4,1440 # 800b48 <error_string+0x2b8>
  8005b0:	00000417          	auipc	s0,0x0
  8005b4:	59940413          	addi	s0,s0,1433 # 800b49 <error_string+0x2b9>
  8005b8:	853a                	mv	a0,a4
  8005ba:	85ea                	mv	a1,s10
  8005bc:	e03a                	sd	a4,0(sp)
  8005be:	e442                	sd	a6,8(sp)
  8005c0:	c6bff0ef          	jal	ra,80022a <strnlen>
  8005c4:	40ac8cbb          	subw	s9,s9,a0
  8005c8:	6702                	ld	a4,0(sp)
  8005ca:	01905f63          	blez	s9,8005e8 <vprintfmt+0x322>
  8005ce:	6822                	ld	a6,8(sp)
  8005d0:	0008079b          	sext.w	a5,a6
  8005d4:	e43e                	sd	a5,8(sp)
  8005d6:	6522                	ld	a0,8(sp)
  8005d8:	864a                	mv	a2,s2
  8005da:	85a6                	mv	a1,s1
  8005dc:	e03a                	sd	a4,0(sp)
  8005de:	3cfd                	addiw	s9,s9,-1
  8005e0:	9982                	jalr	s3
  8005e2:	6702                	ld	a4,0(sp)
  8005e4:	fe0c99e3          	bnez	s9,8005d6 <vprintfmt+0x310>
  8005e8:	00074703          	lbu	a4,0(a4)
  8005ec:	0007051b          	sext.w	a0,a4
  8005f0:	e80512e3          	bnez	a0,800474 <vprintfmt+0x1ae>
  8005f4:	b319                	j	8002fa <vprintfmt+0x34>
  8005f6:	000b2403          	lw	s0,0(s6)
  8005fa:	bb6d                	j	8003b4 <vprintfmt+0xee>
  8005fc:	000b6683          	lwu	a3,0(s6)
  800600:	4729                	li	a4,10
  800602:	8b32                	mv	s6,a2
  800604:	bd3d                	j	800442 <vprintfmt+0x17c>
  800606:	000b6683          	lwu	a3,0(s6)
  80060a:	4741                	li	a4,16
  80060c:	8b32                	mv	s6,a2
  80060e:	bd15                	j	800442 <vprintfmt+0x17c>
  800610:	000b6683          	lwu	a3,0(s6)
  800614:	4721                	li	a4,8
  800616:	8b32                	mv	s6,a2
  800618:	b52d                	j	800442 <vprintfmt+0x17c>
  80061a:	9982                	jalr	s3
  80061c:	bd9d                	j	800492 <vprintfmt+0x1cc>
  80061e:	864a                	mv	a2,s2
  800620:	85a6                	mv	a1,s1
  800622:	02d00513          	li	a0,45
  800626:	e042                	sd	a6,0(sp)
  800628:	9982                	jalr	s3
  80062a:	8b52                	mv	s6,s4
  80062c:	408006b3          	neg	a3,s0
  800630:	4729                	li	a4,10
  800632:	6802                	ld	a6,0(sp)
  800634:	b539                	j	800442 <vprintfmt+0x17c>
  800636:	01905663          	blez	s9,800642 <vprintfmt+0x37c>
  80063a:	02d00713          	li	a4,45
  80063e:	f6e815e3          	bne	a6,a4,8005a8 <vprintfmt+0x2e2>
  800642:	00000417          	auipc	s0,0x0
  800646:	50740413          	addi	s0,s0,1287 # 800b49 <error_string+0x2b9>
  80064a:	02800513          	li	a0,40
  80064e:	02800713          	li	a4,40
  800652:	b50d                	j	800474 <vprintfmt+0x1ae>

0000000000800654 <printfmt>:
  800654:	7139                	addi	sp,sp,-64
  800656:	02010313          	addi	t1,sp,32
  80065a:	f03a                	sd	a4,32(sp)
  80065c:	871a                	mv	a4,t1
  80065e:	ec06                	sd	ra,24(sp)
  800660:	f43e                	sd	a5,40(sp)
  800662:	f842                	sd	a6,48(sp)
  800664:	fc46                	sd	a7,56(sp)
  800666:	e41a                	sd	t1,8(sp)
  800668:	c5fff0ef          	jal	ra,8002c6 <vprintfmt>
  80066c:	60e2                	ld	ra,24(sp)
  80066e:	6121                	addi	sp,sp,64
  800670:	8082                	ret

0000000000800672 <main>:
  800672:	00002783          	lw	a5,0(zero) # 0 <__warn-0x800020>
  800676:	9002                	ebreak
