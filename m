From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SCSI git trees
Date: Mon, 3 Aug 2009 23:04:26 +0200
Message-ID: <20090803210426.GY12579@kernel.dk>
References: <1248887256.3900.78.camel@mulgrave.site> <19063.9181.620137.814464@stoffel.org> <1249325826.3943.207.camel@mulgrave.site> <19063.14027.208148.82667@stoffel.org> <20090803202731.GR12579@kernel.dk> <19063.20434.94571.192897@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:42996 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZHCVE0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2009 17:04:26 -0400
Content-Disposition: inline
In-Reply-To: <19063.20434.94571.192897@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Aug 03 2009, John Stoffel wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> On Mon, Aug 03 2009, John Stoffel wrote:
> >> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> >> 
> James> On Mon, 2009-08-03 at 13:52 -0400, John Stoffel wrote:
> >> >> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> >> >> 
> James> It seems I got unsubscribed from linux-scsi last week while I was on
> James> holiday and I've likely missed a slew of patches, it seems like an
> James> appropriate time to remind everyone how the SCSI trees work.
> >> >> 
> James> ---
> >> >> 
> James> There are two git based scsi trees:
> >> >> 
> James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git
> >> >> 
> James> called the scsi-misc tree for patches being collected for the
> James> next merge window.  And
> >> >> 
> >> >> I don't see my patch to block/Kconfig to make BLK_DEV_BSG be enabled
> >> >> by default.  Is this going to be pushed for 2.6.32-rc1 when the merge
> >> >> window opens up?  
> >> >> 
> >> >> I've attached the patch, just to make sure.  Let me know if I should
> >> >> send it in properly.
> >> >> 
> >> >> Thanks!
> >> >> John
> >> >> 
> >> >> 
> >> >> Make Block Layer SG support v4 the default, since recent udev versions
> >> >> depend on this to access serial numbers and other low level info
> >> >> properly.
> >> >> 
> >> >> This should be backported to older kernels as well, since most distros
> >> >> have
> >> >> enabled this for a long time.
> >> >> 
> >> >> Signed-off-by: John Stoffel <john@stoffel.org>
> >> >> ---
> >> >> block/Kconfig |   11 +++++++----
> >> >> 1 files changed, 7 insertions(+), 4 deletions(-)
> >> >> 
> >> >> diff --git a/block/Kconfig b/block/Kconfig
> >> >> index e7d1278..55bbefc 100644
> >> >> --- a/block/Kconfig
> >> >> +++ b/block/Kconfig
> >> 
> James> Actually, this one isn't really SCSI; it's block (Jens cc'd).
> >> 
> >> Thanks for the cc to Jens.  I'd argue that it is SCSI, since it's
> >> about enbabling the Generic SCSI v4 stuff.  But hey, I'd be happy to
> >> see this enabled by default no matter how it goes into the kernel.
> >> 
> James> It's Jens call on the backport, but my feeling is that removing
> James> a feature from experimental is really an enhancement not a bug
> James> fix, so it's not really eligible under the backport rules.
> >> 
> >> Sure, I can understand this, but since the feature has been around for
> >> quite a while, and since most (as I understand it, but haven't
> >> confirmed) distros enable it by default, I think the risk is low.
> >> 
> >> But again, it's not clear to me whether you think A) this should go
> >> into 2.6.32 and B) whether it will go through your tree or if I should
> >> try to push it through Jens.
> >> 
> >> I await the discussion.  It's really a trivial change, and its makes a
> >> huge difference to people using Udev to manage devices properly.
> 
> Jens> Principally, I completely agree with James assessment that it
> Jens> doesn't meet normal stable rules as such. It's not fixing a bug
> Jens> or oops, it's a feature addition. But since this is rather
> Jens> trivial and bsg has been around for ages (and is on in distro
> Jens> kernels), I'm OK with making an exception in this case.
> 
> So you'd be happy to see it pushed to stable@kernel.org for back
> porting, as well as sending it into the 2.6.32 tree when it opens?
> What about 2.6.31?  Just trying to nail down the flow here.

2.6.31 is a must, which means adding it now. If you send the patch, I
can add it to my pending branch for 2.6.31. Once it's in there, we can
add it to -stable and .32 would happen automatically.

-- 
Jens Axboe

