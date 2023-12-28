%option noyywrap
%x COMMENT_MULTI COMMENT_SINGLE
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <iostream>
    using namespace std;
%}

AlphaNumeric    [a-zA-Z0-9]
%%
{AlphaNumeric}+ {cout<<"identifier"<<endl;}
[ \t\v\n]    {}
"/*"            {BEGIN COMMENT_MULTI;cout<<"multi line comment state begin"<<endl;}
<COMMENT_MULTI>[*/]            {BEGIN 0;cout<<"multi line comment state end"<<endl;}
<COMMENT_MULTI>[ \t\v\n]    {}
<COMMENT_MULTI>{AlphaNumeric}+ {cout<<"multi line comment"<<endl;}
"//"            {BEGIN COMMENT_SINGLE;cout<<"single line comment state begin"<<endl;}
"\\\n"          {cout<<"single line comment extended"<<endl;}
<COMMENT_SINGLE>[\n]            {BEGIN 0;cout<<"single line comment state end"<<endl;}
<COMMENT_SINGLE>[ \t\v\n]    {}
<COMMENT_SINGLE>{AlphaNumeric}+ {cout<<"single line comment"<<endl;}
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

             