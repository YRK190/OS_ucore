
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 42 53 00 00       	call   c0105398 <memset>

    cons_init();                // init the console
c0100056:	e8 bc 14 00 00       	call   c0101517 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 5b 10 c0 	movl   $0xc0105bc0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 5b 10 c0 	movl   $0xc0105bdc,(%esp)
c0100070:	e8 16 02 00 00       	call   c010028b <cprintf>

    print_kerninfo();
c0100075:	e8 b7 08 00 00       	call   c0100931 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 8b 00 00 00       	call   c010010a <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 b8 2e 00 00       	call   c0102f3c <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 eb 15 00 00       	call   c0101674 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 49 17 00 00       	call   c01017d7 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 3a 0c 00 00       	call   c0100ccd <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 17 17 00 00       	call   c01017af <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
c0100098:	e8 62 01 00 00       	call   c01001ff <lab1_switch_test>

    /* do nothing */
    while (1);
c010009d:	eb fe                	jmp    c010009d <kern_init+0x73>

c010009f <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009f:	55                   	push   %ebp
c01000a0:	89 e5                	mov    %esp,%ebp
c01000a2:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ac:	00 
c01000ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b4:	00 
c01000b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bc:	e8 fa 0b 00 00       	call   c0100cbb <mon_backtrace>
}
c01000c1:	c9                   	leave  
c01000c2:	c3                   	ret    

c01000c3 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c3:	55                   	push   %ebp
c01000c4:	89 e5                	mov    %esp,%ebp
c01000c6:	53                   	push   %ebx
c01000c7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000ca:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d0:	8d 55 08             	lea    0x8(%ebp),%edx
c01000d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000da:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000de:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e2:	89 04 24             	mov    %eax,(%esp)
c01000e5:	e8 b5 ff ff ff       	call   c010009f <grade_backtrace2>
}
c01000ea:	83 c4 14             	add    $0x14,%esp
c01000ed:	5b                   	pop    %ebx
c01000ee:	5d                   	pop    %ebp
c01000ef:	c3                   	ret    

c01000f0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f0:	55                   	push   %ebp
c01000f1:	89 e5                	mov    %esp,%ebp
c01000f3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100100:	89 04 24             	mov    %eax,(%esp)
c0100103:	e8 bb ff ff ff       	call   c01000c3 <grade_backtrace1>
}
c0100108:	c9                   	leave  
c0100109:	c3                   	ret    

c010010a <grade_backtrace>:

void
grade_backtrace(void) {
c010010a:	55                   	push   %ebp
c010010b:	89 e5                	mov    %esp,%ebp
c010010d:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100110:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100115:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010011c:	ff 
c010011d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100128:	e8 c3 ff ff ff       	call   c01000f0 <grade_backtrace0>
}
c010012d:	c9                   	leave  
c010012e:	c3                   	ret    

c010012f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012f:	55                   	push   %ebp
c0100130:	89 e5                	mov    %esp,%ebp
c0100132:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100135:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100138:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100141:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100145:	0f b7 c0             	movzwl %ax,%eax
c0100148:	83 e0 03             	and    $0x3,%eax
c010014b:	89 c2                	mov    %eax,%edx
c010014d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100152:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100156:	89 44 24 04          	mov    %eax,0x4(%esp)
c010015a:	c7 04 24 e1 5b 10 c0 	movl   $0xc0105be1,(%esp)
c0100161:	e8 25 01 00 00       	call   c010028b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100166:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016a:	0f b7 d0             	movzwl %ax,%edx
c010016d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100172:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100176:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017a:	c7 04 24 ef 5b 10 c0 	movl   $0xc0105bef,(%esp)
c0100181:	e8 05 01 00 00       	call   c010028b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100186:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010018a:	0f b7 d0             	movzwl %ax,%edx
c010018d:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c0100192:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100196:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019a:	c7 04 24 fd 5b 10 c0 	movl   $0xc0105bfd,(%esp)
c01001a1:	e8 e5 00 00 00       	call   c010028b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001aa:	0f b7 d0             	movzwl %ax,%edx
c01001ad:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001b2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ba:	c7 04 24 0b 5c 10 c0 	movl   $0xc0105c0b,(%esp)
c01001c1:	e8 c5 00 00 00       	call   c010028b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001ca:	0f b7 d0             	movzwl %ax,%edx
c01001cd:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001d2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001da:	c7 04 24 19 5c 10 c0 	movl   $0xc0105c19,(%esp)
c01001e1:	e8 a5 00 00 00       	call   c010028b <cprintf>
    round ++;
c01001e6:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001eb:	83 c0 01             	add    $0x1,%eax
c01001ee:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001f3:	c9                   	leave  
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
c0100202:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100205:	e8 25 ff ff ff       	call   c010012f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020a:	c7 04 24 28 5c 10 c0 	movl   $0xc0105c28,(%esp)
c0100211:	e8 75 00 00 00       	call   c010028b <cprintf>
    lab1_switch_to_user();
c0100216:	e8 da ff ff ff       	call   c01001f5 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021b:	e8 0f ff ff ff       	call   c010012f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100220:	c7 04 24 48 5c 10 c0 	movl   $0xc0105c48,(%esp)
c0100227:	e8 5f 00 00 00       	call   c010028b <cprintf>
    lab1_switch_to_kernel();
c010022c:	e8 c9 ff ff ff       	call   c01001fa <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100231:	e8 f9 fe ff ff       	call   c010012f <lab1_print_cur_status>
}
c0100236:	c9                   	leave  
c0100237:	c3                   	ret    

c0100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100238:	55                   	push   %ebp
c0100239:	89 e5                	mov    %esp,%ebp
c010023b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010023e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100241:	89 04 24             	mov    %eax,(%esp)
c0100244:	e8 fa 12 00 00       	call   c0101543 <cons_putc>
    (*cnt) ++;
c0100249:	8b 45 0c             	mov    0xc(%ebp),%eax
c010024c:	8b 00                	mov    (%eax),%eax
c010024e:	8d 50 01             	lea    0x1(%eax),%edx
c0100251:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100254:	89 10                	mov    %edx,(%eax)
}
c0100256:	c9                   	leave  
c0100257:	c3                   	ret    

c0100258 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100258:	55                   	push   %ebp
c0100259:	89 e5                	mov    %esp,%ebp
c010025b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100265:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100268:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010026c:	8b 45 08             	mov    0x8(%ebp),%eax
c010026f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100273:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100276:	89 44 24 04          	mov    %eax,0x4(%esp)
c010027a:	c7 04 24 38 02 10 c0 	movl   $0xc0100238,(%esp)
c0100281:	e8 64 54 00 00       	call   c01056ea <vprintfmt>
    return cnt;
c0100286:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100289:	c9                   	leave  
c010028a:	c3                   	ret    

c010028b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010028b:	55                   	push   %ebp
c010028c:	89 e5                	mov    %esp,%ebp
c010028e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100291:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100294:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100297:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010029e:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a1:	89 04 24             	mov    %eax,(%esp)
c01002a4:	e8 af ff ff ff       	call   c0100258 <vcprintf>
c01002a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002af:	c9                   	leave  
c01002b0:	c3                   	ret    

c01002b1 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b1:	55                   	push   %ebp
c01002b2:	89 e5                	mov    %esp,%ebp
c01002b4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 81 12 00 00       	call   c0101543 <cons_putc>
}
c01002c2:	c9                   	leave  
c01002c3:	c3                   	ret    

c01002c4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002c4:	55                   	push   %ebp
c01002c5:	89 e5                	mov    %esp,%ebp
c01002c7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d1:	eb 13                	jmp    c01002e6 <cputs+0x22>
        cputch(c, &cnt);
c01002d3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002d7:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002de:	89 04 24             	mov    %eax,(%esp)
c01002e1:	e8 52 ff ff ff       	call   c0100238 <cputch>
    while ((c = *str ++) != '\0') {
c01002e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01002e9:	8d 50 01             	lea    0x1(%eax),%edx
c01002ec:	89 55 08             	mov    %edx,0x8(%ebp)
c01002ef:	0f b6 00             	movzbl (%eax),%eax
c01002f2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002f5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002f9:	75 d8                	jne    c01002d3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01002fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01002fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100302:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100309:	e8 2a ff ff ff       	call   c0100238 <cputch>
    return cnt;
c010030e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100311:	c9                   	leave  
c0100312:	c3                   	ret    

c0100313 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100313:	55                   	push   %ebp
c0100314:	89 e5                	mov    %esp,%ebp
c0100316:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100319:	e8 61 12 00 00       	call   c010157f <cons_getc>
c010031e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100325:	74 f2                	je     c0100319 <getchar+0x6>
        /* do nothing */;
    return c;
c0100327:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010032a:	c9                   	leave  
c010032b:	c3                   	ret    

c010032c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010032c:	55                   	push   %ebp
c010032d:	89 e5                	mov    %esp,%ebp
c010032f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100332:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100336:	74 13                	je     c010034b <readline+0x1f>
        cprintf("%s", prompt);
c0100338:	8b 45 08             	mov    0x8(%ebp),%eax
c010033b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033f:	c7 04 24 67 5c 10 c0 	movl   $0xc0105c67,(%esp)
c0100346:	e8 40 ff ff ff       	call   c010028b <cprintf>
    }
    int i = 0, c;
c010034b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100352:	e8 bc ff ff ff       	call   c0100313 <getchar>
c0100357:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010035a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010035e:	79 07                	jns    c0100367 <readline+0x3b>
            return NULL;
c0100360:	b8 00 00 00 00       	mov    $0x0,%eax
c0100365:	eb 79                	jmp    c01003e0 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100367:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010036b:	7e 28                	jle    c0100395 <readline+0x69>
c010036d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100374:	7f 1f                	jg     c0100395 <readline+0x69>
            cputchar(c);
c0100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100379:	89 04 24             	mov    %eax,(%esp)
c010037c:	e8 30 ff ff ff       	call   c01002b1 <cputchar>
            buf[i ++] = c;
c0100381:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100384:	8d 50 01             	lea    0x1(%eax),%edx
c0100387:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010038a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010038d:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c0100393:	eb 46                	jmp    c01003db <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c0100395:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100399:	75 17                	jne    c01003b2 <readline+0x86>
c010039b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010039f:	7e 11                	jle    c01003b2 <readline+0x86>
            cputchar(c);
c01003a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003a4:	89 04 24             	mov    %eax,(%esp)
c01003a7:	e8 05 ff ff ff       	call   c01002b1 <cputchar>
            i --;
c01003ac:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003b0:	eb 29                	jmp    c01003db <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01003b2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003b6:	74 06                	je     c01003be <readline+0x92>
c01003b8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003bc:	75 1d                	jne    c01003db <readline+0xaf>
            cputchar(c);
c01003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c1:	89 04 24             	mov    %eax,(%esp)
c01003c4:	e8 e8 fe ff ff       	call   c01002b1 <cputchar>
            buf[i] = '\0';
c01003c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003cc:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01003d1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003d4:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01003d9:	eb 05                	jmp    c01003e0 <readline+0xb4>
        }
    }
c01003db:	e9 72 ff ff ff       	jmp    c0100352 <readline+0x26>
}
c01003e0:	c9                   	leave  
c01003e1:	c3                   	ret    

c01003e2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e2:	55                   	push   %ebp
c01003e3:	89 e5                	mov    %esp,%ebp
c01003e5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003e8:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c01003ed:	85 c0                	test   %eax,%eax
c01003ef:	74 02                	je     c01003f3 <__panic+0x11>
        goto panic_dead;
c01003f1:	eb 48                	jmp    c010043b <__panic+0x59>
    }
    is_panic = 1;
c01003f3:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c01003fa:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100403:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100406:	89 44 24 08          	mov    %eax,0x8(%esp)
c010040a:	8b 45 08             	mov    0x8(%ebp),%eax
c010040d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100411:	c7 04 24 6a 5c 10 c0 	movl   $0xc0105c6a,(%esp)
c0100418:	e8 6e fe ff ff       	call   c010028b <cprintf>
    vcprintf(fmt, ap);
c010041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100420:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100424:	8b 45 10             	mov    0x10(%ebp),%eax
c0100427:	89 04 24             	mov    %eax,(%esp)
c010042a:	e8 29 fe ff ff       	call   c0100258 <vcprintf>
    cprintf("\n");
c010042f:	c7 04 24 86 5c 10 c0 	movl   $0xc0105c86,(%esp)
c0100436:	e8 50 fe ff ff       	call   c010028b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c010043b:	e8 75 13 00 00       	call   c01017b5 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100440:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100447:	e8 a0 07 00 00       	call   c0100bec <kmonitor>
    }
c010044c:	eb f2                	jmp    c0100440 <__panic+0x5e>

c010044e <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c010044e:	55                   	push   %ebp
c010044f:	89 e5                	mov    %esp,%ebp
c0100451:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100454:	8d 45 14             	lea    0x14(%ebp),%eax
c0100457:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010045a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010045d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100461:	8b 45 08             	mov    0x8(%ebp),%eax
c0100464:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100468:	c7 04 24 88 5c 10 c0 	movl   $0xc0105c88,(%esp)
c010046f:	e8 17 fe ff ff       	call   c010028b <cprintf>
    vcprintf(fmt, ap);
c0100474:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100477:	89 44 24 04          	mov    %eax,0x4(%esp)
c010047b:	8b 45 10             	mov    0x10(%ebp),%eax
c010047e:	89 04 24             	mov    %eax,(%esp)
c0100481:	e8 d2 fd ff ff       	call   c0100258 <vcprintf>
    cprintf("\n");
c0100486:	c7 04 24 86 5c 10 c0 	movl   $0xc0105c86,(%esp)
c010048d:	e8 f9 fd ff ff       	call   c010028b <cprintf>
    va_end(ap);
}
c0100492:	c9                   	leave  
c0100493:	c3                   	ret    

c0100494 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100494:	55                   	push   %ebp
c0100495:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100497:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c010049c:	5d                   	pop    %ebp
c010049d:	c3                   	ret    

c010049e <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c010049e:	55                   	push   %ebp
c010049f:	89 e5                	mov    %esp,%ebp
c01004a1:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004a7:	8b 00                	mov    (%eax),%eax
c01004a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01004af:	8b 00                	mov    (%eax),%eax
c01004b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004bb:	e9 d2 00 00 00       	jmp    c0100592 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004c6:	01 d0                	add    %edx,%eax
c01004c8:	89 c2                	mov    %eax,%edx
c01004ca:	c1 ea 1f             	shr    $0x1f,%edx
c01004cd:	01 d0                	add    %edx,%eax
c01004cf:	d1 f8                	sar    %eax
c01004d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004d7:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004da:	eb 04                	jmp    c01004e0 <stab_binsearch+0x42>
            m --;
c01004dc:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004e6:	7c 1f                	jl     c0100507 <stab_binsearch+0x69>
c01004e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004eb:	89 d0                	mov    %edx,%eax
c01004ed:	01 c0                	add    %eax,%eax
c01004ef:	01 d0                	add    %edx,%eax
c01004f1:	c1 e0 02             	shl    $0x2,%eax
c01004f4:	89 c2                	mov    %eax,%edx
c01004f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01004f9:	01 d0                	add    %edx,%eax
c01004fb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01004ff:	0f b6 c0             	movzbl %al,%eax
c0100502:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100505:	75 d5                	jne    c01004dc <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100507:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010050a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050d:	7d 0b                	jge    c010051a <stab_binsearch+0x7c>
            l = true_m + 1;
c010050f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100512:	83 c0 01             	add    $0x1,%eax
c0100515:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100518:	eb 78                	jmp    c0100592 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c010051a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100521:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	8b 40 08             	mov    0x8(%eax),%eax
c0100537:	3b 45 18             	cmp    0x18(%ebp),%eax
c010053a:	73 13                	jae    c010054f <stab_binsearch+0xb1>
            *region_left = m;
c010053c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100542:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100544:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100547:	83 c0 01             	add    $0x1,%eax
c010054a:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010054d:	eb 43                	jmp    c0100592 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010054f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100552:	89 d0                	mov    %edx,%eax
c0100554:	01 c0                	add    %eax,%eax
c0100556:	01 d0                	add    %edx,%eax
c0100558:	c1 e0 02             	shl    $0x2,%eax
c010055b:	89 c2                	mov    %eax,%edx
c010055d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100560:	01 d0                	add    %edx,%eax
c0100562:	8b 40 08             	mov    0x8(%eax),%eax
c0100565:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100568:	76 16                	jbe    c0100580 <stab_binsearch+0xe2>
            *region_right = m - 1;
c010056a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010056d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100570:	8b 45 10             	mov    0x10(%ebp),%eax
c0100573:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100578:	83 e8 01             	sub    $0x1,%eax
c010057b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010057e:	eb 12                	jmp    c0100592 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100586:	89 10                	mov    %edx,(%eax)
            l = m;
c0100588:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010058b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010058e:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c0100592:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100595:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0100598:	0f 8e 22 ff ff ff    	jle    c01004c0 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c010059e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005a2:	75 0f                	jne    c01005b3 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a7:	8b 00                	mov    (%eax),%eax
c01005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01005af:	89 10                	mov    %edx,(%eax)
c01005b1:	eb 3f                	jmp    c01005f2 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01005b6:	8b 00                	mov    (%eax),%eax
c01005b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005bb:	eb 04                	jmp    c01005c1 <stab_binsearch+0x123>
c01005bd:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005c4:	8b 00                	mov    (%eax),%eax
c01005c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005c9:	7d 1f                	jge    c01005ea <stab_binsearch+0x14c>
c01005cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005ce:	89 d0                	mov    %edx,%eax
c01005d0:	01 c0                	add    %eax,%eax
c01005d2:	01 d0                	add    %edx,%eax
c01005d4:	c1 e0 02             	shl    $0x2,%eax
c01005d7:	89 c2                	mov    %eax,%edx
c01005d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dc:	01 d0                	add    %edx,%eax
c01005de:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005e2:	0f b6 c0             	movzbl %al,%eax
c01005e5:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005e8:	75 d3                	jne    c01005bd <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c01005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f0:	89 10                	mov    %edx,(%eax)
    }
}
c01005f2:	c9                   	leave  
c01005f3:	c3                   	ret    

c01005f4 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c01005f4:	55                   	push   %ebp
c01005f5:	89 e5                	mov    %esp,%ebp
c01005f7:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c01005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fd:	c7 00 a8 5c 10 c0    	movl   $0xc0105ca8,(%eax)
    info->eip_line = 0;
c0100603:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010060d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100610:	c7 40 08 a8 5c 10 c0 	movl   $0xc0105ca8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100617:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061a:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100624:	8b 55 08             	mov    0x8(%ebp),%edx
c0100627:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010062a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100634:	c7 45 f4 80 6e 10 c0 	movl   $0xc0106e80,-0xc(%ebp)
    stab_end = __STAB_END__;
c010063b:	c7 45 f0 14 16 11 c0 	movl   $0xc0111614,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100642:	c7 45 ec 15 16 11 c0 	movl   $0xc0111615,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100649:	c7 45 e8 0f 40 11 c0 	movl   $0xc011400f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100650:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100653:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100656:	76 0d                	jbe    c0100665 <debuginfo_eip+0x71>
c0100658:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010065b:	83 e8 01             	sub    $0x1,%eax
c010065e:	0f b6 00             	movzbl (%eax),%eax
c0100661:	84 c0                	test   %al,%al
c0100663:	74 0a                	je     c010066f <debuginfo_eip+0x7b>
        return -1;
c0100665:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010066a:	e9 c0 02 00 00       	jmp    c010092f <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010066f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100676:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100679:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067c:	29 c2                	sub    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	c1 f8 02             	sar    $0x2,%eax
c0100683:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100689:	83 e8 01             	sub    $0x1,%eax
c010068c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010068f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100692:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100696:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c010069d:	00 
c010069e:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006a1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006af:	89 04 24             	mov    %eax,(%esp)
c01006b2:	e8 e7 fd ff ff       	call   c010049e <stab_binsearch>
    if (lfile == 0)
c01006b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ba:	85 c0                	test   %eax,%eax
c01006bc:	75 0a                	jne    c01006c8 <debuginfo_eip+0xd4>
        return -1;
c01006be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006c3:	e9 67 02 00 00       	jmp    c010092f <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01006d7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006db:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006e2:	00 
c01006e3:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006f4:	89 04 24             	mov    %eax,(%esp)
c01006f7:	e8 a2 fd ff ff       	call   c010049e <stab_binsearch>

    if (lfun <= rfun) {
c01006fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01006ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100702:	39 c2                	cmp    %eax,%edx
c0100704:	7f 7c                	jg     c0100782 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100706:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100709:	89 c2                	mov    %eax,%edx
c010070b:	89 d0                	mov    %edx,%eax
c010070d:	01 c0                	add    %eax,%eax
c010070f:	01 d0                	add    %edx,%eax
c0100711:	c1 e0 02             	shl    $0x2,%eax
c0100714:	89 c2                	mov    %eax,%edx
c0100716:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100719:	01 d0                	add    %edx,%eax
c010071b:	8b 10                	mov    (%eax),%edx
c010071d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100720:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100723:	29 c1                	sub    %eax,%ecx
c0100725:	89 c8                	mov    %ecx,%eax
c0100727:	39 c2                	cmp    %eax,%edx
c0100729:	73 22                	jae    c010074d <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010072b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010072e:	89 c2                	mov    %eax,%edx
c0100730:	89 d0                	mov    %edx,%eax
c0100732:	01 c0                	add    %eax,%eax
c0100734:	01 d0                	add    %edx,%eax
c0100736:	c1 e0 02             	shl    $0x2,%eax
c0100739:	89 c2                	mov    %eax,%edx
c010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073e:	01 d0                	add    %edx,%eax
c0100740:	8b 10                	mov    (%eax),%edx
c0100742:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100745:	01 c2                	add    %eax,%edx
c0100747:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074a:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010074d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100750:	89 c2                	mov    %eax,%edx
c0100752:	89 d0                	mov    %edx,%eax
c0100754:	01 c0                	add    %eax,%eax
c0100756:	01 d0                	add    %edx,%eax
c0100758:	c1 e0 02             	shl    $0x2,%eax
c010075b:	89 c2                	mov    %eax,%edx
c010075d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100760:	01 d0                	add    %edx,%eax
c0100762:	8b 50 08             	mov    0x8(%eax),%edx
c0100765:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100768:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010076b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076e:	8b 40 10             	mov    0x10(%eax),%eax
c0100771:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100774:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100777:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010077a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010077d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100780:	eb 15                	jmp    c0100797 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100782:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100785:	8b 55 08             	mov    0x8(%ebp),%edx
c0100788:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010078e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c0100791:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100794:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c0100797:	8b 45 0c             	mov    0xc(%ebp),%eax
c010079a:	8b 40 08             	mov    0x8(%eax),%eax
c010079d:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007a4:	00 
c01007a5:	89 04 24             	mov    %eax,(%esp)
c01007a8:	e8 5f 4a 00 00       	call   c010520c <strfind>
c01007ad:	89 c2                	mov    %eax,%edx
c01007af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b2:	8b 40 08             	mov    0x8(%eax),%eax
c01007b5:	29 c2                	sub    %eax,%edx
c01007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ba:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01007c0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007c4:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007cb:	00 
c01007cc:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007cf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007d3:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007dd:	89 04 24             	mov    %eax,(%esp)
c01007e0:	e8 b9 fc ff ff       	call   c010049e <stab_binsearch>
    if (lline <= rline) {
c01007e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007eb:	39 c2                	cmp    %eax,%edx
c01007ed:	7f 24                	jg     c0100813 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c01007ef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f2:	89 c2                	mov    %eax,%edx
c01007f4:	89 d0                	mov    %edx,%eax
c01007f6:	01 c0                	add    %eax,%eax
c01007f8:	01 d0                	add    %edx,%eax
c01007fa:	c1 e0 02             	shl    $0x2,%eax
c01007fd:	89 c2                	mov    %eax,%edx
c01007ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100802:	01 d0                	add    %edx,%eax
c0100804:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100808:	0f b7 d0             	movzwl %ax,%edx
c010080b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010080e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100811:	eb 13                	jmp    c0100826 <debuginfo_eip+0x232>
        return -1;
c0100813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100818:	e9 12 01 00 00       	jmp    c010092f <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100820:	83 e8 01             	sub    $0x1,%eax
c0100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100826:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010082c:	39 c2                	cmp    %eax,%edx
c010082e:	7c 56                	jl     c0100886 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100830:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100833:	89 c2                	mov    %eax,%edx
c0100835:	89 d0                	mov    %edx,%eax
c0100837:	01 c0                	add    %eax,%eax
c0100839:	01 d0                	add    %edx,%eax
c010083b:	c1 e0 02             	shl    $0x2,%eax
c010083e:	89 c2                	mov    %eax,%edx
c0100840:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100843:	01 d0                	add    %edx,%eax
c0100845:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100849:	3c 84                	cmp    $0x84,%al
c010084b:	74 39                	je     c0100886 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100850:	89 c2                	mov    %eax,%edx
c0100852:	89 d0                	mov    %edx,%eax
c0100854:	01 c0                	add    %eax,%eax
c0100856:	01 d0                	add    %edx,%eax
c0100858:	c1 e0 02             	shl    $0x2,%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100866:	3c 64                	cmp    $0x64,%al
c0100868:	75 b3                	jne    c010081d <debuginfo_eip+0x229>
c010086a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010086d:	89 c2                	mov    %eax,%edx
c010086f:	89 d0                	mov    %edx,%eax
c0100871:	01 c0                	add    %eax,%eax
c0100873:	01 d0                	add    %edx,%eax
c0100875:	c1 e0 02             	shl    $0x2,%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010087d:	01 d0                	add    %edx,%eax
c010087f:	8b 40 08             	mov    0x8(%eax),%eax
c0100882:	85 c0                	test   %eax,%eax
c0100884:	74 97                	je     c010081d <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100886:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010088c:	39 c2                	cmp    %eax,%edx
c010088e:	7c 46                	jl     c01008d6 <debuginfo_eip+0x2e2>
c0100890:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100893:	89 c2                	mov    %eax,%edx
c0100895:	89 d0                	mov    %edx,%eax
c0100897:	01 c0                	add    %eax,%eax
c0100899:	01 d0                	add    %edx,%eax
c010089b:	c1 e0 02             	shl    $0x2,%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a3:	01 d0                	add    %edx,%eax
c01008a5:	8b 10                	mov    (%eax),%edx
c01008a7:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008ad:	29 c1                	sub    %eax,%ecx
c01008af:	89 c8                	mov    %ecx,%eax
c01008b1:	39 c2                	cmp    %eax,%edx
c01008b3:	73 21                	jae    c01008d6 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b8:	89 c2                	mov    %eax,%edx
c01008ba:	89 d0                	mov    %edx,%eax
c01008bc:	01 c0                	add    %eax,%eax
c01008be:	01 d0                	add    %edx,%eax
c01008c0:	c1 e0 02             	shl    $0x2,%eax
c01008c3:	89 c2                	mov    %eax,%edx
c01008c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c8:	01 d0                	add    %edx,%eax
c01008ca:	8b 10                	mov    (%eax),%edx
c01008cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008cf:	01 c2                	add    %eax,%edx
c01008d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008d4:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008d6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008dc:	39 c2                	cmp    %eax,%edx
c01008de:	7d 4a                	jge    c010092a <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c01008e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008e3:	83 c0 01             	add    $0x1,%eax
c01008e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008e9:	eb 18                	jmp    c0100903 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008ee:	8b 40 14             	mov    0x14(%eax),%eax
c01008f1:	8d 50 01             	lea    0x1(%eax),%edx
c01008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f7:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c01008fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008fd:	83 c0 01             	add    $0x1,%eax
c0100900:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100903:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100906:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100909:	39 c2                	cmp    %eax,%edx
c010090b:	7d 1d                	jge    c010092a <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010090d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100910:	89 c2                	mov    %eax,%edx
c0100912:	89 d0                	mov    %edx,%eax
c0100914:	01 c0                	add    %eax,%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	c1 e0 02             	shl    $0x2,%eax
c010091b:	89 c2                	mov    %eax,%edx
c010091d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100920:	01 d0                	add    %edx,%eax
c0100922:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100926:	3c a0                	cmp    $0xa0,%al
c0100928:	74 c1                	je     c01008eb <debuginfo_eip+0x2f7>
        }
    }
    return 0;
c010092a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010092f:	c9                   	leave  
c0100930:	c3                   	ret    

c0100931 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100931:	55                   	push   %ebp
c0100932:	89 e5                	mov    %esp,%ebp
c0100934:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100937:	c7 04 24 b2 5c 10 c0 	movl   $0xc0105cb2,(%esp)
c010093e:	e8 48 f9 ff ff       	call   c010028b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100943:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c010094a:	c0 
c010094b:	c7 04 24 cb 5c 10 c0 	movl   $0xc0105ccb,(%esp)
c0100952:	e8 34 f9 ff ff       	call   c010028b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100957:	c7 44 24 04 a2 5b 10 	movl   $0xc0105ba2,0x4(%esp)
c010095e:	c0 
c010095f:	c7 04 24 e3 5c 10 c0 	movl   $0xc0105ce3,(%esp)
c0100966:	e8 20 f9 ff ff       	call   c010028b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c010096b:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c0100972:	c0 
c0100973:	c7 04 24 fb 5c 10 c0 	movl   $0xc0105cfb,(%esp)
c010097a:	e8 0c f9 ff ff       	call   c010028b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c010097f:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c0100986:	c0 
c0100987:	c7 04 24 13 5d 10 c0 	movl   $0xc0105d13,(%esp)
c010098e:	e8 f8 f8 ff ff       	call   c010028b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100993:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0100998:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c010099e:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009a3:	29 c2                	sub    %eax,%edx
c01009a5:	89 d0                	mov    %edx,%eax
c01009a7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ad:	85 c0                	test   %eax,%eax
c01009af:	0f 48 c2             	cmovs  %edx,%eax
c01009b2:	c1 f8 0a             	sar    $0xa,%eax
c01009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b9:	c7 04 24 2c 5d 10 c0 	movl   $0xc0105d2c,(%esp)
c01009c0:	e8 c6 f8 ff ff       	call   c010028b <cprintf>
}
c01009c5:	c9                   	leave  
c01009c6:	c3                   	ret    

c01009c7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009c7:	55                   	push   %ebp
c01009c8:	89 e5                	mov    %esp,%ebp
c01009ca:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d0:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01009da:	89 04 24             	mov    %eax,(%esp)
c01009dd:	e8 12 fc ff ff       	call   c01005f4 <debuginfo_eip>
c01009e2:	85 c0                	test   %eax,%eax
c01009e4:	74 15                	je     c01009fb <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 56 5d 10 c0 	movl   $0xc0105d56,(%esp)
c01009f4:	e8 92 f8 ff ff       	call   c010028b <cprintf>
c01009f9:	eb 6d                	jmp    c0100a68 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a02:	eb 1c                	jmp    c0100a20 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0a:	01 d0                	add    %edx,%eax
c0100a0c:	0f b6 00             	movzbl (%eax),%eax
c0100a0f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a18:	01 ca                	add    %ecx,%edx
c0100a1a:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a26:	7f dc                	jg     c0100a04 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
c0100a28:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a31:	01 d0                	add    %edx,%eax
c0100a33:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a39:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a3c:	89 d1                	mov    %edx,%ecx
c0100a3e:	29 c1                	sub    %eax,%ecx
c0100a40:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a43:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a46:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a4a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a50:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a54:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5c:	c7 04 24 72 5d 10 c0 	movl   $0xc0105d72,(%esp)
c0100a63:	e8 23 f8 ff ff       	call   c010028b <cprintf>
    }
}
c0100a68:	c9                   	leave  
c0100a69:	c3                   	ret    

c0100a6a <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a6a:	55                   	push   %ebp
c0100a6b:	89 e5                	mov    %esp,%ebp
c0100a6d:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a70:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a79:	c9                   	leave  
c0100a7a:	c3                   	ret    

c0100a7b <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a7b:	55                   	push   %ebp
c0100a7c:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a7e:	5d                   	pop    %ebp
c0100a7f:	c3                   	ret    

c0100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a80:	55                   	push   %ebp
c0100a81:	89 e5                	mov    %esp,%ebp
c0100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8d:	eb 0c                	jmp    c0100a9b <parse+0x1b>
            *buf ++ = '\0';
c0100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a92:	8d 50 01             	lea    0x1(%eax),%edx
c0100a95:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a98:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9e:	0f b6 00             	movzbl (%eax),%eax
c0100aa1:	84 c0                	test   %al,%al
c0100aa3:	74 1d                	je     c0100ac2 <parse+0x42>
c0100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa8:	0f b6 00             	movzbl (%eax),%eax
c0100aab:	0f be c0             	movsbl %al,%eax
c0100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab2:	c7 04 24 04 5e 10 c0 	movl   $0xc0105e04,(%esp)
c0100ab9:	e8 1b 47 00 00       	call   c01051d9 <strchr>
c0100abe:	85 c0                	test   %eax,%eax
c0100ac0:	75 cd                	jne    c0100a8f <parse+0xf>
        }
        if (*buf == '\0') {
c0100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac5:	0f b6 00             	movzbl (%eax),%eax
c0100ac8:	84 c0                	test   %al,%al
c0100aca:	75 02                	jne    c0100ace <parse+0x4e>
            break;
c0100acc:	eb 67                	jmp    c0100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad2:	75 14                	jne    c0100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adb:	00 
c0100adc:	c7 04 24 09 5e 10 c0 	movl   $0xc0105e09,(%esp)
c0100ae3:	e8 a3 f7 ff ff       	call   c010028b <cprintf>
        }
        argv[argc ++] = buf;
c0100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aeb:	8d 50 01             	lea    0x1(%eax),%edx
c0100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afb:	01 c2                	add    %eax,%edx
c0100afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b02:	eb 04                	jmp    c0100b08 <parse+0x88>
            buf ++;
c0100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 1d                	je     c0100b2f <parse+0xaf>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1f:	c7 04 24 04 5e 10 c0 	movl   $0xc0105e04,(%esp)
c0100b26:	e8 ae 46 00 00       	call   c01051d9 <strchr>
c0100b2b:	85 c0                	test   %eax,%eax
c0100b2d:	74 d5                	je     c0100b04 <parse+0x84>
        }
    }
c0100b2f:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b30:	e9 66 ff ff ff       	jmp    c0100a9b <parse+0x1b>
    return argc;
c0100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b38:	c9                   	leave  
c0100b39:	c3                   	ret    

c0100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3a:	55                   	push   %ebp
c0100b3b:	89 e5                	mov    %esp,%ebp
c0100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4a:	89 04 24             	mov    %eax,(%esp)
c0100b4d:	e8 2e ff ff ff       	call   c0100a80 <parse>
c0100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b59:	75 0a                	jne    c0100b65 <runcmd+0x2b>
        return 0;
c0100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b60:	e9 85 00 00 00       	jmp    c0100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6c:	eb 5c                	jmp    c0100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b74:	89 d0                	mov    %edx,%eax
c0100b76:	01 c0                	add    %eax,%eax
c0100b78:	01 d0                	add    %edx,%eax
c0100b7a:	c1 e0 02             	shl    $0x2,%eax
c0100b7d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b82:	8b 00                	mov    (%eax),%eax
c0100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b88:	89 04 24             	mov    %eax,(%esp)
c0100b8b:	e8 aa 45 00 00       	call   c010513a <strcmp>
c0100b90:	85 c0                	test   %eax,%eax
c0100b92:	75 32                	jne    c0100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b97:	89 d0                	mov    %edx,%eax
c0100b99:	01 c0                	add    %eax,%eax
c0100b9b:	01 d0                	add    %edx,%eax
c0100b9d:	c1 e0 02             	shl    $0x2,%eax
c0100ba0:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba5:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb8:	83 c2 04             	add    $0x4,%edx
c0100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbf:	89 0c 24             	mov    %ecx,(%esp)
c0100bc2:	ff d0                	call   *%eax
c0100bc4:	eb 24                	jmp    c0100bea <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcd:	83 f8 02             	cmp    $0x2,%eax
c0100bd0:	76 9c                	jbe    c0100b6e <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd9:	c7 04 24 27 5e 10 c0 	movl   $0xc0105e27,(%esp)
c0100be0:	e8 a6 f6 ff ff       	call   c010028b <cprintf>
    return 0;
c0100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bea:	c9                   	leave  
c0100beb:	c3                   	ret    

c0100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bec:	55                   	push   %ebp
c0100bed:	89 e5                	mov    %esp,%ebp
c0100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf2:	c7 04 24 40 5e 10 c0 	movl   $0xc0105e40,(%esp)
c0100bf9:	e8 8d f6 ff ff       	call   c010028b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfe:	c7 04 24 68 5e 10 c0 	movl   $0xc0105e68,(%esp)
c0100c05:	e8 81 f6 ff ff       	call   c010028b <cprintf>

    if (tf != NULL) {
c0100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0e:	74 0b                	je     c0100c1b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	89 04 24             	mov    %eax,(%esp)
c0100c16:	e8 08 0c 00 00       	call   c0101823 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1b:	c7 04 24 8d 5e 10 c0 	movl   $0xc0105e8d,(%esp)
c0100c22:	e8 05 f7 ff ff       	call   c010032c <readline>
c0100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2e:	74 18                	je     c0100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3a:	89 04 24             	mov    %eax,(%esp)
c0100c3d:	e8 f8 fe ff ff       	call   c0100b3a <runcmd>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	79 02                	jns    c0100c48 <kmonitor+0x5c>
                break;
c0100c46:	eb 02                	jmp    c0100c4a <kmonitor+0x5e>
            }
        }
    }
c0100c48:	eb d1                	jmp    c0100c1b <kmonitor+0x2f>
}
c0100c4a:	c9                   	leave  
c0100c4b:	c3                   	ret    

c0100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4c:	55                   	push   %ebp
c0100c4d:	89 e5                	mov    %esp,%ebp
c0100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c59:	eb 3f                	jmp    c0100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c80:	8b 00                	mov    (%eax),%eax
c0100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8a:	c7 04 24 91 5e 10 c0 	movl   $0xc0105e91,(%esp)
c0100c91:	e8 f5 f5 ff ff       	call   c010028b <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9d:	83 f8 02             	cmp    $0x2,%eax
c0100ca0:	76 b9                	jbe    c0100c5b <mon_help+0xf>
    }
    return 0;
c0100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca7:	c9                   	leave  
c0100ca8:	c3                   	ret    

c0100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca9:	55                   	push   %ebp
c0100caa:	89 e5                	mov    %esp,%ebp
c0100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100caf:	e8 7d fc ff ff       	call   c0100931 <print_kerninfo>
    return 0;
c0100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb9:	c9                   	leave  
c0100cba:	c3                   	ret    

c0100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbb:	55                   	push   %ebp
c0100cbc:	89 e5                	mov    %esp,%ebp
c0100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc1:	e8 b5 fd ff ff       	call   c0100a7b <print_stackframe>
    return 0;
c0100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
c0100cd0:	83 ec 28             	sub    $0x28,%esp
c0100cd3:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100cd9:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100cdd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100ce1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ce5:	ee                   	out    %al,(%dx)
c0100ce6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100cec:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100cf0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100cf4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100cf8:	ee                   	out    %al,(%dx)
c0100cf9:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100cff:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100d03:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d07:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d0b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d0c:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100d13:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d16:	c7 04 24 9a 5e 10 c0 	movl   $0xc0105e9a,(%esp)
c0100d1d:	e8 69 f5 ff ff       	call   c010028b <cprintf>
    pic_enable(IRQ_TIMER);
c0100d22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d29:	e8 18 09 00 00       	call   c0101646 <pic_enable>
}
c0100d2e:	c9                   	leave  
c0100d2f:	c3                   	ret    

c0100d30 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d30:	55                   	push   %ebp
c0100d31:	89 e5                	mov    %esp,%ebp
c0100d33:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d36:	9c                   	pushf  
c0100d37:	58                   	pop    %eax
c0100d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d3e:	25 00 02 00 00       	and    $0x200,%eax
c0100d43:	85 c0                	test   %eax,%eax
c0100d45:	74 0c                	je     c0100d53 <__intr_save+0x23>
        intr_disable();
c0100d47:	e8 69 0a 00 00       	call   c01017b5 <intr_disable>
        return 1;
c0100d4c:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d51:	eb 05                	jmp    c0100d58 <__intr_save+0x28>
    }
    return 0;
c0100d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d58:	c9                   	leave  
c0100d59:	c3                   	ret    

c0100d5a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d5a:	55                   	push   %ebp
c0100d5b:	89 e5                	mov    %esp,%ebp
c0100d5d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d64:	74 05                	je     c0100d6b <__intr_restore+0x11>
        intr_enable();
c0100d66:	e8 44 0a 00 00       	call   c01017af <intr_enable>
    }
}
c0100d6b:	c9                   	leave  
c0100d6c:	c3                   	ret    

c0100d6d <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d6d:	55                   	push   %ebp
c0100d6e:	89 e5                	mov    %esp,%ebp
c0100d70:	83 ec 10             	sub    $0x10,%esp
c0100d73:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d79:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100d7d:	89 c2                	mov    %eax,%edx
c0100d7f:	ec                   	in     (%dx),%al
c0100d80:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100d83:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d89:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d8d:	89 c2                	mov    %eax,%edx
c0100d8f:	ec                   	in     (%dx),%al
c0100d90:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100d93:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100d99:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100d9d:	89 c2                	mov    %eax,%edx
c0100d9f:	ec                   	in     (%dx),%al
c0100da0:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100da3:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100da9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100dad:	89 c2                	mov    %eax,%edx
c0100daf:	ec                   	in     (%dx),%al
c0100db0:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100db3:	c9                   	leave  
c0100db4:	c3                   	ret    

c0100db5 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100db5:	55                   	push   %ebp
c0100db6:	89 e5                	mov    %esp,%ebp
c0100db8:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100dbb:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100dc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dc5:	0f b7 00             	movzwl (%eax),%eax
c0100dc8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dcf:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd7:	0f b7 00             	movzwl (%eax),%eax
c0100dda:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100dde:	74 12                	je     c0100df2 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100de0:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100de7:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100dee:	b4 03 
c0100df0:	eb 13                	jmp    c0100e05 <cga_init+0x50>
    } else {
        *cp = was;
c0100df2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100df5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100df9:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100dfc:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e03:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e05:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e0c:	0f b7 c0             	movzwl %ax,%eax
c0100e0f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100e13:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e17:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e1b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e1f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100e20:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e27:	83 c0 01             	add    $0x1,%eax
c0100e2a:	0f b7 c0             	movzwl %ax,%eax
c0100e2d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e31:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100e35:	89 c2                	mov    %eax,%edx
c0100e37:	ec                   	in     (%dx),%al
c0100e38:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100e3b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e3f:	0f b6 c0             	movzbl %al,%eax
c0100e42:	c1 e0 08             	shl    $0x8,%eax
c0100e45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e48:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e4f:	0f b7 c0             	movzwl %ax,%eax
c0100e52:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100e56:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e5a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100e5e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e62:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e63:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100e6a:	83 c0 01             	add    $0x1,%eax
c0100e6d:	0f b7 c0             	movzwl %ax,%eax
c0100e70:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e74:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100e78:	89 c2                	mov    %eax,%edx
c0100e7a:	ec                   	in     (%dx),%al
c0100e7b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100e7e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100e82:	0f b6 c0             	movzbl %al,%eax
c0100e85:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e93:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100e99:	c9                   	leave  
c0100e9a:	c3                   	ret    

c0100e9b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100e9b:	55                   	push   %ebp
c0100e9c:	89 e5                	mov    %esp,%ebp
c0100e9e:	83 ec 48             	sub    $0x48,%esp
c0100ea1:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100ea7:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100eaf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100eb3:	ee                   	out    %al,(%dx)
c0100eb4:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100eba:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100ebe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ec2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ec6:	ee                   	out    %al,(%dx)
c0100ec7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100ecd:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100ed1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ed5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ed9:	ee                   	out    %al,(%dx)
c0100eda:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100ee0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100ee4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ee8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100eec:	ee                   	out    %al,(%dx)
c0100eed:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100ef3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100ef7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100efb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100eff:	ee                   	out    %al,(%dx)
c0100f00:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100f06:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100f0a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f0e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f12:	ee                   	out    %al,(%dx)
c0100f13:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f19:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100f1d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f21:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f25:	ee                   	out    %al,(%dx)
c0100f26:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100f30:	89 c2                	mov    %eax,%edx
c0100f32:	ec                   	in     (%dx),%al
c0100f33:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100f36:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f3a:	3c ff                	cmp    $0xff,%al
c0100f3c:	0f 95 c0             	setne  %al
c0100f3f:	0f b6 c0             	movzbl %al,%eax
c0100f42:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100f47:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f4d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100f51:	89 c2                	mov    %eax,%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100f57:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100f5d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f67:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0100f6c:	85 c0                	test   %eax,%eax
c0100f6e:	74 0c                	je     c0100f7c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0100f70:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100f77:	e8 ca 06 00 00       	call   c0101646 <pic_enable>
    }
}
c0100f7c:	c9                   	leave  
c0100f7d:	c3                   	ret    

c0100f7e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f7e:	55                   	push   %ebp
c0100f7f:	89 e5                	mov    %esp,%ebp
c0100f81:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f8b:	eb 09                	jmp    c0100f96 <lpt_putc_sub+0x18>
        delay();
c0100f8d:	e8 db fd ff ff       	call   c0100d6d <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f92:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100f96:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100f9c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100fa0:	89 c2                	mov    %eax,%edx
c0100fa2:	ec                   	in     (%dx),%al
c0100fa3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100fa6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100faa:	84 c0                	test   %al,%al
c0100fac:	78 09                	js     c0100fb7 <lpt_putc_sub+0x39>
c0100fae:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100fb5:	7e d6                	jle    c0100f8d <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0100fb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fba:	0f b6 c0             	movzbl %al,%eax
c0100fbd:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0100fc3:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fca:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fce:	ee                   	out    %al,(%dx)
c0100fcf:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0100fd5:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100fd9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fdd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fe1:	ee                   	out    %al,(%dx)
c0100fe2:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0100fe8:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0100fec:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ff0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ff4:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0100ff5:	c9                   	leave  
c0100ff6:	c3                   	ret    

c0100ff7 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0100ff7:	55                   	push   %ebp
c0100ff8:	89 e5                	mov    %esp,%ebp
c0100ffa:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0100ffd:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101001:	74 0d                	je     c0101010 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101003:	8b 45 08             	mov    0x8(%ebp),%eax
c0101006:	89 04 24             	mov    %eax,(%esp)
c0101009:	e8 70 ff ff ff       	call   c0100f7e <lpt_putc_sub>
c010100e:	eb 24                	jmp    c0101034 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101010:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101017:	e8 62 ff ff ff       	call   c0100f7e <lpt_putc_sub>
        lpt_putc_sub(' ');
c010101c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101023:	e8 56 ff ff ff       	call   c0100f7e <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101028:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010102f:	e8 4a ff ff ff       	call   c0100f7e <lpt_putc_sub>
    }
}
c0101034:	c9                   	leave  
c0101035:	c3                   	ret    

c0101036 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101036:	55                   	push   %ebp
c0101037:	89 e5                	mov    %esp,%ebp
c0101039:	53                   	push   %ebx
c010103a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010103d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101040:	b0 00                	mov    $0x0,%al
c0101042:	85 c0                	test   %eax,%eax
c0101044:	75 07                	jne    c010104d <cga_putc+0x17>
        c |= 0x0700;
c0101046:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010104d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101050:	0f b6 c0             	movzbl %al,%eax
c0101053:	83 f8 0a             	cmp    $0xa,%eax
c0101056:	74 4c                	je     c01010a4 <cga_putc+0x6e>
c0101058:	83 f8 0d             	cmp    $0xd,%eax
c010105b:	74 57                	je     c01010b4 <cga_putc+0x7e>
c010105d:	83 f8 08             	cmp    $0x8,%eax
c0101060:	0f 85 88 00 00 00    	jne    c01010ee <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101066:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010106d:	66 85 c0             	test   %ax,%ax
c0101070:	74 30                	je     c01010a2 <cga_putc+0x6c>
            crt_pos --;
c0101072:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101079:	83 e8 01             	sub    $0x1,%eax
c010107c:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101082:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101087:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010108e:	0f b7 d2             	movzwl %dx,%edx
c0101091:	01 d2                	add    %edx,%edx
c0101093:	01 c2                	add    %eax,%edx
c0101095:	8b 45 08             	mov    0x8(%ebp),%eax
c0101098:	b0 00                	mov    $0x0,%al
c010109a:	83 c8 20             	or     $0x20,%eax
c010109d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01010a0:	eb 72                	jmp    c0101114 <cga_putc+0xde>
c01010a2:	eb 70                	jmp    c0101114 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c01010a4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010ab:	83 c0 50             	add    $0x50,%eax
c01010ae:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01010b4:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c01010bb:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c01010c2:	0f b7 c1             	movzwl %cx,%eax
c01010c5:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01010cb:	c1 e8 10             	shr    $0x10,%eax
c01010ce:	89 c2                	mov    %eax,%edx
c01010d0:	66 c1 ea 06          	shr    $0x6,%dx
c01010d4:	89 d0                	mov    %edx,%eax
c01010d6:	c1 e0 02             	shl    $0x2,%eax
c01010d9:	01 d0                	add    %edx,%eax
c01010db:	c1 e0 04             	shl    $0x4,%eax
c01010de:	29 c1                	sub    %eax,%ecx
c01010e0:	89 ca                	mov    %ecx,%edx
c01010e2:	89 d8                	mov    %ebx,%eax
c01010e4:	29 d0                	sub    %edx,%eax
c01010e6:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01010ec:	eb 26                	jmp    c0101114 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01010ee:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01010f4:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01010fb:	8d 50 01             	lea    0x1(%eax),%edx
c01010fe:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c0101105:	0f b7 c0             	movzwl %ax,%eax
c0101108:	01 c0                	add    %eax,%eax
c010110a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c010110d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101110:	66 89 02             	mov    %ax,(%edx)
        break;
c0101113:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101114:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010111b:	66 3d cf 07          	cmp    $0x7cf,%ax
c010111f:	76 5b                	jbe    c010117c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101121:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101126:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010112c:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101131:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101138:	00 
c0101139:	89 54 24 04          	mov    %edx,0x4(%esp)
c010113d:	89 04 24             	mov    %eax,(%esp)
c0101140:	e8 92 42 00 00       	call   c01053d7 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101145:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010114c:	eb 15                	jmp    c0101163 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010114e:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101153:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101156:	01 d2                	add    %edx,%edx
c0101158:	01 d0                	add    %edx,%eax
c010115a:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010115f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101163:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010116a:	7e e2                	jle    c010114e <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
c010116c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101173:	83 e8 50             	sub    $0x50,%eax
c0101176:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010117c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101183:	0f b7 c0             	movzwl %ax,%eax
c0101186:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010118a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010118e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101192:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101196:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101197:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010119e:	66 c1 e8 08          	shr    $0x8,%ax
c01011a2:	0f b6 c0             	movzbl %al,%eax
c01011a5:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01011ac:	83 c2 01             	add    $0x1,%edx
c01011af:	0f b7 d2             	movzwl %dx,%edx
c01011b2:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01011b6:	88 45 ed             	mov    %al,-0x13(%ebp)
c01011b9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011bd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011c1:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01011c2:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c01011c9:	0f b7 c0             	movzwl %ax,%eax
c01011cc:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01011d0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01011d4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01011d8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01011dc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01011dd:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011e4:	0f b6 c0             	movzbl %al,%eax
c01011e7:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01011ee:	83 c2 01             	add    $0x1,%edx
c01011f1:	0f b7 d2             	movzwl %dx,%edx
c01011f4:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01011f8:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01011fb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01011ff:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101203:	ee                   	out    %al,(%dx)
}
c0101204:	83 c4 34             	add    $0x34,%esp
c0101207:	5b                   	pop    %ebx
c0101208:	5d                   	pop    %ebp
c0101209:	c3                   	ret    

c010120a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c010120a:	55                   	push   %ebp
c010120b:	89 e5                	mov    %esp,%ebp
c010120d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101210:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101217:	eb 09                	jmp    c0101222 <serial_putc_sub+0x18>
        delay();
c0101219:	e8 4f fb ff ff       	call   c0100d6d <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010121e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101222:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101228:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010122c:	89 c2                	mov    %eax,%edx
c010122e:	ec                   	in     (%dx),%al
c010122f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101232:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101236:	0f b6 c0             	movzbl %al,%eax
c0101239:	83 e0 20             	and    $0x20,%eax
c010123c:	85 c0                	test   %eax,%eax
c010123e:	75 09                	jne    c0101249 <serial_putc_sub+0x3f>
c0101240:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101247:	7e d0                	jle    c0101219 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101249:	8b 45 08             	mov    0x8(%ebp),%eax
c010124c:	0f b6 c0             	movzbl %al,%eax
c010124f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101255:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101258:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010125c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101260:	ee                   	out    %al,(%dx)
}
c0101261:	c9                   	leave  
c0101262:	c3                   	ret    

c0101263 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101263:	55                   	push   %ebp
c0101264:	89 e5                	mov    %esp,%ebp
c0101266:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101269:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010126d:	74 0d                	je     c010127c <serial_putc+0x19>
        serial_putc_sub(c);
c010126f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101272:	89 04 24             	mov    %eax,(%esp)
c0101275:	e8 90 ff ff ff       	call   c010120a <serial_putc_sub>
c010127a:	eb 24                	jmp    c01012a0 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010127c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101283:	e8 82 ff ff ff       	call   c010120a <serial_putc_sub>
        serial_putc_sub(' ');
c0101288:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010128f:	e8 76 ff ff ff       	call   c010120a <serial_putc_sub>
        serial_putc_sub('\b');
c0101294:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010129b:	e8 6a ff ff ff       	call   c010120a <serial_putc_sub>
    }
}
c01012a0:	c9                   	leave  
c01012a1:	c3                   	ret    

c01012a2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01012a2:	55                   	push   %ebp
c01012a3:	89 e5                	mov    %esp,%ebp
c01012a5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01012a8:	eb 33                	jmp    c01012dd <cons_intr+0x3b>
        if (c != 0) {
c01012aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012ae:	74 2d                	je     c01012dd <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01012b0:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01012b5:	8d 50 01             	lea    0x1(%eax),%edx
c01012b8:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c01012be:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012c1:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01012c7:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01012cc:	3d 00 02 00 00       	cmp    $0x200,%eax
c01012d1:	75 0a                	jne    c01012dd <cons_intr+0x3b>
                cons.wpos = 0;
c01012d3:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c01012da:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01012dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e0:	ff d0                	call   *%eax
c01012e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012e5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01012e9:	75 bf                	jne    c01012aa <cons_intr+0x8>
            }
        }
    }
}
c01012eb:	c9                   	leave  
c01012ec:	c3                   	ret    

c01012ed <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01012ed:	55                   	push   %ebp
c01012ee:	89 e5                	mov    %esp,%ebp
c01012f0:	83 ec 10             	sub    $0x10,%esp
c01012f3:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012fd:	89 c2                	mov    %eax,%edx
c01012ff:	ec                   	in     (%dx),%al
c0101300:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101303:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101307:	0f b6 c0             	movzbl %al,%eax
c010130a:	83 e0 01             	and    $0x1,%eax
c010130d:	85 c0                	test   %eax,%eax
c010130f:	75 07                	jne    c0101318 <serial_proc_data+0x2b>
        return -1;
c0101311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101316:	eb 2a                	jmp    c0101342 <serial_proc_data+0x55>
c0101318:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010131e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101322:	89 c2                	mov    %eax,%edx
c0101324:	ec                   	in     (%dx),%al
c0101325:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101328:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010132c:	0f b6 c0             	movzbl %al,%eax
c010132f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101332:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101336:	75 07                	jne    c010133f <serial_proc_data+0x52>
        c = '\b';
c0101338:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101342:	c9                   	leave  
c0101343:	c3                   	ret    

c0101344 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101344:	55                   	push   %ebp
c0101345:	89 e5                	mov    %esp,%ebp
c0101347:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010134a:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010134f:	85 c0                	test   %eax,%eax
c0101351:	74 0c                	je     c010135f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101353:	c7 04 24 ed 12 10 c0 	movl   $0xc01012ed,(%esp)
c010135a:	e8 43 ff ff ff       	call   c01012a2 <cons_intr>
    }
}
c010135f:	c9                   	leave  
c0101360:	c3                   	ret    

c0101361 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101361:	55                   	push   %ebp
c0101362:	89 e5                	mov    %esp,%ebp
c0101364:	83 ec 38             	sub    $0x38,%esp
c0101367:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010136d:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101371:	89 c2                	mov    %eax,%edx
c0101373:	ec                   	in     (%dx),%al
c0101374:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101377:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010137b:	0f b6 c0             	movzbl %al,%eax
c010137e:	83 e0 01             	and    $0x1,%eax
c0101381:	85 c0                	test   %eax,%eax
c0101383:	75 0a                	jne    c010138f <kbd_proc_data+0x2e>
        return -1;
c0101385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010138a:	e9 59 01 00 00       	jmp    c01014e8 <kbd_proc_data+0x187>
c010138f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101395:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101399:	89 c2                	mov    %eax,%edx
c010139b:	ec                   	in     (%dx),%al
c010139c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010139f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01013a3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01013a6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01013aa:	75 17                	jne    c01013c3 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c01013ac:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013b1:	83 c8 40             	or     $0x40,%eax
c01013b4:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01013b9:	b8 00 00 00 00       	mov    $0x0,%eax
c01013be:	e9 25 01 00 00       	jmp    c01014e8 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01013c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013c7:	84 c0                	test   %al,%al
c01013c9:	79 47                	jns    c0101412 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01013cb:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01013d0:	83 e0 40             	and    $0x40,%eax
c01013d3:	85 c0                	test   %eax,%eax
c01013d5:	75 09                	jne    c01013e0 <kbd_proc_data+0x7f>
c01013d7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013db:	83 e0 7f             	and    $0x7f,%eax
c01013de:	eb 04                	jmp    c01013e4 <kbd_proc_data+0x83>
c01013e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013e4:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01013e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013eb:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01013f2:	83 c8 40             	or     $0x40,%eax
c01013f5:	0f b6 c0             	movzbl %al,%eax
c01013f8:	f7 d0                	not    %eax
c01013fa:	89 c2                	mov    %eax,%edx
c01013fc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101401:	21 d0                	and    %edx,%eax
c0101403:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101408:	b8 00 00 00 00       	mov    $0x0,%eax
c010140d:	e9 d6 00 00 00       	jmp    c01014e8 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c0101412:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101417:	83 e0 40             	and    $0x40,%eax
c010141a:	85 c0                	test   %eax,%eax
c010141c:	74 11                	je     c010142f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010141e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101422:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101427:	83 e0 bf             	and    $0xffffffbf,%eax
c010142a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c010142f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101433:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c010143a:	0f b6 d0             	movzbl %al,%edx
c010143d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101442:	09 d0                	or     %edx,%eax
c0101444:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101449:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010144d:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101454:	0f b6 d0             	movzbl %al,%edx
c0101457:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010145c:	31 d0                	xor    %edx,%eax
c010145e:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101463:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101468:	83 e0 03             	and    $0x3,%eax
c010146b:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101472:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101476:	01 d0                	add    %edx,%eax
c0101478:	0f b6 00             	movzbl (%eax),%eax
c010147b:	0f b6 c0             	movzbl %al,%eax
c010147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101481:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101486:	83 e0 08             	and    $0x8,%eax
c0101489:	85 c0                	test   %eax,%eax
c010148b:	74 22                	je     c01014af <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010148d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101491:	7e 0c                	jle    c010149f <kbd_proc_data+0x13e>
c0101493:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101497:	7f 06                	jg     c010149f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101499:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010149d:	eb 10                	jmp    c01014af <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010149f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01014a3:	7e 0a                	jle    c01014af <kbd_proc_data+0x14e>
c01014a5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01014a9:	7f 04                	jg     c01014af <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c01014ab:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01014af:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b4:	f7 d0                	not    %eax
c01014b6:	83 e0 06             	and    $0x6,%eax
c01014b9:	85 c0                	test   %eax,%eax
c01014bb:	75 28                	jne    c01014e5 <kbd_proc_data+0x184>
c01014bd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01014c4:	75 1f                	jne    c01014e5 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01014c6:	c7 04 24 b5 5e 10 c0 	movl   $0xc0105eb5,(%esp)
c01014cd:	e8 b9 ed ff ff       	call   c010028b <cprintf>
c01014d2:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01014d8:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014dc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01014e0:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01014e4:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01014e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01014e8:	c9                   	leave  
c01014e9:	c3                   	ret    

c01014ea <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01014ea:	55                   	push   %ebp
c01014eb:	89 e5                	mov    %esp,%ebp
c01014ed:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01014f0:	c7 04 24 61 13 10 c0 	movl   $0xc0101361,(%esp)
c01014f7:	e8 a6 fd ff ff       	call   c01012a2 <cons_intr>
}
c01014fc:	c9                   	leave  
c01014fd:	c3                   	ret    

c01014fe <kbd_init>:

static void
kbd_init(void) {
c01014fe:	55                   	push   %ebp
c01014ff:	89 e5                	mov    %esp,%ebp
c0101501:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101504:	e8 e1 ff ff ff       	call   c01014ea <kbd_intr>
    pic_enable(IRQ_KBD);
c0101509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101510:	e8 31 01 00 00       	call   c0101646 <pic_enable>
}
c0101515:	c9                   	leave  
c0101516:	c3                   	ret    

c0101517 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101517:	55                   	push   %ebp
c0101518:	89 e5                	mov    %esp,%ebp
c010151a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c010151d:	e8 93 f8 ff ff       	call   c0100db5 <cga_init>
    serial_init();
c0101522:	e8 74 f9 ff ff       	call   c0100e9b <serial_init>
    kbd_init();
c0101527:	e8 d2 ff ff ff       	call   c01014fe <kbd_init>
    if (!serial_exists) {
c010152c:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101531:	85 c0                	test   %eax,%eax
c0101533:	75 0c                	jne    c0101541 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101535:	c7 04 24 c1 5e 10 c0 	movl   $0xc0105ec1,(%esp)
c010153c:	e8 4a ed ff ff       	call   c010028b <cprintf>
    }
}
c0101541:	c9                   	leave  
c0101542:	c3                   	ret    

c0101543 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101543:	55                   	push   %ebp
c0101544:	89 e5                	mov    %esp,%ebp
c0101546:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101549:	e8 e2 f7 ff ff       	call   c0100d30 <__intr_save>
c010154e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101551:	8b 45 08             	mov    0x8(%ebp),%eax
c0101554:	89 04 24             	mov    %eax,(%esp)
c0101557:	e8 9b fa ff ff       	call   c0100ff7 <lpt_putc>
        cga_putc(c);
c010155c:	8b 45 08             	mov    0x8(%ebp),%eax
c010155f:	89 04 24             	mov    %eax,(%esp)
c0101562:	e8 cf fa ff ff       	call   c0101036 <cga_putc>
        serial_putc(c);
c0101567:	8b 45 08             	mov    0x8(%ebp),%eax
c010156a:	89 04 24             	mov    %eax,(%esp)
c010156d:	e8 f1 fc ff ff       	call   c0101263 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101572:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101575:	89 04 24             	mov    %eax,(%esp)
c0101578:	e8 dd f7 ff ff       	call   c0100d5a <__intr_restore>
}
c010157d:	c9                   	leave  
c010157e:	c3                   	ret    

c010157f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010157f:	55                   	push   %ebp
c0101580:	89 e5                	mov    %esp,%ebp
c0101582:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101585:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010158c:	e8 9f f7 ff ff       	call   c0100d30 <__intr_save>
c0101591:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101594:	e8 ab fd ff ff       	call   c0101344 <serial_intr>
        kbd_intr();
c0101599:	e8 4c ff ff ff       	call   c01014ea <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010159e:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c01015a4:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c01015a9:	39 c2                	cmp    %eax,%edx
c01015ab:	74 31                	je     c01015de <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01015ad:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01015b2:	8d 50 01             	lea    0x1(%eax),%edx
c01015b5:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c01015bb:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c01015c2:	0f b6 c0             	movzbl %al,%eax
c01015c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01015c8:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c01015cd:	3d 00 02 00 00       	cmp    $0x200,%eax
c01015d2:	75 0a                	jne    c01015de <cons_getc+0x5f>
                cons.rpos = 0;
c01015d4:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c01015db:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01015de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01015e1:	89 04 24             	mov    %eax,(%esp)
c01015e4:	e8 71 f7 ff ff       	call   c0100d5a <__intr_restore>
    return c;
c01015e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ec:	c9                   	leave  
c01015ed:	c3                   	ret    

c01015ee <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01015ee:	55                   	push   %ebp
c01015ef:	89 e5                	mov    %esp,%ebp
c01015f1:	83 ec 14             	sub    $0x14,%esp
c01015f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01015f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01015fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01015ff:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c0101605:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c010160a:	85 c0                	test   %eax,%eax
c010160c:	74 36                	je     c0101644 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c010160e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101612:	0f b6 c0             	movzbl %al,%eax
c0101615:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010161b:	88 45 fd             	mov    %al,-0x3(%ebp)
c010161e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101622:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101626:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101627:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010162b:	66 c1 e8 08          	shr    $0x8,%ax
c010162f:	0f b6 c0             	movzbl %al,%eax
c0101632:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101638:	88 45 f9             	mov    %al,-0x7(%ebp)
c010163b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010163f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101643:	ee                   	out    %al,(%dx)
    }
}
c0101644:	c9                   	leave  
c0101645:	c3                   	ret    

c0101646 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101646:	55                   	push   %ebp
c0101647:	89 e5                	mov    %esp,%ebp
c0101649:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010164c:	8b 45 08             	mov    0x8(%ebp),%eax
c010164f:	ba 01 00 00 00       	mov    $0x1,%edx
c0101654:	89 c1                	mov    %eax,%ecx
c0101656:	d3 e2                	shl    %cl,%edx
c0101658:	89 d0                	mov    %edx,%eax
c010165a:	f7 d0                	not    %eax
c010165c:	89 c2                	mov    %eax,%edx
c010165e:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101665:	21 d0                	and    %edx,%eax
c0101667:	0f b7 c0             	movzwl %ax,%eax
c010166a:	89 04 24             	mov    %eax,(%esp)
c010166d:	e8 7c ff ff ff       	call   c01015ee <pic_setmask>
}
c0101672:	c9                   	leave  
c0101673:	c3                   	ret    

c0101674 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101674:	55                   	push   %ebp
c0101675:	89 e5                	mov    %esp,%ebp
c0101677:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010167a:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101681:	00 00 00 
c0101684:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010168a:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010168e:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101692:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101696:	ee                   	out    %al,(%dx)
c0101697:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010169d:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01016a1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016a5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016a9:	ee                   	out    %al,(%dx)
c01016aa:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01016b0:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01016b4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01016b8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01016bc:	ee                   	out    %al,(%dx)
c01016bd:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01016c3:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01016c7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01016cb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01016cf:	ee                   	out    %al,(%dx)
c01016d0:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01016d6:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01016da:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01016de:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01016e2:	ee                   	out    %al,(%dx)
c01016e3:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01016e9:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01016ed:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01016f1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01016f5:	ee                   	out    %al,(%dx)
c01016f6:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01016fc:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101700:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101704:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101708:	ee                   	out    %al,(%dx)
c0101709:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010170f:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0101713:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101717:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010171b:	ee                   	out    %al,(%dx)
c010171c:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101722:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101726:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010172a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010172e:	ee                   	out    %al,(%dx)
c010172f:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101735:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101739:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010173d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101741:	ee                   	out    %al,(%dx)
c0101742:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101748:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010174c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101750:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101754:	ee                   	out    %al,(%dx)
c0101755:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010175b:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010175f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101763:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101767:	ee                   	out    %al,(%dx)
c0101768:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010176e:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101772:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101776:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010177a:	ee                   	out    %al,(%dx)
c010177b:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101781:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101785:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101789:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010178d:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010178e:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101795:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101799:	74 12                	je     c01017ad <pic_init+0x139>
        pic_setmask(irq_mask);
c010179b:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c01017a2:	0f b7 c0             	movzwl %ax,%eax
c01017a5:	89 04 24             	mov    %eax,(%esp)
c01017a8:	e8 41 fe ff ff       	call   c01015ee <pic_setmask>
    }
}
c01017ad:	c9                   	leave  
c01017ae:	c3                   	ret    

c01017af <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01017af:	55                   	push   %ebp
c01017b0:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c01017b2:	fb                   	sti    
    sti();
}
c01017b3:	5d                   	pop    %ebp
c01017b4:	c3                   	ret    

c01017b5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01017b5:	55                   	push   %ebp
c01017b6:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01017b8:	fa                   	cli    
    cli();
}
c01017b9:	5d                   	pop    %ebp
c01017ba:	c3                   	ret    

c01017bb <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01017bb:	55                   	push   %ebp
c01017bc:	89 e5                	mov    %esp,%ebp
c01017be:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01017c1:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01017c8:	00 
c01017c9:	c7 04 24 e0 5e 10 c0 	movl   $0xc0105ee0,(%esp)
c01017d0:	e8 b6 ea ff ff       	call   c010028b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01017d5:	c9                   	leave  
c01017d6:	c3                   	ret    

c01017d7 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01017d7:	55                   	push   %ebp
c01017d8:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c01017da:	5d                   	pop    %ebp
c01017db:	c3                   	ret    

c01017dc <trapname>:

static const char *
trapname(int trapno) {
c01017dc:	55                   	push   %ebp
c01017dd:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01017df:	8b 45 08             	mov    0x8(%ebp),%eax
c01017e2:	83 f8 13             	cmp    $0x13,%eax
c01017e5:	77 0c                	ja     c01017f3 <trapname+0x17>
        return excnames[trapno];
c01017e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01017ea:	8b 04 85 40 62 10 c0 	mov    -0x3fef9dc0(,%eax,4),%eax
c01017f1:	eb 18                	jmp    c010180b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01017f3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01017f7:	7e 0d                	jle    c0101806 <trapname+0x2a>
c01017f9:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01017fd:	7f 07                	jg     c0101806 <trapname+0x2a>
        return "Hardware Interrupt";
c01017ff:	b8 ea 5e 10 c0       	mov    $0xc0105eea,%eax
c0101804:	eb 05                	jmp    c010180b <trapname+0x2f>
    }
    return "(unknown trap)";
c0101806:	b8 fd 5e 10 c0       	mov    $0xc0105efd,%eax
}
c010180b:	5d                   	pop    %ebp
c010180c:	c3                   	ret    

c010180d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010180d:	55                   	push   %ebp
c010180e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101810:	8b 45 08             	mov    0x8(%ebp),%eax
c0101813:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101817:	66 83 f8 08          	cmp    $0x8,%ax
c010181b:	0f 94 c0             	sete   %al
c010181e:	0f b6 c0             	movzbl %al,%eax
}
c0101821:	5d                   	pop    %ebp
c0101822:	c3                   	ret    

c0101823 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101823:	55                   	push   %ebp
c0101824:	89 e5                	mov    %esp,%ebp
c0101826:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101829:	8b 45 08             	mov    0x8(%ebp),%eax
c010182c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101830:	c7 04 24 3e 5f 10 c0 	movl   $0xc0105f3e,(%esp)
c0101837:	e8 4f ea ff ff       	call   c010028b <cprintf>
    print_regs(&tf->tf_regs);
c010183c:	8b 45 08             	mov    0x8(%ebp),%eax
c010183f:	89 04 24             	mov    %eax,(%esp)
c0101842:	e8 a1 01 00 00       	call   c01019e8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101847:	8b 45 08             	mov    0x8(%ebp),%eax
c010184a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010184e:	0f b7 c0             	movzwl %ax,%eax
c0101851:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101855:	c7 04 24 4f 5f 10 c0 	movl   $0xc0105f4f,(%esp)
c010185c:	e8 2a ea ff ff       	call   c010028b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101861:	8b 45 08             	mov    0x8(%ebp),%eax
c0101864:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101868:	0f b7 c0             	movzwl %ax,%eax
c010186b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010186f:	c7 04 24 62 5f 10 c0 	movl   $0xc0105f62,(%esp)
c0101876:	e8 10 ea ff ff       	call   c010028b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010187b:	8b 45 08             	mov    0x8(%ebp),%eax
c010187e:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101882:	0f b7 c0             	movzwl %ax,%eax
c0101885:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101889:	c7 04 24 75 5f 10 c0 	movl   $0xc0105f75,(%esp)
c0101890:	e8 f6 e9 ff ff       	call   c010028b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101895:	8b 45 08             	mov    0x8(%ebp),%eax
c0101898:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010189c:	0f b7 c0             	movzwl %ax,%eax
c010189f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018a3:	c7 04 24 88 5f 10 c0 	movl   $0xc0105f88,(%esp)
c01018aa:	e8 dc e9 ff ff       	call   c010028b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01018af:	8b 45 08             	mov    0x8(%ebp),%eax
c01018b2:	8b 40 30             	mov    0x30(%eax),%eax
c01018b5:	89 04 24             	mov    %eax,(%esp)
c01018b8:	e8 1f ff ff ff       	call   c01017dc <trapname>
c01018bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01018c0:	8b 52 30             	mov    0x30(%edx),%edx
c01018c3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01018c7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01018cb:	c7 04 24 9b 5f 10 c0 	movl   $0xc0105f9b,(%esp)
c01018d2:	e8 b4 e9 ff ff       	call   c010028b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01018d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01018da:	8b 40 34             	mov    0x34(%eax),%eax
c01018dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018e1:	c7 04 24 ad 5f 10 c0 	movl   $0xc0105fad,(%esp)
c01018e8:	e8 9e e9 ff ff       	call   c010028b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01018ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01018f0:	8b 40 38             	mov    0x38(%eax),%eax
c01018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018f7:	c7 04 24 bc 5f 10 c0 	movl   $0xc0105fbc,(%esp)
c01018fe:	e8 88 e9 ff ff       	call   c010028b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101903:	8b 45 08             	mov    0x8(%ebp),%eax
c0101906:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010190a:	0f b7 c0             	movzwl %ax,%eax
c010190d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101911:	c7 04 24 cb 5f 10 c0 	movl   $0xc0105fcb,(%esp)
c0101918:	e8 6e e9 ff ff       	call   c010028b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010191d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101920:	8b 40 40             	mov    0x40(%eax),%eax
c0101923:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101927:	c7 04 24 de 5f 10 c0 	movl   $0xc0105fde,(%esp)
c010192e:	e8 58 e9 ff ff       	call   c010028b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101933:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010193a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101941:	eb 3e                	jmp    c0101981 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101943:	8b 45 08             	mov    0x8(%ebp),%eax
c0101946:	8b 50 40             	mov    0x40(%eax),%edx
c0101949:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010194c:	21 d0                	and    %edx,%eax
c010194e:	85 c0                	test   %eax,%eax
c0101950:	74 28                	je     c010197a <print_trapframe+0x157>
c0101952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101955:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c010195c:	85 c0                	test   %eax,%eax
c010195e:	74 1a                	je     c010197a <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101963:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c010196a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010196e:	c7 04 24 ed 5f 10 c0 	movl   $0xc0105fed,(%esp)
c0101975:	e8 11 e9 ff ff       	call   c010028b <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010197a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010197e:	d1 65 f0             	shll   -0x10(%ebp)
c0101981:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101984:	83 f8 17             	cmp    $0x17,%eax
c0101987:	76 ba                	jbe    c0101943 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101989:	8b 45 08             	mov    0x8(%ebp),%eax
c010198c:	8b 40 40             	mov    0x40(%eax),%eax
c010198f:	25 00 30 00 00       	and    $0x3000,%eax
c0101994:	c1 e8 0c             	shr    $0xc,%eax
c0101997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010199b:	c7 04 24 f1 5f 10 c0 	movl   $0xc0105ff1,(%esp)
c01019a2:	e8 e4 e8 ff ff       	call   c010028b <cprintf>

    if (!trap_in_kernel(tf)) {
c01019a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019aa:	89 04 24             	mov    %eax,(%esp)
c01019ad:	e8 5b fe ff ff       	call   c010180d <trap_in_kernel>
c01019b2:	85 c0                	test   %eax,%eax
c01019b4:	75 30                	jne    c01019e6 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01019b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b9:	8b 40 44             	mov    0x44(%eax),%eax
c01019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019c0:	c7 04 24 fa 5f 10 c0 	movl   $0xc0105ffa,(%esp)
c01019c7:	e8 bf e8 ff ff       	call   c010028b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01019cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019cf:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01019d3:	0f b7 c0             	movzwl %ax,%eax
c01019d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019da:	c7 04 24 09 60 10 c0 	movl   $0xc0106009,(%esp)
c01019e1:	e8 a5 e8 ff ff       	call   c010028b <cprintf>
    }
}
c01019e6:	c9                   	leave  
c01019e7:	c3                   	ret    

