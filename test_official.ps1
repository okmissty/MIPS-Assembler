# Official Testing Script (Following Project Instructions)
# Tests using the recommended gold binary comparison method

Write-Output "=== MIPS Assembler - Official Testing Method ==="
Write-Output "Following project instructions: dump readbytes output and diff results"
Write-Output ""

# Build readbytes if needed
if (-not (Test-Path "readbytes.exe")) {
    Write-Output "Compiling readbytes..."
    & g++ -std=c++17 readbytes.cpp -o readbytes
}

# Create txt folder for comparison files
$txtFolder = "txt"
if (-not (Test-Path $txtFolder)) {
    New-Item -ItemType Directory -Path $txtFolder | Out-Null
    Write-Output "Created $txtFolder/ directory for comparison files"
}

$script:passed = 0
$script:total = 0

function Test-WithGoldBinary {
    param($testName, $asmFile, $goldInstBin, $goldStaticBin = $null)
    
    $script:total++
    Write-Output "Testing $testName..."
    
    # Assemble the test file
    & ./assemble $asmFile
    if ($LASTEXITCODE -ne 0) {
        Write-Output "❌ $testName FAILED (Assembly error)"
        return
    }
    
    # Test instruction binary
    $goldFile = "txt/${testName}_gold_inst.txt"
    $mineFile = "txt/${testName}_mine_inst.txt"
    $outputInstBin = "output/${testName}_inst.bin"
    
    & ./readbytes $goldInstBin > $goldFile
    & ./readbytes $outputInstBin > $mineFile
    
    $diff = Compare-Object (Get-Content $goldFile) (Get-Content $mineFile)
    
    if ($diff) {
        Write-Output "❌ $testName FAILED (Instruction differences found)"
        Write-Output "First few differences:"
        $diff | Select-Object -First 5 | Format-Table
        return
    }
    
    # Test static memory binary if provided
    if ($goldStaticBin -and (Test-Path $goldStaticBin)) {
        $goldStaticFile = "txt/${testName}_gold_static.txt"
        $mineStaticFile = "txt/${testName}_mine_static.txt"
        $outputStaticBin = "output/${testName}_static.bin"
        
        & ./readbytes $goldStaticBin > $goldStaticFile
        & ./readbytes $outputStaticBin > $mineStaticFile
        
        $staticDiff = Compare-Object (Get-Content $goldStaticFile) (Get-Content $mineStaticFile)
        
        if ($staticDiff) {
            Write-Output "❌ $testName FAILED (Static memory differences found)"
            return
        }
    }
    
    Write-Output "✅ $testName PASSED"
    $script:passed++
}

# Test the main test cases (those with gold binaries)
Write-Output "=== Testing Main Cases (with Gold Binaries) ==="

Test-WithGoldBinary "demo1" "Testcases/Assembly/demo1.asm" "Testcases/GoldBinaries/demo1_inst.bin" "Testcases/GoldBinaries/demo1_static.bin"

Test-WithGoldBinary "test1" "Testcases/Assembly/test1.asm" "Testcases/GoldBinaries/test1inst.bin" "Testcases/GoldBinaries/test1static.bin"

Test-WithGoldBinary "test2" "Testcases/Assembly/test2.asm" "Testcases/GoldBinaries/test2inst.bin" "Testcases/GoldBinaries/test2static.bin"

Test-WithGoldBinary "test3" "Testcases/Assembly/test3.asm" "Testcases/GoldBinaries/test3inst.bin" "Testcases/GoldBinaries/test3static.bin"

Test-WithGoldBinary "test4" "Testcases/Assembly/test4.asm" "Testcases/GoldBinaries/test4inst.bin" "Testcases/GoldBinaries/test4static.bin"

Test-WithGoldBinary "test5" "Testcases/Assembly/test53.asm" "Testcases/GoldBinaries/test5inst.bin" "Testcases/GoldBinaries/test5static.bin"

Write-Output ""
Write-Output "=== Testing AA-2a Cases (Application Analysis Test Suite) ==="

# These don't have gold binaries, but we can test they assemble without errors
$aa2aTests = @("arithmetic", "branches", "jumps", "memory")
foreach ($test in $aa2aTests) {
    $script:total++
    Write-Output "Testing $test..."
    & ./assemble "Testcases/AA-2a/${test}.asm"
    if ($LASTEXITCODE -eq 0) {
        Write-Output "✅ $test PASSED (assembled successfully)"
        $script:passed++
    } else {
        Write-Output "❌ $test FAILED (assembly error)"
    }
}

Write-Output ""
Write-Output "=== FINAL RESULTS ==="
Write-Output "Passed: $script:passed / $script:total tests"

if ($script:passed -eq $script:total) {
    Write-Output "🎉 ALL TESTS PASSED! Following official testing methodology."
    Write-Output ""
    Write-Output "✅ Your assembler produces identical output to gold binaries"
    Write-Output "✅ Ready for submission!"
} else {
    Write-Output "⚠️  $($script:total - $script:passed) tests failed."
    Write-Output "Check the differences above and fix any issues."
}

Write-Output ""
Write-Output "Comparison files created in txt/ directory for manual inspection:"
Get-ChildItem "txt/*_gold_*.txt", "txt/*_mine_*.txt" | Select-Object Name | Format-Table -HideTableHeaders