#!/bin/sh

#  setupTfFiles.sh
#  Trainer
#
#  Created by Morten Just Petersen on 2/1/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.

HOME=~
TF=~/tf_files

echo Setting up in $TF

# TODO run the setup here instead, so we are not depending on the osx app
#docker exec -it c5999872fb1b /bin/bash /scripts/trainer-scripts/prepareandtrain.sh

#
mkdir -p $TF
mkdir -p $TF/images
mkdir -p $TF/images/originals
mkdir -p $TF/images/resized
mkdir -p $TF/videos
mkdir -p $TF/model
