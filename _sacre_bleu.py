import sacrebleu
import sys
import re
import jieba

src_hyp_ref_path = sys.argv[1]
src_hyp_ref_lines = [l.strip() for l in open(src_hyp_ref_path).readlines()]

def _chartok(line):
    new_line = re.sub(r'(?<=[\u4e00-\u9fff]{1})([\u4e00-\u9fff])', r' \1', line)
    # new_line = re.sub(r'(?<=[^ ])(\<\<unk\>\>)', r' \1', new_line)
    return new_line

hyps = []
refs = []
for line in src_hyp_ref_lines:
    try:
        src, hyp, ref = line.split("\t")
    except:
        print(line)
    ref = ref.replace("@@ ", "") # strip if necessary
    #ref = " ".join(jieba.cut(ref))
    #hyps.append(_chartok(hyp))
    #hyps.append(_chartok(hyp))
    refs.append(_chartok(ref))
    refs.append(_chartok(ref))
    # chartok 
# print(len(hyps))
# print(len(refs))
# print(hyps[:5])
# print(refs[:5])
bleu = sacrebleu.corpus_bleu(hyps, [refs])
print(bleu.score)
