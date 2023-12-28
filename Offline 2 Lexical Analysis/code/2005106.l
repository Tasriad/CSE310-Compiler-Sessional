%option noyywrap

/* custom states */

%x COMMENT_SINGLE_LINE COMMENT_MULTI_LINE STRING_STATE 

/* c++ code section */

%{
    #include <bits/stdc++.h>
    #include "2005106_SymbolTable.h"
    using namespace std;

    //symbol table
    int bucketSize = 10;
    SymbolTable symbolTable(bucketSize);

    //counters
    int lineCount = 1;
    int keywordCount = 0;
    int identifierCount = 0;
    int errorCount = 0;
    int warningCount = 0;

    //extra variables
    int errorLine = 0;
    int stringStart = 0;
    int commentStart = 0;

    //strings and comments
    string literalStr = "";
    string logStr = "";
    string logCommentStr = "";
    string errorStr = "";

    //flags
    bool isMultiLineString = false;
    bool isExtendedComment = false;
    bool shouldCountSpace = false;

    //indenration level
    string indenrationLevel = "";
    string tab = "";
    string space = "";

    //output files
    ofstream tokenfile ("2005106_token.txt");
    ofstream logfile ("2005106_log.txt");

    //helper functions
    string Uppercase(string str){
        string Ustring = str;
        transform(Ustring.begin(), Ustring.end(), Ustring.begin(), ::toupper);
        return Ustring;
    }
    void printToken(string token, string lexeme){
        token = Uppercase(token);
        if(token == "STRING"){
            if(isMultiLineString){
                token = "MULTI LINE STRING";
            }
            else{
                token = "SINGLE LINE STRING";
            }
        }
        tokenfile <<"<" << token << ", " << lexeme << ">" << endl;
    }
    void writeLog(string token, string lexeme){
        int lineNo = lineCount;
        token = Uppercase(token);
        if(token == "STRING"){
            if(isMultiLineString){
                token = "MULTI LINE STRING";
                lineNo = stringStart;
            }
            else{
                token = "SINGLE LINE STRING";
            }
        }
        else if(token == "SINGLE LINE COMMENT" or token == "MULTI LINE COMMENT"){
            lineNo = commentStart;
        }
        logfile << "Line# "<< lineNo <<": "<<"Token "<<"<" << token <<"> " <<"Lexeme " <<lexeme<<" found" << endl;
    }
    void countLog(){
        logfile << "Total lines: " << lineCount << endl;
        logfile << "Total errors: " << errorCount << endl;
        logfile << "Total warnings: " << warningCount << endl;
    }
    void errorPrint(int line, string message, string lexeme){
        logfile << "Error at line# "<< line <<": "<< message <<" "<<lexeme<< endl;
    }
    void addToString(string str){
        literalStr.append(str);
    }
    void clearString(){
        literalStr = "";
        logStr = "";
        stringStart = 0;
    }
    void clearComment(){
        logCommentStr = "";
        commentStart = 0;
    }
    void clearError(){
        errorStr = "";
    }
    void clearWaring(){
        tab = "";
        space = "";
        cout<<"Clearing tabs and spaces/////////////////////////////////////////line count: "<<lineCount<<endl;
    }
    void printTabWarning(int needed, int found){
        warningCount++;
        logfile << "Line# "<< lineCount <<": "<<"warning, "<<needed<<" of tabs needed but got "<<found<<" tabs."<<endl;
    }
    void printSpaceWarning(){
        warningCount++;
        logfile << "Line# "<< lineCount <<": "<<"Warning, tab requrired but got space."<<endl;
    }
    void printWarning(){
        if(shouldCountSpace){
        if(tab.size()!=indenrationLevel.size() or space.size()%4!=0){
            if(space.size()%4!=0){
                printSpaceWarning();
                cout<<"printing space warning/////////////////////////////////////////line count: "<<lineCount<<endl;
            }
            else{
                printTabWarning(indenrationLevel.size(), tab.size());
                cout<<"printing tab warning/////////////////////////////////////////line count: "<<lineCount<<endl;
            }
        }
        clearWaring();
        }
    }
    string removeQuotes(const string& input) {
    if (input.size() >= 2 && input.front() == '\'' && input.back() == '\'') {
        return input.substr(1, input.size() - 2);
    }
    return input; // Return unchanged if not surrounded by quotes
}

    
%}

