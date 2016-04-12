
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
c0100030:	ba 88 89 11 c0       	mov    $0xc0118988,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 ad 5b 00 00       	call   c0105c03 <memset>

    cons_init();                // init the console
c0100056:	e8 77 15 00 00       	call   c01015d2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 5d 10 c0 	movl   $0xc0105da0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc 5d 10 c0 	movl   $0xc0105dbc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 2f 42 00 00       	call   c01042b3 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b2 16 00 00       	call   c010173b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 04 18 00 00       	call   c0101892 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f5 0c 00 00       	call   c0100d88 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 11 16 00 00       	call   c01016a9 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 fe 0b 00 00       	call   c0100cba <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 c1 5d 10 c0 	movl   $0xc0105dc1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 cf 5d 10 c0 	movl   $0xc0105dcf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 dd 5d 10 c0 	movl   $0xc0105ddd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 eb 5d 10 c0 	movl   $0xc0105deb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 f9 5d 10 c0 	movl   $0xc0105df9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 08 5e 10 c0 	movl   $0xc0105e08,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 28 5e 10 c0 	movl   $0xc0105e28,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 47 5e 10 c0 	movl   $0xc0105e47,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 04 13 00 00       	call   c01015fe <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 e5 50 00 00       	call   c010541c <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8b 12 00 00       	call   c01015fe <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6b 12 00 00       	call   c010163a <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 4c 5e 10 c0    	movl   $0xc0105e4c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 4c 5e 10 c0 	movl   $0xc0105e4c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a8 70 10 c0 	movl   $0xc01070a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 64 1a 11 c0 	movl   $0xc0111a64,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 65 1a 11 c0 	movl   $0xc0111a65,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 96 44 11 c0 	movl   $0xc0114496,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 8b 53 00 00       	call   c0105a77 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 56 5e 10 c0 	movl   $0xc0105e56,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 6f 5e 10 c0 	movl   $0xc0105e6f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 8c 5d 10 	movl   $0xc0105d8c,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 87 5e 10 c0 	movl   $0xc0105e87,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 9f 5e 10 c0 	movl   $0xc0105e9f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 88 89 11 	movl   $0xc0118988,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 b7 5e 10 c0 	movl   $0xc0105eb7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 88 89 11 c0       	mov    $0xc0118988,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 d0 5e 10 c0 	movl   $0xc0105ed0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 fa 5e 10 c0 	movl   $0xc0105efa,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 16 5f 10 c0 	movl   $0xc0105f16,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
uint32_t ebp=read_ebp(),eip=read_eip();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&ebp>0;i++)
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 8e 00 00 00       	jmp    c0100a6d <print_stackframe+0xb3>
	{
		cprintf("ebp:0x%08x eip:0x%08x ",ebp,eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 28 5f 10 c0 	movl   $0xc0105f28,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
		cprintf("args:");
c01009f9:	c7 04 24 3f 5f 10 c0 	movl   $0xc0105f3f,(%esp)
c0100a00:	e8 37 f9 ff ff       	call   c010033c <cprintf>
		int j;
		for(j=0;j<4;j++)
c0100a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a0c:	eb 28                	jmp    c0100a36 <print_stackframe+0x7c>
			cprintf("0x%08x ",((uint32_t *)ebp)[2+j]);
c0100a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a11:	83 c0 02             	add    $0x2,%eax
c0100a14:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1e:	01 d0                	add    %edx,%eax
c0100a20:	8b 00                	mov    (%eax),%eax
c0100a22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a26:	c7 04 24 45 5f 10 c0 	movl   $0xc0105f45,(%esp)
c0100a2d:	e8 0a f9 ff ff       	call   c010033c <cprintf>
	for(i=0;i<STACKFRAME_DEPTH&&ebp>0;i++)
	{
		cprintf("ebp:0x%08x eip:0x%08x ",ebp,eip);
		cprintf("args:");
		int j;
		for(j=0;j<4;j++)
c0100a32:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a36:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3a:	7e d2                	jle    c0100a0e <print_stackframe+0x54>
			cprintf("0x%08x ",((uint32_t *)ebp)[2+j]);
		cprintf("\n");
c0100a3c:	c7 04 24 4d 5f 10 c0 	movl   $0xc0105f4d,(%esp)
c0100a43:	e8 f4 f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(eip-1);
c0100a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4b:	83 e8 01             	sub    $0x1,%eax
c0100a4e:	89 04 24             	mov    %eax,(%esp)
c0100a51:	e8 b0 fe ff ff       	call   c0100906 <print_debuginfo>
		eip=((uint32_t *)ebp)[1];
c0100a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a59:	83 c0 04             	add    $0x4,%eax
c0100a5c:	8b 00                	mov    (%eax),%eax
c0100a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=((uint32_t *)ebp)[0];
c0100a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a64:	8b 00                	mov    (%eax),%eax
c0100a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
uint32_t ebp=read_ebp(),eip=read_eip();
	int i;
	for(i=0;i<STACKFRAME_DEPTH&&ebp>0;i++)
c0100a69:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a71:	7f 0a                	jg     c0100a7d <print_stackframe+0xc3>
c0100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a77:	0f 85 62 ff ff ff    	jne    c01009df <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip=((uint32_t *)ebp)[1];
		ebp=((uint32_t *)ebp)[0];
	}
}
c0100a7d:	c9                   	leave  
c0100a7e:	c3                   	ret    

c0100a7f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7f:	55                   	push   %ebp
c0100a80:	89 e5                	mov    %esp,%ebp
c0100a82:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8c:	eb 0c                	jmp    c0100a9a <parse+0x1b>
            *buf ++ = '\0';
c0100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a91:	8d 50 01             	lea    0x1(%eax),%edx
c0100a94:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a97:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9d:	0f b6 00             	movzbl (%eax),%eax
c0100aa0:	84 c0                	test   %al,%al
c0100aa2:	74 1d                	je     c0100ac1 <parse+0x42>
c0100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa7:	0f b6 00             	movzbl (%eax),%eax
c0100aaa:	0f be c0             	movsbl %al,%eax
c0100aad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab1:	c7 04 24 d0 5f 10 c0 	movl   $0xc0105fd0,(%esp)
c0100ab8:	e8 87 4f 00 00       	call   c0105a44 <strchr>
c0100abd:	85 c0                	test   %eax,%eax
c0100abf:	75 cd                	jne    c0100a8e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac4:	0f b6 00             	movzbl (%eax),%eax
c0100ac7:	84 c0                	test   %al,%al
c0100ac9:	75 02                	jne    c0100acd <parse+0x4e>
            break;
c0100acb:	eb 67                	jmp    c0100b34 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100acd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad1:	75 14                	jne    c0100ae7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ada:	00 
c0100adb:	c7 04 24 d5 5f 10 c0 	movl   $0xc0105fd5,(%esp)
c0100ae2:	e8 55 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aea:	8d 50 01             	lea    0x1(%eax),%edx
c0100aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afa:	01 c2                	add    %eax,%edx
c0100afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aff:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	eb 04                	jmp    c0100b07 <parse+0x88>
            buf ++;
c0100b03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0a:	0f b6 00             	movzbl (%eax),%eax
c0100b0d:	84 c0                	test   %al,%al
c0100b0f:	74 1d                	je     c0100b2e <parse+0xaf>
c0100b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b14:	0f b6 00             	movzbl (%eax),%eax
c0100b17:	0f be c0             	movsbl %al,%eax
c0100b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1e:	c7 04 24 d0 5f 10 c0 	movl   $0xc0105fd0,(%esp)
c0100b25:	e8 1a 4f 00 00       	call   c0105a44 <strchr>
c0100b2a:	85 c0                	test   %eax,%eax
c0100b2c:	74 d5                	je     c0100b03 <parse+0x84>
            buf ++;
        }
    }
c0100b2e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2f:	e9 66 ff ff ff       	jmp    c0100a9a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b37:	c9                   	leave  
c0100b38:	c3                   	ret    

c0100b39 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b39:	55                   	push   %ebp
c0100b3a:	89 e5                	mov    %esp,%ebp
c0100b3c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b3f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b49:	89 04 24             	mov    %eax,(%esp)
c0100b4c:	e8 2e ff ff ff       	call   c0100a7f <parse>
c0100b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b58:	75 0a                	jne    c0100b64 <runcmd+0x2b>
        return 0;
c0100b5a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b5f:	e9 85 00 00 00       	jmp    c0100be9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6b:	eb 5c                	jmp    c0100bc9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b73:	89 d0                	mov    %edx,%eax
c0100b75:	01 c0                	add    %eax,%eax
c0100b77:	01 d0                	add    %edx,%eax
c0100b79:	c1 e0 02             	shl    $0x2,%eax
c0100b7c:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b81:	8b 00                	mov    (%eax),%eax
c0100b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b87:	89 04 24             	mov    %eax,(%esp)
c0100b8a:	e8 16 4e 00 00       	call   c01059a5 <strcmp>
c0100b8f:	85 c0                	test   %eax,%eax
c0100b91:	75 32                	jne    c0100bc5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b96:	89 d0                	mov    %edx,%eax
c0100b98:	01 c0                	add    %eax,%eax
c0100b9a:	01 d0                	add    %edx,%eax
c0100b9c:	c1 e0 02             	shl    $0x2,%eax
c0100b9f:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba4:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100baa:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bad:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb7:	83 c2 04             	add    $0x4,%edx
c0100bba:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbe:	89 0c 24             	mov    %ecx,(%esp)
c0100bc1:	ff d0                	call   *%eax
c0100bc3:	eb 24                	jmp    c0100be9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcc:	83 f8 02             	cmp    $0x2,%eax
c0100bcf:	76 9c                	jbe    c0100b6d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd8:	c7 04 24 f3 5f 10 c0 	movl   $0xc0105ff3,(%esp)
c0100bdf:	e8 58 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be9:	c9                   	leave  
c0100bea:	c3                   	ret    

c0100beb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100beb:	55                   	push   %ebp
c0100bec:	89 e5                	mov    %esp,%ebp
c0100bee:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf1:	c7 04 24 0c 60 10 c0 	movl   $0xc010600c,(%esp)
c0100bf8:	e8 3f f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfd:	c7 04 24 34 60 10 c0 	movl   $0xc0106034,(%esp)
c0100c04:	e8 33 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0d:	74 0b                	je     c0100c1a <kmonitor+0x2f>
        print_trapframe(tf);
c0100c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c12:	89 04 24             	mov    %eax,(%esp)
c0100c15:	e8 b0 0d 00 00       	call   c01019ca <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1a:	c7 04 24 59 60 10 c0 	movl   $0xc0106059,(%esp)
c0100c21:	e8 0d f6 ff ff       	call   c0100233 <readline>
c0100c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2d:	74 18                	je     c0100c47 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c39:	89 04 24             	mov    %eax,(%esp)
c0100c3c:	e8 f8 fe ff ff       	call   c0100b39 <runcmd>
c0100c41:	85 c0                	test   %eax,%eax
c0100c43:	79 02                	jns    c0100c47 <kmonitor+0x5c>
                break;
c0100c45:	eb 02                	jmp    c0100c49 <kmonitor+0x5e>
            }
        }
    }
c0100c47:	eb d1                	jmp    c0100c1a <kmonitor+0x2f>
}
c0100c49:	c9                   	leave  
c0100c4a:	c3                   	ret    

c0100c4b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4b:	55                   	push   %ebp
c0100c4c:	89 e5                	mov    %esp,%ebp
c0100c4e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c58:	eb 3f                	jmp    c0100c99 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5d:	89 d0                	mov    %edx,%eax
c0100c5f:	01 c0                	add    %eax,%eax
c0100c61:	01 d0                	add    %edx,%eax
c0100c63:	c1 e0 02             	shl    $0x2,%eax
c0100c66:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6b:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c71:	89 d0                	mov    %edx,%eax
c0100c73:	01 c0                	add    %eax,%eax
c0100c75:	01 d0                	add    %edx,%eax
c0100c77:	c1 e0 02             	shl    $0x2,%eax
c0100c7a:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c7f:	8b 00                	mov    (%eax),%eax
c0100c81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c89:	c7 04 24 5d 60 10 c0 	movl   $0xc010605d,(%esp)
c0100c90:	e8 a7 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9c:	83 f8 02             	cmp    $0x2,%eax
c0100c9f:	76 b9                	jbe    c0100c5a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca6:	c9                   	leave  
c0100ca7:	c3                   	ret    

c0100ca8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca8:	55                   	push   %ebp
c0100ca9:	89 e5                	mov    %esp,%ebp
c0100cab:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cae:	e8 bd fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb8:	c9                   	leave  
c0100cb9:	c3                   	ret    

c0100cba <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cba:	55                   	push   %ebp
c0100cbb:	89 e5                	mov    %esp,%ebp
c0100cbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc0:	e8 f5 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cca:	c9                   	leave  
c0100ccb:	c3                   	ret    

c0100ccc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccc:	55                   	push   %ebp
c0100ccd:	89 e5                	mov    %esp,%ebp
c0100ccf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd2:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd7:	85 c0                	test   %eax,%eax
c0100cd9:	74 02                	je     c0100cdd <__panic+0x11>
        goto panic_dead;
c0100cdb:	eb 48                	jmp    c0100d25 <__panic+0x59>
    }
    is_panic = 1;
c0100cdd:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ced:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfb:	c7 04 24 66 60 10 c0 	movl   $0xc0106066,(%esp)
c0100d02:	e8 35 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d11:	89 04 24             	mov    %eax,(%esp)
c0100d14:	e8 f0 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d19:	c7 04 24 82 60 10 c0 	movl   $0xc0106082,(%esp)
c0100d20:	e8 17 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d25:	e8 85 09 00 00       	call   c01016af <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d31:	e8 b5 fe ff ff       	call   c0100beb <kmonitor>
    }
c0100d36:	eb f2                	jmp    c0100d2a <__panic+0x5e>

c0100d38 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d38:	55                   	push   %ebp
c0100d39:	89 e5                	mov    %esp,%ebp
c0100d3b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d47:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d52:	c7 04 24 84 60 10 c0 	movl   $0xc0106084,(%esp)
c0100d59:	e8 de f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d65:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d68:	89 04 24             	mov    %eax,(%esp)
c0100d6b:	e8 99 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d70:	c7 04 24 82 60 10 c0 	movl   $0xc0106082,(%esp)
c0100d77:	e8 c0 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7c:	c9                   	leave  
c0100d7d:	c3                   	ret    

c0100d7e <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7e:	55                   	push   %ebp
c0100d7f:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d81:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d86:	5d                   	pop    %ebp
c0100d87:	c3                   	ret    

c0100d88 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d88:	55                   	push   %ebp
c0100d89:	89 e5                	mov    %esp,%ebp
c0100d8b:	83 ec 28             	sub    $0x28,%esp
c0100d8e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d94:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d98:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da0:	ee                   	out    %al,(%dx)
c0100da1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100daf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db3:	ee                   	out    %al,(%dx)
c0100db4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dba:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc7:	c7 05 6c 89 11 c0 00 	movl   $0x0,0xc011896c
c0100dce:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd1:	c7 04 24 a2 60 10 c0 	movl   $0xc01060a2,(%esp)
c0100dd8:	e8 5f f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100ddd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de4:	e8 24 09 00 00       	call   c010170d <pic_enable>
}
c0100de9:	c9                   	leave  
c0100dea:	c3                   	ret    

c0100deb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100deb:	55                   	push   %ebp
c0100dec:	89 e5                	mov    %esp,%ebp
c0100dee:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df1:	9c                   	pushf  
c0100df2:	58                   	pop    %eax
c0100df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df9:	25 00 02 00 00       	and    $0x200,%eax
c0100dfe:	85 c0                	test   %eax,%eax
c0100e00:	74 0c                	je     c0100e0e <__intr_save+0x23>
        intr_disable();
c0100e02:	e8 a8 08 00 00       	call   c01016af <intr_disable>
        return 1;
c0100e07:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0c:	eb 05                	jmp    c0100e13 <__intr_save+0x28>
    }
    return 0;
c0100e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e13:	c9                   	leave  
c0100e14:	c3                   	ret    

c0100e15 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e15:	55                   	push   %ebp
c0100e16:	89 e5                	mov    %esp,%ebp
c0100e18:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e1f:	74 05                	je     c0100e26 <__intr_restore+0x11>
        intr_enable();
c0100e21:	e8 83 08 00 00       	call   c01016a9 <intr_enable>
    }
}
c0100e26:	c9                   	leave  
c0100e27:	c3                   	ret    

c0100e28 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e28:	55                   	push   %ebp
c0100e29:	89 e5                	mov    %esp,%ebp
c0100e2b:	83 ec 10             	sub    $0x10,%esp
c0100e2e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e34:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e38:	89 c2                	mov    %eax,%edx
c0100e3a:	ec                   	in     (%dx),%al
c0100e3b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e44:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e48:	89 c2                	mov    %eax,%edx
c0100e4a:	ec                   	in     (%dx),%al
c0100e4b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e54:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e58:	89 c2                	mov    %eax,%edx
c0100e5a:	ec                   	in     (%dx),%al
c0100e5b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e64:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e68:	89 c2                	mov    %eax,%edx
c0100e6a:	ec                   	in     (%dx),%al
c0100e6b:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6e:	c9                   	leave  
c0100e6f:	c3                   	ret    

c0100e70 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e70:	55                   	push   %ebp
c0100e71:	89 e5                	mov    %esp,%ebp
c0100e73:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e76:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e80:	0f b7 00             	movzwl (%eax),%eax
c0100e83:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e92:	0f b7 00             	movzwl (%eax),%eax
c0100e95:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e99:	74 12                	je     c0100ead <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea2:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea9:	b4 03 
c0100eab:	eb 13                	jmp    c0100ec0 <cga_init+0x50>
    } else {
        *cp = was;
c0100ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb7:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ebe:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec0:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec7:	0f b7 c0             	movzwl %ax,%eax
c0100eca:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ece:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eda:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100edb:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee2:	83 c0 01             	add    $0x1,%eax
c0100ee5:	0f b7 c0             	movzwl %ax,%eax
c0100ee8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eec:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef0:	89 c2                	mov    %eax,%edx
c0100ef2:	ec                   	in     (%dx),%al
c0100ef3:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efa:	0f b6 c0             	movzbl %al,%eax
c0100efd:	c1 e0 08             	shl    $0x8,%eax
c0100f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f03:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0a:	0f b7 c0             	movzwl %ax,%eax
c0100f0d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f11:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f15:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f19:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f25:	83 c0 01             	add    $0x1,%eax
c0100f28:	0f b7 c0             	movzwl %ax,%eax
c0100f2b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f33:	89 c2                	mov    %eax,%edx
c0100f35:	ec                   	in     (%dx),%al
c0100f36:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f39:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3d:	0f b6 c0             	movzbl %al,%eax
c0100f40:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f46:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4e:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f54:	c9                   	leave  
c0100f55:	c3                   	ret    

c0100f56 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f56:	55                   	push   %ebp
c0100f57:	89 e5                	mov    %esp,%ebp
c0100f59:	83 ec 48             	sub    $0x48,%esp
c0100f5c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f62:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f66:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6e:	ee                   	out    %al,(%dx)
c0100f6f:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f75:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f79:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f81:	ee                   	out    %al,(%dx)
c0100f82:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f88:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
c0100f95:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9b:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f9f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa7:	ee                   	out    %al,(%dx)
c0100fa8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fae:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fba:	ee                   	out    %al,(%dx)
c0100fbb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc1:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fcd:	ee                   	out    %al,(%dx)
c0100fce:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd4:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdc:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe0:	ee                   	out    %al,(%dx)
c0100fe1:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe7:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100feb:	89 c2                	mov    %eax,%edx
c0100fed:	ec                   	in     (%dx),%al
c0100fee:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff1:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff5:	3c ff                	cmp    $0xff,%al
c0100ff7:	0f 95 c0             	setne  %al
c0100ffa:	0f b6 c0             	movzbl %al,%eax
c0100ffd:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101002:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101008:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100c:	89 c2                	mov    %eax,%edx
c010100e:	ec                   	in     (%dx),%al
c010100f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101012:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101018:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101c:	89 c2                	mov    %eax,%edx
c010101e:	ec                   	in     (%dx),%al
c010101f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101022:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101027:	85 c0                	test   %eax,%eax
c0101029:	74 0c                	je     c0101037 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101032:	e8 d6 06 00 00       	call   c010170d <pic_enable>
    }
}
c0101037:	c9                   	leave  
c0101038:	c3                   	ret    

c0101039 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101039:	55                   	push   %ebp
c010103a:	89 e5                	mov    %esp,%ebp
c010103c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010103f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101046:	eb 09                	jmp    c0101051 <lpt_putc_sub+0x18>
        delay();
c0101048:	e8 db fd ff ff       	call   c0100e28 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101051:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101057:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105b:	89 c2                	mov    %eax,%edx
c010105d:	ec                   	in     (%dx),%al
c010105e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101061:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101065:	84 c0                	test   %al,%al
c0101067:	78 09                	js     c0101072 <lpt_putc_sub+0x39>
c0101069:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101070:	7e d6                	jle    c0101048 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101072:	8b 45 08             	mov    0x8(%ebp),%eax
c0101075:	0f b6 c0             	movzbl %al,%eax
c0101078:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107e:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101081:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101085:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101089:	ee                   	out    %al,(%dx)
c010108a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101090:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101094:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101098:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109c:	ee                   	out    %al,(%dx)
c010109d:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ab:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010af:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b0:	c9                   	leave  
c01010b1:	c3                   	ret    

c01010b2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b2:	55                   	push   %ebp
c01010b3:	89 e5                	mov    %esp,%ebp
c01010b5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bc:	74 0d                	je     c01010cb <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010be:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c1:	89 04 24             	mov    %eax,(%esp)
c01010c4:	e8 70 ff ff ff       	call   c0101039 <lpt_putc_sub>
c01010c9:	eb 24                	jmp    c01010ef <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010cb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d2:	e8 62 ff ff ff       	call   c0101039 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010de:	e8 56 ff ff ff       	call   c0101039 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010ea:	e8 4a ff ff ff       	call   c0101039 <lpt_putc_sub>
    }
}
c01010ef:	c9                   	leave  
c01010f0:	c3                   	ret    

c01010f1 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f1:	55                   	push   %ebp
c01010f2:	89 e5                	mov    %esp,%ebp
c01010f4:	53                   	push   %ebx
c01010f5:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fb:	b0 00                	mov    $0x0,%al
c01010fd:	85 c0                	test   %eax,%eax
c01010ff:	75 07                	jne    c0101108 <cga_putc+0x17>
        c |= 0x0700;
c0101101:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	0f b6 c0             	movzbl %al,%eax
c010110e:	83 f8 0a             	cmp    $0xa,%eax
c0101111:	74 4c                	je     c010115f <cga_putc+0x6e>
c0101113:	83 f8 0d             	cmp    $0xd,%eax
c0101116:	74 57                	je     c010116f <cga_putc+0x7e>
c0101118:	83 f8 08             	cmp    $0x8,%eax
c010111b:	0f 85 88 00 00 00    	jne    c01011a9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101121:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101128:	66 85 c0             	test   %ax,%ax
c010112b:	74 30                	je     c010115d <cga_putc+0x6c>
            crt_pos --;
c010112d:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101134:	83 e8 01             	sub    $0x1,%eax
c0101137:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113d:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101142:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101149:	0f b7 d2             	movzwl %dx,%edx
c010114c:	01 d2                	add    %edx,%edx
c010114e:	01 c2                	add    %eax,%edx
c0101150:	8b 45 08             	mov    0x8(%ebp),%eax
c0101153:	b0 00                	mov    $0x0,%al
c0101155:	83 c8 20             	or     $0x20,%eax
c0101158:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115b:	eb 72                	jmp    c01011cf <cga_putc+0xde>
c010115d:	eb 70                	jmp    c01011cf <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010115f:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101166:	83 c0 50             	add    $0x50,%eax
c0101169:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116f:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101176:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010117d:	0f b7 c1             	movzwl %cx,%eax
c0101180:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101186:	c1 e8 10             	shr    $0x10,%eax
c0101189:	89 c2                	mov    %eax,%edx
c010118b:	66 c1 ea 06          	shr    $0x6,%dx
c010118f:	89 d0                	mov    %edx,%eax
c0101191:	c1 e0 02             	shl    $0x2,%eax
c0101194:	01 d0                	add    %edx,%eax
c0101196:	c1 e0 04             	shl    $0x4,%eax
c0101199:	29 c1                	sub    %eax,%ecx
c010119b:	89 ca                	mov    %ecx,%edx
c010119d:	89 d8                	mov    %ebx,%eax
c010119f:	29 d0                	sub    %edx,%eax
c01011a1:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a7:	eb 26                	jmp    c01011cf <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a9:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011af:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b6:	8d 50 01             	lea    0x1(%eax),%edx
c01011b9:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011c0:	0f b7 c0             	movzwl %ax,%eax
c01011c3:	01 c0                	add    %eax,%eax
c01011c5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cb:	66 89 02             	mov    %ax,(%edx)
        break;
c01011ce:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011cf:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d6:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011da:	76 5b                	jbe    c0101237 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011dc:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e7:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ec:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f3:	00 
c01011f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f8:	89 04 24             	mov    %eax,(%esp)
c01011fb:	e8 42 4a 00 00       	call   c0105c42 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101200:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101207:	eb 15                	jmp    c010121e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101209:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010120e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101211:	01 d2                	add    %edx,%edx
c0101213:	01 d0                	add    %edx,%eax
c0101215:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101225:	7e e2                	jle    c0101209 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101227:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122e:	83 e8 50             	sub    $0x50,%eax
c0101231:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101237:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010123e:	0f b7 c0             	movzwl %ax,%eax
c0101241:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101245:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101249:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101251:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101252:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101259:	66 c1 e8 08          	shr    $0x8,%ax
c010125d:	0f b6 c0             	movzbl %al,%eax
c0101260:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101267:	83 c2 01             	add    $0x1,%edx
c010126a:	0f b7 d2             	movzwl %dx,%edx
c010126d:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101271:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101274:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101278:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127d:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101284:	0f b7 c0             	movzwl %ax,%eax
c0101287:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010128f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101293:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101297:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101298:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010129f:	0f b6 c0             	movzbl %al,%eax
c01012a2:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a9:	83 c2 01             	add    $0x1,%edx
c01012ac:	0f b7 d2             	movzwl %dx,%edx
c01012af:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012ba:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012be:	ee                   	out    %al,(%dx)
}
c01012bf:	83 c4 34             	add    $0x34,%esp
c01012c2:	5b                   	pop    %ebx
c01012c3:	5d                   	pop    %ebp
c01012c4:	c3                   	ret    

c01012c5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c5:	55                   	push   %ebp
c01012c6:	89 e5                	mov    %esp,%ebp
c01012c8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d2:	eb 09                	jmp    c01012dd <serial_putc_sub+0x18>
        delay();
c01012d4:	e8 4f fb ff ff       	call   c0100e28 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012dd:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e7:	89 c2                	mov    %eax,%edx
c01012e9:	ec                   	in     (%dx),%al
c01012ea:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f1:	0f b6 c0             	movzbl %al,%eax
c01012f4:	83 e0 20             	and    $0x20,%eax
c01012f7:	85 c0                	test   %eax,%eax
c01012f9:	75 09                	jne    c0101304 <serial_putc_sub+0x3f>
c01012fb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101302:	7e d0                	jle    c01012d4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101304:	8b 45 08             	mov    0x8(%ebp),%eax
c0101307:	0f b6 c0             	movzbl %al,%eax
c010130a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101310:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101313:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101317:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131b:	ee                   	out    %al,(%dx)
}
c010131c:	c9                   	leave  
c010131d:	c3                   	ret    

c010131e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131e:	55                   	push   %ebp
c010131f:	89 e5                	mov    %esp,%ebp
c0101321:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101324:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101328:	74 0d                	je     c0101337 <serial_putc+0x19>
        serial_putc_sub(c);
c010132a:	8b 45 08             	mov    0x8(%ebp),%eax
c010132d:	89 04 24             	mov    %eax,(%esp)
c0101330:	e8 90 ff ff ff       	call   c01012c5 <serial_putc_sub>
c0101335:	eb 24                	jmp    c010135b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101337:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133e:	e8 82 ff ff ff       	call   c01012c5 <serial_putc_sub>
        serial_putc_sub(' ');
c0101343:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134a:	e8 76 ff ff ff       	call   c01012c5 <serial_putc_sub>
        serial_putc_sub('\b');
c010134f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101356:	e8 6a ff ff ff       	call   c01012c5 <serial_putc_sub>
    }
}
c010135b:	c9                   	leave  
c010135c:	c3                   	ret    

c010135d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135d:	55                   	push   %ebp
c010135e:	89 e5                	mov    %esp,%ebp
c0101360:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101363:	eb 33                	jmp    c0101398 <cons_intr+0x3b>
        if (c != 0) {
c0101365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101369:	74 2d                	je     c0101398 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136b:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101370:	8d 50 01             	lea    0x1(%eax),%edx
c0101373:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101379:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137c:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101382:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101387:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138c:	75 0a                	jne    c0101398 <cons_intr+0x3b>
                cons.wpos = 0;
c010138e:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101395:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101398:	8b 45 08             	mov    0x8(%ebp),%eax
c010139b:	ff d0                	call   *%eax
c010139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a4:	75 bf                	jne    c0101365 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a6:	c9                   	leave  
c01013a7:	c3                   	ret    

c01013a8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a8:	55                   	push   %ebp
c01013a9:	89 e5                	mov    %esp,%ebp
c01013ab:	83 ec 10             	sub    $0x10,%esp
c01013ae:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b8:	89 c2                	mov    %eax,%edx
c01013ba:	ec                   	in     (%dx),%al
c01013bb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013be:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c2:	0f b6 c0             	movzbl %al,%eax
c01013c5:	83 e0 01             	and    $0x1,%eax
c01013c8:	85 c0                	test   %eax,%eax
c01013ca:	75 07                	jne    c01013d3 <serial_proc_data+0x2b>
        return -1;
c01013cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d1:	eb 2a                	jmp    c01013fd <serial_proc_data+0x55>
c01013d3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013dd:	89 c2                	mov    %eax,%edx
c01013df:	ec                   	in     (%dx),%al
c01013e0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e7:	0f b6 c0             	movzbl %al,%eax
c01013ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ed:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f1:	75 07                	jne    c01013fa <serial_proc_data+0x52>
        c = '\b';
c01013f3:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fd:	c9                   	leave  
c01013fe:	c3                   	ret    

c01013ff <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013ff:	55                   	push   %ebp
c0101400:	89 e5                	mov    %esp,%ebp
c0101402:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101405:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010140a:	85 c0                	test   %eax,%eax
c010140c:	74 0c                	je     c010141a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140e:	c7 04 24 a8 13 10 c0 	movl   $0xc01013a8,(%esp)
c0101415:	e8 43 ff ff ff       	call   c010135d <cons_intr>
    }
}
c010141a:	c9                   	leave  
c010141b:	c3                   	ret    

c010141c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141c:	55                   	push   %ebp
c010141d:	89 e5                	mov    %esp,%ebp
c010141f:	83 ec 38             	sub    $0x38,%esp
c0101422:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101428:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142c:	89 c2                	mov    %eax,%edx
c010142e:	ec                   	in     (%dx),%al
c010142f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101432:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101436:	0f b6 c0             	movzbl %al,%eax
c0101439:	83 e0 01             	and    $0x1,%eax
c010143c:	85 c0                	test   %eax,%eax
c010143e:	75 0a                	jne    c010144a <kbd_proc_data+0x2e>
        return -1;
