#! /usr/bin/python

from pybtex.database.input import bibtex

import sys
import os


if (len(sys.argv) < 3):
    print "please specify the bib file and the format file:-)"
    sys.exit(0)

bib_file=sys.argv[1]
format_file = sys.argv[2]

if not os.path.isfile(bib_file):
    print "bib file does not exist :-)"
    sys.exit(0)

if not os.path.isfile(format_file):
    print "bib format does not exist :-)"
    sys.exit(0)


parser = bibtex.Parser()
bib_data = parser.parse_file(bib_file)

#for entry in bib_data.entries.keys():
#    print '<cite>'+ bib_data.entries[entry].fields['journal']+'</cite>'


bibformat = open(format_file,'rb')


formatstr = str(bibformat.read())




for eindex in bib_data.entries.keys():
    formattmp = formatstr
    for findex in bib_data.entries[eindex].fields.keys():
        field = bib_data.entries[eindex].fields[findex]
        formattmp = formattmp.replace(findex,field)
    persons = bib_data.entries[eindex].persons['author']
    authors = ""
    if len(persons) > 0:
        p = persons.pop()
        authors = authors + p.last().pop() + " " + p.first().pop()
    for p in persons:
        authors = authors + ", "
        authors = authors + p.last().pop() + " " + p.first().pop()

    formattmp = formattmp.replace('author',authors)
#    print authors
    print formattmp
        
# The element 'author' is not included in the keys() of the fields.
# So it should be added individually.


