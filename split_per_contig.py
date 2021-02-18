#usage:python split_per_100.py 733_1.bed

import sys
with open(sys.argv[1],'r') as f:
    for line in f:
        line=line.strip()
        arr=line.split('\t')
        filename=arr[0].split('|')[0]+'.bed'
        w = open(filename,'a+')
        w.writelines(line+'\n')
        w.close()



