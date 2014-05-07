From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Wed, 07 May 2014 14:01:48 -0500
Message-ID: <536A831C.4060307@cs.wisc.edu>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36814 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaEGTCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 15:02:15 -0400
In-Reply-To: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, pjones@redhat.com, konrad@kernel.org, linux-scsi@vger.kernel.org, giridhar.malavali@qlogic.com, iscsi-driver@qlogic.com

On 05/07/2014 04:00 AM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> 
> Broadcom iscsi offload firmware uses a non standard ibft sign of "BIFT".
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
> 

Patch looks ok to me.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
