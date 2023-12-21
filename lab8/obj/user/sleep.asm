
obj/__user_sleep.out：     文件格式 elf64-littleriscv


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
  800032:	75a50513          	addi	a0,a0,1882 # 800788 <main+0x6e>
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
  800052:	79a50513          	addi	a0,a0,1946 # 8007e8 <main+0xce>
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
  800072:	73a50513          	addi	a0,a0,1850 # 8007a8 <main+0x8e>
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
  800092:	75a50513          	addi	a0,a0,1882 # 8007e8 <main+0xce>
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

00000000008000f2 <sys_putc>:
  8000f2:	85aa                	mv	a1,a0
  8000f4:	4579                	li	a0,30
  8000f6:	fadff06f          	j	8000a2 <syscall>

00000000008000fa <sys_sleep>:
  8000fa:	85aa                	mv	a1,a0
  8000fc:	452d                	li	a0,11
  8000fe:	fa5ff06f          	j	8000a2 <syscall>

0000000000800102 <sys_gettime>:
  800102:	4545                	li	a0,17
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
  800148:	fabff0ef          	jal	ra,8000f2 <sys_putc>
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
  80016c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6139>
  800170:	ec06                	sd	ra,24(sp)
  800172:	c602                	sw	zero,12(sp)
  800174:	1c4000ef          	jal	ra,800338 <vprintfmt>
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
  80019e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6139>
  8001a2:	ec06                	sd	ra,24(sp)
  8001a4:	e4be                	sd	a5,72(sp)
  8001a6:	e8c2                	sd	a6,80(sp)
  8001a8:	ecc6                	sd	a7,88(sp)
  8001aa:	e41a                	sd	t1,8(sp)
  8001ac:	c202                	sw	zero,4(sp)
  8001ae:	18a000ef          	jal	ra,800338 <vprintfmt>
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
  80020e:	5be58593          	addi	a1,a1,1470 # 8007c8 <main+0xae>
  800212:	4501                	li	a0,0
  800214:	ec06                	sd	ra,24(sp)
  800216:	fa5ff0ef          	jal	ra,8001ba <initfd>
  80021a:	02054263          	bltz	a0,80023e <umain+0x40>
  80021e:	4605                	li	a2,1
  800220:	00000597          	auipc	a1,0x0
  800224:	5e858593          	addi	a1,a1,1512 # 800808 <main+0xee>
  800228:	4505                	li	a0,1
  80022a:	f91ff0ef          	jal	ra,8001ba <initfd>
  80022e:	02054563          	bltz	a0,800258 <umain+0x5a>
  800232:	85a6                	mv	a1,s1
  800234:	8522                	mv	a0,s0
  800236:	4e4000ef          	jal	ra,80071a <main>
  80023a:	038000ef          	jal	ra,800272 <exit>
  80023e:	86aa                	mv	a3,a0
  800240:	00000617          	auipc	a2,0x0
  800244:	59060613          	addi	a2,a2,1424 # 8007d0 <main+0xb6>
  800248:	45e9                	li	a1,26
  80024a:	00000517          	auipc	a0,0x0
  80024e:	5a650513          	addi	a0,a0,1446 # 8007f0 <main+0xd6>
  800252:	e0fff0ef          	jal	ra,800060 <__warn>
  800256:	b7e1                	j	80021e <umain+0x20>
  800258:	86aa                	mv	a3,a0
  80025a:	00000617          	auipc	a2,0x0
  80025e:	5b660613          	addi	a2,a2,1462 # 800810 <main+0xf6>
  800262:	45f5                	li	a1,29
  800264:	00000517          	auipc	a0,0x0
  800268:	58c50513          	addi	a0,a0,1420 # 8007f0 <main+0xd6>
  80026c:	df5ff0ef          	jal	ra,800060 <__warn>
  800270:	b7c9                	j	800232 <umain+0x34>

0000000000800272 <exit>:
  800272:	1141                	addi	sp,sp,-16
  800274:	e406                	sd	ra,8(sp)
  800276:	e65ff0ef          	jal	ra,8000da <sys_exit>
  80027a:	00000517          	auipc	a0,0x0
  80027e:	5b650513          	addi	a0,a0,1462 # 800830 <main+0x116>
  800282:	effff0ef          	jal	ra,800180 <cprintf>
  800286:	a001                	j	800286 <exit+0x14>

