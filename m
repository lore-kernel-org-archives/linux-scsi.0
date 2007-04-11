From: Martin Geier <linux-scsi@ml.martin.geweb.net>
Subject: Re: SCSI breakage on PowerMac 9500 (oldworld) between 2.6.19.7 and 2.6.20
Date: Wed, 11 Apr 2007 03:08:50 +0200
Message-ID: <20070411010850.GA27421@galaxy.int.geweb.net>
References: <20070410221217.GA21776@galaxy.int.geweb.net> <20070410155359.cf82f5ea.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bigmac.geweb.net ([217.197.85.170]:4569 "EHLO bigmac.geweb.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161157AbXDKBJA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Apr 2007 21:09:00 -0400
Content-Disposition: inline
In-Reply-To: <20070410155359.cf82f5ea.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi@vger.kernel.org

Hi

On Tue, Apr 10, 2007 at 03:53:59PM -0700, Randy Dunlap wrote:
> On Wed, 11 Apr 2007 00:12:17 +0200 Martin Geier wrote:
(..)
> > Maybe it's connected to http://marc.info/?l=3Dlinux-scsi&m=3D117596=
425706527&w=3D2
> > but my test of 2.6.21-rc5 failed similarly to the test of 2.6.20.
(..)
> There was a similar report for the imm driver, with a follow-up
> report that 2.6.21-rc5 works.  Could you test 2.6.21-rc6?
I think I saw that one (in case you mean the one mentioned above).
rc5 (*) didn't work, but fortunately rc6 does work. Do you have any
idea which commit fixed this (and if I can apply it against 2.6.20.6)?

Martin

*)
http://www.de.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.21-rc5=
=2Etar.bz2
vs.
http://www.de.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.21-rc6=
=2Etar.bz2


--=20
 /=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=
=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=
=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF=AF\=20
| PGP-Key 0x0F10B493 available via www.de.pgp.net, see header for fpr |
 \___________________________________________________________________/=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
