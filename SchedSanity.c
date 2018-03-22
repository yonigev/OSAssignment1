#include "types.h"
#include "user.h"
#include "stat.h"
#define MEDIUM_LOOP_SIZE 1000
#define LARGE_LOOP_SIZE 500000
#define VERY_LARGE_LOOP_SIZE 100000000
#define PROCNUM 4
int process_1(){
    int loopSize=MEDIUM_LOOP_SIZE;
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    for(i=0; i<loopSize; i++){
        res=num1+num2;
        res=0;
    }
    return res;

}


int process_2(){
    int loopSize=VERY_LARGE_LOOP_SIZE;
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res=0;
    for(i=0; i<loopSize; i++){
        res=num1+num2;
        res=0;
    }
    return res;
}
int process_3(){
    int loopSize=MEDIUM_LOOP_SIZE;
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
    //char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
        res=num1+num2;
        res=0;
        //printf(1,toPrint,res);
        //printf(1,"ITERATION: %d", i);
    }
    return res;
}

int process_4(){
    int loopSize=VERY_LARGE_LOOP_SIZE;
    int i;
    long num1 = 12345678;
    long num2 = 98765432;
    long res;
   // char* toPrint="We don't know what we're testing!!!!\nBut the result is:%d\n";
    for(i=0; i<loopSize; i++){
        res=num1+num2;
        res=0;
        //printf(1,toPrint,res);
        //printf(1,"\n\nITERATION: %d\n\n", i);
    }
    return res;
}






int pid1;
int pid2;
int pid3;
int pid4;

int wtime   =   0;
int rtime   =   0;
int iotime  =   0;

int wtime_acc   =   0;
int rtime_acc   =   0;
int iotime_acc   =   0;

//call wait2 on pid, and accumulate data.
void wait2AndCollect(int pid){
    wait2(pid,&wtime,&rtime,&iotime);
    wtime_acc+=wtime;
    rtime_acc+=rtime;
    iotime_acc+=iotime;
}

int main(){


    if((pid1=fork())==0){
        printf(1,"I'm process 1, pid: %d\n",getpid());
        process_1();
        exit();
    }
    else if((pid2=fork())==0){
        printf(1,"I'm process 2, pid: %d\n",getpid());
        process_2();
        exit();

    }
    else if((pid3=fork())==0){
        printf(1,"I'm process, pid: %d 3\n",getpid());
        process_3();
    }
    else if((pid4=fork())==0){
        printf(1,"I'm process 4, pid: %d\n",getpid());
        process_4();
    }
    else{

        wait2AndCollect(pid1);
        wait2AndCollect(pid2);
        wait2AndCollect(pid3);
        wait2AndCollect(pid4);

        printf(1,"wtime average: %d \n", wtime_acc/PROCNUM);
        printf(1,"rtime average: %d \n", rtime_acc/PROCNUM);
        printf(1,"iotime average: %d \n", iotime_acc/PROCNUM);



    }






    exit();

}