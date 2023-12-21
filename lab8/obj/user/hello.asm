
obj/__user_hello.out：     文件格式 elf64-littleriscv


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
  800032:	6aa50513          	addi	a0,a0,1706 # 8006d8 <main+0x5c>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	0e6000ef          	jal	ra,800128 <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	0b8000ef          	jal	ra,800102 <vcprintf>
  80004e:	00001517          	auipc	a0,0x1
  800052:	b7a50513          	addi	a0,a0,-1158 # 800bc8 <error_string+0x2f8>
  800056:	0d2000ef          	jal	ra,800128 <cprintf>
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

00000000008000a2 <sys_getpid>:
  8000a2:	4549                	li	a0,18
  8000a4:	fbfff06f          	j	800062 <syscall>

00000000008000a8 <sys_putc>:
  8000a8:	85aa                	mv	a1,a0
  8000aa:	4579                	li	a0,30
  8000ac:	fb7ff06f          	j	800062 <syscall>

00000000008000b0 <sys_open>:
  8000b0:	862e                	mv	a2,a1
  8000b2:	85aa                	mv	a1,a0
  8000b4:	06400513          	li	a0,100
  8000b8:	fabff06f          	j	800062 <syscall>

00000000008000bc <sys_close>:
  8000bc:	85aa                	mv	a1,a0
  8000be:	06500513          	li	a0,101
  8000c2:	fa1ff06f          	j	800062 <syscall>

00000000008000c6 <sys_dup>:
  8000c6:	862e                	mv	a2,a1
  8000c8:	85aa                	mv	a1,a0
  8000ca:	08200513          	li	a0,130
  8000ce:	f95ff06f          	j	800062 <syscall>

00000000008000d2 <_start>:
  8000d2:	0d4000ef          	jal	ra,8001a6 <umain>
  8000d6:	a001                	j	8000d6 <_start+0x4>

00000000008000d8 <open>:
  8000d8:	1582                	slli	a1,a1,0x20
  8000da:	9181                	srli	a1,a1,0x20
  8000dc:	fd5ff06f          	j	8000b0 <sys_open>

00000000008000e0 <close>:
  8000e0:	fddff06f          	j	8000bc <sys_close>

00000000008000e4 <dup2>:
  8000e4:	fe3ff06f          	j	8000c6 <sys_dup>

00000000008000e8 <cputch>:
  8000e8:	1141                	addi	sp,sp,-16
  8000ea:	e022                	sd	s0,0(sp)
  8000ec:	e406                	sd	ra,8(sp)
  8000ee:	842e                	mv	s0,a1
  8000f0:	fb9ff0ef          	jal	ra,8000a8 <sys_putc>
  8000f4:	401c                	lw	a5,0(s0)
  8000f6:	60a2                	ld	ra,8(sp)
  8000f8:	2785                	addiw	a5,a5,1
  8000fa:	c01c                	sw	a5,0(s0)
  8000fc:	6402                	ld	s0,0(sp)
  8000fe:	0141                	addi	sp,sp,16
  800100:	8082                	ret

0000000000800102 <vcprintf>:
  800102:	1101                	addi	sp,sp,-32
  800104:	872e                	mv	a4,a1
  800106:	75dd                	lui	a1,0xffff7
  800108:	86aa                	mv	a3,a0
  80010a:	0070                	addi	a2,sp,12
  80010c:	00000517          	auipc	a0,0x0
  800110:	fdc50513          	addi	a0,a0,-36 # 8000e8 <cputch>
  800114:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6209>
  800118:	ec06                	sd	ra,24(sp)
  80011a:	c602                	sw	zero,12(sp)
  80011c:	1b4000ef          	jal	ra,8002d0 <vprintfmt>
  800120:	60e2                	ld	ra,24(sp)
  800122:	4532                	lw	a0,12(sp)
  800124:	6105                	addi	sp,sp,32
  800126:	8082                	ret

