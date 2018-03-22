
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 2a 03 00 00       	call   33b <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	01 d8                	add    %ebx,%eax
  16:	72 11                	jb     29 <fmtname+0x29>
  18:	80 38 2f             	cmpb   $0x2f,(%eax)
  1b:	74 0c                	je     29 <fmtname+0x29>
  1d:	83 e8 01             	sub    $0x1,%eax
  20:	39 c3                	cmp    %eax,%ebx
  22:	77 05                	ja     29 <fmtname+0x29>
  24:	80 38 2f             	cmpb   $0x2f,(%eax)
  27:	75 f4                	jne    1d <fmtname+0x1d>
    ;
  p++;
  29:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	53                   	push   %ebx
  30:	e8 06 03 00 00       	call   33b <strlen>
  35:	83 c4 10             	add    $0x10,%esp
    return p;
  38:	89 da                	mov    %ebx,%edx
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	83 f8 0d             	cmp    $0xd,%eax
  3d:	77 4a                	ja     89 <fmtname+0x89>
    return p;
  memmove(buf, p, strlen(p));
  3f:	83 ec 0c             	sub    $0xc,%esp
  42:	53                   	push   %ebx
  43:	e8 f3 02 00 00       	call   33b <strlen>
  48:	83 c4 0c             	add    $0xc,%esp
  4b:	50                   	push   %eax
  4c:	53                   	push   %ebx
  4d:	68 20 0c 00 00       	push   $0xc20
  52:	e8 28 04 00 00       	call   47f <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  57:	89 1c 24             	mov    %ebx,(%esp)
  5a:	e8 dc 02 00 00       	call   33b <strlen>
  5f:	89 c6                	mov    %eax,%esi
  61:	89 1c 24             	mov    %ebx,(%esp)
  64:	e8 d2 02 00 00       	call   33b <strlen>
  69:	83 c4 0c             	add    $0xc,%esp
  6c:	ba 0e 00 00 00       	mov    $0xe,%edx
  71:	29 f2                	sub    %esi,%edx
  73:	52                   	push   %edx
  74:	6a 20                	push   $0x20
  76:	05 20 0c 00 00       	add    $0xc20,%eax
  7b:	50                   	push   %eax
  7c:	e8 de 02 00 00       	call   35f <memset>
  return buf;
  81:	83 c4 10             	add    $0x10,%esp
  84:	ba 20 0c 00 00       	mov    $0xc20,%edx
}
  89:	89 d0                	mov    %edx,%eax
  8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8e:	5b                   	pop    %ebx
  8f:	5e                   	pop    %esi
  90:	5d                   	pop    %ebp
  91:	c3                   	ret    

00000092 <ls>:

