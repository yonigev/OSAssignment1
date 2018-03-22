
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       6:	68 f4 3a 00 00       	push   $0x3af4
       b:	ff 35 24 5a 00 00    	pushl  0x5a24
      11:	e8 3c 37 00 00       	call   3752 <printf>

  if(mkdir("iputdir") < 0){
      16:	c7 04 24 87 3a 00 00 	movl   $0x3a87,(%esp)
      1d:	e8 3d 36 00 00       	call   365f <mkdir>
      22:	83 c4 10             	add    $0x10,%esp
      25:	85 c0                	test   %eax,%eax
      27:	79 18                	jns    41 <iputtest+0x41>
    printf(stdout, "mkdir failed\n");
      29:	83 ec 08             	sub    $0x8,%esp
      2c:	68 60 3a 00 00       	push   $0x3a60
      31:	ff 35 24 5a 00 00    	pushl  0x5a24
      37:	e8 16 37 00 00       	call   3752 <printf>
    exit();
      3c:	e8 b6 35 00 00       	call   35f7 <exit>
  }
  if(chdir("iputdir") < 0){
      41:	83 ec 0c             	sub    $0xc,%esp
      44:	68 87 3a 00 00       	push   $0x3a87
      49:	e8 19 36 00 00       	call   3667 <chdir>
      4e:	83 c4 10             	add    $0x10,%esp
      51:	85 c0                	test   %eax,%eax
      53:	79 18                	jns    6d <iputtest+0x6d>
    printf(stdout, "chdir iputdir failed\n");
      55:	83 ec 08             	sub    $0x8,%esp
      58:	68 6e 3a 00 00       	push   $0x3a6e
      5d:	ff 35 24 5a 00 00    	pushl  0x5a24
      63:	e8 ea 36 00 00       	call   3752 <printf>
    exit();
      68:	e8 8a 35 00 00       	call   35f7 <exit>
  }
  if(unlink("../iputdir") < 0){
      6d:	83 ec 0c             	sub    $0xc,%esp
      70:	68 84 3a 00 00       	push   $0x3a84
      75:	e8 cd 35 00 00       	call   3647 <unlink>
      7a:	83 c4 10             	add    $0x10,%esp
      7d:	85 c0                	test   %eax,%eax
      7f:	79 18                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      81:	83 ec 08             	sub    $0x8,%esp
      84:	68 8f 3a 00 00       	push   $0x3a8f
      89:	ff 35 24 5a 00 00    	pushl  0x5a24
      8f:	e8 be 36 00 00       	call   3752 <printf>
    exit();
      94:	e8 5e 35 00 00       	call   35f7 <exit>
  }
  if(chdir("/") < 0){
      99:	83 ec 0c             	sub    $0xc,%esp
      9c:	68 a9 3a 00 00       	push   $0x3aa9
      a1:	e8 c1 35 00 00       	call   3667 <chdir>
      a6:	83 c4 10             	add    $0x10,%esp
      a9:	85 c0                	test   %eax,%eax
      ab:	79 18                	jns    c5 <iputtest+0xc5>
    printf(stdout, "chdir / failed\n");
      ad:	83 ec 08             	sub    $0x8,%esp
      b0:	68 ab 3a 00 00       	push   $0x3aab
      b5:	ff 35 24 5a 00 00    	pushl  0x5a24
      bb:	e8 92 36 00 00       	call   3752 <printf>
    exit();
      c0:	e8 32 35 00 00       	call   35f7 <exit>
  }
  printf(stdout, "iput test ok\n");
      c5:	83 ec 08             	sub    $0x8,%esp
      c8:	68 2c 3b 00 00       	push   $0x3b2c
      cd:	ff 35 24 5a 00 00    	pushl  0x5a24
      d3:	e8 7a 36 00 00       	call   3752 <printf>
}
      d8:	83 c4 10             	add    $0x10,%esp
      db:	c9                   	leave  
      dc:	c3                   	ret    

000000dd <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      dd:	55                   	push   %ebp
      de:	89 e5                	mov    %esp,%ebp
      e0:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e3:	68 bb 3a 00 00       	push   $0x3abb
      e8:	ff 35 24 5a 00 00    	pushl  0x5a24
      ee:	e8 5f 36 00 00       	call   3752 <printf>

  pid = fork();
      f3:	e8 f7 34 00 00       	call   35ef <fork>
  if(pid < 0){
      f8:	83 c4 10             	add    $0x10,%esp
      fb:	85 c0                	test   %eax,%eax
      fd:	79 18                	jns    117 <exitiputtest+0x3a>
    printf(stdout, "fork failed\n");
      ff:	83 ec 08             	sub    $0x8,%esp
     102:	68 a1 49 00 00       	push   $0x49a1
     107:	ff 35 24 5a 00 00    	pushl  0x5a24
     10d:	e8 40 36 00 00       	call   3752 <printf>
    exit();
     112:	e8 e0 34 00 00       	call   35f7 <exit>
  }
  if(pid == 0){
     117:	85 c0                	test   %eax,%eax
     119:	0f 85 89 00 00 00    	jne    1a8 <exitiputtest+0xcb>
    if(mkdir("iputdir") < 0){
     11f:	83 ec 0c             	sub    $0xc,%esp
     122:	68 87 3a 00 00       	push   $0x3a87
     127:	e8 33 35 00 00       	call   365f <mkdir>
     12c:	83 c4 10             	add    $0x10,%esp
     12f:	85 c0                	test   %eax,%eax
     131:	79 18                	jns    14b <exitiputtest+0x6e>
      printf(stdout, "mkdir failed\n");
     133:	83 ec 08             	sub    $0x8,%esp
     136:	68 60 3a 00 00       	push   $0x3a60
     13b:	ff 35 24 5a 00 00    	pushl  0x5a24
     141:	e8 0c 36 00 00       	call   3752 <printf>
      exit();
     146:	e8 ac 34 00 00       	call   35f7 <exit>
    }
    if(chdir("iputdir") < 0){
     14b:	83 ec 0c             	sub    $0xc,%esp
     14e:	68 87 3a 00 00       	push   $0x3a87
     153:	e8 0f 35 00 00       	call   3667 <chdir>
     158:	83 c4 10             	add    $0x10,%esp
     15b:	85 c0                	test   %eax,%eax
     15d:	79 18                	jns    177 <exitiputtest+0x9a>
      printf(stdout, "child chdir failed\n");
     15f:	83 ec 08             	sub    $0x8,%esp
     162:	68 ca 3a 00 00       	push   $0x3aca
     167:	ff 35 24 5a 00 00    	pushl  0x5a24
     16d:	e8 e0 35 00 00       	call   3752 <printf>
      exit();
     172:	e8 80 34 00 00       	call   35f7 <exit>
    }
    if(unlink("../iputdir") < 0){
     177:	83 ec 0c             	sub    $0xc,%esp
     17a:	68 84 3a 00 00       	push   $0x3a84
     17f:	e8 c3 34 00 00       	call   3647 <unlink>
     184:	83 c4 10             	add    $0x10,%esp
     187:	85 c0                	test   %eax,%eax
     189:	79 18                	jns    1a3 <exitiputtest+0xc6>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	83 ec 08             	sub    $0x8,%esp
     18e:	68 8f 3a 00 00       	push   $0x3a8f
     193:	ff 35 24 5a 00 00    	pushl  0x5a24
     199:	e8 b4 35 00 00       	call   3752 <printf>
      exit();
     19e:	e8 54 34 00 00       	call   35f7 <exit>
    }
    exit();
     1a3:	e8 4f 34 00 00       	call   35f7 <exit>
  }
  wait();
     1a8:	e8 52 34 00 00       	call   35ff <wait>
  printf(stdout, "exitiput test ok\n");
     1ad:	83 ec 08             	sub    $0x8,%esp
     1b0:	68 de 3a 00 00       	push   $0x3ade
     1b5:	ff 35 24 5a 00 00    	pushl  0x5a24
     1bb:	e8 92 35 00 00       	call   3752 <printf>
}
     1c0:	83 c4 10             	add    $0x10,%esp
     1c3:	c9                   	leave  
     1c4:	c3                   	ret    

000001c5 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c5:	55                   	push   %ebp
     1c6:	89 e5                	mov    %esp,%ebp
     1c8:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cb:	68 f0 3a 00 00       	push   $0x3af0
     1d0:	ff 35 24 5a 00 00    	pushl  0x5a24
     1d6:	e8 77 35 00 00       	call   3752 <printf>
  if(mkdir("oidir") < 0){
     1db:	c7 04 24 ff 3a 00 00 	movl   $0x3aff,(%esp)
     1e2:	e8 78 34 00 00       	call   365f <mkdir>
     1e7:	83 c4 10             	add    $0x10,%esp
     1ea:	85 c0                	test   %eax,%eax
     1ec:	79 18                	jns    206 <openiputtest+0x41>
    printf(stdout, "mkdir oidir failed\n");
     1ee:	83 ec 08             	sub    $0x8,%esp
     1f1:	68 05 3b 00 00       	push   $0x3b05
     1f6:	ff 35 24 5a 00 00    	pushl  0x5a24
     1fc:	e8 51 35 00 00       	call   3752 <printf>
    exit();
     201:	e8 f1 33 00 00       	call   35f7 <exit>
  }
  pid = fork();
     206:	e8 e4 33 00 00       	call   35ef <fork>
  if(pid < 0){
     20b:	85 c0                	test   %eax,%eax
     20d:	79 18                	jns    227 <openiputtest+0x62>
    printf(stdout, "fork failed\n");
     20f:	83 ec 08             	sub    $0x8,%esp
     212:	68 a1 49 00 00       	push   $0x49a1
     217:	ff 35 24 5a 00 00    	pushl  0x5a24
     21d:	e8 30 35 00 00       	call   3752 <printf>
    exit();
     222:	e8 d0 33 00 00       	call   35f7 <exit>
  }
  if(pid == 0){
     227:	85 c0                	test   %eax,%eax
     229:	75 33                	jne    25e <openiputtest+0x99>
    int fd = open("oidir", O_RDWR);
     22b:	83 ec 08             	sub    $0x8,%esp
     22e:	6a 02                	push   $0x2
     230:	68 ff 3a 00 00       	push   $0x3aff
     235:	e8 fd 33 00 00       	call   3637 <open>
    if(fd >= 0){
     23a:	83 c4 10             	add    $0x10,%esp
     23d:	85 c0                	test   %eax,%eax
     23f:	78 18                	js     259 <openiputtest+0x94>
      printf(stdout, "open directory for write succeeded\n");
     241:	83 ec 08             	sub    $0x8,%esp
     244:	68 84 4a 00 00       	push   $0x4a84
     249:	ff 35 24 5a 00 00    	pushl  0x5a24
     24f:	e8 fe 34 00 00       	call   3752 <printf>
      exit();
     254:	e8 9e 33 00 00       	call   35f7 <exit>
    }
    exit();
     259:	e8 99 33 00 00       	call   35f7 <exit>
  }
  sleep(1);
     25e:	83 ec 0c             	sub    $0xc,%esp
     261:	6a 01                	push   $0x1
     263:	e8 1f 34 00 00       	call   3687 <sleep>
  if(unlink("oidir") != 0){
     268:	c7 04 24 ff 3a 00 00 	movl   $0x3aff,(%esp)
     26f:	e8 d3 33 00 00       	call   3647 <unlink>
     274:	83 c4 10             	add    $0x10,%esp
     277:	85 c0                	test   %eax,%eax
     279:	74 18                	je     293 <openiputtest+0xce>
    printf(stdout, "unlink failed\n");
     27b:	83 ec 08             	sub    $0x8,%esp
     27e:	68 19 3b 00 00       	push   $0x3b19
     283:	ff 35 24 5a 00 00    	pushl  0x5a24
     289:	e8 c4 34 00 00       	call   3752 <printf>
    exit();
     28e:	e8 64 33 00 00       	call   35f7 <exit>
  }
  wait();
     293:	e8 67 33 00 00       	call   35ff <wait>
  printf(stdout, "openiput test ok\n");
     298:	83 ec 08             	sub    $0x8,%esp
     29b:	68 28 3b 00 00       	push   $0x3b28
     2a0:	ff 35 24 5a 00 00    	pushl  0x5a24
     2a6:	e8 a7 34 00 00       	call   3752 <printf>
}
     2ab:	83 c4 10             	add    $0x10,%esp
     2ae:	c9                   	leave  
     2af:	c3                   	ret    

000002b0 <opentest>:

// simple file system tests

void
opentest(void)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     2b6:	68 3a 3b 00 00       	push   $0x3b3a
     2bb:	ff 35 24 5a 00 00    	pushl  0x5a24
     2c1:	e8 8c 34 00 00       	call   3752 <printf>
  fd = open("echo", 0);
     2c6:	83 c4 08             	add    $0x8,%esp
     2c9:	6a 00                	push   $0x0
     2cb:	68 45 3b 00 00       	push   $0x3b45
     2d0:	e8 62 33 00 00       	call   3637 <open>
  if(fd < 0){
     2d5:	83 c4 10             	add    $0x10,%esp
     2d8:	85 c0                	test   %eax,%eax
     2da:	79 18                	jns    2f4 <opentest+0x44>
    printf(stdout, "open echo failed!\n");
     2dc:	83 ec 08             	sub    $0x8,%esp
     2df:	68 4a 3b 00 00       	push   $0x3b4a
     2e4:	ff 35 24 5a 00 00    	pushl  0x5a24
     2ea:	e8 63 34 00 00       	call   3752 <printf>
    exit();
     2ef:	e8 03 33 00 00       	call   35f7 <exit>
  }
  close(fd);
     2f4:	83 ec 0c             	sub    $0xc,%esp
     2f7:	50                   	push   %eax
     2f8:	e8 22 33 00 00       	call   361f <close>
  fd = open("doesnotexist", 0);
     2fd:	83 c4 08             	add    $0x8,%esp
     300:	6a 00                	push   $0x0
     302:	68 5d 3b 00 00       	push   $0x3b5d
     307:	e8 2b 33 00 00       	call   3637 <open>
  if(fd >= 0){
     30c:	83 c4 10             	add    $0x10,%esp
     30f:	85 c0                	test   %eax,%eax
     311:	78 18                	js     32b <opentest+0x7b>
    printf(stdout, "open doesnotexist succeeded!\n");
     313:	83 ec 08             	sub    $0x8,%esp
     316:	68 6a 3b 00 00       	push   $0x3b6a
     31b:	ff 35 24 5a 00 00    	pushl  0x5a24
     321:	e8 2c 34 00 00       	call   3752 <printf>
    exit();
     326:	e8 cc 32 00 00       	call   35f7 <exit>
  }
  printf(stdout, "open test ok\n");
     32b:	83 ec 08             	sub    $0x8,%esp
     32e:	68 88 3b 00 00       	push   $0x3b88
     333:	ff 35 24 5a 00 00    	pushl  0x5a24
     339:	e8 14 34 00 00       	call   3752 <printf>
}
     33e:	83 c4 10             	add    $0x10,%esp
     341:	c9                   	leave  
     342:	c3                   	ret    

00000343 <writetest>:

