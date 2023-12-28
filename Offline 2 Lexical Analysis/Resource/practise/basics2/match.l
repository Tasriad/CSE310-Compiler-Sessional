%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
using namespace std;
%}

Alphanumeric [a-zA-Z0-9]

%%
[ \t\n]+ {}
[A-Z]{3} {cout<<yytext<<" matched in [A-Z]{3} rule"<<endl;}
[a]* {cout<<yytext<<" matched in [a]* rule"<<endl;}
[A]* {cout<<yytext<<" matched in [A]* rule"<<endl;}
{Alphanumeric}+ {cout<<yytext<<" matched in {Alphanumeric}+ rule"<<endl;}
. {cout<<yytext<<" matched in . rule"<<endl;}
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