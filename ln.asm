
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 88 06 00 00       	push   $0x688
  1f:	6a 02                	push   $0x2
  21:	e8 53 03 00 00       	call   379 <printf>
    exit();
  26:	e8 f3 01 00 00       	call   21e <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	pushl  0x8(%ebx)
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 45 02 00 00       	call   27e <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	79 15                	jns    55 <main+0x55>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  40:	ff 73 08             	pushl  0x8(%ebx)
  43:	ff 73 04             	pushl  0x4(%ebx)
  46:	68 9b 06 00 00       	push   $0x69b
  4b:	6a 02                	push   $0x2
  4d:	e8 27 03 00 00       	call   379 <printf>
  52:	83 c4 10             	add    $0x10,%esp
  exit();
  55:	e8 c4 01 00 00       	call   21e <exit>

0000005a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5a:	55                   	push   %ebp
  5b:	89 e5                	mov    %esp,%ebp
  5d:	53                   	push   %ebx
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	89 c2                	mov    %eax,%edx
  66:	83 c2 01             	add    $0x1,%edx
  69:	83 c1 01             	add    $0x1,%ecx
  6c:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  70:	88 5a ff             	mov    %bl,-0x1(%edx)
  73:	84 db                	test   %bl,%bl
  75:	75 ef                	jne    66 <strcpy+0xc>
    ;
  return os;
}
  77:	5b                   	pop    %ebx
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    

0000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  83:	0f b6 01             	movzbl (%ecx),%eax
  86:	84 c0                	test   %al,%al
  88:	74 15                	je     9f <strcmp+0x25>
  8a:	3a 02                	cmp    (%edx),%al
  8c:	75 11                	jne    9f <strcmp+0x25>
    p++, q++;
  8e:	83 c1 01             	add    $0x1,%ecx
  91:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  94:	0f b6 01             	movzbl (%ecx),%eax
  97:	84 c0                	test   %al,%al
  99:	74 04                	je     9f <strcmp+0x25>
  9b:	3a 02                	cmp    (%edx),%al
  9d:	74 ef                	je     8e <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9f:	0f b6 c0             	movzbl %al,%eax
  a2:	0f b6 12             	movzbl (%edx),%edx
  a5:	29 d0                	sub    %edx,%eax
}
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strlen>:

uint
strlen(char *s)
{
  a9:	55                   	push   %ebp
  aa:	89 e5                	mov    %esp,%ebp
  ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  af:	80 39 00             	cmpb   $0x0,(%ecx)
  b2:	74 12                	je     c6 <strlen+0x1d>
  b4:	ba 00 00 00 00       	mov    $0x0,%edx
  b9:	83 c2 01             	add    $0x1,%edx
  bc:	89 d0                	mov    %edx,%eax
  be:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c2:	75 f5                	jne    b9 <strlen+0x10>
  c4:	eb 05                	jmp    cb <strlen+0x22>
  c6:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    

000000cd <memset>:

void*
memset(void *dst, int c, uint n)
{
  cd:	55                   	push   %ebp
  ce:	89 e5                	mov    %esp,%ebp
  d0:	57                   	push   %edi
  d1:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d4:	89 d7                	mov    %edx,%edi
  d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  dc:	fc                   	cld    
  dd:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  df:	89 d0                	mov    %edx,%eax
  e1:	5f                   	pop    %edi
  e2:	5d                   	pop    %ebp
  e3:	c3                   	ret    

000000e4 <strchr>:

char*
strchr(const char *s, char c)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	53                   	push   %ebx
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	84 d2                	test   %dl,%dl
  f3:	74 1d                	je     112 <strchr+0x2e>
  f5:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  f7:	38 d3                	cmp    %dl,%bl
  f9:	75 06                	jne    101 <strchr+0x1d>
  fb:	eb 1a                	jmp    117 <strchr+0x33>
  fd:	38 ca                	cmp    %cl,%dl
  ff:	74 16                	je     117 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 101:	83 c0 01             	add    $0x1,%eax
 104:	0f b6 10             	movzbl (%eax),%edx
 107:	84 d2                	test   %dl,%dl
 109:	75 f2                	jne    fd <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 10b:	b8 00 00 00 00       	mov    $0x0,%eax
 110:	eb 05                	jmp    117 <strchr+0x33>
 112:	b8 00 00 00 00       	mov    $0x0,%eax
}
 117:	5b                   	pop    %ebx
 118:	5d                   	pop    %ebp
 119:	c3                   	ret    

0000011a <gets>:

char*
gets(char *buf, int max)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	57                   	push   %edi
 11e:	56                   	push   %esi
 11f:	53                   	push   %ebx
 120:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 123:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 128:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12b:	eb 29                	jmp    156 <gets+0x3c>
    cc = read(0, &c, 1);
 12d:	83 ec 04             	sub    $0x4,%esp
 130:	6a 01                	push   $0x1
 132:	57                   	push   %edi
 133:	6a 00                	push   $0x0
 135:	e8 fc 00 00 00       	call   236 <read>
    if(cc < 1)
 13a:	83 c4 10             	add    $0x10,%esp
 13d:	85 c0                	test   %eax,%eax
 13f:	7e 21                	jle    162 <gets+0x48>
      break;
    buf[i++] = c;
 141:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 145:	8b 55 08             	mov    0x8(%ebp),%edx
 148:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14c:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	3c 0a                	cmp    $0xa,%al
 150:	74 0e                	je     160 <gets+0x46>
 152:	3c 0d                	cmp    $0xd,%al
 154:	74 0a                	je     160 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	8d 5e 01             	lea    0x1(%esi),%ebx
 159:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15c:	7c cf                	jl     12d <gets+0x13>
 15e:	eb 02                	jmp    162 <gets+0x48>
 160:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 169:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16c:	5b                   	pop    %ebx
 16d:	5e                   	pop    %esi
 16e:	5f                   	pop    %edi
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    

00000171 <stat>:

int
stat(char *n, struct stat *st)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 176:	83 ec 08             	sub    $0x8,%esp
 179:	6a 00                	push   $0x0
 17b:	ff 75 08             	pushl  0x8(%ebp)
 17e:	e8 db 00 00 00       	call   25e <open>
  if(fd < 0)
 183:	83 c4 10             	add    $0x10,%esp
 186:	85 c0                	test   %eax,%eax
 188:	78 1f                	js     1a9 <stat+0x38>
 18a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	ff 75 0c             	pushl  0xc(%ebp)
 192:	50                   	push   %eax
 193:	e8 de 00 00 00       	call   276 <fstat>
 198:	89 c6                	mov    %eax,%esi
  close(fd);
 19a:	89 1c 24             	mov    %ebx,(%esp)
 19d:	e8 a4 00 00 00       	call   246 <close>
  return r;
 1a2:	83 c4 10             	add    $0x10,%esp
 1a5:	89 f0                	mov    %esi,%eax
 1a7:	eb 05                	jmp    1ae <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 1ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b1:	5b                   	pop    %ebx
 1b2:	5e                   	pop    %esi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    

000001b5 <atoi>:

int
atoi(const char *s)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	53                   	push   %ebx
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bc:	0f b6 11             	movzbl (%ecx),%edx
 1bf:	8d 42 d0             	lea    -0x30(%edx),%eax
 1c2:	3c 09                	cmp    $0x9,%al
 1c4:	77 1f                	ja     1e5 <atoi+0x30>
 1c6:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1cb:	83 c1 01             	add    $0x1,%ecx
 1ce:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1d1:	0f be d2             	movsbl %dl,%edx
 1d4:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	0f b6 11             	movzbl (%ecx),%edx
 1db:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1de:	80 fb 09             	cmp    $0x9,%bl
 1e1:	76 e8                	jbe    1cb <atoi+0x16>
 1e3:	eb 05                	jmp    1ea <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 1e5:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 1ea:	5b                   	pop    %ebx
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    

000001ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	56                   	push   %esi
 1f1:	53                   	push   %ebx
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	8b 75 0c             	mov    0xc(%ebp),%esi
 1f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1fb:	85 db                	test   %ebx,%ebx
 1fd:	7e 13                	jle    212 <memmove+0x25>
 1ff:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 204:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 208:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 20b:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 20e:	39 da                	cmp    %ebx,%edx
 210:	75 f2                	jne    204 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 212:	5b                   	pop    %ebx
 213:	5e                   	pop    %esi
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    

00000216 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	cd 40                	int    $0x40
 21d:	c3                   	ret    

0000021e <exit>:
SYSCALL(exit)
 21e:	b8 02 00 00 00       	mov    $0x2,%eax
 223:	cd 40                	int    $0x40
 225:	c3                   	ret    

00000226 <wait>:
SYSCALL(wait)
 226:	b8 03 00 00 00       	mov    $0x3,%eax
 22b:	cd 40                	int    $0x40
 22d:	c3                   	ret    

0000022e <pipe>:
SYSCALL(pipe)
 22e:	b8 04 00 00 00       	mov    $0x4,%eax
 233:	cd 40                	int    $0x40
 235:	c3                   	ret    

00000236 <read>:
SYSCALL(read)
 236:	b8 05 00 00 00       	mov    $0x5,%eax
 23b:	cd 40                	int    $0x40
 23d:	c3                   	ret    

0000023e <write>:
SYSCALL(write)
 23e:	b8 10 00 00 00       	mov    $0x10,%eax
 243:	cd 40                	int    $0x40
 245:	c3                   	ret    

00000246 <close>:
SYSCALL(close)
 246:	b8 15 00 00 00       	mov    $0x15,%eax
 24b:	cd 40                	int    $0x40
 24d:	c3                   	ret    

0000024e <kill>:
SYSCALL(kill)
 24e:	b8 06 00 00 00       	mov    $0x6,%eax
 253:	cd 40                	int    $0x40
 255:	c3                   	ret    

00000256 <exec>:
SYSCALL(exec)
 256:	b8 07 00 00 00       	mov    $0x7,%eax
 25b:	cd 40                	int    $0x40
 25d:	c3                   	ret    

0000025e <open>:
SYSCALL(open)
 25e:	b8 0f 00 00 00       	mov    $0xf,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <mknod>:
SYSCALL(mknod)
 266:	b8 11 00 00 00       	mov    $0x11,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <unlink>:
SYSCALL(unlink)
 26e:	b8 12 00 00 00       	mov    $0x12,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <fstat>:
SYSCALL(fstat)
 276:	b8 08 00 00 00       	mov    $0x8,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <link>:
SYSCALL(link)
 27e:	b8 13 00 00 00       	mov    $0x13,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <mkdir>:
SYSCALL(mkdir)
 286:	b8 14 00 00 00       	mov    $0x14,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <chdir>:
SYSCALL(chdir)
 28e:	b8 09 00 00 00       	mov    $0x9,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <dup>:
SYSCALL(dup)
 296:	b8 0a 00 00 00       	mov    $0xa,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <getpid>:
SYSCALL(getpid)
 29e:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <sbrk>:
SYSCALL(sbrk)
 2a6:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <sleep>:
SYSCALL(sleep)
 2ae:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <uptime>:
SYSCALL(uptime)
 2b6:	b8 0e 00 00 00       	mov    $0xe,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <setvariable>:
SYSCALL(setvariable)
 2be:	b8 17 00 00 00       	mov    $0x17,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <getvariable>:
SYSCALL(getvariable)
 2c6:	b8 18 00 00 00       	mov    $0x18,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <remvariable>:
SYSCALL(remvariable)
 2ce:	b8 19 00 00 00       	mov    $0x19,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <wait2>:
SYSCALL(wait2)
 2d6:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <set_priority>:
SYSCALL(set_priority)
 2de:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	57                   	push   %edi
 2ea:	56                   	push   %esi
 2eb:	53                   	push   %ebx
 2ec:	83 ec 3c             	sub    $0x3c,%esp
 2ef:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f6:	74 12                	je     30a <printint+0x24>
 2f8:	89 d0                	mov    %edx,%eax
 2fa:	c1 e8 1f             	shr    $0x1f,%eax
 2fd:	84 c0                	test   %al,%al
 2ff:	74 09                	je     30a <printint+0x24>
    neg = 1;
    x = -xx;
 301:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 303:	be 01 00 00 00       	mov    $0x1,%esi
 308:	eb 05                	jmp    30f <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 30a:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 30f:	bf 00 00 00 00       	mov    $0x0,%edi
 314:	eb 02                	jmp    318 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 316:	89 df                	mov    %ebx,%edi
 318:	8d 5f 01             	lea    0x1(%edi),%ebx
 31b:	89 d0                	mov    %edx,%eax
 31d:	ba 00 00 00 00       	mov    $0x0,%edx
 322:	f7 f1                	div    %ecx
 324:	0f b6 92 b8 06 00 00 	movzbl 0x6b8(%edx),%edx
 32b:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 32f:	89 c2                	mov    %eax,%edx
 331:	85 c0                	test   %eax,%eax
 333:	75 e1                	jne    316 <printint+0x30>
  if(neg)
 335:	85 f6                	test   %esi,%esi
 337:	74 08                	je     341 <printint+0x5b>
    buf[i++] = '-';
 339:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33e:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 341:	89 d8                	mov    %ebx,%eax
 343:	83 e8 01             	sub    $0x1,%eax
 346:	78 29                	js     371 <printint+0x8b>
 348:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 34b:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 34f:	8d 7d d7             	lea    -0x29(%ebp),%edi
 352:	0f b6 03             	movzbl (%ebx),%eax
 355:	88 45 d7             	mov    %al,-0x29(%ebp)
 358:	83 ec 04             	sub    $0x4,%esp
 35b:	6a 01                	push   $0x1
 35d:	57                   	push   %edi
 35e:	56                   	push   %esi
 35f:	e8 da fe ff ff       	call   23e <write>
 364:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 367:	83 c4 10             	add    $0x10,%esp
 36a:	8d 45 d7             	lea    -0x29(%ebp),%eax
 36d:	39 c3                	cmp    %eax,%ebx
 36f:	75 e1                	jne    352 <printint+0x6c>
    putc(fd, buf[i]);
}
 371:	8d 65 f4             	lea    -0xc(%ebp),%esp
 374:	5b                   	pop    %ebx
 375:	5e                   	pop    %esi
 376:	5f                   	pop    %edi
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	57                   	push   %edi
 37d:	56                   	push   %esi
 37e:	53                   	push   %ebx
 37f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 382:	8b 75 0c             	mov    0xc(%ebp),%esi
 385:	0f b6 1e             	movzbl (%esi),%ebx
 388:	84 db                	test   %bl,%bl
 38a:	0f 84 a6 01 00 00    	je     536 <printf+0x1bd>
 390:	83 c6 01             	add    $0x1,%esi
 393:	8d 45 10             	lea    0x10(%ebp),%eax
 396:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 399:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 39e:	0f be d3             	movsbl %bl,%edx
 3a1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3a4:	85 ff                	test   %edi,%edi
 3a6:	75 25                	jne    3cd <printf+0x54>
      if(c == '%'){
 3a8:	83 f8 25             	cmp    $0x25,%eax
 3ab:	0f 84 6a 01 00 00    	je     51b <printf+0x1a2>
 3b1:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3b4:	83 ec 04             	sub    $0x4,%esp
 3b7:	6a 01                	push   $0x1
 3b9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3bc:	50                   	push   %eax
 3bd:	ff 75 08             	pushl  0x8(%ebp)
 3c0:	e8 79 fe ff ff       	call   23e <write>
 3c5:	83 c4 10             	add    $0x10,%esp
 3c8:	e9 5a 01 00 00       	jmp    527 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3cd:	83 ff 25             	cmp    $0x25,%edi
 3d0:	0f 85 51 01 00 00    	jne    527 <printf+0x1ae>
      if(c == 'd'){
 3d6:	83 f8 64             	cmp    $0x64,%eax
 3d9:	75 2c                	jne    407 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 3db:	83 ec 0c             	sub    $0xc,%esp
 3de:	6a 01                	push   $0x1
 3e0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3e8:	8b 17                	mov    (%edi),%edx
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	e8 f4 fe ff ff       	call   2e6 <printint>
        ap++;
 3f2:	89 f8                	mov    %edi,%eax
 3f4:	83 c0 04             	add    $0x4,%eax
 3f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3fa:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3fd:	bf 00 00 00 00       	mov    $0x0,%edi
 402:	e9 20 01 00 00       	jmp    527 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 407:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 40d:	83 fa 70             	cmp    $0x70,%edx
 410:	75 2c                	jne    43e <printf+0xc5>
        printint(fd, *ap, 16, 0);
 412:	83 ec 0c             	sub    $0xc,%esp
 415:	6a 00                	push   $0x0
 417:	b9 10 00 00 00       	mov    $0x10,%ecx
 41c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 41f:	8b 17                	mov    (%edi),%edx
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	e8 bd fe ff ff       	call   2e6 <printint>
        ap++;
 429:	89 f8                	mov    %edi,%eax
 42b:	83 c0 04             	add    $0x4,%eax
 42e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 431:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 434:	bf 00 00 00 00       	mov    $0x0,%edi
 439:	e9 e9 00 00 00       	jmp    527 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43e:	83 f8 73             	cmp    $0x73,%eax
 441:	75 52                	jne    495 <printf+0x11c>
        s = (char*)*ap;
 443:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 446:	8b 18                	mov    (%eax),%ebx
        ap++;
 448:	83 c0 04             	add    $0x4,%eax
 44b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 44e:	85 db                	test   %ebx,%ebx
          s = "(null)";
 450:	b8 af 06 00 00       	mov    $0x6af,%eax
 455:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 458:	0f b6 03             	movzbl (%ebx),%eax
 45b:	84 c0                	test   %al,%al
 45d:	0f 84 bf 00 00 00    	je     522 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 463:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 466:	89 75 d0             	mov    %esi,-0x30(%ebp)
 469:	8b 75 08             	mov    0x8(%ebp),%esi
 46c:	88 45 e3             	mov    %al,-0x1d(%ebp)
 46f:	83 ec 04             	sub    $0x4,%esp
 472:	6a 01                	push   $0x1
 474:	57                   	push   %edi
 475:	56                   	push   %esi
 476:	e8 c3 fd ff ff       	call   23e <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 47b:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 47e:	0f b6 03             	movzbl (%ebx),%eax
 481:	83 c4 10             	add    $0x10,%esp
 484:	84 c0                	test   %al,%al
 486:	75 e4                	jne    46c <printf+0xf3>
 488:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 48b:	bf 00 00 00 00       	mov    $0x0,%edi
 490:	e9 92 00 00 00       	jmp    527 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 495:	83 f8 63             	cmp    $0x63,%eax
 498:	75 2b                	jne    4c5 <printf+0x14c>
 49a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 49d:	8b 07                	mov    (%edi),%eax
 49f:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a2:	83 ec 04             	sub    $0x4,%esp
 4a5:	6a 01                	push   $0x1
 4a7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4aa:	50                   	push   %eax
 4ab:	ff 75 08             	pushl  0x8(%ebp)
 4ae:	e8 8b fd ff ff       	call   23e <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 4b3:	89 f8                	mov    %edi,%eax
 4b5:	83 c0 04             	add    $0x4,%eax
 4b8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4bb:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4be:	bf 00 00 00 00       	mov    $0x0,%edi
 4c3:	eb 62                	jmp    527 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c5:	83 f8 25             	cmp    $0x25,%eax
 4c8:	75 1e                	jne    4e8 <printf+0x16f>
 4ca:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4cd:	83 ec 04             	sub    $0x4,%esp
 4d0:	6a 01                	push   $0x1
 4d2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4d5:	50                   	push   %eax
 4d6:	ff 75 08             	pushl  0x8(%ebp)
 4d9:	e8 60 fd ff ff       	call   23e <write>
 4de:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e1:	bf 00 00 00 00       	mov    $0x0,%edi
 4e6:	eb 3f                	jmp    527 <printf+0x1ae>
 4e8:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ec:	83 ec 04             	sub    $0x4,%esp
 4ef:	6a 01                	push   $0x1
 4f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f4:	50                   	push   %eax
 4f5:	ff 75 08             	pushl  0x8(%ebp)
 4f8:	e8 41 fd ff ff       	call   23e <write>
 4fd:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 500:	83 c4 0c             	add    $0xc,%esp
 503:	6a 01                	push   $0x1
 505:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 508:	50                   	push   %eax
 509:	ff 75 08             	pushl  0x8(%ebp)
 50c:	e8 2d fd ff ff       	call   23e <write>
 511:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 514:	bf 00 00 00 00       	mov    $0x0,%edi
 519:	eb 0c                	jmp    527 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 51b:	bf 25 00 00 00       	mov    $0x25,%edi
 520:	eb 05                	jmp    527 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 522:	bf 00 00 00 00       	mov    $0x0,%edi
 527:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 52a:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 52e:	84 db                	test   %bl,%bl
 530:	0f 85 68 fe ff ff    	jne    39e <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 536:	8d 65 f4             	lea    -0xc(%ebp),%esp
 539:	5b                   	pop    %ebx
 53a:	5e                   	pop    %esi
 53b:	5f                   	pop    %edi
 53c:	5d                   	pop    %ebp
 53d:	c3                   	ret    

0000053e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	57                   	push   %edi
 542:	56                   	push   %esi
 543:	53                   	push   %ebx
 544:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 547:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 54a:	a1 0c 09 00 00       	mov    0x90c,%eax
 54f:	eb 0c                	jmp    55d <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 551:	8b 10                	mov    (%eax),%edx
 553:	39 d0                	cmp    %edx,%eax
 555:	72 04                	jb     55b <free+0x1d>
 557:	39 d1                	cmp    %edx,%ecx
 559:	72 0c                	jb     567 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 55b:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55d:	39 c8                	cmp    %ecx,%eax
 55f:	73 f0                	jae    551 <free+0x13>
 561:	8b 10                	mov    (%eax),%edx
 563:	39 d1                	cmp    %edx,%ecx
 565:	73 3e                	jae    5a5 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 567:	8b 73 fc             	mov    -0x4(%ebx),%esi
 56a:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56d:	8b 10                	mov    (%eax),%edx
 56f:	39 d7                	cmp    %edx,%edi
 571:	75 0f                	jne    582 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 573:	03 77 04             	add    0x4(%edi),%esi
 576:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 579:	8b 10                	mov    (%eax),%edx
 57b:	8b 12                	mov    (%edx),%edx
 57d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 580:	eb 03                	jmp    585 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 582:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 585:	8b 50 04             	mov    0x4(%eax),%edx
 588:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58b:	39 f1                	cmp    %esi,%ecx
 58d:	75 0d                	jne    59c <free+0x5e>
    p->s.size += bp->s.size;
 58f:	03 53 fc             	add    -0x4(%ebx),%edx
 592:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 595:	8b 53 f8             	mov    -0x8(%ebx),%edx
 598:	89 10                	mov    %edx,(%eax)
 59a:	eb 02                	jmp    59e <free+0x60>
  } else
    p->s.ptr = bp;
 59c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 59e:	a3 0c 09 00 00       	mov    %eax,0x90c
}
 5a3:	eb 06                	jmp    5ab <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a5:	39 d0                	cmp    %edx,%eax
 5a7:	72 b2                	jb     55b <free+0x1d>
 5a9:	eb bc                	jmp    567 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 5ab:	5b                   	pop    %ebx
 5ac:	5e                   	pop    %esi
 5ad:	5f                   	pop    %edi
 5ae:	5d                   	pop    %ebp
 5af:	c3                   	ret    

