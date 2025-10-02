// Andy Quach & Tyeon Ford
#ifndef __PROJECT1_CPP__
#define __PROJECT1_CPP__

#include "project1.h"
#include <vector>
#include <string>
#include <unordered_map>
#include <iostream>
#include <sstream>
#include <fstream>

using namespace std;

int main(int argc, char* argv[]) {
    if (argc < 4) { // Checks that at least 3 arguments are given in command line
        cerr << "Expected Usage:\n ./assemble infile1.asm infile2.asm ... infilek.asm staticmem_outfile.bin instructions_outfile.bin\n" << endl;
        exit(1);
    }
    
    //Prepare output files
    ofstream inst_outfile, static_outfile;
    static_outfile.open(argv[argc - 2], ios::binary);
    inst_outfile.open(argv[argc - 1], ios::binary);
    vector<string> instructions;

    /**
     * Phase 1:
     * Read all instructions, clean them of comments and whitespace
     * Parse .data and .text sections separately  
     * Extract labels and calculate their addresses:
     *    - Static memory labels → byte addresses (0, 4, 8, 24, etc.)
     *    - Instruction labels → instruction numbers (0, 1, 2, 20, etc.)
     * Build symbol tables for Phase 2 and 3 to use
     * Separate data declarations from instructions
    */

    // Phase 1: Symbol tables and section tracking
    unordered_map<string, int> static_labels;       // label -> byte address
    unordered_map<string, int> instruction_labels;  // label -> instruction number
    vector<string> data_section;                    // .data section lines
    vector<string> text_section;                    // .text section lines
    enum Section {
        NONE, 
        DATA, 
        TEXT };
    Section current_section = NONE;
    int data_address = 0;                           // current byte address in .data
    int instruction_count = 0;                      // current instruction number in .text

    //For each input file:
    for (int i = 1; i < argc - 2; i++) {
        ifstream infile(argv[i]); //  open the input file for reading
        if (!infile) { // if file can't be opened, need to let the user know
            cerr << "Error: could not open file: " << argv[i] << endl;
            exit(1);
        }

        string str;
        while (getline(infile, str)){ //Read a line from the file
            str = clean(str); // remove comments, leading and trailing whitespace
            if (str == "") { //Ignore empty lines
                continue;
            }
            
            // Phase 1: Process sections and labels
            if (str == ".data") {                                   // Found start of .data section
                current_section = DATA;
            } else if (str == ".text") {                            // Found start of .text section
                current_section = TEXT;
            } else {
                string content = str;  // Default: treat entire line as content                
                
                // Check if line contains a label (has colon)
                if (str.find(':') != string::npos) {
                    // Found a label --> extract it
                    string label = str.substr(0, str.find(':'));
                    content = str.substr(str.find(':') + 1);

                    // Trim whitespace from content
                    content = ltrim(content);
                    
                    // Store label in appropriate symbol table
                    if (current_section == DATA) {                      
                        static_labels[label] = data_address;            // Map label to current byte address
                    } else if (current_section == TEXT) {
                        instruction_labels[label] = instruction_count;  // Map label to current instruction number
                    }
                }
                
                // Process remaining content based on section type
                if (current_section == DATA) {
                    // Data section: only process if there's actual content after label
                    if (!content.empty()) {
                        data_section.push_back(content);

                        // Count bytes for .word directives
                        if (content.find(".word") != string::npos) {
                            vector<string> terms = split(content, WHITESPACE);
                            data_address += (terms.size() - 1) * 4; // Each .word is 4 bytes
                        }
                    }
                } else if (current_section == TEXT) {
                    // Text section: process content if present
                    if (!content.empty()) {
                        text_section.push_back(content);
                        instruction_count++;
                    }
                    // Note: For standalone labels (empty content), we don't increment instruction_count
                    // The label maps to the current instruction_count, which will be the address 
                    // of the next actual instruction that follows
                }
            }
        }
        infile.close();
    }

    /** Phase 2
     * Process all static memory, output to static memory file
     * TODO: All of this
        // Make a binary file that contains all of the static data (*_static.bin.txt)
        // find a way to map labels to line numbers
     */

    /** Phase 3
     * - Goes through each instruction and properly encodes 
     * Process all instructions, output to instruction memory file
     * TODO: Almost all of this, it only works for adds
     */ 
    for(string inst : text_section) {  // Changed from 'instructions' to 'text_section'
        vector<string> terms = split(inst, WHITESPACE+",()");
        string inst_type = terms[0];
        // R type instructions
        if (inst_type == "add"){
            int result = encode_Rtype(0,registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32); // Uncesscary 
            write_binary(encode_Rtype(0,registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32),inst_outfile);
        } else if (inst_type == "addi"){
            
        } else if (inst_type == "sub"){

        } else if (inst_type == "mult"){

        } else if (inst_type == "div"){

        // I type instructions
        } else if (inst_type == "mflo"){
            
        } else if (inst_type == "mfhi"){

        } else if (inst_type == "sll"){

        } else if (inst_type == "srl"){

        } else if (inst_type == "lw"){

        } else if (inst_type == "sw"){

        } else if (inst_type == "slt"){

        } else if (inst_type == "beq"){

        } else if (inst_type == "bne"){

        // J type instructions
        } else if (inst_type == "j"){

        } else if (inst_type == "jal"){

        } else if (inst_type == "jr"){

        } else if (inst_type == "jalr"){

        // Special Instructions
        } else if (inst_type == "Syscall"){

        } else {
            cout << "Error" << end;
        }
    }
}

#endif