c0101440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101445:	e9 59 01 00 00       	jmp    c01015a3 <kbd_proc_data+0x187>
c010144a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101450:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101454:	89 c2                	mov    %eax,%edx
c0101456:	ec                   	in     (%dx),%al
c0101457:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101461:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101465:	75 17                	jne    c010147e <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101467:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146c:	83 c8 40             	or     $0x40,%eax
c010146f:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101474:	b8 00 00 00 00       	mov    $0x0,%eax
c0101479:	e9 25 01 00 00       	jmp    c01015a3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101482:	84 c0                	test   %al,%al
c0101484:	79 47                	jns    c01014cd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101486:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010148b:	83 e0 40             	and    $0x40,%eax
c010148e:	85 c0                	test   %eax,%eax
c0101490:	75 09                	jne    c010149b <kbd_proc_data+0x7f>
c0101492:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101496:	83 e0 7f             	and    $0x7f,%eax
c0101499:	eb 04                	jmp    c010149f <kbd_proc_data+0x83>
c010149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149f:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a6:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ad:	83 c8 40             	or     $0x40,%eax
c01014b0:	0f b6 c0             	movzbl %al,%eax
c01014b3:	f7 d0                	not    %eax
c01014b5:	89 c2                	mov    %eax,%edx
c01014b7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bc:	21 d0                	and    %edx,%eax
c01014be:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c8:	e9 d6 00 00 00       	jmp    c01015a3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014cd:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d2:	83 e0 40             	and    $0x40,%eax
c01014d5:	85 c0                	test   %eax,%eax
c01014d7:	74 11                	je     c01014ea <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014dd:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e2:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e5:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ee:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f5:	0f b6 d0             	movzbl %al,%edx
c01014f8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fd:	09 d0                	or     %edx,%eax
c01014ff:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101504:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101508:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c010150f:	0f b6 d0             	movzbl %al,%edx
c0101512:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101517:	31 d0                	xor    %edx,%eax
c0101519:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151e:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101523:	83 e0 03             	and    $0x3,%eax
c0101526:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101531:	01 d0                	add    %edx,%eax
c0101533:	0f b6 00             	movzbl (%eax),%eax
c0101536:	0f b6 c0             	movzbl %al,%eax
c0101539:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101541:	83 e0 08             	and    $0x8,%eax
c0101544:	85 c0                	test   %eax,%eax
c0101546:	74 22                	je     c010156a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101548:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154c:	7e 0c                	jle    c010155a <kbd_proc_data+0x13e>
c010154e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101552:	7f 06                	jg     c010155a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101554:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101558:	eb 10                	jmp    c010156a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155e:	7e 0a                	jle    c010156a <kbd_proc_data+0x14e>
c0101560:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101564:	7f 04                	jg     c010156a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101566:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156a:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010156f:	f7 d0                	not    %eax
c0101571:	83 e0 06             	and    $0x6,%eax
c0101574:	85 c0                	test   %eax,%eax
c0101576:	75 28                	jne    c01015a0 <kbd_proc_data+0x184>
c0101578:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010157f:	75 1f                	jne    c01015a0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101581:	c7 04 24 bd 60 10 c0 	movl   $0xc01060bd,(%esp)
c0101588:	e8 af ed ff ff       	call   c010033c <cprintf>
c010158d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101593:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101597:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159b:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010159f:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a3:	c9                   	leave  
c01015a4:	c3                   	ret    

c01015a5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a5:	55                   	push   %ebp
c01015a6:	89 e5                	mov    %esp,%ebp
c01015a8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ab:	c7 04 24 1c 14 10 c0 	movl   $0xc010141c,(%esp)
c01015b2:	e8 a6 fd ff ff       	call   c010135d <cons_intr>
}
c01015b7:	c9                   	leave  
c01015b8:	c3                   	ret    

c01015b9 <kbd_init>:

static void
kbd_init(void) {
c01015b9:	55                   	push   %ebp
c01015ba:	89 e5                	mov    %esp,%ebp
c01015bc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015bf:	e8 e1 ff ff ff       	call   c01015a5 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015cb:	e8 3d 01 00 00       	call   c010170d <pic_enable>
}
c01015d0:	c9                   	leave  
c01015d1:	c3                   	ret    

c01015d2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d2:	55                   	push   %ebp
c01015d3:	89 e5                	mov    %esp,%ebp
c01015d5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d8:	e8 93 f8 ff ff       	call   c0100e70 <cga_init>
    serial_init();
c01015dd:	e8 74 f9 ff ff       	call   c0100f56 <serial_init>
    kbd_init();
c01015e2:	e8 d2 ff ff ff       	call   c01015b9 <kbd_init>
    if (!serial_exists) {
c01015e7:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015ec:	85 c0                	test   %eax,%eax
c01015ee:	75 0c                	jne    c01015fc <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f0:	c7 04 24 c9 60 10 c0 	movl   $0xc01060c9,(%esp)
c01015f7:	e8 40 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015fc:	c9                   	leave  
c01015fd:	c3                   	ret    

c01015fe <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015fe:	55                   	push   %ebp
c01015ff:	89 e5                	mov    %esp,%ebp
c0101601:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101604:	e8 e2 f7 ff ff       	call   c0100deb <__intr_save>
c0101609:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160c:	8b 45 08             	mov    0x8(%ebp),%eax
c010160f:	89 04 24             	mov    %eax,(%esp)
c0101612:	e8 9b fa ff ff       	call   c01010b2 <lpt_putc>
        cga_putc(c);
c0101617:	8b 45 08             	mov    0x8(%ebp),%eax
c010161a:	89 04 24             	mov    %eax,(%esp)
c010161d:	e8 cf fa ff ff       	call   c01010f1 <cga_putc>
        serial_putc(c);
c0101622:	8b 45 08             	mov    0x8(%ebp),%eax
c0101625:	89 04 24             	mov    %eax,(%esp)
c0101628:	e8 f1 fc ff ff       	call   c010131e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101630:	89 04 24             	mov    %eax,(%esp)
c0101633:	e8 dd f7 ff ff       	call   c0100e15 <__intr_restore>
}
c0101638:	c9                   	leave  
c0101639:	c3                   	ret    

c010163a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163a:	55                   	push   %ebp
c010163b:	89 e5                	mov    %esp,%ebp
c010163d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101640:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101647:	e8 9f f7 ff ff       	call   c0100deb <__intr_save>
c010164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164f:	e8 ab fd ff ff       	call   c01013ff <serial_intr>
        kbd_intr();
c0101654:	e8 4c ff ff ff       	call   c01015a5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101659:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010165f:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101664:	39 c2                	cmp    %eax,%edx
c0101666:	74 31                	je     c0101699 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101668:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166d:	8d 50 01             	lea    0x1(%eax),%edx
c0101670:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101676:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167d:	0f b6 c0             	movzbl %al,%eax
c0101680:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101683:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101688:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168d:	75 0a                	jne    c0101699 <cons_getc+0x5f>
                cons.rpos = 0;
c010168f:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101696:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101699:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169c:	89 04 24             	mov    %eax,(%esp)
c010169f:	e8 71 f7 ff ff       	call   c0100e15 <__intr_restore>
    return c;
c01016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a7:	c9                   	leave  
c01016a8:	c3                   	ret    

c01016a9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016ac:	fb                   	sti    
    sti();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b2:	fa                   	cli    
    cli();
}
c01016b3:	5d                   	pop    %ebp
c01016b4:	c3                   	ret    

c01016b5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b5:	55                   	push   %ebp
c01016b6:	89 e5                	mov    %esp,%ebp
c01016b8:	83 ec 14             	sub    $0x14,%esp
c01016bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01016be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c6:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cc:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d1:	85 c0                	test   %eax,%eax
c01016d3:	74 36                	je     c010170b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d9:	0f b6 c0             	movzbl %al,%eax
c01016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e2:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e5:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e9:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ed:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ee:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f2:	66 c1 e8 08          	shr    $0x8,%ax
c01016f6:	0f b6 c0             	movzbl %al,%eax
c01016f9:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016ff:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101702:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101706:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170a:	ee                   	out    %al,(%dx)
    }
}
c010170b:	c9                   	leave  
c010170c:	c3                   	ret    

c010170d <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170d:	55                   	push   %ebp
c010170e:	89 e5                	mov    %esp,%ebp
c0101710:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101713:	8b 45 08             	mov    0x8(%ebp),%eax
c0101716:	ba 01 00 00 00       	mov    $0x1,%edx
c010171b:	89 c1                	mov    %eax,%ecx
c010171d:	d3 e2                	shl    %cl,%edx
c010171f:	89 d0                	mov    %edx,%eax
c0101721:	f7 d0                	not    %eax
c0101723:	89 c2                	mov    %eax,%edx
c0101725:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172c:	21 d0                	and    %edx,%eax
c010172e:	0f b7 c0             	movzwl %ax,%eax
c0101731:	89 04 24             	mov    %eax,(%esp)
c0101734:	e8 7c ff ff ff       	call   c01016b5 <pic_setmask>
}
c0101739:	c9                   	leave  
c010173a:	c3                   	ret    

c010173b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173b:	55                   	push   %ebp
c010173c:	89 e5                	mov    %esp,%ebp
c010173e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101741:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101748:	00 00 00 
c010174b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101751:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101755:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101759:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175d:	ee                   	out    %al,(%dx)
c010175e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101764:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101768:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101770:	ee                   	out    %al,(%dx)
c0101771:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101777:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101783:	ee                   	out    %al,(%dx)
c0101784:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178a:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101792:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
c0101797:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179d:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a9:	ee                   	out    %al,(%dx)
c01017aa:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bc:	ee                   	out    %al,(%dx)
c01017bd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c3:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017cf:	ee                   	out    %al,(%dx)
c01017d0:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d6:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017da:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017de:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e2:	ee                   	out    %al,(%dx)
c01017e3:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e9:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ed:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f5:	ee                   	out    %al,(%dx)
c01017f6:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fc:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101800:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101804:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101808:	ee                   	out    %al,(%dx)
c0101809:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010180f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101813:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101817:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181b:	ee                   	out    %al,(%dx)
c010181c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101822:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101826:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182e:	ee                   	out    %al,(%dx)
c010182f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101835:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101839:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101841:	ee                   	out    %al,(%dx)
c0101842:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101848:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101850:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101854:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101855:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185c:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101860:	74 12                	je     c0101874 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101862:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101869:	0f b7 c0             	movzwl %ax,%eax
c010186c:	89 04 24             	mov    %eax,(%esp)
c010186f:	e8 41 fe ff ff       	call   c01016b5 <pic_setmask>
    }
}
c0101874:	c9                   	leave  
c0101875:	c3                   	ret    

c0101876 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101876:	55                   	push   %ebp
c0101877:	89 e5                	mov    %esp,%ebp
c0101879:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101883:	00 
c0101884:	c7 04 24 00 61 10 c0 	movl   $0xc0106100,(%esp)
c010188b:	e8 ac ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101890:	c9                   	leave  
c0101891:	c3                   	ret    

c0101892 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101892:	55                   	push   %ebp
c0101893:	89 e5                	mov    %esp,%ebp
c0101895:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
	int i;
	for( i=0;i<256;i++){
c0101898:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010189f:	e9 c3 00 00 00       	jmp    c0101967 <idt_init+0xd5>
		SETGATE(idt[i],0,KERNEL_CS,__vectors[i],0);       //用法：SETGATE(gate, istrap, sel, off, dpl)
c01018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018a7:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018ae:	89 c2                	mov    %eax,%edx
c01018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b3:	66 89 14 c5 e0 80 11 	mov    %dx,-0x3fee7f20(,%eax,8)
c01018ba:	c0 
c01018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018be:	66 c7 04 c5 e2 80 11 	movw   $0x8,-0x3fee7f1e(,%eax,8)
c01018c5:	c0 08 00 
c01018c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cb:	0f b6 14 c5 e4 80 11 	movzbl -0x3fee7f1c(,%eax,8),%edx
c01018d2:	c0 
c01018d3:	83 e2 e0             	and    $0xffffffe0,%edx
c01018d6:	88 14 c5 e4 80 11 c0 	mov    %dl,-0x3fee7f1c(,%eax,8)
c01018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e0:	0f b6 14 c5 e4 80 11 	movzbl -0x3fee7f1c(,%eax,8),%edx
c01018e7:	c0 
c01018e8:	83 e2 1f             	and    $0x1f,%edx
c01018eb:	88 14 c5 e4 80 11 c0 	mov    %dl,-0x3fee7f1c(,%eax,8)
c01018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f5:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c01018fc:	c0 
c01018fd:	83 e2 f0             	and    $0xfffffff0,%edx
c0101900:	83 ca 0e             	or     $0xe,%edx
c0101903:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c010190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190d:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c0101914:	c0 
c0101915:	83 e2 ef             	and    $0xffffffef,%edx
c0101918:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c010191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101922:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c0101929:	c0 
c010192a:	83 e2 9f             	and    $0xffffff9f,%edx
c010192d:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c0101934:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101937:	0f b6 14 c5 e5 80 11 	movzbl -0x3fee7f1b(,%eax,8),%edx
c010193e:	c0 
c010193f:	83 ca 80             	or     $0xffffff80,%edx
c0101942:	88 14 c5 e5 80 11 c0 	mov    %dl,-0x3fee7f1b(,%eax,8)
c0101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194c:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101953:	c1 e8 10             	shr    $0x10,%eax
c0101956:	89 c2                	mov    %eax,%edx
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	66 89 14 c5 e6 80 11 	mov    %dx,-0x3fee7f1a(,%eax,8)
c0101962:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
	int i;
	for( i=0;i<256;i++){
c0101963:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101967:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010196e:	0f 8e 30 ff ff ff    	jle    c01018a4 <idt_init+0x12>
c0101974:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010197e:	0f 01 18             	lidtl  (%eax)
		SETGATE(idt[i],0,KERNEL_CS,__vectors[i],0);       //用法：SETGATE(gate, istrap, sel, off, dpl)
	}
	lidt(&idt_pd);

}
c0101981:	c9                   	leave  
c0101982:	c3                   	ret    

c0101983 <trapname>:

static const char *
trapname(int trapno) {
c0101983:	55                   	push   %ebp
c0101984:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101986:	8b 45 08             	mov    0x8(%ebp),%eax
c0101989:	83 f8 13             	cmp    $0x13,%eax
c010198c:	77 0c                	ja     c010199a <trapname+0x17>
        return excnames[trapno];
c010198e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101991:	8b 04 85 60 64 10 c0 	mov    -0x3fef9ba0(,%eax,4),%eax
c0101998:	eb 18                	jmp    c01019b2 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010199a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010199e:	7e 0d                	jle    c01019ad <trapname+0x2a>
c01019a0:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019a4:	7f 07                	jg     c01019ad <trapname+0x2a>
        return "Hardware Interrupt";
c01019a6:	b8 0a 61 10 c0       	mov    $0xc010610a,%eax
c01019ab:	eb 05                	jmp    c01019b2 <trapname+0x2f>
    }
    return "(unknown trap)";
c01019ad:	b8 1d 61 10 c0       	mov    $0xc010611d,%eax
}
c01019b2:	5d                   	pop    %ebp
c01019b3:	c3                   	ret    

c01019b4 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019b4:	55                   	push   %ebp
c01019b5:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ba:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019be:	66 83 f8 08          	cmp    $0x8,%ax
c01019c2:	0f 94 c0             	sete   %al
c01019c5:	0f b6 c0             	movzbl %al,%eax
}
c01019c8:	5d                   	pop    %ebp
c01019c9:	c3                   	ret    

c01019ca <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019ca:	55                   	push   %ebp
c01019cb:	89 e5                	mov    %esp,%ebp
c01019cd:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019d7:	c7 04 24 5e 61 10 c0 	movl   $0xc010615e,(%esp)
c01019de:	e8 59 e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c01019e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e6:	89 04 24             	mov    %eax,(%esp)
c01019e9:	e8 a1 01 00 00       	call   c0101b8f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01019ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01019f5:	0f b7 c0             	movzwl %ax,%eax
c01019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fc:	c7 04 24 6f 61 10 c0 	movl   $0xc010616f,(%esp)
c0101a03:	e8 34 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0b:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a0f:	0f b7 c0             	movzwl %ax,%eax
c0101a12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a16:	c7 04 24 82 61 10 c0 	movl   $0xc0106182,(%esp)
c0101a1d:	e8 1a e9 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a22:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a25:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a29:	0f b7 c0             	movzwl %ax,%eax
c0101a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a30:	c7 04 24 95 61 10 c0 	movl   $0xc0106195,(%esp)
c0101a37:	e8 00 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a3f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a43:	0f b7 c0             	movzwl %ax,%eax
c0101a46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a4a:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c0101a51:	e8 e6 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a59:	8b 40 30             	mov    0x30(%eax),%eax
c0101a5c:	89 04 24             	mov    %eax,(%esp)
c0101a5f:	e8 1f ff ff ff       	call   c0101983 <trapname>
c0101a64:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a67:	8b 52 30             	mov    0x30(%edx),%edx
c0101a6a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a6e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a72:	c7 04 24 bb 61 10 c0 	movl   $0xc01061bb,(%esp)
c0101a79:	e8 be e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a81:	8b 40 34             	mov    0x34(%eax),%eax
c0101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a88:	c7 04 24 cd 61 10 c0 	movl   $0xc01061cd,(%esp)
c0101a8f:	e8 a8 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a97:	8b 40 38             	mov    0x38(%eax),%eax
c0101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9e:	c7 04 24 dc 61 10 c0 	movl   $0xc01061dc,(%esp)
c0101aa5:	e8 92 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aad:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ab1:	0f b7 c0             	movzwl %ax,%eax
c0101ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab8:	c7 04 24 eb 61 10 c0 	movl   $0xc01061eb,(%esp)
c0101abf:	e8 78 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac7:	8b 40 40             	mov    0x40(%eax),%eax
c0101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ace:	c7 04 24 fe 61 10 c0 	movl   $0xc01061fe,(%esp)
c0101ad5:	e8 62 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ada:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ae1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101ae8:	eb 3e                	jmp    c0101b28 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aed:	8b 50 40             	mov    0x40(%eax),%edx
c0101af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101af3:	21 d0                	and    %edx,%eax
c0101af5:	85 c0                	test   %eax,%eax
c0101af7:	74 28                	je     c0101b21 <print_trapframe+0x157>
c0101af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101afc:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b03:	85 c0                	test   %eax,%eax
c0101b05:	74 1a                	je     c0101b21 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b0a:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b15:	c7 04 24 0d 62 10 c0 	movl   $0xc010620d,(%esp)
c0101b1c:	e8 1b e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b21:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b25:	d1 65 f0             	shll   -0x10(%ebp)
c0101b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b2b:	83 f8 17             	cmp    $0x17,%eax
c0101b2e:	76 ba                	jbe    c0101aea <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b33:	8b 40 40             	mov    0x40(%eax),%eax
c0101b36:	25 00 30 00 00       	and    $0x3000,%eax
c0101b3b:	c1 e8 0c             	shr    $0xc,%eax
c0101b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b42:	c7 04 24 11 62 10 c0 	movl   $0xc0106211,(%esp)
c0101b49:	e8 ee e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b51:	89 04 24             	mov    %eax,(%esp)
c0101b54:	e8 5b fe ff ff       	call   c01019b4 <trap_in_kernel>
c0101b59:	85 c0                	test   %eax,%eax
c0101b5b:	75 30                	jne    c0101b8d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b60:	8b 40 44             	mov    0x44(%eax),%eax
c0101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b67:	c7 04 24 1a 62 10 c0 	movl   $0xc010621a,(%esp)
c0101b6e:	e8 c9 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b76:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b7a:	0f b7 c0             	movzwl %ax,%eax
c0101b7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b81:	c7 04 24 29 62 10 c0 	movl   $0xc0106229,(%esp)
c0101b88:	e8 af e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101b8d:	c9                   	leave  
c0101b8e:	c3                   	ret    

c0101b8f <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101b8f:	55                   	push   %ebp
c0101b90:	89 e5                	mov    %esp,%ebp
c0101b92:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b98:	8b 00                	mov    (%eax),%eax
c0101b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9e:	c7 04 24 3c 62 10 c0 	movl   $0xc010623c,(%esp)
c0101ba5:	e8 92 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bad:	8b 40 04             	mov    0x4(%eax),%eax
c0101bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb4:	c7 04 24 4b 62 10 c0 	movl   $0xc010624b,(%esp)
c0101bbb:	e8 7c e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc3:	8b 40 08             	mov    0x8(%eax),%eax
c0101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bca:	c7 04 24 5a 62 10 c0 	movl   $0xc010625a,(%esp)
c0101bd1:	e8 66 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd9:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be0:	c7 04 24 69 62 10 c0 	movl   $0xc0106269,(%esp)
c0101be7:	e8 50 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101bec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bef:	8b 40 10             	mov    0x10(%eax),%eax
c0101bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf6:	c7 04 24 78 62 10 c0 	movl   $0xc0106278,(%esp)
c0101bfd:	e8 3a e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c05:	8b 40 14             	mov    0x14(%eax),%eax
c0101c08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0c:	c7 04 24 87 62 10 c0 	movl   $0xc0106287,(%esp)
c0101c13:	e8 24 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1b:	8b 40 18             	mov    0x18(%eax),%eax
c0101c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c22:	c7 04 24 96 62 10 c0 	movl   $0xc0106296,(%esp)
c0101c29:	e8 0e e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c31:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c38:	c7 04 24 a5 62 10 c0 	movl   $0xc01062a5,(%esp)
c0101c3f:	e8 f8 e6 ff ff       	call   c010033c <cprintf>
}
c0101c44:	c9                   	leave  
c0101c45:	c3                   	ret    

c0101c46 <trap_dispatch>:
int tick_count=0;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c46:	55                   	push   %ebp
c0101c47:	89 e5                	mov    %esp,%ebp
c0101c49:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4f:	8b 40 30             	mov    0x30(%eax),%eax
c0101c52:	83 f8 2f             	cmp    $0x2f,%eax
c0101c55:	77 1d                	ja     c0101c74 <trap_dispatch+0x2e>
c0101c57:	83 f8 2e             	cmp    $0x2e,%eax
c0101c5a:	0f 83 f2 00 00 00    	jae    c0101d52 <trap_dispatch+0x10c>
c0101c60:	83 f8 21             	cmp    $0x21,%eax
c0101c63:	74 73                	je     c0101cd8 <trap_dispatch+0x92>
c0101c65:	83 f8 24             	cmp    $0x24,%eax
c0101c68:	74 48                	je     c0101cb2 <trap_dispatch+0x6c>
c0101c6a:	83 f8 20             	cmp    $0x20,%eax
c0101c6d:	74 13                	je     c0101c82 <trap_dispatch+0x3c>
c0101c6f:	e9 a6 00 00 00       	jmp    c0101d1a <trap_dispatch+0xd4>
c0101c74:	83 e8 78             	sub    $0x78,%eax
c0101c77:	83 f8 01             	cmp    $0x1,%eax
c0101c7a:	0f 87 9a 00 00 00    	ja     c0101d1a <trap_dispatch+0xd4>
c0101c80:	eb 7c                	jmp    c0101cfe <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    tick_count++;
c0101c82:	a1 c0 80 11 c0       	mov    0xc01180c0,%eax
c0101c87:	83 c0 01             	add    $0x1,%eax
c0101c8a:	a3 c0 80 11 c0       	mov    %eax,0xc01180c0
    if(tick_count==TICK_NUM){
c0101c8f:	a1 c0 80 11 c0       	mov    0xc01180c0,%eax
c0101c94:	83 f8 64             	cmp    $0x64,%eax
c0101c97:	75 14                	jne    c0101cad <trap_dispatch+0x67>
    	print_ticks();
c0101c99:	e8 d8 fb ff ff       	call   c0101876 <print_ticks>
    	tick_count=0;
c0101c9e:	c7 05 c0 80 11 c0 00 	movl   $0x0,0xc01180c0
c0101ca5:	00 00 00 
    }
        break;
c0101ca8:	e9 a6 00 00 00       	jmp    c0101d53 <trap_dispatch+0x10d>
c0101cad:	e9 a1 00 00 00       	jmp    c0101d53 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101cb2:	e8 83 f9 ff ff       	call   c010163a <cons_getc>
c0101cb7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101cba:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cbe:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cc2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cca:	c7 04 24 b4 62 10 c0 	movl   $0xc01062b4,(%esp)
c0101cd1:	e8 66 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101cd6:	eb 7b                	jmp    c0101d53 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101cd8:	e8 5d f9 ff ff       	call   c010163a <cons_getc>
c0101cdd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101ce0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101ce4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ce8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 c6 62 10 c0 	movl   $0xc01062c6,(%esp)
c0101cf7:	e8 40 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101cfc:	eb 55                	jmp    c0101d53 <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101cfe:	c7 44 24 08 d5 62 10 	movl   $0xc01062d5,0x8(%esp)
c0101d05:	c0 
c0101d06:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0101d0d:	00 
c0101d0e:	c7 04 24 e5 62 10 c0 	movl   $0xc01062e5,(%esp)
c0101d15:	e8 b2 ef ff ff       	call   c0100ccc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d1d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d21:	0f b7 c0             	movzwl %ax,%eax
c0101d24:	83 e0 03             	and    $0x3,%eax
c0101d27:	85 c0                	test   %eax,%eax
c0101d29:	75 28                	jne    c0101d53 <trap_dispatch+0x10d>
            print_trapframe(tf);
c0101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2e:	89 04 24             	mov    %eax,(%esp)
c0101d31:	e8 94 fc ff ff       	call   c01019ca <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d36:	c7 44 24 08 f6 62 10 	movl   $0xc01062f6,0x8(%esp)
c0101d3d:	c0 
c0101d3e:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0101d45:	00 
c0101d46:	c7 04 24 e5 62 10 c0 	movl   $0xc01062e5,(%esp)
c0101d4d:	e8 7a ef ff ff       	call   c0100ccc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d52:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d53:	c9                   	leave  
c0101d54:	c3                   	ret    

c0101d55 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d55:	55                   	push   %ebp
c0101d56:	89 e5                	mov    %esp,%ebp
c0101d58:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d5e:	89 04 24             	mov    %eax,(%esp)
c0101d61:	e8 e0 fe ff ff       	call   c0101c46 <trap_dispatch>
}
c0101d66:	c9                   	leave  
c0101d67:	c3                   	ret    

c0101d68 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d68:	1e                   	push   %ds
    pushl %es
c0101d69:	06                   	push   %es
    pushl %fs
c0101d6a:	0f a0                	push   %fs
    pushl %gs
c0101d6c:	0f a8                	push   %gs
    pushal
c0101d6e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101d6f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101d74:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101d76:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101d78:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101d79:	e8 d7 ff ff ff       	call   c0101d55 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101d7e:	5c                   	pop    %esp

c0101d7f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101d7f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101d80:	0f a9                	pop    %gs
    popl %fs
c0101d82:	0f a1                	pop    %fs
    popl %es
c0101d84:	07                   	pop    %es
    popl %ds
c0101d85:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101d86:	83 c4 08             	add    $0x8,%esp
    iret
c0101d89:	cf                   	iret   

c0101d8a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101d8a:	6a 00                	push   $0x0
  pushl $0
c0101d8c:	6a 00                	push   $0x0
  jmp __alltraps
c0101d8e:	e9 d5 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101d93 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101d93:	6a 00                	push   $0x0
  pushl $1
c0101d95:	6a 01                	push   $0x1
  jmp __alltraps
c0101d97:	e9 cc ff ff ff       	jmp    c0101d68 <__alltraps>

c0101d9c <vector2>:
.globl vector2
vector2:
  pushl $0
c0101d9c:	6a 00                	push   $0x0
  pushl $2
c0101d9e:	6a 02                	push   $0x2
  jmp __alltraps
c0101da0:	e9 c3 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101da5 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101da5:	6a 00                	push   $0x0
  pushl $3
c0101da7:	6a 03                	push   $0x3
  jmp __alltraps
c0101da9:	e9 ba ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dae <vector4>:
.globl vector4
vector4:
  pushl $0
c0101dae:	6a 00                	push   $0x0
  pushl $4
c0101db0:	6a 04                	push   $0x4
  jmp __alltraps
c0101db2:	e9 b1 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101db7 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101db7:	6a 00                	push   $0x0
  pushl $5
c0101db9:	6a 05                	push   $0x5
  jmp __alltraps
c0101dbb:	e9 a8 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dc0 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101dc0:	6a 00                	push   $0x0
  pushl $6
c0101dc2:	6a 06                	push   $0x6
  jmp __alltraps
c0101dc4:	e9 9f ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dc9 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dc9:	6a 00                	push   $0x0
  pushl $7
c0101dcb:	6a 07                	push   $0x7
  jmp __alltraps
c0101dcd:	e9 96 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dd2 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101dd2:	6a 08                	push   $0x8
  jmp __alltraps
c0101dd4:	e9 8f ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dd9 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101dd9:	6a 09                	push   $0x9
  jmp __alltraps
c0101ddb:	e9 88 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101de0 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101de0:	6a 0a                	push   $0xa
  jmp __alltraps
c0101de2:	e9 81 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101de7 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101de7:	6a 0b                	push   $0xb
  jmp __alltraps
c0101de9:	e9 7a ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dee <vector12>:
.globl vector12
vector12:
  pushl $12
c0101dee:	6a 0c                	push   $0xc
  jmp __alltraps
c0101df0:	e9 73 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101df5 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101df5:	6a 0d                	push   $0xd
  jmp __alltraps
c0101df7:	e9 6c ff ff ff       	jmp    c0101d68 <__alltraps>

c0101dfc <vector14>:
.globl vector14
vector14:
  pushl $14
c0101dfc:	6a 0e                	push   $0xe
  jmp __alltraps
c0101dfe:	e9 65 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e03 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e03:	6a 00                	push   $0x0
  pushl $15
c0101e05:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e07:	e9 5c ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e0c <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e0c:	6a 00                	push   $0x0
  pushl $16
c0101e0e:	6a 10                	push   $0x10
  jmp __alltraps
c0101e10:	e9 53 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e15 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e15:	6a 11                	push   $0x11
  jmp __alltraps
c0101e17:	e9 4c ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e1c <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e1c:	6a 00                	push   $0x0
  pushl $18
c0101e1e:	6a 12                	push   $0x12
  jmp __alltraps
c0101e20:	e9 43 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e25 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e25:	6a 00                	push   $0x0
  pushl $19
c0101e27:	6a 13                	push   $0x13
  jmp __alltraps
c0101e29:	e9 3a ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e2e <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e2e:	6a 00                	push   $0x0
  pushl $20
c0101e30:	6a 14                	push   $0x14
  jmp __alltraps
c0101e32:	e9 31 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e37 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e37:	6a 00                	push   $0x0
  pushl $21
c0101e39:	6a 15                	push   $0x15
  jmp __alltraps
c0101e3b:	e9 28 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e40 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e40:	6a 00                	push   $0x0
  pushl $22
c0101e42:	6a 16                	push   $0x16
  jmp __alltraps
c0101e44:	e9 1f ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e49 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e49:	6a 00                	push   $0x0
  pushl $23
c0101e4b:	6a 17                	push   $0x17
  jmp __alltraps
c0101e4d:	e9 16 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e52 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e52:	6a 00                	push   $0x0
  pushl $24
c0101e54:	6a 18                	push   $0x18
  jmp __alltraps
c0101e56:	e9 0d ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e5b <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  pushl $25
c0101e5d:	6a 19                	push   $0x19
  jmp __alltraps
c0101e5f:	e9 04 ff ff ff       	jmp    c0101d68 <__alltraps>

c0101e64 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e64:	6a 00                	push   $0x0
  pushl $26
c0101e66:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e68:	e9 fb fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e6d <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e6d:	6a 00                	push   $0x0
  pushl $27
c0101e6f:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e71:	e9 f2 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e76 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e76:	6a 00                	push   $0x0
  pushl $28
c0101e78:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101e7a:	e9 e9 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e7f <vector29>:
.globl vector29
vector29:
  pushl $0
c0101e7f:	6a 00                	push   $0x0
  pushl $29
c0101e81:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101e83:	e9 e0 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e88 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101e88:	6a 00                	push   $0x0
  pushl $30
c0101e8a:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101e8c:	e9 d7 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e91 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101e91:	6a 00                	push   $0x0
  pushl $31
c0101e93:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101e95:	e9 ce fe ff ff       	jmp    c0101d68 <__alltraps>

c0101e9a <vector32>:
.globl vector32
vector32:
  pushl $0
c0101e9a:	6a 00                	push   $0x0
  pushl $32
c0101e9c:	6a 20                	push   $0x20
  jmp __alltraps
c0101e9e:	e9 c5 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ea3 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ea3:	6a 00                	push   $0x0
  pushl $33
c0101ea5:	6a 21                	push   $0x21
  jmp __alltraps
c0101ea7:	e9 bc fe ff ff       	jmp    c0101d68 <__alltraps>

c0101eac <vector34>:
.globl vector34
vector34:
  pushl $0
c0101eac:	6a 00                	push   $0x0
  pushl $34
