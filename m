From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Sat, 19 Jul 2008 22:54:56 -0700 (PDT)
Message-ID: <20080719.225456.263046335.davem@davemloft.net>
References: <20080717221908D.fujita.tomonori@lab.ntt.co.jp>
	<20080719.002826.73806419.davem@davemloft.net>
	<Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807192141500.13523@devserv.devel.redhat.com>
Sender: linux-parisc-owner@vger.kernel.org
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Sat, 19 Jul 2008 21:45:11 -0400 (EDT)

> Few days ago I created this.
> 
> Another task would be to remove nr_hw_segments from request, bio and queue 
> parameters (if this patch is accepted).

I'm fine with this:

Acked-by: David S. Miller <davem@davemloft.net>
