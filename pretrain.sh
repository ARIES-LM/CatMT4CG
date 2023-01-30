#!/bin/bash

#pip install -e 
export PYTHONPATH=./

dict=no
tgtctxdict=no

epc=${1}
N=${2}

RUN=.

DATA=""

# save epoch ckps for efficiency

modelname=${3}

MODEL="$RUN/checkpoints/${modelname}"

mkdir -p $MODEL
CUDA_VISIBLE_DEVICES=0,1,2,3 python3 -u $RUN/fairseq_cli/train.py $DATA \
        --ctxfeatdp 1 \
        --sharepara 0 \
        --ctxdict ${dict} --tgtctxdict $tgtctxdict --n-cluster $N \
        --dynamic-ctxdict 0 --clus-evepc 0 \
        --clusiter 300 --clustol 0.0001--topk2disk 30 \
        --seed 1 --max-epoch $epc \
        --disable-validation \
        --arch transformer_wmt_en_de --share-all-embeddings \
        --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
        --lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates 4000 \
        --lr 0.0007 \
        --criterion label_smoothed_cross_entropy --label-smoothing 0.1 --weight-decay 0.0 \
        --max-tokens 8192 \
        --save-dir $MODEL \
        --update-freq 1 --no-progress-bar --log-interval 100 \
        --keep-best-checkpoints 1 \
        --ddp-backend=legacy_ddp \
        --fp16 >>${MODEL}/ptrain.log 2>&1