c01019e8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01019e8:	55                   	push   %ebp
c01019e9:	89 e5                	mov    %esp,%ebp
c01019eb:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01019ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f1:	8b 00                	mov    (%eax),%eax
c01019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019f7:	c7 04 24 1c 60 10 c0 	movl   $0xc010601c,(%esp)
c01019fe:	e8 88 e8 ff ff       	call   c010028b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a06:	8b 40 04             	mov    0x4(%eax),%eax
c0101a09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a0d:	c7 04 24 2b 60 10 c0 	movl   $0xc010602b,(%esp)
c0101a14:	e8 72 e8 ff ff       	call   c010028b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1c:	8b 40 08             	mov    0x8(%eax),%eax
c0101a1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a23:	c7 04 24 3a 60 10 c0 	movl   $0xc010603a,(%esp)
c0101a2a:	e8 5c e8 ff ff       	call   c010028b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a32:	8b 40 0c             	mov    0xc(%eax),%eax
c0101a35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a39:	c7 04 24 49 60 10 c0 	movl   $0xc0106049,(%esp)
c0101a40:	e8 46 e8 ff ff       	call   c010028b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101a45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a48:	8b 40 10             	mov    0x10(%eax),%eax
c0101a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a4f:	c7 04 24 58 60 10 c0 	movl   $0xc0106058,(%esp)
c0101a56:	e8 30 e8 ff ff       	call   c010028b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5e:	8b 40 14             	mov    0x14(%eax),%eax
c0101a61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a65:	c7 04 24 67 60 10 c0 	movl   $0xc0106067,(%esp)
c0101a6c:	e8 1a e8 ff ff       	call   c010028b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a74:	8b 40 18             	mov    0x18(%eax),%eax
c0101a77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a7b:	c7 04 24 76 60 10 c0 	movl   $0xc0106076,(%esp)
c0101a82:	e8 04 e8 ff ff       	call   c010028b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8a:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a91:	c7 04 24 85 60 10 c0 	movl   $0xc0106085,(%esp)
c0101a98:	e8 ee e7 ff ff       	call   c010028b <cprintf>
}
c0101a9d:	c9                   	leave  
c0101a9e:	c3                   	ret    

c0101a9f <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101a9f:	55                   	push   %ebp
c0101aa0:	89 e5                	mov    %esp,%ebp
c0101aa2:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa8:	8b 40 30             	mov    0x30(%eax),%eax
c0101aab:	83 f8 2f             	cmp    $0x2f,%eax
c0101aae:	77 1e                	ja     c0101ace <trap_dispatch+0x2f>
c0101ab0:	83 f8 2e             	cmp    $0x2e,%eax
c0101ab3:	0f 83 bf 00 00 00    	jae    c0101b78 <trap_dispatch+0xd9>
c0101ab9:	83 f8 21             	cmp    $0x21,%eax
c0101abc:	74 40                	je     c0101afe <trap_dispatch+0x5f>
c0101abe:	83 f8 24             	cmp    $0x24,%eax
c0101ac1:	74 15                	je     c0101ad8 <trap_dispatch+0x39>
c0101ac3:	83 f8 20             	cmp    $0x20,%eax
c0101ac6:	0f 84 af 00 00 00    	je     c0101b7b <trap_dispatch+0xdc>
c0101acc:	eb 72                	jmp    c0101b40 <trap_dispatch+0xa1>
c0101ace:	83 e8 78             	sub    $0x78,%eax
c0101ad1:	83 f8 01             	cmp    $0x1,%eax
c0101ad4:	77 6a                	ja     c0101b40 <trap_dispatch+0xa1>
c0101ad6:	eb 4c                	jmp    c0101b24 <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ad8:	e8 a2 fa ff ff       	call   c010157f <cons_getc>
c0101add:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ae0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ae4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ae8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af0:	c7 04 24 94 60 10 c0 	movl   $0xc0106094,(%esp)
c0101af7:	e8 8f e7 ff ff       	call   c010028b <cprintf>
        break;
c0101afc:	eb 7e                	jmp    c0101b7c <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101afe:	e8 7c fa ff ff       	call   c010157f <cons_getc>
c0101b03:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101b06:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101b0a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101b0e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b16:	c7 04 24 a6 60 10 c0 	movl   $0xc01060a6,(%esp)
c0101b1d:	e8 69 e7 ff ff       	call   c010028b <cprintf>
        break;
c0101b22:	eb 58                	jmp    c0101b7c <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101b24:	c7 44 24 08 b5 60 10 	movl   $0xc01060b5,0x8(%esp)
c0101b2b:	c0 
c0101b2c:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c0101b33:	00 
c0101b34:	c7 04 24 c5 60 10 c0 	movl   $0xc01060c5,(%esp)
c0101b3b:	e8 a2 e8 ff ff       	call   c01003e2 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b43:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b47:	0f b7 c0             	movzwl %ax,%eax
c0101b4a:	83 e0 03             	and    $0x3,%eax
c0101b4d:	85 c0                	test   %eax,%eax
c0101b4f:	75 2b                	jne    c0101b7c <trap_dispatch+0xdd>
            print_trapframe(tf);
c0101b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b54:	89 04 24             	mov    %eax,(%esp)
c0101b57:	e8 c7 fc ff ff       	call   c0101823 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101b5c:	c7 44 24 08 d6 60 10 	movl   $0xc01060d6,0x8(%esp)
c0101b63:	c0 
c0101b64:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101b6b:	00 
c0101b6c:	c7 04 24 c5 60 10 c0 	movl   $0xc01060c5,(%esp)
c0101b73:	e8 6a e8 ff ff       	call   c01003e2 <__panic>
        break;
c0101b78:	90                   	nop
c0101b79:	eb 01                	jmp    c0101b7c <trap_dispatch+0xdd>
        break;
c0101b7b:	90                   	nop
        }
    }
}
c0101b7c:	c9                   	leave  
c0101b7d:	c3                   	ret    

c0101b7e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101b7e:	55                   	push   %ebp
c0101b7f:	89 e5                	mov    %esp,%ebp
c0101b81:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b87:	89 04 24             	mov    %eax,(%esp)
c0101b8a:	e8 10 ff ff ff       	call   c0101a9f <trap_dispatch>
}
c0101b8f:	c9                   	leave  
c0101b90:	c3                   	ret    

c0101b91 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101b91:	6a 00                	push   $0x0
  pushl $0
c0101b93:	6a 00                	push   $0x0
  jmp __alltraps
c0101b95:	e9 67 0a 00 00       	jmp    c0102601 <__alltraps>

c0101b9a <vector1>:
.globl vector1
vector1:
  pushl $0
c0101b9a:	6a 00                	push   $0x0
  pushl $1
c0101b9c:	6a 01                	push   $0x1
  jmp __alltraps
c0101b9e:	e9 5e 0a 00 00       	jmp    c0102601 <__alltraps>

c0101ba3 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ba3:	6a 00                	push   $0x0
  pushl $2
c0101ba5:	6a 02                	push   $0x2
  jmp __alltraps
c0101ba7:	e9 55 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bac <vector3>:
.globl vector3
vector3:
  pushl $0
c0101bac:	6a 00                	push   $0x0
  pushl $3
c0101bae:	6a 03                	push   $0x3
  jmp __alltraps
c0101bb0:	e9 4c 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bb5 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101bb5:	6a 00                	push   $0x0
  pushl $4
c0101bb7:	6a 04                	push   $0x4
  jmp __alltraps
c0101bb9:	e9 43 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bbe <vector5>:
.globl vector5
vector5:
  pushl $0
c0101bbe:	6a 00                	push   $0x0
  pushl $5
c0101bc0:	6a 05                	push   $0x5
  jmp __alltraps
c0101bc2:	e9 3a 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bc7 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101bc7:	6a 00                	push   $0x0
  pushl $6
c0101bc9:	6a 06                	push   $0x6
  jmp __alltraps
c0101bcb:	e9 31 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bd0 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101bd0:	6a 00                	push   $0x0
  pushl $7
c0101bd2:	6a 07                	push   $0x7
  jmp __alltraps
c0101bd4:	e9 28 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bd9 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101bd9:	6a 08                	push   $0x8
  jmp __alltraps
c0101bdb:	e9 21 0a 00 00       	jmp    c0102601 <__alltraps>

c0101be0 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101be0:	6a 09                	push   $0x9
  jmp __alltraps
c0101be2:	e9 1a 0a 00 00       	jmp    c0102601 <__alltraps>

c0101be7 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101be7:	6a 0a                	push   $0xa
  jmp __alltraps
c0101be9:	e9 13 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bee <vector11>:
.globl vector11
vector11:
  pushl $11
c0101bee:	6a 0b                	push   $0xb
  jmp __alltraps
c0101bf0:	e9 0c 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bf5 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101bf5:	6a 0c                	push   $0xc
  jmp __alltraps
c0101bf7:	e9 05 0a 00 00       	jmp    c0102601 <__alltraps>

c0101bfc <vector13>:
.globl vector13
vector13:
  pushl $13
c0101bfc:	6a 0d                	push   $0xd
  jmp __alltraps
c0101bfe:	e9 fe 09 00 00       	jmp    c0102601 <__alltraps>

c0101c03 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101c03:	6a 0e                	push   $0xe
  jmp __alltraps
c0101c05:	e9 f7 09 00 00       	jmp    c0102601 <__alltraps>

c0101c0a <vector15>:
.globl vector15
vector15:
  pushl $0
c0101c0a:	6a 00                	push   $0x0
  pushl $15
c0101c0c:	6a 0f                	push   $0xf
  jmp __alltraps
c0101c0e:	e9 ee 09 00 00       	jmp    c0102601 <__alltraps>

c0101c13 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101c13:	6a 00                	push   $0x0
  pushl $16
c0101c15:	6a 10                	push   $0x10
  jmp __alltraps
c0101c17:	e9 e5 09 00 00       	jmp    c0102601 <__alltraps>

c0101c1c <vector17>:
.globl vector17
vector17:
  pushl $17
c0101c1c:	6a 11                	push   $0x11
  jmp __alltraps
c0101c1e:	e9 de 09 00 00       	jmp    c0102601 <__alltraps>

c0101c23 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101c23:	6a 00                	push   $0x0
  pushl $18
c0101c25:	6a 12                	push   $0x12
  jmp __alltraps
c0101c27:	e9 d5 09 00 00       	jmp    c0102601 <__alltraps>

c0101c2c <vector19>:
.globl vector19
vector19:
  pushl $0
c0101c2c:	6a 00                	push   $0x0
  pushl $19
c0101c2e:	6a 13                	push   $0x13
  jmp __alltraps
c0101c30:	e9 cc 09 00 00       	jmp    c0102601 <__alltraps>

c0101c35 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101c35:	6a 00                	push   $0x0
  pushl $20
c0101c37:	6a 14                	push   $0x14
  jmp __alltraps
c0101c39:	e9 c3 09 00 00       	jmp    c0102601 <__alltraps>

c0101c3e <vector21>:
.globl vector21
vector21:
  pushl $0
c0101c3e:	6a 00                	push   $0x0
  pushl $21
c0101c40:	6a 15                	push   $0x15
  jmp __alltraps
c0101c42:	e9 ba 09 00 00       	jmp    c0102601 <__alltraps>

c0101c47 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101c47:	6a 00                	push   $0x0
  pushl $22
c0101c49:	6a 16                	push   $0x16
  jmp __alltraps
c0101c4b:	e9 b1 09 00 00       	jmp    c0102601 <__alltraps>

c0101c50 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101c50:	6a 00                	push   $0x0
  pushl $23
c0101c52:	6a 17                	push   $0x17
  jmp __alltraps
c0101c54:	e9 a8 09 00 00       	jmp    c0102601 <__alltraps>

c0101c59 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101c59:	6a 00                	push   $0x0
  pushl $24
c0101c5b:	6a 18                	push   $0x18
  jmp __alltraps
c0101c5d:	e9 9f 09 00 00       	jmp    c0102601 <__alltraps>

c0101c62 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101c62:	6a 00                	push   $0x0
  pushl $25
c0101c64:	6a 19                	push   $0x19
  jmp __alltraps
c0101c66:	e9 96 09 00 00       	jmp    c0102601 <__alltraps>

c0101c6b <vector26>:
.globl vector26
vector26:
  pushl $0
c0101c6b:	6a 00                	push   $0x0
  pushl $26
c0101c6d:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101c6f:	e9 8d 09 00 00       	jmp    c0102601 <__alltraps>

c0101c74 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101c74:	6a 00                	push   $0x0
  pushl $27
c0101c76:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101c78:	e9 84 09 00 00       	jmp    c0102601 <__alltraps>

c0101c7d <vector28>:
.globl vector28
vector28:
  pushl $0
c0101c7d:	6a 00                	push   $0x0
  pushl $28
c0101c7f:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101c81:	e9 7b 09 00 00       	jmp    c0102601 <__alltraps>

c0101c86 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101c86:	6a 00                	push   $0x0
  pushl $29
c0101c88:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101c8a:	e9 72 09 00 00       	jmp    c0102601 <__alltraps>

c0101c8f <vector30>:
.globl vector30
vector30:
  pushl $0
c0101c8f:	6a 00                	push   $0x0
  pushl $30
c0101c91:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101c93:	e9 69 09 00 00       	jmp    c0102601 <__alltraps>

c0101c98 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101c98:	6a 00                	push   $0x0
  pushl $31
c0101c9a:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101c9c:	e9 60 09 00 00       	jmp    c0102601 <__alltraps>

c0101ca1 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ca1:	6a 00                	push   $0x0
  pushl $32
c0101ca3:	6a 20                	push   $0x20
  jmp __alltraps
c0101ca5:	e9 57 09 00 00       	jmp    c0102601 <__alltraps>

c0101caa <vector33>:
.globl vector33
vector33:
  pushl $0
c0101caa:	6a 00                	push   $0x0
  pushl $33
c0101cac:	6a 21                	push   $0x21
  jmp __alltraps
c0101cae:	e9 4e 09 00 00       	jmp    c0102601 <__alltraps>

c0101cb3 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101cb3:	6a 00                	push   $0x0
  pushl $34
c0101cb5:	6a 22                	push   $0x22
  jmp __alltraps
c0101cb7:	e9 45 09 00 00       	jmp    c0102601 <__alltraps>

c0101cbc <vector35>:
.globl vector35
vector35:
  pushl $0
c0101cbc:	6a 00                	push   $0x0
  pushl $35
c0101cbe:	6a 23                	push   $0x23
  jmp __alltraps
c0101cc0:	e9 3c 09 00 00       	jmp    c0102601 <__alltraps>

c0101cc5 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101cc5:	6a 00                	push   $0x0
  pushl $36
c0101cc7:	6a 24                	push   $0x24
  jmp __alltraps
c0101cc9:	e9 33 09 00 00       	jmp    c0102601 <__alltraps>

c0101cce <vector37>:
.globl vector37
vector37:
  pushl $0
c0101cce:	6a 00                	push   $0x0
  pushl $37
c0101cd0:	6a 25                	push   $0x25
  jmp __alltraps
c0101cd2:	e9 2a 09 00 00       	jmp    c0102601 <__alltraps>

c0101cd7 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101cd7:	6a 00                	push   $0x0
  pushl $38
c0101cd9:	6a 26                	push   $0x26
  jmp __alltraps
c0101cdb:	e9 21 09 00 00       	jmp    c0102601 <__alltraps>

c0101ce0 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101ce0:	6a 00                	push   $0x0
  pushl $39
c0101ce2:	6a 27                	push   $0x27
  jmp __alltraps
c0101ce4:	e9 18 09 00 00       	jmp    c0102601 <__alltraps>

c0101ce9 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101ce9:	6a 00                	push   $0x0
  pushl $40
c0101ceb:	6a 28                	push   $0x28
  jmp __alltraps
c0101ced:	e9 0f 09 00 00       	jmp    c0102601 <__alltraps>

c0101cf2 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101cf2:	6a 00                	push   $0x0
  pushl $41
c0101cf4:	6a 29                	push   $0x29
  jmp __alltraps
c0101cf6:	e9 06 09 00 00       	jmp    c0102601 <__alltraps>

c0101cfb <vector42>:
.globl vector42
vector42:
  pushl $0
c0101cfb:	6a 00                	push   $0x0
  pushl $42
c0101cfd:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101cff:	e9 fd 08 00 00       	jmp    c0102601 <__alltraps>

c0101d04 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101d04:	6a 00                	push   $0x0
  pushl $43
c0101d06:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101d08:	e9 f4 08 00 00       	jmp    c0102601 <__alltraps>

c0101d0d <vector44>:
.globl vector44
vector44:
  pushl $0
c0101d0d:	6a 00                	push   $0x0
  pushl $44
c0101d0f:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101d11:	e9 eb 08 00 00       	jmp    c0102601 <__alltraps>

c0101d16 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101d16:	6a 00                	push   $0x0
  pushl $45
c0101d18:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101d1a:	e9 e2 08 00 00       	jmp    c0102601 <__alltraps>

c0101d1f <vector46>:
.globl vector46
vector46:
  pushl $0
c0101d1f:	6a 00                	push   $0x0
  pushl $46
c0101d21:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101d23:	e9 d9 08 00 00       	jmp    c0102601 <__alltraps>

c0101d28 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101d28:	6a 00                	push   $0x0
  pushl $47
c0101d2a:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101d2c:	e9 d0 08 00 00       	jmp    c0102601 <__alltraps>

c0101d31 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101d31:	6a 00                	push   $0x0
  pushl $48
c0101d33:	6a 30                	push   $0x30
  jmp __alltraps
c0101d35:	e9 c7 08 00 00       	jmp    c0102601 <__alltraps>

c0101d3a <vector49>:
.globl vector49
vector49:
  pushl $0
c0101d3a:	6a 00                	push   $0x0
  pushl $49
c0101d3c:	6a 31                	push   $0x31
  jmp __alltraps
c0101d3e:	e9 be 08 00 00       	jmp    c0102601 <__alltraps>

c0101d43 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101d43:	6a 00                	push   $0x0
  pushl $50
c0101d45:	6a 32                	push   $0x32
  jmp __alltraps
c0101d47:	e9 b5 08 00 00       	jmp    c0102601 <__alltraps>

c0101d4c <vector51>:
.globl vector51
vector51:
  pushl $0
c0101d4c:	6a 00                	push   $0x0
  pushl $51
c0101d4e:	6a 33                	push   $0x33
  jmp __alltraps
c0101d50:	e9 ac 08 00 00       	jmp    c0102601 <__alltraps>

c0101d55 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101d55:	6a 00                	push   $0x0
  pushl $52
c0101d57:	6a 34                	push   $0x34
  jmp __alltraps
c0101d59:	e9 a3 08 00 00       	jmp    c0102601 <__alltraps>

c0101d5e <vector53>:
.globl vector53
vector53:
  pushl $0
c0101d5e:	6a 00                	push   $0x0
  pushl $53
c0101d60:	6a 35                	push   $0x35
  jmp __alltraps
c0101d62:	e9 9a 08 00 00       	jmp    c0102601 <__alltraps>

c0101d67 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101d67:	6a 00                	push   $0x0
  pushl $54
c0101d69:	6a 36                	push   $0x36
  jmp __alltraps
c0101d6b:	e9 91 08 00 00       	jmp    c0102601 <__alltraps>

c0101d70 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101d70:	6a 00                	push   $0x0
  pushl $55
c0101d72:	6a 37                	push   $0x37
  jmp __alltraps
c0101d74:	e9 88 08 00 00       	jmp    c0102601 <__alltraps>

c0101d79 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101d79:	6a 00                	push   $0x0
  pushl $56
c0101d7b:	6a 38                	push   $0x38
  jmp __alltraps
c0101d7d:	e9 7f 08 00 00       	jmp    c0102601 <__alltraps>

c0101d82 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101d82:	6a 00                	push   $0x0
  pushl $57
c0101d84:	6a 39                	push   $0x39
  jmp __alltraps
c0101d86:	e9 76 08 00 00       	jmp    c0102601 <__alltraps>

c0101d8b <vector58>:
.globl vector58
vector58:
  pushl $0
c0101d8b:	6a 00                	push   $0x0
  pushl $58
c0101d8d:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101d8f:	e9 6d 08 00 00       	jmp    c0102601 <__alltraps>

c0101d94 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101d94:	6a 00                	push   $0x0
  pushl $59
c0101d96:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101d98:	e9 64 08 00 00       	jmp    c0102601 <__alltraps>

c0101d9d <vector60>:
.globl vector60
vector60:
  pushl $0
c0101d9d:	6a 00                	push   $0x0
  pushl $60
c0101d9f:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101da1:	e9 5b 08 00 00       	jmp    c0102601 <__alltraps>

c0101da6 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101da6:	6a 00                	push   $0x0
  pushl $61
c0101da8:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101daa:	e9 52 08 00 00       	jmp    c0102601 <__alltraps>

c0101daf <vector62>:
.globl vector62
vector62:
  pushl $0
c0101daf:	6a 00                	push   $0x0
  pushl $62
c0101db1:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101db3:	e9 49 08 00 00       	jmp    c0102601 <__alltraps>

c0101db8 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101db8:	6a 00                	push   $0x0
  pushl $63
c0101dba:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101dbc:	e9 40 08 00 00       	jmp    c0102601 <__alltraps>

c0101dc1 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101dc1:	6a 00                	push   $0x0
  pushl $64
c0101dc3:	6a 40                	push   $0x40
  jmp __alltraps
c0101dc5:	e9 37 08 00 00       	jmp    c0102601 <__alltraps>

c0101dca <vector65>:
.globl vector65
vector65:
  pushl $0
c0101dca:	6a 00                	push   $0x0
  pushl $65
c0101dcc:	6a 41                	push   $0x41
  jmp __alltraps
c0101dce:	e9 2e 08 00 00       	jmp    c0102601 <__alltraps>

c0101dd3 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101dd3:	6a 00                	push   $0x0
  pushl $66
c0101dd5:	6a 42                	push   $0x42
  jmp __alltraps
c0101dd7:	e9 25 08 00 00       	jmp    c0102601 <__alltraps>

c0101ddc <vector67>:
.globl vector67
vector67:
  pushl $0
c0101ddc:	6a 00                	push   $0x0
  pushl $67
c0101dde:	6a 43                	push   $0x43
  jmp __alltraps
c0101de0:	e9 1c 08 00 00       	jmp    c0102601 <__alltraps>

c0101de5 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101de5:	6a 00                	push   $0x0
  pushl $68
c0101de7:	6a 44                	push   $0x44
  jmp __alltraps
c0101de9:	e9 13 08 00 00       	jmp    c0102601 <__alltraps>

c0101dee <vector69>:
.globl vector69
vector69:
  pushl $0
c0101dee:	6a 00                	push   $0x0
  pushl $69
c0101df0:	6a 45                	push   $0x45
  jmp __alltraps
c0101df2:	e9 0a 08 00 00       	jmp    c0102601 <__alltraps>

c0101df7 <vector70>:
.globl vector70
vector70:
  pushl $0
c0101df7:	6a 00                	push   $0x0
  pushl $70
c0101df9:	6a 46                	push   $0x46
  jmp __alltraps
c0101dfb:	e9 01 08 00 00       	jmp    c0102601 <__alltraps>

c0101e00 <vector71>:
.globl vector71
vector71:
  pushl $0
c0101e00:	6a 00                	push   $0x0
  pushl $71
c0101e02:	6a 47                	push   $0x47
  jmp __alltraps
c0101e04:	e9 f8 07 00 00       	jmp    c0102601 <__alltraps>

c0101e09 <vector72>:
.globl vector72
vector72:
  pushl $0
c0101e09:	6a 00                	push   $0x0
  pushl $72
c0101e0b:	6a 48                	push   $0x48
  jmp __alltraps
c0101e0d:	e9 ef 07 00 00       	jmp    c0102601 <__alltraps>

c0101e12 <vector73>:
.globl vector73
vector73:
  pushl $0
c0101e12:	6a 00                	push   $0x0
  pushl $73
c0101e14:	6a 49                	push   $0x49
  jmp __alltraps
c0101e16:	e9 e6 07 00 00       	jmp    c0102601 <__alltraps>

c0101e1b <vector74>:
.globl vector74
vector74:
  pushl $0
c0101e1b:	6a 00                	push   $0x0
  pushl $74
c0101e1d:	6a 4a                	push   $0x4a
  jmp __alltraps
c0101e1f:	e9 dd 07 00 00       	jmp    c0102601 <__alltraps>

c0101e24 <vector75>:
.globl vector75
vector75:
  pushl $0
c0101e24:	6a 00                	push   $0x0
  pushl $75
c0101e26:	6a 4b                	push   $0x4b
  jmp __alltraps
c0101e28:	e9 d4 07 00 00       	jmp    c0102601 <__alltraps>

c0101e2d <vector76>:
.globl vector76
vector76:
  pushl $0
c0101e2d:	6a 00                	push   $0x0
  pushl $76
c0101e2f:	6a 4c                	push   $0x4c
  jmp __alltraps
c0101e31:	e9 cb 07 00 00       	jmp    c0102601 <__alltraps>

c0101e36 <vector77>:
.globl vector77
vector77:
  pushl $0
c0101e36:	6a 00                	push   $0x0
  pushl $77
c0101e38:	6a 4d                	push   $0x4d
  jmp __alltraps
c0101e3a:	e9 c2 07 00 00       	jmp    c0102601 <__alltraps>

c0101e3f <vector78>:
.globl vector78
vector78:
  pushl $0
c0101e3f:	6a 00                	push   $0x0
  pushl $78
c0101e41:	6a 4e                	push   $0x4e
  jmp __alltraps
c0101e43:	e9 b9 07 00 00       	jmp    c0102601 <__alltraps>

c0101e48 <vector79>:
.globl vector79
vector79:
  pushl $0
c0101e48:	6a 00                	push   $0x0
  pushl $79
c0101e4a:	6a 4f                	push   $0x4f
  jmp __alltraps
c0101e4c:	e9 b0 07 00 00       	jmp    c0102601 <__alltraps>

c0101e51 <vector80>:
.globl vector80
vector80:
  pushl $0
c0101e51:	6a 00                	push   $0x0
  pushl $80
c0101e53:	6a 50                	push   $0x50
  jmp __alltraps
c0101e55:	e9 a7 07 00 00       	jmp    c0102601 <__alltraps>

c0101e5a <vector81>:
.globl vector81
vector81:
  pushl $0
c0101e5a:	6a 00                	push   $0x0
  pushl $81
c0101e5c:	6a 51                	push   $0x51
  jmp __alltraps
c0101e5e:	e9 9e 07 00 00       	jmp    c0102601 <__alltraps>

c0101e63 <vector82>:
.globl vector82
vector82:
  pushl $0
c0101e63:	6a 00                	push   $0x0
  pushl $82
c0101e65:	6a 52                	push   $0x52
  jmp __alltraps
c0101e67:	e9 95 07 00 00       	jmp    c0102601 <__alltraps>

c0101e6c <vector83>:
.globl vector83
vector83:
  pushl $0
c0101e6c:	6a 00                	push   $0x0
  pushl $83
c0101e6e:	6a 53                	push   $0x53
  jmp __alltraps
c0101e70:	e9 8c 07 00 00       	jmp    c0102601 <__alltraps>

c0101e75 <vector84>:
.globl vector84
vector84:
  pushl $0
c0101e75:	6a 00                	push   $0x0
  pushl $84
c0101e77:	6a 54                	push   $0x54
  jmp __alltraps
c0101e79:	e9 83 07 00 00       	jmp    c0102601 <__alltraps>

c0101e7e <vector85>:
.globl vector85
vector85:
  pushl $0
c0101e7e:	6a 00                	push   $0x0
  pushl $85
c0101e80:	6a 55                	push   $0x55
  jmp __alltraps
c0101e82:	e9 7a 07 00 00       	jmp    c0102601 <__alltraps>

c0101e87 <vector86>:
.globl vector86
vector86:
  pushl $0
c0101e87:	6a 00                	push   $0x0
  pushl $86
c0101e89:	6a 56                	push   $0x56
  jmp __alltraps
c0101e8b:	e9 71 07 00 00       	jmp    c0102601 <__alltraps>

c0101e90 <vector87>:
.globl vector87
vector87:
  pushl $0
c0101e90:	6a 00                	push   $0x0
  pushl $87
c0101e92:	6a 57                	push   $0x57
  jmp __alltraps
c0101e94:	e9 68 07 00 00       	jmp    c0102601 <__alltraps>

c0101e99 <vector88>:
.globl vector88
vector88:
  pushl $0
c0101e99:	6a 00                	push   $0x0
  pushl $88
c0101e9b:	6a 58                	push   $0x58
  jmp __alltraps
c0101e9d:	e9 5f 07 00 00       	jmp    c0102601 <__alltraps>

c0101ea2 <vector89>:
.globl vector89
vector89:
  pushl $0
c0101ea2:	6a 00                	push   $0x0
  pushl $89
c0101ea4:	6a 59                	push   $0x59
  jmp __alltraps
c0101ea6:	e9 56 07 00 00       	jmp    c0102601 <__alltraps>

c0101eab <vector90>:
.globl vector90
vector90:
  pushl $0
c0101eab:	6a 00                	push   $0x0
  pushl $90
c0101ead:	6a 5a                	push   $0x5a
  jmp __alltraps
c0101eaf:	e9 4d 07 00 00       	jmp    c0102601 <__alltraps>

c0101eb4 <vector91>:
.globl vector91
vector91:
  pushl $0
c0101eb4:	6a 00                	push   $0x0
  pushl $91
c0101eb6:	6a 5b                	push   $0x5b
  jmp __alltraps
c0101eb8:	e9 44 07 00 00       	jmp    c0102601 <__alltraps>

c0101ebd <vector92>:
.globl vector92
vector92:
  pushl $0
c0101ebd:	6a 00                	push   $0x0
  pushl $92
c0101ebf:	6a 5c                	push   $0x5c
  jmp __alltraps
c0101ec1:	e9 3b 07 00 00       	jmp    c0102601 <__alltraps>

c0101ec6 <vector93>:
.globl vector93
vector93:
  pushl $0
c0101ec6:	6a 00                	push   $0x0
  pushl $93
c0101ec8:	6a 5d                	push   $0x5d
  jmp __alltraps
c0101eca:	e9 32 07 00 00       	jmp    c0102601 <__alltraps>

c0101ecf <vector94>:
.globl vector94
vector94:
  pushl $0
c0101ecf:	6a 00                	push   $0x0
  pushl $94
c0101ed1:	6a 5e                	push   $0x5e
  jmp __alltraps
c0101ed3:	e9 29 07 00 00       	jmp    c0102601 <__alltraps>

c0101ed8 <vector95>:
.globl vector95
vector95:
  pushl $0
c0101ed8:	6a 00                	push   $0x0
  pushl $95
c0101eda:	6a 5f                	push   $0x5f
  jmp __alltraps
c0101edc:	e9 20 07 00 00       	jmp    c0102601 <__alltraps>

c0101ee1 <vector96>:
.globl vector96
vector96:
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  pushl $96
c0101ee3:	6a 60                	push   $0x60
  jmp __alltraps
c0101ee5:	e9 17 07 00 00       	jmp    c0102601 <__alltraps>

c0101eea <vector97>:
.globl vector97
vector97:
  pushl $0
c0101eea:	6a 00                	push   $0x0
  pushl $97
c0101eec:	6a 61                	push   $0x61
  jmp __alltraps
c0101eee:	e9 0e 07 00 00       	jmp    c0102601 <__alltraps>

c0101ef3 <vector98>:
.globl vector98
vector98:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $98
c0101ef5:	6a 62                	push   $0x62
  jmp __alltraps
c0101ef7:	e9 05 07 00 00       	jmp    c0102601 <__alltraps>

c0101efc <vector99>:
.globl vector99
vector99:
  pushl $0
c0101efc:	6a 00                	push   $0x0
  pushl $99
c0101efe:	6a 63                	push   $0x63
  jmp __alltraps
c0101f00:	e9 fc 06 00 00       	jmp    c0102601 <__alltraps>

c0101f05 <vector100>:
.globl vector100
vector100:
  pushl $0
c0101f05:	6a 00                	push   $0x0
  pushl $100
c0101f07:	6a 64                	push   $0x64
  jmp __alltraps
c0101f09:	e9 f3 06 00 00       	jmp    c0102601 <__alltraps>

c0101f0e <vector101>:
.globl vector101
vector101:
  pushl $0
c0101f0e:	6a 00                	push   $0x0
  pushl $101
c0101f10:	6a 65                	push   $0x65
  jmp __alltraps
c0101f12:	e9 ea 06 00 00       	jmp    c0102601 <__alltraps>

c0101f17 <vector102>:
.globl vector102
vector102:
  pushl $0
c0101f17:	6a 00                	push   $0x0
  pushl $102
c0101f19:	6a 66                	push   $0x66
  jmp __alltraps
c0101f1b:	e9 e1 06 00 00       	jmp    c0102601 <__alltraps>

c0101f20 <vector103>:
.globl vector103
vector103:
  pushl $0
c0101f20:	6a 00                	push   $0x0
  pushl $103
c0101f22:	6a 67                	push   $0x67
  jmp __alltraps
c0101f24:	e9 d8 06 00 00       	jmp    c0102601 <__alltraps>

c0101f29 <vector104>:
.globl vector104
vector104:
  pushl $0
c0101f29:	6a 00                	push   $0x0
  pushl $104
c0101f2b:	6a 68                	push   $0x68
  jmp __alltraps
c0101f2d:	e9 cf 06 00 00       	jmp    c0102601 <__alltraps>

c0101f32 <vector105>:
.globl vector105
vector105:
  pushl $0
c0101f32:	6a 00                	push   $0x0
  pushl $105
c0101f34:	6a 69                	push   $0x69
  jmp __alltraps
c0101f36:	e9 c6 06 00 00       	jmp    c0102601 <__alltraps>

c0101f3b <vector106>:
.globl vector106
vector106:
  pushl $0
c0101f3b:	6a 00                	push   $0x0
  pushl $106
c0101f3d:	6a 6a                	push   $0x6a
  jmp __alltraps
c0101f3f:	e9 bd 06 00 00       	jmp    c0102601 <__alltraps>

c0101f44 <vector107>:
.globl vector107
vector107:
  pushl $0
c0101f44:	6a 00                	push   $0x0
  pushl $107
c0101f46:	6a 6b                	push   $0x6b
  jmp __alltraps
c0101f48:	e9 b4 06 00 00       	jmp    c0102601 <__alltraps>

c0101f4d <vector108>:
.globl vector108
vector108:
  pushl $0
c0101f4d:	6a 00                	push   $0x0
  pushl $108
c0101f4f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0101f51:	e9 ab 06 00 00       	jmp    c0102601 <__alltraps>

c0101f56 <vector109>:
.globl vector109
vector109:
  pushl $0
c0101f56:	6a 00                	push   $0x0
  pushl $109
c0101f58:	6a 6d                	push   $0x6d
  jmp __alltraps
c0101f5a:	e9 a2 06 00 00       	jmp    c0102601 <__alltraps>

c0101f5f <vector110>:
.globl vector110
vector110:
  pushl $0
c0101f5f:	6a 00                	push   $0x0
  pushl $110
c0101f61:	6a 6e                	push   $0x6e
  jmp __alltraps
c0101f63:	e9 99 06 00 00       	jmp    c0102601 <__alltraps>

c0101f68 <vector111>:
.globl vector111
vector111:
  pushl $0
c0101f68:	6a 00                	push   $0x0
  pushl $111
c0101f6a:	6a 6f                	push   $0x6f
  jmp __alltraps
c0101f6c:	e9 90 06 00 00       	jmp    c0102601 <__alltraps>

c0101f71 <vector112>:
.globl vector112
vector112:
  pushl $0
c0101f71:	6a 00                	push   $0x0
  pushl $112
c0101f73:	6a 70                	push   $0x70
  jmp __alltraps
c0101f75:	e9 87 06 00 00       	jmp    c0102601 <__alltraps>

c0101f7a <vector113>:
.globl vector113
vector113:
  pushl $0
c0101f7a:	6a 00                	push   $0x0
  pushl $113
c0101f7c:	6a 71                	push   $0x71
  jmp __alltraps
c0101f7e:	e9 7e 06 00 00       	jmp    c0102601 <__alltraps>

c0101f83 <vector114>:
.globl vector114
vector114:
  pushl $0
c0101f83:	6a 00                	push   $0x0
  pushl $114
c0101f85:	6a 72                	push   $0x72
  jmp __alltraps
c0101f87:	e9 75 06 00 00       	jmp    c0102601 <__alltraps>

c0101f8c <vector115>:
.globl vector115
vector115:
  pushl $0
c0101f8c:	6a 00                	push   $0x0
  pushl $115
c0101f8e:	6a 73                	push   $0x73
  jmp __alltraps
c0101f90:	e9 6c 06 00 00       	jmp    c0102601 <__alltraps>

c0101f95 <vector116>:
.globl vector116
vector116:
  pushl $0
c0101f95:	6a 00                	push   $0x0
  pushl $116
c0101f97:	6a 74                	push   $0x74
  jmp __alltraps
c0101f99:	e9 63 06 00 00       	jmp    c0102601 <__alltraps>

