
obj/__user_sleepkill.out：     文件格式 elf64-littleriscv


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
  800032:	73250513          	addi	a0,a0,1842 # 800760 <main+0x88>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	136000ef          	jal	ra,800178 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	108000ef          	jal	ra,800152 <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	77250513          	addi	a0,a0,1906 # 8007c0 <main+0xe8>
  800056:	122000ef          	jal	ra,800178 <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	20e000ef          	jal	ra,80026a <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00000517          	auipc	a0,0x0
  800072:	71250513          	addi	a0,a0,1810 # 800780 <main+0xa8>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	0f6000ef          	jal	ra,800178 <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	0c8000ef          	jal	ra,800152 <vcprintf>
  80008e:	00000517          	auipc	a0,0x0
  800092:	73250513          	addi	a0,a0,1842 # 8007c0 <main+0xe8>
  800096:	0e2000ef          	jal	ra,800178 <cprintf>
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

00000000008000e8 <sys_kill>:
  8000e8:	85aa                	mv	a1,a0
  8000ea:	4531                	li	a0,12
  8000ec:	fb7ff06f          	j	8000a2 <syscall>

00000000008000f0 <sys_putc>:
  8000f0:	85aa                	mv	a1,a0
  8000f2:	4579                	li	a0,30
  8000f4:	fafff06f          	j	8000a2 <syscall>

00000000008000f8 <sys_sleep>:
  8000f8:	85aa                	mv	a1,a0
  8000fa:	452d                	li	a0,11
  8000fc:	fa7ff06f          	j	8000a2 <syscall>

0000000000800100 <sys_open>:
  800100:	862e                	mv	a2,a1
  800102:	85aa                	mv	a1,a0
  800104:	06400513          	li	a0,100
  800108:	f9bff06f          	j	8000a2 <syscall>

000000000080010c <sys_close>:
  80010c:	85aa                	mv	a1,a0
  80010e:	06500513          	li	a0,101
  800112:	f91ff06f          	j	8000a2 <syscall>

0000000000800116 <sys_dup>:
  800116:	862e                	mv	a2,a1
  800118:	85aa                	mv	a1,a0
  80011a:	08200513          	li	a0,130
  80011e:	f85ff06f          	j	8000a2 <syscall>

0000000000800122 <_start>:
  800122:	0d4000ef          	jal	ra,8001f6 <umain>
  800126:	a001                	j	800126 <_start+0x4>

0000000000800128 <open>:
  800128:	1582                	slli	a1,a1,0x20
  80012a:	9181                	srli	a1,a1,0x20
  80012c:	fd5ff06f          	j	800100 <sys_open>

0000000000800130 <close>:
  800130:	fddff06f          	j	80010c <sys_close>

0000000000800134 <dup2>:
  800134:	fe3ff06f          	j	800116 <sys_dup>

0000000000800138 <cputch>:
  800138:	1141                	addi	sp,sp,-16
  80013a:	e022                	sd	s0,0(sp)
  80013c:	e406                	sd	ra,8(sp)
  80013e:	842e                	mv	s0,a1
  800140:	fb1ff0ef          	jal	ra,8000f0 <sys_putc>
  800144:	401c                	lw	a5,0(s0)
  800146:	60a2                	ld	ra,8(sp)
  800148:	2785                	addiw	a5,a5,1
  80014a:	c01c                	sw	a5,0(s0)
  80014c:	6402                	ld	s0,0(sp)
  80014e:	0141                	addi	sp,sp,16
  800150:	8082                	ret

0000000000800152 <vcprintf>:
  800152:	1101                	addi	sp,sp,-32
  800154:	872e                	mv	a4,a1
  800156:	75dd                	lui	a1,0xffff7
  800158:	86aa                	mv	a3,a0
  80015a:	0070                	addi	a2,sp,12
  80015c:	00000517          	auipc	a0,0x0
  800160:	fdc50513          	addi	a0,a0,-36 # 800138 <cputch>
  800164:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6161>
  800168:	ec06                	sd	ra,24(sp)
  80016a:	c602                	sw	zero,12(sp)
  80016c:	1c0000ef          	jal	ra,80032c <vprintfmt>
  800170:	60e2                	ld	ra,24(sp)
  800172:	4532                	lw	a0,12(sp)
  800174:	6105                	addi	sp,sp,32
  800176:	8082                	ret

