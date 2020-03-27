******************************************************************************************
.inc '90nm_bulk.l'
.SUBCKT FA1 DVDD GND A B CI N0 N1 N2 N3 N4 N5 N6 N7 CO S
*.PININFO DVDD:I GND:I A:I B:I CI:I CO:O S:O

M00 N0 CO DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M01 N0 CO GND  GND  NMOS l=0.1u w=0.25u m=1
M02 N1 B  DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M03 CO CI N1   N1   PMOS l=0.1u w=0.5u  m=1
M04 CO CI N2   N2   NMOS l=0.1u w=0.25u m=1
M05 N2 B  GND  GND  NMOS l=0.1u w=0.25u m=1
M06 N1 A  DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M07 N2 A  GND  GND  NMOS l=0.1u w=0.25u m=1
M08 N3 CI DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M09 N3 CI GND  GND  NMOS l=0.1u w=0.25u m=1
M10 N5 N4 CI   CI   PMOS l=0.1u w=0.5u  m=1
M11 N5 N4 N3   N3   NMOS l=0.1u w=0.25u m=1
M12 N5 CI N7   N7   PMOS l=0.1u w=0.5u  m=1
M13 N5 N3 N7   N7   NMOS l=0.1u w=0.25u m=1
M14 S  N5 DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M15 S  N5 GND  GND  NMOS l=0.1u w=0.25u m=1
M16 N6 A  GND  GND  NMOS l=0.1u w=0.25u m=1
M17 N6 A  DVDD DVDD PMOS l=0.1u w=0.5u  m=1
M18 N4 B  N6   N6   PMOS l=0.1u w=0.25u m=1
M19 B  N6 N4   N4   PMOS l=0.1u w=0.25u m=1
M20 B  A  N4   N4   NMOS l=0.1u w=0.25u m=1
M21 N4 B  A    A    NMOS l=0.1u w=0.25u m=1
.ENDS

******************************************************************************************

Vdd DVDD 0 1
Vss GND  0 0

VA  A  0 pwl(0u 0v 3.9u 0v 4u 1v 7.9u 1v 8u 0v)
VB  B  0 pwl(0u 0v 1.9u 0v 2u 1v 3.9u 1v 4u 0v 5.9u 0v 6u 1v 7.9u 1v 8u 0v)
VCI CI 0 pwl(0u 0v 0.4u 0v 0.5u 1v 0.9u 1v 1u 0v 1.4u 0v 1.5u 1v 1.9u 1v 2u 0v 2.4u 0v 2.5u 1v 2.9u 1v 3u 0v 3.4u 0v 3.5u 1v 3.9u 1v 4u 0v 4.4u 0v 4.5u 1v 4.9u 1v 5u 0v 5.4u 0v 5.5u 1v 5.9u 1v 6u 0v 6.4u 0v 6.5u 1v 6.9u 1v 7u 0v 7.4u 0v 7.5u 1v 7.9u 1v 8u 0v)

x1 DVDD GND A B CI N0 N1 N2 N3 N4 N5 N6 N7 CO S FA1

.tran 10n 8u
.op
.option post
.end