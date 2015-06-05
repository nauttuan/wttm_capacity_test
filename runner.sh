#!/bin/bash

optimization_level=$1

echo `make clean`
echo `make opt$optimization_level`

stride_powers=(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17)
numReadLines=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072)
numWriteLines=(1 2 4 8 16 32 64 128 256 512) 

for s in "${stride_powers[@]}"
do 

    echo -e "\n###################"
    echo -e "### Stride: 2^$s"
    echo -e "###################"
    
    echo -e "\nRead-Only"
    for n in "${numReadLines[@]}" 
    do
        read_out=`./capacity_test $n $s 0`
        if [[ $read_out == *" 0/"* ]]
        then
            echo -e "FAIL: no committed transactions of size $n cache lines with stride 2^$s"
            break
        else
            echo -e "$read_out transactions of size $n cache lines with stride 2^$s"
        fi
    done
    
    echo -e "\nWrite-Only"
    for n in "${numWriteLines[@]}"
    do
        write_out=`./capacity_test $n $s 1`
        if [[ $write_out == *" 0/"* ]]
        then
            echo -e "FAIL: no committed transactions of size $n cache lines with stride 2^$s"
            break
        else
            echo -e "$write_out transactions of size $n cache lines with stride 2^$s"
        fi
    done

done