0000000000800288 <fork>:
  800288:	e5bff06f          	j	8000e2 <sys_fork>

000000000080028c <waitpid>:
  80028c:	e5dff06f          	j	8000e8 <sys_wait>

0000000000800290 <gettime_msec>:
  800290:	e73ff06f          	j	800102 <sys_gettime>

0000000000800294 <sleep>:
  800294:	1502                	slli	a0,a0,0x20
  800296:	9101                	srli	a0,a0,0x20
  800298:	e63ff06f          	j	8000fa <sys_sleep>

000000000080029c <strnlen>:
  80029c:	c185                	beqz	a1,8002bc <strnlen+0x20>
  80029e:	00054783          	lbu	a5,0(a0)
  8002a2:	cf89                	beqz	a5,8002bc <strnlen+0x20>
  8002a4:	4781                	li	a5,0
  8002a6:	a021                	j	8002ae <strnlen+0x12>
  8002a8:	00074703          	lbu	a4,0(a4)
  8002ac:	c711                	beqz	a4,8002b8 <strnlen+0x1c>
  8002ae:	0785                	addi	a5,a5,1
  8002b0:	00f50733          	add	a4,a0,a5
  8002b4:	fef59ae3          	bne	a1,a5,8002a8 <strnlen+0xc>
  8002b8:	853e                	mv	a0,a5
  8002ba:	8082                	ret
  8002bc:	4781                	li	a5,0
  8002be:	853e                	mv	a0,a5
  8002c0:	8082                	ret

00000000008002c2 <printnum>:
  8002c2:	02071893          	slli	a7,a4,0x20
  8002c6:	7139                	addi	sp,sp,-64
  8002c8:	0208d893          	srli	a7,a7,0x20
  8002cc:	e456                	sd	s5,8(sp)
  8002ce:	0316fab3          	remu	s5,a3,a7
  8002d2:	f822                	sd	s0,48(sp)
  8002d4:	f426                	sd	s1,40(sp)
  8002d6:	f04a                	sd	s2,32(sp)
  8002d8:	ec4e                	sd	s3,24(sp)
  8002da:	fc06                	sd	ra,56(sp)
  8002dc:	e852                	sd	s4,16(sp)
  8002de:	84aa                	mv	s1,a0
  8002e0:	89ae                	mv	s3,a1
  8002e2:	8932                	mv	s2,a2
  8002e4:	fff7841b          	addiw	s0,a5,-1
  8002e8:	2a81                	sext.w	s5,s5
  8002ea:	0516f163          	bleu	a7,a3,80032c <printnum+0x6a>
  8002ee:	8a42                	mv	s4,a6
  8002f0:	00805863          	blez	s0,800300 <printnum+0x3e>
  8002f4:	347d                	addiw	s0,s0,-1
  8002f6:	864e                	mv	a2,s3
  8002f8:	85ca                	mv	a1,s2
  8002fa:	8552                	mv	a0,s4
  8002fc:	9482                	jalr	s1
  8002fe:	f87d                	bnez	s0,8002f4 <printnum+0x32>
  800300:	1a82                	slli	s5,s5,0x20
  800302:	020ada93          	srli	s5,s5,0x20
  800306:	00000797          	auipc	a5,0x0
  80030a:	76278793          	addi	a5,a5,1890 # 800a68 <error_string+0xc8>
  80030e:	9abe                	add	s5,s5,a5
  800310:	7442                	ld	s0,48(sp)
  800312:	000ac503          	lbu	a0,0(s5)
  800316:	70e2                	ld	ra,56(sp)
  800318:	6a42                	ld	s4,16(sp)
  80031a:	6aa2                	ld	s5,8(sp)
  80031c:	864e                	mv	a2,s3
  80031e:	85ca                	mv	a1,s2
  800320:	69e2                	ld	s3,24(sp)
  800322:	7902                	ld	s2,32(sp)
  800324:	8326                	mv	t1,s1
  800326:	74a2                	ld	s1,40(sp)
  800328:	6121                	addi	sp,sp,64
  80032a:	8302                	jr	t1
  80032c:	0316d6b3          	divu	a3,a3,a7
  800330:	87a2                	mv	a5,s0
  800332:	f91ff0ef          	jal	ra,8002c2 <printnum>
  800336:	b7e9                	j	800300 <printnum+0x3e>

