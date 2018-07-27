#!/bin/bash

i=1
while [ $i -lt 4 ];

do

    # Monitoramento de CPU no master
    sar 1 >> 2-slave/cpu/$1"GB"/$i"-mastercpu-"$1"GB".txt &
   
    # Execucao dos scripts nos slaves, via SSH, para acionar o monitoramento de CPU e memoria dos mesmos
    ssh hadoop@slave1 './script-slaves.sh' $i '' $1 ' && exit'
    ssh hadoop@slave2 './script-slaves.sh' $i '' $1 ' && exit'
    ssh hadoop@slave3 './script-slaves.sh' $i '' $1 ' && exit'
    ssh hadoop@slave4 './script-slaves.sh' $i '' $1 ' && exit'
    ssh hadoop@slave5 './script-slaves.sh' $i '' $1 ' && exit'
    ssh hadoop@slave6 './script-slaves.sh' $i '' $1 ' && exit'
    
    # Execucao da aplicacao WordCount
    date>> 2-slave/hora/$1"GB"/$i"-hora-"$1"GB".txt;/usr/bin/time -po 2-slave/tempo/$1"GB"/$i"-tempo-"$1"GB".txt bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.2.jar wordcount /dado$1"GB".txt /out$i"-"$1"GB"; date >> 2-slave/hora/$1"GB"/$i"-hora-"$1"GB".txt

    #Terminada a execucao da aplicacao eh necessario encerrar o monitoramento de CPU nos slaves.
    ssh hadoop@slave1 'killall -s SIGINT sar && exit'
    ssh hadoop@slave2 'killall -s SIGINT sar && exit'
    ssh hadoop@slave3 'killall -s SIGINT sar && exit'
    ssh hadoop@slave4 'killall -s SIGINT sar && exit'
    ssh hadoop@slave5 'killall -s SIGINT sar && exit'
    ssh hadoop@slave6 'killall -s SIGINT sar && exit'

    killall -s SIGINT "sar" #Termino do monitoramento de CPU no master - Esse comando eh equivalente a um Ctrl+c emitido no terminal para todos os processos do Sysstat

i=$((i+1))
done

#Apos as 3 iteracoes o tamanho do arquivo eh incrementado para a proxima execucao

bin/hadoop dfs "-rm" /dado$1"GB".txt #apagando o arquivo atual
#apagando diretorio e arquivos gerados pela aplicacao com o resultado do WordCount
bin/hadoop dfs "-rm" /out$i"-"$1"GB"/* 
bin/hadoop dfs "-rmdir" /out$i"-"$1"GB"
y=$1
x=$((y+1))
if [ $x -ne 17 ]; then
    cat dado$1"GB".txt >> dado$x"GB".txt
    cat dado.txt >> dado$x"GB".txt
    rm '-rf' dado$1"GB".txt 
    bin/hadoop dfs -copyFromLocal dado$x"GB".txt /

fi
