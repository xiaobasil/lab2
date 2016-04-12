
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
  100030:	ba 88 89 11 00       	mov    $0x118988,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 ad 5b 00 00       	call   105c03 <memset>

    cons_init();                // init the console
  100056:	e8 77 15 00 00       	call   1015d2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 a0 5d 10 00 	movl   $0x105da0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 bc 5d 10 00 	movl   $0x105dbc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 2f 42 00 00       	call   1042b3 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b2 16 00 00       	call   10173b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 04 18 00 00       	call   101892 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f5 0c 00 00       	call   100d88 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 11 16 00 00       	call   1016a9 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 fe 0b 00 00       	call   100cba <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 c1 5d 10 00 	movl   $0x105dc1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 cf 5d 10 00 	movl   $0x105dcf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 dd 5d 10 00 	movl   $0x105ddd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 eb 5d 10 00 	movl   $0x105deb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 f9 5d 10 00 	movl   $0x105df9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 08 5e 10 00 	movl   $0x105e08,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 28 5e 10 00 	movl   $0x105e28,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 47 5e 10 00 	movl   $0x105e47,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 04 13 00 00       	call   1015fe <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 e5 50 00 00       	call   10541c <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8b 12 00 00       	call   1015fe <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6b 12 00 00       	call   10163a <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 4c 5e 10 00    	movl   $0x105e4c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 4c 5e 10 00 	movl   $0x105e4c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 a8 70 10 00 	movl   $0x1070a8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 64 1a 11 00 	movl   $0x111a64,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 65 1a 11 00 	movl   $0x111a65,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 96 44 11 00 	movl   $0x114496,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 8b 53 00 00       	call   105a77 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 56 5e 10 00 	movl   $0x105e56,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 6f 5e 10 00 	movl   $0x105e6f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 8c 5d 10 	movl   $0x105d8c,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 87 5e 10 00 	movl   $0x105e87,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 9f 5e 10 00 	movl   $0x105e9f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 88 89 11 	movl   $0x118988,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 b7 5e 10 00 	movl   $0x105eb7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 88 89 11 00       	mov    $0x118988,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 d0 5e 10 00 	movl   $0x105ed0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 fa 5e 10 00 	movl   $0x105efa,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 16 5f 10 00 	movl   $0x105f16,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
uint32_t ebp=read_ebp(),eip=read_eip();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&ebp>0;i++)
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 8e 00 00 00       	jmp    100a6d <print_stackframe+0xb3>
	{
		cprintf("ebp:0x%08x eip:0x%08x ",ebp,eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 28 5f 10 00 	movl   $0x105f28,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
		cprintf("args:");
  1009f9:	c7 04 24 3f 5f 10 00 	movl   $0x105f3f,(%esp)
  100a00:	e8 37 f9 ff ff       	call   10033c <cprintf>
		int j;
		for(j=0;j<4;j++)
  100a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a0c:	eb 28                	jmp    100a36 <print_stackframe+0x7c>
			cprintf("0x%08x ",((uint32_t *)ebp)[2+j]);
  100a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a11:	83 c0 02             	add    $0x2,%eax
  100a14:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1e:	01 d0                	add    %edx,%eax
  100a20:	8b 00                	mov    (%eax),%eax
  100a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a26:	c7 04 24 45 5f 10 00 	movl   $0x105f45,(%esp)
  100a2d:	e8 0a f9 ff ff       	call   10033c <cprintf>
	for(i=0;i<STACKFRAME_DEPTH&&ebp>0;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x ",ebp,eip);
		cprintf("args:");
		int j;
		for(j=0;j<4;j++)
  100a32:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a36:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3a:	7e d2                	jle    100a0e <print_stackframe+0x54>
			cprintf("0x%08x ",((uint32_t *)ebp)[2+j]);
		cprintf("\n");
  100a3c:	c7 04 24 4d 5f 10 00 	movl   $0x105f4d,(%esp)
  100a43:	e8 f4 f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(eip-1);
  100a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4b:	83 e8 01             	sub    $0x1,%eax
  100a4e:	89 04 24             	mov    %eax,(%esp)
  100a51:	e8 b0 fe ff ff       	call   100906 <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
  100a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a59:	83 c0 04             	add    $0x4,%eax
  100a5c:	8b 00                	mov    (%eax),%eax
  100a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
  100a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a64:	8b 00                	mov    (%eax),%eax
  100a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
uint32_t ebp=read_ebp(),eip=read_eip();
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&ebp>0;i++)
  100a69:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a71:	7f 0a                	jg     100a7d <print_stackframe+0xc3>
  100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a77:	0f 85 62 ff ff ff    	jne    1009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip=((uint32_t *)ebp)[1];
		ebp=((uint32_t *)ebp)[0];
	}
}
  100a7d:	c9                   	leave  
  100a7e:	c3                   	ret    

00100a7f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a7f:	55                   	push   %ebp
  100a80:	89 e5                	mov    %esp,%ebp
  100a82:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8c:	eb 0c                	jmp    100a9a <parse+0x1b>
            *buf ++ = '\0';
  100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a91:	8d 50 01             	lea    0x1(%eax),%edx
  100a94:	89 55 08             	mov    %edx,0x8(%ebp)
  100a97:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9d:	0f b6 00             	movzbl (%eax),%eax
  100aa0:	84 c0                	test   %al,%al
  100aa2:	74 1d                	je     100ac1 <parse+0x42>
  100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa7:	0f b6 00             	movzbl (%eax),%eax
  100aaa:	0f be c0             	movsbl %al,%eax
  100aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab1:	c7 04 24 d0 5f 10 00 	movl   $0x105fd0,(%esp)
  100ab8:	e8 87 4f 00 00       	call   105a44 <strchr>
  100abd:	85 c0                	test   %eax,%eax
  100abf:	75 cd                	jne    100a8e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac4:	0f b6 00             	movzbl (%eax),%eax
  100ac7:	84 c0                	test   %al,%al
  100ac9:	75 02                	jne    100acd <parse+0x4e>
            break;
  100acb:	eb 67                	jmp    100b34 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100acd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad1:	75 14                	jne    100ae7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ada:	00 
  100adb:	c7 04 24 d5 5f 10 00 	movl   $0x105fd5,(%esp)
  100ae2:	e8 55 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aea:	8d 50 01             	lea    0x1(%eax),%edx
  100aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afa:	01 c2                	add    %eax,%edx
  100afc:	8b 45 08             	mov    0x8(%ebp),%eax
  100aff:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	eb 04                	jmp    100b07 <parse+0x88>
            buf ++;
  100b03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b07:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0a:	0f b6 00             	movzbl (%eax),%eax
  100b0d:	84 c0                	test   %al,%al
  100b0f:	74 1d                	je     100b2e <parse+0xaf>
  100b11:	8b 45 08             	mov    0x8(%ebp),%eax
  100b14:	0f b6 00             	movzbl (%eax),%eax
  100b17:	0f be c0             	movsbl %al,%eax
  100b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1e:	c7 04 24 d0 5f 10 00 	movl   $0x105fd0,(%esp)
  100b25:	e8 1a 4f 00 00       	call   105a44 <strchr>
  100b2a:	85 c0                	test   %eax,%eax
  100b2c:	74 d5                	je     100b03 <parse+0x84>
            buf ++;
        }
    }
  100b2e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2f:	e9 66 ff ff ff       	jmp    100a9a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b37:	c9                   	leave  
  100b38:	c3                   	ret    

00100b39 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b39:	55                   	push   %ebp
  100b3a:	89 e5                	mov    %esp,%ebp
  100b3c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b3f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b46:	8b 45 08             	mov    0x8(%ebp),%eax
  100b49:	89 04 24             	mov    %eax,(%esp)
  100b4c:	e8 2e ff ff ff       	call   100a7f <parse>
  100b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b58:	75 0a                	jne    100b64 <runcmd+0x2b>
        return 0;
  100b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b5f:	e9 85 00 00 00       	jmp    100be9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6b:	eb 5c                	jmp    100bc9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b73:	89 d0                	mov    %edx,%eax
  100b75:	01 c0                	add    %eax,%eax
  100b77:	01 d0                	add    %edx,%eax
  100b79:	c1 e0 02             	shl    $0x2,%eax
  100b7c:	05 20 70 11 00       	add    $0x117020,%eax
  100b81:	8b 00                	mov    (%eax),%eax
  100b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b87:	89 04 24             	mov    %eax,(%esp)
  100b8a:	e8 16 4e 00 00       	call   1059a5 <strcmp>
  100b8f:	85 c0                	test   %eax,%eax
  100b91:	75 32                	jne    100bc5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b96:	89 d0                	mov    %edx,%eax
  100b98:	01 c0                	add    %eax,%eax
  100b9a:	01 d0                	add    %edx,%eax
  100b9c:	c1 e0 02             	shl    $0x2,%eax
  100b9f:	05 20 70 11 00       	add    $0x117020,%eax
  100ba4:	8b 40 08             	mov    0x8(%eax),%eax
  100ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100baa:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb0:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb4:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb7:	83 c2 04             	add    $0x4,%edx
  100bba:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbe:	89 0c 24             	mov    %ecx,(%esp)
  100bc1:	ff d0                	call   *%eax
  100bc3:	eb 24                	jmp    100be9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcc:	83 f8 02             	cmp    $0x2,%eax
  100bcf:	76 9c                	jbe    100b6d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd8:	c7 04 24 f3 5f 10 00 	movl   $0x105ff3,(%esp)
  100bdf:	e8 58 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be9:	c9                   	leave  
  100bea:	c3                   	ret    

00100beb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100beb:	55                   	push   %ebp
  100bec:	89 e5                	mov    %esp,%ebp
  100bee:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf1:	c7 04 24 0c 60 10 00 	movl   $0x10600c,(%esp)
  100bf8:	e8 3f f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfd:	c7 04 24 34 60 10 00 	movl   $0x106034,(%esp)
  100c04:	e8 33 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0d:	74 0b                	je     100c1a <kmonitor+0x2f>
        print_trapframe(tf);
  100c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c12:	89 04 24             	mov    %eax,(%esp)
  100c15:	e8 b0 0d 00 00       	call   1019ca <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1a:	c7 04 24 59 60 10 00 	movl   $0x106059,(%esp)
  100c21:	e8 0d f6 ff ff       	call   100233 <readline>
  100c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2d:	74 18                	je     100c47 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c39:	89 04 24             	mov    %eax,(%esp)
  100c3c:	e8 f8 fe ff ff       	call   100b39 <runcmd>
  100c41:	85 c0                	test   %eax,%eax
  100c43:	79 02                	jns    100c47 <kmonitor+0x5c>
                break;
  100c45:	eb 02                	jmp    100c49 <kmonitor+0x5e>
            }
        }
    }
  100c47:	eb d1                	jmp    100c1a <kmonitor+0x2f>
}
  100c49:	c9                   	leave  
  100c4a:	c3                   	ret    

00100c4b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4b:	55                   	push   %ebp
  100c4c:	89 e5                	mov    %esp,%ebp
  100c4e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c58:	eb 3f                	jmp    100c99 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5d:	89 d0                	mov    %edx,%eax
  100c5f:	01 c0                	add    %eax,%eax
  100c61:	01 d0                	add    %edx,%eax
  100c63:	c1 e0 02             	shl    $0x2,%eax
  100c66:	05 20 70 11 00       	add    $0x117020,%eax
  100c6b:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c71:	89 d0                	mov    %edx,%eax
  100c73:	01 c0                	add    %eax,%eax
  100c75:	01 d0                	add    %edx,%eax
  100c77:	c1 e0 02             	shl    $0x2,%eax
  100c7a:	05 20 70 11 00       	add    $0x117020,%eax
  100c7f:	8b 00                	mov    (%eax),%eax
  100c81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c89:	c7 04 24 5d 60 10 00 	movl   $0x10605d,(%esp)
  100c90:	e8 a7 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9c:	83 f8 02             	cmp    $0x2,%eax
  100c9f:	76 b9                	jbe    100c5a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca6:	c9                   	leave  
  100ca7:	c3                   	ret    

00100ca8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca8:	55                   	push   %ebp
  100ca9:	89 e5                	mov    %esp,%ebp
  100cab:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cae:	e8 bd fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb8:	c9                   	leave  
  100cb9:	c3                   	ret    

00100cba <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cba:	55                   	push   %ebp
  100cbb:	89 e5                	mov    %esp,%ebp
  100cbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc0:	e8 f5 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cca:	c9                   	leave  
  100ccb:	c3                   	ret    

00100ccc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccc:	55                   	push   %ebp
  100ccd:	89 e5                	mov    %esp,%ebp
  100ccf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd2:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd7:	85 c0                	test   %eax,%eax
  100cd9:	74 02                	je     100cdd <__panic+0x11>
        goto panic_dead;
  100cdb:	eb 48                	jmp    100d25 <__panic+0x59>
    }
    is_panic = 1;
  100cdd:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce7:	8d 45 14             	lea    0x14(%ebp),%eax
  100cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfb:	c7 04 24 66 60 10 00 	movl   $0x106066,(%esp)
  100d02:	e8 35 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  100d11:	89 04 24             	mov    %eax,(%esp)
  100d14:	e8 f0 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d19:	c7 04 24 82 60 10 00 	movl   $0x106082,(%esp)
  100d20:	e8 17 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d25:	e8 85 09 00 00       	call   1016af <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d31:	e8 b5 fe ff ff       	call   100beb <kmonitor>
    }
  100d36:	eb f2                	jmp    100d2a <__panic+0x5e>

00100d38 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d38:	55                   	push   %ebp
  100d39:	89 e5                	mov    %esp,%ebp
  100d3b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3e:	8d 45 14             	lea    0x14(%ebp),%eax
  100d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d47:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d52:	c7 04 24 84 60 10 00 	movl   $0x106084,(%esp)
  100d59:	e8 de f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d61:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d65:	8b 45 10             	mov    0x10(%ebp),%eax
  100d68:	89 04 24             	mov    %eax,(%esp)
  100d6b:	e8 99 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d70:	c7 04 24 82 60 10 00 	movl   $0x106082,(%esp)
  100d77:	e8 c0 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7c:	c9                   	leave  
  100d7d:	c3                   	ret    

00100d7e <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7e:	55                   	push   %ebp
  100d7f:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d81:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d86:	5d                   	pop    %ebp
  100d87:	c3                   	ret    

00100d88 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d88:	55                   	push   %ebp
  100d89:	89 e5                	mov    %esp,%ebp
  100d8b:	83 ec 28             	sub    $0x28,%esp
  100d8e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d94:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d98:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da0:	ee                   	out    %al,(%dx)
  100da1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100daf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db3:	ee                   	out    %al,(%dx)
  100db4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dba:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc7:	c7 05 6c 89 11 00 00 	movl   $0x0,0x11896c
  100dce:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd1:	c7 04 24 a2 60 10 00 	movl   $0x1060a2,(%esp)
  100dd8:	e8 5f f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100ddd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de4:	e8 24 09 00 00       	call   10170d <pic_enable>
}
  100de9:	c9                   	leave  
  100dea:	c3                   	ret    

00100deb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100deb:	55                   	push   %ebp
  100dec:	89 e5                	mov    %esp,%ebp
  100dee:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df1:	9c                   	pushf  
  100df2:	58                   	pop    %eax
  100df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df9:	25 00 02 00 00       	and    $0x200,%eax
  100dfe:	85 c0                	test   %eax,%eax
  100e00:	74 0c                	je     100e0e <__intr_save+0x23>
        intr_disable();
  100e02:	e8 a8 08 00 00       	call   1016af <intr_disable>
        return 1;
  100e07:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0c:	eb 05                	jmp    100e13 <__intr_save+0x28>
    }
    return 0;
  100e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e13:	c9                   	leave  
  100e14:	c3                   	ret    

00100e15 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e15:	55                   	push   %ebp
  100e16:	89 e5                	mov    %esp,%ebp
  100e18:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e1f:	74 05                	je     100e26 <__intr_restore+0x11>
        intr_enable();
  100e21:	e8 83 08 00 00       	call   1016a9 <intr_enable>
    }
}
  100e26:	c9                   	leave  
  100e27:	c3                   	ret    

00100e28 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e28:	55                   	push   %ebp
  100e29:	89 e5                	mov    %esp,%ebp
  100e2b:	83 ec 10             	sub    $0x10,%esp
  100e2e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e34:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e38:	89 c2                	mov    %eax,%edx
  100e3a:	ec                   	in     (%dx),%al
  100e3b:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e44:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e48:	89 c2                	mov    %eax,%edx
  100e4a:	ec                   	in     (%dx),%al
  100e4b:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e54:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e58:	89 c2                	mov    %eax,%edx
  100e5a:	ec                   	in     (%dx),%al
  100e5b:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e64:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e68:	89 c2                	mov    %eax,%edx
  100e6a:	ec                   	in     (%dx),%al
  100e6b:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6e:	c9                   	leave  
  100e6f:	c3                   	ret    

00100e70 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e70:	55                   	push   %ebp
  100e71:	89 e5                	mov    %esp,%ebp
  100e73:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e76:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e80:	0f b7 00             	movzwl (%eax),%eax
  100e83:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e92:	0f b7 00             	movzwl (%eax),%eax
  100e95:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e99:	74 12                	je     100ead <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea2:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea9:	b4 03 
  100eab:	eb 13                	jmp    100ec0 <cga_init+0x50>
    } else {
        *cp = was;
  100ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb7:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ebe:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec0:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec7:	0f b7 c0             	movzwl %ax,%eax
  100eca:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ece:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eda:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100edb:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee2:	83 c0 01             	add    $0x1,%eax
  100ee5:	0f b7 c0             	movzwl %ax,%eax
  100ee8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eec:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef0:	89 c2                	mov    %eax,%edx
  100ef2:	ec                   	in     (%dx),%al
  100ef3:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efa:	0f b6 c0             	movzbl %al,%eax
  100efd:	c1 e0 08             	shl    $0x8,%eax
  100f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f03:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0a:	0f b7 c0             	movzwl %ax,%eax
  100f0d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f11:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f15:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f19:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f25:	83 c0 01             	add    $0x1,%eax
  100f28:	0f b7 c0             	movzwl %ax,%eax
  100f2b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f33:	89 c2                	mov    %eax,%edx
  100f35:	ec                   	in     (%dx),%al
  100f36:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f39:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3d:	0f b6 c0             	movzbl %al,%eax
  100f40:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f46:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4e:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f54:	c9                   	leave  
  100f55:	c3                   	ret    

00100f56 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f56:	55                   	push   %ebp
  100f57:	89 e5                	mov    %esp,%ebp
  100f59:	83 ec 48             	sub    $0x48,%esp
  100f5c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f62:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f66:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6e:	ee                   	out    %al,(%dx)
  100f6f:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f75:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f79:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f81:	ee                   	out    %al,(%dx)
  100f82:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f88:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f94:	ee                   	out    %al,(%dx)
  100f95:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9b:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f9f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa7:	ee                   	out    %al,(%dx)
  100fa8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fae:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fba:	ee                   	out    %al,(%dx)
  100fbb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc1:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fcd:	ee                   	out    %al,(%dx)
  100fce:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd4:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe0:	ee                   	out    %al,(%dx)
  100fe1:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe7:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100feb:	89 c2                	mov    %eax,%edx
  100fed:	ec                   	in     (%dx),%al
  100fee:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff5:	3c ff                	cmp    $0xff,%al
  100ff7:	0f 95 c0             	setne  %al
  100ffa:	0f b6 c0             	movzbl %al,%eax
  100ffd:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101002:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101008:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100c:	89 c2                	mov    %eax,%edx
  10100e:	ec                   	in     (%dx),%al
  10100f:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101012:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101018:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101c:	89 c2                	mov    %eax,%edx
  10101e:	ec                   	in     (%dx),%al
  10101f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101022:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101027:	85 c0                	test   %eax,%eax
  101029:	74 0c                	je     101037 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101032:	e8 d6 06 00 00       	call   10170d <pic_enable>
    }
}
  101037:	c9                   	leave  
  101038:	c3                   	ret    

00101039 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101039:	55                   	push   %ebp
  10103a:	89 e5                	mov    %esp,%ebp
  10103c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10103f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101046:	eb 09                	jmp    101051 <lpt_putc_sub+0x18>
        delay();
  101048:	e8 db fd ff ff       	call   100e28 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101051:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101057:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105b:	89 c2                	mov    %eax,%edx
  10105d:	ec                   	in     (%dx),%al
  10105e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101061:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101065:	84 c0                	test   %al,%al
  101067:	78 09                	js     101072 <lpt_putc_sub+0x39>
  101069:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101070:	7e d6                	jle    101048 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101072:	8b 45 08             	mov    0x8(%ebp),%eax
  101075:	0f b6 c0             	movzbl %al,%eax
  101078:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107e:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101081:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101085:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101089:	ee                   	out    %al,(%dx)
  10108a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101090:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101094:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101098:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109c:	ee                   	out    %al,(%dx)
  10109d:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ab:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010af:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b0:	c9                   	leave  
  1010b1:	c3                   	ret    

001010b2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b2:	55                   	push   %ebp
  1010b3:	89 e5                	mov    %esp,%ebp
  1010b5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bc:	74 0d                	je     1010cb <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010be:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c1:	89 04 24             	mov    %eax,(%esp)
  1010c4:	e8 70 ff ff ff       	call   101039 <lpt_putc_sub>
  1010c9:	eb 24                	jmp    1010ef <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010cb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d2:	e8 62 ff ff ff       	call   101039 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010de:	e8 56 ff ff ff       	call   101039 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ea:	e8 4a ff ff ff       	call   101039 <lpt_putc_sub>
    }
}
  1010ef:	c9                   	leave  
  1010f0:	c3                   	ret    

001010f1 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f1:	55                   	push   %ebp
  1010f2:	89 e5                	mov    %esp,%ebp
  1010f4:	53                   	push   %ebx
  1010f5:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fb:	b0 00                	mov    $0x0,%al
  1010fd:	85 c0                	test   %eax,%eax
  1010ff:	75 07                	jne    101108 <cga_putc+0x17>
        c |= 0x0700;
  101101:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101108:	8b 45 08             	mov    0x8(%ebp),%eax
  10110b:	0f b6 c0             	movzbl %al,%eax
  10110e:	83 f8 0a             	cmp    $0xa,%eax
  101111:	74 4c                	je     10115f <cga_putc+0x6e>
  101113:	83 f8 0d             	cmp    $0xd,%eax
  101116:	74 57                	je     10116f <cga_putc+0x7e>
  101118:	83 f8 08             	cmp    $0x8,%eax
  10111b:	0f 85 88 00 00 00    	jne    1011a9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101121:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101128:	66 85 c0             	test   %ax,%ax
  10112b:	74 30                	je     10115d <cga_putc+0x6c>
            crt_pos --;
  10112d:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101134:	83 e8 01             	sub    $0x1,%eax
  101137:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113d:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101142:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101149:	0f b7 d2             	movzwl %dx,%edx
  10114c:	01 d2                	add    %edx,%edx
  10114e:	01 c2                	add    %eax,%edx
  101150:	8b 45 08             	mov    0x8(%ebp),%eax
  101153:	b0 00                	mov    $0x0,%al
  101155:	83 c8 20             	or     $0x20,%eax
  101158:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115b:	eb 72                	jmp    1011cf <cga_putc+0xde>
  10115d:	eb 70                	jmp    1011cf <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10115f:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101166:	83 c0 50             	add    $0x50,%eax
  101169:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10116f:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101176:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10117d:	0f b7 c1             	movzwl %cx,%eax
  101180:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101186:	c1 e8 10             	shr    $0x10,%eax
  101189:	89 c2                	mov    %eax,%edx
  10118b:	66 c1 ea 06          	shr    $0x6,%dx
  10118f:	89 d0                	mov    %edx,%eax
  101191:	c1 e0 02             	shl    $0x2,%eax
  101194:	01 d0                	add    %edx,%eax
  101196:	c1 e0 04             	shl    $0x4,%eax
  101199:	29 c1                	sub    %eax,%ecx
  10119b:	89 ca                	mov    %ecx,%edx
  10119d:	89 d8                	mov    %ebx,%eax
  10119f:	29 d0                	sub    %edx,%eax
  1011a1:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a7:	eb 26                	jmp    1011cf <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a9:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011af:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b6:	8d 50 01             	lea    0x1(%eax),%edx
  1011b9:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c0:	0f b7 c0             	movzwl %ax,%eax
  1011c3:	01 c0                	add    %eax,%eax
  1011c5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cb:	66 89 02             	mov    %ax,(%edx)
        break;
  1011ce:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011cf:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d6:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011da:	76 5b                	jbe    101237 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011dc:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e7:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ec:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f3:	00 
  1011f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f8:	89 04 24             	mov    %eax,(%esp)
  1011fb:	e8 42 4a 00 00       	call   105c42 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101200:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101207:	eb 15                	jmp    10121e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101209:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10120e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101211:	01 d2                	add    %edx,%edx
  101213:	01 d0                	add    %edx,%eax
  101215:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101225:	7e e2                	jle    101209 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101227:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122e:	83 e8 50             	sub    $0x50,%eax
  101231:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101237:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10123e:	0f b7 c0             	movzwl %ax,%eax
  101241:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101245:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101249:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101251:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101252:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101259:	66 c1 e8 08          	shr    $0x8,%ax
  10125d:	0f b6 c0             	movzbl %al,%eax
  101260:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101267:	83 c2 01             	add    $0x1,%edx
  10126a:	0f b7 d2             	movzwl %dx,%edx
  10126d:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101271:	88 45 ed             	mov    %al,-0x13(%ebp)
  101274:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101278:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127d:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101284:	0f b7 c0             	movzwl %ax,%eax
  101287:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10128f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101293:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101297:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101298:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10129f:	0f b6 c0             	movzbl %al,%eax
  1012a2:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a9:	83 c2 01             	add    $0x1,%edx
  1012ac:	0f b7 d2             	movzwl %dx,%edx
  1012af:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b3:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012ba:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012be:	ee                   	out    %al,(%dx)
}
  1012bf:	83 c4 34             	add    $0x34,%esp
  1012c2:	5b                   	pop    %ebx
  1012c3:	5d                   	pop    %ebp
  1012c4:	c3                   	ret    

001012c5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c5:	55                   	push   %ebp
  1012c6:	89 e5                	mov    %esp,%ebp
  1012c8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d2:	eb 09                	jmp    1012dd <serial_putc_sub+0x18>
        delay();
  1012d4:	e8 4f fb ff ff       	call   100e28 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012dd:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e7:	89 c2                	mov    %eax,%edx
  1012e9:	ec                   	in     (%dx),%al
  1012ea:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f1:	0f b6 c0             	movzbl %al,%eax
  1012f4:	83 e0 20             	and    $0x20,%eax
  1012f7:	85 c0                	test   %eax,%eax
  1012f9:	75 09                	jne    101304 <serial_putc_sub+0x3f>
  1012fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101302:	7e d0                	jle    1012d4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101304:	8b 45 08             	mov    0x8(%ebp),%eax
  101307:	0f b6 c0             	movzbl %al,%eax
  10130a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101310:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101313:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101317:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131b:	ee                   	out    %al,(%dx)
}
  10131c:	c9                   	leave  
  10131d:	c3                   	ret    

0010131e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131e:	55                   	push   %ebp
  10131f:	89 e5                	mov    %esp,%ebp
  101321:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101324:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101328:	74 0d                	je     101337 <serial_putc+0x19>
        serial_putc_sub(c);
  10132a:	8b 45 08             	mov    0x8(%ebp),%eax
  10132d:	89 04 24             	mov    %eax,(%esp)
  101330:	e8 90 ff ff ff       	call   1012c5 <serial_putc_sub>
  101335:	eb 24                	jmp    10135b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101337:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133e:	e8 82 ff ff ff       	call   1012c5 <serial_putc_sub>
        serial_putc_sub(' ');
  101343:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134a:	e8 76 ff ff ff       	call   1012c5 <serial_putc_sub>
        serial_putc_sub('\b');
  10134f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101356:	e8 6a ff ff ff       	call   1012c5 <serial_putc_sub>
    }
}
  10135b:	c9                   	leave  
  10135c:	c3                   	ret    

0010135d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135d:	55                   	push   %ebp
  10135e:	89 e5                	mov    %esp,%ebp
  101360:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101363:	eb 33                	jmp    101398 <cons_intr+0x3b>
        if (c != 0) {
  101365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101369:	74 2d                	je     101398 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136b:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101370:	8d 50 01             	lea    0x1(%eax),%edx
  101373:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137c:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101382:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101387:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138c:	75 0a                	jne    101398 <cons_intr+0x3b>
                cons.wpos = 0;
  10138e:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101395:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101398:	8b 45 08             	mov    0x8(%ebp),%eax
  10139b:	ff d0                	call   *%eax
  10139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a4:	75 bf                	jne    101365 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a6:	c9                   	leave  
  1013a7:	c3                   	ret    

001013a8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a8:	55                   	push   %ebp
  1013a9:	89 e5                	mov    %esp,%ebp
  1013ab:	83 ec 10             	sub    $0x10,%esp
  1013ae:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b8:	89 c2                	mov    %eax,%edx
  1013ba:	ec                   	in     (%dx),%al
  1013bb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013be:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c2:	0f b6 c0             	movzbl %al,%eax
  1013c5:	83 e0 01             	and    $0x1,%eax
  1013c8:	85 c0                	test   %eax,%eax
  1013ca:	75 07                	jne    1013d3 <serial_proc_data+0x2b>
        return -1;
  1013cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d1:	eb 2a                	jmp    1013fd <serial_proc_data+0x55>
  1013d3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013dd:	89 c2                	mov    %eax,%edx
  1013df:	ec                   	in     (%dx),%al
  1013e0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e7:	0f b6 c0             	movzbl %al,%eax
  1013ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ed:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f1:	75 07                	jne    1013fa <serial_proc_data+0x52>
        c = '\b';
  1013f3:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fd:	c9                   	leave  
  1013fe:	c3                   	ret    

001013ff <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013ff:	55                   	push   %ebp
  101400:	89 e5                	mov    %esp,%ebp
  101402:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101405:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140a:	85 c0                	test   %eax,%eax
  10140c:	74 0c                	je     10141a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140e:	c7 04 24 a8 13 10 00 	movl   $0x1013a8,(%esp)
  101415:	e8 43 ff ff ff       	call   10135d <cons_intr>
    }
}
  10141a:	c9                   	leave  
  10141b:	c3                   	ret    

0010141c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141c:	55                   	push   %ebp
  10141d:	89 e5                	mov    %esp,%ebp
  10141f:	83 ec 38             	sub    $0x38,%esp
  101422:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101428:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142c:	89 c2                	mov    %eax,%edx
  10142e:	ec                   	in     (%dx),%al
  10142f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101432:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101436:	0f b6 c0             	movzbl %al,%eax
  101439:	83 e0 01             	and    $0x1,%eax
  10143c:	85 c0                	test   %eax,%eax
  10143e:	75 0a                	jne    10144a <kbd_proc_data+0x2e>
        return -1;
  101440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101445:	e9 59 01 00 00       	jmp    1015a3 <kbd_proc_data+0x187>
  10144a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101450:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101454:	89 c2                	mov    %eax,%edx
  101456:	ec                   	in     (%dx),%al
  101457:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101461:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101465:	75 17                	jne    10147e <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101467:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146c:	83 c8 40             	or     $0x40,%eax
  10146f:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101474:	b8 00 00 00 00       	mov    $0x0,%eax
  101479:	e9 25 01 00 00       	jmp    1015a3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101482:	84 c0                	test   %al,%al
  101484:	79 47                	jns    1014cd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101486:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10148b:	83 e0 40             	and    $0x40,%eax
  10148e:	85 c0                	test   %eax,%eax
  101490:	75 09                	jne    10149b <kbd_proc_data+0x7f>
  101492:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101496:	83 e0 7f             	and    $0x7f,%eax
  101499:	eb 04                	jmp    10149f <kbd_proc_data+0x83>
  10149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149f:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a6:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ad:	83 c8 40             	or     $0x40,%eax
  1014b0:	0f b6 c0             	movzbl %al,%eax
  1014b3:	f7 d0                	not    %eax
  1014b5:	89 c2                	mov    %eax,%edx
  1014b7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bc:	21 d0                	and    %edx,%eax
  1014be:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c8:	e9 d6 00 00 00       	jmp    1015a3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014cd:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d2:	83 e0 40             	and    $0x40,%eax
  1014d5:	85 c0                	test   %eax,%eax
  1014d7:	74 11                	je     1014ea <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014dd:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e2:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e5:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ee:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f5:	0f b6 d0             	movzbl %al,%edx
  1014f8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fd:	09 d0                	or     %edx,%eax
  1014ff:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101504:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101508:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  10150f:	0f b6 d0             	movzbl %al,%edx
  101512:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101517:	31 d0                	xor    %edx,%eax
  101519:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151e:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101523:	83 e0 03             	and    $0x3,%eax
  101526:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101531:	01 d0                	add    %edx,%eax
  101533:	0f b6 00             	movzbl (%eax),%eax
  101536:	0f b6 c0             	movzbl %al,%eax
  101539:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101541:	83 e0 08             	and    $0x8,%eax
  101544:	85 c0                	test   %eax,%eax
  101546:	74 22                	je     10156a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101548:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154c:	7e 0c                	jle    10155a <kbd_proc_data+0x13e>
  10154e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101552:	7f 06                	jg     10155a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101554:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101558:	eb 10                	jmp    10156a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155e:	7e 0a                	jle    10156a <kbd_proc_data+0x14e>
  101560:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101564:	7f 04                	jg     10156a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101566:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156a:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10156f:	f7 d0                	not    %eax
  101571:	83 e0 06             	and    $0x6,%eax
  101574:	85 c0                	test   %eax,%eax
  101576:	75 28                	jne    1015a0 <kbd_proc_data+0x184>
  101578:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157f:	75 1f                	jne    1015a0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101581:	c7 04 24 bd 60 10 00 	movl   $0x1060bd,(%esp)
  101588:	e8 af ed ff ff       	call   10033c <cprintf>
  10158d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101593:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101597:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10159f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a3:	c9                   	leave  
  1015a4:	c3                   	ret    

