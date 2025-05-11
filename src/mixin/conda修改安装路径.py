import sys, os
from textwrap import dedent

# 使用方法
# 1. 右键终端以管理员模式运行
# 2. base环境下 ：python 此文件路径
# 3. 打开conda文件夹，修改envs和pkgs（这个如果没有就建立）的用户权限全给了

text = dedent(f"""
channels:
  - defaults
show_channel_urls: true
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch-lts: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
envs_dirs:
  - {sys.prefix}/envs
pkgs_dirs:
  - {sys.prefix}/pkgs
""")

with open(f'{os.path.expanduser("~")}/.condarc2', 'w', encoding='u8') as f:
    f.write(text)

print('Successfully！')