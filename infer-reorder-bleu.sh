#export PYTHONPATH='/home/amax/Codes/ARXIV/fairseq-cg'

datapath=/nfs/Desktop/cognition/cg-test
modelname=${1}
ckppre=${2}

evalfile=$ckppre.cgtest.src-hyp-tgt


python _reorder.py $datapath/test.en $ckppre.cgtest.out $datapath/test.zh > $evalfile

cut -f2 $evalfile > $ckppre.cgtest.hyp
cut -f3 $evalfile > $ckppre.cgtest.ref

sacrebleu $ckppre.cgtest.ref -i $ckppre.cgtest.hyp -tok zh > $ckppre.bleu

#CUDA_VISIBLE_DEVICES=1 python /home/amax/Codes/ARXIV/fairseq-cg/fairseq_cli/generate.py $data \
#    --gen-subset $subset \
#    -s 'en' \
#    -t 'zh' \
#    --path $model/checkpoint_best.pt \
#    --dataset-impl 'raw' \
#    --batch-size 512 --beam 5 --remove-bpe  > $data/$subset.en-zh.en.out

#     --gen-subset valid \



#evalpath=/nfs/Desktop/cognition/eval
#paste ${datapath}/test.en ${datapath}/test.compound checkpoints/$modelname/cgtest.hyp >checkpoints/$modelname/merge.txt

#python $evalpath/eval.py checkpoints/$modelname/merge.txt $evalpath/lexicon >checkpoints/$modelname/cgacc.log
