
_mkdir:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	83 c3 04             	add    $0x4,%ebx
  int i;

  if(argc < 2){
  1c:	be 01 00 00 00       	mov    $0x1,%esi
  21:	83 ff 01             	cmp    $0x1,%edi
  24:	7f 14                	jg     3a <main+0x3a>
    printf(2, "Usage: mkdir files...\n");
  26:	83 ec 08             	sub    $0x8,%esp
  29:	68 a4 06 00 00       	push   $0x6a4
  2e:	6a 02                	push   $0x2
  30:	e8 60 03 00 00       	call   395 <printf>
    exit();
  35:	e8 00 02 00 00       	call   23a <exit>
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  3a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 33                	pushl  (%ebx)
  42:	e8 5b 02 00 00       	call   2a2 <mkdir>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 19                	jns    67 <main+0x67>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  4e:	83 ec 04             	sub    $0x4,%esp
  51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  54:	ff 30                	pushl  (%eax)
  56:	68 bb 06 00 00       	push   $0x6bb
  5b:	6a 02                	push   $0x2
  5d:	e8 33 03 00 00       	call   395 <printf>
      break;
  62:	83 c4 10             	add    $0x10,%esp
  65:	eb 0a                	jmp    71 <main+0x71>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  67:	83 c6 01             	add    $0x1,%esi
  6a:	83 c3 04             	add    $0x4,%ebx
  6d:	39 f7                	cmp    %esi,%edi
  6f:	75 c9                	jne    3a <main+0x3a>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  71:	e8 c4 01 00 00       	call   23a <exit>

00000076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	53                   	push   %ebx
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	89 c2                	mov    %eax,%edx
  82:	83 c2 01             	add    $0x1,%edx
  85:	83 c1 01             	add    $0x1,%ecx
  88:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	84 db                	test   %bl,%bl
  91:	75 ef                	jne    82 <strcpy+0xc>
    ;
  return os;
}
  93:	5b                   	pop    %ebx
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9f:	0f b6 01             	movzbl (%ecx),%eax
  a2:	84 c0                	test   %al,%al
  a4:	74 15                	je     bb <strcmp+0x25>
  a6:	3a 02                	cmp    (%edx),%al
  a8:	75 11                	jne    bb <strcmp+0x25>
    p++, q++;
  aa:	83 c1 01             	add    $0x1,%ecx
  ad:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  b0:	0f b6 01             	movzbl (%ecx),%eax
  b3:	84 c0                	test   %al,%al
  b5:	74 04                	je     bb <strcmp+0x25>
  b7:	3a 02                	cmp    (%edx),%al
  b9:	74 ef                	je     aa <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  bb:	0f b6 c0             	movzbl %al,%eax
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	29 d0                	sub    %edx,%eax
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strlen>:

uint
strlen(char *s)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  cb:	80 39 00             	cmpb   $0x0,(%ecx)
  ce:	74 12                	je     e2 <strlen+0x1d>
  d0:	ba 00 00 00 00       	mov    $0x0,%edx
  d5:	83 c2 01             	add    $0x1,%edx
  d8:	89 d0                	mov    %edx,%eax
  da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  de:	75 f5                	jne    d5 <strlen+0x10>
  e0:	eb 05                	jmp    e7 <strlen+0x22>
  e2:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
  e7:	5d                   	pop    %ebp
  e8:	c3                   	ret    

000000e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f0:	89 d7                	mov    %edx,%edi
  f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	fc                   	cld    
  f9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fb:	89 d0                	mov    %edx,%eax
  fd:	5f                   	pop    %edi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	74 1d                	je     12e <strchr+0x2e>
 111:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 113:	38 d3                	cmp    %dl,%bl
 115:	75 06                	jne    11d <strchr+0x1d>
 117:	eb 1a                	jmp    133 <strchr+0x33>
 119:	38 ca                	cmp    %cl,%dl
 11b:	74 16                	je     133 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11d:	83 c0 01             	add    $0x1,%eax
 120:	0f b6 10             	movzbl (%eax),%edx
 123:	84 d2                	test   %dl,%dl
 125:	75 f2                	jne    119 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 127:	b8 00 00 00 00       	mov    $0x0,%eax
 12c:	eb 05                	jmp    133 <strchr+0x33>
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	5b                   	pop    %ebx
 134:	5d                   	pop    %ebp
 135:	c3                   	ret    

