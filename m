From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 06/13] bsg: Remove unused function bsg_goose_queue()
Date: Sun, 2 Dec 2012 05:29:22 -0800
Message-ID: <20121202132922.GF15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B607E8.20800@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50805 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2LBN31 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:29:27 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1421561pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:29:26 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <50B607E8.20800@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

On Wed, Nov 28, 2012 at 01:47:36PM +0100, Bart Van Assche wrote:
> The function bsg_goose_queue() does not have any in-tree callers,
> so let's remove it.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
