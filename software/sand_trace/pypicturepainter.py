#! /usr/bin/env python

#pypicturepainter.py
#And excercise in artistic expression
#
#Instructions see pypicturepainter.rtf
#
#Jestermon.weebly.com
#jestermonster@gmail.com




#import needed libraries
import sys, pygame, string
from pygame.locals import *

#some useful global variables
global mouseX,mouseY
global mousedown
global mousebutton
global currenttool 
global currentkey
global currenttext
global fontimg
global font
global bgimagename
global bgimage
global imgoffset
global bgclip
global bgcliprect
global bgimagerect
global toolsize
global toolimg
global toolcolor
global toolimg
global spacetoggle 
global screen
global drawimg
global drawclip
global drawcliprect
global commatoggle
global basefilename

#Setup screen and initialize the pygame system
size = width, height = 800, 600
#screen = pygame.display.set_mode((size),FULLSCREEN)
screen = pygame.display.set_mode((size))
pygame.display.set_caption("Jestermon's Python Picture Painter")
pygame.init()

#some useful colors
BLACK = 0,0,0
WHITE = 255,255,255
GREY1 = 100,100,100
GREY2 = 130,130,130
GREY3 = 180,18,180
GREYX = 255,255,254
RED   = 255,0,0,0
GREEN = 0,255,0
BLUE  = 0,0,255

#some useful variables
basefilename = ""
drawclip = None
drawcliprect = None
drawimg = None
spacetoggle = False
commatoggle = False
toolimg = None
toolcolor = WHITE
mousedown = False
toolimg = None
mousebutton = None
imageoffset = 0
imagezoom = 1
toolcolor = BLACK
toolsize = 20
bgimagename = ""
saveimagename = ""
bgimage = None
currenttool = None
currenttext = ""
font = pygame.font.Font(None,25)
fontimg = font.render(currenttext, 0, BLACK)
imgoffset = (0,0)
bgclip = pygame.Surface((600, 600))
bgcliprect = bgclip.get_rect()
bgimagerect = None

#tool selection co-ords
tools = []
load_tool = ("load",18,13,72,62)
tools.append(load_tool)
save_tool = ("save",106,14,169,70)
tools.append(save_tool)
paint_tool = ("paint",14,91,78,152)
tools.append(paint_tool)
blur_tool = ("blur",104,88,164,154)
tools.append(blur_tool)
size_down_tool = ("sizedown",2,179,37,205)
tools.append(size_down_tool)
size_up_tool = ("sizeup",151,170,172,206)
tools.append(size_up_tool)
eraser_tool = ("eraser",17,230,38,301)
tools.append(eraser_tool)
move_up_tool = ("moveup",109,239,132,255)
tools.append(move_up_tool)
move_down_tool = ("movedown",106,272,134,295)
tools.append(move_down_tool)
move_left_tool = ("moveleft",84,252,108,274)
tools.append(move_left_tool)
move_right_tool = ("moveright",135,252,157,276)
tools.append(move_right_tool)
zoom_in_tool = ("zoomin",29,334,62,365)
tools.append(zoom_in_tool)
zoom_out_tool = ("zoomout",102,333,141,365)
tools.append(zoom_out_tool)
color_picker_tool = ("pickcolor",9,407,183,550)
tools.append(color_picker_tool)
close_dialog_tool = ("closedialog",676,293,699,320)
tools.append(close_dialog_tool)                     

#load the loaddialog image
loadimg = pygame.image.load("loaddialog.png").convert()
loadimgrect = loadimg.get_rect()

#load the savedialog image
saveimg = pygame.image.load("savedialog.png").convert()
saveimgrect = saveimg.get_rect()

#load the toolbar image
toolbar = pygame.image.load("toolbar.png").convert()
toolbarrect = toolbar.get_rect()

#load the hand cursor
cursor_hand = pygame.image.load("cursor-hand.png").convert()
cursor_handrect = cursor_hand.get_rect()
cursor_hand_alphakey = cursor_hand.get_at((0, 0)) #get picel at 1,1
cursor_hand.set_colorkey(cursor_hand_alphakey) #set image transparency

#setup cursor data
cursors = []
cursor = (0,cursor_hand,cursor_handrect,(6,1)) #cursor_id,image,rect,hot-spot
cursors.append(cursor)
current_cursor = cursors[0]  #default pointing hand cursor

#display the toolbar
screen.blit (toolbar, (0,0)) 

#hide the normal mouse cursor
pygame.mouse.set_visible(False)

