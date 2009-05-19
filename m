From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH resend] scsi_lib: remove unused variable
Date: Tue, 19 May 2009 19:54:32 +0200
Message-ID: <20090519175432.GE4140@kernel.dk>
References: <4A12B62A.9020708@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:60822 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZESRyb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 13:54:31 -0400
Content-Disposition: inline
In-Reply-To: <4A12B62A.9020708@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, May 19 2009, Boaz Harrosh wrote:
> 
> The last request completion cleanup in scsi_lib left an unused
> this_count variable in scsi_io_completion().
> (It was used before in a code segment that now uses blk_end_request_all())
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks, added.

-- 
Jens Axboe

