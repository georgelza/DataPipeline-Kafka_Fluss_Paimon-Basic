
.DEFAULT_GOAL := help
include .env

define HELP

Available commands:

- buildapp: Just build the docker app image.

- run: This will call core.

- deploy: This will create all the catalogs, databases. Flink/Fluss tables etc.

- rp#: Run workload creator/the Python app -> Post onto MQTT Broker Topic
- sp#: Stop Python app

- stop: Stop the project.
- start: Start a stopped project.
- down: Tear down the project, clean directories.
- ps: Show all running containers.

- logs: Show/tail logs.
- logsf: Stream logs.
- watch: Watch logs.

- fsql: Open Flink Jobmanager and start sql-client.
- jm: Open a bash terminal inside Jobmanager.
- cs: Open a bash terminal inside Coordinator Server.

endef

export HELP
help:
	@echo "$$HELP"
.PHONY: help



buildapp:
	cd ../app_iot1; make build

#	docker rmi $(docker images -q --filter "dangling=true")

run: 
	docker compose -p pipeline up -d \
		broker schema-registry  control-center \
		postgres metastore hiveserver2 \
		jobmanager taskmanager \
		zookeeper coordinator-server tablet-server-0 tablet-server-1 tablet-server-2 \
		namenode resourcemanager historyserver nodemanager1 datanode1 datanode2 datanode3 datanode4 datanode5 \
		 --remove-orphans 
 

deploy: createcat createtopics source targets

createtopics:
	./creTopics/creTopics.sh
 
createcat:
	docker compose exec jobmanager /opt/flink/bin/sql-client.sh -f /sql/1.0.creCat.sql

source:
	docker compose exec jobmanager /opt/flink/bin/sql-client.sh -f /sql/2.0.creKafkaSource.sql

targets:
#	docker compose exec jobmanager /opt/flink/bin/sql-client.sh -f /sql/2.1.creFlussTargets.sql
	docker compose exec jobmanager /opt/flink/bin/sql-client.sh -f /sql/2.2.creFlussTargets.sql

inserts:
#	docker compose exec jobmanager /opt/flink/bin/sql-client.sh -f /sql/3.1.creFlussInserts.sql
	docker compose exec jobmanager /opt/flink/bin/sql-client.sh -f /sql/3.2.creFlussInserts.sql

# The below require the HDFS stack to be working... commented out currently above.
lakehouse:
	docker compose exec coordinator-server /bin/bash -f /shell/4.runLakehouse.bsh

# Run Python app  101,104 - North
rp1:
	docker compose -p pipeline up -d iot1

# Stop Python app
sp1:
	docker compose stop iot1

# Run Python app  102,105 - South
rp2:
	docker compose -p pipeline up -d iot2

# Stop Python app
sp2:
	docker compose stop iot2

# Run Python app  103,106 - East
rp3:
	docker compose -p pipeline up -d iot3

# Stop Python app
sp3:
	docker compose stop iot3


stop:
	docker compose stop

start:
	docker compose start

down:	
	docker compose down
	cd data; rm -rf flink
	cd data; rm -rf fluss
	cd data; rm -rf paimon
	cd data; rm -rf postgres
	cd data; rm -rf confluent.d

ps:
	docker compose ps

logs:
	docker compose logs

logsf:
	docker compose logs -f

watch:
	watch docker compose ps

fsql:
	docker compose exec jobmanager /opt/flink/bin/sql-client.sh

jm:
	docker compose exec jobmanager /bin/bash

cs:
	docker compose exec coordinator-server /bin/bash
