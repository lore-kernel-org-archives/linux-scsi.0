From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 02/14] lpfc: Remove unnessary cast
Date: Tue, 1 Sep 2015 23:24:39 +0200
Message-ID: <20150901232439.000053dd@localhost>
References: <55e4bd89.wnXoOtgVrknAjUqh%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:51371 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbbIAVYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 17:24:51 -0400
In-Reply-To: <55e4bd89.wnXoOtgVrknAjUqh%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> From: Firo Yang <firogm@gmail.com>
> 
> kzalloc() returns a void pointer - no need to cast it in
> drivers/scsi/lpfc/lpfc_init.c::lpfc_sli_driver_resource_setup()
> 
> Signed-off-by: Firo Yang <firogm@gmail.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 1992e74..da9b6fc 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -4982,8 +4982,7 @@ lpfc_sli_driver_resource_setup(struct lpfc_hba *phba)
>  	}
>  
>  	if (!phba->sli.ring)
> -		phba->sli.ring = (struct lpfc_sli_ring *)
> -			kzalloc(LPFC_SLI3_MAX_RING *
> +		phba->sli.ring = kzalloc(LPFC_SLI3_MAX_RING *
>  			sizeof(struct lpfc_sli_ring), GFP_KERNEL);
>  	if (!phba->sli.ring)
>  		return -ENOMEM;

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
