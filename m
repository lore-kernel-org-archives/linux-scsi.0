From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Wed, 14 Feb 2007 22:25:00 +0100
Message-ID: <20070214212456.GA17937@kernel.dk>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:22032 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629AbXBNVZH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 16:25:07 -0500
Content-Disposition: inline
In-Reply-To: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com, hch@infradead.org

On Wed, Feb 14 2007, FUJITA Tomonori wrote:
> It seems that it would be better to bind bsg devices to request_queue
> instead of gendisk. This enables any objects to define own
> request_handler and create own bsg device (under sysfs).
> 
> Possible enhancements:
> 
> - I removed gendisk but it would be better for objects having gendisk
> to keep it for nice features like disk stats.
> 
> - Objects that wants to use bsg need to setup a request_queue. Maybe
> wrapper functions to setup a request_queue for them would be useful.
> 
> This patch was tested only with disk drivers.

Looks good, as discussed in-person I just want to change the _rq name as
that usually implies "struct request" in the block layer. _queue is much
better.

-- 
Jens Axboe

