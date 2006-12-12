From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] remove unnecessary blk_queue_bounce in SG_IO
Date: Tue, 12 Dec 2006 10:27:12 +0100
Message-ID: <20061212092712.GZ4576@kernel.dk>
References: <20061212075212A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:14303 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbWLLJZ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Dec 2006 04:25:57 -0500
Content-Disposition: inline
In-Reply-To: <20061212075212A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 12 2006, FUJITA Tomonori wrote:
> When I converted the origianl patch, I left unnecessary
> blk_queue_bounce in SG_IO.
> 
> ---
> [PATCH] remove unnecessary blk_queue_bounce in SG_IO
> 
> This patch removes blk_queue_bounce in SG_IO since the blk functions
> handle it.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Applied, thanks.

-- 
Jens Axboe

