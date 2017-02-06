From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 35/39] megaraid_sas: Increase internal command pool
Date: Mon, 6 Feb 2017 12:29:22 +0100
Message-ID: <9d839ad4-144d-e9d1-465e-08a86c8fa98a@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-36-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:58359 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdBFL3Z (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:29:25 -0500
In-Reply-To: <1486375212-17329-36-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 11:00 AM, Shivasharan S wrote:
> Fix - increase internal command pool to 8.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        | 2 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 59fe39d..1a9a283 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -1460,7 +1460,7 @@ enum FW_BOOT_CONTEXT {
>   */
>  #define MEGASAS_INT_CMDS			32
>  #define MEGASAS_SKINNY_INT_CMDS			5
> -#define MEGASAS_FUSION_INTERNAL_CMDS		5
> +#define MEGASAS_FUSION_INTERNAL_CMDS		8
>  #define MEGASAS_FUSION_IOCTL_CMDS		3
>  #define MEGASAS_MFI_IOCTL_CMDS			27
>  
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 5dda73d..65971a9d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1347,7 +1347,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
>  		fusion->last_reply_idx[i] = 0;
>  
>  	/*
> -	 * For fusion adapters, 3 commands for IOCTL and 5 commands
> +	 * For fusion adapters, 3 commands for IOCTL and 8 commands
>  	 * for driver's internal DCMDs.
>  	 */
>  	instance->max_scsi_cmds = instance->max_fw_cmds -
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
