
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	eb 2b                	jmp    35 <cat+0x35>
    if (write(1, buf, n) != n) {
   a:	83 ec 04             	sub    $0x4,%esp
   d:	53                   	push   %ebx
   e:	68 20 0a 00 00       	push   $0xa20
  13:	6a 01                	push   $0x1
  15:	e8 c7 02 00 00       	call   2e1 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  1d:	39 c3                	cmp    %eax,%ebx
  1f:	74 14                	je     35 <cat+0x35>
      printf(1, "cat: write error\n");
  21:	83 ec 08             	sub    $0x8,%esp
  24:	68 2c 07 00 00       	push   $0x72c
  29:	6a 01                	push   $0x1
  2b:	e8 ec 03 00 00       	call   41c <printf>
      exit();
  30:	e8 8c 02 00 00       	call   2c1 <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  35:	83 ec 04             	sub    $0x4,%esp
  38:	68 00 02 00 00       	push   $0x200
  3d:	68 20 0a 00 00       	push   $0xa20
  42:	56                   	push   %esi
  43:	e8 91 02 00 00       	call   2d9 <read>
  48:	89 c3                	mov    %eax,%ebx
  4a:	83 c4 10             	add    $0x10,%esp
  4d:	85 c0                	test   %eax,%eax
  4f:	7f b9                	jg     a <cat+0xa>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  51:	85 c0                	test   %eax,%eax
  53:	79 14                	jns    69 <cat+0x69>
    printf(1, "cat: read error\n");
  55:	83 ec 08             	sub    $0x8,%esp
  58:	68 3e 07 00 00       	push   $0x73e
  5d:	6a 01                	push   $0x1
  5f:	e8 b8 03 00 00       	call   41c <printf>
    exit();
  64:	e8 58 02 00 00       	call   2c1 <exit>
  }
}
  69:	8d 65 f8             	lea    -0x8(%ebp),%esp
  6c:	5b                   	pop    %ebx
  6d:	5e                   	pop    %esi
  6e:	5d                   	pop    %ebp
  6f:	c3                   	ret    

00000070 <main>:

int
main(int argc, char *argv[])
{
  70:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  74:	83 e4 f0             	and    $0xfffffff0,%esp
  77:	ff 71 fc             	pushl  -0x4(%ecx)
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	57                   	push   %edi
  7e:	56                   	push   %esi
  7f:	53                   	push   %ebx
  80:	51                   	push   %ecx
  81:	83 ec 18             	sub    $0x18,%esp
  84:	8b 01                	mov    (%ecx),%eax
  86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  89:	8b 59 04             	mov    0x4(%ecx),%ebx
  8c:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  8f:	bf 01 00 00 00       	mov    $0x1,%edi
  94:	83 f8 01             	cmp    $0x1,%eax
  97:	7f 0f                	jg     a8 <main+0x38>
    cat(0);
  99:	83 ec 0c             	sub    $0xc,%esp
  9c:	6a 00                	push   $0x0
  9e:	e8 5d ff ff ff       	call   0 <cat>
    exit();
  a3:	e8 19 02 00 00       	call   2c1 <exit>
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  a8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  ab:	83 ec 08             	sub    $0x8,%esp
  ae:	6a 00                	push   $0x0
  b0:	ff 33                	pushl  (%ebx)
  b2:	e8 4a 02 00 00       	call   301 <open>
  b7:	89 c6                	mov    %eax,%esi
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	85 c0                	test   %eax,%eax
  be:	79 19                	jns    d9 <main+0x69>
      printf(1, "cat: cannot open %s\n", argv[i]);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c6:	ff 30                	pushl  (%eax)
  c8:	68 4f 07 00 00       	push   $0x74f
  cd:	6a 01                	push   $0x1
  cf:	e8 48 03 00 00       	call   41c <printf>
      exit();
  d4:	e8 e8 01 00 00       	call   2c1 <exit>
    }
    cat(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	50                   	push   %eax
  dd:	e8 1e ff ff ff       	call   0 <cat>
    close(fd);
  e2:	89 34 24             	mov    %esi,(%esp)
  e5:	e8 ff 01 00 00       	call   2e9 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ea:	83 c7 01             	add    $0x1,%edi
  ed:	83 c3 04             	add    $0x4,%ebx
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  f6:	75 b0                	jne    a8 <main+0x38>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
  f8:	e8 c4 01 00 00       	call   2c1 <exit>

000000fd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	53                   	push   %ebx
 101:	8b 45 08             	mov    0x8(%ebp),%eax
 104:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 107:	89 c2                	mov    %eax,%edx
 109:	83 c2 01             	add    $0x1,%edx
 10c:	83 c1 01             	add    $0x1,%ecx
 10f:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 113:	88 5a ff             	mov    %bl,-0x1(%edx)
 116:	84 db                	test   %bl,%bl
 118:	75 ef                	jne    109 <strcpy+0xc>
    ;
  return os;
}
 11a:	5b                   	pop    %ebx
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	8b 4d 08             	mov    0x8(%ebp),%ecx
 123:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 126:	0f b6 01             	movzbl (%ecx),%eax
 129:	84 c0                	test   %al,%al
 12b:	74 15                	je     142 <strcmp+0x25>
 12d:	3a 02                	cmp    (%edx),%al
 12f:	75 11                	jne    142 <strcmp+0x25>
    p++, q++;
 131:	83 c1 01             	add    $0x1,%ecx
 134:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 137:	0f b6 01             	movzbl (%ecx),%eax
 13a:	84 c0                	test   %al,%al
 13c:	74 04                	je     142 <strcmp+0x25>
 13e:	3a 02                	cmp    (%edx),%al
 140:	74 ef                	je     131 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 142:	0f b6 c0             	movzbl %al,%eax
 145:	0f b6 12             	movzbl (%edx),%edx
 148:	29 d0                	sub    %edx,%eax
}
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

