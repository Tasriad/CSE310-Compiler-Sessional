//Creator: Tasriad Ahmed @ 2005106
#include "2005106_SymbolInfo.h"
//Constructors
SymbolInfo::SymbolInfo()
{
    symbol_name = "";
    symbol_type = "";
    next = NULL;
    cout << "SymbolInfo Constructor1 Called" << endl;
}
SymbolInfo::SymbolInfo(string name, string type)
{
    symbol_name = name;
    symbol_type = type;
    next = NULL;
    cout << "SymbolInfo Constructor2 Called" << endl;
}
SymbolInfo::SymbolInfo(string name, string type, SymbolInfo *next)
{
    symbol_name = name;
    symbol_type = type;
    this->next = next;
    cout << "SymbolInfo Constructor3 Called" << endl;
}
//Destructor
SymbolInfo::~SymbolInfo()
{
    cout << "SymbolInfo Destructor Called" << endl;
}
//Functions
void SymbolInfo::setSymbolName(string name)
{
    symbol_name = name;
}
void SymbolInfo::setSymbolType(string type)
{
    symbol_type = type;
}
string SymbolInfo::getSymbolName() const
{
    return symbol_name;
}
string SymbolInfo::getSymbolType() const
{
    return symbol_type;
}
