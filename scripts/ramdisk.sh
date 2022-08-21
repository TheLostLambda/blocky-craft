sudo inotifywait -m -e close_write -r /dev/shm --format "%w%f" | while read file; do; echo "Saving $file"; rsync -a "$file" "/home/tll/ServerDirs/Minecraft/${file#/dev/shm/}"; done
