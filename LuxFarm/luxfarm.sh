#!/bin/bash 

# Network rendering for LuxRender

export LD_LIBRARY_PATH=/shared/ucl/apps/gcc/4.6.3/lib:/shared/ucl/apps/gcc/4.6.3/lib64:/shared/ucl/apps/luxrender-1.2RC1/lib:/shared/ucl/apps/luxrender-1.2RC1/lib64:/shared/ucl/apps/luxrender-1.2RC1/usr/lib:/shared/ucl/apps/luxrender-1.2RC1/usr/lib64:$LD_LIBRARY_PATH
export PATH=/shared/ucl/apps/luxrender-1.2RC1/lib:/shared/ucl/apps/luxrender-1.2RC1/lib64:$PATH

if [[ -z "$TMPDIR" ]]; then
  echo "No TMPDIR set for LuxFarm, quitting..." >&2
  exit 5
fi

#module unload compilers
#module load compilers/gnu/4.6.3
#module load luxrender

echo "LuxFarm starts at `date`."

# Get a list of the slave nodes we can use
cat $TMPDIR/machines | grep -v `hostname` | uniq >$TMPDIR/machines_unique_otherthanme
if [ `wc -l $TMPDIR/machines_unique_otherthanme | cut -f 1 -d ' '` -eq 0 ]; then
  echo "Running on a single node -- just using vanilla luxconsole..." >&2
else
  # Set up the slave nodes
  Slaves=""
  for i in `cat $TMPDIR/machines_unique_otherthanme`; do
    echo "Starting luxslave.sh on node: $i" >&2
    ssh $i luxslave.sh &
    Slaves="$Slaves -u $i"
  done
fi

# Sleep to give the slaves time to start up properly
sleep 10

# Run the master (or the only if only a single node is used)
echo "Running luxconsole master..." >&2
luxconsole $Slaves $*

echo "LuxFarm stops at `date`."

