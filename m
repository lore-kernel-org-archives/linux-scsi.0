From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 07/13] be2iscsi: Remove redundant receive buffers
 posting
Date: Thu, 22 Dec 2016 13:57:46 +0100
Message-ID: <39ac0555-d6e2-f814-6988-a880136c8318@suse.de>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
 <1481624766-13846-8-git-send-email-jitendra.bhivare@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41475 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752567AbcLVM5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Dec 2016 07:57:48 -0500
In-Reply-To: <1481624766-13846-8-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org

On 12/13/2016 11:26 AM, Jitendra Bhivare wrote:
> This duplicate code got added during manual merging.
>
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 1b5a07f..c6af6e5 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -3859,14 +3859,6 @@ static int hwi_init_port(struct beiscsi_hba *phba)
>  					phwi_ctrlr->wrb_context[cri].cid] =
>  					async_arr_idx++;
>  			}
> -			/**
> -			 * Now that the default PDU rings have been created,
> -			 * let EP know about it.
> -			 */
> -			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_HDR,
> -						 ulp_num);
> -			beiscsi_hdq_post_handles(phba, BEISCSI_DEFQ_DATA,
> -						 ulp_num);
>  		}
>  	}
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
