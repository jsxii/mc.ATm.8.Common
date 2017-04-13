@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "U:\home\Programm\a05-disp-03\labels.tmp" -fI -W+ie -C V2E -o "U:\home\Programm\a05-disp-03\a05-disp-03.hex" -d "U:\home\Programm\a05-disp-03\a05-disp-03.obj" -e "U:\home\Programm\a05-disp-03\a05-disp-03.eep" -m "U:\home\Programm\a05-disp-03\a05-disp-03.map" "U:\home\Programm\a05-disp-03\00.main.asm"
