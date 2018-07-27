#!/bin/bash

#Script para inicializar o cluster

bin/hadoop namenode -format
sbin/start-dfs.sh
sbin/start-yarn.sh

bin/hadoop dfs -copyFromLocal dado1GB.txt /
