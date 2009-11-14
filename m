From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/7]MVSAS:add supporting MSI feature
Date: Sat, 14 Nov 2009 12:19:17 -0600
Message-ID: <1258222757.4070.34.camel@mulgrave.site>
References: <20091109120818.GA32336@Andy.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbZKNSTT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Nov 2009 13:19:19 -0500
In-Reply-To: <20091109120818.GA32336@Andy.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ayan@marvell.com
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org, jfeng@marvell.com, qswang@marvell.com

On Mon, 2009-11-09 at 20:08 +0800, Andy Yan wrote:
> From 8b51aa63e8b123046a334d630ae045f479acbf6c Mon Sep 17 00:00:00 200=
1
> From: andy <ayan@marvell.com>
> Date: Fri, 6 Nov 2009 17:03:21 +0800
> Subject: [PATCH 2/7] Add supporting MSI feature
>=20
> MSI feature is implemented with mvsas driver.
>=20
> Signed-off-by: Andy <ayan@marvell.com>
> Signed-off-by: Jacky <jfeng@marvell.com>
> Signed-off-by: Ke <kewei@marvell.com>

This doesn't compile:

  CC [M]  drivers/scsi/mvsas/mv_init.o
drivers/scsi/mvsas/mv_init.c: In function =E2=80=98mvs_enable_msi=E2=80=
=99:
drivers/scsi/mvsas/mv_init.c:197: error: =E2=80=98PCR_CMD=E2=80=99 unde=
clared (first use in this function)
drivers/scsi/mvsas/mv_init.c:197: error: (Each undeclared identifier is=
 reported only once
drivers/scsi/mvsas/mv_init.c:197: error: for each function it appears i=
n.)
drivers/scsi/mvsas/mv_init.c:201: error: =E2=80=98PCR_MSI_CTRL=E2=80=99=
 undeclared (first use in this function)
drivers/scsi/mvsas/mv_init.c: In function =E2=80=98mvs_disable_msi=E2=80=
=99:
drivers/scsi/mvsas/mv_init.c:208: error: =E2=80=98PCR_CMD=E2=80=99 unde=
clared (first use in this function)
drivers/scsi/mvsas/mv_init.c:212: error: =E2=80=98PCR_MSI_CTRL=E2=80=99=
 undeclared (first use in this function)

It looks like these definitions are added in patch 3 (after this
one) ... you can't do that: a patch series has to be bisectable

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
