@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "U:\home\Programm\a02-uart-iis\labels.tmp" -fI -W+ie -C V2E -o "U:\home\Programm\a02-uart-iis\a02-uart-iis.hex" -d "U:\home\Programm\a02-uart-iis\a02-uart-iis.obj" -e "U:\home\Programm\a02-uart-iis\a02-uart-iis.eep" -m "U:\home\Programm\a02-uart-iis\a02-uart-iis.map" "U:\home\Programm\a02-uart-iis\main.asm"
