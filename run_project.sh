#!/bin/bash

Rscript ./install_r_library.R
clear

python ./main_script.py
Rscript ./src/part_3_graphs.R
Rscript ./src/part_4_5.r

echo ""
echo "################### End of Execution #####################"
echo ""
