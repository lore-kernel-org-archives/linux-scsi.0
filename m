From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v8 3/8] scsi: ufs-qcom: update configuration option of
 SCSI_UFS_QCOM component
Date: Tue, 27 Oct 2015 15:03:29 -0000
Message-ID: <f78c77f3bcaecea95b6c1e58b447ef56.squirrel@www.codeaurora.org>
References: <1445770250-28802-1-git-send-email-ygardi@codeaurora.org>
    <1445770250-28802-4-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53473 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964863AbbJ0PDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2015 11:03:30 -0400
In-Reply-To: <1445770250-28802-4-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> This change is required in order to be able to build the component
> as a module.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e945383..5f45307 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -72,7 +72,7 @@ config SCSI_UFSHCD_PLATFORM
>  	  If unsure, say N.
>
>  config SCSI_UFS_QCOM
> -	bool "QCOM specific hooks to UFS controller platform driver"
> +	tristate "QCOM specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
>  	select PHY_QCOM_UFS
>  	help
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

