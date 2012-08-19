From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Sun, 19 Aug 2012 12:38:43 -0400
Message-ID: <yq1628eet0s.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com> <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
	<20120819144932.GT19851@reaktio.net>
	<yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
	<20120819153004.GU19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44770 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2HSQkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Aug 2012 12:40:09 -0400
In-Reply-To: <20120819153004.GU19851@reaktio.net> ("Pasi =?utf-8?Q?K=C3=A4?=
 =?utf-8?Q?rkk=C3=A4inen=22's?= message
	of "Sun, 19 Aug 2012 18:30:04 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:

Pasi> So physically the disk is using 520 bytes/sector (and needs to
Pasi> support that), but logically the HBA presents 512 bytes/sector +
Pasi> PI.. is that correct?

Yep. The beauty of PI is that we can store the extra stuff without
having to deal with weird block sizes.


Pasi> I guess what I'm asking is: Can I use sg_format to enable
Pasi> checksums/protection on any disk that physically supports 520
Pasi> bytes/sector, or does the disk need to have special T10 data
Pasi> protection support aswell?

The disk needs to support T10 PI (PROTECT=3D1 in the Standard Inquiry V=
PD
page). We don't support driving the HBA in PI mode with a non-PI target=
=2E

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
