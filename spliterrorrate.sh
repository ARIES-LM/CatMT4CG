#!/bin/bash
export PYTHONPATH=.
datapath=/nfs/Desktop/cognition/cg-test

evalpath=/nfs/Desktop/cognition/eval

mergefile=${1}

sed -n '1,3600p' $mergefile > $mergefile.NP
sed -n '3601,7200p' $mergefile > $mergefile.VP
sed -n '7201,10800p' $mergefile > $mergefile.PP

python $evalpath/eval.py $mergefile.NP $evalpath/lexicon >$mergefile.npacc
python $evalpath/eval.py $mergefile.VP $evalpath/lexicon >$mergefile.vpacc
python $evalpath/eval.py $mergefile.PP $evalpath/lexicon >$mergefile.ppacc

