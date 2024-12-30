#!/bin/bash

reg='{1}\s*LJRouterRegistAction{1}.+'
del_reg="\-$reg"
add_reg="\+$reg"

# 检查diff，有没有router变动，如果只有-router行而没有+router，则认为是有桥被删了
git diff HEAD~ HEAD |grep -E "$del_reg" > delete_temp.txt
git diff HEAD~ HEAD |grep -E "$add_reg" > add_temp.txt


# ---------- TOOLs -------------
# matched:1, not match:0
isStrInArr(){ 
    local del_str=$1
    local add_str="+${del_str:1}"
    local arr=$2
    
    # 遍历数组
    for element in "${arr[@]}"; do
        if [[ "$element" == "$add_str" ]]; then
            echo "match: $add_str"
        return 1
        fi
    done
    return 0
}
# ---------- TOOLs END -------------

# 遍历delete_temp,逐行check，如果有减无加，就报告警告
resArr=()
# resArr+=("2")

del_lines=()
add_lines=()

# 使用 while 循环和 read 命令读取文件
while IFS= read -r line; do
    del_lines+=("$line")
    # echo "line: $line"
done < delete_temp.txt

while IFS= read -r line; do
    add_lines+=("$line")
done < add_temp.txt

rm -rf delete_temp.txt
rm -rf add_temp.txt

# 遍历
search(){
    for line in "${del_lines[@]}"; do
        # echo "elm:\n$line"
        isStrInArr "$line" $add_lines
        local find=$?
        # echo "find: $find"
        
        if [ $find == 0 ]; then 
            resArr+=("$line")
        fi
    done
}
search

YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'

# 没删桥返回0，删掉了桥返回1
run_check(){
    if [ ${#resArr[@]} -gt 0 ]; then
        echo "${YELLOW}————————————————————————————————"
        echo "${YELLOW}哥们，你貌似删除或改动了下面这些路由：\n"
        echo "${YELLOW}$resArr"
        echo "${YELLOW}————————————————————————————————\n"
        exit 1
    fi
    exit 0
}

run_check