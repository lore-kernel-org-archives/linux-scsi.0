From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Sun, 19 Aug 2012 11:18:57 -0400
Message-ID: <yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com> <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
	<20120819144932.GT19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:50381 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2HSPTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Aug 2012 11:19:20 -0400
In-Reply-To: <20120819144932.GT19851@reaktio.net> ("Pasi =?utf-8?Q?K=C3=A4?=
 =?utf-8?Q?rkk=C3=A4inen=22's?= message
	of "Sun, 19 Aug 2012 17:49:32 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:

Pasi> Btw do you know which LSI mpt2sas HBAs support T10 DIF stuff?
Pasi> (using 520 or 528 bytes/sector drives with checkums).

Pasi> LSI SAS2008 based? SAS2308 based?

SAS2008 and beyond. 512-byte logical blocks + 8 bytes of PI. Linux does
not support logical block sizes that are not powers of two.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
