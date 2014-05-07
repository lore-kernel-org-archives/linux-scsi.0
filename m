From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 7 May 2014 09:47:57 -0400
Message-ID: <20140507134757.GC12826@phenom.dumpdata.com>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46494 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbaEGNtv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2014 09:49:51 -0400
Content-Disposition: inline
In-Reply-To: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, michaelc@cs.wisc.edu, pjones@redhat.com, konrad@kernel.org, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, iscsi-driver@qlogic.com

On Wed, May 07, 2014 at 05:00:20AM -0400, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".

Why? If it uses the standard iBFT format why does it use
a non-standard signature?

> This patch modifies the ibft search code to search for "BIFT" along
> with the other possible values.
> 
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> Acked-by: Kevin Tran <ktran@broadcom.com>
> Acked-by: Eddie Wai <eddie.wai@broadcom.com>
> ---
>  drivers/firmware/iscsi_ibft.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> index 3ee852c..071c2c9 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -756,6 +756,7 @@ static const struct {
>  	 */
>  	{ ACPI_SIG_IBFT },
>  	{ "iBFT" },
> +	{ "BIFT" },	/* Broadcom iSCSI Offload */
>  };
>  
>  static void __init acpi_find_ibft_region(void)
> -- 
> 1.8.2.GIT
> 
