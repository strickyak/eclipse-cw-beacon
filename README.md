# eclipse-cw-beacon
CW Ham HF Beacon work for Eclipse2017, for IC-7100, using rigctl from hamlib.

Get the latest release or hamlib.
The one shipped in Ubuntu (in 2017) does not have IC-7100.
Works for me on `x86_64` and on Raspberry Pi Model 3.

## Analysis of results:

`run.sh` will run the analysis programs and drop the results
into /tmp/beacon (which will first be removed & recreated).

It expects `.csv` files with the Reverse Beacon Network spots.

See http://yak.net/beacon-plots/ for a rendering of the current results.

## The Beacon Bash Shell script:

`beacon.sh` -- cycles through 10m, 20m, 40m, & 80m,
broadcasting "de w6rek/b w6rek/b yak.net"
and decaying power samples.
(This is close, but it is not the final code that I used.)

`beacon-fast28.sh` -- for a single-band single-frequency 10m beacon.

Occasionally the beacon stops due to a rigctl error.
This needs to be addressed for a long-running beacon.

(Probably we need a rigctl shell function that retries doing something
after failures, sleeping a tenth of a second between attempts.
But other times we use the rigctl expecting an error, as when
determining when tuning or sending CW is finished.)

## Data files:

`*.csv` -- Raw reception logs from the Reverse Beacon Network.

`radiolog.txt` -- one line per transmission.  
Schema: Human-readable UTC timestamp, equivalent Unix seconds timestamp,
frequency in Hertz, power in Watts, CW rate words per pinute.
Example:
```
08-23T18:52:19,1503514339,28087111,50,15
08-23T18:52:59,1503514379,14087111,50,15
08-23T18:53:39,1503514419,7087111,50,15
08-23T18:54:18,1503514458,3587111,50,15
```
(Notice the first few lines in the file are missing the Power field.)
