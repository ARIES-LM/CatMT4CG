
import sys

hyp=sys.argv[1]
ref=sys.argv[2]
acc = 0
tot = 0

with open(hyp, encoding='utf-8') as fhyp, open(ref, encoding='utf-8') as fref:
    for lh, lr in zip(fhyp, fref):
        if lh == lr:
            acc += 1

print(acc/tot)

