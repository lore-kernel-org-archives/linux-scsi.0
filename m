From: Jean Delvare <jdelvare@suse.de>
Subject: Re: Kernel oops on st module cycling
Date: Wed, 20 Mar 2013 17:56:10 +0100
Message-ID: <1363798570.4522.13.camel@amber.site>
References: <1361538170.24311.209.camel@amber.site>
	 <alpine.DEB.2.02.1302221017330.1736@jlaw-desktop.mno.stratus.com>
	 <1362660484.4312.11.camel@amber.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3CTQ4H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Mar 2013 12:56:07 -0400
In-Reply-To: <1362660484.4312.11.camel@amber.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Kai =?ISO-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, JoeLawrence <Joe.Lawrence@stratus.com>, linux-scsi@vger.kernel.org

Le jeudi 07 mars 2013 =C3=A0 13:48 +0100, Jean Delvare a =C3=A9crit :
> Hi Joe,
>=20
> Thanks for your fast answer.
>=20
> Le vendredi 22 f=C3=A9vrier 2013 =C3=A0 10:30 -0500, Joe Lawrence a =C3=
=A9crit :
> > I remember finding an st module load/unload kref accounting bug a w=
hile=20
> > ago: http://thread.gmane.org/gmane.linux.scsi/77539  I replied to t=
he=20
> > report with a hack-patch that grabbed an extra reference to avoid t=
he=20
> > crash.
> >=20
> > There was an attempt at fixing this up in the block layer [1] but t=
hat=20
> > change was pulled when problems were found with that patch [2].
> >=20
> > [1] https://lkml.org/lkml/2012/8/27/354
> > [2] https://lkml.org/lkml/2012/9/22/113
> >=20
> > Maybe this is the same bug?
>=20
> Seems so. Meanwhile I saw you posted an update at:
> http://marc.info/?l=3Dlinux-scsi&m=3D136249932603011&w=3D2
>=20
> I have tested this patch successfully, and apparently others have as
> well, so I would suggest to get this upstream ASAP. I think this fix =
is
> a candidate for stable kernel series as well.
>=20
> Note for backporters: the value returned by blk_get_queue() changed i=
n
> kernel 3.3, so care must be taken when backporting the fix to kernel =
3.2
> or older, otherwise success becomes failure and vice versa.

James, this patch got successfully tested and positively reviewed. Can
you please queue it and push it upstream?

Thanks,
--=20
Jean Delvare
Suse L3

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
