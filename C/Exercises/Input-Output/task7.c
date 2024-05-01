#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <err.h>
#include <string.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        //only for files and directory from the current working directory
        struct stat s;
        //printf("%s\n",argv[argc-1]);
        if(stat(argv[argc-1],&s)==-1){
                err(1,"Stat erro");
        }
        int is_dir=S_ISDIR(s.st_mode);

        if(is_dir==-1){
                err(2,"Checking dir error");
        }
        else if(is_dir==0){
                errx(3,"Not a directory");
        }

        for(int i=1;i<argc-1;i++){
                int src=open(argv[i],O_RDONLY);
                if(src==-1){
                        err(4,"Opening error");
                }
                char dest[1024];
                strcpy(dest,argv[argc-1]);
                strcat(dest,"/");
                strcat(dest,argv[i]);
        //      printf("%s\n",dest);
                int destfd=open(dest,O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
                if(destfd==-1){
                        err(4,"Opening error");
                }
                char c;
                ssize_t readSize;

                while((readSize=read(src,&c,sizeof(c)))>0){
                        if(write(destfd,&c,readSize)==-1){
                                err(5,"Writing error");
                        }
                }
                if(readSize==-1){
                        err(6,"Reading error");
                }


                close(src);
                close(destfd);
        }
        return 0;
}
