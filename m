From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 02/11] lpfc: Correct error in setting OS Driver Version
 with FW
Date: Tue, 20 Dec 2016 14:35:37 +0100
Message-ID: <df415875-dc12-ad8f-c45f-1d639b13d54d@suse.de>
References: <58586829./7yJcDGJNc37wnHv%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756717AbcLTNfk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:35:40 -0500
In-Reply-To: <58586829./7yJcDGJNc37wnHv%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> Correct error in setting OS Driver Version with FW.  Prior length was
> too short.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 27cbd68..230f924 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6304,7 +6304,8 @@ lpfc_set_host_data(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
>  			 LPFC_SLI4_MBX_EMBED);
>  
>  	mbox->u.mqe.un.set_host_data.param_id = LPFC_SET_HOST_OS_DRIVER_VERSION;
> -	mbox->u.mqe.un.set_host_data.param_len = 8;
> +	mbox->u.mqe.un.set_host_data.param_len =
> +					LPFC_HOST_OS_DRIVER_VERSION_SIZE;
>  	snprintf(mbox->u.mqe.un.set_host_data.data,
>  		 LPFC_HOST_OS_DRIVER_VERSION_SIZE,
>  		 "Linux %s v"LPFC_DRIVER_VERSION,
> 
Reviewed-by: Hannes Reinecke <hare@Suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
