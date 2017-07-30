import sys
from tkinter import *
import time
import math
import random
from collections import deque
import csv
import threading
import time
import logging


class cross(object):
    def __init__(self, canvas, lefB, uppB, rigB, dowB):
        self.canv = canvas
        self.maxXAngle=90
        self.maxYAngle=90
        self.LB = lefB
        self.UB = uppB
        self.RB = rigB
        self.DB = dowB
        self.thiBar = 4
        self.lenBar = 20
        self.defBarHlb = (self.RB / 2) - (self.lenBar / 2)
        self.defBarHub = (self.DB / 2) - (self.thiBar / 2)
        self.defBarHrb = (self.RB / 2) + (self.lenBar / 2)
        self.defBarHdb = (self.DB / 2) + (self.thiBar / 2)

        self.defBarVlb = (self.RB / 2) - (self.thiBar / 2)
        self.defBarVub = (self.DB / 2) - (self.lenBar / 2)
        self.defBarVrb = (self.RB / 2) + (self.thiBar / 2)
        self.defBarVdb = (self.DB / 2) + (self.lenBar / 2)

        self.curBarHlb = (self.RB / 2) - (self.lenBar / 2)
        self.curBarHub = (self.DB / 2) - (self.thiBar / 2)
        self.curBarHrb = (self.RB / 2) + (self.lenBar / 2)
        self.curBarHdb = (self.DB / 2) + (self.thiBar / 2)

        self.curBarVlb = (self.RB / 2) - (self.thiBar / 2)
        self.curBarVub = (self.DB / 2) - (self.lenBar / 2)
        self.curBarVrb = (self.RB / 2) + (self.thiBar / 2)
        self.curBarVdb = (self.DB / 2) + (self.lenBar / 2)

        self.stepSize = 1

        self.barH = self.canv.create_rectangle(self.defBarHlb, self.defBarHub, self.defBarHrb, self.defBarHdb,
                                               outline='black', fill='gray40', tags=('rectH'))
        self.barV = self.canv.create_rectangle(self.defBarVlb, self.defBarVub, self.defBarVrb, self.defBarVdb,
                                               outline='black', fill='gray40', tags=('rectV'))

        self.flagL = self.RB / 2 - (self.lenBar / 2) - 1
        self.flagU = self.DB / 2 - (self.lenBar / 2) - 1
        self.flagR = self.RB / 2 + (self.lenBar / 2) + 1
        self.flagD = self.DB / 2 + (self.lenBar / 2) + 1

    def checkLB(self):
        if self.flagL <= self.LB:
            return False
        else:
            return True

    def checkUB(self):
        if self.flagU <= self.UB:
            return False
        else:
            return True

    def checkRB(self):
        if self.flagR >= self.RB:
            return False
        else:
            return True

    def checkDB(self):
        if self.flagD >= self.DB:
            return False
        else:
            return True

    def smoothToBase(x, base=5):
        return int(base * round(float(x)/base))

    def teleport(self,x,y):
        x=(self.RB/2)+ ((x/self.maxXAngle)*(self.RB/2))
        y = (self.DB / 2) + ((y / self.maxYAngle) * (self.DB / 2))
        print(x,y)
        #x=self.smoothToBase(x)
        #y=self.smoothToBase(y)

        self.curBarHlb = x - (self.lenBar / 2)
        self.curBarHub = y - (self.thiBar / 2)
        self.curBarHrb = x + (self.lenBar / 2)
        self.curBarHdb = y + (self.thiBar / 2)

        self.curBarVlb = x - (self.thiBar / 2)
        self.curBarVub = y - (self.lenBar / 2)
        self.curBarVrb = x + (self.thiBar / 2)
        self.curBarVdb = y + (self.lenBar / 2)

        self.flagL = x - (self.lenBar/2)-self.stepSize
        self.flagR = x + (self.lenBar/2)+self.stepSize
        self.flagU = y - (self.lenBar/2)-self.stepSize
        self.flagD = y + (self.lenBar/2)+self.stepSize

        self.cooH = (self.curBarHlb, self.curBarHub, self.curBarHrb, self.curBarHdb)
        self.cooV = (self.curBarVlb, self.curBarVub, self.curBarVrb, self.curBarVdb)
        self.canv.coords(self.barH, self.cooH)
        self.canv.coords(self.barV, self.cooV)

    def moveR(self):
        self.curBarHlb += self.stepSize
        self.curBarHrb += self.stepSize
        self.curBarVlb += self.stepSize
        self.curBarVrb += self.stepSize
        self.flagL += self.stepSize
        self.flagR += self.stepSize

        self.cooH = (self.curBarHlb, self.curBarHub, self.curBarHrb, self.curBarHdb)
        self.cooV = (self.curBarVlb, self.curBarVub, self.curBarVrb, self.curBarVdb)
        self.canv.coords(self.barH, self.cooH)
        self.canv.coords(self.barV, self.cooV)

    def moveL(self):
        self.curBarHlb -= self.stepSize
        self.curBarHrb -= self.stepSize
        self.curBarVlb -= self.stepSize
        self.curBarVrb -= self.stepSize
        self.flagL -= self.stepSize
        self.flagR -= self.stepSize

        self.cooH = (self.curBarHlb, self.curBarHub, self.curBarHrb, self.curBarHdb)
        self.cooV = (self.curBarVlb, self.curBarVub, self.curBarVrb, self.curBarVdb)
        self.canv.coords(self.barH, self.cooH)
        self.canv.coords(self.barV, self.cooV)

    def moveU(self):
        self.curBarHub -= self.stepSize
        self.curBarHdb -= self.stepSize
        self.curBarVub -= self.stepSize
        self.curBarVdb -= self.stepSize
        self.flagU -= self.stepSize
        self.flagD -= self.stepSize

        self.cooH = (self.curBarHlb, self.curBarHub, self.curBarHrb, self.curBarHdb)
        self.cooV = (self.curBarVlb, self.curBarVub, self.curBarVrb, self.curBarVdb)
        self.canv.coords(self.barH, self.cooH)
        self.canv.coords(self.barV, self.cooV)

    def moveD(self):
        self.curBarHub += self.stepSize
        self.curBarHdb += self.stepSize
        self.curBarVub += self.stepSize
        self.curBarVdb += self.stepSize
        self.flagU += self.stepSize
        self.flagD += self.stepSize

        self.cooH = (self.curBarHlb, self.curBarHub, self.curBarHrb, self.curBarHdb)
        self.cooV = (self.curBarVlb, self.curBarVub, self.curBarVrb, self.curBarVdb)
        self.canv.coords(self.barH, self.cooH)
        self.canv.coords(self.barV, self.cooV)

    def getCrossCR(self):
        pass
    def getCrossCT(self):
        pass
    def getCrossPE(self):
        pass
    def getCrossO(self):
        pass
    def getLastRow(self, csvFile):
        with open(csvFile, 'r') as file:
            lastRow = None
            for lastRow in csv.reader(file):
                pass
            return lastRow
