#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${MASHTREE}
mkdir -p ${MASHTREE}/tmp

# ------------------------------------------------------------------------
# Run mashtree
# ------------------------------------------------------------------------

echo 1>&2 '# Run mashtree'

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

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

