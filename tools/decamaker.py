# -*- coding: utf-8 -*-


import golly as g

"""
generates a adaptator between 2 streams of gliders with a delta*15 pixels diagonal shift
"""

delta = 2

ref2 = [0, -60, 11, 23]
ref3 = [30, -60, 23, 11]
ref4 = [60, -60, 23, 11]


d1 = delta*15+9
d2 = 0
d3 = 9


g.open("reflecteur.mc")


# 2eme reflecteur
g.select(ref2)
g.cut()
g.run(29+4*d1)
g.paste(-19-d1,16+d1, "or")


# 3eme reflecteur
g.select(ref3)
g.cut()
g.run(4*d1)
g.run(4+4*d2)
g.paste(d2+1-d1,34+d2+d1, "or")

# 4eme reflecteur
g.select(ref4)
g.cut()
g.run(4*(d1+d2))
g.run(3+4*d3)
g.paste(d2+17-d1+d3,15+d2+d1-d3, "or")


g.select([-80, -80, 10, 10])
g.clear(0)


g.save("deca_"+str(decalage)+".mc", "mc")






