From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH version 2] New blk_make_request(), takes bio, returns a
	request
Date: Tue, 19 May 2009 19:53:43 +0200
Message-ID: <20090519175343.GD4140@kernel.dk>
References: <4A1032B0.5000003@panasas.com> <4A1033DB.2030908@panasas.com> <4A12B589.1070003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:60807 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbZESRxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 13:53:42 -0400
Content-Disposition: inline
In-Reply-To: <4A12B589.1070003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

On Tue, May 19 2009, Boaz Harrosh wrote:
> 
> New block API:
> given a struct bio allocates a new request. This is the parallel of
> generic_make_request for BLOCK_PC commands users.
> 
> The passed bio may be a chained-bio. The bio is bounced if needed
> inside the call to this member.
> 
> This is in the effort of un-exporting blk_rq_append_bio().

Thanks. I had already applied your previous patch, so I just copied the
new lines and added those.

-- 
Jens Axboe

