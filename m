From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] scsi: fc: remove redundant check of an unsigned long
 being less than zero
Date: Mon, 17 Apr 2017 11:53:02 -0700
Message-ID: <bc14cba3-5140-0e33-115c-56283b2ec44b@gmail.com>
References: <20170414135802.6991-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170414135802.6991-1-colin.king@canonical.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/14/2017 06:58 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check for an unsigned long being less than zero is always false
> so it is a redundant check and can be removed.
> 
> Detected by static analysis with by PVS-Studio
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

> ---
>  drivers/scsi/scsi_transport_fc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 2d753c93e07a..87b8f9d64d9b 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -850,7 +850,7 @@ static int fc_str_to_dev_loss(const char *buf, unsigned long *val)
>  	char *cp;
>  
>  	*val = simple_strtoul(buf, &cp, 0);
> -	if ((*cp && (*cp != '\n')) || (*val < 0))
> +	if (*cp && (*cp != '\n'))
>  		return -EINVAL;
>  	/*
>  	 * Check for overflow; dev_loss_tmo is u32
> 

