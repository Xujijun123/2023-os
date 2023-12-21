
obj/__user_priority.out：     文件格式 elf64-littleriscv


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
  800032:	89a50513          	addi	a0,a0,-1894 # 8008c8 <main+0x1ba>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	14e000ef          	jal	ra,800190 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	120000ef          	jal	ra,80016a <vcprintf>
  80004e:	00001517          	auipc	a0,0x1
  800052:	8da50513          	addi	a0,a0,-1830 # 800928 <main+0x21a>
  800056:	13a000ef          	jal	ra,800190 <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	226000ef          	jal	ra,800282 <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00001517          	auipc	a0,0x1
  800072:	87a50513          	addi	a0,a0,-1926 # 8008e8 <main+0x1da>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	10e000ef          	jal	ra,800190 <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	0e0000ef          	jal	ra,80016a <vcprintf>
  80008e:	00001517          	auipc	a0,0x1
  800092:	89a50513          	addi	a0,a0,-1894 # 800928 <main+0x21a>
  800096:	0fa000ef          	jal	ra,800190 <cprintf>
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

00000000008000f2 <sys_kill>:
  8000f2:	85aa                	mv	a1,a0
  8000f4:	4531                	li	a0,12
  8000f6:	fadff06f          	j	8000a2 <syscall>

00000000008000fa <sys_getpid>:
  8000fa:	4549                	li	a0,18
  8000fc:	fa7ff06f          	j	8000a2 <syscall>

0000000000800100 <sys_putc>:
  800100:	85aa                	mv	a1,a0
  800102:	4579                	li	a0,30
  800104:	f9fff06f          	j	8000a2 <syscall>

0000000000800108 <sys_lab6_set_priority>:
  800108:	85aa                	mv	a1,a0
  80010a:	0ff00513          	li	a0,255
  80010e:	f95ff06f          	j	8000a2 <syscall>

0000000000800112 <sys_gettime>:
  800112:	4545                	li	a0,17
  800114:	f8fff06f          	j	8000a2 <syscall>

0000000000800118 <sys_open>:
  800118:	862e                	mv	a2,a1
  80011a:	85aa                	mv	a1,a0
  80011c:	06400513          	li	a0,100
  800120:	f83ff06f          	j	8000a2 <syscall>

0000000000800124 <sys_close>:
  800124:	85aa                	mv	a1,a0
  800126:	06500513          	li	a0,101
  80012a:	f79ff06f          	j	8000a2 <syscall>

000000000080012e <sys_dup>:
  80012e:	862e                	mv	a2,a1
  800130:	85aa                	mv	a1,a0
  800132:	08200513          	li	a0,130
  800136:	f6dff06f          	j	8000a2 <syscall>

000000000080013a <_start>:
  80013a:	0d4000ef          	jal	ra,80020e <umain>
  80013e:	a001                	j	80013e <_start+0x4>

0000000000800140 <open>:
  800140:	1582                	slli	a1,a1,0x20
  800142:	9181                	srli	a1,a1,0x20
  800144:	fd5ff06f          	j	800118 <sys_open>

0000000000800148 <close>:
  800148:	fddff06f          	j	800124 <sys_close>

000000000080014c <dup2>:
  80014c:	fe3ff06f          	j	80012e <sys_dup>

0000000000800150 <cputch>:
  800150:	1141                	addi	sp,sp,-16
  800152:	e022                	sd	s0,0(sp)
  800154:	e406                	sd	ra,8(sp)
  800156:	842e                	mv	s0,a1
  800158:	fa9ff0ef          	jal	ra,800100 <sys_putc>
  80015c:	401c                	lw	a5,0(s0)
  80015e:	60a2                	ld	ra,8(sp)
  800160:	2785                	addiw	a5,a5,1
  800162:	c01c                	sw	a5,0(s0)
  800164:	6402                	ld	s0,0(sp)
  800166:	0141                	addi	sp,sp,16
  800168:	8082                	ret

000000000080016a <vcprintf>:
  80016a:	1101                	addi	sp,sp,-32
  80016c:	872e                	mv	a4,a1
  80016e:	75dd                	lui	a1,0xffff7
  800170:	86aa                	mv	a3,a0
  800172:	0070                	addi	a2,sp,12
  800174:	00000517          	auipc	a0,0x0
  800178:	fdc50513          	addi	a0,a0,-36 # 800150 <cputch>
  80017c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <pids+0xffffffffff7f5aa9>
  800180:	ec06                	sd	ra,24(sp)
  800182:	c602                	sw	zero,12(sp)
  800184:	1de000ef          	jal	ra,800362 <vprintfmt>
  800188:	60e2                	ld	ra,24(sp)
  80018a:	4532                	lw	a0,12(sp)
  80018c:	6105                	addi	sp,sp,32
  80018e:	8082                	ret

0000000000800190 <cprintf>:
  800190:	711d                	addi	sp,sp,-96
  800192:	02810313          	addi	t1,sp,40
  800196:	f42e                	sd	a1,40(sp)
  800198:	75dd                	lui	a1,0xffff7
  80019a:	f832                	sd	a2,48(sp)
  80019c:	fc36                	sd	a3,56(sp)
  80019e:	e0ba                	sd	a4,64(sp)
  8001a0:	86aa                	mv	a3,a0
  8001a2:	0050                	addi	a2,sp,4
  8001a4:	00000517          	auipc	a0,0x0
  8001a8:	fac50513          	addi	a0,a0,-84 # 800150 <cputch>
  8001ac:	871a                	mv	a4,t1
  8001ae:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <pids+0xffffffffff7f5aa9>
  8001b2:	ec06                	sd	ra,24(sp)
  8001b4:	e4be                	sd	a5,72(sp)
  8001b6:	e8c2                	sd	a6,80(sp)
  8001b8:	ecc6                	sd	a7,88(sp)
  8001ba:	e41a                	sd	t1,8(sp)
  8001bc:	c202                	sw	zero,4(sp)
  8001be:	1a4000ef          	jal	ra,800362 <vprintfmt>
  8001c2:	60e2                	ld	ra,24(sp)
  8001c4:	4512                	lw	a0,4(sp)
  8001c6:	6125                	addi	sp,sp,96
  8001c8:	8082                	ret

