From: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Mon, 17 Sep 2007 12:29:23 +0100 (BST)
Message-ID: <Pine.LNX.4.64N.0709171217350.17606@blysk.ds.pg.gda.pl>
References: <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de>
 <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de>
 <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de>
 <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org>
 <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de>
 <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:54070 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbXIQL3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 07:29:32 -0400
In-Reply-To: <46EBCEF1.4030702@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007, Stefan Richter wrote:

> >> +menu "Storage (core and SCSI commands)"
> >>  
> >>  config SCSI
> >> -	tristate "SCSI device support"
> >> +	tristate "Storage support (core and SCSI commands)"
> >>  	depends on BLOCK
> >>  	select SCSI_DMA if HAS_DMA
> >>  	---help---
> >> ...
> > 
> > What is "storage support"?
> > SATA?
> > PATA?
> > USB mass storage?
> > MMC?
> > MTD?
> 
> What is "Networking"?  Ethernet?  Infiniband?  ...?

 SCSI is a generic peripheral bus (recall the expansion of the acronym).  
Even though probably the most common, storage is one of its applications 
only (think scanners for an immediately obvious other one).  I find 
describing CONFIG_SCSI as "storage support" misleading and inappropriate.

 Referring to your example it is like calling generic networking (i.e. 
CONFIG_NET) "Ethernet support".

  Maciej