void
writetest(void)
{
     343:	55                   	push   %ebp
     344:	89 e5                	mov    %esp,%ebp
     346:	56                   	push   %esi
     347:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     348:	83 ec 08             	sub    $0x8,%esp
     34b:	68 96 3b 00 00       	push   $0x3b96
     350:	ff 35 24 5a 00 00    	pushl  0x5a24
     356:	e8 f7 33 00 00       	call   3752 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     35b:	83 c4 08             	add    $0x8,%esp
     35e:	68 02 02 00 00       	push   $0x202
     363:	68 a7 3b 00 00       	push   $0x3ba7
     368:	e8 ca 32 00 00       	call   3637 <open>
  if(fd >= 0){
     36d:	83 c4 10             	add    $0x10,%esp
     370:	85 c0                	test   %eax,%eax
     372:	78 1f                	js     393 <writetest+0x50>
     374:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     376:	83 ec 08             	sub    $0x8,%esp
     379:	68 ad 3b 00 00       	push   $0x3bad
     37e:	ff 35 24 5a 00 00    	pushl  0x5a24
     384:	e8 c9 33 00 00       	call   3752 <printf>
     389:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     38c:	bb 00 00 00 00       	mov    $0x0,%ebx
     391:	eb 18                	jmp    3ab <writetest+0x68>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     393:	83 ec 08             	sub    $0x8,%esp
     396:	68 c8 3b 00 00       	push   $0x3bc8
     39b:	ff 35 24 5a 00 00    	pushl  0x5a24
     3a1:	e8 ac 33 00 00       	call   3752 <printf>
    exit();
     3a6:	e8 4c 32 00 00       	call   35f7 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3ab:	83 ec 04             	sub    $0x4,%esp
     3ae:	6a 0a                	push   $0xa
     3b0:	68 e4 3b 00 00       	push   $0x3be4
     3b5:	56                   	push   %esi
     3b6:	e8 5c 32 00 00       	call   3617 <write>
     3bb:	83 c4 10             	add    $0x10,%esp
     3be:	83 f8 0a             	cmp    $0xa,%eax
     3c1:	74 19                	je     3dc <writetest+0x99>
      printf(stdout, "error: write aa %d new file failed\n", i);
     3c3:	83 ec 04             	sub    $0x4,%esp
     3c6:	53                   	push   %ebx
     3c7:	68 a8 4a 00 00       	push   $0x4aa8
     3cc:	ff 35 24 5a 00 00    	pushl  0x5a24
     3d2:	e8 7b 33 00 00       	call   3752 <printf>
      exit();
     3d7:	e8 1b 32 00 00       	call   35f7 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3dc:	83 ec 04             	sub    $0x4,%esp
     3df:	6a 0a                	push   $0xa
     3e1:	68 ef 3b 00 00       	push   $0x3bef
     3e6:	56                   	push   %esi
     3e7:	e8 2b 32 00 00       	call   3617 <write>
     3ec:	83 c4 10             	add    $0x10,%esp
     3ef:	83 f8 0a             	cmp    $0xa,%eax
     3f2:	74 19                	je     40d <writetest+0xca>
      printf(stdout, "error: write bb %d new file failed\n", i);
     3f4:	83 ec 04             	sub    $0x4,%esp
     3f7:	53                   	push   %ebx
     3f8:	68 cc 4a 00 00       	push   $0x4acc
     3fd:	ff 35 24 5a 00 00    	pushl  0x5a24
     403:	e8 4a 33 00 00       	call   3752 <printf>
      exit();
     408:	e8 ea 31 00 00       	call   35f7 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     40d:	83 c3 01             	add    $0x1,%ebx
     410:	83 fb 64             	cmp    $0x64,%ebx
     413:	75 96                	jne    3ab <writetest+0x68>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     415:	83 ec 08             	sub    $0x8,%esp
     418:	68 fa 3b 00 00       	push   $0x3bfa
     41d:	ff 35 24 5a 00 00    	pushl  0x5a24
     423:	e8 2a 33 00 00       	call   3752 <printf>
  close(fd);
     428:	89 34 24             	mov    %esi,(%esp)
     42b:	e8 ef 31 00 00       	call   361f <close>
  fd = open("small", O_RDONLY);
     430:	83 c4 08             	add    $0x8,%esp
     433:	6a 00                	push   $0x0
     435:	68 a7 3b 00 00       	push   $0x3ba7
     43a:	e8 f8 31 00 00       	call   3637 <open>
     43f:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     441:	83 c4 10             	add    $0x10,%esp
     444:	85 c0                	test   %eax,%eax
     446:	78 32                	js     47a <writetest+0x137>
    printf(stdout, "open small succeeded ok\n");
     448:	83 ec 08             	sub    $0x8,%esp
     44b:	68 05 3c 00 00       	push   $0x3c05
     450:	ff 35 24 5a 00 00    	pushl  0x5a24
     456:	e8 f7 32 00 00       	call   3752 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     45b:	83 c4 0c             	add    $0xc,%esp
     45e:	68 d0 07 00 00       	push   $0x7d0
     463:	68 00 82 00 00       	push   $0x8200
     468:	53                   	push   %ebx
     469:	e8 a1 31 00 00       	call   360f <read>
  if(i == 2000){
     46e:	83 c4 10             	add    $0x10,%esp
     471:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     476:	74 1a                	je     492 <writetest+0x14f>
     478:	eb 48                	jmp    4c2 <writetest+0x17f>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     47a:	83 ec 08             	sub    $0x8,%esp
     47d:	68 1e 3c 00 00       	push   $0x3c1e
     482:	ff 35 24 5a 00 00    	pushl  0x5a24
     488:	e8 c5 32 00 00       	call   3752 <printf>
    exit();
     48d:	e8 65 31 00 00       	call   35f7 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     492:	83 ec 08             	sub    $0x8,%esp
     495:	68 39 3c 00 00       	push   $0x3c39
     49a:	ff 35 24 5a 00 00    	pushl  0x5a24
     4a0:	e8 ad 32 00 00       	call   3752 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     4a5:	89 1c 24             	mov    %ebx,(%esp)
     4a8:	e8 72 31 00 00       	call   361f <close>

  if(unlink("small") < 0){
     4ad:	c7 04 24 a7 3b 00 00 	movl   $0x3ba7,(%esp)
     4b4:	e8 8e 31 00 00       	call   3647 <unlink>
     4b9:	83 c4 10             	add    $0x10,%esp
     4bc:	85 c0                	test   %eax,%eax
     4be:	79 32                	jns    4f2 <writetest+0x1af>
     4c0:	eb 18                	jmp    4da <writetest+0x197>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     4c2:	83 ec 08             	sub    $0x8,%esp
     4c5:	68 65 3f 00 00       	push   $0x3f65
     4ca:	ff 35 24 5a 00 00    	pushl  0x5a24
     4d0:	e8 7d 32 00 00       	call   3752 <printf>
    exit();
     4d5:	e8 1d 31 00 00       	call   35f7 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     4da:	83 ec 08             	sub    $0x8,%esp
     4dd:	68 4c 3c 00 00       	push   $0x3c4c
     4e2:	ff 35 24 5a 00 00    	pushl  0x5a24
     4e8:	e8 65 32 00 00       	call   3752 <printf>
    exit();
     4ed:	e8 05 31 00 00       	call   35f7 <exit>
  }
  printf(stdout, "small file test ok\n");
     4f2:	83 ec 08             	sub    $0x8,%esp
     4f5:	68 61 3c 00 00       	push   $0x3c61
     4fa:	ff 35 24 5a 00 00    	pushl  0x5a24
     500:	e8 4d 32 00 00       	call   3752 <printf>
}
     505:	83 c4 10             	add    $0x10,%esp
     508:	8d 65 f8             	lea    -0x8(%ebp),%esp
     50b:	5b                   	pop    %ebx
     50c:	5e                   	pop    %esi
     50d:	5d                   	pop    %ebp
     50e:	c3                   	ret    

0000050f <writetest1>:

void
writetest1(void)
{
     50f:	55                   	push   %ebp
     510:	89 e5                	mov    %esp,%ebp
     512:	56                   	push   %esi
     513:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     514:	83 ec 08             	sub    $0x8,%esp
     517:	68 75 3c 00 00       	push   $0x3c75
     51c:	ff 35 24 5a 00 00    	pushl  0x5a24
     522:	e8 2b 32 00 00       	call   3752 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     527:	83 c4 08             	add    $0x8,%esp
     52a:	68 02 02 00 00       	push   $0x202
     52f:	68 ef 3c 00 00       	push   $0x3cef
     534:	e8 fe 30 00 00       	call   3637 <open>
  if(fd < 0){
     539:	83 c4 10             	add    $0x10,%esp
     53c:	85 c0                	test   %eax,%eax
     53e:	79 18                	jns    558 <writetest1+0x49>
    printf(stdout, "error: creat big failed!\n");
     540:	83 ec 08             	sub    $0x8,%esp
     543:	68 85 3c 00 00       	push   $0x3c85
     548:	ff 35 24 5a 00 00    	pushl  0x5a24
     54e:	e8 ff 31 00 00       	call   3752 <printf>
    exit();
     553:	e8 9f 30 00 00       	call   35f7 <exit>
     558:	89 c6                	mov    %eax,%esi
     55a:	bb 00 00 00 00       	mov    $0x0,%ebx
  }

  for(i = 0; i < MAXFILE; i++){
    ((int*)buf)[0] = i;
     55f:	89 1d 00 82 00 00    	mov    %ebx,0x8200
    if(write(fd, buf, 512) != 512){
     565:	83 ec 04             	sub    $0x4,%esp
     568:	68 00 02 00 00       	push   $0x200
     56d:	68 00 82 00 00       	push   $0x8200
     572:	56                   	push   %esi
     573:	e8 9f 30 00 00       	call   3617 <write>
     578:	83 c4 10             	add    $0x10,%esp
     57b:	3d 00 02 00 00       	cmp    $0x200,%eax
     580:	74 19                	je     59b <writetest1+0x8c>
      printf(stdout, "error: write big file failed\n", i);
     582:	83 ec 04             	sub    $0x4,%esp
     585:	53                   	push   %ebx
     586:	68 9f 3c 00 00       	push   $0x3c9f
     58b:	ff 35 24 5a 00 00    	pushl  0x5a24
     591:	e8 bc 31 00 00       	call   3752 <printf>
      exit();
     596:	e8 5c 30 00 00       	call   35f7 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     59b:	83 c3 01             	add    $0x1,%ebx
     59e:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     5a4:	75 b9                	jne    55f <writetest1+0x50>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     5a6:	83 ec 0c             	sub    $0xc,%esp
     5a9:	56                   	push   %esi
     5aa:	e8 70 30 00 00       	call   361f <close>

  fd = open("big", O_RDONLY);
     5af:	83 c4 08             	add    $0x8,%esp
     5b2:	6a 00                	push   $0x0
     5b4:	68 ef 3c 00 00       	push   $0x3cef
     5b9:	e8 79 30 00 00       	call   3637 <open>
     5be:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     5c0:	83 c4 10             	add    $0x10,%esp
     5c3:	85 c0                	test   %eax,%eax
     5c5:	79 18                	jns    5df <writetest1+0xd0>
    printf(stdout, "error: open big failed!\n");
     5c7:	83 ec 08             	sub    $0x8,%esp
     5ca:	68 bd 3c 00 00       	push   $0x3cbd
     5cf:	ff 35 24 5a 00 00    	pushl  0x5a24
     5d5:	e8 78 31 00 00       	call   3752 <printf>
    exit();
     5da:	e8 18 30 00 00       	call   35f7 <exit>
     5df:	bb 00 00 00 00       	mov    $0x0,%ebx
  }

  n = 0;
  for(;;){
    i = read(fd, buf, 512);
     5e4:	83 ec 04             	sub    $0x4,%esp
     5e7:	68 00 02 00 00       	push   $0x200
     5ec:	68 00 82 00 00       	push   $0x8200
     5f1:	56                   	push   %esi
     5f2:	e8 18 30 00 00       	call   360f <read>
    if(i == 0){
     5f7:	83 c4 10             	add    $0x10,%esp
     5fa:	85 c0                	test   %eax,%eax
     5fc:	75 25                	jne    623 <writetest1+0x114>
      if(n == MAXFILE - 1){
     5fe:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     604:	75 65                	jne    66b <writetest1+0x15c>
        printf(stdout, "read only %d blocks from big", n);
     606:	83 ec 04             	sub    $0x4,%esp
     609:	68 8b 00 00 00       	push   $0x8b
     60e:	68 d6 3c 00 00       	push   $0x3cd6
     613:	ff 35 24 5a 00 00    	pushl  0x5a24
     619:	e8 34 31 00 00       	call   3752 <printf>
        exit();
     61e:	e8 d4 2f 00 00       	call   35f7 <exit>
      }
      break;
    } else if(i != 512){
     623:	3d 00 02 00 00       	cmp    $0x200,%eax
     628:	74 19                	je     643 <writetest1+0x134>
      printf(stdout, "read failed %d\n", i);
     62a:	83 ec 04             	sub    $0x4,%esp
     62d:	50                   	push   %eax
     62e:	68 f3 3c 00 00       	push   $0x3cf3
     633:	ff 35 24 5a 00 00    	pushl  0x5a24
     639:	e8 14 31 00 00       	call   3752 <printf>
      exit();
     63e:	e8 b4 2f 00 00       	call   35f7 <exit>
    }
    if(((int*)buf)[0] != n){
     643:	a1 00 82 00 00       	mov    0x8200,%eax
     648:	39 c3                	cmp    %eax,%ebx
     64a:	74 17                	je     663 <writetest1+0x154>
      printf(stdout, "read content of block %d is %d\n",
     64c:	50                   	push   %eax
     64d:	53                   	push   %ebx
     64e:	68 f0 4a 00 00       	push   $0x4af0
     653:	ff 35 24 5a 00 00    	pushl  0x5a24
     659:	e8 f4 30 00 00       	call   3752 <printf>
             n, ((int*)buf)[0]);
      exit();
     65e:	e8 94 2f 00 00       	call   35f7 <exit>
    }
    n++;
     663:	83 c3 01             	add    $0x1,%ebx
  }
     666:	e9 79 ff ff ff       	jmp    5e4 <writetest1+0xd5>
  close(fd);
     66b:	83 ec 0c             	sub    $0xc,%esp
     66e:	56                   	push   %esi
     66f:	e8 ab 2f 00 00       	call   361f <close>
  if(unlink("big") < 0){
     674:	c7 04 24 ef 3c 00 00 	movl   $0x3cef,(%esp)
     67b:	e8 c7 2f 00 00       	call   3647 <unlink>
     680:	83 c4 10             	add    $0x10,%esp
     683:	85 c0                	test   %eax,%eax
     685:	79 18                	jns    69f <writetest1+0x190>
    printf(stdout, "unlink big failed\n");
     687:	83 ec 08             	sub    $0x8,%esp
     68a:	68 03 3d 00 00       	push   $0x3d03
     68f:	ff 35 24 5a 00 00    	pushl  0x5a24
     695:	e8 b8 30 00 00       	call   3752 <printf>
    exit();
     69a:	e8 58 2f 00 00       	call   35f7 <exit>
  }
  printf(stdout, "big files ok\n");
     69f:	83 ec 08             	sub    $0x8,%esp
     6a2:	68 16 3d 00 00       	push   $0x3d16
     6a7:	ff 35 24 5a 00 00    	pushl  0x5a24
     6ad:	e8 a0 30 00 00       	call   3752 <printf>
}
     6b2:	83 c4 10             	add    $0x10,%esp
     6b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
     6b8:	5b                   	pop    %ebx
     6b9:	5e                   	pop    %esi
     6ba:	5d                   	pop    %ebp
     6bb:	c3                   	ret    

000006bc <createtest>:

void
createtest(void)
{
     6bc:	55                   	push   %ebp
     6bd:	89 e5                	mov    %esp,%ebp
     6bf:	53                   	push   %ebx
     6c0:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     6c3:	68 10 4b 00 00       	push   $0x4b10
     6c8:	ff 35 24 5a 00 00    	pushl  0x5a24
     6ce:	e8 7f 30 00 00       	call   3752 <printf>

  name[0] = 'a';
     6d3:	c6 05 00 a2 00 00 61 	movb   $0x61,0xa200
  name[2] = '\0';
     6da:	c6 05 02 a2 00 00 00 	movb   $0x0,0xa202
     6e1:	83 c4 10             	add    $0x10,%esp
     6e4:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     6e9:	88 1d 01 a2 00 00    	mov    %bl,0xa201
    fd = open(name, O_CREATE|O_RDWR);
     6ef:	83 ec 08             	sub    $0x8,%esp
     6f2:	68 02 02 00 00       	push   $0x202
     6f7:	68 00 a2 00 00       	push   $0xa200
     6fc:	e8 36 2f 00 00       	call   3637 <open>
    close(fd);
     701:	89 04 24             	mov    %eax,(%esp)
     704:	e8 16 2f 00 00       	call   361f <close>
     709:	83 c3 01             	add    $0x1,%ebx

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     70c:	83 c4 10             	add    $0x10,%esp
     70f:	80 fb 64             	cmp    $0x64,%bl
     712:	75 d5                	jne    6e9 <createtest+0x2d>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     714:	c6 05 00 a2 00 00 61 	movb   $0x61,0xa200
  name[2] = '\0';
     71b:	c6 05 02 a2 00 00 00 	movb   $0x0,0xa202
     722:	bb 30 00 00 00       	mov    $0x30,%ebx
  for(i = 0; i < 52; i++){
    name[1] = '0' + i;
     727:	88 1d 01 a2 00 00    	mov    %bl,0xa201
    unlink(name);
     72d:	83 ec 0c             	sub    $0xc,%esp
     730:	68 00 a2 00 00       	push   $0xa200
     735:	e8 0d 2f 00 00       	call   3647 <unlink>
     73a:	83 c3 01             	add    $0x1,%ebx
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     73d:	83 c4 10             	add    $0x10,%esp
     740:	80 fb 64             	cmp    $0x64,%bl
     743:	75 e2                	jne    727 <createtest+0x6b>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     745:	83 ec 08             	sub    $0x8,%esp
     748:	68 38 4b 00 00       	push   $0x4b38
     74d:	ff 35 24 5a 00 00    	pushl  0x5a24
     753:	e8 fa 2f 00 00       	call   3752 <printf>
}
     758:	83 c4 10             	add    $0x10,%esp
     75b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     75e:	c9                   	leave  
     75f:	c3                   	ret    

00000760 <dirtest>:

void dirtest(void)
{
     760:	55                   	push   %ebp
     761:	89 e5                	mov    %esp,%ebp
     763:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     766:	68 24 3d 00 00       	push   $0x3d24
     76b:	ff 35 24 5a 00 00    	pushl  0x5a24
     771:	e8 dc 2f 00 00       	call   3752 <printf>

  if(mkdir("dir0") < 0){
     776:	c7 04 24 30 3d 00 00 	movl   $0x3d30,(%esp)
     77d:	e8 dd 2e 00 00       	call   365f <mkdir>
     782:	83 c4 10             	add    $0x10,%esp
     785:	85 c0                	test   %eax,%eax
     787:	79 18                	jns    7a1 <dirtest+0x41>
    printf(stdout, "mkdir failed\n");
     789:	83 ec 08             	sub    $0x8,%esp
     78c:	68 60 3a 00 00       	push   $0x3a60
     791:	ff 35 24 5a 00 00    	pushl  0x5a24
     797:	e8 b6 2f 00 00       	call   3752 <printf>
    exit();
     79c:	e8 56 2e 00 00       	call   35f7 <exit>
  }

  if(chdir("dir0") < 0){
     7a1:	83 ec 0c             	sub    $0xc,%esp
     7a4:	68 30 3d 00 00       	push   $0x3d30
     7a9:	e8 b9 2e 00 00       	call   3667 <chdir>
     7ae:	83 c4 10             	add    $0x10,%esp
     7b1:	85 c0                	test   %eax,%eax
     7b3:	79 18                	jns    7cd <dirtest+0x6d>
    printf(stdout, "chdir dir0 failed\n");
     7b5:	83 ec 08             	sub    $0x8,%esp
     7b8:	68 35 3d 00 00       	push   $0x3d35
     7bd:	ff 35 24 5a 00 00    	pushl  0x5a24
     7c3:	e8 8a 2f 00 00       	call   3752 <printf>
    exit();
     7c8:	e8 2a 2e 00 00       	call   35f7 <exit>
  }

  if(chdir("..") < 0){
     7cd:	83 ec 0c             	sub    $0xc,%esp
     7d0:	68 d5 42 00 00       	push   $0x42d5
     7d5:	e8 8d 2e 00 00       	call   3667 <chdir>
     7da:	83 c4 10             	add    $0x10,%esp
     7dd:	85 c0                	test   %eax,%eax
     7df:	79 18                	jns    7f9 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     7e1:	83 ec 08             	sub    $0x8,%esp
     7e4:	68 48 3d 00 00       	push   $0x3d48
     7e9:	ff 35 24 5a 00 00    	pushl  0x5a24
     7ef:	e8 5e 2f 00 00       	call   3752 <printf>
    exit();
     7f4:	e8 fe 2d 00 00       	call   35f7 <exit>
  }

  if(unlink("dir0") < 0){
     7f9:	83 ec 0c             	sub    $0xc,%esp
     7fc:	68 30 3d 00 00       	push   $0x3d30
     801:	e8 41 2e 00 00       	call   3647 <unlink>
     806:	83 c4 10             	add    $0x10,%esp
     809:	85 c0                	test   %eax,%eax
     80b:	79 18                	jns    825 <dirtest+0xc5>
    printf(stdout, "unlink dir0 failed\n");
     80d:	83 ec 08             	sub    $0x8,%esp
     810:	68 59 3d 00 00       	push   $0x3d59
     815:	ff 35 24 5a 00 00    	pushl  0x5a24
     81b:	e8 32 2f 00 00       	call   3752 <printf>
    exit();
     820:	e8 d2 2d 00 00       	call   35f7 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     825:	83 ec 08             	sub    $0x8,%esp
     828:	68 6d 3d 00 00       	push   $0x3d6d
     82d:	ff 35 24 5a 00 00    	pushl  0x5a24
     833:	e8 1a 2f 00 00       	call   3752 <printf>
}
     838:	83 c4 10             	add    $0x10,%esp
     83b:	c9                   	leave  
     83c:	c3                   	ret    

0000083d <exectest>:

void
exectest(void)
{
     83d:	55                   	push   %ebp
     83e:	89 e5                	mov    %esp,%ebp
     840:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     843:	68 7c 3d 00 00       	push   $0x3d7c
     848:	ff 35 24 5a 00 00    	pushl  0x5a24
     84e:	e8 ff 2e 00 00       	call   3752 <printf>
  if(exec("echo", echoargv) < 0){
     853:	83 c4 08             	add    $0x8,%esp
     856:	68 28 5a 00 00       	push   $0x5a28
     85b:	68 45 3b 00 00       	push   $0x3b45
     860:	e8 ca 2d 00 00       	call   362f <exec>
     865:	83 c4 10             	add    $0x10,%esp
     868:	85 c0                	test   %eax,%eax
     86a:	79 18                	jns    884 <exectest+0x47>
    printf(stdout, "exec echo failed\n");
     86c:	83 ec 08             	sub    $0x8,%esp
     86f:	68 87 3d 00 00       	push   $0x3d87
     874:	ff 35 24 5a 00 00    	pushl  0x5a24
     87a:	e8 d3 2e 00 00       	call   3752 <printf>
    exit();
     87f:	e8 73 2d 00 00       	call   35f7 <exit>
  }
}
     884:	c9                   	leave  
     885:	c3                   	ret    

00000886 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     886:	55                   	push   %ebp
     887:	89 e5                	mov    %esp,%ebp
     889:	57                   	push   %edi
     88a:	56                   	push   %esi
     88b:	53                   	push   %ebx
     88c:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     88f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     892:	50                   	push   %eax
     893:	e8 6f 2d 00 00       	call   3607 <pipe>
     898:	83 c4 10             	add    $0x10,%esp
     89b:	85 c0                	test   %eax,%eax
     89d:	74 14                	je     8b3 <pipe1+0x2d>
    printf(1, "pipe() failed\n");
     89f:	83 ec 08             	sub    $0x8,%esp
     8a2:	68 99 3d 00 00       	push   $0x3d99
     8a7:	6a 01                	push   $0x1
     8a9:	e8 a4 2e 00 00       	call   3752 <printf>
    exit();
     8ae:	e8 44 2d 00 00       	call   35f7 <exit>
  }
  pid = fork();
     8b3:	e8 37 2d 00 00       	call   35ef <fork>
  seq = 0;
  if(pid == 0){
     8b8:	85 c0                	test   %eax,%eax
     8ba:	75 77                	jne    933 <pipe1+0xad>
    close(fds[0]);
     8bc:	83 ec 0c             	sub    $0xc,%esp
     8bf:	ff 75 e0             	pushl  -0x20(%ebp)
     8c2:	e8 58 2d 00 00       	call   361f <close>
     8c7:	83 c4 10             	add    $0x10,%esp
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
  seq = 0;
     8ca:	bb 00 00 00 00       	mov    $0x0,%ebx
     8cf:	eb 4f                	jmp    920 <pipe1+0x9a>
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
     8d1:	88 84 02 00 82 00 00 	mov    %al,0x8200(%edx,%eax,1)
     8d8:	83 c0 01             	add    $0x1,%eax
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     8db:	39 c8                	cmp    %ecx,%eax
     8dd:	75 f2                	jne    8d1 <pipe1+0x4b>
     8df:	81 c3 09 04 00 00    	add    $0x409,%ebx
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     8e5:	83 ec 04             	sub    $0x4,%esp
     8e8:	68 09 04 00 00       	push   $0x409
     8ed:	68 00 82 00 00       	push   $0x8200
     8f2:	ff 75 e4             	pushl  -0x1c(%ebp)
     8f5:	e8 1d 2d 00 00       	call   3617 <write>
     8fa:	83 c4 10             	add    $0x10,%esp
     8fd:	3d 09 04 00 00       	cmp    $0x409,%eax
     902:	74 14                	je     918 <pipe1+0x92>
        printf(1, "pipe1 oops 1\n");
     904:	83 ec 08             	sub    $0x8,%esp
     907:	68 a8 3d 00 00       	push   $0x3da8
     90c:	6a 01                	push   $0x1
     90e:	e8 3f 2e 00 00       	call   3752 <printf>
        exit();
     913:	e8 df 2c 00 00       	call   35f7 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     918:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     91e:	74 0e                	je     92e <pipe1+0xa8>
     920:	8d 8b 09 04 00 00    	lea    0x409(%ebx),%ecx

// simple fork and pipe read/write

void
pipe1(void)
{
     926:	89 d8                	mov    %ebx,%eax
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
        buf[i] = seq++;
     928:	89 da                	mov    %ebx,%edx
     92a:	f7 da                	neg    %edx
     92c:	eb a3                	jmp    8d1 <pipe1+0x4b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     92e:	e8 c4 2c 00 00       	call   35f7 <exit>
  } else if(pid > 0){
     933:	85 c0                	test   %eax,%eax
     935:	0f 8e cc 00 00 00    	jle    a07 <pipe1+0x181>
    close(fds[1]);
     93b:	83 ec 0c             	sub    $0xc,%esp
     93e:	ff 75 e4             	pushl  -0x1c(%ebp)
     941:	e8 d9 2c 00 00       	call   361f <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     946:	83 c4 10             	add    $0x10,%esp
      }
    }
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
     949:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    cc = 1;
     950:	be 01 00 00 00       	mov    $0x1,%esi
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
  seq = 0;
     955:	bb 00 00 00 00       	mov    $0x0,%ebx
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     95a:	eb 3c                	jmp    998 <pipe1+0x112>
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     95c:	8d 4a 01             	lea    0x1(%edx),%ecx
     95f:	38 94 17 00 82 00 00 	cmp    %dl,0x8200(%edi,%edx,1)
     966:	74 17                	je     97f <pipe1+0xf9>
          printf(1, "pipe1 oops 2\n");
     968:	83 ec 08             	sub    $0x8,%esp
     96b:	68 b6 3d 00 00       	push   $0x3db6
     970:	6a 01                	push   $0x1
     972:	e8 db 2d 00 00       	call   3752 <printf>
          return;
     977:	83 c4 10             	add    $0x10,%esp
     97a:	e9 9c 00 00 00       	jmp    a1b <pipe1+0x195>
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     97f:	89 ca                	mov    %ecx,%edx
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     981:	39 d3                	cmp    %edx,%ebx
     983:	75 d7                	jne    95c <pipe1+0xd6>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     985:	01 45 d4             	add    %eax,-0x2c(%ebp)
      cc = cc * 2;
     988:	01 f6                	add    %esi,%esi
      if(cc > sizeof(buf))
        cc = sizeof(buf);
     98a:	81 fe 01 20 00 00    	cmp    $0x2001,%esi
     990:	b8 00 20 00 00       	mov    $0x2000,%eax
     995:	0f 43 f0             	cmovae %eax,%esi
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     998:	83 ec 04             	sub    $0x4,%esp
     99b:	56                   	push   %esi
     99c:	68 00 82 00 00       	push   $0x8200
     9a1:	ff 75 e0             	pushl  -0x20(%ebp)
     9a4:	e8 66 2c 00 00       	call   360f <read>
     9a9:	83 c4 10             	add    $0x10,%esp
     9ac:	85 c0                	test   %eax,%eax
     9ae:	7e 13                	jle    9c3 <pipe1+0x13d>
      for(i = 0; i < n; i++){
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     9b0:	8d 53 01             	lea    0x1(%ebx),%edx
     9b3:	38 1d 00 82 00 00    	cmp    %bl,0x8200
     9b9:	75 ad                	jne    968 <pipe1+0xe2>
     9bb:	89 df                	mov    %ebx,%edi
     9bd:	01 c3                	add    %eax,%ebx
     9bf:	f7 df                	neg    %edi
     9c1:	eb be                	jmp    981 <pipe1+0xfb>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     9c3:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     9ca:	74 17                	je     9e3 <pipe1+0x15d>
      printf(1, "pipe1 oops 3 total %d\n", total);
     9cc:	83 ec 04             	sub    $0x4,%esp
     9cf:	ff 75 d4             	pushl  -0x2c(%ebp)
     9d2:	68 c4 3d 00 00       	push   $0x3dc4
     9d7:	6a 01                	push   $0x1
     9d9:	e8 74 2d 00 00       	call   3752 <printf>
      exit();
     9de:	e8 14 2c 00 00       	call   35f7 <exit>
    }
    close(fds[0]);
     9e3:	83 ec 0c             	sub    $0xc,%esp
     9e6:	ff 75 e0             	pushl  -0x20(%ebp)
     9e9:	e8 31 2c 00 00       	call   361f <close>
    wait();
     9ee:	e8 0c 2c 00 00       	call   35ff <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     9f3:	83 c4 08             	add    $0x8,%esp
     9f6:	68 db 3d 00 00       	push   $0x3ddb
     9fb:	6a 01                	push   $0x1
     9fd:	e8 50 2d 00 00       	call   3752 <printf>
     a02:	83 c4 10             	add    $0x10,%esp
     a05:	eb 14                	jmp    a1b <pipe1+0x195>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     a07:	83 ec 08             	sub    $0x8,%esp
     a0a:	68 e5 3d 00 00       	push   $0x3de5
     a0f:	6a 01                	push   $0x1
     a11:	e8 3c 2d 00 00       	call   3752 <printf>
    exit();
     a16:	e8 dc 2b 00 00       	call   35f7 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a1e:	5b                   	pop    %ebx
     a1f:	5e                   	pop    %esi
     a20:	5f                   	pop    %edi
     a21:	5d                   	pop    %ebp
     a22:	c3                   	ret    

00000a23 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a23:	55                   	push   %ebp
     a24:	89 e5                	mov    %esp,%ebp
     a26:	57                   	push   %edi
     a27:	56                   	push   %esi
     a28:	53                   	push   %ebx
     a29:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     a2c:	68 f4 3d 00 00       	push   $0x3df4
     a31:	6a 01                	push   $0x1
     a33:	e8 1a 2d 00 00       	call   3752 <printf>
  pid1 = fork();
     a38:	e8 b2 2b 00 00       	call   35ef <fork>
  if(pid1 == 0)
     a3d:	83 c4 10             	add    $0x10,%esp
     a40:	85 c0                	test   %eax,%eax
     a42:	75 02                	jne    a46 <preempt+0x23>
     a44:	eb fe                	jmp    a44 <preempt+0x21>
     a46:	89 c7                	mov    %eax,%edi
    for(;;)
      ;

  pid2 = fork();
     a48:	e8 a2 2b 00 00       	call   35ef <fork>
     a4d:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     a4f:	85 c0                	test   %eax,%eax
     a51:	75 02                	jne    a55 <preempt+0x32>
     a53:	eb fe                	jmp    a53 <preempt+0x30>
    for(;;)
      ;

  pipe(pfds);
     a55:	83 ec 0c             	sub    $0xc,%esp
     a58:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a5b:	50                   	push   %eax
     a5c:	e8 a6 2b 00 00       	call   3607 <pipe>
  pid3 = fork();
     a61:	e8 89 2b 00 00       	call   35ef <fork>
     a66:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     a68:	83 c4 10             	add    $0x10,%esp
     a6b:	85 c0                	test   %eax,%eax
     a6d:	75 47                	jne    ab6 <preempt+0x93>
    close(pfds[0]);
     a6f:	83 ec 0c             	sub    $0xc,%esp
     a72:	ff 75 e0             	pushl  -0x20(%ebp)
     a75:	e8 a5 2b 00 00       	call   361f <close>
    if(write(pfds[1], "x", 1) != 1)
     a7a:	83 c4 0c             	add    $0xc,%esp
     a7d:	6a 01                	push   $0x1
     a7f:	68 b9 43 00 00       	push   $0x43b9
     a84:	ff 75 e4             	pushl  -0x1c(%ebp)
     a87:	e8 8b 2b 00 00       	call   3617 <write>
     a8c:	83 c4 10             	add    $0x10,%esp
     a8f:	83 f8 01             	cmp    $0x1,%eax
     a92:	74 12                	je     aa6 <preempt+0x83>
      printf(1, "preempt write error");
     a94:	83 ec 08             	sub    $0x8,%esp
     a97:	68 fe 3d 00 00       	push   $0x3dfe
     a9c:	6a 01                	push   $0x1
     a9e:	e8 af 2c 00 00       	call   3752 <printf>
     aa3:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     aa6:	83 ec 0c             	sub    $0xc,%esp
     aa9:	ff 75 e4             	pushl  -0x1c(%ebp)
     aac:	e8 6e 2b 00 00       	call   361f <close>
     ab1:	83 c4 10             	add    $0x10,%esp
     ab4:	eb fe                	jmp    ab4 <preempt+0x91>
    for(;;)
      ;
  }

  close(pfds[1]);
     ab6:	83 ec 0c             	sub    $0xc,%esp
     ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
     abc:	e8 5e 2b 00 00       	call   361f <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     ac1:	83 c4 0c             	add    $0xc,%esp
     ac4:	68 00 20 00 00       	push   $0x2000
     ac9:	68 00 82 00 00       	push   $0x8200
     ace:	ff 75 e0             	pushl  -0x20(%ebp)
     ad1:	e8 39 2b 00 00       	call   360f <read>
     ad6:	83 c4 10             	add    $0x10,%esp
     ad9:	83 f8 01             	cmp    $0x1,%eax
     adc:	74 14                	je     af2 <preempt+0xcf>
    printf(1, "preempt read error");
     ade:	83 ec 08             	sub    $0x8,%esp
     ae1:	68 12 3e 00 00       	push   $0x3e12
     ae6:	6a 01                	push   $0x1
     ae8:	e8 65 2c 00 00       	call   3752 <printf>
    return;
     aed:	83 c4 10             	add    $0x10,%esp
     af0:	eb 62                	jmp    b54 <preempt+0x131>
  }
  close(pfds[0]);
     af2:	83 ec 0c             	sub    $0xc,%esp
     af5:	ff 75 e0             	pushl  -0x20(%ebp)
     af8:	e8 22 2b 00 00       	call   361f <close>
  printf(1, "kill... ");
     afd:	83 c4 08             	add    $0x8,%esp
     b00:	68 25 3e 00 00       	push   $0x3e25
     b05:	6a 01                	push   $0x1
     b07:	e8 46 2c 00 00       	call   3752 <printf>
  kill(pid1);
     b0c:	89 3c 24             	mov    %edi,(%esp)
     b0f:	e8 13 2b 00 00       	call   3627 <kill>
  kill(pid2);
     b14:	89 34 24             	mov    %esi,(%esp)
     b17:	e8 0b 2b 00 00       	call   3627 <kill>
  kill(pid3);
     b1c:	89 1c 24             	mov    %ebx,(%esp)
     b1f:	e8 03 2b 00 00       	call   3627 <kill>
  printf(1, "wait... ");
     b24:	83 c4 08             	add    $0x8,%esp
     b27:	68 2e 3e 00 00       	push   $0x3e2e
     b2c:	6a 01                	push   $0x1
     b2e:	e8 1f 2c 00 00       	call   3752 <printf>
  wait();
     b33:	e8 c7 2a 00 00       	call   35ff <wait>
  wait();
     b38:	e8 c2 2a 00 00       	call   35ff <wait>
  wait();
     b3d:	e8 bd 2a 00 00       	call   35ff <wait>
  printf(1, "preempt ok\n");
     b42:	83 c4 08             	add    $0x8,%esp
     b45:	68 37 3e 00 00       	push   $0x3e37
     b4a:	6a 01                	push   $0x1
     b4c:	e8 01 2c 00 00       	call   3752 <printf>
     b51:	83 c4 10             	add    $0x10,%esp
}
     b54:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b57:	5b                   	pop    %ebx
     b58:	5e                   	pop    %esi
     b59:	5f                   	pop    %edi
     b5a:	5d                   	pop    %ebp
     b5b:	c3                   	ret    

00000b5c <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     b5c:	55                   	push   %ebp
     b5d:	89 e5                	mov    %esp,%ebp
     b5f:	56                   	push   %esi
     b60:	53                   	push   %ebx
     b61:	be 64 00 00 00       	mov    $0x64,%esi
  int i, pid;

  for(i = 0; i < 100; i++){
    pid = fork();
     b66:	e8 84 2a 00 00       	call   35ef <fork>
     b6b:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     b6d:	85 c0                	test   %eax,%eax
     b6f:	79 14                	jns    b85 <exitwait+0x29>
      printf(1, "fork failed\n");
     b71:	83 ec 08             	sub    $0x8,%esp
     b74:	68 a1 49 00 00       	push   $0x49a1
     b79:	6a 01                	push   $0x1
     b7b:	e8 d2 2b 00 00       	call   3752 <printf>
      return;
     b80:	83 c4 10             	add    $0x10,%esp
     b83:	eb 3d                	jmp    bc2 <exitwait+0x66>
    }
    if(pid){
     b85:	85 c0                	test   %eax,%eax
     b87:	74 1d                	je     ba6 <exitwait+0x4a>
      if(wait() != pid){
     b89:	e8 71 2a 00 00       	call   35ff <wait>
     b8e:	39 c3                	cmp    %eax,%ebx
     b90:	74 19                	je     bab <exitwait+0x4f>
        printf(1, "wait wrong pid\n");
     b92:	83 ec 08             	sub    $0x8,%esp
     b95:	68 43 3e 00 00       	push   $0x3e43
     b9a:	6a 01                	push   $0x1
     b9c:	e8 b1 2b 00 00       	call   3752 <printf>
        return;
     ba1:	83 c4 10             	add    $0x10,%esp
     ba4:	eb 1c                	jmp    bc2 <exitwait+0x66>
      }
    } else {
      exit();
     ba6:	e8 4c 2a 00 00       	call   35f7 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     bab:	83 ee 01             	sub    $0x1,%esi
     bae:	75 b6                	jne    b66 <exitwait+0xa>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 53 3e 00 00       	push   $0x3e53
     bb8:	6a 01                	push   $0x1
     bba:	e8 93 2b 00 00       	call   3752 <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
}
     bc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bc5:	5b                   	pop    %ebx
     bc6:	5e                   	pop    %esi
     bc7:	5d                   	pop    %ebp
     bc8:	c3                   	ret    

00000bc9 <mem>:

void
mem(void)
{
     bc9:	55                   	push   %ebp
     bca:	89 e5                	mov    %esp,%ebp
     bcc:	57                   	push   %edi
     bcd:	56                   	push   %esi
     bce:	53                   	push   %ebx
     bcf:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     bd2:	68 60 3e 00 00       	push   $0x3e60
     bd7:	6a 01                	push   $0x1
     bd9:	e8 74 2b 00 00       	call   3752 <printf>
  ppid = getpid();
     bde:	e8 94 2a 00 00       	call   3677 <getpid>
     be3:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     be5:	e8 05 2a 00 00       	call   35ef <fork>
     bea:	83 c4 10             	add    $0x10,%esp
     bed:	bb 00 00 00 00       	mov    $0x0,%ebx
     bf2:	85 c0                	test   %eax,%eax
     bf4:	74 06                	je     bfc <mem+0x33>
     bf6:	eb 7d                	jmp    c75 <mem+0xac>
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
     bf8:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     bfa:	89 c3                	mov    %eax,%ebx

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     bfc:	83 ec 0c             	sub    $0xc,%esp
     bff:	68 11 27 00 00       	push   $0x2711
     c04:	e8 80 2d 00 00       	call   3989 <malloc>
     c09:	83 c4 10             	add    $0x10,%esp
     c0c:	85 c0                	test   %eax,%eax
     c0e:	75 e8                	jne    bf8 <mem+0x2f>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     c10:	85 db                	test   %ebx,%ebx
     c12:	74 14                	je     c28 <mem+0x5f>
      m2 = *(char**)m1;
     c14:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     c16:	83 ec 0c             	sub    $0xc,%esp
     c19:	53                   	push   %ebx
     c1a:	e8 f8 2c 00 00       	call   3917 <free>
      m1 = m2;
     c1f:	89 fb                	mov    %edi,%ebx
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     c21:	83 c4 10             	add    $0x10,%esp
     c24:	85 ff                	test   %edi,%edi
     c26:	75 ec                	jne    c14 <mem+0x4b>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     c28:	83 ec 0c             	sub    $0xc,%esp
     c2b:	68 00 50 00 00       	push   $0x5000
     c30:	e8 54 2d 00 00       	call   3989 <malloc>
    if(m1 == 0){
     c35:	83 c4 10             	add    $0x10,%esp
     c38:	85 c0                	test   %eax,%eax
     c3a:	75 1c                	jne    c58 <mem+0x8f>
      printf(1, "couldn't allocate mem?!!\n");
     c3c:	83 ec 08             	sub    $0x8,%esp
     c3f:	68 6a 3e 00 00       	push   $0x3e6a
     c44:	6a 01                	push   $0x1
     c46:	e8 07 2b 00 00       	call   3752 <printf>
      kill(ppid);
     c4b:	89 34 24             	mov    %esi,(%esp)
     c4e:	e8 d4 29 00 00       	call   3627 <kill>
      exit();
     c53:	e8 9f 29 00 00       	call   35f7 <exit>
    }
    free(m1);
     c58:	83 ec 0c             	sub    $0xc,%esp
     c5b:	50                   	push   %eax
     c5c:	e8 b6 2c 00 00       	call   3917 <free>
    printf(1, "mem ok\n");
     c61:	83 c4 08             	add    $0x8,%esp
     c64:	68 84 3e 00 00       	push   $0x3e84
     c69:	6a 01                	push   $0x1
     c6b:	e8 e2 2a 00 00       	call   3752 <printf>
    exit();
     c70:	e8 82 29 00 00       	call   35f7 <exit>
  } else {
    wait();
     c75:	e8 85 29 00 00       	call   35ff <wait>
  }
}
     c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c7d:	5b                   	pop    %ebx
     c7e:	5e                   	pop    %esi
     c7f:	5f                   	pop    %edi
     c80:	5d                   	pop    %ebp
     c81:	c3                   	ret    

00000c82 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     c82:	55                   	push   %ebp
     c83:	89 e5                	mov    %esp,%ebp
     c85:	57                   	push   %edi
     c86:	56                   	push   %esi
     c87:	53                   	push   %ebx
     c88:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     c8b:	68 8c 3e 00 00       	push   $0x3e8c
     c90:	6a 01                	push   $0x1
     c92:	e8 bb 2a 00 00       	call   3752 <printf>

  unlink("sharedfd");
     c97:	c7 04 24 9b 3e 00 00 	movl   $0x3e9b,(%esp)
     c9e:	e8 a4 29 00 00       	call   3647 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ca3:	83 c4 08             	add    $0x8,%esp
     ca6:	68 02 02 00 00       	push   $0x202
     cab:	68 9b 3e 00 00       	push   $0x3e9b
     cb0:	e8 82 29 00 00       	call   3637 <open>
  if(fd < 0){
     cb5:	83 c4 10             	add    $0x10,%esp
     cb8:	85 c0                	test   %eax,%eax
     cba:	79 17                	jns    cd3 <sharedfd+0x51>
    printf(1, "fstests: cannot open sharedfd for writing");
     cbc:	83 ec 08             	sub    $0x8,%esp
     cbf:	68 60 4b 00 00       	push   $0x4b60
     cc4:	6a 01                	push   $0x1
     cc6:	e8 87 2a 00 00       	call   3752 <printf>
    return;
     ccb:	83 c4 10             	add    $0x10,%esp
     cce:	e9 3f 01 00 00       	jmp    e12 <sharedfd+0x190>
     cd3:	89 c6                	mov    %eax,%esi
  }
  pid = fork();
     cd5:	e8 15 29 00 00       	call   35ef <fork>
     cda:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     cdd:	83 f8 01             	cmp    $0x1,%eax
     ce0:	19 c0                	sbb    %eax,%eax
     ce2:	83 e0 f3             	and    $0xfffffff3,%eax
     ce5:	83 c0 70             	add    $0x70,%eax
     ce8:	83 ec 04             	sub    $0x4,%esp
     ceb:	6a 0a                	push   $0xa
     ced:	50                   	push   %eax
     cee:	8d 45 de             	lea    -0x22(%ebp),%eax
     cf1:	50                   	push   %eax
     cf2:	e8 af 27 00 00       	call   34a6 <memset>
     cf7:	83 c4 10             	add    $0x10,%esp
     cfa:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  for(i = 0; i < 1000; i++){
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     cff:	8d 7d de             	lea    -0x22(%ebp),%edi
     d02:	83 ec 04             	sub    $0x4,%esp
     d05:	6a 0a                	push   $0xa
     d07:	57                   	push   %edi
     d08:	56                   	push   %esi
     d09:	e8 09 29 00 00       	call   3617 <write>
     d0e:	83 c4 10             	add    $0x10,%esp
     d11:	83 f8 0a             	cmp    $0xa,%eax
     d14:	74 14                	je     d2a <sharedfd+0xa8>
      printf(1, "fstests: write sharedfd failed\n");
     d16:	83 ec 08             	sub    $0x8,%esp
     d19:	68 8c 4b 00 00       	push   $0x4b8c
     d1e:	6a 01                	push   $0x1
     d20:	e8 2d 2a 00 00       	call   3752 <printf>
      break;
     d25:	83 c4 10             	add    $0x10,%esp
     d28:	eb 05                	jmp    d2f <sharedfd+0xad>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     d2a:	83 eb 01             	sub    $0x1,%ebx
     d2d:	75 d3                	jne    d02 <sharedfd+0x80>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     d2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
     d33:	75 05                	jne    d3a <sharedfd+0xb8>
    exit();
     d35:	e8 bd 28 00 00       	call   35f7 <exit>
  else
    wait();
     d3a:	e8 c0 28 00 00       	call   35ff <wait>
  close(fd);
     d3f:	83 ec 0c             	sub    $0xc,%esp
     d42:	56                   	push   %esi
     d43:	e8 d7 28 00 00       	call   361f <close>
  fd = open("sharedfd", 0);
     d48:	83 c4 08             	add    $0x8,%esp
     d4b:	6a 00                	push   $0x0
     d4d:	68 9b 3e 00 00       	push   $0x3e9b
     d52:	e8 e0 28 00 00       	call   3637 <open>
     d57:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     d5a:	83 c4 10             	add    $0x10,%esp
     d5d:	bb 00 00 00 00       	mov    $0x0,%ebx
     d62:	bf 00 00 00 00       	mov    $0x0,%edi
     d67:	8d 75 e8             	lea    -0x18(%ebp),%esi
     d6a:	85 c0                	test   %eax,%eax
     d6c:	79 36                	jns    da4 <sharedfd+0x122>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     d6e:	83 ec 08             	sub    $0x8,%esp
     d71:	68 ac 4b 00 00       	push   $0x4bac
     d76:	6a 01                	push   $0x1
     d78:	e8 d5 29 00 00       	call   3752 <printf>
    return;
     d7d:	83 c4 10             	add    $0x10,%esp
     d80:	e9 8d 00 00 00       	jmp    e12 <sharedfd+0x190>
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
      if(buf[i] == 'c')
     d85:	0f b6 10             	movzbl (%eax),%edx
     d88:	80 fa 63             	cmp    $0x63,%dl
     d8b:	75 05                	jne    d92 <sharedfd+0x110>
        nc++;
     d8d:	83 c7 01             	add    $0x1,%edi
     d90:	eb 0b                	jmp    d9d <sharedfd+0x11b>
      if(buf[i] == 'p')
        np++;
     d92:	80 fa 70             	cmp    $0x70,%dl
     d95:	0f 94 c2             	sete   %dl
     d98:	0f b6 d2             	movzbl %dl,%edx
     d9b:	01 d3                	add    %edx,%ebx
     d9d:	83 c0 01             	add    $0x1,%eax
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     da0:	39 c6                	cmp    %eax,%esi
     da2:	75 e1                	jne    d85 <sharedfd+0x103>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     da4:	83 ec 04             	sub    $0x4,%esp
     da7:	6a 0a                	push   $0xa
     da9:	8d 45 de             	lea    -0x22(%ebp),%eax
     dac:	50                   	push   %eax
     dad:	ff 75 d4             	pushl  -0x2c(%ebp)
     db0:	e8 5a 28 00 00       	call   360f <read>
     db5:	83 c4 10             	add    $0x10,%esp
     db8:	85 c0                	test   %eax,%eax
     dba:	7e 05                	jle    dc1 <sharedfd+0x13f>
     dbc:	8d 45 de             	lea    -0x22(%ebp),%eax
     dbf:	eb c4                	jmp    d85 <sharedfd+0x103>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     dc1:	83 ec 0c             	sub    $0xc,%esp
     dc4:	ff 75 d4             	pushl  -0x2c(%ebp)
     dc7:	e8 53 28 00 00       	call   361f <close>
  unlink("sharedfd");
     dcc:	c7 04 24 9b 3e 00 00 	movl   $0x3e9b,(%esp)
     dd3:	e8 6f 28 00 00       	call   3647 <unlink>
  if(nc == 10000 && np == 10000){
     dd8:	83 c4 10             	add    $0x10,%esp
     ddb:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     de1:	75 1c                	jne    dff <sharedfd+0x17d>
     de3:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     de9:	75 14                	jne    dff <sharedfd+0x17d>
    printf(1, "sharedfd ok\n");
     deb:	83 ec 08             	sub    $0x8,%esp
     dee:	68 a4 3e 00 00       	push   $0x3ea4
     df3:	6a 01                	push   $0x1
     df5:	e8 58 29 00 00       	call   3752 <printf>
     dfa:	83 c4 10             	add    $0x10,%esp
     dfd:	eb 13                	jmp    e12 <sharedfd+0x190>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     dff:	53                   	push   %ebx
     e00:	57                   	push   %edi
     e01:	68 b1 3e 00 00       	push   $0x3eb1
     e06:	6a 01                	push   $0x1
     e08:	e8 45 29 00 00       	call   3752 <printf>
    exit();
     e0d:	e8 e5 27 00 00       	call   35f7 <exit>
  }
}
     e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e15:	5b                   	pop    %ebx
     e16:	5e                   	pop    %esi
     e17:	5f                   	pop    %edi
     e18:	5d                   	pop    %ebp
     e19:	c3                   	ret    

