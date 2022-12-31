#!/bin/bash

set -ex

cd "$(dirname "$0")"

conky -q -c ./lua/title.lua -d &>/dev/null
conky -q -c ./lua/thumbnail.lua -d &> /dev/null
