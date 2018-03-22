
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 d2 01 00 00       	call   1e8 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 5c 02 00 00       	call   280 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 c4 01 00 00       	call   1f0 <exit>

0000002c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	53                   	push   %ebx
  30:	8b 45 08             	mov    0x8(%ebp),%eax
  33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	89 c2                	mov    %eax,%edx
  38:	83 c2 01             	add    $0x1,%edx
  3b:	83 c1 01             	add    $0x1,%ecx
  3e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  42:	88 5a ff             	mov    %bl,-0x1(%edx)
  45:	84 db                	test   %bl,%bl
  47:	75 ef                	jne    38 <strcpy+0xc>
    ;
  return os;
}
  49:	5b                   	pop    %ebx
  4a:	5d                   	pop    %ebp
  4b:	c3                   	ret    

0000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	55                   	push   %ebp
  4d:	89 e5                	mov    %esp,%ebp
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  55:	0f b6 01             	movzbl (%ecx),%eax
  58:	84 c0                	test   %al,%al
  5a:	74 15                	je     71 <strcmp+0x25>
  5c:	3a 02                	cmp    (%edx),%al
  5e:	75 11                	jne    71 <strcmp+0x25>
    p++, q++;
  60:	83 c1 01             	add    $0x1,%ecx
  63:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  66:	0f b6 01             	movzbl (%ecx),%eax
  69:	84 c0                	test   %al,%al
  6b:	74 04                	je     71 <strcmp+0x25>
  6d:	3a 02                	cmp    (%edx),%al
  6f:	74 ef                	je     60 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  71:	0f b6 c0             	movzbl %al,%eax
  74:	0f b6 12             	movzbl (%edx),%edx
  77:	29 d0                	sub    %edx,%eax
}
  79:	5d                   	pop    %ebp
  7a:	c3                   	ret    

0000007b <strlen>:

uint
strlen(char *s)
{
  7b:	55                   	push   %ebp
  7c:	89 e5                	mov    %esp,%ebp
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  81:	80 39 00             	cmpb   $0x0,(%ecx)
  84:	74 12                	je     98 <strlen+0x1d>
  86:	ba 00 00 00 00       	mov    $0x0,%edx
  8b:	83 c2 01             	add    $0x1,%edx
  8e:	89 d0                	mov    %edx,%eax
  90:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  94:	75 f5                	jne    8b <strlen+0x10>
  96:	eb 05                	jmp    9d <strlen+0x22>
  98:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <memset>:

void*
memset(void *dst, int c, uint n)
{
  9f:	55                   	push   %ebp
  a0:	89 e5                	mov    %esp,%ebp
  a2:	57                   	push   %edi
  a3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  a6:	89 d7                	mov    %edx,%edi
  a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	fc                   	cld    
  af:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b1:	89 d0                	mov    %edx,%eax
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strchr>:

char*
strchr(const char *s, char c)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	53                   	push   %ebx
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  c0:	0f b6 10             	movzbl (%eax),%edx
  c3:	84 d2                	test   %dl,%dl
  c5:	74 1d                	je     e4 <strchr+0x2e>
  c7:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  c9:	38 d3                	cmp    %dl,%bl
  cb:	75 06                	jne    d3 <strchr+0x1d>
  cd:	eb 1a                	jmp    e9 <strchr+0x33>
  cf:	38 ca                	cmp    %cl,%dl
  d1:	74 16                	je     e9 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
  d3:	83 c0 01             	add    $0x1,%eax
  d6:	0f b6 10             	movzbl (%eax),%edx
  d9:	84 d2                	test   %dl,%dl
  db:	75 f2                	jne    cf <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
  dd:	b8 00 00 00 00       	mov    $0x0,%eax
  e2:	eb 05                	jmp    e9 <strchr+0x33>
  e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e9:	5b                   	pop    %ebx
  ea:	5d                   	pop    %ebp
  eb:	c3                   	ret    

000000ec <gets>:

char*
gets(char *buf, int max)
{
  ec:	55                   	push   %ebp
  ed:	89 e5                	mov    %esp,%ebp
  ef:	57                   	push   %edi
  f0:	56                   	push   %esi
  f1:	53                   	push   %ebx
  f2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f5:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
  fa:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fd:	eb 29                	jmp    128 <gets+0x3c>
    cc = read(0, &c, 1);
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	6a 01                	push   $0x1
 104:	57                   	push   %edi
 105:	6a 00                	push   $0x0
 107:	e8 fc 00 00 00       	call   208 <read>
    if(cc < 1)
 10c:	83 c4 10             	add    $0x10,%esp
 10f:	85 c0                	test   %eax,%eax
 111:	7e 21                	jle    134 <gets+0x48>
      break;
    buf[i++] = c;
 113:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 117:	8b 55 08             	mov    0x8(%ebp),%edx
 11a:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11e:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 120:	3c 0a                	cmp    $0xa,%al
 122:	74 0e                	je     132 <gets+0x46>
 124:	3c 0d                	cmp    $0xd,%al
 126:	74 0a                	je     132 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 128:	8d 5e 01             	lea    0x1(%esi),%ebx
 12b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12e:	7c cf                	jl     ff <gets+0x13>
 130:	eb 02                	jmp    134 <gets+0x48>
 132:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 13b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 13e:	5b                   	pop    %ebx
 13f:	5e                   	pop    %esi
 140:	5f                   	pop    %edi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <stat>:

int
stat(char *n, struct stat *st)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	56                   	push   %esi
 147:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 148:	83 ec 08             	sub    $0x8,%esp
 14b:	6a 00                	push   $0x0
 14d:	ff 75 08             	pushl  0x8(%ebp)
 150:	e8 db 00 00 00       	call   230 <open>
  if(fd < 0)
 155:	83 c4 10             	add    $0x10,%esp
 158:	85 c0                	test   %eax,%eax
 15a:	78 1f                	js     17b <stat+0x38>
 15c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15e:	83 ec 08             	sub    $0x8,%esp
 161:	ff 75 0c             	pushl  0xc(%ebp)
 164:	50                   	push   %eax
 165:	e8 de 00 00 00       	call   248 <fstat>
 16a:	89 c6                	mov    %eax,%esi
  close(fd);
 16c:	89 1c 24             	mov    %ebx,(%esp)
 16f:	e8 a4 00 00 00       	call   218 <close>
  return r;
 174:	83 c4 10             	add    $0x10,%esp
 177:	89 f0                	mov    %esi,%eax
 179:	eb 05                	jmp    180 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 17b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 180:	8d 65 f8             	lea    -0x8(%ebp),%esp
 183:	5b                   	pop    %ebx
 184:	5e                   	pop    %esi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    

00000187 <atoi>:

int
atoi(const char *s)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	53                   	push   %ebx
 18b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 18e:	0f b6 11             	movzbl (%ecx),%edx
 191:	8d 42 d0             	lea    -0x30(%edx),%eax
 194:	3c 09                	cmp    $0x9,%al
 196:	77 1f                	ja     1b7 <atoi+0x30>
 198:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 19d:	83 c1 01             	add    $0x1,%ecx
 1a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1a3:	0f be d2             	movsbl %dl,%edx
 1a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1aa:	0f b6 11             	movzbl (%ecx),%edx
 1ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1b0:	80 fb 09             	cmp    $0x9,%bl
 1b3:	76 e8                	jbe    19d <atoi+0x16>
 1b5:	eb 05                	jmp    1bc <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 1b7:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 1bc:	5b                   	pop    %ebx
 1bd:	5d                   	pop    %ebp
 1be:	c3                   	ret    

000001bf <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
 1c2:	56                   	push   %esi
 1c3:	53                   	push   %ebx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	8b 75 0c             	mov    0xc(%ebp),%esi
 1ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1cd:	85 db                	test   %ebx,%ebx
 1cf:	7e 13                	jle    1e4 <memmove+0x25>
 1d1:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 1d6:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 1da:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 1dd:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1e0:	39 da                	cmp    %ebx,%edx
 1e2:	75 f2                	jne    1d6 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 1e4:	5b                   	pop    %ebx
 1e5:	5e                   	pop    %esi
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e8:	b8 01 00 00 00       	mov    $0x1,%eax
 1ed:	cd 40                	int    $0x40
 1ef:	c3                   	ret    

000001f0 <exit>:
SYSCALL(exit)
 1f0:	b8 02 00 00 00       	mov    $0x2,%eax
 1f5:	cd 40                	int    $0x40
 1f7:	c3                   	ret    

000001f8 <wait>:
SYSCALL(wait)
 1f8:	b8 03 00 00 00       	mov    $0x3,%eax
 1fd:	cd 40                	int    $0x40
 1ff:	c3                   	ret    

00000200 <pipe>:
SYSCALL(pipe)
 200:	b8 04 00 00 00       	mov    $0x4,%eax
 205:	cd 40                	int    $0x40
 207:	c3                   	ret    

00000208 <read>:
SYSCALL(read)
 208:	b8 05 00 00 00       	mov    $0x5,%eax
 20d:	cd 40                	int    $0x40
 20f:	c3                   	ret    

00000210 <write>:
SYSCALL(write)
 210:	b8 10 00 00 00       	mov    $0x10,%eax
 215:	cd 40                	int    $0x40
 217:	c3                   	ret    

00000218 <close>:
SYSCALL(close)
 218:	b8 15 00 00 00       	mov    $0x15,%eax
 21d:	cd 40                	int    $0x40
 21f:	c3                   	ret    

00000220 <kill>:
SYSCALL(kill)
 220:	b8 06 00 00 00       	mov    $0x6,%eax
 225:	cd 40                	int    $0x40
 227:	c3                   	ret    

00000228 <exec>:
SYSCALL(exec)
 228:	b8 07 00 00 00       	mov    $0x7,%eax
 22d:	cd 40                	int    $0x40
 22f:	c3                   	ret    

00000230 <open>:
SYSCALL(open)
 230:	b8 0f 00 00 00       	mov    $0xf,%eax
 235:	cd 40                	int    $0x40
 237:	c3                   	ret    

00000238 <mknod>:
SYSCALL(mknod)
 238:	b8 11 00 00 00       	mov    $0x11,%eax
 23d:	cd 40                	int    $0x40
 23f:	c3                   	ret    

00000240 <unlink>:
SYSCALL(unlink)
 240:	b8 12 00 00 00       	mov    $0x12,%eax
 245:	cd 40                	int    $0x40
 247:	c3                   	ret    

00000248 <fstat>:
SYSCALL(fstat)
 248:	b8 08 00 00 00       	mov    $0x8,%eax
 24d:	cd 40                	int    $0x40
 24f:	c3                   	ret    

00000250 <link>:
SYSCALL(link)
 250:	b8 13 00 00 00       	mov    $0x13,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <mkdir>:
SYSCALL(mkdir)
 258:	b8 14 00 00 00       	mov    $0x14,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <chdir>:
SYSCALL(chdir)
 260:	b8 09 00 00 00       	mov    $0x9,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <dup>:
SYSCALL(dup)
 268:	b8 0a 00 00 00       	mov    $0xa,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <getpid>:
SYSCALL(getpid)
 270:	b8 0b 00 00 00       	mov    $0xb,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <sbrk>:
SYSCALL(sbrk)
 278:	b8 0c 00 00 00       	mov    $0xc,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <sleep>:
SYSCALL(sleep)
 280:	b8 0d 00 00 00       	mov    $0xd,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <uptime>:
SYSCALL(uptime)
 288:	b8 0e 00 00 00       	mov    $0xe,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <setvariable>:
SYSCALL(setvariable)
 290:	b8 17 00 00 00       	mov    $0x17,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <getvariable>:
SYSCALL(getvariable)
 298:	b8 18 00 00 00       	mov    $0x18,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <remvariable>:
SYSCALL(remvariable)
 2a0:	b8 19 00 00 00       	mov    $0x19,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <wait2>:
SYSCALL(wait2)
 2a8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <set_priority>:
SYSCALL(set_priority)
 2b0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	57                   	push   %edi
 2bc:	56                   	push   %esi
 2bd:	53                   	push   %ebx
 2be:	83 ec 3c             	sub    $0x3c,%esp
 2c1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2c8:	74 12                	je     2dc <printint+0x24>
 2ca:	89 d0                	mov    %edx,%eax
 2cc:	c1 e8 1f             	shr    $0x1f,%eax
 2cf:	84 c0                	test   %al,%al
 2d1:	74 09                	je     2dc <printint+0x24>
    neg = 1;
    x = -xx;
 2d3:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 2d5:	be 01 00 00 00       	mov    $0x1,%esi
 2da:	eb 05                	jmp    2e1 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 2dc:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2e1:	bf 00 00 00 00       	mov    $0x0,%edi
 2e6:	eb 02                	jmp    2ea <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 2e8:	89 df                	mov    %ebx,%edi
 2ea:	8d 5f 01             	lea    0x1(%edi),%ebx
 2ed:	89 d0                	mov    %edx,%eax
 2ef:	ba 00 00 00 00       	mov    $0x0,%edx
 2f4:	f7 f1                	div    %ecx
 2f6:	0f b6 92 60 06 00 00 	movzbl 0x660(%edx),%edx
 2fd:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 301:	89 c2                	mov    %eax,%edx
 303:	85 c0                	test   %eax,%eax
 305:	75 e1                	jne    2e8 <printint+0x30>
  if(neg)
 307:	85 f6                	test   %esi,%esi
 309:	74 08                	je     313 <printint+0x5b>
    buf[i++] = '-';
 30b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 310:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 313:	89 d8                	mov    %ebx,%eax
 315:	83 e8 01             	sub    $0x1,%eax
 318:	78 29                	js     343 <printint+0x8b>
 31a:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 31d:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 321:	8d 7d d7             	lea    -0x29(%ebp),%edi
 324:	0f b6 03             	movzbl (%ebx),%eax
 327:	88 45 d7             	mov    %al,-0x29(%ebp)
 32a:	83 ec 04             	sub    $0x4,%esp
 32d:	6a 01                	push   $0x1
 32f:	57                   	push   %edi
 330:	56                   	push   %esi
 331:	e8 da fe ff ff       	call   210 <write>
 336:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 339:	83 c4 10             	add    $0x10,%esp
 33c:	8d 45 d7             	lea    -0x29(%ebp),%eax
 33f:	39 c3                	cmp    %eax,%ebx
 341:	75 e1                	jne    324 <printint+0x6c>
    putc(fd, buf[i]);
}
 343:	8d 65 f4             	lea    -0xc(%ebp),%esp
 346:	5b                   	pop    %ebx
 347:	5e                   	pop    %esi
 348:	5f                   	pop    %edi
 349:	5d                   	pop    %ebp
 34a:	c3                   	ret    

0000034b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	57                   	push   %edi
 34f:	56                   	push   %esi
 350:	53                   	push   %ebx
 351:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 354:	8b 75 0c             	mov    0xc(%ebp),%esi
 357:	0f b6 1e             	movzbl (%esi),%ebx
 35a:	84 db                	test   %bl,%bl
 35c:	0f 84 a6 01 00 00    	je     508 <printf+0x1bd>
 362:	83 c6 01             	add    $0x1,%esi
 365:	8d 45 10             	lea    0x10(%ebp),%eax
 368:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 36b:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 370:	0f be d3             	movsbl %bl,%edx
 373:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 376:	85 ff                	test   %edi,%edi
 378:	75 25                	jne    39f <printf+0x54>
      if(c == '%'){
 37a:	83 f8 25             	cmp    $0x25,%eax
 37d:	0f 84 6a 01 00 00    	je     4ed <printf+0x1a2>
 383:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 386:	83 ec 04             	sub    $0x4,%esp
 389:	6a 01                	push   $0x1
 38b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 38e:	50                   	push   %eax
 38f:	ff 75 08             	pushl  0x8(%ebp)
 392:	e8 79 fe ff ff       	call   210 <write>
 397:	83 c4 10             	add    $0x10,%esp
 39a:	e9 5a 01 00 00       	jmp    4f9 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 39f:	83 ff 25             	cmp    $0x25,%edi
 3a2:	0f 85 51 01 00 00    	jne    4f9 <printf+0x1ae>
      if(c == 'd'){
 3a8:	83 f8 64             	cmp    $0x64,%eax
 3ab:	75 2c                	jne    3d9 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 3ad:	83 ec 0c             	sub    $0xc,%esp
 3b0:	6a 01                	push   $0x1
 3b2:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3b7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3ba:	8b 17                	mov    (%edi),%edx
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	e8 f4 fe ff ff       	call   2b8 <printint>
        ap++;
 3c4:	89 f8                	mov    %edi,%eax
 3c6:	83 c0 04             	add    $0x4,%eax
 3c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3cc:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3cf:	bf 00 00 00 00       	mov    $0x0,%edi
 3d4:	e9 20 01 00 00       	jmp    4f9 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3d9:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 3df:	83 fa 70             	cmp    $0x70,%edx
 3e2:	75 2c                	jne    410 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 3e4:	83 ec 0c             	sub    $0xc,%esp
 3e7:	6a 00                	push   $0x0
 3e9:	b9 10 00 00 00       	mov    $0x10,%ecx
 3ee:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3f1:	8b 17                	mov    (%edi),%edx
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	e8 bd fe ff ff       	call   2b8 <printint>
        ap++;
 3fb:	89 f8                	mov    %edi,%eax
 3fd:	83 c0 04             	add    $0x4,%eax
 400:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 403:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 406:	bf 00 00 00 00       	mov    $0x0,%edi
 40b:	e9 e9 00 00 00       	jmp    4f9 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 410:	83 f8 73             	cmp    $0x73,%eax
 413:	75 52                	jne    467 <printf+0x11c>
        s = (char*)*ap;
 415:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 418:	8b 18                	mov    (%eax),%ebx
        ap++;
 41a:	83 c0 04             	add    $0x4,%eax
 41d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 420:	85 db                	test   %ebx,%ebx
          s = "(null)";
 422:	b8 58 06 00 00       	mov    $0x658,%eax
 427:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 42a:	0f b6 03             	movzbl (%ebx),%eax
 42d:	84 c0                	test   %al,%al
 42f:	0f 84 bf 00 00 00    	je     4f4 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 435:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 438:	89 75 d0             	mov    %esi,-0x30(%ebp)
 43b:	8b 75 08             	mov    0x8(%ebp),%esi
 43e:	88 45 e3             	mov    %al,-0x1d(%ebp)
 441:	83 ec 04             	sub    $0x4,%esp
 444:	6a 01                	push   $0x1
 446:	57                   	push   %edi
 447:	56                   	push   %esi
 448:	e8 c3 fd ff ff       	call   210 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 44d:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 450:	0f b6 03             	movzbl (%ebx),%eax
 453:	83 c4 10             	add    $0x10,%esp
 456:	84 c0                	test   %al,%al
 458:	75 e4                	jne    43e <printf+0xf3>
 45a:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 45d:	bf 00 00 00 00       	mov    $0x0,%edi
 462:	e9 92 00 00 00       	jmp    4f9 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 467:	83 f8 63             	cmp    $0x63,%eax
 46a:	75 2b                	jne    497 <printf+0x14c>
 46c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 46f:	8b 07                	mov    (%edi),%eax
 471:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 474:	83 ec 04             	sub    $0x4,%esp
 477:	6a 01                	push   $0x1
 479:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 47c:	50                   	push   %eax
 47d:	ff 75 08             	pushl  0x8(%ebp)
 480:	e8 8b fd ff ff       	call   210 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 485:	89 f8                	mov    %edi,%eax
 487:	83 c0 04             	add    $0x4,%eax
 48a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 48d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 490:	bf 00 00 00 00       	mov    $0x0,%edi
 495:	eb 62                	jmp    4f9 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 497:	83 f8 25             	cmp    $0x25,%eax
 49a:	75 1e                	jne    4ba <printf+0x16f>
 49c:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 49f:	83 ec 04             	sub    $0x4,%esp
 4a2:	6a 01                	push   $0x1
 4a4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4a7:	50                   	push   %eax
 4a8:	ff 75 08             	pushl  0x8(%ebp)
 4ab:	e8 60 fd ff ff       	call   210 <write>
 4b0:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b3:	bf 00 00 00 00       	mov    $0x0,%edi
 4b8:	eb 3f                	jmp    4f9 <printf+0x1ae>
 4ba:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4be:	83 ec 04             	sub    $0x4,%esp
 4c1:	6a 01                	push   $0x1
 4c3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4c6:	50                   	push   %eax
 4c7:	ff 75 08             	pushl  0x8(%ebp)
 4ca:	e8 41 fd ff ff       	call   210 <write>
 4cf:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4d2:	83 c4 0c             	add    $0xc,%esp
 4d5:	6a 01                	push   $0x1
 4d7:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 2d fd ff ff       	call   210 <write>
 4e3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e6:	bf 00 00 00 00       	mov    $0x0,%edi
 4eb:	eb 0c                	jmp    4f9 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4ed:	bf 25 00 00 00       	mov    $0x25,%edi
 4f2:	eb 05                	jmp    4f9 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f4:	bf 00 00 00 00       	mov    $0x0,%edi
 4f9:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4fc:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 500:	84 db                	test   %bl,%bl
 502:	0f 85 68 fe ff ff    	jne    370 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 508:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50b:	5b                   	pop    %ebx
 50c:	5e                   	pop    %esi
 50d:	5f                   	pop    %edi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    

00000510 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	57                   	push   %edi
 514:	56                   	push   %esi
 515:	53                   	push   %ebx
 516:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 519:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 51c:	a1 b0 08 00 00       	mov    0x8b0,%eax
 521:	eb 0c                	jmp    52f <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 523:	8b 10                	mov    (%eax),%edx
 525:	39 d0                	cmp    %edx,%eax
 527:	72 04                	jb     52d <free+0x1d>
 529:	39 d1                	cmp    %edx,%ecx
 52b:	72 0c                	jb     539 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 52d:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 52f:	39 c8                	cmp    %ecx,%eax
 531:	73 f0                	jae    523 <free+0x13>
 533:	8b 10                	mov    (%eax),%edx
 535:	39 d1                	cmp    %edx,%ecx
 537:	73 3e                	jae    577 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 539:	8b 73 fc             	mov    -0x4(%ebx),%esi
 53c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 53f:	8b 10                	mov    (%eax),%edx
 541:	39 d7                	cmp    %edx,%edi
 543:	75 0f                	jne    554 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 545:	03 77 04             	add    0x4(%edi),%esi
 548:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 54b:	8b 10                	mov    (%eax),%edx
 54d:	8b 12                	mov    (%edx),%edx
 54f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 552:	eb 03                	jmp    557 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 554:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 557:	8b 50 04             	mov    0x4(%eax),%edx
 55a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 55d:	39 f1                	cmp    %esi,%ecx
 55f:	75 0d                	jne    56e <free+0x5e>
    p->s.size += bp->s.size;
 561:	03 53 fc             	add    -0x4(%ebx),%edx
 564:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 567:	8b 53 f8             	mov    -0x8(%ebx),%edx
 56a:	89 10                	mov    %edx,(%eax)
 56c:	eb 02                	jmp    570 <free+0x60>
  } else
    p->s.ptr = bp;
 56e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 570:	a3 b0 08 00 00       	mov    %eax,0x8b0
}
 575:	eb 06                	jmp    57d <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 577:	39 d0                	cmp    %edx,%eax
 579:	72 b2                	jb     52d <free+0x1d>
 57b:	eb bc                	jmp    539 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 57d:	5b                   	pop    %ebx
 57e:	5e                   	pop    %esi
 57f:	5f                   	pop    %edi
 580:	5d                   	pop    %ebp
 581:	c3                   	ret    

00000582 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	57                   	push   %edi
 586:	56                   	push   %esi
 587:	53                   	push   %ebx
 588:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	8d 58 07             	lea    0x7(%eax),%ebx
 591:	c1 eb 03             	shr    $0x3,%ebx
 594:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 597:	8b 15 b0 08 00 00    	mov    0x8b0,%edx
 59d:	85 d2                	test   %edx,%edx
 59f:	75 23                	jne    5c4 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 5a1:	c7 05 b0 08 00 00 b4 	movl   $0x8b4,0x8b0
 5a8:	08 00 00 
 5ab:	c7 05 b4 08 00 00 b4 	movl   $0x8b4,0x8b4
 5b2:	08 00 00 
    base.s.size = 0;
 5b5:	c7 05 b8 08 00 00 00 	movl   $0x0,0x8b8
 5bc:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 5bf:	ba b4 08 00 00       	mov    $0x8b4,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5c4:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5c6:	8b 48 04             	mov    0x4(%eax),%ecx
 5c9:	39 cb                	cmp    %ecx,%ebx
 5cb:	77 20                	ja     5ed <malloc+0x6b>
      if(p->s.size == nunits)
 5cd:	39 cb                	cmp    %ecx,%ebx
 5cf:	75 06                	jne    5d7 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 5d1:	8b 08                	mov    (%eax),%ecx
 5d3:	89 0a                	mov    %ecx,(%edx)
 5d5:	eb 0b                	jmp    5e2 <malloc+0x60>
      else {
        p->s.size -= nunits;
 5d7:	29 d9                	sub    %ebx,%ecx
 5d9:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 5dc:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 5df:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e2:	89 15 b0 08 00 00    	mov    %edx,0x8b0
      return (void*)(p + 1);
 5e8:	83 c0 08             	add    $0x8,%eax
 5eb:	eb 63                	jmp    650 <malloc+0xce>
 5ed:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 5f3:	be 00 10 00 00       	mov    $0x1000,%esi
 5f8:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 5fb:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 602:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 604:	39 05 b0 08 00 00    	cmp    %eax,0x8b0
 60a:	75 2d                	jne    639 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 60c:	83 ec 0c             	sub    $0xc,%esp
 60f:	57                   	push   %edi
 610:	e8 63 fc ff ff       	call   278 <sbrk>
  if(p == (char*)-1)
 615:	83 c4 10             	add    $0x10,%esp
 618:	83 f8 ff             	cmp    $0xffffffff,%eax
 61b:	74 27                	je     644 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 61d:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 620:	83 ec 0c             	sub    $0xc,%esp
 623:	83 c0 08             	add    $0x8,%eax
 626:	50                   	push   %eax
 627:	e8 e4 fe ff ff       	call   510 <free>
  return freep;
 62c:	8b 15 b0 08 00 00    	mov    0x8b0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 632:	83 c4 10             	add    $0x10,%esp
 635:	85 d2                	test   %edx,%edx
 637:	74 12                	je     64b <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 639:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 63b:	8b 48 04             	mov    0x4(%eax),%ecx
 63e:	39 cb                	cmp    %ecx,%ebx
 640:	77 c0                	ja     602 <malloc+0x80>
 642:	eb 89                	jmp    5cd <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 644:	b8 00 00 00 00       	mov    $0x0,%eax
 649:	eb 05                	jmp    650 <malloc+0xce>
 64b:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 650:	8d 65 f4             	lea    -0xc(%ebp),%esp
 653:	5b                   	pop    %ebx
 654:	5e                   	pop    %esi
 655:	5f                   	pop    %edi
 656:	5d                   	pop    %ebp
 657:	c3                   	ret    
