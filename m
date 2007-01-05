From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC: 2.6 patch] remove the broken SCSI_AMIGA7XX driver
Date: Fri, 5 Jan 2007 10:30:13 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0701051026500.17589@pademelon.sonytel.be>
References: <20070104185359.GJ20714@stusta.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51061 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965139AbXAEJaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2007 04:30:18 -0500
In-Reply-To: <20070104185359.GJ20714@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Kars de Jong <jongk@linux-m68k.org>, linux-scsi@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Thu, 4 Jan 2007, Adrian Bunk wrote:
> The SCSI_AMIGA7XX driver:
> - has been marked as BROKEN for more than two years and
> - is still marked as BROKEN.
> 
> Drivers that had been marked as BROKEN for such a long time seem to be
> unlikely to be revived in the forseeable future.

There's a fix available to convert this driver to the new 53c700 core.
But it needs the new DMA framework, which still causes a few regressions on
m68k that are being worked on.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
