From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Tue, 21 Aug 2012 09:13:23 +0300
Message-ID: <20120821061323.GB19851@reaktio.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
 <50237151.9000801@suse.com>
 <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
 <20120819144932.GT19851@reaktio.net>
 <yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
 <20120819153004.GU19851@reaktio.net>
 <yq1628eet0s.fsf@sermon.lab.mkp.net>
 <20120820104818.GW19851@reaktio.net>
 <20120820110656.GX19851@reaktio.net>
 <yq1fw7hcbwa.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:42167 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2HUGN0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Aug 2012 02:13:26 -0400
Content-Disposition: inline
In-Reply-To: <yq1fw7hcbwa.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

On Mon, Aug 20, 2012 at 08:43:49PM -0400, Martin K. Petersen wrote:
> >>>>> "Pasi" =3D=3D Pasi K=E4rkk=E4inen <pasik@iki.fi> writes:
>=20
> Pasi> .. and I probably need to sg_format the backing devices to enab=
le
> Pasi> PI
>=20
> Yes. Unless the drive is already formatted with PI. The latter is
> becoming increasingly common as a PI-drive will work just fine in a
> "legacy" setup. Many current drives provide the same LBA count
> regardless of whether PI is enabled or not. So there isn't much point=
 in
> not enabling it.
>=20

Makes sense, thanks!

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
