#!/usr/bin/env sage

# Converts pickled lists of Sage complex numbers
# to pickles of lists of Python complex numbers.
# This is because we want to use PyTables, but Sage is
# a special snowflake and needs to have its own version
# of everything, and it's a real pain to install PyTables
# for Sage.

import sys
import cPickle as pickle

for fname in sys.argv[1:]:
    print "Converting %s" % fname
    data = map(complex, pickle.load(open(fname,'rb')))
    with open('py_' + fname, 'wb') as f:
        pickle.dump(data,f)
