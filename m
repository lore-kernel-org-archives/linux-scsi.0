From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Thu, 7 Aug 2008 10:20:01 -0700
Message-ID: <20080807172001.GA9773@kroah.com>
References: <1217786532.4179.24.camel@localhost.localdomain> <200808051415.59993.jbarnes@virtuousgeek.org> <1217973297.9923.80.camel@localhost.localdomain> <200808070903.23787.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200808070903.23787.jbarnes@virtuousgeek.org>
Sender: linux-pci-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 07, 2008 at 09:03:22AM -0700, Jesse Barnes wrote:
> On Tuesday, August 5, 2008 2:54 pm James Bottomley wrote:
> > > or somesuch.  That seems just as simple for driver writers as your
> > > initial patch, and the function is named in accordance with what it
> > > actually does, rather than what it's used for...
> >
> > It could, but if the bridge is the culprit (as it usually is for MSI
> > problems), this print won't help identify it.
> >
> > Therefore, rather than give driver writers a recipe for "print this and
> > this and go to the bridge and print this", I'd rather have a single PCI
> > callback that prints all the (hopefully) relevant information that will
> > allow either fixing or blacklisting.
> 
> So in addition to the IRQ type check we need to dump some device topology 
> information... yeah that makes sense.  I wonder if the driver core should 
> provide something like this.  Greg?

What kind of topology do you need that is not already provided?

thanks,

greg k-h
