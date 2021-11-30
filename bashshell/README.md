> 参考：
>
> ​	Github 上的运维脚本工具收集项目 <https://github.com/aqzt/kjyw>
>
> ​	Linux Bash Shell Script and Python Script For Ops and Devops <https://github.com/DingGuodong/LinuxBashShellScriptForOps>





## 脚本编写规范

### 脚本范例

```SHELL
#!/usr/bin/env bash
#########################################################
# 功能  ：传递两个数字并依次打印按顺序打印它们以及之间的数字
# 系统  ：Linux
# 版本  ：1.0
# 作者  ：Jason Lau
# 用法  ：bash print_nums.sh num1 num2
# 备注  ：
#########################################################
```



### 编写规范

- 起始行（"蛇棒"）

  - 统一使用：

    ```SHELL
    #!/usr/bin/env bash
    ```

- 代码注释
  - 脚本相关信息说明：包括改脚本的功能、运行环境、版本号、编写人、用法等等。
  - 函数、变量、复杂命令说明。

- 命名规则
  - 尽量做到见名知意
  - 自定义变量采用小驼峰写法
  - 变量引用统一使用``${valve}`写法
  - 自定义函数或自定义命令采用全部大写字母

- 代码保持简洁可读
  - 缩进：统一采用4个空格来缩进。
  - 长命令：要写成多行。
  - 代码块：使用自定义函数进行封装。
  - 输出信息：善用`echo`对相关命令或功能执行结果进行输出说明。

