From: ygardi@codeaurora.org
Subject: Re: [PATCH] ufs-qcom: Switch dependency to ARCH_QCOM
Date: Tue, 12 May 2015 07:05:24 -0000
Message-ID: <1730be19bac4946d9c15fa7c99cfbbc0.squirrel@www.codeaurora.org>
References: <1428707466-24526-5-git-send-email-sboyd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428707466-24526-5-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, Yaniv Gardi <ygardi@codeaurora.org>, Dov Levenglick <dovl@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, David Brown <davidb@codeaurora.org>, Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
List-Id: linux-scsi@vger.kernel.org

looks good.

Acked-by: Yaniv Gardi <ygardi@codeaurora.org>


> This device only exists on platforms under ARCH_QCOM, not
> ARCH_MSM.
>
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Dov Levenglick <dovl@codeaurora.org>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: Bryan Huntsman <bryanh@codeaurora.org>
> Cc: Daniel Walker <dwalker@fifo99.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/scsi/ufs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 8a1f4b355416..e94538362536 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -73,7 +73,7 @@ config SCSI_UFSHCD_PLATFORM
>
>  config SCSI_UFS_QCOM
>  	bool "QCOM specific hooks to UFS controller platform driver"
> -	depends on SCSI_UFSHCD_PLATFORM && ARCH_MSM
> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
>  	select PHY_QCOM_UFS
>  	help
>  	  This selects the QCOM specific additions to UFSHCD platform driver.
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
