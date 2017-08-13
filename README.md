# eclipse-cw-beacon
CW Ham HF Beacon work for Eclipse2017, for IC-7100, using rigctl from hamlib.

Work in progress.  Written in bash.

Get the latest release or hamlib.
The one shipped in Ubuntu (in 2017) does not have IC-7100.

`beacon.sh` -- cycles through 10m, 20m, 40m, & 80m,
broadcasting "de w6rek/b w6rek/b yak.net"
and decaying power samples.

`beacon-fast28.sh` -- for a single-band single-frequency 10m beacon.

`spin.sh` -- Subroutine to wait until a :00 or :30 seconds after
the minute, then report which phase is beginning, of four 30-second
phases aligned to full 2-minute cycles.
