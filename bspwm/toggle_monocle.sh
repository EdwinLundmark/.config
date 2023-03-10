#!/bin/sh

if [ $(bspc config top_monocle_padding) == 0 ]
then
    bspc config right_monocle_padding 10 
    bspc config left_monocle_padding 10  
    bspc config bottom_monocle_padding 10
    bspc config top_monocle_padding 10
else
    bspc config right_monocle_padding 0 
    bspc config left_monocle_padding 0  
    bspc config bottom_monocle_padding 0
    bspc config top_monocle_padding 0
fi
