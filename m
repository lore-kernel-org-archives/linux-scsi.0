From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Fri, 8 Aug 2008 08:35:27 +0200
Message-ID: <20080808063527.GJ20055@kernel.dk>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp> <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23985 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYHHGf3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 02:35:29 -0400
Content-Disposition: inline
In-Reply-To: <20080808152845N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net, mpatocka@redhat.com

On Fri, Aug 08 2008, FUJITA Tomonori wrote:
> On Fri, 8 Aug 2008 08:15:37 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > BTW, we also wait for your verdict on:
> > > 
> > > http://marc.info/?t=121611935500002&r=1&w=2
> > 
> > I've always hated the iommu virtual merging complexity. My plan is to
> > rip it out.
> 
> No complaint from me. I'm just happy to see the verdict at length.

Mikulas, you had a patch for this. Can you strip out the arch bits and
just send me the block bits? The arch bits should go in via the arch
maintainers.

The iommu code may still do virtual merging, it would be silly not to do
that if possible. Now that later kernels expose the necessary parameters
at that level as well, it's perfectly feasible.

-- 
Jens Axboe

