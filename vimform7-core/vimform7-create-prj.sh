#!/bin/bash

#Copyright 2020 vimform7@gmail.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

VIMFORM7BASE="$HOME/.vimform7"
VIMFORM7AUTHOR="Vimform7-Placeholder-Author"
VIMFORM7TITLE="Vimform7-Placeholder-Title"
INFORM7COMPILERS="$VIMFORM7BASE/Compilers"
NICOMPILER="$INFORM7COMPILERS/ni"
INFORM6COMPILER="$INFORM7COMPILERS/inform6"
CBLORBCOMPILER="$INFORM7COMPILERS/cBlorb"
HELPFILE="$VIMFORM7BASE/Vimform7/vimform7-create-prj.txt"
clear
echo "VIMFORM - vimform7-create-prj 1.0 (2020 May 10)"
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
	echo "               viminform7-create-prj.sh requires 1 to 2"
	echo "               arguments in order to run."
	echo ""
	echo "   - View the help info using ./vimform7-create-prj.sh -h"
	echo ""
	exit
fi
echo " - Parsing arguments..."
echo ""
MODE="HELP"
PRJNAME=""
PRJFRMT=""
if [ "$#" -ge 1 ]; then
	A="$(cut -d'=' -f2 <<<"$1")"
	B="$(cut -d'=' -f1 <<<"$1")"
	PARAM1="$(cut -d'-' -f2 <<<"$B")"
	echo "   - Argument 1 is option $PARAM1 with data $A."
	if [ "$PARAM1" == "n" ]; then
		MODE="DEFAULT PROJECT"
		PRJNAME=$A
	elif [ "$PARAM1" == "f" ]; then
		MODE="CUSTOM PROJECT"
		PRJFRMT=$A
	elif [ "$PARAM1" == "h" ]; then
		MODE="HELP"
	else
		MODE="HELP"
		echo "   - !!!ERROR: Unknown arg $PARAM1. Script mode is now $MODE."

	fi
fi
if [ "$MODE" == "HELP" ]; then
	echo ""
	cat $HELPFILE
	exit
fi
if [ "$#" -eq 2 ]; then
	A="$(cut -d'=' -f2 <<<"$2")"
	B="$(cut -d'=' -f1 <<<"$2")"
	PARAM2="$(cut -d'-' -f2 <<<"$B")"
	echo "   - Argument 2 is option $PARAM2 with data $A."
        if [ "$PARAM2" == "n" ]; then
                if [ "$PRJNAME" != "" ]; then
                        MODE="HELP"
			echo " *** prj name not empty"
                elif [ "$PRJFRMT" == "" ]; then
                        MODE="HELP"
			echo " *** prj fmt is empty"
                else
                        MODE="CUSTOM PROJECT"
                        PRJNAME=$A
                fi
       	elif [ "$PARAM2" == "f" ]; then
                if [ "$PRJNAME" == "" ]; then
			echo " *** prj name is empty"
                        MODE="HELP"
                elif [ "$PRJFRMT" != "" ]; then
			echo " *** prj fmt is not empty"
                        MODE="HELP"
                else
                        MODE="CUSTOM PROJECT"
                        PRJFRMT=$A
                fi
        elif [ "$PARAM2" == "h" ]; then
                MODE="HELP"
        else
                MODE="HELP"
                echo "   - !!!ERROR: Unknown arg $PARAM1. Script mode is now $MODE."
	fi
else
	if [ "$PRJNAME" == "" ]; then
		MODE="HELP"
	elif [ "$PRJFRMT" != "" ]; then
		MODE="HELP"
	else
		PRJFRMT="ulx"
	fi
fi
if [ "$PRJFRMT" != "z8" ]; then
	if [ "$PRJFRMT" != "ulx" ]; then
		echo ""
		echo "   - !!!ERROR: Project format not recognized: $PRJFRMT"
		echo ""
		MODE="HELP"
	else
		PRJFRMT="ulx"
	fi
fi
if [ "$MODE" == "HELP" ]; then
        cat $HELPFILE
        exit
fi
PRJDIR="./$PRJNAME.inform"
PRJUUID="./$PRJNAME.inform/uuid.txt"
PRJMAKE="./$PRJNAME.inform/makefile"
PRJSRCDIR="./$PRJNAME.inform/Source"
PRJSRC="./$PRJNAME.inform/Source/story.ni"
if [ -d "$PRJDIR" ]; then
	echo ""
	echo " - Nothing to do project $PRJNAME already exists."
	echo " - Please see directory:./$PRJNAME.inform"
	echo ""
	exit
fi
echo ""
echo " - Parsing complete.  Script mode is $MODE"
echo ""
echo " - Preparing project for..."
echo ""
echo "   - Inform7 Project Name: $PRJNAME"
echo "   - Inform7 Project Type: $PRJFRMT"
echo ""
echo "     - Creating directory $PRJDIR"
mkdir "$PRJDIR"
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
echo "     - Creating uuid $PRJUUID"
uuidgen -t > "$PRJUUID"
echo "     - Tuncating uuid.txt by one byte for Inform6 & CBlorb."
truncate -s -1 "$PRJUUID"
UUIDVAL="$(cat "$PRJUUID")"
echo "     - UUID is: $UUIDVAL"
echo "     - Creating initial project source directory."
mkdir "$PRJSRCDIR"
cat > "$PRJSRC" << EOF
"$VIMFORM7TITLE" by "$VIMFORM7AUTHOR"

Vimform7 is a room.  The description of Vimform7 is "A simple workbench sits before you, designed simply to allow creators to edit and compile Inform7 code using existing tool such as VIM, Make, and Lynx".
EOF
echo ""
echo " - !!!DONE: Project Created at $PRJDIR"
echo ""
