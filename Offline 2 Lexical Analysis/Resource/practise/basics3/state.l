%option noyywrap

%x MYSTATE

%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;
%}

%%
[ \t\n]+ {}
<MYSTATE>[ \t\n]+ {}

abc {
    BEGIN MYSTATE;
    cout << "MYSTATE started at "<<yytext<< endl;
    }

<MYSTATE>def {
    cout << "MYSTATE ended at "<<yytext<< endl;
    BEGIN INITIAL;
             }
<MYSTATE>. {}
[a-z]+ {cout<<"in initial state "<<yytext<<" found"<<endl;} 
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

             