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
#include <filesystem>
#include <algorithm>

using namespace std;

// A helper function to get the base filename without path and extension
string getBaseFilename(const string& filepath) {
    filesystem::path p(filepath);
    return p.stem().string();
}

// A helper function that makes sure the desired output directory exists
void ensureOutputDirectory() {
    filesystem::create_directories("output"); 
}

int main(int argc, char* argv[]) {
    // Main expects: ./assemble infile1.asm [infile2.asm ...] static_output.bin inst_output.bin
    // We made it so that it can allow for one argument, ex. ./assemble infile.asm that will output 
    // to output/<basename>_static.bin and output/<basename>_inst.bin
    // 
    // ./assemble demo1.asm [demo2.asm ...] static_output.bin inst_output.bin

        vector<string> inputFiles;
        string static_filename;
        string inst_filename;

        if (argc == 2) {
            // One input file, outputs to output/<basename>_static.bin and output/<basename>_inst.bin
            inputFiles.push_back(string(argv[1]));
            string output_prefix = getBaseFilename(argv[1]);
            static_filename = string("output/") + output_prefix + string("_static.bin");
            inst_filename = string("output/") + output_prefix + string("_inst.bin");

            // Ensures the output directory exists
            ensureOutputDirectory();
        } else if (argc >= 4) {
            int argCount = argc - 1; // excludes the program's name
            int numInputFiles = argCount - 2;
            for (int i = 1; i <= numInputFiles; ++i) {
                inputFiles.push_back(string(argv[i]));
            }
            static_filename = string(argv[argc - 2]);
            inst_filename = string(argv[argc - 1]);

            // Ensure parent directories for output files exist
            try {
                filesystem::path staticPath(static_filename);
                filesystem::path instPath(inst_filename);
                if (staticPath.has_parent_path()) 
                    filesystem::create_directories(staticPath.parent_path());
                if (instPath.has_parent_path()) 
                    filesystem::create_directories(instPath.parent_path());
            } catch (const exception &error) {
                cerr << "Error, the output directories could not be created. " << error.what() << endl;
            }
        } else {
            cerr << "Expected Usage:\n ./assemble infile.asm\n OR\n ./assemble infile1.asm [infile2.asm ...] static_output.bin inst_output.bin\n" << endl;
            return 1;
        }
    
    // Prepares the output files
    ofstream inst_outfile, static_outfile;
    static_outfile.open(static_filename, ios::binary);
    inst_outfile.open(inst_filename, ios::binary);
    
    if (!static_outfile || !inst_outfile) {
        cerr << "Error: Could not create output files in output directory" << endl;
        exit(1);
    }
    
    // Shows the user where the output will end up
    cout << "Assembling to:" << endl;
    cout << "- Static memory: " << static_filename << endl;
    cout << "- Instructions:  " << inst_filename << endl;

    /**
     * Phase 1:
     * Read all instructions, clean them of comments and whitespace DONE
     * DONE: Determine the numbers for all static memory labels
     * (measured in bytes starting at 0)
     * DONE: Determine the line numbers of all instruction line labels
     * (measured in instructions) starting at 0
    */

    // Initialize data structures
    unordered_map<string, int> static_labels; // label --> byte address
    unordered_map<string, int> instruction_labels; // label --> instruction number
    vector<string> data_section;  // .data section lines
    vector<string> text_section;  // .text section lines
    enum Section {
        NONE, 
        DATA, 
        TEXT };
    Section current_section = NONE;
    int data_address = 0; // current byte address in .data
    int instruction_count = 0;  // current instruction number in .text

    // For each input file
    for (int i = 0; i < inputFiles.size(); ++i) {
        ifstream infile(inputFiles[i]); //  open the input file for reading
        if (!infile) { // if file can't be opened, need to let the user know
            cerr << "Error: could not open file: " << inputFiles[i] << endl;
            exit(1);
        }

        string str;
        while (getline(infile, str)){ //Read a line from the file
            str = clean(str); // remove comments, leading and trailing whitespace
            if (str == "") { //Ignore empty lines
                continue;
            }
            
            // Phase 1: Process sections and labels
            if (str == ".data") { // .data section
                current_section = DATA;
            } else if (str == ".text") { // .text section
                current_section = TEXT;
            } else {
                // Handle .globl directives
                if (str.find(".globl") != string::npos) {
                    continue;
                }

                // For test cases like test4.asm where there are labels like .main without .data or .text
                if (!str.empty() && str[0] == '.' && str.find(' ') == string::npos && str.find('\t') == string::npos) {
                    string label = str.substr(1); // drops the leading dot

                    // ensures that we are in the TEXT section
                    current_section = TEXT;
                    
                    instruction_labels[label] = instruction_count;
                    continue; // no more content --> move to the next line
                }

                string content = str;  // The default is to treat the entire line as content

                // Checks if the line contains a label (aka has colon)
                if (str.find(':') != string::npos) {
                    // If there is a label then we extract it
                    string label = str.substr(0, str.find(':'));
                    content = str.substr(str.find(':') + 1);

                    // Trims whitespace from content
                    content = ltrim(content);

                    // Stores label in its appropriate symbol table
                    if (current_section == DATA) {
                        static_labels[label] = data_address; // Map label to current byte address
                    } else if (current_section == TEXT) {
                        instruction_labels[label] = instruction_count; // Map label to current instruction number
                    }
                }
                
                // Process the rest of the content based on the section
                if (current_section == DATA) {
                    // In Data section, it only processes if there's actual content after label
                    if (!content.empty()) {
                        data_section.push_back(content);

                        // Count bytes for .word directives
                        if (content.find(".word") != string::npos) {
                            vector<string> terms = split(content, WHITESPACE);
                            data_address += (terms.size() - 1) * 4; // Each .word is 4 bytes
                        }

                        // Challenge: 5 stars
                        else if (content.find(".asciiz") != string::npos) {
                            // Finds the beginning and the end of the string
                            int begin = content.find('"');
                            int end = content.rfind('"');

                            if (begin != string::npos && end != string::npos && begin < end) {
                                string str_content = content.substr(begin + 1, end - begin - 1);
                                // Each character = 4 bytes, and +1 for null terminator
                                data_address += (str_content.length() + 1) * 4;
                            }
                        }
                    }
                } else if (current_section == TEXT) {
                    // Processes content if anything is there
                    if (!content.empty()) {
                        text_section.push_back(content);
                        instruction_count++;
                    }
                    // For the standalone labels (with empty content) in our asm. files, we don't increment instruction_count
                    // The label maps to the current instruction_count, which will be the address of the next actual instruction that follows
                }
            }
        }
        infile.close();
    }

    /** Phase 2
     * Process all static memory, output to static memory file
     */
    for (const string& line : data_section) {
        vector<string> terms = split(line, WHITESPACE);
        
        if (terms.size() > 0 && terms[0] == ".word") {
            // Processes each value after .word
            for (int i = 1; i < terms.size(); i++) {

                string value = terms[i];
                int data_value;
                
                // Checks if this is a numeric literal or a label reference
                if (isdigit(value[0]) || (value[0] == '-' && value.length() > 1)) {
                    // The term is a numerical value (assuming no labels start with - or digits)
                    data_value = stoi(value);
                } else {
                    // Else its a label reference so it looks for it in the instruction labels
                    if (instruction_labels.find(value) != instruction_labels.end()) {
                        // Converts instruction numbers to its byte address (aka multiply by 4)
                        data_value = instruction_labels[value] * 4;
                    } else {
                        cerr << "Error: undefined label '" << value << "' in .data section" << endl;
                        exit(1);
                    }
                }
                // It will write the integer to static memory file
                write_binary(data_value, static_outfile);
            }
        }
    }
    
    /** Phase 3
     * Process all instructions, encodes, outputs to instruction memory file
     */ 
    int current_instruction = 0;
    for(string inst : text_section) {  
        vector<string> terms = split(inst, WHITESPACE+",()");
        string inst_type = terms[0];
        
        // R type instructions: int opcode, int rs, int rt, int rd, int shftamt, int funccode
        if (inst_type == "add") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 32), inst_outfile);

        } else if (inst_type == "sub") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 34), inst_outfile);

        } else if (inst_type == "mult") {
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 24), inst_outfile);

        } else if (inst_type == "div") {
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 0, 0, 26), inst_outfile);

        } else if (inst_type == "mflo") {
            write_binary(encode_Rtype(0, 0, 0, registers[terms[1]], 0, 18), inst_outfile);

        } else if (inst_type == "mfhi") {
            write_binary(encode_Rtype(0, 0, 0, registers[terms[1]], 0, 16), inst_outfile);

        } else if (inst_type == "sll") {
            // sll rd, rt, shamt
            write_binary(encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 0), inst_outfile);

        } else if (inst_type == "srl") {
            // srl rd, rt, shamt
            write_binary(encode_Rtype(0, 0, registers[terms[2]], registers[terms[1]], stoi(terms[3]), 2), inst_outfile);

        } else if (inst_type == "jr") {
            write_binary(encode_Rtype(0, registers[terms[1]], 0, 0, 0, 8), inst_outfile);

        } else if (inst_type == "jalr") {
            if (terms.size() == 2) {
                write_binary(encode_Rtype(0, registers[terms[1]], 0, 31, 0, 9), inst_outfile);
            } else {
                // In the case that there are two registers, it will store in $r1 and jump to $r0
                write_binary(encode_Rtype(0, registers[terms[1]], 0, registers[terms[2]], 0, 9), inst_outfile);
            }

        } else if (inst_type == "slt") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 42), inst_outfile);

        } else if (inst_type == "addi") {
            int imm = stoi(terms[3]);
            write_binary(encode_Itype(8, registers[terms[2]], registers[terms[1]], imm), inst_outfile);

        } else if (inst_type == "lw") {
            // lw $rt, offset($rs)
            int offset = stoi(terms[2]);
            write_binary(encode_Itype(35, registers[terms[3]], registers[terms[1]], offset), inst_outfile);

        } else if (inst_type == "sw") {
            // sw $rt, offset($rs)
            int offset = stoi(terms[2]);
            write_binary(encode_Itype(43, registers[terms[3]], registers[terms[1]], offset), inst_outfile);

        } else if (inst_type == "beq") {
            string label = terms[3];
            if (instruction_labels.find(label) != instruction_labels.end()) {
                int target = instruction_labels[label];
                int offset = target - (current_instruction + 1);
                write_binary(encode_Itype(4, registers[terms[1]], registers[terms[2]], offset), inst_outfile);
            } else {
                cerr << "Error: undefined instruction label '" << label << "' in beq instruction" << endl;
                exit(1);
            }
        } else if (inst_type == "bne") {
            string label = terms[3];
            if (instruction_labels.find(label) != instruction_labels.end()) {
                int target = instruction_labels[label];
                int offset = target - (current_instruction + 1);
                write_binary(encode_Itype(5, registers[terms[1]], registers[terms[2]], offset), inst_outfile);

            } else {
                cerr << "Error: undefined instruction label '" << label << "' in bne instruction" << endl;
                exit(1);
            }
        
        // J-type instructions
        } else if (inst_type == "j") {
            string label = terms[1];
            if (instruction_labels.find(label) != instruction_labels.end()) {
                int target = instruction_labels[label];
                write_binary(encode_Jtype(2, target), inst_outfile);
            } else {
                cerr << "Error: undefined instruction label '" << label << "' in j instruction" << endl;
                exit(1);
            }
        } else if (inst_type == "jal") {
            string label = terms[1];
            if (instruction_labels.find(label) != instruction_labels.end()) {
                int target = instruction_labels[label];
                write_binary(encode_Jtype(3, target), inst_outfile);
            } else {
                cerr << "Error: undefined instruction label '" << label << "' in jal instruction" << endl;
                exit(1);
            }
        
        // Pseudo instructions
        } else if (inst_type == "la") {
            // la $rt, label --> addi $rt, $zero, address
            // la works with static memory labels, defaults to 0 if not found
            string label = terms[2];
            int address = 0; // Default to address 0
            if (static_labels.find(label) != static_labels.end()) {
                address = static_labels[label];
            }
            write_binary(encode_Itype(8, 0, registers[terms[1]], address), inst_outfile);
        
        // Challenge: bge  (1 star) bge $rs, $rt, label --> slt $at, $rs, $rt; beq $at, $zero, label
        } else if (inst_type == "bge") {
            // bge $rs, $rt, label -> slt $at, $rs, $rt; beq $at, $zero, label
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 1, 0, 42), inst_outfile);
            current_instruction++;
            
            int target = instruction_labels[terms[3]];
            int offset = target - (current_instruction + 1);
            write_binary(encode_Itype(4, 1, 0, offset), inst_outfile);

        // Challenge: ble (1 star) ble $rs, $rt, label --> slt $at, $rt, $rs; bne $at, $zero, label
        } else if (inst_type == "ble") {
            // ble $rs, $rt, label -> slt $at, $rt, $rs; bne $at, $zero, label
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[1]], 1, 0, 42), inst_outfile);
            current_instruction++;
            
            int target = instruction_labels[terms[3]];
            int offset = target - (current_instruction + 1);
            write_binary(encode_Itype(5, 1, 0, offset), inst_outfile);

        // Challenge: mov (0.5 stars)
        } else if (inst_type == "mov") {
            write_binary(encode_Rtype(0, registers[terms[2]], 0, registers[terms[1]], 0, 32), inst_outfile);

        // Challenge: li (0.5 stars)
        } else if (inst_type == "li") {
            int imm = stoi(terms[2]);
            write_binary(encode_Itype(8, 0, registers[terms[1]], imm), inst_outfile);

        // Challenge: AND (0.5 stars)
        } else if (inst_type == "and") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 36), inst_outfile);

        // Challenge: OR (0.5 stars)
        } else if (inst_type == "or") {
            write_binary(encode_Rtype(0, registers[terms[2]], registers[terms[3]], registers[terms[1]], 0, 37), inst_outfile);

        // Challenge: blt (1 star)
        } else if (inst_type == "blt") {
            // blt $rs, $rt, label -> slt $at, $rs, $rt; bne $at, $zero, label
            write_binary(encode_Rtype(0, registers[terms[1]], registers[terms[2]], 1, 0, 42), inst_outfile);
            current_instruction++;
            
            int target = instruction_labels[terms[3]]; // Gets the line number of the label
            int offset = target - (current_instruction + 1);
            write_binary(encode_Itype(5, 1, 0, offset), inst_outfile);
                
        // Special instructions
        } else if (inst_type == "syscall") {
                write_binary(encode_Rtype(0, 0, 0, 26, 0, 12), inst_outfile);
            
        } else {
            cerr << "Error: Unknown instruction '" << inst_type << "'" << endl;
            exit(1);
        }
        current_instruction++;
    }
    
    // Close files and show completion message
    static_outfile.close();
    inst_outfile.close();
    
    cout << "Assembly completed successfully!" << endl;
    cout << "Output files created in output/ directory" << endl;
}

#endif