c0101eae:	6a 22                	push   $0x22
  jmp __alltraps
c0101eb0:	e9 b3 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101eb5 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101eb5:	6a 00                	push   $0x0
  pushl $35
c0101eb7:	6a 23                	push   $0x23
  jmp __alltraps
c0101eb9:	e9 aa fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ebe <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ebe:	6a 00                	push   $0x0
  pushl $36
c0101ec0:	6a 24                	push   $0x24
  jmp __alltraps
c0101ec2:	e9 a1 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ec7 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ec7:	6a 00                	push   $0x0
  pushl $37
c0101ec9:	6a 25                	push   $0x25
  jmp __alltraps
c0101ecb:	e9 98 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ed0 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ed0:	6a 00                	push   $0x0
  pushl $38
c0101ed2:	6a 26                	push   $0x26
  jmp __alltraps
c0101ed4:	e9 8f fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ed9 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101ed9:	6a 00                	push   $0x0
  pushl $39
c0101edb:	6a 27                	push   $0x27
  jmp __alltraps
c0101edd:	e9 86 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ee2 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101ee2:	6a 00                	push   $0x0
  pushl $40
c0101ee4:	6a 28                	push   $0x28
  jmp __alltraps
c0101ee6:	e9 7d fe ff ff       	jmp    c0101d68 <__alltraps>

c0101eeb <vector41>:
.globl vector41
vector41:
  pushl $0
c0101eeb:	6a 00                	push   $0x0
  pushl $41
c0101eed:	6a 29                	push   $0x29
  jmp __alltraps
c0101eef:	e9 74 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101ef4 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101ef4:	6a 00                	push   $0x0
  pushl $42
c0101ef6:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101ef8:	e9 6b fe ff ff       	jmp    c0101d68 <__alltraps>

c0101efd <vector43>:
.globl vector43
vector43:
  pushl $0
c0101efd:	6a 00                	push   $0x0
  pushl $43
c0101eff:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f01:	e9 62 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f06 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f06:	6a 00                	push   $0x0
  pushl $44
c0101f08:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f0a:	e9 59 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f0f <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f0f:	6a 00                	push   $0x0
  pushl $45
c0101f11:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f13:	e9 50 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f18 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f18:	6a 00                	push   $0x0
  pushl $46
c0101f1a:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f1c:	e9 47 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f21 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f21:	6a 00                	push   $0x0
  pushl $47
c0101f23:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f25:	e9 3e fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f2a <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f2a:	6a 00                	push   $0x0
  pushl $48
c0101f2c:	6a 30                	push   $0x30
  jmp __alltraps
c0101f2e:	e9 35 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f33 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f33:	6a 00                	push   $0x0
  pushl $49
c0101f35:	6a 31                	push   $0x31
  jmp __alltraps
c0101f37:	e9 2c fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f3c <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f3c:	6a 00                	push   $0x0
  pushl $50
c0101f3e:	6a 32                	push   $0x32
  jmp __alltraps
c0101f40:	e9 23 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f45 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f45:	6a 00                	push   $0x0
  pushl $51
c0101f47:	6a 33                	push   $0x33
  jmp __alltraps
c0101f49:	e9 1a fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f4e <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f4e:	6a 00                	push   $0x0
  pushl $52
c0101f50:	6a 34                	push   $0x34
  jmp __alltraps
c0101f52:	e9 11 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f57 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f57:	6a 00                	push   $0x0
  pushl $53
c0101f59:	6a 35                	push   $0x35
  jmp __alltraps
c0101f5b:	e9 08 fe ff ff       	jmp    c0101d68 <__alltraps>

c0101f60 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f60:	6a 00                	push   $0x0
  pushl $54
c0101f62:	6a 36                	push   $0x36
  jmp __alltraps
c0101f64:	e9 ff fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f69 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f69:	6a 00                	push   $0x0
  pushl $55
c0101f6b:	6a 37                	push   $0x37
  jmp __alltraps
c0101f6d:	e9 f6 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f72 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f72:	6a 00                	push   $0x0
  pushl $56
c0101f74:	6a 38                	push   $0x38
  jmp __alltraps
c0101f76:	e9 ed fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f7b <vector57>:
.globl vector57
vector57:
  pushl $0
c0101f7b:	6a 00                	push   $0x0
  pushl $57
c0101f7d:	6a 39                	push   $0x39
  jmp __alltraps
c0101f7f:	e9 e4 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f84 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101f84:	6a 00                	push   $0x0
  pushl $58
c0101f86:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101f88:	e9 db fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f8d <vector59>:
.globl vector59
vector59:
  pushl $0
c0101f8d:	6a 00                	push   $0x0
  pushl $59
c0101f8f:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101f91:	e9 d2 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f96 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101f96:	6a 00                	push   $0x0
  pushl $60
c0101f98:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101f9a:	e9 c9 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101f9f <vector61>:
.globl vector61
vector61:
  pushl $0
c0101f9f:	6a 00                	push   $0x0
  pushl $61
c0101fa1:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fa3:	e9 c0 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fa8 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fa8:	6a 00                	push   $0x0
  pushl $62
c0101faa:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fac:	e9 b7 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fb1 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fb1:	6a 00                	push   $0x0
  pushl $63
c0101fb3:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fb5:	e9 ae fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fba <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fba:	6a 00                	push   $0x0
  pushl $64
c0101fbc:	6a 40                	push   $0x40
  jmp __alltraps
c0101fbe:	e9 a5 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fc3 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fc3:	6a 00                	push   $0x0
  pushl $65
c0101fc5:	6a 41                	push   $0x41
  jmp __alltraps
c0101fc7:	e9 9c fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fcc <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fcc:	6a 00                	push   $0x0
  pushl $66
c0101fce:	6a 42                	push   $0x42
  jmp __alltraps
c0101fd0:	e9 93 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fd5 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fd5:	6a 00                	push   $0x0
  pushl $67
c0101fd7:	6a 43                	push   $0x43
  jmp __alltraps
c0101fd9:	e9 8a fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fde <vector68>:
.globl vector68
vector68:
  pushl $0
c0101fde:	6a 00                	push   $0x0
  pushl $68
c0101fe0:	6a 44                	push   $0x44
  jmp __alltraps
c0101fe2:	e9 81 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101fe7 <vector69>:
.globl vector69
vector69:
  pushl $0
c0101fe7:	6a 00                	push   $0x0
  pushl $69
c0101fe9:	6a 45                	push   $0x45
  jmp __alltraps
c0101feb:	e9 78 fd ff ff       	jmp    c0101d68 <__alltraps>

c0101ff0 <vector70>:
.globl vector70
vector70:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $70
c0101ff2:	6a 46                	push   $0x46
  jmp __alltraps
c0101ff4:	e9 6f fd ff ff       	jmp    c0101d68 <__alltraps>

c0101ff9 <vector71>:
.globl vector71
vector71:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $71
c0101ffb:	6a 47                	push   $0x47
  jmp __alltraps
c0101ffd:	e9 66 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102002 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102002:	6a 00                	push   $0x0
  pushl $72
c0102004:	6a 48                	push   $0x48
  jmp __alltraps
c0102006:	e9 5d fd ff ff       	jmp    c0101d68 <__alltraps>

c010200b <vector73>:
.globl vector73
vector73:
  pushl $0
c010200b:	6a 00                	push   $0x0
  pushl $73
c010200d:	6a 49                	push   $0x49
  jmp __alltraps
c010200f:	e9 54 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102014 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102014:	6a 00                	push   $0x0
  pushl $74
c0102016:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102018:	e9 4b fd ff ff       	jmp    c0101d68 <__alltraps>

c010201d <vector75>:
.globl vector75
vector75:
  pushl $0
c010201d:	6a 00                	push   $0x0
  pushl $75
c010201f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102021:	e9 42 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102026 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102026:	6a 00                	push   $0x0
  pushl $76
c0102028:	6a 4c                	push   $0x4c
  jmp __alltraps
c010202a:	e9 39 fd ff ff       	jmp    c0101d68 <__alltraps>

c010202f <vector77>:
.globl vector77
vector77:
  pushl $0
c010202f:	6a 00                	push   $0x0
  pushl $77
c0102031:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102033:	e9 30 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102038 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102038:	6a 00                	push   $0x0
  pushl $78
c010203a:	6a 4e                	push   $0x4e
  jmp __alltraps
c010203c:	e9 27 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102041 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102041:	6a 00                	push   $0x0
  pushl $79
c0102043:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102045:	e9 1e fd ff ff       	jmp    c0101d68 <__alltraps>

c010204a <vector80>:
.globl vector80
vector80:
  pushl $0
c010204a:	6a 00                	push   $0x0
  pushl $80
c010204c:	6a 50                	push   $0x50
  jmp __alltraps
c010204e:	e9 15 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102053 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102053:	6a 00                	push   $0x0
  pushl $81
c0102055:	6a 51                	push   $0x51
  jmp __alltraps
c0102057:	e9 0c fd ff ff       	jmp    c0101d68 <__alltraps>

c010205c <vector82>:
.globl vector82
vector82:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $82
c010205e:	6a 52                	push   $0x52
  jmp __alltraps
c0102060:	e9 03 fd ff ff       	jmp    c0101d68 <__alltraps>

c0102065 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102065:	6a 00                	push   $0x0
  pushl $83
c0102067:	6a 53                	push   $0x53
  jmp __alltraps
c0102069:	e9 fa fc ff ff       	jmp    c0101d68 <__alltraps>

c010206e <vector84>:
.globl vector84
vector84:
  pushl $0
c010206e:	6a 00                	push   $0x0
  pushl $84
c0102070:	6a 54                	push   $0x54
  jmp __alltraps
c0102072:	e9 f1 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102077 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102077:	6a 00                	push   $0x0
  pushl $85
c0102079:	6a 55                	push   $0x55
  jmp __alltraps
c010207b:	e9 e8 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102080 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $86
c0102082:	6a 56                	push   $0x56
  jmp __alltraps
c0102084:	e9 df fc ff ff       	jmp    c0101d68 <__alltraps>

c0102089 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102089:	6a 00                	push   $0x0
  pushl $87
c010208b:	6a 57                	push   $0x57
  jmp __alltraps
c010208d:	e9 d6 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102092 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102092:	6a 00                	push   $0x0
  pushl $88
c0102094:	6a 58                	push   $0x58
  jmp __alltraps
c0102096:	e9 cd fc ff ff       	jmp    c0101d68 <__alltraps>

c010209b <vector89>:
.globl vector89
vector89:
  pushl $0
c010209b:	6a 00                	push   $0x0
  pushl $89
c010209d:	6a 59                	push   $0x59
  jmp __alltraps
c010209f:	e9 c4 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020a4 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $90
c01020a6:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020a8:	e9 bb fc ff ff       	jmp    c0101d68 <__alltraps>

c01020ad <vector91>:
.globl vector91
vector91:
  pushl $0
c01020ad:	6a 00                	push   $0x0
  pushl $91
c01020af:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020b1:	e9 b2 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020b6 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020b6:	6a 00                	push   $0x0
  pushl $92
c01020b8:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020ba:	e9 a9 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020bf <vector93>:
.globl vector93
vector93:
  pushl $0
c01020bf:	6a 00                	push   $0x0
  pushl $93
c01020c1:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020c3:	e9 a0 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020c8 <vector94>:
.globl vector94
vector94:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $94
c01020ca:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020cc:	e9 97 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020d1 <vector95>:
.globl vector95
vector95:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $95
c01020d3:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020d5:	e9 8e fc ff ff       	jmp    c0101d68 <__alltraps>

c01020da <vector96>:
.globl vector96
vector96:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $96
c01020dc:	6a 60                	push   $0x60
  jmp __alltraps
c01020de:	e9 85 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020e3 <vector97>:
.globl vector97
vector97:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $97
c01020e5:	6a 61                	push   $0x61
  jmp __alltraps
c01020e7:	e9 7c fc ff ff       	jmp    c0101d68 <__alltraps>

c01020ec <vector98>:
.globl vector98
vector98:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $98
c01020ee:	6a 62                	push   $0x62
  jmp __alltraps
c01020f0:	e9 73 fc ff ff       	jmp    c0101d68 <__alltraps>

c01020f5 <vector99>:
.globl vector99
vector99:
  pushl $0
c01020f5:	6a 00                	push   $0x0
  pushl $99
c01020f7:	6a 63                	push   $0x63
  jmp __alltraps
c01020f9:	e9 6a fc ff ff       	jmp    c0101d68 <__alltraps>

c01020fe <vector100>:
.globl vector100
vector100:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $100
c0102100:	6a 64                	push   $0x64
  jmp __alltraps
c0102102:	e9 61 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102107 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102107:	6a 00                	push   $0x0
  pushl $101
c0102109:	6a 65                	push   $0x65
  jmp __alltraps
c010210b:	e9 58 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102110 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $102
c0102112:	6a 66                	push   $0x66
  jmp __alltraps
c0102114:	e9 4f fc ff ff       	jmp    c0101d68 <__alltraps>

c0102119 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102119:	6a 00                	push   $0x0
  pushl $103
c010211b:	6a 67                	push   $0x67
  jmp __alltraps
c010211d:	e9 46 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102122 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $104
c0102124:	6a 68                	push   $0x68
  jmp __alltraps
c0102126:	e9 3d fc ff ff       	jmp    c0101d68 <__alltraps>

c010212b <vector105>:
.globl vector105
vector105:
  pushl $0
c010212b:	6a 00                	push   $0x0
  pushl $105
c010212d:	6a 69                	push   $0x69
  jmp __alltraps
c010212f:	e9 34 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102134 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $106
c0102136:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102138:	e9 2b fc ff ff       	jmp    c0101d68 <__alltraps>

c010213d <vector107>:
.globl vector107
vector107:
  pushl $0
c010213d:	6a 00                	push   $0x0
  pushl $107
c010213f:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102141:	e9 22 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102146 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $108
c0102148:	6a 6c                	push   $0x6c
  jmp __alltraps
c010214a:	e9 19 fc ff ff       	jmp    c0101d68 <__alltraps>

c010214f <vector109>:
.globl vector109
vector109:
  pushl $0
c010214f:	6a 00                	push   $0x0
  pushl $109
c0102151:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102153:	e9 10 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102158 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $110
c010215a:	6a 6e                	push   $0x6e
  jmp __alltraps
c010215c:	e9 07 fc ff ff       	jmp    c0101d68 <__alltraps>

c0102161 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102161:	6a 00                	push   $0x0
  pushl $111
c0102163:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102165:	e9 fe fb ff ff       	jmp    c0101d68 <__alltraps>

c010216a <vector112>:
.globl vector112
vector112:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $112
c010216c:	6a 70                	push   $0x70
  jmp __alltraps
c010216e:	e9 f5 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102173 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102173:	6a 00                	push   $0x0
  pushl $113
c0102175:	6a 71                	push   $0x71
  jmp __alltraps
c0102177:	e9 ec fb ff ff       	jmp    c0101d68 <__alltraps>

c010217c <vector114>:
.globl vector114
vector114:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $114
c010217e:	6a 72                	push   $0x72
  jmp __alltraps
c0102180:	e9 e3 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102185 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102185:	6a 00                	push   $0x0
  pushl $115
c0102187:	6a 73                	push   $0x73
  jmp __alltraps
c0102189:	e9 da fb ff ff       	jmp    c0101d68 <__alltraps>

c010218e <vector116>:
.globl vector116
vector116:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $116
c0102190:	6a 74                	push   $0x74
  jmp __alltraps
c0102192:	e9 d1 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102197 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102197:	6a 00                	push   $0x0
  pushl $117
c0102199:	6a 75                	push   $0x75
  jmp __alltraps
c010219b:	e9 c8 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021a0 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $118
c01021a2:	6a 76                	push   $0x76
  jmp __alltraps
c01021a4:	e9 bf fb ff ff       	jmp    c0101d68 <__alltraps>

c01021a9 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021a9:	6a 00                	push   $0x0
  pushl $119
c01021ab:	6a 77                	push   $0x77
  jmp __alltraps
c01021ad:	e9 b6 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021b2 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $120
c01021b4:	6a 78                	push   $0x78
  jmp __alltraps
c01021b6:	e9 ad fb ff ff       	jmp    c0101d68 <__alltraps>

c01021bb <vector121>:
.globl vector121
vector121:
  pushl $0
c01021bb:	6a 00                	push   $0x0
  pushl $121
c01021bd:	6a 79                	push   $0x79
  jmp __alltraps
c01021bf:	e9 a4 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021c4 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $122
c01021c6:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021c8:	e9 9b fb ff ff       	jmp    c0101d68 <__alltraps>

c01021cd <vector123>:
.globl vector123
vector123:
  pushl $0
c01021cd:	6a 00                	push   $0x0
  pushl $123
c01021cf:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021d1:	e9 92 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021d6 <vector124>:
.globl vector124
vector124:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $124
c01021d8:	6a 7c                	push   $0x7c
  jmp __alltraps
c01021da:	e9 89 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021df <vector125>:
.globl vector125
vector125:
  pushl $0
c01021df:	6a 00                	push   $0x0
  pushl $125
c01021e1:	6a 7d                	push   $0x7d
  jmp __alltraps
c01021e3:	e9 80 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021e8 <vector126>:
.globl vector126
vector126:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $126
c01021ea:	6a 7e                	push   $0x7e
  jmp __alltraps
c01021ec:	e9 77 fb ff ff       	jmp    c0101d68 <__alltraps>

c01021f1 <vector127>:
.globl vector127
vector127:
  pushl $0
c01021f1:	6a 00                	push   $0x0
  pushl $127
c01021f3:	6a 7f                	push   $0x7f
  jmp __alltraps
c01021f5:	e9 6e fb ff ff       	jmp    c0101d68 <__alltraps>

c01021fa <vector128>:
.globl vector128
vector128:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $128
c01021fc:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102201:	e9 62 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102206 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $129
c0102208:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010220d:	e9 56 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102212 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $130
c0102214:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102219:	e9 4a fb ff ff       	jmp    c0101d68 <__alltraps>

c010221e <vector131>:
.globl vector131
vector131:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $131
c0102220:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102225:	e9 3e fb ff ff       	jmp    c0101d68 <__alltraps>

c010222a <vector132>:
.globl vector132
vector132:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $132
c010222c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102231:	e9 32 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102236 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $133
c0102238:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010223d:	e9 26 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102242 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $134
c0102244:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102249:	e9 1a fb ff ff       	jmp    c0101d68 <__alltraps>

c010224e <vector135>:
.globl vector135
vector135:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $135
c0102250:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102255:	e9 0e fb ff ff       	jmp    c0101d68 <__alltraps>

c010225a <vector136>:
.globl vector136
vector136:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $136
c010225c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102261:	e9 02 fb ff ff       	jmp    c0101d68 <__alltraps>

c0102266 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $137
c0102268:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010226d:	e9 f6 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102272 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $138
c0102274:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102279:	e9 ea fa ff ff       	jmp    c0101d68 <__alltraps>

c010227e <vector139>:
.globl vector139
vector139:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $139
c0102280:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102285:	e9 de fa ff ff       	jmp    c0101d68 <__alltraps>

c010228a <vector140>:
.globl vector140
vector140:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $140
c010228c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102291:	e9 d2 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102296 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $141
c0102298:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010229d:	e9 c6 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022a2 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $142
c01022a4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022a9:	e9 ba fa ff ff       	jmp    c0101d68 <__alltraps>

c01022ae <vector143>:
.globl vector143
vector143:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $143
c01022b0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022b5:	e9 ae fa ff ff       	jmp    c0101d68 <__alltraps>

c01022ba <vector144>:
.globl vector144
vector144:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $144
c01022bc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022c1:	e9 a2 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022c6 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $145
c01022c8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022cd:	e9 96 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022d2 <vector146>:
.globl vector146
vector146:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $146
c01022d4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01022d9:	e9 8a fa ff ff       	jmp    c0101d68 <__alltraps>

c01022de <vector147>:
.globl vector147
vector147:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $147
c01022e0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01022e5:	e9 7e fa ff ff       	jmp    c0101d68 <__alltraps>

c01022ea <vector148>:
.globl vector148
vector148:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $148
c01022ec:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01022f1:	e9 72 fa ff ff       	jmp    c0101d68 <__alltraps>

c01022f6 <vector149>:
.globl vector149
vector149:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $149
c01022f8:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01022fd:	e9 66 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102302 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $150
c0102304:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102309:	e9 5a fa ff ff       	jmp    c0101d68 <__alltraps>

c010230e <vector151>:
.globl vector151
vector151:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $151
c0102310:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102315:	e9 4e fa ff ff       	jmp    c0101d68 <__alltraps>

c010231a <vector152>:
.globl vector152
vector152:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $152
c010231c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102321:	e9 42 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102326 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $153
c0102328:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010232d:	e9 36 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102332 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $154
c0102334:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102339:	e9 2a fa ff ff       	jmp    c0101d68 <__alltraps>

c010233e <vector155>:
.globl vector155
vector155:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $155
c0102340:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102345:	e9 1e fa ff ff       	jmp    c0101d68 <__alltraps>

c010234a <vector156>:
.globl vector156
vector156:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $156
c010234c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102351:	e9 12 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102356 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $157
c0102358:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010235d:	e9 06 fa ff ff       	jmp    c0101d68 <__alltraps>

c0102362 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $158
c0102364:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102369:	e9 fa f9 ff ff       	jmp    c0101d68 <__alltraps>

c010236e <vector159>:
.globl vector159
vector159:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $159
c0102370:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102375:	e9 ee f9 ff ff       	jmp    c0101d68 <__alltraps>

c010237a <vector160>:
.globl vector160
vector160:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $160
c010237c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102381:	e9 e2 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102386 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $161
c0102388:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010238d:	e9 d6 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102392 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $162
c0102394:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102399:	e9 ca f9 ff ff       	jmp    c0101d68 <__alltraps>

c010239e <vector163>:
.globl vector163
vector163:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $163
c01023a0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023a5:	e9 be f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023aa <vector164>:
.globl vector164
vector164:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $164
c01023ac:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023b1:	e9 b2 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023b6 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023b6:	6a 00                	push   $0x0
  pushl $165
c01023b8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023bd:	e9 a6 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023c2 <vector166>:
.globl vector166
vector166:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $166
c01023c4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023c9:	e9 9a f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023ce <vector167>:
.globl vector167
vector167:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $167
c01023d0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023d5:	e9 8e f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023da <vector168>:
.globl vector168
vector168:
  pushl $0
c01023da:	6a 00                	push   $0x0
  pushl $168
c01023dc:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01023e1:	e9 82 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023e6 <vector169>:
.globl vector169
vector169:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $169
c01023e8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01023ed:	e9 76 f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023f2 <vector170>:
.globl vector170
vector170:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $170
c01023f4:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01023f9:	e9 6a f9 ff ff       	jmp    c0101d68 <__alltraps>

c01023fe <vector171>:
.globl vector171
vector171:
  pushl $0
c01023fe:	6a 00                	push   $0x0
  pushl $171
c0102400:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102405:	e9 5e f9 ff ff       	jmp    c0101d68 <__alltraps>

c010240a <vector172>:
.globl vector172
vector172:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $172
c010240c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102411:	e9 52 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102416 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $173
c0102418:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010241d:	e9 46 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102422 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102422:	6a 00                	push   $0x0
  pushl $174
c0102424:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102429:	e9 3a f9 ff ff       	jmp    c0101d68 <__alltraps>

c010242e <vector175>:
.globl vector175
vector175:
  pushl $0
c010242e:	6a 00                	push   $0x0
  pushl $175
c0102430:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102435:	e9 2e f9 ff ff       	jmp    c0101d68 <__alltraps>

c010243a <vector176>:
.globl vector176
vector176:
  pushl $0
c010243a:	6a 00                	push   $0x0
  pushl $176
c010243c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102441:	e9 22 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102446 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102446:	6a 00                	push   $0x0
  pushl $177
c0102448:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010244d:	e9 16 f9 ff ff       	jmp    c0101d68 <__alltraps>

c0102452 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102452:	6a 00                	push   $0x0
  pushl $178
c0102454:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102459:	e9 0a f9 ff ff       	jmp    c0101d68 <__alltraps>

c010245e <vector179>:
.globl vector179
vector179:
  pushl $0
c010245e:	6a 00                	push   $0x0
  pushl $179
c0102460:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102465:	e9 fe f8 ff ff       	jmp    c0101d68 <__alltraps>

c010246a <vector180>:
.globl vector180
vector180:
  pushl $0
c010246a:	6a 00                	push   $0x0
  pushl $180
c010246c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102471:	e9 f2 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102476 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102476:	6a 00                	push   $0x0
  pushl $181
c0102478:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010247d:	e9 e6 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102482 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102482:	6a 00                	push   $0x0
  pushl $182
c0102484:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102489:	e9 da f8 ff ff       	jmp    c0101d68 <__alltraps>

c010248e <vector183>:
.globl vector183
vector183:
  pushl $0
c010248e:	6a 00                	push   $0x0
  pushl $183
c0102490:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102495:	e9 ce f8 ff ff       	jmp    c0101d68 <__alltraps>

c010249a <vector184>:
.globl vector184
vector184:
  pushl $0
c010249a:	6a 00                	push   $0x0
  pushl $184
c010249c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024a1:	e9 c2 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024a6 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024a6:	6a 00                	push   $0x0
  pushl $185
c01024a8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024ad:	e9 b6 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024b2 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024b2:	6a 00                	push   $0x0
  pushl $186
c01024b4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024b9:	e9 aa f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024be <vector187>:
.globl vector187
vector187:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $187
c01024c0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024c5:	e9 9e f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024ca <vector188>:
.globl vector188
vector188:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $188
c01024cc:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024d1:	e9 92 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024d6 <vector189>:
.globl vector189
vector189:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $189
c01024d8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01024dd:	e9 86 f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024e2 <vector190>:
.globl vector190
vector190:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $190
c01024e4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01024e9:	e9 7a f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024ee <vector191>:
.globl vector191
vector191:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $191
c01024f0:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01024f5:	e9 6e f8 ff ff       	jmp    c0101d68 <__alltraps>

c01024fa <vector192>:
.globl vector192
vector192:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $192
c01024fc:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102501:	e9 62 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102506 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $193
c0102508:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010250d:	e9 56 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102512 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $194
c0102514:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102519:	e9 4a f8 ff ff       	jmp    c0101d68 <__alltraps>

c010251e <vector195>:
.globl vector195
vector195:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $195
c0102520:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102525:	e9 3e f8 ff ff       	jmp    c0101d68 <__alltraps>

c010252a <vector196>:
.globl vector196
vector196:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $196
c010252c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102531:	e9 32 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102536 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $197
c0102538:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010253d:	e9 26 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102542 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $198
c0102544:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102549:	e9 1a f8 ff ff       	jmp    c0101d68 <__alltraps>

c010254e <vector199>:
.globl vector199
vector199:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $199
c0102550:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102555:	e9 0e f8 ff ff       	jmp    c0101d68 <__alltraps>

c010255a <vector200>:
.globl vector200
vector200:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $200
c010255c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102561:	e9 02 f8 ff ff       	jmp    c0101d68 <__alltraps>

c0102566 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $201
c0102568:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010256d:	e9 f6 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102572 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $202
c0102574:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102579:	e9 ea f7 ff ff       	jmp    c0101d68 <__alltraps>

c010257e <vector203>:
.globl vector203
vector203:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $203
c0102580:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102585:	e9 de f7 ff ff       	jmp    c0101d68 <__alltraps>

c010258a <vector204>:
.globl vector204
vector204:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $204
c010258c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102591:	e9 d2 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102596 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $205
c0102598:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010259d:	e9 c6 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025a2 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $206
c01025a4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025a9:	e9 ba f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025ae <vector207>:
.globl vector207
vector207:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $207
c01025b0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025b5:	e9 ae f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025ba <vector208>:
.globl vector208
vector208:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $208
c01025bc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025c1:	e9 a2 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025c6 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $209
c01025c8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025cd:	e9 96 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025d2 <vector210>:
.globl vector210
vector210:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $210
c01025d4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01025d9:	e9 8a f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025de <vector211>:
.globl vector211
vector211:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $211
c01025e0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01025e5:	e9 7e f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025ea <vector212>:
.globl vector212
vector212:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $212
c01025ec:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01025f1:	e9 72 f7 ff ff       	jmp    c0101d68 <__alltraps>

c01025f6 <vector213>:
.globl vector213
vector213:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $213
c01025f8:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01025fd:	e9 66 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102602 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $214
c0102604:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102609:	e9 5a f7 ff ff       	jmp    c0101d68 <__alltraps>

c010260e <vector215>:
.globl vector215
vector215:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $215
c0102610:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102615:	e9 4e f7 ff ff       	jmp    c0101d68 <__alltraps>

c010261a <vector216>:
.globl vector216
vector216:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $216
c010261c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102621:	e9 42 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102626 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $217
c0102628:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010262d:	e9 36 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102632 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $218
c0102634:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102639:	e9 2a f7 ff ff       	jmp    c0101d68 <__alltraps>

c010263e <vector219>:
.globl vector219
vector219:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $219
c0102640:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102645:	e9 1e f7 ff ff       	jmp    c0101d68 <__alltraps>

c010264a <vector220>:
.globl vector220
vector220:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $220
c010264c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102651:	e9 12 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102656 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $221
c0102658:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010265d:	e9 06 f7 ff ff       	jmp    c0101d68 <__alltraps>

c0102662 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $222
c0102664:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102669:	e9 fa f6 ff ff       	jmp    c0101d68 <__alltraps>

c010266e <vector223>:
.globl vector223
vector223:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $223
c0102670:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102675:	e9 ee f6 ff ff       	jmp    c0101d68 <__alltraps>

c010267a <vector224>:
.globl vector224
vector224:
  pushl $0
c010267a:	6a 00                	push   $0x0
  pushl $224
c010267c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102681:	e9 e2 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102686 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $225
c0102688:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010268d:	e9 d6 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102692 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $226
c0102694:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102699:	e9 ca f6 ff ff       	jmp    c0101d68 <__alltraps>

c010269e <vector227>:
.globl vector227
vector227:
  pushl $0
c010269e:	6a 00                	push   $0x0
  pushl $227
c01026a0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026a5:	e9 be f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026aa <vector228>:
.globl vector228
vector228:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $228
c01026ac:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026b1:	e9 b2 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026b6 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $229
c01026b8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026bd:	e9 a6 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026c2 <vector230>:
.globl vector230
vector230:
  pushl $0
c01026c2:	6a 00                	push   $0x0
  pushl $230
c01026c4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026c9:	e9 9a f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026ce <vector231>:
.globl vector231
vector231:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $231
c01026d0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026d5:	e9 8e f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026da <vector232>:
.globl vector232
vector232:
  pushl $0
c01026da:	6a 00                	push   $0x0
  pushl $232
c01026dc:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01026e1:	e9 82 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026e6 <vector233>:
.globl vector233
vector233:
  pushl $0
c01026e6:	6a 00                	push   $0x0
  pushl $233
c01026e8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01026ed:	e9 76 f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026f2 <vector234>:
.globl vector234
vector234:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $234
c01026f4:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01026f9:	e9 6a f6 ff ff       	jmp    c0101d68 <__alltraps>

c01026fe <vector235>:
.globl vector235
vector235:
  pushl $0
c01026fe:	6a 00                	push   $0x0
  pushl $235
c0102700:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102705:	e9 5e f6 ff ff       	jmp    c0101d68 <__alltraps>

c010270a <vector236>:
.globl vector236
vector236:
  pushl $0
c010270a:	6a 00                	push   $0x0
  pushl $236
c010270c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102711:	e9 52 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102716 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $237
c0102718:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010271d:	e9 46 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102722 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102722:	6a 00                	push   $0x0
  pushl $238
c0102724:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102729:	e9 3a f6 ff ff       	jmp    c0101d68 <__alltraps>

c010272e <vector239>:
.globl vector239
vector239:
  pushl $0
c010272e:	6a 00                	push   $0x0
  pushl $239
c0102730:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102735:	e9 2e f6 ff ff       	jmp    c0101d68 <__alltraps>

c010273a <vector240>:
.globl vector240
vector240:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $240
c010273c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102741:	e9 22 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102746 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102746:	6a 00                	push   $0x0
  pushl $241
c0102748:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010274d:	e9 16 f6 ff ff       	jmp    c0101d68 <__alltraps>

c0102752 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102752:	6a 00                	push   $0x0
  pushl $242
