# zabbix

Esse script deverá ser executado no Ubuntu ou Debian.

Instalar wget
apt-get install wget

Em seguinda efetuar o download com o comando abaixo
wget https://raw.githubusercontent.com/faelvinicius/zabbix/master/install.sh

Após efetuar download, executar o seguinte comando deverá dar permissão de execução ao arquivo install.sh com o seguinte comando:
chmod +x install.sh

Em seguinda executar o script
./install.sh

Durante a instalação será solicitado que você digite o ip do host em que está sendo executado o script.
Para verificar o IP basta digitar o seguinte comando ifconfig -a