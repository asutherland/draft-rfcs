# IMAP4 Extension for Handling Conversations #

## Introduction ##

A server advertising the XCONVERSATIONS capability tracks conversation
(i.e. message threading)  information automatically and persistently,
and provides ways for a client to present to users both complete new
views and efficient updates to existing views of conversations.

## Conventions Used in This Document ##

In examples, "C:" and "S:" indicate lines sent by the client and server,
respectively.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in RFC 2119 [KEYWORDS](#KEYWORDS).

## Data Model ##

### Conversations ###

flat/treeless
persistent
server-side

### Conversation Scope ###

### CIDs ###

### ModSeqs ###

### Inserting a New Message ###

When a message arrives in the server via any means, the server MUST associate
the message with a conversation.  This process includes the following steps.

* The server parses the message to discover the values of certain header
  fields.  The exact algorithm is used to decide whether a message
  belongs to a conversation is not specified here, but a server SHOULD
  use some combination of the Message-Id, In-Reply-To, References, and
  Subject header fields.

* The server uses those values to look up zero or more existing conversations
  and chooses one conversation to which the message will be added.
  TODO: scope of this lookup

    * If zero existing conversations were found, the server creates a new
      conversation and uses that.

    * If one existing conversation was found, the uses that conversation.

    * If two or more existing conversations were found, the server merges
      the conversations (see [Conversation Merging](#Conversation_Merging))
      to create a single resulting conversation and uses that.

* The server sets the message's CID attribute to the CID of the chosen
  conversation, and updates the conversation state to account for the
  message.

### Conversation Merging ###

## IMAP Protocol Changes ##

### General Considerations ###

### New Message Data Items in FETCH Command ###
### New Message Data Items in FETCH Response ###

### Interaction with Message Delivery ###

When a message arrives in the server via any local delivery mechanism
(i.e. not via the IMAP protocol), the server MUST associate the message
with a conversation as described in
[Inserting a New Message](#Inserting_a_New_Message).

### Interaction with COPY ###

When a message is added to a folder using the COPY command, the
server MUST associate the message with a conversation as described in
[Inserting a New Message](#Inserting_a_New_Message).

Note that if a message is copied to a folder in the same conversation
scope as the original folder, the new message SHOULD end up in the
same conversation as the original.

TODO: exception: the server MAY split conversations which are too large

### Interaction with APPEND ###

When a message is added to the server using the APPEND command, the
server MUST associate the message with a conversation as described in
[Inserting a New Message](#Inserting_a_New_Message).

### Interaction with XMOVE ###

When a message is moved from one folder to another folder in the same
conversation scope using the extension XMOVE command, the server MUST
preserve the association between the message and it's conversation.

When a message is moved from one folder to a folder in a different
conversation scope using the extension XMOVE command, the server MUST
drop any association between the message and a conversation and
associate the message with a conversation in the new scope as described in
[Inserting a New Message](#Inserting_a_New_Message).


### Interaction with EXPUNGE ###
### Interaction with RENAME ###
### Interaction with DELETE ###
### Interaction with STORE ###

### New Criteria in SEARCH ###
### New Keys in SORT ###
### New Items in STATUS ###

### New Command XCONVMETA ###
### New Command XCONVFETCH ###
### New Command XCONVSORT ###
### New Command XCONVUPDATES ###

## Formal Syntax ##

The following syntax specification uses the Augmented Backus-Naur
Form (ABNF) notation as specified in [ABNF](#ABNF).

Non-terminals referenced but not defined below are as defined by
[IMAP4](#IMAP4), or [IMAPABNF](#IMAPABNF).

Except as noted otherwise, all alphabetic characters are case-
insensitive.  The use of upper or lowercase characters to define
token strings is for editorial clarity only.  Implementations MUST
accept these strings in a case-insensitive fashion.

    capability =/ "XCONVERSATIONS"

    command-auth =/ convfetch / convmeta

    command-select =/ convsort / convupdates

    convsort = "XCONVSORT" SP sort-criteria
	       [SP convsort-windowargs] SP search-criteria
	;; sort-criteria defined in RFC5256
	;; search-criteria defined in RFC5256, includes initial charset

    convsort-windowargs = '(' convsort-windowarg (SP convsort-windowarg)* ')'

    convsort-windowarg = "CONVERSATIONS" /
			 "POSITION" SP '(' nz-number SP number ')' /
			    ;; position     limit
			 "ANCHOR" SP '(' uniqueid SP number SP number ')'
			    ;;           anchor       offset    limit

    convupdates = "XCONVUPDATES" SP sort-criteria
		   SP convupdates-windowargs SP search-criteria
	;; sort-criteria defined in RFC5256
	;; search-criteria defined in RFC5256, includes initial charset

    convupdates-windowargs = '(' convupdates-windowarg (SP convupdates-windowarg)* ')'

    convupdates-windowarg = "CONVERSATIONS" /
			    "CHANGEDSINCE" SP '(' mod-sequence-value SP uniqueid ')' /
				;;                highestmodseq         uidnext
			    "UPTO" SP '(' uniqueid ')'
	;; mod-sequence-value is defined in RFC4551
	;; number and nz-number are defined in RFC3501

Note: CHANGEDSINCE is mandatory for xconvupdates




## Security Considerations ##

## IANA Considerations ##

## Normative References ##

[KEYWORDS]
:   Bradner, S., "Key words for use in RFCs to Indicate
    Requirement Levels", BCP 14, RFC 2119, March 1997.

[IMAP4]
:   Crispin, M., "INTERNET MESSAGE ACCESS PROTOCOL - VERSION
    4rev1", RFC 3501, March 2003.

[ABNF]
:   Crocker, D. (Ed.) and P. Overell, "Augmented BNF for
    Syntax Specifications: ABNF", RFC 4234, October 2005.

[IMAPABNF]
:   Melnikov, A. and C. Daboo, "Collected Extensions to IMAP4
    ABNF", RFC 4466, April 2006.

[SORT]
:   Crispin, M. and K. Murchison, "Internet Message Access
    Protocol - SORT and THREAD Extensions", RFC 5256, June 2008.

[CONDSTORE]
:   Melnikov, A. and S. Hole, "IMAP Extension for Conditional
    STORE", RFC 4551, June 2006.

TODO: RFC5322

## Acknowledgements ##

Author's Addresses


Greg Banks
Opera Software Australia Pty Ltd
Level 1, 91 William St
Melbourne 3000
Australia

Email: gnb@opera.com


