@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "C:\Local\_github\mc.ATm.8.Common\01-RTOS\labels.tmp" -fI -W+ie -C V2E -o "C:\Local\_github\mc.ATm.8.Common\01-RTOS\01-RTOS.hex" -d "C:\Local\_github\mc.ATm.8.Common\01-RTOS\01-RTOS.obj" -e "C:\Local\_github\mc.ATm.8.Common\01-RTOS\01-RTOS.eep" -m "C:\Local\_github\mc.ATm.8.Common\01-RTOS\01-RTOS.map" "C:\Local\_github\mc.ATm.8.Common\01-RTOS\main.asm"
