#!/bin/bash
# author: xudongshun001
# 脚本用于sh review.sh之前检查大图片，如果新增单张图片超过20k，则commit失败

# 限定大小KB
image_max_size=20
# 不达标的图片数量
fail_image_count=0
# 获取提交的文件
echo "`git diff --name-only HEAD~ HEAD`">all_commit_text.txt
# 遍历
while read file_name
do

    if echo ${file_name} | egrep -q '\.gif|\.jpeg|\.png|\.jpg|\.bmp';
    then
        # 图片大小
        file_size=`stat -f %z $file_name`
        # 把图片大小转换成kb
        image_size=`expr $file_size / 1024`
        # 比较
        if [ $image_size -gt $image_max_size ]
        then
            echo "\033[31m${file_name}\n：拒绝提交，图片(${image_size}KB)超过${image_max_size}KB，请尝试压缩后再提交\033[0m"
            # 不达标图片数量+1
            fail_image_count=`expr $fail_image_count + 1`
        fi
    fi
done< all_commit_text.txt
cp all_commit_text.txt all_commit_text_bkup.txt
rm all_commit_text.txt

if [ $fail_image_count -gt 0 ]
then
    echo "\033[31m❎${fail_image_count}张图片超过限定大小, 请压缩至${image_max_size}KB以下再提交\033[0m"
    # 中止提交
    exit 1
else
    exit 0
fi