c0101f9e <vector117>:
.globl vector117
vector117:
  pushl $0
c0101f9e:	6a 00                	push   $0x0
  pushl $117
c0101fa0:	6a 75                	push   $0x75
  jmp __alltraps
c0101fa2:	e9 5a 06 00 00       	jmp    c0102601 <__alltraps>

c0101fa7 <vector118>:
.globl vector118
vector118:
  pushl $0
c0101fa7:	6a 00                	push   $0x0
  pushl $118
c0101fa9:	6a 76                	push   $0x76
  jmp __alltraps
c0101fab:	e9 51 06 00 00       	jmp    c0102601 <__alltraps>

c0101fb0 <vector119>:
.globl vector119
vector119:
  pushl $0
c0101fb0:	6a 00                	push   $0x0
  pushl $119
c0101fb2:	6a 77                	push   $0x77
  jmp __alltraps
c0101fb4:	e9 48 06 00 00       	jmp    c0102601 <__alltraps>

c0101fb9 <vector120>:
.globl vector120
vector120:
  pushl $0
c0101fb9:	6a 00                	push   $0x0
  pushl $120
c0101fbb:	6a 78                	push   $0x78
  jmp __alltraps
c0101fbd:	e9 3f 06 00 00       	jmp    c0102601 <__alltraps>

c0101fc2 <vector121>:
.globl vector121
vector121:
  pushl $0
c0101fc2:	6a 00                	push   $0x0
  pushl $121
c0101fc4:	6a 79                	push   $0x79
  jmp __alltraps
c0101fc6:	e9 36 06 00 00       	jmp    c0102601 <__alltraps>

c0101fcb <vector122>:
.globl vector122
vector122:
  pushl $0
c0101fcb:	6a 00                	push   $0x0
  pushl $122
c0101fcd:	6a 7a                	push   $0x7a
  jmp __alltraps
c0101fcf:	e9 2d 06 00 00       	jmp    c0102601 <__alltraps>

c0101fd4 <vector123>:
.globl vector123
vector123:
  pushl $0
c0101fd4:	6a 00                	push   $0x0
  pushl $123
c0101fd6:	6a 7b                	push   $0x7b
  jmp __alltraps
c0101fd8:	e9 24 06 00 00       	jmp    c0102601 <__alltraps>

c0101fdd <vector124>:
.globl vector124
vector124:
  pushl $0
c0101fdd:	6a 00                	push   $0x0
  pushl $124
c0101fdf:	6a 7c                	push   $0x7c
  jmp __alltraps
c0101fe1:	e9 1b 06 00 00       	jmp    c0102601 <__alltraps>

c0101fe6 <vector125>:
.globl vector125
vector125:
  pushl $0
c0101fe6:	6a 00                	push   $0x0
  pushl $125
c0101fe8:	6a 7d                	push   $0x7d
  jmp __alltraps
c0101fea:	e9 12 06 00 00       	jmp    c0102601 <__alltraps>

c0101fef <vector126>:
.globl vector126
vector126:
  pushl $0
c0101fef:	6a 00                	push   $0x0
  pushl $126
c0101ff1:	6a 7e                	push   $0x7e
  jmp __alltraps
c0101ff3:	e9 09 06 00 00       	jmp    c0102601 <__alltraps>

c0101ff8 <vector127>:
.globl vector127
vector127:
  pushl $0
c0101ff8:	6a 00                	push   $0x0
  pushl $127
c0101ffa:	6a 7f                	push   $0x7f
  jmp __alltraps
c0101ffc:	e9 00 06 00 00       	jmp    c0102601 <__alltraps>

c0102001 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102001:	6a 00                	push   $0x0
  pushl $128
c0102003:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102008:	e9 f4 05 00 00       	jmp    c0102601 <__alltraps>

c010200d <vector129>:
.globl vector129
vector129:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $129
c010200f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102014:	e9 e8 05 00 00       	jmp    c0102601 <__alltraps>

c0102019 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102019:	6a 00                	push   $0x0
  pushl $130
c010201b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102020:	e9 dc 05 00 00       	jmp    c0102601 <__alltraps>

c0102025 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102025:	6a 00                	push   $0x0
  pushl $131
c0102027:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010202c:	e9 d0 05 00 00       	jmp    c0102601 <__alltraps>

c0102031 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $132
c0102033:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102038:	e9 c4 05 00 00       	jmp    c0102601 <__alltraps>

c010203d <vector133>:
.globl vector133
vector133:
  pushl $0
c010203d:	6a 00                	push   $0x0
  pushl $133
c010203f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102044:	e9 b8 05 00 00       	jmp    c0102601 <__alltraps>

c0102049 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102049:	6a 00                	push   $0x0
  pushl $134
c010204b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102050:	e9 ac 05 00 00       	jmp    c0102601 <__alltraps>

c0102055 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $135
c0102057:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010205c:	e9 a0 05 00 00       	jmp    c0102601 <__alltraps>

c0102061 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102061:	6a 00                	push   $0x0
  pushl $136
c0102063:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102068:	e9 94 05 00 00       	jmp    c0102601 <__alltraps>

c010206d <vector137>:
.globl vector137
vector137:
  pushl $0
c010206d:	6a 00                	push   $0x0
  pushl $137
c010206f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102074:	e9 88 05 00 00       	jmp    c0102601 <__alltraps>

c0102079 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $138
c010207b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102080:	e9 7c 05 00 00       	jmp    c0102601 <__alltraps>

c0102085 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102085:	6a 00                	push   $0x0
  pushl $139
c0102087:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010208c:	e9 70 05 00 00       	jmp    c0102601 <__alltraps>

c0102091 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102091:	6a 00                	push   $0x0
  pushl $140
c0102093:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102098:	e9 64 05 00 00       	jmp    c0102601 <__alltraps>

c010209d <vector141>:
.globl vector141
vector141:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $141
c010209f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01020a4:	e9 58 05 00 00       	jmp    c0102601 <__alltraps>

c01020a9 <vector142>:
.globl vector142
vector142:
  pushl $0
c01020a9:	6a 00                	push   $0x0
  pushl $142
c01020ab:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01020b0:	e9 4c 05 00 00       	jmp    c0102601 <__alltraps>

c01020b5 <vector143>:
.globl vector143
vector143:
  pushl $0
c01020b5:	6a 00                	push   $0x0
  pushl $143
c01020b7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01020bc:	e9 40 05 00 00       	jmp    c0102601 <__alltraps>

c01020c1 <vector144>:
.globl vector144
vector144:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $144
c01020c3:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01020c8:	e9 34 05 00 00       	jmp    c0102601 <__alltraps>

c01020cd <vector145>:
.globl vector145
vector145:
  pushl $0
c01020cd:	6a 00                	push   $0x0
  pushl $145
c01020cf:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01020d4:	e9 28 05 00 00       	jmp    c0102601 <__alltraps>

c01020d9 <vector146>:
.globl vector146
vector146:
  pushl $0
c01020d9:	6a 00                	push   $0x0
  pushl $146
c01020db:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01020e0:	e9 1c 05 00 00       	jmp    c0102601 <__alltraps>

c01020e5 <vector147>:
.globl vector147
vector147:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $147
c01020e7:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01020ec:	e9 10 05 00 00       	jmp    c0102601 <__alltraps>

c01020f1 <vector148>:
.globl vector148
vector148:
  pushl $0
c01020f1:	6a 00                	push   $0x0
  pushl $148
c01020f3:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01020f8:	e9 04 05 00 00       	jmp    c0102601 <__alltraps>

c01020fd <vector149>:
.globl vector149
vector149:
  pushl $0
c01020fd:	6a 00                	push   $0x0
  pushl $149
c01020ff:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102104:	e9 f8 04 00 00       	jmp    c0102601 <__alltraps>

c0102109 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $150
c010210b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102110:	e9 ec 04 00 00       	jmp    c0102601 <__alltraps>

c0102115 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102115:	6a 00                	push   $0x0
  pushl $151
c0102117:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010211c:	e9 e0 04 00 00       	jmp    c0102601 <__alltraps>

c0102121 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102121:	6a 00                	push   $0x0
  pushl $152
c0102123:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102128:	e9 d4 04 00 00       	jmp    c0102601 <__alltraps>

c010212d <vector153>:
.globl vector153
vector153:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $153
c010212f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102134:	e9 c8 04 00 00       	jmp    c0102601 <__alltraps>

c0102139 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102139:	6a 00                	push   $0x0
  pushl $154
c010213b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102140:	e9 bc 04 00 00       	jmp    c0102601 <__alltraps>

c0102145 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102145:	6a 00                	push   $0x0
  pushl $155
c0102147:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010214c:	e9 b0 04 00 00       	jmp    c0102601 <__alltraps>

c0102151 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $156
c0102153:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102158:	e9 a4 04 00 00       	jmp    c0102601 <__alltraps>

c010215d <vector157>:
.globl vector157
vector157:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $157
c010215f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102164:	e9 98 04 00 00       	jmp    c0102601 <__alltraps>

c0102169 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102169:	6a 00                	push   $0x0
  pushl $158
c010216b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102170:	e9 8c 04 00 00       	jmp    c0102601 <__alltraps>

c0102175 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $159
c0102177:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010217c:	e9 80 04 00 00       	jmp    c0102601 <__alltraps>

c0102181 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $160
c0102183:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102188:	e9 74 04 00 00       	jmp    c0102601 <__alltraps>

c010218d <vector161>:
.globl vector161
vector161:
  pushl $0
c010218d:	6a 00                	push   $0x0
  pushl $161
c010218f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102194:	e9 68 04 00 00       	jmp    c0102601 <__alltraps>

c0102199 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $162
c010219b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01021a0:	e9 5c 04 00 00       	jmp    c0102601 <__alltraps>

c01021a5 <vector163>:
.globl vector163
vector163:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $163
c01021a7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01021ac:	e9 50 04 00 00       	jmp    c0102601 <__alltraps>

c01021b1 <vector164>:
.globl vector164
vector164:
  pushl $0
c01021b1:	6a 00                	push   $0x0
  pushl $164
c01021b3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01021b8:	e9 44 04 00 00       	jmp    c0102601 <__alltraps>

c01021bd <vector165>:
.globl vector165
vector165:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $165
c01021bf:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01021c4:	e9 38 04 00 00       	jmp    c0102601 <__alltraps>

c01021c9 <vector166>:
.globl vector166
vector166:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $166
c01021cb:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01021d0:	e9 2c 04 00 00       	jmp    c0102601 <__alltraps>

c01021d5 <vector167>:
.globl vector167
vector167:
  pushl $0
c01021d5:	6a 00                	push   $0x0
  pushl $167
c01021d7:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01021dc:	e9 20 04 00 00       	jmp    c0102601 <__alltraps>

c01021e1 <vector168>:
.globl vector168
vector168:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $168
c01021e3:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01021e8:	e9 14 04 00 00       	jmp    c0102601 <__alltraps>

c01021ed <vector169>:
.globl vector169
vector169:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $169
c01021ef:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01021f4:	e9 08 04 00 00       	jmp    c0102601 <__alltraps>

c01021f9 <vector170>:
.globl vector170
vector170:
  pushl $0
c01021f9:	6a 00                	push   $0x0
  pushl $170
c01021fb:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102200:	e9 fc 03 00 00       	jmp    c0102601 <__alltraps>

c0102205 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $171
c0102207:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010220c:	e9 f0 03 00 00       	jmp    c0102601 <__alltraps>

c0102211 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $172
c0102213:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102218:	e9 e4 03 00 00       	jmp    c0102601 <__alltraps>

c010221d <vector173>:
.globl vector173
vector173:
  pushl $0
c010221d:	6a 00                	push   $0x0
  pushl $173
c010221f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102224:	e9 d8 03 00 00       	jmp    c0102601 <__alltraps>

c0102229 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $174
c010222b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102230:	e9 cc 03 00 00       	jmp    c0102601 <__alltraps>

c0102235 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $175
c0102237:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010223c:	e9 c0 03 00 00       	jmp    c0102601 <__alltraps>

c0102241 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102241:	6a 00                	push   $0x0
  pushl $176
c0102243:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102248:	e9 b4 03 00 00       	jmp    c0102601 <__alltraps>

c010224d <vector177>:
.globl vector177
vector177:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $177
c010224f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102254:	e9 a8 03 00 00       	jmp    c0102601 <__alltraps>

c0102259 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $178
c010225b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102260:	e9 9c 03 00 00       	jmp    c0102601 <__alltraps>

c0102265 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102265:	6a 00                	push   $0x0
  pushl $179
c0102267:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010226c:	e9 90 03 00 00       	jmp    c0102601 <__alltraps>

c0102271 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $180
c0102273:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102278:	e9 84 03 00 00       	jmp    c0102601 <__alltraps>

c010227d <vector181>:
.globl vector181
vector181:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $181
c010227f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102284:	e9 78 03 00 00       	jmp    c0102601 <__alltraps>

c0102289 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102289:	6a 00                	push   $0x0
  pushl $182
c010228b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102290:	e9 6c 03 00 00       	jmp    c0102601 <__alltraps>

c0102295 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $183
c0102297:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010229c:	e9 60 03 00 00       	jmp    c0102601 <__alltraps>

c01022a1 <vector184>:
.globl vector184
vector184:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $184
c01022a3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01022a8:	e9 54 03 00 00       	jmp    c0102601 <__alltraps>

c01022ad <vector185>:
.globl vector185
vector185:
  pushl $0
c01022ad:	6a 00                	push   $0x0
  pushl $185
c01022af:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01022b4:	e9 48 03 00 00       	jmp    c0102601 <__alltraps>

c01022b9 <vector186>:
.globl vector186
vector186:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $186
c01022bb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01022c0:	e9 3c 03 00 00       	jmp    c0102601 <__alltraps>

c01022c5 <vector187>:
.globl vector187
vector187:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $187
c01022c7:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01022cc:	e9 30 03 00 00       	jmp    c0102601 <__alltraps>

c01022d1 <vector188>:
.globl vector188
vector188:
  pushl $0
c01022d1:	6a 00                	push   $0x0
  pushl $188
c01022d3:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01022d8:	e9 24 03 00 00       	jmp    c0102601 <__alltraps>

c01022dd <vector189>:
.globl vector189
vector189:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $189
c01022df:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01022e4:	e9 18 03 00 00       	jmp    c0102601 <__alltraps>

c01022e9 <vector190>:
.globl vector190
vector190:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $190
c01022eb:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01022f0:	e9 0c 03 00 00       	jmp    c0102601 <__alltraps>

c01022f5 <vector191>:
.globl vector191
vector191:
  pushl $0
c01022f5:	6a 00                	push   $0x0
  pushl $191
c01022f7:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01022fc:	e9 00 03 00 00       	jmp    c0102601 <__alltraps>

c0102301 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102301:	6a 00                	push   $0x0
  pushl $192
c0102303:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102308:	e9 f4 02 00 00       	jmp    c0102601 <__alltraps>

c010230d <vector193>:
.globl vector193
vector193:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $193
c010230f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102314:	e9 e8 02 00 00       	jmp    c0102601 <__alltraps>

c0102319 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102319:	6a 00                	push   $0x0
  pushl $194
c010231b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102320:	e9 dc 02 00 00       	jmp    c0102601 <__alltraps>

c0102325 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102325:	6a 00                	push   $0x0
  pushl $195
c0102327:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010232c:	e9 d0 02 00 00       	jmp    c0102601 <__alltraps>

c0102331 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $196
c0102333:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102338:	e9 c4 02 00 00       	jmp    c0102601 <__alltraps>

c010233d <vector197>:
.globl vector197
vector197:
  pushl $0
c010233d:	6a 00                	push   $0x0
  pushl $197
c010233f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102344:	e9 b8 02 00 00       	jmp    c0102601 <__alltraps>

c0102349 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102349:	6a 00                	push   $0x0
  pushl $198
c010234b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102350:	e9 ac 02 00 00       	jmp    c0102601 <__alltraps>

c0102355 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $199
c0102357:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010235c:	e9 a0 02 00 00       	jmp    c0102601 <__alltraps>

c0102361 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102361:	6a 00                	push   $0x0
  pushl $200
c0102363:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102368:	e9 94 02 00 00       	jmp    c0102601 <__alltraps>

c010236d <vector201>:
.globl vector201
vector201:
  pushl $0
c010236d:	6a 00                	push   $0x0
  pushl $201
c010236f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102374:	e9 88 02 00 00       	jmp    c0102601 <__alltraps>

c0102379 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $202
c010237b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102380:	e9 7c 02 00 00       	jmp    c0102601 <__alltraps>

c0102385 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102385:	6a 00                	push   $0x0
  pushl $203
c0102387:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010238c:	e9 70 02 00 00       	jmp    c0102601 <__alltraps>

c0102391 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102391:	6a 00                	push   $0x0
  pushl $204
c0102393:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102398:	e9 64 02 00 00       	jmp    c0102601 <__alltraps>

c010239d <vector205>:
.globl vector205
vector205:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $205
c010239f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01023a4:	e9 58 02 00 00       	jmp    c0102601 <__alltraps>

c01023a9 <vector206>:
.globl vector206
vector206:
  pushl $0
c01023a9:	6a 00                	push   $0x0
  pushl $206
c01023ab:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01023b0:	e9 4c 02 00 00       	jmp    c0102601 <__alltraps>

c01023b5 <vector207>:
.globl vector207
vector207:
  pushl $0
c01023b5:	6a 00                	push   $0x0
  pushl $207
c01023b7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01023bc:	e9 40 02 00 00       	jmp    c0102601 <__alltraps>

c01023c1 <vector208>:
.globl vector208
vector208:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $208
c01023c3:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01023c8:	e9 34 02 00 00       	jmp    c0102601 <__alltraps>

c01023cd <vector209>:
.globl vector209
vector209:
  pushl $0
c01023cd:	6a 00                	push   $0x0
  pushl $209
c01023cf:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01023d4:	e9 28 02 00 00       	jmp    c0102601 <__alltraps>

c01023d9 <vector210>:
.globl vector210
vector210:
  pushl $0
c01023d9:	6a 00                	push   $0x0
  pushl $210
c01023db:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01023e0:	e9 1c 02 00 00       	jmp    c0102601 <__alltraps>

c01023e5 <vector211>:
.globl vector211
vector211:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $211
c01023e7:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01023ec:	e9 10 02 00 00       	jmp    c0102601 <__alltraps>

c01023f1 <vector212>:
.globl vector212
vector212:
  pushl $0
c01023f1:	6a 00                	push   $0x0
  pushl $212
c01023f3:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01023f8:	e9 04 02 00 00       	jmp    c0102601 <__alltraps>

c01023fd <vector213>:
.globl vector213
vector213:
  pushl $0
c01023fd:	6a 00                	push   $0x0
  pushl $213
c01023ff:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102404:	e9 f8 01 00 00       	jmp    c0102601 <__alltraps>

c0102409 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102409:	6a 00                	push   $0x0
  pushl $214
c010240b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102410:	e9 ec 01 00 00       	jmp    c0102601 <__alltraps>

c0102415 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102415:	6a 00                	push   $0x0
  pushl $215
c0102417:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010241c:	e9 e0 01 00 00       	jmp    c0102601 <__alltraps>

c0102421 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102421:	6a 00                	push   $0x0
  pushl $216
c0102423:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102428:	e9 d4 01 00 00       	jmp    c0102601 <__alltraps>

c010242d <vector217>:
.globl vector217
vector217:
  pushl $0
c010242d:	6a 00                	push   $0x0
  pushl $217
c010242f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102434:	e9 c8 01 00 00       	jmp    c0102601 <__alltraps>

c0102439 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102439:	6a 00                	push   $0x0
  pushl $218
c010243b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102440:	e9 bc 01 00 00       	jmp    c0102601 <__alltraps>

c0102445 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102445:	6a 00                	push   $0x0
  pushl $219
c0102447:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010244c:	e9 b0 01 00 00       	jmp    c0102601 <__alltraps>

c0102451 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102451:	6a 00                	push   $0x0
  pushl $220
c0102453:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102458:	e9 a4 01 00 00       	jmp    c0102601 <__alltraps>

c010245d <vector221>:
.globl vector221
vector221:
  pushl $0
c010245d:	6a 00                	push   $0x0
  pushl $221
c010245f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102464:	e9 98 01 00 00       	jmp    c0102601 <__alltraps>

c0102469 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102469:	6a 00                	push   $0x0
  pushl $222
c010246b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102470:	e9 8c 01 00 00       	jmp    c0102601 <__alltraps>

c0102475 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102475:	6a 00                	push   $0x0
  pushl $223
c0102477:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010247c:	e9 80 01 00 00       	jmp    c0102601 <__alltraps>

c0102481 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102481:	6a 00                	push   $0x0
  pushl $224
c0102483:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102488:	e9 74 01 00 00       	jmp    c0102601 <__alltraps>

c010248d <vector225>:
.globl vector225
vector225:
  pushl $0
c010248d:	6a 00                	push   $0x0
  pushl $225
c010248f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102494:	e9 68 01 00 00       	jmp    c0102601 <__alltraps>

c0102499 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102499:	6a 00                	push   $0x0
  pushl $226
c010249b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01024a0:	e9 5c 01 00 00       	jmp    c0102601 <__alltraps>

c01024a5 <vector227>:
.globl vector227
vector227:
  pushl $0
c01024a5:	6a 00                	push   $0x0
  pushl $227
c01024a7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01024ac:	e9 50 01 00 00       	jmp    c0102601 <__alltraps>

c01024b1 <vector228>:
.globl vector228
vector228:
  pushl $0
c01024b1:	6a 00                	push   $0x0
  pushl $228
c01024b3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01024b8:	e9 44 01 00 00       	jmp    c0102601 <__alltraps>

c01024bd <vector229>:
.globl vector229
vector229:
  pushl $0
c01024bd:	6a 00                	push   $0x0
  pushl $229
c01024bf:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01024c4:	e9 38 01 00 00       	jmp    c0102601 <__alltraps>

c01024c9 <vector230>:
.globl vector230
vector230:
  pushl $0
c01024c9:	6a 00                	push   $0x0
  pushl $230
c01024cb:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01024d0:	e9 2c 01 00 00       	jmp    c0102601 <__alltraps>

c01024d5 <vector231>:
.globl vector231
vector231:
  pushl $0
c01024d5:	6a 00                	push   $0x0
  pushl $231
c01024d7:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01024dc:	e9 20 01 00 00       	jmp    c0102601 <__alltraps>

c01024e1 <vector232>:
.globl vector232
vector232:
  pushl $0
c01024e1:	6a 00                	push   $0x0
  pushl $232
c01024e3:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01024e8:	e9 14 01 00 00       	jmp    c0102601 <__alltraps>

c01024ed <vector233>:
.globl vector233
vector233:
  pushl $0
c01024ed:	6a 00                	push   $0x0
  pushl $233
c01024ef:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01024f4:	e9 08 01 00 00       	jmp    c0102601 <__alltraps>

c01024f9 <vector234>:
.globl vector234
vector234:
  pushl $0
c01024f9:	6a 00                	push   $0x0
  pushl $234
c01024fb:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102500:	e9 fc 00 00 00       	jmp    c0102601 <__alltraps>

c0102505 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102505:	6a 00                	push   $0x0
  pushl $235
c0102507:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010250c:	e9 f0 00 00 00       	jmp    c0102601 <__alltraps>

c0102511 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102511:	6a 00                	push   $0x0
  pushl $236
c0102513:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102518:	e9 e4 00 00 00       	jmp    c0102601 <__alltraps>

c010251d <vector237>:
.globl vector237
vector237:
  pushl $0
c010251d:	6a 00                	push   $0x0
  pushl $237
c010251f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102524:	e9 d8 00 00 00       	jmp    c0102601 <__alltraps>

c0102529 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102529:	6a 00                	push   $0x0
  pushl $238
c010252b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102530:	e9 cc 00 00 00       	jmp    c0102601 <__alltraps>

c0102535 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102535:	6a 00                	push   $0x0
  pushl $239
c0102537:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010253c:	e9 c0 00 00 00       	jmp    c0102601 <__alltraps>

c0102541 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102541:	6a 00                	push   $0x0
  pushl $240
c0102543:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102548:	e9 b4 00 00 00       	jmp    c0102601 <__alltraps>

c010254d <vector241>:
.globl vector241
vector241:
  pushl $0
c010254d:	6a 00                	push   $0x0
  pushl $241
c010254f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102554:	e9 a8 00 00 00       	jmp    c0102601 <__alltraps>

c0102559 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102559:	6a 00                	push   $0x0
  pushl $242
c010255b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102560:	e9 9c 00 00 00       	jmp    c0102601 <__alltraps>

c0102565 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102565:	6a 00                	push   $0x0
  pushl $243
c0102567:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010256c:	e9 90 00 00 00       	jmp    c0102601 <__alltraps>

c0102571 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102571:	6a 00                	push   $0x0
  pushl $244
c0102573:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102578:	e9 84 00 00 00       	jmp    c0102601 <__alltraps>

c010257d <vector245>:
.globl vector245
vector245:
  pushl $0
c010257d:	6a 00                	push   $0x0
  pushl $245
c010257f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102584:	e9 78 00 00 00       	jmp    c0102601 <__alltraps>

c0102589 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102589:	6a 00                	push   $0x0
  pushl $246
c010258b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102590:	e9 6c 00 00 00       	jmp    c0102601 <__alltraps>

c0102595 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102595:	6a 00                	push   $0x0
  pushl $247
c0102597:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010259c:	e9 60 00 00 00       	jmp    c0102601 <__alltraps>

c01025a1 <vector248>:
.globl vector248
vector248:
  pushl $0
c01025a1:	6a 00                	push   $0x0
  pushl $248
c01025a3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01025a8:	e9 54 00 00 00       	jmp    c0102601 <__alltraps>

c01025ad <vector249>:
.globl vector249
vector249:
  pushl $0
c01025ad:	6a 00                	push   $0x0
  pushl $249
c01025af:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01025b4:	e9 48 00 00 00       	jmp    c0102601 <__alltraps>

c01025b9 <vector250>:
.globl vector250
vector250:
  pushl $0
c01025b9:	6a 00                	push   $0x0
  pushl $250
c01025bb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01025c0:	e9 3c 00 00 00       	jmp    c0102601 <__alltraps>

c01025c5 <vector251>:
.globl vector251
vector251:
  pushl $0
c01025c5:	6a 00                	push   $0x0
  pushl $251
c01025c7:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01025cc:	e9 30 00 00 00       	jmp    c0102601 <__alltraps>

c01025d1 <vector252>:
.globl vector252
vector252:
  pushl $0
c01025d1:	6a 00                	push   $0x0
  pushl $252
c01025d3:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01025d8:	e9 24 00 00 00       	jmp    c0102601 <__alltraps>

c01025dd <vector253>:
.globl vector253
vector253:
  pushl $0
c01025dd:	6a 00                	push   $0x0
  pushl $253
c01025df:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01025e4:	e9 18 00 00 00       	jmp    c0102601 <__alltraps>

c01025e9 <vector254>:
.globl vector254
vector254:
  pushl $0
c01025e9:	6a 00                	push   $0x0
  pushl $254
c01025eb:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01025f0:	e9 0c 00 00 00       	jmp    c0102601 <__alltraps>

c01025f5 <vector255>:
.globl vector255
vector255:
  pushl $0
c01025f5:	6a 00                	push   $0x0
  pushl $255
c01025f7:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01025fc:	e9 00 00 00 00       	jmp    c0102601 <__alltraps>

c0102601 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102601:	1e                   	push   %ds
    pushl %es
c0102602:	06                   	push   %es
    pushl %fs
c0102603:	0f a0                	push   %fs
    pushl %gs
c0102605:	0f a8                	push   %gs
    pushal
c0102607:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102608:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010260d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010260f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102611:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102612:	e8 67 f5 ff ff       	call   c0101b7e <trap>

    # pop the pushed stack pointer
    popl %esp
c0102617:	5c                   	pop    %esp

c0102618 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102618:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102619:	0f a9                	pop    %gs
    popl %fs
c010261b:	0f a1                	pop    %fs
    popl %es
c010261d:	07                   	pop    %es
    popl %ds
c010261e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010261f:	83 c4 08             	add    $0x8,%esp
    iret
c0102622:	cf                   	iret   

c0102623 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102623:	55                   	push   %ebp
c0102624:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102626:	8b 55 08             	mov    0x8(%ebp),%edx
c0102629:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010262e:	29 c2                	sub    %eax,%edx
c0102630:	89 d0                	mov    %edx,%eax
c0102632:	c1 f8 02             	sar    $0x2,%eax
c0102635:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010263b:	5d                   	pop    %ebp
c010263c:	c3                   	ret    

c010263d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010263d:	55                   	push   %ebp
c010263e:	89 e5                	mov    %esp,%ebp
c0102640:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102643:	8b 45 08             	mov    0x8(%ebp),%eax
c0102646:	89 04 24             	mov    %eax,(%esp)
c0102649:	e8 d5 ff ff ff       	call   c0102623 <page2ppn>
c010264e:	c1 e0 0c             	shl    $0xc,%eax
}
c0102651:	c9                   	leave  
c0102652:	c3                   	ret    

c0102653 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102653:	55                   	push   %ebp
c0102654:	89 e5                	mov    %esp,%ebp
c0102656:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102659:	8b 45 08             	mov    0x8(%ebp),%eax
c010265c:	c1 e8 0c             	shr    $0xc,%eax
c010265f:	89 c2                	mov    %eax,%edx
c0102661:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102666:	39 c2                	cmp    %eax,%edx
c0102668:	72 1c                	jb     c0102686 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010266a:	c7 44 24 08 90 62 10 	movl   $0xc0106290,0x8(%esp)
c0102671:	c0 
c0102672:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102679:	00 
c010267a:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
c0102681:	e8 5c dd ff ff       	call   c01003e2 <__panic>
    }
    return &pages[PPN(pa)];
c0102686:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c010268c:	8b 45 08             	mov    0x8(%ebp),%eax
c010268f:	c1 e8 0c             	shr    $0xc,%eax
c0102692:	89 c2                	mov    %eax,%edx
c0102694:	89 d0                	mov    %edx,%eax
c0102696:	c1 e0 02             	shl    $0x2,%eax
c0102699:	01 d0                	add    %edx,%eax
c010269b:	c1 e0 02             	shl    $0x2,%eax
c010269e:	01 c8                	add    %ecx,%eax
}
c01026a0:	c9                   	leave  
c01026a1:	c3                   	ret    

c01026a2 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01026a2:	55                   	push   %ebp
c01026a3:	89 e5                	mov    %esp,%ebp
c01026a5:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01026a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ab:	89 04 24             	mov    %eax,(%esp)
c01026ae:	e8 8a ff ff ff       	call   c010263d <page2pa>
c01026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026b9:	c1 e8 0c             	shr    $0xc,%eax
c01026bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01026bf:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01026c4:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01026c7:	72 23                	jb     c01026ec <page2kva+0x4a>
c01026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01026d0:	c7 44 24 08 c0 62 10 	movl   $0xc01062c0,0x8(%esp)
c01026d7:	c0 
c01026d8:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01026df:	00 
c01026e0:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
c01026e7:	e8 f6 dc ff ff       	call   c01003e2 <__panic>
c01026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026ef:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01026f4:	c9                   	leave  
c01026f5:	c3                   	ret    

c01026f6 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01026f6:	55                   	push   %ebp
c01026f7:	89 e5                	mov    %esp,%ebp
c01026f9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01026fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01026ff:	83 e0 01             	and    $0x1,%eax
c0102702:	85 c0                	test   %eax,%eax
c0102704:	75 1c                	jne    c0102722 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102706:	c7 44 24 08 e4 62 10 	movl   $0xc01062e4,0x8(%esp)
c010270d:	c0 
c010270e:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102715:	00 
c0102716:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
c010271d:	e8 c0 dc ff ff       	call   c01003e2 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102722:	8b 45 08             	mov    0x8(%ebp),%eax
c0102725:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010272a:	89 04 24             	mov    %eax,(%esp)
c010272d:	e8 21 ff ff ff       	call   c0102653 <pa2page>
}
c0102732:	c9                   	leave  
c0102733:	c3                   	ret    

c0102734 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102734:	55                   	push   %ebp
c0102735:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102737:	8b 45 08             	mov    0x8(%ebp),%eax
c010273a:	8b 00                	mov    (%eax),%eax
}
c010273c:	5d                   	pop    %ebp
c010273d:	c3                   	ret    

c010273e <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c010273e:	55                   	push   %ebp
c010273f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102741:	8b 45 08             	mov    0x8(%ebp),%eax
c0102744:	8b 00                	mov    (%eax),%eax
c0102746:	8d 50 01             	lea    0x1(%eax),%edx
c0102749:	8b 45 08             	mov    0x8(%ebp),%eax
c010274c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010274e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102751:	8b 00                	mov    (%eax),%eax
}
c0102753:	5d                   	pop    %ebp
c0102754:	c3                   	ret    

c0102755 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102755:	55                   	push   %ebp
c0102756:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102758:	8b 45 08             	mov    0x8(%ebp),%eax
c010275b:	8b 00                	mov    (%eax),%eax
c010275d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102760:	8b 45 08             	mov    0x8(%ebp),%eax
c0102763:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102765:	8b 45 08             	mov    0x8(%ebp),%eax
c0102768:	8b 00                	mov    (%eax),%eax
}
c010276a:	5d                   	pop    %ebp
c010276b:	c3                   	ret    

c010276c <__intr_save>:
__intr_save(void) {
c010276c:	55                   	push   %ebp
c010276d:	89 e5                	mov    %esp,%ebp
c010276f:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102772:	9c                   	pushf  
c0102773:	58                   	pop    %eax
c0102774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102777:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010277a:	25 00 02 00 00       	and    $0x200,%eax
c010277f:	85 c0                	test   %eax,%eax
c0102781:	74 0c                	je     c010278f <__intr_save+0x23>
        intr_disable();
c0102783:	e8 2d f0 ff ff       	call   c01017b5 <intr_disable>
        return 1;
c0102788:	b8 01 00 00 00       	mov    $0x1,%eax
c010278d:	eb 05                	jmp    c0102794 <__intr_save+0x28>
    return 0;
c010278f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102794:	c9                   	leave  
c0102795:	c3                   	ret    

c0102796 <__intr_restore>:
__intr_restore(bool flag) {
c0102796:	55                   	push   %ebp
c0102797:	89 e5                	mov    %esp,%ebp
c0102799:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010279c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01027a0:	74 05                	je     c01027a7 <__intr_restore+0x11>
        intr_enable();
c01027a2:	e8 08 f0 ff ff       	call   c01017af <intr_enable>
}
c01027a7:	c9                   	leave  
c01027a8:	c3                   	ret    

c01027a9 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01027a9:	55                   	push   %ebp
c01027aa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01027ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01027af:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01027b2:	b8 23 00 00 00       	mov    $0x23,%eax
c01027b7:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01027b9:	b8 23 00 00 00       	mov    $0x23,%eax
c01027be:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01027c0:	b8 10 00 00 00       	mov    $0x10,%eax
c01027c5:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01027c7:	b8 10 00 00 00       	mov    $0x10,%eax
c01027cc:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01027ce:	b8 10 00 00 00       	mov    $0x10,%eax
c01027d3:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01027d5:	ea dc 27 10 c0 08 00 	ljmp   $0x8,$0xc01027dc
}
c01027dc:	5d                   	pop    %ebp
c01027dd:	c3                   	ret    

c01027de <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01027de:	55                   	push   %ebp
c01027df:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01027e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e4:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c01027e9:	5d                   	pop    %ebp
c01027ea:	c3                   	ret    

c01027eb <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01027eb:	55                   	push   %ebp
c01027ec:	89 e5                	mov    %esp,%ebp
c01027ee:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01027f1:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c01027f6:	89 04 24             	mov    %eax,(%esp)
c01027f9:	e8 e0 ff ff ff       	call   c01027de <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01027fe:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0102805:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102807:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c010280e:	68 00 
c0102810:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102815:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c010281b:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0102820:	c1 e8 10             	shr    $0x10,%eax
c0102823:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102828:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c010282f:	83 e0 f0             	and    $0xfffffff0,%eax
c0102832:	83 c8 09             	or     $0x9,%eax
c0102835:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c010283a:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102841:	83 e0 ef             	and    $0xffffffef,%eax
c0102844:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102849:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102850:	83 e0 9f             	and    $0xffffff9f,%eax
c0102853:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102858:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c010285f:	83 c8 80             	or     $0xffffff80,%eax
c0102862:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102867:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010286e:	83 e0 f0             	and    $0xfffffff0,%eax
c0102871:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102876:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010287d:	83 e0 ef             	and    $0xffffffef,%eax
c0102880:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102885:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010288c:	83 e0 df             	and    $0xffffffdf,%eax
c010288f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102894:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010289b:	83 c8 40             	or     $0x40,%eax
c010289e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01028a3:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c01028aa:	83 e0 7f             	and    $0x7f,%eax
c01028ad:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01028b2:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c01028b7:	c1 e8 18             	shr    $0x18,%eax
c01028ba:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01028bf:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c01028c6:	e8 de fe ff ff       	call   c01027a9 <lgdt>
c01028cb:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01028d1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01028d5:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01028d8:	c9                   	leave  
c01028d9:	c3                   	ret    

c01028da <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01028da:	55                   	push   %ebp
c01028db:	89 e5                	mov    %esp,%ebp
c01028dd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01028e0:	c7 05 50 89 11 c0 68 	movl   $0xc0106c68,0xc0118950
c01028e7:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01028ea:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01028ef:	8b 00                	mov    (%eax),%eax
c01028f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028f5:	c7 04 24 10 63 10 c0 	movl   $0xc0106310,(%esp)
c01028fc:	e8 8a d9 ff ff       	call   c010028b <cprintf>
    pmm_manager->init();
c0102901:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102906:	8b 40 04             	mov    0x4(%eax),%eax
c0102909:	ff d0                	call   *%eax
}
c010290b:	c9                   	leave  
c010290c:	c3                   	ret    

