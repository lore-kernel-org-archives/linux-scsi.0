From: Jelle de Jong <jelledejong@powercraft.nl>
Subject: Re: HighPoint Technologies, Inc. Device [1103:2680]
Date: Sat, 19 Jun 2010 10:04:56 +0200
Message-ID: <4C1C7A28.3060307@powercraft.nl>
References: <4C1B612C.8070503@powercraft.nl> <20100618151847.68abad65@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01.cambriumhosting.nl ([217.19.16.173]:47987 "EHLO
	relay01.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753986Ab0FSIE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2010 04:04:59 -0400
In-Reply-To: <20100618151847.68abad65@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erno Kovacs <erno.kovacs@freemail.hu>
Cc: linux-scsi@vger.kernel.org, linux@highpoint-tech.com

Erno Kovacs wrote, on 19-06-10 09:25:
>> Le Fri, 18 Jun 2010 14:06:04 +0200 Jelle de Jong
>> <jelledejong@powercraft.nl> =E9crivait:
>=20
>>> It seems there is no kernel module for the 2600 series or the
>>> 2700 series. The HighPoint website [1][2] keeps claiming there
>>> are open soure drivers available. I know open source is not the
>>> same as free software, but it is very very misleading, because
>>> it does not work.
>=20
>> Usually Highpoint labels "open source" a code source wrapper
>> around a proprietary piece of driver. HighPoint are really
>> horrible from a free software POV and really stink under linux;
>> and as they aren't true hardware RAID but use a substantial part
>> of the driver to do their job there isn't much hope that it will
>> ever get any better. My advice : stay away from these, use any of
>> 3Ware, Areca or Adaptec SAS/SATA controllers which all work fine
>> and without hassle under Linux.
>=20
> Its true, although newer HPT series have real IO processors.=20
> Anyway, 2600 and 2700 serie seem to have Marvell chipset, which
> should work with the mvsas driver, but unfortunately it still has
> some stability issues according to mailing-list posts here, even
> after patchset of Srinivas applied.

I hope the HighPoint Linux team will spent some of there resources in
making there 2600 and 2700 series work with the mvsas driver, maybe
they still have to make there own driver that depends on the mvsas
driver because it seems they put a little bit of there own special
sauce around the Marvell chip.

Would somebody from HighPoint willing to response and share there
plans for the 2600 and 2700 series regarding gnu/linux kernel support?
It is never to late to do change the general advice to stay far away
from HighPoint controllers.

I have no interested in raid support, I need a very stable and fast
interface with the attached SATA/SAS hard drives. I let mdraid, lvm2
and ext4 do the rest.

I bought the HPT RR2680 because my Marvel 88SE63xx/64xx mvsas
controllers are unstable and not usable for production. I switched
back to my sata_mv controllers, they are slow but stable.

With kind regards,

Jelle de Jong
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
