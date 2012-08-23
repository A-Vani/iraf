# CHRTAB -- Table of strokes for the printable ASCII characters.  Each character
# is encoded as a series of strokes.  Each stroke is expressed by a single
# integer containing the following bitfields:
#
#	2                   1
#	0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 
#	          | | | |         | |         |
#		  | | | +---------+ +---------+
#		  | | |      |           |
#		  | | |      X           Y
#		  | | |
#	          | | +-- pen up/down
#                 | +---- begin paint (not used at present)
#                 +------ end paint (not used at present)
#
#------------------------------------------------------------------------------

# Define the database.

short	chridx[96]		# character index in chrtab
short	chrtab[800]		# stroke data to draw the characters

# Index into CHRTAB of each printable character (starting with SP).

data    (chridx(i), i=01,05) /   1,   3,  12,  21,  30/
data    (chridx(i), i=06,10) /  45,  66,  79,  85,  92/
data    (chridx(i), i=11,15) /  99, 106, 111, 118, 121/
data    (chridx(i), i=16,20) / 128, 131, 141, 145, 154/
data    (chridx(i), i=21,25) / 168, 177, 187, 199, 203/
data    (chridx(i), i=26,30) / 221, 233, 246, 259, 263/
data    (chridx(i), i=31,35) / 268, 272, 287, 307, 314/
data    (chridx(i), i=36,40) / 327, 336, 344, 352, 359/
data    (chridx(i), i=41,45) / 371, 378, 385, 391, 398/
data    (chridx(i), i=46,50) / 402, 408, 413, 425, 433/
data    (chridx(i), i=51,55) / 445, 455, 468, 473, 480/
data    (chridx(i), i=56,60) / 484, 490, 495, 501, 506/
data    (chridx(i), i=61,65) / 511, 514, 519, 523, 526/
data    (chridx(i), i=66,70) / 529, 543, 554, 563, 574/
data    (chridx(i), i=71,75) / 585, 593, 607, 615, 625/
data    (chridx(i), i=76,80) / 638, 645, 650, 663, 671/
data    (chridx(i), i=81,85) / 681, 692, 703, 710, 723/
data    (chridx(i), i=86,90) / 731, 739, 743, 749, 754/
data    (chridx(i), i=91,95) / 759, 764, 776, 781, 793/
data    (chridx(i), i=96,96) / 801/

# Stroke data.

