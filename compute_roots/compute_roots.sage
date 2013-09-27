#!/usr/bin/env sage
#
# A small python program to compute the roots of many polynomials
# and save them to a file.
# 
# See https://johncarlosbaez.wordpress.com/2011/12/11/the-beauty-of-roots/
#
# (C) 2013 Henry de Valence <hdevalence@hdevalence.ca>

import cPickle as pickle
from multiprocessing import Pool

# Here we just compute the polynomials whose coefficients are either
# 1 or -1, but not zero. This allows us to encode such a polynomial as
# an integer, where the digit of the binary expansion determines whether
# the coefficient is 1 or -1.

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
        # We only need to compute the roots if the last term is 1,
        # since f and -f have the same roots.
        if f.constant_coefficient() == 1:
            roots += map(complex,f.complex_roots())
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
    

