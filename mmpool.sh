#!/bin/bash

# Add to cron every 4+ hours or so. DO NOT SET TO RUN TOO FREQUENTLY, YOU'LL PUT UNNEEDED LOAD ON MMPOOL'S SERVERS

user="mmpool-user"
wlog="~/withdraw.log"

rawstats=$(curl -s http://mmpool.bitparking.com/user/${user})
bitcoin=$(echo ${rawstats} | grep -Po '(?<=<td>bitcoin</td><td class="number">)[0-9]*\.[0-9]*')
devcoin=$(echo ${rawstats} | grep -Po '(?<=<td>devcoin</td><td class="number">)[0-9]*\.[0-9]*')
ixcoin=$(echo ${rawstats} | grep -Po '(?<=<td>ixcoin</td><td class="number">)[0-9]*\.[0-9]*')
namecoin=$(echo ${rawstats} | grep -Po '(?<=<td>namecoin</td><td class="number">)[0-9]*\.[0-9]*')

echo "--- mmpool.sh started `date` ---" | tee -a $wlog

if [ `bc <<< "${bitcoin}>0.1"` = 1 ]; then
  echo "[`date`] Bitcoins mined (${bitcoin}) is greater than threshold (0.1). Withdrawing." | tee -a $wlog
  curl -s "http://mmpool.bitparking.com/withdrawCoin/${user}/bitcoin" &> /dev/null
else
  echo "Bitcoins mined: ${bitcoin}, withdraw threshold is 0.1."
fi
if [ `bc <<< "${devcoin}>100"` = 1 ]; then
  echo "[`date`] Devcoins mined (${devcoin}) is greater than threshold (100). Withdrawing." | tee -a $wlog
  curl -s "http://mmpool.bitparking.com/withdrawCoin/${user}/devcoin" &> /dev/null
else
  echo "Devcoins mined: ${devcoin}, withdraw threshold is 100."
fi
if [ `bc <<< "${ixcoin}>10"` = 1 ]; then
  echo "[`date`] Ixcoins mined (${ixcoin}) is greater than threshold (10). Withdrawing." | tee -a $wlog
  curl -s "http://mmpool.bitparking.com/withdrawCoin/${user}/ixcoin" &> /dev/null
else
  echo "Ixcoins mined: ${ixcoin}, withdraw threshold is 10."
fi
if [ `bc <<< "${namecoin}>0.1"` = 1 ]; then
  echo "[`date`] Namecoins mined (${namecoin}) is greater than threshold (0.1). Withdrawing." | tee -a $wlog
  curl -s "http://mmpool.bitparking.com/withdrawCoin/${user}/namecoin" &> /dev/null
else
  echo "Namecoins mined: ${namecoin}, withdraw threshold is 0.1."
fi
