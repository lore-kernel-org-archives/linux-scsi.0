From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/13 v6] More device removal fixes
Date: Thu, 06 Dec 2012 14:33:57 +0100
Message-ID: <50C09EC5.7010105@kernel.dk>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755022Ab2LFNeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2012 08:34:23 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On 2012-11-28 13:39, Bart Van Assche wrote:
> Fix a few race conditions that can be triggered by removing a device:
> - Avoid that request_fn() can be invoked on a dead queue.
> - Avoid that blk_cleanup_queue() can finish while request_fn is still
>   running.
> - Fix a race between starved list processing and device removal.
> - Avoid that a SCSI LLD callback can be invoked after scsi_remove_host()
>   finished.
> - Speed up device removal by stopping error handling as soon as
>   scsi_remove_host() started.

Bart, I've applied 1-6 to the block 3.8 tree. I still am not super happy
with 5/6, but I don't have any better ideas at the moment.

-- 
Jens Axboe