00000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	57                   	push   %edi
 13a:	56                   	push   %esi
 13b:	53                   	push   %ebx
 13c:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 144:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 147:	eb 29                	jmp    172 <gets+0x3c>
    cc = read(0, &c, 1);
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	6a 01                	push   $0x1
 14e:	57                   	push   %edi
 14f:	6a 00                	push   $0x0
 151:	e8 fc 00 00 00       	call   252 <read>
    if(cc < 1)
 156:	83 c4 10             	add    $0x10,%esp
 159:	85 c0                	test   %eax,%eax
 15b:	7e 21                	jle    17e <gets+0x48>
      break;
    buf[i++] = c;
 15d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 161:	8b 55 08             	mov    0x8(%ebp),%edx
 164:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16a:	3c 0a                	cmp    $0xa,%al
 16c:	74 0e                	je     17c <gets+0x46>
 16e:	3c 0d                	cmp    $0xd,%al
 170:	74 0a                	je     17c <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	8d 5e 01             	lea    0x1(%esi),%ebx
 175:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 178:	7c cf                	jl     149 <gets+0x13>
 17a:	eb 02                	jmp    17e <gets+0x48>
 17c:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 185:	8d 65 f4             	lea    -0xc(%ebp),%esp
 188:	5b                   	pop    %ebx
 189:	5e                   	pop    %esi
 18a:	5f                   	pop    %edi
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    

0000018d <stat>:

int
stat(char *n, struct stat *st)
{
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
 190:	56                   	push   %esi
 191:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 192:	83 ec 08             	sub    $0x8,%esp
 195:	6a 00                	push   $0x0
 197:	ff 75 08             	pushl  0x8(%ebp)
 19a:	e8 db 00 00 00       	call   27a <open>
  if(fd < 0)
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	85 c0                	test   %eax,%eax
 1a4:	78 1f                	js     1c5 <stat+0x38>
 1a6:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a8:	83 ec 08             	sub    $0x8,%esp
 1ab:	ff 75 0c             	pushl  0xc(%ebp)
 1ae:	50                   	push   %eax
 1af:	e8 de 00 00 00       	call   292 <fstat>
 1b4:	89 c6                	mov    %eax,%esi
  close(fd);
 1b6:	89 1c 24             	mov    %ebx,(%esp)
 1b9:	e8 a4 00 00 00       	call   262 <close>
  return r;
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	89 f0                	mov    %esi,%eax
 1c3:	eb 05                	jmp    1ca <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 1ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1cd:	5b                   	pop    %ebx
 1ce:	5e                   	pop    %esi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <atoi>:

int
atoi(const char *s)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	53                   	push   %ebx
 1d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d8:	0f b6 11             	movzbl (%ecx),%edx
 1db:	8d 42 d0             	lea    -0x30(%edx),%eax
 1de:	3c 09                	cmp    $0x9,%al
 1e0:	77 1f                	ja     201 <atoi+0x30>
 1e2:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1e7:	83 c1 01             	add    $0x1,%ecx
 1ea:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1ed:	0f be d2             	movsbl %dl,%edx
 1f0:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	0f b6 11             	movzbl (%ecx),%edx
 1f7:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1fa:	80 fb 09             	cmp    $0x9,%bl
 1fd:	76 e8                	jbe    1e7 <atoi+0x16>
 1ff:	eb 05                	jmp    206 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 201:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 206:	5b                   	pop    %ebx
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	56                   	push   %esi
 20d:	53                   	push   %ebx
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8b 75 0c             	mov    0xc(%ebp),%esi
 214:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 217:	85 db                	test   %ebx,%ebx
 219:	7e 13                	jle    22e <memmove+0x25>
 21b:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 220:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 224:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 227:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22a:	39 da                	cmp    %ebx,%edx
 22c:	75 f2                	jne    220 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 22e:	5b                   	pop    %ebx
 22f:	5e                   	pop    %esi
 230:	5d                   	pop    %ebp
 231:	c3                   	ret    

00000232 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 232:	b8 01 00 00 00       	mov    $0x1,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <exit>:
SYSCALL(exit)
 23a:	b8 02 00 00 00       	mov    $0x2,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <wait>:
SYSCALL(wait)
 242:	b8 03 00 00 00       	mov    $0x3,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <pipe>:
SYSCALL(pipe)
 24a:	b8 04 00 00 00       	mov    $0x4,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <read>:
SYSCALL(read)
 252:	b8 05 00 00 00       	mov    $0x5,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <write>:
SYSCALL(write)
 25a:	b8 10 00 00 00       	mov    $0x10,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <close>:
SYSCALL(close)
 262:	b8 15 00 00 00       	mov    $0x15,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <kill>:
SYSCALL(kill)
 26a:	b8 06 00 00 00       	mov    $0x6,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <exec>:
SYSCALL(exec)
 272:	b8 07 00 00 00       	mov    $0x7,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <open>:
SYSCALL(open)
 27a:	b8 0f 00 00 00       	mov    $0xf,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <mknod>:
SYSCALL(mknod)
 282:	b8 11 00 00 00       	mov    $0x11,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <unlink>:
SYSCALL(unlink)
 28a:	b8 12 00 00 00       	mov    $0x12,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <fstat>:
SYSCALL(fstat)
 292:	b8 08 00 00 00       	mov    $0x8,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <link>:
SYSCALL(link)
 29a:	b8 13 00 00 00       	mov    $0x13,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <mkdir>:
SYSCALL(mkdir)
 2a2:	b8 14 00 00 00       	mov    $0x14,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <chdir>:
SYSCALL(chdir)
 2aa:	b8 09 00 00 00       	mov    $0x9,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <dup>:
SYSCALL(dup)
 2b2:	b8 0a 00 00 00       	mov    $0xa,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <getpid>:
SYSCALL(getpid)
 2ba:	b8 0b 00 00 00       	mov    $0xb,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <sbrk>:
SYSCALL(sbrk)
 2c2:	b8 0c 00 00 00       	mov    $0xc,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <sleep>:
SYSCALL(sleep)
 2ca:	b8 0d 00 00 00       	mov    $0xd,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <uptime>:
SYSCALL(uptime)
 2d2:	b8 0e 00 00 00       	mov    $0xe,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <setvariable>:
SYSCALL(setvariable)
 2da:	b8 17 00 00 00       	mov    $0x17,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <getvariable>:
SYSCALL(getvariable)
 2e2:	b8 18 00 00 00       	mov    $0x18,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <remvariable>:
SYSCALL(remvariable)
 2ea:	b8 19 00 00 00       	mov    $0x19,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <wait2>:
SYSCALL(wait2)
 2f2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <set_priority>:
SYSCALL(set_priority)
 2fa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	57                   	push   %edi
 306:	56                   	push   %esi
 307:	53                   	push   %ebx
 308:	83 ec 3c             	sub    $0x3c,%esp
 30b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 312:	74 12                	je     326 <printint+0x24>
 314:	89 d0                	mov    %edx,%eax
 316:	c1 e8 1f             	shr    $0x1f,%eax
 319:	84 c0                	test   %al,%al
 31b:	74 09                	je     326 <printint+0x24>
    neg = 1;
    x = -xx;
 31d:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 31f:	be 01 00 00 00       	mov    $0x1,%esi
 324:	eb 05                	jmp    32b <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 326:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 32b:	bf 00 00 00 00       	mov    $0x0,%edi
 330:	eb 02                	jmp    334 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 332:	89 df                	mov    %ebx,%edi
 334:	8d 5f 01             	lea    0x1(%edi),%ebx
 337:	89 d0                	mov    %edx,%eax
 339:	ba 00 00 00 00       	mov    $0x0,%edx
 33e:	f7 f1                	div    %ecx
 340:	0f b6 92 e0 06 00 00 	movzbl 0x6e0(%edx),%edx
 347:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 34b:	89 c2                	mov    %eax,%edx
 34d:	85 c0                	test   %eax,%eax
 34f:	75 e1                	jne    332 <printint+0x30>
  if(neg)
 351:	85 f6                	test   %esi,%esi
 353:	74 08                	je     35d <printint+0x5b>
    buf[i++] = '-';
 355:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 35a:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 35d:	89 d8                	mov    %ebx,%eax
 35f:	83 e8 01             	sub    $0x1,%eax
 362:	78 29                	js     38d <printint+0x8b>
 364:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 367:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 36b:	8d 7d d7             	lea    -0x29(%ebp),%edi
 36e:	0f b6 03             	movzbl (%ebx),%eax
 371:	88 45 d7             	mov    %al,-0x29(%ebp)
 374:	83 ec 04             	sub    $0x4,%esp
 377:	6a 01                	push   $0x1
 379:	57                   	push   %edi
 37a:	56                   	push   %esi
 37b:	e8 da fe ff ff       	call   25a <write>
 380:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 383:	83 c4 10             	add    $0x10,%esp
 386:	8d 45 d7             	lea    -0x29(%ebp),%eax
 389:	39 c3                	cmp    %eax,%ebx
 38b:	75 e1                	jne    36e <printint+0x6c>
    putc(fd, buf[i]);
}
 38d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 390:	5b                   	pop    %ebx
 391:	5e                   	pop    %esi
 392:	5f                   	pop    %edi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret    

