From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/4] drop vmerge accounting
Date: Fri, 22 Aug 2008 11:10:45 +0200
Message-ID: <20080822091044.GA20055@kernel.dk>
References: <20080808055405.GF20055@kernel.dk> <20080808151147J.fujita.tomonori@lab.ntt.co.jp> <20080808061537.GI20055@kernel.dk> <20080808152845N.fujita.tomonori@lab.ntt.co.jp> <20080808063527.GJ20055@kernel.dk> <Pine.LNX.4.64.0808081247430.11647@devserv.devel.redhat.com> <Pine.LNX.4.64.0808081254000.11647@devserv.devel.redhat.com> <20080815094800.GI20055@kernel.dk> <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [93.163.65.50] ([93.163.65.50]:23655 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYHVJmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 05:42:55 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808151418240.24727@hs20-bc2-1.build.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, adel.gadllah@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net, drzeus-mmc@drzeus.cx

On Fri, Aug 15 2008, Mikulas Patocka wrote:
> > I have applied this and the previous, with a fixup to raid5 to overload
> > both active stripe and process count in bi_phys_segments.
> > 
> > -- 
> > Jens Axboe
> 
> Hi
> 
> So here are two new patches. Patch 3 drops blk_queue_max_hw_segments 
> function and max_hw_segments entry. I checked all the drivers, most of 
> them set blk_queue_max_hw_segments equal to blk_queue_max_phys_segments, 
> for the few ones that don't (for example scsi_lib.c), I set minimum of the 
> two values with blk_queue_max_phys_segments.
> 
> The next patch 4 drops the hw_segments logic from MMC card subsystem.

Thanks, I've queued both up for review and inclusion for 2.6.28.

-- 
Jens Axboe

