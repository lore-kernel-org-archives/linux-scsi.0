From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: SCSI_DPT_I2O (was: Re: Linux 2.6.7-rc2)
Date: Thu, 10 Jun 2004 17:03:35 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.58.0406101659430.19315@waterleaf.sonytel.be>
References: <Pine.LNX.4.58.0405292349110.1632@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:41364 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S261426AbUFJPD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 11:03:56 -0400
In-Reply-To: <Pine.LNX.4.58.0405292349110.1632@ppc970.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Go Taniguchi <go@turbolinux.co.jp>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sat, 29 May 2004, Linus Torvalds wrote:
> Summary of changes from v2.6.7-rc1 to v2.6.7-rc2
> ============================================
> Go Taniguchi:
>   o Fix dpt_i2o

I have the impression SCSI_DPT_I2O should depend on PCI.

--- linux-2.6.7-rc3/drivers/scsi/Kconfig	2004-06-09 14:50:53.000000000 +0200
+++ linux-m68k-2.6.7-rc3/drivers/scsi/Kconfig	2004-06-10 11:01:45.000000000 +0200
@@ -352,7 +352,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic
 # All the I2O code and drivers do not seem to be 64bit safe.
 config SCSI_DPT_I2O
 	tristate "Adaptec I2O RAID support "
-	depends on !64BIT && SCSI
+	depends on !64BIT && SCSI && PCI
 	help
 	  This driver supports all of Adaptec's I2O based RAID controllers as
 	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
