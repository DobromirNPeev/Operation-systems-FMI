#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/wait.h>

char L[3][4]={"tic","tac","toe\n"};

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"invalid number of args");
        }

        int nc=atoi(argv[1]);
        int wc=atoi(argv[2]);

        if(nc<1 || nc>7 || wc<1 || wc>35){
                errx(8,"invalid number");
        }
        int pipes[nc+1][2];

        for(int i=0;i<nc+1;i++){
                        if(pipe(pipes[i])==-1){
                                err(3,"pipe error");
                        }
        }
                for(int i=0;i<nc;i++){
                        int pid=fork();
                        if(pid==-1){
                                err(2,"error fork");
                        }
                        if(pid==0){
                                for(int j=0;j<nc+1;j++){
                                        if(j==i){
                                                close(pipes[j][1]);
                                                close(pipes[j+1][0]);
                                                j++;
                                                continue;
                                        }
                                        close(pipes[j][1]);
                                        close(pipes[j][0]);
                                }
                                int count;
                                ssize_t readSize;
                                while((readSize=read(pipes[i][0],&count,sizeof(count)))>0){
                                        if(count==wc){
                                                close(pipes[i][0]);
                                                exit(0);
                                        }
                                        dprintf(1,"%s",L[count%3]);
                                        count++;
                                        if(write(pipes[i+1][1],&count,sizeof(count))==-1){
                                                err(4,"write error");
                                        }
                                }
                                if(readSize==-1){
                                        err(5,"read error");
                                }
                                close(pipes[i][0]);
                                close(pipes[i+1][1]);
                                exit(0);
                        }
                }
                for(int i=1;i<nc;i++){
                        close(pipes[i][1]);
                        close(pipes[i][0]);
                }
                int count=1;
                        ssize_t readSize;
                        dprintf(1,"%s",L[0]);
                        close(pipes[0][0]);
                        close(pipes[nc][1]);
                        if(write(pipes[0][1],&count,sizeof(count))==-1){
                                err(4,"write erro");
                        }

                        while((readSize=read(pipes[nc][0],&count,sizeof(count)))>0){
                                if(count==wc){
                                        break;
                                }
                                if(write(pipes[0][1],&count,sizeof(count))==-1){
                                        err(4,"write erro");
                                }
                        }

                                if(readSize==-1){
                                        err(5,"read error");
                                }
                close(pipes[nc][0]);
                close(pipes[0][1]);

                int stat;
                while(wait(&stat)>0){
                        if(!WIFEXITED(stat)){
                                err(6,"child was killed");
                        }
                        else if(WEXITSTATUS(stat)!=0){
                                err(7,"not zero exit status");
                        }
                }
}
