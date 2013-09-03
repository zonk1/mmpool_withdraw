#!/bin/bash -xv

# Add to cron every 4+ hours or so. DO NOT SET TO RUN TOO FREQUENTLY, YOU'LL PUT UNNEEDED LOAD ON MMPOOL'S SERVERS

user="pfzminer"
wlog="$HOME/withdraw.log"

btc_thresh="1.0"
dev_thresh="500.0"
ix_thresh="20.0"
nmc_thresh="2.0"
i0_thresh="20.0"

[ -e "$wlog" ] || touch "$wlog"

rawstats=$(curl -s http://mmpool.bitparking.com/user/${user})

function withdraw() {
  coin="$1"
  threshold="$2"
  balance=$(echo "${rawstats}" | grep -Po "(?<=<td>${coin}</td><td class=\"number\">)[0-9]*\.[0-9]*")

  if [ `bc <<< "${balance}>${threshold}"` = 1 ]; then
    echo "[`date`] ${coin}s mined (${balance}) is greater than threshold (${threshold}). Withdrawing." >> "$wlog"
    curl -s "http://mmpool.bitparking.com/withdrawCoin/${user}/${coin}" &> /dev/null
  else
    echo "[`date`] ${coin}s mined: ${balance}, withdraw threshold is ${threshold}." >> "$wlog"
  fi
}

echo "[`date`] mmpool.sh started" >> "$wlog"

withdraw bitcoin "$btc_thresh"
withdraw devcoin "$dev_thresh"
withdraw ixcoin "$ix_thresh" 
withdraw namecoin "$nmc_thresh"
withdraw i0coin "$i0_thresh" 

