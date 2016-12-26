# react-native-cjzf-toast
实现IOS和Android对应弹出土司的兼容模块
# Android&IOS 使用
 (1) 安装插件，使用命令：
 
 
             ```npm install --save react-native-cjzf-toast```
              
              
 (2) 导入和链接项目，通过命令：
 
 
              react-native link react-native-cjzf-toast
##   代码解释
                ...
                var ToastPlugin = require('react-native-cjzf-toast');
                ...
                ToastPlugin.show({message:'测试',location:'top',duration:2});
                ...
               
      参数介绍：
      
      
          message:需要展示的信息；
          
          
          location:弹出框出现的位置“center”,"top","bottom",或者不填即默认从底下（bottom）出现
          
          
          duration:显示时长，默认2秒可以不填，android中大于2秒的按照android中的长时间（Toast.LENGTH_LONG）显示，小于2就按照短时间（Toast.LENGTH_SHORT）显示；
          
          
