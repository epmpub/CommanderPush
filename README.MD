# 背景介绍
我为什么创建这个项目呢?主要有以下几个原因:
1. 绝大部企业有追踪在线资产的需求;
2. 企业防病毒软件对系统的启动项目没有关注,存在漏洞;
3. 云计算的环境下,自建ELK平台,没有太大价值,存在成本问题;
4. 病毒或者恶意软件的入侵,必然通过启动项目,对整个系统进行精细管理非常有必要;
5. 其他的需求,成本低(包括网络带宽和阿里云SLS租用),部署灵活;

# 依赖项目
- 阿里云SLS , 用于数据存储与分析与展示,SLS类似ELK stack,为托管服务,由于成本原因,不建议使用ELK平台;
- 阿里云OSS或者其他WebServer,用于托管脚本文件;
- Sysinternal autorunsc ,用来收集系统启动项目;
- 证书签名(Optional),用来做脚本签名;
- 阿里云Logtail Agent for windows<https://help.aliyun.com/document_detail/49006.html>


# 功能模块
- CMDB
  - 收集硬件资产信息;
  - 收集软件信息;
- 信息安全管理
  - 启动项目
    - 服务
    - 注册表
# 安装

- clone或者下载代码,使用Visual Studio 2019 打开,visual studio 2019 中必须安装好.net framework Desktop Develop (桌面开发)模块;
- 编译产生主exe文件,本项目基于 .net framework 4.5,可以修改为更高版本,但是不能修改为.net core项目;
- 运行Deploy.bat程序
- 整个程序已服务的形式,在后台运行;
- 通过http下载脚本程序运行,将输出到日志中,日志集中位于c:\log下面;
- 实际项目可以修改收集的频率,默认为5分钟;
- 实际项目可以修改日志存储的位置


# 注意事项

- 由于网络发生变化或者请求过于频繁,会造成程序WebClient类异常,程序默认忽略了异常处理,以便保证程序不异常退出;
- 如果程序异常退出,可以检查windows 日志系统\应用程序,查看退出原因.

# 架构

- 项目采用 .net framework 4.5 ,主程序为Windows Service,保证可以运行在绝大数主流windows 10系统
- 没有采用.net core ,因为大部分模块无法兼容.net core 3.1,无法保证后期的功能扩展
- 测试使用了go lang,服务也可以正常运行,但是容易引起安全软件的过分关注,所以,为了提供更好的体验,没有采用go lang.
- 脚本使用了数字证书签名,确保不被安全软件拦截.
- 采用阿里云OSS做脚本的存储和分发.
- 依托阿里SLS日志服务,用于数据的存储与分析.
- 变化部分采用powershell脚本完成,可以做到分钟级别的同步.
- 功能的增加可以通过修改脚本快速部署完成.

# 截图

![软件列表](https://github.com/epmpub/MyService/blob/ed533bfcf58baf55e8e6a3d94c07f59413b332e4/images/myService1.png)
![autoruns](https://github.com/epmpub/MyService/blob/ed533bfcf58baf55e8e6a3d94c07f59413b332e4/images/myService2.png)
![CMDB](https://github.com/epmpub/MyService/blob/ed533bfcf58baf55e8e6a3d94c07f59413b332e4/images/myService3.png)

# 与我联系
如果对次项目感兴趣,可以随时联系我(+86 181 2220 8655 Wechat)
- 测试环境
- Face to Face meeting ,腾讯视频,功能介绍.需要提前预约;
- 具体的项目成本和TCO
