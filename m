From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 16:36:18 +0200
Message-ID: <20071017143618.GR5043@kernel.dk>
References: <20071017203758E.fujita.tomonori@lab.ntt.co.jp> <20071017114117.GA5043@kernel.dk> <20071017205717Q.fujita.tomonori@lab.ntt.co.jp> <20071017210535K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26238 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbXJQOgs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 10:36:48 -0400
Content-Disposition: inline
In-Reply-To: <20071017210535K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tomof@acm.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> > I think that it would be better that IOMMU code handles uninitialized
> > sg entries (sg list can be pretty large). Execpt for sparc64, the
> > IOMMU code can do, I think.
> 
> And I think that with this patch, sparc64 can handle it:
> 
> http://marc.info/?l=linux-scsi&m=119261920425120&w=2

I would tend to agree. Get davem to ack that patch, and we can move it
forward.

-- 
Jens Axboe

