
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
wc(int fd, char *name)
{
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1e:	be 00 00 00 00       	mov    $0x0,%esi
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	eb 52                	jmp    77 <wc+0x77>
  25:	bb 00 00 00 00       	mov    $0x0,%ebx
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  2a:	0f b6 83 80 0a 00 00 	movzbl 0xa80(%ebx),%eax
        l++;
  31:	3c 0a                	cmp    $0xa,%al
  33:	0f 94 c2             	sete   %dl
  36:	0f b6 d2             	movzbl %dl,%edx
  39:	01 d6                	add    %edx,%esi
      if(strchr(" \r\t\n\v", buf[i]))
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	0f be c0             	movsbl %al,%eax
  41:	50                   	push   %eax
  42:	68 94 07 00 00       	push   $0x794
  47:	e8 a3 01 00 00       	call   1ef <strchr>
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	85 c0                	test   %eax,%eax
  51:	75 13                	jne    66 <wc+0x66>
        inword = 0;
      else if(!inword){
  53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  57:	75 14                	jne    6d <wc+0x6d>
        w++;
  59:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
  5d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  64:	eb 07                	jmp    6d <wc+0x6d>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
  66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  6d:	83 c3 01             	add    $0x1,%ebx
  70:	39 df                	cmp    %ebx,%edi
  72:	75 b6                	jne    2a <wc+0x2a>
  74:	01 7d dc             	add    %edi,-0x24(%ebp)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  77:	83 ec 04             	sub    $0x4,%esp
  7a:	68 00 02 00 00       	push   $0x200
  7f:	68 80 0a 00 00       	push   $0xa80
  84:	ff 75 08             	pushl  0x8(%ebp)
  87:	e8 b5 02 00 00       	call   341 <read>
  8c:	89 c7                	mov    %eax,%edi
  8e:	83 c4 10             	add    $0x10,%esp
  91:	85 c0                	test   %eax,%eax
  93:	7f 90                	jg     25 <wc+0x25>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  95:	85 c0                	test   %eax,%eax
  97:	79 14                	jns    ad <wc+0xad>
    printf(1, "wc: read error\n");
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	68 9a 07 00 00       	push   $0x79a
  a1:	6a 01                	push   $0x1
  a3:	e8 dc 03 00 00       	call   484 <printf>
    exit();
  a8:	e8 7c 02 00 00       	call   329 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  ad:	83 ec 08             	sub    $0x8,%esp
  b0:	ff 75 0c             	pushl  0xc(%ebp)
  b3:	ff 75 dc             	pushl  -0x24(%ebp)
  b6:	ff 75 e0             	pushl  -0x20(%ebp)
  b9:	56                   	push   %esi
  ba:	68 aa 07 00 00       	push   $0x7aa
  bf:	6a 01                	push   $0x1
  c1:	e8 be 03 00 00       	call   484 <printf>
}
  c6:	83 c4 20             	add    $0x20,%esp
  c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  cc:	5b                   	pop    %ebx
  cd:	5e                   	pop    %esi
  ce:	5f                   	pop    %edi
  cf:	5d                   	pop    %ebp
  d0:	c3                   	ret    

000000d1 <main>:

int
main(int argc, char *argv[])
{
  d1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d5:	83 e4 f0             	and    $0xfffffff0,%esp
  d8:	ff 71 fc             	pushl  -0x4(%ecx)
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	56                   	push   %esi
  e0:	53                   	push   %ebx
  e1:	51                   	push   %ecx
  e2:	83 ec 18             	sub    $0x18,%esp
  e5:	8b 01                	mov    (%ecx),%eax
  e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ea:	8b 59 04             	mov    0x4(%ecx),%ebx
  ed:	83 c3 04             	add    $0x4,%ebx
  int fd, i;

  if(argc <= 1){
  f0:	bf 01 00 00 00       	mov    $0x1,%edi
  f5:	83 f8 01             	cmp    $0x1,%eax
  f8:	7f 14                	jg     10e <main+0x3d>
    wc(0, "");
  fa:	83 ec 08             	sub    $0x8,%esp
  fd:	68 a9 07 00 00       	push   $0x7a9
 102:	6a 00                	push   $0x0
 104:	e8 f7 fe ff ff       	call   0 <wc>
    exit();
 109:	e8 1b 02 00 00       	call   329 <exit>
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 10e:	89 5d e0             	mov    %ebx,-0x20(%ebp)
 111:	83 ec 08             	sub    $0x8,%esp
 114:	6a 00                	push   $0x0
 116:	ff 33                	pushl  (%ebx)
 118:	e8 4c 02 00 00       	call   369 <open>
 11d:	89 c6                	mov    %eax,%esi
 11f:	83 c4 10             	add    $0x10,%esp
 122:	85 c0                	test   %eax,%eax
 124:	79 19                	jns    13f <main+0x6e>
      printf(1, "wc: cannot open %s\n", argv[i]);
 126:	83 ec 04             	sub    $0x4,%esp
 129:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12c:	ff 30                	pushl  (%eax)
 12e:	68 b7 07 00 00       	push   $0x7b7
 133:	6a 01                	push   $0x1
 135:	e8 4a 03 00 00       	call   484 <printf>
      exit();
 13a:	e8 ea 01 00 00       	call   329 <exit>
    }
    wc(fd, argv[i]);
 13f:	83 ec 08             	sub    $0x8,%esp
 142:	ff 33                	pushl  (%ebx)
 144:	50                   	push   %eax
 145:	e8 b6 fe ff ff       	call   0 <wc>
    close(fd);
 14a:	89 34 24             	mov    %esi,(%esp)
 14d:	e8 ff 01 00 00       	call   351 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 152:	83 c7 01             	add    $0x1,%edi
 155:	83 c3 04             	add    $0x4,%ebx
 158:	83 c4 10             	add    $0x10,%esp
 15b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 15e:	75 ae                	jne    10e <main+0x3d>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 160:	e8 c4 01 00 00       	call   329 <exit>

00000165 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	53                   	push   %ebx
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16f:	89 c2                	mov    %eax,%edx
 171:	83 c2 01             	add    $0x1,%edx
 174:	83 c1 01             	add    $0x1,%ecx
 177:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 17b:	88 5a ff             	mov    %bl,-0x1(%edx)
 17e:	84 db                	test   %bl,%bl
 180:	75 ef                	jne    171 <strcpy+0xc>
    ;
  return os;
}
 182:	5b                   	pop    %ebx
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 18e:	0f b6 01             	movzbl (%ecx),%eax
 191:	84 c0                	test   %al,%al
 193:	74 15                	je     1aa <strcmp+0x25>
 195:	3a 02                	cmp    (%edx),%al
 197:	75 11                	jne    1aa <strcmp+0x25>
    p++, q++;
 199:	83 c1 01             	add    $0x1,%ecx
 19c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19f:	0f b6 01             	movzbl (%ecx),%eax
 1a2:	84 c0                	test   %al,%al
 1a4:	74 04                	je     1aa <strcmp+0x25>
 1a6:	3a 02                	cmp    (%edx),%al
 1a8:	74 ef                	je     199 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1aa:	0f b6 c0             	movzbl %al,%eax
 1ad:	0f b6 12             	movzbl (%edx),%edx
 1b0:	29 d0                	sub    %edx,%eax
}
 1b2:	5d                   	pop    %ebp
 1b3:	c3                   	ret    

