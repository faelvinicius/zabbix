#!/bin/bash

#Autor: Rafael Vinicius

##################################### CRIANDO DIRETORIO PARA O MYSQL ########################

echo "Criando diretorio para instalacao do MYSQL..."
if ! mkdir -p /zbx-server/mysql/data
then
    echo "Não foi possível criar o diretorio."
    exit 1
fi    
	echo "Diretorio criado com sucesso!"

##################################### BAIXANDO CONTAINER MYSQL ###############################

if ! docker container run -d -p 3306:3306 -v /zbx-server/mysql/data:/var/lib/mysql -e MYSQL_HOST=127.0.0.1 -e MYSQL_USER=zabbix -e MYSQL_ROOT_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e MYSQL_PASSWORD=zabbix --name mysql-zbx mysql:5.7
then
	echo "Nao foi possivel instalar o MYSQL."
    exit 1
fi
	echo "MYSQL instalado com sucesso!"

##################################### BAIXANDO CONTAINER ZABBIX SERVER #########################

if ! docker container run -d -p 10051:10051 -e MYSQL_ROOT_PASSWORD=zabbix -e DB_SERVER_HOST=127.0.0.1 -e DB_SERVER_PORT=3306 -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix --name zbx-server zabbix/zabbix-server-mysql:ubuntu-4.0-latest
then
	echo "Nao foi possivel instalar Zabbix Server."
  exit 1	
fi
	echo "Zabbix server instalado com sucesso!"

###################################### BAIXANDO CONTAINER ZABBIX WEB ###########################

if ! docker container run -d -p 9090:80 -e DB_SERVER_HOST=127.0.0.1 -e DB_SERVER_PORT=3306 -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e ZBX_SERVER_HOST=127.0.0.1 -e PHP_TZ=America/Sao_Paulo --name zbx-web zabbix/zabbix-web-apache-mysql:ubuntu-4.0-latest
 then
 	echo "Nao foi possivel instalar zabbix web."
    exit 1
fi

##################################### INSTALACAO API CORREIOS ###################################


echo "Criando diretorio para instalacao do nginx..."
if ! mkdir -p /docker-nginx/html
then
    echo "Não foi possível criar o diretorio."
    exit 1
fi
echo "Diretorio criado com sucesso!"

echo "Efetuando download da pagina..."
if ! wget -c -P /docker-nginx/html https://raw.githubusercontent.com/faelvinicius/zabbix/master/index.html
then
    echo "Não foi possível efetuar o download."
    exit 1
fi

echo "Instalando nginx"
if ! docker run --name api-correios -p 7676:80 -d -v /docker-nginx/html:/usr/share/nginx/html nginx
then
    echo "Não foi possível instalar o nginx."
    exit 1
fi

echo "Instalação finalizada com sucesso"
echo "Basta acessar pelo browser o seguinte endereço 127.0.0.1 "
echo "Para acessar a busca de CEP dos Correios basta acessar pelo browser o seguinte endereço: 127.0.0.1:7676"