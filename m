From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/71] ncr5380: Simplify bus reset handlers
Date: Thu, 19 Nov 2015 14:56:21 +0100
Message-ID: <564DD505.3050502@suse.de>
References: <20151118083455.331768508@telegraphics.com.au> <20151118083458.141699017@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbbKSN4X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 08:56:23 -0500
In-Reply-To: <20151118083458.141699017@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/18/2015 09:35 AM, Finn Thain wrote:
> Make use of do_reset() in the bus reset handler in atari_NCR5380.c. T=
he
> version in NCR5380.c already does so. Keep them in sync.
>=20
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>=20
> ---
>=20
> Bus reset handlers in both core drivers still have serious problems f=
or
> EH purposes. Those problems are addressed later in this series.
>=20
> ---
>  drivers/scsi/NCR5380.c       |   20 +++++++++++---------
>  drivers/scsi/atari_NCR5380.c |   30 ++++++++++++------------------
>  2 files changed, 23 insertions(+), 27 deletions(-)
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
