#!/bin/bash

flv_web_addr=$1
flv_dir=$HOME/videos    
flvcd_page_file=$HOME/tmp/flv_page_file

wget -q -O $flvcd_page_file "http://www.flvcd.com/parse.php?kw=$flv_web_addr"
flvurls=( $(iconv -f gbk -t utf-8 $flvcd_page_file | sed -n '/下载地址/,/tr/p' | sed -n 's/.*href="\(.*\)" target.*/\1/p') )

#flvtitles=( $(cat $flvcd_page_file | grep "<N>"  | sed -n "s/\s\{1,\}/_/g;s/<N>//gp") )  
flvtitles=$( iconv -f gbk -t utf-8 $flvcd_page_file | grep document.title | sed -n 's/.*"\(.*\)".*+.*/\1/p')

echo $flvtitles


nr_urls=${#flvurls[@]}

if [ $nr_urls -eq 0 ]
then
    echo "No videos found in this page :("
    exit 1
fi

for ((i=0; i<$nr_urls; i++))
do
#    title=${flvtitles[$i]}
    title=$flvtitles
    url=${flvurls[$i]}
    echo "title: $title"
    echo "  url: $url"
    wget -U NoSuchBrowser/1.0 -O "$flv_dir/$title$i.flv" $url
done

cd $flv_dir
finaltitle=$(echo ${flvtitles[0]} | sed s/-.*//g)
#mencoder -oac pcm -ovc copy -idx -o $finaltitle.flv $finaltitle*
#mencoder -oac copy -ovc copy -of lavf -lavfopts format=flv -o $finaltitle.flv $finaltitle*

