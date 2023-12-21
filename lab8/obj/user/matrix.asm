
obj/__user_matrix.out：     文件格式 elf64-littleriscv


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
  800032:	90a50513          	addi	a0,a0,-1782 # 800938 <main+0xce>
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
  800052:	94a50513          	addi	a0,a0,-1718 # 800998 <main+0x12e>
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
  80006e:	00001517          	auipc	a0,0x1
  800072:	8ea50513          	addi	a0,a0,-1814 # 800958 <main+0xee>
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
  800092:	90a50513          	addi	a0,a0,-1782 # 800998 <main+0x12e>
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
  800172:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <matc+0xffffffffff7f57b1>
  800176:	ec06                	sd	ra,24(sp)
  800178:	c602                	sw	zero,12(sp)
  80017a:	1da000ef          	jal	ra,800354 <vprintfmt>
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
  8001a4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <matc+0xffffffffff7f57b1>
  8001a8:	ec06                	sd	ra,24(sp)
  8001aa:	e4be                	sd	a5,72(sp)
  8001ac:	e8c2                	sd	a6,80(sp)
  8001ae:	ecc6                	sd	a7,88(sp)
  8001b0:	e41a                	sd	t1,8(sp)
  8001b2:	c202                	sw	zero,4(sp)
  8001b4:	1a0000ef          	jal	ra,800354 <vprintfmt>
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
  800214:	76858593          	addi	a1,a1,1896 # 800978 <main+0x10e>
  800218:	4501                	li	a0,0
  80021a:	ec06                	sd	ra,24(sp)
  80021c:	fa5ff0ef          	jal	ra,8001c0 <initfd>
  800220:	02054263          	bltz	a0,800244 <umain+0x40>
  800224:	4605                	li	a2,1
  800226:	00000597          	auipc	a1,0x0
  80022a:	79258593          	addi	a1,a1,1938 # 8009b8 <main+0x14e>
  80022e:	4505                	li	a0,1
  800230:	f91ff0ef          	jal	ra,8001c0 <initfd>
  800234:	02054563          	bltz	a0,80025e <umain+0x5a>
  800238:	85a6                	mv	a1,s1
  80023a:	8522                	mv	a0,s0
  80023c:	62e000ef          	jal	ra,80086a <main>
  800240:	038000ef          	jal	ra,800278 <exit>
  800244:	86aa                	mv	a3,a0
  800246:	00000617          	auipc	a2,0x0
  80024a:	73a60613          	addi	a2,a2,1850 # 800980 <main+0x116>
  80024e:	45e9                	li	a1,26
  800250:	00000517          	auipc	a0,0x0
  800254:	75050513          	addi	a0,a0,1872 # 8009a0 <main+0x136>
  800258:	e09ff0ef          	jal	ra,800060 <__warn>
  80025c:	b7e1                	j	800224 <umain+0x20>
  80025e:	86aa                	mv	a3,a0
  800260:	00000617          	auipc	a2,0x0
  800264:	76060613          	addi	a2,a2,1888 # 8009c0 <main+0x156>
  800268:	45f5                	li	a1,29
  80026a:	00000517          	auipc	a0,0x0
  80026e:	73650513          	addi	a0,a0,1846 # 8009a0 <main+0x136>
  800272:	defff0ef          	jal	ra,800060 <__warn>
  800276:	b7c9                	j	800238 <umain+0x34>

0000000000800278 <exit>:
  800278:	1141                	addi	sp,sp,-16
  80027a:	e406                	sd	ra,8(sp)
  80027c:	e5fff0ef          	jal	ra,8000da <sys_exit>
  800280:	00000517          	auipc	a0,0x0
  800284:	76050513          	addi	a0,a0,1888 # 8009e0 <main+0x176>
  800288:	effff0ef          	jal	ra,800186 <cprintf>
  80028c:	a001                	j	80028c <exit+0x14>

000000000080028e <fork>:
  80028e:	e55ff06f          	j	8000e2 <sys_fork>

0000000000800292 <wait>:
  800292:	4581                	li	a1,0
  800294:	4501                	li	a0,0
  800296:	e53ff06f          	j	8000e8 <sys_wait>

000000000080029a <yield>:
  80029a:	e59ff06f          	j	8000f2 <sys_yield>

000000000080029e <kill>:
  80029e:	e5bff06f          	j	8000f8 <sys_kill>

00000000008002a2 <getpid>:
  8002a2:	e5fff06f          	j	800100 <sys_getpid>

00000000008002a6 <strnlen>:
  8002a6:	c185                	beqz	a1,8002c6 <strnlen+0x20>
  8002a8:	00054783          	lbu	a5,0(a0)
  8002ac:	cf89                	beqz	a5,8002c6 <strnlen+0x20>
  8002ae:	4781                	li	a5,0
  8002b0:	a021                	j	8002b8 <strnlen+0x12>
  8002b2:	00074703          	lbu	a4,0(a4)
  8002b6:	c711                	beqz	a4,8002c2 <strnlen+0x1c>
  8002b8:	0785                	addi	a5,a5,1
  8002ba:	00f50733          	add	a4,a0,a5
  8002be:	fef59ae3          	bne	a1,a5,8002b2 <strnlen+0xc>
  8002c2:	853e                	mv	a0,a5
  8002c4:	8082                	ret
  8002c6:	4781                	li	a5,0
  8002c8:	853e                	mv	a0,a5
  8002ca:	8082                	ret

00000000008002cc <memset>:
  8002cc:	ca01                	beqz	a2,8002dc <memset+0x10>
  8002ce:	962a                	add	a2,a2,a0
  8002d0:	87aa                	mv	a5,a0
  8002d2:	0785                	addi	a5,a5,1
  8002d4:	feb78fa3          	sb	a1,-1(a5)
  8002d8:	fec79de3          	bne	a5,a2,8002d2 <memset+0x6>
  8002dc:	8082                	ret

00000000008002de <printnum>:
  8002de:	02071893          	slli	a7,a4,0x20
  8002e2:	7139                	addi	sp,sp,-64
  8002e4:	0208d893          	srli	a7,a7,0x20
  8002e8:	e456                	sd	s5,8(sp)
  8002ea:	0316fab3          	remu	s5,a3,a7
  8002ee:	f822                	sd	s0,48(sp)
  8002f0:	f426                	sd	s1,40(sp)
  8002f2:	f04a                	sd	s2,32(sp)
  8002f4:	ec4e                	sd	s3,24(sp)
  8002f6:	fc06                	sd	ra,56(sp)
  8002f8:	e852                	sd	s4,16(sp)
  8002fa:	84aa                	mv	s1,a0
  8002fc:	89ae                	mv	s3,a1
  8002fe:	8932                	mv	s2,a2
  800300:	fff7841b          	addiw	s0,a5,-1
  800304:	2a81                	sext.w	s5,s5
  800306:	0516f163          	bleu	a7,a3,800348 <printnum+0x6a>
  80030a:	8a42                	mv	s4,a6
  80030c:	00805863          	blez	s0,80031c <printnum+0x3e>
  800310:	347d                	addiw	s0,s0,-1
  800312:	864e                	mv	a2,s3
  800314:	85ca                	mv	a1,s2
  800316:	8552                	mv	a0,s4
  800318:	9482                	jalr	s1
  80031a:	f87d                	bnez	s0,800310 <printnum+0x32>
  80031c:	1a82                	slli	s5,s5,0x20
  80031e:	020ada93          	srli	s5,s5,0x20
  800322:	00001797          	auipc	a5,0x1
  800326:	8f678793          	addi	a5,a5,-1802 # 800c18 <error_string+0xc8>
  80032a:	9abe                	add	s5,s5,a5
  80032c:	7442                	ld	s0,48(sp)
  80032e:	000ac503          	lbu	a0,0(s5)
  800332:	70e2                	ld	ra,56(sp)
  800334:	6a42                	ld	s4,16(sp)
  800336:	6aa2                	ld	s5,8(sp)
  800338:	864e                	mv	a2,s3
  80033a:	85ca                	mv	a1,s2
  80033c:	69e2                	ld	s3,24(sp)
  80033e:	7902                	ld	s2,32(sp)
  800340:	8326                	mv	t1,s1
  800342:	74a2                	ld	s1,40(sp)
  800344:	6121                	addi	sp,sp,64
  800346:	8302                	jr	t1
  800348:	0316d6b3          	divu	a3,a3,a7
  80034c:	87a2                	mv	a5,s0
  80034e:	f91ff0ef          	jal	ra,8002de <printnum>
  800352:	b7e9                	j	80031c <printnum+0x3e>

