From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] new mac_scsi driver
Date: Thu, 24 Apr 2008 23:08:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804242307370.21224@anakin>
References: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:37382 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYDXVJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 17:09:07 -0400
Received: from winston.telenet-ops.be (unknown [195.130.137.75])
	by yergi.telenet-ops.be (Postfix) with ESMTP id 71B725C926F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 23:09:21 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: David Miller <davem@davemloft.net>, Roman Zippel <zippel@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Thu, 24 Apr 2008, Finn Thain wrote:
> Replace the mac_esp driver with a new one based on the esp_scsi core.
> 
> For esp_scsi: add support for sync transfers for the PIO mode, add a new 
> esp_driver_ops method to get the maximum dma transfer size (like the old 
> NCR53C9x driver), and some cleanups.

Thanks!

I added this patch to my series, after fixing the few checkpatch.pl issues and
adding a test for MACH_IS_MAC() to esp_mac_probe().

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
