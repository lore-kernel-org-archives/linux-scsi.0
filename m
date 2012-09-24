From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] block: Rename queue dead flag
Date: Mon, 24 Sep 2012 12:27:12 -0700
Message-ID: <20120924192712.GA29689@google.com>
References: <505F35C9.6070509@acm.org>
 <505F362D.4020206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38461 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757598Ab2IXT1Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Sep 2012 15:27:16 -0400
Received: by padhz1 with SMTP id hz1so1130824pad.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Sep 2012 12:27:16 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <505F362D.4020206@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Chanho Min <chanho.min@lge.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, James Bottomley <jbottomley@parallels.com>

Hello,

On Sun, Sep 23, 2012 at 06:17:49PM +0200, Bart Van Assche wrote:
> This patch is the result of running the command below and manually
> fixing up indentation:
> 
> git grep -lE 'blk_queue_dead|QUEUE_FLAG_DEAD' |
>   xargs sed -i .tmp -e 's/blk_queue_dead/blk_queue_dying/g' \
> 	-e 's/QUEUE_FLAG_DEAD/QUEUE_FLAG_DYING/g'

Can you please explain why this change is being made in the patch
description?

Thanks.

-- 
tejun