0000014c <strlen>:

uint
strlen(char *s)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
 14f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 152:	80 39 00             	cmpb   $0x0,(%ecx)
 155:	74 12                	je     169 <strlen+0x1d>
 157:	ba 00 00 00 00       	mov    $0x0,%edx
 15c:	83 c2 01             	add    $0x1,%edx
 15f:	89 d0                	mov    %edx,%eax
 161:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 165:	75 f5                	jne    15c <strlen+0x10>
 167:	eb 05                	jmp    16e <strlen+0x22>
 169:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	89 d7                	mov    %edx,%edi
 179:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17c:	8b 45 0c             	mov    0xc(%ebp),%eax
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	89 d0                	mov    %edx,%eax
 184:	5f                   	pop    %edi
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    

00000187 <strchr>:

char*
strchr(const char *s, char c)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	53                   	push   %ebx
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 191:	0f b6 10             	movzbl (%eax),%edx
 194:	84 d2                	test   %dl,%dl
 196:	74 1d                	je     1b5 <strchr+0x2e>
 198:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 19a:	38 d3                	cmp    %dl,%bl
 19c:	75 06                	jne    1a4 <strchr+0x1d>
 19e:	eb 1a                	jmp    1ba <strchr+0x33>
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 16                	je     1ba <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 1ae:	b8 00 00 00 00       	mov    $0x0,%eax
 1b3:	eb 05                	jmp    1ba <strchr+0x33>
 1b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ba:	5b                   	pop    %ebx
 1bb:	5d                   	pop    %ebp
 1bc:	c3                   	ret    

000001bd <gets>:

char*
gets(char *buf, int max)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	56                   	push   %esi
 1c2:	53                   	push   %ebx
 1c3:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c6:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	eb 29                	jmp    1f9 <gets+0x3c>
    cc = read(0, &c, 1);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	6a 01                	push   $0x1
 1d5:	57                   	push   %edi
 1d6:	6a 00                	push   $0x0
 1d8:	e8 fc 00 00 00       	call   2d9 <read>
    if(cc < 1)
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	85 c0                	test   %eax,%eax
 1e2:	7e 21                	jle    205 <gets+0x48>
      break;
    buf[i++] = c;
 1e4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1e8:	8b 55 08             	mov    0x8(%ebp),%edx
 1eb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ef:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f1:	3c 0a                	cmp    $0xa,%al
 1f3:	74 0e                	je     203 <gets+0x46>
 1f5:	3c 0d                	cmp    $0xd,%al
 1f7:	74 0a                	je     203 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f9:	8d 5e 01             	lea    0x1(%esi),%ebx
 1fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ff:	7c cf                	jl     1d0 <gets+0x13>
 201:	eb 02                	jmp    205 <gets+0x48>
 203:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 20c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20f:	5b                   	pop    %ebx
 210:	5e                   	pop    %esi
 211:	5f                   	pop    %edi
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    

00000214 <stat>:

int
stat(char *n, struct stat *st)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	56                   	push   %esi
 218:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	6a 00                	push   $0x0
 21e:	ff 75 08             	pushl  0x8(%ebp)
 221:	e8 db 00 00 00       	call   301 <open>
  if(fd < 0)
 226:	83 c4 10             	add    $0x10,%esp
 229:	85 c0                	test   %eax,%eax
 22b:	78 1f                	js     24c <stat+0x38>
 22d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22f:	83 ec 08             	sub    $0x8,%esp
 232:	ff 75 0c             	pushl  0xc(%ebp)
 235:	50                   	push   %eax
 236:	e8 de 00 00 00       	call   319 <fstat>
 23b:	89 c6                	mov    %eax,%esi
  close(fd);
 23d:	89 1c 24             	mov    %ebx,(%esp)
 240:	e8 a4 00 00 00       	call   2e9 <close>
  return r;
 245:	83 c4 10             	add    $0x10,%esp
 248:	89 f0                	mov    %esi,%eax
 24a:	eb 05                	jmp    251 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 24c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 251:	8d 65 f8             	lea    -0x8(%ebp),%esp
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    

00000258 <atoi>:

int
atoi(const char *s)
{
 258:	55                   	push   %ebp
 259:	89 e5                	mov    %esp,%ebp
 25b:	53                   	push   %ebx
 25c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25f:	0f b6 11             	movzbl (%ecx),%edx
 262:	8d 42 d0             	lea    -0x30(%edx),%eax
 265:	3c 09                	cmp    $0x9,%al
 267:	77 1f                	ja     288 <atoi+0x30>
 269:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 26e:	83 c1 01             	add    $0x1,%ecx
 271:	8d 04 80             	lea    (%eax,%eax,4),%eax
 274:	0f be d2             	movsbl %dl,%edx
 277:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27b:	0f b6 11             	movzbl (%ecx),%edx
 27e:	8d 5a d0             	lea    -0x30(%edx),%ebx
 281:	80 fb 09             	cmp    $0x9,%bl
 284:	76 e8                	jbe    26e <atoi+0x16>
 286:	eb 05                	jmp    28d <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 288:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 28d:	5b                   	pop    %ebx
 28e:	5d                   	pop    %ebp
 28f:	c3                   	ret    

00000290 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	8b 75 0c             	mov    0xc(%ebp),%esi
 29b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 db                	test   %ebx,%ebx
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2a7:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ab:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2ae:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b1:	39 da                	cmp    %ebx,%edx
 2b3:	75 f2                	jne    2a7 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 2b5:	5b                   	pop    %ebx
 2b6:	5e                   	pop    %esi
 2b7:	5d                   	pop    %ebp
 2b8:	c3                   	ret    

000002b9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b9:	b8 01 00 00 00       	mov    $0x1,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <exit>:
SYSCALL(exit)
 2c1:	b8 02 00 00 00       	mov    $0x2,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <wait>:
SYSCALL(wait)
 2c9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <pipe>:
SYSCALL(pipe)
 2d1:	b8 04 00 00 00       	mov    $0x4,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <read>:
SYSCALL(read)
 2d9:	b8 05 00 00 00       	mov    $0x5,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <write>:
SYSCALL(write)
 2e1:	b8 10 00 00 00       	mov    $0x10,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <close>:
SYSCALL(close)
 2e9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <kill>:
SYSCALL(kill)
 2f1:	b8 06 00 00 00       	mov    $0x6,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <exec>:
SYSCALL(exec)
 2f9:	b8 07 00 00 00       	mov    $0x7,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <open>:
SYSCALL(open)
 301:	b8 0f 00 00 00       	mov    $0xf,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <mknod>:
SYSCALL(mknod)
 309:	b8 11 00 00 00       	mov    $0x11,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <unlink>:
SYSCALL(unlink)
 311:	b8 12 00 00 00       	mov    $0x12,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <fstat>:
SYSCALL(fstat)
 319:	b8 08 00 00 00       	mov    $0x8,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <link>:
SYSCALL(link)
 321:	b8 13 00 00 00       	mov    $0x13,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <mkdir>:
SYSCALL(mkdir)
 329:	b8 14 00 00 00       	mov    $0x14,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <chdir>:
SYSCALL(chdir)
 331:	b8 09 00 00 00       	mov    $0x9,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <dup>:
SYSCALL(dup)
 339:	b8 0a 00 00 00       	mov    $0xa,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <getpid>:
SYSCALL(getpid)
 341:	b8 0b 00 00 00       	mov    $0xb,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <sbrk>:
SYSCALL(sbrk)
 349:	b8 0c 00 00 00       	mov    $0xc,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sleep>:
SYSCALL(sleep)
 351:	b8 0d 00 00 00       	mov    $0xd,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <uptime>:
SYSCALL(uptime)
 359:	b8 0e 00 00 00       	mov    $0xe,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <setvariable>:
SYSCALL(setvariable)
 361:	b8 17 00 00 00       	mov    $0x17,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <getvariable>:
SYSCALL(getvariable)
 369:	b8 18 00 00 00       	mov    $0x18,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <remvariable>:
SYSCALL(remvariable)
 371:	b8 19 00 00 00       	mov    $0x19,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <wait2>:
SYSCALL(wait2)
 379:	b8 1a 00 00 00       	mov    $0x1a,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <set_priority>:
SYSCALL(set_priority)
 381:	b8 1b 00 00 00       	mov    $0x1b,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	57                   	push   %edi
 38d:	56                   	push   %esi
 38e:	53                   	push   %ebx
 38f:	83 ec 3c             	sub    $0x3c,%esp
 392:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 399:	74 12                	je     3ad <printint+0x24>
 39b:	89 d0                	mov    %edx,%eax
 39d:	c1 e8 1f             	shr    $0x1f,%eax
 3a0:	84 c0                	test   %al,%al
 3a2:	74 09                	je     3ad <printint+0x24>
    neg = 1;
    x = -xx;
 3a4:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 3a6:	be 01 00 00 00       	mov    $0x1,%esi
 3ab:	eb 05                	jmp    3b2 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ad:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3b2:	bf 00 00 00 00       	mov    $0x0,%edi
 3b7:	eb 02                	jmp    3bb <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3b9:	89 df                	mov    %ebx,%edi
 3bb:	8d 5f 01             	lea    0x1(%edi),%ebx
 3be:	89 d0                	mov    %edx,%eax
 3c0:	ba 00 00 00 00       	mov    $0x0,%edx
 3c5:	f7 f1                	div    %ecx
 3c7:	0f b6 92 6c 07 00 00 	movzbl 0x76c(%edx),%edx
 3ce:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3d2:	89 c2                	mov    %eax,%edx
 3d4:	85 c0                	test   %eax,%eax
 3d6:	75 e1                	jne    3b9 <printint+0x30>
  if(neg)
 3d8:	85 f6                	test   %esi,%esi
 3da:	74 08                	je     3e4 <printint+0x5b>
    buf[i++] = '-';
 3dc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3e1:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3e4:	89 d8                	mov    %ebx,%eax
 3e6:	83 e8 01             	sub    $0x1,%eax
 3e9:	78 29                	js     414 <printint+0x8b>
 3eb:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 3ee:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3f2:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3f5:	0f b6 03             	movzbl (%ebx),%eax
 3f8:	88 45 d7             	mov    %al,-0x29(%ebp)
 3fb:	83 ec 04             	sub    $0x4,%esp
 3fe:	6a 01                	push   $0x1
 400:	57                   	push   %edi
 401:	56                   	push   %esi
 402:	e8 da fe ff ff       	call   2e1 <write>
 407:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 40a:	83 c4 10             	add    $0x10,%esp
 40d:	8d 45 d7             	lea    -0x29(%ebp),%eax
 410:	39 c3                	cmp    %eax,%ebx
 412:	75 e1                	jne    3f5 <printint+0x6c>
    putc(fd, buf[i]);
}
 414:	8d 65 f4             	lea    -0xc(%ebp),%esp
 417:	5b                   	pop    %ebx
 418:	5e                   	pop    %esi
 419:	5f                   	pop    %edi
 41a:	5d                   	pop    %ebp
 41b:	c3                   	ret    

