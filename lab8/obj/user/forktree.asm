
obj/__user_forktree.out：     文件格式 elf64-littleriscv


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
  800032:	7b250513          	addi	a0,a0,1970 # 8007e0 <main+0x3a>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	0f2000ef          	jal	ra,800134 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	0c4000ef          	jal	ra,80010e <vcprintf>
  80004e:	00000517          	auipc	a0,0x0
  800052:	7d250513          	addi	a0,a0,2002 # 800820 <main+0x7a>
  800056:	0de000ef          	jal	ra,800134 <cprintf>
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

00000000008000a2 <sys_fork>:
  8000a2:	4509                	li	a0,2
  8000a4:	fbfff06f          	j	800062 <syscall>

00000000008000a8 <sys_yield>:
  8000a8:	4529                	li	a0,10
  8000aa:	fb9ff06f          	j	800062 <syscall>

00000000008000ae <sys_getpid>:
  8000ae:	4549                	li	a0,18
  8000b0:	fb3ff06f          	j	800062 <syscall>

00000000008000b4 <sys_putc>:
  8000b4:	85aa                	mv	a1,a0
  8000b6:	4579                	li	a0,30
  8000b8:	fabff06f          	j	800062 <syscall>

00000000008000bc <sys_open>:
  8000bc:	862e                	mv	a2,a1
  8000be:	85aa                	mv	a1,a0
  8000c0:	06400513          	li	a0,100
  8000c4:	f9fff06f          	j	800062 <syscall>

00000000008000c8 <sys_close>:
  8000c8:	85aa                	mv	a1,a0
  8000ca:	06500513          	li	a0,101
  8000ce:	f95ff06f          	j	800062 <syscall>

00000000008000d2 <sys_dup>:
  8000d2:	862e                	mv	a2,a1
  8000d4:	85aa                	mv	a1,a0
  8000d6:	08200513          	li	a0,130
  8000da:	f89ff06f          	j	800062 <syscall>

00000000008000de <_start>:
  8000de:	0d4000ef          	jal	ra,8001b2 <umain>
  8000e2:	a001                	j	8000e2 <_start+0x4>

00000000008000e4 <open>:
  8000e4:	1582                	slli	a1,a1,0x20
  8000e6:	9181                	srli	a1,a1,0x20
  8000e8:	fd5ff06f          	j	8000bc <sys_open>

00000000008000ec <close>:
  8000ec:	fddff06f          	j	8000c8 <sys_close>

00000000008000f0 <dup2>:
  8000f0:	fe3ff06f          	j	8000d2 <sys_dup>

00000000008000f4 <cputch>:
  8000f4:	1141                	addi	sp,sp,-16
  8000f6:	e022                	sd	s0,0(sp)
  8000f8:	e406                	sd	ra,8(sp)
  8000fa:	842e                	mv	s0,a1
  8000fc:	fb9ff0ef          	jal	ra,8000b4 <sys_putc>
  800100:	401c                	lw	a5,0(s0)
  800102:	60a2                	ld	ra,8(sp)
  800104:	2785                	addiw	a5,a5,1
  800106:	c01c                	sw	a5,0(s0)
  800108:	6402                	ld	s0,0(sp)
  80010a:	0141                	addi	sp,sp,16
  80010c:	8082                	ret

000000000080010e <vcprintf>:
  80010e:	1101                	addi	sp,sp,-32
  800110:	872e                	mv	a4,a1
  800112:	75dd                	lui	a1,0xffff7
  800114:	86aa                	mv	a3,a0
  800116:	0070                	addi	a2,sp,12
  800118:	00000517          	auipc	a0,0x0
  80011c:	fdc50513          	addi	a0,a0,-36 # 8000f4 <cputch>
  800120:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6101>
  800124:	ec06                	sd	ra,24(sp)
  800126:	c602                	sw	zero,12(sp)
  800128:	1f4000ef          	jal	ra,80031c <vprintfmt>
  80012c:	60e2                	ld	ra,24(sp)
  80012e:	4532                	lw	a0,12(sp)
  800130:	6105                	addi	sp,sp,32
  800132:	8082                	ret

0000000000800134 <cprintf>:
  800134:	711d                	addi	sp,sp,-96
  800136:	02810313          	addi	t1,sp,40
  80013a:	f42e                	sd	a1,40(sp)
  80013c:	75dd                	lui	a1,0xffff7
  80013e:	f832                	sd	a2,48(sp)
  800140:	fc36                	sd	a3,56(sp)
  800142:	e0ba                	sd	a4,64(sp)
  800144:	86aa                	mv	a3,a0
  800146:	0050                	addi	a2,sp,4
  800148:	00000517          	auipc	a0,0x0
  80014c:	fac50513          	addi	a0,a0,-84 # 8000f4 <cputch>
  800150:	871a                	mv	a4,t1
  800152:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6101>
  800156:	ec06                	sd	ra,24(sp)
  800158:	e4be                	sd	a5,72(sp)
  80015a:	e8c2                	sd	a6,80(sp)
  80015c:	ecc6                	sd	a7,88(sp)
  80015e:	e41a                	sd	t1,8(sp)
  800160:	c202                	sw	zero,4(sp)
  800162:	1ba000ef          	jal	ra,80031c <vprintfmt>
  800166:	60e2                	ld	ra,24(sp)
  800168:	4512                	lw	a0,4(sp)
  80016a:	6125                	addi	sp,sp,96
  80016c:	8082                	ret

