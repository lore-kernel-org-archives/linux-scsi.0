From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/7] block: Let blk_drain_queue() caller obtain the queue
 lock
Date: Sun, 28 Oct 2012 18:55:50 -0700
Message-ID: <20121029015550.GE5171@htj.dyndns.org>
References: <508A7B63.60608@acm.org>
 <508A7BC0.4070707@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47666 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab2J2Bzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2012 21:55:55 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so3907547pbb.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Oct 2012 18:55:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508A7BC0.4070707@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On Fri, Oct 26, 2012 at 02:02:08PM +0200, Bart Van Assche wrote:
> Let the caller of blk_drain_queue() obtain the queue lock to improve
> readability of the patch called "Avoid that request_fn is invoked on
> a dead queue".
> 
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Chanho Min <chanho.min@lge.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Tejun Heo <tj@kernel.org>

Nit: probably better to make this change right before the said patch.

Thanks.

-- 
tejun
