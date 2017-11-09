#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial
import time
import random
import math
import pygame

__author__ = 'Paul Chase'


class Sand_Trace(object):
    MOTOR_DIST = 217

    def __init__(self):
        #TODO: serial port chooser :-)
        self.serial = serial.Serial('/dev/ttyACM0',115200)
        
        # Wake up grbl
        self.serial.write("\r\n\r\n".encode())
        time.sleep(2)   # Wait for grbl to initialize 
        self.serial.flushInput()  # Flush startup text in serial input

        # Stream g-code to grbl
        for x in range(0,10):
            self.send_move( 10, 10)
            self.send_move( 10, 50)
            self.send_move( 50, 50)
            self.send_move( 50, 10)

        self.serial.close()


    def send_move(self, x, y):
        dist = self.MOTOR_DIST
        print('Converting: ( ' + str(x) +  " , " + str(y) + ' )')
        
        
        
        a = math.sqrt(x*x+y*y)
        b = math.sqrt(x*x+(dist-y)*(dist-y))

        move = "G0 X"+str(a)+" Y"+str(b) + "\n"

        print('Sending: ' + move)
        self.serial.write(move.encode())
        self.grbl_out = self.serial.readline()
        print(' : ' + move.strip())

if __name__ == '__main__':
    app = Sand_Trace()
