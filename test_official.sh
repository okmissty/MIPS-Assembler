#!/usr/bin/env bash
set -euo pipefail

echo "=== MIPS Assembler - Official Testing Method (Linux) ==="
echo "Following project instructions: dump readbytes output and diff results"
echo

# Build readbytes if needed
if [[ ! -x ./readbytes ]]; then
  if [[ -f readbytes.cpp ]]; then
    echo "Compiling readbytes..."
    g++ -std=c++17 readbytes.cpp -o readbytes
  else
    echo "readbytes.cpp not found; please ensure readbytes tool is available." >&2
    exit 1
  fi
fi

# Create txt folder for comparison files
txtFolder="txt"
if [[ ! -d "$txtFolder" ]]; then
  mkdir -p "$txtFolder"
  echo "Created $txtFolder/ directory for comparison files"
fi

passed=0
total=0

test_with_gold_binary() {
  local testName="$1"
  local asmFile="$2"
  local goldInstBin="$3"
  local goldStaticBin="${4-}"

  total=$((total+1))
  echo "Testing $testName..."

  # Assemble the test file
  # Locate assembler binary: prefer ./assemble, then ./project1, then ./assemble.exe
  ASSEMBLE_BIN=""
  if [[ -x "./assemble" ]]; then
    ASSEMBLE_BIN="./assemble"
  elif [[ -x "./project1" ]]; then
    ASSEMBLE_BIN="./project1"
  elif [[ -x "./assemble.exe" ]]; then
    ASSEMBLE_BIN="./assemble.exe"
  else
    # Try building assemble via Makefile if available
    if [[ -f Makefile ]] || [[ -f makefile ]]; then
      echo "Building assembler (assemble)..."
      make >/dev/null || true
    fi
    if [[ -x "./assemble" ]]; then
      ASSEMBLE_BIN="./assemble"
    elif [[ -x "./project1" ]]; then
      ASSEMBLE_BIN="./project1"
    elif [[ -x "./assemble.exe" ]]; then
      ASSEMBLE_BIN="./assemble.exe"
    fi
  fi

  if [[ -z "$ASSEMBLE_BIN" ]]; then
    echo "Error: assembler binary not found (tried ./assemble, ./project1, ./assemble.exe)" >&2
    echo "❌ $testName FAILED (assembler missing)"
    return
  fi

  # Allow multiple input files (space separated) to be passed in $asmFile
  read -r -a asmFiles <<< "$asmFile"

  # Ensure output directory exists
  mkdir -p output

  # Call assembler with input files followed by static and inst output filenames
  "$ASSEMBLE_BIN" "${asmFiles[@]}" "output/${testName}_static.bin" "output/${testName}_inst.bin"
  if [[ $? -ne 0 ]]; then
    echo "❌ $testName FAILED (Assembly error)"
    return
  fi

  # Test instruction binary
  goldFile="txt/${testName}_gold_inst.txt"
  mineFile="txt/${testName}_mine_inst.txt"
  outputInstBin="output/${testName}_inst.bin"

  if ! ./readbytes "$goldInstBin" > "$goldFile"; then
    echo "Failed: readbytes on $goldInstBin" >&2
    echo "❌ $testName FAILED (readbytes on gold binary)"
    return 0
  fi
  if ! ./readbytes "$outputInstBin" > "$mineFile"; then
    echo "Failed: readbytes on $outputInstBin" >&2
    echo "❌ $testName FAILED (readbytes on produced inst binary)"
    return 0
  fi

  if ! diff -u "$goldFile" "$mineFile" >/dev/null; then
    echo "❌ $testName FAILED (Instruction differences found)"
    echo "First few lines of diff:"
    diff -u "$goldFile" "$mineFile" | sed -n '1,12p'
    return 0
  fi

  # Test static memory binary if provided and exists
  if [[ -n "$goldStaticBin" && -f "$goldStaticBin" ]]; then
    goldStaticFile="txt/${testName}_gold_static.txt"
    mineStaticFile="txt/${testName}_mine_static.txt"
    outputStaticBin="output/${testName}_static.bin"

    if ! ./readbytes "$goldStaticBin" > "$goldStaticFile"; then
      echo "Failed: readbytes on $goldStaticBin" >&2
      echo "❌ $testName FAILED (readbytes on gold static binary)"
      return 0
    fi
    if ! ./readbytes "$outputStaticBin" > "$mineStaticFile"; then
      echo "Failed: readbytes on $outputStaticBin" >&2
      echo "❌ $testName FAILED (readbytes on produced static binary)"
      return 0
    fi

    if ! diff -u "$goldStaticFile" "$mineStaticFile" >/dev/null; then
      echo "❌ $testName FAILED (Static memory differences found)"
      echo "First few lines of diff:"
      diff -u "$goldStaticFile" "$mineStaticFile" | sed -n '1,12p'
      return 0
    fi
  fi

  echo "✅ $testName PASSED"
  passed=$((passed+1))
  return 0
}

echo "=== Testing Main Cases (with Gold Binaries) ==="

test_with_gold_binary "demo1" "Testcases/Assembly/demo1.asm" "Testcases/GoldBinaries/demo1_inst.bin" "Testcases/GoldBinaries/demo1_static.bin"

test_with_gold_binary "test1" "Testcases/Assembly/test1.asm" "Testcases/GoldBinaries/test1inst.bin" "Testcases/GoldBinaries/test1static.bin"

test_with_gold_binary "test2" "Testcases/Assembly/test2.asm" "Testcases/GoldBinaries/test2inst.bin" "Testcases/GoldBinaries/test2static.bin"

test_with_gold_binary "test3" "Testcases/Assembly/test3.asm" "Testcases/GoldBinaries/test3inst.bin" "Testcases/GoldBinaries/test3static.bin"

test_with_gold_binary "test4" "Testcases/Assembly/test4.asm" "Testcases/GoldBinaries/test4inst.bin" "Testcases/GoldBinaries/test4static.bin"

# test5 is composed of test51, test52, test53 assembled together (order matters)
test_with_gold_binary "test5" "Testcases/Assembly/test51.asm Testcases/Assembly/test52.asm Testcases/Assembly/test53.asm" "Testcases/GoldBinaries/test5inst.bin" "Testcases/GoldBinaries/test5static.bin"

echo
echo "=== Testing AA-2a Cases (Application Analysis Test Suite) ==="

# These don't have gold binaries, but we can test they assemble without errors
aa2aTests=(arithmetic branches jumps memory)
for test in "${aa2aTests[@]}"; do
  total=$((total+1))
  echo "Testing $test..."
  if ! ./assemble "Testcases/AA-2a/${test}.asm"; then
    echo "❌ $test FAILED (assembly error)"
  else
    echo "✅ $test PASSED (assembled successfully)"
    passed=$((passed+1))
  fi
done

echo
echo "=== FINAL RESULTS ==="
echo "Passed: $passed / $total tests"

if [[ $passed -eq $total ]]; then
  echo "🎉 ALL TESTS PASSED! Following official testing methodology."
  echo
  echo "✅ Your assembler produces identical output to gold binaries"
  echo "✅ Ready for submission!"
else
  echo "⚠️  $((total - passed)) tests failed."
  echo "Check the differences above and fix any issues."
fi

echo
echo "Comparison files created in txt/ directory for manual inspection:"
ls -1 txt/*_gold_*.txt txt/*_mine_*.txt 2>/dev/null || true
