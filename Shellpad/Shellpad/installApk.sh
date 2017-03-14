#!/bin/sh

#  installApk.sh
#  Shellpad
#
#  Created by Morten Just Petersen on 11/1/15.
#  Copyright © 2015 Morten Just Petersen. All rights reserved.


thisdir=$1
filename=$2

adb=$1/adb

echo "$adb" install -r "$filename"
"$adb" install -r "$filename"
