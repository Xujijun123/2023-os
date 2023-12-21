
obj/__user_sh.out：     文件格式 elf64-littleriscv


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
  800032:	d6250513          	addi	a0,a0,-670 # 800d90 <main+0xca>
  800036:	ec06                	sd	ra,24(sp)
  800038:	f436                	sd	a3,40(sp)
  80003a:	f83a                	sd	a4,48(sp)
  80003c:	e0c2                	sd	a6,64(sp)
  80003e:	e4c6                	sd	a7,72(sp)
  800040:	e43e                	sd	a5,8(sp)
  800042:	188000ef          	jal	ra,8001ca <cprintf>
  800046:	65a2                	ld	a1,8(sp)
  800048:	8522                	mv	a0,s0
  80004a:	15a000ef          	jal	ra,8001a4 <vcprintf>
  80004e:	00001517          	auipc	a0,0x1
  800052:	da250513          	addi	a0,a0,-606 # 800df0 <main+0x12a>
  800056:	174000ef          	jal	ra,8001ca <cprintf>
  80005a:	5559                	li	a0,-10
  80005c:	2d4000ef          	jal	ra,800330 <exit>

0000000000800060 <__warn>:
  800060:	715d                	addi	sp,sp,-80
  800062:	e822                	sd	s0,16(sp)
  800064:	fc3e                	sd	a5,56(sp)
  800066:	8432                	mv	s0,a2
  800068:	103c                	addi	a5,sp,40
  80006a:	862e                	mv	a2,a1
  80006c:	85aa                	mv	a1,a0
  80006e:	00001517          	auipc	a0,0x1
  800072:	d4250513          	addi	a0,a0,-702 # 800db0 <main+0xea>
  800076:	ec06                	sd	ra,24(sp)
  800078:	f436                	sd	a3,40(sp)
  80007a:	f83a                	sd	a4,48(sp)
  80007c:	e0c2                	sd	a6,64(sp)
  80007e:	e4c6                	sd	a7,72(sp)
  800080:	e43e                	sd	a5,8(sp)
  800082:	148000ef          	jal	ra,8001ca <cprintf>
  800086:	65a2                	ld	a1,8(sp)
  800088:	8522                	mv	a0,s0
  80008a:	11a000ef          	jal	ra,8001a4 <vcprintf>
  80008e:	00001517          	auipc	a0,0x1
  800092:	d6250513          	addi	a0,a0,-670 # 800df0 <main+0x12a>
  800096:	134000ef          	jal	ra,8001ca <cprintf>
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

00000000008000fa <sys_exec>:
  8000fa:	86b2                	mv	a3,a2
  8000fc:	862e                	mv	a2,a1
  8000fe:	85aa                	mv	a1,a0
  800100:	4511                	li	a0,4
  800102:	fa1ff06f          	j	8000a2 <syscall>

0000000000800106 <sys_open>:
  800106:	862e                	mv	a2,a1
  800108:	85aa                	mv	a1,a0
  80010a:	06400513          	li	a0,100
  80010e:	f95ff06f          	j	8000a2 <syscall>

0000000000800112 <sys_close>:
  800112:	85aa                	mv	a1,a0
  800114:	06500513          	li	a0,101
  800118:	f8bff06f          	j	8000a2 <syscall>

000000000080011c <sys_read>:
  80011c:	86b2                	mv	a3,a2
  80011e:	862e                	mv	a2,a1
  800120:	85aa                	mv	a1,a0
  800122:	06600513          	li	a0,102
  800126:	f7dff06f          	j	8000a2 <syscall>

000000000080012a <sys_write>:
  80012a:	86b2                	mv	a3,a2
  80012c:	862e                	mv	a2,a1
  80012e:	85aa                	mv	a1,a0
  800130:	06700513          	li	a0,103
  800134:	f6fff06f          	j	8000a2 <syscall>

0000000000800138 <sys_dup>:
  800138:	862e                	mv	a2,a1
  80013a:	85aa                	mv	a1,a0
  80013c:	08200513          	li	a0,130
  800140:	f63ff06f          	j	8000a2 <syscall>

0000000000800144 <_start>:
  800144:	178000ef          	jal	ra,8002bc <umain>
  800148:	a001                	j	800148 <_start+0x4>

000000000080014a <open>:
  80014a:	1582                	slli	a1,a1,0x20
  80014c:	9181                	srli	a1,a1,0x20
  80014e:	fb9ff06f          	j	800106 <sys_open>

0000000000800152 <close>:
  800152:	fc1ff06f          	j	800112 <sys_close>

0000000000800156 <read>:
  800156:	fc7ff06f          	j	80011c <sys_read>

000000000080015a <write>:
  80015a:	fd1ff06f          	j	80012a <sys_write>

000000000080015e <dup2>:
  80015e:	fdbff06f          	j	800138 <sys_dup>

0000000000800162 <cputch>:
  800162:	1141                	addi	sp,sp,-16
  800164:	e022                	sd	s0,0(sp)
  800166:	e406                	sd	ra,8(sp)
  800168:	842e                	mv	s0,a1
  80016a:	f89ff0ef          	jal	ra,8000f2 <sys_putc>
  80016e:	401c                	lw	a5,0(s0)
  800170:	60a2                	ld	ra,8(sp)
  800172:	2785                	addiw	a5,a5,1
  800174:	c01c                	sw	a5,0(s0)
  800176:	6402                	ld	s0,0(sp)
  800178:	0141                	addi	sp,sp,16
  80017a:	8082                	ret

000000000080017c <fputch>:
  80017c:	1101                	addi	sp,sp,-32
  80017e:	87b2                	mv	a5,a2
  800180:	e822                	sd	s0,16(sp)
  800182:	00a107a3          	sb	a0,15(sp)
  800186:	842e                	mv	s0,a1
  800188:	853e                	mv	a0,a5
  80018a:	00f10593          	addi	a1,sp,15
  80018e:	4605                	li	a2,1
  800190:	ec06                	sd	ra,24(sp)
  800192:	fc9ff0ef          	jal	ra,80015a <write>
  800196:	401c                	lw	a5,0(s0)
  800198:	60e2                	ld	ra,24(sp)
  80019a:	2785                	addiw	a5,a5,1
  80019c:	c01c                	sw	a5,0(s0)
  80019e:	6442                	ld	s0,16(sp)
  8001a0:	6105                	addi	sp,sp,32
  8001a2:	8082                	ret

00000000008001a4 <vcprintf>:
  8001a4:	1101                	addi	sp,sp,-32
  8001a6:	872e                	mv	a4,a1
  8001a8:	75dd                	lui	a1,0xffff7
  8001aa:	86aa                	mv	a3,a0
  8001ac:	0070                	addi	a2,sp,12
  8001ae:	00000517          	auipc	a0,0x0
  8001b2:	fb450513          	addi	a0,a0,-76 # 800162 <cputch>
  8001b6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <buffer.1212+0xffffffffff7f29d1>
  8001ba:	ec06                	sd	ra,24(sp)
  8001bc:	c602                	sw	zero,12(sp)
  8001be:	2c2000ef          	jal	ra,800480 <vprintfmt>
  8001c2:	60e2                	ld	ra,24(sp)
  8001c4:	4532                	lw	a0,12(sp)
  8001c6:	6105                	addi	sp,sp,32
  8001c8:	8082                	ret

00000000008001ca <cprintf>:
  8001ca:	711d                	addi	sp,sp,-96
  8001cc:	02810313          	addi	t1,sp,40
  8001d0:	f42e                	sd	a1,40(sp)
  8001d2:	75dd                	lui	a1,0xffff7
  8001d4:	f832                	sd	a2,48(sp)
  8001d6:	fc36                	sd	a3,56(sp)
  8001d8:	e0ba                	sd	a4,64(sp)
  8001da:	86aa                	mv	a3,a0
  8001dc:	0050                	addi	a2,sp,4
  8001de:	00000517          	auipc	a0,0x0
  8001e2:	f8450513          	addi	a0,a0,-124 # 800162 <cputch>
  8001e6:	871a                	mv	a4,t1
  8001e8:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <buffer.1212+0xffffffffff7f29d1>
  8001ec:	ec06                	sd	ra,24(sp)
  8001ee:	e4be                	sd	a5,72(sp)
  8001f0:	e8c2                	sd	a6,80(sp)
  8001f2:	ecc6                	sd	a7,88(sp)
  8001f4:	e41a                	sd	t1,8(sp)
  8001f6:	c202                	sw	zero,4(sp)
  8001f8:	288000ef          	jal	ra,800480 <vprintfmt>
  8001fc:	60e2                	ld	ra,24(sp)
  8001fe:	4512                	lw	a0,4(sp)
  800200:	6125                	addi	sp,sp,96
  800202:	8082                	ret

