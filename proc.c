#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"


struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;


static struct proc *initproc;

int nextpid = 1;

extern void forkret(void);

extern void trapret(void);

static void wakeup1(void *chan);

//a process queue .
struct process_queue {
    //struct spinlock *lock;
    struct proc *processes[NPROC];
    int lastIndex;
} pq = {.processes={0},
        .lastIndex= 0};

//Enqueue a process (pointer)
void enqueue(struct proc *toAdd) {

    if (pq.lastIndex == NPROC) {
        //no place
    } else {
        pq.processes[pq.lastIndex] = toAdd;
        pq.lastIndex++;
    }
}

//Dequeue a process pointer
struct proc *dequeue() {
    //cprintf("dequeueing!!!!!!!!!!!!!!!!!!!\n\n");
    struct proc *toReturn = pq.processes[0];
    //cprintf("pq.processes[0]= :%d\n", toReturn);
    pq.processes[0] = 0;
    int i;
    for (i = 0; i < NPROC; i++) {
        if (i == NPROC - 1)
            pq.processes[i] = 0;
        else
            pq.processes[i] = pq.processes[i + 1];
    }
    pq.lastIndex--;
    return toReturn;
}


void
pinit(void) {
    initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
    c = mycpu();
    p = c->proc;
    popcli();
    return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
    struct proc *p;
    char *sp;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;

    release(&ptable.lock);

    // Allocate kernel stack.
    if ((p->kstack = kalloc()) == 0) {
        p->state = UNUSED;
        return 0;
    }
    sp = p->kstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
    p->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *p->context;
    p->context = (struct context *) sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint) forkret;
    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();

    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->tf, 0, sizeof(*p->tf));
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->tf->es = p->tf->ds;
    p->tf->ss = p->tf->ds;
    p->tf->eflags = FL_IF;
    p->tf->esp = PGSIZE;
    p->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    p->cwd = namei("/");

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.
    acquire(&ptable.lock);
    p->ctime=ticks;
    p->iotime=0;
    p->rtime=0;
    p->AI=QUANTUM;
    p->trem=QUANTUM;
    p->priority=2;
    p->state = RUNNABLE;


#ifdef FCFS
    cprintf("ENQUEUEING INIT PROCESS\n\n");
    enqueue(p);
#endif
    release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
    switchuvm(curproc);
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->kstack);
        np->kstack = 0;
        np->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->tf = *curproc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);
    np->cwd = idup(curproc->cwd);

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));

    pid = np->pid;

    acquire(&ptable.lock);


    //update creation time (task2)
    np->ctime = ticks;
    np->rtime = 0;
    np->iotime = 0;
    np->AI = QUANTUM;
    np->trem=QUANTUM;     //limit ticks remaining to QUANTUM
    np->lastRtime=0;
    //task 3.4 requirement
    if(np->parent!=0)
        np->priority=np->parent->priority;
    else{
        np->priority=2;
    }
    //task 3.3 requirement for fork? TODO: ask in forum
    np->parent->AI=QUANTUM;

    np->state = RUNNABLE;
#ifdef FCFS
    enqueue(np);
#endif

    release(&ptable.lock);

    return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
    struct proc *curproc = myproc();
    struct proc *p;
    int fd;

    if (curproc == initproc)
        panic("init exiting");

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }

    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;

    acquire(&ptable.lock);

    // Parent might be sleeping in wait().
    wakeup1(curproc->parent);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
            if (p->state == ZOMBIE)
                wakeup1(initproc);
        }
    }

    //"round up" rtime in case process ran less than 1 tick
    if(curproc->lastRtime == curproc->rtime)
        curproc->rtime++;
    curproc->lastRtime=curproc->rtime;      //save the rtime for the next time the process's done with the cpu
    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
    //added task2
    curproc->etime = ticks;
   
    sched();
    panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                return pid;
            }
        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }
}

//added task2
int
wait2(int pid, int *wtime, int *rtime, int *iotime) {
    struct proc *p;
    int havekids;//, pid;
    struct proc *curproc = myproc();

    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->pid == pid && p->state == ZOMBIE) {
                // Found one.
                //pid = p->pid;
                kfree(p->kstack);
                p->kstack = 0;
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                //changes for task2
                *rtime = p->rtime;
                *iotime = p->iotime;
                *wtime = p->etime - p->ctime - p->iotime - p->rtime;
                return pid;
            }

        }

        // No point waiting if we don't have any children.
        if (!havekids || curproc->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    }

}

