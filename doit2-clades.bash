#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${CLADES}
mkdir -p ${CLADES}

# ------------------------------------------------------------------------
# Make clades
# ------------------------------------------------------------------------

echo 1>&2 '# Make clades'

${PIPELINE}/mashtree2pyani.pl \
	   < ${MASHTREE}/mashtree.tsv \
	   > ${CLADES}/fixed.tsv


echo 1>&2 '## Make species list'
${PIPELINE}/scripts/make-clades.pl \
	   -M ${CLADES}/fixed.tsv \
	   -c ${SPECIES_CUTOFF} \
	   > ${CLADES}/species.txt

echo 1>&2 '## Make genus list'
${PIPELINE}/scripts/make-clades.pl \
	   -M ${CLADES}/fixed.tsv \
	   -c ${GENUS_CUTOFF} \
	   > ${CLADES}/genus.txt

echo 1>&2 '## Make .dot file'
${PIPELINE}/scripts/make-clades.pl \
	   -M ${CLADES}/fixed.tsv \
	   -c 0.0 \
	   -d ${CLADES}/mashtree.dot \
	   > /dev/null



# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

