From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 08 May 2007 22:30:59 +0900
Message-ID: <200705081330.l48DUxOp006228@mbox.iij4u.or.jp>
References: <20070508122134.GI4163@kernel.dk>
	<20070508215620M.fujita.tomonori@lab.ntt.co.jp>
	<20070508130032.GJ4163@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48387 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934134AbXEHNbZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 May 2007 09:31:25 -0400
In-Reply-To: <20070508130032.GJ4163@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, Daniel.E.Messinger@seagate.com, tomof@acm.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 8 May 2007 15:00:32 +0200

> On Tue, May 08 2007, FUJITA Tomonori wrote:
> > BTW, any comments on the bidi patch for the block layer?
> 
> Yeah it looks much better. I agree with your notion that bidi should be
> block layer agnostic at least for now (until a general use comes up),
> it's just a way to transport these commands. And I do still prefer
> ->next_rq as the pointer name for partly those reasons.

Thanks for the comments. Seems that the block layer part is done. And
my patch uses ->next_rq pointer name:

http://marc.info/?l=linux-scsi&m=117835587615642&w=2
