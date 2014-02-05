#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){
	echo -e "** Launching containers **\n\n"

	echo "Starting ZOOKEEPER..."
	mkdir -p $APPS/zookeeper/data
	mkdir -p $APPS/zookeeper/logs
	sudo docker rm zookeeper > /dev/null 2>&1
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v $APPS/zookeeper/logs:/logs \
		-name zookeeper \
		oisinmulvihill/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	echo "Starting REDIS..."
	mkdir -p $APPS/redis/data
	mkdir -p $APPS/redis/logs
	REDIS=$(docker run \
		-p 6379:6379 \
		-v $APPS/redis/data:/data \
		-v $APPS/redis/logs:/logs \
		-d \
		oisinmulvihill/redis)
	echo "Started REDIS in container $REDIS"

	echo "Starting ELASTICSEARCH..."
	mkdir -p $APPS/elasticsearch/data
	mkdir -p $APPS/elasticsearch/logs
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 9300:9300 \
		-v $APPS/elasticsearch/data:/data \
		-v $APPS/elasticsearch/logs:/logs \
		-d \
		oisinmulvihill/elasticsearch)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	echo "Starting MONGO..."
	mkdir -p $APPS/mongo/data
	mkdir -p $APPS/mongo/logs
	MONGO=$(docker run \
		-p 27017:27017 \
		-p 28017:28017 \
		-v $APPS/mongo/data:/data/lucid_prod \
		-v $APPS/mongo/logs:/logs \
		-d \
		oisinmulvihill/mongo)
	echo "Started MONGO in container $MONGO"

	echo "Starting SHIPYARD..."
	SHIPYARD=$(docker run \
		-p 8005:8000 \
		-d \
		shipyard/shipyard)

	sleep 1

}

update(){
	apt-get update
	apt-get install -y lxc-docker
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	docker pull omulvihill/zookeeper
	docker pull omulvihill/redis
	docker pull omulvihill/elasticsearch
	docker pull omulvihill/mongo
	docker pull omulvihill/shipyard
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
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh}"
		RETVAL=1
esac
