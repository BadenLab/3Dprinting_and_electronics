EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:switches
LIBS:relays
LIBS:motors
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L LED D1
U 1 1 5B51B6AA
P 5200 3600
F 0 "D1" H 5200 3700 50  0000 C CNN
F 1 "LED" H 5200 3500 50  0000 C CNN
F 2 "Resistors_Universal:Resistor_SMD+THTuniversal_0805to2512_RM10_HandSoldering" H 5200 3600 50  0001 C CNN
F 3 "" H 5200 3600 50  0001 C CNN
	1    5200 3600
	1    0    0    -1  
$EndComp
$Comp
L Conn_01x02_Female J1
U 1 1 5B51B72A
P 5150 2950
F 0 "J1" H 5150 3050 50  0000 C CNN
F 1 "Conn_01x02_Female" H 5150 2750 50  0000 C CNN
F 2 "Socket_Strips:Socket_Strip_Straight_1x02_Pitch2.54mm" H 5150 2950 50  0001 C CNN
F 3 "" H 5150 2950 50  0001 C CNN
	1    5150 2950
	0    -1   -1   0   
$EndComp
$Comp
L +3.3V #PWR01
U 1 1 5B51B77F
P 5550 3050
F 0 "#PWR01" H 5550 2900 50  0001 C CNN
F 1 "+3.3V" H 5550 3190 50  0000 C CNN
F 2 "" H 5550 3050 50  0001 C CNN
F 3 "" H 5550 3050 50  0001 C CNN
	1    5550 3050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 5B51B797
P 4850 3050
F 0 "#PWR02" H 4850 2800 50  0001 C CNN
F 1 "GND" H 4850 2900 50  0000 C CNN
F 2 "" H 4850 3050 50  0001 C CNN
F 3 "" H 4850 3050 50  0001 C CNN
	1    4850 3050
	-1   0    0    1   
$EndComp
Wire Wire Line
	5050 3600 5050 3150
Wire Wire Line
	5050 3150 5150 3150
Wire Wire Line
	5350 3600 5350 3150
Wire Wire Line
	5350 3150 5250 3150
Wire Wire Line
	5350 3600 5550 3600
Wire Wire Line
	5550 3600 5550 3050
Wire Wire Line
	5050 3600 4850 3600
Wire Wire Line
	4850 3600 4850 3050
$EndSCHEMATC
