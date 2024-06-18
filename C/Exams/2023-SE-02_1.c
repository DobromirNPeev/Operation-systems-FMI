#include <fcntl.h>
#include <stdio.h>
#include <err.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <signal.h>
#include <sys/wait.h>
#include <stdlib.h>

int main(int argc,char* argv[]){
        if(argc==1){
                errx(26,"invalid number of args");
        }
        const int n=argc;
        int p[n][2];
        int pids[n];
        for(int i=1;i<argc;i++){
                if(pipe(p[i])==-1){
                        err(26,"pipe error");
                }
                int pid=fork();
                if(pid==0){
                        close(p[i][0]);
                        if(dup2(p[i][1],1)==-1){
                                err(26,"dup2 erro");
                        }
                        close(p[i][1]);
                        execlp(argv[i],argv[i],(char*)NULL);
                        err(26,"exec error");
                }
                pids[i]=pid;
                close(p[i][1]);
        }
        bool found_it=false;
        for(int i=1;i<argc;i++){
                char buff[4096]={'\0'};
                ssize_t readSize;
                while((readSize=read(p[i][0],buff,sizeof(buff)))>0){
                        if(strcmp(buff,"found it!")==0){
                                found_it=true;
                                break;
                        }
                }
                dprintf(1,"%s\n",buff);
                if(found_it){
                        break;
                }
                if(readSize==-1){
                        err(26,"read error");
                }
        }
        if(found_it){
                for(int i=1;i<argc;i++){
                        if(kill(pids[i],SIGTERM)==-1){
                                err(4,"could not kill");
                        }
                        wait(NULL);
                }
                exit(0);
        }
        int stat;
        while(wait(&stat)>0){
                if(!WIFEXITED(stat)){
                        err(26,"child was killed");
                }
                else if(WEXITSTATUS(stat)!=0){
                        err(26,"not zero");
                }
        }
        exit(1);
}
