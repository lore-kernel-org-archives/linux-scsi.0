From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] block: Fix blk_execute_rq_nowait() dead queue
 handling
Date: Mon, 25 Jun 2012 11:41:12 -0700
Message-ID: <20120625184112.GI3869@google.com>
References: <4FE8A9FC.6040805@acm.org>
 <4FE8AA77.5050005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42222 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2FYSlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 14:41:17 -0400
Received: by dady13 with SMTP id y13so5691807dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2012 11:41:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FE8AA77.5050005@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Muthu Kumar <muthu.lkml@gmail.com>, Muthukumar Ratty <muthur@gmail.com>

On Mon, Jun 25, 2012 at 06:14:15PM +0000, Bart Van Assche wrote:
> From: Muthukumar Ratty <muthur@gmail.com>
> 
> If the queue is dead blk_execute_rq_nowait() doesn't invoke the done()
> callback function. That will result in blk_execute_rq() being stuck
> in wait_for_completion(). Avoid this by initializing rq->end_io to the
> done() callback before we check the queue state. Also, make sure the
> queue lock is held around the invocation of the done() callback. Found
> this through source code review.
> 
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot!

-- 
tejun
