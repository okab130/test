#!/usr/bin/bash
#実行権限設定
#chmod 755 xxxxx.sh
PJNAME="testprj3"
APNAME="newapp"
DBNAME="okab130_04"
#Project Folder Create

#Pj Dirctoryは手作業で作成
mkdir $PJNAME
cd $PJNAME
mkdir templates
mkdir static


#Virtual Enviroment Create
python3 -m venv venv

#Activastion
source venv/bin/activate

#Django install
pip3 install django

#site create
django-admin startproject config .

#Application Create
python3 manage.py startapp $APNAME

#Postgrest Client install
#sudo opt-get install libpg-dev
pip3 install psycopg2
pip3 install psycopg2-binary

psql -c "create database $DBNAME"




