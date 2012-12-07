From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v7 9/9] Avoid that scsi_device_set_state() triggers a
 race
Date: Fri, 07 Dec 2012 07:59:19 +0100
Message-ID: <50C193C7.80007@suse.de>
References: <50C0BEEE.4040907@acm.org> <50C0C13A.9060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34209 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab2LGG7V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2012 01:59:21 -0500
In-Reply-To: <50C0C13A.9060009@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 12/06/2012 05:00 PM, Bart Van Assche wrote:
> Make concurrent invocations of scsi_device_set_state() safe.
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michaelc@cs.wisc.edu>
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
