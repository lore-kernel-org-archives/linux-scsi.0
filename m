From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] pm8001: raise host can queue
Date: Thu, 22 Sep 2011 12:34:36 +0800
Message-ID: <B728E837EB904EDEA62AB9C9DCF11A34@usish.com.cn>
References: <CE155251DF87469DA8F1A8290EDCF361@usish.com.cn> <CAA9_cme5EOrkC_LKfVdEoqch9C_KYireVX79OUgPcsEoQ2MeqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37517 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804Ab1IVEey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2011 00:34:54 -0400
In-Reply-To: <CAA9_cme5EOrkC_LKfVdEoqch9C_KYireVX79OUgPcsEoQ2MeqA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, 'lindar_liu' <lindar_liu@usish.com>, crystal_yu@usish.com, john_gong@usish.com, mark_salyzyn@us.xyratex.com, 'Christoph Hellwig' <hch@infradead.org>

Hi Dan

Not a real concern, the hardware is not limit to process 128 commands.

Jack
Re: [PATCH] pm8001: raise host can queue
>=20
> On Wed, Sep 21, 2011 at 7:05 PM, Jack Wang <jack_wang@usish.com> wrot=
e:
> > Hi James,
> >
> > Because Dan change device queue depth to 256, and as point by Mark =
this
may
> > result in starvation, so I bump the host can queue value to 510.
>=20
> Hi,
>=20
> Is this a theoretical or actual concern?  Because the mid-layer shoul=
d
> be handling starvation if I understand the mechanics of the
> shost->starved_list.
>=20
> --
> Dan
>=20
> > Best regards!
> >
> > Jack
> >
> > From 3647cde88d66760ca336ad127a5b1fdf5c1d28f7 Mon Sep 17 00:00:00 2=
001
> > From: Jack Wang <jack_wang@usish.com>
> > Date: Thu, 22 Sep 2011 09:50:54 +0800
> > Subject: [PATCH] bump host can queue to follow libsas queue depth c=
hange
> >
> > Signed-off-by: Jack Wang <jack_wang@usish.com>
> > ---
> > =A0pm8001_defs.h | =A0 =A02 +-
> > =A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/pm8001_defs.h b/pm8001_defs.h
> > index 944afad..704b492 100644
> > --- a/pm8001_defs.h
> > +++ b/pm8001_defs.h
> > @@ -68,7 +68,7 @@ enum port_type {
> > =A0#define =A0 =A0 =A0 =A0PM8001_MAX_CCB =A0 =A0 =A0 =A0 =A0 512 =A0=
 =A0/* max ccbs supported
> */
> > =A0#define =A0 =A0 =A0 =A0PM8001_MAX_INB_NUM =A0 =A0 =A0 1
> > =A0#define =A0 =A0 =A0 =A0PM8001_MAX_OUTB_NUM =A0 =A0 =A01
> > -#define =A0 =A0 =A0 =A0PM8001_CAN_QUEUE =A0 =A0 =A0 =A0 128 =A0 =A0=
/* SCSI Queue depth */
> > +#define =A0 =A0 =A0 =A0PM8001_CAN_QUEUE =A0 =A0 =A0 =A0 510 =A0 =A0=
/* SCSI Queue depth */
>=20
>=20
> >
> > =A0/* unchangeable hardware details */
> > =A0#define =A0 =A0 =A0 =A0PM8001_MAX_PHYS =A0 =A0 =A0 =A0 =A08 =A0 =
=A0 =A0/* max. possible phys
> */
> > --
> > 1.7.4.msysgit.0
> >
> >
> >

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
