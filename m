From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v11 5/9] Avoid saving/restoring interrupt state inside
 scsi_remove_host()
Date: Sun, 23 Jun 2013 20:06:04 -0500
Message-ID: <51C79B7C.2010902@cs.wisc.edu>
References: <51B86E26.6030108@acm.org> <51B86F77.7010208@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56986 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab3FXBGX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jun 2013 21:06:23 -0400
In-Reply-To: <51B86F77.7010208@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On 6/12/13 7:54 AM, Bart Van Assche wrote:
> Since it is not allowed to invoke scsi_remove_host() with interrupts
> disabled, avoid saving and restoring the interrupt state inside
> scsi_remove_host(). This patch does not change the functionality of
> the function scsi_remove_host().
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: James Bottomley <JBottomley@Parallels.com>


Seems ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

