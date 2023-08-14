#! /bin/bash

. $(dirname ${BASH_SOURCE[0]})/doit-preamble.bash

# ------------------------------------------------------------------------

rm -rf ${CLADES}
mkdir -p ${CLADES}

# ------------------------------------------------------------------------
# Creating the `sed` exprs for name substitutions
# ------------------------------------------------------------------------

if [ -z "${REPLICON_NAMES}" ] ; then
    REPLICON_NAMES=/dev/null
fi

cat ${REPLICON_NAMES} \
    | sed -e 's/ *#.*//' \
    | grep -v '^$/' \
    | tr '\t' '\a' \
    | (
    while IFS=$'\a' read OLD NEW ; do
	echo "s/\<$OLD\>/$NEW/g"
    done
) > ${CLADES}/names.sed


# ------------------------------------------------------------------------
# Make clades
# ------------------------------------------------------------------------

echo 1>&2 "# Converting distances to %similarity's"

cat ${MASHTREE}/mashtree.tsv \
    | ${PIPELINE}/mashtree2pyani.pl \
    | sed -f ${CLADES}/names.sed \
	   > ${CLADES}/fixed.tsv

echo 1>&2 "# Computing sequence lengths"

for FNA in ${INPUTS}/*.fna ; do
    NAME=$(basename $FNA .fna)
    LEN=$(${PIPELINE}/scripts/fasta-length < $FNA)
    echo ${NAME}$'\t'${LEN} \
	| sed -f ${CLADES}/names.sed \
	      >> ${CLADES}/lens.tsv
done

function run_clades {
    CLADE_NAME=$1
    CLADE_CUTOFF=$2
    CLADE_NAMES=$3

    echo 1>&2 "# Making ${CLADE_NAME}s"
    
    if [ -z "$CLADE_NAMES" ] ; then
	CLADE_NAMES=/dev/null
    fi

    ${PIPELINE}/scripts/make-clades.pl \
	       -M ${CLADES}/fixed.tsv \
	       -L ${CLADES}/lens.tsv \
	       -c ${CLADE_CUTOFF} \
	       -t > ${CLADES}/${CLADE_NAME}.tsv

    ${PIPELINE}/scripts/make-clades.pl \
	       -M ${CLADES}/fixed.tsv \
	       -L ${CLADES}/lens.tsv \
	       -N ${CLADE_NAMES} \
	       -U $(date +%Y-%m-%d). \
	       -c ${CLADE_CUTOFF} \
	       > ${CLADES}/${CLADE_NAME}.txt
}

if [ "$CLADE1_NAME" ] ; then
    run_clades $CLADE1_NAME $CLADE1_CUTOFF $CLADE1_NAMES
fi
if [ "$CLADE2_NAME" ] ; then
    run_clades $CLADE2_NAME $CLADE2_CUTOFF $CLADE2_NAMES
fi
if [ "$CLADE3_NAME" ] ; then
    run_clades $CLADE3_NAME $CLADE3_CUTOFF $CLADE3_NAMES
fi


echo 1>&2 '# Make .dot file'
${PIPELINE}/scripts/make-clades.pl \
	   -M ${CLADES}/fixed.tsv \
	   -c 0.0 \
	   -d ${CLADES}/mashtree.dot \
	   > /dev/null



# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------

echo 1>&2 '# Done.'