0000000000800128 <cprintf>:
  800128:	711d                	addi	sp,sp,-96
  80012a:	02810313          	addi	t1,sp,40
  80012e:	f42e                	sd	a1,40(sp)
  800130:	75dd                	lui	a1,0xffff7
  800132:	f832                	sd	a2,48(sp)
  800134:	fc36                	sd	a3,56(sp)
  800136:	e0ba                	sd	a4,64(sp)
  800138:	86aa                	mv	a3,a0
  80013a:	0050                	addi	a2,sp,4
  80013c:	00000517          	auipc	a0,0x0
  800140:	fac50513          	addi	a0,a0,-84 # 8000e8 <cputch>
  800144:	871a                	mv	a4,t1
  800146:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6209>
  80014a:	ec06                	sd	ra,24(sp)
  80014c:	e4be                	sd	a5,72(sp)
  80014e:	e8c2                	sd	a6,80(sp)
  800150:	ecc6                	sd	a7,88(sp)
  800152:	e41a                	sd	t1,8(sp)
  800154:	c202                	sw	zero,4(sp)
  800156:	17a000ef          	jal	ra,8002d0 <vprintfmt>
  80015a:	60e2                	ld	ra,24(sp)
  80015c:	4512                	lw	a0,4(sp)
  80015e:	6125                	addi	sp,sp,96
  800160:	8082                	ret

0000000000800162 <initfd>:
  800162:	1101                	addi	sp,sp,-32
  800164:	87ae                	mv	a5,a1
  800166:	e426                	sd	s1,8(sp)
  800168:	85b2                	mv	a1,a2
  80016a:	84aa                	mv	s1,a0
  80016c:	853e                	mv	a0,a5
  80016e:	e822                	sd	s0,16(sp)
  800170:	ec06                	sd	ra,24(sp)
  800172:	f67ff0ef          	jal	ra,8000d8 <open>
  800176:	842a                	mv	s0,a0
  800178:	00054463          	bltz	a0,800180 <initfd+0x1e>
  80017c:	00951863          	bne	a0,s1,80018c <initfd+0x2a>
  800180:	8522                	mv	a0,s0
  800182:	60e2                	ld	ra,24(sp)
  800184:	6442                	ld	s0,16(sp)
  800186:	64a2                	ld	s1,8(sp)
  800188:	6105                	addi	sp,sp,32
  80018a:	8082                	ret
  80018c:	8526                	mv	a0,s1
  80018e:	f53ff0ef          	jal	ra,8000e0 <close>
  800192:	85a6                	mv	a1,s1
  800194:	8522                	mv	a0,s0
  800196:	f4fff0ef          	jal	ra,8000e4 <dup2>
  80019a:	84aa                	mv	s1,a0
  80019c:	8522                	mv	a0,s0
  80019e:	f43ff0ef          	jal	ra,8000e0 <close>
  8001a2:	8426                	mv	s0,s1
  8001a4:	bff1                	j	800180 <initfd+0x1e>

00000000008001a6 <umain>:
  8001a6:	1101                	addi	sp,sp,-32
  8001a8:	e822                	sd	s0,16(sp)
  8001aa:	e426                	sd	s1,8(sp)
  8001ac:	842a                	mv	s0,a0
  8001ae:	84ae                	mv	s1,a1
  8001b0:	4601                	li	a2,0
  8001b2:	00000597          	auipc	a1,0x0
  8001b6:	54658593          	addi	a1,a1,1350 # 8006f8 <main+0x7c>
  8001ba:	4501                	li	a0,0
  8001bc:	ec06                	sd	ra,24(sp)
  8001be:	fa5ff0ef          	jal	ra,800162 <initfd>
  8001c2:	02054263          	bltz	a0,8001e6 <umain+0x40>
  8001c6:	4605                	li	a2,1
  8001c8:	00000597          	auipc	a1,0x0
  8001cc:	57058593          	addi	a1,a1,1392 # 800738 <main+0xbc>
  8001d0:	4505                	li	a0,1
  8001d2:	f91ff0ef          	jal	ra,800162 <initfd>
  8001d6:	02054563          	bltz	a0,800200 <umain+0x5a>
  8001da:	85a6                	mv	a1,s1
  8001dc:	8522                	mv	a0,s0
  8001de:	49e000ef          	jal	ra,80067c <main>
  8001e2:	038000ef          	jal	ra,80021a <exit>
  8001e6:	86aa                	mv	a3,a0
  8001e8:	00000617          	auipc	a2,0x0
  8001ec:	51860613          	addi	a2,a2,1304 # 800700 <main+0x84>
  8001f0:	45e9                	li	a1,26
  8001f2:	00000517          	auipc	a0,0x0
  8001f6:	52e50513          	addi	a0,a0,1326 # 800720 <main+0xa4>
  8001fa:	e27ff0ef          	jal	ra,800020 <__warn>
  8001fe:	b7e1                	j	8001c6 <umain+0x20>
  800200:	86aa                	mv	a3,a0
  800202:	00000617          	auipc	a2,0x0
  800206:	53e60613          	addi	a2,a2,1342 # 800740 <main+0xc4>
  80020a:	45f5                	li	a1,29
  80020c:	00000517          	auipc	a0,0x0
  800210:	51450513          	addi	a0,a0,1300 # 800720 <main+0xa4>
  800214:	e0dff0ef          	jal	ra,800020 <__warn>
  800218:	b7c9                	j	8001da <umain+0x34>

