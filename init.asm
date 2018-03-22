
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 0c 07 00 00       	push   $0x70c
  19:	e8 c3 02 00 00       	call   2e1 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	79 23                	jns    48 <main+0x48>
    mknod("console", 1, 1);
  25:	83 ec 04             	sub    $0x4,%esp
  28:	6a 01                	push   $0x1
  2a:	6a 01                	push   $0x1
  2c:	68 0c 07 00 00       	push   $0x70c
  31:	e8 b3 02 00 00       	call   2e9 <mknod>
    open("console", O_RDWR);
  36:	83 c4 08             	add    $0x8,%esp
  39:	6a 02                	push   $0x2
  3b:	68 0c 07 00 00       	push   $0x70c
  40:	e8 9c 02 00 00       	call   2e1 <open>
  45:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	6a 00                	push   $0x0
  4d:	e8 c7 02 00 00       	call   319 <dup>
  dup(0);  // stderr
  52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  59:	e8 bb 02 00 00       	call   319 <dup>
  5e:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  61:	83 ec 08             	sub    $0x8,%esp
  64:	68 14 07 00 00       	push   $0x714
  69:	6a 01                	push   $0x1
  6b:	e8 8c 03 00 00       	call   3fc <printf>
    pid = fork();
  70:	e8 24 02 00 00       	call   299 <fork>
  75:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  77:	83 c4 10             	add    $0x10,%esp
  7a:	85 c0                	test   %eax,%eax
  7c:	79 14                	jns    92 <main+0x92>
      printf(1, "init: fork failed\n");
  7e:	83 ec 08             	sub    $0x8,%esp
  81:	68 27 07 00 00       	push   $0x727
  86:	6a 01                	push   $0x1
  88:	e8 6f 03 00 00       	call   3fc <printf>
      exit();
  8d:	e8 0f 02 00 00       	call   2a1 <exit>
    }
    if(pid == 0){
  92:	85 c0                	test   %eax,%eax
  94:	75 38                	jne    ce <main+0xce>
      exec("sh", argv);
  96:	83 ec 08             	sub    $0x8,%esp
  99:	68 b8 09 00 00       	push   $0x9b8
  9e:	68 3a 07 00 00       	push   $0x73a
  a3:	e8 31 02 00 00       	call   2d9 <exec>
      printf(1, "init: exec sh failed\n");
  a8:	83 c4 08             	add    $0x8,%esp
  ab:	68 3d 07 00 00       	push   $0x73d
  b0:	6a 01                	push   $0x1
  b2:	e8 45 03 00 00       	call   3fc <printf>
      exit();
  b7:	e8 e5 01 00 00       	call   2a1 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  bc:	83 ec 08             	sub    $0x8,%esp
  bf:	68 53 07 00 00       	push   $0x753
  c4:	6a 01                	push   $0x1
  c6:	e8 31 03 00 00       	call   3fc <printf>
  cb:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  ce:	e8 d6 01 00 00       	call   2a9 <wait>
  d3:	39 c3                	cmp    %eax,%ebx
  d5:	74 8a                	je     61 <main+0x61>
  d7:	85 c0                	test   %eax,%eax
  d9:	79 e1                	jns    bc <main+0xbc>
  db:	eb 84                	jmp    61 <main+0x61>

000000dd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	53                   	push   %ebx
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e7:	89 c2                	mov    %eax,%edx
  e9:	83 c2 01             	add    $0x1,%edx
  ec:	83 c1 01             	add    $0x1,%ecx
  ef:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  f3:	88 5a ff             	mov    %bl,-0x1(%edx)
  f6:	84 db                	test   %bl,%bl
  f8:	75 ef                	jne    e9 <strcpy+0xc>
    ;
  return os;
}
  fa:	5b                   	pop    %ebx
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    

000000fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	8b 4d 08             	mov    0x8(%ebp),%ecx
 103:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 106:	0f b6 01             	movzbl (%ecx),%eax
 109:	84 c0                	test   %al,%al
 10b:	74 15                	je     122 <strcmp+0x25>
 10d:	3a 02                	cmp    (%edx),%al
 10f:	75 11                	jne    122 <strcmp+0x25>
    p++, q++;
 111:	83 c1 01             	add    $0x1,%ecx
 114:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 117:	0f b6 01             	movzbl (%ecx),%eax
 11a:	84 c0                	test   %al,%al
 11c:	74 04                	je     122 <strcmp+0x25>
 11e:	3a 02                	cmp    (%edx),%al
 120:	74 ef                	je     111 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 122:	0f b6 c0             	movzbl %al,%eax
 125:	0f b6 12             	movzbl (%edx),%edx
 128:	29 d0                	sub    %edx,%eax
}
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    

0000012c <strlen>:

uint
strlen(char *s)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 132:	80 39 00             	cmpb   $0x0,(%ecx)
 135:	74 12                	je     149 <strlen+0x1d>
 137:	ba 00 00 00 00       	mov    $0x0,%edx
 13c:	83 c2 01             	add    $0x1,%edx
 13f:	89 d0                	mov    %edx,%eax
 141:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 145:	75 f5                	jne    13c <strlen+0x10>
 147:	eb 05                	jmp    14e <strlen+0x22>
 149:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
 14e:	5d                   	pop    %ebp
 14f:	c3                   	ret    

00000150 <memset>:

void*
memset(void *dst, int c, uint n)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	57                   	push   %edi
 154:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 157:	89 d7                	mov    %edx,%edi
 159:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15c:	8b 45 0c             	mov    0xc(%ebp),%eax
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 162:	89 d0                	mov    %edx,%eax
 164:	5f                   	pop    %edi
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    

00000167 <strchr>:

char*
strchr(const char *s, char c)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	53                   	push   %ebx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	84 d2                	test   %dl,%dl
 176:	74 1d                	je     195 <strchr+0x2e>
 178:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 17a:	38 d3                	cmp    %dl,%bl
 17c:	75 06                	jne    184 <strchr+0x1d>
 17e:	eb 1a                	jmp    19a <strchr+0x33>
 180:	38 ca                	cmp    %cl,%dl
 182:	74 16                	je     19a <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 c0 01             	add    $0x1,%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	84 d2                	test   %dl,%dl
 18c:	75 f2                	jne    180 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 18e:	b8 00 00 00 00       	mov    $0x0,%eax
 193:	eb 05                	jmp    19a <strchr+0x33>
 195:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19a:	5b                   	pop    %ebx
 19b:	5d                   	pop    %ebp
 19c:	c3                   	ret    

0000019d <gets>:

