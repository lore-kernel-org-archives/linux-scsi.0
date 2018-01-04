From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Wed, 03 Jan 2018 22:36:09 -0500
Message-ID: <yq1608iz45y.fsf@oracle.com>
References: <20171221024049.36509-1-yanaijie@huawei.com>
        <1513872544.2931.13.camel@wdc.com>
        <20171222070318.p4bor426wcc7kxwm@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50340 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbeADDgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 22:36:24 -0500
In-Reply-To: <20171222070318.p4bor426wcc7kxwm@linux-x5ow.site> (Johannes
        Thumshirn's message of "Fri, 22 Dec 2017 08:03:18 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>


Johannes,

> All in all I'm so much in favour of this cleanup patch (and even would
> apprechiate more of these, especailly getting rid of all those
> camelCase foo we have in the scsi hba drivers).
>
> Let's see how Martin and James deceide about it.

I am thoroughly annoyed by all the legacy whitespace problems. I've been
working on two different sd patch series over the holidays and both
caused me no end of grief due to legacy formatting issues.

I have had an unbreak-sd patch sitting in my queue for several years but
never pulled the trigger on it. For the usual reasons.

I'm not particularly worried about bisection. But fixing whitespace does
make it harder on the distro backporting front (Very pleased that you
have now inadvertently volunteered to deal with all the issues that may
arise at SUSE from such a subsystem-wide cleanup :).

Anyway. I'm OK with fixing up the core pieces since they are the ones
that annoy me the most. But I'm not sure we should enforce cleanups on
drivers without an ack from the relevant maintainer. And for the
unmaintained legacy baggage, I'm just not sure it's worth the hassle to
clean things up. Fixing the crufty old things gives an illusion of the
driver being actively worked on. I'd rather see dead code being left as
such. Gives us a good indication of when it's safe to drop.

One thing I specifically don't want is to open the flood gates for
drive-by whitespace patches. I have no interest in wasting cycles on
that. I generally only take arbitrary 3rd party cleanups if a driver is
actively maintained and the maintainer specifically acks the change.

PS. I'll at least partially unbreak sd.c as part of the series I'll be
posting shortly.

-- 
Martin K. Petersen	Oracle Linux Engineering