c0102754:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102759:	e9 0a f6 ff ff       	jmp    c0101d68 <__alltraps>

c010275e <vector243>:
.globl vector243
vector243:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $243
c0102760:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102765:	e9 fe f5 ff ff       	jmp    c0101d68 <__alltraps>

c010276a <vector244>:
.globl vector244
vector244:
  pushl $0
c010276a:	6a 00                	push   $0x0
  pushl $244
c010276c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102771:	e9 f2 f5 ff ff       	jmp    c0101d68 <__alltraps>

c0102776 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102776:	6a 00                	push   $0x0
  pushl $245
c0102778:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010277d:	e9 e6 f5 ff ff       	jmp    c0101d68 <__alltraps>

c0102782 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $246
c0102784:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102789:	e9 da f5 ff ff       	jmp    c0101d68 <__alltraps>

c010278e <vector247>:
.globl vector247
vector247:
  pushl $0
c010278e:	6a 00                	push   $0x0
  pushl $247
c0102790:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102795:	e9 ce f5 ff ff       	jmp    c0101d68 <__alltraps>

c010279a <vector248>:
.globl vector248
vector248:
  pushl $0
c010279a:	6a 00                	push   $0x0
  pushl $248
c010279c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027a1:	e9 c2 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027a6 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $249
c01027a8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027ad:	e9 b6 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027b2 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027b2:	6a 00                	push   $0x0
  pushl $250
c01027b4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027b9:	e9 aa f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027be <vector251>:
.globl vector251
vector251:
  pushl $0
c01027be:	6a 00                	push   $0x0
  pushl $251
c01027c0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027c5:	e9 9e f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027ca <vector252>:
.globl vector252
vector252:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $252
c01027cc:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027d1:	e9 92 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027d6 <vector253>:
.globl vector253
vector253:
  pushl $0
c01027d6:	6a 00                	push   $0x0
  pushl $253
c01027d8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01027dd:	e9 86 f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027e2 <vector254>:
.globl vector254
vector254:
  pushl $0
c01027e2:	6a 00                	push   $0x0
  pushl $254
c01027e4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01027e9:	e9 7a f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027ee <vector255>:
.globl vector255
vector255:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $255
c01027f0:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01027f5:	e9 6e f5 ff ff       	jmp    c0101d68 <__alltraps>

c01027fa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01027fa:	55                   	push   %ebp
c01027fb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01027fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0102800:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c0102805:	29 c2                	sub    %eax,%edx
c0102807:	89 d0                	mov    %edx,%eax
c0102809:	c1 f8 02             	sar    $0x2,%eax
c010280c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102812:	5d                   	pop    %ebp
c0102813:	c3                   	ret    

c0102814 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102814:	55                   	push   %ebp
c0102815:	89 e5                	mov    %esp,%ebp
c0102817:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010281a:	8b 45 08             	mov    0x8(%ebp),%eax
c010281d:	89 04 24             	mov    %eax,(%esp)
c0102820:	e8 d5 ff ff ff       	call   c01027fa <page2ppn>
c0102825:	c1 e0 0c             	shl    $0xc,%eax
}
c0102828:	c9                   	leave  
c0102829:	c3                   	ret    

c010282a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010282a:	55                   	push   %ebp
c010282b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010282d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102830:	8b 00                	mov    (%eax),%eax
}
c0102832:	5d                   	pop    %ebp
c0102833:	c3                   	ret    

c0102834 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102834:	55                   	push   %ebp
c0102835:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102837:	8b 45 08             	mov    0x8(%ebp),%eax
c010283a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010283d:	89 10                	mov    %edx,(%eax)
}
c010283f:	5d                   	pop    %ebp
c0102840:	c3                   	ret    

c0102841 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102841:	55                   	push   %ebp
c0102842:	89 e5                	mov    %esp,%ebp
c0102844:	83 ec 10             	sub    $0x10,%esp
c0102847:	c7 45 fc 70 89 11 c0 	movl   $0xc0118970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010284e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102851:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102854:	89 50 04             	mov    %edx,0x4(%eax)
c0102857:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010285a:	8b 50 04             	mov    0x4(%eax),%edx
c010285d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102860:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102862:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c0102869:	00 00 00 
}
c010286c:	c9                   	leave  
c010286d:	c3                   	ret    

c010286e <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010286e:	55                   	push   %ebp
c010286f:	89 e5                	mov    %esp,%ebp
c0102871:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102874:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102878:	75 24                	jne    c010289e <default_init_memmap+0x30>
c010287a:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c0102881:	c0 
c0102882:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102889:	c0 
c010288a:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102891:	00 
c0102892:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102899:	e8 2e e4 ff ff       	call   c0100ccc <__panic>
    struct Page *p = base;
c010289e:	8b 45 08             	mov    0x8(%ebp),%eax
c01028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028a4:	eb 7d                	jmp    c0102923 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028a9:	83 c0 04             	add    $0x4,%eax
c01028ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028bc:	0f a3 10             	bt     %edx,(%eax)
c01028bf:	19 c0                	sbb    %eax,%eax
c01028c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028c8:	0f 95 c0             	setne  %al
c01028cb:	0f b6 c0             	movzbl %al,%eax
c01028ce:	85 c0                	test   %eax,%eax
c01028d0:	75 24                	jne    c01028f6 <default_init_memmap+0x88>
c01028d2:	c7 44 24 0c e1 64 10 	movl   $0xc01064e1,0xc(%esp)
c01028d9:	c0 
c01028da:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01028e1:	c0 
c01028e2:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01028e9:	00 
c01028ea:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01028f1:	e8 d6 e3 ff ff       	call   c0100ccc <__panic>
        p->flags = p->property = 0;
c01028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102900:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102903:	8b 50 08             	mov    0x8(%eax),%edx
c0102906:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102909:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010290c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102913:	00 
c0102914:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102917:	89 04 24             	mov    %eax,(%esp)
c010291a:	e8 15 ff ff ff       	call   c0102834 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010291f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102923:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102926:	89 d0                	mov    %edx,%eax
c0102928:	c1 e0 02             	shl    $0x2,%eax
c010292b:	01 d0                	add    %edx,%eax
c010292d:	c1 e0 02             	shl    $0x2,%eax
c0102930:	89 c2                	mov    %eax,%edx
c0102932:	8b 45 08             	mov    0x8(%ebp),%eax
c0102935:	01 d0                	add    %edx,%eax
c0102937:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010293a:	0f 85 66 ff ff ff    	jne    c01028a6 <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102940:	8b 45 08             	mov    0x8(%ebp),%eax
c0102943:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102946:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102949:	8b 45 08             	mov    0x8(%ebp),%eax
c010294c:	83 c0 04             	add    $0x4,%eax
c010294f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102956:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102959:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010295c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010295f:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102962:	8b 15 78 89 11 c0    	mov    0xc0118978,%edx
c0102968:	8b 45 0c             	mov    0xc(%ebp),%eax
c010296b:	01 d0                	add    %edx,%eax
c010296d:	a3 78 89 11 c0       	mov    %eax,0xc0118978
    list_add(&free_list, &(base->page_link));
c0102972:	8b 45 08             	mov    0x8(%ebp),%eax
c0102975:	83 c0 0c             	add    $0xc,%eax
c0102978:	c7 45 dc 70 89 11 c0 	movl   $0xc0118970,-0x24(%ebp)
c010297f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102985:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102988:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010298b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010298e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102991:	8b 40 04             	mov    0x4(%eax),%eax
c0102994:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102997:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010299a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010299d:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01029a0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01029a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01029a6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029a9:	89 10                	mov    %edx,(%eax)
c01029ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01029ae:	8b 10                	mov    (%eax),%edx
c01029b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01029b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029b6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029b9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01029bc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029bf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01029c5:	89 10                	mov    %edx,(%eax)
}
c01029c7:	c9                   	leave  
c01029c8:	c3                   	ret    

c01029c9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029c9:	55                   	push   %ebp
c01029ca:	89 e5                	mov    %esp,%ebp
c01029cc:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01029cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029d3:	75 24                	jne    c01029f9 <default_alloc_pages+0x30>
c01029d5:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c01029dc:	c0 
c01029dd:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01029e4:	c0 
c01029e5:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01029ec:	00 
c01029ed:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01029f4:	e8 d3 e2 ff ff       	call   c0100ccc <__panic>
    if (n > nr_free) {
c01029f9:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01029fe:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a01:	73 0a                	jae    c0102a0d <default_alloc_pages+0x44>
        return NULL;
c0102a03:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a08:	e9 2a 01 00 00       	jmp    c0102b37 <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0102a0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a14:	c7 45 f0 70 89 11 c0 	movl   $0xc0118970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102a1b:	eb 1c                	jmp    c0102a39 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a20:	83 e8 0c             	sub    $0xc,%eax
c0102a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a29:	8b 40 08             	mov    0x8(%eax),%eax
c0102a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a2f:	72 08                	jb     c0102a39 <default_alloc_pages+0x70>
            page = p;
c0102a31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a34:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a37:	eb 18                	jmp    c0102a51 <default_alloc_pages+0x88>
c0102a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a3c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a42:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a48:	81 7d f0 70 89 11 c0 	cmpl   $0xc0118970,-0x10(%ebp)
c0102a4f:	75 cc                	jne    c0102a1d <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102a55:	0f 84 d9 00 00 00    	je     c0102b34 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c0102a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a5e:	83 c0 0c             	add    $0xc,%eax
c0102a61:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a67:	8b 40 04             	mov    0x4(%eax),%eax
c0102a6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102a6d:	8b 12                	mov    (%edx),%edx
c0102a6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102a72:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102a75:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a78:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a7b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102a7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a81:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a84:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0102a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a89:	8b 40 08             	mov    0x8(%eax),%eax
c0102a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a8f:	76 7d                	jbe    c0102b0e <default_alloc_pages+0x145>
            struct Page *p = page + n;
c0102a91:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a94:	89 d0                	mov    %edx,%eax
c0102a96:	c1 e0 02             	shl    $0x2,%eax
c0102a99:	01 d0                	add    %edx,%eax
c0102a9b:	c1 e0 02             	shl    $0x2,%eax
c0102a9e:	89 c2                	mov    %eax,%edx
c0102aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aa3:	01 d0                	add    %edx,%eax
c0102aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aab:	8b 40 08             	mov    0x8(%eax),%eax
c0102aae:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ab1:	89 c2                	mov    %eax,%edx
c0102ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ab6:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0102ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102abc:	83 c0 0c             	add    $0xc,%eax
c0102abf:	c7 45 d4 70 89 11 c0 	movl   $0xc0118970,-0x2c(%ebp)
c0102ac6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ac9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102acc:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102acf:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ad2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ad8:	8b 40 04             	mov    0x4(%eax),%eax
c0102adb:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102ade:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102ae1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ae4:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102ae7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102aea:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102aed:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102af0:	89 10                	mov    %edx,(%eax)
c0102af2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102af5:	8b 10                	mov    (%eax),%edx
c0102af7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102afa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102afd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b00:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b03:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b09:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b0c:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102b0e:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0102b13:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b16:	a3 78 89 11 c0       	mov    %eax,0xc0118978
        ClearPageProperty(page);
c0102b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b1e:	83 c0 04             	add    $0x4,%eax
c0102b21:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102b28:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b2b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b2e:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b31:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b37:	c9                   	leave  
c0102b38:	c3                   	ret    

c0102b39 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b39:	55                   	push   %ebp
c0102b3a:	89 e5                	mov    %esp,%ebp
c0102b3c:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b46:	75 24                	jne    c0102b6c <default_free_pages+0x33>
c0102b48:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c0102b4f:	c0 
c0102b50:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102b57:	c0 
c0102b58:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0102b5f:	00 
c0102b60:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102b67:	e8 60 e1 ff ff       	call   c0100ccc <__panic>
    struct Page *p = base;
c0102b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102b72:	e9 9d 00 00 00       	jmp    c0102c14 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b7a:	83 c0 04             	add    $0x4,%eax
c0102b7d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102b8d:	0f a3 10             	bt     %edx,(%eax)
c0102b90:	19 c0                	sbb    %eax,%eax
c0102b92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102b95:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102b99:	0f 95 c0             	setne  %al
c0102b9c:	0f b6 c0             	movzbl %al,%eax
c0102b9f:	85 c0                	test   %eax,%eax
c0102ba1:	75 2c                	jne    c0102bcf <default_free_pages+0x96>
c0102ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba6:	83 c0 04             	add    $0x4,%eax
c0102ba9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102bb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bb6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102bb9:	0f a3 10             	bt     %edx,(%eax)
c0102bbc:	19 c0                	sbb    %eax,%eax
c0102bbe:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102bc1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102bc5:	0f 95 c0             	setne  %al
c0102bc8:	0f b6 c0             	movzbl %al,%eax
c0102bcb:	85 c0                	test   %eax,%eax
c0102bcd:	74 24                	je     c0102bf3 <default_free_pages+0xba>
c0102bcf:	c7 44 24 0c f4 64 10 	movl   $0xc01064f4,0xc(%esp)
c0102bd6:	c0 
c0102bd7:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102bde:	c0 
c0102bdf:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102be6:	00 
c0102be7:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102bee:	e8 d9 e0 ff ff       	call   c0100ccc <__panic>
        p->flags = 0;
c0102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bf6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c04:	00 
c0102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c08:	89 04 24             	mov    %eax,(%esp)
c0102c0b:	e8 24 fc ff ff       	call   c0102834 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c10:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c14:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c17:	89 d0                	mov    %edx,%eax
c0102c19:	c1 e0 02             	shl    $0x2,%eax
c0102c1c:	01 d0                	add    %edx,%eax
c0102c1e:	c1 e0 02             	shl    $0x2,%eax
c0102c21:	89 c2                	mov    %eax,%edx
c0102c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c26:	01 d0                	add    %edx,%eax
c0102c28:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c2b:	0f 85 46 ff ff ff    	jne    c0102b77 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c34:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c37:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c3d:	83 c0 04             	add    $0x4,%eax
c0102c40:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102c47:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c50:	0f ab 10             	bts    %edx,(%eax)
c0102c53:	c7 45 cc 70 89 11 c0 	movl   $0xc0118970,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c5d:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102c60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102c63:	e9 08 01 00 00       	jmp    c0102d70 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c6b:	83 e8 0c             	sub    $0xc,%eax
c0102c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c74:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102c77:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c7a:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c83:	8b 50 08             	mov    0x8(%eax),%edx
c0102c86:	89 d0                	mov    %edx,%eax
c0102c88:	c1 e0 02             	shl    $0x2,%eax
c0102c8b:	01 d0                	add    %edx,%eax
c0102c8d:	c1 e0 02             	shl    $0x2,%eax
c0102c90:	89 c2                	mov    %eax,%edx
c0102c92:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c95:	01 d0                	add    %edx,%eax
c0102c97:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c9a:	75 5a                	jne    c0102cf6 <default_free_pages+0x1bd>
            base->property += p->property;
c0102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9f:	8b 50 08             	mov    0x8(%eax),%edx
c0102ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca5:	8b 40 08             	mov    0x8(%eax),%eax
c0102ca8:	01 c2                	add    %eax,%edx
c0102caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cad:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cb3:	83 c0 04             	add    $0x4,%eax
c0102cb6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102cbd:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102cc3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cc6:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ccc:	83 c0 0c             	add    $0xc,%eax
c0102ccf:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102cd2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102cd5:	8b 40 04             	mov    0x4(%eax),%eax
c0102cd8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cdb:	8b 12                	mov    (%edx),%edx
c0102cdd:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102ce0:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102ce3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102ce6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ce9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102cec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102cef:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102cf2:	89 10                	mov    %edx,(%eax)
c0102cf4:	eb 7a                	jmp    c0102d70 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf9:	8b 50 08             	mov    0x8(%eax),%edx
c0102cfc:	89 d0                	mov    %edx,%eax
c0102cfe:	c1 e0 02             	shl    $0x2,%eax
c0102d01:	01 d0                	add    %edx,%eax
c0102d03:	c1 e0 02             	shl    $0x2,%eax
c0102d06:	89 c2                	mov    %eax,%edx
c0102d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0b:	01 d0                	add    %edx,%eax
c0102d0d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d10:	75 5e                	jne    c0102d70 <default_free_pages+0x237>
            p->property += base->property;
c0102d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d15:	8b 50 08             	mov    0x8(%eax),%edx
c0102d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1b:	8b 40 08             	mov    0x8(%eax),%eax
c0102d1e:	01 c2                	add    %eax,%edx
c0102d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d23:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d29:	83 c0 04             	add    $0x4,%eax
c0102d2c:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102d33:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102d36:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d39:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d3c:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d42:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d48:	83 c0 0c             	add    $0xc,%eax
c0102d4b:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d4e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102d51:	8b 40 04             	mov    0x4(%eax),%eax
c0102d54:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102d57:	8b 12                	mov    (%edx),%edx
c0102d59:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102d5c:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d5f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102d62:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102d65:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d68:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d6b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102d6e:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102d70:	81 7d f0 70 89 11 c0 	cmpl   $0xc0118970,-0x10(%ebp)
c0102d77:	0f 85 eb fe ff ff    	jne    c0102c68 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102d7d:	8b 15 78 89 11 c0    	mov    0xc0118978,%edx
c0102d83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d86:	01 d0                	add    %edx,%eax
c0102d88:	a3 78 89 11 c0       	mov    %eax,0xc0118978
    list_add(&free_list, &(base->page_link));
c0102d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d90:	83 c0 0c             	add    $0xc,%eax
c0102d93:	c7 45 9c 70 89 11 c0 	movl   $0xc0118970,-0x64(%ebp)
c0102d9a:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102d9d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102da0:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102da3:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102da6:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102da9:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102dac:	8b 40 04             	mov    0x4(%eax),%eax
c0102daf:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102db2:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102db5:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102db8:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102dbb:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102dbe:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102dc1:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102dc4:	89 10                	mov    %edx,(%eax)
c0102dc6:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102dc9:	8b 10                	mov    (%eax),%edx
c0102dcb:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102dce:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102dd1:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102dd4:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102dd7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102dda:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102ddd:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102de0:	89 10                	mov    %edx,(%eax)
}
c0102de2:	c9                   	leave  
c0102de3:	c3                   	ret    

c0102de4 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102de4:	55                   	push   %ebp
c0102de5:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102de7:	a1 78 89 11 c0       	mov    0xc0118978,%eax
}
c0102dec:	5d                   	pop    %ebp
c0102ded:	c3                   	ret    

c0102dee <basic_check>:

static void
basic_check(void) {
c0102dee:	55                   	push   %ebp
c0102def:	89 e5                	mov    %esp,%ebp
c0102df1:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102df4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e0e:	e8 90 0e 00 00       	call   c0103ca3 <alloc_pages>
c0102e13:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e1a:	75 24                	jne    c0102e40 <basic_check+0x52>
c0102e1c:	c7 44 24 0c 19 65 10 	movl   $0xc0106519,0xc(%esp)
c0102e23:	c0 
c0102e24:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102e2b:	c0 
c0102e2c:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0102e33:	00 
c0102e34:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102e3b:	e8 8c de ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e47:	e8 57 0e 00 00       	call   c0103ca3 <alloc_pages>
c0102e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e53:	75 24                	jne    c0102e79 <basic_check+0x8b>
c0102e55:	c7 44 24 0c 35 65 10 	movl   $0xc0106535,0xc(%esp)
c0102e5c:	c0 
c0102e5d:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102e64:	c0 
c0102e65:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102e6c:	00 
c0102e6d:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102e74:	e8 53 de ff ff       	call   c0100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e80:	e8 1e 0e 00 00       	call   c0103ca3 <alloc_pages>
c0102e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e8c:	75 24                	jne    c0102eb2 <basic_check+0xc4>
c0102e8e:	c7 44 24 0c 51 65 10 	movl   $0xc0106551,0xc(%esp)
c0102e95:	c0 
c0102e96:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102e9d:	c0 
c0102e9e:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0102ea5:	00 
c0102ea6:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102ead:	e8 1a de ff ff       	call   c0100ccc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102eb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102eb5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102eb8:	74 10                	je     c0102eca <basic_check+0xdc>
c0102eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ebd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ec0:	74 08                	je     c0102eca <basic_check+0xdc>
c0102ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ec5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ec8:	75 24                	jne    c0102eee <basic_check+0x100>
c0102eca:	c7 44 24 0c 70 65 10 	movl   $0xc0106570,0xc(%esp)
c0102ed1:	c0 
c0102ed2:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102ed9:	c0 
c0102eda:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102ee1:	00 
c0102ee2:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102ee9:	e8 de dd ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ef1:	89 04 24             	mov    %eax,(%esp)
c0102ef4:	e8 31 f9 ff ff       	call   c010282a <page_ref>
c0102ef9:	85 c0                	test   %eax,%eax
c0102efb:	75 1e                	jne    c0102f1b <basic_check+0x12d>
c0102efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f00:	89 04 24             	mov    %eax,(%esp)
c0102f03:	e8 22 f9 ff ff       	call   c010282a <page_ref>
c0102f08:	85 c0                	test   %eax,%eax
c0102f0a:	75 0f                	jne    c0102f1b <basic_check+0x12d>
c0102f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f0f:	89 04 24             	mov    %eax,(%esp)
c0102f12:	e8 13 f9 ff ff       	call   c010282a <page_ref>
c0102f17:	85 c0                	test   %eax,%eax
c0102f19:	74 24                	je     c0102f3f <basic_check+0x151>
c0102f1b:	c7 44 24 0c 94 65 10 	movl   $0xc0106594,0xc(%esp)
c0102f22:	c0 
c0102f23:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102f2a:	c0 
c0102f2b:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0102f32:	00 
c0102f33:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102f3a:	e8 8d dd ff ff       	call   c0100ccc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f42:	89 04 24             	mov    %eax,(%esp)
c0102f45:	e8 ca f8 ff ff       	call   c0102814 <page2pa>
c0102f4a:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0102f50:	c1 e2 0c             	shl    $0xc,%edx
c0102f53:	39 d0                	cmp    %edx,%eax
c0102f55:	72 24                	jb     c0102f7b <basic_check+0x18d>
c0102f57:	c7 44 24 0c d0 65 10 	movl   $0xc01065d0,0xc(%esp)
c0102f5e:	c0 
c0102f5f:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102f66:	c0 
c0102f67:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0102f6e:	00 
c0102f6f:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102f76:	e8 51 dd ff ff       	call   c0100ccc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f7e:	89 04 24             	mov    %eax,(%esp)
c0102f81:	e8 8e f8 ff ff       	call   c0102814 <page2pa>
c0102f86:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0102f8c:	c1 e2 0c             	shl    $0xc,%edx
c0102f8f:	39 d0                	cmp    %edx,%eax
c0102f91:	72 24                	jb     c0102fb7 <basic_check+0x1c9>
c0102f93:	c7 44 24 0c ed 65 10 	movl   $0xc01065ed,0xc(%esp)
c0102f9a:	c0 
c0102f9b:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102fa2:	c0 
c0102fa3:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0102faa:	00 
c0102fab:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102fb2:	e8 15 dd ff ff       	call   c0100ccc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fba:	89 04 24             	mov    %eax,(%esp)
c0102fbd:	e8 52 f8 ff ff       	call   c0102814 <page2pa>
c0102fc2:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0102fc8:	c1 e2 0c             	shl    $0xc,%edx
c0102fcb:	39 d0                	cmp    %edx,%eax
c0102fcd:	72 24                	jb     c0102ff3 <basic_check+0x205>
c0102fcf:	c7 44 24 0c 0a 66 10 	movl   $0xc010660a,0xc(%esp)
c0102fd6:	c0 
c0102fd7:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102fde:	c0 
c0102fdf:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102fe6:	00 
c0102fe7:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102fee:	e8 d9 dc ff ff       	call   c0100ccc <__panic>

    list_entry_t free_list_store = free_list;
c0102ff3:	a1 70 89 11 c0       	mov    0xc0118970,%eax
c0102ff8:	8b 15 74 89 11 c0    	mov    0xc0118974,%edx
c0102ffe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103001:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103004:	c7 45 e0 70 89 11 c0 	movl   $0xc0118970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010300b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010300e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103011:	89 50 04             	mov    %edx,0x4(%eax)
c0103014:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103017:	8b 50 04             	mov    0x4(%eax),%edx
c010301a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010301d:	89 10                	mov    %edx,(%eax)
c010301f:	c7 45 dc 70 89 11 c0 	movl   $0xc0118970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103026:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103029:	8b 40 04             	mov    0x4(%eax),%eax
c010302c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010302f:	0f 94 c0             	sete   %al
c0103032:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103035:	85 c0                	test   %eax,%eax
c0103037:	75 24                	jne    c010305d <basic_check+0x26f>
c0103039:	c7 44 24 0c 27 66 10 	movl   $0xc0106627,0xc(%esp)
c0103040:	c0 
c0103041:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103048:	c0 
c0103049:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103050:	00 
c0103051:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103058:	e8 6f dc ff ff       	call   c0100ccc <__panic>

    unsigned int nr_free_store = nr_free;
c010305d:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103062:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103065:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c010306c:	00 00 00 

    assert(alloc_page() == NULL);
c010306f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103076:	e8 28 0c 00 00       	call   c0103ca3 <alloc_pages>
c010307b:	85 c0                	test   %eax,%eax
c010307d:	74 24                	je     c01030a3 <basic_check+0x2b5>
c010307f:	c7 44 24 0c 3e 66 10 	movl   $0xc010663e,0xc(%esp)
c0103086:	c0 
c0103087:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010308e:	c0 
c010308f:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103096:	00 
c0103097:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010309e:	e8 29 dc ff ff       	call   c0100ccc <__panic>

    free_page(p0);
c01030a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030aa:	00 
c01030ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030ae:	89 04 24             	mov    %eax,(%esp)
c01030b1:	e8 25 0c 00 00       	call   c0103cdb <free_pages>
    free_page(p1);
c01030b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030bd:	00 
c01030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030c1:	89 04 24             	mov    %eax,(%esp)
c01030c4:	e8 12 0c 00 00       	call   c0103cdb <free_pages>
    free_page(p2);
c01030c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030d0:	00 
c01030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030d4:	89 04 24             	mov    %eax,(%esp)
c01030d7:	e8 ff 0b 00 00       	call   c0103cdb <free_pages>
    assert(nr_free == 3);
c01030dc:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01030e1:	83 f8 03             	cmp    $0x3,%eax
c01030e4:	74 24                	je     c010310a <basic_check+0x31c>
c01030e6:	c7 44 24 0c 53 66 10 	movl   $0xc0106653,0xc(%esp)
c01030ed:	c0 
c01030ee:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01030f5:	c0 
c01030f6:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01030fd:	00 
c01030fe:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103105:	e8 c2 db ff ff       	call   c0100ccc <__panic>

    assert((p0 = alloc_page()) != NULL);
c010310a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103111:	e8 8d 0b 00 00       	call   c0103ca3 <alloc_pages>
c0103116:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103119:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010311d:	75 24                	jne    c0103143 <basic_check+0x355>
c010311f:	c7 44 24 0c 19 65 10 	movl   $0xc0106519,0xc(%esp)
c0103126:	c0 
c0103127:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010312e:	c0 
c010312f:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0103136:	00 
c0103137:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010313e:	e8 89 db ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103143:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010314a:	e8 54 0b 00 00       	call   c0103ca3 <alloc_pages>
c010314f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103156:	75 24                	jne    c010317c <basic_check+0x38e>
c0103158:	c7 44 24 0c 35 65 10 	movl   $0xc0106535,0xc(%esp)
c010315f:	c0 
c0103160:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103167:	c0 
c0103168:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c010316f:	00 
c0103170:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103177:	e8 50 db ff ff       	call   c0100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
c010317c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103183:	e8 1b 0b 00 00       	call   c0103ca3 <alloc_pages>
c0103188:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010318b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010318f:	75 24                	jne    c01031b5 <basic_check+0x3c7>
c0103191:	c7 44 24 0c 51 65 10 	movl   $0xc0106551,0xc(%esp)
c0103198:	c0 
c0103199:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01031a0:	c0 
c01031a1:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01031a8:	00 
c01031a9:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01031b0:	e8 17 db ff ff       	call   c0100ccc <__panic>

    assert(alloc_page() == NULL);
c01031b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031bc:	e8 e2 0a 00 00       	call   c0103ca3 <alloc_pages>
c01031c1:	85 c0                	test   %eax,%eax
c01031c3:	74 24                	je     c01031e9 <basic_check+0x3fb>
c01031c5:	c7 44 24 0c 3e 66 10 	movl   $0xc010663e,0xc(%esp)
c01031cc:	c0 
c01031cd:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01031d4:	c0 
c01031d5:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01031dc:	00 
c01031dd:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01031e4:	e8 e3 da ff ff       	call   c0100ccc <__panic>

    free_page(p0);
c01031e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031f0:	00 
c01031f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031f4:	89 04 24             	mov    %eax,(%esp)
c01031f7:	e8 df 0a 00 00       	call   c0103cdb <free_pages>
c01031fc:	c7 45 d8 70 89 11 c0 	movl   $0xc0118970,-0x28(%ebp)
c0103203:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103206:	8b 40 04             	mov    0x4(%eax),%eax
c0103209:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010320c:	0f 94 c0             	sete   %al
c010320f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103212:	85 c0                	test   %eax,%eax
c0103214:	74 24                	je     c010323a <basic_check+0x44c>
c0103216:	c7 44 24 0c 60 66 10 	movl   $0xc0106660,0xc(%esp)
c010321d:	c0 
c010321e:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103225:	c0 
c0103226:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c010322d:	00 
c010322e:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103235:	e8 92 da ff ff       	call   c0100ccc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010323a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103241:	e8 5d 0a 00 00       	call   c0103ca3 <alloc_pages>
c0103246:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103249:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010324c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010324f:	74 24                	je     c0103275 <basic_check+0x487>
c0103251:	c7 44 24 0c 78 66 10 	movl   $0xc0106678,0xc(%esp)
c0103258:	c0 
c0103259:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103260:	c0 
c0103261:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103268:	00 
c0103269:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103270:	e8 57 da ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c0103275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010327c:	e8 22 0a 00 00       	call   c0103ca3 <alloc_pages>
c0103281:	85 c0                	test   %eax,%eax
c0103283:	74 24                	je     c01032a9 <basic_check+0x4bb>
c0103285:	c7 44 24 0c 3e 66 10 	movl   $0xc010663e,0xc(%esp)
c010328c:	c0 
c010328d:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103294:	c0 
c0103295:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010329c:	00 
c010329d:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01032a4:	e8 23 da ff ff       	call   c0100ccc <__panic>

    assert(nr_free == 0);
c01032a9:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c01032ae:	85 c0                	test   %eax,%eax
c01032b0:	74 24                	je     c01032d6 <basic_check+0x4e8>
c01032b2:	c7 44 24 0c 91 66 10 	movl   $0xc0106691,0xc(%esp)
c01032b9:	c0 
c01032ba:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01032c1:	c0 
c01032c2:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c01032c9:	00 
c01032ca:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01032d1:	e8 f6 d9 ff ff       	call   c0100ccc <__panic>
    free_list = free_list_store;
c01032d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032dc:	a3 70 89 11 c0       	mov    %eax,0xc0118970
c01032e1:	89 15 74 89 11 c0    	mov    %edx,0xc0118974
    nr_free = nr_free_store;
c01032e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032ea:	a3 78 89 11 c0       	mov    %eax,0xc0118978

    free_page(p);
c01032ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032f6:	00 
c01032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032fa:	89 04 24             	mov    %eax,(%esp)
c01032fd:	e8 d9 09 00 00       	call   c0103cdb <free_pages>
    free_page(p1);
c0103302:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103309:	00 
c010330a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010330d:	89 04 24             	mov    %eax,(%esp)
c0103310:	e8 c6 09 00 00       	call   c0103cdb <free_pages>
    free_page(p2);
c0103315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010331c:	00 
c010331d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103320:	89 04 24             	mov    %eax,(%esp)
c0103323:	e8 b3 09 00 00       	call   c0103cdb <free_pages>
}
c0103328:	c9                   	leave  
c0103329:	c3                   	ret    

