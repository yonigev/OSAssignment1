
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <strncmp>:
struct backcmd {
  int type;
  struct cmd *cmd;
};

int strncmp(char* s1, char* s2, int len){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	57                   	push   %edi
       4:	56                   	push   %esi
       5:	53                   	push   %ebx
       6:	83 ec 24             	sub    $0x24,%esp
       9:	8b 45 08             	mov    0x8(%ebp),%eax
       c:	8b 55 0c             	mov    0xc(%ebp),%edx
       f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    char s1Char=s1[len];
      12:	8d 34 18             	lea    (%eax,%ebx,1),%esi
      15:	0f b6 3e             	movzbl (%esi),%edi
    char s2Char=s2[len];
      18:	01 d3                	add    %edx,%ebx
      1a:	0f b6 0b             	movzbl (%ebx),%ecx
      1d:	88 4d e7             	mov    %cl,-0x19(%ebp)
    int toReturn;
    s1[len]=0;
      20:	c6 06 00             	movb   $0x0,(%esi)
    s2[len]=0;
      23:	c6 03 00             	movb   $0x0,(%ebx)
    toReturn=strcmp(s1,s2);
      26:	52                   	push   %edx
      27:	50                   	push   %eax
      28:	e8 28 0f 00 00       	call   f55 <strcmp>
    s1[len]=s1Char;
      2d:	89 fa                	mov    %edi,%edx
      2f:	88 16                	mov    %dl,(%esi)
    s2[len]=s2Char;
      31:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
      35:	88 0b                	mov    %cl,(%ebx)
    return toReturn;
    
}
      37:	8d 65 f4             	lea    -0xc(%ebp),%esp
      3a:	5b                   	pop    %ebx
      3b:	5e                   	pop    %esi
      3c:	5f                   	pop    %edi
      3d:	5d                   	pop    %ebp
      3e:	c3                   	ret    

0000003f <shiftAndAdd>:

//shift the command array by 1, and add a new command
//TODO: free old command string?
void shiftAndAdd(char* command){
      3f:	55                   	push   %ebp
      40:	89 e5                	mov    %esp,%ebp
      42:	83 ec 14             	sub    $0x14,%esp
    //printf(1,"SHIFTED!");
    free(history[0]);
      45:	ff 35 40 1d 00 00    	pushl  0x1d40
      4b:	e8 c9 13 00 00       	call   1419 <free>
      50:	b8 44 1d 00 00       	mov    $0x1d44,%eax
      55:	b9 80 1d 00 00       	mov    $0x1d80,%ecx
      5a:	83 c4 10             	add    $0x10,%esp
    //history[0]=0;
    int i;
    for(i=1; i<MAX_HISTORY; i++){
        history[i-1]=history[i];
      5d:	8b 10                	mov    (%eax),%edx
      5f:	89 50 fc             	mov    %edx,-0x4(%eax)
      62:	83 c0 04             	add    $0x4,%eax
void shiftAndAdd(char* command){
    //printf(1,"SHIFTED!");
    free(history[0]);
    //history[0]=0;
    int i;
    for(i=1; i<MAX_HISTORY; i++){
      65:	39 c8                	cmp    %ecx,%eax
      67:	75 f4                	jne    5d <shiftAndAdd+0x1e>
        history[i-1]=history[i];
    }
    history[MAX_HISTORY-1]=command;
      69:	8b 45 08             	mov    0x8(%ebp),%eax
      6c:	a3 7c 1d 00 00       	mov    %eax,0x1d7c
}
      71:	c9                   	leave  
      72:	c3                   	ret    

00000073 <printHistory>:
//check if history command 
void printHistory(){
      73:	55                   	push   %ebp
      74:	89 e5                	mov    %esp,%ebp
      76:	57                   	push   %edi
      77:	56                   	push   %esi
      78:	53                   	push   %ebx
      79:	83 ec 0c             	sub    $0xc,%esp
      7c:	bb 40 1d 00 00       	mov    $0x1d40,%ebx
      81:	bf 80 1d 00 00       	mov    $0x1d80,%edi
    int i;
    int counter=0;
      86:	be 00 00 00 00       	mov    $0x0,%esi
    for(i=0; i<MAX_HISTORY; i++){
        if(history[i]!=0){
      8b:	83 3b 00             	cmpl   $0x0,(%ebx)
      8e:	74 22                	je     b2 <printHistory+0x3f>
            printf(1, "%d. ",counter+1);
      90:	83 c6 01             	add    $0x1,%esi
      93:	83 ec 04             	sub    $0x4,%esp
      96:	56                   	push   %esi
      97:	68 64 15 00 00       	push   $0x1564
      9c:	6a 01                	push   $0x1
      9e:	e8 b1 11 00 00       	call   1254 <printf>
            printf(1,history[i]);
      a3:	83 c4 08             	add    $0x8,%esp
      a6:	ff 33                	pushl  (%ebx)
      a8:	6a 01                	push   $0x1
      aa:	e8 a5 11 00 00       	call   1254 <printf>
      af:	83 c4 10             	add    $0x10,%esp
      b2:	83 c3 04             	add    $0x4,%ebx
}
//check if history command 
void printHistory(){
    int i;
    int counter=0;
    for(i=0; i<MAX_HISTORY; i++){
      b5:	39 fb                	cmp    %edi,%ebx
      b7:	75 d2                	jne    8b <printHistory+0x18>
            counter++;
            //printf(1,"\n");
        }
        
    }
}
      b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      bc:	5b                   	pop    %ebx
      bd:	5e                   	pop    %esi
      be:	5f                   	pop    %edi
      bf:	5d                   	pop    %ebp
      c0:	c3                   	ret    

000000c1 <isPrintHistory>:

//check if the user entered an "history" command
int isPrintHistory(char* buf){
      c1:	55                   	push   %ebp
      c2:	89 e5                	mov    %esp,%ebp
      c4:	83 ec 10             	sub    $0x10,%esp
    if(strcmp(buf,"history\n")==0)
      c7:	68 69 15 00 00       	push   $0x1569
      cc:	ff 75 08             	pushl  0x8(%ebp)
      cf:	e8 81 0e 00 00       	call   f55 <strcmp>
      d4:	83 c4 10             	add    $0x10,%esp
      d7:	85 c0                	test   %eax,%eax
      d9:	0f 94 c0             	sete   %al
      dc:	0f b6 c0             	movzbl %al,%eax
        return 1;
    return 0;    
}
      df:	c9                   	leave  
      e0:	c3                   	ret    

000000e1 <runToNextWord>:
//
char* runToNextWord(char* runner){
      e1:	55                   	push   %ebp
      e2:	89 e5                	mov    %esp,%ebp
      e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i=0;
    while(*runner!=' ' && i<=MAXLEN ){
      e7:	80 39 20             	cmpb   $0x20,(%ecx)
      ea:	74 18                	je     104 <runToNextWord+0x23>
      ec:	89 c8                	mov    %ecx,%eax
        runner++;            //run until space
      ee:	83 c0 01             	add    $0x1,%eax
    return 0;    
}
//
char* runToNextWord(char* runner){
    int i=0;
    while(*runner!=' ' && i<=MAXLEN ){
      f1:	89 c2                	mov    %eax,%edx
      f3:	29 ca                	sub    %ecx,%edx
      f5:	81 fa 80 00 00 00    	cmp    $0x80,%edx
      fb:	7f 09                	jg     106 <runToNextWord+0x25>
      fd:	80 38 20             	cmpb   $0x20,(%eax)
     100:	75 ec                	jne    ee <runToNextWord+0xd>
     102:	eb 02                	jmp    106 <runToNextWord+0x25>
     104:	89 c8                	mov    %ecx,%eax
        runner++;            //run until space
        i++;
    }
    runner=runner+1;
    return runner;
     106:	83 c0 01             	add    $0x1,%eax
}
     109:	5d                   	pop    %ebp
     10a:	c3                   	ret    

0000010b <handleRunFromHistory>:
//handle history -l ##    command
int handleRunFromHistory(char* buf){
     10b:	55                   	push   %ebp
     10c:	89 e5                	mov    %esp,%ebp
     10e:	57                   	push   %edi
     10f:	56                   	push   %esi
     110:	53                   	push   %ebx
     111:	83 ec 10             	sub    $0x10,%esp
     114:	8b 75 08             	mov    0x8(%ebp),%esi
    if(strncmp(buf,"history",7)==0){
     117:	6a 07                	push   $0x7
     119:	68 72 15 00 00       	push   $0x1572
     11e:	56                   	push   %esi
     11f:	e8 dc fe ff ff       	call   0 <strncmp>
     124:	83 c4 10             	add    $0x10,%esp
            strcpy(buf, history[lineToRun]);
            return 1;
            
        }
    }
    return 0;
     127:	bb 00 00 00 00       	mov    $0x0,%ebx
    runner=runner+1;
    return runner;
}
//handle history -l ##    command
int handleRunFromHistory(char* buf){
    if(strncmp(buf,"history",7)==0){
     12c:	85 c0                	test   %eax,%eax
     12e:	75 4f                	jne    17f <handleRunFromHistory+0x74>
     130:	89 c3                	mov    %eax,%ebx
        char* runner=buf;
        runner=runToNextWord(runner);
     132:	83 ec 0c             	sub    $0xc,%esp
     135:	56                   	push   %esi
     136:	e8 a6 ff ff ff       	call   e1 <runToNextWord>
     13b:	83 c4 0c             	add    $0xc,%esp
     13e:	89 c7                	mov    %eax,%edi
        if(strncmp(runner,"-l",2)==0){
     140:	6a 02                	push   $0x2
     142:	68 7a 15 00 00       	push   $0x157a
     147:	50                   	push   %eax
     148:	e8 b3 fe ff ff       	call   0 <strncmp>
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	75 2b                	jne    17f <handleRunFromHistory+0x74>
            runner=runToNextWord(runner);
     154:	83 ec 0c             	sub    $0xc,%esp
     157:	57                   	push   %edi
     158:	e8 84 ff ff ff       	call   e1 <runToNextWord>
            int lineToRun=atoi(runner)-1;
     15d:	89 04 24             	mov    %eax,(%esp)
     160:	e8 2b 0f 00 00       	call   1090 <atoi>
            strcpy(buf, history[lineToRun]);
     165:	83 c4 08             	add    $0x8,%esp
     168:	ff 34 85 3c 1d 00 00 	pushl  0x1d3c(,%eax,4)
     16f:	56                   	push   %esi
     170:	e8 c0 0d 00 00       	call   f35 <strcpy>
            return 1;
     175:	83 c4 10             	add    $0x10,%esp
     178:	bb 01 00 00 00       	mov    $0x1,%ebx
     17d:	eb 00                	jmp    17f <handleRunFromHistory+0x74>
    }
    return 0;
    
    
    
}
     17f:	89 d8                	mov    %ebx,%eax
     181:	8d 65 f4             	lea    -0xc(%ebp),%esp
     184:	5b                   	pop    %ebx
     185:	5e                   	pop    %esi
     186:	5f                   	pop    %edi
     187:	5d                   	pop    %ebp
     188:	c3                   	ret    

00000189 <handleVariableAssign>:
//Handles variable Assignment if needed.
int handleVariableAssign(char* buf){
     189:	55                   	push   %ebp
     18a:	89 e5                	mov    %esp,%ebp
     18c:	57                   	push   %edi
     18d:	56                   	push   %esi
     18e:	53                   	push   %ebx
     18f:	83 ec 18             	sub    $0x18,%esp
     192:	8b 5d 08             	mov    0x8(%ebp),%ebx
//         else return -1;
//     }
//     
//     
    i=0;
    char* variable=malloc(MAX_VAR_LEN);
     195:	6a 20                	push   $0x20
     197:	e8 ef 12 00 00       	call   148b <malloc>
     19c:	89 c6                	mov    %eax,%esi
    char* value=malloc(MAX_VAL_LEN);
     19e:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
     1a5:	e8 e1 12 00 00       	call   148b <malloc>
    //copy the variable
    while(buf[i]!='='){
     1aa:	0f b6 0b             	movzbl (%ebx),%ecx
     1ad:	83 c4 10             	add    $0x10,%esp
     1b0:	80 f9 3d             	cmp    $0x3d,%cl
     1b3:	74 18                	je     1cd <handleVariableAssign+0x44>
     1b5:	ba 00 00 00 00       	mov    $0x0,%edx
        variable[i]=buf[i];
     1ba:	88 0c 16             	mov    %cl,(%esi,%edx,1)
        i++;
     1bd:	83 c2 01             	add    $0x1,%edx
//     
    i=0;
    char* variable=malloc(MAX_VAR_LEN);
    char* value=malloc(MAX_VAL_LEN);
    //copy the variable
    while(buf[i]!='='){
     1c0:	89 d7                	mov    %edx,%edi
     1c2:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     1c6:	80 f9 3d             	cmp    $0x3d,%cl
     1c9:	75 ef                	jne    1ba <handleVariableAssign+0x31>
     1cb:	eb 0a                	jmp    1d7 <handleVariableAssign+0x4e>
     1cd:	bf 00 00 00 00       	mov    $0x0,%edi
//         if(i==MAXLEN) return 0;
//         else return -1;
//     }
//     
//     
    i=0;
     1d2:	ba 00 00 00 00       	mov    $0x0,%edx
    //copy the variable
    while(buf[i]!='='){
        variable[i]=buf[i];
        i++;
    }
    variable[i]=0;       //null terminate
     1d7:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
    //advance index to the value
    i++;
    //copy the value
    while(buf[i]!='\n' && buf[i]!=0 ){
     1db:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
     1e0:	80 f9 0a             	cmp    $0xa,%cl
     1e3:	74 21                	je     206 <handleVariableAssign+0x7d>
     1e5:	84 c9                	test   %cl,%cl
     1e7:	74 1d                	je     206 <handleVariableAssign+0x7d>
     1e9:	bf 00 00 00 00       	mov    $0x0,%edi
     1ee:	01 da                	add    %ebx,%edx
        value[j]=buf[i];
     1f0:	88 0c 38             	mov    %cl,(%eax,%edi,1)
        i++;
        j++;
     1f3:	83 c7 01             	add    $0x1,%edi
    }
    variable[i]=0;       //null terminate
    //advance index to the value
    i++;
    //copy the value
    while(buf[i]!='\n' && buf[i]!=0 ){
     1f6:	0f b6 4c 3a 01       	movzbl 0x1(%edx,%edi,1),%ecx
     1fb:	80 f9 0a             	cmp    $0xa,%cl
     1fe:	74 0b                	je     20b <handleVariableAssign+0x82>
     200:	84 c9                	test   %cl,%cl
     202:	75 ec                	jne    1f0 <handleVariableAssign+0x67>
     204:	eb 05                	jmp    20b <handleVariableAssign+0x82>
    
}
//Handles variable Assignment if needed.
int handleVariableAssign(char* buf){
    int i=0;        //index to iterate over buf
    int j=0;        //index to iterate over value
     206:	bf 00 00 00 00       	mov    $0x0,%edi
    while(buf[i]!='\n' && buf[i]!=0 ){
        value[j]=buf[i];
        i++;
        j++;
    }
    value[j]=0;       //null terminate
     20b:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
    return setvariable(variable, value);
     20f:	83 ec 08             	sub    $0x8,%esp
     212:	50                   	push   %eax
     213:	56                   	push   %esi
     214:	e8 80 0f 00 00       	call   1199 <setvariable>
    //printf(1,"<%s,%s>\n",variable,value);
    
    //return success;
    
    
}
     219:	8d 65 f4             	lea    -0xc(%ebp),%esp
     21c:	5b                   	pop    %ebx
     21d:	5e                   	pop    %esi
     21e:	5f                   	pop    %edi
     21f:	5d                   	pop    %ebp
     220:	c3                   	ret    

00000221 <insertValue>:


//insert the correct value at index 'swapIndex'
int insertValue(char* buf, int swapIndex){
     221:	55                   	push   %ebp
     222:	89 e5                	mov    %esp,%ebp
     224:	57                   	push   %edi
     225:	56                   	push   %esi
     226:	53                   	push   %ebx
     227:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
     22d:	8b 75 0c             	mov    0xc(%ebp),%esi
    int i=swapIndex+1; //point to the variable's name
    int varIndex=0;    //iterate over the variable's name
    char swapped[MAXLEN]={0};
     230:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
     236:	b9 20 00 00 00       	mov    $0x20,%ecx
     23b:	b8 00 00 00 00       	mov    $0x0,%eax
     240:	f3 ab                	rep stos %eax,%es:(%edi)
    char variable[MAX_VAR_LEN]={0};
     242:	ba 20 00 00 00       	mov    $0x20,%edx
     247:	89 8c 05 48 ff ff ff 	mov    %ecx,-0xb8(%ebp,%eax,1)
     24e:	83 c0 04             	add    $0x4,%eax
     251:	39 d0                	cmp    %edx,%eax
     253:	72 f2                	jb     247 <insertValue+0x26>
    char value[MAX_VAL_LEN]={0};
     255:	8d bd c8 fe ff ff    	lea    -0x138(%ebp),%edi
     25b:	b9 20 00 00 00       	mov    $0x20,%ecx
     260:	b8 00 00 00 00       	mov    $0x0,%eax
     265:	f3 ab                	rep stos %eax,%es:(%edi)
    //add to variable, until reaching ending of variable name.
    while(buf[i]!='$' && buf[i]!=' ' && buf[i]!='\n' && buf[i]!=0){
     267:	8b 45 08             	mov    0x8(%ebp),%eax
     26a:	0f b6 44 30 01       	movzbl 0x1(%eax,%esi,1),%eax
     26f:	3c 24                	cmp    $0x24,%al
     271:	0f 95 c1             	setne  %cl
     274:	3c 0a                	cmp    $0xa,%al
     276:	0f 95 c2             	setne  %dl
     279:	84 d1                	test   %dl,%cl
     27b:	74 31                	je     2ae <insertValue+0x8d>
     27d:	a8 df                	test   $0xdf,%al
     27f:	74 2d                	je     2ae <insertValue+0x8d>
     281:	ba 00 00 00 00       	mov    $0x0,%edx
     286:	89 f7                	mov    %esi,%edi
     288:	03 7d 08             	add    0x8(%ebp),%edi
        variable[varIndex]=buf[i];
     28b:	88 84 15 48 ff ff ff 	mov    %al,-0xb8(%ebp,%edx,1)
        i++;
        varIndex++;        
     292:	83 c2 01             	add    $0x1,%edx
    int varIndex=0;    //iterate over the variable's name
    char swapped[MAXLEN]={0};
    char variable[MAX_VAR_LEN]={0};
    char value[MAX_VAL_LEN]={0};
    //add to variable, until reaching ending of variable name.
    while(buf[i]!='$' && buf[i]!=' ' && buf[i]!='\n' && buf[i]!=0){
     295:	0f b6 44 17 01       	movzbl 0x1(%edi,%edx,1),%eax
     29a:	3c 24                	cmp    $0x24,%al
     29c:	0f 95 c3             	setne  %bl
     29f:	3c 0a                	cmp    $0xa,%al
     2a1:	0f 95 c1             	setne  %cl
     2a4:	84 cb                	test   %cl,%bl
     2a6:	74 0b                	je     2b3 <insertValue+0x92>
     2a8:	a8 df                	test   $0xdf,%al
     2aa:	75 df                	jne    28b <insertValue+0x6a>
     2ac:	eb 05                	jmp    2b3 <insertValue+0x92>


//insert the correct value at index 'swapIndex'
int insertValue(char* buf, int swapIndex){
    int i=swapIndex+1; //point to the variable's name
    int varIndex=0;    //iterate over the variable's name
     2ae:	ba 00 00 00 00       	mov    $0x0,%edx
    while(buf[i]!='$' && buf[i]!=' ' && buf[i]!='\n' && buf[i]!=0){
        variable[varIndex]=buf[i];
        i++;
        varIndex++;        
    }
    variable[varIndex]=0;    //null terminate the variable name
     2b3:	c6 84 15 48 ff ff ff 	movb   $0x0,-0xb8(%ebp,%edx,1)
     2ba:	00 
    //now variable has the needed name, put the value into value
    int varExists=getvariable((char*)&variable,(char*)&value);
     2bb:	83 ec 08             	sub    $0x8,%esp
     2be:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
     2c4:	50                   	push   %eax
     2c5:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
     2cb:	50                   	push   %eax
     2cc:	e8 d0 0e 00 00       	call   11a1 <getvariable>
     2d1:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
//     printf(1,"<%s,%s>\n",&variable,&value);
//     printf(1,"varExists: %d\n",varExists);
    if(varExists!=0){
     2d7:	83 c4 10             	add    $0x10,%esp
     2da:	85 c0                	test   %eax,%eax
     2dc:	0f 85 f0 00 00 00    	jne    3d2 <insertValue+0x1b1>
        return varExists;
    }
    //create the new array after swapping
    i=0;
    int newIndex=0;
    while(i<swapIndex){
     2e2:	85 f6                	test   %esi,%esi
     2e4:	7e 15                	jle    2fb <insertValue+0xda>
     2e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
        swapped[i]=buf[i];
     2e9:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
     2ed:	88 94 05 68 ff ff ff 	mov    %dl,-0x98(%ebp,%eax,1)
        i++;
     2f4:	83 c0 01             	add    $0x1,%eax
        return varExists;
    }
    //create the new array after swapping
    i=0;
    int newIndex=0;
    while(i<swapIndex){
     2f7:	39 c6                	cmp    %eax,%esi
     2f9:	75 ee                	jne    2e9 <insertValue+0xc8>
     2fb:	bb 00 00 00 00       	mov    $0x0,%ebx
    }
    //now copy the value
    newIndex=swapIndex;
    int j;
    for(j=0; j<strlen(value); j++){
        swapped[newIndex]=value[j];
     300:	8d 84 35 68 ff ff ff 	lea    -0x98(%ebp,%esi,1),%eax
     307:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
     30d:	eb 14                	jmp    323 <insertValue+0x102>
     30f:	0f b6 84 1d c8 fe ff 	movzbl -0x138(%ebp,%ebx,1),%eax
     316:	ff 
     317:	8b 8d bc fe ff ff    	mov    -0x144(%ebp),%ecx
     31d:	88 04 19             	mov    %al,(%ecx,%ebx,1)
        //newIndex++;
    }
    //now copy the value
    newIndex=swapIndex;
    int j;
    for(j=0; j<strlen(value); j++){
     320:	83 c3 01             	add    $0x1,%ebx
     323:	89 b5 c0 fe ff ff    	mov    %esi,-0x140(%ebp)
     329:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
     32c:	89 bd c4 fe ff ff    	mov    %edi,-0x13c(%ebp)
     332:	83 ec 0c             	sub    $0xc,%esp
     335:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
     33b:	50                   	push   %eax
     33c:	e8 43 0c 00 00       	call   f84 <strlen>
     341:	83 c4 10             	add    $0x10,%esp
     344:	39 d8                	cmp    %ebx,%eax
     346:	77 c7                	ja     30f <insertValue+0xee>
        swapped[newIndex]=value[j];
        newIndex++;        
    }
    //now copy the rest to "swapped"
    i=swapIndex+strlen(variable) + 1;   //point to the spot after $<varname>
     348:	83 ec 0c             	sub    $0xc,%esp
     34b:	8d 85 48 ff ff ff    	lea    -0xb8(%ebp),%eax
     351:	50                   	push   %eax
     352:	e8 2d 0c 00 00       	call   f84 <strlen>
     357:	8b 95 c0 fe ff ff    	mov    -0x140(%ebp),%edx
     35d:	8d 4c 10 01          	lea    0x1(%eax,%edx,1),%ecx
    while(buf[i]!='\n' && i<=MAXLEN){
     361:	8b 45 08             	mov    0x8(%ebp),%eax
     364:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
     368:	83 c4 10             	add    $0x10,%esp
     36b:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
     371:	7f 3c                	jg     3af <insertValue+0x18e>
     373:	3c 0a                	cmp    $0xa,%al
     375:	74 38                	je     3af <insertValue+0x18e>
     377:	29 f9                	sub    %edi,%ecx
     379:	89 cb                	mov    %ecx,%ebx
     37b:	03 5d 08             	add    0x8(%ebp),%ebx
     37e:	8b 95 c4 fe ff ff    	mov    -0x13c(%ebp),%edx
        swapped[newIndex]=buf[i];
     384:	88 84 15 68 ff ff ff 	mov    %al,-0x98(%ebp,%edx,1)
        i++;
        newIndex++;
     38b:	83 c2 01             	add    $0x1,%edx
        swapped[newIndex]=value[j];
        newIndex++;        
    }
    //now copy the rest to "swapped"
    i=swapIndex+strlen(variable) + 1;   //point to the spot after $<varname>
    while(buf[i]!='\n' && i<=MAXLEN){
     38e:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
     392:	8d 34 0a             	lea    (%edx,%ecx,1),%esi
     395:	81 fe 80 00 00 00    	cmp    $0x80,%esi
     39b:	7f 0c                	jg     3a9 <insertValue+0x188>
     39d:	3c 0a                	cmp    $0xa,%al
     39f:	75 e3                	jne    384 <insertValue+0x163>
     3a1:	89 95 c4 fe ff ff    	mov    %edx,-0x13c(%ebp)
     3a7:	eb 06                	jmp    3af <insertValue+0x18e>
     3a9:	89 95 c4 fe ff ff    	mov    %edx,-0x13c(%ebp)
        swapped[newIndex]=buf[i];
        i++;
        newIndex++;
    }
    swapped[newIndex]=0;
     3af:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
     3b5:	c6 84 05 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%eax,1)
     3bc:	00 
    strcpy(buf,swapped);    //copy the swapped line into buf, and return    
     3bd:	83 ec 08             	sub    $0x8,%esp
     3c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
     3c6:	50                   	push   %eax
     3c7:	ff 75 08             	pushl  0x8(%ebp)
     3ca:	e8 66 0b 00 00       	call   f35 <strcpy>
    //memset(buf,MAXLEN,0);
    return varExists;
     3cf:	83 c4 10             	add    $0x10,%esp
}
     3d2:	8b 85 b8 fe ff ff    	mov    -0x148(%ebp),%eax
     3d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3db:	5b                   	pop    %ebx
     3dc:	5e                   	pop    %esi
     3dd:	5f                   	pop    %edi
     3de:	5d                   	pop    %ebp
     3df:	c3                   	ret    

000003e0 <swapAllVariables>:
//Swap all $<var> to their values.
void swapAllVariables(char* buf){
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	56                   	push   %esi
     3e4:	53                   	push   %ebx
     3e5:	8b 75 08             	mov    0x8(%ebp),%esi
    int i=0;            //iterate over buf
    //char* swapped=malloc(MAXLEN);   //the new buf after swapping $<?> with value
    while(buf[i]!='\n' && i<=MAXLEN && buf[i]!=0){
     3e8:	0f b6 06             	movzbl (%esi),%eax
     3eb:	3c 0a                	cmp    $0xa,%al
     3ed:	74 37                	je     426 <swapAllVariables+0x46>
     3ef:	84 c0                	test   %al,%al
     3f1:	74 33                	je     426 <swapAllVariables+0x46>
     3f3:	bb 00 00 00 00       	mov    $0x0,%ebx
        //if  $ sign, swap in swapped
        if(buf[i]=='$'){
     3f8:	3c 24                	cmp    $0x24,%al
     3fa:	75 0d                	jne    409 <swapAllVariables+0x29>
            insertValue(buf, i);
     3fc:	83 ec 08             	sub    $0x8,%esp
     3ff:	53                   	push   %ebx
     400:	56                   	push   %esi
     401:	e8 1b fe ff ff       	call   221 <insertValue>
     406:	83 c4 10             	add    $0x10,%esp
        }
        i++;
     409:	83 c3 01             	add    $0x1,%ebx
}
//Swap all $<var> to their values.
void swapAllVariables(char* buf){
    int i=0;            //iterate over buf
    //char* swapped=malloc(MAXLEN);   //the new buf after swapping $<?> with value
    while(buf[i]!='\n' && i<=MAXLEN && buf[i]!=0){
     40c:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
     410:	3c 0a                	cmp    $0xa,%al
     412:	0f 95 c1             	setne  %cl
     415:	84 c0                	test   %al,%al
     417:	0f 95 c2             	setne  %dl
     41a:	84 d1                	test   %dl,%cl
     41c:	74 08                	je     426 <swapAllVariables+0x46>
     41e:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
     424:	7e d2                	jle    3f8 <swapAllVariables+0x18>
        }
        i++;
    }
    

}
     426:	8d 65 f8             	lea    -0x8(%ebp),%esp
     429:	5b                   	pop    %ebx
     42a:	5e                   	pop    %esi
     42b:	5d                   	pop    %ebp
     42c:	c3                   	ret    

0000042d <handleVariableCommand>:
//return 0 to continue (skip iteration), or 1 to run as usual
int handleVariableCommand(char* buf){
     42d:	55                   	push   %ebp
     42e:	89 e5                	mov    %esp,%ebp
     430:	83 ec 08             	sub    $0x8,%esp
     433:	8b 4d 08             	mov    0x8(%ebp),%ecx
    int i;
    for(i=0; i<MAXLEN; i++){//iterate over the line
        if(buf[i]=='=')     //if assigning
     436:	80 39 3d             	cmpb   $0x3d,(%ecx)
     439:	74 0e                	je     449 <handleVariableCommand+0x1c>
     43b:	8d 41 01             	lea    0x1(%ecx),%eax
     43e:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
     444:	80 38 3d             	cmpb   $0x3d,(%eax)
     447:	75 0e                	jne    457 <handleVariableCommand+0x2a>
            return handleVariableAssign(buf);
     449:	83 ec 0c             	sub    $0xc,%esp
     44c:	51                   	push   %ecx
     44d:	e8 37 fd ff ff       	call   189 <handleVariableAssign>
     452:	83 c4 10             	add    $0x10,%esp
     455:	eb 0c                	jmp    463 <handleVariableCommand+0x36>
     457:	83 c0 01             	add    $0x1,%eax

}
//return 0 to continue (skip iteration), or 1 to run as usual
int handleVariableCommand(char* buf){
    int i;
    for(i=0; i<MAXLEN; i++){//iterate over the line
     45a:	39 d0                	cmp    %edx,%eax
     45c:	75 e6                	jne    444 <handleVariableCommand+0x17>
        if(buf[i]=='=')     //if assigning
            return handleVariableAssign(buf);
    }
    return 1;  //no assignment needed
     45e:	b8 01 00 00 00       	mov    $0x1,%eax
}
     463:	c9                   	leave  
     464:	c3                   	ret    

00000465 <addCommand>:
void panic(char*);
struct cmd *parsecmd(char*);

//add a command to the history array
//if there's not place in the history array, shift all commands, then add.
void addCommand(char* buf){
     465:	55                   	push   %ebp
     466:	89 e5                	mov    %esp,%ebp
     468:	53                   	push   %ebx
     469:	83 ec 10             	sub    $0x10,%esp
    char* command=malloc(MAXLEN);
     46c:	68 80 00 00 00       	push   $0x80
     471:	e8 15 10 00 00       	call   148b <malloc>
     476:	89 c3                	mov    %eax,%ebx
    int foundSpot=0;
    strcpy(command,buf);   
     478:	83 c4 08             	add    $0x8,%esp
     47b:	ff 75 08             	pushl  0x8(%ebp)
     47e:	50                   	push   %eax
     47f:	e8 b1 0a 00 00       	call   f35 <strcpy>
    int i;
    for(i=0; i<MAX_HISTORY; i++){
        if(history[i] == 0){
     484:	83 c4 10             	add    $0x10,%esp
     487:	83 3d 40 1d 00 00 00 	cmpl   $0x0,0x1d40
     48e:	74 11                	je     4a1 <addCommand+0x3c>
     490:	b8 01 00 00 00       	mov    $0x1,%eax
     495:	83 3c 85 40 1d 00 00 	cmpl   $0x0,0x1d40(,%eax,4)
     49c:	00 
     49d:	75 10                	jne    4af <addCommand+0x4a>
     49f:	eb 05                	jmp    4a6 <addCommand+0x41>
void addCommand(char* buf){
    char* command=malloc(MAXLEN);
    int foundSpot=0;
    strcpy(command,buf);   
    int i;
    for(i=0; i<MAX_HISTORY; i++){
     4a1:	b8 00 00 00 00       	mov    $0x0,%eax
        if(history[i] == 0){
            history[i]=command;
     4a6:	89 1c 85 40 1d 00 00 	mov    %ebx,0x1d40(,%eax,4)
     4ad:	eb 14                	jmp    4c3 <addCommand+0x5e>
void addCommand(char* buf){
    char* command=malloc(MAXLEN);
    int foundSpot=0;
    strcpy(command,buf);   
    int i;
    for(i=0; i<MAX_HISTORY; i++){
     4af:	83 c0 01             	add    $0x1,%eax
     4b2:	83 f8 10             	cmp    $0x10,%eax
     4b5:	75 de                	jne    495 <addCommand+0x30>
            foundSpot=1;
            break;
        }
    }
    if(!foundSpot){
        shiftAndAdd(command);
     4b7:	83 ec 0c             	sub    $0xc,%esp
     4ba:	53                   	push   %ebx
     4bb:	e8 7f fb ff ff       	call   3f <shiftAndAdd>
     4c0:	83 c4 10             	add    $0x10,%esp
        
    }
}
     4c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4c6:	c9                   	leave  
     4c7:	c3                   	ret    

000004c8 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
     4c8:	55                   	push   %ebp
     4c9:	89 e5                	mov    %esp,%ebp
     4cb:	56                   	push   %esi
     4cc:	53                   	push   %ebx
     4cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
     4d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     4d3:	83 ec 08             	sub    $0x8,%esp
     4d6:	68 7d 15 00 00       	push   $0x157d
     4db:	6a 02                	push   $0x2
     4dd:	e8 72 0d 00 00       	call   1254 <printf>
  memset(buf, 0, nbuf);
     4e2:	83 c4 0c             	add    $0xc,%esp
     4e5:	56                   	push   %esi
     4e6:	6a 00                	push   $0x0
     4e8:	53                   	push   %ebx
     4e9:	e8 ba 0a 00 00       	call   fa8 <memset>
  gets(buf, nbuf);
     4ee:	83 c4 08             	add    $0x8,%esp
     4f1:	56                   	push   %esi
     4f2:	53                   	push   %ebx
     4f3:	e8 fd 0a 00 00       	call   ff5 <gets>
     4f8:	83 c4 10             	add    $0x10,%esp
     4fb:	80 3b 00             	cmpb   $0x0,(%ebx)
     4fe:	0f 94 c0             	sete   %al
     501:	0f b6 c0             	movzbl %al,%eax
     504:	f7 d8                	neg    %eax
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}
     506:	8d 65 f8             	lea    -0x8(%ebp),%esp
     509:	5b                   	pop    %ebx
     50a:	5e                   	pop    %esi
     50b:	5d                   	pop    %ebp
     50c:	c3                   	ret    

0000050d <panic>:
  exit();
}

void
panic(char *s)
{
     50d:	55                   	push   %ebp
     50e:	89 e5                	mov    %esp,%ebp
     510:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     513:	ff 75 08             	pushl  0x8(%ebp)
     516:	68 1a 16 00 00       	push   $0x161a
     51b:	6a 02                	push   $0x2
     51d:	e8 32 0d 00 00       	call   1254 <printf>
  exit();
     522:	e8 d2 0b 00 00       	call   10f9 <exit>

00000527 <fork1>:
}

int
fork1(void)
{
     527:	55                   	push   %ebp
     528:	89 e5                	mov    %esp,%ebp
     52a:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
     52d:	e8 bf 0b 00 00       	call   10f1 <fork>
  if(pid == -1)
     532:	83 f8 ff             	cmp    $0xffffffff,%eax
     535:	75 0d                	jne    544 <fork1+0x1d>
    panic("fork");
     537:	83 ec 0c             	sub    $0xc,%esp
     53a:	68 80 15 00 00       	push   $0x1580
     53f:	e8 c9 ff ff ff       	call   50d <panic>
  return pid;
}
     544:	c9                   	leave  
     545:	c3                   	ret    

00000546 <runcmd>:


// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     546:	55                   	push   %ebp
     547:	89 e5                	mov    %esp,%ebp
     549:	53                   	push   %ebx
     54a:	83 ec 14             	sub    $0x14,%esp
     54d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  if(cmd == 0)
     550:	85 db                	test   %ebx,%ebx
     552:	75 05                	jne    559 <runcmd+0x13>
    exit();
     554:	e8 a0 0b 00 00       	call   10f9 <exit>

  switch(cmd->type){
     559:	83 3b 05             	cmpl   $0x5,(%ebx)
     55c:	77 09                	ja     567 <runcmd+0x21>
     55e:	8b 03                	mov    (%ebx),%eax
     560:	ff 24 85 34 16 00 00 	jmp    *0x1634(,%eax,4)
  default:
    panic("runcmd");
     567:	83 ec 0c             	sub    $0xc,%esp
     56a:	68 85 15 00 00       	push   $0x1585
     56f:	e8 99 ff ff ff       	call   50d <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
     574:	8b 43 04             	mov    0x4(%ebx),%eax
     577:	85 c0                	test   %eax,%eax
     579:	75 05                	jne    580 <runcmd+0x3a>
      exit();
     57b:	e8 79 0b 00 00       	call   10f9 <exit>
    exec(ecmd->argv[0], ecmd->argv);
     580:	83 ec 08             	sub    $0x8,%esp
     583:	8d 53 04             	lea    0x4(%ebx),%edx
     586:	52                   	push   %edx
     587:	50                   	push   %eax
     588:	e8 a4 0b 00 00       	call   1131 <exec>

    printf(2, "exec %s failed\n", ecmd->argv[0]);
     58d:	83 c4 0c             	add    $0xc,%esp
     590:	ff 73 04             	pushl  0x4(%ebx)
     593:	68 8c 15 00 00       	push   $0x158c
     598:	6a 02                	push   $0x2
     59a:	e8 b5 0c 00 00       	call   1254 <printf>
    break;
     59f:	83 c4 10             	add    $0x10,%esp
     5a2:	e9 3d 01 00 00       	jmp    6e4 <runcmd+0x19e>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
     5a7:	83 ec 0c             	sub    $0xc,%esp
     5aa:	ff 73 14             	pushl  0x14(%ebx)
     5ad:	e8 6f 0b 00 00       	call   1121 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     5b2:	83 c4 08             	add    $0x8,%esp
     5b5:	ff 73 10             	pushl  0x10(%ebx)
     5b8:	ff 73 08             	pushl  0x8(%ebx)
     5bb:	e8 79 0b 00 00       	call   1139 <open>
     5c0:	83 c4 10             	add    $0x10,%esp
     5c3:	85 c0                	test   %eax,%eax
     5c5:	79 17                	jns    5de <runcmd+0x98>
      printf(2, "open %s failed\n", rcmd->file);
     5c7:	83 ec 04             	sub    $0x4,%esp
     5ca:	ff 73 08             	pushl  0x8(%ebx)
     5cd:	68 9c 15 00 00       	push   $0x159c
     5d2:	6a 02                	push   $0x2
     5d4:	e8 7b 0c 00 00       	call   1254 <printf>
      exit();
     5d9:	e8 1b 0b 00 00       	call   10f9 <exit>
    }
    runcmd(rcmd->cmd);
     5de:	83 ec 0c             	sub    $0xc,%esp
     5e1:	ff 73 04             	pushl  0x4(%ebx)
     5e4:	e8 5d ff ff ff       	call   546 <runcmd>
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
     5e9:	e8 39 ff ff ff       	call   527 <fork1>
     5ee:	85 c0                	test   %eax,%eax
     5f0:	75 0b                	jne    5fd <runcmd+0xb7>
      runcmd(lcmd->left);
     5f2:	83 ec 0c             	sub    $0xc,%esp
     5f5:	ff 73 04             	pushl  0x4(%ebx)
     5f8:	e8 49 ff ff ff       	call   546 <runcmd>
    wait();
     5fd:	e8 ff 0a 00 00       	call   1101 <wait>
    runcmd(lcmd->right);
     602:	83 ec 0c             	sub    $0xc,%esp
     605:	ff 73 08             	pushl  0x8(%ebx)
     608:	e8 39 ff ff ff       	call   546 <runcmd>
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
     60d:	83 ec 0c             	sub    $0xc,%esp
     610:	8d 45 f0             	lea    -0x10(%ebp),%eax
     613:	50                   	push   %eax
     614:	e8 f0 0a 00 00       	call   1109 <pipe>
     619:	83 c4 10             	add    $0x10,%esp
     61c:	85 c0                	test   %eax,%eax
     61e:	79 0d                	jns    62d <runcmd+0xe7>
      panic("pipe");
     620:	83 ec 0c             	sub    $0xc,%esp
     623:	68 ac 15 00 00       	push   $0x15ac
     628:	e8 e0 fe ff ff       	call   50d <panic>
    if(fork1() == 0){
     62d:	e8 f5 fe ff ff       	call   527 <fork1>
     632:	85 c0                	test   %eax,%eax
     634:	75 36                	jne    66c <runcmd+0x126>
      close(1);
     636:	83 ec 0c             	sub    $0xc,%esp
     639:	6a 01                	push   $0x1
     63b:	e8 e1 0a 00 00       	call   1121 <close>
      dup(p[1]);
     640:	83 c4 04             	add    $0x4,%esp
     643:	ff 75 f4             	pushl  -0xc(%ebp)
     646:	e8 26 0b 00 00       	call   1171 <dup>
      close(p[0]);
     64b:	83 c4 04             	add    $0x4,%esp
     64e:	ff 75 f0             	pushl  -0x10(%ebp)
     651:	e8 cb 0a 00 00       	call   1121 <close>
      close(p[1]);
     656:	83 c4 04             	add    $0x4,%esp
     659:	ff 75 f4             	pushl  -0xc(%ebp)
     65c:	e8 c0 0a 00 00       	call   1121 <close>
      runcmd(pcmd->left);
     661:	83 c4 04             	add    $0x4,%esp
     664:	ff 73 04             	pushl  0x4(%ebx)
     667:	e8 da fe ff ff       	call   546 <runcmd>
    }
    if(fork1() == 0){
     66c:	e8 b6 fe ff ff       	call   527 <fork1>
     671:	85 c0                	test   %eax,%eax
     673:	75 36                	jne    6ab <runcmd+0x165>
      close(0);
     675:	83 ec 0c             	sub    $0xc,%esp
     678:	6a 00                	push   $0x0
     67a:	e8 a2 0a 00 00       	call   1121 <close>
      dup(p[0]);
     67f:	83 c4 04             	add    $0x4,%esp
     682:	ff 75 f0             	pushl  -0x10(%ebp)
     685:	e8 e7 0a 00 00       	call   1171 <dup>
      close(p[0]);
     68a:	83 c4 04             	add    $0x4,%esp
     68d:	ff 75 f0             	pushl  -0x10(%ebp)
     690:	e8 8c 0a 00 00       	call   1121 <close>
      close(p[1]);
     695:	83 c4 04             	add    $0x4,%esp
     698:	ff 75 f4             	pushl  -0xc(%ebp)
     69b:	e8 81 0a 00 00       	call   1121 <close>
      runcmd(pcmd->right);
     6a0:	83 c4 04             	add    $0x4,%esp
     6a3:	ff 73 08             	pushl  0x8(%ebx)
     6a6:	e8 9b fe ff ff       	call   546 <runcmd>
    }
    close(p[0]);
     6ab:	83 ec 0c             	sub    $0xc,%esp
     6ae:	ff 75 f0             	pushl  -0x10(%ebp)
     6b1:	e8 6b 0a 00 00       	call   1121 <close>
    close(p[1]);
     6b6:	83 c4 04             	add    $0x4,%esp
     6b9:	ff 75 f4             	pushl  -0xc(%ebp)
     6bc:	e8 60 0a 00 00       	call   1121 <close>
    wait();
     6c1:	e8 3b 0a 00 00       	call   1101 <wait>
    wait();
     6c6:	e8 36 0a 00 00       	call   1101 <wait>
    break;
     6cb:	83 c4 10             	add    $0x10,%esp
     6ce:	eb 14                	jmp    6e4 <runcmd+0x19e>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
     6d0:	e8 52 fe ff ff       	call   527 <fork1>
     6d5:	85 c0                	test   %eax,%eax
     6d7:	75 0b                	jne    6e4 <runcmd+0x19e>
      runcmd(bcmd->cmd);
     6d9:	83 ec 0c             	sub    $0xc,%esp
     6dc:	ff 73 04             	pushl  0x4(%ebx)
     6df:	e8 62 fe ff ff       	call   546 <runcmd>
    break;
  }
  exit();
     6e4:	e8 10 0a 00 00       	call   10f9 <exit>

000006e9 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     6e9:	55                   	push   %ebp
     6ea:	89 e5                	mov    %esp,%ebp
     6ec:	53                   	push   %ebx
     6ed:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6f0:	6a 54                	push   $0x54
     6f2:	e8 94 0d 00 00       	call   148b <malloc>
     6f7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     6f9:	83 c4 0c             	add    $0xc,%esp
     6fc:	6a 54                	push   $0x54
     6fe:	6a 00                	push   $0x0
     700:	50                   	push   %eax
     701:	e8 a2 08 00 00       	call   fa8 <memset>
  cmd->type = EXEC;
     706:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     70c:	89 d8                	mov    %ebx,%eax
     70e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     711:	c9                   	leave  
     712:	c3                   	ret    

00000713 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     713:	55                   	push   %ebp
     714:	89 e5                	mov    %esp,%ebp
     716:	53                   	push   %ebx
     717:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     71a:	6a 18                	push   $0x18
     71c:	e8 6a 0d 00 00       	call   148b <malloc>
     721:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     723:	83 c4 0c             	add    $0xc,%esp
     726:	6a 18                	push   $0x18
     728:	6a 00                	push   $0x0
     72a:	50                   	push   %eax
     72b:	e8 78 08 00 00       	call   fa8 <memset>
  cmd->type = REDIR;
     730:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     736:	8b 45 08             	mov    0x8(%ebp),%eax
     739:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     73c:	8b 45 0c             	mov    0xc(%ebp),%eax
     73f:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     742:	8b 45 10             	mov    0x10(%ebp),%eax
     745:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     748:	8b 45 14             	mov    0x14(%ebp),%eax
     74b:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     74e:	8b 45 18             	mov    0x18(%ebp),%eax
     751:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     754:	89 d8                	mov    %ebx,%eax
     756:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     759:	c9                   	leave  
     75a:	c3                   	ret    

0000075b <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     75b:	55                   	push   %ebp
     75c:	89 e5                	mov    %esp,%ebp
     75e:	53                   	push   %ebx
     75f:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     762:	6a 0c                	push   $0xc
     764:	e8 22 0d 00 00       	call   148b <malloc>
     769:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     76b:	83 c4 0c             	add    $0xc,%esp
     76e:	6a 0c                	push   $0xc
     770:	6a 00                	push   $0x0
     772:	50                   	push   %eax
     773:	e8 30 08 00 00       	call   fa8 <memset>
  cmd->type = PIPE;
     778:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     77e:	8b 45 08             	mov    0x8(%ebp),%eax
     781:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     78a:	89 d8                	mov    %ebx,%eax
     78c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     78f:	c9                   	leave  
     790:	c3                   	ret    

00000791 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     791:	55                   	push   %ebp
     792:	89 e5                	mov    %esp,%ebp
     794:	53                   	push   %ebx
     795:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     798:	6a 0c                	push   $0xc
     79a:	e8 ec 0c 00 00       	call   148b <malloc>
     79f:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7a1:	83 c4 0c             	add    $0xc,%esp
     7a4:	6a 0c                	push   $0xc
     7a6:	6a 00                	push   $0x0
     7a8:	50                   	push   %eax
     7a9:	e8 fa 07 00 00       	call   fa8 <memset>
  cmd->type = LIST;
     7ae:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     7b4:	8b 45 08             	mov    0x8(%ebp),%eax
     7b7:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     7ba:	8b 45 0c             	mov    0xc(%ebp),%eax
     7bd:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     7c0:	89 d8                	mov    %ebx,%eax
     7c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7c5:	c9                   	leave  
     7c6:	c3                   	ret    

000007c7 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     7c7:	55                   	push   %ebp
     7c8:	89 e5                	mov    %esp,%ebp
     7ca:	53                   	push   %ebx
     7cb:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7ce:	6a 08                	push   $0x8
     7d0:	e8 b6 0c 00 00       	call   148b <malloc>
     7d5:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7d7:	83 c4 0c             	add    $0xc,%esp
     7da:	6a 08                	push   $0x8
     7dc:	6a 00                	push   $0x0
     7de:	50                   	push   %eax
     7df:	e8 c4 07 00 00       	call   fa8 <memset>
  cmd->type = BACK;
     7e4:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     7ea:	8b 45 08             	mov    0x8(%ebp),%eax
     7ed:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     7f0:	89 d8                	mov    %ebx,%eax
     7f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7f5:	c9                   	leave  
     7f6:	c3                   	ret    

000007f7 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     7f7:	55                   	push   %ebp
     7f8:	89 e5                	mov    %esp,%ebp
     7fa:	57                   	push   %edi
     7fb:	56                   	push   %esi
     7fc:	53                   	push   %ebx
     7fd:	83 ec 0c             	sub    $0xc,%esp
     800:	8b 75 0c             	mov    0xc(%ebp),%esi
     803:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     806:	8b 45 08             	mov    0x8(%ebp),%eax
     809:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     80b:	39 f3                	cmp    %esi,%ebx
     80d:	72 09                	jb     818 <gettoken+0x21>
     80f:	eb 23                	jmp    834 <gettoken+0x3d>
    s++;
     811:	83 c3 01             	add    $0x1,%ebx
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     814:	39 de                	cmp    %ebx,%esi
     816:	74 1a                	je     832 <gettoken+0x3b>
     818:	83 ec 08             	sub    $0x8,%esp
     81b:	0f be 03             	movsbl (%ebx),%eax
     81e:	50                   	push   %eax
     81f:	68 28 1d 00 00       	push   $0x1d28
     824:	e8 96 07 00 00       	call   fbf <strchr>
     829:	83 c4 10             	add    $0x10,%esp
     82c:	85 c0                	test   %eax,%eax
     82e:	75 e1                	jne    811 <gettoken+0x1a>
     830:	eb 02                	jmp    834 <gettoken+0x3d>
    s++;
     832:	89 f3                	mov    %esi,%ebx
  if(q)
     834:	85 ff                	test   %edi,%edi
     836:	74 02                	je     83a <gettoken+0x43>
    *q = s;
     838:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     83a:	0f b6 03             	movzbl (%ebx),%eax
     83d:	0f be f8             	movsbl %al,%edi
  switch(*s){
     840:	3c 29                	cmp    $0x29,%al
     842:	7f 12                	jg     856 <gettoken+0x5f>
     844:	3c 28                	cmp    $0x28,%al
     846:	7d 2c                	jge    874 <gettoken+0x7d>
     848:	84 c0                	test   %al,%al
     84a:	0f 84 81 00 00 00    	je     8d1 <gettoken+0xda>
     850:	3c 26                	cmp    $0x26,%al
     852:	75 17                	jne    86b <gettoken+0x74>
     854:	eb 1e                	jmp    874 <gettoken+0x7d>
     856:	3c 3e                	cmp    $0x3e,%al
     858:	74 1f                	je     879 <gettoken+0x82>
     85a:	3c 3e                	cmp    $0x3e,%al
     85c:	7f 09                	jg     867 <gettoken+0x70>
     85e:	83 e8 3b             	sub    $0x3b,%eax
     861:	3c 01                	cmp    $0x1,%al
     863:	77 06                	ja     86b <gettoken+0x74>
     865:	eb 0d                	jmp    874 <gettoken+0x7d>
     867:	3c 7c                	cmp    $0x7c,%al
     869:	74 09                	je     874 <gettoken+0x7d>
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     86b:	39 de                	cmp    %ebx,%esi
     86d:	77 26                	ja     895 <gettoken+0x9e>
     86f:	e9 95 00 00 00       	jmp    909 <gettoken+0x112>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     874:	83 c3 01             	add    $0x1,%ebx
    break;
     877:	eb 58                	jmp    8d1 <gettoken+0xda>
  case '>':
    s++;
    if(*s == '>'){
     879:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     87d:	74 05                	je     884 <gettoken+0x8d>
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
     87f:	83 c3 01             	add    $0x1,%ebx
     882:	eb 4d                	jmp    8d1 <gettoken+0xda>
    if(*s == '>'){
      ret = '+';
      s++;
     884:	83 c3 02             	add    $0x2,%ebx
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
     887:	bf 2b 00 00 00       	mov    $0x2b,%edi
     88c:	eb 43                	jmp    8d1 <gettoken+0xda>
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
     88e:	83 c3 01             	add    $0x1,%ebx
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     891:	39 de                	cmp    %ebx,%esi
     893:	74 72                	je     907 <gettoken+0x110>
     895:	83 ec 08             	sub    $0x8,%esp
     898:	0f be 03             	movsbl (%ebx),%eax
     89b:	50                   	push   %eax
     89c:	68 28 1d 00 00       	push   $0x1d28
     8a1:	e8 19 07 00 00       	call   fbf <strchr>
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	85 c0                	test   %eax,%eax
     8ab:	75 1f                	jne    8cc <gettoken+0xd5>
     8ad:	83 ec 08             	sub    $0x8,%esp
     8b0:	0f be 03             	movsbl (%ebx),%eax
     8b3:	50                   	push   %eax
     8b4:	68 20 1d 00 00       	push   $0x1d20
     8b9:	e8 01 07 00 00       	call   fbf <strchr>
     8be:	83 c4 10             	add    $0x10,%esp
     8c1:	85 c0                	test   %eax,%eax
     8c3:	74 c9                	je     88e <gettoken+0x97>
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
     8c5:	bf 61 00 00 00       	mov    $0x61,%edi
     8ca:	eb 05                	jmp    8d1 <gettoken+0xda>
     8cc:	bf 61 00 00 00       	mov    $0x61,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     8d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     8d5:	74 05                	je     8dc <gettoken+0xe5>
    *eq = s;
     8d7:	8b 45 14             	mov    0x14(%ebp),%eax
     8da:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
     8dc:	39 de                	cmp    %ebx,%esi
     8de:	77 09                	ja     8e9 <gettoken+0xf2>
     8e0:	eb 32                	jmp    914 <gettoken+0x11d>
    s++;
     8e2:	83 c3 01             	add    $0x1,%ebx
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     8e5:	39 de                	cmp    %ebx,%esi
     8e7:	74 1a                	je     903 <gettoken+0x10c>
     8e9:	83 ec 08             	sub    $0x8,%esp
     8ec:	0f be 03             	movsbl (%ebx),%eax
     8ef:	50                   	push   %eax
     8f0:	68 28 1d 00 00       	push   $0x1d28
     8f5:	e8 c5 06 00 00       	call   fbf <strchr>
     8fa:	83 c4 10             	add    $0x10,%esp
     8fd:	85 c0                	test   %eax,%eax
     8ff:	75 e1                	jne    8e2 <gettoken+0xeb>
     901:	eb 11                	jmp    914 <gettoken+0x11d>
    s++;
     903:	89 f3                	mov    %esi,%ebx
     905:	eb 0d                	jmp    914 <gettoken+0x11d>
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
     907:	89 f3                	mov    %esi,%ebx
    break;
  }
  if(eq)
     909:	bf 61 00 00 00       	mov    $0x61,%edi
     90e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     912:	75 c3                	jne    8d7 <gettoken+0xe0>
    *eq = s;

  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
     914:	8b 45 08             	mov    0x8(%ebp),%eax
     917:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     919:	89 f8                	mov    %edi,%eax
     91b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     91e:	5b                   	pop    %ebx
     91f:	5e                   	pop    %esi
     920:	5f                   	pop    %edi
     921:	5d                   	pop    %ebp
     922:	c3                   	ret    

00000923 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     923:	55                   	push   %ebp
     924:	89 e5                	mov    %esp,%ebp
     926:	57                   	push   %edi
     927:	56                   	push   %esi
     928:	53                   	push   %ebx
     929:	83 ec 0c             	sub    $0xc,%esp
     92c:	8b 7d 08             	mov    0x8(%ebp),%edi
     92f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     932:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     934:	39 f3                	cmp    %esi,%ebx
     936:	72 09                	jb     941 <peek+0x1e>
     938:	eb 23                	jmp    95d <peek+0x3a>
    s++;
     93a:	83 c3 01             	add    $0x1,%ebx
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     93d:	39 de                	cmp    %ebx,%esi
     93f:	74 1a                	je     95b <peek+0x38>
     941:	83 ec 08             	sub    $0x8,%esp
     944:	0f be 03             	movsbl (%ebx),%eax
     947:	50                   	push   %eax
     948:	68 28 1d 00 00       	push   $0x1d28
     94d:	e8 6d 06 00 00       	call   fbf <strchr>
     952:	83 c4 10             	add    $0x10,%esp
     955:	85 c0                	test   %eax,%eax
     957:	75 e1                	jne    93a <peek+0x17>
     959:	eb 02                	jmp    95d <peek+0x3a>
    s++;
     95b:	89 f3                	mov    %esi,%ebx
  *ps = s;
     95d:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     95f:	0f b6 13             	movzbl (%ebx),%edx
     962:	b8 00 00 00 00       	mov    $0x0,%eax
     967:	84 d2                	test   %dl,%dl
     969:	74 1a                	je     985 <peek+0x62>
     96b:	83 ec 08             	sub    $0x8,%esp
     96e:	0f be d2             	movsbl %dl,%edx
     971:	52                   	push   %edx
     972:	ff 75 10             	pushl  0x10(%ebp)
     975:	e8 45 06 00 00       	call   fbf <strchr>
     97a:	83 c4 10             	add    $0x10,%esp
     97d:	85 c0                	test   %eax,%eax
     97f:	0f 95 c0             	setne  %al
     982:	0f b6 c0             	movzbl %al,%eax
}
     985:	8d 65 f4             	lea    -0xc(%ebp),%esp
     988:	5b                   	pop    %ebx
     989:	5e                   	pop    %esi
     98a:	5f                   	pop    %edi
     98b:	5d                   	pop    %ebp
     98c:	c3                   	ret    

0000098d <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     98d:	55                   	push   %ebp
     98e:	89 e5                	mov    %esp,%ebp
     990:	57                   	push   %edi
     991:	56                   	push   %esi
     992:	53                   	push   %ebx
     993:	83 ec 1c             	sub    $0x1c,%esp
     996:	8b 7d 0c             	mov    0xc(%ebp),%edi
     999:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     99c:	e9 9d 00 00 00       	jmp    a3e <parseredirs+0xb1>
    tok = gettoken(ps, es, 0, 0);
     9a1:	6a 00                	push   $0x0
     9a3:	6a 00                	push   $0x0
     9a5:	56                   	push   %esi
     9a6:	57                   	push   %edi
     9a7:	e8 4b fe ff ff       	call   7f7 <gettoken>
     9ac:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     9ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
     9b1:	50                   	push   %eax
     9b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     9b5:	50                   	push   %eax
     9b6:	56                   	push   %esi
     9b7:	57                   	push   %edi
     9b8:	e8 3a fe ff ff       	call   7f7 <gettoken>
     9bd:	83 c4 20             	add    $0x20,%esp
     9c0:	83 f8 61             	cmp    $0x61,%eax
     9c3:	74 0d                	je     9d2 <parseredirs+0x45>
      panic("missing file for redirection");
     9c5:	83 ec 0c             	sub    $0xc,%esp
     9c8:	68 b1 15 00 00       	push   $0x15b1
     9cd:	e8 3b fb ff ff       	call   50d <panic>
    switch(tok){
     9d2:	83 fb 3c             	cmp    $0x3c,%ebx
     9d5:	74 0c                	je     9e3 <parseredirs+0x56>
     9d7:	83 fb 3e             	cmp    $0x3e,%ebx
     9da:	74 24                	je     a00 <parseredirs+0x73>
     9dc:	83 fb 2b             	cmp    $0x2b,%ebx
     9df:	75 5d                	jne    a3e <parseredirs+0xb1>
     9e1:	eb 3d                	jmp    a20 <parseredirs+0x93>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     9e3:	83 ec 0c             	sub    $0xc,%esp
     9e6:	6a 00                	push   $0x0
     9e8:	6a 00                	push   $0x0
     9ea:	ff 75 e0             	pushl  -0x20(%ebp)
     9ed:	ff 75 e4             	pushl  -0x1c(%ebp)
     9f0:	ff 75 08             	pushl  0x8(%ebp)
     9f3:	e8 1b fd ff ff       	call   713 <redircmd>
     9f8:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9fb:	83 c4 20             	add    $0x20,%esp
     9fe:	eb 3e                	jmp    a3e <parseredirs+0xb1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a00:	83 ec 0c             	sub    $0xc,%esp
     a03:	6a 01                	push   $0x1
     a05:	68 01 02 00 00       	push   $0x201
     a0a:	ff 75 e0             	pushl  -0x20(%ebp)
     a0d:	ff 75 e4             	pushl  -0x1c(%ebp)
     a10:	ff 75 08             	pushl  0x8(%ebp)
     a13:	e8 fb fc ff ff       	call   713 <redircmd>
     a18:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a1b:	83 c4 20             	add    $0x20,%esp
     a1e:	eb 1e                	jmp    a3e <parseredirs+0xb1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a20:	83 ec 0c             	sub    $0xc,%esp
     a23:	6a 01                	push   $0x1
     a25:	68 01 02 00 00       	push   $0x201
     a2a:	ff 75 e0             	pushl  -0x20(%ebp)
     a2d:	ff 75 e4             	pushl  -0x1c(%ebp)
     a30:	ff 75 08             	pushl  0x8(%ebp)
     a33:	e8 db fc ff ff       	call   713 <redircmd>
     a38:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a3b:	83 c4 20             	add    $0x20,%esp
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     a3e:	83 ec 04             	sub    $0x4,%esp
     a41:	68 ce 15 00 00       	push   $0x15ce
     a46:	56                   	push   %esi
     a47:	57                   	push   %edi
     a48:	e8 d6 fe ff ff       	call   923 <peek>
     a4d:	83 c4 10             	add    $0x10,%esp
     a50:	85 c0                	test   %eax,%eax
     a52:	0f 85 49 ff ff ff    	jne    9a1 <parseredirs+0x14>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}
     a58:	8b 45 08             	mov    0x8(%ebp),%eax
     a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a5e:	5b                   	pop    %ebx
     a5f:	5e                   	pop    %esi
     a60:	5f                   	pop    %edi
     a61:	5d                   	pop    %ebp
     a62:	c3                   	ret    

00000a63 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     a63:	55                   	push   %ebp
     a64:	89 e5                	mov    %esp,%ebp
     a66:	57                   	push   %edi
     a67:	56                   	push   %esi
     a68:	53                   	push   %ebx
     a69:	83 ec 30             	sub    $0x30,%esp
     a6c:	8b 75 08             	mov    0x8(%ebp),%esi
     a6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     a72:	68 d1 15 00 00       	push   $0x15d1
     a77:	57                   	push   %edi
     a78:	56                   	push   %esi
     a79:	e8 a5 fe ff ff       	call   923 <peek>
     a7e:	83 c4 10             	add    $0x10,%esp
     a81:	85 c0                	test   %eax,%eax
     a83:	74 12                	je     a97 <parseexec+0x34>
    return parseblock(ps, es);
     a85:	83 ec 08             	sub    $0x8,%esp
     a88:	57                   	push   %edi
     a89:	56                   	push   %esi
     a8a:	e8 b4 01 00 00       	call   c43 <parseblock>
     a8f:	83 c4 10             	add    $0x10,%esp
     a92:	e9 b9 00 00 00       	jmp    b50 <parseexec+0xed>

  ret = execcmd();
     a97:	e8 4d fc ff ff       	call   6e9 <execcmd>
     a9c:	89 c3                	mov    %eax,%ebx
     a9e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     aa1:	83 ec 04             	sub    $0x4,%esp
     aa4:	57                   	push   %edi
     aa5:	56                   	push   %esi
     aa6:	50                   	push   %eax
     aa7:	e8 e1 fe ff ff       	call   98d <parseredirs>
     aac:	89 45 d0             	mov    %eax,-0x30(%ebp)
     aaf:	8d 5b 04             	lea    0x4(%ebx),%ebx
  while(!peek(ps, es, "|)&;")){
     ab2:	83 c4 10             	add    $0x10,%esp
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
     ab5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     abc:	eb 62                	jmp    b20 <parseexec+0xbd>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     abe:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ac1:	50                   	push   %eax
     ac2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     ac5:	50                   	push   %eax
     ac6:	57                   	push   %edi
     ac7:	56                   	push   %esi
     ac8:	e8 2a fd ff ff       	call   7f7 <gettoken>
     acd:	83 c4 10             	add    $0x10,%esp
     ad0:	85 c0                	test   %eax,%eax
     ad2:	74 62                	je     b36 <parseexec+0xd3>
      break;
    if(tok != 'a')
     ad4:	83 f8 61             	cmp    $0x61,%eax
     ad7:	74 0d                	je     ae6 <parseexec+0x83>
      panic("syntax");
     ad9:	83 ec 0c             	sub    $0xc,%esp
     adc:	68 d3 15 00 00       	push   $0x15d3
     ae1:	e8 27 fa ff ff       	call   50d <panic>
    cmd->argv[argc] = q;
     ae6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ae9:	89 03                	mov    %eax,(%ebx)
    cmd->eargv[argc] = eq;
     aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     aee:	89 43 28             	mov    %eax,0x28(%ebx)
    argc++;
     af1:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
     af5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     af8:	83 c3 04             	add    $0x4,%ebx
    if(argc >= MAXARGS)
     afb:	83 f8 0a             	cmp    $0xa,%eax
     afe:	75 0d                	jne    b0d <parseexec+0xaa>
      panic("too many args");
     b00:	83 ec 0c             	sub    $0xc,%esp
     b03:	68 da 15 00 00       	push   $0x15da
     b08:	e8 00 fa ff ff       	call   50d <panic>
    ret = parseredirs(ret, ps, es);
     b0d:	83 ec 04             	sub    $0x4,%esp
     b10:	57                   	push   %edi
     b11:	56                   	push   %esi
     b12:	ff 75 d0             	pushl  -0x30(%ebp)
     b15:	e8 73 fe ff ff       	call   98d <parseredirs>
     b1a:	89 45 d0             	mov    %eax,-0x30(%ebp)
     b1d:	83 c4 10             	add    $0x10,%esp
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     b20:	83 ec 04             	sub    $0x4,%esp
     b23:	68 e8 15 00 00       	push   $0x15e8
     b28:	57                   	push   %edi
     b29:	56                   	push   %esi
     b2a:	e8 f4 fd ff ff       	call   923 <peek>
     b2f:	83 c4 10             	add    $0x10,%esp
     b32:	85 c0                	test   %eax,%eax
     b34:	74 88                	je     abe <parseexec+0x5b>
     b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
     b39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     b3c:	8d 04 90             	lea    (%eax,%edx,4),%eax
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     b3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     b46:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
     b4d:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
     b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b53:	5b                   	pop    %ebx
     b54:	5e                   	pop    %esi
     b55:	5f                   	pop    %edi
     b56:	5d                   	pop    %ebp
     b57:	c3                   	ret    

00000b58 <parsepipe>:
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
     b58:	55                   	push   %ebp
     b59:	89 e5                	mov    %esp,%ebp
     b5b:	57                   	push   %edi
     b5c:	56                   	push   %esi
     b5d:	53                   	push   %ebx
     b5e:	83 ec 14             	sub    $0x14,%esp
     b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b64:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     b67:	56                   	push   %esi
     b68:	53                   	push   %ebx
     b69:	e8 f5 fe ff ff       	call   a63 <parseexec>
     b6e:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     b70:	83 c4 0c             	add    $0xc,%esp
     b73:	68 ed 15 00 00       	push   $0x15ed
     b78:	56                   	push   %esi
     b79:	53                   	push   %ebx
     b7a:	e8 a4 fd ff ff       	call   923 <peek>
     b7f:	83 c4 10             	add    $0x10,%esp
     b82:	85 c0                	test   %eax,%eax
     b84:	74 24                	je     baa <parsepipe+0x52>
    gettoken(ps, es, 0, 0);
     b86:	6a 00                	push   $0x0
     b88:	6a 00                	push   $0x0
     b8a:	56                   	push   %esi
     b8b:	53                   	push   %ebx
     b8c:	e8 66 fc ff ff       	call   7f7 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b91:	83 c4 08             	add    $0x8,%esp
     b94:	56                   	push   %esi
     b95:	53                   	push   %ebx
     b96:	e8 bd ff ff ff       	call   b58 <parsepipe>
     b9b:	83 c4 08             	add    $0x8,%esp
     b9e:	50                   	push   %eax
     b9f:	57                   	push   %edi
     ba0:	e8 b6 fb ff ff       	call   75b <pipecmd>
     ba5:	89 c7                	mov    %eax,%edi
     ba7:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     baa:	89 f8                	mov    %edi,%eax
     bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
     baf:	5b                   	pop    %ebx
     bb0:	5e                   	pop    %esi
     bb1:	5f                   	pop    %edi
     bb2:	5d                   	pop    %ebp
     bb3:	c3                   	ret    

00000bb4 <parseline>:
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
     bb4:	55                   	push   %ebp
     bb5:	89 e5                	mov    %esp,%ebp
     bb7:	57                   	push   %edi
     bb8:	56                   	push   %esi
     bb9:	53                   	push   %ebx
     bba:	83 ec 14             	sub    $0x14,%esp
     bbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
     bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     bc3:	56                   	push   %esi
     bc4:	53                   	push   %ebx
     bc5:	e8 8e ff ff ff       	call   b58 <parsepipe>
     bca:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     bcc:	83 c4 10             	add    $0x10,%esp
     bcf:	eb 18                	jmp    be9 <parseline+0x35>
    gettoken(ps, es, 0, 0);
     bd1:	6a 00                	push   $0x0
     bd3:	6a 00                	push   $0x0
     bd5:	56                   	push   %esi
     bd6:	53                   	push   %ebx
     bd7:	e8 1b fc ff ff       	call   7f7 <gettoken>
    cmd = backcmd(cmd);
     bdc:	89 3c 24             	mov    %edi,(%esp)
     bdf:	e8 e3 fb ff ff       	call   7c7 <backcmd>
     be4:	89 c7                	mov    %eax,%edi
     be6:	83 c4 10             	add    $0x10,%esp
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     be9:	83 ec 04             	sub    $0x4,%esp
     bec:	68 ef 15 00 00       	push   $0x15ef
     bf1:	56                   	push   %esi
     bf2:	53                   	push   %ebx
     bf3:	e8 2b fd ff ff       	call   923 <peek>
     bf8:	83 c4 10             	add    $0x10,%esp
     bfb:	85 c0                	test   %eax,%eax
     bfd:	75 d2                	jne    bd1 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     bff:	83 ec 04             	sub    $0x4,%esp
     c02:	68 eb 15 00 00       	push   $0x15eb
     c07:	56                   	push   %esi
     c08:	53                   	push   %ebx
     c09:	e8 15 fd ff ff       	call   923 <peek>
     c0e:	83 c4 10             	add    $0x10,%esp
     c11:	85 c0                	test   %eax,%eax
     c13:	74 24                	je     c39 <parseline+0x85>
    gettoken(ps, es, 0, 0);
     c15:	6a 00                	push   $0x0
     c17:	6a 00                	push   $0x0
     c19:	56                   	push   %esi
     c1a:	53                   	push   %ebx
     c1b:	e8 d7 fb ff ff       	call   7f7 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     c20:	83 c4 08             	add    $0x8,%esp
     c23:	56                   	push   %esi
     c24:	53                   	push   %ebx
     c25:	e8 8a ff ff ff       	call   bb4 <parseline>
     c2a:	83 c4 08             	add    $0x8,%esp
     c2d:	50                   	push   %eax
     c2e:	57                   	push   %edi
     c2f:	e8 5d fb ff ff       	call   791 <listcmd>
     c34:	89 c7                	mov    %eax,%edi
     c36:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
}
     c39:	89 f8                	mov    %edi,%eax
     c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c3e:	5b                   	pop    %ebx
     c3f:	5e                   	pop    %esi
     c40:	5f                   	pop    %edi
     c41:	5d                   	pop    %ebp
     c42:	c3                   	ret    

00000c43 <parseblock>:
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
     c43:	55                   	push   %ebp
     c44:	89 e5                	mov    %esp,%ebp
     c46:	57                   	push   %edi
     c47:	56                   	push   %esi
     c48:	53                   	push   %ebx
     c49:	83 ec 10             	sub    $0x10,%esp
     c4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     c4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     c52:	68 d1 15 00 00       	push   $0x15d1
     c57:	56                   	push   %esi
     c58:	53                   	push   %ebx
     c59:	e8 c5 fc ff ff       	call   923 <peek>
     c5e:	83 c4 10             	add    $0x10,%esp
     c61:	85 c0                	test   %eax,%eax
     c63:	75 0d                	jne    c72 <parseblock+0x2f>
    panic("parseblock");
     c65:	83 ec 0c             	sub    $0xc,%esp
     c68:	68 f1 15 00 00       	push   $0x15f1
     c6d:	e8 9b f8 ff ff       	call   50d <panic>
  gettoken(ps, es, 0, 0);
     c72:	6a 00                	push   $0x0
     c74:	6a 00                	push   $0x0
     c76:	56                   	push   %esi
     c77:	53                   	push   %ebx
     c78:	e8 7a fb ff ff       	call   7f7 <gettoken>
  cmd = parseline(ps, es);
     c7d:	83 c4 08             	add    $0x8,%esp
     c80:	56                   	push   %esi
     c81:	53                   	push   %ebx
     c82:	e8 2d ff ff ff       	call   bb4 <parseline>
     c87:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     c89:	83 c4 0c             	add    $0xc,%esp
     c8c:	68 0d 16 00 00       	push   $0x160d
     c91:	56                   	push   %esi
     c92:	53                   	push   %ebx
     c93:	e8 8b fc ff ff       	call   923 <peek>
     c98:	83 c4 10             	add    $0x10,%esp
     c9b:	85 c0                	test   %eax,%eax
     c9d:	75 0d                	jne    cac <parseblock+0x69>
    panic("syntax - missing )");
     c9f:	83 ec 0c             	sub    $0xc,%esp
     ca2:	68 fc 15 00 00       	push   $0x15fc
     ca7:	e8 61 f8 ff ff       	call   50d <panic>
  gettoken(ps, es, 0, 0);
     cac:	6a 00                	push   $0x0
     cae:	6a 00                	push   $0x0
     cb0:	56                   	push   %esi
     cb1:	53                   	push   %ebx
     cb2:	e8 40 fb ff ff       	call   7f7 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     cb7:	83 c4 0c             	add    $0xc,%esp
     cba:	56                   	push   %esi
     cbb:	53                   	push   %ebx
     cbc:	57                   	push   %edi
     cbd:	e8 cb fc ff ff       	call   98d <parseredirs>
  return cmd;
}
     cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cc5:	5b                   	pop    %ebx
     cc6:	5e                   	pop    %esi
     cc7:	5f                   	pop    %edi
     cc8:	5d                   	pop    %ebp
     cc9:	c3                   	ret    

00000cca <nulterminate>:
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     cca:	55                   	push   %ebp
     ccb:	89 e5                	mov    %esp,%ebp
     ccd:	53                   	push   %ebx
     cce:	83 ec 04             	sub    $0x4,%esp
     cd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     cd4:	85 db                	test   %ebx,%ebx
     cd6:	0f 84 95 00 00 00    	je     d71 <nulterminate+0xa7>
    return 0;

  switch(cmd->type){
     cdc:	83 3b 05             	cmpl   $0x5,(%ebx)
     cdf:	0f 87 93 00 00 00    	ja     d78 <nulterminate+0xae>
     ce5:	8b 03                	mov    (%ebx),%eax
     ce7:	ff 24 85 4c 16 00 00 	jmp    *0x164c(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     cee:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
     cf2:	0f 84 84 00 00 00    	je     d7c <nulterminate+0xb2>
     cf8:	8d 43 2c             	lea    0x2c(%ebx),%eax
      *ecmd->eargv[i] = 0;
     cfb:	8b 10                	mov    (%eax),%edx
     cfd:	c6 02 00             	movb   $0x0,(%edx)
     d00:	83 c0 04             	add    $0x4,%eax
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     d03:	83 78 d8 00          	cmpl   $0x0,-0x28(%eax)
     d07:	75 f2                	jne    cfb <nulterminate+0x31>
  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
     d09:	89 d8                	mov    %ebx,%eax
     d0b:	eb 71                	jmp    d7e <nulterminate+0xb4>
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     d0d:	83 ec 0c             	sub    $0xc,%esp
     d10:	ff 73 04             	pushl  0x4(%ebx)
     d13:	e8 b2 ff ff ff       	call   cca <nulterminate>
    *rcmd->efile = 0;
     d18:	8b 43 0c             	mov    0xc(%ebx),%eax
     d1b:	c6 00 00             	movb   $0x0,(%eax)
    break;
     d1e:	83 c4 10             	add    $0x10,%esp
  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
     d21:	89 d8                	mov    %ebx,%eax

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;
     d23:	eb 59                	jmp    d7e <nulterminate+0xb4>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    nulterminate(pcmd->left);
     d25:	83 ec 0c             	sub    $0xc,%esp
     d28:	ff 73 04             	pushl  0x4(%ebx)
     d2b:	e8 9a ff ff ff       	call   cca <nulterminate>
    nulterminate(pcmd->right);
     d30:	83 c4 04             	add    $0x4,%esp
     d33:	ff 73 08             	pushl  0x8(%ebx)
     d36:	e8 8f ff ff ff       	call   cca <nulterminate>
    break;
     d3b:	83 c4 10             	add    $0x10,%esp
  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
     d3e:	89 d8                	mov    %ebx,%eax

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    nulterminate(pcmd->left);
    nulterminate(pcmd->right);
    break;
     d40:	eb 3c                	jmp    d7e <nulterminate+0xb4>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     d42:	83 ec 0c             	sub    $0xc,%esp
     d45:	ff 73 04             	pushl  0x4(%ebx)
     d48:	e8 7d ff ff ff       	call   cca <nulterminate>
    nulterminate(lcmd->right);
     d4d:	83 c4 04             	add    $0x4,%esp
     d50:	ff 73 08             	pushl  0x8(%ebx)
     d53:	e8 72 ff ff ff       	call   cca <nulterminate>
    break;
     d58:	83 c4 10             	add    $0x10,%esp
  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
     d5b:	89 d8                	mov    %ebx,%eax

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    nulterminate(lcmd->right);
    break;
     d5d:	eb 1f                	jmp    d7e <nulterminate+0xb4>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
     d5f:	83 ec 0c             	sub    $0xc,%esp
     d62:	ff 73 04             	pushl  0x4(%ebx)
     d65:	e8 60 ff ff ff       	call   cca <nulterminate>
    break;
     d6a:	83 c4 10             	add    $0x10,%esp
  }
  return cmd;
     d6d:	89 d8                	mov    %ebx,%eax
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
     d6f:	eb 0d                	jmp    d7e <nulterminate+0xb4>
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;
     d71:	b8 00 00 00 00       	mov    $0x0,%eax
     d76:	eb 06                	jmp    d7e <nulterminate+0xb4>
  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
     d78:	89 d8                	mov    %ebx,%eax
     d7a:	eb 02                	jmp    d7e <nulterminate+0xb4>
     d7c:	89 d8                	mov    %ebx,%eax
}
     d7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d81:	c9                   	leave  
     d82:	c3                   	ret    

00000d83 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     d83:	55                   	push   %ebp
     d84:	89 e5                	mov    %esp,%ebp
     d86:	56                   	push   %esi
     d87:	53                   	push   %ebx
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     d88:	8b 5d 08             	mov    0x8(%ebp),%ebx
     d8b:	83 ec 0c             	sub    $0xc,%esp
     d8e:	53                   	push   %ebx
     d8f:	e8 f0 01 00 00       	call   f84 <strlen>
     d94:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     d96:	83 c4 08             	add    $0x8,%esp
     d99:	53                   	push   %ebx
     d9a:	8d 45 08             	lea    0x8(%ebp),%eax
     d9d:	50                   	push   %eax
     d9e:	e8 11 fe ff ff       	call   bb4 <parseline>
     da3:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     da5:	83 c4 0c             	add    $0xc,%esp
     da8:	68 9b 15 00 00       	push   $0x159b
     dad:	53                   	push   %ebx
     dae:	8d 45 08             	lea    0x8(%ebp),%eax
     db1:	50                   	push   %eax
     db2:	e8 6c fb ff ff       	call   923 <peek>
  if(s != es){
     db7:	8b 45 08             	mov    0x8(%ebp),%eax
     dba:	83 c4 10             	add    $0x10,%esp
     dbd:	39 c3                	cmp    %eax,%ebx
     dbf:	74 1c                	je     ddd <parsecmd+0x5a>
    printf(2, "leftovers: %s\n", s);
     dc1:	83 ec 04             	sub    $0x4,%esp
     dc4:	50                   	push   %eax
     dc5:	68 0f 16 00 00       	push   $0x160f
     dca:	6a 02                	push   $0x2
     dcc:	e8 83 04 00 00       	call   1254 <printf>
    panic("syntax");
     dd1:	c7 04 24 d3 15 00 00 	movl   $0x15d3,(%esp)
     dd8:	e8 30 f7 ff ff       	call   50d <panic>
  }
  nulterminate(cmd);
     ddd:	83 ec 0c             	sub    $0xc,%esp
     de0:	56                   	push   %esi
     de1:	e8 e4 fe ff ff       	call   cca <nulterminate>
  return cmd;
}
     de6:	89 f0                	mov    %esi,%eax
     de8:	8d 65 f8             	lea    -0x8(%ebp),%esp
     deb:	5b                   	pop    %ebx
     dec:	5e                   	pop    %esi
     ded:	5d                   	pop    %ebp
     dee:	c3                   	ret    

00000def <main>:
  return 0;
}

int
main(void)
{
     def:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     df3:	83 e4 f0             	and    $0xfffffff0,%esp
     df6:	ff 71 fc             	pushl  -0x4(%ecx)
     df9:	55                   	push   %ebp
     dfa:	89 e5                	mov    %esp,%ebp
     dfc:	51                   	push   %ecx
     dfd:	83 ec 04             	sub    $0x4,%esp
  static char buf[MAXLEN];
  int fd;
  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     e00:	eb 16                	jmp    e18 <main+0x29>
    if(fd >= 3){
     e02:	83 f8 02             	cmp    $0x2,%eax
     e05:	7e 11                	jle    e18 <main+0x29>
      close(fd);
     e07:	83 ec 0c             	sub    $0xc,%esp
     e0a:	50                   	push   %eax
     e0b:	e8 11 03 00 00       	call   1121 <close>
      break;
     e10:	83 c4 10             	add    $0x10,%esp
     e13:	e9 fb 00 00 00       	jmp    f13 <main+0x124>
main(void)
{
  static char buf[MAXLEN];
  int fd;
  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     e18:	83 ec 08             	sub    $0x8,%esp
     e1b:	6a 02                	push   $0x2
     e1d:	68 1e 16 00 00       	push   $0x161e
     e22:	e8 12 03 00 00       	call   1139 <open>
     e27:	83 c4 10             	add    $0x10,%esp
     e2a:	85 c0                	test   %eax,%eax
     e2c:	79 d4                	jns    e02 <main+0x13>
     e2e:	e9 e0 00 00 00       	jmp    f13 <main+0x124>

  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    //add the input to the history
    addCommand(buf);
     e33:	83 ec 0c             	sub    $0xc,%esp
     e36:	68 80 1d 00 00       	push   $0x1d80
     e3b:	e8 25 f6 ff ff       	call   465 <addCommand>
    if(isPrintHistory(buf)){
     e40:	c7 04 24 80 1d 00 00 	movl   $0x1d80,(%esp)
     e47:	e8 75 f2 ff ff       	call   c1 <isPrintHistory>
     e4c:	83 c4 10             	add    $0x10,%esp
     e4f:	85 c0                	test   %eax,%eax
     e51:	74 0a                	je     e5d <main+0x6e>
        printHistory();
     e53:	e8 1b f2 ff ff       	call   73 <printHistory>
        //buf[0]=0;
        continue;        
     e58:	e9 b6 00 00 00       	jmp    f13 <main+0x124>
    }
    swapAllVariables(buf);
     e5d:	83 ec 0c             	sub    $0xc,%esp
     e60:	68 80 1d 00 00       	push   $0x1d80
     e65:	e8 76 f5 ff ff       	call   3e0 <swapAllVariables>
    handleRunFromHistory(buf);
     e6a:	c7 04 24 80 1d 00 00 	movl   $0x1d80,(%esp)
     e71:	e8 95 f2 ff ff       	call   10b <handleRunFromHistory>
    swapAllVariables(buf);
     e76:	c7 04 24 80 1d 00 00 	movl   $0x1d80,(%esp)
     e7d:	e8 5e f5 ff ff       	call   3e0 <swapAllVariables>
    
    
    int variableAssign=handleVariableCommand(buf);
     e82:	c7 04 24 80 1d 00 00 	movl   $0x1d80,(%esp)
     e89:	e8 9f f5 ff ff       	call   42d <handleVariableCommand>
    if(variableAssign==0)
     e8e:	83 c4 10             	add    $0x10,%esp
     e91:	85 c0                	test   %eax,%eax
     e93:	74 7e                	je     f13 <main+0x124>
        continue;
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     e95:	80 3d 80 1d 00 00 63 	cmpb   $0x63,0x1d80
     e9c:	75 52                	jne    ef0 <main+0x101>
     e9e:	80 3d 81 1d 00 00 64 	cmpb   $0x64,0x1d81
     ea5:	75 49                	jne    ef0 <main+0x101>
     ea7:	80 3d 82 1d 00 00 20 	cmpb   $0x20,0x1d82
     eae:	75 40                	jne    ef0 <main+0x101>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     eb0:	83 ec 0c             	sub    $0xc,%esp
     eb3:	68 80 1d 00 00       	push   $0x1d80
     eb8:	e8 c7 00 00 00       	call   f84 <strlen>
     ebd:	c6 80 7f 1d 00 00 00 	movb   $0x0,0x1d7f(%eax)
      if(chdir(buf+3) < 0)
     ec4:	c7 04 24 83 1d 00 00 	movl   $0x1d83,(%esp)
     ecb:	e8 99 02 00 00       	call   1169 <chdir>
     ed0:	83 c4 10             	add    $0x10,%esp
     ed3:	85 c0                	test   %eax,%eax
     ed5:	79 3c                	jns    f13 <main+0x124>
        printf(2, "cannot cd %s\n", buf+3);
     ed7:	83 ec 04             	sub    $0x4,%esp
     eda:	68 83 1d 00 00       	push   $0x1d83
     edf:	68 26 16 00 00       	push   $0x1626
     ee4:	6a 02                	push   $0x2
     ee6:	e8 69 03 00 00       	call   1254 <printf>
     eeb:	83 c4 10             	add    $0x10,%esp
     eee:	eb 23                	jmp    f13 <main+0x124>
      continue;
    }
    if(fork1() == 0) {
     ef0:	e8 32 f6 ff ff       	call   527 <fork1>
     ef5:	85 c0                	test   %eax,%eax
     ef7:	75 15                	jne    f0e <main+0x11f>
        runcmd(parsecmd(buf));
     ef9:	83 ec 0c             	sub    $0xc,%esp
     efc:	68 80 1d 00 00       	push   $0x1d80
     f01:	e8 7d fe ff ff       	call   d83 <parsecmd>
     f06:	89 04 24             	mov    %eax,(%esp)
     f09:	e8 38 f6 ff ff       	call   546 <runcmd>

    }
    wait();
     f0e:	e8 ee 01 00 00       	call   1101 <wait>
    }
  }

  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     f13:	83 ec 08             	sub    $0x8,%esp
     f16:	68 80 00 00 00       	push   $0x80
     f1b:	68 80 1d 00 00       	push   $0x1d80
     f20:	e8 a3 f5 ff ff       	call   4c8 <getcmd>
     f25:	83 c4 10             	add    $0x10,%esp
     f28:	85 c0                	test   %eax,%eax
     f2a:	0f 89 03 ff ff ff    	jns    e33 <main+0x44>
        runcmd(parsecmd(buf));

    }
    wait();
  }
  exit();
     f30:	e8 c4 01 00 00       	call   10f9 <exit>

00000f35 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     f35:	55                   	push   %ebp
     f36:	89 e5                	mov    %esp,%ebp
     f38:	53                   	push   %ebx
     f39:	8b 45 08             	mov    0x8(%ebp),%eax
     f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f3f:	89 c2                	mov    %eax,%edx
     f41:	83 c2 01             	add    $0x1,%edx
     f44:	83 c1 01             	add    $0x1,%ecx
     f47:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     f4b:	88 5a ff             	mov    %bl,-0x1(%edx)
     f4e:	84 db                	test   %bl,%bl
     f50:	75 ef                	jne    f41 <strcpy+0xc>
    ;
  return os;
}
     f52:	5b                   	pop    %ebx
     f53:	5d                   	pop    %ebp
     f54:	c3                   	ret    

00000f55 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f55:	55                   	push   %ebp
     f56:	89 e5                	mov    %esp,%ebp
     f58:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     f5e:	0f b6 01             	movzbl (%ecx),%eax
     f61:	84 c0                	test   %al,%al
     f63:	74 15                	je     f7a <strcmp+0x25>
     f65:	3a 02                	cmp    (%edx),%al
     f67:	75 11                	jne    f7a <strcmp+0x25>
    p++, q++;
     f69:	83 c1 01             	add    $0x1,%ecx
     f6c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     f6f:	0f b6 01             	movzbl (%ecx),%eax
     f72:	84 c0                	test   %al,%al
     f74:	74 04                	je     f7a <strcmp+0x25>
     f76:	3a 02                	cmp    (%edx),%al
     f78:	74 ef                	je     f69 <strcmp+0x14>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     f7a:	0f b6 c0             	movzbl %al,%eax
     f7d:	0f b6 12             	movzbl (%edx),%edx
     f80:	29 d0                	sub    %edx,%eax
}
     f82:	5d                   	pop    %ebp
     f83:	c3                   	ret    

00000f84 <strlen>:

uint
strlen(char *s)
{
     f84:	55                   	push   %ebp
     f85:	89 e5                	mov    %esp,%ebp
     f87:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     f8a:	80 39 00             	cmpb   $0x0,(%ecx)
     f8d:	74 12                	je     fa1 <strlen+0x1d>
     f8f:	ba 00 00 00 00       	mov    $0x0,%edx
     f94:	83 c2 01             	add    $0x1,%edx
     f97:	89 d0                	mov    %edx,%eax
     f99:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     f9d:	75 f5                	jne    f94 <strlen+0x10>
     f9f:	eb 05                	jmp    fa6 <strlen+0x22>
     fa1:	b8 00 00 00 00       	mov    $0x0,%eax
    ;
  return n;
}
     fa6:	5d                   	pop    %ebp
     fa7:	c3                   	ret    

00000fa8 <memset>:

void*
memset(void *dst, int c, uint n)
{
     fa8:	55                   	push   %ebp
     fa9:	89 e5                	mov    %esp,%ebp
     fab:	57                   	push   %edi
     fac:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     faf:	89 d7                	mov    %edx,%edi
     fb1:	8b 4d 10             	mov    0x10(%ebp),%ecx
     fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
     fb7:	fc                   	cld    
     fb8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     fba:	89 d0                	mov    %edx,%eax
     fbc:	5f                   	pop    %edi
     fbd:	5d                   	pop    %ebp
     fbe:	c3                   	ret    

00000fbf <strchr>:

char*
strchr(const char *s, char c)
{
     fbf:	55                   	push   %ebp
     fc0:	89 e5                	mov    %esp,%ebp
     fc2:	53                   	push   %ebx
     fc3:	8b 45 08             	mov    0x8(%ebp),%eax
     fc6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     fc9:	0f b6 10             	movzbl (%eax),%edx
     fcc:	84 d2                	test   %dl,%dl
     fce:	74 1d                	je     fed <strchr+0x2e>
     fd0:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
     fd2:	38 d3                	cmp    %dl,%bl
     fd4:	75 06                	jne    fdc <strchr+0x1d>
     fd6:	eb 1a                	jmp    ff2 <strchr+0x33>
     fd8:	38 ca                	cmp    %cl,%dl
     fda:	74 16                	je     ff2 <strchr+0x33>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     fdc:	83 c0 01             	add    $0x1,%eax
     fdf:	0f b6 10             	movzbl (%eax),%edx
     fe2:	84 d2                	test   %dl,%dl
     fe4:	75 f2                	jne    fd8 <strchr+0x19>
    if(*s == c)
      return (char*)s;
  return 0;
     fe6:	b8 00 00 00 00       	mov    $0x0,%eax
     feb:	eb 05                	jmp    ff2 <strchr+0x33>
     fed:	b8 00 00 00 00       	mov    $0x0,%eax
}
     ff2:	5b                   	pop    %ebx
     ff3:	5d                   	pop    %ebp
     ff4:	c3                   	ret    

00000ff5 <gets>:

char*
gets(char *buf, int max)
{
     ff5:	55                   	push   %ebp
     ff6:	89 e5                	mov    %esp,%ebp
     ff8:	57                   	push   %edi
     ff9:	56                   	push   %esi
     ffa:	53                   	push   %ebx
     ffb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ffe:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
    1003:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1006:	eb 29                	jmp    1031 <gets+0x3c>
    cc = read(0, &c, 1);
    1008:	83 ec 04             	sub    $0x4,%esp
    100b:	6a 01                	push   $0x1
    100d:	57                   	push   %edi
    100e:	6a 00                	push   $0x0
    1010:	e8 fc 00 00 00       	call   1111 <read>
    if(cc < 1)
    1015:	83 c4 10             	add    $0x10,%esp
    1018:	85 c0                	test   %eax,%eax
    101a:	7e 21                	jle    103d <gets+0x48>
      break;
    buf[i++] = c;
    101c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1020:	8b 55 08             	mov    0x8(%ebp),%edx
    1023:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1027:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1029:	3c 0a                	cmp    $0xa,%al
    102b:	74 0e                	je     103b <gets+0x46>
    102d:	3c 0d                	cmp    $0xd,%al
    102f:	74 0a                	je     103b <gets+0x46>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1031:	8d 5e 01             	lea    0x1(%esi),%ebx
    1034:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1037:	7c cf                	jl     1008 <gets+0x13>
    1039:	eb 02                	jmp    103d <gets+0x48>
    103b:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    103d:	8b 45 08             	mov    0x8(%ebp),%eax
    1040:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    1044:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1047:	5b                   	pop    %ebx
    1048:	5e                   	pop    %esi
    1049:	5f                   	pop    %edi
    104a:	5d                   	pop    %ebp
    104b:	c3                   	ret    

0000104c <stat>:

int
stat(char *n, struct stat *st)
{
    104c:	55                   	push   %ebp
    104d:	89 e5                	mov    %esp,%ebp
    104f:	56                   	push   %esi
    1050:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1051:	83 ec 08             	sub    $0x8,%esp
    1054:	6a 00                	push   $0x0
    1056:	ff 75 08             	pushl  0x8(%ebp)
    1059:	e8 db 00 00 00       	call   1139 <open>
  if(fd < 0)
    105e:	83 c4 10             	add    $0x10,%esp
    1061:	85 c0                	test   %eax,%eax
    1063:	78 1f                	js     1084 <stat+0x38>
    1065:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1067:	83 ec 08             	sub    $0x8,%esp
    106a:	ff 75 0c             	pushl  0xc(%ebp)
    106d:	50                   	push   %eax
    106e:	e8 de 00 00 00       	call   1151 <fstat>
    1073:	89 c6                	mov    %eax,%esi
  close(fd);
    1075:	89 1c 24             	mov    %ebx,(%esp)
    1078:	e8 a4 00 00 00       	call   1121 <close>
  return r;
    107d:	83 c4 10             	add    $0x10,%esp
    1080:	89 f0                	mov    %esi,%eax
    1082:	eb 05                	jmp    1089 <stat+0x3d>
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    1084:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  r = fstat(fd, st);
  close(fd);
  return r;
}
    1089:	8d 65 f8             	lea    -0x8(%ebp),%esp
    108c:	5b                   	pop    %ebx
    108d:	5e                   	pop    %esi
    108e:	5d                   	pop    %ebp
    108f:	c3                   	ret    

00001090 <atoi>:

int
atoi(const char *s)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	53                   	push   %ebx
    1094:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1097:	0f b6 11             	movzbl (%ecx),%edx
    109a:	8d 42 d0             	lea    -0x30(%edx),%eax
    109d:	3c 09                	cmp    $0x9,%al
    109f:	77 1f                	ja     10c0 <atoi+0x30>
    10a1:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
    10a6:	83 c1 01             	add    $0x1,%ecx
    10a9:	8d 04 80             	lea    (%eax,%eax,4),%eax
    10ac:	0f be d2             	movsbl %dl,%edx
    10af:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    10b3:	0f b6 11             	movzbl (%ecx),%edx
    10b6:	8d 5a d0             	lea    -0x30(%edx),%ebx
    10b9:	80 fb 09             	cmp    $0x9,%bl
    10bc:	76 e8                	jbe    10a6 <atoi+0x16>
    10be:	eb 05                	jmp    10c5 <atoi+0x35>
int
atoi(const char *s)
{
  int n;

  n = 0;
    10c0:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}
    10c5:	5b                   	pop    %ebx
    10c6:	5d                   	pop    %ebp
    10c7:	c3                   	ret    

000010c8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    10c8:	55                   	push   %ebp
    10c9:	89 e5                	mov    %esp,%ebp
    10cb:	56                   	push   %esi
    10cc:	53                   	push   %ebx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	8b 75 0c             	mov    0xc(%ebp),%esi
    10d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    10d6:	85 db                	test   %ebx,%ebx
    10d8:	7e 13                	jle    10ed <memmove+0x25>
    10da:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
    10df:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    10e3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    10e6:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    10e9:	39 da                	cmp    %ebx,%edx
    10eb:	75 f2                	jne    10df <memmove+0x17>
    *dst++ = *src++;
  return vdst;
}
    10ed:	5b                   	pop    %ebx
    10ee:	5e                   	pop    %esi
    10ef:	5d                   	pop    %ebp
    10f0:	c3                   	ret    

000010f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    10f1:	b8 01 00 00 00       	mov    $0x1,%eax
    10f6:	cd 40                	int    $0x40
    10f8:	c3                   	ret    

000010f9 <exit>:
SYSCALL(exit)
    10f9:	b8 02 00 00 00       	mov    $0x2,%eax
    10fe:	cd 40                	int    $0x40
    1100:	c3                   	ret    

00001101 <wait>:
SYSCALL(wait)
    1101:	b8 03 00 00 00       	mov    $0x3,%eax
    1106:	cd 40                	int    $0x40
    1108:	c3                   	ret    

00001109 <pipe>:
SYSCALL(pipe)
    1109:	b8 04 00 00 00       	mov    $0x4,%eax
    110e:	cd 40                	int    $0x40
    1110:	c3                   	ret    

00001111 <read>:
SYSCALL(read)
    1111:	b8 05 00 00 00       	mov    $0x5,%eax
    1116:	cd 40                	int    $0x40
    1118:	c3                   	ret    

00001119 <write>:
SYSCALL(write)
    1119:	b8 10 00 00 00       	mov    $0x10,%eax
    111e:	cd 40                	int    $0x40
    1120:	c3                   	ret    

00001121 <close>:
SYSCALL(close)
    1121:	b8 15 00 00 00       	mov    $0x15,%eax
    1126:	cd 40                	int    $0x40
    1128:	c3                   	ret    

00001129 <kill>:
SYSCALL(kill)
    1129:	b8 06 00 00 00       	mov    $0x6,%eax
    112e:	cd 40                	int    $0x40
    1130:	c3                   	ret    

00001131 <exec>:
SYSCALL(exec)
    1131:	b8 07 00 00 00       	mov    $0x7,%eax
    1136:	cd 40                	int    $0x40
    1138:	c3                   	ret    

00001139 <open>:
SYSCALL(open)
    1139:	b8 0f 00 00 00       	mov    $0xf,%eax
    113e:	cd 40                	int    $0x40
    1140:	c3                   	ret    

00001141 <mknod>:
SYSCALL(mknod)
    1141:	b8 11 00 00 00       	mov    $0x11,%eax
    1146:	cd 40                	int    $0x40
    1148:	c3                   	ret    

00001149 <unlink>:
SYSCALL(unlink)
    1149:	b8 12 00 00 00       	mov    $0x12,%eax
    114e:	cd 40                	int    $0x40
    1150:	c3                   	ret    

00001151 <fstat>:
SYSCALL(fstat)
    1151:	b8 08 00 00 00       	mov    $0x8,%eax
    1156:	cd 40                	int    $0x40
    1158:	c3                   	ret    

00001159 <link>:
SYSCALL(link)
    1159:	b8 13 00 00 00       	mov    $0x13,%eax
    115e:	cd 40                	int    $0x40
    1160:	c3                   	ret    

00001161 <mkdir>:
SYSCALL(mkdir)
    1161:	b8 14 00 00 00       	mov    $0x14,%eax
    1166:	cd 40                	int    $0x40
    1168:	c3                   	ret    

00001169 <chdir>:
SYSCALL(chdir)
    1169:	b8 09 00 00 00       	mov    $0x9,%eax
    116e:	cd 40                	int    $0x40
    1170:	c3                   	ret    

00001171 <dup>:
SYSCALL(dup)
    1171:	b8 0a 00 00 00       	mov    $0xa,%eax
    1176:	cd 40                	int    $0x40
    1178:	c3                   	ret    

00001179 <getpid>:
SYSCALL(getpid)
    1179:	b8 0b 00 00 00       	mov    $0xb,%eax
    117e:	cd 40                	int    $0x40
    1180:	c3                   	ret    

00001181 <sbrk>:
SYSCALL(sbrk)
    1181:	b8 0c 00 00 00       	mov    $0xc,%eax
    1186:	cd 40                	int    $0x40
    1188:	c3                   	ret    

00001189 <sleep>:
SYSCALL(sleep)
    1189:	b8 0d 00 00 00       	mov    $0xd,%eax
    118e:	cd 40                	int    $0x40
    1190:	c3                   	ret    

00001191 <uptime>:
SYSCALL(uptime)
    1191:	b8 0e 00 00 00       	mov    $0xe,%eax
    1196:	cd 40                	int    $0x40
    1198:	c3                   	ret    

00001199 <setvariable>:
SYSCALL(setvariable)
    1199:	b8 17 00 00 00       	mov    $0x17,%eax
    119e:	cd 40                	int    $0x40
    11a0:	c3                   	ret    

000011a1 <getvariable>:
SYSCALL(getvariable)
    11a1:	b8 18 00 00 00       	mov    $0x18,%eax
    11a6:	cd 40                	int    $0x40
    11a8:	c3                   	ret    

000011a9 <remvariable>:
SYSCALL(remvariable)
    11a9:	b8 19 00 00 00       	mov    $0x19,%eax
    11ae:	cd 40                	int    $0x40
    11b0:	c3                   	ret    

000011b1 <wait2>:
SYSCALL(wait2)
    11b1:	b8 1a 00 00 00       	mov    $0x1a,%eax
    11b6:	cd 40                	int    $0x40
    11b8:	c3                   	ret    

000011b9 <set_priority>:
SYSCALL(set_priority)
    11b9:	b8 1b 00 00 00       	mov    $0x1b,%eax
    11be:	cd 40                	int    $0x40
    11c0:	c3                   	ret    

000011c1 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    11c1:	55                   	push   %ebp
    11c2:	89 e5                	mov    %esp,%ebp
    11c4:	57                   	push   %edi
    11c5:	56                   	push   %esi
    11c6:	53                   	push   %ebx
    11c7:	83 ec 3c             	sub    $0x3c,%esp
    11ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    11cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    11d1:	74 12                	je     11e5 <printint+0x24>
    11d3:	89 d0                	mov    %edx,%eax
    11d5:	c1 e8 1f             	shr    $0x1f,%eax
    11d8:	84 c0                	test   %al,%al
    11da:	74 09                	je     11e5 <printint+0x24>
    neg = 1;
    x = -xx;
    11dc:	f7 da                	neg    %edx
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    11de:	be 01 00 00 00       	mov    $0x1,%esi
    11e3:	eb 05                	jmp    11ea <printint+0x29>
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    11e5:	be 00 00 00 00       	mov    $0x0,%esi
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    11ea:	bf 00 00 00 00       	mov    $0x0,%edi
    11ef:	eb 02                	jmp    11f3 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    11f1:	89 df                	mov    %ebx,%edi
    11f3:	8d 5f 01             	lea    0x1(%edi),%ebx
    11f6:	89 d0                	mov    %edx,%eax
    11f8:	ba 00 00 00 00       	mov    $0x0,%edx
    11fd:	f7 f1                	div    %ecx
    11ff:	0f b6 92 6c 16 00 00 	movzbl 0x166c(%edx),%edx
    1206:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
    120a:	89 c2                	mov    %eax,%edx
    120c:	85 c0                	test   %eax,%eax
    120e:	75 e1                	jne    11f1 <printint+0x30>
  if(neg)
    1210:	85 f6                	test   %esi,%esi
    1212:	74 08                	je     121c <printint+0x5b>
    buf[i++] = '-';
    1214:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1219:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
    121c:	89 d8                	mov    %ebx,%eax
    121e:	83 e8 01             	sub    $0x1,%eax
    1221:	78 29                	js     124c <printint+0x8b>
    1223:	8b 75 c4             	mov    -0x3c(%ebp),%esi
    1226:	8d 5c 1d d7          	lea    -0x29(%ebp,%ebx,1),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    122a:	8d 7d d7             	lea    -0x29(%ebp),%edi
    122d:	0f b6 03             	movzbl (%ebx),%eax
    1230:	88 45 d7             	mov    %al,-0x29(%ebp)
    1233:	83 ec 04             	sub    $0x4,%esp
    1236:	6a 01                	push   $0x1
    1238:	57                   	push   %edi
    1239:	56                   	push   %esi
    123a:	e8 da fe ff ff       	call   1119 <write>
    123f:	83 eb 01             	sub    $0x1,%ebx
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1242:	83 c4 10             	add    $0x10,%esp
    1245:	8d 45 d7             	lea    -0x29(%ebp),%eax
    1248:	39 c3                	cmp    %eax,%ebx
    124a:	75 e1                	jne    122d <printint+0x6c>
    putc(fd, buf[i]);
}
    124c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    124f:	5b                   	pop    %ebx
    1250:	5e                   	pop    %esi
    1251:	5f                   	pop    %edi
    1252:	5d                   	pop    %ebp
    1253:	c3                   	ret    

00001254 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1254:	55                   	push   %ebp
    1255:	89 e5                	mov    %esp,%ebp
    1257:	57                   	push   %edi
    1258:	56                   	push   %esi
    1259:	53                   	push   %ebx
    125a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    125d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1260:	0f b6 1e             	movzbl (%esi),%ebx
    1263:	84 db                	test   %bl,%bl
    1265:	0f 84 a6 01 00 00    	je     1411 <printf+0x1bd>
    126b:	83 c6 01             	add    $0x1,%esi
    126e:	8d 45 10             	lea    0x10(%ebp),%eax
    1271:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1274:	bf 00 00 00 00       	mov    $0x0,%edi
    c = fmt[i] & 0xff;
    1279:	0f be d3             	movsbl %bl,%edx
    127c:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    127f:	85 ff                	test   %edi,%edi
    1281:	75 25                	jne    12a8 <printf+0x54>
      if(c == '%'){
    1283:	83 f8 25             	cmp    $0x25,%eax
    1286:	0f 84 6a 01 00 00    	je     13f6 <printf+0x1a2>
    128c:	88 5d e2             	mov    %bl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    128f:	83 ec 04             	sub    $0x4,%esp
    1292:	6a 01                	push   $0x1
    1294:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1297:	50                   	push   %eax
    1298:	ff 75 08             	pushl  0x8(%ebp)
    129b:	e8 79 fe ff ff       	call   1119 <write>
    12a0:	83 c4 10             	add    $0x10,%esp
    12a3:	e9 5a 01 00 00       	jmp    1402 <printf+0x1ae>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    12a8:	83 ff 25             	cmp    $0x25,%edi
    12ab:	0f 85 51 01 00 00    	jne    1402 <printf+0x1ae>
      if(c == 'd'){
    12b1:	83 f8 64             	cmp    $0x64,%eax
    12b4:	75 2c                	jne    12e2 <printf+0x8e>
        printint(fd, *ap, 10, 1);
    12b6:	83 ec 0c             	sub    $0xc,%esp
    12b9:	6a 01                	push   $0x1
    12bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
    12c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    12c3:	8b 17                	mov    (%edi),%edx
    12c5:	8b 45 08             	mov    0x8(%ebp),%eax
    12c8:	e8 f4 fe ff ff       	call   11c1 <printint>
        ap++;
    12cd:	89 f8                	mov    %edi,%eax
    12cf:	83 c0 04             	add    $0x4,%eax
    12d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    12d5:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    12d8:	bf 00 00 00 00       	mov    $0x0,%edi
    12dd:	e9 20 01 00 00       	jmp    1402 <printf+0x1ae>
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    12e2:	81 e2 f7 00 00 00    	and    $0xf7,%edx
    12e8:	83 fa 70             	cmp    $0x70,%edx
    12eb:	75 2c                	jne    1319 <printf+0xc5>
        printint(fd, *ap, 16, 0);
    12ed:	83 ec 0c             	sub    $0xc,%esp
    12f0:	6a 00                	push   $0x0
    12f2:	b9 10 00 00 00       	mov    $0x10,%ecx
    12f7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    12fa:	8b 17                	mov    (%edi),%edx
    12fc:	8b 45 08             	mov    0x8(%ebp),%eax
    12ff:	e8 bd fe ff ff       	call   11c1 <printint>
        ap++;
    1304:	89 f8                	mov    %edi,%eax
    1306:	83 c0 04             	add    $0x4,%eax
    1309:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    130c:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    130f:	bf 00 00 00 00       	mov    $0x0,%edi
    1314:	e9 e9 00 00 00       	jmp    1402 <printf+0x1ae>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1319:	83 f8 73             	cmp    $0x73,%eax
    131c:	75 52                	jne    1370 <printf+0x11c>
        s = (char*)*ap;
    131e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1321:	8b 18                	mov    (%eax),%ebx
        ap++;
    1323:	83 c0 04             	add    $0x4,%eax
    1326:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1329:	85 db                	test   %ebx,%ebx
          s = "(null)";
    132b:	b8 64 16 00 00       	mov    $0x1664,%eax
    1330:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
    1333:	0f b6 03             	movzbl (%ebx),%eax
    1336:	84 c0                	test   %al,%al
    1338:	0f 84 bf 00 00 00    	je     13fd <printf+0x1a9>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    133e:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1341:	89 75 d0             	mov    %esi,-0x30(%ebp)
    1344:	8b 75 08             	mov    0x8(%ebp),%esi
    1347:	88 45 e3             	mov    %al,-0x1d(%ebp)
    134a:	83 ec 04             	sub    $0x4,%esp
    134d:	6a 01                	push   $0x1
    134f:	57                   	push   %edi
    1350:	56                   	push   %esi
    1351:	e8 c3 fd ff ff       	call   1119 <write>
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    1356:	83 c3 01             	add    $0x1,%ebx
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1359:	0f b6 03             	movzbl (%ebx),%eax
    135c:	83 c4 10             	add    $0x10,%esp
    135f:	84 c0                	test   %al,%al
    1361:	75 e4                	jne    1347 <printf+0xf3>
    1363:	8b 75 d0             	mov    -0x30(%ebp),%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1366:	bf 00 00 00 00       	mov    $0x0,%edi
    136b:	e9 92 00 00 00       	jmp    1402 <printf+0x1ae>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1370:	83 f8 63             	cmp    $0x63,%eax
    1373:	75 2b                	jne    13a0 <printf+0x14c>
    1375:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    1378:	8b 07                	mov    (%edi),%eax
    137a:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    137d:	83 ec 04             	sub    $0x4,%esp
    1380:	6a 01                	push   $0x1
    1382:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1385:	50                   	push   %eax
    1386:	ff 75 08             	pushl  0x8(%ebp)
    1389:	e8 8b fd ff ff       	call   1119 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    138e:	89 f8                	mov    %edi,%eax
    1390:	83 c0 04             	add    $0x4,%eax
    1393:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1396:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1399:	bf 00 00 00 00       	mov    $0x0,%edi
    139e:	eb 62                	jmp    1402 <printf+0x1ae>
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13a0:	83 f8 25             	cmp    $0x25,%eax
    13a3:	75 1e                	jne    13c3 <printf+0x16f>
    13a5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13a8:	83 ec 04             	sub    $0x4,%esp
    13ab:	6a 01                	push   $0x1
    13ad:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    13b0:	50                   	push   %eax
    13b1:	ff 75 08             	pushl  0x8(%ebp)
    13b4:	e8 60 fd ff ff       	call   1119 <write>
    13b9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13bc:	bf 00 00 00 00       	mov    $0x0,%edi
    13c1:	eb 3f                	jmp    1402 <printf+0x1ae>
    13c3:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    13c7:	83 ec 04             	sub    $0x4,%esp
    13ca:	6a 01                	push   $0x1
    13cc:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13cf:	50                   	push   %eax
    13d0:	ff 75 08             	pushl  0x8(%ebp)
    13d3:	e8 41 fd ff ff       	call   1119 <write>
    13d8:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    13db:	83 c4 0c             	add    $0xc,%esp
    13de:	6a 01                	push   $0x1
    13e0:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    13e3:	50                   	push   %eax
    13e4:	ff 75 08             	pushl  0x8(%ebp)
    13e7:	e8 2d fd ff ff       	call   1119 <write>
    13ec:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13ef:	bf 00 00 00 00       	mov    $0x0,%edi
    13f4:	eb 0c                	jmp    1402 <printf+0x1ae>
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    13f6:	bf 25 00 00 00       	mov    $0x25,%edi
    13fb:	eb 05                	jmp    1402 <printf+0x1ae>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13fd:	bf 00 00 00 00       	mov    $0x0,%edi
    1402:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1405:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1409:	84 db                	test   %bl,%bl
    140b:	0f 85 68 fe ff ff    	jne    1279 <printf+0x25>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1411:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1414:	5b                   	pop    %ebx
    1415:	5e                   	pop    %esi
    1416:	5f                   	pop    %edi
    1417:	5d                   	pop    %ebp
    1418:	c3                   	ret    

00001419 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1419:	55                   	push   %ebp
    141a:	89 e5                	mov    %esp,%ebp
    141c:	57                   	push   %edi
    141d:	56                   	push   %esi
    141e:	53                   	push   %ebx
    141f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1422:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1425:	a1 00 1e 00 00       	mov    0x1e00,%eax
    142a:	eb 0c                	jmp    1438 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    142c:	8b 10                	mov    (%eax),%edx
    142e:	39 d0                	cmp    %edx,%eax
    1430:	72 04                	jb     1436 <free+0x1d>
    1432:	39 d1                	cmp    %edx,%ecx
    1434:	72 0c                	jb     1442 <free+0x29>
static Header base;
static Header *freep;

void
free(void *ap)
{
    1436:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1438:	39 c8                	cmp    %ecx,%eax
    143a:	73 f0                	jae    142c <free+0x13>
    143c:	8b 10                	mov    (%eax),%edx
    143e:	39 d1                	cmp    %edx,%ecx
    1440:	73 3e                	jae    1480 <free+0x67>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1442:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1445:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1448:	8b 10                	mov    (%eax),%edx
    144a:	39 d7                	cmp    %edx,%edi
    144c:	75 0f                	jne    145d <free+0x44>
    bp->s.size += p->s.ptr->s.size;
    144e:	03 77 04             	add    0x4(%edi),%esi
    1451:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1454:	8b 10                	mov    (%eax),%edx
    1456:	8b 12                	mov    (%edx),%edx
    1458:	89 53 f8             	mov    %edx,-0x8(%ebx)
    145b:	eb 03                	jmp    1460 <free+0x47>
  } else
    bp->s.ptr = p->s.ptr;
    145d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1460:	8b 50 04             	mov    0x4(%eax),%edx
    1463:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1466:	39 f1                	cmp    %esi,%ecx
    1468:	75 0d                	jne    1477 <free+0x5e>
    p->s.size += bp->s.size;
    146a:	03 53 fc             	add    -0x4(%ebx),%edx
    146d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1470:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1473:	89 10                	mov    %edx,(%eax)
    1475:	eb 02                	jmp    1479 <free+0x60>
  } else
    p->s.ptr = bp;
    1477:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1479:	a3 00 1e 00 00       	mov    %eax,0x1e00
}
    147e:	eb 06                	jmp    1486 <free+0x6d>
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1480:	39 d0                	cmp    %edx,%eax
    1482:	72 b2                	jb     1436 <free+0x1d>
    1484:	eb bc                	jmp    1442 <free+0x29>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}
    1486:	5b                   	pop    %ebx
    1487:	5e                   	pop    %esi
    1488:	5f                   	pop    %edi
    1489:	5d                   	pop    %ebp
    148a:	c3                   	ret    

0000148b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    148b:	55                   	push   %ebp
    148c:	89 e5                	mov    %esp,%ebp
    148e:	57                   	push   %edi
    148f:	56                   	push   %esi
    1490:	53                   	push   %ebx
    1491:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1494:	8b 45 08             	mov    0x8(%ebp),%eax
    1497:	8d 58 07             	lea    0x7(%eax),%ebx
    149a:	c1 eb 03             	shr    $0x3,%ebx
    149d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    14a0:	8b 15 00 1e 00 00    	mov    0x1e00,%edx
    14a6:	85 d2                	test   %edx,%edx
    14a8:	75 23                	jne    14cd <malloc+0x42>
    base.s.ptr = freep = prevp = &base;
    14aa:	c7 05 00 1e 00 00 04 	movl   $0x1e04,0x1e00
    14b1:	1e 00 00 
    14b4:	c7 05 04 1e 00 00 04 	movl   $0x1e04,0x1e04
    14bb:	1e 00 00 
    base.s.size = 0;
    14be:	c7 05 08 1e 00 00 00 	movl   $0x0,0x1e08
    14c5:	00 00 00 
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    14c8:	ba 04 1e 00 00       	mov    $0x1e04,%edx
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14cd:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    14cf:	8b 48 04             	mov    0x4(%eax),%ecx
    14d2:	39 cb                	cmp    %ecx,%ebx
    14d4:	77 20                	ja     14f6 <malloc+0x6b>
      if(p->s.size == nunits)
    14d6:	39 cb                	cmp    %ecx,%ebx
    14d8:	75 06                	jne    14e0 <malloc+0x55>
        prevp->s.ptr = p->s.ptr;
    14da:	8b 08                	mov    (%eax),%ecx
    14dc:	89 0a                	mov    %ecx,(%edx)
    14de:	eb 0b                	jmp    14eb <malloc+0x60>
      else {
        p->s.size -= nunits;
    14e0:	29 d9                	sub    %ebx,%ecx
    14e2:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    14e5:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    14e8:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    14eb:	89 15 00 1e 00 00    	mov    %edx,0x1e00
      return (void*)(p + 1);
    14f1:	83 c0 08             	add    $0x8,%eax
    14f4:	eb 63                	jmp    1559 <malloc+0xce>
    14f6:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
    14fc:	be 00 10 00 00       	mov    $0x1000,%esi
    1501:	0f 43 f3             	cmovae %ebx,%esi
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    1504:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
    150b:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    150d:	39 05 00 1e 00 00    	cmp    %eax,0x1e00
    1513:	75 2d                	jne    1542 <malloc+0xb7>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    1515:	83 ec 0c             	sub    $0xc,%esp
    1518:	57                   	push   %edi
    1519:	e8 63 fc ff ff       	call   1181 <sbrk>
  if(p == (char*)-1)
    151e:	83 c4 10             	add    $0x10,%esp
    1521:	83 f8 ff             	cmp    $0xffffffff,%eax
    1524:	74 27                	je     154d <malloc+0xc2>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    1526:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1529:	83 ec 0c             	sub    $0xc,%esp
    152c:	83 c0 08             	add    $0x8,%eax
    152f:	50                   	push   %eax
    1530:	e8 e4 fe ff ff       	call   1419 <free>
  return freep;
    1535:	8b 15 00 1e 00 00    	mov    0x1e00,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    153b:	83 c4 10             	add    $0x10,%esp
    153e:	85 d2                	test   %edx,%edx
    1540:	74 12                	je     1554 <malloc+0xc9>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1542:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1544:	8b 48 04             	mov    0x4(%eax),%ecx
    1547:	39 cb                	cmp    %ecx,%ebx
    1549:	77 c0                	ja     150b <malloc+0x80>
    154b:	eb 89                	jmp    14d6 <malloc+0x4b>
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
    154d:	b8 00 00 00 00       	mov    $0x0,%eax
    1552:	eb 05                	jmp    1559 <malloc+0xce>
    1554:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
    1559:	8d 65 f4             	lea    -0xc(%ebp),%esp
    155c:	5b                   	pop    %ebx
    155d:	5e                   	pop    %esi
    155e:	5f                   	pop    %edi
    155f:	5d                   	pop    %ebp
    1560:	c3                   	ret    
