From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Tue, 13 Feb 2007 13:00:33 -0500
Message-ID: <20070213180033.GB6798@havoc.gtf.org>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:45498 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXBMSUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Feb 2007 13:20:48 -0500
Content-Disposition: inline
In-Reply-To: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Smart@Emulex.Com, hch@infradead.org

On Wed, Feb 14, 2007 at 02:53:31AM +0900, FUJITA Tomonori wrote:
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
> 
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c            |   37 +++++++++++++++++--------------------

What is this patch against?  scsi-misc?

I certainly like the bsg solution, but block/bsg.c does not exist in my
vanilla linux-2.6.git tree :)

	Jeff



