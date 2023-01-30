#!/bin/bash

epc=
k=

# fairseq_cli/train.py
# from fairseq_cli.fastkmeans import KMeans


modelname=wmtende_epc${epc}k${k}

bash $RUN/pretrain.sh $epc $k $modelname
bash $RUN/cluster.sh $epc $k $modelname
bash $RUN/conti.sh $epc $k $modelname


