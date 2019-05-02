From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 22/24] sr: add a SPDX tag to sr.c
Date: Thu, 2 May 2019 08:06:07 +0200
Message-ID: <8148c56e-0ba3-9871-5804-1da28759b9f8@suse.de>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-23-hch@lst.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCHZVHVFVMARBUMRVLTAKGQELDG7OPA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20190501161417.32592-23-hch-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E . J . Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org>, Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Willem Riede <osst-BKTAy3DeTVvYtjvyW6yDsg@public.gmane.org>, Doug Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, osst-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 5/1/19 6:14 PM, Christoph Hellwig wrote:
> sr.c is the only sr file missing licensing information.  Add a
> GPLv2 tag for the default kernel license.
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/scsi/sr.c | 1 +
>   1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 039c27c2d7b3..701d1e68d86e 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>   /*
>    *  sr.c Copyright (C) 1992 David Giller
>    *           Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
>=20
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG N=C3=BCrnberg)

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
