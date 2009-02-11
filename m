From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [stable] [PATCH -stable 2.6.28.x] sg: avoid
	blk_put_request/blk_rq_unmap_user in interrupt
Date: Wed, 11 Feb 2009 10:24:56 -0500
Message-ID: <1234365896.3295.20.camel@localhost.localdomain>
References: <20090211145014C.fujita.tomonori@lab.ntt.co.jp>
	 <20090211060558.GB31483@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60861 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbZBKPY7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2009 10:24:59 -0500
In-Reply-To: <20090211060558.GB31483@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stable@kernel.org, rjw@sisk.pl, hias@horus.com, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Tue, 2009-02-10 at 22:05 -0800, Greg KH wrote:
> On Wed, Feb 11, 2009 at 02:50:18PM +0900, FUJITA Tomonori wrote:
> > This patch is against 2.6.28.x, fixes a regression from 2.6.27.
> > 
> > This is the modified version of the following patch that is planed to
> > merged into 2.6.30-rc1 in scsi-misc tree:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=b35fe25ae156830f85a305afaba837b084458e7a
> > 
> > scsi-misc tree has other patches to fix sg oops so the above patch
> > can't be cleanly applied to 2.6.28.x. These patches are too large for
> > 2.6.28.x (needs more testings) so sg in 2.6.28.x still has the oops
> > bugs for now even with this patch. I expect that these patches will go
> > into stable trees too after 2.6.30-rc1 (that is, after more people
> > test them).
> 
> What about 2.6.29?  If it still has this problem as well, why not get
> this patch into that tree now?  Then it can go into the -stable trees.
> As it is, I can't take a patch in the .28.y or .27.y trees that is not
> in Linus's tree.
> 
> confused,

Sorry my fault ... this is a risky change, so we're going to incubate in
misc first, then place in the merge window, then backport to stable.  If
nothing turns up in linux-next, I could move across to rc-fixes and send
upstream earlier ...  I was just wary of the depth of testing in
linux-next.

James