//added task3.4
int
set_priority(int priority) {
    if (priority > 3 || priority < 1)   //bad priority
        return -1;
    else {
        //struct cpu *c = mycpu();  //current proc
        //c->proc->priority =priority;
        struct proc *curproc = myproc();
        curproc->priority = priority;
    }
    return 0;
}
int
getRunTimeRatio(struct proc *p) {
    if(p==0)
        cprintf("REALLY SHOULD NOT HAPPE\n");
    //TODO: return double?
    int toReturn = 0;
    int wtime = ticks - p->ctime - p->iotime - p->rtime;
    int decay_factor = 0;
    if (p->priority == 1)          //high priority
        decay_factor = 0.75;
    else if (p->priority == 2)     //normal priority
        decay_factor = 1;
    else                        //low priority
        decay_factor = 1.25;
    toReturn = (p->rtime * decay_factor) / (p->rtime + wtime);

    cprintf("getRunTimeRatio returns: %d\n",toReturn);
    return toReturn;
}
//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
    struct proc *p;
    struct cpu *c = mycpu();
    c->proc = 0;

    for (;;) {
        // Enable interrupts on this processor.
        sti();

        // Loop over process table looking for process to run.
        acquire(&ptable.lock);

#ifdef DEFAULT
        //cprintf("IN DEFAULT");
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
          if(p->state != RUNNABLE)
            continue;

          // Switch to chosen process.  It is the process's job
          // to release ptable.lock and then reacquire it
          // before jumping back to us.
          c->proc = p;
          switchuvm(p);
          p->state = RUNNING;

          swtch(&(c->scheduler), p->context);
          switchkvm();

          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
        }
#else
#ifdef FCFS
        //cprintf("IN FCFS");
        //FCFS POLICY
        if(pq.processes[0]!=0) {
            p = dequeue();
            c->proc = p;  //dequeue a process
            switchuvm(p);
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }

#else

#ifdef SRT
        struct proc* minimal=0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
             if(p->state==RUNNABLE) {
                 if (minimal == 0 || (p->AI - p->rtime) < (minimal->AI - minimal->rtime)) {
                     minimal = p;
                 }
             }
         }
        //----------------context switch
        if(minimal!=0){       //in case no RUNNABLE processes yet
            c->proc = minimal;
            switchuvm(minimal);
            minimal->state = RUNNING;
            swtch(&(c->scheduler), minimal->context);
            switchkvm();
            c->proc = 0;
        }
        //------------------------------
#else

#ifdef CFSD
        struct proc *minimal = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->state == RUNNABLE) { 
                if (minimal == 0 || getRunTimeRatio(p) < getRunTimeRatio(minimal)) {
                    minimal = p;
                }
            }
        }
        if(minimal==0){
            cprintf("SHOULD NOT HAPPEN\n");
        }
        //----------------context switch
        if(minimal!=0){      //in case no RUNNABLE processes yet
            c->proc = minimal;
            switchuvm(minimal);
            minimal->state = RUNNING;
            swtch(&(c->scheduler), minimal->context);
            switchkvm();
            c->proc = 0;
        }
        //------------------------------

#endif
#endif
#endif
#endif
        release(&ptable.lock);

    }
}


// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.


void
sched(void) {
    int intena;
    struct proc *p = myproc();

    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (p->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&p->context, mycpu()->scheduler);
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
    acquire(&ptable.lock);  //DOC: yieldlock
    struct proc *p = myproc();
    p->state = RUNNABLE;
    //"round up" rtime in case process ran less than 1 tick
    if(p->lastRtime == p->rtime)
        p->rtime++;
    p->lastRtime=p->rtime;      //save the rtime for the next time the process's done with the cpu
    if (p->rtime >= p->AI)
        p->AI = p->AI + ALPHA * (p->AI);
    p->trem=QUANTUM;            //reset the ticks remaining

#ifdef FCFS
    enqueue(myproc());
#endif

    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    struct proc *p = myproc();

    if (p == 0)
        panic("sleep");

    if (lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {  //DOC: sleeplock0
        acquire(&ptable.lock);  //DOC: sleeplock1
        release(lk);
    }
    // Go to sleep.
    p->chan = chan;
    p->state = SLEEPING;
    //"round up" rtime in case process ran less than 1 tick
    if(p->lastRtime == p->rtime)
        p->rtime++;
    p->lastRtime=p->rtime;      //save the rtime for the next time the process's done with the cpu
    if (p->rtime >= p->AI)
        p->AI = p->AI + ALPHA * (p->AI);
    p->trem=QUANTUM;            //reset the ticks remaining
    sched();

    // Tidy up.
    p->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == SLEEPING && p->chan == chan) {
            p->state = RUNNABLE;
#ifdef FCFS
            enqueue(p);
#endif

        }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
    struct proc *p;

    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
                p->state = RUNNABLE;
#ifdef FCFS
                enqueue(p);
#endif
            }
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
    static char *states[] = {
            [UNUSED]    "unused",
            [EMBRYO]    "embryo",
            [SLEEPING]  "sleep ",
            [RUNNABLE]  "runble",
            [RUNNING]   "run   ",
            [ZOMBIE]    "zombie"
    };
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->state == SLEEPING) {
            getcallerpcs((uint *) p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}

//update the process' time variables (rtime and iotime)
//
void
updatetime() {
    acquire(&ptable.lock);
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
//        if (p->state == RUNNING) {
//            runningCounter++;
//            p->rtime++; //increase runtime.
//            if(p->trem==0)
//                cprintf("ERROR-trem is: %d, pid: %d\n",p->trem,p->pid);
//            p->trem--;
//        }

        if (p->state == SLEEPING) {
            p->iotime++;
        }
    }
    if(myproc()!=0) {
        myproc()->rtime++;
        myproc()->trem--;
    }
    release(&ptable.lock);
}