#!/usr/bin/env python3 

# script to replace less standardized C types such as u32_t, used in linux,
# zephyr and a lot of other places, to respective stdint.h type.  
# Alternative use clang-rename from clang-tools - it is
# probably safer but requries more setup.

import sys
import re

TEST = """
	s8_t txy1, txy2;
	s16_t* s16p=(s16_t*)x; // no space
	s16_t* s16p = (s16_t*) x; // space
	s16_t** s16p = (s16_t**) NULL; 
        int s16_t_ = 0;
        u32_t x = 0;
u32_t x = 0;
"""

def replace_type(s, from_t, to_t):
    return re.sub(
            r'([^a-zA-Z\d:])' + re.escape(from_t) + r'([^a-zA-Z\d:])', 
            r'\1' + re.escape(to_t) + r'\2', 
            s
    )
RENAME_LUT = [
    ('u8_t',  'uint8_t'),
    ('u16_t', 'uint16_t'),
    ('u32_t', 'uint32_t'),
    ('u64_t', 'uint64_t'),
    ('s8_t',  'int8_t'),
    ('s16_t', 'int16_t'),
    ('s32_t', 'int32_t'),
    ('s64_t', 'int64_t')
]

def reformat_line(s):
    for item in RENAME_LUT:
        s = replace_type(s, item[0], item[1])
    return s

def main():
    filename = sys.argv[1]
    with open(filename) as f:
        lines = f.readlines()

    #lines = TEST.splitlines()
    #print("#warning \"Remove this when output is confirmed\"")
    for line in lines:
        print(reformat_line(line), end="")
        #print(reformat_line(line))

main()
