## PassCapsule
---------------------------
PassCapsule 是一个类似 1Password 和 KeePass 的密码管理软件，由我个人独立开发，除了加密的安全性，主要特点是能支持多用户使用，共享一个密码库（尚未实现）。数据加密部分采用 AES 256 算法，再用 base64 编码后存储到作为密码库的 XML 文件。


###安装
```shell
pod install
```

###结构
//TODO:结构图，model层说明等。