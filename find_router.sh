#!/bin/bash

reg='{1}\s*LJRouterRegistAction{1}.+'
echo "reg:${reg}"
del_reg="\-$reg"
add_reg="\+$reg"

# 获取提交的文件
git diff HEAD~ HEAD |grep -E "$del_reg" > delete_temp.txt
git diff HEAD~ HEAD |grep -E "$add_reg" > add_temp.txt

