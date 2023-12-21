
obj/__user_waitkill.out：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000800020 <__panic>:
  800020:	715d                	addi	sp,sp,-80
  800022:	e822                	sd	s0,16(sp)
  800024:	fc3e                	sd	a5,56(sp)
  800026:	8432                	mv	s0,a2
  800028:	103c                	addi	a5,sp,40
  80002a:	862e                	mv	a2,a1
  80002c:	85aa                	mv	a1,a0
  80002e:	00001517          	auipc	a0,0x1
  800032:	80250513          	addi	a0,a0,-2046 # 800830 <main+0xb8>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	144000ef          	jal	ra,800186 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	116000ef          	jal	ra,800160 <vcprintf>
  80004e:	00001517          	auipc	a0,0x1
  800052:	cda50513          	addi	a0,a0,-806 # 800d28 <error_string+0x2e0>
  800056:	130000ef          	jal	ra,800186 <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	21c000ef          	jal	ra,800278 <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00000517          	auipc	a0,0x0
  800072:	7e250513          	addi	a0,a0,2018 # 800850 <main+0xd8>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	104000ef          	jal	ra,800186 <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	0d6000ef          	jal	ra,800160 <vcprintf>
  80008e:	00001517          	auipc	a0,0x1
  800092:	c9a50513          	addi	a0,a0,-870 # 800d28 <error_string+0x2e0>
  800096:	0f0000ef          	jal	ra,800186 <cprintf>
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

0000000000800100 <sys_getpid>:
  800100:	4549                	li	a0,18
  800102:	fa1ff06f          	j	8000a2 <syscall>

0000000000800106 <sys_putc>:
  800106:	85aa                	mv	a1,a0
  800108:	4579                	li	a0,30
  80010a:	f99ff06f          	j	8000a2 <syscall>

000000000080010e <sys_open>:
  80010e:	862e                	mv	a2,a1
  800110:	85aa                	mv	a1,a0
  800112:	06400513          	li	a0,100
  800116:	f8dff06f          	j	8000a2 <syscall>

000000000080011a <sys_close>:
  80011a:	85aa                	mv	a1,a0
  80011c:	06500513          	li	a0,101
  800120:	f83ff06f          	j	8000a2 <syscall>

0000000000800124 <sys_dup>:
  800124:	862e                	mv	a2,a1
  800126:	85aa                	mv	a1,a0
  800128:	08200513          	li	a0,130
  80012c:	f77ff06f          	j	8000a2 <syscall>

0000000000800130 <_start>:
  800130:	0d4000ef          	jal	ra,800204 <umain>
  800134:	a001                	j	800134 <_start+0x4>

0000000000800136 <open>:
  800136:	1582                	slli	a1,a1,0x20
  800138:	9181                	srli	a1,a1,0x20
  80013a:	fd5ff06f          	j	80010e <sys_open>

000000000080013e <close>:
  80013e:	fddff06f          	j	80011a <sys_close>

0000000000800142 <dup2>:
  800142:	fe3ff06f          	j	800124 <sys_dup>

0000000000800146 <cputch>:
  800146:	1141                	addi	sp,sp,-16
  800148:	e022                	sd	s0,0(sp)
  80014a:	e406                	sd	ra,8(sp)
  80014c:	842e                	mv	s0,a1
  80014e:	fb9ff0ef          	jal	ra,800106 <sys_putc>
  800152:	401c                	lw	a5,0(s0)
  800154:	60a2                	ld	ra,8(sp)
  800156:	2785                	addiw	a5,a5,1
  800158:	c01c                	sw	a5,0(s0)
  80015a:	6402                	ld	s0,0(sp)
  80015c:	0141                	addi	sp,sp,16
  80015e:	8082                	ret

0000000000800160 <vcprintf>:
  800160:	1101                	addi	sp,sp,-32
  800162:	872e                	mv	a4,a1
  800164:	75dd                	lui	a1,0xffff7
  800166:	86aa                	mv	a3,a0
  800168:	0070                	addi	a2,sp,12
  80016a:	00000517          	auipc	a0,0x0
  80016e:	fdc50513          	addi	a0,a0,-36 # 800146 <cputch>
  800172:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <pid1+0xffffffffff7f5ad1>
  800176:	ec06                	sd	ra,24(sp)
  800178:	c602                	sw	zero,12(sp)
  80017a:	1c4000ef          	jal	ra,80033e <vprintfmt>
  80017e:	60e2                	ld	ra,24(sp)
  800180:	4532                	lw	a0,12(sp)
  800182:	6105                	addi	sp,sp,32
  800184:	8082                	ret

