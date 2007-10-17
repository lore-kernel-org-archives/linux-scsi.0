From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Wed, 17 Oct 2007 19:23:59 +0200
Message-ID: <4716452F.4080408@s5r6.in-berlin.de>
References: <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org> <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm> <20071017094838.GB18035@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:57184 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760147AbXJQRZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:25:22 -0400
In-Reply-To: <20071017094838.GB18035@boogie.lpds.sztaki.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: david@lang.hm, Matthew Wilcox <matthew@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Gabor Gombas wrote:
> On Tue, Oct 16, 2007 at 01:55:07PM -0700, david@lang.hm wrote:
>> why is this any different from the external enclosures? they have al=
ways=20
>> appeared as the type of device that connects them to the motherboard=
, (and=20
>> even with SCSI, there are some controllers that don't generate sdX d=
evices)
>=20
> In the past enclosures supported only one kind of connector so this
> assumption was fine. But nowadays an external disk may have several
> connectors (like USB, Firewire and eSata). Why should the disk's name
> depend on what type of cable did I manage to grab first? It is the
> _same_ disk regardless of the cable type.

Yes, but even udev won't give you one and the same symlink to the disk'=
s
device file then.=B9  There isn't a persistent unique target/unit prope=
rty
which all of these transports have in common.

The only thing that could be common in the best case is the symlink to
the partition's device file, based on filesystem UUID or filesystem lab=
el.

=B9) unless you write your own rule specific to this on particular encl=
osure
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D=3D =3D-=3D- =3D---=3D
http://arcgraph.de/sr/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
