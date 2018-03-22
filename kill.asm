
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  19:	bb 01 00 00 00       	mov    $0x1,%ebx
  int i;

  if(argc < 2){
  1e:	83 fe 01             	cmp    $0x1,%esi
  21:	7f 14                	jg     37 <main+0x37>
    printf(2, "usage: kill pid...\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 88 06 00 00       	push   $0x688
  2b:	6a 02                	push   $0x2
  2d:	e8 46 03 00 00       	call   378 <printf>
    exit();
  32:	e8 e6 01 00 00       	call   21d <exit>
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  37:	83 ec 0c             	sub    $0xc,%esp
  3a:	ff 34 9f             	pushl  (%edi,%ebx,4)
  3d:	e8 72 01 00 00       	call   1b4 <atoi>
  42:	89 04 24             	mov    %eax,(%esp)
  45:	e8 03 02 00 00       	call   24d <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  4a:	83 c3 01             	add    $0x1,%ebx
  4d:	83 c4 10             	add    $0x10,%esp
  50:	39 de                	cmp    %ebx,%esi
  52:	75 e3                	jne    37 <main+0x37>
    kill(atoi(argv[i]));
  exit();
  54:	e8 c4 01 00 00       	call   21d <exit>

00000059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	53                   	push   %ebx
  5d:	8b 45 08             	mov    0x8(%ebp),%eax
  60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  63:	89 c2                	mov    %eax,%edx
  65:	83 c2 01             	add    $0x1,%edx
  68:	83 c1 01             	add    $0x1,%ecx
  6b:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  6f:	88 5a ff             	mov    %bl,-0x1(%edx)
  72:	84 db                	test   %bl,%bl
  74:	75 ef                	jne    65 <strcpy+0xc>
    ;
  return os;
}
  76:	5b                   	pop    %ebx
  77:	5d                   	pop    %ebp
  78:	c3                   	ret    

00000079 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  82:	0f b6 01             	movzbl (%ecx),%eax
  85:	84 c0                	test   %al,%al
  87:	74 15                	je     9e <strcmp+0x25>
  89:	3a 02                	cmp    (%edx),%al
  8b:	75 11                	jne    9e <strcmp+0x25>
    p++, q++;
  8d:	83 c1 01             	add    $0x1,%ecx
  90:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  93:	0f b6 01             	movzbl (%ecx),%eax
  96:	84 c0                	test   %al,%al
  98:	74 04                	je     9e <strcmp+0x25>
  9a:	3a 02                	cmp    (%edx),%al
  9c:	74 ef                	je     8d <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  9e:	0f b6 c0             	movzbl %al,%eax
  a1:	0f b6 12             	movzbl (%edx),%edx
  a4:	29 d0                	sub    %edx,%eax
}
  a6:	5d                   	pop    %ebp
  a7:	c3                   	ret    

000000a8 <strlen>:

uint
strlen(char *s)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ae:	80 39 00             	cmpb   $0x0,(%ecx)
  b1:	74 12                	je     c5 <strlen+0x1d>
  b3:	ba 00 00 00 00       	mov    $0x0,%edx
  b8:	83 c2 01             	add    $0x1,%edx
  bb:	89 d0                	mov    %edx,%eax
  bd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c1:	75 f5                	jne    b8 <strlen+0x10>
  c3:	eb 05                	jmp    ca <strlen+0x22>
  c5:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
  ca:	5d                   	pop    %ebp
  cb:	c3                   	ret    

000000cc <memset>:

