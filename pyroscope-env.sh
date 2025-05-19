#!/bin/bash

# Pyroscope application configuration
export PYROSCOPE_APPLICATION_NAME=memorydemo
export PYROSCOPE_SERVER_ADDRESS=http://localhost:4040
#export PYROSCOPE_FORMAT=jfr
#export PYROSCOPE_PROFILER_EVENT=cp
#export PYROSCOPE_PROFILER_ALLOC=0
#export PYROSCOPE_PROFILER_LOCK=0
#export PYROSCOPE_LOG_LEVEL=debug

# Print current configuration
echo "Pyroscope configuration:"
echo "Application Name: $PYROSCOPE_APPLICATION_NAME"
echo "Server Address: $PYROSCOPE_SERVER_ADDRESS"
#echo "Format: $PYROSCOPE_FORMAT"
#echo "Profiler Event: $PYROSCOPE_PROFILER_EVENT"
#echo "Profiler Alloc: $PYROSCOPE_PROFILER_ALLOC"
#echo "Profiler Lock: $PYROSCOPE_PROFILER_LOCK"
#echo "Log Level: $PYROSCOPE_LOG_LEVEL"
