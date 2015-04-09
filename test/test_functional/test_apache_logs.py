#!/usr/bin/env python

import datetime
import random
import time

with open("/tmp/access_log", "a", 0) as fi:
  while True:

    rnd = int(random.random()*5)
    version_ = 5.0

    if rnd==0:
      bibcode = "2009AA..123..4L"
    elif rnd == 1:
      bibcode = "2010MNRAS...123..4L"
    elif rnd == 2:
      bibcode = "2011A&A...123..4L"
    elif rnd == 3:
      bibcode = "2012ApJ...123..4L"
    elif rnd == 4:
      bibcode = "2015Natur...123..4L"
    elif rnd == 5:
      bibcode = "2016Sci...123.4L"

    time.sleep(rnd)
    date_ = datetime.datetime.today().strftime("%d/%b/%Y %H:%M:%S")
    log_out = '127.0.0.1 - - [{DATE}] "GET {BIBCODE} HTTP/1.1" 200 -'.format(DATE=date_, VERSION=version_, BIBCODE=bibcode)
#    print log_out
    fi.write("{0}\n".format(log_out))