char*
gets(char *buf, int max)
{
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
 1a0:	57                   	push   %edi
 1a1:	56                   	push   %esi
 1a2:	53                   	push   %ebx
 1a3:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a6:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1ab:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ae:	eb 29                	jmp    1d9 <gets+0x3c>
    cc = read(0, &c, 1);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	6a 01                	push   $0x1
 1b5:	57                   	push   %edi
 1b6:	6a 00                	push   $0x0
 1b8:	e8 fc 00 00 00       	call   2b9 <read>
    if(cc < 1)
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	85 c0                	test   %eax,%eax
 1c2:	7e 21                	jle    1e5 <gets+0x48>
      break;
    buf[i++] = c;
 1c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c8:	8b 55 08             	mov    0x8(%ebp),%edx
 1cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cf:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1d1:	3c 0a                	cmp    $0xa,%al
 1d3:	74 0e                	je     1e3 <gets+0x46>
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0a                	je     1e3 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1df:	7c cf                	jl     1b0 <gets+0x13>
 1e1:	eb 02                	jmp    1e5 <gets+0x48>
 1e3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ef:	5b                   	pop    %ebx
 1f0:	5e                   	pop    %esi
 1f1:	5f                   	pop    %edi
 1f2:	5d                   	pop    %ebp
 1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(char *n, struct stat *st)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	56                   	push   %esi
 1f8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f9:	83 ec 08             	sub    $0x8,%esp
 1fc:	6a 00                	push   $0x0
 1fe:	ff 75 08             	pushl  0x8(%ebp)
 201:	e8 db 00 00 00       	call   2e1 <open>
  if(fd < 0)
 206:	83 c4 10             	add    $0x10,%esp
 209:	85 c0                	test   %eax,%eax
 20b:	78 1f                	js     22c <stat+0x38>
 20d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 20f:	83 ec 08             	sub    $0x8,%esp
 212:	ff 75 0c             	pushl  0xc(%ebp)
 215:	50                   	push   %eax
 216:	e8 de 00 00 00       	call   2f9 <fstat>
 21b:	89 c6                	mov    %eax,%esi
  close(fd);
 21d:	89 1c 24             	mov    %ebx,(%esp)
 220:	e8 a4 00 00 00       	call   2c9 <close>
  return r;
 225:	83 c4 10             	add    $0x10,%esp
 228:	89 f0                	mov    %esi,%eax
 22a:	eb 05                	jmp    231 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 22c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 231:	8d 65 f8             	lea    -0x8(%ebp),%esp
 234:	5b                   	pop    %ebx
 235:	5e                   	pop    %esi
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    

00000238 <atoi>:

int
atoi(const char *s)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	53                   	push   %ebx
 23c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23f:	0f b6 11             	movzbl (%ecx),%edx
 242:	8d 42 d0             	lea    -0x30(%edx),%eax
 245:	3c 09                	cmp    $0x9,%al
 247:	77 1f                	ja     268 <atoi+0x30>
 249:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 24e:	83 c1 01             	add    $0x1,%ecx
 251:	8d 04 80             	lea    (%eax,%eax,4),%eax
 254:	0f be d2             	movsbl %dl,%edx
 257:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25b:	0f b6 11             	movzbl (%ecx),%edx
 25e:	8d 5a d0             	lea    -0x30(%edx),%ebx
 261:	80 fb 09             	cmp    $0x9,%bl
 264:	76 e8                	jbe    24e <atoi+0x16>
 266:	eb 05                	jmp    26d <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 268:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 26d:	5b                   	pop    %ebx
 26e:	5d                   	pop    %ebp
 26f:	c3                   	ret    

00000270 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	56                   	push   %esi
 274:	53                   	push   %ebx
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	8b 75 0c             	mov    0xc(%ebp),%esi
 27b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	85 db                	test   %ebx,%ebx
 280:	7e 13                	jle    295 <memmove+0x25>
 282:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 287:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 28b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 28e:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 291:	39 da                	cmp    %ebx,%edx
 293:	75 f2                	jne    287 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 295:	5b                   	pop    %ebx
 296:	5e                   	pop    %esi
 297:	5d                   	pop    %ebp
 298:	c3                   	ret    

00000299 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 299:	b8 01 00 00 00       	mov    $0x1,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <exit>:
SYSCALL(exit)
 2a1:	b8 02 00 00 00       	mov    $0x2,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <wait>:
SYSCALL(wait)
 2a9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <pipe>:
SYSCALL(pipe)
 2b1:	b8 04 00 00 00       	mov    $0x4,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <read>:
SYSCALL(read)
 2b9:	b8 05 00 00 00       	mov    $0x5,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <write>:
SYSCALL(write)
 2c1:	b8 10 00 00 00       	mov    $0x10,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <close>:
SYSCALL(close)
 2c9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <kill>:
SYSCALL(kill)
 2d1:	b8 06 00 00 00       	mov    $0x6,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <exec>:
SYSCALL(exec)
 2d9:	b8 07 00 00 00       	mov    $0x7,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <open>:
SYSCALL(open)
 2e1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <mknod>:
SYSCALL(mknod)
 2e9:	b8 11 00 00 00       	mov    $0x11,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <unlink>:
SYSCALL(unlink)
 2f1:	b8 12 00 00 00       	mov    $0x12,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <fstat>:
SYSCALL(fstat)
 2f9:	b8 08 00 00 00       	mov    $0x8,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <link>:
SYSCALL(link)
 301:	b8 13 00 00 00       	mov    $0x13,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <mkdir>:
SYSCALL(mkdir)
 309:	b8 14 00 00 00       	mov    $0x14,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <chdir>:
SYSCALL(chdir)
 311:	b8 09 00 00 00       	mov    $0x9,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <dup>:
SYSCALL(dup)
 319:	b8 0a 00 00 00       	mov    $0xa,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <getpid>:
SYSCALL(getpid)
 321:	b8 0b 00 00 00       	mov    $0xb,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <sbrk>:
SYSCALL(sbrk)
 329:	b8 0c 00 00 00       	mov    $0xc,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <sleep>:
SYSCALL(sleep)
 331:	b8 0d 00 00 00       	mov    $0xd,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <uptime>:
SYSCALL(uptime)
 339:	b8 0e 00 00 00       	mov    $0xe,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <setvariable>:
SYSCALL(setvariable)
 341:	b8 17 00 00 00       	mov    $0x17,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getvariable>:
SYSCALL(getvariable)
 349:	b8 18 00 00 00       	mov    $0x18,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <remvariable>:
SYSCALL(remvariable)
 351:	b8 19 00 00 00       	mov    $0x19,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <wait2>:
SYSCALL(wait2)
 359:	b8 1a 00 00 00       	mov    $0x1a,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <set_priority>:
SYSCALL(set_priority)
 361:	b8 1b 00 00 00       	mov    $0x1b,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	57                   	push   %edi
 36d:	56                   	push   %esi
 36e:	53                   	push   %ebx
 36f:	83 ec 3c             	sub    $0x3c,%esp
 372:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 375:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 379:	74 12                	je     38d <printint+0x24>
 37b:	89 d0                	mov    %edx,%eax
 37d:	c1 e8 1f             	shr    $0x1f,%eax
 380:	84 c0                	test   %al,%al
 382:	74 09                	je     38d <printint+0x24>
    neg = 1;
    x = -xx;
 384:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 386:	be 01 00 00 00       	mov    $0x1,%esi
 38b:	eb 05                	jmp    392 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38d:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 392:	bf 00 00 00 00       	mov    $0x0,%edi
 397:	eb 02                	jmp    39b <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 399:	89 df                	mov    %ebx,%edi
 39b:	8d 5f 01             	lea    0x1(%edi),%ebx
 39e:	89 d0                	mov    %edx,%eax
 3a0:	ba 00 00 00 00       	mov    $0x0,%edx
 3a5:	f7 f1                	div    %ecx
 3a7:	0f b6 92 64 07 00 00 	movzbl 0x764(%edx),%edx
 3ae:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	85 c0                	test   %eax,%eax
 3b6:	75 e1                	jne    399 <printint+0x30>
  if(neg)
 3b8:	85 f6                	test   %esi,%esi
 3ba:	74 08                	je     3c4 <printint+0x5b>
    buf[i++] = '-';
 3bc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c1:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3c4:	89 d8                	mov    %ebx,%eax
 3c6:	83 e8 01             	sub    $0x1,%eax
 3c9:	78 29                	js     3f4 <printint+0x8b>
 3cb:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 3ce:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d2:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3d5:	0f b6 03             	movzbl (%ebx),%eax
 3d8:	88 45 d7             	mov    %al,-0x29(%ebp)
 3db:	83 ec 04             	sub    $0x4,%esp
 3de:	6a 01                	push   $0x1
 3e0:	57                   	push   %edi
 3e1:	56                   	push   %esi
 3e2:	e8 da fe ff ff       	call   2c1 <write>
 3e7:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3ea:	83 c4 10             	add    $0x10,%esp
 3ed:	8d 45 d7             	lea    -0x29(%ebp),%eax
 3f0:	39 c3                	cmp    %eax,%ebx
 3f2:	75 e1                	jne    3d5 <printint+0x6c>
    putc(fd, buf[i]);
}
 3f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f7:	5b                   	pop    %ebx
 3f8:	5e                   	pop    %esi
 3f9:	5f                   	pop    %edi
 3fa:	5d                   	pop    %ebp
 3fb:	c3                   	ret    