/* regular expressions declarations */
AlphaNumeric [a-zA-Z0-9]
Digit [0-9]
Identifier [a-zA-Z_][a-zA-Z_0-9]*
WhiteSpace [\v\f\r]+
NewLine [\n]
ConstInt {Digit}+
ConstFloat ({Digit}+\.?{Digit}*|\.{Digit}+)([Ee][+-]?{Digit}+)?
ConstChar \'((\\\")|(\\n)|(\\t)|(\\\\)|(\\\')|(\\a)|(\\f)|(\\r)|(\\b)|(\\v)|(\\0)|{AlphaNumeric})\'
Keyword if|else|for|while|do|break|int|char|float|double|void|return|switch|case|default|continue
RedundantDecimal {Digit}*(\.)({Digit}*(\.){Digit}+)+([Ee][+-]?{Digit}+)?
IllFormedNumber  {Digit}+\.?{Digit}*([Ee][+-]?){Digit}*\.{Digit}+
InvalidPrefix    {Digit}+{Identifier}
MultiCharError   \'[^'\n]{2,}\'
EmptyCharacter    \'\'
UnfinishedConstChar \'[^'\n]*
UnfinishedConstChar2 '\\'

/* rules */
%%
{NewLine} {
    clearWaring();
    lineCount++;
    shouldCountSpace = true;
}

[\t]+ {
    if(shouldCountSpace){
        tab.append(yytext);
        cout<<"append to tabs///////////////////////////////////////////line count: "<<lineCount<<" tabs counted: "<<tab.size()<<" indentation level: "<<indenrationLevel.size()<<endl;
    }
}
[ ]+ {
    if(shouldCountSpace){
        space.append(yytext);
        cout<<"append to spaces/////////////////////////////////////////line count: "<<lineCount<<" space counted: "<<space.size()<<" indentation level: "<<indenrationLevel.size()<<endl;
    }
}
{WhiteSpace} { /* ignore */ }

{Keyword} {
    printWarning();
    printToken(yytext, yytext);
    writeLog(yytext, yytext);
    keywordCount++;
    shouldCountSpace=false;
}

{ConstInt} {
    printWarning();
    printToken("CONST_INT", yytext);
    writeLog("CONST_INT", yytext);
    shouldCountSpace=false;
}
{ConstFloat} {
    printWarning();
    printToken("CONST_FLOAT", yytext);
    writeLog("CONST_FLOAT", yytext);
    shouldCountSpace=false;
}
{RedundantDecimal} {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "TOO_MANY_DECIMAL_POINTS", yytext);
    shouldCountSpace=false;
}
{IllFormedNumber} {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "ILLFORMED_NUMBER", yytext);
    shouldCountSpace=false;
}
{InvalidPrefix} {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "INVALID_ID_SUFFIX_NUM_PREFIX", yytext);
    shouldCountSpace=false;
}
{EmptyCharacter} {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "EMPTY_CONST_CHAR", yytext);
    shouldCountSpace=false;
}
{UnfinishedConstChar2} {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "UNFINISHED_CONST_CHAR", yytext);
    shouldCountSpace=false;
}
{UnfinishedConstChar} {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "UNFINISHED_CONST_CHAR", yytext);
    shouldCountSpace=false;
}
{ConstChar} {
    printWarning();
    shouldCountSpace=false;
    string temp;
    if(yyleng == 3)
    {
        if(yytext[1] == '\\'){
            errorCount++;
            errorPrint(lineCount, "UNFINISHED_CONST_CHAR", yytext);
        }
        else{
        temp = removeQuotes(yytext);
        printToken("CONST_CHAR", temp);
        writeLog("CONST_CHAR", temp);
        }
    }
    else if(yyleng == 4)
    {
        if(yytext[1] == '\\')
        {
            switch(yytext[2]){
			case 'n' : temp = '\n'; break;
			case 't' : temp = '\t'; break;
			case 'a' : temp = '\a'; break;
			case 'b' : temp = '\b'; break;
			case 'r' : temp = '\r'; break;
			case 'f' : temp = '\f'; break;
			case 'v' : temp = '\v'; break;
            case '0' : temp = '\0'; break;
            case '\\' : temp = '\\'; break;
            case '\'' : temp = '\''; break;
            case '\"' : temp = '\"'; break;
            default : errorCount++; errorPrint(lineCount, "MULTICHAR_CONST_CHAR", yytext); break;
            }
    printToken("CONST_CHAR", temp);
    writeLog("CONST_CHAR", temp);
        }
    }
    else
    {
        errorCount++;
        errorPrint(lineCount, "MULTICHAR_CONST_CHAR", yytext);
    }
}
{MultiCharError} {

    printWarning();
    shouldCountSpace=false;
    errorCount++;
    errorPrint(lineCount, "MULTICHAR_CONST_CHAR", yytext);
}
"//" {
    printWarning();
    shouldCountSpace=false;
    BEGIN COMMENT_SINGLE_LINE;
    cout<<"single line comment state begin"<<endl;
    logCommentStr.append(yytext);
    errorLine = lineCount;
    commentStart = lineCount;
    }
