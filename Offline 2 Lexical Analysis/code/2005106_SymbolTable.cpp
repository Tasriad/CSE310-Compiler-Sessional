//Creator: Tasriad Ahmed @ 2005106
#include "2005106_SymbolTable.h"
//Constructors
SymbolTable::SymbolTable()
{
    current_scope = NULL;
    total_buckets = 0;
    current_scope_id = "1";
    cout << "SymbolTable Constructor1 Called" << endl;
}
SymbolTable::SymbolTable(int total_buckets)
{
    current_scope = new ScopeTable(total_buckets);
    this->total_buckets = total_buckets;
    current_scope_id = "1";
    cout << "SymbolTable Constructor2 Called" << endl;
}
//Destructor
SymbolTable::~SymbolTable()
{
    while(current_scope != NULL)
    {
        ScopeTable *temp = current_scope;
        current_scope = current_scope->getParentScope();
        delete temp;
    }
}
//Functions
void SymbolTable::setTotalBuckets(int total_buckets)
{
    this->total_buckets = total_buckets;
}
int SymbolTable::getTotalBuckets() const
{
    return total_buckets;
}
void SymbolTable::setCurrentScope(ScopeTable *current_scope)
{
    this->current_scope = current_scope;
}
ScopeTable* SymbolTable::getCurrentScope() const
{
    return current_scope;
}
void SymbolTable::setCurrentScopeId(int current_scope_id)
{
    this->current_scope_id = current_scope_id;
}
string SymbolTable::getCurrentScopeId() const
{
    return current_scope_id;
}
void SymbolTable::EnterScope()
{
    current_scope->setChildCount(current_scope->getChildCount() + 1);
    ScopeTable *new_scope = new ScopeTable(total_buckets, current_scope);
    current_scope = new_scope;
    current_scope_id = current_scope->getScopeId();
    cout << "New ScopeTable with id " << current_scope->getScopeId() << " created" << endl;
}
void SymbolTable::ExitScope()
{
    ScopeTable *temp = current_scope;
    string deleted_scope_id = current_scope->getScopeId();
    current_scope = current_scope->getParentScope();
    delete temp;
    if(current_scope != NULL)
    {
        current_scope_id = current_scope->getScopeId();
    }
    cout << "ScopeTable with id " << deleted_scope_id << " removed" << endl;
}
bool SymbolTable::Insert(string symbol_name, string symbol_type)
{
    SymbolInfo symbol(symbol_name, symbol_type);
    return current_scope->Insert(symbol);
}
bool SymbolTable::Remove(string symbol_name)
{
    return current_scope->Delete(symbol_name);
}
SymbolInfo* SymbolTable::Lookup(string symbol_name)
{
    ScopeTable *temp = current_scope;
    while(temp != NULL)
    {
        SymbolInfo *symbol = temp->Lookup(symbol_name);
        if(symbol != NULL)
        {
            return symbol;
        }
        temp = temp->getParentScope();
    }
    cout << "Not Found so returning NULL" << endl;
    return NULL;
}
void SymbolTable::PrintCurrentScopeTable(ofstream &outfile)
{
    outfile << "	ScopeTable# " << current_scope_id << endl;
    current_scope->Print(outfile);
}
void SymbolTable::PrintAllScopeTable(ofstream &outfile)
{
    ScopeTable *temp = current_scope;
    while(temp != NULL)
    {
        outfile << "	ScopeTable# " << temp->getScopeId() << endl;
        temp->Print(outfile);
        temp = temp->getParentScope();
    }
}
//helper functions
ScopeTable* SymbolTable::getScopeTableOfSymbol(string symbol_name)
{
    ScopeTable *temp = current_scope;
    while(temp != NULL)
    {
        SymbolInfo *symbol = temp->Lookup(symbol_name);
        if(symbol != NULL)
        {
            return temp;
        }
        temp = temp->getParentScope();
    }
    cout << "Not Found so returning NULL" << endl;
    return NULL;
}
