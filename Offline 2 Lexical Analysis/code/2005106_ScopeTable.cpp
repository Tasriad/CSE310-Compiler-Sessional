//Creator: Tasriad Ahmed @ 2005106
#include "2005106_ScopeTable.h"
// Constructors
ScopeTable::ScopeTable()
{
    scope_table = NULL;
    parent_scope = NULL;
    total_buckets = 0;
    child_count = 0;
    scope_id = "1";
    cout << "ScopeTable Constructor1 Called" << endl;
}
ScopeTable::ScopeTable(int table_size)
{
    scope_table = new SymbolInfo *[table_size];
    for (int i = 0; i < table_size; i++)
    {
        scope_table[i] = NULL;
    }
    parent_scope = NULL;
    total_buckets = table_size;
    child_count = 0;
    scope_id = "1";
    cout << "ScopeTable Constructor2 Called" << endl;
}
ScopeTable::ScopeTable(int table_size, int scope_id)
{
    scope_table = new SymbolInfo *[table_size];
    for (int i = 0; i < table_size; i++)
    {
        scope_table[i] = NULL;
    }
    parent_scope = NULL;
    total_buckets = table_size;
    child_count = 0;
    this->scope_id = to_string(scope_id);
    cout << "ScopeTable Constructor3 Called" << endl;
}
ScopeTable::ScopeTable(int table_size, ScopeTable *parent_scope)
{

    this->parent_scope = parent_scope;
    child_count = 0;

    if (parent_scope == NULL)
    {
        scope_id = "1";
    }
    else
    {
        scope_id = parent_scope->scope_id + "." + to_string(parent_scope->child_count);
    }
    this->total_buckets = table_size;
    scope_table = new SymbolInfo *[table_size];
    for (int i = 0; i < table_size; i++)
    {
        scope_table[i] = NULL;
    }
    cout << "ScopeTable Constructor4 Called" << endl;
}
// Destructor
ScopeTable::~ScopeTable()
{
    cout << "ScopeTable Destructor Called" << endl;
    for (int i = 0; i < total_buckets; i++)
    {
        SymbolInfo *temp = scope_table[i];
        while (temp != NULL)
        {
            SymbolInfo *temp2 = temp;
            temp = temp->next;
            delete temp2;
        }
    }
    delete[] scope_table;
}
// Functions
unsigned long long ScopeTable::sdbmhash(string str)
{
    unsigned long long hash = 0;
    int c;
    for (int i = 0; i < str.length(); i++)
    {
        c = (int)str[i];
        hash = c+ (hash << 6) + (hash << 16) - hash;
    }
    return hash%total_buckets;
}
unsigned long long ScopeTable::hash_function(string symbol_name)
{
    return sdbmhash(symbol_name) % total_buckets;
}
void ScopeTable::setScopeId(string scope_id)
{
    this->scope_id = scope_id;
}
string ScopeTable::getScopeId() const
{
    return scope_id;
}
void ScopeTable::setTotalBuckets(int total_buckets)
{
    this->total_buckets = total_buckets;
}
int ScopeTable::getTotalBuckets() const
{
    return total_buckets;
}
void ScopeTable::setParentScope(ScopeTable *parent_scope)
{
    this->parent_scope = parent_scope;
}
ScopeTable *ScopeTable::getParentScope() const
{
    return parent_scope;
}
void ScopeTable::setChildCount(int child_count)
{
    this->child_count = child_count;
}
int ScopeTable::getChildCount() const
{
    return child_count;
}
SymbolInfo **ScopeTable::getScopeTable() const
{
    return scope_table;
}
SymbolInfo *ScopeTable::Lookup(string symbol_name)
{
    unsigned long hash_value = hash_function(symbol_name);
    SymbolInfo *temp = scope_table[hash_value];
    int position = 1;
    while (temp != NULL)
    {
        if (temp->getSymbolName() == symbol_name)
        {
            cout << "Found in ScopeTable No: " << scope_id << " at position " << hash_value << "," << position << endl
                 << endl;
            return temp;
        }
        temp = temp->next;
        position++;
    }
    cout << "Not Found so returning NULL" << endl;
    return NULL;
}
bool ScopeTable::Insert(SymbolInfo symbol)
{
    string symbol_name = symbol.getSymbolName();
    string symbol_type = symbol.getSymbolType();
    if (Lookup(symbol_name) != NULL)
    {
        cout << "<" << symbol_name << "," << symbol_type << "> already exists in current ScopeTable" << endl;
        return false;
    }
    int hash_value = hash_function(symbol_name);
    SymbolInfo *temp = scope_table[hash_value];
    int position_in_chain = 1;
    // head is empty
    if (temp == NULL)
    {
        scope_table[hash_value] = new SymbolInfo(symbol_name, symbol_type);
        cout << "Inserted in ScopeTable No:" << scope_id << " at position " << hash_value << "," << position_in_chain << endl
             << endl;
        return true;
    }
    // head is not empty
    else
    {
        while (temp->next != NULL)
        {
            temp = temp->next;
            position_in_chain++;
        }
        temp->next = new SymbolInfo(symbol_name, symbol_type);
        cout << "Inserted in ScopeTable No:" << scope_id << " at position " << hash_value << "," << position_in_chain << endl
             << endl;
        return true;
    }
}
bool ScopeTable::Delete(string symbol_name)
{
    // symbol not present
    if (Lookup(symbol_name) == NULL)
    {
        cout << "<" << symbol_name << "> doesn't exist in current ScopeTable" << endl;
        return false;
    }
    unsigned long hash_value = hash_function(symbol_name);
    SymbolInfo *temp = scope_table[hash_value];
    // symbol present at head and no other symbols in chain
    if (temp->getSymbolName() == symbol_name && temp->next == NULL)
    {
        scope_table[hash_value] = NULL;
        delete temp;
        cout << "Deleted entry at " << hash_value << ",0 from current ScopeTable" << endl
             << endl;
        return true;
    }
    // symbol present at head and other symbols present in chain
    else if (temp->getSymbolName() == symbol_name && temp->next != NULL)
    {
        scope_table[hash_value] = temp->next;
        delete temp;
        cout << "Deleted entry at " << hash_value << ",0 from current ScopeTable" << endl
             << endl;
        return true;
    }
    // symbol present in chain but not at head
    else
    {
        int position_in_chain = 1;
        while (temp->next->getSymbolName() != symbol_name)
        {
            temp = temp->next;
            position_in_chain++;
        }
        SymbolInfo *temp2 = temp->next;
        if (temp->next->next != NULL)
        {
            temp->next = temp->next->next;
        }
        // symbol present at tail
        else
        {
            temp->next = NULL;
        }
        delete temp2;
        cout << "Deleted entry at " << hash_value << "," << position_in_chain << " from current ScopeTable" << endl
             << endl;
        return true;
    }
}
void ScopeTable::Print(ofstream &outfile)
{
    // cout << "ScopeTable # " << scope_id << endl;
    for (int i = 0; i < total_buckets; i++)
    {
        SymbolInfo *temp = scope_table[i];
        if (temp != NULL)
        {
            outfile <<"	"<< i+1 << " --> ";
            while (temp != NULL)
            {
                outfile << "(" << temp->getSymbolName() << "," << temp->getSymbolType() << ")";
                temp = temp->next;
                if(temp != NULL)
                {
                    outfile << " --> ";
                }
            }
            outfile << endl;
        }
        else
        {
            outfile<<"	" << i+1 << endl;
        }
    }
    cout << endl;
}
