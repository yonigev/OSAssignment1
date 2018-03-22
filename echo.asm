
_echo:     file format elf32-i386


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
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 0e                	jle    2c <main+0x2c>
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  23:	83 c3 01             	add    $0x1,%ebx
  26:	39 de                	cmp    %ebx,%esi
  28:	75 07                	jne    31 <main+0x31>
  2a:	eb 1f                	jmp    4b <main+0x4b>
  exit();
  2c:	e8 f8 01 00 00       	call   229 <exit>
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  31:	68 94 06 00 00       	push   $0x694
  36:	ff 74 9f fc          	pushl  -0x4(%edi,%ebx,4)
  3a:	68 96 06 00 00       	push   $0x696
  3f:	6a 01                	push   $0x1
  41:	e8 3e 03 00 00       	call   384 <printf>
  46:	83 c4 10             	add    $0x10,%esp
  49:	eb d8                	jmp    23 <main+0x23>
  4b:	68 9b 06 00 00       	push   $0x69b
  50:	ff 74 b7 fc          	pushl  -0x4(%edi,%esi,4)
  54:	68 96 06 00 00       	push   $0x696
  59:	6a 01                	push   $0x1
  5b:	e8 24 03 00 00       	call   384 <printf>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c7                	jmp    2c <main+0x2c>

00000065 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	53                   	push   %ebx
  69:	8b 45 08             	mov    0x8(%ebp),%eax
  6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6f:	89 c2                	mov    %eax,%edx
  71:	83 c2 01             	add    $0x1,%edx
  74:	83 c1 01             	add    $0x1,%ecx
  77:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  7b:	88 5a ff             	mov    %bl,-0x1(%edx)
  7e:	84 db                	test   %bl,%bl
  80:	75 ef                	jne    71 <strcpy+0xc>
    ;
  return os;
}
  82:	5b                   	pop    %ebx
  83:	5d                   	pop    %ebp
  84:	c3                   	ret    

00000085 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  85:	55                   	push   %ebp
  86:	89 e5                	mov    %esp,%ebp
  88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8e:	0f b6 01             	movzbl (%ecx),%eax
  91:	84 c0                	test   %al,%al
  93:	74 15                	je     aa <strcmp+0x25>
  95:	3a 02                	cmp    (%edx),%al
  97:	75 11                	jne    aa <strcmp+0x25>
    p++, q++;
  99:	83 c1 01             	add    $0x1,%ecx
  9c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  9f:	0f b6 01             	movzbl (%ecx),%eax
  a2:	84 c0                	test   %al,%al
  a4:	74 04                	je     aa <strcmp+0x25>
  a6:	3a 02                	cmp    (%edx),%al
  a8:	74 ef                	je     99 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  aa:	0f b6 c0             	movzbl %al,%eax
  ad:	0f b6 12             	movzbl (%edx),%edx
  b0:	29 d0                	sub    %edx,%eax
}
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strlen>:

uint
strlen(char *s)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  ba:	80 39 00             	cmpb   $0x0,(%ecx)
  bd:	74 12                	je     d1 <strlen+0x1d>
  bf:	ba 00 00 00 00       	mov    $0x0,%edx
  c4:	83 c2 01             	add    $0x1,%edx
  c7:	89 d0                	mov    %edx,%eax
  c9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  cd:	75 f5                	jne    c4 <strlen+0x10>
  cf:	eb 05                	jmp    d6 <strlen+0x22>
  d1:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
  d6:	5d                   	pop    %ebp
  d7:	c3                   	ret    

000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	57                   	push   %edi
  dc:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  df:	89 d7                	mov    %edx,%edi
  e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  e7:	fc                   	cld    
  e8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ea:	89 d0                	mov    %edx,%eax
  ec:	5f                   	pop    %edi
  ed:	5d                   	pop    %ebp
  ee:	c3                   	ret    

000000ef <strchr>:

