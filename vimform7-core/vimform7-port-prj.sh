#!/bin/bash

#Copyright 2020 vimform7@gmail.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

VIMFORM7SCRIPTS="$HOME/.local/bin"
VIMFORM7BASE="$HOME/.vimform7"
INFORM7COMPILERS="$VIMFORM7BASE/Compilers"
NICOMPILER="$INFORM7COMPILERS/ni"
INFORM6COMPILER="$INFORM7COMPILERS/inform6"
CBLORBCOMPILER="$INFORM7COMPILERS/cBlorb"
HELPFILE="$VIMFORM7BASE/Vimform7/vimform7-port-prj.txt"
VIMFORMVIM="vim"
VIMFORM7PROJECTFOLDER="ERROR"
VIMFORM7ENABLEPLAYER="NO"
VIMFORM7ENABLEHELP="NO"
MODE="HELP"
PRJFRMT="ulx"
PRJMAKE=""
PRJNAME=""
source "$VIMFORM7SCRIPTS/vimform7-common.sh"
function handle_parameter_data()
{
	parameter=$1
	data=$2
	case $parameter in
	f)	echo "     - Setting project folder path and name."
		VIMFORM7PROJECTFOLDER=$data
		A=`basename "$data"`
		B="$(cut -d'.' -f1 <<<"$A")"
		echo "     - Project path is: $data"
		echo "     - Project name is: $B"
		PRJNAME=$B
		M="makefile"
		PRJMAKE="$data/$M"
		echo "     - Project make path: $PRJMAKE"
		MODE="PORTPRJ"
		;;
	t)	echo "     - Setting project type to $data."
		PRJFRMT=$data
		;;
	h)	echo "     - Show vimform7-port-prj.sh help information."
                echo ""
                cat $HELPFILE
                exit
		;;
	*)	echo "     - Invalid argument given.  Script exiting."
		echo "     - View help using ./vimform7-port-prj.sh -h"
       		exit
		;;
	esac

}
clear
echo "VIMFORM - vimform7-port-prj 1.0 (2020 May 10)"
echo ""
echo " - Validating arguments..."
echo ""
echo "   - Total argument count is $#"
if [ "$#" -ge 1 ]; then
        echo "   - First argument: $1"
        if [ "$#" -eq 2 ]; then
                echo "   - Second argument: $2"
        fi
fi
echo ""
if (([ "$#" -gt 2 ])||([ "$#" -lt 1 ])); then
        echo "   - !!!ERROR: Total argument count is $# and the script"
        echo "               viminform7-port-prj.sh requires 1 to 2"
        echo "               arguments in order to run."
        echo ""
        echo "   - View the help info using ./vimform7-port-prj.sh -h"
        echo ""
        exit
fi
echo " - Parsing arguments..."
echo ""
for var in "$@"
do
	echo "   - Processing argument $ARGCOUNTER: $var"
	paramval="$(parse_argument_param $var)"
	dataval=$(cut -d'=' -f2- <<<"$var")
	echo "     - Parameter $paramval found..."
	if [ "$dataval" != "$var" ]; then
		echo "     - Data for parameter is: $dataval"
	else
		echo "     - No data found."
	fi
	handle_parameter_data "$paramval" "$dataval"
done
echo ""
echo " - Parsing complete.  Script mode is $MODE"
echo ""
echo " - Preparing project for..."
echo ""
echo "   - Inform7 Project Name: $PRJNAME"
echo "   - Inform7 Project Type: $PRJFRMT"
echo ""
if [ "$MODE" == "HELP" ]; then
        echo ""
        cat $HELPFILE
        exit
fi
echo "     - Creating makefile $PRJMAKE"
cat > "$PRJMAKE" << EOF
MAKEENVIRONMENT=$VIMFORM7BASE
MAKECOMPILERS=$INFORM7COMPILERS
WORKSPACEFOLDER=".."
PROJECTNAME=$PRJNAME
default:
	make $PRJFRMT
	make inform6
	make cblorb
all:
	make default
z8:
EOF
cat >> "$PRJMAKE" << 'EOF'
	$(MAKECOMPILERS)/ni -internal $(MAKEENVIRONMENT) -format=z8 -project "$(WORKSPACEFOLDER)/
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << EOF
$PRJNAME.inform" -release
ulx:
EOF
cat >> "$PRJMAKE" << 'EOF'
	$(MAKECOMPILERS)/ni -internal $(MAKEENVIRONMENT) -format=ulx -project "$(WORKSPACEFOLDER)/
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << EOF
$PRJNAME.inform" -release
inform6:
EOF
cat >> "$PRJMAKE" << 'EOF'
	$(MAKECOMPILERS)/inform6 -wxE2~S~DG $(huge) "$(WORKSPACEFOLDER)/
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << EOF
$PRJNAME.inform/Build/auto.inf"
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << 'EOF'
 "$(WORKSPACEFOLDER)/
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << EOF
$PRJNAME.inform/Build/output.$PRJFRMT"
cblorb:
EOF
cat >> "$PRJMAKE" << 'EOF'
	$(MAKECOMPILERS)/cBlorb -unix "$(WORKSPACEFOLDER)/
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << EOF
$PRJNAME.inform/Release.blurb"
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << 'EOF'
 "$(WORKSPACEFOLDER)/
EOF
truncate -s -1 "$PRJMAKE"
cat >> "$PRJMAKE" << EOF
$PRJNAME.inform/Build/output.gblorb"
EOF
echo "     - Attempting to build $PRJNAME.inform from makefile..."
echo ""
echo ""
CURRENTPWD=$PWD
cd "$VIMFORM7PROJECTFOLDER"
make
cd $CURRENTPWD
echo ""
echo " - !!!DONE: Project at $PRJDIR ported to makefile."
echo ""
