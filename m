From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: entries in sysfs regarding enclosures seem not being updated
 after hot plugging
Date: Fri, 22 Jan 2010 10:28:00 -0500
Message-ID: <1264174080.5704.107.camel@mulgrave.site>
References: <20100118114624.fea646be.taeuber@bbaw.de>
	 <20100120095733.f65474fa.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab0AVP2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 10:28:05 -0500
In-Reply-To: <20100120095733.f65474fa.taeuber@bbaw.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars =?ISO-8859-1?Q?T=E4uber?= <taeuber@bbaw.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-01-20 at 09:57 +0100, Lars T=C3=A4uber wrote:
> I might be wrong on this mailing list. Is there a special sysfs ML?

No, this is the right list.

> Please point me out a place to look next with my problem.
>=20
> I should have mentioned the kernel version and enclosure type:
> # uname -a
> Linux speicher48 2.6.31-17-server #54-Ubuntu SMP Thu Dec 10 18:06:56 =
UTC 2009 x86_64 GNU/Linux
> # cat /sys/class/enclosure/10\:0\:24\:0/device/vendor=20
> CHENBRO=20
> # cat /sys/class/enclosure/10\:0\:24\:0/device/model=20
> SASX36 B0      =20

So the bug reports sound like something is going wrong in the device
unbinding ... I don't see what from the code, so I need to play with an
actual enclosure.  Unfortunately, that can only be done when physically
present (unlike most of the SCSI development which I can do remotely),
so it has to wait until I get back home.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
