From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
	block/for-2.6.31 tree
Date: Wed, 20 May 2009 21:10:16 +0200
Message-ID: <20090520191016.GC11363@kernel.dk>
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com> <20090520111619.87f815b1.sfr@canb.auug.org.au> <1242830240.2881.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:32984 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZETTKP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 15:10:15 -0400
Content-Disposition: inline
In-Reply-To: <1242830240.2881.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, May 20 2009, James Bottomley wrote:
> On Wed, 2009-05-20 at 11:16 +1000, Stephen Rothwell wrote:
> > On Tue, 19 May 2009 15:54:59 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:
> > >
> > > 
> > > This patch should be squashed into
> > >     [SCSI] FC Pass Thru support
> > > 
> > > If it needs to compile after Tejun's block-layer revamps
> > > (all of them)
> > 
> > Is there some reason that the FC passthrough support (and any followup
> > patches) can't be pushed through the block tree.  It clearly currently
> > doesn't depend on anything new in the scsi tree ...
> 
> That would preserve the logical sequence of patches, yes.  However, Jens
> is a bit pressed for time, so I agreed to do this in SCSI.
> 
> Unfortuantely, I still need the block tree for-next to be rebased up to
> the current linus head because of a couple of conflicts:
> 
> CONFLICT (content): Merge conflict in drivers/block/hd.c
> CONFLICT (content): Merge conflict in drivers/block/mg_disk.c
> 
> The are both just rebase/rebase conflicts:  it looks like there are two
> commit ids for 

James, I'll get this fixed (either pull linus tree in or rebase) and
send you a note! It wont be before tomorrow, I think.

-- 
Jens Axboe

