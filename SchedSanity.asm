
_SchedSanity:     file format elf32-i386


Disassembly of section .text:

00000000 <process_1>:
#include "stat.h"
#define MEDIUM_LOOP_SIZE 1000
#define LARGE_LOOP_SIZE 500000
#define VERY_LARGE_LOOP_SIZE 1000
#define PROCNUM 10
int process_1(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	b8 0a 00 00 00       	mov    $0xa,%eax
    int loopSize=MEDIUM_LOOP_SIZE;
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    for(i=0; i<loopSize; i++){
   8:	83 e8 01             	sub    $0x1,%eax
   b:	75 fb                	jne    8 <process_1+0x8>
        res=num1+num2;
        res=res-num2;
    }
    return res;

}
   d:	b8 4e 61 bc 00       	mov    $0xbc614e,%eax
  12:	5d                   	pop    %ebp
  13:	c3                   	ret    

00000014 <process_2>:


int process_2(){
  14:	55                   	push   %ebp
  15:	89 e5                	mov    %esp,%ebp
  17:	b8 e8 03 00 00       	mov    $0x3e8,%eax
    int loopSize=VERY_LARGE_LOOP_SIZE;
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res=0;
    for(i=0; i<loopSize; i++){
  1c:	83 e8 01             	sub    $0x1,%eax
  1f:	75 fb                	jne    1c <process_2+0x8>
        res=num1+num2;
        res=res-num2;
    }
    return res;
}
  21:	b8 4e 61 bc 00       	mov    $0xbc614e,%eax
  26:	5d                   	pop    %ebp
  27:	c3                   	ret    

00000028 <process_3>:
int process_3(){
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	53                   	push   %ebx
  2c:	83 ec 04             	sub    $0x4,%esp
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
  2f:	bb 00 00 00 00       	mov    $0x0,%ebx
        res=num1+num2;
        res=res-num2;
        //printf(1,toPrint,res);
        printf(1,"%d\n", i);
  34:	83 ec 04             	sub    $0x4,%esp
  37:	53                   	push   %ebx
  38:	68 5c 09 00 00       	push   $0x95c
  3d:	6a 01                	push   $0x1
  3f:	e8 0a 06 00 00       	call   64e <printf>
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
  44:	83 c3 01             	add    $0x1,%ebx
  47:	83 c4 10             	add    $0x10,%esp
  4a:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  50:	75 e2                	jne    34 <process_3+0xc>
        res=res-num2;
        //printf(1,toPrint,res);
        printf(1,"%d\n", i);
    }
    return res;
}
  52:	b8 4e 61 bc 00       	mov    $0xbc614e,%eax
  57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  5a:	c9                   	leave  
  5b:	c3                   	ret    

0000005c <process_4>:

int process_4(){
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	83 ec 04             	sub    $0x4,%esp
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
  63:	bb 00 00 00 00       	mov    $0x0,%ebx
        res=num1+num2;
        res=res-num2;
        //printf(1,toPrint,res);
        printf(1,"%d\n", i);
  68:	83 ec 04             	sub    $0x4,%esp
  6b:	53                   	push   %ebx
  6c:	68 5c 09 00 00       	push   $0x95c
  71:	6a 01                	push   $0x1
  73:	e8 d6 05 00 00       	call   64e <printf>
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
  78:	83 c3 01             	add    $0x1,%ebx
  7b:	83 c4 10             	add    $0x10,%esp
  7e:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  84:	75 e2                	jne    68 <process_4+0xc>
        res=res-num2;
        //printf(1,toPrint,res);
        printf(1,"%d\n", i);
    }
    return res;
}
  86:	b8 4e 61 bc 00       	mov    $0xbc614e,%eax
  8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8e:	c9                   	leave  
  8f:	c3                   	ret    

00000090 <wait2AndCollect>:
int wtime_acc   =   0;
int rtime_acc   =   0;
int iotime_acc   =   0;

//call wait2 on pid, and accumulate data.
void wait2AndCollect(int pid){
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	83 ec 08             	sub    $0x8,%esp
    wait2(pid,&wtime,&rtime,&iotime);
  96:	68 ac 0c 00 00       	push   $0xcac
  9b:	68 b0 0c 00 00       	push   $0xcb0
  a0:	68 b4 0c 00 00       	push   $0xcb4
  a5:	ff 75 08             	pushl  0x8(%ebp)
  a8:	e8 fe 04 00 00       	call   5ab <wait2>
    wtime_acc+=wtime;
  ad:	a1 b4 0c 00 00       	mov    0xcb4,%eax
  b2:	01 05 a8 0c 00 00    	add    %eax,0xca8
    rtime_acc+=rtime;
  b8:	a1 b0 0c 00 00       	mov    0xcb0,%eax
  bd:	01 05 a4 0c 00 00    	add    %eax,0xca4
    iotime_acc+=iotime;
  c3:	a1 ac 0c 00 00       	mov    0xcac,%eax
  c8:	01 05 a0 0c 00 00    	add    %eax,0xca0
}
  ce:	83 c4 10             	add    $0x10,%esp
  d1:	c9                   	leave  
  d2:	c3                   	ret    

000000d3 <main>:

int main(){
  d3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d7:	83 e4 f0             	and    $0xfffffff0,%esp
  da:	ff 71 fc             	pushl  -0x4(%ecx)
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	53                   	push   %ebx
  e1:	51                   	push   %ecx


    if((pid1=fork())==0){
  e2:	e8 04 04 00 00       	call   4eb <fork>
  e7:	a3 e4 0c 00 00       	mov    %eax,0xce4
  ec:	85 c0                	test   %eax,%eax
  ee:	75 14                	jne    104 <main+0x31>
        //printf(1,"I'm process 1, pid: %d\n",getpid());
        set_priority(1);
  f0:	83 ec 0c             	sub    $0xc,%esp
  f3:	6a 01                	push   $0x1
  f5:	e8 b9 04 00 00       	call   5b3 <set_priority>
        process_4();
  fa:	e8 5d ff ff ff       	call   5c <process_4>
        exit();
  ff:	e8 ef 03 00 00       	call   4f3 <exit>
    }
    else if((pid2=fork())==0){
 104:	e8 e2 03 00 00       	call   4eb <fork>
 109:	a3 d4 0c 00 00       	mov    %eax,0xcd4
 10e:	85 c0                	test   %eax,%eax
 110:	75 14                	jne    126 <main+0x53>
        //printf(1,"I'm process 2, pid: %d\n",getpid());
        set_priority(1);
 112:	83 ec 0c             	sub    $0xc,%esp
 115:	6a 01                	push   $0x1
 117:	e8 97 04 00 00       	call   5b3 <set_priority>
        process_4();
 11c:	e8 3b ff ff ff       	call   5c <process_4>
        exit();
 121:	e8 cd 03 00 00       	call   4f3 <exit>

    }
    else if((pid3=fork())==0){
 126:	e8 c0 03 00 00       	call   4eb <fork>
 12b:	a3 e0 0c 00 00       	mov    %eax,0xce0
 130:	85 c0                	test   %eax,%eax
 132:	75 17                	jne    14b <main+0x78>
        //printf(1,"I'm process, pid: %d 3\n",getpid());
        set_priority(3);
 134:	83 ec 0c             	sub    $0xc,%esp
 137:	6a 03                	push   $0x3
 139:	e8 75 04 00 00       	call   5b3 <set_priority>
        process_4();
 13e:	e8 19 ff ff ff       	call   5c <process_4>
 143:	83 c4 10             	add    $0x10,%esp
 146:	e9 df 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid4=fork())==0){
 14b:	e8 9b 03 00 00       	call   4eb <fork>
 150:	a3 c8 0c 00 00       	mov    %eax,0xcc8
 155:	85 c0                	test   %eax,%eax
 157:	75 17                	jne    170 <main+0x9d>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(3);
 159:	83 ec 0c             	sub    $0xc,%esp
 15c:	6a 03                	push   $0x3
 15e:	e8 50 04 00 00       	call   5b3 <set_priority>
        process_4();
 163:	e8 f4 fe ff ff       	call   5c <process_4>
 168:	83 c4 10             	add    $0x10,%esp
 16b:	e9 ba 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid5=fork())==0){
 170:	e8 76 03 00 00       	call   4eb <fork>
 175:	a3 d0 0c 00 00       	mov    %eax,0xcd0
 17a:	85 c0                	test   %eax,%eax
 17c:	75 17                	jne    195 <main+0xc2>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(3);
 17e:	83 ec 0c             	sub    $0xc,%esp
 181:	6a 03                	push   $0x3
 183:	e8 2b 04 00 00       	call   5b3 <set_priority>
        process_4();
 188:	e8 cf fe ff ff       	call   5c <process_4>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	e9 95 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid6=fork())==0){
 195:	e8 51 03 00 00       	call   4eb <fork>
 19a:	a3 c4 0c 00 00       	mov    %eax,0xcc4
 19f:	85 c0                	test   %eax,%eax
 1a1:	75 17                	jne    1ba <main+0xe7>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(3);
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	6a 03                	push   $0x3
 1a8:	e8 06 04 00 00       	call   5b3 <set_priority>
        process_4();
 1ad:	e8 aa fe ff ff       	call   5c <process_4>
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	e9 70 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid7=fork())==0){
 1ba:	e8 2c 03 00 00       	call   4eb <fork>
 1bf:	a3 e8 0c 00 00       	mov    %eax,0xce8
 1c4:	85 c0                	test   %eax,%eax
 1c6:	75 17                	jne    1df <main+0x10c>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(3);
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	6a 03                	push   $0x3
 1cd:	e8 e1 03 00 00       	call   5b3 <set_priority>
        process_4();
 1d2:	e8 85 fe ff ff       	call   5c <process_4>
 1d7:	83 c4 10             	add    $0x10,%esp
 1da:	e9 4b 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid8=fork())==0){
 1df:	e8 07 03 00 00       	call   4eb <fork>
 1e4:	a3 dc 0c 00 00       	mov    %eax,0xcdc
 1e9:	85 c0                	test   %eax,%eax
 1eb:	75 17                	jne    204 <main+0x131>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(3);
 1ed:	83 ec 0c             	sub    $0xc,%esp
 1f0:	6a 03                	push   $0x3
 1f2:	e8 bc 03 00 00       	call   5b3 <set_priority>
        process_4();
 1f7:	e8 60 fe ff ff       	call   5c <process_4>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	e9 26 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid9=fork())==0){
 204:	e8 e2 02 00 00       	call   4eb <fork>
 209:	a3 cc 0c 00 00       	mov    %eax,0xccc
 20e:	85 c0                	test   %eax,%eax
 210:	75 17                	jne    229 <main+0x156>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(3);
 212:	83 ec 0c             	sub    $0xc,%esp
 215:	6a 03                	push   $0x3
 217:	e8 97 03 00 00       	call   5b3 <set_priority>
        process_4();
 21c:	e8 3b fe ff ff       	call   5c <process_4>
 221:	83 c4 10             	add    $0x10,%esp
 224:	e9 01 01 00 00       	jmp    32a <main+0x257>
    }
    else if((pid10=fork())==0){
 229:	e8 bd 02 00 00       	call   4eb <fork>
 22e:	a3 d8 0c 00 00       	mov    %eax,0xcd8
 233:	85 c0                	test   %eax,%eax
 235:	75 17                	jne    24e <main+0x17b>
        //printf(1,"I'm process 4, pid: %d\n",getpid());
        set_priority(2);
 237:	83 ec 0c             	sub    $0xc,%esp
 23a:	6a 02                	push   $0x2
 23c:	e8 72 03 00 00       	call   5b3 <set_priority>
        process_4();
 241:	e8 16 fe ff ff       	call   5c <process_4>
 246:	83 c4 10             	add    $0x10,%esp
 249:	e9 dc 00 00 00       	jmp    32a <main+0x257>
    }
    else{

        wait2AndCollect(pid1);
 24e:	83 ec 0c             	sub    $0xc,%esp
 251:	ff 35 e4 0c 00 00    	pushl  0xce4
 257:	e8 34 fe ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid2);
 25c:	83 c4 04             	add    $0x4,%esp
 25f:	ff 35 d4 0c 00 00    	pushl  0xcd4
 265:	e8 26 fe ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid3);
 26a:	83 c4 04             	add    $0x4,%esp
 26d:	ff 35 e0 0c 00 00    	pushl  0xce0
 273:	e8 18 fe ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid4);
 278:	83 c4 04             	add    $0x4,%esp
 27b:	ff 35 c8 0c 00 00    	pushl  0xcc8
 281:	e8 0a fe ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid5);
 286:	83 c4 04             	add    $0x4,%esp
 289:	ff 35 d0 0c 00 00    	pushl  0xcd0
 28f:	e8 fc fd ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid6);
 294:	83 c4 04             	add    $0x4,%esp
 297:	ff 35 c4 0c 00 00    	pushl  0xcc4
 29d:	e8 ee fd ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid7);
 2a2:	83 c4 04             	add    $0x4,%esp
 2a5:	ff 35 e8 0c 00 00    	pushl  0xce8
 2ab:	e8 e0 fd ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid8);
 2b0:	83 c4 04             	add    $0x4,%esp
 2b3:	ff 35 dc 0c 00 00    	pushl  0xcdc
 2b9:	e8 d2 fd ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid9);
 2be:	83 c4 04             	add    $0x4,%esp
 2c1:	ff 35 cc 0c 00 00    	pushl  0xccc
 2c7:	e8 c4 fd ff ff       	call   90 <wait2AndCollect>
        wait2AndCollect(pid10);
 2cc:	83 c4 04             	add    $0x4,%esp
 2cf:	ff 35 d8 0c 00 00    	pushl  0xcd8
 2d5:	e8 b6 fd ff ff       	call   90 <wait2AndCollect>

        printf(1,"wtime average: %d \n", wtime_acc/PROCNUM);
 2da:	83 c4 0c             	add    $0xc,%esp
 2dd:	a1 a8 0c 00 00       	mov    0xca8,%eax
 2e2:	bb 0a 00 00 00       	mov    $0xa,%ebx
 2e7:	99                   	cltd   
 2e8:	f7 fb                	idiv   %ebx
 2ea:	50                   	push   %eax
 2eb:	68 60 09 00 00       	push   $0x960
 2f0:	6a 01                	push   $0x1
 2f2:	e8 57 03 00 00       	call   64e <printf>
        printf(1,"rtime average: %d \n", rtime_acc/PROCNUM);
 2f7:	83 c4 0c             	add    $0xc,%esp
 2fa:	a1 a4 0c 00 00       	mov    0xca4,%eax
 2ff:	99                   	cltd   
 300:	f7 fb                	idiv   %ebx
 302:	50                   	push   %eax
 303:	68 74 09 00 00       	push   $0x974
 308:	6a 01                	push   $0x1
 30a:	e8 3f 03 00 00       	call   64e <printf>
        printf(1,"iotime average: %d \n", iotime_acc/PROCNUM);
 30f:	83 c4 0c             	add    $0xc,%esp
 312:	a1 a0 0c 00 00       	mov    0xca0,%eax
 317:	99                   	cltd   
 318:	f7 fb                	idiv   %ebx
 31a:	50                   	push   %eax
 31b:	68 88 09 00 00       	push   $0x988
 320:	6a 01                	push   $0x1
 322:	e8 27 03 00 00       	call   64e <printf>
 327:	83 c4 10             	add    $0x10,%esp





    exit();
 32a:	e8 c4 01 00 00       	call   4f3 <exit>

