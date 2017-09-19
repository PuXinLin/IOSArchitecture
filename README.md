# IOSArchitecture
IOSArchitecture 是一个能提高开发效率和用户体验的框架。框架是由多个小模块组成，这里主要讲解的iOS开发过程中的网络层封装。<br/>

<br/>


## 使用Podfile文件导入

    
     platform :ios, '8.0' 
     #use_frameworks!个别需要用到它，比如reactiveCocoa
     target 'ProjectName' do
        pod 'PXLNetWork', '~> 1.0.9',:inhibit_warnings => false #忽略xcode8 注释里面的警告
     end
    
<br/>

<!--## 默认依赖第三方库：-->
<!---->
<!--    pod 'MBProgressHUD', '~> 0.9.2'-->
<!--    pod 'AFNetworking', '~> 3.1.0'-->
<!--    pod 'MJRefresh', '~> 3.1.0'-->
<!--    pod 'SDWebImage', '~> 3.7.5'-->
<!--    pod 'Masonry', '~> 1.0.1'-->
<!--    pod 'YYModel', '~> 1.0.4'-->
<!--    pod 'YYCache', '~> 1.0.4'-->
<!---->
<!--<br/>-->

## 模块说明
    * bar            : 对UITabBarController和UINavigationController的封装。可根据Resources文件夹下的TabBarInfo.plist实现需求。
    * Cache          : 数据持久化缓存封装 简单实现）
    * Category       : 开发过程中的分类工具 (简单实现)
    * DataEncryption : 数据加密封装 每个公司都有自己的数据加密方式（并未实现）
    * Macro          : 一些常用的常量和方法（简单实现）
    * ShowBox        : 基于MBProgressHUD的提示框 （简单实现）
    * NetWork        : 基于AFNetworking 对整个网络层封装（这里主要讲的就是网络层 上面只是网络层附带的一些小模块）


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










