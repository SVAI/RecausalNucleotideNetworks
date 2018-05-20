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


true_positives = 0
false_positives = 0
false_negatives = 0

target_variant_type = sys.argv[1]

for line in open(sys.argv[2], 'r'):
    disputed_variants[line.strip()] = True

for line in open(sys.argv[3], 'r'):
    consensus_variants[line.strip()] = "Expected"


caller_name = sys.argv[4].split(".")[0].split("/")[-1]
coverage = sys.argv[4].split("/")[0]

for line in open(sys.argv[4], 'r'):
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
    
    if len(ref_allele) != 1 or len(alt_allele) != 1:
        variant_type = "Indel"
    else:
        variant_type = "SNP"

    if variant_type != target_variant_type:
        continue
        
    # Ignore no-call and ref_call
    if genotype == "./." or genotype == "0/0":
        continue

    if caller_name == "clairvoyante":
        if int(tab_split[5]) < 100:
            continue

    # TODO: This is a caller-specific hack for this investigation
    # Ignore variants that do not have PASS
    print caller_name
    if caller_name == "dragen" or caller_name == "strelka2":
        if tab_split[6] != "PASS":
            continue

    if consensus_variants.get("_".join([chromosome, position, ref_allele, alt_allele, genotype])) == "Expected":
        consensus_variants["_".join([chromosome, position, ref_allele, alt_allele, genotype])] = "Observed"

    if consensus_variants.get("_".join([chromosome, position, ref_allele, alt_allele, genotype])) == None and not disputed_variants.get("_".join([chromosome, position])):
        false_positives += 1

for k, v in consensus_variants.iteritems():
    if v == "Expected":
        false_negatives += 1
    elif v == "Observed":
        true_positives += 1

print "%s,%s,%d,%d,%d" % (coverage,caller_name, false_positives, false_negatives, true_positives)



            
