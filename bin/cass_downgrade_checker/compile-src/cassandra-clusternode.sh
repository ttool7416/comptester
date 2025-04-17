#!/usr/bin/env bash
set -euo pipefail

# Get running container's IP
IP=$(hostname --ip-address | cut -f 1 -d ' ')
if [ $# == 1 ]; then
    SEEDS="$1,$IP"
else SEEDS="$IP"; fi

# Change it to the target systems
ORG_VERSION=apache-cassandra-2.2.8
UPG_VERSION=apache-cassandra-3.0.15

# create necessary dirs (some version of cassandra cannot create these)
mkdir -p /var/log/cassandra
mkdir -p /var/lib/cassandra

if [[ ! -f "/tmp/.setup_conf" ]]; then
    echo "copy and format configurations"
    for VERSION in ${ORG_VERSION} ${UPG_VERSION}; do
        mkdir /etc/${VERSION}
        echo "cp -r \"/cassandra/${VERSION}/conf/*\" \"/etc/${VERSION}\""
        cp -r /cassandra/${VERSION}/conf/* /etc/${VERSION}
        CONFIG="/etc/${VERSION}"

        # If using the default configurations, just stop the replacing

        arrIN=(${VERSION//-/ })
        echo "split1 = " ${arrIN[2]}
        arrIN1=(${arrIN[2]//./ })
        MAIN_VERSION=${arrIN1[0]}
        MINOR_VERSION=${arrIN1[1]}
        if [[ ${MAIN_VERSION} -gt "2" ]]; then
                echo "hints_directory: /var/lib/cassandra/hints" >> ${CONFIG}/cassandra.yaml
                if [[ ${MINOR_VERSION} -ge "11" ]]; then
                        echo "cdc_raw_directory: /var/lib/cassandra/cdc_raw" >> ${CONFIG}/cassandra.yaml
                fi
        fi

        sed -i 's/#MAX_HEAP_SIZE="4G"/MAX_HEAP_SIZE="512M"/' ${CONFIG}/cassandra-env.sh
        sed -i 's/#HEAP_NEWSIZE="800M"/HEAP_NEWSIZE="200M"/' ${CONFIG}/cassandra-env.sh

        # Change these to append will work
        # config on-disk data locations
        echo "data_file_directories:" >> ${CONFIG}/cassandra.yaml
        echo "  - /var/lib/cassandra/data" >> ${CONFIG}/cassandra.yaml
        echo "commitlog_directory: /var/lib/cassandra/commitlog" >> ${CONFIG}/cassandra.yaml
        echo "saved_caches_directory: /var/lib/cassandra/saved_caches" >> ${CONFIG}/cassandra.yaml

        # Setup cluster name
        if [ -z "$CASSANDRA_CLUSTER_NAME" ]; then
            echo "No cluster name specified, preserving default one"
        else
            sed -i -e "s/^cluster_name:.*/cluster_name: $CASSANDRA_CLUSTER_NAME/" ${CONFIG}/cassandra.yaml
        fi

        echo "Before starting Cassandra on $IP... Config dir $CASSANDRA_HOME/conf" >/tmp.log
        grep address ${CONFIG}/cassandra.yaml >>/tmp.log 2>&1

        # Dunno why zeroes here
        sed -i -e "s/^rpc_address.*/rpc_address: $IP/" ${CONFIG}/cassandra.yaml >>/tmp.log 2>&1

        # Listen on IP:port of the container
        sed -i -e "s/^listen_address.*/listen_address: $IP/" ${CONFIG}/cassandra.yaml >>/tmp.log 2>&1

        # FIXME skip now
        # # Change the logging level accordingly
        # if [ -z "$CASSANDRA_LOGGING_LEVEL" ]; then
        #     echo "No log level specified, preserving default INFO"
        # else
        #     sed -i -e "s/^log4j.rootLogger=.*/log4j.rootLogger=$CASSANDRA_LOGGING_LEVEL,stdout,R/" ${CONFIG}/log4j-server.properties >>/tmp.log 2>&1
        # fi

        echo "after" >>/tmp.log
        grep address ${CONFIG}/cassandra.yaml >>/tmp.log 2>&1

        # Configure Cassandra seeds
        if [ -z "$CASSANDRA_SEEDS" ]; then
            echo "No seeds specified, being my own seed..."
            CASSANDRA_SEEDS=$SEEDS
        fi
        sed -i -e "s/- seeds: .*/- seeds: \"$CASSANDRA_SEEDS\"/" ${CONFIG}/cassandra.yaml

        # With virtual nodes disabled, we need to manually specify the token
        # Not needed for Cassandra 0.8
        #if [ -z "$CASSANDRA_TOKEN" ]; then
        #       echo "Missing initial token for Cassandra"
        #       exit -1
        #fi
        #echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.initial_token=$CASSANDRA_TOKEN\"" >> $CASSANDRA_HOME/conf/cassandra-env.sh

        # Most likely not needed
        #echo "JVM_OPTS=\"\$JVM_OPTS -Djava.rmi.server.hostname=$IP\"" >> $CASSANDRA_HOME/conf/cassandra-env.sh
    done
    echo "setup done"
    touch "/tmp/.setup_conf"
fi
echo "Starting Cassandra on $IP..."
echo "Starting Cassandra on $IP... Config dir $CASSANDRA_HOME/conf" >>/tmp.log

echo "ENV: HOME:${CASSANDRA_HOME}\nCONF:${CASSANDRA_CONF}"
#exec cassandra -f
# -exec $CASSANDRA_HOME/bin/cassandra -Dcassandra.ring_delay_ms=100 -Dcassandra.broadcast_interval_ms=100 -fR 
exec $CASSANDRA_HOME/bin/cassandra -fR 
# use R so that Cassandra can be run as root
