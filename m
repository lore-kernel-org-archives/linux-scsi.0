From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/7] Use 'Scsi_Host' as argument for host reset
Date: Fri, 27 Jun 2014 10:14:36 +0200
Message-ID: <53AD27EC.2030603@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de> <20140627075938.GD21799@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaF0IOi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 04:14:38 -0400
In-Reply-To: <20140627075938.GD21799@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 06/27/2014 09:59 AM, Christoph Hellwig wrote:
> On Fri, Jun 27, 2014 at 08:26:58AM +0200, Hannes Reinecke wrote:
>> eh_host_reset_handler can only depend on the Scsi_Host, so
>> we should make that explicit by using 'struct Scsi_Host' as
>> argument for it.
>
> I like where this is going.  Are you going to do a similar conversion
> away from scsi_cmnd for the other reset methods as well?  It would be
> good to get them into a single kernel release so that we don't have
> a churn of lots of small driver API changes.
>
Yes, that was the plan.

I just wanted to push this out to get some feedback.
Especially the driver changes do warrant some maintainer approval.

And I didn't want this to linger in my tree, as sending out the=20
entire conversion will result in a massive patchset.

But if you're fine with it ...

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
