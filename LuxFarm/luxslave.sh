#!/bin/bash -l
module purge
module unload compilers
module load compilers/gnu/4.6.3
module load luxrender
if [[ -z "$TMPDIR" ]]; then
	echo "No TMPDIR set for luxslave." >&2
	exit 5
fi
luxconsole -s -c ${TMPDIR}

