From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 10:38:44 -0500
Message-ID: <1186501124.3414.32.camel@localhost.localdomain>
References: <1186248703.3439.20.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	 <1186458941.6637.44.camel@localhost.localdomain>
	 <20070807001429.f8cb3b22.akpm@linux-foundation.org>
	 <1186496712.3414.17.camel@localhost.localdomain>
	 <46B88B91.4050703@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40589 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755697AbXHGPir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 11:38:47 -0400
In-Reply-To: <46B88B91.4050703@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2007-08-07 at 11:11 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > The initial bsg submit went via the block git tree ... which I believe
> > you have in -mm.  We only started taking the updates via the scsi tree
> 
> Seven hours before you posted this, in 
> <20070807001429.f8cb3b22.akpm@linux-foundation.org>, Andrew already 
> noted it was not in -mm.
> 
> A trivial examination of the broken-out mm patches backs up the absence 
>   of Jens' block tree, too.
> 
> So let's put this myth / bad assumption to rest, shall we?

Sorry ... I just assumed from the fact that it had been in the block git
tree for six months that it was also in -mm.

> > Yes ... particularly in large trees like SCSI, there's the maintainer
> > "bugger if I don't mail it out now I don't get it in for another three
> > months" factor.
> 
> That factor always exists.  It's not confined to SCSI or large trees. 
> It's basic the nature of the merge window.  Nothing new or shocking here.
> 
> 
> > bsg had actually been sitting in the block tree since 2.6.21, so it had
> > followed the delayed merge rule ... it just seems that it didn't get
> > enough integration testing in that six months.  This is what I consider
> 
> It didn't get integration testing, at least in part, because it did not 
> hit our official pre-release tree.  Quoth Andrew:
> > I pulled git-scsi-misc on July 19 and there was no bsg code in there at
> > all.  I pulled again on July 20 and all the bsg code was in mainline.
> 
> 
> 
> > I don't disagree; my point is that bsg did follow this rule (in fact it
> 
> Evidence says otherwise.

It followed the rule of trying to stabilise outside mainline ... it just
didn't get sufficient integration testing.

> > I wouldn't call bsg half baked ... it was very carefully matured.  There
> > were just a few integration issues.
> 
> I wouldn't call bsg carefully matured, if in addition to not really 
> gracing -mm with its presence, the userland API structure is still 
> getting changes on July 29, 2007 (0c6a89ba640d28e1dcd7fd1a217d2cfb92ae4953).

This would be the ABI change I talked about in the previous emails.

So would this problem have been fixed simply by adding the missing block
tree to -mm?

James


