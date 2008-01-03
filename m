From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Thu, 3 Jan 2008 20:05:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801032003170.27528@anakin>
References: <477CFC97.2010201@panasas.com>  <477D0209.2000609@panasas.com>
 <1199384189.3122.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:52169 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYACTGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 14:06:22 -0500
Received: from edna.telenet-ops.be (edna.telenet-ops.be [195.130.132.58])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id C5298A00BC
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jan 2008 20:06:11 +0100 (CET)
In-Reply-To: <1199384189.3122.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux/m68k <linux-m68k@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 3 Jan 2008, James Bottomley wrote:
> On Thu, 2008-01-03 at 17:40 +0200, Boaz Harrosh wrote:
> > As recommended by Christoph Hellwig. There is no use
> >  of Fixing these drivers, since there is a much simpler
> >  and modern esp infrastructure with David Miller's esp_scsi
> > 
> >   - Remove all driver files dependent on NCR53C9x.c
> >         deleted:    drivers/scsi/NCR53C9x.c
> >         deleted:    drivers/scsi/NCR53C9x.h
> >         deleted:    drivers/scsi/blz1230.c
> >         deleted:    drivers/scsi/blz2060.c
> >         deleted:    drivers/scsi/cyberstorm.c
> >         deleted:    drivers/scsi/cyberstormII.c
> >         deleted:    drivers/scsi/dec_esp.c
> >         deleted:    drivers/scsi/fastlane.c
> >         deleted:    drivers/scsi/mac_esp.c
> >         deleted:    drivers/scsi/mca_53c9x.c
> >         deleted:    drivers/scsi/oktagon_esp.c
> >         deleted:    drivers/scsi/oktagon_io.S
> >         deleted:    drivers/scsi/sun3x_esp.c
> > 
> >   - Remove above list from drivers/scsi/Kconfig &&
> > drivers/scsi/Makefile
> 
> OK, I'll split this into four pieces for scsi-pending, since there are
> three separate interest groups with signoffs to collect (MCA, m68k and
> alpha) plus the core removal.

Anybody who can look into converting the m68k NCR53C9x drivers and has
hardware to test (some of) them? I don't think we can afford losing one
third of our SCSI drivers...

You can use the following as guidance:

commit 5ff263667798946abc15314eae3f341345877d7a
Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date:   Tue May 22 17:03:44 2007 -0700

    [SCSI] jazz_esp: Converted to use esp_core.
        
	    Use new esp_scsi for JAZZ SCSI host adapter driver

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
