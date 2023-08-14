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
    echo ${NAME}$'\t'${LEN} >> ${CLADES}/lens.tsv
done

function run_clades {
    CLADE_NAME=$1
    CLADE_CUTOFF=$2

    echo 1>&2 "# Making $CLADE_NAME"
    
    ${PIPELINE}/scripts/make-clades.pl \
	       -M ${CLADES}/fixed.tsv \
	       -c ${CLADE_CUTOFF} \
	       -t > ${CLADES}/raw.${CLADE_NAME}.tsv

    # Add lengths in third column

    join -a 1 -e FIXME -t $'\t' -1 2 -2 1 \
	 <(sort -k2,2 ${CLADES}/raw.${CLADE_NAME}.tsv) \
	 ${CLADES}/lens.tsv \
	| perl -ane 'print "$F[1]\t$F[0]\t$F[2]\n"' \
	| sort -n \
	       > ${CLADES}/${CLADE_NAME}.tsv

    rm -f ${CLADES}/raw.${CLADE_NAME}.tsv

    ${PIPELINE}/scripts/make-clades.pl \
	       -M ${CLADES}/fixed.tsv \
	       -c ${CLADE_CUTOFF} \
	       > ${CLADES}/raw.${CLADE_NAME}.txt

    # Add lengths in names
    cat ${CLADES}/lens.tsv \
	| sed -E -e 's|^(.*)\t(.*)|s/\\<\1\\>/\& [\2]/|' \
	      > ${CLADES}/raw.${CLADE_NAME}.sed
    cat ${CLADES}/raw.${CLADE_NAME}.txt \
	| sed -f ${CLADES}/raw.${CLADE_NAME}.sed \
	      > ${CLADES}/${CLADE_NAME}.txt

    rm -f ${CLADES}/raw.${CLADE_NAME}.txt
    rm -f ${CLADES}/raw.${CLADE_NAME}.sed

}

if [ "$CLADE1_NAME" ] ; then
    run_clades $CLADE1_NAME $CLADE1_CUTOFF
fi
if [ "$CLADE2_NAME" ] ; then
    run_clades $CLADE2_NAME $CLADE2_CUTOFF
fi
if [ "$CLADE3_NAME" ] ; then
    run_clades $CLADE3_NAME $CLADE3_CUTOFF
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