0000000000800338 <vprintfmt>:
  800338:	7119                	addi	sp,sp,-128
  80033a:	f4a6                	sd	s1,104(sp)
  80033c:	f0ca                	sd	s2,96(sp)
  80033e:	ecce                	sd	s3,88(sp)
  800340:	e4d6                	sd	s5,72(sp)
  800342:	e0da                	sd	s6,64(sp)
  800344:	fc5e                	sd	s7,56(sp)
  800346:	f862                	sd	s8,48(sp)
  800348:	ec6e                	sd	s11,24(sp)
  80034a:	fc86                	sd	ra,120(sp)
  80034c:	f8a2                	sd	s0,112(sp)
  80034e:	e8d2                	sd	s4,80(sp)
  800350:	f466                	sd	s9,40(sp)
  800352:	f06a                	sd	s10,32(sp)
  800354:	89aa                	mv	s3,a0
  800356:	892e                	mv	s2,a1
  800358:	84b2                	mv	s1,a2
  80035a:	8db6                	mv	s11,a3
  80035c:	8b3a                	mv	s6,a4
  80035e:	5bfd                	li	s7,-1
  800360:	00000a97          	auipc	s5,0x0
  800364:	4e4a8a93          	addi	s5,s5,1252 # 800844 <main+0x12a>
  800368:	05e00c13          	li	s8,94
  80036c:	000dc503          	lbu	a0,0(s11)
  800370:	02500793          	li	a5,37
  800374:	001d8413          	addi	s0,s11,1
  800378:	00f50f63          	beq	a0,a5,800396 <vprintfmt+0x5e>
  80037c:	c529                	beqz	a0,8003c6 <vprintfmt+0x8e>
  80037e:	02500a13          	li	s4,37
  800382:	a011                	j	800386 <vprintfmt+0x4e>
  800384:	c129                	beqz	a0,8003c6 <vprintfmt+0x8e>
  800386:	864a                	mv	a2,s2
  800388:	85a6                	mv	a1,s1
  80038a:	0405                	addi	s0,s0,1
  80038c:	9982                	jalr	s3
  80038e:	fff44503          	lbu	a0,-1(s0)
  800392:	ff4519e3          	bne	a0,s4,800384 <vprintfmt+0x4c>
  800396:	00044603          	lbu	a2,0(s0)
  80039a:	02000813          	li	a6,32
  80039e:	4a01                	li	s4,0
  8003a0:	4881                	li	a7,0
  8003a2:	5d7d                	li	s10,-1
  8003a4:	5cfd                	li	s9,-1
  8003a6:	05500593          	li	a1,85
  8003aa:	4525                	li	a0,9
  8003ac:	fdd6071b          	addiw	a4,a2,-35
  8003b0:	0ff77713          	andi	a4,a4,255
  8003b4:	00140d93          	addi	s11,s0,1
  8003b8:	22e5e363          	bltu	a1,a4,8005de <vprintfmt+0x2a6>
  8003bc:	070a                	slli	a4,a4,0x2
  8003be:	9756                	add	a4,a4,s5
  8003c0:	4318                	lw	a4,0(a4)
  8003c2:	9756                	add	a4,a4,s5
  8003c4:	8702                	jr	a4
  8003c6:	70e6                	ld	ra,120(sp)
  8003c8:	7446                	ld	s0,112(sp)
  8003ca:	74a6                	ld	s1,104(sp)
  8003cc:	7906                	ld	s2,96(sp)
  8003ce:	69e6                	ld	s3,88(sp)
  8003d0:	6a46                	ld	s4,80(sp)
  8003d2:	6aa6                	ld	s5,72(sp)
  8003d4:	6b06                	ld	s6,64(sp)
  8003d6:	7be2                	ld	s7,56(sp)
  8003d8:	7c42                	ld	s8,48(sp)
  8003da:	7ca2                	ld	s9,40(sp)
  8003dc:	7d02                	ld	s10,32(sp)
  8003de:	6de2                	ld	s11,24(sp)
  8003e0:	6109                	addi	sp,sp,128
  8003e2:	8082                	ret
  8003e4:	4705                	li	a4,1
  8003e6:	008b0613          	addi	a2,s6,8
  8003ea:	01174463          	blt	a4,a7,8003f2 <vprintfmt+0xba>
  8003ee:	28088563          	beqz	a7,800678 <vprintfmt+0x340>
  8003f2:	000b3683          	ld	a3,0(s6)
  8003f6:	4741                	li	a4,16
  8003f8:	8b32                	mv	s6,a2
  8003fa:	a86d                	j	8004b4 <vprintfmt+0x17c>
  8003fc:	00144603          	lbu	a2,1(s0)
  800400:	4a05                	li	s4,1
  800402:	846e                	mv	s0,s11
  800404:	b765                	j	8003ac <vprintfmt+0x74>
  800406:	000b2503          	lw	a0,0(s6)
  80040a:	864a                	mv	a2,s2
  80040c:	85a6                	mv	a1,s1
  80040e:	0b21                	addi	s6,s6,8
  800410:	9982                	jalr	s3
  800412:	bfa9                	j	80036c <vprintfmt+0x34>
  800414:	4705                	li	a4,1
  800416:	008b0a13          	addi	s4,s6,8
  80041a:	01174463          	blt	a4,a7,800422 <vprintfmt+0xea>
  80041e:	24088563          	beqz	a7,800668 <vprintfmt+0x330>
  800422:	000b3403          	ld	s0,0(s6)
  800426:	26044563          	bltz	s0,800690 <vprintfmt+0x358>
  80042a:	86a2                	mv	a3,s0
  80042c:	8b52                	mv	s6,s4
  80042e:	4729                	li	a4,10
  800430:	a051                	j	8004b4 <vprintfmt+0x17c>
  800432:	000b2783          	lw	a5,0(s6)
  800436:	46e1                	li	a3,24
  800438:	0b21                	addi	s6,s6,8
  80043a:	41f7d71b          	sraiw	a4,a5,0x1f
  80043e:	8fb9                	xor	a5,a5,a4
  800440:	40e7873b          	subw	a4,a5,a4
  800444:	1ce6c163          	blt	a3,a4,800606 <vprintfmt+0x2ce>
  800448:	00371793          	slli	a5,a4,0x3
  80044c:	00000697          	auipc	a3,0x0
  800450:	55468693          	addi	a3,a3,1364 # 8009a0 <error_string>
  800454:	97b6                	add	a5,a5,a3
  800456:	639c                	ld	a5,0(a5)
  800458:	1a078763          	beqz	a5,800606 <vprintfmt+0x2ce>
  80045c:	873e                	mv	a4,a5
  80045e:	00001697          	auipc	a3,0x1
  800462:	81268693          	addi	a3,a3,-2030 # 800c70 <error_string+0x2d0>
  800466:	8626                	mv	a2,s1
  800468:	85ca                	mv	a1,s2
  80046a:	854e                	mv	a0,s3
  80046c:	25a000ef          	jal	ra,8006c6 <printfmt>
  800470:	bdf5                	j	80036c <vprintfmt+0x34>
  800472:	00144603          	lbu	a2,1(s0)
  800476:	2885                	addiw	a7,a7,1
  800478:	846e                	mv	s0,s11
  80047a:	bf0d                	j	8003ac <vprintfmt+0x74>
  80047c:	4705                	li	a4,1
  80047e:	008b0613          	addi	a2,s6,8
  800482:	01174463          	blt	a4,a7,80048a <vprintfmt+0x152>
  800486:	1e088e63          	beqz	a7,800682 <vprintfmt+0x34a>
  80048a:	000b3683          	ld	a3,0(s6)
  80048e:	4721                	li	a4,8
  800490:	8b32                	mv	s6,a2
  800492:	a00d                	j	8004b4 <vprintfmt+0x17c>
  800494:	03000513          	li	a0,48
  800498:	864a                	mv	a2,s2
  80049a:	85a6                	mv	a1,s1
  80049c:	e042                	sd	a6,0(sp)
  80049e:	9982                	jalr	s3
  8004a0:	864a                	mv	a2,s2
  8004a2:	85a6                	mv	a1,s1
  8004a4:	07800513          	li	a0,120
  8004a8:	9982                	jalr	s3
  8004aa:	0b21                	addi	s6,s6,8
  8004ac:	ff8b3683          	ld	a3,-8(s6)
  8004b0:	6802                	ld	a6,0(sp)
  8004b2:	4741                	li	a4,16
  8004b4:	87e6                	mv	a5,s9
  8004b6:	8626                	mv	a2,s1
  8004b8:	85ca                	mv	a1,s2
  8004ba:	854e                	mv	a0,s3
  8004bc:	e07ff0ef          	jal	ra,8002c2 <printnum>
  8004c0:	b575                	j	80036c <vprintfmt+0x34>
  8004c2:	000b3703          	ld	a4,0(s6)
  8004c6:	0b21                	addi	s6,s6,8
  8004c8:	1e070063          	beqz	a4,8006a8 <vprintfmt+0x370>
  8004cc:	00170413          	addi	s0,a4,1
  8004d0:	19905563          	blez	s9,80065a <vprintfmt+0x322>
  8004d4:	02d00613          	li	a2,45
  8004d8:	14c81963          	bne	a6,a2,80062a <vprintfmt+0x2f2>
  8004dc:	00074703          	lbu	a4,0(a4)
  8004e0:	0007051b          	sext.w	a0,a4
  8004e4:	c90d                	beqz	a0,800516 <vprintfmt+0x1de>
  8004e6:	000d4563          	bltz	s10,8004f0 <vprintfmt+0x1b8>
  8004ea:	3d7d                	addiw	s10,s10,-1
  8004ec:	037d0363          	beq	s10,s7,800512 <vprintfmt+0x1da>
  8004f0:	864a                	mv	a2,s2
  8004f2:	85a6                	mv	a1,s1
  8004f4:	180a0c63          	beqz	s4,80068c <vprintfmt+0x354>
  8004f8:	3701                	addiw	a4,a4,-32
  8004fa:	18ec7963          	bleu	a4,s8,80068c <vprintfmt+0x354>
  8004fe:	03f00513          	li	a0,63
  800502:	9982                	jalr	s3
  800504:	0405                	addi	s0,s0,1
  800506:	fff44703          	lbu	a4,-1(s0)
  80050a:	3cfd                	addiw	s9,s9,-1
  80050c:	0007051b          	sext.w	a0,a4
  800510:	f979                	bnez	a0,8004e6 <vprintfmt+0x1ae>
  800512:	e5905de3          	blez	s9,80036c <vprintfmt+0x34>
  800516:	3cfd                	addiw	s9,s9,-1
  800518:	864a                	mv	a2,s2
  80051a:	85a6                	mv	a1,s1
  80051c:	02000513          	li	a0,32
  800520:	9982                	jalr	s3
  800522:	e40c85e3          	beqz	s9,80036c <vprintfmt+0x34>
  800526:	3cfd                	addiw	s9,s9,-1
  800528:	864a                	mv	a2,s2
  80052a:	85a6                	mv	a1,s1
  80052c:	02000513          	li	a0,32
  800530:	9982                	jalr	s3
  800532:	fe0c92e3          	bnez	s9,800516 <vprintfmt+0x1de>
  800536:	bd1d                	j	80036c <vprintfmt+0x34>
  800538:	4705                	li	a4,1
  80053a:	008b0613          	addi	a2,s6,8
  80053e:	01174463          	blt	a4,a7,800546 <vprintfmt+0x20e>
  800542:	12088663          	beqz	a7,80066e <vprintfmt+0x336>
  800546:	000b3683          	ld	a3,0(s6)
  80054a:	4729                	li	a4,10
  80054c:	8b32                	mv	s6,a2
  80054e:	b79d                	j	8004b4 <vprintfmt+0x17c>
  800550:	00144603          	lbu	a2,1(s0)
  800554:	02d00813          	li	a6,45
  800558:	846e                	mv	s0,s11
  80055a:	bd89                	j	8003ac <vprintfmt+0x74>
  80055c:	864a                	mv	a2,s2
  80055e:	85a6                	mv	a1,s1
  800560:	02500513          	li	a0,37
  800564:	9982                	jalr	s3
  800566:	b519                	j	80036c <vprintfmt+0x34>
  800568:	000b2d03          	lw	s10,0(s6)
  80056c:	00144603          	lbu	a2,1(s0)
  800570:	0b21                	addi	s6,s6,8
  800572:	846e                	mv	s0,s11
  800574:	e20cdce3          	bgez	s9,8003ac <vprintfmt+0x74>
  800578:	8cea                	mv	s9,s10
  80057a:	5d7d                	li	s10,-1
  80057c:	bd05                	j	8003ac <vprintfmt+0x74>
  80057e:	00144603          	lbu	a2,1(s0)
  800582:	03000813          	li	a6,48
  800586:	846e                	mv	s0,s11
  800588:	b515                	j	8003ac <vprintfmt+0x74>
  80058a:	fd060d1b          	addiw	s10,a2,-48
  80058e:	00144603          	lbu	a2,1(s0)
  800592:	846e                	mv	s0,s11
  800594:	fd06071b          	addiw	a4,a2,-48
  800598:	0006031b          	sext.w	t1,a2
  80059c:	fce56ce3          	bltu	a0,a4,800574 <vprintfmt+0x23c>
  8005a0:	0405                	addi	s0,s0,1
  8005a2:	002d171b          	slliw	a4,s10,0x2
  8005a6:	00044603          	lbu	a2,0(s0)
  8005aa:	01a706bb          	addw	a3,a4,s10
  8005ae:	0016969b          	slliw	a3,a3,0x1
  8005b2:	006686bb          	addw	a3,a3,t1
  8005b6:	fd06071b          	addiw	a4,a2,-48
  8005ba:	fd068d1b          	addiw	s10,a3,-48
  8005be:	0006031b          	sext.w	t1,a2
  8005c2:	fce57fe3          	bleu	a4,a0,8005a0 <vprintfmt+0x268>
  8005c6:	b77d                	j	800574 <vprintfmt+0x23c>
  8005c8:	fffcc713          	not	a4,s9
  8005cc:	977d                	srai	a4,a4,0x3f
  8005ce:	00ecf7b3          	and	a5,s9,a4
  8005d2:	00144603          	lbu	a2,1(s0)
  8005d6:	00078c9b          	sext.w	s9,a5
  8005da:	846e                	mv	s0,s11
  8005dc:	bbc1                	j	8003ac <vprintfmt+0x74>
  8005de:	864a                	mv	a2,s2
  8005e0:	85a6                	mv	a1,s1
  8005e2:	02500513          	li	a0,37
  8005e6:	9982                	jalr	s3
  8005e8:	fff44703          	lbu	a4,-1(s0)
  8005ec:	02500793          	li	a5,37
  8005f0:	8da2                	mv	s11,s0
  8005f2:	d6f70de3          	beq	a4,a5,80036c <vprintfmt+0x34>
  8005f6:	02500713          	li	a4,37
  8005fa:	1dfd                	addi	s11,s11,-1
  8005fc:	fffdc783          	lbu	a5,-1(s11)
  800600:	fee79de3          	bne	a5,a4,8005fa <vprintfmt+0x2c2>
  800604:	b3a5                	j	80036c <vprintfmt+0x34>
  800606:	00000697          	auipc	a3,0x0
  80060a:	65a68693          	addi	a3,a3,1626 # 800c60 <error_string+0x2c0>
  80060e:	8626                	mv	a2,s1
  800610:	85ca                	mv	a1,s2
  800612:	854e                	mv	a0,s3
  800614:	0b2000ef          	jal	ra,8006c6 <printfmt>
  800618:	bb91                	j	80036c <vprintfmt+0x34>
  80061a:	00000717          	auipc	a4,0x0
  80061e:	63e70713          	addi	a4,a4,1598 # 800c58 <error_string+0x2b8>
  800622:	00000417          	auipc	s0,0x0
  800626:	63740413          	addi	s0,s0,1591 # 800c59 <error_string+0x2b9>
  80062a:	853a                	mv	a0,a4
  80062c:	85ea                	mv	a1,s10
  80062e:	e03a                	sd	a4,0(sp)
  800630:	e442                	sd	a6,8(sp)
  800632:	c6bff0ef          	jal	ra,80029c <strnlen>
  800636:	40ac8cbb          	subw	s9,s9,a0
  80063a:	6702                	ld	a4,0(sp)
  80063c:	01905f63          	blez	s9,80065a <vprintfmt+0x322>
  800640:	6822                	ld	a6,8(sp)
  800642:	0008079b          	sext.w	a5,a6
  800646:	e43e                	sd	a5,8(sp)
  800648:	6522                	ld	a0,8(sp)
  80064a:	864a                	mv	a2,s2
  80064c:	85a6                	mv	a1,s1
  80064e:	e03a                	sd	a4,0(sp)
  800650:	3cfd                	addiw	s9,s9,-1
  800652:	9982                	jalr	s3
  800654:	6702                	ld	a4,0(sp)
  800656:	fe0c99e3          	bnez	s9,800648 <vprintfmt+0x310>
  80065a:	00074703          	lbu	a4,0(a4)
  80065e:	0007051b          	sext.w	a0,a4
  800662:	e80512e3          	bnez	a0,8004e6 <vprintfmt+0x1ae>
  800666:	b319                	j	80036c <vprintfmt+0x34>
  800668:	000b2403          	lw	s0,0(s6)
  80066c:	bb6d                	j	800426 <vprintfmt+0xee>
  80066e:	000b6683          	lwu	a3,0(s6)
  800672:	4729                	li	a4,10
  800674:	8b32                	mv	s6,a2
  800676:	bd3d                	j	8004b4 <vprintfmt+0x17c>
  800678:	000b6683          	lwu	a3,0(s6)
  80067c:	4741                	li	a4,16
  80067e:	8b32                	mv	s6,a2
  800680:	bd15                	j	8004b4 <vprintfmt+0x17c>
  800682:	000b6683          	lwu	a3,0(s6)
  800686:	4721                	li	a4,8
  800688:	8b32                	mv	s6,a2
  80068a:	b52d                	j	8004b4 <vprintfmt+0x17c>
  80068c:	9982                	jalr	s3
  80068e:	bd9d                	j	800504 <vprintfmt+0x1cc>
  800690:	864a                	mv	a2,s2
  800692:	85a6                	mv	a1,s1
  800694:	02d00513          	li	a0,45
  800698:	e042                	sd	a6,0(sp)
  80069a:	9982                	jalr	s3
  80069c:	8b52                	mv	s6,s4
  80069e:	408006b3          	neg	a3,s0
  8006a2:	4729                	li	a4,10
  8006a4:	6802                	ld	a6,0(sp)
  8006a6:	b539                	j	8004b4 <vprintfmt+0x17c>
  8006a8:	01905663          	blez	s9,8006b4 <vprintfmt+0x37c>
  8006ac:	02d00713          	li	a4,45
  8006b0:	f6e815e3          	bne	a6,a4,80061a <vprintfmt+0x2e2>
  8006b4:	00000417          	auipc	s0,0x0
  8006b8:	5a540413          	addi	s0,s0,1445 # 800c59 <error_string+0x2b9>
  8006bc:	02800513          	li	a0,40
  8006c0:	02800713          	li	a4,40
  8006c4:	b50d                	j	8004e6 <vprintfmt+0x1ae>