001015a5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a5:	55                   	push   %ebp
  1015a6:	89 e5                	mov    %esp,%ebp
  1015a8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ab:	c7 04 24 1c 14 10 00 	movl   $0x10141c,(%esp)
  1015b2:	e8 a6 fd ff ff       	call   10135d <cons_intr>
}
  1015b7:	c9                   	leave  
  1015b8:	c3                   	ret    

001015b9 <kbd_init>:

static void
kbd_init(void) {
  1015b9:	55                   	push   %ebp
  1015ba:	89 e5                	mov    %esp,%ebp
  1015bc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015bf:	e8 e1 ff ff ff       	call   1015a5 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015cb:	e8 3d 01 00 00       	call   10170d <pic_enable>
}
  1015d0:	c9                   	leave  
  1015d1:	c3                   	ret    

001015d2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d2:	55                   	push   %ebp
  1015d3:	89 e5                	mov    %esp,%ebp
  1015d5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d8:	e8 93 f8 ff ff       	call   100e70 <cga_init>
    serial_init();
  1015dd:	e8 74 f9 ff ff       	call   100f56 <serial_init>
    kbd_init();
  1015e2:	e8 d2 ff ff ff       	call   1015b9 <kbd_init>
    if (!serial_exists) {
  1015e7:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015ec:	85 c0                	test   %eax,%eax
  1015ee:	75 0c                	jne    1015fc <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f0:	c7 04 24 c9 60 10 00 	movl   $0x1060c9,(%esp)
  1015f7:	e8 40 ed ff ff       	call   10033c <cprintf>
    }
}
  1015fc:	c9                   	leave  
  1015fd:	c3                   	ret    

001015fe <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015fe:	55                   	push   %ebp
  1015ff:	89 e5                	mov    %esp,%ebp
  101601:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101604:	e8 e2 f7 ff ff       	call   100deb <__intr_save>
  101609:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160c:	8b 45 08             	mov    0x8(%ebp),%eax
  10160f:	89 04 24             	mov    %eax,(%esp)
  101612:	e8 9b fa ff ff       	call   1010b2 <lpt_putc>
        cga_putc(c);
  101617:	8b 45 08             	mov    0x8(%ebp),%eax
  10161a:	89 04 24             	mov    %eax,(%esp)
  10161d:	e8 cf fa ff ff       	call   1010f1 <cga_putc>
        serial_putc(c);
  101622:	8b 45 08             	mov    0x8(%ebp),%eax
  101625:	89 04 24             	mov    %eax,(%esp)
  101628:	e8 f1 fc ff ff       	call   10131e <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101630:	89 04 24             	mov    %eax,(%esp)
  101633:	e8 dd f7 ff ff       	call   100e15 <__intr_restore>
}
  101638:	c9                   	leave  
  101639:	c3                   	ret    

0010163a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163a:	55                   	push   %ebp
  10163b:	89 e5                	mov    %esp,%ebp
  10163d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101647:	e8 9f f7 ff ff       	call   100deb <__intr_save>
  10164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164f:	e8 ab fd ff ff       	call   1013ff <serial_intr>
        kbd_intr();
  101654:	e8 4c ff ff ff       	call   1015a5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101659:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10165f:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101664:	39 c2                	cmp    %eax,%edx
  101666:	74 31                	je     101699 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101668:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166d:	8d 50 01             	lea    0x1(%eax),%edx
  101670:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101676:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167d:	0f b6 c0             	movzbl %al,%eax
  101680:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101683:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101688:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168d:	75 0a                	jne    101699 <cons_getc+0x5f>
                cons.rpos = 0;
  10168f:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101696:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169c:	89 04 24             	mov    %eax,(%esp)
  10169f:	e8 71 f7 ff ff       	call   100e15 <__intr_restore>
    return c;
  1016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a7:	c9                   	leave  
  1016a8:	c3                   	ret    

001016a9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ac:	fb                   	sti    
    sti();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b2:	fa                   	cli    
    cli();
}
  1016b3:	5d                   	pop    %ebp
  1016b4:	c3                   	ret    

001016b5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b5:	55                   	push   %ebp
  1016b6:	89 e5                	mov    %esp,%ebp
  1016b8:	83 ec 14             	sub    $0x14,%esp
  1016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1016be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c6:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cc:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d1:	85 c0                	test   %eax,%eax
  1016d3:	74 36                	je     10170b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d9:	0f b6 c0             	movzbl %al,%eax
  1016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e2:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ed:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f2:	66 c1 e8 08          	shr    $0x8,%ax
  1016f6:	0f b6 c0             	movzbl %al,%eax
  1016f9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
  101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101706:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
    }
}
  10170b:	c9                   	leave  
  10170c:	c3                   	ret    

0010170d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170d:	55                   	push   %ebp
  10170e:	89 e5                	mov    %esp,%ebp
  101710:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101713:	8b 45 08             	mov    0x8(%ebp),%eax
  101716:	ba 01 00 00 00       	mov    $0x1,%edx
  10171b:	89 c1                	mov    %eax,%ecx
  10171d:	d3 e2                	shl    %cl,%edx
  10171f:	89 d0                	mov    %edx,%eax
  101721:	f7 d0                	not    %eax
  101723:	89 c2                	mov    %eax,%edx
  101725:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172c:	21 d0                	and    %edx,%eax
  10172e:	0f b7 c0             	movzwl %ax,%eax
  101731:	89 04 24             	mov    %eax,(%esp)
  101734:	e8 7c ff ff ff       	call   1016b5 <pic_setmask>
}
  101739:	c9                   	leave  
  10173a:	c3                   	ret    

0010173b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173b:	55                   	push   %ebp
  10173c:	89 e5                	mov    %esp,%ebp
  10173e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101741:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101748:	00 00 00 
  10174b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101751:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101755:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101759:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175d:	ee                   	out    %al,(%dx)
  10175e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101764:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101768:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101770:	ee                   	out    %al,(%dx)
  101771:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101777:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10177f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101783:	ee                   	out    %al,(%dx)
  101784:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101792:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
  101797:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a9:	ee                   	out    %al,(%dx)
  1017aa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
  1017bd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c3:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017cf:	ee                   	out    %al,(%dx)
  1017d0:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d6:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017da:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
  1017e3:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e9:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f5:	ee                   	out    %al,(%dx)
  1017f6:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fc:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101800:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101804:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101808:	ee                   	out    %al,(%dx)
  101809:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10180f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101813:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101817:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
  10181c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101822:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101826:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182e:	ee                   	out    %al,(%dx)
  10182f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101835:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
  101842:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101848:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101850:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101855:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185c:	66 83 f8 ff          	cmp    $0xffff,%ax
  101860:	74 12                	je     101874 <pic_init+0x139>
        pic_setmask(irq_mask);
  101862:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101869:	0f b7 c0             	movzwl %ax,%eax
  10186c:	89 04 24             	mov    %eax,(%esp)
  10186f:	e8 41 fe ff ff       	call   1016b5 <pic_setmask>
    }
}
  101874:	c9                   	leave  
  101875:	c3                   	ret    

00101876 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101876:	55                   	push   %ebp
  101877:	89 e5                	mov    %esp,%ebp
  101879:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101883:	00 
  101884:	c7 04 24 00 61 10 00 	movl   $0x106100,(%esp)
  10188b:	e8 ac ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101890:	c9                   	leave  
  101891:	c3                   	ret    

00101892 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101892:	55                   	push   %ebp
  101893:	89 e5                	mov    %esp,%ebp
  101895:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
	int i;
	for( i=0;i<256;i++){
  101898:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10189f:	e9 c3 00 00 00       	jmp    101967 <idt_init+0xd5>
		SETGATE(idt[i],0,KERNEL_CS,__vectors[i],0);       //用法：SETGATE(gate, istrap, sel, off, dpl)
  1018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a7:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018ae:	89 c2                	mov    %eax,%edx
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	66 89 14 c5 e0 80 11 	mov    %dx,0x1180e0(,%eax,8)
  1018ba:	00 
  1018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018be:	66 c7 04 c5 e2 80 11 	movw   $0x8,0x1180e2(,%eax,8)
  1018c5:	00 08 00 
  1018c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cb:	0f b6 14 c5 e4 80 11 	movzbl 0x1180e4(,%eax,8),%edx
  1018d2:	00 
  1018d3:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d6:	88 14 c5 e4 80 11 00 	mov    %dl,0x1180e4(,%eax,8)
  1018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e0:	0f b6 14 c5 e4 80 11 	movzbl 0x1180e4(,%eax,8),%edx
  1018e7:	00 
  1018e8:	83 e2 1f             	and    $0x1f,%edx
  1018eb:	88 14 c5 e4 80 11 00 	mov    %dl,0x1180e4(,%eax,8)
  1018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f5:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  1018fc:	00 
  1018fd:	83 e2 f0             	and    $0xfffffff0,%edx
  101900:	83 ca 0e             	or     $0xe,%edx
  101903:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  10190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190d:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  101914:	00 
  101915:	83 e2 ef             	and    $0xffffffef,%edx
  101918:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  10191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101922:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  101929:	00 
  10192a:	83 e2 9f             	and    $0xffffff9f,%edx
  10192d:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  101934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101937:	0f b6 14 c5 e5 80 11 	movzbl 0x1180e5(,%eax,8),%edx
  10193e:	00 
  10193f:	83 ca 80             	or     $0xffffff80,%edx
  101942:	88 14 c5 e5 80 11 00 	mov    %dl,0x1180e5(,%eax,8)
  101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194c:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101953:	c1 e8 10             	shr    $0x10,%eax
  101956:	89 c2                	mov    %eax,%edx
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	66 89 14 c5 e6 80 11 	mov    %dx,0x1180e6(,%eax,8)
  101962:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
	int i;
	for( i=0;i<256;i++){
  101963:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101967:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  10196e:	0f 8e 30 ff ff ff    	jle    1018a4 <idt_init+0x12>
  101974:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  10197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10197e:	0f 01 18             	lidtl  (%eax)
		SETGATE(idt[i],0,KERNEL_CS,__vectors[i],0);       //用法：SETGATE(gate, istrap, sel, off, dpl)
	}
	lidt(&idt_pd);

}
  101981:	c9                   	leave  
  101982:	c3                   	ret    

00101983 <trapname>:

static const char *
trapname(int trapno) {
  101983:	55                   	push   %ebp
  101984:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101986:	8b 45 08             	mov    0x8(%ebp),%eax
  101989:	83 f8 13             	cmp    $0x13,%eax
  10198c:	77 0c                	ja     10199a <trapname+0x17>
        return excnames[trapno];
  10198e:	8b 45 08             	mov    0x8(%ebp),%eax
  101991:	8b 04 85 60 64 10 00 	mov    0x106460(,%eax,4),%eax
  101998:	eb 18                	jmp    1019b2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10199a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10199e:	7e 0d                	jle    1019ad <trapname+0x2a>
  1019a0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019a4:	7f 07                	jg     1019ad <trapname+0x2a>
        return "Hardware Interrupt";
  1019a6:	b8 0a 61 10 00       	mov    $0x10610a,%eax
  1019ab:	eb 05                	jmp    1019b2 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019ad:	b8 1d 61 10 00       	mov    $0x10611d,%eax
}
  1019b2:	5d                   	pop    %ebp
  1019b3:	c3                   	ret    

001019b4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019b4:	55                   	push   %ebp
  1019b5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019be:	66 83 f8 08          	cmp    $0x8,%ax
  1019c2:	0f 94 c0             	sete   %al
  1019c5:	0f b6 c0             	movzbl %al,%eax
}
  1019c8:	5d                   	pop    %ebp
  1019c9:	c3                   	ret    

001019ca <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019ca:	55                   	push   %ebp
  1019cb:	89 e5                	mov    %esp,%ebp
  1019cd:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d7:	c7 04 24 5e 61 10 00 	movl   $0x10615e,(%esp)
  1019de:	e8 59 e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  1019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e6:	89 04 24             	mov    %eax,(%esp)
  1019e9:	e8 a1 01 00 00       	call   101b8f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019f5:	0f b7 c0             	movzwl %ax,%eax
  1019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fc:	c7 04 24 6f 61 10 00 	movl   $0x10616f,(%esp)
  101a03:	e8 34 e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a08:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a0f:	0f b7 c0             	movzwl %ax,%eax
  101a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a16:	c7 04 24 82 61 10 00 	movl   $0x106182,(%esp)
  101a1d:	e8 1a e9 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a22:	8b 45 08             	mov    0x8(%ebp),%eax
  101a25:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a29:	0f b7 c0             	movzwl %ax,%eax
  101a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a30:	c7 04 24 95 61 10 00 	movl   $0x106195,(%esp)
  101a37:	e8 00 e9 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a43:	0f b7 c0             	movzwl %ax,%eax
  101a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a4a:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  101a51:	e8 e6 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a56:	8b 45 08             	mov    0x8(%ebp),%eax
  101a59:	8b 40 30             	mov    0x30(%eax),%eax
  101a5c:	89 04 24             	mov    %eax,(%esp)
  101a5f:	e8 1f ff ff ff       	call   101983 <trapname>
  101a64:	8b 55 08             	mov    0x8(%ebp),%edx
  101a67:	8b 52 30             	mov    0x30(%edx),%edx
  101a6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a72:	c7 04 24 bb 61 10 00 	movl   $0x1061bb,(%esp)
  101a79:	e8 be e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a81:	8b 40 34             	mov    0x34(%eax),%eax
  101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a88:	c7 04 24 cd 61 10 00 	movl   $0x1061cd,(%esp)
  101a8f:	e8 a8 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a94:	8b 45 08             	mov    0x8(%ebp),%eax
  101a97:	8b 40 38             	mov    0x38(%eax),%eax
  101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9e:	c7 04 24 dc 61 10 00 	movl   $0x1061dc,(%esp)
  101aa5:	e8 92 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101aad:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ab1:	0f b7 c0             	movzwl %ax,%eax
  101ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab8:	c7 04 24 eb 61 10 00 	movl   $0x1061eb,(%esp)
  101abf:	e8 78 e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	8b 40 40             	mov    0x40(%eax),%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 fe 61 10 00 	movl   $0x1061fe,(%esp)
  101ad5:	e8 62 e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ae1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ae8:	eb 3e                	jmp    101b28 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101aea:	8b 45 08             	mov    0x8(%ebp),%eax
  101aed:	8b 50 40             	mov    0x40(%eax),%edx
  101af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101af3:	21 d0                	and    %edx,%eax
  101af5:	85 c0                	test   %eax,%eax
  101af7:	74 28                	je     101b21 <print_trapframe+0x157>
  101af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101afc:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b03:	85 c0                	test   %eax,%eax
  101b05:	74 1a                	je     101b21 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b0a:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b15:	c7 04 24 0d 62 10 00 	movl   $0x10620d,(%esp)
  101b1c:	e8 1b e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b21:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b25:	d1 65 f0             	shll   -0x10(%ebp)
  101b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2b:	83 f8 17             	cmp    $0x17,%eax
  101b2e:	76 ba                	jbe    101aea <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b30:	8b 45 08             	mov    0x8(%ebp),%eax
  101b33:	8b 40 40             	mov    0x40(%eax),%eax
  101b36:	25 00 30 00 00       	and    $0x3000,%eax
  101b3b:	c1 e8 0c             	shr    $0xc,%eax
  101b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b42:	c7 04 24 11 62 10 00 	movl   $0x106211,(%esp)
  101b49:	e8 ee e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b51:	89 04 24             	mov    %eax,(%esp)
  101b54:	e8 5b fe ff ff       	call   1019b4 <trap_in_kernel>
  101b59:	85 c0                	test   %eax,%eax
  101b5b:	75 30                	jne    101b8d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b60:	8b 40 44             	mov    0x44(%eax),%eax
  101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b67:	c7 04 24 1a 62 10 00 	movl   $0x10621a,(%esp)
  101b6e:	e8 c9 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b7a:	0f b7 c0             	movzwl %ax,%eax
  101b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b81:	c7 04 24 29 62 10 00 	movl   $0x106229,(%esp)
  101b88:	e8 af e7 ff ff       	call   10033c <cprintf>
    }
}
  101b8d:	c9                   	leave  
  101b8e:	c3                   	ret    

00101b8f <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b8f:	55                   	push   %ebp
  101b90:	89 e5                	mov    %esp,%ebp
  101b92:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b95:	8b 45 08             	mov    0x8(%ebp),%eax
  101b98:	8b 00                	mov    (%eax),%eax
  101b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9e:	c7 04 24 3c 62 10 00 	movl   $0x10623c,(%esp)
  101ba5:	e8 92 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 40 04             	mov    0x4(%eax),%eax
  101bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb4:	c7 04 24 4b 62 10 00 	movl   $0x10624b,(%esp)
  101bbb:	e8 7c e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc3:	8b 40 08             	mov    0x8(%eax),%eax
  101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bca:	c7 04 24 5a 62 10 00 	movl   $0x10625a,(%esp)
  101bd1:	e8 66 e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	8b 40 0c             	mov    0xc(%eax),%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 69 62 10 00 	movl   $0x106269,(%esp)
  101be7:	e8 50 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	8b 40 10             	mov    0x10(%eax),%eax
  101bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf6:	c7 04 24 78 62 10 00 	movl   $0x106278,(%esp)
  101bfd:	e8 3a e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c02:	8b 45 08             	mov    0x8(%ebp),%eax
  101c05:	8b 40 14             	mov    0x14(%eax),%eax
  101c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0c:	c7 04 24 87 62 10 00 	movl   $0x106287,(%esp)
  101c13:	e8 24 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c18:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1b:	8b 40 18             	mov    0x18(%eax),%eax
  101c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c22:	c7 04 24 96 62 10 00 	movl   $0x106296,(%esp)
  101c29:	e8 0e e7 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c31:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c38:	c7 04 24 a5 62 10 00 	movl   $0x1062a5,(%esp)
  101c3f:	e8 f8 e6 ff ff       	call   10033c <cprintf>
}
  101c44:	c9                   	leave  
  101c45:	c3                   	ret    

00101c46 <trap_dispatch>:
int tick_count=0;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c46:	55                   	push   %ebp
  101c47:	89 e5                	mov    %esp,%ebp
  101c49:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4f:	8b 40 30             	mov    0x30(%eax),%eax
  101c52:	83 f8 2f             	cmp    $0x2f,%eax
  101c55:	77 1d                	ja     101c74 <trap_dispatch+0x2e>
  101c57:	83 f8 2e             	cmp    $0x2e,%eax
  101c5a:	0f 83 f2 00 00 00    	jae    101d52 <trap_dispatch+0x10c>
  101c60:	83 f8 21             	cmp    $0x21,%eax
  101c63:	74 73                	je     101cd8 <trap_dispatch+0x92>
  101c65:	83 f8 24             	cmp    $0x24,%eax
  101c68:	74 48                	je     101cb2 <trap_dispatch+0x6c>
  101c6a:	83 f8 20             	cmp    $0x20,%eax
  101c6d:	74 13                	je     101c82 <trap_dispatch+0x3c>
  101c6f:	e9 a6 00 00 00       	jmp    101d1a <trap_dispatch+0xd4>
  101c74:	83 e8 78             	sub    $0x78,%eax
  101c77:	83 f8 01             	cmp    $0x1,%eax
  101c7a:	0f 87 9a 00 00 00    	ja     101d1a <trap_dispatch+0xd4>
  101c80:	eb 7c                	jmp    101cfe <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    tick_count++;
  101c82:	a1 c0 80 11 00       	mov    0x1180c0,%eax
  101c87:	83 c0 01             	add    $0x1,%eax
  101c8a:	a3 c0 80 11 00       	mov    %eax,0x1180c0
    if(tick_count==TICK_NUM){
  101c8f:	a1 c0 80 11 00       	mov    0x1180c0,%eax
  101c94:	83 f8 64             	cmp    $0x64,%eax
  101c97:	75 14                	jne    101cad <trap_dispatch+0x67>
    	print_ticks();
  101c99:	e8 d8 fb ff ff       	call   101876 <print_ticks>
    	tick_count=0;
  101c9e:	c7 05 c0 80 11 00 00 	movl   $0x0,0x1180c0
  101ca5:	00 00 00 
    }
        break;
  101ca8:	e9 a6 00 00 00       	jmp    101d53 <trap_dispatch+0x10d>
  101cad:	e9 a1 00 00 00       	jmp    101d53 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cb2:	e8 83 f9 ff ff       	call   10163a <cons_getc>
  101cb7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cba:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cbe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cc2:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cca:	c7 04 24 b4 62 10 00 	movl   $0x1062b4,(%esp)
  101cd1:	e8 66 e6 ff ff       	call   10033c <cprintf>
        break;
  101cd6:	eb 7b                	jmp    101d53 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cd8:	e8 5d f9 ff ff       	call   10163a <cons_getc>
  101cdd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ce0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ce4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ce8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 c6 62 10 00 	movl   $0x1062c6,(%esp)
  101cf7:	e8 40 e6 ff ff       	call   10033c <cprintf>
        break;
  101cfc:	eb 55                	jmp    101d53 <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cfe:	c7 44 24 08 d5 62 10 	movl   $0x1062d5,0x8(%esp)
  101d05:	00 
  101d06:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101d0d:	00 
  101d0e:	c7 04 24 e5 62 10 00 	movl   $0x1062e5,(%esp)
  101d15:	e8 b2 ef ff ff       	call   100ccc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d21:	0f b7 c0             	movzwl %ax,%eax
  101d24:	83 e0 03             	and    $0x3,%eax
  101d27:	85 c0                	test   %eax,%eax
  101d29:	75 28                	jne    101d53 <trap_dispatch+0x10d>
            print_trapframe(tf);
  101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2e:	89 04 24             	mov    %eax,(%esp)
  101d31:	e8 94 fc ff ff       	call   1019ca <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d36:	c7 44 24 08 f6 62 10 	movl   $0x1062f6,0x8(%esp)
  101d3d:	00 
  101d3e:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101d45:	00 
  101d46:	c7 04 24 e5 62 10 00 	movl   $0x1062e5,(%esp)
  101d4d:	e8 7a ef ff ff       	call   100ccc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d52:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d53:	c9                   	leave  
  101d54:	c3                   	ret    

00101d55 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d55:	55                   	push   %ebp
  101d56:	89 e5                	mov    %esp,%ebp
  101d58:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5e:	89 04 24             	mov    %eax,(%esp)
  101d61:	e8 e0 fe ff ff       	call   101c46 <trap_dispatch>
}
  101d66:	c9                   	leave  
  101d67:	c3                   	ret    

00101d68 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d68:	1e                   	push   %ds
    pushl %es
  101d69:	06                   	push   %es
    pushl %fs
  101d6a:	0f a0                	push   %fs
    pushl %gs
  101d6c:	0f a8                	push   %gs
    pushal
  101d6e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d6f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d74:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d76:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d78:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d79:	e8 d7 ff ff ff       	call   101d55 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d7e:	5c                   	pop    %esp

00101d7f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d7f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d80:	0f a9                	pop    %gs
    popl %fs
  101d82:	0f a1                	pop    %fs
    popl %es
  101d84:	07                   	pop    %es
    popl %ds
  101d85:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d86:	83 c4 08             	add    $0x8,%esp
    iret
  101d89:	cf                   	iret   

00101d8a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d8a:	6a 00                	push   $0x0
  pushl $0
  101d8c:	6a 00                	push   $0x0
  jmp __alltraps
  101d8e:	e9 d5 ff ff ff       	jmp    101d68 <__alltraps>

00101d93 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d93:	6a 00                	push   $0x0
  pushl $1
  101d95:	6a 01                	push   $0x1
  jmp __alltraps
  101d97:	e9 cc ff ff ff       	jmp    101d68 <__alltraps>

00101d9c <vector2>:
.globl vector2
vector2:
  pushl $0
  101d9c:	6a 00                	push   $0x0
  pushl $2
  101d9e:	6a 02                	push   $0x2
  jmp __alltraps
  101da0:	e9 c3 ff ff ff       	jmp    101d68 <__alltraps>

00101da5 <vector3>:
.globl vector3
vector3:
  pushl $0
  101da5:	6a 00                	push   $0x0
  pushl $3
  101da7:	6a 03                	push   $0x3
  jmp __alltraps
  101da9:	e9 ba ff ff ff       	jmp    101d68 <__alltraps>

00101dae <vector4>:
.globl vector4
vector4:
  pushl $0
  101dae:	6a 00                	push   $0x0
  pushl $4
  101db0:	6a 04                	push   $0x4
  jmp __alltraps
  101db2:	e9 b1 ff ff ff       	jmp    101d68 <__alltraps>

00101db7 <vector5>:
.globl vector5
vector5:
  pushl $0
  101db7:	6a 00                	push   $0x0
  pushl $5
  101db9:	6a 05                	push   $0x5
  jmp __alltraps
  101dbb:	e9 a8 ff ff ff       	jmp    101d68 <__alltraps>

00101dc0 <vector6>:
.globl vector6
vector6:
  pushl $0
  101dc0:	6a 00                	push   $0x0
  pushl $6
  101dc2:	6a 06                	push   $0x6
  jmp __alltraps
  101dc4:	e9 9f ff ff ff       	jmp    101d68 <__alltraps>

00101dc9 <vector7>:
.globl vector7
vector7:
  pushl $0
  101dc9:	6a 00                	push   $0x0
  pushl $7
  101dcb:	6a 07                	push   $0x7
  jmp __alltraps
  101dcd:	e9 96 ff ff ff       	jmp    101d68 <__alltraps>

00101dd2 <vector8>:
.globl vector8
vector8:
  pushl $8
  101dd2:	6a 08                	push   $0x8
  jmp __alltraps
  101dd4:	e9 8f ff ff ff       	jmp    101d68 <__alltraps>

00101dd9 <vector9>:
.globl vector9
vector9:
  pushl $9
  101dd9:	6a 09                	push   $0x9
  jmp __alltraps
  101ddb:	e9 88 ff ff ff       	jmp    101d68 <__alltraps>

00101de0 <vector10>:
.globl vector10
vector10:
  pushl $10
  101de0:	6a 0a                	push   $0xa
  jmp __alltraps
  101de2:	e9 81 ff ff ff       	jmp    101d68 <__alltraps>

00101de7 <vector11>:
.globl vector11
vector11:
  pushl $11
  101de7:	6a 0b                	push   $0xb
  jmp __alltraps
  101de9:	e9 7a ff ff ff       	jmp    101d68 <__alltraps>

00101dee <vector12>:
.globl vector12
vector12:
  pushl $12
  101dee:	6a 0c                	push   $0xc
  jmp __alltraps
  101df0:	e9 73 ff ff ff       	jmp    101d68 <__alltraps>

00101df5 <vector13>:
.globl vector13
vector13:
  pushl $13
  101df5:	6a 0d                	push   $0xd
  jmp __alltraps
  101df7:	e9 6c ff ff ff       	jmp    101d68 <__alltraps>

00101dfc <vector14>:
.globl vector14
vector14:
  pushl $14
  101dfc:	6a 0e                	push   $0xe
  jmp __alltraps
  101dfe:	e9 65 ff ff ff       	jmp    101d68 <__alltraps>

00101e03 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e03:	6a 00                	push   $0x0
  pushl $15
  101e05:	6a 0f                	push   $0xf
  jmp __alltraps
  101e07:	e9 5c ff ff ff       	jmp    101d68 <__alltraps>

00101e0c <vector16>:
.globl vector16
vector16:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $16
  101e0e:	6a 10                	push   $0x10
  jmp __alltraps
  101e10:	e9 53 ff ff ff       	jmp    101d68 <__alltraps>

00101e15 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e15:	6a 11                	push   $0x11
  jmp __alltraps
  101e17:	e9 4c ff ff ff       	jmp    101d68 <__alltraps>

00101e1c <vector18>:
.globl vector18
vector18:
  pushl $0
  101e1c:	6a 00                	push   $0x0
  pushl $18
  101e1e:	6a 12                	push   $0x12
  jmp __alltraps
  101e20:	e9 43 ff ff ff       	jmp    101d68 <__alltraps>

00101e25 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e25:	6a 00                	push   $0x0
  pushl $19
  101e27:	6a 13                	push   $0x13
  jmp __alltraps
  101e29:	e9 3a ff ff ff       	jmp    101d68 <__alltraps>

00101e2e <vector20>:
.globl vector20
vector20:
  pushl $0
  101e2e:	6a 00                	push   $0x0
  pushl $20
  101e30:	6a 14                	push   $0x14
  jmp __alltraps
  101e32:	e9 31 ff ff ff       	jmp    101d68 <__alltraps>

00101e37 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e37:	6a 00                	push   $0x0
  pushl $21
  101e39:	6a 15                	push   $0x15
  jmp __alltraps
  101e3b:	e9 28 ff ff ff       	jmp    101d68 <__alltraps>

00101e40 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e40:	6a 00                	push   $0x0
  pushl $22
  101e42:	6a 16                	push   $0x16
  jmp __alltraps
  101e44:	e9 1f ff ff ff       	jmp    101d68 <__alltraps>

00101e49 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e49:	6a 00                	push   $0x0
  pushl $23
  101e4b:	6a 17                	push   $0x17
  jmp __alltraps
  101e4d:	e9 16 ff ff ff       	jmp    101d68 <__alltraps>

00101e52 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e52:	6a 00                	push   $0x0
  pushl $24
  101e54:	6a 18                	push   $0x18
  jmp __alltraps
  101e56:	e9 0d ff ff ff       	jmp    101d68 <__alltraps>

00101e5b <vector25>:
.globl vector25
vector25:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $25
  101e5d:	6a 19                	push   $0x19
  jmp __alltraps
  101e5f:	e9 04 ff ff ff       	jmp    101d68 <__alltraps>

00101e64 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e64:	6a 00                	push   $0x0
  pushl $26
  101e66:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e68:	e9 fb fe ff ff       	jmp    101d68 <__alltraps>

00101e6d <vector27>:
.globl vector27
vector27:
  pushl $0
  101e6d:	6a 00                	push   $0x0
  pushl $27
  101e6f:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e71:	e9 f2 fe ff ff       	jmp    101d68 <__alltraps>

00101e76 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $28
  101e78:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e7a:	e9 e9 fe ff ff       	jmp    101d68 <__alltraps>

00101e7f <vector29>:
.globl vector29
vector29:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $29
  101e81:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e83:	e9 e0 fe ff ff       	jmp    101d68 <__alltraps>

00101e88 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e88:	6a 00                	push   $0x0
  pushl $30
  101e8a:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e8c:	e9 d7 fe ff ff       	jmp    101d68 <__alltraps>

00101e91 <vector31>:
.globl vector31
vector31:
  pushl $0
  101e91:	6a 00                	push   $0x0
  pushl $31
  101e93:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e95:	e9 ce fe ff ff       	jmp    101d68 <__alltraps>

00101e9a <vector32>:
.globl vector32
vector32:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $32
  101e9c:	6a 20                	push   $0x20
  jmp __alltraps
  101e9e:	e9 c5 fe ff ff       	jmp    101d68 <__alltraps>

00101ea3 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $33
  101ea5:	6a 21                	push   $0x21
  jmp __alltraps
  101ea7:	e9 bc fe ff ff       	jmp    101d68 <__alltraps>

00101eac <vector34>:
.globl vector34
vector34:
  pushl $0
  101eac:	6a 00                	push   $0x0
  pushl $34
  101eae:	6a 22                	push   $0x22
  jmp __alltraps
  101eb0:	e9 b3 fe ff ff       	jmp    101d68 <__alltraps>

00101eb5 <vector35>:
.globl vector35
vector35:
  pushl $0
  101eb5:	6a 00                	push   $0x0
  pushl $35
  101eb7:	6a 23                	push   $0x23
  jmp __alltraps
  101eb9:	e9 aa fe ff ff       	jmp    101d68 <__alltraps>

00101ebe <vector36>:
.globl vector36
vector36:
  pushl $0
  101ebe:	6a 00                	push   $0x0
  pushl $36
  101ec0:	6a 24                	push   $0x24
  jmp __alltraps
  101ec2:	e9 a1 fe ff ff       	jmp    101d68 <__alltraps>

