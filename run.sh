set -x
rm -rf /tmp/beacon
set -e
mkdir /tmp/beacon
cat *csv | python grok-rbn.py  2>&1 > _ 
TZ='GMT+0' sh plot-rbn.sh
