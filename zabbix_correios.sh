#!/bin/bash

echo "Iniciando a instalacao do Zabbix..."
echo "Atualizando repositórios..."
if ! apt-get update
then
       echo "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list"
       exit 1
fi
echo "Atualização feita com sucesso"

echo "Instalando o curl..."
if ! apt-get install curl -y
then
       echo "Não foi possível instalar o curl."
       exit 1
fi
echo "Instalação do curl feita com sucesso"

echo "Instalando o Docker..."
if ! curl -fsSL https://get.docker.com | bash
then
       echo "Não foi possível instalar o docker."
       exit 1
fi
echo "Instalação do docker feita com sucesso"



echo "Criando diretorio para instalacao do MYSQL..."
if ! mkdir -p /zbx-server/mysql/data
then
       echo "Não foi possível criar o diretorio."
       exit 1
fi    
       echo "Diretorio criado com sucesso!"

echo "Digite o IP do para prosseguir com a instalacao do MYSQL..."
read ip
if ! docker container run -d -p 3306:3306 -v /zbx-server/mysql/data:/var/lib/mysql -e MYSQL_HOST=$ip -e MYSQL_USER=zabbix -e MYSQL_ROOT_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e MYSQL_PASSWORD=zabbix --name mysql-zbx mysql:5.7
then 
	   echo "nao foi possivel instalar o MYSQL"  
       exit 1
fi

echo " Digite o IP do HOST para prosseguir a instalacao do Zabbix Server..."
read ip
if ! docker container run -d -p 10051:10051 -e MYSQL_ROOT_PASSWORD=zabbix -e DB_SERVER_HOST=$ip -e DB_SERVER_PORT=3306 -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix --name zbx-server zabbix/zabbix-server-mysql:ubuntu-4.0-latest
then
	   echo "Nao foi possivel instalar Zabbix Server."
  	   exit 1	
fi


echo "Digite o IP do HOST para prosseguir a instalacao do zabbix web..."
read ip
if ! docker container run -d -p 80:80 -e DB_SERVER_HOST=$ip -e DB_SERVER_PORT=3306 -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e ZBX_SERVER_HOST=$ip -e PHP_TZ=America/Sao_Paulo --name zbx-web zabbix/zabbix-web-apache-mysql:ubuntu-4.0-latest
then
 	   echo "Nao foi possivel instalar zabbix web."
       exit 1
fi

echo "Instalacao API Correios"
if ! docker run --rm -d -p 8080:8080 feliperoberto/non-official-correios-api
then
 	   echo "Nao foi possivel instalar a API correios."
       exit 1
fi

echo "Instalação finalizada com sucesso"
echo "Basta acessar o zabbix pelo browser, basta acessar o seguinte endereço $ip "
echo "Para acessar o correios, basta acessar o seguinte endereço $ip:8080 "
