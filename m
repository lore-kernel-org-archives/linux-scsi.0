From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [loongson-PATCH-v1 24/27] fixup for FUJITSU disk
Date: Mon, 25 May 2009 16:56:24 +0200
Message-ID: <200905251656.25357.bzolnier@gmail.com>
References: <cover.1242855716.git.wuzhangjin@gmail.com> <1243230339.9819.18.camel@localhost.localdomain> <4A1A4A54.6090401@lemote.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:4793 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZEYOvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 May 2009 10:51:49 -0400
In-Reply-To: <4A1A4A54.6090401@lemote.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?q?=E8=83=A1=E6=B4=AA=E5=85=B5?= <huhb@lemote.com>
Cc: yanh@lemote.com, wuzhangjin@gmail.com, linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>, Zhang Fuxin <zhangfx@lemote.com>, Arnaud Patard <apatard@mandriva.com>, loongson-dev@googlegroups.com, gnewsense-dev@nongnu.org, Nicholas Mc Guire <hofrat@hofr.at>, Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>

On Monday 25 May 2009 09:35:48 =E8=83=A1=E6=B4=AA=E5=85=B5 wrote:
> yanh =E5=86=99=E9=81=93:

[...]

> > the cs5536 pata driver have some geode platform dependent codes. We=
 can
> > just ignore it, but the performance is poor(using hdparm to test it=
),
> > which only get 22+ MB/s. we find it only use udma2. However if usin=
g
> > amd74xx driver, it can set udma5, and the speed can reach to 50+ MB=
/s.=20
> >
> > we will test whether this driver is working well without this patch=
=2E
> >
> > Anyway, thanks your advice.
> >  =20
> Use the driver drivers/ata/pata_cs5536.c, unfortunately it also have =
the=20
> same issue.

Both drivers (pata_cs5536 & cs5536) should handle UDMA5.

Could you please explain the issue with platform specific code a bit mo=
re?

Is it related to a cable detection by any chance?

Thanks.
Bart
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
