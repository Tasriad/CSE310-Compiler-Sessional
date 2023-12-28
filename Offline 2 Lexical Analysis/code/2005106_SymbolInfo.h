// Creator: Tasriad Ahmed @ 2005106

#pragma once
#include <iostream>
using namespace std;

class SymbolInfo
{   
    private:
        string symbol_name;
        string symbol_type;
    public:
        SymbolInfo *next;
        //Constructors
        SymbolInfo();
        SymbolInfo(string name, string type);
        SymbolInfo(string name, string type, SymbolInfo *next);
        //Destructor
        ~SymbolInfo();
        //Functions
        void setSymbolName(string name);
        void setSymbolType(string type);
        string getSymbolName() const;
        string getSymbolType() const;

};