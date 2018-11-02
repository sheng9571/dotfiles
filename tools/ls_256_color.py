#!/usr/bin/env python2
# -*- coding: utf-8 -*-

print "Color indexes should be drawn in bold text of the same color."
print

col_tpe = {'normal': 0, 'bold': 1, 'dim': 2, 'underline': 4, 'blink': 5, 'reverse': 7, 'invisible': 8}

colored = [0] + [0x5f + 40 * n for n in range(0, 5)]
colored_palette = [
    "%02x/%02x/%02x" % (r, g, b)
    for r in colored
    for g in colored
    for b in colored
]

grayscale = [0x08 + 10 * n for n in range(0, 24)]
grayscale_palette = [
    "%02x/%02x/%02x" % (a, a, a)
    for a in grayscale
]

normal = "\033[%d38;5;" % col_tpe['normal']
normal += "%sm" 
bold = "\033[%d;38;5;" % col_tpe['bold']
bold = "\033[1;38;5;%sm"
reset = "\033[0m"

for (i, color) in enumerate(colored_palette + grayscale_palette, 16):
    index = (bold + "%4s" + reset) % (i, str(i) + ':')
    hex   = (normal + "%s" + reset) % (i, color)
    newline = '\n' if i % 6 == 3 else ''
    print index, hex, newline,
