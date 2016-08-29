From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/17] smartpqi: change commonly used function to inline
Date: Mon, 29 Aug 2016 11:06:52 +0200
Message-ID: <20160829090652.wxjff23nxbsbmcxn@c203.arch.suse.de>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
 <147222988202.31214.8351871414119128313.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57783 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbcH2JGy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Aug 2016 05:06:54 -0400
Content-Disposition: inline
In-Reply-To: <147222988202.31214.8351871414119128313.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Fri, Aug 26, 2016 at 11:44:42AM -0500, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microsemi.com>
> 
> A tiny tweak to convert a small, commonly used function to inline.
> 
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index dbc8b40..2656124 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -316,7 +316,7 @@ static struct pqi_io_request *pqi_alloc_io_request(
>  	return io_request;
>  }
>  
> -static void pqi_free_io_request(struct pqi_io_request *io_request)
> +static inline void pqi_free_io_request(struct pqi_io_request *io_request)
>  {
>  	atomic_dec(&io_request->refcount);
>  }
> 

Did you check whether the compiler does this for you already?

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
