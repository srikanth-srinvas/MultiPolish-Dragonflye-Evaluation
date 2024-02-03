#!/bin/bash

# Check for the correct number of command-line arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_fasta_file>"
    exit 1
fi

# Input FASTA file
fasta_file="$1"

# Check if the input file exists
if [ ! -f "$fasta_file" ]; then
    echo "Error: File $fasta_file not found."
    exit 1
fi

# Extract file name without extension
file_prefix=$(basename "$fasta_file" .fasta)

# Output CSV file in the same directory as the input file
csv_file="$(dirname "$fasta_file")/${file_prefix}_mean_cov.csv"

# Extract cov= values and calculate mean
awk '/^>/ { sum += gensub(/^.*cov=([0-9.]+).*$/, "\\1", "g", $0); count++; next } END { if (count > 0) print sum / count }' "$fasta_file" > "$csv_file"

echo "Mean of cov values calculated. Result saved in $csv_file"
