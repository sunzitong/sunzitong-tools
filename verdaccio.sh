# 清楚npm缓存，否则可能会导致pm2安装失败。
# 加上--unsafe-perm选项是为了防止gyp ERR! permission denied权限问题报错
# 对于 verdaccio@4.0.0-alpha.x 或 verdaccio@4.x版本， Node 8.x (LTS "Carbon") 是最低支持版本
# 配置文件是verdaccio启动之后才生成的，并且执行pm2 start verdaccio后直接读取配置文件读取不到，所以我延时了1s执行。
# 由于默认情况下只可以本机访问，所以要在配置文件的最后面添加 listen: 0.0.0.0:4873，用来之前外网访问。
# 如果已经配置了 listen: 0.0.0.0:4873， 则不会再次添加。
# 修改配置文件后重启 verdaccio 服务
npm cache clean -f
echo '全局安装verdaccio...'
npm install -g verdaccio --unsafe-perm
echo 'verdaccio全局安装成功'
echo '全局安装pm2...'
npm install -g pm2 --unsafe-perm
echo 'pm2全局安装成功'
echo '启动verdaccio...'
pm2 start verdaccio
echo '延迟读取verdaccio配置文件'
sleep 3
echo '开始读取verdaccio配置文件'
if [ `grep -c "0.0.0.0" ~/.config/verdaccio/config.yaml` -lt 1 ]
then
 echo '添加在配置文件中，添加 listen: 0.0.0.0:4873'
 echo listen: 0.0.0.0:4873 >> ~/.config/verdaccio/config.yaml
fi
echo '重启verdaccio服务'
pm2 restart verdaccio
