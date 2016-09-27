From: subhashj@codeaurora.org
Subject: Re: [PATCH] scsi: ufs: enable no vccq quirk for skhynix device
Date: Tue, 27 Sep 2016 13:09:34 -0700
Message-ID: <378bfe51eb7d16a64dc629c195dd72dc@codeaurora.org>
References: <1474901905-21551-1-git-send-email-kyuho.choi@sk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49632 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932573AbcI0UJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 16:09:36 -0400
In-Reply-To: <1474901905-21551-1-git-send-email-kyuho.choi@sk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyuho Choi <chlrbgh0@gmail.com>
Cc: vinholikatti@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Kyuho Choi <kyuho.choi@sk.com>, linux-scsi-owner@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

On 2016-09-26 07:58, Kyuho Choi wrote:
> This patch enable no vccq quirk for SKHynix devices.
> SKHynix ufs device don't need vccq vrail for device operation.
> 
> Signed-off-by: Kyuho Choi <kyuho.choi@sk.com>
> ---
>  drivers/scsi/ufs/ufs_quirks.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs_quirks.h 
> b/drivers/scsi/ufs/ufs_quirks.h
> index ee4ab85..22f881e 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -25,6 +25,7 @@
> 
>  #define UFS_VENDOR_TOSHIBA     0x198
>  #define UFS_VENDOR_SAMSUNG     0x1CE
> +#define UFS_VENDOR_SKHYNIX     0x1AD
> 
>  /**
>   * ufs_device_info - ufs device details
> @@ -145,6 +146,7 @@ static struct ufs_dev_fix ufs_fixups[] = {
>  		UFS_DEVICE_QUIRK_PA_TACTIVATE),
>  	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
>  		UFS_DEVICE_QUIRK_PA_TACTIVATE),
> +	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
> 
>  	END_FIX
>  };