000003fc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	57                   	push   %edi
 400:	56                   	push   %esi
 401:	53                   	push   %ebx
 402:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 405:	8b 75 0c             	mov    0xc(%ebp),%esi
 408:	0f b6 1e             	movzbl (%esi),%ebx
 40b:	84 db                	test   %bl,%bl
 40d:	0f 84 a6 01 00 00    	je     5b9 <printf+0x1bd>
 413:	83 c6 01             	add    $0x1,%esi
 416:	8d 45 10             	lea    0x10(%ebp),%eax
 419:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 41c:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 421:	0f be d3             	movsbl %bl,%edx
 424:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 427:	85 ff                	test   %edi,%edi
 429:	75 25                	jne    450 <printf+0x54>
      if(c == '%'){
 42b:	83 f8 25             	cmp    $0x25,%eax
 42e:	0f 84 6a 01 00 00    	je     59e <printf+0x1a2>
 434:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 437:	83 ec 04             	sub    $0x4,%esp
 43a:	6a 01                	push   $0x1
 43c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 43f:	50                   	push   %eax
 440:	ff 75 08             	pushl  0x8(%ebp)
 443:	e8 79 fe ff ff       	call   2c1 <write>
 448:	83 c4 10             	add    $0x10,%esp
 44b:	e9 5a 01 00 00       	jmp    5aa <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 450:	83 ff 25             	cmp    $0x25,%edi
 453:	0f 85 51 01 00 00    	jne    5aa <printf+0x1ae>
      if(c == 'd'){
 459:	83 f8 64             	cmp    $0x64,%eax
 45c:	75 2c                	jne    48a <printf+0x8e>
        printint(fd, *ap, 10, 1);
 45e:	83 ec 0c             	sub    $0xc,%esp
 461:	6a 01                	push   $0x1
 463:	b9 0a 00 00 00       	mov    $0xa,%ecx
 468:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 46b:	8b 17                	mov    (%edi),%edx
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	e8 f4 fe ff ff       	call   369 <printint>
        ap++;
 475:	89 f8                	mov    %edi,%eax
 477:	83 c0 04             	add    $0x4,%eax
 47a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 47d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 480:	bf 00 00 00 00       	mov    $0x0,%edi
 485:	e9 20 01 00 00       	jmp    5aa <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 490:	83 fa 70             	cmp    $0x70,%edx
 493:	75 2c                	jne    4c1 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 495:	83 ec 0c             	sub    $0xc,%esp
 498:	6a 00                	push   $0x0
 49a:	b9 10 00 00 00       	mov    $0x10,%ecx
 49f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a2:	8b 17                	mov    (%edi),%edx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	e8 bd fe ff ff       	call   369 <printint>
        ap++;
 4ac:	89 f8                	mov    %edi,%eax
 4ae:	83 c0 04             	add    $0x4,%eax
 4b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4b4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b7:	bf 00 00 00 00       	mov    $0x0,%edi
 4bc:	e9 e9 00 00 00       	jmp    5aa <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c1:	83 f8 73             	cmp    $0x73,%eax
 4c4:	75 52                	jne    518 <printf+0x11c>
        s = (char*)*ap;
 4c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4c9:	8b 18                	mov    (%eax),%ebx
        ap++;
 4cb:	83 c0 04             	add    $0x4,%eax
 4ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 4d1:	85 db                	test   %ebx,%ebx
          s = "(null)";
 4d3:	b8 5c 07 00 00       	mov    $0x75c,%eax
 4d8:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 4db:	0f b6 03             	movzbl (%ebx),%eax
 4de:	84 c0                	test   %al,%al
 4e0:	0f 84 bf 00 00 00    	je     5a5 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e6:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 4e9:	89 75 d0             	mov    %esi,-0x30(%ebp)
 4ec:	8b 75 08             	mov    0x8(%ebp),%esi
 4ef:	88 45 e3             	mov    %al,-0x1d(%ebp)
 4f2:	83 ec 04             	sub    $0x4,%esp
 4f5:	6a 01                	push   $0x1
 4f7:	57                   	push   %edi
 4f8:	56                   	push   %esi
 4f9:	e8 c3 fd ff ff       	call   2c1 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4fe:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 501:	0f b6 03             	movzbl (%ebx),%eax
 504:	83 c4 10             	add    $0x10,%esp
 507:	84 c0                	test   %al,%al
 509:	75 e4                	jne    4ef <printf+0xf3>
 50b:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50e:	bf 00 00 00 00       	mov    $0x0,%edi
 513:	e9 92 00 00 00       	jmp    5aa <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 518:	83 f8 63             	cmp    $0x63,%eax
 51b:	75 2b                	jne    548 <printf+0x14c>
 51d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 520:	8b 07                	mov    (%edi),%eax
 522:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 525:	83 ec 04             	sub    $0x4,%esp
 528:	6a 01                	push   $0x1
 52a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 8b fd ff ff       	call   2c1 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 536:	89 f8                	mov    %edi,%eax
 538:	83 c0 04             	add    $0x4,%eax
 53b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 541:	bf 00 00 00 00       	mov    $0x0,%edi
 546:	eb 62                	jmp    5aa <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 548:	83 f8 25             	cmp    $0x25,%eax
 54b:	75 1e                	jne    56b <printf+0x16f>
 54d:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 550:	83 ec 04             	sub    $0x4,%esp
 553:	6a 01                	push   $0x1
 555:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 558:	50                   	push   %eax
 559:	ff 75 08             	pushl  0x8(%ebp)
 55c:	e8 60 fd ff ff       	call   2c1 <write>
 561:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 564:	bf 00 00 00 00       	mov    $0x0,%edi
 569:	eb 3f                	jmp    5aa <printf+0x1ae>
 56b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56f:	83 ec 04             	sub    $0x4,%esp
 572:	6a 01                	push   $0x1
 574:	8d 45 e7             	lea    -0x19(%ebp),%eax
 577:	50                   	push   %eax
 578:	ff 75 08             	pushl  0x8(%ebp)
 57b:	e8 41 fd ff ff       	call   2c1 <write>
 580:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 583:	83 c4 0c             	add    $0xc,%esp
 586:	6a 01                	push   $0x1
 588:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 58b:	50                   	push   %eax
 58c:	ff 75 08             	pushl  0x8(%ebp)
 58f:	e8 2d fd ff ff       	call   2c1 <write>
 594:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 597:	bf 00 00 00 00       	mov    $0x0,%edi
 59c:	eb 0c                	jmp    5aa <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 59e:	bf 25 00 00 00       	mov    $0x25,%edi
 5a3:	eb 05                	jmp    5aa <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a5:	bf 00 00 00 00       	mov    $0x0,%edi
 5aa:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ad:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5b1:	84 db                	test   %bl,%bl
 5b3:	0f 85 68 fe ff ff    	jne    421 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bc:	5b                   	pop    %ebx
 5bd:	5e                   	pop    %esi
 5be:	5f                   	pop    %edi
 5bf:	5d                   	pop    %ebp
 5c0:	c3                   	ret    

000005c1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c1:	55                   	push   %ebp
 5c2:	89 e5                	mov    %esp,%ebp
 5c4:	57                   	push   %edi
 5c5:	56                   	push   %esi
 5c6:	53                   	push   %ebx
 5c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ca:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cd:	a1 c0 09 00 00       	mov    0x9c0,%eax
 5d2:	eb 0c                	jmp    5e0 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	8b 10                	mov    (%eax),%edx
 5d6:	39 d0                	cmp    %edx,%eax
 5d8:	72 04                	jb     5de <free+0x1d>
 5da:	39 d1                	cmp    %edx,%ecx
 5dc:	72 0c                	jb     5ea <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 5de:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e0:	39 c8                	cmp    %ecx,%eax
 5e2:	73 f0                	jae    5d4 <free+0x13>
 5e4:	8b 10                	mov    (%eax),%edx
 5e6:	39 d1                	cmp    %edx,%ecx
 5e8:	73 3e                	jae    628 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ea:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5ed:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5f0:	8b 10                	mov    (%eax),%edx
 5f2:	39 d7                	cmp    %edx,%edi
 5f4:	75 0f                	jne    605 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 5f6:	03 77 04             	add    0x4(%edi),%esi
 5f9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5fc:	8b 10                	mov    (%eax),%edx
 5fe:	8b 12                	mov    (%edx),%edx
 600:	89 53 f8             	mov    %edx,-0x8(%ebx)
 603:	eb 03                	jmp    608 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 605:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 608:	8b 50 04             	mov    0x4(%eax),%edx
 60b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 60e:	39 f1                	cmp    %esi,%ecx
 610:	75 0d                	jne    61f <free+0x5e>
    p->s.size += bp->s.size;
 612:	03 53 fc             	add    -0x4(%ebx),%edx
 615:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 618:	8b 53 f8             	mov    -0x8(%ebx),%edx
 61b:	89 10                	mov    %edx,(%eax)
 61d:	eb 02                	jmp    621 <free+0x60>
  } else
    p->s.ptr = bp;
 61f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 621:	a3 c0 09 00 00       	mov    %eax,0x9c0
}
 626:	eb 06                	jmp    62e <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 628:	39 d0                	cmp    %edx,%eax
 62a:	72 b2                	jb     5de <free+0x1d>
 62c:	eb bc                	jmp    5ea <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 62e:	5b                   	pop    %ebx
 62f:	5e                   	pop    %esi
 630:	5f                   	pop    %edi
 631:	5d                   	pop    %ebp
 632:	c3                   	ret    

