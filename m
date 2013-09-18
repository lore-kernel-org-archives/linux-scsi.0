From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: free bios when failing blk_execute_rq_nowait calls
Date: Wed, 18 Sep 2013 08:34:13 -0600
Message-ID: <20130918143413.GC28478@kernel.dk>
References: <1379489869-4492-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab3IROeU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2013 10:34:20 -0400
Content-Disposition: inline
In-Reply-To: <1379489869-4492-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

On Wed, Sep 18 2013, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> If the queue is dying then we only call the rq->end_io callout.
> This leaves bios setup on the request, because the caller assumes when
> the blk_execute_rq_nowait/blk_execute_rq call has completed that
> the rq->bios have been cleaned up.
> 
> This patch has blk_execute_rq_nowait use __blk_end_request_all
> to free bios and also call rq->end_io.

Thanks Mike, applied.

-- 
Jens Axboe

