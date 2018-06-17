#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

int binarySearch(int fd, char* word, int low, int high);
char readChar(int fd, int pos);


int main(int argc,char *argv[]){

	if(argc < 3){
		printf("Invalid number of parameters!\nFirst enter a dictionary file and than a word!\n");
		exit(1);
	}

	int filedesc = open(argv[1], O_RDONLY);

	if(filedesc < 0){
		printf("Error opening dictionary file!\n");
		exit(1);
	}

	int file_start = 0;
	int file_end = lseek(filedesc, 0, SEEK_END);

	int word_pos = binarySearch(filedesc, argv[2], file_start, file_end);

	if(word_pos == -1){
		printf("The word is not in the dictionary!\n");
		exit(1);
	}

	char desc = readChar(filedesc, ++word_pos);

	while(desc != '\0'){
		printf("%c", desc);
		word_pos++;
		desc = readChar(filedesc, word_pos);
	}


	if(close(filedesc) < 0){
		printf("Error closing dictionary file!\n");
		exit(1);
	}
}


int binarySearch(int fd, char* word, int low, int high) {

	if(word[0] == 'a' && word[1] == '\0')
		return 1;

	if (low < high) {
		int len = 0;
		int mid = (low + high) / 2;
	        int next = mid;
		char current = readChar(fd,next);

		while(current != '\0'){
			current = readChar(fd, next);
			next++;
		}

		while(word[len] != '\0'){

			current = readChar(fd, next);

			if (word[len] < current) {

				return binarySearch(fd, word, low, mid - 1);
			} else if (word[len] > current){

				return binarySearch(fd, word, mid + 1 , high);
			}

			len++;
			next++;
		}

		current = readChar(fd, next);

		if(current == '\n'){
			return next;
		}

		if(current != '\n'){
			return binarySearch(fd, word, low, mid - 1);
		}

	}

	return -1;
}

char readChar(int fd, int pos){

	char buff[1];

	int current = lseek(fd, pos, SEEK_SET);

	if(current < 0){
		printf("Error seeking in dictionary file!\n");
		exit(1);
	}

	int bytes = read(fd, buff, 1);

	if (bytes < 0){
		printf("Error reading from dictionary file!\n");
		exit(1);
	}

	return buff[0];
}
