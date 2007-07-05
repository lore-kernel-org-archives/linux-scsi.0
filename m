From: "Lin Yu" <yulin@ustc.edu>
Subject: RE: [RFC 1/8] stex driver BROKEN
Date: Thu, 5 Jul 2007 12:12:08 -0700
Message-ID: <002701c7bf38$6699d5a0$9701a8c0@ptu.promise.com>
References: <468CF57C.60002@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.ustc.edu ([202.141.160.100]:59872 "EHLO ustc.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759628AbXGETJm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 15:09:42 -0400
In-Reply-To: <468CF57C.60002@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Boaz Harrosh' <bharrosh@panasas.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, 'FUJITA Tomonori' <fujita.tomonori@lab.ntt.co.jp>, 'Andrew Morton' <akpm@linux-foundation.org>, 'linux-scsi' <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Boaz Harrosh
> Sent: Thursday, July 05, 2007 6:43 AM
> To: James Bottomley; FUJITA Tomonori; Andrew Morton; linux-scsi
> Subject: [RFC 1/8] stex driver BROKEN
> 
> 
> 
>   I just comment out the code, but now user-mode is broken
>   what to do ??
> ---
>  drivers/scsi/stex.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index adda296..935e2a6 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -719,8 +719,8 @@ static void stex_ys_commands(struct st_hba *hba,
>  
>  	if (ccb->cmd->cmnd[0] == MGT_CMD &&
>  		resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
> -		scsi_bufflen(ccb->cmd) =
> -			le32_to_cpu(*(__le32 *)&resp->variable[0]);
> +/*		scsi_bufflen(ccb->cmd) =
> +			le32_to_cpu(*(__le32 *)&resp->variable[0]);*/
>  		return;
>  	}
>  
> -- 
> 1.5.2.2.249.g45fd
> 
> 
> -

NAK

A patch for this issue just sent.



Ed Lin
 


