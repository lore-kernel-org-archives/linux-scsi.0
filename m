From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Sat, 19 Jul 2008 21:07:37 -0700 (PDT)
Message-ID: <20080719.210737.197246608.davem@davemloft.net>
References: <20080719.002826.73806419.davem@davemloft.net>
	<Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
	<1216520228.3376.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1216520228.3376.33.camel@localhost.localdomain>
Sender: linux-parisc-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: mpatocka@redhat.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 19 Jul 2008 21:17:08 -0500

> Try this patch

I'd rather remove the vmerge code, it doesn't buy us
anything, and for something so complex and so hard to
keep working correctly it's existence is far from
justified these days.
