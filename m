From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Fri, 08 Feb 2008 10:37:00 -0600
Message-ID: <1202488620.3102.33.camel@localhost.localdomain>
References: <1202432206.3171.53.camel@localhost.localdomain>
	 <1202432647.31361.26.camel@brick>
	 <1202432873.3171.58.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802081001540.18242@anakin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57760 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933577AbYBHQhL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 11:37:11 -0500
In-Reply-To: <Pine.LNX.4.64.0802081001540.18242@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Fri, 2008-02-08 at 10:03 +0100, Geert Uytterhoeven wrote:
> On Thu, 7 Feb 2008, James Bottomley wrote:
> > On Thu, 2008-02-07 at 17:04 -0800, Harvey Harrison wrote:
> > > On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> > > > Quite a bit of this is fixing things broken previously (the advansys fix
> > > > is still pending resolution, but I'll send it as an -rc fix when we have
> > > > it).  There's the final elimination of all drivers that are esp based
> > > > but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> > > > the usual bunch of driver updates and the addition of a new enclosure
> > > > services driver and the corresponding ULD.
> > > > 
> > > > The patch is available from:
> > > > 
> > > 
> > > I'm going to guess that this is the entry in feature-removal.txt
> > > that need an update then:
> > > 
> > > ---------------------------
> > > 
> > > What:	old NCR53C9x driver
> > > When:	October 2007
> > > Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > > 	driver can be ported over almost trivially.
> > > Who:	David Miller <davem@davemloft.net>
> > > 	Christoph Hellwig <hch@lst.de>
> > 
> > Not immediately ... I anticipate a few "where'd my driver go?" type
> > questions from m68k for which this provides a useful reference to point
> > to ...
> 
> Don't bother, we're fully aware of this.
> 
> The shortest feature removal notice in Linux's history (is it?) didn't go
> unnoticed ;-)

I don't know where you get that from.  The notice went in on 30 April
2007 and we gave you six months to convert the drivers, hence the
October 2007 date for when the deletion will actually be done.  I've
actually delayed removal until February 2007 giving you a further three
months.  Even then I only removed the drivers because they no longer
compile.

I think nine months isn't unreasonable for a feature removal ... unless
you work on a different time scale from me?

James