00101ec7 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ec7:	6a 00                	push   $0x0
  pushl $37
  101ec9:	6a 25                	push   $0x25
  jmp __alltraps
  101ecb:	e9 98 fe ff ff       	jmp    101d68 <__alltraps>

00101ed0 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ed0:	6a 00                	push   $0x0
  pushl $38
  101ed2:	6a 26                	push   $0x26
  jmp __alltraps
  101ed4:	e9 8f fe ff ff       	jmp    101d68 <__alltraps>

00101ed9 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ed9:	6a 00                	push   $0x0
  pushl $39
  101edb:	6a 27                	push   $0x27
  jmp __alltraps
  101edd:	e9 86 fe ff ff       	jmp    101d68 <__alltraps>

00101ee2 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $40
  101ee4:	6a 28                	push   $0x28
  jmp __alltraps
  101ee6:	e9 7d fe ff ff       	jmp    101d68 <__alltraps>

00101eeb <vector41>:
.globl vector41
vector41:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $41
  101eed:	6a 29                	push   $0x29
  jmp __alltraps
  101eef:	e9 74 fe ff ff       	jmp    101d68 <__alltraps>

00101ef4 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $42
  101ef6:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ef8:	e9 6b fe ff ff       	jmp    101d68 <__alltraps>

00101efd <vector43>:
.globl vector43
vector43:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $43
  101eff:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f01:	e9 62 fe ff ff       	jmp    101d68 <__alltraps>

00101f06 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $44
  101f08:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f0a:	e9 59 fe ff ff       	jmp    101d68 <__alltraps>

00101f0f <vector45>:
.globl vector45
vector45:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $45
  101f11:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f13:	e9 50 fe ff ff       	jmp    101d68 <__alltraps>

00101f18 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $46
  101f1a:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f1c:	e9 47 fe ff ff       	jmp    101d68 <__alltraps>

00101f21 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $47
  101f23:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f25:	e9 3e fe ff ff       	jmp    101d68 <__alltraps>

00101f2a <vector48>:
.globl vector48
vector48:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $48
  101f2c:	6a 30                	push   $0x30
  jmp __alltraps
  101f2e:	e9 35 fe ff ff       	jmp    101d68 <__alltraps>

00101f33 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f33:	6a 00                	push   $0x0
  pushl $49
  101f35:	6a 31                	push   $0x31
  jmp __alltraps
  101f37:	e9 2c fe ff ff       	jmp    101d68 <__alltraps>

00101f3c <vector50>:
.globl vector50
vector50:
  pushl $0
  101f3c:	6a 00                	push   $0x0
  pushl $50
  101f3e:	6a 32                	push   $0x32
  jmp __alltraps
  101f40:	e9 23 fe ff ff       	jmp    101d68 <__alltraps>

00101f45 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f45:	6a 00                	push   $0x0
  pushl $51
  101f47:	6a 33                	push   $0x33
  jmp __alltraps
  101f49:	e9 1a fe ff ff       	jmp    101d68 <__alltraps>

00101f4e <vector52>:
.globl vector52
vector52:
  pushl $0
  101f4e:	6a 00                	push   $0x0
  pushl $52
  101f50:	6a 34                	push   $0x34
  jmp __alltraps
  101f52:	e9 11 fe ff ff       	jmp    101d68 <__alltraps>

00101f57 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f57:	6a 00                	push   $0x0
  pushl $53
  101f59:	6a 35                	push   $0x35
  jmp __alltraps
  101f5b:	e9 08 fe ff ff       	jmp    101d68 <__alltraps>

00101f60 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f60:	6a 00                	push   $0x0
  pushl $54
  101f62:	6a 36                	push   $0x36
  jmp __alltraps
  101f64:	e9 ff fd ff ff       	jmp    101d68 <__alltraps>

00101f69 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f69:	6a 00                	push   $0x0
  pushl $55
  101f6b:	6a 37                	push   $0x37
  jmp __alltraps
  101f6d:	e9 f6 fd ff ff       	jmp    101d68 <__alltraps>

00101f72 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $56
  101f74:	6a 38                	push   $0x38
  jmp __alltraps
  101f76:	e9 ed fd ff ff       	jmp    101d68 <__alltraps>

00101f7b <vector57>:
.globl vector57
vector57:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $57
  101f7d:	6a 39                	push   $0x39
  jmp __alltraps
  101f7f:	e9 e4 fd ff ff       	jmp    101d68 <__alltraps>

00101f84 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $58
  101f86:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f88:	e9 db fd ff ff       	jmp    101d68 <__alltraps>

00101f8d <vector59>:
.globl vector59
vector59:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $59
  101f8f:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f91:	e9 d2 fd ff ff       	jmp    101d68 <__alltraps>

00101f96 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f96:	6a 00                	push   $0x0
  pushl $60
  101f98:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f9a:	e9 c9 fd ff ff       	jmp    101d68 <__alltraps>

00101f9f <vector61>:
.globl vector61
vector61:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $61
  101fa1:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fa3:	e9 c0 fd ff ff       	jmp    101d68 <__alltraps>

00101fa8 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $62
  101faa:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fac:	e9 b7 fd ff ff       	jmp    101d68 <__alltraps>

00101fb1 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $63
  101fb3:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fb5:	e9 ae fd ff ff       	jmp    101d68 <__alltraps>

00101fba <vector64>:
.globl vector64
vector64:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $64
  101fbc:	6a 40                	push   $0x40
  jmp __alltraps
  101fbe:	e9 a5 fd ff ff       	jmp    101d68 <__alltraps>

00101fc3 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $65
  101fc5:	6a 41                	push   $0x41
  jmp __alltraps
  101fc7:	e9 9c fd ff ff       	jmp    101d68 <__alltraps>

00101fcc <vector66>:
.globl vector66
vector66:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $66
  101fce:	6a 42                	push   $0x42
  jmp __alltraps
  101fd0:	e9 93 fd ff ff       	jmp    101d68 <__alltraps>

00101fd5 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $67
  101fd7:	6a 43                	push   $0x43
  jmp __alltraps
  101fd9:	e9 8a fd ff ff       	jmp    101d68 <__alltraps>

00101fde <vector68>:
.globl vector68
vector68:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $68
  101fe0:	6a 44                	push   $0x44
  jmp __alltraps
  101fe2:	e9 81 fd ff ff       	jmp    101d68 <__alltraps>

00101fe7 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $69
  101fe9:	6a 45                	push   $0x45
  jmp __alltraps
  101feb:	e9 78 fd ff ff       	jmp    101d68 <__alltraps>

00101ff0 <vector70>:
.globl vector70
vector70:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $70
  101ff2:	6a 46                	push   $0x46
  jmp __alltraps
  101ff4:	e9 6f fd ff ff       	jmp    101d68 <__alltraps>

00101ff9 <vector71>:
.globl vector71
vector71:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $71
  101ffb:	6a 47                	push   $0x47
  jmp __alltraps
  101ffd:	e9 66 fd ff ff       	jmp    101d68 <__alltraps>

00102002 <vector72>:
.globl vector72
vector72:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $72
  102004:	6a 48                	push   $0x48
  jmp __alltraps
  102006:	e9 5d fd ff ff       	jmp    101d68 <__alltraps>

0010200b <vector73>:
.globl vector73
vector73:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $73
  10200d:	6a 49                	push   $0x49
  jmp __alltraps
  10200f:	e9 54 fd ff ff       	jmp    101d68 <__alltraps>

00102014 <vector74>:
.globl vector74
vector74:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $74
  102016:	6a 4a                	push   $0x4a
  jmp __alltraps
  102018:	e9 4b fd ff ff       	jmp    101d68 <__alltraps>

0010201d <vector75>:
.globl vector75
vector75:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $75
  10201f:	6a 4b                	push   $0x4b
  jmp __alltraps
  102021:	e9 42 fd ff ff       	jmp    101d68 <__alltraps>

00102026 <vector76>:
.globl vector76
vector76:
  pushl $0
  102026:	6a 00                	push   $0x0
  pushl $76
  102028:	6a 4c                	push   $0x4c
  jmp __alltraps
  10202a:	e9 39 fd ff ff       	jmp    101d68 <__alltraps>

0010202f <vector77>:
.globl vector77
vector77:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $77
  102031:	6a 4d                	push   $0x4d
  jmp __alltraps
  102033:	e9 30 fd ff ff       	jmp    101d68 <__alltraps>

00102038 <vector78>:
.globl vector78
vector78:
  pushl $0
  102038:	6a 00                	push   $0x0
  pushl $78
  10203a:	6a 4e                	push   $0x4e
  jmp __alltraps
  10203c:	e9 27 fd ff ff       	jmp    101d68 <__alltraps>

00102041 <vector79>:
.globl vector79
vector79:
  pushl $0
  102041:	6a 00                	push   $0x0
  pushl $79
  102043:	6a 4f                	push   $0x4f
  jmp __alltraps
  102045:	e9 1e fd ff ff       	jmp    101d68 <__alltraps>

0010204a <vector80>:
.globl vector80
vector80:
  pushl $0
  10204a:	6a 00                	push   $0x0
  pushl $80
  10204c:	6a 50                	push   $0x50
  jmp __alltraps
  10204e:	e9 15 fd ff ff       	jmp    101d68 <__alltraps>

00102053 <vector81>:
.globl vector81
vector81:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $81
  102055:	6a 51                	push   $0x51
  jmp __alltraps
  102057:	e9 0c fd ff ff       	jmp    101d68 <__alltraps>

0010205c <vector82>:
.globl vector82
vector82:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $82
  10205e:	6a 52                	push   $0x52
  jmp __alltraps
  102060:	e9 03 fd ff ff       	jmp    101d68 <__alltraps>

00102065 <vector83>:
.globl vector83
vector83:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $83
  102067:	6a 53                	push   $0x53
  jmp __alltraps
  102069:	e9 fa fc ff ff       	jmp    101d68 <__alltraps>

0010206e <vector84>:
.globl vector84
vector84:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $84
  102070:	6a 54                	push   $0x54
  jmp __alltraps
  102072:	e9 f1 fc ff ff       	jmp    101d68 <__alltraps>

00102077 <vector85>:
.globl vector85
vector85:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $85
  102079:	6a 55                	push   $0x55
  jmp __alltraps
  10207b:	e9 e8 fc ff ff       	jmp    101d68 <__alltraps>

00102080 <vector86>:
.globl vector86
vector86:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $86
  102082:	6a 56                	push   $0x56
  jmp __alltraps
  102084:	e9 df fc ff ff       	jmp    101d68 <__alltraps>

00102089 <vector87>:
.globl vector87
vector87:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $87
  10208b:	6a 57                	push   $0x57
  jmp __alltraps
  10208d:	e9 d6 fc ff ff       	jmp    101d68 <__alltraps>

00102092 <vector88>:
.globl vector88
vector88:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $88
  102094:	6a 58                	push   $0x58
  jmp __alltraps
  102096:	e9 cd fc ff ff       	jmp    101d68 <__alltraps>

0010209b <vector89>:
.globl vector89
vector89:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $89
  10209d:	6a 59                	push   $0x59
  jmp __alltraps
  10209f:	e9 c4 fc ff ff       	jmp    101d68 <__alltraps>

001020a4 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $90
  1020a6:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020a8:	e9 bb fc ff ff       	jmp    101d68 <__alltraps>

001020ad <vector91>:
.globl vector91
vector91:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $91
  1020af:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020b1:	e9 b2 fc ff ff       	jmp    101d68 <__alltraps>

001020b6 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $92
  1020b8:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020ba:	e9 a9 fc ff ff       	jmp    101d68 <__alltraps>

001020bf <vector93>:
.globl vector93
vector93:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $93
  1020c1:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020c3:	e9 a0 fc ff ff       	jmp    101d68 <__alltraps>

001020c8 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $94
  1020ca:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020cc:	e9 97 fc ff ff       	jmp    101d68 <__alltraps>

001020d1 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $95
  1020d3:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020d5:	e9 8e fc ff ff       	jmp    101d68 <__alltraps>

001020da <vector96>:
.globl vector96
vector96:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $96
  1020dc:	6a 60                	push   $0x60
  jmp __alltraps
  1020de:	e9 85 fc ff ff       	jmp    101d68 <__alltraps>

001020e3 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $97
  1020e5:	6a 61                	push   $0x61
  jmp __alltraps
  1020e7:	e9 7c fc ff ff       	jmp    101d68 <__alltraps>

001020ec <vector98>:
.globl vector98
vector98:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $98
  1020ee:	6a 62                	push   $0x62
  jmp __alltraps
  1020f0:	e9 73 fc ff ff       	jmp    101d68 <__alltraps>

001020f5 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $99
  1020f7:	6a 63                	push   $0x63
  jmp __alltraps
  1020f9:	e9 6a fc ff ff       	jmp    101d68 <__alltraps>

001020fe <vector100>:
.globl vector100
vector100:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $100
  102100:	6a 64                	push   $0x64
  jmp __alltraps
  102102:	e9 61 fc ff ff       	jmp    101d68 <__alltraps>

00102107 <vector101>:
.globl vector101
vector101:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $101
  102109:	6a 65                	push   $0x65
  jmp __alltraps
  10210b:	e9 58 fc ff ff       	jmp    101d68 <__alltraps>

00102110 <vector102>:
.globl vector102
vector102:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $102
  102112:	6a 66                	push   $0x66
  jmp __alltraps
  102114:	e9 4f fc ff ff       	jmp    101d68 <__alltraps>

00102119 <vector103>:
.globl vector103
vector103:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $103
  10211b:	6a 67                	push   $0x67
  jmp __alltraps
  10211d:	e9 46 fc ff ff       	jmp    101d68 <__alltraps>

00102122 <vector104>:
.globl vector104
vector104:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $104
  102124:	6a 68                	push   $0x68
  jmp __alltraps
  102126:	e9 3d fc ff ff       	jmp    101d68 <__alltraps>

0010212b <vector105>:
.globl vector105
vector105:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $105
  10212d:	6a 69                	push   $0x69
  jmp __alltraps
  10212f:	e9 34 fc ff ff       	jmp    101d68 <__alltraps>

00102134 <vector106>:
.globl vector106
vector106:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $106
  102136:	6a 6a                	push   $0x6a
  jmp __alltraps
  102138:	e9 2b fc ff ff       	jmp    101d68 <__alltraps>

0010213d <vector107>:
.globl vector107
vector107:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $107
  10213f:	6a 6b                	push   $0x6b
  jmp __alltraps
  102141:	e9 22 fc ff ff       	jmp    101d68 <__alltraps>

00102146 <vector108>:
.globl vector108
vector108:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $108
  102148:	6a 6c                	push   $0x6c
  jmp __alltraps
  10214a:	e9 19 fc ff ff       	jmp    101d68 <__alltraps>

0010214f <vector109>:
.globl vector109
vector109:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $109
  102151:	6a 6d                	push   $0x6d
  jmp __alltraps
  102153:	e9 10 fc ff ff       	jmp    101d68 <__alltraps>

00102158 <vector110>:
.globl vector110
vector110:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $110
  10215a:	6a 6e                	push   $0x6e
  jmp __alltraps
  10215c:	e9 07 fc ff ff       	jmp    101d68 <__alltraps>

00102161 <vector111>:
.globl vector111
vector111:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $111
  102163:	6a 6f                	push   $0x6f
  jmp __alltraps
  102165:	e9 fe fb ff ff       	jmp    101d68 <__alltraps>

0010216a <vector112>:
.globl vector112
vector112:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $112
  10216c:	6a 70                	push   $0x70
  jmp __alltraps
  10216e:	e9 f5 fb ff ff       	jmp    101d68 <__alltraps>

00102173 <vector113>:
.globl vector113
vector113:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $113
  102175:	6a 71                	push   $0x71
  jmp __alltraps
  102177:	e9 ec fb ff ff       	jmp    101d68 <__alltraps>

0010217c <vector114>:
.globl vector114
vector114:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $114
  10217e:	6a 72                	push   $0x72
  jmp __alltraps
  102180:	e9 e3 fb ff ff       	jmp    101d68 <__alltraps>

00102185 <vector115>:
.globl vector115
vector115:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $115
  102187:	6a 73                	push   $0x73
  jmp __alltraps
  102189:	e9 da fb ff ff       	jmp    101d68 <__alltraps>

0010218e <vector116>:
.globl vector116
vector116:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $116
  102190:	6a 74                	push   $0x74
  jmp __alltraps
  102192:	e9 d1 fb ff ff       	jmp    101d68 <__alltraps>

00102197 <vector117>:
.globl vector117
vector117:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $117
  102199:	6a 75                	push   $0x75
  jmp __alltraps
  10219b:	e9 c8 fb ff ff       	jmp    101d68 <__alltraps>

001021a0 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $118
  1021a2:	6a 76                	push   $0x76
  jmp __alltraps
  1021a4:	e9 bf fb ff ff       	jmp    101d68 <__alltraps>

001021a9 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $119
  1021ab:	6a 77                	push   $0x77
  jmp __alltraps
  1021ad:	e9 b6 fb ff ff       	jmp    101d68 <__alltraps>

001021b2 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $120
  1021b4:	6a 78                	push   $0x78
  jmp __alltraps
  1021b6:	e9 ad fb ff ff       	jmp    101d68 <__alltraps>

001021bb <vector121>:
.globl vector121
vector121:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $121
  1021bd:	6a 79                	push   $0x79
  jmp __alltraps
  1021bf:	e9 a4 fb ff ff       	jmp    101d68 <__alltraps>

001021c4 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $122
  1021c6:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021c8:	e9 9b fb ff ff       	jmp    101d68 <__alltraps>

001021cd <vector123>:
.globl vector123
vector123:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $123
  1021cf:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021d1:	e9 92 fb ff ff       	jmp    101d68 <__alltraps>

001021d6 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $124
  1021d8:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021da:	e9 89 fb ff ff       	jmp    101d68 <__alltraps>

001021df <vector125>:
.globl vector125
vector125:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $125
  1021e1:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021e3:	e9 80 fb ff ff       	jmp    101d68 <__alltraps>

001021e8 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $126
  1021ea:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021ec:	e9 77 fb ff ff       	jmp    101d68 <__alltraps>

001021f1 <vector127>:
.globl vector127
vector127:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $127
  1021f3:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021f5:	e9 6e fb ff ff       	jmp    101d68 <__alltraps>

001021fa <vector128>:
.globl vector128
vector128:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $128
  1021fc:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102201:	e9 62 fb ff ff       	jmp    101d68 <__alltraps>

00102206 <vector129>:
.globl vector129
vector129:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $129
  102208:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10220d:	e9 56 fb ff ff       	jmp    101d68 <__alltraps>

00102212 <vector130>:
.globl vector130
vector130:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $130
  102214:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102219:	e9 4a fb ff ff       	jmp    101d68 <__alltraps>

0010221e <vector131>:
.globl vector131
vector131:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $131
  102220:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102225:	e9 3e fb ff ff       	jmp    101d68 <__alltraps>

0010222a <vector132>:
.globl vector132
vector132:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $132
  10222c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102231:	e9 32 fb ff ff       	jmp    101d68 <__alltraps>

00102236 <vector133>:
.globl vector133
vector133:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $133
  102238:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10223d:	e9 26 fb ff ff       	jmp    101d68 <__alltraps>

00102242 <vector134>:
.globl vector134
vector134:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $134
  102244:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102249:	e9 1a fb ff ff       	jmp    101d68 <__alltraps>

0010224e <vector135>:
.globl vector135
vector135:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $135
  102250:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102255:	e9 0e fb ff ff       	jmp    101d68 <__alltraps>

0010225a <vector136>:
.globl vector136
vector136:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $136
  10225c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102261:	e9 02 fb ff ff       	jmp    101d68 <__alltraps>

00102266 <vector137>:
.globl vector137
vector137:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $137
  102268:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10226d:	e9 f6 fa ff ff       	jmp    101d68 <__alltraps>

00102272 <vector138>:
.globl vector138
vector138:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $138
  102274:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102279:	e9 ea fa ff ff       	jmp    101d68 <__alltraps>

0010227e <vector139>:
.globl vector139
vector139:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $139
  102280:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102285:	e9 de fa ff ff       	jmp    101d68 <__alltraps>

0010228a <vector140>:
.globl vector140
vector140:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $140
  10228c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102291:	e9 d2 fa ff ff       	jmp    101d68 <__alltraps>

00102296 <vector141>:
.globl vector141
vector141:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $141
  102298:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10229d:	e9 c6 fa ff ff       	jmp    101d68 <__alltraps>

001022a2 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $142
  1022a4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022a9:	e9 ba fa ff ff       	jmp    101d68 <__alltraps>

001022ae <vector143>:
.globl vector143
vector143:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $143
  1022b0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022b5:	e9 ae fa ff ff       	jmp    101d68 <__alltraps>

001022ba <vector144>:
.globl vector144
vector144:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $144
  1022bc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022c1:	e9 a2 fa ff ff       	jmp    101d68 <__alltraps>

001022c6 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $145
  1022c8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022cd:	e9 96 fa ff ff       	jmp    101d68 <__alltraps>

001022d2 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $146
  1022d4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022d9:	e9 8a fa ff ff       	jmp    101d68 <__alltraps>

001022de <vector147>:
.globl vector147
vector147:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $147
  1022e0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022e5:	e9 7e fa ff ff       	jmp    101d68 <__alltraps>

001022ea <vector148>:
.globl vector148
vector148:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $148
  1022ec:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022f1:	e9 72 fa ff ff       	jmp    101d68 <__alltraps>

001022f6 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $149
  1022f8:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022fd:	e9 66 fa ff ff       	jmp    101d68 <__alltraps>

00102302 <vector150>:
.globl vector150
vector150:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $150
  102304:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102309:	e9 5a fa ff ff       	jmp    101d68 <__alltraps>

0010230e <vector151>:
.globl vector151
vector151:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $151
  102310:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102315:	e9 4e fa ff ff       	jmp    101d68 <__alltraps>

0010231a <vector152>:
.globl vector152
vector152:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $152
  10231c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102321:	e9 42 fa ff ff       	jmp    101d68 <__alltraps>

00102326 <vector153>:
.globl vector153
vector153:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $153
  102328:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10232d:	e9 36 fa ff ff       	jmp    101d68 <__alltraps>

00102332 <vector154>:
.globl vector154
vector154:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $154
  102334:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102339:	e9 2a fa ff ff       	jmp    101d68 <__alltraps>

0010233e <vector155>:
.globl vector155
vector155:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $155
  102340:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102345:	e9 1e fa ff ff       	jmp    101d68 <__alltraps>

0010234a <vector156>:
.globl vector156
vector156:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $156
  10234c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102351:	e9 12 fa ff ff       	jmp    101d68 <__alltraps>

00102356 <vector157>:
.globl vector157
vector157:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $157
  102358:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10235d:	e9 06 fa ff ff       	jmp    101d68 <__alltraps>

00102362 <vector158>:
.globl vector158
vector158:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $158
  102364:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102369:	e9 fa f9 ff ff       	jmp    101d68 <__alltraps>

0010236e <vector159>:
.globl vector159
vector159:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $159
  102370:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102375:	e9 ee f9 ff ff       	jmp    101d68 <__alltraps>

0010237a <vector160>:
.globl vector160
vector160:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $160
  10237c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102381:	e9 e2 f9 ff ff       	jmp    101d68 <__alltraps>

00102386 <vector161>:
.globl vector161
vector161:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $161
  102388:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10238d:	e9 d6 f9 ff ff       	jmp    101d68 <__alltraps>

00102392 <vector162>:
.globl vector162
vector162:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $162
  102394:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102399:	e9 ca f9 ff ff       	jmp    101d68 <__alltraps>

0010239e <vector163>:
.globl vector163
vector163:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $163
  1023a0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023a5:	e9 be f9 ff ff       	jmp    101d68 <__alltraps>

001023aa <vector164>:
.globl vector164
vector164:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $164
  1023ac:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023b1:	e9 b2 f9 ff ff       	jmp    101d68 <__alltraps>

001023b6 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $165
  1023b8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023bd:	e9 a6 f9 ff ff       	jmp    101d68 <__alltraps>

001023c2 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $166
  1023c4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023c9:	e9 9a f9 ff ff       	jmp    101d68 <__alltraps>

001023ce <vector167>:
.globl vector167
vector167:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $167
  1023d0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023d5:	e9 8e f9 ff ff       	jmp    101d68 <__alltraps>

001023da <vector168>:
.globl vector168
vector168:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $168
  1023dc:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023e1:	e9 82 f9 ff ff       	jmp    101d68 <__alltraps>

001023e6 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $169
  1023e8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023ed:	e9 76 f9 ff ff       	jmp    101d68 <__alltraps>

001023f2 <vector170>:
.globl vector170
vector170:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $170
  1023f4:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023f9:	e9 6a f9 ff ff       	jmp    101d68 <__alltraps>

001023fe <vector171>:
.globl vector171
vector171:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $171
  102400:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102405:	e9 5e f9 ff ff       	jmp    101d68 <__alltraps>

0010240a <vector172>:
.globl vector172
vector172:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $172
  10240c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102411:	e9 52 f9 ff ff       	jmp    101d68 <__alltraps>

00102416 <vector173>:
.globl vector173
vector173:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $173
  102418:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10241d:	e9 46 f9 ff ff       	jmp    101d68 <__alltraps>

00102422 <vector174>:
.globl vector174
vector174:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $174
  102424:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102429:	e9 3a f9 ff ff       	jmp    101d68 <__alltraps>

0010242e <vector175>:
.globl vector175
vector175:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $175
  102430:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102435:	e9 2e f9 ff ff       	jmp    101d68 <__alltraps>

0010243a <vector176>:
.globl vector176
vector176:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $176
  10243c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102441:	e9 22 f9 ff ff       	jmp    101d68 <__alltraps>

00102446 <vector177>:
.globl vector177
vector177:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $177
  102448:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10244d:	e9 16 f9 ff ff       	jmp    101d68 <__alltraps>

00102452 <vector178>:
.globl vector178
vector178:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $178
  102454:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102459:	e9 0a f9 ff ff       	jmp    101d68 <__alltraps>

0010245e <vector179>:
.globl vector179
vector179:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $179
  102460:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102465:	e9 fe f8 ff ff       	jmp    101d68 <__alltraps>

0010246a <vector180>:
.globl vector180
vector180:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $180
  10246c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102471:	e9 f2 f8 ff ff       	jmp    101d68 <__alltraps>

00102476 <vector181>:
.globl vector181
vector181:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $181
  102478:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10247d:	e9 e6 f8 ff ff       	jmp    101d68 <__alltraps>

00102482 <vector182>:
.globl vector182
vector182:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $182
  102484:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102489:	e9 da f8 ff ff       	jmp    101d68 <__alltraps>

0010248e <vector183>:
.globl vector183
vector183:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $183
  102490:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102495:	e9 ce f8 ff ff       	jmp    101d68 <__alltraps>

0010249a <vector184>:
.globl vector184
vector184:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $184
  10249c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024a1:	e9 c2 f8 ff ff       	jmp    101d68 <__alltraps>

001024a6 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $185
  1024a8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024ad:	e9 b6 f8 ff ff       	jmp    101d68 <__alltraps>

001024b2 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $186
  1024b4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024b9:	e9 aa f8 ff ff       	jmp    101d68 <__alltraps>

001024be <vector187>:
.globl vector187
vector187:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $187
  1024c0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024c5:	e9 9e f8 ff ff       	jmp    101d68 <__alltraps>

001024ca <vector188>:
.globl vector188
vector188:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $188
  1024cc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024d1:	e9 92 f8 ff ff       	jmp    101d68 <__alltraps>

001024d6 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $189
  1024d8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024dd:	e9 86 f8 ff ff       	jmp    101d68 <__alltraps>

001024e2 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $190
  1024e4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024e9:	e9 7a f8 ff ff       	jmp    101d68 <__alltraps>

001024ee <vector191>:
.globl vector191
vector191:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $191
  1024f0:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024f5:	e9 6e f8 ff ff       	jmp    101d68 <__alltraps>

001024fa <vector192>:
.globl vector192
vector192:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $192
  1024fc:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102501:	e9 62 f8 ff ff       	jmp    101d68 <__alltraps>

00102506 <vector193>:
.globl vector193
vector193:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $193
  102508:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10250d:	e9 56 f8 ff ff       	jmp    101d68 <__alltraps>

00102512 <vector194>:
.globl vector194
vector194:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $194
  102514:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102519:	e9 4a f8 ff ff       	jmp    101d68 <__alltraps>

0010251e <vector195>:
.globl vector195
vector195:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $195
  102520:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102525:	e9 3e f8 ff ff       	jmp    101d68 <__alltraps>

0010252a <vector196>:
.globl vector196
vector196:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $196
  10252c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102531:	e9 32 f8 ff ff       	jmp    101d68 <__alltraps>

00102536 <vector197>:
.globl vector197
vector197:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $197
  102538:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10253d:	e9 26 f8 ff ff       	jmp    101d68 <__alltraps>

00102542 <vector198>:
.globl vector198
vector198:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $198
  102544:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102549:	e9 1a f8 ff ff       	jmp    101d68 <__alltraps>

0010254e <vector199>:
.globl vector199
vector199:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $199
  102550:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102555:	e9 0e f8 ff ff       	jmp    101d68 <__alltraps>

0010255a <vector200>:
.globl vector200
vector200:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $200
  10255c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102561:	e9 02 f8 ff ff       	jmp    101d68 <__alltraps>

00102566 <vector201>:
.globl vector201
vector201:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $201
  102568:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10256d:	e9 f6 f7 ff ff       	jmp    101d68 <__alltraps>

00102572 <vector202>:
.globl vector202
vector202:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $202
  102574:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102579:	e9 ea f7 ff ff       	jmp    101d68 <__alltraps>

0010257e <vector203>:
.globl vector203
vector203:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $203
  102580:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102585:	e9 de f7 ff ff       	jmp    101d68 <__alltraps>

0010258a <vector204>:
.globl vector204
vector204:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $204
  10258c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102591:	e9 d2 f7 ff ff       	jmp    101d68 <__alltraps>

00102596 <vector205>:
.globl vector205
vector205:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $205
  102598:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10259d:	e9 c6 f7 ff ff       	jmp    101d68 <__alltraps>

001025a2 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $206
  1025a4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025a9:	e9 ba f7 ff ff       	jmp    101d68 <__alltraps>

001025ae <vector207>:
.globl vector207
vector207:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $207
  1025b0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025b5:	e9 ae f7 ff ff       	jmp    101d68 <__alltraps>

001025ba <vector208>:
.globl vector208
vector208:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $208
  1025bc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025c1:	e9 a2 f7 ff ff       	jmp    101d68 <__alltraps>

001025c6 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $209
  1025c8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025cd:	e9 96 f7 ff ff       	jmp    101d68 <__alltraps>

001025d2 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $210
  1025d4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025d9:	e9 8a f7 ff ff       	jmp    101d68 <__alltraps>

001025de <vector211>:
.globl vector211
vector211:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $211
  1025e0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025e5:	e9 7e f7 ff ff       	jmp    101d68 <__alltraps>

001025ea <vector212>:
.globl vector212
vector212:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $212
  1025ec:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025f1:	e9 72 f7 ff ff       	jmp    101d68 <__alltraps>

001025f6 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $213
  1025f8:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025fd:	e9 66 f7 ff ff       	jmp    101d68 <__alltraps>

00102602 <vector214>:
.globl vector214
vector214:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $214
  102604:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102609:	e9 5a f7 ff ff       	jmp    101d68 <__alltraps>

0010260e <vector215>:
.globl vector215
vector215:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $215
  102610:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102615:	e9 4e f7 ff ff       	jmp    101d68 <__alltraps>

0010261a <vector216>:
.globl vector216
vector216:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $216
  10261c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102621:	e9 42 f7 ff ff       	jmp    101d68 <__alltraps>

00102626 <vector217>:
.globl vector217
vector217:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $217
  102628:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10262d:	e9 36 f7 ff ff       	jmp    101d68 <__alltraps>

00102632 <vector218>:
.globl vector218
vector218:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $218
  102634:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102639:	e9 2a f7 ff ff       	jmp    101d68 <__alltraps>

0010263e <vector219>:
.globl vector219
vector219:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $219
  102640:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102645:	e9 1e f7 ff ff       	jmp    101d68 <__alltraps>

0010264a <vector220>:
.globl vector220
vector220:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $220
  10264c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102651:	e9 12 f7 ff ff       	jmp    101d68 <__alltraps>

00102656 <vector221>:
.globl vector221
vector221:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $221
  102658:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10265d:	e9 06 f7 ff ff       	jmp    101d68 <__alltraps>

00102662 <vector222>:
.globl vector222
vector222:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $222
  102664:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102669:	e9 fa f6 ff ff       	jmp    101d68 <__alltraps>

0010266e <vector223>:
.globl vector223
vector223:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $223
  102670:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102675:	e9 ee f6 ff ff       	jmp    101d68 <__alltraps>

0010267a <vector224>:
.globl vector224
vector224:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $224
  10267c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102681:	e9 e2 f6 ff ff       	jmp    101d68 <__alltraps>

