#!/bin/sh

#  startTensorboard.sh
#  Trainer
#
#  Created by Morten Just Petersen on 2/3/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.


echo "Starting Tensorboard on image $1"

docker exec -itd $1 \
    /bin/bash /scripts/starttensorboard.sh
