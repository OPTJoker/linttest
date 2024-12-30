#bin/bash

git_prefix=".git"

install_commit_msg(){ 
    echo ""
}

if [ ! -d "$git_prefix" ]; then
	echo "! [Illegal git repository directory]"
	echo "  移动脚本到git仓库根目录"
	exit 1
fi


if [ ! -d ".git/hooks" ]; then
    mkdir ".git/hooks"
	echo "mkdir successfull"
fi

while getopts "m:c" arg
do
	case $arg in
		m)
		  echo "git commit -a -m ..."
          install_commit_msg
          git commit -a -m "$OPTARG"
          ;;
		c)
		  echo "git commit -a --amend -C HEAD"
          install_commit_msg
          git commit -a --amend -C HEAD;
          ;;
	esac
done



#检测图片大小是否超过上限
sh find_router.sh
if [[ "$?" == "1" ]]; then
    echo "你确定要删掉上述的桥方法么 (请输入：y/n)?"
    read del_router_choose
    lower_choose=$(echo "$del_router_choose" | tr 'A-Z' 'a-z')
    # echo "lower: $lower_choose"
    if [ "$lower_choose" == "y" ] || [ "$lower_choose" == "yes" ]; then
        echo ''
    else
        echo "你选择了: 否\n请恢复误删的桥后再重新提交"
        exit 1
    fi
fi

root_path=$(cd `dirname $0`; pwd)

if [ -f ".git/HEAD" ]; then
    head=$(< ".git/HEAD")
    if [[ $head = ref:\ refs/heads/* ]]; then
        git_branch="${head#*/*/}"
    else
        echo "无法获取当前分支"
	    exit 1
    fi

else
    echo "没有git中的HEAD文件"
	exit 1
fi

reviewers=("songhongri001" "zhangxianglong007")

echo "当前分支为:$git_branch"

pushUrl="HEAD:refs/for/$git_branch%"
git push origin $pushUrl
if [ $? -eq 0 ]; then
	exit 0
else
	exit 1
fi
