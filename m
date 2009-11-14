From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 7/7]MVSAS: Update to match latest libsas
Date: Sat, 14 Nov 2009 12:05:21 -0600
Message-ID: <1258221921.4070.17.camel@mulgrave.site>
References: <20091109122942.GF32336@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZKNSFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Nov 2009 13:05:23 -0500
In-Reply-To: <20091109122942.GF32336@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, qswang@marvell.com, jfeng@marvell.com

On Mon, 2009-11-09 at 20:29 +0800, Andy Yan wrote:
> From 8687e06d9f636828e006fc4938513ce4731ea356 Mon Sep 17 00:00:00 2001
> From: Andy <ayan@marvell.com>
> Date: Sun, 8 Nov 2009 14:26:39 +0800
> Subject: [PATCH 7/7] Update to match latest libsas
> 
> Signed-off-by: Andy <ayan@marvell.com>
> Signed-off-by: Jacky <jfeng@marvell.com>
> Signed-off-by: Ke <kewei@marvell.com>
> 
> ---
>  drivers/scsi/mvsas/mv_sas.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index 7ced157..51bb6fe 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -414,7 +414,7 @@ int mvs_slave_configure(struct scsi_device *sdev)
>  		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
>  	#endif
>  	} else
> -		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE);
> +		sas_change_queue_depth(sdev, MVS_QUEUE_SIZE, SCSI_QDEPTH_DEFAULT);

No.

A patch series has to be bisectable, so introduce the right signature in
patch 5 instead of introducing the wrong one and fixing it in patch 7

James