000001b4 <strlen>:

uint
strlen(char *s)
{
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1ba:	80 39 00             	cmpb   $0x0,(%ecx)
 1bd:	74 12                	je     1d1 <strlen+0x1d>
 1bf:	ba 00 00 00 00       	mov    $0x0,%edx
 1c4:	83 c2 01             	add    $0x1,%edx
 1c7:	89 d0                	mov    %edx,%eax
 1c9:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1cd:	75 f5                	jne    1c4 <strlen+0x10>
 1cf:	eb 05                	jmp    1d6 <strlen+0x22>
 1d1:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	57                   	push   %edi
 1dc:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1df:	89 d7                	mov    %edx,%edi
 1e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	fc                   	cld    
 1e8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1ea:	89 d0                	mov    %edx,%eax
 1ec:	5f                   	pop    %edi
 1ed:	5d                   	pop    %ebp
 1ee:	c3                   	ret    

000001ef <strchr>:

char*
strchr(const char *s, char c)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	53                   	push   %ebx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1f9:	0f b6 10             	movzbl (%eax),%edx
 1fc:	84 d2                	test   %dl,%dl
 1fe:	74 1d                	je     21d <strchr+0x2e>
 200:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 202:	38 d3                	cmp    %dl,%bl
 204:	75 06                	jne    20c <strchr+0x1d>
 206:	eb 1a                	jmp    222 <strchr+0x33>
 208:	38 ca                	cmp    %cl,%dl
 20a:	74 16                	je     222 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 20c:	83 c0 01             	add    $0x1,%eax
 20f:	0f b6 10             	movzbl (%eax),%edx
 212:	84 d2                	test   %dl,%dl
 214:	75 f2                	jne    208 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 216:	b8 00 00 00 00       	mov    $0x0,%eax
 21b:	eb 05                	jmp    222 <strchr+0x33>
 21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 222:	5b                   	pop    %ebx
 223:	5d                   	pop    %ebp
 224:	c3                   	ret    

00000225 <gets>:

char*
gets(char *buf, int max)
{
 225:	55                   	push   %ebp
 226:	89 e5                	mov    %esp,%ebp
 228:	57                   	push   %edi
 229:	56                   	push   %esi
 22a:	53                   	push   %ebx
 22b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 233:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	eb 29                	jmp    261 <gets+0x3c>
    cc = read(0, &c, 1);
 238:	83 ec 04             	sub    $0x4,%esp
 23b:	6a 01                	push   $0x1
 23d:	57                   	push   %edi
 23e:	6a 00                	push   $0x0
 240:	e8 fc 00 00 00       	call   341 <read>
    if(cc < 1)
 245:	83 c4 10             	add    $0x10,%esp
 248:	85 c0                	test   %eax,%eax
 24a:	7e 21                	jle    26d <gets+0x48>
      break;
    buf[i++] = c;
 24c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 250:	8b 55 08             	mov    0x8(%ebp),%edx
 253:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 257:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 259:	3c 0a                	cmp    $0xa,%al
 25b:	74 0e                	je     26b <gets+0x46>
 25d:	3c 0d                	cmp    $0xd,%al
 25f:	74 0a                	je     26b <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	8d 5e 01             	lea    0x1(%esi),%ebx
 264:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 267:	7c cf                	jl     238 <gets+0x13>
 269:	eb 02                	jmp    26d <gets+0x48>
 26b:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 274:	8d 65 f4             	lea    -0xc(%ebp),%esp
 277:	5b                   	pop    %ebx
 278:	5e                   	pop    %esi
 279:	5f                   	pop    %edi
 27a:	5d                   	pop    %ebp
 27b:	c3                   	ret    

0000027c <stat>:

int
stat(char *n, struct stat *st)
{
 27c:	55                   	push   %ebp
 27d:	89 e5                	mov    %esp,%ebp
 27f:	56                   	push   %esi
 280:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 281:	83 ec 08             	sub    $0x8,%esp
 284:	6a 00                	push   $0x0
 286:	ff 75 08             	pushl  0x8(%ebp)
 289:	e8 db 00 00 00       	call   369 <open>
  if(fd < 0)
 28e:	83 c4 10             	add    $0x10,%esp
 291:	85 c0                	test   %eax,%eax
 293:	78 1f                	js     2b4 <stat+0x38>
 295:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 297:	83 ec 08             	sub    $0x8,%esp
 29a:	ff 75 0c             	pushl  0xc(%ebp)
 29d:	50                   	push   %eax
 29e:	e8 de 00 00 00       	call   381 <fstat>
 2a3:	89 c6                	mov    %eax,%esi
  close(fd);
 2a5:	89 1c 24             	mov    %ebx,(%esp)
 2a8:	e8 a4 00 00 00       	call   351 <close>
  return r;
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 f0                	mov    %esi,%eax
 2b2:	eb 05                	jmp    2b9 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 2b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2bc:	5b                   	pop    %ebx
 2bd:	5e                   	pop    %esi
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <atoi>:

int
atoi(const char *s)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c7:	0f b6 11             	movzbl (%ecx),%edx
 2ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 2cd:	3c 09                	cmp    $0x9,%al
 2cf:	77 1f                	ja     2f0 <atoi+0x30>
 2d1:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 2d6:	83 c1 01             	add    $0x1,%ecx
 2d9:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2dc:	0f be d2             	movsbl %dl,%edx
 2df:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e3:	0f b6 11             	movzbl (%ecx),%edx
 2e6:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2e9:	80 fb 09             	cmp    $0x9,%bl
 2ec:	76 e8                	jbe    2d6 <atoi+0x16>
 2ee:	eb 05                	jmp    2f5 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 2f0:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 2f5:	5b                   	pop    %ebx
 2f6:	5d                   	pop    %ebp
 2f7:	c3                   	ret    

000002f8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	56                   	push   %esi
 2fc:	53                   	push   %ebx
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	8b 75 0c             	mov    0xc(%ebp),%esi
 303:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 306:	85 db                	test   %ebx,%ebx
 308:	7e 13                	jle    31d <memmove+0x25>
 30a:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 30f:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 313:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 316:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 319:	39 da                	cmp    %ebx,%edx
 31b:	75 f2                	jne    30f <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 31d:	5b                   	pop    %ebx
 31e:	5e                   	pop    %esi
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    

00000321 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 321:	b8 01 00 00 00       	mov    $0x1,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <exit>:
SYSCALL(exit)
 329:	b8 02 00 00 00       	mov    $0x2,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <wait>:
SYSCALL(wait)
 331:	b8 03 00 00 00       	mov    $0x3,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <pipe>:
SYSCALL(pipe)
 339:	b8 04 00 00 00       	mov    $0x4,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <read>:
SYSCALL(read)
 341:	b8 05 00 00 00       	mov    $0x5,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <write>:
SYSCALL(write)
 349:	b8 10 00 00 00       	mov    $0x10,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <close>:
SYSCALL(close)
 351:	b8 15 00 00 00       	mov    $0x15,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <kill>:
SYSCALL(kill)
 359:	b8 06 00 00 00       	mov    $0x6,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <exec>:
SYSCALL(exec)
 361:	b8 07 00 00 00       	mov    $0x7,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <open>:
SYSCALL(open)
 369:	b8 0f 00 00 00       	mov    $0xf,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <mknod>:
SYSCALL(mknod)
 371:	b8 11 00 00 00       	mov    $0x11,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <unlink>:
SYSCALL(unlink)
 379:	b8 12 00 00 00       	mov    $0x12,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <fstat>:
SYSCALL(fstat)
 381:	b8 08 00 00 00       	mov    $0x8,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <link>:
SYSCALL(link)
 389:	b8 13 00 00 00       	mov    $0x13,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <mkdir>:
SYSCALL(mkdir)
 391:	b8 14 00 00 00       	mov    $0x14,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <chdir>:
SYSCALL(chdir)
 399:	b8 09 00 00 00       	mov    $0x9,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <dup>:
SYSCALL(dup)
 3a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <getpid>:
SYSCALL(getpid)
 3a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <sbrk>:
SYSCALL(sbrk)
 3b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <sleep>:
SYSCALL(sleep)
 3b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <uptime>:
SYSCALL(uptime)
 3c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <setvariable>:
SYSCALL(setvariable)
 3c9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <getvariable>:
SYSCALL(getvariable)
 3d1:	b8 18 00 00 00       	mov    $0x18,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <remvariable>:
SYSCALL(remvariable)
 3d9:	b8 19 00 00 00       	mov    $0x19,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <wait2>:
SYSCALL(wait2)
 3e1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <set_priority>:
SYSCALL(set_priority)
 3e9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f1:	55                   	push   %ebp
 3f2:	89 e5                	mov    %esp,%ebp
 3f4:	57                   	push   %edi
 3f5:	56                   	push   %esi
 3f6:	53                   	push   %ebx
 3f7:	83 ec 3c             	sub    $0x3c,%esp
 3fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 401:	74 12                	je     415 <printint+0x24>
 403:	89 d0                	mov    %edx,%eax
 405:	c1 e8 1f             	shr    $0x1f,%eax
 408:	84 c0                	test   %al,%al
 40a:	74 09                	je     415 <printint+0x24>
    neg = 1;
    x = -xx;
 40c:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 40e:	be 01 00 00 00       	mov    $0x1,%esi
 413:	eb 05                	jmp    41a <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 415:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 41a:	bf 00 00 00 00       	mov    $0x0,%edi
 41f:	eb 02                	jmp    423 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 421:	89 df                	mov    %ebx,%edi
 423:	8d 5f 01             	lea    0x1(%edi),%ebx
 426:	89 d0                	mov    %edx,%eax
 428:	ba 00 00 00 00       	mov    $0x0,%edx
 42d:	f7 f1                	div    %ecx
 42f:	0f b6 92 d4 07 00 00 	movzbl 0x7d4(%edx),%edx
 436:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 43a:	89 c2                	mov    %eax,%edx
 43c:	85 c0                	test   %eax,%eax
 43e:	75 e1                	jne    421 <printint+0x30>
  if(neg)
 440:	85 f6                	test   %esi,%esi
 442:	74 08                	je     44c <printint+0x5b>
    buf[i++] = '-';
 444:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 449:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 44c:	89 d8                	mov    %ebx,%eax
 44e:	83 e8 01             	sub    $0x1,%eax
 451:	78 29                	js     47c <printint+0x8b>
 453:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 456:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 45a:	8d 7d d7             	lea    -0x29(%ebp),%edi
 45d:	0f b6 03             	movzbl (%ebx),%eax
 460:	88 45 d7             	mov    %al,-0x29(%ebp)
 463:	83 ec 04             	sub    $0x4,%esp
 466:	6a 01                	push   $0x1
 468:	57                   	push   %edi
 469:	56                   	push   %esi
 46a:	e8 da fe ff ff       	call   349 <write>
 46f:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 472:	83 c4 10             	add    $0x10,%esp
 475:	8d 45 d7             	lea    -0x29(%ebp),%eax
 478:	39 c3                	cmp    %eax,%ebx
 47a:	75 e1                	jne    45d <printint+0x6c>
    putc(fd, buf[i]);
}
 47c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47f:	5b                   	pop    %ebx
 480:	5e                   	pop    %esi
 481:	5f                   	pop    %edi
 482:	5d                   	pop    %ebp
 483:	c3                   	ret    

00000484 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	57                   	push   %edi
 488:	56                   	push   %esi
 489:	53                   	push   %ebx
 48a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 48d:	8b 75 0c             	mov    0xc(%ebp),%esi
 490:	0f b6 1e             	movzbl (%esi),%ebx
 493:	84 db                	test   %bl,%bl
 495:	0f 84 a6 01 00 00    	je     641 <printf+0x1bd>
 49b:	83 c6 01             	add    $0x1,%esi
 49e:	8d 45 10             	lea    0x10(%ebp),%eax
 4a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4a4:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 4a9:	0f be d3             	movsbl %bl,%edx
 4ac:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4af:	85 ff                	test   %edi,%edi
 4b1:	75 25                	jne    4d8 <printf+0x54>
      if(c == '%'){
 4b3:	83 f8 25             	cmp    $0x25,%eax
 4b6:	0f 84 6a 01 00 00    	je     626 <printf+0x1a2>
 4bc:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4bf:	83 ec 04             	sub    $0x4,%esp
 4c2:	6a 01                	push   $0x1
 4c4:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4c7:	50                   	push   %eax
 4c8:	ff 75 08             	pushl  0x8(%ebp)
 4cb:	e8 79 fe ff ff       	call   349 <write>
 4d0:	83 c4 10             	add    $0x10,%esp
 4d3:	e9 5a 01 00 00       	jmp    632 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4d8:	83 ff 25             	cmp    $0x25,%edi
 4db:	0f 85 51 01 00 00    	jne    632 <printf+0x1ae>
      if(c == 'd'){
 4e1:	83 f8 64             	cmp    $0x64,%eax
 4e4:	75 2c                	jne    512 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 4e6:	83 ec 0c             	sub    $0xc,%esp
 4e9:	6a 01                	push   $0x1
 4eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f3:	8b 17                	mov    (%edi),%edx
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	e8 f4 fe ff ff       	call   3f1 <printint>
        ap++;
 4fd:	89 f8                	mov    %edi,%eax
 4ff:	83 c0 04             	add    $0x4,%eax
 502:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 505:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 508:	bf 00 00 00 00       	mov    $0x0,%edi
 50d:	e9 20 01 00 00       	jmp    632 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 512:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 518:	83 fa 70             	cmp    $0x70,%edx
 51b:	75 2c                	jne    549 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 51d:	83 ec 0c             	sub    $0xc,%esp
 520:	6a 00                	push   $0x0
 522:	b9 10 00 00 00       	mov    $0x10,%ecx
 527:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 52a:	8b 17                	mov    (%edi),%edx
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	e8 bd fe ff ff       	call   3f1 <printint>
        ap++;
 534:	89 f8                	mov    %edi,%eax
 536:	83 c0 04             	add    $0x4,%eax
 539:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 53c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 53f:	bf 00 00 00 00       	mov    $0x0,%edi
 544:	e9 e9 00 00 00       	jmp    632 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 549:	83 f8 73             	cmp    $0x73,%eax
 54c:	75 52                	jne    5a0 <printf+0x11c>
        s = (char*)*ap;
 54e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 551:	8b 18                	mov    (%eax),%ebx
        ap++;
 553:	83 c0 04             	add    $0x4,%eax
 556:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 559:	85 db                	test   %ebx,%ebx
          s = "(null)";
 55b:	b8 cb 07 00 00       	mov    $0x7cb,%eax
 560:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 563:	0f b6 03             	movzbl (%ebx),%eax
 566:	84 c0                	test   %al,%al
 568:	0f 84 bf 00 00 00    	je     62d <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 571:	89 75 d0             	mov    %esi,-0x30(%ebp)
 574:	8b 75 08             	mov    0x8(%ebp),%esi
 577:	88 45 e3             	mov    %al,-0x1d(%ebp)
 57a:	83 ec 04             	sub    $0x4,%esp
 57d:	6a 01                	push   $0x1
 57f:	57                   	push   %edi
 580:	56                   	push   %esi
 581:	e8 c3 fd ff ff       	call   349 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 586:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 589:	0f b6 03             	movzbl (%ebx),%eax
 58c:	83 c4 10             	add    $0x10,%esp
 58f:	84 c0                	test   %al,%al
 591:	75 e4                	jne    577 <printf+0xf3>
 593:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 596:	bf 00 00 00 00       	mov    $0x0,%edi
 59b:	e9 92 00 00 00       	jmp    632 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a0:	83 f8 63             	cmp    $0x63,%eax
 5a3:	75 2b                	jne    5d0 <printf+0x14c>
 5a5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5a8:	8b 07                	mov    (%edi),%eax
 5aa:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5ad:	83 ec 04             	sub    $0x4,%esp
 5b0:	6a 01                	push   $0x1
 5b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 8b fd ff ff       	call   349 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 5be:	89 f8                	mov    %edi,%eax
 5c0:	83 c0 04             	add    $0x4,%eax
 5c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5c6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c9:	bf 00 00 00 00       	mov    $0x0,%edi
 5ce:	eb 62                	jmp    632 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5d0:	83 f8 25             	cmp    $0x25,%eax
 5d3:	75 1e                	jne    5f3 <printf+0x16f>
 5d5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d8:	83 ec 04             	sub    $0x4,%esp
 5db:	6a 01                	push   $0x1
 5dd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 60 fd ff ff       	call   349 <write>
 5e9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ec:	bf 00 00 00 00       	mov    $0x0,%edi
 5f1:	eb 3f                	jmp    632 <printf+0x1ae>
 5f3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5f7:	83 ec 04             	sub    $0x4,%esp
 5fa:	6a 01                	push   $0x1
 5fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5ff:	50                   	push   %eax
 600:	ff 75 08             	pushl  0x8(%ebp)
 603:	e8 41 fd ff ff       	call   349 <write>
 608:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 60b:	83 c4 0c             	add    $0xc,%esp
 60e:	6a 01                	push   $0x1
 610:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 2d fd ff ff       	call   349 <write>
 61c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 61f:	bf 00 00 00 00       	mov    $0x0,%edi
 624:	eb 0c                	jmp    632 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 626:	bf 25 00 00 00       	mov    $0x25,%edi
 62b:	eb 05                	jmp    632 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 62d:	bf 00 00 00 00       	mov    $0x0,%edi
 632:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 635:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 639:	84 db                	test   %bl,%bl
 63b:	0f 85 68 fe ff ff    	jne    4a9 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 641:	8d 65 f4             	lea    -0xc(%ebp),%esp
 644:	5b                   	pop    %ebx
 645:	5e                   	pop    %esi
 646:	5f                   	pop    %edi
 647:	5d                   	pop    %ebp
 648:	c3                   	ret    

00000649 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 649:	55                   	push   %ebp
 64a:	89 e5                	mov    %esp,%ebp
 64c:	57                   	push   %edi
 64d:	56                   	push   %esi
 64e:	53                   	push   %ebx
 64f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 652:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 655:	a1 60 0a 00 00       	mov    0xa60,%eax
 65a:	eb 0c                	jmp    668 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 65c:	8b 10                	mov    (%eax),%edx
 65e:	39 d0                	cmp    %edx,%eax
 660:	72 04                	jb     666 <free+0x1d>
 662:	39 d1                	cmp    %edx,%ecx
 664:	72 0c                	jb     672 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	39 c8                	cmp    %ecx,%eax
 66a:	73 f0                	jae    65c <free+0x13>
 66c:	8b 10                	mov    (%eax),%edx
 66e:	39 d1                	cmp    %edx,%ecx
 670:	73 3e                	jae    6b0 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 672:	8b 73 fc             	mov    -0x4(%ebx),%esi
 675:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 678:	8b 10                	mov    (%eax),%edx
 67a:	39 d7                	cmp    %edx,%edi
 67c:	75 0f                	jne    68d <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 67e:	03 77 04             	add    0x4(%edi),%esi
 681:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 684:	8b 10                	mov    (%eax),%edx
 686:	8b 12                	mov    (%edx),%edx
 688:	89 53 f8             	mov    %edx,-0x8(%ebx)
 68b:	eb 03                	jmp    690 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 68d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 690:	8b 50 04             	mov    0x4(%eax),%edx
 693:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 696:	39 f1                	cmp    %esi,%ecx
 698:	75 0d                	jne    6a7 <free+0x5e>
    p->s.size += bp->s.size;
 69a:	03 53 fc             	add    -0x4(%ebx),%edx
 69d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6a3:	89 10                	mov    %edx,(%eax)
 6a5:	eb 02                	jmp    6a9 <free+0x60>
  } else
    p->s.ptr = bp;
 6a7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6a9:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 6ae:	eb 06                	jmp    6b6 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	39 d0                	cmp    %edx,%eax
 6b2:	72 b2                	jb     666 <free+0x1d>
 6b4:	eb bc                	jmp    672 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 6b6:	5b                   	pop    %ebx
 6b7:	5e                   	pop    %esi
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret    

000006bb <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6bb:	55                   	push   %ebp
 6bc:	89 e5                	mov    %esp,%ebp
 6be:	57                   	push   %edi
 6bf:	56                   	push   %esi
 6c0:	53                   	push   %ebx
 6c1:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	8d 58 07             	lea    0x7(%eax),%ebx
 6ca:	c1 eb 03             	shr    $0x3,%ebx
 6cd:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6d0:	8b 15 60 0a 00 00    	mov    0xa60,%edx
 6d6:	85 d2                	test   %edx,%edx
 6d8:	75 23                	jne    6fd <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 6da:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 6e1:	0a 00 00 
 6e4:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 6eb:	0a 00 00 
    base.s.size = 0;
 6ee:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 6f5:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6f8:	ba 64 0a 00 00       	mov    $0xa64,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6fd:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ff:	8b 48 04             	mov    0x4(%eax),%ecx
 702:	39 cb                	cmp    %ecx,%ebx
 704:	77 20                	ja     726 <malloc+0x6b>
      if(p->s.size == nunits)
 706:	39 cb                	cmp    %ecx,%ebx
 708:	75 06                	jne    710 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 70a:	8b 08                	mov    (%eax),%ecx
 70c:	89 0a                	mov    %ecx,(%edx)
 70e:	eb 0b                	jmp    71b <malloc+0x60>
      else {
        p->s.size -= nunits;
 710:	29 d9                	sub    %ebx,%ecx
 712:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 715:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 718:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 71b:	89 15 60 0a 00 00    	mov    %edx,0xa60
      return (void*)(p + 1);
 721:	83 c0 08             	add    $0x8,%eax
 724:	eb 63                	jmp    789 <malloc+0xce>
 726:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 72c:	be 00 10 00 00       	mov    $0x1000,%esi
 731:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 734:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 73b:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73d:	39 05 60 0a 00 00    	cmp    %eax,0xa60
 743:	75 2d                	jne    772 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 745:	83 ec 0c             	sub    $0xc,%esp
 748:	57                   	push   %edi
 749:	e8 63 fc ff ff       	call   3b1 <sbrk>
  if(p == (char*)-1)
 74e:	83 c4 10             	add    $0x10,%esp
 751:	83 f8 ff             	cmp    $0xffffffff,%eax
 754:	74 27                	je     77d <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 756:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 759:	83 ec 0c             	sub    $0xc,%esp
 75c:	83 c0 08             	add    $0x8,%eax
 75f:	50                   	push   %eax
 760:	e8 e4 fe ff ff       	call   649 <free>
  return freep;
 765:	8b 15 60 0a 00 00    	mov    0xa60,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 76b:	83 c4 10             	add    $0x10,%esp
 76e:	85 d2                	test   %edx,%edx
 770:	74 12                	je     784 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 774:	8b 48 04             	mov    0x4(%eax),%ecx
 777:	39 cb                	cmp    %ecx,%ebx
 779:	77 c0                	ja     73b <malloc+0x80>
 77b:	eb 89                	jmp    706 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 77d:	b8 00 00 00 00       	mov    $0x0,%eax
 782:	eb 05                	jmp    789 <malloc+0xce>
 784:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 789:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78c:	5b                   	pop    %ebx
 78d:	5e                   	pop    %esi
 78e:	5f                   	pop    %edi
 78f:	5d                   	pop    %ebp
 790:	c3                   	ret    
