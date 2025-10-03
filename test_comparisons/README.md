# Test Comparisons Directory

This directory contains comparison files used for testing the MIPS assembler output against expected results.

## Directory Structure

### `main_tests/`
Contains comparison files for the main test cases (demo1, test1-5):
- `*_mine.txt` - Output from our assembler implementation
- `*_gold.txt` - Expected output from reference implementation
- Files include both instruction and static memory outputs where applicable

### `aa2a_tests/`
Contains comparison files for Application Analysis Objective 2a test cases:
- `*_mine.txt` - Output from our assembler implementation  
- `*_expected.txt` - Expected output from reference files
- Test cases: arithmetic, branches, jumps, memory

## Usage

These files are generated during testing to compare:
1. Our assembler's binary output (converted to readable format via `readbytes`)
2. Expected binary output from reference implementations

All tests currently **PASS** - the binary content matches perfectly with only minor whitespace formatting differences.

## Current Test Status

✅ **Main Tests**: All passing (demo1, test1-5)  
✅ **AA-2a Tests**: All passing (arithmetic, branches, jumps, memory)  
✅ **Static Memory**: Correctly processed for all applicable tests  
✅ **la Instruction**: Fixed and working correctly for both static and undefined labels  

Last updated: October 3, 2025