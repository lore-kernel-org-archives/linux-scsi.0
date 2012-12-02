From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 10/13] Make scsi_remove_host() wait for device removal
Date: Sun, 2 Dec 2012 05:48:28 -0800
Message-ID: <20121202134828.GK15930@mtj.dyndns.org>
References: <50B60619.4080406@acm.org>
 <50B608C1.6080803@acm.org>
 <20121202134515.GJ15930@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48305 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2LBNsd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2012 08:48:33 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so1426039pbc.19
        for <linux-scsi@vger.kernel.org>; Sun, 02 Dec 2012 05:48:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121202134515.GJ15930@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

Hey, again.

On Sun, Dec 02, 2012 at 05:45:15AM -0800, Tejun Heo wrote:
> > +/* Return true if and only if scsi_remove_host() is allowed to finish. */
> > +static bool __scsi_remove_host_done(struct Scsi_Host *shost)
> > +{
> > +	lockdep_assert_held(shost->host_lock);
> > +
> > +	return list_empty(&shost->__devices);
> > +}
> 
> This is a preference thing but I usually find this type of trivial
> wrappers more obfuscating than actually helpful.  Dunno what James's
> preference is tho.

Please disregard this one.  You're adding more conditions afterwards.

Thanks.

-- 
tejun
