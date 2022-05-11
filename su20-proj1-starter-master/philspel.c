/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

#define MAX_LENGTH 60


char* allButFirstLower(char* ch, int i) {
  char* stack;
  char* head;
  stack = malloc(sizeof(char)*i);
  head = stack;
  *stack++ = *ch++;
  i--;
  while (i != 0) {
    *stack = tolower(*ch++);
    i--; 
  }
  return head;
}

char* allToLower(char* ch, int i) {
  char* stack;
  char* head;
  stack = malloc(sizeof(char)*i);
  head = stack;
  while(i != 0) {
    *stack++ = tolower(*ch++);
    i--;
  }
  return head;
}


/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");

  fprintf(stderr, "Processing stdin\n");
  processInput();

  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s){
  char *string = (char *) s;
  int i;
  int hash_code = 0;
  for (i = 0; i < strlen(string); i++) {
    hash_code = (127 * hash_code + (int)string[i]) % 16908799;
  }
  return hash_code;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2){
  char *string1 = (char *) s1;
  char *string2 = (char *) s2;
  if (strlen(string1) != strlen(string2)) {
    return 0;
  }
  while (*string1 != '\0' && *string2 != '\0') {
    if (*(string1++) != *(string2++)) {
      return 0;
    }
  }
  return 1;
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */
void readDictionary(char *filename){

  FILE* inpfile;
  char* stack = NULL;
  char* word = NULL;
  int s_size = 60;
  int i = 0;
  int ch;

  inpfile = fopen(filename, "r");
  if (inpfile == NULL) {
    fprintf(stderr, "%s\n", "File does not exist.");
    exit(0);
  }

  stack = malloc(sizeof(char) * s_size);
  while ((ch = fgetc(inpfile)) != EOF) {
    if (i > s_size - 1) {
      s_size *= 2;
      stack = realloc(stack, s_size * sizeof(char));
    } else if (ch != '\n') {
      stack[i++] = ch;
    } else {
      stack[i++] = '\0';
      word = stack;
      insertData(dictionary, word, word);
      s_size = 60;
      i = 0;
      stack = malloc(s_size * sizeof(char));
    }
  }

  free(stack);
  fclose(inpfile);
}


/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput(){

  char* stack = NULL;
  int ch;
  int size = 60;
  int i = 0;
  char* all_but_first;
  char* all_lower;
  
  stack = malloc(sizeof(char) * size);
  while((ch = fgetc(stdin)) != EOF){

    if(!isalpha(ch)) {       //non alphabet characters as word breaks.
      if (i == 0) {
        fprintf(stdout, "%c", ch);
      } else {
        stack[i++] = '\0';
        all_but_first = allButFirstLower(stack, i);
        all_lower = allToLower(stack, i);

        if (findData(dictionary, stack) != NULL 
          || findData(dictionary, all_but_first) != NULL 
          || findData(dictionary, all_lower) != NULL) {
          fprintf(stdout, "%s", stack);
        } else {
          fprintf(stdout, "%s", stack);
          fprintf(stdout, "%s", " [sic]");
        }
        fprintf(stdout, "%c", ch);
        free(all_but_first);
        free(all_lower);
      }
      size = 60;
      i = 0;
      free(stack);
      stack = malloc(size * sizeof(char));

    } else if (i > size - 1) {
      size *= 2;
      stack = realloc(stack, size * sizeof(char));
    } else {
      stack[i++] = ch;
    }

  }
  if (i > 0) {
    stack[i++] = '\0';
    all_but_first = allButFirstLower(stack, i);
    all_lower = allToLower(stack, i);
    fprintf(stdout, "%s", stack);

    if(findData(dictionary, stack) != NULL 
      || findData(dictionary, all_but_first) != NULL
      || findData(dictionary, all_lower) != NULL) {
    free(stack);
    free(all_but_first);
    free(all_lower);

    return;

    } else {
    fprintf(stdout, "%s", " [sic]");
    free(stack);
    free(all_but_first);
    free(all_lower);
    return;
    }
  }
  free(stack);
  return;
}