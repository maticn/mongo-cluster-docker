#!/bin/bash 

mongodbrouter="192.168.20.160"
thisip="192.168.20.186"

port=${PORT:-27017}

echo $mongodbrouter
echo $thisip

echo "Waiting for startup.."
until mongo --host ${mongodbrouter}:${port} --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null; do
  printf '.'
  sleep 1
done

echo "Started.."

echo init-shard34.sh time now: `date +"%T" `
mongo --host ${mongodbrouter}:${port} <<EOF
   sh.addShard( "${RS3}/${thisip}:${PORT1},${thisip}:${PORT2},${thisip}:${PORT3}" );
   sh.addShard( "${RS4}/${thisip}:${PORT4},${thisip}:${PORT5},${thisip}:${PORT6}" );
   sh.status();
EOF
