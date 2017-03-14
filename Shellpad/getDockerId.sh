#!/bin/sh

#  getDockerId.sh
#  Trainer
#
#  Created by Morten Just Petersen on 1/31/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.
# returns docker ID
#
# This shell cannot return anything else than the latest container
docker ps -ql
