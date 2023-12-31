import os
import random
import sys

def flip_bit(byte, bit_position):
  """Flip the specified bit in a byte"""
  return byte ^ (1 << bit_position)

def simulate_seu(seu_target_file_path, seu_rate):
  """Simulate SEU on a file given its path and SEU rate"""
  if not os.path.exists(seu_target_file_path):
    print("ERROR: SEU target file does not exist")
    sys.exit(1)

  # Read file into memory
  with open(seu_target_file_path, "rb") as file:
    data = bytearray(file.read())

  total_bits = len(data) * 8
  num_flips = int(total_bits * seu_rate)

  # Randomly select bits to flip
  for _ in range(num_flips):
    bit_to_flip = random.randint(0, total_bits - 1)
    byte_index = bit_to_flip // 8
    bit_position = bit_to_flip % 8
    data[byte_index] = flip_bit(data[byte_index], bit_position)

  # Write data back to file
  with open(seu_target_file_path, "wb") as file:
    file.write(data)

# Check if the script has the necessary command-line arguments
if len(sys.argv) != 3:
  print("Usage: python simulate_seu.py [seu_target_file_path] [seu_rate]")
  sys.exit(1)

# Command-line arguments
seu_target_file_path = sys.argv[1]
try:
  seu_rate = float(sys.argv[2])
except ValueError:
  print("ERROR: SEU rate must be a float")
  sys.exit(1)

# Simulate SEU on target file at given rate
simulate_seu(seu_target_file_path, seu_rate)
print("QAPLA': SEU simulation completed")
sys.exit(0)

