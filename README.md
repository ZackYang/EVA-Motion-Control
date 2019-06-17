# EVA-Motion-Control
EVA-Motion-Control
先下这个
https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.5.5-1/rubyinstaller-devkit-2.5.5-1-x64.exe
然后开始安装 安装的时候把所有内部的工具都装上

装完之后 去console里面 输入: ruby -v
理论上 应该可以看到版本号

然后安装bundler
命令行中输入 gem install bundler

在安装TCP库 命令后面的位置你看你的ruby装在哪的 稍微改一下
gem install eventmachine --platform ruby -- --use-system-libraries --with-ssl-dir=D:/Ruby25-x64/msys64/mingw64

console进入程序根目录 输入bundle install 这个会自动解决库依赖

这个执行测试程序
bundle exec ruby tests/base_test.rb