000000000080016e <initfd>:
  80016e:	1101                	addi	sp,sp,-32
  800170:	87ae                	mv	a5,a1
  800172:	e426                	sd	s1,8(sp)
  800174:	85b2                	mv	a1,a2
  800176:	84aa                	mv	s1,a0
  800178:	853e                	mv	a0,a5
  80017a:	e822                	sd	s0,16(sp)
  80017c:	ec06                	sd	ra,24(sp)
  80017e:	f67ff0ef          	jal	ra,8000e4 <open>
  800182:	842a                	mv	s0,a0
  800184:	00054463          	bltz	a0,80018c <initfd+0x1e>
  800188:	00951863          	bne	a0,s1,800198 <initfd+0x2a>
  80018c:	8522                	mv	a0,s0
  80018e:	60e2                	ld	ra,24(sp)
  800190:	6442                	ld	s0,16(sp)
  800192:	64a2                	ld	s1,8(sp)
  800194:	6105                	addi	sp,sp,32
  800196:	8082                	ret
  800198:	8526                	mv	a0,s1
  80019a:	f53ff0ef          	jal	ra,8000ec <close>
  80019e:	85a6                	mv	a1,s1
  8001a0:	8522                	mv	a0,s0
  8001a2:	f4fff0ef          	jal	ra,8000f0 <dup2>
  8001a6:	84aa                	mv	s1,a0
  8001a8:	8522                	mv	a0,s0
  8001aa:	f43ff0ef          	jal	ra,8000ec <close>
  8001ae:	8426                	mv	s0,s1
  8001b0:	bff1                	j	80018c <initfd+0x1e>

00000000008001b2 <umain>:
  8001b2:	1101                	addi	sp,sp,-32
  8001b4:	e822                	sd	s0,16(sp)
  8001b6:	e426                	sd	s1,8(sp)
  8001b8:	842a                	mv	s0,a0
  8001ba:	84ae                	mv	s1,a1
  8001bc:	4601                	li	a2,0
  8001be:	00000597          	auipc	a1,0x0
  8001c2:	64258593          	addi	a1,a1,1602 # 800800 <main+0x5a>
  8001c6:	4501                	li	a0,0
  8001c8:	ec06                	sd	ra,24(sp)
  8001ca:	fa5ff0ef          	jal	ra,80016e <initfd>
  8001ce:	02054263          	bltz	a0,8001f2 <umain+0x40>
  8001d2:	4605                	li	a2,1
  8001d4:	00000597          	auipc	a1,0x0
  8001d8:	66c58593          	addi	a1,a1,1644 # 800840 <main+0x9a>
  8001dc:	4505                	li	a0,1
  8001de:	f91ff0ef          	jal	ra,80016e <initfd>
  8001e2:	02054563          	bltz	a0,80020c <umain+0x5a>
  8001e6:	85a6                	mv	a1,s1
  8001e8:	8522                	mv	a0,s0
  8001ea:	5bc000ef          	jal	ra,8007a6 <main>
  8001ee:	038000ef          	jal	ra,800226 <exit>
  8001f2:	86aa                	mv	a3,a0
  8001f4:	00000617          	auipc	a2,0x0
  8001f8:	61460613          	addi	a2,a2,1556 # 800808 <main+0x62>
  8001fc:	45e9                	li	a1,26
  8001fe:	00000517          	auipc	a0,0x0
  800202:	62a50513          	addi	a0,a0,1578 # 800828 <main+0x82>
  800206:	e1bff0ef          	jal	ra,800020 <__warn>
  80020a:	b7e1                	j	8001d2 <umain+0x20>
  80020c:	86aa                	mv	a3,a0
  80020e:	00000617          	auipc	a2,0x0
  800212:	63a60613          	addi	a2,a2,1594 # 800848 <main+0xa2>
  800216:	45f5                	li	a1,29
  800218:	00000517          	auipc	a0,0x0
  80021c:	61050513          	addi	a0,a0,1552 # 800828 <main+0x82>
  800220:	e01ff0ef          	jal	ra,800020 <__warn>
  800224:	b7c9                	j	8001e6 <umain+0x34>

0000000000800226 <exit>:
  800226:	1141                	addi	sp,sp,-16
  800228:	e406                	sd	ra,8(sp)
  80022a:	e71ff0ef          	jal	ra,80009a <sys_exit>
  80022e:	00000517          	auipc	a0,0x0
  800232:	63a50513          	addi	a0,a0,1594 # 800868 <main+0xc2>
  800236:	effff0ef          	jal	ra,800134 <cprintf>
  80023a:	a001                	j	80023a <exit+0x14>

000000000080023c <fork>:
  80023c:	e67ff06f          	j	8000a2 <sys_fork>

0000000000800240 <yield>:
  800240:	e69ff06f          	j	8000a8 <sys_yield>

0000000000800244 <getpid>:
  800244:	e6bff06f          	j	8000ae <sys_getpid>