0000000000800178 <cprintf>:
  800178:	711d                	addi	sp,sp,-96
  80017a:	02810313          	addi	t1,sp,40
  80017e:	f42e                	sd	a1,40(sp)
  800180:	75dd                	lui	a1,0xffff7
  800182:	f832                	sd	a2,48(sp)
  800184:	fc36                	sd	a3,56(sp)
  800186:	e0ba                	sd	a4,64(sp)
  800188:	86aa                	mv	a3,a0
  80018a:	0050                	addi	a2,sp,4
  80018c:	00000517          	auipc	a0,0x0
  800190:	fac50513          	addi	a0,a0,-84 # 800138 <cputch>
  800194:	871a                	mv	a4,t1
  800196:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6161>
  80019a:	ec06                	sd	ra,24(sp)
  80019c:	e4be                	sd	a5,72(sp)
  80019e:	e8c2                	sd	a6,80(sp)
  8001a0:	ecc6                	sd	a7,88(sp)
  8001a2:	e41a                	sd	t1,8(sp)
  8001a4:	c202                	sw	zero,4(sp)
  8001a6:	186000ef          	jal	ra,80032c <vprintfmt>
  8001aa:	60e2                	ld	ra,24(sp)
  8001ac:	4512                	lw	a0,4(sp)
  8001ae:	6125                	addi	sp,sp,96
  8001b0:	8082                	ret

00000000008001b2 <initfd>:
  8001b2:	1101                	addi	sp,sp,-32
  8001b4:	87ae                	mv	a5,a1
  8001b6:	e426                	sd	s1,8(sp)
  8001b8:	85b2                	mv	a1,a2
  8001ba:	84aa                	mv	s1,a0
  8001bc:	853e                	mv	a0,a5
  8001be:	e822                	sd	s0,16(sp)
  8001c0:	ec06                	sd	ra,24(sp)
  8001c2:	f67ff0ef          	jal	ra,800128 <open>
  8001c6:	842a                	mv	s0,a0
  8001c8:	00054463          	bltz	a0,8001d0 <initfd+0x1e>
  8001cc:	00951863          	bne	a0,s1,8001dc <initfd+0x2a>
  8001d0:	8522                	mv	a0,s0
  8001d2:	60e2                	ld	ra,24(sp)
  8001d4:	6442                	ld	s0,16(sp)
  8001d6:	64a2                	ld	s1,8(sp)
  8001d8:	6105                	addi	sp,sp,32
  8001da:	8082                	ret
  8001dc:	8526                	mv	a0,s1
  8001de:	f53ff0ef          	jal	ra,800130 <close>
  8001e2:	85a6                	mv	a1,s1
  8001e4:	8522                	mv	a0,s0
  8001e6:	f4fff0ef          	jal	ra,800134 <dup2>
  8001ea:	84aa                	mv	s1,a0
  8001ec:	8522                	mv	a0,s0
  8001ee:	f43ff0ef          	jal	ra,800130 <close>
  8001f2:	8426                	mv	s0,s1
  8001f4:	bff1                	j	8001d0 <initfd+0x1e>

00000000008001f6 <umain>:
  8001f6:	1101                	addi	sp,sp,-32
  8001f8:	e822                	sd	s0,16(sp)
  8001fa:	e426                	sd	s1,8(sp)
  8001fc:	842a                	mv	s0,a0
  8001fe:	84ae                	mv	s1,a1
  800200:	4601                	li	a2,0
  800202:	00000597          	auipc	a1,0x0
  800206:	59e58593          	addi	a1,a1,1438 # 8007a0 <main+0xc8>
  80020a:	4501                	li	a0,0
  80020c:	ec06                	sd	ra,24(sp)
  80020e:	fa5ff0ef          	jal	ra,8001b2 <initfd>
  800212:	02054263          	bltz	a0,800236 <umain+0x40>
  800216:	4605                	li	a2,1
  800218:	00000597          	auipc	a1,0x0
  80021c:	5c858593          	addi	a1,a1,1480 # 8007e0 <main+0x108>
  800220:	4505                	li	a0,1
  800222:	f91ff0ef          	jal	ra,8001b2 <initfd>
  800226:	02054563          	bltz	a0,800250 <umain+0x5a>
  80022a:	85a6                	mv	a1,s1
  80022c:	8522                	mv	a0,s0
  80022e:	4aa000ef          	jal	ra,8006d8 <main>
  800232:	038000ef          	jal	ra,80026a <exit>
  800236:	86aa                	mv	a3,a0
  800238:	00000617          	auipc	a2,0x0
  80023c:	57060613          	addi	a2,a2,1392 # 8007a8 <main+0xd0>
  800240:	45e9                	li	a1,26
  800242:	00000517          	auipc	a0,0x0
  800246:	58650513          	addi	a0,a0,1414 # 8007c8 <main+0xf0>
  80024a:	e17ff0ef          	jal	ra,800060 <__warn>
  80024e:	b7e1                	j	800216 <umain+0x20>
  800250:	86aa                	mv	a3,a0
  800252:	00000617          	auipc	a2,0x0
  800256:	59660613          	addi	a2,a2,1430 # 8007e8 <main+0x110>
  80025a:	45f5                	li	a1,29
  80025c:	00000517          	auipc	a0,0x0
  800260:	56c50513          	addi	a0,a0,1388 # 8007c8 <main+0xf0>
  800264:	dfdff0ef          	jal	ra,800060 <__warn>
  800268:	b7c9                	j	80022a <umain+0x34>

