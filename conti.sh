#!/bin/bash

#pip install -e 
export PYTHONPATH=./

tgtctxdict=no

epc=${1}
N=${2}

seed=1
topk2disk=30

DATA=

modelname=${3}

MODEL="$RUN/checkpoints/${modelname}"

# ende
remain=$((200000-epc*4691))

# roen
#remain=200000

# enfi
#remain=$((150000-epc*2212))

# continue
dict=$MODEL/src.l6.k${N}.epc${epc}.pkl

CUDA_VISIBLE_DEVICES=0,1,2,3 python -u $RUN/fairseq_cli/train.py $DATA \
        --ctxfeatdp 1 \
        --ctxdict ${dict} --tgtctxdict $tgtctxdict --n-cluster $N \
        --ctxgate 0 --dynamic-ctxdict 0 --clus-evepc 0 \
        --clusiter 300 --clustol 0.0001 --topk2disk $topk2disk --clusseed $seed \
        --seed $seed \
        --max-update $remain \
        --save-interval-updates 1000 --keep-interval-updates 1 \
        --arch transformer_wmt_en_de --share-all-embeddings \
        --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
        --lr-scheduler inverse_sqrt --warmup-init-lr 1e-07 --warmup-updates 4000 \
        --lr 0.0007 \
        --criterion label_smoothed_cross_entropy --label-smoothing 0.1 --weight-decay 0.0 \
        --max-tokens 8192 --save-dir $MODEL \
        --update-freq 1 --no-progress-bar --log-interval 500 \
        --keep-best-checkpoints 1 --no-epoch-checkpoints \
        --ddp-backend=legacy_ddp --reset-optimizer >>${MODEL}/contitrain.log 2>&1

test_model=checkpoint_best.pt
CUDA_VISIBLE_DEVICES=0 python $RUN/fairseq_cli/generate.py $DATA \
        --ctxdict $dict \
        --tgtctxdict $tgtctxdict \
        --path $MODEL/$test_model \
        --fp16 --max-len-a 1 --max-len-b 50 \
        --batch-size 128 --beam 4 --remove-bpe --lenpen 0.6 >${MODEL}/test-$test_model.log 2>&1

