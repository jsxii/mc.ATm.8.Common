#!/usr/bin/python
# -*- coding: utf-8 -*-

import serial

#port = serial.Serial(port='', baudrate=9600, parity=serial.PARITY_ODD, stopbits=serial.STOPBITS_TWO, bytesize = serial.SEVENBITS)
#try:
#    port = serial.Serial(port='COM6', baudrate=115200)
#    port.isOpen()
#except Exception as exc:
#    print "[%s: %s]" % (type(exc).__name__, str(exc))

a = 255
b = 31
c = a ^ b

print c
print bin(c)
print chr(c)