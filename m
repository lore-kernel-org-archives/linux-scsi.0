From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] scsi: ufs: remove the duplicated checking for supporting
 clkscaling
Date: Wed, 22 Mar 2017 14:35:45 +0100
Message-ID: <10077418.cjgahspKMt@amdc3058>
References: <CGME20170321121957epcas1p3ccd834d3ac572a1858684e8ab4bb24e1@epcas1p3.samsung.com>
 <20170321121957.18655-1-jh80.chung@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:36393 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933002AbdCVNqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2017 09:46:52 -0400
In-reply-to: <20170321121957.18655-1-jh80.chung@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org


Hi,

On Tuesday, March 21, 2017 09:19:57 PM Jaehoon Chung wrote:
> There are same conditions for checking whether supporting clkscaling or
> not.
> When ufshcd is supporting clkscaling, active_reqs should be decreased by
> two.

I guess you meant "one" here, not "two"?

> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index dc6efbd..f2cbc71 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4598,8 +4598,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
>  		}
>  		if (ufshcd_is_clkscaling_supported(hba))
>  			hba->clk_scaling.active_reqs--;
> -		if (ufshcd_is_clkscaling_supported(hba))
> -			hba->clk_scaling.active_reqs--;
>  	}
>  
>  	/* clear corresponding bits of completed commands */

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
