From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v11 4/9] Disallow changing the device state via sysfs
 into "deleted"
Date: Sun, 23 Jun 2013 20:05:00 -0500
Message-ID: <51C79B3C.7070204@cs.wisc.edu>
References: <51B86E26.6030108@acm.org> <51B86F40.3020407@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56978 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab3FXBFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jun 2013 21:05:25 -0400
In-Reply-To: <51B86F40.3020407@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On 6/12/13 7:53 AM, Bart Van Assche wrote:
> Changing the state of a SCSI device via sysfs into "cancel" or
> "deleted" prevents removal of these devices by scsi_remove_host().
> Hence do not allow this. Also, introduce the symbolic name
> INVALID_SDEV_STATE, representing a value different from any valid


Maybe it should be named SDEV_INVALID_STATE to match the current naming 
scheme? Other than that, it seems ok.


