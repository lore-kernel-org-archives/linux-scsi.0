From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v4 69/78] ncr5380: Fix whitespace in comments using
 regexp
Date: Sun, 3 Jan 2016 19:17:00 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1601031915250.30041@nippy.intranet>
References: <20160103050501.042035135@telegraphics.com.au>  <20160103050520.752909053@telegraphics.com.au> <1451807668.4334.38.camel@perches.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463806400-310644150-1451808921=:30041"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50233 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbcACIRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 03:17:39 -0500
In-Reply-To: <1451807668.4334.38.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463806400-310644150-1451808921=:30041
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Sat, 2 Jan 2016, Joe Perches wrote:

> On Sun, 2016-01-03 at 16:06 +1100, Finn Thain wrote:
> > Hanging indentation was a poor choice for the text inside comments. It
> > has been used in the wrong places and done badly elsewhere. There is
> > little consistency within any file. One fork of the core driver uses
> > tabs for this indentation while the other uses spaces. Better to use
> > flush-left alignment throughout.
> >=20
> > This patch is the result of the following substitution. It replaces tab=
s
> > and spaces at the start of a comment line with a single space.
> >=20
> > perl -i -pe 's,^(\t*[/ ]\*)[ \t]+,$1 ,' drivers/scsi/{atari_,}NCR5380.c=
=A0
> >=20
> > This removes some unimportant discrepancies between the two core driver
> > forks so that the important ones become obvious, to facilitate
> > reunification.
>=20
> I still think this patch is poor at best and
> overall not useful.

Opinions will differ.

> @@ -32,15 +32,15 @@
> > =A0/*
> > =A0 * Further development / testing that should be done :
> > =A0 * 1.=A0=A0Cleanup the NCR5380_transfer_dma function and DMA operati=
on complete
> > - *=A0=A0=A0=A0=A0code so that everything does the same thing that's do=
ne at the
> > - *=A0=A0=A0=A0=A0end of a pseudo-DMA read operation.
> > + * code so that everything does the same thing that's done at the
> > + * end of a pseudo-DMA read operation.
> > =A0 *
> > =A0 * 2.=A0=A0Fix REAL_DMA (interrupt driven, polled works fine) -
> > - *=A0=A0=A0=A0=A0basically, transfer size needs to be reduced by one
> > - *=A0=A0=A0=A0=A0and the last byte read as is done with PSEUDO_DMA.
> > + * basically, transfer size needs to be reduced by one
> > + * and the last byte read as is done with PSEUDO_DMA.
> > =A0 *
> > =A0 * 4.=A0=A0Test SCSI-II tagged queueing (I have no devices which sup=
port
> > - *=A0=A0=A0=A0=A0=A0tagged queueing)
> > + * tagged queueing)
>=20
> Numbering 1, 2, then 4 could be improved.

That would be churn. I have other plans for the To Do list. The numbering=
=20
will get fixed as items are removed.

--=20
---1463806400-310644150-1451808921=:30041--
