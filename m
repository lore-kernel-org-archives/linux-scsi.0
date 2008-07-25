From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Thu, 24 Jul 2008 22:21:52 -0700 (PDT)
Message-ID: <20080724.222152.193709632.davem@davemloft.net>
References: <Pine.LNX.4.64.0807241727320.12036@devserv.devel.redhat.com>
	<20080724.145336.41899163.davem@davemloft.net>
	<1216957670.4524.87.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1216957670.4524.87.camel@localhost.localdomain>
Sender: linux-parisc-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Thu, 24 Jul 2008 23:47:50 -0400

> I'm sorry sparc broke, really I am ... but you changed your iommu code
> from one with a working vmerge to one without and failed to turn off
> vmerging.  Partly it wasn't noticed because at 2*PAGE_SIZE you have a
> strange vmerge boundary, so it's harder to notice.   However, I can't
> extrapolate that just because this happened on sparc it will inevitably
> happen on all other architectures.

The vmerge boundary on sparc64 was 8K which is equal to sparc64's base
PAGE_SIZE.  I don't know where you get that 2*PAGE_SIZE from.

