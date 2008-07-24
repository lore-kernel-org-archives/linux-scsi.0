From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in blk_recalc_rq_segments
 about VMERGE
Date: Thu, 24 Jul 2008 12:34:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807241232040.9412@devserv.devel.redhat.com>
References: <1216520228.3376.33.camel@localhost.localdomain>
 <20080719.210737.197246608.davem@davemloft.net>  <1216565545.4199.10.camel@localhost.localdomain>
  <20080720.102302.137955996.davem@davemloft.net>  <1216575211.4199.35.camel@localhost.localdomain>
  <Pine.LNX.4.64.0807241103190.1545@devserv.devel.redhat.com>
 <1216913314.4524.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1216913314.4524.25.camel@localhost.localdomain>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 24 Jul 2008, James Bottomley wrote:

> On Thu, 2008-07-24 at 11:07 -0400, Mikulas Patocka wrote:
> > So try to #define BIO_VMERGE_BOUNDARY 0 for Pa-Risc and tell us what 
> > performance degradation do you see (and what driver do you use and what is 
> > the I/O pattern).
> > 
> > If you show something specific, we can consider that --- but you haven't 
> > yet told us anything, except generic talk.
> 
> You keep ignoring inconvenient facts.  For about the third time:
> 
> I run a test bed for sg_tables (large chaining of requests).  This runs
> on parisc using virtual merging (has to because the final physical table
> size can't go over the sg list of the SCSI card).  If I turn off virtual
> merging I can no longer test sg_tables in vanilla kernels.
> 
> James

What sg_tables test do you mean? What does the test do? Why couldn't you 
run the test if BIO_VMERGE_BOUNDARY is 0? Normal I/O obviously can work 
with BIO_VMERGE_BOUNDARY 0, the kernel will just send more smaller 
requests.

Mikulas
