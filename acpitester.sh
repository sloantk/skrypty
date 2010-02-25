#!/bin/bash

echo "Linux ACPI Tester - V0.2"
echo "Copyright 2008 Bill Giannikos"
echo ""
echo "For best results you should ensure you have the latest version of this utility from:"
echo "http://www.linlap.com/wiki/Linux+ACPI+Tester"
echo ""
echo "This program will NOT load any ACPI modules."
echo ""


if [ -f /proc/acpi/info ]; then
    echo "The Linux ACPI version is: `cat /proc/acpi/info | awk '{print $2}'`"
else
    echo "ACPI is NOT active on this system"
    exit 0
fi

echo ""
echo "- ACPI Power Test -"
DEVFOUND=0
for DEVDIR in /proc/acpi/ac_adapter/*; do
    if [ -f $DEVDIR/state ]; then
        DEVNAME=`basename $DEVDIR`
        echo ""
        echo "Detected AC Adapter ($DEVNAME), current state is: `cat $DEVDIR/state | awk '{print $2}'`"
        let DEVFOUND=$DEVFOUND+1
    fi
done
if [ $DEVFOUND -eq 0 ]; then
    echo ""
    echo "No AC Adapter sensor was detected on this system. This is normal for a desktop system, but may indicate a ACPI issue on a laptop."
fi

echo "";echo ""
echo "- ACPI Battery Test -"
DEVFOUND=0
for DEVDIR in /proc/acpi/battery/*; do
    if [ -f $DEVDIR/state ]; then
        DEVSTATE=`grep "present:" $DEVDIR/state | awk '{print $2}'`
        DEVNAME=`basename $DEVDIR`
        if [ $DEVSTATE == "yes" ]; then
            echo " "
            echo "Detected battery ($DEVNAME); here are the details:"
            echo "Info:"
            cat "$DEVDIR/info"
            echo ""
            echo "State:"
            cat "$DEVDIR/state"
            let DEVFOUND=$DEVFOUND+1
        else
            echo "Detected battery socket ($DEVNAME), but it appears to be empty."
        fi
    fi;
done

echo ""
if [ $DEVFOUND -eq 1 ]; then
    DEVNAME="battery";
else
    DEVNAME="batteries";
fi
echo "Detected a total of $DEVFOUND $DEVNAME.  If this total differs from the actual number of batteries in your system, it may indicate an ACPI issue."

echo "";echo ""
echo "- ACPI Processor Test -"
DEVFOUND=0
for DEVDIR in /proc/acpi/processor/*; do
    if [  -f $DEVDIR/info ]; then
        DEVNAME=`basename $DEVDIR`
        echo " "
        echo "Detected $DEVNAME, details are:"
        cat $DEVDIR/info
        let DEVFOUND=$DEVFOUND+1
    fi;
done
echo " "
if [ $DEVFOUND -eq 0 ]; then
    echo "No CPUs were detected. This is a problem as ACPI did not detect the CPU in your system."
elif [ $DEVFOUND -eq 1 ]; then
    echo "Detected 1 CPU."
else
    echo "Detected a total of $DEVFOUND CPUs."
fi

echo "";echo ""
echo "- ACPI Temperature Sensor Test -"
DEVFOUND=0
for DEVDIR in /proc/acpi/thermal_zone/*; do
    if [ -f $DEVDIR/temperature ]; then
        DEVNAME=`basename $DEVDIR`
        echo " "
        echo "Detected temperature sensor ($DEVNAME); details are:"
        cat $DEVDIR/temperature
        echo "Cooling mode details:"
        cat $DEVDIR/cooling_mode
        echo "Tripping point details are:"
        cat $DEVDIR/trip_points
        let DEVFOUND=$DEVFOUND+1
    fi;
done
echo " "
if [ $DEVFOUND -eq 0 ]; then
    echo "No Temperature sensor was detected; this may indicate an ACPI problem."
elif [ $DEVFOUND -eq 1 ]; then
    echo "Detected 1 CPU temperature sensor."
else
    echo "Detected a total of $DEVFOUND temperature sensors."
fi
echo " "

