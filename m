From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/4 v8] Fixes for SCSI device removal
Date: Mon, 11 Jun 2012 17:54:31 -0500
Message-ID: <4FD67727.5040902@cs.wisc.edu>
References: <4FD0F558.6090801@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59152 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2FKW6T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2012 18:58:19 -0400
In-Reply-To: <4FD0F558.6090801@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tejun Heo <tj@kernel.org>

On 06/07/2012 01:39 PM, Bart Van Assche wrote:
> This is version eight of the SCSI device removal patch series. This
> version of this patch series has been tested by triggering a large
> number of removals of a SCSI device controlled by the ib_srp LLD and at
> the same time running an I/O integrity test with fio on a dm device on
> top of the SRP SCSI device.
> 

Patches look ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

I also tested them in a distro kernel and they fix a oops we were seeing
there.
