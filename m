From: Josef =?iso-8859-1?Q?M=F6llers?=
	<josef.moellers@fujitsu-siemens.com>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Fri, 08 Aug 2003 08:45:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F3346EE.B98B35D2@fujitsu-siemens.com>
References: <1060042082.1985.53.camel@fuzzy> <20030807172028.A13400@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plam.fujitsu-siemens.com ([217.115.66.9]:61493 "EHLO
	plam.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S271343AbTHHGoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 02:44:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:

> > 4. Configuration of this solution would be extremely important.  Th=
e
> > idea here is to rely on the udev solution currently making its way =
into
> > the kernel and essentially have a vendor specific multi-path
> > configuration as a udev plug-in.
> >
> > 5. Vendor value add for specific devices could be encoded both as
> > configuration (udev) pieces and plug-ins to the upper layer multi-p=
ath
> > driver to activate any proprietary vendor specific configuration op=
tions
> > that may be needed for specific solutions.
>=20
> What are examples of such value add?

Some older EMC RAID boxes need a special "TRESPASS" command (implemente=
d
as a MODE SELECT) to switch the ownership of a LUN from one path
("Storage Processor") to the other. The newer ones do this
automatically, though.
Without the TRESPASS, you'd see the LUN (INQUIRY), but you can't do
anything with it, even a simple READ CAPACITY fails.
--=20
Josef M=F6llers (Pinguinpfleger bei FSC)
	If failure had no penalty success would not be a prize
						-- T.  Pratchett
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