c010290d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010290d:	55                   	push   %ebp
c010290e:	89 e5                	mov    %esp,%ebp
c0102910:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102913:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102918:	8b 40 08             	mov    0x8(%eax),%eax
c010291b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010291e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102922:	8b 55 08             	mov    0x8(%ebp),%edx
c0102925:	89 14 24             	mov    %edx,(%esp)
c0102928:	ff d0                	call   *%eax
}
c010292a:	c9                   	leave  
c010292b:	c3                   	ret    

c010292c <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c010292c:	55                   	push   %ebp
c010292d:	89 e5                	mov    %esp,%ebp
c010292f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102939:	e8 2e fe ff ff       	call   c010276c <__intr_save>
c010293e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102941:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102946:	8b 40 0c             	mov    0xc(%eax),%eax
c0102949:	8b 55 08             	mov    0x8(%ebp),%edx
c010294c:	89 14 24             	mov    %edx,(%esp)
c010294f:	ff d0                	call   *%eax
c0102951:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102954:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102957:	89 04 24             	mov    %eax,(%esp)
c010295a:	e8 37 fe ff ff       	call   c0102796 <__intr_restore>
    return page;
c010295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102962:	c9                   	leave  
c0102963:	c3                   	ret    

c0102964 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102964:	55                   	push   %ebp
c0102965:	89 e5                	mov    %esp,%ebp
c0102967:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010296a:	e8 fd fd ff ff       	call   c010276c <__intr_save>
c010296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102972:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102977:	8b 40 10             	mov    0x10(%eax),%eax
c010297a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010297d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102981:	8b 55 08             	mov    0x8(%ebp),%edx
c0102984:	89 14 24             	mov    %edx,(%esp)
c0102987:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102989:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010298c:	89 04 24             	mov    %eax,(%esp)
c010298f:	e8 02 fe ff ff       	call   c0102796 <__intr_restore>
}
c0102994:	c9                   	leave  
c0102995:	c3                   	ret    

c0102996 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102996:	55                   	push   %ebp
c0102997:	89 e5                	mov    %esp,%ebp
c0102999:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010299c:	e8 cb fd ff ff       	call   c010276c <__intr_save>
c01029a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01029a4:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01029a9:	8b 40 14             	mov    0x14(%eax),%eax
c01029ac:	ff d0                	call   *%eax
c01029ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b4:	89 04 24             	mov    %eax,(%esp)
c01029b7:	e8 da fd ff ff       	call   c0102796 <__intr_restore>
    return ret;
c01029bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01029bf:	c9                   	leave  
c01029c0:	c3                   	ret    

c01029c1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01029c1:	55                   	push   %ebp
c01029c2:	89 e5                	mov    %esp,%ebp
c01029c4:	57                   	push   %edi
c01029c5:	56                   	push   %esi
c01029c6:	53                   	push   %ebx
c01029c7:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01029cd:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01029d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01029db:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01029e2:	c7 04 24 27 63 10 c0 	movl   $0xc0106327,(%esp)
c01029e9:	e8 9d d8 ff ff       	call   c010028b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01029ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01029f5:	e9 15 01 00 00       	jmp    c0102b0f <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01029fa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01029fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a00:	89 d0                	mov    %edx,%eax
c0102a02:	c1 e0 02             	shl    $0x2,%eax
c0102a05:	01 d0                	add    %edx,%eax
c0102a07:	c1 e0 02             	shl    $0x2,%eax
c0102a0a:	01 c8                	add    %ecx,%eax
c0102a0c:	8b 50 08             	mov    0x8(%eax),%edx
c0102a0f:	8b 40 04             	mov    0x4(%eax),%eax
c0102a12:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102a15:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102a18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102a1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a1e:	89 d0                	mov    %edx,%eax
c0102a20:	c1 e0 02             	shl    $0x2,%eax
c0102a23:	01 d0                	add    %edx,%eax
c0102a25:	c1 e0 02             	shl    $0x2,%eax
c0102a28:	01 c8                	add    %ecx,%eax
c0102a2a:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102a2d:	8b 58 10             	mov    0x10(%eax),%ebx
c0102a30:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102a33:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102a36:	01 c8                	add    %ecx,%eax
c0102a38:	11 da                	adc    %ebx,%edx
c0102a3a:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102a3d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102a40:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102a43:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a46:	89 d0                	mov    %edx,%eax
c0102a48:	c1 e0 02             	shl    $0x2,%eax
c0102a4b:	01 d0                	add    %edx,%eax
c0102a4d:	c1 e0 02             	shl    $0x2,%eax
c0102a50:	01 c8                	add    %ecx,%eax
c0102a52:	83 c0 14             	add    $0x14,%eax
c0102a55:	8b 00                	mov    (%eax),%eax
c0102a57:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0102a5d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102a60:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102a63:	83 c0 ff             	add    $0xffffffff,%eax
c0102a66:	83 d2 ff             	adc    $0xffffffff,%edx
c0102a69:	89 c6                	mov    %eax,%esi
c0102a6b:	89 d7                	mov    %edx,%edi
c0102a6d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102a70:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a73:	89 d0                	mov    %edx,%eax
c0102a75:	c1 e0 02             	shl    $0x2,%eax
c0102a78:	01 d0                	add    %edx,%eax
c0102a7a:	c1 e0 02             	shl    $0x2,%eax
c0102a7d:	01 c8                	add    %ecx,%eax
c0102a7f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102a82:	8b 58 10             	mov    0x10(%eax),%ebx
c0102a85:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102a8b:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0102a8f:	89 74 24 14          	mov    %esi,0x14(%esp)
c0102a93:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0102a97:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102a9a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102a9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102aa1:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102aa5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102aa9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102aad:	c7 04 24 34 63 10 c0 	movl   $0xc0106334,(%esp)
c0102ab4:	e8 d2 d7 ff ff       	call   c010028b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102ab9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102abf:	89 d0                	mov    %edx,%eax
c0102ac1:	c1 e0 02             	shl    $0x2,%eax
c0102ac4:	01 d0                	add    %edx,%eax
c0102ac6:	c1 e0 02             	shl    $0x2,%eax
c0102ac9:	01 c8                	add    %ecx,%eax
c0102acb:	83 c0 14             	add    $0x14,%eax
c0102ace:	8b 00                	mov    (%eax),%eax
c0102ad0:	83 f8 01             	cmp    $0x1,%eax
c0102ad3:	75 36                	jne    c0102b0b <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0102ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ad8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102adb:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102ade:	77 2b                	ja     c0102b0b <page_init+0x14a>
c0102ae0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102ae3:	72 05                	jb     c0102aea <page_init+0x129>
c0102ae5:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102ae8:	73 21                	jae    c0102b0b <page_init+0x14a>
c0102aea:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102aee:	77 1b                	ja     c0102b0b <page_init+0x14a>
c0102af0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102af4:	72 09                	jb     c0102aff <page_init+0x13e>
c0102af6:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102afd:	77 0c                	ja     c0102b0b <page_init+0x14a>
                maxpa = end;
c0102aff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102b02:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b05:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102b08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102b0b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102b0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b12:	8b 00                	mov    (%eax),%eax
c0102b14:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102b17:	0f 8f dd fe ff ff    	jg     c01029fa <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102b1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102b21:	72 1d                	jb     c0102b40 <page_init+0x17f>
c0102b23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102b27:	77 09                	ja     c0102b32 <page_init+0x171>
c0102b29:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102b30:	76 0e                	jbe    c0102b40 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0102b32:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102b39:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102b46:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102b4a:	c1 ea 0c             	shr    $0xc,%edx
c0102b4d:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102b52:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102b59:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0102b5e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102b61:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b64:	01 d0                	add    %edx,%eax
c0102b66:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102b69:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102b6c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102b71:	f7 75 ac             	divl   -0x54(%ebp)
c0102b74:	89 d0                	mov    %edx,%eax
c0102b76:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102b79:	29 c2                	sub    %eax,%edx
c0102b7b:	89 d0                	mov    %edx,%eax
c0102b7d:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    for (i = 0; i < npage; i ++) {
c0102b82:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102b89:	eb 2f                	jmp    c0102bba <page_init+0x1f9>
        SetPageReserved(pages + i);
c0102b8b:	8b 0d 58 89 11 c0    	mov    0xc0118958,%ecx
c0102b91:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b94:	89 d0                	mov    %edx,%eax
c0102b96:	c1 e0 02             	shl    $0x2,%eax
c0102b99:	01 d0                	add    %edx,%eax
c0102b9b:	c1 e0 02             	shl    $0x2,%eax
c0102b9e:	01 c8                	add    %ecx,%eax
c0102ba0:	83 c0 04             	add    $0x4,%eax
c0102ba3:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102baa:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bad:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102bb0:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102bb3:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102bb6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102bba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102bbd:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0102bc2:	39 c2                	cmp    %eax,%edx
c0102bc4:	72 c5                	jb     c0102b8b <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102bc6:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102bcc:	89 d0                	mov    %edx,%eax
c0102bce:	c1 e0 02             	shl    $0x2,%eax
c0102bd1:	01 d0                	add    %edx,%eax
c0102bd3:	c1 e0 02             	shl    $0x2,%eax
c0102bd6:	89 c2                	mov    %eax,%edx
c0102bd8:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102bdd:	01 d0                	add    %edx,%eax
c0102bdf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102be2:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102be9:	77 23                	ja     c0102c0e <page_init+0x24d>
c0102beb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102bee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102bf2:	c7 44 24 08 64 63 10 	movl   $0xc0106364,0x8(%esp)
c0102bf9:	c0 
c0102bfa:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0102c01:	00 
c0102c02:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0102c09:	e8 d4 d7 ff ff       	call   c01003e2 <__panic>
c0102c0e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102c11:	05 00 00 00 40       	add    $0x40000000,%eax
c0102c16:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102c19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c20:	e9 74 01 00 00       	jmp    c0102d99 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c25:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c28:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c2b:	89 d0                	mov    %edx,%eax
c0102c2d:	c1 e0 02             	shl    $0x2,%eax
c0102c30:	01 d0                	add    %edx,%eax
c0102c32:	c1 e0 02             	shl    $0x2,%eax
c0102c35:	01 c8                	add    %ecx,%eax
c0102c37:	8b 50 08             	mov    0x8(%eax),%edx
c0102c3a:	8b 40 04             	mov    0x4(%eax),%eax
c0102c3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102c40:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102c43:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c46:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c49:	89 d0                	mov    %edx,%eax
c0102c4b:	c1 e0 02             	shl    $0x2,%eax
c0102c4e:	01 d0                	add    %edx,%eax
c0102c50:	c1 e0 02             	shl    $0x2,%eax
c0102c53:	01 c8                	add    %ecx,%eax
c0102c55:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102c58:	8b 58 10             	mov    0x10(%eax),%ebx
c0102c5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c61:	01 c8                	add    %ecx,%eax
c0102c63:	11 da                	adc    %ebx,%edx
c0102c65:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102c68:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102c6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c71:	89 d0                	mov    %edx,%eax
c0102c73:	c1 e0 02             	shl    $0x2,%eax
c0102c76:	01 d0                	add    %edx,%eax
c0102c78:	c1 e0 02             	shl    $0x2,%eax
c0102c7b:	01 c8                	add    %ecx,%eax
c0102c7d:	83 c0 14             	add    $0x14,%eax
c0102c80:	8b 00                	mov    (%eax),%eax
c0102c82:	83 f8 01             	cmp    $0x1,%eax
c0102c85:	0f 85 0a 01 00 00    	jne    c0102d95 <page_init+0x3d4>
            if (begin < freemem) {
c0102c8b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102c8e:	ba 00 00 00 00       	mov    $0x0,%edx
c0102c93:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102c96:	72 17                	jb     c0102caf <page_init+0x2ee>
c0102c98:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102c9b:	77 05                	ja     c0102ca2 <page_init+0x2e1>
c0102c9d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102ca0:	76 0d                	jbe    c0102caf <page_init+0x2ee>
                begin = freemem;
c0102ca2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ca8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102caf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102cb3:	72 1d                	jb     c0102cd2 <page_init+0x311>
c0102cb5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102cb9:	77 09                	ja     c0102cc4 <page_init+0x303>
c0102cbb:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102cc2:	76 0e                	jbe    c0102cd2 <page_init+0x311>
                end = KMEMSIZE;
c0102cc4:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102ccb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102cd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cd8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102cdb:	0f 87 b4 00 00 00    	ja     c0102d95 <page_init+0x3d4>
c0102ce1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102ce4:	72 09                	jb     c0102cef <page_init+0x32e>
c0102ce6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102ce9:	0f 83 a6 00 00 00    	jae    c0102d95 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0102cef:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102cf6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cf9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102cfc:	01 d0                	add    %edx,%eax
c0102cfe:	83 e8 01             	sub    $0x1,%eax
c0102d01:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102d04:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102d07:	ba 00 00 00 00       	mov    $0x0,%edx
c0102d0c:	f7 75 9c             	divl   -0x64(%ebp)
c0102d0f:	89 d0                	mov    %edx,%eax
c0102d11:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102d14:	29 c2                	sub    %eax,%edx
c0102d16:	89 d0                	mov    %edx,%eax
c0102d18:	ba 00 00 00 00       	mov    $0x0,%edx
c0102d1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102d20:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102d23:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d26:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102d29:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102d2c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102d31:	89 c7                	mov    %eax,%edi
c0102d33:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0102d39:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0102d3c:	89 d0                	mov    %edx,%eax
c0102d3e:	83 e0 00             	and    $0x0,%eax
c0102d41:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102d44:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102d47:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102d4a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d4d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0102d50:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d53:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d56:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102d59:	77 3a                	ja     c0102d95 <page_init+0x3d4>
c0102d5b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102d5e:	72 05                	jb     c0102d65 <page_init+0x3a4>
c0102d60:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102d63:	73 30                	jae    c0102d95 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102d65:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0102d68:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0102d6b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d6e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d71:	29 c8                	sub    %ecx,%eax
c0102d73:	19 da                	sbb    %ebx,%edx
c0102d75:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102d79:	c1 ea 0c             	shr    $0xc,%edx
c0102d7c:	89 c3                	mov    %eax,%ebx
c0102d7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d81:	89 04 24             	mov    %eax,(%esp)
c0102d84:	e8 ca f8 ff ff       	call   c0102653 <pa2page>
c0102d89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102d8d:	89 04 24             	mov    %eax,(%esp)
c0102d90:	e8 78 fb ff ff       	call   c010290d <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d95:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102d99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d9c:	8b 00                	mov    (%eax),%eax
c0102d9e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102da1:	0f 8f 7e fe ff ff    	jg     c0102c25 <page_init+0x264>
                }
            }
        }
    }
}
c0102da7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0102dad:	5b                   	pop    %ebx
c0102dae:	5e                   	pop    %esi
c0102daf:	5f                   	pop    %edi
c0102db0:	5d                   	pop    %ebp
c0102db1:	c3                   	ret    

c0102db2 <enable_paging>:

static void
enable_paging(void) {
c0102db2:	55                   	push   %ebp
c0102db3:	89 e5                	mov    %esp,%ebp
c0102db5:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0102db8:	a1 54 89 11 c0       	mov    0xc0118954,%eax
c0102dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0102dc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102dc3:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0102dc6:	0f 20 c0             	mov    %cr0,%eax
c0102dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0102dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0102dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0102dd2:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0102dd9:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0102ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0102de3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102de6:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0102de9:	c9                   	leave  
c0102dea:	c3                   	ret    

c0102deb <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0102deb:	55                   	push   %ebp
c0102dec:	89 e5                	mov    %esp,%ebp
c0102dee:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0102df1:	8b 45 14             	mov    0x14(%ebp),%eax
c0102df4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102df7:	31 d0                	xor    %edx,%eax
c0102df9:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102dfe:	85 c0                	test   %eax,%eax
c0102e00:	74 24                	je     c0102e26 <boot_map_segment+0x3b>
c0102e02:	c7 44 24 0c 96 63 10 	movl   $0xc0106396,0xc(%esp)
c0102e09:	c0 
c0102e0a:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0102e11:	c0 
c0102e12:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0102e19:	00 
c0102e1a:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0102e21:	e8 bc d5 ff ff       	call   c01003e2 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0102e26:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0102e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e30:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102e35:	89 c2                	mov    %eax,%edx
c0102e37:	8b 45 10             	mov    0x10(%ebp),%eax
c0102e3a:	01 c2                	add    %eax,%edx
c0102e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e3f:	01 d0                	add    %edx,%eax
c0102e41:	83 e8 01             	sub    $0x1,%eax
c0102e44:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e4a:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e4f:	f7 75 f0             	divl   -0x10(%ebp)
c0102e52:	89 d0                	mov    %edx,%eax
c0102e54:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102e57:	29 c2                	sub    %eax,%edx
c0102e59:	89 d0                	mov    %edx,%eax
c0102e5b:	c1 e8 0c             	shr    $0xc,%eax
c0102e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0102e61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e64:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102e6f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0102e72:	8b 45 14             	mov    0x14(%ebp),%eax
c0102e75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102e7b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102e80:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0102e83:	eb 6b                	jmp    c0102ef0 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0102e85:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0102e8c:	00 
c0102e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102e94:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e97:	89 04 24             	mov    %eax,(%esp)
c0102e9a:	e8 cc 01 00 00       	call   c010306b <get_pte>
c0102e9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0102ea2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102ea6:	75 24                	jne    c0102ecc <boot_map_segment+0xe1>
c0102ea8:	c7 44 24 0c c2 63 10 	movl   $0xc01063c2,0xc(%esp)
c0102eaf:	c0 
c0102eb0:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0102eb7:	c0 
c0102eb8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0102ebf:	00 
c0102ec0:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0102ec7:	e8 16 d5 ff ff       	call   c01003e2 <__panic>
        *ptep = pa | PTE_P | perm;
c0102ecc:	8b 45 18             	mov    0x18(%ebp),%eax
c0102ecf:	8b 55 14             	mov    0x14(%ebp),%edx
c0102ed2:	09 d0                	or     %edx,%eax
c0102ed4:	83 c8 01             	or     $0x1,%eax
c0102ed7:	89 c2                	mov    %eax,%edx
c0102ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102edc:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0102ede:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0102ee2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0102ee9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0102ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ef4:	75 8f                	jne    c0102e85 <boot_map_segment+0x9a>
    }
}
c0102ef6:	c9                   	leave  
c0102ef7:	c3                   	ret    

c0102ef8 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0102ef8:	55                   	push   %ebp
c0102ef9:	89 e5                	mov    %esp,%ebp
c0102efb:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0102efe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f05:	e8 22 fa ff ff       	call   c010292c <alloc_pages>
c0102f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0102f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f11:	75 1c                	jne    c0102f2f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0102f13:	c7 44 24 08 cf 63 10 	movl   $0xc01063cf,0x8(%esp)
c0102f1a:	c0 
c0102f1b:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0102f22:	00 
c0102f23:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0102f2a:	e8 b3 d4 ff ff       	call   c01003e2 <__panic>
    }
    return page2kva(p);
c0102f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f32:	89 04 24             	mov    %eax,(%esp)
c0102f35:	e8 68 f7 ff ff       	call   c01026a2 <page2kva>
}
c0102f3a:	c9                   	leave  
c0102f3b:	c3                   	ret    

c0102f3c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0102f3c:	55                   	push   %ebp
c0102f3d:	89 e5                	mov    %esp,%ebp
c0102f3f:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0102f42:	e8 93 f9 ff ff       	call   c01028da <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0102f47:	e8 75 fa ff ff       	call   c01029c1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0102f4c:	e8 d7 02 00 00       	call   c0103228 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0102f51:	e8 a2 ff ff ff       	call   c0102ef8 <boot_alloc_page>
c0102f56:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0102f5b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0102f60:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0102f67:	00 
c0102f68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102f6f:	00 
c0102f70:	89 04 24             	mov    %eax,(%esp)
c0102f73:	e8 20 24 00 00       	call   c0105398 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0102f78:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0102f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f80:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0102f87:	77 23                	ja     c0102fac <pmm_init+0x70>
c0102f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f8c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102f90:	c7 44 24 08 64 63 10 	movl   $0xc0106364,0x8(%esp)
c0102f97:	c0 
c0102f98:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0102f9f:	00 
c0102fa0:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0102fa7:	e8 36 d4 ff ff       	call   c01003e2 <__panic>
c0102fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102faf:	05 00 00 00 40       	add    $0x40000000,%eax
c0102fb4:	a3 54 89 11 c0       	mov    %eax,0xc0118954

    check_pgdir();
c0102fb9:	e8 88 02 00 00       	call   c0103246 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0102fbe:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0102fc3:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0102fc9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0102fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102fd1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0102fd8:	77 23                	ja     c0102ffd <pmm_init+0xc1>
c0102fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fdd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102fe1:	c7 44 24 08 64 63 10 	movl   $0xc0106364,0x8(%esp)
c0102fe8:	c0 
c0102fe9:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0102ff0:	00 
c0102ff1:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0102ff8:	e8 e5 d3 ff ff       	call   c01003e2 <__panic>
c0102ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103000:	05 00 00 00 40       	add    $0x40000000,%eax
c0103005:	83 c8 03             	or     $0x3,%eax
c0103008:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010300a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010300f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0103016:	00 
c0103017:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010301e:	00 
c010301f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0103026:	38 
c0103027:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010302e:	c0 
c010302f:	89 04 24             	mov    %eax,(%esp)
c0103032:	e8 b4 fd ff ff       	call   c0102deb <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0103037:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010303c:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0103042:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0103048:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010304a:	e8 63 fd ff ff       	call   c0102db2 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010304f:	e8 97 f7 ff ff       	call   c01027eb <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0103054:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010305f:	e8 7d 08 00 00       	call   c01038e1 <check_boot_pgdir>

    print_pgdir();
c0103064:	e8 0a 0d 00 00       	call   c0103d73 <print_pgdir>

}
c0103069:	c9                   	leave  
c010306a:	c3                   	ret    

c010306b <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010306b:	55                   	push   %ebp
c010306c:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010306e:	5d                   	pop    %ebp
c010306f:	c3                   	ret    

c0103070 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0103070:	55                   	push   %ebp
c0103071:	89 e5                	mov    %esp,%ebp
c0103073:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010307d:	00 
c010307e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103081:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103085:	8b 45 08             	mov    0x8(%ebp),%eax
c0103088:	89 04 24             	mov    %eax,(%esp)
c010308b:	e8 db ff ff ff       	call   c010306b <get_pte>
c0103090:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103097:	74 08                	je     c01030a1 <get_page+0x31>
        *ptep_store = ptep;
c0103099:	8b 45 10             	mov    0x10(%ebp),%eax
c010309c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010309f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030a5:	74 1b                	je     c01030c2 <get_page+0x52>
c01030a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030aa:	8b 00                	mov    (%eax),%eax
c01030ac:	83 e0 01             	and    $0x1,%eax
c01030af:	85 c0                	test   %eax,%eax
c01030b1:	74 0f                	je     c01030c2 <get_page+0x52>
        return pa2page(*ptep);
c01030b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030b6:	8b 00                	mov    (%eax),%eax
c01030b8:	89 04 24             	mov    %eax,(%esp)
c01030bb:	e8 93 f5 ff ff       	call   c0102653 <pa2page>
c01030c0:	eb 05                	jmp    c01030c7 <get_page+0x57>
    }
    return NULL;
c01030c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01030c7:	c9                   	leave  
c01030c8:	c3                   	ret    

c01030c9 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01030c9:	55                   	push   %ebp
c01030ca:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01030cc:	5d                   	pop    %ebp
c01030cd:	c3                   	ret    

c01030ce <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01030ce:	55                   	push   %ebp
c01030cf:	89 e5                	mov    %esp,%ebp
c01030d1:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01030d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01030db:	00 
c01030dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01030e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01030e6:	89 04 24             	mov    %eax,(%esp)
c01030e9:	e8 7d ff ff ff       	call   c010306b <get_pte>
c01030ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01030f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01030f5:	74 19                	je     c0103110 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01030f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01030fa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01030fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103101:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103105:	8b 45 08             	mov    0x8(%ebp),%eax
c0103108:	89 04 24             	mov    %eax,(%esp)
c010310b:	e8 b9 ff ff ff       	call   c01030c9 <page_remove_pte>
    }
}
c0103110:	c9                   	leave  
c0103111:	c3                   	ret    

c0103112 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103112:	55                   	push   %ebp
c0103113:	89 e5                	mov    %esp,%ebp
c0103115:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103118:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010311f:	00 
c0103120:	8b 45 10             	mov    0x10(%ebp),%eax
c0103123:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103127:	8b 45 08             	mov    0x8(%ebp),%eax
c010312a:	89 04 24             	mov    %eax,(%esp)
c010312d:	e8 39 ff ff ff       	call   c010306b <get_pte>
c0103132:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103139:	75 0a                	jne    c0103145 <page_insert+0x33>
        return -E_NO_MEM;
c010313b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103140:	e9 84 00 00 00       	jmp    c01031c9 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0103145:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103148:	89 04 24             	mov    %eax,(%esp)
c010314b:	e8 ee f5 ff ff       	call   c010273e <page_ref_inc>
    if (*ptep & PTE_P) {
c0103150:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103153:	8b 00                	mov    (%eax),%eax
c0103155:	83 e0 01             	and    $0x1,%eax
c0103158:	85 c0                	test   %eax,%eax
c010315a:	74 3e                	je     c010319a <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010315f:	8b 00                	mov    (%eax),%eax
c0103161:	89 04 24             	mov    %eax,(%esp)
c0103164:	e8 8d f5 ff ff       	call   c01026f6 <pte2page>
c0103169:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010316c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010316f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103172:	75 0d                	jne    c0103181 <page_insert+0x6f>
            page_ref_dec(page);
c0103174:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103177:	89 04 24             	mov    %eax,(%esp)
c010317a:	e8 d6 f5 ff ff       	call   c0102755 <page_ref_dec>
c010317f:	eb 19                	jmp    c010319a <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0103181:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103184:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103188:	8b 45 10             	mov    0x10(%ebp),%eax
c010318b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010318f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103192:	89 04 24             	mov    %eax,(%esp)
c0103195:	e8 2f ff ff ff       	call   c01030c9 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010319a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010319d:	89 04 24             	mov    %eax,(%esp)
c01031a0:	e8 98 f4 ff ff       	call   c010263d <page2pa>
c01031a5:	0b 45 14             	or     0x14(%ebp),%eax
c01031a8:	83 c8 01             	or     $0x1,%eax
c01031ab:	89 c2                	mov    %eax,%edx
c01031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031b0:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01031b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01031b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01031b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01031bc:	89 04 24             	mov    %eax,(%esp)
c01031bf:	e8 07 00 00 00       	call   c01031cb <tlb_invalidate>
    return 0;
c01031c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01031c9:	c9                   	leave  
c01031ca:	c3                   	ret    

c01031cb <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01031cb:	55                   	push   %ebp
c01031cc:	89 e5                	mov    %esp,%ebp
c01031ce:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01031d1:	0f 20 d8             	mov    %cr3,%eax
c01031d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01031d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01031da:	89 c2                	mov    %eax,%edx
c01031dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01031df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031e2:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01031e9:	77 23                	ja     c010320e <tlb_invalidate+0x43>
c01031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01031f2:	c7 44 24 08 64 63 10 	movl   $0xc0106364,0x8(%esp)
c01031f9:	c0 
c01031fa:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0103201:	00 
c0103202:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103209:	e8 d4 d1 ff ff       	call   c01003e2 <__panic>
c010320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103211:	05 00 00 00 40       	add    $0x40000000,%eax
c0103216:	39 c2                	cmp    %eax,%edx
c0103218:	75 0c                	jne    c0103226 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010321a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010321d:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0103220:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103223:	0f 01 38             	invlpg (%eax)
    }
}
c0103226:	c9                   	leave  
c0103227:	c3                   	ret    

c0103228 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103228:	55                   	push   %ebp
c0103229:	89 e5                	mov    %esp,%ebp
c010322b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010322e:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103233:	8b 40 18             	mov    0x18(%eax),%eax
c0103236:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103238:	c7 04 24 e8 63 10 c0 	movl   $0xc01063e8,(%esp)
c010323f:	e8 47 d0 ff ff       	call   c010028b <cprintf>
}
c0103244:	c9                   	leave  
c0103245:	c3                   	ret    

c0103246 <check_pgdir>:

static void
check_pgdir(void) {
c0103246:	55                   	push   %ebp
c0103247:	89 e5                	mov    %esp,%ebp
c0103249:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010324c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103251:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0103256:	76 24                	jbe    c010327c <check_pgdir+0x36>
c0103258:	c7 44 24 0c 07 64 10 	movl   $0xc0106407,0xc(%esp)
c010325f:	c0 
c0103260:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103267:	c0 
c0103268:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c010326f:	00 
c0103270:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103277:	e8 66 d1 ff ff       	call   c01003e2 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010327c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103281:	85 c0                	test   %eax,%eax
c0103283:	74 0e                	je     c0103293 <check_pgdir+0x4d>
c0103285:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010328a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010328f:	85 c0                	test   %eax,%eax
c0103291:	74 24                	je     c01032b7 <check_pgdir+0x71>
c0103293:	c7 44 24 0c 24 64 10 	movl   $0xc0106424,0xc(%esp)
c010329a:	c0 
c010329b:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01032a2:	c0 
c01032a3:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c01032aa:	00 
c01032ab:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01032b2:	e8 2b d1 ff ff       	call   c01003e2 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01032b7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01032bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01032c3:	00 
c01032c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032cb:	00 
c01032cc:	89 04 24             	mov    %eax,(%esp)
c01032cf:	e8 9c fd ff ff       	call   c0103070 <get_page>
c01032d4:	85 c0                	test   %eax,%eax
c01032d6:	74 24                	je     c01032fc <check_pgdir+0xb6>
c01032d8:	c7 44 24 0c 5c 64 10 	movl   $0xc010645c,0xc(%esp)
c01032df:	c0 
c01032e0:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01032e7:	c0 
c01032e8:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c01032ef:	00 
c01032f0:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01032f7:	e8 e6 d0 ff ff       	call   c01003e2 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01032fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103303:	e8 24 f6 ff ff       	call   c010292c <alloc_pages>
c0103308:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010330b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103310:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103317:	00 
c0103318:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010331f:	00 
c0103320:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103323:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103327:	89 04 24             	mov    %eax,(%esp)
c010332a:	e8 e3 fd ff ff       	call   c0103112 <page_insert>
c010332f:	85 c0                	test   %eax,%eax
c0103331:	74 24                	je     c0103357 <check_pgdir+0x111>
c0103333:	c7 44 24 0c 84 64 10 	movl   $0xc0106484,0xc(%esp)
c010333a:	c0 
c010333b:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103342:	c0 
c0103343:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c010334a:	00 
c010334b:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103352:	e8 8b d0 ff ff       	call   c01003e2 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103357:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010335c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103363:	00 
c0103364:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010336b:	00 
c010336c:	89 04 24             	mov    %eax,(%esp)
c010336f:	e8 f7 fc ff ff       	call   c010306b <get_pte>
c0103374:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010337b:	75 24                	jne    c01033a1 <check_pgdir+0x15b>
c010337d:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c0103384:	c0 
c0103385:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c010338c:	c0 
c010338d:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0103394:	00 
c0103395:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010339c:	e8 41 d0 ff ff       	call   c01003e2 <__panic>
    assert(pa2page(*ptep) == p1);
c01033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033a4:	8b 00                	mov    (%eax),%eax
c01033a6:	89 04 24             	mov    %eax,(%esp)
c01033a9:	e8 a5 f2 ff ff       	call   c0102653 <pa2page>
c01033ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01033b1:	74 24                	je     c01033d7 <check_pgdir+0x191>
c01033b3:	c7 44 24 0c dd 64 10 	movl   $0xc01064dd,0xc(%esp)
c01033ba:	c0 
c01033bb:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01033c2:	c0 
c01033c3:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01033ca:	00 
c01033cb:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01033d2:	e8 0b d0 ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p1) == 1);
c01033d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033da:	89 04 24             	mov    %eax,(%esp)
c01033dd:	e8 52 f3 ff ff       	call   c0102734 <page_ref>
c01033e2:	83 f8 01             	cmp    $0x1,%eax
c01033e5:	74 24                	je     c010340b <check_pgdir+0x1c5>
c01033e7:	c7 44 24 0c f2 64 10 	movl   $0xc01064f2,0xc(%esp)
c01033ee:	c0 
c01033ef:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01033f6:	c0 
c01033f7:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c01033fe:	00 
c01033ff:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103406:	e8 d7 cf ff ff       	call   c01003e2 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010340b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103410:	8b 00                	mov    (%eax),%eax
c0103412:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103417:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010341a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010341d:	c1 e8 0c             	shr    $0xc,%eax
c0103420:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103423:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103428:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010342b:	72 23                	jb     c0103450 <check_pgdir+0x20a>
c010342d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103430:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103434:	c7 44 24 08 c0 62 10 	movl   $0xc01062c0,0x8(%esp)
c010343b:	c0 
c010343c:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c0103443:	00 
c0103444:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010344b:	e8 92 cf ff ff       	call   c01003e2 <__panic>
c0103450:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103453:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103458:	83 c0 04             	add    $0x4,%eax
c010345b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010345e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103463:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010346a:	00 
c010346b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103472:	00 
c0103473:	89 04 24             	mov    %eax,(%esp)
c0103476:	e8 f0 fb ff ff       	call   c010306b <get_pte>
c010347b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010347e:	74 24                	je     c01034a4 <check_pgdir+0x25e>
c0103480:	c7 44 24 0c 04 65 10 	movl   $0xc0106504,0xc(%esp)
c0103487:	c0 
c0103488:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c010348f:	c0 
c0103490:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0103497:	00 
c0103498:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010349f:	e8 3e cf ff ff       	call   c01003e2 <__panic>

    p2 = alloc_page();
c01034a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034ab:	e8 7c f4 ff ff       	call   c010292c <alloc_pages>
c01034b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01034b3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01034b8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01034bf:	00 
c01034c0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01034c7:	00 
c01034c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01034cb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01034cf:	89 04 24             	mov    %eax,(%esp)
c01034d2:	e8 3b fc ff ff       	call   c0103112 <page_insert>
c01034d7:	85 c0                	test   %eax,%eax
c01034d9:	74 24                	je     c01034ff <check_pgdir+0x2b9>
c01034db:	c7 44 24 0c 2c 65 10 	movl   $0xc010652c,0xc(%esp)
c01034e2:	c0 
c01034e3:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01034ea:	c0 
c01034eb:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c01034f2:	00 
c01034f3:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01034fa:	e8 e3 ce ff ff       	call   c01003e2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01034ff:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103504:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010350b:	00 
c010350c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103513:	00 
c0103514:	89 04 24             	mov    %eax,(%esp)
c0103517:	e8 4f fb ff ff       	call   c010306b <get_pte>
c010351c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010351f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103523:	75 24                	jne    c0103549 <check_pgdir+0x303>
c0103525:	c7 44 24 0c 64 65 10 	movl   $0xc0106564,0xc(%esp)
c010352c:	c0 
c010352d:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103534:	c0 
c0103535:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010353c:	00 
c010353d:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103544:	e8 99 ce ff ff       	call   c01003e2 <__panic>
    assert(*ptep & PTE_U);
c0103549:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010354c:	8b 00                	mov    (%eax),%eax
c010354e:	83 e0 04             	and    $0x4,%eax
c0103551:	85 c0                	test   %eax,%eax
c0103553:	75 24                	jne    c0103579 <check_pgdir+0x333>
c0103555:	c7 44 24 0c 94 65 10 	movl   $0xc0106594,0xc(%esp)
c010355c:	c0 
c010355d:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103564:	c0 
c0103565:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c010356c:	00 
c010356d:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103574:	e8 69 ce ff ff       	call   c01003e2 <__panic>
    assert(*ptep & PTE_W);
c0103579:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010357c:	8b 00                	mov    (%eax),%eax
c010357e:	83 e0 02             	and    $0x2,%eax
c0103581:	85 c0                	test   %eax,%eax
c0103583:	75 24                	jne    c01035a9 <check_pgdir+0x363>
c0103585:	c7 44 24 0c a2 65 10 	movl   $0xc01065a2,0xc(%esp)
c010358c:	c0 
c010358d:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103594:	c0 
c0103595:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c010359c:	00 
c010359d:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01035a4:	e8 39 ce ff ff       	call   c01003e2 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01035a9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01035ae:	8b 00                	mov    (%eax),%eax
c01035b0:	83 e0 04             	and    $0x4,%eax
c01035b3:	85 c0                	test   %eax,%eax
c01035b5:	75 24                	jne    c01035db <check_pgdir+0x395>
c01035b7:	c7 44 24 0c b0 65 10 	movl   $0xc01065b0,0xc(%esp)
c01035be:	c0 
c01035bf:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01035c6:	c0 
c01035c7:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c01035ce:	00 
c01035cf:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01035d6:	e8 07 ce ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p2) == 1);
c01035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035de:	89 04 24             	mov    %eax,(%esp)
c01035e1:	e8 4e f1 ff ff       	call   c0102734 <page_ref>
c01035e6:	83 f8 01             	cmp    $0x1,%eax
c01035e9:	74 24                	je     c010360f <check_pgdir+0x3c9>
c01035eb:	c7 44 24 0c c6 65 10 	movl   $0xc01065c6,0xc(%esp)
c01035f2:	c0 
c01035f3:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01035fa:	c0 
c01035fb:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103602:	00 
c0103603:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010360a:	e8 d3 cd ff ff       	call   c01003e2 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010360f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103614:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010361b:	00 
c010361c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103623:	00 
c0103624:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103627:	89 54 24 04          	mov    %edx,0x4(%esp)
c010362b:	89 04 24             	mov    %eax,(%esp)
c010362e:	e8 df fa ff ff       	call   c0103112 <page_insert>
c0103633:	85 c0                	test   %eax,%eax
c0103635:	74 24                	je     c010365b <check_pgdir+0x415>
c0103637:	c7 44 24 0c d8 65 10 	movl   $0xc01065d8,0xc(%esp)
c010363e:	c0 
c010363f:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103646:	c0 
c0103647:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c010364e:	00 
c010364f:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103656:	e8 87 cd ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p1) == 2);
c010365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010365e:	89 04 24             	mov    %eax,(%esp)
c0103661:	e8 ce f0 ff ff       	call   c0102734 <page_ref>
c0103666:	83 f8 02             	cmp    $0x2,%eax
c0103669:	74 24                	je     c010368f <check_pgdir+0x449>
c010366b:	c7 44 24 0c 04 66 10 	movl   $0xc0106604,0xc(%esp)
c0103672:	c0 
c0103673:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c010367a:	c0 
c010367b:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0103682:	00 
c0103683:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010368a:	e8 53 cd ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p2) == 0);
c010368f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103692:	89 04 24             	mov    %eax,(%esp)
c0103695:	e8 9a f0 ff ff       	call   c0102734 <page_ref>
c010369a:	85 c0                	test   %eax,%eax
c010369c:	74 24                	je     c01036c2 <check_pgdir+0x47c>
c010369e:	c7 44 24 0c 16 66 10 	movl   $0xc0106616,0xc(%esp)
c01036a5:	c0 
c01036a6:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01036ad:	c0 
c01036ae:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01036b5:	00 
c01036b6:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01036bd:	e8 20 cd ff ff       	call   c01003e2 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01036c2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01036c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036ce:	00 
c01036cf:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01036d6:	00 
c01036d7:	89 04 24             	mov    %eax,(%esp)
c01036da:	e8 8c f9 ff ff       	call   c010306b <get_pte>
c01036df:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01036e6:	75 24                	jne    c010370c <check_pgdir+0x4c6>
c01036e8:	c7 44 24 0c 64 65 10 	movl   $0xc0106564,0xc(%esp)
c01036ef:	c0 
c01036f0:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01036f7:	c0 
c01036f8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c01036ff:	00 
c0103700:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103707:	e8 d6 cc ff ff       	call   c01003e2 <__panic>
    assert(pa2page(*ptep) == p1);
