import sys
from sets import Set

valid_chromosomes = []
for i in range(1, 23):
    valid_chromosomes.append(str(i))
valid_chromosomes.append("X")
valid_chromosomes.append("Y")

consensus_variants = {}
disputed_variants = {}
all_variants = {}

all_callers = []

target_variant_type = sys.argv[1]

for input_file in sys.argv[2:]:
    caller_name = input_file.split(".")[0]
    all_callers.append(caller_name)
    for line in open(input_file, 'r'):
        if line[0] == "#":
            continue
        
        tab_split = line.split("\t")
        ref_allele = tab_split[3]
        alt_allele = tab_split[4]
        genotype = tab_split[9].split(":")[0]
        chromosome = tab_split[0]
        position = tab_split[1]

        if chromosome not in valid_chromosomes:
            continue

        # Currently, only consider mono-allelic positions
        if "," in alt_allele:
            continue
            
        if len(ref_allele) != 1 and len(alt_allele) != 1:
            variant_type = "Indel"
        else:
            variant_type = "SNP"
            
        # Ignore no-call and ref_call
        if genotype == "./." or genotype == "0/0":
            continue

        # TODO: This is a caller-specific hack for this investigation
        # Ignore variants that do not have PASS
        if caller_name == "dragen" or caller_name == "strelka":
            if tab_split[6] != "PASS":
                continue

        if all_variants.get(chromosome + "_" + position) == None:
            all_variants[chromosome + "_" + position] = {}
        all_variants[chromosome + "_" + position][caller_name] = "_".join([ref_allele, alt_allele, genotype])

for k, v in all_variants.iteritems():
    if len(v) == len(all_callers):
        for x in all_callers:
            if v[x] != v[all_callers[0]]:
                disputed_variants[k] = True
                break
        consensus_variants[k] = True
    else:
        disputed_variants[k] = True
    

consensus_file = open("consensus.vcf", 'w')
disputed_file = open("disputed.vcf", 'w')

for k, v in consensus_variants.iteritems():
    consensus_file.write(v + "\n")

for k, v in disputed_variants.iteritems():
    disputed_file.write(k + "\n")
    
print "consensus variants: %d || disputed variants %d" % (len(consensus_variants), len(disputed_variants))



            
                



            
