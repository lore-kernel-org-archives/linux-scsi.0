From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] aic94xx: Supermicro motherboards support (PCI id)
Date: Sat, 14 Oct 2006 18:24:57 -0700 (PDT)
Message-ID: <20061015012457.83843.qmail@web31811.mail.mud.yahoo.com>
References: <20061015023444.44468dc7@manowar.localnet>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:55201 "HELO
	web31811.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1752320AbWJOBY6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Oct 2006 21:24:58 -0400
In-Reply-To: <20061015023444.44468dc7@manowar.localnet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergey Kononenko <sergk@center.hqhost.net>, linux-scsi@vger.kernel.org

--- Sergey Kononenko <sergk@center.hqhost.net> wrote:
> Add PCI id.
> 
> Signed-off-by: Sergey Kononenko <sergk@sergk.org.ua>
> 
> diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_hwi.h \
>         linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_hwi.h
> --- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_hwi.h 2006-10-14 \
>         21:11:59.000000000 +0000
> +++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_hwi.h \
>         2006-10-14 02:15:16.000000000 +0000
> @@ -46,6 +46,7 @@
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR10 0x410
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR12 0x412
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR1E 0x41E
> +#define PCI_DEVICE_ID_ADAPTEC2_RAZOR1F 0x41F
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR30 0x430
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR32 0x432
>  #define PCI_DEVICE_ID_ADAPTEC2_RAZOR3E 0x43E
> diff -urN linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_init.c \
>         linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_init.c
> --- linux-2.6.19-rc2/drivers/scsi/aic94xx/aic94xx_init.c 2006-10-14 \
>         21:11:59.000000000 +0000
> +++ linux-2.6.19-rc2.patched/drivers/scsi/aic94xx/aic94xx_init.c
> 2006-10-14 \ 02:15:16.000000000 +0000
> @@ -814,6 +814,8 @@
>          0, 0, 1},
>         {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1E),
>          0, 0, 1},
> +       {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR1F),
> +        0, 0, 1},
>         {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR30),
>          0, 0, 2},
>         {PCI_DEVICE(PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_RAZOR32),

Here is the commit, dated last year, 19 October 2005:

commit 63769e8c801e5247dde0b897811d86b4c7885485
Author: Luben Tuikov <luben_tuikov@adaptec.com>
Date:   Wed Oct 19 14:06:50 2005 -0400

    Re-add 0x41F PCI device ID for Razor on mainboards.
    Currently SuperMicro X6DHR-3G2 and X6DH3-G2.
    (As noted by Mark Rustad.)
    
    Signed-off-by: Luben Tuikov <luben_tuikov@adaptec.com>

Luben

