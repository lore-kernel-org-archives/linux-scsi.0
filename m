From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 13/36] ncr5380: Move static PDMA spin counters to host
 data
Date: Thu, 30 Oct 2014 08:31:00 +0100
Message-ID: <5451E934.6010902@suse.de>
References: <20141027052607.105914311@telegraphics.com.au> <20141027052610.275439151@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaJ3HbC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 03:31:02 -0400
In-Reply-To: <20141027052610.275439151@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

On 10/27/2014 06:26 AM, Finn Thain wrote:
> Static variables from dtc.c and pas16.c should not appear in the core
> NCR5380.c driver. Aside from being a layering issue this worsens the
> divergence between the three core driver variants (atari_NCR5380.c an=
d
> sun3_NCR5380.c don't support PSEUDO_DMA) and it can mean multiple hos=
ts
> share the same counters.
>=20
> Fix this by making the pseudo DMA spin counters in the core more gene=
ric.
> This also avoids the abuse of the {DTC,PAS16}_PUBLIC_RELEASE macros, =
so
> they can be removed.
>=20
> oak.c doesn't use PDMA and hence it doesn't use the counters and henc=
e it
> needs no write_info() method. Remove it.
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
