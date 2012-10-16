From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] block: Rename queue dead flag
Date: Tue, 16 Oct 2012 16:31:02 -0700
Message-ID: <20121016233102.GJ16166@google.com>
References: <50758EBE.7050202@acm.org>
 <50758F1C.9030005@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2JPXbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2012 19:31:07 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so6471021pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 16 Oct 2012 16:31:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50758F1C.9030005@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On Wed, Oct 10, 2012 at 05:07:08PM +0200, Bart Van Assche wrote:
> QUEUE_FLAG_DEAD is used to indicate that queuing new requests must
> stop. After this flag has been set queue draining starts. However,
> during the queue draining phase it is still safe to invoke the
> queue's request_fn, so QUEUE_FLAG_DYING is a better name for this
> flag.
> 
> This patch is the result of running the command below and manually
> fixing up indentation:
> 
> git grep -lE 'blk_queue_dead|QUEUE_FLAG_DEAD' |
>   xargs sed -i.tmp -e 's/blk_queue_dead/blk_queue_dying/g' \
> 	-e 's/QUEUE_FLAG_DEAD/QUEUE_FLAG_DYING/g'
> 
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Chanho Min <chanho.min@lge.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
