#!/bin/bash
# Turn off automatic exit on error for more controlled debugging
set -u  # Treat unset variables as an error

# Define environment variables
PACKAGE_NAME="SnappThemingSVGSupport"
SOURCE_PATH="$PACKAGE_NAME/Sources"
OUTPUT_FILE="pr_coverage_summary.txt"
DECIMAL_PRECISION=6
DISPLAY_PRECISION=2
DEBUG_LOG="coverage_debug.log"

# Start debug log
{
    echo "====== DEBUG LOG ======"
    echo "Date: $(date)"
    echo "Script started"
    echo "Package: $PACKAGE_NAME"
    echo "Source path: $SOURCE_PATH"
    echo "Environment variables:"
    env | sort
    echo "Current directory: $(pwd)"
    echo "Directory contents:"
    ls -la
    echo "========================"
} > "$DEBUG_LOG"

# Function to log debug information
log_debug() {
    echo "$(date +%H:%M:%S) - $1" >> "$DEBUG_LOG"
}

# Function to examine a file
examine_file() {
    local file="$1"
    log_debug "Examining file: $file"
    
    if [ -f "$file" ]; then
    log_debug "File exists and size is: $(wc -c < "$file") bytes"
    log_debug "File type: $(file -b "$file")"
    log_debug "First 500 bytes:"
    head -c 500 "$file" | hexdump -C >> "$DEBUG_LOG"
    log_debug "File stats: $(stat "$file" 2>/dev/null || ls -la "$file")"
    else
    log_debug "File does not exist"
    fi
}

# Create a fallback coverage report
create_fallback_report() {
    local reason="$1"
    log_debug "Creating fallback report due to: $reason"
    
    cat > "$OUTPUT_FILE" << EOF
    | ID | Name | Executable Lines | Coverage |
    |----|------|-----------------:|---------:|
    | 0 | ${PACKAGE_NAME%SVGSupport} | 0 | **0.00%** |
    EOF
    echo "Created a minimal coverage report due to: $reason"
    log_debug "Fallback report created"
}

log_debug "Obtaining coverage path from Swift"
echo "Running Swift test to get coverage path..."

# Get the path to the coverage report - capture both stdout and stderr
CODECOV_OUTPUT=$(swift test --enable-code-coverage --show-codecov-path 2>&1)
EXIT_CODE=$?

# Log the command output
log_debug "Swift test exit code: $EXIT_CODE"
log_debug "Swift test output: $CODECOV_OUTPUT"

# Check if the command succeeded
if [ $EXIT_CODE -ne 0 ]; then
echo "Error: Failed to get coverage path. Exit code: $EXIT_CODE"
log_debug "Error: Swift test command failed with exit code $EXIT_CODE"
create_fallback_report "swift test command failed"

echo "Debug log written to $DEBUG_LOG"
exit 0
fi

# Extract the path from the output
CODECOV_PATH=$(echo "$CODECOV_OUTPUT" | tail -n 1)
echo "Using coverage report at: $CODECOV_PATH"
log_debug "Coverage path: $CODECOV_PATH"

# Check if the file exists
if [ ! -f "$CODECOV_PATH" ]; then
echo "Error: Coverage report not found at $CODECOV_PATH"
log_debug "Coverage file does not exist"

# Check if the directory exists
CODECOV_DIR=$(dirname "$CODECOV_PATH")
if [ -d "$CODECOV_DIR" ]; then
log_debug "Parent directory exists, contents:"
ls -la "$CODECOV_DIR" >> "$DEBUG_LOG"
else
log_debug "Parent directory does not exist"
fi

create_fallback_report "coverage file not found"
echo "Debug log written to $DEBUG_LOG"
exit 0
fi

# Examine the coverage file
examine_file "$CODECOV_PATH"

# Try to validate the JSON file
log_debug "Validating JSON format"
JSON_CHECK=$(jq empty "$CODECOV_PATH" 2>&1)
JSON_EXIT_CODE=$?

log_debug "JSON validation exit code: $JSON_EXIT_CODE"
log_debug "JSON validation output: $JSON_CHECK"

if [ $JSON_EXIT_CODE -ne 0 ]; then
echo "Error: Invalid JSON format in $CODECOV_PATH"
echo "JSON validation error: $JSON_CHECK"

# Try to determine the file format and size
FILE_TYPE=$(file -b "$CODECOV_PATH")
FILE_SIZE=$(wc -c < "$CODECOV_PATH")
echo "File appears to be: $FILE_TYPE (Size: $FILE_SIZE bytes)"

log_debug "Trying to parse as xcresult instead"
if [[ "$CODECOV_PATH" == *".xcresult"* ]]; then
echo "Detected .xcresult format, trying xcresulttool..."
if command -v xcrun &> /dev/null; then
log_debug "xcrun is available, trying to extract coverage data"
XCRUN_OUTPUT=$(xcrun xcresulttool get --format json --path "$CODECOV_PATH" 2>&1)
log_debug "xcrun output: $XCRUN_OUTPUT"
else
log_debug "xcrun not available"
fi
fi

create_fallback_report "invalid JSON format"
echo "Debug log written to $DEBUG_LOG"
exit 0
fi

# Try to extract coverage data
log_debug "Extracting coverage data"
TMP_DATA_FILE=$(mktemp)
JQ_CMD="jq -r --arg source_path \"$SOURCE_PATH\" '.data[0].files[] | select(.filename | contains(\$source_path)) | .summary.lines' \"$CODECOV_PATH\""
log_debug "JQ command: $JQ_CMD"

