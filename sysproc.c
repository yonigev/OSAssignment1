#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

#define MAX_VARIABLES 32
#define MAX_VAR_LEN 32
#define MAX_VAL_LEN 128

struct variable_pair{

    char* variable;
    char* value; 
    
};

struct variable_pair variable_array[MAX_VARIABLES];

int sys_yield(void)
{
  yield(); 
  return 0;
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

//added task 1.2
//task 1.2 implementations

int
sys_setvariable(void){
    char* variable;
    char* value;
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
        return -1;
    return setvariable(variable , value);
}
int
sys_getvariable(void){
    char* variable;
    char* value;
    if(argstr(0, &variable) < 0 || argstr(1, &value)<0)
        return -1;
    return getvariable(variable , value);
}
int
sys_remvariable(void){
    char* variable;
    if(argstr(0, &variable) < 0)
        return -1;
    return remvariable(variable);
    
}

int
sys_wait2(void){
    int pid;
    int* wtime;
    int* rtime;
    int* iotime;
    if(argint(0, &pid) < 0 || argint(1, (int *)&wtime) < 0 || argint(2, (int *)&rtime) < 0 || argint(3, (int *)&iotime) < 0){
        return -1;
    }
    return wait2(pid,wtime,rtime,iotime);
}

int
sys_set_priority(void){
    int priority;
    if(argint(0, &priority)<0)
        return -1;
    return  set_priority(priority);
}


int onlyLetters(char* s){
    int i;
    for(i=0; i<strlen(s); i++){
        if(!(s[i]>='a' && s[i]<='z' )|| (s[i]>='A' && s[i]<='Z'))
            return 0;
    }
    return 1;
}
//get a free index for a variable. if none available, returns -1
int getFreeIndex(char* variable){
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
        char* current_variable=variable_array[i].variable;
        if(strlen(variable) == strlen(current_variable) && strncmp(variable,current_variable,strlen(variable))==0)
            return i;
    }
    for(i=0; i<MAX_VARIABLES; i++){
         if(variable_array[i].variable == 0 && variable_array[i].value == 0)
            return i;
    }
    return -1;
    
}


//implementation of setVariable
int setvariable(char* variable, char* value){
    
    int freeIndex;
    //if illegal input
    if(!onlyLetters(variable) || strlen(variable)>32 || strlen(value)>128)
        return -2;
    if((freeIndex=getFreeIndex(variable))==-1)
        return -1;
    //------------------
    variable_array[freeIndex].variable=variable;
    variable_array[freeIndex].value=value;
    return 0;
}

//implementation of getVariable
int getvariable(char* variable, char* value){
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
        if(strncmp(variable_array[i].variable,variable, strlen(variable))==0){
            strncpy(value,variable_array[i].value,strlen(variable_array[i].value));
            value[strlen(value)]=0; //null terminate the value
            return 0;
        }
    }
    return -1;
}

//implementation of remVariable
int remvariable(char* variable){
    int i;
    for(i=0; i<MAX_VARIABLES; i++){
        if(strncmp(variable_array[i].variable,variable, strlen(variable)==0)){
            variable_array[i].variable=0;
            variable_array[i].value=0;

            return 0;
        }
    }
    return -1;
    
    
}

//int wait2(int pid, int* wtime, int* rtime, int* iotime){
//
//
//
//
//}