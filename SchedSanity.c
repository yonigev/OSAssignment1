#include "types.h"
#include "user.h"
#include "stat.h"
#define MEDIUM_LOOP_SIZE 20
#define VERY_LARGE_LOOP_SIZE 60
#define MAXINT 2147483647
#define PROCNUM 10


int pids[PROCNUM *  4]={0};


int process_1(){
    int i;
    int sum=0;
    float x=123.232;
    for(i=0; i<MAXINT; i++){
        sum=sum+i;
        x=x*i*80.20*19.8/2.2;


        asm("");

    }
    return sum;
}


int process_2(){
    int i;
    int sum=0;
    float x=123.232;

    for(i=0; i<MAXINT; i++){
        sum=sum+i;
        x=x*x*x*x/123.4122+1+2+3;

        asm("");
    }
    return sum;
}
int process_3(){
    int i;
    int sum=0;
    for(i=0; i<MEDIUM_LOOP_SIZE; i++){
        sum=sum+i;
        //printf(1,"%d\n", i);
        sleep(1);
    }
    return sum;
}

int process_4(){
    int i;
    int sum=0;

    for(i=0; i<VERY_LARGE_LOOP_SIZE; i++){
        sum=sum+i;
        //printf(1,"%d\n", i);
        sleep(1);
    }
    return sum;
}

// Accumulators for each type of process. 
//{type1,type2,type3,type4}
int wtime_acc[4]={0};
int rtime_acc[4]={0};
int iotime_acc[4]={0};

//call wait2 on pid, and accumulate data.
void wait2AndCollect(int type,int pid){
    int wtime=0;
    int rtime=0;
    int iotime=0;
    wait2(pid,&wtime,&rtime,&iotime);
    wtime_acc[type-1]+=wtime;
    rtime_acc[type-1]+=rtime;
    iotime_acc[type-1]+=iotime;
    wtime=0;
    rtime=0;
    iotime=0;
}

int main(){

    int i;
    int type=1;
    for(i=0; i< PROCNUM * 4; i++){
       pids[i]=fork();
       if(pids[i]==0){
           switch(type){
               case 1:
               set_priority(2);
               process_1();
               exit();
               break;

               case 2:
               set_priority(3);
               process_2();
               exit();
               break;

               case 3:
               set_priority(2);
               process_3();
               exit();
               break;

               case 4:
               set_priority(1);
               process_4();
               exit();
               break;
           }
       }
       //move to next type of process.
           if(type<4)
             type++;
           else
             type=1;
    }

   //if it's the parent
    if(pids[PROCNUM-1]!=0){
        type=1;
        for(i=0; i<PROCNUM * 4; i++){
            wait2AndCollect(type,pids[i]);
            if(type<4)
             type++;
            else
             type=1;
        }
       


        printf(1,"TYPE 1\n----------------\n");
        printf(1,"wtime average: %d \n", wtime_acc[0]/PROCNUM);
        printf(1,"rtime average: %d \n", rtime_acc[0]/PROCNUM);
        printf(1,"iotime average: %d \n", iotime_acc[0]/PROCNUM);

        printf(1,"TYPE 2\n----------------\n");
        printf(1,"wtime average: %d \n", wtime_acc[1]/PROCNUM);
        printf(1,"rtime average: %d \n", rtime_acc[1]/PROCNUM);
        printf(1,"iotime average: %d \n", iotime_acc[1]/PROCNUM);

        printf(1,"TYPE 3\n----------------\n");
        printf(1,"wtime average: %d \n", wtime_acc[2]/PROCNUM);
        printf(1,"rtime average: %d \n", rtime_acc[2]/PROCNUM);
        printf(1,"iotime average: %d \n", iotime_acc[2]/PROCNUM);

        printf(1,"TYPE 4\n----------------\n");
        printf(1,"wtime average: %d \n", wtime_acc[3]/PROCNUM);
        printf(1,"rtime average: %d \n", rtime_acc[3]/PROCNUM);
        printf(1,"iotime average: %d \n", iotime_acc[3]/PROCNUM);
    }
    exit();

}
