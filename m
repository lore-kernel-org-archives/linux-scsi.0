From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Sun, 19 Aug 2012 18:30:04 +0300
Message-ID: <20120819153004.GU19851@reaktio.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
 <50237151.9000801@suse.com>
 <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
 <20120819144932.GT19851@reaktio.net>
 <yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:35672 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab2HSPaI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Aug 2012 11:30:08 -0400
Content-Disposition: inline
In-Reply-To: <yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

On Sun, Aug 19, 2012 at 11:18:57AM -0400, Martin K. Petersen wrote:
> >>>>> "Pasi" =3D=3D Pasi K=E4rkk=E4inen <pasik@iki.fi> writes:
>=20
> Pasi> Btw do you know which LSI mpt2sas HBAs support T10 DIF stuff?
> Pasi> (using 520 or 528 bytes/sector drives with checkums).
>=20
> Pasi> LSI SAS2008 based? SAS2308 based?
>=20
> SAS2008 and beyond.
>

Ok, good.

> 512-byte logical blocks + 8 bytes of PI.=20
>

So physically the disk is using 520 bytes/sector (and needs to support =
that),
but logically the HBA presents 512 bytes/sector + PI.. is that correct?=
=20

I guess what I'm asking is: Can I use sg_format to enable checksums/pro=
tection
on any disk that physically supports 520 bytes/sector,
or does the disk need to have special T10 data protection support aswel=
l?=20

> Linux does not support logical block sizes that are not powers of two=
=2E
>=20

Yep.

Thanks,

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
