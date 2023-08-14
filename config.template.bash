# directory into which the results are written.
#DATA=.
#DATA=data # default

# ------------------------------------------------------------------------

COLLECTION=../collection/data

# ------------------------------------------------------------------------

BOOTSTRAP_REPS=100

# ------------------------------------------------------------------------

# # a tab-delimed file for replicon name substitutions (*cough* Prokka *cough*)
# # - column 1: replicon name as it appears in input genomes
# # - column 2: replicon name as it should appear in the output
# REPLICON_NAMES=local/names.txt

CLADE1_NAME=species
CLADE1_CUTOFF=95.0
# CLADE2_NAME=genera
# CLADE2_CUTOFF=70.0

# ------------------------------------------------------------------------

# Uncomment to get packages from HOWTO
PACKAGES_FROM=howto

# # Uncomment to use conda
# PACKAGES_FROM=conda
# CONDA_ENV=pipeline-mashtree

#THREADS=$(nproc --all)

# ------------------------------------------------------------------------
