From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] unexport sg v3 helper functions
Date: Mon, 23 Jul 2007 14:02:22 +0200
Message-ID: <20070723120222.GI11657@kernel.dk>
References: <20070722033008L.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:5465 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbXGWMCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jul 2007 08:02:08 -0400
Content-Disposition: inline
In-Reply-To: <20070722033008L.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Sun, Jul 22 2007, FUJITA Tomonori wrote:
> blk_fill_sghdr_rq, blk_unmap_sghdr_rq, and blk_complete_sghdr_rq were
> exported for bsg, however bsg was changed to support only sg v4.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

