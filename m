From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 17/17] lpfc: lpfc version changed to 11.2.0.2
Date: Fri, 14 Oct 2016 12:44:48 +0200
Message-ID: <5acd33b0-0abf-7473-97f3-a0db42f2e279@suse.de>
References: <5800055a.N2FUIaZYX6deGAKO%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48644 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbcJNLdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Oct 2016 07:33:45 -0400
In-Reply-To: <5800055a.N2FUIaZYX6deGAKO%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 10/14/2016 12:06 AM, James Smart wrote:
> 
> lpfc version changed to 11.2.0.2
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_version.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
> index c9bf20e..50bfc43 100644
> --- a/drivers/scsi/lpfc/lpfc_version.h
> +++ b/drivers/scsi/lpfc/lpfc_version.h
> @@ -18,7 +18,7 @@
>   * included with this package.                                     *
>   *******************************************************************/
>  
> -#define LPFC_DRIVER_VERSION "11.2.0.0."
> +#define LPFC_DRIVER_VERSION "11.2.0.2"
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
