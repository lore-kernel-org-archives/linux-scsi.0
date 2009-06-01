From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [SCSI] cxgb3i: Include net/dst.h for struct dst_cache
Date: Sun, 31 May 2009 21:25:06 -0500
Message-ID: <4A233C02.7010505@cs.wisc.edu>
References: <20090530034004.GA20516@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090530034004.GA20516@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, Karen Xie <kxie@chelsio.com>
List-Id: linux-scsi@vger.kernel.org

ccing cxgb3i driver maitainer.

Herbert Xu wrote:
> Hi:
> 
> [SCSI] cxgb3i: Include net/dst.h for struct dst_cache
> 
> This driver needs dst_cache->dev so it should include net/dst.h
> to ensure that it builds.  While net/tcp.h probably includes it
> already, we shouldn't rely on that since there is no guarantee
> that this won't change in future.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> index 9212400..8b49731 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/inet.h>
>  #include <linux/crypto.h>
> +#include <net/dst.h>
>  #include <net/tcp.h>
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_device.h>
> 

Looks ok.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
