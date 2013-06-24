From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v11 2/9] Remove get_device() / put_device() pair from
 scsi_request_fn()
Date: Sun, 23 Jun 2013 20:29:17 -0500
Message-ID: <51C7A0ED.50808@cs.wisc.edu>
References: <51B86E26.6030108@acm.org> <51B86EB5.8030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57024 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab3FXB3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jun 2013 21:29:40 -0400
In-Reply-To: <51B86EB5.8030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On 6/12/13 7:51 AM, Bart Van Assche wrote:
> Now that all scsi_request_fn() callers hold a reference on the
> SCSI device that function is invoked for and since
> blk_cleanup_queue() waits until scsi_request_fn() has finished
> it is safe to remove the get_device() / put_device() pair from
> scsi_request_fn().
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> ---


Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

