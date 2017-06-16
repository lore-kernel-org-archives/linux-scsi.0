From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/11] lpfc: update to revision to 11.4.0.1
Date: Fri, 16 Jun 2017 10:03:30 +0200
Message-ID: <79e08da8-fad7-49b3-cd08-552abda200c7@suse.de>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
 <20170616055651.9674-12-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56949 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752134AbdFPIDc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 04:03:32 -0400
In-Reply-To: <20170616055651.9674-12-jsmart2021@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 06/16/2017 07:56 AM, James Smart wrote:
> Set lpfc driver revision to 11.4.0.1
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_version.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
> index 067c9e8a4b2d..c6a24c3e2d5e 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -20,7 +20,7 @@
>   * included with this package.                                     *
>   *******************************************************************/
>  
> -#define LPFC_DRIVER_VERSION "11.4.0.0"
> +#define LPFC_DRIVER_VERSION "11.4.0.1"
>  #define LPFC_DRIVER_NAME		"lpfc"
>  
>  /* Used for SLI 2/3 */
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