0000000000800248 <strlen>:
  800248:	00054783          	lbu	a5,0(a0)
  80024c:	cb91                	beqz	a5,800260 <strlen+0x18>
  80024e:	4781                	li	a5,0
  800250:	0785                	addi	a5,a5,1
  800252:	00f50733          	add	a4,a0,a5
  800256:	00074703          	lbu	a4,0(a4)
  80025a:	fb7d                	bnez	a4,800250 <strlen+0x8>
  80025c:	853e                	mv	a0,a5
  80025e:	8082                	ret
  800260:	4781                	li	a5,0
  800262:	853e                	mv	a0,a5
  800264:	8082                	ret

0000000000800266 <strnlen>:
  800266:	c185                	beqz	a1,800286 <strnlen+0x20>
  800268:	00054783          	lbu	a5,0(a0)
  80026c:	cf89                	beqz	a5,800286 <strnlen+0x20>
  80026e:	4781                	li	a5,0
  800270:	a021                	j	800278 <strnlen+0x12>
  800272:	00074703          	lbu	a4,0(a4)
  800276:	c711                	beqz	a4,800282 <strnlen+0x1c>
  800278:	0785                	addi	a5,a5,1
  80027a:	00f50733          	add	a4,a0,a5
  80027e:	fef59ae3          	bne	a1,a5,800272 <strnlen+0xc>
  800282:	853e                	mv	a0,a5
  800284:	8082                	ret
  800286:	4781                	li	a5,0
  800288:	853e                	mv	a0,a5
  80028a:	8082                	ret

000000000080028c <printnum>:
  80028c:	02071893          	slli	a7,a4,0x20
  800290:	7139                	addi	sp,sp,-64
  800292:	0208d893          	srli	a7,a7,0x20
  800296:	e456                	sd	s5,8(sp)
  800298:	0316fab3          	remu	s5,a3,a7
  80029c:	f822                	sd	s0,48(sp)
  80029e:	f426                	sd	s1,40(sp)
  8002a0:	f04a                	sd	s2,32(sp)
  8002a2:	ec4e                	sd	s3,24(sp)
  8002a4:	fc06                	sd	ra,56(sp)
  8002a6:	e852                	sd	s4,16(sp)
  8002a8:	84aa                	mv	s1,a0
  8002aa:	89ae                	mv	s3,a1
  8002ac:	8932                	mv	s2,a2
  8002ae:	fff7841b          	addiw	s0,a5,-1
  8002b2:	2a81                	sext.w	s5,s5
  8002b4:	0516f163          	bleu	a7,a3,8002f6 <printnum+0x6a>
  8002b8:	8a42                	mv	s4,a6
  8002ba:	00805863          	blez	s0,8002ca <printnum+0x3e>
  8002be:	347d                	addiw	s0,s0,-1
  8002c0:	864e                	mv	a2,s3
  8002c2:	85ca                	mv	a1,s2
  8002c4:	8552                	mv	a0,s4
  8002c6:	9482                	jalr	s1
  8002c8:	f87d                	bnez	s0,8002be <printnum+0x32>
  8002ca:	1a82                	slli	s5,s5,0x20
  8002cc:	020ada93          	srli	s5,s5,0x20
  8002d0:	00000797          	auipc	a5,0x0
  8002d4:	7d078793          	addi	a5,a5,2000 # 800aa0 <error_string+0xc8>
  8002d8:	9abe                	add	s5,s5,a5
  8002da:	7442                	ld	s0,48(sp)
  8002dc:	000ac503          	lbu	a0,0(s5)
  8002e0:	70e2                	ld	ra,56(sp)
  8002e2:	6a42                	ld	s4,16(sp)
  8002e4:	6aa2                	ld	s5,8(sp)
  8002e6:	864e                	mv	a2,s3
  8002e8:	85ca                	mv	a1,s2
  8002ea:	69e2                	ld	s3,24(sp)
  8002ec:	7902                	ld	s2,32(sp)
  8002ee:	8326                	mv	t1,s1
  8002f0:	74a2                	ld	s1,40(sp)
  8002f2:	6121                	addi	sp,sp,64
  8002f4:	8302                	jr	t1
  8002f6:	0316d6b3          	divu	a3,a3,a7
  8002fa:	87a2                	mv	a5,s0
  8002fc:	f91ff0ef          	jal	ra,80028c <printnum>
  800300:	b7e9                	j	8002ca <printnum+0x3e>

0000000000800302 <sprintputch>:
  800302:	499c                	lw	a5,16(a1)
  800304:	6198                	ld	a4,0(a1)
  800306:	6594                	ld	a3,8(a1)
  800308:	2785                	addiw	a5,a5,1
  80030a:	c99c                	sw	a5,16(a1)
  80030c:	00d77763          	bleu	a3,a4,80031a <sprintputch+0x18>
  800310:	00170793          	addi	a5,a4,1
  800314:	e19c                	sd	a5,0(a1)
  800316:	00a70023          	sb	a0,0(a4)
  80031a:	8082                	ret