00000000008001ca <initfd>:
  8001ca:	1101                	addi	sp,sp,-32
  8001cc:	87ae                	mv	a5,a1
  8001ce:	e426                	sd	s1,8(sp)
  8001d0:	85b2                	mv	a1,a2
  8001d2:	84aa                	mv	s1,a0
  8001d4:	853e                	mv	a0,a5
  8001d6:	e822                	sd	s0,16(sp)
  8001d8:	ec06                	sd	ra,24(sp)
  8001da:	f67ff0ef          	jal	ra,800140 <open>
  8001de:	842a                	mv	s0,a0
  8001e0:	00054463          	bltz	a0,8001e8 <initfd+0x1e>
  8001e4:	00951863          	bne	a0,s1,8001f4 <initfd+0x2a>
  8001e8:	8522                	mv	a0,s0
  8001ea:	60e2                	ld	ra,24(sp)
  8001ec:	6442                	ld	s0,16(sp)
  8001ee:	64a2                	ld	s1,8(sp)
  8001f0:	6105                	addi	sp,sp,32
  8001f2:	8082                	ret
  8001f4:	8526                	mv	a0,s1
  8001f6:	f53ff0ef          	jal	ra,800148 <close>
  8001fa:	85a6                	mv	a1,s1
  8001fc:	8522                	mv	a0,s0
  8001fe:	f4fff0ef          	jal	ra,80014c <dup2>
  800202:	84aa                	mv	s1,a0
  800204:	8522                	mv	a0,s0
  800206:	f43ff0ef          	jal	ra,800148 <close>
  80020a:	8426                	mv	s0,s1
  80020c:	bff1                	j	8001e8 <initfd+0x1e>

000000000080020e <umain>:
  80020e:	1101                	addi	sp,sp,-32
  800210:	e822                	sd	s0,16(sp)
  800212:	e426                	sd	s1,8(sp)
  800214:	842a                	mv	s0,a0
  800216:	84ae                	mv	s1,a1
  800218:	4601                	li	a2,0
  80021a:	00000597          	auipc	a1,0x0
  80021e:	6ee58593          	addi	a1,a1,1774 # 800908 <main+0x1fa>
  800222:	4501                	li	a0,0
  800224:	ec06                	sd	ra,24(sp)
  800226:	fa5ff0ef          	jal	ra,8001ca <initfd>
  80022a:	02054263          	bltz	a0,80024e <umain+0x40>
  80022e:	4605                	li	a2,1
  800230:	00000597          	auipc	a1,0x0
  800234:	71858593          	addi	a1,a1,1816 # 800948 <main+0x23a>
  800238:	4505                	li	a0,1
  80023a:	f91ff0ef          	jal	ra,8001ca <initfd>
  80023e:	02054563          	bltz	a0,800268 <umain+0x5a>
  800242:	85a6                	mv	a1,s1
  800244:	8522                	mv	a0,s0
  800246:	4c8000ef          	jal	ra,80070e <main>
  80024a:	038000ef          	jal	ra,800282 <exit>
  80024e:	86aa                	mv	a3,a0
  800250:	00000617          	auipc	a2,0x0
  800254:	6c060613          	addi	a2,a2,1728 # 800910 <main+0x202>
  800258:	45e9                	li	a1,26
  80025a:	00000517          	auipc	a0,0x0
  80025e:	6d650513          	addi	a0,a0,1750 # 800930 <main+0x222>
  800262:	dffff0ef          	jal	ra,800060 <__warn>
  800266:	b7e1                	j	80022e <umain+0x20>
  800268:	86aa                	mv	a3,a0
  80026a:	00000617          	auipc	a2,0x0
  80026e:	6e660613          	addi	a2,a2,1766 # 800950 <main+0x242>
  800272:	45f5                	li	a1,29
  800274:	00000517          	auipc	a0,0x0
  800278:	6bc50513          	addi	a0,a0,1724 # 800930 <main+0x222>
  80027c:	de5ff0ef          	jal	ra,800060 <__warn>
  800280:	b7c9                	j	800242 <umain+0x34>

0000000000800282 <exit>:
  800282:	1141                	addi	sp,sp,-16
  800284:	e406                	sd	ra,8(sp)
  800286:	e55ff0ef          	jal	ra,8000da <sys_exit>
  80028a:	00000517          	auipc	a0,0x0
  80028e:	6e650513          	addi	a0,a0,1766 # 800970 <main+0x262>
  800292:	effff0ef          	jal	ra,800190 <cprintf>
  800296:	a001                	j	800296 <exit+0x14>

0000000000800298 <fork>:
  800298:	e4bff06f          	j	8000e2 <sys_fork>

000000000080029c <waitpid>:
  80029c:	e4dff06f          	j	8000e8 <sys_wait>

00000000008002a0 <kill>:
  8002a0:	e53ff06f          	j	8000f2 <sys_kill>

00000000008002a4 <getpid>:
  8002a4:	e57ff06f          	j	8000fa <sys_getpid>

00000000008002a8 <gettime_msec>:
  8002a8:	e6bff06f          	j	800112 <sys_gettime>

