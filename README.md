# IOSArchitecture
IOSArchitecture 是一个能提高开发效率和用户体验的框架。<br/>
目前还只是对网络层进行封装

<br/>

## 网络层封装-开发使用
    * 请求方式离散化
    * 回调方式集约化

<br/>

## 网络层封装-业务逻辑
    * 网络请求数据缓存检验
    * 网络请求是否值得发起检验
    * 网络请求数据加密
    * 网络请求多通道
    * 网络请求响应数据检验
    * 网络请求失败重发
    * 网络环境切换恢复失败的网络请求
    * 页面返回取消当前页面发起的网络请求

<br/>

## 使用Podfile文件导入
<!--    *-->
<!--    * platform :ios, '8.0'-->
<!--    * #use_frameworks!个别需要用到它，比如reactiveCocoa-->
<!--    * target 'ProjectName' do-->
<!--    * pod 'PXLNetWork', '~> 1.0.9',:inhibit_warnings => false #忽略xcode8 注释里面的警告-->
<!--    * end-->

    ```java  

     platform :ios, '8.0' 
     #use_frameworks!个别需要用到它，比如reactiveCocoa
     target 'ProjectName' do
        pod 'PXLNetWork', '~> 1.0.9',:inhibit_warnings => false #忽略xcode8 注释里面的警告
     end


```

