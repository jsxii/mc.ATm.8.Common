#!/usr/bin/python
# -*- coding: utf-8 -*-

def main():

#    send('hello world')
    send(chr(1))

    

def send(msg):
    try:
#        ser = serial.Serial(0)
        port = serial.Serial(port=comport, baudrate=baudrate)
        port.isOpen()
    except Exception as exc:
        sys.exit("[%s: %s]" % (type(exc).__name__, str(exc)))
    msgint = []
    global seqnum
    msgint.append(int(0x1B))	# message start.
    seqnum =+ 1
    if seqnum == 256: seqnum = 0
    msgint.append(seqnum)
    size = len(msg)
    hsize = int(size / 256)
    lsize = size - hsize * 256
    if hsize > 255: sys.exit("-- Message larger than 65535 bytes.")
    if lsize < 0: sys.exit("-- Wrong message size computing.")
    msgint.append(hsize)
    msgint.append(lsize)
    msgint.append(int(0x0E))	# token
    for sym in msg:
        msgint.append(ord(sym))
    crc = 0
    for code in msgint:
        crc = crc ^ code
    msgint.append(crc)
    msgbin = r''
    for code in msgint:
        msgbin += chr(code)
# SEND
    open('z.send02.log', 'wb').write(msgbin)
    port.write(msgbin)
    out = r''
    time.sleep(1)
    while port.inWaiting() > 0:
        out += port.read(1)
    open('z.recv02.log', 'wb').write(out)
    return
#------------------------------------------------------------
'''
MESSAGE_START	1 байт	Здесь всегда 0x1B.
SEQUENCE_NUMBER	1 байт	Инкрементируется на 1 с каждым отправляемым сообщением. Обращается в 0xFF по достижении значения 0xFF.
MESSAGE_SIZE	2 байта, старший байт MSB идет первым.	Размер тела сообщения(1) (поле MESSAGE_BODY).
TOKEN	1 байт	Здесь всегда 0x0E.
MESSAGE_BODY	MESSAGE_SIZE байт	Тело сообщения, размер 0..65535 байт(1).
CHECKSUM	1 байт	Контрольная сумма. Для её подсчета учитываются все байты в сообщении от MESSAGE_START до MESSAGE_BODY включительно. Контрольная сумма вычисляется операцией XOR от всех байт.
'''
#------------------------------------------------------------
import serial
import sys
import time
#------------------------------------------------------------
seqnum = 0
comport = 'COM1'
baudrate = 115200
#------------------------------------------------------------
main()
