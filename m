From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Replace BUG() with BUG_ON()
Date: Tue, 17 Jan 2017 12:34:29 -0800
Message-ID: <3f227927-a816-ac7f-73eb-8b87e917eb46@broadcom.com>
References: <1482576667-8042-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35103 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdAQUed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 15:34:33 -0500
Received: by mail-qt0-f169.google.com with SMTP id x49so177707924qtc.2
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 12:34:33 -0800 (PST)
In-Reply-To: <1482576667-8042-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Good by me.

-- james

Signed-off-by: James Smart <james.smart@broadcom.com>


On 12/24/2016 2:51 AM, Shyam Saini wrote:
> Replace BUG() with BUG_ON() using coccinelle
>
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_els.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 27f0cbb..ede14f1 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -8855,8 +8855,7 @@ lpfc_cmpl_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
>   {
>   	struct ls_rjt stat;
>   
> -	if ((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC)
> -		BUG();
> +	BUG_ON((cmdiocb->iocb_flag & LPFC_IO_FABRIC) != LPFC_IO_FABRIC);
>   
>   	switch (rspiocb->iocb.ulpStatus) {
>   		case IOSTAT_NPORT_RJT:

