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
HELPFILE="$VIMFORM7BASE/Vimform7/vimform7-open-prj.txt"
VIMFORMVIM="vim"
VIMFORM7PROJECTFOLDER="ERROR"
VIMFORM7ENABLEPLAYER="NO"
VIMFORM7ENABLEHELP="NO"
MODE="HELP"
VIMFORM7OPENDEFAULT="$HOME/.vimform7/Vimform7/.vimform7rc-lastopened"
source "$VIMFORM7SCRIPTS/vimform7-common.sh"
source "$VIMFORM7OPENDEFAULT"
function update_last_opened_project()
{
	cp "$VIMFORM7OPENDEFAULT" "$VIMFORM7OPENDEFAULT.BAK"
	rm -rf "$VIMFORM7OPENDEFAULT"
cat > "$VIMFORM7OPENDEFAULT" << EOF
VIMFORM7LASTOPENED=$VIMFORM7PROJECTFOLDER
EOF

	
}
function exit_script()
{
	update_last_opened_project
	echo " - Thanks for using Vimform7!!!"
	echo ""
	exit
}
function handle_parameter_data()
{
	parameter=$1
	data=$2
	case $parameter in
	f)	echo "     - Setting project folder path and name."
		VIMFORM7PROJECTFOLDER=$data
		MODE="OPENPRJ"
		;;
	p)	echo "     - Enabling  player in VIM view."
		VIMFORM7ENABLEPLAYER="YES"
		;;
	7h)	echo "     - Enabling Inform7 help in VIM view."
		VIMFORM7ENABLEHELP="YES"
		;;
	h)	echo "     - Show vimform7-open-prj.sh help information."
                echo ""
                cat $HELPFILE
                exit		
		;;
	g)	echo "     - Selecting GVIM instead of VIM."
		VIMFORMVIM="gvim"
		;;
	*)	echo "     - Invalid argument given.  Script exiting."
		echo "     - View help using ./vimform7-open-prj.sh -h"
       		exit
		;;
	esac
		
}
clear
echo "VIMFORM - vimform7-open-prj 1.0 (2020 May 10)"
echo ""
echo " - Validating arguments..."
echo ""
echo "   - Total argument count is $#"
if [ "$#" -eq 0 ]; then
	cd $VIMFORM7LASTOPENED && $VIMFORMVIM "./Source/story.ni" -c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim'
	VIMFORM7PROJECTFOLDER=$VIMFORM7LASTOPENED
	exit_script
fi
if [ "$#" -ge 1 ]; then
        echo "   - First argument: $1"
        if [ "$#" -ge 2 ]; then
                echo "   - Second argument: $2"
        fi
	if [ "$#" -ge 3 ]; then
		echo "   - Third argument: $3"
	fi
	if [ "$#" -eq 4 ]; then
		echo "   - Fourth argument: $4"
	fi
fi
echo ""
if (([ "$#" -gt 4 ])||([ "$#" -lt 1 ])); then
        echo "   - !!!ERROR: Total argument count is $# and the script"
        echo "               viminform7-open-prj.sh requires 1 to 3"
        echo "               arguments in order to run."
        echo ""
        echo "   - View the help info using ./vimform7-open-prj.sh -h"
        echo ""
        exit
fi
echo " - Parsing arguments..."
echo ""
for var in "$@"
do
	echo "   - Processing argument $ARGCOUNTER: $var"
	paramval="$(parse_argument_param $var)"
	#dataval="$(parse_argument_data $var)"
	dataval=$(cut -d'=' -f2- <<<"$var")
	ls -al "$dataval"
	echo "     - Parameter $paramval found..."
	if [ "$dataval" != "$var" ]; then
		echo "     - Data for parameter is: $dataval"
	else
		echo "     - No data found."
	fi
	handle_parameter_data "$paramval" "$dataval"
done
if [ "$MODE" == "HELP" ]; then
        echo ""
        cat $HELPFILE
        exit
fi
VIMCMDPARAMS="-c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim'"
if [ "$MODE" == "OPENPRJ" ]; then
	echo ""
	echo " - Executing project open request..."
	echo ""
	CURRENTPATH=$PWD
        SOURCEFILE="./Source/story.ni"
        echo "   - Main story file expected at: $VIMFORM7PROJECTFOLDER/Source/story.ni"
	if [ "$VIMFORM7ENABLEHELP" == "YES" ]; then
		if [ "$VIMFORM7ENABLEPLAYER" == "YES" ]; then
			echo "   - Attempting to open with Inform7 help and player..."
			echo "   - Attempt to build project to play.."
			cd $VIMFORM7PROJECTFOLDER
			make
			if [ ! -f "./Build/output.gblorb" ]; then
				echo "   - No valid gblorb to open for play."
				echo "   - Try using vimform7-open-prj.sh without -p option."
				echo ""
				echo " - Thanks for using Vimform7 :-> !!!"
				echo ""
				exit
			fi
			cd "$CURRENTPATH"
			cd $VIMFORM7PROJECTFOLDER && $VIMFORMVIM $SOURCEFILE -c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim' -c 'execute "normal -7ph"'
			VIMFORM7PROJECTFOLDER=$PWD
			cd "$CURRENTPATH"
			echo ""
			echo ""
			exit_script
		else
			echo "   - Attempting to open with Inform7 help..."
			cd $VIMFORM7PROJECTFOLDER && $VIMFORMVIM $SOURCEFILE -c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim' -c 'execute "normal -7h"'
			VIMFORM7PROJECTFOLDER=$PWD
			cd "$CURRENTPATH"
			echo ""
			echo ""
			exit_script
		fi
	fi
	if [ "$VIMFORM7ENABLEPLAYER" == "YES" ]; then
		echo "   - Attempt to build project to play.."
		cd $VIMFORM7PROJECTFOLDER
		make
		if [ ! -f "./Build/output.gblorb" ]; then
			echo "   - No valid gblorb to open for play."
			echo "   - Try using vimform7-open-prj.sh without -p option."
			echo ""
			echo " - Thanks for using Vimform7 :-> !!!"
			echo ""
			exit
		fi
		cd "$CURRENTPATH"
		if [ "$VIMFORM7ENABLEHELP" == "YES" ]; then
			echo "   - Attempting to open with Inform7 help and player..."
			cd $VIMFORM7PROJECTFOLDER && $VIMFORMVIM $SOURCEFILE -c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim' -c 'execute "normal -7ph"'
			VIMFORM7PROJECTFOLDER=$PWD
			cd "$CURRENTPATH"
			echo ""
			echo ""
			exit_script
		else
			echo "   - Attempting to open with Inform7 player..."
			cd $VIMFORM7PROJECTFOLDER && $VIMFORMVIM $SOURCEFILE -c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim' -c 'execute "normal -7p"'
			VIMFORM7PROJECTFOLDER=$PWD
			cd "$CURRENTPATH"
			echo ""
			echo ""
			exit_script
		fi
	fi
	echo "   - Attempting to open with main source file only..."
	cd $VIMFORM7PROJECTFOLDER && $VIMFORMVIM $SOURCEFILE -c 'set tabstop=4' -c 'set breakindent' -c 'set breakindentopt=shift:4' -c 'set linebreak' -c 'runtime autoload/inform.vim'
	VIMFORM7PROJECTFOLDER=$PWD
	cd "$CURRENTPATH"
	echo ""
	echo ""
	exit_script
fi
