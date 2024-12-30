#!/bin/bash

reg='{1}\s*LJRouterRegistAction{1}.+'
del_reg="\-$reg"
add_reg="\+$reg"

isStrInArr(){
    local del_str=$1
    local add_str="+${del_str:1}"
    local arr=$2
    local res=0
    
    # 遍历数组
    for element in "${arr[@]}"; do
        if [[ "$element" == "$add_str" ]]; then
        echo "match: $add_str"
        res=1
        fi
    done
    return $res
}


# 检查diff，有没有router变动，如果只有-router行而没有+router，则认为是有桥被删了
git diff HEAD~ HEAD |grep -E "$del_reg" > delete_temp.txt
git diff HEAD~ HEAD |grep -E "$add_reg" > add_temp.txt

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

# rm -rf delete_temp.txt
# rm -rf add_temp.txt

# 遍历
search(){
    for line in "${del_lines[@]}"; do
        # echo "elm: $line"
        isStrInArr $line $add_lines
        local find=$?

        if [ $find == 1 ]; then 
        resArr+=("$line")
        fi
    done
}
search

run_check(){
    local final_res=1
    if [ ${#resArr[@]} -gt 0 ]; then
        local final_res=0; #发现删桥了，返回0
        echo "————————————————————————————————"
        echo "哥们，你貌似删掉了一些路由，他们是：\n"
        echo $resArr
        echo "————————————————————————————————"

        echo "\n你确定要删掉上述这些述路由么? (y/n)"
    fi
    return $final_res
}
run_check