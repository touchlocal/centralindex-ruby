#!/bin/sh
gem build centralindex.gemspec
gem push *.gem
rm *.gem

