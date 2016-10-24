From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 8/8] megaraid_sas: driver version upgrade
Date: Mon, 24 Oct 2016 16:36:44 +0200
Message-ID: <21b4efe9-708e-ce80-573c-7305460e680c@suse.de>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
 <1477056816-7058-9-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54252 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932346AbcJXOgq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Oct 2016 10:36:46 -0400
In-Reply-To: <1477056816-7058-9-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

On 10/21/2016 03:33 PM, Kashyap Desai wrote:
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 43fd14f..74c7b44 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -35,8 +35,8 @@
>  /*
>   * MegaRAID SAS Driver meta data
>   */
> -#define MEGASAS_VERSION				"06.811.02.00-rc1"
> -#define MEGASAS_RELDATE				"April 12, 2016"
> +#define MEGASAS_VERSION				"06.812.07.00-rc1"
> +#define MEGASAS_RELDATE				"August 22, 2016"
>
>  /*
>   * Device IDs
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