0000000000800204 <cputs>:
  800204:	1101                	addi	sp,sp,-32
  800206:	e822                	sd	s0,16(sp)
  800208:	ec06                	sd	ra,24(sp)
  80020a:	e426                	sd	s1,8(sp)
  80020c:	842a                	mv	s0,a0
  80020e:	00054503          	lbu	a0,0(a0)
  800212:	c51d                	beqz	a0,800240 <cputs+0x3c>
  800214:	0405                	addi	s0,s0,1
  800216:	4485                	li	s1,1
  800218:	9c81                	subw	s1,s1,s0
  80021a:	ed9ff0ef          	jal	ra,8000f2 <sys_putc>
  80021e:	008487bb          	addw	a5,s1,s0
  800222:	0405                	addi	s0,s0,1
  800224:	fff44503          	lbu	a0,-1(s0)
  800228:	f96d                	bnez	a0,80021a <cputs+0x16>
  80022a:	0017841b          	addiw	s0,a5,1
  80022e:	4529                	li	a0,10
  800230:	ec3ff0ef          	jal	ra,8000f2 <sys_putc>
  800234:	8522                	mv	a0,s0
  800236:	60e2                	ld	ra,24(sp)
  800238:	6442                	ld	s0,16(sp)
  80023a:	64a2                	ld	s1,8(sp)
  80023c:	6105                	addi	sp,sp,32
  80023e:	8082                	ret
  800240:	4405                	li	s0,1
  800242:	b7f5                	j	80022e <cputs+0x2a>

0000000000800244 <fprintf>:
  800244:	715d                	addi	sp,sp,-80
  800246:	02010313          	addi	t1,sp,32
  80024a:	f032                	sd	a2,32(sp)
  80024c:	f436                	sd	a3,40(sp)
  80024e:	f83a                	sd	a4,48(sp)
  800250:	86ae                	mv	a3,a1
  800252:	0050                	addi	a2,sp,4
  800254:	85aa                	mv	a1,a0
  800256:	871a                	mv	a4,t1
  800258:	00000517          	auipc	a0,0x0
  80025c:	f2450513          	addi	a0,a0,-220 # 80017c <fputch>
  800260:	ec06                	sd	ra,24(sp)
  800262:	fc3e                	sd	a5,56(sp)
  800264:	e0c2                	sd	a6,64(sp)
  800266:	e4c6                	sd	a7,72(sp)
  800268:	e41a                	sd	t1,8(sp)
  80026a:	c202                	sw	zero,4(sp)
  80026c:	214000ef          	jal	ra,800480 <vprintfmt>
  800270:	60e2                	ld	ra,24(sp)
  800272:	4512                	lw	a0,4(sp)
  800274:	6161                	addi	sp,sp,80
  800276:	8082                	ret

0000000000800278 <initfd>:
  800278:	1101                	addi	sp,sp,-32
  80027a:	87ae                	mv	a5,a1
  80027c:	e426                	sd	s1,8(sp)
  80027e:	85b2                	mv	a1,a2
  800280:	84aa                	mv	s1,a0
  800282:	853e                	mv	a0,a5
  800284:	e822                	sd	s0,16(sp)
  800286:	ec06                	sd	ra,24(sp)
  800288:	ec3ff0ef          	jal	ra,80014a <open>
  80028c:	842a                	mv	s0,a0
  80028e:	00054463          	bltz	a0,800296 <initfd+0x1e>
  800292:	00951863          	bne	a0,s1,8002a2 <initfd+0x2a>
  800296:	8522                	mv	a0,s0
  800298:	60e2                	ld	ra,24(sp)
  80029a:	6442                	ld	s0,16(sp)
  80029c:	64a2                	ld	s1,8(sp)
  80029e:	6105                	addi	sp,sp,32
  8002a0:	8082                	ret
  8002a2:	8526                	mv	a0,s1
  8002a4:	eafff0ef          	jal	ra,800152 <close>
  8002a8:	85a6                	mv	a1,s1
  8002aa:	8522                	mv	a0,s0
  8002ac:	eb3ff0ef          	jal	ra,80015e <dup2>
  8002b0:	84aa                	mv	s1,a0
  8002b2:	8522                	mv	a0,s0
  8002b4:	e9fff0ef          	jal	ra,800152 <close>
  8002b8:	8426                	mv	s0,s1
  8002ba:	bff1                	j	800296 <initfd+0x1e>

00000000008002bc <umain>:
  8002bc:	1101                	addi	sp,sp,-32
  8002be:	e822                	sd	s0,16(sp)
  8002c0:	e426                	sd	s1,8(sp)
  8002c2:	842a                	mv	s0,a0
  8002c4:	84ae                	mv	s1,a1
  8002c6:	4601                	li	a2,0
  8002c8:	00001597          	auipc	a1,0x1
  8002cc:	b0858593          	addi	a1,a1,-1272 # 800dd0 <main+0x10a>
  8002d0:	4501                	li	a0,0
  8002d2:	ec06                	sd	ra,24(sp)
  8002d4:	fa5ff0ef          	jal	ra,800278 <initfd>
  8002d8:	02054263          	bltz	a0,8002fc <umain+0x40>
  8002dc:	4605                	li	a2,1
  8002de:	00001597          	auipc	a1,0x1
  8002e2:	b3258593          	addi	a1,a1,-1230 # 800e10 <main+0x14a>
  8002e6:	4505                	li	a0,1
  8002e8:	f91ff0ef          	jal	ra,800278 <initfd>
  8002ec:	02054563          	bltz	a0,800316 <umain+0x5a>
  8002f0:	85a6                	mv	a1,s1
  8002f2:	8522                	mv	a0,s0
  8002f4:	1d3000ef          	jal	ra,800cc6 <main>
  8002f8:	038000ef          	jal	ra,800330 <exit>
  8002fc:	86aa                	mv	a3,a0
  8002fe:	00001617          	auipc	a2,0x1
  800302:	ada60613          	addi	a2,a2,-1318 # 800dd8 <main+0x112>
  800306:	45e9                	li	a1,26
  800308:	00001517          	auipc	a0,0x1
  80030c:	af050513          	addi	a0,a0,-1296 # 800df8 <main+0x132>
  800310:	d51ff0ef          	jal	ra,800060 <__warn>
  800314:	b7e1                	j	8002dc <umain+0x20>
  800316:	86aa                	mv	a3,a0
  800318:	00001617          	auipc	a2,0x1
  80031c:	b0060613          	addi	a2,a2,-1280 # 800e18 <main+0x152>
  800320:	45f5                	li	a1,29
  800322:	00001517          	auipc	a0,0x1
  800326:	ad650513          	addi	a0,a0,-1322 # 800df8 <main+0x132>
  80032a:	d37ff0ef          	jal	ra,800060 <__warn>
  80032e:	b7c9                	j	8002f0 <umain+0x34>

0000000000800330 <exit>:
  800330:	1141                	addi	sp,sp,-16
  800332:	e406                	sd	ra,8(sp)
  800334:	da7ff0ef          	jal	ra,8000da <sys_exit>
  800338:	00001517          	auipc	a0,0x1
  80033c:	b0050513          	addi	a0,a0,-1280 # 800e38 <main+0x172>
  800340:	e8bff0ef          	jal	ra,8001ca <cprintf>
  800344:	a001                	j	800344 <exit+0x14>

0000000000800346 <fork>:
  800346:	d9dff06f          	j	8000e2 <sys_fork>

000000000080034a <waitpid>:
  80034a:	d9fff06f          	j	8000e8 <sys_wait>

000000000080034e <__exec>:
  80034e:	619c                	ld	a5,0(a1)
  800350:	862e                	mv	a2,a1
  800352:	cf81                	beqz	a5,80036a <__exec+0x1c>
  800354:	00858793          	addi	a5,a1,8
  800358:	4701                	li	a4,0
  80035a:	07a1                	addi	a5,a5,8
  80035c:	ff87b683          	ld	a3,-8(a5)
  800360:	2705                	addiw	a4,a4,1
  800362:	fee5                	bnez	a3,80035a <__exec+0xc>
  800364:	85ba                	mv	a1,a4
  800366:	d95ff06f          	j	8000fa <sys_exec>
  80036a:	4581                	li	a1,0
  80036c:	d8fff06f          	j	8000fa <sys_exec>

0000000000800370 <strnlen>:
  800370:	c185                	beqz	a1,800390 <strnlen+0x20>
  800372:	00054783          	lbu	a5,0(a0)
  800376:	cf89                	beqz	a5,800390 <strnlen+0x20>
  800378:	4781                	li	a5,0
  80037a:	a021                	j	800382 <strnlen+0x12>
  80037c:	00074703          	lbu	a4,0(a4)
  800380:	c711                	beqz	a4,80038c <strnlen+0x1c>
  800382:	0785                	addi	a5,a5,1
  800384:	00f50733          	add	a4,a0,a5
  800388:	fef59ae3          	bne	a1,a5,80037c <strnlen+0xc>
  80038c:	853e                	mv	a0,a5
  80038e:	8082                	ret
  800390:	4781                	li	a5,0
  800392:	853e                	mv	a0,a5
  800394:	8082                	ret

0000000000800396 <strcpy>:
  800396:	87aa                	mv	a5,a0
  800398:	0585                	addi	a1,a1,1
  80039a:	fff5c703          	lbu	a4,-1(a1)
  80039e:	0785                	addi	a5,a5,1
  8003a0:	fee78fa3          	sb	a4,-1(a5)
  8003a4:	fb75                	bnez	a4,800398 <strcpy+0x2>
  8003a6:	8082                	ret

