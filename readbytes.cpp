//This program will read a file and output the binary in that file to the
//terminal, 32 bits at a time. It prints in binary, hex, and decimal
#include <string>
#include <iostream>
#include <fstream>
#include <bitset>
#include <iomanip>

using namespace std;
int main(int argc, char* argv[]) {
  string filename = argv[argc-1];
  int buffer;
  ifstream file(filename, ios::in | ios::binary);
  while(file.read((char*) &buffer,sizeof(int))) {
    cout << bitset<32>(buffer) << " " << setfill('0') << setw(8) << hex << buffer << " " << dec << buffer << endl;
  }
  file.close();
}
