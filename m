From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Mon, 20 Aug 2012 14:06:56 +0300
Message-ID: <20120820110656.GX19851@reaktio.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
 <50237151.9000801@suse.com>
 <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
 <20120819144932.GT19851@reaktio.net>
 <yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
 <20120819153004.GU19851@reaktio.net>
 <yq1628eet0s.fsf@sermon.lab.mkp.net>
 <20120820104818.GW19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:48824 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab2HTLHA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2012 07:07:00 -0400
Content-Disposition: inline
In-Reply-To: <20120820104818.GW19851@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

On Mon, Aug 20, 2012 at 01:48:19PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Sun, Aug 19, 2012 at 12:38:43PM -0400, Martin K. Petersen wrote:
> > >>>>> "Pasi" =3D=3D Pasi K=E4rkk=E4inen <pasik@iki.fi> writes:
> >=20
> > Pasi> So physically the disk is using 520 bytes/sector (and needs t=
o
> > Pasi> support that), but logically the HBA presents 512 bytes/secto=
r +
> > Pasi> PI.. is that correct?
> >=20
> > Yep. The beauty of PI is that we can store the extra stuff without
> > having to deal with weird block sizes.
> >=20
> >=20
> > Pasi> I guess what I'm asking is: Can I use sg_format to enable
> > Pasi> checksums/protection on any disk that physically supports 520
> > Pasi> bytes/sector, or does the disk need to have special T10 data
> > Pasi> protection support aswell?
> >=20
> > The disk needs to support T10 PI (PROTECT=3D1 in the Standard Inqui=
ry VPD
> > page). We don't support driving the HBA in PI mode with a non-PI ta=
rget.
> >=20
>=20
> Btw do you know the current status of T10 PI support in md/dm raid?=20
> If I understood correctly there's some support for raid0/raid1 implem=
ented..
>=20
> Are there any docs how to enable/disable/configure T10 PI for md/dm r=
aid?
> Perhaps the <bdev>/integrite/{write_enable|read_verify} work directly=
 for the md/dm device?=20
>=20

=2E. and I probably need to sg_format the backing devices to enable PI =
before enabling PI for the md/dm device?=20

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
