// Shell.

#include "types.h"
#include "user.h"
#include "fcntl.h"

// Parsed command representation
#define EXEC  1
#define REDIR 2
#define PIPE  3
#define LIST  4
#define BACK  5
#define MAX_HISTORY 16
#define MAXARGS 10
#define MAXLEN 128
#define MAX_VARIABLES 3
#define MAX_VAR_LEN 32
#define MAX_VAL_LEN 128
char* history[MAX_HISTORY]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; //command history



struct cmd {
  int type;
};

struct execcmd {
  int type;
  char *argv[MAXARGS];
  char *eargv[MAXARGS];
};

struct redircmd {
  int type;
  struct cmd *cmd;
  char *file;
  char *efile;
  int mode;
  int fd;
};

struct pipecmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct listcmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct backcmd {
  int type;
  struct cmd *cmd;
};

int strncmp(char* s1, char* s2, int len){
    char s1Char=s1[len];
    char s2Char=s2[len];
    int toReturn;
    s1[len]=0;
    s2[len]=0;
    toReturn=strcmp(s1,s2);
    s1[len]=s1Char;
    s2[len]=s2Char;
    return toReturn;
    
}

//shift the command array by 1, and add a new command
void shiftAndAdd(char* command){
    //printf(1,"SHIFTED!");
    free(history[0]);
    //history[0]=0;
    int i;
    for(i=1; i<MAX_HISTORY; i++){
        history[i-1]=history[i];
    }
    history[MAX_HISTORY-1]=command;
}
//check if history command 
void printHistory(){
    int i;
    int counter=0;
    for(i=0; i<MAX_HISTORY; i++){
        if(history[i]!=0){
            printf(1, "%d. ",counter+1);
            printf(1,history[i]);
            counter++;
        }
        
    }
}

//check if the user entered an "history" command
int isPrintHistory(char* buf){
    if(strcmp(buf,"history\n")==0)
        return 1;
    return 0;    
}
//
char* runToNextWord(char* runner){
    int i=0;
    while(*runner!=' ' && i<=MAXLEN ){
        runner++;            //run until space
        i++;
    }
    runner=runner+1;
    return runner;
}
//handle history -l ##    command
int handleRunFromHistory(char* buf){
    if(strncmp(buf,"history",7)==0){
        char* runner=buf;
        runner=runToNextWord(runner);
        if(strncmp(runner,"-l",2)==0){
            runner=runToNextWord(runner);
            int lineToRun=atoi(runner)-1;
            strcpy(buf, history[lineToRun]);
            return 1;
            
        }
    }
    return 0;
    
    
    
}
//Handles variable Assignment if needed.
int handleVariableAssign(char* buf){
    int i=0;        //index to iterate over buf
    int j=0;        //index to iterate over value
    i=0;
    char* variable=malloc(MAX_VAR_LEN);
    char* value=malloc(MAX_VAL_LEN);
    //copy the variable
    while(buf[i]!='='){
        //if not a letter
        if(!((buf[i]>='a' && buf[i]<='z') || (buf[i]>='A' && buf[i]<='Z')))
            return -1;
        variable[i]=buf[i];
        i++;
    }
    variable[i]=0;       //null terminate
    //advance index to the value
    i++;
    //copy the value
    while(buf[i]!='\n' && buf[i]!=0 ){
        value[j]=buf[i];
        i++;
        j++;
    }
    value[j]=0;       //null terminate
    return setvariable(variable, value);

    
    
}


