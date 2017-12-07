From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v3 00/22]  qla2xxx: Bug fixes for 4.15-rc2
Date: Thu, 7 Dec 2017 03:51:50 +0000
Message-ID: <B0E82B1E-596D-4795-8692-1B4300B7989E@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
 <yq1k1y16heg.fsf@oracle.com>
 <E2C1FCEE-E4A1-4942-A711-730ABF4E4A4D@cavium.com>
 <yq1bmjbxno4.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0088.outbound.protection.outlook.com ([104.47.37.88]:5490
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752129AbdLGDvw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Dec 2017 22:51:52 -0500
In-Reply-To: <yq1bmjbxno4.fsf@oracle.com>
Content-Language: en-US
Content-ID: <96C358CD0F9BD246981910C483C9F277@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,=20

> On Dec 6, 2017, at 6:43 PM, Martin K. Petersen <martin.petersen@oracle.co=
m> wrote:
>=20
>=20
> Himanshu,
>=20
>>> This looks pretty big for a series of bug fixes. Are all these
>>> patches really candidates for 4.15 and stable backports all the way
>>> back to 4.10?
>=20
>> Yes Please. I would want them back ported to 4.10 since these issues
>> were discovered in combination of 4.10/4.11 kernel.
>=20
> James already sent Linus a pull request for this week. So that would put
> your series out another week. 22 patches and 400+ insertions. That's a
> lot of churn for rc4, and while the changes are indeed fixes and not new
> features, the whole thing still looks like a regular merge window driver
> update to me.
>=20
> This series really should have been posted before the 4.15 merge window
> opened. However, the first iteration of this series was posted after rc1
> was out. I'm terribly sorry, but that's just too late for something this
> size.
>=20

> I queued everything up for 4.16.
>=20

Understood the concern and i am okay this to be queued for 4.16

> --=20
> Martin K. Petersen	Oracle Linux Engineering

Thanks,
- Himanshu=
