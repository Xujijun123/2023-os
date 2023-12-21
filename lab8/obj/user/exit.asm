
obj/__user_exit.out：     文件格式 elf64-littleriscv


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
  800032:	7ca50513          	addi	a0,a0,1994 # 8007f8 <main+0x11c>
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
  80004e:	00001517          	auipc	a0,0x1
  800052:	80a50513          	addi	a0,a0,-2038 # 800858 <main+0x17c>
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
  800072:	7aa50513          	addi	a0,a0,1962 # 800818 <main+0x13c>
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
  800092:	7ca50513          	addi	a0,a0,1994 # 800858 <main+0x17c>
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

00000000008000e8 <sys_wait>:
  8000e8:	862e                	mv	a2,a1
  8000ea:	85aa                	mv	a1,a0
  8000ec:	450d                	li	a0,3
  8000ee:	fb5ff06f          	j	8000a2 <syscall>

00000000008000f2 <sys_yield>:
  8000f2:	4529                	li	a0,10
  8000f4:	fafff06f          	j	8000a2 <syscall>

00000000008000f8 <sys_putc>:
  8000f8:	85aa                	mv	a1,a0
  8000fa:	4579                	li	a0,30
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
  800140:	fb9ff0ef          	jal	ra,8000f8 <sys_putc>
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
  800164:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  800168:	ec06                	sd	ra,24(sp)
  80016a:	c602                	sw	zero,12(sp)
  80016c:	1c4000ef          	jal	ra,800330 <vprintfmt>
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
  800196:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  80019a:	ec06                	sd	ra,24(sp)
  80019c:	e4be                	sd	a5,72(sp)
  80019e:	e8c2                	sd	a6,80(sp)
  8001a0:	ecc6                	sd	a7,88(sp)
  8001a2:	e41a                	sd	t1,8(sp)
  8001a4:	c202                	sw	zero,4(sp)
  8001a6:	18a000ef          	jal	ra,800330 <vprintfmt>
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
  800206:	63658593          	addi	a1,a1,1590 # 800838 <main+0x15c>
  80020a:	4501                	li	a0,0
  80020c:	ec06                	sd	ra,24(sp)
  80020e:	fa5ff0ef          	jal	ra,8001b2 <initfd>
  800212:	02054263          	bltz	a0,800236 <umain+0x40>
  800216:	4605                	li	a2,1
  800218:	00000597          	auipc	a1,0x0
  80021c:	66058593          	addi	a1,a1,1632 # 800878 <main+0x19c>
  800220:	4505                	li	a0,1
  800222:	f91ff0ef          	jal	ra,8001b2 <initfd>
  800226:	02054563          	bltz	a0,800250 <umain+0x5a>
  80022a:	85a6                	mv	a1,s1
  80022c:	8522                	mv	a0,s0
  80022e:	4ae000ef          	jal	ra,8006dc <main>
  800232:	038000ef          	jal	ra,80026a <exit>
  800236:	86aa                	mv	a3,a0
  800238:	00000617          	auipc	a2,0x0
  80023c:	60860613          	addi	a2,a2,1544 # 800840 <main+0x164>
  800240:	45e9                	li	a1,26
  800242:	00000517          	auipc	a0,0x0
  800246:	61e50513          	addi	a0,a0,1566 # 800860 <main+0x184>
  80024a:	e17ff0ef          	jal	ra,800060 <__warn>
  80024e:	b7e1                	j	800216 <umain+0x20>
  800250:	86aa                	mv	a3,a0
  800252:	00000617          	auipc	a2,0x0
  800256:	62e60613          	addi	a2,a2,1582 # 800880 <main+0x1a4>
  80025a:	45f5                	li	a1,29
  80025c:	00000517          	auipc	a0,0x0
  800260:	60450513          	addi	a0,a0,1540 # 800860 <main+0x184>
  800264:	dfdff0ef          	jal	ra,800060 <__warn>
  800268:	b7c9                	j	80022a <umain+0x34>

000000000080026a <exit>:
  80026a:	1141                	addi	sp,sp,-16
  80026c:	e406                	sd	ra,8(sp)
  80026e:	e6dff0ef          	jal	ra,8000da <sys_exit>
  800272:	00000517          	auipc	a0,0x0
  800276:	62e50513          	addi	a0,a0,1582 # 8008a0 <main+0x1c4>
  80027a:	effff0ef          	jal	ra,800178 <cprintf>
  80027e:	a001                	j	80027e <exit+0x14>