void*
memset(void *dst, int c, uint n)
{
  cc:	55                   	push   %ebp
  cd:	89 e5                	mov    %esp,%ebp
  cf:	57                   	push   %edi
  d0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d3:	89 d7                	mov    %edx,%edi
  d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	fc                   	cld    
  dc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  de:	89 d0                	mov    %edx,%eax
  e0:	5f                   	pop    %edi
  e1:	5d                   	pop    %ebp
  e2:	c3                   	ret    

000000e3 <strchr>:

char*
strchr(const char *s, char c)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	53                   	push   %ebx
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  ed:	0f b6 10             	movzbl (%eax),%edx
  f0:	84 d2                	test   %dl,%dl
  f2:	74 1d                	je     111 <strchr+0x2e>
  f4:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  f6:	38 d3                	cmp    %dl,%bl
  f8:	75 06                	jne    100 <strchr+0x1d>
  fa:	eb 1a                	jmp    116 <strchr+0x33>
  fc:	38 ca                	cmp    %cl,%dl
  fe:	74 16                	je     116 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 100:	83 c0 01             	add    $0x1,%eax
 103:	0f b6 10             	movzbl (%eax),%edx
 106:	84 d2                	test   %dl,%dl
 108:	75 f2                	jne    fc <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 10a:	b8 00 00 00 00       	mov    $0x0,%eax
 10f:	eb 05                	jmp    116 <strchr+0x33>
 111:	b8 00 00 00 00       	mov    $0x0,%eax
}
 116:	5b                   	pop    %ebx
 117:	5d                   	pop    %ebp
 118:	c3                   	ret    

00000119 <gets>:

