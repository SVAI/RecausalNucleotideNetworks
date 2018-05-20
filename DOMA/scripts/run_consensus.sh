set -x

# This is just an example script showing usage for assessing caller performance

python assess_caller.py SNP disputed.SNP.txt consensus.SNP.txt 45x/strelka2.45x.vcf >> strelka.snp.csv
python assess_caller.py SNP disputed.SNP.txt consensus.SNP.txt 40x/strelka2.40x.vcf >> strelka.snp.csv
python assess_caller.py SNP disputed.SNP.txt consensus.SNP.txt 35x/strelka2.35x.vcf >> strelka.snp.csv
python assess_caller.py SNP disputed.SNP.txt consensus.SNP.txt 30x/strelka2.30x.vcf >> strelka.snp.csv
python assess_caller.py SNP disputed.SNP.txt consensus.SNP.txt 25x/strelka2.25x.vcf >> strelka.snp.csv

python assess_caller.py Indel disputed.Indel.txt consensus.Indel.txt 45x/strelka.45x.vcf >> strelka.indel.csv
python assess_caller.py Indel disputed.Indel.txt consensus.Indel.txt 40x/strelka2.40x.vcf >> strelka.indel.csv
python assess_caller.py Indel disputed.Indel.txt consensus.Indel.txt 35x/strelka2.35x.vcf >> strelka.indel.csv
python assess_caller.py Indel disputed.Indel.txt consensus.Indel.txt 30x/strelka2.30x.vcf >> strelka.indel.csv
python assess_caller.py Indel disputed.Indel.txt consensus.Indel.txt 25x/strelka2.25x.vcf >> strelka.indel.csv