000000000080031c <vprintfmt>:
  80031c:	7119                	addi	sp,sp,-128
  80031e:	f4a6                	sd	s1,104(sp)
  800320:	f0ca                	sd	s2,96(sp)
  800322:	ecce                	sd	s3,88(sp)
  800324:	e4d6                	sd	s5,72(sp)
  800326:	e0da                	sd	s6,64(sp)
  800328:	fc5e                	sd	s7,56(sp)
  80032a:	f862                	sd	s8,48(sp)
  80032c:	ec6e                	sd	s11,24(sp)
  80032e:	fc86                	sd	ra,120(sp)
  800330:	f8a2                	sd	s0,112(sp)
  800332:	e8d2                	sd	s4,80(sp)
  800334:	f466                	sd	s9,40(sp)
  800336:	f06a                	sd	s10,32(sp)
  800338:	89aa                	mv	s3,a0
  80033a:	892e                	mv	s2,a1
  80033c:	84b2                	mv	s1,a2
  80033e:	8db6                	mv	s11,a3
  800340:	8b3a                	mv	s6,a4
  800342:	5bfd                	li	s7,-1
  800344:	00000a97          	auipc	s5,0x0
  800348:	538a8a93          	addi	s5,s5,1336 # 80087c <main+0xd6>
  80034c:	05e00c13          	li	s8,94
  800350:	000dc503          	lbu	a0,0(s11)
  800354:	02500793          	li	a5,37
  800358:	001d8413          	addi	s0,s11,1
  80035c:	00f50f63          	beq	a0,a5,80037a <vprintfmt+0x5e>
  800360:	c529                	beqz	a0,8003aa <vprintfmt+0x8e>
  800362:	02500a13          	li	s4,37
  800366:	a011                	j	80036a <vprintfmt+0x4e>
  800368:	c129                	beqz	a0,8003aa <vprintfmt+0x8e>
  80036a:	864a                	mv	a2,s2
  80036c:	85a6                	mv	a1,s1
  80036e:	0405                	addi	s0,s0,1
  800370:	9982                	jalr	s3
  800372:	fff44503          	lbu	a0,-1(s0)
  800376:	ff4519e3          	bne	a0,s4,800368 <vprintfmt+0x4c>
  80037a:	00044603          	lbu	a2,0(s0)
  80037e:	02000813          	li	a6,32
  800382:	4a01                	li	s4,0
  800384:	4881                	li	a7,0
  800386:	5d7d                	li	s10,-1
  800388:	5cfd                	li	s9,-1
  80038a:	05500593          	li	a1,85
  80038e:	4525                	li	a0,9
  800390:	fdd6071b          	addiw	a4,a2,-35
  800394:	0ff77713          	andi	a4,a4,255
  800398:	00140d93          	addi	s11,s0,1
  80039c:	22e5e363          	bltu	a1,a4,8005c2 <vprintfmt+0x2a6>
  8003a0:	070a                	slli	a4,a4,0x2
  8003a2:	9756                	add	a4,a4,s5
  8003a4:	4318                	lw	a4,0(a4)
  8003a6:	9756                	add	a4,a4,s5
  8003a8:	8702                	jr	a4
  8003aa:	70e6                	ld	ra,120(sp)
  8003ac:	7446                	ld	s0,112(sp)
  8003ae:	74a6                	ld	s1,104(sp)
  8003b0:	7906                	ld	s2,96(sp)
  8003b2:	69e6                	ld	s3,88(sp)
  8003b4:	6a46                	ld	s4,80(sp)
  8003b6:	6aa6                	ld	s5,72(sp)
  8003b8:	6b06                	ld	s6,64(sp)
  8003ba:	7be2                	ld	s7,56(sp)
  8003bc:	7c42                	ld	s8,48(sp)
  8003be:	7ca2                	ld	s9,40(sp)
  8003c0:	7d02                	ld	s10,32(sp)
  8003c2:	6de2                	ld	s11,24(sp)
  8003c4:	6109                	addi	sp,sp,128
  8003c6:	8082                	ret
  8003c8:	4705                	li	a4,1
  8003ca:	008b0613          	addi	a2,s6,8
  8003ce:	01174463          	blt	a4,a7,8003d6 <vprintfmt+0xba>
  8003d2:	28088563          	beqz	a7,80065c <vprintfmt+0x340>
  8003d6:	000b3683          	ld	a3,0(s6)
  8003da:	4741                	li	a4,16
  8003dc:	8b32                	mv	s6,a2
  8003de:	a86d                	j	800498 <vprintfmt+0x17c>
  8003e0:	00144603          	lbu	a2,1(s0)
  8003e4:	4a05                	li	s4,1
  8003e6:	846e                	mv	s0,s11
  8003e8:	b765                	j	800390 <vprintfmt+0x74>
  8003ea:	000b2503          	lw	a0,0(s6)
  8003ee:	864a                	mv	a2,s2
  8003f0:	85a6                	mv	a1,s1
  8003f2:	0b21                	addi	s6,s6,8
  8003f4:	9982                	jalr	s3
  8003f6:	bfa9                	j	800350 <vprintfmt+0x34>
  8003f8:	4705                	li	a4,1
  8003fa:	008b0a13          	addi	s4,s6,8
  8003fe:	01174463          	blt	a4,a7,800406 <vprintfmt+0xea>
  800402:	24088563          	beqz	a7,80064c <vprintfmt+0x330>
  800406:	000b3403          	ld	s0,0(s6)
  80040a:	26044563          	bltz	s0,800674 <vprintfmt+0x358>
  80040e:	86a2                	mv	a3,s0
  800410:	8b52                	mv	s6,s4
  800412:	4729                	li	a4,10
  800414:	a051                	j	800498 <vprintfmt+0x17c>
  800416:	000b2783          	lw	a5,0(s6)
  80041a:	46e1                	li	a3,24
  80041c:	0b21                	addi	s6,s6,8
  80041e:	41f7d71b          	sraiw	a4,a5,0x1f
  800422:	8fb9                	xor	a5,a5,a4
  800424:	40e7873b          	subw	a4,a5,a4
  800428:	1ce6c163          	blt	a3,a4,8005ea <vprintfmt+0x2ce>
  80042c:	00371793          	slli	a5,a4,0x3
  800430:	00000697          	auipc	a3,0x0
  800434:	5a868693          	addi	a3,a3,1448 # 8009d8 <error_string>
  800438:	97b6                	add	a5,a5,a3
  80043a:	639c                	ld	a5,0(a5)
  80043c:	1a078763          	beqz	a5,8005ea <vprintfmt+0x2ce>
  800440:	873e                	mv	a4,a5
  800442:	00001697          	auipc	a3,0x1
  800446:	86668693          	addi	a3,a3,-1946 # 800ca8 <error_string+0x2d0>
  80044a:	8626                	mv	a2,s1
  80044c:	85ca                	mv	a1,s2
  80044e:	854e                	mv	a0,s3
  800450:	25a000ef          	jal	ra,8006aa <printfmt>
  800454:	bdf5                	j	800350 <vprintfmt+0x34>
  800456:	00144603          	lbu	a2,1(s0)
  80045a:	2885                	addiw	a7,a7,1
  80045c:	846e                	mv	s0,s11
  80045e:	bf0d                	j	800390 <vprintfmt+0x74>
  800460:	4705                	li	a4,1
  800462:	008b0613          	addi	a2,s6,8
  800466:	01174463          	blt	a4,a7,80046e <vprintfmt+0x152>
  80046a:	1e088e63          	beqz	a7,800666 <vprintfmt+0x34a>
  80046e:	000b3683          	ld	a3,0(s6)
  800472:	4721                	li	a4,8
  800474:	8b32                	mv	s6,a2
  800476:	a00d                	j	800498 <vprintfmt+0x17c>
  800478:	03000513          	li	a0,48
  80047c:	864a                	mv	a2,s2
  80047e:	85a6                	mv	a1,s1
  800480:	e042                	sd	a6,0(sp)
  800482:	9982                	jalr	s3
  800484:	864a                	mv	a2,s2
  800486:	85a6                	mv	a1,s1
  800488:	07800513          	li	a0,120
  80048c:	9982                	jalr	s3
  80048e:	0b21                	addi	s6,s6,8
  800490:	ff8b3683          	ld	a3,-8(s6)
  800494:	6802                	ld	a6,0(sp)
  800496:	4741                	li	a4,16
  800498:	87e6                	mv	a5,s9
  80049a:	8626                	mv	a2,s1
  80049c:	85ca                	mv	a1,s2
  80049e:	854e                	mv	a0,s3
  8004a0:	dedff0ef          	jal	ra,80028c <printnum>
  8004a4:	b575                	j	800350 <vprintfmt+0x34>
  8004a6:	000b3703          	ld	a4,0(s6)
  8004aa:	0b21                	addi	s6,s6,8
  8004ac:	1e070063          	beqz	a4,80068c <vprintfmt+0x370>
  8004b0:	00170413          	addi	s0,a4,1
  8004b4:	19905563          	blez	s9,80063e <vprintfmt+0x322>
  8004b8:	02d00613          	li	a2,45
  8004bc:	14c81963          	bne	a6,a2,80060e <vprintfmt+0x2f2>
  8004c0:	00074703          	lbu	a4,0(a4)
  8004c4:	0007051b          	sext.w	a0,a4
  8004c8:	c90d                	beqz	a0,8004fa <vprintfmt+0x1de>
  8004ca:	000d4563          	bltz	s10,8004d4 <vprintfmt+0x1b8>
  8004ce:	3d7d                	addiw	s10,s10,-1
  8004d0:	037d0363          	beq	s10,s7,8004f6 <vprintfmt+0x1da>
  8004d4:	864a                	mv	a2,s2
  8004d6:	85a6                	mv	a1,s1
  8004d8:	180a0c63          	beqz	s4,800670 <vprintfmt+0x354>
  8004dc:	3701                	addiw	a4,a4,-32
  8004de:	18ec7963          	bleu	a4,s8,800670 <vprintfmt+0x354>
  8004e2:	03f00513          	li	a0,63
  8004e6:	9982                	jalr	s3
  8004e8:	0405                	addi	s0,s0,1
  8004ea:	fff44703          	lbu	a4,-1(s0)
  8004ee:	3cfd                	addiw	s9,s9,-1
  8004f0:	0007051b          	sext.w	a0,a4
  8004f4:	f979                	bnez	a0,8004ca <vprintfmt+0x1ae>
  8004f6:	e5905de3          	blez	s9,800350 <vprintfmt+0x34>
  8004fa:	3cfd                	addiw	s9,s9,-1
  8004fc:	864a                	mv	a2,s2
  8004fe:	85a6                	mv	a1,s1
  800500:	02000513          	li	a0,32
  800504:	9982                	jalr	s3
  800506:	e40c85e3          	beqz	s9,800350 <vprintfmt+0x34>
  80050a:	3cfd                	addiw	s9,s9,-1
  80050c:	864a                	mv	a2,s2
  80050e:	85a6                	mv	a1,s1
  800510:	02000513          	li	a0,32
  800514:	9982                	jalr	s3
  800516:	fe0c92e3          	bnez	s9,8004fa <vprintfmt+0x1de>
  80051a:	bd1d                	j	800350 <vprintfmt+0x34>
  80051c:	4705                	li	a4,1
  80051e:	008b0613          	addi	a2,s6,8
  800522:	01174463          	blt	a4,a7,80052a <vprintfmt+0x20e>
  800526:	12088663          	beqz	a7,800652 <vprintfmt+0x336>
  80052a:	000b3683          	ld	a3,0(s6)
  80052e:	4729                	li	a4,10
  800530:	8b32                	mv	s6,a2
  800532:	b79d                	j	800498 <vprintfmt+0x17c>
  800534:	00144603          	lbu	a2,1(s0)
  800538:	02d00813          	li	a6,45
  80053c:	846e                	mv	s0,s11
  80053e:	bd89                	j	800390 <vprintfmt+0x74>
  800540:	864a                	mv	a2,s2
  800542:	85a6                	mv	a1,s1
  800544:	02500513          	li	a0,37
  800548:	9982                	jalr	s3
  80054a:	b519                	j	800350 <vprintfmt+0x34>
  80054c:	000b2d03          	lw	s10,0(s6)
  800550:	00144603          	lbu	a2,1(s0)
  800554:	0b21                	addi	s6,s6,8
  800556:	846e                	mv	s0,s11
  800558:	e20cdce3          	bgez	s9,800390 <vprintfmt+0x74>
  80055c:	8cea                	mv	s9,s10
  80055e:	5d7d                	li	s10,-1
  800560:	bd05                	j	800390 <vprintfmt+0x74>
  800562:	00144603          	lbu	a2,1(s0)
  800566:	03000813          	li	a6,48
  80056a:	846e                	mv	s0,s11
  80056c:	b515                	j	800390 <vprintfmt+0x74>
  80056e:	fd060d1b          	addiw	s10,a2,-48
  800572:	00144603          	lbu	a2,1(s0)
  800576:	846e                	mv	s0,s11
  800578:	fd06071b          	addiw	a4,a2,-48
  80057c:	0006031b          	sext.w	t1,a2
  800580:	fce56ce3          	bltu	a0,a4,800558 <vprintfmt+0x23c>
  800584:	0405                	addi	s0,s0,1
  800586:	002d171b          	slliw	a4,s10,0x2
  80058a:	00044603          	lbu	a2,0(s0)
  80058e:	01a706bb          	addw	a3,a4,s10
  800592:	0016969b          	slliw	a3,a3,0x1
  800596:	006686bb          	addw	a3,a3,t1
  80059a:	fd06071b          	addiw	a4,a2,-48
  80059e:	fd068d1b          	addiw	s10,a3,-48
  8005a2:	0006031b          	sext.w	t1,a2
  8005a6:	fce57fe3          	bleu	a4,a0,800584 <vprintfmt+0x268>
  8005aa:	b77d                	j	800558 <vprintfmt+0x23c>
  8005ac:	fffcc713          	not	a4,s9
  8005b0:	977d                	srai	a4,a4,0x3f
  8005b2:	00ecf7b3          	and	a5,s9,a4
  8005b6:	00144603          	lbu	a2,1(s0)
  8005ba:	00078c9b          	sext.w	s9,a5
  8005be:	846e                	mv	s0,s11
  8005c0:	bbc1                	j	800390 <vprintfmt+0x74>
  8005c2:	864a                	mv	a2,s2
  8005c4:	85a6                	mv	a1,s1
  8005c6:	02500513          	li	a0,37
  8005ca:	9982                	jalr	s3
  8005cc:	fff44703          	lbu	a4,-1(s0)
  8005d0:	02500793          	li	a5,37
  8005d4:	8da2                	mv	s11,s0
  8005d6:	d6f70de3          	beq	a4,a5,800350 <vprintfmt+0x34>
  8005da:	02500713          	li	a4,37
  8005de:	1dfd                	addi	s11,s11,-1
  8005e0:	fffdc783          	lbu	a5,-1(s11)
  8005e4:	fee79de3          	bne	a5,a4,8005de <vprintfmt+0x2c2>
  8005e8:	b3a5                	j	800350 <vprintfmt+0x34>
  8005ea:	00000697          	auipc	a3,0x0
  8005ee:	6ae68693          	addi	a3,a3,1710 # 800c98 <error_string+0x2c0>
  8005f2:	8626                	mv	a2,s1
  8005f4:	85ca                	mv	a1,s2
  8005f6:	854e                	mv	a0,s3
  8005f8:	0b2000ef          	jal	ra,8006aa <printfmt>
  8005fc:	bb91                	j	800350 <vprintfmt+0x34>
  8005fe:	00000717          	auipc	a4,0x0
  800602:	69270713          	addi	a4,a4,1682 # 800c90 <error_string+0x2b8>
  800606:	00000417          	auipc	s0,0x0
  80060a:	68b40413          	addi	s0,s0,1675 # 800c91 <error_string+0x2b9>
  80060e:	853a                	mv	a0,a4
  800610:	85ea                	mv	a1,s10
  800612:	e03a                	sd	a4,0(sp)
  800614:	e442                	sd	a6,8(sp)
  800616:	c51ff0ef          	jal	ra,800266 <strnlen>
  80061a:	40ac8cbb          	subw	s9,s9,a0
  80061e:	6702                	ld	a4,0(sp)
  800620:	01905f63          	blez	s9,80063e <vprintfmt+0x322>
  800624:	6822                	ld	a6,8(sp)
  800626:	0008079b          	sext.w	a5,a6
  80062a:	e43e                	sd	a5,8(sp)
  80062c:	6522                	ld	a0,8(sp)
  80062e:	864a                	mv	a2,s2
  800630:	85a6                	mv	a1,s1
  800632:	e03a                	sd	a4,0(sp)
  800634:	3cfd                	addiw	s9,s9,-1
  800636:	9982                	jalr	s3
  800638:	6702                	ld	a4,0(sp)
  80063a:	fe0c99e3          	bnez	s9,80062c <vprintfmt+0x310>
  80063e:	00074703          	lbu	a4,0(a4)
  800642:	0007051b          	sext.w	a0,a4
  800646:	e80512e3          	bnez	a0,8004ca <vprintfmt+0x1ae>
  80064a:	b319                	j	800350 <vprintfmt+0x34>
  80064c:	000b2403          	lw	s0,0(s6)
  800650:	bb6d                	j	80040a <vprintfmt+0xee>
  800652:	000b6683          	lwu	a3,0(s6)
  800656:	4729                	li	a4,10
  800658:	8b32                	mv	s6,a2
  80065a:	bd3d                	j	800498 <vprintfmt+0x17c>
  80065c:	000b6683          	lwu	a3,0(s6)
  800660:	4741                	li	a4,16
  800662:	8b32                	mv	s6,a2
  800664:	bd15                	j	800498 <vprintfmt+0x17c>
  800666:	000b6683          	lwu	a3,0(s6)
  80066a:	4721                	li	a4,8
  80066c:	8b32                	mv	s6,a2
  80066e:	b52d                	j	800498 <vprintfmt+0x17c>
  800670:	9982                	jalr	s3
  800672:	bd9d                	j	8004e8 <vprintfmt+0x1cc>
  800674:	864a                	mv	a2,s2
  800676:	85a6                	mv	a1,s1
  800678:	02d00513          	li	a0,45
  80067c:	e042                	sd	a6,0(sp)
  80067e:	9982                	jalr	s3
  800680:	8b52                	mv	s6,s4
  800682:	408006b3          	neg	a3,s0
  800686:	4729                	li	a4,10
  800688:	6802                	ld	a6,0(sp)
  80068a:	b539                	j	800498 <vprintfmt+0x17c>
  80068c:	01905663          	blez	s9,800698 <vprintfmt+0x37c>
  800690:	02d00713          	li	a4,45
  800694:	f6e815e3          	bne	a6,a4,8005fe <vprintfmt+0x2e2>
  800698:	00000417          	auipc	s0,0x0
  80069c:	5f940413          	addi	s0,s0,1529 # 800c91 <error_string+0x2b9>
  8006a0:	02800513          	li	a0,40
  8006a4:	02800713          	li	a4,40
  8006a8:	b50d                	j	8004ca <vprintfmt+0x1ae>