char*
gets(char *buf, int max)
{
 119:	55                   	push   %ebp
 11a:	89 e5                	mov    %esp,%ebp
 11c:	57                   	push   %edi
 11d:	56                   	push   %esi
 11e:	53                   	push   %ebx
 11f:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 122:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 127:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12a:	eb 29                	jmp    155 <gets+0x3c>
    cc = read(0, &c, 1);
 12c:	83 ec 04             	sub    $0x4,%esp
 12f:	6a 01                	push   $0x1
 131:	57                   	push   %edi
 132:	6a 00                	push   $0x0
 134:	e8 fc 00 00 00       	call   235 <read>
    if(cc < 1)
 139:	83 c4 10             	add    $0x10,%esp
 13c:	85 c0                	test   %eax,%eax
 13e:	7e 21                	jle    161 <gets+0x48>
      break;
    buf[i++] = c;
 140:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 144:	8b 55 08             	mov    0x8(%ebp),%edx
 147:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14b:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14d:	3c 0a                	cmp    $0xa,%al
 14f:	74 0e                	je     15f <gets+0x46>
 151:	3c 0d                	cmp    $0xd,%al
 153:	74 0a                	je     15f <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 155:	8d 5e 01             	lea    0x1(%esi),%ebx
 158:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 15b:	7c cf                	jl     12c <gets+0x13>
 15d:	eb 02                	jmp    161 <gets+0x48>
 15f:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 168:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16b:	5b                   	pop    %ebx
 16c:	5e                   	pop    %esi
 16d:	5f                   	pop    %edi
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <stat>:

int
stat(char *n, struct stat *st)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	56                   	push   %esi
 174:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 175:	83 ec 08             	sub    $0x8,%esp
 178:	6a 00                	push   $0x0
 17a:	ff 75 08             	pushl  0x8(%ebp)
 17d:	e8 db 00 00 00       	call   25d <open>
  if(fd < 0)
 182:	83 c4 10             	add    $0x10,%esp
 185:	85 c0                	test   %eax,%eax
 187:	78 1f                	js     1a8 <stat+0x38>
 189:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	ff 75 0c             	pushl  0xc(%ebp)
 191:	50                   	push   %eax
 192:	e8 de 00 00 00       	call   275 <fstat>
 197:	89 c6                	mov    %eax,%esi
  close(fd);
 199:	89 1c 24             	mov    %ebx,(%esp)
 19c:	e8 a4 00 00 00       	call   245 <close>
  return r;
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	89 f0                	mov    %esi,%eax
 1a6:	eb 05                	jmp    1ad <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 1ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b0:	5b                   	pop    %ebx
 1b1:	5e                   	pop    %esi
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <atoi>:

int
atoi(const char *s)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	53                   	push   %ebx
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1bb:	0f b6 11             	movzbl (%ecx),%edx
 1be:	8d 42 d0             	lea    -0x30(%edx),%eax
 1c1:	3c 09                	cmp    $0x9,%al
 1c3:	77 1f                	ja     1e4 <atoi+0x30>
 1c5:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1ca:	83 c1 01             	add    $0x1,%ecx
 1cd:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1d0:	0f be d2             	movsbl %dl,%edx
 1d3:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d7:	0f b6 11             	movzbl (%ecx),%edx
 1da:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1dd:	80 fb 09             	cmp    $0x9,%bl
 1e0:	76 e8                	jbe    1ca <atoi+0x16>
 1e2:	eb 05                	jmp    1e9 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 1e4:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 1e9:	5b                   	pop    %ebx
 1ea:	5d                   	pop    %ebp
 1eb:	c3                   	ret    

000001ec <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	8b 75 0c             	mov    0xc(%ebp),%esi
 1f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 1fa:	85 db                	test   %ebx,%ebx
 1fc:	7e 13                	jle    211 <memmove+0x25>
 1fe:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 203:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 207:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 20a:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 20d:	39 da                	cmp    %ebx,%edx
 20f:	75 f2                	jne    203 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 211:	5b                   	pop    %ebx
 212:	5e                   	pop    %esi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    

00000215 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 215:	b8 01 00 00 00       	mov    $0x1,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <exit>:
SYSCALL(exit)
 21d:	b8 02 00 00 00       	mov    $0x2,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <wait>:
SYSCALL(wait)
 225:	b8 03 00 00 00       	mov    $0x3,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <pipe>:
SYSCALL(pipe)
 22d:	b8 04 00 00 00       	mov    $0x4,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <read>:
SYSCALL(read)
 235:	b8 05 00 00 00       	mov    $0x5,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <write>:
SYSCALL(write)
 23d:	b8 10 00 00 00       	mov    $0x10,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <close>:
SYSCALL(close)
 245:	b8 15 00 00 00       	mov    $0x15,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <kill>:
SYSCALL(kill)
 24d:	b8 06 00 00 00       	mov    $0x6,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <exec>:
SYSCALL(exec)
 255:	b8 07 00 00 00       	mov    $0x7,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <open>:
SYSCALL(open)
 25d:	b8 0f 00 00 00       	mov    $0xf,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <mknod>:
SYSCALL(mknod)
 265:	b8 11 00 00 00       	mov    $0x11,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <unlink>:
SYSCALL(unlink)
 26d:	b8 12 00 00 00       	mov    $0x12,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <fstat>:
SYSCALL(fstat)
 275:	b8 08 00 00 00       	mov    $0x8,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <link>:
SYSCALL(link)
 27d:	b8 13 00 00 00       	mov    $0x13,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <mkdir>:
SYSCALL(mkdir)
 285:	b8 14 00 00 00       	mov    $0x14,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <chdir>:
SYSCALL(chdir)
 28d:	b8 09 00 00 00       	mov    $0x9,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <dup>:
SYSCALL(dup)
 295:	b8 0a 00 00 00       	mov    $0xa,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <getpid>:
SYSCALL(getpid)
 29d:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <sbrk>:
SYSCALL(sbrk)
 2a5:	b8 0c 00 00 00       	mov    $0xc,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <sleep>:
SYSCALL(sleep)
 2ad:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <uptime>:
SYSCALL(uptime)
 2b5:	b8 0e 00 00 00       	mov    $0xe,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <setvariable>:
SYSCALL(setvariable)
 2bd:	b8 17 00 00 00       	mov    $0x17,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <getvariable>:
SYSCALL(getvariable)
 2c5:	b8 18 00 00 00       	mov    $0x18,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <remvariable>:
SYSCALL(remvariable)
 2cd:	b8 19 00 00 00       	mov    $0x19,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <wait2>:
SYSCALL(wait2)
 2d5:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <set_priority>:
SYSCALL(set_priority)
 2dd:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	57                   	push   %edi
 2e9:	56                   	push   %esi
 2ea:	53                   	push   %ebx
 2eb:	83 ec 3c             	sub    $0x3c,%esp
 2ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f5:	74 12                	je     309 <printint+0x24>
 2f7:	89 d0                	mov    %edx,%eax
 2f9:	c1 e8 1f             	shr    $0x1f,%eax
 2fc:	84 c0                	test   %al,%al
 2fe:	74 09                	je     309 <printint+0x24>
    neg = 1;
    x = -xx;
 300:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 302:	be 01 00 00 00       	mov    $0x1,%esi
 307:	eb 05                	jmp    30e <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 309:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 30e:	bf 00 00 00 00       	mov    $0x0,%edi
 313:	eb 02                	jmp    317 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 315:	89 df                	mov    %ebx,%edi
 317:	8d 5f 01             	lea    0x1(%edi),%ebx
 31a:	89 d0                	mov    %edx,%eax
 31c:	ba 00 00 00 00       	mov    $0x0,%edx
 321:	f7 f1                	div    %ecx
 323:	0f b6 92 a4 06 00 00 	movzbl 0x6a4(%edx),%edx
 32a:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 32e:	89 c2                	mov    %eax,%edx
 330:	85 c0                	test   %eax,%eax
 332:	75 e1                	jne    315 <printint+0x30>
  if(neg)
 334:	85 f6                	test   %esi,%esi
 336:	74 08                	je     340 <printint+0x5b>
    buf[i++] = '-';
 338:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 33d:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 340:	89 d8                	mov    %ebx,%eax
 342:	83 e8 01             	sub    $0x1,%eax
 345:	78 29                	js     370 <printint+0x8b>
 347:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 34a:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 34e:	8d 7d d7             	lea    -0x29(%ebp),%edi
 351:	0f b6 03             	movzbl (%ebx),%eax
 354:	88 45 d7             	mov    %al,-0x29(%ebp)
 357:	83 ec 04             	sub    $0x4,%esp
 35a:	6a 01                	push   $0x1
 35c:	57                   	push   %edi
 35d:	56                   	push   %esi
 35e:	e8 da fe ff ff       	call   23d <write>
 363:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 366:	83 c4 10             	add    $0x10,%esp
 369:	8d 45 d7             	lea    -0x29(%ebp),%eax
 36c:	39 c3                	cmp    %eax,%ebx
 36e:	75 e1                	jne    351 <printint+0x6c>
    putc(fd, buf[i]);
}
 370:	8d 65 f4             	lea    -0xc(%ebp),%esp
 373:	5b                   	pop    %ebx
 374:	5e                   	pop    %esi
 375:	5f                   	pop    %edi
 376:	5d                   	pop    %ebp
 377:	c3                   	ret    

