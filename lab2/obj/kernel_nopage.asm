
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 42 53 00 00       	call   105398 <memset>

    cons_init();                // init the console
  100056:	e8 bc 14 00 00       	call   101517 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 c0 5b 10 00 	movl   $0x105bc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 dc 5b 10 00 	movl   $0x105bdc,(%esp)
  100070:	e8 16 02 00 00       	call   10028b <cprintf>

    print_kerninfo();
  100075:	e8 b7 08 00 00       	call   100931 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 8b 00 00 00       	call   10010a <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 b8 2e 00 00       	call   102f3c <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 eb 15 00 00       	call   101674 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 49 17 00 00       	call   1017d7 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 3a 0c 00 00       	call   100ccd <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 17 17 00 00       	call   1017af <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100098:	e8 62 01 00 00       	call   1001ff <lab1_switch_test>

    /* do nothing */
    while (1);
  10009d:	eb fe                	jmp    10009d <kern_init+0x73>

0010009f <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009f:	55                   	push   %ebp
  1000a0:	89 e5                	mov    %esp,%ebp
  1000a2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000ac:	00 
  1000ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b4:	00 
  1000b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bc:	e8 fa 0b 00 00       	call   100cbb <mon_backtrace>
}
  1000c1:	c9                   	leave  
  1000c2:	c3                   	ret    

001000c3 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c3:	55                   	push   %ebp
  1000c4:	89 e5                	mov    %esp,%ebp
  1000c6:	53                   	push   %ebx
  1000c7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000ca:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d0:	8d 55 08             	lea    0x8(%ebp),%edx
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000da:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000de:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e2:	89 04 24             	mov    %eax,(%esp)
  1000e5:	e8 b5 ff ff ff       	call   10009f <grade_backtrace2>
}
  1000ea:	83 c4 14             	add    $0x14,%esp
  1000ed:	5b                   	pop    %ebx
  1000ee:	5d                   	pop    %ebp
  1000ef:	c3                   	ret    

001000f0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f0:	55                   	push   %ebp
  1000f1:	89 e5                	mov    %esp,%ebp
  1000f3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f6:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100100:	89 04 24             	mov    %eax,(%esp)
  100103:	e8 bb ff ff ff       	call   1000c3 <grade_backtrace1>
}
  100108:	c9                   	leave  
  100109:	c3                   	ret    

0010010a <grade_backtrace>:

void
grade_backtrace(void) {
  10010a:	55                   	push   %ebp
  10010b:	89 e5                	mov    %esp,%ebp
  10010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100110:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100115:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10011c:	ff 
  10011d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100128:	e8 c3 ff ff ff       	call   1000f0 <grade_backtrace0>
}
  10012d:	c9                   	leave  
  10012e:	c3                   	ret    

0010012f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012f:	55                   	push   %ebp
  100130:	89 e5                	mov    %esp,%ebp
  100132:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100145:	0f b7 c0             	movzwl %ax,%eax
  100148:	83 e0 03             	and    $0x3,%eax
  10014b:	89 c2                	mov    %eax,%edx
  10014d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100152:	89 54 24 08          	mov    %edx,0x8(%esp)
  100156:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015a:	c7 04 24 e1 5b 10 00 	movl   $0x105be1,(%esp)
  100161:	e8 25 01 00 00       	call   10028b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100166:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10016a:	0f b7 d0             	movzwl %ax,%edx
  10016d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100172:	89 54 24 08          	mov    %edx,0x8(%esp)
  100176:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017a:	c7 04 24 ef 5b 10 00 	movl   $0x105bef,(%esp)
  100181:	e8 05 01 00 00       	call   10028b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100186:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10018a:	0f b7 d0             	movzwl %ax,%edx
  10018d:	a1 40 7a 11 00       	mov    0x117a40,%eax
  100192:	89 54 24 08          	mov    %edx,0x8(%esp)
  100196:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019a:	c7 04 24 fd 5b 10 00 	movl   $0x105bfd,(%esp)
  1001a1:	e8 e5 00 00 00       	call   10028b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001aa:	0f b7 d0             	movzwl %ax,%edx
  1001ad:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ba:	c7 04 24 0b 5c 10 00 	movl   $0x105c0b,(%esp)
  1001c1:	e8 c5 00 00 00       	call   10028b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ca:	0f b7 d0             	movzwl %ax,%edx
  1001cd:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001da:	c7 04 24 19 5c 10 00 	movl   $0x105c19,(%esp)
  1001e1:	e8 a5 00 00 00       	call   10028b <cprintf>
    round ++;
  1001e6:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001eb:	83 c0 01             	add    $0x1,%eax
  1001ee:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001f3:	c9                   	leave  
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
  100202:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100205:	e8 25 ff ff ff       	call   10012f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10020a:	c7 04 24 28 5c 10 00 	movl   $0x105c28,(%esp)
  100211:	e8 75 00 00 00       	call   10028b <cprintf>
    lab1_switch_to_user();
  100216:	e8 da ff ff ff       	call   1001f5 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021b:	e8 0f ff ff ff       	call   10012f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100220:	c7 04 24 48 5c 10 00 	movl   $0x105c48,(%esp)
  100227:	e8 5f 00 00 00       	call   10028b <cprintf>
    lab1_switch_to_kernel();
  10022c:	e8 c9 ff ff ff       	call   1001fa <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100231:	e8 f9 fe ff ff       	call   10012f <lab1_print_cur_status>
}
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	55                   	push   %ebp
  100239:	89 e5                	mov    %esp,%ebp
  10023b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10023e:	8b 45 08             	mov    0x8(%ebp),%eax
  100241:	89 04 24             	mov    %eax,(%esp)
  100244:	e8 fa 12 00 00       	call   101543 <cons_putc>
    (*cnt) ++;
  100249:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024c:	8b 00                	mov    (%eax),%eax
  10024e:	8d 50 01             	lea    0x1(%eax),%edx
  100251:	8b 45 0c             	mov    0xc(%ebp),%eax
  100254:	89 10                	mov    %edx,(%eax)
}
  100256:	c9                   	leave  
  100257:	c3                   	ret    

00100258 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100258:	55                   	push   %ebp
  100259:	89 e5                	mov    %esp,%ebp
  10025b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100265:	8b 45 0c             	mov    0xc(%ebp),%eax
  100268:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10026c:	8b 45 08             	mov    0x8(%ebp),%eax
  10026f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100273:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100276:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027a:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  100281:	e8 64 54 00 00       	call   1056ea <vprintfmt>
    return cnt;
  100286:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100289:	c9                   	leave  
  10028a:	c3                   	ret    

0010028b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10028b:	55                   	push   %ebp
  10028c:	89 e5                	mov    %esp,%ebp
  10028e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100291:	8d 45 0c             	lea    0xc(%ebp),%eax
  100294:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100297:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10029e:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a1:	89 04 24             	mov    %eax,(%esp)
  1002a4:	e8 af ff ff ff       	call   100258 <vcprintf>
  1002a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002af:	c9                   	leave  
  1002b0:	c3                   	ret    

001002b1 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b1:	55                   	push   %ebp
  1002b2:	89 e5                	mov    %esp,%ebp
  1002b4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ba:	89 04 24             	mov    %eax,(%esp)
  1002bd:	e8 81 12 00 00       	call   101543 <cons_putc>
}
  1002c2:	c9                   	leave  
  1002c3:	c3                   	ret    

001002c4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002c4:	55                   	push   %ebp
  1002c5:	89 e5                	mov    %esp,%ebp
  1002c7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d1:	eb 13                	jmp    1002e6 <cputs+0x22>
        cputch(c, &cnt);
  1002d3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002d7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002da:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002de:	89 04 24             	mov    %eax,(%esp)
  1002e1:	e8 52 ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e9:	8d 50 01             	lea    0x1(%eax),%edx
  1002ec:	89 55 08             	mov    %edx,0x8(%ebp)
  1002ef:	0f b6 00             	movzbl (%eax),%eax
  1002f2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002f5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002f9:	75 d8                	jne    1002d3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100302:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100309:	e8 2a ff ff ff       	call   100238 <cputch>
    return cnt;
  10030e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100311:	c9                   	leave  
  100312:	c3                   	ret    

00100313 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100313:	55                   	push   %ebp
  100314:	89 e5                	mov    %esp,%ebp
  100316:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100319:	e8 61 12 00 00       	call   10157f <cons_getc>
  10031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100325:	74 f2                	je     100319 <getchar+0x6>
        /* do nothing */;
    return c;
  100327:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032a:	c9                   	leave  
  10032b:	c3                   	ret    

0010032c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10032c:	55                   	push   %ebp
  10032d:	89 e5                	mov    %esp,%ebp
  10032f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100332:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100336:	74 13                	je     10034b <readline+0x1f>
        cprintf("%s", prompt);
  100338:	8b 45 08             	mov    0x8(%ebp),%eax
  10033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10033f:	c7 04 24 67 5c 10 00 	movl   $0x105c67,(%esp)
  100346:	e8 40 ff ff ff       	call   10028b <cprintf>
    }
    int i = 0, c;
  10034b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100352:	e8 bc ff ff ff       	call   100313 <getchar>
  100357:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10035a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10035e:	79 07                	jns    100367 <readline+0x3b>
            return NULL;
  100360:	b8 00 00 00 00       	mov    $0x0,%eax
  100365:	eb 79                	jmp    1003e0 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100367:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10036b:	7e 28                	jle    100395 <readline+0x69>
  10036d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100374:	7f 1f                	jg     100395 <readline+0x69>
            cputchar(c);
  100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100379:	89 04 24             	mov    %eax,(%esp)
  10037c:	e8 30 ff ff ff       	call   1002b1 <cputchar>
            buf[i ++] = c;
  100381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100384:	8d 50 01             	lea    0x1(%eax),%edx
  100387:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10038a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10038d:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  100393:	eb 46                	jmp    1003db <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100395:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100399:	75 17                	jne    1003b2 <readline+0x86>
  10039b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10039f:	7e 11                	jle    1003b2 <readline+0x86>
            cputchar(c);
  1003a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a4:	89 04 24             	mov    %eax,(%esp)
  1003a7:	e8 05 ff ff ff       	call   1002b1 <cputchar>
            i --;
  1003ac:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003b0:	eb 29                	jmp    1003db <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1003b2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003b6:	74 06                	je     1003be <readline+0x92>
  1003b8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003bc:	75 1d                	jne    1003db <readline+0xaf>
            cputchar(c);
  1003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c1:	89 04 24             	mov    %eax,(%esp)
  1003c4:	e8 e8 fe ff ff       	call   1002b1 <cputchar>
            buf[i] = '\0';
  1003c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003cc:	05 60 7a 11 00       	add    $0x117a60,%eax
  1003d1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003d4:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1003d9:	eb 05                	jmp    1003e0 <readline+0xb4>
        }
    }
  1003db:	e9 72 ff ff ff       	jmp    100352 <readline+0x26>
}
  1003e0:	c9                   	leave  
  1003e1:	c3                   	ret    

001003e2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e2:	55                   	push   %ebp
  1003e3:	89 e5                	mov    %esp,%ebp
  1003e5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003e8:	a1 60 7e 11 00       	mov    0x117e60,%eax
  1003ed:	85 c0                	test   %eax,%eax
  1003ef:	74 02                	je     1003f3 <__panic+0x11>
        goto panic_dead;
  1003f1:	eb 48                	jmp    10043b <__panic+0x59>
    }
    is_panic = 1;
  1003f3:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  1003fa:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003fd:	8d 45 14             	lea    0x14(%ebp),%eax
  100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100403:	8b 45 0c             	mov    0xc(%ebp),%eax
  100406:	89 44 24 08          	mov    %eax,0x8(%esp)
  10040a:	8b 45 08             	mov    0x8(%ebp),%eax
  10040d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100411:	c7 04 24 6a 5c 10 00 	movl   $0x105c6a,(%esp)
  100418:	e8 6e fe ff ff       	call   10028b <cprintf>
    vcprintf(fmt, ap);
  10041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100420:	89 44 24 04          	mov    %eax,0x4(%esp)
  100424:	8b 45 10             	mov    0x10(%ebp),%eax
  100427:	89 04 24             	mov    %eax,(%esp)
  10042a:	e8 29 fe ff ff       	call   100258 <vcprintf>
    cprintf("\n");
  10042f:	c7 04 24 86 5c 10 00 	movl   $0x105c86,(%esp)
  100436:	e8 50 fe ff ff       	call   10028b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  10043b:	e8 75 13 00 00       	call   1017b5 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100440:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100447:	e8 a0 07 00 00       	call   100bec <kmonitor>
    }
  10044c:	eb f2                	jmp    100440 <__panic+0x5e>

0010044e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10044e:	55                   	push   %ebp
  10044f:	89 e5                	mov    %esp,%ebp
  100451:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100454:	8d 45 14             	lea    0x14(%ebp),%eax
  100457:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10045d:	89 44 24 08          	mov    %eax,0x8(%esp)
  100461:	8b 45 08             	mov    0x8(%ebp),%eax
  100464:	89 44 24 04          	mov    %eax,0x4(%esp)
  100468:	c7 04 24 88 5c 10 00 	movl   $0x105c88,(%esp)
  10046f:	e8 17 fe ff ff       	call   10028b <cprintf>
    vcprintf(fmt, ap);
  100474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100477:	89 44 24 04          	mov    %eax,0x4(%esp)
  10047b:	8b 45 10             	mov    0x10(%ebp),%eax
  10047e:	89 04 24             	mov    %eax,(%esp)
  100481:	e8 d2 fd ff ff       	call   100258 <vcprintf>
    cprintf("\n");
  100486:	c7 04 24 86 5c 10 00 	movl   $0x105c86,(%esp)
  10048d:	e8 f9 fd ff ff       	call   10028b <cprintf>
    va_end(ap);
}
  100492:	c9                   	leave  
  100493:	c3                   	ret    

00100494 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100494:	55                   	push   %ebp
  100495:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100497:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  10049c:	5d                   	pop    %ebp
  10049d:	c3                   	ret    

0010049e <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10049e:	55                   	push   %ebp
  10049f:	89 e5                	mov    %esp,%ebp
  1004a1:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a7:	8b 00                	mov    (%eax),%eax
  1004a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1004af:	8b 00                	mov    (%eax),%eax
  1004b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004bb:	e9 d2 00 00 00       	jmp    100592 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004c6:	01 d0                	add    %edx,%eax
  1004c8:	89 c2                	mov    %eax,%edx
  1004ca:	c1 ea 1f             	shr    $0x1f,%edx
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	d1 f8                	sar    %eax
  1004d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d7:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004da:	eb 04                	jmp    1004e0 <stab_binsearch+0x42>
            m --;
  1004dc:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e6:	7c 1f                	jl     100507 <stab_binsearch+0x69>
  1004e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004eb:	89 d0                	mov    %edx,%eax
  1004ed:	01 c0                	add    %eax,%eax
  1004ef:	01 d0                	add    %edx,%eax
  1004f1:	c1 e0 02             	shl    $0x2,%eax
  1004f4:	89 c2                	mov    %eax,%edx
  1004f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f9:	01 d0                	add    %edx,%eax
  1004fb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004ff:	0f b6 c0             	movzbl %al,%eax
  100502:	3b 45 14             	cmp    0x14(%ebp),%eax
  100505:	75 d5                	jne    1004dc <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10050a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050d:	7d 0b                	jge    10051a <stab_binsearch+0x7c>
            l = true_m + 1;
  10050f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100512:	83 c0 01             	add    $0x1,%eax
  100515:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100518:	eb 78                	jmp    100592 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10051a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100521:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100524:	89 d0                	mov    %edx,%eax
  100526:	01 c0                	add    %eax,%eax
  100528:	01 d0                	add    %edx,%eax
  10052a:	c1 e0 02             	shl    $0x2,%eax
  10052d:	89 c2                	mov    %eax,%edx
  10052f:	8b 45 08             	mov    0x8(%ebp),%eax
  100532:	01 d0                	add    %edx,%eax
  100534:	8b 40 08             	mov    0x8(%eax),%eax
  100537:	3b 45 18             	cmp    0x18(%ebp),%eax
  10053a:	73 13                	jae    10054f <stab_binsearch+0xb1>
            *region_left = m;
  10053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100542:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100544:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100547:	83 c0 01             	add    $0x1,%eax
  10054a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10054d:	eb 43                	jmp    100592 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100552:	89 d0                	mov    %edx,%eax
  100554:	01 c0                	add    %eax,%eax
  100556:	01 d0                	add    %edx,%eax
  100558:	c1 e0 02             	shl    $0x2,%eax
  10055b:	89 c2                	mov    %eax,%edx
  10055d:	8b 45 08             	mov    0x8(%ebp),%eax
  100560:	01 d0                	add    %edx,%eax
  100562:	8b 40 08             	mov    0x8(%eax),%eax
  100565:	3b 45 18             	cmp    0x18(%ebp),%eax
  100568:	76 16                	jbe    100580 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10056a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100570:	8b 45 10             	mov    0x10(%ebp),%eax
  100573:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	83 e8 01             	sub    $0x1,%eax
  10057b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10057e:	eb 12                	jmp    100592 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100580:	8b 45 0c             	mov    0xc(%ebp),%eax
  100583:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100586:	89 10                	mov    %edx,(%eax)
            l = m;
  100588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10058e:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100592:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100595:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100598:	0f 8e 22 ff ff ff    	jle    1004c0 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10059e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005a2:	75 0f                	jne    1005b3 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a7:	8b 00                	mov    (%eax),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
  1005b1:	eb 3f                	jmp    1005f2 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b6:	8b 00                	mov    (%eax),%eax
  1005b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005bb:	eb 04                	jmp    1005c1 <stab_binsearch+0x123>
  1005bd:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c4:	8b 00                	mov    (%eax),%eax
  1005c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005c9:	7d 1f                	jge    1005ea <stab_binsearch+0x14c>
  1005cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005ce:	89 d0                	mov    %edx,%eax
  1005d0:	01 c0                	add    %eax,%eax
  1005d2:	01 d0                	add    %edx,%eax
  1005d4:	c1 e0 02             	shl    $0x2,%eax
  1005d7:	89 c2                	mov    %eax,%edx
  1005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dc:	01 d0                	add    %edx,%eax
  1005de:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005e2:	0f b6 c0             	movzbl %al,%eax
  1005e5:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005e8:	75 d3                	jne    1005bd <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f0:	89 10                	mov    %edx,(%eax)
    }
}
  1005f2:	c9                   	leave  
  1005f3:	c3                   	ret    

001005f4 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005f4:	55                   	push   %ebp
  1005f5:	89 e5                	mov    %esp,%ebp
  1005f7:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fd:	c7 00 a8 5c 10 00    	movl   $0x105ca8,(%eax)
    info->eip_line = 0;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	c7 40 08 a8 5c 10 00 	movl   $0x105ca8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100617:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061a:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100621:	8b 45 0c             	mov    0xc(%ebp),%eax
  100624:	8b 55 08             	mov    0x8(%ebp),%edx
  100627:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100634:	c7 45 f4 80 6e 10 00 	movl   $0x106e80,-0xc(%ebp)
    stab_end = __STAB_END__;
  10063b:	c7 45 f0 14 16 11 00 	movl   $0x111614,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100642:	c7 45 ec 15 16 11 00 	movl   $0x111615,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100649:	c7 45 e8 0f 40 11 00 	movl   $0x11400f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100653:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100656:	76 0d                	jbe    100665 <debuginfo_eip+0x71>
  100658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10065b:	83 e8 01             	sub    $0x1,%eax
  10065e:	0f b6 00             	movzbl (%eax),%eax
  100661:	84 c0                	test   %al,%al
  100663:	74 0a                	je     10066f <debuginfo_eip+0x7b>
        return -1;
  100665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10066a:	e9 c0 02 00 00       	jmp    10092f <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10066f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100676:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067c:	29 c2                	sub    %eax,%edx
  10067e:	89 d0                	mov    %edx,%eax
  100680:	c1 f8 02             	sar    $0x2,%eax
  100683:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100689:	83 e8 01             	sub    $0x1,%eax
  10068c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10068f:	8b 45 08             	mov    0x8(%ebp),%eax
  100692:	89 44 24 10          	mov    %eax,0x10(%esp)
  100696:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10069d:	00 
  10069e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006af:	89 04 24             	mov    %eax,(%esp)
  1006b2:	e8 e7 fd ff ff       	call   10049e <stab_binsearch>
    if (lfile == 0)
  1006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ba:	85 c0                	test   %eax,%eax
  1006bc:	75 0a                	jne    1006c8 <debuginfo_eip+0xd4>
        return -1;
  1006be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c3:	e9 67 02 00 00       	jmp    10092f <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006db:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e2:	00 
  1006e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f4:	89 04 24             	mov    %eax,(%esp)
  1006f7:	e8 a2 fd ff ff       	call   10049e <stab_binsearch>

    if (lfun <= rfun) {
  1006fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100702:	39 c2                	cmp    %eax,%edx
  100704:	7f 7c                	jg     100782 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100706:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100709:	89 c2                	mov    %eax,%edx
  10070b:	89 d0                	mov    %edx,%eax
  10070d:	01 c0                	add    %eax,%eax
  10070f:	01 d0                	add    %edx,%eax
  100711:	c1 e0 02             	shl    $0x2,%eax
  100714:	89 c2                	mov    %eax,%edx
  100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100719:	01 d0                	add    %edx,%eax
  10071b:	8b 10                	mov    (%eax),%edx
  10071d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100723:	29 c1                	sub    %eax,%ecx
  100725:	89 c8                	mov    %ecx,%eax
  100727:	39 c2                	cmp    %eax,%edx
  100729:	73 22                	jae    10074d <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072e:	89 c2                	mov    %eax,%edx
  100730:	89 d0                	mov    %edx,%eax
  100732:	01 c0                	add    %eax,%eax
  100734:	01 d0                	add    %edx,%eax
  100736:	c1 e0 02             	shl    $0x2,%eax
  100739:	89 c2                	mov    %eax,%edx
  10073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	8b 10                	mov    (%eax),%edx
  100742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100745:	01 c2                	add    %eax,%edx
  100747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10074d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100750:	89 c2                	mov    %eax,%edx
  100752:	89 d0                	mov    %edx,%eax
  100754:	01 c0                	add    %eax,%eax
  100756:	01 d0                	add    %edx,%eax
  100758:	c1 e0 02             	shl    $0x2,%eax
  10075b:	89 c2                	mov    %eax,%edx
  10075d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100760:	01 d0                	add    %edx,%eax
  100762:	8b 50 08             	mov    0x8(%eax),%edx
  100765:	8b 45 0c             	mov    0xc(%ebp),%eax
  100768:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10076b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076e:	8b 40 10             	mov    0x10(%eax),%eax
  100771:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100777:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10077a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10077d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100780:	eb 15                	jmp    100797 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100782:	8b 45 0c             	mov    0xc(%ebp),%eax
  100785:	8b 55 08             	mov    0x8(%ebp),%edx
  100788:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100791:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100794:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007a4:	00 
  1007a5:	89 04 24             	mov    %eax,(%esp)
  1007a8:	e8 5f 4a 00 00       	call   10520c <strfind>
  1007ad:	89 c2                	mov    %eax,%edx
  1007af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b2:	8b 40 08             	mov    0x8(%eax),%eax
  1007b5:	29 c2                	sub    %eax,%edx
  1007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ba:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007c4:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007cb:	00 
  1007cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007d3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	89 04 24             	mov    %eax,(%esp)
  1007e0:	e8 b9 fc ff ff       	call   10049e <stab_binsearch>
    if (lline <= rline) {
  1007e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007eb:	39 c2                	cmp    %eax,%edx
  1007ed:	7f 24                	jg     100813 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f2:	89 c2                	mov    %eax,%edx
  1007f4:	89 d0                	mov    %edx,%eax
  1007f6:	01 c0                	add    %eax,%eax
  1007f8:	01 d0                	add    %edx,%eax
  1007fa:	c1 e0 02             	shl    $0x2,%eax
  1007fd:	89 c2                	mov    %eax,%edx
  1007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100802:	01 d0                	add    %edx,%eax
  100804:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100808:	0f b7 d0             	movzwl %ax,%edx
  10080b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100811:	eb 13                	jmp    100826 <debuginfo_eip+0x232>
        return -1;
  100813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100818:	e9 12 01 00 00       	jmp    10092f <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	83 e8 01             	sub    $0x1,%eax
  100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10082c:	39 c2                	cmp    %eax,%edx
  10082e:	7c 56                	jl     100886 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100833:	89 c2                	mov    %eax,%edx
  100835:	89 d0                	mov    %edx,%eax
  100837:	01 c0                	add    %eax,%eax
  100839:	01 d0                	add    %edx,%eax
  10083b:	c1 e0 02             	shl    $0x2,%eax
  10083e:	89 c2                	mov    %eax,%edx
  100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100843:	01 d0                	add    %edx,%eax
  100845:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100849:	3c 84                	cmp    $0x84,%al
  10084b:	74 39                	je     100886 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	89 c2                	mov    %eax,%edx
  100852:	89 d0                	mov    %edx,%eax
  100854:	01 c0                	add    %eax,%eax
  100856:	01 d0                	add    %edx,%eax
  100858:	c1 e0 02             	shl    $0x2,%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100860:	01 d0                	add    %edx,%eax
  100862:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100866:	3c 64                	cmp    $0x64,%al
  100868:	75 b3                	jne    10081d <debuginfo_eip+0x229>
  10086a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086d:	89 c2                	mov    %eax,%edx
  10086f:	89 d0                	mov    %edx,%eax
  100871:	01 c0                	add    %eax,%eax
  100873:	01 d0                	add    %edx,%eax
  100875:	c1 e0 02             	shl    $0x2,%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087d:	01 d0                	add    %edx,%eax
  10087f:	8b 40 08             	mov    0x8(%eax),%eax
  100882:	85 c0                	test   %eax,%eax
  100884:	74 97                	je     10081d <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088c:	39 c2                	cmp    %eax,%edx
  10088e:	7c 46                	jl     1008d6 <debuginfo_eip+0x2e2>
  100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100893:	89 c2                	mov    %eax,%edx
  100895:	89 d0                	mov    %edx,%eax
  100897:	01 c0                	add    %eax,%eax
  100899:	01 d0                	add    %edx,%eax
  10089b:	c1 e0 02             	shl    $0x2,%eax
  10089e:	89 c2                	mov    %eax,%edx
  1008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	8b 10                	mov    (%eax),%edx
  1008a7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008ad:	29 c1                	sub    %eax,%ecx
  1008af:	89 c8                	mov    %ecx,%eax
  1008b1:	39 c2                	cmp    %eax,%edx
  1008b3:	73 21                	jae    1008d6 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b8:	89 c2                	mov    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	01 c0                	add    %eax,%eax
  1008be:	01 d0                	add    %edx,%eax
  1008c0:	c1 e0 02             	shl    $0x2,%eax
  1008c3:	89 c2                	mov    %eax,%edx
  1008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c8:	01 d0                	add    %edx,%eax
  1008ca:	8b 10                	mov    (%eax),%edx
  1008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008cf:	01 c2                	add    %eax,%edx
  1008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008dc:	39 c2                	cmp    %eax,%edx
  1008de:	7d 4a                	jge    10092a <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e3:	83 c0 01             	add    $0x1,%eax
  1008e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008e9:	eb 18                	jmp    100903 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ee:	8b 40 14             	mov    0x14(%eax),%eax
  1008f1:	8d 50 01             	lea    0x1(%eax),%edx
  1008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f7:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008fd:	83 c0 01             	add    $0x1,%eax
  100900:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100903:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100906:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100909:	39 c2                	cmp    %eax,%edx
  10090b:	7d 1d                	jge    10092a <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100910:	89 c2                	mov    %eax,%edx
  100912:	89 d0                	mov    %edx,%eax
  100914:	01 c0                	add    %eax,%eax
  100916:	01 d0                	add    %edx,%eax
  100918:	c1 e0 02             	shl    $0x2,%eax
  10091b:	89 c2                	mov    %eax,%edx
  10091d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100920:	01 d0                	add    %edx,%eax
  100922:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100926:	3c a0                	cmp    $0xa0,%al
  100928:	74 c1                	je     1008eb <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  10092a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10092f:	c9                   	leave  
  100930:	c3                   	ret    

00100931 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100931:	55                   	push   %ebp
  100932:	89 e5                	mov    %esp,%ebp
  100934:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100937:	c7 04 24 b2 5c 10 00 	movl   $0x105cb2,(%esp)
  10093e:	e8 48 f9 ff ff       	call   10028b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100943:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  10094a:	00 
  10094b:	c7 04 24 cb 5c 10 00 	movl   $0x105ccb,(%esp)
  100952:	e8 34 f9 ff ff       	call   10028b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100957:	c7 44 24 04 a2 5b 10 	movl   $0x105ba2,0x4(%esp)
  10095e:	00 
  10095f:	c7 04 24 e3 5c 10 00 	movl   $0x105ce3,(%esp)
  100966:	e8 20 f9 ff ff       	call   10028b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10096b:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100972:	00 
  100973:	c7 04 24 fb 5c 10 00 	movl   $0x105cfb,(%esp)
  10097a:	e8 0c f9 ff ff       	call   10028b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  10097f:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  100986:	00 
  100987:	c7 04 24 13 5d 10 00 	movl   $0x105d13,(%esp)
  10098e:	e8 f8 f8 ff ff       	call   10028b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100993:	b8 68 89 11 00       	mov    $0x118968,%eax
  100998:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10099e:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1009a3:	29 c2                	sub    %eax,%edx
  1009a5:	89 d0                	mov    %edx,%eax
  1009a7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009ad:	85 c0                	test   %eax,%eax
  1009af:	0f 48 c2             	cmovs  %edx,%eax
  1009b2:	c1 f8 0a             	sar    $0xa,%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	c7 04 24 2c 5d 10 00 	movl   $0x105d2c,(%esp)
  1009c0:	e8 c6 f8 ff ff       	call   10028b <cprintf>
}
  1009c5:	c9                   	leave  
  1009c6:	c3                   	ret    

001009c7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009c7:	55                   	push   %ebp
  1009c8:	89 e5                	mov    %esp,%ebp
  1009ca:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1009da:	89 04 24             	mov    %eax,(%esp)
  1009dd:	e8 12 fc ff ff       	call   1005f4 <debuginfo_eip>
  1009e2:	85 c0                	test   %eax,%eax
  1009e4:	74 15                	je     1009fb <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 56 5d 10 00 	movl   $0x105d56,(%esp)
  1009f4:	e8 92 f8 ff ff       	call   10028b <cprintf>
  1009f9:	eb 6d                	jmp    100a68 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a02:	eb 1c                	jmp    100a20 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0a:	01 d0                	add    %edx,%eax
  100a0c:	0f b6 00             	movzbl (%eax),%eax
  100a0f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a18:	01 ca                	add    %ecx,%edx
  100a1a:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a26:	7f dc                	jg     100a04 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a28:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a31:	01 d0                	add    %edx,%eax
  100a33:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a39:	8b 55 08             	mov    0x8(%ebp),%edx
  100a3c:	89 d1                	mov    %edx,%ecx
  100a3e:	29 c1                	sub    %eax,%ecx
  100a40:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a43:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a46:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a4a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a50:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a54:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5c:	c7 04 24 72 5d 10 00 	movl   $0x105d72,(%esp)
  100a63:	e8 23 f8 ff ff       	call   10028b <cprintf>
    }
}
  100a68:	c9                   	leave  
  100a69:	c3                   	ret    

00100a6a <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a6a:	55                   	push   %ebp
  100a6b:	89 e5                	mov    %esp,%ebp
  100a6d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a70:	8b 45 04             	mov    0x4(%ebp),%eax
  100a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a79:	c9                   	leave  
  100a7a:	c3                   	ret    

00100a7b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a7b:	55                   	push   %ebp
  100a7c:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a7e:	5d                   	pop    %ebp
  100a7f:	c3                   	ret    

00100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a80:	55                   	push   %ebp
  100a81:	89 e5                	mov    %esp,%ebp
  100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8d:	eb 0c                	jmp    100a9b <parse+0x1b>
            *buf ++ = '\0';
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	8d 50 01             	lea    0x1(%eax),%edx
  100a95:	89 55 08             	mov    %edx,0x8(%ebp)
  100a98:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 1d                	je     100ac2 <parse+0x42>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab2:	c7 04 24 04 5e 10 00 	movl   $0x105e04,(%esp)
  100ab9:	e8 1b 47 00 00       	call   1051d9 <strchr>
  100abe:	85 c0                	test   %eax,%eax
  100ac0:	75 cd                	jne    100a8f <parse+0xf>
        }
        if (*buf == '\0') {
  100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac5:	0f b6 00             	movzbl (%eax),%eax
  100ac8:	84 c0                	test   %al,%al
  100aca:	75 02                	jne    100ace <parse+0x4e>
            break;
  100acc:	eb 67                	jmp    100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad2:	75 14                	jne    100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adb:	00 
  100adc:	c7 04 24 09 5e 10 00 	movl   $0x105e09,(%esp)
  100ae3:	e8 a3 f7 ff ff       	call   10028b <cprintf>
        }
        argv[argc ++] = buf;
  100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aeb:	8d 50 01             	lea    0x1(%eax),%edx
  100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afb:	01 c2                	add    %eax,%edx
  100afd:	8b 45 08             	mov    0x8(%ebp),%eax
  100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b02:	eb 04                	jmp    100b08 <parse+0x88>
            buf ++;
  100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1d                	je     100b2f <parse+0xaf>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 04 5e 10 00 	movl   $0x105e04,(%esp)
  100b26:	e8 ae 46 00 00       	call   1051d9 <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d5                	je     100b04 <parse+0x84>
        }
    }
  100b2f:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b30:	e9 66 ff ff ff       	jmp    100a9b <parse+0x1b>
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	c9                   	leave  
  100b39:	c3                   	ret    

00100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3a:	55                   	push   %ebp
  100b3b:	89 e5                	mov    %esp,%ebp
  100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	89 04 24             	mov    %eax,(%esp)
  100b4d:	e8 2e ff ff ff       	call   100a80 <parse>
  100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b59:	75 0a                	jne    100b65 <runcmd+0x2b>
        return 0;
  100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b60:	e9 85 00 00 00       	jmp    100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6c:	eb 5c                	jmp    100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b74:	89 d0                	mov    %edx,%eax
  100b76:	01 c0                	add    %eax,%eax
  100b78:	01 d0                	add    %edx,%eax
  100b7a:	c1 e0 02             	shl    $0x2,%eax
  100b7d:	05 20 70 11 00       	add    $0x117020,%eax
  100b82:	8b 00                	mov    (%eax),%eax
  100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b88:	89 04 24             	mov    %eax,(%esp)
  100b8b:	e8 aa 45 00 00       	call   10513a <strcmp>
  100b90:	85 c0                	test   %eax,%eax
  100b92:	75 32                	jne    100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b97:	89 d0                	mov    %edx,%eax
  100b99:	01 c0                	add    %eax,%eax
  100b9b:	01 d0                	add    %edx,%eax
  100b9d:	c1 e0 02             	shl    $0x2,%eax
  100ba0:	05 20 70 11 00       	add    $0x117020,%eax
  100ba5:	8b 40 08             	mov    0x8(%eax),%eax
  100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb8:	83 c2 04             	add    $0x4,%edx
  100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbf:	89 0c 24             	mov    %ecx,(%esp)
  100bc2:	ff d0                	call   *%eax
  100bc4:	eb 24                	jmp    100bea <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcd:	83 f8 02             	cmp    $0x2,%eax
  100bd0:	76 9c                	jbe    100b6e <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd9:	c7 04 24 27 5e 10 00 	movl   $0x105e27,(%esp)
  100be0:	e8 a6 f6 ff ff       	call   10028b <cprintf>
    return 0;
  100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf2:	c7 04 24 40 5e 10 00 	movl   $0x105e40,(%esp)
  100bf9:	e8 8d f6 ff ff       	call   10028b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfe:	c7 04 24 68 5e 10 00 	movl   $0x105e68,(%esp)
  100c05:	e8 81 f6 ff ff       	call   10028b <cprintf>

    if (tf != NULL) {
  100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0e:	74 0b                	je     100c1b <kmonitor+0x2f>
        print_trapframe(tf);
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 08 0c 00 00       	call   101823 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1b:	c7 04 24 8d 5e 10 00 	movl   $0x105e8d,(%esp)
  100c22:	e8 05 f7 ff ff       	call   10032c <readline>
  100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2e:	74 18                	je     100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c30:	8b 45 08             	mov    0x8(%ebp),%eax
  100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	89 04 24             	mov    %eax,(%esp)
  100c3d:	e8 f8 fe ff ff       	call   100b3a <runcmd>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	79 02                	jns    100c48 <kmonitor+0x5c>
                break;
  100c46:	eb 02                	jmp    100c4a <kmonitor+0x5e>
            }
        }
    }
  100c48:	eb d1                	jmp    100c1b <kmonitor+0x2f>
}
  100c4a:	c9                   	leave  
  100c4b:	c3                   	ret    

