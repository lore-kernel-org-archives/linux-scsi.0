From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Tue, 20 Mar 2007 04:03:45 +0900
Message-ID: <20070320040345W.fujita.tomonori@lab.ntt.co.jp>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
	<20070214212456.GA17937@kernel.dk>
	<20070319192534A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59505 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbXCSTEm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2007 15:04:42 -0400
In-Reply-To: <20070319192534A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com, hch@infradead.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Mon, 19 Mar 2007 19:25:34 +0900

> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
> Date: Wed, 14 Feb 2007 22:25:00 +0100
> 
> > On Wed, Feb 14 2007, FUJITA Tomonori wrote:
> > > It seems that it would be better to bind bsg devices to request_queue
> > > instead of gendisk. This enables any objects to define own
> > > request_handler and create own bsg device (under sysfs).
> > > 
> > > Possible enhancements:
> > > 
> > > - I removed gendisk but it would be better for objects having gendisk
> > > to keep it for nice features like disk stats.
> > > 
> > > - Objects that wants to use bsg need to setup a request_queue. Maybe
> > > wrapper functions to setup a request_queue for them would be useful.
> > > 
> > > This patch was tested only with disk drivers.
> > 
> > Looks good, as discussed in-person I just want to change the _rq name as
> > that usually implies "struct request" in the block layer. _queue is much
> > better.
> 
> Here is a resend though including the following updates.
> 
> - bsg_register/unregister_rq are renamed bsg_register/unregister_queue
> 
> - fix !CONFIG_BLK_DEV_BSG compilation
> 
> ---
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> This binds bsg devices to request_queue instead of gendisk. It enables
> any objects (like transport entities) to define own request_handler
> and create own bsg device.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Sorry, this patch doesn't work. I'll resend an updated patch later.
