From: yanh <yanh@lemote.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Tue, 26 May 2009 09:21:30 +0800
Message-ID: <1243300890.9819.40.camel@localhost.localdomain>
References: <cover.1242855716.git.wuzhangjin@gmail.com>
	 <1243230339.9819.18.camel@localhost.localdomain>
	 <4A1A4A54.6090401@lemote.com> <200905251656.25357.bzolnier@gmail.com>
	 <4A1AEBF7.7040402@ru.mvista.com>  <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
Reply-To: yanh@lemote.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [222.92.8.141] ([222.92.8.141]:48417 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZEZBV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2009 21:21:58 -0400
In-Reply-To: <yq1tz39dmmn.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, =?gb2312?Q?=BA=FA=BA=E9=B1=F8?= <huhb@lemote.com>, wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>

=E5=9C=A8 2009-05-25=E4=B8=80=E7=9A=84 15:10 -0400=EF=BC=8CMartin K. Pe=
tersen=E5=86=99=E9=81=93=EF=BC=9A
> >>>>> "Sergei" =3D=3D Sergei Shtylyov <sshtylyov@ru.mvista.com> write=
s:
>=20
> >> Could you please explain the issue with platform specific code a b=
it
> >> more?
>=20
> >> Is it related to a cable detection by any chance?
>=20
> Sergei>    I guess it's rdmsr()/wrmsr()...
currently, we just commented out the rdmsr/wrmsr.
and we use pci VSA to access it.=20
>=20
> Those are only used when the driver is explicitly loaded with
> use_msr=3D1.  The default is to use PCI config space/VSA.
>=20
> In any case I have yet to see a CS5536 system whose BIOS sets the cab=
le
> detection bit.  If that's the problem I guess we could add a quirk fl=
ag
> to override the (lack of) BIOS setting.
>=20
This may be the cause that udma5 cannot be set.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
