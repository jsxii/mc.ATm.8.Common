@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\Local\Programm\AVR\max7219-1\labels.tmp" -fI -W+ie -C V2E -o "C:\Local\Programm\AVR\max7219-1\max7219-1.hex" -d "C:\Local\Programm\AVR\max7219-1\max7219-1.obj" -e "C:\Local\Programm\AVR\max7219-1\max7219-1.eep" -m "C:\Local\Programm\AVR\max7219-1\max7219-1.map" "C:\Local\Programm\AVR\max7219-1\max7219-1.asm"
