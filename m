From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] scsi: core: Update SCSI_MQ_DEFAULT help text to match
 default
Date: Tue, 21 Aug 2018 21:19:55 +0800
Message-ID: <20180821131953.GA28549@ming.t460p>
References: <20180821114407.18393-1-geert+renesas@glider.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180821114407.18393-1-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 21, 2018 at 01:44:07PM +0200, Geert Uytterhoeven wrote:
> The default was changed, but the help text was not updated.
> 
> Fix grammar (s/the option/this option/) while at it.
> 
> Fixes: d5038a13eca72fb2 ("scsi: core: switch to scsi-mq by default")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/scsi/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 8fc851a9e1162a56..a0491e11bd359499 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -53,11 +53,11 @@ config SCSI_MQ_DEFAULT
>  	depends on SCSI
>  	---help---
>  	  This option enables the new blk-mq based I/O path for SCSI
> -	  devices by default.  With the option the scsi_mod.use_blk_mq
> +	  devices by default.  With this option the scsi_mod.use_blk_mq
>  	  module/boot option defaults to Y, without it to N, but it can
>  	  still be overridden either way.
>  
> -	  If unsure say N.
> +	  If unsure say Y.
>  
>  config SCSI_PROC_FS
>  	bool "legacy /proc/scsi/ support"
> -- 
> 2.17.1
> 

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming
