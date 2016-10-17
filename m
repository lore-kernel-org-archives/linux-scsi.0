From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/7] megaraid_sas: driver version upgrade
Date: Mon, 17 Oct 2016 13:35:05 +0200
Message-ID: <acb9270b-13e0-ad6e-0af5-ce05215db139@suse.de>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-6-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935129AbcJQLfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 07:35:16 -0400
In-Reply-To: <1476699850-25083-6-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com

On 10/17/2016 12:24 PM, Sumit Saxena wrote:
> Upgrade driver version.
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 43fd14f..1d4de90 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -35,8 +35,8 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"06.811.02.00-rc1"
> -#define MEGASAS_RELDATE				"April 12, 2016"
> +#define MEGASAS_VERSION				"06.812.06.00-rc1"
> +#define MEGASAS_RELDATE				"August 22, 2016"
>  
>  /*
>   * Device IDs
> 
Please move this patch to the end of the series.
Otherwise it's impossible to tell if the following patches should be
part of the new version or not.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
