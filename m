From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 2/2] qedi: Remove WARN_ON from clear task context.
Date: Fri, 16 Jun 2017 11:46:07 -0700
Message-ID: <d2bb982f-211b-17df-bdee-d101c73c8846@suse.com>
References: <20170615071040.18093-1-manish.rangankar@cavium.com>
 <20170615071040.18093-3-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55059 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750792AbdFPSqM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 14:46:12 -0400
In-Reply-To: <20170615071040.18093-3-manish.rangankar@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>, martin.petersen@oracle.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On 06/15/2017 12:10 AM, Manish Rangankar wrote:
> Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index 09a2946..879d3b7 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1499,11 +1499,9 @@ int qedi_get_task_idx(struct qedi_ctx *qedi)
>  
>  void qedi_clear_task_idx(struct qedi_ctx *qedi, int idx)
>  {
> -	if (!test_and_clear_bit(idx, qedi->task_idx_map)) {
> +	if (!test_and_clear_bit(idx, qedi->task_idx_map))
>  		QEDI_ERR(&qedi->dbg_ctx,
>  			 "FW task context, already cleared, tid=0x%x\n", idx);
> -		WARN_ON(1);
> -	}
>  }
>  
>  void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
