From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Mon, 14 May 2007 23:40:03 +0900
Message-ID: <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>
	<20070512153023.GA8088@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:40626 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbXENOkx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 May 2007 10:40:53 -0400
In-Reply-To: <20070512153023.GA8088@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Sat, 12 May 2007 16:30:23 +0100

> On Sat, May 12, 2007 at 07:05:42PM +0900, FUJITA Tomonori wrote:
> > There are two patches for each driver, removing the non-use-sg code
> > and converting to use the accessors.
> 
> One patch would probably be fine aswell.

I merged the two. And I finished cleaning up 35 drivers in total.

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git cleanups
