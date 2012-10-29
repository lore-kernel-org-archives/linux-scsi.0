From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] Remove get_device() / put_device() pair from
 scsi_request_fn()
Date: Sun, 28 Oct 2012 19:08:22 -0700
Message-ID: <20121029020822.GI5171@htj.dyndns.org>
References: <508A7B63.60608@acm.org>
 <508A7C9B.5020800@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37447 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab2J2CI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Oct 2012 22:08:27 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so3068235pad.19
        for <linux-scsi@vger.kernel.org>; Sun, 28 Oct 2012 19:08:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <508A7C9B.5020800@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On Fri, Oct 26, 2012 at 02:05:47PM +0200, Bart Van Assche wrote:
> Since all scsi_request_fn() callers hold a reference on the

Maybe s/Since/Now that/

> SCSI device that function is invoked for and since
> blk_cleanup_queue() waits until scsi_request_fn() has finished
> it is safe to remove the get_device() / put_device() pair from
> scsi_request_fn().
> 
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
