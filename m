From: Martin Dalecki <dalecki@evision-ventures.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 22:55:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D124149.6010901@evision-ventures.com>
References: <Pine.LNX.4.44.0206201115460.8225-100000@home.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

U=BFytkownik Linus Torvalds napisa=B3:

> For example, to be useful, every driver that knows about disks should=
 make
> sure they show up with some standard name (the old "disk" vs "disc" w=
ar
> ;), exactly so that you _should_ be able to do something like
>=20
> 	find /devices -name disk*

Not good. find /devices -name "/sd@* -- will be unambigious.
There are good reaons they do it like they do on the "other unix OS"...

> and be able to enumerate every disk in the whole system.

>=20
> 	/devices/disks/disk0 -> ../../pci0/00:02.0/02:1f.0/03:07.0/disk0
                  ^^^^^^^^^^ You notice the redundancy in naming here :=
-).

> 	               disk1 -> ../../pci0/00:02.3/usb_bus/001000/dev1
>=20
> the same way that Pat already planned to do the mappings for network
> devices in /devices/network/eth*.

Boah the chierachies are already deep enough. /devices/net/eth@XX
will cut it.

> Is this done? No. But is it fundamentally hard? Nope. Useful? You be =
the
> judge.  Imagine yourself as a installer searching for disks. Or imagi=
ne
> yourself as a initrd program that runs at boot, setting up irq routin=
gs
> etc before the "real boot".

Yes but again the most content files found there are already inventing
interfaces on the heap. /name /irq /resources /power this will end the =
same
as similar attempts ended already - in a mess.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
