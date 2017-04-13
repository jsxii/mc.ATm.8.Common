@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "U:\home\Programm\i2c-rs\labels.tmp" -fI -W+ie -C V2E -o "U:\home\Programm\i2c-rs\i2c-rs.hex" -d "U:\home\Programm\i2c-rs\i2c-rs.obj" -e "U:\home\Programm\i2c-rs\i2c-rs.eep" -m "U:\home\Programm\i2c-rs\i2c-rs.map" "U:\home\Programm\i2c-rs\main.asm"
