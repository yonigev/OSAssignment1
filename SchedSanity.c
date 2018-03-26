#include "types.h"
#include "user.h"
#include "stat.h"
#define MEDIUM_LOOP_SIZE 10000
#define LARGE_LOOP_SIZE 500000
#define VERY_LARGE_LOOP_SIZE 10000000
#define PROCNUM 10
int pids[PROCNUM]={0};

int process_1(){
    int loopSize=MEDIUM_LOOP_SIZE;
    int i;
    int sum=0;
    for(i=0; i<loopSize; i++){
       sum=sum+i;
    }
    return sum;
}


int process_2(){
    int loopSize=VERY_LARGE_LOOP_SIZE;
    int i;
    int sum=0;
    for(i=0; i<loopSize; i++){
        sum=sum+i;
    }
    return sum;
}
int process_3(){
    int loopSize=MEDIUM_LOOP_SIZE;
    int i;
    int sum=0;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
        sum=sum+i;
        //printf(1,toPrint,res);
       // printf(1,"%d\n", i);
    }
    return sum;
}

int process_4(){
    int loopSize=VERY_LARGE_LOOP_SIZE;
    int i;
    int sum=0;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
        sum=sum+i;
        //printf(1,toPrint,res);
        //printf(1,"%d\n", i);
    }
    return sum;
}



int wtime_acc   =   0;
int rtime_acc   =   0;
int iotime_acc   =   0;

int wtime=0;
int rtime=0;
int iotime=0;

//call wait2 on pid, and accumulate data.
void wait2AndCollect(int pid){
    wait2(pid,&wtime,&rtime,&iotime);
    wtime_acc+=wtime;
    rtime_acc+=rtime;
    iotime_acc+=iotime;
    wtime=0;
    rtime=0;
    iotime=0;
}

int main(){

    int i;
    for(i=0; i<PROCNUM; i++){
       pids[i]=fork();
       if(pids[i]==0){
           switch(i % 4){
               case 0:
               process_4();
               exit();
               break;

               case 1:
               process_1();
               exit();
               break;

               case 2:
               process_2();
               exit();
               break;

               case 3:
               process_3();
               exit();
               break;
           }
       }
    }

   //if it's the parent
    if(pids[PROCNUM-1]!=0){
        for(i=0; i<PROCNUM; i++){
            wait2AndCollect(pids[i]);
        }
        printf(1,"wtime average: %d \n", wtime_acc/PROCNUM);
        printf(1,"rtime average: %d \n", rtime_acc/PROCNUM);
        printf(1,"iotime average: %d \n", iotime_acc/PROCNUM);
    }
    exit();

}
