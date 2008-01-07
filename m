From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Mon, 07 Jan 2008 07:07:40 +0100
Message-ID: <1199686061.31422.2.camel@kars.perseus.home>
References: <477CFC97.2010201@panasas.com>  <477D0209.2000609@panasas.com>
	 <1199384189.3122.22.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801032003170.27528@anakin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:50644 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYAGGHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 01:07:45 -0500
In-Reply-To: <Pine.LNX.4.64.0801032003170.27528@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On do, 2008-01-03 at 20:05 +0100, Geert Uytterhoeven wrote:
> On Thu, 3 Jan 2008, James Bottomley wrote:
> > On Thu, 2008-01-03 at 17:40 +0200, Boaz Harrosh wrote:
> > > As recommended by Christoph Hellwig. There is no use
> > >  of Fixing these drivers, since there is a much simpler
> > >  and modern esp infrastructure with David Miller's esp_scsi
> > > 
> > >   - Remove all driver files dependent on NCR53C9x.c
> > >         deleted:    drivers/scsi/NCR53C9x.c
> > >         deleted:    drivers/scsi/NCR53C9x.h
> > >         deleted:    drivers/scsi/blz1230.c
> > >         deleted:    drivers/scsi/blz2060.c
> > >         deleted:    drivers/scsi/cyberstorm.c
> > >         deleted:    drivers/scsi/cyberstormII.c
> > >         deleted:    drivers/scsi/dec_esp.c
> > >         deleted:    drivers/scsi/fastlane.c
> > >         deleted:    drivers/scsi/mac_esp.c
> > >         deleted:    drivers/scsi/mca_53c9x.c
> > >         deleted:    drivers/scsi/oktagon_esp.c
> > >         deleted:    drivers/scsi/oktagon_io.S
> > >         deleted:    drivers/scsi/sun3x_esp.c
> > > 
> > >   - Remove above list from drivers/scsi/Kconfig &&
> > > drivers/scsi/Makefile
> > 
> > OK, I'll split this into four pieces for scsi-pending, since there are
> > three separate interest groups with signoffs to collect (MCA, m68k and
> > alpha) plus the core removal.
> 
> Anybody who can look into converting the m68k NCR53C9x drivers and has
> hardware to test (some of) them? I don't think we can afford losing one
> third of our SCSI drivers...

I'll have a look at this. I can only test it on Blizzard 1260 hardware
though.


Kind regards,

Kars.