00000e1a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     e1a:	55                   	push   %ebp
     e1b:	89 e5                	mov    %esp,%ebp
     e1d:	57                   	push   %edi
     e1e:	56                   	push   %esi
     e1f:	53                   	push   %ebx
     e20:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     e23:	c7 45 d8 c6 3e 00 00 	movl   $0x3ec6,-0x28(%ebp)
     e2a:	c7 45 dc 0f 40 00 00 	movl   $0x400f,-0x24(%ebp)
     e31:	c7 45 e0 13 40 00 00 	movl   $0x4013,-0x20(%ebp)
     e38:	c7 45 e4 c9 3e 00 00 	movl   $0x3ec9,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
     e3f:	68 cc 3e 00 00       	push   $0x3ecc
     e44:	6a 01                	push   $0x1
     e46:	e8 07 29 00 00       	call   3752 <printf>
     e4b:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
     e4e:	bb 00 00 00 00       	mov    $0x0,%ebx
    fname = names[pi];
     e53:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    unlink(fname);
     e57:	83 ec 0c             	sub    $0xc,%esp
     e5a:	56                   	push   %esi
     e5b:	e8 e7 27 00 00       	call   3647 <unlink>

    pid = fork();
     e60:	e8 8a 27 00 00       	call   35ef <fork>
    if(pid < 0){
     e65:	83 c4 10             	add    $0x10,%esp
     e68:	85 c0                	test   %eax,%eax
     e6a:	79 14                	jns    e80 <fourfiles+0x66>
      printf(1, "fork failed\n");
     e6c:	83 ec 08             	sub    $0x8,%esp
     e6f:	68 a1 49 00 00       	push   $0x49a1
     e74:	6a 01                	push   $0x1
     e76:	e8 d7 28 00 00       	call   3752 <printf>
      exit();
     e7b:	e8 77 27 00 00       	call   35f7 <exit>
    }

    if(pid == 0){
     e80:	85 c0                	test   %eax,%eax
     e82:	0f 85 85 00 00 00    	jne    f0d <fourfiles+0xf3>
      fd = open(fname, O_CREATE | O_RDWR);
     e88:	83 ec 08             	sub    $0x8,%esp
     e8b:	68 02 02 00 00       	push   $0x202
     e90:	56                   	push   %esi
     e91:	e8 a1 27 00 00       	call   3637 <open>
     e96:	89 c6                	mov    %eax,%esi
      if(fd < 0){
     e98:	83 c4 10             	add    $0x10,%esp
     e9b:	85 c0                	test   %eax,%eax
     e9d:	79 14                	jns    eb3 <fourfiles+0x99>
        printf(1, "create failed\n");
     e9f:	83 ec 08             	sub    $0x8,%esp
     ea2:	68 67 41 00 00       	push   $0x4167
     ea7:	6a 01                	push   $0x1
     ea9:	e8 a4 28 00 00       	call   3752 <printf>
        exit();
     eae:	e8 44 27 00 00       	call   35f7 <exit>
      }

      memset(buf, '0'+pi, 512);
     eb3:	83 ec 04             	sub    $0x4,%esp
     eb6:	68 00 02 00 00       	push   $0x200
     ebb:	83 c3 30             	add    $0x30,%ebx
     ebe:	53                   	push   %ebx
     ebf:	68 00 82 00 00       	push   $0x8200
     ec4:	e8 dd 25 00 00       	call   34a6 <memset>
     ec9:	83 c4 10             	add    $0x10,%esp
     ecc:	bb 0c 00 00 00       	mov    $0xc,%ebx
      for(i = 0; i < 12; i++){
        if((n = write(fd, buf, 500)) != 500){
     ed1:	83 ec 04             	sub    $0x4,%esp
     ed4:	68 f4 01 00 00       	push   $0x1f4
     ed9:	68 00 82 00 00       	push   $0x8200
     ede:	56                   	push   %esi
     edf:	e8 33 27 00 00       	call   3617 <write>
     ee4:	83 c4 10             	add    $0x10,%esp
     ee7:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     eec:	74 15                	je     f03 <fourfiles+0xe9>
          printf(1, "write failed %d\n", n);
     eee:	83 ec 04             	sub    $0x4,%esp
     ef1:	50                   	push   %eax
     ef2:	68 dc 3e 00 00       	push   $0x3edc
     ef7:	6a 01                	push   $0x1
     ef9:	e8 54 28 00 00       	call   3752 <printf>
          exit();
     efe:	e8 f4 26 00 00       	call   35f7 <exit>
        printf(1, "create failed\n");
        exit();
      }

      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
     f03:	83 eb 01             	sub    $0x1,%ebx
     f06:	75 c9                	jne    ed1 <fourfiles+0xb7>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
     f08:	e8 ea 26 00 00       	call   35f7 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
     f0d:	83 c3 01             	add    $0x1,%ebx
     f10:	83 fb 04             	cmp    $0x4,%ebx
     f13:	0f 85 3a ff ff ff    	jne    e53 <fourfiles+0x39>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
     f19:	e8 e1 26 00 00       	call   35ff <wait>
     f1e:	e8 dc 26 00 00       	call   35ff <wait>
     f23:	e8 d7 26 00 00       	call   35ff <wait>
     f28:	e8 d2 26 00 00       	call   35ff <wait>
     f2d:	c7 45 d4 30 00 00 00 	movl   $0x30,-0x2c(%ebp)
  }

  for(i = 0; i < 2; i++){
    fname = names[i];
     f34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     f37:	8b 84 85 18 ff ff ff 	mov    -0xe8(%ebp,%eax,4),%eax
     f3e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    fd = open(fname, 0);
     f41:	83 ec 08             	sub    $0x8,%esp
     f44:	6a 00                	push   $0x0
     f46:	50                   	push   %eax
     f47:	e8 eb 26 00 00       	call   3637 <open>
     f4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f4f:	83 c4 10             	add    $0x10,%esp
  }

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
     f52:	bb 00 00 00 00       	mov    $0x0,%ebx
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f57:	eb 24                	jmp    f7d <fourfiles+0x163>
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
     f59:	0f be 0a             	movsbl (%edx),%ecx
     f5c:	83 c2 01             	add    $0x1,%edx
     f5f:	39 f1                	cmp    %esi,%ecx
     f61:	74 14                	je     f77 <fourfiles+0x15d>
          printf(1, "wrong char\n");
     f63:	83 ec 08             	sub    $0x8,%esp
     f66:	68 ed 3e 00 00       	push   $0x3eed
     f6b:	6a 01                	push   $0x1
     f6d:	e8 e0 27 00 00       	call   3752 <printf>
          exit();
     f72:	e8 80 26 00 00       	call   35f7 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
     f77:	39 fa                	cmp    %edi,%edx
     f79:	75 de                	jne    f59 <fourfiles+0x13f>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
     f7b:	01 c3                	add    %eax,%ebx

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f7d:	83 ec 04             	sub    $0x4,%esp
     f80:	68 00 20 00 00       	push   $0x2000
     f85:	68 00 82 00 00       	push   $0x8200
     f8a:	ff 75 d0             	pushl  -0x30(%ebp)
     f8d:	e8 7d 26 00 00       	call   360f <read>
     f92:	83 c4 10             	add    $0x10,%esp
     f95:	85 c0                	test   %eax,%eax
     f97:	7e 19                	jle    fb2 <fourfiles+0x198>
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
     f99:	0f be 35 00 82 00 00 	movsbl 0x8200,%esi
     fa0:	3b 75 d4             	cmp    -0x2c(%ebp),%esi
     fa3:	75 be                	jne    f63 <fourfiles+0x149>
     fa5:	ba 01 82 00 00       	mov    $0x8201,%edx
     faa:	8d b8 00 82 00 00    	lea    0x8200(%eax),%edi
     fb0:	eb c5                	jmp    f77 <fourfiles+0x15d>
          exit();
        }
      }
      total += n;
    }
    close(fd);
     fb2:	83 ec 0c             	sub    $0xc,%esp
     fb5:	ff 75 d0             	pushl  -0x30(%ebp)
     fb8:	e8 62 26 00 00       	call   361f <close>
    if(total != 12*500){
     fbd:	83 c4 10             	add    $0x10,%esp
     fc0:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
     fc6:	74 15                	je     fdd <fourfiles+0x1c3>
      printf(1, "wrong length %d\n", total);
     fc8:	83 ec 04             	sub    $0x4,%esp
     fcb:	53                   	push   %ebx
     fcc:	68 f9 3e 00 00       	push   $0x3ef9
     fd1:	6a 01                	push   $0x1
     fd3:	e8 7a 27 00 00       	call   3752 <printf>
      exit();
     fd8:	e8 1a 26 00 00       	call   35f7 <exit>
    }
    unlink(fname);
     fdd:	83 ec 0c             	sub    $0xc,%esp
     fe0:	ff 75 cc             	pushl  -0x34(%ebp)
     fe3:	e8 5f 26 00 00       	call   3647 <unlink>
     fe8:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
     fec:	8b 45 d4             	mov    -0x2c(%ebp),%eax

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
     fef:	83 c4 10             	add    $0x10,%esp
     ff2:	83 f8 32             	cmp    $0x32,%eax
     ff5:	0f 85 39 ff ff ff    	jne    f34 <fourfiles+0x11a>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
     ffb:	83 ec 08             	sub    $0x8,%esp
     ffe:	68 0a 3f 00 00       	push   $0x3f0a
    1003:	6a 01                	push   $0x1
    1005:	e8 48 27 00 00       	call   3752 <printf>
}
    100a:	83 c4 10             	add    $0x10,%esp
    100d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1010:	5b                   	pop    %ebx
    1011:	5e                   	pop    %esi
    1012:	5f                   	pop    %edi
    1013:	5d                   	pop    %ebp
    1014:	c3                   	ret    

00001015 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1015:	55                   	push   %ebp
    1016:	89 e5                	mov    %esp,%ebp
    1018:	57                   	push   %edi
    1019:	56                   	push   %esi
    101a:	53                   	push   %ebx
    101b:	83 ec 44             	sub    $0x44,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    101e:	68 18 3f 00 00       	push   $0x3f18
    1023:	6a 01                	push   $0x1
    1025:	e8 28 27 00 00       	call   3752 <printf>
    102a:	83 c4 10             	add    $0x10,%esp

  for(pi = 0; pi < 4; pi++){
    102d:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    1032:	e8 b8 25 00 00       	call   35ef <fork>
    if(pid < 0){
    1037:	85 c0                	test   %eax,%eax
    1039:	79 14                	jns    104f <createdelete+0x3a>
      printf(1, "fork failed\n");
    103b:	83 ec 08             	sub    $0x8,%esp
    103e:	68 a1 49 00 00       	push   $0x49a1
    1043:	6a 01                	push   $0x1
    1045:	e8 08 27 00 00       	call   3752 <printf>
      exit();
    104a:	e8 a8 25 00 00       	call   35f7 <exit>
    }

    if(pid == 0){
    104f:	85 c0                	test   %eax,%eax
    1051:	0f 85 96 00 00 00    	jne    10ed <createdelete+0xd8>
      name[0] = 'p' + pi;
    1057:	83 c3 70             	add    $0x70,%ebx
    105a:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    105d:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    1061:	bb 00 00 00 00       	mov    $0x0,%ebx
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
    1066:	8d 75 c8             	lea    -0x38(%ebp),%esi

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
        name[1] = '0' + i;
    1069:	8d 43 30             	lea    0x30(%ebx),%eax
    106c:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    106f:	83 ec 08             	sub    $0x8,%esp
    1072:	68 02 02 00 00       	push   $0x202
    1077:	56                   	push   %esi
    1078:	e8 ba 25 00 00       	call   3637 <open>
        if(fd < 0){
    107d:	83 c4 10             	add    $0x10,%esp
    1080:	85 c0                	test   %eax,%eax
    1082:	79 14                	jns    1098 <createdelete+0x83>
          printf(1, "create failed\n");
    1084:	83 ec 08             	sub    $0x8,%esp
    1087:	68 67 41 00 00       	push   $0x4167
    108c:	6a 01                	push   $0x1
    108e:	e8 bf 26 00 00       	call   3752 <printf>
          exit();
    1093:	e8 5f 25 00 00       	call   35f7 <exit>
        }
        close(fd);
    1098:	83 ec 0c             	sub    $0xc,%esp
    109b:	50                   	push   %eax
    109c:	e8 7e 25 00 00       	call   361f <close>
        if(i > 0 && (i % 2 ) == 0){
    10a1:	83 c4 10             	add    $0x10,%esp
    10a4:	85 db                	test   %ebx,%ebx
    10a6:	7e 38                	jle    10e0 <createdelete+0xcb>
    10a8:	f6 c3 01             	test   $0x1,%bl
    10ab:	75 33                	jne    10e0 <createdelete+0xcb>
          name[1] = '0' + (i / 2);
    10ad:	89 d8                	mov    %ebx,%eax
    10af:	c1 e8 1f             	shr    $0x1f,%eax
    10b2:	01 d8                	add    %ebx,%eax
    10b4:	d1 f8                	sar    %eax
    10b6:	83 c0 30             	add    $0x30,%eax
    10b9:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    10bc:	83 ec 0c             	sub    $0xc,%esp
    10bf:	56                   	push   %esi
    10c0:	e8 82 25 00 00       	call   3647 <unlink>
    10c5:	83 c4 10             	add    $0x10,%esp
    10c8:	85 c0                	test   %eax,%eax
    10ca:	79 14                	jns    10e0 <createdelete+0xcb>
            printf(1, "unlink failed\n");
    10cc:	83 ec 08             	sub    $0x8,%esp
    10cf:	68 19 3b 00 00       	push   $0x3b19
    10d4:	6a 01                	push   $0x1
    10d6:	e8 77 26 00 00       	call   3752 <printf>
            exit();
    10db:	e8 17 25 00 00       	call   35f7 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    10e0:	83 c3 01             	add    $0x1,%ebx
    10e3:	83 fb 14             	cmp    $0x14,%ebx
    10e6:	75 81                	jne    1069 <createdelete+0x54>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    10e8:	e8 0a 25 00 00       	call   35f7 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    10ed:	83 c3 01             	add    $0x1,%ebx
    10f0:	83 fb 04             	cmp    $0x4,%ebx
    10f3:	0f 85 39 ff ff ff    	jne    1032 <createdelete+0x1d>
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    wait();
    10f9:	e8 01 25 00 00       	call   35ff <wait>
    10fe:	e8 fc 24 00 00       	call   35ff <wait>
    1103:	e8 f7 24 00 00       	call   35ff <wait>
    1108:	e8 f2 24 00 00       	call   35ff <wait>
  }

  name[0] = name[1] = name[2] = 0;
    110d:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    1111:	be 00 00 00 00       	mov    $0x0,%esi
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
      fd = open(name, 0);
    1116:	8d 7d c8             	lea    -0x38(%ebp),%edi
    1119:	e9 90 00 00 00       	jmp    11ae <createdelete+0x199>
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
    111e:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[1] = '0' + i;
    1121:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    1125:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1128:	83 ec 08             	sub    $0x8,%esp
    112b:	6a 00                	push   $0x0
    112d:	57                   	push   %edi
    112e:	e8 04 25 00 00       	call   3637 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1133:	83 c4 10             	add    $0x10,%esp
    1136:	85 f6                	test   %esi,%esi
    1138:	0f 94 c1             	sete   %cl
    113b:	83 fe 09             	cmp    $0x9,%esi
    113e:	0f 9f c2             	setg   %dl
    1141:	08 d1                	or     %dl,%cl
    1143:	74 21                	je     1166 <createdelete+0x151>
    1145:	89 c2                	mov    %eax,%edx
    1147:	c1 ea 1f             	shr    $0x1f,%edx
    114a:	84 d2                	test   %dl,%dl
    114c:	74 18                	je     1166 <createdelete+0x151>
        printf(1, "oops createdelete %s didn't exist\n", name);
    114e:	83 ec 04             	sub    $0x4,%esp
    1151:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1154:	50                   	push   %eax
    1155:	68 d8 4b 00 00       	push   $0x4bd8
    115a:	6a 01                	push   $0x1
    115c:	e8 f1 25 00 00       	call   3752 <printf>
        exit();
    1161:	e8 91 24 00 00       	call   35f7 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1166:	8d 56 ff             	lea    -0x1(%esi),%edx
    1169:	83 fa 08             	cmp    $0x8,%edx
    116c:	77 1c                	ja     118a <createdelete+0x175>
    116e:	85 c0                	test   %eax,%eax
    1170:	78 18                	js     118a <createdelete+0x175>
        printf(1, "oops createdelete %s did exist\n", name);
    1172:	83 ec 04             	sub    $0x4,%esp
    1175:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1178:	50                   	push   %eax
    1179:	68 fc 4b 00 00       	push   $0x4bfc
    117e:	6a 01                	push   $0x1
    1180:	e8 cd 25 00 00       	call   3752 <printf>
        exit();
    1185:	e8 6d 24 00 00       	call   35f7 <exit>
      }
      if(fd >= 0)
    118a:	85 c0                	test   %eax,%eax
    118c:	78 0c                	js     119a <createdelete+0x185>
        close(fd);
    118e:	83 ec 0c             	sub    $0xc,%esp
    1191:	50                   	push   %eax
    1192:	e8 88 24 00 00       	call   361f <close>
    1197:	83 c4 10             	add    $0x10,%esp
    119a:	83 c3 01             	add    $0x1,%ebx
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    119d:	80 fb 74             	cmp    $0x74,%bl
    11a0:	0f 85 78 ff ff ff    	jne    111e <createdelete+0x109>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    11a6:	83 c6 01             	add    $0x1,%esi
    11a9:	83 fe 14             	cmp    $0x14,%esi
    11ac:	74 38                	je     11e6 <createdelete+0x1d1>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    11ae:	bb 70 00 00 00       	mov    $0x70,%ebx

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + pi;
      name[1] = '0' + i;
    11b3:	8d 46 30             	lea    0x30(%esi),%eax
    11b6:	88 45 c7             	mov    %al,-0x39(%ebp)
    11b9:	e9 60 ff ff ff       	jmp    111e <createdelete+0x109>
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    11be:	89 f0                	mov    %esi,%eax
    11c0:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    11c3:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    11c7:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    11ca:	83 ec 0c             	sub    $0xc,%esp
    11cd:	57                   	push   %edi
    11ce:	e8 74 24 00 00       	call   3647 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    11d3:	83 c4 10             	add    $0x10,%esp
    11d6:	83 eb 01             	sub    $0x1,%ebx
    11d9:	75 e3                	jne    11be <createdelete+0x1a9>
    11db:	83 c6 01             	add    $0x1,%esi
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    11de:	89 f0                	mov    %esi,%eax
    11e0:	3c 84                	cmp    $0x84,%al
    11e2:	75 0a                	jne    11ee <createdelete+0x1d9>
    11e4:	eb 15                	jmp    11fb <createdelete+0x1e6>
    11e6:	be 70 00 00 00       	mov    $0x70,%esi
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
      name[1] = '0' + i;
      unlink(name);
    11eb:	8d 7d c8             	lea    -0x38(%ebp),%edi
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    11ee:	bb 04 00 00 00       	mov    $0x4,%ebx
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
      name[1] = '0' + i;
    11f3:	8d 46 c0             	lea    -0x40(%esi),%eax
    11f6:	88 45 c7             	mov    %al,-0x39(%ebp)
    11f9:	eb c3                	jmp    11be <createdelete+0x1a9>
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    11fb:	83 ec 08             	sub    $0x8,%esp
    11fe:	68 2b 3f 00 00       	push   $0x3f2b
    1203:	6a 01                	push   $0x1
    1205:	e8 48 25 00 00       	call   3752 <printf>
}
    120a:	83 c4 10             	add    $0x10,%esp
    120d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1210:	5b                   	pop    %ebx
    1211:	5e                   	pop    %esi
    1212:	5f                   	pop    %edi
    1213:	5d                   	pop    %ebp
    1214:	c3                   	ret    

00001215 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1215:	55                   	push   %ebp
    1216:	89 e5                	mov    %esp,%ebp
    1218:	56                   	push   %esi
    1219:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    121a:	83 ec 08             	sub    $0x8,%esp
    121d:	68 3c 3f 00 00       	push   $0x3f3c
    1222:	6a 01                	push   $0x1
    1224:	e8 29 25 00 00       	call   3752 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1229:	83 c4 08             	add    $0x8,%esp
    122c:	68 02 02 00 00       	push   $0x202
    1231:	68 4d 3f 00 00       	push   $0x3f4d
    1236:	e8 fc 23 00 00       	call   3637 <open>
  if(fd < 0){
    123b:	83 c4 10             	add    $0x10,%esp
    123e:	85 c0                	test   %eax,%eax
    1240:	79 14                	jns    1256 <unlinkread+0x41>
    printf(1, "create unlinkread failed\n");
    1242:	83 ec 08             	sub    $0x8,%esp
    1245:	68 58 3f 00 00       	push   $0x3f58
    124a:	6a 01                	push   $0x1
    124c:	e8 01 25 00 00       	call   3752 <printf>
    exit();
    1251:	e8 a1 23 00 00       	call   35f7 <exit>
    1256:	89 c3                	mov    %eax,%ebx
  }
  write(fd, "hello", 5);
    1258:	83 ec 04             	sub    $0x4,%esp
    125b:	6a 05                	push   $0x5
    125d:	68 72 3f 00 00       	push   $0x3f72
    1262:	50                   	push   %eax
    1263:	e8 af 23 00 00       	call   3617 <write>
  close(fd);
    1268:	89 1c 24             	mov    %ebx,(%esp)
    126b:	e8 af 23 00 00       	call   361f <close>

  fd = open("unlinkread", O_RDWR);
    1270:	83 c4 08             	add    $0x8,%esp
    1273:	6a 02                	push   $0x2
    1275:	68 4d 3f 00 00       	push   $0x3f4d
    127a:	e8 b8 23 00 00       	call   3637 <open>
    127f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1281:	83 c4 10             	add    $0x10,%esp
    1284:	85 c0                	test   %eax,%eax
    1286:	79 14                	jns    129c <unlinkread+0x87>
    printf(1, "open unlinkread failed\n");
    1288:	83 ec 08             	sub    $0x8,%esp
    128b:	68 78 3f 00 00       	push   $0x3f78
    1290:	6a 01                	push   $0x1
    1292:	e8 bb 24 00 00       	call   3752 <printf>
    exit();
    1297:	e8 5b 23 00 00       	call   35f7 <exit>
  }
  if(unlink("unlinkread") != 0){
    129c:	83 ec 0c             	sub    $0xc,%esp
    129f:	68 4d 3f 00 00       	push   $0x3f4d
    12a4:	e8 9e 23 00 00       	call   3647 <unlink>
    12a9:	83 c4 10             	add    $0x10,%esp
    12ac:	85 c0                	test   %eax,%eax
    12ae:	74 14                	je     12c4 <unlinkread+0xaf>
    printf(1, "unlink unlinkread failed\n");
    12b0:	83 ec 08             	sub    $0x8,%esp
    12b3:	68 90 3f 00 00       	push   $0x3f90
    12b8:	6a 01                	push   $0x1
    12ba:	e8 93 24 00 00       	call   3752 <printf>
    exit();
    12bf:	e8 33 23 00 00       	call   35f7 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12c4:	83 ec 08             	sub    $0x8,%esp
    12c7:	68 02 02 00 00       	push   $0x202
    12cc:	68 4d 3f 00 00       	push   $0x3f4d
    12d1:	e8 61 23 00 00       	call   3637 <open>
    12d6:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    12d8:	83 c4 0c             	add    $0xc,%esp
    12db:	6a 03                	push   $0x3
    12dd:	68 aa 3f 00 00       	push   $0x3faa
    12e2:	50                   	push   %eax
    12e3:	e8 2f 23 00 00       	call   3617 <write>
  close(fd1);
    12e8:	89 34 24             	mov    %esi,(%esp)
    12eb:	e8 2f 23 00 00       	call   361f <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    12f0:	83 c4 0c             	add    $0xc,%esp
    12f3:	68 00 20 00 00       	push   $0x2000
    12f8:	68 00 82 00 00       	push   $0x8200
    12fd:	53                   	push   %ebx
    12fe:	e8 0c 23 00 00       	call   360f <read>
    1303:	83 c4 10             	add    $0x10,%esp
    1306:	83 f8 05             	cmp    $0x5,%eax
    1309:	74 14                	je     131f <unlinkread+0x10a>
    printf(1, "unlinkread read failed");
    130b:	83 ec 08             	sub    $0x8,%esp
    130e:	68 ae 3f 00 00       	push   $0x3fae
    1313:	6a 01                	push   $0x1
    1315:	e8 38 24 00 00       	call   3752 <printf>
    exit();
    131a:	e8 d8 22 00 00       	call   35f7 <exit>
  }
  if(buf[0] != 'h'){
    131f:	80 3d 00 82 00 00 68 	cmpb   $0x68,0x8200
    1326:	74 14                	je     133c <unlinkread+0x127>
    printf(1, "unlinkread wrong data\n");
    1328:	83 ec 08             	sub    $0x8,%esp
    132b:	68 c5 3f 00 00       	push   $0x3fc5
    1330:	6a 01                	push   $0x1
    1332:	e8 1b 24 00 00       	call   3752 <printf>
    exit();
    1337:	e8 bb 22 00 00       	call   35f7 <exit>
  }
  if(write(fd, buf, 10) != 10){
    133c:	83 ec 04             	sub    $0x4,%esp
    133f:	6a 0a                	push   $0xa
    1341:	68 00 82 00 00       	push   $0x8200
    1346:	53                   	push   %ebx
    1347:	e8 cb 22 00 00       	call   3617 <write>
    134c:	83 c4 10             	add    $0x10,%esp
    134f:	83 f8 0a             	cmp    $0xa,%eax
    1352:	74 14                	je     1368 <unlinkread+0x153>
    printf(1, "unlinkread write failed\n");
    1354:	83 ec 08             	sub    $0x8,%esp
    1357:	68 dc 3f 00 00       	push   $0x3fdc
    135c:	6a 01                	push   $0x1
    135e:	e8 ef 23 00 00       	call   3752 <printf>
    exit();
    1363:	e8 8f 22 00 00       	call   35f7 <exit>
  }
  close(fd);
    1368:	83 ec 0c             	sub    $0xc,%esp
    136b:	53                   	push   %ebx
    136c:	e8 ae 22 00 00       	call   361f <close>
  unlink("unlinkread");
    1371:	c7 04 24 4d 3f 00 00 	movl   $0x3f4d,(%esp)
    1378:	e8 ca 22 00 00       	call   3647 <unlink>
  printf(1, "unlinkread ok\n");
    137d:	83 c4 08             	add    $0x8,%esp
    1380:	68 f5 3f 00 00       	push   $0x3ff5
    1385:	6a 01                	push   $0x1
    1387:	e8 c6 23 00 00       	call   3752 <printf>
}
    138c:	83 c4 10             	add    $0x10,%esp
    138f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1392:	5b                   	pop    %ebx
    1393:	5e                   	pop    %esi
    1394:	5d                   	pop    %ebp
    1395:	c3                   	ret    

00001396 <linktest>:

void
linktest(void)
{
    1396:	55                   	push   %ebp
    1397:	89 e5                	mov    %esp,%ebp
    1399:	53                   	push   %ebx
    139a:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    139d:	68 04 40 00 00       	push   $0x4004
    13a2:	6a 01                	push   $0x1
    13a4:	e8 a9 23 00 00       	call   3752 <printf>

  unlink("lf1");
    13a9:	c7 04 24 0e 40 00 00 	movl   $0x400e,(%esp)
    13b0:	e8 92 22 00 00       	call   3647 <unlink>
  unlink("lf2");
    13b5:	c7 04 24 12 40 00 00 	movl   $0x4012,(%esp)
    13bc:	e8 86 22 00 00       	call   3647 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    13c1:	83 c4 08             	add    $0x8,%esp
    13c4:	68 02 02 00 00       	push   $0x202
    13c9:	68 0e 40 00 00       	push   $0x400e
    13ce:	e8 64 22 00 00       	call   3637 <open>
  if(fd < 0){
    13d3:	83 c4 10             	add    $0x10,%esp
    13d6:	85 c0                	test   %eax,%eax
    13d8:	79 14                	jns    13ee <linktest+0x58>
    printf(1, "create lf1 failed\n");
    13da:	83 ec 08             	sub    $0x8,%esp
    13dd:	68 16 40 00 00       	push   $0x4016
    13e2:	6a 01                	push   $0x1
    13e4:	e8 69 23 00 00       	call   3752 <printf>
    exit();
    13e9:	e8 09 22 00 00       	call   35f7 <exit>
    13ee:	89 c3                	mov    %eax,%ebx
  }
  if(write(fd, "hello", 5) != 5){
    13f0:	83 ec 04             	sub    $0x4,%esp
    13f3:	6a 05                	push   $0x5
    13f5:	68 72 3f 00 00       	push   $0x3f72
    13fa:	50                   	push   %eax
    13fb:	e8 17 22 00 00       	call   3617 <write>
    1400:	83 c4 10             	add    $0x10,%esp
    1403:	83 f8 05             	cmp    $0x5,%eax
    1406:	74 14                	je     141c <linktest+0x86>
    printf(1, "write lf1 failed\n");
    1408:	83 ec 08             	sub    $0x8,%esp
    140b:	68 29 40 00 00       	push   $0x4029
    1410:	6a 01                	push   $0x1
    1412:	e8 3b 23 00 00       	call   3752 <printf>
    exit();
    1417:	e8 db 21 00 00       	call   35f7 <exit>
  }
  close(fd);
    141c:	83 ec 0c             	sub    $0xc,%esp
    141f:	53                   	push   %ebx
    1420:	e8 fa 21 00 00       	call   361f <close>

  if(link("lf1", "lf2") < 0){
    1425:	83 c4 08             	add    $0x8,%esp
    1428:	68 12 40 00 00       	push   $0x4012
    142d:	68 0e 40 00 00       	push   $0x400e
    1432:	e8 20 22 00 00       	call   3657 <link>
    1437:	83 c4 10             	add    $0x10,%esp
    143a:	85 c0                	test   %eax,%eax
    143c:	79 14                	jns    1452 <linktest+0xbc>
    printf(1, "link lf1 lf2 failed\n");
    143e:	83 ec 08             	sub    $0x8,%esp
    1441:	68 3b 40 00 00       	push   $0x403b
    1446:	6a 01                	push   $0x1
    1448:	e8 05 23 00 00       	call   3752 <printf>
    exit();
    144d:	e8 a5 21 00 00       	call   35f7 <exit>
  }
  unlink("lf1");
    1452:	83 ec 0c             	sub    $0xc,%esp
    1455:	68 0e 40 00 00       	push   $0x400e
    145a:	e8 e8 21 00 00       	call   3647 <unlink>

  if(open("lf1", 0) >= 0){
    145f:	83 c4 08             	add    $0x8,%esp
    1462:	6a 00                	push   $0x0
    1464:	68 0e 40 00 00       	push   $0x400e
    1469:	e8 c9 21 00 00       	call   3637 <open>
    146e:	83 c4 10             	add    $0x10,%esp
    1471:	85 c0                	test   %eax,%eax
    1473:	78 14                	js     1489 <linktest+0xf3>
    printf(1, "unlinked lf1 but it is still there!\n");
    1475:	83 ec 08             	sub    $0x8,%esp
    1478:	68 1c 4c 00 00       	push   $0x4c1c
    147d:	6a 01                	push   $0x1
    147f:	e8 ce 22 00 00       	call   3752 <printf>
    exit();
    1484:	e8 6e 21 00 00       	call   35f7 <exit>
  }

  fd = open("lf2", 0);
    1489:	83 ec 08             	sub    $0x8,%esp
    148c:	6a 00                	push   $0x0
    148e:	68 12 40 00 00       	push   $0x4012
    1493:	e8 9f 21 00 00       	call   3637 <open>
    1498:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    149a:	83 c4 10             	add    $0x10,%esp
    149d:	85 c0                	test   %eax,%eax
    149f:	79 14                	jns    14b5 <linktest+0x11f>
    printf(1, "open lf2 failed\n");
    14a1:	83 ec 08             	sub    $0x8,%esp
    14a4:	68 50 40 00 00       	push   $0x4050
    14a9:	6a 01                	push   $0x1
    14ab:	e8 a2 22 00 00       	call   3752 <printf>
    exit();
    14b0:	e8 42 21 00 00       	call   35f7 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    14b5:	83 ec 04             	sub    $0x4,%esp
    14b8:	68 00 20 00 00       	push   $0x2000
    14bd:	68 00 82 00 00       	push   $0x8200
    14c2:	50                   	push   %eax
    14c3:	e8 47 21 00 00       	call   360f <read>
    14c8:	83 c4 10             	add    $0x10,%esp
    14cb:	83 f8 05             	cmp    $0x5,%eax
    14ce:	74 14                	je     14e4 <linktest+0x14e>
    printf(1, "read lf2 failed\n");
    14d0:	83 ec 08             	sub    $0x8,%esp
    14d3:	68 61 40 00 00       	push   $0x4061
    14d8:	6a 01                	push   $0x1
    14da:	e8 73 22 00 00       	call   3752 <printf>
    exit();
    14df:	e8 13 21 00 00       	call   35f7 <exit>
  }
  close(fd);
    14e4:	83 ec 0c             	sub    $0xc,%esp
    14e7:	53                   	push   %ebx
    14e8:	e8 32 21 00 00       	call   361f <close>

  if(link("lf2", "lf2") >= 0){
    14ed:	83 c4 08             	add    $0x8,%esp
    14f0:	68 12 40 00 00       	push   $0x4012
    14f5:	68 12 40 00 00       	push   $0x4012
    14fa:	e8 58 21 00 00       	call   3657 <link>
    14ff:	83 c4 10             	add    $0x10,%esp
    1502:	85 c0                	test   %eax,%eax
    1504:	78 14                	js     151a <linktest+0x184>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1506:	83 ec 08             	sub    $0x8,%esp
    1509:	68 72 40 00 00       	push   $0x4072
    150e:	6a 01                	push   $0x1
    1510:	e8 3d 22 00 00       	call   3752 <printf>
    exit();
    1515:	e8 dd 20 00 00       	call   35f7 <exit>
  }

  unlink("lf2");
    151a:	83 ec 0c             	sub    $0xc,%esp
    151d:	68 12 40 00 00       	push   $0x4012
    1522:	e8 20 21 00 00       	call   3647 <unlink>
  if(link("lf2", "lf1") >= 0){
    1527:	83 c4 08             	add    $0x8,%esp
    152a:	68 0e 40 00 00       	push   $0x400e
    152f:	68 12 40 00 00       	push   $0x4012
    1534:	e8 1e 21 00 00       	call   3657 <link>
    1539:	83 c4 10             	add    $0x10,%esp
    153c:	85 c0                	test   %eax,%eax
    153e:	78 14                	js     1554 <linktest+0x1be>
    printf(1, "link non-existant succeeded! oops\n");
    1540:	83 ec 08             	sub    $0x8,%esp
    1543:	68 44 4c 00 00       	push   $0x4c44
    1548:	6a 01                	push   $0x1
    154a:	e8 03 22 00 00       	call   3752 <printf>
    exit();
    154f:	e8 a3 20 00 00       	call   35f7 <exit>
  }

  if(link(".", "lf1") >= 0){
    1554:	83 ec 08             	sub    $0x8,%esp
    1557:	68 0e 40 00 00       	push   $0x400e
    155c:	68 d6 42 00 00       	push   $0x42d6
    1561:	e8 f1 20 00 00       	call   3657 <link>
    1566:	83 c4 10             	add    $0x10,%esp
    1569:	85 c0                	test   %eax,%eax
    156b:	78 14                	js     1581 <linktest+0x1eb>
    printf(1, "link . lf1 succeeded! oops\n");
    156d:	83 ec 08             	sub    $0x8,%esp
    1570:	68 90 40 00 00       	push   $0x4090
    1575:	6a 01                	push   $0x1
    1577:	e8 d6 21 00 00       	call   3752 <printf>
    exit();
    157c:	e8 76 20 00 00       	call   35f7 <exit>
  }

  printf(1, "linktest ok\n");
    1581:	83 ec 08             	sub    $0x8,%esp
    1584:	68 ac 40 00 00       	push   $0x40ac
    1589:	6a 01                	push   $0x1
    158b:	e8 c2 21 00 00       	call   3752 <printf>
}
    1590:	83 c4 10             	add    $0x10,%esp
    1593:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1596:	c9                   	leave  
    1597:	c3                   	ret    