char*
strchr(const char *s, char c)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	53                   	push   %ebx
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  f9:	0f b6 10             	movzbl (%eax),%edx
  fc:	84 d2                	test   %dl,%dl
  fe:	74 1d                	je     11d <strchr+0x2e>
 100:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 102:	38 d3                	cmp    %dl,%bl
 104:	75 06                	jne    10c <strchr+0x1d>
 106:	eb 1a                	jmp    122 <strchr+0x33>
 108:	38 ca                	cmp    %cl,%dl
 10a:	74 16                	je     122 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 10c:	83 c0 01             	add    $0x1,%eax
 10f:	0f b6 10             	movzbl (%eax),%edx
 112:	84 d2                	test   %dl,%dl
 114:	75 f2                	jne    108 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 116:	b8 00 00 00 00       	mov    $0x0,%eax
 11b:	eb 05                	jmp    122 <strchr+0x33>
 11d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 122:	5b                   	pop    %ebx
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <gets>:

char*
gets(char *buf, int max)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	57                   	push   %edi
 129:	56                   	push   %esi
 12a:	53                   	push   %ebx
 12b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 133:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	eb 29                	jmp    161 <gets+0x3c>
    cc = read(0, &c, 1);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	6a 01                	push   $0x1
 13d:	57                   	push   %edi
 13e:	6a 00                	push   $0x0
 140:	e8 fc 00 00 00       	call   241 <read>
    if(cc < 1)
 145:	83 c4 10             	add    $0x10,%esp
 148:	85 c0                	test   %eax,%eax
 14a:	7e 21                	jle    16d <gets+0x48>
      break;
    buf[i++] = c;
 14c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 150:	8b 55 08             	mov    0x8(%ebp),%edx
 153:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 157:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 159:	3c 0a                	cmp    $0xa,%al
 15b:	74 0e                	je     16b <gets+0x46>
 15d:	3c 0d                	cmp    $0xd,%al
 15f:	74 0a                	je     16b <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 161:	8d 5e 01             	lea    0x1(%esi),%ebx
 164:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 167:	7c cf                	jl     138 <gets+0x13>
 169:	eb 02                	jmp    16d <gets+0x48>
 16b:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 174:	8d 65 f4             	lea    -0xc(%ebp),%esp
 177:	5b                   	pop    %ebx
 178:	5e                   	pop    %esi
 179:	5f                   	pop    %edi
 17a:	5d                   	pop    %ebp
 17b:	c3                   	ret    

0000017c <stat>:

int
stat(char *n, struct stat *st)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	56                   	push   %esi
 180:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 181:	83 ec 08             	sub    $0x8,%esp
 184:	6a 00                	push   $0x0
 186:	ff 75 08             	pushl  0x8(%ebp)
 189:	e8 db 00 00 00       	call   269 <open>
  if(fd < 0)
 18e:	83 c4 10             	add    $0x10,%esp
 191:	85 c0                	test   %eax,%eax
 193:	78 1f                	js     1b4 <stat+0x38>
 195:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 197:	83 ec 08             	sub    $0x8,%esp
 19a:	ff 75 0c             	pushl  0xc(%ebp)
 19d:	50                   	push   %eax
 19e:	e8 de 00 00 00       	call   281 <fstat>
 1a3:	89 c6                	mov    %eax,%esi
  close(fd);
 1a5:	89 1c 24             	mov    %ebx,(%esp)
 1a8:	e8 a4 00 00 00       	call   251 <close>
  return r;
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	89 f0                	mov    %esi,%eax
 1b2:	eb 05                	jmp    1b9 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 1b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1bc:	5b                   	pop    %ebx
 1bd:	5e                   	pop    %esi
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <atoi>:

