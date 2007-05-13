From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Sun, 13 May 2007 12:30:42 +0900
Message-ID: <200705130330.l4D3UsYn029448@mbox.iij4u.or.jp>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp>
	<20070512153023.GA8088@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48613 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646AbXEMDbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 May 2007 23:31:16 -0400
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

Yeah probably. I just thought that it's easier for the driver
maintainers to review separate two patches.