00001598 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1598:	55                   	push   %ebp
    1599:	89 e5                	mov    %esp,%ebp
    159b:	57                   	push   %edi
    159c:	56                   	push   %esi
    159d:	53                   	push   %ebx
    159e:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    15a1:	68 b9 40 00 00       	push   $0x40b9
    15a6:	6a 01                	push   $0x1
    15a8:	e8 a5 21 00 00       	call   3752 <printf>
  file[0] = 'C';
    15ad:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    15b1:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    15b5:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 40; i++){
    15b8:	bb 00 00 00 00       	mov    $0x0,%ebx
    file[1] = '0' + i;
    unlink(file);
    15bd:	8d 75 e5             	lea    -0x1b(%ebp),%esi
    pid = fork();
    if(pid && (i % 3) == 1){
    15c0:	bf 56 55 55 55       	mov    $0x55555556,%edi

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    15c5:	8d 43 30             	lea    0x30(%ebx),%eax
    15c8:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    15cb:	83 ec 0c             	sub    $0xc,%esp
    15ce:	56                   	push   %esi
    15cf:	e8 73 20 00 00       	call   3647 <unlink>
    pid = fork();
    15d4:	e8 16 20 00 00       	call   35ef <fork>
    if(pid && (i % 3) == 1){
    15d9:	83 c4 10             	add    $0x10,%esp
    15dc:	85 c0                	test   %eax,%eax
    15de:	74 2e                	je     160e <concreate+0x76>
    15e0:	89 d8                	mov    %ebx,%eax
    15e2:	f7 ef                	imul   %edi
    15e4:	89 d8                	mov    %ebx,%eax
    15e6:	c1 f8 1f             	sar    $0x1f,%eax
    15e9:	29 c2                	sub    %eax,%edx
    15eb:	8d 04 52             	lea    (%edx,%edx,2),%eax
    15ee:	89 d9                	mov    %ebx,%ecx
    15f0:	29 c1                	sub    %eax,%ecx
    15f2:	83 f9 01             	cmp    $0x1,%ecx
    15f5:	0f 85 6c 02 00 00    	jne    1867 <concreate+0x2cf>
      link("C0", file);
    15fb:	83 ec 08             	sub    $0x8,%esp
    15fe:	56                   	push   %esi
    15ff:	68 c9 40 00 00       	push   $0x40c9
    1604:	e8 4e 20 00 00       	call   3657 <link>
    1609:	83 c4 10             	add    $0x10,%esp
    160c:	eb 53                	jmp    1661 <concreate+0xc9>
    } else if(pid == 0 && (i % 5) == 1){
    160e:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1613:	89 d8                	mov    %ebx,%eax
    1615:	f7 ea                	imul   %edx
    1617:	d1 fa                	sar    %edx
    1619:	89 d8                	mov    %ebx,%eax
    161b:	c1 f8 1f             	sar    $0x1f,%eax
    161e:	29 c2                	sub    %eax,%edx
    1620:	8d 04 92             	lea    (%edx,%edx,4),%eax
    1623:	29 c3                	sub    %eax,%ebx
    1625:	83 fb 01             	cmp    $0x1,%ebx
    1628:	0f 85 0a 02 00 00    	jne    1838 <concreate+0x2a0>
      link("C0", file);
    162e:	83 ec 08             	sub    $0x8,%esp
    1631:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1634:	50                   	push   %eax
    1635:	68 c9 40 00 00       	push   $0x40c9
    163a:	e8 18 20 00 00       	call   3657 <link>
    163f:	83 c4 10             	add    $0x10,%esp
    1642:	eb 18                	jmp    165c <concreate+0xc4>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
    1644:	83 ec 04             	sub    $0x4,%esp
    1647:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    164a:	50                   	push   %eax
    164b:	68 cc 40 00 00       	push   $0x40cc
    1650:	6a 01                	push   $0x1
    1652:	e8 fb 20 00 00       	call   3752 <printf>
        exit();
    1657:	e8 9b 1f 00 00       	call   35f7 <exit>
      }
      close(fd);
    }
    if(pid == 0)
      exit();
    165c:	e8 96 1f 00 00       	call   35f7 <exit>
    else
      wait();
    1661:	e8 99 1f 00 00       	call   35ff <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    1666:	83 c3 01             	add    $0x1,%ebx
    1669:	83 fb 28             	cmp    $0x28,%ebx
    166c:	0f 85 53 ff ff ff    	jne    15c5 <concreate+0x2d>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    1672:	83 ec 04             	sub    $0x4,%esp
    1675:	6a 28                	push   $0x28
    1677:	6a 00                	push   $0x0
    1679:	8d 45 bd             	lea    -0x43(%ebp),%eax
    167c:	50                   	push   %eax
    167d:	e8 24 1e 00 00       	call   34a6 <memset>
  fd = open(".", 0);
    1682:	83 c4 08             	add    $0x8,%esp
    1685:	6a 00                	push   $0x0
    1687:	68 d6 42 00 00       	push   $0x42d6
    168c:	e8 a6 1f 00 00       	call   3637 <open>
    1691:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1693:	83 c4 10             	add    $0x10,%esp
      wait();
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
    1696:	bf 00 00 00 00       	mov    $0x0,%edi
  while(read(fd, &de, sizeof(de)) > 0){
    169b:	8d 75 ac             	lea    -0x54(%ebp),%esi
    169e:	eb 5e                	jmp    16fe <concreate+0x166>
    if(de.inum == 0)
    16a0:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    16a5:	74 57                	je     16fe <concreate+0x166>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    16a7:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    16ab:	75 51                	jne    16fe <concreate+0x166>
    16ad:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    16b1:	75 4b                	jne    16fe <concreate+0x166>
      i = de.name[1] - '0';
    16b3:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    16b7:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    16ba:	83 f8 27             	cmp    $0x27,%eax
    16bd:	76 18                	jbe    16d7 <concreate+0x13f>
        printf(1, "concreate weird file %s\n", de.name);
    16bf:	83 ec 04             	sub    $0x4,%esp
    16c2:	8d 45 ae             	lea    -0x52(%ebp),%eax
    16c5:	50                   	push   %eax
    16c6:	68 e8 40 00 00       	push   $0x40e8
    16cb:	6a 01                	push   $0x1
    16cd:	e8 80 20 00 00       	call   3752 <printf>
        exit();
    16d2:	e8 20 1f 00 00       	call   35f7 <exit>
      }
      if(fa[i]){
    16d7:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    16dc:	74 18                	je     16f6 <concreate+0x15e>
        printf(1, "concreate duplicate file %s\n", de.name);
    16de:	83 ec 04             	sub    $0x4,%esp
    16e1:	8d 45 ae             	lea    -0x52(%ebp),%eax
    16e4:	50                   	push   %eax
    16e5:	68 01 41 00 00       	push   $0x4101
    16ea:	6a 01                	push   $0x1
    16ec:	e8 61 20 00 00       	call   3752 <printf>
        exit();
    16f1:	e8 01 1f 00 00       	call   35f7 <exit>
      }
      fa[i] = 1;
    16f6:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    16fb:	83 c7 01             	add    $0x1,%edi
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    16fe:	83 ec 04             	sub    $0x4,%esp
    1701:	6a 10                	push   $0x10
    1703:	56                   	push   %esi
    1704:	53                   	push   %ebx
    1705:	e8 05 1f 00 00       	call   360f <read>
    170a:	83 c4 10             	add    $0x10,%esp
    170d:	85 c0                	test   %eax,%eax
    170f:	7f 8f                	jg     16a0 <concreate+0x108>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1711:	83 ec 0c             	sub    $0xc,%esp
    1714:	53                   	push   %ebx
    1715:	e8 05 1f 00 00       	call   361f <close>

  if(n != 40){
    171a:	83 c4 10             	add    $0x10,%esp
    171d:	83 ff 28             	cmp    $0x28,%edi
    1720:	74 14                	je     1736 <concreate+0x19e>
    printf(1, "concreate not enough files in directory listing\n");
    1722:	83 ec 08             	sub    $0x8,%esp
    1725:	68 68 4c 00 00       	push   $0x4c68
    172a:	6a 01                	push   $0x1
    172c:	e8 21 20 00 00       	call   3752 <printf>
    exit();
    1731:	e8 c1 1e 00 00       	call   35f7 <exit>
    1736:	bb 00 00 00 00       	mov    $0x0,%ebx
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    173b:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    file[1] = '0' + i;
    173e:	8d 43 30             	lea    0x30(%ebx),%eax
    1741:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1744:	e8 a6 1e 00 00       	call   35ef <fork>
    1749:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    174b:	85 c0                	test   %eax,%eax
    174d:	79 14                	jns    1763 <concreate+0x1cb>
      printf(1, "fork failed\n");
    174f:	83 ec 08             	sub    $0x8,%esp
    1752:	68 a1 49 00 00       	push   $0x49a1
    1757:	6a 01                	push   $0x1
    1759:	e8 f4 1f 00 00       	call   3752 <printf>
      exit();
    175e:	e8 94 1e 00 00       	call   35f7 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1763:	b8 56 55 55 55       	mov    $0x55555556,%eax
    1768:	f7 eb                	imul   %ebx
    176a:	89 d8                	mov    %ebx,%eax
    176c:	c1 f8 1f             	sar    $0x1f,%eax
    176f:	29 c2                	sub    %eax,%edx
    1771:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1774:	89 da                	mov    %ebx,%edx
    1776:	29 c2                	sub    %eax,%edx
    1778:	89 f0                	mov    %esi,%eax
    177a:	09 d0                	or     %edx,%eax
    177c:	74 09                	je     1787 <concreate+0x1ef>
       ((i % 3) == 1 && pid != 0)){
    177e:	85 f6                	test   %esi,%esi
    1780:	74 56                	je     17d8 <concreate+0x240>
    1782:	83 fa 01             	cmp    $0x1,%edx
    1785:	75 51                	jne    17d8 <concreate+0x240>
      close(open(file, 0));
    1787:	83 ec 08             	sub    $0x8,%esp
    178a:	6a 00                	push   $0x0
    178c:	57                   	push   %edi
    178d:	e8 a5 1e 00 00       	call   3637 <open>
    1792:	89 04 24             	mov    %eax,(%esp)
    1795:	e8 85 1e 00 00       	call   361f <close>
      close(open(file, 0));
    179a:	83 c4 08             	add    $0x8,%esp
    179d:	6a 00                	push   $0x0
    179f:	57                   	push   %edi
    17a0:	e8 92 1e 00 00       	call   3637 <open>
    17a5:	89 04 24             	mov    %eax,(%esp)
    17a8:	e8 72 1e 00 00       	call   361f <close>
      close(open(file, 0));
    17ad:	83 c4 08             	add    $0x8,%esp
    17b0:	6a 00                	push   $0x0
    17b2:	57                   	push   %edi
    17b3:	e8 7f 1e 00 00       	call   3637 <open>
    17b8:	89 04 24             	mov    %eax,(%esp)
    17bb:	e8 5f 1e 00 00       	call   361f <close>
      close(open(file, 0));
    17c0:	83 c4 08             	add    $0x8,%esp
    17c3:	6a 00                	push   $0x0
    17c5:	57                   	push   %edi
    17c6:	e8 6c 1e 00 00       	call   3637 <open>
    17cb:	89 04 24             	mov    %eax,(%esp)
    17ce:	e8 4c 1e 00 00       	call   361f <close>
    17d3:	83 c4 10             	add    $0x10,%esp
    17d6:	eb 24                	jmp    17fc <concreate+0x264>
    } else {
      unlink(file);
    17d8:	83 ec 0c             	sub    $0xc,%esp
    17db:	57                   	push   %edi
    17dc:	e8 66 1e 00 00       	call   3647 <unlink>
      unlink(file);
    17e1:	89 3c 24             	mov    %edi,(%esp)
    17e4:	e8 5e 1e 00 00       	call   3647 <unlink>
      unlink(file);
    17e9:	89 3c 24             	mov    %edi,(%esp)
    17ec:	e8 56 1e 00 00       	call   3647 <unlink>
      unlink(file);
    17f1:	89 3c 24             	mov    %edi,(%esp)
    17f4:	e8 4e 1e 00 00       	call   3647 <unlink>
    17f9:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    17fc:	85 f6                	test   %esi,%esi
    17fe:	75 05                	jne    1805 <concreate+0x26d>
      exit();
    1800:	e8 f2 1d 00 00       	call   35f7 <exit>
    else
      wait();
    1805:	e8 f5 1d 00 00       	call   35ff <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    180a:	83 c3 01             	add    $0x1,%ebx
    180d:	83 fb 28             	cmp    $0x28,%ebx
    1810:	0f 85 28 ff ff ff    	jne    173e <concreate+0x1a6>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1816:	83 ec 08             	sub    $0x8,%esp
    1819:	68 1e 41 00 00       	push   $0x411e
    181e:	6a 01                	push   $0x1
    1820:	e8 2d 1f 00 00       	call   3752 <printf>
}
    1825:	eb 5a                	jmp    1881 <concreate+0x2e9>
      fd = open(file, O_CREATE | O_RDWR);
      if(fd < 0){
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1827:	83 ec 0c             	sub    $0xc,%esp
    182a:	50                   	push   %eax
    182b:	e8 ef 1d 00 00       	call   361f <close>
    1830:	83 c4 10             	add    $0x10,%esp
    1833:	e9 24 fe ff ff       	jmp    165c <concreate+0xc4>
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1838:	83 ec 08             	sub    $0x8,%esp
    183b:	68 02 02 00 00       	push   $0x202
    1840:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1843:	50                   	push   %eax
    1844:	e8 ee 1d 00 00       	call   3637 <open>
      if(fd < 0){
    1849:	83 c4 10             	add    $0x10,%esp
    184c:	85 c0                	test   %eax,%eax
    184e:	0f 88 f0 fd ff ff    	js     1644 <concreate+0xac>
    1854:	eb d1                	jmp    1827 <concreate+0x28f>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1856:	83 ec 0c             	sub    $0xc,%esp
    1859:	50                   	push   %eax
    185a:	e8 c0 1d 00 00       	call   361f <close>
    185f:	83 c4 10             	add    $0x10,%esp
    1862:	e9 fa fd ff ff       	jmp    1661 <concreate+0xc9>
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1867:	83 ec 08             	sub    $0x8,%esp
    186a:	68 02 02 00 00       	push   $0x202
    186f:	56                   	push   %esi
    1870:	e8 c2 1d 00 00       	call   3637 <open>
      if(fd < 0){
    1875:	83 c4 10             	add    $0x10,%esp
    1878:	85 c0                	test   %eax,%eax
    187a:	79 da                	jns    1856 <concreate+0x2be>
    187c:	e9 c3 fd ff ff       	jmp    1644 <concreate+0xac>
    else
      wait();
  }

  printf(1, "concreate ok\n");
}
    1881:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1884:	5b                   	pop    %ebx
    1885:	5e                   	pop    %esi
    1886:	5f                   	pop    %edi
    1887:	5d                   	pop    %ebp
    1888:	c3                   	ret    

00001889 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1889:	55                   	push   %ebp
    188a:	89 e5                	mov    %esp,%ebp
    188c:	57                   	push   %edi
    188d:	56                   	push   %esi
    188e:	53                   	push   %ebx
    188f:	83 ec 24             	sub    $0x24,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1892:	68 2c 41 00 00       	push   $0x412c
    1897:	6a 01                	push   $0x1
    1899:	e8 b4 1e 00 00       	call   3752 <printf>

  unlink("x");
    189e:	c7 04 24 b9 43 00 00 	movl   $0x43b9,(%esp)
    18a5:	e8 9d 1d 00 00       	call   3647 <unlink>
  pid = fork();
    18aa:	e8 40 1d 00 00       	call   35ef <fork>
    18af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    18b2:	83 c4 10             	add    $0x10,%esp
    18b5:	85 c0                	test   %eax,%eax
    18b7:	79 14                	jns    18cd <linkunlink+0x44>
    printf(1, "fork failed\n");
    18b9:	83 ec 08             	sub    $0x8,%esp
    18bc:	68 a1 49 00 00       	push   $0x49a1
    18c1:	6a 01                	push   $0x1
    18c3:	e8 8a 1e 00 00       	call   3752 <printf>
    exit();
    18c8:	e8 2a 1d 00 00       	call   35f7 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    18cd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    18d1:	19 db                	sbb    %ebx,%ebx
    18d3:	83 e3 60             	and    $0x60,%ebx
    18d6:	83 c3 01             	add    $0x1,%ebx
    18d9:	be 64 00 00 00       	mov    $0x64,%esi
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
    18de:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    18e3:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    18e9:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    18ef:	89 d8                	mov    %ebx,%eax
    18f1:	f7 e7                	mul    %edi
    18f3:	d1 ea                	shr    %edx
    18f5:	8d 04 52             	lea    (%edx,%edx,2),%eax
    18f8:	89 da                	mov    %ebx,%edx
    18fa:	29 c2                	sub    %eax,%edx
    18fc:	75 1f                	jne    191d <linkunlink+0x94>
      close(open("x", O_RDWR | O_CREATE));
    18fe:	83 ec 08             	sub    $0x8,%esp
    1901:	68 02 02 00 00       	push   $0x202
    1906:	68 b9 43 00 00       	push   $0x43b9
    190b:	e8 27 1d 00 00       	call   3637 <open>
    1910:	89 04 24             	mov    %eax,(%esp)
    1913:	e8 07 1d 00 00       	call   361f <close>
    1918:	83 c4 10             	add    $0x10,%esp
    191b:	eb 2c                	jmp    1949 <linkunlink+0xc0>
    } else if((x % 3) == 1){
    191d:	83 fa 01             	cmp    $0x1,%edx
    1920:	75 17                	jne    1939 <linkunlink+0xb0>
      link("cat", "x");
    1922:	83 ec 08             	sub    $0x8,%esp
    1925:	68 b9 43 00 00       	push   $0x43b9
    192a:	68 3d 41 00 00       	push   $0x413d
    192f:	e8 23 1d 00 00       	call   3657 <link>
    1934:	83 c4 10             	add    $0x10,%esp
    1937:	eb 10                	jmp    1949 <linkunlink+0xc0>
    } else {
      unlink("x");
    1939:	83 ec 0c             	sub    $0xc,%esp
    193c:	68 b9 43 00 00       	push   $0x43b9
    1941:	e8 01 1d 00 00       	call   3647 <unlink>
    1946:	83 c4 10             	add    $0x10,%esp
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1949:	83 ee 01             	sub    $0x1,%esi
    194c:	75 95                	jne    18e3 <linkunlink+0x5a>
    } else {
      unlink("x");
    }
  }

  if(pid)
    194e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1952:	74 16                	je     196a <linkunlink+0xe1>
    wait();
    1954:	e8 a6 1c 00 00       	call   35ff <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    1959:	83 ec 08             	sub    $0x8,%esp
    195c:	68 41 41 00 00       	push   $0x4141
    1961:	6a 01                	push   $0x1
    1963:	e8 ea 1d 00 00       	call   3752 <printf>
}
    1968:	eb 05                	jmp    196f <linkunlink+0xe6>
  }

  if(pid)
    wait();
  else
    exit();
    196a:	e8 88 1c 00 00       	call   35f7 <exit>

  printf(1, "linkunlink ok\n");
}
    196f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1972:	5b                   	pop    %ebx
    1973:	5e                   	pop    %esi
    1974:	5f                   	pop    %edi
    1975:	5d                   	pop    %ebp
    1976:	c3                   	ret    

