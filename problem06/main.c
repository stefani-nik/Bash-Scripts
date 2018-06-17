#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <string.h>
#include <err.h>

int main(int argc, char **argv)
{
	if(argc != 2){
		errx(2, "Invalid number of parameters!");
	}

	int parallel_tasks_count = atoi(argv[1]);
	int current_tasks = 0;
	char ch;
 	char line[1024] = {0};
	char previous = ' ';
	int char_number = 0;

	while(read(0, &ch, sizeof(char)) > 0){

			if(previous == ' ' && ch == ' '){
				continue;
			}

			previous = ch;

			if(ch == '\n'){

				line[char_number] = '\0';
				char_number = 0;
				int is_processed = 0;

				while(is_processed != 1){

					if (current_tasks < parallel_tasks_count){

				   		int process_id = fork();
				   		is_processed = 1;

						if (process_id == 0){
							system(line);
							exit(0);
						}
						else if (process_id > 0){
							current_tasks++;
						}
						else{
							errx(2, "Eror");
							exit(1);
						}
					}
					else
					{
						wait(NULL);
						current_tasks--;
					}
				}

				memset(line, 0, 1024);
			    }

			else{

				line[char_number] = ch;
				char_number++;
			}
  }
  return 0;
}
