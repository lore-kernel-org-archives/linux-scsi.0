From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] ufs: Add missing UFS_MASK macro definition
Date: Thu, 24 Nov 2016 07:07:17 -0800
Message-ID: <a9dbd99252db26ca6a93c567d978dc2c@codeaurora.org>
References: <1479963531-6458-1-git-send-email-zhangfei.gao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966345AbcKXPHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Nov 2016 10:07:20 -0500
In-Reply-To: <1479963531-6458-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Santosh Y <santoshsy@gmail.com>

On 2016-11-23 20:58, Zhangfei Gao wrote:
> From: Santosh Y <santoshsy@gmail.com>
> 
> Reported-by: Venkatraman S <svenkatr@ti.com>
> Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Signed-off-by: Santosh Y <santoshsy@gmail.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
> 
> Find the original patch from
> http://www.spinics.net/lists/linux-scsi/msg58634.html
> 
>  drivers/scsi/ufs/ufshci.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index 9599741..bbd8df9 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -83,6 +83,8 @@ enum {
>  	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
>  };
> 
> +#define UFS_MASK(mask, offset)		((mask) << (offset))
> +
>  /* UFS Version 08h */
>  #define MINOR_VERSION_NUM_MASK		UFS_MASK(0xFFFF, 0)
>  #define MAJOR_VERSION_NUM_MASK		UFS_MASK(0xFFFF, 16)

LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
