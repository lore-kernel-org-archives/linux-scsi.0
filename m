From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] SCSI: fcoe: remove unneeded fcoe_ctlr_destroy_store
 export
Date: Thu, 24 Jan 2019 08:54:36 +0100
Message-ID: <e9751f7a-7599-a30f-015c-c13bc4573220@suse.de>
References: <20190122142818.GC18225@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122142818.GC18225@kroah.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/22/19 3:28 PM, Greg Kroah-Hartman wrote:
> There's no need to export fcoe_ctlr_destroy_store as a symbol, so remove
> the EXPORT_SYMBOL() line for it.
> 
> Cc: Johannes Thumshirn <jth@kernel.org>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/scsi/fcoe/fcoe_transport.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index f4909cd206d3..6d3949b687ef 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -855,7 +855,6 @@ ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
>   	mutex_unlock(&ft_mutex);
>   	return rc;
>   }
> -EXPORT_SYMBOL(fcoe_ctlr_destroy_store);
>   
>   /**
>    * fcoe_transport_create() - Create a fcoe interface
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