0000000000800354 <vprintfmt>:
  800354:	7119                	addi	sp,sp,-128
  800356:	f4a6                	sd	s1,104(sp)
  800358:	f0ca                	sd	s2,96(sp)
  80035a:	ecce                	sd	s3,88(sp)
  80035c:	e4d6                	sd	s5,72(sp)
  80035e:	e0da                	sd	s6,64(sp)
  800360:	fc5e                	sd	s7,56(sp)
  800362:	f862                	sd	s8,48(sp)
  800364:	ec6e                	sd	s11,24(sp)
  800366:	fc86                	sd	ra,120(sp)
  800368:	f8a2                	sd	s0,112(sp)
  80036a:	e8d2                	sd	s4,80(sp)
  80036c:	f466                	sd	s9,40(sp)
  80036e:	f06a                	sd	s10,32(sp)
  800370:	89aa                	mv	s3,a0
  800372:	892e                	mv	s2,a1
  800374:	84b2                	mv	s1,a2
  800376:	8db6                	mv	s11,a3
  800378:	8b3a                	mv	s6,a4
  80037a:	5bfd                	li	s7,-1
  80037c:	00000a97          	auipc	s5,0x0
  800380:	678a8a93          	addi	s5,s5,1656 # 8009f4 <main+0x18a>
  800384:	05e00c13          	li	s8,94
  800388:	000dc503          	lbu	a0,0(s11)
  80038c:	02500793          	li	a5,37
  800390:	001d8413          	addi	s0,s11,1
  800394:	00f50f63          	beq	a0,a5,8003b2 <vprintfmt+0x5e>
  800398:	c529                	beqz	a0,8003e2 <vprintfmt+0x8e>
  80039a:	02500a13          	li	s4,37
  80039e:	a011                	j	8003a2 <vprintfmt+0x4e>
  8003a0:	c129                	beqz	a0,8003e2 <vprintfmt+0x8e>
  8003a2:	864a                	mv	a2,s2
  8003a4:	85a6                	mv	a1,s1
  8003a6:	0405                	addi	s0,s0,1
  8003a8:	9982                	jalr	s3
  8003aa:	fff44503          	lbu	a0,-1(s0)
  8003ae:	ff4519e3          	bne	a0,s4,8003a0 <vprintfmt+0x4c>
  8003b2:	00044603          	lbu	a2,0(s0)
  8003b6:	02000813          	li	a6,32
  8003ba:	4a01                	li	s4,0
  8003bc:	4881                	li	a7,0
  8003be:	5d7d                	li	s10,-1
  8003c0:	5cfd                	li	s9,-1
  8003c2:	05500593          	li	a1,85
  8003c6:	4525                	li	a0,9
  8003c8:	fdd6071b          	addiw	a4,a2,-35
  8003cc:	0ff77713          	andi	a4,a4,255
  8003d0:	00140d93          	addi	s11,s0,1
  8003d4:	22e5e363          	bltu	a1,a4,8005fa <vprintfmt+0x2a6>
  8003d8:	070a                	slli	a4,a4,0x2
  8003da:	9756                	add	a4,a4,s5
  8003dc:	4318                	lw	a4,0(a4)
  8003de:	9756                	add	a4,a4,s5
  8003e0:	8702                	jr	a4
  8003e2:	70e6                	ld	ra,120(sp)
  8003e4:	7446                	ld	s0,112(sp)
  8003e6:	74a6                	ld	s1,104(sp)
  8003e8:	7906                	ld	s2,96(sp)
  8003ea:	69e6                	ld	s3,88(sp)
  8003ec:	6a46                	ld	s4,80(sp)
  8003ee:	6aa6                	ld	s5,72(sp)
  8003f0:	6b06                	ld	s6,64(sp)
  8003f2:	7be2                	ld	s7,56(sp)
  8003f4:	7c42                	ld	s8,48(sp)
  8003f6:	7ca2                	ld	s9,40(sp)
  8003f8:	7d02                	ld	s10,32(sp)
  8003fa:	6de2                	ld	s11,24(sp)
  8003fc:	6109                	addi	sp,sp,128
  8003fe:	8082                	ret
  800400:	4705                	li	a4,1
  800402:	008b0613          	addi	a2,s6,8
  800406:	01174463          	blt	a4,a7,80040e <vprintfmt+0xba>
  80040a:	28088563          	beqz	a7,800694 <vprintfmt+0x340>
  80040e:	000b3683          	ld	a3,0(s6)
  800412:	4741                	li	a4,16
  800414:	8b32                	mv	s6,a2
  800416:	a86d                	j	8004d0 <vprintfmt+0x17c>
  800418:	00144603          	lbu	a2,1(s0)
  80041c:	4a05                	li	s4,1
  80041e:	846e                	mv	s0,s11
  800420:	b765                	j	8003c8 <vprintfmt+0x74>
  800422:	000b2503          	lw	a0,0(s6)
  800426:	864a                	mv	a2,s2
  800428:	85a6                	mv	a1,s1
  80042a:	0b21                	addi	s6,s6,8
  80042c:	9982                	jalr	s3
  80042e:	bfa9                	j	800388 <vprintfmt+0x34>
  800430:	4705                	li	a4,1
  800432:	008b0a13          	addi	s4,s6,8
  800436:	01174463          	blt	a4,a7,80043e <vprintfmt+0xea>
  80043a:	24088563          	beqz	a7,800684 <vprintfmt+0x330>
  80043e:	000b3403          	ld	s0,0(s6)
  800442:	26044563          	bltz	s0,8006ac <vprintfmt+0x358>
  800446:	86a2                	mv	a3,s0
  800448:	8b52                	mv	s6,s4
  80044a:	4729                	li	a4,10
  80044c:	a051                	j	8004d0 <vprintfmt+0x17c>
  80044e:	000b2783          	lw	a5,0(s6)
  800452:	46e1                	li	a3,24
  800454:	0b21                	addi	s6,s6,8
  800456:	41f7d71b          	sraiw	a4,a5,0x1f
  80045a:	8fb9                	xor	a5,a5,a4
  80045c:	40e7873b          	subw	a4,a5,a4
  800460:	1ce6c163          	blt	a3,a4,800622 <vprintfmt+0x2ce>
  800464:	00371793          	slli	a5,a4,0x3
  800468:	00000697          	auipc	a3,0x0
  80046c:	6e868693          	addi	a3,a3,1768 # 800b50 <error_string>
  800470:	97b6                	add	a5,a5,a3
  800472:	639c                	ld	a5,0(a5)
  800474:	1a078763          	beqz	a5,800622 <vprintfmt+0x2ce>
  800478:	873e                	mv	a4,a5
  80047a:	00001697          	auipc	a3,0x1
  80047e:	9a668693          	addi	a3,a3,-1626 # 800e20 <error_string+0x2d0>
  800482:	8626                	mv	a2,s1
  800484:	85ca                	mv	a1,s2
  800486:	854e                	mv	a0,s3
  800488:	25a000ef          	jal	ra,8006e2 <printfmt>
  80048c:	bdf5                	j	800388 <vprintfmt+0x34>
  80048e:	00144603          	lbu	a2,1(s0)
  800492:	2885                	addiw	a7,a7,1
  800494:	846e                	mv	s0,s11
  800496:	bf0d                	j	8003c8 <vprintfmt+0x74>
  800498:	4705                	li	a4,1
  80049a:	008b0613          	addi	a2,s6,8
  80049e:	01174463          	blt	a4,a7,8004a6 <vprintfmt+0x152>
  8004a2:	1e088e63          	beqz	a7,80069e <vprintfmt+0x34a>
  8004a6:	000b3683          	ld	a3,0(s6)
  8004aa:	4721                	li	a4,8
  8004ac:	8b32                	mv	s6,a2
  8004ae:	a00d                	j	8004d0 <vprintfmt+0x17c>
  8004b0:	03000513          	li	a0,48
  8004b4:	864a                	mv	a2,s2
  8004b6:	85a6                	mv	a1,s1
  8004b8:	e042                	sd	a6,0(sp)
  8004ba:	9982                	jalr	s3
  8004bc:	864a                	mv	a2,s2
  8004be:	85a6                	mv	a1,s1
  8004c0:	07800513          	li	a0,120
  8004c4:	9982                	jalr	s3
  8004c6:	0b21                	addi	s6,s6,8
  8004c8:	ff8b3683          	ld	a3,-8(s6)
  8004cc:	6802                	ld	a6,0(sp)
  8004ce:	4741                	li	a4,16
  8004d0:	87e6                	mv	a5,s9
  8004d2:	8626                	mv	a2,s1
  8004d4:	85ca                	mv	a1,s2
  8004d6:	854e                	mv	a0,s3
  8004d8:	e07ff0ef          	jal	ra,8002de <printnum>
  8004dc:	b575                	j	800388 <vprintfmt+0x34>
  8004de:	000b3703          	ld	a4,0(s6)
  8004e2:	0b21                	addi	s6,s6,8
  8004e4:	1e070063          	beqz	a4,8006c4 <vprintfmt+0x370>
  8004e8:	00170413          	addi	s0,a4,1
  8004ec:	19905563          	blez	s9,800676 <vprintfmt+0x322>
  8004f0:	02d00613          	li	a2,45
  8004f4:	14c81963          	bne	a6,a2,800646 <vprintfmt+0x2f2>
  8004f8:	00074703          	lbu	a4,0(a4)
  8004fc:	0007051b          	sext.w	a0,a4
  800500:	c90d                	beqz	a0,800532 <vprintfmt+0x1de>
  800502:	000d4563          	bltz	s10,80050c <vprintfmt+0x1b8>
  800506:	3d7d                	addiw	s10,s10,-1
  800508:	037d0363          	beq	s10,s7,80052e <vprintfmt+0x1da>
  80050c:	864a                	mv	a2,s2
  80050e:	85a6                	mv	a1,s1
  800510:	180a0c63          	beqz	s4,8006a8 <vprintfmt+0x354>
  800514:	3701                	addiw	a4,a4,-32
  800516:	18ec7963          	bleu	a4,s8,8006a8 <vprintfmt+0x354>
  80051a:	03f00513          	li	a0,63
  80051e:	9982                	jalr	s3
  800520:	0405                	addi	s0,s0,1
  800522:	fff44703          	lbu	a4,-1(s0)
  800526:	3cfd                	addiw	s9,s9,-1
  800528:	0007051b          	sext.w	a0,a4
  80052c:	f979                	bnez	a0,800502 <vprintfmt+0x1ae>
  80052e:	e5905de3          	blez	s9,800388 <vprintfmt+0x34>
  800532:	3cfd                	addiw	s9,s9,-1
  800534:	864a                	mv	a2,s2
  800536:	85a6                	mv	a1,s1
  800538:	02000513          	li	a0,32
  80053c:	9982                	jalr	s3
  80053e:	e40c85e3          	beqz	s9,800388 <vprintfmt+0x34>
  800542:	3cfd                	addiw	s9,s9,-1
  800544:	864a                	mv	a2,s2
  800546:	85a6                	mv	a1,s1
  800548:	02000513          	li	a0,32
  80054c:	9982                	jalr	s3
  80054e:	fe0c92e3          	bnez	s9,800532 <vprintfmt+0x1de>
  800552:	bd1d                	j	800388 <vprintfmt+0x34>
  800554:	4705                	li	a4,1
  800556:	008b0613          	addi	a2,s6,8
  80055a:	01174463          	blt	a4,a7,800562 <vprintfmt+0x20e>
  80055e:	12088663          	beqz	a7,80068a <vprintfmt+0x336>
  800562:	000b3683          	ld	a3,0(s6)
  800566:	4729                	li	a4,10
  800568:	8b32                	mv	s6,a2
  80056a:	b79d                	j	8004d0 <vprintfmt+0x17c>
  80056c:	00144603          	lbu	a2,1(s0)
  800570:	02d00813          	li	a6,45
  800574:	846e                	mv	s0,s11
  800576:	bd89                	j	8003c8 <vprintfmt+0x74>
  800578:	864a                	mv	a2,s2
  80057a:	85a6                	mv	a1,s1
  80057c:	02500513          	li	a0,37
  800580:	9982                	jalr	s3
  800582:	b519                	j	800388 <vprintfmt+0x34>
  800584:	000b2d03          	lw	s10,0(s6)
  800588:	00144603          	lbu	a2,1(s0)
  80058c:	0b21                	addi	s6,s6,8
  80058e:	846e                	mv	s0,s11
  800590:	e20cdce3          	bgez	s9,8003c8 <vprintfmt+0x74>
  800594:	8cea                	mv	s9,s10
  800596:	5d7d                	li	s10,-1
  800598:	bd05                	j	8003c8 <vprintfmt+0x74>
  80059a:	00144603          	lbu	a2,1(s0)
  80059e:	03000813          	li	a6,48
  8005a2:	846e                	mv	s0,s11
  8005a4:	b515                	j	8003c8 <vprintfmt+0x74>
  8005a6:	fd060d1b          	addiw	s10,a2,-48
  8005aa:	00144603          	lbu	a2,1(s0)
  8005ae:	846e                	mv	s0,s11
  8005b0:	fd06071b          	addiw	a4,a2,-48
  8005b4:	0006031b          	sext.w	t1,a2
  8005b8:	fce56ce3          	bltu	a0,a4,800590 <vprintfmt+0x23c>
  8005bc:	0405                	addi	s0,s0,1
  8005be:	002d171b          	slliw	a4,s10,0x2
  8005c2:	00044603          	lbu	a2,0(s0)
  8005c6:	01a706bb          	addw	a3,a4,s10
  8005ca:	0016969b          	slliw	a3,a3,0x1
  8005ce:	006686bb          	addw	a3,a3,t1
  8005d2:	fd06071b          	addiw	a4,a2,-48
  8005d6:	fd068d1b          	addiw	s10,a3,-48
  8005da:	0006031b          	sext.w	t1,a2
  8005de:	fce57fe3          	bleu	a4,a0,8005bc <vprintfmt+0x268>
  8005e2:	b77d                	j	800590 <vprintfmt+0x23c>
  8005e4:	fffcc713          	not	a4,s9
  8005e8:	977d                	srai	a4,a4,0x3f
  8005ea:	00ecf7b3          	and	a5,s9,a4
  8005ee:	00144603          	lbu	a2,1(s0)
  8005f2:	00078c9b          	sext.w	s9,a5
  8005f6:	846e                	mv	s0,s11
  8005f8:	bbc1                	j	8003c8 <vprintfmt+0x74>
  8005fa:	864a                	mv	a2,s2
  8005fc:	85a6                	mv	a1,s1
  8005fe:	02500513          	li	a0,37
  800602:	9982                	jalr	s3
  800604:	fff44703          	lbu	a4,-1(s0)
  800608:	02500793          	li	a5,37
  80060c:	8da2                	mv	s11,s0
  80060e:	d6f70de3          	beq	a4,a5,800388 <vprintfmt+0x34>
  800612:	02500713          	li	a4,37
  800616:	1dfd                	addi	s11,s11,-1
  800618:	fffdc783          	lbu	a5,-1(s11)
  80061c:	fee79de3          	bne	a5,a4,800616 <vprintfmt+0x2c2>
  800620:	b3a5                	j	800388 <vprintfmt+0x34>
  800622:	00000697          	auipc	a3,0x0
  800626:	7ee68693          	addi	a3,a3,2030 # 800e10 <error_string+0x2c0>
  80062a:	8626                	mv	a2,s1
  80062c:	85ca                	mv	a1,s2
  80062e:	854e                	mv	a0,s3
  800630:	0b2000ef          	jal	ra,8006e2 <printfmt>
  800634:	bb91                	j	800388 <vprintfmt+0x34>
  800636:	00000717          	auipc	a4,0x0
  80063a:	7d270713          	addi	a4,a4,2002 # 800e08 <error_string+0x2b8>
  80063e:	00000417          	auipc	s0,0x0
  800642:	7cb40413          	addi	s0,s0,1995 # 800e09 <error_string+0x2b9>
  800646:	853a                	mv	a0,a4
  800648:	85ea                	mv	a1,s10
  80064a:	e03a                	sd	a4,0(sp)
  80064c:	e442                	sd	a6,8(sp)
  80064e:	c59ff0ef          	jal	ra,8002a6 <strnlen>
  800652:	40ac8cbb          	subw	s9,s9,a0
  800656:	6702                	ld	a4,0(sp)
  800658:	01905f63          	blez	s9,800676 <vprintfmt+0x322>
  80065c:	6822                	ld	a6,8(sp)
  80065e:	0008079b          	sext.w	a5,a6
  800662:	e43e                	sd	a5,8(sp)
  800664:	6522                	ld	a0,8(sp)
  800666:	864a                	mv	a2,s2
  800668:	85a6                	mv	a1,s1
  80066a:	e03a                	sd	a4,0(sp)
  80066c:	3cfd                	addiw	s9,s9,-1
  80066e:	9982                	jalr	s3
  800670:	6702                	ld	a4,0(sp)
  800672:	fe0c99e3          	bnez	s9,800664 <vprintfmt+0x310>
  800676:	00074703          	lbu	a4,0(a4)
  80067a:	0007051b          	sext.w	a0,a4
  80067e:	e80512e3          	bnez	a0,800502 <vprintfmt+0x1ae>
  800682:	b319                	j	800388 <vprintfmt+0x34>
  800684:	000b2403          	lw	s0,0(s6)
  800688:	bb6d                	j	800442 <vprintfmt+0xee>
  80068a:	000b6683          	lwu	a3,0(s6)
  80068e:	4729                	li	a4,10
  800690:	8b32                	mv	s6,a2
  800692:	bd3d                	j	8004d0 <vprintfmt+0x17c>
  800694:	000b6683          	lwu	a3,0(s6)
  800698:	4741                	li	a4,16
  80069a:	8b32                	mv	s6,a2
  80069c:	bd15                	j	8004d0 <vprintfmt+0x17c>
  80069e:	000b6683          	lwu	a3,0(s6)
  8006a2:	4721                	li	a4,8
  8006a4:	8b32                	mv	s6,a2
  8006a6:	b52d                	j	8004d0 <vprintfmt+0x17c>
  8006a8:	9982                	jalr	s3
  8006aa:	bd9d                	j	800520 <vprintfmt+0x1cc>
  8006ac:	864a                	mv	a2,s2
  8006ae:	85a6                	mv	a1,s1
  8006b0:	02d00513          	li	a0,45
  8006b4:	e042                	sd	a6,0(sp)
  8006b6:	9982                	jalr	s3
  8006b8:	8b52                	mv	s6,s4
  8006ba:	408006b3          	neg	a3,s0
  8006be:	4729                	li	a4,10
  8006c0:	6802                	ld	a6,0(sp)
  8006c2:	b539                	j	8004d0 <vprintfmt+0x17c>
  8006c4:	01905663          	blez	s9,8006d0 <vprintfmt+0x37c>
  8006c8:	02d00713          	li	a4,45
  8006cc:	f6e815e3          	bne	a6,a4,800636 <vprintfmt+0x2e2>
  8006d0:	00000417          	auipc	s0,0x0
  8006d4:	73940413          	addi	s0,s0,1849 # 800e09 <error_string+0x2b9>
  8006d8:	02800513          	li	a0,40
  8006dc:	02800713          	li	a4,40
  8006e0:	b50d                	j	800502 <vprintfmt+0x1ae>