000000000080026a <exit>:
  80026a:	1141                	addi	sp,sp,-16
  80026c:	e406                	sd	ra,8(sp)
  80026e:	e6dff0ef          	jal	ra,8000da <sys_exit>
  800272:	00000517          	auipc	a0,0x0
  800276:	59650513          	addi	a0,a0,1430 # 800808 <main+0x130>
  80027a:	effff0ef          	jal	ra,800178 <cprintf>
  80027e:	a001                	j	80027e <exit+0x14>

0000000000800280 <fork>:
  800280:	e63ff06f          	j	8000e2 <sys_fork>

0000000000800284 <kill>:
  800284:	e65ff06f          	j	8000e8 <sys_kill>

0000000000800288 <sleep>:
  800288:	1502                	slli	a0,a0,0x20
  80028a:	9101                	srli	a0,a0,0x20
  80028c:	e6dff06f          	j	8000f8 <sys_sleep>

0000000000800290 <strnlen>:
  800290:	c185                	beqz	a1,8002b0 <strnlen+0x20>
  800292:	00054783          	lbu	a5,0(a0)
  800296:	cf89                	beqz	a5,8002b0 <strnlen+0x20>
  800298:	4781                	li	a5,0
  80029a:	a021                	j	8002a2 <strnlen+0x12>
  80029c:	00074703          	lbu	a4,0(a4)
  8002a0:	c711                	beqz	a4,8002ac <strnlen+0x1c>
  8002a2:	0785                	addi	a5,a5,1
  8002a4:	00f50733          	add	a4,a0,a5
  8002a8:	fef59ae3          	bne	a1,a5,80029c <strnlen+0xc>
  8002ac:	853e                	mv	a0,a5
  8002ae:	8082                	ret
  8002b0:	4781                	li	a5,0
  8002b2:	853e                	mv	a0,a5
  8002b4:	8082                	ret

00000000008002b6 <printnum>:
  8002b6:	02071893          	slli	a7,a4,0x20
  8002ba:	7139                	addi	sp,sp,-64
  8002bc:	0208d893          	srli	a7,a7,0x20
  8002c0:	e456                	sd	s5,8(sp)
  8002c2:	0316fab3          	remu	s5,a3,a7
  8002c6:	f822                	sd	s0,48(sp)
  8002c8:	f426                	sd	s1,40(sp)
  8002ca:	f04a                	sd	s2,32(sp)
  8002cc:	ec4e                	sd	s3,24(sp)
  8002ce:	fc06                	sd	ra,56(sp)
  8002d0:	e852                	sd	s4,16(sp)
  8002d2:	84aa                	mv	s1,a0
  8002d4:	89ae                	mv	s3,a1
  8002d6:	8932                	mv	s2,a2
  8002d8:	fff7841b          	addiw	s0,a5,-1
  8002dc:	2a81                	sext.w	s5,s5
  8002de:	0516f163          	bleu	a7,a3,800320 <printnum+0x6a>
  8002e2:	8a42                	mv	s4,a6
  8002e4:	00805863          	blez	s0,8002f4 <printnum+0x3e>
  8002e8:	347d                	addiw	s0,s0,-1
  8002ea:	864e                	mv	a2,s3
  8002ec:	85ca                	mv	a1,s2
  8002ee:	8552                	mv	a0,s4
  8002f0:	9482                	jalr	s1
  8002f2:	f87d                	bnez	s0,8002e8 <printnum+0x32>
  8002f4:	1a82                	slli	s5,s5,0x20
  8002f6:	020ada93          	srli	s5,s5,0x20
  8002fa:	00000797          	auipc	a5,0x0
  8002fe:	74678793          	addi	a5,a5,1862 # 800a40 <error_string+0xc8>
  800302:	9abe                	add	s5,s5,a5
  800304:	7442                	ld	s0,48(sp)
  800306:	000ac503          	lbu	a0,0(s5)
  80030a:	70e2                	ld	ra,56(sp)
  80030c:	6a42                	ld	s4,16(sp)
  80030e:	6aa2                	ld	s5,8(sp)
  800310:	864e                	mv	a2,s3
  800312:	85ca                	mv	a1,s2
  800314:	69e2                	ld	s3,24(sp)
  800316:	7902                	ld	s2,32(sp)
  800318:	8326                	mv	t1,s1
  80031a:	74a2                	ld	s1,40(sp)
  80031c:	6121                	addi	sp,sp,64
  80031e:	8302                	jr	t1
  800320:	0316d6b3          	divu	a3,a3,a7
  800324:	87a2                	mv	a5,s0
  800326:	f91ff0ef          	jal	ra,8002b6 <printnum>
  80032a:	b7e9                	j	8002f4 <printnum+0x3e>

