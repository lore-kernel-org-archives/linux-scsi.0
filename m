From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Tue, 02 Oct 2012 18:24:19 -0400
Message-ID: <yq11uhg4ing.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com> <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
	<20121001091746.GA8912@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:37893 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2JBWYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 18:24:40 -0400
In-Reply-To: <20121001091746.GA8912@reaktio.net> ("Pasi =?utf-8?Q?K=C3=A4r?=
 =?utf-8?Q?kk=C3=A4inen=22's?= message
	of "Mon, 1 Oct 2012 12:17:46 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Ankit Jain <jankit@suse.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

>>>>> "Pasi" =3D=3D Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> writes:

>> 2 of the patches are absolutely trivial and should just be applied.
>> However, LSI objects to patch #3 which tweaks an incorrect NVDATA
>> flag from within the driver.
>>=20
>> Instead LSI has promised to revert to the original behavior in their
>> firmware/NVDATA updates. Eric, can you give us an update? There was
>> another bug report on linux-scsi just a couple of weeks ago.

Pasi> Hopefully these T10 patches can go in during the 3.7 merge window=
!

The 2 trivial patches are queued for 3.7, yes. LSI are still working th=
e
bad NVDATA default issue.

--=20
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
