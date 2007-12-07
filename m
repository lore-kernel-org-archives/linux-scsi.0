From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] SCSI: make pcmcia directory use obj-y|m instead of subdir-y|m
Date: Fri, 7 Dec 2007 17:06:03 +0100
Message-ID: <20071207160603.GB31641@uranus.ravnborg.org>
References: <47594C57.4070006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:35693 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXLGQEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 11:04:15 -0500
Content-Disposition: inline
In-Reply-To: <47594C57.4070006@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Fri, Dec 07, 2007 at 10:36:23PM +0900, Tejun Heo wrote:
> subdir-y|m isn't supposed to contain modules or built-in components.
> Change subdir-$(CONFIG_PCMCIA) to obj-$(CONFIG_PCMCIA).
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
Ack-by: Sam Ravnborg <sam@ravnborg.org>

> ---
>  drivers/scsi/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 2e6129f..72c8d2e 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -18,7 +18,7 @@ CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
>  CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ -DGDTH_STATISTICS
>  CFLAGS_seagate.o =   -DARBITRATE -DPARITY -DSEAGATE_USE_ASM
>  
> -subdir-$(CONFIG_PCMCIA)		+= pcmcia
> +obj-$(CONFIG_PCMCIA)		+= pcmcia/
>  
>  obj-$(CONFIG_SCSI)		+= scsi_mod.o
>  obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
