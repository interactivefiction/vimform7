#!/bin/bash

#Copyright 2020 vimform7@gmail.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

VIMFORMBASEPATH=$HOME
VIM="$VIMFORMBASEPATH/.vim/"
VIMFORM7INSTALLDESTCORE="$VIMFORMBASEPATH/.local/bin"
VIMFORM7INSTALLDESTLIBS="$VIMFORMBASEPATH/.vimform7"
DEBDISTRO="/etc/debian_version"
HELPFILE="./vimform7-install.txt"
MODE="DEFAULT"
function parse_argument_param()
{
        B="$(cut -d'=' -f1 <<<"$1")"
        local retval="$(cut -d'-' -f2 <<<"$B")"
        echo "$retval"
}
function parse_argument_data()
{
        local retval="$(cut -d'=' -f2 <<<"$1")"
        echo "$retval"
}
function handle_parameter_data()
{
        parameter=$1
        data=$2
        case $parameter in
        d)      echo "     - Setting installation folder path and name."
                VIMFORMBASEPATH=$data
		VIM="$VIMFORMBASEPATH/.vim/"
		VIMFORM7INSTALLDESTCORE="$VIMFORMBASEPATH/.local/bin"
		VIMFORM7INSTALLDESTLIBS="$VIMFORMBASEPATH/.vimform7"
		if [ ! -d $VIMFORMBASEPATH ]; then
			echo "     - $VIMFORMBASEPATH does not exist."
			echo "     - Attempting to create dir..."
			mkdir -p $VIMFORMBASEPATH
			if [ ! -d $VIMFORMBASEPATH ]; then
				echo "     - Failed to create dir."
				echo ""
				echo " - Installation failed."
				echo ""
				exit
			else
				echo "     - Directory created."
			fi
		fi
                MODE="CUSTOMINSTALL"
                ;;
        h)      echo "     - Show vimform7-install.sh help information."
                echo ""
                cat $HELPFILE
                exit
                ;;
        *)      echo "     - Invalid argument given.  Script exiting."
                echo "     - View help using ./vimform7-install.sh -h"
                exit
                ;;
        esac

}
function check_rpm_dep()
{
	local pkg=$1
	echo "   - Checking for $pkg..."
	RPMCHECK=$(rpm -qa $pkg)
        if [ -n "$RPMCHECK" ];
        then
                echo "   - $pkg is installed"
        else
                echo "   - $pkg is NOT installed"
                echo "   - Attempting to install $pkg..."
                sudo dnf install $pkg
                RPMCHECK=$(rpm -qa $pkg)
        	if [ -n "$RPMCHECK" ]; then
                        echo "  - Installation of $pkg complete." 
                else
                        echo "  - !!!ERROR: Could no install $pkg."
                        echo ""
                        echo " - Installation failed."
                        echo ""
			exit
                fi
        fi
}
function check_deb_dep()
{
	local pkg=$1
	local PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok installed")
	echo "   - Checking for $pkg..."
	if [ "" = "$PKG_OK" ]; then
                echo "   - $pkg is NOT installed"
                echo "   - Attempting to install $pkg..."
		sudo apt-get --force-yes --yes install $pkg
		PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $pkg|grep "install ok installed")
		if [ "" = "$PKG_OK" ]; then
                        echo "  - !!!ERROR: Could not install $pkg."
                        echo ""
                        echo " - Installation failed."
                        echo ""
			exit
		else
                        echo "  - Installation of $pkg complete."
		fi						
	else
		echo "   - $pkg is installed"
	fi
}
echo "VIMFORM - vimform7-install 1.0 (2020 May 10)"
echo ""
echo " - Validating arguments..."
echo ""
echo "   - Total argument count is $#"
if [ "$#" -eq 1 ]; then
        echo "   - First argument: $1"
fi
echo ""
if [ "$#" -gt 1 ]; then
        echo "   - !!!ERROR: Total argument count is $# and the script"
        echo "               viminform7-install.sh requires max of 1"
        echo "               or no arguments in order to run."
        echo ""
        echo "   - View the help info using ./vimform7-install.sh -h"
        echo ""
        exit
fi
if [ "$#" -eq 1 ]; then
	echo " - Parsing arguments..."
else
	echo " - Default installation selected."
