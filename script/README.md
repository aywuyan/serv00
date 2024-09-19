# serv00 保护脚本
此脚本需要提前准备一台非serv00的vps，通过ssh密钥登录serv00的方式来保活。  
要先把主vps的公钥复制到serv00中，复制后用下面命令来测试无密码登录。  
```bash
ssh user@vps-address
```
其中配置项可以按需填入，tg相关的配置项不填不影响脚本运行。





怎么serv00的Last Login中看不到登录信息？
