From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 3/6] scsi: ufs: non functional macro fix
Date: Tue, 28 Mar 2017 22:03:38 -0700
Message-ID: <0b75f41bc06b3403de05829d0a5e1405@codeaurora.org>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
 <20170328134929.25599-3-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdC2FEJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 01:04:09 -0400
In-Reply-To: <20170328134929.25599-3-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>, linux-scsi-owner@vger.kernel.org

On 2017-03-28 06:49, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> Not having () isn't likely to do any harm in this case, but all the
> other macros below do have it. Also add "are" in a comment.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dd46259..089b76f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -151,11 +151,11 @@ enum {
>  };
> 
>  #define ufshcd_set_eh_in_progress(h) \
> -	(h->eh_flags |= UFSHCD_EH_IN_PROGRESS)
> +	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
>  #define ufshcd_eh_in_progress(h) \
> -	(h->eh_flags & UFSHCD_EH_IN_PROGRESS)
> +	((h)->eh_flags & UFSHCD_EH_IN_PROGRESS)
>  #define ufshcd_clear_eh_in_progress(h) \
> -	(h->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
> +	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
> 
>  #define ufshcd_set_ufs_dev_active(h) \
>  	((h)->curr_dev_pwr_mode = UFS_ACTIVE_PWR_MODE)
> @@ -1491,7 +1491,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  			break;
>  		}
>  		/*
> -		 * If we here, it means gating work is either done or
> +		 * If we are here, it means gating work is either done or
>  		 * currently running. Hence, fall through to cancel gating
>  		 * work and to enable clocks.
>  		 */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
