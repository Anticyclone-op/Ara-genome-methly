#usage:perl script.pl 733_1.bed
%hash=();
open(F1,$ARGV[0]) or die "$!";
while(my $line=<F1>){
	chomp $line;
	@arr=split/\t/,$line;
	if($arr[7]=~/G/ || $arr[7]=~/C/){
		if($arr[6] eq '150M'){
			$seq=$arr[7];
		}else{
			$cigar=$arr[6];@len=split/M|D|I/,$cigar;$cigar=~s/\d//g;
			$j=0;
			while($j<=length($cigar)-1){
				push(@info,substr($cigar,$j,1));
				$j+=1;
			}
			$seq="";   #构建一个新的完整序列，新增加的序列使用X代替
			$index=0;
			$j=0;#标记read中的碱基位置，从0开始
			while($index<=$#info){
				if($info[$index] eq "M"){
					$seq.=substr($arr[7],$j,$len[$index]);
					$j+=$len[$index];
				}
				if($info[$index] eq "I"){
					$j+=$len[$index];
				}
				if($info[$index] eq "D"){
					$m=1;
					while($m<=$len[$index]){
						$seq.="X";
						$m+=1;
					}
				}
				$index+=1;
			}
		}
		if($seq=~/G/ || $seq=~/C/){
			$j=0;
			while($j<=length($seq)-1){
				$pos=$arr[1]+$j+1;
				if((substr($seq,$j,1) eq "G") || (substr($seq,$j,1) eq "C")){
					$hash{$arr[0].'#'.$pos}+=1
				}
				$j+=1;
			}
		}
	}
}
close F1;

foreach $key(sort keys %hash){
	print $key,"\t",$hash{$key},"\n";
}