00000000008006e2 <printfmt>:
  8006e2:	7139                	addi	sp,sp,-64
  8006e4:	02010313          	addi	t1,sp,32
  8006e8:	f03a                	sd	a4,32(sp)
  8006ea:	871a                	mv	a4,t1
  8006ec:	ec06                	sd	ra,24(sp)
  8006ee:	f43e                	sd	a5,40(sp)
  8006f0:	f842                	sd	a6,48(sp)
  8006f2:	fc46                	sd	a7,56(sp)
  8006f4:	e41a                	sd	t1,8(sp)
  8006f6:	c5fff0ef          	jal	ra,800354 <vprintfmt>
  8006fa:	60e2                	ld	ra,24(sp)
  8006fc:	6121                	addi	sp,sp,64
  8006fe:	8082                	ret

0000000000800700 <rand>:
  800700:	00001697          	auipc	a3,0x1
  800704:	90068693          	addi	a3,a3,-1792 # 801000 <next>
  800708:	00000717          	auipc	a4,0x0
  80070c:	72070713          	addi	a4,a4,1824 # 800e28 <error_string+0x2d8>
  800710:	629c                	ld	a5,0(a3)
  800712:	6318                	ld	a4,0(a4)
  800714:	02e787b3          	mul	a5,a5,a4
  800718:	577d                	li	a4,-1
  80071a:	8341                	srli	a4,a4,0x10
  80071c:	07ad                	addi	a5,a5,11
  80071e:	8ff9                	and	a5,a5,a4
  800720:	80000737          	lui	a4,0x80000
  800724:	00c7d513          	srli	a0,a5,0xc
  800728:	fff74713          	not	a4,a4
  80072c:	02e57533          	remu	a0,a0,a4
  800730:	e29c                	sd	a5,0(a3)
  800732:	2505                	addiw	a0,a0,1
  800734:	8082                	ret

