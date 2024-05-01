#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <string.h>
#include <stdint.h>
#include <sys/stat.h>
#include <stdio.h>

int main(int argc,char* argv[]){
        if(argc!=3){
                errx(1,"Invalid number of arguments");
        }
        if(strcmp(argv[1],"--min")!=0 && strcmp(argv[1],"--max")!=0 && strcmp(argv[1],"--print")!=0){
                errx(2,"Invalid first argument");
        }
        uint16_t ans;
        if(strcmp(argv[1],"--min")==0){
                ans=UINT16_MAX;
        }
        else if(strcmp(argv[1],"--max")==0){
                ans=0;
        }

        int fd=open(argv[2],O_RDONLY);
        if(fd==-1){
                err(3,"Openning err");
        }
        uint16_t num;
        ssize_t readSize;
        struct stat s;
        if(fstat(fd,&s)==-1){
                err(4,"Status err");
        }
        if(s.st_size % sizeof(uint16_t) != 0){
                errx(5,"Invalid format");
        }

        while((readSize=read(fd,&num,sizeof(uint16_t)))>0){
                if(strcmp(argv[1],"--print")==0){
                        dprintf(1,"%d\n",num);
                }
                else if(strcmp(argv[1],"--min")==0){
                        if(num<ans){
                                ans=num;
                        }
                }
                else{
                        if(num>ans){
                                ans=num;
                        }
                }
        }

        if(readSize==-1){
                err(6,"Reading err");
        }

        if(strcmp(argv[1],"--print")!=0){
                dprintf(1,"%d\n",ans);
        }

        close(fd);
        return 0;
}
