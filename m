From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] qla1820 iomem annotations
Date: Thu, 21 Oct 2004 18:30:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021173057.GC24336@parcelfarce.linux.theplanet.co.uk>
References: <20041020235837.GC23987@parcelfarce.linux.theplanet.co.uk> <20041021090032.GA1941@infradead.org> <20041021151406.GB24336@parcelfarce.linux.theplanet.co.uk> <20041021172547.GA8242@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45727 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270732AbUJURa6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 13:30:58 -0400
Content-Disposition: inline
In-Reply-To: <20041021172547.GA8242@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-scsi@vger.kernel.org

On Thu, Oct 21, 2004 at 06:25:47PM +0100, Christoph Hellwig wrote:
> On Thu, Oct 21, 2004 at 04:14:06PM +0100, Al Viro wrote:
> > On Thu, Oct 21, 2004 at 10:00:32AM +0100, Christoph Hellwig wrote:
> > > This breaks old-style PIO support in this driver which is required for the
> > > Visual Workstations.
> > 
> > Where?  __iomem is #defined to nothing for gcc.  So that leaves only
> > the chunk below as theoretically possible source of changes, right?
> 
> Sorry, this was totlly misworked.  What I actually meant is that it gives
> the sparse warnings again in the PIO-config, so you trade sparse warnings
> for one variant vs ones for another variant.

Huh?  We _already_ have these guys as pointers; so PIO variants were not
any happier with non-iomem ones.

Details, please...
