From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Asynchronous Event Reporting
Date: Tue, 16 Apr 2002 14:59:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFDAF02D4B.E9D44720-ONC1256B9D.004734BC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Michael Heinz <mheinz@infiniconsys.com>
Cc: linux-scsi@vger.kernel.org

Hi,

is there any transfer mechanism which allows an HBA driver to push
its AER data to the mid layer?

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Michael Heinz <mheinz@infiniconsys.com>@vger.kernel.org on 04/16/2002
02:30:34 PM

Please respond to Michael Heinz <mheinz@infiniconsys.com>

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi@vger.kernel.org
cc:
Subject:    Asynchronous Event Reporting



I'd like to do a quick sanity check here...

I've been asked to make sure I support async event reporting in the
driver I'm working on (which will eventually be GPL! Honest! :-P).

 From reviewing the code in 2.4 scsi/drivers it appears that the best I
can do is log that I got the event, but then ignore it - sd.c does not
support AER.

Is this correct?

--
knock knock.

Michael Heinz <mheinz@infiniconsys.com>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