0000041c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	57                   	push   %edi
 420:	56                   	push   %esi
 421:	53                   	push   %ebx
 422:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 425:	8b 75 0c             	mov    0xc(%ebp),%esi
 428:	0f b6 1e             	movzbl (%esi),%ebx
 42b:	84 db                	test   %bl,%bl
 42d:	0f 84 a6 01 00 00    	je     5d9 <printf+0x1bd>
 433:	83 c6 01             	add    $0x1,%esi
 436:	8d 45 10             	lea    0x10(%ebp),%eax
 439:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 43c:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 441:	0f be d3             	movsbl %bl,%edx
 444:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 447:	85 ff                	test   %edi,%edi
 449:	75 25                	jne    470 <printf+0x54>
      if(c == '%'){
 44b:	83 f8 25             	cmp    $0x25,%eax
 44e:	0f 84 6a 01 00 00    	je     5be <printf+0x1a2>
 454:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 457:	83 ec 04             	sub    $0x4,%esp
 45a:	6a 01                	push   $0x1
 45c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 45f:	50                   	push   %eax
 460:	ff 75 08             	pushl  0x8(%ebp)
 463:	e8 79 fe ff ff       	call   2e1 <write>
 468:	83 c4 10             	add    $0x10,%esp
 46b:	e9 5a 01 00 00       	jmp    5ca <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 470:	83 ff 25             	cmp    $0x25,%edi
 473:	0f 85 51 01 00 00    	jne    5ca <printf+0x1ae>
      if(c == 'd'){
 479:	83 f8 64             	cmp    $0x64,%eax
 47c:	75 2c                	jne    4aa <printf+0x8e>
        printint(fd, *ap, 10, 1);
 47e:	83 ec 0c             	sub    $0xc,%esp
 481:	6a 01                	push   $0x1
 483:	b9 0a 00 00 00       	mov    $0xa,%ecx
 488:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 48b:	8b 17                	mov    (%edi),%edx
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	e8 f4 fe ff ff       	call   389 <printint>
        ap++;
 495:	89 f8                	mov    %edi,%eax
 497:	83 c0 04             	add    $0x4,%eax
 49a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 49d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a0:	bf 00 00 00 00       	mov    $0x0,%edi
 4a5:	e9 20 01 00 00       	jmp    5ca <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4aa:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4b0:	83 fa 70             	cmp    $0x70,%edx
 4b3:	75 2c                	jne    4e1 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 4b5:	83 ec 0c             	sub    $0xc,%esp
 4b8:	6a 00                	push   $0x0
 4ba:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bf:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4c2:	8b 17                	mov    (%edi),%edx
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	e8 bd fe ff ff       	call   389 <printint>
        ap++;
 4cc:	89 f8                	mov    %edi,%eax
 4ce:	83 c0 04             	add    $0x4,%eax
 4d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d7:	bf 00 00 00 00       	mov    $0x0,%edi
 4dc:	e9 e9 00 00 00       	jmp    5ca <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4e1:	83 f8 73             	cmp    $0x73,%eax
 4e4:	75 52                	jne    538 <printf+0x11c>
        s = (char*)*ap;
 4e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4e9:	8b 18                	mov    (%eax),%ebx
        ap++;
 4eb:	83 c0 04             	add    $0x4,%eax
 4ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 4f1:	85 db                	test   %ebx,%ebx
          s = "(null)";
 4f3:	b8 64 07 00 00       	mov    $0x764,%eax
 4f8:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 4fb:	0f b6 03             	movzbl (%ebx),%eax
 4fe:	84 c0                	test   %al,%al
 500:	0f 84 bf 00 00 00    	je     5c5 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 506:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 509:	89 75 d0             	mov    %esi,-0x30(%ebp)
 50c:	8b 75 08             	mov    0x8(%ebp),%esi
 50f:	88 45 e3             	mov    %al,-0x1d(%ebp)
 512:	83 ec 04             	sub    $0x4,%esp
 515:	6a 01                	push   $0x1
 517:	57                   	push   %edi
 518:	56                   	push   %esi
 519:	e8 c3 fd ff ff       	call   2e1 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 51e:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 521:	0f b6 03             	movzbl (%ebx),%eax
 524:	83 c4 10             	add    $0x10,%esp
 527:	84 c0                	test   %al,%al
 529:	75 e4                	jne    50f <printf+0xf3>
 52b:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52e:	bf 00 00 00 00       	mov    $0x0,%edi
 533:	e9 92 00 00 00       	jmp    5ca <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 538:	83 f8 63             	cmp    $0x63,%eax
 53b:	75 2b                	jne    568 <printf+0x14c>
 53d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 540:	8b 07                	mov    (%edi),%eax
 542:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 545:	83 ec 04             	sub    $0x4,%esp
 548:	6a 01                	push   $0x1
 54a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 8b fd ff ff       	call   2e1 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 556:	89 f8                	mov    %edi,%eax
 558:	83 c0 04             	add    $0x4,%eax
 55b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 55e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 561:	bf 00 00 00 00       	mov    $0x0,%edi
 566:	eb 62                	jmp    5ca <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 568:	83 f8 25             	cmp    $0x25,%eax
 56b:	75 1e                	jne    58b <printf+0x16f>
 56d:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	6a 01                	push   $0x1
 575:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 578:	50                   	push   %eax
 579:	ff 75 08             	pushl  0x8(%ebp)
 57c:	e8 60 fd ff ff       	call   2e1 <write>
 581:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 584:	bf 00 00 00 00       	mov    $0x0,%edi
 589:	eb 3f                	jmp    5ca <printf+0x1ae>
 58b:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 58f:	83 ec 04             	sub    $0x4,%esp
 592:	6a 01                	push   $0x1
 594:	8d 45 e7             	lea    -0x19(%ebp),%eax
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 41 fd ff ff       	call   2e1 <write>
 5a0:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5a3:	83 c4 0c             	add    $0xc,%esp
 5a6:	6a 01                	push   $0x1
 5a8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 2d fd ff ff       	call   2e1 <write>
 5b4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5b7:	bf 00 00 00 00       	mov    $0x0,%edi
 5bc:	eb 0c                	jmp    5ca <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5be:	bf 25 00 00 00       	mov    $0x25,%edi
 5c3:	eb 05                	jmp    5ca <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c5:	bf 00 00 00 00       	mov    $0x0,%edi
 5ca:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cd:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5d1:	84 db                	test   %bl,%bl
 5d3:	0f 85 68 fe ff ff    	jne    441 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5dc:	5b                   	pop    %ebx
 5dd:	5e                   	pop    %esi
 5de:	5f                   	pop    %edi
 5df:	5d                   	pop    %ebp
 5e0:	c3                   	ret    

000005e1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	57                   	push   %edi
 5e5:	56                   	push   %esi
 5e6:	53                   	push   %ebx
 5e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ea:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ed:	a1 00 0a 00 00       	mov    0xa00,%eax
 5f2:	eb 0c                	jmp    600 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f4:	8b 10                	mov    (%eax),%edx
 5f6:	39 d0                	cmp    %edx,%eax
 5f8:	72 04                	jb     5fe <free+0x1d>
 5fa:	39 d1                	cmp    %edx,%ecx
 5fc:	72 0c                	jb     60a <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fe:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 600:	39 c8                	cmp    %ecx,%eax
 602:	73 f0                	jae    5f4 <free+0x13>
 604:	8b 10                	mov    (%eax),%edx
 606:	39 d1                	cmp    %edx,%ecx
 608:	73 3e                	jae    648 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60d:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 610:	8b 10                	mov    (%eax),%edx
 612:	39 d7                	cmp    %edx,%edi
 614:	75 0f                	jne    625 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 616:	03 77 04             	add    0x4(%edi),%esi
 619:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 61c:	8b 10                	mov    (%eax),%edx
 61e:	8b 12                	mov    (%edx),%edx
 620:	89 53 f8             	mov    %edx,-0x8(%ebx)
 623:	eb 03                	jmp    628 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 625:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 628:	8b 50 04             	mov    0x4(%eax),%edx
 62b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62e:	39 f1                	cmp    %esi,%ecx
 630:	75 0d                	jne    63f <free+0x5e>
    p->s.size += bp->s.size;
 632:	03 53 fc             	add    -0x4(%ebx),%edx
 635:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 638:	8b 53 f8             	mov    -0x8(%ebx),%edx
 63b:	89 10                	mov    %edx,(%eax)
 63d:	eb 02                	jmp    641 <free+0x60>
  } else
    p->s.ptr = bp;
 63f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 641:	a3 00 0a 00 00       	mov    %eax,0xa00
}
 646:	eb 06                	jmp    64e <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 648:	39 d0                	cmp    %edx,%eax
 64a:	72 b2                	jb     5fe <free+0x1d>
 64c:	eb bc                	jmp    60a <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 64e:	5b                   	pop    %ebx
 64f:	5e                   	pop    %esi
 650:	5f                   	pop    %edi
 651:	5d                   	pop    %ebp
 652:	c3                   	ret    

