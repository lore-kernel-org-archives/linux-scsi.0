From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: minor bug fixes
Date: Fri, 30 Mar 2007 11:18:09 +0200
Message-ID: <20070330091809.GD6246@kernel.dk>
References: <20070330103902U.fujita.tomonori@lab.ntt.co.jp> <20070330063804.GE6320@kernel.dk> <20070330173626P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:4337 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945948AbXC3JXM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2007 05:23:12 -0400
Content-Disposition: inline
In-Reply-To: <20070330173626P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Fri, Mar 30 2007, FUJITA Tomonori wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Subject: Re: [PATCH] bsg: minor bug fixes
> Date: Fri, 30 Mar 2007 08:38:04 +0200
> 
> > On Fri, Mar 30 2007, FUJITA Tomonori wrote:
> > > This fixes the following minor issues:
> > > 
> > > - When bsg_register_queue is called with a request queue that doesn't
> > > have request_fn, it returns -EINVAL instead of zero.
> > 
> > Seems a little backwards, you wont be able to talk to the device then.
> 
> What do you mean? All the devices that we might bind to bsg has
> request_fn?

They have to, how else would you send commands to it?

> > So, what is the purpose of this patch?
> 
> When I wrote a SMP pass through interface via bsg, I thought that it
> would be better to return an error instead of success when we call
> bsg_register_queue with a request queue that doesn't have a
> request_fn.
> 
> 
> Anyway, it doesn't matter much. Here is a new version.

Aplied this one.

-- 
Jens Axboe

