From: "jansen, frank" <jansen_frank@emc.com>
Subject: RE: Summary of the Multi-Path BOF at OLS and future directions
Date: Fri, 8 Aug 2003 08:28:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <64655AAA92E6ED46B9AC9421260D96A5025BD654@srmanning.lss.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [168.159.100.12] ([168.159.100.12]:54800 "EHLO
	mercury.eng.emc.com") by vger.kernel.org with ESMTP id S271298AbTHHM2e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2003 08:28:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?=27Josef_M=F6llers=27?= <josef.moellers@fujitsu-siemens.com>, "jansen, frank" <jansen_frank@emc.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> Josef M=F6llers wrote
>=20
> With MultiPath it _is_ necessary to TRESPASS a CLARiiON box if each S=
P
> is conected to a seperate path.
>=20
To access the non-active path, this is correct.  What I was trying to s=
ay
is that the MultiPath layer should be somewhat intelligent about this a=
nd
be aware that there may be another active path.  It is much quicker to =
go
down an active path than trespass a LUN and then do the I/O.  The other
part is the risk of excessive trespassing, where a LUN just gets bounce=
d
back and forth between SPs for each I/O; this is an absolute worst case=
=20
that would bring performance to a standstill.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
