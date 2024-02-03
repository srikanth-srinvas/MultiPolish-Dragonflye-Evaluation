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

# Create a directory named "length" inside the directory of the input FASTA file
output_dir="$(dirname "$fasta_file")/length"
mkdir -p "$output_dir"

# Output CSV file for mean len in the "length" directory
csv_len_file="$output_dir/${file_prefix}_mean_len.csv"

# Extract len= values and calculate mean
awk '/^>/ { len_sum += gensub(/^.*len=([0-9]+).*$/, "\\1", "g", $0); len_count++; next } END { if (len_count > 0) print len_sum / len_count }' "$fasta_file" > "$csv_len_file"

echo "Mean of len values calculated. Result saved in $csv_len_file"