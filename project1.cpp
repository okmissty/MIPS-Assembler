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
     * Read all instructions, clean them of comments and whitespace DONE
     * TODO: Determine the numbers for all static memory labels
     * (measured in bytes starting at 0)
     * TODO: Determine the line numbers of all instruction line labels
     * (measured in instructions) starting at 0
    */

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
            instructions.push_back(str); // TODO This will need to change for labels
        }
        infile.close();
    }

    /** Phase 2
     * Process all static memory, output to static memory file
     * TODO: All of this
        // Make a binary file that contains all of the data .word 2 4 5
        // multiple label adress by 4
        // find a way to map labels to line numbers
     */

    /** Phase 3
     * - Goes through each instruction and properly encodes 
     * Process all instructions, output to instruction memory file
     * TODO: Almost all of this, it only works for adds
     */ 
    for(string inst : instructions) {
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
