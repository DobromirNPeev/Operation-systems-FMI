cat ssa-input.txt | grep -E --color 'Array|physicaldrive|Current Temperature \(C\)|Maximum Temperature \(C\)' | tail -n +2 | sed -E 's/Array|physicaldrive|Current Temperature \(C\): |Maximum Temperature \(C\): //' | sed 's/ *//' | awk '/^[A-Z]$/ {array=$1;disk="";curr="";max=""} /.*:.*:.*/ {disk=$1;curr="";max=""} /^[0-9]+$/ {max=$1} /^[0-9]+$/ {if (curr=="") {curr=$1;max=""}} {if (array!= "" && disk!="" && curr!="" && max!=""){print array,disk,curr,max}}'