00100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c59:	eb 3f                	jmp    100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 20 70 11 00       	add    $0x117020,%eax
  100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c72:	89 d0                	mov    %edx,%eax
  100c74:	01 c0                	add    %eax,%eax
  100c76:	01 d0                	add    %edx,%eax
  100c78:	c1 e0 02             	shl    $0x2,%eax
  100c7b:	05 20 70 11 00       	add    $0x117020,%eax
  100c80:	8b 00                	mov    (%eax),%eax
  100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8a:	c7 04 24 91 5e 10 00 	movl   $0x105e91,(%esp)
  100c91:	e8 f5 f5 ff ff       	call   10028b <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9d:	83 f8 02             	cmp    $0x2,%eax
  100ca0:	76 b9                	jbe    100c5b <mon_help+0xf>
    }
    return 0;
  100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca7:	c9                   	leave  
  100ca8:	c3                   	ret    

00100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca9:	55                   	push   %ebp
  100caa:	89 e5                	mov    %esp,%ebp
  100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100caf:	e8 7d fc ff ff       	call   100931 <print_kerninfo>
    return 0;
  100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc1:	e8 b5 fd ff ff       	call   100a7b <print_stackframe>
    return 0;
  100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccb:	c9                   	leave  
  100ccc:	c3                   	ret    

00100ccd <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100ccd:	55                   	push   %ebp
  100cce:	89 e5                	mov    %esp,%ebp
  100cd0:	83 ec 28             	sub    $0x28,%esp
  100cd3:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100cd9:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100cdd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ce1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ce5:	ee                   	out    %al,(%dx)
  100ce6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100cec:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100cf0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100cf4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100cf8:	ee                   	out    %al,(%dx)
  100cf9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100cff:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d03:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d07:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d0b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d0c:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100d13:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d16:	c7 04 24 9a 5e 10 00 	movl   $0x105e9a,(%esp)
  100d1d:	e8 69 f5 ff ff       	call   10028b <cprintf>
    pic_enable(IRQ_TIMER);
  100d22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d29:	e8 18 09 00 00       	call   101646 <pic_enable>
}
  100d2e:	c9                   	leave  
  100d2f:	c3                   	ret    

00100d30 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100d36:	9c                   	pushf  
  100d37:	58                   	pop    %eax
  100d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100d3e:	25 00 02 00 00       	and    $0x200,%eax
  100d43:	85 c0                	test   %eax,%eax
  100d45:	74 0c                	je     100d53 <__intr_save+0x23>
        intr_disable();
  100d47:	e8 69 0a 00 00       	call   1017b5 <intr_disable>
        return 1;
  100d4c:	b8 01 00 00 00       	mov    $0x1,%eax
  100d51:	eb 05                	jmp    100d58 <__intr_save+0x28>
    }
    return 0;
  100d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d58:	c9                   	leave  
  100d59:	c3                   	ret    

00100d5a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100d5a:	55                   	push   %ebp
  100d5b:	89 e5                	mov    %esp,%ebp
  100d5d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d64:	74 05                	je     100d6b <__intr_restore+0x11>
        intr_enable();
  100d66:	e8 44 0a 00 00       	call   1017af <intr_enable>
    }
}
  100d6b:	c9                   	leave  
  100d6c:	c3                   	ret    

00100d6d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d6d:	55                   	push   %ebp
  100d6e:	89 e5                	mov    %esp,%ebp
  100d70:	83 ec 10             	sub    $0x10,%esp
  100d73:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100d79:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d7d:	89 c2                	mov    %eax,%edx
  100d7f:	ec                   	in     (%dx),%al
  100d80:	88 45 fd             	mov    %al,-0x3(%ebp)
  100d83:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d89:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d8d:	89 c2                	mov    %eax,%edx
  100d8f:	ec                   	in     (%dx),%al
  100d90:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d93:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100d99:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100d9d:	89 c2                	mov    %eax,%edx
  100d9f:	ec                   	in     (%dx),%al
  100da0:	88 45 f5             	mov    %al,-0xb(%ebp)
  100da3:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100da9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dad:	89 c2                	mov    %eax,%edx
  100daf:	ec                   	in     (%dx),%al
  100db0:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100db3:	c9                   	leave  
  100db4:	c3                   	ret    

00100db5 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100db5:	55                   	push   %ebp
  100db6:	89 e5                	mov    %esp,%ebp
  100db8:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100dbb:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dc5:	0f b7 00             	movzwl (%eax),%eax
  100dc8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dcf:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dd7:	0f b7 00             	movzwl (%eax),%eax
  100dda:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100dde:	74 12                	je     100df2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100de0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100de7:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100dee:	b4 03 
  100df0:	eb 13                	jmp    100e05 <cga_init+0x50>
    } else {
        *cp = was;
  100df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100df9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100dfc:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e05:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e0c:	0f b7 c0             	movzwl %ax,%eax
  100e0f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e13:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e17:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e1b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e1f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e20:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e27:	83 c0 01             	add    $0x1,%eax
  100e2a:	0f b7 c0             	movzwl %ax,%eax
  100e2d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e31:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e35:	89 c2                	mov    %eax,%edx
  100e37:	ec                   	in     (%dx),%al
  100e38:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e3b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e3f:	0f b6 c0             	movzbl %al,%eax
  100e42:	c1 e0 08             	shl    $0x8,%eax
  100e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e48:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e4f:	0f b7 c0             	movzwl %ax,%eax
  100e52:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e56:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e5a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e5e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e62:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e63:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100e6a:	83 c0 01             	add    $0x1,%eax
  100e6d:	0f b7 c0             	movzwl %ax,%eax
  100e70:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e74:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100e78:	89 c2                	mov    %eax,%edx
  100e7a:	ec                   	in     (%dx),%al
  100e7b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100e7e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e82:	0f b6 c0             	movzbl %al,%eax
  100e85:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e93:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100e99:	c9                   	leave  
  100e9a:	c3                   	ret    

00100e9b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e9b:	55                   	push   %ebp
  100e9c:	89 e5                	mov    %esp,%ebp
  100e9e:	83 ec 48             	sub    $0x48,%esp
  100ea1:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ea7:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100eaf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eb3:	ee                   	out    %al,(%dx)
  100eb4:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100eba:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ebe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ec2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ec6:	ee                   	out    %al,(%dx)
  100ec7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100ecd:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100ed1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ed9:	ee                   	out    %al,(%dx)
  100eda:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100ee0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100ee4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eec:	ee                   	out    %al,(%dx)
  100eed:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100ef3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100ef7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100efb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100eff:	ee                   	out    %al,(%dx)
  100f00:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f06:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f0a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f0e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f12:	ee                   	out    %al,(%dx)
  100f13:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f19:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f1d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f21:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f25:	ee                   	out    %al,(%dx)
  100f26:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f30:	89 c2                	mov    %eax,%edx
  100f32:	ec                   	in     (%dx),%al
  100f33:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f36:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f3a:	3c ff                	cmp    $0xff,%al
  100f3c:	0f 95 c0             	setne  %al
  100f3f:	0f b6 c0             	movzbl %al,%eax
  100f42:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100f47:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f4d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f51:	89 c2                	mov    %eax,%edx
  100f53:	ec                   	in     (%dx),%al
  100f54:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f57:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f5d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f61:	89 c2                	mov    %eax,%edx
  100f63:	ec                   	in     (%dx),%al
  100f64:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f67:	a1 88 7e 11 00       	mov    0x117e88,%eax
  100f6c:	85 c0                	test   %eax,%eax
  100f6e:	74 0c                	je     100f7c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100f70:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f77:	e8 ca 06 00 00       	call   101646 <pic_enable>
    }
}
  100f7c:	c9                   	leave  
  100f7d:	c3                   	ret    

00100f7e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f7e:	55                   	push   %ebp
  100f7f:	89 e5                	mov    %esp,%ebp
  100f81:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f8b:	eb 09                	jmp    100f96 <lpt_putc_sub+0x18>
        delay();
  100f8d:	e8 db fd ff ff       	call   100d6d <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f96:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100f9c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fa0:	89 c2                	mov    %eax,%edx
  100fa2:	ec                   	in     (%dx),%al
  100fa3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fa6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100faa:	84 c0                	test   %al,%al
  100fac:	78 09                	js     100fb7 <lpt_putc_sub+0x39>
  100fae:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fb5:	7e d6                	jle    100f8d <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  100fba:	0f b6 c0             	movzbl %al,%eax
  100fbd:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100fc3:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fca:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fce:	ee                   	out    %al,(%dx)
  100fcf:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fd5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fd9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fdd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fe1:	ee                   	out    %al,(%dx)
  100fe2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  100fe8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  100fec:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ff0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ff4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100ff5:	c9                   	leave  
  100ff6:	c3                   	ret    

00100ff7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100ff7:	55                   	push   %ebp
  100ff8:	89 e5                	mov    %esp,%ebp
  100ffa:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  100ffd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101001:	74 0d                	je     101010 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101003:	8b 45 08             	mov    0x8(%ebp),%eax
  101006:	89 04 24             	mov    %eax,(%esp)
  101009:	e8 70 ff ff ff       	call   100f7e <lpt_putc_sub>
  10100e:	eb 24                	jmp    101034 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101010:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101017:	e8 62 ff ff ff       	call   100f7e <lpt_putc_sub>
        lpt_putc_sub(' ');
  10101c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101023:	e8 56 ff ff ff       	call   100f7e <lpt_putc_sub>
        lpt_putc_sub('\b');
  101028:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10102f:	e8 4a ff ff ff       	call   100f7e <lpt_putc_sub>
    }
}
  101034:	c9                   	leave  
  101035:	c3                   	ret    

00101036 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101036:	55                   	push   %ebp
  101037:	89 e5                	mov    %esp,%ebp
  101039:	53                   	push   %ebx
  10103a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10103d:	8b 45 08             	mov    0x8(%ebp),%eax
  101040:	b0 00                	mov    $0x0,%al
  101042:	85 c0                	test   %eax,%eax
  101044:	75 07                	jne    10104d <cga_putc+0x17>
        c |= 0x0700;
  101046:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10104d:	8b 45 08             	mov    0x8(%ebp),%eax
  101050:	0f b6 c0             	movzbl %al,%eax
  101053:	83 f8 0a             	cmp    $0xa,%eax
  101056:	74 4c                	je     1010a4 <cga_putc+0x6e>
  101058:	83 f8 0d             	cmp    $0xd,%eax
  10105b:	74 57                	je     1010b4 <cga_putc+0x7e>
  10105d:	83 f8 08             	cmp    $0x8,%eax
  101060:	0f 85 88 00 00 00    	jne    1010ee <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101066:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10106d:	66 85 c0             	test   %ax,%ax
  101070:	74 30                	je     1010a2 <cga_putc+0x6c>
            crt_pos --;
  101072:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101079:	83 e8 01             	sub    $0x1,%eax
  10107c:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101082:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101087:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10108e:	0f b7 d2             	movzwl %dx,%edx
  101091:	01 d2                	add    %edx,%edx
  101093:	01 c2                	add    %eax,%edx
  101095:	8b 45 08             	mov    0x8(%ebp),%eax
  101098:	b0 00                	mov    $0x0,%al
  10109a:	83 c8 20             	or     $0x20,%eax
  10109d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010a0:	eb 72                	jmp    101114 <cga_putc+0xde>
  1010a2:	eb 70                	jmp    101114 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010a4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010ab:	83 c0 50             	add    $0x50,%eax
  1010ae:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010b4:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  1010bb:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  1010c2:	0f b7 c1             	movzwl %cx,%eax
  1010c5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010cb:	c1 e8 10             	shr    $0x10,%eax
  1010ce:	89 c2                	mov    %eax,%edx
  1010d0:	66 c1 ea 06          	shr    $0x6,%dx
  1010d4:	89 d0                	mov    %edx,%eax
  1010d6:	c1 e0 02             	shl    $0x2,%eax
  1010d9:	01 d0                	add    %edx,%eax
  1010db:	c1 e0 04             	shl    $0x4,%eax
  1010de:	29 c1                	sub    %eax,%ecx
  1010e0:	89 ca                	mov    %ecx,%edx
  1010e2:	89 d8                	mov    %ebx,%eax
  1010e4:	29 d0                	sub    %edx,%eax
  1010e6:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1010ec:	eb 26                	jmp    101114 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010ee:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1010f4:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1010fb:	8d 50 01             	lea    0x1(%eax),%edx
  1010fe:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  101105:	0f b7 c0             	movzwl %ax,%eax
  101108:	01 c0                	add    %eax,%eax
  10110a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10110d:	8b 45 08             	mov    0x8(%ebp),%eax
  101110:	66 89 02             	mov    %ax,(%edx)
        break;
  101113:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101114:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10111b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10111f:	76 5b                	jbe    10117c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101121:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101126:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10112c:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101131:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101138:	00 
  101139:	89 54 24 04          	mov    %edx,0x4(%esp)
  10113d:	89 04 24             	mov    %eax,(%esp)
  101140:	e8 92 42 00 00       	call   1053d7 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101145:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10114c:	eb 15                	jmp    101163 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10114e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101153:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101156:	01 d2                	add    %edx,%edx
  101158:	01 d0                	add    %edx,%eax
  10115a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10115f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101163:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10116a:	7e e2                	jle    10114e <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  10116c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101173:	83 e8 50             	sub    $0x50,%eax
  101176:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10117c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101183:	0f b7 c0             	movzwl %ax,%eax
  101186:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10118a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10118e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101192:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101196:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101197:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10119e:	66 c1 e8 08          	shr    $0x8,%ax
  1011a2:	0f b6 c0             	movzbl %al,%eax
  1011a5:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1011ac:	83 c2 01             	add    $0x1,%edx
  1011af:	0f b7 d2             	movzwl %dx,%edx
  1011b2:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011b6:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011b9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011bd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011c1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011c2:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  1011c9:	0f b7 c0             	movzwl %ax,%eax
  1011cc:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011d0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1011d4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011d8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011dc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011dd:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011e4:	0f b6 c0             	movzbl %al,%eax
  1011e7:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1011ee:	83 c2 01             	add    $0x1,%edx
  1011f1:	0f b7 d2             	movzwl %dx,%edx
  1011f4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1011f8:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1011fb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011ff:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101203:	ee                   	out    %al,(%dx)
}
  101204:	83 c4 34             	add    $0x34,%esp
  101207:	5b                   	pop    %ebx
  101208:	5d                   	pop    %ebp
  101209:	c3                   	ret    

0010120a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10120a:	55                   	push   %ebp
  10120b:	89 e5                	mov    %esp,%ebp
  10120d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101217:	eb 09                	jmp    101222 <serial_putc_sub+0x18>
        delay();
  101219:	e8 4f fb ff ff       	call   100d6d <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10121e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101222:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101228:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10122c:	89 c2                	mov    %eax,%edx
  10122e:	ec                   	in     (%dx),%al
  10122f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101232:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101236:	0f b6 c0             	movzbl %al,%eax
  101239:	83 e0 20             	and    $0x20,%eax
  10123c:	85 c0                	test   %eax,%eax
  10123e:	75 09                	jne    101249 <serial_putc_sub+0x3f>
  101240:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101247:	7e d0                	jle    101219 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101249:	8b 45 08             	mov    0x8(%ebp),%eax
  10124c:	0f b6 c0             	movzbl %al,%eax
  10124f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101255:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101258:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10125c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101260:	ee                   	out    %al,(%dx)
}
  101261:	c9                   	leave  
  101262:	c3                   	ret    

00101263 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101263:	55                   	push   %ebp
  101264:	89 e5                	mov    %esp,%ebp
  101266:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101269:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10126d:	74 0d                	je     10127c <serial_putc+0x19>
        serial_putc_sub(c);
  10126f:	8b 45 08             	mov    0x8(%ebp),%eax
  101272:	89 04 24             	mov    %eax,(%esp)
  101275:	e8 90 ff ff ff       	call   10120a <serial_putc_sub>
  10127a:	eb 24                	jmp    1012a0 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10127c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101283:	e8 82 ff ff ff       	call   10120a <serial_putc_sub>
        serial_putc_sub(' ');
  101288:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10128f:	e8 76 ff ff ff       	call   10120a <serial_putc_sub>
        serial_putc_sub('\b');
  101294:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10129b:	e8 6a ff ff ff       	call   10120a <serial_putc_sub>
    }
}
  1012a0:	c9                   	leave  
  1012a1:	c3                   	ret    

001012a2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012a2:	55                   	push   %ebp
  1012a3:	89 e5                	mov    %esp,%ebp
  1012a5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012a8:	eb 33                	jmp    1012dd <cons_intr+0x3b>
        if (c != 0) {
  1012aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012ae:	74 2d                	je     1012dd <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012b0:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1012b5:	8d 50 01             	lea    0x1(%eax),%edx
  1012b8:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  1012be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012c1:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012c7:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1012cc:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012d1:	75 0a                	jne    1012dd <cons_intr+0x3b>
                cons.wpos = 0;
  1012d3:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  1012da:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e0:	ff d0                	call   *%eax
  1012e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012e9:	75 bf                	jne    1012aa <cons_intr+0x8>
            }
        }
    }
}
  1012eb:	c9                   	leave  
  1012ec:	c3                   	ret    

001012ed <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012ed:	55                   	push   %ebp
  1012ee:	89 e5                	mov    %esp,%ebp
  1012f0:	83 ec 10             	sub    $0x10,%esp
  1012f3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012f9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012fd:	89 c2                	mov    %eax,%edx
  1012ff:	ec                   	in     (%dx),%al
  101300:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101303:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101307:	0f b6 c0             	movzbl %al,%eax
  10130a:	83 e0 01             	and    $0x1,%eax
  10130d:	85 c0                	test   %eax,%eax
  10130f:	75 07                	jne    101318 <serial_proc_data+0x2b>
        return -1;
  101311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101316:	eb 2a                	jmp    101342 <serial_proc_data+0x55>
  101318:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10131e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101322:	89 c2                	mov    %eax,%edx
  101324:	ec                   	in     (%dx),%al
  101325:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101328:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10132c:	0f b6 c0             	movzbl %al,%eax
  10132f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101332:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101336:	75 07                	jne    10133f <serial_proc_data+0x52>
        c = '\b';
  101338:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101342:	c9                   	leave  
  101343:	c3                   	ret    

00101344 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101344:	55                   	push   %ebp
  101345:	89 e5                	mov    %esp,%ebp
  101347:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10134a:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10134f:	85 c0                	test   %eax,%eax
  101351:	74 0c                	je     10135f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101353:	c7 04 24 ed 12 10 00 	movl   $0x1012ed,(%esp)
  10135a:	e8 43 ff ff ff       	call   1012a2 <cons_intr>
    }
}
  10135f:	c9                   	leave  
  101360:	c3                   	ret    

00101361 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101361:	55                   	push   %ebp
  101362:	89 e5                	mov    %esp,%ebp
  101364:	83 ec 38             	sub    $0x38,%esp
  101367:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10136d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101371:	89 c2                	mov    %eax,%edx
  101373:	ec                   	in     (%dx),%al
  101374:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101377:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10137b:	0f b6 c0             	movzbl %al,%eax
  10137e:	83 e0 01             	and    $0x1,%eax
  101381:	85 c0                	test   %eax,%eax
  101383:	75 0a                	jne    10138f <kbd_proc_data+0x2e>
        return -1;
  101385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10138a:	e9 59 01 00 00       	jmp    1014e8 <kbd_proc_data+0x187>
  10138f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101395:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101399:	89 c2                	mov    %eax,%edx
  10139b:	ec                   	in     (%dx),%al
  10139c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10139f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013a3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013a6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013aa:	75 17                	jne    1013c3 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013ac:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013b1:	83 c8 40             	or     $0x40,%eax
  1013b4:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  1013be:	e9 25 01 00 00       	jmp    1014e8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1013c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013c7:	84 c0                	test   %al,%al
  1013c9:	79 47                	jns    101412 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013cb:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1013d0:	83 e0 40             	and    $0x40,%eax
  1013d3:	85 c0                	test   %eax,%eax
  1013d5:	75 09                	jne    1013e0 <kbd_proc_data+0x7f>
  1013d7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013db:	83 e0 7f             	and    $0x7f,%eax
  1013de:	eb 04                	jmp    1013e4 <kbd_proc_data+0x83>
  1013e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013e4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013eb:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1013f2:	83 c8 40             	or     $0x40,%eax
  1013f5:	0f b6 c0             	movzbl %al,%eax
  1013f8:	f7 d0                	not    %eax
  1013fa:	89 c2                	mov    %eax,%edx
  1013fc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101401:	21 d0                	and    %edx,%eax
  101403:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101408:	b8 00 00 00 00       	mov    $0x0,%eax
  10140d:	e9 d6 00 00 00       	jmp    1014e8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101412:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101417:	83 e0 40             	and    $0x40,%eax
  10141a:	85 c0                	test   %eax,%eax
  10141c:	74 11                	je     10142f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10141e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101422:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101427:	83 e0 bf             	and    $0xffffffbf,%eax
  10142a:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  10142f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101433:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  10143a:	0f b6 d0             	movzbl %al,%edx
  10143d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101442:	09 d0                	or     %edx,%eax
  101444:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101449:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144d:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101454:	0f b6 d0             	movzbl %al,%edx
  101457:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10145c:	31 d0                	xor    %edx,%eax
  10145e:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101463:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101468:	83 e0 03             	and    $0x3,%eax
  10146b:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101472:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101476:	01 d0                	add    %edx,%eax
  101478:	0f b6 00             	movzbl (%eax),%eax
  10147b:	0f b6 c0             	movzbl %al,%eax
  10147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101481:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101486:	83 e0 08             	and    $0x8,%eax
  101489:	85 c0                	test   %eax,%eax
  10148b:	74 22                	je     1014af <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10148d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101491:	7e 0c                	jle    10149f <kbd_proc_data+0x13e>
  101493:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101497:	7f 06                	jg     10149f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101499:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10149d:	eb 10                	jmp    1014af <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10149f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014a3:	7e 0a                	jle    1014af <kbd_proc_data+0x14e>
  1014a5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014a9:	7f 04                	jg     1014af <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014ab:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014af:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b4:	f7 d0                	not    %eax
  1014b6:	83 e0 06             	and    $0x6,%eax
  1014b9:	85 c0                	test   %eax,%eax
  1014bb:	75 28                	jne    1014e5 <kbd_proc_data+0x184>
  1014bd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014c4:	75 1f                	jne    1014e5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1014c6:	c7 04 24 b5 5e 10 00 	movl   $0x105eb5,(%esp)
  1014cd:	e8 b9 ed ff ff       	call   10028b <cprintf>
  1014d2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014d8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1014dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1014e0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1014e4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014e8:	c9                   	leave  
  1014e9:	c3                   	ret    

001014ea <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014ea:	55                   	push   %ebp
  1014eb:	89 e5                	mov    %esp,%ebp
  1014ed:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1014f0:	c7 04 24 61 13 10 00 	movl   $0x101361,(%esp)
  1014f7:	e8 a6 fd ff ff       	call   1012a2 <cons_intr>
}
  1014fc:	c9                   	leave  
  1014fd:	c3                   	ret    

001014fe <kbd_init>:

static void
kbd_init(void) {
  1014fe:	55                   	push   %ebp
  1014ff:	89 e5                	mov    %esp,%ebp
  101501:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101504:	e8 e1 ff ff ff       	call   1014ea <kbd_intr>
    pic_enable(IRQ_KBD);
  101509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101510:	e8 31 01 00 00       	call   101646 <pic_enable>
}
  101515:	c9                   	leave  
  101516:	c3                   	ret    

00101517 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101517:	55                   	push   %ebp
  101518:	89 e5                	mov    %esp,%ebp
  10151a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10151d:	e8 93 f8 ff ff       	call   100db5 <cga_init>
    serial_init();
  101522:	e8 74 f9 ff ff       	call   100e9b <serial_init>
    kbd_init();
  101527:	e8 d2 ff ff ff       	call   1014fe <kbd_init>
    if (!serial_exists) {
  10152c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101531:	85 c0                	test   %eax,%eax
  101533:	75 0c                	jne    101541 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101535:	c7 04 24 c1 5e 10 00 	movl   $0x105ec1,(%esp)
  10153c:	e8 4a ed ff ff       	call   10028b <cprintf>
    }
}
  101541:	c9                   	leave  
  101542:	c3                   	ret    

00101543 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101543:	55                   	push   %ebp
  101544:	89 e5                	mov    %esp,%ebp
  101546:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101549:	e8 e2 f7 ff ff       	call   100d30 <__intr_save>
  10154e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101551:	8b 45 08             	mov    0x8(%ebp),%eax
  101554:	89 04 24             	mov    %eax,(%esp)
  101557:	e8 9b fa ff ff       	call   100ff7 <lpt_putc>
        cga_putc(c);
  10155c:	8b 45 08             	mov    0x8(%ebp),%eax
  10155f:	89 04 24             	mov    %eax,(%esp)
  101562:	e8 cf fa ff ff       	call   101036 <cga_putc>
        serial_putc(c);
  101567:	8b 45 08             	mov    0x8(%ebp),%eax
  10156a:	89 04 24             	mov    %eax,(%esp)
  10156d:	e8 f1 fc ff ff       	call   101263 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101575:	89 04 24             	mov    %eax,(%esp)
  101578:	e8 dd f7 ff ff       	call   100d5a <__intr_restore>
}
  10157d:	c9                   	leave  
  10157e:	c3                   	ret    

0010157f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10157f:	55                   	push   %ebp
  101580:	89 e5                	mov    %esp,%ebp
  101582:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101585:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10158c:	e8 9f f7 ff ff       	call   100d30 <__intr_save>
  101591:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101594:	e8 ab fd ff ff       	call   101344 <serial_intr>
        kbd_intr();
  101599:	e8 4c ff ff ff       	call   1014ea <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10159e:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  1015a4:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  1015a9:	39 c2                	cmp    %eax,%edx
  1015ab:	74 31                	je     1015de <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1015ad:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1015b2:	8d 50 01             	lea    0x1(%eax),%edx
  1015b5:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  1015bb:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  1015c2:	0f b6 c0             	movzbl %al,%eax
  1015c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1015c8:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  1015cd:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015d2:	75 0a                	jne    1015de <cons_getc+0x5f>
                cons.rpos = 0;
  1015d4:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  1015db:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015e1:	89 04 24             	mov    %eax,(%esp)
  1015e4:	e8 71 f7 ff ff       	call   100d5a <__intr_restore>
    return c;
  1015e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ec:	c9                   	leave  
  1015ed:	c3                   	ret    

001015ee <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015ee:	55                   	push   %ebp
  1015ef:	89 e5                	mov    %esp,%ebp
  1015f1:	83 ec 14             	sub    $0x14,%esp
  1015f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1015fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1015ff:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  101605:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  10160a:	85 c0                	test   %eax,%eax
  10160c:	74 36                	je     101644 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10160e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101612:	0f b6 c0             	movzbl %al,%eax
  101615:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10161b:	88 45 fd             	mov    %al,-0x3(%ebp)
  10161e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101622:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101626:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101627:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162b:	66 c1 e8 08          	shr    $0x8,%ax
  10162f:	0f b6 c0             	movzbl %al,%eax
  101632:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101638:	88 45 f9             	mov    %al,-0x7(%ebp)
  10163b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10163f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101643:	ee                   	out    %al,(%dx)
    }
}
  101644:	c9                   	leave  
  101645:	c3                   	ret    

00101646 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101646:	55                   	push   %ebp
  101647:	89 e5                	mov    %esp,%ebp
  101649:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10164c:	8b 45 08             	mov    0x8(%ebp),%eax
  10164f:	ba 01 00 00 00       	mov    $0x1,%edx
  101654:	89 c1                	mov    %eax,%ecx
  101656:	d3 e2                	shl    %cl,%edx
  101658:	89 d0                	mov    %edx,%eax
  10165a:	f7 d0                	not    %eax
  10165c:	89 c2                	mov    %eax,%edx
  10165e:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101665:	21 d0                	and    %edx,%eax
  101667:	0f b7 c0             	movzwl %ax,%eax
  10166a:	89 04 24             	mov    %eax,(%esp)
  10166d:	e8 7c ff ff ff       	call   1015ee <pic_setmask>
}
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
  101677:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10167a:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101681:	00 00 00 
  101684:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10168a:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10168e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101692:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101696:	ee                   	out    %al,(%dx)
  101697:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10169d:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016a1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016a5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016a9:	ee                   	out    %al,(%dx)
  1016aa:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016b0:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016b8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016bc:	ee                   	out    %al,(%dx)
  1016bd:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016c3:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016c7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016cb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016cf:	ee                   	out    %al,(%dx)
  1016d0:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016d6:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016da:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016de:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016e2:	ee                   	out    %al,(%dx)
  1016e3:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1016e9:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1016ed:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1016f1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1016f5:	ee                   	out    %al,(%dx)
  1016f6:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1016fc:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101700:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101704:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
  101709:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10170f:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101713:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101717:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10171b:	ee                   	out    %al,(%dx)
  10171c:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101722:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101726:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10172a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10172e:	ee                   	out    %al,(%dx)
  10172f:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101735:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101739:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10173d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101741:	ee                   	out    %al,(%dx)
  101742:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101748:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10174c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101750:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10175b:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10175f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101763:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10176e:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101772:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101776:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101781:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101785:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101789:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10178e:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101795:	66 83 f8 ff          	cmp    $0xffff,%ax
  101799:	74 12                	je     1017ad <pic_init+0x139>
        pic_setmask(irq_mask);
  10179b:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  1017a2:	0f b7 c0             	movzwl %ax,%eax
  1017a5:	89 04 24             	mov    %eax,(%esp)
  1017a8:	e8 41 fe ff ff       	call   1015ee <pic_setmask>
    }
}
  1017ad:	c9                   	leave  
  1017ae:	c3                   	ret    

001017af <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017af:	55                   	push   %ebp
  1017b0:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  1017b2:	fb                   	sti    
    sti();
}
  1017b3:	5d                   	pop    %ebp
  1017b4:	c3                   	ret    

001017b5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017b5:	55                   	push   %ebp
  1017b6:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  1017b8:	fa                   	cli    
    cli();
}
  1017b9:	5d                   	pop    %ebp
  1017ba:	c3                   	ret    

001017bb <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017bb:	55                   	push   %ebp
  1017bc:	89 e5                	mov    %esp,%ebp
  1017be:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017c1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017c8:	00 
  1017c9:	c7 04 24 e0 5e 10 00 	movl   $0x105ee0,(%esp)
  1017d0:	e8 b6 ea ff ff       	call   10028b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017d5:	c9                   	leave  
  1017d6:	c3                   	ret    

001017d7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017d7:	55                   	push   %ebp
  1017d8:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1017da:	5d                   	pop    %ebp
  1017db:	c3                   	ret    

001017dc <trapname>:

static const char *
trapname(int trapno) {
  1017dc:	55                   	push   %ebp
  1017dd:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1017df:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e2:	83 f8 13             	cmp    $0x13,%eax
  1017e5:	77 0c                	ja     1017f3 <trapname+0x17>
        return excnames[trapno];
  1017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ea:	8b 04 85 40 62 10 00 	mov    0x106240(,%eax,4),%eax
  1017f1:	eb 18                	jmp    10180b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1017f3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1017f7:	7e 0d                	jle    101806 <trapname+0x2a>
  1017f9:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1017fd:	7f 07                	jg     101806 <trapname+0x2a>
        return "Hardware Interrupt";
  1017ff:	b8 ea 5e 10 00       	mov    $0x105eea,%eax
  101804:	eb 05                	jmp    10180b <trapname+0x2f>
    }
    return "(unknown trap)";
  101806:	b8 fd 5e 10 00       	mov    $0x105efd,%eax
}
  10180b:	5d                   	pop    %ebp
  10180c:	c3                   	ret    

0010180d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10180d:	55                   	push   %ebp
  10180e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101810:	8b 45 08             	mov    0x8(%ebp),%eax
  101813:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101817:	66 83 f8 08          	cmp    $0x8,%ax
  10181b:	0f 94 c0             	sete   %al
  10181e:	0f b6 c0             	movzbl %al,%eax
}
  101821:	5d                   	pop    %ebp
  101822:	c3                   	ret    

00101823 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101823:	55                   	push   %ebp
  101824:	89 e5                	mov    %esp,%ebp
  101826:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101829:	8b 45 08             	mov    0x8(%ebp),%eax
  10182c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101830:	c7 04 24 3e 5f 10 00 	movl   $0x105f3e,(%esp)
  101837:	e8 4f ea ff ff       	call   10028b <cprintf>
    print_regs(&tf->tf_regs);
  10183c:	8b 45 08             	mov    0x8(%ebp),%eax
  10183f:	89 04 24             	mov    %eax,(%esp)
  101842:	e8 a1 01 00 00       	call   1019e8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101847:	8b 45 08             	mov    0x8(%ebp),%eax
  10184a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  10184e:	0f b7 c0             	movzwl %ax,%eax
  101851:	89 44 24 04          	mov    %eax,0x4(%esp)
  101855:	c7 04 24 4f 5f 10 00 	movl   $0x105f4f,(%esp)
  10185c:	e8 2a ea ff ff       	call   10028b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101861:	8b 45 08             	mov    0x8(%ebp),%eax
  101864:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101868:	0f b7 c0             	movzwl %ax,%eax
  10186b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10186f:	c7 04 24 62 5f 10 00 	movl   $0x105f62,(%esp)
  101876:	e8 10 ea ff ff       	call   10028b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10187b:	8b 45 08             	mov    0x8(%ebp),%eax
  10187e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101882:	0f b7 c0             	movzwl %ax,%eax
  101885:	89 44 24 04          	mov    %eax,0x4(%esp)
  101889:	c7 04 24 75 5f 10 00 	movl   $0x105f75,(%esp)
  101890:	e8 f6 e9 ff ff       	call   10028b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101895:	8b 45 08             	mov    0x8(%ebp),%eax
  101898:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  10189c:	0f b7 c0             	movzwl %ax,%eax
  10189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018a3:	c7 04 24 88 5f 10 00 	movl   $0x105f88,(%esp)
  1018aa:	e8 dc e9 ff ff       	call   10028b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018af:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b2:	8b 40 30             	mov    0x30(%eax),%eax
  1018b5:	89 04 24             	mov    %eax,(%esp)
  1018b8:	e8 1f ff ff ff       	call   1017dc <trapname>
  1018bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1018c0:	8b 52 30             	mov    0x30(%edx),%edx
  1018c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1018c7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1018cb:	c7 04 24 9b 5f 10 00 	movl   $0x105f9b,(%esp)
  1018d2:	e8 b4 e9 ff ff       	call   10028b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1018da:	8b 40 34             	mov    0x34(%eax),%eax
  1018dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018e1:	c7 04 24 ad 5f 10 00 	movl   $0x105fad,(%esp)
  1018e8:	e8 9e e9 ff ff       	call   10028b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1018ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f0:	8b 40 38             	mov    0x38(%eax),%eax
  1018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018f7:	c7 04 24 bc 5f 10 00 	movl   $0x105fbc,(%esp)
  1018fe:	e8 88 e9 ff ff       	call   10028b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101903:	8b 45 08             	mov    0x8(%ebp),%eax
  101906:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  10190a:	0f b7 c0             	movzwl %ax,%eax
  10190d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101911:	c7 04 24 cb 5f 10 00 	movl   $0x105fcb,(%esp)
  101918:	e8 6e e9 ff ff       	call   10028b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  10191d:	8b 45 08             	mov    0x8(%ebp),%eax
  101920:	8b 40 40             	mov    0x40(%eax),%eax
  101923:	89 44 24 04          	mov    %eax,0x4(%esp)
  101927:	c7 04 24 de 5f 10 00 	movl   $0x105fde,(%esp)
  10192e:	e8 58 e9 ff ff       	call   10028b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10193a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101941:	eb 3e                	jmp    101981 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101943:	8b 45 08             	mov    0x8(%ebp),%eax
  101946:	8b 50 40             	mov    0x40(%eax),%edx
  101949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10194c:	21 d0                	and    %edx,%eax
  10194e:	85 c0                	test   %eax,%eax
  101950:	74 28                	je     10197a <print_trapframe+0x157>
  101952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101955:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  10195c:	85 c0                	test   %eax,%eax
  10195e:	74 1a                	je     10197a <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101963:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  10196a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10196e:	c7 04 24 ed 5f 10 00 	movl   $0x105fed,(%esp)
  101975:	e8 11 e9 ff ff       	call   10028b <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10197a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10197e:	d1 65 f0             	shll   -0x10(%ebp)
  101981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101984:	83 f8 17             	cmp    $0x17,%eax
  101987:	76 ba                	jbe    101943 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101989:	8b 45 08             	mov    0x8(%ebp),%eax
  10198c:	8b 40 40             	mov    0x40(%eax),%eax
  10198f:	25 00 30 00 00       	and    $0x3000,%eax
  101994:	c1 e8 0c             	shr    $0xc,%eax
  101997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10199b:	c7 04 24 f1 5f 10 00 	movl   $0x105ff1,(%esp)
  1019a2:	e8 e4 e8 ff ff       	call   10028b <cprintf>

    if (!trap_in_kernel(tf)) {
  1019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019aa:	89 04 24             	mov    %eax,(%esp)
  1019ad:	e8 5b fe ff ff       	call   10180d <trap_in_kernel>
  1019b2:	85 c0                	test   %eax,%eax
  1019b4:	75 30                	jne    1019e6 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b9:	8b 40 44             	mov    0x44(%eax),%eax
  1019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c0:	c7 04 24 fa 5f 10 00 	movl   $0x105ffa,(%esp)
  1019c7:	e8 bf e8 ff ff       	call   10028b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  1019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cf:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  1019d3:	0f b7 c0             	movzwl %ax,%eax
  1019d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019da:	c7 04 24 09 60 10 00 	movl   $0x106009,(%esp)
  1019e1:	e8 a5 e8 ff ff       	call   10028b <cprintf>
    }
}
  1019e6:	c9                   	leave  
  1019e7:	c3                   	ret    

