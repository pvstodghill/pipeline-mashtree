#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${MASHTREE}
mkdir -p ${MASHTREE}/tmp

# ------------------------------------------------------------------------
# Run mashtree
# ------------------------------------------------------------------------

echo 1>&2 '# Run mashtree'

mashtree \
    --numcpus ${THREADS} \
    --outmatrix ${MASHTREE}/mashtree.tsv \
    --outtree ${MASHTREE}/mashtree.dnd \
    --mindepth 0 \
    --tempdir ${MASHTREE}/tmp \
    ${INPUTS}/*.fna

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

