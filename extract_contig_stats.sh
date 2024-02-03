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
file_name=$(basename "$fasta_file" .fasta)

# Create a directory named "contig_info" inside the directory of the input FASTA file
output_dir="$(dirname "$fasta_file")/contig_info"
mkdir -p "$output_dir"

# Output CSV file in the "contig_info" directory
csv_file="$output_dir/${file_name}_contig_stats.csv"

# Count the number of contigs and circular contigs
num_contigs=$(grep -c "^>" "$fasta_file")
num_circular_contigs=$(grep -c "^>.*circular=Y" "$fasta_file")

# Write the result to the CSV file without column headers
echo "$file_name,$num_contigs,$num_circular_contigs" >> "$csv_file"

echo "Contig statistics calculated. Result saved in $csv_file"
