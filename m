From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: mpt sets 64bit consistent mask yet requires mapping in same 4 GB chunk?!?
Date: Fri, 13 Feb 2004 15:39:00 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213233900.GE504054@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703EF915E@exa-atlanta.se.lsil.com> <20040213213043.GB20323@sgi.com> <200402131552.43935.bjorn.helgaas@hp.com> <20040213231308.GT31168@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:56634 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S267192AbUBMXjS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 18:39:18 -0500
Content-Disposition: inline
In-Reply-To: <20040213231308.GT31168@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jesse Barnes <jbarnes@sgi.com>, "Moore, Eric Dean" <Emoore@lsil.com>, Alex Williamson <alex.williamson@hp.com>, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org

On Fri, Feb 13, 2004 at 11:13:08PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 13, 2004 at 03:52:43PM -0700, Bjorn Helgaas wrote:
> > > I think Alex's second suggestion would be the best--do a single
> > > allocation rather than falling back to a 32 bit consistent mask.
> > 
> > But even with a single allocation, there's nothing to prevent it
> > from crossing a 4GB boundary, is there?
> 
> Since we use buddy allocators everywhere, we'd need to be doing 8GB
> allocations to cross a 4GB barrier.  Of course if we change allocators ...

... and this particular behavior, then I think lots of hardware will
stop working, because LSI is not the only vendor with this sort of
limitation  :-)

jeremy