001019e8 <print_regs>:

void
print_regs(struct pushregs *regs) {
  1019e8:	55                   	push   %ebp
  1019e9:	89 e5                	mov    %esp,%ebp
  1019eb:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  1019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f1:	8b 00                	mov    (%eax),%eax
  1019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f7:	c7 04 24 1c 60 10 00 	movl   $0x10601c,(%esp)
  1019fe:	e8 88 e8 ff ff       	call   10028b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	8b 40 04             	mov    0x4(%eax),%eax
  101a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a0d:	c7 04 24 2b 60 10 00 	movl   $0x10602b,(%esp)
  101a14:	e8 72 e8 ff ff       	call   10028b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	8b 40 08             	mov    0x8(%eax),%eax
  101a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a23:	c7 04 24 3a 60 10 00 	movl   $0x10603a,(%esp)
  101a2a:	e8 5c e8 ff ff       	call   10028b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a32:	8b 40 0c             	mov    0xc(%eax),%eax
  101a35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a39:	c7 04 24 49 60 10 00 	movl   $0x106049,(%esp)
  101a40:	e8 46 e8 ff ff       	call   10028b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a45:	8b 45 08             	mov    0x8(%ebp),%eax
  101a48:	8b 40 10             	mov    0x10(%eax),%eax
  101a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a4f:	c7 04 24 58 60 10 00 	movl   $0x106058,(%esp)
  101a56:	e8 30 e8 ff ff       	call   10028b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5e:	8b 40 14             	mov    0x14(%eax),%eax
  101a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a65:	c7 04 24 67 60 10 00 	movl   $0x106067,(%esp)
  101a6c:	e8 1a e8 ff ff       	call   10028b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101a71:	8b 45 08             	mov    0x8(%ebp),%eax
  101a74:	8b 40 18             	mov    0x18(%eax),%eax
  101a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7b:	c7 04 24 76 60 10 00 	movl   $0x106076,(%esp)
  101a82:	e8 04 e8 ff ff       	call   10028b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101a87:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8a:	8b 40 1c             	mov    0x1c(%eax),%eax
  101a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a91:	c7 04 24 85 60 10 00 	movl   $0x106085,(%esp)
  101a98:	e8 ee e7 ff ff       	call   10028b <cprintf>
}
  101a9d:	c9                   	leave  
  101a9e:	c3                   	ret    

00101a9f <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101a9f:	55                   	push   %ebp
  101aa0:	89 e5                	mov    %esp,%ebp
  101aa2:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa8:	8b 40 30             	mov    0x30(%eax),%eax
  101aab:	83 f8 2f             	cmp    $0x2f,%eax
  101aae:	77 1e                	ja     101ace <trap_dispatch+0x2f>
  101ab0:	83 f8 2e             	cmp    $0x2e,%eax
  101ab3:	0f 83 bf 00 00 00    	jae    101b78 <trap_dispatch+0xd9>
  101ab9:	83 f8 21             	cmp    $0x21,%eax
  101abc:	74 40                	je     101afe <trap_dispatch+0x5f>
  101abe:	83 f8 24             	cmp    $0x24,%eax
  101ac1:	74 15                	je     101ad8 <trap_dispatch+0x39>
  101ac3:	83 f8 20             	cmp    $0x20,%eax
  101ac6:	0f 84 af 00 00 00    	je     101b7b <trap_dispatch+0xdc>
  101acc:	eb 72                	jmp    101b40 <trap_dispatch+0xa1>
  101ace:	83 e8 78             	sub    $0x78,%eax
  101ad1:	83 f8 01             	cmp    $0x1,%eax
  101ad4:	77 6a                	ja     101b40 <trap_dispatch+0xa1>
  101ad6:	eb 4c                	jmp    101b24 <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ad8:	e8 a2 fa ff ff       	call   10157f <cons_getc>
  101add:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ae0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ae4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ae8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af0:	c7 04 24 94 60 10 00 	movl   $0x106094,(%esp)
  101af7:	e8 8f e7 ff ff       	call   10028b <cprintf>
        break;
  101afc:	eb 7e                	jmp    101b7c <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101afe:	e8 7c fa ff ff       	call   10157f <cons_getc>
  101b03:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b06:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b0a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b16:	c7 04 24 a6 60 10 00 	movl   $0x1060a6,(%esp)
  101b1d:	e8 69 e7 ff ff       	call   10028b <cprintf>
        break;
  101b22:	eb 58                	jmp    101b7c <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b24:	c7 44 24 08 b5 60 10 	movl   $0x1060b5,0x8(%esp)
  101b2b:	00 
  101b2c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b33:	00 
  101b34:	c7 04 24 c5 60 10 00 	movl   $0x1060c5,(%esp)
  101b3b:	e8 a2 e8 ff ff       	call   1003e2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b40:	8b 45 08             	mov    0x8(%ebp),%eax
  101b43:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b47:	0f b7 c0             	movzwl %ax,%eax
  101b4a:	83 e0 03             	and    $0x3,%eax
  101b4d:	85 c0                	test   %eax,%eax
  101b4f:	75 2b                	jne    101b7c <trap_dispatch+0xdd>
            print_trapframe(tf);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	89 04 24             	mov    %eax,(%esp)
  101b57:	e8 c7 fc ff ff       	call   101823 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b5c:	c7 44 24 08 d6 60 10 	movl   $0x1060d6,0x8(%esp)
  101b63:	00 
  101b64:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101b6b:	00 
  101b6c:	c7 04 24 c5 60 10 00 	movl   $0x1060c5,(%esp)
  101b73:	e8 6a e8 ff ff       	call   1003e2 <__panic>
        break;
  101b78:	90                   	nop
  101b79:	eb 01                	jmp    101b7c <trap_dispatch+0xdd>
        break;
  101b7b:	90                   	nop
        }
    }
}
  101b7c:	c9                   	leave  
  101b7d:	c3                   	ret    

00101b7e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101b7e:	55                   	push   %ebp
  101b7f:	89 e5                	mov    %esp,%ebp
  101b81:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101b84:	8b 45 08             	mov    0x8(%ebp),%eax
  101b87:	89 04 24             	mov    %eax,(%esp)
  101b8a:	e8 10 ff ff ff       	call   101a9f <trap_dispatch>
}
  101b8f:	c9                   	leave  
  101b90:	c3                   	ret    

00101b91 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101b91:	6a 00                	push   $0x0
  pushl $0
  101b93:	6a 00                	push   $0x0
  jmp __alltraps
  101b95:	e9 67 0a 00 00       	jmp    102601 <__alltraps>

00101b9a <vector1>:
.globl vector1
vector1:
  pushl $0
  101b9a:	6a 00                	push   $0x0
  pushl $1
  101b9c:	6a 01                	push   $0x1
  jmp __alltraps
  101b9e:	e9 5e 0a 00 00       	jmp    102601 <__alltraps>

00101ba3 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ba3:	6a 00                	push   $0x0
  pushl $2
  101ba5:	6a 02                	push   $0x2
  jmp __alltraps
  101ba7:	e9 55 0a 00 00       	jmp    102601 <__alltraps>

00101bac <vector3>:
.globl vector3
vector3:
  pushl $0
  101bac:	6a 00                	push   $0x0
  pushl $3
  101bae:	6a 03                	push   $0x3
  jmp __alltraps
  101bb0:	e9 4c 0a 00 00       	jmp    102601 <__alltraps>

00101bb5 <vector4>:
.globl vector4
vector4:
  pushl $0
  101bb5:	6a 00                	push   $0x0
  pushl $4
  101bb7:	6a 04                	push   $0x4
  jmp __alltraps
  101bb9:	e9 43 0a 00 00       	jmp    102601 <__alltraps>

00101bbe <vector5>:
.globl vector5
vector5:
  pushl $0
  101bbe:	6a 00                	push   $0x0
  pushl $5
  101bc0:	6a 05                	push   $0x5
  jmp __alltraps
  101bc2:	e9 3a 0a 00 00       	jmp    102601 <__alltraps>

00101bc7 <vector6>:
.globl vector6
vector6:
  pushl $0
  101bc7:	6a 00                	push   $0x0
  pushl $6
  101bc9:	6a 06                	push   $0x6
  jmp __alltraps
  101bcb:	e9 31 0a 00 00       	jmp    102601 <__alltraps>

00101bd0 <vector7>:
.globl vector7
vector7:
  pushl $0
  101bd0:	6a 00                	push   $0x0
  pushl $7
  101bd2:	6a 07                	push   $0x7
  jmp __alltraps
  101bd4:	e9 28 0a 00 00       	jmp    102601 <__alltraps>

00101bd9 <vector8>:
.globl vector8
vector8:
  pushl $8
  101bd9:	6a 08                	push   $0x8
  jmp __alltraps
  101bdb:	e9 21 0a 00 00       	jmp    102601 <__alltraps>

00101be0 <vector9>:
.globl vector9
vector9:
  pushl $9
  101be0:	6a 09                	push   $0x9
  jmp __alltraps
  101be2:	e9 1a 0a 00 00       	jmp    102601 <__alltraps>

00101be7 <vector10>:
.globl vector10
vector10:
  pushl $10
  101be7:	6a 0a                	push   $0xa
  jmp __alltraps
  101be9:	e9 13 0a 00 00       	jmp    102601 <__alltraps>

00101bee <vector11>:
.globl vector11
vector11:
  pushl $11
  101bee:	6a 0b                	push   $0xb
  jmp __alltraps
  101bf0:	e9 0c 0a 00 00       	jmp    102601 <__alltraps>

00101bf5 <vector12>:
.globl vector12
vector12:
  pushl $12
  101bf5:	6a 0c                	push   $0xc
  jmp __alltraps
  101bf7:	e9 05 0a 00 00       	jmp    102601 <__alltraps>

00101bfc <vector13>:
.globl vector13
vector13:
  pushl $13
  101bfc:	6a 0d                	push   $0xd
  jmp __alltraps
  101bfe:	e9 fe 09 00 00       	jmp    102601 <__alltraps>

00101c03 <vector14>:
.globl vector14
vector14:
  pushl $14
  101c03:	6a 0e                	push   $0xe
  jmp __alltraps
  101c05:	e9 f7 09 00 00       	jmp    102601 <__alltraps>

00101c0a <vector15>:
.globl vector15
vector15:
  pushl $0
  101c0a:	6a 00                	push   $0x0
  pushl $15
  101c0c:	6a 0f                	push   $0xf
  jmp __alltraps
  101c0e:	e9 ee 09 00 00       	jmp    102601 <__alltraps>

00101c13 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c13:	6a 00                	push   $0x0
  pushl $16
  101c15:	6a 10                	push   $0x10
  jmp __alltraps
  101c17:	e9 e5 09 00 00       	jmp    102601 <__alltraps>

00101c1c <vector17>:
.globl vector17
vector17:
  pushl $17
  101c1c:	6a 11                	push   $0x11
  jmp __alltraps
  101c1e:	e9 de 09 00 00       	jmp    102601 <__alltraps>

00101c23 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c23:	6a 00                	push   $0x0
  pushl $18
  101c25:	6a 12                	push   $0x12
  jmp __alltraps
  101c27:	e9 d5 09 00 00       	jmp    102601 <__alltraps>

00101c2c <vector19>:
.globl vector19
vector19:
  pushl $0
  101c2c:	6a 00                	push   $0x0
  pushl $19
  101c2e:	6a 13                	push   $0x13
  jmp __alltraps
  101c30:	e9 cc 09 00 00       	jmp    102601 <__alltraps>

00101c35 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c35:	6a 00                	push   $0x0
  pushl $20
  101c37:	6a 14                	push   $0x14
  jmp __alltraps
  101c39:	e9 c3 09 00 00       	jmp    102601 <__alltraps>

00101c3e <vector21>:
.globl vector21
vector21:
  pushl $0
  101c3e:	6a 00                	push   $0x0
  pushl $21
  101c40:	6a 15                	push   $0x15
  jmp __alltraps
  101c42:	e9 ba 09 00 00       	jmp    102601 <__alltraps>

00101c47 <vector22>:
.globl vector22
vector22:
  pushl $0
  101c47:	6a 00                	push   $0x0
  pushl $22
  101c49:	6a 16                	push   $0x16
  jmp __alltraps
  101c4b:	e9 b1 09 00 00       	jmp    102601 <__alltraps>

00101c50 <vector23>:
.globl vector23
vector23:
  pushl $0
  101c50:	6a 00                	push   $0x0
  pushl $23
  101c52:	6a 17                	push   $0x17
  jmp __alltraps
  101c54:	e9 a8 09 00 00       	jmp    102601 <__alltraps>

00101c59 <vector24>:
.globl vector24
vector24:
  pushl $0
  101c59:	6a 00                	push   $0x0
  pushl $24
  101c5b:	6a 18                	push   $0x18
  jmp __alltraps
  101c5d:	e9 9f 09 00 00       	jmp    102601 <__alltraps>

00101c62 <vector25>:
.globl vector25
vector25:
  pushl $0
  101c62:	6a 00                	push   $0x0
  pushl $25
  101c64:	6a 19                	push   $0x19
  jmp __alltraps
  101c66:	e9 96 09 00 00       	jmp    102601 <__alltraps>

00101c6b <vector26>:
.globl vector26
vector26:
  pushl $0
  101c6b:	6a 00                	push   $0x0
  pushl $26
  101c6d:	6a 1a                	push   $0x1a
  jmp __alltraps
  101c6f:	e9 8d 09 00 00       	jmp    102601 <__alltraps>

00101c74 <vector27>:
.globl vector27
vector27:
  pushl $0
  101c74:	6a 00                	push   $0x0
  pushl $27
  101c76:	6a 1b                	push   $0x1b
  jmp __alltraps
  101c78:	e9 84 09 00 00       	jmp    102601 <__alltraps>

00101c7d <vector28>:
.globl vector28
vector28:
  pushl $0
  101c7d:	6a 00                	push   $0x0
  pushl $28
  101c7f:	6a 1c                	push   $0x1c
  jmp __alltraps
  101c81:	e9 7b 09 00 00       	jmp    102601 <__alltraps>

00101c86 <vector29>:
.globl vector29
vector29:
  pushl $0
  101c86:	6a 00                	push   $0x0
  pushl $29
  101c88:	6a 1d                	push   $0x1d
  jmp __alltraps
  101c8a:	e9 72 09 00 00       	jmp    102601 <__alltraps>

00101c8f <vector30>:
.globl vector30
vector30:
  pushl $0
  101c8f:	6a 00                	push   $0x0
  pushl $30
  101c91:	6a 1e                	push   $0x1e
  jmp __alltraps
  101c93:	e9 69 09 00 00       	jmp    102601 <__alltraps>

00101c98 <vector31>:
.globl vector31
vector31:
  pushl $0
  101c98:	6a 00                	push   $0x0
  pushl $31
  101c9a:	6a 1f                	push   $0x1f
  jmp __alltraps
  101c9c:	e9 60 09 00 00       	jmp    102601 <__alltraps>

00101ca1 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ca1:	6a 00                	push   $0x0
  pushl $32
  101ca3:	6a 20                	push   $0x20
  jmp __alltraps
  101ca5:	e9 57 09 00 00       	jmp    102601 <__alltraps>

00101caa <vector33>:
.globl vector33
vector33:
  pushl $0
  101caa:	6a 00                	push   $0x0
  pushl $33
  101cac:	6a 21                	push   $0x21
  jmp __alltraps
  101cae:	e9 4e 09 00 00       	jmp    102601 <__alltraps>

00101cb3 <vector34>:
.globl vector34
vector34:
  pushl $0
  101cb3:	6a 00                	push   $0x0
  pushl $34
  101cb5:	6a 22                	push   $0x22
  jmp __alltraps
  101cb7:	e9 45 09 00 00       	jmp    102601 <__alltraps>

00101cbc <vector35>:
.globl vector35
vector35:
  pushl $0
  101cbc:	6a 00                	push   $0x0
  pushl $35
  101cbe:	6a 23                	push   $0x23
  jmp __alltraps
  101cc0:	e9 3c 09 00 00       	jmp    102601 <__alltraps>

00101cc5 <vector36>:
.globl vector36
vector36:
  pushl $0
  101cc5:	6a 00                	push   $0x0
  pushl $36
  101cc7:	6a 24                	push   $0x24
  jmp __alltraps
  101cc9:	e9 33 09 00 00       	jmp    102601 <__alltraps>

00101cce <vector37>:
.globl vector37
vector37:
  pushl $0
  101cce:	6a 00                	push   $0x0
  pushl $37
  101cd0:	6a 25                	push   $0x25
  jmp __alltraps
  101cd2:	e9 2a 09 00 00       	jmp    102601 <__alltraps>

00101cd7 <vector38>:
.globl vector38
vector38:
  pushl $0
  101cd7:	6a 00                	push   $0x0
  pushl $38
  101cd9:	6a 26                	push   $0x26
  jmp __alltraps
  101cdb:	e9 21 09 00 00       	jmp    102601 <__alltraps>

00101ce0 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ce0:	6a 00                	push   $0x0
  pushl $39
  101ce2:	6a 27                	push   $0x27
  jmp __alltraps
  101ce4:	e9 18 09 00 00       	jmp    102601 <__alltraps>

00101ce9 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ce9:	6a 00                	push   $0x0
  pushl $40
  101ceb:	6a 28                	push   $0x28
  jmp __alltraps
  101ced:	e9 0f 09 00 00       	jmp    102601 <__alltraps>

00101cf2 <vector41>:
.globl vector41
vector41:
  pushl $0
  101cf2:	6a 00                	push   $0x0
  pushl $41
  101cf4:	6a 29                	push   $0x29
  jmp __alltraps
  101cf6:	e9 06 09 00 00       	jmp    102601 <__alltraps>

00101cfb <vector42>:
.globl vector42
vector42:
  pushl $0
  101cfb:	6a 00                	push   $0x0
  pushl $42
  101cfd:	6a 2a                	push   $0x2a
  jmp __alltraps
  101cff:	e9 fd 08 00 00       	jmp    102601 <__alltraps>

00101d04 <vector43>:
.globl vector43
vector43:
  pushl $0
  101d04:	6a 00                	push   $0x0
  pushl $43
  101d06:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d08:	e9 f4 08 00 00       	jmp    102601 <__alltraps>

00101d0d <vector44>:
.globl vector44
vector44:
  pushl $0
  101d0d:	6a 00                	push   $0x0
  pushl $44
  101d0f:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d11:	e9 eb 08 00 00       	jmp    102601 <__alltraps>

00101d16 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d16:	6a 00                	push   $0x0
  pushl $45
  101d18:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d1a:	e9 e2 08 00 00       	jmp    102601 <__alltraps>

00101d1f <vector46>:
.globl vector46
vector46:
  pushl $0
  101d1f:	6a 00                	push   $0x0
  pushl $46
  101d21:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d23:	e9 d9 08 00 00       	jmp    102601 <__alltraps>

00101d28 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d28:	6a 00                	push   $0x0
  pushl $47
  101d2a:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d2c:	e9 d0 08 00 00       	jmp    102601 <__alltraps>

00101d31 <vector48>:
.globl vector48
vector48:
  pushl $0
  101d31:	6a 00                	push   $0x0
  pushl $48
  101d33:	6a 30                	push   $0x30
  jmp __alltraps
  101d35:	e9 c7 08 00 00       	jmp    102601 <__alltraps>

00101d3a <vector49>:
.globl vector49
vector49:
  pushl $0
  101d3a:	6a 00                	push   $0x0
  pushl $49
  101d3c:	6a 31                	push   $0x31
  jmp __alltraps
  101d3e:	e9 be 08 00 00       	jmp    102601 <__alltraps>

00101d43 <vector50>:
.globl vector50
vector50:
  pushl $0
  101d43:	6a 00                	push   $0x0
  pushl $50
  101d45:	6a 32                	push   $0x32
  jmp __alltraps
  101d47:	e9 b5 08 00 00       	jmp    102601 <__alltraps>

00101d4c <vector51>:
.globl vector51
vector51:
  pushl $0
  101d4c:	6a 00                	push   $0x0
  pushl $51
  101d4e:	6a 33                	push   $0x33
  jmp __alltraps
  101d50:	e9 ac 08 00 00       	jmp    102601 <__alltraps>

00101d55 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d55:	6a 00                	push   $0x0
  pushl $52
  101d57:	6a 34                	push   $0x34
  jmp __alltraps
  101d59:	e9 a3 08 00 00       	jmp    102601 <__alltraps>

00101d5e <vector53>:
.globl vector53
vector53:
  pushl $0
  101d5e:	6a 00                	push   $0x0
  pushl $53
  101d60:	6a 35                	push   $0x35
  jmp __alltraps
  101d62:	e9 9a 08 00 00       	jmp    102601 <__alltraps>

00101d67 <vector54>:
.globl vector54
vector54:
  pushl $0
  101d67:	6a 00                	push   $0x0
  pushl $54
  101d69:	6a 36                	push   $0x36
  jmp __alltraps
  101d6b:	e9 91 08 00 00       	jmp    102601 <__alltraps>

00101d70 <vector55>:
.globl vector55
vector55:
  pushl $0
  101d70:	6a 00                	push   $0x0
  pushl $55
  101d72:	6a 37                	push   $0x37
  jmp __alltraps
  101d74:	e9 88 08 00 00       	jmp    102601 <__alltraps>

00101d79 <vector56>:
.globl vector56
vector56:
  pushl $0
  101d79:	6a 00                	push   $0x0
  pushl $56
  101d7b:	6a 38                	push   $0x38
  jmp __alltraps
  101d7d:	e9 7f 08 00 00       	jmp    102601 <__alltraps>

00101d82 <vector57>:
.globl vector57
vector57:
  pushl $0
  101d82:	6a 00                	push   $0x0
  pushl $57
  101d84:	6a 39                	push   $0x39
  jmp __alltraps
  101d86:	e9 76 08 00 00       	jmp    102601 <__alltraps>

00101d8b <vector58>:
.globl vector58
vector58:
  pushl $0
  101d8b:	6a 00                	push   $0x0
  pushl $58
  101d8d:	6a 3a                	push   $0x3a
  jmp __alltraps
  101d8f:	e9 6d 08 00 00       	jmp    102601 <__alltraps>

00101d94 <vector59>:
.globl vector59
vector59:
  pushl $0
  101d94:	6a 00                	push   $0x0
  pushl $59
  101d96:	6a 3b                	push   $0x3b
  jmp __alltraps
  101d98:	e9 64 08 00 00       	jmp    102601 <__alltraps>

00101d9d <vector60>:
.globl vector60
vector60:
  pushl $0
  101d9d:	6a 00                	push   $0x0
  pushl $60
  101d9f:	6a 3c                	push   $0x3c
  jmp __alltraps
  101da1:	e9 5b 08 00 00       	jmp    102601 <__alltraps>

00101da6 <vector61>:
.globl vector61
vector61:
  pushl $0
  101da6:	6a 00                	push   $0x0
  pushl $61
  101da8:	6a 3d                	push   $0x3d
  jmp __alltraps
  101daa:	e9 52 08 00 00       	jmp    102601 <__alltraps>

00101daf <vector62>:
.globl vector62
vector62:
  pushl $0
  101daf:	6a 00                	push   $0x0
  pushl $62
  101db1:	6a 3e                	push   $0x3e
  jmp __alltraps
  101db3:	e9 49 08 00 00       	jmp    102601 <__alltraps>

00101db8 <vector63>:
.globl vector63
vector63:
  pushl $0
  101db8:	6a 00                	push   $0x0
  pushl $63
  101dba:	6a 3f                	push   $0x3f
  jmp __alltraps
  101dbc:	e9 40 08 00 00       	jmp    102601 <__alltraps>

00101dc1 <vector64>:
.globl vector64
vector64:
  pushl $0
  101dc1:	6a 00                	push   $0x0
  pushl $64
  101dc3:	6a 40                	push   $0x40
  jmp __alltraps
  101dc5:	e9 37 08 00 00       	jmp    102601 <__alltraps>

00101dca <vector65>:
.globl vector65
vector65:
  pushl $0
  101dca:	6a 00                	push   $0x0
  pushl $65
  101dcc:	6a 41                	push   $0x41
  jmp __alltraps
  101dce:	e9 2e 08 00 00       	jmp    102601 <__alltraps>

00101dd3 <vector66>:
.globl vector66
vector66:
  pushl $0
  101dd3:	6a 00                	push   $0x0
  pushl $66
  101dd5:	6a 42                	push   $0x42
  jmp __alltraps
  101dd7:	e9 25 08 00 00       	jmp    102601 <__alltraps>

00101ddc <vector67>:
.globl vector67
vector67:
  pushl $0
  101ddc:	6a 00                	push   $0x0
  pushl $67
  101dde:	6a 43                	push   $0x43
  jmp __alltraps
  101de0:	e9 1c 08 00 00       	jmp    102601 <__alltraps>

00101de5 <vector68>:
.globl vector68
vector68:
  pushl $0
  101de5:	6a 00                	push   $0x0
  pushl $68
  101de7:	6a 44                	push   $0x44
  jmp __alltraps
  101de9:	e9 13 08 00 00       	jmp    102601 <__alltraps>

00101dee <vector69>:
.globl vector69
vector69:
  pushl $0
  101dee:	6a 00                	push   $0x0
  pushl $69
  101df0:	6a 45                	push   $0x45
  jmp __alltraps
  101df2:	e9 0a 08 00 00       	jmp    102601 <__alltraps>

00101df7 <vector70>:
.globl vector70
vector70:
  pushl $0
  101df7:	6a 00                	push   $0x0
  pushl $70
  101df9:	6a 46                	push   $0x46
  jmp __alltraps
  101dfb:	e9 01 08 00 00       	jmp    102601 <__alltraps>

00101e00 <vector71>:
.globl vector71
vector71:
  pushl $0
  101e00:	6a 00                	push   $0x0
  pushl $71
  101e02:	6a 47                	push   $0x47
  jmp __alltraps
  101e04:	e9 f8 07 00 00       	jmp    102601 <__alltraps>

00101e09 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e09:	6a 00                	push   $0x0
  pushl $72
  101e0b:	6a 48                	push   $0x48
  jmp __alltraps
  101e0d:	e9 ef 07 00 00       	jmp    102601 <__alltraps>

00101e12 <vector73>:
.globl vector73
vector73:
  pushl $0
  101e12:	6a 00                	push   $0x0
  pushl $73
  101e14:	6a 49                	push   $0x49
  jmp __alltraps
  101e16:	e9 e6 07 00 00       	jmp    102601 <__alltraps>

00101e1b <vector74>:
.globl vector74
vector74:
  pushl $0
  101e1b:	6a 00                	push   $0x0
  pushl $74
  101e1d:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e1f:	e9 dd 07 00 00       	jmp    102601 <__alltraps>

00101e24 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $75
  101e26:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e28:	e9 d4 07 00 00       	jmp    102601 <__alltraps>

00101e2d <vector76>:
.globl vector76
vector76:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $76
  101e2f:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e31:	e9 cb 07 00 00       	jmp    102601 <__alltraps>

00101e36 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $77
  101e38:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e3a:	e9 c2 07 00 00       	jmp    102601 <__alltraps>

00101e3f <vector78>:
.globl vector78
vector78:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $78
  101e41:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e43:	e9 b9 07 00 00       	jmp    102601 <__alltraps>

00101e48 <vector79>:
.globl vector79
vector79:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $79
  101e4a:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e4c:	e9 b0 07 00 00       	jmp    102601 <__alltraps>

00101e51 <vector80>:
.globl vector80
vector80:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $80
  101e53:	6a 50                	push   $0x50
  jmp __alltraps
  101e55:	e9 a7 07 00 00       	jmp    102601 <__alltraps>

00101e5a <vector81>:
.globl vector81
vector81:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $81
  101e5c:	6a 51                	push   $0x51
  jmp __alltraps
  101e5e:	e9 9e 07 00 00       	jmp    102601 <__alltraps>

00101e63 <vector82>:
.globl vector82
vector82:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $82
  101e65:	6a 52                	push   $0x52
  jmp __alltraps
  101e67:	e9 95 07 00 00       	jmp    102601 <__alltraps>

00101e6c <vector83>:
.globl vector83
vector83:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $83
  101e6e:	6a 53                	push   $0x53
  jmp __alltraps
  101e70:	e9 8c 07 00 00       	jmp    102601 <__alltraps>

00101e75 <vector84>:
.globl vector84
vector84:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $84
  101e77:	6a 54                	push   $0x54
  jmp __alltraps
  101e79:	e9 83 07 00 00       	jmp    102601 <__alltraps>

00101e7e <vector85>:
.globl vector85
vector85:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $85
  101e80:	6a 55                	push   $0x55
  jmp __alltraps
  101e82:	e9 7a 07 00 00       	jmp    102601 <__alltraps>

00101e87 <vector86>:
.globl vector86
vector86:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $86
  101e89:	6a 56                	push   $0x56
  jmp __alltraps
  101e8b:	e9 71 07 00 00       	jmp    102601 <__alltraps>

00101e90 <vector87>:
.globl vector87
vector87:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $87
  101e92:	6a 57                	push   $0x57
  jmp __alltraps
  101e94:	e9 68 07 00 00       	jmp    102601 <__alltraps>

00101e99 <vector88>:
.globl vector88
vector88:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $88
  101e9b:	6a 58                	push   $0x58
  jmp __alltraps
  101e9d:	e9 5f 07 00 00       	jmp    102601 <__alltraps>

00101ea2 <vector89>:
.globl vector89
vector89:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $89
  101ea4:	6a 59                	push   $0x59
  jmp __alltraps
  101ea6:	e9 56 07 00 00       	jmp    102601 <__alltraps>

00101eab <vector90>:
.globl vector90
vector90:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $90
  101ead:	6a 5a                	push   $0x5a
  jmp __alltraps
  101eaf:	e9 4d 07 00 00       	jmp    102601 <__alltraps>

00101eb4 <vector91>:
.globl vector91
vector91:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $91
  101eb6:	6a 5b                	push   $0x5b
  jmp __alltraps
  101eb8:	e9 44 07 00 00       	jmp    102601 <__alltraps>

00101ebd <vector92>:
.globl vector92
vector92:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $92
  101ebf:	6a 5c                	push   $0x5c
  jmp __alltraps
  101ec1:	e9 3b 07 00 00       	jmp    102601 <__alltraps>

00101ec6 <vector93>:
.globl vector93
vector93:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $93
  101ec8:	6a 5d                	push   $0x5d
  jmp __alltraps
  101eca:	e9 32 07 00 00       	jmp    102601 <__alltraps>

00101ecf <vector94>:
.globl vector94
vector94:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $94
  101ed1:	6a 5e                	push   $0x5e
  jmp __alltraps
  101ed3:	e9 29 07 00 00       	jmp    102601 <__alltraps>

00101ed8 <vector95>:
.globl vector95
vector95:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $95
  101eda:	6a 5f                	push   $0x5f
  jmp __alltraps
  101edc:	e9 20 07 00 00       	jmp    102601 <__alltraps>

00101ee1 <vector96>:
.globl vector96
vector96:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $96
  101ee3:	6a 60                	push   $0x60
  jmp __alltraps
  101ee5:	e9 17 07 00 00       	jmp    102601 <__alltraps>

00101eea <vector97>:
.globl vector97
vector97:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $97
  101eec:	6a 61                	push   $0x61
  jmp __alltraps
  101eee:	e9 0e 07 00 00       	jmp    102601 <__alltraps>

00101ef3 <vector98>:
.globl vector98
vector98:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $98
  101ef5:	6a 62                	push   $0x62
  jmp __alltraps
  101ef7:	e9 05 07 00 00       	jmp    102601 <__alltraps>

00101efc <vector99>:
.globl vector99
vector99:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $99
  101efe:	6a 63                	push   $0x63
  jmp __alltraps
  101f00:	e9 fc 06 00 00       	jmp    102601 <__alltraps>

00101f05 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $100
  101f07:	6a 64                	push   $0x64
  jmp __alltraps
  101f09:	e9 f3 06 00 00       	jmp    102601 <__alltraps>

00101f0e <vector101>:
.globl vector101
vector101:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $101
  101f10:	6a 65                	push   $0x65
  jmp __alltraps
  101f12:	e9 ea 06 00 00       	jmp    102601 <__alltraps>

00101f17 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $102
  101f19:	6a 66                	push   $0x66
  jmp __alltraps
  101f1b:	e9 e1 06 00 00       	jmp    102601 <__alltraps>

00101f20 <vector103>:
.globl vector103
vector103:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $103
  101f22:	6a 67                	push   $0x67
  jmp __alltraps
  101f24:	e9 d8 06 00 00       	jmp    102601 <__alltraps>

00101f29 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $104
  101f2b:	6a 68                	push   $0x68
  jmp __alltraps
  101f2d:	e9 cf 06 00 00       	jmp    102601 <__alltraps>

00101f32 <vector105>:
.globl vector105
vector105:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $105
  101f34:	6a 69                	push   $0x69
  jmp __alltraps
  101f36:	e9 c6 06 00 00       	jmp    102601 <__alltraps>

00101f3b <vector106>:
.globl vector106
vector106:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $106
  101f3d:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f3f:	e9 bd 06 00 00       	jmp    102601 <__alltraps>

00101f44 <vector107>:
.globl vector107
vector107:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $107
  101f46:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f48:	e9 b4 06 00 00       	jmp    102601 <__alltraps>

00101f4d <vector108>:
.globl vector108
vector108:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $108
  101f4f:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f51:	e9 ab 06 00 00       	jmp    102601 <__alltraps>

00101f56 <vector109>:
.globl vector109
vector109:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $109
  101f58:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f5a:	e9 a2 06 00 00       	jmp    102601 <__alltraps>

00101f5f <vector110>:
.globl vector110
vector110:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $110
  101f61:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f63:	e9 99 06 00 00       	jmp    102601 <__alltraps>

00101f68 <vector111>:
.globl vector111
vector111:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $111
  101f6a:	6a 6f                	push   $0x6f
  jmp __alltraps
  101f6c:	e9 90 06 00 00       	jmp    102601 <__alltraps>

00101f71 <vector112>:
.globl vector112
vector112:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $112
  101f73:	6a 70                	push   $0x70
  jmp __alltraps
  101f75:	e9 87 06 00 00       	jmp    102601 <__alltraps>

00101f7a <vector113>:
.globl vector113
vector113:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $113
  101f7c:	6a 71                	push   $0x71
  jmp __alltraps
  101f7e:	e9 7e 06 00 00       	jmp    102601 <__alltraps>

00101f83 <vector114>:
.globl vector114
vector114:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $114
  101f85:	6a 72                	push   $0x72
  jmp __alltraps
  101f87:	e9 75 06 00 00       	jmp    102601 <__alltraps>

00101f8c <vector115>:
.globl vector115
vector115:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $115
  101f8e:	6a 73                	push   $0x73
  jmp __alltraps
  101f90:	e9 6c 06 00 00       	jmp    102601 <__alltraps>

00101f95 <vector116>:
.globl vector116
vector116:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $116
  101f97:	6a 74                	push   $0x74
  jmp __alltraps
  101f99:	e9 63 06 00 00       	jmp    102601 <__alltraps>

00101f9e <vector117>:
.globl vector117
vector117:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $117
  101fa0:	6a 75                	push   $0x75
  jmp __alltraps
  101fa2:	e9 5a 06 00 00       	jmp    102601 <__alltraps>

00101fa7 <vector118>:
.globl vector118
vector118:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $118
  101fa9:	6a 76                	push   $0x76
  jmp __alltraps
  101fab:	e9 51 06 00 00       	jmp    102601 <__alltraps>

00101fb0 <vector119>:
.globl vector119
vector119:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $119
  101fb2:	6a 77                	push   $0x77
  jmp __alltraps
  101fb4:	e9 48 06 00 00       	jmp    102601 <__alltraps>

00101fb9 <vector120>:
.globl vector120
vector120:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $120
  101fbb:	6a 78                	push   $0x78
  jmp __alltraps
  101fbd:	e9 3f 06 00 00       	jmp    102601 <__alltraps>

00101fc2 <vector121>:
.globl vector121
vector121:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $121
  101fc4:	6a 79                	push   $0x79
  jmp __alltraps
  101fc6:	e9 36 06 00 00       	jmp    102601 <__alltraps>

00101fcb <vector122>:
.globl vector122
vector122:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $122
  101fcd:	6a 7a                	push   $0x7a
  jmp __alltraps
  101fcf:	e9 2d 06 00 00       	jmp    102601 <__alltraps>

