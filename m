From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 0/6] qla2xxx: Bug fixes for driver
Date: Thu, 27 Jul 2017 03:59:12 +0000
Message-ID: <F77B89F7-6CF4-480B-BD64-FEEBC31B4969@cavium.com>
References: <20170721163228.32339-1-himanshu.madhani@cavium.com>
 <yq1eft2y72u.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0053.outbound.protection.outlook.com ([104.47.33.53]:12275
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751465AbdG0D7P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 23:59:15 -0400
In-Reply-To: <yq1eft2y72u.fsf@oracle.com>
Content-Language: en-US
Content-ID: <5A5B26DF8AB7CF40A39FB6FEDBFF7029@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,=20

> On Jul 26, 2017, at 6:58 PM, Martin K. Petersen <martin.petersen@oracle.c=
om> wrote:
>=20
>=20
> Himanshu,
>=20
>> This series addresses review comments for previously submitted series fo=
r
>> target multiqueue and FC-NVMe support in 4.13.0-rc1
>>=20
>> Patches 1,2 addresses review comments by Johannes for FC-NVMe series
>> (https://www.spinics.net/lists/linux-scsi/msg110077.html)
>> (https://www.spinics.net/lists/linux-scsi/msg109985.html)
>>=20
>> Patch 3 adds ZIO support for FC-NVMe
>>=20
>> Patch 4 simplifies unregistration of local/remote FC-NVMe ports.
>>=20
>> Patch 5 fixes handling of remote-port disconnect for FC-NVMe.
>>=20
>> Patch 6 addresses review comments by Bart for Target Multiqueue series.
>> (https://www.spinics.net/lists/target-devel/msg15563.html)
>=20
> It seems to me like patch 5 is the only bug fix candidate for 4.13 and
> the rest of these should go into 4.14?
>=20

I am okay with 4.14 for the whole series=20

> --=20
> Martin K. Petersen	Oracle Linux Engineering

Thanks,
- Himanshu
