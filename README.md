# cyberDeck 2022

![](media/cyberDeck_2022_Thornwood_1.jpg)

![](media/cyberDeck_2022_Brandenburg_3.jpg)

Suited to the hardened writer, the mobile hacker and the executive types we see in old IBM advertisements, the cyberDeck 2022 comprises a Raspberry Pi, an LCD display, an e-ink display, various peripherals (such as a camera), a ThinkPad USB keyboard and a battery, all in the case of a [ThinkPad 380E](https://old.reddit.com/r/thinkpad/comments/wy555k/the_thinkpad_380_is_the_perfect_answer_for_an) laptop.

This makes for a machine with a look and ergonomics sense from the 90s, with a decent battery life, with a great adaptability and hackability, and one which works (particularly on text) as effectively in bright suns as in dark caverns.

|![](media/cyberDeck_2022_Brandenburg_1.jpg)|![](media/cyberDeck_2022_Brandenburg_2.jpg)|
|:---:|:---:|:---:|

|![](media/cyberDeck_2022_Clyde_1.jpg)|![](media/cyberDeck_2022_Dowanhill_1.jpg)|
|:---:|:---:|:---:|

# components and construction

The LCD display is the Waveshare WAV-17916 and it is connected to the Raspberry Pi using HDMI. The e-ink display is the [Waveshare 13504](https://www.waveshare.com/product/7.5inch-e-paper-hat.htm) and it is connected to the Raspberry Pi using SPI. An OV2643 camera is placed in the display case. The original inbuilt speaker of the ThinkPad 380E is used.

A [ThinkPad USB keyboard](https://www.lenovo.com/gb/en/p/accessories-and-software/keyboards-and-mice/keyboards/0b47221) is used in the place of the original inbuilt because (easily set-up) scroll wheel emulation using a middle TrackPoint button was desired. This USB keyboard fits the space available in the ThinkPad 380E case almost exactly.

One could use original inbuilt keyboard. There are at least two things to consider for this. First, it is possible to adapt the original inbuilt keyboard together with its TrackPoint to USB. A procedure for this has been described by [Frank Adams](https://vimeo.com/458669376). Second, as the original inbuilt keyboard features two TrackPoint buttons rather than the contemporary three, one could investigate scroll wheel emulation that uses one of the existing TrackPoint buttons. An example of this form of interface is seen with [Ubuntu MATE](https://ubuntu-mate.org/umpcs) on the [GPD Pocket](https://gpd.hk/gpdpocket) (the first version, with pointing stick).

The construction of the machine could be accomplished in any number of ways, and could be improved upon (perhaps by using the original inbuilt keyboard, by adding an amplifier for the inbuilt speaker and by adding a better battery). So, instead of specific instructions, there are provided a few photographs which are intended to provide inspiration and only an approximate guide:

|![](media/cyberDeck_2022_construction_1.jpg)|![](media/OV2643_1.jpg)|![](media/OV2643_2.jpg)|
|:---:|:---:|:---:|

|![](media/cyberDeck_2022_construction_2.jpg)|![](media/cyberDeck_2022_construction_3.jpg)|![](media/cyberDeck_2022_construction_4.jpg)|
|:---:|:---:|:---:|

|![](media/cyberDeck_2022_construction_5.jpg)|![](media/cyberDeck_2022_construction_6.jpg)|![](media/cyberDeck_2022_construction_7.jpg)|
|:---:|:---:|:---:|

# software

The operating system used is Raspberry Pi OS, specifically a version from April 2022. On the fresh installation, the following contents can be added to the file `/config.txt` of the boot partition, with the display rotation set as appropriate:

```
hdmi_group=2
hdmi_mode=87
hdmi_timings=400 0 100 10 140 1280 10 20 20 2 0 0 0 60 0 43000000 3
display_rotate=1
```

A modified version of the [PaperTTY](https://github.com/wdbm/PaperTTY) Python package is used to drive the e-ink display with both standard full-update and prototype partial-update modes.

With this setup, the default virtual teletypewriter (tty) terminal dimensions are 160 columns by 25 lines (derived from `tput cols` and `tput lines`). These can be changed to other dimensions more suited to the e-ink display, using a command like the following:

```Bash
stty cols 72 rows 25
```

If the battery used is a little underpowered, particularly for some tasks like wireless connectivity and full updates to the e-ink display, it can be helpful to disable console kernel messages, such as those corresponding to low voltage warnings. This can be done using a command like the following:

```Bash
sudo dmesg -n 1
```

A small prototype Bash library is provided, [lib_cyberDeck.sh](lib_cyberDeck.sh). Dependencies for this include a modified version of [PaperTTY](https://github.com/wdbm/PaperTTY), the font Consolas and [TOIlet](caca.zoy.org/wiki/toilet).

Following appropriate setup, a local installation of the modified version of [PaperTTY](https://github.com/wdbm/PaperTTY) may be used in a way like the following in order to start using the e-ink display with one of the virtual tty terminals:

```Bash
sudo su

. /root/.cache/pypoetry/virtualenvs/papertty-Py6eRTj9-py3.9/bin/activate

papertty --driver epd7in5v2partial terminal --portrait --interactive --size 20 --font /home/user/.fonts/consolas.ttf --spacing="auto"
```
