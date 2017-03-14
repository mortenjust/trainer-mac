#!/bin/sh

#  startTraining.sh
#  Trainer
#
#  Created by Morten Just Petersen on 2/3/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.

container=$1


docker exec -i $1 \
/bin/bash /scripts/trainer-scripts/prepareandtrain.sh
