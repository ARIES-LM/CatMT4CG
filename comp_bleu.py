import sacrebleu
import sys
import re

src_hyp_ref_path = sys.argv[1]
hyp_lines = [l.strip() for l in open(sys.argv[1]).readlines()]
ref_lines = [l.strip() for l in open(sys.argv[2]).readlines()]

def _chartok(line):
    new_line = re.sub(r'(?<=[\u4e00-\u9fff]{1})([\u4e00-\u9fff])', r' \1', line)
    # new_line = re.sub(r'(?<=[^ ])(\<\<unk\>\>)', r' \1', new_line)
    return new_line

hyps = []
refs = []
for hyp, ref in zip(hyp_lines, ref_lines):
    ref = ref.replace("@@ ", "") # strip if necessary
    hyps.append(_chartok(hyp))
    refs.append(_chartok(ref))
    # print(hyps)
    # print(refs)
    # exit()
    # chartok 
# print(len(hyps))
# print(len(refs))
# print(hyps[:5])
# print(refs[:5])
bleu = sacrebleu.corpus_bleu(hyps, [refs])
print(bleu.score)

