From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: remove the duplicated checking for supporting
 clkscaling
Date: Fri, 24 Mar 2017 16:19:07 -0700
Message-ID: <dd298f19613023950555d2742d0d4014@codeaurora.org>
References: <CGME20170321121957epcas1p3ccd834d3ac572a1858684e8ab4bb24e1@epcas1p3.samsung.com>
 <20170321121957.18655-1-jh80.chung@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39332 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdCXXTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2017 19:19:10 -0400
In-Reply-To: <20170321121957.18655-1-jh80.chung@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-03-21 05:19, Jaehoon Chung wrote:
> There are same conditions for checking whether supporting clkscaling or
> not.
> When ufshcd is supporting clkscaling, active_reqs should be decreased 
> by
> two.
> 
> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dc6efbd..f2cbc71 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4598,8 +4598,6 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>  		}
>  		if (ufshcd_is_clkscaling_supported(hba))
>  			hba->clk_scaling.active_reqs--;
> -		if (ufshcd_is_clkscaling_supported(hba))
> -			hba->clk_scaling.active_reqs--;
>  	}
> 
>  	/* clear corresponding bits of completed commands */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