0000000000800280 <fork>:
  800280:	e63ff06f          	j	8000e2 <sys_fork>

0000000000800284 <wait>:
  800284:	4581                	li	a1,0
  800286:	4501                	li	a0,0
  800288:	e61ff06f          	j	8000e8 <sys_wait>

000000000080028c <waitpid>:
  80028c:	e5dff06f          	j	8000e8 <sys_wait>

0000000000800290 <yield>:
  800290:	e63ff06f          	j	8000f2 <sys_yield>

0000000000800294 <strnlen>:
  800294:	c185                	beqz	a1,8002b4 <strnlen+0x20>
  800296:	00054783          	lbu	a5,0(a0)
  80029a:	cf89                	beqz	a5,8002b4 <strnlen+0x20>
  80029c:	4781                	li	a5,0
  80029e:	a021                	j	8002a6 <strnlen+0x12>
  8002a0:	00074703          	lbu	a4,0(a4)
  8002a4:	c711                	beqz	a4,8002b0 <strnlen+0x1c>
  8002a6:	0785                	addi	a5,a5,1
  8002a8:	00f50733          	add	a4,a0,a5
  8002ac:	fef59ae3          	bne	a1,a5,8002a0 <strnlen+0xc>
  8002b0:	853e                	mv	a0,a5
  8002b2:	8082                	ret
  8002b4:	4781                	li	a5,0
  8002b6:	853e                	mv	a0,a5
  8002b8:	8082                	ret

00000000008002ba <printnum>:
  8002ba:	02071893          	slli	a7,a4,0x20
  8002be:	7139                	addi	sp,sp,-64
  8002c0:	0208d893          	srli	a7,a7,0x20
  8002c4:	e456                	sd	s5,8(sp)
  8002c6:	0316fab3          	remu	s5,a3,a7
  8002ca:	f822                	sd	s0,48(sp)
  8002cc:	f426                	sd	s1,40(sp)
  8002ce:	f04a                	sd	s2,32(sp)
  8002d0:	ec4e                	sd	s3,24(sp)
  8002d2:	fc06                	sd	ra,56(sp)
  8002d4:	e852                	sd	s4,16(sp)
  8002d6:	84aa                	mv	s1,a0
  8002d8:	89ae                	mv	s3,a1
  8002da:	8932                	mv	s2,a2
  8002dc:	fff7841b          	addiw	s0,a5,-1
  8002e0:	2a81                	sext.w	s5,s5
  8002e2:	0516f163          	bleu	a7,a3,800324 <printnum+0x6a>
  8002e6:	8a42                	mv	s4,a6
  8002e8:	00805863          	blez	s0,8002f8 <printnum+0x3e>
  8002ec:	347d                	addiw	s0,s0,-1
  8002ee:	864e                	mv	a2,s3
  8002f0:	85ca                	mv	a1,s2
  8002f2:	8552                	mv	a0,s4
  8002f4:	9482                	jalr	s1
  8002f6:	f87d                	bnez	s0,8002ec <printnum+0x32>
  8002f8:	1a82                	slli	s5,s5,0x20
  8002fa:	020ada93          	srli	s5,s5,0x20
  8002fe:	00000797          	auipc	a5,0x0
  800302:	7da78793          	addi	a5,a5,2010 # 800ad8 <error_string+0xc8>
  800306:	9abe                	add	s5,s5,a5
  800308:	7442                	ld	s0,48(sp)
  80030a:	000ac503          	lbu	a0,0(s5)
  80030e:	70e2                	ld	ra,56(sp)
  800310:	6a42                	ld	s4,16(sp)
  800312:	6aa2                	ld	s5,8(sp)
  800314:	864e                	mv	a2,s3
  800316:	85ca                	mv	a1,s2
  800318:	69e2                	ld	s3,24(sp)
  80031a:	7902                	ld	s2,32(sp)
  80031c:	8326                	mv	t1,s1
  80031e:	74a2                	ld	s1,40(sp)
  800320:	6121                	addi	sp,sp,64
  800322:	8302                	jr	t1
  800324:	0316d6b3          	divu	a3,a3,a7
  800328:	87a2                	mv	a5,s0
  80032a:	f91ff0ef          	jal	ra,8002ba <printnum>
  80032e:	b7e9                	j	8002f8 <printnum+0x3e>

