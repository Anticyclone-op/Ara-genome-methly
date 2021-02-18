#usage:perl x.pl As.maf
open (OUT,">As-738_conserve_region.txt") or die "$!";
open (OUT1,">As-738_C.txt") or die "$!";
open (F1,$ARGV[0]) or die "$!";

$/="\n\n";$n=0;
while(my $line=<F1>){
	chomp $line;
	@arr=split/\n/,$line;@as=split/\s+/,$arr[0];@t738=split/\s+/,$arr[1];
	$n+=1;
	if($as[4] eq "+"){
		$qs=$as[2]+1;
		$qe=$qs+$as[3]-1;
	}else{
		$qs=$as[5]-$as[2];
		$qe=$qs-$as[3]+1;
	}
	if($t738[4] eq "+"){
		$rs=$t738[2]+1;
		$re=$rs+$t738[3]-1;
	}else{
		$rs=$t738[5]-$t738[2];
		$re=$rs-$t738[3]+1;
	}
	print OUT "region",$n,"\t","As\t",$as[1],"\t",$qs,"\t",$qe,"\t738\t",$t738[1],"\t",$rs,"\t",$re,"\n";
	$j=0;$x=0;$y=0;
	while($j<length($as[6])){
		$q=uc(substr($as[6],$j,1));$r=uc(substr($t738[6],$j,1));
		if($q=~/G|C/ && $r=~/G|C/ && $q eq $r){
			print OUT1 "region",$n,"\t","As\t",$as[1],"\t738\t",$t738[1];
			if($as[4] eq "+"){
				print OUT1 "\t",$qs+$x;
			}else{
				print OUT1 "\t",$qs-$x;
			}
			if($t738[4] eq "+"){
				print OUT1 "\t",$rs+$y,"\n";
			}else{
				print OUT1 "\t",$rs-$y,"\n";
			}
		}else{
			if($q eq "-"){
				$x=$x-1;
			}
			if($r eq "-"){
				$y=$y-1;
			}
		}
		$j+=1;$x+=1;$y+=1;
	}
}
close F1;