c010370c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010370f:	8b 00                	mov    (%eax),%eax
c0103711:	89 04 24             	mov    %eax,(%esp)
c0103714:	e8 3a ef ff ff       	call   c0102653 <pa2page>
c0103719:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010371c:	74 24                	je     c0103742 <check_pgdir+0x4fc>
c010371e:	c7 44 24 0c dd 64 10 	movl   $0xc01064dd,0xc(%esp)
c0103725:	c0 
c0103726:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c010372d:	c0 
c010372e:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103735:	00 
c0103736:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010373d:	e8 a0 cc ff ff       	call   c01003e2 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103742:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103745:	8b 00                	mov    (%eax),%eax
c0103747:	83 e0 04             	and    $0x4,%eax
c010374a:	85 c0                	test   %eax,%eax
c010374c:	74 24                	je     c0103772 <check_pgdir+0x52c>
c010374e:	c7 44 24 0c 28 66 10 	movl   $0xc0106628,0xc(%esp)
c0103755:	c0 
c0103756:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c010375d:	c0 
c010375e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103765:	00 
c0103766:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010376d:	e8 70 cc ff ff       	call   c01003e2 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103772:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103777:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010377e:	00 
c010377f:	89 04 24             	mov    %eax,(%esp)
c0103782:	e8 47 f9 ff ff       	call   c01030ce <page_remove>
    assert(page_ref(p1) == 1);
c0103787:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010378a:	89 04 24             	mov    %eax,(%esp)
c010378d:	e8 a2 ef ff ff       	call   c0102734 <page_ref>
c0103792:	83 f8 01             	cmp    $0x1,%eax
c0103795:	74 24                	je     c01037bb <check_pgdir+0x575>
c0103797:	c7 44 24 0c f2 64 10 	movl   $0xc01064f2,0xc(%esp)
c010379e:	c0 
c010379f:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01037a6:	c0 
c01037a7:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c01037ae:	00 
c01037af:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01037b6:	e8 27 cc ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p2) == 0);
c01037bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037be:	89 04 24             	mov    %eax,(%esp)
c01037c1:	e8 6e ef ff ff       	call   c0102734 <page_ref>
c01037c6:	85 c0                	test   %eax,%eax
c01037c8:	74 24                	je     c01037ee <check_pgdir+0x5a8>
c01037ca:	c7 44 24 0c 16 66 10 	movl   $0xc0106616,0xc(%esp)
c01037d1:	c0 
c01037d2:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01037d9:	c0 
c01037da:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c01037e1:	00 
c01037e2:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01037e9:	e8 f4 cb ff ff       	call   c01003e2 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01037ee:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01037f3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01037fa:	00 
c01037fb:	89 04 24             	mov    %eax,(%esp)
c01037fe:	e8 cb f8 ff ff       	call   c01030ce <page_remove>
    assert(page_ref(p1) == 0);
c0103803:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103806:	89 04 24             	mov    %eax,(%esp)
c0103809:	e8 26 ef ff ff       	call   c0102734 <page_ref>
c010380e:	85 c0                	test   %eax,%eax
c0103810:	74 24                	je     c0103836 <check_pgdir+0x5f0>
c0103812:	c7 44 24 0c 3d 66 10 	movl   $0xc010663d,0xc(%esp)
c0103819:	c0 
c010381a:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103821:	c0 
c0103822:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103829:	00 
c010382a:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103831:	e8 ac cb ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p2) == 0);
c0103836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103839:	89 04 24             	mov    %eax,(%esp)
c010383c:	e8 f3 ee ff ff       	call   c0102734 <page_ref>
c0103841:	85 c0                	test   %eax,%eax
c0103843:	74 24                	je     c0103869 <check_pgdir+0x623>
c0103845:	c7 44 24 0c 16 66 10 	movl   $0xc0106616,0xc(%esp)
c010384c:	c0 
c010384d:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103854:	c0 
c0103855:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010385c:	00 
c010385d:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103864:	e8 79 cb ff ff       	call   c01003e2 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0103869:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010386e:	8b 00                	mov    (%eax),%eax
c0103870:	89 04 24             	mov    %eax,(%esp)
c0103873:	e8 db ed ff ff       	call   c0102653 <pa2page>
c0103878:	89 04 24             	mov    %eax,(%esp)
c010387b:	e8 b4 ee ff ff       	call   c0102734 <page_ref>
c0103880:	83 f8 01             	cmp    $0x1,%eax
c0103883:	74 24                	je     c01038a9 <check_pgdir+0x663>
c0103885:	c7 44 24 0c 50 66 10 	movl   $0xc0106650,0xc(%esp)
c010388c:	c0 
c010388d:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103894:	c0 
c0103895:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c010389c:	00 
c010389d:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01038a4:	e8 39 cb ff ff       	call   c01003e2 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c01038a9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038ae:	8b 00                	mov    (%eax),%eax
c01038b0:	89 04 24             	mov    %eax,(%esp)
c01038b3:	e8 9b ed ff ff       	call   c0102653 <pa2page>
c01038b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038bf:	00 
c01038c0:	89 04 24             	mov    %eax,(%esp)
c01038c3:	e8 9c f0 ff ff       	call   c0102964 <free_pages>
    boot_pgdir[0] = 0;
c01038c8:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01038cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01038d3:	c7 04 24 76 66 10 c0 	movl   $0xc0106676,(%esp)
c01038da:	e8 ac c9 ff ff       	call   c010028b <cprintf>
}
c01038df:	c9                   	leave  
c01038e0:	c3                   	ret    

c01038e1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01038e1:	55                   	push   %ebp
c01038e2:	89 e5                	mov    %esp,%ebp
c01038e4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01038e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01038ee:	e9 ca 00 00 00       	jmp    c01039bd <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01038f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038fc:	c1 e8 0c             	shr    $0xc,%eax
c01038ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103902:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103907:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010390a:	72 23                	jb     c010392f <check_boot_pgdir+0x4e>
c010390c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010390f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103913:	c7 44 24 08 c0 62 10 	movl   $0xc01062c0,0x8(%esp)
c010391a:	c0 
c010391b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103922:	00 
c0103923:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010392a:	e8 b3 ca ff ff       	call   c01003e2 <__panic>
c010392f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103932:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103937:	89 c2                	mov    %eax,%edx
c0103939:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010393e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103945:	00 
c0103946:	89 54 24 04          	mov    %edx,0x4(%esp)
c010394a:	89 04 24             	mov    %eax,(%esp)
c010394d:	e8 19 f7 ff ff       	call   c010306b <get_pte>
c0103952:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103955:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103959:	75 24                	jne    c010397f <check_boot_pgdir+0x9e>
c010395b:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c0103962:	c0 
c0103963:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c010396a:	c0 
c010396b:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103972:	00 
c0103973:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c010397a:	e8 63 ca ff ff       	call   c01003e2 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010397f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103982:	8b 00                	mov    (%eax),%eax
c0103984:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103989:	89 c2                	mov    %eax,%edx
c010398b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010398e:	39 c2                	cmp    %eax,%edx
c0103990:	74 24                	je     c01039b6 <check_boot_pgdir+0xd5>
c0103992:	c7 44 24 0c cd 66 10 	movl   $0xc01066cd,0xc(%esp)
c0103999:	c0 
c010399a:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c01039a1:	c0 
c01039a2:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c01039a9:	00 
c01039aa:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c01039b1:	e8 2c ca ff ff       	call   c01003e2 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c01039b6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01039bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01039c0:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039c5:	39 c2                	cmp    %eax,%edx
c01039c7:	0f 82 26 ff ff ff    	jb     c01038f3 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01039cd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039d2:	05 ac 0f 00 00       	add    $0xfac,%eax
c01039d7:	8b 00                	mov    (%eax),%eax
c01039d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039de:	89 c2                	mov    %eax,%edx
c01039e0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01039e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01039e8:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01039ef:	77 23                	ja     c0103a14 <check_boot_pgdir+0x133>
c01039f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039f8:	c7 44 24 08 64 63 10 	movl   $0xc0106364,0x8(%esp)
c01039ff:	c0 
c0103a00:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103a07:	00 
c0103a08:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103a0f:	e8 ce c9 ff ff       	call   c01003e2 <__panic>
c0103a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a17:	05 00 00 00 40       	add    $0x40000000,%eax
c0103a1c:	39 c2                	cmp    %eax,%edx
c0103a1e:	74 24                	je     c0103a44 <check_boot_pgdir+0x163>
c0103a20:	c7 44 24 0c e4 66 10 	movl   $0xc01066e4,0xc(%esp)
c0103a27:	c0 
c0103a28:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103a2f:	c0 
c0103a30:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0103a37:	00 
c0103a38:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103a3f:	e8 9e c9 ff ff       	call   c01003e2 <__panic>

    assert(boot_pgdir[0] == 0);
c0103a44:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a49:	8b 00                	mov    (%eax),%eax
c0103a4b:	85 c0                	test   %eax,%eax
c0103a4d:	74 24                	je     c0103a73 <check_boot_pgdir+0x192>
c0103a4f:	c7 44 24 0c 18 67 10 	movl   $0xc0106718,0xc(%esp)
c0103a56:	c0 
c0103a57:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103a5e:	c0 
c0103a5f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0103a66:	00 
c0103a67:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103a6e:	e8 6f c9 ff ff       	call   c01003e2 <__panic>

    struct Page *p;
    p = alloc_page();
c0103a73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a7a:	e8 ad ee ff ff       	call   c010292c <alloc_pages>
c0103a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103a82:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103a87:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103a8e:	00 
c0103a8f:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103a96:	00 
c0103a97:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a9a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103a9e:	89 04 24             	mov    %eax,(%esp)
c0103aa1:	e8 6c f6 ff ff       	call   c0103112 <page_insert>
c0103aa6:	85 c0                	test   %eax,%eax
c0103aa8:	74 24                	je     c0103ace <check_boot_pgdir+0x1ed>
c0103aaa:	c7 44 24 0c 2c 67 10 	movl   $0xc010672c,0xc(%esp)
c0103ab1:	c0 
c0103ab2:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103ab9:	c0 
c0103aba:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0103ac1:	00 
c0103ac2:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103ac9:	e8 14 c9 ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p) == 1);
c0103ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ad1:	89 04 24             	mov    %eax,(%esp)
c0103ad4:	e8 5b ec ff ff       	call   c0102734 <page_ref>
c0103ad9:	83 f8 01             	cmp    $0x1,%eax
c0103adc:	74 24                	je     c0103b02 <check_boot_pgdir+0x221>
c0103ade:	c7 44 24 0c 5a 67 10 	movl   $0xc010675a,0xc(%esp)
c0103ae5:	c0 
c0103ae6:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103aed:	c0 
c0103aee:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0103af5:	00 
c0103af6:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103afd:	e8 e0 c8 ff ff       	call   c01003e2 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103b02:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103b07:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103b0e:	00 
c0103b0f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103b16:	00 
c0103b17:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103b1a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b1e:	89 04 24             	mov    %eax,(%esp)
c0103b21:	e8 ec f5 ff ff       	call   c0103112 <page_insert>
c0103b26:	85 c0                	test   %eax,%eax
c0103b28:	74 24                	je     c0103b4e <check_boot_pgdir+0x26d>
c0103b2a:	c7 44 24 0c 6c 67 10 	movl   $0xc010676c,0xc(%esp)
c0103b31:	c0 
c0103b32:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103b39:	c0 
c0103b3a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0103b41:	00 
c0103b42:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103b49:	e8 94 c8 ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p) == 2);
c0103b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b51:	89 04 24             	mov    %eax,(%esp)
c0103b54:	e8 db eb ff ff       	call   c0102734 <page_ref>
c0103b59:	83 f8 02             	cmp    $0x2,%eax
c0103b5c:	74 24                	je     c0103b82 <check_boot_pgdir+0x2a1>
c0103b5e:	c7 44 24 0c a3 67 10 	movl   $0xc01067a3,0xc(%esp)
c0103b65:	c0 
c0103b66:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103b6d:	c0 
c0103b6e:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0103b75:	00 
c0103b76:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103b7d:	e8 60 c8 ff ff       	call   c01003e2 <__panic>

    const char *str = "ucore: Hello world!!";
c0103b82:	c7 45 dc b4 67 10 c0 	movl   $0xc01067b4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103b89:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103b90:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103b97:	e8 25 15 00 00       	call   c01050c1 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103b9c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103ba3:	00 
c0103ba4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103bab:	e8 8a 15 00 00       	call   c010513a <strcmp>
c0103bb0:	85 c0                	test   %eax,%eax
c0103bb2:	74 24                	je     c0103bd8 <check_boot_pgdir+0x2f7>
c0103bb4:	c7 44 24 0c cc 67 10 	movl   $0xc01067cc,0xc(%esp)
c0103bbb:	c0 
c0103bbc:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103bc3:	c0 
c0103bc4:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0103bcb:	00 
c0103bcc:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103bd3:	e8 0a c8 ff ff       	call   c01003e2 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bdb:	89 04 24             	mov    %eax,(%esp)
c0103bde:	e8 bf ea ff ff       	call   c01026a2 <page2kva>
c0103be3:	05 00 01 00 00       	add    $0x100,%eax
c0103be8:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103beb:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103bf2:	e8 72 14 00 00       	call   c0105069 <strlen>
c0103bf7:	85 c0                	test   %eax,%eax
c0103bf9:	74 24                	je     c0103c1f <check_boot_pgdir+0x33e>
c0103bfb:	c7 44 24 0c 04 68 10 	movl   $0xc0106804,0xc(%esp)
c0103c02:	c0 
c0103c03:	c7 44 24 08 ad 63 10 	movl   $0xc01063ad,0x8(%esp)
c0103c0a:	c0 
c0103c0b:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0103c12:	00 
c0103c13:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0103c1a:	e8 c3 c7 ff ff       	call   c01003e2 <__panic>

    free_page(p);
c0103c1f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c26:	00 
c0103c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c2a:	89 04 24             	mov    %eax,(%esp)
c0103c2d:	e8 32 ed ff ff       	call   c0102964 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0103c32:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c37:	8b 00                	mov    (%eax),%eax
c0103c39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103c3e:	89 04 24             	mov    %eax,(%esp)
c0103c41:	e8 0d ea ff ff       	call   c0102653 <pa2page>
c0103c46:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c4d:	00 
c0103c4e:	89 04 24             	mov    %eax,(%esp)
c0103c51:	e8 0e ed ff ff       	call   c0102964 <free_pages>
    boot_pgdir[0] = 0;
c0103c56:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0103c5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103c61:	c7 04 24 28 68 10 c0 	movl   $0xc0106828,(%esp)
c0103c68:	e8 1e c6 ff ff       	call   c010028b <cprintf>
}
c0103c6d:	c9                   	leave  
c0103c6e:	c3                   	ret    

c0103c6f <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103c6f:	55                   	push   %ebp
c0103c70:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103c72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c75:	83 e0 04             	and    $0x4,%eax
c0103c78:	85 c0                	test   %eax,%eax
c0103c7a:	74 07                	je     c0103c83 <perm2str+0x14>
c0103c7c:	b8 75 00 00 00       	mov    $0x75,%eax
c0103c81:	eb 05                	jmp    c0103c88 <perm2str+0x19>
c0103c83:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103c88:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0103c8d:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c97:	83 e0 02             	and    $0x2,%eax
c0103c9a:	85 c0                	test   %eax,%eax
c0103c9c:	74 07                	je     c0103ca5 <perm2str+0x36>
c0103c9e:	b8 77 00 00 00       	mov    $0x77,%eax
c0103ca3:	eb 05                	jmp    c0103caa <perm2str+0x3b>
c0103ca5:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0103caa:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c0103caf:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0103cb6:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0103cbb:	5d                   	pop    %ebp
c0103cbc:	c3                   	ret    

c0103cbd <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103cbd:	55                   	push   %ebp
c0103cbe:	89 e5                	mov    %esp,%ebp
c0103cc0:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103cc3:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cc6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103cc9:	72 0a                	jb     c0103cd5 <get_pgtable_items+0x18>
        return 0;
c0103ccb:	b8 00 00 00 00       	mov    $0x0,%eax
c0103cd0:	e9 9c 00 00 00       	jmp    c0103d71 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103cd5:	eb 04                	jmp    c0103cdb <get_pgtable_items+0x1e>
        start ++;
c0103cd7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0103cdb:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cde:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103ce1:	73 18                	jae    c0103cfb <get_pgtable_items+0x3e>
c0103ce3:	8b 45 10             	mov    0x10(%ebp),%eax
c0103ce6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103ced:	8b 45 14             	mov    0x14(%ebp),%eax
c0103cf0:	01 d0                	add    %edx,%eax
c0103cf2:	8b 00                	mov    (%eax),%eax
c0103cf4:	83 e0 01             	and    $0x1,%eax
c0103cf7:	85 c0                	test   %eax,%eax
c0103cf9:	74 dc                	je     c0103cd7 <get_pgtable_items+0x1a>
    }
    if (start < right) {
c0103cfb:	8b 45 10             	mov    0x10(%ebp),%eax
c0103cfe:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d01:	73 69                	jae    c0103d6c <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0103d03:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103d07:	74 08                	je     c0103d11 <get_pgtable_items+0x54>
            *left_store = start;
c0103d09:	8b 45 18             	mov    0x18(%ebp),%eax
c0103d0c:	8b 55 10             	mov    0x10(%ebp),%edx
c0103d0f:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d14:	8d 50 01             	lea    0x1(%eax),%edx
c0103d17:	89 55 10             	mov    %edx,0x10(%ebp)
c0103d1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103d21:	8b 45 14             	mov    0x14(%ebp),%eax
c0103d24:	01 d0                	add    %edx,%eax
c0103d26:	8b 00                	mov    (%eax),%eax
c0103d28:	83 e0 07             	and    $0x7,%eax
c0103d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103d2e:	eb 04                	jmp    c0103d34 <get_pgtable_items+0x77>
            start ++;
c0103d30:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103d34:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d37:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d3a:	73 1d                	jae    c0103d59 <get_pgtable_items+0x9c>
c0103d3c:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103d46:	8b 45 14             	mov    0x14(%ebp),%eax
c0103d49:	01 d0                	add    %edx,%eax
c0103d4b:	8b 00                	mov    (%eax),%eax
c0103d4d:	83 e0 07             	and    $0x7,%eax
c0103d50:	89 c2                	mov    %eax,%edx
c0103d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103d55:	39 c2                	cmp    %eax,%edx
c0103d57:	74 d7                	je     c0103d30 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
c0103d59:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103d5d:	74 08                	je     c0103d67 <get_pgtable_items+0xaa>
            *right_store = start;
c0103d5f:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103d62:	8b 55 10             	mov    0x10(%ebp),%edx
c0103d65:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103d67:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103d6a:	eb 05                	jmp    c0103d71 <get_pgtable_items+0xb4>
    }
    return 0;
c0103d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d71:	c9                   	leave  
c0103d72:	c3                   	ret    

c0103d73 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103d73:	55                   	push   %ebp
c0103d74:	89 e5                	mov    %esp,%ebp
c0103d76:	57                   	push   %edi
c0103d77:	56                   	push   %esi
c0103d78:	53                   	push   %ebx
c0103d79:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103d7c:	c7 04 24 48 68 10 c0 	movl   $0xc0106848,(%esp)
c0103d83:	e8 03 c5 ff ff       	call   c010028b <cprintf>
    size_t left, right = 0, perm;
c0103d88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103d8f:	e9 fa 00 00 00       	jmp    c0103e8e <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d97:	89 04 24             	mov    %eax,(%esp)
c0103d9a:	e8 d0 fe ff ff       	call   c0103c6f <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103d9f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0103da2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103da5:	29 d1                	sub    %edx,%ecx
c0103da7:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103da9:	89 d6                	mov    %edx,%esi
c0103dab:	c1 e6 16             	shl    $0x16,%esi
c0103dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103db1:	89 d3                	mov    %edx,%ebx
c0103db3:	c1 e3 16             	shl    $0x16,%ebx
c0103db6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103db9:	89 d1                	mov    %edx,%ecx
c0103dbb:	c1 e1 16             	shl    $0x16,%ecx
c0103dbe:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0103dc1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103dc4:	29 d7                	sub    %edx,%edi
c0103dc6:	89 fa                	mov    %edi,%edx
c0103dc8:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103dcc:	89 74 24 10          	mov    %esi,0x10(%esp)
c0103dd0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0103dd4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103dd8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ddc:	c7 04 24 79 68 10 c0 	movl   $0xc0106879,(%esp)
c0103de3:	e8 a3 c4 ff ff       	call   c010028b <cprintf>
        size_t l, r = left * NPTEENTRY;
c0103de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103deb:	c1 e0 0a             	shl    $0xa,%eax
c0103dee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103df1:	eb 54                	jmp    c0103e47 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103df6:	89 04 24             	mov    %eax,(%esp)
c0103df9:	e8 71 fe ff ff       	call   c0103c6f <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103dfe:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103e01:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103e04:	29 d1                	sub    %edx,%ecx
c0103e06:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103e08:	89 d6                	mov    %edx,%esi
c0103e0a:	c1 e6 0c             	shl    $0xc,%esi
c0103e0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e10:	89 d3                	mov    %edx,%ebx
c0103e12:	c1 e3 0c             	shl    $0xc,%ebx
c0103e15:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103e18:	c1 e2 0c             	shl    $0xc,%edx
c0103e1b:	89 d1                	mov    %edx,%ecx
c0103e1d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0103e20:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103e23:	29 d7                	sub    %edx,%edi
c0103e25:	89 fa                	mov    %edi,%edx
c0103e27:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103e2b:	89 74 24 10          	mov    %esi,0x10(%esp)
c0103e2f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0103e33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103e37:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e3b:	c7 04 24 98 68 10 c0 	movl   $0xc0106898,(%esp)
c0103e42:	e8 44 c4 ff ff       	call   c010028b <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103e47:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0103e4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103e4f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0103e52:	89 ce                	mov    %ecx,%esi
c0103e54:	c1 e6 0a             	shl    $0xa,%esi
c0103e57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0103e5a:	89 cb                	mov    %ecx,%ebx
c0103e5c:	c1 e3 0a             	shl    $0xa,%ebx
c0103e5f:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0103e62:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0103e66:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0103e69:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0103e6d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103e71:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103e75:	89 74 24 04          	mov    %esi,0x4(%esp)
c0103e79:	89 1c 24             	mov    %ebx,(%esp)
c0103e7c:	e8 3c fe ff ff       	call   c0103cbd <get_pgtable_items>
c0103e81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e88:	0f 85 65 ff ff ff    	jne    c0103df3 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103e8e:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0103e93:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e96:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0103e99:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0103e9d:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0103ea0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0103ea4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103eac:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0103eb3:	00 
c0103eb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0103ebb:	e8 fd fd ff ff       	call   c0103cbd <get_pgtable_items>
c0103ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ec3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ec7:	0f 85 c7 fe ff ff    	jne    c0103d94 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0103ecd:	c7 04 24 bc 68 10 c0 	movl   $0xc01068bc,(%esp)
c0103ed4:	e8 b2 c3 ff ff       	call   c010028b <cprintf>
}
c0103ed9:	83 c4 4c             	add    $0x4c,%esp
c0103edc:	5b                   	pop    %ebx
c0103edd:	5e                   	pop    %esi
c0103ede:	5f                   	pop    %edi
c0103edf:	5d                   	pop    %ebp
c0103ee0:	c3                   	ret    

c0103ee1 <page2ppn>:
page2ppn(struct Page *page) {
c0103ee1:	55                   	push   %ebp
c0103ee2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103ee4:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ee7:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103eec:	29 c2                	sub    %eax,%edx
c0103eee:	89 d0                	mov    %edx,%eax
c0103ef0:	c1 f8 02             	sar    $0x2,%eax
c0103ef3:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103ef9:	5d                   	pop    %ebp
c0103efa:	c3                   	ret    

c0103efb <page2pa>:
page2pa(struct Page *page) {
c0103efb:	55                   	push   %ebp
c0103efc:	89 e5                	mov    %esp,%ebp
c0103efe:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103f01:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f04:	89 04 24             	mov    %eax,(%esp)
c0103f07:	e8 d5 ff ff ff       	call   c0103ee1 <page2ppn>
c0103f0c:	c1 e0 0c             	shl    $0xc,%eax
}
c0103f0f:	c9                   	leave  
c0103f10:	c3                   	ret    

c0103f11 <page_ref>:
page_ref(struct Page *page) {
c0103f11:	55                   	push   %ebp
c0103f12:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f17:	8b 00                	mov    (%eax),%eax
}
c0103f19:	5d                   	pop    %ebp
c0103f1a:	c3                   	ret    

c0103f1b <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0103f1b:	55                   	push   %ebp
c0103f1c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103f1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f21:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f24:	89 10                	mov    %edx,(%eax)
}
c0103f26:	5d                   	pop    %ebp
c0103f27:	c3                   	ret    

c0103f28 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103f28:	55                   	push   %ebp
c0103f29:	89 e5                	mov    %esp,%ebp
c0103f2b:	83 ec 10             	sub    $0x10,%esp
c0103f2e:	c7 45 fc 5c 89 11 c0 	movl   $0xc011895c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f38:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103f3b:	89 50 04             	mov    %edx,0x4(%eax)
c0103f3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f41:	8b 50 04             	mov    0x4(%eax),%edx
c0103f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f47:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103f49:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0103f50:	00 00 00 
}
c0103f53:	c9                   	leave  
c0103f54:	c3                   	ret    

c0103f55 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103f55:	55                   	push   %ebp
c0103f56:	89 e5                	mov    %esp,%ebp
c0103f58:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103f5b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103f5f:	75 24                	jne    c0103f85 <default_init_memmap+0x30>
c0103f61:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c0103f68:	c0 
c0103f69:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0103f70:	c0 
c0103f71:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103f78:	00 
c0103f79:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0103f80:	e8 5d c4 ff ff       	call   c01003e2 <__panic>
    struct Page *p = base;
c0103f85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103f8b:	eb 7d                	jmp    c010400a <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f90:	83 c0 04             	add    $0x4,%eax
c0103f93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103f9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103fa3:	0f a3 10             	bt     %edx,(%eax)
c0103fa6:	19 c0                	sbb    %eax,%eax
c0103fa8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103fab:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103faf:	0f 95 c0             	setne  %al
c0103fb2:	0f b6 c0             	movzbl %al,%eax
c0103fb5:	85 c0                	test   %eax,%eax
c0103fb7:	75 24                	jne    c0103fdd <default_init_memmap+0x88>
c0103fb9:	c7 44 24 0c 21 69 10 	movl   $0xc0106921,0xc(%esp)
c0103fc0:	c0 
c0103fc1:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0103fc8:	c0 
c0103fc9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103fd0:	00 
c0103fd1:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0103fd8:	e8 05 c4 ff ff       	call   c01003e2 <__panic>
        p->flags = p->property = 0;
c0103fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fe0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0103fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fea:	8b 50 08             	mov    0x8(%eax),%edx
c0103fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ff0:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0103ff3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103ffa:	00 
c0103ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ffe:	89 04 24             	mov    %eax,(%esp)
c0104001:	e8 15 ff ff ff       	call   c0103f1b <set_page_ref>
    for (; p != base + n; p ++) {
c0104006:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010400a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010400d:	89 d0                	mov    %edx,%eax
c010400f:	c1 e0 02             	shl    $0x2,%eax
c0104012:	01 d0                	add    %edx,%eax
c0104014:	c1 e0 02             	shl    $0x2,%eax
c0104017:	89 c2                	mov    %eax,%edx
c0104019:	8b 45 08             	mov    0x8(%ebp),%eax
c010401c:	01 d0                	add    %edx,%eax
c010401e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104021:	0f 85 66 ff ff ff    	jne    c0103f8d <default_init_memmap+0x38>
    }
    base->property = n;
c0104027:	8b 45 08             	mov    0x8(%ebp),%eax
c010402a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010402d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104030:	8b 45 08             	mov    0x8(%ebp),%eax
c0104033:	83 c0 04             	add    $0x4,%eax
c0104036:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010403d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104040:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104043:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104046:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104049:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c010404f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104052:	01 d0                	add    %edx,%eax
c0104054:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    list_add(&free_list, &(base->page_link));
c0104059:	8b 45 08             	mov    0x8(%ebp),%eax
c010405c:	83 c0 0c             	add    $0xc,%eax
c010405f:	c7 45 dc 5c 89 11 c0 	movl   $0xc011895c,-0x24(%ebp)
c0104066:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0104069:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010406c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010406f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104072:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104075:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104078:	8b 40 04             	mov    0x4(%eax),%eax
c010407b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010407e:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104081:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104084:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0104087:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010408a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010408d:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104090:	89 10                	mov    %edx,(%eax)
c0104092:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104095:	8b 10                	mov    (%eax),%edx
c0104097:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010409a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010409d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01040a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01040a3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01040a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01040a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01040ac:	89 10                	mov    %edx,(%eax)
}
c01040ae:	c9                   	leave  
c01040af:	c3                   	ret    

c01040b0 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01040b0:	55                   	push   %ebp
c01040b1:	89 e5                	mov    %esp,%ebp
c01040b3:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01040b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01040ba:	75 24                	jne    c01040e0 <default_alloc_pages+0x30>
c01040bc:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c01040c3:	c0 
c01040c4:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01040cb:	c0 
c01040cc:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01040d3:	00 
c01040d4:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01040db:	e8 02 c3 ff ff       	call   c01003e2 <__panic>
    if (n > nr_free) {
c01040e0:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01040e5:	3b 45 08             	cmp    0x8(%ebp),%eax
c01040e8:	73 0a                	jae    c01040f4 <default_alloc_pages+0x44>
        return NULL;
c01040ea:	b8 00 00 00 00       	mov    $0x0,%eax
c01040ef:	e9 2a 01 00 00       	jmp    c010421e <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c01040f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01040fb:	c7 45 f0 5c 89 11 c0 	movl   $0xc011895c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104102:	eb 1c                	jmp    c0104120 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0104104:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104107:	83 e8 0c             	sub    $0xc,%eax
c010410a:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010410d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104110:	8b 40 08             	mov    0x8(%eax),%eax
c0104113:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104116:	72 08                	jb     c0104120 <default_alloc_pages+0x70>
            page = p;
c0104118:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010411b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010411e:	eb 18                	jmp    c0104138 <default_alloc_pages+0x88>
c0104120:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104123:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104129:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010412c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010412f:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c0104136:	75 cc                	jne    c0104104 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0104138:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010413c:	0f 84 d9 00 00 00    	je     c010421b <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c0104142:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104145:	83 c0 0c             	add    $0xc,%eax
c0104148:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c010414b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010414e:	8b 40 04             	mov    0x4(%eax),%eax
c0104151:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104154:	8b 12                	mov    (%edx),%edx
c0104156:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0104159:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010415c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010415f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104162:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104165:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104168:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010416b:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c010416d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104170:	8b 40 08             	mov    0x8(%eax),%eax
c0104173:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104176:	76 7d                	jbe    c01041f5 <default_alloc_pages+0x145>
            struct Page *p = page + n;
c0104178:	8b 55 08             	mov    0x8(%ebp),%edx
c010417b:	89 d0                	mov    %edx,%eax
c010417d:	c1 e0 02             	shl    $0x2,%eax
c0104180:	01 d0                	add    %edx,%eax
c0104182:	c1 e0 02             	shl    $0x2,%eax
c0104185:	89 c2                	mov    %eax,%edx
c0104187:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010418a:	01 d0                	add    %edx,%eax
c010418c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010418f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104192:	8b 40 08             	mov    0x8(%eax),%eax
c0104195:	2b 45 08             	sub    0x8(%ebp),%eax
c0104198:	89 c2                	mov    %eax,%edx
c010419a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010419d:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c01041a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041a3:	83 c0 0c             	add    $0xc,%eax
c01041a6:	c7 45 d4 5c 89 11 c0 	movl   $0xc011895c,-0x2c(%ebp)
c01041ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01041b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01041b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c01041bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01041bf:	8b 40 04             	mov    0x4(%eax),%eax
c01041c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01041c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01041c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01041cb:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01041ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c01041d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01041d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01041d7:	89 10                	mov    %edx,(%eax)
c01041d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01041dc:	8b 10                	mov    (%eax),%edx
c01041de:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01041e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01041e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041e7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01041ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01041ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01041f3:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c01041f5:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01041fa:	2b 45 08             	sub    0x8(%ebp),%eax
c01041fd:	a3 64 89 11 c0       	mov    %eax,0xc0118964
        ClearPageProperty(page);
c0104202:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104205:	83 c0 04             	add    $0x4,%eax
c0104208:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010420f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104212:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104215:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104218:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010421b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010421e:	c9                   	leave  
c010421f:	c3                   	ret    

c0104220 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104220:	55                   	push   %ebp
c0104221:	89 e5                	mov    %esp,%ebp
c0104223:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104229:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010422d:	75 24                	jne    c0104253 <default_free_pages+0x33>
c010422f:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c0104236:	c0 
c0104237:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010423e:	c0 
c010423f:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104246:	00 
c0104247:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010424e:	e8 8f c1 ff ff       	call   c01003e2 <__panic>
    struct Page *p = base;
c0104253:	8b 45 08             	mov    0x8(%ebp),%eax
c0104256:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104259:	e9 9d 00 00 00       	jmp    c01042fb <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c010425e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104261:	83 c0 04             	add    $0x4,%eax
c0104264:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010426b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010426e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104271:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104274:	0f a3 10             	bt     %edx,(%eax)
c0104277:	19 c0                	sbb    %eax,%eax
c0104279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c010427c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104280:	0f 95 c0             	setne  %al
c0104283:	0f b6 c0             	movzbl %al,%eax
c0104286:	85 c0                	test   %eax,%eax
c0104288:	75 2c                	jne    c01042b6 <default_free_pages+0x96>
c010428a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010428d:	83 c0 04             	add    $0x4,%eax
c0104290:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0104297:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010429a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010429d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01042a0:	0f a3 10             	bt     %edx,(%eax)
c01042a3:	19 c0                	sbb    %eax,%eax
c01042a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01042a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01042ac:	0f 95 c0             	setne  %al
c01042af:	0f b6 c0             	movzbl %al,%eax
c01042b2:	85 c0                	test   %eax,%eax
c01042b4:	74 24                	je     c01042da <default_free_pages+0xba>
c01042b6:	c7 44 24 0c 34 69 10 	movl   $0xc0106934,0xc(%esp)
c01042bd:	c0 
c01042be:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01042c5:	c0 
c01042c6:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c01042cd:	00 
c01042ce:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01042d5:	e8 08 c1 ff ff       	call   c01003e2 <__panic>
        p->flags = 0;
c01042da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01042e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01042eb:	00 
c01042ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ef:	89 04 24             	mov    %eax,(%esp)
c01042f2:	e8 24 fc ff ff       	call   c0103f1b <set_page_ref>
    for (; p != base + n; p ++) {
c01042f7:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01042fb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01042fe:	89 d0                	mov    %edx,%eax
c0104300:	c1 e0 02             	shl    $0x2,%eax
c0104303:	01 d0                	add    %edx,%eax
c0104305:	c1 e0 02             	shl    $0x2,%eax
c0104308:	89 c2                	mov    %eax,%edx
c010430a:	8b 45 08             	mov    0x8(%ebp),%eax
c010430d:	01 d0                	add    %edx,%eax
c010430f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104312:	0f 85 46 ff ff ff    	jne    c010425e <default_free_pages+0x3e>
    }
    base->property = n;
c0104318:	8b 45 08             	mov    0x8(%ebp),%eax
c010431b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010431e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104321:	8b 45 08             	mov    0x8(%ebp),%eax
c0104324:	83 c0 04             	add    $0x4,%eax
c0104327:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010432e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104331:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104334:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104337:	0f ab 10             	bts    %edx,(%eax)
c010433a:	c7 45 cc 5c 89 11 c0 	movl   $0xc011895c,-0x34(%ebp)
    return listelm->next;
c0104341:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104344:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104347:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010434a:	e9 08 01 00 00       	jmp    c0104457 <default_free_pages+0x237>
        p = le2page(le, page_link);
c010434f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104352:	83 e8 0c             	sub    $0xc,%eax
c0104355:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104358:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010435b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010435e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104361:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0104364:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0104367:	8b 45 08             	mov    0x8(%ebp),%eax
c010436a:	8b 50 08             	mov    0x8(%eax),%edx
c010436d:	89 d0                	mov    %edx,%eax
c010436f:	c1 e0 02             	shl    $0x2,%eax
c0104372:	01 d0                	add    %edx,%eax
c0104374:	c1 e0 02             	shl    $0x2,%eax
c0104377:	89 c2                	mov    %eax,%edx
c0104379:	8b 45 08             	mov    0x8(%ebp),%eax
c010437c:	01 d0                	add    %edx,%eax
c010437e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104381:	75 5a                	jne    c01043dd <default_free_pages+0x1bd>
            base->property += p->property;
c0104383:	8b 45 08             	mov    0x8(%ebp),%eax
c0104386:	8b 50 08             	mov    0x8(%eax),%edx
c0104389:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010438c:	8b 40 08             	mov    0x8(%eax),%eax
c010438f:	01 c2                	add    %eax,%edx
c0104391:	8b 45 08             	mov    0x8(%ebp),%eax
c0104394:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0104397:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439a:	83 c0 04             	add    $0x4,%eax
c010439d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01043a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01043a7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01043aa:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01043ad:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c01043b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043b3:	83 c0 0c             	add    $0xc,%eax
c01043b6:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c01043b9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01043bc:	8b 40 04             	mov    0x4(%eax),%eax
c01043bf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01043c2:	8b 12                	mov    (%edx),%edx
c01043c4:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01043c7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c01043ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01043cd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01043d0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01043d3:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01043d6:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01043d9:	89 10                	mov    %edx,(%eax)
c01043db:	eb 7a                	jmp    c0104457 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c01043dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e0:	8b 50 08             	mov    0x8(%eax),%edx
c01043e3:	89 d0                	mov    %edx,%eax
c01043e5:	c1 e0 02             	shl    $0x2,%eax
c01043e8:	01 d0                	add    %edx,%eax
c01043ea:	c1 e0 02             	shl    $0x2,%eax
c01043ed:	89 c2                	mov    %eax,%edx
c01043ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f2:	01 d0                	add    %edx,%eax
c01043f4:	3b 45 08             	cmp    0x8(%ebp),%eax
c01043f7:	75 5e                	jne    c0104457 <default_free_pages+0x237>
            p->property += base->property;
c01043f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043fc:	8b 50 08             	mov    0x8(%eax),%edx
c01043ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104402:	8b 40 08             	mov    0x8(%eax),%eax
c0104405:	01 c2                	add    %eax,%edx
c0104407:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010440a:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010440d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104410:	83 c0 04             	add    $0x4,%eax
c0104413:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010441a:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010441d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104420:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104423:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104426:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104429:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010442c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442f:	83 c0 0c             	add    $0xc,%eax
c0104432:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104435:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104438:	8b 40 04             	mov    0x4(%eax),%eax
c010443b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010443e:	8b 12                	mov    (%edx),%edx
c0104440:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0104443:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
c0104446:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104449:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010444c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010444f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104452:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104455:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0104457:	81 7d f0 5c 89 11 c0 	cmpl   $0xc011895c,-0x10(%ebp)
c010445e:	0f 85 eb fe ff ff    	jne    c010434f <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c0104464:	8b 15 64 89 11 c0    	mov    0xc0118964,%edx
c010446a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010446d:	01 d0                	add    %edx,%eax
c010446f:	a3 64 89 11 c0       	mov    %eax,0xc0118964
    list_add(&free_list, &(base->page_link));
c0104474:	8b 45 08             	mov    0x8(%ebp),%eax
c0104477:	83 c0 0c             	add    $0xc,%eax
c010447a:	c7 45 9c 5c 89 11 c0 	movl   $0xc011895c,-0x64(%ebp)
c0104481:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104484:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104487:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010448a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010448d:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104490:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104493:	8b 40 04             	mov    0x4(%eax),%eax
c0104496:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104499:	89 55 8c             	mov    %edx,-0x74(%ebp)
c010449c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010449f:	89 55 88             	mov    %edx,-0x78(%ebp)
c01044a2:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c01044a5:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01044a8:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01044ab:	89 10                	mov    %edx,(%eax)
c01044ad:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01044b0:	8b 10                	mov    (%eax),%edx
c01044b2:	8b 45 88             	mov    -0x78(%ebp),%eax
c01044b5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01044b8:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01044bb:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01044be:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01044c1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01044c4:	8b 55 88             	mov    -0x78(%ebp),%edx
c01044c7:	89 10                	mov    %edx,(%eax)
}
c01044c9:	c9                   	leave  
c01044ca:	c3                   	ret    

