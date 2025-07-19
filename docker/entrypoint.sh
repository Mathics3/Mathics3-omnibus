#!/bin/bash
# This is the docker entry point and gets installed as /usr/local/bin/mathics.sh

USER_HOME="/home/ubuntu"
MATHICS_DJANGO_SYSTEM_DB_PATH="${USER_HOME}/.local/var/Mathics3/mathics.sqlite"

export PATH="/opt/python3.13/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${USER_HOME}/.local/bin"
export PYTHONBREAKPOINT=trepan.api.debug

script_cmd="${ENTRYPOINT_COMMAND:-$(basename $0)}"

function help {
    cat <<EOF

Usage:
    $script_cmd [arg] [-- params, ...]

Arg:

    -h | --help               Print this help and exit

    --pythonpath              This will be added to PYTHONPATH. Example use-case - absolute path to
                              basedir of mathics source code inside container

    -m | --mode {cli|ui|gui|minimal|pdf|copy}
                              Start mathics in either:
                                 * web-ui mode (ui or gui),
                                 * cli mode (cli) or minimal.
								 * viewing manual (pdf) or document
								 * copy the manual mathics.pdf to the host computer
                              Default is cli.
                              See: https://github.com/Mathics3/mathics-core/wiki/Installing#running-mathics

Params:

    Everything passed after '--' will be passed to mathics as is.

EOF
}

mathics_mode=cli
COPY_DOC=0

while (( $# )) ; do
    case "$1" in
        -h | --help)  help ; exit ;;
        -m | --mode)
			mathics_mode="$2"
			shift 2
			;;
        --pythonpath) export PYTHONPATH="$2":$PYTHONPATH ; shift 2 ;;
        --)           shift ; break ;;
        *)            echo "Can't parse '$@'. See '$0 --help'" ; exit 1 ;;
    esac
done

case $mathics_mode in
    cli) mathicsscript $@
		 ;;
    mathics3-tokens) python ${USER_HOME}/mathics-scanner/mathics_scanner/mathics3_tokens.py $@
		 ;;
    minimal|mathics|mathics3)
		mathics $@
		;;
    document|pdf)
		evince ${USER_HOME}/mathics-core/mathics/doc/latex/mathics.pdf
		;;
    copy)
		echo "Copying mathics.pdf to host-attached filesystem ${TEMPDIR}."
		cp ${USER_HOME}/mathics-core/mathics/doc/latex/mathics.pdf /usr/src/app/data/mathics.pdf
		;;
    django|ui|gui)
	echo
	echo "~~~~ app/data has been mounted to $MATHICS_HOME/data ~~~~"
	if [[ -n $MATHICS_DJANGO_DB_PATH ]]; then
	    echo "~~~~ SQLite data (worksheets, user info) will be stored in $MATHICS_DJANGO_DB_PATH ~~~~"
		if [[ ! -s $MATHICS_DJANGO_DB_PATH ]] && [[ -n $MATHICS_DJANGO_SYSTEM_DB_PATH ]]; then
			echo "~~~~ Copying internal SQLite data (worksheets, user info) to location specified in \$MATHICS_DJANGO_DB_PATH"
			cp -vp $MATHICS_DJANGO_SYSTEM_DB_PATH $MATHICS_DJANGO_DB_PATH
		fi
	else
	    echo "~~~~ SQLite data (worksheets, user info) will be stored in $MATHICS_HOME/data/mathics.sqlite"
	fi
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo
	mathicsserver -e $@ ;;
    shell)  /bin/bash ;;
    *)   echo "unknown mathics_mode=$mathics_mode. See '$script_cmd --help'" ; exit 2 ;;
esac
