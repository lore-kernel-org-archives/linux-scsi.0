From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/5] block: add gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
Date: Thu, 28 Aug 2008 09:34:13 +0200
Message-ID: <20080828073413.GS20055@kernel.dk>
References: <20080828070725.GP20055@kernel.dk> <1219907829-27365-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:44930 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbYH1HeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 03:34:16 -0400
Content-Disposition: inline
In-Reply-To: <1219907829-27365-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Thu, Aug 28 2008, FUJITA Tomonori wrote:
> Currently, blk_rq_map_user and blk_rq_map_user_iov always do
> GFP_KERNEL allocation.
> 
> This adds gfp_mask argument to blk_rq_map_user and blk_rq_map_user_iov
> so sg can use it (sg always does GFP_ATOMIC allocation).

Thanks for the (quick!) resend, earns you another shining star to place
on the refrigerator!

I've applied them, thanks again Tomo.

-- 
Jens Axboe

