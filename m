From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cdrom: Make device operations read-only
Date: Mon, 13 Feb 2017 21:58:11 -0500 (EST)
Message-ID: <20170213.215811.902501442022534048.davem@davemloft.net>
References: <20170214002526.GA124769@beast>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170214002526.GA124769@beast>
Sender: linux-ide-owner@vger.kernel.org
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, corbet@lwn.net, tim@cyberelk.net, bp@alien8.de, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-doc@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-scsi@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Mon, 13 Feb 2017 16:25:26 -0800

> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 9cbd217bc0c9..ab9232e1e16f 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1166,7 +1166,7 @@ void ide_cdrom_update_speed(ide_drive_t *drive, u8 *buf)
>  	 CDC_CD_RW | CDC_DVD | CDC_DVD_R | CDC_DVD_RAM | CDC_GENERIC_PACKET | \
>  	 CDC_MO_DRIVE | CDC_MRW | CDC_MRW_W | CDC_RAM)
>  
> -static struct cdrom_device_ops ide_cdrom_dops = {
> +static const struct cdrom_device_ops ide_cdrom_dops = {
>  	.open			= ide_cdrom_open_real,
>  	.release		= ide_cdrom_release_real,
>  	.drive_status		= ide_cdrom_drive_status,

Acked-by: David S. Miller <davem@davemloft.net>
