From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito-qczF+2RCDl1fyO9Q7EP/yw@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 14020] New: Stack trace when running smartctl
 on an USB disk
Date: Sat, 22 Aug 2009 16:23:04 -0300
Message-ID: <20090822192304.GB5572@ime.usp.br>
References: <20090820220740.GA767@ime.usp.br>
 <Pine.LNX.4.44L0.0908211003090.2912-100000@iolanthe.rowland.org>
 <20090822191420.GA5572@ime.usp.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090822191420.GA5572-qczF+2RCDl1fyO9Q7EP/yw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi, it's me again.

On Aug 22 2009, Rog=C3=A9rio Brito wrote:
> In the mean time, I just issued the command with a freshly compiled
> 2.6.31-rc7 and the problem persists:
(...)

Well, after some minutes (the time that I took to check my computer and
to compose the previous message), I got two stack traces (attached to
this message) and smartctl has just finished:

,----
| chagas:/tmp/sbin# ./smartctl -d usbcypress -a /dev/sda
| smartctl 5.39 2009-08-20 r2876 [x86_64-unknown-linux-gnu] (local buil=
d)
| Copyright (C) 2002-9 by Bruce Allen, http://smartmontools.sourceforge=
=2Enet
|=20
| =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
| Device Model:     [No Information Found]
| Serial Number:    [No Information Found]
| Firmware Version: [No Information Found]
| Device is:        Not in smartctl database [for details use: -P showa=
ll]
| ATA Version is:   1
| ATA Standard is:  Exact ATA specification draft version not indicated
| Local Time is:    Sat Aug 22 16:13:12 2009 BRT
| SMART is only available in ATA Version 3 Revision 3 or greater.
| We will try to proceed in spite of this.
| SMART support is: Ambiguous - ATA IDENTIFY DEVICE words 82-83 don't s=
how if SMART supported.
| A mandatory SMART command failed: exiting. To continue, add one or mo=
re '-T permissive' options.
| chagas:/tmp/sbin#
`----

Does this help (at least a bit), before I get usbmon working? I just
wanted to report something that could be an extra data point.


Regards, Rog=C3=A9rio Brito.

--=20
Rog=C3=A9rio Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2C=
AEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