#function to replace all text in a string
def replaceall(s,s1,s2):
    ss = s
    p = string.find(ss,s1)
    while p > -1:
        p = string.find(ss,s1)
        if p < 0:
            break
        ss = ss[:p]+s2+ss[p+len(s1):]
        p = string.find(ss,s1)
    return ss

#function to display the current cursor
def show_cursor(cursor):
    #dont draw cursor if mouse is outside window
    if mouseY < 3 or mouseX < 3:
        return
    cursor_id = cursor[0]
    cursor_image = cursor[1]
    cursor_rect = cursor[2]
    cursor_hotspot = cursor[3]
    screen.blit(cursor_image,(mouseX,mouseY))

#Sets and returns the current tool
def gettool():
    for tool in tools:
        toolname,x1,y1,x2,y2 = tool
        if mouseX >= x1 and mouseX <= x2 and mouseY >= y1 and mouseY <= y2:
            return toolname
    return None

#create a new drawing subsurface because we moved the background image
def new_draw_surface():
    global drawimg
    global drawclip
    global imgoffset
    global bgimage
    global drawcliprect
    rect = bgimage.get_rect()
    x,y = imgoffset
    x1,y1,x2,y2 = rect
    w = x2+x
    h = y2+y
    if w > 600:
        w = 600
    if h > 600:
        h = 600
    x = abs(x)
    y = abs(y)
    if bgimage:
        drawclip = drawimg.subsurface((x,y,w,h))
        drawcliprect = drawclip.get_rect()

#function to do the actual painting
def paint():
    global drawimg
    global drawclip
    global toolimg
    global imgoffset
    global toolsize
    x,y = imgoffset
    xpos = mouseX - int(toolsize/2) -200
    ypos = mouseY - int(toolsize/2) 
    if drawimg and not spacetoggle:
        drawclip.blit(toolimg,(xpos,ypos))

#function to paint eraser color onto image
def erase():
    return  #we need to work at surfacearray level .. version 2

#function to save file
def savefile():
    global drawimg
    global basefilename
    p = string.find(basefilename,".")
    if p > -1:
        savefilename = basefilename[:p]+".png"
        pygame.image.save(drawimg, savefilename)        

#function to load working drawing if it exists
def load_drawing():
    global drawimg
    global basefilename
    p = string.find(basefilename,".")
    if p > -1:
        savefilename = basefilename[:p]+".png"
        drawimg = pygame.image.load(savefilename).convert()
        drawimg.set_colorkey(GREYX)
        new_draw_surface()
    
def process_tool():
    global currenttool
    global fontimg
    global imgoffset
    global bgimagerect
    global toolsize
    global toolcolor
    global spacetoggle
    global drawimg
    #smudge, erase and zoom to be implemented in V2
    if currenttool == "eraser" and mousedown and mouseX > 200:
        erase()
    if currenttool == "paint" and mousedown and  mouseX> 200:
        paint()
    #if space bar is toggled, pick up a color from anywhere on the screen
    #These two lines are the heart of this painter program
    if spacetoggle and mousedown:
        toolcolor = screen.get_at((mouseX,mouseY))
    if currenttool == "load":
        screen.blit(loadimg,(120,200))
        screen.blit(fontimg,(140,300))
    if currenttool == "save" and drawimg:
        savefile()
        currenttool = ""
    try: #catch error if background image is not loaded yet
        if currenttool == "moveleft" and mousedown:
            x,y = imgoffset
            x-=1
            x1,y1,x2,y2 = bgimagerect
            if x2 <= 600:
                return
            diff = 600 - x2
            if x < diff:
                x = diff
            imgoffset = (x,y)
            currenttool = ""
            new_draw_surface()
    except:
        pass
    if currenttool == "moveright" and mousedown:
        x,y = imgoffset
        x+=1
        if x > 0:
            x = 0
        imgoffset = (x,y)
        currenttool = ""
        new_draw_surface()
    try:  #catch error if background image is not loaded yet
        if currenttool == "moveup" and mousedown:
            x,y = imgoffset
            y-=1
            x1,y1,x2,y2 = bgimagerect
            if y2 <= 600:
                return
            diff = 600 - y2
            if y < diff:
                y = diff
            imgoffset = (x,y)
            currenttool = ""
            new_draw_surface()
    except:
        pass
    if currenttool == "movedown" and mousedown:
        x,y = imgoffset
        y+=1
        if y > 0:
            y = 0
        imgoffset = (x,y)
        currenttool = ""
        new_draw_surface()
    if currenttool == "sizedown" and mousedown:        
        toolsize -=0.25
        if toolsize < 2:
            toolsize = 2
        make_tool()           
        currenttool = ""
    if currenttool == "sizeup" and mousedown:
        toolsize +=0.25
        if toolsize > 70:
            toolsize = 70
        make_tool()
        currenttool = ""
    if currenttool == "pickcolor" and mousedown:
        if mouseX < 200:
            toolcolor = toolbar.get_at((mouseX,mouseY))
        currenttool = ""
        
