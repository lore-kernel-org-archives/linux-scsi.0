From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 5/6] scsi: ufs: remove deprecated enum for hw interrupt
Date: Tue, 28 Mar 2017 22:07:46 -0700
Message-ID: <322b92e49c576c1571b648a2fbe7985f@codeaurora.org>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
 <20170328134929.25599-5-tkusumi@tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752482AbdC2FHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2017 01:07:53 -0400
In-Reply-To: <20170328134929.25599-5-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kusumi.tomohiro@gmail.com
Cc: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>, linux-scsi-owner@vger.kernel.org

On 2017-03-28 06:49, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> These flags are no longer needed after 2fbd009b in 2013.
> 
> Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 089b76f..109a762 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -143,13 +143,6 @@ enum {
>  	UFSHCD_UIC_DME_ERROR = (1 << 5), /* DME error */
>  };
> 
> -/* Interrupt configuration options */
> -enum {
> -	UFSHCD_INT_DISABLE,
> -	UFSHCD_INT_ENABLE,
> -	UFSHCD_INT_CLEAR,
> -};
> -
>  #define ufshcd_set_eh_in_progress(h) \
>  	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
>  #define ufshcd_eh_in_progress(h) \


Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
