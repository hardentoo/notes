#!/bin/bash

function working() {
    start=$1
    end=$2
    hour=$(date +%H)
    stamp=$(date +"%I:%M %p %a  ")
    echo -n "$stamp  "
    if (( hour >= start && hour < end )); then
        echo -n "[32m"
    else
        echo -n "[31m"
    fi
    echo -n $3
    echo "[0m"
}

TZ=US/Pacific     working 8 17 "Bartosz Milewski"
TZ=US/Central     working 12 20 "John Wiegley"
TZ=Europe/London  working 8 17 "Duncan Coutts"
TZ=Europe/Rome    working 9 18 "Christopher Done"
TZ=Asia/Jerusalem working 5 14 "Michael Snoyman"
