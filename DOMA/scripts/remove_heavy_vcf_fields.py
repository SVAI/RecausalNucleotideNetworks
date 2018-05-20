import sys

for line in open(sys.argv[1], 'r'):
    if line[0] == "#":
        sys.stdout.write(line)
    else:
        tab_split = line.split("\t")
        tab_split[7] = "."
        tab_split[8] = "GT"
        tab_split[9] = tab_split[9].split(":")[0]
        print "\t".join(tab_split)
