From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts power
Date: Mon, 20 Apr 2009 17:35:39 +0900
Message-ID: <49EC33DB.5060808@gmail.com>
References: <20090418124415.1dc82273@neptune.home>	<20090418124558.0426f74c@neptune.home>	<49EC299D.5020102@gmail.com> <20090420102826.5184f3fe@pluto.restena.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090420102826.5184f3fe@pluto.restena.lu>
Sender: linux-ide-owner@vger.kernel.org
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Cc: Linux IDE <linux-ide@vger.kernel.org>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

Bruno Pr=C3=A9mont wrote:
> Possibly it depends very much how the power is connected,
> e.g. desktop boxes with ATX power-supply probably never tell the
> power-supply to cut the power but laptop may behave differently with
> regard to their built-in DC-DC converters (disks connected to
> mainboard versus disks directly connected to power supply).

I've seen several desktop motherboards which fully power cycle disks
on reboot.  Dunno where the difference comes from tho.  IIRC, some
intel boards seem to do things that way.

> What I was also wondering whether the list of machines to which to
> apply the quirk should be moved to a common location so it exists
> only once for ide and scsi/ata instead of once on each side.  Having
> the list exactly once avoids the risk for content to drift between
> ide and scsi/ata.

Hmmm....

Thanks.

--=20
tejun
