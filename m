From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: fix wrong/ambiguous fall through comments
Date: Fri, 24 Mar 2017 16:21:13 -0700
Message-ID: <59298e05e511ed5860e07e48fc55f173@codeaurora.org>
References: <20170323104904.47040-1-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934479AbdCXXVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 19:21:15 -0400
In-Reply-To: <20170323104904.47040-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>, linux-scsi-owner@vger.kernel.org

On 2017-03-23 03:49, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> These aren't really falling through to anywhere meaningful.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dc6efbd..b7e5128 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -553,15 +553,14 @@ static inline u32 ufshcd_get_intr_mask(struct
> ufs_hba *hba)
>  	case UFSHCI_VERSION_10:
>  		intr_mask = INTERRUPT_MASK_ALL_VER_10;
>  		break;
> -	/* allow fall through */
>  	case UFSHCI_VERSION_11:
>  	case UFSHCI_VERSION_20:
>  		intr_mask = INTERRUPT_MASK_ALL_VER_11;
>  		break;
> -	/* allow fall through */
>  	case UFSHCI_VERSION_21:
>  	default:
>  		intr_mask = INTERRUPT_MASK_ALL_VER_21;
> +		break;
>  	}
> 
>  	return intr_mask;

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
