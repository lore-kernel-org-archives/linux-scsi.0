From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 1/2] qedi: Remove WARN_ON for untracked cleanup.
Date: Fri, 16 Jun 2017 11:45:39 -0700
Message-ID: <9af8b0f4-7dc1-0a39-6958-a8dcecf3e2fb@suse.com>
References: <20170615071040.18093-1-manish.rangankar@cavium.com>
 <20170615071040.18093-2-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54999 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750797AbdFPSpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 14:45:45 -0400
In-Reply-To: <20170615071040.18093-2-manish.rangankar@cavium.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manish Rangankar <manish.rangankar@cavium.com>, martin.petersen@oracle.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

On 06/15/2017 12:10 AM, Manish Rangankar wrote:
> Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 8bc7ee1..507512c 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -870,7 +870,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
>  		QEDI_ERR(&qedi->dbg_ctx,
>  			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
>  			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
> -		WARN_ON(1);
>  	}
>  }
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