c010332a <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010332a:	55                   	push   %ebp
c010332b:	89 e5                	mov    %esp,%ebp
c010332d:	53                   	push   %ebx
c010332e:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103334:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010333b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103342:	c7 45 ec 70 89 11 c0 	movl   $0xc0118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103349:	eb 6b                	jmp    c01033b6 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010334b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010334e:	83 e8 0c             	sub    $0xc,%eax
c0103351:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103354:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103357:	83 c0 04             	add    $0x4,%eax
c010335a:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103361:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103364:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103367:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010336a:	0f a3 10             	bt     %edx,(%eax)
c010336d:	19 c0                	sbb    %eax,%eax
c010336f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103372:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103376:	0f 95 c0             	setne  %al
c0103379:	0f b6 c0             	movzbl %al,%eax
c010337c:	85 c0                	test   %eax,%eax
c010337e:	75 24                	jne    c01033a4 <default_check+0x7a>
c0103380:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c0103387:	c0 
c0103388:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010338f:	c0 
c0103390:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103397:	00 
c0103398:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010339f:	e8 28 d9 ff ff       	call   c0100ccc <__panic>
        count ++, total += p->property;
c01033a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033ab:	8b 50 08             	mov    0x8(%eax),%edx
c01033ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033b1:	01 d0                	add    %edx,%eax
c01033b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033bf:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033c5:	81 7d ec 70 89 11 c0 	cmpl   $0xc0118970,-0x14(%ebp)
c01033cc:	0f 85 79 ff ff ff    	jne    c010334b <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01033d2:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01033d5:	e8 33 09 00 00       	call   c0103d0d <nr_free_pages>
c01033da:	39 c3                	cmp    %eax,%ebx
c01033dc:	74 24                	je     c0103402 <default_check+0xd8>
c01033de:	c7 44 24 0c ae 66 10 	movl   $0xc01066ae,0xc(%esp)
c01033e5:	c0 
c01033e6:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01033ed:	c0 
c01033ee:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01033f5:	00 
c01033f6:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01033fd:	e8 ca d8 ff ff       	call   c0100ccc <__panic>

    basic_check();
c0103402:	e8 e7 f9 ff ff       	call   c0102dee <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103407:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010340e:	e8 90 08 00 00       	call   c0103ca3 <alloc_pages>
c0103413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103416:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010341a:	75 24                	jne    c0103440 <default_check+0x116>
c010341c:	c7 44 24 0c c7 66 10 	movl   $0xc01066c7,0xc(%esp)
c0103423:	c0 
c0103424:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010342b:	c0 
c010342c:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103433:	00 
c0103434:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010343b:	e8 8c d8 ff ff       	call   c0100ccc <__panic>
    assert(!PageProperty(p0));
c0103440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103443:	83 c0 04             	add    $0x4,%eax
c0103446:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010344d:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103450:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103453:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103456:	0f a3 10             	bt     %edx,(%eax)
c0103459:	19 c0                	sbb    %eax,%eax
c010345b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010345e:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103462:	0f 95 c0             	setne  %al
c0103465:	0f b6 c0             	movzbl %al,%eax
c0103468:	85 c0                	test   %eax,%eax
c010346a:	74 24                	je     c0103490 <default_check+0x166>
c010346c:	c7 44 24 0c d2 66 10 	movl   $0xc01066d2,0xc(%esp)
c0103473:	c0 
c0103474:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010347b:	c0 
c010347c:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103483:	00 
c0103484:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010348b:	e8 3c d8 ff ff       	call   c0100ccc <__panic>

    list_entry_t free_list_store = free_list;
c0103490:	a1 70 89 11 c0       	mov    0xc0118970,%eax
c0103495:	8b 15 74 89 11 c0    	mov    0xc0118974,%edx
c010349b:	89 45 80             	mov    %eax,-0x80(%ebp)
c010349e:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034a1:	c7 45 b4 70 89 11 c0 	movl   $0xc0118970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034ab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034ae:	89 50 04             	mov    %edx,0x4(%eax)
c01034b1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034b4:	8b 50 04             	mov    0x4(%eax),%edx
c01034b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034ba:	89 10                	mov    %edx,(%eax)
c01034bc:	c7 45 b0 70 89 11 c0 	movl   $0xc0118970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01034c3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034c6:	8b 40 04             	mov    0x4(%eax),%eax
c01034c9:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01034cc:	0f 94 c0             	sete   %al
c01034cf:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01034d2:	85 c0                	test   %eax,%eax
c01034d4:	75 24                	jne    c01034fa <default_check+0x1d0>
c01034d6:	c7 44 24 0c 27 66 10 	movl   $0xc0106627,0xc(%esp)
c01034dd:	c0 
c01034de:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01034e5:	c0 
c01034e6:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01034ed:	00 
c01034ee:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01034f5:	e8 d2 d7 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c01034fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103501:	e8 9d 07 00 00       	call   c0103ca3 <alloc_pages>
c0103506:	85 c0                	test   %eax,%eax
c0103508:	74 24                	je     c010352e <default_check+0x204>
c010350a:	c7 44 24 0c 3e 66 10 	movl   $0xc010663e,0xc(%esp)
c0103511:	c0 
c0103512:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103519:	c0 
c010351a:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103521:	00 
c0103522:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103529:	e8 9e d7 ff ff       	call   c0100ccc <__panic>

    unsigned int nr_free_store = nr_free;
c010352e:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103533:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103536:	c7 05 78 89 11 c0 00 	movl   $0x0,0xc0118978
c010353d:	00 00 00 

    free_pages(p0 + 2, 3);
c0103540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103543:	83 c0 28             	add    $0x28,%eax
c0103546:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010354d:	00 
c010354e:	89 04 24             	mov    %eax,(%esp)
c0103551:	e8 85 07 00 00       	call   c0103cdb <free_pages>
    assert(alloc_pages(4) == NULL);
c0103556:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010355d:	e8 41 07 00 00       	call   c0103ca3 <alloc_pages>
c0103562:	85 c0                	test   %eax,%eax
c0103564:	74 24                	je     c010358a <default_check+0x260>
c0103566:	c7 44 24 0c e4 66 10 	movl   $0xc01066e4,0xc(%esp)
c010356d:	c0 
c010356e:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103575:	c0 
c0103576:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010357d:	00 
c010357e:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103585:	e8 42 d7 ff ff       	call   c0100ccc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010358a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010358d:	83 c0 28             	add    $0x28,%eax
c0103590:	83 c0 04             	add    $0x4,%eax
c0103593:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010359a:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010359d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035a0:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035a3:	0f a3 10             	bt     %edx,(%eax)
c01035a6:	19 c0                	sbb    %eax,%eax
c01035a8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035ab:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035af:	0f 95 c0             	setne  %al
c01035b2:	0f b6 c0             	movzbl %al,%eax
c01035b5:	85 c0                	test   %eax,%eax
c01035b7:	74 0e                	je     c01035c7 <default_check+0x29d>
c01035b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035bc:	83 c0 28             	add    $0x28,%eax
c01035bf:	8b 40 08             	mov    0x8(%eax),%eax
c01035c2:	83 f8 03             	cmp    $0x3,%eax
c01035c5:	74 24                	je     c01035eb <default_check+0x2c1>
c01035c7:	c7 44 24 0c fc 66 10 	movl   $0xc01066fc,0xc(%esp)
c01035ce:	c0 
c01035cf:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01035d6:	c0 
c01035d7:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01035de:	00 
c01035df:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01035e6:	e8 e1 d6 ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01035eb:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01035f2:	e8 ac 06 00 00       	call   c0103ca3 <alloc_pages>
c01035f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01035fe:	75 24                	jne    c0103624 <default_check+0x2fa>
c0103600:	c7 44 24 0c 28 67 10 	movl   $0xc0106728,0xc(%esp)
c0103607:	c0 
c0103608:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010360f:	c0 
c0103610:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103617:	00 
c0103618:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010361f:	e8 a8 d6 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c0103624:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010362b:	e8 73 06 00 00       	call   c0103ca3 <alloc_pages>
c0103630:	85 c0                	test   %eax,%eax
c0103632:	74 24                	je     c0103658 <default_check+0x32e>
c0103634:	c7 44 24 0c 3e 66 10 	movl   $0xc010663e,0xc(%esp)
c010363b:	c0 
c010363c:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103643:	c0 
c0103644:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010364b:	00 
c010364c:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103653:	e8 74 d6 ff ff       	call   c0100ccc <__panic>
    assert(p0 + 2 == p1);
c0103658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010365b:	83 c0 28             	add    $0x28,%eax
c010365e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103661:	74 24                	je     c0103687 <default_check+0x35d>
c0103663:	c7 44 24 0c 46 67 10 	movl   $0xc0106746,0xc(%esp)
c010366a:	c0 
c010366b:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103672:	c0 
c0103673:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010367a:	00 
c010367b:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103682:	e8 45 d6 ff ff       	call   c0100ccc <__panic>

    p2 = p0 + 1;
c0103687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010368a:	83 c0 14             	add    $0x14,%eax
c010368d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103690:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103697:	00 
c0103698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010369b:	89 04 24             	mov    %eax,(%esp)
c010369e:	e8 38 06 00 00       	call   c0103cdb <free_pages>
    free_pages(p1, 3);
c01036a3:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036aa:	00 
c01036ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036ae:	89 04 24             	mov    %eax,(%esp)
c01036b1:	e8 25 06 00 00       	call   c0103cdb <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036b9:	83 c0 04             	add    $0x4,%eax
c01036bc:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01036c3:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036c6:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01036c9:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01036cc:	0f a3 10             	bt     %edx,(%eax)
c01036cf:	19 c0                	sbb    %eax,%eax
c01036d1:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01036d4:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01036d8:	0f 95 c0             	setne  %al
c01036db:	0f b6 c0             	movzbl %al,%eax
c01036de:	85 c0                	test   %eax,%eax
c01036e0:	74 0b                	je     c01036ed <default_check+0x3c3>
c01036e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036e5:	8b 40 08             	mov    0x8(%eax),%eax
c01036e8:	83 f8 01             	cmp    $0x1,%eax
c01036eb:	74 24                	je     c0103711 <default_check+0x3e7>
c01036ed:	c7 44 24 0c 54 67 10 	movl   $0xc0106754,0xc(%esp)
c01036f4:	c0 
c01036f5:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01036fc:	c0 
c01036fd:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103704:	00 
c0103705:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010370c:	e8 bb d5 ff ff       	call   c0100ccc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103711:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103714:	83 c0 04             	add    $0x4,%eax
c0103717:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010371e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103721:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103724:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103727:	0f a3 10             	bt     %edx,(%eax)
c010372a:	19 c0                	sbb    %eax,%eax
c010372c:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010372f:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103733:	0f 95 c0             	setne  %al
c0103736:	0f b6 c0             	movzbl %al,%eax
c0103739:	85 c0                	test   %eax,%eax
c010373b:	74 0b                	je     c0103748 <default_check+0x41e>
c010373d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103740:	8b 40 08             	mov    0x8(%eax),%eax
c0103743:	83 f8 03             	cmp    $0x3,%eax
c0103746:	74 24                	je     c010376c <default_check+0x442>
c0103748:	c7 44 24 0c 7c 67 10 	movl   $0xc010677c,0xc(%esp)
c010374f:	c0 
c0103750:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103757:	c0 
c0103758:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c010375f:	00 
c0103760:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103767:	e8 60 d5 ff ff       	call   c0100ccc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010376c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103773:	e8 2b 05 00 00       	call   c0103ca3 <alloc_pages>
c0103778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010377b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010377e:	83 e8 14             	sub    $0x14,%eax
c0103781:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103784:	74 24                	je     c01037aa <default_check+0x480>
c0103786:	c7 44 24 0c a2 67 10 	movl   $0xc01067a2,0xc(%esp)
c010378d:	c0 
c010378e:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103795:	c0 
c0103796:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010379d:	00 
c010379e:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01037a5:	e8 22 d5 ff ff       	call   c0100ccc <__panic>
    free_page(p0);
c01037aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037b1:	00 
c01037b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037b5:	89 04 24             	mov    %eax,(%esp)
c01037b8:	e8 1e 05 00 00       	call   c0103cdb <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01037bd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01037c4:	e8 da 04 00 00       	call   c0103ca3 <alloc_pages>
c01037c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037cf:	83 c0 14             	add    $0x14,%eax
c01037d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037d5:	74 24                	je     c01037fb <default_check+0x4d1>
c01037d7:	c7 44 24 0c c0 67 10 	movl   $0xc01067c0,0xc(%esp)
c01037de:	c0 
c01037df:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01037e6:	c0 
c01037e7:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01037ee:	00 
c01037ef:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01037f6:	e8 d1 d4 ff ff       	call   c0100ccc <__panic>

    free_pages(p0, 2);
c01037fb:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103802:	00 
c0103803:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103806:	89 04 24             	mov    %eax,(%esp)
c0103809:	e8 cd 04 00 00       	call   c0103cdb <free_pages>
    free_page(p2);
c010380e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103815:	00 
c0103816:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103819:	89 04 24             	mov    %eax,(%esp)
c010381c:	e8 ba 04 00 00       	call   c0103cdb <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103821:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103828:	e8 76 04 00 00       	call   c0103ca3 <alloc_pages>
c010382d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103830:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103834:	75 24                	jne    c010385a <default_check+0x530>
c0103836:	c7 44 24 0c e0 67 10 	movl   $0xc01067e0,0xc(%esp)
c010383d:	c0 
c010383e:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103845:	c0 
c0103846:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c010384d:	00 
c010384e:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103855:	e8 72 d4 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c010385a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103861:	e8 3d 04 00 00       	call   c0103ca3 <alloc_pages>
c0103866:	85 c0                	test   %eax,%eax
c0103868:	74 24                	je     c010388e <default_check+0x564>
c010386a:	c7 44 24 0c 3e 66 10 	movl   $0xc010663e,0xc(%esp)
c0103871:	c0 
c0103872:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103879:	c0 
c010387a:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103881:	00 
c0103882:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103889:	e8 3e d4 ff ff       	call   c0100ccc <__panic>

    assert(nr_free == 0);
c010388e:	a1 78 89 11 c0       	mov    0xc0118978,%eax
c0103893:	85 c0                	test   %eax,%eax
c0103895:	74 24                	je     c01038bb <default_check+0x591>
c0103897:	c7 44 24 0c 91 66 10 	movl   $0xc0106691,0xc(%esp)
c010389e:	c0 
c010389f:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01038a6:	c0 
c01038a7:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01038ae:	00 
c01038af:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01038b6:	e8 11 d4 ff ff       	call   c0100ccc <__panic>
    nr_free = nr_free_store;
c01038bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038be:	a3 78 89 11 c0       	mov    %eax,0xc0118978

    free_list = free_list_store;
c01038c3:	8b 45 80             	mov    -0x80(%ebp),%eax
c01038c6:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038c9:	a3 70 89 11 c0       	mov    %eax,0xc0118970
c01038ce:	89 15 74 89 11 c0    	mov    %edx,0xc0118974
    free_pages(p0, 5);
c01038d4:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01038db:	00 
c01038dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038df:	89 04 24             	mov    %eax,(%esp)
c01038e2:	e8 f4 03 00 00       	call   c0103cdb <free_pages>

    le = &free_list;
c01038e7:	c7 45 ec 70 89 11 c0 	movl   $0xc0118970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01038ee:	eb 1d                	jmp    c010390d <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01038f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038f3:	83 e8 0c             	sub    $0xc,%eax
c01038f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01038f9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01038fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103900:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103903:	8b 40 08             	mov    0x8(%eax),%eax
c0103906:	29 c2                	sub    %eax,%edx
c0103908:	89 d0                	mov    %edx,%eax
c010390a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010390d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103910:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103913:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103916:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103919:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010391c:	81 7d ec 70 89 11 c0 	cmpl   $0xc0118970,-0x14(%ebp)
c0103923:	75 cb                	jne    c01038f0 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103929:	74 24                	je     c010394f <default_check+0x625>
c010392b:	c7 44 24 0c fe 67 10 	movl   $0xc01067fe,0xc(%esp)
c0103932:	c0 
c0103933:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010393a:	c0 
c010393b:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103942:	00 
c0103943:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010394a:	e8 7d d3 ff ff       	call   c0100ccc <__panic>
    assert(total == 0);
c010394f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103953:	74 24                	je     c0103979 <default_check+0x64f>
c0103955:	c7 44 24 0c 09 68 10 	movl   $0xc0106809,0xc(%esp)
c010395c:	c0 
c010395d:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103964:	c0 
c0103965:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010396c:	00 
c010396d:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103974:	e8 53 d3 ff ff       	call   c0100ccc <__panic>
}
c0103979:	81 c4 94 00 00 00    	add    $0x94,%esp
c010397f:	5b                   	pop    %ebx
c0103980:	5d                   	pop    %ebp
c0103981:	c3                   	ret    

c0103982 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103982:	55                   	push   %ebp
c0103983:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103985:	8b 55 08             	mov    0x8(%ebp),%edx
c0103988:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c010398d:	29 c2                	sub    %eax,%edx
c010398f:	89 d0                	mov    %edx,%eax
c0103991:	c1 f8 02             	sar    $0x2,%eax
c0103994:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010399a:	5d                   	pop    %ebp
c010399b:	c3                   	ret    

c010399c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010399c:	55                   	push   %ebp
c010399d:	89 e5                	mov    %esp,%ebp
c010399f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a5:	89 04 24             	mov    %eax,(%esp)
c01039a8:	e8 d5 ff ff ff       	call   c0103982 <page2ppn>
c01039ad:	c1 e0 0c             	shl    $0xc,%eax
}
c01039b0:	c9                   	leave  
c01039b1:	c3                   	ret    

c01039b2 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01039b2:	55                   	push   %ebp
c01039b3:	89 e5                	mov    %esp,%ebp
c01039b5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01039b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bb:	c1 e8 0c             	shr    $0xc,%eax
c01039be:	89 c2                	mov    %eax,%edx
c01039c0:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c01039c5:	39 c2                	cmp    %eax,%edx
c01039c7:	72 1c                	jb     c01039e5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01039c9:	c7 44 24 08 44 68 10 	movl   $0xc0106844,0x8(%esp)
c01039d0:	c0 
c01039d1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01039d8:	00 
c01039d9:	c7 04 24 63 68 10 c0 	movl   $0xc0106863,(%esp)
c01039e0:	e8 e7 d2 ff ff       	call   c0100ccc <__panic>
    }
    return &pages[PPN(pa)];
c01039e5:	8b 0d 84 89 11 c0    	mov    0xc0118984,%ecx
c01039eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ee:	c1 e8 0c             	shr    $0xc,%eax
c01039f1:	89 c2                	mov    %eax,%edx
c01039f3:	89 d0                	mov    %edx,%eax
c01039f5:	c1 e0 02             	shl    $0x2,%eax
c01039f8:	01 d0                	add    %edx,%eax
c01039fa:	c1 e0 02             	shl    $0x2,%eax
c01039fd:	01 c8                	add    %ecx,%eax
}
c01039ff:	c9                   	leave  
c0103a00:	c3                   	ret    

c0103a01 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a01:	55                   	push   %ebp
c0103a02:	89 e5                	mov    %esp,%ebp
c0103a04:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a0a:	89 04 24             	mov    %eax,(%esp)
c0103a0d:	e8 8a ff ff ff       	call   c010399c <page2pa>
c0103a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a18:	c1 e8 0c             	shr    $0xc,%eax
c0103a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a1e:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103a23:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a26:	72 23                	jb     c0103a4b <page2kva+0x4a>
c0103a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a2f:	c7 44 24 08 74 68 10 	movl   $0xc0106874,0x8(%esp)
c0103a36:	c0 
c0103a37:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a3e:	00 
c0103a3f:	c7 04 24 63 68 10 c0 	movl   $0xc0106863,(%esp)
c0103a46:	e8 81 d2 ff ff       	call   c0100ccc <__panic>
c0103a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a53:	c9                   	leave  
c0103a54:	c3                   	ret    

c0103a55 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a55:	55                   	push   %ebp
c0103a56:	89 e5                	mov    %esp,%ebp
c0103a58:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5e:	83 e0 01             	and    $0x1,%eax
c0103a61:	85 c0                	test   %eax,%eax
c0103a63:	75 1c                	jne    c0103a81 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a65:	c7 44 24 08 98 68 10 	movl   $0xc0106898,0x8(%esp)
c0103a6c:	c0 
c0103a6d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a74:	00 
c0103a75:	c7 04 24 63 68 10 c0 	movl   $0xc0106863,(%esp)
c0103a7c:	e8 4b d2 ff ff       	call   c0100ccc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a89:	89 04 24             	mov    %eax,(%esp)
c0103a8c:	e8 21 ff ff ff       	call   c01039b2 <pa2page>
}
c0103a91:	c9                   	leave  
c0103a92:	c3                   	ret    

c0103a93 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103a93:	55                   	push   %ebp
c0103a94:	89 e5                	mov    %esp,%ebp
c0103a96:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103aa1:	89 04 24             	mov    %eax,(%esp)
c0103aa4:	e8 09 ff ff ff       	call   c01039b2 <pa2page>
}
c0103aa9:	c9                   	leave  
c0103aaa:	c3                   	ret    

c0103aab <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103aab:	55                   	push   %ebp
c0103aac:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab1:	8b 00                	mov    (%eax),%eax
}
c0103ab3:	5d                   	pop    %ebp
c0103ab4:	c3                   	ret    

c0103ab5 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103ab5:	55                   	push   %ebp
c0103ab6:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103ab8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103abb:	8b 00                	mov    (%eax),%eax
c0103abd:	8d 50 01             	lea    0x1(%eax),%edx
c0103ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac3:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac8:	8b 00                	mov    (%eax),%eax
}
c0103aca:	5d                   	pop    %ebp
c0103acb:	c3                   	ret    

c0103acc <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103acc:	55                   	push   %ebp
c0103acd:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad2:	8b 00                	mov    (%eax),%eax
c0103ad4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ada:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103adf:	8b 00                	mov    (%eax),%eax
}
c0103ae1:	5d                   	pop    %ebp
c0103ae2:	c3                   	ret    

c0103ae3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103ae3:	55                   	push   %ebp
c0103ae4:	89 e5                	mov    %esp,%ebp
c0103ae6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103ae9:	9c                   	pushf  
c0103aea:	58                   	pop    %eax
c0103aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103af1:	25 00 02 00 00       	and    $0x200,%eax
c0103af6:	85 c0                	test   %eax,%eax
c0103af8:	74 0c                	je     c0103b06 <__intr_save+0x23>
        intr_disable();
c0103afa:	e8 b0 db ff ff       	call   c01016af <intr_disable>
        return 1;
c0103aff:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b04:	eb 05                	jmp    c0103b0b <__intr_save+0x28>
    }
    return 0;
c0103b06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b0b:	c9                   	leave  
c0103b0c:	c3                   	ret    

c0103b0d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b0d:	55                   	push   %ebp
c0103b0e:	89 e5                	mov    %esp,%ebp
c0103b10:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b17:	74 05                	je     c0103b1e <__intr_restore+0x11>
        intr_enable();
c0103b19:	e8 8b db ff ff       	call   c01016a9 <intr_enable>
    }
}
c0103b1e:	c9                   	leave  
c0103b1f:	c3                   	ret    

c0103b20 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b20:	55                   	push   %ebp
c0103b21:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b26:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b29:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b2e:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b30:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b35:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b37:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b3c:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b3e:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b43:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b45:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b4a:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b4c:	ea 53 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b53
}
c0103b53:	5d                   	pop    %ebp
c0103b54:	c3                   	ret    

c0103b55 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b55:	55                   	push   %ebp
c0103b56:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b5b:	a3 04 89 11 c0       	mov    %eax,0xc0118904
}
c0103b60:	5d                   	pop    %ebp
c0103b61:	c3                   	ret    

c0103b62 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b62:	55                   	push   %ebp
c0103b63:	89 e5                	mov    %esp,%ebp
c0103b65:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b68:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b6d:	89 04 24             	mov    %eax,(%esp)
c0103b70:	e8 e0 ff ff ff       	call   c0103b55 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b75:	66 c7 05 08 89 11 c0 	movw   $0x10,0xc0118908
c0103b7c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b7e:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103b85:	68 00 
c0103b87:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103b8c:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103b92:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103b97:	c1 e8 10             	shr    $0x10,%eax
c0103b9a:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103b9f:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103ba6:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ba9:	83 c8 09             	or     $0x9,%eax
c0103bac:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bb1:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bb8:	83 e0 ef             	and    $0xffffffef,%eax
c0103bbb:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bc0:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bc7:	83 e0 9f             	and    $0xffffff9f,%eax
c0103bca:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bcf:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bd6:	83 c8 80             	or     $0xffffff80,%eax
c0103bd9:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bde:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103be5:	83 e0 f0             	and    $0xfffffff0,%eax
c0103be8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bed:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103bf4:	83 e0 ef             	and    $0xffffffef,%eax
c0103bf7:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103bfc:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c03:	83 e0 df             	and    $0xffffffdf,%eax
c0103c06:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c0b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c12:	83 c8 40             	or     $0x40,%eax
c0103c15:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c1a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c21:	83 e0 7f             	and    $0x7f,%eax
c0103c24:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c29:	b8 00 89 11 c0       	mov    $0xc0118900,%eax
c0103c2e:	c1 e8 18             	shr    $0x18,%eax
c0103c31:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c36:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c3d:	e8 de fe ff ff       	call   c0103b20 <lgdt>
c0103c42:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c48:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c4c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c4f:	c9                   	leave  
c0103c50:	c3                   	ret    

c0103c51 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c51:	55                   	push   %ebp
c0103c52:	89 e5                	mov    %esp,%ebp
c0103c54:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c57:	c7 05 7c 89 11 c0 28 	movl   $0xc0106828,0xc011897c
c0103c5e:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c61:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103c66:	8b 00                	mov    (%eax),%eax
c0103c68:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c6c:	c7 04 24 c4 68 10 c0 	movl   $0xc01068c4,(%esp)
c0103c73:	e8 c4 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c78:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103c7d:	8b 40 04             	mov    0x4(%eax),%eax
c0103c80:	ff d0                	call   *%eax
}
c0103c82:	c9                   	leave  
c0103c83:	c3                   	ret    

c0103c84 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c84:	55                   	push   %ebp
c0103c85:	89 e5                	mov    %esp,%ebp
c0103c87:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103c8a:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103c8f:	8b 40 08             	mov    0x8(%eax),%eax
c0103c92:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c95:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c99:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c9c:	89 14 24             	mov    %edx,(%esp)
c0103c9f:	ff d0                	call   *%eax
}
c0103ca1:	c9                   	leave  
c0103ca2:	c3                   	ret    

c0103ca3 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103ca3:	55                   	push   %ebp
c0103ca4:	89 e5                	mov    %esp,%ebp
c0103ca6:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103ca9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cb0:	e8 2e fe ff ff       	call   c0103ae3 <__intr_save>
c0103cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103cb8:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103cbd:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cc0:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cc3:	89 14 24             	mov    %edx,(%esp)
c0103cc6:	ff d0                	call   *%eax
c0103cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cce:	89 04 24             	mov    %eax,(%esp)
c0103cd1:	e8 37 fe ff ff       	call   c0103b0d <__intr_restore>
    return page;
c0103cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cd9:	c9                   	leave  
c0103cda:	c3                   	ret    

c0103cdb <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103cdb:	55                   	push   %ebp
c0103cdc:	89 e5                	mov    %esp,%ebp
c0103cde:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ce1:	e8 fd fd ff ff       	call   c0103ae3 <__intr_save>
c0103ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103ce9:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103cee:	8b 40 10             	mov    0x10(%eax),%eax
c0103cf1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cf4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cf8:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cfb:	89 14 24             	mov    %edx,(%esp)
c0103cfe:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d03:	89 04 24             	mov    %eax,(%esp)
c0103d06:	e8 02 fe ff ff       	call   c0103b0d <__intr_restore>
}
c0103d0b:	c9                   	leave  
c0103d0c:	c3                   	ret    

c0103d0d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d0d:	55                   	push   %ebp
c0103d0e:	89 e5                	mov    %esp,%ebp
c0103d10:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d13:	e8 cb fd ff ff       	call   c0103ae3 <__intr_save>
c0103d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d1b:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c0103d20:	8b 40 14             	mov    0x14(%eax),%eax
c0103d23:	ff d0                	call   *%eax
c0103d25:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d2b:	89 04 24             	mov    %eax,(%esp)
c0103d2e:	e8 da fd ff ff       	call   c0103b0d <__intr_restore>
    return ret;
c0103d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d36:	c9                   	leave  
c0103d37:	c3                   	ret    

c0103d38 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d38:	55                   	push   %ebp
c0103d39:	89 e5                	mov    %esp,%ebp
c0103d3b:	57                   	push   %edi
c0103d3c:	56                   	push   %esi
c0103d3d:	53                   	push   %ebx
c0103d3e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d44:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d4b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d59:	c7 04 24 db 68 10 c0 	movl   $0xc01068db,(%esp)
c0103d60:	e8 d7 c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d6c:	e9 15 01 00 00       	jmp    c0103e86 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d74:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d77:	89 d0                	mov    %edx,%eax
c0103d79:	c1 e0 02             	shl    $0x2,%eax
c0103d7c:	01 d0                	add    %edx,%eax
c0103d7e:	c1 e0 02             	shl    $0x2,%eax
c0103d81:	01 c8                	add    %ecx,%eax
c0103d83:	8b 50 08             	mov    0x8(%eax),%edx
c0103d86:	8b 40 04             	mov    0x4(%eax),%eax
c0103d89:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103d8c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103d8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d92:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d95:	89 d0                	mov    %edx,%eax
c0103d97:	c1 e0 02             	shl    $0x2,%eax
c0103d9a:	01 d0                	add    %edx,%eax
c0103d9c:	c1 e0 02             	shl    $0x2,%eax
c0103d9f:	01 c8                	add    %ecx,%eax
c0103da1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103da4:	8b 58 10             	mov    0x10(%eax),%ebx
c0103da7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103daa:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103dad:	01 c8                	add    %ecx,%eax
c0103daf:	11 da                	adc    %ebx,%edx
c0103db1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103db4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103db7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dbd:	89 d0                	mov    %edx,%eax
c0103dbf:	c1 e0 02             	shl    $0x2,%eax
c0103dc2:	01 d0                	add    %edx,%eax
c0103dc4:	c1 e0 02             	shl    $0x2,%eax
c0103dc7:	01 c8                	add    %ecx,%eax
c0103dc9:	83 c0 14             	add    $0x14,%eax
c0103dcc:	8b 00                	mov    (%eax),%eax
c0103dce:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103dd4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103dd7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103dda:	83 c0 ff             	add    $0xffffffff,%eax
c0103ddd:	83 d2 ff             	adc    $0xffffffff,%edx
c0103de0:	89 c6                	mov    %eax,%esi
c0103de2:	89 d7                	mov    %edx,%edi
c0103de4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103de7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dea:	89 d0                	mov    %edx,%eax
c0103dec:	c1 e0 02             	shl    $0x2,%eax
c0103def:	01 d0                	add    %edx,%eax
c0103df1:	c1 e0 02             	shl    $0x2,%eax
c0103df4:	01 c8                	add    %ecx,%eax
c0103df6:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103df9:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dfc:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e02:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e06:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e0a:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e0e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e11:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e14:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e18:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e1c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e20:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e24:	c7 04 24 e8 68 10 c0 	movl   $0xc01068e8,(%esp)
c0103e2b:	e8 0c c5 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e30:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e33:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e36:	89 d0                	mov    %edx,%eax
c0103e38:	c1 e0 02             	shl    $0x2,%eax
c0103e3b:	01 d0                	add    %edx,%eax
c0103e3d:	c1 e0 02             	shl    $0x2,%eax
c0103e40:	01 c8                	add    %ecx,%eax
c0103e42:	83 c0 14             	add    $0x14,%eax
c0103e45:	8b 00                	mov    (%eax),%eax
c0103e47:	83 f8 01             	cmp    $0x1,%eax
c0103e4a:	75 36                	jne    c0103e82 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e52:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e55:	77 2b                	ja     c0103e82 <page_init+0x14a>
c0103e57:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e5a:	72 05                	jb     c0103e61 <page_init+0x129>
c0103e5c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e5f:	73 21                	jae    c0103e82 <page_init+0x14a>
c0103e61:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e65:	77 1b                	ja     c0103e82 <page_init+0x14a>
c0103e67:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e6b:	72 09                	jb     c0103e76 <page_init+0x13e>
c0103e6d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e74:	77 0c                	ja     c0103e82 <page_init+0x14a>
                maxpa = end;
