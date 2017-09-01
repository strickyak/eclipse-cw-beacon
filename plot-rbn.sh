#!/bin/bash

# Eclipse Date: 2017-08-21
# Partial starts on Oregon coast: 16:04 UTC
# Totality starts on Oregon coast: 17:16 UTC
# Totality ends on South Carolina coast: 18:49 UTC
# Partial ends on South Carolina coast: 20:09 UTC
# Sunrise: 10:54 UTC
# Solar Noon: 17:30
# Sunset: 00:07 UTC

# Off the air:
# Stopped at     08-21T08:32:48 UTC
# Began again at 08-21T14:52:06 UTC
# Final at       08-23T18:58:57 UTC

cd /tmp/beacon
CALLS=$(ls *.txt | sed 's/[.].*//' | sort | uniq)

echo $CALLS

cat <<~~~~~~ >totality.txt
2017-08-21-17-17-00 0 0 40
2017-08-21-18-49-00 0 0 40
~~~~~~
cat <<~~~~~~ >sunrise.txt
2017-08-21-10-54-00 0 0 40
~~~~~~
cat <<~~~~~~ >sunset.txt
2017-08-21-00-07-00 0 0 40
~~~~~~

(
cat <<~~~~~~
  <html>
  <body>
  <h2>Reception of HF CW Beacon W6REK/B around the 2017-08-21 Great American Eclipse</h2>
  All dates & times are UTC.
  <p>
  For major portions of several days, from Aug 18 to Aug 23, W6REK/B transmitted a CW beacon at 50 Watts on four bands
  (10m, 20m, 40m, and 80m) from a location near Trenton, South Carolina, Maidenhead Grid Square EM93bq.
  It was received on the Reverse Beacon Network (RBN) by a number of stations.
  A record of all transmissions is here: 
  <a href="http://wiki.yak.net/1107/radiolog.txt">radiolog.txt</a>.
  Reception data can be downloaded from
  <a href="http://www.reversebeacon.net/">http://www.reversebeacon.net/</a>.
  Basically the four beacons are sent, one band after the other, in a roughly 2 minute 40 second loop.
  The contents of the beacon was "DE W6REK/B W6REK/B YAK.NET EM93BQ" in CW 
  Morse Code at 15 words per minute.  The referenced web site
  <a href="http://YAK.NET/">YAK.NET<a> has information about the plan for this beacon and links
  to other pages about Ham Science and Ham Eclipse experiments.
  <p>
  Below we plot these receptions and their reported signal-to-noise ratio (in decibels)
  for the stations with more than roughly 100 reports.   All 6 days are folded over
  each other, with the horizontal scale running from 00:00 to 23:59 UTC.
  The mark is a different color and shape depending on which of the 4 bands it was heard on.
  <p>
  During the period from 15:00 UTC to 23:00 UTC on the day of the eclipse (Aug 21),
  two things are different:  The points are connected by lines, and "missing points"
  are drawn below the zero line.  Outside this interval, missing points are not marked.
  The Reverse Beacon Network does not report reception within 10 minutes of aother
  report on the same frequency, by the same station.  So we use a criteron of 15 minutes
  for determining a missing point.  If no reception is reported within 15 minutes,
  we record a missing point, and start another 15 minute interval before recording
  another missing point.
  <p>
  Two vertical brown lines mark the begin and end of totality in the continental US states,
  at 17:17 UTC when totality hits the West Coast of Oregon,
  and at 18:49 UTC when totality leaves the East Coast of South Carolina.
  <p>
  Two more vertical lines mark sunrise and sunset at the transmitter QTH,
  with sunrise around 10:54 UTC (the olive line) and sunset at 00:07 (the blue line).
  <p>
  In many of the graphs you can see the eclipse affecting the blue stars connected by lines
  representing the reception of the 20m beacon.  They tend to fade when totality is about
  halfway across America, and return by an hour after totality has left America.
  <p>
  There is no guarantee the receiving stations were functional during the eclipse
  or at any other particular time, or on any band, unless it reported a positive
  reception.  You'll notice one station N2GZ that seems to have been up only around
  the time of the eclipse, and some stations (e.g. VE2WU) that were not up at all around
  the eclipse.   Also remember this is a report of signal-to-noise ratio,
  not the actual power we were received at.   The most reports were from K1TTT,
  which regularly reported 80m at night, and even some sporadic 10m spots.
  <p>
  I think it's hard to draw strong conclusions from such spotty data,
  except that 20m reception can be seen to suffer consistently in a number of the plots.
  <p>
  de W6REK (Henry Strickland)

~~~~~~

for c in $CALLS
do
  COUNT=$(cat $c.*.txt | wc -l)
  [ 200 -gt $COUNT ] && continue
  cat <<~~~~~~
<h3>$c</h3>
<img src="$c.daywise.png" />
~~~~~~


  cat <<~~~~~~ >tmp.plot
set terminal png medium size 1200,400
set output "$c.daywise.png"
set key inside left top
set xdata time
set timefmt "%Y-%m-%d-%H-%M-%S"
set format x "%H:%M"
set xrange ["2017-08-21-00-00-00" : "2017-08-22-00-00-00"]
set yrange [-2 : 40]

plot \
     "$c.3587.day.txt"  using 1:2 with points lt 1  title "$c 80m" ,\
     "$c.7087.day.txt"  using 1:2 with points lt 2  title "$c 40m" ,\
     "$c.14087.day.txt" using 1:2 with points lt 3  title "$c 20m" ,\
     "$c.28087.day.txt" using 1:2 with points lt 4  title "$c 10m" ,\
     "$c.3587.eclipse.txt"  using 1:2 with linespoints lt 1  title "Around Eclipse: $c 80m" ,\
     "$c.7087.eclipse.txt"  using 1:2 with linespoints lt 2  title "Around Eclipse: $c 40m" ,\
     "$c.14087.eclipse.txt" using 1:2 with linespoints lt 3  title "Around Eclipse: $c 20m" ,\
     "$c.28087.eclipse.txt" using 1:2 with linespoints lt 4  title "Around Eclipse: $c 10m" ,\
     "totality.txt"   using 1:2:3:4 with errorbars lt 6  title "Totality Begin (Oregon West Coast) & END (SC East Coast)"  ,\
     "sunrise.txt"   using 1:2:3:4 with errorbars lt 7  title "Sunrise at SC Beacon QTH"  ,\
     "sunset.txt"   using 1:2:3:4 with errorbars lt 8  title "Sunset at SC Beacon QTH"   ,\
     (0) with lines lt 9 title "Around Eclipse: Below this line, nothing heard."
~~~~~~
  gnuplot tmp.plot

done 
)>/tmp/beacon/index.html
