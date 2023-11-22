#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${MASHTREE}
mkdir -p ${MASHTREE}/tmp

# ------------------------------------------------------------------------
# Run mashtree
# ------------------------------------------------------------------------

echo 1>&2 '# Run mashtree'

if [ "$BOOTSTRAP_REPS" ] ; then
    mashtree_bootstrap.pl \
	--outmatrix ${MASHTREE}/mashtree.tsv \
	--reps ${BOOTSTRAP_REPS} \
	--numcpus ${THREADS} \
	--tempdir ${MASHTREE}/tmp \
	-- \
	--outtree ${MASHTREE}/raw.mashtree.dnd \
	--mindepth 0 \
	${INPUTS}/*.fna \
	> ${MASHTREE}/mashtree.dnd
else
    mashtree \
	--outmatrix ${MASHTREE}/mashtree.tsv \
	--numcpus ${THREADS} \
	--tempdir ${MASHTREE}/tmp \
	--outtree ${MASHTREE}/raw.mashtree.dnd \
	--mindepth 0 \
	${INPUTS}/*.fna \
	> ${MASHTREE}/mashtree.dnd
fi

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