c0103e76:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e79:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e82:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e86:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e89:	8b 00                	mov    (%eax),%eax
c0103e8b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103e8e:	0f 8f dd fe ff ff    	jg     c0103d71 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103e94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e98:	72 1d                	jb     c0103eb7 <page_init+0x17f>
c0103e9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e9e:	77 09                	ja     c0103ea9 <page_init+0x171>
c0103ea0:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103ea7:	76 0e                	jbe    c0103eb7 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ea9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103eb0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103eba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ebd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ec1:	c1 ea 0c             	shr    $0xc,%edx
c0103ec4:	a3 e0 88 11 c0       	mov    %eax,0xc01188e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103ec9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103ed0:	b8 88 89 11 c0       	mov    $0xc0118988,%eax
c0103ed5:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ed8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103edb:	01 d0                	add    %edx,%eax
c0103edd:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103ee0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ee3:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ee8:	f7 75 ac             	divl   -0x54(%ebp)
c0103eeb:	89 d0                	mov    %edx,%eax
c0103eed:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103ef0:	29 c2                	sub    %eax,%edx
c0103ef2:	89 d0                	mov    %edx,%eax
c0103ef4:	a3 84 89 11 c0       	mov    %eax,0xc0118984

    for (i = 0; i < npage; i ++) {
c0103ef9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f00:	eb 2f                	jmp    c0103f31 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f02:	8b 0d 84 89 11 c0    	mov    0xc0118984,%ecx
c0103f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f0b:	89 d0                	mov    %edx,%eax
c0103f0d:	c1 e0 02             	shl    $0x2,%eax
c0103f10:	01 d0                	add    %edx,%eax
c0103f12:	c1 e0 02             	shl    $0x2,%eax
c0103f15:	01 c8                	add    %ecx,%eax
c0103f17:	83 c0 04             	add    $0x4,%eax
c0103f1a:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f21:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f24:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f27:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f2a:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f2d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f34:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0103f39:	39 c2                	cmp    %eax,%edx
c0103f3b:	72 c5                	jb     c0103f02 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f3d:	8b 15 e0 88 11 c0    	mov    0xc01188e0,%edx
c0103f43:	89 d0                	mov    %edx,%eax
c0103f45:	c1 e0 02             	shl    $0x2,%eax
c0103f48:	01 d0                	add    %edx,%eax
c0103f4a:	c1 e0 02             	shl    $0x2,%eax
c0103f4d:	89 c2                	mov    %eax,%edx
c0103f4f:	a1 84 89 11 c0       	mov    0xc0118984,%eax
c0103f54:	01 d0                	add    %edx,%eax
c0103f56:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f59:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f60:	77 23                	ja     c0103f85 <page_init+0x24d>
c0103f62:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f65:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f69:	c7 44 24 08 18 69 10 	movl   $0xc0106918,0x8(%esp)
c0103f70:	c0 
c0103f71:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f78:	00 
c0103f79:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0103f80:	e8 47 cd ff ff       	call   c0100ccc <__panic>
c0103f85:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f88:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f8d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103f90:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f97:	e9 74 01 00 00       	jmp    c0104110 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f9c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f9f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fa2:	89 d0                	mov    %edx,%eax
c0103fa4:	c1 e0 02             	shl    $0x2,%eax
c0103fa7:	01 d0                	add    %edx,%eax
c0103fa9:	c1 e0 02             	shl    $0x2,%eax
c0103fac:	01 c8                	add    %ecx,%eax
c0103fae:	8b 50 08             	mov    0x8(%eax),%edx
c0103fb1:	8b 40 04             	mov    0x4(%eax),%eax
c0103fb4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fb7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103fba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fbd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fc0:	89 d0                	mov    %edx,%eax
c0103fc2:	c1 e0 02             	shl    $0x2,%eax
c0103fc5:	01 d0                	add    %edx,%eax
c0103fc7:	c1 e0 02             	shl    $0x2,%eax
c0103fca:	01 c8                	add    %ecx,%eax
c0103fcc:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fcf:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fd5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fd8:	01 c8                	add    %ecx,%eax
c0103fda:	11 da                	adc    %ebx,%edx
c0103fdc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103fdf:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103fe2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fe5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fe8:	89 d0                	mov    %edx,%eax
c0103fea:	c1 e0 02             	shl    $0x2,%eax
c0103fed:	01 d0                	add    %edx,%eax
c0103fef:	c1 e0 02             	shl    $0x2,%eax
c0103ff2:	01 c8                	add    %ecx,%eax
c0103ff4:	83 c0 14             	add    $0x14,%eax
c0103ff7:	8b 00                	mov    (%eax),%eax
c0103ff9:	83 f8 01             	cmp    $0x1,%eax
c0103ffc:	0f 85 0a 01 00 00    	jne    c010410c <page_init+0x3d4>
            if (begin < freemem) {
c0104002:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104005:	ba 00 00 00 00       	mov    $0x0,%edx
c010400a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010400d:	72 17                	jb     c0104026 <page_init+0x2ee>
c010400f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104012:	77 05                	ja     c0104019 <page_init+0x2e1>
c0104014:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104017:	76 0d                	jbe    c0104026 <page_init+0x2ee>
                begin = freemem;
c0104019:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010401c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010401f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104026:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010402a:	72 1d                	jb     c0104049 <page_init+0x311>
c010402c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104030:	77 09                	ja     c010403b <page_init+0x303>
c0104032:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104039:	76 0e                	jbe    c0104049 <page_init+0x311>
                end = KMEMSIZE;
c010403b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104042:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104049:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010404c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010404f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104052:	0f 87 b4 00 00 00    	ja     c010410c <page_init+0x3d4>
c0104058:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010405b:	72 09                	jb     c0104066 <page_init+0x32e>
c010405d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104060:	0f 83 a6 00 00 00    	jae    c010410c <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104066:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010406d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104070:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104073:	01 d0                	add    %edx,%eax
c0104075:	83 e8 01             	sub    $0x1,%eax
c0104078:	89 45 98             	mov    %eax,-0x68(%ebp)
c010407b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010407e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104083:	f7 75 9c             	divl   -0x64(%ebp)
c0104086:	89 d0                	mov    %edx,%eax
c0104088:	8b 55 98             	mov    -0x68(%ebp),%edx
c010408b:	29 c2                	sub    %eax,%edx
c010408d:	89 d0                	mov    %edx,%eax
c010408f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104094:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104097:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010409a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010409d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040a0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040a3:	ba 00 00 00 00       	mov    $0x0,%edx
c01040a8:	89 c7                	mov    %eax,%edi
c01040aa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040b0:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040b3:	89 d0                	mov    %edx,%eax
c01040b5:	83 e0 00             	and    $0x0,%eax
c01040b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01040bb:	8b 45 80             	mov    -0x80(%ebp),%eax
c01040be:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01040c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d0:	77 3a                	ja     c010410c <page_init+0x3d4>
c01040d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d5:	72 05                	jb     c01040dc <page_init+0x3a4>
c01040d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040da:	73 30                	jae    c010410c <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01040dc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01040df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01040e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01040e8:	29 c8                	sub    %ecx,%eax
c01040ea:	19 da                	sbb    %ebx,%edx
c01040ec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01040f0:	c1 ea 0c             	shr    $0xc,%edx
c01040f3:	89 c3                	mov    %eax,%ebx
c01040f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040f8:	89 04 24             	mov    %eax,(%esp)
c01040fb:	e8 b2 f8 ff ff       	call   c01039b2 <pa2page>
c0104100:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104104:	89 04 24             	mov    %eax,(%esp)
c0104107:	e8 78 fb ff ff       	call   c0103c84 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010410c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104110:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104113:	8b 00                	mov    (%eax),%eax
c0104115:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104118:	0f 8f 7e fe ff ff    	jg     c0103f9c <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010411e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104124:	5b                   	pop    %ebx
c0104125:	5e                   	pop    %esi
c0104126:	5f                   	pop    %edi
c0104127:	5d                   	pop    %ebp
c0104128:	c3                   	ret    

c0104129 <enable_paging>:

static void
enable_paging(void) {
c0104129:	55                   	push   %ebp
c010412a:	89 e5                	mov    %esp,%ebp
c010412c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010412f:	a1 80 89 11 c0       	mov    0xc0118980,%eax
c0104134:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104137:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010413a:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010413d:	0f 20 c0             	mov    %cr0,%eax
c0104140:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104143:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104146:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104149:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104150:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104154:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010415a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010415d:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104160:	c9                   	leave  
c0104161:	c3                   	ret    

c0104162 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104162:	55                   	push   %ebp
c0104163:	89 e5                	mov    %esp,%ebp
c0104165:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104168:	8b 45 14             	mov    0x14(%ebp),%eax
c010416b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010416e:	31 d0                	xor    %edx,%eax
c0104170:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104175:	85 c0                	test   %eax,%eax
c0104177:	74 24                	je     c010419d <boot_map_segment+0x3b>
c0104179:	c7 44 24 0c 4a 69 10 	movl   $0xc010694a,0xc(%esp)
c0104180:	c0 
c0104181:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104188:	c0 
c0104189:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104190:	00 
c0104191:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104198:	e8 2f cb ff ff       	call   c0100ccc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010419d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041a7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041ac:	89 c2                	mov    %eax,%edx
c01041ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01041b1:	01 c2                	add    %eax,%edx
c01041b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041b6:	01 d0                	add    %edx,%eax
c01041b8:	83 e8 01             	sub    $0x1,%eax
c01041bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01041c6:	f7 75 f0             	divl   -0x10(%ebp)
c01041c9:	89 d0                	mov    %edx,%eax
c01041cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041ce:	29 c2                	sub    %eax,%edx
c01041d0:	89 d0                	mov    %edx,%eax
c01041d2:	c1 e8 0c             	shr    $0xc,%eax
c01041d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041db:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041e6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01041e9:	8b 45 14             	mov    0x14(%ebp),%eax
c01041ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01041f7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01041fa:	eb 6b                	jmp    c0104267 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01041fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104203:	00 
c0104204:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104207:	89 44 24 04          	mov    %eax,0x4(%esp)
c010420b:	8b 45 08             	mov    0x8(%ebp),%eax
c010420e:	89 04 24             	mov    %eax,(%esp)
c0104211:	e8 cc 01 00 00       	call   c01043e2 <get_pte>
c0104216:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104219:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010421d:	75 24                	jne    c0104243 <boot_map_segment+0xe1>
c010421f:	c7 44 24 0c 76 69 10 	movl   $0xc0106976,0xc(%esp)
c0104226:	c0 
c0104227:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c010422e:	c0 
c010422f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104236:	00 
c0104237:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010423e:	e8 89 ca ff ff       	call   c0100ccc <__panic>
        *ptep = pa | PTE_P | perm;
c0104243:	8b 45 18             	mov    0x18(%ebp),%eax
c0104246:	8b 55 14             	mov    0x14(%ebp),%edx
c0104249:	09 d0                	or     %edx,%eax
c010424b:	83 c8 01             	or     $0x1,%eax
c010424e:	89 c2                	mov    %eax,%edx
c0104250:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104253:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104255:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104259:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104260:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104267:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010426b:	75 8f                	jne    c01041fc <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010426d:	c9                   	leave  
c010426e:	c3                   	ret    

c010426f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010426f:	55                   	push   %ebp
c0104270:	89 e5                	mov    %esp,%ebp
c0104272:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010427c:	e8 22 fa ff ff       	call   c0103ca3 <alloc_pages>
c0104281:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104284:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104288:	75 1c                	jne    c01042a6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010428a:	c7 44 24 08 83 69 10 	movl   $0xc0106983,0x8(%esp)
c0104291:	c0 
c0104292:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104299:	00 
c010429a:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01042a1:	e8 26 ca ff ff       	call   c0100ccc <__panic>
    }
    return page2kva(p);
c01042a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042a9:	89 04 24             	mov    %eax,(%esp)
c01042ac:	e8 50 f7 ff ff       	call   c0103a01 <page2kva>
}
c01042b1:	c9                   	leave  
c01042b2:	c3                   	ret    

c01042b3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042b3:	55                   	push   %ebp
c01042b4:	89 e5                	mov    %esp,%ebp
c01042b6:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01042b9:	e8 93 f9 ff ff       	call   c0103c51 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01042be:	e8 75 fa ff ff       	call   c0103d38 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01042c3:	e8 d7 02 00 00       	call   c010459f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042c8:	e8 a2 ff ff ff       	call   c010426f <boot_alloc_page>
c01042cd:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
    memset(boot_pgdir, 0, PGSIZE);
c01042d2:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01042d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01042de:	00 
c01042df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01042e6:	00 
c01042e7:	89 04 24             	mov    %eax,(%esp)
c01042ea:	e8 14 19 00 00       	call   c0105c03 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01042ef:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01042f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01042f7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01042fe:	77 23                	ja     c0104323 <pmm_init+0x70>
c0104300:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104303:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104307:	c7 44 24 08 18 69 10 	movl   $0xc0106918,0x8(%esp)
c010430e:	c0 
c010430f:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104316:	00 
c0104317:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010431e:	e8 a9 c9 ff ff       	call   c0100ccc <__panic>
c0104323:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104326:	05 00 00 00 40       	add    $0x40000000,%eax
c010432b:	a3 80 89 11 c0       	mov    %eax,0xc0118980

    check_pgdir();
c0104330:	e8 88 02 00 00       	call   c01045bd <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104335:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010433a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104340:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104345:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104348:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010434f:	77 23                	ja     c0104374 <pmm_init+0xc1>
c0104351:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104354:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104358:	c7 44 24 08 18 69 10 	movl   $0xc0106918,0x8(%esp)
c010435f:	c0 
c0104360:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104367:	00 
c0104368:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010436f:	e8 58 c9 ff ff       	call   c0100ccc <__panic>
c0104374:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104377:	05 00 00 00 40       	add    $0x40000000,%eax
c010437c:	83 c8 03             	or     $0x3,%eax
c010437f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104381:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104386:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010438d:	00 
c010438e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104395:	00 
c0104396:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010439d:	38 
c010439e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043a5:	c0 
c01043a6:	89 04 24             	mov    %eax,(%esp)
c01043a9:	e8 b4 fd ff ff       	call   c0104162 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043ae:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01043b3:	8b 15 e4 88 11 c0    	mov    0xc01188e4,%edx
c01043b9:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01043bf:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01043c1:	e8 63 fd ff ff       	call   c0104129 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043c6:	e8 97 f7 ff ff       	call   c0103b62 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043cb:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01043d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043d6:	e8 7d 08 00 00       	call   c0104c58 <check_boot_pgdir>

    print_pgdir();
c01043db:	e8 05 0d 00 00       	call   c01050e5 <print_pgdir>

}
c01043e0:	c9                   	leave  
c01043e1:	c3                   	ret    

c01043e2 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043e2:	55                   	push   %ebp
c01043e3:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01043e5:	5d                   	pop    %ebp
c01043e6:	c3                   	ret    

c01043e7 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01043e7:	55                   	push   %ebp
c01043e8:	89 e5                	mov    %esp,%ebp
c01043ea:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01043ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01043f4:	00 
c01043f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ff:	89 04 24             	mov    %eax,(%esp)
c0104402:	e8 db ff ff ff       	call   c01043e2 <get_pte>
c0104407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010440a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010440e:	74 08                	je     c0104418 <get_page+0x31>
        *ptep_store = ptep;
c0104410:	8b 45 10             	mov    0x10(%ebp),%eax
c0104413:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104416:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010441c:	74 1b                	je     c0104439 <get_page+0x52>
c010441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104421:	8b 00                	mov    (%eax),%eax
c0104423:	83 e0 01             	and    $0x1,%eax
c0104426:	85 c0                	test   %eax,%eax
c0104428:	74 0f                	je     c0104439 <get_page+0x52>
        return pte2page(*ptep);
c010442a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442d:	8b 00                	mov    (%eax),%eax
c010442f:	89 04 24             	mov    %eax,(%esp)
c0104432:	e8 1e f6 ff ff       	call   c0103a55 <pte2page>
c0104437:	eb 05                	jmp    c010443e <get_page+0x57>
    }
    return NULL;
c0104439:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010443e:	c9                   	leave  
c010443f:	c3                   	ret    

c0104440 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104440:	55                   	push   %ebp
c0104441:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104443:	5d                   	pop    %ebp
c0104444:	c3                   	ret    

c0104445 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104445:	55                   	push   %ebp
c0104446:	89 e5                	mov    %esp,%ebp
c0104448:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010444b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104452:	00 
c0104453:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104456:	89 44 24 04          	mov    %eax,0x4(%esp)
c010445a:	8b 45 08             	mov    0x8(%ebp),%eax
c010445d:	89 04 24             	mov    %eax,(%esp)
c0104460:	e8 7d ff ff ff       	call   c01043e2 <get_pte>
c0104465:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104468:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010446c:	74 19                	je     c0104487 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010446e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104471:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104475:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104478:	89 44 24 04          	mov    %eax,0x4(%esp)
c010447c:	8b 45 08             	mov    0x8(%ebp),%eax
c010447f:	89 04 24             	mov    %eax,(%esp)
c0104482:	e8 b9 ff ff ff       	call   c0104440 <page_remove_pte>
    }
}
c0104487:	c9                   	leave  
c0104488:	c3                   	ret    

c0104489 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104489:	55                   	push   %ebp
c010448a:	89 e5                	mov    %esp,%ebp
c010448c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010448f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104496:	00 
c0104497:	8b 45 10             	mov    0x10(%ebp),%eax
c010449a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010449e:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a1:	89 04 24             	mov    %eax,(%esp)
c01044a4:	e8 39 ff ff ff       	call   c01043e2 <get_pte>
c01044a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01044ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044b0:	75 0a                	jne    c01044bc <page_insert+0x33>
        return -E_NO_MEM;
c01044b2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01044b7:	e9 84 00 00 00       	jmp    c0104540 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01044bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044bf:	89 04 24             	mov    %eax,(%esp)
c01044c2:	e8 ee f5 ff ff       	call   c0103ab5 <page_ref_inc>
    if (*ptep & PTE_P) {
c01044c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ca:	8b 00                	mov    (%eax),%eax
c01044cc:	83 e0 01             	and    $0x1,%eax
c01044cf:	85 c0                	test   %eax,%eax
c01044d1:	74 3e                	je     c0104511 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d6:	8b 00                	mov    (%eax),%eax
c01044d8:	89 04 24             	mov    %eax,(%esp)
c01044db:	e8 75 f5 ff ff       	call   c0103a55 <pte2page>
c01044e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01044e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01044e9:	75 0d                	jne    c01044f8 <page_insert+0x6f>
            page_ref_dec(page);
c01044eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044ee:	89 04 24             	mov    %eax,(%esp)
c01044f1:	e8 d6 f5 ff ff       	call   c0103acc <page_ref_dec>
c01044f6:	eb 19                	jmp    c0104511 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01044f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044fb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0104502:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104506:	8b 45 08             	mov    0x8(%ebp),%eax
c0104509:	89 04 24             	mov    %eax,(%esp)
c010450c:	e8 2f ff ff ff       	call   c0104440 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104511:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104514:	89 04 24             	mov    %eax,(%esp)
c0104517:	e8 80 f4 ff ff       	call   c010399c <page2pa>
c010451c:	0b 45 14             	or     0x14(%ebp),%eax
c010451f:	83 c8 01             	or     $0x1,%eax
c0104522:	89 c2                	mov    %eax,%edx
c0104524:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104527:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104529:	8b 45 10             	mov    0x10(%ebp),%eax
c010452c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104530:	8b 45 08             	mov    0x8(%ebp),%eax
c0104533:	89 04 24             	mov    %eax,(%esp)
c0104536:	e8 07 00 00 00       	call   c0104542 <tlb_invalidate>
    return 0;
c010453b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104540:	c9                   	leave  
c0104541:	c3                   	ret    

c0104542 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104542:	55                   	push   %ebp
c0104543:	89 e5                	mov    %esp,%ebp
c0104545:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104548:	0f 20 d8             	mov    %cr3,%eax
c010454b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010454e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104551:	89 c2                	mov    %eax,%edx
c0104553:	8b 45 08             	mov    0x8(%ebp),%eax
c0104556:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104559:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104560:	77 23                	ja     c0104585 <tlb_invalidate+0x43>
c0104562:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104565:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104569:	c7 44 24 08 18 69 10 	movl   $0xc0106918,0x8(%esp)
c0104570:	c0 
c0104571:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0104578:	00 
c0104579:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104580:	e8 47 c7 ff ff       	call   c0100ccc <__panic>
c0104585:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104588:	05 00 00 00 40       	add    $0x40000000,%eax
c010458d:	39 c2                	cmp    %eax,%edx
c010458f:	75 0c                	jne    c010459d <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104591:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104594:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104597:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010459a:	0f 01 38             	invlpg (%eax)
    }
}
c010459d:	c9                   	leave  
c010459e:	c3                   	ret    

c010459f <check_alloc_page>:

static void
check_alloc_page(void) {
c010459f:	55                   	push   %ebp
c01045a0:	89 e5                	mov    %esp,%ebp
c01045a2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01045a5:	a1 7c 89 11 c0       	mov    0xc011897c,%eax
c01045aa:	8b 40 18             	mov    0x18(%eax),%eax
c01045ad:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01045af:	c7 04 24 9c 69 10 c0 	movl   $0xc010699c,(%esp)
c01045b6:	e8 81 bd ff ff       	call   c010033c <cprintf>
}
c01045bb:	c9                   	leave  
c01045bc:	c3                   	ret    

c01045bd <check_pgdir>:

static void
check_pgdir(void) {
c01045bd:	55                   	push   %ebp
c01045be:	89 e5                	mov    %esp,%ebp
c01045c0:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01045c3:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c01045c8:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01045cd:	76 24                	jbe    c01045f3 <check_pgdir+0x36>
c01045cf:	c7 44 24 0c bb 69 10 	movl   $0xc01069bb,0xc(%esp)
c01045d6:	c0 
c01045d7:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c01045de:	c0 
c01045df:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01045e6:	00 
c01045e7:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01045ee:	e8 d9 c6 ff ff       	call   c0100ccc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01045f3:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01045f8:	85 c0                	test   %eax,%eax
c01045fa:	74 0e                	je     c010460a <check_pgdir+0x4d>
c01045fc:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104601:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104606:	85 c0                	test   %eax,%eax
c0104608:	74 24                	je     c010462e <check_pgdir+0x71>
c010460a:	c7 44 24 0c d8 69 10 	movl   $0xc01069d8,0xc(%esp)
c0104611:	c0 
c0104612:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104619:	c0 
c010461a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104621:	00 
c0104622:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104629:	e8 9e c6 ff ff       	call   c0100ccc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010462e:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104633:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010463a:	00 
c010463b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104642:	00 
c0104643:	89 04 24             	mov    %eax,(%esp)
c0104646:	e8 9c fd ff ff       	call   c01043e7 <get_page>
c010464b:	85 c0                	test   %eax,%eax
c010464d:	74 24                	je     c0104673 <check_pgdir+0xb6>
c010464f:	c7 44 24 0c 10 6a 10 	movl   $0xc0106a10,0xc(%esp)
c0104656:	c0 
c0104657:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c010465e:	c0 
c010465f:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0104666:	00 
c0104667:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010466e:	e8 59 c6 ff ff       	call   c0100ccc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010467a:	e8 24 f6 ff ff       	call   c0103ca3 <alloc_pages>
c010467f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104682:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104687:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010468e:	00 
c010468f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104696:	00 
c0104697:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010469a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010469e:	89 04 24             	mov    %eax,(%esp)
c01046a1:	e8 e3 fd ff ff       	call   c0104489 <page_insert>
c01046a6:	85 c0                	test   %eax,%eax
c01046a8:	74 24                	je     c01046ce <check_pgdir+0x111>
c01046aa:	c7 44 24 0c 38 6a 10 	movl   $0xc0106a38,0xc(%esp)
c01046b1:	c0 
c01046b2:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c01046b9:	c0 
c01046ba:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c01046c1:	00 
c01046c2:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01046c9:	e8 fe c5 ff ff       	call   c0100ccc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01046ce:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01046d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046da:	00 
c01046db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046e2:	00 
c01046e3:	89 04 24             	mov    %eax,(%esp)
c01046e6:	e8 f7 fc ff ff       	call   c01043e2 <get_pte>
c01046eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046f2:	75 24                	jne    c0104718 <check_pgdir+0x15b>
c01046f4:	c7 44 24 0c 64 6a 10 	movl   $0xc0106a64,0xc(%esp)
c01046fb:	c0 
c01046fc:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104703:	c0 
c0104704:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c010470b:	00 
c010470c:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104713:	e8 b4 c5 ff ff       	call   c0100ccc <__panic>
    assert(pte2page(*ptep) == p1);
c0104718:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471b:	8b 00                	mov    (%eax),%eax
c010471d:	89 04 24             	mov    %eax,(%esp)
c0104720:	e8 30 f3 ff ff       	call   c0103a55 <pte2page>
c0104725:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104728:	74 24                	je     c010474e <check_pgdir+0x191>
c010472a:	c7 44 24 0c 91 6a 10 	movl   $0xc0106a91,0xc(%esp)
c0104731:	c0 
c0104732:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104739:	c0 
c010473a:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c0104741:	00 
c0104742:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104749:	e8 7e c5 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p1) == 1);
c010474e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104751:	89 04 24             	mov    %eax,(%esp)
c0104754:	e8 52 f3 ff ff       	call   c0103aab <page_ref>
c0104759:	83 f8 01             	cmp    $0x1,%eax
c010475c:	74 24                	je     c0104782 <check_pgdir+0x1c5>
c010475e:	c7 44 24 0c a7 6a 10 	movl   $0xc0106aa7,0xc(%esp)
c0104765:	c0 
c0104766:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c010476d:	c0 
c010476e:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104775:	00 
c0104776:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010477d:	e8 4a c5 ff ff       	call   c0100ccc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104782:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104787:	8b 00                	mov    (%eax),%eax
c0104789:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010478e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104791:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104794:	c1 e8 0c             	shr    $0xc,%eax
c0104797:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010479a:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c010479f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01047a2:	72 23                	jb     c01047c7 <check_pgdir+0x20a>
c01047a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047ab:	c7 44 24 08 74 68 10 	movl   $0xc0106874,0x8(%esp)
c01047b2:	c0 
c01047b3:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c01047ba:	00 
c01047bb:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01047c2:	e8 05 c5 ff ff       	call   c0100ccc <__panic>
c01047c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ca:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01047cf:	83 c0 04             	add    $0x4,%eax
c01047d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01047d5:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c01047da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047e1:	00 
c01047e2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01047e9:	00 
c01047ea:	89 04 24             	mov    %eax,(%esp)
c01047ed:	e8 f0 fb ff ff       	call   c01043e2 <get_pte>
c01047f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047f5:	74 24                	je     c010481b <check_pgdir+0x25e>
c01047f7:	c7 44 24 0c bc 6a 10 	movl   $0xc0106abc,0xc(%esp)
c01047fe:	c0 
c01047ff:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104806:	c0 
c0104807:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c010480e:	00 
c010480f:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104816:	e8 b1 c4 ff ff       	call   c0100ccc <__panic>

    p2 = alloc_page();
c010481b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104822:	e8 7c f4 ff ff       	call   c0103ca3 <alloc_pages>
c0104827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010482a:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010482f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104836:	00 
c0104837:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010483e:	00 
c010483f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104842:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104846:	89 04 24             	mov    %eax,(%esp)
c0104849:	e8 3b fc ff ff       	call   c0104489 <page_insert>
c010484e:	85 c0                	test   %eax,%eax
c0104850:	74 24                	je     c0104876 <check_pgdir+0x2b9>
c0104852:	c7 44 24 0c e4 6a 10 	movl   $0xc0106ae4,0xc(%esp)
c0104859:	c0 
c010485a:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104861:	c0 
c0104862:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104869:	00 
c010486a:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104871:	e8 56 c4 ff ff       	call   c0100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104876:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010487b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104882:	00 
c0104883:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010488a:	00 
c010488b:	89 04 24             	mov    %eax,(%esp)
c010488e:	e8 4f fb ff ff       	call   c01043e2 <get_pte>
c0104893:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104896:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010489a:	75 24                	jne    c01048c0 <check_pgdir+0x303>
c010489c:	c7 44 24 0c 1c 6b 10 	movl   $0xc0106b1c,0xc(%esp)
c01048a3:	c0 
c01048a4:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c01048ab:	c0 
c01048ac:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01048b3:	00 
c01048b4:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01048bb:	e8 0c c4 ff ff       	call   c0100ccc <__panic>
    assert(*ptep & PTE_U);
c01048c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c3:	8b 00                	mov    (%eax),%eax
c01048c5:	83 e0 04             	and    $0x4,%eax
c01048c8:	85 c0                	test   %eax,%eax
c01048ca:	75 24                	jne    c01048f0 <check_pgdir+0x333>
c01048cc:	c7 44 24 0c 4c 6b 10 	movl   $0xc0106b4c,0xc(%esp)
c01048d3:	c0 
c01048d4:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c01048db:	c0 
c01048dc:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01048e3:	00 
c01048e4:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01048eb:	e8 dc c3 ff ff       	call   c0100ccc <__panic>
    assert(*ptep & PTE_W);
c01048f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f3:	8b 00                	mov    (%eax),%eax
c01048f5:	83 e0 02             	and    $0x2,%eax
c01048f8:	85 c0                	test   %eax,%eax
c01048fa:	75 24                	jne    c0104920 <check_pgdir+0x363>
c01048fc:	c7 44 24 0c 5a 6b 10 	movl   $0xc0106b5a,0xc(%esp)
c0104903:	c0 
c0104904:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c010490b:	c0 
c010490c:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104913:	00 
c0104914:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010491b:	e8 ac c3 ff ff       	call   c0100ccc <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104920:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104925:	8b 00                	mov    (%eax),%eax
c0104927:	83 e0 04             	and    $0x4,%eax
c010492a:	85 c0                	test   %eax,%eax
c010492c:	75 24                	jne    c0104952 <check_pgdir+0x395>
c010492e:	c7 44 24 0c 68 6b 10 	movl   $0xc0106b68,0xc(%esp)
c0104935:	c0 
c0104936:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c010493d:	c0 
c010493e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104945:	00 
c0104946:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c010494d:	e8 7a c3 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 1);
c0104952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104955:	89 04 24             	mov    %eax,(%esp)
c0104958:	e8 4e f1 ff ff       	call   c0103aab <page_ref>
c010495d:	83 f8 01             	cmp    $0x1,%eax
c0104960:	74 24                	je     c0104986 <check_pgdir+0x3c9>
c0104962:	c7 44 24 0c 7e 6b 10 	movl   $0xc0106b7e,0xc(%esp)
c0104969:	c0 
c010496a:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104971:	c0 
c0104972:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104979:	00 
c010497a:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104981:	e8 46 c3 ff ff       	call   c0100ccc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104986:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c010498b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104992:	00 
c0104993:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010499a:	00 
c010499b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010499e:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049a2:	89 04 24             	mov    %eax,(%esp)
c01049a5:	e8 df fa ff ff       	call   c0104489 <page_insert>
c01049aa:	85 c0                	test   %eax,%eax
c01049ac:	74 24                	je     c01049d2 <check_pgdir+0x415>
c01049ae:	c7 44 24 0c 90 6b 10 	movl   $0xc0106b90,0xc(%esp)
c01049b5:	c0 
c01049b6:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c01049bd:	c0 
c01049be:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01049c5:	00 
c01049c6:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c01049cd:	e8 fa c2 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p1) == 2);
c01049d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d5:	89 04 24             	mov    %eax,(%esp)
c01049d8:	e8 ce f0 ff ff       	call   c0103aab <page_ref>
c01049dd:	83 f8 02             	cmp    $0x2,%eax
c01049e0:	74 24                	je     c0104a06 <check_pgdir+0x449>
c01049e2:	c7 44 24 0c bc 6b 10 	movl   $0xc0106bbc,0xc(%esp)
c01049e9:	c0 
c01049ea:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c01049f1:	c0 
c01049f2:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01049f9:	00 
c01049fa:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104a01:	e8 c6 c2 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104a06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a09:	89 04 24             	mov    %eax,(%esp)
c0104a0c:	e8 9a f0 ff ff       	call   c0103aab <page_ref>
c0104a11:	85 c0                	test   %eax,%eax
c0104a13:	74 24                	je     c0104a39 <check_pgdir+0x47c>
c0104a15:	c7 44 24 0c ce 6b 10 	movl   $0xc0106bce,0xc(%esp)
c0104a1c:	c0 
c0104a1d:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104a24:	c0 
c0104a25:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104a2c:	00 
c0104a2d:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104a34:	e8 93 c2 ff ff       	call   c0100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a39:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104a3e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a45:	00 
c0104a46:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a4d:	00 
c0104a4e:	89 04 24             	mov    %eax,(%esp)
c0104a51:	e8 8c f9 ff ff       	call   c01043e2 <get_pte>
c0104a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a5d:	75 24                	jne    c0104a83 <check_pgdir+0x4c6>
c0104a5f:	c7 44 24 0c 1c 6b 10 	movl   $0xc0106b1c,0xc(%esp)
c0104a66:	c0 
c0104a67:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104a6e:	c0 
c0104a6f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104a76:	00 
c0104a77:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104a7e:	e8 49 c2 ff ff       	call   c0100ccc <__panic>
    assert(pte2page(*ptep) == p1);
