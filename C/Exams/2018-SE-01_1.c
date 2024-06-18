#include <unistd.h>
#include <err.h>
#include <sys/wait.h>

int main(int argc,char* argv[]){

        if(argc!=2){
                errx(3,"invalid number of args");
        }

        char* dir=argv[1];

        int find[2];
        if(pipe(find)==-1){
                err(1,"pipe error");
        }

        int pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }

        if (pid==0){
                close(find[0]);
                dup2(find[1],1);
                close(find[1]);
                execlp("find","find",dir,"-type","f","-printf","%T@ %f\n",(char *)NULL);
                err(4,"exec error");
        }
        close(find[1]);
        int sort[2];
        if(pipe(sort)==-1){
                err(1,"pipe error");
        }

        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                dup2(find[0],0);
                close(find[0]);
                dup2(sort[1],1);
                close(sort[1]);
                execlp("sort","sort","-n","-t"," ","-k","1",(char *)NULL);
                err(4,"exec error");
        }

        close(sort[1]);

        int tail[2];
        if(pipe(tail)==-1){
                err(1,"pipe error");
        }

        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                dup2(sort[0],0);
                close(sort[0]);
                dup2(tail[1],1);
                close(tail[1]);
                execlp("tail","tail","-n","1",(char *)NULL);
                err(4,"exec error");
        }
        close(tail[1]);

        int cut[2];
        if(pipe(cut)==-1){
                err(1,"pipe error");
        }

        pid=fork();
        if(pid==-1){
                err(2,"fork error");
        }
        if (pid==0){
                dup2(tail[0],0);
                close(tail[0]);
                dup2(cut[1],1);
                close(cut[1]);
                execlp("cut","cut","-d"," ","-f","2",(char *)NULL);
                err(4,"exec error");
        }

        close(cut[1]);
        char c;
        ssize_t readSize;
        while((readSize=read(cut[0],&c,sizeof(c)))>0){
                write(1,&c,readSize);
        }
        if(readSize==-1){
                err(5,"read error");
        }
        int stat;
        while(wait(&stat)>0){
                if(!WIFEXITED(stat)){
                        err(6,"child was killed");
                }
                else if (WEXITSTATUS(stat)!=0){
                        err(7,"exit status not zero");
                }
        }
}
