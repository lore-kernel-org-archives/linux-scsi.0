From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Tue, 21 Aug 2012 09:12:56 +0300
Message-ID: <20120821061256.GA19851@reaktio.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
 <50237151.9000801@suse.com>
 <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
 <20120819144932.GT19851@reaktio.net>
 <yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
 <20120819153004.GU19851@reaktio.net>
 <yq1628eet0s.fsf@sermon.lab.mkp.net>
 <20120820104818.GW19851@reaktio.net>
 <yq1k3wtcc22.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:53131 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2HUGNA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Aug 2012 02:13:00 -0400
Content-Disposition: inline
In-Reply-To: <yq1k3wtcc22.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

On Mon, Aug 20, 2012 at 08:40:21PM -0400, Martin K. Petersen wrote:
> >>>>> "Pasi" =3D=3D Pasi K=E4rkk=E4inen <pasik@iki.fi> writes:
>=20
> Pasi> Btw do you know the current status of T10 PI support in md/dm
> Pasi> raid?  If I understood correctly there's some support for
> Pasi> raid0/raid1 implemented..
>=20
> Yes. The only thing that doesn't work is RAID5/6.
>=20

Ok, thanks for confirming that.

>=20
> Pasi> Are there any docs how to enable/disable/configure T10 PI for
> Pasi> md/dm raid?  Perhaps the
> Pasi> <bdev>/integrite/{write_enable|read_verify} work directly for t=
he
> Pasi> md/dm device?
>=20
> You don't have to configure anything. If all component devices are
> capable the md/dm device will register a suitable integrity profile.
>=20

Oh, nice! I'll have to try it once I get some drives with PI.

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
