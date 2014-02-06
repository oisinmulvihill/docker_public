#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`sudo docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`sudo docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){
	echo -e "** Launching containers **\n\n"

	echo "Starting REDIS..."
	mkdir -p $APPS/redis/data
	mkdir -p $APPS/redis/logs
	REDIS=$(sudo docker run \
		-p 16379:16379 \
		-v $APPS/redis/data:/data \
		-v $APPS/redis/logs:/logs \
		-d \
		oisinmulvihill/redis)
	echo "Started REDIS in container $REDIS"

	echo "Starting MONGO..."
	mkdir -p $APPS/mongo/data
	mkdir -p $APPS/mongo/logs
	MONGO=$(sudo docker run \
		-p 27017:27017 \
		-p 28017:28017 \
		-v $APPS/mongo/data:/data/lucid_prod \
		-v $APPS/mongo/logs:/logs \
		-d \
		oisinmulvihill/mongo)
	echo "Started MONGO in container $MONGO"

	echo "Starting RIAK..."
	RIAK=$(sudo docker run \
		-p 8098:8098 \
		-d \
		oisinmulvihill/riak)
	echo "Started RIAK in container $RIAK"

	echo "Starting DEVBOX..."
	RIAK=$(sudo docker run \
		-p 1022:22 \
		-d \
		oisinmulvihill/devbox)
	echo "Started DEVBOX in container $DEVBOX"

	echo "Starting SHIPYARD..."
	SHIPYARD=$(sudo docker run \
		-p 8005:8000 \
		-d \
		oisinmulvihill/shipyard)

	sleep 1
}

update(){
	apt-get update
	apt-get install -y lxc-docker
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	docker pull omulvihill/redis
	docker pull omulvihill/mongo
	docker pull omulvihill/riak
	docker pull omulvihill/devbox
	docker pull omulvihill/shipyard
}

build_images() {
	echo "Kicking off image build."
	SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"

	for dir in $SCRIPT_HOME/../images/*/
	do
		cd $dir &&
		image_name=${PWD##*/} && # to assign to a variable
		echo "Building $image_name from $dir" &&
		docker build -t oisinmulvihill/$image_name .
	done
}


case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	build_images)
		build_images
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|build_images|restart|status|ssh}"
		RETVAL=1
esac
