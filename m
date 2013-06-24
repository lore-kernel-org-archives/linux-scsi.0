From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v11 8/9] Save and restore host_scribble during error handling
Date: Sun, 23 Jun 2013 20:21:21 -0500
Message-ID: <51C79F11.2060906@cs.wisc.edu>
References: <51B86E26.6030108@acm.org> <51B8702C.6030508@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57003 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3FXBVk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jun 2013 21:21:40 -0400
In-Reply-To: <51B8702C.6030508@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>

On 6/12/13 7:57 AM, Bart Van Assche wrote:
> A SCSI LLD may overwrite host_scribble in its queuecommand()
> implementation. Several drivers need that field to process
> requests and aborts correctly. Hence this field must be saved
> by scsi_eh_prep_cmnd() and must be restored by
> scsi_eh_restore_cmnd().
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tejun Heo <tj@kernel.org>


How have we not hit this before :) ?

Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

