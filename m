From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/11] Fix nvme_info sysfs output to be consistent
Date: Fri, 16 Jun 2017 09:51:05 +0200
Message-ID: <ed985ff6-0b2d-ca65-d70a-0587fe8000fd@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-3-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752375AbdFPHvH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 03:51:07 -0400
In-Reply-To: <20170616055651.9674-3-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> First line of nvme_info output is not consistent
> 
> There is an Extra colon in the format.
> 
> First line of output will contain one of the following strings:
> NVME Initiator Enabled
> NVME Target Enabled
> NVME Disabled
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_attr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 66269e342c7e..af22602b1058 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -171,7 +171,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
>  		else
>  			statep = "INIT";
>  		len += snprintf(buf + len, PAGE_SIZE - len,
> -				"NVME Target: Enabled  State %s\n",
> +				"NVME Target Enabled  State %s\n",
>  				statep);
>  		len += snprintf(buf + len, PAGE_SIZE - len,
>  				"%s%d WWPN x%llx WWNN x%llx DID x%06x\n",
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