<COMMENT_SINGLE_LINE>[\r] {/*ignore*/}  
<COMMENT_SINGLE_LINE>{NewLine} {
    cout<<"The last character of comment: "<<logCommentStr[logCommentStr.size()-1]<<"  ASCII:"<<static_cast<int>(logCommentStr[logCommentStr.size()-1])<<endl;
    if(logCommentStr[logCommentStr.size()-1] == '\\'){
        cout<<"Single Line comment extended."<<endl;
        lineCount++;
        logCommentStr.append("\n");
    }
    else{
    lineCount++;
    writeLog("SINGLE LINE COMMENT", logCommentStr);
    clearComment();
    cout<<"single line comment state end"<<endl;
    BEGIN INITIAL;
    }
}
<COMMENT_SINGLE_LINE><<EOF>> {
    writeLog("SINGLE LINE COMMENT", logCommentStr);
    clearComment();
    cout<<"single line comment state end"<<endl;
    BEGIN INITIAL;
}
<COMMENT_SINGLE_LINE>. {
    logCommentStr.append(yytext);
    cout<<"Appending "<<yytext<<" to single line comment string"<<endl;
} 
"/*" {
    printWarning();
    shouldCountSpace=false;
    BEGIN COMMENT_MULTI_LINE;
    cout<<"multi line comment state begin"<<endl;
    logCommentStr.append(yytext);
    errorLine = lineCount;
    commentStart = lineCount;
    }
<COMMENT_MULTI_LINE>[\r] {/*ignore*/}
<COMMENT_MULTI_LINE>{NewLine} {
    logCommentStr.append(yytext);
    lineCount++;
} 
<COMMENT_MULTI_LINE>"*/" {
    logCommentStr.append(yytext);
    writeLog("MULTI LINE COMMENT", logCommentStr);
    clearComment();
    cout<<"multi line comment state end"<<endl;
    BEGIN INITIAL;
}
<COMMENT_MULTI_LINE><<EOF>> {
    errorCount++;
    errorPrint(lineCount, "UNFINISHED_COMMENT",logCommentStr);
    clearComment();
    cout<<"multi line comment state end"<<endl;
    BEGIN INITIAL;
}
<COMMENT_MULTI_LINE>. {
    logCommentStr.append(yytext);
    cout<<"Appending "<<yytext<<" to multiline comment string"<<endl;
} 

"+"|"-"     {printWarning();printToken("ADDOP", yytext);writeLog("ADDOP", yytext);shouldCountSpace=false;}
"*"|"/"|"%" {printWarning();printToken("MULOP", yytext);writeLog("MULOP", yytext);shouldCountSpace=false;}
"++"|"--"   {printWarning();printToken("INCOP", yytext);writeLog("INCOP", yytext);shouldCountSpace=false;}
"<"|"<="|">"|">="|"=="|"!=" {printWarning();printToken("RELOP", yytext);writeLog("RELOP", yytext);shouldCountSpace=false;}
"&"|"|"|"^"|"<<"|">>" {printWarning();printToken("BITOP", yytext);writeLog("BITOP", yytext);shouldCountSpace=false;}
"="         {printWarning();printToken("ASSIGNOP", yytext);writeLog("ASSIGNOP", yytext);shouldCountSpace=false;}
"&&"|"||"   {printWarning();printToken("LOGICOP", yytext);writeLog("LOGICOP", yytext);shouldCountSpace=false;}
"!"         {printWarning();printToken("NOT", yytext);writeLog("NOT", yytext);shouldCountSpace=false;}
"("         {printWarning();printToken("LPAREN", yytext);writeLog("LPAREN", yytext);shouldCountSpace=false;}
")"         {printWarning();printToken("RPAREN", yytext);writeLog("RPAREN", yytext);shouldCountSpace=false;}
"{"         {printWarning();printToken("LCURL", yytext);writeLog("LCURL", yytext);shouldCountSpace=false;
             symbolTable.EnterScope();
             indenrationLevel.push_back('\t');
             cout<<"Pushing a tab/////////////////////////////////line count: "<<lineCount<<" indentation level: "<<indenrationLevel.size()<<endl;
            }
