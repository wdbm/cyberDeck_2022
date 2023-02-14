################################################################################
#                                                                              #
# lib_cyberDeck                                                                #
#                                                                              #
# version: 2022-08-03T1112Z                                                    #
#                                                                              #
################################################################################
#                                                                              #
# LICENCE INFORMATION                                                          #
#                                                                              #
# The program provides functions for an e-ink display and the cyberDeck 2022.  #
#                                                                              #
# copyright (C) 2022 William Breaden Madden                                    #
#                                                                              #
# This software is released under the terms of the GNU General Public License  #
# version 3 (GPLv3).                                                           #
#                                                                              #
# This program is free software: you can redistribute it and/or modify it      #
# under the terms of the GNU General Public License as published by the Free   #
# Software Foundation, either version 3 of the License, or (at your option)    #
# any later version.                                                           #
#                                                                              #
# This program is distributed in the hope that it will be useful, but WITHOUT  #
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        #
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for     #
# more details.                                                                #
#                                                                              #
# For a copy of the GNU General Public License, see                            #
# <http://www.gnu.org/licenses>.                                               #
#                                                                              #
################################################################################

inkimage(){
    sudo papertty --driver epd7in5v2 image --image "${1}"
}

inkterminal(){
    sudo papertty --driver epd7in5v2 terminal --portrait --interactive --size 20 --font ~/.fonts/consolas.ttf --spacing="auto" #--noclear
}

snapshot(){
    filename="$(date "+%Y-%m-%dT%H%M%SZ" --utc).jpg"
    fswebcam -r 640x480 --jpeg 100 -d /dev/video0 -D 1 "${filename}"
}

snapshots(){
    while true; do
        echo "Press Ctrl C to stop."
        snapshot
        sleep 30
    done
}

inksnapshot(){
    filename="$(date "+%Y-%m-%dT%H%M%SZ" --utc).jpg"
    fswebcam -r 640x480 --jpeg 100 -d /dev/video0 -D 1 "${filename}"
    inkimage "${filename}"
}

clock(){
    echo " $(date +"%I:%M:%S") " | toilet --filter border
}

clockloop(){
    while true; do clock; sleep 1; done
}

clockdateloop(){
    while true; do clock; date; sleep 1; done
}

hdmi_is_off(){
    tvservice -s | grep "TV is off" >/dev/null
}

hdmi(){
    case ${1} in
        off)
            tvservice -o
        ;;
        on)
            if hdmi_is_off; then
                tvservice -p
                curr_vt=`fgconsole`
                if [ "${curr_vt}" = "1" ]; then
                    chvt 2
                    chvt 1
                else
                    chvt 1
                    chvt "${curr_vt}"
                fi
            fi;;
        status)
            if hdmi_is_off; then
                echo off
            else
                echo on
            fi;;
        *)
            echo "usage: ${0} on|off|status" >&2
            exit 2;;
    esac
    exit 0
}

export PATH="/home/"${USER}"/.local/bin:$PATH"

# disable console kernel messages, such as low voltage warnings
sudo dmesg -n 1
# set terminal character dimensions suited to how e-ink display is used
stty cols 72 rows 25
# address mouse middle button emulation
xinput set-prop "Lenovo ThinkPad Compact USB Keyboard with TrackPoint Mouse" "libinput Middle Emulation Enabled" 1
