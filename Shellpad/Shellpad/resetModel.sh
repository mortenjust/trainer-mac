#!/bin/sh

#  resetModel.sh
#  Trainer
#
#  Created by Morten Just Petersen on 2/4/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.

docker exec -itd $1 \
    /bin/bash /
    /scripts/trainer-scripts/resetmodel.sh silently
