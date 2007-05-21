From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] jazz_esp converted to use esp_core
Date: Mon, 21 May 2007 16:41:47 -0700 (PDT)
Message-ID: <20070521.164147.35664152.davem@davemloft.net>
References: <20070521210224.GA24573@alpha.franken.de>
	<20070521230041.GA12090@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53175
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbXEUXlq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 19:41:46 -0400
In-Reply-To: <20070521230041.GA12090@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: tsbogend@alpha.franken.de, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 22 May 2007 00:00:41 +0100

> > --- a/drivers/scsi/Makefile
> > +++ b/drivers/scsi/Makefile
> > @@ -121,7 +121,7 @@ obj-$(CONFIG_BLK_DEV_3W_XXXX_RAID) += 3w-xxxx.o
> >  obj-$(CONFIG_SCSI_3W_9XXX)	+= 3w-9xxx.o
> >  obj-$(CONFIG_SCSI_PPA)		+= ppa.o
> >  obj-$(CONFIG_SCSI_IMM)		+= imm.o
> > -obj-$(CONFIG_JAZZ_ESP)		+= NCR53C9x.o	jazz_esp.o
> > +obj-$(CONFIG_JAZZ_ESP)		+= jazz_esp.o
> 
> Note to Dave:  it probably would be nice to just build esp_scsi.o
> from the makefile like the old NCR53C9x drivers did instead of the
> Kconfig hackery, what do you think?

I disagree, I want people to be able to do test builds
even if their platform lacks a front-end driver.  And
for platforms with multiple front ends it's a complete
waste of space.
