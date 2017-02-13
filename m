From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 16/16] lpfc: Update lpfc version to 11.2.0.7
Date: Mon, 13 Feb 2017 10:19:32 +0100
Message-ID: <d4587f50-e88a-f322-8205-29052953f502@suse.de>
References: <58a0d928.Zhz1nZh7kjbELlcG%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbdBMJTe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Feb 2017 04:19:34 -0500
In-Reply-To: <58a0d928.Zhz1nZh7kjbELlcG%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On 02/12/2017 10:52 PM, James Smart wrote:
> 
> Update lpfc version to 11.2.0.7
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_version.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
> index 0d93535..86c6c9b 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -20,7 +20,7 @@
>   * included with this package.                                     *
>   *******************************************************************/
>  
> -#define LPFC_DRIVER_VERSION "11.2.0.4"
> +#define LPFC_DRIVER_VERSION "11.2.0.7"
>  #define LPFC_DRIVER_NAME		"lpfc"
>  
>  /* Used for SLI 2/3 */
> 
Hmm. One would have thought that a major rework like this would warrant
an increased major number.
But that's probably just me being totally ignorant of any company
policies :-)

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