00000000008006c6 <printfmt>:
  8006c6:	7139                	addi	sp,sp,-64
  8006c8:	02010313          	addi	t1,sp,32
  8006cc:	f03a                	sd	a4,32(sp)
  8006ce:	871a                	mv	a4,t1
  8006d0:	ec06                	sd	ra,24(sp)
  8006d2:	f43e                	sd	a5,40(sp)
  8006d4:	f842                	sd	a6,48(sp)
  8006d6:	fc46                	sd	a7,56(sp)
  8006d8:	e41a                	sd	t1,8(sp)
  8006da:	c5fff0ef          	jal	ra,800338 <vprintfmt>
  8006de:	60e2                	ld	ra,24(sp)
  8006e0:	6121                	addi	sp,sp,64
  8006e2:	8082                	ret

00000000008006e4 <sleepy>:
  8006e4:	1101                	addi	sp,sp,-32
  8006e6:	e822                	sd	s0,16(sp)
  8006e8:	e426                	sd	s1,8(sp)
  8006ea:	e04a                	sd	s2,0(sp)
  8006ec:	ec06                	sd	ra,24(sp)
  8006ee:	4401                	li	s0,0
  8006f0:	00000917          	auipc	s2,0x0
  8006f4:	61090913          	addi	s2,s2,1552 # 800d00 <error_string+0x360>
  8006f8:	44a9                	li	s1,10
  8006fa:	06400513          	li	a0,100
  8006fe:	b97ff0ef          	jal	ra,800294 <sleep>
  800702:	2405                	addiw	s0,s0,1
  800704:	06400613          	li	a2,100
  800708:	85a2                	mv	a1,s0
  80070a:	854a                	mv	a0,s2
  80070c:	a75ff0ef          	jal	ra,800180 <cprintf>
  800710:	fe9415e3          	bne	s0,s1,8006fa <sleepy+0x16>
  800714:	4501                	li	a0,0
  800716:	b5dff0ef          	jal	ra,800272 <exit>