0000000000800186 <cprintf>:
  800186:	711d                	addi	sp,sp,-96
  800188:	02810313          	addi	t1,sp,40
  80018c:	f42e                	sd	a1,40(sp)
  80018e:	75dd                	lui	a1,0xffff7
  800190:	f832                	sd	a2,48(sp)
  800192:	fc36                	sd	a3,56(sp)
  800194:	e0ba                	sd	a4,64(sp)
  800196:	86aa                	mv	a3,a0
  800198:	0050                	addi	a2,sp,4
  80019a:	00000517          	auipc	a0,0x0
  80019e:	fac50513          	addi	a0,a0,-84 # 800146 <cputch>
  8001a2:	871a                	mv	a4,t1
  8001a4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <pid1+0xffffffffff7f5ad1>
  8001a8:	ec06                	sd	ra,24(sp)
  8001aa:	e4be                	sd	a5,72(sp)
  8001ac:	e8c2                	sd	a6,80(sp)
  8001ae:	ecc6                	sd	a7,88(sp)
  8001b0:	e41a                	sd	t1,8(sp)
  8001b2:	c202                	sw	zero,4(sp)
  8001b4:	18a000ef          	jal	ra,80033e <vprintfmt>
  8001b8:	60e2                	ld	ra,24(sp)
  8001ba:	4512                	lw	a0,4(sp)
  8001bc:	6125                	addi	sp,sp,96
  8001be:	8082                	ret

00000000008001c0 <initfd>:
  8001c0:	1101                	addi	sp,sp,-32
  8001c2:	87ae                	mv	a5,a1
  8001c4:	e426                	sd	s1,8(sp)
  8001c6:	85b2                	mv	a1,a2
  8001c8:	84aa                	mv	s1,a0
  8001ca:	853e                	mv	a0,a5
  8001cc:	e822                	sd	s0,16(sp)
  8001ce:	ec06                	sd	ra,24(sp)
  8001d0:	f67ff0ef          	jal	ra,800136 <open>
  8001d4:	842a                	mv	s0,a0
  8001d6:	00054463          	bltz	a0,8001de <initfd+0x1e>
  8001da:	00951863          	bne	a0,s1,8001ea <initfd+0x2a>
  8001de:	8522                	mv	a0,s0
  8001e0:	60e2                	ld	ra,24(sp)
  8001e2:	6442                	ld	s0,16(sp)
  8001e4:	64a2                	ld	s1,8(sp)
  8001e6:	6105                	addi	sp,sp,32
  8001e8:	8082                	ret
  8001ea:	8526                	mv	a0,s1
  8001ec:	f53ff0ef          	jal	ra,80013e <close>
  8001f0:	85a6                	mv	a1,s1
  8001f2:	8522                	mv	a0,s0
  8001f4:	f4fff0ef          	jal	ra,800142 <dup2>
  8001f8:	84aa                	mv	s1,a0
  8001fa:	8522                	mv	a0,s0
  8001fc:	f43ff0ef          	jal	ra,80013e <close>
  800200:	8426                	mv	s0,s1
  800202:	bff1                	j	8001de <initfd+0x1e>

0000000000800204 <umain>:
  800204:	1101                	addi	sp,sp,-32
  800206:	e822                	sd	s0,16(sp)
  800208:	e426                	sd	s1,8(sp)
  80020a:	842a                	mv	s0,a0
  80020c:	84ae                	mv	s1,a1
  80020e:	4601                	li	a2,0
  800210:	00000597          	auipc	a1,0x0
  800214:	66058593          	addi	a1,a1,1632 # 800870 <main+0xf8>
  800218:	4501                	li	a0,0
  80021a:	ec06                	sd	ra,24(sp)
  80021c:	fa5ff0ef          	jal	ra,8001c0 <initfd>
  800220:	02054263          	bltz	a0,800244 <umain+0x40>
  800224:	4605                	li	a2,1
  800226:	00000597          	auipc	a1,0x0
  80022a:	68a58593          	addi	a1,a1,1674 # 8008b0 <main+0x138>
  80022e:	4505                	li	a0,1
  800230:	f91ff0ef          	jal	ra,8001c0 <initfd>
  800234:	02054563          	bltz	a0,80025e <umain+0x5a>
  800238:	85a6                	mv	a1,s1
  80023a:	8522                	mv	a0,s0
  80023c:	53c000ef          	jal	ra,800778 <main>
  800240:	038000ef          	jal	ra,800278 <exit>
  800244:	86aa                	mv	a3,a0
  800246:	00000617          	auipc	a2,0x0
  80024a:	63260613          	addi	a2,a2,1586 # 800878 <main+0x100>
  80024e:	45e9                	li	a1,26
  800250:	00000517          	auipc	a0,0x0
  800254:	64850513          	addi	a0,a0,1608 # 800898 <main+0x120>
  800258:	e09ff0ef          	jal	ra,800060 <__warn>
  80025c:	b7e1                	j	800224 <umain+0x20>
  80025e:	86aa                	mv	a3,a0
  800260:	00000617          	auipc	a2,0x0
  800264:	65860613          	addi	a2,a2,1624 # 8008b8 <main+0x140>
  800268:	45f5                	li	a1,29
  80026a:	00000517          	auipc	a0,0x0
  80026e:	62e50513          	addi	a0,a0,1582 # 800898 <main+0x120>
  800272:	defff0ef          	jal	ra,800060 <__warn>
  800276:	b7c9                	j	800238 <umain+0x34>

0000000000800278 <exit>:
  800278:	1141                	addi	sp,sp,-16
  80027a:	e406                	sd	ra,8(sp)
  80027c:	e5fff0ef          	jal	ra,8000da <sys_exit>
  800280:	00000517          	auipc	a0,0x0
  800284:	65850513          	addi	a0,a0,1624 # 8008d8 <main+0x160>
  800288:	effff0ef          	jal	ra,800186 <cprintf>
  80028c:	a001                	j	80028c <exit+0x14>

