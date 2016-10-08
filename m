From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: replace wrong device handler name for CLARiiON
 arrays
Date: Sat, 8 Oct 2016 19:17:59 +0200
Message-ID: <612033e6-1caa-30e8-b4f2-8cf3fd5190c7@suse.de>
References: <20161007161957.6042-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56453 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757910AbcJHRSC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Oct 2016 13:18:02 -0400
In-Reply-To: <20161007161957.6042-1-xose.vazquez@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On 10/07/2016 06:19 PM, Xose Vazquez Perez wrote:
> At drivers/scsi/device_handler/scsi_dh_emc.c it was defined as:
> #define CLARIION_NAME                   "emc"
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI ML <linux-scsi@vger.kernel.org>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/scsi/scsi_dh.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 54d446c..b8d3b97 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -36,9 +36,9 @@ struct scsi_dh_blist {
>  };
>
>  static const struct scsi_dh_blist scsi_dh_blist[] = {
> -	{"DGC", "RAID",			"clariion" },
> -	{"DGC", "DISK",			"clariion" },
> -	{"DGC", "VRAID",		"clariion" },
> +	{"DGC", "RAID",			"emc" },
> +	{"DGC", "DISK",			"emc" },
> +	{"DGC", "VRAID",		"emc" },
>
>  	{"COMPAQ", "MSA1000 VOLUME",	"hp_sw" },
>  	{"COMPAQ", "HSV110",		"hp_sw" },
>
Whee. Of course.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
