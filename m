From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of
 queue
Date: Thu, 22 Jan 2009 08:24:03 +0900
Message-ID: <20090122082314G.fujita.tomonori@lab.ntt.co.jp>
References: <4976F067.8000501@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34965 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbZAUXYi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 18:24:38 -0500
In-Reply-To: <4976F067.8000501@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Wed, 21 Jan 2009 11:52:39 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> Currently inherited from sg.c bsg will submit asynchronous request
> at the head-of-the-queue, (using "at_head" set in the call to
> blk_execute_rq_nowait()). This is bad in situation where we want
> to keep the queues full but need the requests to execute in order.

As I wrote, I think that blk_execute_rq_nowait inserts a request and
plugs a queue. So how can you keep the queue full? On the completion
of blk_execute_rq_nowait, the queue is empty.
