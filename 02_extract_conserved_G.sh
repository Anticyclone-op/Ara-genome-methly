#!/bin/bash
while read line
do
	mkdir ${line} && cd ${line}
	python ../split_per_contig.py ../${line}.bed
	ls *.bed >sample1.txt
	perl -pi -e 's/\.bed//g' sample1.txt
	
	THREAD_NUM=16
	mkfifo tmp
	exec 6<>tmp
	for((i=0;i<$THREAD_NUM;i++))
	do
		echo
	done >&6
	while read line1
	do
		read -u 6
		{
			perl ../extract_conserved_G_from_bed.pl ${line1}.bed > ${line1}_conserved_G.txt
			echo >&6
		}&
	done <sample1.txt
	wait
	exec 6>&-
	rm tmp
	
	cat *_conserved_G.txt > ../${line}_conserved_G.txt
	cd .. && rm -r ${line}
done <sample.txt
