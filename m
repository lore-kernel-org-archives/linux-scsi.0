From: weiping zhang <zhangweiping@didichuxing.com>
Subject: Re: [PATCH] scsi: sd: remove duplicated setting of gd->minors
Date: Thu, 24 Aug 2017 19:57:40 +0800
Message-ID: <20170824115740.GA18246@localhost.didichuxing.com>
References: <20170818064923.GA36375@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:16245 "EHLO
        BJEXMBX011.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751285AbdHXL5t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 07:57:49 -0400
Content-Disposition: inline
In-Reply-To: <20170818064923.GA36375@localhost.didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2017 at 02:49:30PM +0800, weiping zhang wrote:
> gd->minors has been set when call alloc_disk() in sd_probe.
> 
> Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
> ---
>  drivers/scsi/sd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index bea36ad..c18ca7a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3223,7 +3223,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  
>  	gd->major = sd_major((index & 0xf0) >> 4);
>  	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
> -	gd->minors = SD_MINORS;
>  
>  	gd->fops = &sd_fops;
>  	gd->private_data = &sdkp->driver;
> -- 
> 2.9.4
> 

Hi Martin,

would you please look into this misc patch ?

Thanks