00000000008003a8 <strcmp>:
  8003a8:	00054783          	lbu	a5,0(a0)
  8003ac:	0005c703          	lbu	a4,0(a1)
  8003b0:	cb91                	beqz	a5,8003c4 <strcmp+0x1c>
  8003b2:	00e79c63          	bne	a5,a4,8003ca <strcmp+0x22>
  8003b6:	0505                	addi	a0,a0,1
  8003b8:	00054783          	lbu	a5,0(a0)
  8003bc:	0585                	addi	a1,a1,1
  8003be:	0005c703          	lbu	a4,0(a1)
  8003c2:	fbe5                	bnez	a5,8003b2 <strcmp+0xa>
  8003c4:	4501                	li	a0,0
  8003c6:	9d19                	subw	a0,a0,a4
  8003c8:	8082                	ret
  8003ca:	0007851b          	sext.w	a0,a5
  8003ce:	9d19                	subw	a0,a0,a4
  8003d0:	8082                	ret

00000000008003d2 <strchr>:
  8003d2:	00054783          	lbu	a5,0(a0)
  8003d6:	cb91                	beqz	a5,8003ea <strchr+0x18>
  8003d8:	00b79563          	bne	a5,a1,8003e2 <strchr+0x10>
  8003dc:	a809                	j	8003ee <strchr+0x1c>
  8003de:	00b78763          	beq	a5,a1,8003ec <strchr+0x1a>
  8003e2:	0505                	addi	a0,a0,1
  8003e4:	00054783          	lbu	a5,0(a0)
  8003e8:	fbfd                	bnez	a5,8003de <strchr+0xc>
  8003ea:	4501                	li	a0,0
  8003ec:	8082                	ret
  8003ee:	8082                	ret

00000000008003f0 <printnum>:
  8003f0:	02071893          	slli	a7,a4,0x20
  8003f4:	7139                	addi	sp,sp,-64
  8003f6:	0208d893          	srli	a7,a7,0x20
  8003fa:	e456                	sd	s5,8(sp)
  8003fc:	0316fab3          	remu	s5,a3,a7
  800400:	f822                	sd	s0,48(sp)
  800402:	f426                	sd	s1,40(sp)
  800404:	f04a                	sd	s2,32(sp)
  800406:	ec4e                	sd	s3,24(sp)
  800408:	fc06                	sd	ra,56(sp)
  80040a:	e852                	sd	s4,16(sp)
  80040c:	84aa                	mv	s1,a0
  80040e:	89ae                	mv	s3,a1
  800410:	8932                	mv	s2,a2
  800412:	fff7841b          	addiw	s0,a5,-1
  800416:	2a81                	sext.w	s5,s5
  800418:	0516f163          	bleu	a7,a3,80045a <printnum+0x6a>
  80041c:	8a42                	mv	s4,a6
  80041e:	00805863          	blez	s0,80042e <printnum+0x3e>
  800422:	347d                	addiw	s0,s0,-1
  800424:	864e                	mv	a2,s3
  800426:	85ca                	mv	a1,s2
  800428:	8552                	mv	a0,s4
  80042a:	9482                	jalr	s1
  80042c:	f87d                	bnez	s0,800422 <printnum+0x32>
  80042e:	1a82                	slli	s5,s5,0x20
  800430:	020ada93          	srli	s5,s5,0x20
  800434:	00001797          	auipc	a5,0x1
  800438:	c3c78793          	addi	a5,a5,-964 # 801070 <error_string+0xc8>
  80043c:	9abe                	add	s5,s5,a5
  80043e:	7442                	ld	s0,48(sp)
  800440:	000ac503          	lbu	a0,0(s5)
  800444:	70e2                	ld	ra,56(sp)
  800446:	6a42                	ld	s4,16(sp)
  800448:	6aa2                	ld	s5,8(sp)
  80044a:	864e                	mv	a2,s3
  80044c:	85ca                	mv	a1,s2
  80044e:	69e2                	ld	s3,24(sp)
  800450:	7902                	ld	s2,32(sp)
  800452:	8326                	mv	t1,s1
  800454:	74a2                	ld	s1,40(sp)
  800456:	6121                	addi	sp,sp,64
  800458:	8302                	jr	t1
  80045a:	0316d6b3          	divu	a3,a3,a7
  80045e:	87a2                	mv	a5,s0
  800460:	f91ff0ef          	jal	ra,8003f0 <printnum>
  800464:	b7e9                	j	80042e <printnum+0x3e>

0000000000800466 <sprintputch>:
  800466:	499c                	lw	a5,16(a1)
  800468:	6198                	ld	a4,0(a1)
  80046a:	6594                	ld	a3,8(a1)
  80046c:	2785                	addiw	a5,a5,1
  80046e:	c99c                	sw	a5,16(a1)
  800470:	00d77763          	bleu	a3,a4,80047e <sprintputch+0x18>
  800474:	00170793          	addi	a5,a4,1
  800478:	e19c                	sd	a5,0(a1)
  80047a:	00a70023          	sb	a0,0(a4)
  80047e:	8082                	ret