000000000080028e <fork>:
  80028e:	e55ff06f          	j	8000e2 <sys_fork>

0000000000800292 <waitpid>:
  800292:	e57ff06f          	j	8000e8 <sys_wait>

0000000000800296 <yield>:
  800296:	e5dff06f          	j	8000f2 <sys_yield>

000000000080029a <kill>:
  80029a:	e5fff06f          	j	8000f8 <sys_kill>

000000000080029e <getpid>:
  80029e:	e63ff06f          	j	800100 <sys_getpid>

00000000008002a2 <strnlen>:
  8002a2:	c185                	beqz	a1,8002c2 <strnlen+0x20>
  8002a4:	00054783          	lbu	a5,0(a0)
  8002a8:	cf89                	beqz	a5,8002c2 <strnlen+0x20>
  8002aa:	4781                	li	a5,0
  8002ac:	a021                	j	8002b4 <strnlen+0x12>
  8002ae:	00074703          	lbu	a4,0(a4)
  8002b2:	c711                	beqz	a4,8002be <strnlen+0x1c>
  8002b4:	0785                	addi	a5,a5,1
  8002b6:	00f50733          	add	a4,a0,a5
  8002ba:	fef59ae3          	bne	a1,a5,8002ae <strnlen+0xc>
  8002be:	853e                	mv	a0,a5
  8002c0:	8082                	ret
  8002c2:	4781                	li	a5,0
  8002c4:	853e                	mv	a0,a5
  8002c6:	8082                	ret

00000000008002c8 <printnum>:
  8002c8:	02071893          	slli	a7,a4,0x20
  8002cc:	7139                	addi	sp,sp,-64
  8002ce:	0208d893          	srli	a7,a7,0x20
  8002d2:	e456                	sd	s5,8(sp)
  8002d4:	0316fab3          	remu	s5,a3,a7
  8002d8:	f822                	sd	s0,48(sp)
  8002da:	f426                	sd	s1,40(sp)
  8002dc:	f04a                	sd	s2,32(sp)
  8002de:	ec4e                	sd	s3,24(sp)
  8002e0:	fc06                	sd	ra,56(sp)
  8002e2:	e852                	sd	s4,16(sp)
  8002e4:	84aa                	mv	s1,a0
  8002e6:	89ae                	mv	s3,a1
  8002e8:	8932                	mv	s2,a2
  8002ea:	fff7841b          	addiw	s0,a5,-1
  8002ee:	2a81                	sext.w	s5,s5
  8002f0:	0516f163          	bleu	a7,a3,800332 <printnum+0x6a>
  8002f4:	8a42                	mv	s4,a6
  8002f6:	00805863          	blez	s0,800306 <printnum+0x3e>
  8002fa:	347d                	addiw	s0,s0,-1
  8002fc:	864e                	mv	a2,s3
  8002fe:	85ca                	mv	a1,s2
  800300:	8552                	mv	a0,s4
  800302:	9482                	jalr	s1
  800304:	f87d                	bnez	s0,8002fa <printnum+0x32>
  800306:	1a82                	slli	s5,s5,0x20
  800308:	020ada93          	srli	s5,s5,0x20
  80030c:	00001797          	auipc	a5,0x1
  800310:	80478793          	addi	a5,a5,-2044 # 800b10 <error_string+0xc8>
  800314:	9abe                	add	s5,s5,a5
  800316:	7442                	ld	s0,48(sp)
  800318:	000ac503          	lbu	a0,0(s5)
  80031c:	70e2                	ld	ra,56(sp)
  80031e:	6a42                	ld	s4,16(sp)
  800320:	6aa2                	ld	s5,8(sp)
  800322:	864e                	mv	a2,s3
  800324:	85ca                	mv	a1,s2
  800326:	69e2                	ld	s3,24(sp)
  800328:	7902                	ld	s2,32(sp)
  80032a:	8326                	mv	t1,s1
  80032c:	74a2                	ld	s1,40(sp)
  80032e:	6121                	addi	sp,sp,64
  800330:	8302                	jr	t1
  800332:	0316d6b3          	divu	a3,a3,a7
  800336:	87a2                	mv	a5,s0
  800338:	f91ff0ef          	jal	ra,8002c8 <printnum>
  80033c:	b7e9                	j	800306 <printnum+0x3e>

