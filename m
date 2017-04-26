From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 3/3] scsi: ufs: Delete an unnecessary return statement in
 ufshcd_exception_event_handler()
Date: Wed, 26 Apr 2017 10:59:43 -0700
Message-ID: <6c360ac6f9b5a9a1591757a35b8d5036@codeaurora.org>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
 <9fc152fd-0881-85f6-a4d0-3db27dc364f5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9fc152fd-0881-85f6-a4d0-3db27dc364f5@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-04-25 13:30, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Tue, 25 Apr 2017 22:00:05 +0200
> 
> The script "checkpatch.pl" pointed information out like the following.
> 
> WARNING: void function return statements are not generally useful
> 
> Thus remove such a statement here.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/scsi/ufs/ufshcd.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5216e33e61a3..9018f26a5667 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4966,7 +4966,6 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
> 
>  out:
>  	pm_runtime_put_sync(hba->dev);
> -	return;
>  }
> 
>  /* Complete requests that have door-bell cleared */

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
