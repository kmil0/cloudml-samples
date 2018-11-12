#!/bin/bash
# Copyright 2018 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

run_script_local() {

	cd $1
	echo "Running '$1' code sample."
	DATE=`date '+%Y%m%d_%H%M%S'`
	JOB_DIR=mnist_$DATE
	GCS_TRAIN_FILE=gs://cloud-samples-data/ml-engine/mnist/train-images-idx3-ubyte.gz
    GCS_TRAIN_LABELS_FILE=gs://cloud-samples-data/ml-engine/mnist/train-labels-idx1-ubyte.gz
    GCS_TEST_FILE=gs://cloud-samples-data/ml-engine/mnist/t10k-images-idx3-ubyte.gz
    GCS_TEST_LABELS_FILE=gs://cloud-samples-data/ml-engine/mnist/t10k-labels-idx1-ubyte.gz
    DATA=mnist_data
	TRAIN_FILE=$DATA/train-images-idx3-ubyte.gz
    TRAIN_LABELS_FILE=$DATA/train-labels-idx1-ubyte.gz
    TEST_FILE=$DATA/train-images-idx3-ubyte.gz
    TEST_LABELS_FILE=$DATA/train-labels-idx1-ubyte.gz


	gsutil cp $GCS_TRAIN_FILE $TRAIN_FILE
	gsutil cp $GCS_TRAIN_LABELS_FILE $TRAIN_LABELS_FILE
	gsutil cp $GCS_TEST_FILE $TEST_FILE
	gsutil cp $GCS_TEST_LABELS_FILE $TEST_LABELS_FILE

	# Local training.
	python -m trainer.task \
    --train-file=$TRAIN_FILE \
    --train-labels-file=$TRAIN_LABELS_FILE \
    --test-file=$TEST_FILE \
    --test-labels-file=$TEST_LABELS_FILE \
    --job-dir=$JOB_DIR

	if [ $? = 0 ]; then
		echo "Python script succeeded"
		rm -rf $DATA
		rm -rf $JOB_DIR
		cd ..
		return 0
	fi
	echo "Python script failed"
	return 1
}

run_script_local tensorflow/keras/fashion
if [ $? = 1 ]; then
	exit 1
fi