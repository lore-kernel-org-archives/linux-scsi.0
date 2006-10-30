From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Fwd: linux-2.6.19-rc3-g2da6dc28 build #105 failed
Date: Mon, 30 Oct 2006 12:07:48 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0610301206240.6761@scrub.home>
References: <200610291945.16948.toralf.foerster@gmx.de>
 <20061029190357.98fc9c98.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811837-1556391829-1162206468=:6761"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:21420 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S1161251AbWJ3LIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 06:08:04 -0500
In-Reply-To: <20061029190357.98fc9c98.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: =?UTF-8?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811837-1556391829-1162206468=:6761
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Sun, 29 Oct 2006, Randy Dunlap wrote:

> On Sun, 29 Oct 2006 19:45:15 +0100 Toralf F=F6rster wrote:
>=20
> > Hello,
>=20
> config SCSI_ISCSI_ATTRS
> =09tristate "iSCSI Transport Attributes"
> =09depends on SCSI && NET
> =09help
> =09  If you wish to export transport-specific information about
> =09  each attached iSCSI device to sysfs, say Y.
> =09  Otherwise, say N.
>=20
> but NET is disabled, yet somehow SCSI_ISCSI_ATTRS is enabled.
> I don't see how that happens.
> Roman, any ideas?
>=20
> [...]
> > CONFIG_SCSI_QLA_ISCSI=3Dy

I guess, that needs a dependency on NET.

bye, Roman
---1463811837-1556391829-1162206468=:6761--
