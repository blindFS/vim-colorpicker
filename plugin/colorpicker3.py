#!/usr/bin/env python3
from gi.repository import Gtk
from gi.repository import Gdk
import sys

color_sel_dia = Gtk.ColorSelectionDialog("vim")
color_sel = color_sel_dia.get_color_selection()
color_sel.set_has_opacity_control(True)

if len(sys.argv) > 1 and sys.argv[1].startswith("#"):
    if Gdk.color_parse(sys.argv[1]):
        color_sel.set_current_color(Gdk.color_parse(sys.argv[1]))
if len(sys.argv) > 3:
    oldalpha = int(float(sys.argv[2])*65536)
    if oldalpha < 65536:
        color_sel.set_current_alpha(oldalpha)

if color_sel_dia.run() == Gtk.ResponseType.OK:
    color = color_sel.get_current_color()
    alpha = color_sel.get_current_alpha()
    red = int(color.red / 256)
    green = int(color.green / 256)
    blue = int(color.blue / 256)
    alp = (alpha+0.0) / 65536
    if alpha != 65535:
        print("rgba(%s, %s, %s, %1.2f)" % (red, green, blue, alp))
    elif sys.argv[-1] == "rgb":
        print("rgb(%s, %s, %s)" % (red, green, blue))
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
        print(finalcolor.upper())

color_sel_dia.destroy()
