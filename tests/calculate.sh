#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

cd $1

find . -name decompositionprofile.csv -exec wc -l {} \;
find . -name Mutation_Probabilities.txt -exec wc -l {} \;
find . -name Sig_activities.txt -exec wc -l {} \;
find . -name Signatures.txt -exec wc -l {} \;
