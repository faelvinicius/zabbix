#!/bin/bash

#Autor: Rafael Vinicius

################################### ATUALIZANDO O SO ####################################
echo "Iniciando a instalacao do Zabbix..."
echo "Atualizando repositórios..."
if ! apt-get update
then
    echo "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list"
    exit 1
fi
echo "Atualização feita com sucesso"


#################################### ATUALIZANDO CURL e WGET ###############################
echo "Instalando o curl..."
if ! apt-get install curl && wget -y
then
    echo "Não foi possível instalar o curl."
    exit 1
fi
echo "Instalação do curl feita com sucesso"

##################################### INSTALANDO DOCKER ####################################

echo "Instalando o Docker..."
if ! curl -fsSL https://get.docker.com | bash
then
    echo "Não foi possível instalar o docker."
    exit 1
fi

##################################### CRIANDO DIRETORIO PARA O MYSQL ########################

echo "Criando diretorio para instalacao do MYSQL..."
if ! mkdir -p /zbx-server/mysql/data
then
    echo "Não foi possível criar o diretorio."
    exit 1
fi    
	echo "Diretorio criado com sucesso!"

##################################### BAIXANDO CONTAINER MYSQL ###############################

echo "Digite o IP do HOST para prosseguir com a instalacao do MYSQL..."
read ip
if ! docker container run -d -p 3306:3306 -v /zbx-server/mysql/data:/var/lib/mysql -e MYSQL_HOST=$ip -e MYSQL_USER=zabbix -e MYSQL_ROOT_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e MYSQL_PASSWORD=zabbix --name mysql-zbx mysql:5.7
then
	echo "Nao foi possivel instalar o MYSQL."
    exit 1
fi
	echo "MYSQL instalado com sucesso!"

##################################### BAIXANDO CONTAINER ZABBIX SERVER #########################

if ! docker container run -d -p 10051:10051 -e MYSQL_ROOT_PASSWORD=zabbix -e DB_SERVER_HOST=$ip -e DB_SERVER_PORT=3306 -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix --name zbx-server zabbix/zabbix-server-mysql:ubuntu-4.0-latest
then
	echo "Nao foi possivel instalar Zabbix Server."
  exit 1	
fi
	echo "Zabbix server instalado com sucesso!"

###################################### BAIXANDO CONTAINER ZABBIX WEB ###########################

if ! docker container run -d -p 80:80 -e DB_SERVER_HOST=$ip -e DB_SERVER_PORT=3306 -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e ZBX_SERVER_HOST=$ip -e PHP_TZ=America/Sao_Paulo --name zbx-web zabbix/zabbix-web-apache-mysql:ubuntu-4.0-latest
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
if ! docker run --name api-correios3 -p 7676:80 -d -v /docker-nginx/html:/usr/share/nginx/html nginx
then
    echo "Não foi possível instalar o nginx."
    exit 1
fi


echo "Instalação finalizada com sucesso"
echo "Basta acessar pelo browser o seguinte endereço $ip "
echo "Para acessar a busca de CEP dos Correios basta acessar pelo browser o seguinte endereço: $ip:7676"
