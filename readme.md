基于walle-php 的fork，主要是对其版本的升级

原始项目地址
https://github.com/meolu/walle-web-v1.x

git clone git@github.com:meolu/walle-web.git
cd walle-web
vi config/local.php # 设置mysql连接
./yii walle/setup # 初始化项目
配置nginx