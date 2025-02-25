#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error and exit immediately

# Define environment variables
PACKAGE_NAME="SnappThemingSVGSupport"
SOURCE_PATH="$PACKAGE_NAME/Sources"
OUTPUT_FILE="pr_coverage_summary.txt"
DECIMAL_PRECISION=6
DISPLAY_PRECISION=2

# Get the path to the coverage report
CODECOV_PATH=$(swift test --enable-code-coverage --show-codecov-path)
echo "Using coverage report at: $CODECOV_PATH"

# Extract all line coverage data for files containing the specified source path
# Use a temporary file for the extracted data to avoid command substitution issues
TMP_DATA_FILE=$(mktemp)
jq -r --arg source_path "$SOURCE_PATH" '.data[0].files[] | select(.filename | contains($source_path)) | .summary.lines' "$CODECOV_PATH" > "$TMP_DATA_FILE"

total_lines=0
covered_lines=0

# Process each line of the data file
while IFS= read -r line_data || [[ -n "$line_data" ]]; do
  # Skip empty lines
  [[ -z "$line_data" ]] && continue

  # Extract total and covered lines
  total=$(echo "$line_data" | jq -r '.count')
  covered=$(echo "$line_data" | jq -r '.covered')

  # Validate numbers before adding them
  if ! [[ "$total" =~ ^[0-9]+$ ]] || ! [[ "$covered" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid line count data found"
    exit 1
  fi

  # Add to the total lines and covered lines
  total_lines=$((total_lines + total))
  covered_lines=$((covered_lines + covered))
done < "$TMP_DATA_FILE"

# Calculate the average line coverage percentage
if [ $total_lines -gt 0 ]; then
  average_coverage=$(bc <<< "scale=$DECIMAL_PRECISION; $covered_lines * 100 / $total_lines")
else
  average_coverage=0
fi

# Format the coverage percentage with proper rounding
average_coverage_rounded=$(printf "%.*f" $DISPLAY_PRECISION "$average_coverage")
average_coverage_with_percentage="${average_coverage_rounded}%"

echo "Total executable lines: $total_lines"
echo "Covered lines: $covered_lines"
echo "Coverage: $average_coverage_with_percentage"

# Save to output file
cat > "$OUTPUT_FILE" << EOF
| ID | Name | Executable Lines | Coverage |
|----|------|-----------------:|---------:|
| 0 | ${PACKAGE_NAME%SVGSupport} | $total_lines | **$average_coverage_with_percentage** |
EOF

echo "Coverage summary saved to $OUTPUT_FILE"

# Clean up temporary files
rm -f "$TMP_DATA_FILE"
