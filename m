From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 48/77] atari_NCR5380: Fix queue_size limit
Date: Tue, 22 Dec 2015 08:44:03 +0100
Message-ID: <5678FF43.5050106@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011751.025473889@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151222011751.025473889@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> When a target reports a QUEUE_FULL condition it causes the driver to
> update the 'queue_size' limit with the number of currently allocated =
tags.
> At least, that's what's supposed to happen, according to the comments=
=2E
> Unfortunately the terms in the assignment are swapped. Fix this and
> cleanup some obsolete comments.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/atari_NCR5380.c |   14 ++------------
>   1 file changed, 2 insertions(+), 12 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