000000000080033e <vprintfmt>:
  80033e:	7119                	addi	sp,sp,-128
  800340:	f4a6                	sd	s1,104(sp)
  800342:	f0ca                	sd	s2,96(sp)
  800344:	ecce                	sd	s3,88(sp)
  800346:	e4d6                	sd	s5,72(sp)
  800348:	e0da                	sd	s6,64(sp)
  80034a:	fc5e                	sd	s7,56(sp)
  80034c:	f862                	sd	s8,48(sp)
  80034e:	ec6e                	sd	s11,24(sp)
  800350:	fc86                	sd	ra,120(sp)
  800352:	f8a2                	sd	s0,112(sp)
  800354:	e8d2                	sd	s4,80(sp)
  800356:	f466                	sd	s9,40(sp)
  800358:	f06a                	sd	s10,32(sp)
  80035a:	89aa                	mv	s3,a0
  80035c:	892e                	mv	s2,a1
  80035e:	84b2                	mv	s1,a2
  800360:	8db6                	mv	s11,a3
  800362:	8b3a                	mv	s6,a4
  800364:	5bfd                	li	s7,-1
  800366:	00000a97          	auipc	s5,0x0
  80036a:	586a8a93          	addi	s5,s5,1414 # 8008ec <main+0x174>
  80036e:	05e00c13          	li	s8,94
  800372:	000dc503          	lbu	a0,0(s11)
  800376:	02500793          	li	a5,37
  80037a:	001d8413          	addi	s0,s11,1
  80037e:	00f50f63          	beq	a0,a5,80039c <vprintfmt+0x5e>
  800382:	c529                	beqz	a0,8003cc <vprintfmt+0x8e>
  800384:	02500a13          	li	s4,37
  800388:	a011                	j	80038c <vprintfmt+0x4e>
  80038a:	c129                	beqz	a0,8003cc <vprintfmt+0x8e>
  80038c:	864a                	mv	a2,s2
  80038e:	85a6                	mv	a1,s1
  800390:	0405                	addi	s0,s0,1
  800392:	9982                	jalr	s3
  800394:	fff44503          	lbu	a0,-1(s0)
  800398:	ff4519e3          	bne	a0,s4,80038a <vprintfmt+0x4c>
  80039c:	00044603          	lbu	a2,0(s0)
  8003a0:	02000813          	li	a6,32
  8003a4:	4a01                	li	s4,0
  8003a6:	4881                	li	a7,0
  8003a8:	5d7d                	li	s10,-1
  8003aa:	5cfd                	li	s9,-1
  8003ac:	05500593          	li	a1,85
  8003b0:	4525                	li	a0,9
  8003b2:	fdd6071b          	addiw	a4,a2,-35
  8003b6:	0ff77713          	andi	a4,a4,255
  8003ba:	00140d93          	addi	s11,s0,1
  8003be:	22e5e363          	bltu	a1,a4,8005e4 <vprintfmt+0x2a6>
  8003c2:	070a                	slli	a4,a4,0x2
  8003c4:	9756                	add	a4,a4,s5
  8003c6:	4318                	lw	a4,0(a4)
  8003c8:	9756                	add	a4,a4,s5
  8003ca:	8702                	jr	a4
  8003cc:	70e6                	ld	ra,120(sp)
  8003ce:	7446                	ld	s0,112(sp)
  8003d0:	74a6                	ld	s1,104(sp)
  8003d2:	7906                	ld	s2,96(sp)
  8003d4:	69e6                	ld	s3,88(sp)
  8003d6:	6a46                	ld	s4,80(sp)
  8003d8:	6aa6                	ld	s5,72(sp)
  8003da:	6b06                	ld	s6,64(sp)
  8003dc:	7be2                	ld	s7,56(sp)
  8003de:	7c42                	ld	s8,48(sp)
  8003e0:	7ca2                	ld	s9,40(sp)
  8003e2:	7d02                	ld	s10,32(sp)
  8003e4:	6de2                	ld	s11,24(sp)
  8003e6:	6109                	addi	sp,sp,128
  8003e8:	8082                	ret
  8003ea:	4705                	li	a4,1
  8003ec:	008b0613          	addi	a2,s6,8
  8003f0:	01174463          	blt	a4,a7,8003f8 <vprintfmt+0xba>
  8003f4:	28088563          	beqz	a7,80067e <vprintfmt+0x340>
  8003f8:	000b3683          	ld	a3,0(s6)
  8003fc:	4741                	li	a4,16
  8003fe:	8b32                	mv	s6,a2
  800400:	a86d                	j	8004ba <vprintfmt+0x17c>
  800402:	00144603          	lbu	a2,1(s0)
  800406:	4a05                	li	s4,1
  800408:	846e                	mv	s0,s11
  80040a:	b765                	j	8003b2 <vprintfmt+0x74>
  80040c:	000b2503          	lw	a0,0(s6)
  800410:	864a                	mv	a2,s2
  800412:	85a6                	mv	a1,s1
  800414:	0b21                	addi	s6,s6,8
  800416:	9982                	jalr	s3
  800418:	bfa9                	j	800372 <vprintfmt+0x34>
  80041a:	4705                	li	a4,1
  80041c:	008b0a13          	addi	s4,s6,8
  800420:	01174463          	blt	a4,a7,800428 <vprintfmt+0xea>
  800424:	24088563          	beqz	a7,80066e <vprintfmt+0x330>
  800428:	000b3403          	ld	s0,0(s6)
  80042c:	26044563          	bltz	s0,800696 <vprintfmt+0x358>
  800430:	86a2                	mv	a3,s0
  800432:	8b52                	mv	s6,s4
  800434:	4729                	li	a4,10
  800436:	a051                	j	8004ba <vprintfmt+0x17c>
  800438:	000b2783          	lw	a5,0(s6)
  80043c:	46e1                	li	a3,24
  80043e:	0b21                	addi	s6,s6,8
  800440:	41f7d71b          	sraiw	a4,a5,0x1f
  800444:	8fb9                	xor	a5,a5,a4
  800446:	40e7873b          	subw	a4,a5,a4
  80044a:	1ce6c163          	blt	a3,a4,80060c <vprintfmt+0x2ce>
  80044e:	00371793          	slli	a5,a4,0x3
  800452:	00000697          	auipc	a3,0x0
  800456:	5f668693          	addi	a3,a3,1526 # 800a48 <error_string>
  80045a:	97b6                	add	a5,a5,a3
  80045c:	639c                	ld	a5,0(a5)
  80045e:	1a078763          	beqz	a5,80060c <vprintfmt+0x2ce>
  800462:	873e                	mv	a4,a5
  800464:	00001697          	auipc	a3,0x1
  800468:	8b468693          	addi	a3,a3,-1868 # 800d18 <error_string+0x2d0>
  80046c:	8626                	mv	a2,s1
  80046e:	85ca                	mv	a1,s2
  800470:	854e                	mv	a0,s3
  800472:	25a000ef          	jal	ra,8006cc <printfmt>
  800476:	bdf5                	j	800372 <vprintfmt+0x34>
  800478:	00144603          	lbu	a2,1(s0)
  80047c:	2885                	addiw	a7,a7,1
  80047e:	846e                	mv	s0,s11
  800480:	bf0d                	j	8003b2 <vprintfmt+0x74>
  800482:	4705                	li	a4,1
  800484:	008b0613          	addi	a2,s6,8
  800488:	01174463          	blt	a4,a7,800490 <vprintfmt+0x152>
  80048c:	1e088e63          	beqz	a7,800688 <vprintfmt+0x34a>
  800490:	000b3683          	ld	a3,0(s6)
  800494:	4721                	li	a4,8
  800496:	8b32                	mv	s6,a2
  800498:	a00d                	j	8004ba <vprintfmt+0x17c>
  80049a:	03000513          	li	a0,48
  80049e:	864a                	mv	a2,s2
  8004a0:	85a6                	mv	a1,s1
  8004a2:	e042                	sd	a6,0(sp)
  8004a4:	9982                	jalr	s3
  8004a6:	864a                	mv	a2,s2
  8004a8:	85a6                	mv	a1,s1
  8004aa:	07800513          	li	a0,120
  8004ae:	9982                	jalr	s3
  8004b0:	0b21                	addi	s6,s6,8
  8004b2:	ff8b3683          	ld	a3,-8(s6)
  8004b6:	6802                	ld	a6,0(sp)
  8004b8:	4741                	li	a4,16
  8004ba:	87e6                	mv	a5,s9
  8004bc:	8626                	mv	a2,s1
  8004be:	85ca                	mv	a1,s2
  8004c0:	854e                	mv	a0,s3
  8004c2:	e07ff0ef          	jal	ra,8002c8 <printnum>
  8004c6:	b575                	j	800372 <vprintfmt+0x34>
  8004c8:	000b3703          	ld	a4,0(s6)
  8004cc:	0b21                	addi	s6,s6,8
  8004ce:	1e070063          	beqz	a4,8006ae <vprintfmt+0x370>
  8004d2:	00170413          	addi	s0,a4,1
  8004d6:	19905563          	blez	s9,800660 <vprintfmt+0x322>
  8004da:	02d00613          	li	a2,45
  8004de:	14c81963          	bne	a6,a2,800630 <vprintfmt+0x2f2>
  8004e2:	00074703          	lbu	a4,0(a4)
  8004e6:	0007051b          	sext.w	a0,a4
  8004ea:	c90d                	beqz	a0,80051c <vprintfmt+0x1de>
  8004ec:	000d4563          	bltz	s10,8004f6 <vprintfmt+0x1b8>
  8004f0:	3d7d                	addiw	s10,s10,-1
  8004f2:	037d0363          	beq	s10,s7,800518 <vprintfmt+0x1da>
  8004f6:	864a                	mv	a2,s2
  8004f8:	85a6                	mv	a1,s1
  8004fa:	180a0c63          	beqz	s4,800692 <vprintfmt+0x354>
  8004fe:	3701                	addiw	a4,a4,-32
  800500:	18ec7963          	bleu	a4,s8,800692 <vprintfmt+0x354>
  800504:	03f00513          	li	a0,63
  800508:	9982                	jalr	s3
  80050a:	0405                	addi	s0,s0,1
  80050c:	fff44703          	lbu	a4,-1(s0)
  800510:	3cfd                	addiw	s9,s9,-1
  800512:	0007051b          	sext.w	a0,a4
  800516:	f979                	bnez	a0,8004ec <vprintfmt+0x1ae>
  800518:	e5905de3          	blez	s9,800372 <vprintfmt+0x34>
  80051c:	3cfd                	addiw	s9,s9,-1
  80051e:	864a                	mv	a2,s2
  800520:	85a6                	mv	a1,s1
  800522:	02000513          	li	a0,32
  800526:	9982                	jalr	s3
  800528:	e40c85e3          	beqz	s9,800372 <vprintfmt+0x34>
  80052c:	3cfd                	addiw	s9,s9,-1
  80052e:	864a                	mv	a2,s2
  800530:	85a6                	mv	a1,s1
  800532:	02000513          	li	a0,32
  800536:	9982                	jalr	s3
  800538:	fe0c92e3          	bnez	s9,80051c <vprintfmt+0x1de>
  80053c:	bd1d                	j	800372 <vprintfmt+0x34>
  80053e:	4705                	li	a4,1
  800540:	008b0613          	addi	a2,s6,8
  800544:	01174463          	blt	a4,a7,80054c <vprintfmt+0x20e>
  800548:	12088663          	beqz	a7,800674 <vprintfmt+0x336>
  80054c:	000b3683          	ld	a3,0(s6)
  800550:	4729                	li	a4,10
  800552:	8b32                	mv	s6,a2
  800554:	b79d                	j	8004ba <vprintfmt+0x17c>
  800556:	00144603          	lbu	a2,1(s0)
  80055a:	02d00813          	li	a6,45
  80055e:	846e                	mv	s0,s11
  800560:	bd89                	j	8003b2 <vprintfmt+0x74>
  800562:	864a                	mv	a2,s2
  800564:	85a6                	mv	a1,s1
  800566:	02500513          	li	a0,37
  80056a:	9982                	jalr	s3
  80056c:	b519                	j	800372 <vprintfmt+0x34>
  80056e:	000b2d03          	lw	s10,0(s6)
  800572:	00144603          	lbu	a2,1(s0)
  800576:	0b21                	addi	s6,s6,8
  800578:	846e                	mv	s0,s11
  80057a:	e20cdce3          	bgez	s9,8003b2 <vprintfmt+0x74>
  80057e:	8cea                	mv	s9,s10
  800580:	5d7d                	li	s10,-1
  800582:	bd05                	j	8003b2 <vprintfmt+0x74>
  800584:	00144603          	lbu	a2,1(s0)
  800588:	03000813          	li	a6,48
  80058c:	846e                	mv	s0,s11
  80058e:	b515                	j	8003b2 <vprintfmt+0x74>
  800590:	fd060d1b          	addiw	s10,a2,-48
  800594:	00144603          	lbu	a2,1(s0)
  800598:	846e                	mv	s0,s11
  80059a:	fd06071b          	addiw	a4,a2,-48
  80059e:	0006031b          	sext.w	t1,a2
  8005a2:	fce56ce3          	bltu	a0,a4,80057a <vprintfmt+0x23c>
  8005a6:	0405                	addi	s0,s0,1
  8005a8:	002d171b          	slliw	a4,s10,0x2
  8005ac:	00044603          	lbu	a2,0(s0)
  8005b0:	01a706bb          	addw	a3,a4,s10
  8005b4:	0016969b          	slliw	a3,a3,0x1
  8005b8:	006686bb          	addw	a3,a3,t1
  8005bc:	fd06071b          	addiw	a4,a2,-48
  8005c0:	fd068d1b          	addiw	s10,a3,-48
  8005c4:	0006031b          	sext.w	t1,a2
  8005c8:	fce57fe3          	bleu	a4,a0,8005a6 <vprintfmt+0x268>
  8005cc:	b77d                	j	80057a <vprintfmt+0x23c>
  8005ce:	fffcc713          	not	a4,s9
  8005d2:	977d                	srai	a4,a4,0x3f
  8005d4:	00ecf7b3          	and	a5,s9,a4
  8005d8:	00144603          	lbu	a2,1(s0)
  8005dc:	00078c9b          	sext.w	s9,a5
  8005e0:	846e                	mv	s0,s11
  8005e2:	bbc1                	j	8003b2 <vprintfmt+0x74>
  8005e4:	864a                	mv	a2,s2
  8005e6:	85a6                	mv	a1,s1
  8005e8:	02500513          	li	a0,37
  8005ec:	9982                	jalr	s3
  8005ee:	fff44703          	lbu	a4,-1(s0)
  8005f2:	02500793          	li	a5,37
  8005f6:	8da2                	mv	s11,s0
  8005f8:	d6f70de3          	beq	a4,a5,800372 <vprintfmt+0x34>
  8005fc:	02500713          	li	a4,37
  800600:	1dfd                	addi	s11,s11,-1
  800602:	fffdc783          	lbu	a5,-1(s11)
  800606:	fee79de3          	bne	a5,a4,800600 <vprintfmt+0x2c2>
  80060a:	b3a5                	j	800372 <vprintfmt+0x34>
  80060c:	00000697          	auipc	a3,0x0
  800610:	6fc68693          	addi	a3,a3,1788 # 800d08 <error_string+0x2c0>
  800614:	8626                	mv	a2,s1
  800616:	85ca                	mv	a1,s2
  800618:	854e                	mv	a0,s3
  80061a:	0b2000ef          	jal	ra,8006cc <printfmt>
  80061e:	bb91                	j	800372 <vprintfmt+0x34>
  800620:	00000717          	auipc	a4,0x0
  800624:	6e070713          	addi	a4,a4,1760 # 800d00 <error_string+0x2b8>
  800628:	00000417          	auipc	s0,0x0
  80062c:	6d940413          	addi	s0,s0,1753 # 800d01 <error_string+0x2b9>
  800630:	853a                	mv	a0,a4
  800632:	85ea                	mv	a1,s10
  800634:	e03a                	sd	a4,0(sp)
  800636:	e442                	sd	a6,8(sp)
  800638:	c6bff0ef          	jal	ra,8002a2 <strnlen>
  80063c:	40ac8cbb          	subw	s9,s9,a0
  800640:	6702                	ld	a4,0(sp)
  800642:	01905f63          	blez	s9,800660 <vprintfmt+0x322>
  800646:	6822                	ld	a6,8(sp)
  800648:	0008079b          	sext.w	a5,a6
  80064c:	e43e                	sd	a5,8(sp)
  80064e:	6522                	ld	a0,8(sp)
  800650:	864a                	mv	a2,s2
  800652:	85a6                	mv	a1,s1
  800654:	e03a                	sd	a4,0(sp)
  800656:	3cfd                	addiw	s9,s9,-1
  800658:	9982                	jalr	s3
  80065a:	6702                	ld	a4,0(sp)
  80065c:	fe0c99e3          	bnez	s9,80064e <vprintfmt+0x310>
  800660:	00074703          	lbu	a4,0(a4)
  800664:	0007051b          	sext.w	a0,a4
  800668:	e80512e3          	bnez	a0,8004ec <vprintfmt+0x1ae>
  80066c:	b319                	j	800372 <vprintfmt+0x34>
  80066e:	000b2403          	lw	s0,0(s6)
  800672:	bb6d                	j	80042c <vprintfmt+0xee>
  800674:	000b6683          	lwu	a3,0(s6)
  800678:	4729                	li	a4,10
  80067a:	8b32                	mv	s6,a2
  80067c:	bd3d                	j	8004ba <vprintfmt+0x17c>
  80067e:	000b6683          	lwu	a3,0(s6)
  800682:	4741                	li	a4,16
  800684:	8b32                	mv	s6,a2
  800686:	bd15                	j	8004ba <vprintfmt+0x17c>
  800688:	000b6683          	lwu	a3,0(s6)
  80068c:	4721                	li	a4,8
  80068e:	8b32                	mv	s6,a2
  800690:	b52d                	j	8004ba <vprintfmt+0x17c>
  800692:	9982                	jalr	s3
  800694:	bd9d                	j	80050a <vprintfmt+0x1cc>
  800696:	864a                	mv	a2,s2
  800698:	85a6                	mv	a1,s1
  80069a:	02d00513          	li	a0,45
  80069e:	e042                	sd	a6,0(sp)
  8006a0:	9982                	jalr	s3
  8006a2:	8b52                	mv	s6,s4
  8006a4:	408006b3          	neg	a3,s0
  8006a8:	4729                	li	a4,10
  8006aa:	6802                	ld	a6,0(sp)
  8006ac:	b539                	j	8004ba <vprintfmt+0x17c>
  8006ae:	01905663          	blez	s9,8006ba <vprintfmt+0x37c>
  8006b2:	02d00713          	li	a4,45
  8006b6:	f6e815e3          	bne	a6,a4,800620 <vprintfmt+0x2e2>
  8006ba:	00000417          	auipc	s0,0x0
  8006be:	64740413          	addi	s0,s0,1607 # 800d01 <error_string+0x2b9>
  8006c2:	02800513          	li	a0,40
  8006c6:	02800713          	li	a4,40
  8006ca:	b50d                	j	8004ec <vprintfmt+0x1ae>

