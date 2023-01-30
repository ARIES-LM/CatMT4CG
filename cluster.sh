#!/bin/bash

#pip install -e .
export PYTHONPATH=.

dict=no
tgtctxdict=no

epc=${1}
N=${2}

seed=1
topk2disk=10

RUN=.
DATA=""

modelname=${3}

MODEL="$RUN/checkpoints/${modelname}"
# cluster
CUDA_VISIBLE_DEVICES=0 python -u $RUN/fairseq_cli/cluster.py $DATA \
        --ctxfeatdp 1 \
        --sharepara 0 \
        --ctxdict ${dict} --tgtctxdict $tgtctxdict --n-cluster $N \
        --dynamic-ctxdict 0 --clus-evepc 0 \
        --clusiter 300 --clustol 0.0001 --topk2disk $topk2disk --clusseed $seed \
        --restore-file $MODEL/checkpoint_last.pt \
        --seed $seed \
        --arch transformer_wmt_en_de --share-all-embeddings \
        --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
        --lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates 4000 \
        --lr 0.0007 \
        --criterion label_smoothed_cross_entropy --label-smoothing 0.1 --weight-decay 0.0 \
        --max-tokens 25000 --save-dir $MODEL \
        --update-freq 1 --no-progress-bar --log-interval 50 \
        --keep-best-checkpoints 1 --no-epoch-checkpoints \
        --ddp-backend=legacy_ddp \
        --fp16 \
        --save-dir $MODEL >$MODEL/cluster.log 2>&1

rm $MODEL/token*.txt

