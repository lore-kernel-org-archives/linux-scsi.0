From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/5] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Thu, 2 May 2013 13:41:46 +0530
Message-ID: <CALMYJDteQFvFcW3E8pXKLTigqj42fd=dwfdknE3SiG6zH9zMJQ@mail.gmail.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org> <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:54947 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3EBIMI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 May 2013 04:12:08 -0400
Received: by mail-bk0-f49.google.com with SMTP id e19so133024bku.22
        for <linux-scsi@vger.kernel.org>; Thu, 02 May 2013 01:12:06 -0700 (PDT)
In-Reply-To: <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wed, Apr 24, 2013 at 9:36 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> Move the ufshcd_hba_stop from header file.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    9 +++++++++
>  drivers/scsi/ufs/ufshcd.h |    9 ---------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 60fd40c..41b9639 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -285,6 +285,15 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_hba_stop - Send controller to reset state
> + * @hba: per adapter instance
> + */
> +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> +{
> +       writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> +}
> +
> +/**
>   * ufshcd_is_hba_active - Get controller state
>   * @hba: per adapter instance
>   *
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 6b99a42..1680394 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -190,13 +190,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
>                         unsigned int);
>  void ufshcd_remove(struct ufs_hba *);
>
> -/**
> - * ufshcd_hba_stop - Send controller to reset state
> - * @hba: per adapter instance
> - */
> -static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> -{
> -       writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> -}
> -
>  #endif /* End of Header */
> --
> 1.7.0.4
>
>

The patch doesn't apply due to the character set.

"fatal: cannot convert from ks_c_5601-1987 to UTF-8"


-- 
~Santosh
