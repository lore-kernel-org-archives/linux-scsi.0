From: Nikola Pajkovsky <npajkovsky@suse.cz>
Subject: Re: [PATCH 01/21] lpfc: Fix opps when ExpressLane is enabled
Date: Thu, 03 Aug 2017 12:43:18 +0200
Message-ID: <87bmnxgce1.fsf@suse.cz>
References: <20170802233648.4573-1-jsmart2021@gmail.com>
        <20170802233648.4573-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44742 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751221AbdHCKnU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 06:43:20 -0400
In-Reply-To: <20170802233648.4573-2-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 2 Aug 2017 16:36:28 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

James Smart <jsmart2021@gmail.com> writes:

> From: Dick Kennedy <dick.kennedy@broadcom.com>
>
> Null pointer dereference in lpfc_sli4_fof_intr_handler
>
> The driver does not set up cq->assoc_qp for sli4_hba->oas_cq
>
> Initialize cq->assoc_qp before accessing it
>
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index e948ea05fd33..0615bf9def23 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -13557,6 +13557,9 @@ lpfc_sli4_fof_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe)
>  	/* Save EQ associated with this CQ */
>  	cq->assoc_qp = phba->sli4_hba.fof_eq;
>  
> +	/* Save EQ associated with this CQ */
> +	cq->assoc_qp = phba->sli4_hba.fof_eq;
> +

Copy & paste error? Above lines are similar.

-- 
Nikola
