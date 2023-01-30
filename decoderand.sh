#!/bin/bash
RUN=./
export PYTHONPATH=$RUN
export PYTHONIOENCODING=utf8

datapath=cogmt/data/bin

MODEL=$RUN/checkpoints

modelname=${1}

ckp=$MODEL/$modelname/checkpoint_best.pt

GEN=${ckp}.rand.out

CUDA_VISIBLE_DEVICES=${2} python -u $RUN/fairseq_cli/generate.py $datapath/ \
    --path $ckp \
    --batch-size 128 --beam 5 --remove-bpe >$GEN

SYS=$GEN.sys
REF=$GEN.ref

grep ^H $GEN | cut -f3-  > $SYS
grep ^T $GEN | cut -f2-  > $REF

sacrebleu $REF -i $SYS -tok zh > $ckp.rand.bleu

