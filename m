From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] newline in iscsi printk
Date: Thu, 30 Nov 2006 06:04:24 -0600
Message-ID: <456EC8C8.8070206@cs.wisc.edu>
References: <Pine.SOC.4.61.0611301336530.23558@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42676 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030905AbWK3SEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Nov 2006 13:04:30 -0500
In-Reply-To: <Pine.SOC.4.61.0611301336530.23558@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org, open-iscsi <open-iscsi@googlegroups.com>

Meelis Roos wrote:
> This patch against 2.6.19 cures two runtogether printk messages in iSCSI 
> driver.
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 9b25124..2648dbd 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1414,7 +1414,7 @@ static __init int iscsi_transport_init(void)
>  {
>  	int err;
>  
> -	printk(KERN_INFO "Loading iSCSI transport class v%s.",
> +	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
>  		ISCSI_TRANSPORT_VERSION);
>  
>  	err = class_register(&iscsi_transport_class);
> 

ACK.

If James does not pick this up, then I will put it in my patchset.
Thanks for the patch.
