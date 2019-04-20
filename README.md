# Instalação Zabbix + busca de CEP correios

A instalação do ambiente e feita através do Vagrant + Virtualbox.

Após instalar o virtualbox e o vagrant, deverá ser criao um diretório com o nome do seu projeto.

Em seguida deverá baixar o arquivo vagrantfile e salvar o arquivo dentro do diretório que foi criado.

Pará que o ambiente seja configurando, basta digitar o seguinte comando no terminal ou powershell se estiver utilizando windows.
vagrant up

É só aguardar e o ambiente está configurado.


Após instalado, basta acessar o zabbix pelo browser digitando endereço IP que foi informado na instalação.
http://ip_informado

Login: Admin 
Senha: zabbix


Para acessar o serviço dos correios basta acessar o endereço informado durante a instalação acompanhado da porta 7676.
http://seu_ip:7676