0000032f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 32f:	55                   	push   %ebp
 330:	89 e5                	mov    %esp,%ebp
 332:	53                   	push   %ebx
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 339:	89 c2                	mov    %eax,%edx
 33b:	83 c2 01             	add    $0x1,%edx
 33e:	83 c1 01             	add    $0x1,%ecx
 341:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 345:	88 5a ff             	mov    %bl,-0x1(%edx)
 348:	84 db                	test   %bl,%bl
 34a:	75 ef                	jne    33b <strcpy+0xc>
    ;
  return os;
}
 34c:	5b                   	pop    %ebx
 34d:	5d                   	pop    %ebp
 34e:	c3                   	ret    

0000034f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 34f:	55                   	push   %ebp
 350:	89 e5                	mov    %esp,%ebp
 352:	8b 4d 08             	mov    0x8(%ebp),%ecx
 355:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 358:	0f b6 01             	movzbl (%ecx),%eax
 35b:	84 c0                	test   %al,%al
 35d:	74 15                	je     374 <strcmp+0x25>
 35f:	3a 02                	cmp    (%edx),%al
 361:	75 11                	jne    374 <strcmp+0x25>
    p++, q++;
 363:	83 c1 01             	add    $0x1,%ecx
 366:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 369:	0f b6 01             	movzbl (%ecx),%eax
 36c:	84 c0                	test   %al,%al
 36e:	74 04                	je     374 <strcmp+0x25>
 370:	3a 02                	cmp    (%edx),%al
 372:	74 ef                	je     363 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 374:	0f b6 c0             	movzbl %al,%eax
 377:	0f b6 12             	movzbl (%edx),%edx
 37a:	29 d0                	sub    %edx,%eax
}
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret    

