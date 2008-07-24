From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Thu, 24 Jul 2008 11:07:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807241103190.1545@devserv.devel.redhat.com>
References: <1216520228.3376.33.camel@localhost.localdomain>
 <20080719.210737.197246608.davem@davemloft.net>  <1216565545.4199.10.camel@localhost.localdomain>
  <20080720.102302.137955996.davem@davemloft.net> <1216575211.4199.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1216575211.4199.35.camel@localhost.localdomain>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> > For a dumb I/O card, you advertise SG_ALL capabilities, the IOMMU
> > is going to merge things as it would have anyways, and you have
> > code in the driver to advance SG entries after each "dumb I/O".
> 
> Not that dumb ... they just have a limited number of SG slots.  We
> wouldn't want to run them as spoon fed PIO because that really would
> kill performance.
> 
> > There is zero value to the vmerge code, the real gains are being
> > realized already.
> 
> There is value to me in my testbed, which I can't achieve any other way
> (except by buying different SCSI cards).
> 
> As I said, you can compile it out on sparc just fine.  I wish to keep it
> running for parisc, so I'll maintain it.  If it ever bit rots out of
> parisc like it has done for the other architectures, then feel free to
> remove it.
> 
> James

So try to #define BIO_VMERGE_BOUNDARY 0 for Pa-Risc and tell us what 
performance degradation do you see (and what driver do you use and what is 
the I/O pattern).

If you show something specific, we can consider that --- but you haven't 
yet told us anything, except generic talk.

Mikulas
