From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] block: Avoid that request_fn is invoked on a dead
 queue
Date: Wed, 24 Oct 2012 12:13:16 -0700
Message-ID: <20121024191316.GE12182@atj.dyndns.org>
References: <50758EBE.7050202@acm.org>
 <50758F51.3020601@acm.org>
 <20121016233829.GK16166@google.com>
 <50868971.2060209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62670 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030213Ab2JXTNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2012 15:13:24 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1181068iea.19
        for <linux-scsi@vger.kernel.org>; Wed, 24 Oct 2012 12:13:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <50868971.2060209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

Hello, Bart.

On Tue, Oct 23, 2012 at 02:11:29PM +0200, Bart Van Assche wrote:
> >__blk_run_queue_uncond() is a cold path and I don't think adding a
> >test there matters but I think it would be better if we avoid an extra
> >branch if possible for __blk_run_queue().  Can't we merge
> >blk_queue_stopped/dead() testing?
> 
> How about declaring the function __blk_run_queue_uncond() inline ?
> That should allow the compiler to combine the two tests into a
> single test.

Let's leave it as-is for now.  Given the later patches, I no longer
think it would be better to merge the testings.

Thanks!

--
tejun