00101fd4 <vector123>:
.globl vector123
vector123:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $123
  101fd6:	6a 7b                	push   $0x7b
  jmp __alltraps
  101fd8:	e9 24 06 00 00       	jmp    102601 <__alltraps>

00101fdd <vector124>:
.globl vector124
vector124:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $124
  101fdf:	6a 7c                	push   $0x7c
  jmp __alltraps
  101fe1:	e9 1b 06 00 00       	jmp    102601 <__alltraps>

00101fe6 <vector125>:
.globl vector125
vector125:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $125
  101fe8:	6a 7d                	push   $0x7d
  jmp __alltraps
  101fea:	e9 12 06 00 00       	jmp    102601 <__alltraps>

00101fef <vector126>:
.globl vector126
vector126:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $126
  101ff1:	6a 7e                	push   $0x7e
  jmp __alltraps
  101ff3:	e9 09 06 00 00       	jmp    102601 <__alltraps>

00101ff8 <vector127>:
.globl vector127
vector127:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $127
  101ffa:	6a 7f                	push   $0x7f
  jmp __alltraps
  101ffc:	e9 00 06 00 00       	jmp    102601 <__alltraps>

00102001 <vector128>:
.globl vector128
vector128:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $128
  102003:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102008:	e9 f4 05 00 00       	jmp    102601 <__alltraps>

0010200d <vector129>:
.globl vector129
vector129:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $129
  10200f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102014:	e9 e8 05 00 00       	jmp    102601 <__alltraps>

00102019 <vector130>:
.globl vector130
vector130:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $130
  10201b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102020:	e9 dc 05 00 00       	jmp    102601 <__alltraps>

00102025 <vector131>:
.globl vector131
vector131:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $131
  102027:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10202c:	e9 d0 05 00 00       	jmp    102601 <__alltraps>

00102031 <vector132>:
.globl vector132
vector132:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $132
  102033:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102038:	e9 c4 05 00 00       	jmp    102601 <__alltraps>

0010203d <vector133>:
.globl vector133
vector133:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $133
  10203f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102044:	e9 b8 05 00 00       	jmp    102601 <__alltraps>

00102049 <vector134>:
.globl vector134
vector134:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $134
  10204b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102050:	e9 ac 05 00 00       	jmp    102601 <__alltraps>

00102055 <vector135>:
.globl vector135
vector135:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $135
  102057:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10205c:	e9 a0 05 00 00       	jmp    102601 <__alltraps>

00102061 <vector136>:
.globl vector136
vector136:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $136
  102063:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102068:	e9 94 05 00 00       	jmp    102601 <__alltraps>

0010206d <vector137>:
.globl vector137
vector137:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $137
  10206f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102074:	e9 88 05 00 00       	jmp    102601 <__alltraps>

00102079 <vector138>:
.globl vector138
vector138:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $138
  10207b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102080:	e9 7c 05 00 00       	jmp    102601 <__alltraps>

00102085 <vector139>:
.globl vector139
vector139:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $139
  102087:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10208c:	e9 70 05 00 00       	jmp    102601 <__alltraps>

00102091 <vector140>:
.globl vector140
vector140:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $140
  102093:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102098:	e9 64 05 00 00       	jmp    102601 <__alltraps>

0010209d <vector141>:
.globl vector141
vector141:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $141
  10209f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020a4:	e9 58 05 00 00       	jmp    102601 <__alltraps>

001020a9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $142
  1020ab:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020b0:	e9 4c 05 00 00       	jmp    102601 <__alltraps>

001020b5 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $143
  1020b7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020bc:	e9 40 05 00 00       	jmp    102601 <__alltraps>

001020c1 <vector144>:
.globl vector144
vector144:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $144
  1020c3:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1020c8:	e9 34 05 00 00       	jmp    102601 <__alltraps>

001020cd <vector145>:
.globl vector145
vector145:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $145
  1020cf:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1020d4:	e9 28 05 00 00       	jmp    102601 <__alltraps>

001020d9 <vector146>:
.globl vector146
vector146:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $146
  1020db:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1020e0:	e9 1c 05 00 00       	jmp    102601 <__alltraps>

001020e5 <vector147>:
.globl vector147
vector147:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $147
  1020e7:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1020ec:	e9 10 05 00 00       	jmp    102601 <__alltraps>

001020f1 <vector148>:
.globl vector148
vector148:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $148
  1020f3:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1020f8:	e9 04 05 00 00       	jmp    102601 <__alltraps>

001020fd <vector149>:
.globl vector149
vector149:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $149
  1020ff:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102104:	e9 f8 04 00 00       	jmp    102601 <__alltraps>

00102109 <vector150>:
.globl vector150
vector150:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $150
  10210b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102110:	e9 ec 04 00 00       	jmp    102601 <__alltraps>

00102115 <vector151>:
.globl vector151
vector151:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $151
  102117:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10211c:	e9 e0 04 00 00       	jmp    102601 <__alltraps>

00102121 <vector152>:
.globl vector152
vector152:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $152
  102123:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102128:	e9 d4 04 00 00       	jmp    102601 <__alltraps>

0010212d <vector153>:
.globl vector153
vector153:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $153
  10212f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102134:	e9 c8 04 00 00       	jmp    102601 <__alltraps>

00102139 <vector154>:
.globl vector154
vector154:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $154
  10213b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102140:	e9 bc 04 00 00       	jmp    102601 <__alltraps>

00102145 <vector155>:
.globl vector155
vector155:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $155
  102147:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10214c:	e9 b0 04 00 00       	jmp    102601 <__alltraps>

00102151 <vector156>:
.globl vector156
vector156:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $156
  102153:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102158:	e9 a4 04 00 00       	jmp    102601 <__alltraps>

0010215d <vector157>:
.globl vector157
vector157:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $157
  10215f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102164:	e9 98 04 00 00       	jmp    102601 <__alltraps>

00102169 <vector158>:
.globl vector158
vector158:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $158
  10216b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102170:	e9 8c 04 00 00       	jmp    102601 <__alltraps>

00102175 <vector159>:
.globl vector159
vector159:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $159
  102177:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10217c:	e9 80 04 00 00       	jmp    102601 <__alltraps>

00102181 <vector160>:
.globl vector160
vector160:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $160
  102183:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102188:	e9 74 04 00 00       	jmp    102601 <__alltraps>

0010218d <vector161>:
.globl vector161
vector161:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $161
  10218f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102194:	e9 68 04 00 00       	jmp    102601 <__alltraps>

00102199 <vector162>:
.globl vector162
vector162:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $162
  10219b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021a0:	e9 5c 04 00 00       	jmp    102601 <__alltraps>

001021a5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $163
  1021a7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021ac:	e9 50 04 00 00       	jmp    102601 <__alltraps>

001021b1 <vector164>:
.globl vector164
vector164:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $164
  1021b3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021b8:	e9 44 04 00 00       	jmp    102601 <__alltraps>

001021bd <vector165>:
.globl vector165
vector165:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $165
  1021bf:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1021c4:	e9 38 04 00 00       	jmp    102601 <__alltraps>

001021c9 <vector166>:
.globl vector166
vector166:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $166
  1021cb:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1021d0:	e9 2c 04 00 00       	jmp    102601 <__alltraps>

001021d5 <vector167>:
.globl vector167
vector167:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $167
  1021d7:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1021dc:	e9 20 04 00 00       	jmp    102601 <__alltraps>

001021e1 <vector168>:
.globl vector168
vector168:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $168
  1021e3:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1021e8:	e9 14 04 00 00       	jmp    102601 <__alltraps>

001021ed <vector169>:
.globl vector169
vector169:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $169
  1021ef:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1021f4:	e9 08 04 00 00       	jmp    102601 <__alltraps>

001021f9 <vector170>:
.globl vector170
vector170:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $170
  1021fb:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102200:	e9 fc 03 00 00       	jmp    102601 <__alltraps>

00102205 <vector171>:
.globl vector171
vector171:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $171
  102207:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10220c:	e9 f0 03 00 00       	jmp    102601 <__alltraps>

00102211 <vector172>:
.globl vector172
vector172:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $172
  102213:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102218:	e9 e4 03 00 00       	jmp    102601 <__alltraps>

0010221d <vector173>:
.globl vector173
vector173:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $173
  10221f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102224:	e9 d8 03 00 00       	jmp    102601 <__alltraps>

00102229 <vector174>:
.globl vector174
vector174:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $174
  10222b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102230:	e9 cc 03 00 00       	jmp    102601 <__alltraps>

00102235 <vector175>:
.globl vector175
vector175:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $175
  102237:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10223c:	e9 c0 03 00 00       	jmp    102601 <__alltraps>

00102241 <vector176>:
.globl vector176
vector176:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $176
  102243:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102248:	e9 b4 03 00 00       	jmp    102601 <__alltraps>

0010224d <vector177>:
.globl vector177
vector177:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $177
  10224f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102254:	e9 a8 03 00 00       	jmp    102601 <__alltraps>

00102259 <vector178>:
.globl vector178
vector178:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $178
  10225b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102260:	e9 9c 03 00 00       	jmp    102601 <__alltraps>

00102265 <vector179>:
.globl vector179
vector179:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $179
  102267:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10226c:	e9 90 03 00 00       	jmp    102601 <__alltraps>

00102271 <vector180>:
.globl vector180
vector180:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $180
  102273:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102278:	e9 84 03 00 00       	jmp    102601 <__alltraps>

0010227d <vector181>:
.globl vector181
vector181:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $181
  10227f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102284:	e9 78 03 00 00       	jmp    102601 <__alltraps>

00102289 <vector182>:
.globl vector182
vector182:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $182
  10228b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102290:	e9 6c 03 00 00       	jmp    102601 <__alltraps>

00102295 <vector183>:
.globl vector183
vector183:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $183
  102297:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10229c:	e9 60 03 00 00       	jmp    102601 <__alltraps>

001022a1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $184
  1022a3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022a8:	e9 54 03 00 00       	jmp    102601 <__alltraps>

001022ad <vector185>:
.globl vector185
vector185:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $185
  1022af:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022b4:	e9 48 03 00 00       	jmp    102601 <__alltraps>

001022b9 <vector186>:
.globl vector186
vector186:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $186
  1022bb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1022c0:	e9 3c 03 00 00       	jmp    102601 <__alltraps>

001022c5 <vector187>:
.globl vector187
vector187:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $187
  1022c7:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1022cc:	e9 30 03 00 00       	jmp    102601 <__alltraps>

001022d1 <vector188>:
.globl vector188
vector188:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $188
  1022d3:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1022d8:	e9 24 03 00 00       	jmp    102601 <__alltraps>

001022dd <vector189>:
.globl vector189
vector189:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $189
  1022df:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1022e4:	e9 18 03 00 00       	jmp    102601 <__alltraps>

001022e9 <vector190>:
.globl vector190
vector190:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $190
  1022eb:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1022f0:	e9 0c 03 00 00       	jmp    102601 <__alltraps>

001022f5 <vector191>:
.globl vector191
vector191:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $191
  1022f7:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1022fc:	e9 00 03 00 00       	jmp    102601 <__alltraps>

00102301 <vector192>:
.globl vector192
vector192:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $192
  102303:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102308:	e9 f4 02 00 00       	jmp    102601 <__alltraps>

0010230d <vector193>:
.globl vector193
vector193:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $193
  10230f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102314:	e9 e8 02 00 00       	jmp    102601 <__alltraps>

00102319 <vector194>:
.globl vector194
vector194:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $194
  10231b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102320:	e9 dc 02 00 00       	jmp    102601 <__alltraps>

00102325 <vector195>:
.globl vector195
vector195:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $195
  102327:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10232c:	e9 d0 02 00 00       	jmp    102601 <__alltraps>

00102331 <vector196>:
.globl vector196
vector196:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $196
  102333:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102338:	e9 c4 02 00 00       	jmp    102601 <__alltraps>

0010233d <vector197>:
.globl vector197
vector197:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $197
  10233f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102344:	e9 b8 02 00 00       	jmp    102601 <__alltraps>

00102349 <vector198>:
.globl vector198
vector198:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $198
  10234b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102350:	e9 ac 02 00 00       	jmp    102601 <__alltraps>

00102355 <vector199>:
.globl vector199
vector199:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $199
  102357:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10235c:	e9 a0 02 00 00       	jmp    102601 <__alltraps>

00102361 <vector200>:
.globl vector200
vector200:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $200
  102363:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102368:	e9 94 02 00 00       	jmp    102601 <__alltraps>

0010236d <vector201>:
.globl vector201
vector201:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $201
  10236f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102374:	e9 88 02 00 00       	jmp    102601 <__alltraps>

00102379 <vector202>:
.globl vector202
vector202:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $202
  10237b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102380:	e9 7c 02 00 00       	jmp    102601 <__alltraps>

00102385 <vector203>:
.globl vector203
vector203:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $203
  102387:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10238c:	e9 70 02 00 00       	jmp    102601 <__alltraps>

00102391 <vector204>:
.globl vector204
vector204:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $204
  102393:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102398:	e9 64 02 00 00       	jmp    102601 <__alltraps>

0010239d <vector205>:
.globl vector205
vector205:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $205
  10239f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023a4:	e9 58 02 00 00       	jmp    102601 <__alltraps>

001023a9 <vector206>:
.globl vector206
vector206:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $206
  1023ab:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023b0:	e9 4c 02 00 00       	jmp    102601 <__alltraps>

001023b5 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $207
  1023b7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023bc:	e9 40 02 00 00       	jmp    102601 <__alltraps>

001023c1 <vector208>:
.globl vector208
vector208:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $208
  1023c3:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1023c8:	e9 34 02 00 00       	jmp    102601 <__alltraps>

001023cd <vector209>:
.globl vector209
vector209:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $209
  1023cf:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1023d4:	e9 28 02 00 00       	jmp    102601 <__alltraps>

001023d9 <vector210>:
.globl vector210
vector210:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $210
  1023db:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1023e0:	e9 1c 02 00 00       	jmp    102601 <__alltraps>

001023e5 <vector211>:
.globl vector211
vector211:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $211
  1023e7:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1023ec:	e9 10 02 00 00       	jmp    102601 <__alltraps>

001023f1 <vector212>:
.globl vector212
vector212:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $212
  1023f3:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1023f8:	e9 04 02 00 00       	jmp    102601 <__alltraps>

001023fd <vector213>:
.globl vector213
vector213:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $213
  1023ff:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102404:	e9 f8 01 00 00       	jmp    102601 <__alltraps>

00102409 <vector214>:
.globl vector214
vector214:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $214
  10240b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102410:	e9 ec 01 00 00       	jmp    102601 <__alltraps>

00102415 <vector215>:
.globl vector215
vector215:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $215
  102417:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10241c:	e9 e0 01 00 00       	jmp    102601 <__alltraps>

00102421 <vector216>:
.globl vector216
vector216:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $216
  102423:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102428:	e9 d4 01 00 00       	jmp    102601 <__alltraps>

0010242d <vector217>:
.globl vector217
vector217:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $217
  10242f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102434:	e9 c8 01 00 00       	jmp    102601 <__alltraps>

00102439 <vector218>:
.globl vector218
vector218:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $218
  10243b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102440:	e9 bc 01 00 00       	jmp    102601 <__alltraps>

00102445 <vector219>:
.globl vector219
vector219:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $219
  102447:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10244c:	e9 b0 01 00 00       	jmp    102601 <__alltraps>

00102451 <vector220>:
.globl vector220
vector220:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $220
  102453:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102458:	e9 a4 01 00 00       	jmp    102601 <__alltraps>

0010245d <vector221>:
.globl vector221
vector221:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $221
  10245f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102464:	e9 98 01 00 00       	jmp    102601 <__alltraps>

00102469 <vector222>:
.globl vector222
vector222:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $222
  10246b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102470:	e9 8c 01 00 00       	jmp    102601 <__alltraps>

00102475 <vector223>:
.globl vector223
vector223:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $223
  102477:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10247c:	e9 80 01 00 00       	jmp    102601 <__alltraps>

00102481 <vector224>:
.globl vector224
vector224:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $224
  102483:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102488:	e9 74 01 00 00       	jmp    102601 <__alltraps>

0010248d <vector225>:
.globl vector225
vector225:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $225
  10248f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102494:	e9 68 01 00 00       	jmp    102601 <__alltraps>

00102499 <vector226>:
.globl vector226
vector226:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $226
  10249b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024a0:	e9 5c 01 00 00       	jmp    102601 <__alltraps>

001024a5 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $227
  1024a7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024ac:	e9 50 01 00 00       	jmp    102601 <__alltraps>

001024b1 <vector228>:
.globl vector228
vector228:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $228
  1024b3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024b8:	e9 44 01 00 00       	jmp    102601 <__alltraps>

001024bd <vector229>:
.globl vector229
vector229:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $229
  1024bf:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1024c4:	e9 38 01 00 00       	jmp    102601 <__alltraps>

001024c9 <vector230>:
.globl vector230
vector230:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $230
  1024cb:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1024d0:	e9 2c 01 00 00       	jmp    102601 <__alltraps>

001024d5 <vector231>:
.globl vector231
vector231:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $231
  1024d7:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1024dc:	e9 20 01 00 00       	jmp    102601 <__alltraps>

001024e1 <vector232>:
.globl vector232
vector232:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $232
  1024e3:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1024e8:	e9 14 01 00 00       	jmp    102601 <__alltraps>

001024ed <vector233>:
.globl vector233
vector233:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $233
  1024ef:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1024f4:	e9 08 01 00 00       	jmp    102601 <__alltraps>

001024f9 <vector234>:
.globl vector234
vector234:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $234
  1024fb:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102500:	e9 fc 00 00 00       	jmp    102601 <__alltraps>

00102505 <vector235>:
.globl vector235
vector235:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $235
  102507:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10250c:	e9 f0 00 00 00       	jmp    102601 <__alltraps>

00102511 <vector236>:
.globl vector236
vector236:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $236
  102513:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102518:	e9 e4 00 00 00       	jmp    102601 <__alltraps>

0010251d <vector237>:
.globl vector237
vector237:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $237
  10251f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102524:	e9 d8 00 00 00       	jmp    102601 <__alltraps>

00102529 <vector238>:
.globl vector238
vector238:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $238
  10252b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102530:	e9 cc 00 00 00       	jmp    102601 <__alltraps>

00102535 <vector239>:
.globl vector239
vector239:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $239
  102537:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10253c:	e9 c0 00 00 00       	jmp    102601 <__alltraps>

00102541 <vector240>:
.globl vector240
vector240:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $240
  102543:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102548:	e9 b4 00 00 00       	jmp    102601 <__alltraps>

0010254d <vector241>:
.globl vector241
vector241:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $241
  10254f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102554:	e9 a8 00 00 00       	jmp    102601 <__alltraps>

00102559 <vector242>:
.globl vector242
vector242:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $242
  10255b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102560:	e9 9c 00 00 00       	jmp    102601 <__alltraps>

00102565 <vector243>:
.globl vector243
vector243:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $243
  102567:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10256c:	e9 90 00 00 00       	jmp    102601 <__alltraps>

00102571 <vector244>:
.globl vector244
vector244:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $244
  102573:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102578:	e9 84 00 00 00       	jmp    102601 <__alltraps>

0010257d <vector245>:
.globl vector245
vector245:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $245
  10257f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102584:	e9 78 00 00 00       	jmp    102601 <__alltraps>

00102589 <vector246>:
.globl vector246
vector246:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $246
  10258b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102590:	e9 6c 00 00 00       	jmp    102601 <__alltraps>

00102595 <vector247>:
.globl vector247
vector247:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $247
  102597:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10259c:	e9 60 00 00 00       	jmp    102601 <__alltraps>

001025a1 <vector248>:
.globl vector248
vector248:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $248
  1025a3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025a8:	e9 54 00 00 00       	jmp    102601 <__alltraps>

001025ad <vector249>:
.globl vector249
vector249:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $249
  1025af:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025b4:	e9 48 00 00 00       	jmp    102601 <__alltraps>

001025b9 <vector250>:
.globl vector250
vector250:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $250
  1025bb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1025c0:	e9 3c 00 00 00       	jmp    102601 <__alltraps>

001025c5 <vector251>:
.globl vector251
vector251:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $251
  1025c7:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1025cc:	e9 30 00 00 00       	jmp    102601 <__alltraps>

001025d1 <vector252>:
.globl vector252
vector252:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $252
  1025d3:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1025d8:	e9 24 00 00 00       	jmp    102601 <__alltraps>

001025dd <vector253>:
.globl vector253
vector253:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $253
  1025df:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1025e4:	e9 18 00 00 00       	jmp    102601 <__alltraps>

001025e9 <vector254>:
.globl vector254
vector254:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $254
  1025eb:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1025f0:	e9 0c 00 00 00       	jmp    102601 <__alltraps>

001025f5 <vector255>:
.globl vector255
vector255:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $255
  1025f7:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1025fc:	e9 00 00 00 00       	jmp    102601 <__alltraps>

00102601 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102601:	1e                   	push   %ds
    pushl %es
  102602:	06                   	push   %es
    pushl %fs
  102603:	0f a0                	push   %fs
    pushl %gs
  102605:	0f a8                	push   %gs
    pushal
  102607:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102608:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10260d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10260f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102611:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102612:	e8 67 f5 ff ff       	call   101b7e <trap>

    # pop the pushed stack pointer
    popl %esp
  102617:	5c                   	pop    %esp

00102618 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102618:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102619:	0f a9                	pop    %gs
    popl %fs
  10261b:	0f a1                	pop    %fs
    popl %es
  10261d:	07                   	pop    %es
    popl %ds
  10261e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10261f:	83 c4 08             	add    $0x8,%esp
    iret
  102622:	cf                   	iret   

00102623 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102623:	55                   	push   %ebp
  102624:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102626:	8b 55 08             	mov    0x8(%ebp),%edx
  102629:	a1 58 89 11 00       	mov    0x118958,%eax
  10262e:	29 c2                	sub    %eax,%edx
  102630:	89 d0                	mov    %edx,%eax
  102632:	c1 f8 02             	sar    $0x2,%eax
  102635:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10263b:	5d                   	pop    %ebp
  10263c:	c3                   	ret    

0010263d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10263d:	55                   	push   %ebp
  10263e:	89 e5                	mov    %esp,%ebp
  102640:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102643:	8b 45 08             	mov    0x8(%ebp),%eax
  102646:	89 04 24             	mov    %eax,(%esp)
  102649:	e8 d5 ff ff ff       	call   102623 <page2ppn>
  10264e:	c1 e0 0c             	shl    $0xc,%eax
}
  102651:	c9                   	leave  
  102652:	c3                   	ret    

00102653 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102653:	55                   	push   %ebp
  102654:	89 e5                	mov    %esp,%ebp
  102656:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102659:	8b 45 08             	mov    0x8(%ebp),%eax
  10265c:	c1 e8 0c             	shr    $0xc,%eax
  10265f:	89 c2                	mov    %eax,%edx
  102661:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102666:	39 c2                	cmp    %eax,%edx
  102668:	72 1c                	jb     102686 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  10266a:	c7 44 24 08 90 62 10 	movl   $0x106290,0x8(%esp)
  102671:	00 
  102672:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102679:	00 
  10267a:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
  102681:	e8 5c dd ff ff       	call   1003e2 <__panic>
    }
    return &pages[PPN(pa)];
  102686:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  10268c:	8b 45 08             	mov    0x8(%ebp),%eax
  10268f:	c1 e8 0c             	shr    $0xc,%eax
  102692:	89 c2                	mov    %eax,%edx
  102694:	89 d0                	mov    %edx,%eax
  102696:	c1 e0 02             	shl    $0x2,%eax
  102699:	01 d0                	add    %edx,%eax
  10269b:	c1 e0 02             	shl    $0x2,%eax
  10269e:	01 c8                	add    %ecx,%eax
}
  1026a0:	c9                   	leave  
  1026a1:	c3                   	ret    

001026a2 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1026a2:	55                   	push   %ebp
  1026a3:	89 e5                	mov    %esp,%ebp
  1026a5:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1026a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1026ab:	89 04 24             	mov    %eax,(%esp)
  1026ae:	e8 8a ff ff ff       	call   10263d <page2pa>
  1026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026b9:	c1 e8 0c             	shr    $0xc,%eax
  1026bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1026bf:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1026c4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1026c7:	72 23                	jb     1026ec <page2kva+0x4a>
  1026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1026d0:	c7 44 24 08 c0 62 10 	movl   $0x1062c0,0x8(%esp)
  1026d7:	00 
  1026d8:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1026df:	00 
  1026e0:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
  1026e7:	e8 f6 dc ff ff       	call   1003e2 <__panic>
  1026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026ef:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1026f4:	c9                   	leave  
  1026f5:	c3                   	ret    

001026f6 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  1026f6:	55                   	push   %ebp
  1026f7:	89 e5                	mov    %esp,%ebp
  1026f9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1026ff:	83 e0 01             	and    $0x1,%eax
  102702:	85 c0                	test   %eax,%eax
  102704:	75 1c                	jne    102722 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102706:	c7 44 24 08 e4 62 10 	movl   $0x1062e4,0x8(%esp)
  10270d:	00 
  10270e:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102715:	00 
  102716:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
  10271d:	e8 c0 dc ff ff       	call   1003e2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102722:	8b 45 08             	mov    0x8(%ebp),%eax
  102725:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10272a:	89 04 24             	mov    %eax,(%esp)
  10272d:	e8 21 ff ff ff       	call   102653 <pa2page>
}
  102732:	c9                   	leave  
  102733:	c3                   	ret    

00102734 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102734:	55                   	push   %ebp
  102735:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102737:	8b 45 08             	mov    0x8(%ebp),%eax
  10273a:	8b 00                	mov    (%eax),%eax
}
  10273c:	5d                   	pop    %ebp
  10273d:	c3                   	ret    

0010273e <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  10273e:	55                   	push   %ebp
  10273f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102741:	8b 45 08             	mov    0x8(%ebp),%eax
  102744:	8b 00                	mov    (%eax),%eax
  102746:	8d 50 01             	lea    0x1(%eax),%edx
  102749:	8b 45 08             	mov    0x8(%ebp),%eax
  10274c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  10274e:	8b 45 08             	mov    0x8(%ebp),%eax
  102751:	8b 00                	mov    (%eax),%eax
}
  102753:	5d                   	pop    %ebp
  102754:	c3                   	ret    

00102755 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102755:	55                   	push   %ebp
  102756:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102758:	8b 45 08             	mov    0x8(%ebp),%eax
  10275b:	8b 00                	mov    (%eax),%eax
  10275d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102760:	8b 45 08             	mov    0x8(%ebp),%eax
  102763:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102765:	8b 45 08             	mov    0x8(%ebp),%eax
  102768:	8b 00                	mov    (%eax),%eax
}
  10276a:	5d                   	pop    %ebp
  10276b:	c3                   	ret    

0010276c <__intr_save>:
__intr_save(void) {
  10276c:	55                   	push   %ebp
  10276d:	89 e5                	mov    %esp,%ebp
  10276f:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102772:	9c                   	pushf  
  102773:	58                   	pop    %eax
  102774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102777:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  10277a:	25 00 02 00 00       	and    $0x200,%eax
  10277f:	85 c0                	test   %eax,%eax
  102781:	74 0c                	je     10278f <__intr_save+0x23>
        intr_disable();
  102783:	e8 2d f0 ff ff       	call   1017b5 <intr_disable>
        return 1;
  102788:	b8 01 00 00 00       	mov    $0x1,%eax
  10278d:	eb 05                	jmp    102794 <__intr_save+0x28>
    return 0;
  10278f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102794:	c9                   	leave  
  102795:	c3                   	ret    

00102796 <__intr_restore>:
__intr_restore(bool flag) {
  102796:	55                   	push   %ebp
  102797:	89 e5                	mov    %esp,%ebp
  102799:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  10279c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1027a0:	74 05                	je     1027a7 <__intr_restore+0x11>
        intr_enable();
  1027a2:	e8 08 f0 ff ff       	call   1017af <intr_enable>
}
  1027a7:	c9                   	leave  
  1027a8:	c3                   	ret    

001027a9 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027a9:	55                   	push   %ebp
  1027aa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1027af:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027b2:	b8 23 00 00 00       	mov    $0x23,%eax
  1027b7:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1027b9:	b8 23 00 00 00       	mov    $0x23,%eax
  1027be:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1027c0:	b8 10 00 00 00       	mov    $0x10,%eax
  1027c5:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1027c7:	b8 10 00 00 00       	mov    $0x10,%eax
  1027cc:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1027ce:	b8 10 00 00 00       	mov    $0x10,%eax
  1027d3:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1027d5:	ea dc 27 10 00 08 00 	ljmp   $0x8,$0x1027dc
}
  1027dc:	5d                   	pop    %ebp
  1027dd:	c3                   	ret    

001027de <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  1027de:	55                   	push   %ebp
  1027df:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  1027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1027e4:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  1027e9:	5d                   	pop    %ebp
  1027ea:	c3                   	ret    

001027eb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1027eb:	55                   	push   %ebp
  1027ec:	89 e5                	mov    %esp,%ebp
  1027ee:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  1027f1:	b8 00 70 11 00       	mov    $0x117000,%eax
  1027f6:	89 04 24             	mov    %eax,(%esp)
  1027f9:	e8 e0 ff ff ff       	call   1027de <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  1027fe:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  102805:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102807:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  10280e:	68 00 
  102810:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102815:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  10281b:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  102820:	c1 e8 10             	shr    $0x10,%eax
  102823:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102828:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  10282f:	83 e0 f0             	and    $0xfffffff0,%eax
  102832:	83 c8 09             	or     $0x9,%eax
  102835:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  10283a:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102841:	83 e0 ef             	and    $0xffffffef,%eax
  102844:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102849:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102850:	83 e0 9f             	and    $0xffffff9f,%eax
  102853:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102858:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  10285f:	83 c8 80             	or     $0xffffff80,%eax
  102862:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102867:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10286e:	83 e0 f0             	and    $0xfffffff0,%eax
  102871:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102876:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10287d:	83 e0 ef             	and    $0xffffffef,%eax
  102880:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102885:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10288c:	83 e0 df             	and    $0xffffffdf,%eax
  10288f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102894:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10289b:	83 c8 40             	or     $0x40,%eax
  10289e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1028a3:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  1028aa:	83 e0 7f             	and    $0x7f,%eax
  1028ad:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1028b2:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  1028b7:	c1 e8 18             	shr    $0x18,%eax
  1028ba:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  1028bf:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  1028c6:	e8 de fe ff ff       	call   1027a9 <lgdt>
  1028cb:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  1028d1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1028d5:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1028d8:	c9                   	leave  
  1028d9:	c3                   	ret    

001028da <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  1028da:	55                   	push   %ebp
  1028db:	89 e5                	mov    %esp,%ebp
  1028dd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  1028e0:	c7 05 50 89 11 00 68 	movl   $0x106c68,0x118950
  1028e7:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  1028ea:	a1 50 89 11 00       	mov    0x118950,%eax
  1028ef:	8b 00                	mov    (%eax),%eax
  1028f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1028f5:	c7 04 24 10 63 10 00 	movl   $0x106310,(%esp)
  1028fc:	e8 8a d9 ff ff       	call   10028b <cprintf>
    pmm_manager->init();
  102901:	a1 50 89 11 00       	mov    0x118950,%eax
  102906:	8b 40 04             	mov    0x4(%eax),%eax
  102909:	ff d0                	call   *%eax
}
  10290b:	c9                   	leave  
  10290c:	c3                   	ret    

0010290d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  10290d:	55                   	push   %ebp
  10290e:	89 e5                	mov    %esp,%ebp
  102910:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102913:	a1 50 89 11 00       	mov    0x118950,%eax
  102918:	8b 40 08             	mov    0x8(%eax),%eax
  10291b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10291e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102922:	8b 55 08             	mov    0x8(%ebp),%edx
  102925:	89 14 24             	mov    %edx,(%esp)
  102928:	ff d0                	call   *%eax
}
  10292a:	c9                   	leave  
  10292b:	c3                   	ret    

0010292c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  10292c:	55                   	push   %ebp
  10292d:	89 e5                	mov    %esp,%ebp
  10292f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102939:	e8 2e fe ff ff       	call   10276c <__intr_save>
  10293e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102941:	a1 50 89 11 00       	mov    0x118950,%eax
  102946:	8b 40 0c             	mov    0xc(%eax),%eax
  102949:	8b 55 08             	mov    0x8(%ebp),%edx
  10294c:	89 14 24             	mov    %edx,(%esp)
  10294f:	ff d0                	call   *%eax
  102951:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102957:	89 04 24             	mov    %eax,(%esp)
  10295a:	e8 37 fe ff ff       	call   102796 <__intr_restore>
    return page;
  10295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102962:	c9                   	leave  
  102963:	c3                   	ret    

00102964 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102964:	55                   	push   %ebp
  102965:	89 e5                	mov    %esp,%ebp
  102967:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10296a:	e8 fd fd ff ff       	call   10276c <__intr_save>
  10296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102972:	a1 50 89 11 00       	mov    0x118950,%eax
  102977:	8b 40 10             	mov    0x10(%eax),%eax
  10297a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10297d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102981:	8b 55 08             	mov    0x8(%ebp),%edx
  102984:	89 14 24             	mov    %edx,(%esp)
  102987:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10298c:	89 04 24             	mov    %eax,(%esp)
  10298f:	e8 02 fe ff ff       	call   102796 <__intr_restore>
}
  102994:	c9                   	leave  
  102995:	c3                   	ret    

00102996 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102996:	55                   	push   %ebp
  102997:	89 e5                	mov    %esp,%ebp
  102999:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  10299c:	e8 cb fd ff ff       	call   10276c <__intr_save>
  1029a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  1029a4:	a1 50 89 11 00       	mov    0x118950,%eax
  1029a9:	8b 40 14             	mov    0x14(%eax),%eax
  1029ac:	ff d0                	call   *%eax
  1029ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  1029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b4:	89 04 24             	mov    %eax,(%esp)
  1029b7:	e8 da fd ff ff       	call   102796 <__intr_restore>
    return ret;
  1029bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1029bf:	c9                   	leave  
  1029c0:	c3                   	ret    

