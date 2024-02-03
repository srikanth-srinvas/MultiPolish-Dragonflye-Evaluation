import sys
import os
import re

def parse_busco_summary(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    species_name = os.path.basename(file_path).replace('short_summary.specific.enterobacterales_odb10.', '').replace('.txt', '')
    
    # Use regular expression to extract various percentages from the line
    summary_line = next(line for line in lines if 'C:' in line)
    
    complete_percentage = float(re.search(r'C:(\d+\.\d+)%', summary_line).group(1))
    single_percentage = float(re.search(r'S:(\d+\.\d+)%', summary_line).group(1))
    duplicate_percentage = float(re.search(r'D:(\d+\.\d+)%', summary_line).group(1))
    fragmented_percentage = float(re.search(r'F:(\d+\.\d+)%', summary_line).group(1))
    missing_percentage = float(re.search(r'M:(\d+\.\d+)%', summary_line).group(1))
    
    # Extract 'n' value
    n_value = int(re.search(r'n:(\d+)', summary_line).group(1))

    return [species_name, complete_percentage, single_percentage, duplicate_percentage, fragmented_percentage, missing_percentage, n_value]

def main():
    # Check if the command-line argument is provided
    if len(sys.argv) != 2:
        print("Usage: python busco_summarise_results.py /path/to/busco_summaries/")
        sys.exit(1)

    busco_directory = sys.argv[1]  # Get the input directory from the command line
    output_csv = os.path.join(busco_directory, "output_new.csv")  # Output file in the same directory

    # Get a list of all BUSCO summary files
    busco_files = [os.path.join(busco_directory, file) for file in os.listdir(busco_directory) if file.endswith(".txt")]

    # Parse each BUSCO summary file
    data = [parse_busco_summary(file) for file in busco_files]

    # Write the summary data to a CSV file
    with open(output_csv, 'w') as csv_file:
        csv_file.write("Species,Complete_Percentage,Single_Percentage,Duplicate_Percentage,Fragmented_Percentage,Missing_Percentage,n_value\n")
        for species, c_percentage, s_percentage, d_percentage, f_percentage, m_percentage, n_value in data:
            csv_file.write(f"{species},{c_percentage},{s_percentage},{d_percentage},{f_percentage},{m_percentage},{n_value}\n")

if __name__ == "__main__":
    main()