00000000008006aa <printfmt>:
  8006aa:	7139                	addi	sp,sp,-64
  8006ac:	02010313          	addi	t1,sp,32
  8006b0:	f03a                	sd	a4,32(sp)
  8006b2:	871a                	mv	a4,t1
  8006b4:	ec06                	sd	ra,24(sp)
  8006b6:	f43e                	sd	a5,40(sp)
  8006b8:	f842                	sd	a6,48(sp)
  8006ba:	fc46                	sd	a7,56(sp)
  8006bc:	e41a                	sd	t1,8(sp)
  8006be:	c5fff0ef          	jal	ra,80031c <vprintfmt>
  8006c2:	60e2                	ld	ra,24(sp)
  8006c4:	6121                	addi	sp,sp,64
  8006c6:	8082                	ret

00000000008006c8 <vsnprintf>:
  8006c8:	15fd                	addi	a1,a1,-1
  8006ca:	7179                	addi	sp,sp,-48
  8006cc:	95aa                	add	a1,a1,a0
  8006ce:	f406                	sd	ra,40(sp)
  8006d0:	e42a                	sd	a0,8(sp)
  8006d2:	e82e                	sd	a1,16(sp)
  8006d4:	cc02                	sw	zero,24(sp)
  8006d6:	c515                	beqz	a0,800702 <vsnprintf+0x3a>
  8006d8:	02a5e563          	bltu	a1,a0,800702 <vsnprintf+0x3a>
  8006dc:	75dd                	lui	a1,0xffff7
  8006de:	8736                	mv	a4,a3
  8006e0:	00000517          	auipc	a0,0x0
  8006e4:	c2250513          	addi	a0,a0,-990 # 800302 <sprintputch>
  8006e8:	86b2                	mv	a3,a2
  8006ea:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6101>
  8006ee:	0030                	addi	a2,sp,8
  8006f0:	c2dff0ef          	jal	ra,80031c <vprintfmt>
  8006f4:	67a2                	ld	a5,8(sp)
  8006f6:	00078023          	sb	zero,0(a5)
  8006fa:	4562                	lw	a0,24(sp)
  8006fc:	70a2                	ld	ra,40(sp)
  8006fe:	6145                	addi	sp,sp,48
  800700:	8082                	ret
  800702:	5575                	li	a0,-3
  800704:	bfe5                	j	8006fc <vsnprintf+0x34>