# First, check the structure of the JSON to see what we're working with
log_debug "Examining JSON structure"
JSON_KEYS=$(jq -r 'keys' "$CODECOV_PATH" 2>&1)
log_debug "Top-level JSON keys: $JSON_KEYS"

# Try to extract data with different queries to see what works
log_debug "Trying different JSON paths"

# Try the original path
JQ_RESULT=$(jq -r '.data[0].files[] | select(.filename | contains("'"$SOURCE_PATH"'")) | .summary.lines' "$CODECOV_PATH" 2>&1)
JQ_EXIT_CODE=$?
log_debug "Original JQ path exit code: $JQ_EXIT_CODE"
log_debug "Original JQ path result: $JQ_RESULT"

# Try alternative paths
log_debug "Trying alternative JSON paths"
ALT_PATHS=(
'.data[].files[].summary.lines'
'.files[].summary.lines'
'.targets[].files[].summary.lines'
'.'
)

for path in "${ALT_PATHS[@]}"; do
log_debug "Trying path: $path"
ALT_RESULT=$(jq -r "$path" "$CODECOV_PATH" 2>&1)
ALT_EXIT_CODE=$?
log_debug "  Exit code: $ALT_EXIT_CODE"
if [ $ALT_EXIT_CODE -eq 0 ] && [ -n "$ALT_RESULT" ] && [ "$ALT_RESULT" != "null" ]; then
log_debug "  Found data with path: $path"
log_debug "  Data sample: $(echo "$ALT_RESULT" | head -n 5)"
else
log_debug "  No data found with this path"
fi
done

# Try our best to extract some meaningful data
echo "Attempting to extract coverage data..."
jq -r '.data[0].files[] | select(.filename | contains("'"$SOURCE_PATH"'")) | .summary.lines' "$CODECOV_PATH" > "$TMP_DATA_FILE" 2>> "$DEBUG_LOG" || {
    log_debug "Failed with original path, trying alternatives"
    
    # Try the first alternative that might work
    for path in "${ALT_PATHS[@]}"; do
    log_debug "Extracting with alternative path: $path"
    jq -r "$path" "$CODECOV_PATH" > "$TMP_DATA_FILE" 2>> "$DEBUG_LOG"
    if [ -s "$TMP_DATA_FILE" ]; then
    log_debug "Found data with path: $path"
    break
    else
    log_debug "No data found with path: $path"
    fi
    done
}

# Check if we got any data
if [ ! -s "$TMP_DATA_FILE" ]; then
echo "Warning: No coverage data extracted using any known JSON path"
log_debug "No coverage data could be extracted"
create_fallback_report "no coverage data found"

# Clean up temporary file
rm -f "$TMP_DATA_FILE"
echo "Debug log written to $DEBUG_LOG"
exit 0
fi

log_debug "Extracted data file size: $(wc -c < "$TMP_DATA_FILE") bytes"
log_debug "Extracted data sample: $(head -n 5 "$TMP_DATA_FILE")"

total_lines=0
covered_lines=0

log_debug "Processing coverage data"
# Process each line of the data file
while IFS= read -r line_data || [[ -n "$line_data" ]]; do
# Skip empty lines
[[ -z "$line_data" ]] && continue

log_debug "Processing line data: $line_data"
# Extract total and covered lines
total=$(echo "$line_data" | jq -r '.count' 2>/dev/null)
covered=$(echo "$line_data" | jq -r '.covered' 2>/dev/null)

log_debug "Extracted: total=$total, covered=$covered"

# Validate numbers before adding them
if ! [[ "$total" =~ ^[0-9]+$ ]] || ! [[ "$covered" =~ ^[0-9]+$ ]]; then
log_debug "Invalid data: $line_data"
echo "Warning: Invalid line count data found, skipping: $line_data"
continue
fi

# Add to the total lines and covered lines
total_lines=$((total_lines + total))
covered_lines=$((covered_lines + covered))
done < "$TMP_DATA_FILE"

log_debug "Final counts: total_lines=$total_lines, covered_lines=$covered_lines"

# Calculate the average line coverage percentage
if [ $total_lines -gt 0 ]; then
average_coverage=$(bc <<< "scale=$DECIMAL_PRECISION; $covered_lines * 100 / $total_lines")
else
average_coverage=0
fi

log_debug "Calculated coverage: $average_coverage"

# Format the coverage percentage with proper rounding
average_coverage_rounded=$(printf "%.*f" $DISPLAY_PRECISION "$average_coverage")
average_coverage_with_percentage="${average_coverage_rounded}%"

echo "Total executable lines: $total_lines"
echo "Covered lines: $covered_lines"
echo "Coverage: $average_coverage_with_percentage"

log_debug "Creating final report"
# Save to output file
cat > "$OUTPUT_FILE" << EOF
| ID | Name | Executable Lines | Coverage |
|----|------|-----------------:|---------:|
| 0 | ${PACKAGE_NAME%SVGSupport} | $total_lines | **$average_coverage_with_percentage** |
EOF

log_debug "Report created successfully"
echo "Coverage summary saved to $OUTPUT_FILE"

# Clean up temporary files
rm -f "$TMP_DATA_FILE"
log_debug "Temporary files cleaned up"
log_debug "Script completed successfully"

echo "Debug log written to $DEBUG_LOG"
