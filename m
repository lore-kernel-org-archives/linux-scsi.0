From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Mon, 11 Feb 2008 16:02:22 -0600
Message-ID: <1202767342.3122.61.camel@localhost.localdomain>
References: <1202432206.3171.53.camel@localhost.localdomain>
	 <1202432647.31361.26.camel@brick>
	 <1202432873.3171.58.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0802081001540.18242@anakin>
	 <1202488620.3102.33.camel@localhost.localdomain>
	 <1202764411.10004.15.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41776 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbYBKWCa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 17:02:30 -0500
In-Reply-To: <1202764411.10004.15.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

On Mon, 2008-02-11 at 13:13 -0800, Harvey Harrison wrote:
> On Fri, 2008-02-08 at 10:37 -0600, James Bottomley wrote:
> > On Fri, 2008-02-08 at 10:03 +0100, Geert Uytterhoeven wrote:
> > > On Thu, 7 Feb 2008, James Bottomley wrote:
> > > > On Thu, 2008-02-07 at 17:04 -0800, Harvey Harrison wrote:
> > > > > I'm going to guess that this is the entry in feature-removal.txt
> > > > > that need an update then:
> > > > > 
> > > > > ---------------------------
> > > > > 
> > > > > What:	old NCR53C9x driver
> > > > > When:	October 2007
> > > > > Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > > > > 	driver can be ported over almost trivially.
> > > > > Who:	David Miller <davem@davemloft.net>
> > > > > 	Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Not immediately ... I anticipate a few "where'd my driver go?" type
> > > > questions from m68k for which this provides a useful reference to point
> > > > to ...
> > > 
> > > Don't bother, we're fully aware of this.
> > > 
> > > The shortest feature removal notice in Linux's history (is it?) didn't go
> > > unnoticed ;-)
> 
> So....would a patch be welcome to remove this entry then?

Not at the moment for the reasons I already gave.  Ping me in about
three months if it's not gone by then.

James