00102686 <vector225>:
.globl vector225
vector225:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $225
  102688:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10268d:	e9 d6 f6 ff ff       	jmp    101d68 <__alltraps>

00102692 <vector226>:
.globl vector226
vector226:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $226
  102694:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102699:	e9 ca f6 ff ff       	jmp    101d68 <__alltraps>

0010269e <vector227>:
.globl vector227
vector227:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $227
  1026a0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026a5:	e9 be f6 ff ff       	jmp    101d68 <__alltraps>

001026aa <vector228>:
.globl vector228
vector228:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $228
  1026ac:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026b1:	e9 b2 f6 ff ff       	jmp    101d68 <__alltraps>

001026b6 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $229
  1026b8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026bd:	e9 a6 f6 ff ff       	jmp    101d68 <__alltraps>

001026c2 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $230
  1026c4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026c9:	e9 9a f6 ff ff       	jmp    101d68 <__alltraps>

001026ce <vector231>:
.globl vector231
vector231:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $231
  1026d0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026d5:	e9 8e f6 ff ff       	jmp    101d68 <__alltraps>

001026da <vector232>:
.globl vector232
vector232:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $232
  1026dc:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026e1:	e9 82 f6 ff ff       	jmp    101d68 <__alltraps>

001026e6 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $233
  1026e8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026ed:	e9 76 f6 ff ff       	jmp    101d68 <__alltraps>

001026f2 <vector234>:
.globl vector234
vector234:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $234
  1026f4:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026f9:	e9 6a f6 ff ff       	jmp    101d68 <__alltraps>

001026fe <vector235>:
.globl vector235
vector235:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $235
  102700:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102705:	e9 5e f6 ff ff       	jmp    101d68 <__alltraps>

0010270a <vector236>:
.globl vector236
vector236:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $236
  10270c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102711:	e9 52 f6 ff ff       	jmp    101d68 <__alltraps>

00102716 <vector237>:
.globl vector237
vector237:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $237
  102718:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10271d:	e9 46 f6 ff ff       	jmp    101d68 <__alltraps>

00102722 <vector238>:
.globl vector238
vector238:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $238
  102724:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102729:	e9 3a f6 ff ff       	jmp    101d68 <__alltraps>

0010272e <vector239>:
.globl vector239
vector239:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $239
  102730:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102735:	e9 2e f6 ff ff       	jmp    101d68 <__alltraps>

0010273a <vector240>:
.globl vector240
vector240:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $240
  10273c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102741:	e9 22 f6 ff ff       	jmp    101d68 <__alltraps>

00102746 <vector241>:
.globl vector241
vector241:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $241
  102748:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10274d:	e9 16 f6 ff ff       	jmp    101d68 <__alltraps>

00102752 <vector242>:
.globl vector242
vector242:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $242
  102754:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102759:	e9 0a f6 ff ff       	jmp    101d68 <__alltraps>

0010275e <vector243>:
.globl vector243
vector243:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $243
  102760:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102765:	e9 fe f5 ff ff       	jmp    101d68 <__alltraps>

0010276a <vector244>:
.globl vector244
vector244:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $244
  10276c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102771:	e9 f2 f5 ff ff       	jmp    101d68 <__alltraps>

00102776 <vector245>:
.globl vector245
vector245:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $245
  102778:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10277d:	e9 e6 f5 ff ff       	jmp    101d68 <__alltraps>

00102782 <vector246>:
.globl vector246
vector246:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $246
  102784:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102789:	e9 da f5 ff ff       	jmp    101d68 <__alltraps>

0010278e <vector247>:
.globl vector247
vector247:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $247
  102790:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102795:	e9 ce f5 ff ff       	jmp    101d68 <__alltraps>

0010279a <vector248>:
.globl vector248
vector248:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $248
  10279c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027a1:	e9 c2 f5 ff ff       	jmp    101d68 <__alltraps>

001027a6 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $249
  1027a8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027ad:	e9 b6 f5 ff ff       	jmp    101d68 <__alltraps>

001027b2 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $250
  1027b4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027b9:	e9 aa f5 ff ff       	jmp    101d68 <__alltraps>

001027be <vector251>:
.globl vector251
vector251:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $251
  1027c0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027c5:	e9 9e f5 ff ff       	jmp    101d68 <__alltraps>

001027ca <vector252>:
.globl vector252
vector252:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $252
  1027cc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027d1:	e9 92 f5 ff ff       	jmp    101d68 <__alltraps>

001027d6 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $253
  1027d8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027dd:	e9 86 f5 ff ff       	jmp    101d68 <__alltraps>

001027e2 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $254
  1027e4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027e9:	e9 7a f5 ff ff       	jmp    101d68 <__alltraps>

001027ee <vector255>:
.globl vector255
vector255:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $255
  1027f0:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027f5:	e9 6e f5 ff ff       	jmp    101d68 <__alltraps>

001027fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1027fa:	55                   	push   %ebp
  1027fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1027fd:	8b 55 08             	mov    0x8(%ebp),%edx
  102800:	a1 84 89 11 00       	mov    0x118984,%eax
  102805:	29 c2                	sub    %eax,%edx
  102807:	89 d0                	mov    %edx,%eax
  102809:	c1 f8 02             	sar    $0x2,%eax
  10280c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102812:	5d                   	pop    %ebp
  102813:	c3                   	ret    

00102814 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102814:	55                   	push   %ebp
  102815:	89 e5                	mov    %esp,%ebp
  102817:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10281a:	8b 45 08             	mov    0x8(%ebp),%eax
  10281d:	89 04 24             	mov    %eax,(%esp)
  102820:	e8 d5 ff ff ff       	call   1027fa <page2ppn>
  102825:	c1 e0 0c             	shl    $0xc,%eax
}
  102828:	c9                   	leave  
  102829:	c3                   	ret    

0010282a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10282a:	55                   	push   %ebp
  10282b:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10282d:	8b 45 08             	mov    0x8(%ebp),%eax
  102830:	8b 00                	mov    (%eax),%eax
}
  102832:	5d                   	pop    %ebp
  102833:	c3                   	ret    

00102834 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102834:	55                   	push   %ebp
  102835:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102837:	8b 45 08             	mov    0x8(%ebp),%eax
  10283a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10283d:	89 10                	mov    %edx,(%eax)
}
  10283f:	5d                   	pop    %ebp
  102840:	c3                   	ret    

00102841 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102841:	55                   	push   %ebp
  102842:	89 e5                	mov    %esp,%ebp
  102844:	83 ec 10             	sub    $0x10,%esp
  102847:	c7 45 fc 70 89 11 00 	movl   $0x118970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10284e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102851:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102854:	89 50 04             	mov    %edx,0x4(%eax)
  102857:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10285a:	8b 50 04             	mov    0x4(%eax),%edx
  10285d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102860:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102862:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  102869:	00 00 00 
}
  10286c:	c9                   	leave  
  10286d:	c3                   	ret    

0010286e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10286e:	55                   	push   %ebp
  10286f:	89 e5                	mov    %esp,%ebp
  102871:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102874:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102878:	75 24                	jne    10289e <default_init_memmap+0x30>
  10287a:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  102881:	00 
  102882:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102889:	00 
  10288a:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102891:	00 
  102892:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102899:	e8 2e e4 ff ff       	call   100ccc <__panic>
    struct Page *p = base;
  10289e:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1028a4:	eb 7d                	jmp    102923 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028a9:	83 c0 04             	add    $0x4,%eax
  1028ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1028b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1028bc:	0f a3 10             	bt     %edx,(%eax)
  1028bf:	19 c0                	sbb    %eax,%eax
  1028c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1028c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028c8:	0f 95 c0             	setne  %al
  1028cb:	0f b6 c0             	movzbl %al,%eax
  1028ce:	85 c0                	test   %eax,%eax
  1028d0:	75 24                	jne    1028f6 <default_init_memmap+0x88>
  1028d2:	c7 44 24 0c e1 64 10 	movl   $0x1064e1,0xc(%esp)
  1028d9:	00 
  1028da:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1028e1:	00 
  1028e2:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1028e9:	00 
  1028ea:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1028f1:	e8 d6 e3 ff ff       	call   100ccc <__panic>
        p->flags = p->property = 0;
  1028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102903:	8b 50 08             	mov    0x8(%eax),%edx
  102906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102909:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10290c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102913:	00 
  102914:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102917:	89 04 24             	mov    %eax,(%esp)
  10291a:	e8 15 ff ff ff       	call   102834 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  10291f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102923:	8b 55 0c             	mov    0xc(%ebp),%edx
  102926:	89 d0                	mov    %edx,%eax
  102928:	c1 e0 02             	shl    $0x2,%eax
  10292b:	01 d0                	add    %edx,%eax
  10292d:	c1 e0 02             	shl    $0x2,%eax
  102930:	89 c2                	mov    %eax,%edx
  102932:	8b 45 08             	mov    0x8(%ebp),%eax
  102935:	01 d0                	add    %edx,%eax
  102937:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10293a:	0f 85 66 ff ff ff    	jne    1028a6 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102940:	8b 45 08             	mov    0x8(%ebp),%eax
  102943:	8b 55 0c             	mov    0xc(%ebp),%edx
  102946:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102949:	8b 45 08             	mov    0x8(%ebp),%eax
  10294c:	83 c0 04             	add    $0x4,%eax
  10294f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102956:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10295c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10295f:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102962:	8b 15 78 89 11 00    	mov    0x118978,%edx
  102968:	8b 45 0c             	mov    0xc(%ebp),%eax
  10296b:	01 d0                	add    %edx,%eax
  10296d:	a3 78 89 11 00       	mov    %eax,0x118978
    list_add(&free_list, &(base->page_link));
  102972:	8b 45 08             	mov    0x8(%ebp),%eax
  102975:	83 c0 0c             	add    $0xc,%eax
  102978:	c7 45 dc 70 89 11 00 	movl   $0x118970,-0x24(%ebp)
  10297f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102985:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102988:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10298b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10298e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102991:	8b 40 04             	mov    0x4(%eax),%eax
  102994:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102997:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10299a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10299d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1029a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1029a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1029a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029a9:	89 10                	mov    %edx,(%eax)
  1029ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1029ae:	8b 10                	mov    (%eax),%edx
  1029b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1029b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1029bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1029bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1029c5:	89 10                	mov    %edx,(%eax)
}
  1029c7:	c9                   	leave  
  1029c8:	c3                   	ret    

001029c9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1029c9:	55                   	push   %ebp
  1029ca:	89 e5                	mov    %esp,%ebp
  1029cc:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1029cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029d3:	75 24                	jne    1029f9 <default_alloc_pages+0x30>
  1029d5:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  1029dc:	00 
  1029dd:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1029e4:	00 
  1029e5:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  1029ec:	00 
  1029ed:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1029f4:	e8 d3 e2 ff ff       	call   100ccc <__panic>
    if (n > nr_free) {
  1029f9:	a1 78 89 11 00       	mov    0x118978,%eax
  1029fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a01:	73 0a                	jae    102a0d <default_alloc_pages+0x44>
        return NULL;
  102a03:	b8 00 00 00 00       	mov    $0x0,%eax
  102a08:	e9 2a 01 00 00       	jmp    102b37 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  102a0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102a14:	c7 45 f0 70 89 11 00 	movl   $0x118970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102a1b:	eb 1c                	jmp    102a39 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a20:	83 e8 0c             	sub    $0xc,%eax
  102a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a29:	8b 40 08             	mov    0x8(%eax),%eax
  102a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a2f:	72 08                	jb     102a39 <default_alloc_pages+0x70>
            page = p;
  102a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102a37:	eb 18                	jmp    102a51 <default_alloc_pages+0x88>
  102a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a42:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a48:	81 7d f0 70 89 11 00 	cmpl   $0x118970,-0x10(%ebp)
  102a4f:	75 cc                	jne    102a1d <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102a55:	0f 84 d9 00 00 00    	je     102b34 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  102a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a5e:	83 c0 0c             	add    $0xc,%eax
  102a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a67:	8b 40 04             	mov    0x4(%eax),%eax
  102a6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102a6d:	8b 12                	mov    (%edx),%edx
  102a6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102a72:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102a75:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a78:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a7b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102a7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a81:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a84:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  102a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a89:	8b 40 08             	mov    0x8(%eax),%eax
  102a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a8f:	76 7d                	jbe    102b0e <default_alloc_pages+0x145>
            struct Page *p = page + n;
  102a91:	8b 55 08             	mov    0x8(%ebp),%edx
  102a94:	89 d0                	mov    %edx,%eax
  102a96:	c1 e0 02             	shl    $0x2,%eax
  102a99:	01 d0                	add    %edx,%eax
  102a9b:	c1 e0 02             	shl    $0x2,%eax
  102a9e:	89 c2                	mov    %eax,%edx
  102aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aa3:	01 d0                	add    %edx,%eax
  102aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aab:	8b 40 08             	mov    0x8(%eax),%eax
  102aae:	2b 45 08             	sub    0x8(%ebp),%eax
  102ab1:	89 c2                	mov    %eax,%edx
  102ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ab6:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  102ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102abc:	83 c0 0c             	add    $0xc,%eax
  102abf:	c7 45 d4 70 89 11 00 	movl   $0x118970,-0x2c(%ebp)
  102ac6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ac9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102acc:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102acf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ad2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ad8:	8b 40 04             	mov    0x4(%eax),%eax
  102adb:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102ade:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102ae1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ae4:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102ae7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102aea:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102aed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102af0:	89 10                	mov    %edx,(%eax)
  102af2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102af5:	8b 10                	mov    (%eax),%edx
  102af7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102afa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102afd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b00:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b09:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b0c:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102b0e:	a1 78 89 11 00       	mov    0x118978,%eax
  102b13:	2b 45 08             	sub    0x8(%ebp),%eax
  102b16:	a3 78 89 11 00       	mov    %eax,0x118978
        ClearPageProperty(page);
  102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1e:	83 c0 04             	add    $0x4,%eax
  102b21:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102b28:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b2e:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b31:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102b37:	c9                   	leave  
  102b38:	c3                   	ret    

00102b39 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b39:	55                   	push   %ebp
  102b3a:	89 e5                	mov    %esp,%ebp
  102b3c:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b46:	75 24                	jne    102b6c <default_free_pages+0x33>
  102b48:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  102b4f:	00 
  102b50:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102b57:	00 
  102b58:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  102b5f:	00 
  102b60:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102b67:	e8 60 e1 ff ff       	call   100ccc <__panic>
    struct Page *p = base;
  102b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102b72:	e9 9d 00 00 00       	jmp    102c14 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7a:	83 c0 04             	add    $0x4,%eax
  102b7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b8d:	0f a3 10             	bt     %edx,(%eax)
  102b90:	19 c0                	sbb    %eax,%eax
  102b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102b95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102b99:	0f 95 c0             	setne  %al
  102b9c:	0f b6 c0             	movzbl %al,%eax
  102b9f:	85 c0                	test   %eax,%eax
  102ba1:	75 2c                	jne    102bcf <default_free_pages+0x96>
  102ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba6:	83 c0 04             	add    $0x4,%eax
  102ba9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102bb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102bb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102bb9:	0f a3 10             	bt     %edx,(%eax)
  102bbc:	19 c0                	sbb    %eax,%eax
  102bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102bc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102bc5:	0f 95 c0             	setne  %al
  102bc8:	0f b6 c0             	movzbl %al,%eax
  102bcb:	85 c0                	test   %eax,%eax
  102bcd:	74 24                	je     102bf3 <default_free_pages+0xba>
  102bcf:	c7 44 24 0c f4 64 10 	movl   $0x1064f4,0xc(%esp)
  102bd6:	00 
  102bd7:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102bde:	00 
  102bdf:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102be6:	00 
  102be7:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102bee:	e8 d9 e0 ff ff       	call   100ccc <__panic>
        p->flags = 0;
  102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c04:	00 
  102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c08:	89 04 24             	mov    %eax,(%esp)
  102c0b:	e8 24 fc ff ff       	call   102834 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102c10:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c14:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c17:	89 d0                	mov    %edx,%eax
  102c19:	c1 e0 02             	shl    $0x2,%eax
  102c1c:	01 d0                	add    %edx,%eax
  102c1e:	c1 e0 02             	shl    $0x2,%eax
  102c21:	89 c2                	mov    %eax,%edx
  102c23:	8b 45 08             	mov    0x8(%ebp),%eax
  102c26:	01 d0                	add    %edx,%eax
  102c28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c2b:	0f 85 46 ff ff ff    	jne    102b77 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102c31:	8b 45 08             	mov    0x8(%ebp),%eax
  102c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c37:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3d:	83 c0 04             	add    $0x4,%eax
  102c40:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102c47:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c50:	0f ab 10             	bts    %edx,(%eax)
  102c53:	c7 45 cc 70 89 11 00 	movl   $0x118970,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c5d:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102c63:	e9 08 01 00 00       	jmp    102d70 <default_free_pages+0x237>
        p = le2page(le, page_link);
  102c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c6b:	83 e8 0c             	sub    $0xc,%eax
  102c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c74:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102c77:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c7a:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102c80:	8b 45 08             	mov    0x8(%ebp),%eax
  102c83:	8b 50 08             	mov    0x8(%eax),%edx
  102c86:	89 d0                	mov    %edx,%eax
  102c88:	c1 e0 02             	shl    $0x2,%eax
  102c8b:	01 d0                	add    %edx,%eax
  102c8d:	c1 e0 02             	shl    $0x2,%eax
  102c90:	89 c2                	mov    %eax,%edx
  102c92:	8b 45 08             	mov    0x8(%ebp),%eax
  102c95:	01 d0                	add    %edx,%eax
  102c97:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c9a:	75 5a                	jne    102cf6 <default_free_pages+0x1bd>
            base->property += p->property;
  102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9f:	8b 50 08             	mov    0x8(%eax),%edx
  102ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca5:	8b 40 08             	mov    0x8(%eax),%eax
  102ca8:	01 c2                	add    %eax,%edx
  102caa:	8b 45 08             	mov    0x8(%ebp),%eax
  102cad:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cb3:	83 c0 04             	add    $0x4,%eax
  102cb6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102cbd:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102cc3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102cc6:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ccc:	83 c0 0c             	add    $0xc,%eax
  102ccf:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102cd2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102cd5:	8b 40 04             	mov    0x4(%eax),%eax
  102cd8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cdb:	8b 12                	mov    (%edx),%edx
  102cdd:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102ce0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102ce3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ce6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ce9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102cec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102cef:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102cf2:	89 10                	mov    %edx,(%eax)
  102cf4:	eb 7a                	jmp    102d70 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf9:	8b 50 08             	mov    0x8(%eax),%edx
  102cfc:	89 d0                	mov    %edx,%eax
  102cfe:	c1 e0 02             	shl    $0x2,%eax
  102d01:	01 d0                	add    %edx,%eax
  102d03:	c1 e0 02             	shl    $0x2,%eax
  102d06:	89 c2                	mov    %eax,%edx
  102d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0b:	01 d0                	add    %edx,%eax
  102d0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d10:	75 5e                	jne    102d70 <default_free_pages+0x237>
            p->property += base->property;
  102d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d15:	8b 50 08             	mov    0x8(%eax),%edx
  102d18:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1b:	8b 40 08             	mov    0x8(%eax),%eax
  102d1e:	01 c2                	add    %eax,%edx
  102d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d23:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102d26:	8b 45 08             	mov    0x8(%ebp),%eax
  102d29:	83 c0 04             	add    $0x4,%eax
  102d2c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102d33:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102d36:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102d39:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102d3c:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d42:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d48:	83 c0 0c             	add    $0xc,%eax
  102d4b:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d4e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102d51:	8b 40 04             	mov    0x4(%eax),%eax
  102d54:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102d57:	8b 12                	mov    (%edx),%edx
  102d59:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102d5c:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d5f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102d62:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102d65:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d68:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102d6b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102d6e:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102d70:	81 7d f0 70 89 11 00 	cmpl   $0x118970,-0x10(%ebp)
  102d77:	0f 85 eb fe ff ff    	jne    102c68 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102d7d:	8b 15 78 89 11 00    	mov    0x118978,%edx
  102d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d86:	01 d0                	add    %edx,%eax
  102d88:	a3 78 89 11 00       	mov    %eax,0x118978
    list_add(&free_list, &(base->page_link));
  102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d90:	83 c0 0c             	add    $0xc,%eax
  102d93:	c7 45 9c 70 89 11 00 	movl   $0x118970,-0x64(%ebp)
  102d9a:	89 45 98             	mov    %eax,-0x68(%ebp)
  102d9d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102da0:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102da3:	8b 45 98             	mov    -0x68(%ebp),%eax
  102da6:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102da9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102dac:	8b 40 04             	mov    0x4(%eax),%eax
  102daf:	8b 55 90             	mov    -0x70(%ebp),%edx
  102db2:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102db5:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102db8:	89 55 88             	mov    %edx,-0x78(%ebp)
  102dbb:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102dbe:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102dc1:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102dc4:	89 10                	mov    %edx,(%eax)
  102dc6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102dc9:	8b 10                	mov    (%eax),%edx
  102dcb:	8b 45 88             	mov    -0x78(%ebp),%eax
  102dce:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102dd1:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102dd4:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102dd7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102dda:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102ddd:	8b 55 88             	mov    -0x78(%ebp),%edx
  102de0:	89 10                	mov    %edx,(%eax)
}
  102de2:	c9                   	leave  
  102de3:	c3                   	ret    

00102de4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102de4:	55                   	push   %ebp
  102de5:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102de7:	a1 78 89 11 00       	mov    0x118978,%eax
}
  102dec:	5d                   	pop    %ebp
  102ded:	c3                   	ret    

00102dee <basic_check>:

static void
basic_check(void) {
  102dee:	55                   	push   %ebp
  102def:	89 e5                	mov    %esp,%ebp
  102df1:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102df4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e0e:	e8 90 0e 00 00       	call   103ca3 <alloc_pages>
  102e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e1a:	75 24                	jne    102e40 <basic_check+0x52>
  102e1c:	c7 44 24 0c 19 65 10 	movl   $0x106519,0xc(%esp)
  102e23:	00 
  102e24:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102e2b:	00 
  102e2c:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  102e33:	00 
  102e34:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102e3b:	e8 8c de ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e47:	e8 57 0e 00 00       	call   103ca3 <alloc_pages>
  102e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e53:	75 24                	jne    102e79 <basic_check+0x8b>
  102e55:	c7 44 24 0c 35 65 10 	movl   $0x106535,0xc(%esp)
  102e5c:	00 
  102e5d:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102e64:	00 
  102e65:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  102e6c:	00 
  102e6d:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102e74:	e8 53 de ff ff       	call   100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
  102e79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e80:	e8 1e 0e 00 00       	call   103ca3 <alloc_pages>
  102e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102e8c:	75 24                	jne    102eb2 <basic_check+0xc4>
  102e8e:	c7 44 24 0c 51 65 10 	movl   $0x106551,0xc(%esp)
  102e95:	00 
  102e96:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102e9d:	00 
  102e9e:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  102ea5:	00 
  102ea6:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102ead:	e8 1a de ff ff       	call   100ccc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102eb8:	74 10                	je     102eca <basic_check+0xdc>
  102eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ebd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ec0:	74 08                	je     102eca <basic_check+0xdc>
  102ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ec8:	75 24                	jne    102eee <basic_check+0x100>
  102eca:	c7 44 24 0c 70 65 10 	movl   $0x106570,0xc(%esp)
  102ed1:	00 
  102ed2:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102ed9:	00 
  102eda:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  102ee1:	00 
  102ee2:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102ee9:	e8 de dd ff ff       	call   100ccc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ef1:	89 04 24             	mov    %eax,(%esp)
  102ef4:	e8 31 f9 ff ff       	call   10282a <page_ref>
  102ef9:	85 c0                	test   %eax,%eax
  102efb:	75 1e                	jne    102f1b <basic_check+0x12d>
  102efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f00:	89 04 24             	mov    %eax,(%esp)
  102f03:	e8 22 f9 ff ff       	call   10282a <page_ref>
  102f08:	85 c0                	test   %eax,%eax
  102f0a:	75 0f                	jne    102f1b <basic_check+0x12d>
  102f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f0f:	89 04 24             	mov    %eax,(%esp)
  102f12:	e8 13 f9 ff ff       	call   10282a <page_ref>
  102f17:	85 c0                	test   %eax,%eax
  102f19:	74 24                	je     102f3f <basic_check+0x151>
  102f1b:	c7 44 24 0c 94 65 10 	movl   $0x106594,0xc(%esp)
  102f22:	00 
  102f23:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102f2a:	00 
  102f2b:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  102f32:	00 
  102f33:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102f3a:	e8 8d dd ff ff       	call   100ccc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f42:	89 04 24             	mov    %eax,(%esp)
  102f45:	e8 ca f8 ff ff       	call   102814 <page2pa>
  102f4a:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  102f50:	c1 e2 0c             	shl    $0xc,%edx
  102f53:	39 d0                	cmp    %edx,%eax
  102f55:	72 24                	jb     102f7b <basic_check+0x18d>
  102f57:	c7 44 24 0c d0 65 10 	movl   $0x1065d0,0xc(%esp)
  102f5e:	00 
  102f5f:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102f66:	00 
  102f67:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  102f6e:	00 
  102f6f:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102f76:	e8 51 dd ff ff       	call   100ccc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f7e:	89 04 24             	mov    %eax,(%esp)
  102f81:	e8 8e f8 ff ff       	call   102814 <page2pa>
  102f86:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  102f8c:	c1 e2 0c             	shl    $0xc,%edx
  102f8f:	39 d0                	cmp    %edx,%eax
  102f91:	72 24                	jb     102fb7 <basic_check+0x1c9>
  102f93:	c7 44 24 0c ed 65 10 	movl   $0x1065ed,0xc(%esp)
  102f9a:	00 
  102f9b:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102fa2:	00 
  102fa3:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  102faa:	00 
  102fab:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102fb2:	e8 15 dd ff ff       	call   100ccc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fba:	89 04 24             	mov    %eax,(%esp)
  102fbd:	e8 52 f8 ff ff       	call   102814 <page2pa>
  102fc2:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  102fc8:	c1 e2 0c             	shl    $0xc,%edx
  102fcb:	39 d0                	cmp    %edx,%eax
  102fcd:	72 24                	jb     102ff3 <basic_check+0x205>
  102fcf:	c7 44 24 0c 0a 66 10 	movl   $0x10660a,0xc(%esp)
  102fd6:	00 
  102fd7:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102fde:	00 
  102fdf:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102fe6:	00 
  102fe7:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102fee:	e8 d9 dc ff ff       	call   100ccc <__panic>

    list_entry_t free_list_store = free_list;
  102ff3:	a1 70 89 11 00       	mov    0x118970,%eax
  102ff8:	8b 15 74 89 11 00    	mov    0x118974,%edx
  102ffe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103001:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103004:	c7 45 e0 70 89 11 00 	movl   $0x118970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10300b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10300e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103011:	89 50 04             	mov    %edx,0x4(%eax)
  103014:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103017:	8b 50 04             	mov    0x4(%eax),%edx
  10301a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10301d:	89 10                	mov    %edx,(%eax)
  10301f:	c7 45 dc 70 89 11 00 	movl   $0x118970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103026:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103029:	8b 40 04             	mov    0x4(%eax),%eax
  10302c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10302f:	0f 94 c0             	sete   %al
  103032:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103035:	85 c0                	test   %eax,%eax
  103037:	75 24                	jne    10305d <basic_check+0x26f>
  103039:	c7 44 24 0c 27 66 10 	movl   $0x106627,0xc(%esp)
  103040:	00 
  103041:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103048:	00 
  103049:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  103050:	00 
  103051:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103058:	e8 6f dc ff ff       	call   100ccc <__panic>

    unsigned int nr_free_store = nr_free;
  10305d:	a1 78 89 11 00       	mov    0x118978,%eax
  103062:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103065:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  10306c:	00 00 00 

    assert(alloc_page() == NULL);
  10306f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103076:	e8 28 0c 00 00       	call   103ca3 <alloc_pages>
  10307b:	85 c0                	test   %eax,%eax
  10307d:	74 24                	je     1030a3 <basic_check+0x2b5>
  10307f:	c7 44 24 0c 3e 66 10 	movl   $0x10663e,0xc(%esp)
  103086:	00 
  103087:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10308e:	00 
  10308f:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  103096:	00 
  103097:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10309e:	e8 29 dc ff ff       	call   100ccc <__panic>

    free_page(p0);
  1030a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030aa:	00 
  1030ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030ae:	89 04 24             	mov    %eax,(%esp)
  1030b1:	e8 25 0c 00 00       	call   103cdb <free_pages>
    free_page(p1);
  1030b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030bd:	00 
  1030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030c1:	89 04 24             	mov    %eax,(%esp)
  1030c4:	e8 12 0c 00 00       	call   103cdb <free_pages>
    free_page(p2);
  1030c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030d0:	00 
  1030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030d4:	89 04 24             	mov    %eax,(%esp)
  1030d7:	e8 ff 0b 00 00       	call   103cdb <free_pages>
    assert(nr_free == 3);
  1030dc:	a1 78 89 11 00       	mov    0x118978,%eax
  1030e1:	83 f8 03             	cmp    $0x3,%eax
  1030e4:	74 24                	je     10310a <basic_check+0x31c>
  1030e6:	c7 44 24 0c 53 66 10 	movl   $0x106653,0xc(%esp)
  1030ed:	00 
  1030ee:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1030f5:	00 
  1030f6:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  1030fd:	00 
  1030fe:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103105:	e8 c2 db ff ff       	call   100ccc <__panic>

    assert((p0 = alloc_page()) != NULL);
  10310a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103111:	e8 8d 0b 00 00       	call   103ca3 <alloc_pages>
  103116:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103119:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10311d:	75 24                	jne    103143 <basic_check+0x355>
  10311f:	c7 44 24 0c 19 65 10 	movl   $0x106519,0xc(%esp)
  103126:	00 
  103127:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10312e:	00 
  10312f:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  103136:	00 
  103137:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10313e:	e8 89 db ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
  103143:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10314a:	e8 54 0b 00 00       	call   103ca3 <alloc_pages>
  10314f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103156:	75 24                	jne    10317c <basic_check+0x38e>
  103158:	c7 44 24 0c 35 65 10 	movl   $0x106535,0xc(%esp)
  10315f:	00 
  103160:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103167:	00 
  103168:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  10316f:	00 
  103170:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103177:	e8 50 db ff ff       	call   100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
  10317c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103183:	e8 1b 0b 00 00       	call   103ca3 <alloc_pages>
  103188:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10318b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10318f:	75 24                	jne    1031b5 <basic_check+0x3c7>
  103191:	c7 44 24 0c 51 65 10 	movl   $0x106551,0xc(%esp)
  103198:	00 
  103199:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1031a0:	00 
  1031a1:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  1031a8:	00 
  1031a9:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1031b0:	e8 17 db ff ff       	call   100ccc <__panic>

    assert(alloc_page() == NULL);
  1031b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031bc:	e8 e2 0a 00 00       	call   103ca3 <alloc_pages>
  1031c1:	85 c0                	test   %eax,%eax
  1031c3:	74 24                	je     1031e9 <basic_check+0x3fb>
  1031c5:	c7 44 24 0c 3e 66 10 	movl   $0x10663e,0xc(%esp)
  1031cc:	00 
  1031cd:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1031d4:	00 
  1031d5:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  1031dc:	00 
  1031dd:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1031e4:	e8 e3 da ff ff       	call   100ccc <__panic>

    free_page(p0);
  1031e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031f0:	00 
  1031f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031f4:	89 04 24             	mov    %eax,(%esp)
  1031f7:	e8 df 0a 00 00       	call   103cdb <free_pages>
  1031fc:	c7 45 d8 70 89 11 00 	movl   $0x118970,-0x28(%ebp)
  103203:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103206:	8b 40 04             	mov    0x4(%eax),%eax
  103209:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10320c:	0f 94 c0             	sete   %al
  10320f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103212:	85 c0                	test   %eax,%eax
  103214:	74 24                	je     10323a <basic_check+0x44c>
  103216:	c7 44 24 0c 60 66 10 	movl   $0x106660,0xc(%esp)
  10321d:	00 
  10321e:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103225:	00 
  103226:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  10322d:	00 
  10322e:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103235:	e8 92 da ff ff       	call   100ccc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10323a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103241:	e8 5d 0a 00 00       	call   103ca3 <alloc_pages>
  103246:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103249:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10324c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10324f:	74 24                	je     103275 <basic_check+0x487>
  103251:	c7 44 24 0c 78 66 10 	movl   $0x106678,0xc(%esp)
  103258:	00 
  103259:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103260:	00 
  103261:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  103268:	00 
  103269:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103270:	e8 57 da ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  103275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10327c:	e8 22 0a 00 00       	call   103ca3 <alloc_pages>
  103281:	85 c0                	test   %eax,%eax
  103283:	74 24                	je     1032a9 <basic_check+0x4bb>
  103285:	c7 44 24 0c 3e 66 10 	movl   $0x10663e,0xc(%esp)
  10328c:	00 
  10328d:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103294:	00 
  103295:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10329c:	00 
  10329d:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1032a4:	e8 23 da ff ff       	call   100ccc <__panic>

    assert(nr_free == 0);
  1032a9:	a1 78 89 11 00       	mov    0x118978,%eax
  1032ae:	85 c0                	test   %eax,%eax
  1032b0:	74 24                	je     1032d6 <basic_check+0x4e8>
  1032b2:	c7 44 24 0c 91 66 10 	movl   $0x106691,0xc(%esp)
  1032b9:	00 
  1032ba:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1032c1:	00 
  1032c2:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  1032c9:	00 
  1032ca:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1032d1:	e8 f6 d9 ff ff       	call   100ccc <__panic>
    free_list = free_list_store;
  1032d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1032dc:	a3 70 89 11 00       	mov    %eax,0x118970
  1032e1:	89 15 74 89 11 00    	mov    %edx,0x118974
    nr_free = nr_free_store;
  1032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ea:	a3 78 89 11 00       	mov    %eax,0x118978

    free_page(p);
  1032ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032f6:	00 
  1032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032fa:	89 04 24             	mov    %eax,(%esp)
  1032fd:	e8 d9 09 00 00       	call   103cdb <free_pages>
    free_page(p1);
  103302:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103309:	00 
  10330a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10330d:	89 04 24             	mov    %eax,(%esp)
  103310:	e8 c6 09 00 00       	call   103cdb <free_pages>
    free_page(p2);
  103315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10331c:	00 
  10331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103320:	89 04 24             	mov    %eax,(%esp)
  103323:	e8 b3 09 00 00       	call   103cdb <free_pages>
}
  103328:	c9                   	leave  
  103329:	c3                   	ret    

