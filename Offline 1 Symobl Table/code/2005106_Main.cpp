// Creator: Tasriad Ahmed @ 2005106
#include <bits/stdc++.h>
#include "2005106_SymbolTable.h"
using namespace std;
// Helper Functions
string insertAddress(SymbolTable &symbol_table, string symbol_name)
{
    ScopeTable *search_scope = symbol_table.getCurrentScope();
    string address = "";
    while (search_scope != NULL)
    {
        unsigned long hash_address = search_scope->hash_function(symbol_name);
        SymbolInfo *temp = search_scope->getScopeTable()[hash_address];
        int position = 1;
        while (temp != NULL)
        {
            if (temp->getSymbolName() == symbol_name)
            {
                address = "<" + to_string(hash_address + 1) + ", " + to_string(position) + ">";
                return address;
            }
            temp = temp->next;
            position++;
        }
        search_scope = search_scope->getParentScope();
    }
    return address;
}
std::size_t arrayLength(const string arr[])
{
    std::size_t length = 0;
    while (arr[length] != "")
    {
        ++length;
    }
    return length;
}
void argumentsPrinter(ofstream &outfile, string arg[])
{
    int length = arrayLength(arg);
    for (int i = 0; i < length; i++)
    {
        if (i == length - 1)
        {
            outfile << arg[i];
            break;
        }
        else
        {
            outfile << arg[i] << " ";
        }
    }
    outfile << endl;
}
// Main Function
int main()
{
    ifstream infile;
    ofstream outfile;
    infile.open("input.txt");
    outfile.open("output.txt");
    int total_buckets;
    string temp;
    getline(infile, temp);
    total_buckets = stoi(temp);
    SymbolTable symbol_table(total_buckets);
    outfile << "	ScopeTable# " << symbol_table.getCurrentScopeId() << " created" << endl;
    string command;
    int command_count = 0;
    while (infile.eof() == false)
    {
        getline(infile, command);
        istringstream iss(command);
        string arg[50];
        int i = 0;
        while (iss >> arg[i])
        {
            i++;
        }
        command_count++;
        int length = arrayLength(arg);
        if (arg[0] == "I")
        {
            string symbol_name, symbol_type;
            symbol_name = arg[1];
            symbol_type = arg[2];
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 3)
            {
                outfile << "	Wrong number of arguments for the command I" << endl;
            }
            else
            {
                if (symbol_table.Insert(symbol_name, symbol_type) == true)
                {

                    outfile << "	Inserted  at position " << insertAddress(symbol_table, symbol_name) << " of ScopeTable# " << symbol_table.getCurrentScopeId() << endl;
                }
                else
                {
                    outfile << "	'" << symbol_name << "' already exists in the current ScopeTable# " << symbol_table.getCurrentScopeId() << endl;
                }
            }
        }
        else if (arg[0] == "L")
        {
            string symbol_name;
            symbol_name = arg[1];
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 2)
            {
                outfile << "	Wrong number of arguments for the command L" << endl;
            }
            else
            {
                SymbolInfo *symbol = symbol_table.Lookup(symbol_name);
                if (symbol == NULL)
                {
                    outfile << "	'" << symbol_name << "' not found in any of the ScopeTables" << endl;
                }
                else
                {
                    outfile << "	'" << symbol_name << "' found at position " << insertAddress(symbol_table, symbol_name) << " of ScopeTable# " << symbol_table.getScopeTableOfSymbol(symbol_name)->getScopeId() << endl;
                }
            }
        }
        else if (arg[0] == "D")
        {
            string symbol_name;
            symbol_name = arg[1];
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 2)
            {
                outfile << "	Wrong number of arguments for the command D" << endl;
            }
            else
            {
                string address = insertAddress(symbol_table, symbol_name);
                if (symbol_table.Remove(symbol_name) == true)
                {
                    outfile << "	Deleted '" << symbol_name << "' from position " << address << " of ScopeTable# " << symbol_table.getCurrentScopeId() << endl;
                }
                else
                {
                    outfile << "	Not found in the current ScopeTable# " << symbol_table.getCurrentScopeId() << endl;
                }
            }
        }
        else if (arg[0] == "P")
        {
            string scope_type;
            scope_type = arg[1];
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 2)
            {
                outfile << "	Wrong number of arguments for the command P" << endl;
            }
            else
            {
                if (scope_type == "A")
                {
                    symbol_table.PrintAllScopeTable(outfile);
                }
                else if (scope_type == "C")
                {
                    symbol_table.PrintCurrentScopeTable(outfile);
                }
                else
                {
                    outfile << "	Invalid argument for the command P" << endl;
                }
            }
        }
        else if (arg[0] == "S")
        {
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 1)
            {
                outfile << "	Wrong number of arguments for the command S" << endl;
            }
            else
            {
                symbol_table.EnterScope();
                outfile << "	ScopeTable# " << symbol_table.getCurrentScopeId() << " created" << endl;
            }
        }
        else if (arg[0] == "E")
        {
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 1)
            {
                outfile << "	Wrong number of arguments for the command E" << endl;
            }
            else
            {
                if (symbol_table.getCurrentScope() == NULL)
                {
                    outfile << "    No scope to exit" << endl;
                }
                else if (symbol_table.getCurrentScope()->getParentScope() == NULL)
                {
                    outfile << "	ScopeTable# " << symbol_table.getCurrentScope()->getScopeId() << " cannot be deleted" << endl;
                }
                else
                {
                    outfile << "	ScopeTable# " << symbol_table.getCurrentScopeId() << " deleted" << endl;
                    symbol_table.ExitScope();
                }
            }
        }
        else if (arg[0] == "Q")
        {
            outfile << "Cmd " << command_count << ": ";
            argumentsPrinter(outfile, arg);
            if (length != 1)
            {
                outfile << "	Wrong number of arguments for the command Q" << endl;
            }
            else
            {
                while (symbol_table.getCurrentScope() != NULL)
                {
                    outfile << "	ScopeTable# " << symbol_table.getCurrentScopeId() << " deleted" << endl;
                    symbol_table.ExitScope();
                }
            }
        }
        else
        {
            outfile << "	Wrong command" << endl;
        }
    }
}