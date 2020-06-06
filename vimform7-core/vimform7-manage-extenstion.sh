#!/bin/bash

#Copyright 2020 vimform7@gmail.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

VIMFORM7TARGETEXTNAME="INVALID"
VIMFORM7TARGETDISTRODIR="./"
VIMFORM7BASE="$HOME/.vimform7"
HELPFILE="$VIMFORM7BASE/Vimform7/vimform7-manage-extenstion.txt"
VIMFORM7SCRIPTS="$HOME/.local/bin"
MODE="ADD"
source "$VIMFORM7SCRIPTS/vimform7-common.sh"
function handle_parameter_data()
{
	parameter=$1
	data=$2
	case $parameter in
	e)	echo "     - Setting extenstion $data for processing."
		VIMFORM7TARGETEXTNAME=$data
		echo "     - Extenstion target name is: $VIMFORM7TARGETEXTNAME"
		;;
	a)	echo "     - Preparing to add extension to ~/Inform."
		MODE="ADD"
		;;
	r)	echo "     - Preparing to remove extension from ~/Inform."
		MODE="REMOVE"
		;;
	h)	echo "     - Show vimform7-manage-extenstion.sh help information."
                echo ""
                cat $HELPFILE
                exit		
		;;
	*)	echo "     - Invalid argument given.  Script exiting."
		echo "     - View help using vimform7-manage-extenstion.sh -h"
       		exit
		;;
	esac
		
}
clear
echo "VIMFORM - vimform7-manage-extenstion 1.0 (2020 June 4)"
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
if ([ "$#" -gt 2 ]); then
        echo "   - !!!ERROR: Total argument count is $# and the script"
        echo "               vimform7-manage-extenstion.sh requires 0 to 1"
        echo "               arguments in order to run."
        echo ""
        echo "   - View the help info using vimform7-manage-extenstion.sh -h"
        echo ""
        exit
fi
echo " - Parsing arguments..."
echo ""
for var in "$@"
do
	echo "   - Processing argument $ARGCOUNTER: $var"
	paramval=$(parse_argument_param $var)
	#dataval=$(parse_argument_data $var)
	dataval=$(cut -d'=' -f2- <<<"$var")
	echo "     - Parameter $paramval found..."
	handle_parameter_data "$paramval" "$dataval"
done
echo ""
echo " - Parsing complete.  Script mode is $MODE"
echo ""
echo " - Preparing to process extension script request..."
echo ""
if [ "$MODE" == "HELP" ]; then
        echo ""
        cat $HELPFILE
        exit
fi
USEREXTENSIONSFOLDER=$HOME/Inform/Extensions
if [ -d "$USEREXTENSIONSFOLDER" ]; then
	echo " - User extension folder exists."
else
	echo " - No extension folder for user."
	echo " - Attempting to create extension folder $HOME/Inform/Extensions"
	mkdir -p "$HOME/Inform/Extensions"
	if [ -d "$USEREXTENSIONSFOLDER" ]; then
		echo " - User extension folder created."
	else
		echo " - User extension folder could not be created."
		echo " - Extension installation FAILED."
		exit
	fi	
fi
VIMFORM7EXTAUTHOR=$(grep 'begins here.' "$VIMFORM7TARGETEXTNAME"  | sed 's/^.*by/by/' | sed -e 's/\<by\>//g' | sed -e 's/\<begins here\>//g' | cut -f1 -d "." | sed "s/^[ \t]*//" | sed 's/[[:blank:]]*$//')
VIMFORM7EXTNAME=$(grep 'begins here.' "$VIMFORM7TARGETEXTNAME"  | sed 's/by.*//g' | sed 's/^.*of/of/' | sed -e 's/\<of\>//g' | sed "s/^[ \t]*//" | sed 's/[[:blank:]]*$//')
echo " - Extension Author Is: $VIMFORM7EXTAUTHOR"
echo " - Extension Name Is: $VIMFORM7EXTNAME"
if [ -d "$USEREXTENSIONSFOLDER/$VIMFORM7EXTAUTHOR" ]; then
	echo " - User extension folder for author $USEREXTENSIONSFOLDER/$VIMFORM7EXTAUTHOR exists."
else
	echo " - No extension folder for author: "
	echo " - Attempting to create extension folder for author $USEREXTENSIONSFOLDER/$VIMFORM7EXTAUTHOR"
	mkdir -p "$USEREXTENSIONSFOLDER/$VIMFORM7EXTAUTHOR"
	if [ -d "$USEREXTENSIONSFOLDER/$VIMFORM7EXTAUTHOR" ]; then
		echo " - Author extension folder created."
	else
		echo " - Author extension folder could not be created."
		echo " - Extension installation FAILED."
		exit
	fi
fi
VIMFORM7FILENAMEWITHPATH="$USEREXTENSIONSFOLDER/$VIMFORM7EXTAUTHOR/$VIMFORM7EXTNAME.i7x"
echo " - Target file path and name is: $VIMFORM7FILENAMEWITHPATH"
if [ -f "$VIMFORM7FILENAMEWITHPATH" ]; then
	echo " - Target file already exists."
	read -p " - Do you want to overwrite the existing file (Y/n): " -n1 answer
	echo ""
	if [ "$answer" == "Y" ]; then
		echo " - Target file will be overwritten."
		cp -rfv "$VIMFORM7TARGETEXTNAME" "$VIMFORM7FILENAMEWITHPATH"
	fi
else
	echo " - Copying file to destination."
	cp -rfv "$VIMFORM7TARGETEXTNAME" "$VIMFORM7FILENAMEWITHPATH"
fi
echo ""
echo " - Installation SUCCESS."
echo ""
echo "Summary:"
echo ""
echo "Extension Source File: $VIMFORM7TARGETEXTNAME"
echo "Extension Author: $VIMFORM7EXTAUTHOR"
echo "Extension Name: $VIMFORM7EXTNAME"
echo ""
echo "Now Installed To: $VIMFORM7FILENAMEWITHPATH"
echo ""
echo ""
	