000000000080032c <vprintfmt>:
  80032c:	7119                	addi	sp,sp,-128
  80032e:	f4a6                	sd	s1,104(sp)
  800330:	f0ca                	sd	s2,96(sp)
  800332:	ecce                	sd	s3,88(sp)
  800334:	e4d6                	sd	s5,72(sp)
  800336:	e0da                	sd	s6,64(sp)
  800338:	fc5e                	sd	s7,56(sp)
  80033a:	f862                	sd	s8,48(sp)
  80033c:	ec6e                	sd	s11,24(sp)
  80033e:	fc86                	sd	ra,120(sp)
  800340:	f8a2                	sd	s0,112(sp)
  800342:	e8d2                	sd	s4,80(sp)
  800344:	f466                	sd	s9,40(sp)
  800346:	f06a                	sd	s10,32(sp)
  800348:	89aa                	mv	s3,a0
  80034a:	892e                	mv	s2,a1
  80034c:	84b2                	mv	s1,a2
  80034e:	8db6                	mv	s11,a3
  800350:	8b3a                	mv	s6,a4
  800352:	5bfd                	li	s7,-1
  800354:	00000a97          	auipc	s5,0x0
  800358:	4c8a8a93          	addi	s5,s5,1224 # 80081c <main+0x144>
  80035c:	05e00c13          	li	s8,94
  800360:	000dc503          	lbu	a0,0(s11)
  800364:	02500793          	li	a5,37
  800368:	001d8413          	addi	s0,s11,1
  80036c:	00f50f63          	beq	a0,a5,80038a <vprintfmt+0x5e>
  800370:	c529                	beqz	a0,8003ba <vprintfmt+0x8e>
  800372:	02500a13          	li	s4,37
  800376:	a011                	j	80037a <vprintfmt+0x4e>
  800378:	c129                	beqz	a0,8003ba <vprintfmt+0x8e>
  80037a:	864a                	mv	a2,s2
  80037c:	85a6                	mv	a1,s1
  80037e:	0405                	addi	s0,s0,1
  800380:	9982                	jalr	s3
  800382:	fff44503          	lbu	a0,-1(s0)
  800386:	ff4519e3          	bne	a0,s4,800378 <vprintfmt+0x4c>
  80038a:	00044603          	lbu	a2,0(s0)
  80038e:	02000813          	li	a6,32
  800392:	4a01                	li	s4,0
  800394:	4881                	li	a7,0
  800396:	5d7d                	li	s10,-1
  800398:	5cfd                	li	s9,-1
  80039a:	05500593          	li	a1,85
  80039e:	4525                	li	a0,9
  8003a0:	fdd6071b          	addiw	a4,a2,-35
  8003a4:	0ff77713          	andi	a4,a4,255
  8003a8:	00140d93          	addi	s11,s0,1
  8003ac:	22e5e363          	bltu	a1,a4,8005d2 <vprintfmt+0x2a6>
  8003b0:	070a                	slli	a4,a4,0x2
  8003b2:	9756                	add	a4,a4,s5
  8003b4:	4318                	lw	a4,0(a4)
  8003b6:	9756                	add	a4,a4,s5
  8003b8:	8702                	jr	a4
  8003ba:	70e6                	ld	ra,120(sp)
  8003bc:	7446                	ld	s0,112(sp)
  8003be:	74a6                	ld	s1,104(sp)
  8003c0:	7906                	ld	s2,96(sp)
  8003c2:	69e6                	ld	s3,88(sp)
  8003c4:	6a46                	ld	s4,80(sp)
  8003c6:	6aa6                	ld	s5,72(sp)
  8003c8:	6b06                	ld	s6,64(sp)
  8003ca:	7be2                	ld	s7,56(sp)
  8003cc:	7c42                	ld	s8,48(sp)
  8003ce:	7ca2                	ld	s9,40(sp)
  8003d0:	7d02                	ld	s10,32(sp)
  8003d2:	6de2                	ld	s11,24(sp)
  8003d4:	6109                	addi	sp,sp,128
  8003d6:	8082                	ret
  8003d8:	4705                	li	a4,1
  8003da:	008b0613          	addi	a2,s6,8
  8003de:	01174463          	blt	a4,a7,8003e6 <vprintfmt+0xba>
  8003e2:	28088563          	beqz	a7,80066c <vprintfmt+0x340>
  8003e6:	000b3683          	ld	a3,0(s6)
  8003ea:	4741                	li	a4,16
  8003ec:	8b32                	mv	s6,a2
  8003ee:	a86d                	j	8004a8 <vprintfmt+0x17c>
  8003f0:	00144603          	lbu	a2,1(s0)
  8003f4:	4a05                	li	s4,1
  8003f6:	846e                	mv	s0,s11
  8003f8:	b765                	j	8003a0 <vprintfmt+0x74>
  8003fa:	000b2503          	lw	a0,0(s6)
  8003fe:	864a                	mv	a2,s2
  800400:	85a6                	mv	a1,s1
  800402:	0b21                	addi	s6,s6,8
  800404:	9982                	jalr	s3
  800406:	bfa9                	j	800360 <vprintfmt+0x34>
  800408:	4705                	li	a4,1
  80040a:	008b0a13          	addi	s4,s6,8
  80040e:	01174463          	blt	a4,a7,800416 <vprintfmt+0xea>
  800412:	24088563          	beqz	a7,80065c <vprintfmt+0x330>
  800416:	000b3403          	ld	s0,0(s6)
  80041a:	26044563          	bltz	s0,800684 <vprintfmt+0x358>
  80041e:	86a2                	mv	a3,s0
  800420:	8b52                	mv	s6,s4
  800422:	4729                	li	a4,10
  800424:	a051                	j	8004a8 <vprintfmt+0x17c>
  800426:	000b2783          	lw	a5,0(s6)
  80042a:	46e1                	li	a3,24
  80042c:	0b21                	addi	s6,s6,8
  80042e:	41f7d71b          	sraiw	a4,a5,0x1f
  800432:	8fb9                	xor	a5,a5,a4
  800434:	40e7873b          	subw	a4,a5,a4
  800438:	1ce6c163          	blt	a3,a4,8005fa <vprintfmt+0x2ce>
  80043c:	00371793          	slli	a5,a4,0x3
  800440:	00000697          	auipc	a3,0x0
  800444:	53868693          	addi	a3,a3,1336 # 800978 <error_string>
  800448:	97b6                	add	a5,a5,a3
  80044a:	639c                	ld	a5,0(a5)
  80044c:	1a078763          	beqz	a5,8005fa <vprintfmt+0x2ce>
  800450:	873e                	mv	a4,a5
  800452:	00000697          	auipc	a3,0x0
  800456:	7f668693          	addi	a3,a3,2038 # 800c48 <error_string+0x2d0>
  80045a:	8626                	mv	a2,s1
  80045c:	85ca                	mv	a1,s2
  80045e:	854e                	mv	a0,s3
  800460:	25a000ef          	jal	ra,8006ba <printfmt>
  800464:	bdf5                	j	800360 <vprintfmt+0x34>
  800466:	00144603          	lbu	a2,1(s0)
  80046a:	2885                	addiw	a7,a7,1
  80046c:	846e                	mv	s0,s11
  80046e:	bf0d                	j	8003a0 <vprintfmt+0x74>
  800470:	4705                	li	a4,1
  800472:	008b0613          	addi	a2,s6,8
  800476:	01174463          	blt	a4,a7,80047e <vprintfmt+0x152>
  80047a:	1e088e63          	beqz	a7,800676 <vprintfmt+0x34a>
  80047e:	000b3683          	ld	a3,0(s6)
  800482:	4721                	li	a4,8
  800484:	8b32                	mv	s6,a2
  800486:	a00d                	j	8004a8 <vprintfmt+0x17c>
  800488:	03000513          	li	a0,48
  80048c:	864a                	mv	a2,s2
  80048e:	85a6                	mv	a1,s1
  800490:	e042                	sd	a6,0(sp)
  800492:	9982                	jalr	s3
  800494:	864a                	mv	a2,s2
  800496:	85a6                	mv	a1,s1
  800498:	07800513          	li	a0,120
  80049c:	9982                	jalr	s3
  80049e:	0b21                	addi	s6,s6,8
  8004a0:	ff8b3683          	ld	a3,-8(s6)
  8004a4:	6802                	ld	a6,0(sp)
  8004a6:	4741                	li	a4,16
  8004a8:	87e6                	mv	a5,s9
  8004aa:	8626                	mv	a2,s1
  8004ac:	85ca                	mv	a1,s2
  8004ae:	854e                	mv	a0,s3
  8004b0:	e07ff0ef          	jal	ra,8002b6 <printnum>
  8004b4:	b575                	j	800360 <vprintfmt+0x34>
  8004b6:	000b3703          	ld	a4,0(s6)
  8004ba:	0b21                	addi	s6,s6,8
  8004bc:	1e070063          	beqz	a4,80069c <vprintfmt+0x370>
  8004c0:	00170413          	addi	s0,a4,1
  8004c4:	19905563          	blez	s9,80064e <vprintfmt+0x322>
  8004c8:	02d00613          	li	a2,45
  8004cc:	14c81963          	bne	a6,a2,80061e <vprintfmt+0x2f2>
  8004d0:	00074703          	lbu	a4,0(a4)
  8004d4:	0007051b          	sext.w	a0,a4
  8004d8:	c90d                	beqz	a0,80050a <vprintfmt+0x1de>
  8004da:	000d4563          	bltz	s10,8004e4 <vprintfmt+0x1b8>
  8004de:	3d7d                	addiw	s10,s10,-1
  8004e0:	037d0363          	beq	s10,s7,800506 <vprintfmt+0x1da>
  8004e4:	864a                	mv	a2,s2
  8004e6:	85a6                	mv	a1,s1
  8004e8:	180a0c63          	beqz	s4,800680 <vprintfmt+0x354>
  8004ec:	3701                	addiw	a4,a4,-32
  8004ee:	18ec7963          	bleu	a4,s8,800680 <vprintfmt+0x354>
  8004f2:	03f00513          	li	a0,63
  8004f6:	9982                	jalr	s3
  8004f8:	0405                	addi	s0,s0,1
  8004fa:	fff44703          	lbu	a4,-1(s0)
  8004fe:	3cfd                	addiw	s9,s9,-1
  800500:	0007051b          	sext.w	a0,a4
  800504:	f979                	bnez	a0,8004da <vprintfmt+0x1ae>
  800506:	e5905de3          	blez	s9,800360 <vprintfmt+0x34>
  80050a:	3cfd                	addiw	s9,s9,-1
  80050c:	864a                	mv	a2,s2
  80050e:	85a6                	mv	a1,s1
  800510:	02000513          	li	a0,32
  800514:	9982                	jalr	s3
  800516:	e40c85e3          	beqz	s9,800360 <vprintfmt+0x34>
  80051a:	3cfd                	addiw	s9,s9,-1
  80051c:	864a                	mv	a2,s2
  80051e:	85a6                	mv	a1,s1
  800520:	02000513          	li	a0,32
  800524:	9982                	jalr	s3
  800526:	fe0c92e3          	bnez	s9,80050a <vprintfmt+0x1de>
  80052a:	bd1d                	j	800360 <vprintfmt+0x34>
  80052c:	4705                	li	a4,1
  80052e:	008b0613          	addi	a2,s6,8
  800532:	01174463          	blt	a4,a7,80053a <vprintfmt+0x20e>
  800536:	12088663          	beqz	a7,800662 <vprintfmt+0x336>
  80053a:	000b3683          	ld	a3,0(s6)
  80053e:	4729                	li	a4,10
  800540:	8b32                	mv	s6,a2
  800542:	b79d                	j	8004a8 <vprintfmt+0x17c>
  800544:	00144603          	lbu	a2,1(s0)
  800548:	02d00813          	li	a6,45
  80054c:	846e                	mv	s0,s11
  80054e:	bd89                	j	8003a0 <vprintfmt+0x74>
  800550:	864a                	mv	a2,s2
  800552:	85a6                	mv	a1,s1
  800554:	02500513          	li	a0,37
  800558:	9982                	jalr	s3
  80055a:	b519                	j	800360 <vprintfmt+0x34>
  80055c:	000b2d03          	lw	s10,0(s6)
  800560:	00144603          	lbu	a2,1(s0)
  800564:	0b21                	addi	s6,s6,8
  800566:	846e                	mv	s0,s11
  800568:	e20cdce3          	bgez	s9,8003a0 <vprintfmt+0x74>
  80056c:	8cea                	mv	s9,s10
  80056e:	5d7d                	li	s10,-1
  800570:	bd05                	j	8003a0 <vprintfmt+0x74>
  800572:	00144603          	lbu	a2,1(s0)
  800576:	03000813          	li	a6,48
  80057a:	846e                	mv	s0,s11
  80057c:	b515                	j	8003a0 <vprintfmt+0x74>
  80057e:	fd060d1b          	addiw	s10,a2,-48
  800582:	00144603          	lbu	a2,1(s0)
  800586:	846e                	mv	s0,s11
  800588:	fd06071b          	addiw	a4,a2,-48
  80058c:	0006031b          	sext.w	t1,a2
  800590:	fce56ce3          	bltu	a0,a4,800568 <vprintfmt+0x23c>
  800594:	0405                	addi	s0,s0,1
  800596:	002d171b          	slliw	a4,s10,0x2
  80059a:	00044603          	lbu	a2,0(s0)
  80059e:	01a706bb          	addw	a3,a4,s10
  8005a2:	0016969b          	slliw	a3,a3,0x1
  8005a6:	006686bb          	addw	a3,a3,t1
  8005aa:	fd06071b          	addiw	a4,a2,-48
  8005ae:	fd068d1b          	addiw	s10,a3,-48
  8005b2:	0006031b          	sext.w	t1,a2
  8005b6:	fce57fe3          	bleu	a4,a0,800594 <vprintfmt+0x268>
  8005ba:	b77d                	j	800568 <vprintfmt+0x23c>
  8005bc:	fffcc713          	not	a4,s9
  8005c0:	977d                	srai	a4,a4,0x3f
  8005c2:	00ecf7b3          	and	a5,s9,a4
  8005c6:	00144603          	lbu	a2,1(s0)
  8005ca:	00078c9b          	sext.w	s9,a5
  8005ce:	846e                	mv	s0,s11
  8005d0:	bbc1                	j	8003a0 <vprintfmt+0x74>
  8005d2:	864a                	mv	a2,s2
  8005d4:	85a6                	mv	a1,s1
  8005d6:	02500513          	li	a0,37
  8005da:	9982                	jalr	s3
  8005dc:	fff44703          	lbu	a4,-1(s0)
  8005e0:	02500793          	li	a5,37
  8005e4:	8da2                	mv	s11,s0
  8005e6:	d6f70de3          	beq	a4,a5,800360 <vprintfmt+0x34>
  8005ea:	02500713          	li	a4,37
  8005ee:	1dfd                	addi	s11,s11,-1
  8005f0:	fffdc783          	lbu	a5,-1(s11)
  8005f4:	fee79de3          	bne	a5,a4,8005ee <vprintfmt+0x2c2>
  8005f8:	b3a5                	j	800360 <vprintfmt+0x34>
  8005fa:	00000697          	auipc	a3,0x0
  8005fe:	63e68693          	addi	a3,a3,1598 # 800c38 <error_string+0x2c0>
  800602:	8626                	mv	a2,s1
  800604:	85ca                	mv	a1,s2
  800606:	854e                	mv	a0,s3
  800608:	0b2000ef          	jal	ra,8006ba <printfmt>
  80060c:	bb91                	j	800360 <vprintfmt+0x34>
  80060e:	00000717          	auipc	a4,0x0
  800612:	62270713          	addi	a4,a4,1570 # 800c30 <error_string+0x2b8>
  800616:	00000417          	auipc	s0,0x0
  80061a:	61b40413          	addi	s0,s0,1563 # 800c31 <error_string+0x2b9>
  80061e:	853a                	mv	a0,a4
  800620:	85ea                	mv	a1,s10
  800622:	e03a                	sd	a4,0(sp)
  800624:	e442                	sd	a6,8(sp)
  800626:	c6bff0ef          	jal	ra,800290 <strnlen>
  80062a:	40ac8cbb          	subw	s9,s9,a0
  80062e:	6702                	ld	a4,0(sp)
  800630:	01905f63          	blez	s9,80064e <vprintfmt+0x322>
  800634:	6822                	ld	a6,8(sp)
  800636:	0008079b          	sext.w	a5,a6
  80063a:	e43e                	sd	a5,8(sp)
  80063c:	6522                	ld	a0,8(sp)
  80063e:	864a                	mv	a2,s2
  800640:	85a6                	mv	a1,s1
  800642:	e03a                	sd	a4,0(sp)
  800644:	3cfd                	addiw	s9,s9,-1
  800646:	9982                	jalr	s3
  800648:	6702                	ld	a4,0(sp)
  80064a:	fe0c99e3          	bnez	s9,80063c <vprintfmt+0x310>
  80064e:	00074703          	lbu	a4,0(a4)
  800652:	0007051b          	sext.w	a0,a4
  800656:	e80512e3          	bnez	a0,8004da <vprintfmt+0x1ae>
  80065a:	b319                	j	800360 <vprintfmt+0x34>
  80065c:	000b2403          	lw	s0,0(s6)
  800660:	bb6d                	j	80041a <vprintfmt+0xee>
  800662:	000b6683          	lwu	a3,0(s6)
  800666:	4729                	li	a4,10
  800668:	8b32                	mv	s6,a2
  80066a:	bd3d                	j	8004a8 <vprintfmt+0x17c>
  80066c:	000b6683          	lwu	a3,0(s6)
  800670:	4741                	li	a4,16
  800672:	8b32                	mv	s6,a2
  800674:	bd15                	j	8004a8 <vprintfmt+0x17c>
  800676:	000b6683          	lwu	a3,0(s6)
  80067a:	4721                	li	a4,8
  80067c:	8b32                	mv	s6,a2
  80067e:	b52d                	j	8004a8 <vprintfmt+0x17c>
  800680:	9982                	jalr	s3
  800682:	bd9d                	j	8004f8 <vprintfmt+0x1cc>
  800684:	864a                	mv	a2,s2
  800686:	85a6                	mv	a1,s1
  800688:	02d00513          	li	a0,45
  80068c:	e042                	sd	a6,0(sp)
  80068e:	9982                	jalr	s3
  800690:	8b52                	mv	s6,s4
  800692:	408006b3          	neg	a3,s0
  800696:	4729                	li	a4,10
  800698:	6802                	ld	a6,0(sp)
  80069a:	b539                	j	8004a8 <vprintfmt+0x17c>
  80069c:	01905663          	blez	s9,8006a8 <vprintfmt+0x37c>
  8006a0:	02d00713          	li	a4,45
  8006a4:	f6e815e3          	bne	a6,a4,80060e <vprintfmt+0x2e2>
  8006a8:	00000417          	auipc	s0,0x0
  8006ac:	58940413          	addi	s0,s0,1417 # 800c31 <error_string+0x2b9>
  8006b0:	02800513          	li	a0,40
  8006b4:	02800713          	li	a4,40
  8006b8:	b50d                	j	8004da <vprintfmt+0x1ae>