int
atoi(const char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c7:	0f b6 11             	movzbl (%ecx),%edx
 1ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 1cd:	3c 09                	cmp    $0x9,%al
 1cf:	77 1f                	ja     1f0 <atoi+0x30>
 1d1:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1d6:	83 c1 01             	add    $0x1,%ecx
 1d9:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1dc:	0f be d2             	movsbl %dl,%edx
 1df:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e3:	0f b6 11             	movzbl (%ecx),%edx
 1e6:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1e9:	80 fb 09             	cmp    $0x9,%bl
 1ec:	76 e8                	jbe    1d6 <atoi+0x16>
 1ee:	eb 05                	jmp    1f5 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 1f0:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 1f5:	5b                   	pop    %ebx
 1f6:	5d                   	pop    %ebp
 1f7:	c3                   	ret    

000001f8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	56                   	push   %esi
 1fc:	53                   	push   %ebx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	8b 75 0c             	mov    0xc(%ebp),%esi
 203:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 206:	85 db                	test   %ebx,%ebx
 208:	7e 13                	jle    21d <memmove+0x25>
 20a:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 20f:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 213:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 216:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 219:	39 da                	cmp    %ebx,%edx
 21b:	75 f2                	jne    20f <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 21d:	5b                   	pop    %ebx
 21e:	5e                   	pop    %esi
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret    

00000221 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 221:	b8 01 00 00 00       	mov    $0x1,%eax
 226:	cd 40                	int    $0x40
 228:	c3                   	ret    

00000229 <exit>:
SYSCALL(exit)
 229:	b8 02 00 00 00       	mov    $0x2,%eax
 22e:	cd 40                	int    $0x40
 230:	c3                   	ret    

00000231 <wait>:
SYSCALL(wait)
 231:	b8 03 00 00 00       	mov    $0x3,%eax
 236:	cd 40                	int    $0x40
 238:	c3                   	ret    

00000239 <pipe>:
SYSCALL(pipe)
 239:	b8 04 00 00 00       	mov    $0x4,%eax
 23e:	cd 40                	int    $0x40
 240:	c3                   	ret    

00000241 <read>:
SYSCALL(read)
 241:	b8 05 00 00 00       	mov    $0x5,%eax
 246:	cd 40                	int    $0x40
 248:	c3                   	ret    

00000249 <write>:
SYSCALL(write)
 249:	b8 10 00 00 00       	mov    $0x10,%eax
 24e:	cd 40                	int    $0x40
 250:	c3                   	ret    

00000251 <close>:
SYSCALL(close)
 251:	b8 15 00 00 00       	mov    $0x15,%eax
 256:	cd 40                	int    $0x40
 258:	c3                   	ret    

00000259 <kill>:
SYSCALL(kill)
 259:	b8 06 00 00 00       	mov    $0x6,%eax
 25e:	cd 40                	int    $0x40
 260:	c3                   	ret    

00000261 <exec>:
SYSCALL(exec)
 261:	b8 07 00 00 00       	mov    $0x7,%eax
 266:	cd 40                	int    $0x40
 268:	c3                   	ret    

00000269 <open>:
SYSCALL(open)
 269:	b8 0f 00 00 00       	mov    $0xf,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <mknod>:
SYSCALL(mknod)
 271:	b8 11 00 00 00       	mov    $0x11,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <unlink>:
SYSCALL(unlink)
 279:	b8 12 00 00 00       	mov    $0x12,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <fstat>:
SYSCALL(fstat)
 281:	b8 08 00 00 00       	mov    $0x8,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <link>:
SYSCALL(link)
 289:	b8 13 00 00 00       	mov    $0x13,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <mkdir>:
SYSCALL(mkdir)
 291:	b8 14 00 00 00       	mov    $0x14,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <chdir>:
SYSCALL(chdir)
 299:	b8 09 00 00 00       	mov    $0x9,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <dup>:
SYSCALL(dup)
 2a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <getpid>:
SYSCALL(getpid)
 2a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <sbrk>:
SYSCALL(sbrk)
 2b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <sleep>:
SYSCALL(sleep)
 2b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <uptime>:
SYSCALL(uptime)
 2c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <setvariable>:
SYSCALL(setvariable)
 2c9:	b8 17 00 00 00       	mov    $0x17,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <getvariable>:
SYSCALL(getvariable)
 2d1:	b8 18 00 00 00       	mov    $0x18,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <remvariable>:
SYSCALL(remvariable)
 2d9:	b8 19 00 00 00       	mov    $0x19,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <wait2>:
SYSCALL(wait2)
 2e1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <set_priority>:
SYSCALL(set_priority)
 2e9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	57                   	push   %edi
 2f5:	56                   	push   %esi
 2f6:	53                   	push   %ebx
 2f7:	83 ec 3c             	sub    $0x3c,%esp
 2fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 301:	74 12                	je     315 <printint+0x24>
 303:	89 d0                	mov    %edx,%eax
 305:	c1 e8 1f             	shr    $0x1f,%eax
 308:	84 c0                	test   %al,%al
 30a:	74 09                	je     315 <printint+0x24>
    neg = 1;
    x = -xx;
 30c:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 30e:	be 01 00 00 00       	mov    $0x1,%esi
 313:	eb 05                	jmp    31a <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 315:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 31a:	bf 00 00 00 00       	mov    $0x0,%edi
 31f:	eb 02                	jmp    323 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 321:	89 df                	mov    %ebx,%edi
 323:	8d 5f 01             	lea    0x1(%edi),%ebx
 326:	89 d0                	mov    %edx,%eax
 328:	ba 00 00 00 00       	mov    $0x0,%edx
 32d:	f7 f1                	div    %ecx
 32f:	0f b6 92 a4 06 00 00 	movzbl 0x6a4(%edx),%edx
 336:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 33a:	89 c2                	mov    %eax,%edx
 33c:	85 c0                	test   %eax,%eax
 33e:	75 e1                	jne    321 <printint+0x30>
  if(neg)
 340:	85 f6                	test   %esi,%esi
 342:	74 08                	je     34c <printint+0x5b>
    buf[i++] = '-';
 344:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 349:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 34c:	89 d8                	mov    %ebx,%eax
 34e:	83 e8 01             	sub    $0x1,%eax
 351:	78 29                	js     37c <printint+0x8b>
 353:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 356:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 35a:	8d 7d d7             	lea    -0x29(%ebp),%edi
 35d:	0f b6 03             	movzbl (%ebx),%eax
 360:	88 45 d7             	mov    %al,-0x29(%ebp)
 363:	83 ec 04             	sub    $0x4,%esp
 366:	6a 01                	push   $0x1
 368:	57                   	push   %edi
 369:	56                   	push   %esi
 36a:	e8 da fe ff ff       	call   249 <write>
 36f:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 372:	83 c4 10             	add    $0x10,%esp
 375:	8d 45 d7             	lea    -0x29(%ebp),%eax
 378:	39 c3                	cmp    %eax,%ebx
 37a:	75 e1                	jne    35d <printint+0x6c>
    putc(fd, buf[i]);
}
 37c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 37f:	5b                   	pop    %ebx
 380:	5e                   	pop    %esi
 381:	5f                   	pop    %edi
 382:	5d                   	pop    %ebp
 383:	c3                   	ret    

