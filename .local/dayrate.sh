#!/bin/sh

if [ $(date +%H) -gt 16 ] && [ $(date +%D) != $(cat ~/.local/scripts/lastchanged) ]
then
    echo "Vill du betygsätta dagen nu? (y/n)"
    read continue
    if [ $continue != "y" ]
    then
	exit 0
    fi

    date +%D > ~/.local/scripts/lastchanged
    echo "Betygsätt hur din dag har varit från 1-10:"
    read grade

    date +%d/%m/%y >> ~/betyg.txt
    echo $grade >> ~/betyg.txt

    echo "Några extra kommentarer?"
    read comments

    [ -n "$comments" ] && echo $comments >> ~/betyg.txt

    echo "" >> ~/betyg.txt
    
fi
