From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: STK9840/SYM53c875 ODD transfer in DATA OUT phase
Date: Fri, 26 Sep 2003 12:20:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926102021.GA32502@chihiro.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.cern.ch ([137.138.131.164]:60871 "EHLO smtp3.cern.ch")
	by vger.kernel.org with ESMTP id S261464AbTIZKU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 06:20:28 -0400
Received: from chihiro.cern.ch (pcitadc13.cern.ch [137.138.34.18])
	by smtp3.cern.ch (8.12.1-20030924/8.12.1) with ESMTP id h8QAKOBs025836
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2003 12:20:25 +0200 (MET DST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

[ Please Cc: me as I'm not subscribed to the list.  Thanks. ]

Hello,

Since 2.4.18, we have a problem with the above combo if and only
if the transfer is odd number of bytes.  Even byte transfer works
well.  The error message we see is:

Sep 25 17:45:48 x kernel: st0: Error 70000 (sugg. bt 0x0, driver bt 0x0=
, host bt 0x7).
Sep 25 17:45:49 x kernel: sym0:0:0:extraneous data discarded.
Sep 25 17:45:49 x kernel: sym0:0:0:ODD transfer in DATA OUT phase.
Sep 25 17:45:49 x kernel: sym0:0:0:COMMAND FAILED (87 0 9).

I'm out of ideas what to try next, debugging didn't show up
anything unusual.  The same hardware works with 2.2.19.

Any ideas?

Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern.c=
h
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