00000378 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	57                   	push   %edi
 37c:	56                   	push   %esi
 37d:	53                   	push   %ebx
 37e:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 381:	8b 75 0c             	mov    0xc(%ebp),%esi
 384:	0f b6 1e             	movzbl (%esi),%ebx
 387:	84 db                	test   %bl,%bl
 389:	0f 84 a6 01 00 00    	je     535 <printf+0x1bd>
 38f:	83 c6 01             	add    $0x1,%esi
 392:	8d 45 10             	lea    0x10(%ebp),%eax
 395:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 398:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 39d:	0f be d3             	movsbl %bl,%edx
 3a0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3a3:	85 ff                	test   %edi,%edi
 3a5:	75 25                	jne    3cc <printf+0x54>
      if(c == '%'){
 3a7:	83 f8 25             	cmp    $0x25,%eax
 3aa:	0f 84 6a 01 00 00    	je     51a <printf+0x1a2>
 3b0:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3b3:	83 ec 04             	sub    $0x4,%esp
 3b6:	6a 01                	push   $0x1
 3b8:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3bb:	50                   	push   %eax
 3bc:	ff 75 08             	pushl  0x8(%ebp)
 3bf:	e8 79 fe ff ff       	call   23d <write>
 3c4:	83 c4 10             	add    $0x10,%esp
 3c7:	e9 5a 01 00 00       	jmp    526 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3cc:	83 ff 25             	cmp    $0x25,%edi
 3cf:	0f 85 51 01 00 00    	jne    526 <printf+0x1ae>
      if(c == 'd'){
 3d5:	83 f8 64             	cmp    $0x64,%eax
 3d8:	75 2c                	jne    406 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 3da:	83 ec 0c             	sub    $0xc,%esp
 3dd:	6a 01                	push   $0x1
 3df:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3e4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3e7:	8b 17                	mov    (%edi),%edx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	e8 f4 fe ff ff       	call   2e5 <printint>
        ap++;
 3f1:	89 f8                	mov    %edi,%eax
 3f3:	83 c0 04             	add    $0x4,%eax
 3f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3f9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3fc:	bf 00 00 00 00       	mov    $0x0,%edi
 401:	e9 20 01 00 00       	jmp    526 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 406:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 40c:	83 fa 70             	cmp    $0x70,%edx
 40f:	75 2c                	jne    43d <printf+0xc5>
        printint(fd, *ap, 16, 0);
 411:	83 ec 0c             	sub    $0xc,%esp
 414:	6a 00                	push   $0x0
 416:	b9 10 00 00 00       	mov    $0x10,%ecx
 41b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 41e:	8b 17                	mov    (%edi),%edx
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	e8 bd fe ff ff       	call   2e5 <printint>
        ap++;
 428:	89 f8                	mov    %edi,%eax
 42a:	83 c0 04             	add    $0x4,%eax
 42d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 430:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 433:	bf 00 00 00 00       	mov    $0x0,%edi
 438:	e9 e9 00 00 00       	jmp    526 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43d:	83 f8 73             	cmp    $0x73,%eax
 440:	75 52                	jne    494 <printf+0x11c>
        s = (char*)*ap;
 442:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 445:	8b 18                	mov    (%eax),%ebx
        ap++;
 447:	83 c0 04             	add    $0x4,%eax
 44a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 44d:	85 db                	test   %ebx,%ebx
          s = "(null)";
 44f:	b8 9c 06 00 00       	mov    $0x69c,%eax
 454:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 457:	0f b6 03             	movzbl (%ebx),%eax
 45a:	84 c0                	test   %al,%al
 45c:	0f 84 bf 00 00 00    	je     521 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 462:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 465:	89 75 d0             	mov    %esi,-0x30(%ebp)
 468:	8b 75 08             	mov    0x8(%ebp),%esi
 46b:	88 45 e3             	mov    %al,-0x1d(%ebp)
 46e:	83 ec 04             	sub    $0x4,%esp
 471:	6a 01                	push   $0x1
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	e8 c3 fd ff ff       	call   23d <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 47a:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 47d:	0f b6 03             	movzbl (%ebx),%eax
 480:	83 c4 10             	add    $0x10,%esp
 483:	84 c0                	test   %al,%al
 485:	75 e4                	jne    46b <printf+0xf3>
 487:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 48a:	bf 00 00 00 00       	mov    $0x0,%edi
 48f:	e9 92 00 00 00       	jmp    526 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 494:	83 f8 63             	cmp    $0x63,%eax
 497:	75 2b                	jne    4c4 <printf+0x14c>
 499:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 49c:	8b 07                	mov    (%edi),%eax
 49e:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4a1:	83 ec 04             	sub    $0x4,%esp
 4a4:	6a 01                	push   $0x1
 4a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4a9:	50                   	push   %eax
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 8b fd ff ff       	call   23d <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 4b2:	89 f8                	mov    %edi,%eax
 4b4:	83 c0 04             	add    $0x4,%eax
 4b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4ba:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4bd:	bf 00 00 00 00       	mov    $0x0,%edi
 4c2:	eb 62                	jmp    526 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c4:	83 f8 25             	cmp    $0x25,%eax
 4c7:	75 1e                	jne    4e7 <printf+0x16f>
 4c9:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4cc:	83 ec 04             	sub    $0x4,%esp
 4cf:	6a 01                	push   $0x1
 4d1:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4d4:	50                   	push   %eax
 4d5:	ff 75 08             	pushl  0x8(%ebp)
 4d8:	e8 60 fd ff ff       	call   23d <write>
 4dd:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4e0:	bf 00 00 00 00       	mov    $0x0,%edi
 4e5:	eb 3f                	jmp    526 <printf+0x1ae>
 4e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4eb:	83 ec 04             	sub    $0x4,%esp
 4ee:	6a 01                	push   $0x1
 4f0:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f3:	50                   	push   %eax
 4f4:	ff 75 08             	pushl  0x8(%ebp)
 4f7:	e8 41 fd ff ff       	call   23d <write>
 4fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4ff:	83 c4 0c             	add    $0xc,%esp
 502:	6a 01                	push   $0x1
 504:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 507:	50                   	push   %eax
 508:	ff 75 08             	pushl  0x8(%ebp)
 50b:	e8 2d fd ff ff       	call   23d <write>
 510:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 513:	bf 00 00 00 00       	mov    $0x0,%edi
 518:	eb 0c                	jmp    526 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 51a:	bf 25 00 00 00       	mov    $0x25,%edi
 51f:	eb 05                	jmp    526 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 521:	bf 00 00 00 00       	mov    $0x0,%edi
 526:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 529:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 52d:	84 db                	test   %bl,%bl
 52f:	0f 85 68 fe ff ff    	jne    39d <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 535:	8d 65 f4             	lea    -0xc(%ebp),%esp
 538:	5b                   	pop    %ebx
 539:	5e                   	pop    %esi
 53a:	5f                   	pop    %edi
 53b:	5d                   	pop    %ebp
 53c:	c3                   	ret    

0000053d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 53d:	55                   	push   %ebp
 53e:	89 e5                	mov    %esp,%ebp
 540:	57                   	push   %edi
 541:	56                   	push   %esi
 542:	53                   	push   %ebx
 543:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 546:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 549:	a1 00 09 00 00       	mov    0x900,%eax
 54e:	eb 0c                	jmp    55c <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 550:	8b 10                	mov    (%eax),%edx
 552:	39 d0                	cmp    %edx,%eax
 554:	72 04                	jb     55a <free+0x1d>
 556:	39 d1                	cmp    %edx,%ecx
 558:	72 0c                	jb     566 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 55a:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 55c:	39 c8                	cmp    %ecx,%eax
 55e:	73 f0                	jae    550 <free+0x13>
 560:	8b 10                	mov    (%eax),%edx
 562:	39 d1                	cmp    %edx,%ecx
 564:	73 3e                	jae    5a4 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 566:	8b 73 fc             	mov    -0x4(%ebx),%esi
 569:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 56c:	8b 10                	mov    (%eax),%edx
 56e:	39 d7                	cmp    %edx,%edi
 570:	75 0f                	jne    581 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 572:	03 77 04             	add    0x4(%edi),%esi
 575:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 578:	8b 10                	mov    (%eax),%edx
 57a:	8b 12                	mov    (%edx),%edx
 57c:	89 53 f8             	mov    %edx,-0x8(%ebx)
 57f:	eb 03                	jmp    584 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 581:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 584:	8b 50 04             	mov    0x4(%eax),%edx
 587:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58a:	39 f1                	cmp    %esi,%ecx
 58c:	75 0d                	jne    59b <free+0x5e>
    p->s.size += bp->s.size;
 58e:	03 53 fc             	add    -0x4(%ebx),%edx
 591:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 594:	8b 53 f8             	mov    -0x8(%ebx),%edx
 597:	89 10                	mov    %edx,(%eax)
 599:	eb 02                	jmp    59d <free+0x60>
  } else
    p->s.ptr = bp;
 59b:	89 08                	mov    %ecx,(%eax)
  freep = p;
 59d:	a3 00 09 00 00       	mov    %eax,0x900
}
 5a2:	eb 06                	jmp    5aa <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a4:	39 d0                	cmp    %edx,%eax
 5a6:	72 b2                	jb     55a <free+0x1d>
 5a8:	eb bc                	jmp    566 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 5aa:	5b                   	pop    %ebx
 5ab:	5e                   	pop    %esi
 5ac:	5f                   	pop    %edi
 5ad:	5d                   	pop    %ebp
 5ae:	c3                   	ret    

