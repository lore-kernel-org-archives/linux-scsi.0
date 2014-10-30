From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 17/36] dmx3191d: Use NO_IRQ
Date: Thu, 30 Oct 2014 08:38:50 +0100
Message-ID: <5451EB0A.6090102@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052611.245412218@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbaJ3Hiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 03:38:52 -0400
In-Reply-To: <20141027052611.245412218@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Testing shows that the Domex 3191D card never asserts its IRQ. Hence =
it is
> non-functional with Linux (worse, the EH bugs in the core driver are =
fatal
> but that's a problem for another patch). Perhaps the DT-536 chip need=
s
> special setup? I can't find documentation for it. The NetBSD driver u=
ses
> polling apparently because of this issue.
>=20
> Set host->irq =3D NO_IRQ so the core driver will prevent targets from
> disconnecting. Don't request host->irq.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
