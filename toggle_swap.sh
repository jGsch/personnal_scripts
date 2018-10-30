#!/bin/bash

# from https://gist.github.com/Jekis/6c8fe9dfb999fa76479058e2d769ee5c

function mem_stat () {
    mem_total="$(free | grep 'Mem:' | awk '{print $2}')"
    free_mem="$(free | grep 'Mem:'  | awk '{print $4}')"
    mem_percent=$(($free_mem * 100 / $mem_total))
    swap_total="$(free | grep 'Swap:' | awk '{print $2}')"
    used_swap="$(free | grep 'Swap:' | awk '{print $3}')"
    swap_percent=$(($used_swap * 100 / $swap_total))

    echo -e "Free memory:\t$((free_mem / 1024))/$((mem_total / 1024)) MB\t($mem_percent%)"
    echo -e "Used swap:\t$((used_swap / 1024))/$((swap_total / 1024)) MB\t($swap_percent%)"
}

echo "Testing..."
mem_stat

if [[ $used_swap -eq 0 ]]; then
    echo "No swap is in use."
elif [[ $used_swap -lt $free_mem ]]; then
    echo "Freeing swap..."

    sudo swapoff -a
    sudo swapon -a

    mem_stat
else
    echo "Not enough free memory. Exiting."
    exit 1
fi
