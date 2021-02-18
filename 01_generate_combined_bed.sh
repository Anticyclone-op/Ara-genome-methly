#!/bin/bash
THREAD_NUM=2
mkfifo tmp
exec 6<>tmp
for((i=0;i<$THREAD_NUM;i++))
do
	echo
done >&6
while read line
do
	read -u 6
	{
		samtools sort -@ 4 ${line}.bam > ${line}_sorted.bam
		samtools view -@ 4 ${line}_sorted.bam > ${line}_sorted.sam
		cut -f 10 ${line}_sorted.sam > ${line}_sorted.seq
		rm ${line}_sorted.sam
		bamToBed -cigar -i ${line}_sorted.bam > ${line}_sorted.bed
		paste ${line}_sorted.bed ${line}_sorted.seq > ${line}.bed
		rm ${line}_sorted.bed ${line}_sorted.seq
		echo >&6
	}&
done <sample.txt
wait
exec 6>&-
rm tmp
