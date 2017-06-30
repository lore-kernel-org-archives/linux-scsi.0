From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/15] megaraid_sas: call megasas_dump_frame with correct
 IO frame size
Date: Fri, 30 Jun 2017 15:41:14 +0200
Message-ID: <dace9a03-4340-5e2a-7999-b3f44a4285b1@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38411 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751690AbdF3NlR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:41:17 -0400
In-Reply-To: <1498811409-11157-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:30 AM, Shivasharan S wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index c200f1a..c403e1d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -2795,7 +2795,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
>  		cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
>  		if (cmd)
>  			megasas_dump_frame(cmd->io_request,
> -				sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
> +				MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE);
>  		ret = megasas_reset_fusion(scmd->device->host,
>  				SCSIIO_TIMEOUT_OCR);
>  	} else
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
