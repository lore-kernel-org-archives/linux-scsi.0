From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Fri, 08 Aug 2003 15:27:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F33A536.F0C3F1C5@fujitsu-siemens.com>
References: <64655AAA92E6ED46B9AC9421260D96A5025BD654@srmanning.lss.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:19762 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S271337AbTHHNZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 09:25:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: "jansen, frank" <jansen_frank@emc.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

"jansen, frank" wrote:
>=20
> > Josef M=F6llers wrote
> >
> > With MultiPath it _is_ necessary to TRESPASS a CLARiiON box if each=
 SP
> > is conected to a seperate path.
> >
> To access the non-active path, this is correct.  What I was trying to=
 say
> is that the MultiPath layer should be somewhat intelligent about this=
 and
> be aware that there may be another active path.  It is much quicker t=
o go
> down an active path than trespass a LUN and then do the I/O.  The oth=
er
> part is the risk of excessive trespassing, where a LUN just gets boun=
ced
> back and forth between SPs for each I/O; this is an absolute worst ca=
se
> that would bring performance to a standstill.

Obviously.
What we did was to do a TRESPASS only if a command failed with certain
sense data:
ILLEGAL REQUEST, LUN NOT READY, CAUSE NOT REPORTABLE.

Have a nice weekend
--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
