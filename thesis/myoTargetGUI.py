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
import CROSS



DEBUG = False


class app(Frame):
    def __init__(self, master=None):
        Frame.__init__(self, master)
        self.master = master

        defFontSize=8
        defSampTime=0.10
        defWidth=600
        defHeight=600
        defRad=20
        self.tarRad = defRad
        self.homeTarRad=defRad
        self.lefB = 0
        self.rigB = defWidth
        self.uppB = 0
        self.dowB = defHeight

        self.tarLB = (defWidth/2)-self.tarRad
        self.tarUB = (defHeight/2)-self.tarRad
        self.tarRB = (defWidth/2)+self.tarRad
        self.tarDB = (defWidth/2)+self.tarRad

        self.targetCoo = [self.tarLB, self.tarUB, self.tarRB, self.tarDB]
        self.homeTargetCoo = [self.tarLB, self.tarUB, self.tarRB, self.tarDB]
        self.canv = Canvas(root, highlightthickness=0)
        self.canv.pack(fill='both', expand=True)
        #self.top = self.canv.create_oval(0, 0, 645, 0, fill='green', tags=('top'))
        self.canv.bind_all('<Right>', self.move_right)
        self.canv.bind_all('<Left>', self.move_left)
        self.canv.bind_all('<Up>', self.move_up)
        self.canv.bind_all('<Down>', self.move_down)
        self.canv.bind_all('<Return>', self.startListener)
        self.screen = self.canv.create_oval(self.lefB, self.uppB, self.rigB, self.dowB, outline='black', fill='white',tags=('screen'))
        self.play = False
        self.restart = False
        listOfCircle=[]
        for i in range(0,10):
            ratio=(1-(i/20))
            diffW=ratio*defWidth
            diffH=ratio*defHeight
            a1=int(self.lefB-(diffW-defWidth))
            a2=int(self.uppB-(diffH-defHeight))
            a3=int(self.rigB+(diffW-defWidth))
            a4=int(self.dowB+(diffH-defHeight))
            a=self.canv.create_oval(a1,#self.lefB-(diffW-defWidth),
                                    a2,#self.uppB-(diffH-defHeight),
                                    a3,#self.rigB+(diffW-defWidth),
                                    a4,#self.dowB+(diffH-defHeight),
                                    outline='black')
            b=self.canv.create_text(defHeight/2,
                                  (self.uppB-(diffH-defHeight)-(0.05*defHeight)),
                                  font=("Purisa",defFontSize),
                                  text=str(int(100*(1-i/10)))
                                  )
            c = self.canv.create_text(defHeight / 2,(self.dowB + (diffH - defHeight) + (0.05 * defHeight)),font=("Purisa", defFontSize),text=str(-1 * int((100*(1-(i/10))))))
            d = self.canv.create_text((self.rigB + (diffW - defWidth) + (0.05 * defWidth)),defWidth / 2 ,font=("Purisa", defFontSize), text=str(int((100 * (1 - (i / 10))))))
            f = self.canv.create_text((self.lefB - (diffW - defWidth) - (0.05 * defWidth)),defWidth / 2 ,font=("Purisa", defFontSize), text=str(-1 * int((100 * (1 - (i / 10))))))

            listOfCircle.append(a)
            listOfCircle.append(b)

        self.cross = CROSS.cross(self.canv, self.lefB, self.uppB, self.rigB, self.dowB)
        self.target = self.canv.create_oval(self.tarLB+100, self.tarUB-50, self.tarRB+100, self.tarDB-50, outline='red',fill='yellow', tags=('target'))
        self.homeTarget = self.canv.create_oval(self.tarLB, self.tarUB, self.tarRB, self.tarDB, outline='gray',fill='green', tags=('homeTarget'))

        self.dt=2
        self.rt=3

        self.dtFlag=0
        self.rtFlag=0
        self.dtTimer=timerTimer(self.dt,0,self.dtFlag)
        self.rtTimer=timerTimer(self.rt,0,self.rtFlag)
        self.sampTimer = timerTimer(defSampTime, self.getSample, self.play)
        self.dataStampTimer=timerChrono()

        self.homeThread = threading.Event()
        self.targetThread = threading.Event()
        self.processThread = threading.Event()
        self.metricsThread = threading.Event()

        self.checkHome = threading.Thread(name='checkHome', target=self.waitingForHome, args=(self.homeThread, defSampTime /5))
        self.checkTarget = threading.Thread(name='checkTarget', target=self.runningSample, args=(self.targetThread, defSampTime/5))
        self.processStream = threading.Thread(name='processStream', target=self.fireProcess,args=(self.processThread, defSampTime))
        self.updateMetrics = threading.Thread(name='updateMetrics', target=self.updateTargetMetrics,args=(self.metricsThread, defSampTime))

    def startListener(self, event):
        if self.play == False:
            self.cross.teleport(-45,-45)
            self.updateMetrics.start()
            self.checkHome.start()
            try:
                self.processStream.start()
            except:
                pass
            self.sampTimer.start()
        else:
            pass

    def waitingForHome(self, homeFlag, t):
        self.status = 'HomeWait'
        print(self.status+' started')
        while not homeFlag.isSet():
            isCrossHome = homeFlag.wait(t)
            if isCrossHome:
                print('Wait Resting time: ', self.rt,' secs')
                self.rtTimer.start()
                self.status = 'RestWait'
                break
        print('Home Wait Done')

    def runningSample(self,targetFlag,t):
        self.status = 'Travelling'
        print(self.status + ' started')
        while not targetFlag.isSet():
            isTargetBeenHit = targetFlag.wait(t)
            if isTargetBeenHit:
                print('Wait Dwell time: ', self.dt, ' secs')
                self.dtTimer.start()
                self.status = 'WaitDwell'
                break
        print('Travelling Done')

    def fireProcess(self,flagEvent,t):
        print('Processing Stream started')
        while not flagEvent.isSet():
            print('inside process')
            stop = flagEvent.wait(t)
            if stop:
                print('inside if')
                break
            else:
                print('else')
                print('inside else process')
                angles=self.getNewMove()
                print('after get new moves')
                x=int(angles[0])
                y=int(angles[1])
                t=int(angles[2])
                print(x,y,t)
                #try:
                self.cross.teleport(x,y)#,t)#int(angles[0]), int(angles[1]))
                #except TypeError:
                 #   pass
        print('Processing Stream Done')

    def updateTargetMetrics(self,flagEvent,t):
        print('Processing Metrics is started')
        while not flagEvent.isSet():
            success = flagEvent.wait(t)
            if success:
                print('SUCCESS')
                with open('targetMetrics.csv', 'wb') as csvfile:
                    targetWriter = csv.writer(csvfile, delimiter=' ',quotechar='|', quoting=csv.QUOTE_MINIMAL)
                    targetWriter.writerow(self.getCCR(),self.getCCT(),self.getCPE(),self.getCO())
                break
        self.updateMetrics.start()

    def getSample(self):
        self.isTargetHit()
        self.isHomeHit()

    def getNewMove(self):
        flag=False
        while(not flag):
            print('inside while')
            try:
                fileMove=open("moves.txt")
                a=fileMove.readlines()
                
                print(a)
                fileMove.close()
                #if type(a)==str:
                a=a[0].split(',')
                print(a)
                flag=True
                return a
            except Exception as e:
                print(str(e))
                


                    # # shift_the_referenceFrame
        # wristTwist = shiftAngle
        #
        # phi = z_xy_angle
        # theta = x_zy_angle - shiftAngle
        # r = defWidth / 2
        #
        # leftRightSwap = x_zy_angle
        # upDownSwap = z_xy_angle
        #
        # distanceFromCenterPointZ = r * sin(z_xy_angle)
        #
        # x = r * sin(z_xy_angle) * cos(x_zy_angle)
        # y = r * sin(z_xy_angle) * sin(x_zy_angle)
        # z = r * cos(z_xy_angle)
    def getCCR(self):
       return 0
    def getCCT(self):
        a = self.completionTime
        self.completionTime = 0
        return a
    def getCPE(self):
        return 0
    def getCO(self):
        return 0
    def hideTarget(self):
        self.tarLB = -100
        self.tarUB = -100
        self.tarRB = -100
        self.tarDB = -100
        self.targetCoo = [self.tarLB, self.tarUB, self.tarRB, self.tarDB]
        self.canv.coords(self.target, self.targetCoo)
    def getNewTarget(self):
        r = self.tarRad
        R = self.rigB / 2

        targetMinLim = self.lefB + r
        targetMaxLim = self.dowB - r
        targetMaxAng = 360
        targetMaxDis = (self.rigB / 2) - r
        point = random.randint(targetMinLim, targetMaxDis)
        angle = random.randint(0, targetMaxAng)
        cooY = (point * math.sin(angle)) + targetMaxDis
        cooX = (point * math.cos(angle)) + targetMaxDis

        self.tarLB = cooX - r
        self.tarUB = cooY - r
        self.tarRB = cooX + r
        self.tarDB = cooY + r
        self.targetCoo = [self.tarLB, self.tarUB, self.tarRB, self.tarDB]
        self.canv.coords(self.target, self.targetCoo)
    def isHomeHit(self):
        print('check if hit home')
        targetCorner = [(self.canv.coords(self.homeTarget))[2], (self.canv.coords(self.homeTarget))[3]]
        barHCenter = [(self.canv.coords(self.cross.barH))[0] + (self.cross.lenBar / 2),(self.canv.coords(self.cross.barH))[1] + (self.cross.thiBar / 2)]
        if (((targetCorner[0] - (2 * self.tarRad)) <= barHCenter[0])) and (targetCorner[0] >= barHCenter[0]):
            if (targetCorner[1] - (2 * self.tarRad) <= barHCenter[1]) and (targetCorner[1] >= barHCenter[1]):
                if self.status == 'HomeWait':
                    self.homeThread.set()
                    #self.checkTarget.start()
                elif self.status == 'RestWait':
                    if self.rtFlag==True:
                        #self.status = 'Travelling'
                        print('here')
                        self.getNewTarget()
                        self.dataStampTimer.start()
                        self.checkTarget.start()
        else:
            self.rtTimer.restart()
    def isTargetHit(self):
        print('check if hit target')
        targetCorner = [(self.canv.coords(self.homeTarget))[2], (self.canv.coords(self.homeTarget))[3]]
        barHCenter = [(self.canv.coords(self.cross.barH))[0] + (self.cross.lenBar / 2),(self.canv.coords(self.cross.barH))[1] + (self.cross.thiBar / 2)]
        if (((targetCorner[0] - (2 * self.tarRad)) <= barHCenter[0])) and (targetCorner[0] >= barHCenter[0]):
            if (targetCorner[1] - (2 * self.tarRad) <= barHCenter[1]) and (targetCorner[1] >= barHCenter[1]):
                if self.status == 'Travelling':
                    self.targetThread.set()
                elif self.status == 'DwellWait':
                    if self.rtFlag == True:
                        #self.status = 'HomeWait'
                        self.HideTarget()
                        self.completionTime = self.dataStampTimer.stop()
                        self.metricsThread.set()
                        self.checkHome.start()
        else:
            self.dtTimer.restart()
    def move_right(self, event):
        self.canv.focus_set()
        if self.cross.checkRB() == True:
            self.cross.moveR()
     #   if self.isTargetHit(self.target,0):
      #      self.getNewTarget()
    def move_left(self, event):
        self.canv.focus_set()
        if self.cross.checkLB() == True:
            self.cross.moveL()
     #   if self.isTargetHit(self.target,0):
      #      self.getNewTarget()
    def move_up(self, event):
        self.canv.focus_set()
        if self.cross.checkUB() == True:
            self.cross.moveU()
     #   if self.isTargetHit(self.target,0):
      #      self.getNewTarget()
    def move_down(self, event):
        self.canv.focus_set()
        if self.cross.checkDB() == True:
            self.cross.moveD()
        #if self.isTargetHit(self.target,0):
         #   self.getNewTarget()

class timerChrono(object):
    def __init__(self):
        self.t0 = 0
        self.t1 = 0
        #self.flag = flag

    def start(self):
        self.t0=time.time()

    def stop(self):
        self.t1 = time.time() - self.t0
        return self.t1
class timerTimer(object):
    def __init__(self,cycle,getMethod,flag):
        self.t0 = 0
        self.t1 = 0
        self.flag = flag
        if getMethod == 0:
            self.TIMER = threading.Timer(cycle, self.stop)
        else:
            self.TIMER = threading.Timer(cycle, getMethod)

    def start(self):
        self.TIMER.start()  # after 30 seconds, "hello, world" will be printed

    def stop(self):
        self.flag=True
        self.TIMER.cancel()

    def restart(self):
        self.flag = False
        self.TIMER.cancel()
        self.start()

root = Tk()
root.title('Pointer V1')
# root.state('zoomed')
root.geometry('600x600')
app = app(master=root)
app.mainloop()
#root.mainloop()