000000000080021a <exit>:
  80021a:	1141                	addi	sp,sp,-16
  80021c:	e406                	sd	ra,8(sp)
  80021e:	e7dff0ef          	jal	ra,80009a <sys_exit>
  800222:	00000517          	auipc	a0,0x0
  800226:	53e50513          	addi	a0,a0,1342 # 800760 <main+0xe4>
  80022a:	effff0ef          	jal	ra,800128 <cprintf>
  80022e:	a001                	j	80022e <exit+0x14>

0000000000800230 <getpid>:
  800230:	e73ff06f          	j	8000a2 <sys_getpid>

0000000000800234 <strnlen>:
  800234:	c185                	beqz	a1,800254 <strnlen+0x20>
  800236:	00054783          	lbu	a5,0(a0)
  80023a:	cf89                	beqz	a5,800254 <strnlen+0x20>
  80023c:	4781                	li	a5,0
  80023e:	a021                	j	800246 <strnlen+0x12>
  800240:	00074703          	lbu	a4,0(a4)
  800244:	c711                	beqz	a4,800250 <strnlen+0x1c>
  800246:	0785                	addi	a5,a5,1
  800248:	00f50733          	add	a4,a0,a5
  80024c:	fef59ae3          	bne	a1,a5,800240 <strnlen+0xc>
  800250:	853e                	mv	a0,a5
  800252:	8082                	ret
  800254:	4781                	li	a5,0
  800256:	853e                	mv	a0,a5
  800258:	8082                	ret

000000000080025a <printnum>:
  80025a:	02071893          	slli	a7,a4,0x20
  80025e:	7139                	addi	sp,sp,-64
  800260:	0208d893          	srli	a7,a7,0x20
  800264:	e456                	sd	s5,8(sp)
  800266:	0316fab3          	remu	s5,a3,a7
  80026a:	f822                	sd	s0,48(sp)
  80026c:	f426                	sd	s1,40(sp)
  80026e:	f04a                	sd	s2,32(sp)
  800270:	ec4e                	sd	s3,24(sp)
  800272:	fc06                	sd	ra,56(sp)
  800274:	e852                	sd	s4,16(sp)
  800276:	84aa                	mv	s1,a0
  800278:	89ae                	mv	s3,a1
  80027a:	8932                	mv	s2,a2
  80027c:	fff7841b          	addiw	s0,a5,-1
  800280:	2a81                	sext.w	s5,s5
  800282:	0516f163          	bleu	a7,a3,8002c4 <printnum+0x6a>
  800286:	8a42                	mv	s4,a6
  800288:	00805863          	blez	s0,800298 <printnum+0x3e>
  80028c:	347d                	addiw	s0,s0,-1
  80028e:	864e                	mv	a2,s3
  800290:	85ca                	mv	a1,s2
  800292:	8552                	mv	a0,s4
  800294:	9482                	jalr	s1
  800296:	f87d                	bnez	s0,80028c <printnum+0x32>
  800298:	1a82                	slli	s5,s5,0x20
  80029a:	020ada93          	srli	s5,s5,0x20
  80029e:	00000797          	auipc	a5,0x0
  8002a2:	6fa78793          	addi	a5,a5,1786 # 800998 <error_string+0xc8>
  8002a6:	9abe                	add	s5,s5,a5
  8002a8:	7442                	ld	s0,48(sp)
  8002aa:	000ac503          	lbu	a0,0(s5)
  8002ae:	70e2                	ld	ra,56(sp)
  8002b0:	6a42                	ld	s4,16(sp)
  8002b2:	6aa2                	ld	s5,8(sp)
  8002b4:	864e                	mv	a2,s3
  8002b6:	85ca                	mv	a1,s2
  8002b8:	69e2                	ld	s3,24(sp)
  8002ba:	7902                	ld	s2,32(sp)
  8002bc:	8326                	mv	t1,s1
  8002be:	74a2                	ld	s1,40(sp)
  8002c0:	6121                	addi	sp,sp,64
  8002c2:	8302                	jr	t1
  8002c4:	0316d6b3          	divu	a3,a3,a7
  8002c8:	87a2                	mv	a5,s0
  8002ca:	f91ff0ef          	jal	ra,80025a <printnum>
  8002ce:	b7e9                	j	800298 <printnum+0x3e>

