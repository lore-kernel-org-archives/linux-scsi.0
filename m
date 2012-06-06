From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 4/4] scsi: Stop accepting SCSI requests before removing
 a device
Date: Wed, 06 Jun 2012 15:07:24 +0000
Message-ID: <4FCF722C.8030303@acm.org>
References: <4FCE3D20.4000205@acm.org> <4FCE3E63.7000002@acm.org> <4FCE8349.2000908@cs.wisc.edu> <4FCF4C1E.1080300@acm.org> <4FCF5E6B.40507@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:54095 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab2FFPHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jun 2012 11:07:35 -0400
In-Reply-To: <4FCF5E6B.40507@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 06/06/12 13:43, Mike Christie wrote:

> What if we moved the requeue work struct to the request queue, then have
> blk_cleanup_queue or blk_drain_queue call cancel_work_sync before the
> queue is freed. That way that code could make sure the queue and work is
> flushed and drained, and it can make sure it is flushed and drained
> before freeing the queue?


Sounds like a good idea to me. However, personally I'd prefer with this
patch set to focus on fixing bugs and to leave such restructuring for a
subsequent patch.

Bart.

 