0000000000800480 <vprintfmt>:
  800480:	7119                	addi	sp,sp,-128
  800482:	f4a6                	sd	s1,104(sp)
  800484:	f0ca                	sd	s2,96(sp)
  800486:	ecce                	sd	s3,88(sp)
  800488:	e4d6                	sd	s5,72(sp)
  80048a:	e0da                	sd	s6,64(sp)
  80048c:	fc5e                	sd	s7,56(sp)
  80048e:	f862                	sd	s8,48(sp)
  800490:	ec6e                	sd	s11,24(sp)
  800492:	fc86                	sd	ra,120(sp)
  800494:	f8a2                	sd	s0,112(sp)
  800496:	e8d2                	sd	s4,80(sp)
  800498:	f466                	sd	s9,40(sp)
  80049a:	f06a                	sd	s10,32(sp)
  80049c:	89aa                	mv	s3,a0
  80049e:	892e                	mv	s2,a1
  8004a0:	84b2                	mv	s1,a2
  8004a2:	8db6                	mv	s11,a3
  8004a4:	8b3a                	mv	s6,a4
  8004a6:	5bfd                	li	s7,-1
  8004a8:	00001a97          	auipc	s5,0x1
  8004ac:	9a4a8a93          	addi	s5,s5,-1628 # 800e4c <main+0x186>
  8004b0:	05e00c13          	li	s8,94
  8004b4:	000dc503          	lbu	a0,0(s11)
  8004b8:	02500793          	li	a5,37
  8004bc:	001d8413          	addi	s0,s11,1
  8004c0:	00f50f63          	beq	a0,a5,8004de <vprintfmt+0x5e>
  8004c4:	c529                	beqz	a0,80050e <vprintfmt+0x8e>
  8004c6:	02500a13          	li	s4,37
  8004ca:	a011                	j	8004ce <vprintfmt+0x4e>
  8004cc:	c129                	beqz	a0,80050e <vprintfmt+0x8e>
  8004ce:	864a                	mv	a2,s2
  8004d0:	85a6                	mv	a1,s1
  8004d2:	0405                	addi	s0,s0,1
  8004d4:	9982                	jalr	s3
  8004d6:	fff44503          	lbu	a0,-1(s0)
  8004da:	ff4519e3          	bne	a0,s4,8004cc <vprintfmt+0x4c>
  8004de:	00044603          	lbu	a2,0(s0)
  8004e2:	02000813          	li	a6,32
  8004e6:	4a01                	li	s4,0
  8004e8:	4881                	li	a7,0
  8004ea:	5d7d                	li	s10,-1
  8004ec:	5cfd                	li	s9,-1
  8004ee:	05500593          	li	a1,85
  8004f2:	4525                	li	a0,9
  8004f4:	fdd6071b          	addiw	a4,a2,-35
  8004f8:	0ff77713          	andi	a4,a4,255
  8004fc:	00140d93          	addi	s11,s0,1
  800500:	22e5e363          	bltu	a1,a4,800726 <vprintfmt+0x2a6>
  800504:	070a                	slli	a4,a4,0x2
  800506:	9756                	add	a4,a4,s5
  800508:	4318                	lw	a4,0(a4)
  80050a:	9756                	add	a4,a4,s5
  80050c:	8702                	jr	a4
  80050e:	70e6                	ld	ra,120(sp)
  800510:	7446                	ld	s0,112(sp)
  800512:	74a6                	ld	s1,104(sp)
  800514:	7906                	ld	s2,96(sp)
  800516:	69e6                	ld	s3,88(sp)
  800518:	6a46                	ld	s4,80(sp)
  80051a:	6aa6                	ld	s5,72(sp)
  80051c:	6b06                	ld	s6,64(sp)
  80051e:	7be2                	ld	s7,56(sp)
  800520:	7c42                	ld	s8,48(sp)
  800522:	7ca2                	ld	s9,40(sp)
  800524:	7d02                	ld	s10,32(sp)
  800526:	6de2                	ld	s11,24(sp)
  800528:	6109                	addi	sp,sp,128
  80052a:	8082                	ret
  80052c:	4705                	li	a4,1
  80052e:	008b0613          	addi	a2,s6,8
  800532:	01174463          	blt	a4,a7,80053a <vprintfmt+0xba>
  800536:	28088563          	beqz	a7,8007c0 <vprintfmt+0x340>
  80053a:	000b3683          	ld	a3,0(s6)
  80053e:	4741                	li	a4,16
  800540:	8b32                	mv	s6,a2
  800542:	a86d                	j	8005fc <vprintfmt+0x17c>
  800544:	00144603          	lbu	a2,1(s0)
  800548:	4a05                	li	s4,1
  80054a:	846e                	mv	s0,s11
  80054c:	b765                	j	8004f4 <vprintfmt+0x74>
  80054e:	000b2503          	lw	a0,0(s6)
  800552:	864a                	mv	a2,s2
  800554:	85a6                	mv	a1,s1
  800556:	0b21                	addi	s6,s6,8
  800558:	9982                	jalr	s3
  80055a:	bfa9                	j	8004b4 <vprintfmt+0x34>
  80055c:	4705                	li	a4,1
  80055e:	008b0a13          	addi	s4,s6,8
  800562:	01174463          	blt	a4,a7,80056a <vprintfmt+0xea>
  800566:	24088563          	beqz	a7,8007b0 <vprintfmt+0x330>
  80056a:	000b3403          	ld	s0,0(s6)
  80056e:	26044563          	bltz	s0,8007d8 <vprintfmt+0x358>
  800572:	86a2                	mv	a3,s0
  800574:	8b52                	mv	s6,s4
  800576:	4729                	li	a4,10
  800578:	a051                	j	8005fc <vprintfmt+0x17c>
  80057a:	000b2783          	lw	a5,0(s6)
  80057e:	46e1                	li	a3,24
  800580:	0b21                	addi	s6,s6,8
  800582:	41f7d71b          	sraiw	a4,a5,0x1f
  800586:	8fb9                	xor	a5,a5,a4
  800588:	40e7873b          	subw	a4,a5,a4
  80058c:	1ce6c163          	blt	a3,a4,80074e <vprintfmt+0x2ce>
  800590:	00371793          	slli	a5,a4,0x3
  800594:	00001697          	auipc	a3,0x1
  800598:	a1468693          	addi	a3,a3,-1516 # 800fa8 <error_string>
  80059c:	97b6                	add	a5,a5,a3
  80059e:	639c                	ld	a5,0(a5)
  8005a0:	1a078763          	beqz	a5,80074e <vprintfmt+0x2ce>
  8005a4:	873e                	mv	a4,a5
  8005a6:	00001697          	auipc	a3,0x1
  8005aa:	cd268693          	addi	a3,a3,-814 # 801278 <error_string+0x2d0>
  8005ae:	8626                	mv	a2,s1
  8005b0:	85ca                	mv	a1,s2
  8005b2:	854e                	mv	a0,s3
  8005b4:	25a000ef          	jal	ra,80080e <printfmt>
  8005b8:	bdf5                	j	8004b4 <vprintfmt+0x34>
  8005ba:	00144603          	lbu	a2,1(s0)
  8005be:	2885                	addiw	a7,a7,1
  8005c0:	846e                	mv	s0,s11
  8005c2:	bf0d                	j	8004f4 <vprintfmt+0x74>
  8005c4:	4705                	li	a4,1
  8005c6:	008b0613          	addi	a2,s6,8
  8005ca:	01174463          	blt	a4,a7,8005d2 <vprintfmt+0x152>
  8005ce:	1e088e63          	beqz	a7,8007ca <vprintfmt+0x34a>
  8005d2:	000b3683          	ld	a3,0(s6)
  8005d6:	4721                	li	a4,8
  8005d8:	8b32                	mv	s6,a2
  8005da:	a00d                	j	8005fc <vprintfmt+0x17c>
  8005dc:	03000513          	li	a0,48
  8005e0:	864a                	mv	a2,s2
  8005e2:	85a6                	mv	a1,s1
  8005e4:	e042                	sd	a6,0(sp)
  8005e6:	9982                	jalr	s3
  8005e8:	864a                	mv	a2,s2
  8005ea:	85a6                	mv	a1,s1
  8005ec:	07800513          	li	a0,120
  8005f0:	9982                	jalr	s3
  8005f2:	0b21                	addi	s6,s6,8
  8005f4:	ff8b3683          	ld	a3,-8(s6)
  8005f8:	6802                	ld	a6,0(sp)
  8005fa:	4741                	li	a4,16
  8005fc:	87e6                	mv	a5,s9
  8005fe:	8626                	mv	a2,s1
  800600:	85ca                	mv	a1,s2
  800602:	854e                	mv	a0,s3
  800604:	dedff0ef          	jal	ra,8003f0 <printnum>
  800608:	b575                	j	8004b4 <vprintfmt+0x34>
  80060a:	000b3703          	ld	a4,0(s6)
  80060e:	0b21                	addi	s6,s6,8
  800610:	1e070063          	beqz	a4,8007f0 <vprintfmt+0x370>
  800614:	00170413          	addi	s0,a4,1
  800618:	19905563          	blez	s9,8007a2 <vprintfmt+0x322>
  80061c:	02d00613          	li	a2,45
  800620:	14c81963          	bne	a6,a2,800772 <vprintfmt+0x2f2>
  800624:	00074703          	lbu	a4,0(a4)
  800628:	0007051b          	sext.w	a0,a4
  80062c:	c90d                	beqz	a0,80065e <vprintfmt+0x1de>
  80062e:	000d4563          	bltz	s10,800638 <vprintfmt+0x1b8>
  800632:	3d7d                	addiw	s10,s10,-1
  800634:	037d0363          	beq	s10,s7,80065a <vprintfmt+0x1da>
  800638:	864a                	mv	a2,s2
  80063a:	85a6                	mv	a1,s1
  80063c:	180a0c63          	beqz	s4,8007d4 <vprintfmt+0x354>
  800640:	3701                	addiw	a4,a4,-32
  800642:	18ec7963          	bleu	a4,s8,8007d4 <vprintfmt+0x354>
  800646:	03f00513          	li	a0,63
  80064a:	9982                	jalr	s3
  80064c:	0405                	addi	s0,s0,1
  80064e:	fff44703          	lbu	a4,-1(s0)
  800652:	3cfd                	addiw	s9,s9,-1
  800654:	0007051b          	sext.w	a0,a4
  800658:	f979                	bnez	a0,80062e <vprintfmt+0x1ae>
  80065a:	e5905de3          	blez	s9,8004b4 <vprintfmt+0x34>
  80065e:	3cfd                	addiw	s9,s9,-1
  800660:	864a                	mv	a2,s2
  800662:	85a6                	mv	a1,s1
  800664:	02000513          	li	a0,32
  800668:	9982                	jalr	s3
  80066a:	e40c85e3          	beqz	s9,8004b4 <vprintfmt+0x34>
  80066e:	3cfd                	addiw	s9,s9,-1
  800670:	864a                	mv	a2,s2
  800672:	85a6                	mv	a1,s1
  800674:	02000513          	li	a0,32
  800678:	9982                	jalr	s3
  80067a:	fe0c92e3          	bnez	s9,80065e <vprintfmt+0x1de>
  80067e:	bd1d                	j	8004b4 <vprintfmt+0x34>
  800680:	4705                	li	a4,1
  800682:	008b0613          	addi	a2,s6,8
  800686:	01174463          	blt	a4,a7,80068e <vprintfmt+0x20e>
  80068a:	12088663          	beqz	a7,8007b6 <vprintfmt+0x336>
  80068e:	000b3683          	ld	a3,0(s6)
  800692:	4729                	li	a4,10
  800694:	8b32                	mv	s6,a2
  800696:	b79d                	j	8005fc <vprintfmt+0x17c>
  800698:	00144603          	lbu	a2,1(s0)
  80069c:	02d00813          	li	a6,45
  8006a0:	846e                	mv	s0,s11
  8006a2:	bd89                	j	8004f4 <vprintfmt+0x74>
  8006a4:	864a                	mv	a2,s2
  8006a6:	85a6                	mv	a1,s1
  8006a8:	02500513          	li	a0,37
  8006ac:	9982                	jalr	s3
  8006ae:	b519                	j	8004b4 <vprintfmt+0x34>
  8006b0:	000b2d03          	lw	s10,0(s6)
  8006b4:	00144603          	lbu	a2,1(s0)
  8006b8:	0b21                	addi	s6,s6,8
  8006ba:	846e                	mv	s0,s11
  8006bc:	e20cdce3          	bgez	s9,8004f4 <vprintfmt+0x74>
  8006c0:	8cea                	mv	s9,s10
  8006c2:	5d7d                	li	s10,-1
  8006c4:	bd05                	j	8004f4 <vprintfmt+0x74>
  8006c6:	00144603          	lbu	a2,1(s0)
  8006ca:	03000813          	li	a6,48
  8006ce:	846e                	mv	s0,s11
  8006d0:	b515                	j	8004f4 <vprintfmt+0x74>
  8006d2:	fd060d1b          	addiw	s10,a2,-48
  8006d6:	00144603          	lbu	a2,1(s0)
  8006da:	846e                	mv	s0,s11
  8006dc:	fd06071b          	addiw	a4,a2,-48
  8006e0:	0006031b          	sext.w	t1,a2
  8006e4:	fce56ce3          	bltu	a0,a4,8006bc <vprintfmt+0x23c>
  8006e8:	0405                	addi	s0,s0,1
  8006ea:	002d171b          	slliw	a4,s10,0x2
  8006ee:	00044603          	lbu	a2,0(s0)
  8006f2:	01a706bb          	addw	a3,a4,s10
  8006f6:	0016969b          	slliw	a3,a3,0x1
  8006fa:	006686bb          	addw	a3,a3,t1
  8006fe:	fd06071b          	addiw	a4,a2,-48
  800702:	fd068d1b          	addiw	s10,a3,-48
  800706:	0006031b          	sext.w	t1,a2
  80070a:	fce57fe3          	bleu	a4,a0,8006e8 <vprintfmt+0x268>
  80070e:	b77d                	j	8006bc <vprintfmt+0x23c>
  800710:	fffcc713          	not	a4,s9
  800714:	977d                	srai	a4,a4,0x3f
  800716:	00ecf7b3          	and	a5,s9,a4
  80071a:	00144603          	lbu	a2,1(s0)
  80071e:	00078c9b          	sext.w	s9,a5
  800722:	846e                	mv	s0,s11
  800724:	bbc1                	j	8004f4 <vprintfmt+0x74>
  800726:	864a                	mv	a2,s2
  800728:	85a6                	mv	a1,s1
  80072a:	02500513          	li	a0,37
  80072e:	9982                	jalr	s3
  800730:	fff44703          	lbu	a4,-1(s0)
  800734:	02500793          	li	a5,37
  800738:	8da2                	mv	s11,s0
  80073a:	d6f70de3          	beq	a4,a5,8004b4 <vprintfmt+0x34>
  80073e:	02500713          	li	a4,37
  800742:	1dfd                	addi	s11,s11,-1
  800744:	fffdc783          	lbu	a5,-1(s11)
  800748:	fee79de3          	bne	a5,a4,800742 <vprintfmt+0x2c2>
  80074c:	b3a5                	j	8004b4 <vprintfmt+0x34>
  80074e:	00001697          	auipc	a3,0x1
  800752:	b1a68693          	addi	a3,a3,-1254 # 801268 <error_string+0x2c0>
  800756:	8626                	mv	a2,s1
  800758:	85ca                	mv	a1,s2
  80075a:	854e                	mv	a0,s3
  80075c:	0b2000ef          	jal	ra,80080e <printfmt>
  800760:	bb91                	j	8004b4 <vprintfmt+0x34>
  800762:	00001717          	auipc	a4,0x1
  800766:	afe70713          	addi	a4,a4,-1282 # 801260 <error_string+0x2b8>
  80076a:	00001417          	auipc	s0,0x1
  80076e:	af740413          	addi	s0,s0,-1289 # 801261 <error_string+0x2b9>
  800772:	853a                	mv	a0,a4
  800774:	85ea                	mv	a1,s10
  800776:	e03a                	sd	a4,0(sp)
  800778:	e442                	sd	a6,8(sp)
  80077a:	bf7ff0ef          	jal	ra,800370 <strnlen>
  80077e:	40ac8cbb          	subw	s9,s9,a0
  800782:	6702                	ld	a4,0(sp)
  800784:	01905f63          	blez	s9,8007a2 <vprintfmt+0x322>
  800788:	6822                	ld	a6,8(sp)
  80078a:	0008079b          	sext.w	a5,a6
  80078e:	e43e                	sd	a5,8(sp)
  800790:	6522                	ld	a0,8(sp)
  800792:	864a                	mv	a2,s2
  800794:	85a6                	mv	a1,s1
  800796:	e03a                	sd	a4,0(sp)
  800798:	3cfd                	addiw	s9,s9,-1
  80079a:	9982                	jalr	s3
  80079c:	6702                	ld	a4,0(sp)
  80079e:	fe0c99e3          	bnez	s9,800790 <vprintfmt+0x310>
  8007a2:	00074703          	lbu	a4,0(a4)
  8007a6:	0007051b          	sext.w	a0,a4
  8007aa:	e80512e3          	bnez	a0,80062e <vprintfmt+0x1ae>
  8007ae:	b319                	j	8004b4 <vprintfmt+0x34>
  8007b0:	000b2403          	lw	s0,0(s6)
  8007b4:	bb6d                	j	80056e <vprintfmt+0xee>
  8007b6:	000b6683          	lwu	a3,0(s6)
  8007ba:	4729                	li	a4,10
  8007bc:	8b32                	mv	s6,a2
  8007be:	bd3d                	j	8005fc <vprintfmt+0x17c>
  8007c0:	000b6683          	lwu	a3,0(s6)
  8007c4:	4741                	li	a4,16
  8007c6:	8b32                	mv	s6,a2
  8007c8:	bd15                	j	8005fc <vprintfmt+0x17c>
  8007ca:	000b6683          	lwu	a3,0(s6)
  8007ce:	4721                	li	a4,8
  8007d0:	8b32                	mv	s6,a2
  8007d2:	b52d                	j	8005fc <vprintfmt+0x17c>
  8007d4:	9982                	jalr	s3
  8007d6:	bd9d                	j	80064c <vprintfmt+0x1cc>
  8007d8:	864a                	mv	a2,s2
  8007da:	85a6                	mv	a1,s1
  8007dc:	02d00513          	li	a0,45
  8007e0:	e042                	sd	a6,0(sp)
  8007e2:	9982                	jalr	s3
  8007e4:	8b52                	mv	s6,s4
  8007e6:	408006b3          	neg	a3,s0
  8007ea:	4729                	li	a4,10
  8007ec:	6802                	ld	a6,0(sp)
  8007ee:	b539                	j	8005fc <vprintfmt+0x17c>
  8007f0:	01905663          	blez	s9,8007fc <vprintfmt+0x37c>
  8007f4:	02d00713          	li	a4,45
  8007f8:	f6e815e3          	bne	a6,a4,800762 <vprintfmt+0x2e2>
  8007fc:	00001417          	auipc	s0,0x1
  800800:	a6540413          	addi	s0,s0,-1435 # 801261 <error_string+0x2b9>
  800804:	02800513          	li	a0,40
  800808:	02800713          	li	a4,40
  80080c:	b50d                	j	80062e <vprintfmt+0x1ae>

