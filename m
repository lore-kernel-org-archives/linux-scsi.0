From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Fri, 4 Jan 2008 22:05:20 +1100 (EST)
Message-ID: <Pine.LNX.4.64.0801042143001.17406@loopy.telegraphics.com.au>
References: <477D0209.2000609@panasas.com> <1199384189.3122.22.camel@localhost.localdomain>
 <Pine.LNX.4.64.0801032003170.27528@anakin> <20080103.150204.101269827.davem@davemloft.net>
 <Pine.LNX.4.64.0801041054130.27528@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:37893 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYADLjU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 06:39:20 -0500
In-Reply-To: <Pine.LNX.4.64.0801041054130.27528@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Miller <davem@davemloft.net>, linux-m68k@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, hch@infradead.org, macro@linux-mips.org, linux-scsi@vger.kernel.org



On Fri, 4 Jan 2008, Geert Uytterhoeven wrote:

> 
> > I totally object to keeping these things around any longer.  And this 
> > I support these changes going in.
> 
> BTW, I hope you do remember why NCR53C9x.[ch] incarnated in the first 
> place...
> 
> OK, we'll see what we can do...

I have a partially written replacement for mac_esp. Unlike the other 
NCR53C9x drivers it needs PIO or pseudo DMA depending on the machine -- so 
it is not as straight-forward as jazz_esp. The new esp_scsi core assumes 
DMA and doesn't support asynch transfers. But I'll try to get it finished 
before 2.6.25 is released.

Finn

> Gr{oetje,eeting}s,
> 
> 						Geert
> 