00000000008002d0 <vprintfmt>:
  8002d0:	7119                	addi	sp,sp,-128
  8002d2:	f4a6                	sd	s1,104(sp)
  8002d4:	f0ca                	sd	s2,96(sp)
  8002d6:	ecce                	sd	s3,88(sp)
  8002d8:	e4d6                	sd	s5,72(sp)
  8002da:	e0da                	sd	s6,64(sp)
  8002dc:	fc5e                	sd	s7,56(sp)
  8002de:	f862                	sd	s8,48(sp)
  8002e0:	ec6e                	sd	s11,24(sp)
  8002e2:	fc86                	sd	ra,120(sp)
  8002e4:	f8a2                	sd	s0,112(sp)
  8002e6:	e8d2                	sd	s4,80(sp)
  8002e8:	f466                	sd	s9,40(sp)
  8002ea:	f06a                	sd	s10,32(sp)
  8002ec:	89aa                	mv	s3,a0
  8002ee:	892e                	mv	s2,a1
  8002f0:	84b2                	mv	s1,a2
  8002f2:	8db6                	mv	s11,a3
  8002f4:	8b3a                	mv	s6,a4
  8002f6:	5bfd                	li	s7,-1
  8002f8:	00000a97          	auipc	s5,0x0
  8002fc:	47ca8a93          	addi	s5,s5,1148 # 800774 <main+0xf8>
  800300:	05e00c13          	li	s8,94
  800304:	000dc503          	lbu	a0,0(s11)
  800308:	02500793          	li	a5,37
  80030c:	001d8413          	addi	s0,s11,1
  800310:	00f50f63          	beq	a0,a5,80032e <vprintfmt+0x5e>
  800314:	c529                	beqz	a0,80035e <vprintfmt+0x8e>
  800316:	02500a13          	li	s4,37
  80031a:	a011                	j	80031e <vprintfmt+0x4e>
  80031c:	c129                	beqz	a0,80035e <vprintfmt+0x8e>
  80031e:	864a                	mv	a2,s2
  800320:	85a6                	mv	a1,s1
  800322:	0405                	addi	s0,s0,1
  800324:	9982                	jalr	s3
  800326:	fff44503          	lbu	a0,-1(s0)
  80032a:	ff4519e3          	bne	a0,s4,80031c <vprintfmt+0x4c>
  80032e:	00044603          	lbu	a2,0(s0)
  800332:	02000813          	li	a6,32
  800336:	4a01                	li	s4,0
  800338:	4881                	li	a7,0
  80033a:	5d7d                	li	s10,-1
  80033c:	5cfd                	li	s9,-1
  80033e:	05500593          	li	a1,85
  800342:	4525                	li	a0,9
  800344:	fdd6071b          	addiw	a4,a2,-35
  800348:	0ff77713          	andi	a4,a4,255
  80034c:	00140d93          	addi	s11,s0,1
  800350:	22e5e363          	bltu	a1,a4,800576 <vprintfmt+0x2a6>
  800354:	070a                	slli	a4,a4,0x2
  800356:	9756                	add	a4,a4,s5
  800358:	4318                	lw	a4,0(a4)
  80035a:	9756                	add	a4,a4,s5
  80035c:	8702                	jr	a4
  80035e:	70e6                	ld	ra,120(sp)
  800360:	7446                	ld	s0,112(sp)
  800362:	74a6                	ld	s1,104(sp)
  800364:	7906                	ld	s2,96(sp)
  800366:	69e6                	ld	s3,88(sp)
  800368:	6a46                	ld	s4,80(sp)
  80036a:	6aa6                	ld	s5,72(sp)
  80036c:	6b06                	ld	s6,64(sp)
  80036e:	7be2                	ld	s7,56(sp)
  800370:	7c42                	ld	s8,48(sp)
  800372:	7ca2                	ld	s9,40(sp)
  800374:	7d02                	ld	s10,32(sp)
  800376:	6de2                	ld	s11,24(sp)
  800378:	6109                	addi	sp,sp,128
  80037a:	8082                	ret
  80037c:	4705                	li	a4,1
  80037e:	008b0613          	addi	a2,s6,8
  800382:	01174463          	blt	a4,a7,80038a <vprintfmt+0xba>
  800386:	28088563          	beqz	a7,800610 <vprintfmt+0x340>
  80038a:	000b3683          	ld	a3,0(s6)
  80038e:	4741                	li	a4,16
  800390:	8b32                	mv	s6,a2
  800392:	a86d                	j	80044c <vprintfmt+0x17c>
  800394:	00144603          	lbu	a2,1(s0)
  800398:	4a05                	li	s4,1
  80039a:	846e                	mv	s0,s11
  80039c:	b765                	j	800344 <vprintfmt+0x74>
  80039e:	000b2503          	lw	a0,0(s6)
  8003a2:	864a                	mv	a2,s2
  8003a4:	85a6                	mv	a1,s1
  8003a6:	0b21                	addi	s6,s6,8
  8003a8:	9982                	jalr	s3
  8003aa:	bfa9                	j	800304 <vprintfmt+0x34>
  8003ac:	4705                	li	a4,1
  8003ae:	008b0a13          	addi	s4,s6,8
  8003b2:	01174463          	blt	a4,a7,8003ba <vprintfmt+0xea>
  8003b6:	24088563          	beqz	a7,800600 <vprintfmt+0x330>
  8003ba:	000b3403          	ld	s0,0(s6)
  8003be:	26044563          	bltz	s0,800628 <vprintfmt+0x358>
  8003c2:	86a2                	mv	a3,s0
  8003c4:	8b52                	mv	s6,s4
  8003c6:	4729                	li	a4,10
  8003c8:	a051                	j	80044c <vprintfmt+0x17c>
  8003ca:	000b2783          	lw	a5,0(s6)
  8003ce:	46e1                	li	a3,24
  8003d0:	0b21                	addi	s6,s6,8
  8003d2:	41f7d71b          	sraiw	a4,a5,0x1f
  8003d6:	8fb9                	xor	a5,a5,a4
  8003d8:	40e7873b          	subw	a4,a5,a4
  8003dc:	1ce6c163          	blt	a3,a4,80059e <vprintfmt+0x2ce>
  8003e0:	00371793          	slli	a5,a4,0x3
  8003e4:	00000697          	auipc	a3,0x0
  8003e8:	4ec68693          	addi	a3,a3,1260 # 8008d0 <error_string>
  8003ec:	97b6                	add	a5,a5,a3
  8003ee:	639c                	ld	a5,0(a5)
  8003f0:	1a078763          	beqz	a5,80059e <vprintfmt+0x2ce>
  8003f4:	873e                	mv	a4,a5
  8003f6:	00000697          	auipc	a3,0x0
  8003fa:	7aa68693          	addi	a3,a3,1962 # 800ba0 <error_string+0x2d0>
  8003fe:	8626                	mv	a2,s1
  800400:	85ca                	mv	a1,s2
  800402:	854e                	mv	a0,s3
  800404:	25a000ef          	jal	ra,80065e <printfmt>
  800408:	bdf5                	j	800304 <vprintfmt+0x34>
  80040a:	00144603          	lbu	a2,1(s0)
  80040e:	2885                	addiw	a7,a7,1
  800410:	846e                	mv	s0,s11
  800412:	bf0d                	j	800344 <vprintfmt+0x74>
  800414:	4705                	li	a4,1
  800416:	008b0613          	addi	a2,s6,8
  80041a:	01174463          	blt	a4,a7,800422 <vprintfmt+0x152>
  80041e:	1e088e63          	beqz	a7,80061a <vprintfmt+0x34a>
  800422:	000b3683          	ld	a3,0(s6)
  800426:	4721                	li	a4,8
  800428:	8b32                	mv	s6,a2
  80042a:	a00d                	j	80044c <vprintfmt+0x17c>
  80042c:	03000513          	li	a0,48
  800430:	864a                	mv	a2,s2
  800432:	85a6                	mv	a1,s1
  800434:	e042                	sd	a6,0(sp)
  800436:	9982                	jalr	s3
  800438:	864a                	mv	a2,s2
  80043a:	85a6                	mv	a1,s1
  80043c:	07800513          	li	a0,120
  800440:	9982                	jalr	s3
  800442:	0b21                	addi	s6,s6,8
  800444:	ff8b3683          	ld	a3,-8(s6)
  800448:	6802                	ld	a6,0(sp)
  80044a:	4741                	li	a4,16
  80044c:	87e6                	mv	a5,s9
  80044e:	8626                	mv	a2,s1
  800450:	85ca                	mv	a1,s2
  800452:	854e                	mv	a0,s3
  800454:	e07ff0ef          	jal	ra,80025a <printnum>
  800458:	b575                	j	800304 <vprintfmt+0x34>
  80045a:	000b3703          	ld	a4,0(s6)
  80045e:	0b21                	addi	s6,s6,8
  800460:	1e070063          	beqz	a4,800640 <vprintfmt+0x370>
  800464:	00170413          	addi	s0,a4,1
  800468:	19905563          	blez	s9,8005f2 <vprintfmt+0x322>
  80046c:	02d00613          	li	a2,45
  800470:	14c81963          	bne	a6,a2,8005c2 <vprintfmt+0x2f2>
  800474:	00074703          	lbu	a4,0(a4)
  800478:	0007051b          	sext.w	a0,a4
  80047c:	c90d                	beqz	a0,8004ae <vprintfmt+0x1de>
  80047e:	000d4563          	bltz	s10,800488 <vprintfmt+0x1b8>
  800482:	3d7d                	addiw	s10,s10,-1
  800484:	037d0363          	beq	s10,s7,8004aa <vprintfmt+0x1da>
  800488:	864a                	mv	a2,s2
  80048a:	85a6                	mv	a1,s1
  80048c:	180a0c63          	beqz	s4,800624 <vprintfmt+0x354>
  800490:	3701                	addiw	a4,a4,-32
  800492:	18ec7963          	bleu	a4,s8,800624 <vprintfmt+0x354>
  800496:	03f00513          	li	a0,63
  80049a:	9982                	jalr	s3
  80049c:	0405                	addi	s0,s0,1
  80049e:	fff44703          	lbu	a4,-1(s0)
  8004a2:	3cfd                	addiw	s9,s9,-1
  8004a4:	0007051b          	sext.w	a0,a4
  8004a8:	f979                	bnez	a0,80047e <vprintfmt+0x1ae>
  8004aa:	e5905de3          	blez	s9,800304 <vprintfmt+0x34>
  8004ae:	3cfd                	addiw	s9,s9,-1
  8004b0:	864a                	mv	a2,s2
  8004b2:	85a6                	mv	a1,s1
  8004b4:	02000513          	li	a0,32
  8004b8:	9982                	jalr	s3
  8004ba:	e40c85e3          	beqz	s9,800304 <vprintfmt+0x34>
  8004be:	3cfd                	addiw	s9,s9,-1
  8004c0:	864a                	mv	a2,s2
  8004c2:	85a6                	mv	a1,s1
  8004c4:	02000513          	li	a0,32
  8004c8:	9982                	jalr	s3
  8004ca:	fe0c92e3          	bnez	s9,8004ae <vprintfmt+0x1de>
  8004ce:	bd1d                	j	800304 <vprintfmt+0x34>
  8004d0:	4705                	li	a4,1
  8004d2:	008b0613          	addi	a2,s6,8
  8004d6:	01174463          	blt	a4,a7,8004de <vprintfmt+0x20e>
  8004da:	12088663          	beqz	a7,800606 <vprintfmt+0x336>
  8004de:	000b3683          	ld	a3,0(s6)
  8004e2:	4729                	li	a4,10
  8004e4:	8b32                	mv	s6,a2
  8004e6:	b79d                	j	80044c <vprintfmt+0x17c>
  8004e8:	00144603          	lbu	a2,1(s0)
  8004ec:	02d00813          	li	a6,45
  8004f0:	846e                	mv	s0,s11
  8004f2:	bd89                	j	800344 <vprintfmt+0x74>
  8004f4:	864a                	mv	a2,s2
  8004f6:	85a6                	mv	a1,s1
  8004f8:	02500513          	li	a0,37
  8004fc:	9982                	jalr	s3
  8004fe:	b519                	j	800304 <vprintfmt+0x34>
  800500:	000b2d03          	lw	s10,0(s6)
  800504:	00144603          	lbu	a2,1(s0)
  800508:	0b21                	addi	s6,s6,8
  80050a:	846e                	mv	s0,s11
  80050c:	e20cdce3          	bgez	s9,800344 <vprintfmt+0x74>
  800510:	8cea                	mv	s9,s10
  800512:	5d7d                	li	s10,-1
  800514:	bd05                	j	800344 <vprintfmt+0x74>
  800516:	00144603          	lbu	a2,1(s0)
  80051a:	03000813          	li	a6,48
  80051e:	846e                	mv	s0,s11
  800520:	b515                	j	800344 <vprintfmt+0x74>
  800522:	fd060d1b          	addiw	s10,a2,-48
  800526:	00144603          	lbu	a2,1(s0)
  80052a:	846e                	mv	s0,s11
  80052c:	fd06071b          	addiw	a4,a2,-48
  800530:	0006031b          	sext.w	t1,a2
  800534:	fce56ce3          	bltu	a0,a4,80050c <vprintfmt+0x23c>
  800538:	0405                	addi	s0,s0,1
  80053a:	002d171b          	slliw	a4,s10,0x2
  80053e:	00044603          	lbu	a2,0(s0)
  800542:	01a706bb          	addw	a3,a4,s10
  800546:	0016969b          	slliw	a3,a3,0x1
  80054a:	006686bb          	addw	a3,a3,t1
  80054e:	fd06071b          	addiw	a4,a2,-48
  800552:	fd068d1b          	addiw	s10,a3,-48
  800556:	0006031b          	sext.w	t1,a2
  80055a:	fce57fe3          	bleu	a4,a0,800538 <vprintfmt+0x268>
  80055e:	b77d                	j	80050c <vprintfmt+0x23c>
  800560:	fffcc713          	not	a4,s9
  800564:	977d                	srai	a4,a4,0x3f
  800566:	00ecf7b3          	and	a5,s9,a4
  80056a:	00144603          	lbu	a2,1(s0)
  80056e:	00078c9b          	sext.w	s9,a5
  800572:	846e                	mv	s0,s11
  800574:	bbc1                	j	800344 <vprintfmt+0x74>
  800576:	864a                	mv	a2,s2
  800578:	85a6                	mv	a1,s1
  80057a:	02500513          	li	a0,37
  80057e:	9982                	jalr	s3
  800580:	fff44703          	lbu	a4,-1(s0)
  800584:	02500793          	li	a5,37
  800588:	8da2                	mv	s11,s0
  80058a:	d6f70de3          	beq	a4,a5,800304 <vprintfmt+0x34>
  80058e:	02500713          	li	a4,37
  800592:	1dfd                	addi	s11,s11,-1
  800594:	fffdc783          	lbu	a5,-1(s11)
  800598:	fee79de3          	bne	a5,a4,800592 <vprintfmt+0x2c2>
  80059c:	b3a5                	j	800304 <vprintfmt+0x34>
  80059e:	00000697          	auipc	a3,0x0
  8005a2:	5f268693          	addi	a3,a3,1522 # 800b90 <error_string+0x2c0>
  8005a6:	8626                	mv	a2,s1
  8005a8:	85ca                	mv	a1,s2
  8005aa:	854e                	mv	a0,s3
  8005ac:	0b2000ef          	jal	ra,80065e <printfmt>
  8005b0:	bb91                	j	800304 <vprintfmt+0x34>
  8005b2:	00000717          	auipc	a4,0x0
  8005b6:	5d670713          	addi	a4,a4,1494 # 800b88 <error_string+0x2b8>
  8005ba:	00000417          	auipc	s0,0x0
  8005be:	5cf40413          	addi	s0,s0,1487 # 800b89 <error_string+0x2b9>
  8005c2:	853a                	mv	a0,a4
  8005c4:	85ea                	mv	a1,s10
  8005c6:	e03a                	sd	a4,0(sp)
  8005c8:	e442                	sd	a6,8(sp)
  8005ca:	c6bff0ef          	jal	ra,800234 <strnlen>
  8005ce:	40ac8cbb          	subw	s9,s9,a0
  8005d2:	6702                	ld	a4,0(sp)
  8005d4:	01905f63          	blez	s9,8005f2 <vprintfmt+0x322>
  8005d8:	6822                	ld	a6,8(sp)
  8005da:	0008079b          	sext.w	a5,a6
  8005de:	e43e                	sd	a5,8(sp)
  8005e0:	6522                	ld	a0,8(sp)
  8005e2:	864a                	mv	a2,s2
  8005e4:	85a6                	mv	a1,s1
  8005e6:	e03a                	sd	a4,0(sp)
  8005e8:	3cfd                	addiw	s9,s9,-1
  8005ea:	9982                	jalr	s3
  8005ec:	6702                	ld	a4,0(sp)
  8005ee:	fe0c99e3          	bnez	s9,8005e0 <vprintfmt+0x310>
  8005f2:	00074703          	lbu	a4,0(a4)
  8005f6:	0007051b          	sext.w	a0,a4
  8005fa:	e80512e3          	bnez	a0,80047e <vprintfmt+0x1ae>
  8005fe:	b319                	j	800304 <vprintfmt+0x34>
  800600:	000b2403          	lw	s0,0(s6)
  800604:	bb6d                	j	8003be <vprintfmt+0xee>
  800606:	000b6683          	lwu	a3,0(s6)
  80060a:	4729                	li	a4,10
  80060c:	8b32                	mv	s6,a2
  80060e:	bd3d                	j	80044c <vprintfmt+0x17c>
  800610:	000b6683          	lwu	a3,0(s6)
  800614:	4741                	li	a4,16
  800616:	8b32                	mv	s6,a2
  800618:	bd15                	j	80044c <vprintfmt+0x17c>
  80061a:	000b6683          	lwu	a3,0(s6)
  80061e:	4721                	li	a4,8
  800620:	8b32                	mv	s6,a2
  800622:	b52d                	j	80044c <vprintfmt+0x17c>
  800624:	9982                	jalr	s3
  800626:	bd9d                	j	80049c <vprintfmt+0x1cc>
  800628:	864a                	mv	a2,s2
  80062a:	85a6                	mv	a1,s1
  80062c:	02d00513          	li	a0,45
  800630:	e042                	sd	a6,0(sp)
  800632:	9982                	jalr	s3
  800634:	8b52                	mv	s6,s4
  800636:	408006b3          	neg	a3,s0
  80063a:	4729                	li	a4,10
  80063c:	6802                	ld	a6,0(sp)
  80063e:	b539                	j	80044c <vprintfmt+0x17c>
  800640:	01905663          	blez	s9,80064c <vprintfmt+0x37c>
  800644:	02d00713          	li	a4,45
  800648:	f6e815e3          	bne	a6,a4,8005b2 <vprintfmt+0x2e2>
  80064c:	00000417          	auipc	s0,0x0
  800650:	53d40413          	addi	s0,s0,1341 # 800b89 <error_string+0x2b9>
  800654:	02800513          	li	a0,40
  800658:	02800713          	li	a4,40
  80065c:	b50d                	j	80047e <vprintfmt+0x1ae>

000000000080065e <printfmt>:
  80065e:	7139                	addi	sp,sp,-64
  800660:	02010313          	addi	t1,sp,32
  800664:	f03a                	sd	a4,32(sp)
  800666:	871a                	mv	a4,t1
  800668:	ec06                	sd	ra,24(sp)
  80066a:	f43e                	sd	a5,40(sp)
  80066c:	f842                	sd	a6,48(sp)
  80066e:	fc46                	sd	a7,56(sp)
  800670:	e41a                	sd	t1,8(sp)
  800672:	c5fff0ef          	jal	ra,8002d0 <vprintfmt>
  800676:	60e2                	ld	ra,24(sp)
  800678:	6121                	addi	sp,sp,64
  80067a:	8082                	ret

000000000080067c <main>:
  80067c:	1141                	addi	sp,sp,-16
  80067e:	00000517          	auipc	a0,0x0
  800682:	52a50513          	addi	a0,a0,1322 # 800ba8 <error_string+0x2d8>
  800686:	e406                	sd	ra,8(sp)
  800688:	aa1ff0ef          	jal	ra,800128 <cprintf>
  80068c:	ba5ff0ef          	jal	ra,800230 <getpid>
  800690:	85aa                	mv	a1,a0
  800692:	00000517          	auipc	a0,0x0
  800696:	52650513          	addi	a0,a0,1318 # 800bb8 <error_string+0x2e8>
  80069a:	a8fff0ef          	jal	ra,800128 <cprintf>
  80069e:	00000517          	auipc	a0,0x0
  8006a2:	53250513          	addi	a0,a0,1330 # 800bd0 <error_string+0x300>
  8006a6:	a83ff0ef          	jal	ra,800128 <cprintf>
  8006aa:	60a2                	ld	ra,8(sp)
  8006ac:	4501                	li	a0,0
  8006ae:	0141                	addi	sp,sp,16
  8006b0:	8082                	ret
