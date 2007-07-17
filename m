From: Jeff Garzik <jeff@garzik.org>
Subject: Re: block/bsg.c
Date: Mon, 16 Jul 2007 21:12:26 -0400
Message-ID: <469C177A.3080002@garzik.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org>	<20070716175347.bea345dd.akpm@linux-foundation.org>	<469C1423.3090908@garzik.org> <20070716180908.e15325bd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38780 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXGQBMd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 21:12:33 -0400
In-Reply-To: <20070716180908.e15325bd.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Yup, but the concern (from Al, iirc) was that someone could change the code
> later on, add a new bug and have that bug hidden by the unneeded
> initialisation.

True.

That's why #gccbug went the safe route, took the cost of extra 
instructions, and initialized it to zero.


> uninitialized_var() has the advantage that it generates no code, whereas "=
> 0" often adds instructions.  Plus of course it is self-documenting, greppable-for
> and centrally alterable.

Agreed.

	Jeff


