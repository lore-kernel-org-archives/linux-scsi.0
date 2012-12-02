From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 09/13] Avoid saving/restoring interrupt state inside
 scsi_remove_host()
Date: Sun, 2 Dec 2012 05:35:30 -0800
Message-ID: <20121202133530.GI15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60880.3050602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2LBNff (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:35:35 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1423025pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:35:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60880.3050602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On Wed, Nov 28, 2012 at 01:50:08PM +0100, Bart Van Assche wrote:
> Since it is not allowed to invoke scsi_remove_host() with interrupts
> disabled, avoid saving and restoring the interrupt state inside
> scsi_remove_host().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

It would be nice to note that this doesn't make any functional
difference in the commit message.

Thanks.

-- 
tejun
