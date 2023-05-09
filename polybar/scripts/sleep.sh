#!/bin/sh

echo mem | tee /sys/power/state 2> failed
echo $USER >> failed
