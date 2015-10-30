From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 25/25] hpsa: bump the driver version
Date: Fri, 30 Oct 2015 15:44:44 +0100
Message-ID: <5633825C.6090202@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220702.5323.10444.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbbJ3Oos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 10:44:48 -0400
In-Reply-To: <20151028220702.5323.10444.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:07, Don Brace wrote:
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Gerry Morong <gerry.morong.pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index ca38a00..1b43157 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -56,7 +56,7 @@
>  #include "hpsa.h"
>  
>  /* HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.' */

Is the description^ still valid ?

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> -#define HPSA_DRIVER_VERSION "3.4.10-0"
> +#define HPSA_DRIVER_VERSION "3.4.14-0"
>  #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
>  #define HPSA "hpsa"
>  
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