00000000008006cc <printfmt>:
  8006cc:	7139                	addi	sp,sp,-64
  8006ce:	02010313          	addi	t1,sp,32
  8006d2:	f03a                	sd	a4,32(sp)
  8006d4:	871a                	mv	a4,t1
  8006d6:	ec06                	sd	ra,24(sp)
  8006d8:	f43e                	sd	a5,40(sp)
  8006da:	f842                	sd	a6,48(sp)
  8006dc:	fc46                	sd	a7,56(sp)
  8006de:	e41a                	sd	t1,8(sp)
  8006e0:	c5fff0ef          	jal	ra,80033e <vprintfmt>
  8006e4:	60e2                	ld	ra,24(sp)
  8006e6:	6121                	addi	sp,sp,64
  8006e8:	8082                	ret

00000000008006ea <do_yield>:
  8006ea:	1141                	addi	sp,sp,-16
  8006ec:	e406                	sd	ra,8(sp)
  8006ee:	ba9ff0ef          	jal	ra,800296 <yield>
  8006f2:	ba5ff0ef          	jal	ra,800296 <yield>
  8006f6:	ba1ff0ef          	jal	ra,800296 <yield>
  8006fa:	b9dff0ef          	jal	ra,800296 <yield>
  8006fe:	b99ff0ef          	jal	ra,800296 <yield>
  800702:	60a2                	ld	ra,8(sp)
  800704:	0141                	addi	sp,sp,16
  800706:	b91ff06f          	j	800296 <yield>

000000000080070a <loop>:
  80070a:	1141                	addi	sp,sp,-16
  80070c:	00000517          	auipc	a0,0x0
  800710:	61450513          	addi	a0,a0,1556 # 800d20 <error_string+0x2d8>
  800714:	e406                	sd	ra,8(sp)
  800716:	a71ff0ef          	jal	ra,800186 <cprintf>
  80071a:	a001                	j	80071a <loop+0x10>

000000000080071c <work>:
  80071c:	1141                	addi	sp,sp,-16
  80071e:	00000517          	auipc	a0,0x0
  800722:	68250513          	addi	a0,a0,1666 # 800da0 <error_string+0x358>
  800726:	e406                	sd	ra,8(sp)
  800728:	a5fff0ef          	jal	ra,800186 <cprintf>
  80072c:	fbfff0ef          	jal	ra,8006ea <do_yield>
  800730:	00001797          	auipc	a5,0x1
  800734:	8d078793          	addi	a5,a5,-1840 # 801000 <parent>
  800738:	4388                	lw	a0,0(a5)
  80073a:	b61ff0ef          	jal	ra,80029a <kill>
  80073e:	e10d                	bnez	a0,800760 <work+0x44>
  800740:	00000517          	auipc	a0,0x0
  800744:	67050513          	addi	a0,a0,1648 # 800db0 <error_string+0x368>
  800748:	a3fff0ef          	jal	ra,800186 <cprintf>
  80074c:	f9fff0ef          	jal	ra,8006ea <do_yield>
  800750:	00001797          	auipc	a5,0x1
  800754:	8b878793          	addi	a5,a5,-1864 # 801008 <pid1>
  800758:	4388                	lw	a0,0(a5)
  80075a:	b41ff0ef          	jal	ra,80029a <kill>
  80075e:	c501                	beqz	a0,800766 <work+0x4a>
  800760:	557d                	li	a0,-1
  800762:	b17ff0ef          	jal	ra,800278 <exit>
  800766:	00000517          	auipc	a0,0x0
  80076a:	66250513          	addi	a0,a0,1634 # 800dc8 <error_string+0x380>
  80076e:	a19ff0ef          	jal	ra,800186 <cprintf>
  800772:	4501                	li	a0,0
  800774:	b05ff0ef          	jal	ra,800278 <exit>

