From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [patch] [SCSI] csiostor: remove unneeded memset()
Date: Thu, 29 Nov 2012 11:45:00 +0530
Message-ID: <50B6FD64.2080504@chelsio.com>
References: <20121127173330.GD1059@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121127173330.GD1059@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/27/2012 11:03 PM, Dan Carpenter wrote:
> No need to memset() this when we just copy over it on the next line.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
> index 551959e..8b54976 100644
> --- a/drivers/scsi/csiostor/csio_lnode.c
> +++ b/drivers/scsi/csiostor/csio_lnode.c
> @@ -245,7 +245,6 @@ csio_append_attrib(uint8_t **ptr, uint16_t type, uint8_t *val, uint16_t len)
>  	len += 4;		/* includes attribute type and length */
>  	len = (len + 3) & ~3;	/* should be multiple of 4 bytes */
>  	ae->len = htons(len);
> -	memset(ae->value, 0, len - 4);
>  	memcpy(ae->value, val, len);
>  	*ptr += len;
>  }
> 

Acked-by: Naresh Kumar Inna <naresh@chelsio.com>

Thanks,
Naresh.