000000000080080e <printfmt>:
  80080e:	7139                	addi	sp,sp,-64
  800810:	02010313          	addi	t1,sp,32
  800814:	f03a                	sd	a4,32(sp)
  800816:	871a                	mv	a4,t1
  800818:	ec06                	sd	ra,24(sp)
  80081a:	f43e                	sd	a5,40(sp)
  80081c:	f842                	sd	a6,48(sp)
  80081e:	fc46                	sd	a7,56(sp)
  800820:	e41a                	sd	t1,8(sp)
  800822:	c5fff0ef          	jal	ra,800480 <vprintfmt>
  800826:	60e2                	ld	ra,24(sp)
  800828:	6121                	addi	sp,sp,64
  80082a:	8082                	ret

000000000080082c <vsnprintf>:
  80082c:	15fd                	addi	a1,a1,-1
  80082e:	7179                	addi	sp,sp,-48
  800830:	95aa                	add	a1,a1,a0
  800832:	f406                	sd	ra,40(sp)
  800834:	e42a                	sd	a0,8(sp)
  800836:	e82e                	sd	a1,16(sp)
  800838:	cc02                	sw	zero,24(sp)
  80083a:	c515                	beqz	a0,800866 <vsnprintf+0x3a>
  80083c:	02a5e563          	bltu	a1,a0,800866 <vsnprintf+0x3a>
  800840:	75dd                	lui	a1,0xffff7
  800842:	8736                	mv	a4,a3
  800844:	00000517          	auipc	a0,0x0
  800848:	c2250513          	addi	a0,a0,-990 # 800466 <sprintputch>
  80084c:	86b2                	mv	a3,a2
  80084e:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <buffer.1212+0xffffffffff7f29d1>
  800852:	0030                	addi	a2,sp,8
  800854:	c2dff0ef          	jal	ra,800480 <vprintfmt>
  800858:	67a2                	ld	a5,8(sp)
  80085a:	00078023          	sb	zero,0(a5)
  80085e:	4562                	lw	a0,24(sp)
  800860:	70a2                	ld	ra,40(sp)
  800862:	6145                	addi	sp,sp,48
  800864:	8082                	ret
  800866:	5575                	li	a0,-3
  800868:	bfe5                	j	800860 <vsnprintf+0x34>

000000000080086a <snprintf>:
  80086a:	715d                	addi	sp,sp,-80
  80086c:	02810313          	addi	t1,sp,40
  800870:	f436                	sd	a3,40(sp)
  800872:	869a                	mv	a3,t1
  800874:	ec06                	sd	ra,24(sp)
  800876:	f83a                	sd	a4,48(sp)
  800878:	fc3e                	sd	a5,56(sp)
  80087a:	e0c2                	sd	a6,64(sp)
  80087c:	e4c6                	sd	a7,72(sp)
  80087e:	e41a                	sd	t1,8(sp)
  800880:	fadff0ef          	jal	ra,80082c <vsnprintf>
  800884:	60e2                	ld	ra,24(sp)
  800886:	6161                	addi	sp,sp,80
  800888:	8082                	ret

000000000080088a <gettoken>:
  80088a:	7139                	addi	sp,sp,-64
  80088c:	f822                	sd	s0,48(sp)
  80088e:	6100                	ld	s0,0(a0)
  800890:	fc06                	sd	ra,56(sp)
  800892:	f426                	sd	s1,40(sp)
  800894:	f04a                	sd	s2,32(sp)
  800896:	ec4e                	sd	s3,24(sp)
  800898:	e852                	sd	s4,16(sp)
  80089a:	e456                	sd	s5,8(sp)
  80089c:	e05a                	sd	s6,0(sp)
  80089e:	c405                	beqz	s0,8008c6 <gettoken+0x3c>
  8008a0:	89aa                	mv	s3,a0
  8008a2:	892e                	mv	s2,a1
  8008a4:	00001497          	auipc	s1,0x1
  8008a8:	9dc48493          	addi	s1,s1,-1572 # 801280 <error_string+0x2d8>
  8008ac:	a021                	j	8008b4 <gettoken+0x2a>
  8008ae:	0405                	addi	s0,s0,1
  8008b0:	fe040fa3          	sb	zero,-1(s0)
  8008b4:	00044583          	lbu	a1,0(s0)
  8008b8:	8526                	mv	a0,s1
  8008ba:	b19ff0ef          	jal	ra,8003d2 <strchr>
  8008be:	f965                	bnez	a0,8008ae <gettoken+0x24>
  8008c0:	00044783          	lbu	a5,0(s0)
  8008c4:	ef81                	bnez	a5,8008dc <gettoken+0x52>
  8008c6:	4501                	li	a0,0
  8008c8:	70e2                	ld	ra,56(sp)
  8008ca:	7442                	ld	s0,48(sp)
  8008cc:	74a2                	ld	s1,40(sp)
  8008ce:	7902                	ld	s2,32(sp)
  8008d0:	69e2                	ld	s3,24(sp)
  8008d2:	6a42                	ld	s4,16(sp)
  8008d4:	6aa2                	ld	s5,8(sp)
  8008d6:	6b02                	ld	s6,0(sp)
  8008d8:	6121                	addi	sp,sp,64
  8008da:	8082                	ret
  8008dc:	00893023          	sd	s0,0(s2)
  8008e0:	00044583          	lbu	a1,0(s0)
  8008e4:	00001517          	auipc	a0,0x1
  8008e8:	9a450513          	addi	a0,a0,-1628 # 801288 <error_string+0x2e0>
  8008ec:	ae7ff0ef          	jal	ra,8003d2 <strchr>
  8008f0:	892a                	mv	s2,a0
  8008f2:	c115                	beqz	a0,800916 <gettoken+0x8c>
  8008f4:	00044503          	lbu	a0,0(s0)
  8008f8:	00140913          	addi	s2,s0,1
  8008fc:	00040023          	sb	zero,0(s0)
  800900:	00094783          	lbu	a5,0(s2)
  800904:	00f037b3          	snez	a5,a5
  800908:	40f007b3          	neg	a5,a5
  80090c:	00f97933          	and	s2,s2,a5
  800910:	0129b023          	sd	s2,0(s3)
  800914:	bf55                	j	8008c8 <gettoken+0x3e>
  800916:	00044583          	lbu	a1,0(s0)
  80091a:	4481                	li	s1,0
  80091c:	00001b17          	auipc	s6,0x1
  800920:	974b0b13          	addi	s6,s6,-1676 # 801290 <error_string+0x2e8>
  800924:	02200a13          	li	s4,34
  800928:	02000a93          	li	s5,32
  80092c:	cd91                	beqz	a1,800948 <gettoken+0xbe>
  80092e:	c095                	beqz	s1,800952 <gettoken+0xc8>
  800930:	00044783          	lbu	a5,0(s0)
  800934:	01479663          	bne	a5,s4,800940 <gettoken+0xb6>
  800938:	01540023          	sb	s5,0(s0)
  80093c:	0014c493          	xori	s1,s1,1
  800940:	0405                	addi	s0,s0,1
  800942:	00044583          	lbu	a1,0(s0)
  800946:	f5e5                	bnez	a1,80092e <gettoken+0xa4>
  800948:	07700513          	li	a0,119
  80094c:	0129b023          	sd	s2,0(s3)
  800950:	bfa5                	j	8008c8 <gettoken+0x3e>
  800952:	855a                	mv	a0,s6
  800954:	a7fff0ef          	jal	ra,8003d2 <strchr>
  800958:	dd61                	beqz	a0,800930 <gettoken+0xa6>
  80095a:	8922                	mv	s2,s0
  80095c:	07700513          	li	a0,119
  800960:	b745                	j	800900 <gettoken+0x76>

0000000000800962 <readline>:
  800962:	711d                	addi	sp,sp,-96
  800964:	ec86                	sd	ra,88(sp)
  800966:	e8a2                	sd	s0,80(sp)
  800968:	e4a6                	sd	s1,72(sp)
  80096a:	e0ca                	sd	s2,64(sp)
  80096c:	fc4e                	sd	s3,56(sp)
  80096e:	f852                	sd	s4,48(sp)
  800970:	f456                	sd	s5,40(sp)
  800972:	f05a                	sd	s6,32(sp)
  800974:	ec5e                	sd	s7,24(sp)
  800976:	c909                	beqz	a0,800988 <readline+0x26>
  800978:	862a                	mv	a2,a0
  80097a:	00001597          	auipc	a1,0x1
  80097e:	8fe58593          	addi	a1,a1,-1794 # 801278 <error_string+0x2d0>
  800982:	4505                	li	a0,1
  800984:	8c1ff0ef          	jal	ra,800244 <fprintf>
  800988:	6985                	lui	s3,0x1
  80098a:	4401                	li	s0,0
  80098c:	448d                	li	s1,3
  80098e:	497d                	li	s2,31
  800990:	4a21                	li	s4,8
  800992:	4aa9                	li	s5,10
  800994:	4b35                	li	s6,13
  800996:	19f9                	addi	s3,s3,-2
  800998:	00003b97          	auipc	s7,0x3
  80099c:	770b8b93          	addi	s7,s7,1904 # 804108 <buffer.1212>
  8009a0:	4605                	li	a2,1
  8009a2:	00f10593          	addi	a1,sp,15
  8009a6:	4501                	li	a0,0
  8009a8:	faeff0ef          	jal	ra,800156 <read>
  8009ac:	04054163          	bltz	a0,8009ee <readline+0x8c>
  8009b0:	c549                	beqz	a0,800a3a <readline+0xd8>
  8009b2:	00f14603          	lbu	a2,15(sp)
  8009b6:	02960c63          	beq	a2,s1,8009ee <readline+0x8c>
  8009ba:	04c97663          	bleu	a2,s2,800a06 <readline+0xa4>
  8009be:	fe89c1e3          	blt	s3,s0,8009a0 <readline+0x3e>
  8009c2:	00001597          	auipc	a1,0x1
  8009c6:	94658593          	addi	a1,a1,-1722 # 801308 <error_string+0x360>
  8009ca:	4505                	li	a0,1
  8009cc:	879ff0ef          	jal	ra,800244 <fprintf>
  8009d0:	00f14703          	lbu	a4,15(sp)
  8009d4:	008b87b3          	add	a5,s7,s0
  8009d8:	4605                	li	a2,1
  8009da:	00f10593          	addi	a1,sp,15
  8009de:	4501                	li	a0,0
  8009e0:	00e78023          	sb	a4,0(a5)
  8009e4:	2405                	addiw	s0,s0,1
  8009e6:	f70ff0ef          	jal	ra,800156 <read>
  8009ea:	fc0553e3          	bgez	a0,8009b0 <readline+0x4e>
  8009ee:	4501                	li	a0,0
  8009f0:	60e6                	ld	ra,88(sp)
  8009f2:	6446                	ld	s0,80(sp)
  8009f4:	64a6                	ld	s1,72(sp)
  8009f6:	6906                	ld	s2,64(sp)
  8009f8:	79e2                	ld	s3,56(sp)
  8009fa:	7a42                	ld	s4,48(sp)
  8009fc:	7aa2                	ld	s5,40(sp)
  8009fe:	7b02                	ld	s6,32(sp)
  800a00:	6be2                	ld	s7,24(sp)
  800a02:	6125                	addi	sp,sp,96
  800a04:	8082                	ret
  800a06:	01461d63          	bne	a2,s4,800a20 <readline+0xbe>
  800a0a:	d859                	beqz	s0,8009a0 <readline+0x3e>
  800a0c:	4621                	li	a2,8
  800a0e:	00001597          	auipc	a1,0x1
  800a12:	8fa58593          	addi	a1,a1,-1798 # 801308 <error_string+0x360>
  800a16:	4505                	li	a0,1
  800a18:	82dff0ef          	jal	ra,800244 <fprintf>
  800a1c:	347d                	addiw	s0,s0,-1
  800a1e:	b749                	j	8009a0 <readline+0x3e>
  800a20:	03560a63          	beq	a2,s5,800a54 <readline+0xf2>
  800a24:	f7661ee3          	bne	a2,s6,8009a0 <readline+0x3e>
  800a28:	4635                	li	a2,13
  800a2a:	00001597          	auipc	a1,0x1
  800a2e:	8de58593          	addi	a1,a1,-1826 # 801308 <error_string+0x360>
  800a32:	4505                	li	a0,1
  800a34:	811ff0ef          	jal	ra,800244 <fprintf>
  800a38:	a011                	j	800a3c <readline+0xda>
  800a3a:	d855                	beqz	s0,8009ee <readline+0x8c>
  800a3c:	00003797          	auipc	a5,0x3
  800a40:	6cc78793          	addi	a5,a5,1740 # 804108 <buffer.1212>
  800a44:	943e                	add	s0,s0,a5
  800a46:	00040023          	sb	zero,0(s0)
  800a4a:	00003517          	auipc	a0,0x3
  800a4e:	6be50513          	addi	a0,a0,1726 # 804108 <buffer.1212>
  800a52:	bf79                	j	8009f0 <readline+0x8e>
  800a54:	4629                	li	a2,10
  800a56:	bfd1                	j	800a2a <readline+0xc8>

