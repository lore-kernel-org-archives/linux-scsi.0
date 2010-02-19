From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: entries in sysfs regarding enclosures seem not being updated
 after hot plugging
Date: Fri, 19 Feb 2010 09:08:36 +0100
Message-ID: <20100219090836.28580961.taeuber@bbaw.de>
References: <20100118114624.fea646be.taeuber@bbaw.de>
	<20100120095733.f65474fa.taeuber@bbaw.de>
	<1264174080.5704.107.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:40648 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0BSIIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 03:08:38 -0500
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id 9F0334A8084
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 09:08:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 0642F93828
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 09:08:36 +0100 (CET)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id EF76293809
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 09:08:35 +0100 (CET)
In-Reply-To: <1264174080.5704.107.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hallo James,

James Bottomley <James.Bottomley@suse.de> schrieb:
> On Wed, 2010-01-20 at 09:57 +0100, Lars T=C3=A4uber wrote:
> > I might be wrong on this mailing list. Is there a special sysfs ML?
>=20
> No, this is the right list.
>=20
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

is there some progress on this subject?
Just tell me if I can help anyhow.

Best regards
Lars

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