00001977 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1977:	55                   	push   %ebp
    1978:	89 e5                	mov    %esp,%ebp
    197a:	56                   	push   %esi
    197b:	53                   	push   %ebx
    197c:	83 ec 18             	sub    $0x18,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    197f:	68 50 41 00 00       	push   $0x4150
    1984:	6a 01                	push   $0x1
    1986:	e8 c7 1d 00 00       	call   3752 <printf>
  unlink("bd");
    198b:	c7 04 24 5d 41 00 00 	movl   $0x415d,(%esp)
    1992:	e8 b0 1c 00 00       	call   3647 <unlink>

  fd = open("bd", O_CREATE);
    1997:	83 c4 08             	add    $0x8,%esp
    199a:	68 00 02 00 00       	push   $0x200
    199f:	68 5d 41 00 00       	push   $0x415d
    19a4:	e8 8e 1c 00 00       	call   3637 <open>
  if(fd < 0){
    19a9:	83 c4 10             	add    $0x10,%esp
    19ac:	85 c0                	test   %eax,%eax
    19ae:	79 14                	jns    19c4 <bigdir+0x4d>
    printf(1, "bigdir create failed\n");
    19b0:	83 ec 08             	sub    $0x8,%esp
    19b3:	68 60 41 00 00       	push   $0x4160
    19b8:	6a 01                	push   $0x1
    19ba:	e8 93 1d 00 00       	call   3752 <printf>
    exit();
    19bf:	e8 33 1c 00 00       	call   35f7 <exit>
  }
  close(fd);
    19c4:	83 ec 0c             	sub    $0xc,%esp
    19c7:	50                   	push   %eax
    19c8:	e8 52 1c 00 00       	call   361f <close>
    19cd:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 500; i++){
    19d0:	bb 00 00 00 00       	mov    $0x0,%ebx
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(link("bd", name) != 0){
    19d5:	8d 75 ee             	lea    -0x12(%ebp),%esi
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    name[0] = 'x';
    19d8:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    19dc:	8d 43 3f             	lea    0x3f(%ebx),%eax
    19df:	85 db                	test   %ebx,%ebx
    19e1:	0f 49 c3             	cmovns %ebx,%eax
    19e4:	c1 f8 06             	sar    $0x6,%eax
    19e7:	83 c0 30             	add    $0x30,%eax
    19ea:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    19ed:	89 da                	mov    %ebx,%edx
    19ef:	c1 fa 1f             	sar    $0x1f,%edx
    19f2:	c1 ea 1a             	shr    $0x1a,%edx
    19f5:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    19f8:	83 e0 3f             	and    $0x3f,%eax
    19fb:	29 d0                	sub    %edx,%eax
    19fd:	83 c0 30             	add    $0x30,%eax
    1a00:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1a03:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1a07:	83 ec 08             	sub    $0x8,%esp
    1a0a:	56                   	push   %esi
    1a0b:	68 5d 41 00 00       	push   $0x415d
    1a10:	e8 42 1c 00 00       	call   3657 <link>
    1a15:	83 c4 10             	add    $0x10,%esp
    1a18:	85 c0                	test   %eax,%eax
    1a1a:	74 14                	je     1a30 <bigdir+0xb9>
      printf(1, "bigdir link failed\n");
    1a1c:	83 ec 08             	sub    $0x8,%esp
    1a1f:	68 76 41 00 00       	push   $0x4176
    1a24:	6a 01                	push   $0x1
    1a26:	e8 27 1d 00 00       	call   3752 <printf>
      exit();
    1a2b:	e8 c7 1b 00 00       	call   35f7 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1a30:	83 c3 01             	add    $0x1,%ebx
    1a33:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1a39:	75 9d                	jne    19d8 <bigdir+0x61>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1a3b:	83 ec 0c             	sub    $0xc,%esp
    1a3e:	68 5d 41 00 00       	push   $0x415d
    1a43:	e8 ff 1b 00 00       	call   3647 <unlink>
    1a48:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 500; i++){
    1a4b:	bb 00 00 00 00       	mov    $0x0,%ebx
    name[0] = 'x';
    name[1] = '0' + (i / 64);
    name[2] = '0' + (i % 64);
    name[3] = '\0';
    if(unlink(name) != 0){
    1a50:	8d 75 ee             	lea    -0x12(%ebp),%esi
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    name[0] = 'x';
    1a53:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1a57:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1a5a:	85 db                	test   %ebx,%ebx
    1a5c:	0f 49 c3             	cmovns %ebx,%eax
    1a5f:	c1 f8 06             	sar    $0x6,%eax
    1a62:	83 c0 30             	add    $0x30,%eax
    1a65:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1a68:	89 da                	mov    %ebx,%edx
    1a6a:	c1 fa 1f             	sar    $0x1f,%edx
    1a6d:	c1 ea 1a             	shr    $0x1a,%edx
    1a70:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1a73:	83 e0 3f             	and    $0x3f,%eax
    1a76:	29 d0                	sub    %edx,%eax
    1a78:	83 c0 30             	add    $0x30,%eax
    1a7b:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1a7e:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1a82:	83 ec 0c             	sub    $0xc,%esp
    1a85:	56                   	push   %esi
    1a86:	e8 bc 1b 00 00       	call   3647 <unlink>
    1a8b:	83 c4 10             	add    $0x10,%esp
    1a8e:	85 c0                	test   %eax,%eax
    1a90:	74 14                	je     1aa6 <bigdir+0x12f>
      printf(1, "bigdir unlink failed");
    1a92:	83 ec 08             	sub    $0x8,%esp
    1a95:	68 8a 41 00 00       	push   $0x418a
    1a9a:	6a 01                	push   $0x1
    1a9c:	e8 b1 1c 00 00       	call   3752 <printf>
      exit();
    1aa1:	e8 51 1b 00 00       	call   35f7 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1aa6:	83 c3 01             	add    $0x1,%ebx
    1aa9:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1aaf:	75 a2                	jne    1a53 <bigdir+0xdc>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1ab1:	83 ec 08             	sub    $0x8,%esp
    1ab4:	68 9f 41 00 00       	push   $0x419f
    1ab9:	6a 01                	push   $0x1
    1abb:	e8 92 1c 00 00       	call   3752 <printf>
}
    1ac0:	83 c4 10             	add    $0x10,%esp
    1ac3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1ac6:	5b                   	pop    %ebx
    1ac7:	5e                   	pop    %esi
    1ac8:	5d                   	pop    %ebp
    1ac9:	c3                   	ret    

00001aca <subdir>:

void
subdir(void)
{
    1aca:	55                   	push   %ebp
    1acb:	89 e5                	mov    %esp,%ebp
    1acd:	53                   	push   %ebx
    1ace:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1ad1:	68 aa 41 00 00       	push   $0x41aa
    1ad6:	6a 01                	push   $0x1
    1ad8:	e8 75 1c 00 00       	call   3752 <printf>

  unlink("ff");
    1add:	c7 04 24 33 42 00 00 	movl   $0x4233,(%esp)
    1ae4:	e8 5e 1b 00 00       	call   3647 <unlink>
  if(mkdir("dd") != 0){
    1ae9:	c7 04 24 d0 42 00 00 	movl   $0x42d0,(%esp)
    1af0:	e8 6a 1b 00 00       	call   365f <mkdir>
    1af5:	83 c4 10             	add    $0x10,%esp
    1af8:	85 c0                	test   %eax,%eax
    1afa:	74 14                	je     1b10 <subdir+0x46>
    printf(1, "subdir mkdir dd failed\n");
    1afc:	83 ec 08             	sub    $0x8,%esp
    1aff:	68 b7 41 00 00       	push   $0x41b7
    1b04:	6a 01                	push   $0x1
    1b06:	e8 47 1c 00 00       	call   3752 <printf>
    exit();
    1b0b:	e8 e7 1a 00 00       	call   35f7 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b10:	83 ec 08             	sub    $0x8,%esp
    1b13:	68 02 02 00 00       	push   $0x202
    1b18:	68 09 42 00 00       	push   $0x4209
    1b1d:	e8 15 1b 00 00       	call   3637 <open>
    1b22:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b24:	83 c4 10             	add    $0x10,%esp
    1b27:	85 c0                	test   %eax,%eax
    1b29:	79 14                	jns    1b3f <subdir+0x75>
    printf(1, "create dd/ff failed\n");
    1b2b:	83 ec 08             	sub    $0x8,%esp
    1b2e:	68 cf 41 00 00       	push   $0x41cf
    1b33:	6a 01                	push   $0x1
    1b35:	e8 18 1c 00 00       	call   3752 <printf>
    exit();
    1b3a:	e8 b8 1a 00 00       	call   35f7 <exit>
  }
  write(fd, "ff", 2);
    1b3f:	83 ec 04             	sub    $0x4,%esp
    1b42:	6a 02                	push   $0x2
    1b44:	68 33 42 00 00       	push   $0x4233
    1b49:	50                   	push   %eax
    1b4a:	e8 c8 1a 00 00       	call   3617 <write>
  close(fd);
    1b4f:	89 1c 24             	mov    %ebx,(%esp)
    1b52:	e8 c8 1a 00 00       	call   361f <close>

  if(unlink("dd") >= 0){
    1b57:	c7 04 24 d0 42 00 00 	movl   $0x42d0,(%esp)
    1b5e:	e8 e4 1a 00 00       	call   3647 <unlink>
    1b63:	83 c4 10             	add    $0x10,%esp
    1b66:	85 c0                	test   %eax,%eax
    1b68:	78 14                	js     1b7e <subdir+0xb4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1b6a:	83 ec 08             	sub    $0x8,%esp
    1b6d:	68 9c 4c 00 00       	push   $0x4c9c
    1b72:	6a 01                	push   $0x1
    1b74:	e8 d9 1b 00 00       	call   3752 <printf>
    exit();
    1b79:	e8 79 1a 00 00       	call   35f7 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1b7e:	83 ec 0c             	sub    $0xc,%esp
    1b81:	68 e4 41 00 00       	push   $0x41e4
    1b86:	e8 d4 1a 00 00       	call   365f <mkdir>
    1b8b:	83 c4 10             	add    $0x10,%esp
    1b8e:	85 c0                	test   %eax,%eax
    1b90:	74 14                	je     1ba6 <subdir+0xdc>
    printf(1, "subdir mkdir dd/dd failed\n");
    1b92:	83 ec 08             	sub    $0x8,%esp
    1b95:	68 eb 41 00 00       	push   $0x41eb
    1b9a:	6a 01                	push   $0x1
    1b9c:	e8 b1 1b 00 00       	call   3752 <printf>
    exit();
    1ba1:	e8 51 1a 00 00       	call   35f7 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1ba6:	83 ec 08             	sub    $0x8,%esp
    1ba9:	68 02 02 00 00       	push   $0x202
    1bae:	68 06 42 00 00       	push   $0x4206
    1bb3:	e8 7f 1a 00 00       	call   3637 <open>
    1bb8:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bba:	83 c4 10             	add    $0x10,%esp
    1bbd:	85 c0                	test   %eax,%eax
    1bbf:	79 14                	jns    1bd5 <subdir+0x10b>
    printf(1, "create dd/dd/ff failed\n");
    1bc1:	83 ec 08             	sub    $0x8,%esp
    1bc4:	68 0f 42 00 00       	push   $0x420f
    1bc9:	6a 01                	push   $0x1
    1bcb:	e8 82 1b 00 00       	call   3752 <printf>
    exit();
    1bd0:	e8 22 1a 00 00       	call   35f7 <exit>
  }
  write(fd, "FF", 2);
    1bd5:	83 ec 04             	sub    $0x4,%esp
    1bd8:	6a 02                	push   $0x2
    1bda:	68 27 42 00 00       	push   $0x4227
    1bdf:	50                   	push   %eax
    1be0:	e8 32 1a 00 00       	call   3617 <write>
  close(fd);
    1be5:	89 1c 24             	mov    %ebx,(%esp)
    1be8:	e8 32 1a 00 00       	call   361f <close>

  fd = open("dd/dd/../ff", 0);
    1bed:	83 c4 08             	add    $0x8,%esp
    1bf0:	6a 00                	push   $0x0
    1bf2:	68 2a 42 00 00       	push   $0x422a
    1bf7:	e8 3b 1a 00 00       	call   3637 <open>
    1bfc:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bfe:	83 c4 10             	add    $0x10,%esp
    1c01:	85 c0                	test   %eax,%eax
    1c03:	79 14                	jns    1c19 <subdir+0x14f>
    printf(1, "open dd/dd/../ff failed\n");
    1c05:	83 ec 08             	sub    $0x8,%esp
    1c08:	68 36 42 00 00       	push   $0x4236
    1c0d:	6a 01                	push   $0x1
    1c0f:	e8 3e 1b 00 00       	call   3752 <printf>
    exit();
    1c14:	e8 de 19 00 00       	call   35f7 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    1c19:	83 ec 04             	sub    $0x4,%esp
    1c1c:	68 00 20 00 00       	push   $0x2000
    1c21:	68 00 82 00 00       	push   $0x8200
    1c26:	50                   	push   %eax
    1c27:	e8 e3 19 00 00       	call   360f <read>
  if(cc != 2 || buf[0] != 'f'){
    1c2c:	83 c4 10             	add    $0x10,%esp
    1c2f:	83 f8 02             	cmp    $0x2,%eax
    1c32:	75 09                	jne    1c3d <subdir+0x173>
    1c34:	80 3d 00 82 00 00 66 	cmpb   $0x66,0x8200
    1c3b:	74 14                	je     1c51 <subdir+0x187>
    printf(1, "dd/dd/../ff wrong content\n");
    1c3d:	83 ec 08             	sub    $0x8,%esp
    1c40:	68 4f 42 00 00       	push   $0x424f
    1c45:	6a 01                	push   $0x1
    1c47:	e8 06 1b 00 00       	call   3752 <printf>
    exit();
    1c4c:	e8 a6 19 00 00       	call   35f7 <exit>
  }
  close(fd);
    1c51:	83 ec 0c             	sub    $0xc,%esp
    1c54:	53                   	push   %ebx
    1c55:	e8 c5 19 00 00       	call   361f <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c5a:	83 c4 08             	add    $0x8,%esp
    1c5d:	68 6a 42 00 00       	push   $0x426a
    1c62:	68 06 42 00 00       	push   $0x4206
    1c67:	e8 eb 19 00 00       	call   3657 <link>
    1c6c:	83 c4 10             	add    $0x10,%esp
    1c6f:	85 c0                	test   %eax,%eax
    1c71:	74 14                	je     1c87 <subdir+0x1bd>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1c73:	83 ec 08             	sub    $0x8,%esp
    1c76:	68 c4 4c 00 00       	push   $0x4cc4
    1c7b:	6a 01                	push   $0x1
    1c7d:	e8 d0 1a 00 00       	call   3752 <printf>
    exit();
    1c82:	e8 70 19 00 00       	call   35f7 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    1c87:	83 ec 0c             	sub    $0xc,%esp
    1c8a:	68 06 42 00 00       	push   $0x4206
    1c8f:	e8 b3 19 00 00       	call   3647 <unlink>
    1c94:	83 c4 10             	add    $0x10,%esp
    1c97:	85 c0                	test   %eax,%eax
    1c99:	74 14                	je     1caf <subdir+0x1e5>
    printf(1, "unlink dd/dd/ff failed\n");
    1c9b:	83 ec 08             	sub    $0x8,%esp
    1c9e:	68 75 42 00 00       	push   $0x4275
    1ca3:	6a 01                	push   $0x1
    1ca5:	e8 a8 1a 00 00       	call   3752 <printf>
    exit();
    1caa:	e8 48 19 00 00       	call   35f7 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1caf:	83 ec 08             	sub    $0x8,%esp
    1cb2:	6a 00                	push   $0x0
    1cb4:	68 06 42 00 00       	push   $0x4206
    1cb9:	e8 79 19 00 00       	call   3637 <open>
    1cbe:	83 c4 10             	add    $0x10,%esp
    1cc1:	85 c0                	test   %eax,%eax
    1cc3:	78 14                	js     1cd9 <subdir+0x20f>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1cc5:	83 ec 08             	sub    $0x8,%esp
    1cc8:	68 e8 4c 00 00       	push   $0x4ce8
    1ccd:	6a 01                	push   $0x1
    1ccf:	e8 7e 1a 00 00       	call   3752 <printf>
    exit();
    1cd4:	e8 1e 19 00 00       	call   35f7 <exit>
  }

  if(chdir("dd") != 0){
    1cd9:	83 ec 0c             	sub    $0xc,%esp
    1cdc:	68 d0 42 00 00       	push   $0x42d0
    1ce1:	e8 81 19 00 00       	call   3667 <chdir>
    1ce6:	83 c4 10             	add    $0x10,%esp
    1ce9:	85 c0                	test   %eax,%eax
    1ceb:	74 14                	je     1d01 <subdir+0x237>
    printf(1, "chdir dd failed\n");
    1ced:	83 ec 08             	sub    $0x8,%esp
    1cf0:	68 8d 42 00 00       	push   $0x428d
    1cf5:	6a 01                	push   $0x1
    1cf7:	e8 56 1a 00 00       	call   3752 <printf>
    exit();
    1cfc:	e8 f6 18 00 00       	call   35f7 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    1d01:	83 ec 0c             	sub    $0xc,%esp
    1d04:	68 9e 42 00 00       	push   $0x429e
    1d09:	e8 59 19 00 00       	call   3667 <chdir>
    1d0e:	83 c4 10             	add    $0x10,%esp
    1d11:	85 c0                	test   %eax,%eax
    1d13:	74 14                	je     1d29 <subdir+0x25f>
    printf(1, "chdir dd/../../dd failed\n");
    1d15:	83 ec 08             	sub    $0x8,%esp
    1d18:	68 aa 42 00 00       	push   $0x42aa
    1d1d:	6a 01                	push   $0x1
    1d1f:	e8 2e 1a 00 00       	call   3752 <printf>
    exit();
    1d24:	e8 ce 18 00 00       	call   35f7 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    1d29:	83 ec 0c             	sub    $0xc,%esp
    1d2c:	68 c4 42 00 00       	push   $0x42c4
    1d31:	e8 31 19 00 00       	call   3667 <chdir>
    1d36:	83 c4 10             	add    $0x10,%esp
    1d39:	85 c0                	test   %eax,%eax
    1d3b:	74 14                	je     1d51 <subdir+0x287>
    printf(1, "chdir dd/../../dd failed\n");
    1d3d:	83 ec 08             	sub    $0x8,%esp
    1d40:	68 aa 42 00 00       	push   $0x42aa
    1d45:	6a 01                	push   $0x1
    1d47:	e8 06 1a 00 00       	call   3752 <printf>
    exit();
    1d4c:	e8 a6 18 00 00       	call   35f7 <exit>
  }
  if(chdir("./..") != 0){
    1d51:	83 ec 0c             	sub    $0xc,%esp
    1d54:	68 d3 42 00 00       	push   $0x42d3
    1d59:	e8 09 19 00 00       	call   3667 <chdir>
    1d5e:	83 c4 10             	add    $0x10,%esp
    1d61:	85 c0                	test   %eax,%eax
    1d63:	74 14                	je     1d79 <subdir+0x2af>
    printf(1, "chdir ./.. failed\n");
    1d65:	83 ec 08             	sub    $0x8,%esp
    1d68:	68 d8 42 00 00       	push   $0x42d8
    1d6d:	6a 01                	push   $0x1
    1d6f:	e8 de 19 00 00       	call   3752 <printf>
    exit();
    1d74:	e8 7e 18 00 00       	call   35f7 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    1d79:	83 ec 08             	sub    $0x8,%esp
    1d7c:	6a 00                	push   $0x0
    1d7e:	68 6a 42 00 00       	push   $0x426a
    1d83:	e8 af 18 00 00       	call   3637 <open>
    1d88:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d8a:	83 c4 10             	add    $0x10,%esp
    1d8d:	85 c0                	test   %eax,%eax
    1d8f:	79 14                	jns    1da5 <subdir+0x2db>
    printf(1, "open dd/dd/ffff failed\n");
    1d91:	83 ec 08             	sub    $0x8,%esp
    1d94:	68 eb 42 00 00       	push   $0x42eb
    1d99:	6a 01                	push   $0x1
    1d9b:	e8 b2 19 00 00       	call   3752 <printf>
    exit();
    1da0:	e8 52 18 00 00       	call   35f7 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1da5:	83 ec 04             	sub    $0x4,%esp
    1da8:	68 00 20 00 00       	push   $0x2000
    1dad:	68 00 82 00 00       	push   $0x8200
    1db2:	50                   	push   %eax
    1db3:	e8 57 18 00 00       	call   360f <read>
    1db8:	83 c4 10             	add    $0x10,%esp
    1dbb:	83 f8 02             	cmp    $0x2,%eax
    1dbe:	74 14                	je     1dd4 <subdir+0x30a>
    printf(1, "read dd/dd/ffff wrong len\n");
    1dc0:	83 ec 08             	sub    $0x8,%esp
    1dc3:	68 03 43 00 00       	push   $0x4303
    1dc8:	6a 01                	push   $0x1
    1dca:	e8 83 19 00 00       	call   3752 <printf>
    exit();
    1dcf:	e8 23 18 00 00       	call   35f7 <exit>
  }
  close(fd);
    1dd4:	83 ec 0c             	sub    $0xc,%esp
    1dd7:	53                   	push   %ebx
    1dd8:	e8 42 18 00 00       	call   361f <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ddd:	83 c4 08             	add    $0x8,%esp
    1de0:	6a 00                	push   $0x0
    1de2:	68 06 42 00 00       	push   $0x4206
    1de7:	e8 4b 18 00 00       	call   3637 <open>
    1dec:	83 c4 10             	add    $0x10,%esp
    1def:	85 c0                	test   %eax,%eax
    1df1:	78 14                	js     1e07 <subdir+0x33d>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    1df3:	83 ec 08             	sub    $0x8,%esp
    1df6:	68 0c 4d 00 00       	push   $0x4d0c
    1dfb:	6a 01                	push   $0x1
    1dfd:	e8 50 19 00 00       	call   3752 <printf>
    exit();
    1e02:	e8 f0 17 00 00       	call   35f7 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1e07:	83 ec 08             	sub    $0x8,%esp
    1e0a:	68 02 02 00 00       	push   $0x202
    1e0f:	68 1e 43 00 00       	push   $0x431e
    1e14:	e8 1e 18 00 00       	call   3637 <open>
    1e19:	83 c4 10             	add    $0x10,%esp
    1e1c:	85 c0                	test   %eax,%eax
    1e1e:	78 14                	js     1e34 <subdir+0x36a>
    printf(1, "create dd/ff/ff succeeded!\n");
    1e20:	83 ec 08             	sub    $0x8,%esp
    1e23:	68 27 43 00 00       	push   $0x4327
    1e28:	6a 01                	push   $0x1
    1e2a:	e8 23 19 00 00       	call   3752 <printf>
    exit();
    1e2f:	e8 c3 17 00 00       	call   35f7 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1e34:	83 ec 08             	sub    $0x8,%esp
    1e37:	68 02 02 00 00       	push   $0x202
    1e3c:	68 43 43 00 00       	push   $0x4343
    1e41:	e8 f1 17 00 00       	call   3637 <open>
    1e46:	83 c4 10             	add    $0x10,%esp
    1e49:	85 c0                	test   %eax,%eax
    1e4b:	78 14                	js     1e61 <subdir+0x397>
    printf(1, "create dd/xx/ff succeeded!\n");
    1e4d:	83 ec 08             	sub    $0x8,%esp
    1e50:	68 4c 43 00 00       	push   $0x434c
    1e55:	6a 01                	push   $0x1
    1e57:	e8 f6 18 00 00       	call   3752 <printf>
    exit();
    1e5c:	e8 96 17 00 00       	call   35f7 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    1e61:	83 ec 08             	sub    $0x8,%esp
    1e64:	68 00 02 00 00       	push   $0x200
    1e69:	68 d0 42 00 00       	push   $0x42d0
    1e6e:	e8 c4 17 00 00       	call   3637 <open>
    1e73:	83 c4 10             	add    $0x10,%esp
    1e76:	85 c0                	test   %eax,%eax
    1e78:	78 14                	js     1e8e <subdir+0x3c4>
    printf(1, "create dd succeeded!\n");
    1e7a:	83 ec 08             	sub    $0x8,%esp
    1e7d:	68 68 43 00 00       	push   $0x4368
    1e82:	6a 01                	push   $0x1
    1e84:	e8 c9 18 00 00       	call   3752 <printf>
    exit();
    1e89:	e8 69 17 00 00       	call   35f7 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    1e8e:	83 ec 08             	sub    $0x8,%esp
    1e91:	6a 02                	push   $0x2
    1e93:	68 d0 42 00 00       	push   $0x42d0
    1e98:	e8 9a 17 00 00       	call   3637 <open>
    1e9d:	83 c4 10             	add    $0x10,%esp
    1ea0:	85 c0                	test   %eax,%eax
    1ea2:	78 14                	js     1eb8 <subdir+0x3ee>
    printf(1, "open dd rdwr succeeded!\n");
    1ea4:	83 ec 08             	sub    $0x8,%esp
    1ea7:	68 7e 43 00 00       	push   $0x437e
    1eac:	6a 01                	push   $0x1
    1eae:	e8 9f 18 00 00       	call   3752 <printf>
    exit();
    1eb3:	e8 3f 17 00 00       	call   35f7 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    1eb8:	83 ec 08             	sub    $0x8,%esp
    1ebb:	6a 01                	push   $0x1
    1ebd:	68 d0 42 00 00       	push   $0x42d0
    1ec2:	e8 70 17 00 00       	call   3637 <open>
    1ec7:	83 c4 10             	add    $0x10,%esp
    1eca:	85 c0                	test   %eax,%eax
    1ecc:	78 14                	js     1ee2 <subdir+0x418>
    printf(1, "open dd wronly succeeded!\n");
    1ece:	83 ec 08             	sub    $0x8,%esp
    1ed1:	68 97 43 00 00       	push   $0x4397
    1ed6:	6a 01                	push   $0x1
    1ed8:	e8 75 18 00 00       	call   3752 <printf>
    exit();
    1edd:	e8 15 17 00 00       	call   35f7 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1ee2:	83 ec 08             	sub    $0x8,%esp
    1ee5:	68 b2 43 00 00       	push   $0x43b2
    1eea:	68 1e 43 00 00       	push   $0x431e
    1eef:	e8 63 17 00 00       	call   3657 <link>
    1ef4:	83 c4 10             	add    $0x10,%esp
    1ef7:	85 c0                	test   %eax,%eax
    1ef9:	75 14                	jne    1f0f <subdir+0x445>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    1efb:	83 ec 08             	sub    $0x8,%esp
    1efe:	68 34 4d 00 00       	push   $0x4d34
    1f03:	6a 01                	push   $0x1
    1f05:	e8 48 18 00 00       	call   3752 <printf>
    exit();
    1f0a:	e8 e8 16 00 00       	call   35f7 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1f0f:	83 ec 08             	sub    $0x8,%esp
    1f12:	68 b2 43 00 00       	push   $0x43b2
    1f17:	68 43 43 00 00       	push   $0x4343
    1f1c:	e8 36 17 00 00       	call   3657 <link>
    1f21:	83 c4 10             	add    $0x10,%esp
    1f24:	85 c0                	test   %eax,%eax
    1f26:	75 14                	jne    1f3c <subdir+0x472>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    1f28:	83 ec 08             	sub    $0x8,%esp
    1f2b:	68 58 4d 00 00       	push   $0x4d58
    1f30:	6a 01                	push   $0x1
    1f32:	e8 1b 18 00 00       	call   3752 <printf>
    exit();
    1f37:	e8 bb 16 00 00       	call   35f7 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1f3c:	83 ec 08             	sub    $0x8,%esp
    1f3f:	68 6a 42 00 00       	push   $0x426a
    1f44:	68 09 42 00 00       	push   $0x4209
    1f49:	e8 09 17 00 00       	call   3657 <link>
    1f4e:	83 c4 10             	add    $0x10,%esp
    1f51:	85 c0                	test   %eax,%eax
    1f53:	75 14                	jne    1f69 <subdir+0x49f>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    1f55:	83 ec 08             	sub    $0x8,%esp
    1f58:	68 7c 4d 00 00       	push   $0x4d7c
    1f5d:	6a 01                	push   $0x1
    1f5f:	e8 ee 17 00 00       	call   3752 <printf>
    exit();
    1f64:	e8 8e 16 00 00       	call   35f7 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    1f69:	83 ec 0c             	sub    $0xc,%esp
    1f6c:	68 1e 43 00 00       	push   $0x431e
    1f71:	e8 e9 16 00 00       	call   365f <mkdir>
    1f76:	83 c4 10             	add    $0x10,%esp
    1f79:	85 c0                	test   %eax,%eax
    1f7b:	75 14                	jne    1f91 <subdir+0x4c7>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    1f7d:	83 ec 08             	sub    $0x8,%esp
    1f80:	68 bb 43 00 00       	push   $0x43bb
    1f85:	6a 01                	push   $0x1
    1f87:	e8 c6 17 00 00       	call   3752 <printf>
    exit();
    1f8c:	e8 66 16 00 00       	call   35f7 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    1f91:	83 ec 0c             	sub    $0xc,%esp
    1f94:	68 43 43 00 00       	push   $0x4343
    1f99:	e8 c1 16 00 00       	call   365f <mkdir>
    1f9e:	83 c4 10             	add    $0x10,%esp
    1fa1:	85 c0                	test   %eax,%eax
    1fa3:	75 14                	jne    1fb9 <subdir+0x4ef>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    1fa5:	83 ec 08             	sub    $0x8,%esp
    1fa8:	68 d6 43 00 00       	push   $0x43d6
    1fad:	6a 01                	push   $0x1
    1faf:	e8 9e 17 00 00       	call   3752 <printf>
    exit();
    1fb4:	e8 3e 16 00 00       	call   35f7 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    1fb9:	83 ec 0c             	sub    $0xc,%esp
    1fbc:	68 6a 42 00 00       	push   $0x426a
    1fc1:	e8 99 16 00 00       	call   365f <mkdir>
    1fc6:	83 c4 10             	add    $0x10,%esp
    1fc9:	85 c0                	test   %eax,%eax
    1fcb:	75 14                	jne    1fe1 <subdir+0x517>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    1fcd:	83 ec 08             	sub    $0x8,%esp
    1fd0:	68 f1 43 00 00       	push   $0x43f1
    1fd5:	6a 01                	push   $0x1
    1fd7:	e8 76 17 00 00       	call   3752 <printf>
    exit();
    1fdc:	e8 16 16 00 00       	call   35f7 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    1fe1:	83 ec 0c             	sub    $0xc,%esp
    1fe4:	68 43 43 00 00       	push   $0x4343
    1fe9:	e8 59 16 00 00       	call   3647 <unlink>
    1fee:	83 c4 10             	add    $0x10,%esp
    1ff1:	85 c0                	test   %eax,%eax
    1ff3:	75 14                	jne    2009 <subdir+0x53f>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    1ff5:	83 ec 08             	sub    $0x8,%esp
    1ff8:	68 0e 44 00 00       	push   $0x440e
    1ffd:	6a 01                	push   $0x1
    1fff:	e8 4e 17 00 00       	call   3752 <printf>
    exit();
    2004:	e8 ee 15 00 00       	call   35f7 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2009:	83 ec 0c             	sub    $0xc,%esp
    200c:	68 1e 43 00 00       	push   $0x431e
    2011:	e8 31 16 00 00       	call   3647 <unlink>
    2016:	83 c4 10             	add    $0x10,%esp
    2019:	85 c0                	test   %eax,%eax
    201b:	75 14                	jne    2031 <subdir+0x567>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    201d:	83 ec 08             	sub    $0x8,%esp
    2020:	68 2a 44 00 00       	push   $0x442a
    2025:	6a 01                	push   $0x1
    2027:	e8 26 17 00 00       	call   3752 <printf>
    exit();
    202c:	e8 c6 15 00 00       	call   35f7 <exit>
  }
  if(chdir("dd/ff") == 0){
    2031:	83 ec 0c             	sub    $0xc,%esp
    2034:	68 09 42 00 00       	push   $0x4209
    2039:	e8 29 16 00 00       	call   3667 <chdir>
    203e:	83 c4 10             	add    $0x10,%esp
    2041:	85 c0                	test   %eax,%eax
    2043:	75 14                	jne    2059 <subdir+0x58f>
    printf(1, "chdir dd/ff succeeded!\n");
    2045:	83 ec 08             	sub    $0x8,%esp
    2048:	68 46 44 00 00       	push   $0x4446
    204d:	6a 01                	push   $0x1
    204f:	e8 fe 16 00 00       	call   3752 <printf>
    exit();
    2054:	e8 9e 15 00 00       	call   35f7 <exit>
  }
  if(chdir("dd/xx") == 0){
    2059:	83 ec 0c             	sub    $0xc,%esp
    205c:	68 b5 43 00 00       	push   $0x43b5
    2061:	e8 01 16 00 00       	call   3667 <chdir>
    2066:	83 c4 10             	add    $0x10,%esp
    2069:	85 c0                	test   %eax,%eax
    206b:	75 14                	jne    2081 <subdir+0x5b7>
    printf(1, "chdir dd/xx succeeded!\n");
    206d:	83 ec 08             	sub    $0x8,%esp
    2070:	68 5e 44 00 00       	push   $0x445e
    2075:	6a 01                	push   $0x1
    2077:	e8 d6 16 00 00       	call   3752 <printf>
    exit();
    207c:	e8 76 15 00 00       	call   35f7 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2081:	83 ec 0c             	sub    $0xc,%esp
    2084:	68 6a 42 00 00       	push   $0x426a
    2089:	e8 b9 15 00 00       	call   3647 <unlink>
    208e:	83 c4 10             	add    $0x10,%esp
    2091:	85 c0                	test   %eax,%eax
    2093:	74 14                	je     20a9 <subdir+0x5df>
    printf(1, "unlink dd/dd/ff failed\n");
    2095:	83 ec 08             	sub    $0x8,%esp
    2098:	68 75 42 00 00       	push   $0x4275
    209d:	6a 01                	push   $0x1
    209f:	e8 ae 16 00 00       	call   3752 <printf>
    exit();
    20a4:	e8 4e 15 00 00       	call   35f7 <exit>
  }
  if(unlink("dd/ff") != 0){
    20a9:	83 ec 0c             	sub    $0xc,%esp
    20ac:	68 09 42 00 00       	push   $0x4209
    20b1:	e8 91 15 00 00       	call   3647 <unlink>
    20b6:	83 c4 10             	add    $0x10,%esp
    20b9:	85 c0                	test   %eax,%eax
    20bb:	74 14                	je     20d1 <subdir+0x607>
    printf(1, "unlink dd/ff failed\n");
    20bd:	83 ec 08             	sub    $0x8,%esp
    20c0:	68 76 44 00 00       	push   $0x4476
    20c5:	6a 01                	push   $0x1
    20c7:	e8 86 16 00 00       	call   3752 <printf>
    exit();
    20cc:	e8 26 15 00 00       	call   35f7 <exit>
  }
  if(unlink("dd") == 0){
    20d1:	83 ec 0c             	sub    $0xc,%esp
    20d4:	68 d0 42 00 00       	push   $0x42d0
    20d9:	e8 69 15 00 00       	call   3647 <unlink>
    20de:	83 c4 10             	add    $0x10,%esp
    20e1:	85 c0                	test   %eax,%eax
    20e3:	75 14                	jne    20f9 <subdir+0x62f>
    printf(1, "unlink non-empty dd succeeded!\n");
    20e5:	83 ec 08             	sub    $0x8,%esp
    20e8:	68 a0 4d 00 00       	push   $0x4da0
    20ed:	6a 01                	push   $0x1
    20ef:	e8 5e 16 00 00       	call   3752 <printf>
    exit();
    20f4:	e8 fe 14 00 00       	call   35f7 <exit>
  }
  if(unlink("dd/dd") < 0){
    20f9:	83 ec 0c             	sub    $0xc,%esp
    20fc:	68 e5 41 00 00       	push   $0x41e5
    2101:	e8 41 15 00 00       	call   3647 <unlink>
    2106:	83 c4 10             	add    $0x10,%esp
    2109:	85 c0                	test   %eax,%eax
    210b:	79 14                	jns    2121 <subdir+0x657>
    printf(1, "unlink dd/dd failed\n");
    210d:	83 ec 08             	sub    $0x8,%esp
    2110:	68 8b 44 00 00       	push   $0x448b
    2115:	6a 01                	push   $0x1
    2117:	e8 36 16 00 00       	call   3752 <printf>
    exit();
    211c:	e8 d6 14 00 00       	call   35f7 <exit>
  }
  if(unlink("dd") < 0){
    2121:	83 ec 0c             	sub    $0xc,%esp
    2124:	68 d0 42 00 00       	push   $0x42d0
    2129:	e8 19 15 00 00       	call   3647 <unlink>
    212e:	83 c4 10             	add    $0x10,%esp
    2131:	85 c0                	test   %eax,%eax
    2133:	79 14                	jns    2149 <subdir+0x67f>
    printf(1, "unlink dd failed\n");
    2135:	83 ec 08             	sub    $0x8,%esp
    2138:	68 a0 44 00 00       	push   $0x44a0
    213d:	6a 01                	push   $0x1
    213f:	e8 0e 16 00 00       	call   3752 <printf>
    exit();
    2144:	e8 ae 14 00 00       	call   35f7 <exit>
  }

  printf(1, "subdir ok\n");
    2149:	83 ec 08             	sub    $0x8,%esp
    214c:	68 b2 44 00 00       	push   $0x44b2
    2151:	6a 01                	push   $0x1
    2153:	e8 fa 15 00 00       	call   3752 <printf>
}
    2158:	83 c4 10             	add    $0x10,%esp
    215b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    215e:	c9                   	leave  
    215f:	c3                   	ret    

00002160 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2160:	55                   	push   %ebp
    2161:	89 e5                	mov    %esp,%ebp
    2163:	57                   	push   %edi
    2164:	56                   	push   %esi
    2165:	53                   	push   %ebx
    2166:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2169:	68 bd 44 00 00       	push   $0x44bd
    216e:	6a 01                	push   $0x1
    2170:	e8 dd 15 00 00       	call   3752 <printf>

  unlink("bigwrite");
    2175:	c7 04 24 cc 44 00 00 	movl   $0x44cc,(%esp)
    217c:	e8 c6 14 00 00       	call   3647 <unlink>
    2181:	83 c4 10             	add    $0x10,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    2184:	bb f3 01 00 00       	mov    $0x1f3,%ebx
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2189:	83 ec 08             	sub    $0x8,%esp
    218c:	68 02 02 00 00       	push   $0x202
    2191:	68 cc 44 00 00       	push   $0x44cc
    2196:	e8 9c 14 00 00       	call   3637 <open>
    219b:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    219d:	83 c4 10             	add    $0x10,%esp
    21a0:	85 c0                	test   %eax,%eax
    21a2:	79 14                	jns    21b8 <bigwrite+0x58>
      printf(1, "cannot create bigwrite\n");
    21a4:	83 ec 08             	sub    $0x8,%esp
    21a7:	68 d5 44 00 00       	push   $0x44d5
    21ac:	6a 01                	push   $0x1
    21ae:	e8 9f 15 00 00       	call   3752 <printf>
      exit();
    21b3:	e8 3f 14 00 00       	call   35f7 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    21b8:	83 ec 04             	sub    $0x4,%esp
    21bb:	53                   	push   %ebx
    21bc:	68 00 82 00 00       	push   $0x8200
    21c1:	50                   	push   %eax
    21c2:	e8 50 14 00 00       	call   3617 <write>
    21c7:	89 c7                	mov    %eax,%edi
      if(cc != sz){
    21c9:	83 c4 10             	add    $0x10,%esp
    21cc:	39 d8                	cmp    %ebx,%eax
    21ce:	75 18                	jne    21e8 <bigwrite+0x88>
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
    21d0:	83 ec 04             	sub    $0x4,%esp
    21d3:	53                   	push   %ebx
    21d4:	68 00 82 00 00       	push   $0x8200
    21d9:	56                   	push   %esi
    21da:	e8 38 14 00 00       	call   3617 <write>
      if(cc != sz){
    21df:	83 c4 10             	add    $0x10,%esp
    21e2:	39 d8                	cmp    %ebx,%eax
    21e4:	74 17                	je     21fd <bigwrite+0x9d>
    21e6:	eb 02                	jmp    21ea <bigwrite+0x8a>
    21e8:	89 df                	mov    %ebx,%edi
        printf(1, "write(%d) ret %d\n", sz, cc);
    21ea:	50                   	push   %eax
    21eb:	57                   	push   %edi
    21ec:	68 ed 44 00 00       	push   $0x44ed
    21f1:	6a 01                	push   $0x1
    21f3:	e8 5a 15 00 00       	call   3752 <printf>
        exit();
    21f8:	e8 fa 13 00 00       	call   35f7 <exit>
      }
    }
    close(fd);
    21fd:	83 ec 0c             	sub    $0xc,%esp
    2200:	56                   	push   %esi
    2201:	e8 19 14 00 00       	call   361f <close>
    unlink("bigwrite");
    2206:	c7 04 24 cc 44 00 00 	movl   $0x44cc,(%esp)
    220d:	e8 35 14 00 00       	call   3647 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2212:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    2218:	83 c4 10             	add    $0x10,%esp
    221b:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    2221:	0f 85 62 ff ff ff    	jne    2189 <bigwrite+0x29>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2227:	83 ec 08             	sub    $0x8,%esp
    222a:	68 ff 44 00 00       	push   $0x44ff
    222f:	6a 01                	push   $0x1
    2231:	e8 1c 15 00 00       	call   3752 <printf>
}
    2236:	83 c4 10             	add    $0x10,%esp
    2239:	8d 65 f4             	lea    -0xc(%ebp),%esp
    223c:	5b                   	pop    %ebx
    223d:	5e                   	pop    %esi
    223e:	5f                   	pop    %edi
    223f:	5d                   	pop    %ebp
    2240:	c3                   	ret    

00002241 <bigfile>:

void
bigfile(void)
{
    2241:	55                   	push   %ebp
    2242:	89 e5                	mov    %esp,%ebp
    2244:	57                   	push   %edi
    2245:	56                   	push   %esi
    2246:	53                   	push   %ebx
    2247:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    224a:	68 0c 45 00 00       	push   $0x450c
    224f:	6a 01                	push   $0x1
    2251:	e8 fc 14 00 00       	call   3752 <printf>

  unlink("bigfile");
    2256:	c7 04 24 28 45 00 00 	movl   $0x4528,(%esp)
    225d:	e8 e5 13 00 00       	call   3647 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2262:	83 c4 08             	add    $0x8,%esp
    2265:	68 02 02 00 00       	push   $0x202
    226a:	68 28 45 00 00       	push   $0x4528
    226f:	e8 c3 13 00 00       	call   3637 <open>
  if(fd < 0){
    2274:	83 c4 10             	add    $0x10,%esp
    2277:	85 c0                	test   %eax,%eax
    2279:	79 14                	jns    228f <bigfile+0x4e>
    printf(1, "cannot create bigfile");
    227b:	83 ec 08             	sub    $0x8,%esp
    227e:	68 1a 45 00 00       	push   $0x451a
    2283:	6a 01                	push   $0x1
    2285:	e8 c8 14 00 00       	call   3752 <printf>
    exit();
    228a:	e8 68 13 00 00       	call   35f7 <exit>
    228f:	89 c6                	mov    %eax,%esi
    2291:	bb 00 00 00 00       	mov    $0x0,%ebx
  }
  for(i = 0; i < 20; i++){
    memset(buf, i, 600);
    2296:	83 ec 04             	sub    $0x4,%esp
    2299:	68 58 02 00 00       	push   $0x258
    229e:	53                   	push   %ebx
    229f:	68 00 82 00 00       	push   $0x8200
    22a4:	e8 fd 11 00 00       	call   34a6 <memset>
    if(write(fd, buf, 600) != 600){
    22a9:	83 c4 0c             	add    $0xc,%esp
    22ac:	68 58 02 00 00       	push   $0x258
    22b1:	68 00 82 00 00       	push   $0x8200
    22b6:	56                   	push   %esi
    22b7:	e8 5b 13 00 00       	call   3617 <write>
    22bc:	83 c4 10             	add    $0x10,%esp
    22bf:	3d 58 02 00 00       	cmp    $0x258,%eax
    22c4:	74 14                	je     22da <bigfile+0x99>
      printf(1, "write bigfile failed\n");
    22c6:	83 ec 08             	sub    $0x8,%esp
    22c9:	68 30 45 00 00       	push   $0x4530
    22ce:	6a 01                	push   $0x1
    22d0:	e8 7d 14 00 00       	call   3752 <printf>
      exit();
    22d5:	e8 1d 13 00 00       	call   35f7 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    22da:	83 c3 01             	add    $0x1,%ebx
    22dd:	83 fb 14             	cmp    $0x14,%ebx
    22e0:	75 b4                	jne    2296 <bigfile+0x55>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    22e2:	83 ec 0c             	sub    $0xc,%esp
    22e5:	56                   	push   %esi
    22e6:	e8 34 13 00 00       	call   361f <close>

  fd = open("bigfile", 0);
    22eb:	83 c4 08             	add    $0x8,%esp
    22ee:	6a 00                	push   $0x0
    22f0:	68 28 45 00 00       	push   $0x4528
    22f5:	e8 3d 13 00 00       	call   3637 <open>
    22fa:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    22fc:	83 c4 10             	add    $0x10,%esp
    22ff:	85 c0                	test   %eax,%eax
    2301:	79 14                	jns    2317 <bigfile+0xd6>
    printf(1, "cannot open bigfile\n");
    2303:	83 ec 08             	sub    $0x8,%esp
    2306:	68 46 45 00 00       	push   $0x4546
    230b:	6a 01                	push   $0x1
    230d:	e8 40 14 00 00       	call   3752 <printf>
    exit();
    2312:	e8 e0 12 00 00       	call   35f7 <exit>
    2317:	be 00 00 00 00       	mov    $0x0,%esi
    231c:	bb 00 00 00 00       	mov    $0x0,%ebx
  }
  total = 0;
  for(i = 0; ; i++){
    cc = read(fd, buf, 300);
    2321:	83 ec 04             	sub    $0x4,%esp
    2324:	68 2c 01 00 00       	push   $0x12c
    2329:	68 00 82 00 00       	push   $0x8200
    232e:	57                   	push   %edi
    232f:	e8 db 12 00 00       	call   360f <read>
    if(cc < 0){
    2334:	83 c4 10             	add    $0x10,%esp
    2337:	85 c0                	test   %eax,%eax
    2339:	79 14                	jns    234f <bigfile+0x10e>
      printf(1, "read bigfile failed\n");
    233b:	83 ec 08             	sub    $0x8,%esp
    233e:	68 5b 45 00 00       	push   $0x455b
    2343:	6a 01                	push   $0x1
    2345:	e8 08 14 00 00       	call   3752 <printf>
      exit();
    234a:	e8 a8 12 00 00       	call   35f7 <exit>
    }
    if(cc == 0)
    234f:	85 c0                	test   %eax,%eax
    2351:	74 5c                	je     23af <bigfile+0x16e>
      break;
    if(cc != 300){
    2353:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2358:	74 14                	je     236e <bigfile+0x12d>
      printf(1, "short read bigfile\n");
    235a:	83 ec 08             	sub    $0x8,%esp
    235d:	68 70 45 00 00       	push   $0x4570
    2362:	6a 01                	push   $0x1
    2364:	e8 e9 13 00 00       	call   3752 <printf>
      exit();
    2369:	e8 89 12 00 00       	call   35f7 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    236e:	0f be 15 00 82 00 00 	movsbl 0x8200,%edx
    2375:	89 d8                	mov    %ebx,%eax
    2377:	c1 e8 1f             	shr    $0x1f,%eax
    237a:	01 d8                	add    %ebx,%eax
    237c:	d1 f8                	sar    %eax
    237e:	39 c2                	cmp    %eax,%edx
    2380:	75 0b                	jne    238d <bigfile+0x14c>
    2382:	0f be 05 2b 83 00 00 	movsbl 0x832b,%eax
    2389:	39 c2                	cmp    %eax,%edx
    238b:	74 14                	je     23a1 <bigfile+0x160>
      printf(1, "read bigfile wrong data\n");
    238d:	83 ec 08             	sub    $0x8,%esp
    2390:	68 84 45 00 00       	push   $0x4584
    2395:	6a 01                	push   $0x1
    2397:	e8 b6 13 00 00       	call   3752 <printf>
      exit();
    239c:	e8 56 12 00 00       	call   35f7 <exit>
    }
    total += cc;
    23a1:	81 c6 2c 01 00 00    	add    $0x12c,%esi
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    23a7:	83 c3 01             	add    $0x1,%ebx
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    23aa:	e9 72 ff ff ff       	jmp    2321 <bigfile+0xe0>
  close(fd);
    23af:	83 ec 0c             	sub    $0xc,%esp
    23b2:	57                   	push   %edi
    23b3:	e8 67 12 00 00       	call   361f <close>
  if(total != 20*600){
    23b8:	83 c4 10             	add    $0x10,%esp
    23bb:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    23c1:	74 14                	je     23d7 <bigfile+0x196>
    printf(1, "read bigfile wrong total\n");
    23c3:	83 ec 08             	sub    $0x8,%esp
    23c6:	68 9d 45 00 00       	push   $0x459d
    23cb:	6a 01                	push   $0x1
    23cd:	e8 80 13 00 00       	call   3752 <printf>
    exit();
    23d2:	e8 20 12 00 00       	call   35f7 <exit>
  }
  unlink("bigfile");
    23d7:	83 ec 0c             	sub    $0xc,%esp
    23da:	68 28 45 00 00       	push   $0x4528
    23df:	e8 63 12 00 00       	call   3647 <unlink>

  printf(1, "bigfile test ok\n");
    23e4:	83 c4 08             	add    $0x8,%esp
    23e7:	68 b7 45 00 00       	push   $0x45b7
    23ec:	6a 01                	push   $0x1
    23ee:	e8 5f 13 00 00       	call   3752 <printf>
}
    23f3:	83 c4 10             	add    $0x10,%esp
    23f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    23f9:	5b                   	pop    %ebx
    23fa:	5e                   	pop    %esi
    23fb:	5f                   	pop    %edi
    23fc:	5d                   	pop    %ebp
    23fd:	c3                   	ret    

000023fe <fourteen>:

void
fourteen(void)
{
    23fe:	55                   	push   %ebp
    23ff:	89 e5                	mov    %esp,%ebp
    2401:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2404:	68 c8 45 00 00       	push   $0x45c8
    2409:	6a 01                	push   $0x1
    240b:	e8 42 13 00 00       	call   3752 <printf>

  if(mkdir("12345678901234") != 0){
    2410:	c7 04 24 03 46 00 00 	movl   $0x4603,(%esp)
    2417:	e8 43 12 00 00       	call   365f <mkdir>
    241c:	83 c4 10             	add    $0x10,%esp
    241f:	85 c0                	test   %eax,%eax
    2421:	74 14                	je     2437 <fourteen+0x39>
    printf(1, "mkdir 12345678901234 failed\n");
    2423:	83 ec 08             	sub    $0x8,%esp
    2426:	68 d7 45 00 00       	push   $0x45d7
    242b:	6a 01                	push   $0x1
    242d:	e8 20 13 00 00       	call   3752 <printf>
    exit();
    2432:	e8 c0 11 00 00       	call   35f7 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2437:	83 ec 0c             	sub    $0xc,%esp
    243a:	68 c0 4d 00 00       	push   $0x4dc0
    243f:	e8 1b 12 00 00       	call   365f <mkdir>
    2444:	83 c4 10             	add    $0x10,%esp
    2447:	85 c0                	test   %eax,%eax
    2449:	74 14                	je     245f <fourteen+0x61>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    244b:	83 ec 08             	sub    $0x8,%esp
    244e:	68 e0 4d 00 00       	push   $0x4de0
    2453:	6a 01                	push   $0x1
    2455:	e8 f8 12 00 00       	call   3752 <printf>
    exit();
    245a:	e8 98 11 00 00       	call   35f7 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    245f:	83 ec 08             	sub    $0x8,%esp
    2462:	68 00 02 00 00       	push   $0x200
    2467:	68 10 4e 00 00       	push   $0x4e10
    246c:	e8 c6 11 00 00       	call   3637 <open>
  if(fd < 0){
    2471:	83 c4 10             	add    $0x10,%esp
    2474:	85 c0                	test   %eax,%eax
    2476:	79 14                	jns    248c <fourteen+0x8e>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2478:	83 ec 08             	sub    $0x8,%esp
    247b:	68 40 4e 00 00       	push   $0x4e40
    2480:	6a 01                	push   $0x1
    2482:	e8 cb 12 00 00       	call   3752 <printf>
    exit();
    2487:	e8 6b 11 00 00       	call   35f7 <exit>
  }
  close(fd);
    248c:	83 ec 0c             	sub    $0xc,%esp
    248f:	50                   	push   %eax
    2490:	e8 8a 11 00 00       	call   361f <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2495:	83 c4 08             	add    $0x8,%esp
    2498:	6a 00                	push   $0x0
    249a:	68 80 4e 00 00       	push   $0x4e80
    249f:	e8 93 11 00 00       	call   3637 <open>
  if(fd < 0){
    24a4:	83 c4 10             	add    $0x10,%esp
    24a7:	85 c0                	test   %eax,%eax
    24a9:	79 14                	jns    24bf <fourteen+0xc1>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    24ab:	83 ec 08             	sub    $0x8,%esp
    24ae:	68 b0 4e 00 00       	push   $0x4eb0
    24b3:	6a 01                	push   $0x1
    24b5:	e8 98 12 00 00       	call   3752 <printf>
    exit();
    24ba:	e8 38 11 00 00       	call   35f7 <exit>
  }
  close(fd);
    24bf:	83 ec 0c             	sub    $0xc,%esp
    24c2:	50                   	push   %eax
    24c3:	e8 57 11 00 00       	call   361f <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    24c8:	c7 04 24 f4 45 00 00 	movl   $0x45f4,(%esp)
    24cf:	e8 8b 11 00 00       	call   365f <mkdir>
    24d4:	83 c4 10             	add    $0x10,%esp
    24d7:	85 c0                	test   %eax,%eax
    24d9:	75 14                	jne    24ef <fourteen+0xf1>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    24db:	83 ec 08             	sub    $0x8,%esp
    24de:	68 ec 4e 00 00       	push   $0x4eec
    24e3:	6a 01                	push   $0x1
    24e5:	e8 68 12 00 00       	call   3752 <printf>
    exit();
    24ea:	e8 08 11 00 00       	call   35f7 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    24ef:	83 ec 0c             	sub    $0xc,%esp
    24f2:	68 1c 4f 00 00       	push   $0x4f1c
    24f7:	e8 63 11 00 00       	call   365f <mkdir>
    24fc:	83 c4 10             	add    $0x10,%esp
    24ff:	85 c0                	test   %eax,%eax
    2501:	75 14                	jne    2517 <fourteen+0x119>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2503:	83 ec 08             	sub    $0x8,%esp
    2506:	68 3c 4f 00 00       	push   $0x4f3c
    250b:	6a 01                	push   $0x1
    250d:	e8 40 12 00 00       	call   3752 <printf>
    exit();
    2512:	e8 e0 10 00 00       	call   35f7 <exit>
  }

  printf(1, "fourteen ok\n");
    2517:	83 ec 08             	sub    $0x8,%esp
    251a:	68 12 46 00 00       	push   $0x4612
    251f:	6a 01                	push   $0x1
    2521:	e8 2c 12 00 00       	call   3752 <printf>
}
    2526:	83 c4 10             	add    $0x10,%esp
    2529:	c9                   	leave  
    252a:	c3                   	ret    

0000252b <rmdot>:

void
rmdot(void)
{
    252b:	55                   	push   %ebp
    252c:	89 e5                	mov    %esp,%ebp
    252e:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2531:	68 1f 46 00 00       	push   $0x461f
    2536:	6a 01                	push   $0x1
    2538:	e8 15 12 00 00       	call   3752 <printf>
  if(mkdir("dots") != 0){
    253d:	c7 04 24 2b 46 00 00 	movl   $0x462b,(%esp)
    2544:	e8 16 11 00 00       	call   365f <mkdir>
    2549:	83 c4 10             	add    $0x10,%esp
    254c:	85 c0                	test   %eax,%eax
    254e:	74 14                	je     2564 <rmdot+0x39>
    printf(1, "mkdir dots failed\n");
    2550:	83 ec 08             	sub    $0x8,%esp
    2553:	68 30 46 00 00       	push   $0x4630
    2558:	6a 01                	push   $0x1
    255a:	e8 f3 11 00 00       	call   3752 <printf>
    exit();
    255f:	e8 93 10 00 00       	call   35f7 <exit>
  }
  if(chdir("dots") != 0){
    2564:	83 ec 0c             	sub    $0xc,%esp
    2567:	68 2b 46 00 00       	push   $0x462b
    256c:	e8 f6 10 00 00       	call   3667 <chdir>
    2571:	83 c4 10             	add    $0x10,%esp
    2574:	85 c0                	test   %eax,%eax
    2576:	74 14                	je     258c <rmdot+0x61>
    printf(1, "chdir dots failed\n");
    2578:	83 ec 08             	sub    $0x8,%esp
    257b:	68 43 46 00 00       	push   $0x4643
    2580:	6a 01                	push   $0x1
    2582:	e8 cb 11 00 00       	call   3752 <printf>
    exit();
    2587:	e8 6b 10 00 00       	call   35f7 <exit>
  }
  if(unlink(".") == 0){
    258c:	83 ec 0c             	sub    $0xc,%esp
    258f:	68 d6 42 00 00       	push   $0x42d6
    2594:	e8 ae 10 00 00       	call   3647 <unlink>
    2599:	83 c4 10             	add    $0x10,%esp
    259c:	85 c0                	test   %eax,%eax
    259e:	75 14                	jne    25b4 <rmdot+0x89>
    printf(1, "rm . worked!\n");
    25a0:	83 ec 08             	sub    $0x8,%esp
    25a3:	68 56 46 00 00       	push   $0x4656
    25a8:	6a 01                	push   $0x1
    25aa:	e8 a3 11 00 00       	call   3752 <printf>
    exit();
    25af:	e8 43 10 00 00       	call   35f7 <exit>
  }
  if(unlink("..") == 0){
    25b4:	83 ec 0c             	sub    $0xc,%esp
    25b7:	68 d5 42 00 00       	push   $0x42d5
    25bc:	e8 86 10 00 00       	call   3647 <unlink>
    25c1:	83 c4 10             	add    $0x10,%esp
    25c4:	85 c0                	test   %eax,%eax
    25c6:	75 14                	jne    25dc <rmdot+0xb1>
    printf(1, "rm .. worked!\n");
    25c8:	83 ec 08             	sub    $0x8,%esp
    25cb:	68 64 46 00 00       	push   $0x4664
    25d0:	6a 01                	push   $0x1
    25d2:	e8 7b 11 00 00       	call   3752 <printf>
    exit();
    25d7:	e8 1b 10 00 00       	call   35f7 <exit>
  }
  if(chdir("/") != 0){
    25dc:	83 ec 0c             	sub    $0xc,%esp
    25df:	68 a9 3a 00 00       	push   $0x3aa9
    25e4:	e8 7e 10 00 00       	call   3667 <chdir>
    25e9:	83 c4 10             	add    $0x10,%esp
    25ec:	85 c0                	test   %eax,%eax
    25ee:	74 14                	je     2604 <rmdot+0xd9>
    printf(1, "chdir / failed\n");
    25f0:	83 ec 08             	sub    $0x8,%esp
    25f3:	68 ab 3a 00 00       	push   $0x3aab
    25f8:	6a 01                	push   $0x1
    25fa:	e8 53 11 00 00       	call   3752 <printf>
    exit();
    25ff:	e8 f3 0f 00 00       	call   35f7 <exit>
  }
  if(unlink("dots/.") == 0){
    2604:	83 ec 0c             	sub    $0xc,%esp
    2607:	68 73 46 00 00       	push   $0x4673
    260c:	e8 36 10 00 00       	call   3647 <unlink>
    2611:	83 c4 10             	add    $0x10,%esp
    2614:	85 c0                	test   %eax,%eax
    2616:	75 14                	jne    262c <rmdot+0x101>
    printf(1, "unlink dots/. worked!\n");
    2618:	83 ec 08             	sub    $0x8,%esp
    261b:	68 7a 46 00 00       	push   $0x467a
    2620:	6a 01                	push   $0x1
    2622:	e8 2b 11 00 00       	call   3752 <printf>
    exit();
    2627:	e8 cb 0f 00 00       	call   35f7 <exit>
  }
  if(unlink("dots/..") == 0){
    262c:	83 ec 0c             	sub    $0xc,%esp
    262f:	68 91 46 00 00       	push   $0x4691
    2634:	e8 0e 10 00 00       	call   3647 <unlink>
    2639:	83 c4 10             	add    $0x10,%esp
    263c:	85 c0                	test   %eax,%eax
    263e:	75 14                	jne    2654 <rmdot+0x129>
    printf(1, "unlink dots/.. worked!\n");
    2640:	83 ec 08             	sub    $0x8,%esp
    2643:	68 99 46 00 00       	push   $0x4699
    2648:	6a 01                	push   $0x1
    264a:	e8 03 11 00 00       	call   3752 <printf>
    exit();
    264f:	e8 a3 0f 00 00       	call   35f7 <exit>
  }
  if(unlink("dots") != 0){
    2654:	83 ec 0c             	sub    $0xc,%esp
    2657:	68 2b 46 00 00       	push   $0x462b
    265c:	e8 e6 0f 00 00       	call   3647 <unlink>
    2661:	83 c4 10             	add    $0x10,%esp
    2664:	85 c0                	test   %eax,%eax
    2666:	74 14                	je     267c <rmdot+0x151>
    printf(1, "unlink dots failed!\n");
    2668:	83 ec 08             	sub    $0x8,%esp
    266b:	68 b1 46 00 00       	push   $0x46b1
    2670:	6a 01                	push   $0x1
    2672:	e8 db 10 00 00       	call   3752 <printf>
    exit();
    2677:	e8 7b 0f 00 00       	call   35f7 <exit>
  }
  printf(1, "rmdot ok\n");
    267c:	83 ec 08             	sub    $0x8,%esp
    267f:	68 c6 46 00 00       	push   $0x46c6
    2684:	6a 01                	push   $0x1
    2686:	e8 c7 10 00 00       	call   3752 <printf>
}
    268b:	83 c4 10             	add    $0x10,%esp
    268e:	c9                   	leave  
    268f:	c3                   	ret    

00002690 <dirfile>:

void
dirfile(void)
{
    2690:	55                   	push   %ebp
    2691:	89 e5                	mov    %esp,%ebp
    2693:	53                   	push   %ebx
    2694:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    2697:	68 d0 46 00 00       	push   $0x46d0
    269c:	6a 01                	push   $0x1
    269e:	e8 af 10 00 00       	call   3752 <printf>

  fd = open("dirfile", O_CREATE);
    26a3:	83 c4 08             	add    $0x8,%esp
    26a6:	68 00 02 00 00       	push   $0x200
    26ab:	68 dd 46 00 00       	push   $0x46dd
    26b0:	e8 82 0f 00 00       	call   3637 <open>
  if(fd < 0){
    26b5:	83 c4 10             	add    $0x10,%esp
    26b8:	85 c0                	test   %eax,%eax
    26ba:	79 14                	jns    26d0 <dirfile+0x40>
    printf(1, "create dirfile failed\n");
    26bc:	83 ec 08             	sub    $0x8,%esp
    26bf:	68 e5 46 00 00       	push   $0x46e5
    26c4:	6a 01                	push   $0x1
    26c6:	e8 87 10 00 00       	call   3752 <printf>
    exit();
    26cb:	e8 27 0f 00 00       	call   35f7 <exit>
  }
  close(fd);
    26d0:	83 ec 0c             	sub    $0xc,%esp
    26d3:	50                   	push   %eax
    26d4:	e8 46 0f 00 00       	call   361f <close>
  if(chdir("dirfile") == 0){
    26d9:	c7 04 24 dd 46 00 00 	movl   $0x46dd,(%esp)
    26e0:	e8 82 0f 00 00       	call   3667 <chdir>
    26e5:	83 c4 10             	add    $0x10,%esp
    26e8:	85 c0                	test   %eax,%eax
    26ea:	75 14                	jne    2700 <dirfile+0x70>
    printf(1, "chdir dirfile succeeded!\n");
    26ec:	83 ec 08             	sub    $0x8,%esp
    26ef:	68 fc 46 00 00       	push   $0x46fc
    26f4:	6a 01                	push   $0x1
    26f6:	e8 57 10 00 00       	call   3752 <printf>
    exit();
    26fb:	e8 f7 0e 00 00       	call   35f7 <exit>
  }
  fd = open("dirfile/xx", 0);
    2700:	83 ec 08             	sub    $0x8,%esp
    2703:	6a 00                	push   $0x0
    2705:	68 16 47 00 00       	push   $0x4716
    270a:	e8 28 0f 00 00       	call   3637 <open>
  if(fd >= 0){
    270f:	83 c4 10             	add    $0x10,%esp
    2712:	85 c0                	test   %eax,%eax
    2714:	78 14                	js     272a <dirfile+0x9a>
    printf(1, "create dirfile/xx succeeded!\n");
    2716:	83 ec 08             	sub    $0x8,%esp
    2719:	68 21 47 00 00       	push   $0x4721
    271e:	6a 01                	push   $0x1
    2720:	e8 2d 10 00 00       	call   3752 <printf>
    exit();
    2725:	e8 cd 0e 00 00       	call   35f7 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    272a:	83 ec 08             	sub    $0x8,%esp
    272d:	68 00 02 00 00       	push   $0x200
    2732:	68 16 47 00 00       	push   $0x4716
    2737:	e8 fb 0e 00 00       	call   3637 <open>
  if(fd >= 0){
    273c:	83 c4 10             	add    $0x10,%esp
    273f:	85 c0                	test   %eax,%eax
    2741:	78 14                	js     2757 <dirfile+0xc7>
    printf(1, "create dirfile/xx succeeded!\n");
    2743:	83 ec 08             	sub    $0x8,%esp
    2746:	68 21 47 00 00       	push   $0x4721
    274b:	6a 01                	push   $0x1
    274d:	e8 00 10 00 00       	call   3752 <printf>
    exit();
    2752:	e8 a0 0e 00 00       	call   35f7 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2757:	83 ec 0c             	sub    $0xc,%esp
    275a:	68 16 47 00 00       	push   $0x4716
    275f:	e8 fb 0e 00 00       	call   365f <mkdir>
    2764:	83 c4 10             	add    $0x10,%esp
    2767:	85 c0                	test   %eax,%eax
    2769:	75 14                	jne    277f <dirfile+0xef>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    276b:	83 ec 08             	sub    $0x8,%esp
    276e:	68 3f 47 00 00       	push   $0x473f
    2773:	6a 01                	push   $0x1
    2775:	e8 d8 0f 00 00       	call   3752 <printf>
    exit();
    277a:	e8 78 0e 00 00       	call   35f7 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    277f:	83 ec 0c             	sub    $0xc,%esp
    2782:	68 16 47 00 00       	push   $0x4716
    2787:	e8 bb 0e 00 00       	call   3647 <unlink>
    278c:	83 c4 10             	add    $0x10,%esp
    278f:	85 c0                	test   %eax,%eax
    2791:	75 14                	jne    27a7 <dirfile+0x117>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2793:	83 ec 08             	sub    $0x8,%esp
    2796:	68 5c 47 00 00       	push   $0x475c
    279b:	6a 01                	push   $0x1
    279d:	e8 b0 0f 00 00       	call   3752 <printf>
    exit();
    27a2:	e8 50 0e 00 00       	call   35f7 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    27a7:	83 ec 08             	sub    $0x8,%esp
    27aa:	68 16 47 00 00       	push   $0x4716
    27af:	68 7a 47 00 00       	push   $0x477a
    27b4:	e8 9e 0e 00 00       	call   3657 <link>
    27b9:	83 c4 10             	add    $0x10,%esp
    27bc:	85 c0                	test   %eax,%eax
    27be:	75 14                	jne    27d4 <dirfile+0x144>
    printf(1, "link to dirfile/xx succeeded!\n");
    27c0:	83 ec 08             	sub    $0x8,%esp
    27c3:	68 70 4f 00 00       	push   $0x4f70
    27c8:	6a 01                	push   $0x1
    27ca:	e8 83 0f 00 00       	call   3752 <printf>
    exit();
    27cf:	e8 23 0e 00 00       	call   35f7 <exit>
  }
  if(unlink("dirfile") != 0){
    27d4:	83 ec 0c             	sub    $0xc,%esp
    27d7:	68 dd 46 00 00       	push   $0x46dd
    27dc:	e8 66 0e 00 00       	call   3647 <unlink>
    27e1:	83 c4 10             	add    $0x10,%esp
    27e4:	85 c0                	test   %eax,%eax
    27e6:	74 14                	je     27fc <dirfile+0x16c>
    printf(1, "unlink dirfile failed!\n");
    27e8:	83 ec 08             	sub    $0x8,%esp
    27eb:	68 81 47 00 00       	push   $0x4781
    27f0:	6a 01                	push   $0x1
    27f2:	e8 5b 0f 00 00       	call   3752 <printf>
    exit();
    27f7:	e8 fb 0d 00 00       	call   35f7 <exit>
  }

  fd = open(".", O_RDWR);
    27fc:	83 ec 08             	sub    $0x8,%esp
    27ff:	6a 02                	push   $0x2
    2801:	68 d6 42 00 00       	push   $0x42d6
    2806:	e8 2c 0e 00 00       	call   3637 <open>
  if(fd >= 0){
    280b:	83 c4 10             	add    $0x10,%esp
    280e:	85 c0                	test   %eax,%eax
    2810:	78 14                	js     2826 <dirfile+0x196>
    printf(1, "open . for writing succeeded!\n");
    2812:	83 ec 08             	sub    $0x8,%esp
    2815:	68 90 4f 00 00       	push   $0x4f90
    281a:	6a 01                	push   $0x1
    281c:	e8 31 0f 00 00       	call   3752 <printf>
    exit();
    2821:	e8 d1 0d 00 00       	call   35f7 <exit>
  }
  fd = open(".", 0);
    2826:	83 ec 08             	sub    $0x8,%esp
    2829:	6a 00                	push   $0x0
    282b:	68 d6 42 00 00       	push   $0x42d6
    2830:	e8 02 0e 00 00       	call   3637 <open>
    2835:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2837:	83 c4 0c             	add    $0xc,%esp
    283a:	6a 01                	push   $0x1
    283c:	68 b9 43 00 00       	push   $0x43b9
    2841:	50                   	push   %eax
    2842:	e8 d0 0d 00 00       	call   3617 <write>
    2847:	83 c4 10             	add    $0x10,%esp
    284a:	85 c0                	test   %eax,%eax
    284c:	7e 14                	jle    2862 <dirfile+0x1d2>
    printf(1, "write . succeeded!\n");
    284e:	83 ec 08             	sub    $0x8,%esp
    2851:	68 99 47 00 00       	push   $0x4799
    2856:	6a 01                	push   $0x1
    2858:	e8 f5 0e 00 00       	call   3752 <printf>
    exit();
    285d:	e8 95 0d 00 00       	call   35f7 <exit>
  }
  close(fd);
    2862:	83 ec 0c             	sub    $0xc,%esp
    2865:	53                   	push   %ebx
    2866:	e8 b4 0d 00 00       	call   361f <close>

  printf(1, "dir vs file OK\n");
    286b:	83 c4 08             	add    $0x8,%esp
    286e:	68 ad 47 00 00       	push   $0x47ad
    2873:	6a 01                	push   $0x1
    2875:	e8 d8 0e 00 00       	call   3752 <printf>
}
    287a:	83 c4 10             	add    $0x10,%esp
    287d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2880:	c9                   	leave  
    2881:	c3                   	ret    

00002882 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2882:	55                   	push   %ebp
    2883:	89 e5                	mov    %esp,%ebp
    2885:	53                   	push   %ebx
    2886:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2889:	68 bd 47 00 00       	push   $0x47bd
    288e:	6a 01                	push   $0x1
    2890:	e8 bd 0e 00 00       	call   3752 <printf>
    2895:	83 c4 10             	add    $0x10,%esp
    2898:	bb 33 00 00 00       	mov    $0x33,%ebx

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    if(mkdir("irefd") != 0){
    289d:	83 ec 0c             	sub    $0xc,%esp
    28a0:	68 ce 47 00 00       	push   $0x47ce
    28a5:	e8 b5 0d 00 00       	call   365f <mkdir>
    28aa:	83 c4 10             	add    $0x10,%esp
    28ad:	85 c0                	test   %eax,%eax
    28af:	74 14                	je     28c5 <iref+0x43>
      printf(1, "mkdir irefd failed\n");
    28b1:	83 ec 08             	sub    $0x8,%esp
    28b4:	68 d4 47 00 00       	push   $0x47d4
    28b9:	6a 01                	push   $0x1
    28bb:	e8 92 0e 00 00       	call   3752 <printf>
      exit();
    28c0:	e8 32 0d 00 00       	call   35f7 <exit>
    }
    if(chdir("irefd") != 0){
    28c5:	83 ec 0c             	sub    $0xc,%esp
    28c8:	68 ce 47 00 00       	push   $0x47ce
    28cd:	e8 95 0d 00 00       	call   3667 <chdir>
    28d2:	83 c4 10             	add    $0x10,%esp
    28d5:	85 c0                	test   %eax,%eax
    28d7:	74 14                	je     28ed <iref+0x6b>
      printf(1, "chdir irefd failed\n");
    28d9:	83 ec 08             	sub    $0x8,%esp
    28dc:	68 e8 47 00 00       	push   $0x47e8
    28e1:	6a 01                	push   $0x1
    28e3:	e8 6a 0e 00 00       	call   3752 <printf>
      exit();
    28e8:	e8 0a 0d 00 00       	call   35f7 <exit>
    }

    mkdir("");
    28ed:	83 ec 0c             	sub    $0xc,%esp
    28f0:	68 83 3e 00 00       	push   $0x3e83
    28f5:	e8 65 0d 00 00       	call   365f <mkdir>
    link("README", "");
    28fa:	83 c4 08             	add    $0x8,%esp
    28fd:	68 83 3e 00 00       	push   $0x3e83
    2902:	68 7a 47 00 00       	push   $0x477a
    2907:	e8 4b 0d 00 00       	call   3657 <link>
    fd = open("", O_CREATE);
    290c:	83 c4 08             	add    $0x8,%esp
    290f:	68 00 02 00 00       	push   $0x200
    2914:	68 83 3e 00 00       	push   $0x3e83
    2919:	e8 19 0d 00 00       	call   3637 <open>
    if(fd >= 0)
    291e:	83 c4 10             	add    $0x10,%esp
    2921:	85 c0                	test   %eax,%eax
    2923:	78 0c                	js     2931 <iref+0xaf>
      close(fd);
    2925:	83 ec 0c             	sub    $0xc,%esp
    2928:	50                   	push   %eax
    2929:	e8 f1 0c 00 00       	call   361f <close>
    292e:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2931:	83 ec 08             	sub    $0x8,%esp
    2934:	68 00 02 00 00       	push   $0x200
    2939:	68 b8 43 00 00       	push   $0x43b8
    293e:	e8 f4 0c 00 00       	call   3637 <open>
    if(fd >= 0)
    2943:	83 c4 10             	add    $0x10,%esp
    2946:	85 c0                	test   %eax,%eax
    2948:	78 0c                	js     2956 <iref+0xd4>
      close(fd);
    294a:	83 ec 0c             	sub    $0xc,%esp
    294d:	50                   	push   %eax
    294e:	e8 cc 0c 00 00       	call   361f <close>
    2953:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2956:	83 ec 0c             	sub    $0xc,%esp
    2959:	68 b8 43 00 00       	push   $0x43b8
    295e:	e8 e4 0c 00 00       	call   3647 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2963:	83 c4 10             	add    $0x10,%esp
    2966:	83 eb 01             	sub    $0x1,%ebx
    2969:	0f 85 2e ff ff ff    	jne    289d <iref+0x1b>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    296f:	83 ec 0c             	sub    $0xc,%esp
    2972:	68 a9 3a 00 00       	push   $0x3aa9
    2977:	e8 eb 0c 00 00       	call   3667 <chdir>
  printf(1, "empty file name OK\n");
    297c:	83 c4 08             	add    $0x8,%esp
    297f:	68 fc 47 00 00       	push   $0x47fc
    2984:	6a 01                	push   $0x1
    2986:	e8 c7 0d 00 00       	call   3752 <printf>
}
    298b:	83 c4 10             	add    $0x10,%esp
    298e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2991:	c9                   	leave  
    2992:	c3                   	ret    

00002993 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2993:	55                   	push   %ebp
    2994:	89 e5                	mov    %esp,%ebp
    2996:	53                   	push   %ebx
    2997:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    299a:	68 10 48 00 00       	push   $0x4810
    299f:	6a 01                	push   $0x1
    29a1:	e8 ac 0d 00 00       	call   3752 <printf>
    29a6:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<1000; n++){
    29a9:	bb 00 00 00 00       	mov    $0x0,%ebx
    pid = fork();
    29ae:	e8 3c 0c 00 00       	call   35ef <fork>
    if(pid < 0)
    29b3:	85 c0                	test   %eax,%eax
    29b5:	78 16                	js     29cd <forktest+0x3a>
      break;
    if(pid == 0)
    29b7:	85 c0                	test   %eax,%eax
    29b9:	75 05                	jne    29c0 <forktest+0x2d>
      exit();
    29bb:	e8 37 0c 00 00       	call   35f7 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    29c0:	83 c3 01             	add    $0x1,%ebx
    29c3:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    29c9:	75 e3                	jne    29ae <forktest+0x1b>
    29cb:	eb 0e                	jmp    29db <forktest+0x48>
      break;
    if(pid == 0)
      exit();
  }

  if(n == 1000){
    29cd:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    29d3:	74 06                	je     29db <forktest+0x48>
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
    29d5:	85 db                	test   %ebx,%ebx
    29d7:	7f 16                	jg     29ef <forktest+0x5c>
    29d9:	eb 36                	jmp    2a11 <forktest+0x7e>
    if(pid == 0)
      exit();
  }

  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    29db:	83 ec 08             	sub    $0x8,%esp
    29de:	68 b0 4f 00 00       	push   $0x4fb0
    29e3:	6a 01                	push   $0x1
    29e5:	e8 68 0d 00 00       	call   3752 <printf>
    exit();
    29ea:	e8 08 0c 00 00       	call   35f7 <exit>
  }

  for(; n > 0; n--){
    if(wait() < 0){
    29ef:	e8 0b 0c 00 00       	call   35ff <wait>
    29f4:	85 c0                	test   %eax,%eax
    29f6:	79 14                	jns    2a0c <forktest+0x79>
      printf(1, "wait stopped early\n");
    29f8:	83 ec 08             	sub    $0x8,%esp
    29fb:	68 1b 48 00 00       	push   $0x481b
    2a00:	6a 01                	push   $0x1
    2a02:	e8 4b 0d 00 00       	call   3752 <printf>
      exit();
    2a07:	e8 eb 0b 00 00       	call   35f7 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
    2a0c:	83 eb 01             	sub    $0x1,%ebx
    2a0f:	75 de                	jne    29ef <forktest+0x5c>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
    2a11:	e8 e9 0b 00 00       	call   35ff <wait>
    2a16:	83 f8 ff             	cmp    $0xffffffff,%eax
    2a19:	74 14                	je     2a2f <forktest+0x9c>
    printf(1, "wait got too many\n");
    2a1b:	83 ec 08             	sub    $0x8,%esp
    2a1e:	68 2f 48 00 00       	push   $0x482f
    2a23:	6a 01                	push   $0x1
    2a25:	e8 28 0d 00 00       	call   3752 <printf>
    exit();
    2a2a:	e8 c8 0b 00 00       	call   35f7 <exit>
  }

  printf(1, "fork test OK\n");
    2a2f:	83 ec 08             	sub    $0x8,%esp
    2a32:	68 42 48 00 00       	push   $0x4842
    2a37:	6a 01                	push   $0x1
    2a39:	e8 14 0d 00 00       	call   3752 <printf>
}
    2a3e:	83 c4 10             	add    $0x10,%esp
    2a41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2a44:	c9                   	leave  
    2a45:	c3                   	ret    

00002a46 <sbrktest>:

