From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/19] sd: Fix indentation
Date: Fri, 25 Aug 2017 17:50:11 +0200
Message-ID: <f2cc18a3-7f86-22ff-0e6e-abe5ce1c36d9@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-11-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42833 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933662AbdHYPuN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:50:13 -0400
In-Reply-To: <20170823214009.15015-11-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:40 PM, Bart Van Assche wrote:
> This patch avoids that smatch reports the following:
> 
> drivers/scsi/sd.c:3540: sd_suspend_common() warn: inconsistent indenting
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/sd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a88639fbedb3..8b3d7994e182 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3537,7 +3537,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
>  			 * doesn't support sync. There's not much to do and
>  			 * suspend shouldn't fail.
>  			 */
> -			 ret = 0;
> +			ret = 0;
>  		}
>  	}
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