c01044cb <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01044cb:	55                   	push   %ebp
c01044cc:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01044ce:	a1 64 89 11 c0       	mov    0xc0118964,%eax
}
c01044d3:	5d                   	pop    %ebp
c01044d4:	c3                   	ret    

c01044d5 <basic_check>:

static void
basic_check(void) {
c01044d5:	55                   	push   %ebp
c01044d6:	89 e5                	mov    %esp,%ebp
c01044d8:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01044db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01044ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044f5:	e8 32 e4 ff ff       	call   c010292c <alloc_pages>
c01044fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01044fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104501:	75 24                	jne    c0104527 <basic_check+0x52>
c0104503:	c7 44 24 0c 59 69 10 	movl   $0xc0106959,0xc(%esp)
c010450a:	c0 
c010450b:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104512:	c0 
c0104513:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c010451a:	00 
c010451b:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104522:	e8 bb be ff ff       	call   c01003e2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104527:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010452e:	e8 f9 e3 ff ff       	call   c010292c <alloc_pages>
c0104533:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104536:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010453a:	75 24                	jne    c0104560 <basic_check+0x8b>
c010453c:	c7 44 24 0c 75 69 10 	movl   $0xc0106975,0xc(%esp)
c0104543:	c0 
c0104544:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010454b:	c0 
c010454c:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0104553:	00 
c0104554:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010455b:	e8 82 be ff ff       	call   c01003e2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104560:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104567:	e8 c0 e3 ff ff       	call   c010292c <alloc_pages>
c010456c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010456f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104573:	75 24                	jne    c0104599 <basic_check+0xc4>
c0104575:	c7 44 24 0c 91 69 10 	movl   $0xc0106991,0xc(%esp)
c010457c:	c0 
c010457d:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104584:	c0 
c0104585:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c010458c:	00 
c010458d:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104594:	e8 49 be ff ff       	call   c01003e2 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104599:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010459c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010459f:	74 10                	je     c01045b1 <basic_check+0xdc>
c01045a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01045a7:	74 08                	je     c01045b1 <basic_check+0xdc>
c01045a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01045af:	75 24                	jne    c01045d5 <basic_check+0x100>
c01045b1:	c7 44 24 0c b0 69 10 	movl   $0xc01069b0,0xc(%esp)
c01045b8:	c0 
c01045b9:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01045c0:	c0 
c01045c1:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c01045c8:	00 
c01045c9:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01045d0:	e8 0d be ff ff       	call   c01003e2 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01045d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045d8:	89 04 24             	mov    %eax,(%esp)
c01045db:	e8 31 f9 ff ff       	call   c0103f11 <page_ref>
c01045e0:	85 c0                	test   %eax,%eax
c01045e2:	75 1e                	jne    c0104602 <basic_check+0x12d>
c01045e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045e7:	89 04 24             	mov    %eax,(%esp)
c01045ea:	e8 22 f9 ff ff       	call   c0103f11 <page_ref>
c01045ef:	85 c0                	test   %eax,%eax
c01045f1:	75 0f                	jne    c0104602 <basic_check+0x12d>
c01045f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f6:	89 04 24             	mov    %eax,(%esp)
c01045f9:	e8 13 f9 ff ff       	call   c0103f11 <page_ref>
c01045fe:	85 c0                	test   %eax,%eax
c0104600:	74 24                	je     c0104626 <basic_check+0x151>
c0104602:	c7 44 24 0c d4 69 10 	movl   $0xc01069d4,0xc(%esp)
c0104609:	c0 
c010460a:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104611:	c0 
c0104612:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0104619:	00 
c010461a:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104621:	e8 bc bd ff ff       	call   c01003e2 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104626:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104629:	89 04 24             	mov    %eax,(%esp)
c010462c:	e8 ca f8 ff ff       	call   c0103efb <page2pa>
c0104631:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104637:	c1 e2 0c             	shl    $0xc,%edx
c010463a:	39 d0                	cmp    %edx,%eax
c010463c:	72 24                	jb     c0104662 <basic_check+0x18d>
c010463e:	c7 44 24 0c 10 6a 10 	movl   $0xc0106a10,0xc(%esp)
c0104645:	c0 
c0104646:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010464d:	c0 
c010464e:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0104655:	00 
c0104656:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010465d:	e8 80 bd ff ff       	call   c01003e2 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104662:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104665:	89 04 24             	mov    %eax,(%esp)
c0104668:	e8 8e f8 ff ff       	call   c0103efb <page2pa>
c010466d:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0104673:	c1 e2 0c             	shl    $0xc,%edx
c0104676:	39 d0                	cmp    %edx,%eax
c0104678:	72 24                	jb     c010469e <basic_check+0x1c9>
c010467a:	c7 44 24 0c 2d 6a 10 	movl   $0xc0106a2d,0xc(%esp)
c0104681:	c0 
c0104682:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104689:	c0 
c010468a:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0104691:	00 
c0104692:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104699:	e8 44 bd ff ff       	call   c01003e2 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010469e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a1:	89 04 24             	mov    %eax,(%esp)
c01046a4:	e8 52 f8 ff ff       	call   c0103efb <page2pa>
c01046a9:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c01046af:	c1 e2 0c             	shl    $0xc,%edx
c01046b2:	39 d0                	cmp    %edx,%eax
c01046b4:	72 24                	jb     c01046da <basic_check+0x205>
c01046b6:	c7 44 24 0c 4a 6a 10 	movl   $0xc0106a4a,0xc(%esp)
c01046bd:	c0 
c01046be:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01046c5:	c0 
c01046c6:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01046cd:	00 
c01046ce:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01046d5:	e8 08 bd ff ff       	call   c01003e2 <__panic>

    list_entry_t free_list_store = free_list;
c01046da:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01046df:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c01046e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01046e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01046eb:	c7 45 e0 5c 89 11 c0 	movl   $0xc011895c,-0x20(%ebp)
    elm->prev = elm->next = elm;
c01046f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01046f8:	89 50 04             	mov    %edx,0x4(%eax)
c01046fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046fe:	8b 50 04             	mov    0x4(%eax),%edx
c0104701:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104704:	89 10                	mov    %edx,(%eax)
c0104706:	c7 45 dc 5c 89 11 c0 	movl   $0xc011895c,-0x24(%ebp)
    return list->next == list;
c010470d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104710:	8b 40 04             	mov    0x4(%eax),%eax
c0104713:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104716:	0f 94 c0             	sete   %al
c0104719:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010471c:	85 c0                	test   %eax,%eax
c010471e:	75 24                	jne    c0104744 <basic_check+0x26f>
c0104720:	c7 44 24 0c 67 6a 10 	movl   $0xc0106a67,0xc(%esp)
c0104727:	c0 
c0104728:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010472f:	c0 
c0104730:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0104737:	00 
c0104738:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010473f:	e8 9e bc ff ff       	call   c01003e2 <__panic>

    unsigned int nr_free_store = nr_free;
c0104744:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104749:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010474c:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104753:	00 00 00 

    assert(alloc_page() == NULL);
c0104756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010475d:	e8 ca e1 ff ff       	call   c010292c <alloc_pages>
c0104762:	85 c0                	test   %eax,%eax
c0104764:	74 24                	je     c010478a <basic_check+0x2b5>
c0104766:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c010476d:	c0 
c010476e:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104775:	c0 
c0104776:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010477d:	00 
c010477e:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104785:	e8 58 bc ff ff       	call   c01003e2 <__panic>

    free_page(p0);
c010478a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104791:	00 
c0104792:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104795:	89 04 24             	mov    %eax,(%esp)
c0104798:	e8 c7 e1 ff ff       	call   c0102964 <free_pages>
    free_page(p1);
c010479d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047a4:	00 
c01047a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047a8:	89 04 24             	mov    %eax,(%esp)
c01047ab:	e8 b4 e1 ff ff       	call   c0102964 <free_pages>
    free_page(p2);
c01047b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047b7:	00 
c01047b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047bb:	89 04 24             	mov    %eax,(%esp)
c01047be:	e8 a1 e1 ff ff       	call   c0102964 <free_pages>
    assert(nr_free == 3);
c01047c3:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01047c8:	83 f8 03             	cmp    $0x3,%eax
c01047cb:	74 24                	je     c01047f1 <basic_check+0x31c>
c01047cd:	c7 44 24 0c 93 6a 10 	movl   $0xc0106a93,0xc(%esp)
c01047d4:	c0 
c01047d5:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01047dc:	c0 
c01047dd:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01047e4:	00 
c01047e5:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01047ec:	e8 f1 bb ff ff       	call   c01003e2 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01047f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047f8:	e8 2f e1 ff ff       	call   c010292c <alloc_pages>
c01047fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104800:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104804:	75 24                	jne    c010482a <basic_check+0x355>
c0104806:	c7 44 24 0c 59 69 10 	movl   $0xc0106959,0xc(%esp)
c010480d:	c0 
c010480e:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104815:	c0 
c0104816:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c010481d:	00 
c010481e:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104825:	e8 b8 bb ff ff       	call   c01003e2 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010482a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104831:	e8 f6 e0 ff ff       	call   c010292c <alloc_pages>
c0104836:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104839:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010483d:	75 24                	jne    c0104863 <basic_check+0x38e>
c010483f:	c7 44 24 0c 75 69 10 	movl   $0xc0106975,0xc(%esp)
c0104846:	c0 
c0104847:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010484e:	c0 
c010484f:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0104856:	00 
c0104857:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010485e:	e8 7f bb ff ff       	call   c01003e2 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104863:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010486a:	e8 bd e0 ff ff       	call   c010292c <alloc_pages>
c010486f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104872:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104876:	75 24                	jne    c010489c <basic_check+0x3c7>
c0104878:	c7 44 24 0c 91 69 10 	movl   $0xc0106991,0xc(%esp)
c010487f:	c0 
c0104880:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104887:	c0 
c0104888:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c010488f:	00 
c0104890:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104897:	e8 46 bb ff ff       	call   c01003e2 <__panic>

    assert(alloc_page() == NULL);
c010489c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048a3:	e8 84 e0 ff ff       	call   c010292c <alloc_pages>
c01048a8:	85 c0                	test   %eax,%eax
c01048aa:	74 24                	je     c01048d0 <basic_check+0x3fb>
c01048ac:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c01048b3:	c0 
c01048b4:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01048bb:	c0 
c01048bc:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01048c3:	00 
c01048c4:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01048cb:	e8 12 bb ff ff       	call   c01003e2 <__panic>

    free_page(p0);
c01048d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01048d7:	00 
c01048d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048db:	89 04 24             	mov    %eax,(%esp)
c01048de:	e8 81 e0 ff ff       	call   c0102964 <free_pages>
c01048e3:	c7 45 d8 5c 89 11 c0 	movl   $0xc011895c,-0x28(%ebp)
c01048ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01048ed:	8b 40 04             	mov    0x4(%eax),%eax
c01048f0:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01048f3:	0f 94 c0             	sete   %al
c01048f6:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01048f9:	85 c0                	test   %eax,%eax
c01048fb:	74 24                	je     c0104921 <basic_check+0x44c>
c01048fd:	c7 44 24 0c a0 6a 10 	movl   $0xc0106aa0,0xc(%esp)
c0104904:	c0 
c0104905:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010490c:	c0 
c010490d:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0104914:	00 
c0104915:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010491c:	e8 c1 ba ff ff       	call   c01003e2 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104921:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104928:	e8 ff df ff ff       	call   c010292c <alloc_pages>
c010492d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104933:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104936:	74 24                	je     c010495c <basic_check+0x487>
c0104938:	c7 44 24 0c b8 6a 10 	movl   $0xc0106ab8,0xc(%esp)
c010493f:	c0 
c0104940:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104947:	c0 
c0104948:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010494f:	00 
c0104950:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104957:	e8 86 ba ff ff       	call   c01003e2 <__panic>
    assert(alloc_page() == NULL);
c010495c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104963:	e8 c4 df ff ff       	call   c010292c <alloc_pages>
c0104968:	85 c0                	test   %eax,%eax
c010496a:	74 24                	je     c0104990 <basic_check+0x4bb>
c010496c:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c0104973:	c0 
c0104974:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010497b:	c0 
c010497c:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0104983:	00 
c0104984:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010498b:	e8 52 ba ff ff       	call   c01003e2 <__panic>

    assert(nr_free == 0);
c0104990:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104995:	85 c0                	test   %eax,%eax
c0104997:	74 24                	je     c01049bd <basic_check+0x4e8>
c0104999:	c7 44 24 0c d1 6a 10 	movl   $0xc0106ad1,0xc(%esp)
c01049a0:	c0 
c01049a1:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c01049a8:	c0 
c01049a9:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c01049b0:	00 
c01049b1:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c01049b8:	e8 25 ba ff ff       	call   c01003e2 <__panic>
    free_list = free_list_store;
c01049bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049c0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049c3:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c01049c8:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    nr_free = nr_free_store;
c01049ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01049d1:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_page(p);
c01049d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01049dd:	00 
c01049de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049e1:	89 04 24             	mov    %eax,(%esp)
c01049e4:	e8 7b df ff ff       	call   c0102964 <free_pages>
    free_page(p1);
c01049e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01049f0:	00 
c01049f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f4:	89 04 24             	mov    %eax,(%esp)
c01049f7:	e8 68 df ff ff       	call   c0102964 <free_pages>
    free_page(p2);
c01049fc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a03:	00 
c0104a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a07:	89 04 24             	mov    %eax,(%esp)
c0104a0a:	e8 55 df ff ff       	call   c0102964 <free_pages>
}
c0104a0f:	c9                   	leave  
c0104a10:	c3                   	ret    

c0104a11 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104a11:	55                   	push   %ebp
c0104a12:	89 e5                	mov    %esp,%ebp
c0104a14:	53                   	push   %ebx
c0104a15:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0104a1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104a29:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104a30:	eb 6b                	jmp    c0104a9d <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0104a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a35:	83 e8 0c             	sub    $0xc,%eax
c0104a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0104a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a3e:	83 c0 04             	add    $0x4,%eax
c0104a41:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104a48:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104a4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104a4e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a51:	0f a3 10             	bt     %edx,(%eax)
c0104a54:	19 c0                	sbb    %eax,%eax
c0104a56:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104a59:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104a5d:	0f 95 c0             	setne  %al
c0104a60:	0f b6 c0             	movzbl %al,%eax
c0104a63:	85 c0                	test   %eax,%eax
c0104a65:	75 24                	jne    c0104a8b <default_check+0x7a>
c0104a67:	c7 44 24 0c de 6a 10 	movl   $0xc0106ade,0xc(%esp)
c0104a6e:	c0 
c0104a6f:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104a76:	c0 
c0104a77:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0104a7e:	00 
c0104a7f:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104a86:	e8 57 b9 ff ff       	call   c01003e2 <__panic>
        count ++, total += p->property;
c0104a8b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a92:	8b 50 08             	mov    0x8(%eax),%edx
c0104a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a98:	01 d0                	add    %edx,%eax
c0104a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aa0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104aa3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104aa6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104aa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104aac:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c0104ab3:	0f 85 79 ff ff ff    	jne    c0104a32 <default_check+0x21>
    }
    assert(total == nr_free_pages());
c0104ab9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104abc:	e8 d5 de ff ff       	call   c0102996 <nr_free_pages>
c0104ac1:	39 c3                	cmp    %eax,%ebx
c0104ac3:	74 24                	je     c0104ae9 <default_check+0xd8>
c0104ac5:	c7 44 24 0c ee 6a 10 	movl   $0xc0106aee,0xc(%esp)
c0104acc:	c0 
c0104acd:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104ad4:	c0 
c0104ad5:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104adc:	00 
c0104add:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104ae4:	e8 f9 b8 ff ff       	call   c01003e2 <__panic>

    basic_check();
c0104ae9:	e8 e7 f9 ff ff       	call   c01044d5 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104aee:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104af5:	e8 32 de ff ff       	call   c010292c <alloc_pages>
c0104afa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0104afd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104b01:	75 24                	jne    c0104b27 <default_check+0x116>
c0104b03:	c7 44 24 0c 07 6b 10 	movl   $0xc0106b07,0xc(%esp)
c0104b0a:	c0 
c0104b0b:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104b12:	c0 
c0104b13:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0104b1a:	00 
c0104b1b:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104b22:	e8 bb b8 ff ff       	call   c01003e2 <__panic>
    assert(!PageProperty(p0));
c0104b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b2a:	83 c0 04             	add    $0x4,%eax
c0104b2d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104b34:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b37:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104b3a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104b3d:	0f a3 10             	bt     %edx,(%eax)
c0104b40:	19 c0                	sbb    %eax,%eax
c0104b42:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104b45:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104b49:	0f 95 c0             	setne  %al
c0104b4c:	0f b6 c0             	movzbl %al,%eax
c0104b4f:	85 c0                	test   %eax,%eax
c0104b51:	74 24                	je     c0104b77 <default_check+0x166>
c0104b53:	c7 44 24 0c 12 6b 10 	movl   $0xc0106b12,0xc(%esp)
c0104b5a:	c0 
c0104b5b:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104b62:	c0 
c0104b63:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104b6a:	00 
c0104b6b:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104b72:	e8 6b b8 ff ff       	call   c01003e2 <__panic>

    list_entry_t free_list_store = free_list;
c0104b77:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104b7c:	8b 15 60 89 11 c0    	mov    0xc0118960,%edx
c0104b82:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104b85:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104b88:	c7 45 b4 5c 89 11 c0 	movl   $0xc011895c,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c0104b8f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104b92:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104b95:	89 50 04             	mov    %edx,0x4(%eax)
c0104b98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104b9b:	8b 50 04             	mov    0x4(%eax),%edx
c0104b9e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104ba1:	89 10                	mov    %edx,(%eax)
c0104ba3:	c7 45 b0 5c 89 11 c0 	movl   $0xc011895c,-0x50(%ebp)
    return list->next == list;
c0104baa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104bad:	8b 40 04             	mov    0x4(%eax),%eax
c0104bb0:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104bb3:	0f 94 c0             	sete   %al
c0104bb6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104bb9:	85 c0                	test   %eax,%eax
c0104bbb:	75 24                	jne    c0104be1 <default_check+0x1d0>
c0104bbd:	c7 44 24 0c 67 6a 10 	movl   $0xc0106a67,0xc(%esp)
c0104bc4:	c0 
c0104bc5:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104bcc:	c0 
c0104bcd:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104bd4:	00 
c0104bd5:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104bdc:	e8 01 b8 ff ff       	call   c01003e2 <__panic>
    assert(alloc_page() == NULL);
c0104be1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104be8:	e8 3f dd ff ff       	call   c010292c <alloc_pages>
c0104bed:	85 c0                	test   %eax,%eax
c0104bef:	74 24                	je     c0104c15 <default_check+0x204>
c0104bf1:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c0104bf8:	c0 
c0104bf9:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104c00:	c0 
c0104c01:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104c08:	00 
c0104c09:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104c10:	e8 cd b7 ff ff       	call   c01003e2 <__panic>

    unsigned int nr_free_store = nr_free;
c0104c15:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104c1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0104c1d:	c7 05 64 89 11 c0 00 	movl   $0x0,0xc0118964
c0104c24:	00 00 00 

    free_pages(p0 + 2, 3);
c0104c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c2a:	83 c0 28             	add    $0x28,%eax
c0104c2d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104c34:	00 
c0104c35:	89 04 24             	mov    %eax,(%esp)
c0104c38:	e8 27 dd ff ff       	call   c0102964 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104c3d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104c44:	e8 e3 dc ff ff       	call   c010292c <alloc_pages>
c0104c49:	85 c0                	test   %eax,%eax
c0104c4b:	74 24                	je     c0104c71 <default_check+0x260>
c0104c4d:	c7 44 24 0c 24 6b 10 	movl   $0xc0106b24,0xc(%esp)
c0104c54:	c0 
c0104c55:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104c5c:	c0 
c0104c5d:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104c64:	00 
c0104c65:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104c6c:	e8 71 b7 ff ff       	call   c01003e2 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c74:	83 c0 28             	add    $0x28,%eax
c0104c77:	83 c0 04             	add    $0x4,%eax
c0104c7a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104c81:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c84:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104c87:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104c8a:	0f a3 10             	bt     %edx,(%eax)
c0104c8d:	19 c0                	sbb    %eax,%eax
c0104c8f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104c92:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104c96:	0f 95 c0             	setne  %al
c0104c99:	0f b6 c0             	movzbl %al,%eax
c0104c9c:	85 c0                	test   %eax,%eax
c0104c9e:	74 0e                	je     c0104cae <default_check+0x29d>
c0104ca0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ca3:	83 c0 28             	add    $0x28,%eax
c0104ca6:	8b 40 08             	mov    0x8(%eax),%eax
c0104ca9:	83 f8 03             	cmp    $0x3,%eax
c0104cac:	74 24                	je     c0104cd2 <default_check+0x2c1>
c0104cae:	c7 44 24 0c 3c 6b 10 	movl   $0xc0106b3c,0xc(%esp)
c0104cb5:	c0 
c0104cb6:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104cbd:	c0 
c0104cbe:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0104cc5:	00 
c0104cc6:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104ccd:	e8 10 b7 ff ff       	call   c01003e2 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104cd2:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104cd9:	e8 4e dc ff ff       	call   c010292c <alloc_pages>
c0104cde:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ce1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104ce5:	75 24                	jne    c0104d0b <default_check+0x2fa>
c0104ce7:	c7 44 24 0c 68 6b 10 	movl   $0xc0106b68,0xc(%esp)
c0104cee:	c0 
c0104cef:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104cf6:	c0 
c0104cf7:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104cfe:	00 
c0104cff:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104d06:	e8 d7 b6 ff ff       	call   c01003e2 <__panic>
    assert(alloc_page() == NULL);
c0104d0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d12:	e8 15 dc ff ff       	call   c010292c <alloc_pages>
c0104d17:	85 c0                	test   %eax,%eax
c0104d19:	74 24                	je     c0104d3f <default_check+0x32e>
c0104d1b:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c0104d22:	c0 
c0104d23:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104d2a:	c0 
c0104d2b:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0104d32:	00 
c0104d33:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104d3a:	e8 a3 b6 ff ff       	call   c01003e2 <__panic>
    assert(p0 + 2 == p1);
c0104d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d42:	83 c0 28             	add    $0x28,%eax
c0104d45:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104d48:	74 24                	je     c0104d6e <default_check+0x35d>
c0104d4a:	c7 44 24 0c 86 6b 10 	movl   $0xc0106b86,0xc(%esp)
c0104d51:	c0 
c0104d52:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104d59:	c0 
c0104d5a:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0104d61:	00 
c0104d62:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104d69:	e8 74 b6 ff ff       	call   c01003e2 <__panic>

    p2 = p0 + 1;
c0104d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d71:	83 c0 14             	add    $0x14,%eax
c0104d74:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104d77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d7e:	00 
c0104d7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d82:	89 04 24             	mov    %eax,(%esp)
c0104d85:	e8 da db ff ff       	call   c0102964 <free_pages>
    free_pages(p1, 3);
c0104d8a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104d91:	00 
c0104d92:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d95:	89 04 24             	mov    %eax,(%esp)
c0104d98:	e8 c7 db ff ff       	call   c0102964 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104da0:	83 c0 04             	add    $0x4,%eax
c0104da3:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104daa:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104dad:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104db0:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104db3:	0f a3 10             	bt     %edx,(%eax)
c0104db6:	19 c0                	sbb    %eax,%eax
c0104db8:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104dbb:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104dbf:	0f 95 c0             	setne  %al
c0104dc2:	0f b6 c0             	movzbl %al,%eax
c0104dc5:	85 c0                	test   %eax,%eax
c0104dc7:	74 0b                	je     c0104dd4 <default_check+0x3c3>
c0104dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dcc:	8b 40 08             	mov    0x8(%eax),%eax
c0104dcf:	83 f8 01             	cmp    $0x1,%eax
c0104dd2:	74 24                	je     c0104df8 <default_check+0x3e7>
c0104dd4:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0104ddb:	c0 
c0104ddc:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104de3:	c0 
c0104de4:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0104deb:	00 
c0104dec:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104df3:	e8 ea b5 ff ff       	call   c01003e2 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104df8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104dfb:	83 c0 04             	add    $0x4,%eax
c0104dfe:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104e05:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e08:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104e0b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104e0e:	0f a3 10             	bt     %edx,(%eax)
c0104e11:	19 c0                	sbb    %eax,%eax
c0104e13:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104e16:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104e1a:	0f 95 c0             	setne  %al
c0104e1d:	0f b6 c0             	movzbl %al,%eax
c0104e20:	85 c0                	test   %eax,%eax
c0104e22:	74 0b                	je     c0104e2f <default_check+0x41e>
c0104e24:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e27:	8b 40 08             	mov    0x8(%eax),%eax
c0104e2a:	83 f8 03             	cmp    $0x3,%eax
c0104e2d:	74 24                	je     c0104e53 <default_check+0x442>
c0104e2f:	c7 44 24 0c bc 6b 10 	movl   $0xc0106bbc,0xc(%esp)
c0104e36:	c0 
c0104e37:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104e3e:	c0 
c0104e3f:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104e46:	00 
c0104e47:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104e4e:	e8 8f b5 ff ff       	call   c01003e2 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104e53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e5a:	e8 cd da ff ff       	call   c010292c <alloc_pages>
c0104e5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e62:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104e65:	83 e8 14             	sub    $0x14,%eax
c0104e68:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e6b:	74 24                	je     c0104e91 <default_check+0x480>
c0104e6d:	c7 44 24 0c e2 6b 10 	movl   $0xc0106be2,0xc(%esp)
c0104e74:	c0 
c0104e75:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104e7c:	c0 
c0104e7d:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0104e84:	00 
c0104e85:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104e8c:	e8 51 b5 ff ff       	call   c01003e2 <__panic>
    free_page(p0);
c0104e91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e98:	00 
c0104e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e9c:	89 04 24             	mov    %eax,(%esp)
c0104e9f:	e8 c0 da ff ff       	call   c0102964 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104ea4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104eab:	e8 7c da ff ff       	call   c010292c <alloc_pages>
c0104eb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104eb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104eb6:	83 c0 14             	add    $0x14,%eax
c0104eb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104ebc:	74 24                	je     c0104ee2 <default_check+0x4d1>
c0104ebe:	c7 44 24 0c 00 6c 10 	movl   $0xc0106c00,0xc(%esp)
c0104ec5:	c0 
c0104ec6:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104ecd:	c0 
c0104ece:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0104ed5:	00 
c0104ed6:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104edd:	e8 00 b5 ff ff       	call   c01003e2 <__panic>

    free_pages(p0, 2);
c0104ee2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104ee9:	00 
c0104eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eed:	89 04 24             	mov    %eax,(%esp)
c0104ef0:	e8 6f da ff ff       	call   c0102964 <free_pages>
    free_page(p2);
c0104ef5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104efc:	00 
c0104efd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104f00:	89 04 24             	mov    %eax,(%esp)
c0104f03:	e8 5c da ff ff       	call   c0102964 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104f08:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104f0f:	e8 18 da ff ff       	call   c010292c <alloc_pages>
c0104f14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f1b:	75 24                	jne    c0104f41 <default_check+0x530>
c0104f1d:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c0104f24:	c0 
c0104f25:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104f2c:	c0 
c0104f2d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104f34:	00 
c0104f35:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104f3c:	e8 a1 b4 ff ff       	call   c01003e2 <__panic>
    assert(alloc_page() == NULL);
c0104f41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f48:	e8 df d9 ff ff       	call   c010292c <alloc_pages>
c0104f4d:	85 c0                	test   %eax,%eax
c0104f4f:	74 24                	je     c0104f75 <default_check+0x564>
c0104f51:	c7 44 24 0c 7e 6a 10 	movl   $0xc0106a7e,0xc(%esp)
c0104f58:	c0 
c0104f59:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104f60:	c0 
c0104f61:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0104f68:	00 
c0104f69:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104f70:	e8 6d b4 ff ff       	call   c01003e2 <__panic>

    assert(nr_free == 0);
c0104f75:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0104f7a:	85 c0                	test   %eax,%eax
c0104f7c:	74 24                	je     c0104fa2 <default_check+0x591>
c0104f7e:	c7 44 24 0c d1 6a 10 	movl   $0xc0106ad1,0xc(%esp)
c0104f85:	c0 
c0104f86:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0104f8d:	c0 
c0104f8e:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104f95:	00 
c0104f96:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0104f9d:	e8 40 b4 ff ff       	call   c01003e2 <__panic>
    nr_free = nr_free_store;
c0104fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa5:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    free_list = free_list_store;
c0104faa:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104fad:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104fb0:	a3 5c 89 11 c0       	mov    %eax,0xc011895c
c0104fb5:	89 15 60 89 11 c0    	mov    %edx,0xc0118960
    free_pages(p0, 5);
c0104fbb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104fc2:	00 
c0104fc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fc6:	89 04 24             	mov    %eax,(%esp)
c0104fc9:	e8 96 d9 ff ff       	call   c0102964 <free_pages>

    le = &free_list;
c0104fce:	c7 45 ec 5c 89 11 c0 	movl   $0xc011895c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104fd5:	eb 1d                	jmp    c0104ff4 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104fd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fda:	83 e8 0c             	sub    $0xc,%eax
c0104fdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104fe0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104fe4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104fe7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104fea:	8b 40 08             	mov    0x8(%eax),%eax
c0104fed:	29 c2                	sub    %eax,%edx
c0104fef:	89 d0                	mov    %edx,%eax
c0104ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ff7:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0104ffa:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104ffd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105000:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105003:	81 7d ec 5c 89 11 c0 	cmpl   $0xc011895c,-0x14(%ebp)
c010500a:	75 cb                	jne    c0104fd7 <default_check+0x5c6>
    }
    assert(count == 0);
c010500c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105010:	74 24                	je     c0105036 <default_check+0x625>
c0105012:	c7 44 24 0c 3e 6c 10 	movl   $0xc0106c3e,0xc(%esp)
c0105019:	c0 
c010501a:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c0105021:	c0 
c0105022:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0105029:	00 
c010502a:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c0105031:	e8 ac b3 ff ff       	call   c01003e2 <__panic>
    assert(total == 0);
c0105036:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010503a:	74 24                	je     c0105060 <default_check+0x64f>
c010503c:	c7 44 24 0c 49 6c 10 	movl   $0xc0106c49,0xc(%esp)
c0105043:	c0 
c0105044:	c7 44 24 08 f6 68 10 	movl   $0xc01068f6,0x8(%esp)
c010504b:	c0 
c010504c:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0105053:	00 
c0105054:	c7 04 24 0b 69 10 c0 	movl   $0xc010690b,(%esp)
c010505b:	e8 82 b3 ff ff       	call   c01003e2 <__panic>
}
c0105060:	81 c4 94 00 00 00    	add    $0x94,%esp
c0105066:	5b                   	pop    %ebx
c0105067:	5d                   	pop    %ebp
c0105068:	c3                   	ret    

c0105069 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105069:	55                   	push   %ebp
c010506a:	89 e5                	mov    %esp,%ebp
c010506c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010506f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105076:	eb 04                	jmp    c010507c <strlen+0x13>
        cnt ++;
c0105078:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c010507c:	8b 45 08             	mov    0x8(%ebp),%eax
c010507f:	8d 50 01             	lea    0x1(%eax),%edx
c0105082:	89 55 08             	mov    %edx,0x8(%ebp)
c0105085:	0f b6 00             	movzbl (%eax),%eax
c0105088:	84 c0                	test   %al,%al
c010508a:	75 ec                	jne    c0105078 <strlen+0xf>
    }
    return cnt;
c010508c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010508f:	c9                   	leave  
c0105090:	c3                   	ret    

c0105091 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105091:	55                   	push   %ebp
c0105092:	89 e5                	mov    %esp,%ebp
c0105094:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105097:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010509e:	eb 04                	jmp    c01050a4 <strnlen+0x13>
        cnt ++;
c01050a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01050a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050aa:	73 10                	jae    c01050bc <strnlen+0x2b>
c01050ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01050af:	8d 50 01             	lea    0x1(%eax),%edx
c01050b2:	89 55 08             	mov    %edx,0x8(%ebp)
c01050b5:	0f b6 00             	movzbl (%eax),%eax
c01050b8:	84 c0                	test   %al,%al
c01050ba:	75 e4                	jne    c01050a0 <strnlen+0xf>
    }
    return cnt;
c01050bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01050bf:	c9                   	leave  
c01050c0:	c3                   	ret    

c01050c1 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01050c1:	55                   	push   %ebp
c01050c2:	89 e5                	mov    %esp,%ebp
c01050c4:	57                   	push   %edi
c01050c5:	56                   	push   %esi
c01050c6:	83 ec 20             	sub    $0x20,%esp
c01050c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01050cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01050cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01050d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050db:	89 d1                	mov    %edx,%ecx
c01050dd:	89 c2                	mov    %eax,%edx
c01050df:	89 ce                	mov    %ecx,%esi
c01050e1:	89 d7                	mov    %edx,%edi
c01050e3:	ac                   	lods   %ds:(%esi),%al
c01050e4:	aa                   	stos   %al,%es:(%edi)
c01050e5:	84 c0                	test   %al,%al
c01050e7:	75 fa                	jne    c01050e3 <strcpy+0x22>
c01050e9:	89 fa                	mov    %edi,%edx
c01050eb:	89 f1                	mov    %esi,%ecx
c01050ed:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01050f0:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01050f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01050f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01050f9:	83 c4 20             	add    $0x20,%esp
c01050fc:	5e                   	pop    %esi
c01050fd:	5f                   	pop    %edi
c01050fe:	5d                   	pop    %ebp
c01050ff:	c3                   	ret    

