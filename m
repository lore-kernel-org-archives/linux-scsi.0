From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Fri, 08 Aug 2003 14:21:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F3395AF.30C5CE21@fujitsu-siemens.com>
References: <64655AAA92E6ED46B9AC9421260D96A5025BD653@srmanning.lss.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:33594 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S271298AbTHHMTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 08:19:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: "jansen, frank" <jansen_frank@emc.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

"jansen, frank" wrote:

> > Without the TRESPASS, you'd see the LUN (INQUIRY), but you can't do
> > anything with it, even a simple READ CAPACITY fails.
>=20
> This is correct.  Note, that it is not necessarily desirable to TRESP=
ASS
> the LUN, as there may be an active path from the other SP to this or
> another HBA on the host system.

With MultiPath it _is_ necessary to TRESPASS a CLARiiON box if each SP
is conected to a seperate path.

--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