000000000080071a <main>:
  80071a:	1101                	addi	sp,sp,-32
  80071c:	e822                	sd	s0,16(sp)
  80071e:	ec06                	sd	ra,24(sp)
  800720:	b71ff0ef          	jal	ra,800290 <gettime_msec>
  800724:	0005041b          	sext.w	s0,a0
  800728:	b61ff0ef          	jal	ra,800288 <fork>
  80072c:	cd21                	beqz	a0,800784 <main+0x6a>
  80072e:	006c                	addi	a1,sp,12
  800730:	b5dff0ef          	jal	ra,80028c <waitpid>
  800734:	47b2                	lw	a5,12(sp)
  800736:	8d5d                	or	a0,a0,a5
  800738:	2501                	sext.w	a0,a0
  80073a:	e515                	bnez	a0,800766 <main+0x4c>
  80073c:	b55ff0ef          	jal	ra,800290 <gettime_msec>
  800740:	408505bb          	subw	a1,a0,s0
  800744:	00000517          	auipc	a0,0x0
  800748:	59450513          	addi	a0,a0,1428 # 800cd8 <error_string+0x338>
  80074c:	a35ff0ef          	jal	ra,800180 <cprintf>
  800750:	00000517          	auipc	a0,0x0
  800754:	5a050513          	addi	a0,a0,1440 # 800cf0 <error_string+0x350>
  800758:	a29ff0ef          	jal	ra,800180 <cprintf>
  80075c:	60e2                	ld	ra,24(sp)
  80075e:	6442                	ld	s0,16(sp)
  800760:	4501                	li	a0,0
  800762:	6105                	addi	sp,sp,32
  800764:	8082                	ret
  800766:	00000697          	auipc	a3,0x0
  80076a:	51268693          	addi	a3,a3,1298 # 800c78 <error_string+0x2d8>
  80076e:	00000617          	auipc	a2,0x0
  800772:	54260613          	addi	a2,a2,1346 # 800cb0 <error_string+0x310>
  800776:	45dd                	li	a1,23
  800778:	00000517          	auipc	a0,0x0
  80077c:	55050513          	addi	a0,a0,1360 # 800cc8 <error_string+0x328>
  800780:	8a1ff0ef          	jal	ra,800020 <__panic>
  800784:	f61ff0ef          	jal	ra,8006e4 <sleepy>
