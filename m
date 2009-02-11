From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH -stable 2.6.28.x] sg: avoid
	blk_put_request/blk_rq_unmap_user in interrupt
Date: Wed, 11 Feb 2009 09:15:18 -0800
Message-ID: <20090211171518.GA16279@kroah.com>
References: <20090211145014C.fujita.tomonori@lab.ntt.co.jp> <20090211060558.GB31483@kroah.com> <1234365896.3295.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:44504 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756536AbZBKRRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 12:17:10 -0500
Content-Disposition: inline
In-Reply-To: <1234365896.3295.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stable@kernel.org, rjw@sisk.pl, hias@horus.com, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, Feb 11, 2009 at 10:24:56AM -0500, James Bottomley wrote:
> On Tue, 2009-02-10 at 22:05 -0800, Greg KH wrote:
> > On Wed, Feb 11, 2009 at 02:50:18PM +0900, FUJITA Tomonori wrote:
> > > This patch is against 2.6.28.x, fixes a regression from 2.6.27.
> > > 
> > > This is the modified version of the following patch that is planed to
> > > merged into 2.6.30-rc1 in scsi-misc tree:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=b35fe25ae156830f85a305afaba837b084458e7a
> > > 
> > > scsi-misc tree has other patches to fix sg oops so the above patch
> > > can't be cleanly applied to 2.6.28.x. These patches are too large for
> > > 2.6.28.x (needs more testings) so sg in 2.6.28.x still has the oops
> > > bugs for now even with this patch. I expect that these patches will go
> > > into stable trees too after 2.6.30-rc1 (that is, after more people
> > > test them).
> > 
> > What about 2.6.29?  If it still has this problem as well, why not get
> > this patch into that tree now?  Then it can go into the -stable trees.
> > As it is, I can't take a patch in the .28.y or .27.y trees that is not
> > in Linus's tree.
> > 
> > confused,
> 
> Sorry my fault ... this is a risky change, so we're going to incubate in
> misc first, then place in the merge window, then backport to stable.  If
> nothing turns up in linux-next, I could move across to rc-fixes and send
> upstream earlier ...  I was just wary of the depth of testing in
> linux-next.

Ok, please let stable@kernel.org know when it goes into Linus's tree and
what needs to be added to the older kernel trees.

thanks,

greg k-h