0000000000800706 <snprintf>:
  800706:	715d                	addi	sp,sp,-80
  800708:	02810313          	addi	t1,sp,40
  80070c:	f436                	sd	a3,40(sp)
  80070e:	869a                	mv	a3,t1
  800710:	ec06                	sd	ra,24(sp)
  800712:	f83a                	sd	a4,48(sp)
  800714:	fc3e                	sd	a5,56(sp)
  800716:	e0c2                	sd	a6,64(sp)
  800718:	e4c6                	sd	a7,72(sp)
  80071a:	e41a                	sd	t1,8(sp)
  80071c:	fadff0ef          	jal	ra,8006c8 <vsnprintf>
  800720:	60e2                	ld	ra,24(sp)
  800722:	6161                	addi	sp,sp,80
  800724:	8082                	ret

0000000000800726 <forktree>:
  800726:	1141                	addi	sp,sp,-16
  800728:	e406                	sd	ra,8(sp)
  80072a:	e022                	sd	s0,0(sp)
  80072c:	842a                	mv	s0,a0
  80072e:	b17ff0ef          	jal	ra,800244 <getpid>
  800732:	8622                	mv	a2,s0
  800734:	85aa                	mv	a1,a0
  800736:	00000517          	auipc	a0,0x0
  80073a:	58250513          	addi	a0,a0,1410 # 800cb8 <error_string+0x2e0>
  80073e:	9f7ff0ef          	jal	ra,800134 <cprintf>
  800742:	8522                	mv	a0,s0
  800744:	03000593          	li	a1,48
  800748:	014000ef          	jal	ra,80075c <forkchild>
  80074c:	8522                	mv	a0,s0
  80074e:	6402                	ld	s0,0(sp)
  800750:	60a2                	ld	ra,8(sp)
  800752:	03100593          	li	a1,49
  800756:	0141                	addi	sp,sp,16
  800758:	0040006f          	j	80075c <forkchild>

