From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 24/77] ncr5380: Implement NCR5380_dma_xfer_len and
 remove LIMIT_TRANSFERSIZE macro
Date: Tue, 22 Dec 2015 08:17:51 +0100
Message-ID: <5678F91F.3030306@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011744.545942658@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbbLVHRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 02:17:53 -0500
In-Reply-To: <20151222011744.545942658@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> Follow the example of the atari_NCR5380.c core driver and adopt the
> NCR5380_dma_xfer_len() hook. Implement NCR5380_dma_xfer_len() for dtc=
=2Ec
> and g_NCR5380.c to take care of the limitations of these cards. Keep =
the
> default for drivers using PSEUDO_DMA.
>
> Eliminate the unused macro LIMIT_TRANSFERSIZE.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |   32 +++++--------------------------=
-
>   drivers/scsi/arm/cumana_1.c  |    3 +++
>   drivers/scsi/arm/oak.c       |    2 ++
>   drivers/scsi/atari_NCR5380.c |    8 +++++---
>   drivers/scsi/dtc.c           |   14 ++++++++++++++
>   drivers/scsi/dtc.h           |    3 +++
>   drivers/scsi/g_NCR5380.c     |   15 +++++++++++++++
>   drivers/scsi/g_NCR5380.h     |    3 +++
>   drivers/scsi/mac_scsi.c      |    1 +
>   drivers/scsi/pas16.h         |    2 ++
>   drivers/scsi/t128.h          |    2 ++
>   11 files changed, 55 insertions(+), 30 deletions(-)
>
Hmm. I really, _really_, wish we could move away from the 'magic'=20
definitions and use a proper function template.
But maybe next time.

So:

Reviewed-by: Hannes Reinecke <hare@suse.com>

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
