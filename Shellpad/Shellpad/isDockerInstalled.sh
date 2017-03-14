#!/bin/sh

#  isDockerInstalled.sh
#  Trainer
#
#  Created by Morten Just Petersen on 2/1/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.


if hash docker 2>/dev/null && hash git 2>/dev/null; then echo "yes"; else echo "no"; fi
