# Instalação Zabbix + busca de CEP correios no Ubuntu.

Instalar wget
sudo apt-get install wget

Em seguinda efetuar o download com o comando abaixo
sudo wget https://raw.githubusercontent.com/faelvinicius/zabbix/master/install.sh

Após efetuar download, executar o seguinte comando deverá dar permissão de execução ao arquivo install.sh com o seguinte comando:

sudo chmod +x install.sh

Em seguinda executar o script

sudo ./install.sh

Durante a instalação será solicitado que você digite o ip do host em que está sendo executado o script.

Para verificar o IP basta digitar o seguinte comando ifconfig -a

Após instalado, basta acessar o zabbix pelo browser digitando endereço IP que foi informado na instalação.
http://ip_informado

Login: Admin 
Senha: zabbix


Para acessar o serviço dos correios basta acessar o endereço informado durante a instalação acompanhado da porta 7676.
http://seu_ip:7676
