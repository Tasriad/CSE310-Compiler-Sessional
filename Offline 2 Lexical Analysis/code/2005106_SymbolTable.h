//Creator: Tasriad Ahmed @ 2005106

#pragma once
#include <bits/stdc++.h>
#include "2005106_ScopeTable.h"
using namespace std;
class SymbolTable
{
    private:
        ScopeTable *current_scope;
        int total_buckets;
        string current_scope_id;
    public:
        //Constructors
        SymbolTable();
        SymbolTable(int total_buckets);
        //Destructor
        ~SymbolTable();
        //Functions
        void setTotalBuckets(int total_buckets);
        int getTotalBuckets() const;
        void setCurrentScope(ScopeTable *current_scope);
        ScopeTable* getCurrentScope() const;
        void setCurrentScopeId(int current_scope_id);
        string getCurrentScopeId() const;
        void EnterScope();
        void ExitScope();
        bool Insert(string symbol_name, string symbol_type);
        bool Remove(string symbol_name);
        SymbolInfo* Lookup(string symbol_name);
        void PrintCurrentScopeTable(ofstream &outfile);
        void PrintAllScopeTable(ofstream &outfile);
        //helper functions
        ScopeTable* getScopeTableOfSymbol(string symbol_name);
};