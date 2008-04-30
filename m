From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: add large command support
Date: Wed, 30 Apr 2008 15:40:15 +0200
Message-ID: <20080430134015.GE12774@kernel.dk>
References: <20080430131616O.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:15383 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090AbYD3NkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2008 09:40:20 -0400
Content-Disposition: inline
In-Reply-To: <20080430131616O.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, pw@osc.edu

On Wed, Apr 30 2008, FUJITA Tomonori wrote:
> This is against Linus' tree since this depends on the large command
> support of the block layer, which was merged few hours ago.
> 
> This can be applied now since it doesn't depend on Boaz's variable
> length CDB support though this is useful only for the variable length
> CDB.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] bsg: add large command support
> 
> This enables bsg to handle the request length larger than BLK_MAX_CDB
> (mainly for the variable length CDB format).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Pete Wyckoff <pw@osc.edu>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  block/bsg.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

