From: Adam Kropelin <akropel1@rochester.rr.com>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Mon, 11 Aug 2003 13:41:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030811134115.A28008@mail.kroptech.com>
References: <20030806231359.A28252@mail.kroptech.com> <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local> <20030807201916.A1065@mail.kroptech.com> <20030808173003.GA3231@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roc-24-93-20-125.rochester.rr.com ([24.93.20.125]:47613 "EHLO
	mail.kroptech.com") by vger.kernel.org with ESMTP id S272972AbTHKRoo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 13:44:44 -0400
Content-Disposition: inline
In-Reply-To: <20030808173003.GA3231@kai.makisara.local>; from kai.makisara@kolumbus.fi on Fri, Aug 08, 2003 at 08:30:03PM +0300
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

[Justin Gibbs dropped from the CC: list because he probably doesn't wan=
t
this thread filling his inbox any longer...]

On Fri, Aug 08, 2003 at 08:30:03PM +0300, Kai M=E4kisara wrote:
> Thus spake Adam Kropelin (akropel1@rochester.rr.com):
>=20
> > On Fri, Aug 08, 2003 at 12:00:56AM +0300, Kai Makisara wrote:
> ...
> > I tried aic7xxx_old and hit the same BUG so Justin's driver would s=
eem
> > to be exonerated. The new backtrace is below. The commonality is cl=
early
> > the st driver and the SCSI midlayer. Perhaps I'll try to verbosify
> > things a bit in that area and see what comes up.
> >=20
> I reproduced the problem with an aha2940. The patch at the end of thi=
s
> message fixes the problem but I must think a little more before
> sending a permanent fix (at least some comments must be added).

This does indeed solve the problem on my end (tested on -test3). I'd be
happy to test any future patch you might come up with.

> This bug has been in st for quite a long time. Thanks for finally
> detecting it :-)

No problem...thanks for taking such quick action!

--Adam

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