001029c1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  1029c1:	55                   	push   %ebp
  1029c2:	89 e5                	mov    %esp,%ebp
  1029c4:	57                   	push   %edi
  1029c5:	56                   	push   %esi
  1029c6:	53                   	push   %ebx
  1029c7:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  1029cd:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  1029d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1029db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  1029e2:	c7 04 24 27 63 10 00 	movl   $0x106327,(%esp)
  1029e9:	e8 9d d8 ff ff       	call   10028b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1029ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1029f5:	e9 15 01 00 00       	jmp    102b0f <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1029fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1029fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a00:	89 d0                	mov    %edx,%eax
  102a02:	c1 e0 02             	shl    $0x2,%eax
  102a05:	01 d0                	add    %edx,%eax
  102a07:	c1 e0 02             	shl    $0x2,%eax
  102a0a:	01 c8                	add    %ecx,%eax
  102a0c:	8b 50 08             	mov    0x8(%eax),%edx
  102a0f:	8b 40 04             	mov    0x4(%eax),%eax
  102a12:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102a15:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102a18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102a1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a1e:	89 d0                	mov    %edx,%eax
  102a20:	c1 e0 02             	shl    $0x2,%eax
  102a23:	01 d0                	add    %edx,%eax
  102a25:	c1 e0 02             	shl    $0x2,%eax
  102a28:	01 c8                	add    %ecx,%eax
  102a2a:	8b 48 0c             	mov    0xc(%eax),%ecx
  102a2d:	8b 58 10             	mov    0x10(%eax),%ebx
  102a30:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102a33:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102a36:	01 c8                	add    %ecx,%eax
  102a38:	11 da                	adc    %ebx,%edx
  102a3a:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102a3d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102a40:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102a43:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a46:	89 d0                	mov    %edx,%eax
  102a48:	c1 e0 02             	shl    $0x2,%eax
  102a4b:	01 d0                	add    %edx,%eax
  102a4d:	c1 e0 02             	shl    $0x2,%eax
  102a50:	01 c8                	add    %ecx,%eax
  102a52:	83 c0 14             	add    $0x14,%eax
  102a55:	8b 00                	mov    (%eax),%eax
  102a57:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  102a5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102a60:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102a63:	83 c0 ff             	add    $0xffffffff,%eax
  102a66:	83 d2 ff             	adc    $0xffffffff,%edx
  102a69:	89 c6                	mov    %eax,%esi
  102a6b:	89 d7                	mov    %edx,%edi
  102a6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102a70:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a73:	89 d0                	mov    %edx,%eax
  102a75:	c1 e0 02             	shl    $0x2,%eax
  102a78:	01 d0                	add    %edx,%eax
  102a7a:	c1 e0 02             	shl    $0x2,%eax
  102a7d:	01 c8                	add    %ecx,%eax
  102a7f:	8b 48 0c             	mov    0xc(%eax),%ecx
  102a82:	8b 58 10             	mov    0x10(%eax),%ebx
  102a85:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102a8b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  102a8f:	89 74 24 14          	mov    %esi,0x14(%esp)
  102a93:	89 7c 24 18          	mov    %edi,0x18(%esp)
  102a97:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102a9a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102a9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102aa1:	89 54 24 10          	mov    %edx,0x10(%esp)
  102aa5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102aa9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102aad:	c7 04 24 34 63 10 00 	movl   $0x106334,(%esp)
  102ab4:	e8 d2 d7 ff ff       	call   10028b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102ab9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102abf:	89 d0                	mov    %edx,%eax
  102ac1:	c1 e0 02             	shl    $0x2,%eax
  102ac4:	01 d0                	add    %edx,%eax
  102ac6:	c1 e0 02             	shl    $0x2,%eax
  102ac9:	01 c8                	add    %ecx,%eax
  102acb:	83 c0 14             	add    $0x14,%eax
  102ace:	8b 00                	mov    (%eax),%eax
  102ad0:	83 f8 01             	cmp    $0x1,%eax
  102ad3:	75 36                	jne    102b0b <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  102ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ad8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102adb:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102ade:	77 2b                	ja     102b0b <page_init+0x14a>
  102ae0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102ae3:	72 05                	jb     102aea <page_init+0x129>
  102ae5:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102ae8:	73 21                	jae    102b0b <page_init+0x14a>
  102aea:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102aee:	77 1b                	ja     102b0b <page_init+0x14a>
  102af0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102af4:	72 09                	jb     102aff <page_init+0x13e>
  102af6:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102afd:	77 0c                	ja     102b0b <page_init+0x14a>
                maxpa = end;
  102aff:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102b02:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102b05:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102b0b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102b0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b12:	8b 00                	mov    (%eax),%eax
  102b14:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102b17:	0f 8f dd fe ff ff    	jg     1029fa <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102b21:	72 1d                	jb     102b40 <page_init+0x17f>
  102b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102b27:	77 09                	ja     102b32 <page_init+0x171>
  102b29:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102b30:	76 0e                	jbe    102b40 <page_init+0x17f>
        maxpa = KMEMSIZE;
  102b32:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102b39:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b46:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102b4a:	c1 ea 0c             	shr    $0xc,%edx
  102b4d:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102b52:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102b59:	b8 68 89 11 00       	mov    $0x118968,%eax
  102b5e:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b61:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b64:	01 d0                	add    %edx,%eax
  102b66:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102b69:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102b6c:	ba 00 00 00 00       	mov    $0x0,%edx
  102b71:	f7 75 ac             	divl   -0x54(%ebp)
  102b74:	89 d0                	mov    %edx,%eax
  102b76:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102b79:	29 c2                	sub    %eax,%edx
  102b7b:	89 d0                	mov    %edx,%eax
  102b7d:	a3 58 89 11 00       	mov    %eax,0x118958

    for (i = 0; i < npage; i ++) {
  102b82:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b89:	eb 2f                	jmp    102bba <page_init+0x1f9>
        SetPageReserved(pages + i);
  102b8b:	8b 0d 58 89 11 00    	mov    0x118958,%ecx
  102b91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b94:	89 d0                	mov    %edx,%eax
  102b96:	c1 e0 02             	shl    $0x2,%eax
  102b99:	01 d0                	add    %edx,%eax
  102b9b:	c1 e0 02             	shl    $0x2,%eax
  102b9e:	01 c8                	add    %ecx,%eax
  102ba0:	83 c0 04             	add    $0x4,%eax
  102ba3:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102baa:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bad:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102bb0:	8b 55 90             	mov    -0x70(%ebp),%edx
  102bb3:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102bb6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102bba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102bbd:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  102bc2:	39 c2                	cmp    %eax,%edx
  102bc4:	72 c5                	jb     102b8b <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102bc6:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102bcc:	89 d0                	mov    %edx,%eax
  102bce:	c1 e0 02             	shl    $0x2,%eax
  102bd1:	01 d0                	add    %edx,%eax
  102bd3:	c1 e0 02             	shl    $0x2,%eax
  102bd6:	89 c2                	mov    %eax,%edx
  102bd8:	a1 58 89 11 00       	mov    0x118958,%eax
  102bdd:	01 d0                	add    %edx,%eax
  102bdf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102be2:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102be9:	77 23                	ja     102c0e <page_init+0x24d>
  102beb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102bee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102bf2:	c7 44 24 08 64 63 10 	movl   $0x106364,0x8(%esp)
  102bf9:	00 
  102bfa:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  102c01:	00 
  102c02:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102c09:	e8 d4 d7 ff ff       	call   1003e2 <__panic>
  102c0e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102c11:	05 00 00 00 40       	add    $0x40000000,%eax
  102c16:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102c19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c20:	e9 74 01 00 00       	jmp    102d99 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102c25:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c2b:	89 d0                	mov    %edx,%eax
  102c2d:	c1 e0 02             	shl    $0x2,%eax
  102c30:	01 d0                	add    %edx,%eax
  102c32:	c1 e0 02             	shl    $0x2,%eax
  102c35:	01 c8                	add    %ecx,%eax
  102c37:	8b 50 08             	mov    0x8(%eax),%edx
  102c3a:	8b 40 04             	mov    0x4(%eax),%eax
  102c3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c40:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c43:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c46:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c49:	89 d0                	mov    %edx,%eax
  102c4b:	c1 e0 02             	shl    $0x2,%eax
  102c4e:	01 d0                	add    %edx,%eax
  102c50:	c1 e0 02             	shl    $0x2,%eax
  102c53:	01 c8                	add    %ecx,%eax
  102c55:	8b 48 0c             	mov    0xc(%eax),%ecx
  102c58:	8b 58 10             	mov    0x10(%eax),%ebx
  102c5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c61:	01 c8                	add    %ecx,%eax
  102c63:	11 da                	adc    %ebx,%edx
  102c65:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102c68:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102c6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c71:	89 d0                	mov    %edx,%eax
  102c73:	c1 e0 02             	shl    $0x2,%eax
  102c76:	01 d0                	add    %edx,%eax
  102c78:	c1 e0 02             	shl    $0x2,%eax
  102c7b:	01 c8                	add    %ecx,%eax
  102c7d:	83 c0 14             	add    $0x14,%eax
  102c80:	8b 00                	mov    (%eax),%eax
  102c82:	83 f8 01             	cmp    $0x1,%eax
  102c85:	0f 85 0a 01 00 00    	jne    102d95 <page_init+0x3d4>
            if (begin < freemem) {
  102c8b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  102c93:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102c96:	72 17                	jb     102caf <page_init+0x2ee>
  102c98:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102c9b:	77 05                	ja     102ca2 <page_init+0x2e1>
  102c9d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102ca0:	76 0d                	jbe    102caf <page_init+0x2ee>
                begin = freemem;
  102ca2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ca8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102caf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102cb3:	72 1d                	jb     102cd2 <page_init+0x311>
  102cb5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102cb9:	77 09                	ja     102cc4 <page_init+0x303>
  102cbb:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102cc2:	76 0e                	jbe    102cd2 <page_init+0x311>
                end = KMEMSIZE;
  102cc4:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102ccb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102cd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cd8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102cdb:	0f 87 b4 00 00 00    	ja     102d95 <page_init+0x3d4>
  102ce1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102ce4:	72 09                	jb     102cef <page_init+0x32e>
  102ce6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102ce9:	0f 83 a6 00 00 00    	jae    102d95 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  102cef:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102cf6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cf9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102cfc:	01 d0                	add    %edx,%eax
  102cfe:	83 e8 01             	sub    $0x1,%eax
  102d01:	89 45 98             	mov    %eax,-0x68(%ebp)
  102d04:	8b 45 98             	mov    -0x68(%ebp),%eax
  102d07:	ba 00 00 00 00       	mov    $0x0,%edx
  102d0c:	f7 75 9c             	divl   -0x64(%ebp)
  102d0f:	89 d0                	mov    %edx,%eax
  102d11:	8b 55 98             	mov    -0x68(%ebp),%edx
  102d14:	29 c2                	sub    %eax,%edx
  102d16:	89 d0                	mov    %edx,%eax
  102d18:	ba 00 00 00 00       	mov    $0x0,%edx
  102d1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d20:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102d23:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d26:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102d29:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102d2c:	ba 00 00 00 00       	mov    $0x0,%edx
  102d31:	89 c7                	mov    %eax,%edi
  102d33:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  102d39:	89 7d 80             	mov    %edi,-0x80(%ebp)
  102d3c:	89 d0                	mov    %edx,%eax
  102d3e:	83 e0 00             	and    $0x0,%eax
  102d41:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102d44:	8b 45 80             	mov    -0x80(%ebp),%eax
  102d47:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102d4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d4d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  102d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d56:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102d59:	77 3a                	ja     102d95 <page_init+0x3d4>
  102d5b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102d5e:	72 05                	jb     102d65 <page_init+0x3a4>
  102d60:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102d63:	73 30                	jae    102d95 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102d65:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  102d68:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  102d6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d6e:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d71:	29 c8                	sub    %ecx,%eax
  102d73:	19 da                	sbb    %ebx,%edx
  102d75:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102d79:	c1 ea 0c             	shr    $0xc,%edx
  102d7c:	89 c3                	mov    %eax,%ebx
  102d7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d81:	89 04 24             	mov    %eax,(%esp)
  102d84:	e8 ca f8 ff ff       	call   102653 <pa2page>
  102d89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102d8d:	89 04 24             	mov    %eax,(%esp)
  102d90:	e8 78 fb ff ff       	call   10290d <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  102d95:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102d99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d9c:	8b 00                	mov    (%eax),%eax
  102d9e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102da1:	0f 8f 7e fe ff ff    	jg     102c25 <page_init+0x264>
                }
            }
        }
    }
}
  102da7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  102dad:	5b                   	pop    %ebx
  102dae:	5e                   	pop    %esi
  102daf:	5f                   	pop    %edi
  102db0:	5d                   	pop    %ebp
  102db1:	c3                   	ret    

00102db2 <enable_paging>:

static void
enable_paging(void) {
  102db2:	55                   	push   %ebp
  102db3:	89 e5                	mov    %esp,%ebp
  102db5:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  102db8:	a1 54 89 11 00       	mov    0x118954,%eax
  102dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  102dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dc3:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  102dc6:	0f 20 c0             	mov    %cr0,%eax
  102dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  102dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  102dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  102dd2:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  102dd9:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  102ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  102de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de6:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  102de9:	c9                   	leave  
  102dea:	c3                   	ret    

00102deb <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  102deb:	55                   	push   %ebp
  102dec:	89 e5                	mov    %esp,%ebp
  102dee:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  102df1:	8b 45 14             	mov    0x14(%ebp),%eax
  102df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  102df7:	31 d0                	xor    %edx,%eax
  102df9:	25 ff 0f 00 00       	and    $0xfff,%eax
  102dfe:	85 c0                	test   %eax,%eax
  102e00:	74 24                	je     102e26 <boot_map_segment+0x3b>
  102e02:	c7 44 24 0c 96 63 10 	movl   $0x106396,0xc(%esp)
  102e09:	00 
  102e0a:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  102e11:	00 
  102e12:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  102e19:	00 
  102e1a:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102e21:	e8 bc d5 ff ff       	call   1003e2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  102e26:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  102e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e30:	25 ff 0f 00 00       	and    $0xfff,%eax
  102e35:	89 c2                	mov    %eax,%edx
  102e37:	8b 45 10             	mov    0x10(%ebp),%eax
  102e3a:	01 c2                	add    %eax,%edx
  102e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e3f:	01 d0                	add    %edx,%eax
  102e41:	83 e8 01             	sub    $0x1,%eax
  102e44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  102e4f:	f7 75 f0             	divl   -0x10(%ebp)
  102e52:	89 d0                	mov    %edx,%eax
  102e54:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102e57:	29 c2                	sub    %eax,%edx
  102e59:	89 d0                	mov    %edx,%eax
  102e5b:	c1 e8 0c             	shr    $0xc,%eax
  102e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  102e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e64:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e6f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  102e72:	8b 45 14             	mov    0x14(%ebp),%eax
  102e75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102e80:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  102e83:	eb 6b                	jmp    102ef0 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  102e85:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102e8c:	00 
  102e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e94:	8b 45 08             	mov    0x8(%ebp),%eax
  102e97:	89 04 24             	mov    %eax,(%esp)
  102e9a:	e8 cc 01 00 00       	call   10306b <get_pte>
  102e9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  102ea2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102ea6:	75 24                	jne    102ecc <boot_map_segment+0xe1>
  102ea8:	c7 44 24 0c c2 63 10 	movl   $0x1063c2,0xc(%esp)
  102eaf:	00 
  102eb0:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  102eb7:	00 
  102eb8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  102ebf:	00 
  102ec0:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102ec7:	e8 16 d5 ff ff       	call   1003e2 <__panic>
        *ptep = pa | PTE_P | perm;
  102ecc:	8b 45 18             	mov    0x18(%ebp),%eax
  102ecf:	8b 55 14             	mov    0x14(%ebp),%edx
  102ed2:	09 d0                	or     %edx,%eax
  102ed4:	83 c8 01             	or     $0x1,%eax
  102ed7:	89 c2                	mov    %eax,%edx
  102ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102edc:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  102ede:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  102ee2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  102ee9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  102ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ef4:	75 8f                	jne    102e85 <boot_map_segment+0x9a>
    }
}
  102ef6:	c9                   	leave  
  102ef7:	c3                   	ret    

00102ef8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  102ef8:	55                   	push   %ebp
  102ef9:	89 e5                	mov    %esp,%ebp
  102efb:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  102efe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f05:	e8 22 fa ff ff       	call   10292c <alloc_pages>
  102f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  102f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f11:	75 1c                	jne    102f2f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  102f13:	c7 44 24 08 cf 63 10 	movl   $0x1063cf,0x8(%esp)
  102f1a:	00 
  102f1b:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  102f22:	00 
  102f23:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102f2a:	e8 b3 d4 ff ff       	call   1003e2 <__panic>
    }
    return page2kva(p);
  102f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f32:	89 04 24             	mov    %eax,(%esp)
  102f35:	e8 68 f7 ff ff       	call   1026a2 <page2kva>
}
  102f3a:	c9                   	leave  
  102f3b:	c3                   	ret    

00102f3c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  102f3c:	55                   	push   %ebp
  102f3d:	89 e5                	mov    %esp,%ebp
  102f3f:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  102f42:	e8 93 f9 ff ff       	call   1028da <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  102f47:	e8 75 fa ff ff       	call   1029c1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  102f4c:	e8 d7 02 00 00       	call   103228 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  102f51:	e8 a2 ff ff ff       	call   102ef8 <boot_alloc_page>
  102f56:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  102f5b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  102f60:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  102f67:	00 
  102f68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102f6f:	00 
  102f70:	89 04 24             	mov    %eax,(%esp)
  102f73:	e8 20 24 00 00       	call   105398 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  102f78:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  102f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f80:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  102f87:	77 23                	ja     102fac <pmm_init+0x70>
  102f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f90:	c7 44 24 08 64 63 10 	movl   $0x106364,0x8(%esp)
  102f97:	00 
  102f98:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  102f9f:	00 
  102fa0:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102fa7:	e8 36 d4 ff ff       	call   1003e2 <__panic>
  102fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102faf:	05 00 00 00 40       	add    $0x40000000,%eax
  102fb4:	a3 54 89 11 00       	mov    %eax,0x118954

    check_pgdir();
  102fb9:	e8 88 02 00 00       	call   103246 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  102fbe:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  102fc3:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  102fc9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  102fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fd1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  102fd8:	77 23                	ja     102ffd <pmm_init+0xc1>
  102fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fdd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fe1:	c7 44 24 08 64 63 10 	movl   $0x106364,0x8(%esp)
  102fe8:	00 
  102fe9:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  102ff0:	00 
  102ff1:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  102ff8:	e8 e5 d3 ff ff       	call   1003e2 <__panic>
  102ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103000:	05 00 00 00 40       	add    $0x40000000,%eax
  103005:	83 c8 03             	or     $0x3,%eax
  103008:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10300a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10300f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  103016:	00 
  103017:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10301e:	00 
  10301f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  103026:	38 
  103027:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10302e:	c0 
  10302f:	89 04 24             	mov    %eax,(%esp)
  103032:	e8 b4 fd ff ff       	call   102deb <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  103037:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10303c:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  103042:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  103048:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10304a:	e8 63 fd ff ff       	call   102db2 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10304f:	e8 97 f7 ff ff       	call   1027eb <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  103054:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10305f:	e8 7d 08 00 00       	call   1038e1 <check_boot_pgdir>

    print_pgdir();
  103064:	e8 0a 0d 00 00       	call   103d73 <print_pgdir>

}
  103069:	c9                   	leave  
  10306a:	c3                   	ret    

0010306b <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10306b:	55                   	push   %ebp
  10306c:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  10306e:	5d                   	pop    %ebp
  10306f:	c3                   	ret    

00103070 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  103070:	55                   	push   %ebp
  103071:	89 e5                	mov    %esp,%ebp
  103073:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10307d:	00 
  10307e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103081:	89 44 24 04          	mov    %eax,0x4(%esp)
  103085:	8b 45 08             	mov    0x8(%ebp),%eax
  103088:	89 04 24             	mov    %eax,(%esp)
  10308b:	e8 db ff ff ff       	call   10306b <get_pte>
  103090:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103097:	74 08                	je     1030a1 <get_page+0x31>
        *ptep_store = ptep;
  103099:	8b 45 10             	mov    0x10(%ebp),%eax
  10309c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10309f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030a5:	74 1b                	je     1030c2 <get_page+0x52>
  1030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030aa:	8b 00                	mov    (%eax),%eax
  1030ac:	83 e0 01             	and    $0x1,%eax
  1030af:	85 c0                	test   %eax,%eax
  1030b1:	74 0f                	je     1030c2 <get_page+0x52>
        return pa2page(*ptep);
  1030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030b6:	8b 00                	mov    (%eax),%eax
  1030b8:	89 04 24             	mov    %eax,(%esp)
  1030bb:	e8 93 f5 ff ff       	call   102653 <pa2page>
  1030c0:	eb 05                	jmp    1030c7 <get_page+0x57>
    }
    return NULL;
  1030c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030c7:	c9                   	leave  
  1030c8:	c3                   	ret    

001030c9 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1030c9:	55                   	push   %ebp
  1030ca:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1030cc:	5d                   	pop    %ebp
  1030cd:	c3                   	ret    

001030ce <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1030ce:	55                   	push   %ebp
  1030cf:	89 e5                	mov    %esp,%ebp
  1030d1:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1030d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1030db:	00 
  1030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e6:	89 04 24             	mov    %eax,(%esp)
  1030e9:	e8 7d ff ff ff       	call   10306b <get_pte>
  1030ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1030f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1030f5:	74 19                	je     103110 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1030f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103101:	89 44 24 04          	mov    %eax,0x4(%esp)
  103105:	8b 45 08             	mov    0x8(%ebp),%eax
  103108:	89 04 24             	mov    %eax,(%esp)
  10310b:	e8 b9 ff ff ff       	call   1030c9 <page_remove_pte>
    }
}
  103110:	c9                   	leave  
  103111:	c3                   	ret    

00103112 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103112:	55                   	push   %ebp
  103113:	89 e5                	mov    %esp,%ebp
  103115:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103118:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10311f:	00 
  103120:	8b 45 10             	mov    0x10(%ebp),%eax
  103123:	89 44 24 04          	mov    %eax,0x4(%esp)
  103127:	8b 45 08             	mov    0x8(%ebp),%eax
  10312a:	89 04 24             	mov    %eax,(%esp)
  10312d:	e8 39 ff ff ff       	call   10306b <get_pte>
  103132:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103139:	75 0a                	jne    103145 <page_insert+0x33>
        return -E_NO_MEM;
  10313b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103140:	e9 84 00 00 00       	jmp    1031c9 <page_insert+0xb7>
    }
    page_ref_inc(page);
  103145:	8b 45 0c             	mov    0xc(%ebp),%eax
  103148:	89 04 24             	mov    %eax,(%esp)
  10314b:	e8 ee f5 ff ff       	call   10273e <page_ref_inc>
    if (*ptep & PTE_P) {
  103150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103153:	8b 00                	mov    (%eax),%eax
  103155:	83 e0 01             	and    $0x1,%eax
  103158:	85 c0                	test   %eax,%eax
  10315a:	74 3e                	je     10319a <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10315f:	8b 00                	mov    (%eax),%eax
  103161:	89 04 24             	mov    %eax,(%esp)
  103164:	e8 8d f5 ff ff       	call   1026f6 <pte2page>
  103169:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103172:	75 0d                	jne    103181 <page_insert+0x6f>
            page_ref_dec(page);
  103174:	8b 45 0c             	mov    0xc(%ebp),%eax
  103177:	89 04 24             	mov    %eax,(%esp)
  10317a:	e8 d6 f5 ff ff       	call   102755 <page_ref_dec>
  10317f:	eb 19                	jmp    10319a <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  103181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103184:	89 44 24 08          	mov    %eax,0x8(%esp)
  103188:	8b 45 10             	mov    0x10(%ebp),%eax
  10318b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10318f:	8b 45 08             	mov    0x8(%ebp),%eax
  103192:	89 04 24             	mov    %eax,(%esp)
  103195:	e8 2f ff ff ff       	call   1030c9 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10319a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319d:	89 04 24             	mov    %eax,(%esp)
  1031a0:	e8 98 f4 ff ff       	call   10263d <page2pa>
  1031a5:	0b 45 14             	or     0x14(%ebp),%eax
  1031a8:	83 c8 01             	or     $0x1,%eax
  1031ab:	89 c2                	mov    %eax,%edx
  1031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031b0:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1031b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1031b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bc:	89 04 24             	mov    %eax,(%esp)
  1031bf:	e8 07 00 00 00       	call   1031cb <tlb_invalidate>
    return 0;
  1031c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1031c9:	c9                   	leave  
  1031ca:	c3                   	ret    

001031cb <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1031cb:	55                   	push   %ebp
  1031cc:	89 e5                	mov    %esp,%ebp
  1031ce:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1031d1:	0f 20 d8             	mov    %cr3,%eax
  1031d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1031da:	89 c2                	mov    %eax,%edx
  1031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031e2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1031e9:	77 23                	ja     10320e <tlb_invalidate+0x43>
  1031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1031f2:	c7 44 24 08 64 63 10 	movl   $0x106364,0x8(%esp)
  1031f9:	00 
  1031fa:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  103201:	00 
  103202:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103209:	e8 d4 d1 ff ff       	call   1003e2 <__panic>
  10320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103211:	05 00 00 00 40       	add    $0x40000000,%eax
  103216:	39 c2                	cmp    %eax,%edx
  103218:	75 0c                	jne    103226 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10321a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321d:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103223:	0f 01 38             	invlpg (%eax)
    }
}
  103226:	c9                   	leave  
  103227:	c3                   	ret    

00103228 <check_alloc_page>:

static void
check_alloc_page(void) {
  103228:	55                   	push   %ebp
  103229:	89 e5                	mov    %esp,%ebp
  10322b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10322e:	a1 50 89 11 00       	mov    0x118950,%eax
  103233:	8b 40 18             	mov    0x18(%eax),%eax
  103236:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103238:	c7 04 24 e8 63 10 00 	movl   $0x1063e8,(%esp)
  10323f:	e8 47 d0 ff ff       	call   10028b <cprintf>
}
  103244:	c9                   	leave  
  103245:	c3                   	ret    

00103246 <check_pgdir>:

static void
check_pgdir(void) {
  103246:	55                   	push   %ebp
  103247:	89 e5                	mov    %esp,%ebp
  103249:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10324c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103251:	3d 00 80 03 00       	cmp    $0x38000,%eax
  103256:	76 24                	jbe    10327c <check_pgdir+0x36>
  103258:	c7 44 24 0c 07 64 10 	movl   $0x106407,0xc(%esp)
  10325f:	00 
  103260:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103267:	00 
  103268:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  10326f:	00 
  103270:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103277:	e8 66 d1 ff ff       	call   1003e2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10327c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103281:	85 c0                	test   %eax,%eax
  103283:	74 0e                	je     103293 <check_pgdir+0x4d>
  103285:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10328a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10328f:	85 c0                	test   %eax,%eax
  103291:	74 24                	je     1032b7 <check_pgdir+0x71>
  103293:	c7 44 24 0c 24 64 10 	movl   $0x106424,0xc(%esp)
  10329a:	00 
  10329b:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1032a2:	00 
  1032a3:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  1032aa:	00 
  1032ab:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1032b2:	e8 2b d1 ff ff       	call   1003e2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1032b7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1032bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1032c3:	00 
  1032c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1032cb:	00 
  1032cc:	89 04 24             	mov    %eax,(%esp)
  1032cf:	e8 9c fd ff ff       	call   103070 <get_page>
  1032d4:	85 c0                	test   %eax,%eax
  1032d6:	74 24                	je     1032fc <check_pgdir+0xb6>
  1032d8:	c7 44 24 0c 5c 64 10 	movl   $0x10645c,0xc(%esp)
  1032df:	00 
  1032e0:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1032e7:	00 
  1032e8:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  1032ef:	00 
  1032f0:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1032f7:	e8 e6 d0 ff ff       	call   1003e2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1032fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103303:	e8 24 f6 ff ff       	call   10292c <alloc_pages>
  103308:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10330b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103310:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103317:	00 
  103318:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10331f:	00 
  103320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103323:	89 54 24 04          	mov    %edx,0x4(%esp)
  103327:	89 04 24             	mov    %eax,(%esp)
  10332a:	e8 e3 fd ff ff       	call   103112 <page_insert>
  10332f:	85 c0                	test   %eax,%eax
  103331:	74 24                	je     103357 <check_pgdir+0x111>
  103333:	c7 44 24 0c 84 64 10 	movl   $0x106484,0xc(%esp)
  10333a:	00 
  10333b:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103342:	00 
  103343:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  10334a:	00 
  10334b:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103352:	e8 8b d0 ff ff       	call   1003e2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103357:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10335c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103363:	00 
  103364:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10336b:	00 
  10336c:	89 04 24             	mov    %eax,(%esp)
  10336f:	e8 f7 fc ff ff       	call   10306b <get_pte>
  103374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10337b:	75 24                	jne    1033a1 <check_pgdir+0x15b>
  10337d:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  103384:	00 
  103385:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  10338c:	00 
  10338d:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  103394:	00 
  103395:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10339c:	e8 41 d0 ff ff       	call   1003e2 <__panic>
    assert(pa2page(*ptep) == p1);
  1033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a4:	8b 00                	mov    (%eax),%eax
  1033a6:	89 04 24             	mov    %eax,(%esp)
  1033a9:	e8 a5 f2 ff ff       	call   102653 <pa2page>
  1033ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1033b1:	74 24                	je     1033d7 <check_pgdir+0x191>
  1033b3:	c7 44 24 0c dd 64 10 	movl   $0x1064dd,0xc(%esp)
  1033ba:	00 
  1033bb:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1033c2:	00 
  1033c3:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1033ca:	00 
  1033cb:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1033d2:	e8 0b d0 ff ff       	call   1003e2 <__panic>
    assert(page_ref(p1) == 1);
  1033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033da:	89 04 24             	mov    %eax,(%esp)
  1033dd:	e8 52 f3 ff ff       	call   102734 <page_ref>
  1033e2:	83 f8 01             	cmp    $0x1,%eax
  1033e5:	74 24                	je     10340b <check_pgdir+0x1c5>
  1033e7:	c7 44 24 0c f2 64 10 	movl   $0x1064f2,0xc(%esp)
  1033ee:	00 
  1033ef:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1033f6:	00 
  1033f7:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  1033fe:	00 
  1033ff:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103406:	e8 d7 cf ff ff       	call   1003e2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10340b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103410:	8b 00                	mov    (%eax),%eax
  103412:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103417:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10341a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10341d:	c1 e8 0c             	shr    $0xc,%eax
  103420:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103423:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103428:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10342b:	72 23                	jb     103450 <check_pgdir+0x20a>
  10342d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103434:	c7 44 24 08 c0 62 10 	movl   $0x1062c0,0x8(%esp)
  10343b:	00 
  10343c:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  103443:	00 
  103444:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10344b:	e8 92 cf ff ff       	call   1003e2 <__panic>
  103450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103453:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103458:	83 c0 04             	add    $0x4,%eax
  10345b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10345e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103463:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10346a:	00 
  10346b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103472:	00 
  103473:	89 04 24             	mov    %eax,(%esp)
  103476:	e8 f0 fb ff ff       	call   10306b <get_pte>
  10347b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10347e:	74 24                	je     1034a4 <check_pgdir+0x25e>
  103480:	c7 44 24 0c 04 65 10 	movl   $0x106504,0xc(%esp)
  103487:	00 
  103488:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  10348f:	00 
  103490:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  103497:	00 
  103498:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10349f:	e8 3e cf ff ff       	call   1003e2 <__panic>

    p2 = alloc_page();
  1034a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034ab:	e8 7c f4 ff ff       	call   10292c <alloc_pages>
  1034b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1034b3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1034b8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1034bf:	00 
  1034c0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1034c7:	00 
  1034c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1034cf:	89 04 24             	mov    %eax,(%esp)
  1034d2:	e8 3b fc ff ff       	call   103112 <page_insert>
  1034d7:	85 c0                	test   %eax,%eax
  1034d9:	74 24                	je     1034ff <check_pgdir+0x2b9>
  1034db:	c7 44 24 0c 2c 65 10 	movl   $0x10652c,0xc(%esp)
  1034e2:	00 
  1034e3:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1034ea:	00 
  1034eb:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1034f2:	00 
  1034f3:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1034fa:	e8 e3 ce ff ff       	call   1003e2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1034ff:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103504:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10350b:	00 
  10350c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103513:	00 
  103514:	89 04 24             	mov    %eax,(%esp)
  103517:	e8 4f fb ff ff       	call   10306b <get_pte>
  10351c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10351f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103523:	75 24                	jne    103549 <check_pgdir+0x303>
  103525:	c7 44 24 0c 64 65 10 	movl   $0x106564,0xc(%esp)
  10352c:	00 
  10352d:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103534:	00 
  103535:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  10353c:	00 
  10353d:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103544:	e8 99 ce ff ff       	call   1003e2 <__panic>
    assert(*ptep & PTE_U);
  103549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354c:	8b 00                	mov    (%eax),%eax
  10354e:	83 e0 04             	and    $0x4,%eax
  103551:	85 c0                	test   %eax,%eax
  103553:	75 24                	jne    103579 <check_pgdir+0x333>
  103555:	c7 44 24 0c 94 65 10 	movl   $0x106594,0xc(%esp)
  10355c:	00 
  10355d:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103564:	00 
  103565:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  10356c:	00 
  10356d:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103574:	e8 69 ce ff ff       	call   1003e2 <__panic>
    assert(*ptep & PTE_W);
  103579:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10357c:	8b 00                	mov    (%eax),%eax
  10357e:	83 e0 02             	and    $0x2,%eax
  103581:	85 c0                	test   %eax,%eax
  103583:	75 24                	jne    1035a9 <check_pgdir+0x363>
  103585:	c7 44 24 0c a2 65 10 	movl   $0x1065a2,0xc(%esp)
  10358c:	00 
  10358d:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103594:	00 
  103595:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  10359c:	00 
  10359d:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1035a4:	e8 39 ce ff ff       	call   1003e2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  1035a9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1035ae:	8b 00                	mov    (%eax),%eax
  1035b0:	83 e0 04             	and    $0x4,%eax
  1035b3:	85 c0                	test   %eax,%eax
  1035b5:	75 24                	jne    1035db <check_pgdir+0x395>
  1035b7:	c7 44 24 0c b0 65 10 	movl   $0x1065b0,0xc(%esp)
  1035be:	00 
  1035bf:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1035c6:	00 
  1035c7:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  1035ce:	00 
  1035cf:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1035d6:	e8 07 ce ff ff       	call   1003e2 <__panic>
    assert(page_ref(p2) == 1);
  1035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035de:	89 04 24             	mov    %eax,(%esp)
  1035e1:	e8 4e f1 ff ff       	call   102734 <page_ref>
  1035e6:	83 f8 01             	cmp    $0x1,%eax
  1035e9:	74 24                	je     10360f <check_pgdir+0x3c9>
  1035eb:	c7 44 24 0c c6 65 10 	movl   $0x1065c6,0xc(%esp)
  1035f2:	00 
  1035f3:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1035fa:	00 
  1035fb:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103602:	00 
  103603:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10360a:	e8 d3 cd ff ff       	call   1003e2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10360f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103614:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10361b:	00 
  10361c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103623:	00 
  103624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103627:	89 54 24 04          	mov    %edx,0x4(%esp)
  10362b:	89 04 24             	mov    %eax,(%esp)
  10362e:	e8 df fa ff ff       	call   103112 <page_insert>
  103633:	85 c0                	test   %eax,%eax
  103635:	74 24                	je     10365b <check_pgdir+0x415>
  103637:	c7 44 24 0c d8 65 10 	movl   $0x1065d8,0xc(%esp)
  10363e:	00 
  10363f:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103646:	00 
  103647:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  10364e:	00 
  10364f:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103656:	e8 87 cd ff ff       	call   1003e2 <__panic>
    assert(page_ref(p1) == 2);
  10365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10365e:	89 04 24             	mov    %eax,(%esp)
  103661:	e8 ce f0 ff ff       	call   102734 <page_ref>
  103666:	83 f8 02             	cmp    $0x2,%eax
  103669:	74 24                	je     10368f <check_pgdir+0x449>
  10366b:	c7 44 24 0c 04 66 10 	movl   $0x106604,0xc(%esp)
  103672:	00 
  103673:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  10367a:	00 
  10367b:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103682:	00 
  103683:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10368a:	e8 53 cd ff ff       	call   1003e2 <__panic>
    assert(page_ref(p2) == 0);
  10368f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103692:	89 04 24             	mov    %eax,(%esp)
  103695:	e8 9a f0 ff ff       	call   102734 <page_ref>
  10369a:	85 c0                	test   %eax,%eax
  10369c:	74 24                	je     1036c2 <check_pgdir+0x47c>
  10369e:	c7 44 24 0c 16 66 10 	movl   $0x106616,0xc(%esp)
  1036a5:	00 
  1036a6:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1036ad:	00 
  1036ae:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  1036b5:	00 
  1036b6:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1036bd:	e8 20 cd ff ff       	call   1003e2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1036c2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1036c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036ce:	00 
  1036cf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1036d6:	00 
  1036d7:	89 04 24             	mov    %eax,(%esp)
  1036da:	e8 8c f9 ff ff       	call   10306b <get_pte>
  1036df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1036e6:	75 24                	jne    10370c <check_pgdir+0x4c6>
  1036e8:	c7 44 24 0c 64 65 10 	movl   $0x106564,0xc(%esp)
  1036ef:	00 
  1036f0:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1036f7:	00 
  1036f8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  1036ff:	00 
  103700:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103707:	e8 d6 cc ff ff       	call   1003e2 <__panic>
    assert(pa2page(*ptep) == p1);
  10370c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10370f:	8b 00                	mov    (%eax),%eax
  103711:	89 04 24             	mov    %eax,(%esp)
  103714:	e8 3a ef ff ff       	call   102653 <pa2page>
  103719:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10371c:	74 24                	je     103742 <check_pgdir+0x4fc>
  10371e:	c7 44 24 0c dd 64 10 	movl   $0x1064dd,0xc(%esp)
  103725:	00 
  103726:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  10372d:	00 
  10372e:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103735:	00 
  103736:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10373d:	e8 a0 cc ff ff       	call   1003e2 <__panic>
    assert((*ptep & PTE_U) == 0);
  103742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103745:	8b 00                	mov    (%eax),%eax
  103747:	83 e0 04             	and    $0x4,%eax
  10374a:	85 c0                	test   %eax,%eax
  10374c:	74 24                	je     103772 <check_pgdir+0x52c>
  10374e:	c7 44 24 0c 28 66 10 	movl   $0x106628,0xc(%esp)
  103755:	00 
  103756:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  10375d:	00 
  10375e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103765:	00 
  103766:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10376d:	e8 70 cc ff ff       	call   1003e2 <__panic>

    page_remove(boot_pgdir, 0x0);
  103772:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103777:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10377e:	00 
  10377f:	89 04 24             	mov    %eax,(%esp)
  103782:	e8 47 f9 ff ff       	call   1030ce <page_remove>
    assert(page_ref(p1) == 1);
  103787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10378a:	89 04 24             	mov    %eax,(%esp)
  10378d:	e8 a2 ef ff ff       	call   102734 <page_ref>
  103792:	83 f8 01             	cmp    $0x1,%eax
  103795:	74 24                	je     1037bb <check_pgdir+0x575>
  103797:	c7 44 24 0c f2 64 10 	movl   $0x1064f2,0xc(%esp)
  10379e:	00 
  10379f:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1037a6:	00 
  1037a7:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  1037ae:	00 
  1037af:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1037b6:	e8 27 cc ff ff       	call   1003e2 <__panic>
    assert(page_ref(p2) == 0);
  1037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037be:	89 04 24             	mov    %eax,(%esp)
  1037c1:	e8 6e ef ff ff       	call   102734 <page_ref>
  1037c6:	85 c0                	test   %eax,%eax
  1037c8:	74 24                	je     1037ee <check_pgdir+0x5a8>
  1037ca:	c7 44 24 0c 16 66 10 	movl   $0x106616,0xc(%esp)
  1037d1:	00 
  1037d2:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1037d9:	00 
  1037da:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  1037e1:	00 
  1037e2:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1037e9:	e8 f4 cb ff ff       	call   1003e2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  1037ee:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1037f3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037fa:	00 
  1037fb:	89 04 24             	mov    %eax,(%esp)
  1037fe:	e8 cb f8 ff ff       	call   1030ce <page_remove>
    assert(page_ref(p1) == 0);
  103803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103806:	89 04 24             	mov    %eax,(%esp)
  103809:	e8 26 ef ff ff       	call   102734 <page_ref>
  10380e:	85 c0                	test   %eax,%eax
  103810:	74 24                	je     103836 <check_pgdir+0x5f0>
  103812:	c7 44 24 0c 3d 66 10 	movl   $0x10663d,0xc(%esp)
  103819:	00 
  10381a:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103821:	00 
  103822:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103829:	00 
  10382a:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103831:	e8 ac cb ff ff       	call   1003e2 <__panic>
    assert(page_ref(p2) == 0);
  103836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103839:	89 04 24             	mov    %eax,(%esp)
  10383c:	e8 f3 ee ff ff       	call   102734 <page_ref>
  103841:	85 c0                	test   %eax,%eax
  103843:	74 24                	je     103869 <check_pgdir+0x623>
  103845:	c7 44 24 0c 16 66 10 	movl   $0x106616,0xc(%esp)
  10384c:	00 
  10384d:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103854:	00 
  103855:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  10385c:	00 
  10385d:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103864:	e8 79 cb ff ff       	call   1003e2 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  103869:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10386e:	8b 00                	mov    (%eax),%eax
  103870:	89 04 24             	mov    %eax,(%esp)
  103873:	e8 db ed ff ff       	call   102653 <pa2page>
  103878:	89 04 24             	mov    %eax,(%esp)
  10387b:	e8 b4 ee ff ff       	call   102734 <page_ref>
  103880:	83 f8 01             	cmp    $0x1,%eax
  103883:	74 24                	je     1038a9 <check_pgdir+0x663>
  103885:	c7 44 24 0c 50 66 10 	movl   $0x106650,0xc(%esp)
  10388c:	00 
  10388d:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103894:	00 
  103895:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  10389c:	00 
  10389d:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1038a4:	e8 39 cb ff ff       	call   1003e2 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  1038a9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038ae:	8b 00                	mov    (%eax),%eax
  1038b0:	89 04 24             	mov    %eax,(%esp)
  1038b3:	e8 9b ed ff ff       	call   102653 <pa2page>
  1038b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038bf:	00 
  1038c0:	89 04 24             	mov    %eax,(%esp)
  1038c3:	e8 9c f0 ff ff       	call   102964 <free_pages>
    boot_pgdir[0] = 0;
  1038c8:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1038cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1038d3:	c7 04 24 76 66 10 00 	movl   $0x106676,(%esp)
  1038da:	e8 ac c9 ff ff       	call   10028b <cprintf>
}
  1038df:	c9                   	leave  
  1038e0:	c3                   	ret    

