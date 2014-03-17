#!/bin/sh

# DummyJohn init script

# You have to SET the DummyJohn installation directory here

DUMMYJOHN_DIR="somewhere"
DUMMYJOHN_USER="somebody"

usage() {
	echo "Usage: `basename $0`: <start|stop|status>"
	exit 1
}

start() {
	status
	if [ $PID -gt 0 ]
	then
		echo "DummyJohn server daemon was already started. PID: $PID"
		return $PID
	fi
	echo "Starting DummyJohn server daemon..."
	cd "$DUMMYJOHN_DIR/bin"
	su -c "cd \"$DUMMYJOHN_DIR/bin\"; /usr/bin/nohup ./server.sh 1>../log/dummyjohn.log 2>../log/dummyjohn.err &" - $DUMMYJOHN_USER
}

stop() {
	status
	if [ $PID -eq 0 ]
	then
		echo "OrientDB server daemon is already not running"
		return 0
	fi
	echo "Stopping OrientDB server daemon..."
	cd "$DUMMYJOHN_DIR/bin"
	su -c "cd \"$DUMMYJOHN_DIR/bin\"; /usr/bin/nohup ./shutdown.sh 1>>../log/orientdb.log 2>>../log/orientdb.err &" - $DUMMYJOHN_USER
}

status() {
	PID=`ps -ef | grep 'dummyjohn.www.path' | grep java | grep -v grep | awk '{print $2}'`
	if [ "x$PID" = "x" ]
	then
		PID=0
	fi
	
	# if PID is greater than 0 then DummyJohn is running, else it is not
	return $PID
}

if [ "x$1" = "xstart" ]
then
	start
	exit 0
fi

if [ "x$1" = "xstop" ]
then
	stop
	exit 0
fi

if [ "x$1" = "xstatus" ]
then
	status
	if [ $PID -gt 0 ]
	then
		echo "DummyJohn server daemon is running with PID: $PID"
	else
		echo "DummyJohn server daemon is NOT running"
	fi
	exit $PID
fi

usage

