From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] block: Fix race on request_queue.end_io invocations
Date: Wed, 6 Jun 2012 06:32:48 +0900
Message-ID: <20120605213248.GB3700@mtj.dyndns.org>
References: <4FCE3D20.4000205@acm.org>
 <4FCE3D77.8040909@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35482 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2FEVc4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jun 2012 17:32:56 -0400
Received: by pbbrp8 with SMTP id rp8so7997446pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jun 2012 14:32:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FCE3D77.8040909@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>

On Tue, Jun 05, 2012 at 05:10:15PM +0000, Bart Van Assche wrote:
> Some request_queue.end_io implementations can be called safely
> without the queue lock held while several other implementations
> assume that the queue lock is held. So let's play it safe and
> make sure that the queue lock is held around end_io invocations.
> Found this through source code review.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Not sure about stable@ tho.  This doesn't fix any visible issue at the
moment and any change carries some risk.

Thanks.

-- 
tejun
