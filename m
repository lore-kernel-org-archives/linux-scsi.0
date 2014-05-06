From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add an entry for all the NCR5380 drivers
Date: Wed, 7 May 2014 08:16:33 +1200
Message-ID: <CAOmrzkKFiEW6sMXr6nxgjGW=Bf2EUbBoBC=sXVLPH=r8iY8BCg@mail.gmail.com>
References: <alpine.LNX.2.00.1405051458460.16664@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1405051458460.16664@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Acked-by: Michael Schmitz <schmitzmic@gmail.com>

On Mon, May 5, 2014 at 5:35 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
>
> ---
>
> As requested:
> http://marc.info/?l=linux-arm-kernel&m=139853302724112&w=2
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e67ea24..60ea600 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5996,6 +5996,28 @@ M:       Petr Vandrovec <petr@vandrovec.name>
>  S:     Odd Fixes
>  F:     fs/ncpfs/
>
> +NCR 5380 SCSI DRIVERS
> +M:     Finn Thain <fthain@telegraphics.com.au>
> +M:     Michael Schmitz <schmitzmic@gmail.com>
> +L:     linux-scsi@vger.kernel.org
> +S:     Maintained
> +F:     Documentation/scsi/g_NCR5380.txt
> +F:     drivers/scsi/NCR5380.*
> +F:     drivers/scsi/arm/cumana_1.c
> +F:     drivers/scsi/arm/oak.c
> +F:     drivers/scsi/atari_NCR5380.c
> +F:     drivers/scsi/atari_scsi.*
> +F:     drivers/scsi/dmx3191d.c
> +F:     drivers/scsi/dtc.*
> +F:     drivers/scsi/g_NCR5380.*
> +F:     drivers/scsi/g_NCR5380_mmio.c
> +F:     drivers/scsi/mac_scsi.*
> +F:     drivers/scsi/pas16.*
> +F:     drivers/scsi/sun3_NCR5380.c
> +F:     drivers/scsi/sun3_scsi.*
> +F:     drivers/scsi/sun3_scsi_vme.c
> +F:     drivers/scsi/t128.*
> +
>  NCR DUAL 700 SCSI DRIVER (MICROCHANNEL)
>  M:     "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>  L:     linux-scsi@vger.kernel.org
