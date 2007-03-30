From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: minor bug fixes
Date: Fri, 30 Mar 2007 08:38:04 +0200
Message-ID: <20070330063804.GE6320@kernel.dk>
References: <20070330103902U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:7983 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXC3GnF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2007 02:43:05 -0400
Content-Disposition: inline
In-Reply-To: <20070330103902U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 30 2007, FUJITA Tomonori wrote:
> This fixes the following minor issues:
> 
> - When bsg_register_queue is called with a request queue that doesn't
> have request_fn, it returns -EINVAL instead of zero.

Seems a little backwards, you wont be able to talk to the device then.
So, what is the purpose of this patch?

> - add EXPORT_SYMBOL_GPL for bsg_register_queue and
> bsg_unregister_queue.

ok

> - shut up gcc warnings

ok


-- 
Jens Axboe

