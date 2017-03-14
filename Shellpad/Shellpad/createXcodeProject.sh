#!/bin/sh

#  createXcodeProject.sh
#  Trainer
#
#  Created by Morten Just Petersen on 2/5/17.
#  Copyright © 2017 Morten Just Petersen. All rights reserved.


# can't run this from the docker because it needs to get dependencies and compile stuff on a mac, so here we go

# TODO don't hardcode
# TODO create another project if one exists


TFBASE=~/tf_files

cd "$TFBASE"

mkdir -p "$TFBASE/projects"

cd "$TFBASE/projects"
git clone --recursive -j8 https://github.com/mortenjust/tensorswift-ios.git
cd tensorswift-ios
./setup.sh

# copy in the model and label file

cp "$TFBASE/model/retrained_graph_stripped.pb" \
   "$TFBASE/projects/tensorswift-ios/tensorswift/retrained_graph_stripped.pb"

cp "$TFBASE/model/retrained_labels.txt" \
   "$TFBASE/projects/tensorswift-ios/tensorswift/retrained_labels.txt"

# TODO: Modify the project's Config.swift to correspond to each line of retrained_labels.txt
