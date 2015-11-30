From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: ufs: fix spelling mistake in error message
Date: Mon, 30 Nov 2015 06:46:38 +0000
Message-ID: <20151130064638.581010d73g7xidam@imap.suse.de>
References: <1448728436-9058-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448728436-9058-1-git-send-email-colin.king@canonical.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Zitat von Colin King <colin.king@canonical.com>:

> From: Colin Ian King <colin.king@canonical.com>
>
> Minor issue, fix spelling mistake, Intialization -> Initialization
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c  
> b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index 9714f2a..d2a7b12 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -333,7 +333,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
>
>  	err = ufshcd_init(hba, mmio_base, irq);
>  	if (err) {
> -		dev_err(dev, "Intialization failed\n");
> +		dev_err(dev, "Initialization failed\n");
>  		goto out_disable_rpm;
>  	}
>
> --
> 2.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse>
