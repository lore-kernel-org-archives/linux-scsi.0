From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: mpt sets 64bit consistent mask yet requires mapping in same 4
	 GB chunk?!?
Date: Fri, 13 Feb 2004 18:23:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E5703EF9182@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40918 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264353AbUBMXYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 18:24:10 -0500
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@sgi.com>, Alex Williamson <alex.williamson@hp.com>, jeremy@sgi.com, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org

I will investigate, and see what can be done.
Thanks for your feedback.

Eric

> 
> 
> On Fri, Feb 13, 2004 at 03:52:43PM -0700, Bjorn Helgaas wrote:
> > > I think Alex's second suggestion would be the best--do a single
> > > allocation rather than falling back to a 32 bit consistent mask.
> > 
> > But even with a single allocation, there's nothing to prevent it
> > from crossing a 4GB boundary, is there?
> 
> Since we use buddy allocators everywhere, we'd need to be doing 8GB
> allocations to cross a 4GB barrier.  Of course if we change 
> allocators ...
> 
> -- 
> "Next the statesmen will invent cheap lies, putting the blame upon 
> the nation that is attacked, and every man will be glad of those
> conscience-soothing falsities, and will diligently study 
> them, and refuse
> to examine any refutations of them; and thus he will by and 
> by convince 
> himself that the war is just, and will thank God for the better sleep 
> he enjoys after this process of grotesque self-deception." -- 
> Mark Twain
> 
