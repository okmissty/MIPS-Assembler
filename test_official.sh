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

  # Test instruction binary (store comparison dumps in output/)
  goldFile="output/${testName}_gold_inst.txt"
  mineFile="output/${testName}_mine_inst.txt"
  outputInstBin="output/${testName}_inst.bin"

  if ! ./readbytes "$goldInstBin" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' > "$goldFile"; then
    echo "Failed: readbytes on $goldInstBin" >&2
    echo "❌ $testName FAILED (readbytes on gold binary)"
    return 0
  fi
  if ! ./readbytes "$outputInstBin" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' > "$mineFile"; then
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
  goldStaticFile="output/${testName}_gold_static.txt"
  mineStaticFile="output/${testName}_mine_static.txt"
    outputStaticBin="output/${testName}_static.bin"

  if ! ./readbytes "$goldStaticBin" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' > "$goldStaticFile"; then
      echo "Failed: readbytes on $goldStaticBin" >&2
      echo "❌ $testName FAILED (readbytes on gold static binary)"
      return 0
    fi
  if ! ./readbytes "$outputStaticBin" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' > "$mineStaticFile"; then
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

# Locate assembler binary once for AA-2a tests (reuse logic from above)
ASSEMBLE_BIN=""
if [[ -x "./assemble" ]]; then
  ASSEMBLE_BIN="./assemble"
elif [[ -x "./project1" ]]; then
  ASSEMBLE_BIN="./project1"
elif [[ -x "./assemble.exe" ]]; then
  ASSEMBLE_BIN="./assemble.exe"
else
  if [[ -f Makefile ]] || [[ -f makefile ]]; then
    echo "Building assembler for AA-2a tests..."
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

for test in "${aa2aTests[@]}"; do
  total=$((total+1))
  echo "Testing $test..."
  if [[ -z "$ASSEMBLE_BIN" ]]; then
    echo "Error: assembler binary not found for AA-2a tests" >&2
    echo "❌ $test FAILED (assembler missing)"
    continue
  fi

  # assemble into output/<test>_{static,inst}.bin
  if ! "$ASSEMBLE_BIN" "Testcases/AA-2a/${test}.asm" "output/${test}_static.bin" "output/${test}_inst.bin"; then
    echo "❌ $test FAILED (assembly error)"
    continue
  fi

  # Produce readbytes dumps for produced binaries
  instBin="output/${test}_inst.bin"
  staticBin="output/${test}_static.bin"
  mineInstTxt="output/${test}_mine_inst.txt"
  mineStaticTxt="output/${test}_mine_static.txt"
  goldInstTxt="Testcases/AA-2a/${test}_inst.bin.txt"
  goldStaticTxt="Testcases/AA-2a/${test}_static.bin.txt"

  ok=true
  if [[ -f "$instBin" ]]; then
  if ! ./readbytes "$instBin" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' > "$mineInstTxt"; then
      echo "Failed: readbytes on $instBin" >&2
      ok=false
    fi
    if [[ -f "$goldInstTxt" ]]; then
      # create a normalized version of the gold (trim trailing spaces) for diff
      goldInstNorm="/tmp/gold_${test}_inst.txt"
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' "$goldInstTxt" > "$goldInstNorm" || cp "$goldInstTxt" "$goldInstNorm"
      # Ensure normalized gold ends with a newline (some gold files may lack final newline)
      if [[ $(tail -c1 "$goldInstNorm" | wc -l) -eq 0 ]]; then
        printf "\n" >> "$goldInstNorm"
      fi
      if ! diff -u "$goldInstNorm" "$mineInstTxt" >/dev/null; then
        echo "❌ $test FAILED (Instruction differences found)"
        echo "First few lines of diff:";
        diff -u "$goldInstNorm" "$mineInstTxt" | sed -n '1,12p'
        ok=false
      fi
      rm -f "$goldInstNorm"
    fi
  else
    echo "Warning: produced instruction binary missing for $test" >&2
    ok=false
  fi

  if [[ -f "$staticBin" ]]; then
  if ! ./readbytes "$staticBin" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' > "$mineStaticTxt"; then
      echo "Failed: readbytes on $staticBin" >&2
      ok=false
    fi
    if [[ -f "$goldStaticTxt" ]]; then
      goldStaticNorm="/tmp/gold_${test}_static.txt"
  sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/[[:space:]]+$//' "$goldStaticTxt" > "$goldStaticNorm" || cp "$goldStaticTxt" "$goldStaticNorm"
      # Ensure normalized gold ends with a newline
      if [[ $(tail -c1 "$goldStaticNorm" | wc -l) -eq 0 ]]; then
        printf "\n" >> "$goldStaticNorm"
      fi
      if ! diff -u "$goldStaticNorm" "$mineStaticTxt" >/dev/null; then
        echo "❌ $test FAILED (Static memory differences found)"
        echo "First few lines of diff:";
        diff -u "$goldStaticNorm" "$mineStaticTxt" | sed -n '1,12p'
        ok=false
      fi
      rm -f "$goldStaticNorm"
    fi
  else
    # It's okay for some AA tests to have empty static; not fatal by itself
    :
  fi

  if [[ "$ok" == true ]]; then
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
echo "Comparison files created in output/ directory for manual inspection:"
ls -1 output/*_gold_*.txt output/*_mine_*.txt 2>/dev/null || true
