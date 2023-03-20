基于walle-php 的fork，主要是对其版本的升级

原始项目地址
https://github.com/meolu/walle-web-v1.x

```
git clone git@github.com:awanganddong/walle-web-php.git
cd walle-web  
vim config/local.php # 设置mysql连接
./yii walle/setup # 初始化项目
配置nginx

账号:admin
密码:admin

请保证nignx的用户和php-fpm的用户，以及执行命令的用户是同一个。
不然容易出现权限不一致的问题。
nginx.conf
php-fpm.d=>www.conf

创建远程目录的时候，需要保证目录的用户属组是在执行脚本的用户下。
```