0000000000800330 <vprintfmt>:
  800330:	7119                	addi	sp,sp,-128
  800332:	f4a6                	sd	s1,104(sp)
  800334:	f0ca                	sd	s2,96(sp)
  800336:	ecce                	sd	s3,88(sp)
  800338:	e4d6                	sd	s5,72(sp)
  80033a:	e0da                	sd	s6,64(sp)
  80033c:	fc5e                	sd	s7,56(sp)
  80033e:	f862                	sd	s8,48(sp)
  800340:	ec6e                	sd	s11,24(sp)
  800342:	fc86                	sd	ra,120(sp)
  800344:	f8a2                	sd	s0,112(sp)
  800346:	e8d2                	sd	s4,80(sp)
  800348:	f466                	sd	s9,40(sp)
  80034a:	f06a                	sd	s10,32(sp)
  80034c:	89aa                	mv	s3,a0
  80034e:	892e                	mv	s2,a1
  800350:	84b2                	mv	s1,a2
  800352:	8db6                	mv	s11,a3
  800354:	8b3a                	mv	s6,a4
  800356:	5bfd                	li	s7,-1
  800358:	00000a97          	auipc	s5,0x0
  80035c:	55ca8a93          	addi	s5,s5,1372 # 8008b4 <main+0x1d8>
  800360:	05e00c13          	li	s8,94
  800364:	000dc503          	lbu	a0,0(s11)
  800368:	02500793          	li	a5,37
  80036c:	001d8413          	addi	s0,s11,1
  800370:	00f50f63          	beq	a0,a5,80038e <vprintfmt+0x5e>
  800374:	c529                	beqz	a0,8003be <vprintfmt+0x8e>
  800376:	02500a13          	li	s4,37
  80037a:	a011                	j	80037e <vprintfmt+0x4e>
  80037c:	c129                	beqz	a0,8003be <vprintfmt+0x8e>
  80037e:	864a                	mv	a2,s2
  800380:	85a6                	mv	a1,s1
  800382:	0405                	addi	s0,s0,1
  800384:	9982                	jalr	s3
  800386:	fff44503          	lbu	a0,-1(s0)
  80038a:	ff4519e3          	bne	a0,s4,80037c <vprintfmt+0x4c>
  80038e:	00044603          	lbu	a2,0(s0)
  800392:	02000813          	li	a6,32
  800396:	4a01                	li	s4,0
  800398:	4881                	li	a7,0
  80039a:	5d7d                	li	s10,-1
  80039c:	5cfd                	li	s9,-1
  80039e:	05500593          	li	a1,85
  8003a2:	4525                	li	a0,9
  8003a4:	fdd6071b          	addiw	a4,a2,-35
  8003a8:	0ff77713          	andi	a4,a4,255
  8003ac:	00140d93          	addi	s11,s0,1
  8003b0:	22e5e363          	bltu	a1,a4,8005d6 <vprintfmt+0x2a6>
  8003b4:	070a                	slli	a4,a4,0x2
  8003b6:	9756                	add	a4,a4,s5
  8003b8:	4318                	lw	a4,0(a4)
  8003ba:	9756                	add	a4,a4,s5
  8003bc:	8702                	jr	a4
  8003be:	70e6                	ld	ra,120(sp)
  8003c0:	7446                	ld	s0,112(sp)
  8003c2:	74a6                	ld	s1,104(sp)
  8003c4:	7906                	ld	s2,96(sp)
  8003c6:	69e6                	ld	s3,88(sp)
  8003c8:	6a46                	ld	s4,80(sp)
  8003ca:	6aa6                	ld	s5,72(sp)
  8003cc:	6b06                	ld	s6,64(sp)
  8003ce:	7be2                	ld	s7,56(sp)
  8003d0:	7c42                	ld	s8,48(sp)
  8003d2:	7ca2                	ld	s9,40(sp)
  8003d4:	7d02                	ld	s10,32(sp)
  8003d6:	6de2                	ld	s11,24(sp)
  8003d8:	6109                	addi	sp,sp,128
  8003da:	8082                	ret
  8003dc:	4705                	li	a4,1
  8003de:	008b0613          	addi	a2,s6,8
  8003e2:	01174463          	blt	a4,a7,8003ea <vprintfmt+0xba>
  8003e6:	28088563          	beqz	a7,800670 <vprintfmt+0x340>
  8003ea:	000b3683          	ld	a3,0(s6)
  8003ee:	4741                	li	a4,16
  8003f0:	8b32                	mv	s6,a2
  8003f2:	a86d                	j	8004ac <vprintfmt+0x17c>
  8003f4:	00144603          	lbu	a2,1(s0)
  8003f8:	4a05                	li	s4,1
  8003fa:	846e                	mv	s0,s11
  8003fc:	b765                	j	8003a4 <vprintfmt+0x74>
  8003fe:	000b2503          	lw	a0,0(s6)
  800402:	864a                	mv	a2,s2
  800404:	85a6                	mv	a1,s1
  800406:	0b21                	addi	s6,s6,8
  800408:	9982                	jalr	s3
  80040a:	bfa9                	j	800364 <vprintfmt+0x34>
  80040c:	4705                	li	a4,1
  80040e:	008b0a13          	addi	s4,s6,8
  800412:	01174463          	blt	a4,a7,80041a <vprintfmt+0xea>
  800416:	24088563          	beqz	a7,800660 <vprintfmt+0x330>
  80041a:	000b3403          	ld	s0,0(s6)
  80041e:	26044563          	bltz	s0,800688 <vprintfmt+0x358>
  800422:	86a2                	mv	a3,s0
  800424:	8b52                	mv	s6,s4
  800426:	4729                	li	a4,10
  800428:	a051                	j	8004ac <vprintfmt+0x17c>
  80042a:	000b2783          	lw	a5,0(s6)
  80042e:	46e1                	li	a3,24
  800430:	0b21                	addi	s6,s6,8
  800432:	41f7d71b          	sraiw	a4,a5,0x1f
  800436:	8fb9                	xor	a5,a5,a4
  800438:	40e7873b          	subw	a4,a5,a4
  80043c:	1ce6c163          	blt	a3,a4,8005fe <vprintfmt+0x2ce>
  800440:	00371793          	slli	a5,a4,0x3
  800444:	00000697          	auipc	a3,0x0
  800448:	5cc68693          	addi	a3,a3,1484 # 800a10 <error_string>
  80044c:	97b6                	add	a5,a5,a3
  80044e:	639c                	ld	a5,0(a5)
  800450:	1a078763          	beqz	a5,8005fe <vprintfmt+0x2ce>
  800454:	873e                	mv	a4,a5
  800456:	00001697          	auipc	a3,0x1
  80045a:	88a68693          	addi	a3,a3,-1910 # 800ce0 <error_string+0x2d0>
  80045e:	8626                	mv	a2,s1
  800460:	85ca                	mv	a1,s2
  800462:	854e                	mv	a0,s3
  800464:	25a000ef          	jal	ra,8006be <printfmt>
  800468:	bdf5                	j	800364 <vprintfmt+0x34>
  80046a:	00144603          	lbu	a2,1(s0)
  80046e:	2885                	addiw	a7,a7,1
  800470:	846e                	mv	s0,s11
  800472:	bf0d                	j	8003a4 <vprintfmt+0x74>
  800474:	4705                	li	a4,1
  800476:	008b0613          	addi	a2,s6,8
  80047a:	01174463          	blt	a4,a7,800482 <vprintfmt+0x152>
  80047e:	1e088e63          	beqz	a7,80067a <vprintfmt+0x34a>
  800482:	000b3683          	ld	a3,0(s6)
  800486:	4721                	li	a4,8
  800488:	8b32                	mv	s6,a2
  80048a:	a00d                	j	8004ac <vprintfmt+0x17c>
  80048c:	03000513          	li	a0,48
  800490:	864a                	mv	a2,s2
  800492:	85a6                	mv	a1,s1
  800494:	e042                	sd	a6,0(sp)
  800496:	9982                	jalr	s3
  800498:	864a                	mv	a2,s2
  80049a:	85a6                	mv	a1,s1
  80049c:	07800513          	li	a0,120
  8004a0:	9982                	jalr	s3
  8004a2:	0b21                	addi	s6,s6,8
  8004a4:	ff8b3683          	ld	a3,-8(s6)
  8004a8:	6802                	ld	a6,0(sp)
  8004aa:	4741                	li	a4,16
  8004ac:	87e6                	mv	a5,s9
  8004ae:	8626                	mv	a2,s1
  8004b0:	85ca                	mv	a1,s2
  8004b2:	854e                	mv	a0,s3
  8004b4:	e07ff0ef          	jal	ra,8002ba <printnum>
  8004b8:	b575                	j	800364 <vprintfmt+0x34>
  8004ba:	000b3703          	ld	a4,0(s6)
  8004be:	0b21                	addi	s6,s6,8
  8004c0:	1e070063          	beqz	a4,8006a0 <vprintfmt+0x370>
  8004c4:	00170413          	addi	s0,a4,1
  8004c8:	19905563          	blez	s9,800652 <vprintfmt+0x322>
  8004cc:	02d00613          	li	a2,45
  8004d0:	14c81963          	bne	a6,a2,800622 <vprintfmt+0x2f2>
  8004d4:	00074703          	lbu	a4,0(a4)
  8004d8:	0007051b          	sext.w	a0,a4
  8004dc:	c90d                	beqz	a0,80050e <vprintfmt+0x1de>
  8004de:	000d4563          	bltz	s10,8004e8 <vprintfmt+0x1b8>
  8004e2:	3d7d                	addiw	s10,s10,-1
  8004e4:	037d0363          	beq	s10,s7,80050a <vprintfmt+0x1da>
  8004e8:	864a                	mv	a2,s2
  8004ea:	85a6                	mv	a1,s1
  8004ec:	180a0c63          	beqz	s4,800684 <vprintfmt+0x354>
  8004f0:	3701                	addiw	a4,a4,-32
  8004f2:	18ec7963          	bleu	a4,s8,800684 <vprintfmt+0x354>
  8004f6:	03f00513          	li	a0,63
  8004fa:	9982                	jalr	s3
  8004fc:	0405                	addi	s0,s0,1
  8004fe:	fff44703          	lbu	a4,-1(s0)
  800502:	3cfd                	addiw	s9,s9,-1
  800504:	0007051b          	sext.w	a0,a4
  800508:	f979                	bnez	a0,8004de <vprintfmt+0x1ae>
  80050a:	e5905de3          	blez	s9,800364 <vprintfmt+0x34>
  80050e:	3cfd                	addiw	s9,s9,-1
  800510:	864a                	mv	a2,s2
  800512:	85a6                	mv	a1,s1
  800514:	02000513          	li	a0,32
  800518:	9982                	jalr	s3
  80051a:	e40c85e3          	beqz	s9,800364 <vprintfmt+0x34>
  80051e:	3cfd                	addiw	s9,s9,-1
  800520:	864a                	mv	a2,s2
  800522:	85a6                	mv	a1,s1
  800524:	02000513          	li	a0,32
  800528:	9982                	jalr	s3
  80052a:	fe0c92e3          	bnez	s9,80050e <vprintfmt+0x1de>
  80052e:	bd1d                	j	800364 <vprintfmt+0x34>
  800530:	4705                	li	a4,1
  800532:	008b0613          	addi	a2,s6,8
  800536:	01174463          	blt	a4,a7,80053e <vprintfmt+0x20e>
  80053a:	12088663          	beqz	a7,800666 <vprintfmt+0x336>
  80053e:	000b3683          	ld	a3,0(s6)
  800542:	4729                	li	a4,10
  800544:	8b32                	mv	s6,a2
  800546:	b79d                	j	8004ac <vprintfmt+0x17c>
  800548:	00144603          	lbu	a2,1(s0)
  80054c:	02d00813          	li	a6,45
  800550:	846e                	mv	s0,s11
  800552:	bd89                	j	8003a4 <vprintfmt+0x74>
  800554:	864a                	mv	a2,s2
  800556:	85a6                	mv	a1,s1
  800558:	02500513          	li	a0,37
  80055c:	9982                	jalr	s3
  80055e:	b519                	j	800364 <vprintfmt+0x34>
  800560:	000b2d03          	lw	s10,0(s6)
  800564:	00144603          	lbu	a2,1(s0)
  800568:	0b21                	addi	s6,s6,8
  80056a:	846e                	mv	s0,s11
  80056c:	e20cdce3          	bgez	s9,8003a4 <vprintfmt+0x74>
  800570:	8cea                	mv	s9,s10
  800572:	5d7d                	li	s10,-1
  800574:	bd05                	j	8003a4 <vprintfmt+0x74>
  800576:	00144603          	lbu	a2,1(s0)
  80057a:	03000813          	li	a6,48
  80057e:	846e                	mv	s0,s11
  800580:	b515                	j	8003a4 <vprintfmt+0x74>
  800582:	fd060d1b          	addiw	s10,a2,-48
  800586:	00144603          	lbu	a2,1(s0)
  80058a:	846e                	mv	s0,s11
  80058c:	fd06071b          	addiw	a4,a2,-48
  800590:	0006031b          	sext.w	t1,a2
  800594:	fce56ce3          	bltu	a0,a4,80056c <vprintfmt+0x23c>
  800598:	0405                	addi	s0,s0,1
  80059a:	002d171b          	slliw	a4,s10,0x2
  80059e:	00044603          	lbu	a2,0(s0)
  8005a2:	01a706bb          	addw	a3,a4,s10
  8005a6:	0016969b          	slliw	a3,a3,0x1
  8005aa:	006686bb          	addw	a3,a3,t1
  8005ae:	fd06071b          	addiw	a4,a2,-48
  8005b2:	fd068d1b          	addiw	s10,a3,-48
  8005b6:	0006031b          	sext.w	t1,a2
  8005ba:	fce57fe3          	bleu	a4,a0,800598 <vprintfmt+0x268>
  8005be:	b77d                	j	80056c <vprintfmt+0x23c>
  8005c0:	fffcc713          	not	a4,s9
  8005c4:	977d                	srai	a4,a4,0x3f
  8005c6:	00ecf7b3          	and	a5,s9,a4
  8005ca:	00144603          	lbu	a2,1(s0)
  8005ce:	00078c9b          	sext.w	s9,a5
  8005d2:	846e                	mv	s0,s11
  8005d4:	bbc1                	j	8003a4 <vprintfmt+0x74>
  8005d6:	864a                	mv	a2,s2
  8005d8:	85a6                	mv	a1,s1
  8005da:	02500513          	li	a0,37
  8005de:	9982                	jalr	s3
  8005e0:	fff44703          	lbu	a4,-1(s0)
  8005e4:	02500793          	li	a5,37
  8005e8:	8da2                	mv	s11,s0
  8005ea:	d6f70de3          	beq	a4,a5,800364 <vprintfmt+0x34>
  8005ee:	02500713          	li	a4,37
  8005f2:	1dfd                	addi	s11,s11,-1
  8005f4:	fffdc783          	lbu	a5,-1(s11)
  8005f8:	fee79de3          	bne	a5,a4,8005f2 <vprintfmt+0x2c2>
  8005fc:	b3a5                	j	800364 <vprintfmt+0x34>
  8005fe:	00000697          	auipc	a3,0x0
  800602:	6d268693          	addi	a3,a3,1746 # 800cd0 <error_string+0x2c0>
  800606:	8626                	mv	a2,s1
  800608:	85ca                	mv	a1,s2
  80060a:	854e                	mv	a0,s3
  80060c:	0b2000ef          	jal	ra,8006be <printfmt>
  800610:	bb91                	j	800364 <vprintfmt+0x34>
  800612:	00000717          	auipc	a4,0x0
  800616:	6b670713          	addi	a4,a4,1718 # 800cc8 <error_string+0x2b8>
  80061a:	00000417          	auipc	s0,0x0
  80061e:	6af40413          	addi	s0,s0,1711 # 800cc9 <error_string+0x2b9>
  800622:	853a                	mv	a0,a4
  800624:	85ea                	mv	a1,s10
  800626:	e03a                	sd	a4,0(sp)
  800628:	e442                	sd	a6,8(sp)
  80062a:	c6bff0ef          	jal	ra,800294 <strnlen>
  80062e:	40ac8cbb          	subw	s9,s9,a0
  800632:	6702                	ld	a4,0(sp)
  800634:	01905f63          	blez	s9,800652 <vprintfmt+0x322>
  800638:	6822                	ld	a6,8(sp)
  80063a:	0008079b          	sext.w	a5,a6
  80063e:	e43e                	sd	a5,8(sp)
  800640:	6522                	ld	a0,8(sp)
  800642:	864a                	mv	a2,s2
  800644:	85a6                	mv	a1,s1
  800646:	e03a                	sd	a4,0(sp)
  800648:	3cfd                	addiw	s9,s9,-1
  80064a:	9982                	jalr	s3
  80064c:	6702                	ld	a4,0(sp)
  80064e:	fe0c99e3          	bnez	s9,800640 <vprintfmt+0x310>
  800652:	00074703          	lbu	a4,0(a4)
  800656:	0007051b          	sext.w	a0,a4
  80065a:	e80512e3          	bnez	a0,8004de <vprintfmt+0x1ae>
  80065e:	b319                	j	800364 <vprintfmt+0x34>
  800660:	000b2403          	lw	s0,0(s6)
  800664:	bb6d                	j	80041e <vprintfmt+0xee>
  800666:	000b6683          	lwu	a3,0(s6)
  80066a:	4729                	li	a4,10
  80066c:	8b32                	mv	s6,a2
  80066e:	bd3d                	j	8004ac <vprintfmt+0x17c>
  800670:	000b6683          	lwu	a3,0(s6)
  800674:	4741                	li	a4,16
  800676:	8b32                	mv	s6,a2
  800678:	bd15                	j	8004ac <vprintfmt+0x17c>
  80067a:	000b6683          	lwu	a3,0(s6)
  80067e:	4721                	li	a4,8
  800680:	8b32                	mv	s6,a2
  800682:	b52d                	j	8004ac <vprintfmt+0x17c>
  800684:	9982                	jalr	s3
  800686:	bd9d                	j	8004fc <vprintfmt+0x1cc>
  800688:	864a                	mv	a2,s2
  80068a:	85a6                	mv	a1,s1
  80068c:	02d00513          	li	a0,45
  800690:	e042                	sd	a6,0(sp)
  800692:	9982                	jalr	s3
  800694:	8b52                	mv	s6,s4
  800696:	408006b3          	neg	a3,s0
  80069a:	4729                	li	a4,10
  80069c:	6802                	ld	a6,0(sp)
  80069e:	b539                	j	8004ac <vprintfmt+0x17c>
  8006a0:	01905663          	blez	s9,8006ac <vprintfmt+0x37c>
  8006a4:	02d00713          	li	a4,45
  8006a8:	f6e815e3          	bne	a6,a4,800612 <vprintfmt+0x2e2>
  8006ac:	00000417          	auipc	s0,0x0
  8006b0:	61d40413          	addi	s0,s0,1565 # 800cc9 <error_string+0x2b9>
  8006b4:	02800513          	li	a0,40
  8006b8:	02800713          	li	a4,40
  8006bc:	b50d                	j	8004de <vprintfmt+0x1ae>

