From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v11 2/9] Remove get_device() / put_device() pair from
 scsi_request_fn()
Date: Mon, 24 Jun 2013 02:36:31 +0000
Message-ID: <1372041391.2386.20.camel@dabdike>
References: <51B86E26.6030108@acm.org> <51B86EB5.8030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:47589 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab3FXCgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jun 2013 22:36:33 -0400
In-Reply-To: <51B86EB5.8030602@acm.org>
Content-Language: en-US
Content-ID: <32BC7DA6C0979B4498F9AFDF824760AC@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

On Wed, 2013-06-12 at 14:51 +0200, Bart Van Assche wrote:
> Now that all scsi_request_fn() callers hold a reference on the
> SCSI device that function is invoked for

What makes you think that this is a true statement?  The usual caller is
the block layer, which doesn't really know anything about the
sdev->sdev_gendev.

James

