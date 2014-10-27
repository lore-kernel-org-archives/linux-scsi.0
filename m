From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] ipr: Disable async aborts
Date: Mon, 27 Oct 2014 07:50:03 -0700
Message-ID: <1414421403.6401.5.camel@jarvis.lan>
References: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37677 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbaJ0OuF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2014 10:50:05 -0400
In-Reply-To: <201410271439.s9REdl9U017474@d01av02.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com

On Mon, 2014-10-27 at 09:37 -0500, Brian King wrote:
> The ipr driver does not yet support async aborts, so disable this
> for now.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

By "does not yet support" do you mean doesn't work with or merely not
tested with but seems to work OK?  if the former, then surely this
should be a fixes patch with a cc to stable for all the kernels async
abort is in (which is 3.14)

James

> ---
> 
>  drivers/scsi/ipr.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -puN drivers/scsi/ipr.c~ipr_no_async_eh drivers/scsi/ipr.c
> --- linux/drivers/scsi/ipr.c~ipr_no_async_eh	2014-10-24 08:57:53.169169509 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2014-10-24 08:57:53.175169579 -0500
> @@ -6357,6 +6357,7 @@ static struct scsi_host_template driver_
>  	.sdev_attrs = ipr_dev_attrs,
>  	.proc_name = IPR_NAME,
>  	.no_write_same = 1,
> +	.no_async_abort = 1,
>  };
>  
>  /**
> _
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