00000000008002ac <lab6_set_priority>:
  8002ac:	1502                	slli	a0,a0,0x20
  8002ae:	9101                	srli	a0,a0,0x20
  8002b0:	e59ff06f          	j	800108 <sys_lab6_set_priority>

00000000008002b4 <strnlen>:
  8002b4:	c185                	beqz	a1,8002d4 <strnlen+0x20>
  8002b6:	00054783          	lbu	a5,0(a0)
  8002ba:	cf89                	beqz	a5,8002d4 <strnlen+0x20>
  8002bc:	4781                	li	a5,0
  8002be:	a021                	j	8002c6 <strnlen+0x12>
  8002c0:	00074703          	lbu	a4,0(a4)
  8002c4:	c711                	beqz	a4,8002d0 <strnlen+0x1c>
  8002c6:	0785                	addi	a5,a5,1
  8002c8:	00f50733          	add	a4,a0,a5
  8002cc:	fef59ae3          	bne	a1,a5,8002c0 <strnlen+0xc>
  8002d0:	853e                	mv	a0,a5
  8002d2:	8082                	ret
  8002d4:	4781                	li	a5,0
  8002d6:	853e                	mv	a0,a5
  8002d8:	8082                	ret

00000000008002da <memset>:
  8002da:	ca01                	beqz	a2,8002ea <memset+0x10>
  8002dc:	962a                	add	a2,a2,a0
  8002de:	87aa                	mv	a5,a0
  8002e0:	0785                	addi	a5,a5,1
  8002e2:	feb78fa3          	sb	a1,-1(a5)
  8002e6:	fec79de3          	bne	a5,a2,8002e0 <memset+0x6>
  8002ea:	8082                	ret

00000000008002ec <printnum>:
  8002ec:	02071893          	slli	a7,a4,0x20
  8002f0:	7139                	addi	sp,sp,-64
  8002f2:	0208d893          	srli	a7,a7,0x20
  8002f6:	e456                	sd	s5,8(sp)
  8002f8:	0316fab3          	remu	s5,a3,a7
  8002fc:	f822                	sd	s0,48(sp)
  8002fe:	f426                	sd	s1,40(sp)
  800300:	f04a                	sd	s2,32(sp)
  800302:	ec4e                	sd	s3,24(sp)
  800304:	fc06                	sd	ra,56(sp)
  800306:	e852                	sd	s4,16(sp)
  800308:	84aa                	mv	s1,a0
  80030a:	89ae                	mv	s3,a1
  80030c:	8932                	mv	s2,a2
  80030e:	fff7841b          	addiw	s0,a5,-1
  800312:	2a81                	sext.w	s5,s5
  800314:	0516f163          	bleu	a7,a3,800356 <printnum+0x6a>
  800318:	8a42                	mv	s4,a6
  80031a:	00805863          	blez	s0,80032a <printnum+0x3e>
  80031e:	347d                	addiw	s0,s0,-1
  800320:	864e                	mv	a2,s3
  800322:	85ca                	mv	a1,s2
  800324:	8552                	mv	a0,s4
  800326:	9482                	jalr	s1
  800328:	f87d                	bnez	s0,80031e <printnum+0x32>
  80032a:	1a82                	slli	s5,s5,0x20
  80032c:	020ada93          	srli	s5,s5,0x20
  800330:	00001797          	auipc	a5,0x1
  800334:	87878793          	addi	a5,a5,-1928 # 800ba8 <error_string+0xc8>
  800338:	9abe                	add	s5,s5,a5
  80033a:	7442                	ld	s0,48(sp)
  80033c:	000ac503          	lbu	a0,0(s5)
  800340:	70e2                	ld	ra,56(sp)
  800342:	6a42                	ld	s4,16(sp)
  800344:	6aa2                	ld	s5,8(sp)
  800346:	864e                	mv	a2,s3
  800348:	85ca                	mv	a1,s2
  80034a:	69e2                	ld	s3,24(sp)
  80034c:	7902                	ld	s2,32(sp)
  80034e:	8326                	mv	t1,s1
  800350:	74a2                	ld	s1,40(sp)
  800352:	6121                	addi	sp,sp,64
  800354:	8302                	jr	t1
  800356:	0316d6b3          	divu	a3,a3,a7
  80035a:	87a2                	mv	a5,s0
  80035c:	f91ff0ef          	jal	ra,8002ec <printnum>
  800360:	b7e9                	j	80032a <printnum+0x3e>