void
ls(char *path)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	56                   	push   %esi
  97:	53                   	push   %ebx
  98:	81 ec 54 02 00 00    	sub    $0x254,%esp
  9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  a1:	6a 00                	push   $0x0
  a3:	53                   	push   %ebx
  a4:	e8 47 04 00 00       	call   4f0 <open>
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	85 c0                	test   %eax,%eax
  ae:	79 18                	jns    c8 <ls+0x36>
    printf(2, "ls: cannot open %s\n", path);
  b0:	83 ec 04             	sub    $0x4,%esp
  b3:	53                   	push   %ebx
  b4:	68 18 09 00 00       	push   $0x918
  b9:	6a 02                	push   $0x2
  bb:	e8 4b 05 00 00       	call   60b <printf>
    return;
  c0:	83 c4 10             	add    $0x10,%esp
  c3:	e9 cd 01 00 00       	jmp    295 <ls+0x203>
  c8:	89 c6                	mov    %eax,%esi
  }

  if(fstat(fd, &st) < 0){
  ca:	83 ec 08             	sub    $0x8,%esp
  cd:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  d3:	50                   	push   %eax
  d4:	56                   	push   %esi
  d5:	e8 2e 04 00 00       	call   508 <fstat>
  da:	83 c4 10             	add    $0x10,%esp
  dd:	85 c0                	test   %eax,%eax
  df:	79 20                	jns    101 <ls+0x6f>
    printf(2, "ls: cannot stat %s\n", path);
  e1:	83 ec 04             	sub    $0x4,%esp
  e4:	53                   	push   %ebx
  e5:	68 2c 09 00 00       	push   $0x92c
  ea:	6a 02                	push   $0x2
  ec:	e8 1a 05 00 00       	call   60b <printf>
    close(fd);
  f1:	89 34 24             	mov    %esi,(%esp)
  f4:	e8 df 03 00 00       	call   4d8 <close>
    return;
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	e9 94 01 00 00       	jmp    295 <ls+0x203>
  }

  switch(st.type){
 101:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
 108:	66 83 f8 01          	cmp    $0x1,%ax
 10c:	74 46                	je     154 <ls+0xc2>
 10e:	66 83 f8 02          	cmp    $0x2,%ax
 112:	0f 85 71 01 00 00    	jne    289 <ls+0x1f7>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 118:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
 11e:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 124:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 12a:	83 ec 0c             	sub    $0xc,%esp
 12d:	53                   	push   %ebx
 12e:	e8 cd fe ff ff       	call   0 <fmtname>
 133:	83 c4 08             	add    $0x8,%esp
 136:	57                   	push   %edi
 137:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 13d:	6a 02                	push   $0x2
 13f:	50                   	push   %eax
 140:	68 40 09 00 00       	push   $0x940
 145:	6a 01                	push   $0x1
 147:	e8 bf 04 00 00       	call   60b <printf>
    break;
 14c:	83 c4 20             	add    $0x20,%esp
 14f:	e9 35 01 00 00       	jmp    289 <ls+0x1f7>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 154:	83 ec 0c             	sub    $0xc,%esp
 157:	53                   	push   %ebx
 158:	e8 de 01 00 00       	call   33b <strlen>
 15d:	83 c0 10             	add    $0x10,%eax
 160:	83 c4 10             	add    $0x10,%esp
 163:	3d 00 02 00 00       	cmp    $0x200,%eax
 168:	76 17                	jbe    181 <ls+0xef>
      printf(1, "ls: path too long\n");
 16a:	83 ec 08             	sub    $0x8,%esp
 16d:	68 4d 09 00 00       	push   $0x94d
 172:	6a 01                	push   $0x1
 174:	e8 92 04 00 00       	call   60b <printf>
      break;
 179:	83 c4 10             	add    $0x10,%esp
 17c:	e9 08 01 00 00       	jmp    289 <ls+0x1f7>
    }
    strcpy(buf, path);
 181:	83 ec 08             	sub    $0x8,%esp
 184:	53                   	push   %ebx
 185:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
 18b:	53                   	push   %ebx
 18c:	e8 5b 01 00 00       	call   2ec <strcpy>
    p = buf+strlen(buf);
 191:	89 1c 24             	mov    %ebx,(%esp)
 194:	e8 a2 01 00 00       	call   33b <strlen>
 199:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
    *p++ = '/';
 19c:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
 1a0:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
 1a6:	c6 07 2f             	movb   $0x2f,(%edi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1a9:	83 c4 10             	add    $0x10,%esp
 1ac:	8d 9d d8 fd ff ff    	lea    -0x228(%ebp),%ebx
 1b2:	e9 ba 00 00 00       	jmp    271 <ls+0x1df>
      if(de.inum == 0)
 1b7:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1be:	00 
 1bf:	0f 84 ac 00 00 00    	je     271 <ls+0x1df>
        continue;
      memmove(p, de.name, DIRSIZ);
 1c5:	83 ec 04             	sub    $0x4,%esp
 1c8:	6a 0e                	push   $0xe
 1ca:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 1d0:	50                   	push   %eax
 1d1:	ff b5 a8 fd ff ff    	pushl  -0x258(%ebp)
 1d7:	e8 a3 02 00 00       	call   47f <memmove>
      p[DIRSIZ] = 0;
 1dc:	c6 47 0f 00          	movb   $0x0,0xf(%edi)
      if(stat(buf, &st) < 0){
 1e0:	83 c4 08             	add    $0x8,%esp
 1e3:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 1e9:	50                   	push   %eax
 1ea:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1f0:	50                   	push   %eax
 1f1:	e8 0d 02 00 00       	call   403 <stat>
 1f6:	83 c4 10             	add    $0x10,%esp
 1f9:	85 c0                	test   %eax,%eax
 1fb:	79 1b                	jns    218 <ls+0x186>
        printf(1, "ls: cannot stat %s\n", buf);
 1fd:	83 ec 04             	sub    $0x4,%esp
 200:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 206:	50                   	push   %eax
 207:	68 2c 09 00 00       	push   $0x92c
 20c:	6a 01                	push   $0x1
 20e:	e8 f8 03 00 00       	call   60b <printf>
        continue;
 213:	83 c4 10             	add    $0x10,%esp
 216:	eb 59                	jmp    271 <ls+0x1df>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 218:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 21e:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 224:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 22a:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 230:	0f bf 8d c4 fd ff ff 	movswl -0x23c(%ebp),%ecx
 237:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 23d:	83 ec 0c             	sub    $0xc,%esp
 240:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 246:	50                   	push   %eax
 247:	e8 b4 fd ff ff       	call   0 <fmtname>
 24c:	83 c4 08             	add    $0x8,%esp
 24f:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 255:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 25b:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 261:	50                   	push   %eax
 262:	68 40 09 00 00       	push   $0x940
 267:	6a 01                	push   $0x1
 269:	e8 9d 03 00 00       	call   60b <printf>
 26e:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 271:	83 ec 04             	sub    $0x4,%esp
 274:	6a 10                	push   $0x10
 276:	53                   	push   %ebx
 277:	56                   	push   %esi
 278:	e8 4b 02 00 00       	call   4c8 <read>
 27d:	83 c4 10             	add    $0x10,%esp
 280:	83 f8 10             	cmp    $0x10,%eax
 283:	0f 84 2e ff ff ff    	je     1b7 <ls+0x125>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 289:	83 ec 0c             	sub    $0xc,%esp
 28c:	56                   	push   %esi
 28d:	e8 46 02 00 00       	call   4d8 <close>
 292:	83 c4 10             	add    $0x10,%esp
}
 295:	8d 65 f4             	lea    -0xc(%ebp),%esp
 298:	5b                   	pop    %ebx
 299:	5e                   	pop    %esi
 29a:	5f                   	pop    %edi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    

0000029d <main>:

int
main(int argc, char *argv[])
{
 29d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2a1:	83 e4 f0             	and    $0xfffffff0,%esp
 2a4:	ff 71 fc             	pushl  -0x4(%ecx)
 2a7:	55                   	push   %ebp
 2a8:	89 e5                	mov    %esp,%ebp
 2aa:	57                   	push   %edi
 2ab:	56                   	push   %esi
 2ac:	53                   	push   %ebx
 2ad:	51                   	push   %ecx
 2ae:	83 ec 08             	sub    $0x8,%esp
 2b1:	8b 31                	mov    (%ecx),%esi
 2b3:	8b 79 04             	mov    0x4(%ecx),%edi
 2b6:	bb 01 00 00 00       	mov    $0x1,%ebx
  int i;

  if(argc < 2){
 2bb:	83 fe 01             	cmp    $0x1,%esi
 2be:	7f 12                	jg     2d2 <main+0x35>
    ls(".");
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	68 60 09 00 00       	push   $0x960
 2c8:	e8 c5 fd ff ff       	call   92 <ls>
    exit();
 2cd:	e8 de 01 00 00       	call   4b0 <exit>
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2d2:	83 ec 0c             	sub    $0xc,%esp
 2d5:	ff 34 9f             	pushl  (%edi,%ebx,4)
 2d8:	e8 b5 fd ff ff       	call   92 <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 2dd:	83 c3 01             	add    $0x1,%ebx
 2e0:	83 c4 10             	add    $0x10,%esp
 2e3:	39 de                	cmp    %ebx,%esi
 2e5:	75 eb                	jne    2d2 <main+0x35>
    ls(argv[i]);
  exit();
 2e7:	e8 c4 01 00 00       	call   4b0 <exit>

000002ec <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f6:	89 c2                	mov    %eax,%edx
 2f8:	83 c2 01             	add    $0x1,%edx
 2fb:	83 c1 01             	add    $0x1,%ecx
 2fe:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 302:	88 5a ff             	mov    %bl,-0x1(%edx)
 305:	84 db                	test   %bl,%bl
 307:	75 ef                	jne    2f8 <strcpy+0xc>
    ;
  return os;
}
 309:	5b                   	pop    %ebx
 30a:	5d                   	pop    %ebp
 30b:	c3                   	ret    

0000030c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 30c:	55                   	push   %ebp
 30d:	89 e5                	mov    %esp,%ebp
 30f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 312:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 315:	0f b6 01             	movzbl (%ecx),%eax
 318:	84 c0                	test   %al,%al
 31a:	74 15                	je     331 <strcmp+0x25>
 31c:	3a 02                	cmp    (%edx),%al
 31e:	75 11                	jne    331 <strcmp+0x25>
    p++, q++;
 320:	83 c1 01             	add    $0x1,%ecx
 323:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 326:	0f b6 01             	movzbl (%ecx),%eax
 329:	84 c0                	test   %al,%al
 32b:	74 04                	je     331 <strcmp+0x25>
 32d:	3a 02                	cmp    (%edx),%al
 32f:	74 ef                	je     320 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 331:	0f b6 c0             	movzbl %al,%eax
 334:	0f b6 12             	movzbl (%edx),%edx
 337:	29 d0                	sub    %edx,%eax
}
 339:	5d                   	pop    %ebp
 33a:	c3                   	ret    

0000033b <strlen>:

uint
strlen(char *s)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 341:	80 39 00             	cmpb   $0x0,(%ecx)
 344:	74 12                	je     358 <strlen+0x1d>
 346:	ba 00 00 00 00       	mov    $0x0,%edx
 34b:	83 c2 01             	add    $0x1,%edx
 34e:	89 d0                	mov    %edx,%eax
 350:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 354:	75 f5                	jne    34b <strlen+0x10>
 356:	eb 05                	jmp    35d <strlen+0x22>
 358:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    

0000035f <memset>:

void*
memset(void *dst, int c, uint n)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	57                   	push   %edi
 363:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 366:	89 d7                	mov    %edx,%edi
 368:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	fc                   	cld    
 36f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 371:	89 d0                	mov    %edx,%eax
 373:	5f                   	pop    %edi
 374:	5d                   	pop    %ebp
 375:	c3                   	ret    

00000376 <strchr>:

char*
strchr(const char *s, char c)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	53                   	push   %ebx
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 380:	0f b6 10             	movzbl (%eax),%edx
 383:	84 d2                	test   %dl,%dl
 385:	74 1d                	je     3a4 <strchr+0x2e>
 387:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 389:	38 d3                	cmp    %dl,%bl
 38b:	75 06                	jne    393 <strchr+0x1d>
 38d:	eb 1a                	jmp    3a9 <strchr+0x33>
 38f:	38 ca                	cmp    %cl,%dl
 391:	74 16                	je     3a9 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 393:	83 c0 01             	add    $0x1,%eax
 396:	0f b6 10             	movzbl (%eax),%edx
 399:	84 d2                	test   %dl,%dl
 39b:	75 f2                	jne    38f <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 39d:	b8 00 00 00 00       	mov    $0x0,%eax
 3a2:	eb 05                	jmp    3a9 <strchr+0x33>
 3a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a9:	5b                   	pop    %ebx
 3aa:	5d                   	pop    %ebp
 3ab:	c3                   	ret    

000003ac <gets>:

char*
gets(char *buf, int max)
{
 3ac:	55                   	push   %ebp
 3ad:	89 e5                	mov    %esp,%ebp
 3af:	57                   	push   %edi
 3b0:	56                   	push   %esi
 3b1:	53                   	push   %ebx
 3b2:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b5:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 3ba:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3bd:	eb 29                	jmp    3e8 <gets+0x3c>
    cc = read(0, &c, 1);
 3bf:	83 ec 04             	sub    $0x4,%esp
 3c2:	6a 01                	push   $0x1
 3c4:	57                   	push   %edi
 3c5:	6a 00                	push   $0x0
 3c7:	e8 fc 00 00 00       	call   4c8 <read>
    if(cc < 1)
 3cc:	83 c4 10             	add    $0x10,%esp
 3cf:	85 c0                	test   %eax,%eax
 3d1:	7e 21                	jle    3f4 <gets+0x48>
      break;
    buf[i++] = c;
 3d3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3d7:	8b 55 08             	mov    0x8(%ebp),%edx
 3da:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3de:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e0:	3c 0a                	cmp    $0xa,%al
 3e2:	74 0e                	je     3f2 <gets+0x46>
 3e4:	3c 0d                	cmp    $0xd,%al
 3e6:	74 0a                	je     3f2 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e8:	8d 5e 01             	lea    0x1(%esi),%ebx
 3eb:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3ee:	7c cf                	jl     3bf <gets+0x13>
 3f0:	eb 02                	jmp    3f4 <gets+0x48>
 3f2:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3fe:	5b                   	pop    %ebx
 3ff:	5e                   	pop    %esi
 400:	5f                   	pop    %edi
 401:	5d                   	pop    %ebp
 402:	c3                   	ret    

00000403 <stat>:

int
stat(char *n, struct stat *st)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	56                   	push   %esi
 407:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 408:	83 ec 08             	sub    $0x8,%esp
 40b:	6a 00                	push   $0x0
 40d:	ff 75 08             	pushl  0x8(%ebp)
 410:	e8 db 00 00 00       	call   4f0 <open>
  if(fd < 0)
 415:	83 c4 10             	add    $0x10,%esp
 418:	85 c0                	test   %eax,%eax
 41a:	78 1f                	js     43b <stat+0x38>
 41c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 41e:	83 ec 08             	sub    $0x8,%esp
 421:	ff 75 0c             	pushl  0xc(%ebp)
 424:	50                   	push   %eax
 425:	e8 de 00 00 00       	call   508 <fstat>
 42a:	89 c6                	mov    %eax,%esi
  close(fd);
 42c:	89 1c 24             	mov    %ebx,(%esp)
 42f:	e8 a4 00 00 00       	call   4d8 <close>
  return r;
 434:	83 c4 10             	add    $0x10,%esp
 437:	89 f0                	mov    %esi,%eax
 439:	eb 05                	jmp    440 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 43b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 440:	8d 65 f8             	lea    -0x8(%ebp),%esp
 443:	5b                   	pop    %ebx
 444:	5e                   	pop    %esi
 445:	5d                   	pop    %ebp
 446:	c3                   	ret    

00000447 <atoi>:

int
atoi(const char *s)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	53                   	push   %ebx
 44b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44e:	0f b6 11             	movzbl (%ecx),%edx
 451:	8d 42 d0             	lea    -0x30(%edx),%eax
 454:	3c 09                	cmp    $0x9,%al
 456:	77 1f                	ja     477 <atoi+0x30>
 458:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 45d:	83 c1 01             	add    $0x1,%ecx
 460:	8d 04 80             	lea    (%eax,%eax,4),%eax
 463:	0f be d2             	movsbl %dl,%edx
 466:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46a:	0f b6 11             	movzbl (%ecx),%edx
 46d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 470:	80 fb 09             	cmp    $0x9,%bl
 473:	76 e8                	jbe    45d <atoi+0x16>
 475:	eb 05                	jmp    47c <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 477:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 47c:	5b                   	pop    %ebx
 47d:	5d                   	pop    %ebp
 47e:	c3                   	ret    

0000047f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 47f:	55                   	push   %ebp
 480:	89 e5                	mov    %esp,%ebp
 482:	56                   	push   %esi
 483:	53                   	push   %ebx
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	8b 75 0c             	mov    0xc(%ebp),%esi
 48a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48d:	85 db                	test   %ebx,%ebx
 48f:	7e 13                	jle    4a4 <memmove+0x25>
 491:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 496:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 49a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 49d:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4a0:	39 da                	cmp    %ebx,%edx
 4a2:	75 f2                	jne    496 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 4a4:	5b                   	pop    %ebx
 4a5:	5e                   	pop    %esi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    

000004a8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4a8:	b8 01 00 00 00       	mov    $0x1,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <exit>:
SYSCALL(exit)
 4b0:	b8 02 00 00 00       	mov    $0x2,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <wait>:
SYSCALL(wait)
 4b8:	b8 03 00 00 00       	mov    $0x3,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <pipe>:
SYSCALL(pipe)
 4c0:	b8 04 00 00 00       	mov    $0x4,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <read>:
SYSCALL(read)
 4c8:	b8 05 00 00 00       	mov    $0x5,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <write>:
SYSCALL(write)
 4d0:	b8 10 00 00 00       	mov    $0x10,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <close>:
SYSCALL(close)
 4d8:	b8 15 00 00 00       	mov    $0x15,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <kill>:
SYSCALL(kill)
 4e0:	b8 06 00 00 00       	mov    $0x6,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <exec>:
SYSCALL(exec)
 4e8:	b8 07 00 00 00       	mov    $0x7,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <open>:
SYSCALL(open)
 4f0:	b8 0f 00 00 00       	mov    $0xf,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <mknod>:
SYSCALL(mknod)
 4f8:	b8 11 00 00 00       	mov    $0x11,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <unlink>:
SYSCALL(unlink)
 500:	b8 12 00 00 00       	mov    $0x12,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <fstat>:
SYSCALL(fstat)
 508:	b8 08 00 00 00       	mov    $0x8,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <link>:
SYSCALL(link)
 510:	b8 13 00 00 00       	mov    $0x13,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <mkdir>:
SYSCALL(mkdir)
 518:	b8 14 00 00 00       	mov    $0x14,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <chdir>:
SYSCALL(chdir)
 520:	b8 09 00 00 00       	mov    $0x9,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <dup>:
SYSCALL(dup)
 528:	b8 0a 00 00 00       	mov    $0xa,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <getpid>:
SYSCALL(getpid)
 530:	b8 0b 00 00 00       	mov    $0xb,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <sbrk>:
SYSCALL(sbrk)
 538:	b8 0c 00 00 00       	mov    $0xc,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <sleep>:
SYSCALL(sleep)
 540:	b8 0d 00 00 00       	mov    $0xd,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <uptime>:
SYSCALL(uptime)
 548:	b8 0e 00 00 00       	mov    $0xe,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <setvariable>:
SYSCALL(setvariable)
 550:	b8 17 00 00 00       	mov    $0x17,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <getvariable>:
SYSCALL(getvariable)
 558:	b8 18 00 00 00       	mov    $0x18,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <remvariable>:
SYSCALL(remvariable)
 560:	b8 19 00 00 00       	mov    $0x19,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <wait2>:
SYSCALL(wait2)
 568:	b8 1a 00 00 00       	mov    $0x1a,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <set_priority>:
SYSCALL(set_priority)
 570:	b8 1b 00 00 00       	mov    $0x1b,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	57                   	push   %edi
 57c:	56                   	push   %esi
 57d:	53                   	push   %ebx
 57e:	83 ec 3c             	sub    $0x3c,%esp
 581:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 584:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 588:	74 12                	je     59c <printint+0x24>
 58a:	89 d0                	mov    %edx,%eax
 58c:	c1 e8 1f             	shr    $0x1f,%eax
 58f:	84 c0                	test   %al,%al
 591:	74 09                	je     59c <printint+0x24>
    neg = 1;
    x = -xx;
 593:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 595:	be 01 00 00 00       	mov    $0x1,%esi
 59a:	eb 05                	jmp    5a1 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 59c:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5a1:	bf 00 00 00 00       	mov    $0x0,%edi
 5a6:	eb 02                	jmp    5aa <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 5a8:	89 df                	mov    %ebx,%edi
 5aa:	8d 5f 01             	lea    0x1(%edi),%ebx
 5ad:	89 d0                	mov    %edx,%eax
 5af:	ba 00 00 00 00       	mov    $0x0,%edx
 5b4:	f7 f1                	div    %ecx
 5b6:	0f b6 92 6c 09 00 00 	movzbl 0x96c(%edx),%edx
 5bd:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 5c1:	89 c2                	mov    %eax,%edx
 5c3:	85 c0                	test   %eax,%eax
 5c5:	75 e1                	jne    5a8 <printint+0x30>
  if(neg)
 5c7:	85 f6                	test   %esi,%esi
 5c9:	74 08                	je     5d3 <printint+0x5b>
    buf[i++] = '-';
 5cb:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 5d0:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 5d3:	89 d8                	mov    %ebx,%eax
 5d5:	83 e8 01             	sub    $0x1,%eax
 5d8:	78 29                	js     603 <printint+0x8b>
 5da:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 5dd:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5e1:	8d 7d d7             	lea    -0x29(%ebp),%edi
 5e4:	0f b6 03             	movzbl (%ebx),%eax
 5e7:	88 45 d7             	mov    %al,-0x29(%ebp)
 5ea:	83 ec 04             	sub    $0x4,%esp
 5ed:	6a 01                	push   $0x1
 5ef:	57                   	push   %edi
 5f0:	56                   	push   %esi
 5f1:	e8 da fe ff ff       	call   4d0 <write>
 5f6:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f9:	83 c4 10             	add    $0x10,%esp
 5fc:	8d 45 d7             	lea    -0x29(%ebp),%eax
 5ff:	39 c3                	cmp    %eax,%ebx
 601:	75 e1                	jne    5e4 <printint+0x6c>
    putc(fd, buf[i]);
}
 603:	8d 65 f4             	lea    -0xc(%ebp),%esp
 606:	5b                   	pop    %ebx
 607:	5e                   	pop    %esi
 608:	5f                   	pop    %edi
 609:	5d                   	pop    %ebp
 60a:	c3                   	ret    

0000060b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60b:	55                   	push   %ebp
 60c:	89 e5                	mov    %esp,%ebp
 60e:	57                   	push   %edi
 60f:	56                   	push   %esi
 610:	53                   	push   %ebx
 611:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 614:	8b 75 0c             	mov    0xc(%ebp),%esi
 617:	0f b6 1e             	movzbl (%esi),%ebx
 61a:	84 db                	test   %bl,%bl
 61c:	0f 84 a6 01 00 00    	je     7c8 <printf+0x1bd>
 622:	83 c6 01             	add    $0x1,%esi
 625:	8d 45 10             	lea    0x10(%ebp),%eax
 628:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 62b:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 630:	0f be d3             	movsbl %bl,%edx
 633:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 636:	85 ff                	test   %edi,%edi
 638:	75 25                	jne    65f <printf+0x54>
      if(c == '%'){
 63a:	83 f8 25             	cmp    $0x25,%eax
 63d:	0f 84 6a 01 00 00    	je     7ad <printf+0x1a2>
 643:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 646:	83 ec 04             	sub    $0x4,%esp
 649:	6a 01                	push   $0x1
 64b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 64e:	50                   	push   %eax
 64f:	ff 75 08             	pushl  0x8(%ebp)
 652:	e8 79 fe ff ff       	call   4d0 <write>
 657:	83 c4 10             	add    $0x10,%esp
 65a:	e9 5a 01 00 00       	jmp    7b9 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 65f:	83 ff 25             	cmp    $0x25,%edi
 662:	0f 85 51 01 00 00    	jne    7b9 <printf+0x1ae>
      if(c == 'd'){
 668:	83 f8 64             	cmp    $0x64,%eax
 66b:	75 2c                	jne    699 <printf+0x8e>
        printint(fd, *ap, 10, 1);
 66d:	83 ec 0c             	sub    $0xc,%esp
 670:	6a 01                	push   $0x1
 672:	b9 0a 00 00 00       	mov    $0xa,%ecx
 677:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 67a:	8b 17                	mov    (%edi),%edx
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	e8 f4 fe ff ff       	call   578 <printint>
        ap++;
 684:	89 f8                	mov    %edi,%eax
 686:	83 c0 04             	add    $0x4,%eax
 689:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 68c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68f:	bf 00 00 00 00       	mov    $0x0,%edi
 694:	e9 20 01 00 00       	jmp    7b9 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 699:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 69f:	83 fa 70             	cmp    $0x70,%edx
 6a2:	75 2c                	jne    6d0 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 6a4:	83 ec 0c             	sub    $0xc,%esp
 6a7:	6a 00                	push   $0x0
 6a9:	b9 10 00 00 00       	mov    $0x10,%ecx
 6ae:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6b1:	8b 17                	mov    (%edi),%edx
 6b3:	8b 45 08             	mov    0x8(%ebp),%eax
 6b6:	e8 bd fe ff ff       	call   578 <printint>
        ap++;
 6bb:	89 f8                	mov    %edi,%eax
 6bd:	83 c0 04             	add    $0x4,%eax
 6c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6c3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6c6:	bf 00 00 00 00       	mov    $0x0,%edi
 6cb:	e9 e9 00 00 00       	jmp    7b9 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6d0:	83 f8 73             	cmp    $0x73,%eax
 6d3:	75 52                	jne    727 <printf+0x11c>
        s = (char*)*ap;
 6d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6d8:	8b 18                	mov    (%eax),%ebx
        ap++;
 6da:	83 c0 04             	add    $0x4,%eax
 6dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6e0:	85 db                	test   %ebx,%ebx
          s = "(null)";
 6e2:	b8 62 09 00 00       	mov    $0x962,%eax
 6e7:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6ea:	0f b6 03             	movzbl (%ebx),%eax
 6ed:	84 c0                	test   %al,%al
 6ef:	0f 84 bf 00 00 00    	je     7b4 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6f5:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6f8:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6fb:	8b 75 08             	mov    0x8(%ebp),%esi
 6fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
 701:	83 ec 04             	sub    $0x4,%esp
 704:	6a 01                	push   $0x1
 706:	57                   	push   %edi
 707:	56                   	push   %esi
 708:	e8 c3 fd ff ff       	call   4d0 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 70d:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 710:	0f b6 03             	movzbl (%ebx),%eax
 713:	83 c4 10             	add    $0x10,%esp
 716:	84 c0                	test   %al,%al
 718:	75 e4                	jne    6fe <printf+0xf3>
 71a:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 71d:	bf 00 00 00 00       	mov    $0x0,%edi
 722:	e9 92 00 00 00       	jmp    7b9 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 727:	83 f8 63             	cmp    $0x63,%eax
 72a:	75 2b                	jne    757 <printf+0x14c>
 72c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 72f:	8b 07                	mov    (%edi),%eax
 731:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 734:	83 ec 04             	sub    $0x4,%esp
 737:	6a 01                	push   $0x1
 739:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 73c:	50                   	push   %eax
 73d:	ff 75 08             	pushl  0x8(%ebp)
 740:	e8 8b fd ff ff       	call   4d0 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 745:	89 f8                	mov    %edi,%eax
 747:	83 c0 04             	add    $0x4,%eax
 74a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 74d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 750:	bf 00 00 00 00       	mov    $0x0,%edi
 755:	eb 62                	jmp    7b9 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 757:	83 f8 25             	cmp    $0x25,%eax
 75a:	75 1e                	jne    77a <printf+0x16f>
 75c:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 75f:	83 ec 04             	sub    $0x4,%esp
 762:	6a 01                	push   $0x1
 764:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 767:	50                   	push   %eax
 768:	ff 75 08             	pushl  0x8(%ebp)
 76b:	e8 60 fd ff ff       	call   4d0 <write>
 770:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 773:	bf 00 00 00 00       	mov    $0x0,%edi
 778:	eb 3f                	jmp    7b9 <printf+0x1ae>
 77a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 77e:	83 ec 04             	sub    $0x4,%esp
 781:	6a 01                	push   $0x1
 783:	8d 45 e7             	lea    -0x19(%ebp),%eax
 786:	50                   	push   %eax
 787:	ff 75 08             	pushl  0x8(%ebp)
 78a:	e8 41 fd ff ff       	call   4d0 <write>
 78f:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 792:	83 c4 0c             	add    $0xc,%esp
 795:	6a 01                	push   $0x1
 797:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 79a:	50                   	push   %eax
 79b:	ff 75 08             	pushl  0x8(%ebp)
 79e:	e8 2d fd ff ff       	call   4d0 <write>
 7a3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a6:	bf 00 00 00 00       	mov    $0x0,%edi
 7ab:	eb 0c                	jmp    7b9 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7ad:	bf 25 00 00 00       	mov    $0x25,%edi
 7b2:	eb 05                	jmp    7b9 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7b4:	bf 00 00 00 00       	mov    $0x0,%edi
 7b9:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7bc:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7c0:	84 db                	test   %bl,%bl
 7c2:	0f 85 68 fe ff ff    	jne    630 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7cb:	5b                   	pop    %ebx
 7cc:	5e                   	pop    %esi
 7cd:	5f                   	pop    %edi
 7ce:	5d                   	pop    %ebp
 7cf:	c3                   	ret    

000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d9:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	a1 30 0c 00 00       	mov    0xc30,%eax
 7e1:	eb 0c                	jmp    7ef <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e3:	8b 10                	mov    (%eax),%edx
 7e5:	39 d0                	cmp    %edx,%eax
 7e7:	72 04                	jb     7ed <free+0x1d>
 7e9:	39 d1                	cmp    %edx,%ecx
 7eb:	72 0c                	jb     7f9 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ed:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ef:	39 c8                	cmp    %ecx,%eax
 7f1:	73 f0                	jae    7e3 <free+0x13>
 7f3:	8b 10                	mov    (%eax),%edx
 7f5:	39 d1                	cmp    %edx,%ecx
 7f7:	73 3e                	jae    837 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f9:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7fc:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ff:	8b 10                	mov    (%eax),%edx
 801:	39 d7                	cmp    %edx,%edi
 803:	75 0f                	jne    814 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 805:	03 77 04             	add    0x4(%edi),%esi
 808:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 80b:	8b 10                	mov    (%eax),%edx
 80d:	8b 12                	mov    (%edx),%edx
 80f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 812:	eb 03                	jmp    817 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 814:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 817:	8b 50 04             	mov    0x4(%eax),%edx
 81a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 81d:	39 f1                	cmp    %esi,%ecx
 81f:	75 0d                	jne    82e <free+0x5e>
    p->s.size += bp->s.size;
 821:	03 53 fc             	add    -0x4(%ebx),%edx
 824:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 827:	8b 53 f8             	mov    -0x8(%ebx),%edx
 82a:	89 10                	mov    %edx,(%eax)
 82c:	eb 02                	jmp    830 <free+0x60>
  } else
    p->s.ptr = bp;
 82e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 830:	a3 30 0c 00 00       	mov    %eax,0xc30
}
 835:	eb 06                	jmp    83d <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 837:	39 d0                	cmp    %edx,%eax
 839:	72 b2                	jb     7ed <free+0x1d>
 83b:	eb bc                	jmp    7f9 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 83d:	5b                   	pop    %ebx
 83e:	5e                   	pop    %esi
 83f:	5f                   	pop    %edi
 840:	5d                   	pop    %ebp
 841:	c3                   	ret    

00000842 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	57                   	push   %edi
 846:	56                   	push   %esi
 847:	53                   	push   %ebx
 848:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84b:	8b 45 08             	mov    0x8(%ebp),%eax
 84e:	8d 58 07             	lea    0x7(%eax),%ebx
 851:	c1 eb 03             	shr    $0x3,%ebx
 854:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 857:	8b 15 30 0c 00 00    	mov    0xc30,%edx
 85d:	85 d2                	test   %edx,%edx
 85f:	75 23                	jne    884 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 861:	c7 05 30 0c 00 00 34 	movl   $0xc34,0xc30
 868:	0c 00 00 
 86b:	c7 05 34 0c 00 00 34 	movl   $0xc34,0xc34
 872:	0c 00 00 
    base.s.size = 0;
 875:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 87c:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 87f:	ba 34 0c 00 00       	mov    $0xc34,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 886:	8b 48 04             	mov    0x4(%eax),%ecx
 889:	39 cb                	cmp    %ecx,%ebx
 88b:	77 20                	ja     8ad <malloc+0x6b>
      if(p->s.size == nunits)
 88d:	39 cb                	cmp    %ecx,%ebx
 88f:	75 06                	jne    897 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 891:	8b 08                	mov    (%eax),%ecx
 893:	89 0a                	mov    %ecx,(%edx)
 895:	eb 0b                	jmp    8a2 <malloc+0x60>
      else {
        p->s.size -= nunits;
 897:	29 d9                	sub    %ebx,%ecx
 899:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 89c:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 89f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 8a2:	89 15 30 0c 00 00    	mov    %edx,0xc30
      return (void*)(p + 1);
 8a8:	83 c0 08             	add    $0x8,%eax
 8ab:	eb 63                	jmp    910 <malloc+0xce>
 8ad:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 8b3:	be 00 10 00 00       	mov    $0x1000,%esi
 8b8:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8bb:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 8c2:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8c4:	39 05 30 0c 00 00    	cmp    %eax,0xc30
 8ca:	75 2d                	jne    8f9 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8cc:	83 ec 0c             	sub    $0xc,%esp
 8cf:	57                   	push   %edi
 8d0:	e8 63 fc ff ff       	call   538 <sbrk>
  if(p == (char*)-1)
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	83 f8 ff             	cmp    $0xffffffff,%eax
 8db:	74 27                	je     904 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8dd:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 8e0:	83 ec 0c             	sub    $0xc,%esp
 8e3:	83 c0 08             	add    $0x8,%eax
 8e6:	50                   	push   %eax
 8e7:	e8 e4 fe ff ff       	call   7d0 <free>
  return freep;
 8ec:	8b 15 30 0c 00 00    	mov    0xc30,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8f2:	83 c4 10             	add    $0x10,%esp
 8f5:	85 d2                	test   %edx,%edx
 8f7:	74 12                	je     90b <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8fb:	8b 48 04             	mov    0x4(%eax),%ecx
 8fe:	39 cb                	cmp    %ecx,%ebx
 900:	77 c0                	ja     8c2 <malloc+0x80>
 902:	eb 89                	jmp    88d <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 904:	b8 00 00 00 00       	mov    $0x0,%eax
 909:	eb 05                	jmp    910 <malloc+0xce>
 90b:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 910:	8d 65 f4             	lea    -0xc(%ebp),%esp
 913:	5b                   	pop    %ebx
 914:	5e                   	pop    %esi
 915:	5f                   	pop    %edi
 916:	5d                   	pop    %ebp
 917:	c3                   	ret    
