@echo off
wsl -d docker-desktop sh -c "echo 3 > '/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf 'Ram-cache and Swap Cleared\n'"

timeout /t 2