0000037e <strlen>:

uint
strlen(char *s)
{
 37e:	55                   	push   %ebp
 37f:	89 e5                	mov    %esp,%ebp
 381:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 384:	80 39 00             	cmpb   $0x0,(%ecx)
 387:	74 12                	je     39b <strlen+0x1d>
 389:	ba 00 00 00 00       	mov    $0x0,%edx
 38e:	83 c2 01             	add    $0x1,%edx
 391:	89 d0                	mov    %edx,%eax
 393:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 397:	75 f5                	jne    38e <strlen+0x10>
 399:	eb 05                	jmp    3a0 <strlen+0x22>
 39b:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
 3a0:	5d                   	pop    %ebp
 3a1:	c3                   	ret    

000003a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	57                   	push   %edi
 3a6:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3a9:	89 d7                	mov    %edx,%edi
 3ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	fc                   	cld    
 3b2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3b4:	89 d0                	mov    %edx,%eax
 3b6:	5f                   	pop    %edi
 3b7:	5d                   	pop    %ebp
 3b8:	c3                   	ret    

000003b9 <strchr>:

char*
strchr(const char *s, char c)
{
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp
 3bc:	53                   	push   %ebx
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 3c3:	0f b6 10             	movzbl (%eax),%edx
 3c6:	84 d2                	test   %dl,%dl
 3c8:	74 1d                	je     3e7 <strchr+0x2e>
 3ca:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 3cc:	38 d3                	cmp    %dl,%bl
 3ce:	75 06                	jne    3d6 <strchr+0x1d>
 3d0:	eb 1a                	jmp    3ec <strchr+0x33>
 3d2:	38 ca                	cmp    %cl,%dl
 3d4:	74 16                	je     3ec <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3d6:	83 c0 01             	add    $0x1,%eax
 3d9:	0f b6 10             	movzbl (%eax),%edx
 3dc:	84 d2                	test   %dl,%dl
 3de:	75 f2                	jne    3d2 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
 3e0:	b8 00 00 00 00       	mov    $0x0,%eax
 3e5:	eb 05                	jmp    3ec <strchr+0x33>
 3e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3ec:	5b                   	pop    %ebx
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    

000003ef <gets>:

char*
gets(char *buf, int max)
{
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	57                   	push   %edi
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
 3f5:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f8:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 3fd:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 400:	eb 29                	jmp    42b <gets+0x3c>
    cc = read(0, &c, 1);
 402:	83 ec 04             	sub    $0x4,%esp
 405:	6a 01                	push   $0x1
 407:	57                   	push   %edi
 408:	6a 00                	push   $0x0
 40a:	e8 fc 00 00 00       	call   50b <read>
    if(cc < 1)
 40f:	83 c4 10             	add    $0x10,%esp
 412:	85 c0                	test   %eax,%eax
 414:	7e 21                	jle    437 <gets+0x48>
      break;
    buf[i++] = c;
 416:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 41a:	8b 55 08             	mov    0x8(%ebp),%edx
 41d:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 421:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 423:	3c 0a                	cmp    $0xa,%al
 425:	74 0e                	je     435 <gets+0x46>
 427:	3c 0d                	cmp    $0xd,%al
 429:	74 0a                	je     435 <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 42b:	8d 5e 01             	lea    0x1(%esi),%ebx
 42e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 431:	7c cf                	jl     402 <gets+0x13>
 433:	eb 02                	jmp    437 <gets+0x48>
 435:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 43e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 441:	5b                   	pop    %ebx
 442:	5e                   	pop    %esi
 443:	5f                   	pop    %edi
 444:	5d                   	pop    %ebp
 445:	c3                   	ret    

00000446 <stat>:

int
stat(char *n, struct stat *st)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	56                   	push   %esi
 44a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 44b:	83 ec 08             	sub    $0x8,%esp
 44e:	6a 00                	push   $0x0
 450:	ff 75 08             	pushl  0x8(%ebp)
 453:	e8 db 00 00 00       	call   533 <open>
  if(fd < 0)
 458:	83 c4 10             	add    $0x10,%esp
 45b:	85 c0                	test   %eax,%eax
 45d:	78 1f                	js     47e <stat+0x38>
 45f:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 461:	83 ec 08             	sub    $0x8,%esp
 464:	ff 75 0c             	pushl  0xc(%ebp)
 467:	50                   	push   %eax
 468:	e8 de 00 00 00       	call   54b <fstat>
 46d:	89 c6                	mov    %eax,%esi
  close(fd);
 46f:	89 1c 24             	mov    %ebx,(%esp)
 472:	e8 a4 00 00 00       	call   51b <close>
  return r;
 477:	83 c4 10             	add    $0x10,%esp
 47a:	89 f0                	mov    %esi,%eax
 47c:	eb 05                	jmp    483 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 47e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
 483:	8d 65 f8             	lea    -0x8(%ebp),%esp
 486:	5b                   	pop    %ebx
 487:	5e                   	pop    %esi
 488:	5d                   	pop    %ebp
 489:	c3                   	ret    

0000048a <atoi>:

int
atoi(const char *s)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	53                   	push   %ebx
 48e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 491:	0f b6 11             	movzbl (%ecx),%edx
 494:	8d 42 d0             	lea    -0x30(%edx),%eax
 497:	3c 09                	cmp    $0x9,%al
 499:	77 1f                	ja     4ba <atoi+0x30>
 49b:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 4a0:	83 c1 01             	add    $0x1,%ecx
 4a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4a6:	0f be d2             	movsbl %dl,%edx
 4a9:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4ad:	0f b6 11             	movzbl (%ecx),%edx
 4b0:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4b3:	80 fb 09             	cmp    $0x9,%bl
 4b6:	76 e8                	jbe    4a0 <atoi+0x16>
 4b8:	eb 05                	jmp    4bf <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
 4ba:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
 4bf:	5b                   	pop    %ebx
 4c0:	5d                   	pop    %ebp
 4c1:	c3                   	ret    

000004c2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	56                   	push   %esi
 4c6:	53                   	push   %ebx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	8b 75 0c             	mov    0xc(%ebp),%esi
 4cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d0:	85 db                	test   %ebx,%ebx
 4d2:	7e 13                	jle    4e7 <memmove+0x25>
 4d4:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 4d9:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4dd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4e0:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4e3:	39 da                	cmp    %ebx,%edx
 4e5:	75 f2                	jne    4d9 <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
 4e7:	5b                   	pop    %ebx
 4e8:	5e                   	pop    %esi
 4e9:	5d                   	pop    %ebp
 4ea:	c3                   	ret    

000004eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4eb:	b8 01 00 00 00       	mov    $0x1,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <exit>:
SYSCALL(exit)
 4f3:	b8 02 00 00 00       	mov    $0x2,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <wait>:
SYSCALL(wait)
 4fb:	b8 03 00 00 00       	mov    $0x3,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <pipe>:
SYSCALL(pipe)
 503:	b8 04 00 00 00       	mov    $0x4,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <read>:
SYSCALL(read)
 50b:	b8 05 00 00 00       	mov    $0x5,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <write>:
SYSCALL(write)
 513:	b8 10 00 00 00       	mov    $0x10,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <close>:
SYSCALL(close)
 51b:	b8 15 00 00 00       	mov    $0x15,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <kill>:
SYSCALL(kill)
 523:	b8 06 00 00 00       	mov    $0x6,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <exec>:
SYSCALL(exec)
 52b:	b8 07 00 00 00       	mov    $0x7,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <open>:
SYSCALL(open)
 533:	b8 0f 00 00 00       	mov    $0xf,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <mknod>:
SYSCALL(mknod)
 53b:	b8 11 00 00 00       	mov    $0x11,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <unlink>:
SYSCALL(unlink)
 543:	b8 12 00 00 00       	mov    $0x12,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <fstat>:
SYSCALL(fstat)
 54b:	b8 08 00 00 00       	mov    $0x8,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <link>:
SYSCALL(link)
 553:	b8 13 00 00 00       	mov    $0x13,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <mkdir>:
SYSCALL(mkdir)
 55b:	b8 14 00 00 00       	mov    $0x14,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <chdir>:
SYSCALL(chdir)
 563:	b8 09 00 00 00       	mov    $0x9,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <dup>:
SYSCALL(dup)
 56b:	b8 0a 00 00 00       	mov    $0xa,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <getpid>:
SYSCALL(getpid)
 573:	b8 0b 00 00 00       	mov    $0xb,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <sbrk>:
SYSCALL(sbrk)
 57b:	b8 0c 00 00 00       	mov    $0xc,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <sleep>:
SYSCALL(sleep)
 583:	b8 0d 00 00 00       	mov    $0xd,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <uptime>:
SYSCALL(uptime)
 58b:	b8 0e 00 00 00       	mov    $0xe,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <setvariable>:
SYSCALL(setvariable)
 593:	b8 17 00 00 00       	mov    $0x17,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <getvariable>:
SYSCALL(getvariable)
 59b:	b8 18 00 00 00       	mov    $0x18,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <remvariable>:
SYSCALL(remvariable)
 5a3:	b8 19 00 00 00       	mov    $0x19,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <wait2>:
SYSCALL(wait2)
 5ab:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <set_priority>:
SYSCALL(set_priority)
 5b3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	57                   	push   %edi
 5bf:	56                   	push   %esi
 5c0:	53                   	push   %ebx
 5c1:	83 ec 3c             	sub    $0x3c,%esp
 5c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5cb:	74 12                	je     5df <printint+0x24>
 5cd:	89 d0                	mov    %edx,%eax
 5cf:	c1 e8 1f             	shr    $0x1f,%eax
 5d2:	84 c0                	test   %al,%al
 5d4:	74 09                	je     5df <printint+0x24>
    neg = 1;
    x = -xx;
 5d6:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 5d8:	be 01 00 00 00       	mov    $0x1,%esi
 5dd:	eb 05                	jmp    5e4 <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5df:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5e4:	bf 00 00 00 00       	mov    $0x0,%edi
 5e9:	eb 02                	jmp    5ed <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 5eb:	89 df                	mov    %ebx,%edi
 5ed:	8d 5f 01             	lea    0x1(%edi),%ebx
 5f0:	89 d0                	mov    %edx,%eax
 5f2:	ba 00 00 00 00       	mov    $0x0,%edx
 5f7:	f7 f1                	div    %ecx
 5f9:	0f b6 92 a4 09 00 00 	movzbl 0x9a4(%edx),%edx
 600:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 604:	89 c2                	mov    %eax,%edx
 606:	85 c0                	test   %eax,%eax
 608:	75 e1                	jne    5eb <printint+0x30>
  if(neg)
 60a:	85 f6                	test   %esi,%esi
 60c:	74 08                	je     616 <printint+0x5b>
    buf[i++] = '-';
 60e:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 613:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 616:	89 d8                	mov    %ebx,%eax
 618:	83 e8 01             	sub    $0x1,%eax
 61b:	78 29                	js     646 <printint+0x8b>
 61d:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 620:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 624:	8d 7d d7             	lea    -0x29(%ebp),%edi
 627:	0f b6 03             	movzbl (%ebx),%eax
 62a:	88 45 d7             	mov    %al,-0x29(%ebp)
 62d:	83 ec 04             	sub    $0x4,%esp
 630:	6a 01                	push   $0x1
 632:	57                   	push   %edi
 633:	56                   	push   %esi
 634:	e8 da fe ff ff       	call   513 <write>
 639:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 63c:	83 c4 10             	add    $0x10,%esp
 63f:	8d 45 d7             	lea    -0x29(%ebp),%eax
 642:	39 c3                	cmp    %eax,%ebx
 644:	75 e1                	jne    627 <printint+0x6c>
    putc(fd, buf[i]);
}
 646:	8d 65 f4             	lea    -0xc(%ebp),%esp
 649:	5b                   	pop    %ebx
 64a:	5e                   	pop    %esi
 64b:	5f                   	pop    %edi
 64c:	5d                   	pop    %ebp
 64d:	c3                   	ret    

0000064e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 64e:	55                   	push   %ebp
 64f:	89 e5                	mov    %esp,%ebp
 651:	57                   	push   %edi
 652:	56                   	push   %esi
 653:	53                   	push   %ebx
 654:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 657:	8b 75 0c             	mov    0xc(%ebp),%esi
 65a:	0f b6 1e             	movzbl (%esi),%ebx
 65d:	84 db                	test   %bl,%bl
 65f:	0f 84 a6 01 00 00    	je     80b <printf+0x1bd>
 665:	83 c6 01             	add    $0x1,%esi
 668:	8d 45 10             	lea    0x10(%ebp),%eax
 66b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 66e:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
 673:	0f be d3             	movsbl %bl,%edx
 676:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 679:	85 ff                	test   %edi,%edi
 67b:	75 25                	jne    6a2 <printf+0x54>
      if(c == '%'){
 67d:	83 f8 25             	cmp    $0x25,%eax
 680:	0f 84 6a 01 00 00    	je     7f0 <printf+0x1a2>
 686:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 689:	83 ec 04             	sub    $0x4,%esp
 68c:	6a 01                	push   $0x1
 68e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 79 fe ff ff       	call   513 <write>
 69a:	83 c4 10             	add    $0x10,%esp
 69d:	e9 5a 01 00 00       	jmp    7fc <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6a2:	83 ff 25             	cmp    $0x25,%edi
 6a5:	0f 85 51 01 00 00    	jne    7fc <printf+0x1ae>
      if(c == 'd'){
 6ab:	83 f8 64             	cmp    $0x64,%eax
 6ae:	75 2c                	jne    6dc <printf+0x8e>
        printint(fd, *ap, 10, 1);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	6a 01                	push   $0x1
 6b5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6ba:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6bd:	8b 17                	mov    (%edi),%edx
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	e8 f4 fe ff ff       	call   5bb <printint>
        ap++;
 6c7:	89 f8                	mov    %edi,%eax
 6c9:	83 c0 04             	add    $0x4,%eax
 6cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6cf:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6d2:	bf 00 00 00 00       	mov    $0x0,%edi
 6d7:	e9 20 01 00 00       	jmp    7fc <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6dc:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 6e2:	83 fa 70             	cmp    $0x70,%edx
 6e5:	75 2c                	jne    713 <printf+0xc5>
        printint(fd, *ap, 16, 0);
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	6a 00                	push   $0x0
 6ec:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6f4:	8b 17                	mov    (%edi),%edx
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	e8 bd fe ff ff       	call   5bb <printint>
        ap++;
 6fe:	89 f8                	mov    %edi,%eax
 700:	83 c0 04             	add    $0x4,%eax
 703:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 706:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 709:	bf 00 00 00 00       	mov    $0x0,%edi
 70e:	e9 e9 00 00 00       	jmp    7fc <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 713:	83 f8 73             	cmp    $0x73,%eax
 716:	75 52                	jne    76a <printf+0x11c>
        s = (char*)*ap;
 718:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 71b:	8b 18                	mov    (%eax),%ebx
        ap++;
 71d:	83 c0 04             	add    $0x4,%eax
 720:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 723:	85 db                	test   %ebx,%ebx
          s = "(null)";
 725:	b8 9d 09 00 00       	mov    $0x99d,%eax
 72a:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 72d:	0f b6 03             	movzbl (%ebx),%eax
 730:	84 c0                	test   %al,%al
 732:	0f 84 bf 00 00 00    	je     7f7 <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 738:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 73b:	89 75 d0             	mov    %esi,-0x30(%ebp)
 73e:	8b 75 08             	mov    0x8(%ebp),%esi
 741:	88 45 e3             	mov    %al,-0x1d(%ebp)
 744:	83 ec 04             	sub    $0x4,%esp
 747:	6a 01                	push   $0x1
 749:	57                   	push   %edi
 74a:	56                   	push   %esi
 74b:	e8 c3 fd ff ff       	call   513 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 750:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 753:	0f b6 03             	movzbl (%ebx),%eax
 756:	83 c4 10             	add    $0x10,%esp
 759:	84 c0                	test   %al,%al
 75b:	75 e4                	jne    741 <printf+0xf3>
 75d:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 760:	bf 00 00 00 00       	mov    $0x0,%edi
 765:	e9 92 00 00 00       	jmp    7fc <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76a:	83 f8 63             	cmp    $0x63,%eax
 76d:	75 2b                	jne    79a <printf+0x14c>
 76f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 772:	8b 07                	mov    (%edi),%eax
 774:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 777:	83 ec 04             	sub    $0x4,%esp
 77a:	6a 01                	push   $0x1
 77c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 8b fd ff ff       	call   513 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 788:	89 f8                	mov    %edi,%eax
 78a:	83 c0 04             	add    $0x4,%eax
 78d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 790:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 793:	bf 00 00 00 00       	mov    $0x0,%edi
 798:	eb 62                	jmp    7fc <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 79a:	83 f8 25             	cmp    $0x25,%eax
 79d:	75 1e                	jne    7bd <printf+0x16f>
 79f:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7a2:	83 ec 04             	sub    $0x4,%esp
 7a5:	6a 01                	push   $0x1
 7a7:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7aa:	50                   	push   %eax
 7ab:	ff 75 08             	pushl  0x8(%ebp)
 7ae:	e8 60 fd ff ff       	call   513 <write>
 7b3:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7b6:	bf 00 00 00 00       	mov    $0x0,%edi
 7bb:	eb 3f                	jmp    7fc <printf+0x1ae>
 7bd:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7c1:	83 ec 04             	sub    $0x4,%esp
 7c4:	6a 01                	push   $0x1
 7c6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7c9:	50                   	push   %eax
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 41 fd ff ff       	call   513 <write>
 7d2:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7d5:	83 c4 0c             	add    $0xc,%esp
 7d8:	6a 01                	push   $0x1
 7da:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7dd:	50                   	push   %eax
 7de:	ff 75 08             	pushl  0x8(%ebp)
 7e1:	e8 2d fd ff ff       	call   513 <write>
 7e6:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7e9:	bf 00 00 00 00       	mov    $0x0,%edi
 7ee:	eb 0c                	jmp    7fc <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 7f0:	bf 25 00 00 00       	mov    $0x25,%edi
 7f5:	eb 05                	jmp    7fc <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7f7:	bf 00 00 00 00       	mov    $0x0,%edi
 7fc:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 803:	84 db                	test   %bl,%bl
 805:	0f 85 68 fe ff ff    	jne    673 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 80b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 80e:	5b                   	pop    %ebx
 80f:	5e                   	pop    %esi
 810:	5f                   	pop    %edi
 811:	5d                   	pop    %ebp
 812:	c3                   	ret    

00000813 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 813:	55                   	push   %ebp
 814:	89 e5                	mov    %esp,%ebp
 816:	57                   	push   %edi
 817:	56                   	push   %esi
 818:	53                   	push   %ebx
 819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81c:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81f:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 824:	eb 0c                	jmp    832 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	8b 10                	mov    (%eax),%edx
 828:	39 d0                	cmp    %edx,%eax
 82a:	72 04                	jb     830 <free+0x1d>
 82c:	39 d1                	cmp    %edx,%ecx
 82e:	72 0c                	jb     83c <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
 830:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	39 c8                	cmp    %ecx,%eax
 834:	73 f0                	jae    826 <free+0x13>
 836:	8b 10                	mov    (%eax),%edx
 838:	39 d1                	cmp    %edx,%ecx
 83a:	73 3e                	jae    87a <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 83c:	8b 73 fc             	mov    -0x4(%ebx),%esi
 83f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 842:	8b 10                	mov    (%eax),%edx
 844:	39 d7                	cmp    %edx,%edi
 846:	75 0f                	jne    857 <free+0x44>
    bp->s.size += p->s.ptr->s.size;
 848:	03 77 04             	add    0x4(%edi),%esi
 84b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	8b 10                	mov    (%eax),%edx
 850:	8b 12                	mov    (%edx),%edx
 852:	89 53 f8             	mov    %edx,-0x8(%ebx)
 855:	eb 03                	jmp    85a <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
 857:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 85a:	8b 50 04             	mov    0x4(%eax),%edx
 85d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 860:	39 f1                	cmp    %esi,%ecx
 862:	75 0d                	jne    871 <free+0x5e>
    p->s.size += bp->s.size;
 864:	03 53 fc             	add    -0x4(%ebx),%edx
 867:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 86a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 86d:	89 10                	mov    %edx,(%eax)
 86f:	eb 02                	jmp    873 <free+0x60>
  } else
    p->s.ptr = bp;
 871:	89 08                	mov    %ecx,(%eax)
  freep = p;
 873:	a3 b8 0c 00 00       	mov    %eax,0xcb8
}
 878:	eb 06                	jmp    880 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	39 d0                	cmp    %edx,%eax
 87c:	72 b2                	jb     830 <free+0x1d>
 87e:	eb bc                	jmp    83c <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
 880:	5b                   	pop    %ebx
 881:	5e                   	pop    %esi
 882:	5f                   	pop    %edi
 883:	5d                   	pop    %ebp
 884:	c3                   	ret    

00000885 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 885:	55                   	push   %ebp
 886:	89 e5                	mov    %esp,%ebp
 888:	57                   	push   %edi
 889:	56                   	push   %esi
 88a:	53                   	push   %ebx
 88b:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
 891:	8d 58 07             	lea    0x7(%eax),%ebx
 894:	c1 eb 03             	shr    $0x3,%ebx
 897:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 89a:	8b 15 b8 0c 00 00    	mov    0xcb8,%edx
 8a0:	85 d2                	test   %edx,%edx
 8a2:	75 23                	jne    8c7 <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
 8a4:	c7 05 b8 0c 00 00 bc 	movl   $0xcbc,0xcb8
 8ab:	0c 00 00 
 8ae:	c7 05 bc 0c 00 00 bc 	movl   $0xcbc,0xcbc
 8b5:	0c 00 00 
    base.s.size = 0;
 8b8:	c7 05 c0 0c 00 00 00 	movl   $0x0,0xcc0
 8bf:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 8c2:	ba bc 0c 00 00       	mov    $0xcbc,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c7:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8c9:	8b 48 04             	mov    0x4(%eax),%ecx
 8cc:	39 cb                	cmp    %ecx,%ebx
 8ce:	77 20                	ja     8f0 <malloc+0x6b>
      if(p->s.size == nunits)
 8d0:	39 cb                	cmp    %ecx,%ebx
 8d2:	75 06                	jne    8da <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
 8d4:	8b 08                	mov    (%eax),%ecx
 8d6:	89 0a                	mov    %ecx,(%edx)
 8d8:	eb 0b                	jmp    8e5 <malloc+0x60>
      else {
        p->s.size -= nunits;
 8da:	29 d9                	sub    %ebx,%ecx
 8dc:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8df:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8e2:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 8e5:	89 15 b8 0c 00 00    	mov    %edx,0xcb8
      return (void*)(p + 1);
 8eb:	83 c0 08             	add    $0x8,%eax
 8ee:	eb 63                	jmp    953 <malloc+0xce>
 8f0:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 8f6:	be 00 10 00 00       	mov    $0x1000,%esi
 8fb:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8fe:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 905:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 907:	39 05 b8 0c 00 00    	cmp    %eax,0xcb8
 90d:	75 2d                	jne    93c <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 90f:	83 ec 0c             	sub    $0xc,%esp
 912:	57                   	push   %edi
 913:	e8 63 fc ff ff       	call   57b <sbrk>
  if(p == (char*)-1)
 918:	83 c4 10             	add    $0x10,%esp
 91b:	83 f8 ff             	cmp    $0xffffffff,%eax
 91e:	74 27                	je     947 <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 920:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 923:	83 ec 0c             	sub    $0xc,%esp
 926:	83 c0 08             	add    $0x8,%eax
 929:	50                   	push   %eax
 92a:	e8 e4 fe ff ff       	call   813 <free>
  return freep;
 92f:	8b 15 b8 0c 00 00    	mov    0xcb8,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 935:	83 c4 10             	add    $0x10,%esp
 938:	85 d2                	test   %edx,%edx
 93a:	74 12                	je     94e <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 93e:	8b 48 04             	mov    0x4(%eax),%ecx
 941:	39 cb                	cmp    %ecx,%ebx
 943:	77 c0                	ja     905 <malloc+0x80>
 945:	eb 89                	jmp    8d0 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
 947:	b8 00 00 00 00       	mov    $0x0,%eax
 94c:	eb 05                	jmp    953 <malloc+0xce>
 94e:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
 953:	8d 65 f4             	lea    -0xc(%ebp),%esp
 956:	5b                   	pop    %ebx
 957:	5e                   	pop    %esi
 958:	5f                   	pop    %edi
 959:	5d                   	pop    %ebp
 95a:	c3                   	ret    
