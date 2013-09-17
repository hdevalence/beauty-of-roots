#!/usr/bin/env sage

import cPickle as pickle
from multiprocessing import Pool

def polynomial_from_integer(x,n,bits, offset):
    """
    Use the binary digits of n to construct
    a polynomial in x.
    """
    return sum([(1 if (n >> i) & 1 else -1) * x^(offset +i) for i in range(bits)])

def find_derbyshire_block(d):
    degree,x,prefix = d
    print "Finding roots for polynomials starting with: "
    print "\t%s" % str(prefix)
    roots = []
    bits = degree + 1
    for i in xrange(2^bits):
        f = prefix + polynomial_from_integer(x,i,bits,0)
        roots += f.complex_roots()
    picklename = 'pickled_roots_' + str(prefix).replace(' ','')
    print "Saving to %s" % picklename
    with open(picklename,'wb') as p:
        pickle.dump(roots, p)

def find_derbyshire(degree):
    p = Pool(4)
    x = polygen(ZZ)
    blocksize = 12
    if degree <= blocksize:
        raise ValueError
    # Get a list of prefixes
    predegbits = degree - blocksize + 1
    # We have to pack things into a tuple so that multiprocessing will work
    prefixes = [(blocksize-1,x,
                 polynomial_from_integer(x,n,predegbits,blocksize)) for n in xrange(2^predegbits)]
    p.map(find_derbyshire_block, prefixes)

if __name__=='__main__':
    import sys
    degree = int(sys.argv[1])
    print "Computing Derbyshire set for degree %d" % degree
    find_derbyshire(degree)
    

