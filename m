From: Dave Chinner <david@fromorbit.com>
Subject: Re: Combined storage tree
Date: Mon, 13 Sep 2010 12:58:07 +1000
Message-ID: <20100913025807.GD411@dastard>
References: <1284143247.6551.23.camel@mulgrave.site>
 <20100911082054.GF705@dastard>
 <1284213316.2986.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:60880 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754280Ab0IMC6N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2010 22:58:13 -0400
Content-Disposition: inline
In-Reply-To: <1284213316.2986.7.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>

On Sat, Sep 11, 2010 at 08:55:16AM -0500, James Bottomley wrote:
> On Sat, 2010-09-11 at 18:20 +1000, Dave Chinner wrote:
> > On Fri, Sep 10, 2010 at 01:27:27PM -0500, James Bottomley wrote:
> > > One of the requests from LSF10 in August was the production of a
> > > combined storage tree.  This is now ready at
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/storage-tree
> > > 
> > > It's actually a nightly built merge tree consisting of
> > > 
> > > scsi-misc; scsi-rc-fixes
> > > libata#upstream-fixes, libata#upstream
> > > block#for-linus, block#for-next
> > > and the dm quilt (which is empty at the moment).
> > > 
> > > I haven't yet added vfs or any of the fs trees, but if necessary, I can.
> > > 
> > > Note, because it's built nightly, like linux-next, it's hard (but not
> > > impossible) to use it as a basis for git trees (it is much easier to use
> > > it as a basis for quilts).
> > 
> > Hmmm. I was kind of hoping for an upstream maintainer tree, kind of
> > like the netdev tree.  I really don't see a tree like this getting
> > wide use - if I enjoyed the pain of rebasing against throw-away
> > merge trees every day, then I'd already be using linux-next....
> 
> Well, to be honest, that's what people wanted when the issue was raised
> at LSF10.  However, unlike net, storage has never had a single
> maintainer, so it's a bit more political than just doing that by fiat,

Bah. Technical arguments win here, not politics. Besides, what
possible political concern can anyone have about using a different
upstream tree for development? A storage maintainer tree would not
replace anyone's little fiefdom; what we need is an integration point
long before stuff gets to Linus....

> plus not all of the current maintainers with storage trees were there.

If that's the barrier to discussion, then where else but a dedicated
storage workshop are you going to get a more representative sample
of storage developers in the same room?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
