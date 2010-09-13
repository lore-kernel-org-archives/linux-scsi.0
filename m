From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Combined storage tree
Date: Mon, 13 Sep 2010 11:46:59 -0500
Message-ID: <1284396419.10388.342.camel@mulgrave.site>
References: <1284143247.6551.23.camel@mulgrave.site>
	 <20100911082054.GF705@dastard> <1284213316.2986.7.camel@mulgrave.site>
	 <20100913025807.GD411@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100913025807.GD411@dastard>
Sender: linux-ide-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-09-13 at 12:58 +1000, Dave Chinner wrote: 
> On Sat, Sep 11, 2010 at 08:55:16AM -0500, James Bottomley wrote:
> > On Sat, 2010-09-11 at 18:20 +1000, Dave Chinner wrote:
> > > On Fri, Sep 10, 2010 at 01:27:27PM -0500, James Bottomley wrote:
> > > > One of the requests from LSF10 in August was the production of a
> > > > combined storage tree.  This is now ready at
> > > > 
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/storage-tree
> > > > 
> > > > It's actually a nightly built merge tree consisting of
> > > > 
> > > > scsi-misc; scsi-rc-fixes
> > > > libata#upstream-fixes, libata#upstream
> > > > block#for-linus, block#for-next
> > > > and the dm quilt (which is empty at the moment).
> > > > 
> > > > I haven't yet added vfs or any of the fs trees, but if necessary, I can.
> > > > 
> > > > Note, because it's built nightly, like linux-next, it's hard (but not
> > > > impossible) to use it as a basis for git trees (it is much easier to use
> > > > it as a basis for quilts).
> > > 
> > > Hmmm. I was kind of hoping for an upstream maintainer tree, kind of
> > > like the netdev tree.  I really don't see a tree like this getting
> > > wide use - if I enjoyed the pain of rebasing against throw-away
> > > merge trees every day, then I'd already be using linux-next....
> > 
> > Well, to be honest, that's what people wanted when the issue was raised
> > at LSF10.  However, unlike net, storage has never had a single
> > maintainer, so it's a bit more political than just doing that by fiat,
> 
> Bah. Technical arguments win here, not politics.

Heh, who runs a tree is both politics and technical.

> Besides, what
> possible political concern can anyone have about using a different
> upstream tree for development? A storage maintainer tree would not
> replace anyone's little fiefdom; what we need is an integration point
> long before stuff gets to Linus....

For a storage git tree to be usable as a stable base, it has to be the
upstream tree.  That would mean that, like net, the way upstream would
be via this tree.  That's quite a shift in the way we currently work.

> > plus not all of the current maintainers with storage trees were there.
> 
> If that's the barrier to discussion, then where else but a dedicated
> storage workshop are you going to get a more representative sample
> of storage developers in the same room?

This sort of thing doesn't get decided by fiat.  If you can't get all of
the relevant parties to agree, you have to demonstrate the need.  So
doing a rollup tree to test how much of the problem is solvable that way
seems like a reasonable first step.

James


