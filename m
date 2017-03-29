From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 2/6] scsi: ufs: use existing macro CONTROLLER_ENABLE to
 test register bit
Date: Tue, 28 Mar 2017 22:02:53 -0700
Message-ID: <4876fb0f3b1539f140d29c8af6e06c52@codeaurora.org>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
 <20170328134929.25599-2-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752630AbdC2FDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 01:03:10 -0400
In-Reply-To: <20170328134929.25599-2-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>, linux-scsi-owner@vger.kernel.org

On 2017-03-28 06:49, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> (Note this commit directly goes on top of the previous one)
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b006f1e..dd46259 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -836,7 +836,8 @@ static inline void ufshcd_hba_start(struct ufs_hba 
> *hba)
>   */
>  static inline bool ufshcd_is_hba_active(struct ufs_hba *hba)
>  {
> -	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? false : 
> true;
> +	return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & CONTROLLER_ENABLE)
> +		? false : true;
>  }
> 
>  static const char *ufschd_uic_link_state_to_string(

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
