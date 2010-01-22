From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: entries in sysfs regarding enclosures seem not being updated
 after hot plugging
Date: Fri, 22 Jan 2010 16:48:30 +0100
Message-ID: <20100122164830.be5e8ee7.taeuber@bbaw.de>
References: <20100118114624.fea646be.taeuber@bbaw.de>
	<20100120095733.f65474fa.taeuber@bbaw.de>
	<1264174080.5704.107.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:39613 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab0AVPsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2010 10:48:32 -0500
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id DDEFA4A80A5
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2010 16:48:29 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 9B98A93801
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2010 16:48:30 +0100 (CET)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 927E6937B4
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2010 16:48:30 +0100 (CET)
In-Reply-To: <1264174080.5704.107.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi James!

James Bottomley <James.Bottomley@suse.de> schrieb:
> On Wed, 2010-01-20 at 09:57 +0100, Lars T=C3=A4uber wrote:
> > I might be wrong on this mailing list. Is there a special sysfs ML?
>=20
> No, this is the right list.

Ok.


> > Please point me out a place to look next with my problem.
> >=20
> > I should have mentioned the kernel version and enclosure type:
> > # uname -a
> > Linux speicher48 2.6.31-17-server #54-Ubuntu SMP Thu Dec 10 18:06:5=
6 UTC 2009 x86_64 GNU/Linux
> > # cat /sys/class/enclosure/10\:0\:24\:0/device/vendor=20
> > CHENBRO=20
> > # cat /sys/class/enclosure/10\:0\:24\:0/device/model=20
> > SASX36 B0      =20
>=20
> So the bug reports sound like something is going wrong in the device
> unbinding ... I don't see what from the code, so I need to play with =
an
> actual enclosure.  Unfortunately, that can only be done when physical=
ly
> present (unlike most of the SCSI development which I can do remotely)=
,
> so it has to wait until I get back home.

Thanks. I'm looking forward to.
If I can help any further just ask. The server isn't productive yet.

Lars
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
