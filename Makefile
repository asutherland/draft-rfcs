
RFC_XML=   draft-banks-imap-conversations.xml

XML2RFC_DIR=    /home/gnb/software/xml2rfc-1.36
XML2RFC=	tclsh $(XML2RFC_DIR)/xml2rfc.tcl

all: validate $(RFC_XML:.xml=.txt) $(RFC_XML:.xml=.html)

validate:
	@for rfc in $(RFC_XML) ; do \
	    xmllint  --valid --path $(XML2RFC_DIR) --noout $$rfc || exit 1;\
	done

%.txt: %.xml
	unset DISPLAY; $(XML2RFC) $* $< $@

%.html: %.xml
	unset DISPLAY; $(XML2RFC) $* $< $@