001038e1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1038e1:	55                   	push   %ebp
  1038e2:	89 e5                	mov    %esp,%ebp
  1038e4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1038e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1038ee:	e9 ca 00 00 00       	jmp    1039bd <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038fc:	c1 e8 0c             	shr    $0xc,%eax
  1038ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103902:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103907:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10390a:	72 23                	jb     10392f <check_boot_pgdir+0x4e>
  10390c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10390f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103913:	c7 44 24 08 c0 62 10 	movl   $0x1062c0,0x8(%esp)
  10391a:	00 
  10391b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103922:	00 
  103923:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10392a:	e8 b3 ca ff ff       	call   1003e2 <__panic>
  10392f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103932:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103937:	89 c2                	mov    %eax,%edx
  103939:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10393e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103945:	00 
  103946:	89 54 24 04          	mov    %edx,0x4(%esp)
  10394a:	89 04 24             	mov    %eax,(%esp)
  10394d:	e8 19 f7 ff ff       	call   10306b <get_pte>
  103952:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103955:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103959:	75 24                	jne    10397f <check_boot_pgdir+0x9e>
  10395b:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  103962:	00 
  103963:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  10396a:	00 
  10396b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103972:	00 
  103973:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  10397a:	e8 63 ca ff ff       	call   1003e2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10397f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103982:	8b 00                	mov    (%eax),%eax
  103984:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103989:	89 c2                	mov    %eax,%edx
  10398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10398e:	39 c2                	cmp    %eax,%edx
  103990:	74 24                	je     1039b6 <check_boot_pgdir+0xd5>
  103992:	c7 44 24 0c cd 66 10 	movl   $0x1066cd,0xc(%esp)
  103999:	00 
  10399a:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  1039a1:	00 
  1039a2:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  1039a9:	00 
  1039aa:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  1039b1:	e8 2c ca ff ff       	call   1003e2 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  1039b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1039bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1039c0:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039c5:	39 c2                	cmp    %eax,%edx
  1039c7:	0f 82 26 ff ff ff    	jb     1038f3 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1039cd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039d2:	05 ac 0f 00 00       	add    $0xfac,%eax
  1039d7:	8b 00                	mov    (%eax),%eax
  1039d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039de:	89 c2                	mov    %eax,%edx
  1039e0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1039e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1039e8:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1039ef:	77 23                	ja     103a14 <check_boot_pgdir+0x133>
  1039f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039f8:	c7 44 24 08 64 63 10 	movl   $0x106364,0x8(%esp)
  1039ff:	00 
  103a00:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103a07:	00 
  103a08:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103a0f:	e8 ce c9 ff ff       	call   1003e2 <__panic>
  103a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a17:	05 00 00 00 40       	add    $0x40000000,%eax
  103a1c:	39 c2                	cmp    %eax,%edx
  103a1e:	74 24                	je     103a44 <check_boot_pgdir+0x163>
  103a20:	c7 44 24 0c e4 66 10 	movl   $0x1066e4,0xc(%esp)
  103a27:	00 
  103a28:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103a2f:	00 
  103a30:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  103a37:	00 
  103a38:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103a3f:	e8 9e c9 ff ff       	call   1003e2 <__panic>

    assert(boot_pgdir[0] == 0);
  103a44:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a49:	8b 00                	mov    (%eax),%eax
  103a4b:	85 c0                	test   %eax,%eax
  103a4d:	74 24                	je     103a73 <check_boot_pgdir+0x192>
  103a4f:	c7 44 24 0c 18 67 10 	movl   $0x106718,0xc(%esp)
  103a56:	00 
  103a57:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103a5e:	00 
  103a5f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  103a66:	00 
  103a67:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103a6e:	e8 6f c9 ff ff       	call   1003e2 <__panic>

    struct Page *p;
    p = alloc_page();
  103a73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a7a:	e8 ad ee ff ff       	call   10292c <alloc_pages>
  103a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103a82:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103a87:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103a8e:	00 
  103a8f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103a96:	00 
  103a97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103a9a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a9e:	89 04 24             	mov    %eax,(%esp)
  103aa1:	e8 6c f6 ff ff       	call   103112 <page_insert>
  103aa6:	85 c0                	test   %eax,%eax
  103aa8:	74 24                	je     103ace <check_boot_pgdir+0x1ed>
  103aaa:	c7 44 24 0c 2c 67 10 	movl   $0x10672c,0xc(%esp)
  103ab1:	00 
  103ab2:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103ab9:	00 
  103aba:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103ac1:	00 
  103ac2:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103ac9:	e8 14 c9 ff ff       	call   1003e2 <__panic>
    assert(page_ref(p) == 1);
  103ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ad1:	89 04 24             	mov    %eax,(%esp)
  103ad4:	e8 5b ec ff ff       	call   102734 <page_ref>
  103ad9:	83 f8 01             	cmp    $0x1,%eax
  103adc:	74 24                	je     103b02 <check_boot_pgdir+0x221>
  103ade:	c7 44 24 0c 5a 67 10 	movl   $0x10675a,0xc(%esp)
  103ae5:	00 
  103ae6:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103aed:	00 
  103aee:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103af5:	00 
  103af6:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103afd:	e8 e0 c8 ff ff       	call   1003e2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103b02:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103b07:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103b0e:	00 
  103b0f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103b16:	00 
  103b17:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103b1a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b1e:	89 04 24             	mov    %eax,(%esp)
  103b21:	e8 ec f5 ff ff       	call   103112 <page_insert>
  103b26:	85 c0                	test   %eax,%eax
  103b28:	74 24                	je     103b4e <check_boot_pgdir+0x26d>
  103b2a:	c7 44 24 0c 6c 67 10 	movl   $0x10676c,0xc(%esp)
  103b31:	00 
  103b32:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103b39:	00 
  103b3a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  103b41:	00 
  103b42:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103b49:	e8 94 c8 ff ff       	call   1003e2 <__panic>
    assert(page_ref(p) == 2);
  103b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b51:	89 04 24             	mov    %eax,(%esp)
  103b54:	e8 db eb ff ff       	call   102734 <page_ref>
  103b59:	83 f8 02             	cmp    $0x2,%eax
  103b5c:	74 24                	je     103b82 <check_boot_pgdir+0x2a1>
  103b5e:	c7 44 24 0c a3 67 10 	movl   $0x1067a3,0xc(%esp)
  103b65:	00 
  103b66:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103b6d:	00 
  103b6e:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  103b75:	00 
  103b76:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103b7d:	e8 60 c8 ff ff       	call   1003e2 <__panic>

    const char *str = "ucore: Hello world!!";
  103b82:	c7 45 dc b4 67 10 00 	movl   $0x1067b4,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103b89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103b90:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103b97:	e8 25 15 00 00       	call   1050c1 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103b9c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103ba3:	00 
  103ba4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103bab:	e8 8a 15 00 00       	call   10513a <strcmp>
  103bb0:	85 c0                	test   %eax,%eax
  103bb2:	74 24                	je     103bd8 <check_boot_pgdir+0x2f7>
  103bb4:	c7 44 24 0c cc 67 10 	movl   $0x1067cc,0xc(%esp)
  103bbb:	00 
  103bbc:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103bc3:	00 
  103bc4:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  103bcb:	00 
  103bcc:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103bd3:	e8 0a c8 ff ff       	call   1003e2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103bdb:	89 04 24             	mov    %eax,(%esp)
  103bde:	e8 bf ea ff ff       	call   1026a2 <page2kva>
  103be3:	05 00 01 00 00       	add    $0x100,%eax
  103be8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103beb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103bf2:	e8 72 14 00 00       	call   105069 <strlen>
  103bf7:	85 c0                	test   %eax,%eax
  103bf9:	74 24                	je     103c1f <check_boot_pgdir+0x33e>
  103bfb:	c7 44 24 0c 04 68 10 	movl   $0x106804,0xc(%esp)
  103c02:	00 
  103c03:	c7 44 24 08 ad 63 10 	movl   $0x1063ad,0x8(%esp)
  103c0a:	00 
  103c0b:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  103c12:	00 
  103c13:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  103c1a:	e8 c3 c7 ff ff       	call   1003e2 <__panic>

    free_page(p);
  103c1f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c26:	00 
  103c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c2a:	89 04 24             	mov    %eax,(%esp)
  103c2d:	e8 32 ed ff ff       	call   102964 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  103c32:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c37:	8b 00                	mov    (%eax),%eax
  103c39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103c3e:	89 04 24             	mov    %eax,(%esp)
  103c41:	e8 0d ea ff ff       	call   102653 <pa2page>
  103c46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c4d:	00 
  103c4e:	89 04 24             	mov    %eax,(%esp)
  103c51:	e8 0e ed ff ff       	call   102964 <free_pages>
    boot_pgdir[0] = 0;
  103c56:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  103c5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103c61:	c7 04 24 28 68 10 00 	movl   $0x106828,(%esp)
  103c68:	e8 1e c6 ff ff       	call   10028b <cprintf>
}
  103c6d:	c9                   	leave  
  103c6e:	c3                   	ret    

00103c6f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103c6f:	55                   	push   %ebp
  103c70:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103c72:	8b 45 08             	mov    0x8(%ebp),%eax
  103c75:	83 e0 04             	and    $0x4,%eax
  103c78:	85 c0                	test   %eax,%eax
  103c7a:	74 07                	je     103c83 <perm2str+0x14>
  103c7c:	b8 75 00 00 00       	mov    $0x75,%eax
  103c81:	eb 05                	jmp    103c88 <perm2str+0x19>
  103c83:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103c88:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  103c8d:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103c94:	8b 45 08             	mov    0x8(%ebp),%eax
  103c97:	83 e0 02             	and    $0x2,%eax
  103c9a:	85 c0                	test   %eax,%eax
  103c9c:	74 07                	je     103ca5 <perm2str+0x36>
  103c9e:	b8 77 00 00 00       	mov    $0x77,%eax
  103ca3:	eb 05                	jmp    103caa <perm2str+0x3b>
  103ca5:	b8 2d 00 00 00       	mov    $0x2d,%eax
  103caa:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  103caf:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  103cb6:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  103cbb:	5d                   	pop    %ebp
  103cbc:	c3                   	ret    

00103cbd <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103cbd:	55                   	push   %ebp
  103cbe:	89 e5                	mov    %esp,%ebp
  103cc0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  103cc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103cc9:	72 0a                	jb     103cd5 <get_pgtable_items+0x18>
        return 0;
  103ccb:	b8 00 00 00 00       	mov    $0x0,%eax
  103cd0:	e9 9c 00 00 00       	jmp    103d71 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  103cd5:	eb 04                	jmp    103cdb <get_pgtable_items+0x1e>
        start ++;
  103cd7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  103cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  103cde:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103ce1:	73 18                	jae    103cfb <get_pgtable_items+0x3e>
  103ce3:	8b 45 10             	mov    0x10(%ebp),%eax
  103ce6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103ced:	8b 45 14             	mov    0x14(%ebp),%eax
  103cf0:	01 d0                	add    %edx,%eax
  103cf2:	8b 00                	mov    (%eax),%eax
  103cf4:	83 e0 01             	and    $0x1,%eax
  103cf7:	85 c0                	test   %eax,%eax
  103cf9:	74 dc                	je     103cd7 <get_pgtable_items+0x1a>
    }
    if (start < right) {
  103cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  103cfe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d01:	73 69                	jae    103d6c <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  103d03:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103d07:	74 08                	je     103d11 <get_pgtable_items+0x54>
            *left_store = start;
  103d09:	8b 45 18             	mov    0x18(%ebp),%eax
  103d0c:	8b 55 10             	mov    0x10(%ebp),%edx
  103d0f:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103d11:	8b 45 10             	mov    0x10(%ebp),%eax
  103d14:	8d 50 01             	lea    0x1(%eax),%edx
  103d17:	89 55 10             	mov    %edx,0x10(%ebp)
  103d1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d21:	8b 45 14             	mov    0x14(%ebp),%eax
  103d24:	01 d0                	add    %edx,%eax
  103d26:	8b 00                	mov    (%eax),%eax
  103d28:	83 e0 07             	and    $0x7,%eax
  103d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103d2e:	eb 04                	jmp    103d34 <get_pgtable_items+0x77>
            start ++;
  103d30:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103d34:	8b 45 10             	mov    0x10(%ebp),%eax
  103d37:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d3a:	73 1d                	jae    103d59 <get_pgtable_items+0x9c>
  103d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  103d3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d46:	8b 45 14             	mov    0x14(%ebp),%eax
  103d49:	01 d0                	add    %edx,%eax
  103d4b:	8b 00                	mov    (%eax),%eax
  103d4d:	83 e0 07             	and    $0x7,%eax
  103d50:	89 c2                	mov    %eax,%edx
  103d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103d55:	39 c2                	cmp    %eax,%edx
  103d57:	74 d7                	je     103d30 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
  103d59:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103d5d:	74 08                	je     103d67 <get_pgtable_items+0xaa>
            *right_store = start;
  103d5f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103d62:	8b 55 10             	mov    0x10(%ebp),%edx
  103d65:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103d6a:	eb 05                	jmp    103d71 <get_pgtable_items+0xb4>
    }
    return 0;
  103d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d71:	c9                   	leave  
  103d72:	c3                   	ret    

00103d73 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  103d73:	55                   	push   %ebp
  103d74:	89 e5                	mov    %esp,%ebp
  103d76:	57                   	push   %edi
  103d77:	56                   	push   %esi
  103d78:	53                   	push   %ebx
  103d79:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  103d7c:	c7 04 24 48 68 10 00 	movl   $0x106848,(%esp)
  103d83:	e8 03 c5 ff ff       	call   10028b <cprintf>
    size_t left, right = 0, perm;
  103d88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103d8f:	e9 fa 00 00 00       	jmp    103e8e <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d97:	89 04 24             	mov    %eax,(%esp)
  103d9a:	e8 d0 fe ff ff       	call   103c6f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  103d9f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103da2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103da5:	29 d1                	sub    %edx,%ecx
  103da7:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103da9:	89 d6                	mov    %edx,%esi
  103dab:	c1 e6 16             	shl    $0x16,%esi
  103dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103db1:	89 d3                	mov    %edx,%ebx
  103db3:	c1 e3 16             	shl    $0x16,%ebx
  103db6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103db9:	89 d1                	mov    %edx,%ecx
  103dbb:	c1 e1 16             	shl    $0x16,%ecx
  103dbe:	8b 7d dc             	mov    -0x24(%ebp),%edi
  103dc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103dc4:	29 d7                	sub    %edx,%edi
  103dc6:	89 fa                	mov    %edi,%edx
  103dc8:	89 44 24 14          	mov    %eax,0x14(%esp)
  103dcc:	89 74 24 10          	mov    %esi,0x10(%esp)
  103dd0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103dd4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103dd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ddc:	c7 04 24 79 68 10 00 	movl   $0x106879,(%esp)
  103de3:	e8 a3 c4 ff ff       	call   10028b <cprintf>
        size_t l, r = left * NPTEENTRY;
  103de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103deb:	c1 e0 0a             	shl    $0xa,%eax
  103dee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103df1:	eb 54                	jmp    103e47 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103df6:	89 04 24             	mov    %eax,(%esp)
  103df9:	e8 71 fe ff ff       	call   103c6f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  103dfe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103e01:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103e04:	29 d1                	sub    %edx,%ecx
  103e06:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103e08:	89 d6                	mov    %edx,%esi
  103e0a:	c1 e6 0c             	shl    $0xc,%esi
  103e0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103e10:	89 d3                	mov    %edx,%ebx
  103e12:	c1 e3 0c             	shl    $0xc,%ebx
  103e15:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103e18:	c1 e2 0c             	shl    $0xc,%edx
  103e1b:	89 d1                	mov    %edx,%ecx
  103e1d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  103e20:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103e23:	29 d7                	sub    %edx,%edi
  103e25:	89 fa                	mov    %edi,%edx
  103e27:	89 44 24 14          	mov    %eax,0x14(%esp)
  103e2b:	89 74 24 10          	mov    %esi,0x10(%esp)
  103e2f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103e33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103e37:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e3b:	c7 04 24 98 68 10 00 	movl   $0x106898,(%esp)
  103e42:	e8 44 c4 ff ff       	call   10028b <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103e47:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  103e4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103e4f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103e52:	89 ce                	mov    %ecx,%esi
  103e54:	c1 e6 0a             	shl    $0xa,%esi
  103e57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  103e5a:	89 cb                	mov    %ecx,%ebx
  103e5c:	c1 e3 0a             	shl    $0xa,%ebx
  103e5f:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  103e62:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  103e66:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  103e69:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  103e6d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103e71:	89 44 24 08          	mov    %eax,0x8(%esp)
  103e75:	89 74 24 04          	mov    %esi,0x4(%esp)
  103e79:	89 1c 24             	mov    %ebx,(%esp)
  103e7c:	e8 3c fe ff ff       	call   103cbd <get_pgtable_items>
  103e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e88:	0f 85 65 ff ff ff    	jne    103df3 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103e8e:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  103e93:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103e96:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  103e99:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  103e9d:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  103ea0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  103ea4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
  103eac:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  103eb3:	00 
  103eb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103ebb:	e8 fd fd ff ff       	call   103cbd <get_pgtable_items>
  103ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ec3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ec7:	0f 85 c7 fe ff ff    	jne    103d94 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  103ecd:	c7 04 24 bc 68 10 00 	movl   $0x1068bc,(%esp)
  103ed4:	e8 b2 c3 ff ff       	call   10028b <cprintf>
}
  103ed9:	83 c4 4c             	add    $0x4c,%esp
  103edc:	5b                   	pop    %ebx
  103edd:	5e                   	pop    %esi
  103ede:	5f                   	pop    %edi
  103edf:	5d                   	pop    %ebp
  103ee0:	c3                   	ret    

00103ee1 <page2ppn>:
page2ppn(struct Page *page) {
  103ee1:	55                   	push   %ebp
  103ee2:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  103ee7:	a1 58 89 11 00       	mov    0x118958,%eax
  103eec:	29 c2                	sub    %eax,%edx
  103eee:	89 d0                	mov    %edx,%eax
  103ef0:	c1 f8 02             	sar    $0x2,%eax
  103ef3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103ef9:	5d                   	pop    %ebp
  103efa:	c3                   	ret    

00103efb <page2pa>:
page2pa(struct Page *page) {
  103efb:	55                   	push   %ebp
  103efc:	89 e5                	mov    %esp,%ebp
  103efe:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103f01:	8b 45 08             	mov    0x8(%ebp),%eax
  103f04:	89 04 24             	mov    %eax,(%esp)
  103f07:	e8 d5 ff ff ff       	call   103ee1 <page2ppn>
  103f0c:	c1 e0 0c             	shl    $0xc,%eax
}
  103f0f:	c9                   	leave  
  103f10:	c3                   	ret    

00103f11 <page_ref>:
page_ref(struct Page *page) {
  103f11:	55                   	push   %ebp
  103f12:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103f14:	8b 45 08             	mov    0x8(%ebp),%eax
  103f17:	8b 00                	mov    (%eax),%eax
}
  103f19:	5d                   	pop    %ebp
  103f1a:	c3                   	ret    

00103f1b <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  103f1b:	55                   	push   %ebp
  103f1c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  103f21:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f24:	89 10                	mov    %edx,(%eax)
}
  103f26:	5d                   	pop    %ebp
  103f27:	c3                   	ret    

00103f28 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  103f28:	55                   	push   %ebp
  103f29:	89 e5                	mov    %esp,%ebp
  103f2b:	83 ec 10             	sub    $0x10,%esp
  103f2e:	c7 45 fc 5c 89 11 00 	movl   $0x11895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103f3b:	89 50 04             	mov    %edx,0x4(%eax)
  103f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f41:	8b 50 04             	mov    0x4(%eax),%edx
  103f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f47:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  103f49:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  103f50:	00 00 00 
}
  103f53:	c9                   	leave  
  103f54:	c3                   	ret    

00103f55 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  103f55:	55                   	push   %ebp
  103f56:	89 e5                	mov    %esp,%ebp
  103f58:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  103f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103f5f:	75 24                	jne    103f85 <default_init_memmap+0x30>
  103f61:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  103f68:	00 
  103f69:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  103f70:	00 
  103f71:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  103f78:	00 
  103f79:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  103f80:	e8 5d c4 ff ff       	call   1003e2 <__panic>
    struct Page *p = base;
  103f85:	8b 45 08             	mov    0x8(%ebp),%eax
  103f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  103f8b:	eb 7d                	jmp    10400a <default_init_memmap+0xb5>
        assert(PageReserved(p));
  103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f90:	83 c0 04             	add    $0x4,%eax
  103f93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  103f9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103fa3:	0f a3 10             	bt     %edx,(%eax)
  103fa6:	19 c0                	sbb    %eax,%eax
  103fa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  103fab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103faf:	0f 95 c0             	setne  %al
  103fb2:	0f b6 c0             	movzbl %al,%eax
  103fb5:	85 c0                	test   %eax,%eax
  103fb7:	75 24                	jne    103fdd <default_init_memmap+0x88>
  103fb9:	c7 44 24 0c 21 69 10 	movl   $0x106921,0xc(%esp)
  103fc0:	00 
  103fc1:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  103fc8:	00 
  103fc9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  103fd0:	00 
  103fd1:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  103fd8:	e8 05 c4 ff ff       	call   1003e2 <__panic>
        p->flags = p->property = 0;
  103fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fe0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  103fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fea:	8b 50 08             	mov    0x8(%eax),%edx
  103fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ff0:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  103ff3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103ffa:	00 
  103ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ffe:	89 04 24             	mov    %eax,(%esp)
  104001:	e8 15 ff ff ff       	call   103f1b <set_page_ref>
    for (; p != base + n; p ++) {
  104006:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10400a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10400d:	89 d0                	mov    %edx,%eax
  10400f:	c1 e0 02             	shl    $0x2,%eax
  104012:	01 d0                	add    %edx,%eax
  104014:	c1 e0 02             	shl    $0x2,%eax
  104017:	89 c2                	mov    %eax,%edx
  104019:	8b 45 08             	mov    0x8(%ebp),%eax
  10401c:	01 d0                	add    %edx,%eax
  10401e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104021:	0f 85 66 ff ff ff    	jne    103f8d <default_init_memmap+0x38>
    }
    base->property = n;
  104027:	8b 45 08             	mov    0x8(%ebp),%eax
  10402a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10402d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104030:	8b 45 08             	mov    0x8(%ebp),%eax
  104033:	83 c0 04             	add    $0x4,%eax
  104036:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10403d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104040:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104043:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104046:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  104049:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10404f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104052:	01 d0                	add    %edx,%eax
  104054:	a3 64 89 11 00       	mov    %eax,0x118964
    list_add(&free_list, &(base->page_link));
  104059:	8b 45 08             	mov    0x8(%ebp),%eax
  10405c:	83 c0 0c             	add    $0xc,%eax
  10405f:	c7 45 dc 5c 89 11 00 	movl   $0x11895c,-0x24(%ebp)
  104066:	89 45 d8             	mov    %eax,-0x28(%ebp)
  104069:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10406c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10406f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104072:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104075:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104078:	8b 40 04             	mov    0x4(%eax),%eax
  10407b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10407e:	89 55 cc             	mov    %edx,-0x34(%ebp)
  104081:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104084:	89 55 c8             	mov    %edx,-0x38(%ebp)
  104087:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10408a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10408d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104090:	89 10                	mov    %edx,(%eax)
  104092:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104095:	8b 10                	mov    (%eax),%edx
  104097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10409a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10409d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1040a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1040a3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1040a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1040a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1040ac:	89 10                	mov    %edx,(%eax)
}
  1040ae:	c9                   	leave  
  1040af:	c3                   	ret    

001040b0 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1040b0:	55                   	push   %ebp
  1040b1:	89 e5                	mov    %esp,%ebp
  1040b3:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1040b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1040ba:	75 24                	jne    1040e0 <default_alloc_pages+0x30>
  1040bc:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  1040c3:	00 
  1040c4:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1040cb:	00 
  1040cc:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  1040d3:	00 
  1040d4:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1040db:	e8 02 c3 ff ff       	call   1003e2 <__panic>
    if (n > nr_free) {
  1040e0:	a1 64 89 11 00       	mov    0x118964,%eax
  1040e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  1040e8:	73 0a                	jae    1040f4 <default_alloc_pages+0x44>
        return NULL;
  1040ea:	b8 00 00 00 00       	mov    $0x0,%eax
  1040ef:	e9 2a 01 00 00       	jmp    10421e <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  1040f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1040fb:	c7 45 f0 5c 89 11 00 	movl   $0x11895c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104102:	eb 1c                	jmp    104120 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  104104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104107:	83 e8 0c             	sub    $0xc,%eax
  10410a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  10410d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104110:	8b 40 08             	mov    0x8(%eax),%eax
  104113:	3b 45 08             	cmp    0x8(%ebp),%eax
  104116:	72 08                	jb     104120 <default_alloc_pages+0x70>
            page = p;
  104118:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10411b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10411e:	eb 18                	jmp    104138 <default_alloc_pages+0x88>
  104120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104123:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104129:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10412c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10412f:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  104136:	75 cc                	jne    104104 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  104138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10413c:	0f 84 d9 00 00 00    	je     10421b <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  104142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104145:	83 c0 0c             	add    $0xc,%eax
  104148:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  10414b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10414e:	8b 40 04             	mov    0x4(%eax),%eax
  104151:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104154:	8b 12                	mov    (%edx),%edx
  104156:	89 55 dc             	mov    %edx,-0x24(%ebp)
  104159:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10415c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10415f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104162:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104165:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104168:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10416b:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  10416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104170:	8b 40 08             	mov    0x8(%eax),%eax
  104173:	3b 45 08             	cmp    0x8(%ebp),%eax
  104176:	76 7d                	jbe    1041f5 <default_alloc_pages+0x145>
            struct Page *p = page + n;
  104178:	8b 55 08             	mov    0x8(%ebp),%edx
  10417b:	89 d0                	mov    %edx,%eax
  10417d:	c1 e0 02             	shl    $0x2,%eax
  104180:	01 d0                	add    %edx,%eax
  104182:	c1 e0 02             	shl    $0x2,%eax
  104185:	89 c2                	mov    %eax,%edx
  104187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10418a:	01 d0                	add    %edx,%eax
  10418c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  10418f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104192:	8b 40 08             	mov    0x8(%eax),%eax
  104195:	2b 45 08             	sub    0x8(%ebp),%eax
  104198:	89 c2                	mov    %eax,%edx
  10419a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10419d:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  1041a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041a3:	83 c0 0c             	add    $0xc,%eax
  1041a6:	c7 45 d4 5c 89 11 00 	movl   $0x11895c,-0x2c(%ebp)
  1041ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  1041b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  1041bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1041bf:	8b 40 04             	mov    0x4(%eax),%eax
  1041c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1041c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1041c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1041cb:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1041ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  1041d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1041d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1041d7:	89 10                	mov    %edx,(%eax)
  1041d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1041dc:	8b 10                	mov    (%eax),%edx
  1041de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1041e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1041e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041e7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1041ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1041ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1041f3:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  1041f5:	a1 64 89 11 00       	mov    0x118964,%eax
  1041fa:	2b 45 08             	sub    0x8(%ebp),%eax
  1041fd:	a3 64 89 11 00       	mov    %eax,0x118964
        ClearPageProperty(page);
  104202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104205:	83 c0 04             	add    $0x4,%eax
  104208:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10420f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104212:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104215:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104218:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  10421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10421e:	c9                   	leave  
  10421f:	c3                   	ret    

00104220 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104220:	55                   	push   %ebp
  104221:	89 e5                	mov    %esp,%ebp
  104223:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104229:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10422d:	75 24                	jne    104253 <default_free_pages+0x33>
  10422f:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  104236:	00 
  104237:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10423e:	00 
  10423f:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  104246:	00 
  104247:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10424e:	e8 8f c1 ff ff       	call   1003e2 <__panic>
    struct Page *p = base;
  104253:	8b 45 08             	mov    0x8(%ebp),%eax
  104256:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104259:	e9 9d 00 00 00       	jmp    1042fb <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  10425e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104261:	83 c0 04             	add    $0x4,%eax
  104264:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  10426b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10426e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104271:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104274:	0f a3 10             	bt     %edx,(%eax)
  104277:	19 c0                	sbb    %eax,%eax
  104279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  10427c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104280:	0f 95 c0             	setne  %al
  104283:	0f b6 c0             	movzbl %al,%eax
  104286:	85 c0                	test   %eax,%eax
  104288:	75 2c                	jne    1042b6 <default_free_pages+0x96>
  10428a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10428d:	83 c0 04             	add    $0x4,%eax
  104290:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  104297:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10429a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10429d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042a0:	0f a3 10             	bt     %edx,(%eax)
  1042a3:	19 c0                	sbb    %eax,%eax
  1042a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1042a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1042ac:	0f 95 c0             	setne  %al
  1042af:	0f b6 c0             	movzbl %al,%eax
  1042b2:	85 c0                	test   %eax,%eax
  1042b4:	74 24                	je     1042da <default_free_pages+0xba>
  1042b6:	c7 44 24 0c 34 69 10 	movl   $0x106934,0xc(%esp)
  1042bd:	00 
  1042be:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1042c5:	00 
  1042c6:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  1042cd:	00 
  1042ce:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1042d5:	e8 08 c1 ff ff       	call   1003e2 <__panic>
        p->flags = 0;
  1042da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1042e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042eb:	00 
  1042ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ef:	89 04 24             	mov    %eax,(%esp)
  1042f2:	e8 24 fc ff ff       	call   103f1b <set_page_ref>
    for (; p != base + n; p ++) {
  1042f7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1042fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1042fe:	89 d0                	mov    %edx,%eax
  104300:	c1 e0 02             	shl    $0x2,%eax
  104303:	01 d0                	add    %edx,%eax
  104305:	c1 e0 02             	shl    $0x2,%eax
  104308:	89 c2                	mov    %eax,%edx
  10430a:	8b 45 08             	mov    0x8(%ebp),%eax
  10430d:	01 d0                	add    %edx,%eax
  10430f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104312:	0f 85 46 ff ff ff    	jne    10425e <default_free_pages+0x3e>
    }
    base->property = n;
  104318:	8b 45 08             	mov    0x8(%ebp),%eax
  10431b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10431e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104321:	8b 45 08             	mov    0x8(%ebp),%eax
  104324:	83 c0 04             	add    $0x4,%eax
  104327:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  10432e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104331:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104334:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104337:	0f ab 10             	bts    %edx,(%eax)
  10433a:	c7 45 cc 5c 89 11 00 	movl   $0x11895c,-0x34(%ebp)
    return listelm->next;
  104341:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104344:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104347:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  10434a:	e9 08 01 00 00       	jmp    104457 <default_free_pages+0x237>
        p = le2page(le, page_link);
  10434f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104352:	83 e8 0c             	sub    $0xc,%eax
  104355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10435b:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10435e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104361:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  104364:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  104367:	8b 45 08             	mov    0x8(%ebp),%eax
  10436a:	8b 50 08             	mov    0x8(%eax),%edx
  10436d:	89 d0                	mov    %edx,%eax
  10436f:	c1 e0 02             	shl    $0x2,%eax
  104372:	01 d0                	add    %edx,%eax
  104374:	c1 e0 02             	shl    $0x2,%eax
  104377:	89 c2                	mov    %eax,%edx
  104379:	8b 45 08             	mov    0x8(%ebp),%eax
  10437c:	01 d0                	add    %edx,%eax
  10437e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104381:	75 5a                	jne    1043dd <default_free_pages+0x1bd>
            base->property += p->property;
  104383:	8b 45 08             	mov    0x8(%ebp),%eax
  104386:	8b 50 08             	mov    0x8(%eax),%edx
  104389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10438c:	8b 40 08             	mov    0x8(%eax),%eax
  10438f:	01 c2                	add    %eax,%edx
  104391:	8b 45 08             	mov    0x8(%ebp),%eax
  104394:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  104397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439a:	83 c0 04             	add    $0x4,%eax
  10439d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  1043a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1043a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1043aa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1043ad:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  1043b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043b3:	83 c0 0c             	add    $0xc,%eax
  1043b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  1043b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1043bc:	8b 40 04             	mov    0x4(%eax),%eax
  1043bf:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1043c2:	8b 12                	mov    (%edx),%edx
  1043c4:	89 55 b8             	mov    %edx,-0x48(%ebp)
  1043c7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
  1043ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1043cd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1043d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1043d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1043d6:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1043d9:	89 10                	mov    %edx,(%eax)
  1043db:	eb 7a                	jmp    104457 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  1043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043e0:	8b 50 08             	mov    0x8(%eax),%edx
  1043e3:	89 d0                	mov    %edx,%eax
  1043e5:	c1 e0 02             	shl    $0x2,%eax
  1043e8:	01 d0                	add    %edx,%eax
  1043ea:	c1 e0 02             	shl    $0x2,%eax
  1043ed:	89 c2                	mov    %eax,%edx
  1043ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043f2:	01 d0                	add    %edx,%eax
  1043f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  1043f7:	75 5e                	jne    104457 <default_free_pages+0x237>
            p->property += base->property;
  1043f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043fc:	8b 50 08             	mov    0x8(%eax),%edx
  1043ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104402:	8b 40 08             	mov    0x8(%eax),%eax
  104405:	01 c2                	add    %eax,%edx
  104407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10440a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  10440d:	8b 45 08             	mov    0x8(%ebp),%eax
  104410:	83 c0 04             	add    $0x4,%eax
  104413:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  10441a:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10441d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104420:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104423:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104429:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10442c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10442f:	83 c0 0c             	add    $0xc,%eax
  104432:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
  104435:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104438:	8b 40 04             	mov    0x4(%eax),%eax
  10443b:	8b 55 a8             	mov    -0x58(%ebp),%edx
  10443e:	8b 12                	mov    (%edx),%edx
  104440:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  104443:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
  104446:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104449:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10444c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10444f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104452:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104455:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  104457:	81 7d f0 5c 89 11 00 	cmpl   $0x11895c,-0x10(%ebp)
  10445e:	0f 85 eb fe ff ff    	jne    10434f <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  104464:	8b 15 64 89 11 00    	mov    0x118964,%edx
  10446a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10446d:	01 d0                	add    %edx,%eax
  10446f:	a3 64 89 11 00       	mov    %eax,0x118964
    list_add(&free_list, &(base->page_link));
  104474:	8b 45 08             	mov    0x8(%ebp),%eax
  104477:	83 c0 0c             	add    $0xc,%eax
  10447a:	c7 45 9c 5c 89 11 00 	movl   $0x11895c,-0x64(%ebp)
  104481:	89 45 98             	mov    %eax,-0x68(%ebp)
  104484:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104487:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10448a:	8b 45 98             	mov    -0x68(%ebp),%eax
  10448d:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
  104490:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104493:	8b 40 04             	mov    0x4(%eax),%eax
  104496:	8b 55 90             	mov    -0x70(%ebp),%edx
  104499:	89 55 8c             	mov    %edx,-0x74(%ebp)
  10449c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10449f:	89 55 88             	mov    %edx,-0x78(%ebp)
  1044a2:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  1044a5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1044a8:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1044ab:	89 10                	mov    %edx,(%eax)
  1044ad:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1044b0:	8b 10                	mov    (%eax),%edx
  1044b2:	8b 45 88             	mov    -0x78(%ebp),%eax
  1044b5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1044b8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1044bb:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1044be:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1044c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1044c4:	8b 55 88             	mov    -0x78(%ebp),%edx
  1044c7:	89 10                	mov    %edx,(%eax)
}
  1044c9:	c9                   	leave  
  1044ca:	c3                   	ret    

