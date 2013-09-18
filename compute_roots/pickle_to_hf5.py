#!/usr/bin/python2

# Loads pickled data into PyTables.

import sys
from tables import *
import cPickle as pickle

class Root(IsDescription):
    re = FloatCol()
    im = FloatCol()

def load_pickle_to_table(filename,table):
    """
    Load a pickle containing a list of complex numbers,
    then convert them all to Root objects and store them in the table.
    """
    print 'Loading file %s' % filename
    # Load pickle and convert to Python complex type
    data = pickle.load(open(filename,'rb'))
    root = table.row
    for c in data:
        root['re'] = c.real
        root['im'] = c.imag
        root.append()

if __name__=='__main__':
    filename = sys.argv[1]
    h5file = open_file(filename, mode='w', title='Beauty of Roots data')
    group = h5file.create_group('/', 'roots', 'Root data')
    table = h5file.create_table(group,'roots', Root, 'Root data')

    for filename in sys.argv[2:]:
        load_pickle_to_table(filename, table)
    h5file.close()

