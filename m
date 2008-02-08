From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Fri, 8 Feb 2008 10:03:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802081001540.18242@anakin>
References: <1202432206.3171.53.camel@localhost.localdomain>
 <1202432647.31361.26.camel@brick> <1202432873.3171.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933369AbYBHJD7@vger.kernel.org>
In-Reply-To: <1202432873.3171.58.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 7 Feb 2008, James Bottomley wrote:
> On Thu, 2008-02-07 at 17:04 -0800, Harvey Harrison wrote:
> > On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> > > Quite a bit of this is fixing things broken previously (the advansys fix
> > > is still pending resolution, but I'll send it as an -rc fix when we have
> > > it).  There's the final elimination of all drivers that are esp based
> > > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > > the usual bunch of driver updates and the addition of a new enclosure
> > > services driver and the corresponding ULD.
> > > 
> > > The patch is available from:
> > > 
> > 
> > I'm going to guess that this is the entry in feature-removal.txt
> > that need an update then:
> > 
> > ---------------------------
> > 
> > What:	old NCR53C9x driver
> > When:	October 2007
> > Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > 	driver can be ported over almost trivially.
> > Who:	David Miller <davem@davemloft.net>
> > 	Christoph Hellwig <hch@lst.de>
> 
> Not immediately ... I anticipate a few "where'd my driver go?" type
> questions from m68k for which this provides a useful reference to point
> to ...

Don't bother, we're fully aware of this.

The shortest feature removal notice in Linux's history (is it?) didn't go
unnoticed ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
