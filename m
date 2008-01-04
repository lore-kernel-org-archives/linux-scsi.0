From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Fri, 4 Jan 2008 10:59:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041054130.27528@anakin>
References: <477D0209.2000609@panasas.com> <1199384189.3122.22.camel@localhost.localdomain>
 <Pine.LNX.4.64.0801032003170.27528@anakin> <20080103.150204.101269827.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yergi.telenet-ops.be ([195.130.132.36]:41724 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYADKAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 05:00:13 -0500
In-Reply-To: <20080103.150204.101269827.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-m68k@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, hch@infradead.org, macro@linux-mips.org, linux-scsi@vger.kernel.org

On Thu, 3 Jan 2008, David Miller wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> > On Thu, 3 Jan 2008, James Bottomley wrote:
> > > On Thu, 2008-01-03 at 17:40 +0200, Boaz Harrosh wrote:
> > > > As recommended by Christoph Hellwig. There is no use
> > > >  of Fixing these drivers, since there is a much simpler
> > > >  and modern esp infrastructure with David Miller's esp_scsi
> > > > 
> > > >   - Remove all driver files dependent on NCR53C9x.c
> > > >         deleted:    drivers/scsi/NCR53C9x.c
> > > >         deleted:    drivers/scsi/NCR53C9x.h
> > > >         deleted:    drivers/scsi/blz1230.c
> > > >         deleted:    drivers/scsi/blz2060.c
> > > >         deleted:    drivers/scsi/cyberstorm.c
> > > >         deleted:    drivers/scsi/cyberstormII.c
> > > >         deleted:    drivers/scsi/dec_esp.c
> > > >         deleted:    drivers/scsi/fastlane.c
> > > >         deleted:    drivers/scsi/mac_esp.c
> > > >         deleted:    drivers/scsi/mca_53c9x.c
> > > >         deleted:    drivers/scsi/oktagon_esp.c
> > > >         deleted:    drivers/scsi/oktagon_io.S
> > > >         deleted:    drivers/scsi/sun3x_esp.c
> > > > 
> > > >   - Remove above list from drivers/scsi/Kconfig &&
> > > > drivers/scsi/Makefile
> > > 
> > > OK, I'll split this into four pieces for scsi-pending, since there are
> > > three separate interest groups with signoffs to collect (MCA, m68k and
> > > alpha) plus the core removal.
> > 
> > Anybody who can look into converting the m68k NCR53C9x drivers and has
> > hardware to test (some of) them? I don't think we can afford losing one
> > third of our SCSI drivers...
> 
> We can't wait forever, and effort spent maintaining the old
> rotting drivers is effort that should instead be spent on
> the converted new drivers.
> 
> Instead of seeing conversions being written, we've been hearing this
> swan song from the m68k crowd forever, it's getting quite old.

quite old == the new esp_scsi arrived in April 2007. On the m68k timescale,
this is just a split-second ago. Following this logic, it's a surprise
OSS hasn't been removed completely ;-)

> I totally object to keeping these things around any longer.  And this
> I support these changes going in.

BTW, I hope you do remember why NCR53C9x.[ch] incarnated in the first place...

OK, we'll see what we can do...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
