From: Jeff Garzik <jeff@garzik.org>
Subject: Re: block/bsg.c
Date: Mon, 16 Jul 2007 20:47:45 -0400
Message-ID: <469C11B1.8000302@garzik.org>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38213 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbXGQAr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 20:47:57 -0400
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> The modern way of shutting up gcc is uninitialized_var().


Should I convert my misc-2.6.git#gccbug repository over to this, and 
push upstream?

#gccbug branch is a set of places where I have verified that the 
variable is indeed initialized, even though gcc complains it may not be.

	Jeff