0000000000800a58 <reopen>:
  800a58:	1101                	addi	sp,sp,-32
  800a5a:	ec06                	sd	ra,24(sp)
  800a5c:	e822                	sd	s0,16(sp)
  800a5e:	e426                	sd	s1,8(sp)
  800a60:	842e                	mv	s0,a1
  800a62:	e04a                	sd	s2,0(sp)
  800a64:	84aa                	mv	s1,a0
  800a66:	8932                	mv	s2,a2
  800a68:	eeaff0ef          	jal	ra,800152 <close>
  800a6c:	8522                	mv	a0,s0
  800a6e:	85ca                	mv	a1,s2
  800a70:	edaff0ef          	jal	ra,80014a <open>
  800a74:	842a                	mv	s0,a0
  800a76:	00054463          	bltz	a0,800a7e <reopen+0x26>
  800a7a:	00a49e63          	bne	s1,a0,800a96 <reopen+0x3e>
  800a7e:	00142513          	slti	a0,s0,1
  800a82:	40a0053b          	negw	a0,a0
  800a86:	8d61                	and	a0,a0,s0
  800a88:	60e2                	ld	ra,24(sp)
  800a8a:	6442                	ld	s0,16(sp)
  800a8c:	64a2                	ld	s1,8(sp)
  800a8e:	6902                	ld	s2,0(sp)
  800a90:	2501                	sext.w	a0,a0
  800a92:	6105                	addi	sp,sp,32
  800a94:	8082                	ret
  800a96:	8526                	mv	a0,s1
  800a98:	ebaff0ef          	jal	ra,800152 <close>
  800a9c:	85a6                	mv	a1,s1
  800a9e:	8522                	mv	a0,s0
  800aa0:	ebeff0ef          	jal	ra,80015e <dup2>
  800aa4:	84aa                	mv	s1,a0
  800aa6:	8522                	mv	a0,s0
  800aa8:	eaaff0ef          	jal	ra,800152 <close>
  800aac:	8426                	mv	s0,s1
  800aae:	bfc1                	j	800a7e <reopen+0x26>

0000000000800ab0 <testfile>:
  800ab0:	1141                	addi	sp,sp,-16
  800ab2:	4581                	li	a1,0
  800ab4:	e406                	sd	ra,8(sp)
  800ab6:	e94ff0ef          	jal	ra,80014a <open>
  800aba:	87aa                	mv	a5,a0
  800abc:	00054563          	bltz	a0,800ac6 <testfile+0x16>
  800ac0:	e92ff0ef          	jal	ra,800152 <close>
  800ac4:	4781                	li	a5,0
  800ac6:	60a2                	ld	ra,8(sp)
  800ac8:	853e                	mv	a0,a5
  800aca:	0141                	addi	sp,sp,16
  800acc:	8082                	ret

0000000000800ace <runcmd>:
  800ace:	711d                	addi	sp,sp,-96
  800ad0:	e0ca                	sd	s2,64(sp)
  800ad2:	f852                	sd	s4,48(sp)
  800ad4:	f456                	sd	s5,40(sp)
  800ad6:	f05a                	sd	s6,32(sp)
  800ad8:	ec86                	sd	ra,88(sp)
  800ada:	e8a2                	sd	s0,80(sp)
  800adc:	e4a6                	sd	s1,72(sp)
  800ade:	fc4e                	sd	s3,56(sp)
  800ae0:	e42a                	sd	a0,8(sp)
  800ae2:	07700913          	li	s2,119
  800ae6:	02000a93          	li	s5,32
  800aea:	00002b17          	auipc	s6,0x2
  800aee:	516b0b13          	addi	s6,s6,1302 # 803000 <argv.1236>
  800af2:	07c00a13          	li	s4,124
  800af6:	4481                	li	s1,0
  800af8:	03c00413          	li	s0,60
  800afc:	03e00993          	li	s3,62
  800b00:	082c                	addi	a1,sp,24
  800b02:	0028                	addi	a0,sp,8
  800b04:	d87ff0ef          	jal	ra,80088a <gettoken>
  800b08:	0c850563          	beq	a0,s0,800bd2 <runcmd+0x104>
  800b0c:	02a45c63          	ble	a0,s0,800b44 <runcmd+0x76>
  800b10:	0b250363          	beq	a0,s2,800bb6 <runcmd+0xe8>
  800b14:	0f450d63          	beq	a0,s4,800c0e <runcmd+0x140>
  800b18:	0d350c63          	beq	a0,s3,800bf0 <runcmd+0x122>
  800b1c:	862a                	mv	a2,a0
  800b1e:	00001597          	auipc	a1,0x1
  800b22:	87258593          	addi	a1,a1,-1934 # 801390 <error_string+0x3e8>
  800b26:	4505                	li	a0,1
  800b28:	f1cff0ef          	jal	ra,800244 <fprintf>
  800b2c:	54fd                	li	s1,-1
  800b2e:	60e6                	ld	ra,88(sp)
  800b30:	6446                	ld	s0,80(sp)
  800b32:	8526                	mv	a0,s1
  800b34:	6906                	ld	s2,64(sp)
  800b36:	64a6                	ld	s1,72(sp)
  800b38:	79e2                	ld	s3,56(sp)
  800b3a:	7a42                	ld	s4,48(sp)
  800b3c:	7aa2                	ld	s5,40(sp)
  800b3e:	7b02                	ld	s6,32(sp)
  800b40:	6125                	addi	sp,sp,96
  800b42:	8082                	ret
  800b44:	c121                	beqz	a0,800b84 <runcmd+0xb6>
  800b46:	03b00793          	li	a5,59
  800b4a:	fcf519e3          	bne	a0,a5,800b1c <runcmd+0x4e>
  800b4e:	ff8ff0ef          	jal	ra,800346 <fork>
  800b52:	87aa                	mv	a5,a0
  800b54:	c905                	beqz	a0,800b84 <runcmd+0xb6>
  800b56:	12054963          	bltz	a0,800c88 <runcmd+0x1ba>
  800b5a:	4581                	li	a1,0
  800b5c:	feeff0ef          	jal	ra,80034a <waitpid>
  800b60:	bf59                	j	800af6 <runcmd+0x28>
  800b62:	12054363          	bltz	a0,800c88 <runcmd+0x1ba>
  800b66:	4505                	li	a0,1
  800b68:	deaff0ef          	jal	ra,800152 <close>
  800b6c:	4585                	li	a1,1
  800b6e:	4501                	li	a0,0
  800b70:	deeff0ef          	jal	ra,80015e <dup2>
  800b74:	06054c63          	bltz	a0,800bec <runcmd+0x11e>
  800b78:	4501                	li	a0,0
  800b7a:	dd8ff0ef          	jal	ra,800152 <close>
  800b7e:	4501                	li	a0,0
  800b80:	dd2ff0ef          	jal	ra,800152 <close>
  800b84:	d4cd                	beqz	s1,800b2e <runcmd+0x60>
  800b86:	00002417          	auipc	s0,0x2
  800b8a:	47a40413          	addi	s0,s0,1146 # 803000 <argv.1236>
  800b8e:	6008                	ld	a0,0(s0)
  800b90:	00001597          	auipc	a1,0x1
  800b94:	82858593          	addi	a1,a1,-2008 # 8013b8 <error_string+0x410>
  800b98:	811ff0ef          	jal	ra,8003a8 <strcmp>
  800b9c:	ed49                	bnez	a0,800c36 <runcmd+0x168>
  800b9e:	4789                	li	a5,2
  800ba0:	0ef49663          	bne	s1,a5,800c8c <runcmd+0x1be>
  800ba4:	640c                	ld	a1,8(s0)
  800ba6:	00001517          	auipc	a0,0x1
  800baa:	45a50513          	addi	a0,a0,1114 # 802000 <shcwd>
  800bae:	4481                	li	s1,0
  800bb0:	fe6ff0ef          	jal	ra,800396 <strcpy>
  800bb4:	bfad                	j	800b2e <runcmd+0x60>
  800bb6:	0f548f63          	beq	s1,s5,800cb4 <runcmd+0x1e6>
  800bba:	6762                	ld	a4,24(sp)
  800bbc:	00349793          	slli	a5,s1,0x3
  800bc0:	97da                	add	a5,a5,s6
  800bc2:	082c                	addi	a1,sp,24
  800bc4:	0028                	addi	a0,sp,8
  800bc6:	e398                	sd	a4,0(a5)
  800bc8:	2485                	addiw	s1,s1,1
  800bca:	cc1ff0ef          	jal	ra,80088a <gettoken>
  800bce:	f2851fe3          	bne	a0,s0,800b0c <runcmd+0x3e>
  800bd2:	082c                	addi	a1,sp,24
  800bd4:	0028                	addi	a0,sp,8
  800bd6:	cb5ff0ef          	jal	ra,80088a <gettoken>
  800bda:	0d251463          	bne	a0,s2,800ca2 <runcmd+0x1d4>
  800bde:	65e2                	ld	a1,24(sp)
  800be0:	4601                	li	a2,0
  800be2:	4501                	li	a0,0
  800be4:	e75ff0ef          	jal	ra,800a58 <reopen>
  800be8:	f0050ce3          	beqz	a0,800b00 <runcmd+0x32>
  800bec:	84aa                	mv	s1,a0
  800bee:	b781                	j	800b2e <runcmd+0x60>
  800bf0:	082c                	addi	a1,sp,24
  800bf2:	0028                	addi	a0,sp,8
  800bf4:	c97ff0ef          	jal	ra,80088a <gettoken>
  800bf8:	09251c63          	bne	a0,s2,800c90 <runcmd+0x1c2>
  800bfc:	65e2                	ld	a1,24(sp)
  800bfe:	4659                	li	a2,22
  800c00:	4505                	li	a0,1
  800c02:	e57ff0ef          	jal	ra,800a58 <reopen>
  800c06:	ee050de3          	beqz	a0,800b00 <runcmd+0x32>
  800c0a:	84aa                	mv	s1,a0
  800c0c:	b70d                	j	800b2e <runcmd+0x60>
  800c0e:	f38ff0ef          	jal	ra,800346 <fork>
  800c12:	87aa                	mv	a5,a0
  800c14:	f539                	bnez	a0,800b62 <runcmd+0x94>
  800c16:	d3cff0ef          	jal	ra,800152 <close>
  800c1a:	4581                	li	a1,0
  800c1c:	4501                	li	a0,0
  800c1e:	d40ff0ef          	jal	ra,80015e <dup2>
  800c22:	84aa                	mv	s1,a0
  800c24:	f00545e3          	bltz	a0,800b2e <runcmd+0x60>
  800c28:	4501                	li	a0,0
  800c2a:	d28ff0ef          	jal	ra,800152 <close>
  800c2e:	4501                	li	a0,0
  800c30:	d22ff0ef          	jal	ra,800152 <close>
  800c34:	b5c9                	j	800af6 <runcmd+0x28>
  800c36:	6008                	ld	a0,0(s0)
  800c38:	e79ff0ef          	jal	ra,800ab0 <testfile>
  800c3c:	c905                	beqz	a0,800c6c <runcmd+0x19e>
  800c3e:	57c1                	li	a5,-16
  800c40:	faf516e3          	bne	a0,a5,800bec <runcmd+0x11e>
  800c44:	6014                	ld	a3,0(s0)
  800c46:	00000617          	auipc	a2,0x0
  800c4a:	77a60613          	addi	a2,a2,1914 # 8013c0 <error_string+0x418>
  800c4e:	6585                	lui	a1,0x1
  800c50:	00002517          	auipc	a0,0x2
  800c54:	4b850513          	addi	a0,a0,1208 # 803108 <argv0.1235>
  800c58:	c13ff0ef          	jal	ra,80086a <snprintf>
  800c5c:	00002797          	auipc	a5,0x2
  800c60:	4ac78793          	addi	a5,a5,1196 # 803108 <argv0.1235>
  800c64:	00002717          	auipc	a4,0x2
  800c68:	38f73e23          	sd	a5,924(a4) # 803000 <argv.1236>
  800c6c:	00349793          	slli	a5,s1,0x3
  800c70:	97a2                	add	a5,a5,s0
  800c72:	0007b023          	sd	zero,0(a5)
  800c76:	6008                	ld	a0,0(s0)
  800c78:	00002597          	auipc	a1,0x2
  800c7c:	38858593          	addi	a1,a1,904 # 803000 <argv.1236>
  800c80:	eceff0ef          	jal	ra,80034e <__exec>
  800c84:	84aa                	mv	s1,a0
  800c86:	b565                	j	800b2e <runcmd+0x60>
  800c88:	84be                	mv	s1,a5
  800c8a:	b555                	j	800b2e <runcmd+0x60>
  800c8c:	54fd                	li	s1,-1
  800c8e:	b545                	j	800b2e <runcmd+0x60>
  800c90:	00000597          	auipc	a1,0x0
  800c94:	6d058593          	addi	a1,a1,1744 # 801360 <error_string+0x3b8>
  800c98:	4505                	li	a0,1
  800c9a:	daaff0ef          	jal	ra,800244 <fprintf>
  800c9e:	54fd                	li	s1,-1
  800ca0:	b579                	j	800b2e <runcmd+0x60>
  800ca2:	00000597          	auipc	a1,0x0
  800ca6:	68e58593          	addi	a1,a1,1678 # 801330 <error_string+0x388>
  800caa:	4505                	li	a0,1
  800cac:	d98ff0ef          	jal	ra,800244 <fprintf>
  800cb0:	54fd                	li	s1,-1
  800cb2:	bdb5                	j	800b2e <runcmd+0x60>
  800cb4:	00000597          	auipc	a1,0x0
  800cb8:	65c58593          	addi	a1,a1,1628 # 801310 <error_string+0x368>
  800cbc:	4505                	li	a0,1
  800cbe:	d86ff0ef          	jal	ra,800244 <fprintf>
  800cc2:	54fd                	li	s1,-1
  800cc4:	b5ad                	j	800b2e <runcmd+0x60>

