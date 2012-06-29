From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/5] scsi: Avoid dangling pointer in
 scsi_requeue_command()
Date: Fri, 29 Jun 2012 09:48:15 -0700
Message-ID: <20120629164815.GA21048@google.com>
References: <4FEDCA26.90804@acm.org>
 <4FEDCB02.6070600@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58339 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2F2QsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2012 12:48:20 -0400
Received: by dady13 with SMTP id y13so4607749dad.19
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jun 2012 09:48:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FEDCB02.6070600@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Muthukumar Ratty <muthur@gmail.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Fri, Jun 29, 2012 at 03:34:26PM +0000, Bart Van Assche wrote:
> Reported-by: Mike Christie <michaelc@cs.wisc.edu>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: <stable@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
