#!/bin/sh

#  boot.sh
#  Trainer
#
#  Created by Morten Just Petersen on 1/30/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.

echo "Stopping ghost images"
docker stop $(docker ps -q --filter ancestor=mortenjust/trainer)


echo "Starting Ubuntu..."

#docker run -itd mortenjust/trainer

#docker run -itd \
#    -v $HOME/tf_files:/tf_files \
#    mortenjust/trainer:latest

docker run -itd \
    -v $HOME/tf_files:/tf_files \
    -p 0.0.0.0:7007:6006 \
    mortenjust/trainer