0000000000800736 <srand>:
  800736:	1502                	slli	a0,a0,0x20
  800738:	9101                	srli	a0,a0,0x20
  80073a:	00001797          	auipc	a5,0x1
  80073e:	8ca7b323          	sd	a0,-1850(a5) # 801000 <next>
  800742:	8082                	ret

0000000000800744 <work>:
  800744:	7179                	addi	sp,sp,-48
  800746:	e84a                	sd	s2,16(sp)
  800748:	00001597          	auipc	a1,0x1
  80074c:	89858593          	addi	a1,a1,-1896 # 800fe0 <error_string+0x490>
  800750:	00001917          	auipc	s2,0x1
  800754:	a4890913          	addi	s2,s2,-1464 # 801198 <matb>
  800758:	f022                	sd	s0,32(sp)
  80075a:	ec26                	sd	s1,24(sp)
  80075c:	e44e                	sd	s3,8(sp)
  80075e:	f406                	sd	ra,40(sp)
  800760:	84aa                	mv	s1,a0
  800762:	00001617          	auipc	a2,0x1
  800766:	a5e60613          	addi	a2,a2,-1442 # 8011c0 <matb+0x28>
  80076a:	00001417          	auipc	s0,0x1
  80076e:	be640413          	addi	s0,s0,-1050 # 801350 <matc+0x28>
  800772:	00001997          	auipc	s3,0x1
  800776:	89698993          	addi	s3,s3,-1898 # 801008 <mata>
  80077a:	412585b3          	sub	a1,a1,s2
  80077e:	4685                	li	a3,1
  800780:	fd860793          	addi	a5,a2,-40
  800784:	00c58733          	add	a4,a1,a2
  800788:	c394                	sw	a3,0(a5)
  80078a:	c314                	sw	a3,0(a4)
  80078c:	0791                	addi	a5,a5,4
  80078e:	0711                	addi	a4,a4,4
  800790:	fec79ce3          	bne	a5,a2,800788 <work+0x44>
  800794:	02878613          	addi	a2,a5,40
  800798:	fe8614e3          	bne	a2,s0,800780 <work+0x3c>
  80079c:	affff0ef          	jal	ra,80029a <yield>
  8007a0:	b03ff0ef          	jal	ra,8002a2 <getpid>
  8007a4:	8626                	mv	a2,s1
  8007a6:	85aa                	mv	a1,a0
  8007a8:	00000517          	auipc	a0,0x0
  8007ac:	6d850513          	addi	a0,a0,1752 # 800e80 <error_string+0x330>
  8007b0:	9d7ff0ef          	jal	ra,800186 <cprintf>
  8007b4:	53fd                	li	t2,-1
  8007b6:	34fd                	addiw	s1,s1,-1
  8007b8:	00001297          	auipc	t0,0x1
  8007bc:	9e028293          	addi	t0,t0,-1568 # 801198 <matb>
  8007c0:	00001f97          	auipc	t6,0x1
  8007c4:	b68f8f93          	addi	t6,t6,-1176 # 801328 <matc>
  8007c8:	00001f17          	auipc	t5,0x1
  8007cc:	cf0f0f13          	addi	t5,t5,-784 # 8014b8 <matc+0x190>
  8007d0:	02800e13          	li	t3,40
  8007d4:	06748f63          	beq	s1,t2,800852 <work+0x10e>
  8007d8:	00001897          	auipc	a7,0x1
  8007dc:	b5088893          	addi	a7,a7,-1200 # 801328 <matc>
  8007e0:	8ec6                	mv	t4,a7
  8007e2:	834e                	mv	t1,s3
  8007e4:	857e                	mv	a0,t6
  8007e6:	8876                	mv	a6,t4
  8007e8:	e7050793          	addi	a5,a0,-400
  8007ec:	869a                	mv	a3,t1
  8007ee:	4601                	li	a2,0
  8007f0:	4298                	lw	a4,0(a3)
  8007f2:	438c                	lw	a1,0(a5)
  8007f4:	02878793          	addi	a5,a5,40
  8007f8:	0691                	addi	a3,a3,4
  8007fa:	02b7073b          	mulw	a4,a4,a1
  8007fe:	9e39                	addw	a2,a2,a4
  800800:	fea798e3          	bne	a5,a0,8007f0 <work+0xac>
  800804:	00c82023          	sw	a2,0(a6)
  800808:	00478513          	addi	a0,a5,4
  80080c:	0811                	addi	a6,a6,4
  80080e:	fc851de3          	bne	a0,s0,8007e8 <work+0xa4>
  800812:	02830313          	addi	t1,t1,40
  800816:	028e8e93          	addi	t4,t4,40
  80081a:	fc5315e3          	bne	t1,t0,8007e4 <work+0xa0>
  80081e:	854e                	mv	a0,s3
  800820:	85ca                	mv	a1,s2
  800822:	4781                	li	a5,0
  800824:	00f88733          	add	a4,a7,a5
  800828:	4318                	lw	a4,0(a4)
  80082a:	00f58633          	add	a2,a1,a5
  80082e:	00f506b3          	add	a3,a0,a5
  800832:	c218                	sw	a4,0(a2)
  800834:	c298                	sw	a4,0(a3)
  800836:	0791                	addi	a5,a5,4
  800838:	ffc796e3          	bne	a5,t3,800824 <work+0xe0>
  80083c:	02888893          	addi	a7,a7,40
  800840:	02858593          	addi	a1,a1,40
  800844:	02850513          	addi	a0,a0,40
  800848:	fde89de3          	bne	a7,t5,800822 <work+0xde>
  80084c:	34fd                	addiw	s1,s1,-1
  80084e:	f87495e3          	bne	s1,t2,8007d8 <work+0x94>
  800852:	a51ff0ef          	jal	ra,8002a2 <getpid>
  800856:	85aa                	mv	a1,a0
  800858:	00000517          	auipc	a0,0x0
  80085c:	64850513          	addi	a0,a0,1608 # 800ea0 <error_string+0x350>
  800860:	927ff0ef          	jal	ra,800186 <cprintf>
  800864:	4501                	li	a0,0
  800866:	a13ff0ef          	jal	ra,800278 <exit>