//insert the correct value at index 'swapIndex'
int insertValue(char* buf, int swapIndex){
    int i=swapIndex+1; //point to the variable's name
    int varIndex=0;    //iterate over the variable's name
    char swapped[MAXLEN]={0};
    char variable[MAX_VAR_LEN]={0};
    char value[MAX_VAL_LEN]={0};
    //add to variable, until reaching ending of variable name.
    while(buf[i]!='$' && buf[i]!=' ' && buf[i]!='\n' && buf[i]!=0){
        variable[varIndex]=buf[i];
        i++;
        varIndex++;        
    }
    variable[varIndex]=0;    //null terminate the variable name
    //now variable has the needed name, put the value into value
    int varExists=getvariable((char*)&variable,(char*)&value);
    if(varExists!=0){
        return varExists;
    }
    //create the new array after swapping
    i=0;
    int newIndex=0;
    while(i<swapIndex){
        swapped[i]=buf[i];
        i++;
        //newIndex++;
    }
    //now copy the value
    newIndex=swapIndex;
    int j;
    for(j=0; j<strlen(value); j++){
        swapped[newIndex]=value[j];
        newIndex++;        
    }
    //now copy the rest to "swapped"
    i=swapIndex+strlen(variable) + 1;   //point to the spot after $<varname>
    while(buf[i]!='\n' && i<=MAXLEN){
        swapped[newIndex]=buf[i];
        i++;
        newIndex++;
    }
    swapped[newIndex]=0;
    strcpy(buf,swapped);    //copy the swapped line into buf, and return    
    //memset(buf,MAXLEN,0);
    return varExists;
}
//Swap all $<var> to their values.
void swapAllVariables(char* buf){
    int i=0;            //iterate over buf
    //char* swapped=malloc(MAXLEN);   //the new buf after swapping $<?> with value
    while(buf[i]!='\n' && i<=MAXLEN && buf[i]!=0){
        //if  $ sign, swap in swapped
        if(buf[i]=='$'){
            insertValue(buf, i);
        }
        i++;
    }
    

}
//return 0 to continue (skip iteration), or 1 to run as usual
int handleVariableCommand(char* buf){
    int i;
    for(i=0; i<MAXLEN; i++){//iterate over the line
        if(buf[i]=='=')     //if assigning
            return handleVariableAssign(buf);
    }
    return 1;  //no assignment needed
}

int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct cmd *parsecmd(char*);

//add a command to the history array
//if there's not place in the history array, shift all commands, then add.
void addCommand(char* buf){
    char* command=malloc(MAXLEN);
    int foundSpot=0;
    strcpy(command,buf);   
    int i;
    for(i=0; i<MAX_HISTORY; i++){
        if(history[i] == 0){
            history[i]=command;
            foundSpot=1;
            break;
        }
    }
    if(!foundSpot){
        shiftAndAdd(command);
        
    }
}


// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2];
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;
  if(cmd == 0)
    exit();

  switch(cmd->type){
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit();
    exec(ecmd->argv[0], ecmd->argv);

    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    close(rcmd->fd);
    if(open(rcmd->file, rcmd->mode) < 0){
      printf(2, "open %s failed\n", rcmd->file);
      exit();
    }
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    if(fork1() == 0)
      runcmd(lcmd->left);
    wait();
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    if(pipe(p) < 0)
      panic("pipe");
    if(fork1() == 0){
      close(1);
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if(fork1() == 0){
      close(0);
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    close(p[1]);
    wait();
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    if(fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
}

int
getcmd(char *buf, int nbuf)
{
  printf(2, "$ ");
  memset(buf, 0, nbuf);
  gets(buf, nbuf);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int
main(void)
{
  static char buf[MAXLEN];
  int fd;
  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
    if(fd >= 3){
      close(fd);
      break;
    }
  }

  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    //add the input to the history
    addCommand(buf);
    if(isPrintHistory(buf)){
        printHistory();
        //buf[0]=0;
        continue;        
    }
    swapAllVariables(buf);
    handleRunFromHistory(buf);
    swapAllVariables(buf);
    
    
    int variableAssign=handleVariableCommand(buf);
    if(variableAssign==0)
        continue;
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(fork1() == 0) {
        runcmd(parsecmd(buf));

    }
    wait();
  }
  exit();
}

void
panic(char *s)
{
  printf(2, "%s\n", s);
  exit();
}

int
fork1(void)
{
  int pid;

  pid = fork();
  if(pid == -1)
    panic("fork");
  return pid;
}

//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd = fd;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = PIPE;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = LIST;
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

struct cmd*
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
  cmd->cmd = subcmd;
  return (struct cmd*)cmd;
}
//PAGEBREAK!
// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
  case '|':
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
}

struct cmd*
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if(!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
  int i;
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    nulterminate(pcmd->left);
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
