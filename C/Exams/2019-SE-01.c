#include <stdint.h>
#include <fcntl.h>
#include <stdio.h>
#include <err.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct data{
        uint32_t uid;
        uint16_t saved1;
        uint16_t saved2;
        uint32_t begin;
        uint32_t end;
}__attribute__((packed)) data;

typedef struct pair{
        uint32_t uid;
        uint32_t biggestSession;
}__attribute__((packed)) pair;

uint32_t calculateAvg(data* sessions,int size){
        uint32_t sum=0;
        for(int i=0;i<size;i++){
                if(sessions[i].begin > sessions[i].end){
                        err(6,"Invalid data");
                }
                uint32_t diff=sessions[i].end-sessions[i].begin;
                sum+=diff;
        }
        return (sum/size);
}

uint32_t calculateDispersion(data* sessions,int size,uint32_t avg){
        uint32_t disp=0;
        for(int i=0;i<size;i++){
                uint32_t diff=((sessions[i].end-sessions[i].begin)-avg);
                disp+=diff*diff;
        }
        return (disp/size);
}

int compareData(const void* lhs,const void* rhs){
        const data* a=(const data*)lhs;
        const data* b=(const data*)rhs;

        return a->uid - b->uid;
}

int main(int argc,char* argv[]){
        if(argc!=2){
                errx(1,"Invalid number of arguments");
        }
        int fd=open(argv[1],O_RDONLY);
        if(fd==-1){
                err(2,"Open error");
        }
        struct stat st;
        if(fstat(fd,&st)==-1){
                err(3,"Stat error");
        }
        if(st.st_size%sizeof(data)!=0){
                errx(4,"Invalid format");
        }
        int sessionsCount=st.st_size/sizeof(data);
        data sessions[16384];
        for(int i=0;i<sessionsCount;i++){
                if(read(fd,&sessions[i],sizeof(sessions[i]))==-1){
                        err(5,"Read error");
                }
        }
        qsort(sessions,sessionsCount,sizeof(data),compareData);
        uint32_t avg=calculateAvg(sessions,sessionsCount);
        uint32_t disp=calculateDispersion(sessions,sessionsCount,avg);
        pair users[2048]={{0,0}};
        size_t counter=0;
        for(int i=0;i<sessionsCount;i++){
                users[counter].uid=sessions[i].uid;
                while(sessions[i].uid==users[counter].uid){
                        uint32_t dur=sessions[i].end-sessions[i].begin;
                        if(dur*dur>disp){
                                if(users[counter].biggestSession<dur){
                                        users[counter].biggestSession=dur;
                                }
                        }
                        i++;
                }
                counter++;
        }
        for(size_t i=0;i<counter;i++){
                if(users[i].biggestSession>0){
                        dprintf(1,"%d %d\n",users[i].uid,users[i].biggestSession);
                }
        }
        close(fd);
}
