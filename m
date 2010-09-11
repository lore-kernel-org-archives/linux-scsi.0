From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Combined storage tree
Date: Sat, 11 Sep 2010 08:55:16 -0500
Message-ID: <1284213316.2986.7.camel@mulgrave.site>
References: <1284143247.6551.23.camel@mulgrave.site>
	 <20100911082054.GF705@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100911082054.GF705@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2010-09-11 at 18:20 +1000, Dave Chinner wrote:
> On Fri, Sep 10, 2010 at 01:27:27PM -0500, James Bottomley wrote:
> > One of the requests from LSF10 in August was the production of a
> > combined storage tree.  This is now ready at
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/storage-tree
> > 
> > It's actually a nightly built merge tree consisting of
> > 
> > scsi-misc; scsi-rc-fixes
> > libata#upstream-fixes, libata#upstream
> > block#for-linus, block#for-next
> > and the dm quilt (which is empty at the moment).
> > 
> > I haven't yet added vfs or any of the fs trees, but if necessary, I can.
> > 
> > Note, because it's built nightly, like linux-next, it's hard (but not
> > impossible) to use it as a basis for git trees (it is much easier to use
> > it as a basis for quilts).
> 
> Hmmm. I was kind of hoping for an upstream maintainer tree, kind of
> like the netdev tree.  I really don't see a tree like this getting
> wide use - if I enjoyed the pain of rebasing against throw-away
> merge trees every day, then I'd already be using linux-next....

Well, to be honest, that's what people wanted when the issue was raised
at LSF10.  However, unlike net, storage has never had a single
maintainer, so it's a bit more political than just doing that by fiat,
plus not all of the current maintainers with storage trees were there.
So we agreed (reluctantly) to start with an automatic tree and see how
much of the current problem that solved.  If the automatic tree turns
out not to be very useful, we can revisit the idea of a storage
maintainer.

The reason for being storage only rather than saying just use linux-next
(which was mentioned) is that next is a much bigger tree, so it's harder
to follow.  The diffs to mainline in the current storage tree are still
under a megabyte.

James


