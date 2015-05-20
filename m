From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v1 3/3] scsi: ufs-qcom: update configuration option of
 SCSI_UFS_QCOM component
Date: Wed, 20 May 2015 09:21:19 +0200
Message-ID: <1432106479.21715.33.camel@x220>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
	 <1432043231-31102-4-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1432043231-31102-4-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-19 at 16:47 +0300, Yaniv Gardi wrote:
> This change is required in order to be able to build the component
> as a module.
> 
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
 
>  config SCSI_UFS_QCOM
> -	bool "QCOM specific hooks to UFS controller platform driver"
> +	tristate "QCOM specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
>  	select PHY_QCOM_UFS
>  	help

As far as I can see, in next-20150519, drivers/scsi/ufs/ufs-qcom.c lacks
the required module specific boilerplate for this to be useful. Is that
boilerplate added in another series?

Thanks,


Paul Bolle
