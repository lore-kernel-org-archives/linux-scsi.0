From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] lpfc: fix compile error when CONFIG_NVME_TARGET_FC not
 enabled
Date: Thu, 27 Apr 2017 13:40:05 -0600
Message-ID: <45c01ad4-5241-bb9f-1d0a-7749ae6ca5d9@kernel.dk>
References: <20170427193547.21553-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:33145 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164165AbdD0TkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2017 15:40:07 -0400
Received: by mail-it0-f50.google.com with SMTP id 70so5694925ita.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2017 12:40:07 -0700 (PDT)
In-Reply-To: <20170427193547.21553-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 04/27/2017 01:35 PM, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> fix compile error when CONFIG_NVME_TARGET_FC not enabled
> 
> return statement needs to be outside of ifdef
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
> Patch to be pulled in via block trees
> 
> Patch cut against nvme-4.12 tree
> 
> 
>  drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
> index 90527e7..4da99db 100644
> --- a/drivers/scsi/lpfc/lpfc_nvmet.c
> +++ b/drivers/scsi/lpfc/lpfc_nvmet.c
> @@ -958,8 +958,8 @@ lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
>  
>  	/* Respond with BA_RJT accordingly */
>  	lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 0);
> -	return 0;
>  #endif
> +	return 0;
>  }
>  
>  void
> 

I fixed this up already when I merged it, it's in the merge commit with
the block for-4.12/post-merge tree.

-- 
Jens Axboe
