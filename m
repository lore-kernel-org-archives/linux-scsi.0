From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] Add EVPD page 0x83 to sysfs
Date: Mon, 10 Mar 2014 21:52:03 +0100
Message-ID: <531E25F3.6090102@suse.de>
References: <1394461725-76203-1-git-send-email-hare@suse.de>	 <1394461725-76203-4-git-send-email-hare@suse.de> <1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaCJStD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 14:49:03 -0400
In-Reply-To: <1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "jlinton@tributary.com" <jlinton@tributary.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>, "kay@vrfy.org" <kay@vrfy.org>

On 03/10/2014 07:24 PM, James Bottomley wrote:
> On Mon, 2014-03-10 at 15:28 +0100, Hannes Reinecke wrote:
>> EVPD page 0x83 is used to uniquely identify the device.
>> So instead of having each and every program issue a separate
>> SG_IO call to retrieve this information it does make far more
>> sense to display it in sysfs.
>
> Christoph's suggestion of binary sysfs attributes for this rather tha=
n
> the text ones you have is better ... because your current ones are go=
ing
> to truncate when they run off the one page of data sysfs text attribu=
tes
> get (i.e. about 2k of vpd).
>
Yes, I thought of that, too.
I thought to remember that binary attributes are reserved for=20
firmware/hardware-dependent interfaces.
If that's not the case I'll be moving to a binary attribute here.
Will be resending the patchset.

What should happen with the first patch in the series, then?
When moving to a binary attribute the first patch isn't required=20
anymore; should I drop it or send as a separate patch?

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
