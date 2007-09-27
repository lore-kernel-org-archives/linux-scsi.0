From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] question on flushing buffers and spinning down
 disk
Date: Thu, 27 Sep 2007 12:01:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709271159570.7735-100000@iolanthe.rowland.org>
References: <200709271340.46496.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50979 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751118AbXI0QB4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 12:01:56 -0400
In-Reply-To: <200709271340.46496.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, 27 Sep 2007, Oliver Neukum wrote:

> Am Dienstag 25 September 2007 schrieb Alan Stern:
> > Getting all this to work will be tricky, because sd is a block devi=
ce
> > driven by requests issued through the block layer in atomic context=
,
> > whereas suspend and resume require a process context. =A0Probably t=
he=20
> > SCSI core would have to get involved in managing the synchronizatio=
n.
>=20
>=20
> Well,
>=20
> here's a patch that seems to do what needs to be done to make it work=
=2E

Oliver, I'm surprised at you!  This patch is a big hack, not to mention=
=20
a layering violation and an inversion of the proper calling sequence.

Alan Stern


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
