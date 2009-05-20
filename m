From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
	block/for-2.6.31 tree
Date: Wed, 20 May 2009 14:47:45 +0000
Message-ID: <1242830865.2881.13.camel@localhost.localdomain>
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com>
	 <20090520111619.87f815b1.sfr@canb.auug.org.au>
	 <1242830240.2881.10.camel@localhost.localdomain>
	 <20090521004251.9160e228.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53057 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756389AbZETOrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2009 10:47:42 -0400
In-Reply-To: <20090521004251.9160e228.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On Thu, 2009-05-21 at 00:42 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> On Wed, 20 May 2009 14:37:20 +0000 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >
> > Unfortuantely, I still need the block tree for-next to be rebased up to
> > the current linus head because of a couple of conflicts:
> > 
> > CONFLICT (content): Merge conflict in drivers/block/hd.c
> > CONFLICT (content): Merge conflict in drivers/block/mg_disk.c
> 
> As discussed elsewhere, a merge of Linus' tree into the block tree will
> fix this.

Yes, I know, I was just adding urgency because scsi-misc has the two
conflicting commits in it, so it can't be merged into block for-next.

> > So they obviously moved into linus head but wasn't taken out of block
> > for-next.
> 
> Indeed.

OK, so I think your pulling of my posmerge tree can cope with the fact
that I did the necessary rebasing in block for-next before I made it the
base of my combined tree .... think of this as a nice test.

Just building now ... if it works, I'll push to SCSI post merge and all
our problems should go away.

James