00000633 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 633:	55                   	push   %ebp
 634:	89 e5                	mov    %esp,%ebp
 636:	57                   	push   %edi
 637:	56                   	push   %esi
 638:	53                   	push   %ebx
 639:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63c:	8b 45 08             	mov    0x8(%ebp),%eax
 63f:	8d 58 07             	lea    0x7(%eax),%ebx
 642:	c1 eb 03             	shr    $0x3,%ebx
 645:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 648:	8b 15 c0 09 00 00    	mov    0x9c0,%edx
 64e:	85 d2                	test   %edx,%edx
 650:	75 23                	jne    675 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 652:	c7 05 c0 09 00 00 c4 	movl   $0x9c4,0x9c0
 659:	09 00 00 
 65c:	c7 05 c4 09 00 00 c4 	movl   $0x9c4,0x9c4
 663:	09 00 00 
    base.s.size = 0;
 666:	c7 05 c8 09 00 00 00 	movl   $0x0,0x9c8
 66d:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 670:	ba c4 09 00 00       	mov    $0x9c4,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 675:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 677:	8b 48 04             	mov    0x4(%eax),%ecx
 67a:	39 cb                	cmp    %ecx,%ebx
 67c:	77 20                	ja     69e <malloc+0x6b>
      if(p->s.size == nunits)
 67e:	39 cb                	cmp    %ecx,%ebx
 680:	75 06                	jne    688 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 682:	8b 08                	mov    (%eax),%ecx
 684:	89 0a                	mov    %ecx,(%edx)
 686:	eb 0b                	jmp    693 <malloc+0x60>
      else {
        p->s.size -= nunits;
 688:	29 d9                	sub    %ebx,%ecx
 68a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 68d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 690:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 693:	89 15 c0 09 00 00    	mov    %edx,0x9c0
      return (void*)(p + 1);
 699:	83 c0 08             	add    $0x8,%eax
 69c:	eb 63                	jmp    701 <malloc+0xce>
 69e:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6a4:	be 00 10 00 00       	mov    $0x1000,%esi
 6a9:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6ac:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6b3:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6b5:	39 05 c0 09 00 00    	cmp    %eax,0x9c0
 6bb:	75 2d                	jne    6ea <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6bd:	83 ec 0c             	sub    $0xc,%esp
 6c0:	57                   	push   %edi
 6c1:	e8 63 fc ff ff       	call   329 <sbrk>
  if(p == (char*)-1)
 6c6:	83 c4 10             	add    $0x10,%esp
 6c9:	83 f8 ff             	cmp    $0xffffffff,%eax
 6cc:	74 27                	je     6f5 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6ce:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6d1:	83 ec 0c             	sub    $0xc,%esp
 6d4:	83 c0 08             	add    $0x8,%eax
 6d7:	50                   	push   %eax
 6d8:	e8 e4 fe ff ff       	call   5c1 <free>
  return freep;
 6dd:	8b 15 c0 09 00 00    	mov    0x9c0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6e3:	83 c4 10             	add    $0x10,%esp
 6e6:	85 d2                	test   %edx,%edx
 6e8:	74 12                	je     6fc <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ea:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ec:	8b 48 04             	mov    0x4(%eax),%ecx
 6ef:	39 cb                	cmp    %ecx,%ebx
 6f1:	77 c0                	ja     6b3 <malloc+0x80>
 6f3:	eb 89                	jmp    67e <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 6f5:	b8 00 00 00 00       	mov    $0x0,%eax
 6fa:	eb 05                	jmp    701 <malloc+0xce>
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 701:	8d 65 f4             	lea    -0xc(%ebp),%esp
 704:	5b                   	pop    %ebx
 705:	5e                   	pop    %esi
 706:	5f                   	pop    %edi
 707:	5d                   	pop    %ebp
 708:	c3                   	ret    
