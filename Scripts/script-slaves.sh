#!/bin/bash

#script executado nos slaves, chamado pelo script-master.sh que executa no Master

#$1 --> numero da iteracao (variando de 1 a 3)
#$2 --> Tamanho do arquivo

#Monitoramento de CPU
sar 1 >> 2-slave/cpu/$2"GB"/$1"-slave1cpu-"$2"GB".txt &


