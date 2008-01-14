From: Guillaume Bedot <littletux@zarb.org>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was Linux scsi /
	usb-mass-storage and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 10:40:45 +0100
Message-ID: <1200303645.11301.15.camel@littletux>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>
	 <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
	 <4787CE08.5000304@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.153.228]:51778 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYANJku (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 04:40:50 -0500
In-Reply-To: <4787CE08.5000304@hhs.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, fedora-kernel-list@redhat.com, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

Hello,

On ven, 2008-01-11 at 21:14 +0100, Hans de Goede wrote:
> Boaz Harrosh wrote:
> > Yes, you're right. in ULDs it is a much proper way to do this.
> >=20
> > So I guess you'll have to do that special host flag or device
> > flag, and add a check for it in sd.c. You'll see that sd.c is=20
> > already doing bufflen truncation at sd_prep_fn(), just add one
> > more case.
> >=20
>=20
> Done, thanks for the hint. Patch implementing my fix this way attache=
d, please=20
> apply.
>=20
> Thanks & Regards,
>=20
> Hans
>=20
I have tested this time with two PSC 1610 printers, and two SD cards,
the same bug occured without the patch.
And is fixed with your new patch. =EF=BB=BFGood work !

The bug however did not occur with a microSD card in a SD adaptator ?!

But it fixes only two models.
Do you think other devices (hp or not) can be impacted ?
There are hundreds of models with card readers only for hp :
http://hplip.sourceforge.net/supported_devices/combined.html

Will this be possible to use "LAST_SECTOR_BUG" quirk for testing withou=
t
recompiling a kernel ?

Best regards,

Guillaume B.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
