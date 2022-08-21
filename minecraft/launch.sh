#!/bin/sh
ionice -c 1 -n 0 nice -20 java -Xmx4096M -Xms2048M -jar ../server.jar -nogui
