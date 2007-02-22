From: Greg KH <gregkh@suse.de>
Subject: Re: [Patch 2/2] cciss: add shutdown support (replaces reboot notifier)
Date: Thu, 22 Feb 2007 15:08:30 -0800
Message-ID: <20070222230830.GA28128@suse.de>
References: <20070222213845.GA14162@beardog.cca.cpqcorp.net> <20070222214502.GA19670@infradead.org> <20070222215611.GB14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbXBVXKY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 18:10:24 -0500
Content-Disposition: inline
In-Reply-To: <20070222215611.GB14162@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@osdl.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 22, 2007 at 03:56:11PM -0600, Mike Miller (OS Dev) wrote:
> On Thu, Feb 22, 2007 at 09:45:02PM +0000, Christoph Hellwig wrote:
> > On Thu, Feb 22, 2007 at 03:38:45PM -0600, Mike Miller (OS Dev) wrote:
> > > Patch 2/2
> > > 
> > > This adds support for struct pci_driver shutdown and negates the previous NAK'ed
> > > reboot_notifier patch. It's much easier, wish I had know about this before. Thanks to
> > > Christoph for pointing this out.
> > 
> > Just sondering, where should we have put information about this so driver
> > writers/maintainers like you would have found it easily?
> > 
> Excellent question. I wish I had a good answer. It's pretty difficult to monitor
> everything going on, especially when I also have to consider HP's schedule and those
> of our partners. 

It is properly documented in Documentation/pci.txt as to how to do
this...

thanks,

greg k-h
