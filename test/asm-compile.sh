#!/bin/bash

# Assemble the source file
arm-none-eabi-as -march=armv4 -o a1.o a1.s

# Disassemble the object file
arm-none-eabi-objdump -d a1.o > disassembly.txt

# Extract the hexadecimal opcodes
awk '{print $2}' disassembly.txt | grep -v '^$' | grep -E '^[[:xdigit:]]{8}$' > opcodes.txt

# Reverse the byte order and convert to a hex array
while read line; do
    if [ ! -z "$line" ]; then
        echo $line | xxd -r -p | xxd -p | tac -rs.. | tr -d '\n' | fold -w2
        echo
    fi
done < opcodes.txt | awk NF > hex_array.txt

# Count lines in the hex array
line_count=$(wc -l < hex_array.txt)

# If there are fewer than 4096 lines, append zeros until there are 4096
while [ $line_count -lt 4096 ]; do
    echo "00" >> hex_array.txt
    line_count=$((line_count+1))
done

# Print the hex array
#cat hex_array.txt

# copy file to sim folder
cp -f hex_array.txt ../Pipelined.sim/sim_1/behav/xsim/imem_data.txt