00000000008006be <printfmt>:
  8006be:	7139                	addi	sp,sp,-64
  8006c0:	02010313          	addi	t1,sp,32
  8006c4:	f03a                	sd	a4,32(sp)
  8006c6:	871a                	mv	a4,t1
  8006c8:	ec06                	sd	ra,24(sp)
  8006ca:	f43e                	sd	a5,40(sp)
  8006cc:	f842                	sd	a6,48(sp)
  8006ce:	fc46                	sd	a7,56(sp)
  8006d0:	e41a                	sd	t1,8(sp)
  8006d2:	c5fff0ef          	jal	ra,800330 <vprintfmt>
  8006d6:	60e2                	ld	ra,24(sp)
  8006d8:	6121                	addi	sp,sp,64
  8006da:	8082                	ret

00000000008006dc <main>:
  8006dc:	1101                	addi	sp,sp,-32
  8006de:	00000517          	auipc	a0,0x0
  8006e2:	60a50513          	addi	a0,a0,1546 # 800ce8 <error_string+0x2d8>
  8006e6:	ec06                	sd	ra,24(sp)
  8006e8:	e822                	sd	s0,16(sp)
  8006ea:	a8fff0ef          	jal	ra,800178 <cprintf>
  8006ee:	b93ff0ef          	jal	ra,800280 <fork>
  8006f2:	c569                	beqz	a0,8007bc <main+0xe0>
  8006f4:	842a                	mv	s0,a0
  8006f6:	85aa                	mv	a1,a0
  8006f8:	00000517          	auipc	a0,0x0
  8006fc:	63050513          	addi	a0,a0,1584 # 800d28 <error_string+0x318>
  800700:	a79ff0ef          	jal	ra,800178 <cprintf>
  800704:	08805d63          	blez	s0,80079e <main+0xc2>
  800708:	00000517          	auipc	a0,0x0
  80070c:	67850513          	addi	a0,a0,1656 # 800d80 <error_string+0x370>
  800710:	a69ff0ef          	jal	ra,800178 <cprintf>
  800714:	006c                	addi	a1,sp,12
  800716:	8522                	mv	a0,s0
  800718:	b75ff0ef          	jal	ra,80028c <waitpid>
  80071c:	e139                	bnez	a0,800762 <main+0x86>
  80071e:	00001797          	auipc	a5,0x1
  800722:	8e278793          	addi	a5,a5,-1822 # 801000 <magic>
  800726:	4732                	lw	a4,12(sp)
  800728:	439c                	lw	a5,0(a5)
  80072a:	02f71c63          	bne	a4,a5,800762 <main+0x86>
  80072e:	006c                	addi	a1,sp,12
  800730:	8522                	mv	a0,s0
  800732:	b5bff0ef          	jal	ra,80028c <waitpid>
  800736:	c529                	beqz	a0,800780 <main+0xa4>
  800738:	b4dff0ef          	jal	ra,800284 <wait>
  80073c:	c131                	beqz	a0,800780 <main+0xa4>
  80073e:	85a2                	mv	a1,s0
  800740:	00000517          	auipc	a0,0x0
  800744:	6b850513          	addi	a0,a0,1720 # 800df8 <error_string+0x3e8>
  800748:	a31ff0ef          	jal	ra,800178 <cprintf>
  80074c:	00000517          	auipc	a0,0x0
  800750:	6bc50513          	addi	a0,a0,1724 # 800e08 <error_string+0x3f8>
  800754:	a25ff0ef          	jal	ra,800178 <cprintf>
  800758:	60e2                	ld	ra,24(sp)
  80075a:	6442                	ld	s0,16(sp)
  80075c:	4501                	li	a0,0
  80075e:	6105                	addi	sp,sp,32
  800760:	8082                	ret
  800762:	00000697          	auipc	a3,0x0
  800766:	63e68693          	addi	a3,a3,1598 # 800da0 <error_string+0x390>
  80076a:	00000617          	auipc	a2,0x0
  80076e:	5ee60613          	addi	a2,a2,1518 # 800d58 <error_string+0x348>
  800772:	45ed                	li	a1,27
  800774:	00000517          	auipc	a0,0x0
  800778:	5fc50513          	addi	a0,a0,1532 # 800d70 <error_string+0x360>
  80077c:	8a5ff0ef          	jal	ra,800020 <__panic>
  800780:	00000697          	auipc	a3,0x0
  800784:	65068693          	addi	a3,a3,1616 # 800dd0 <error_string+0x3c0>
  800788:	00000617          	auipc	a2,0x0
  80078c:	5d060613          	addi	a2,a2,1488 # 800d58 <error_string+0x348>
  800790:	45f1                	li	a1,28
  800792:	00000517          	auipc	a0,0x0
  800796:	5de50513          	addi	a0,a0,1502 # 800d70 <error_string+0x360>
  80079a:	887ff0ef          	jal	ra,800020 <__panic>
  80079e:	00000697          	auipc	a3,0x0
  8007a2:	5b268693          	addi	a3,a3,1458 # 800d50 <error_string+0x340>
  8007a6:	00000617          	auipc	a2,0x0
  8007aa:	5b260613          	addi	a2,a2,1458 # 800d58 <error_string+0x348>
  8007ae:	45e1                	li	a1,24
  8007b0:	00000517          	auipc	a0,0x0
  8007b4:	5c050513          	addi	a0,a0,1472 # 800d70 <error_string+0x360>
  8007b8:	869ff0ef          	jal	ra,800020 <__panic>
  8007bc:	00000517          	auipc	a0,0x0
  8007c0:	55450513          	addi	a0,a0,1364 # 800d10 <error_string+0x300>
  8007c4:	9b5ff0ef          	jal	ra,800178 <cprintf>
  8007c8:	ac9ff0ef          	jal	ra,800290 <yield>
  8007cc:	ac5ff0ef          	jal	ra,800290 <yield>
  8007d0:	ac1ff0ef          	jal	ra,800290 <yield>
  8007d4:	abdff0ef          	jal	ra,800290 <yield>
  8007d8:	ab9ff0ef          	jal	ra,800290 <yield>
  8007dc:	ab5ff0ef          	jal	ra,800290 <yield>
  8007e0:	ab1ff0ef          	jal	ra,800290 <yield>
  8007e4:	00001797          	auipc	a5,0x1
  8007e8:	81c78793          	addi	a5,a5,-2020 # 801000 <magic>
  8007ec:	4388                	lw	a0,0(a5)
  8007ee:	a7dff0ef          	jal	ra,80026a <exit>