001044cb <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1044cb:	55                   	push   %ebp
  1044cc:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1044ce:	a1 64 89 11 00       	mov    0x118964,%eax
}
  1044d3:	5d                   	pop    %ebp
  1044d4:	c3                   	ret    

001044d5 <basic_check>:

static void
basic_check(void) {
  1044d5:	55                   	push   %ebp
  1044d6:	89 e5                	mov    %esp,%ebp
  1044d8:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1044db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1044ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044f5:	e8 32 e4 ff ff       	call   10292c <alloc_pages>
  1044fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1044fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104501:	75 24                	jne    104527 <basic_check+0x52>
  104503:	c7 44 24 0c 59 69 10 	movl   $0x106959,0xc(%esp)
  10450a:	00 
  10450b:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104512:	00 
  104513:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  10451a:	00 
  10451b:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104522:	e8 bb be ff ff       	call   1003e2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104527:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10452e:	e8 f9 e3 ff ff       	call   10292c <alloc_pages>
  104533:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104536:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10453a:	75 24                	jne    104560 <basic_check+0x8b>
  10453c:	c7 44 24 0c 75 69 10 	movl   $0x106975,0xc(%esp)
  104543:	00 
  104544:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10454b:	00 
  10454c:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  104553:	00 
  104554:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10455b:	e8 82 be ff ff       	call   1003e2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104560:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104567:	e8 c0 e3 ff ff       	call   10292c <alloc_pages>
  10456c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10456f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104573:	75 24                	jne    104599 <basic_check+0xc4>
  104575:	c7 44 24 0c 91 69 10 	movl   $0x106991,0xc(%esp)
  10457c:	00 
  10457d:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104584:	00 
  104585:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  10458c:	00 
  10458d:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104594:	e8 49 be ff ff       	call   1003e2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10459c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10459f:	74 10                	je     1045b1 <basic_check+0xdc>
  1045a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1045a7:	74 08                	je     1045b1 <basic_check+0xdc>
  1045a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1045af:	75 24                	jne    1045d5 <basic_check+0x100>
  1045b1:	c7 44 24 0c b0 69 10 	movl   $0x1069b0,0xc(%esp)
  1045b8:	00 
  1045b9:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1045c0:	00 
  1045c1:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  1045c8:	00 
  1045c9:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1045d0:	e8 0d be ff ff       	call   1003e2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1045d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045d8:	89 04 24             	mov    %eax,(%esp)
  1045db:	e8 31 f9 ff ff       	call   103f11 <page_ref>
  1045e0:	85 c0                	test   %eax,%eax
  1045e2:	75 1e                	jne    104602 <basic_check+0x12d>
  1045e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045e7:	89 04 24             	mov    %eax,(%esp)
  1045ea:	e8 22 f9 ff ff       	call   103f11 <page_ref>
  1045ef:	85 c0                	test   %eax,%eax
  1045f1:	75 0f                	jne    104602 <basic_check+0x12d>
  1045f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f6:	89 04 24             	mov    %eax,(%esp)
  1045f9:	e8 13 f9 ff ff       	call   103f11 <page_ref>
  1045fe:	85 c0                	test   %eax,%eax
  104600:	74 24                	je     104626 <basic_check+0x151>
  104602:	c7 44 24 0c d4 69 10 	movl   $0x1069d4,0xc(%esp)
  104609:	00 
  10460a:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104611:	00 
  104612:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  104619:	00 
  10461a:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104621:	e8 bc bd ff ff       	call   1003e2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104626:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104629:	89 04 24             	mov    %eax,(%esp)
  10462c:	e8 ca f8 ff ff       	call   103efb <page2pa>
  104631:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104637:	c1 e2 0c             	shl    $0xc,%edx
  10463a:	39 d0                	cmp    %edx,%eax
  10463c:	72 24                	jb     104662 <basic_check+0x18d>
  10463e:	c7 44 24 0c 10 6a 10 	movl   $0x106a10,0xc(%esp)
  104645:	00 
  104646:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10464d:	00 
  10464e:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  104655:	00 
  104656:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10465d:	e8 80 bd ff ff       	call   1003e2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104665:	89 04 24             	mov    %eax,(%esp)
  104668:	e8 8e f8 ff ff       	call   103efb <page2pa>
  10466d:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  104673:	c1 e2 0c             	shl    $0xc,%edx
  104676:	39 d0                	cmp    %edx,%eax
  104678:	72 24                	jb     10469e <basic_check+0x1c9>
  10467a:	c7 44 24 0c 2d 6a 10 	movl   $0x106a2d,0xc(%esp)
  104681:	00 
  104682:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104689:	00 
  10468a:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  104691:	00 
  104692:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104699:	e8 44 bd ff ff       	call   1003e2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a1:	89 04 24             	mov    %eax,(%esp)
  1046a4:	e8 52 f8 ff ff       	call   103efb <page2pa>
  1046a9:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  1046af:	c1 e2 0c             	shl    $0xc,%edx
  1046b2:	39 d0                	cmp    %edx,%eax
  1046b4:	72 24                	jb     1046da <basic_check+0x205>
  1046b6:	c7 44 24 0c 4a 6a 10 	movl   $0x106a4a,0xc(%esp)
  1046bd:	00 
  1046be:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1046c5:	00 
  1046c6:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  1046cd:	00 
  1046ce:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1046d5:	e8 08 bd ff ff       	call   1003e2 <__panic>

    list_entry_t free_list_store = free_list;
  1046da:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1046df:	8b 15 60 89 11 00    	mov    0x118960,%edx
  1046e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1046e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1046eb:	c7 45 e0 5c 89 11 00 	movl   $0x11895c,-0x20(%ebp)
    elm->prev = elm->next = elm;
  1046f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1046f8:	89 50 04             	mov    %edx,0x4(%eax)
  1046fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1046fe:	8b 50 04             	mov    0x4(%eax),%edx
  104701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104704:	89 10                	mov    %edx,(%eax)
  104706:	c7 45 dc 5c 89 11 00 	movl   $0x11895c,-0x24(%ebp)
    return list->next == list;
  10470d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104710:	8b 40 04             	mov    0x4(%eax),%eax
  104713:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104716:	0f 94 c0             	sete   %al
  104719:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10471c:	85 c0                	test   %eax,%eax
  10471e:	75 24                	jne    104744 <basic_check+0x26f>
  104720:	c7 44 24 0c 67 6a 10 	movl   $0x106a67,0xc(%esp)
  104727:	00 
  104728:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10472f:	00 
  104730:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  104737:	00 
  104738:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10473f:	e8 9e bc ff ff       	call   1003e2 <__panic>

    unsigned int nr_free_store = nr_free;
  104744:	a1 64 89 11 00       	mov    0x118964,%eax
  104749:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10474c:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104753:	00 00 00 

    assert(alloc_page() == NULL);
  104756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10475d:	e8 ca e1 ff ff       	call   10292c <alloc_pages>
  104762:	85 c0                	test   %eax,%eax
  104764:	74 24                	je     10478a <basic_check+0x2b5>
  104766:	c7 44 24 0c 7e 6a 10 	movl   $0x106a7e,0xc(%esp)
  10476d:	00 
  10476e:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104775:	00 
  104776:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  10477d:	00 
  10477e:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104785:	e8 58 bc ff ff       	call   1003e2 <__panic>

    free_page(p0);
  10478a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104791:	00 
  104792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104795:	89 04 24             	mov    %eax,(%esp)
  104798:	e8 c7 e1 ff ff       	call   102964 <free_pages>
    free_page(p1);
  10479d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1047a4:	00 
  1047a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047a8:	89 04 24             	mov    %eax,(%esp)
  1047ab:	e8 b4 e1 ff ff       	call   102964 <free_pages>
    free_page(p2);
  1047b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1047b7:	00 
  1047b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047bb:	89 04 24             	mov    %eax,(%esp)
  1047be:	e8 a1 e1 ff ff       	call   102964 <free_pages>
    assert(nr_free == 3);
  1047c3:	a1 64 89 11 00       	mov    0x118964,%eax
  1047c8:	83 f8 03             	cmp    $0x3,%eax
  1047cb:	74 24                	je     1047f1 <basic_check+0x31c>
  1047cd:	c7 44 24 0c 93 6a 10 	movl   $0x106a93,0xc(%esp)
  1047d4:	00 
  1047d5:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1047dc:	00 
  1047dd:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  1047e4:	00 
  1047e5:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1047ec:	e8 f1 bb ff ff       	call   1003e2 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1047f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1047f8:	e8 2f e1 ff ff       	call   10292c <alloc_pages>
  1047fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104800:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104804:	75 24                	jne    10482a <basic_check+0x355>
  104806:	c7 44 24 0c 59 69 10 	movl   $0x106959,0xc(%esp)
  10480d:	00 
  10480e:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104815:	00 
  104816:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  10481d:	00 
  10481e:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104825:	e8 b8 bb ff ff       	call   1003e2 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10482a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104831:	e8 f6 e0 ff ff       	call   10292c <alloc_pages>
  104836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10483d:	75 24                	jne    104863 <basic_check+0x38e>
  10483f:	c7 44 24 0c 75 69 10 	movl   $0x106975,0xc(%esp)
  104846:	00 
  104847:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10484e:	00 
  10484f:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  104856:	00 
  104857:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10485e:	e8 7f bb ff ff       	call   1003e2 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104863:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10486a:	e8 bd e0 ff ff       	call   10292c <alloc_pages>
  10486f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104876:	75 24                	jne    10489c <basic_check+0x3c7>
  104878:	c7 44 24 0c 91 69 10 	movl   $0x106991,0xc(%esp)
  10487f:	00 
  104880:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104887:	00 
  104888:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  10488f:	00 
  104890:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104897:	e8 46 bb ff ff       	call   1003e2 <__panic>

    assert(alloc_page() == NULL);
  10489c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048a3:	e8 84 e0 ff ff       	call   10292c <alloc_pages>
  1048a8:	85 c0                	test   %eax,%eax
  1048aa:	74 24                	je     1048d0 <basic_check+0x3fb>
  1048ac:	c7 44 24 0c 7e 6a 10 	movl   $0x106a7e,0xc(%esp)
  1048b3:	00 
  1048b4:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1048bb:	00 
  1048bc:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  1048c3:	00 
  1048c4:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1048cb:	e8 12 bb ff ff       	call   1003e2 <__panic>

    free_page(p0);
  1048d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1048d7:	00 
  1048d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048db:	89 04 24             	mov    %eax,(%esp)
  1048de:	e8 81 e0 ff ff       	call   102964 <free_pages>
  1048e3:	c7 45 d8 5c 89 11 00 	movl   $0x11895c,-0x28(%ebp)
  1048ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1048ed:	8b 40 04             	mov    0x4(%eax),%eax
  1048f0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1048f3:	0f 94 c0             	sete   %al
  1048f6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1048f9:	85 c0                	test   %eax,%eax
  1048fb:	74 24                	je     104921 <basic_check+0x44c>
  1048fd:	c7 44 24 0c a0 6a 10 	movl   $0x106aa0,0xc(%esp)
  104904:	00 
  104905:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10490c:	00 
  10490d:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  104914:	00 
  104915:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10491c:	e8 c1 ba ff ff       	call   1003e2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104921:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104928:	e8 ff df ff ff       	call   10292c <alloc_pages>
  10492d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104933:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104936:	74 24                	je     10495c <basic_check+0x487>
  104938:	c7 44 24 0c b8 6a 10 	movl   $0x106ab8,0xc(%esp)
  10493f:	00 
  104940:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104947:	00 
  104948:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  10494f:	00 
  104950:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104957:	e8 86 ba ff ff       	call   1003e2 <__panic>
    assert(alloc_page() == NULL);
  10495c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104963:	e8 c4 df ff ff       	call   10292c <alloc_pages>
  104968:	85 c0                	test   %eax,%eax
  10496a:	74 24                	je     104990 <basic_check+0x4bb>
  10496c:	c7 44 24 0c 7e 6a 10 	movl   $0x106a7e,0xc(%esp)
  104973:	00 
  104974:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10497b:	00 
  10497c:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  104983:	00 
  104984:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10498b:	e8 52 ba ff ff       	call   1003e2 <__panic>

    assert(nr_free == 0);
  104990:	a1 64 89 11 00       	mov    0x118964,%eax
  104995:	85 c0                	test   %eax,%eax
  104997:	74 24                	je     1049bd <basic_check+0x4e8>
  104999:	c7 44 24 0c d1 6a 10 	movl   $0x106ad1,0xc(%esp)
  1049a0:	00 
  1049a1:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  1049a8:	00 
  1049a9:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  1049b0:	00 
  1049b1:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  1049b8:	e8 25 ba ff ff       	call   1003e2 <__panic>
    free_list = free_list_store;
  1049bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1049c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1049c3:	a3 5c 89 11 00       	mov    %eax,0x11895c
  1049c8:	89 15 60 89 11 00    	mov    %edx,0x118960
    nr_free = nr_free_store;
  1049ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1049d1:	a3 64 89 11 00       	mov    %eax,0x118964

    free_page(p);
  1049d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1049dd:	00 
  1049de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049e1:	89 04 24             	mov    %eax,(%esp)
  1049e4:	e8 7b df ff ff       	call   102964 <free_pages>
    free_page(p1);
  1049e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1049f0:	00 
  1049f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049f4:	89 04 24             	mov    %eax,(%esp)
  1049f7:	e8 68 df ff ff       	call   102964 <free_pages>
    free_page(p2);
  1049fc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a03:	00 
  104a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a07:	89 04 24             	mov    %eax,(%esp)
  104a0a:	e8 55 df ff ff       	call   102964 <free_pages>
}
  104a0f:	c9                   	leave  
  104a10:	c3                   	ret    

00104a11 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104a11:	55                   	push   %ebp
  104a12:	89 e5                	mov    %esp,%ebp
  104a14:	53                   	push   %ebx
  104a15:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  104a1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104a29:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104a30:	eb 6b                	jmp    104a9d <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  104a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a35:	83 e8 0c             	sub    $0xc,%eax
  104a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  104a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a3e:	83 c0 04             	add    $0x4,%eax
  104a41:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104a48:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104a4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104a51:	0f a3 10             	bt     %edx,(%eax)
  104a54:	19 c0                	sbb    %eax,%eax
  104a56:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104a59:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104a5d:	0f 95 c0             	setne  %al
  104a60:	0f b6 c0             	movzbl %al,%eax
  104a63:	85 c0                	test   %eax,%eax
  104a65:	75 24                	jne    104a8b <default_check+0x7a>
  104a67:	c7 44 24 0c de 6a 10 	movl   $0x106ade,0xc(%esp)
  104a6e:	00 
  104a6f:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104a76:	00 
  104a77:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  104a7e:	00 
  104a7f:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104a86:	e8 57 b9 ff ff       	call   1003e2 <__panic>
        count ++, total += p->property;
  104a8b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104a92:	8b 50 08             	mov    0x8(%eax),%edx
  104a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a98:	01 d0                	add    %edx,%eax
  104a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104aa0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104aa3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104aa6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104aa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104aac:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  104ab3:	0f 85 79 ff ff ff    	jne    104a32 <default_check+0x21>
    }
    assert(total == nr_free_pages());
  104ab9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  104abc:	e8 d5 de ff ff       	call   102996 <nr_free_pages>
  104ac1:	39 c3                	cmp    %eax,%ebx
  104ac3:	74 24                	je     104ae9 <default_check+0xd8>
  104ac5:	c7 44 24 0c ee 6a 10 	movl   $0x106aee,0xc(%esp)
  104acc:	00 
  104acd:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104ad4:	00 
  104ad5:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104adc:	00 
  104add:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104ae4:	e8 f9 b8 ff ff       	call   1003e2 <__panic>

    basic_check();
  104ae9:	e8 e7 f9 ff ff       	call   1044d5 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104aee:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104af5:	e8 32 de ff ff       	call   10292c <alloc_pages>
  104afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  104afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104b01:	75 24                	jne    104b27 <default_check+0x116>
  104b03:	c7 44 24 0c 07 6b 10 	movl   $0x106b07,0xc(%esp)
  104b0a:	00 
  104b0b:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104b12:	00 
  104b13:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  104b1a:	00 
  104b1b:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104b22:	e8 bb b8 ff ff       	call   1003e2 <__panic>
    assert(!PageProperty(p0));
  104b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b2a:	83 c0 04             	add    $0x4,%eax
  104b2d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104b34:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b37:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104b3a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104b3d:	0f a3 10             	bt     %edx,(%eax)
  104b40:	19 c0                	sbb    %eax,%eax
  104b42:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104b45:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104b49:	0f 95 c0             	setne  %al
  104b4c:	0f b6 c0             	movzbl %al,%eax
  104b4f:	85 c0                	test   %eax,%eax
  104b51:	74 24                	je     104b77 <default_check+0x166>
  104b53:	c7 44 24 0c 12 6b 10 	movl   $0x106b12,0xc(%esp)
  104b5a:	00 
  104b5b:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104b62:	00 
  104b63:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104b6a:	00 
  104b6b:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104b72:	e8 6b b8 ff ff       	call   1003e2 <__panic>

    list_entry_t free_list_store = free_list;
  104b77:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104b7c:	8b 15 60 89 11 00    	mov    0x118960,%edx
  104b82:	89 45 80             	mov    %eax,-0x80(%ebp)
  104b85:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104b88:	c7 45 b4 5c 89 11 00 	movl   $0x11895c,-0x4c(%ebp)
    elm->prev = elm->next = elm;
  104b8f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104b92:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104b95:	89 50 04             	mov    %edx,0x4(%eax)
  104b98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104b9b:	8b 50 04             	mov    0x4(%eax),%edx
  104b9e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104ba1:	89 10                	mov    %edx,(%eax)
  104ba3:	c7 45 b0 5c 89 11 00 	movl   $0x11895c,-0x50(%ebp)
    return list->next == list;
  104baa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104bad:	8b 40 04             	mov    0x4(%eax),%eax
  104bb0:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  104bb3:	0f 94 c0             	sete   %al
  104bb6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104bb9:	85 c0                	test   %eax,%eax
  104bbb:	75 24                	jne    104be1 <default_check+0x1d0>
  104bbd:	c7 44 24 0c 67 6a 10 	movl   $0x106a67,0xc(%esp)
  104bc4:	00 
  104bc5:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104bcc:	00 
  104bcd:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104bd4:	00 
  104bd5:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104bdc:	e8 01 b8 ff ff       	call   1003e2 <__panic>
    assert(alloc_page() == NULL);
  104be1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104be8:	e8 3f dd ff ff       	call   10292c <alloc_pages>
  104bed:	85 c0                	test   %eax,%eax
  104bef:	74 24                	je     104c15 <default_check+0x204>
  104bf1:	c7 44 24 0c 7e 6a 10 	movl   $0x106a7e,0xc(%esp)
  104bf8:	00 
  104bf9:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104c00:	00 
  104c01:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104c08:	00 
  104c09:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104c10:	e8 cd b7 ff ff       	call   1003e2 <__panic>

    unsigned int nr_free_store = nr_free;
  104c15:	a1 64 89 11 00       	mov    0x118964,%eax
  104c1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  104c1d:	c7 05 64 89 11 00 00 	movl   $0x0,0x118964
  104c24:	00 00 00 

    free_pages(p0 + 2, 3);
  104c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c2a:	83 c0 28             	add    $0x28,%eax
  104c2d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104c34:	00 
  104c35:	89 04 24             	mov    %eax,(%esp)
  104c38:	e8 27 dd ff ff       	call   102964 <free_pages>
    assert(alloc_pages(4) == NULL);
  104c3d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104c44:	e8 e3 dc ff ff       	call   10292c <alloc_pages>
  104c49:	85 c0                	test   %eax,%eax
  104c4b:	74 24                	je     104c71 <default_check+0x260>
  104c4d:	c7 44 24 0c 24 6b 10 	movl   $0x106b24,0xc(%esp)
  104c54:	00 
  104c55:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104c5c:	00 
  104c5d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104c64:	00 
  104c65:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104c6c:	e8 71 b7 ff ff       	call   1003e2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c74:	83 c0 28             	add    $0x28,%eax
  104c77:	83 c0 04             	add    $0x4,%eax
  104c7a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104c81:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104c84:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104c87:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104c8a:	0f a3 10             	bt     %edx,(%eax)
  104c8d:	19 c0                	sbb    %eax,%eax
  104c8f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104c92:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104c96:	0f 95 c0             	setne  %al
  104c99:	0f b6 c0             	movzbl %al,%eax
  104c9c:	85 c0                	test   %eax,%eax
  104c9e:	74 0e                	je     104cae <default_check+0x29d>
  104ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ca3:	83 c0 28             	add    $0x28,%eax
  104ca6:	8b 40 08             	mov    0x8(%eax),%eax
  104ca9:	83 f8 03             	cmp    $0x3,%eax
  104cac:	74 24                	je     104cd2 <default_check+0x2c1>
  104cae:	c7 44 24 0c 3c 6b 10 	movl   $0x106b3c,0xc(%esp)
  104cb5:	00 
  104cb6:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104cbd:	00 
  104cbe:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104cc5:	00 
  104cc6:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104ccd:	e8 10 b7 ff ff       	call   1003e2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104cd2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  104cd9:	e8 4e dc ff ff       	call   10292c <alloc_pages>
  104cde:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104ce1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104ce5:	75 24                	jne    104d0b <default_check+0x2fa>
  104ce7:	c7 44 24 0c 68 6b 10 	movl   $0x106b68,0xc(%esp)
  104cee:	00 
  104cef:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104cf6:	00 
  104cf7:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104cfe:	00 
  104cff:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104d06:	e8 d7 b6 ff ff       	call   1003e2 <__panic>
    assert(alloc_page() == NULL);
  104d0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d12:	e8 15 dc ff ff       	call   10292c <alloc_pages>
  104d17:	85 c0                	test   %eax,%eax
  104d19:	74 24                	je     104d3f <default_check+0x32e>
  104d1b:	c7 44 24 0c 7e 6a 10 	movl   $0x106a7e,0xc(%esp)
  104d22:	00 
  104d23:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104d2a:	00 
  104d2b:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  104d32:	00 
  104d33:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104d3a:	e8 a3 b6 ff ff       	call   1003e2 <__panic>
    assert(p0 + 2 == p1);
  104d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d42:	83 c0 28             	add    $0x28,%eax
  104d45:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104d48:	74 24                	je     104d6e <default_check+0x35d>
  104d4a:	c7 44 24 0c 86 6b 10 	movl   $0x106b86,0xc(%esp)
  104d51:	00 
  104d52:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104d59:	00 
  104d5a:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  104d61:	00 
  104d62:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104d69:	e8 74 b6 ff ff       	call   1003e2 <__panic>

    p2 = p0 + 1;
  104d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d71:	83 c0 14             	add    $0x14,%eax
  104d74:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  104d77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d7e:	00 
  104d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d82:	89 04 24             	mov    %eax,(%esp)
  104d85:	e8 da db ff ff       	call   102964 <free_pages>
    free_pages(p1, 3);
  104d8a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104d91:	00 
  104d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d95:	89 04 24             	mov    %eax,(%esp)
  104d98:	e8 c7 db ff ff       	call   102964 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  104d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104da0:	83 c0 04             	add    $0x4,%eax
  104da3:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  104daa:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104dad:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104db0:	8b 55 a0             	mov    -0x60(%ebp),%edx
  104db3:	0f a3 10             	bt     %edx,(%eax)
  104db6:	19 c0                	sbb    %eax,%eax
  104db8:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104dbb:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104dbf:	0f 95 c0             	setne  %al
  104dc2:	0f b6 c0             	movzbl %al,%eax
  104dc5:	85 c0                	test   %eax,%eax
  104dc7:	74 0b                	je     104dd4 <default_check+0x3c3>
  104dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dcc:	8b 40 08             	mov    0x8(%eax),%eax
  104dcf:	83 f8 01             	cmp    $0x1,%eax
  104dd2:	74 24                	je     104df8 <default_check+0x3e7>
  104dd4:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  104ddb:	00 
  104ddc:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104de3:	00 
  104de4:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104deb:	00 
  104dec:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104df3:	e8 ea b5 ff ff       	call   1003e2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104df8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104dfb:	83 c0 04             	add    $0x4,%eax
  104dfe:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  104e05:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e08:	8b 45 90             	mov    -0x70(%ebp),%eax
  104e0b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  104e0e:	0f a3 10             	bt     %edx,(%eax)
  104e11:	19 c0                	sbb    %eax,%eax
  104e13:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  104e16:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  104e1a:	0f 95 c0             	setne  %al
  104e1d:	0f b6 c0             	movzbl %al,%eax
  104e20:	85 c0                	test   %eax,%eax
  104e22:	74 0b                	je     104e2f <default_check+0x41e>
  104e24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e27:	8b 40 08             	mov    0x8(%eax),%eax
  104e2a:	83 f8 03             	cmp    $0x3,%eax
  104e2d:	74 24                	je     104e53 <default_check+0x442>
  104e2f:	c7 44 24 0c bc 6b 10 	movl   $0x106bbc,0xc(%esp)
  104e36:	00 
  104e37:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104e3e:	00 
  104e3f:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  104e46:	00 
  104e47:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104e4e:	e8 8f b5 ff ff       	call   1003e2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104e53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e5a:	e8 cd da ff ff       	call   10292c <alloc_pages>
  104e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104e65:	83 e8 14             	sub    $0x14,%eax
  104e68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104e6b:	74 24                	je     104e91 <default_check+0x480>
  104e6d:	c7 44 24 0c e2 6b 10 	movl   $0x106be2,0xc(%esp)
  104e74:	00 
  104e75:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104e7c:	00 
  104e7d:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104e84:	00 
  104e85:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104e8c:	e8 51 b5 ff ff       	call   1003e2 <__panic>
    free_page(p0);
  104e91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e98:	00 
  104e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e9c:	89 04 24             	mov    %eax,(%esp)
  104e9f:	e8 c0 da ff ff       	call   102964 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104ea4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104eab:	e8 7c da ff ff       	call   10292c <alloc_pages>
  104eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104eb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104eb6:	83 c0 14             	add    $0x14,%eax
  104eb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104ebc:	74 24                	je     104ee2 <default_check+0x4d1>
  104ebe:	c7 44 24 0c 00 6c 10 	movl   $0x106c00,0xc(%esp)
  104ec5:	00 
  104ec6:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104ecd:	00 
  104ece:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  104ed5:	00 
  104ed6:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104edd:	e8 00 b5 ff ff       	call   1003e2 <__panic>

    free_pages(p0, 2);
  104ee2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  104ee9:	00 
  104eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104eed:	89 04 24             	mov    %eax,(%esp)
  104ef0:	e8 6f da ff ff       	call   102964 <free_pages>
    free_page(p2);
  104ef5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104efc:	00 
  104efd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104f00:	89 04 24             	mov    %eax,(%esp)
  104f03:	e8 5c da ff ff       	call   102964 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  104f08:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104f0f:	e8 18 da ff ff       	call   10292c <alloc_pages>
  104f14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104f1b:	75 24                	jne    104f41 <default_check+0x530>
  104f1d:	c7 44 24 0c 20 6c 10 	movl   $0x106c20,0xc(%esp)
  104f24:	00 
  104f25:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104f2c:	00 
  104f2d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  104f34:	00 
  104f35:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104f3c:	e8 a1 b4 ff ff       	call   1003e2 <__panic>
    assert(alloc_page() == NULL);
  104f41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f48:	e8 df d9 ff ff       	call   10292c <alloc_pages>
  104f4d:	85 c0                	test   %eax,%eax
  104f4f:	74 24                	je     104f75 <default_check+0x564>
  104f51:	c7 44 24 0c 7e 6a 10 	movl   $0x106a7e,0xc(%esp)
  104f58:	00 
  104f59:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104f60:	00 
  104f61:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  104f68:	00 
  104f69:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104f70:	e8 6d b4 ff ff       	call   1003e2 <__panic>

    assert(nr_free == 0);
  104f75:	a1 64 89 11 00       	mov    0x118964,%eax
  104f7a:	85 c0                	test   %eax,%eax
  104f7c:	74 24                	je     104fa2 <default_check+0x591>
  104f7e:	c7 44 24 0c d1 6a 10 	movl   $0x106ad1,0xc(%esp)
  104f85:	00 
  104f86:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  104f8d:	00 
  104f8e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  104f95:	00 
  104f96:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  104f9d:	e8 40 b4 ff ff       	call   1003e2 <__panic>
    nr_free = nr_free_store;
  104fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fa5:	a3 64 89 11 00       	mov    %eax,0x118964

    free_list = free_list_store;
  104faa:	8b 45 80             	mov    -0x80(%ebp),%eax
  104fad:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104fb0:	a3 5c 89 11 00       	mov    %eax,0x11895c
  104fb5:	89 15 60 89 11 00    	mov    %edx,0x118960
    free_pages(p0, 5);
  104fbb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  104fc2:	00 
  104fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fc6:	89 04 24             	mov    %eax,(%esp)
  104fc9:	e8 96 d9 ff ff       	call   102964 <free_pages>

    le = &free_list;
  104fce:	c7 45 ec 5c 89 11 00 	movl   $0x11895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104fd5:	eb 1d                	jmp    104ff4 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  104fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fda:	83 e8 0c             	sub    $0xc,%eax
  104fdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  104fe0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104fe7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fea:	8b 40 08             	mov    0x8(%eax),%eax
  104fed:	29 c2                	sub    %eax,%edx
  104fef:	89 d0                	mov    %edx,%eax
  104ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ff7:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  104ffa:	8b 45 88             	mov    -0x78(%ebp),%eax
  104ffd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105000:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105003:	81 7d ec 5c 89 11 00 	cmpl   $0x11895c,-0x14(%ebp)
  10500a:	75 cb                	jne    104fd7 <default_check+0x5c6>
    }
    assert(count == 0);
  10500c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105010:	74 24                	je     105036 <default_check+0x625>
  105012:	c7 44 24 0c 3e 6c 10 	movl   $0x106c3e,0xc(%esp)
  105019:	00 
  10501a:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  105021:	00 
  105022:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  105029:	00 
  10502a:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  105031:	e8 ac b3 ff ff       	call   1003e2 <__panic>
    assert(total == 0);
  105036:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10503a:	74 24                	je     105060 <default_check+0x64f>
  10503c:	c7 44 24 0c 49 6c 10 	movl   $0x106c49,0xc(%esp)
  105043:	00 
  105044:	c7 44 24 08 f6 68 10 	movl   $0x1068f6,0x8(%esp)
  10504b:	00 
  10504c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  105053:	00 
  105054:	c7 04 24 0b 69 10 00 	movl   $0x10690b,(%esp)
  10505b:	e8 82 b3 ff ff       	call   1003e2 <__panic>
}
  105060:	81 c4 94 00 00 00    	add    $0x94,%esp
  105066:	5b                   	pop    %ebx
  105067:	5d                   	pop    %ebp
  105068:	c3                   	ret    

00105069 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105069:	55                   	push   %ebp
  10506a:	89 e5                	mov    %esp,%ebp
  10506c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10506f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105076:	eb 04                	jmp    10507c <strlen+0x13>
        cnt ++;
  105078:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  10507c:	8b 45 08             	mov    0x8(%ebp),%eax
  10507f:	8d 50 01             	lea    0x1(%eax),%edx
  105082:	89 55 08             	mov    %edx,0x8(%ebp)
  105085:	0f b6 00             	movzbl (%eax),%eax
  105088:	84 c0                	test   %al,%al
  10508a:	75 ec                	jne    105078 <strlen+0xf>
    }
    return cnt;
  10508c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10508f:	c9                   	leave  
  105090:	c3                   	ret    

00105091 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105091:	55                   	push   %ebp
  105092:	89 e5                	mov    %esp,%ebp
  105094:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10509e:	eb 04                	jmp    1050a4 <strnlen+0x13>
        cnt ++;
  1050a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1050a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050aa:	73 10                	jae    1050bc <strnlen+0x2b>
  1050ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1050af:	8d 50 01             	lea    0x1(%eax),%edx
  1050b2:	89 55 08             	mov    %edx,0x8(%ebp)
  1050b5:	0f b6 00             	movzbl (%eax),%eax
  1050b8:	84 c0                	test   %al,%al
  1050ba:	75 e4                	jne    1050a0 <strnlen+0xf>
    }
    return cnt;
  1050bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1050bf:	c9                   	leave  
  1050c0:	c3                   	ret    

001050c1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1050c1:	55                   	push   %ebp
  1050c2:	89 e5                	mov    %esp,%ebp
  1050c4:	57                   	push   %edi
  1050c5:	56                   	push   %esi
  1050c6:	83 ec 20             	sub    $0x20,%esp
  1050c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1050cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1050cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1050d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1050d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1050d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050db:	89 d1                	mov    %edx,%ecx
  1050dd:	89 c2                	mov    %eax,%edx
  1050df:	89 ce                	mov    %ecx,%esi
  1050e1:	89 d7                	mov    %edx,%edi
  1050e3:	ac                   	lods   %ds:(%esi),%al
  1050e4:	aa                   	stos   %al,%es:(%edi)
  1050e5:	84 c0                	test   %al,%al
  1050e7:	75 fa                	jne    1050e3 <strcpy+0x22>
  1050e9:	89 fa                	mov    %edi,%edx
  1050eb:	89 f1                	mov    %esi,%ecx
  1050ed:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1050f0:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1050f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1050f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1050f9:	83 c4 20             	add    $0x20,%esp
  1050fc:	5e                   	pop    %esi
  1050fd:	5f                   	pop    %edi
  1050fe:	5d                   	pop    %ebp
  1050ff:	c3                   	ret    

00105100 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105100:	55                   	push   %ebp
  105101:	89 e5                	mov    %esp,%ebp
  105103:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105106:	8b 45 08             	mov    0x8(%ebp),%eax
  105109:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10510c:	eb 21                	jmp    10512f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10510e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105111:	0f b6 10             	movzbl (%eax),%edx
  105114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105117:	88 10                	mov    %dl,(%eax)
  105119:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10511c:	0f b6 00             	movzbl (%eax),%eax
  10511f:	84 c0                	test   %al,%al
  105121:	74 04                	je     105127 <strncpy+0x27>
            src ++;
  105123:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105127:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10512b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  10512f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105133:	75 d9                	jne    10510e <strncpy+0xe>
    }
    return dst;
  105135:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105138:	c9                   	leave  
  105139:	c3                   	ret    

0010513a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10513a:	55                   	push   %ebp
  10513b:	89 e5                	mov    %esp,%ebp
  10513d:	57                   	push   %edi
  10513e:	56                   	push   %esi
  10513f:	83 ec 20             	sub    $0x20,%esp
  105142:	8b 45 08             	mov    0x8(%ebp),%eax
  105145:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105148:	8b 45 0c             	mov    0xc(%ebp),%eax
  10514b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10514e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105154:	89 d1                	mov    %edx,%ecx
  105156:	89 c2                	mov    %eax,%edx
  105158:	89 ce                	mov    %ecx,%esi
  10515a:	89 d7                	mov    %edx,%edi
  10515c:	ac                   	lods   %ds:(%esi),%al
  10515d:	ae                   	scas   %es:(%edi),%al
  10515e:	75 08                	jne    105168 <strcmp+0x2e>
  105160:	84 c0                	test   %al,%al
  105162:	75 f8                	jne    10515c <strcmp+0x22>
  105164:	31 c0                	xor    %eax,%eax
  105166:	eb 04                	jmp    10516c <strcmp+0x32>
  105168:	19 c0                	sbb    %eax,%eax
  10516a:	0c 01                	or     $0x1,%al
  10516c:	89 fa                	mov    %edi,%edx
  10516e:	89 f1                	mov    %esi,%ecx
  105170:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105173:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105176:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105179:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10517c:	83 c4 20             	add    $0x20,%esp
  10517f:	5e                   	pop    %esi
  105180:	5f                   	pop    %edi
  105181:	5d                   	pop    %ebp
  105182:	c3                   	ret    

