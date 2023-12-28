%option noyywrap

%{
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

int wordCount = 0;
int lineCount = 1;
int numberCount = 0;

void INCwc() {
    wordCount++;
}
void INClc() {
    lineCount++;
}
void INCnc() {
    numberCount++;
}   
%}

letter [a-zA-Z]
digit [0-9]

%%
[ \t\v]+ {}
{letter}+ {INCwc(); cout<<"word found : "<<yytext<<endl;}
{digit}+ {INCnc(); cout<<"number found : "<<yytext<<endl;}
[\n] {INClc();}
\\[\\nfratbv0\"\'] {cout<<"Escape sequence found : "<<yytext<<endl;}
<<EOF>> {cout<<"Number of words : "<<wordCount<<endl;
        cout<<"Number of lines : "<<lineCount<<endl;
        cout<<"Number of numbers : "<<numberCount<<endl;
        return 0;}
. {}
%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	

	yyin= fin;
	yylex();
	fclose(yyin);
	return 0;
}