000005b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	8d 58 07             	lea    0x7(%eax),%ebx
 5bf:	c1 eb 03             	shr    $0x3,%ebx
 5c2:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c5:	8b 15 0c 09 00 00    	mov    0x90c,%edx
 5cb:	85 d2                	test   %edx,%edx
 5cd:	75 23                	jne    5f2 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 5cf:	c7 05 0c 09 00 00 10 	movl   $0x910,0x90c
 5d6:	09 00 00 
 5d9:	c7 05 10 09 00 00 10 	movl   $0x910,0x910
 5e0:	09 00 00 
    base.s.size = 0;
 5e3:	c7 05 14 09 00 00 00 	movl   $0x0,0x914
 5ea:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 5ed:	ba 10 09 00 00       	mov    $0x910,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5f4:	8b 48 04             	mov    0x4(%eax),%ecx
 5f7:	39 cb                	cmp    %ecx,%ebx
 5f9:	77 20                	ja     61b <malloc+0x6b>
      if(p->s.size == nunits)
 5fb:	39 cb                	cmp    %ecx,%ebx
 5fd:	75 06                	jne    605 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 5ff:	8b 08                	mov    (%eax),%ecx
 601:	89 0a                	mov    %ecx,(%edx)
 603:	eb 0b                	jmp    610 <malloc+0x60>
      else {
        p->s.size -= nunits;
 605:	29 d9                	sub    %ebx,%ecx
 607:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 60a:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 60d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 610:	89 15 0c 09 00 00    	mov    %edx,0x90c
      return (void*)(p + 1);
 616:	83 c0 08             	add    $0x8,%eax
 619:	eb 63                	jmp    67e <malloc+0xce>
 61b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 621:	be 00 10 00 00       	mov    $0x1000,%esi
 626:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 629:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 630:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 632:	39 05 0c 09 00 00    	cmp    %eax,0x90c
 638:	75 2d                	jne    667 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 63a:	83 ec 0c             	sub    $0xc,%esp
 63d:	57                   	push   %edi
 63e:	e8 63 fc ff ff       	call   2a6 <sbrk>
  if(p == (char*)-1)
 643:	83 c4 10             	add    $0x10,%esp
 646:	83 f8 ff             	cmp    $0xffffffff,%eax
 649:	74 27                	je     672 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 64b:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 64e:	83 ec 0c             	sub    $0xc,%esp
 651:	83 c0 08             	add    $0x8,%eax
 654:	50                   	push   %eax
 655:	e8 e4 fe ff ff       	call   53e <free>
  return freep;
 65a:	8b 15 0c 09 00 00    	mov    0x90c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 660:	83 c4 10             	add    $0x10,%esp
 663:	85 d2                	test   %edx,%edx
 665:	74 12                	je     679 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 667:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 669:	8b 48 04             	mov    0x4(%eax),%ecx
 66c:	39 cb                	cmp    %ecx,%ebx
 66e:	77 c0                	ja     630 <malloc+0x80>
 670:	eb 89                	jmp    5fb <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 672:	b8 00 00 00 00       	mov    $0x0,%eax
 677:	eb 05                	jmp    67e <malloc+0xce>
 679:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 67e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 681:	5b                   	pop    %ebx
 682:	5e                   	pop    %esi
 683:	5f                   	pop    %edi
 684:	5d                   	pop    %ebp
 685:	c3                   	ret    
