
RFC_XML=   draft-banks-imap-conversations.xml

all: $(RFC_XML:.xml=.txt) $(RFC_XML:.xml=.html)

XML2RFC=    tclsh /home/gnb/software/xml2rfc-1.36/xml2rfc.tcl

%.txt: %.xml
	unset DISPLAY; $(XML2RFC) $* $< $@

%.html: %.xml
	unset DISPLAY; $(XML2RFC) $* $< $@

