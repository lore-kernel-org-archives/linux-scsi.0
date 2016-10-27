From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] hpsa: bump driver version
Date: Thu, 27 Oct 2016 11:03:54 +0200
Message-ID: <cfd1c213-83fb-d640-840e-fa730a76e658@suse.de>
References: <147752001094.813.10247306839794156732.stgit@brunhilda>
 <147752052502.813.10020617570995802711.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbcJ0Oyg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 10:54:36 -0400
In-Reply-To: <147752052502.813.10020617570995802711.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 10/27/2016 12:22 AM, Don Brace wrote:
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/hpsa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 810c300..0b6eb5a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -60,7 +60,7 @@
>   * HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.'
>   * with an optional trailing '-' followed by a byte value (0-255).
>   */
> -#define HPSA_DRIVER_VERSION "3.4.16-0"
> +#define HPSA_DRIVER_VERSION "3.4.16-145"
>  #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
>  #define HPSA "hpsa"
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
