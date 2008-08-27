From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/5] convert sg to use the block layer
Date: Thu, 28 Aug 2008 08:26:49 +0900
Message-ID: <20080828082601S.fujita.tomonori@lab.ntt.co.jp>
References: <20080826075627.GU20055@kernel.dk>
	<20080827111425Y.fujita.tomonori@lab.ntt.co.jp>
	<20080827071018.GX20055@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42388 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbYH0X1M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 19:27:12 -0400
In-Reply-To: <20080827071018.GX20055@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

On Wed, 27 Aug 2008 09:10:18 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> > Thanks, I put an updated version against the for-2.6.28 branch in your
> > tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git sg-block
> > 
> > 
> > Can you wait for a little while before applying this to your
> > for-2.6.28 branch? We need Doug's ACK on this.
> 
> Sure, just let me know...

Now we got Doug's ACK on this (Doug, thanks!). Can you apply them to
your for-2.6.28 branch? I'll resend them if necessary.


> > But I think that it's nice if you can send this to linux-next since
> > testing this patchset on linux-next is good.
> 
> for-2.6.28 is already in linux-next, so once this gets applied it'll get
> tested there as well. And in -mm.

Thanks, I see.