0010332a <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10332a:	55                   	push   %ebp
  10332b:	89 e5                	mov    %esp,%ebp
  10332d:	53                   	push   %ebx
  10332e:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10333b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103342:	c7 45 ec 70 89 11 00 	movl   $0x118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103349:	eb 6b                	jmp    1033b6 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10334b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10334e:	83 e8 0c             	sub    $0xc,%eax
  103351:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103357:	83 c0 04             	add    $0x4,%eax
  10335a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103361:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103364:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103367:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10336a:	0f a3 10             	bt     %edx,(%eax)
  10336d:	19 c0                	sbb    %eax,%eax
  10336f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103372:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103376:	0f 95 c0             	setne  %al
  103379:	0f b6 c0             	movzbl %al,%eax
  10337c:	85 c0                	test   %eax,%eax
  10337e:	75 24                	jne    1033a4 <default_check+0x7a>
  103380:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  103387:	00 
  103388:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10338f:	00 
  103390:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103397:	00 
  103398:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10339f:	e8 28 d9 ff ff       	call   100ccc <__panic>
        count ++, total += p->property;
  1033a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ab:	8b 50 08             	mov    0x8(%eax),%edx
  1033ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b1:	01 d0                	add    %edx,%eax
  1033b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033bf:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033c5:	81 7d ec 70 89 11 00 	cmpl   $0x118970,-0x14(%ebp)
  1033cc:	0f 85 79 ff ff ff    	jne    10334b <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1033d2:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1033d5:	e8 33 09 00 00       	call   103d0d <nr_free_pages>
  1033da:	39 c3                	cmp    %eax,%ebx
  1033dc:	74 24                	je     103402 <default_check+0xd8>
  1033de:	c7 44 24 0c ae 66 10 	movl   $0x1066ae,0xc(%esp)
  1033e5:	00 
  1033e6:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1033ed:	00 
  1033ee:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  1033f5:	00 
  1033f6:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1033fd:	e8 ca d8 ff ff       	call   100ccc <__panic>

    basic_check();
  103402:	e8 e7 f9 ff ff       	call   102dee <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103407:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10340e:	e8 90 08 00 00       	call   103ca3 <alloc_pages>
  103413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103416:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10341a:	75 24                	jne    103440 <default_check+0x116>
  10341c:	c7 44 24 0c c7 66 10 	movl   $0x1066c7,0xc(%esp)
  103423:	00 
  103424:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10342b:	00 
  10342c:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103433:	00 
  103434:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10343b:	e8 8c d8 ff ff       	call   100ccc <__panic>
    assert(!PageProperty(p0));
  103440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103443:	83 c0 04             	add    $0x4,%eax
  103446:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10344d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103450:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103453:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103456:	0f a3 10             	bt     %edx,(%eax)
  103459:	19 c0                	sbb    %eax,%eax
  10345b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10345e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103462:	0f 95 c0             	setne  %al
  103465:	0f b6 c0             	movzbl %al,%eax
  103468:	85 c0                	test   %eax,%eax
  10346a:	74 24                	je     103490 <default_check+0x166>
  10346c:	c7 44 24 0c d2 66 10 	movl   $0x1066d2,0xc(%esp)
  103473:	00 
  103474:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10347b:	00 
  10347c:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103483:	00 
  103484:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10348b:	e8 3c d8 ff ff       	call   100ccc <__panic>

    list_entry_t free_list_store = free_list;
  103490:	a1 70 89 11 00       	mov    0x118970,%eax
  103495:	8b 15 74 89 11 00    	mov    0x118974,%edx
  10349b:	89 45 80             	mov    %eax,-0x80(%ebp)
  10349e:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034a1:	c7 45 b4 70 89 11 00 	movl   $0x118970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034ab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034ae:	89 50 04             	mov    %edx,0x4(%eax)
  1034b1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034b4:	8b 50 04             	mov    0x4(%eax),%edx
  1034b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034ba:	89 10                	mov    %edx,(%eax)
  1034bc:	c7 45 b0 70 89 11 00 	movl   $0x118970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034c6:	8b 40 04             	mov    0x4(%eax),%eax
  1034c9:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034cc:	0f 94 c0             	sete   %al
  1034cf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1034d2:	85 c0                	test   %eax,%eax
  1034d4:	75 24                	jne    1034fa <default_check+0x1d0>
  1034d6:	c7 44 24 0c 27 66 10 	movl   $0x106627,0xc(%esp)
  1034dd:	00 
  1034de:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1034e5:	00 
  1034e6:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1034ed:	00 
  1034ee:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1034f5:	e8 d2 d7 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  1034fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103501:	e8 9d 07 00 00       	call   103ca3 <alloc_pages>
  103506:	85 c0                	test   %eax,%eax
  103508:	74 24                	je     10352e <default_check+0x204>
  10350a:	c7 44 24 0c 3e 66 10 	movl   $0x10663e,0xc(%esp)
  103511:	00 
  103512:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103519:	00 
  10351a:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103521:	00 
  103522:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103529:	e8 9e d7 ff ff       	call   100ccc <__panic>

    unsigned int nr_free_store = nr_free;
  10352e:	a1 78 89 11 00       	mov    0x118978,%eax
  103533:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103536:	c7 05 78 89 11 00 00 	movl   $0x0,0x118978
  10353d:	00 00 00 

    free_pages(p0 + 2, 3);
  103540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103543:	83 c0 28             	add    $0x28,%eax
  103546:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10354d:	00 
  10354e:	89 04 24             	mov    %eax,(%esp)
  103551:	e8 85 07 00 00       	call   103cdb <free_pages>
    assert(alloc_pages(4) == NULL);
  103556:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10355d:	e8 41 07 00 00       	call   103ca3 <alloc_pages>
  103562:	85 c0                	test   %eax,%eax
  103564:	74 24                	je     10358a <default_check+0x260>
  103566:	c7 44 24 0c e4 66 10 	movl   $0x1066e4,0xc(%esp)
  10356d:	00 
  10356e:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103575:	00 
  103576:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  10357d:	00 
  10357e:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103585:	e8 42 d7 ff ff       	call   100ccc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10358a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10358d:	83 c0 28             	add    $0x28,%eax
  103590:	83 c0 04             	add    $0x4,%eax
  103593:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10359a:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10359d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035a0:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035a3:	0f a3 10             	bt     %edx,(%eax)
  1035a6:	19 c0                	sbb    %eax,%eax
  1035a8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035ab:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035af:	0f 95 c0             	setne  %al
  1035b2:	0f b6 c0             	movzbl %al,%eax
  1035b5:	85 c0                	test   %eax,%eax
  1035b7:	74 0e                	je     1035c7 <default_check+0x29d>
  1035b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035bc:	83 c0 28             	add    $0x28,%eax
  1035bf:	8b 40 08             	mov    0x8(%eax),%eax
  1035c2:	83 f8 03             	cmp    $0x3,%eax
  1035c5:	74 24                	je     1035eb <default_check+0x2c1>
  1035c7:	c7 44 24 0c fc 66 10 	movl   $0x1066fc,0xc(%esp)
  1035ce:	00 
  1035cf:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1035d6:	00 
  1035d7:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1035de:	00 
  1035df:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1035e6:	e8 e1 d6 ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1035eb:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1035f2:	e8 ac 06 00 00       	call   103ca3 <alloc_pages>
  1035f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1035fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1035fe:	75 24                	jne    103624 <default_check+0x2fa>
  103600:	c7 44 24 0c 28 67 10 	movl   $0x106728,0xc(%esp)
  103607:	00 
  103608:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10360f:	00 
  103610:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103617:	00 
  103618:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10361f:	e8 a8 d6 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  103624:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10362b:	e8 73 06 00 00       	call   103ca3 <alloc_pages>
  103630:	85 c0                	test   %eax,%eax
  103632:	74 24                	je     103658 <default_check+0x32e>
  103634:	c7 44 24 0c 3e 66 10 	movl   $0x10663e,0xc(%esp)
  10363b:	00 
  10363c:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103643:	00 
  103644:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  10364b:	00 
  10364c:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103653:	e8 74 d6 ff ff       	call   100ccc <__panic>
    assert(p0 + 2 == p1);
  103658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10365b:	83 c0 28             	add    $0x28,%eax
  10365e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103661:	74 24                	je     103687 <default_check+0x35d>
  103663:	c7 44 24 0c 46 67 10 	movl   $0x106746,0xc(%esp)
  10366a:	00 
  10366b:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103672:	00 
  103673:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10367a:	00 
  10367b:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103682:	e8 45 d6 ff ff       	call   100ccc <__panic>

    p2 = p0 + 1;
  103687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10368a:	83 c0 14             	add    $0x14,%eax
  10368d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103690:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103697:	00 
  103698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10369b:	89 04 24             	mov    %eax,(%esp)
  10369e:	e8 38 06 00 00       	call   103cdb <free_pages>
    free_pages(p1, 3);
  1036a3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036aa:	00 
  1036ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036ae:	89 04 24             	mov    %eax,(%esp)
  1036b1:	e8 25 06 00 00       	call   103cdb <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b9:	83 c0 04             	add    $0x4,%eax
  1036bc:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036c3:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036c6:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036c9:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036cc:	0f a3 10             	bt     %edx,(%eax)
  1036cf:	19 c0                	sbb    %eax,%eax
  1036d1:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1036d4:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1036d8:	0f 95 c0             	setne  %al
  1036db:	0f b6 c0             	movzbl %al,%eax
  1036de:	85 c0                	test   %eax,%eax
  1036e0:	74 0b                	je     1036ed <default_check+0x3c3>
  1036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036e5:	8b 40 08             	mov    0x8(%eax),%eax
  1036e8:	83 f8 01             	cmp    $0x1,%eax
  1036eb:	74 24                	je     103711 <default_check+0x3e7>
  1036ed:	c7 44 24 0c 54 67 10 	movl   $0x106754,0xc(%esp)
  1036f4:	00 
  1036f5:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1036fc:	00 
  1036fd:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103704:	00 
  103705:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10370c:	e8 bb d5 ff ff       	call   100ccc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103711:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103714:	83 c0 04             	add    $0x4,%eax
  103717:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10371e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103721:	8b 45 90             	mov    -0x70(%ebp),%eax
  103724:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103727:	0f a3 10             	bt     %edx,(%eax)
  10372a:	19 c0                	sbb    %eax,%eax
  10372c:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10372f:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103733:	0f 95 c0             	setne  %al
  103736:	0f b6 c0             	movzbl %al,%eax
  103739:	85 c0                	test   %eax,%eax
  10373b:	74 0b                	je     103748 <default_check+0x41e>
  10373d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103740:	8b 40 08             	mov    0x8(%eax),%eax
  103743:	83 f8 03             	cmp    $0x3,%eax
  103746:	74 24                	je     10376c <default_check+0x442>
  103748:	c7 44 24 0c 7c 67 10 	movl   $0x10677c,0xc(%esp)
  10374f:	00 
  103750:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103757:	00 
  103758:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  10375f:	00 
  103760:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103767:	e8 60 d5 ff ff       	call   100ccc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10376c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103773:	e8 2b 05 00 00       	call   103ca3 <alloc_pages>
  103778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10377b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10377e:	83 e8 14             	sub    $0x14,%eax
  103781:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103784:	74 24                	je     1037aa <default_check+0x480>
  103786:	c7 44 24 0c a2 67 10 	movl   $0x1067a2,0xc(%esp)
  10378d:	00 
  10378e:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103795:	00 
  103796:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10379d:	00 
  10379e:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1037a5:	e8 22 d5 ff ff       	call   100ccc <__panic>
    free_page(p0);
  1037aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037b1:	00 
  1037b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037b5:	89 04 24             	mov    %eax,(%esp)
  1037b8:	e8 1e 05 00 00       	call   103cdb <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037bd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037c4:	e8 da 04 00 00       	call   103ca3 <alloc_pages>
  1037c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037cf:	83 c0 14             	add    $0x14,%eax
  1037d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037d5:	74 24                	je     1037fb <default_check+0x4d1>
  1037d7:	c7 44 24 0c c0 67 10 	movl   $0x1067c0,0xc(%esp)
  1037de:	00 
  1037df:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1037e6:	00 
  1037e7:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  1037ee:	00 
  1037ef:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1037f6:	e8 d1 d4 ff ff       	call   100ccc <__panic>

    free_pages(p0, 2);
  1037fb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103802:	00 
  103803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103806:	89 04 24             	mov    %eax,(%esp)
  103809:	e8 cd 04 00 00       	call   103cdb <free_pages>
    free_page(p2);
  10380e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103815:	00 
  103816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103819:	89 04 24             	mov    %eax,(%esp)
  10381c:	e8 ba 04 00 00       	call   103cdb <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103821:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103828:	e8 76 04 00 00       	call   103ca3 <alloc_pages>
  10382d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103830:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103834:	75 24                	jne    10385a <default_check+0x530>
  103836:	c7 44 24 0c e0 67 10 	movl   $0x1067e0,0xc(%esp)
  10383d:	00 
  10383e:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103845:	00 
  103846:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  10384d:	00 
  10384e:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103855:	e8 72 d4 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  10385a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103861:	e8 3d 04 00 00       	call   103ca3 <alloc_pages>
  103866:	85 c0                	test   %eax,%eax
  103868:	74 24                	je     10388e <default_check+0x564>
  10386a:	c7 44 24 0c 3e 66 10 	movl   $0x10663e,0xc(%esp)
  103871:	00 
  103872:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103879:	00 
  10387a:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103881:	00 
  103882:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103889:	e8 3e d4 ff ff       	call   100ccc <__panic>

    assert(nr_free == 0);
  10388e:	a1 78 89 11 00       	mov    0x118978,%eax
  103893:	85 c0                	test   %eax,%eax
  103895:	74 24                	je     1038bb <default_check+0x591>
  103897:	c7 44 24 0c 91 66 10 	movl   $0x106691,0xc(%esp)
  10389e:	00 
  10389f:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1038a6:	00 
  1038a7:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1038ae:	00 
  1038af:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1038b6:	e8 11 d4 ff ff       	call   100ccc <__panic>
    nr_free = nr_free_store;
  1038bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038be:	a3 78 89 11 00       	mov    %eax,0x118978

    free_list = free_list_store;
  1038c3:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038c6:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038c9:	a3 70 89 11 00       	mov    %eax,0x118970
  1038ce:	89 15 74 89 11 00    	mov    %edx,0x118974
    free_pages(p0, 5);
  1038d4:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1038db:	00 
  1038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038df:	89 04 24             	mov    %eax,(%esp)
  1038e2:	e8 f4 03 00 00       	call   103cdb <free_pages>

    le = &free_list;
  1038e7:	c7 45 ec 70 89 11 00 	movl   $0x118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1038ee:	eb 1d                	jmp    10390d <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1038f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038f3:	83 e8 0c             	sub    $0xc,%eax
  1038f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1038f9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1038fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103903:	8b 40 08             	mov    0x8(%eax),%eax
  103906:	29 c2                	sub    %eax,%edx
  103908:	89 d0                	mov    %edx,%eax
  10390a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10390d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103910:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103913:	8b 45 88             	mov    -0x78(%ebp),%eax
  103916:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103919:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10391c:	81 7d ec 70 89 11 00 	cmpl   $0x118970,-0x14(%ebp)
  103923:	75 cb                	jne    1038f0 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103929:	74 24                	je     10394f <default_check+0x625>
  10392b:	c7 44 24 0c fe 67 10 	movl   $0x1067fe,0xc(%esp)
  103932:	00 
  103933:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10393a:	00 
  10393b:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103942:	00 
  103943:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10394a:	e8 7d d3 ff ff       	call   100ccc <__panic>
    assert(total == 0);
  10394f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103953:	74 24                	je     103979 <default_check+0x64f>
  103955:	c7 44 24 0c 09 68 10 	movl   $0x106809,0xc(%esp)
  10395c:	00 
  10395d:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103964:	00 
  103965:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10396c:	00 
  10396d:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103974:	e8 53 d3 ff ff       	call   100ccc <__panic>
}
  103979:	81 c4 94 00 00 00    	add    $0x94,%esp
  10397f:	5b                   	pop    %ebx
  103980:	5d                   	pop    %ebp
  103981:	c3                   	ret    

00103982 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103982:	55                   	push   %ebp
  103983:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103985:	8b 55 08             	mov    0x8(%ebp),%edx
  103988:	a1 84 89 11 00       	mov    0x118984,%eax
  10398d:	29 c2                	sub    %eax,%edx
  10398f:	89 d0                	mov    %edx,%eax
  103991:	c1 f8 02             	sar    $0x2,%eax
  103994:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10399a:	5d                   	pop    %ebp
  10399b:	c3                   	ret    

0010399c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10399c:	55                   	push   %ebp
  10399d:	89 e5                	mov    %esp,%ebp
  10399f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1039a5:	89 04 24             	mov    %eax,(%esp)
  1039a8:	e8 d5 ff ff ff       	call   103982 <page2ppn>
  1039ad:	c1 e0 0c             	shl    $0xc,%eax
}
  1039b0:	c9                   	leave  
  1039b1:	c3                   	ret    

001039b2 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039b2:	55                   	push   %ebp
  1039b3:	89 e5                	mov    %esp,%ebp
  1039b5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1039bb:	c1 e8 0c             	shr    $0xc,%eax
  1039be:	89 c2                	mov    %eax,%edx
  1039c0:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  1039c5:	39 c2                	cmp    %eax,%edx
  1039c7:	72 1c                	jb     1039e5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039c9:	c7 44 24 08 44 68 10 	movl   $0x106844,0x8(%esp)
  1039d0:	00 
  1039d1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1039d8:	00 
  1039d9:	c7 04 24 63 68 10 00 	movl   $0x106863,(%esp)
  1039e0:	e8 e7 d2 ff ff       	call   100ccc <__panic>
    }
    return &pages[PPN(pa)];
  1039e5:	8b 0d 84 89 11 00    	mov    0x118984,%ecx
  1039eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1039ee:	c1 e8 0c             	shr    $0xc,%eax
  1039f1:	89 c2                	mov    %eax,%edx
  1039f3:	89 d0                	mov    %edx,%eax
  1039f5:	c1 e0 02             	shl    $0x2,%eax
  1039f8:	01 d0                	add    %edx,%eax
  1039fa:	c1 e0 02             	shl    $0x2,%eax
  1039fd:	01 c8                	add    %ecx,%eax
}
  1039ff:	c9                   	leave  
  103a00:	c3                   	ret    

00103a01 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a01:	55                   	push   %ebp
  103a02:	89 e5                	mov    %esp,%ebp
  103a04:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a07:	8b 45 08             	mov    0x8(%ebp),%eax
  103a0a:	89 04 24             	mov    %eax,(%esp)
  103a0d:	e8 8a ff ff ff       	call   10399c <page2pa>
  103a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a18:	c1 e8 0c             	shr    $0xc,%eax
  103a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a1e:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103a23:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a26:	72 23                	jb     103a4b <page2kva+0x4a>
  103a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a2f:	c7 44 24 08 74 68 10 	movl   $0x106874,0x8(%esp)
  103a36:	00 
  103a37:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a3e:	00 
  103a3f:	c7 04 24 63 68 10 00 	movl   $0x106863,(%esp)
  103a46:	e8 81 d2 ff ff       	call   100ccc <__panic>
  103a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a4e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a53:	c9                   	leave  
  103a54:	c3                   	ret    

00103a55 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a55:	55                   	push   %ebp
  103a56:	89 e5                	mov    %esp,%ebp
  103a58:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5e:	83 e0 01             	and    $0x1,%eax
  103a61:	85 c0                	test   %eax,%eax
  103a63:	75 1c                	jne    103a81 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a65:	c7 44 24 08 98 68 10 	movl   $0x106898,0x8(%esp)
  103a6c:	00 
  103a6d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a74:	00 
  103a75:	c7 04 24 63 68 10 00 	movl   $0x106863,(%esp)
  103a7c:	e8 4b d2 ff ff       	call   100ccc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103a81:	8b 45 08             	mov    0x8(%ebp),%eax
  103a84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a89:	89 04 24             	mov    %eax,(%esp)
  103a8c:	e8 21 ff ff ff       	call   1039b2 <pa2page>
}
  103a91:	c9                   	leave  
  103a92:	c3                   	ret    

00103a93 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103a93:	55                   	push   %ebp
  103a94:	89 e5                	mov    %esp,%ebp
  103a96:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103a99:	8b 45 08             	mov    0x8(%ebp),%eax
  103a9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103aa1:	89 04 24             	mov    %eax,(%esp)
  103aa4:	e8 09 ff ff ff       	call   1039b2 <pa2page>
}
  103aa9:	c9                   	leave  
  103aaa:	c3                   	ret    

00103aab <page_ref>:

static inline int
page_ref(struct Page *page) {
  103aab:	55                   	push   %ebp
  103aac:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103aae:	8b 45 08             	mov    0x8(%ebp),%eax
  103ab1:	8b 00                	mov    (%eax),%eax
}
  103ab3:	5d                   	pop    %ebp
  103ab4:	c3                   	ret    

00103ab5 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103ab5:	55                   	push   %ebp
  103ab6:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  103abb:	8b 00                	mov    (%eax),%eax
  103abd:	8d 50 01             	lea    0x1(%eax),%edx
  103ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac3:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac8:	8b 00                	mov    (%eax),%eax
}
  103aca:	5d                   	pop    %ebp
  103acb:	c3                   	ret    

00103acc <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103acc:	55                   	push   %ebp
  103acd:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103acf:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad2:	8b 00                	mov    (%eax),%eax
  103ad4:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  103ada:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103adc:	8b 45 08             	mov    0x8(%ebp),%eax
  103adf:	8b 00                	mov    (%eax),%eax
}
  103ae1:	5d                   	pop    %ebp
  103ae2:	c3                   	ret    

00103ae3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103ae3:	55                   	push   %ebp
  103ae4:	89 e5                	mov    %esp,%ebp
  103ae6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103ae9:	9c                   	pushf  
  103aea:	58                   	pop    %eax
  103aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103af1:	25 00 02 00 00       	and    $0x200,%eax
  103af6:	85 c0                	test   %eax,%eax
  103af8:	74 0c                	je     103b06 <__intr_save+0x23>
        intr_disable();
  103afa:	e8 b0 db ff ff       	call   1016af <intr_disable>
        return 1;
  103aff:	b8 01 00 00 00       	mov    $0x1,%eax
  103b04:	eb 05                	jmp    103b0b <__intr_save+0x28>
    }
    return 0;
  103b06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b0b:	c9                   	leave  
  103b0c:	c3                   	ret    

00103b0d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b0d:	55                   	push   %ebp
  103b0e:	89 e5                	mov    %esp,%ebp
  103b10:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b17:	74 05                	je     103b1e <__intr_restore+0x11>
        intr_enable();
  103b19:	e8 8b db ff ff       	call   1016a9 <intr_enable>
    }
}
  103b1e:	c9                   	leave  
  103b1f:	c3                   	ret    

00103b20 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b20:	55                   	push   %ebp
  103b21:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b23:	8b 45 08             	mov    0x8(%ebp),%eax
  103b26:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b29:	b8 23 00 00 00       	mov    $0x23,%eax
  103b2e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b30:	b8 23 00 00 00       	mov    $0x23,%eax
  103b35:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b37:	b8 10 00 00 00       	mov    $0x10,%eax
  103b3c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b3e:	b8 10 00 00 00       	mov    $0x10,%eax
  103b43:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b45:	b8 10 00 00 00       	mov    $0x10,%eax
  103b4a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b4c:	ea 53 3b 10 00 08 00 	ljmp   $0x8,$0x103b53
}
  103b53:	5d                   	pop    %ebp
  103b54:	c3                   	ret    

00103b55 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b55:	55                   	push   %ebp
  103b56:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b58:	8b 45 08             	mov    0x8(%ebp),%eax
  103b5b:	a3 04 89 11 00       	mov    %eax,0x118904
}
  103b60:	5d                   	pop    %ebp
  103b61:	c3                   	ret    

00103b62 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b62:	55                   	push   %ebp
  103b63:	89 e5                	mov    %esp,%ebp
  103b65:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b68:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b6d:	89 04 24             	mov    %eax,(%esp)
  103b70:	e8 e0 ff ff ff       	call   103b55 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b75:	66 c7 05 08 89 11 00 	movw   $0x10,0x118908
  103b7c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b7e:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103b85:	68 00 
  103b87:	b8 00 89 11 00       	mov    $0x118900,%eax
  103b8c:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103b92:	b8 00 89 11 00       	mov    $0x118900,%eax
  103b97:	c1 e8 10             	shr    $0x10,%eax
  103b9a:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103b9f:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103ba6:	83 e0 f0             	and    $0xfffffff0,%eax
  103ba9:	83 c8 09             	or     $0x9,%eax
  103bac:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bb1:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bb8:	83 e0 ef             	and    $0xffffffef,%eax
  103bbb:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bc0:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bc7:	83 e0 9f             	and    $0xffffff9f,%eax
  103bca:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bcf:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bd6:	83 c8 80             	or     $0xffffff80,%eax
  103bd9:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bde:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103be5:	83 e0 f0             	and    $0xfffffff0,%eax
  103be8:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bed:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103bf4:	83 e0 ef             	and    $0xffffffef,%eax
  103bf7:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103bfc:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c03:	83 e0 df             	and    $0xffffffdf,%eax
  103c06:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c0b:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c12:	83 c8 40             	or     $0x40,%eax
  103c15:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c1a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c21:	83 e0 7f             	and    $0x7f,%eax
  103c24:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c29:	b8 00 89 11 00       	mov    $0x118900,%eax
  103c2e:	c1 e8 18             	shr    $0x18,%eax
  103c31:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c36:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c3d:	e8 de fe ff ff       	call   103b20 <lgdt>
  103c42:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c48:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c4c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c4f:	c9                   	leave  
  103c50:	c3                   	ret    

00103c51 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c51:	55                   	push   %ebp
  103c52:	89 e5                	mov    %esp,%ebp
  103c54:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c57:	c7 05 7c 89 11 00 28 	movl   $0x106828,0x11897c
  103c5e:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c61:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103c66:	8b 00                	mov    (%eax),%eax
  103c68:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c6c:	c7 04 24 c4 68 10 00 	movl   $0x1068c4,(%esp)
  103c73:	e8 c4 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c78:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103c7d:	8b 40 04             	mov    0x4(%eax),%eax
  103c80:	ff d0                	call   *%eax
}
  103c82:	c9                   	leave  
  103c83:	c3                   	ret    

00103c84 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c84:	55                   	push   %ebp
  103c85:	89 e5                	mov    %esp,%ebp
  103c87:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103c8a:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103c8f:	8b 40 08             	mov    0x8(%eax),%eax
  103c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c95:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c99:	8b 55 08             	mov    0x8(%ebp),%edx
  103c9c:	89 14 24             	mov    %edx,(%esp)
  103c9f:	ff d0                	call   *%eax
}
  103ca1:	c9                   	leave  
  103ca2:	c3                   	ret    

00103ca3 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103ca3:	55                   	push   %ebp
  103ca4:	89 e5                	mov    %esp,%ebp
  103ca6:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103cb0:	e8 2e fe ff ff       	call   103ae3 <__intr_save>
  103cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103cb8:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  103cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  103cc3:	89 14 24             	mov    %edx,(%esp)
  103cc6:	ff d0                	call   *%eax
  103cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cce:	89 04 24             	mov    %eax,(%esp)
  103cd1:	e8 37 fe ff ff       	call   103b0d <__intr_restore>
    return page;
  103cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103cd9:	c9                   	leave  
  103cda:	c3                   	ret    

00103cdb <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103cdb:	55                   	push   %ebp
  103cdc:	89 e5                	mov    %esp,%ebp
  103cde:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103ce1:	e8 fd fd ff ff       	call   103ae3 <__intr_save>
  103ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103ce9:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103cee:	8b 40 10             	mov    0x10(%eax),%eax
  103cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cf4:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  103cfb:	89 14 24             	mov    %edx,(%esp)
  103cfe:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d03:	89 04 24             	mov    %eax,(%esp)
  103d06:	e8 02 fe ff ff       	call   103b0d <__intr_restore>
}
  103d0b:	c9                   	leave  
  103d0c:	c3                   	ret    

00103d0d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d0d:	55                   	push   %ebp
  103d0e:	89 e5                	mov    %esp,%ebp
  103d10:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d13:	e8 cb fd ff ff       	call   103ae3 <__intr_save>
  103d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d1b:	a1 7c 89 11 00       	mov    0x11897c,%eax
  103d20:	8b 40 14             	mov    0x14(%eax),%eax
  103d23:	ff d0                	call   *%eax
  103d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d2b:	89 04 24             	mov    %eax,(%esp)
  103d2e:	e8 da fd ff ff       	call   103b0d <__intr_restore>
    return ret;
  103d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d36:	c9                   	leave  
  103d37:	c3                   	ret    

