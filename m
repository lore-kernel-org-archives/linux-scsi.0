From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/4] drop vmerge accounting
Date: Fri, 22 Aug 2008 12:58:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808221254140.315@hs20-bc2-1.build.redhat.com>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp>
 <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
 <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com>
 <20080815094800.GI20055@kernel.dk> <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
 <20080822091044.GA20055@kernel.dk> <20080822091740.GB20055@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbYHVQ6g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 12:58:36 -0400
In-Reply-To: <20080822091740.GB20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net, drzeus-mmc@drzeus.cx



On Fri, 22 Aug 2008, Jens Axboe wrote:

> On Fri, Aug 22 2008, Jens Axboe wrote:
> > On Fri, Aug 15 2008, Mikulas Patocka wrote:
> > > > I have applied this and the previous, with a fixup to raid5 to overload
> > > > both active stripe and process count in bi_phys_segments.
> > > > 
> > > > -- 
> > > > Jens Axboe
> > > 
> > > Hi
> > > 
> > > So here are two new patches. Patch 3 drops blk_queue_max_hw_segments 
> > > function and max_hw_segments entry. I checked all the drivers, most of 
> > > them set blk_queue_max_hw_segments equal to blk_queue_max_phys_segments, 
> > > for the few ones that don't (for example scsi_lib.c), I set minimum of the 
> > > two values with blk_queue_max_phys_segments.
> > > 
> > > The next patch 4 drops the hw_segments logic from MMC card subsystem.
> > 
> > Thanks, I've queued both up for review and inclusion for 2.6.28.
> 
> Spoke too soon, they don't really apply to the for-2.6.28 branch of the
> block git tree that has your two previous patches. Can you please
> recheck and resend against that?
> 
> -- 
> Jens Axboe

I've just cloned 
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git 
and found out that none of my four patches are there. So no wonder that 
patches 3 and 4 won't apply if the patches 1 and 2 aren't there.

What do you want the patches against? git/axboe/linux-2.6-block.git? Or 
something different?

Mikulas
