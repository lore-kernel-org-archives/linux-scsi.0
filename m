From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] SCSI NCR53C9x.c: some cleanups
Date: Mon, 17 Jan 2005 13:41:29 +0100 (MET)
Message-ID: <Pine.GSO.4.61.0501171339270.3226@waterleaf.sonytel.be>
References: <200412290732.iBT7WifI018047@hera.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:45007 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S262783AbVAQMtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jan 2005 07:49:07 -0500
In-Reply-To: <200412290732.iBT7WifI018047@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Tue, 21 Dec 2004, Linux Kernel Mailing List wrote:
> ChangeSet 1.2034.61.36, 2004/12/21 09:41:18-06:00, bunk@stusta.de
> 
> 	[PATCH] SCSI NCR53C9x.c: some cleanups
> 	
> 	Make two functions static

> --- a/drivers/scsi/NCR53C9x.c	2004-12-28 23:32:55 -08:00
> +++ b/drivers/scsi/NCR53C9x.c	2004-12-28 23:32:55 -08:00
> @@ -505,7 +505,7 @@
>  }
>  
>  /* This places the ESP into a known state at boot time. */
> -void esp_bootup_reset(struct NCR_ESP *esp, struct ESP_regs *eregs)
> +static void esp_bootup_reset(struct NCR_ESP *esp, struct ESP_regs *eregs)
>  {
>  	volatile unchar trash;
>  

This change breaks the Amiga Oktagon SCSI driver (drivers/scsi/oktagon_esp.c),
which calls esp_bootup_reset().

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
