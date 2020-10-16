# Makefile-for-stcMCU
这是为在Linux环境下开发(宏晶)STC写的Makefile模板，关于如何使用，在Makefile文件中
有注释。
文件涉及编译器sdcc ,下载软件stcgal 关于sdcc,stcgal(来自github)请参考各自文件。
注意：如果从windos环境转到linux，sdcc自带了一个脚本帮助在keil环境格式头文件转为
sdcc环境格式头文件，这个脚本个人使用后发现它还不彻底，编译时报错，可以比对sdcc安装后
的目录中关于C51头文件内容可知错误原因，手动修改即可，简易提示区别在于_ 和 __字符区别。

