From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi_debug: Error message should say scsi_host_alloc
 not scsi_register
Date: Fri, 03 Oct 2014 12:02:36 -0400
Message-ID: <542EC89C.5030708@interlog.com>
References: <alpine.LNX.2.00.1410011653220.25690@nippy.intranet>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49819 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbaJCQC5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2014 12:02:57 -0400
In-Reply-To: <alpine.LNX.2.00.1410011653220.25690@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org

On 14-10-02 09:43 PM, Finn Thain wrote:
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux/drivers/scsi/scsi_debug.c
> ===================================================================
> --- linux.orig/drivers/scsi/scsi_debug.c	2014-09-29 10:55:44.000000000 +1000
> +++ linux/drivers/scsi/scsi_debug.c	2014-10-01 16:33:23.000000000 +1000
> @@ -3967,7 +3967,7 @@ static int sdebug_driver_probe(struct de
>   		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
>   	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
>   	if (NULL == hpnt) {
> -		printk(KERN_ERR "%s: scsi_register failed\n", __func__);
> +		pr_err("%s: scsi_host_alloc failed\n", __func__);
>   		error = -ENODEV;
>   		return error;
>   	}
> --