c0104a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a86:	8b 00                	mov    (%eax),%eax
c0104a88:	89 04 24             	mov    %eax,(%esp)
c0104a8b:	e8 c5 ef ff ff       	call   c0103a55 <pte2page>
c0104a90:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a93:	74 24                	je     c0104ab9 <check_pgdir+0x4fc>
c0104a95:	c7 44 24 0c 91 6a 10 	movl   $0xc0106a91,0xc(%esp)
c0104a9c:	c0 
c0104a9d:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104aa4:	c0 
c0104aa5:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0104aac:	00 
c0104aad:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104ab4:	e8 13 c2 ff ff       	call   c0100ccc <__panic>
    assert((*ptep & PTE_U) == 0);
c0104ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104abc:	8b 00                	mov    (%eax),%eax
c0104abe:	83 e0 04             	and    $0x4,%eax
c0104ac1:	85 c0                	test   %eax,%eax
c0104ac3:	74 24                	je     c0104ae9 <check_pgdir+0x52c>
c0104ac5:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c0104acc:	c0 
c0104acd:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104ad4:	c0 
c0104ad5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104adc:	00 
c0104add:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104ae4:	e8 e3 c1 ff ff       	call   c0100ccc <__panic>

    page_remove(boot_pgdir, 0x0);
c0104ae9:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104aee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104af5:	00 
c0104af6:	89 04 24             	mov    %eax,(%esp)
c0104af9:	e8 47 f9 ff ff       	call   c0104445 <page_remove>
    assert(page_ref(p1) == 1);
c0104afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b01:	89 04 24             	mov    %eax,(%esp)
c0104b04:	e8 a2 ef ff ff       	call   c0103aab <page_ref>
c0104b09:	83 f8 01             	cmp    $0x1,%eax
c0104b0c:	74 24                	je     c0104b32 <check_pgdir+0x575>
c0104b0e:	c7 44 24 0c a7 6a 10 	movl   $0xc0106aa7,0xc(%esp)
c0104b15:	c0 
c0104b16:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104b1d:	c0 
c0104b1e:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104b25:	00 
c0104b26:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104b2d:	e8 9a c1 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b35:	89 04 24             	mov    %eax,(%esp)
c0104b38:	e8 6e ef ff ff       	call   c0103aab <page_ref>
c0104b3d:	85 c0                	test   %eax,%eax
c0104b3f:	74 24                	je     c0104b65 <check_pgdir+0x5a8>
c0104b41:	c7 44 24 0c ce 6b 10 	movl   $0xc0106bce,0xc(%esp)
c0104b48:	c0 
c0104b49:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104b50:	c0 
c0104b51:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104b58:	00 
c0104b59:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104b60:	e8 67 c1 ff ff       	call   c0100ccc <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104b65:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104b6a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b71:	00 
c0104b72:	89 04 24             	mov    %eax,(%esp)
c0104b75:	e8 cb f8 ff ff       	call   c0104445 <page_remove>
    assert(page_ref(p1) == 0);
c0104b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7d:	89 04 24             	mov    %eax,(%esp)
c0104b80:	e8 26 ef ff ff       	call   c0103aab <page_ref>
c0104b85:	85 c0                	test   %eax,%eax
c0104b87:	74 24                	je     c0104bad <check_pgdir+0x5f0>
c0104b89:	c7 44 24 0c f5 6b 10 	movl   $0xc0106bf5,0xc(%esp)
c0104b90:	c0 
c0104b91:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104b98:	c0 
c0104b99:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104ba0:	00 
c0104ba1:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104ba8:	e8 1f c1 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104bad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bb0:	89 04 24             	mov    %eax,(%esp)
c0104bb3:	e8 f3 ee ff ff       	call   c0103aab <page_ref>
c0104bb8:	85 c0                	test   %eax,%eax
c0104bba:	74 24                	je     c0104be0 <check_pgdir+0x623>
c0104bbc:	c7 44 24 0c ce 6b 10 	movl   $0xc0106bce,0xc(%esp)
c0104bc3:	c0 
c0104bc4:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104bcb:	c0 
c0104bcc:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104bd3:	00 
c0104bd4:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104bdb:	e8 ec c0 ff ff       	call   c0100ccc <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104be0:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104be5:	8b 00                	mov    (%eax),%eax
c0104be7:	89 04 24             	mov    %eax,(%esp)
c0104bea:	e8 a4 ee ff ff       	call   c0103a93 <pde2page>
c0104bef:	89 04 24             	mov    %eax,(%esp)
c0104bf2:	e8 b4 ee ff ff       	call   c0103aab <page_ref>
c0104bf7:	83 f8 01             	cmp    $0x1,%eax
c0104bfa:	74 24                	je     c0104c20 <check_pgdir+0x663>
c0104bfc:	c7 44 24 0c 08 6c 10 	movl   $0xc0106c08,0xc(%esp)
c0104c03:	c0 
c0104c04:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104c0b:	c0 
c0104c0c:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c13:	00 
c0104c14:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104c1b:	e8 ac c0 ff ff       	call   c0100ccc <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104c20:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c25:	8b 00                	mov    (%eax),%eax
c0104c27:	89 04 24             	mov    %eax,(%esp)
c0104c2a:	e8 64 ee ff ff       	call   c0103a93 <pde2page>
c0104c2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c36:	00 
c0104c37:	89 04 24             	mov    %eax,(%esp)
c0104c3a:	e8 9c f0 ff ff       	call   c0103cdb <free_pages>
    boot_pgdir[0] = 0;
c0104c3f:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104c44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104c4a:	c7 04 24 2f 6c 10 c0 	movl   $0xc0106c2f,(%esp)
c0104c51:	e8 e6 b6 ff ff       	call   c010033c <cprintf>
}
c0104c56:	c9                   	leave  
c0104c57:	c3                   	ret    

c0104c58 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104c58:	55                   	push   %ebp
c0104c59:	89 e5                	mov    %esp,%ebp
c0104c5b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c65:	e9 ca 00 00 00       	jmp    c0104d34 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c73:	c1 e8 0c             	shr    $0xc,%eax
c0104c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c79:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104c7e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104c81:	72 23                	jb     c0104ca6 <check_boot_pgdir+0x4e>
c0104c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c86:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c8a:	c7 44 24 08 74 68 10 	movl   $0xc0106874,0x8(%esp)
c0104c91:	c0 
c0104c92:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104c99:	00 
c0104c9a:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104ca1:	e8 26 c0 ff ff       	call   c0100ccc <__panic>
c0104ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ca9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104cae:	89 c2                	mov    %eax,%edx
c0104cb0:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104cb5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cbc:	00 
c0104cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cc1:	89 04 24             	mov    %eax,(%esp)
c0104cc4:	e8 19 f7 ff ff       	call   c01043e2 <get_pte>
c0104cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ccc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104cd0:	75 24                	jne    c0104cf6 <check_boot_pgdir+0x9e>
c0104cd2:	c7 44 24 0c 4c 6c 10 	movl   $0xc0106c4c,0xc(%esp)
c0104cd9:	c0 
c0104cda:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104ce1:	c0 
c0104ce2:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104ce9:	00 
c0104cea:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104cf1:	e8 d6 bf ff ff       	call   c0100ccc <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cf9:	8b 00                	mov    (%eax),%eax
c0104cfb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d00:	89 c2                	mov    %eax,%edx
c0104d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d05:	39 c2                	cmp    %eax,%edx
c0104d07:	74 24                	je     c0104d2d <check_boot_pgdir+0xd5>
c0104d09:	c7 44 24 0c 89 6c 10 	movl   $0xc0106c89,0xc(%esp)
c0104d10:	c0 
c0104d11:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104d18:	c0 
c0104d19:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104d20:	00 
c0104d21:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104d28:	e8 9f bf ff ff       	call   c0100ccc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d2d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104d34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d37:	a1 e0 88 11 c0       	mov    0xc01188e0,%eax
c0104d3c:	39 c2                	cmp    %eax,%edx
c0104d3e:	0f 82 26 ff ff ff    	jb     c0104c6a <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104d44:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104d49:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104d4e:	8b 00                	mov    (%eax),%eax
c0104d50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d55:	89 c2                	mov    %eax,%edx
c0104d57:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104d5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d5f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104d66:	77 23                	ja     c0104d8b <check_boot_pgdir+0x133>
c0104d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d6f:	c7 44 24 08 18 69 10 	movl   $0xc0106918,0x8(%esp)
c0104d76:	c0 
c0104d77:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104d7e:	00 
c0104d7f:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104d86:	e8 41 bf ff ff       	call   c0100ccc <__panic>
c0104d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d8e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d93:	39 c2                	cmp    %eax,%edx
c0104d95:	74 24                	je     c0104dbb <check_boot_pgdir+0x163>
c0104d97:	c7 44 24 0c a0 6c 10 	movl   $0xc0106ca0,0xc(%esp)
c0104d9e:	c0 
c0104d9f:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104da6:	c0 
c0104da7:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104dae:	00 
c0104daf:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104db6:	e8 11 bf ff ff       	call   c0100ccc <__panic>

    assert(boot_pgdir[0] == 0);
c0104dbb:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104dc0:	8b 00                	mov    (%eax),%eax
c0104dc2:	85 c0                	test   %eax,%eax
c0104dc4:	74 24                	je     c0104dea <check_boot_pgdir+0x192>
c0104dc6:	c7 44 24 0c d4 6c 10 	movl   $0xc0106cd4,0xc(%esp)
c0104dcd:	c0 
c0104dce:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104dd5:	c0 
c0104dd6:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104ddd:	00 
c0104dde:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104de5:	e8 e2 be ff ff       	call   c0100ccc <__panic>

    struct Page *p;
    p = alloc_page();
c0104dea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104df1:	e8 ad ee ff ff       	call   c0103ca3 <alloc_pages>
c0104df6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104df9:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104dfe:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e05:	00 
c0104e06:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e0d:	00 
c0104e0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e11:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e15:	89 04 24             	mov    %eax,(%esp)
c0104e18:	e8 6c f6 ff ff       	call   c0104489 <page_insert>
c0104e1d:	85 c0                	test   %eax,%eax
c0104e1f:	74 24                	je     c0104e45 <check_boot_pgdir+0x1ed>
c0104e21:	c7 44 24 0c e8 6c 10 	movl   $0xc0106ce8,0xc(%esp)
c0104e28:	c0 
c0104e29:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104e30:	c0 
c0104e31:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104e38:	00 
c0104e39:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104e40:	e8 87 be ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p) == 1);
c0104e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e48:	89 04 24             	mov    %eax,(%esp)
c0104e4b:	e8 5b ec ff ff       	call   c0103aab <page_ref>
c0104e50:	83 f8 01             	cmp    $0x1,%eax
c0104e53:	74 24                	je     c0104e79 <check_boot_pgdir+0x221>
c0104e55:	c7 44 24 0c 16 6d 10 	movl   $0xc0106d16,0xc(%esp)
c0104e5c:	c0 
c0104e5d:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104e64:	c0 
c0104e65:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104e6c:	00 
c0104e6d:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104e74:	e8 53 be ff ff       	call   c0100ccc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104e79:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104e7e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e85:	00 
c0104e86:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104e8d:	00 
c0104e8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e91:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e95:	89 04 24             	mov    %eax,(%esp)
c0104e98:	e8 ec f5 ff ff       	call   c0104489 <page_insert>
c0104e9d:	85 c0                	test   %eax,%eax
c0104e9f:	74 24                	je     c0104ec5 <check_boot_pgdir+0x26d>
c0104ea1:	c7 44 24 0c 28 6d 10 	movl   $0xc0106d28,0xc(%esp)
c0104ea8:	c0 
c0104ea9:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104eb0:	c0 
c0104eb1:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104eb8:	00 
c0104eb9:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104ec0:	e8 07 be ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p) == 2);
c0104ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ec8:	89 04 24             	mov    %eax,(%esp)
c0104ecb:	e8 db eb ff ff       	call   c0103aab <page_ref>
c0104ed0:	83 f8 02             	cmp    $0x2,%eax
c0104ed3:	74 24                	je     c0104ef9 <check_boot_pgdir+0x2a1>
c0104ed5:	c7 44 24 0c 5f 6d 10 	movl   $0xc0106d5f,0xc(%esp)
c0104edc:	c0 
c0104edd:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104ee4:	c0 
c0104ee5:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104eec:	00 
c0104eed:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104ef4:	e8 d3 bd ff ff       	call   c0100ccc <__panic>

    const char *str = "ucore: Hello world!!";
c0104ef9:	c7 45 dc 70 6d 10 c0 	movl   $0xc0106d70,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f07:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f0e:	e8 19 0a 00 00       	call   c010592c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f13:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f1a:	00 
c0104f1b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f22:	e8 7e 0a 00 00       	call   c01059a5 <strcmp>
c0104f27:	85 c0                	test   %eax,%eax
c0104f29:	74 24                	je     c0104f4f <check_boot_pgdir+0x2f7>
c0104f2b:	c7 44 24 0c 88 6d 10 	movl   $0xc0106d88,0xc(%esp)
c0104f32:	c0 
c0104f33:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104f3a:	c0 
c0104f3b:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104f42:	00 
c0104f43:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104f4a:	e8 7d bd ff ff       	call   c0100ccc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104f4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f52:	89 04 24             	mov    %eax,(%esp)
c0104f55:	e8 a7 ea ff ff       	call   c0103a01 <page2kva>
c0104f5a:	05 00 01 00 00       	add    $0x100,%eax
c0104f5f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104f62:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f69:	e8 66 09 00 00       	call   c01058d4 <strlen>
c0104f6e:	85 c0                	test   %eax,%eax
c0104f70:	74 24                	je     c0104f96 <check_boot_pgdir+0x33e>
c0104f72:	c7 44 24 0c c0 6d 10 	movl   $0xc0106dc0,0xc(%esp)
c0104f79:	c0 
c0104f7a:	c7 44 24 08 61 69 10 	movl   $0xc0106961,0x8(%esp)
c0104f81:	c0 
c0104f82:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104f89:	00 
c0104f8a:	c7 04 24 3c 69 10 c0 	movl   $0xc010693c,(%esp)
c0104f91:	e8 36 bd ff ff       	call   c0100ccc <__panic>

    free_page(p);
c0104f96:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f9d:	00 
c0104f9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa1:	89 04 24             	mov    %eax,(%esp)
c0104fa4:	e8 32 ed ff ff       	call   c0103cdb <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104fa9:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104fae:	8b 00                	mov    (%eax),%eax
c0104fb0:	89 04 24             	mov    %eax,(%esp)
c0104fb3:	e8 db ea ff ff       	call   c0103a93 <pde2page>
c0104fb8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fbf:	00 
c0104fc0:	89 04 24             	mov    %eax,(%esp)
c0104fc3:	e8 13 ed ff ff       	call   c0103cdb <free_pages>
    boot_pgdir[0] = 0;
c0104fc8:	a1 e4 88 11 c0       	mov    0xc01188e4,%eax
c0104fcd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104fd3:	c7 04 24 e4 6d 10 c0 	movl   $0xc0106de4,(%esp)
c0104fda:	e8 5d b3 ff ff       	call   c010033c <cprintf>
}
c0104fdf:	c9                   	leave  
c0104fe0:	c3                   	ret    

c0104fe1 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104fe1:	55                   	push   %ebp
c0104fe2:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104fe4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fe7:	83 e0 04             	and    $0x4,%eax
c0104fea:	85 c0                	test   %eax,%eax
c0104fec:	74 07                	je     c0104ff5 <perm2str+0x14>
c0104fee:	b8 75 00 00 00       	mov    $0x75,%eax
c0104ff3:	eb 05                	jmp    c0104ffa <perm2str+0x19>
c0104ff5:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104ffa:	a2 68 89 11 c0       	mov    %al,0xc0118968
    str[1] = 'r';
c0104fff:	c6 05 69 89 11 c0 72 	movb   $0x72,0xc0118969
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105006:	8b 45 08             	mov    0x8(%ebp),%eax
c0105009:	83 e0 02             	and    $0x2,%eax
c010500c:	85 c0                	test   %eax,%eax
c010500e:	74 07                	je     c0105017 <perm2str+0x36>
c0105010:	b8 77 00 00 00       	mov    $0x77,%eax
c0105015:	eb 05                	jmp    c010501c <perm2str+0x3b>
c0105017:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010501c:	a2 6a 89 11 c0       	mov    %al,0xc011896a
    str[3] = '\0';
c0105021:	c6 05 6b 89 11 c0 00 	movb   $0x0,0xc011896b
    return str;
c0105028:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
}
c010502d:	5d                   	pop    %ebp
c010502e:	c3                   	ret    

c010502f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010502f:	55                   	push   %ebp
c0105030:	89 e5                	mov    %esp,%ebp
c0105032:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105035:	8b 45 10             	mov    0x10(%ebp),%eax
c0105038:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010503b:	72 0a                	jb     c0105047 <get_pgtable_items+0x18>
        return 0;
c010503d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105042:	e9 9c 00 00 00       	jmp    c01050e3 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105047:	eb 04                	jmp    c010504d <get_pgtable_items+0x1e>
        start ++;
c0105049:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010504d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105050:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105053:	73 18                	jae    c010506d <get_pgtable_items+0x3e>
c0105055:	8b 45 10             	mov    0x10(%ebp),%eax
c0105058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010505f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105062:	01 d0                	add    %edx,%eax
c0105064:	8b 00                	mov    (%eax),%eax
c0105066:	83 e0 01             	and    $0x1,%eax
c0105069:	85 c0                	test   %eax,%eax
c010506b:	74 dc                	je     c0105049 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010506d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105070:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105073:	73 69                	jae    c01050de <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105075:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105079:	74 08                	je     c0105083 <get_pgtable_items+0x54>
            *left_store = start;
c010507b:	8b 45 18             	mov    0x18(%ebp),%eax
c010507e:	8b 55 10             	mov    0x10(%ebp),%edx
c0105081:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105083:	8b 45 10             	mov    0x10(%ebp),%eax
c0105086:	8d 50 01             	lea    0x1(%eax),%edx
c0105089:	89 55 10             	mov    %edx,0x10(%ebp)
c010508c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105093:	8b 45 14             	mov    0x14(%ebp),%eax
c0105096:	01 d0                	add    %edx,%eax
c0105098:	8b 00                	mov    (%eax),%eax
c010509a:	83 e0 07             	and    $0x7,%eax
c010509d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01050a0:	eb 04                	jmp    c01050a6 <get_pgtable_items+0x77>
            start ++;
c01050a2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01050a6:	8b 45 10             	mov    0x10(%ebp),%eax
c01050a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050ac:	73 1d                	jae    c01050cb <get_pgtable_items+0x9c>
c01050ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01050bb:	01 d0                	add    %edx,%eax
c01050bd:	8b 00                	mov    (%eax),%eax
c01050bf:	83 e0 07             	and    $0x7,%eax
c01050c2:	89 c2                	mov    %eax,%edx
c01050c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050c7:	39 c2                	cmp    %eax,%edx
c01050c9:	74 d7                	je     c01050a2 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01050cb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01050cf:	74 08                	je     c01050d9 <get_pgtable_items+0xaa>
            *right_store = start;
c01050d1:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01050d4:	8b 55 10             	mov    0x10(%ebp),%edx
c01050d7:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01050d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050dc:	eb 05                	jmp    c01050e3 <get_pgtable_items+0xb4>
    }
    return 0;
c01050de:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050e3:	c9                   	leave  
c01050e4:	c3                   	ret    

c01050e5 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01050e5:	55                   	push   %ebp
c01050e6:	89 e5                	mov    %esp,%ebp
c01050e8:	57                   	push   %edi
c01050e9:	56                   	push   %esi
c01050ea:	53                   	push   %ebx
c01050eb:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01050ee:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01050f5:	e8 42 b2 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01050fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105101:	e9 fa 00 00 00       	jmp    c0105200 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105109:	89 04 24             	mov    %eax,(%esp)
c010510c:	e8 d0 fe ff ff       	call   c0104fe1 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105111:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105114:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105117:	29 d1                	sub    %edx,%ecx
c0105119:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010511b:	89 d6                	mov    %edx,%esi
c010511d:	c1 e6 16             	shl    $0x16,%esi
c0105120:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105123:	89 d3                	mov    %edx,%ebx
c0105125:	c1 e3 16             	shl    $0x16,%ebx
c0105128:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010512b:	89 d1                	mov    %edx,%ecx
c010512d:	c1 e1 16             	shl    $0x16,%ecx
c0105130:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105133:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105136:	29 d7                	sub    %edx,%edi
c0105138:	89 fa                	mov    %edi,%edx
c010513a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010513e:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105142:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105146:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010514a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010514e:	c7 04 24 35 6e 10 c0 	movl   $0xc0106e35,(%esp)
c0105155:	e8 e2 b1 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010515a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010515d:	c1 e0 0a             	shl    $0xa,%eax
c0105160:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105163:	eb 54                	jmp    c01051b9 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105168:	89 04 24             	mov    %eax,(%esp)
c010516b:	e8 71 fe ff ff       	call   c0104fe1 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105170:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105173:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105176:	29 d1                	sub    %edx,%ecx
c0105178:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010517a:	89 d6                	mov    %edx,%esi
c010517c:	c1 e6 0c             	shl    $0xc,%esi
c010517f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105182:	89 d3                	mov    %edx,%ebx
c0105184:	c1 e3 0c             	shl    $0xc,%ebx
c0105187:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010518a:	c1 e2 0c             	shl    $0xc,%edx
c010518d:	89 d1                	mov    %edx,%ecx
c010518f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105192:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105195:	29 d7                	sub    %edx,%edi
c0105197:	89 fa                	mov    %edi,%edx
c0105199:	89 44 24 14          	mov    %eax,0x14(%esp)
c010519d:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051a1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051a5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051ad:	c7 04 24 54 6e 10 c0 	movl   $0xc0106e54,(%esp)
c01051b4:	e8 83 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051b9:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01051be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01051c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01051c4:	89 ce                	mov    %ecx,%esi
c01051c6:	c1 e6 0a             	shl    $0xa,%esi
c01051c9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01051cc:	89 cb                	mov    %ecx,%ebx
c01051ce:	c1 e3 0a             	shl    $0xa,%ebx
c01051d1:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01051d4:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01051d8:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01051db:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01051df:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01051e3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051e7:	89 74 24 04          	mov    %esi,0x4(%esp)
c01051eb:	89 1c 24             	mov    %ebx,(%esp)
c01051ee:	e8 3c fe ff ff       	call   c010502f <get_pgtable_items>
c01051f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01051f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01051fa:	0f 85 65 ff ff ff    	jne    c0105165 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105200:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105205:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105208:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010520b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010520f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105212:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105216:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010521a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010521e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105225:	00 
c0105226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010522d:	e8 fd fd ff ff       	call   c010502f <get_pgtable_items>
c0105232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105235:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105239:	0f 85 c7 fe ff ff    	jne    c0105106 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010523f:	c7 04 24 78 6e 10 c0 	movl   $0xc0106e78,(%esp)
c0105246:	e8 f1 b0 ff ff       	call   c010033c <cprintf>
}
c010524b:	83 c4 4c             	add    $0x4c,%esp
c010524e:	5b                   	pop    %ebx
c010524f:	5e                   	pop    %esi
c0105250:	5f                   	pop    %edi
c0105251:	5d                   	pop    %ebp
c0105252:	c3                   	ret    

c0105253 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105253:	55                   	push   %ebp
c0105254:	89 e5                	mov    %esp,%ebp
c0105256:	83 ec 58             	sub    $0x58,%esp
c0105259:	8b 45 10             	mov    0x10(%ebp),%eax
c010525c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010525f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105262:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105265:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105268:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010526b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010526e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105271:	8b 45 18             	mov    0x18(%ebp),%eax
c0105274:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105277:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010527a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010527d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105280:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105283:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105286:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010528d:	74 1c                	je     c01052ab <printnum+0x58>
c010528f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105292:	ba 00 00 00 00       	mov    $0x0,%edx
c0105297:	f7 75 e4             	divl   -0x1c(%ebp)
c010529a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010529d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052a0:	ba 00 00 00 00       	mov    $0x0,%edx
c01052a5:	f7 75 e4             	divl   -0x1c(%ebp)
c01052a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052b1:	f7 75 e4             	divl   -0x1c(%ebp)
c01052b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052b7:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01052ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01052c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01052c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052c9:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01052cc:	8b 45 18             	mov    0x18(%ebp),%eax
c01052cf:	ba 00 00 00 00       	mov    $0x0,%edx
c01052d4:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01052d7:	77 56                	ja     c010532f <printnum+0xdc>
c01052d9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01052dc:	72 05                	jb     c01052e3 <printnum+0x90>
c01052de:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01052e1:	77 4c                	ja     c010532f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01052e3:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052e6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01052e9:	8b 45 20             	mov    0x20(%ebp),%eax
c01052ec:	89 44 24 18          	mov    %eax,0x18(%esp)
c01052f0:	89 54 24 14          	mov    %edx,0x14(%esp)
c01052f4:	8b 45 18             	mov    0x18(%ebp),%eax
c01052f7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01052fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105301:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105305:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010530c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105310:	8b 45 08             	mov    0x8(%ebp),%eax
c0105313:	89 04 24             	mov    %eax,(%esp)
c0105316:	e8 38 ff ff ff       	call   c0105253 <printnum>
c010531b:	eb 1c                	jmp    c0105339 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010531d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105320:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105324:	8b 45 20             	mov    0x20(%ebp),%eax
c0105327:	89 04 24             	mov    %eax,(%esp)
c010532a:	8b 45 08             	mov    0x8(%ebp),%eax
c010532d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010532f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105333:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105337:	7f e4                	jg     c010531d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105339:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010533c:	05 2c 6f 10 c0       	add    $0xc0106f2c,%eax
c0105341:	0f b6 00             	movzbl (%eax),%eax
c0105344:	0f be c0             	movsbl %al,%eax
c0105347:	8b 55 0c             	mov    0xc(%ebp),%edx
c010534a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010534e:	89 04 24             	mov    %eax,(%esp)
c0105351:	8b 45 08             	mov    0x8(%ebp),%eax
c0105354:	ff d0                	call   *%eax
}
c0105356:	c9                   	leave  
c0105357:	c3                   	ret    

c0105358 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105358:	55                   	push   %ebp
c0105359:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010535b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010535f:	7e 14                	jle    c0105375 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105361:	8b 45 08             	mov    0x8(%ebp),%eax
c0105364:	8b 00                	mov    (%eax),%eax
c0105366:	8d 48 08             	lea    0x8(%eax),%ecx
c0105369:	8b 55 08             	mov    0x8(%ebp),%edx
c010536c:	89 0a                	mov    %ecx,(%edx)
c010536e:	8b 50 04             	mov    0x4(%eax),%edx
c0105371:	8b 00                	mov    (%eax),%eax
c0105373:	eb 30                	jmp    c01053a5 <getuint+0x4d>
    }
    else if (lflag) {
c0105375:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105379:	74 16                	je     c0105391 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010537b:	8b 45 08             	mov    0x8(%ebp),%eax
c010537e:	8b 00                	mov    (%eax),%eax
c0105380:	8d 48 04             	lea    0x4(%eax),%ecx
c0105383:	8b 55 08             	mov    0x8(%ebp),%edx
c0105386:	89 0a                	mov    %ecx,(%edx)
c0105388:	8b 00                	mov    (%eax),%eax
c010538a:	ba 00 00 00 00       	mov    $0x0,%edx
c010538f:	eb 14                	jmp    c01053a5 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105391:	8b 45 08             	mov    0x8(%ebp),%eax
c0105394:	8b 00                	mov    (%eax),%eax
c0105396:	8d 48 04             	lea    0x4(%eax),%ecx
c0105399:	8b 55 08             	mov    0x8(%ebp),%edx
c010539c:	89 0a                	mov    %ecx,(%edx)
c010539e:	8b 00                	mov    (%eax),%eax
c01053a0:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01053a5:	5d                   	pop    %ebp
c01053a6:	c3                   	ret    

c01053a7 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01053a7:	55                   	push   %ebp
c01053a8:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053ae:	7e 14                	jle    c01053c4 <getint+0x1d>
        return va_arg(*ap, long long);
c01053b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b3:	8b 00                	mov    (%eax),%eax
c01053b5:	8d 48 08             	lea    0x8(%eax),%ecx
c01053b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01053bb:	89 0a                	mov    %ecx,(%edx)
c01053bd:	8b 50 04             	mov    0x4(%eax),%edx
c01053c0:	8b 00                	mov    (%eax),%eax
c01053c2:	eb 28                	jmp    c01053ec <getint+0x45>
    }
    else if (lflag) {
c01053c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053c8:	74 12                	je     c01053dc <getint+0x35>
        return va_arg(*ap, long);
c01053ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01053cd:	8b 00                	mov    (%eax),%eax
c01053cf:	8d 48 04             	lea    0x4(%eax),%ecx
c01053d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01053d5:	89 0a                	mov    %ecx,(%edx)
c01053d7:	8b 00                	mov    (%eax),%eax
c01053d9:	99                   	cltd   
c01053da:	eb 10                	jmp    c01053ec <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01053dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01053df:	8b 00                	mov    (%eax),%eax
c01053e1:	8d 48 04             	lea    0x4(%eax),%ecx
c01053e4:	8b 55 08             	mov    0x8(%ebp),%edx
c01053e7:	89 0a                	mov    %ecx,(%edx)
c01053e9:	8b 00                	mov    (%eax),%eax
c01053eb:	99                   	cltd   
    }
}
c01053ec:	5d                   	pop    %ebp
c01053ed:	c3                   	ret    

c01053ee <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01053ee:	55                   	push   %ebp
c01053ef:	89 e5                	mov    %esp,%ebp
c01053f1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01053f4:	8d 45 14             	lea    0x14(%ebp),%eax
c01053f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01053fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105401:	8b 45 10             	mov    0x10(%ebp),%eax
c0105404:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010540b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010540f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105412:	89 04 24             	mov    %eax,(%esp)
c0105415:	e8 02 00 00 00       	call   c010541c <vprintfmt>
    va_end(ap);
}
c010541a:	c9                   	leave  
c010541b:	c3                   	ret    