00000653 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 653:	55                   	push   %ebp
 654:	89 e5                	mov    %esp,%ebp
 656:	57                   	push   %edi
 657:	56                   	push   %esi
 658:	53                   	push   %ebx
 659:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
 65f:	8d 58 07             	lea    0x7(%eax),%ebx
 662:	c1 eb 03             	shr    $0x3,%ebx
 665:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 668:	8b 15 00 0a 00 00    	mov    0xa00,%edx
 66e:	85 d2                	test   %edx,%edx
 670:	75 23                	jne    695 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 672:	c7 05 00 0a 00 00 04 	movl   $0xa04,0xa00
 679:	0a 00 00 
 67c:	c7 05 04 0a 00 00 04 	movl   $0xa04,0xa04
 683:	0a 00 00 
    base.s.size = 0;
 686:	c7 05 08 0a 00 00 00 	movl   $0x0,0xa08
 68d:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 690:	ba 04 0a 00 00       	mov    $0xa04,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 695:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 697:	8b 48 04             	mov    0x4(%eax),%ecx
 69a:	39 cb                	cmp    %ecx,%ebx
 69c:	77 20                	ja     6be <malloc+0x6b>
      if(p->s.size == nunits)
 69e:	39 cb                	cmp    %ecx,%ebx
 6a0:	75 06                	jne    6a8 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 6a2:	8b 08                	mov    (%eax),%ecx
 6a4:	89 0a                	mov    %ecx,(%edx)
 6a6:	eb 0b                	jmp    6b3 <malloc+0x60>
      else {
        p->s.size -= nunits;
 6a8:	29 d9                	sub    %ebx,%ecx
 6aa:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6ad:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6b0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6b3:	89 15 00 0a 00 00    	mov    %edx,0xa00
      return (void*)(p + 1);
 6b9:	83 c0 08             	add    $0x8,%eax
 6bc:	eb 63                	jmp    721 <malloc+0xce>
 6be:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6c4:	be 00 10 00 00       	mov    $0x1000,%esi
 6c9:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6cc:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6d3:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d5:	39 05 00 0a 00 00    	cmp    %eax,0xa00
 6db:	75 2d                	jne    70a <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 6dd:	83 ec 0c             	sub    $0xc,%esp
 6e0:	57                   	push   %edi
 6e1:	e8 63 fc ff ff       	call   349 <sbrk>
  if(p == (char*)-1)
 6e6:	83 c4 10             	add    $0x10,%esp
 6e9:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ec:	74 27                	je     715 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6ee:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6f1:	83 ec 0c             	sub    $0xc,%esp
 6f4:	83 c0 08             	add    $0x8,%eax
 6f7:	50                   	push   %eax
 6f8:	e8 e4 fe ff ff       	call   5e1 <free>
  return freep;
 6fd:	8b 15 00 0a 00 00    	mov    0xa00,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 703:	83 c4 10             	add    $0x10,%esp
 706:	85 d2                	test   %edx,%edx
 708:	74 12                	je     71c <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 70c:	8b 48 04             	mov    0x4(%eax),%ecx
 70f:	39 cb                	cmp    %ecx,%ebx
 711:	77 c0                	ja     6d3 <malloc+0x80>
 713:	eb 89                	jmp    69e <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 715:	b8 00 00 00 00       	mov    $0x0,%eax
 71a:	eb 05                	jmp    721 <malloc+0xce>
 71c:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 721:	8d 65 f4             	lea    -0xc(%ebp),%esp
 724:	5b                   	pop    %ebx
 725:	5e                   	pop    %esi
 726:	5f                   	pop    %edi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    
