#!/bin/bash

# usage: ./get_csv_element.sh <filename> <column> <row>

#unset env VAR:
unset AWS_ACCESS_KEY
unset AWS_SECRET_ACCESS_KEY

# Assign the input arguments to variables
filename=$1

# Use awk to extract the specific element
element_key=$(awk -F, -v col="1" -v row="2" '{if (NR==row) print $col}' "$filename")

element_secret=$(awk -F, -v col="2" -v row="2" '{if (NR==row) print $col}' "$filename")


# Print the element
echo "export AWS_ACCESS_KEY=$element_key" >> ~/.bashrc
echo "export AWS_SECRET_ACCESS_KEY=$element_secret" >> ~/.bashrc

source ~/.bashrc
