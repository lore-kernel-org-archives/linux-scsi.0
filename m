From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 17/28] scsi: drop owner assignment from
 platform_drivers
Date: Thu, 29 Jan 2015 17:54:46 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1501291747020.7510@nippy.intranet>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de> <1419196495-9626-18-git-send-email-wsa@the-dreams.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1419196495-9626-18-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Acked-by: Finn Thain <fthain@telegraphics.com.au>

On Sun, 21 Dec 2014, Wolfram Sang wrote:

> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/scsi/atari_scsi.c | 1 -
>  drivers/scsi/mac_scsi.c   | 1 -
>  drivers/scsi/sun3_scsi.c  | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index d1c37a386947..5ede3daa93dc 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -1014,7 +1014,6 @@ static struct platform_driver atari_scsi_driver = {
>  	.remove = __exit_p(atari_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> -		.owner	= THIS_MODULE,
>  	},
>  };
>  
> diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
> index 1e85c07e3b62..d64a769b8155 100644
> --- a/drivers/scsi/mac_scsi.c
> +++ b/drivers/scsi/mac_scsi.c
> @@ -483,7 +483,6 @@ static struct platform_driver mac_scsi_driver = {
>  	.remove = __exit_p(mac_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> -		.owner	= THIS_MODULE,
>  	},
>  };
>  
> diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
> index 2a906d1d34ba..22a42836d193 100644
> --- a/drivers/scsi/sun3_scsi.c
> +++ b/drivers/scsi/sun3_scsi.c
> @@ -676,7 +676,6 @@ static struct platform_driver sun3_scsi_driver = {
>  	.remove = __exit_p(sun3_scsi_remove),
>  	.driver = {
>  		.name	= DRV_MODULE_NAME,
> -		.owner	= THIS_MODULE,
>  	},
>  };
>  
> 
