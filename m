From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 16:41:37 +0200
Message-ID: <200706151641.37788.arnd@arndb.de>
References: <20070615113919.142332000@pademelon.sonytel.be> <20070615120848.352093000@pademelon.sonytel.be> <1181918159.25228.543.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:51292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXFOOlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jun 2007 10:41:47 -0400
In-Reply-To: <1181918159.25228.543.camel@pmac.infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxppc-dev@ozlabs.org
Cc: David Woodhouse <dwmw2@infradead.org>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>

On Friday 15 June 2007, David Woodhouse wrote:
>=20
> On Fri, 2007-06-15 at 13:39 +0200, Geert Uytterhoeven wrote:
> > Add a Disk Storage Driver for the PS3:
> > =A0 - Implemented as a block device driver with a dynamic major
> > =A0 - Disk names (and partitions) are of the format ps3d%c(%u)
> > =A0 - Uses software scatter-gather with a 64 KiB bounce buffer as t=
he hypervisor
> > =A0 =A0 doesn't support scatter-gather
>=20
> Any particular reason why this is done as a separate block device dri=
ver
> rather than as SCSI?

Because the hypervisor interface is based on tranferring blocks, not ba=
sed
on SCSI commands like the one for the optical storage drive.

The first version of this driver actually was based on SCSI command emu=
lation,
and in an earlier round of reviews it was decided to rewrite it to use =
the
simpler block interface directly.

	Arnd <><
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