00103d38 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d38:	55                   	push   %ebp
  103d39:	89 e5                	mov    %esp,%ebp
  103d3b:	57                   	push   %edi
  103d3c:	56                   	push   %esi
  103d3d:	53                   	push   %ebx
  103d3e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d44:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d59:	c7 04 24 db 68 10 00 	movl   $0x1068db,(%esp)
  103d60:	e8 d7 c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d6c:	e9 15 01 00 00       	jmp    103e86 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d77:	89 d0                	mov    %edx,%eax
  103d79:	c1 e0 02             	shl    $0x2,%eax
  103d7c:	01 d0                	add    %edx,%eax
  103d7e:	c1 e0 02             	shl    $0x2,%eax
  103d81:	01 c8                	add    %ecx,%eax
  103d83:	8b 50 08             	mov    0x8(%eax),%edx
  103d86:	8b 40 04             	mov    0x4(%eax),%eax
  103d89:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103d8c:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103d8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d95:	89 d0                	mov    %edx,%eax
  103d97:	c1 e0 02             	shl    $0x2,%eax
  103d9a:	01 d0                	add    %edx,%eax
  103d9c:	c1 e0 02             	shl    $0x2,%eax
  103d9f:	01 c8                	add    %ecx,%eax
  103da1:	8b 48 0c             	mov    0xc(%eax),%ecx
  103da4:	8b 58 10             	mov    0x10(%eax),%ebx
  103da7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103daa:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dad:	01 c8                	add    %ecx,%eax
  103daf:	11 da                	adc    %ebx,%edx
  103db1:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103db4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103db7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dbd:	89 d0                	mov    %edx,%eax
  103dbf:	c1 e0 02             	shl    $0x2,%eax
  103dc2:	01 d0                	add    %edx,%eax
  103dc4:	c1 e0 02             	shl    $0x2,%eax
  103dc7:	01 c8                	add    %ecx,%eax
  103dc9:	83 c0 14             	add    $0x14,%eax
  103dcc:	8b 00                	mov    (%eax),%eax
  103dce:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103dd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103dd7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103dda:	83 c0 ff             	add    $0xffffffff,%eax
  103ddd:	83 d2 ff             	adc    $0xffffffff,%edx
  103de0:	89 c6                	mov    %eax,%esi
  103de2:	89 d7                	mov    %edx,%edi
  103de4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103de7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dea:	89 d0                	mov    %edx,%eax
  103dec:	c1 e0 02             	shl    $0x2,%eax
  103def:	01 d0                	add    %edx,%eax
  103df1:	c1 e0 02             	shl    $0x2,%eax
  103df4:	01 c8                	add    %ecx,%eax
  103df6:	8b 48 0c             	mov    0xc(%eax),%ecx
  103df9:	8b 58 10             	mov    0x10(%eax),%ebx
  103dfc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e02:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e06:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e0a:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e11:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e18:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e1c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e20:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e24:	c7 04 24 e8 68 10 00 	movl   $0x1068e8,(%esp)
  103e2b:	e8 0c c5 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e30:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e33:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e36:	89 d0                	mov    %edx,%eax
  103e38:	c1 e0 02             	shl    $0x2,%eax
  103e3b:	01 d0                	add    %edx,%eax
  103e3d:	c1 e0 02             	shl    $0x2,%eax
  103e40:	01 c8                	add    %ecx,%eax
  103e42:	83 c0 14             	add    $0x14,%eax
  103e45:	8b 00                	mov    (%eax),%eax
  103e47:	83 f8 01             	cmp    $0x1,%eax
  103e4a:	75 36                	jne    103e82 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e52:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e55:	77 2b                	ja     103e82 <page_init+0x14a>
  103e57:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e5a:	72 05                	jb     103e61 <page_init+0x129>
  103e5c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e5f:	73 21                	jae    103e82 <page_init+0x14a>
  103e61:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e65:	77 1b                	ja     103e82 <page_init+0x14a>
  103e67:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e6b:	72 09                	jb     103e76 <page_init+0x13e>
  103e6d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e74:	77 0c                	ja     103e82 <page_init+0x14a>
                maxpa = end;
  103e76:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e79:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e82:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103e86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103e89:	8b 00                	mov    (%eax),%eax
  103e8b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103e8e:	0f 8f dd fe ff ff    	jg     103d71 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103e94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e98:	72 1d                	jb     103eb7 <page_init+0x17f>
  103e9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e9e:	77 09                	ja     103ea9 <page_init+0x171>
  103ea0:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103ea7:	76 0e                	jbe    103eb7 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ea9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103eb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103eba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ebd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ec1:	c1 ea 0c             	shr    $0xc,%edx
  103ec4:	a3 e0 88 11 00       	mov    %eax,0x1188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103ec9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103ed0:	b8 88 89 11 00       	mov    $0x118988,%eax
  103ed5:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ed8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103edb:	01 d0                	add    %edx,%eax
  103edd:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103ee0:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103ee3:	ba 00 00 00 00       	mov    $0x0,%edx
  103ee8:	f7 75 ac             	divl   -0x54(%ebp)
  103eeb:	89 d0                	mov    %edx,%eax
  103eed:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103ef0:	29 c2                	sub    %eax,%edx
  103ef2:	89 d0                	mov    %edx,%eax
  103ef4:	a3 84 89 11 00       	mov    %eax,0x118984

    for (i = 0; i < npage; i ++) {
  103ef9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f00:	eb 2f                	jmp    103f31 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f02:	8b 0d 84 89 11 00    	mov    0x118984,%ecx
  103f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f0b:	89 d0                	mov    %edx,%eax
  103f0d:	c1 e0 02             	shl    $0x2,%eax
  103f10:	01 d0                	add    %edx,%eax
  103f12:	c1 e0 02             	shl    $0x2,%eax
  103f15:	01 c8                	add    %ecx,%eax
  103f17:	83 c0 04             	add    $0x4,%eax
  103f1a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f21:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f24:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f27:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f2a:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f2d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f34:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  103f39:	39 c2                	cmp    %eax,%edx
  103f3b:	72 c5                	jb     103f02 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f3d:	8b 15 e0 88 11 00    	mov    0x1188e0,%edx
  103f43:	89 d0                	mov    %edx,%eax
  103f45:	c1 e0 02             	shl    $0x2,%eax
  103f48:	01 d0                	add    %edx,%eax
  103f4a:	c1 e0 02             	shl    $0x2,%eax
  103f4d:	89 c2                	mov    %eax,%edx
  103f4f:	a1 84 89 11 00       	mov    0x118984,%eax
  103f54:	01 d0                	add    %edx,%eax
  103f56:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f59:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f60:	77 23                	ja     103f85 <page_init+0x24d>
  103f62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f69:	c7 44 24 08 18 69 10 	movl   $0x106918,0x8(%esp)
  103f70:	00 
  103f71:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f78:	00 
  103f79:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  103f80:	e8 47 cd ff ff       	call   100ccc <__panic>
  103f85:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f88:	05 00 00 00 40       	add    $0x40000000,%eax
  103f8d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f97:	e9 74 01 00 00       	jmp    104110 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103f9c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fa2:	89 d0                	mov    %edx,%eax
  103fa4:	c1 e0 02             	shl    $0x2,%eax
  103fa7:	01 d0                	add    %edx,%eax
  103fa9:	c1 e0 02             	shl    $0x2,%eax
  103fac:	01 c8                	add    %ecx,%eax
  103fae:	8b 50 08             	mov    0x8(%eax),%edx
  103fb1:	8b 40 04             	mov    0x4(%eax),%eax
  103fb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fb7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fbd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fc0:	89 d0                	mov    %edx,%eax
  103fc2:	c1 e0 02             	shl    $0x2,%eax
  103fc5:	01 d0                	add    %edx,%eax
  103fc7:	c1 e0 02             	shl    $0x2,%eax
  103fca:	01 c8                	add    %ecx,%eax
  103fcc:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fcf:	8b 58 10             	mov    0x10(%eax),%ebx
  103fd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103fd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103fd8:	01 c8                	add    %ecx,%eax
  103fda:	11 da                	adc    %ebx,%edx
  103fdc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103fdf:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103fe2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fe5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fe8:	89 d0                	mov    %edx,%eax
  103fea:	c1 e0 02             	shl    $0x2,%eax
  103fed:	01 d0                	add    %edx,%eax
  103fef:	c1 e0 02             	shl    $0x2,%eax
  103ff2:	01 c8                	add    %ecx,%eax
  103ff4:	83 c0 14             	add    $0x14,%eax
  103ff7:	8b 00                	mov    (%eax),%eax
  103ff9:	83 f8 01             	cmp    $0x1,%eax
  103ffc:	0f 85 0a 01 00 00    	jne    10410c <page_init+0x3d4>
            if (begin < freemem) {
  104002:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104005:	ba 00 00 00 00       	mov    $0x0,%edx
  10400a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10400d:	72 17                	jb     104026 <page_init+0x2ee>
  10400f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104012:	77 05                	ja     104019 <page_init+0x2e1>
  104014:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104017:	76 0d                	jbe    104026 <page_init+0x2ee>
                begin = freemem;
  104019:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10401c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10401f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104026:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10402a:	72 1d                	jb     104049 <page_init+0x311>
  10402c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104030:	77 09                	ja     10403b <page_init+0x303>
  104032:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104039:	76 0e                	jbe    104049 <page_init+0x311>
                end = KMEMSIZE;
  10403b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104042:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104049:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10404c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10404f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104052:	0f 87 b4 00 00 00    	ja     10410c <page_init+0x3d4>
  104058:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10405b:	72 09                	jb     104066 <page_init+0x32e>
  10405d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104060:	0f 83 a6 00 00 00    	jae    10410c <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104066:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10406d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104070:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104073:	01 d0                	add    %edx,%eax
  104075:	83 e8 01             	sub    $0x1,%eax
  104078:	89 45 98             	mov    %eax,-0x68(%ebp)
  10407b:	8b 45 98             	mov    -0x68(%ebp),%eax
  10407e:	ba 00 00 00 00       	mov    $0x0,%edx
  104083:	f7 75 9c             	divl   -0x64(%ebp)
  104086:	89 d0                	mov    %edx,%eax
  104088:	8b 55 98             	mov    -0x68(%ebp),%edx
  10408b:	29 c2                	sub    %eax,%edx
  10408d:	89 d0                	mov    %edx,%eax
  10408f:	ba 00 00 00 00       	mov    $0x0,%edx
  104094:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104097:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10409a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10409d:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040a0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040a3:	ba 00 00 00 00       	mov    $0x0,%edx
  1040a8:	89 c7                	mov    %eax,%edi
  1040aa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040b0:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040b3:	89 d0                	mov    %edx,%eax
  1040b5:	83 e0 00             	and    $0x0,%eax
  1040b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040bb:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040be:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040d0:	77 3a                	ja     10410c <page_init+0x3d4>
  1040d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040d5:	72 05                	jb     1040dc <page_init+0x3a4>
  1040d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040da:	73 30                	jae    10410c <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1040dc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1040df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1040e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1040e8:	29 c8                	sub    %ecx,%eax
  1040ea:	19 da                	sbb    %ebx,%edx
  1040ec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1040f0:	c1 ea 0c             	shr    $0xc,%edx
  1040f3:	89 c3                	mov    %eax,%ebx
  1040f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040f8:	89 04 24             	mov    %eax,(%esp)
  1040fb:	e8 b2 f8 ff ff       	call   1039b2 <pa2page>
  104100:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104104:	89 04 24             	mov    %eax,(%esp)
  104107:	e8 78 fb ff ff       	call   103c84 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10410c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104110:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104113:	8b 00                	mov    (%eax),%eax
  104115:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104118:	0f 8f 7e fe ff ff    	jg     103f9c <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10411e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104124:	5b                   	pop    %ebx
  104125:	5e                   	pop    %esi
  104126:	5f                   	pop    %edi
  104127:	5d                   	pop    %ebp
  104128:	c3                   	ret    

00104129 <enable_paging>:

static void
enable_paging(void) {
  104129:	55                   	push   %ebp
  10412a:	89 e5                	mov    %esp,%ebp
  10412c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10412f:	a1 80 89 11 00       	mov    0x118980,%eax
  104134:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104137:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10413a:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10413d:	0f 20 c0             	mov    %cr0,%eax
  104140:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104143:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104146:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104149:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104150:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104154:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10415a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10415d:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104160:	c9                   	leave  
  104161:	c3                   	ret    

00104162 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104162:	55                   	push   %ebp
  104163:	89 e5                	mov    %esp,%ebp
  104165:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104168:	8b 45 14             	mov    0x14(%ebp),%eax
  10416b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10416e:	31 d0                	xor    %edx,%eax
  104170:	25 ff 0f 00 00       	and    $0xfff,%eax
  104175:	85 c0                	test   %eax,%eax
  104177:	74 24                	je     10419d <boot_map_segment+0x3b>
  104179:	c7 44 24 0c 4a 69 10 	movl   $0x10694a,0xc(%esp)
  104180:	00 
  104181:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104188:	00 
  104189:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  104190:	00 
  104191:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104198:	e8 2f cb ff ff       	call   100ccc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10419d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041a7:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041ac:	89 c2                	mov    %eax,%edx
  1041ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1041b1:	01 c2                	add    %eax,%edx
  1041b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041b6:	01 d0                	add    %edx,%eax
  1041b8:	83 e8 01             	sub    $0x1,%eax
  1041bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041c1:	ba 00 00 00 00       	mov    $0x0,%edx
  1041c6:	f7 75 f0             	divl   -0x10(%ebp)
  1041c9:	89 d0                	mov    %edx,%eax
  1041cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041ce:	29 c2                	sub    %eax,%edx
  1041d0:	89 d0                	mov    %edx,%eax
  1041d2:	c1 e8 0c             	shr    $0xc,%eax
  1041d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1041d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1041de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1041e6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1041e9:	8b 45 14             	mov    0x14(%ebp),%eax
  1041ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1041f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1041f7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1041fa:	eb 6b                	jmp    104267 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1041fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104203:	00 
  104204:	8b 45 0c             	mov    0xc(%ebp),%eax
  104207:	89 44 24 04          	mov    %eax,0x4(%esp)
  10420b:	8b 45 08             	mov    0x8(%ebp),%eax
  10420e:	89 04 24             	mov    %eax,(%esp)
  104211:	e8 cc 01 00 00       	call   1043e2 <get_pte>
  104216:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104219:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10421d:	75 24                	jne    104243 <boot_map_segment+0xe1>
  10421f:	c7 44 24 0c 76 69 10 	movl   $0x106976,0xc(%esp)
  104226:	00 
  104227:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  10422e:	00 
  10422f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104236:	00 
  104237:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10423e:	e8 89 ca ff ff       	call   100ccc <__panic>
        *ptep = pa | PTE_P | perm;
  104243:	8b 45 18             	mov    0x18(%ebp),%eax
  104246:	8b 55 14             	mov    0x14(%ebp),%edx
  104249:	09 d0                	or     %edx,%eax
  10424b:	83 c8 01             	or     $0x1,%eax
  10424e:	89 c2                	mov    %eax,%edx
  104250:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104253:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104255:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104259:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104260:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10426b:	75 8f                	jne    1041fc <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10426d:	c9                   	leave  
  10426e:	c3                   	ret    

0010426f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10426f:	55                   	push   %ebp
  104270:	89 e5                	mov    %esp,%ebp
  104272:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10427c:	e8 22 fa ff ff       	call   103ca3 <alloc_pages>
  104281:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104288:	75 1c                	jne    1042a6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10428a:	c7 44 24 08 83 69 10 	movl   $0x106983,0x8(%esp)
  104291:	00 
  104292:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104299:	00 
  10429a:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1042a1:	e8 26 ca ff ff       	call   100ccc <__panic>
    }
    return page2kva(p);
  1042a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042a9:	89 04 24             	mov    %eax,(%esp)
  1042ac:	e8 50 f7 ff ff       	call   103a01 <page2kva>
}
  1042b1:	c9                   	leave  
  1042b2:	c3                   	ret    

001042b3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042b3:	55                   	push   %ebp
  1042b4:	89 e5                	mov    %esp,%ebp
  1042b6:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042b9:	e8 93 f9 ff ff       	call   103c51 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042be:	e8 75 fa ff ff       	call   103d38 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042c3:	e8 d7 02 00 00       	call   10459f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042c8:	e8 a2 ff ff ff       	call   10426f <boot_alloc_page>
  1042cd:	a3 e4 88 11 00       	mov    %eax,0x1188e4
    memset(boot_pgdir, 0, PGSIZE);
  1042d2:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1042d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1042de:	00 
  1042df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1042e6:	00 
  1042e7:	89 04 24             	mov    %eax,(%esp)
  1042ea:	e8 14 19 00 00       	call   105c03 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1042ef:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1042f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1042f7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1042fe:	77 23                	ja     104323 <pmm_init+0x70>
  104300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104303:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104307:	c7 44 24 08 18 69 10 	movl   $0x106918,0x8(%esp)
  10430e:	00 
  10430f:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104316:	00 
  104317:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10431e:	e8 a9 c9 ff ff       	call   100ccc <__panic>
  104323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104326:	05 00 00 00 40       	add    $0x40000000,%eax
  10432b:	a3 80 89 11 00       	mov    %eax,0x118980

    check_pgdir();
  104330:	e8 88 02 00 00       	call   1045bd <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104335:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10433a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104340:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104345:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104348:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10434f:	77 23                	ja     104374 <pmm_init+0xc1>
  104351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104354:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104358:	c7 44 24 08 18 69 10 	movl   $0x106918,0x8(%esp)
  10435f:	00 
  104360:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104367:	00 
  104368:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10436f:	e8 58 c9 ff ff       	call   100ccc <__panic>
  104374:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104377:	05 00 00 00 40       	add    $0x40000000,%eax
  10437c:	83 c8 03             	or     $0x3,%eax
  10437f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104381:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104386:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10438d:	00 
  10438e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104395:	00 
  104396:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10439d:	38 
  10439e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043a5:	c0 
  1043a6:	89 04 24             	mov    %eax,(%esp)
  1043a9:	e8 b4 fd ff ff       	call   104162 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043ae:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1043b3:	8b 15 e4 88 11 00    	mov    0x1188e4,%edx
  1043b9:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043bf:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043c1:	e8 63 fd ff ff       	call   104129 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043c6:	e8 97 f7 ff ff       	call   103b62 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043cb:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1043d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043d6:	e8 7d 08 00 00       	call   104c58 <check_boot_pgdir>

    print_pgdir();
  1043db:	e8 05 0d 00 00       	call   1050e5 <print_pgdir>

}
  1043e0:	c9                   	leave  
  1043e1:	c3                   	ret    

001043e2 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043e2:	55                   	push   %ebp
  1043e3:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1043e5:	5d                   	pop    %ebp
  1043e6:	c3                   	ret    

001043e7 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1043e7:	55                   	push   %ebp
  1043e8:	89 e5                	mov    %esp,%ebp
  1043ea:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1043ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1043f4:	00 
  1043f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1043ff:	89 04 24             	mov    %eax,(%esp)
  104402:	e8 db ff ff ff       	call   1043e2 <get_pte>
  104407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10440a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10440e:	74 08                	je     104418 <get_page+0x31>
        *ptep_store = ptep;
  104410:	8b 45 10             	mov    0x10(%ebp),%eax
  104413:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104416:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10441c:	74 1b                	je     104439 <get_page+0x52>
  10441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104421:	8b 00                	mov    (%eax),%eax
  104423:	83 e0 01             	and    $0x1,%eax
  104426:	85 c0                	test   %eax,%eax
  104428:	74 0f                	je     104439 <get_page+0x52>
        return pte2page(*ptep);
  10442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10442d:	8b 00                	mov    (%eax),%eax
  10442f:	89 04 24             	mov    %eax,(%esp)
  104432:	e8 1e f6 ff ff       	call   103a55 <pte2page>
  104437:	eb 05                	jmp    10443e <get_page+0x57>
    }
    return NULL;
  104439:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10443e:	c9                   	leave  
  10443f:	c3                   	ret    

00104440 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104440:	55                   	push   %ebp
  104441:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  104443:	5d                   	pop    %ebp
  104444:	c3                   	ret    

00104445 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104445:	55                   	push   %ebp
  104446:	89 e5                	mov    %esp,%ebp
  104448:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10444b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104452:	00 
  104453:	8b 45 0c             	mov    0xc(%ebp),%eax
  104456:	89 44 24 04          	mov    %eax,0x4(%esp)
  10445a:	8b 45 08             	mov    0x8(%ebp),%eax
  10445d:	89 04 24             	mov    %eax,(%esp)
  104460:	e8 7d ff ff ff       	call   1043e2 <get_pte>
  104465:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104468:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10446c:	74 19                	je     104487 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10446e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104471:	89 44 24 08          	mov    %eax,0x8(%esp)
  104475:	8b 45 0c             	mov    0xc(%ebp),%eax
  104478:	89 44 24 04          	mov    %eax,0x4(%esp)
  10447c:	8b 45 08             	mov    0x8(%ebp),%eax
  10447f:	89 04 24             	mov    %eax,(%esp)
  104482:	e8 b9 ff ff ff       	call   104440 <page_remove_pte>
    }
}
  104487:	c9                   	leave  
  104488:	c3                   	ret    

00104489 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104489:	55                   	push   %ebp
  10448a:	89 e5                	mov    %esp,%ebp
  10448c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10448f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104496:	00 
  104497:	8b 45 10             	mov    0x10(%ebp),%eax
  10449a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10449e:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a1:	89 04 24             	mov    %eax,(%esp)
  1044a4:	e8 39 ff ff ff       	call   1043e2 <get_pte>
  1044a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1044ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b0:	75 0a                	jne    1044bc <page_insert+0x33>
        return -E_NO_MEM;
  1044b2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1044b7:	e9 84 00 00 00       	jmp    104540 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1044bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044bf:	89 04 24             	mov    %eax,(%esp)
  1044c2:	e8 ee f5 ff ff       	call   103ab5 <page_ref_inc>
    if (*ptep & PTE_P) {
  1044c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ca:	8b 00                	mov    (%eax),%eax
  1044cc:	83 e0 01             	and    $0x1,%eax
  1044cf:	85 c0                	test   %eax,%eax
  1044d1:	74 3e                	je     104511 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d6:	8b 00                	mov    (%eax),%eax
  1044d8:	89 04 24             	mov    %eax,(%esp)
  1044db:	e8 75 f5 ff ff       	call   103a55 <pte2page>
  1044e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1044e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1044e9:	75 0d                	jne    1044f8 <page_insert+0x6f>
            page_ref_dec(page);
  1044eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044ee:	89 04 24             	mov    %eax,(%esp)
  1044f1:	e8 d6 f5 ff ff       	call   103acc <page_ref_dec>
  1044f6:	eb 19                	jmp    104511 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1044f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044ff:	8b 45 10             	mov    0x10(%ebp),%eax
  104502:	89 44 24 04          	mov    %eax,0x4(%esp)
  104506:	8b 45 08             	mov    0x8(%ebp),%eax
  104509:	89 04 24             	mov    %eax,(%esp)
  10450c:	e8 2f ff ff ff       	call   104440 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104511:	8b 45 0c             	mov    0xc(%ebp),%eax
  104514:	89 04 24             	mov    %eax,(%esp)
  104517:	e8 80 f4 ff ff       	call   10399c <page2pa>
  10451c:	0b 45 14             	or     0x14(%ebp),%eax
  10451f:	83 c8 01             	or     $0x1,%eax
  104522:	89 c2                	mov    %eax,%edx
  104524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104527:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104529:	8b 45 10             	mov    0x10(%ebp),%eax
  10452c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104530:	8b 45 08             	mov    0x8(%ebp),%eax
  104533:	89 04 24             	mov    %eax,(%esp)
  104536:	e8 07 00 00 00       	call   104542 <tlb_invalidate>
    return 0;
  10453b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104540:	c9                   	leave  
  104541:	c3                   	ret    

00104542 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104542:	55                   	push   %ebp
  104543:	89 e5                	mov    %esp,%ebp
  104545:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104548:	0f 20 d8             	mov    %cr3,%eax
  10454b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10454e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104551:	89 c2                	mov    %eax,%edx
  104553:	8b 45 08             	mov    0x8(%ebp),%eax
  104556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104559:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104560:	77 23                	ja     104585 <tlb_invalidate+0x43>
  104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104565:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104569:	c7 44 24 08 18 69 10 	movl   $0x106918,0x8(%esp)
  104570:	00 
  104571:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  104578:	00 
  104579:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104580:	e8 47 c7 ff ff       	call   100ccc <__panic>
  104585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104588:	05 00 00 00 40       	add    $0x40000000,%eax
  10458d:	39 c2                	cmp    %eax,%edx
  10458f:	75 0c                	jne    10459d <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104591:	8b 45 0c             	mov    0xc(%ebp),%eax
  104594:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104597:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10459a:	0f 01 38             	invlpg (%eax)
    }
}
  10459d:	c9                   	leave  
  10459e:	c3                   	ret    

0010459f <check_alloc_page>:

static void
check_alloc_page(void) {
  10459f:	55                   	push   %ebp
  1045a0:	89 e5                	mov    %esp,%ebp
  1045a2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1045a5:	a1 7c 89 11 00       	mov    0x11897c,%eax
  1045aa:	8b 40 18             	mov    0x18(%eax),%eax
  1045ad:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1045af:	c7 04 24 9c 69 10 00 	movl   $0x10699c,(%esp)
  1045b6:	e8 81 bd ff ff       	call   10033c <cprintf>
}
  1045bb:	c9                   	leave  
  1045bc:	c3                   	ret    

001045bd <check_pgdir>:

static void
check_pgdir(void) {
  1045bd:	55                   	push   %ebp
  1045be:	89 e5                	mov    %esp,%ebp
  1045c0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1045c3:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  1045c8:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1045cd:	76 24                	jbe    1045f3 <check_pgdir+0x36>
  1045cf:	c7 44 24 0c bb 69 10 	movl   $0x1069bb,0xc(%esp)
  1045d6:	00 
  1045d7:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  1045de:	00 
  1045df:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1045e6:	00 
  1045e7:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1045ee:	e8 d9 c6 ff ff       	call   100ccc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1045f3:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1045f8:	85 c0                	test   %eax,%eax
  1045fa:	74 0e                	je     10460a <check_pgdir+0x4d>
  1045fc:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104601:	25 ff 0f 00 00       	and    $0xfff,%eax
  104606:	85 c0                	test   %eax,%eax
  104608:	74 24                	je     10462e <check_pgdir+0x71>
  10460a:	c7 44 24 0c d8 69 10 	movl   $0x1069d8,0xc(%esp)
  104611:	00 
  104612:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104619:	00 
  10461a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104621:	00 
  104622:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104629:	e8 9e c6 ff ff       	call   100ccc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10462e:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104633:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10463a:	00 
  10463b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104642:	00 
  104643:	89 04 24             	mov    %eax,(%esp)
  104646:	e8 9c fd ff ff       	call   1043e7 <get_page>
  10464b:	85 c0                	test   %eax,%eax
  10464d:	74 24                	je     104673 <check_pgdir+0xb6>
  10464f:	c7 44 24 0c 10 6a 10 	movl   $0x106a10,0xc(%esp)
  104656:	00 
  104657:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  10465e:	00 
  10465f:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  104666:	00 
  104667:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10466e:	e8 59 c6 ff ff       	call   100ccc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10467a:	e8 24 f6 ff ff       	call   103ca3 <alloc_pages>
  10467f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104682:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104687:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10468e:	00 
  10468f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104696:	00 
  104697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10469a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10469e:	89 04 24             	mov    %eax,(%esp)
  1046a1:	e8 e3 fd ff ff       	call   104489 <page_insert>
  1046a6:	85 c0                	test   %eax,%eax
  1046a8:	74 24                	je     1046ce <check_pgdir+0x111>
  1046aa:	c7 44 24 0c 38 6a 10 	movl   $0x106a38,0xc(%esp)
  1046b1:	00 
  1046b2:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  1046b9:	00 
  1046ba:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  1046c1:	00 
  1046c2:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1046c9:	e8 fe c5 ff ff       	call   100ccc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1046ce:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1046d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046da:	00 
  1046db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046e2:	00 
  1046e3:	89 04 24             	mov    %eax,(%esp)
  1046e6:	e8 f7 fc ff ff       	call   1043e2 <get_pte>
  1046eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1046f2:	75 24                	jne    104718 <check_pgdir+0x15b>
  1046f4:	c7 44 24 0c 64 6a 10 	movl   $0x106a64,0xc(%esp)
  1046fb:	00 
  1046fc:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104703:	00 
  104704:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  10470b:	00 
  10470c:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104713:	e8 b4 c5 ff ff       	call   100ccc <__panic>
    assert(pte2page(*ptep) == p1);
  104718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10471b:	8b 00                	mov    (%eax),%eax
  10471d:	89 04 24             	mov    %eax,(%esp)
  104720:	e8 30 f3 ff ff       	call   103a55 <pte2page>
  104725:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104728:	74 24                	je     10474e <check_pgdir+0x191>
  10472a:	c7 44 24 0c 91 6a 10 	movl   $0x106a91,0xc(%esp)
  104731:	00 
  104732:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104739:	00 
  10473a:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  104741:	00 
  104742:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104749:	e8 7e c5 ff ff       	call   100ccc <__panic>
    assert(page_ref(p1) == 1);
  10474e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104751:	89 04 24             	mov    %eax,(%esp)
  104754:	e8 52 f3 ff ff       	call   103aab <page_ref>
  104759:	83 f8 01             	cmp    $0x1,%eax
  10475c:	74 24                	je     104782 <check_pgdir+0x1c5>
  10475e:	c7 44 24 0c a7 6a 10 	movl   $0x106aa7,0xc(%esp)
  104765:	00 
  104766:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  10476d:	00 
  10476e:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104775:	00 
  104776:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10477d:	e8 4a c5 ff ff       	call   100ccc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104782:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104787:	8b 00                	mov    (%eax),%eax
  104789:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10478e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104794:	c1 e8 0c             	shr    $0xc,%eax
  104797:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10479a:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  10479f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1047a2:	72 23                	jb     1047c7 <check_pgdir+0x20a>
  1047a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047ab:	c7 44 24 08 74 68 10 	movl   $0x106874,0x8(%esp)
  1047b2:	00 
  1047b3:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  1047ba:	00 
  1047bb:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1047c2:	e8 05 c5 ff ff       	call   100ccc <__panic>
  1047c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047ca:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1047cf:	83 c0 04             	add    $0x4,%eax
  1047d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1047d5:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  1047da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047e1:	00 
  1047e2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1047e9:	00 
  1047ea:	89 04 24             	mov    %eax,(%esp)
  1047ed:	e8 f0 fb ff ff       	call   1043e2 <get_pte>
  1047f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1047f5:	74 24                	je     10481b <check_pgdir+0x25e>
  1047f7:	c7 44 24 0c bc 6a 10 	movl   $0x106abc,0xc(%esp)
  1047fe:	00 
  1047ff:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104806:	00 
  104807:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  10480e:	00 
  10480f:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104816:	e8 b1 c4 ff ff       	call   100ccc <__panic>

    p2 = alloc_page();
  10481b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104822:	e8 7c f4 ff ff       	call   103ca3 <alloc_pages>
  104827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10482a:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10482f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104836:	00 
  104837:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10483e:	00 
  10483f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104842:	89 54 24 04          	mov    %edx,0x4(%esp)
  104846:	89 04 24             	mov    %eax,(%esp)
  104849:	e8 3b fc ff ff       	call   104489 <page_insert>
  10484e:	85 c0                	test   %eax,%eax
  104850:	74 24                	je     104876 <check_pgdir+0x2b9>
  104852:	c7 44 24 0c e4 6a 10 	movl   $0x106ae4,0xc(%esp)
  104859:	00 
  10485a:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104861:	00 
  104862:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104869:	00 
  10486a:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104871:	e8 56 c4 ff ff       	call   100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104876:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10487b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104882:	00 
  104883:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10488a:	00 
  10488b:	89 04 24             	mov    %eax,(%esp)
  10488e:	e8 4f fb ff ff       	call   1043e2 <get_pte>
  104893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104896:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10489a:	75 24                	jne    1048c0 <check_pgdir+0x303>
  10489c:	c7 44 24 0c 1c 6b 10 	movl   $0x106b1c,0xc(%esp)
  1048a3:	00 
  1048a4:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  1048ab:	00 
  1048ac:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1048b3:	00 
  1048b4:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1048bb:	e8 0c c4 ff ff       	call   100ccc <__panic>
    assert(*ptep & PTE_U);
  1048c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048c3:	8b 00                	mov    (%eax),%eax
  1048c5:	83 e0 04             	and    $0x4,%eax
  1048c8:	85 c0                	test   %eax,%eax
  1048ca:	75 24                	jne    1048f0 <check_pgdir+0x333>
  1048cc:	c7 44 24 0c 4c 6b 10 	movl   $0x106b4c,0xc(%esp)
  1048d3:	00 
  1048d4:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  1048db:	00 
  1048dc:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1048e3:	00 
  1048e4:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1048eb:	e8 dc c3 ff ff       	call   100ccc <__panic>
    assert(*ptep & PTE_W);
  1048f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048f3:	8b 00                	mov    (%eax),%eax
  1048f5:	83 e0 02             	and    $0x2,%eax
  1048f8:	85 c0                	test   %eax,%eax
  1048fa:	75 24                	jne    104920 <check_pgdir+0x363>
  1048fc:	c7 44 24 0c 5a 6b 10 	movl   $0x106b5a,0xc(%esp)
  104903:	00 
  104904:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  10490b:	00 
  10490c:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104913:	00 
  104914:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10491b:	e8 ac c3 ff ff       	call   100ccc <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104920:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104925:	8b 00                	mov    (%eax),%eax
  104927:	83 e0 04             	and    $0x4,%eax
  10492a:	85 c0                	test   %eax,%eax
  10492c:	75 24                	jne    104952 <check_pgdir+0x395>
  10492e:	c7 44 24 0c 68 6b 10 	movl   $0x106b68,0xc(%esp)
  104935:	00 
  104936:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  10493d:	00 
  10493e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104945:	00 
  104946:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  10494d:	e8 7a c3 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 1);
  104952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104955:	89 04 24             	mov    %eax,(%esp)
  104958:	e8 4e f1 ff ff       	call   103aab <page_ref>
  10495d:	83 f8 01             	cmp    $0x1,%eax
  104960:	74 24                	je     104986 <check_pgdir+0x3c9>
  104962:	c7 44 24 0c 7e 6b 10 	movl   $0x106b7e,0xc(%esp)
  104969:	00 
  10496a:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104971:	00 
  104972:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104979:	00 
  10497a:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104981:	e8 46 c3 ff ff       	call   100ccc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104986:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  10498b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104992:	00 
  104993:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10499a:	00 
  10499b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10499e:	89 54 24 04          	mov    %edx,0x4(%esp)
  1049a2:	89 04 24             	mov    %eax,(%esp)
  1049a5:	e8 df fa ff ff       	call   104489 <page_insert>
  1049aa:	85 c0                	test   %eax,%eax
  1049ac:	74 24                	je     1049d2 <check_pgdir+0x415>
  1049ae:	c7 44 24 0c 90 6b 10 	movl   $0x106b90,0xc(%esp)
  1049b5:	00 
  1049b6:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  1049bd:	00 
  1049be:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1049c5:	00 
  1049c6:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  1049cd:	e8 fa c2 ff ff       	call   100ccc <__panic>
    assert(page_ref(p1) == 2);
  1049d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d5:	89 04 24             	mov    %eax,(%esp)
  1049d8:	e8 ce f0 ff ff       	call   103aab <page_ref>
  1049dd:	83 f8 02             	cmp    $0x2,%eax
  1049e0:	74 24                	je     104a06 <check_pgdir+0x449>
  1049e2:	c7 44 24 0c bc 6b 10 	movl   $0x106bbc,0xc(%esp)
  1049e9:	00 
  1049ea:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  1049f1:	00 
  1049f2:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1049f9:	00 
  1049fa:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104a01:	e8 c6 c2 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a09:	89 04 24             	mov    %eax,(%esp)
  104a0c:	e8 9a f0 ff ff       	call   103aab <page_ref>
  104a11:	85 c0                	test   %eax,%eax
  104a13:	74 24                	je     104a39 <check_pgdir+0x47c>
  104a15:	c7 44 24 0c ce 6b 10 	movl   $0x106bce,0xc(%esp)
  104a1c:	00 
  104a1d:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104a24:	00 
  104a25:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104a2c:	00 
  104a2d:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104a34:	e8 93 c2 ff ff       	call   100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a39:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104a3e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a45:	00 
  104a46:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a4d:	00 
  104a4e:	89 04 24             	mov    %eax,(%esp)
  104a51:	e8 8c f9 ff ff       	call   1043e2 <get_pte>
  104a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a5d:	75 24                	jne    104a83 <check_pgdir+0x4c6>
  104a5f:	c7 44 24 0c 1c 6b 10 	movl   $0x106b1c,0xc(%esp)
  104a66:	00 
  104a67:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104a6e:	00 
  104a6f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104a76:	00 
  104a77:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104a7e:	e8 49 c2 ff ff       	call   100ccc <__panic>
    assert(pte2page(*ptep) == p1);
  104a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a86:	8b 00                	mov    (%eax),%eax
  104a88:	89 04 24             	mov    %eax,(%esp)
  104a8b:	e8 c5 ef ff ff       	call   103a55 <pte2page>
  104a90:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a93:	74 24                	je     104ab9 <check_pgdir+0x4fc>
  104a95:	c7 44 24 0c 91 6a 10 	movl   $0x106a91,0xc(%esp)
  104a9c:	00 
  104a9d:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104aa4:	00 
  104aa5:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  104aac:	00 
  104aad:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104ab4:	e8 13 c2 ff ff       	call   100ccc <__panic>
    assert((*ptep & PTE_U) == 0);
  104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104abc:	8b 00                	mov    (%eax),%eax
  104abe:	83 e0 04             	and    $0x4,%eax
  104ac1:	85 c0                	test   %eax,%eax
  104ac3:	74 24                	je     104ae9 <check_pgdir+0x52c>
  104ac5:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  104acc:	00 
  104acd:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104ad4:	00 
  104ad5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104adc:	00 
  104add:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104ae4:	e8 e3 c1 ff ff       	call   100ccc <__panic>

    page_remove(boot_pgdir, 0x0);
  104ae9:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104aee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104af5:	00 
  104af6:	89 04 24             	mov    %eax,(%esp)
  104af9:	e8 47 f9 ff ff       	call   104445 <page_remove>
    assert(page_ref(p1) == 1);
  104afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b01:	89 04 24             	mov    %eax,(%esp)
  104b04:	e8 a2 ef ff ff       	call   103aab <page_ref>
  104b09:	83 f8 01             	cmp    $0x1,%eax
  104b0c:	74 24                	je     104b32 <check_pgdir+0x575>
  104b0e:	c7 44 24 0c a7 6a 10 	movl   $0x106aa7,0xc(%esp)
  104b15:	00 
  104b16:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104b1d:	00 
  104b1e:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104b25:	00 
  104b26:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104b2d:	e8 9a c1 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b35:	89 04 24             	mov    %eax,(%esp)
  104b38:	e8 6e ef ff ff       	call   103aab <page_ref>
  104b3d:	85 c0                	test   %eax,%eax
  104b3f:	74 24                	je     104b65 <check_pgdir+0x5a8>
  104b41:	c7 44 24 0c ce 6b 10 	movl   $0x106bce,0xc(%esp)
  104b48:	00 
  104b49:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104b50:	00 
  104b51:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104b58:	00 
  104b59:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104b60:	e8 67 c1 ff ff       	call   100ccc <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104b65:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104b6a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b71:	00 
  104b72:	89 04 24             	mov    %eax,(%esp)
  104b75:	e8 cb f8 ff ff       	call   104445 <page_remove>
    assert(page_ref(p1) == 0);
  104b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b7d:	89 04 24             	mov    %eax,(%esp)
  104b80:	e8 26 ef ff ff       	call   103aab <page_ref>
  104b85:	85 c0                	test   %eax,%eax
  104b87:	74 24                	je     104bad <check_pgdir+0x5f0>
  104b89:	c7 44 24 0c f5 6b 10 	movl   $0x106bf5,0xc(%esp)
  104b90:	00 
  104b91:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104b98:	00 
  104b99:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104ba0:	00 
  104ba1:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104ba8:	e8 1f c1 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bb0:	89 04 24             	mov    %eax,(%esp)
  104bb3:	e8 f3 ee ff ff       	call   103aab <page_ref>
  104bb8:	85 c0                	test   %eax,%eax
  104bba:	74 24                	je     104be0 <check_pgdir+0x623>
  104bbc:	c7 44 24 0c ce 6b 10 	movl   $0x106bce,0xc(%esp)
  104bc3:	00 
  104bc4:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104bcb:	00 
  104bcc:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104bd3:	00 
  104bd4:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104bdb:	e8 ec c0 ff ff       	call   100ccc <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104be0:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104be5:	8b 00                	mov    (%eax),%eax
  104be7:	89 04 24             	mov    %eax,(%esp)
  104bea:	e8 a4 ee ff ff       	call   103a93 <pde2page>
  104bef:	89 04 24             	mov    %eax,(%esp)
  104bf2:	e8 b4 ee ff ff       	call   103aab <page_ref>
  104bf7:	83 f8 01             	cmp    $0x1,%eax
  104bfa:	74 24                	je     104c20 <check_pgdir+0x663>
  104bfc:	c7 44 24 0c 08 6c 10 	movl   $0x106c08,0xc(%esp)
  104c03:	00 
  104c04:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104c0b:	00 
  104c0c:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104c13:	00 
  104c14:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104c1b:	e8 ac c0 ff ff       	call   100ccc <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104c20:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c25:	8b 00                	mov    (%eax),%eax
  104c27:	89 04 24             	mov    %eax,(%esp)
  104c2a:	e8 64 ee ff ff       	call   103a93 <pde2page>
  104c2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c36:	00 
  104c37:	89 04 24             	mov    %eax,(%esp)
  104c3a:	e8 9c f0 ff ff       	call   103cdb <free_pages>
    boot_pgdir[0] = 0;
  104c3f:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104c4a:	c7 04 24 2f 6c 10 00 	movl   $0x106c2f,(%esp)
  104c51:	e8 e6 b6 ff ff       	call   10033c <cprintf>
}
  104c56:	c9                   	leave  
  104c57:	c3                   	ret    

