From: Martin Geier <linux-scsi@ml.martin.geweb.net>
Subject: Re: SCSI breakage on PowerMac 9500 (oldworld) between 2.6.19.7 and 2.6.20
Date: Wed, 11 Apr 2007 23:45:45 +0200
Message-ID: <20070411214545.GA18404@galaxy.int.geweb.net>
References: <20070410221217.GA21776@galaxy.int.geweb.net> <20070410155359.cf82f5ea.randy.dunlap@oracle.com> <20070411010850.GA27421@galaxy.int.geweb.net> <20070410191534.9b443b71.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bigmac.geweb.net ([217.197.85.170]:4493 "EHLO bigmac.geweb.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161257AbXDKVps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2007 17:45:48 -0400
Content-Disposition: inline
In-Reply-To: <20070410191534.9b443b71.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi@vger.kernel.org, davem@davemloft.net

Hi Randy, hi David, hi all

On Tue, Apr 10, 2007 at 07:15:34PM -0700, Randy Dunlap wrote:
> On Wed, 11 Apr 2007 03:08:50 +0200 Martin Geier wrote:
> > I think I saw that one (in case you mean the one mentioned above).
> > rc5 (*) didn't work, but fortunately rc6 does work. Do you have any
> > idea which commit fixed this (and if I can apply it against 2.6.20.=
6)?
> No, sorry, I don't know what patch fixes it.  I just know that I can
> reproduce the failure + fix using the imm driver.
Ok, I think I got it: 2.6.20.6 (current -stable) patched with git-commi=
t
8cc574a3c5cea70229f243a6b57fd69e60491d82 (see * for full link) works. S=
o
apparently this commit fixed more than it originally was tought of (I
added David S. Miller, the committer of the patch, to CC).

Martin

*)
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commitdiff_plain;h=3D8cc574a3c5cea70229f243a6b57fd69e60491d82

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
