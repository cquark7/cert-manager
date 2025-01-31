#!/usr/bin/env bash
# Copyright 2021 The cert-manager Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

REPLACE_NEW=TEMP_REPLACE_IGNORE_AUTOGENERATED_NEW_SYNTAX
REPLACE_OLD=TEMP_REPLACE_IGNORE_AUTOGENERATED_OLD_SYNTAX

remove_go_autogen_tags() {
	if [ "$#" -ne 1 ]; then
          echo "Usage: hack::lib::remove_go_autogen_tags <file>"
	  exit 1
	fi
	local file="$1"

	local sed_args
	if [[ $(uname) == 'Darwin' ]]; then
		sed_args=''
	elif [[ $(uname) == 'Linux' ]]; then
	  sed_args+=('-i')
	else
	  echo "Unsupported OS: $(uname), please raise an issue if you would like it to be supported"
	  exit 1
	fi
      
        # Currently (Go 1.17) both // +build and //go: build lines are added to files.
	# This code should keep working with a new version of Go that only adds //go: build lines.
	# https://go.googlesource.com/proposal/+/master/design/draft-gobuild.md
        sed "${sed_args}"  -e "s/\+build \!ignore_autogenerated/$REPLACE_OLD/" "${file}" \
          -e "s/go\:build\ \!ignore_autogenerated/$REPLACE_NEW/" "${file}"
}

replace_go_autogen_tags() {
	if [ "$#" -ne 1 ]; then
          echo "Usage: hack::lib::remove_go_autogen_tags <file>"
	  exit 1
	fi
	local file="$1"

	local sed_args
	if [[ $(uname) == 'Darwin' ]]; then
		sed_args=''
	elif [[ $(uname) == 'Linux' ]]; then
	  sed_args='-i'
	else
	  echo "Unsupported OS: $(uname), please raise an issue if you would like it to be supported"
	  exit 1
	fi
      
        # Currently (Go 1.17) both // +build and //go: build lines are added to
	# files.
	# This code should keep working with a new version of Go that only adds //go: build lines.
	# See https://go.googlesource.com/proposal/+/master/design/draft-gobuild.md
        sed "${sed_args}"  -e "s/$REPLACE_NEW/go\:build\ \!ignore_autogenerated/" "${file}" \
          -e "s/$REPLACE_OLD/\+build \!ignore_autogenerated/" "${file}"
}