00000000008006ba <printfmt>:
  8006ba:	7139                	addi	sp,sp,-64
  8006bc:	02010313          	addi	t1,sp,32
  8006c0:	f03a                	sd	a4,32(sp)
  8006c2:	871a                	mv	a4,t1
  8006c4:	ec06                	sd	ra,24(sp)
  8006c6:	f43e                	sd	a5,40(sp)
  8006c8:	f842                	sd	a6,48(sp)
  8006ca:	fc46                	sd	a7,56(sp)
  8006cc:	e41a                	sd	t1,8(sp)
  8006ce:	c5fff0ef          	jal	ra,80032c <vprintfmt>
  8006d2:	60e2                	ld	ra,24(sp)
  8006d4:	6121                	addi	sp,sp,64
  8006d6:	8082                	ret

00000000008006d8 <main>:
  8006d8:	1141                	addi	sp,sp,-16
  8006da:	e406                	sd	ra,8(sp)
  8006dc:	e022                	sd	s0,0(sp)
  8006de:	ba3ff0ef          	jal	ra,800280 <fork>
  8006e2:	c51d                	beqz	a0,800710 <main+0x38>
  8006e4:	842a                	mv	s0,a0
  8006e6:	04a05c63          	blez	a0,80073e <main+0x66>
  8006ea:	06400513          	li	a0,100
  8006ee:	b9bff0ef          	jal	ra,800288 <sleep>
  8006f2:	8522                	mv	a0,s0
  8006f4:	b91ff0ef          	jal	ra,800284 <kill>
  8006f8:	e505                	bnez	a0,800720 <main+0x48>
  8006fa:	00000517          	auipc	a0,0x0
  8006fe:	59e50513          	addi	a0,a0,1438 # 800c98 <error_string+0x320>
  800702:	a77ff0ef          	jal	ra,800178 <cprintf>
  800706:	60a2                	ld	ra,8(sp)
  800708:	6402                	ld	s0,0(sp)
  80070a:	4501                	li	a0,0
  80070c:	0141                	addi	sp,sp,16
  80070e:	8082                	ret
  800710:	557d                	li	a0,-1
  800712:	b77ff0ef          	jal	ra,800288 <sleep>
  800716:	6539                	lui	a0,0xe
  800718:	ead50513          	addi	a0,a0,-339 # dead <__panic-0x7f2173>
  80071c:	b4fff0ef          	jal	ra,80026a <exit>
  800720:	00000697          	auipc	a3,0x0
  800724:	56868693          	addi	a3,a3,1384 # 800c88 <error_string+0x310>
  800728:	00000617          	auipc	a2,0x0
  80072c:	53060613          	addi	a2,a2,1328 # 800c58 <error_string+0x2e0>
  800730:	45b9                	li	a1,14
  800732:	00000517          	auipc	a0,0x0
  800736:	53e50513          	addi	a0,a0,1342 # 800c70 <error_string+0x2f8>
  80073a:	8e7ff0ef          	jal	ra,800020 <__panic>
  80073e:	00000697          	auipc	a3,0x0
  800742:	51268693          	addi	a3,a3,1298 # 800c50 <error_string+0x2d8>
  800746:	00000617          	auipc	a2,0x0
  80074a:	51260613          	addi	a2,a2,1298 # 800c58 <error_string+0x2e0>
  80074e:	45ad                	li	a1,11
  800750:	00000517          	auipc	a0,0x0
  800754:	52050513          	addi	a0,a0,1312 # 800c70 <error_string+0x2f8>
  800758:	8c9ff0ef          	jal	ra,800020 <__panic>
