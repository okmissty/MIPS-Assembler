// Andy Quach & Tyeon Ford
#ifndef __PROJECT1_H__
#define __PROJECT1_H__

#include <math.h>
#include <string>
#include <vector>
#include <unordered_map>
#include <iostream>
#include <sstream>
#include <fstream>

using namespace std;
/**
 * Helper Functions for String Processing
 */

const string WHITESPACE = " \n\r\t\f\v";
 
//Remove all whitespace from the left of the string
string ltrim(const string &s){
    size_t start = s.find_first_not_of(WHITESPACE);
    return (start == string::npos) ? "" : s.substr(start);
}
 
//Remove all whitespace from the right of the string
string rtrim(const string &s){
    size_t end = s.find_last_not_of(WHITESPACE);
    return (end == string::npos) ? "" : s.substr(0, end + 1);
}

vector<string> split(const string &s, const string &split_on){
    vector<string> split_terms;
    int cur_pos = 0;
    while(cur_pos != string::npos) {
        int new_pos = s.find_first_not_of(split_on, cur_pos);
        cur_pos = s.find_first_of(split_on, new_pos);
        if(new_pos == -1 && cur_pos == -1) break;
        split_terms.push_back(s.substr(new_pos,cur_pos-new_pos));
    }
    return split_terms;
}

//Remove all comments and leading/trailing whitespace
string clean(const string &s){
    return rtrim(ltrim(s.substr(0,s.find('#'))));
}

// Parse a numeric literal (decimal or hex) into a 32-bit int.
// Accepts decimal like "123", negative like "-1", and hex like "0xFF".
// If the value is outside signed 32-bit range, we preserve the lower 32 bits
// by parsing as unsigned and then casting to int, which keeps the bit pattern.
inline int parse_number(const string &s) {
    try {
        // Use base 0 so "0x" prefixes are recognized as hex
        long long v = stoll(s, nullptr, 0);
        return (int)((unsigned long long)v & 0xFFFFFFFFULL);
    } catch (const std::invalid_argument &e) {
        cerr << "Error: invalid numeric literal '" << s << "'" << endl;
        exit(1);
    } catch (const std::out_of_range &e) {
        // Try unsigned parse and mask lower 32 bits
        try {
            unsigned long long uv = stoull(s, nullptr, 0);
            return (int)(uv & 0xFFFFFFFFULL);
        } catch (...) {
            cerr << "Error: numeric literal out of range '" << s << "'" << endl;
            exit(1);
        }
    }
}

/**
 * How to write raw binary to a file in C++
 */
void write_binary(int value,ofstream &outfile){
    //cout << hex << value << endl; //Useful for debugging
    outfile.write((char *)&value, sizeof(int));
}

/**
 * Helper methods for instruction encoding
 */

// Utility function for encoding an arithmetic "R" type function: Registers Only
int encode_Rtype(int opcode, int rs, int rt, int rd, int shftamt, int funccode){
    return (opcode << 26) + (rs << 21) + (rt << 16) + (rd << 11) + (shftamt << 6) + funccode; // shifts by int 
}

// Utility function for encoding an arithmetic "I" type function: Has an immediate involved
int encode_Itype(int opcode, int rs, int rt, int imm){
    return (opcode << 26) + (rs << 21) + (rt << 16) + (imm & 0xFFFF);
}

// Utility function for encoding an arithmetic "J" type function: Jumps to address
int encode_Jtype(int opcode, int address){
    return (opcode << 26) + (address & 0x3FFFFFF);
}

/**
 * Register name map
 */
static unordered_map<string, int> registers {
  {"$zero", 0}, {"$0", 0},
  {"$at", 1}, {"$1", 1},
  {"$v0", 2}, {"$2", 2},
  {"$v1", 3}, {"$3", 3},
  {"$a0", 4}, {"$4", 4},
  {"$a1", 5}, {"$5", 5},
  {"$a2", 6}, {"$6", 6},
  {"$a3", 7}, {"$7", 7},
  {"$t0", 8}, {"$8", 8},
  {"$t1", 9}, {"$9", 9},
  {"$t2", 10}, {"$10", 10},
  {"$t3", 11}, {"$11", 11},
  {"$t4", 12}, {"$12", 12},
  {"$t5", 13}, {"$13", 13},
  {"$t6", 14}, {"$14", 14},
  {"$t7", 15}, {"$15", 15},
  {"$s0", 16}, {"$16", 16},
  {"$s1", 17}, {"$17", 17},
  {"$s2", 18}, {"$18", 18},
  {"$s3", 19}, {"$19", 19},
  {"$s4", 20}, {"$20", 20},
  {"$s5", 21}, {"$21", 21},
  {"$s6", 22}, {"$22", 22},
  {"$s7", 23}, {"$23", 23},
  {"$t8", 24}, {"$24", 24},
  {"$t9", 25}, {"$25", 25},
  {"$k0", 26}, {"$26", 26},
  {"$k1", 27}, {"$27", 27},
  {"$gp", 28}, {"$28", 28},
  {"$sp", 29}, {"$29", 29},
  {"$s8", 30}, {"$30", 30},
  {"$ra", 31}, {"$31", 31}
};


#endif