00000395 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	57                   	push   %edi
 399:	56                   	push   %esi
 39a:	53                   	push   %ebx
 39b:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 39e:	8b 75 0c             	mov    0xc(%ebp),%esi
 3a1:	0f b6 1e             	movzbl (%esi),%ebx
 3a4:	84 db                	test   %bl,%bl
 3a6:	0f 84 a6 01 00 00    	je     552 <printf+0x1bd>
 3ac:	83 c6 01             	add    $0x1,%esi
 3af:	8d 45 10             	lea    0x10(%ebp),%eax
 3b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3b5:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 3ba:	0f be d3             	movsbl %bl,%edx
 3bd:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3c0:	85 ff                	test   %edi,%edi
 3c2:	75 25                	jne    3e9 <printf+0x54>
      if(c == '%'){
 3c4:	83 f8 25             	cmp    $0x25,%eax
 3c7:	0f 84 6a 01 00 00    	je     537 <printf+0x1a2>
 3cd:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d0:	83 ec 04             	sub    $0x4,%esp
 3d3:	6a 01                	push   $0x1
 3d5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3d8:	50                   	push   %eax
 3d9:	ff 75 08             	pushl  0x8(%ebp)
 3dc:	e8 79 fe ff ff       	call   25a <write>
 3e1:	83 c4 10             	add    $0x10,%esp
 3e4:	e9 5a 01 00 00       	jmp    543 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3e9:	83 ff 25             	cmp    $0x25,%edi
 3ec:	0f 85 51 01 00 00    	jne    543 <printf+0x1ae>
      if(c == 'd'){
 3f2:	83 f8 64             	cmp    $0x64,%eax
 3f5:	75 2c                	jne    423 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 3f7:	83 ec 0c             	sub    $0xc,%esp
 3fa:	6a 01                	push   $0x1
 3fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 401:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 404:	8b 17                	mov    (%edi),%edx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	e8 f4 fe ff ff       	call   302 <printint>
        ap++;
 40e:	89 f8                	mov    %edi,%eax
 410:	83 c0 04             	add    $0x4,%eax
 413:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 416:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 419:	bf 00 00 00 00       	mov    $0x0,%edi
 41e:	e9 20 01 00 00       	jmp    543 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 423:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 429:	83 fa 70             	cmp    $0x70,%edx
 42c:	75 2c                	jne    45a <printf+0xc5>
        printint(fd, *ap, 16, 0);
 42e:	83 ec 0c             	sub    $0xc,%esp
 431:	6a 00                	push   $0x0
 433:	b9 10 00 00 00       	mov    $0x10,%ecx
 438:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 43b:	8b 17                	mov    (%edi),%edx
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	e8 bd fe ff ff       	call   302 <printint>
        ap++;
 445:	89 f8                	mov    %edi,%eax
 447:	83 c0 04             	add    $0x4,%eax
 44a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 44d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 450:	bf 00 00 00 00       	mov    $0x0,%edi
 455:	e9 e9 00 00 00       	jmp    543 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 45a:	83 f8 73             	cmp    $0x73,%eax
 45d:	75 52                	jne    4b1 <printf+0x11c>
        s = (char*)*ap;
 45f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 462:	8b 18                	mov    (%eax),%ebx
        ap++;
 464:	83 c0 04             	add    $0x4,%eax
 467:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 46a:	85 db                	test   %ebx,%ebx
          s = "(null)";
 46c:	b8 d7 06 00 00       	mov    $0x6d7,%eax
 471:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 474:	0f b6 03             	movzbl (%ebx),%eax
 477:	84 c0                	test   %al,%al
 479:	0f 84 bf 00 00 00    	je     53e <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 47f:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 482:	89 75 d0             	mov    %esi,-0x30(%ebp)
 485:	8b 75 08             	mov    0x8(%ebp),%esi
 488:	88 45 e3             	mov    %al,-0x1d(%ebp)
 48b:	83 ec 04             	sub    $0x4,%esp
 48e:	6a 01                	push   $0x1
 490:	57                   	push   %edi
 491:	56                   	push   %esi
 492:	e8 c3 fd ff ff       	call   25a <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 497:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 49a:	0f b6 03             	movzbl (%ebx),%eax
 49d:	83 c4 10             	add    $0x10,%esp
 4a0:	84 c0                	test   %al,%al
 4a2:	75 e4                	jne    488 <printf+0xf3>
 4a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a7:	bf 00 00 00 00       	mov    $0x0,%edi
 4ac:	e9 92 00 00 00       	jmp    543 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b1:	83 f8 63             	cmp    $0x63,%eax
 4b4:	75 2b                	jne    4e1 <printf+0x14c>
 4b6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4b9:	8b 07                	mov    (%edi),%eax
 4bb:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4be:	83 ec 04             	sub    $0x4,%esp
 4c1:	6a 01                	push   $0x1
 4c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4c6:	50                   	push   %eax
 4c7:	ff 75 08             	pushl  0x8(%ebp)
 4ca:	e8 8b fd ff ff       	call   25a <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 4cf:	89 f8                	mov    %edi,%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d7:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4da:	bf 00 00 00 00       	mov    $0x0,%edi
 4df:	eb 62                	jmp    543 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4e1:	83 f8 25             	cmp    $0x25,%eax
 4e4:	75 1e                	jne    504 <printf+0x16f>
 4e6:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e9:	83 ec 04             	sub    $0x4,%esp
 4ec:	6a 01                	push   $0x1
 4ee:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4f1:	50                   	push   %eax
 4f2:	ff 75 08             	pushl  0x8(%ebp)
 4f5:	e8 60 fd ff ff       	call   25a <write>
 4fa:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fd:	bf 00 00 00 00       	mov    $0x0,%edi
 502:	eb 3f                	jmp    543 <printf+0x1ae>
 504:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 508:	83 ec 04             	sub    $0x4,%esp
 50b:	6a 01                	push   $0x1
 50d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 510:	50                   	push   %eax
 511:	ff 75 08             	pushl  0x8(%ebp)
 514:	e8 41 fd ff ff       	call   25a <write>
 519:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 51c:	83 c4 0c             	add    $0xc,%esp
 51f:	6a 01                	push   $0x1
 521:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 524:	50                   	push   %eax
 525:	ff 75 08             	pushl  0x8(%ebp)
 528:	e8 2d fd ff ff       	call   25a <write>
 52d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 530:	bf 00 00 00 00       	mov    $0x0,%edi
 535:	eb 0c                	jmp    543 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 537:	bf 25 00 00 00       	mov    $0x25,%edi
 53c:	eb 05                	jmp    543 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53e:	bf 00 00 00 00       	mov    $0x0,%edi
 543:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 546:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 54a:	84 db                	test   %bl,%bl
 54c:	0f 85 68 fe ff ff    	jne    3ba <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 552:	8d 65 f4             	lea    -0xc(%ebp),%esp
 555:	5b                   	pop    %ebx
 556:	5e                   	pop    %esi
 557:	5f                   	pop    %edi
 558:	5d                   	pop    %ebp
 559:	c3                   	ret    

0000055a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 55a:	55                   	push   %ebp
 55b:	89 e5                	mov    %esp,%ebp
 55d:	57                   	push   %edi
 55e:	56                   	push   %esi
 55f:	53                   	push   %ebx
 560:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 563:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 566:	a1 3c 09 00 00       	mov    0x93c,%eax
 56b:	eb 0c                	jmp    579 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 56d:	8b 10                	mov    (%eax),%edx
 56f:	39 d0                	cmp    %edx,%eax
 571:	72 04                	jb     577 <free+0x1d>
 573:	39 d1                	cmp    %edx,%ecx
 575:	72 0c                	jb     583 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 577:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 579:	39 c8                	cmp    %ecx,%eax
 57b:	73 f0                	jae    56d <free+0x13>
 57d:	8b 10                	mov    (%eax),%edx
 57f:	39 d1                	cmp    %edx,%ecx
 581:	73 3e                	jae    5c1 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 583:	8b 73 fc             	mov    -0x4(%ebx),%esi
 586:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 589:	8b 10                	mov    (%eax),%edx
 58b:	39 d7                	cmp    %edx,%edi
 58d:	75 0f                	jne    59e <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 58f:	03 77 04             	add    0x4(%edi),%esi
 592:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 595:	8b 10                	mov    (%eax),%edx
 597:	8b 12                	mov    (%edx),%edx
 599:	89 53 f8             	mov    %edx,-0x8(%ebx)
 59c:	eb 03                	jmp    5a1 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 59e:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5a1:	8b 50 04             	mov    0x4(%eax),%edx
 5a4:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5a7:	39 f1                	cmp    %esi,%ecx
 5a9:	75 0d                	jne    5b8 <free+0x5e>
    p->s.size += bp->s.size;
 5ab:	03 53 fc             	add    -0x4(%ebx),%edx
 5ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b1:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b4:	89 10                	mov    %edx,(%eax)
 5b6:	eb 02                	jmp    5ba <free+0x60>
  } else
    p->s.ptr = bp;
 5b8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ba:	a3 3c 09 00 00       	mov    %eax,0x93c
}
 5bf:	eb 06                	jmp    5c7 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c1:	39 d0                	cmp    %edx,%eax
 5c3:	72 b2                	jb     577 <free+0x1d>
 5c5:	eb bc                	jmp    583 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 5c7:	5b                   	pop    %ebx
 5c8:	5e                   	pop    %esi
 5c9:	5f                   	pop    %edi
 5ca:	5d                   	pop    %ebp
 5cb:	c3                   	ret    