000000000080075c <forkchild>:
  80075c:	7179                	addi	sp,sp,-48
  80075e:	f022                	sd	s0,32(sp)
  800760:	ec26                	sd	s1,24(sp)
  800762:	f406                	sd	ra,40(sp)
  800764:	842a                	mv	s0,a0
  800766:	84ae                	mv	s1,a1
  800768:	ae1ff0ef          	jal	ra,800248 <strlen>
  80076c:	4789                	li	a5,2
  80076e:	00a7f763          	bleu	a0,a5,80077c <forkchild+0x20>
  800772:	70a2                	ld	ra,40(sp)
  800774:	7402                	ld	s0,32(sp)
  800776:	64e2                	ld	s1,24(sp)
  800778:	6145                	addi	sp,sp,48
  80077a:	8082                	ret
  80077c:	8726                	mv	a4,s1
  80077e:	86a2                	mv	a3,s0
  800780:	00000617          	auipc	a2,0x0
  800784:	53060613          	addi	a2,a2,1328 # 800cb0 <error_string+0x2d8>
  800788:	4591                	li	a1,4
  80078a:	0028                	addi	a0,sp,8
  80078c:	f7bff0ef          	jal	ra,800706 <snprintf>
  800790:	aadff0ef          	jal	ra,80023c <fork>
  800794:	fd79                	bnez	a0,800772 <forkchild+0x16>
  800796:	0028                	addi	a0,sp,8
  800798:	f8fff0ef          	jal	ra,800726 <forktree>
  80079c:	aa5ff0ef          	jal	ra,800240 <yield>
  8007a0:	4501                	li	a0,0
  8007a2:	a85ff0ef          	jal	ra,800226 <exit>

00000000008007a6 <main>:
  8007a6:	1141                	addi	sp,sp,-16
  8007a8:	00000517          	auipc	a0,0x0
  8007ac:	52050513          	addi	a0,a0,1312 # 800cc8 <error_string+0x2f0>
  8007b0:	e406                	sd	ra,8(sp)
  8007b2:	f75ff0ef          	jal	ra,800726 <forktree>
  8007b6:	60a2                	ld	ra,8(sp)
  8007b8:	4501                	li	a0,0
  8007ba:	0141                	addi	sp,sp,16
  8007bc:	8082                	ret