0000000000800778 <main>:
  800778:	1141                	addi	sp,sp,-16
  80077a:	e406                	sd	ra,8(sp)
  80077c:	e022                	sd	s0,0(sp)
  80077e:	b21ff0ef          	jal	ra,80029e <getpid>
  800782:	00001797          	auipc	a5,0x1
  800786:	86a7af23          	sw	a0,-1922(a5) # 801000 <parent>
  80078a:	b05ff0ef          	jal	ra,80028e <fork>
  80078e:	00001797          	auipc	a5,0x1
  800792:	86a7ad23          	sw	a0,-1926(a5) # 801008 <pid1>
  800796:	c53d                	beqz	a0,800804 <main+0x8c>
  800798:	04a05663          	blez	a0,8007e4 <main+0x6c>
  80079c:	af3ff0ef          	jal	ra,80028e <fork>
  8007a0:	00001797          	auipc	a5,0x1
  8007a4:	86a7a223          	sw	a0,-1948(a5) # 801004 <pid2>
  8007a8:	cd3d                	beqz	a0,800826 <main+0xae>
  8007aa:	00001417          	auipc	s0,0x1
  8007ae:	85e40413          	addi	s0,s0,-1954 # 801008 <pid1>
  8007b2:	04a05b63          	blez	a0,800808 <main+0x90>
  8007b6:	00000517          	auipc	a0,0x0
  8007ba:	5b250513          	addi	a0,a0,1458 # 800d68 <error_string+0x320>
  8007be:	9c9ff0ef          	jal	ra,800186 <cprintf>
  8007c2:	4008                	lw	a0,0(s0)
  8007c4:	4581                	li	a1,0
  8007c6:	acdff0ef          	jal	ra,800292 <waitpid>
  8007ca:	4014                	lw	a3,0(s0)
  8007cc:	00000617          	auipc	a2,0x0
  8007d0:	5ac60613          	addi	a2,a2,1452 # 800d78 <error_string+0x330>
  8007d4:	03400593          	li	a1,52
  8007d8:	00000517          	auipc	a0,0x0
  8007dc:	58050513          	addi	a0,a0,1408 # 800d58 <error_string+0x310>
  8007e0:	841ff0ef          	jal	ra,800020 <__panic>
  8007e4:	00000697          	auipc	a3,0x0
  8007e8:	54c68693          	addi	a3,a3,1356 # 800d30 <error_string+0x2e8>
  8007ec:	00000617          	auipc	a2,0x0
  8007f0:	55460613          	addi	a2,a2,1364 # 800d40 <error_string+0x2f8>
  8007f4:	02c00593          	li	a1,44
  8007f8:	00000517          	auipc	a0,0x0
  8007fc:	56050513          	addi	a0,a0,1376 # 800d58 <error_string+0x310>
  800800:	821ff0ef          	jal	ra,800020 <__panic>
  800804:	f07ff0ef          	jal	ra,80070a <loop>
  800808:	4008                	lw	a0,0(s0)
  80080a:	a91ff0ef          	jal	ra,80029a <kill>
  80080e:	00000617          	auipc	a2,0x0
  800812:	58260613          	addi	a2,a2,1410 # 800d90 <error_string+0x348>
  800816:	03900593          	li	a1,57
  80081a:	00000517          	auipc	a0,0x0
  80081e:	53e50513          	addi	a0,a0,1342 # 800d58 <error_string+0x310>
  800822:	ffeff0ef          	jal	ra,800020 <__panic>
  800826:	ef7ff0ef          	jal	ra,80071c <work>
