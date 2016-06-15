From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] 53c700: fix BUG on untagged commands
Date: Wed, 15 Jun 2016 08:41:05 +0200
Message-ID: <5760F881.9070108@suse.de>
References: <1465880407.18583.18.camel@linux.vnet.ibm.com>
 <20160614150555.GA698@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <20160614150555.GA698@infradead.org>
Sender: linux-parisc-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Parisc List <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/14/2016 05:05 PM, Christoph Hellwig wrote:
> Looks fine:
>=20
> Acked-by: Christoph Hellwig <hch@lst.de>
>=20
> But it should really go together with something like this:
>=20
> ---
> From e54d1462ae244db3189a8b69018bc5f3e3d3b468 Mon Sep 17 00:00:00 200=
1
> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 14 Jun 2016 17:04:10 +0200
> Subject: scsi: move current_cmnd into the 53c700 driver
>=20
> The 53c700 driver is the only user of the current_cmnd field in
> struct scsi_device, so let's move it into the driver private data.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/53c700.c      | 8 +++++---
>  drivers/scsi/53c700.h      | 1 +
>  include/scsi/scsi_device.h | 1 -
>  3 files changed, 6 insertions(+), 4 deletions(-)
>=20
Yes, please. I was wanting to get rid of the 'current_cmnd' thingie a
long time ago.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-parisc"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
