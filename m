From: Zhenwen Xu <helight.xu@gmail.com>
Subject: Re: [patch for 2.6.30? 1/1] drivers/scsi/NCR_D700.c: fix IRQ
	handler return type
Date: Wed, 13 May 2009 09:09:07 +0800
Message-ID: <20090513010907.GA4067@helight>
References: <200905122048.n4CKmSw7030088@imap1.linux-foundation.org>
Reply-To: Zhenwen Xu <helight.xu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:40819 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZEMBRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2009 21:17:30 -0400
Received: by pxi29 with SMTP id 29so123010pxi.33
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2009 18:17:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <200905122048.n4CKmSw7030088@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Tue, May 12, 2009 at 01:29:13PM -0700, akpm@linux-foundation.org wrote:
> From: Zhenwen Xu <helight.xu@gmail.com>
> 
> drivers/scsi/NCR_D700.c: In function `NCR_D700_probe':
> drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type
> drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type
> drivers/scsi/NCR_D700.c:322: warning: passing argument 2 of `request_irq' from incompatible pointer type

Yes, this patch is made for 2.6.30. 
> 
> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/NCR_D700.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/NCR_D700.c~drivers-scsi-ncr_d700c-fix-irq-handler-return-type drivers/scsi/NCR_D700.c
> --- a/drivers/scsi/NCR_D700.c~drivers-scsi-ncr_d700c-fix-irq-handler-return-type
> +++ a/drivers/scsi/NCR_D700.c
> @@ -224,7 +224,7 @@ NCR_D700_probe_one(struct NCR_D700_priva
>  	return ret;
>  }
>  
> -static int
> +static irqreturn_t
>  NCR_D700_intr(int irq, void *data)
>  {
>  	struct NCR_D700_private *p = (struct NCR_D700_private *)data;
> _

-- 
--------------------------------
http://zhwen.org - Open and Free
