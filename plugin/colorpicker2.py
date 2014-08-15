#!/usr/bin/env python2

import pygtk
pygtk.require('2.0')
import gtk
import sys

color_sel = gtk.ColorSelectionDialog("Vim Color Picker")
color_sel.colorsel.set_has_opacity_control(True)

if len(sys.argv) > 1 and sys.argv[1].startswith("#"):
    if gtk.gdk.Color(sys.argv[1]):
        color_sel.colorsel.set_current_color(gtk.gdk.Color(sys.argv[1]))
if len(sys.argv) > 3:
    oldalpha = int(float(sys.argv[2])*65536)
    if oldalpha < 65536:
        color_sel.colorsel.set_current_alpha(oldalpha)

if color_sel.run() == gtk.RESPONSE_OK:
    color = color_sel.colorsel.get_current_color()
    alpha = color_sel.colorsel.get_current_alpha()
    #Convert to 8bit channels
    red = color.red / 256
    green = color.green / 256
    blue = color.blue / 256
    alp = (alpha+0.0) / 65536
    if alpha != 65535:
        print "rgba(%s, %s, %s, %1.2f)" % (red, green, blue, alp)
    elif sys.argv[-1] == "rgb":
        print "rgb(%s, %s, %s)" % (red, green, blue)
    else:
        #Convert to hexa strings
        red = str(hex(red))[2:]
        green = str(hex(green))[2:]
        blue = str(hex(blue))[2:]
        #Format
        if len(red) == 1:
            red = "0%s" % red
        if len(green) == 1:
            green = "0%s" % green
        if len(blue) == 1:
            blue = "0%s" % blue

        finalcolor = '#'+red+green+blue
        print finalcolor.upper()

color_sel.destroy()
