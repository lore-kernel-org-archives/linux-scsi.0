From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 28/39] megaraid_sas: Remove unused pd_index from
 megasas_build_ld_nonrw_fusion
Date: Mon, 6 Feb 2017 12:25:51 +0100
Message-ID: <e26fc1ac-f1fd-22bc-1b0a-7b74ca22d61a@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:42324 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751343AbdBFLZy (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:25:54 -0500
In-Reply-To: <1486375212-17329-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 11:00 AM, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index e74cbe6d..7f53505 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2477,7 +2477,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
>  {
>  	u32 device_id;
>  	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
> -	u16 pd_index = 0, ld;
> +	u16 ld;
>  	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
>  	struct fusion_context *fusion = instance->ctrl_context;
>  	u8                          span, physArm;
> @@ -2489,7 +2489,6 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
>  
>  	io_request = cmd->io_request;
>  	device_id = MEGASAS_DEV_INDEX(scmd);
> -	pd_index = MEGASAS_PD_INDEX(scmd);
>  	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
>  	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
>  	/* get RAID_Context pointer */
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
