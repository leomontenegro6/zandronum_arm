#!/bin/bash

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "/roms/ports/PortMaster" ]; then
  controlfolder="/roms/ports/PortMaster"
elif [ -d "/roms2/ports/PortMaster" ]; then
  controlfolder="/roms2/ports/PortMaster"
else
  controlfolder="/storage/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

get_controls

GAMEDIR="/$directory/ports/Zandronum"
GPTOKEYB="$GAMEDIR/gptokeyb $ESUDOKILL"


if [[ -e "/dev/input/by-path/platform-ff300000.usb-usb-0:1.2:1.0-event-joystick" ]]; then
      param_device="anbernic"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_480/* $GAMEDIR/conf/zandronum/.
        fi      
      if [ -f "/opt/system/Advanced/Switch to main SD for Roms.sh" ] || [ -f "/opt/system/Advanced/Switch to SD2 for Roms.sh" ] || [ -f "/boot/rk3326-rg351v-linux.dtb" ]; then
        param_device="anbernic"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_640/* $GAMEDIR/conf/zandronum/.
        fi      
      fi
elif [[ -e "/dev/input/by-path/platform-odroidgo2-joypad-event-joystick" ]]; then
    if [[ ! -z $(cat /etc/emulationstation/es_input.cfg | grep "190000004b4800000010000001010000") ]]; then
      param_device="oga"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_480/* $GAMEDIR/conf/zandronum/.
        fi      
	else
      param_device="rk2020"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_480/* $GAMEDIR/conf/zandronum/.
        fi      
   fi
elif [[ -e "/dev/input/by-path/platform-odroidgo3-joypad-event-joystick" ]]; then
      param_device="ogs"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_640/* $GAMEDIR/conf/zandronum/.
        fi      
elif [[ -e "/dev/input/by-path/platform-gameforce-gamepad-event-joystick" ]]; then
      param_device="chi"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_640/* $GAMEDIR/conf/zandronum/.
        fi      
elif [[ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG552" ]]; then
      param_device="rg552"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_960/* $GAMEDIR/conf/zandronum/.
        fi      
elif [ -e "/dev/input/by-path/platform-singleadc-joypad-event-joystick" ] || [ "$(cat /sys/firmware/devicetree/base/model)" == "Anbernic RG503" ]; then
      param_device="rg503"
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_960/* $GAMEDIR/conf/zandronum/.
        fi      
else
        if [ ! -f /$GAMEDIR/conf/zandronum/zandronum.ini ]; then
          mkdir -p $GAMEDIR/conf/zandronum
          cp -rf $GAMEDIR/conf/zandronum_640/* $GAMEDIR/conf/zandronum/.
        fi
fi


$ESUDO rm -rf ~/.config/zandronum
$ESUDO ln -s $GAMEDIR/conf/zandronum ~/.config/

$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput

export LD_LIBRARY_PATH="$GAMEDIR/libs" 

GPTOKEYB_CONFIG="$GAMEDIR/zandronum.gptk"

cd $GAMEDIR

$GPTOKEYB "zandronum" -c $GPTOKEYB_CONFIG &
./zandronum -iwad "$GAMEDIR/doom2.wad" -file "$GAMEDIR/skulltag_content-3.0-beta01.pk3"

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" >> /dev/tty1