0000000000800cc6 <main>:
  800cc6:	7179                	addi	sp,sp,-48
  800cc8:	f022                	sd	s0,32(sp)
  800cca:	842a                	mv	s0,a0
  800ccc:	00000517          	auipc	a0,0x0
  800cd0:	5d450513          	addi	a0,a0,1492 # 8012a0 <error_string+0x2f8>
  800cd4:	ec26                	sd	s1,24(sp)
  800cd6:	f406                	sd	ra,40(sp)
  800cd8:	e84a                	sd	s2,16(sp)
  800cda:	84ae                	mv	s1,a1
  800cdc:	d28ff0ef          	jal	ra,800204 <cputs>
  800ce0:	4789                	li	a5,2
  800ce2:	04f40e63          	beq	s0,a5,800d3e <main+0x78>
  800ce6:	00000497          	auipc	s1,0x0
  800cea:	60a48493          	addi	s1,s1,1546 # 8012f0 <error_string+0x348>
  800cee:	0687c163          	blt	a5,s0,800d50 <main+0x8a>
  800cf2:	00000917          	auipc	s2,0x0
  800cf6:	60690913          	addi	s2,s2,1542 # 8012f8 <error_string+0x350>
  800cfa:	a831                	j	800d16 <main+0x50>
  800cfc:	00001797          	auipc	a5,0x1
  800d00:	30078223          	sb	zero,772(a5) # 802000 <shcwd>
  800d04:	e42ff0ef          	jal	ra,800346 <fork>
  800d08:	cd2d                	beqz	a0,800d82 <main+0xbc>
  800d0a:	04054c63          	bltz	a0,800d62 <main+0x9c>
  800d0e:	006c                	addi	a1,sp,12
  800d10:	e3aff0ef          	jal	ra,80034a <waitpid>
  800d14:	cd09                	beqz	a0,800d2e <main+0x68>
  800d16:	8526                	mv	a0,s1
  800d18:	c4bff0ef          	jal	ra,800962 <readline>
  800d1c:	842a                	mv	s0,a0
  800d1e:	fd79                	bnez	a0,800cfc <main+0x36>
  800d20:	4501                	li	a0,0
  800d22:	70a2                	ld	ra,40(sp)
  800d24:	7402                	ld	s0,32(sp)
  800d26:	64e2                	ld	s1,24(sp)
  800d28:	6942                	ld	s2,16(sp)
  800d2a:	6145                	addi	sp,sp,48
  800d2c:	8082                	ret
  800d2e:	46b2                	lw	a3,12(sp)
  800d30:	d2fd                	beqz	a3,800d16 <main+0x50>
  800d32:	8636                	mv	a2,a3
  800d34:	85ca                	mv	a1,s2
  800d36:	4505                	li	a0,1
  800d38:	d0cff0ef          	jal	ra,800244 <fprintf>
  800d3c:	bfe9                	j	800d16 <main+0x50>
  800d3e:	648c                	ld	a1,8(s1)
  800d40:	4601                	li	a2,0
  800d42:	4501                	li	a0,0
  800d44:	d15ff0ef          	jal	ra,800a58 <reopen>
  800d48:	c62a                	sw	a0,12(sp)
  800d4a:	4481                	li	s1,0
  800d4c:	d15d                	beqz	a0,800cf2 <main+0x2c>
  800d4e:	bfd1                	j	800d22 <main+0x5c>
  800d50:	00000597          	auipc	a1,0x0
  800d54:	67858593          	addi	a1,a1,1656 # 8013c8 <error_string+0x420>
  800d58:	4505                	li	a0,1
  800d5a:	ceaff0ef          	jal	ra,800244 <fprintf>
  800d5e:	557d                	li	a0,-1
  800d60:	b7c9                	j	800d22 <main+0x5c>
  800d62:	00000697          	auipc	a3,0x0
  800d66:	55668693          	addi	a3,a3,1366 # 8012b8 <error_string+0x310>
  800d6a:	00000617          	auipc	a2,0x0
  800d6e:	55e60613          	addi	a2,a2,1374 # 8012c8 <error_string+0x320>
  800d72:	0f200593          	li	a1,242
  800d76:	00000517          	auipc	a0,0x0
  800d7a:	56a50513          	addi	a0,a0,1386 # 8012e0 <error_string+0x338>
  800d7e:	aa2ff0ef          	jal	ra,800020 <__panic>
  800d82:	8522                	mv	a0,s0
  800d84:	d4bff0ef          	jal	ra,800ace <runcmd>
  800d88:	c62a                	sw	a0,12(sp)
  800d8a:	da6ff0ef          	jal	ra,800330 <exit>
