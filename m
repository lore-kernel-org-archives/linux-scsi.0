From: Christoph Hellwig <hch@infradead.org>
Subject: Re: broken reverse_scan in aic7xxx
Date: Sat, 8 Jul 2006 18:48:44 +0100
Message-ID: <20060708174844.GB29602@infradead.org>
References: <Pine.GSO.3.95.1060708171547.28320A-100000@rcs52.urz.tu-dresden.de> <20060708154449.GE1605@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51369 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964919AbWGHRsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jul 2006 13:48:46 -0400
Content-Disposition: inline
In-Reply-To: <20060708154449.GE1605@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephan Seidl <stephan.seidl@tu-dresden.de>, linux-scsi@vger.kernel.org

On Sat, Jul 08, 2006 at 09:44:49AM -0600, Matthew Wilcox wrote:
> On Sat, Jul 08, 2006 at 05:21:59PM +0200, Stephan Seidl wrote:
> > A victim of the cleaning operation is the option `aic7xxx=reverse_scan'
> > which is still documented, but, which does no longer work. Here is some
> > output.
> > 
> > Since `aic7xxx=reverse_scan' is part of my disaster recovery concept,
> > I would like to ask whether anybody has the resources to reactivate
> > this driver option as it was before ?
> 
> The documentation should be removed ;-)
> 
> It's a simple choice between reverse_scan and supporting PCI hotplug.
> You can't have both, and we chose the latter.  The same choice has been
> made in virtually every other device driver.
> 
> I'm afraid you're going to have to change your concept.

Or you could submit a patch to implement a reverse scanning option in
the core PCI code..

