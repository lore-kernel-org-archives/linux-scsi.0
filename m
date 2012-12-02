From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/13 v6] More device removal fixes
Date: Sun, 2 Dec 2012 06:02:13 -0800
Message-ID: <20121202140213.GP15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45250 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2LBOCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 09:02:18 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1429665pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 06:02:18 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello, Bart.

On Wed, Nov 28, 2012 at 01:39:53PM +0100, Bart Van Assche wrote:
> Fix a few race conditions that can be triggered by removing a device:
> - Avoid that request_fn() can be invoked on a dead queue.
> - Avoid that blk_cleanup_queue() can finish while request_fn is still
>   running.
> - Fix a race between starved list processing and device removal.
> - Avoid that a SCSI LLD callback can be invoked after scsi_remove_host()
>   finished.
> - Speed up device removal by stopping error handling as soon as
>   scsi_remove_host() started.
> 
> These patches have been tested on top of kernel v3.7-rc7.

Awesome work.  I had some nits but would be happy if the whole
patchset gets merged right now.  It's embarrassing that we are *still*
this broken and, nits aside, all the patches seem correct and to the
point.

Jens, James?  Except for the last few SCSI patches, this patchset has
now been around for quite a while.  Any chance to fast-track these?

Thanks.

-- 
tejun
