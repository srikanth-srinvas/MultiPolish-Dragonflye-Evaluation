import os
import csv
import re
import glob

def extract_values_from_log(log_file_path):
    with open(log_file_path, 'r') as log_file:
        content = log_file.read()
        
        # Extracting values using regular expressions
        total_bp_match = re.search(r'\[dragonflye\] Read stats: total_bp = (\d+)', content)
        depth_match = re.search(r'\[dragonflye\] Estimated sequencing depth: (\d+)x', content)
        
        if total_bp_match and depth_match:
            total_bp = total_bp_match.group(1)
            sequencing_depth = depth_match.group(1)
            
            return total_bp, sequencing_depth
        else:
            return None, None

def process_directory(directory_path, output_csv_path):
    with open(output_csv_path, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        
        # Write header to the CSV file
        csv_writer.writerow(['Directory', 'Total_BP', 'Sequencing_Depth'])
        
        # Iterate through directories
        for root, dirs, files in os.walk(directory_path):
            for d in dirs:
                log_file_path = os.path.join(root, d, 'dragonflye_out_1', d, '*.log')
                log_file_matches = glob.glob(log_file_path)
                
                if log_file_matches:
                    log_file_path = log_file_matches[0]  # Assuming there's only one matching log file
                    
                    total_bp, sequencing_depth = extract_values_from_log(log_file_path)
                    
                    if total_bp is not None and sequencing_depth is not None:
                        csv_writer.writerow([d, total_bp, sequencing_depth])

# Replace 'your_directory_path' with the actual path to the parent directory containing subdirectories
directory_path = '/path/to/your/parent_directory'

# Replace 'output.csv' with the desired output CSV file name
output_csv_path = '/path/to/your/output_directory/depth_out.csv'

process_directory(directory_path, output_csv_path)