00000384 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	57                   	push   %edi
 388:	56                   	push   %esi
 389:	53                   	push   %ebx
 38a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 38d:	8b 75 0c             	mov    0xc(%ebp),%esi
 390:	0f b6 1e             	movzbl (%esi),%ebx
 393:	84 db                	test   %bl,%bl
 395:	0f 84 a6 01 00 00    	je     541 <printf+0x1bd>
 39b:	83 c6 01             	add    $0x1,%esi
 39e:	8d 45 10             	lea    0x10(%ebp),%eax
 3a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3a4:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 3a9:	0f be d3             	movsbl %bl,%edx
 3ac:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 3af:	85 ff                	test   %edi,%edi
 3b1:	75 25                	jne    3d8 <printf+0x54>
      if(c == '%'){
 3b3:	83 f8 25             	cmp    $0x25,%eax
 3b6:	0f 84 6a 01 00 00    	je     526 <printf+0x1a2>
 3bc:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3bf:	83 ec 04             	sub    $0x4,%esp
 3c2:	6a 01                	push   $0x1
 3c4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3c7:	50                   	push   %eax
 3c8:	ff 75 08             	pushl  0x8(%ebp)
 3cb:	e8 79 fe ff ff       	call   249 <write>
 3d0:	83 c4 10             	add    $0x10,%esp
 3d3:	e9 5a 01 00 00       	jmp    532 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3d8:	83 ff 25             	cmp    $0x25,%edi
 3db:	0f 85 51 01 00 00    	jne    532 <printf+0x1ae>
      if(c == 'd'){
 3e1:	83 f8 64             	cmp    $0x64,%eax
 3e4:	75 2c                	jne    412 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 3e6:	83 ec 0c             	sub    $0xc,%esp
 3e9:	6a 01                	push   $0x1
 3eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 3f3:	8b 17                	mov    (%edi),%edx
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	e8 f4 fe ff ff       	call   2f1 <printint>
        ap++;
 3fd:	89 f8                	mov    %edi,%eax
 3ff:	83 c0 04             	add    $0x4,%eax
 402:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 405:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 408:	bf 00 00 00 00       	mov    $0x0,%edi
 40d:	e9 20 01 00 00       	jmp    532 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 412:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 418:	83 fa 70             	cmp    $0x70,%edx
 41b:	75 2c                	jne    449 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 41d:	83 ec 0c             	sub    $0xc,%esp
 420:	6a 00                	push   $0x0
 422:	b9 10 00 00 00       	mov    $0x10,%ecx
 427:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 42a:	8b 17                	mov    (%edi),%edx
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
 42f:	e8 bd fe ff ff       	call   2f1 <printint>
        ap++;
 434:	89 f8                	mov    %edi,%eax
 436:	83 c0 04             	add    $0x4,%eax
 439:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 43c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 43f:	bf 00 00 00 00       	mov    $0x0,%edi
 444:	e9 e9 00 00 00       	jmp    532 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 449:	83 f8 73             	cmp    $0x73,%eax
 44c:	75 52                	jne    4a0 <printf+0x11c>
        s = (char*)*ap;
 44e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 451:	8b 18                	mov    (%eax),%ebx
        ap++;
 453:	83 c0 04             	add    $0x4,%eax
 456:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 459:	85 db                	test   %ebx,%ebx
          s = "(null)";
 45b:	b8 9d 06 00 00       	mov    $0x69d,%eax
 460:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 463:	0f b6 03             	movzbl (%ebx),%eax
 466:	84 c0                	test   %al,%al
 468:	0f 84 bf 00 00 00    	je     52d <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 471:	89 75 d0             	mov    %esi,-0x30(%ebp)
 474:	8b 75 08             	mov    0x8(%ebp),%esi
 477:	88 45 e3             	mov    %al,-0x1d(%ebp)
 47a:	83 ec 04             	sub    $0x4,%esp
 47d:	6a 01                	push   $0x1
 47f:	57                   	push   %edi
 480:	56                   	push   %esi
 481:	e8 c3 fd ff ff       	call   249 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 486:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 489:	0f b6 03             	movzbl (%ebx),%eax
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	84 c0                	test   %al,%al
 491:	75 e4                	jne    477 <printf+0xf3>
 493:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 496:	bf 00 00 00 00       	mov    $0x0,%edi
 49b:	e9 92 00 00 00       	jmp    532 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4a0:	83 f8 63             	cmp    $0x63,%eax
 4a3:	75 2b                	jne    4d0 <printf+0x14c>
 4a5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4a8:	8b 07                	mov    (%edi),%eax
 4aa:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4ad:	83 ec 04             	sub    $0x4,%esp
 4b0:	6a 01                	push   $0x1
 4b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 8b fd ff ff       	call   249 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 4be:	89 f8                	mov    %edi,%eax
 4c0:	83 c0 04             	add    $0x4,%eax
 4c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4c9:	bf 00 00 00 00       	mov    $0x0,%edi
 4ce:	eb 62                	jmp    532 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d0:	83 f8 25             	cmp    $0x25,%eax
 4d3:	75 1e                	jne    4f3 <printf+0x16f>
 4d5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4d8:	83 ec 04             	sub    $0x4,%esp
 4db:	6a 01                	push   $0x1
 4dd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	pushl  0x8(%ebp)
 4e4:	e8 60 fd ff ff       	call   249 <write>
 4e9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4ec:	bf 00 00 00 00       	mov    $0x0,%edi
 4f1:	eb 3f                	jmp    532 <printf+0x1ae>
 4f3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f7:	83 ec 04             	sub    $0x4,%esp
 4fa:	6a 01                	push   $0x1
 4fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ff:	50                   	push   %eax
 500:	ff 75 08             	pushl  0x8(%ebp)
 503:	e8 41 fd ff ff       	call   249 <write>
 508:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 50b:	83 c4 0c             	add    $0xc,%esp
 50e:	6a 01                	push   $0x1
 510:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 513:	50                   	push   %eax
 514:	ff 75 08             	pushl  0x8(%ebp)
 517:	e8 2d fd ff ff       	call   249 <write>
 51c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51f:	bf 00 00 00 00       	mov    $0x0,%edi
 524:	eb 0c                	jmp    532 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 526:	bf 25 00 00 00       	mov    $0x25,%edi
 52b:	eb 05                	jmp    532 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52d:	bf 00 00 00 00       	mov    $0x0,%edi
 532:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 535:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 539:	84 db                	test   %bl,%bl
 53b:	0f 85 68 fe ff ff    	jne    3a9 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 541:	8d 65 f4             	lea    -0xc(%ebp),%esp
 544:	5b                   	pop    %ebx
 545:	5e                   	pop    %esi
 546:	5f                   	pop    %edi
 547:	5d                   	pop    %ebp
 548:	c3                   	ret    

00000549 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 549:	55                   	push   %ebp
 54a:	89 e5                	mov    %esp,%ebp
 54c:	57                   	push   %edi
 54d:	56                   	push   %esi
 54e:	53                   	push   %ebx
 54f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 552:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 555:	a1 00 09 00 00       	mov    0x900,%eax
 55a:	eb 0c                	jmp    568 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 55c:	8b 10                	mov    (%eax),%edx
 55e:	39 d0                	cmp    %edx,%eax
 560:	72 04                	jb     566 <free+0x1d>
 562:	39 d1                	cmp    %edx,%ecx
 564:	72 0c                	jb     572 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 566:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 568:	39 c8                	cmp    %ecx,%eax
 56a:	73 f0                	jae    55c <free+0x13>
 56c:	8b 10                	mov    (%eax),%edx
 56e:	39 d1                	cmp    %edx,%ecx
 570:	73 3e                	jae    5b0 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 572:	8b 73 fc             	mov    -0x4(%ebx),%esi
 575:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 578:	8b 10                	mov    (%eax),%edx
 57a:	39 d7                	cmp    %edx,%edi
 57c:	75 0f                	jne    58d <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 57e:	03 77 04             	add    0x4(%edi),%esi
 581:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 584:	8b 10                	mov    (%eax),%edx
 586:	8b 12                	mov    (%edx),%edx
 588:	89 53 f8             	mov    %edx,-0x8(%ebx)
 58b:	eb 03                	jmp    590 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 58d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 590:	8b 50 04             	mov    0x4(%eax),%edx
 593:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 596:	39 f1                	cmp    %esi,%ecx
 598:	75 0d                	jne    5a7 <free+0x5e>
    p->s.size += bp->s.size;
 59a:	03 53 fc             	add    -0x4(%ebx),%edx
 59d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5a0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5a3:	89 10                	mov    %edx,(%eax)
 5a5:	eb 02                	jmp    5a9 <free+0x60>
  } else
    p->s.ptr = bp;
 5a7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5a9:	a3 00 09 00 00       	mov    %eax,0x900
}
 5ae:	eb 06                	jmp    5b6 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b0:	39 d0                	cmp    %edx,%eax
 5b2:	72 b2                	jb     566 <free+0x1d>
 5b4:	eb bc                	jmp    572 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 5b6:	5b                   	pop    %ebx
 5b7:	5e                   	pop    %esi
 5b8:	5f                   	pop    %edi
 5b9:	5d                   	pop    %ebp
 5ba:	c3                   	ret    

