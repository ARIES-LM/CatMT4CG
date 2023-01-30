#!/bin/bash
export PYTHONPATH=./

datapath=cognition/bin

epc=8
k=3

modelname=xxx

mkdir -p checkpoints/$modelname
gpu=0

ctxdict=no
tgtctxdict=no

CUDA_VISIBLE_DEVICES=$gpu python -u fairseq_cli/train.py \
  $datapath \
  --seed 1 \
  --ctxfusion residual --ctxfeatdp 1 \
  --ctxdict $ctxdict --tgtctxdict $tgtctxdict --n-cluster $k \
  --dynamic-ctxdict $epc --clus-evepc 0 --topk2disk 0 \
  --save-dir checkpoints/$modelname \
  --patience 10 \
  --arch transformer_iwslt_de_en --share-decoder-input-output-embed \
  --optimizer adam --adam-betas '(0.9, 0.98)' --clip-norm 0.0 \
  --lr 5e-4 --lr-scheduler inverse_sqrt --warmup-updates 4000 \
  --dropout 0.3 --weight-decay 0.0001 \
  --criterion label_smoothed_cross_entropy --label-smoothing 0.1 \
  --max-tokens 4096 --max-update 50000 --no-epoch-checkpoints \
  >checkpoints/$modelname/train.log 2>&1

ctxdict=checkpoints/$modelname/src.l6.k${k}.epc${epc}.pkl
#bash decodecgmore.sh $modelname $gpu ${ctxdict} $tgtctxdict