00104c58 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104c58:	55                   	push   %ebp
  104c59:	89 e5                	mov    %esp,%ebp
  104c5b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104c65:	e9 ca 00 00 00       	jmp    104d34 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c73:	c1 e8 0c             	shr    $0xc,%eax
  104c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c79:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104c7e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104c81:	72 23                	jb     104ca6 <check_boot_pgdir+0x4e>
  104c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c86:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104c8a:	c7 44 24 08 74 68 10 	movl   $0x106874,0x8(%esp)
  104c91:	00 
  104c92:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104c99:	00 
  104c9a:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104ca1:	e8 26 c0 ff ff       	call   100ccc <__panic>
  104ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ca9:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104cae:	89 c2                	mov    %eax,%edx
  104cb0:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104cb5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cbc:	00 
  104cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cc1:	89 04 24             	mov    %eax,(%esp)
  104cc4:	e8 19 f7 ff ff       	call   1043e2 <get_pte>
  104cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104cd0:	75 24                	jne    104cf6 <check_boot_pgdir+0x9e>
  104cd2:	c7 44 24 0c 4c 6c 10 	movl   $0x106c4c,0xc(%esp)
  104cd9:	00 
  104cda:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104ce1:	00 
  104ce2:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104ce9:	00 
  104cea:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104cf1:	e8 d6 bf ff ff       	call   100ccc <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104cf9:	8b 00                	mov    (%eax),%eax
  104cfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d00:	89 c2                	mov    %eax,%edx
  104d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d05:	39 c2                	cmp    %eax,%edx
  104d07:	74 24                	je     104d2d <check_boot_pgdir+0xd5>
  104d09:	c7 44 24 0c 89 6c 10 	movl   $0x106c89,0xc(%esp)
  104d10:	00 
  104d11:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104d18:	00 
  104d19:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104d20:	00 
  104d21:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104d28:	e8 9f bf ff ff       	call   100ccc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d2d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d37:	a1 e0 88 11 00       	mov    0x1188e0,%eax
  104d3c:	39 c2                	cmp    %eax,%edx
  104d3e:	0f 82 26 ff ff ff    	jb     104c6a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104d44:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104d49:	05 ac 0f 00 00       	add    $0xfac,%eax
  104d4e:	8b 00                	mov    (%eax),%eax
  104d50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d55:	89 c2                	mov    %eax,%edx
  104d57:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104d5f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104d66:	77 23                	ja     104d8b <check_boot_pgdir+0x133>
  104d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d6f:	c7 44 24 08 18 69 10 	movl   $0x106918,0x8(%esp)
  104d76:	00 
  104d77:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104d7e:	00 
  104d7f:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104d86:	e8 41 bf ff ff       	call   100ccc <__panic>
  104d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d8e:	05 00 00 00 40       	add    $0x40000000,%eax
  104d93:	39 c2                	cmp    %eax,%edx
  104d95:	74 24                	je     104dbb <check_boot_pgdir+0x163>
  104d97:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  104d9e:	00 
  104d9f:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104da6:	00 
  104da7:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104dae:	00 
  104daf:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104db6:	e8 11 bf ff ff       	call   100ccc <__panic>

    assert(boot_pgdir[0] == 0);
  104dbb:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104dc0:	8b 00                	mov    (%eax),%eax
  104dc2:	85 c0                	test   %eax,%eax
  104dc4:	74 24                	je     104dea <check_boot_pgdir+0x192>
  104dc6:	c7 44 24 0c d4 6c 10 	movl   $0x106cd4,0xc(%esp)
  104dcd:	00 
  104dce:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104dd5:	00 
  104dd6:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104ddd:	00 
  104dde:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104de5:	e8 e2 be ff ff       	call   100ccc <__panic>

    struct Page *p;
    p = alloc_page();
  104dea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104df1:	e8 ad ee ff ff       	call   103ca3 <alloc_pages>
  104df6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104df9:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104dfe:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e05:	00 
  104e06:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104e0d:	00 
  104e0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e11:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e15:	89 04 24             	mov    %eax,(%esp)
  104e18:	e8 6c f6 ff ff       	call   104489 <page_insert>
  104e1d:	85 c0                	test   %eax,%eax
  104e1f:	74 24                	je     104e45 <check_boot_pgdir+0x1ed>
  104e21:	c7 44 24 0c e8 6c 10 	movl   $0x106ce8,0xc(%esp)
  104e28:	00 
  104e29:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104e30:	00 
  104e31:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104e38:	00 
  104e39:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104e40:	e8 87 be ff ff       	call   100ccc <__panic>
    assert(page_ref(p) == 1);
  104e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e48:	89 04 24             	mov    %eax,(%esp)
  104e4b:	e8 5b ec ff ff       	call   103aab <page_ref>
  104e50:	83 f8 01             	cmp    $0x1,%eax
  104e53:	74 24                	je     104e79 <check_boot_pgdir+0x221>
  104e55:	c7 44 24 0c 16 6d 10 	movl   $0x106d16,0xc(%esp)
  104e5c:	00 
  104e5d:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104e64:	00 
  104e65:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104e6c:	00 
  104e6d:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104e74:	e8 53 be ff ff       	call   100ccc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104e79:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104e7e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e85:	00 
  104e86:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104e8d:	00 
  104e8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e91:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e95:	89 04 24             	mov    %eax,(%esp)
  104e98:	e8 ec f5 ff ff       	call   104489 <page_insert>
  104e9d:	85 c0                	test   %eax,%eax
  104e9f:	74 24                	je     104ec5 <check_boot_pgdir+0x26d>
  104ea1:	c7 44 24 0c 28 6d 10 	movl   $0x106d28,0xc(%esp)
  104ea8:	00 
  104ea9:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104eb0:	00 
  104eb1:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104eb8:	00 
  104eb9:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104ec0:	e8 07 be ff ff       	call   100ccc <__panic>
    assert(page_ref(p) == 2);
  104ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ec8:	89 04 24             	mov    %eax,(%esp)
  104ecb:	e8 db eb ff ff       	call   103aab <page_ref>
  104ed0:	83 f8 02             	cmp    $0x2,%eax
  104ed3:	74 24                	je     104ef9 <check_boot_pgdir+0x2a1>
  104ed5:	c7 44 24 0c 5f 6d 10 	movl   $0x106d5f,0xc(%esp)
  104edc:	00 
  104edd:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104ee4:	00 
  104ee5:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104eec:	00 
  104eed:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104ef4:	e8 d3 bd ff ff       	call   100ccc <__panic>

    const char *str = "ucore: Hello world!!";
  104ef9:	c7 45 dc 70 6d 10 00 	movl   $0x106d70,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f03:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f07:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f0e:	e8 19 0a 00 00       	call   10592c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104f13:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104f1a:	00 
  104f1b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f22:	e8 7e 0a 00 00       	call   1059a5 <strcmp>
  104f27:	85 c0                	test   %eax,%eax
  104f29:	74 24                	je     104f4f <check_boot_pgdir+0x2f7>
  104f2b:	c7 44 24 0c 88 6d 10 	movl   $0x106d88,0xc(%esp)
  104f32:	00 
  104f33:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104f3a:	00 
  104f3b:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104f42:	00 
  104f43:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104f4a:	e8 7d bd ff ff       	call   100ccc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f52:	89 04 24             	mov    %eax,(%esp)
  104f55:	e8 a7 ea ff ff       	call   103a01 <page2kva>
  104f5a:	05 00 01 00 00       	add    $0x100,%eax
  104f5f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104f62:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f69:	e8 66 09 00 00       	call   1058d4 <strlen>
  104f6e:	85 c0                	test   %eax,%eax
  104f70:	74 24                	je     104f96 <check_boot_pgdir+0x33e>
  104f72:	c7 44 24 0c c0 6d 10 	movl   $0x106dc0,0xc(%esp)
  104f79:	00 
  104f7a:	c7 44 24 08 61 69 10 	movl   $0x106961,0x8(%esp)
  104f81:	00 
  104f82:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104f89:	00 
  104f8a:	c7 04 24 3c 69 10 00 	movl   $0x10693c,(%esp)
  104f91:	e8 36 bd ff ff       	call   100ccc <__panic>

    free_page(p);
  104f96:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f9d:	00 
  104f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fa1:	89 04 24             	mov    %eax,(%esp)
  104fa4:	e8 32 ed ff ff       	call   103cdb <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104fa9:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104fae:	8b 00                	mov    (%eax),%eax
  104fb0:	89 04 24             	mov    %eax,(%esp)
  104fb3:	e8 db ea ff ff       	call   103a93 <pde2page>
  104fb8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fbf:	00 
  104fc0:	89 04 24             	mov    %eax,(%esp)
  104fc3:	e8 13 ed ff ff       	call   103cdb <free_pages>
    boot_pgdir[0] = 0;
  104fc8:	a1 e4 88 11 00       	mov    0x1188e4,%eax
  104fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104fd3:	c7 04 24 e4 6d 10 00 	movl   $0x106de4,(%esp)
  104fda:	e8 5d b3 ff ff       	call   10033c <cprintf>
}
  104fdf:	c9                   	leave  
  104fe0:	c3                   	ret    

00104fe1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104fe1:	55                   	push   %ebp
  104fe2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  104fe7:	83 e0 04             	and    $0x4,%eax
  104fea:	85 c0                	test   %eax,%eax
  104fec:	74 07                	je     104ff5 <perm2str+0x14>
  104fee:	b8 75 00 00 00       	mov    $0x75,%eax
  104ff3:	eb 05                	jmp    104ffa <perm2str+0x19>
  104ff5:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104ffa:	a2 68 89 11 00       	mov    %al,0x118968
    str[1] = 'r';
  104fff:	c6 05 69 89 11 00 72 	movb   $0x72,0x118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105006:	8b 45 08             	mov    0x8(%ebp),%eax
  105009:	83 e0 02             	and    $0x2,%eax
  10500c:	85 c0                	test   %eax,%eax
  10500e:	74 07                	je     105017 <perm2str+0x36>
  105010:	b8 77 00 00 00       	mov    $0x77,%eax
  105015:	eb 05                	jmp    10501c <perm2str+0x3b>
  105017:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10501c:	a2 6a 89 11 00       	mov    %al,0x11896a
    str[3] = '\0';
  105021:	c6 05 6b 89 11 00 00 	movb   $0x0,0x11896b
    return str;
  105028:	b8 68 89 11 00       	mov    $0x118968,%eax
}
  10502d:	5d                   	pop    %ebp
  10502e:	c3                   	ret    

0010502f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10502f:	55                   	push   %ebp
  105030:	89 e5                	mov    %esp,%ebp
  105032:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105035:	8b 45 10             	mov    0x10(%ebp),%eax
  105038:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10503b:	72 0a                	jb     105047 <get_pgtable_items+0x18>
        return 0;
  10503d:	b8 00 00 00 00       	mov    $0x0,%eax
  105042:	e9 9c 00 00 00       	jmp    1050e3 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105047:	eb 04                	jmp    10504d <get_pgtable_items+0x1e>
        start ++;
  105049:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10504d:	8b 45 10             	mov    0x10(%ebp),%eax
  105050:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105053:	73 18                	jae    10506d <get_pgtable_items+0x3e>
  105055:	8b 45 10             	mov    0x10(%ebp),%eax
  105058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10505f:	8b 45 14             	mov    0x14(%ebp),%eax
  105062:	01 d0                	add    %edx,%eax
  105064:	8b 00                	mov    (%eax),%eax
  105066:	83 e0 01             	and    $0x1,%eax
  105069:	85 c0                	test   %eax,%eax
  10506b:	74 dc                	je     105049 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10506d:	8b 45 10             	mov    0x10(%ebp),%eax
  105070:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105073:	73 69                	jae    1050de <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105075:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105079:	74 08                	je     105083 <get_pgtable_items+0x54>
            *left_store = start;
  10507b:	8b 45 18             	mov    0x18(%ebp),%eax
  10507e:	8b 55 10             	mov    0x10(%ebp),%edx
  105081:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105083:	8b 45 10             	mov    0x10(%ebp),%eax
  105086:	8d 50 01             	lea    0x1(%eax),%edx
  105089:	89 55 10             	mov    %edx,0x10(%ebp)
  10508c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105093:	8b 45 14             	mov    0x14(%ebp),%eax
  105096:	01 d0                	add    %edx,%eax
  105098:	8b 00                	mov    (%eax),%eax
  10509a:	83 e0 07             	and    $0x7,%eax
  10509d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1050a0:	eb 04                	jmp    1050a6 <get_pgtable_items+0x77>
            start ++;
  1050a2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1050a6:	8b 45 10             	mov    0x10(%ebp),%eax
  1050a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050ac:	73 1d                	jae    1050cb <get_pgtable_items+0x9c>
  1050ae:	8b 45 10             	mov    0x10(%ebp),%eax
  1050b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050b8:	8b 45 14             	mov    0x14(%ebp),%eax
  1050bb:	01 d0                	add    %edx,%eax
  1050bd:	8b 00                	mov    (%eax),%eax
  1050bf:	83 e0 07             	and    $0x7,%eax
  1050c2:	89 c2                	mov    %eax,%edx
  1050c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050c7:	39 c2                	cmp    %eax,%edx
  1050c9:	74 d7                	je     1050a2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1050cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1050cf:	74 08                	je     1050d9 <get_pgtable_items+0xaa>
            *right_store = start;
  1050d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1050d4:	8b 55 10             	mov    0x10(%ebp),%edx
  1050d7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1050d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050dc:	eb 05                	jmp    1050e3 <get_pgtable_items+0xb4>
    }
    return 0;
  1050de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1050e3:	c9                   	leave  
  1050e4:	c3                   	ret    

001050e5 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1050e5:	55                   	push   %ebp
  1050e6:	89 e5                	mov    %esp,%ebp
  1050e8:	57                   	push   %edi
  1050e9:	56                   	push   %esi
  1050ea:	53                   	push   %ebx
  1050eb:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1050ee:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1050f5:	e8 42 b2 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1050fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105101:	e9 fa 00 00 00       	jmp    105200 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105109:	89 04 24             	mov    %eax,(%esp)
  10510c:	e8 d0 fe ff ff       	call   104fe1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105111:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105114:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105117:	29 d1                	sub    %edx,%ecx
  105119:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10511b:	89 d6                	mov    %edx,%esi
  10511d:	c1 e6 16             	shl    $0x16,%esi
  105120:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105123:	89 d3                	mov    %edx,%ebx
  105125:	c1 e3 16             	shl    $0x16,%ebx
  105128:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10512b:	89 d1                	mov    %edx,%ecx
  10512d:	c1 e1 16             	shl    $0x16,%ecx
  105130:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105133:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105136:	29 d7                	sub    %edx,%edi
  105138:	89 fa                	mov    %edi,%edx
  10513a:	89 44 24 14          	mov    %eax,0x14(%esp)
  10513e:	89 74 24 10          	mov    %esi,0x10(%esp)
  105142:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105146:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10514a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10514e:	c7 04 24 35 6e 10 00 	movl   $0x106e35,(%esp)
  105155:	e8 e2 b1 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10515a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10515d:	c1 e0 0a             	shl    $0xa,%eax
  105160:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105163:	eb 54                	jmp    1051b9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105168:	89 04 24             	mov    %eax,(%esp)
  10516b:	e8 71 fe ff ff       	call   104fe1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105170:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105173:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105176:	29 d1                	sub    %edx,%ecx
  105178:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10517a:	89 d6                	mov    %edx,%esi
  10517c:	c1 e6 0c             	shl    $0xc,%esi
  10517f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105182:	89 d3                	mov    %edx,%ebx
  105184:	c1 e3 0c             	shl    $0xc,%ebx
  105187:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10518a:	c1 e2 0c             	shl    $0xc,%edx
  10518d:	89 d1                	mov    %edx,%ecx
  10518f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105192:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105195:	29 d7                	sub    %edx,%edi
  105197:	89 fa                	mov    %edi,%edx
  105199:	89 44 24 14          	mov    %eax,0x14(%esp)
  10519d:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051a1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051ad:	c7 04 24 54 6e 10 00 	movl   $0x106e54,(%esp)
  1051b4:	e8 83 b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1051b9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1051be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1051c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1051c4:	89 ce                	mov    %ecx,%esi
  1051c6:	c1 e6 0a             	shl    $0xa,%esi
  1051c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1051cc:	89 cb                	mov    %ecx,%ebx
  1051ce:	c1 e3 0a             	shl    $0xa,%ebx
  1051d1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1051d4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1051d8:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1051db:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1051df:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1051e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1051e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  1051eb:	89 1c 24             	mov    %ebx,(%esp)
  1051ee:	e8 3c fe ff ff       	call   10502f <get_pgtable_items>
  1051f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1051f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1051fa:	0f 85 65 ff ff ff    	jne    105165 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105200:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105205:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105208:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10520b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10520f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105212:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105216:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10521a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10521e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105225:	00 
  105226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10522d:	e8 fd fd ff ff       	call   10502f <get_pgtable_items>
  105232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105235:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105239:	0f 85 c7 fe ff ff    	jne    105106 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10523f:	c7 04 24 78 6e 10 00 	movl   $0x106e78,(%esp)
  105246:	e8 f1 b0 ff ff       	call   10033c <cprintf>
}
  10524b:	83 c4 4c             	add    $0x4c,%esp
  10524e:	5b                   	pop    %ebx
  10524f:	5e                   	pop    %esi
  105250:	5f                   	pop    %edi
  105251:	5d                   	pop    %ebp
  105252:	c3                   	ret    

00105253 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105253:	55                   	push   %ebp
  105254:	89 e5                	mov    %esp,%ebp
  105256:	83 ec 58             	sub    $0x58,%esp
  105259:	8b 45 10             	mov    0x10(%ebp),%eax
  10525c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10525f:	8b 45 14             	mov    0x14(%ebp),%eax
  105262:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105265:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105268:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10526b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10526e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105271:	8b 45 18             	mov    0x18(%ebp),%eax
  105274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10527a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10527d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105280:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10528d:	74 1c                	je     1052ab <printnum+0x58>
  10528f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105292:	ba 00 00 00 00       	mov    $0x0,%edx
  105297:	f7 75 e4             	divl   -0x1c(%ebp)
  10529a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10529d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052a0:	ba 00 00 00 00       	mov    $0x0,%edx
  1052a5:	f7 75 e4             	divl   -0x1c(%ebp)
  1052a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1052ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1052b1:	f7 75 e4             	divl   -0x1c(%ebp)
  1052b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1052ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1052c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1052c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052c9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1052cc:	8b 45 18             	mov    0x18(%ebp),%eax
  1052cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1052d4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1052d7:	77 56                	ja     10532f <printnum+0xdc>
  1052d9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1052dc:	72 05                	jb     1052e3 <printnum+0x90>
  1052de:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1052e1:	77 4c                	ja     10532f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1052e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1052e9:	8b 45 20             	mov    0x20(%ebp),%eax
  1052ec:	89 44 24 18          	mov    %eax,0x18(%esp)
  1052f0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1052f4:	8b 45 18             	mov    0x18(%ebp),%eax
  1052f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1052fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105301:	89 44 24 08          	mov    %eax,0x8(%esp)
  105305:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105309:	8b 45 0c             	mov    0xc(%ebp),%eax
  10530c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105310:	8b 45 08             	mov    0x8(%ebp),%eax
  105313:	89 04 24             	mov    %eax,(%esp)
  105316:	e8 38 ff ff ff       	call   105253 <printnum>
  10531b:	eb 1c                	jmp    105339 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10531d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105320:	89 44 24 04          	mov    %eax,0x4(%esp)
  105324:	8b 45 20             	mov    0x20(%ebp),%eax
  105327:	89 04 24             	mov    %eax,(%esp)
  10532a:	8b 45 08             	mov    0x8(%ebp),%eax
  10532d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10532f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105333:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105337:	7f e4                	jg     10531d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105339:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10533c:	05 2c 6f 10 00       	add    $0x106f2c,%eax
  105341:	0f b6 00             	movzbl (%eax),%eax
  105344:	0f be c0             	movsbl %al,%eax
  105347:	8b 55 0c             	mov    0xc(%ebp),%edx
  10534a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10534e:	89 04 24             	mov    %eax,(%esp)
  105351:	8b 45 08             	mov    0x8(%ebp),%eax
  105354:	ff d0                	call   *%eax
}
  105356:	c9                   	leave  
  105357:	c3                   	ret    

00105358 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105358:	55                   	push   %ebp
  105359:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10535b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10535f:	7e 14                	jle    105375 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105361:	8b 45 08             	mov    0x8(%ebp),%eax
  105364:	8b 00                	mov    (%eax),%eax
  105366:	8d 48 08             	lea    0x8(%eax),%ecx
  105369:	8b 55 08             	mov    0x8(%ebp),%edx
  10536c:	89 0a                	mov    %ecx,(%edx)
  10536e:	8b 50 04             	mov    0x4(%eax),%edx
  105371:	8b 00                	mov    (%eax),%eax
  105373:	eb 30                	jmp    1053a5 <getuint+0x4d>
    }
    else if (lflag) {
  105375:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105379:	74 16                	je     105391 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10537b:	8b 45 08             	mov    0x8(%ebp),%eax
  10537e:	8b 00                	mov    (%eax),%eax
  105380:	8d 48 04             	lea    0x4(%eax),%ecx
  105383:	8b 55 08             	mov    0x8(%ebp),%edx
  105386:	89 0a                	mov    %ecx,(%edx)
  105388:	8b 00                	mov    (%eax),%eax
  10538a:	ba 00 00 00 00       	mov    $0x0,%edx
  10538f:	eb 14                	jmp    1053a5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105391:	8b 45 08             	mov    0x8(%ebp),%eax
  105394:	8b 00                	mov    (%eax),%eax
  105396:	8d 48 04             	lea    0x4(%eax),%ecx
  105399:	8b 55 08             	mov    0x8(%ebp),%edx
  10539c:	89 0a                	mov    %ecx,(%edx)
  10539e:	8b 00                	mov    (%eax),%eax
  1053a0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1053a5:	5d                   	pop    %ebp
  1053a6:	c3                   	ret    

001053a7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1053a7:	55                   	push   %ebp
  1053a8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053ae:	7e 14                	jle    1053c4 <getint+0x1d>
        return va_arg(*ap, long long);
  1053b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b3:	8b 00                	mov    (%eax),%eax
  1053b5:	8d 48 08             	lea    0x8(%eax),%ecx
  1053b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1053bb:	89 0a                	mov    %ecx,(%edx)
  1053bd:	8b 50 04             	mov    0x4(%eax),%edx
  1053c0:	8b 00                	mov    (%eax),%eax
  1053c2:	eb 28                	jmp    1053ec <getint+0x45>
    }
    else if (lflag) {
  1053c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053c8:	74 12                	je     1053dc <getint+0x35>
        return va_arg(*ap, long);
  1053ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1053cd:	8b 00                	mov    (%eax),%eax
  1053cf:	8d 48 04             	lea    0x4(%eax),%ecx
  1053d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1053d5:	89 0a                	mov    %ecx,(%edx)
  1053d7:	8b 00                	mov    (%eax),%eax
  1053d9:	99                   	cltd   
  1053da:	eb 10                	jmp    1053ec <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1053dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1053df:	8b 00                	mov    (%eax),%eax
  1053e1:	8d 48 04             	lea    0x4(%eax),%ecx
  1053e4:	8b 55 08             	mov    0x8(%ebp),%edx
  1053e7:	89 0a                	mov    %ecx,(%edx)
  1053e9:	8b 00                	mov    (%eax),%eax
  1053eb:	99                   	cltd   
    }
}
  1053ec:	5d                   	pop    %ebp
  1053ed:	c3                   	ret    

001053ee <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1053ee:	55                   	push   %ebp
  1053ef:	89 e5                	mov    %esp,%ebp
  1053f1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1053f4:	8d 45 14             	lea    0x14(%ebp),%eax
  1053f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1053fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105401:	8b 45 10             	mov    0x10(%ebp),%eax
  105404:	89 44 24 08          	mov    %eax,0x8(%esp)
  105408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10540b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10540f:	8b 45 08             	mov    0x8(%ebp),%eax
  105412:	89 04 24             	mov    %eax,(%esp)
  105415:	e8 02 00 00 00       	call   10541c <vprintfmt>
    va_end(ap);
}
  10541a:	c9                   	leave  
  10541b:	c3                   	ret    

