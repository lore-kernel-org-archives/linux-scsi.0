From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 30/39] megaraid_sas: During OCR, if get_ctrl_info fails do
 not continue with OCR
Date: Mon, 6 Feb 2017 12:26:53 +0100
Message-ID: <fcbab45d-cf56-6426-b463-d3928cd7ed8a@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-31-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:56618 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdBFL04 (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:26:56 -0500
In-Reply-To: <1486375212-17329-31-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 11:00 AM, Shivasharan S wrote:
> Error handling: If controller reset is not able to
> recover, kill HBA and quit immediately.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index d49f6bd..9f3cbaa 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -4281,6 +4281,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
>  					__func__, __LINE__);
>  				megaraid_sas_kill_hba(instance);
>  				retval = FAILED;
> +				goto out;
>  			}
>  			/* Reset load balance info */
>  			if (fusion->load_balance_info)
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
