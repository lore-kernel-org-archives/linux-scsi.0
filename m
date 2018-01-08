From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Mon, 08 Jan 2018 09:21:47 +0100
Message-ID: <mqdwp0skbfo.fsf@linux-x5ow.site>
References: <20171221024049.36509-1-yanaijie@huawei.com>
        <1513872544.2931.13.camel@wdc.com>
        <20171222070318.p4bor426wcc7kxwm@linux-x5ow.site>
        <yq1608iz45y.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40895 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755009AbeAHIVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Jan 2018 03:21:50 -0500
In-Reply-To: <yq1608iz45y.fsf@oracle.com> (Martin K. Petersen's message of
        "Wed, 03 Jan 2018 22:36:09 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>

"Martin K. Petersen" <martin.petersen@oracle.com> writes:
> I am thoroughly annoyed by all the legacy whitespace problems. I've been
> working on two different sd patch series over the holidays and both
> caused me no end of grief due to legacy formatting issues.
>
> I have had an unbreak-sd patch sitting in my queue for several years but
> never pulled the trigger on it. For the usual reasons.

So we all share the same common pain points.

> I'm not particularly worried about bisection. But fixing whitespace does
> make it harder on the distro backporting front (Very pleased that you
> have now inadvertently volunteered to deal with all the issues that may
> arise at SUSE from such a subsystem-wide cleanup :).
>
> Anyway. I'm OK with fixing up the core pieces since they are the ones
> that annoy me the most. But I'm not sure we should enforce cleanups on
> drivers without an ack from the relevant maintainer. And for the
> unmaintained legacy baggage, I'm just not sure it's worth the hassle to
> clean things up. Fixing the crufty old things gives an illusion of the
> driver being actively worked on. I'd rather see dead code being left as
> such. Gives us a good indication of when it's safe to drop.

Well the drivers are more of a personal pain pain point but yes cleaning
up the core would be very much appreciated.

> One thing I specifically don't want is to open the flood gates for
> drive-by whitespace patches. I have no interest in wasting cycles on
> that. I generally only take arbitrary 3rd party cleanups if a driver is
> actively maintained and the maintainer specifically acks the change.

Agreed

> PS. I'll at least partially unbreak sd.c as part of the series I'll be
> posting shortly.

:-)

Byte,
        Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
