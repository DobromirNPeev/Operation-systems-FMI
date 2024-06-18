#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <sys/wait.h>

int main(int argc,char* argv[]){

        int cat[2];
        if(pipe(cat)==-1){
                err(1,"pipe error");
        }

        int pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                close(cat[0]);
                dup2(cat[1],1);
                close(cat[1]);
                execlp("cat","cat","/etc/passwd",(char*)NULL);
                err(3,"exec error");
        }
        close(cat[1]);
        int cut[2];
        if(pipe(cut)==-1){
                err(1,"pipe error");
        }
        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                close(cut[0]);
                dup2(cat[0],0);
                close(cat[0]);
                dup2(cut[1],1);
                close(cut[1]);
                execlp("cut","cut","-d",":","-f","7",(char*)NULL);
                err(3,"exec error");
        }

        close(cut[1]);
        int sort[2];
        if(pipe(sort)==-1){
                err(1,"pipe error");
        }
        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                close(sort[0]);
                dup2(cut[0],0);
                close(cut[0]);
                dup2(sort[1],1);
                close(sort[1]);
                execlp("sort","sort",(char*)NULL);
                err(3,"exec error");
        }

        close(sort[1]);
        int uniq[2];
        if(pipe(uniq)==-1){
                err(1,"pipe error");
        }
        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                close(uniq[0]);
                dup2(sort[0],0);
                close(sort[0]);
                dup2(uniq[1],1);
                close(uniq[1]);
                execlp("uniq","uniq","-c",(char*)NULL);
                err(3,"exec error");
        }
        close(uniq[1]);

        int sort1[2];
        if(pipe(sort1)==-1){
                err(1,"pipe error");
        }
        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                close(sort1[0]);
                dup2(uniq[0],0);
                close(uniq[0]);
                dup2(sort1[1],1);
                close(sort[1]);
                execlp("sort","sort","-t"," ","-k","1",(char*)NULL);
                err(3,"exec error");
        }
        close(sort1[1]);
        char c;
        ssize_t readSize;
        while((readSize=read(sort1[0],&c,sizeof(c)))>0){
                if(write(1,&c,readSize)==-1){
                        err(4,"write error");
                }
        }

        if(readSize==-1){
                err(5,"read error");
        }

        int stat;
        while(wait(&stat)>0){
                if(!WIFEXITED(stat)){
                        err(6,"child was killed");
                }
                else if(WEXITSTATUS(stat)!=0){
                        err(7,"exit status not zero");
                }
        }



}
