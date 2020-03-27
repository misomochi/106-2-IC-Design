******************************************************************************************
.inc '90nm_bulk.l'
.SUBCKT	E03 DVDD GND A B C N1 N2 N3 N4 N5 Z
*.PININFO DVDD:I GND:I A:I B:I C:I Z:O

M00 N1 C  DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M01 N1 C  GND  GND  NMOS l=0.1u w=0.25u m=1
M02 C  N5 N2   N2   PMOS l=0.1u w=0.5u  m=1
M03 N1 N5 N2   N2   NMOS l=0.1u w=0.25u m=1
M04 N3 C  N2   N2   PMOS l=0.1u w=0.5u  m=1
M05 N3 N1 N2   N2   NMOS l=0.1u w=0.25u m=1
M06 Z  N2 DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M07 Z  N2 GND  GND  NMOS l=0.1u w=0.25u m=1
M08 N4 A  DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M09 N4 A  GND  GND  NMOS l=0.1u w=0.25u m=1
M10 N5 B  N4   N4   PMOS l=0.1u w=0.5u  m=1
M11 B  N4 N5   N5   PMOS l=0.1u w=0.5u  m=1
M12 B  A  N5   N5   NMOS l=0.1u w=0.25u m=1
M13 N5 B  A    A    NMOS l=0.1u w=0.25u m=1
.ENDS

******************************************************************************************

Vdd DVDD 0 1
Vss GND  0 0

VA A 0 pwl(0u 0v 1.9u 0v 2u 1v 3.9u 1v 4u 0v)
VB B 0 pwl(0u 0v 0.9u 0v 1u 1v 1.9u 1v 2u 0v 2.9u 0v 3u 1v 3.9u 1v 4u 0v)
VC C 0 pwl(0u 0v 0.4u 0v 0.5u 1v 0.9u 1v 1u 0v 1.4u 0v 1.5u 1v 1.9u 1v 2u 0v 2.4u 0v 2.5u 1v 2.9u 1v 3u 0v 3.4u 0v 3.5u 1v 3.9u 1v 4u 0v)

x1 DVDD GND A B C N1 N2 N3 N4 N5 Z E03

.tran 10n 4u
.op
.option post
.end