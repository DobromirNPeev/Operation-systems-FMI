#include <stdio.h>
#include <err.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"invalid number of args");
        }
        int n=atoi(argv[1]);
        int d=atoi(argv[2]);
        if(n<0 || n>9 || d<0 || d>9){
                errx(2,"not a number");
        }
        int parentToChild[2];
        if(pipe(parentToChild)==-1){
                err(3,"pipe error");
        }

        int childToParent[2];
        if(pipe(childToParent)==-1){
                err(3,"pipe error");
        }

        int pid=fork();
        if(pid==-1){
                err(4,"fork error");
        }
        if(pid==0){
                close(parentToChild[1]);
                close(childToParent[0]);
                char c;
                ssize_t readSize;
                while((readSize=read(parentToChild[0],&c,sizeof(c)))>0){
                        dprintf(1,"DONG\n");
                        if(write(childToParent[1],&c,sizeof(c))==-1){
                                err(5,"write error");
                        }
                }
                if(readSize==-1){
                        err(6,"read error");
                }
                close(parentToChild[0]);
                close(childToParent[1]);
                exit(0);
        }
        close(parentToChild[0]);
        close(childToParent[1]);
        for(int i=0;i<n;i++){
                dprintf(1,"DING ");
                char c='!';
                if(write(parentToChild[1],&c,sizeof(c))==-1){
                        err(5,"write error");
                }
                ssize_t readSize;
                if((readSize=read(childToParent[0],&c,sizeof(c))==-1)){
                        err(6,"read error");
                }
                sleep(d);
        }
        close(parentToChild[1]);
        close(childToParent[0]);
        int stat;
        wait(&stat);
        if(!WIFEXITED(stat)){
                err(7,"child was killed");
        }
        else if(WEXITSTATUS(stat)!=0){
                err(8,"not zero");
        }

}
