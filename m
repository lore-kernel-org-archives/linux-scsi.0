From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] bnx2i: fix spelling mistake "complection" ->
 "completion"
Date: Sat, 4 Jun 2016 15:47:31 -0400 (EDT)
Message-ID: <558141483.40236641.1465069651168.JavaMail.zimbra@redhat.com>
References: <1465067670-7489-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:53115 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbcFDTrj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2016 15:47:39 -0400
In-Reply-To: <1465067670-7489-1-git-send-email-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Colin King" <colin.king@canonical.com>
> To: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen"
> <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Sent: Saturday, June 4, 2016 3:14:30 PM
> Subject: [PATCH] bnx2i: fix spelling mistake "complection" -> "completion"
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> trivial fix to spelling mistake in printk message
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/bnx2i/bnx2i_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index fb072cc..42921db 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -2417,7 +2417,7 @@ static void bnx2i_process_conn_destroy_cmpl(struct
> bnx2i_hba *hba,
>  	ep = bnx2i_find_ep_in_destroy_list(hba, conn_destroy->iscsi_conn_id);
>  	if (!ep) {
>  		printk(KERN_ALERT "bnx2i_conn_destroy_cmpl: no pending "
> -				  "offload request, unexpected complection\n");
> +				  "offload request, unexpected completion\n");
>  		return;
>  	}
>  
> --
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Simple fix
Reviewed-by Laurence Oberman <loberman@redhat.com>