fi
echo ""
for var in $@
do
        echo "   - Processing argument $ARGCOUNTER: $var"
        paramval=$(parse_argument_param $var)
        dataval=$(parse_argument_data $var)
        echo "     - Parameter $paramval found..."
        if [ $dataval != $var ]; then
                echo "     - Data for parameter is: $dataval"
        else
                echo "     - No data found."
        fi
        handle_parameter_data $paramval $dataval
done
if [ "$#" -eq 1 ]; then
	echo ""
fi
if [ "$MODE" == "HELP" ]; then
        echo ""
        cat $HELPFILE
        exit
fi
echo " - Checking for system dependencies."
echo ""
if [ ! -f $DEBDISTRO ]; then
	echo " - RPM Based distribution detected."
	echo ""
	testpkg="vim-enhanced"
	check_rpm_dep $testpkg
	testpkg="lynx"
	check_rpm_dep $testpkg
	testpkg="make"
	check_rpm_dep $testpkg
	testpkg="util-linux"
	check_rpm_dep $testpkg
else
	echo " - DEB Based distribution detected."
	echo ""
	testpkg="vim"
	check_deb_dep $testpkg
	testpkg="lynx"
        check_deb_dep $testpkg
	testpkg="make"
        check_deb_dep $testpkg
	testpkg="uuid-runtime"
        check_deb_dep $testpkg
fi
echo ""
echo " - Checking for installation directories..."
echo ""
echo "   - Looking for $VIMFORM7INSTALLDESTCORE..."
#Check if ~/.local/bin/ exists, if not create it.
if [ ! -d $VIMFORM7INSTALLDESTCORE ]; then
	echo "      - Core installation target dir does not exist."
	echo "      - Attempting to create core installation dir."
	mkdir -p $VIMFORM7INSTALLDESTCORE
	if [ ! -d $VIMFORM7INSTALLDESTCORE ]; then
		echo "      - !!!ERROR: Creating core install dir failed."
		echo ""
		echo " - Installation FAILED."
		echo ""
	else
		echo "      - Core installation target dir created."
	fi
else
	echo "     - Core dir $VIMFORM7INSTALLDESTCORE found."
fi
echo ""
echo "   - Looking for $VIMFORM7INSTALLDESTLIBS..."
#Create ~/.vimform7/
if [ ! -d $VIMFORM7INSTALLDESTLIBS ]; then
        echo "      - Lib installation target dir does not exist."
        echo "      - Attempting to create lib installation dir."
        mkdir -p $VIMFORM7INSTALLDESTLIBS
        if [ ! -d $VIMFORM7INSTALLDESTLIBS ]; then
                echo "      - !!!ERROR: Creating lib install dir failed."
		echo ""
		echo " - Installation FAILED."
		echo ""
        else
                echo "      - Lib installation target dir created."
        fi
else
	echo "     - Lib dir $VIMFORM7INSTALLDESTLIBS found."
fi
echo ""
echo "   - Looking for $VIM configuration directory..."
if [ ! -d $VIM ]; then
        echo "     - Configuration dir $VIM does not exist ..."
        echo "     - Attempting to create dir $VIM  ..."
	mkdir -p $VIM
        if [ ! -d $VIM ]; then
                echo "     - !!!ERROR: Cannot create $VIM ."
                echo ""
                echo " - Installation FAILED."
        else
                echo "     - Dir $VIM created"
        fi
else
        echo "     - Dir $VIM was found."
fi
echo ""
echo "   - Looking for $VIM plugin directories..."
PLUGDIR="autoload"
echo "     - Checking for $VIM$PLUGDIR..."
if [ ! -d $VIM$PLUGDIR ]; then
	echo "     - Plugin dir $VIM$PLUGDIR does not exist ..."
	echo "     - Attempting to create dir $VIM$PLUGDIR ..."
	mkdir -p $VIM$PLUGDIR
	if [ ! -d $VIM$PLUGDIR ]; then
		echo "     - !!!ERROR: Cannot create $VIM$PLUGDIR ."
		echo ""
		echo " - Installation FAILED."
	else
		echo "     - Dir $VIM$PLUGDIR created"
	fi
else
	echo "     - Dir $VIM$PLUGDIR was found."
