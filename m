From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi-sg: pass flag to inhibit setting LUN
Date: Fri, 03 Jan 2014 15:21:34 -0500
Message-ID: <yq1ha9kzui9.fsf@sermon.lab.mkp.net>
References: <52C56755.7060709@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20617 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaACUWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 15:22:00 -0500
In-Reply-To: <52C56755.7060709@seznam.cz> (=?utf-8?B?IkppxZnDrQ==?=
 Pinkava"'s message of "Thu,
	02 Jan 2014 14:19:17 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?SmnFmcOt?= Pinkava <j-pi@seznam.cz>
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com

>>>>> "Ji=C5=99=C3=AD" =3D=3D Ji=C5=99=C3=AD Pinkava <j-pi@seznam.cz> w=
rites:

Ji=C5=99=C3=AD> This patch implements support for inhibiting setting LU=
N number
Ji=C5=99=C3=AD> for SCSI custom command send via /dev/sgX with ioctl(..=
, SG_IO,
Ji=C5=99=C3=AD> ...) call.

Is it an absolute requirement that this is a per-command option or coul=
d
we have a scsi_device quirk flag so we didn't have to plumb this throug=
h
the entire I/O stack?

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