000005af <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5af:	55                   	push   %ebp
 5b0:	89 e5                	mov    %esp,%ebp
 5b2:	57                   	push   %edi
 5b3:	56                   	push   %esi
 5b4:	53                   	push   %ebx
 5b5:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	8d 58 07             	lea    0x7(%eax),%ebx
 5be:	c1 eb 03             	shr    $0x3,%ebx
 5c1:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5c4:	8b 15 00 09 00 00    	mov    0x900,%edx
 5ca:	85 d2                	test   %edx,%edx
 5cc:	75 23                	jne    5f1 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 5ce:	c7 05 00 09 00 00 04 	movl   $0x904,0x900
 5d5:	09 00 00 
 5d8:	c7 05 04 09 00 00 04 	movl   $0x904,0x904
 5df:	09 00 00 
    base.s.size = 0;
 5e2:	c7 05 08 09 00 00 00 	movl   $0x0,0x908
 5e9:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 5ec:	ba 04 09 00 00       	mov    $0x904,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5f3:	8b 48 04             	mov    0x4(%eax),%ecx
 5f6:	39 cb                	cmp    %ecx,%ebx
 5f8:	77 20                	ja     61a <malloc+0x6b>
      if(p->s.size == nunits)
 5fa:	39 cb                	cmp    %ecx,%ebx
 5fc:	75 06                	jne    604 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 5fe:	8b 08                	mov    (%eax),%ecx
 600:	89 0a                	mov    %ecx,(%edx)
 602:	eb 0b                	jmp    60f <malloc+0x60>
      else {
        p->s.size -= nunits;
 604:	29 d9                	sub    %ebx,%ecx
 606:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 609:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 60c:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 60f:	89 15 00 09 00 00    	mov    %edx,0x900
      return (void*)(p + 1);
 615:	83 c0 08             	add    $0x8,%eax
 618:	eb 63                	jmp    67d <malloc+0xce>
 61a:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 620:	be 00 10 00 00       	mov    $0x1000,%esi
 625:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 628:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 62f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 631:	39 05 00 09 00 00    	cmp    %eax,0x900
 637:	75 2d                	jne    666 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 639:	83 ec 0c             	sub    $0xc,%esp
 63c:	57                   	push   %edi
 63d:	e8 63 fc ff ff       	call   2a5 <sbrk>
  if(p == (char*)-1)
 642:	83 c4 10             	add    $0x10,%esp
 645:	83 f8 ff             	cmp    $0xffffffff,%eax
 648:	74 27                	je     671 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 64a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 64d:	83 ec 0c             	sub    $0xc,%esp
 650:	83 c0 08             	add    $0x8,%eax
 653:	50                   	push   %eax
 654:	e8 e4 fe ff ff       	call   53d <free>
  return freep;
 659:	8b 15 00 09 00 00    	mov    0x900,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 65f:	83 c4 10             	add    $0x10,%esp
 662:	85 d2                	test   %edx,%edx
 664:	74 12                	je     678 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 666:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 668:	8b 48 04             	mov    0x4(%eax),%ecx
 66b:	39 cb                	cmp    %ecx,%ebx
 66d:	77 c0                	ja     62f <malloc+0x80>
 66f:	eb 89                	jmp    5fa <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 671:	b8 00 00 00 00       	mov    $0x0,%eax
 676:	eb 05                	jmp    67d <malloc+0xce>
 678:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 67d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 680:	5b                   	pop    %ebx
 681:	5e                   	pop    %esi
 682:	5f                   	pop    %edi
 683:	5d                   	pop    %ebp
 684:	c3                   	ret    
