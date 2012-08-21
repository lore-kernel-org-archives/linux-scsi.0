From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Mon, 20 Aug 2012 20:43:49 -0400
Message-ID: <yq1fw7hcbwa.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com> <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
	<20120819144932.GT19851@reaktio.net>
	<yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
	<20120819153004.GU19851@reaktio.net>
	<yq1628eet0s.fsf@sermon.lab.mkp.net>
	<20120820104818.GW19851@reaktio.net>
	<20120820110656.GX19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:44801 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2HUAoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 20:44:13 -0400
In-Reply-To: <20120820110656.GX19851@reaktio.net> ("Pasi =?utf-8?Q?K=C3=A4?=
 =?utf-8?Q?rkk=C3=A4inen=22's?= message
	of "Mon, 20 Aug 2012 14:06:56 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:

Pasi> .. and I probably need to sg_format the backing devices to enable
Pasi> PI

Yes. Unless the drive is already formatted with PI. The latter is
becoming increasingly common as a PI-drive will work just fine in a
"legacy" setup. Many current drives provide the same LBA count
regardless of whether PI is enabled or not. So there isn't much point i=
n
not enabling it.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