data	(chrtab(i), i=001,005) /    36,  1764,   675, 29328,   585/
data	(chrtab(i), i=006,010) / 21063, 21191, 21193, 21065, 29383/
data	(chrtab(i), i=011,015) /  1764,   355, 29023,   351, 29027/
data	(chrtab(i), i=016,020) /   931, 29599,   927, 29603,  1764/
data	(chrtab(i), i=021,025) /   603, 29066,   842, 29723,  1302/
data	(chrtab(i), i=026,030) / 28886,   143, 29839,  1764,   611/
data	(chrtab(i), i=031,035) / 29256,    78, 20810, 21322, 21581/
data	(chrtab(i), i=036,040) / 21586, 21334, 20822, 20569, 20573/
data	(chrtab(i), i=041,045) / 20833, 21345, 29789,  1764,   419/
data	(chrtab(i), i=046,050) / 20707, 20577, 20574, 20700, 20892/
data	(chrtab(i), i=051,055) / 21022, 21025, 20899,  1187, 28744/
data	(chrtab(i), i=056,060) /   717, 21194, 21320, 21512, 21642/
data	(chrtab(i), i=061,065) / 21645, 21519, 21327, 21197,  1764/
data	(chrtab(i), i=066,070) /  1160, 20700, 20704, 20835, 21027/
data	(chrtab(i), i=071,075) / 21152, 21149, 20561, 20556, 20744/
data	(chrtab(i), i=076,080) / 21192, 29841,  1764,   611, 21023/
data	(chrtab(i), i=081,085) / 21087, 21155, 21091,  1764,   739/
data	(chrtab(i), i=086,090) / 21087, 21018, 21009, 21068, 29384/
data	(chrtab(i), i=091,095) /  1764,   547, 21151, 21210, 21201/
data	(chrtab(i), i=096,100) / 21132, 29192,  1764,    93, 29774/
data	(chrtab(i), i=101,105) /   608, 29259,    78, 29789,  1764/
data	(chrtab(i), i=106,110) /   604, 29260,    84, 29780,  1764/
data	(chrtab(i), i=111,115) /   516, 21062, 21065, 21001, 21000/
data	(chrtab(i), i=116,120) / 21064,  1764,    84, 29780,  1764/
data	(chrtab(i), i=121,125) /   585, 21063, 21191, 21193, 21065/
data	(chrtab(i), i=126,130) / 21191,  1764,    72, 29859,  1764/
data	(chrtab(i), i=131,135) /   419, 20573, 20558, 20872, 21320/
data	(chrtab(i), i=136,140) / 21646, 21661, 21347, 20899,  1764/
data	(chrtab(i), i=141,145) /   221, 21155, 29320,  1764,    95/
data	(chrtab(i), i=146,150) / 20835, 21411, 21663, 21655, 20556/
data	(chrtab(i), i=151,155) / 20552, 29832,  1764,    95, 20899/
data	(chrtab(i), i=156,160) / 21347, 21663, 21658, 21334, 29270/
data	(chrtab(i), i=161,165) /   854,  5266, 21644, 21320, 20872/
data	(chrtab(i), i=166,170) / 28749,  1764,   904, 21411, 21283/
data	(chrtab(i), i=171,175) / 20561, 20559, 21391,   911, 13455/
data	(chrtab(i), i=176,180) /  1764,   136, 21320, 21645, 21652/
data	(chrtab(i), i=181,185) / 21337, 20889, 20565, 20579, 29859/
data	(chrtab(i), i=186,190) /  1764,    83, 20888, 21336, 21651/
data	(chrtab(i), i=191,195) / 21645, 21320, 20872, 20557, 20563/
data	(chrtab(i), i=196,200) / 20635, 29347,  1764,    99, 21667/
data	(chrtab(i), i=201,205) / 29064,  1764,   355, 20575, 20570/
data	(chrtab(i), i=206,210) / 20822, 20562, 20556, 20808, 21384/
data	(chrtab(i), i=211,215) / 21644, 21650, 21398, 20822,   918/
data	(chrtab(i), i=216,220) /  5274, 21663, 21411, 20835,  1764/
data	(chrtab(i), i=221,225) /   648, 21584, 21656, 21662, 21347/
data	(chrtab(i), i=226,230) / 20899, 20574, 20568, 20883, 21331/
data	(chrtab(i), i=231,235) / 21656,  1764,   602, 21210, 21207/
data	(chrtab(i), i=236,240) / 21079, 21082, 21207,   592, 21069/
data	(chrtab(i), i=241,245) / 21197, 21200, 21072, 21197,  1764/
data	(chrtab(i), i=246,250) /   602, 21146, 21143, 21079, 21082/
data	(chrtab(i), i=251,255) / 21143,   585, 21132, 21136, 21072/
data	(chrtab(i), i=256,260) / 21071, 21135,  1764,   988, 20628/
data	(chrtab(i), i=261,265) / 29644,  1764,  1112, 28824,   144/
data	(chrtab(i), i=266,270) / 29776,  1764,   156, 21460, 28812/
data	(chrtab(i), i=271,275) /  1764,   221, 20704, 20899, 21218/
data	(chrtab(i), i=276,280) / 21471, 21466, 21011, 21007,   521/
data	(chrtab(i), i=281,285) / 20999, 21127, 21129, 21001, 21127/
data	(chrtab(i), i=286,290) /  1764,   908, 20812, 20560, 20571/
data	(chrtab(i), i=291,295) / 20831, 21407, 21659, 21651, 21521/
data	(chrtab(i), i=296,300) / 21393, 21331, 21335, 21210, 21018/
data	(chrtab(i), i=301,305) / 20887, 20883, 21009, 21201, 21331/
data	(chrtab(i), i=306,310) /  1764,    72, 20963, 21219, 29768/
data	(chrtab(i), i=311,315) /   210,  5074,  1764,    99, 21411/
data	(chrtab(i), i=316,320) / 21663, 21658, 21398, 20566,   918/
data	(chrtab(i), i=321,325) /  5266, 21644, 21384, 20552, 20579/
data	(chrtab(i), i=326,330) /  1764,  1165, 21320, 20872, 20557/
data	(chrtab(i), i=331,335) / 20574, 20899, 21347, 29854,  1764/
data	(chrtab(i), i=336,340) /    99, 21347, 21662, 21645, 21320/
data	(chrtab(i), i=341,345) / 20552, 20579,  1764,    99, 20552/
data	(chrtab(i), i=346,350) / 29832,    86, 13078,    99, 29859/
data	(chrtab(i), i=351,355) /  1764,    99, 20552,    86, 13078/
data	(chrtab(i), i=356,360) /    99, 29859,  1764,   722, 21650/
data	(chrtab(i), i=361,365) / 29832,  1165,  4936, 20872, 20557/
data	(chrtab(i), i=366,370) / 20574, 20899, 21347, 29854,  1764/
data	(chrtab(i), i=371,375) /    99, 28744,    85,  5269,  1160/
data	(chrtab(i), i=376,380) / 29859,  1764,   291, 29603,   611/
data	(chrtab(i), i=381,385) /  4680,   328, 29576,  1764,    77/
data	(chrtab(i), i=386,390) / 20872, 21256, 21581, 29795,  1764/
data	(chrtab(i), i=391,395) /    99, 28744,  1160, 20887,    82/
data	(chrtab(i), i=396,400) / 13475,  1764,    99, 20552, 29832/
data	(chrtab(i), i=401,405) /  1764,    72, 20579, 21077, 21603/
data	(chrtab(i), i=406,410) / 29768,  1764,    72, 20579, 21640/
data	(chrtab(i), i=411,415) / 29859,  1764,    94, 20899, 21347/
data	(chrtab(i), i=416,420) / 21662, 21645, 21320, 20872, 20557/
data	(chrtab(i), i=421,425) / 20574,   862, 29859,  1764,    72/
data	(chrtab(i), i=426,430) / 20579, 21411, 21663, 21656, 21396/
data	(chrtab(i), i=431,435) / 20564,  1764,    94, 20557, 20872/
data	(chrtab(i), i=436,440) / 21320, 21645, 21662, 21347, 20899/
data	(chrtab(i), i=441,445) / 20574,   536, 29828,  1764,    72/
data	(chrtab(i), i=446,450) / 20579, 21411, 21663, 21657, 21398/
data	(chrtab(i), i=451,455) / 20566,   918, 13448,  1764,    76/
data	(chrtab(i), i=456,460) / 20808, 21384, 21644, 21649, 21397/
data	(chrtab(i), i=461,465) / 20822, 20570, 20575, 20835, 21411/
data	(chrtab(i), i=466,470) / 29855,  1764,   648, 21155,    99/
data	(chrtab(i), i=471,475) / 29923,  1764,    99, 20557, 20872/
data	(chrtab(i), i=476,480) / 21320, 21645, 29859,  1764,    99/
data	(chrtab(i), i=481,485) / 21064, 29795,  1764,    99, 20808/
data	(chrtab(i), i=486,490) / 21141, 21448, 29923,  1764,    99/
data	(chrtab(i), i=491,495) / 29832,    72, 29859,  1764,    99/
data	(chrtab(i), i=496,500) / 21079, 29256,   599, 13411,  1764/
data	(chrtab(i), i=501,505) /    99, 21667, 20552, 29832,  1764/
data	(chrtab(i), i=506,510) /   805, 20965, 20935, 29447,  1764/
data	(chrtab(i), i=511,515) /    99, 29832,  1764,   421, 21221/
data	(chrtab(i), i=516,520) / 21191, 29063,  1764,   288, 21091/
data	(chrtab(i), i=521,525) / 29600,  1764,     3, 29891,  1764/
data	(chrtab(i), i=526,530) /   547, 29341,  1764,   279, 21207/
data	(chrtab(i), i=531,535) / 21396, 21387, 21127, 20807, 20555/
data	(chrtab(i), i=536,540) / 20558, 20753, 21201, 21391,   907/
data	(chrtab(i), i=541,545) / 13447,  1764,    99, 28744,    76/
data	(chrtab(i), i=546,550) /  4424, 21256, 21516, 21523, 21271/
data	(chrtab(i), i=551,555) / 20823, 20563,  1764,   981, 21271/
data	(chrtab(i), i=556,560) / 20823, 20563, 20556, 20808, 21256/
data	(chrtab(i), i=561,565) / 29642,  1764,  1043,  4887, 20823/
data	(chrtab(i), i=566,570) / 20563, 20556, 20808, 21256, 21516/
data	(chrtab(i), i=571,575) /  1032, 29731,  1764,    80,  5136/
data	(chrtab(i), i=576,580) / 21523, 21271, 20823, 20563, 20556/
data	(chrtab(i), i=581,585) / 20808, 21256, 29707,  1764,   215/
data	(chrtab(i), i=586,590) / 29591,   456, 20958, 21153, 21409/
data	(chrtab(i), i=591,595) / 29727,  1764,    67, 20800, 21248/
data	(chrtab(i), i=596,600) / 21508, 29719,  1043, 21271, 20823/
data	(chrtab(i), i=601,605) / 20563, 20556, 20808, 21256, 21516/
data	(chrtab(i), i=606,610) /  1764,    99, 28744,    83,  4439/
data	(chrtab(i), i=611,615) / 21271, 21523, 29704,  1764,   541/
data	(chrtab(i), i=616,620) / 21019, 21147, 21149, 21021, 21147/
data	(chrtab(i), i=621,625) /   533, 21077, 29256,  1764,   541/
data	(chrtab(i), i=626,630) / 21019, 21147, 21149, 21021, 21147/
data	(chrtab(i), i=631,635) /   533, 21077, 21058, 20928, 20736/
data	(chrtab(i), i=636,640) / 28802,  1764,    99, 28744,    84/
data	(chrtab(i), i=641,645) / 29530,   342, 13320,  1764,   483/
data	(chrtab(i), i=646,650) / 21089, 21066, 29384,  1764,    87/
data	(chrtab(i), i=651,655) / 28744,   584, 21076,    84,  4375/
data	(chrtab(i), i=656,660) / 20951, 21076, 21207, 21399, 21588/
data	(chrtab(i), i=661,665) / 29768,  1764,    87, 28744,    83/
data	(chrtab(i), i=666,670) / 20823, 21271, 21523, 29704,  1764/
data	(chrtab(i), i=671,675) /    83, 20556, 20808, 21256, 21516/
data	(chrtab(i), i=676,680) / 21523, 21271, 20823, 20563,  1764/
data	(chrtab(i), i=681,685) /    87, 28736,    83, 20823, 21271/
data	(chrtab(i), i=686,690) / 21523, 21516, 21256, 20808, 20556/
data	(chrtab(i), i=691,695) /  1764,  1047, 29696,  1036, 21256/
data	(chrtab(i), i=696,700) / 20808, 20556, 20563, 20823, 21271/
data	(chrtab(i), i=701,705) / 21523,  1764,    87, 28744,    83/
data	(chrtab(i), i=706,710) / 20823, 21271, 29716,  1764,    74/
data	(chrtab(i), i=711,715) / 20808, 21256, 21514, 21518, 21264/
data	(chrtab(i), i=716,720) / 20816, 20562, 20565, 20823, 21271/
data	(chrtab(i), i=721,725) / 21461,  1764,   279, 29591,   970/
data	(chrtab(i), i=726,730) / 21320, 21128, 21002, 21025,  1764/
data	(chrtab(i), i=731,735) /    87, 20556, 20808, 21256, 21516/
data	(chrtab(i), i=736,740) /  1032, 29719,  1764,   151, 21064/
data	(chrtab(i), i=741,745) / 29719,  1764,    87, 20808, 21077/
data	(chrtab(i), i=746,750) / 21320, 29783,  1764,   151, 29704/
data	(chrtab(i), i=751,755) /   136, 29719,  1764,    87, 21064/
data	(chrtab(i), i=756,760) /   320, 29783,  1764,   151, 21527/
data	(chrtab(i), i=761,765) / 20616, 29704,  1764,   805, 21157/
data	(chrtab(i), i=766,770) / 21026, 21017, 20951, 20822, 20949/
data	(chrtab(i), i=771,775) / 21011, 21001, 21127, 21255,  1764/
data	(chrtab(i), i=776,780) /   611, 29273,   594, 29256,  1764/
data	(chrtab(i), i=781,785) /   485, 21093, 21218, 21209, 21271/
data	(chrtab(i), i=786,790) / 21398, 21269, 21203, 21193, 21063/
data	(chrtab(i), i=791,795) / 29127,  1764,    83, 20758, 20950/
data	(chrtab(i), i=796,800) / 21265, 21457, 29844,  1764,     0/