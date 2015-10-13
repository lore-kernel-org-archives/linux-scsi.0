From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: allow debug output to be enabled or disabled via sysfs
Date: Tue, 13 Oct 2015 23:12:52 +0300
Message-ID: <C6AFF410-BC3F-4AD0-93AA-F30DFBAA91ED@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB444ABDC8@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 9.0 \(3094\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:60313 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbbJMUYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2015 16:24:32 -0400
In-Reply-To: <DDB9C85B850785449757F9914A034FCB444ABDC8@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>


> On 12.10.2015, at 7.31, Seymour, Shane M <shane.seymour@hpe.com> wrot=
e:
>=20
>=20
> Change st driver to allow enabling or disabling debug output
> via sysfs file /sys/bus/scsi/drivers/st/debug_flag.
>=20
> Previously the only way to enable debug output was:
>=20
> 1. loading the driver with the module parameter debug_flag=3D1
> 2. an ioctl call (this method was also the only way to dynamically
> disable debug output).
>=20
> To use the ioctl you need a second tape drive (if you are
> actively testing the first tape drive) since a second process
> cannot open the first tape drive if it is in use.
>=20
Good justification for the feature.

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