0010541c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10541c:	55                   	push   %ebp
  10541d:	89 e5                	mov    %esp,%ebp
  10541f:	56                   	push   %esi
  105420:	53                   	push   %ebx
  105421:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105424:	eb 18                	jmp    10543e <vprintfmt+0x22>
            if (ch == '\0') {
  105426:	85 db                	test   %ebx,%ebx
  105428:	75 05                	jne    10542f <vprintfmt+0x13>
                return;
  10542a:	e9 d1 03 00 00       	jmp    105800 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10542f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105432:	89 44 24 04          	mov    %eax,0x4(%esp)
  105436:	89 1c 24             	mov    %ebx,(%esp)
  105439:	8b 45 08             	mov    0x8(%ebp),%eax
  10543c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10543e:	8b 45 10             	mov    0x10(%ebp),%eax
  105441:	8d 50 01             	lea    0x1(%eax),%edx
  105444:	89 55 10             	mov    %edx,0x10(%ebp)
  105447:	0f b6 00             	movzbl (%eax),%eax
  10544a:	0f b6 d8             	movzbl %al,%ebx
  10544d:	83 fb 25             	cmp    $0x25,%ebx
  105450:	75 d4                	jne    105426 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105452:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105456:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10545d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105460:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105463:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10546a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10546d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105470:	8b 45 10             	mov    0x10(%ebp),%eax
  105473:	8d 50 01             	lea    0x1(%eax),%edx
  105476:	89 55 10             	mov    %edx,0x10(%ebp)
  105479:	0f b6 00             	movzbl (%eax),%eax
  10547c:	0f b6 d8             	movzbl %al,%ebx
  10547f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105482:	83 f8 55             	cmp    $0x55,%eax
  105485:	0f 87 44 03 00 00    	ja     1057cf <vprintfmt+0x3b3>
  10548b:	8b 04 85 50 6f 10 00 	mov    0x106f50(,%eax,4),%eax
  105492:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105494:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105498:	eb d6                	jmp    105470 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10549a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10549e:	eb d0                	jmp    105470 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1054a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054aa:	89 d0                	mov    %edx,%eax
  1054ac:	c1 e0 02             	shl    $0x2,%eax
  1054af:	01 d0                	add    %edx,%eax
  1054b1:	01 c0                	add    %eax,%eax
  1054b3:	01 d8                	add    %ebx,%eax
  1054b5:	83 e8 30             	sub    $0x30,%eax
  1054b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1054bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1054be:	0f b6 00             	movzbl (%eax),%eax
  1054c1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1054c4:	83 fb 2f             	cmp    $0x2f,%ebx
  1054c7:	7e 0b                	jle    1054d4 <vprintfmt+0xb8>
  1054c9:	83 fb 39             	cmp    $0x39,%ebx
  1054cc:	7f 06                	jg     1054d4 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054ce:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1054d2:	eb d3                	jmp    1054a7 <vprintfmt+0x8b>
            goto process_precision;
  1054d4:	eb 33                	jmp    105509 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1054d6:	8b 45 14             	mov    0x14(%ebp),%eax
  1054d9:	8d 50 04             	lea    0x4(%eax),%edx
  1054dc:	89 55 14             	mov    %edx,0x14(%ebp)
  1054df:	8b 00                	mov    (%eax),%eax
  1054e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1054e4:	eb 23                	jmp    105509 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1054e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1054ea:	79 0c                	jns    1054f8 <vprintfmt+0xdc>
                width = 0;
  1054ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1054f3:	e9 78 ff ff ff       	jmp    105470 <vprintfmt+0x54>
  1054f8:	e9 73 ff ff ff       	jmp    105470 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1054fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105504:	e9 67 ff ff ff       	jmp    105470 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105509:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10550d:	79 12                	jns    105521 <vprintfmt+0x105>
                width = precision, precision = -1;
  10550f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105512:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105515:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10551c:	e9 4f ff ff ff       	jmp    105470 <vprintfmt+0x54>
  105521:	e9 4a ff ff ff       	jmp    105470 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105526:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10552a:	e9 41 ff ff ff       	jmp    105470 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10552f:	8b 45 14             	mov    0x14(%ebp),%eax
  105532:	8d 50 04             	lea    0x4(%eax),%edx
  105535:	89 55 14             	mov    %edx,0x14(%ebp)
  105538:	8b 00                	mov    (%eax),%eax
  10553a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10553d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105541:	89 04 24             	mov    %eax,(%esp)
  105544:	8b 45 08             	mov    0x8(%ebp),%eax
  105547:	ff d0                	call   *%eax
            break;
  105549:	e9 ac 02 00 00       	jmp    1057fa <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10554e:	8b 45 14             	mov    0x14(%ebp),%eax
  105551:	8d 50 04             	lea    0x4(%eax),%edx
  105554:	89 55 14             	mov    %edx,0x14(%ebp)
  105557:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105559:	85 db                	test   %ebx,%ebx
  10555b:	79 02                	jns    10555f <vprintfmt+0x143>
                err = -err;
  10555d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10555f:	83 fb 06             	cmp    $0x6,%ebx
  105562:	7f 0b                	jg     10556f <vprintfmt+0x153>
  105564:	8b 34 9d 10 6f 10 00 	mov    0x106f10(,%ebx,4),%esi
  10556b:	85 f6                	test   %esi,%esi
  10556d:	75 23                	jne    105592 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10556f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105573:	c7 44 24 08 3d 6f 10 	movl   $0x106f3d,0x8(%esp)
  10557a:	00 
  10557b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10557e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105582:	8b 45 08             	mov    0x8(%ebp),%eax
  105585:	89 04 24             	mov    %eax,(%esp)
  105588:	e8 61 fe ff ff       	call   1053ee <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10558d:	e9 68 02 00 00       	jmp    1057fa <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105592:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105596:	c7 44 24 08 46 6f 10 	movl   $0x106f46,0x8(%esp)
  10559d:	00 
  10559e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a8:	89 04 24             	mov    %eax,(%esp)
  1055ab:	e8 3e fe ff ff       	call   1053ee <printfmt>
            }
            break;
  1055b0:	e9 45 02 00 00       	jmp    1057fa <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1055b5:	8b 45 14             	mov    0x14(%ebp),%eax
  1055b8:	8d 50 04             	lea    0x4(%eax),%edx
  1055bb:	89 55 14             	mov    %edx,0x14(%ebp)
  1055be:	8b 30                	mov    (%eax),%esi
  1055c0:	85 f6                	test   %esi,%esi
  1055c2:	75 05                	jne    1055c9 <vprintfmt+0x1ad>
                p = "(null)";
  1055c4:	be 49 6f 10 00       	mov    $0x106f49,%esi
            }
            if (width > 0 && padc != '-') {
  1055c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1055cd:	7e 3e                	jle    10560d <vprintfmt+0x1f1>
  1055cf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1055d3:	74 38                	je     10560d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1055d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1055d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055df:	89 34 24             	mov    %esi,(%esp)
  1055e2:	e8 15 03 00 00       	call   1058fc <strnlen>
  1055e7:	29 c3                	sub    %eax,%ebx
  1055e9:	89 d8                	mov    %ebx,%eax
  1055eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055ee:	eb 17                	jmp    105607 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1055f0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1055f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055fb:	89 04 24             	mov    %eax,(%esp)
  1055fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105601:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105603:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105607:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10560b:	7f e3                	jg     1055f0 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10560d:	eb 38                	jmp    105647 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10560f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105613:	74 1f                	je     105634 <vprintfmt+0x218>
  105615:	83 fb 1f             	cmp    $0x1f,%ebx
  105618:	7e 05                	jle    10561f <vprintfmt+0x203>
  10561a:	83 fb 7e             	cmp    $0x7e,%ebx
  10561d:	7e 15                	jle    105634 <vprintfmt+0x218>
                    putch('?', putdat);
  10561f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105622:	89 44 24 04          	mov    %eax,0x4(%esp)
  105626:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10562d:	8b 45 08             	mov    0x8(%ebp),%eax
  105630:	ff d0                	call   *%eax
  105632:	eb 0f                	jmp    105643 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105634:	8b 45 0c             	mov    0xc(%ebp),%eax
  105637:	89 44 24 04          	mov    %eax,0x4(%esp)
  10563b:	89 1c 24             	mov    %ebx,(%esp)
  10563e:	8b 45 08             	mov    0x8(%ebp),%eax
  105641:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105643:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105647:	89 f0                	mov    %esi,%eax
  105649:	8d 70 01             	lea    0x1(%eax),%esi
  10564c:	0f b6 00             	movzbl (%eax),%eax
  10564f:	0f be d8             	movsbl %al,%ebx
  105652:	85 db                	test   %ebx,%ebx
  105654:	74 10                	je     105666 <vprintfmt+0x24a>
  105656:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10565a:	78 b3                	js     10560f <vprintfmt+0x1f3>
  10565c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105664:	79 a9                	jns    10560f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105666:	eb 17                	jmp    10567f <vprintfmt+0x263>
                putch(' ', putdat);
  105668:	8b 45 0c             	mov    0xc(%ebp),%eax
  10566b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10566f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105676:	8b 45 08             	mov    0x8(%ebp),%eax
  105679:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10567b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10567f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105683:	7f e3                	jg     105668 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105685:	e9 70 01 00 00       	jmp    1057fa <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10568a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10568d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105691:	8d 45 14             	lea    0x14(%ebp),%eax
  105694:	89 04 24             	mov    %eax,(%esp)
  105697:	e8 0b fd ff ff       	call   1053a7 <getint>
  10569c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10569f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1056a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056a8:	85 d2                	test   %edx,%edx
  1056aa:	79 26                	jns    1056d2 <vprintfmt+0x2b6>
                putch('-', putdat);
  1056ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056b3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1056ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1056bd:	ff d0                	call   *%eax
                num = -(long long)num;
  1056bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056c5:	f7 d8                	neg    %eax
  1056c7:	83 d2 00             	adc    $0x0,%edx
  1056ca:	f7 da                	neg    %edx
  1056cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1056d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1056d9:	e9 a8 00 00 00       	jmp    105786 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1056de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056e5:	8d 45 14             	lea    0x14(%ebp),%eax
  1056e8:	89 04 24             	mov    %eax,(%esp)
  1056eb:	e8 68 fc ff ff       	call   105358 <getuint>
  1056f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1056f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1056fd:	e9 84 00 00 00       	jmp    105786 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105702:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105705:	89 44 24 04          	mov    %eax,0x4(%esp)
  105709:	8d 45 14             	lea    0x14(%ebp),%eax
  10570c:	89 04 24             	mov    %eax,(%esp)
  10570f:	e8 44 fc ff ff       	call   105358 <getuint>
  105714:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105717:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10571a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105721:	eb 63                	jmp    105786 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105723:	8b 45 0c             	mov    0xc(%ebp),%eax
  105726:	89 44 24 04          	mov    %eax,0x4(%esp)
  10572a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105731:	8b 45 08             	mov    0x8(%ebp),%eax
  105734:	ff d0                	call   *%eax
            putch('x', putdat);
  105736:	8b 45 0c             	mov    0xc(%ebp),%eax
  105739:	89 44 24 04          	mov    %eax,0x4(%esp)
  10573d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105744:	8b 45 08             	mov    0x8(%ebp),%eax
  105747:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105749:	8b 45 14             	mov    0x14(%ebp),%eax
  10574c:	8d 50 04             	lea    0x4(%eax),%edx
  10574f:	89 55 14             	mov    %edx,0x14(%ebp)
  105752:	8b 00                	mov    (%eax),%eax
  105754:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10575e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105765:	eb 1f                	jmp    105786 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10576a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10576e:	8d 45 14             	lea    0x14(%ebp),%eax
  105771:	89 04 24             	mov    %eax,(%esp)
  105774:	e8 df fb ff ff       	call   105358 <getuint>
  105779:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10577c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10577f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105786:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10578a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10578d:	89 54 24 18          	mov    %edx,0x18(%esp)
  105791:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105794:	89 54 24 14          	mov    %edx,0x14(%esp)
  105798:	89 44 24 10          	mov    %eax,0x10(%esp)
  10579c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10579f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1057aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b4:	89 04 24             	mov    %eax,(%esp)
  1057b7:	e8 97 fa ff ff       	call   105253 <printnum>
            break;
  1057bc:	eb 3c                	jmp    1057fa <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1057be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c5:	89 1c 24             	mov    %ebx,(%esp)
  1057c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1057cb:	ff d0                	call   *%eax
            break;
  1057cd:	eb 2b                	jmp    1057fa <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1057dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e0:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1057e2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057e6:	eb 04                	jmp    1057ec <vprintfmt+0x3d0>
  1057e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1057ef:	83 e8 01             	sub    $0x1,%eax
  1057f2:	0f b6 00             	movzbl (%eax),%eax
  1057f5:	3c 25                	cmp    $0x25,%al
  1057f7:	75 ef                	jne    1057e8 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1057f9:	90                   	nop
        }
    }
  1057fa:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057fb:	e9 3e fc ff ff       	jmp    10543e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105800:	83 c4 40             	add    $0x40,%esp
  105803:	5b                   	pop    %ebx
  105804:	5e                   	pop    %esi
  105805:	5d                   	pop    %ebp
  105806:	c3                   	ret    

00105807 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105807:	55                   	push   %ebp
  105808:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10580a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580d:	8b 40 08             	mov    0x8(%eax),%eax
  105810:	8d 50 01             	lea    0x1(%eax),%edx
  105813:	8b 45 0c             	mov    0xc(%ebp),%eax
  105816:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10581c:	8b 10                	mov    (%eax),%edx
  10581e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105821:	8b 40 04             	mov    0x4(%eax),%eax
  105824:	39 c2                	cmp    %eax,%edx
  105826:	73 12                	jae    10583a <sprintputch+0x33>
        *b->buf ++ = ch;
  105828:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582b:	8b 00                	mov    (%eax),%eax
  10582d:	8d 48 01             	lea    0x1(%eax),%ecx
  105830:	8b 55 0c             	mov    0xc(%ebp),%edx
  105833:	89 0a                	mov    %ecx,(%edx)
  105835:	8b 55 08             	mov    0x8(%ebp),%edx
  105838:	88 10                	mov    %dl,(%eax)
    }
}
  10583a:	5d                   	pop    %ebp
  10583b:	c3                   	ret    

0010583c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10583c:	55                   	push   %ebp
  10583d:	89 e5                	mov    %esp,%ebp
  10583f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105842:	8d 45 14             	lea    0x14(%ebp),%eax
  105845:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10584b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10584f:	8b 45 10             	mov    0x10(%ebp),%eax
  105852:	89 44 24 08          	mov    %eax,0x8(%esp)
  105856:	8b 45 0c             	mov    0xc(%ebp),%eax
  105859:	89 44 24 04          	mov    %eax,0x4(%esp)
  10585d:	8b 45 08             	mov    0x8(%ebp),%eax
  105860:	89 04 24             	mov    %eax,(%esp)
  105863:	e8 08 00 00 00       	call   105870 <vsnprintf>
  105868:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10586e:	c9                   	leave  
  10586f:	c3                   	ret    

00105870 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105870:	55                   	push   %ebp
  105871:	89 e5                	mov    %esp,%ebp
  105873:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105876:	8b 45 08             	mov    0x8(%ebp),%eax
  105879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10587c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10587f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105882:	8b 45 08             	mov    0x8(%ebp),%eax
  105885:	01 d0                	add    %edx,%eax
  105887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10588a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105891:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105895:	74 0a                	je     1058a1 <vsnprintf+0x31>
  105897:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10589a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10589d:	39 c2                	cmp    %eax,%edx
  10589f:	76 07                	jbe    1058a8 <vsnprintf+0x38>
        return -E_INVAL;
  1058a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1058a6:	eb 2a                	jmp    1058d2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1058a8:	8b 45 14             	mov    0x14(%ebp),%eax
  1058ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058af:	8b 45 10             	mov    0x10(%ebp),%eax
  1058b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bd:	c7 04 24 07 58 10 00 	movl   $0x105807,(%esp)
  1058c4:	e8 53 fb ff ff       	call   10541c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1058c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058cc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1058cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058d2:	c9                   	leave  
  1058d3:	c3                   	ret    

001058d4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1058d4:	55                   	push   %ebp
  1058d5:	89 e5                	mov    %esp,%ebp
  1058d7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1058da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1058e1:	eb 04                	jmp    1058e7 <strlen+0x13>
        cnt ++;
  1058e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1058e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ea:	8d 50 01             	lea    0x1(%eax),%edx
  1058ed:	89 55 08             	mov    %edx,0x8(%ebp)
  1058f0:	0f b6 00             	movzbl (%eax),%eax
  1058f3:	84 c0                	test   %al,%al
  1058f5:	75 ec                	jne    1058e3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1058f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1058fa:	c9                   	leave  
  1058fb:	c3                   	ret    

001058fc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1058fc:	55                   	push   %ebp
  1058fd:	89 e5                	mov    %esp,%ebp
  1058ff:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105902:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105909:	eb 04                	jmp    10590f <strnlen+0x13>
        cnt ++;
  10590b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10590f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105912:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105915:	73 10                	jae    105927 <strnlen+0x2b>
  105917:	8b 45 08             	mov    0x8(%ebp),%eax
  10591a:	8d 50 01             	lea    0x1(%eax),%edx
  10591d:	89 55 08             	mov    %edx,0x8(%ebp)
  105920:	0f b6 00             	movzbl (%eax),%eax
  105923:	84 c0                	test   %al,%al
  105925:	75 e4                	jne    10590b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105927:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10592a:	c9                   	leave  
  10592b:	c3                   	ret    

0010592c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10592c:	55                   	push   %ebp
  10592d:	89 e5                	mov    %esp,%ebp
  10592f:	57                   	push   %edi
  105930:	56                   	push   %esi
  105931:	83 ec 20             	sub    $0x20,%esp
  105934:	8b 45 08             	mov    0x8(%ebp),%eax
  105937:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10593a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10593d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105940:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105946:	89 d1                	mov    %edx,%ecx
  105948:	89 c2                	mov    %eax,%edx
  10594a:	89 ce                	mov    %ecx,%esi
  10594c:	89 d7                	mov    %edx,%edi
  10594e:	ac                   	lods   %ds:(%esi),%al
  10594f:	aa                   	stos   %al,%es:(%edi)
  105950:	84 c0                	test   %al,%al
  105952:	75 fa                	jne    10594e <strcpy+0x22>
  105954:	89 fa                	mov    %edi,%edx
  105956:	89 f1                	mov    %esi,%ecx
  105958:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10595b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10595e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105961:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105964:	83 c4 20             	add    $0x20,%esp
  105967:	5e                   	pop    %esi
  105968:	5f                   	pop    %edi
  105969:	5d                   	pop    %ebp
  10596a:	c3                   	ret    

0010596b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10596b:	55                   	push   %ebp
  10596c:	89 e5                	mov    %esp,%ebp
  10596e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105971:	8b 45 08             	mov    0x8(%ebp),%eax
  105974:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105977:	eb 21                	jmp    10599a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105979:	8b 45 0c             	mov    0xc(%ebp),%eax
  10597c:	0f b6 10             	movzbl (%eax),%edx
  10597f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105982:	88 10                	mov    %dl,(%eax)
  105984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105987:	0f b6 00             	movzbl (%eax),%eax
  10598a:	84 c0                	test   %al,%al
  10598c:	74 04                	je     105992 <strncpy+0x27>
            src ++;
  10598e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105992:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105996:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10599a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10599e:	75 d9                	jne    105979 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1059a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1059a3:	c9                   	leave  
  1059a4:	c3                   	ret    

001059a5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1059a5:	55                   	push   %ebp
  1059a6:	89 e5                	mov    %esp,%ebp
  1059a8:	57                   	push   %edi
  1059a9:	56                   	push   %esi
  1059aa:	83 ec 20             	sub    $0x20,%esp
  1059ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1059b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059bf:	89 d1                	mov    %edx,%ecx
  1059c1:	89 c2                	mov    %eax,%edx
  1059c3:	89 ce                	mov    %ecx,%esi
  1059c5:	89 d7                	mov    %edx,%edi
  1059c7:	ac                   	lods   %ds:(%esi),%al
  1059c8:	ae                   	scas   %es:(%edi),%al
  1059c9:	75 08                	jne    1059d3 <strcmp+0x2e>
  1059cb:	84 c0                	test   %al,%al
  1059cd:	75 f8                	jne    1059c7 <strcmp+0x22>
  1059cf:	31 c0                	xor    %eax,%eax
  1059d1:	eb 04                	jmp    1059d7 <strcmp+0x32>
  1059d3:	19 c0                	sbb    %eax,%eax
  1059d5:	0c 01                	or     $0x1,%al
  1059d7:	89 fa                	mov    %edi,%edx
  1059d9:	89 f1                	mov    %esi,%ecx
  1059db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059de:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1059e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  1059e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1059e7:	83 c4 20             	add    $0x20,%esp
  1059ea:	5e                   	pop    %esi
  1059eb:	5f                   	pop    %edi
  1059ec:	5d                   	pop    %ebp
  1059ed:	c3                   	ret    

001059ee <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1059ee:	55                   	push   %ebp
  1059ef:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1059f1:	eb 0c                	jmp    1059ff <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1059f3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1059fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1059ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a03:	74 1a                	je     105a1f <strncmp+0x31>
  105a05:	8b 45 08             	mov    0x8(%ebp),%eax
  105a08:	0f b6 00             	movzbl (%eax),%eax
  105a0b:	84 c0                	test   %al,%al
  105a0d:	74 10                	je     105a1f <strncmp+0x31>
  105a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a12:	0f b6 10             	movzbl (%eax),%edx
  105a15:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a18:	0f b6 00             	movzbl (%eax),%eax
  105a1b:	38 c2                	cmp    %al,%dl
  105a1d:	74 d4                	je     1059f3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a23:	74 18                	je     105a3d <strncmp+0x4f>
  105a25:	8b 45 08             	mov    0x8(%ebp),%eax
  105a28:	0f b6 00             	movzbl (%eax),%eax
  105a2b:	0f b6 d0             	movzbl %al,%edx
  105a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a31:	0f b6 00             	movzbl (%eax),%eax
  105a34:	0f b6 c0             	movzbl %al,%eax
  105a37:	29 c2                	sub    %eax,%edx
  105a39:	89 d0                	mov    %edx,%eax
  105a3b:	eb 05                	jmp    105a42 <strncmp+0x54>
  105a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a42:	5d                   	pop    %ebp
  105a43:	c3                   	ret    

00105a44 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105a44:	55                   	push   %ebp
  105a45:	89 e5                	mov    %esp,%ebp
  105a47:	83 ec 04             	sub    $0x4,%esp
  105a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a50:	eb 14                	jmp    105a66 <strchr+0x22>
        if (*s == c) {
  105a52:	8b 45 08             	mov    0x8(%ebp),%eax
  105a55:	0f b6 00             	movzbl (%eax),%eax
  105a58:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105a5b:	75 05                	jne    105a62 <strchr+0x1e>
            return (char *)s;
  105a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a60:	eb 13                	jmp    105a75 <strchr+0x31>
        }
        s ++;
  105a62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105a66:	8b 45 08             	mov    0x8(%ebp),%eax
  105a69:	0f b6 00             	movzbl (%eax),%eax
  105a6c:	84 c0                	test   %al,%al
  105a6e:	75 e2                	jne    105a52 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a75:	c9                   	leave  
  105a76:	c3                   	ret    

00105a77 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105a77:	55                   	push   %ebp
  105a78:	89 e5                	mov    %esp,%ebp
  105a7a:	83 ec 04             	sub    $0x4,%esp
  105a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a80:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a83:	eb 11                	jmp    105a96 <strfind+0x1f>
        if (*s == c) {
  105a85:	8b 45 08             	mov    0x8(%ebp),%eax
  105a88:	0f b6 00             	movzbl (%eax),%eax
  105a8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105a8e:	75 02                	jne    105a92 <strfind+0x1b>
            break;
  105a90:	eb 0e                	jmp    105aa0 <strfind+0x29>
        }
        s ++;
  105a92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105a96:	8b 45 08             	mov    0x8(%ebp),%eax
  105a99:	0f b6 00             	movzbl (%eax),%eax
  105a9c:	84 c0                	test   %al,%al
  105a9e:	75 e5                	jne    105a85 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105aa3:	c9                   	leave  
  105aa4:	c3                   	ret    

00105aa5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105aa5:	55                   	push   %ebp
  105aa6:	89 e5                	mov    %esp,%ebp
  105aa8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ab2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ab9:	eb 04                	jmp    105abf <strtol+0x1a>
        s ++;
  105abb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105abf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac2:	0f b6 00             	movzbl (%eax),%eax
  105ac5:	3c 20                	cmp    $0x20,%al
  105ac7:	74 f2                	je     105abb <strtol+0x16>
  105ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  105acc:	0f b6 00             	movzbl (%eax),%eax
  105acf:	3c 09                	cmp    $0x9,%al
  105ad1:	74 e8                	je     105abb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad6:	0f b6 00             	movzbl (%eax),%eax
  105ad9:	3c 2b                	cmp    $0x2b,%al
  105adb:	75 06                	jne    105ae3 <strtol+0x3e>
        s ++;
  105add:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ae1:	eb 15                	jmp    105af8 <strtol+0x53>
    }
    else if (*s == '-') {
  105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae6:	0f b6 00             	movzbl (%eax),%eax
  105ae9:	3c 2d                	cmp    $0x2d,%al
  105aeb:	75 0b                	jne    105af8 <strtol+0x53>
        s ++, neg = 1;
  105aed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105af1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105af8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105afc:	74 06                	je     105b04 <strtol+0x5f>
  105afe:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b02:	75 24                	jne    105b28 <strtol+0x83>
  105b04:	8b 45 08             	mov    0x8(%ebp),%eax
  105b07:	0f b6 00             	movzbl (%eax),%eax
  105b0a:	3c 30                	cmp    $0x30,%al
  105b0c:	75 1a                	jne    105b28 <strtol+0x83>
  105b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b11:	83 c0 01             	add    $0x1,%eax
  105b14:	0f b6 00             	movzbl (%eax),%eax
  105b17:	3c 78                	cmp    $0x78,%al
  105b19:	75 0d                	jne    105b28 <strtol+0x83>
        s += 2, base = 16;
  105b1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105b26:	eb 2a                	jmp    105b52 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105b28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b2c:	75 17                	jne    105b45 <strtol+0xa0>
  105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b31:	0f b6 00             	movzbl (%eax),%eax
  105b34:	3c 30                	cmp    $0x30,%al
  105b36:	75 0d                	jne    105b45 <strtol+0xa0>
        s ++, base = 8;
  105b38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b3c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105b43:	eb 0d                	jmp    105b52 <strtol+0xad>
    }
    else if (base == 0) {
  105b45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b49:	75 07                	jne    105b52 <strtol+0xad>
        base = 10;
  105b4b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105b52:	8b 45 08             	mov    0x8(%ebp),%eax
  105b55:	0f b6 00             	movzbl (%eax),%eax
  105b58:	3c 2f                	cmp    $0x2f,%al
  105b5a:	7e 1b                	jle    105b77 <strtol+0xd2>
  105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5f:	0f b6 00             	movzbl (%eax),%eax
  105b62:	3c 39                	cmp    $0x39,%al
  105b64:	7f 11                	jg     105b77 <strtol+0xd2>
            dig = *s - '0';
  105b66:	8b 45 08             	mov    0x8(%ebp),%eax
  105b69:	0f b6 00             	movzbl (%eax),%eax
  105b6c:	0f be c0             	movsbl %al,%eax
  105b6f:	83 e8 30             	sub    $0x30,%eax
  105b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b75:	eb 48                	jmp    105bbf <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105b77:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7a:	0f b6 00             	movzbl (%eax),%eax
  105b7d:	3c 60                	cmp    $0x60,%al
  105b7f:	7e 1b                	jle    105b9c <strtol+0xf7>
  105b81:	8b 45 08             	mov    0x8(%ebp),%eax
  105b84:	0f b6 00             	movzbl (%eax),%eax
  105b87:	3c 7a                	cmp    $0x7a,%al
  105b89:	7f 11                	jg     105b9c <strtol+0xf7>
            dig = *s - 'a' + 10;
  105b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b8e:	0f b6 00             	movzbl (%eax),%eax
  105b91:	0f be c0             	movsbl %al,%eax
  105b94:	83 e8 57             	sub    $0x57,%eax
  105b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b9a:	eb 23                	jmp    105bbf <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b9f:	0f b6 00             	movzbl (%eax),%eax
  105ba2:	3c 40                	cmp    $0x40,%al
  105ba4:	7e 3d                	jle    105be3 <strtol+0x13e>
  105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba9:	0f b6 00             	movzbl (%eax),%eax
  105bac:	3c 5a                	cmp    $0x5a,%al
  105bae:	7f 33                	jg     105be3 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb3:	0f b6 00             	movzbl (%eax),%eax
  105bb6:	0f be c0             	movsbl %al,%eax
  105bb9:	83 e8 37             	sub    $0x37,%eax
  105bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bc2:	3b 45 10             	cmp    0x10(%ebp),%eax
  105bc5:	7c 02                	jl     105bc9 <strtol+0x124>
            break;
  105bc7:	eb 1a                	jmp    105be3 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105bc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bd0:	0f af 45 10          	imul   0x10(%ebp),%eax
  105bd4:	89 c2                	mov    %eax,%edx
  105bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bd9:	01 d0                	add    %edx,%eax
  105bdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105bde:	e9 6f ff ff ff       	jmp    105b52 <strtol+0xad>

    if (endptr) {
  105be3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105be7:	74 08                	je     105bf1 <strtol+0x14c>
        *endptr = (char *) s;
  105be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bec:	8b 55 08             	mov    0x8(%ebp),%edx
  105bef:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105bf5:	74 07                	je     105bfe <strtol+0x159>
  105bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bfa:	f7 d8                	neg    %eax
  105bfc:	eb 03                	jmp    105c01 <strtol+0x15c>
  105bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c01:	c9                   	leave  
  105c02:	c3                   	ret    

00105c03 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c03:	55                   	push   %ebp
  105c04:	89 e5                	mov    %esp,%ebp
  105c06:	57                   	push   %edi
  105c07:	83 ec 24             	sub    $0x24,%esp
  105c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c0d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c10:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105c14:	8b 55 08             	mov    0x8(%ebp),%edx
  105c17:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105c1a:	88 45 f7             	mov    %al,-0x9(%ebp)
  105c1d:	8b 45 10             	mov    0x10(%ebp),%eax
  105c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105c23:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105c26:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105c2a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105c2d:	89 d7                	mov    %edx,%edi
  105c2f:	f3 aa                	rep stos %al,%es:(%edi)
  105c31:	89 fa                	mov    %edi,%edx
  105c33:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c36:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105c39:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105c3c:	83 c4 24             	add    $0x24,%esp
  105c3f:	5f                   	pop    %edi
  105c40:	5d                   	pop    %ebp
  105c41:	c3                   	ret    

00105c42 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105c42:	55                   	push   %ebp
  105c43:	89 e5                	mov    %esp,%ebp
  105c45:	57                   	push   %edi
  105c46:	56                   	push   %esi
  105c47:	53                   	push   %ebx
  105c48:	83 ec 30             	sub    $0x30,%esp
  105c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c57:	8b 45 10             	mov    0x10(%ebp),%eax
  105c5a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105c63:	73 42                	jae    105ca7 <memmove+0x65>
  105c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c74:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105c77:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c7a:	c1 e8 02             	shr    $0x2,%eax
  105c7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105c7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105c82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c85:	89 d7                	mov    %edx,%edi
  105c87:	89 c6                	mov    %eax,%esi
  105c89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105c8b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105c8e:	83 e1 03             	and    $0x3,%ecx
  105c91:	74 02                	je     105c95 <memmove+0x53>
  105c93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105c95:	89 f0                	mov    %esi,%eax
  105c97:	89 fa                	mov    %edi,%edx
  105c99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105c9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105c9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ca5:	eb 36                	jmp    105cdd <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105caa:	8d 50 ff             	lea    -0x1(%eax),%edx
  105cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cb0:	01 c2                	add    %eax,%edx
  105cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cb5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cbb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cc1:	89 c1                	mov    %eax,%ecx
  105cc3:	89 d8                	mov    %ebx,%eax
  105cc5:	89 d6                	mov    %edx,%esi
  105cc7:	89 c7                	mov    %eax,%edi
  105cc9:	fd                   	std    
  105cca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ccc:	fc                   	cld    
  105ccd:	89 f8                	mov    %edi,%eax
  105ccf:	89 f2                	mov    %esi,%edx
  105cd1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105cd4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105cd7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105cdd:	83 c4 30             	add    $0x30,%esp
  105ce0:	5b                   	pop    %ebx
  105ce1:	5e                   	pop    %esi
  105ce2:	5f                   	pop    %edi
  105ce3:	5d                   	pop    %ebp
  105ce4:	c3                   	ret    

00105ce5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ce5:	55                   	push   %ebp
  105ce6:	89 e5                	mov    %esp,%ebp
  105ce8:	57                   	push   %edi
  105ce9:	56                   	push   %esi
  105cea:	83 ec 20             	sub    $0x20,%esp
  105ced:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  105cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d02:	c1 e8 02             	shr    $0x2,%eax
  105d05:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d0d:	89 d7                	mov    %edx,%edi
  105d0f:	89 c6                	mov    %eax,%esi
  105d11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d13:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d16:	83 e1 03             	and    $0x3,%ecx
  105d19:	74 02                	je     105d1d <memcpy+0x38>
  105d1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d1d:	89 f0                	mov    %esi,%eax
  105d1f:	89 fa                	mov    %edi,%edx
  105d21:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105d27:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105d2d:	83 c4 20             	add    $0x20,%esp
  105d30:	5e                   	pop    %esi
  105d31:	5f                   	pop    %edi
  105d32:	5d                   	pop    %ebp
  105d33:	c3                   	ret    

00105d34 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105d34:	55                   	push   %ebp
  105d35:	89 e5                	mov    %esp,%ebp
  105d37:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105d46:	eb 30                	jmp    105d78 <memcmp+0x44>
        if (*s1 != *s2) {
  105d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d4b:	0f b6 10             	movzbl (%eax),%edx
  105d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d51:	0f b6 00             	movzbl (%eax),%eax
  105d54:	38 c2                	cmp    %al,%dl
  105d56:	74 18                	je     105d70 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d5b:	0f b6 00             	movzbl (%eax),%eax
  105d5e:	0f b6 d0             	movzbl %al,%edx
  105d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d64:	0f b6 00             	movzbl (%eax),%eax
  105d67:	0f b6 c0             	movzbl %al,%eax
  105d6a:	29 c2                	sub    %eax,%edx
  105d6c:	89 d0                	mov    %edx,%eax
  105d6e:	eb 1a                	jmp    105d8a <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105d70:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d74:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105d78:	8b 45 10             	mov    0x10(%ebp),%eax
  105d7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d7e:	89 55 10             	mov    %edx,0x10(%ebp)
  105d81:	85 c0                	test   %eax,%eax
  105d83:	75 c3                	jne    105d48 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d8a:	c9                   	leave  
  105d8b:	c3                   	ret    
