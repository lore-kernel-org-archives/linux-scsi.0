From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 8/9] Make scsi_remove_host() wait until error handling
 finished
Date: Fri, 07 Dec 2012 07:58:02 +0100
Message-ID: <50C1937A.6090803@suse.de>
References: <50C0BEEE.4040907@acm.org> <50C0C0FC.7030701@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab2LGG6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 01:58:03 -0500
In-Reply-To: <50C0C0FC.7030701@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/06/2012 04:59 PM, Bart Van Assche wrote:
> A SCSI LLD may start cleaning up host resources as soon as
> scsi_remove_host() returns. These host resources may be needed by
> the LLD in an implementation of one of the eh_* functions. So if
> one of the eh_* functions is in progress when scsi_remove_host()
> is invoked, wait until the eh_* function has finished. Also, do
> not invoke any of the eh_* functions after scsi_remove_host() has
> started.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
> Cc: Tejun Heo <tj@kernel.org>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