c010541c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010541c:	55                   	push   %ebp
c010541d:	89 e5                	mov    %esp,%ebp
c010541f:	56                   	push   %esi
c0105420:	53                   	push   %ebx
c0105421:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105424:	eb 18                	jmp    c010543e <vprintfmt+0x22>
            if (ch == '\0') {
c0105426:	85 db                	test   %ebx,%ebx
c0105428:	75 05                	jne    c010542f <vprintfmt+0x13>
                return;
c010542a:	e9 d1 03 00 00       	jmp    c0105800 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010542f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105432:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105436:	89 1c 24             	mov    %ebx,(%esp)
c0105439:	8b 45 08             	mov    0x8(%ebp),%eax
c010543c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010543e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105441:	8d 50 01             	lea    0x1(%eax),%edx
c0105444:	89 55 10             	mov    %edx,0x10(%ebp)
c0105447:	0f b6 00             	movzbl (%eax),%eax
c010544a:	0f b6 d8             	movzbl %al,%ebx
c010544d:	83 fb 25             	cmp    $0x25,%ebx
c0105450:	75 d4                	jne    c0105426 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105452:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105456:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010545d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105460:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105463:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010546a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010546d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105470:	8b 45 10             	mov    0x10(%ebp),%eax
c0105473:	8d 50 01             	lea    0x1(%eax),%edx
c0105476:	89 55 10             	mov    %edx,0x10(%ebp)
c0105479:	0f b6 00             	movzbl (%eax),%eax
c010547c:	0f b6 d8             	movzbl %al,%ebx
c010547f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105482:	83 f8 55             	cmp    $0x55,%eax
c0105485:	0f 87 44 03 00 00    	ja     c01057cf <vprintfmt+0x3b3>
c010548b:	8b 04 85 50 6f 10 c0 	mov    -0x3fef90b0(,%eax,4),%eax
c0105492:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105494:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105498:	eb d6                	jmp    c0105470 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010549a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010549e:	eb d0                	jmp    c0105470 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01054a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01054a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054aa:	89 d0                	mov    %edx,%eax
c01054ac:	c1 e0 02             	shl    $0x2,%eax
c01054af:	01 d0                	add    %edx,%eax
c01054b1:	01 c0                	add    %eax,%eax
c01054b3:	01 d8                	add    %ebx,%eax
c01054b5:	83 e8 30             	sub    $0x30,%eax
c01054b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01054bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01054be:	0f b6 00             	movzbl (%eax),%eax
c01054c1:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01054c4:	83 fb 2f             	cmp    $0x2f,%ebx
c01054c7:	7e 0b                	jle    c01054d4 <vprintfmt+0xb8>
c01054c9:	83 fb 39             	cmp    $0x39,%ebx
c01054cc:	7f 06                	jg     c01054d4 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01054ce:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01054d2:	eb d3                	jmp    c01054a7 <vprintfmt+0x8b>
            goto process_precision;
c01054d4:	eb 33                	jmp    c0105509 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01054d6:	8b 45 14             	mov    0x14(%ebp),%eax
c01054d9:	8d 50 04             	lea    0x4(%eax),%edx
c01054dc:	89 55 14             	mov    %edx,0x14(%ebp)
c01054df:	8b 00                	mov    (%eax),%eax
c01054e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01054e4:	eb 23                	jmp    c0105509 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01054e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01054ea:	79 0c                	jns    c01054f8 <vprintfmt+0xdc>
                width = 0;
c01054ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01054f3:	e9 78 ff ff ff       	jmp    c0105470 <vprintfmt+0x54>
c01054f8:	e9 73 ff ff ff       	jmp    c0105470 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01054fd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105504:	e9 67 ff ff ff       	jmp    c0105470 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105509:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010550d:	79 12                	jns    c0105521 <vprintfmt+0x105>
                width = precision, precision = -1;
c010550f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105512:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105515:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010551c:	e9 4f ff ff ff       	jmp    c0105470 <vprintfmt+0x54>
c0105521:	e9 4a ff ff ff       	jmp    c0105470 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105526:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010552a:	e9 41 ff ff ff       	jmp    c0105470 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010552f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105532:	8d 50 04             	lea    0x4(%eax),%edx
c0105535:	89 55 14             	mov    %edx,0x14(%ebp)
c0105538:	8b 00                	mov    (%eax),%eax
c010553a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010553d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105541:	89 04 24             	mov    %eax,(%esp)
c0105544:	8b 45 08             	mov    0x8(%ebp),%eax
c0105547:	ff d0                	call   *%eax
            break;
c0105549:	e9 ac 02 00 00       	jmp    c01057fa <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010554e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105551:	8d 50 04             	lea    0x4(%eax),%edx
c0105554:	89 55 14             	mov    %edx,0x14(%ebp)
c0105557:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105559:	85 db                	test   %ebx,%ebx
c010555b:	79 02                	jns    c010555f <vprintfmt+0x143>
                err = -err;
c010555d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010555f:	83 fb 06             	cmp    $0x6,%ebx
c0105562:	7f 0b                	jg     c010556f <vprintfmt+0x153>
c0105564:	8b 34 9d 10 6f 10 c0 	mov    -0x3fef90f0(,%ebx,4),%esi
c010556b:	85 f6                	test   %esi,%esi
c010556d:	75 23                	jne    c0105592 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010556f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105573:	c7 44 24 08 3d 6f 10 	movl   $0xc0106f3d,0x8(%esp)
c010557a:	c0 
c010557b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010557e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105582:	8b 45 08             	mov    0x8(%ebp),%eax
c0105585:	89 04 24             	mov    %eax,(%esp)
c0105588:	e8 61 fe ff ff       	call   c01053ee <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010558d:	e9 68 02 00 00       	jmp    c01057fa <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105592:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105596:	c7 44 24 08 46 6f 10 	movl   $0xc0106f46,0x8(%esp)
c010559d:	c0 
c010559e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a8:	89 04 24             	mov    %eax,(%esp)
c01055ab:	e8 3e fe ff ff       	call   c01053ee <printfmt>
            }
            break;
c01055b0:	e9 45 02 00 00       	jmp    c01057fa <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01055b5:	8b 45 14             	mov    0x14(%ebp),%eax
c01055b8:	8d 50 04             	lea    0x4(%eax),%edx
c01055bb:	89 55 14             	mov    %edx,0x14(%ebp)
c01055be:	8b 30                	mov    (%eax),%esi
c01055c0:	85 f6                	test   %esi,%esi
c01055c2:	75 05                	jne    c01055c9 <vprintfmt+0x1ad>
                p = "(null)";
c01055c4:	be 49 6f 10 c0       	mov    $0xc0106f49,%esi
            }
            if (width > 0 && padc != '-') {
c01055c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055cd:	7e 3e                	jle    c010560d <vprintfmt+0x1f1>
c01055cf:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01055d3:	74 38                	je     c010560d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01055d5:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01055d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055df:	89 34 24             	mov    %esi,(%esp)
c01055e2:	e8 15 03 00 00       	call   c01058fc <strnlen>
c01055e7:	29 c3                	sub    %eax,%ebx
c01055e9:	89 d8                	mov    %ebx,%eax
c01055eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055ee:	eb 17                	jmp    c0105607 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01055f0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01055f4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055f7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055fb:	89 04 24             	mov    %eax,(%esp)
c01055fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105601:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105603:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105607:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010560b:	7f e3                	jg     c01055f0 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010560d:	eb 38                	jmp    c0105647 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010560f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105613:	74 1f                	je     c0105634 <vprintfmt+0x218>
c0105615:	83 fb 1f             	cmp    $0x1f,%ebx
c0105618:	7e 05                	jle    c010561f <vprintfmt+0x203>
c010561a:	83 fb 7e             	cmp    $0x7e,%ebx
c010561d:	7e 15                	jle    c0105634 <vprintfmt+0x218>
                    putch('?', putdat);
c010561f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105622:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105626:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010562d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105630:	ff d0                	call   *%eax
c0105632:	eb 0f                	jmp    c0105643 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105634:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105637:	89 44 24 04          	mov    %eax,0x4(%esp)
c010563b:	89 1c 24             	mov    %ebx,(%esp)
c010563e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105641:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105643:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105647:	89 f0                	mov    %esi,%eax
c0105649:	8d 70 01             	lea    0x1(%eax),%esi
c010564c:	0f b6 00             	movzbl (%eax),%eax
c010564f:	0f be d8             	movsbl %al,%ebx
c0105652:	85 db                	test   %ebx,%ebx
c0105654:	74 10                	je     c0105666 <vprintfmt+0x24a>
c0105656:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010565a:	78 b3                	js     c010560f <vprintfmt+0x1f3>
c010565c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105660:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105664:	79 a9                	jns    c010560f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105666:	eb 17                	jmp    c010567f <vprintfmt+0x263>
                putch(' ', putdat);
c0105668:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010566f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105676:	8b 45 08             	mov    0x8(%ebp),%eax
c0105679:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010567b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010567f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105683:	7f e3                	jg     c0105668 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105685:	e9 70 01 00 00       	jmp    c01057fa <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010568a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010568d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105691:	8d 45 14             	lea    0x14(%ebp),%eax
c0105694:	89 04 24             	mov    %eax,(%esp)
c0105697:	e8 0b fd ff ff       	call   c01053a7 <getint>
c010569c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010569f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01056a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056a8:	85 d2                	test   %edx,%edx
c01056aa:	79 26                	jns    c01056d2 <vprintfmt+0x2b6>
                putch('-', putdat);
c01056ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b3:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01056ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01056bd:	ff d0                	call   *%eax
                num = -(long long)num;
c01056bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056c5:	f7 d8                	neg    %eax
c01056c7:	83 d2 00             	adc    $0x0,%edx
c01056ca:	f7 da                	neg    %edx
c01056cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01056d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01056d9:	e9 a8 00 00 00       	jmp    c0105786 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01056de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e5:	8d 45 14             	lea    0x14(%ebp),%eax
c01056e8:	89 04 24             	mov    %eax,(%esp)
c01056eb:	e8 68 fc ff ff       	call   c0105358 <getuint>
c01056f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01056f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01056fd:	e9 84 00 00 00       	jmp    c0105786 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105702:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105705:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105709:	8d 45 14             	lea    0x14(%ebp),%eax
c010570c:	89 04 24             	mov    %eax,(%esp)
c010570f:	e8 44 fc ff ff       	call   c0105358 <getuint>
c0105714:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105717:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010571a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105721:	eb 63                	jmp    c0105786 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105723:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105726:	89 44 24 04          	mov    %eax,0x4(%esp)
c010572a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105731:	8b 45 08             	mov    0x8(%ebp),%eax
c0105734:	ff d0                	call   *%eax
            putch('x', putdat);
c0105736:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105739:	89 44 24 04          	mov    %eax,0x4(%esp)
c010573d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105744:	8b 45 08             	mov    0x8(%ebp),%eax
c0105747:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105749:	8b 45 14             	mov    0x14(%ebp),%eax
c010574c:	8d 50 04             	lea    0x4(%eax),%edx
c010574f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105752:	8b 00                	mov    (%eax),%eax
c0105754:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105757:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010575e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105765:	eb 1f                	jmp    c0105786 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105767:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010576a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010576e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105771:	89 04 24             	mov    %eax,(%esp)
c0105774:	e8 df fb ff ff       	call   c0105358 <getuint>
c0105779:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010577c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010577f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105786:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010578a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010578d:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105791:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105794:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105798:	89 44 24 10          	mov    %eax,0x10(%esp)
c010579c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010579f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01057aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b4:	89 04 24             	mov    %eax,(%esp)
c01057b7:	e8 97 fa ff ff       	call   c0105253 <printnum>
            break;
c01057bc:	eb 3c                	jmp    c01057fa <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01057be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c5:	89 1c 24             	mov    %ebx,(%esp)
c01057c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cb:	ff d0                	call   *%eax
            break;
c01057cd:	eb 2b                	jmp    c01057fa <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d6:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01057dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e0:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01057e2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01057e6:	eb 04                	jmp    c01057ec <vprintfmt+0x3d0>
c01057e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01057ec:	8b 45 10             	mov    0x10(%ebp),%eax
c01057ef:	83 e8 01             	sub    $0x1,%eax
c01057f2:	0f b6 00             	movzbl (%eax),%eax
c01057f5:	3c 25                	cmp    $0x25,%al
c01057f7:	75 ef                	jne    c01057e8 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01057f9:	90                   	nop
        }
    }
c01057fa:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057fb:	e9 3e fc ff ff       	jmp    c010543e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105800:	83 c4 40             	add    $0x40,%esp
c0105803:	5b                   	pop    %ebx
c0105804:	5e                   	pop    %esi
c0105805:	5d                   	pop    %ebp
c0105806:	c3                   	ret    

c0105807 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105807:	55                   	push   %ebp
c0105808:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010580a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580d:	8b 40 08             	mov    0x8(%eax),%eax
c0105810:	8d 50 01             	lea    0x1(%eax),%edx
c0105813:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105816:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010581c:	8b 10                	mov    (%eax),%edx
c010581e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105821:	8b 40 04             	mov    0x4(%eax),%eax
c0105824:	39 c2                	cmp    %eax,%edx
c0105826:	73 12                	jae    c010583a <sprintputch+0x33>
        *b->buf ++ = ch;
c0105828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582b:	8b 00                	mov    (%eax),%eax
c010582d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105830:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105833:	89 0a                	mov    %ecx,(%edx)
c0105835:	8b 55 08             	mov    0x8(%ebp),%edx
c0105838:	88 10                	mov    %dl,(%eax)
    }
}
c010583a:	5d                   	pop    %ebp
c010583b:	c3                   	ret    

c010583c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010583c:	55                   	push   %ebp
c010583d:	89 e5                	mov    %esp,%ebp
c010583f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105842:	8d 45 14             	lea    0x14(%ebp),%eax
c0105845:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105848:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010584b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010584f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105852:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105856:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105859:	89 44 24 04          	mov    %eax,0x4(%esp)
c010585d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105860:	89 04 24             	mov    %eax,(%esp)
c0105863:	e8 08 00 00 00       	call   c0105870 <vsnprintf>
c0105868:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010586b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010586e:	c9                   	leave  
c010586f:	c3                   	ret    

c0105870 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105870:	55                   	push   %ebp
c0105871:	89 e5                	mov    %esp,%ebp
c0105873:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105876:	8b 45 08             	mov    0x8(%ebp),%eax
c0105879:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010587c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105882:	8b 45 08             	mov    0x8(%ebp),%eax
c0105885:	01 d0                	add    %edx,%eax
c0105887:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010588a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105891:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105895:	74 0a                	je     c01058a1 <vsnprintf+0x31>
c0105897:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010589a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010589d:	39 c2                	cmp    %eax,%edx
c010589f:	76 07                	jbe    c01058a8 <vsnprintf+0x38>
        return -E_INVAL;
c01058a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01058a6:	eb 2a                	jmp    c01058d2 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01058a8:	8b 45 14             	mov    0x14(%ebp),%eax
c01058ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058af:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bd:	c7 04 24 07 58 10 c0 	movl   $0xc0105807,(%esp)
c01058c4:	e8 53 fb ff ff       	call   c010541c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01058c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058cc:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01058cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058d2:	c9                   	leave  
c01058d3:	c3                   	ret    

c01058d4 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01058d4:	55                   	push   %ebp
c01058d5:	89 e5                	mov    %esp,%ebp
c01058d7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01058da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01058e1:	eb 04                	jmp    c01058e7 <strlen+0x13>
        cnt ++;
c01058e3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01058e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ea:	8d 50 01             	lea    0x1(%eax),%edx
c01058ed:	89 55 08             	mov    %edx,0x8(%ebp)
c01058f0:	0f b6 00             	movzbl (%eax),%eax
c01058f3:	84 c0                	test   %al,%al
c01058f5:	75 ec                	jne    c01058e3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01058f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01058fa:	c9                   	leave  
c01058fb:	c3                   	ret    

c01058fc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01058fc:	55                   	push   %ebp
c01058fd:	89 e5                	mov    %esp,%ebp
c01058ff:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105902:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105909:	eb 04                	jmp    c010590f <strnlen+0x13>
        cnt ++;
c010590b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010590f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105912:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105915:	73 10                	jae    c0105927 <strnlen+0x2b>
c0105917:	8b 45 08             	mov    0x8(%ebp),%eax
c010591a:	8d 50 01             	lea    0x1(%eax),%edx
c010591d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105920:	0f b6 00             	movzbl (%eax),%eax
c0105923:	84 c0                	test   %al,%al
c0105925:	75 e4                	jne    c010590b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105927:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010592a:	c9                   	leave  
c010592b:	c3                   	ret    

c010592c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010592c:	55                   	push   %ebp
c010592d:	89 e5                	mov    %esp,%ebp
c010592f:	57                   	push   %edi
c0105930:	56                   	push   %esi
c0105931:	83 ec 20             	sub    $0x20,%esp
c0105934:	8b 45 08             	mov    0x8(%ebp),%eax
c0105937:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010593a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105940:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105946:	89 d1                	mov    %edx,%ecx
c0105948:	89 c2                	mov    %eax,%edx
c010594a:	89 ce                	mov    %ecx,%esi
c010594c:	89 d7                	mov    %edx,%edi
c010594e:	ac                   	lods   %ds:(%esi),%al
c010594f:	aa                   	stos   %al,%es:(%edi)
c0105950:	84 c0                	test   %al,%al
c0105952:	75 fa                	jne    c010594e <strcpy+0x22>
c0105954:	89 fa                	mov    %edi,%edx
c0105956:	89 f1                	mov    %esi,%ecx
c0105958:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010595b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010595e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105961:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105964:	83 c4 20             	add    $0x20,%esp
c0105967:	5e                   	pop    %esi
c0105968:	5f                   	pop    %edi
c0105969:	5d                   	pop    %ebp
c010596a:	c3                   	ret    

c010596b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010596b:	55                   	push   %ebp
c010596c:	89 e5                	mov    %esp,%ebp
c010596e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105971:	8b 45 08             	mov    0x8(%ebp),%eax
c0105974:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105977:	eb 21                	jmp    c010599a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105979:	8b 45 0c             	mov    0xc(%ebp),%eax
c010597c:	0f b6 10             	movzbl (%eax),%edx
c010597f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105982:	88 10                	mov    %dl,(%eax)
c0105984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105987:	0f b6 00             	movzbl (%eax),%eax
c010598a:	84 c0                	test   %al,%al
c010598c:	74 04                	je     c0105992 <strncpy+0x27>
            src ++;
c010598e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105992:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105996:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010599a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010599e:	75 d9                	jne    c0105979 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01059a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01059a3:	c9                   	leave  
c01059a4:	c3                   	ret    

c01059a5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01059a5:	55                   	push   %ebp
c01059a6:	89 e5                	mov    %esp,%ebp
c01059a8:	57                   	push   %edi
c01059a9:	56                   	push   %esi
c01059aa:	83 ec 20             	sub    $0x20,%esp
c01059ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01059b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059bf:	89 d1                	mov    %edx,%ecx
c01059c1:	89 c2                	mov    %eax,%edx
c01059c3:	89 ce                	mov    %ecx,%esi
c01059c5:	89 d7                	mov    %edx,%edi
c01059c7:	ac                   	lods   %ds:(%esi),%al
c01059c8:	ae                   	scas   %es:(%edi),%al
c01059c9:	75 08                	jne    c01059d3 <strcmp+0x2e>
c01059cb:	84 c0                	test   %al,%al
c01059cd:	75 f8                	jne    c01059c7 <strcmp+0x22>
c01059cf:	31 c0                	xor    %eax,%eax
c01059d1:	eb 04                	jmp    c01059d7 <strcmp+0x32>
c01059d3:	19 c0                	sbb    %eax,%eax
c01059d5:	0c 01                	or     $0x1,%al
c01059d7:	89 fa                	mov    %edi,%edx
c01059d9:	89 f1                	mov    %esi,%ecx
c01059db:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059de:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01059e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01059e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01059e7:	83 c4 20             	add    $0x20,%esp
c01059ea:	5e                   	pop    %esi
c01059eb:	5f                   	pop    %edi
c01059ec:	5d                   	pop    %ebp
c01059ed:	c3                   	ret    

c01059ee <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01059ee:	55                   	push   %ebp
c01059ef:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01059f1:	eb 0c                	jmp    c01059ff <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01059f3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01059fb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01059ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a03:	74 1a                	je     c0105a1f <strncmp+0x31>
c0105a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a08:	0f b6 00             	movzbl (%eax),%eax
c0105a0b:	84 c0                	test   %al,%al
c0105a0d:	74 10                	je     c0105a1f <strncmp+0x31>
c0105a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a12:	0f b6 10             	movzbl (%eax),%edx
c0105a15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a18:	0f b6 00             	movzbl (%eax),%eax
c0105a1b:	38 c2                	cmp    %al,%dl
c0105a1d:	74 d4                	je     c01059f3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a1f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a23:	74 18                	je     c0105a3d <strncmp+0x4f>
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	0f b6 00             	movzbl (%eax),%eax
c0105a2b:	0f b6 d0             	movzbl %al,%edx
c0105a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a31:	0f b6 00             	movzbl (%eax),%eax
c0105a34:	0f b6 c0             	movzbl %al,%eax
c0105a37:	29 c2                	sub    %eax,%edx
c0105a39:	89 d0                	mov    %edx,%eax
c0105a3b:	eb 05                	jmp    c0105a42 <strncmp+0x54>
c0105a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a42:	5d                   	pop    %ebp
c0105a43:	c3                   	ret    

c0105a44 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105a44:	55                   	push   %ebp
c0105a45:	89 e5                	mov    %esp,%ebp
c0105a47:	83 ec 04             	sub    $0x4,%esp
c0105a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a50:	eb 14                	jmp    c0105a66 <strchr+0x22>
        if (*s == c) {
c0105a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a55:	0f b6 00             	movzbl (%eax),%eax
c0105a58:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105a5b:	75 05                	jne    c0105a62 <strchr+0x1e>
            return (char *)s;
c0105a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a60:	eb 13                	jmp    c0105a75 <strchr+0x31>
        }
        s ++;
c0105a62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a69:	0f b6 00             	movzbl (%eax),%eax
c0105a6c:	84 c0                	test   %al,%al
c0105a6e:	75 e2                	jne    c0105a52 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a75:	c9                   	leave  
c0105a76:	c3                   	ret    

c0105a77 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105a77:	55                   	push   %ebp
c0105a78:	89 e5                	mov    %esp,%ebp
c0105a7a:	83 ec 04             	sub    $0x4,%esp
c0105a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a80:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a83:	eb 11                	jmp    c0105a96 <strfind+0x1f>
        if (*s == c) {
c0105a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a88:	0f b6 00             	movzbl (%eax),%eax
c0105a8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105a8e:	75 02                	jne    c0105a92 <strfind+0x1b>
            break;
c0105a90:	eb 0e                	jmp    c0105aa0 <strfind+0x29>
        }
        s ++;
c0105a92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a99:	0f b6 00             	movzbl (%eax),%eax
c0105a9c:	84 c0                	test   %al,%al
c0105a9e:	75 e5                	jne    c0105a85 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105aa3:	c9                   	leave  
c0105aa4:	c3                   	ret    

c0105aa5 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105aa5:	55                   	push   %ebp
c0105aa6:	89 e5                	mov    %esp,%ebp
c0105aa8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105aab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ab2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ab9:	eb 04                	jmp    c0105abf <strtol+0x1a>
        s ++;
c0105abb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac2:	0f b6 00             	movzbl (%eax),%eax
c0105ac5:	3c 20                	cmp    $0x20,%al
c0105ac7:	74 f2                	je     c0105abb <strtol+0x16>
c0105ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acc:	0f b6 00             	movzbl (%eax),%eax
c0105acf:	3c 09                	cmp    $0x9,%al
c0105ad1:	74 e8                	je     c0105abb <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad6:	0f b6 00             	movzbl (%eax),%eax
c0105ad9:	3c 2b                	cmp    $0x2b,%al
c0105adb:	75 06                	jne    c0105ae3 <strtol+0x3e>
        s ++;
c0105add:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ae1:	eb 15                	jmp    c0105af8 <strtol+0x53>
    }
    else if (*s == '-') {
c0105ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae6:	0f b6 00             	movzbl (%eax),%eax
c0105ae9:	3c 2d                	cmp    $0x2d,%al
c0105aeb:	75 0b                	jne    c0105af8 <strtol+0x53>
        s ++, neg = 1;
c0105aed:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105af1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105af8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105afc:	74 06                	je     c0105b04 <strtol+0x5f>
c0105afe:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b02:	75 24                	jne    c0105b28 <strtol+0x83>
c0105b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b07:	0f b6 00             	movzbl (%eax),%eax
c0105b0a:	3c 30                	cmp    $0x30,%al
c0105b0c:	75 1a                	jne    c0105b28 <strtol+0x83>
c0105b0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b11:	83 c0 01             	add    $0x1,%eax
c0105b14:	0f b6 00             	movzbl (%eax),%eax
c0105b17:	3c 78                	cmp    $0x78,%al
c0105b19:	75 0d                	jne    c0105b28 <strtol+0x83>
        s += 2, base = 16;
c0105b1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105b26:	eb 2a                	jmp    c0105b52 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105b28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b2c:	75 17                	jne    c0105b45 <strtol+0xa0>
c0105b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b31:	0f b6 00             	movzbl (%eax),%eax
c0105b34:	3c 30                	cmp    $0x30,%al
c0105b36:	75 0d                	jne    c0105b45 <strtol+0xa0>
        s ++, base = 8;
c0105b38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b3c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105b43:	eb 0d                	jmp    c0105b52 <strtol+0xad>
    }
    else if (base == 0) {
c0105b45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b49:	75 07                	jne    c0105b52 <strtol+0xad>
        base = 10;
c0105b4b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b55:	0f b6 00             	movzbl (%eax),%eax
c0105b58:	3c 2f                	cmp    $0x2f,%al
c0105b5a:	7e 1b                	jle    c0105b77 <strtol+0xd2>
c0105b5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5f:	0f b6 00             	movzbl (%eax),%eax
c0105b62:	3c 39                	cmp    $0x39,%al
c0105b64:	7f 11                	jg     c0105b77 <strtol+0xd2>
            dig = *s - '0';
c0105b66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b69:	0f b6 00             	movzbl (%eax),%eax
c0105b6c:	0f be c0             	movsbl %al,%eax
c0105b6f:	83 e8 30             	sub    $0x30,%eax
c0105b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b75:	eb 48                	jmp    c0105bbf <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7a:	0f b6 00             	movzbl (%eax),%eax
c0105b7d:	3c 60                	cmp    $0x60,%al
c0105b7f:	7e 1b                	jle    c0105b9c <strtol+0xf7>
c0105b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b84:	0f b6 00             	movzbl (%eax),%eax
c0105b87:	3c 7a                	cmp    $0x7a,%al
c0105b89:	7f 11                	jg     c0105b9c <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8e:	0f b6 00             	movzbl (%eax),%eax
c0105b91:	0f be c0             	movsbl %al,%eax
c0105b94:	83 e8 57             	sub    $0x57,%eax
c0105b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b9a:	eb 23                	jmp    c0105bbf <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9f:	0f b6 00             	movzbl (%eax),%eax
c0105ba2:	3c 40                	cmp    $0x40,%al
c0105ba4:	7e 3d                	jle    c0105be3 <strtol+0x13e>
c0105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba9:	0f b6 00             	movzbl (%eax),%eax
c0105bac:	3c 5a                	cmp    $0x5a,%al
c0105bae:	7f 33                	jg     c0105be3 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb3:	0f b6 00             	movzbl (%eax),%eax
c0105bb6:	0f be c0             	movsbl %al,%eax
c0105bb9:	83 e8 37             	sub    $0x37,%eax
c0105bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc2:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105bc5:	7c 02                	jl     c0105bc9 <strtol+0x124>
            break;
c0105bc7:	eb 1a                	jmp    c0105be3 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105bc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bd0:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105bd4:	89 c2                	mov    %eax,%edx
c0105bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bd9:	01 d0                	add    %edx,%eax
c0105bdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105bde:	e9 6f ff ff ff       	jmp    c0105b52 <strtol+0xad>

    if (endptr) {
c0105be3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105be7:	74 08                	je     c0105bf1 <strtol+0x14c>
        *endptr = (char *) s;
c0105be9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bec:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bef:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105bf1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105bf5:	74 07                	je     c0105bfe <strtol+0x159>
c0105bf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bfa:	f7 d8                	neg    %eax
c0105bfc:	eb 03                	jmp    c0105c01 <strtol+0x15c>
c0105bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c01:	c9                   	leave  
c0105c02:	c3                   	ret    

c0105c03 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c03:	55                   	push   %ebp
c0105c04:	89 e5                	mov    %esp,%ebp
c0105c06:	57                   	push   %edi
c0105c07:	83 ec 24             	sub    $0x24,%esp
c0105c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c0d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c10:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c14:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c17:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c1a:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c1d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105c23:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105c26:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105c2a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105c2d:	89 d7                	mov    %edx,%edi
c0105c2f:	f3 aa                	rep stos %al,%es:(%edi)
c0105c31:	89 fa                	mov    %edi,%edx
c0105c33:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105c36:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105c39:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105c3c:	83 c4 24             	add    $0x24,%esp
c0105c3f:	5f                   	pop    %edi
c0105c40:	5d                   	pop    %ebp
c0105c41:	c3                   	ret    

c0105c42 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105c42:	55                   	push   %ebp
c0105c43:	89 e5                	mov    %esp,%ebp
c0105c45:	57                   	push   %edi
c0105c46:	56                   	push   %esi
c0105c47:	53                   	push   %ebx
c0105c48:	83 ec 30             	sub    $0x30,%esp
c0105c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c54:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c57:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c60:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105c63:	73 42                	jae    c0105ca7 <memmove+0x65>
c0105c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c74:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105c77:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c7a:	c1 e8 02             	shr    $0x2,%eax
c0105c7d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105c7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c82:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c85:	89 d7                	mov    %edx,%edi
c0105c87:	89 c6                	mov    %eax,%esi
c0105c89:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105c8b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105c8e:	83 e1 03             	and    $0x3,%ecx
c0105c91:	74 02                	je     c0105c95 <memmove+0x53>
c0105c93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105c95:	89 f0                	mov    %esi,%eax
c0105c97:	89 fa                	mov    %edi,%edx
c0105c99:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105c9c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105c9f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ca5:	eb 36                	jmp    c0105cdd <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105caa:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cb0:	01 c2                	add    %eax,%edx
c0105cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cb5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cbb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cc1:	89 c1                	mov    %eax,%ecx
c0105cc3:	89 d8                	mov    %ebx,%eax
c0105cc5:	89 d6                	mov    %edx,%esi
c0105cc7:	89 c7                	mov    %eax,%edi
c0105cc9:	fd                   	std    
c0105cca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ccc:	fc                   	cld    
c0105ccd:	89 f8                	mov    %edi,%eax
c0105ccf:	89 f2                	mov    %esi,%edx
c0105cd1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105cd4:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105cd7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105cdd:	83 c4 30             	add    $0x30,%esp
c0105ce0:	5b                   	pop    %ebx
c0105ce1:	5e                   	pop    %esi
c0105ce2:	5f                   	pop    %edi
c0105ce3:	5d                   	pop    %ebp
c0105ce4:	c3                   	ret    

c0105ce5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ce5:	55                   	push   %ebp
c0105ce6:	89 e5                	mov    %esp,%ebp
c0105ce8:	57                   	push   %edi
c0105ce9:	56                   	push   %esi
c0105cea:	83 ec 20             	sub    $0x20,%esp
c0105ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cf9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d02:	c1 e8 02             	shr    $0x2,%eax
c0105d05:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d0d:	89 d7                	mov    %edx,%edi
c0105d0f:	89 c6                	mov    %eax,%esi
c0105d11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d13:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d16:	83 e1 03             	and    $0x3,%ecx
c0105d19:	74 02                	je     c0105d1d <memcpy+0x38>
c0105d1b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d1d:	89 f0                	mov    %esi,%eax
c0105d1f:	89 fa                	mov    %edi,%edx
c0105d21:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d24:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105d27:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105d2d:	83 c4 20             	add    $0x20,%esp
c0105d30:	5e                   	pop    %esi
c0105d31:	5f                   	pop    %edi
c0105d32:	5d                   	pop    %ebp
c0105d33:	c3                   	ret    

c0105d34 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105d34:	55                   	push   %ebp
c0105d35:	89 e5                	mov    %esp,%ebp
c0105d37:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105d40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105d46:	eb 30                	jmp    c0105d78 <memcmp+0x44>
        if (*s1 != *s2) {
c0105d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d4b:	0f b6 10             	movzbl (%eax),%edx
c0105d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d51:	0f b6 00             	movzbl (%eax),%eax
c0105d54:	38 c2                	cmp    %al,%dl
c0105d56:	74 18                	je     c0105d70 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d5b:	0f b6 00             	movzbl (%eax),%eax
c0105d5e:	0f b6 d0             	movzbl %al,%edx
c0105d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d64:	0f b6 00             	movzbl (%eax),%eax
c0105d67:	0f b6 c0             	movzbl %al,%eax
c0105d6a:	29 c2                	sub    %eax,%edx
c0105d6c:	89 d0                	mov    %edx,%eax
c0105d6e:	eb 1a                	jmp    c0105d8a <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105d70:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d74:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105d78:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d7e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d81:	85 c0                	test   %eax,%eax
c0105d83:	75 c3                	jne    c0105d48 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105d85:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d8a:	c9                   	leave  
c0105d8b:	c3                   	ret    