0000000000800362 <vprintfmt>:
  800362:	7119                	addi	sp,sp,-128
  800364:	f4a6                	sd	s1,104(sp)
  800366:	f0ca                	sd	s2,96(sp)
  800368:	ecce                	sd	s3,88(sp)
  80036a:	e4d6                	sd	s5,72(sp)
  80036c:	e0da                	sd	s6,64(sp)
  80036e:	fc5e                	sd	s7,56(sp)
  800370:	f862                	sd	s8,48(sp)
  800372:	ec6e                	sd	s11,24(sp)
  800374:	fc86                	sd	ra,120(sp)
  800376:	f8a2                	sd	s0,112(sp)
  800378:	e8d2                	sd	s4,80(sp)
  80037a:	f466                	sd	s9,40(sp)
  80037c:	f06a                	sd	s10,32(sp)
  80037e:	89aa                	mv	s3,a0
  800380:	892e                	mv	s2,a1
  800382:	84b2                	mv	s1,a2
  800384:	8db6                	mv	s11,a3
  800386:	8b3a                	mv	s6,a4
  800388:	5bfd                	li	s7,-1
  80038a:	00000a97          	auipc	s5,0x0
  80038e:	5faa8a93          	addi	s5,s5,1530 # 800984 <main+0x276>
  800392:	05e00c13          	li	s8,94
  800396:	000dc503          	lbu	a0,0(s11)
  80039a:	02500793          	li	a5,37
  80039e:	001d8413          	addi	s0,s11,1
  8003a2:	00f50f63          	beq	a0,a5,8003c0 <vprintfmt+0x5e>
  8003a6:	c529                	beqz	a0,8003f0 <vprintfmt+0x8e>
  8003a8:	02500a13          	li	s4,37
  8003ac:	a011                	j	8003b0 <vprintfmt+0x4e>
  8003ae:	c129                	beqz	a0,8003f0 <vprintfmt+0x8e>
  8003b0:	864a                	mv	a2,s2
  8003b2:	85a6                	mv	a1,s1
  8003b4:	0405                	addi	s0,s0,1
  8003b6:	9982                	jalr	s3
  8003b8:	fff44503          	lbu	a0,-1(s0)
  8003bc:	ff4519e3          	bne	a0,s4,8003ae <vprintfmt+0x4c>
  8003c0:	00044603          	lbu	a2,0(s0)
  8003c4:	02000813          	li	a6,32
  8003c8:	4a01                	li	s4,0
  8003ca:	4881                	li	a7,0
  8003cc:	5d7d                	li	s10,-1
  8003ce:	5cfd                	li	s9,-1
  8003d0:	05500593          	li	a1,85
  8003d4:	4525                	li	a0,9
  8003d6:	fdd6071b          	addiw	a4,a2,-35
  8003da:	0ff77713          	andi	a4,a4,255
  8003de:	00140d93          	addi	s11,s0,1
  8003e2:	22e5e363          	bltu	a1,a4,800608 <vprintfmt+0x2a6>
  8003e6:	070a                	slli	a4,a4,0x2
  8003e8:	9756                	add	a4,a4,s5
  8003ea:	4318                	lw	a4,0(a4)
  8003ec:	9756                	add	a4,a4,s5
  8003ee:	8702                	jr	a4
  8003f0:	70e6                	ld	ra,120(sp)
  8003f2:	7446                	ld	s0,112(sp)
  8003f4:	74a6                	ld	s1,104(sp)
  8003f6:	7906                	ld	s2,96(sp)
  8003f8:	69e6                	ld	s3,88(sp)
  8003fa:	6a46                	ld	s4,80(sp)
  8003fc:	6aa6                	ld	s5,72(sp)
  8003fe:	6b06                	ld	s6,64(sp)
  800400:	7be2                	ld	s7,56(sp)
  800402:	7c42                	ld	s8,48(sp)
  800404:	7ca2                	ld	s9,40(sp)
  800406:	7d02                	ld	s10,32(sp)
  800408:	6de2                	ld	s11,24(sp)
  80040a:	6109                	addi	sp,sp,128
  80040c:	8082                	ret
  80040e:	4705                	li	a4,1
  800410:	008b0613          	addi	a2,s6,8
  800414:	01174463          	blt	a4,a7,80041c <vprintfmt+0xba>
  800418:	28088563          	beqz	a7,8006a2 <vprintfmt+0x340>
  80041c:	000b3683          	ld	a3,0(s6)
  800420:	4741                	li	a4,16
  800422:	8b32                	mv	s6,a2
  800424:	a86d                	j	8004de <vprintfmt+0x17c>
  800426:	00144603          	lbu	a2,1(s0)
  80042a:	4a05                	li	s4,1
  80042c:	846e                	mv	s0,s11
  80042e:	b765                	j	8003d6 <vprintfmt+0x74>
  800430:	000b2503          	lw	a0,0(s6)
  800434:	864a                	mv	a2,s2
  800436:	85a6                	mv	a1,s1
  800438:	0b21                	addi	s6,s6,8
  80043a:	9982                	jalr	s3
  80043c:	bfa9                	j	800396 <vprintfmt+0x34>
  80043e:	4705                	li	a4,1
  800440:	008b0a13          	addi	s4,s6,8
  800444:	01174463          	blt	a4,a7,80044c <vprintfmt+0xea>
  800448:	24088563          	beqz	a7,800692 <vprintfmt+0x330>
  80044c:	000b3403          	ld	s0,0(s6)
  800450:	26044563          	bltz	s0,8006ba <vprintfmt+0x358>
  800454:	86a2                	mv	a3,s0
  800456:	8b52                	mv	s6,s4
  800458:	4729                	li	a4,10
  80045a:	a051                	j	8004de <vprintfmt+0x17c>
  80045c:	000b2783          	lw	a5,0(s6)
  800460:	46e1                	li	a3,24
  800462:	0b21                	addi	s6,s6,8
  800464:	41f7d71b          	sraiw	a4,a5,0x1f
  800468:	8fb9                	xor	a5,a5,a4
  80046a:	40e7873b          	subw	a4,a5,a4
  80046e:	1ce6c163          	blt	a3,a4,800630 <vprintfmt+0x2ce>
  800472:	00371793          	slli	a5,a4,0x3
  800476:	00000697          	auipc	a3,0x0
  80047a:	66a68693          	addi	a3,a3,1642 # 800ae0 <error_string>
  80047e:	97b6                	add	a5,a5,a3
  800480:	639c                	ld	a5,0(a5)
  800482:	1a078763          	beqz	a5,800630 <vprintfmt+0x2ce>
  800486:	873e                	mv	a4,a5
  800488:	00001697          	auipc	a3,0x1
  80048c:	92868693          	addi	a3,a3,-1752 # 800db0 <error_string+0x2d0>
  800490:	8626                	mv	a2,s1
  800492:	85ca                	mv	a1,s2
  800494:	854e                	mv	a0,s3
  800496:	25a000ef          	jal	ra,8006f0 <printfmt>
  80049a:	bdf5                	j	800396 <vprintfmt+0x34>
  80049c:	00144603          	lbu	a2,1(s0)
  8004a0:	2885                	addiw	a7,a7,1
  8004a2:	846e                	mv	s0,s11
  8004a4:	bf0d                	j	8003d6 <vprintfmt+0x74>
  8004a6:	4705                	li	a4,1
  8004a8:	008b0613          	addi	a2,s6,8
  8004ac:	01174463          	blt	a4,a7,8004b4 <vprintfmt+0x152>
  8004b0:	1e088e63          	beqz	a7,8006ac <vprintfmt+0x34a>
  8004b4:	000b3683          	ld	a3,0(s6)
  8004b8:	4721                	li	a4,8
  8004ba:	8b32                	mv	s6,a2
  8004bc:	a00d                	j	8004de <vprintfmt+0x17c>
  8004be:	03000513          	li	a0,48
  8004c2:	864a                	mv	a2,s2
  8004c4:	85a6                	mv	a1,s1
  8004c6:	e042                	sd	a6,0(sp)
  8004c8:	9982                	jalr	s3
  8004ca:	864a                	mv	a2,s2
  8004cc:	85a6                	mv	a1,s1
  8004ce:	07800513          	li	a0,120
  8004d2:	9982                	jalr	s3
  8004d4:	0b21                	addi	s6,s6,8
  8004d6:	ff8b3683          	ld	a3,-8(s6)
  8004da:	6802                	ld	a6,0(sp)
  8004dc:	4741                	li	a4,16
  8004de:	87e6                	mv	a5,s9
  8004e0:	8626                	mv	a2,s1
  8004e2:	85ca                	mv	a1,s2
  8004e4:	854e                	mv	a0,s3
  8004e6:	e07ff0ef          	jal	ra,8002ec <printnum>
  8004ea:	b575                	j	800396 <vprintfmt+0x34>
  8004ec:	000b3703          	ld	a4,0(s6)
  8004f0:	0b21                	addi	s6,s6,8
  8004f2:	1e070063          	beqz	a4,8006d2 <vprintfmt+0x370>
  8004f6:	00170413          	addi	s0,a4,1
  8004fa:	19905563          	blez	s9,800684 <vprintfmt+0x322>
  8004fe:	02d00613          	li	a2,45
  800502:	14c81963          	bne	a6,a2,800654 <vprintfmt+0x2f2>
  800506:	00074703          	lbu	a4,0(a4)
  80050a:	0007051b          	sext.w	a0,a4
  80050e:	c90d                	beqz	a0,800540 <vprintfmt+0x1de>
  800510:	000d4563          	bltz	s10,80051a <vprintfmt+0x1b8>
  800514:	3d7d                	addiw	s10,s10,-1
  800516:	037d0363          	beq	s10,s7,80053c <vprintfmt+0x1da>
  80051a:	864a                	mv	a2,s2
  80051c:	85a6                	mv	a1,s1
  80051e:	180a0c63          	beqz	s4,8006b6 <vprintfmt+0x354>
  800522:	3701                	addiw	a4,a4,-32
  800524:	18ec7963          	bleu	a4,s8,8006b6 <vprintfmt+0x354>
  800528:	03f00513          	li	a0,63
  80052c:	9982                	jalr	s3
  80052e:	0405                	addi	s0,s0,1
  800530:	fff44703          	lbu	a4,-1(s0)
  800534:	3cfd                	addiw	s9,s9,-1
  800536:	0007051b          	sext.w	a0,a4
  80053a:	f979                	bnez	a0,800510 <vprintfmt+0x1ae>
  80053c:	e5905de3          	blez	s9,800396 <vprintfmt+0x34>
  800540:	3cfd                	addiw	s9,s9,-1
  800542:	864a                	mv	a2,s2
  800544:	85a6                	mv	a1,s1
  800546:	02000513          	li	a0,32
  80054a:	9982                	jalr	s3
  80054c:	e40c85e3          	beqz	s9,800396 <vprintfmt+0x34>
  800550:	3cfd                	addiw	s9,s9,-1
  800552:	864a                	mv	a2,s2
  800554:	85a6                	mv	a1,s1
  800556:	02000513          	li	a0,32
  80055a:	9982                	jalr	s3
  80055c:	fe0c92e3          	bnez	s9,800540 <vprintfmt+0x1de>
  800560:	bd1d                	j	800396 <vprintfmt+0x34>
  800562:	4705                	li	a4,1
  800564:	008b0613          	addi	a2,s6,8
  800568:	01174463          	blt	a4,a7,800570 <vprintfmt+0x20e>
  80056c:	12088663          	beqz	a7,800698 <vprintfmt+0x336>
  800570:	000b3683          	ld	a3,0(s6)
  800574:	4729                	li	a4,10
  800576:	8b32                	mv	s6,a2
  800578:	b79d                	j	8004de <vprintfmt+0x17c>
  80057a:	00144603          	lbu	a2,1(s0)
  80057e:	02d00813          	li	a6,45
  800582:	846e                	mv	s0,s11
  800584:	bd89                	j	8003d6 <vprintfmt+0x74>
  800586:	864a                	mv	a2,s2
  800588:	85a6                	mv	a1,s1
  80058a:	02500513          	li	a0,37
  80058e:	9982                	jalr	s3
  800590:	b519                	j	800396 <vprintfmt+0x34>
  800592:	000b2d03          	lw	s10,0(s6)
  800596:	00144603          	lbu	a2,1(s0)
  80059a:	0b21                	addi	s6,s6,8
  80059c:	846e                	mv	s0,s11
  80059e:	e20cdce3          	bgez	s9,8003d6 <vprintfmt+0x74>
  8005a2:	8cea                	mv	s9,s10
  8005a4:	5d7d                	li	s10,-1
  8005a6:	bd05                	j	8003d6 <vprintfmt+0x74>
  8005a8:	00144603          	lbu	a2,1(s0)
  8005ac:	03000813          	li	a6,48
  8005b0:	846e                	mv	s0,s11
  8005b2:	b515                	j	8003d6 <vprintfmt+0x74>
  8005b4:	fd060d1b          	addiw	s10,a2,-48
  8005b8:	00144603          	lbu	a2,1(s0)
  8005bc:	846e                	mv	s0,s11
  8005be:	fd06071b          	addiw	a4,a2,-48
  8005c2:	0006031b          	sext.w	t1,a2
  8005c6:	fce56ce3          	bltu	a0,a4,80059e <vprintfmt+0x23c>
  8005ca:	0405                	addi	s0,s0,1
  8005cc:	002d171b          	slliw	a4,s10,0x2
  8005d0:	00044603          	lbu	a2,0(s0)
  8005d4:	01a706bb          	addw	a3,a4,s10
  8005d8:	0016969b          	slliw	a3,a3,0x1
  8005dc:	006686bb          	addw	a3,a3,t1
  8005e0:	fd06071b          	addiw	a4,a2,-48
  8005e4:	fd068d1b          	addiw	s10,a3,-48
  8005e8:	0006031b          	sext.w	t1,a2
  8005ec:	fce57fe3          	bleu	a4,a0,8005ca <vprintfmt+0x268>
  8005f0:	b77d                	j	80059e <vprintfmt+0x23c>
  8005f2:	fffcc713          	not	a4,s9
  8005f6:	977d                	srai	a4,a4,0x3f
  8005f8:	00ecf7b3          	and	a5,s9,a4
  8005fc:	00144603          	lbu	a2,1(s0)
  800600:	00078c9b          	sext.w	s9,a5
  800604:	846e                	mv	s0,s11
  800606:	bbc1                	j	8003d6 <vprintfmt+0x74>
  800608:	864a                	mv	a2,s2
  80060a:	85a6                	mv	a1,s1
  80060c:	02500513          	li	a0,37
  800610:	9982                	jalr	s3
  800612:	fff44703          	lbu	a4,-1(s0)
  800616:	02500793          	li	a5,37
  80061a:	8da2                	mv	s11,s0
  80061c:	d6f70de3          	beq	a4,a5,800396 <vprintfmt+0x34>
  800620:	02500713          	li	a4,37
  800624:	1dfd                	addi	s11,s11,-1
  800626:	fffdc783          	lbu	a5,-1(s11)
  80062a:	fee79de3          	bne	a5,a4,800624 <vprintfmt+0x2c2>
  80062e:	b3a5                	j	800396 <vprintfmt+0x34>
  800630:	00000697          	auipc	a3,0x0
  800634:	77068693          	addi	a3,a3,1904 # 800da0 <error_string+0x2c0>
  800638:	8626                	mv	a2,s1
  80063a:	85ca                	mv	a1,s2
  80063c:	854e                	mv	a0,s3
  80063e:	0b2000ef          	jal	ra,8006f0 <printfmt>
  800642:	bb91                	j	800396 <vprintfmt+0x34>
  800644:	00000717          	auipc	a4,0x0
  800648:	75470713          	addi	a4,a4,1876 # 800d98 <error_string+0x2b8>
  80064c:	00000417          	auipc	s0,0x0
  800650:	74d40413          	addi	s0,s0,1869 # 800d99 <error_string+0x2b9>
  800654:	853a                	mv	a0,a4
  800656:	85ea                	mv	a1,s10
  800658:	e03a                	sd	a4,0(sp)
  80065a:	e442                	sd	a6,8(sp)
  80065c:	c59ff0ef          	jal	ra,8002b4 <strnlen>
  800660:	40ac8cbb          	subw	s9,s9,a0
  800664:	6702                	ld	a4,0(sp)
  800666:	01905f63          	blez	s9,800684 <vprintfmt+0x322>
  80066a:	6822                	ld	a6,8(sp)
  80066c:	0008079b          	sext.w	a5,a6
  800670:	e43e                	sd	a5,8(sp)
  800672:	6522                	ld	a0,8(sp)
  800674:	864a                	mv	a2,s2
  800676:	85a6                	mv	a1,s1
  800678:	e03a                	sd	a4,0(sp)
  80067a:	3cfd                	addiw	s9,s9,-1
  80067c:	9982                	jalr	s3
  80067e:	6702                	ld	a4,0(sp)
  800680:	fe0c99e3          	bnez	s9,800672 <vprintfmt+0x310>
  800684:	00074703          	lbu	a4,0(a4)
  800688:	0007051b          	sext.w	a0,a4
  80068c:	e80512e3          	bnez	a0,800510 <vprintfmt+0x1ae>
  800690:	b319                	j	800396 <vprintfmt+0x34>
  800692:	000b2403          	lw	s0,0(s6)
  800696:	bb6d                	j	800450 <vprintfmt+0xee>
  800698:	000b6683          	lwu	a3,0(s6)
  80069c:	4729                	li	a4,10
  80069e:	8b32                	mv	s6,a2
  8006a0:	bd3d                	j	8004de <vprintfmt+0x17c>
  8006a2:	000b6683          	lwu	a3,0(s6)
  8006a6:	4741                	li	a4,16
  8006a8:	8b32                	mv	s6,a2
  8006aa:	bd15                	j	8004de <vprintfmt+0x17c>
  8006ac:	000b6683          	lwu	a3,0(s6)
  8006b0:	4721                	li	a4,8
  8006b2:	8b32                	mv	s6,a2
  8006b4:	b52d                	j	8004de <vprintfmt+0x17c>
  8006b6:	9982                	jalr	s3
  8006b8:	bd9d                	j	80052e <vprintfmt+0x1cc>
  8006ba:	864a                	mv	a2,s2
  8006bc:	85a6                	mv	a1,s1
  8006be:	02d00513          	li	a0,45
  8006c2:	e042                	sd	a6,0(sp)
  8006c4:	9982                	jalr	s3
  8006c6:	8b52                	mv	s6,s4
  8006c8:	408006b3          	neg	a3,s0
  8006cc:	4729                	li	a4,10
  8006ce:	6802                	ld	a6,0(sp)
  8006d0:	b539                	j	8004de <vprintfmt+0x17c>
  8006d2:	01905663          	blez	s9,8006de <vprintfmt+0x37c>
  8006d6:	02d00713          	li	a4,45
  8006da:	f6e815e3          	bne	a6,a4,800644 <vprintfmt+0x2e2>
  8006de:	00000417          	auipc	s0,0x0
  8006e2:	6bb40413          	addi	s0,s0,1723 # 800d99 <error_string+0x2b9>
  8006e6:	02800513          	li	a0,40
  8006ea:	02800713          	li	a4,40
  8006ee:	b50d                	j	800510 <vprintfmt+0x1ae>