#function to process mouse events
def process_mouse_events():
    global currenttool
    global currenttext
    if mousedown:
        tool = gettool()
        if tool:
            currenttext = ""
            currenttool = tool

#function to load the background image
def loadbgimage(imgname):
    global bgimage
    global currenttool
    global bgimagerect
    global drawimg
    global basefilename
    try: #catch file not found error
        #load the image if it exists
        bgimage = pygame.image.load(imgname).convert()
        bgimagerect = bgimage.get_rect()
        basefilename = imgname
    except:
        pass
    #load the working drawing if it exists
    try: #catch file not found error
        load_drawing()
    except:
        #create the drawing
        x,y,w,h = bgimagerect
        drawimg = pygame.Surface((w,h))
        drawimg.fill(GREYX)
        drawimg.set_colorkey(GREYX)
        new_draw_surface()

    currenttool = ""

#function to make tool surface
def make_tool():
    global toolsize
    global toolimg
    toolimg = pygame.Surface((toolsize,toolsize))

#function to show tool
def show_tool():
    global toolcolor
    global toolsize
    global toolimg
    global spcetoggle
    if toolimg == None:
        make_tool()
    pos = int(toolsize/2)
    toolimg.fill(GREYX)
    toolimg.set_colorkey(GREYX)
    pygame.draw.circle(toolimg, toolcolor, (pos,pos), int(toolsize/2),0)
    x1 = mouseX - pos
    y1 = mouseY - pos
    screen.blit(toolimg,(95-pos,195-pos)) #draw tool, showing color and size on toolbar
    if mouseX < (200):  #dont draw tool over toolbar
        return
    if not spacetoggle:
        screen.blit(toolimg,(x1,y1))

#function to show the actual image being drawn
def show_drawing():
    global drawclip
    global bgimage
    global screen
    if drawclip and not spacetoggle:  #we only draw our image if we have loaded a background
        screen.blit(drawclip,(200,0))                

#function to show the background image
def show_background():
    global bgimage
    global imgoffset
    global bgclip
    global commatoggle
    x,y = imgoffset
    if bgimage and not commatoggle:
        bgclip.blit(bgimage,(x,y))
        screen.blit(bgclip,(200,0))

#function to accept keyboard text input
def text_input(c,ascii):
    global basefilename
    global fontimg
    valid = "abcdefghijklmnopqrstuvwxyz1234567890.-_ :\\/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    global currenttext
    txt = currenttext
    txt = replaceall(txt,"|","")  #remove the carot
    if c == "\b":
        txt = txt[:-1]
    p = string.find(valid,c)
    if p > -1:
        txt += c
    if len(txt) > 30:
        txt = txt[:30]
    if ascii == 13:
        if currenttool == "load":
            bgimagename = txt
            loadbgimage(txt)
            basefilename = txt
    txt += "|"
    currenttext = txt
    fontimg = font.render(currenttext, 0, BLACK)

#Main process loop
QUIT = False

while 1:

    #Get pygame events
    events = pygame.event.get()
    
    #get mouse position
    mouseX, mouseY = pygame.mouse.get_pos()
    #print mouseX,mouseY   # to debug mouse co-ords
    
    #get all events
    for e in events:
        if e.type == pygame.QUIT : #close window
            QUIT = True
        currentkey = None
        if e.type == KEYDOWN:     #key press
            if e.key == K_ESCAPE: #escape key
                currenttool = None
            currentkey = e.unicode
            if currentkey == " ":
                spacetoggle = not spacetoggle
            if currentkey == ",":
                commatoggle = not commatoggle
            text_input(currentkey, e.key)
        if e.type == pygame.MOUSEBUTTONDOWN: 
            mousedown = True
            mousebutton = e.button
        elif e.type == pygame.MOUSEBUTTONUP:
            mousedown = False
            mousebutton = e.button
    if QUIT:
        pygame.quit()
        sys.exit(0)

    #draw the toolbar
    screen.fill(BLACK) #clear everything from screen 
    screen.blit (toolbar, (0,0)) 

    #process mouse events 
    process_mouse_events()

    #show the background image
    show_background()

    #show the drawing image
    show_drawing()

    #tool processes
    process_tool()


    #show tool
    show_tool()

    #finally display the current cursor
    show_cursor(current_cursor)

    #display all
    pygame.display.flip()