000000000080086a <main>:
  80086a:	7175                	addi	sp,sp,-144
  80086c:	f4ce                	sd	s3,104(sp)
  80086e:	05400613          	li	a2,84
  800872:	4581                	li	a1,0
  800874:	0028                	addi	a0,sp,8
  800876:	00810993          	addi	s3,sp,8
  80087a:	e122                	sd	s0,128(sp)
  80087c:	fca6                	sd	s1,120(sp)
  80087e:	f8ca                	sd	s2,112(sp)
  800880:	e506                	sd	ra,136(sp)
  800882:	84ce                	mv	s1,s3
  800884:	a49ff0ef          	jal	ra,8002cc <memset>
  800888:	4401                	li	s0,0
  80088a:	4955                	li	s2,21
  80088c:	a03ff0ef          	jal	ra,80028e <fork>
  800890:	c088                	sw	a0,0(s1)
  800892:	cd2d                	beqz	a0,80090c <main+0xa2>
  800894:	04054663          	bltz	a0,8008e0 <main+0x76>
  800898:	2405                	addiw	s0,s0,1
  80089a:	0491                	addi	s1,s1,4
  80089c:	ff2418e3          	bne	s0,s2,80088c <main+0x22>
  8008a0:	00000517          	auipc	a0,0x0
  8008a4:	59050513          	addi	a0,a0,1424 # 800e30 <error_string+0x2e0>
  8008a8:	8dfff0ef          	jal	ra,800186 <cprintf>
  8008ac:	4455                	li	s0,21
  8008ae:	9e5ff0ef          	jal	ra,800292 <wait>
  8008b2:	e10d                	bnez	a0,8008d4 <main+0x6a>
  8008b4:	347d                	addiw	s0,s0,-1
  8008b6:	fc65                	bnez	s0,8008ae <main+0x44>
  8008b8:	00000517          	auipc	a0,0x0
  8008bc:	59850513          	addi	a0,a0,1432 # 800e50 <error_string+0x300>
  8008c0:	8c7ff0ef          	jal	ra,800186 <cprintf>
  8008c4:	60aa                	ld	ra,136(sp)
  8008c6:	640a                	ld	s0,128(sp)
  8008c8:	74e6                	ld	s1,120(sp)
  8008ca:	7946                	ld	s2,112(sp)
  8008cc:	79a6                	ld	s3,104(sp)
  8008ce:	4501                	li	a0,0
  8008d0:	6149                	addi	sp,sp,144
  8008d2:	8082                	ret
  8008d4:	00000517          	auipc	a0,0x0
  8008d8:	56c50513          	addi	a0,a0,1388 # 800e40 <error_string+0x2f0>
  8008dc:	8abff0ef          	jal	ra,800186 <cprintf>
  8008e0:	08e0                	addi	s0,sp,92
  8008e2:	0009a503          	lw	a0,0(s3)
  8008e6:	00a05463          	blez	a0,8008ee <main+0x84>
  8008ea:	9b5ff0ef          	jal	ra,80029e <kill>
  8008ee:	0991                	addi	s3,s3,4
  8008f0:	ff3419e3          	bne	s0,s3,8008e2 <main+0x78>
  8008f4:	00000617          	auipc	a2,0x0
  8008f8:	56c60613          	addi	a2,a2,1388 # 800e60 <error_string+0x310>
  8008fc:	05200593          	li	a1,82
  800900:	00000517          	auipc	a0,0x0
  800904:	57050513          	addi	a0,a0,1392 # 800e70 <error_string+0x320>
  800908:	f18ff0ef          	jal	ra,800020 <__panic>
  80090c:	0284053b          	mulw	a0,s0,s0
  800910:	e27ff0ef          	jal	ra,800736 <srand>
  800914:	dedff0ef          	jal	ra,800700 <rand>
  800918:	47d5                	li	a5,21
  80091a:	02f5753b          	remuw	a0,a0,a5
  80091e:	02a5053b          	mulw	a0,a0,a0
  800922:	00a5079b          	addiw	a5,a0,10
  800926:	06400513          	li	a0,100
  80092a:	02f50533          	mul	a0,a0,a5
  80092e:	e17ff0ef          	jal	ra,800744 <work>