00105183 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105183:	55                   	push   %ebp
  105184:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105186:	eb 0c                	jmp    105194 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105188:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10518c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105190:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105194:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105198:	74 1a                	je     1051b4 <strncmp+0x31>
  10519a:	8b 45 08             	mov    0x8(%ebp),%eax
  10519d:	0f b6 00             	movzbl (%eax),%eax
  1051a0:	84 c0                	test   %al,%al
  1051a2:	74 10                	je     1051b4 <strncmp+0x31>
  1051a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a7:	0f b6 10             	movzbl (%eax),%edx
  1051aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051ad:	0f b6 00             	movzbl (%eax),%eax
  1051b0:	38 c2                	cmp    %al,%dl
  1051b2:	74 d4                	je     105188 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1051b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051b8:	74 18                	je     1051d2 <strncmp+0x4f>
  1051ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1051bd:	0f b6 00             	movzbl (%eax),%eax
  1051c0:	0f b6 d0             	movzbl %al,%edx
  1051c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051c6:	0f b6 00             	movzbl (%eax),%eax
  1051c9:	0f b6 c0             	movzbl %al,%eax
  1051cc:	29 c2                	sub    %eax,%edx
  1051ce:	89 d0                	mov    %edx,%eax
  1051d0:	eb 05                	jmp    1051d7 <strncmp+0x54>
  1051d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1051d7:	5d                   	pop    %ebp
  1051d8:	c3                   	ret    

001051d9 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1051d9:	55                   	push   %ebp
  1051da:	89 e5                	mov    %esp,%ebp
  1051dc:	83 ec 04             	sub    $0x4,%esp
  1051df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051e2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1051e5:	eb 14                	jmp    1051fb <strchr+0x22>
        if (*s == c) {
  1051e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1051ea:	0f b6 00             	movzbl (%eax),%eax
  1051ed:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1051f0:	75 05                	jne    1051f7 <strchr+0x1e>
            return (char *)s;
  1051f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f5:	eb 13                	jmp    10520a <strchr+0x31>
        }
        s ++;
  1051f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  1051fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1051fe:	0f b6 00             	movzbl (%eax),%eax
  105201:	84 c0                	test   %al,%al
  105203:	75 e2                	jne    1051e7 <strchr+0xe>
    }
    return NULL;
  105205:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10520a:	c9                   	leave  
  10520b:	c3                   	ret    

0010520c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10520c:	55                   	push   %ebp
  10520d:	89 e5                	mov    %esp,%ebp
  10520f:	83 ec 04             	sub    $0x4,%esp
  105212:	8b 45 0c             	mov    0xc(%ebp),%eax
  105215:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105218:	eb 11                	jmp    10522b <strfind+0x1f>
        if (*s == c) {
  10521a:	8b 45 08             	mov    0x8(%ebp),%eax
  10521d:	0f b6 00             	movzbl (%eax),%eax
  105220:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105223:	75 02                	jne    105227 <strfind+0x1b>
            break;
  105225:	eb 0e                	jmp    105235 <strfind+0x29>
        }
        s ++;
  105227:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  10522b:	8b 45 08             	mov    0x8(%ebp),%eax
  10522e:	0f b6 00             	movzbl (%eax),%eax
  105231:	84 c0                	test   %al,%al
  105233:	75 e5                	jne    10521a <strfind+0xe>
    }
    return (char *)s;
  105235:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105238:	c9                   	leave  
  105239:	c3                   	ret    

0010523a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10523a:	55                   	push   %ebp
  10523b:	89 e5                	mov    %esp,%ebp
  10523d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105247:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10524e:	eb 04                	jmp    105254 <strtol+0x1a>
        s ++;
  105250:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105254:	8b 45 08             	mov    0x8(%ebp),%eax
  105257:	0f b6 00             	movzbl (%eax),%eax
  10525a:	3c 20                	cmp    $0x20,%al
  10525c:	74 f2                	je     105250 <strtol+0x16>
  10525e:	8b 45 08             	mov    0x8(%ebp),%eax
  105261:	0f b6 00             	movzbl (%eax),%eax
  105264:	3c 09                	cmp    $0x9,%al
  105266:	74 e8                	je     105250 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105268:	8b 45 08             	mov    0x8(%ebp),%eax
  10526b:	0f b6 00             	movzbl (%eax),%eax
  10526e:	3c 2b                	cmp    $0x2b,%al
  105270:	75 06                	jne    105278 <strtol+0x3e>
        s ++;
  105272:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105276:	eb 15                	jmp    10528d <strtol+0x53>
    }
    else if (*s == '-') {
  105278:	8b 45 08             	mov    0x8(%ebp),%eax
  10527b:	0f b6 00             	movzbl (%eax),%eax
  10527e:	3c 2d                	cmp    $0x2d,%al
  105280:	75 0b                	jne    10528d <strtol+0x53>
        s ++, neg = 1;
  105282:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105286:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10528d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105291:	74 06                	je     105299 <strtol+0x5f>
  105293:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105297:	75 24                	jne    1052bd <strtol+0x83>
  105299:	8b 45 08             	mov    0x8(%ebp),%eax
  10529c:	0f b6 00             	movzbl (%eax),%eax
  10529f:	3c 30                	cmp    $0x30,%al
  1052a1:	75 1a                	jne    1052bd <strtol+0x83>
  1052a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052a6:	83 c0 01             	add    $0x1,%eax
  1052a9:	0f b6 00             	movzbl (%eax),%eax
  1052ac:	3c 78                	cmp    $0x78,%al
  1052ae:	75 0d                	jne    1052bd <strtol+0x83>
        s += 2, base = 16;
  1052b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1052b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1052bb:	eb 2a                	jmp    1052e7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1052bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1052c1:	75 17                	jne    1052da <strtol+0xa0>
  1052c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052c6:	0f b6 00             	movzbl (%eax),%eax
  1052c9:	3c 30                	cmp    $0x30,%al
  1052cb:	75 0d                	jne    1052da <strtol+0xa0>
        s ++, base = 8;
  1052cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1052d1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1052d8:	eb 0d                	jmp    1052e7 <strtol+0xad>
    }
    else if (base == 0) {
  1052da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1052de:	75 07                	jne    1052e7 <strtol+0xad>
        base = 10;
  1052e0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1052e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1052ea:	0f b6 00             	movzbl (%eax),%eax
  1052ed:	3c 2f                	cmp    $0x2f,%al
  1052ef:	7e 1b                	jle    10530c <strtol+0xd2>
  1052f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f4:	0f b6 00             	movzbl (%eax),%eax
  1052f7:	3c 39                	cmp    $0x39,%al
  1052f9:	7f 11                	jg     10530c <strtol+0xd2>
            dig = *s - '0';
  1052fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1052fe:	0f b6 00             	movzbl (%eax),%eax
  105301:	0f be c0             	movsbl %al,%eax
  105304:	83 e8 30             	sub    $0x30,%eax
  105307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10530a:	eb 48                	jmp    105354 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10530c:	8b 45 08             	mov    0x8(%ebp),%eax
  10530f:	0f b6 00             	movzbl (%eax),%eax
  105312:	3c 60                	cmp    $0x60,%al
  105314:	7e 1b                	jle    105331 <strtol+0xf7>
  105316:	8b 45 08             	mov    0x8(%ebp),%eax
  105319:	0f b6 00             	movzbl (%eax),%eax
  10531c:	3c 7a                	cmp    $0x7a,%al
  10531e:	7f 11                	jg     105331 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105320:	8b 45 08             	mov    0x8(%ebp),%eax
  105323:	0f b6 00             	movzbl (%eax),%eax
  105326:	0f be c0             	movsbl %al,%eax
  105329:	83 e8 57             	sub    $0x57,%eax
  10532c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10532f:	eb 23                	jmp    105354 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105331:	8b 45 08             	mov    0x8(%ebp),%eax
  105334:	0f b6 00             	movzbl (%eax),%eax
  105337:	3c 40                	cmp    $0x40,%al
  105339:	7e 3d                	jle    105378 <strtol+0x13e>
  10533b:	8b 45 08             	mov    0x8(%ebp),%eax
  10533e:	0f b6 00             	movzbl (%eax),%eax
  105341:	3c 5a                	cmp    $0x5a,%al
  105343:	7f 33                	jg     105378 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105345:	8b 45 08             	mov    0x8(%ebp),%eax
  105348:	0f b6 00             	movzbl (%eax),%eax
  10534b:	0f be c0             	movsbl %al,%eax
  10534e:	83 e8 37             	sub    $0x37,%eax
  105351:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105357:	3b 45 10             	cmp    0x10(%ebp),%eax
  10535a:	7c 02                	jl     10535e <strtol+0x124>
            break;
  10535c:	eb 1a                	jmp    105378 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  10535e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105362:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105365:	0f af 45 10          	imul   0x10(%ebp),%eax
  105369:	89 c2                	mov    %eax,%edx
  10536b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10536e:	01 d0                	add    %edx,%eax
  105370:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105373:	e9 6f ff ff ff       	jmp    1052e7 <strtol+0xad>

    if (endptr) {
  105378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10537c:	74 08                	je     105386 <strtol+0x14c>
        *endptr = (char *) s;
  10537e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105381:	8b 55 08             	mov    0x8(%ebp),%edx
  105384:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105386:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10538a:	74 07                	je     105393 <strtol+0x159>
  10538c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10538f:	f7 d8                	neg    %eax
  105391:	eb 03                	jmp    105396 <strtol+0x15c>
  105393:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105396:	c9                   	leave  
  105397:	c3                   	ret    

00105398 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105398:	55                   	push   %ebp
  105399:	89 e5                	mov    %esp,%ebp
  10539b:	57                   	push   %edi
  10539c:	83 ec 24             	sub    $0x24,%esp
  10539f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053a2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1053a5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1053a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1053ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1053af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1053b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1053b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1053b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1053bb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1053bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1053c2:	89 d7                	mov    %edx,%edi
  1053c4:	f3 aa                	rep stos %al,%es:(%edi)
  1053c6:	89 fa                	mov    %edi,%edx
  1053c8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1053cb:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1053ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1053d1:	83 c4 24             	add    $0x24,%esp
  1053d4:	5f                   	pop    %edi
  1053d5:	5d                   	pop    %ebp
  1053d6:	c3                   	ret    

001053d7 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1053d7:	55                   	push   %ebp
  1053d8:	89 e5                	mov    %esp,%ebp
  1053da:	57                   	push   %edi
  1053db:	56                   	push   %esi
  1053dc:	53                   	push   %ebx
  1053dd:	83 ec 30             	sub    $0x30,%esp
  1053e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1053ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1053ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1053f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1053f8:	73 42                	jae    10543c <memmove+0x65>
  1053fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105403:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105406:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105409:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10540c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10540f:	c1 e8 02             	shr    $0x2,%eax
  105412:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105414:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10541a:	89 d7                	mov    %edx,%edi
  10541c:	89 c6                	mov    %eax,%esi
  10541e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105420:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105423:	83 e1 03             	and    $0x3,%ecx
  105426:	74 02                	je     10542a <memmove+0x53>
  105428:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10542a:	89 f0                	mov    %esi,%eax
  10542c:	89 fa                	mov    %edi,%edx
  10542e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105431:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105434:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10543a:	eb 36                	jmp    105472 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10543c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10543f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105442:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105445:	01 c2                	add    %eax,%edx
  105447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10544a:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10544d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105450:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105456:	89 c1                	mov    %eax,%ecx
  105458:	89 d8                	mov    %ebx,%eax
  10545a:	89 d6                	mov    %edx,%esi
  10545c:	89 c7                	mov    %eax,%edi
  10545e:	fd                   	std    
  10545f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105461:	fc                   	cld    
  105462:	89 f8                	mov    %edi,%eax
  105464:	89 f2                	mov    %esi,%edx
  105466:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105469:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10546c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10546f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105472:	83 c4 30             	add    $0x30,%esp
  105475:	5b                   	pop    %ebx
  105476:	5e                   	pop    %esi
  105477:	5f                   	pop    %edi
  105478:	5d                   	pop    %ebp
  105479:	c3                   	ret    

0010547a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10547a:	55                   	push   %ebp
  10547b:	89 e5                	mov    %esp,%ebp
  10547d:	57                   	push   %edi
  10547e:	56                   	push   %esi
  10547f:	83 ec 20             	sub    $0x20,%esp
  105482:	8b 45 08             	mov    0x8(%ebp),%eax
  105485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105488:	8b 45 0c             	mov    0xc(%ebp),%eax
  10548b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10548e:	8b 45 10             	mov    0x10(%ebp),%eax
  105491:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105497:	c1 e8 02             	shr    $0x2,%eax
  10549a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10549c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10549f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054a2:	89 d7                	mov    %edx,%edi
  1054a4:	89 c6                	mov    %eax,%esi
  1054a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1054a8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1054ab:	83 e1 03             	and    $0x3,%ecx
  1054ae:	74 02                	je     1054b2 <memcpy+0x38>
  1054b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1054b2:	89 f0                	mov    %esi,%eax
  1054b4:	89 fa                	mov    %edi,%edx
  1054b6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1054b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1054bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1054bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1054c2:	83 c4 20             	add    $0x20,%esp
  1054c5:	5e                   	pop    %esi
  1054c6:	5f                   	pop    %edi
  1054c7:	5d                   	pop    %ebp
  1054c8:	c3                   	ret    

001054c9 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1054c9:	55                   	push   %ebp
  1054ca:	89 e5                	mov    %esp,%ebp
  1054cc:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1054cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1054d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1054d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1054db:	eb 30                	jmp    10550d <memcmp+0x44>
        if (*s1 != *s2) {
  1054dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054e0:	0f b6 10             	movzbl (%eax),%edx
  1054e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054e6:	0f b6 00             	movzbl (%eax),%eax
  1054e9:	38 c2                	cmp    %al,%dl
  1054eb:	74 18                	je     105505 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1054ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054f0:	0f b6 00             	movzbl (%eax),%eax
  1054f3:	0f b6 d0             	movzbl %al,%edx
  1054f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1054f9:	0f b6 00             	movzbl (%eax),%eax
  1054fc:	0f b6 c0             	movzbl %al,%eax
  1054ff:	29 c2                	sub    %eax,%edx
  105501:	89 d0                	mov    %edx,%eax
  105503:	eb 1a                	jmp    10551f <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105505:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105509:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  10550d:	8b 45 10             	mov    0x10(%ebp),%eax
  105510:	8d 50 ff             	lea    -0x1(%eax),%edx
  105513:	89 55 10             	mov    %edx,0x10(%ebp)
  105516:	85 c0                	test   %eax,%eax
  105518:	75 c3                	jne    1054dd <memcmp+0x14>
    }
    return 0;
  10551a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10551f:	c9                   	leave  
  105520:	c3                   	ret    

00105521 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105521:	55                   	push   %ebp
  105522:	89 e5                	mov    %esp,%ebp
  105524:	83 ec 58             	sub    $0x58,%esp
  105527:	8b 45 10             	mov    0x10(%ebp),%eax
  10552a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10552d:	8b 45 14             	mov    0x14(%ebp),%eax
  105530:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105533:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105539:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10553c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10553f:	8b 45 18             	mov    0x18(%ebp),%eax
  105542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105548:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10554b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10554e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105557:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10555b:	74 1c                	je     105579 <printnum+0x58>
  10555d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105560:	ba 00 00 00 00       	mov    $0x0,%edx
  105565:	f7 75 e4             	divl   -0x1c(%ebp)
  105568:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10556b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10556e:	ba 00 00 00 00       	mov    $0x0,%edx
  105573:	f7 75 e4             	divl   -0x1c(%ebp)
  105576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105579:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10557c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10557f:	f7 75 e4             	divl   -0x1c(%ebp)
  105582:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105585:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105588:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10558b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10558e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105591:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105594:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105597:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10559a:	8b 45 18             	mov    0x18(%ebp),%eax
  10559d:	ba 00 00 00 00       	mov    $0x0,%edx
  1055a2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1055a5:	77 56                	ja     1055fd <printnum+0xdc>
  1055a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1055aa:	72 05                	jb     1055b1 <printnum+0x90>
  1055ac:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1055af:	77 4c                	ja     1055fd <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1055b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1055b4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1055b7:	8b 45 20             	mov    0x20(%ebp),%eax
  1055ba:	89 44 24 18          	mov    %eax,0x18(%esp)
  1055be:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055c2:	8b 45 18             	mov    0x18(%ebp),%eax
  1055c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1055c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055de:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e1:	89 04 24             	mov    %eax,(%esp)
  1055e4:	e8 38 ff ff ff       	call   105521 <printnum>
  1055e9:	eb 1c                	jmp    105607 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1055eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055f2:	8b 45 20             	mov    0x20(%ebp),%eax
  1055f5:	89 04 24             	mov    %eax,(%esp)
  1055f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fb:	ff d0                	call   *%eax
        while (-- width > 0)
  1055fd:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105601:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105605:	7f e4                	jg     1055eb <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105607:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10560a:	05 04 6d 10 00       	add    $0x106d04,%eax
  10560f:	0f b6 00             	movzbl (%eax),%eax
  105612:	0f be c0             	movsbl %al,%eax
  105615:	8b 55 0c             	mov    0xc(%ebp),%edx
  105618:	89 54 24 04          	mov    %edx,0x4(%esp)
  10561c:	89 04 24             	mov    %eax,(%esp)
  10561f:	8b 45 08             	mov    0x8(%ebp),%eax
  105622:	ff d0                	call   *%eax
}
  105624:	c9                   	leave  
  105625:	c3                   	ret    

00105626 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105626:	55                   	push   %ebp
  105627:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105629:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10562d:	7e 14                	jle    105643 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10562f:	8b 45 08             	mov    0x8(%ebp),%eax
  105632:	8b 00                	mov    (%eax),%eax
  105634:	8d 48 08             	lea    0x8(%eax),%ecx
  105637:	8b 55 08             	mov    0x8(%ebp),%edx
  10563a:	89 0a                	mov    %ecx,(%edx)
  10563c:	8b 50 04             	mov    0x4(%eax),%edx
  10563f:	8b 00                	mov    (%eax),%eax
  105641:	eb 30                	jmp    105673 <getuint+0x4d>
    }
    else if (lflag) {
  105643:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105647:	74 16                	je     10565f <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105649:	8b 45 08             	mov    0x8(%ebp),%eax
  10564c:	8b 00                	mov    (%eax),%eax
  10564e:	8d 48 04             	lea    0x4(%eax),%ecx
  105651:	8b 55 08             	mov    0x8(%ebp),%edx
  105654:	89 0a                	mov    %ecx,(%edx)
  105656:	8b 00                	mov    (%eax),%eax
  105658:	ba 00 00 00 00       	mov    $0x0,%edx
  10565d:	eb 14                	jmp    105673 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10565f:	8b 45 08             	mov    0x8(%ebp),%eax
  105662:	8b 00                	mov    (%eax),%eax
  105664:	8d 48 04             	lea    0x4(%eax),%ecx
  105667:	8b 55 08             	mov    0x8(%ebp),%edx
  10566a:	89 0a                	mov    %ecx,(%edx)
  10566c:	8b 00                	mov    (%eax),%eax
  10566e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105673:	5d                   	pop    %ebp
  105674:	c3                   	ret    

00105675 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105675:	55                   	push   %ebp
  105676:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105678:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10567c:	7e 14                	jle    105692 <getint+0x1d>
        return va_arg(*ap, long long);
  10567e:	8b 45 08             	mov    0x8(%ebp),%eax
  105681:	8b 00                	mov    (%eax),%eax
  105683:	8d 48 08             	lea    0x8(%eax),%ecx
  105686:	8b 55 08             	mov    0x8(%ebp),%edx
  105689:	89 0a                	mov    %ecx,(%edx)
  10568b:	8b 50 04             	mov    0x4(%eax),%edx
  10568e:	8b 00                	mov    (%eax),%eax
  105690:	eb 28                	jmp    1056ba <getint+0x45>
    }
    else if (lflag) {
  105692:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105696:	74 12                	je     1056aa <getint+0x35>
        return va_arg(*ap, long);
  105698:	8b 45 08             	mov    0x8(%ebp),%eax
  10569b:	8b 00                	mov    (%eax),%eax
  10569d:	8d 48 04             	lea    0x4(%eax),%ecx
  1056a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1056a3:	89 0a                	mov    %ecx,(%edx)
  1056a5:	8b 00                	mov    (%eax),%eax
  1056a7:	99                   	cltd   
  1056a8:	eb 10                	jmp    1056ba <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1056aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ad:	8b 00                	mov    (%eax),%eax
  1056af:	8d 48 04             	lea    0x4(%eax),%ecx
  1056b2:	8b 55 08             	mov    0x8(%ebp),%edx
  1056b5:	89 0a                	mov    %ecx,(%edx)
  1056b7:	8b 00                	mov    (%eax),%eax
  1056b9:	99                   	cltd   
    }
}
  1056ba:	5d                   	pop    %ebp
  1056bb:	c3                   	ret    

001056bc <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1056bc:	55                   	push   %ebp
  1056bd:	89 e5                	mov    %esp,%ebp
  1056bf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1056c2:	8d 45 14             	lea    0x14(%ebp),%eax
  1056c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1056c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1056d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e0:	89 04 24             	mov    %eax,(%esp)
  1056e3:	e8 02 00 00 00       	call   1056ea <vprintfmt>
    va_end(ap);
}
  1056e8:	c9                   	leave  
  1056e9:	c3                   	ret    

001056ea <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1056ea:	55                   	push   %ebp
  1056eb:	89 e5                	mov    %esp,%ebp
  1056ed:	56                   	push   %esi
  1056ee:	53                   	push   %ebx
  1056ef:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1056f2:	eb 18                	jmp    10570c <vprintfmt+0x22>
            if (ch == '\0') {
  1056f4:	85 db                	test   %ebx,%ebx
  1056f6:	75 05                	jne    1056fd <vprintfmt+0x13>
                return;
  1056f8:	e9 d1 03 00 00       	jmp    105ace <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1056fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105700:	89 44 24 04          	mov    %eax,0x4(%esp)
  105704:	89 1c 24             	mov    %ebx,(%esp)
  105707:	8b 45 08             	mov    0x8(%ebp),%eax
  10570a:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10570c:	8b 45 10             	mov    0x10(%ebp),%eax
  10570f:	8d 50 01             	lea    0x1(%eax),%edx
  105712:	89 55 10             	mov    %edx,0x10(%ebp)
  105715:	0f b6 00             	movzbl (%eax),%eax
  105718:	0f b6 d8             	movzbl %al,%ebx
  10571b:	83 fb 25             	cmp    $0x25,%ebx
  10571e:	75 d4                	jne    1056f4 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105720:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105724:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10572b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10572e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105731:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10573b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10573e:	8b 45 10             	mov    0x10(%ebp),%eax
  105741:	8d 50 01             	lea    0x1(%eax),%edx
  105744:	89 55 10             	mov    %edx,0x10(%ebp)
  105747:	0f b6 00             	movzbl (%eax),%eax
  10574a:	0f b6 d8             	movzbl %al,%ebx
  10574d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105750:	83 f8 55             	cmp    $0x55,%eax
  105753:	0f 87 44 03 00 00    	ja     105a9d <vprintfmt+0x3b3>
  105759:	8b 04 85 28 6d 10 00 	mov    0x106d28(,%eax,4),%eax
  105760:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105762:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105766:	eb d6                	jmp    10573e <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105768:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10576c:	eb d0                	jmp    10573e <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10576e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105775:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105778:	89 d0                	mov    %edx,%eax
  10577a:	c1 e0 02             	shl    $0x2,%eax
  10577d:	01 d0                	add    %edx,%eax
  10577f:	01 c0                	add    %eax,%eax
  105781:	01 d8                	add    %ebx,%eax
  105783:	83 e8 30             	sub    $0x30,%eax
  105786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105789:	8b 45 10             	mov    0x10(%ebp),%eax
  10578c:	0f b6 00             	movzbl (%eax),%eax
  10578f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105792:	83 fb 2f             	cmp    $0x2f,%ebx
  105795:	7e 0b                	jle    1057a2 <vprintfmt+0xb8>
  105797:	83 fb 39             	cmp    $0x39,%ebx
  10579a:	7f 06                	jg     1057a2 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  10579c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  1057a0:	eb d3                	jmp    105775 <vprintfmt+0x8b>
            goto process_precision;
  1057a2:	eb 33                	jmp    1057d7 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1057a4:	8b 45 14             	mov    0x14(%ebp),%eax
  1057a7:	8d 50 04             	lea    0x4(%eax),%edx
  1057aa:	89 55 14             	mov    %edx,0x14(%ebp)
  1057ad:	8b 00                	mov    (%eax),%eax
  1057af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1057b2:	eb 23                	jmp    1057d7 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1057b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057b8:	79 0c                	jns    1057c6 <vprintfmt+0xdc>
                width = 0;
  1057ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1057c1:	e9 78 ff ff ff       	jmp    10573e <vprintfmt+0x54>
  1057c6:	e9 73 ff ff ff       	jmp    10573e <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1057cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1057d2:	e9 67 ff ff ff       	jmp    10573e <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1057d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057db:	79 12                	jns    1057ef <vprintfmt+0x105>
                width = precision, precision = -1;
  1057dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1057ea:	e9 4f ff ff ff       	jmp    10573e <vprintfmt+0x54>
  1057ef:	e9 4a ff ff ff       	jmp    10573e <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1057f4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1057f8:	e9 41 ff ff ff       	jmp    10573e <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1057fd:	8b 45 14             	mov    0x14(%ebp),%eax
  105800:	8d 50 04             	lea    0x4(%eax),%edx
  105803:	89 55 14             	mov    %edx,0x14(%ebp)
  105806:	8b 00                	mov    (%eax),%eax
  105808:	8b 55 0c             	mov    0xc(%ebp),%edx
  10580b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10580f:	89 04 24             	mov    %eax,(%esp)
  105812:	8b 45 08             	mov    0x8(%ebp),%eax
  105815:	ff d0                	call   *%eax
            break;
  105817:	e9 ac 02 00 00       	jmp    105ac8 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10581c:	8b 45 14             	mov    0x14(%ebp),%eax
  10581f:	8d 50 04             	lea    0x4(%eax),%edx
  105822:	89 55 14             	mov    %edx,0x14(%ebp)
  105825:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105827:	85 db                	test   %ebx,%ebx
  105829:	79 02                	jns    10582d <vprintfmt+0x143>
                err = -err;
  10582b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10582d:	83 fb 06             	cmp    $0x6,%ebx
  105830:	7f 0b                	jg     10583d <vprintfmt+0x153>
  105832:	8b 34 9d e8 6c 10 00 	mov    0x106ce8(,%ebx,4),%esi
  105839:	85 f6                	test   %esi,%esi
  10583b:	75 23                	jne    105860 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10583d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105841:	c7 44 24 08 15 6d 10 	movl   $0x106d15,0x8(%esp)
  105848:	00 
  105849:	8b 45 0c             	mov    0xc(%ebp),%eax
  10584c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105850:	8b 45 08             	mov    0x8(%ebp),%eax
  105853:	89 04 24             	mov    %eax,(%esp)
  105856:	e8 61 fe ff ff       	call   1056bc <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10585b:	e9 68 02 00 00       	jmp    105ac8 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  105860:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105864:	c7 44 24 08 1e 6d 10 	movl   $0x106d1e,0x8(%esp)
  10586b:	00 
  10586c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105873:	8b 45 08             	mov    0x8(%ebp),%eax
  105876:	89 04 24             	mov    %eax,(%esp)
  105879:	e8 3e fe ff ff       	call   1056bc <printfmt>
            break;
  10587e:	e9 45 02 00 00       	jmp    105ac8 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105883:	8b 45 14             	mov    0x14(%ebp),%eax
  105886:	8d 50 04             	lea    0x4(%eax),%edx
  105889:	89 55 14             	mov    %edx,0x14(%ebp)
  10588c:	8b 30                	mov    (%eax),%esi
  10588e:	85 f6                	test   %esi,%esi
  105890:	75 05                	jne    105897 <vprintfmt+0x1ad>
                p = "(null)";
  105892:	be 21 6d 10 00       	mov    $0x106d21,%esi
            }
            if (width > 0 && padc != '-') {
  105897:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10589b:	7e 3e                	jle    1058db <vprintfmt+0x1f1>
  10589d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1058a1:	74 38                	je     1058db <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058a3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1058a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ad:	89 34 24             	mov    %esi,(%esp)
  1058b0:	e8 dc f7 ff ff       	call   105091 <strnlen>
  1058b5:	29 c3                	sub    %eax,%ebx
  1058b7:	89 d8                	mov    %ebx,%eax
  1058b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058bc:	eb 17                	jmp    1058d5 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1058be:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1058c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058c9:	89 04 24             	mov    %eax,(%esp)
  1058cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1058cf:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1058d1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1058d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1058d9:	7f e3                	jg     1058be <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1058db:	eb 38                	jmp    105915 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1058dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1058e1:	74 1f                	je     105902 <vprintfmt+0x218>
  1058e3:	83 fb 1f             	cmp    $0x1f,%ebx
  1058e6:	7e 05                	jle    1058ed <vprintfmt+0x203>
  1058e8:	83 fb 7e             	cmp    $0x7e,%ebx
  1058eb:	7e 15                	jle    105902 <vprintfmt+0x218>
                    putch('?', putdat);
  1058ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1058fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fe:	ff d0                	call   *%eax
  105900:	eb 0f                	jmp    105911 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105902:	8b 45 0c             	mov    0xc(%ebp),%eax
  105905:	89 44 24 04          	mov    %eax,0x4(%esp)
  105909:	89 1c 24             	mov    %ebx,(%esp)
  10590c:	8b 45 08             	mov    0x8(%ebp),%eax
  10590f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105911:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105915:	89 f0                	mov    %esi,%eax
  105917:	8d 70 01             	lea    0x1(%eax),%esi
  10591a:	0f b6 00             	movzbl (%eax),%eax
  10591d:	0f be d8             	movsbl %al,%ebx
  105920:	85 db                	test   %ebx,%ebx
  105922:	74 10                	je     105934 <vprintfmt+0x24a>
  105924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105928:	78 b3                	js     1058dd <vprintfmt+0x1f3>
  10592a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10592e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105932:	79 a9                	jns    1058dd <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  105934:	eb 17                	jmp    10594d <vprintfmt+0x263>
                putch(' ', putdat);
  105936:	8b 45 0c             	mov    0xc(%ebp),%eax
  105939:	89 44 24 04          	mov    %eax,0x4(%esp)
  10593d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105944:	8b 45 08             	mov    0x8(%ebp),%eax
  105947:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105949:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10594d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105951:	7f e3                	jg     105936 <vprintfmt+0x24c>
            }
            break;
  105953:	e9 70 01 00 00       	jmp    105ac8 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105958:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10595b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10595f:	8d 45 14             	lea    0x14(%ebp),%eax
  105962:	89 04 24             	mov    %eax,(%esp)
  105965:	e8 0b fd ff ff       	call   105675 <getint>
  10596a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10596d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105970:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105973:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105976:	85 d2                	test   %edx,%edx
  105978:	79 26                	jns    1059a0 <vprintfmt+0x2b6>
                putch('-', putdat);
  10597a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10597d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105981:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105988:	8b 45 08             	mov    0x8(%ebp),%eax
  10598b:	ff d0                	call   *%eax
                num = -(long long)num;
  10598d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105993:	f7 d8                	neg    %eax
  105995:	83 d2 00             	adc    $0x0,%edx
  105998:	f7 da                	neg    %edx
  10599a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10599d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1059a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059a7:	e9 a8 00 00 00       	jmp    105a54 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1059ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059b3:	8d 45 14             	lea    0x14(%ebp),%eax
  1059b6:	89 04 24             	mov    %eax,(%esp)
  1059b9:	e8 68 fc ff ff       	call   105626 <getuint>
  1059be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1059c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1059cb:	e9 84 00 00 00       	jmp    105a54 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1059d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d7:	8d 45 14             	lea    0x14(%ebp),%eax
  1059da:	89 04 24             	mov    %eax,(%esp)
  1059dd:	e8 44 fc ff ff       	call   105626 <getuint>
  1059e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1059e8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1059ef:	eb 63                	jmp    105a54 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1059f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1059ff:	8b 45 08             	mov    0x8(%ebp),%eax
  105a02:	ff d0                	call   *%eax
            putch('x', putdat);
  105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a0b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105a12:	8b 45 08             	mov    0x8(%ebp),%eax
  105a15:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105a17:	8b 45 14             	mov    0x14(%ebp),%eax
  105a1a:	8d 50 04             	lea    0x4(%eax),%edx
  105a1d:	89 55 14             	mov    %edx,0x14(%ebp)
  105a20:	8b 00                	mov    (%eax),%eax
  105a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105a2c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105a33:	eb 1f                	jmp    105a54 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a3c:	8d 45 14             	lea    0x14(%ebp),%eax
  105a3f:	89 04 24             	mov    %eax,(%esp)
  105a42:	e8 df fb ff ff       	call   105626 <getuint>
  105a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105a4d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105a54:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a5b:	89 54 24 18          	mov    %edx,0x18(%esp)
  105a5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105a62:	89 54 24 14          	mov    %edx,0x14(%esp)
  105a66:	89 44 24 10          	mov    %eax,0x10(%esp)
  105a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a70:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a74:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a82:	89 04 24             	mov    %eax,(%esp)
  105a85:	e8 97 fa ff ff       	call   105521 <printnum>
            break;
  105a8a:	eb 3c                	jmp    105ac8 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a93:	89 1c 24             	mov    %ebx,(%esp)
  105a96:	8b 45 08             	mov    0x8(%ebp),%eax
  105a99:	ff d0                	call   *%eax
            break;
  105a9b:	eb 2b                	jmp    105ac8 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa4:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105aab:	8b 45 08             	mov    0x8(%ebp),%eax
  105aae:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105ab0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ab4:	eb 04                	jmp    105aba <vprintfmt+0x3d0>
  105ab6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105aba:	8b 45 10             	mov    0x10(%ebp),%eax
  105abd:	83 e8 01             	sub    $0x1,%eax
  105ac0:	0f b6 00             	movzbl (%eax),%eax
  105ac3:	3c 25                	cmp    $0x25,%al
  105ac5:	75 ef                	jne    105ab6 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105ac7:	90                   	nop
        }
    }
  105ac8:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105ac9:	e9 3e fc ff ff       	jmp    10570c <vprintfmt+0x22>
}
  105ace:	83 c4 40             	add    $0x40,%esp
  105ad1:	5b                   	pop    %ebx
  105ad2:	5e                   	pop    %esi
  105ad3:	5d                   	pop    %ebp
  105ad4:	c3                   	ret    

00105ad5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105ad5:	55                   	push   %ebp
  105ad6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105adb:	8b 40 08             	mov    0x8(%eax),%eax
  105ade:	8d 50 01             	lea    0x1(%eax),%edx
  105ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aea:	8b 10                	mov    (%eax),%edx
  105aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aef:	8b 40 04             	mov    0x4(%eax),%eax
  105af2:	39 c2                	cmp    %eax,%edx
  105af4:	73 12                	jae    105b08 <sprintputch+0x33>
        *b->buf ++ = ch;
  105af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af9:	8b 00                	mov    (%eax),%eax
  105afb:	8d 48 01             	lea    0x1(%eax),%ecx
  105afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b01:	89 0a                	mov    %ecx,(%edx)
  105b03:	8b 55 08             	mov    0x8(%ebp),%edx
  105b06:	88 10                	mov    %dl,(%eax)
    }
}
  105b08:	5d                   	pop    %ebp
  105b09:	c3                   	ret    

00105b0a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105b0a:	55                   	push   %ebp
  105b0b:	89 e5                	mov    %esp,%ebp
  105b0d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105b10:	8d 45 14             	lea    0x14(%ebp),%eax
  105b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b19:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  105b20:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2e:	89 04 24             	mov    %eax,(%esp)
  105b31:	e8 08 00 00 00       	call   105b3e <vsnprintf>
  105b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105b3c:	c9                   	leave  
  105b3d:	c3                   	ret    

00105b3e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105b3e:	55                   	push   %ebp
  105b3f:	89 e5                	mov    %esp,%ebp
  105b41:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105b44:	8b 45 08             	mov    0x8(%ebp),%eax
  105b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b50:	8b 45 08             	mov    0x8(%ebp),%eax
  105b53:	01 d0                	add    %edx,%eax
  105b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105b5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105b63:	74 0a                	je     105b6f <vsnprintf+0x31>
  105b65:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b6b:	39 c2                	cmp    %eax,%edx
  105b6d:	76 07                	jbe    105b76 <vsnprintf+0x38>
        return -E_INVAL;
  105b6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105b74:	eb 2a                	jmp    105ba0 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105b76:	8b 45 14             	mov    0x14(%ebp),%eax
  105b79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  105b80:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b84:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b8b:	c7 04 24 d5 5a 10 00 	movl   $0x105ad5,(%esp)
  105b92:	e8 53 fb ff ff       	call   1056ea <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b9a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ba0:	c9                   	leave  
  105ba1:	c3                   	ret    
