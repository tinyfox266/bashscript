# !/bin/bash

searchtmp="searchtmp.html"

bibtmp="bibtmp.html"

papertitle=$1

#fakebrowser="Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.3)
#Gecko/20100401 Firefox/3.6.3 (.NET CLR 3.5.30729)"
fakebrowser="Mozilla/5.0"

acmsearch="http://dl.acm.org/results.cfm?"

acmbibtex="http://dl.acm.org/exportformats.cfm?"

curl -s -o $searchtmp -A $fakebrowser -X post --data-urlencode "query=$papertitle" $acmsearch   


paperids=( $( grep -i "$papertitle" $searchtmp |\
grep citation | \
sed 's/^.*[1-9]*\.\([1-9]*\).*/\1/g') )

nu_papers=${#paperids[@]}

if [ $nu_papers -eq 0 ]
then 
    echo "No paper found :( in acm libary"
    exit 1
fi

paperid=${paperids[0]}


wget  -q -U $fakebrowser -O $bibtmp ${acmbibtex}"id=$paperid""&expformat=bibtex"

bibtex=( $(sed -n '/<PRE/,/<\/pre>/p' $bibtmp  | grep -v PRE | grep -v pre )) 

sed -n '/<PRE/,/<\/pre>/p' $bibtmp  | grep -v PRE | grep -v pre 

rm $searchtmp $bibtmp