000005cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	57                   	push   %edi
 5d0:	56                   	push   %esi
 5d1:	53                   	push   %ebx
 5d2:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	8d 58 07             	lea    0x7(%eax),%ebx
 5db:	c1 eb 03             	shr    $0x3,%ebx
 5de:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5e1:	8b 15 3c 09 00 00    	mov    0x93c,%edx
 5e7:	85 d2                	test   %edx,%edx
 5e9:	75 23                	jne    60e <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 5eb:	c7 05 3c 09 00 00 40 	movl   $0x940,0x93c
 5f2:	09 00 00 
 5f5:	c7 05 40 09 00 00 40 	movl   $0x940,0x940
 5fc:	09 00 00 
    base.s.size = 0;
 5ff:	c7 05 44 09 00 00 00 	movl   $0x0,0x944
 606:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 609:	ba 40 09 00 00       	mov    $0x940,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 610:	8b 48 04             	mov    0x4(%eax),%ecx
 613:	39 cb                	cmp    %ecx,%ebx
 615:	77 20                	ja     637 <malloc+0x6b>
      if(p->s.size == nunits)
 617:	39 cb                	cmp    %ecx,%ebx
 619:	75 06                	jne    621 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 61b:	8b 08                	mov    (%eax),%ecx
 61d:	89 0a                	mov    %ecx,(%edx)
 61f:	eb 0b                	jmp    62c <malloc+0x60>
      else {
        p->s.size -= nunits;
 621:	29 d9                	sub    %ebx,%ecx
 623:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 626:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 629:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 62c:	89 15 3c 09 00 00    	mov    %edx,0x93c
      return (void*)(p + 1);
 632:	83 c0 08             	add    $0x8,%eax
 635:	eb 63                	jmp    69a <malloc+0xce>
 637:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 63d:	be 00 10 00 00       	mov    $0x1000,%esi
 642:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 645:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 64c:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 64e:	39 05 3c 09 00 00    	cmp    %eax,0x93c
 654:	75 2d                	jne    683 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 656:	83 ec 0c             	sub    $0xc,%esp
 659:	57                   	push   %edi
 65a:	e8 63 fc ff ff       	call   2c2 <sbrk>
  if(p == (char*)-1)
 65f:	83 c4 10             	add    $0x10,%esp
 662:	83 f8 ff             	cmp    $0xffffffff,%eax
 665:	74 27                	je     68e <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 667:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 66a:	83 ec 0c             	sub    $0xc,%esp
 66d:	83 c0 08             	add    $0x8,%eax
 670:	50                   	push   %eax
 671:	e8 e4 fe ff ff       	call   55a <free>
  return freep;
 676:	8b 15 3c 09 00 00    	mov    0x93c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 67c:	83 c4 10             	add    $0x10,%esp
 67f:	85 d2                	test   %edx,%edx
 681:	74 12                	je     695 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 685:	8b 48 04             	mov    0x4(%eax),%ecx
 688:	39 cb                	cmp    %ecx,%ebx
 68a:	77 c0                	ja     64c <malloc+0x80>
 68c:	eb 89                	jmp    617 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 68e:	b8 00 00 00 00       	mov    $0x0,%eax
 693:	eb 05                	jmp    69a <malloc+0xce>
 695:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    