000005bb <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	57                   	push   %edi
 5bf:	56                   	push   %esi
 5c0:	53                   	push   %ebx
 5c1:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	8d 58 07             	lea    0x7(%eax),%ebx
 5ca:	c1 eb 03             	shr    $0x3,%ebx
 5cd:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5d0:	8b 15 00 09 00 00    	mov    0x900,%edx
 5d6:	85 d2                	test   %edx,%edx
 5d8:	75 23                	jne    5fd <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 5da:	c7 05 00 09 00 00 04 	movl   $0x904,0x900
 5e1:	09 00 00 
 5e4:	c7 05 04 09 00 00 04 	movl   $0x904,0x904
 5eb:	09 00 00 
    base.s.size = 0;
 5ee:	c7 05 08 09 00 00 00 	movl   $0x0,0x908
 5f5:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 5f8:	ba 04 09 00 00       	mov    $0x904,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5fd:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 5ff:	8b 48 04             	mov    0x4(%eax),%ecx
 602:	39 cb                	cmp    %ecx,%ebx
 604:	77 20                	ja     626 <malloc+0x6b>
      if(p->s.size == nunits)
 606:	39 cb                	cmp    %ecx,%ebx
 608:	75 06                	jne    610 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 60a:	8b 08                	mov    (%eax),%ecx
 60c:	89 0a                	mov    %ecx,(%edx)
 60e:	eb 0b                	jmp    61b <malloc+0x60>
      else {
        p->s.size -= nunits;
 610:	29 d9                	sub    %ebx,%ecx
 612:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 615:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 618:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 61b:	89 15 00 09 00 00    	mov    %edx,0x900
      return (void*)(p + 1);
 621:	83 c0 08             	add    $0x8,%eax
 624:	eb 63                	jmp    689 <malloc+0xce>
 626:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 62c:	be 00 10 00 00       	mov    $0x1000,%esi
 631:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 634:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 63b:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 63d:	39 05 00 09 00 00    	cmp    %eax,0x900
 643:	75 2d                	jne    672 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 645:	83 ec 0c             	sub    $0xc,%esp
 648:	57                   	push   %edi
 649:	e8 63 fc ff ff       	call   2b1 <sbrk>
  if(p == (char*)-1)
 64e:	83 c4 10             	add    $0x10,%esp
 651:	83 f8 ff             	cmp    $0xffffffff,%eax
 654:	74 27                	je     67d <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 656:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 659:	83 ec 0c             	sub    $0xc,%esp
 65c:	83 c0 08             	add    $0x8,%eax
 65f:	50                   	push   %eax
 660:	e8 e4 fe ff ff       	call   549 <free>
  return freep;
 665:	8b 15 00 09 00 00    	mov    0x900,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	85 d2                	test   %edx,%edx
 670:	74 12                	je     684 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 672:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 674:	8b 48 04             	mov    0x4(%eax),%ecx
 677:	39 cb                	cmp    %ecx,%ebx
 679:	77 c0                	ja     63b <malloc+0x80>
 67b:	eb 89                	jmp    606 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 67d:	b8 00 00 00 00       	mov    $0x0,%eax
 682:	eb 05                	jmp    689 <malloc+0xce>
 684:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 689:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68c:	5b                   	pop    %ebx
 68d:	5e                   	pop    %esi
 68e:	5f                   	pop    %edi
 68f:	5d                   	pop    %ebp
 690:	c3                   	ret    
