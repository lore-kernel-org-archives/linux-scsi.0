From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 0/4] scsi: some (very) old clean ups
Date: Mon, 20 Jun 2016 12:03:02 +0300
Message-ID: <1466413382.30123.176.camel@linux.intel.com>
References: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65279 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbcFTJE2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 05:04:28 -0400
In-Reply-To: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, 2016-05-06 at 19:23 +0300, Andy Shevchenko wrote:
> This is a set of independent clean ups that didn't land upstream for
> ages (some
> are dated 2010!).=C2=A0=C2=A0As agreed with Martin at some point I re=
send
> them.
>=20
> I have more, but the rest is not yet ready for submission.

Gentle ping to get know what is the destiny of my patches.

>=20
> Andy Shevchenko (3):
> =C2=A0 libsas: remove private hex2bin() implementation
> =C2=A0 scsi: fnic: use kernel's '%pM' format option to print MAC
> =C2=A0 fusion: print lan address via %pMR
>=20
> Oleksandr Khoshaba (1):
> =C2=A0 scsi: qla4xxx: print MAC and SID via %p[mM][R]
>=20
> =C2=A0drivers/message/fusion/mptbase.c=C2=A0=C2=A0=C2=A0=C2=A0| 14 ++=
++----------
> =C2=A0drivers/scsi/fnic/vnic_dev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0| 10 ++--------
> =C2=A0drivers/scsi/libsas/sas_scsi_host.c | 22 ++++++----------------
> =C2=A0drivers/scsi/qla4xxx/ql4_mbx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0|=C2=A0=C2=A05 +----
> =C2=A0drivers/scsi/qla4xxx/ql4_nx.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0|=C2=A0=C2=A08 ++------
> =C2=A0drivers/scsi/qla4xxx/ql4_os.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0| 15 ++++-----------
> =C2=A06 files changed, 19 insertions(+), 55 deletions(-)
>=20

--=20

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
