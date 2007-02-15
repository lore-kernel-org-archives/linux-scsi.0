From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Thu, 15 Feb 2007 11:13:41 +0900 (JST)
Message-ID: <20070214160236Q.fujita.tomonori@lab.ntt.co.jp>
References: <20070213095318G.fujita.tomonori@lab.ntt.co.jp>
	<20070213180033.GB6798@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:38416 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844AbXBOCO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2007 21:14:27 -0500
In-Reply-To: <20070213180033.GB6798@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Smart@Emulex.Com, hch@infradead.org

From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] bind bsg to request_queue instead of gendisk
Date: Tue, 13 Feb 2007 13:00:33 -0500

> On Wed, Feb 14, 2007 at 02:53:31AM +0900, FUJITA Tomonori wrote:
> > It seems that it would be better to bind bsg devices to request_queue
> > instead of gendisk. This enables any objects to define own
> > request_handler and create own bsg device (under sysfs).
> > 
> > Possible enhancements:
> > 
> > - I removed gendisk but it would be better for objects having gendisk
> > to keep it for nice features like disk stats.
> > 
> > - Objects that wants to use bsg need to setup a request_queue. Maybe
> > wrapper functions to setup a request_queue for them would be useful.
> > 
> > This patch was tested only with disk drivers.
> > 
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  block/bsg.c            |   37 +++++++++++++++++--------------------
> 
> What is this patch against?  scsi-misc?

Oops. As Doug said, it's against Jens's block tree (bsg branch).


> I certainly like the bsg solution, but block/bsg.c does not exist in my
> vanilla linux-2.6.git tree :)

Hopefully we see it in mainline soon. :)
