From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [13/21] Use blk_q_mask/get_pages_mask in sg driver
Date: Mon, 17 Nov 2008 12:43:38 +0100
Message-ID: <20081117114338.GJ6703@one.firstfloor.org>
References: <20081117102227.GG6703@one.firstfloor.org> <20081117200720M.fujita.tomonori@lab.ntt.co.jp> <20081117112346.GI6703@one.firstfloor.org> <20081117202248D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:37138 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYKQLd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Nov 2008 06:33:59 -0500
Content-Disposition: inline
In-Reply-To: <20081117202248D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: andi@firstfloor.org, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-scsi@vger.kernel.org

> Yeah, I know. It's not nice (as I wrote in the first mail), it doesn't
> work well, etc. But it's not the point (as I wrote in the previous
> mail). I'm against the patch just because I don't think the rules
> about the userspace API permit removing the exiting API like this.

Ok perhaps removing the define was a bit much, but at least stubbing
the ioctl should be transparent to the application.

Ok except that I return EINVAL in the set variant now. I could lie and return 0
instead, although I suspect it wouldn't make much difference either 
way.
 
> 
> If the rules permit, I'm happy to try to remove more old features of
> sg.

As long as old binaries don't break I don't see a problem with
any such changes (afaik that's true for my change)

If you want to break something you have to just go through
feature deprecation and printk, but normally it's only a good
idea to do that if it saves a lot of code or ugliness.

-Andi

-- 
ak@linux.intel.com
