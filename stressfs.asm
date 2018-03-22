
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

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
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  1e:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  25:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2b:	68 40 07 00 00       	push   $0x740
  30:	6a 01                	push   $0x1
  32:	e8 f9 03 00 00       	call   430 <printf>
  memset(data, 'a', sizeof(data));
  37:	83 c4 0c             	add    $0xc,%esp
  3a:	68 00 02 00 00       	push   $0x200
  3f:	6a 61                	push   $0x61
  41:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  47:	50                   	push   %eax
  48:	e8 37 01 00 00       	call   184 <memset>
  4d:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  50:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(fork() > 0)
  55:	e8 73 02 00 00       	call   2cd <fork>
  5a:	85 c0                	test   %eax,%eax
  5c:	7f 08                	jg     66 <main+0x66>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  5e:	83 c3 01             	add    $0x1,%ebx
  61:	83 fb 04             	cmp    $0x4,%ebx
  64:	75 ef                	jne    55 <main+0x55>
    if(fork() > 0)
      break;

  printf(1, "write %d\n", i);
  66:	83 ec 04             	sub    $0x4,%esp
  69:	53                   	push   %ebx
  6a:	68 53 07 00 00       	push   $0x753
  6f:	6a 01                	push   $0x1
  71:	e8 ba 03 00 00       	call   430 <printf>

  path[8] += i;
  76:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  79:	83 c4 08             	add    $0x8,%esp
  7c:	68 02 02 00 00       	push   $0x202
  81:	8d 45 de             	lea    -0x22(%ebp),%eax
  84:	50                   	push   %eax
  85:	e8 8b 02 00 00       	call   315 <open>
  8a:	89 c6                	mov    %eax,%esi
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	bb 14 00 00 00       	mov    $0x14,%ebx
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  94:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	68 00 02 00 00       	push   $0x200
  a2:	57                   	push   %edi
  a3:	56                   	push   %esi
  a4:	e8 4c 02 00 00       	call   2f5 <write>

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	83 eb 01             	sub    $0x1,%ebx
  af:	75 e9                	jne    9a <main+0x9a>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  b1:	83 ec 0c             	sub    $0xc,%esp
  b4:	56                   	push   %esi
  b5:	e8 43 02 00 00       	call   2fd <close>

  printf(1, "read\n");
  ba:	83 c4 08             	add    $0x8,%esp
  bd:	68 5d 07 00 00       	push   $0x75d
  c2:	6a 01                	push   $0x1
  c4:	e8 67 03 00 00       	call   430 <printf>

  fd = open(path, O_RDONLY);
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	6a 00                	push   $0x0
  ce:	8d 45 de             	lea    -0x22(%ebp),%eax
  d1:	50                   	push   %eax
  d2:	e8 3e 02 00 00       	call   315 <open>
  d7:	89 c6                	mov    %eax,%esi
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e1:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	68 00 02 00 00       	push   $0x200
  ef:	57                   	push   %edi
  f0:	56                   	push   %esi
  f1:	e8 f7 01 00 00       	call   2ed <read>
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	83 eb 01             	sub    $0x1,%ebx
  fc:	75 e9                	jne    e7 <main+0xe7>
    read(fd, data, sizeof(data));
  close(fd);
  fe:	83 ec 0c             	sub    $0xc,%esp
 101:	56                   	push   %esi
 102:	e8 f6 01 00 00       	call   2fd <close>

  wait();
 107:	e8 d1 01 00 00       	call   2dd <wait>

  exit();
 10c:	e8 c4 01 00 00       	call   2d5 <exit>

