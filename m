From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC] scsi: switch to scsi-mq by default
Date: Tue, 3 Jul 2018 08:56:03 +0200
Message-ID: <32b31863-48c6-002e-e769-0c76f90502a3@suse.de>
References: <20180703065413.6098-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703065413.6098-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Ming Lei <tom.leiming@gmail.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 07/03/2018 08:54 AM, Johannes Thumshirn wrote:
> It has been more than one year since we tried to change the default
> from legacy to multi queue in SCSI. Back then we had to retract the
> change because of performance issues with rotating disks.
> 
> In the meantime there have been a substantial amount of performance
> improvements, thus we can re-enable scsi-mq without a significant
> performance penalty.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 35c909bbf8ba..bd115bab162e 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -49,6 +49,7 @@ config SCSI_NETLINK
>  
>  config SCSI_MQ_DEFAULT
>  	bool "SCSI: use blk-mq I/O path by default"
> +	default y
>  	depends on SCSI
>  	---help---
>  	  This option enables the new blk-mq based I/O path for SCSI
> 

Yeah, let's try it.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
