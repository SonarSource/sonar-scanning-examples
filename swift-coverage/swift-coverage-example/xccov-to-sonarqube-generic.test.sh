#!/usr/bin/env bash
set -euo pipefail

# Unit tests for xccov-to-sonarqube-generic.sh
# Run: ./xccov-to-sonarqube-generic.test.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SCRIPT="$SCRIPT_DIR/xccov-to-sonarqube-generic.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Extract the convert_xccov_to_xml function from the source script
# We source it in a subshell to avoid executing the main script logic
extract_convert_function() {
  awk '/^function convert_xccov_to_xml/,/^}$/' "$SOURCE_SCRIPT"
}

# Create a temporary script with just the conversion function
TEMP_SCRIPT=$(mktemp)
trap "rm -f $TEMP_SCRIPT" EXIT

cat > "$TEMP_SCRIPT" << 'SCRIPT_HEADER'
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_HEADER

extract_convert_function >> "$TEMP_SCRIPT"

cat >> "$TEMP_SCRIPT" << 'SCRIPT_FOOTER'
# Read from stdin and convert
convert_xccov_to_xml
SCRIPT_FOOTER

chmod +x "$TEMP_SCRIPT"

# Test helper function
run_test() {
  local test_name="$1"
  local input="$2"
  local expected="$3"
  
  TESTS_RUN=$((TESTS_RUN + 1))
  
  # Run conversion
  local actual
  actual=$(echo "$input" | bash "$TEMP_SCRIPT" 2>&1) || true
  
  # Normalize whitespace for comparison
  local expected_normalized=$(echo "$expected" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  local actual_normalized=$(echo "$actual" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  
  if [[ "$expected_normalized" == "$actual_normalized" ]]; then
    echo -e "${GREEN}✓ PASS${NC}: $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    return 0
  else
    echo -e "${RED}✗ FAIL${NC}: $test_name"
    echo -e "${YELLOW}Expected:${NC}"
    echo "$expected" | sed 's/^/  /'
    echo -e "${YELLOW}Actual:${NC}"
    echo "$actual" | sed 's/^/  /'
    TESTS_FAILED=$((TESTS_FAILED + 1))
    return 1
  fi
}

echo "Running unit tests for xccov-to-sonarqube-generic.sh"
echo "======================================================"
echo ""

# ------------------------------------------------------------------------------
# Test: Simple covered line
# ------------------------------------------------------------------------------
run_test "Simple covered line" \
"/path/to/File.swift:
  10: 5
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="10" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Simple uncovered line
# ------------------------------------------------------------------------------
run_test "Simple uncovered line" \
"/path/to/File.swift:
  10: 0
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="10" covered="false"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Multiple lines with mixed coverage
# ------------------------------------------------------------------------------
run_test "Multiple lines with mixed coverage" \
"/path/to/File.swift:
  10: 5
  11: 0
  12: 1
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="10" covered="true"/>
    <lineToCover lineNumber="11" covered="false"/>
    <lineToCover lineNumber="12" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Branch coverage - single tuple, one branch uncovered
# ------------------------------------------------------------------------------
run_test "Branch coverage - single tuple, one branch uncovered" \
"/path/to/File.swift:
  21: 1 [
(33, 9, 0)
]
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="21" covered="true" branchesToCover="2" coveredBranches="1"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Branch coverage - single tuple, both branches covered
# ------------------------------------------------------------------------------
run_test "Branch coverage - single tuple, both branches covered" \
"/path/to/File.swift:
  21: 5 [
(33, 9, 3)
]
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="21" covered="true" branchesToCover="2" coveredBranches="2"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Branch coverage - single tuple, no branches covered
# ------------------------------------------------------------------------------
run_test "Branch coverage - single tuple, no branches covered" \
"/path/to/File.swift:
  21: 1 [
(33, 0, 0)
]
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="21" covered="true" branchesToCover="2" coveredBranches="0"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Branch coverage - multiple tuples (nil coalescing chain)
# ------------------------------------------------------------------------------
run_test "Branch coverage - multiple tuples (nil coalescing chain)" \
"/path/to/File.swift:
  26: 1 [
(21, 5, 0)
(26, 1, 0)
]
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="26" covered="true" branchesToCover="4" coveredBranches="2"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Branch coverage - complex nested ternary (6 tuples)
# ------------------------------------------------------------------------------
run_test "Branch coverage - complex nested ternary (6 tuples)" \
"/path/to/File.swift:
  40: 2 [
(20, 5, 1)
(25, 6, 1)
(31, 3, 1)
(34, 7, 0)
(41, 1, 1)
(45, 9, 1)
]
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="40" covered="true" branchesToCover="12" coveredBranches="11"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Mixed lines - some with branches, some without
# ------------------------------------------------------------------------------
run_test "Mixed lines - some with branches, some without" \
"/path/to/File.swift:
  10: 5
  11: 2 [
(20, 1, 0)
]
  12: 0
  13: 1
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="10" covered="true"/>
    <lineToCover lineNumber="11" covered="true" branchesToCover="2" coveredBranches="1"/>
    <lineToCover lineNumber="12" covered="false"/>
    <lineToCover lineNumber="13" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Multiple files
# ------------------------------------------------------------------------------
run_test "Multiple files" \
"/path/to/File1.swift:
  10: 5

/path/to/File2.swift:
  20: 0
" \
'  <file path="/path/to/File1.swift">
    <lineToCover lineNumber="10" covered="true"/>
  </file>
  <file path="/path/to/File2.swift">
    <lineToCover lineNumber="20" covered="false"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: File path with ampersand (XML escaping)
# ------------------------------------------------------------------------------
run_test "File path with ampersand (XML escaping)" \
"/path/to/Tom & Jerry.swift:
  10: 5
" \
'  <file path="/path/to/Tom &amp; Jerry.swift">
    <lineToCover lineNumber="10" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Large line numbers
# ------------------------------------------------------------------------------
run_test "Large line numbers" \
"/path/to/File.swift:
  1234: 999
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="1234" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Line with high execution count
# ------------------------------------------------------------------------------
run_test "Line with high execution count" \
"/path/to/File.swift:
  10: 999999
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="10" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Non-executable lines should be ignored
# ------------------------------------------------------------------------------
run_test "Non-executable lines (asterisk) should be ignored" \
"/path/to/File.swift:
  10: *
  11: 5
  12: *
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="11" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Branch with uncovered line (edge case)
# ------------------------------------------------------------------------------
run_test "Branch with execution count 0 (uncovered but has branch info)" \
"/path/to/File.swift:
  21: 0 [
(33, 0, 0)
]
" \
'  <file path="/path/to/File.swift">
    <lineToCover lineNumber="21" covered="false" branchesToCover="2" coveredBranches="0"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Real-world example from AppDelegate.swift
# ------------------------------------------------------------------------------
run_test "Real-world example - if/else with branch info" \
"/Users/test/AppDelegate.swift:
  29: 1
  30: 1 [
(20, 0, 0)
]
  31: 0
  32: 1 [
(1, 9, 0)
]
  33: 1
  34: 1
  35: 1
" \
'  <file path="/Users/test/AppDelegate.swift">
    <lineToCover lineNumber="29" covered="true"/>
    <lineToCover lineNumber="30" covered="true" branchesToCover="2" coveredBranches="0"/>
    <lineToCover lineNumber="31" covered="false"/>
    <lineToCover lineNumber="32" covered="true" branchesToCover="2" coveredBranches="1"/>
    <lineToCover lineNumber="33" covered="true"/>
    <lineToCover lineNumber="34" covered="true"/>
    <lineToCover lineNumber="35" covered="true"/>
  </file>'

# ------------------------------------------------------------------------------
# Test: Empty input
# ------------------------------------------------------------------------------
run_test "Empty input" \
"" \
""

# ==============================================================================
# Version Check Tests
# ==============================================================================

echo ""
echo "Version check tests"
echo "------------------------------------------------------"

# Extract the is_xcode_version_supported function from the source script
extract_version_function() {
  awk '/^function is_xcode_version_supported/,/^}$/' "$SOURCE_SCRIPT"
}

# Test helper for version checks
run_version_test() {
  local test_name="$1"
  local major="$2"
  local minor="$3"
  local expected_supported="$4"  # "true" or "false"
  
  TESTS_RUN=$((TESTS_RUN + 1))
  
  # Create temp script with version function
  local version_script
  version_script=$(mktemp)
  
  cat > "$version_script" << 'HEADER'
#!/usr/bin/env bash
set -euo pipefail
HEADER
  
  extract_version_function >> "$version_script"
  
  cat >> "$version_script" << FOOTER
if is_xcode_version_supported $major $minor; then
  echo "supported"
else
  echo "unsupported"
fi
FOOTER
  
  chmod +x "$version_script"
  
  local actual
  actual=$(bash "$version_script" 2>&1)
  rm -f "$version_script"
  
  local expected
  if [[ "$expected_supported" == "true" ]]; then
    expected="supported"
  else
    expected="unsupported"
  fi
  
  if [[ "$actual" == "$expected" ]]; then
    echo -e "${GREEN}✓ PASS${NC}: $test_name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
    return 0
  else
    echo -e "${RED}✗ FAIL${NC}: $test_name"
    echo -e "${YELLOW}Expected:${NC} $expected"
    echo -e "${YELLOW}Actual:${NC} $actual"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    return 1
  fi
}

# ------------------------------------------------------------------------------
# Supported versions (13.3+)
# ------------------------------------------------------------------------------
run_version_test "Xcode 26.2 should be supported" 26 2 "true"
run_version_test "Xcode 16.0 should be supported" 16 0 "true"
run_version_test "Xcode 16.2 should be supported" 16 2 "true"
run_version_test "Xcode 15.0 should be supported" 15 0 "true"
run_version_test "Xcode 15.4 should be supported" 15 4 "true"
run_version_test "Xcode 14.0 should be supported" 14 0 "true"
run_version_test "Xcode 14.3 should be supported" 14 3 "true"
run_version_test "Xcode 13.3 should be supported (minimum)" 13 3 "true"
run_version_test "Xcode 13.4 should be supported" 13 4 "true"

# ------------------------------------------------------------------------------
# Unsupported versions (< 13.3)
# ------------------------------------------------------------------------------
run_version_test "Xcode 13.2 should be unsupported" 13 2 "false"
run_version_test "Xcode 13.1 should be unsupported" 13 1 "false"
run_version_test "Xcode 13.0 should be unsupported" 13 0 "false"
run_version_test "Xcode 12.5 should be unsupported" 12 5 "false"
run_version_test "Xcode 12.0 should be unsupported" 12 0 "false"
run_version_test "Xcode 11.0 should be unsupported" 11 0 "false"
run_version_test "Xcode 10.0 should be unsupported" 10 0 "false"

# ------------------------------------------------------------------------------
# Edge cases
# ------------------------------------------------------------------------------
run_version_test "Xcode 0.0 should be unsupported" 0 0 "false"
run_version_test "Xcode 99.0 (future) should be supported" 99 0 "true"

# ------------------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------------------
echo ""
echo "======================================================"
echo -e "Tests run: $TESTS_RUN"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
if [[ $TESTS_FAILED -gt 0 ]]; then
  echo -e "${RED}Failed: $TESTS_FAILED${NC}"
  exit 1
else
  echo -e "Failed: $TESTS_FAILED"
  echo ""
  echo -e "${GREEN}All tests passed!${NC}"
  exit 0
fi

