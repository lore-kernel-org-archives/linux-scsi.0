From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 04/13] block: Avoid scheduling delayed work on a dead
 queue
Date: Sun, 2 Dec 2012 05:59:25 -0800
Message-ID: <20121202135925.GO15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60784.1080604@acm.org>
 <20121202132613.GD15930@mtj.dyndns.org>
 <50BB5A80.5010600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:52869 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2LBN7a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:59:30 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so925323dak.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:59:30 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50BB5A80.5010600@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hello, Bart.

On Sun, Dec 02, 2012 at 02:41:20PM +0100, Bart Van Assche wrote:
> I agree. There is a reason though I have not yet added a
> lockdep_assert_held() statement in these functions: there are still
> unprotected calls of blk_run_queue_async() in drivers/md/dm.c and
> drivers/scsi/scsi_transport_fc.c.

Hmmm... that's nasty.  Any chance you can fix them up too?

Thanks!

-- 
tejun
