From: yanh <yanh@lemote.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Tue, 26 May 2009 22:39:32 +0800
Message-ID: <1243348772.9819.77.camel@localhost.localdomain>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <1243230339.9819.18.camel@localhost.localdomain>
	 <4A1A4A54.6090401@lemote.com> <200905251656.25357.bzolnier@gmail.com>
	 <4A1AEBF7.7040402@ru.mvista.com> <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
	 <1243300890.9819.40.camel@localhost.localdomain>
	 <20090526085605.014d0087@lxorguk.ukuu.org.uk>
Reply-To: yanh@lemote.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [222.92.8.141] ([222.92.8.141]:34859 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZEZOkA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 10:40:00 -0400
In-Reply-To: <20090526085605.014d0087@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sergei Shtylyov <sshtylyov@ru.mvista.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?gb2312?Q?=BA=FA=BA=E9=B1=F8?= <huhb@lemote.com>, wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>

=E5=9C=A8 2009-05-26=E4=BA=8C=E7=9A=84 08:56 +0100=EF=BC=8CAlan Cox=E5=86=
=99=E9=81=93=EF=BC=9A
> > > In any case I have yet to see a CS5536 system whose BIOS sets the=
 cable
> > > detection bit.  If that's the problem I guess we could add a quir=
k flag
> > > to override the (lack of) BIOS setting.
> > >=20
> > This may be the cause that udma5 cannot be set.
>=20
>=20
> If the system doesn't have working BIOS cable detect as per the
> documentation for the chip then just return the "unknown" cable type =
and
> libata will do device side cable detect.

After force cable type as 80 wire, udma5 can be set OK now.=20
after some raw test, the legacy and native driver have no obvious
difference in performance.

Remain issue: this native driver still have suspend/resume issue.

=20
>=20
> Alan

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
