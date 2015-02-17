#!/bin/bash

#    Resurrection Remix Compilation Script
#
#    Copyright (C) 2014 Shubhang Rathore
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


# No scrollback buffer
echo -e '\0033\0143'



# Get intial time of script startup
res1=$(date +%s.%N)



# Specify colors for shell
red='tput setaf 1'              # red
green='tput setaf 2'            # green
yellow='tput setaf 3'           # yellow
blue='tput setaf 4'             # blue
violet='tput setaf 5'           # violet
cyan='tput setaf 6'             # cyan
white='tput setaf 7'            # white
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Bold red
bldgrn=${txtbld}$(tput setaf 2) # Bold green
bldblu=${txtbld}$(tput setaf 4) # Bold blue
bldcya=${txtbld}$(tput setaf 6) # Bold cyan
normal='tput sgr0'


tput bold
tput setaf 1
clear
echo -e ""
echo -e "BLISS POP"
echo -e ""
echo -e ""
echo -e ""
echo -e ""

sleep 3s

# Clear terminal
clear

# Confirm 'make clean'
echo -e "\n\n${bldgrn}  Do you want to make clean?\n"
echo ""
echo -e "${bldblu}  1. Yes"
echo -e "${bldblu}  2. No"
echo ""
echo ""
$normal
read askClean

echo ""
echo ""
if [ "$askClean" == "1" ]
then
    echo -e "${bldred}  Compilation will continue after cleaning previous build files... "
else
    echo -e "${bldred}  ROM will be compiled without cleaning previous build files... "
fi
echo ""
echo ""


# Confirm fetching prebuilts
echo -e "\n\n${bldgrn}  Do you want to move the build after it finishes?\n "
echo ""
echo -e "${bldblu}  1. Yes"
echo -e "${bldblu}  2. No"
echo ""
echo ""
$normal
read askMove



echo ""
echo ""
if [ "$askPrebuilts" == "1" ]
then
    echo -e "${bldred}  Built will be Moved after it finishes... "
else
    echo -e "${bldred}  Build won't be moved... "
fi
echo ""
echo ""


# Confirm toolchain to be used for compilation
# Linaro or default GCC

echo ""
echo -e "\n\n${bldgrn}  Linaro toolchain\n"
echo ""
echo ""
echo -e "${bldblu}  1. NO"
echo -e "${bldblu}  2. Yes, but only use it for ROM"
echo -e "${bldblu}  3. Yes, but only use it for KERNEL"
echo -e "${bldblu}  4. Yes, use it for BOTH"
echo ""
echo -e "${bldblu}  Do you want to compile using Linaro? \n\n"
$normal
read askLinaro

echo ""
echo ""

if [ "$askLinaro" == "2" ] || [ "$askLinaro" == "4" ]  
then
	echo -e "${bldred}  BlissPop ROM will be compiled using Linaro Toolchain... "
else
	echo -e "${bldred}  BlissPop ROM will be compiled using the default GCC Toolchain..."
fi

if [ "$askLinaro" == "3" ] || [ "$askLinaro" == "4" ]
then
	echo -e "${bldred}  Kernel will be compiled using Linaro Toolchain... "
else
	echo -e "${bldred}  Kernel will be compiled using the default GCC Toolchain..."
fi

echo ""
echo ""


sleep 2s

# Clear terminal
clear


# Apply patch to enable compilation with Linaro Toolchain

echo ""
echo ""

if [ "$askLinaro" == "2" ] || [ "$askLinaro" == "4" ]
then
	echo -e "${bldgrn}  Patching build environment to use Linaro Toolchain to compile the ROM... "
	$normal
	cd build
	patch -p1 < ../patches/.linaro/android.diff
	cd ..
fi

echo ""
echo ""

if [ "$askLinaro" == "3" ] || [ "$askLinaro" == "4" ]
then
	echo -e "${bldgrn}  Patching build environment to use Linaro Toolchain to compile the kernel... "
	$normal
	cd build
	patch -p1 < ../patches/.linaro/kernel.diff
	cd ..
fi

echo ""
echo ""


sleep 2s
# Clear terminal
clear


if [ "$askClean" == "1" ]
then
	echo ""
	echo ""
	echo -e "${bldgrn}  Removing files from previous compilations - Cleaning... "
	echo ""
	echo ""
	$normal
	make clobber
fi


# Clear terminal
clear


# Setup environment
echo -e ""
echo -e ""
echo -e "${bldgrn}  Setting up build environment..."
echo -e ""
echo -e ""
$normal
. build/envsetup.sh



# Clear terminal
clear



# Lunch device
echo -e ""
echo -e ""
echo -e "${bldcya}  Choose your device from the lunch menu..."
echo -e ""
echo -e ""
$normal
$green
lunch


# Clear terminal
clear


# Start compilation
echo -e ""
echo -e ""
echo -e "${bldcya}  Starting compilation of BlissPop ROM..."
echo -e ""
echo -e ""
$normal
make bacon
echo -e ""



# Get elapsed time
$blue
res2=$(date +%s.%N)
echo -e ""
echo -e ""
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
echo -e ""
echo -e ""

# Reverting toolchain to default GCC from linaro
if [ "$askLinaro" == "2" ] || [ "$askLinaro" == "3" ] || [ "$askLinaro" == "4" ]
then
	cd build
	git checkout .
	cd ..
fi


# Compilation complete
tput bold
tput setaf 1
clear
echo -e ""
echo -e "THANKS FOR USING BLISSPOP BUILT SCRIPT"
echo -e ""
echo -e ""


# Switch terminal back to normal
$normal

