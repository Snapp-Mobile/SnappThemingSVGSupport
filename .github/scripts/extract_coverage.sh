#!/bin/bash

# Environment variables
PACKAGE_NAME="SnappThemingSVGSupport"
SOURCE_PATH="$PACKAGE_NAME/Sources"
OUTPUT_FILE="pr_coverage_summary.txt"
DECIMAL_PLACES=6

# Get the path to the coverage report
CODECOV_PATH=$(swift test --enable-code-coverage --show-codecov-path)
echo "Using coverage report at: $CODECOV_PATH"

# Extract all line coverage data for files containing SOURCE_PATH
FILES_LINE_COUNTS=$(jq -r --arg path "$SOURCE_PATH" '.data[0].files[] | select(.filename | contains($path)) | .summary.lines' "$CODECOV_PATH")

total_lines=0
covered_lines=0

# Loop through each file's line count data
for lines_data in $(echo "$FILES_LINE_COUNTS" | jq -c '.'); do
  # Extract total and covered lines for each file
  total=$(echo "$lines_data" | jq '.count')
  covered=$(echo "$lines_data" | jq '.covered')

  # Add to the total lines and covered lines
  total_lines=$((total_lines + total))
  covered_lines=$((covered_lines + covered))
done

# Calculate the average line coverage percentage
if [ $total_lines -gt 0 ]; then
  average_coverage=$(echo "scale=$DECIMAL_PLACES; $covered_lines * 100 / $total_lines" | bc)
else
  average_coverage=0
fi

average_coverage_rounded=$(echo "$average_coverage" | awk '{print int($1 * 100 + 0.5) / 100}')
average_coverage_with_percentage="${average_coverage_rounded}%"

# Save to pr_coverage_summary.txt
cat <<EOF > "$OUTPUT_FILE"
| ID | Name | Executable Lines | Coverage |
|----|------|-----------------:|---------:|
| 0 | $PACKAGE_NAME | $total_lines | **$average_coverage_with_percentage** |
EOF

echo "Coverage report generated with $average_coverage_with_percentage coverage"