"}"         {indenrationLevel.pop_back();  
             printWarning();
             shouldCountSpace=false;
             printToken("RCURL", yytext);writeLog("RCURL", yytext);
             symbolTable.ExitScope();
             cout<<"Popping a tab/////////////////////////////////line count: "<<lineCount<<" indentation level: "<<indenrationLevel.size()<<endl;
            }
"["         {printWarning();printToken("LSQUARE", yytext);writeLog("LSQUARE", yytext);shouldCountSpace=false;}
"]"         {printWarning();printToken("RSQUARE", yytext);writeLog("RSQUARE", yytext);shouldCountSpace=false;}
","         {printWarning();printToken("COMMA", yytext);writeLog("COMMA", yytext);shouldCountSpace=false;}
";"         {printWarning();printToken("SEMICOLON", yytext);writeLog("SEMICOLON", yytext);shouldCountSpace=false;}

{Identifier} {
    printWarning();
    shouldCountSpace=false;
    printToken("ID", yytext);
    writeLog("ID", yytext);
    bool isInserted = symbolTable.Insert(yytext,"ID");
    if(isInserted){
        symbolTable.PrintAllScopeTable(logfile);
    }
    else
    {
        logfile<<"	"<<yytext<<" already exists in the current ScopeTable"<<endl;
    }
    identifierCount++;
}
\" {
    printWarning();
    shouldCountSpace=false;
    BEGIN STRING_STATE;
    errorLine = lineCount;
    stringStart = lineCount;
    logStr.append(yytext);
    errorStr.append(yytext);
    cout<<"Entering STRING state"<<endl;
}
<STRING_STATE>[\r] {/*ignore*/}
<STRING_STATE>{NewLine} {
    cout<<"The last character: "<<literalStr[literalStr.size()-1]<<"  ASCII:"<<static_cast<int>(literalStr[literalStr.size()-1])<<endl;
    if(literalStr[literalStr.size()-1] == '\\'){
        isMultiLineString = true;
        cout<<"Multi line string detected"<<endl;
        lineCount++;
        errorLine = lineCount;
        if(!literalStr.empty()){
            literalStr.pop_back();
        }
        logStr.append("\n");
        errorStr.append("\n");
    }
    else{
    clearString();
    lineCount++;
    errorCount++;
    errorPrint(errorLine, "UNFINISHED_STRING",errorStr);
    clearError();
    BEGIN INITIAL;
    }
}
<STRING_STATE><<EOF>> {
    errorCount++;
    errorPrint(errorLine, "UNFINISHED_STRING.",errorStr);
    countLog();
    BEGIN INITIAL;
}
<STRING_STATE>(\\[\\nfratbv0\"\']) {
        logStr.append(yytext);
        errorStr.append(yytext);
        	switch(yytext[1]){
			case 'n' : literalStr.push_back('\n'); break;
			case 't' : literalStr.push_back('\t'); break;
			case 'a' : literalStr.push_back('\a'); break;
			case 'b' : literalStr.push_back('\b'); break;
			case 'r' : literalStr.push_back('\r'); break;
			case 'f' : literalStr.push_back('\f'); break;
			case 'v' : literalStr.push_back('\v'); break;
			case '0' : literalStr.push_back('\0'); break;
			case '\\' : literalStr.push_back('\\'); break;
			case '\'' : literalStr.push_back('\''); break;
			case '\"' : literalStr.push_back('\"'); break;
			

		}	
}
<STRING_STATE>[ \t]+ {
    if(isMultiLineString){
    logStr.append(yytext);
    errorStr.append(yytext);
    literalStr.append(yytext);
    }
    else
    {
    logStr.append(yytext);
    errorStr.append(yytext);
    literalStr.append(yytext);
    }
}
<STRING_STATE>\" {
    logStr.append(yytext);
    printToken("STRING", literalStr);
    writeLog("STRING", logStr);
    isMultiLineString = false;
    clearString();
    clearError();
    cout<<"Exiting STRING state"<<endl;
    BEGIN INITIAL;
}
<STRING_STATE>. {
    literalStr.append(yytext);
    logStr.append(yytext);
    errorStr.append(yytext);
    cout<<"Appending "<<yytext<<" to literal string"<<endl;
}
. {
    printWarning();
    errorCount++;
    errorPrint(lineCount, "UNRECOGNIZED_CHAR", yytext);
    shouldCountSpace=false;
}
<<EOF>> {
    shouldCountSpace=false;
    symbolTable.PrintAllScopeTable(logfile);
    countLog();
    exit(0);
}
%%

/* c code section*/
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


