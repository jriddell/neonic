#!/bin/bash

WORKERS="46.101.189.70 46.101.153.146 46.101.165.122 46.101.184.166"

for worker in $WORKERS; do
    echo ==${worker}==;
    ssh -i ~/.ssh/do-ssh-key-blue-private.pem root@${worker} 'systemctl stop docker; systemctl stop docker.socket; rm -r /var/lib/docker;  systemctl start docker.socket; systemctl start docker'
done
