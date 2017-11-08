From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/17] lpfc: Raise maximum NVME sg list size for 256
 elements
Date: Wed, 8 Nov 2017 10:24:52 +0100
Message-ID: <ddd3fb4a-8343-12be-4b32-9c025984aa78@suse.de>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
 <20171103225628.24716-7-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751126AbdKHJYx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Nov 2017 04:24:53 -0500
In-Reply-To: <20171103225628.24716-7-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 11/03/2017 11:56 PM, James Smart wrote:
> Raise the maximum NVME sg list size allowed to 256 elements.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 7219b6ce5dc7..46a89bdff8e4 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -57,7 +57,7 @@ struct lpfc_sli2_slim;
>  #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
>  #define LPFC_MAX_SGL_SEG_CNT	512	/* SGL element count per scsi cmnd */
>  #define LPFC_MAX_BPL_SEG_CNT	4096	/* BPL element count per scsi cmnd */
> -#define LPFC_MAX_NVME_SEG_CNT	128	/* max SGL element cnt per NVME cmnd */
> +#define LPFC_MAX_NVME_SEG_CNT	256	/* max SGL element cnt per NVME cmnd */
>  
>  #define LPFC_MAX_SGE_SIZE       0x80000000 /* Maximum data allowed in a SGE */
>  #define LPFC_IOCB_LIST_CNT	2250	/* list of IOCBs for fast-path usage. */
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
