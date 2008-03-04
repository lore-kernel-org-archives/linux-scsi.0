From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 19:29:25 +0100
Message-ID: <20080304182925.GQ6704@kernel.dk>
References: <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net> <20080304123939.GM6704@kernel.dk> <1204634619.17258.0.camel@homer.simson.net> <1204635515.17258.12.camel@homer.simson.net> <20080304130307.GN6704@kernel.dk> <1204640722.5783.10.camel@homer.simson.net> <20080304181736.GP6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:2886 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYCDS3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 13:29:30 -0500
Content-Disposition: inline
In-Reply-To: <20080304181736.GP6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, Mar 04 2008, Jens Axboe wrote:
> On Tue, Mar 04 2008, Mike Galbraith wrote:
> > 
> > On Tue, 2008-03-04 at 14:03 +0100, Jens Axboe wrote:
> > 
> > > Re-read my original mail! It states that you should just pull:
> > > 
> > > git://git.kernel.dk/linux-2.6-block.git for-linus
> > > 
> > > into your linus branch, or just create a test branch off linus' master
> > > and pull into that. IOW, it's the for-linus branch that you should pull,
> > > nothing else.
> > 
> > Well, I had a good reason.  You know how to un-pull, I know how to
> > un-remote to get back to pristine after I'm done testing... guaranteed
> > without whimpering pathetically on the git list ;-)
> 
> OK, if you're on master, it's pretty easy:
> 
> $ git branch test-branch
> $ git checkout test-branch
> $ git pull git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> [build, boot, test]
> $ git checkout master
> $ git branch -D test-branch
> 
> > Anyway, I checked out the one with the big-fat-hint in it's name
> > (block-for-linus/for-linus).
> > Same error.  Git this morning with patches...
> > 	restore_meaning_of_data_len.diff
> > 	seperate_out_padding_from_alignment.diff
> > ...reverted restored me to the originally reported k3b error, nothing
> > new noted.
> > 
> > If I tested the wrong branch, whack me upside the head, and I'll follow
> > your pull destructions, and figure out how to un-pull later.
> 
> for-linus is the right branch, but I'm just a little worried that you
> didn't test what you think you tested. What does cat .git/HEAD say? If
> that is a ref to a file (eg refs/heads/master), what does that file
> contain?

Or just re-pull Linus' tree, the stuff is in now.

-- 
Jens Axboe