fi
echo ""
PLUGDIR="ftdetect"
echo "     - Checking for $VIM$PLUGDIR..."
if [ ! -d $VIM$PLUGDIR ]; then
        echo "     - Plugin dir $VIM$PLUGDIR does not exist ..."
        echo "     - Attempting to create dir $VIM$PLUGDIR ..."
	mkdir -p $VIM$PLUGDIR
        if [ ! -d $VIM$PLUGDIR ]; then
                echo "     - !!!ERROR: Cannot create $VIM$PLUGDIR ."
                echo ""
                echo " - Installation FAILED."
        else
                echo "     - Dir $VIM$PLUGDIR created"
        fi
else
        echo "     - Dir $VIM$PLUGDIR was found."
fi
echo ""
PLUGDIR="syntax"
echo "     - Checking for $VIM$PLUGDIR..."
if [ ! -d $VIM$PLUGDIR ]; then
        echo "     - Plugin dir $VIM$PLUGDIR does not exist ..."
        echo "     - Attempting to create dir $VIM$PLUGDIR ..."
	mkdir -p $VIM$PLUGDIR
        if [ ! -d $VIM$PLUGDIR ]; then
                echo "     - !!!ERROR: Cannot create $VIM$PLUGDIR ."
                echo ""
                echo " - Installation FAILED."
        else
                echo "     - Dir $VIM$PLUGDIR created"
        fi
else
        echo "     - Dir $VIM$PLUGDIR was found."
fi
echo ""

echo " - Extracting Vimform7 core components..."
#Extract vimform7-cor.tar.xz to VIMFORM7INSTALLDESTCORE
tar xfv vimform7-core.tar.xz -C $VIMFORM7INSTALLDESTCORE
echo ""
echo " - Extracting Vimform7 library components..."
#Extract vimform7-libs.tar.xv to VIMFORM7INSTALLDESTLIBS
tar xfv vimform7-libs.tar.xz -C $VIMFORM7INSTALLDESTLIBS
echo ""
echo " - Extracting Vimform7 VIM plugins..."
#Extract vimform7-vim.tar.xv to $VIM
tar xfv vimform7-vimplugins.tar.xz -C $VIM
echo ""
echo " - Creating Desktop Entry and Init Profile"
VIMFORM7DESKTOPDIR="$HOME/.local/share/applications/"
VIMFORM7ICONDIR="$HOME/.local/share/icons/"
mkdir -p $VIMFORM7DESKTOPDIR
mkdir -p $VIMFORM7ICONDIR
cp "$HOME/.vimform7/Vimform7/vimform7.png" "$HOME/.local/share/icons/vimform7.png"
cp -rfv "$HOME/.vimform7/Vimform7/.vimform7rc-lastopened.INIT" "$HOME/.vimform7/Vimform7/.vimform7rc-lastopened"
VIMFORM7DESKTOPENTRY="$HOME/.local/share/applications/vimform7.desktop"
VIMFORM7ICON="$HOME/.local/share/icons/vimform7.png"
cat > "$VIMFORM7DESKTOPENTRY" << EOF
[Desktop Entry]
Name=vimform7
Comment=Vi plugin for the Inform7 programming language.
Exec=gnome-terminal --command="$HOME/.local/bin/vimform7-open-prj.sh"
Icon=$VIMFORM7ICON
Categories=Game;Emulator;
Type=Application
Terminal=true
X-Desktop-File-Install-Version=0.3
EOF
CURRENTDIR=$PWD
cd $HOME/.vimform7/Vimform7
$HOME/.local/bin/vimform7-create-prj.sh -n="vimform7-template" > /dev/null
cd $CURRENTDIR
CHECKPATH=$(grep VIMFORM ~/.bashrc)
if [ -z "$CHECKPATH" ]; then
echo " - Adding Vimform7 scripts to bashrc path."
cat >> "$HOME/.bashrc" << 'EOF'
#VIMFORM7 Add ~/.local/bin to path
PATH=$PATH:~/.local/bin
EOF
fi
if [ -f $DEBDISTRO ]; then
CHECKPATH=$(grep VIMFORM ~/.profile)
if [ -z "$CHECKPATH" ]; then
echo " - Adding Vimform7 scripts to profile path"
cat >> "$HOME/.profile" << 'EOF'
#VIMFORM7 Add ~/.local/bin to path
PATH=$PATH:~/.local/bin
EOF
fi
fi
echo " - Installation Complete!"
echo ""
echo " - TO USE VIMFORM7 PLESE RESTART YOUR TERMINAL."
echo ""
