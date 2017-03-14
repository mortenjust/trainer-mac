#!/bin/sh

#  stopDocker.sh
#  Trainer
#
#  Created by Morten Just Petersen on 1/30/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.

CONTAINER=$1

echo "0 : $0"
echo "1 : $1"
echo "2 : $2"
echo "3 : $3"
echo "4 : $4"


echo "Stopping container $1"
docker kill $CONTAINER

