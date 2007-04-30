From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] deprecate the old NCR53C9x driver
Date: Mon, 30 Apr 2007 15:16:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0704301516190.27246@anakin>
References: <20070429220548.GA22666@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:48053 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423252AbXD3NRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2007 09:17:12 -0400
Received: from hoboe2bl1.telenet-ops.be (hoboe2bl1.telenet-ops.be [195.130.137.73])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id 2F2739FE3E
	for <linux-scsi@vger.kernel.org>; Mon, 30 Apr 2007 15:17:11 +0200 (CEST)
In-Reply-To: <20070429220548.GA22666@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, davem@davemloft.net, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-mips@linux-mips.org

On Mon, 30 Apr 2007, Christoph Hellwig wrote:
> Now that we have the much better esp_scsi driver and low level drivers
> are easy to port over deprecate the old NCR53C9x driver.
> 
> I've Cc'ed the m68k and mips lists because all but one bus glues are
> for these platforms.  Chances stand bad for the remaining driver,
> mca_53c9x which hasn't gotten any non-trivial update since it was
> merge in late 2.1.x and whos maintainers mail address bounces.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/Documentation/feature-removal-schedule.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/feature-removal-schedule.txt	2007-04-29 23:44:46.000000000 +0200
> +++ linux-2.6/Documentation/feature-removal-schedule.txt	2007-04-29 23:45:55.000000000 +0200
> @@ -6,6 +6,13 @@ be removed from this file.
>  
>  ---------------------------
>  
> +What:	old NCR53C9x driver
> +When:	October 2007
> +Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> +	driver can ported over almost trivially.
                  ^
		  be

> +Who:	David Miller <davem@davemloft.net>
> +	Christoph Hellwig <hch@lst.de>
> +
>  What:	V4L2 VIDIOC_G_MPEGCOMP and VIDIOC_S_MPEGCOMP
>  When:	October 2007
>  Why:	Broken attempt to set MPEG compression parameters. These ioctls are

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
