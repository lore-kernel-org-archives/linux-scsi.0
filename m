From: Michael Schmitz <schmitz@onyx.biophys.uni-duesseldorf.de>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Thu, 03 Jan 2008 20:46:46 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0801032037180.26840-100000@onyx.biophys.uni-duesseldorf.de>
References: <1199387992.3122.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.rz.uni-duesseldorf.de ([134.99.128.30]:46702 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbYACXkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 18:40:14 -0500
In-reply-to: <1199387992.3122.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

Hi all,

> > Anybody who can look into converting the m68k NCR53C9x drivers and has
> > hardware to test (some of) them? I don't think we can afford losing one
> > third of our SCSI drivers...

I can look into converting some (having worked on the m68k Mac ESP driver
in the past - I do recall the Mac driver needs special hacks so it won't
be the easiest one to convert). I have no hardware to test these on,
however.

> > You can use the following as guidance:
> >
> > commit 5ff263667798946abc15314eae3f341345877d7a
> > Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Date:   Tue May 22 17:03:44 2007 -0700
> >
> >     [SCSI] jazz_esp: Converted to use esp_core.
> >
> > 	    Use new esp_scsi for JAZZ SCSI host adapter driver

Hasn't this come up before on linux-m68k? Someone asked me for information
when converting the Mac driver, I think. That could be a good start.

> I can also offer help to anyone who tries this.  It's also a good
> opportunity to let die drivers that have no committed users.

I'll contact you about this, then.

> Just to be clear on why we're doing this:  the NCR53C9x driver on which
> these are all based is in a pretty horrendous state of repair.  The
> esp_scsi one is much nicer, actually nicely tested and has a host of
> features the old driver didn't.  However, the principle driving force is
> the conversion of the SCSI subsystem to the sg_list accessors.  esp_scsi
> is already coverted.  NCR53C9x looks like a nasty job.  Thus, the moment
> the conversion patch goes in, all your drivers will break.  However,

Hmm, does that also affect another of the m68k drivers, the 5380 one? More
headache for me...

	Michael


