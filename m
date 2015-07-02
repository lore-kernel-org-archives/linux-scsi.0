From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: null pointer dereference panic caused by use after kref_put by st_open
Date: Thu, 2 Jul 2015 18:53:07 +0300
Message-ID: <7CAAAEF5-412C-44F2-BA89-9DA516516591@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB44430852@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:47024 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbGBPxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2015 11:53:14 -0400
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44430852@G9W0766.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James Bottomley (JBottomley@Odin.com)" <JBottomley@Odin.com>, "Lavender, Darren Christopher" <darren.lavender@hp.com>


> On 2.7.2015, at 15.01, Seymour, Shane M <shane.seymour@hp.com> wrote:
>=20
>=20
> Two SLES11 SP3 servers encountered similar crashes simultaneously
> following some kind of SAN/tape target issue:
>=20
=2E..
> The crash is fixed by reordering the code so we no longer access
> the struct scsi_tape after the kref_put() is done on it in st_open().
>=20
> Signed-off-by: Shane Seymour <shane.seymour@hp.com>
> Signed-off-by: Darren Lavender <darren.lavender@hp.com>

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks for finding this. No code should touch an object after put().

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
