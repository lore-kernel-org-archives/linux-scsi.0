From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH] scsi: don't reinitialize adapter's req_table
Date: Thu, 25 Aug 2016 14:45:31 -0400
Message-ID: <a4341156-ffcb-cacc-595e-6887ed72830c@attotech.com>
References: <1471747164-31441-1-git-send-email-shawn.lin@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:40535 "EHLO
        NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751667AbcHYTDi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2016 15:03:38 -0400
In-Reply-To: <1471747164-31441-1-git-send-email-shawn.lin@rock-chips.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shawn Lin <shawn.lin@rock-chips.com>, Bradley Grove <linuxdrivers@attotech.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Acked-by: Bradley Grove <bgrove@attotech.com>

On 08/20/2016 10:39 PM, Shawn Lin wrote:
> req_table is allocate by kzalloc, so we don't need to
> zero it again anyway.
>
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> ---
>
>  drivers/scsi/esas2r/esas2r_init.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
> index 78ce4d61..d6e53ae 100644
> --- a/drivers/scsi/esas2r/esas2r_init.c
> +++ b/drivers/scsi/esas2r/esas2r_init.c
> @@ -963,10 +963,6 @@ bool esas2r_init_adapter_struct(struct esas2r_adapter *a,
>
>  	/* initialize the allocated memory */
>  	if (test_bit(AF_FIRST_INIT, &a->flags)) {
> -		memset(a->req_table, 0,
> -		       (num_requests + num_ae_requests +
> -			1) * sizeof(struct esas2r_request *));
> -
>  		esas2r_targ_db_initialize(a);
>
>  		/* prime parts of the inbound list */
>




This electronic transmission and any attachments hereto are intended only for the use of the individual or entity to which it is addressed and may contain confidential information belonging to ATTO Technology, Inc. If you have reason to believe that you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution or the taking of any action in reliance on the contents of this electronic transmission is strictly prohibited. If you have reason to believe that you have received this transmission in error, please notify ATTO immediately by return e-mail and delete and destroy this communication.   
