From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Can not see/access devices on Marvell 88SE9485 + SiI 3726 PMP
Date: Wed, 03 Jul 2013 08:07:32 -0700
Message-ID: <1372864052.3601.24.camel@dabdike>
References: <51D18DA6.8000502@gmail.com> <1372689482.2385.15.camel@dabdike>
	 <51D41EA7.20308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39069 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756127Ab3GCPHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 11:07:34 -0400
In-Reply-To: <51D41EA7.20308@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hajo =?ISO-8859-1?Q?M=F6ller?= <dasjoe@gmail.com>
Cc: linux-scsi@vger.kernel.org, yuxiangl@marvell.com

On Wed, 2013-07-03 at 14:52 +0200, Hajo M=F6ller wrote:
> On 01.07.2013 16:38, James Bottomley wrote:
> > mv_sas is a libsas based driver.  libsas doesn't have any support f=
or
> > SATA PMPs.  When it was added they were left as a todo item but the=
n in
> > the field everyone deployed enterprise type SATA devices in SAS exp=
ander
> > chassis, so PMP support just got forgotten.
>=20
> That's a pity, so it's unlikely libsas will get support for PMPs in t=
he
> near future or at all?  Sadly I'm not able to add the support myself.
>=20
> Do you know of any SAS controllers which do support SATA PMPs?
> I'm stuck with the PMPs, so I'm trying a SATA controller with an
> 88SX7042 next, although having a good SAS controller would be better =
in
> the long run.

No, I'm afraid not.  Libsas has been released for nearly seven years an=
d
no-one has noticed in all that time, which means it's a really rare
thing to do.  Everyone who uses SAS controllers usually has either a
direct connection or an expander.  There's no real reason to buy
expensive kit and then plug it into a cheap port switch.  That said,
it's possible that some of the firmware SAT blob based controllers, lik=
e
the MPT ones might have PMP support ... but because of the rarity it's
likely to be buggy.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
