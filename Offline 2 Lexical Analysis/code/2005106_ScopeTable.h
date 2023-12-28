// Creator: Tasriad Ahmed @ 2005106
#pragma once
#include <bits/stdc++.h>
#include "2005106_SymbolInfo.h"
using namespace std;
class ScopeTable
{
private:
    SymbolInfo **scope_table; // array of SymbolInfo pointers
    ScopeTable *parent_scope; // pointer to parent scope
    int total_buckets;        // size of the array
    int child_count;          // number of child scopes
    string scope_id;          // id of the scope
public:
    // Constructors
    ScopeTable();
    ScopeTable(int table_size);
    ScopeTable(int table_size, int scope_id);
    ScopeTable(int table_size, ScopeTable *parent_scope);
    // Destructor
    ~ScopeTable();
    // Functions
    unsigned long long sdbmhash(string str);
    unsigned long long hash_function(string symbol_name); // hash function
    SymbolInfo **getScopeTable() const;
    void setScopeId(string scope_id);
    string getScopeId() const;
    void setTotalBuckets(int total_buckets);
    int getTotalBuckets() const;
    void setParentScope(ScopeTable *parent_scope);
    ScopeTable *getParentScope() const;
    void setChildCount(int child_count);
    int getChildCount() const;
    bool Insert(SymbolInfo symbol);
    SymbolInfo *Lookup(string symbol_name);
    bool Delete(string symbol_name);
    void Print(ofstream &outfile);
};