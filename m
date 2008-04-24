From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] new mac_scsi driver
Date: Thu, 24 Apr 2008 16:33:27 -0500
Message-ID: <1209072808.3121.22.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0804231833210.12067@loopy.telegraphics.com.au>
	 <Pine.LNX.4.64.0804242307370.21224@anakin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48895 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048AbYDXVdc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2008 17:33:32 -0400
In-Reply-To: <Pine.LNX.4.64.0804242307370.21224@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, David Miller <davem@davemloft.net>, Roman Zippel <zippel@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Thu, 2008-04-24 at 23:08 +0200, Geert Uytterhoeven wrote:
> On Thu, 24 Apr 2008, Finn Thain wrote:
> > Replace the mac_esp driver with a new one based on the esp_scsi core.
> > 
> > For esp_scsi: add support for sync transfers for the PIO mode, add a new 
> > esp_driver_ops method to get the maximum dma transfer size (like the old 
> > NCR53C9x driver), and some cleanups.
> 
> Thanks!
> 
> I added this patch to my series, after fixing the few checkpatch.pl issues and
> adding a test for MACH_IS_MAC() to esp_mac_probe().

I got the tabs and spaces thing.  I'm not too concerned about the
assignment in conditional, but I'm happy to go whichever way the author
does.

Could you repost please because I already have this queued, so I need a
replacement (assuming everyone agrees).  There are other issues with the
driver (like the dma_length_limit stuff which looks like it should
really by fixed using the block layer segment boundary/segment length
limits, but that's more esp generic than mac_esp specific) which I
planned to look into after it was merged.

Thanks,

James


