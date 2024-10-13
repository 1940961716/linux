#!/bin/bash
source ./game.sh
  # 初始化二维数组的尺寸
rows=10
cols=10

# 创建一个二维数组并初始化为空格

declare -A map #用于场景绘制
# 设置起始位置
x=0
y=0
new_x=0
new_y=0
# 场景图层初始化
for ((i=0; i<rows; i++)); do
  for ((j=0; j<cols; j++)); do
    map[$i,$j]="🟨"
  done
done

map[$x,$y]="👦"  # 人物的初始位置

# 保存未被捡起的物品
save_item="🟨"

# 背包系统
declare -a backpack
max_capacity=4


load_game_data() {
  # 清空背包
  unset backpack
  

  # 读取数据文件
  while IFS='=' read -r key value; do
    case $key in
      rows)
        rows=$value
        ;;
      cols)
        cols=$value
        ;;
      x)
        x=$value
        ;;
      y)
        y=$value
        ;;
      new_x)
        new_x=$value
        ;;
      new_y)
        new_y=$value
        ;;
      save_item)
        save_item=$value
        ;;
      max_capacity)
        max_capacity=$value
        ;;
      backpack)
        IFS='(' read -ra backpack <<< "$value"
        ;;
      *)
        # 解析地图数据
        IFS=',' read -r i j <<< "$key"
        map[$i,$j]=$value
        ;;
    esac
  done < e:/linux/game_data.txt
  
}

welcome_screen() {
  echo "========= 欢迎来到冒险世界！=========="
  echo "请选择:"
  echo "1. 开始新游戏"
  echo "2. 从上次保存的记录开始"
  echo "3. 退出游戏"
  read -p "请输入选项(1/2/3): " choice
  case $choice in
    1)
      randomPut
      main 
      ;;
    2)
      #echo "这里是游戏的历史记录..."
      
      load_game_data
      main
      ;;
    3)
      echo "感谢游玩！再见！"
      exit 0
      ;;
    *)
      echo "无效的选择，请重新输入！"
      welcome_screen
      ;;
  esac
}
welcome_screen
# 函数：读取游戏数据文件
