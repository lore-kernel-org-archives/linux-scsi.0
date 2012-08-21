From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Mon, 20 Aug 2012 20:40:21 -0400
Message-ID: <yq1k3wtcc22.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com> <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
	<20120819144932.GT19851@reaktio.net>
	<yq1ehn2ewpq.fsf@sermon.lab.mkp.net>
	<20120819153004.GU19851@reaktio.net>
	<yq1628eet0s.fsf@sermon.lab.mkp.net>
	<20120820104818.GW19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:21934 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2HUAlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Aug 2012 20:41:10 -0400
In-Reply-To: <20120820104818.GW19851@reaktio.net> ("Pasi =?utf-8?Q?K=C3=A4?=
 =?utf-8?Q?rkk=C3=A4inen=22's?= message
	of "Mon, 20 Aug 2012 13:48:19 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:

Pasi> Btw do you know the current status of T10 PI support in md/dm
Pasi> raid?  If I understood correctly there's some support for
Pasi> raid0/raid1 implemented..

Yes. The only thing that doesn't work is RAID5/6.


Pasi> Are there any docs how to enable/disable/configure T10 PI for
Pasi> md/dm raid?  Perhaps the
Pasi> <bdev>/integrite/{write_enable|read_verify} work directly for the
Pasi> md/dm device?

You don't have to configure anything. If all component devices are
capable the md/dm device will register a suitable integrity profile.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
