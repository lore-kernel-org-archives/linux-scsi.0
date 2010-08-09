From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] scsi: mpt2sas: Add space in printk
Date: Mon, 9 Aug 2010 19:46:13 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB24902991CD597@inbmail02.lsi.com>
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
 <20100806075914.GS9031@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:42430 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756434Ab0HIOQh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2010 10:16:37 -0400
In-Reply-To: <20100806075914.GS9031@bicker>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>, Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>



> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Friday, August 06, 2010 1:29 PM
> To: Julia Lawall
> Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Moore, Eric;
> Desai, Kashyap
> Subject: [PATCH] scsi: mpt2sas: Add space in printk
> 
> Add a space in the output:
> old:  Discovery: (stop)discovery_status(0x%08x)
> new:  Discovery: (stop) discovery_status(0x%08x)
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This goes on top of Julia's [PATCH 9/42] drivers/scsi: Adjust
> confusing if indentation
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 12faf64..562b909 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -532,7 +532,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER
> *ioc,
>  		    (event_data->ReasonCode ==
> MPI2_EVENT_SAS_DISC_RC_STARTED) ?
>  		    "start" : "stop");
>  		if (event_data->DiscoveryStatus)
> -			printk("discovery_status(0x%08x)",
> +			printk(" discovery_status(0x%08x)",
I don't see any significant reason for changing print. It not adding any benefit.
Thanks, Kashyap
>  			    le32_to_cpu(event_data->DiscoveryStatus));
>  		printk("\n");
>  		return;