00000000008006f0 <printfmt>:
  8006f0:	7139                	addi	sp,sp,-64
  8006f2:	02010313          	addi	t1,sp,32
  8006f6:	f03a                	sd	a4,32(sp)
  8006f8:	871a                	mv	a4,t1
  8006fa:	ec06                	sd	ra,24(sp)
  8006fc:	f43e                	sd	a5,40(sp)
  8006fe:	f842                	sd	a6,48(sp)
  800700:	fc46                	sd	a7,56(sp)
  800702:	e41a                	sd	t1,8(sp)
  800704:	c5fff0ef          	jal	ra,800362 <vprintfmt>
  800708:	60e2                	ld	ra,24(sp)
  80070a:	6121                	addi	sp,sp,64
  80070c:	8082                	ret

000000000080070e <main>:
  80070e:	711d                	addi	sp,sp,-96
  800710:	4651                	li	a2,20
  800712:	4581                	li	a1,0
  800714:	00001517          	auipc	a0,0x1
  800718:	91c50513          	addi	a0,a0,-1764 # 801030 <pids>
  80071c:	ec86                	sd	ra,88(sp)
  80071e:	e8a2                	sd	s0,80(sp)
  800720:	e4a6                	sd	s1,72(sp)
  800722:	e0ca                	sd	s2,64(sp)
  800724:	fc4e                	sd	s3,56(sp)
  800726:	f852                	sd	s4,48(sp)
  800728:	f456                	sd	s5,40(sp)
  80072a:	f05a                	sd	s6,32(sp)
  80072c:	ec5e                	sd	s7,24(sp)
  80072e:	badff0ef          	jal	ra,8002da <memset>
  800732:	4519                	li	a0,6
  800734:	00001a97          	auipc	s5,0x1
  800738:	8cca8a93          	addi	s5,s5,-1844 # 801000 <acc>
  80073c:	00001917          	auipc	s2,0x1
  800740:	8f490913          	addi	s2,s2,-1804 # 801030 <pids>
  800744:	b69ff0ef          	jal	ra,8002ac <lab6_set_priority>
  800748:	89d6                	mv	s3,s5
  80074a:	84ca                	mv	s1,s2
  80074c:	4401                	li	s0,0
  80074e:	4a15                	li	s4,5
  800750:	0009a023          	sw	zero,0(s3)
  800754:	b45ff0ef          	jal	ra,800298 <fork>
  800758:	c088                	sw	a0,0(s1)
  80075a:	c969                	beqz	a0,80082c <main+0x11e>
  80075c:	12054d63          	bltz	a0,800896 <main+0x188>
  800760:	2405                	addiw	s0,s0,1
  800762:	0991                	addi	s3,s3,4
  800764:	0491                	addi	s1,s1,4
  800766:	ff4415e3          	bne	s0,s4,800750 <main+0x42>
  80076a:	00001497          	auipc	s1,0x1
  80076e:	8ae48493          	addi	s1,s1,-1874 # 801018 <status>
  800772:	00000517          	auipc	a0,0x0
  800776:	66650513          	addi	a0,a0,1638 # 800dd8 <error_string+0x2f8>
  80077a:	a17ff0ef          	jal	ra,800190 <cprintf>
  80077e:	00001997          	auipc	s3,0x1
  800782:	8ae98993          	addi	s3,s3,-1874 # 80102c <status+0x14>
  800786:	8a26                	mv	s4,s1
  800788:	8426                	mv	s0,s1
  80078a:	00000b97          	auipc	s7,0x0
  80078e:	676b8b93          	addi	s7,s7,1654 # 800e00 <error_string+0x320>
  800792:	00092503          	lw	a0,0(s2)
  800796:	85a2                	mv	a1,s0
  800798:	00042023          	sw	zero,0(s0)
  80079c:	b01ff0ef          	jal	ra,80029c <waitpid>
  8007a0:	00092a83          	lw	s5,0(s2)
  8007a4:	00042b03          	lw	s6,0(s0)
  8007a8:	b01ff0ef          	jal	ra,8002a8 <gettime_msec>
  8007ac:	0005069b          	sext.w	a3,a0
  8007b0:	865a                	mv	a2,s6
  8007b2:	85d6                	mv	a1,s5
  8007b4:	855e                	mv	a0,s7
  8007b6:	0411                	addi	s0,s0,4
  8007b8:	9d9ff0ef          	jal	ra,800190 <cprintf>
  8007bc:	0911                	addi	s2,s2,4
  8007be:	fd341ae3          	bne	s0,s3,800792 <main+0x84>
  8007c2:	00000517          	auipc	a0,0x0
  8007c6:	65e50513          	addi	a0,a0,1630 # 800e20 <error_string+0x340>
  8007ca:	9c7ff0ef          	jal	ra,800190 <cprintf>
  8007ce:	00000517          	auipc	a0,0x0
  8007d2:	66a50513          	addi	a0,a0,1642 # 800e38 <error_string+0x358>
  8007d6:	9bbff0ef          	jal	ra,800190 <cprintf>
  8007da:	00000417          	auipc	s0,0x0
  8007de:	67e40413          	addi	s0,s0,1662 # 800e58 <error_string+0x378>
  8007e2:	408c                	lw	a1,0(s1)
  8007e4:	000a2783          	lw	a5,0(s4)
  8007e8:	0491                	addi	s1,s1,4
  8007ea:	0015959b          	slliw	a1,a1,0x1
  8007ee:	02f5c5bb          	divw	a1,a1,a5
  8007f2:	8522                	mv	a0,s0
  8007f4:	2585                	addiw	a1,a1,1
  8007f6:	01f5d79b          	srliw	a5,a1,0x1f
  8007fa:	9dbd                	addw	a1,a1,a5
  8007fc:	4015d59b          	sraiw	a1,a1,0x1
  800800:	991ff0ef          	jal	ra,800190 <cprintf>
  800804:	fd349fe3          	bne	s1,s3,8007e2 <main+0xd4>
  800808:	00000517          	auipc	a0,0x0
  80080c:	12050513          	addi	a0,a0,288 # 800928 <main+0x21a>
  800810:	981ff0ef          	jal	ra,800190 <cprintf>
  800814:	60e6                	ld	ra,88(sp)
  800816:	6446                	ld	s0,80(sp)
  800818:	64a6                	ld	s1,72(sp)
  80081a:	6906                	ld	s2,64(sp)
  80081c:	79e2                	ld	s3,56(sp)
  80081e:	7a42                	ld	s4,48(sp)
  800820:	7aa2                	ld	s5,40(sp)
  800822:	7b02                	ld	s6,32(sp)
  800824:	6be2                	ld	s7,24(sp)
  800826:	4501                	li	a0,0
  800828:	6125                	addi	sp,sp,96
  80082a:	8082                	ret
  80082c:	0014051b          	addiw	a0,s0,1
  800830:	040a                	slli	s0,s0,0x2
  800832:	9456                	add	s0,s0,s5
  800834:	6485                	lui	s1,0x1
  800836:	6909                	lui	s2,0x2
  800838:	a75ff0ef          	jal	ra,8002ac <lab6_set_priority>
  80083c:	fa04849b          	addiw	s1,s1,-96
  800840:	00042023          	sw	zero,0(s0)
  800844:	71090913          	addi	s2,s2,1808 # 2710 <__panic-0x7fd910>
  800848:	4014                	lw	a3,0(s0)
  80084a:	2685                	addiw	a3,a3,1
  80084c:	0c800713          	li	a4,200
  800850:	47b2                	lw	a5,12(sp)
  800852:	377d                	addiw	a4,a4,-1
  800854:	2781                	sext.w	a5,a5
  800856:	0017b793          	seqz	a5,a5
  80085a:	c63e                	sw	a5,12(sp)
  80085c:	fb75                	bnez	a4,800850 <main+0x142>
  80085e:	0296f7bb          	remuw	a5,a3,s1
  800862:	0016871b          	addiw	a4,a3,1
  800866:	c399                	beqz	a5,80086c <main+0x15e>
  800868:	86ba                	mv	a3,a4
  80086a:	b7cd                	j	80084c <main+0x13e>
  80086c:	c014                	sw	a3,0(s0)
  80086e:	a3bff0ef          	jal	ra,8002a8 <gettime_msec>
  800872:	0005099b          	sext.w	s3,a0
  800876:	fd3959e3          	ble	s3,s2,800848 <main+0x13a>
  80087a:	a2bff0ef          	jal	ra,8002a4 <getpid>
  80087e:	4010                	lw	a2,0(s0)
  800880:	85aa                	mv	a1,a0
  800882:	86ce                	mv	a3,s3
  800884:	00000517          	auipc	a0,0x0
  800888:	53450513          	addi	a0,a0,1332 # 800db8 <error_string+0x2d8>
  80088c:	905ff0ef          	jal	ra,800190 <cprintf>
  800890:	4008                	lw	a0,0(s0)
  800892:	9f1ff0ef          	jal	ra,800282 <exit>
  800896:	00000417          	auipc	s0,0x0
  80089a:	7ae40413          	addi	s0,s0,1966 # 801044 <pids+0x14>
  80089e:	00092503          	lw	a0,0(s2)
  8008a2:	00a05463          	blez	a0,8008aa <main+0x19c>
  8008a6:	9fbff0ef          	jal	ra,8002a0 <kill>
  8008aa:	0911                	addi	s2,s2,4
  8008ac:	ff2419e3          	bne	s0,s2,80089e <main+0x190>
  8008b0:	00000617          	auipc	a2,0x0
  8008b4:	5b060613          	addi	a2,a2,1456 # 800e60 <error_string+0x380>
  8008b8:	04b00593          	li	a1,75
  8008bc:	00000517          	auipc	a0,0x0
  8008c0:	5b450513          	addi	a0,a0,1460 # 800e70 <error_string+0x390>
  8008c4:	f5cff0ef          	jal	ra,800020 <__panic>
