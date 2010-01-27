From: devzero@web.de
Subject: Re: fw: smartd crashing recent 2.6.32 kernel
Date: Wed, 27 Jan 2010 13:49:54 +0100
Message-ID: <1115608744@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate05.web.de ([217.72.192.243]:34123 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab0A0MuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2010 07:50:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, Smartmontools Mailing List <smartmontools-support@lists.sourceforge.net>, support@lsi.com

> Running 'smartd -r ioctl,1' from the command line might
> help us find which command it didn't like. That will
> send information to the log. If the crash truncates the
> log then add '-d' to the above invocation to dump debug
> information to the console.=20

thanks!

here we go:

smartd -r ioctl,1 -d
smartd 5.39 2009-08-08 r2872~ [i686-pc-linux-gnu] (openSUSE RPM)
Copyright (C) 2002-9 by Bruce Allen, http://smartmontools.sourceforge.n=
et

Opened configuration file /etc/smartd.conf
Drive: DEVICESCAN, implied '-a' Directive on line 26 of file /etc/smart=
d.conf
Configuration file /etc/smartd.conf was parsed, found DEVICESCAN, scann=
ing devices
glob(3) found no matches for pattern /dev/hd[a-t]
 [inquiry: 12 00 00 00 24 00 ]
  scsi_status=3D0x0, host_status=3D0x0, driver_status=3D0x0
  info=3D0x0  duration=3D0 milliseconds  resid=3D0
  status=3D0x0
Device: /dev/sda, opened
 [test unit ready: 00 00 00 00 00 00 ]
  scsi_status=3D0x0, host_status=3D0x0, driver_status=3D0x0
  info=3D0x0  duration=3D0 milliseconds  resid=3D0
  status=3D0x0
 [mode sense(6): 1a 00 1c 00 40 00 ]
Killed
[box freezed here]

>Information about the disks would be useful as well.

3x MAP 3367NC-V4 , 36GB -  2 Disks Raid1, 1 Disk Hotspare

> Does the megaraid controller have the latest firmware
> from LSI?

it didn`t (had 1F30) but it has 1F56 now. ( did an update with latest a=
vailable from http://support.ts.fujitsu.com/Download/ShowDescription.as=
p?SoftwareGUID=3D873EAF12-50EA-4EB1-B48E-D8E9C9929EA4&OSID=3DBD62ED52-D=
B04-417E-8A72-A3BA96295B00&Status=3DTrue&Component=3DMegaRAID%20SCSI%20=
U320-1 )=20

problem still exists with the latest firmware.

regards
roland


> devzero@web.de wrote:
> > maybe someone has a clue....!?
> >=20
> > see https://bugzillafiles.novell.org/attachment.cgi?id=3D338427
> >=20
> > that box seems to crash in megaraid_mbox driver as soon as smartd i=
s starting - even with recent 2.6.32 kernel.
> >=20
> > as this box will go into production between mid/end of february, i =
think that is not much time if there is something to fix (and then bein=
g tested/confirmed to be fixed)
>=20
> Roland,
> Running 'smartd -r ioctl,1' from the command line might
> help us find which command it didn't like. That will
> send information to the log. If the crash truncates the
> log then add '-d' to the above invocation to dump debug
> information to the console. Information about the disks
> would be useful as well.
>=20
> Does the megaraid controller have the latest firmware
> from LSI?
>=20
> https://bugzilla.novell.com/show_bug.cgi?id=3D573244
>=20
> Doug Gilbert
>=20
>=20
> >> -----Urspr=FCngliche Nachricht-----
> >> Von: <devzero@web.de>
> >> Gesendet: 25.01.10 12:15:09
> >> An: smartmontools-support@lists.sourceforge.net
> >> Betreff: smartd crashing recent 2.6.32 kernel
> >> Hi,=20
> >>
> >> just wanted to let you know that smartd is crashing my system at l=
ate installation stage.
> >>
> >> have opened novell bugticket #573244 ( https://bugzilla.novell.com=
/show_bug.cgi?id=3D573244 ) for this.
> >>
> >> regards
> >> roland
>=20
>=20


______________________________________________________
GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
