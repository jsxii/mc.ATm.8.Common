@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\Local\_github\mc.ATm.8.Common\aa-dumb-spi\labels.tmp" -fI -W+ie -C V2E -o "C:\Local\_github\mc.ATm.8.Common\aa-dumb-spi\aa-dumb-spi.hex" -d "C:\Local\_github\mc.ATm.8.Common\aa-dumb-spi\aa-dumb-spi.obj" -e "C:\Local\_github\mc.ATm.8.Common\aa-dumb-spi\aa-dumb-spi.eep" -m "C:\Local\_github\mc.ATm.8.Common\aa-dumb-spi\aa-dumb-spi.map" "C:\Local\_github\mc.ATm.8.Common\aa-dumb-spi\main.asm"