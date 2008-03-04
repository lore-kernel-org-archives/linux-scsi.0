From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 14:03:07 +0100
Message-ID: <20080304130307.GN6704@kernel.dk>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net> <20080304123939.GM6704@kernel.dk> <1204634619.17258.0.camel@homer.simson.net> <1204635515.17258.12.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:15464 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418AbYCDNDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 08:03:12 -0500
Content-Disposition: inline
In-Reply-To: <1204635515.17258.12.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, Mar 04 2008, Mike Galbraith wrote:
> 
> On Tue, 2008-03-04 at 13:43 +0100, Mike Galbraith wrote:
> 
> > > can you please try git as of this morning without any patches applied,
> > > and then pull
> > > 
> > > git://git.kernel.dk/linux-2.6-block.git for-linus
> > > 
> > > into that and see if that works?
> > 
> > I'll give it a shot in a bit.
> 
> Aw poo, so many choices.
> I did:
> 	git add remote block-for-linus git://git.kernel.dk/linux-2.6-block.git
> 	git remote update
> Now, which one do I check out?  block-for-linus/master maybe, or
> block-for-linus/for-linus?

Re-read my original mail! It states that you should just pull:

git://git.kernel.dk/linux-2.6-block.git for-linus

into your linus branch, or just create a test branch off linus' master
and pull into that. IOW, it's the for-linus branch that you should pull,
nothing else.

-- 
Jens Axboe