void
sbrktest(void)
{
    2a46:	55                   	push   %ebp
    2a47:	89 e5                	mov    %esp,%ebp
    2a49:	57                   	push   %edi
    2a4a:	56                   	push   %esi
    2a4b:	53                   	push   %ebx
    2a4c:	83 ec 64             	sub    $0x64,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2a4f:	68 50 48 00 00       	push   $0x4850
    2a54:	ff 35 24 5a 00 00    	pushl  0x5a24
    2a5a:	e8 f3 0c 00 00       	call   3752 <printf>
  oldbrk = sbrk(0);
    2a5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2a66:	e8 14 0c 00 00       	call   367f <sbrk>
    2a6b:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2a6e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2a75:	e8 05 0c 00 00       	call   367f <sbrk>
    2a7a:	89 c3                	mov    %eax,%ebx
    2a7c:	83 c4 10             	add    $0x10,%esp
  int i;
  for(i = 0; i < 5000; i++){
    2a7f:	be 00 00 00 00       	mov    $0x0,%esi
    b = sbrk(1);
    2a84:	83 ec 0c             	sub    $0xc,%esp
    2a87:	6a 01                	push   $0x1
    2a89:	e8 f1 0b 00 00       	call   367f <sbrk>
    if(b != a){
    2a8e:	83 c4 10             	add    $0x10,%esp
    2a91:	39 d8                	cmp    %ebx,%eax
    2a93:	74 1e                	je     2ab3 <sbrktest+0x6d>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2a95:	83 ec 0c             	sub    $0xc,%esp
    2a98:	50                   	push   %eax
    2a99:	53                   	push   %ebx
    2a9a:	56                   	push   %esi
    2a9b:	68 5b 48 00 00       	push   $0x485b
    2aa0:	ff 35 24 5a 00 00    	pushl  0x5a24
    2aa6:	e8 a7 0c 00 00       	call   3752 <printf>
      exit();
    2aab:	83 c4 20             	add    $0x20,%esp
    2aae:	e8 44 0b 00 00       	call   35f7 <exit>
    }
    *b = 1;
    2ab3:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + 1;
    2ab6:	83 c3 01             	add    $0x1,%ebx
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){
    2ab9:	83 c6 01             	add    $0x1,%esi
    2abc:	81 fe 88 13 00 00    	cmp    $0x1388,%esi
    2ac2:	75 c0                	jne    2a84 <sbrktest+0x3e>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    2ac4:	e8 26 0b 00 00       	call   35ef <fork>
    2ac9:	89 c6                	mov    %eax,%esi
  if(pid < 0){
    2acb:	85 c0                	test   %eax,%eax
    2acd:	79 18                	jns    2ae7 <sbrktest+0xa1>
    printf(stdout, "sbrk test fork failed\n");
    2acf:	83 ec 08             	sub    $0x8,%esp
    2ad2:	68 76 48 00 00       	push   $0x4876
    2ad7:	ff 35 24 5a 00 00    	pushl  0x5a24
    2add:	e8 70 0c 00 00       	call   3752 <printf>
    exit();
    2ae2:	e8 10 0b 00 00       	call   35f7 <exit>
  }
  c = sbrk(1);
    2ae7:	83 ec 0c             	sub    $0xc,%esp
    2aea:	6a 01                	push   $0x1
    2aec:	e8 8e 0b 00 00       	call   367f <sbrk>
  c = sbrk(1);
    2af1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af8:	e8 82 0b 00 00       	call   367f <sbrk>
  if(c != a + 1){
    2afd:	83 c3 01             	add    $0x1,%ebx
    2b00:	83 c4 10             	add    $0x10,%esp
    2b03:	39 d8                	cmp    %ebx,%eax
    2b05:	74 18                	je     2b1f <sbrktest+0xd9>
    printf(stdout, "sbrk test failed post-fork\n");
    2b07:	83 ec 08             	sub    $0x8,%esp
    2b0a:	68 8d 48 00 00       	push   $0x488d
    2b0f:	ff 35 24 5a 00 00    	pushl  0x5a24
    2b15:	e8 38 0c 00 00       	call   3752 <printf>
    exit();
    2b1a:	e8 d8 0a 00 00       	call   35f7 <exit>
  }
  if(pid == 0)
    2b1f:	85 f6                	test   %esi,%esi
    2b21:	75 05                	jne    2b28 <sbrktest+0xe2>
    exit();
    2b23:	e8 cf 0a 00 00       	call   35f7 <exit>
  wait();
    2b28:	e8 d2 0a 00 00       	call   35ff <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2b2d:	83 ec 0c             	sub    $0xc,%esp
    2b30:	6a 00                	push   $0x0
    2b32:	e8 48 0b 00 00       	call   367f <sbrk>
    2b37:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
  p = sbrk(amt);
    2b39:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2b3e:	29 d8                	sub    %ebx,%eax
    2b40:	89 04 24             	mov    %eax,(%esp)
    2b43:	e8 37 0b 00 00       	call   367f <sbrk>
  if (p != a) {
    2b48:	83 c4 10             	add    $0x10,%esp
    2b4b:	39 c3                	cmp    %eax,%ebx
    2b4d:	74 18                	je     2b67 <sbrktest+0x121>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2b4f:	83 ec 08             	sub    $0x8,%esp
    2b52:	68 d4 4f 00 00       	push   $0x4fd4
    2b57:	ff 35 24 5a 00 00    	pushl  0x5a24
    2b5d:	e8 f0 0b 00 00       	call   3752 <printf>
    exit();
    2b62:	e8 90 0a 00 00       	call   35f7 <exit>
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    2b67:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    2b6e:	83 ec 0c             	sub    $0xc,%esp
    2b71:	6a 00                	push   $0x0
    2b73:	e8 07 0b 00 00       	call   367f <sbrk>
    2b78:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2b7a:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2b81:	e8 f9 0a 00 00       	call   367f <sbrk>
  if(c == (char*)0xffffffff){
    2b86:	83 c4 10             	add    $0x10,%esp
    2b89:	83 f8 ff             	cmp    $0xffffffff,%eax
    2b8c:	75 18                	jne    2ba6 <sbrktest+0x160>
    printf(stdout, "sbrk could not deallocate\n");
    2b8e:	83 ec 08             	sub    $0x8,%esp
    2b91:	68 a9 48 00 00       	push   $0x48a9
    2b96:	ff 35 24 5a 00 00    	pushl  0x5a24
    2b9c:	e8 b1 0b 00 00       	call   3752 <printf>
    exit();
    2ba1:	e8 51 0a 00 00       	call   35f7 <exit>
  }
  c = sbrk(0);
    2ba6:	83 ec 0c             	sub    $0xc,%esp
    2ba9:	6a 00                	push   $0x0
    2bab:	e8 cf 0a 00 00       	call   367f <sbrk>
  if(c != a - 4096){
    2bb0:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2bb6:	83 c4 10             	add    $0x10,%esp
    2bb9:	39 d0                	cmp    %edx,%eax
    2bbb:	74 17                	je     2bd4 <sbrktest+0x18e>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2bbd:	50                   	push   %eax
    2bbe:	53                   	push   %ebx
    2bbf:	68 14 50 00 00       	push   $0x5014
    2bc4:	ff 35 24 5a 00 00    	pushl  0x5a24
    2bca:	e8 83 0b 00 00       	call   3752 <printf>
    exit();
    2bcf:	e8 23 0a 00 00       	call   35f7 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2bd4:	83 ec 0c             	sub    $0xc,%esp
    2bd7:	6a 00                	push   $0x0
    2bd9:	e8 a1 0a 00 00       	call   367f <sbrk>
    2bde:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    2be0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2be7:	e8 93 0a 00 00       	call   367f <sbrk>
    2bec:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    2bee:	83 c4 10             	add    $0x10,%esp
    2bf1:	39 c3                	cmp    %eax,%ebx
    2bf3:	75 17                	jne    2c0c <sbrktest+0x1c6>
    2bf5:	83 ec 0c             	sub    $0xc,%esp
    2bf8:	6a 00                	push   $0x0
    2bfa:	e8 80 0a 00 00       	call   367f <sbrk>
    2bff:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2c05:	83 c4 10             	add    $0x10,%esp
    2c08:	39 d0                	cmp    %edx,%eax
    2c0a:	74 17                	je     2c23 <sbrktest+0x1dd>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2c0c:	56                   	push   %esi
    2c0d:	53                   	push   %ebx
    2c0e:	68 4c 50 00 00       	push   $0x504c
    2c13:	ff 35 24 5a 00 00    	pushl  0x5a24
    2c19:	e8 34 0b 00 00       	call   3752 <printf>
    exit();
    2c1e:	e8 d4 09 00 00       	call   35f7 <exit>
  }
  if(*lastaddr == 99){
    2c23:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2c2a:	75 18                	jne    2c44 <sbrktest+0x1fe>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2c2c:	83 ec 08             	sub    $0x8,%esp
    2c2f:	68 74 50 00 00       	push   $0x5074
    2c34:	ff 35 24 5a 00 00    	pushl  0x5a24
    2c3a:	e8 13 0b 00 00       	call   3752 <printf>
    exit();
    2c3f:	e8 b3 09 00 00       	call   35f7 <exit>
  }

  a = sbrk(0);
    2c44:	83 ec 0c             	sub    $0xc,%esp
    2c47:	6a 00                	push   $0x0
    2c49:	e8 31 0a 00 00       	call   367f <sbrk>
    2c4e:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    2c50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2c57:	e8 23 0a 00 00       	call   367f <sbrk>
    2c5c:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
    2c5f:	29 c1                	sub    %eax,%ecx
    2c61:	89 0c 24             	mov    %ecx,(%esp)
    2c64:	e8 16 0a 00 00       	call   367f <sbrk>
  if(c != a){
    2c69:	83 c4 10             	add    $0x10,%esp
    2c6c:	39 c3                	cmp    %eax,%ebx
    2c6e:	74 17                	je     2c87 <sbrktest+0x241>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2c70:	50                   	push   %eax
    2c71:	53                   	push   %ebx
    2c72:	68 a4 50 00 00       	push   $0x50a4
    2c77:	ff 35 24 5a 00 00    	pushl  0x5a24
    2c7d:	e8 d0 0a 00 00       	call   3752 <printf>
    exit();
    2c82:	e8 70 09 00 00       	call   35f7 <exit>
    2c87:	bb 00 00 00 80       	mov    $0x80000000,%ebx
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
    2c8c:	e8 e6 09 00 00       	call   3677 <getpid>
    2c91:	89 c6                	mov    %eax,%esi
    pid = fork();
    2c93:	e8 57 09 00 00       	call   35ef <fork>
    if(pid < 0){
    2c98:	85 c0                	test   %eax,%eax
    2c9a:	79 18                	jns    2cb4 <sbrktest+0x26e>
      printf(stdout, "fork failed\n");
    2c9c:	83 ec 08             	sub    $0x8,%esp
    2c9f:	68 a1 49 00 00       	push   $0x49a1
    2ca4:	ff 35 24 5a 00 00    	pushl  0x5a24
    2caa:	e8 a3 0a 00 00       	call   3752 <printf>
      exit();
    2caf:	e8 43 09 00 00       	call   35f7 <exit>
    }
    if(pid == 0){
    2cb4:	85 c0                	test   %eax,%eax
    2cb6:	75 22                	jne    2cda <sbrktest+0x294>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2cb8:	0f be 03             	movsbl (%ebx),%eax
    2cbb:	50                   	push   %eax
    2cbc:	53                   	push   %ebx
    2cbd:	68 c4 48 00 00       	push   $0x48c4
    2cc2:	ff 35 24 5a 00 00    	pushl  0x5a24
    2cc8:	e8 85 0a 00 00       	call   3752 <printf>
      kill(ppid);
    2ccd:	89 34 24             	mov    %esi,(%esp)
    2cd0:	e8 52 09 00 00       	call   3627 <kill>
      exit();
    2cd5:	e8 1d 09 00 00       	call   35f7 <exit>
    }
    wait();
    2cda:	e8 20 09 00 00       	call   35ff <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2cdf:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    2ce5:	81 fb 80 84 1e 80    	cmp    $0x801e8480,%ebx
    2ceb:	75 9f                	jne    2c8c <sbrktest+0x246>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2ced:	83 ec 0c             	sub    $0xc,%esp
    2cf0:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2cf3:	50                   	push   %eax
    2cf4:	e8 0e 09 00 00       	call   3607 <pipe>
    2cf9:	83 c4 10             	add    $0x10,%esp
    2cfc:	85 c0                	test   %eax,%eax
    2cfe:	74 14                	je     2d14 <sbrktest+0x2ce>
    printf(1, "pipe() failed\n");
    2d00:	83 ec 08             	sub    $0x8,%esp
    2d03:	68 99 3d 00 00       	push   $0x3d99
    2d08:	6a 01                	push   $0x1
    2d0a:	e8 43 0a 00 00       	call   3752 <printf>
    exit();
    2d0f:	e8 e3 08 00 00       	call   35f7 <exit>
    2d14:	8d 5d b8             	lea    -0x48(%ebp),%ebx
    2d17:	8d 7d e0             	lea    -0x20(%ebp),%edi
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2d1a:	89 de                	mov    %ebx,%esi
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
    2d1c:	e8 ce 08 00 00       	call   35ef <fork>
    2d21:	89 06                	mov    %eax,(%esi)
    2d23:	85 c0                	test   %eax,%eax
    2d25:	75 40                	jne    2d67 <sbrktest+0x321>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    2d27:	83 ec 0c             	sub    $0xc,%esp
    2d2a:	6a 00                	push   $0x0
    2d2c:	e8 4e 09 00 00       	call   367f <sbrk>
    2d31:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2d36:	29 c2                	sub    %eax,%edx
    2d38:	89 14 24             	mov    %edx,(%esp)
    2d3b:	e8 3f 09 00 00       	call   367f <sbrk>
      write(fds[1], "x", 1);
    2d40:	83 c4 0c             	add    $0xc,%esp
    2d43:	6a 01                	push   $0x1
    2d45:	68 b9 43 00 00       	push   $0x43b9
    2d4a:	ff 75 e4             	pushl  -0x1c(%ebp)
    2d4d:	e8 c5 08 00 00       	call   3617 <write>
    2d52:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    2d55:	83 ec 0c             	sub    $0xc,%esp
    2d58:	68 e8 03 00 00       	push   $0x3e8
    2d5d:	e8 25 09 00 00       	call   3687 <sleep>
    2d62:	83 c4 10             	add    $0x10,%esp
    2d65:	eb ee                	jmp    2d55 <sbrktest+0x30f>
    }
    if(pids[i] != -1)
    2d67:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d6a:	74 14                	je     2d80 <sbrktest+0x33a>
      read(fds[0], &scratch, 1);
    2d6c:	83 ec 04             	sub    $0x4,%esp
    2d6f:	6a 01                	push   $0x1
    2d71:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2d74:	50                   	push   %eax
    2d75:	ff 75 e0             	pushl  -0x20(%ebp)
    2d78:	e8 92 08 00 00       	call   360f <read>
    2d7d:	83 c4 10             	add    $0x10,%esp
    2d80:	83 c6 04             	add    $0x4,%esi
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2d83:	39 f7                	cmp    %esi,%edi
    2d85:	75 95                	jne    2d1c <sbrktest+0x2d6>
    2d87:	eb 7d                	jmp    2e06 <sbrktest+0x3c0>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
    2d89:	8b 03                	mov    (%ebx),%eax
    2d8b:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d8e:	74 11                	je     2da1 <sbrktest+0x35b>
      continue;
    kill(pids[i]);
    2d90:	83 ec 0c             	sub    $0xc,%esp
    2d93:	50                   	push   %eax
    2d94:	e8 8e 08 00 00       	call   3627 <kill>
    wait();
    2d99:	e8 61 08 00 00       	call   35ff <wait>
    2d9e:	83 c4 10             	add    $0x10,%esp
    2da1:	83 c3 04             	add    $0x4,%ebx
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2da4:	39 fb                	cmp    %edi,%ebx
    2da6:	75 e1                	jne    2d89 <sbrktest+0x343>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    2da8:	83 fe ff             	cmp    $0xffffffff,%esi
    2dab:	75 18                	jne    2dc5 <sbrktest+0x37f>
    printf(stdout, "failed sbrk leaked memory\n");
    2dad:	83 ec 08             	sub    $0x8,%esp
    2db0:	68 dd 48 00 00       	push   $0x48dd
    2db5:	ff 35 24 5a 00 00    	pushl  0x5a24
    2dbb:	e8 92 09 00 00       	call   3752 <printf>
    exit();
    2dc0:	e8 32 08 00 00       	call   35f7 <exit>
  }

  if(sbrk(0) > oldbrk)
    2dc5:	83 ec 0c             	sub    $0xc,%esp
    2dc8:	6a 00                	push   $0x0
    2dca:	e8 b0 08 00 00       	call   367f <sbrk>
    2dcf:	83 c4 10             	add    $0x10,%esp
    2dd2:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
    2dd5:	73 1a                	jae    2df1 <sbrktest+0x3ab>
    sbrk(-(sbrk(0) - oldbrk));
    2dd7:	83 ec 0c             	sub    $0xc,%esp
    2dda:	6a 00                	push   $0x0
    2ddc:	e8 9e 08 00 00       	call   367f <sbrk>
    2de1:	8b 4d a4             	mov    -0x5c(%ebp),%ecx
    2de4:	29 c1                	sub    %eax,%ecx
    2de6:	89 0c 24             	mov    %ecx,(%esp)
    2de9:	e8 91 08 00 00       	call   367f <sbrk>
    2dee:	83 c4 10             	add    $0x10,%esp

  printf(stdout, "sbrk test OK\n");
    2df1:	83 ec 08             	sub    $0x8,%esp
    2df4:	68 f8 48 00 00       	push   $0x48f8
    2df9:	ff 35 24 5a 00 00    	pushl  0x5a24
    2dff:	e8 4e 09 00 00       	call   3752 <printf>
}
    2e04:	eb 17                	jmp    2e1d <sbrktest+0x3d7>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    2e06:	83 ec 0c             	sub    $0xc,%esp
    2e09:	68 00 10 00 00       	push   $0x1000
    2e0e:	e8 6c 08 00 00       	call   367f <sbrk>
    2e13:	89 c6                	mov    %eax,%esi
    2e15:	83 c4 10             	add    $0x10,%esp
    2e18:	e9 6c ff ff ff       	jmp    2d89 <sbrktest+0x343>

  if(sbrk(0) > oldbrk)
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
}
    2e1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2e20:	5b                   	pop    %ebx
    2e21:	5e                   	pop    %esi
    2e22:	5f                   	pop    %edi
    2e23:	5d                   	pop    %ebp
    2e24:	c3                   	ret    

00002e25 <validateint>:

void
validateint(int *p)
{
    2e25:	55                   	push   %ebp
    2e26:	89 e5                	mov    %esp,%ebp
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    2e28:	5d                   	pop    %ebp
    2e29:	c3                   	ret    

00002e2a <validatetest>:

void
validatetest(void)
{
    2e2a:	55                   	push   %ebp
    2e2b:	89 e5                	mov    %esp,%ebp
    2e2d:	56                   	push   %esi
    2e2e:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2e2f:	83 ec 08             	sub    $0x8,%esp
    2e32:	68 06 49 00 00       	push   $0x4906
    2e37:	ff 35 24 5a 00 00    	pushl  0x5a24
    2e3d:	e8 10 09 00 00       	call   3752 <printf>
    2e42:	83 c4 10             	add    $0x10,%esp
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    2e45:	bb 00 00 00 00       	mov    $0x0,%ebx
    if((pid = fork()) == 0){
    2e4a:	e8 a0 07 00 00       	call   35ef <fork>
    2e4f:	89 c6                	mov    %eax,%esi
    2e51:	85 c0                	test   %eax,%eax
    2e53:	75 05                	jne    2e5a <validatetest+0x30>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    2e55:	e8 9d 07 00 00       	call   35f7 <exit>
    }
    sleep(0);
    2e5a:	83 ec 0c             	sub    $0xc,%esp
    2e5d:	6a 00                	push   $0x0
    2e5f:	e8 23 08 00 00       	call   3687 <sleep>
    sleep(0);
    2e64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e6b:	e8 17 08 00 00       	call   3687 <sleep>
    kill(pid);
    2e70:	89 34 24             	mov    %esi,(%esp)
    2e73:	e8 af 07 00 00       	call   3627 <kill>
    wait();
    2e78:	e8 82 07 00 00       	call   35ff <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    2e7d:	83 c4 08             	add    $0x8,%esp
    2e80:	53                   	push   %ebx
    2e81:	68 15 49 00 00       	push   $0x4915
    2e86:	e8 cc 07 00 00       	call   3657 <link>
    2e8b:	83 c4 10             	add    $0x10,%esp
    2e8e:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e91:	74 18                	je     2eab <validatetest+0x81>
      printf(stdout, "link should not succeed\n");
    2e93:	83 ec 08             	sub    $0x8,%esp
    2e96:	68 20 49 00 00       	push   $0x4920
    2e9b:	ff 35 24 5a 00 00    	pushl  0x5a24
    2ea1:	e8 ac 08 00 00       	call   3752 <printf>
      exit();
    2ea6:	e8 4c 07 00 00       	call   35f7 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    2eab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    2eb1:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    2eb7:	75 91                	jne    2e4a <validatetest+0x20>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    2eb9:	83 ec 08             	sub    $0x8,%esp
    2ebc:	68 39 49 00 00       	push   $0x4939
    2ec1:	ff 35 24 5a 00 00    	pushl  0x5a24
    2ec7:	e8 86 08 00 00       	call   3752 <printf>
}
    2ecc:	83 c4 10             	add    $0x10,%esp
    2ecf:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2ed2:	5b                   	pop    %ebx
    2ed3:	5e                   	pop    %esi
    2ed4:	5d                   	pop    %ebp
    2ed5:	c3                   	ret    

00002ed6 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    2ed6:	55                   	push   %ebp
    2ed7:	89 e5                	mov    %esp,%ebp
    2ed9:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    2edc:	68 46 49 00 00       	push   $0x4946
    2ee1:	ff 35 24 5a 00 00    	pushl  0x5a24
    2ee7:	e8 66 08 00 00       	call   3752 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    if(uninit[i] != '\0'){
    2eec:	83 c4 10             	add    $0x10,%esp
    2eef:	80 3d e0 5a 00 00 00 	cmpb   $0x0,0x5ae0
    2ef6:	75 0f                	jne    2f07 <bsstest+0x31>
    2ef8:	b8 e1 5a 00 00       	mov    $0x5ae1,%eax
    2efd:	ba f0 81 00 00       	mov    $0x81f0,%edx
    2f02:	80 38 00             	cmpb   $0x0,(%eax)
    2f05:	74 18                	je     2f1f <bsstest+0x49>
      printf(stdout, "bss test failed\n");
    2f07:	83 ec 08             	sub    $0x8,%esp
    2f0a:	68 50 49 00 00       	push   $0x4950
    2f0f:	ff 35 24 5a 00 00    	pushl  0x5a24
    2f15:	e8 38 08 00 00       	call   3752 <printf>
      exit();
    2f1a:	e8 d8 06 00 00       	call   35f7 <exit>
    2f1f:	83 c0 01             	add    $0x1,%eax
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    2f22:	39 d0                	cmp    %edx,%eax
    2f24:	75 dc                	jne    2f02 <bsstest+0x2c>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    2f26:	83 ec 08             	sub    $0x8,%esp
    2f29:	68 61 49 00 00       	push   $0x4961
    2f2e:	ff 35 24 5a 00 00    	pushl  0x5a24
    2f34:	e8 19 08 00 00       	call   3752 <printf>
}
    2f39:	83 c4 10             	add    $0x10,%esp
    2f3c:	c9                   	leave  
    2f3d:	c3                   	ret    

00002f3e <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    2f3e:	55                   	push   %ebp
    2f3f:	89 e5                	mov    %esp,%ebp
    2f41:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    2f44:	68 6e 49 00 00       	push   $0x496e
    2f49:	e8 f9 06 00 00       	call   3647 <unlink>
  pid = fork();
    2f4e:	e8 9c 06 00 00       	call   35ef <fork>
  if(pid == 0){
    2f53:	83 c4 10             	add    $0x10,%esp
    2f56:	85 c0                	test   %eax,%eax
    2f58:	75 78                	jne    2fd2 <bigargtest+0x94>
    2f5a:	b8 40 5a 00 00       	mov    $0x5a40,%eax
    2f5f:	ba bc 5a 00 00       	mov    $0x5abc,%edx
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2f64:	c7 00 c8 50 00 00    	movl   $0x50c8,(%eax)
    2f6a:	83 c0 04             	add    $0x4,%eax
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    2f6d:	39 d0                	cmp    %edx,%eax
    2f6f:	75 f3                	jne    2f64 <bigargtest+0x26>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    2f71:	c7 05 bc 5a 00 00 00 	movl   $0x0,0x5abc
    2f78:	00 00 00 
    printf(stdout, "bigarg test\n");
    2f7b:	83 ec 08             	sub    $0x8,%esp
    2f7e:	68 78 49 00 00       	push   $0x4978
    2f83:	ff 35 24 5a 00 00    	pushl  0x5a24
    2f89:	e8 c4 07 00 00       	call   3752 <printf>
    exec("echo", args);
    2f8e:	83 c4 08             	add    $0x8,%esp
    2f91:	68 40 5a 00 00       	push   $0x5a40
    2f96:	68 45 3b 00 00       	push   $0x3b45
    2f9b:	e8 8f 06 00 00       	call   362f <exec>
    printf(stdout, "bigarg test ok\n");
    2fa0:	83 c4 08             	add    $0x8,%esp
    2fa3:	68 85 49 00 00       	push   $0x4985
    2fa8:	ff 35 24 5a 00 00    	pushl  0x5a24
    2fae:	e8 9f 07 00 00       	call   3752 <printf>
    fd = open("bigarg-ok", O_CREATE);
    2fb3:	83 c4 08             	add    $0x8,%esp
    2fb6:	68 00 02 00 00       	push   $0x200
    2fbb:	68 6e 49 00 00       	push   $0x496e
    2fc0:	e8 72 06 00 00       	call   3637 <open>
    close(fd);
    2fc5:	89 04 24             	mov    %eax,(%esp)
    2fc8:	e8 52 06 00 00       	call   361f <close>
    exit();
    2fcd:	e8 25 06 00 00       	call   35f7 <exit>
  } else if(pid < 0){
    2fd2:	85 c0                	test   %eax,%eax
    2fd4:	79 18                	jns    2fee <bigargtest+0xb0>
    printf(stdout, "bigargtest: fork failed\n");
    2fd6:	83 ec 08             	sub    $0x8,%esp
    2fd9:	68 95 49 00 00       	push   $0x4995
    2fde:	ff 35 24 5a 00 00    	pushl  0x5a24
    2fe4:	e8 69 07 00 00       	call   3752 <printf>
    exit();
    2fe9:	e8 09 06 00 00       	call   35f7 <exit>
  }
  wait();
    2fee:	e8 0c 06 00 00       	call   35ff <wait>
  fd = open("bigarg-ok", 0);
    2ff3:	83 ec 08             	sub    $0x8,%esp
    2ff6:	6a 00                	push   $0x0
    2ff8:	68 6e 49 00 00       	push   $0x496e
    2ffd:	e8 35 06 00 00       	call   3637 <open>
  if(fd < 0){
    3002:	83 c4 10             	add    $0x10,%esp
    3005:	85 c0                	test   %eax,%eax
    3007:	79 18                	jns    3021 <bigargtest+0xe3>
    printf(stdout, "bigarg test failed!\n");
    3009:	83 ec 08             	sub    $0x8,%esp
    300c:	68 ae 49 00 00       	push   $0x49ae
    3011:	ff 35 24 5a 00 00    	pushl  0x5a24
    3017:	e8 36 07 00 00       	call   3752 <printf>
    exit();
    301c:	e8 d6 05 00 00       	call   35f7 <exit>
  }
  close(fd);
    3021:	83 ec 0c             	sub    $0xc,%esp
    3024:	50                   	push   %eax
    3025:	e8 f5 05 00 00       	call   361f <close>
  unlink("bigarg-ok");
    302a:	c7 04 24 6e 49 00 00 	movl   $0x496e,(%esp)
    3031:	e8 11 06 00 00       	call   3647 <unlink>
}
    3036:	83 c4 10             	add    $0x10,%esp
    3039:	c9                   	leave  
    303a:	c3                   	ret    

0000303b <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    303b:	55                   	push   %ebp
    303c:	89 e5                	mov    %esp,%ebp
    303e:	57                   	push   %edi
    303f:	56                   	push   %esi
    3040:	53                   	push   %ebx
    3041:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    3044:	68 c3 49 00 00       	push   $0x49c3
    3049:	6a 01                	push   $0x1
    304b:	e8 02 07 00 00       	call   3752 <printf>
    3050:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    3053:	be 00 00 00 00       	mov    $0x0,%esi
    char name[64];
    name[0] = 'f';
    3058:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    305c:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3061:	f7 ee                	imul   %esi
    3063:	c1 fa 06             	sar    $0x6,%edx
    3066:	89 f3                	mov    %esi,%ebx
    3068:	c1 fb 1f             	sar    $0x1f,%ebx
    306b:	29 da                	sub    %ebx,%edx
    306d:	8d 42 30             	lea    0x30(%edx),%eax
    3070:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3073:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    3079:	89 f7                	mov    %esi,%edi
    307b:	29 d7                	sub    %edx,%edi
    307d:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3082:	89 f8                	mov    %edi,%eax
    3084:	f7 e9                	imul   %ecx
    3086:	c1 fa 05             	sar    $0x5,%edx
    3089:	c1 ff 1f             	sar    $0x1f,%edi
    308c:	29 fa                	sub    %edi,%edx
    308e:	83 c2 30             	add    $0x30,%edx
    3091:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3094:	89 f0                	mov    %esi,%eax
    3096:	f7 e9                	imul   %ecx
    3098:	c1 fa 05             	sar    $0x5,%edx
    309b:	29 da                	sub    %ebx,%edx
    309d:	6b d2 64             	imul   $0x64,%edx,%edx
    30a0:	89 f7                	mov    %esi,%edi
    30a2:	29 d7                	sub    %edx,%edi
    30a4:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    30a9:	89 f8                	mov    %edi,%eax
    30ab:	f7 e9                	imul   %ecx
    30ad:	c1 fa 02             	sar    $0x2,%edx
    30b0:	c1 ff 1f             	sar    $0x1f,%edi
    30b3:	29 fa                	sub    %edi,%edx
    30b5:	83 c2 30             	add    $0x30,%edx
    30b8:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    30bb:	89 f0                	mov    %esi,%eax
    30bd:	f7 e9                	imul   %ecx
    30bf:	c1 fa 02             	sar    $0x2,%edx
    30c2:	29 da                	sub    %ebx,%edx
    30c4:	8d 04 92             	lea    (%edx,%edx,4),%eax
    30c7:	01 c0                	add    %eax,%eax
    30c9:	89 f1                	mov    %esi,%ecx
    30cb:	29 c1                	sub    %eax,%ecx
    30cd:	89 c8                	mov    %ecx,%eax
    30cf:	83 c0 30             	add    $0x30,%eax
    30d2:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    30d5:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    30d9:	83 ec 04             	sub    $0x4,%esp
    30dc:	8d 45 a8             	lea    -0x58(%ebp),%eax
    30df:	50                   	push   %eax
    30e0:	68 d0 49 00 00       	push   $0x49d0
    30e5:	6a 01                	push   $0x1
    30e7:	e8 66 06 00 00       	call   3752 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    30ec:	83 c4 08             	add    $0x8,%esp
    30ef:	68 02 02 00 00       	push   $0x202
    30f4:	8d 45 a8             	lea    -0x58(%ebp),%eax
    30f7:	50                   	push   %eax
    30f8:	e8 3a 05 00 00       	call   3637 <open>
    30fd:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    30ff:	83 c4 10             	add    $0x10,%esp
    3102:	85 c0                	test   %eax,%eax
    3104:	79 18                	jns    311e <fsfull+0xe3>
      printf(1, "open %s failed\n", name);
    3106:	83 ec 04             	sub    $0x4,%esp
    3109:	8d 45 a8             	lea    -0x58(%ebp),%eax
    310c:	50                   	push   %eax
    310d:	68 dc 49 00 00       	push   $0x49dc
    3112:	6a 01                	push   $0x1
    3114:	e8 39 06 00 00       	call   3752 <printf>
      break;
    3119:	83 c4 10             	add    $0x10,%esp
    311c:	eb 4d                	jmp    316b <fsfull+0x130>
    311e:	bb 00 00 00 00       	mov    $0x0,%ebx
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
    3123:	83 ec 04             	sub    $0x4,%esp
    3126:	68 00 02 00 00       	push   $0x200
    312b:	68 00 82 00 00       	push   $0x8200
    3130:	57                   	push   %edi
    3131:	e8 e1 04 00 00       	call   3617 <write>
      if(cc < 512)
    3136:	83 c4 10             	add    $0x10,%esp
    3139:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    313e:	7e 04                	jle    3144 <fsfull+0x109>
        break;
      total += cc;
    3140:	01 c3                	add    %eax,%ebx
      fsblocks++;
    }
    3142:	eb df                	jmp    3123 <fsfull+0xe8>
    printf(1, "wrote %d bytes\n", total);
    3144:	83 ec 04             	sub    $0x4,%esp
    3147:	53                   	push   %ebx
    3148:	68 ec 49 00 00       	push   $0x49ec
    314d:	6a 01                	push   $0x1
    314f:	e8 fe 05 00 00       	call   3752 <printf>
    close(fd);
    3154:	89 3c 24             	mov    %edi,(%esp)
    3157:	e8 c3 04 00 00       	call   361f <close>
    if(total == 0)
    315c:	83 c4 10             	add    $0x10,%esp
    315f:	85 db                	test   %ebx,%ebx
    3161:	74 08                	je     316b <fsfull+0x130>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    3163:	83 c6 01             	add    $0x1,%esi
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    3166:	e9 ed fe ff ff       	jmp    3058 <fsfull+0x1d>

  while(nfiles >= 0){
    316b:	85 f6                	test   %esi,%esi
    316d:	0f 88 9c 00 00 00    	js     320f <fsfull+0x1d4>
    char name[64];
    name[0] = 'f';
    3173:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3177:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    317c:	f7 ee                	imul   %esi
    317e:	c1 fa 06             	sar    $0x6,%edx
    3181:	89 f3                	mov    %esi,%ebx
    3183:	c1 fb 1f             	sar    $0x1f,%ebx
    3186:	29 da                	sub    %ebx,%edx
    3188:	8d 42 30             	lea    0x30(%edx),%eax
    318b:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    318e:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    3194:	89 f7                	mov    %esi,%edi
    3196:	29 d7                	sub    %edx,%edi
    3198:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    319d:	89 f8                	mov    %edi,%eax
    319f:	f7 e9                	imul   %ecx
    31a1:	c1 fa 05             	sar    $0x5,%edx
    31a4:	c1 ff 1f             	sar    $0x1f,%edi
    31a7:	29 fa                	sub    %edi,%edx
    31a9:	83 c2 30             	add    $0x30,%edx
    31ac:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    31af:	89 f0                	mov    %esi,%eax
    31b1:	f7 e9                	imul   %ecx
    31b3:	c1 fa 05             	sar    $0x5,%edx
    31b6:	29 da                	sub    %ebx,%edx
    31b8:	6b d2 64             	imul   $0x64,%edx,%edx
    31bb:	89 f7                	mov    %esi,%edi
    31bd:	29 d7                	sub    %edx,%edi
    31bf:	b9 67 66 66 66       	mov    $0x66666667,%ecx
    31c4:	89 f8                	mov    %edi,%eax
    31c6:	f7 e9                	imul   %ecx
    31c8:	c1 fa 02             	sar    $0x2,%edx
    31cb:	c1 ff 1f             	sar    $0x1f,%edi
    31ce:	29 fa                	sub    %edi,%edx
    31d0:	83 c2 30             	add    $0x30,%edx
    31d3:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    31d6:	89 f0                	mov    %esi,%eax
    31d8:	f7 e9                	imul   %ecx
    31da:	c1 fa 02             	sar    $0x2,%edx
    31dd:	29 da                	sub    %ebx,%edx
    31df:	8d 04 92             	lea    (%edx,%edx,4),%eax
    31e2:	01 c0                	add    %eax,%eax
    31e4:	89 f1                	mov    %esi,%ecx
    31e6:	29 c1                	sub    %eax,%ecx
    31e8:	89 c8                	mov    %ecx,%eax
    31ea:	83 c0 30             	add    $0x30,%eax
    31ed:	88 45 ac             	mov    %al,-0x54(%ebp)
    name[5] = '\0';
    31f0:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    31f4:	83 ec 0c             	sub    $0xc,%esp
    31f7:	8d 45 a8             	lea    -0x58(%ebp),%eax
    31fa:	50                   	push   %eax
    31fb:	e8 47 04 00 00       	call   3647 <unlink>
    nfiles--;
    3200:	83 ee 01             	sub    $0x1,%esi
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3203:	83 c4 10             	add    $0x10,%esp
    3206:	83 fe ff             	cmp    $0xffffffff,%esi
    3209:	0f 85 64 ff ff ff    	jne    3173 <fsfull+0x138>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    320f:	83 ec 08             	sub    $0x8,%esp
    3212:	68 fc 49 00 00       	push   $0x49fc
    3217:	6a 01                	push   $0x1
    3219:	e8 34 05 00 00       	call   3752 <printf>
}
    321e:	83 c4 10             	add    $0x10,%esp
    3221:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3224:	5b                   	pop    %ebx
    3225:	5e                   	pop    %esi
    3226:	5f                   	pop    %edi
    3227:	5d                   	pop    %ebp
    3228:	c3                   	ret    

00003229 <uio>:

void
uio()
{
    3229:	55                   	push   %ebp
    322a:	89 e5                	mov    %esp,%ebp
    322c:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    322f:	68 12 4a 00 00       	push   $0x4a12
    3234:	6a 01                	push   $0x1
    3236:	e8 17 05 00 00       	call   3752 <printf>
  pid = fork();
    323b:	e8 af 03 00 00       	call   35ef <fork>
  if(pid == 0){
    3240:	83 c4 10             	add    $0x10,%esp
    3243:	85 c0                	test   %eax,%eax
    3245:	75 25                	jne    326c <uio+0x43>
    port = RTC_ADDR;
    val = 0x09;  /* year */
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3247:	ba 70 00 00 00       	mov    $0x70,%edx
    324c:	b8 09 00 00 00       	mov    $0x9,%eax
    3251:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3252:	ba 71 00 00 00       	mov    $0x71,%edx
    3257:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    3258:	83 ec 08             	sub    $0x8,%esp
    325b:	68 a8 51 00 00       	push   $0x51a8
    3260:	6a 01                	push   $0x1
    3262:	e8 eb 04 00 00       	call   3752 <printf>
    exit();
    3267:	e8 8b 03 00 00       	call   35f7 <exit>
  } else if(pid < 0){
    326c:	85 c0                	test   %eax,%eax
    326e:	79 14                	jns    3284 <uio+0x5b>
    printf (1, "fork failed\n");
    3270:	83 ec 08             	sub    $0x8,%esp
    3273:	68 a1 49 00 00       	push   $0x49a1
    3278:	6a 01                	push   $0x1
    327a:	e8 d3 04 00 00       	call   3752 <printf>
    exit();
    327f:	e8 73 03 00 00       	call   35f7 <exit>
  }
  wait();
    3284:	e8 76 03 00 00       	call   35ff <wait>
  printf(1, "uio test done\n");
    3289:	83 ec 08             	sub    $0x8,%esp
    328c:	68 1c 4a 00 00       	push   $0x4a1c
    3291:	6a 01                	push   $0x1
    3293:	e8 ba 04 00 00       	call   3752 <printf>
}
    3298:	83 c4 10             	add    $0x10,%esp
    329b:	c9                   	leave  
    329c:	c3                   	ret    

0000329d <argptest>:

void argptest()
{
    329d:	55                   	push   %ebp
    329e:	89 e5                	mov    %esp,%ebp
    32a0:	53                   	push   %ebx
    32a1:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    32a4:	6a 00                	push   $0x0
    32a6:	68 2b 4a 00 00       	push   $0x4a2b
    32ab:	e8 87 03 00 00       	call   3637 <open>
  if (fd < 0) {
    32b0:	83 c4 10             	add    $0x10,%esp
    32b3:	85 c0                	test   %eax,%eax
    32b5:	79 14                	jns    32cb <argptest+0x2e>
    printf(2, "open failed\n");
    32b7:	83 ec 08             	sub    $0x8,%esp
    32ba:	68 30 4a 00 00       	push   $0x4a30
    32bf:	6a 02                	push   $0x2
    32c1:	e8 8c 04 00 00       	call   3752 <printf>
    exit();
    32c6:	e8 2c 03 00 00       	call   35f7 <exit>
    32cb:	89 c3                	mov    %eax,%ebx
  }
  read(fd, sbrk(0) - 1, -1);
    32cd:	83 ec 0c             	sub    $0xc,%esp
    32d0:	6a 00                	push   $0x0
    32d2:	e8 a8 03 00 00       	call   367f <sbrk>
    32d7:	83 c4 0c             	add    $0xc,%esp
    32da:	6a ff                	push   $0xffffffff
    32dc:	83 e8 01             	sub    $0x1,%eax
    32df:	50                   	push   %eax
    32e0:	53                   	push   %ebx
    32e1:	e8 29 03 00 00       	call   360f <read>
  close(fd);
    32e6:	89 1c 24             	mov    %ebx,(%esp)
    32e9:	e8 31 03 00 00       	call   361f <close>
  printf(1, "arg test passed\n");
    32ee:	83 c4 08             	add    $0x8,%esp
    32f1:	68 3d 4a 00 00       	push   $0x4a3d
    32f6:	6a 01                	push   $0x1
    32f8:	e8 55 04 00 00       	call   3752 <printf>
}
    32fd:	83 c4 10             	add    $0x10,%esp
    3300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3303:	c9                   	leave  
    3304:	c3                   	ret    

00003305 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3305:	55                   	push   %ebp
    3306:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3308:	69 05 20 5a 00 00 0d 	imul   $0x19660d,0x5a20,%eax
    330f:	66 19 00 
    3312:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3317:	a3 20 5a 00 00       	mov    %eax,0x5a20
  return randstate;
}
    331c:	5d                   	pop    %ebp
    331d:	c3                   	ret    

0000331e <main>:

