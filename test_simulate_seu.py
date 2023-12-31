import sys

def read_file(file_path):
  with open(file_path, 'rb') as file:
    return bytearray(file.read())

def count_bit_diffs(data1, data2):
  if len(data1) != len(data2):
    print "ERROR: Files are of different sizes"
    return -1

  diff_count = 0
  for byte1, byte2 in zip(data1, data2):
    # XOR to find differing bits, then count the number of set bits
    diff_count += bin(byte1 ^ byte2).count('1')

  return diff_count

def calculate_percentage(total_bits, diff_bits):
  return (float(diff_bits) / total_bits) * 100

# Check if the script has the necessary command-line arguments
if len(sys.argv) != 3:
  print "Usage: python test_simulate_seu.py [file1] [file2]"
  sys.exit(1)

# Command-line arguments
file1_path = sys.argv[1]
file2_path = sys.argv[2]

# Read files
data1 = read_file(file1_path)
data2 = read_file(file2_path)

# Calculate bit differences
total_bits = len(data1) * 8
diff_bits = count_bit_diffs(data1, data2)

if diff_bits >= 0:
  percentage_diff = calculate_percentage(total_bits, diff_bits)
  print "Percentage of differing bits: {:.2f}%".format(percentage_diff)
else:
  sys.exit(1)

