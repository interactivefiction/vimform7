#!/bin/bash

#Copyright 2020 vimform7@gmail.com
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

VIMFORM7TARGETDISTRONAME="Vimform7-"$(date +"%m-%d-%Y-%H%M%S")
VIMFORM7TARGETDISTRODIR="./"
VIMFORM7BASE="$HOME/.vimform7"
HELPFILE="$VIMFORM7BASE/Vimform7/vimform7-make-distro.txt"
VIMFORM7SCRIPTS="$HOME/.local/bin"
source "$VIMFORM7SCRIPTS/vimform7-common.sh"
function handle_parameter_data()
{
	parameter=$1
	data=$2
	case $parameter in
	n)	echo "     - Setting distro name."
		VIMFORM7TARGETDISTRONAME=$data
		echo "     - Distro target name is: $VIMFORM7TARGETDISTRONAME"
		MODE="CUSTOM"
		;;
	h)	echo "     - Show vimform7-make-distro.sh help information."
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
echo "VIMFORM - vimform7-make-distro 1.0 (2020 May 10)"
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
if ([ "$#" -gt 1 ]); then
        echo "   - !!!ERROR: Total argument count is $# and the script"
        echo "               viminform7-make-distro.sh requires 0 to 1"
        echo "               arguments in order to run."
        echo ""
        echo "   - View the help info using ./vimform7-make-distro.sh -h"
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
echo " - Preparing distro..."
echo ""
if [ "$MODE" == "HELP" ]; then
        echo ""
        cat $HELPFILE
        exit
fi
mkdir "$VIMFORM7TARGETDISTRODIR$VIMFORM7TARGETDISTRONAME"
cd "$VIMFORM7TARGETDISTRODIR$VIMFORM7TARGETDISTRONAME"
mkdir -p ./.vim/autoload
mkdir -p ./.vim/syntax
mkdir -p ./.vim/ftdetect
cp -rfv $HOME/.vimform7 ./
rm -fv ./.vimform7/Vimform7/.vimform7rc-lastopened
cp $HOME/.vim/autoload/inform.vim ./.vim/autoload
cp $HOME/.vim/syntax/inform7.vim ./.vim/syntax
cp $HOME/.vim/ftdetect/inform7.vim ./.vim/ftdetect
mkdir -p ./.local/bin
cp $HOME/.local/bin/vimform7-* ./.local/bin
cp ./.vimform7/Vimform7/vimform7-install.sh ./
cp ./.vimform7/Vimform7/vimform7-install.txt ./
cp ./.vimform7/Vimform7/vimform7-uninstall.sh ./
tar -cJf vimform7-vimplugins.tar.xz -C ./.vim .
tar -cJf vimform7-libs.tar.xz -C ./.vimform7 .
tar -cJf vimform7-core.tar.xz -C ./.local/bin .
rm -rfv ./.vim
rm -rfv ./.local
rm -rfv ./.vimform7
cd ..
ls -al
mkdir ./PACKAGE
cp -rfv "$VIMFORM7TARGETDISTRODIR$VIMFORM7TARGETDISTRONAME" ./PACKAGE
cd ./PACKAGE
tar -cJf "$VIMFORM7TARGETDISTRONAME.tar.xz" -C "./$VIMFORM7TARGETDISTRONAME" .
cd ..
mv "./PACKAGE/$VIMFORM7TARGETDISTRONAME.tar.xz" ./
rm -rfv ./PACKAGE
rm -rfv "$VIMFORM7TARGETDISTRODIR$VIMFORM7TARGETDISTRONAME"
