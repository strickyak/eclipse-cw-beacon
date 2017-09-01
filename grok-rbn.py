# callsign,de_pfx,de_cont,freq,band,dx,dx_pfx,dx_cont,mode,db,date,speed,tx_mode

from datetime import datetime, timedelta, tzinfo
import sys 

MY_CALL = 'W6REK/B'
VALID_FREQS = [3587, 7087, 14087, 28087]
NUM_FREQS = len(VALID_FREQS)

# python is hard {
TIME_DELTA_ZERO = timedelta(0)
class UTC(tzinfo):
    def utcoffset(self, dt):
        return TIME_DELTA_ZERO
    def tzname(self, dt):
        return "UTC"
    def dst(self, dt):
        return TIME_DELTA_ZERO
utc_instance = UTC()
def ParseDateUTC(date_str):
  Y, m, d, H, M, S = [int(x) for x in date_str.replace('-', ' ').replace(':', ' ').split()]
  return datetime(Y, m, d, H, M, S, 0, utc_instance)
# python is hard }

Graph = dict()
def GraphFor(call, freq):
  if call not in Graph:
    Graph[call] = dict([(f,{}) for f in VALID_FREQS])
  g = Graph[call]
  return g[freq]

def GrokLine(line):
  # Split into names given in the schema, the first line of the csv.
  callsign,de_pfx,de_cont,freq,band,dx,dx_pfx,dx_cont,mode,db,date,speed,tx_mode = line.split(',')
  if dx != MY_CALL: return
  f = int(float(freq))
  if f not in VALID_FREQS: return

  timestamp = ParseDateUTC(date).strftime('%Y-%m-%d-%H-%M-%S')
  print callsign, dx, line, ParseDateUTC(date), timestamp

  g = GraphFor(callsign, f)[timestamp] = int(db)  # Signal/Noise in db

for line in sys.stdin:
  line = line.strip()
  if line[0] == '(': continue  # Skip final record count lines.
  GrokLine(line)


def WriteGraphs():
  # with Full Timestamp
  for call, by_freq in Graph.items():
    for f in VALID_FREQS:
      w = open('/tmp/beacon/%s.%d.full.txt' % (call, f), 'w')
      for ts, db in sorted(by_freq.get(f, {}).items()):
        print >>w, ts, db
      w.close()
  # Daily View.
  for call, by_freq in Graph.items():
    for f in VALID_FREQS:
      w = open('/tmp/beacon/%s.%d.day.txt' % (call, f), 'w')
      for ts, db in sorted(by_freq.get(f, {}).items()):
        print >>w, '2017-08-21-' + ts[11:], db
      w.close()
  # Eclipse.
  for call, by_freq in Graph.items():
    bottom = 0
    for f in VALID_FREQS:
      bottom -= 0.4
      w = open('/tmp/beacon/%s.%d.eclipse.txt' % (call, f), 'w')
      tmp = dict()
      for ts, db in sorted(by_freq.get(f, {}).items()):
        if '2017-08-21-15-00-00' < ts < '2017-08-21-23-00-00':
          tmp[ts] = db

      CRITEREON = 15
      gap = 0
      # for h in range(15, 21):
      for h in range(15, 23):
        for m in range(60):
          ts = '2017-08-21-%02d-%02d' % (h, m)
          found = any([x.startswith(ts) for x in tmp.keys()])
	  print call, f, ts, found, gap
          if not found:
            gap += 1
          else:
            gap = 0
          if gap > CRITEREON:
            tmp[ts + '-00'] = 0
            tmp[ts + '-00'] = bottom
            gap = 0

      for ts, db in sorted(tmp.items()):
        if '2017-08-21-15-00-00' < ts < '2017-08-21-23-00-00':
          print >>w, '2017-08-21-' + ts[11:], db
      w.close()

print Graph
WriteGraphs()
