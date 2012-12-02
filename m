From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 12/13] Avoid that scsi_device_set_state() triggers a
 race
Date: Sun, 2 Dec 2012 05:53:30 -0800
Message-ID: <20121202135330.GM15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B60944.2080605@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62577 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2LBNxg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:53:36 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1427298pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:53:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B60944.2080605@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On Wed, Nov 28, 2012 at 01:53:24PM +0100, Bart Van Assche wrote:
> Make concurrent invocations of scsi_device_set_state() safe.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>

Acked-by: Tejun Heo <tj@kernel.org>

Yeah, this is an old one.

Thanks.

-- 
tejun