00000111 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	53                   	push   %ebx
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11b:	89 c2                	mov    %eax,%edx
 11d:	83 c2 01             	add    $0x1,%edx
 120:	83 c1 01             	add    $0x1,%ecx
 123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 127:	88 5a ff             	mov    %bl,-0x1(%edx)
 12a:	84 db                	test   %bl,%bl
 12c:	75 ef                	jne    11d <strcpy+0xc>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	8b 4d 08             	mov    0x8(%ebp),%ecx
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 13a:	0f b6 01             	movzbl (%ecx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	74 15                	je     156 <strcmp+0x25>
 141:	3a 02                	cmp    (%edx),%al
 143:	75 11                	jne    156 <strcmp+0x25>
    p++, q++;
 145:	83 c1 01             	add    $0x1,%ecx
 148:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 14b:	0f b6 01             	movzbl (%ecx),%eax
 14e:	84 c0                	test   %al,%al
 150:	74 04                	je     156 <strcmp+0x25>
 152:	3a 02                	cmp    (%edx),%al
 154:	74 ef                	je     145 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 156:	0f b6 c0             	movzbl %al,%eax
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	29 d0                	sub    %edx,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 12                	je     17d <strlen+0x1d>
 16b:	ba 00 00 00 00       	mov    $0x0,%edx
 170:	83 c2 01             	add    $0x1,%edx
 173:	89 d0                	mov    %edx,%eax
 175:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 179:	75 f5                	jne    170 <strlen+0x10>
 17b:	eb 05                	jmp    182 <strlen+0x22>
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    

00000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
 188:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 18b:	89 d7                	mov    %edx,%edi
 18d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	fc                   	cld    
 194:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 196:	89 d0                	mov    %edx,%eax
 198:	5f                   	pop    %edi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <strchr>:

char*
strchr(const char *s, char c)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	53                   	push   %ebx
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1a5:	0f b6 10             	movzbl (%eax),%edx
 1a8:	84 d2                	test   %dl,%dl
 1aa:	74 1d                	je     1c9 <strchr+0x2e>
 1ac:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 1ae:	38 d3                	cmp    %dl,%bl
 1b0:	75 06                	jne    1b8 <strchr+0x1d>
 1b2:	eb 1a                	jmp    1ce <strchr+0x33>
 1b4:	38 ca                	cmp    %cl,%dl
 1b6:	74 16                	je     1ce <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	0f b6 10             	movzbl (%eax),%edx
 1be:	84 d2                	test   %dl,%dl
 1c0:	75 f2                	jne    1b4 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 1c2:	b8 00 00 00 00       	mov    $0x0,%eax
 1c7:	eb 05                	jmp    1ce <strchr+0x33>
 1c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ce:	5b                   	pop    %ebx
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <gets>:

char*
gets(char *buf, int max)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	57                   	push   %edi
 1d5:	56                   	push   %esi
 1d6:	53                   	push   %ebx
 1d7:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1df:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	eb 29                	jmp    20d <gets+0x3c>
    cc = read(0, &c, 1);
 1e4:	83 ec 04             	sub    $0x4,%esp
 1e7:	6a 01                	push   $0x1
 1e9:	57                   	push   %edi
 1ea:	6a 00                	push   $0x0
 1ec:	e8 fc 00 00 00       	call   2ed <read>
    if(cc < 1)
 1f1:	83 c4 10             	add    $0x10,%esp
 1f4:	85 c0                	test   %eax,%eax
 1f6:	7e 21                	jle    219 <gets+0x48>
      break;
    buf[i++] = c;
 1f8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1fc:	8b 55 08             	mov    0x8(%ebp),%edx
 1ff:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 203:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 205:	3c 0a                	cmp    $0xa,%al
 207:	74 0e                	je     217 <gets+0x46>
 209:	3c 0d                	cmp    $0xd,%al
 20b:	74 0a                	je     217 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	8d 5e 01             	lea    0x1(%esi),%ebx
 210:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 213:	7c cf                	jl     1e4 <gets+0x13>
 215:	eb 02                	jmp    219 <gets+0x48>
 217:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 220:	8d 65 f4             	lea    -0xc(%ebp),%esp
 223:	5b                   	pop    %ebx
 224:	5e                   	pop    %esi
 225:	5f                   	pop    %edi
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    

00000228 <stat>:

int
stat(char *n, struct stat *st)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	56                   	push   %esi
 22c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22d:	83 ec 08             	sub    $0x8,%esp
 230:	6a 00                	push   $0x0
 232:	ff 75 08             	pushl  0x8(%ebp)
 235:	e8 db 00 00 00       	call   315 <open>
  if(fd < 0)
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	85 c0                	test   %eax,%eax
 23f:	78 1f                	js     260 <stat+0x38>
 241:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 243:	83 ec 08             	sub    $0x8,%esp
 246:	ff 75 0c             	pushl  0xc(%ebp)
 249:	50                   	push   %eax
 24a:	e8 de 00 00 00       	call   32d <fstat>
 24f:	89 c6                	mov    %eax,%esi
  close(fd);
 251:	89 1c 24             	mov    %ebx,(%esp)
 254:	e8 a4 00 00 00       	call   2fd <close>
  return r;
 259:	83 c4 10             	add    $0x10,%esp
 25c:	89 f0                	mov    %esi,%eax
 25e:	eb 05                	jmp    265 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 265:	8d 65 f8             	lea    -0x8(%ebp),%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    

0000026c <atoi>:

int
atoi(const char *s)
{
 26c:	55                   	push   %ebp
 26d:	89 e5                	mov    %esp,%ebp
 26f:	53                   	push   %ebx
 270:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 273:	0f b6 11             	movzbl (%ecx),%edx
 276:	8d 42 d0             	lea    -0x30(%edx),%eax
 279:	3c 09                	cmp    $0x9,%al
 27b:	77 1f                	ja     29c <atoi+0x30>
 27d:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 282:	83 c1 01             	add    $0x1,%ecx
 285:	8d 04 80             	lea    (%eax,%eax,4),%eax
 288:	0f be d2             	movsbl %dl,%edx
 28b:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28f:	0f b6 11             	movzbl (%ecx),%edx
 292:	8d 5a d0             	lea    -0x30(%edx),%ebx
 295:	80 fb 09             	cmp    $0x9,%bl
 298:	76 e8                	jbe    282 <atoi+0x16>
 29a:	eb 05                	jmp    2a1 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 29c:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 2a1:	5b                   	pop    %ebx
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret    

000002a4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	56                   	push   %esi
 2a8:	53                   	push   %ebx
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	8b 75 0c             	mov    0xc(%ebp),%esi
 2af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b2:	85 db                	test   %ebx,%ebx
 2b4:	7e 13                	jle    2c9 <memmove+0x25>
 2b6:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2bb:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bf:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2c2:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c5:	39 da                	cmp    %ebx,%edx
 2c7:	75 f2                	jne    2bb <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 2c9:	5b                   	pop    %ebx
 2ca:	5e                   	pop    %esi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    

000002cd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cd:	b8 01 00 00 00       	mov    $0x1,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <exit>:
SYSCALL(exit)
 2d5:	b8 02 00 00 00       	mov    $0x2,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <wait>:
SYSCALL(wait)
 2dd:	b8 03 00 00 00       	mov    $0x3,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <pipe>:
SYSCALL(pipe)
 2e5:	b8 04 00 00 00       	mov    $0x4,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <read>:
SYSCALL(read)
 2ed:	b8 05 00 00 00       	mov    $0x5,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <write>:
SYSCALL(write)
 2f5:	b8 10 00 00 00       	mov    $0x10,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <close>:
SYSCALL(close)
 2fd:	b8 15 00 00 00       	mov    $0x15,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <kill>:
SYSCALL(kill)
 305:	b8 06 00 00 00       	mov    $0x6,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <exec>:
SYSCALL(exec)
 30d:	b8 07 00 00 00       	mov    $0x7,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <open>:
SYSCALL(open)
 315:	b8 0f 00 00 00       	mov    $0xf,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <mknod>:
SYSCALL(mknod)
 31d:	b8 11 00 00 00       	mov    $0x11,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <unlink>:
SYSCALL(unlink)
 325:	b8 12 00 00 00       	mov    $0x12,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <fstat>:
SYSCALL(fstat)
 32d:	b8 08 00 00 00       	mov    $0x8,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <link>:
SYSCALL(link)
 335:	b8 13 00 00 00       	mov    $0x13,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <mkdir>:
SYSCALL(mkdir)
 33d:	b8 14 00 00 00       	mov    $0x14,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <chdir>:
SYSCALL(chdir)
 345:	b8 09 00 00 00       	mov    $0x9,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <dup>:
SYSCALL(dup)
 34d:	b8 0a 00 00 00       	mov    $0xa,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <getpid>:
SYSCALL(getpid)
 355:	b8 0b 00 00 00       	mov    $0xb,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <sbrk>:
SYSCALL(sbrk)
 35d:	b8 0c 00 00 00       	mov    $0xc,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <sleep>:
SYSCALL(sleep)
 365:	b8 0d 00 00 00       	mov    $0xd,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <uptime>:
SYSCALL(uptime)
 36d:	b8 0e 00 00 00       	mov    $0xe,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <setvariable>:
SYSCALL(setvariable)
 375:	b8 17 00 00 00       	mov    $0x17,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <getvariable>:
SYSCALL(getvariable)
 37d:	b8 18 00 00 00       	mov    $0x18,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <remvariable>:
SYSCALL(remvariable)
 385:	b8 19 00 00 00       	mov    $0x19,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <wait2>:
SYSCALL(wait2)
 38d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <set_priority>:
SYSCALL(set_priority)
 395:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 39d:	55                   	push   %ebp
 39e:	89 e5                	mov    %esp,%ebp
 3a0:	57                   	push   %edi
 3a1:	56                   	push   %esi
 3a2:	53                   	push   %ebx
 3a3:	83 ec 3c             	sub    $0x3c,%esp
 3a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ad:	74 12                	je     3c1 <printint+0x24>
 3af:	89 d0                	mov    %edx,%eax
 3b1:	c1 e8 1f             	shr    $0x1f,%eax
 3b4:	84 c0                	test   %al,%al
 3b6:	74 09                	je     3c1 <printint+0x24>
    neg = 1;
    x = -xx;
 3b8:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 3ba:	be 01 00 00 00       	mov    $0x1,%esi
 3bf:	eb 05                	jmp    3c6 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c1:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3c6:	bf 00 00 00 00       	mov    $0x0,%edi
 3cb:	eb 02                	jmp    3cf <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3cd:	89 df                	mov    %ebx,%edi
 3cf:	8d 5f 01             	lea    0x1(%edi),%ebx
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f1                	div    %ecx
 3db:	0f b6 92 6c 07 00 00 	movzbl 0x76c(%edx),%edx
 3e2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3e6:	89 c2                	mov    %eax,%edx
 3e8:	85 c0                	test   %eax,%eax
 3ea:	75 e1                	jne    3cd <printint+0x30>
  if(neg)
 3ec:	85 f6                	test   %esi,%esi
 3ee:	74 08                	je     3f8 <printint+0x5b>
    buf[i++] = '-';
 3f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3f5:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3f8:	89 d8                	mov    %ebx,%eax
 3fa:	83 e8 01             	sub    $0x1,%eax
 3fd:	78 29                	js     428 <printint+0x8b>
 3ff:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 402:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 406:	8d 7d d7             	lea    -0x29(%ebp),%edi
 409:	0f b6 03             	movzbl (%ebx),%eax
 40c:	88 45 d7             	mov    %al,-0x29(%ebp)
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	6a 01                	push   $0x1
 414:	57                   	push   %edi
 415:	56                   	push   %esi
 416:	e8 da fe ff ff       	call   2f5 <write>
 41b:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 41e:	83 c4 10             	add    $0x10,%esp
 421:	8d 45 d7             	lea    -0x29(%ebp),%eax
 424:	39 c3                	cmp    %eax,%ebx
 426:	75 e1                	jne    409 <printint+0x6c>
    putc(fd, buf[i]);
}
 428:	8d 65 f4             	lea    -0xc(%ebp),%esp
 42b:	5b                   	pop    %ebx
 42c:	5e                   	pop    %esi
 42d:	5f                   	pop    %edi
 42e:	5d                   	pop    %ebp
 42f:	c3                   	ret    

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 439:	8b 75 0c             	mov    0xc(%ebp),%esi
 43c:	0f b6 1e             	movzbl (%esi),%ebx
 43f:	84 db                	test   %bl,%bl
 441:	0f 84 a6 01 00 00    	je     5ed <printf+0x1bd>
 447:	83 c6 01             	add    $0x1,%esi
 44a:	8d 45 10             	lea    0x10(%ebp),%eax
 44d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 450:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 455:	0f be d3             	movsbl %bl,%edx
 458:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 45b:	85 ff                	test   %edi,%edi
 45d:	75 25                	jne    484 <printf+0x54>
      if(c == '%'){
 45f:	83 f8 25             	cmp    $0x25,%eax
 462:	0f 84 6a 01 00 00    	je     5d2 <printf+0x1a2>
 468:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46b:	83 ec 04             	sub    $0x4,%esp
 46e:	6a 01                	push   $0x1
 470:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 473:	50                   	push   %eax
 474:	ff 75 08             	pushl  0x8(%ebp)
 477:	e8 79 fe ff ff       	call   2f5 <write>
 47c:	83 c4 10             	add    $0x10,%esp
 47f:	e9 5a 01 00 00       	jmp    5de <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 484:	83 ff 25             	cmp    $0x25,%edi
 487:	0f 85 51 01 00 00    	jne    5de <printf+0x1ae>
      if(c == 'd'){
 48d:	83 f8 64             	cmp    $0x64,%eax
 490:	75 2c                	jne    4be <printf+0x8e>
        printint(fd, *ap, 10, 1);
 492:	83 ec 0c             	sub    $0xc,%esp
 495:	6a 01                	push   $0x1
 497:	b9 0a 00 00 00       	mov    $0xa,%ecx
 49c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 49f:	8b 17                	mov    (%edi),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	e8 f4 fe ff ff       	call   39d <printint>
        ap++;
 4a9:	89 f8                	mov    %edi,%eax
 4ab:	83 c0 04             	add    $0x4,%eax
 4ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4b1:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b4:	bf 00 00 00 00       	mov    $0x0,%edi
 4b9:	e9 20 01 00 00       	jmp    5de <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4be:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4c4:	83 fa 70             	cmp    $0x70,%edx
 4c7:	75 2c                	jne    4f5 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 4c9:	83 ec 0c             	sub    $0xc,%esp
 4cc:	6a 00                	push   $0x0
 4ce:	b9 10 00 00 00       	mov    $0x10,%ecx
 4d3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d6:	8b 17                	mov    (%edi),%edx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	e8 bd fe ff ff       	call   39d <printint>
        ap++;
 4e0:	89 f8                	mov    %edi,%eax
 4e2:	83 c0 04             	add    $0x4,%eax
 4e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4e8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4eb:	bf 00 00 00 00       	mov    $0x0,%edi
 4f0:	e9 e9 00 00 00       	jmp    5de <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4f5:	83 f8 73             	cmp    $0x73,%eax
 4f8:	75 52                	jne    54c <printf+0x11c>
        s = (char*)*ap;
 4fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4fd:	8b 18                	mov    (%eax),%ebx
        ap++;
 4ff:	83 c0 04             	add    $0x4,%eax
 502:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 505:	85 db                	test   %ebx,%ebx
          s = "(null)";
 507:	b8 63 07 00 00       	mov    $0x763,%eax
 50c:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 50f:	0f b6 03             	movzbl (%ebx),%eax
 512:	84 c0                	test   %al,%al
 514:	0f 84 bf 00 00 00    	je     5d9 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51a:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 51d:	89 75 d0             	mov    %esi,-0x30(%ebp)
 520:	8b 75 08             	mov    0x8(%ebp),%esi
 523:	88 45 e3             	mov    %al,-0x1d(%ebp)
 526:	83 ec 04             	sub    $0x4,%esp
 529:	6a 01                	push   $0x1
 52b:	57                   	push   %edi
 52c:	56                   	push   %esi
 52d:	e8 c3 fd ff ff       	call   2f5 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 532:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 535:	0f b6 03             	movzbl (%ebx),%eax
 538:	83 c4 10             	add    $0x10,%esp
 53b:	84 c0                	test   %al,%al
 53d:	75 e4                	jne    523 <printf+0xf3>
 53f:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 542:	bf 00 00 00 00       	mov    $0x0,%edi
 547:	e9 92 00 00 00       	jmp    5de <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 54c:	83 f8 63             	cmp    $0x63,%eax
 54f:	75 2b                	jne    57c <printf+0x14c>
 551:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 554:	8b 07                	mov    (%edi),%eax
 556:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 559:	83 ec 04             	sub    $0x4,%esp
 55c:	6a 01                	push   $0x1
 55e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 561:	50                   	push   %eax
 562:	ff 75 08             	pushl  0x8(%ebp)
 565:	e8 8b fd ff ff       	call   2f5 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 56a:	89 f8                	mov    %edi,%eax
 56c:	83 c0 04             	add    $0x4,%eax
 56f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 572:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 575:	bf 00 00 00 00       	mov    $0x0,%edi
 57a:	eb 62                	jmp    5de <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 57c:	83 f8 25             	cmp    $0x25,%eax
 57f:	75 1e                	jne    59f <printf+0x16f>
 581:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 584:	83 ec 04             	sub    $0x4,%esp
 587:	6a 01                	push   $0x1
 589:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 58c:	50                   	push   %eax
 58d:	ff 75 08             	pushl  0x8(%ebp)
 590:	e8 60 fd ff ff       	call   2f5 <write>
 595:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 598:	bf 00 00 00 00       	mov    $0x0,%edi
 59d:	eb 3f                	jmp    5de <printf+0x1ae>
 59f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a3:	83 ec 04             	sub    $0x4,%esp
 5a6:	6a 01                	push   $0x1
 5a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 41 fd ff ff       	call   2f5 <write>
 5b4:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5b7:	83 c4 0c             	add    $0xc,%esp
 5ba:	6a 01                	push   $0x1
 5bc:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	pushl  0x8(%ebp)
 5c3:	e8 2d fd ff ff       	call   2f5 <write>
 5c8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5cb:	bf 00 00 00 00       	mov    $0x0,%edi
 5d0:	eb 0c                	jmp    5de <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5d2:	bf 25 00 00 00       	mov    $0x25,%edi
 5d7:	eb 05                	jmp    5de <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d9:	bf 00 00 00 00       	mov    $0x0,%edi
 5de:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5e1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5e5:	84 db                	test   %bl,%bl
 5e7:	0f 85 68 fe ff ff    	jne    455 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5f0:	5b                   	pop    %ebx
 5f1:	5e                   	pop    %esi
 5f2:	5f                   	pop    %edi
 5f3:	5d                   	pop    %ebp
 5f4:	c3                   	ret    

000005f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f5:	55                   	push   %ebp
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 601:	a1 c8 09 00 00       	mov    0x9c8,%eax
 606:	eb 0c                	jmp    614 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 608:	8b 10                	mov    (%eax),%edx
 60a:	39 d0                	cmp    %edx,%eax
 60c:	72 04                	jb     612 <free+0x1d>
 60e:	39 d1                	cmp    %edx,%ecx
 610:	72 0c                	jb     61e <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 612:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	39 c8                	cmp    %ecx,%eax
 616:	73 f0                	jae    608 <free+0x13>
 618:	8b 10                	mov    (%eax),%edx
 61a:	39 d1                	cmp    %edx,%ecx
 61c:	73 3e                	jae    65c <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 621:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 624:	8b 10                	mov    (%eax),%edx
 626:	39 d7                	cmp    %edx,%edi
 628:	75 0f                	jne    639 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 62a:	03 77 04             	add    0x4(%edi),%esi
 62d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 630:	8b 10                	mov    (%eax),%edx
 632:	8b 12                	mov    (%edx),%edx
 634:	89 53 f8             	mov    %edx,-0x8(%ebx)
 637:	eb 03                	jmp    63c <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 639:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63c:	8b 50 04             	mov    0x4(%eax),%edx
 63f:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 642:	39 f1                	cmp    %esi,%ecx
 644:	75 0d                	jne    653 <free+0x5e>
    p->s.size += bp->s.size;
 646:	03 53 fc             	add    -0x4(%ebx),%edx
 649:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 64c:	8b 53 f8             	mov    -0x8(%ebx),%edx
 64f:	89 10                	mov    %edx,(%eax)
 651:	eb 02                	jmp    655 <free+0x60>
  } else
    p->s.ptr = bp;
 653:	89 08                	mov    %ecx,(%eax)
  freep = p;
 655:	a3 c8 09 00 00       	mov    %eax,0x9c8
}
 65a:	eb 06                	jmp    662 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	39 d0                	cmp    %edx,%eax
 65e:	72 b2                	jb     612 <free+0x1d>
 660:	eb bc                	jmp    61e <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 662:	5b                   	pop    %ebx
 663:	5e                   	pop    %esi
 664:	5f                   	pop    %edi
 665:	5d                   	pop    %ebp
 666:	c3                   	ret    

00000667 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	57                   	push   %edi
 66b:	56                   	push   %esi
 66c:	53                   	push   %ebx
 66d:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	8d 58 07             	lea    0x7(%eax),%ebx
 676:	c1 eb 03             	shr    $0x3,%ebx
 679:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 67c:	8b 15 c8 09 00 00    	mov    0x9c8,%edx
 682:	85 d2                	test   %edx,%edx
 684:	75 23                	jne    6a9 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 686:	c7 05 c8 09 00 00 cc 	movl   $0x9cc,0x9c8
 68d:	09 00 00 
 690:	c7 05 cc 09 00 00 cc 	movl   $0x9cc,0x9cc
 697:	09 00 00 
    base.s.size = 0;
 69a:	c7 05 d0 09 00 00 00 	movl   $0x0,0x9d0
 6a1:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6a4:	ba cc 09 00 00       	mov    $0x9cc,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6a9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ab:	8b 48 04             	mov    0x4(%eax),%ecx
 6ae:	39 cb                	cmp    %ecx,%ebx
 6b0:	77 20                	ja     6d2 <malloc+0x6b>
      if(p->s.size == nunits)
 6b2:	39 cb                	cmp    %ecx,%ebx
 6b4:	75 06                	jne    6bc <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 6b6:	8b 08                	mov    (%eax),%ecx
 6b8:	89 0a                	mov    %ecx,(%edx)
 6ba:	eb 0b                	jmp    6c7 <malloc+0x60>
      else {
        p->s.size -= nunits;
 6bc:	29 d9                	sub    %ebx,%ecx
 6be:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6c4:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6c7:	89 15 c8 09 00 00    	mov    %edx,0x9c8
      return (void*)(p + 1);
 6cd:	83 c0 08             	add    $0x8,%eax
 6d0:	eb 63                	jmp    735 <malloc+0xce>
 6d2:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6d8:	be 00 10 00 00       	mov    $0x1000,%esi
 6dd:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6e0:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6e7:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6e9:	39 05 c8 09 00 00    	cmp    %eax,0x9c8
 6ef:	75 2d                	jne    71e <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	57                   	push   %edi
 6f5:	e8 63 fc ff ff       	call   35d <sbrk>
  if(p == (char*)-1)
 6fa:	83 c4 10             	add    $0x10,%esp
 6fd:	83 f8 ff             	cmp    $0xffffffff,%eax
 700:	74 27                	je     729 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 702:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 705:	83 ec 0c             	sub    $0xc,%esp
 708:	83 c0 08             	add    $0x8,%eax
 70b:	50                   	push   %eax
 70c:	e8 e4 fe ff ff       	call   5f5 <free>
  return freep;
 711:	8b 15 c8 09 00 00    	mov    0x9c8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 717:	83 c4 10             	add    $0x10,%esp
 71a:	85 d2                	test   %edx,%edx
 71c:	74 12                	je     730 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71e:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 720:	8b 48 04             	mov    0x4(%eax),%ecx
 723:	39 cb                	cmp    %ecx,%ebx
 725:	77 c0                	ja     6e7 <malloc+0x80>
 727:	eb 89                	jmp    6b2 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 729:	b8 00 00 00 00       	mov    $0x0,%eax
 72e:	eb 05                	jmp    735 <malloc+0xce>
 730:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 735:	8d 65 f4             	lea    -0xc(%ebp),%esp
 738:	5b                   	pop    %ebx
 739:	5e                   	pop    %esi
 73a:	5f                   	pop    %edi
 73b:	5d                   	pop    %ebp
 73c:	c3                   	ret    