int
main(int argc, char *argv[])
{
    331e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3322:	83 e4 f0             	and    $0xfffffff0,%esp
    3325:	ff 71 fc             	pushl  -0x4(%ecx)
    3328:	55                   	push   %ebp
    3329:	89 e5                	mov    %esp,%ebp
    332b:	51                   	push   %ecx
    332c:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    332f:	68 4e 4a 00 00       	push   $0x4a4e
    3334:	6a 01                	push   $0x1
    3336:	e8 17 04 00 00       	call   3752 <printf>

  if(open("usertests.ran", 0) >= 0){
    333b:	83 c4 08             	add    $0x8,%esp
    333e:	6a 00                	push   $0x0
    3340:	68 62 4a 00 00       	push   $0x4a62
    3345:	e8 ed 02 00 00       	call   3637 <open>
    334a:	83 c4 10             	add    $0x10,%esp
    334d:	85 c0                	test   %eax,%eax
    334f:	78 14                	js     3365 <main+0x47>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3351:	83 ec 08             	sub    $0x8,%esp
    3354:	68 cc 51 00 00       	push   $0x51cc
    3359:	6a 01                	push   $0x1
    335b:	e8 f2 03 00 00       	call   3752 <printf>
    exit();
    3360:	e8 92 02 00 00       	call   35f7 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3365:	83 ec 08             	sub    $0x8,%esp
    3368:	68 00 02 00 00       	push   $0x200
    336d:	68 62 4a 00 00       	push   $0x4a62
    3372:	e8 c0 02 00 00       	call   3637 <open>
    3377:	89 04 24             	mov    %eax,(%esp)
    337a:	e8 a0 02 00 00       	call   361f <close>

  argptest();
    337f:	e8 19 ff ff ff       	call   329d <argptest>
  createdelete();
    3384:	e8 8c dc ff ff       	call   1015 <createdelete>
  linkunlink();
    3389:	e8 fb e4 ff ff       	call   1889 <linkunlink>
  concreate();
    338e:	e8 05 e2 ff ff       	call   1598 <concreate>
  fourfiles();
    3393:	e8 82 da ff ff       	call   e1a <fourfiles>
  sharedfd();
    3398:	e8 e5 d8 ff ff       	call   c82 <sharedfd>

  bigargtest();
    339d:	e8 9c fb ff ff       	call   2f3e <bigargtest>
  bigwrite();
    33a2:	e8 b9 ed ff ff       	call   2160 <bigwrite>
  bigargtest();
    33a7:	e8 92 fb ff ff       	call   2f3e <bigargtest>
  bsstest();
    33ac:	e8 25 fb ff ff       	call   2ed6 <bsstest>
  sbrktest();
    33b1:	e8 90 f6 ff ff       	call   2a46 <sbrktest>
  validatetest();
    33b6:	e8 6f fa ff ff       	call   2e2a <validatetest>

  opentest();
    33bb:	e8 f0 ce ff ff       	call   2b0 <opentest>
  writetest();
    33c0:	e8 7e cf ff ff       	call   343 <writetest>
  writetest1();
    33c5:	e8 45 d1 ff ff       	call   50f <writetest1>
  createtest();
    33ca:	e8 ed d2 ff ff       	call   6bc <createtest>

  openiputtest();
    33cf:	e8 f1 cd ff ff       	call   1c5 <openiputtest>
  exitiputtest();
    33d4:	e8 04 cd ff ff       	call   dd <exitiputtest>
  iputtest();
    33d9:	e8 22 cc ff ff       	call   0 <iputtest>

  mem();
    33de:	e8 e6 d7 ff ff       	call   bc9 <mem>
  pipe1();
    33e3:	e8 9e d4 ff ff       	call   886 <pipe1>
  preempt();
    33e8:	e8 36 d6 ff ff       	call   a23 <preempt>
  exitwait();
    33ed:	e8 6a d7 ff ff       	call   b5c <exitwait>

  rmdot();
    33f2:	e8 34 f1 ff ff       	call   252b <rmdot>
  fourteen();
    33f7:	e8 02 f0 ff ff       	call   23fe <fourteen>
  bigfile();
    33fc:	e8 40 ee ff ff       	call   2241 <bigfile>
  subdir();
    3401:	e8 c4 e6 ff ff       	call   1aca <subdir>
  linktest();
    3406:	e8 8b df ff ff       	call   1396 <linktest>
  unlinkread();
    340b:	e8 05 de ff ff       	call   1215 <unlinkread>
  dirfile();
    3410:	e8 7b f2 ff ff       	call   2690 <dirfile>
  iref();
    3415:	e8 68 f4 ff ff       	call   2882 <iref>
  forktest();
    341a:	e8 74 f5 ff ff       	call   2993 <forktest>
  bigdir(); // slow
    341f:	e8 53 e5 ff ff       	call   1977 <bigdir>

  uio();
    3424:	e8 00 fe ff ff       	call   3229 <uio>

  exectest();
    3429:	e8 0f d4 ff ff       	call   83d <exectest>

  exit();
    342e:	e8 c4 01 00 00       	call   35f7 <exit>

00003433 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    3433:	55                   	push   %ebp
    3434:	89 e5                	mov    %esp,%ebp
    3436:	53                   	push   %ebx
    3437:	8b 45 08             	mov    0x8(%ebp),%eax
    343a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    343d:	89 c2                	mov    %eax,%edx
    343f:	83 c2 01             	add    $0x1,%edx
    3442:	83 c1 01             	add    $0x1,%ecx
    3445:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    3449:	88 5a ff             	mov    %bl,-0x1(%edx)
    344c:	84 db                	test   %bl,%bl
    344e:	75 ef                	jne    343f <strcpy+0xc>
    ;
  return os;
}
    3450:	5b                   	pop    %ebx
    3451:	5d                   	pop    %ebp
    3452:	c3                   	ret    

00003453 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3453:	55                   	push   %ebp
    3454:	89 e5                	mov    %esp,%ebp
    3456:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3459:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    345c:	0f b6 01             	movzbl (%ecx),%eax
    345f:	84 c0                	test   %al,%al
    3461:	74 15                	je     3478 <strcmp+0x25>
    3463:	3a 02                	cmp    (%edx),%al
    3465:	75 11                	jne    3478 <strcmp+0x25>
    p++, q++;
    3467:	83 c1 01             	add    $0x1,%ecx
    346a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    346d:	0f b6 01             	movzbl (%ecx),%eax
    3470:	84 c0                	test   %al,%al
    3472:	74 04                	je     3478 <strcmp+0x25>
    3474:	3a 02                	cmp    (%edx),%al
    3476:	74 ef                	je     3467 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3478:	0f b6 c0             	movzbl %al,%eax
    347b:	0f b6 12             	movzbl (%edx),%edx
    347e:	29 d0                	sub    %edx,%eax
}
    3480:	5d                   	pop    %ebp
    3481:	c3                   	ret    

00003482 <strlen>:

uint
strlen(char *s)
{
    3482:	55                   	push   %ebp
    3483:	89 e5                	mov    %esp,%ebp
    3485:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3488:	80 39 00             	cmpb   $0x0,(%ecx)
    348b:	74 12                	je     349f <strlen+0x1d>
    348d:	ba 00 00 00 00       	mov    $0x0,%edx
    3492:	83 c2 01             	add    $0x1,%edx
    3495:	89 d0                	mov    %edx,%eax
    3497:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    349b:	75 f5                	jne    3492 <strlen+0x10>
    349d:	eb 05                	jmp    34a4 <strlen+0x22>
    349f:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
    34a4:	5d                   	pop    %ebp
    34a5:	c3                   	ret    

000034a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    34a6:	55                   	push   %ebp
    34a7:	89 e5                	mov    %esp,%ebp
    34a9:	57                   	push   %edi
    34aa:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    34ad:	89 d7                	mov    %edx,%edi
    34af:	8b 4d 10             	mov    0x10(%ebp),%ecx
    34b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    34b5:	fc                   	cld    
    34b6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    34b8:	89 d0                	mov    %edx,%eax
    34ba:	5f                   	pop    %edi
    34bb:	5d                   	pop    %ebp
    34bc:	c3                   	ret    

000034bd <strchr>:

char*
strchr(const char *s, char c)
{
    34bd:	55                   	push   %ebp
    34be:	89 e5                	mov    %esp,%ebp
    34c0:	53                   	push   %ebx
    34c1:	8b 45 08             	mov    0x8(%ebp),%eax
    34c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    34c7:	0f b6 10             	movzbl (%eax),%edx
    34ca:	84 d2                	test   %dl,%dl
    34cc:	74 1d                	je     34eb <strchr+0x2e>
    34ce:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
    34d0:	38 d3                	cmp    %dl,%bl
    34d2:	75 06                	jne    34da <strchr+0x1d>
    34d4:	eb 1a                	jmp    34f0 <strchr+0x33>
    34d6:	38 ca                	cmp    %cl,%dl
    34d8:	74 16                	je     34f0 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    34da:	83 c0 01             	add    $0x1,%eax
    34dd:	0f b6 10             	movzbl (%eax),%edx
    34e0:	84 d2                	test   %dl,%dl
    34e2:	75 f2                	jne    34d6 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
    34e4:	b8 00 00 00 00       	mov    $0x0,%eax
    34e9:	eb 05                	jmp    34f0 <strchr+0x33>
    34eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    34f0:	5b                   	pop    %ebx
    34f1:	5d                   	pop    %ebp
    34f2:	c3                   	ret    

000034f3 <gets>:

char*
gets(char *buf, int max)
{
    34f3:	55                   	push   %ebp
    34f4:	89 e5                	mov    %esp,%ebp
    34f6:	57                   	push   %edi
    34f7:	56                   	push   %esi
    34f8:	53                   	push   %ebx
    34f9:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    34fc:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    3501:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3504:	eb 29                	jmp    352f <gets+0x3c>
    cc = read(0, &c, 1);
    3506:	83 ec 04             	sub    $0x4,%esp
    3509:	6a 01                	push   $0x1
    350b:	57                   	push   %edi
    350c:	6a 00                	push   $0x0
    350e:	e8 fc 00 00 00       	call   360f <read>
    if(cc < 1)
    3513:	83 c4 10             	add    $0x10,%esp
    3516:	85 c0                	test   %eax,%eax
    3518:	7e 21                	jle    353b <gets+0x48>
      break;
    buf[i++] = c;
    351a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    351e:	8b 55 08             	mov    0x8(%ebp),%edx
    3521:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3525:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    3527:	3c 0a                	cmp    $0xa,%al
    3529:	74 0e                	je     3539 <gets+0x46>
    352b:	3c 0d                	cmp    $0xd,%al
    352d:	74 0a                	je     3539 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    352f:	8d 5e 01             	lea    0x1(%esi),%ebx
    3532:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3535:	7c cf                	jl     3506 <gets+0x13>
    3537:	eb 02                	jmp    353b <gets+0x48>
    3539:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    353b:	8b 45 08             	mov    0x8(%ebp),%eax
    353e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    3542:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3545:	5b                   	pop    %ebx
    3546:	5e                   	pop    %esi
    3547:	5f                   	pop    %edi
    3548:	5d                   	pop    %ebp
    3549:	c3                   	ret    

0000354a <stat>:

int
stat(char *n, struct stat *st)
{
    354a:	55                   	push   %ebp
    354b:	89 e5                	mov    %esp,%ebp
    354d:	56                   	push   %esi
    354e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    354f:	83 ec 08             	sub    $0x8,%esp
    3552:	6a 00                	push   $0x0
    3554:	ff 75 08             	pushl  0x8(%ebp)
    3557:	e8 db 00 00 00       	call   3637 <open>
  if(fd < 0)
    355c:	83 c4 10             	add    $0x10,%esp
    355f:	85 c0                	test   %eax,%eax
    3561:	78 1f                	js     3582 <stat+0x38>
    3563:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    3565:	83 ec 08             	sub    $0x8,%esp
    3568:	ff 75 0c             	pushl  0xc(%ebp)
    356b:	50                   	push   %eax
    356c:	e8 de 00 00 00       	call   364f <fstat>
    3571:	89 c6                	mov    %eax,%esi
  close(fd);
    3573:	89 1c 24             	mov    %ebx,(%esp)
    3576:	e8 a4 00 00 00       	call   361f <close>
  return r;
    357b:	83 c4 10             	add    $0x10,%esp
    357e:	89 f0                	mov    %esi,%eax
    3580:	eb 05                	jmp    3587 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    3582:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
    3587:	8d 65 f8             	lea    -0x8(%ebp),%esp
    358a:	5b                   	pop    %ebx
    358b:	5e                   	pop    %esi
    358c:	5d                   	pop    %ebp
    358d:	c3                   	ret    

0000358e <atoi>:

int
atoi(const char *s)
{
    358e:	55                   	push   %ebp
    358f:	89 e5                	mov    %esp,%ebp
    3591:	53                   	push   %ebx
    3592:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3595:	0f b6 11             	movzbl (%ecx),%edx
    3598:	8d 42 d0             	lea    -0x30(%edx),%eax
    359b:	3c 09                	cmp    $0x9,%al
    359d:	77 1f                	ja     35be <atoi+0x30>
    359f:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    35a4:	83 c1 01             	add    $0x1,%ecx
    35a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
    35aa:	0f be d2             	movsbl %dl,%edx
    35ad:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    35b1:	0f b6 11             	movzbl (%ecx),%edx
    35b4:	8d 5a d0             	lea    -0x30(%edx),%ebx
    35b7:	80 fb 09             	cmp    $0x9,%bl
    35ba:	76 e8                	jbe    35a4 <atoi+0x16>
    35bc:	eb 05                	jmp    35c3 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
    35be:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
    35c3:	5b                   	pop    %ebx
    35c4:	5d                   	pop    %ebp
    35c5:	c3                   	ret    

000035c6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    35c6:	55                   	push   %ebp
    35c7:	89 e5                	mov    %esp,%ebp
    35c9:	56                   	push   %esi
    35ca:	53                   	push   %ebx
    35cb:	8b 45 08             	mov    0x8(%ebp),%eax
    35ce:	8b 75 0c             	mov    0xc(%ebp),%esi
    35d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    35d4:	85 db                	test   %ebx,%ebx
    35d6:	7e 13                	jle    35eb <memmove+0x25>
    35d8:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    35dd:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    35e1:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    35e4:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    35e7:	39 da                	cmp    %ebx,%edx
    35e9:	75 f2                	jne    35dd <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
    35eb:	5b                   	pop    %ebx
    35ec:	5e                   	pop    %esi
    35ed:	5d                   	pop    %ebp
    35ee:	c3                   	ret    

000035ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    35ef:	b8 01 00 00 00       	mov    $0x1,%eax
    35f4:	cd 40                	int    $0x40
    35f6:	c3                   	ret    

000035f7 <exit>:
SYSCALL(exit)
    35f7:	b8 02 00 00 00       	mov    $0x2,%eax
    35fc:	cd 40                	int    $0x40
    35fe:	c3                   	ret    

000035ff <wait>:
SYSCALL(wait)
    35ff:	b8 03 00 00 00       	mov    $0x3,%eax
    3604:	cd 40                	int    $0x40
    3606:	c3                   	ret    

00003607 <pipe>:
SYSCALL(pipe)
    3607:	b8 04 00 00 00       	mov    $0x4,%eax
    360c:	cd 40                	int    $0x40
    360e:	c3                   	ret    

0000360f <read>:
SYSCALL(read)
    360f:	b8 05 00 00 00       	mov    $0x5,%eax
    3614:	cd 40                	int    $0x40
    3616:	c3                   	ret    

00003617 <write>:
SYSCALL(write)
    3617:	b8 10 00 00 00       	mov    $0x10,%eax
    361c:	cd 40                	int    $0x40
    361e:	c3                   	ret    

0000361f <close>:
SYSCALL(close)
    361f:	b8 15 00 00 00       	mov    $0x15,%eax
    3624:	cd 40                	int    $0x40
    3626:	c3                   	ret    

00003627 <kill>:
SYSCALL(kill)
    3627:	b8 06 00 00 00       	mov    $0x6,%eax
    362c:	cd 40                	int    $0x40
    362e:	c3                   	ret    

0000362f <exec>:
SYSCALL(exec)
    362f:	b8 07 00 00 00       	mov    $0x7,%eax
    3634:	cd 40                	int    $0x40
    3636:	c3                   	ret    

00003637 <open>:
SYSCALL(open)
    3637:	b8 0f 00 00 00       	mov    $0xf,%eax
    363c:	cd 40                	int    $0x40
    363e:	c3                   	ret    

0000363f <mknod>:
SYSCALL(mknod)
    363f:	b8 11 00 00 00       	mov    $0x11,%eax
    3644:	cd 40                	int    $0x40
    3646:	c3                   	ret    

00003647 <unlink>:
SYSCALL(unlink)
    3647:	b8 12 00 00 00       	mov    $0x12,%eax
    364c:	cd 40                	int    $0x40
    364e:	c3                   	ret    

0000364f <fstat>:
SYSCALL(fstat)
    364f:	b8 08 00 00 00       	mov    $0x8,%eax
    3654:	cd 40                	int    $0x40
    3656:	c3                   	ret    

00003657 <link>:
SYSCALL(link)
    3657:	b8 13 00 00 00       	mov    $0x13,%eax
    365c:	cd 40                	int    $0x40
    365e:	c3                   	ret    

0000365f <mkdir>:
SYSCALL(mkdir)
    365f:	b8 14 00 00 00       	mov    $0x14,%eax
    3664:	cd 40                	int    $0x40
    3666:	c3                   	ret    

00003667 <chdir>:
SYSCALL(chdir)
    3667:	b8 09 00 00 00       	mov    $0x9,%eax
    366c:	cd 40                	int    $0x40
    366e:	c3                   	ret    

0000366f <dup>:
SYSCALL(dup)
    366f:	b8 0a 00 00 00       	mov    $0xa,%eax
    3674:	cd 40                	int    $0x40
    3676:	c3                   	ret    

00003677 <getpid>:
SYSCALL(getpid)
    3677:	b8 0b 00 00 00       	mov    $0xb,%eax
    367c:	cd 40                	int    $0x40
    367e:	c3                   	ret    

0000367f <sbrk>:
SYSCALL(sbrk)
    367f:	b8 0c 00 00 00       	mov    $0xc,%eax
    3684:	cd 40                	int    $0x40
    3686:	c3                   	ret    

00003687 <sleep>:
SYSCALL(sleep)
    3687:	b8 0d 00 00 00       	mov    $0xd,%eax
    368c:	cd 40                	int    $0x40
    368e:	c3                   	ret    

0000368f <uptime>:
SYSCALL(uptime)
    368f:	b8 0e 00 00 00       	mov    $0xe,%eax
    3694:	cd 40                	int    $0x40
    3696:	c3                   	ret    

00003697 <setvariable>:
SYSCALL(setvariable)
    3697:	b8 17 00 00 00       	mov    $0x17,%eax
    369c:	cd 40                	int    $0x40
    369e:	c3                   	ret    

0000369f <getvariable>:
SYSCALL(getvariable)
    369f:	b8 18 00 00 00       	mov    $0x18,%eax
    36a4:	cd 40                	int    $0x40
    36a6:	c3                   	ret    

000036a7 <remvariable>:
SYSCALL(remvariable)
    36a7:	b8 19 00 00 00       	mov    $0x19,%eax
    36ac:	cd 40                	int    $0x40
    36ae:	c3                   	ret    

000036af <wait2>:
SYSCALL(wait2)
    36af:	b8 1a 00 00 00       	mov    $0x1a,%eax
    36b4:	cd 40                	int    $0x40
    36b6:	c3                   	ret    

000036b7 <set_priority>:
SYSCALL(set_priority)
    36b7:	b8 1b 00 00 00       	mov    $0x1b,%eax
    36bc:	cd 40                	int    $0x40
    36be:	c3                   	ret    

000036bf <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    36bf:	55                   	push   %ebp
    36c0:	89 e5                	mov    %esp,%ebp
    36c2:	57                   	push   %edi
    36c3:	56                   	push   %esi
    36c4:	53                   	push   %ebx
    36c5:	83 ec 3c             	sub    $0x3c,%esp
    36c8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    36cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    36cf:	74 12                	je     36e3 <printint+0x24>
    36d1:	89 d0                	mov    %edx,%eax
    36d3:	c1 e8 1f             	shr    $0x1f,%eax
    36d6:	84 c0                	test   %al,%al
    36d8:	74 09                	je     36e3 <printint+0x24>
    neg = 1;
    x = -xx;
    36da:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    36dc:	be 01 00 00 00       	mov    $0x1,%esi
    36e1:	eb 05                	jmp    36e8 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    36e3:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    36e8:	bf 00 00 00 00       	mov    $0x0,%edi
    36ed:	eb 02                	jmp    36f1 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    36ef:	89 df                	mov    %ebx,%edi
    36f1:	8d 5f 01             	lea    0x1(%edi),%ebx
    36f4:	89 d0                	mov    %edx,%eax
    36f6:	ba 00 00 00 00       	mov    $0x0,%edx
    36fb:	f7 f1                	div    %ecx
    36fd:	0f b6 92 00 52 00 00 	movzbl 0x5200(%edx),%edx
    3704:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    3708:	89 c2                	mov    %eax,%edx
    370a:	85 c0                	test   %eax,%eax
    370c:	75 e1                	jne    36ef <printint+0x30>
  if(neg)
    370e:	85 f6                	test   %esi,%esi
    3710:	74 08                	je     371a <printint+0x5b>
    buf[i++] = '-';
    3712:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    3717:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    371a:	89 d8                	mov    %ebx,%eax
    371c:	83 e8 01             	sub    $0x1,%eax
    371f:	78 29                	js     374a <printint+0x8b>
    3721:	8b 75 c4             	mov    -0x3c(%ebp),%esi
    3724:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    3728:	8d 7d d7             	lea    -0x29(%ebp),%edi
    372b:	0f b6 03             	movzbl (%ebx),%eax
    372e:	88 45 d7             	mov    %al,-0x29(%ebp)
    3731:	83 ec 04             	sub    $0x4,%esp
    3734:	6a 01                	push   $0x1
    3736:	57                   	push   %edi
    3737:	56                   	push   %esi
    3738:	e8 da fe ff ff       	call   3617 <write>
    373d:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    3740:	83 c4 10             	add    $0x10,%esp
    3743:	8d 45 d7             	lea    -0x29(%ebp),%eax
    3746:	39 c3                	cmp    %eax,%ebx
    3748:	75 e1                	jne    372b <printint+0x6c>
    putc(fd, buf[i]);
}
    374a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    374d:	5b                   	pop    %ebx
    374e:	5e                   	pop    %esi
    374f:	5f                   	pop    %edi
    3750:	5d                   	pop    %ebp
    3751:	c3                   	ret    

00003752 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3752:	55                   	push   %ebp
    3753:	89 e5                	mov    %esp,%ebp
    3755:	57                   	push   %edi
    3756:	56                   	push   %esi
    3757:	53                   	push   %ebx
    3758:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    375b:	8b 75 0c             	mov    0xc(%ebp),%esi
    375e:	0f b6 1e             	movzbl (%esi),%ebx
    3761:	84 db                	test   %bl,%bl
    3763:	0f 84 a6 01 00 00    	je     390f <printf+0x1bd>
    3769:	83 c6 01             	add    $0x1,%esi
    376c:	8d 45 10             	lea    0x10(%ebp),%eax
    376f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3772:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
    3777:	0f be d3             	movsbl %bl,%edx
    377a:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    377d:	85 ff                	test   %edi,%edi
    377f:	75 25                	jne    37a6 <printf+0x54>
      if(c == '%'){
    3781:	83 f8 25             	cmp    $0x25,%eax
    3784:	0f 84 6a 01 00 00    	je     38f4 <printf+0x1a2>
    378a:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    378d:	83 ec 04             	sub    $0x4,%esp
    3790:	6a 01                	push   $0x1
    3792:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    3795:	50                   	push   %eax
    3796:	ff 75 08             	pushl  0x8(%ebp)
    3799:	e8 79 fe ff ff       	call   3617 <write>
    379e:	83 c4 10             	add    $0x10,%esp
    37a1:	e9 5a 01 00 00       	jmp    3900 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    37a6:	83 ff 25             	cmp    $0x25,%edi
    37a9:	0f 85 51 01 00 00    	jne    3900 <printf+0x1ae>
      if(c == 'd'){
    37af:	83 f8 64             	cmp    $0x64,%eax
    37b2:	75 2c                	jne    37e0 <printf+0x8e>
        printint(fd, *ap, 10, 1);
    37b4:	83 ec 0c             	sub    $0xc,%esp
    37b7:	6a 01                	push   $0x1
    37b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
    37be:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    37c1:	8b 17                	mov    (%edi),%edx
    37c3:	8b 45 08             	mov    0x8(%ebp),%eax
    37c6:	e8 f4 fe ff ff       	call   36bf <printint>
        ap++;
    37cb:	89 f8                	mov    %edi,%eax
    37cd:	83 c0 04             	add    $0x4,%eax
    37d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    37d3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    37d6:	bf 00 00 00 00       	mov    $0x0,%edi
    37db:	e9 20 01 00 00       	jmp    3900 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    37e0:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    37e6:	83 fa 70             	cmp    $0x70,%edx
    37e9:	75 2c                	jne    3817 <printf+0xc5>
        printint(fd, *ap, 16, 0);
    37eb:	83 ec 0c             	sub    $0xc,%esp
    37ee:	6a 00                	push   $0x0
    37f0:	b9 10 00 00 00       	mov    $0x10,%ecx
    37f5:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    37f8:	8b 17                	mov    (%edi),%edx
    37fa:	8b 45 08             	mov    0x8(%ebp),%eax
    37fd:	e8 bd fe ff ff       	call   36bf <printint>
        ap++;
    3802:	89 f8                	mov    %edi,%eax
    3804:	83 c0 04             	add    $0x4,%eax
    3807:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    380a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    380d:	bf 00 00 00 00       	mov    $0x0,%edi
    3812:	e9 e9 00 00 00       	jmp    3900 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3817:	83 f8 73             	cmp    $0x73,%eax
    381a:	75 52                	jne    386e <printf+0x11c>
        s = (char*)*ap;
    381c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    381f:	8b 18                	mov    (%eax),%ebx
        ap++;
    3821:	83 c0 04             	add    $0x4,%eax
    3824:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    3827:	85 db                	test   %ebx,%ebx
          s = "(null)";
    3829:	b8 f8 51 00 00       	mov    $0x51f8,%eax
    382e:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
    3831:	0f b6 03             	movzbl (%ebx),%eax
    3834:	84 c0                	test   %al,%al
    3836:	0f 84 bf 00 00 00    	je     38fb <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    383c:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    383f:	89 75 d0             	mov    %esi,-0x30(%ebp)
    3842:	8b 75 08             	mov    0x8(%ebp),%esi
    3845:	88 45 e3             	mov    %al,-0x1d(%ebp)
    3848:	83 ec 04             	sub    $0x4,%esp
    384b:	6a 01                	push   $0x1
    384d:	57                   	push   %edi
    384e:	56                   	push   %esi
    384f:	e8 c3 fd ff ff       	call   3617 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    3854:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    3857:	0f b6 03             	movzbl (%ebx),%eax
    385a:	83 c4 10             	add    $0x10,%esp
    385d:	84 c0                	test   %al,%al
    385f:	75 e4                	jne    3845 <printf+0xf3>
    3861:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3864:	bf 00 00 00 00       	mov    $0x0,%edi
    3869:	e9 92 00 00 00       	jmp    3900 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    386e:	83 f8 63             	cmp    $0x63,%eax
    3871:	75 2b                	jne    389e <printf+0x14c>
    3873:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3876:	8b 07                	mov    (%edi),%eax
    3878:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    387b:	83 ec 04             	sub    $0x4,%esp
    387e:	6a 01                	push   $0x1
    3880:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3883:	50                   	push   %eax
    3884:	ff 75 08             	pushl  0x8(%ebp)
    3887:	e8 8b fd ff ff       	call   3617 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    388c:	89 f8                	mov    %edi,%eax
    388e:	83 c0 04             	add    $0x4,%eax
    3891:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3894:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3897:	bf 00 00 00 00       	mov    $0x0,%edi
    389c:	eb 62                	jmp    3900 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    389e:	83 f8 25             	cmp    $0x25,%eax
    38a1:	75 1e                	jne    38c1 <printf+0x16f>
    38a3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    38a6:	83 ec 04             	sub    $0x4,%esp
    38a9:	6a 01                	push   $0x1
    38ab:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    38ae:	50                   	push   %eax
    38af:	ff 75 08             	pushl  0x8(%ebp)
    38b2:	e8 60 fd ff ff       	call   3617 <write>
    38b7:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    38ba:	bf 00 00 00 00       	mov    $0x0,%edi
    38bf:	eb 3f                	jmp    3900 <printf+0x1ae>
    38c1:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    38c5:	83 ec 04             	sub    $0x4,%esp
    38c8:	6a 01                	push   $0x1
    38ca:	8d 45 e7             	lea    -0x19(%ebp),%eax
    38cd:	50                   	push   %eax
    38ce:	ff 75 08             	pushl  0x8(%ebp)
    38d1:	e8 41 fd ff ff       	call   3617 <write>
    38d6:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    38d9:	83 c4 0c             	add    $0xc,%esp
    38dc:	6a 01                	push   $0x1
    38de:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    38e1:	50                   	push   %eax
    38e2:	ff 75 08             	pushl  0x8(%ebp)
    38e5:	e8 2d fd ff ff       	call   3617 <write>
    38ea:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    38ed:	bf 00 00 00 00       	mov    $0x0,%edi
    38f2:	eb 0c                	jmp    3900 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    38f4:	bf 25 00 00 00       	mov    $0x25,%edi
    38f9:	eb 05                	jmp    3900 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    38fb:	bf 00 00 00 00       	mov    $0x0,%edi
    3900:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3903:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    3907:	84 db                	test   %bl,%bl
    3909:	0f 85 68 fe ff ff    	jne    3777 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    390f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3912:	5b                   	pop    %ebx
    3913:	5e                   	pop    %esi
    3914:	5f                   	pop    %edi
    3915:	5d                   	pop    %ebp
    3916:	c3                   	ret    

00003917 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3917:	55                   	push   %ebp
    3918:	89 e5                	mov    %esp,%ebp
    391a:	57                   	push   %edi
    391b:	56                   	push   %esi
    391c:	53                   	push   %ebx
    391d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3920:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3923:	a1 c0 5a 00 00       	mov    0x5ac0,%eax
    3928:	eb 0c                	jmp    3936 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    392a:	8b 10                	mov    (%eax),%edx
    392c:	39 d0                	cmp    %edx,%eax
    392e:	72 04                	jb     3934 <free+0x1d>
    3930:	39 d1                	cmp    %edx,%ecx
    3932:	72 0c                	jb     3940 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
    3934:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3936:	39 c8                	cmp    %ecx,%eax
    3938:	73 f0                	jae    392a <free+0x13>
    393a:	8b 10                	mov    (%eax),%edx
    393c:	39 d1                	cmp    %edx,%ecx
    393e:	73 3e                	jae    397e <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    3940:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3943:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3946:	8b 10                	mov    (%eax),%edx
    3948:	39 d7                	cmp    %edx,%edi
    394a:	75 0f                	jne    395b <free+0x44>
    bp->s.size += p->s.ptr->s.size;
    394c:	03 77 04             	add    0x4(%edi),%esi
    394f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3952:	8b 10                	mov    (%eax),%edx
    3954:	8b 12                	mov    (%edx),%edx
    3956:	89 53 f8             	mov    %edx,-0x8(%ebx)
    3959:	eb 03                	jmp    395e <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
    395b:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    395e:	8b 50 04             	mov    0x4(%eax),%edx
    3961:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3964:	39 f1                	cmp    %esi,%ecx
    3966:	75 0d                	jne    3975 <free+0x5e>
    p->s.size += bp->s.size;
    3968:	03 53 fc             	add    -0x4(%ebx),%edx
    396b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    396e:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3971:	89 10                	mov    %edx,(%eax)
    3973:	eb 02                	jmp    3977 <free+0x60>
  } else
    p->s.ptr = bp;
    3975:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3977:	a3 c0 5a 00 00       	mov    %eax,0x5ac0
}
    397c:	eb 06                	jmp    3984 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    397e:	39 d0                	cmp    %edx,%eax
    3980:	72 b2                	jb     3934 <free+0x1d>
    3982:	eb bc                	jmp    3940 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
    3984:	5b                   	pop    %ebx
    3985:	5e                   	pop    %esi
    3986:	5f                   	pop    %edi
    3987:	5d                   	pop    %ebp
    3988:	c3                   	ret    

00003989 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3989:	55                   	push   %ebp
    398a:	89 e5                	mov    %esp,%ebp
    398c:	57                   	push   %edi
    398d:	56                   	push   %esi
    398e:	53                   	push   %ebx
    398f:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3992:	8b 45 08             	mov    0x8(%ebp),%eax
    3995:	8d 58 07             	lea    0x7(%eax),%ebx
    3998:	c1 eb 03             	shr    $0x3,%ebx
    399b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    399e:	8b 15 c0 5a 00 00    	mov    0x5ac0,%edx
    39a4:	85 d2                	test   %edx,%edx
    39a6:	75 23                	jne    39cb <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
    39a8:	c7 05 c0 5a 00 00 c4 	movl   $0x5ac4,0x5ac0
    39af:	5a 00 00 
    39b2:	c7 05 c4 5a 00 00 c4 	movl   $0x5ac4,0x5ac4
    39b9:	5a 00 00 
    base.s.size = 0;
    39bc:	c7 05 c8 5a 00 00 00 	movl   $0x0,0x5ac8
    39c3:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    39c6:	ba c4 5a 00 00       	mov    $0x5ac4,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    39cb:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    39cd:	8b 48 04             	mov    0x4(%eax),%ecx
    39d0:	39 cb                	cmp    %ecx,%ebx
    39d2:	77 20                	ja     39f4 <malloc+0x6b>
      if(p->s.size == nunits)
    39d4:	39 cb                	cmp    %ecx,%ebx
    39d6:	75 06                	jne    39de <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
    39d8:	8b 08                	mov    (%eax),%ecx
    39da:	89 0a                	mov    %ecx,(%edx)
    39dc:	eb 0b                	jmp    39e9 <malloc+0x60>
      else {
        p->s.size -= nunits;
    39de:	29 d9                	sub    %ebx,%ecx
    39e0:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    39e3:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    39e6:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    39e9:	89 15 c0 5a 00 00    	mov    %edx,0x5ac0
      return (void*)(p + 1);
    39ef:	83 c0 08             	add    $0x8,%eax
    39f2:	eb 63                	jmp    3a57 <malloc+0xce>
    39f4:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    39fa:	be 00 10 00 00       	mov    $0x1000,%esi
    39ff:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    3a02:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    3a09:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3a0b:	39 05 c0 5a 00 00    	cmp    %eax,0x5ac0
    3a11:	75 2d                	jne    3a40 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    3a13:	83 ec 0c             	sub    $0xc,%esp
    3a16:	57                   	push   %edi
    3a17:	e8 63 fc ff ff       	call   367f <sbrk>
  if(p == (char*)-1)
    3a1c:	83 c4 10             	add    $0x10,%esp
    3a1f:	83 f8 ff             	cmp    $0xffffffff,%eax
    3a22:	74 27                	je     3a4b <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    3a24:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    3a27:	83 ec 0c             	sub    $0xc,%esp
    3a2a:	83 c0 08             	add    $0x8,%eax
    3a2d:	50                   	push   %eax
    3a2e:	e8 e4 fe ff ff       	call   3917 <free>
  return freep;
    3a33:	8b 15 c0 5a 00 00    	mov    0x5ac0,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    3a39:	83 c4 10             	add    $0x10,%esp
    3a3c:	85 d2                	test   %edx,%edx
    3a3e:	74 12                	je     3a52 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3a40:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3a42:	8b 48 04             	mov    0x4(%eax),%ecx
    3a45:	39 cb                	cmp    %ecx,%ebx
    3a47:	77 c0                	ja     3a09 <malloc+0x80>
    3a49:	eb 89                	jmp    39d4 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
    3a4b:	b8 00 00 00 00       	mov    $0x0,%eax
    3a50:	eb 05                	jmp    3a57 <malloc+0xce>
    3a52:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
    3a57:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3a5a:	5b                   	pop    %ebx
    3a5b:	5e                   	pop    %esi
    3a5c:	5f                   	pop    %edi
    3a5d:	5d                   	pop    %ebp
    3a5e:	c3                   	ret    