c0105100 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105100:	55                   	push   %ebp
c0105101:	89 e5                	mov    %esp,%ebp
c0105103:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105106:	8b 45 08             	mov    0x8(%ebp),%eax
c0105109:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010510c:	eb 21                	jmp    c010512f <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010510e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105111:	0f b6 10             	movzbl (%eax),%edx
c0105114:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105117:	88 10                	mov    %dl,(%eax)
c0105119:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010511c:	0f b6 00             	movzbl (%eax),%eax
c010511f:	84 c0                	test   %al,%al
c0105121:	74 04                	je     c0105127 <strncpy+0x27>
            src ++;
c0105123:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105127:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010512b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c010512f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105133:	75 d9                	jne    c010510e <strncpy+0xe>
    }
    return dst;
c0105135:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105138:	c9                   	leave  
c0105139:	c3                   	ret    

c010513a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010513a:	55                   	push   %ebp
c010513b:	89 e5                	mov    %esp,%ebp
c010513d:	57                   	push   %edi
c010513e:	56                   	push   %esi
c010513f:	83 ec 20             	sub    $0x20,%esp
c0105142:	8b 45 08             	mov    0x8(%ebp),%eax
c0105145:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105148:	8b 45 0c             	mov    0xc(%ebp),%eax
c010514b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c010514e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105151:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105154:	89 d1                	mov    %edx,%ecx
c0105156:	89 c2                	mov    %eax,%edx
c0105158:	89 ce                	mov    %ecx,%esi
c010515a:	89 d7                	mov    %edx,%edi
c010515c:	ac                   	lods   %ds:(%esi),%al
c010515d:	ae                   	scas   %es:(%edi),%al
c010515e:	75 08                	jne    c0105168 <strcmp+0x2e>
c0105160:	84 c0                	test   %al,%al
c0105162:	75 f8                	jne    c010515c <strcmp+0x22>
c0105164:	31 c0                	xor    %eax,%eax
c0105166:	eb 04                	jmp    c010516c <strcmp+0x32>
c0105168:	19 c0                	sbb    %eax,%eax
c010516a:	0c 01                	or     $0x1,%al
c010516c:	89 fa                	mov    %edi,%edx
c010516e:	89 f1                	mov    %esi,%ecx
c0105170:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105173:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105176:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105179:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010517c:	83 c4 20             	add    $0x20,%esp
c010517f:	5e                   	pop    %esi
c0105180:	5f                   	pop    %edi
c0105181:	5d                   	pop    %ebp
c0105182:	c3                   	ret    

c0105183 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105183:	55                   	push   %ebp
c0105184:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105186:	eb 0c                	jmp    c0105194 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105188:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010518c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105190:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105194:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105198:	74 1a                	je     c01051b4 <strncmp+0x31>
c010519a:	8b 45 08             	mov    0x8(%ebp),%eax
c010519d:	0f b6 00             	movzbl (%eax),%eax
c01051a0:	84 c0                	test   %al,%al
c01051a2:	74 10                	je     c01051b4 <strncmp+0x31>
c01051a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a7:	0f b6 10             	movzbl (%eax),%edx
c01051aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051ad:	0f b6 00             	movzbl (%eax),%eax
c01051b0:	38 c2                	cmp    %al,%dl
c01051b2:	74 d4                	je     c0105188 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01051b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051b8:	74 18                	je     c01051d2 <strncmp+0x4f>
c01051ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bd:	0f b6 00             	movzbl (%eax),%eax
c01051c0:	0f b6 d0             	movzbl %al,%edx
c01051c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051c6:	0f b6 00             	movzbl (%eax),%eax
c01051c9:	0f b6 c0             	movzbl %al,%eax
c01051cc:	29 c2                	sub    %eax,%edx
c01051ce:	89 d0                	mov    %edx,%eax
c01051d0:	eb 05                	jmp    c01051d7 <strncmp+0x54>
c01051d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01051d7:	5d                   	pop    %ebp
c01051d8:	c3                   	ret    

c01051d9 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01051d9:	55                   	push   %ebp
c01051da:	89 e5                	mov    %esp,%ebp
c01051dc:	83 ec 04             	sub    $0x4,%esp
c01051df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051e2:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01051e5:	eb 14                	jmp    c01051fb <strchr+0x22>
        if (*s == c) {
c01051e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01051ea:	0f b6 00             	movzbl (%eax),%eax
c01051ed:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01051f0:	75 05                	jne    c01051f7 <strchr+0x1e>
            return (char *)s;
c01051f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f5:	eb 13                	jmp    c010520a <strchr+0x31>
        }
        s ++;
c01051f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01051fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fe:	0f b6 00             	movzbl (%eax),%eax
c0105201:	84 c0                	test   %al,%al
c0105203:	75 e2                	jne    c01051e7 <strchr+0xe>
    }
    return NULL;
c0105205:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010520a:	c9                   	leave  
c010520b:	c3                   	ret    

c010520c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010520c:	55                   	push   %ebp
c010520d:	89 e5                	mov    %esp,%ebp
c010520f:	83 ec 04             	sub    $0x4,%esp
c0105212:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105215:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105218:	eb 11                	jmp    c010522b <strfind+0x1f>
        if (*s == c) {
c010521a:	8b 45 08             	mov    0x8(%ebp),%eax
c010521d:	0f b6 00             	movzbl (%eax),%eax
c0105220:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105223:	75 02                	jne    c0105227 <strfind+0x1b>
            break;
c0105225:	eb 0e                	jmp    c0105235 <strfind+0x29>
        }
        s ++;
c0105227:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010522b:	8b 45 08             	mov    0x8(%ebp),%eax
c010522e:	0f b6 00             	movzbl (%eax),%eax
c0105231:	84 c0                	test   %al,%al
c0105233:	75 e5                	jne    c010521a <strfind+0xe>
    }
    return (char *)s;
c0105235:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105238:	c9                   	leave  
c0105239:	c3                   	ret    

c010523a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010523a:	55                   	push   %ebp
c010523b:	89 e5                	mov    %esp,%ebp
c010523d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105247:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010524e:	eb 04                	jmp    c0105254 <strtol+0x1a>
        s ++;
c0105250:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0105254:	8b 45 08             	mov    0x8(%ebp),%eax
c0105257:	0f b6 00             	movzbl (%eax),%eax
c010525a:	3c 20                	cmp    $0x20,%al
c010525c:	74 f2                	je     c0105250 <strtol+0x16>
c010525e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105261:	0f b6 00             	movzbl (%eax),%eax
c0105264:	3c 09                	cmp    $0x9,%al
c0105266:	74 e8                	je     c0105250 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105268:	8b 45 08             	mov    0x8(%ebp),%eax
c010526b:	0f b6 00             	movzbl (%eax),%eax
c010526e:	3c 2b                	cmp    $0x2b,%al
c0105270:	75 06                	jne    c0105278 <strtol+0x3e>
        s ++;
c0105272:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105276:	eb 15                	jmp    c010528d <strtol+0x53>
    }
    else if (*s == '-') {
c0105278:	8b 45 08             	mov    0x8(%ebp),%eax
c010527b:	0f b6 00             	movzbl (%eax),%eax
c010527e:	3c 2d                	cmp    $0x2d,%al
c0105280:	75 0b                	jne    c010528d <strtol+0x53>
        s ++, neg = 1;
c0105282:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105286:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010528d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105291:	74 06                	je     c0105299 <strtol+0x5f>
c0105293:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105297:	75 24                	jne    c01052bd <strtol+0x83>
c0105299:	8b 45 08             	mov    0x8(%ebp),%eax
c010529c:	0f b6 00             	movzbl (%eax),%eax
c010529f:	3c 30                	cmp    $0x30,%al
c01052a1:	75 1a                	jne    c01052bd <strtol+0x83>
c01052a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a6:	83 c0 01             	add    $0x1,%eax
c01052a9:	0f b6 00             	movzbl (%eax),%eax
c01052ac:	3c 78                	cmp    $0x78,%al
c01052ae:	75 0d                	jne    c01052bd <strtol+0x83>
        s += 2, base = 16;
c01052b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01052b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01052bb:	eb 2a                	jmp    c01052e7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01052bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052c1:	75 17                	jne    c01052da <strtol+0xa0>
c01052c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052c6:	0f b6 00             	movzbl (%eax),%eax
c01052c9:	3c 30                	cmp    $0x30,%al
c01052cb:	75 0d                	jne    c01052da <strtol+0xa0>
        s ++, base = 8;
c01052cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01052d1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01052d8:	eb 0d                	jmp    c01052e7 <strtol+0xad>
    }
    else if (base == 0) {
c01052da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01052de:	75 07                	jne    c01052e7 <strtol+0xad>
        base = 10;
c01052e0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01052e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ea:	0f b6 00             	movzbl (%eax),%eax
c01052ed:	3c 2f                	cmp    $0x2f,%al
c01052ef:	7e 1b                	jle    c010530c <strtol+0xd2>
c01052f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f4:	0f b6 00             	movzbl (%eax),%eax
c01052f7:	3c 39                	cmp    $0x39,%al
c01052f9:	7f 11                	jg     c010530c <strtol+0xd2>
            dig = *s - '0';
c01052fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01052fe:	0f b6 00             	movzbl (%eax),%eax
c0105301:	0f be c0             	movsbl %al,%eax
c0105304:	83 e8 30             	sub    $0x30,%eax
c0105307:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010530a:	eb 48                	jmp    c0105354 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010530c:	8b 45 08             	mov    0x8(%ebp),%eax
c010530f:	0f b6 00             	movzbl (%eax),%eax
c0105312:	3c 60                	cmp    $0x60,%al
c0105314:	7e 1b                	jle    c0105331 <strtol+0xf7>
c0105316:	8b 45 08             	mov    0x8(%ebp),%eax
c0105319:	0f b6 00             	movzbl (%eax),%eax
c010531c:	3c 7a                	cmp    $0x7a,%al
c010531e:	7f 11                	jg     c0105331 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105320:	8b 45 08             	mov    0x8(%ebp),%eax
c0105323:	0f b6 00             	movzbl (%eax),%eax
c0105326:	0f be c0             	movsbl %al,%eax
c0105329:	83 e8 57             	sub    $0x57,%eax
c010532c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010532f:	eb 23                	jmp    c0105354 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105331:	8b 45 08             	mov    0x8(%ebp),%eax
c0105334:	0f b6 00             	movzbl (%eax),%eax
c0105337:	3c 40                	cmp    $0x40,%al
c0105339:	7e 3d                	jle    c0105378 <strtol+0x13e>
c010533b:	8b 45 08             	mov    0x8(%ebp),%eax
c010533e:	0f b6 00             	movzbl (%eax),%eax
c0105341:	3c 5a                	cmp    $0x5a,%al
c0105343:	7f 33                	jg     c0105378 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105345:	8b 45 08             	mov    0x8(%ebp),%eax
c0105348:	0f b6 00             	movzbl (%eax),%eax
c010534b:	0f be c0             	movsbl %al,%eax
c010534e:	83 e8 37             	sub    $0x37,%eax
c0105351:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105354:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105357:	3b 45 10             	cmp    0x10(%ebp),%eax
c010535a:	7c 02                	jl     c010535e <strtol+0x124>
            break;
c010535c:	eb 1a                	jmp    c0105378 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010535e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105362:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105365:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105369:	89 c2                	mov    %eax,%edx
c010536b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010536e:	01 d0                	add    %edx,%eax
c0105370:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105373:	e9 6f ff ff ff       	jmp    c01052e7 <strtol+0xad>

    if (endptr) {
c0105378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010537c:	74 08                	je     c0105386 <strtol+0x14c>
        *endptr = (char *) s;
c010537e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105381:	8b 55 08             	mov    0x8(%ebp),%edx
c0105384:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105386:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010538a:	74 07                	je     c0105393 <strtol+0x159>
c010538c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010538f:	f7 d8                	neg    %eax
c0105391:	eb 03                	jmp    c0105396 <strtol+0x15c>
c0105393:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105396:	c9                   	leave  
c0105397:	c3                   	ret    

c0105398 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105398:	55                   	push   %ebp
c0105399:	89 e5                	mov    %esp,%ebp
c010539b:	57                   	push   %edi
c010539c:	83 ec 24             	sub    $0x24,%esp
c010539f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053a2:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01053a5:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01053a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01053ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01053af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01053b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01053b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01053b8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01053bb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01053bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01053c2:	89 d7                	mov    %edx,%edi
c01053c4:	f3 aa                	rep stos %al,%es:(%edi)
c01053c6:	89 fa                	mov    %edi,%edx
c01053c8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01053cb:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01053ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01053d1:	83 c4 24             	add    $0x24,%esp
c01053d4:	5f                   	pop    %edi
c01053d5:	5d                   	pop    %ebp
c01053d6:	c3                   	ret    

c01053d7 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01053d7:	55                   	push   %ebp
c01053d8:	89 e5                	mov    %esp,%ebp
c01053da:	57                   	push   %edi
c01053db:	56                   	push   %esi
c01053dc:	53                   	push   %ebx
c01053dd:	83 ec 30             	sub    $0x30,%esp
c01053e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01053ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01053f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053f5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01053f8:	73 42                	jae    c010543c <memmove+0x65>
c01053fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105400:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105403:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105406:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105409:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010540c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010540f:	c1 e8 02             	shr    $0x2,%eax
c0105412:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105414:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105417:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010541a:	89 d7                	mov    %edx,%edi
c010541c:	89 c6                	mov    %eax,%esi
c010541e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105420:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105423:	83 e1 03             	and    $0x3,%ecx
c0105426:	74 02                	je     c010542a <memmove+0x53>
c0105428:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010542a:	89 f0                	mov    %esi,%eax
c010542c:	89 fa                	mov    %edi,%edx
c010542e:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105431:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105434:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010543a:	eb 36                	jmp    c0105472 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010543c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010543f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105442:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105445:	01 c2                	add    %eax,%edx
c0105447:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010544a:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010544d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105450:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105453:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105456:	89 c1                	mov    %eax,%ecx
c0105458:	89 d8                	mov    %ebx,%eax
c010545a:	89 d6                	mov    %edx,%esi
c010545c:	89 c7                	mov    %eax,%edi
c010545e:	fd                   	std    
c010545f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105461:	fc                   	cld    
c0105462:	89 f8                	mov    %edi,%eax
c0105464:	89 f2                	mov    %esi,%edx
c0105466:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105469:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010546c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c010546f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105472:	83 c4 30             	add    $0x30,%esp
c0105475:	5b                   	pop    %ebx
c0105476:	5e                   	pop    %esi
c0105477:	5f                   	pop    %edi
c0105478:	5d                   	pop    %ebp
c0105479:	c3                   	ret    

c010547a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010547a:	55                   	push   %ebp
c010547b:	89 e5                	mov    %esp,%ebp
c010547d:	57                   	push   %edi
c010547e:	56                   	push   %esi
c010547f:	83 ec 20             	sub    $0x20,%esp
c0105482:	8b 45 08             	mov    0x8(%ebp),%eax
c0105485:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105488:	8b 45 0c             	mov    0xc(%ebp),%eax
c010548b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010548e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105491:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105494:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105497:	c1 e8 02             	shr    $0x2,%eax
c010549a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010549c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010549f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a2:	89 d7                	mov    %edx,%edi
c01054a4:	89 c6                	mov    %eax,%esi
c01054a6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01054a8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01054ab:	83 e1 03             	and    $0x3,%ecx
c01054ae:	74 02                	je     c01054b2 <memcpy+0x38>
c01054b0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01054b2:	89 f0                	mov    %esi,%eax
c01054b4:	89 fa                	mov    %edi,%edx
c01054b6:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01054b9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01054bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01054bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01054c2:	83 c4 20             	add    $0x20,%esp
c01054c5:	5e                   	pop    %esi
c01054c6:	5f                   	pop    %edi
c01054c7:	5d                   	pop    %ebp
c01054c8:	c3                   	ret    

c01054c9 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01054c9:	55                   	push   %ebp
c01054ca:	89 e5                	mov    %esp,%ebp
c01054cc:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01054cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01054d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01054d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01054db:	eb 30                	jmp    c010550d <memcmp+0x44>
        if (*s1 != *s2) {
c01054dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054e0:	0f b6 10             	movzbl (%eax),%edx
c01054e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054e6:	0f b6 00             	movzbl (%eax),%eax
c01054e9:	38 c2                	cmp    %al,%dl
c01054eb:	74 18                	je     c0105505 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01054ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054f0:	0f b6 00             	movzbl (%eax),%eax
c01054f3:	0f b6 d0             	movzbl %al,%edx
c01054f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01054f9:	0f b6 00             	movzbl (%eax),%eax
c01054fc:	0f b6 c0             	movzbl %al,%eax
c01054ff:	29 c2                	sub    %eax,%edx
c0105501:	89 d0                	mov    %edx,%eax
c0105503:	eb 1a                	jmp    c010551f <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105505:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105509:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c010550d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105510:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105513:	89 55 10             	mov    %edx,0x10(%ebp)
c0105516:	85 c0                	test   %eax,%eax
c0105518:	75 c3                	jne    c01054dd <memcmp+0x14>
    }
    return 0;
c010551a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010551f:	c9                   	leave  
c0105520:	c3                   	ret    

c0105521 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105521:	55                   	push   %ebp
c0105522:	89 e5                	mov    %esp,%ebp
c0105524:	83 ec 58             	sub    $0x58,%esp
c0105527:	8b 45 10             	mov    0x10(%ebp),%eax
c010552a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010552d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105530:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105533:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105539:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010553c:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010553f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105545:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105548:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010554b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010554e:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105554:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105557:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010555b:	74 1c                	je     c0105579 <printnum+0x58>
c010555d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105560:	ba 00 00 00 00       	mov    $0x0,%edx
c0105565:	f7 75 e4             	divl   -0x1c(%ebp)
c0105568:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010556b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010556e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105573:	f7 75 e4             	divl   -0x1c(%ebp)
c0105576:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105579:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010557c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010557f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105582:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105585:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105588:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010558b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010558e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105591:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105594:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105597:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010559a:	8b 45 18             	mov    0x18(%ebp),%eax
c010559d:	ba 00 00 00 00       	mov    $0x0,%edx
c01055a2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01055a5:	77 56                	ja     c01055fd <printnum+0xdc>
c01055a7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01055aa:	72 05                	jb     c01055b1 <printnum+0x90>
c01055ac:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01055af:	77 4c                	ja     c01055fd <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01055b1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01055b4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01055b7:	8b 45 20             	mov    0x20(%ebp),%eax
c01055ba:	89 44 24 18          	mov    %eax,0x18(%esp)
c01055be:	89 54 24 14          	mov    %edx,0x14(%esp)
c01055c2:	8b 45 18             	mov    0x18(%ebp),%eax
c01055c5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01055c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055cf:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055de:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e1:	89 04 24             	mov    %eax,(%esp)
c01055e4:	e8 38 ff ff ff       	call   c0105521 <printnum>
c01055e9:	eb 1c                	jmp    c0105607 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01055eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055f2:	8b 45 20             	mov    0x20(%ebp),%eax
c01055f5:	89 04 24             	mov    %eax,(%esp)
c01055f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fb:	ff d0                	call   *%eax
        while (-- width > 0)
c01055fd:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105601:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105605:	7f e4                	jg     c01055eb <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105607:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010560a:	05 04 6d 10 c0       	add    $0xc0106d04,%eax
c010560f:	0f b6 00             	movzbl (%eax),%eax
c0105612:	0f be c0             	movsbl %al,%eax
c0105615:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105618:	89 54 24 04          	mov    %edx,0x4(%esp)
c010561c:	89 04 24             	mov    %eax,(%esp)
c010561f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105622:	ff d0                	call   *%eax
}
c0105624:	c9                   	leave  
c0105625:	c3                   	ret    

c0105626 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105626:	55                   	push   %ebp
c0105627:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105629:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010562d:	7e 14                	jle    c0105643 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010562f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105632:	8b 00                	mov    (%eax),%eax
c0105634:	8d 48 08             	lea    0x8(%eax),%ecx
c0105637:	8b 55 08             	mov    0x8(%ebp),%edx
c010563a:	89 0a                	mov    %ecx,(%edx)
c010563c:	8b 50 04             	mov    0x4(%eax),%edx
c010563f:	8b 00                	mov    (%eax),%eax
c0105641:	eb 30                	jmp    c0105673 <getuint+0x4d>
    }
    else if (lflag) {
c0105643:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105647:	74 16                	je     c010565f <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105649:	8b 45 08             	mov    0x8(%ebp),%eax
c010564c:	8b 00                	mov    (%eax),%eax
c010564e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105651:	8b 55 08             	mov    0x8(%ebp),%edx
c0105654:	89 0a                	mov    %ecx,(%edx)
c0105656:	8b 00                	mov    (%eax),%eax
c0105658:	ba 00 00 00 00       	mov    $0x0,%edx
c010565d:	eb 14                	jmp    c0105673 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010565f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105662:	8b 00                	mov    (%eax),%eax
c0105664:	8d 48 04             	lea    0x4(%eax),%ecx
c0105667:	8b 55 08             	mov    0x8(%ebp),%edx
c010566a:	89 0a                	mov    %ecx,(%edx)
c010566c:	8b 00                	mov    (%eax),%eax
c010566e:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105673:	5d                   	pop    %ebp
c0105674:	c3                   	ret    

c0105675 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105675:	55                   	push   %ebp
c0105676:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105678:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010567c:	7e 14                	jle    c0105692 <getint+0x1d>
        return va_arg(*ap, long long);
c010567e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105681:	8b 00                	mov    (%eax),%eax
c0105683:	8d 48 08             	lea    0x8(%eax),%ecx
c0105686:	8b 55 08             	mov    0x8(%ebp),%edx
c0105689:	89 0a                	mov    %ecx,(%edx)
c010568b:	8b 50 04             	mov    0x4(%eax),%edx
c010568e:	8b 00                	mov    (%eax),%eax
c0105690:	eb 28                	jmp    c01056ba <getint+0x45>
    }
    else if (lflag) {
c0105692:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105696:	74 12                	je     c01056aa <getint+0x35>
        return va_arg(*ap, long);
c0105698:	8b 45 08             	mov    0x8(%ebp),%eax
c010569b:	8b 00                	mov    (%eax),%eax
c010569d:	8d 48 04             	lea    0x4(%eax),%ecx
c01056a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01056a3:	89 0a                	mov    %ecx,(%edx)
c01056a5:	8b 00                	mov    (%eax),%eax
c01056a7:	99                   	cltd   
c01056a8:	eb 10                	jmp    c01056ba <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01056aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ad:	8b 00                	mov    (%eax),%eax
c01056af:	8d 48 04             	lea    0x4(%eax),%ecx
c01056b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01056b5:	89 0a                	mov    %ecx,(%edx)
c01056b7:	8b 00                	mov    (%eax),%eax
c01056b9:	99                   	cltd   
    }
}
c01056ba:	5d                   	pop    %ebp
c01056bb:	c3                   	ret    

c01056bc <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01056bc:	55                   	push   %ebp
c01056bd:	89 e5                	mov    %esp,%ebp
c01056bf:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01056c2:	8d 45 14             	lea    0x14(%ebp),%eax
c01056c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01056c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01056d2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e0:	89 04 24             	mov    %eax,(%esp)
c01056e3:	e8 02 00 00 00       	call   c01056ea <vprintfmt>
    va_end(ap);
}
c01056e8:	c9                   	leave  
c01056e9:	c3                   	ret    

c01056ea <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01056ea:	55                   	push   %ebp
c01056eb:	89 e5                	mov    %esp,%ebp
c01056ed:	56                   	push   %esi
c01056ee:	53                   	push   %ebx
c01056ef:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01056f2:	eb 18                	jmp    c010570c <vprintfmt+0x22>
            if (ch == '\0') {
c01056f4:	85 db                	test   %ebx,%ebx
c01056f6:	75 05                	jne    c01056fd <vprintfmt+0x13>
                return;
c01056f8:	e9 d1 03 00 00       	jmp    c0105ace <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01056fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105700:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105704:	89 1c 24             	mov    %ebx,(%esp)
c0105707:	8b 45 08             	mov    0x8(%ebp),%eax
c010570a:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010570c:	8b 45 10             	mov    0x10(%ebp),%eax
c010570f:	8d 50 01             	lea    0x1(%eax),%edx
c0105712:	89 55 10             	mov    %edx,0x10(%ebp)
c0105715:	0f b6 00             	movzbl (%eax),%eax
c0105718:	0f b6 d8             	movzbl %al,%ebx
c010571b:	83 fb 25             	cmp    $0x25,%ebx
c010571e:	75 d4                	jne    c01056f4 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105720:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105724:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010572b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010572e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105731:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105738:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010573b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010573e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105741:	8d 50 01             	lea    0x1(%eax),%edx
c0105744:	89 55 10             	mov    %edx,0x10(%ebp)
c0105747:	0f b6 00             	movzbl (%eax),%eax
c010574a:	0f b6 d8             	movzbl %al,%ebx
c010574d:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105750:	83 f8 55             	cmp    $0x55,%eax
c0105753:	0f 87 44 03 00 00    	ja     c0105a9d <vprintfmt+0x3b3>
c0105759:	8b 04 85 28 6d 10 c0 	mov    -0x3fef92d8(,%eax,4),%eax
c0105760:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105762:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105766:	eb d6                	jmp    c010573e <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105768:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010576c:	eb d0                	jmp    c010573e <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010576e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105775:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105778:	89 d0                	mov    %edx,%eax
c010577a:	c1 e0 02             	shl    $0x2,%eax
c010577d:	01 d0                	add    %edx,%eax
c010577f:	01 c0                	add    %eax,%eax
c0105781:	01 d8                	add    %ebx,%eax
c0105783:	83 e8 30             	sub    $0x30,%eax
c0105786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105789:	8b 45 10             	mov    0x10(%ebp),%eax
c010578c:	0f b6 00             	movzbl (%eax),%eax
c010578f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105792:	83 fb 2f             	cmp    $0x2f,%ebx
c0105795:	7e 0b                	jle    c01057a2 <vprintfmt+0xb8>
c0105797:	83 fb 39             	cmp    $0x39,%ebx
c010579a:	7f 06                	jg     c01057a2 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
c010579c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
c01057a0:	eb d3                	jmp    c0105775 <vprintfmt+0x8b>
            goto process_precision;
c01057a2:	eb 33                	jmp    c01057d7 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01057a4:	8b 45 14             	mov    0x14(%ebp),%eax
c01057a7:	8d 50 04             	lea    0x4(%eax),%edx
c01057aa:	89 55 14             	mov    %edx,0x14(%ebp)
c01057ad:	8b 00                	mov    (%eax),%eax
c01057af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01057b2:	eb 23                	jmp    c01057d7 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01057b4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057b8:	79 0c                	jns    c01057c6 <vprintfmt+0xdc>
                width = 0;
c01057ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01057c1:	e9 78 ff ff ff       	jmp    c010573e <vprintfmt+0x54>
c01057c6:	e9 73 ff ff ff       	jmp    c010573e <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01057cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01057d2:	e9 67 ff ff ff       	jmp    c010573e <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01057d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057db:	79 12                	jns    c01057ef <vprintfmt+0x105>
                width = precision, precision = -1;
c01057dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057e3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01057ea:	e9 4f ff ff ff       	jmp    c010573e <vprintfmt+0x54>
c01057ef:	e9 4a ff ff ff       	jmp    c010573e <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01057f4:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01057f8:	e9 41 ff ff ff       	jmp    c010573e <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01057fd:	8b 45 14             	mov    0x14(%ebp),%eax
c0105800:	8d 50 04             	lea    0x4(%eax),%edx
c0105803:	89 55 14             	mov    %edx,0x14(%ebp)
c0105806:	8b 00                	mov    (%eax),%eax
c0105808:	8b 55 0c             	mov    0xc(%ebp),%edx
c010580b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010580f:	89 04 24             	mov    %eax,(%esp)
c0105812:	8b 45 08             	mov    0x8(%ebp),%eax
c0105815:	ff d0                	call   *%eax
            break;
c0105817:	e9 ac 02 00 00       	jmp    c0105ac8 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010581c:	8b 45 14             	mov    0x14(%ebp),%eax
c010581f:	8d 50 04             	lea    0x4(%eax),%edx
c0105822:	89 55 14             	mov    %edx,0x14(%ebp)
c0105825:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105827:	85 db                	test   %ebx,%ebx
c0105829:	79 02                	jns    c010582d <vprintfmt+0x143>
                err = -err;
c010582b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010582d:	83 fb 06             	cmp    $0x6,%ebx
c0105830:	7f 0b                	jg     c010583d <vprintfmt+0x153>
c0105832:	8b 34 9d e8 6c 10 c0 	mov    -0x3fef9318(,%ebx,4),%esi
c0105839:	85 f6                	test   %esi,%esi
c010583b:	75 23                	jne    c0105860 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010583d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105841:	c7 44 24 08 15 6d 10 	movl   $0xc0106d15,0x8(%esp)
c0105848:	c0 
c0105849:	8b 45 0c             	mov    0xc(%ebp),%eax
c010584c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105850:	8b 45 08             	mov    0x8(%ebp),%eax
c0105853:	89 04 24             	mov    %eax,(%esp)
c0105856:	e8 61 fe ff ff       	call   c01056bc <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010585b:	e9 68 02 00 00       	jmp    c0105ac8 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
c0105860:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105864:	c7 44 24 08 1e 6d 10 	movl   $0xc0106d1e,0x8(%esp)
c010586b:	c0 
c010586c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105873:	8b 45 08             	mov    0x8(%ebp),%eax
c0105876:	89 04 24             	mov    %eax,(%esp)
c0105879:	e8 3e fe ff ff       	call   c01056bc <printfmt>
            break;
c010587e:	e9 45 02 00 00       	jmp    c0105ac8 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105883:	8b 45 14             	mov    0x14(%ebp),%eax
c0105886:	8d 50 04             	lea    0x4(%eax),%edx
c0105889:	89 55 14             	mov    %edx,0x14(%ebp)
c010588c:	8b 30                	mov    (%eax),%esi
c010588e:	85 f6                	test   %esi,%esi
c0105890:	75 05                	jne    c0105897 <vprintfmt+0x1ad>
                p = "(null)";
c0105892:	be 21 6d 10 c0       	mov    $0xc0106d21,%esi
            }
            if (width > 0 && padc != '-') {
c0105897:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010589b:	7e 3e                	jle    c01058db <vprintfmt+0x1f1>
c010589d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01058a1:	74 38                	je     c01058db <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058a3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01058a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058ad:	89 34 24             	mov    %esi,(%esp)
c01058b0:	e8 dc f7 ff ff       	call   c0105091 <strnlen>
c01058b5:	29 c3                	sub    %eax,%ebx
c01058b7:	89 d8                	mov    %ebx,%eax
c01058b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058bc:	eb 17                	jmp    c01058d5 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01058be:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01058c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058c5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058c9:	89 04 24             	mov    %eax,(%esp)
c01058cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01058cf:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c01058d1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01058d5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058d9:	7f e3                	jg     c01058be <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01058db:	eb 38                	jmp    c0105915 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01058dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01058e1:	74 1f                	je     c0105902 <vprintfmt+0x218>
c01058e3:	83 fb 1f             	cmp    $0x1f,%ebx
c01058e6:	7e 05                	jle    c01058ed <vprintfmt+0x203>
c01058e8:	83 fb 7e             	cmp    $0x7e,%ebx
c01058eb:	7e 15                	jle    c0105902 <vprintfmt+0x218>
                    putch('?', putdat);
c01058ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01058fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fe:	ff d0                	call   *%eax
c0105900:	eb 0f                	jmp    c0105911 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105902:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105905:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105909:	89 1c 24             	mov    %ebx,(%esp)
c010590c:	8b 45 08             	mov    0x8(%ebp),%eax
c010590f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105911:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105915:	89 f0                	mov    %esi,%eax
c0105917:	8d 70 01             	lea    0x1(%eax),%esi
c010591a:	0f b6 00             	movzbl (%eax),%eax
c010591d:	0f be d8             	movsbl %al,%ebx
c0105920:	85 db                	test   %ebx,%ebx
c0105922:	74 10                	je     c0105934 <vprintfmt+0x24a>
c0105924:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105928:	78 b3                	js     c01058dd <vprintfmt+0x1f3>
c010592a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010592e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105932:	79 a9                	jns    c01058dd <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
c0105934:	eb 17                	jmp    c010594d <vprintfmt+0x263>
                putch(' ', putdat);
c0105936:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105939:	89 44 24 04          	mov    %eax,0x4(%esp)
c010593d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105944:	8b 45 08             	mov    0x8(%ebp),%eax
c0105947:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105949:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010594d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105951:	7f e3                	jg     c0105936 <vprintfmt+0x24c>
            }
            break;
c0105953:	e9 70 01 00 00       	jmp    c0105ac8 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105958:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010595b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010595f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105962:	89 04 24             	mov    %eax,(%esp)
c0105965:	e8 0b fd ff ff       	call   c0105675 <getint>
c010596a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010596d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105970:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105973:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105976:	85 d2                	test   %edx,%edx
c0105978:	79 26                	jns    c01059a0 <vprintfmt+0x2b6>
                putch('-', putdat);
c010597a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105981:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105988:	8b 45 08             	mov    0x8(%ebp),%eax
c010598b:	ff d0                	call   *%eax
                num = -(long long)num;
c010598d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105990:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105993:	f7 d8                	neg    %eax
c0105995:	83 d2 00             	adc    $0x0,%edx
c0105998:	f7 da                	neg    %edx
c010599a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010599d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01059a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059a7:	e9 a8 00 00 00       	jmp    c0105a54 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01059ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059b3:	8d 45 14             	lea    0x14(%ebp),%eax
c01059b6:	89 04 24             	mov    %eax,(%esp)
c01059b9:	e8 68 fc ff ff       	call   c0105626 <getuint>
c01059be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01059c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01059cb:	e9 84 00 00 00       	jmp    c0105a54 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01059d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d7:	8d 45 14             	lea    0x14(%ebp),%eax
c01059da:	89 04 24             	mov    %eax,(%esp)
c01059dd:	e8 44 fc ff ff       	call   c0105626 <getuint>
c01059e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059e5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01059e8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01059ef:	eb 63                	jmp    c0105a54 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01059f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f8:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01059ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a02:	ff d0                	call   *%eax
            putch('x', putdat);
c0105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a0b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a15:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105a17:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a1a:	8d 50 04             	lea    0x4(%eax),%edx
c0105a1d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a20:	8b 00                	mov    (%eax),%eax
c0105a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105a2c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105a33:	eb 1f                	jmp    c0105a54 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a3c:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a3f:	89 04 24             	mov    %eax,(%esp)
c0105a42:	e8 df fb ff ff       	call   c0105626 <getuint>
c0105a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105a4d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105a54:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a5b:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105a5f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105a62:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105a66:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a70:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a74:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105a78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a82:	89 04 24             	mov    %eax,(%esp)
c0105a85:	e8 97 fa ff ff       	call   c0105521 <printnum>
            break;
c0105a8a:	eb 3c                	jmp    c0105ac8 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a93:	89 1c 24             	mov    %ebx,(%esp)
c0105a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a99:	ff d0                	call   *%eax
            break;
c0105a9b:	eb 2b                	jmp    c0105ac8 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa4:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aae:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105ab0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ab4:	eb 04                	jmp    c0105aba <vprintfmt+0x3d0>
c0105ab6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105aba:	8b 45 10             	mov    0x10(%ebp),%eax
c0105abd:	83 e8 01             	sub    $0x1,%eax
c0105ac0:	0f b6 00             	movzbl (%eax),%eax
c0105ac3:	3c 25                	cmp    $0x25,%al
c0105ac5:	75 ef                	jne    c0105ab6 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105ac7:	90                   	nop
        }
    }
c0105ac8:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105ac9:	e9 3e fc ff ff       	jmp    c010570c <vprintfmt+0x22>
}
c0105ace:	83 c4 40             	add    $0x40,%esp
c0105ad1:	5b                   	pop    %ebx
c0105ad2:	5e                   	pop    %esi
c0105ad3:	5d                   	pop    %ebp
c0105ad4:	c3                   	ret    

c0105ad5 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105ad5:	55                   	push   %ebp
c0105ad6:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105adb:	8b 40 08             	mov    0x8(%eax),%eax
c0105ade:	8d 50 01             	lea    0x1(%eax),%edx
c0105ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae4:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aea:	8b 10                	mov    (%eax),%edx
c0105aec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aef:	8b 40 04             	mov    0x4(%eax),%eax
c0105af2:	39 c2                	cmp    %eax,%edx
c0105af4:	73 12                	jae    c0105b08 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105af6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af9:	8b 00                	mov    (%eax),%eax
c0105afb:	8d 48 01             	lea    0x1(%eax),%ecx
c0105afe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b01:	89 0a                	mov    %ecx,(%edx)
c0105b03:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b06:	88 10                	mov    %dl,(%eax)
    }
}
c0105b08:	5d                   	pop    %ebp
c0105b09:	c3                   	ret    

c0105b0a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105b0a:	55                   	push   %ebp
c0105b0b:	89 e5                	mov    %esp,%ebp
c0105b0d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105b10:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b19:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b20:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2e:	89 04 24             	mov    %eax,(%esp)
c0105b31:	e8 08 00 00 00       	call   c0105b3e <vsnprintf>
c0105b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105b3c:	c9                   	leave  
c0105b3d:	c3                   	ret    

c0105b3e <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105b3e:	55                   	push   %ebp
c0105b3f:	89 e5                	mov    %esp,%ebp
c0105b41:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b47:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b53:	01 d0                	add    %edx,%eax
c0105b55:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105b5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b63:	74 0a                	je     c0105b6f <vsnprintf+0x31>
c0105b65:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b6b:	39 c2                	cmp    %eax,%edx
c0105b6d:	76 07                	jbe    c0105b76 <vsnprintf+0x38>
        return -E_INVAL;
c0105b6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105b74:	eb 2a                	jmp    c0105ba0 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105b76:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b79:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b80:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b84:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105b87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b8b:	c7 04 24 d5 5a 10 c0 	movl   $0xc0105ad5,(%esp)
c0105b92:	e8 53 fb ff ff       	call   c01056ea <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b9a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ba0:	c9                   	leave  
c0105ba1:	c3                   	ret    
