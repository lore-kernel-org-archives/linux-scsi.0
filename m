From: Olaf Hering <olh@suse.de>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Sat, 2 Oct 2004 21:36:31 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002193631.GA4394@suse.de>
References: <0B1E13B586976742A7599D71A6AC733C08664E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45480 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S267519AbUJBTjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2004 15:39:05 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C08664E@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

 On Sat, Oct 02, James.Smart@Emulex.Com wrote:

>=20
>=20
> > I tried it on a legacy iseries partition, there where a few
> > warnings/errors in dmesg. the box has no storage attached. Does tha=
t
> > indicate a driver problem, or is it just the not-attached storage?
>=20
> Depends on the errors - please send the the dmesg log.

It was attached.

> > curry:~ # rmmod lpfc
> > Kernel panic - not syncing: PCI: Hardware I/O Error, SRC=20
> > B6000103, Automatic Reboot Disabled.
> >=20
> > this is 2.6.9-rc3-bk2, + bk-scsi-target.patch and bk-scsi.patch wit=
h
> > arch/ppc64/configs/iseriesconfig.
>=20
> We don't know of any issues like this. I'll look more at the logs you=
 send and perhaps it'll give a hint...

It worked with the second try, but a few modprobe/rmmod cycles caused
the same crash. Could be something in the iseries arch code.
I cant really help with that sort of crash.

--=20
USB is for mice, FireWire is for men!

sUse lINUX ag, n=C3=9CRNBERG
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
