From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 0/6] Six qla2xxx and qla4xxx patches
Date: Wed, 31 Jan 2018 05:57:55 +0000
Message-ID: <9E0BB966-2EF3-47A4-9517-2966957B4F9A@cavium.com>
References: <20180124003351.2616-1-bart.vanassche@wdc.com>
 <yq1tvv2enju.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0051.outbound.protection.outlook.com ([104.47.36.51]:43392
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751289AbeAaF54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 00:57:56 -0500
In-Reply-To: <yq1tvv2enju.fsf@oracle.com>
Content-Language: en-US
Content-ID: <AC8E1C34ADDBD34B88F065E0BC4E55DD@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,=20

> On Jan 30, 2018, at 7:04 PM, Martin K. Petersen <martin.petersen@oracle.c=
om> wrote:
>=20
>=20
> Bart,
>=20
>> The patches in this series are what I came up with after having analyzed
>> the source code of the qla[24]xxx drivers with several source code analy=
sis
>> tools (scripts/kernel-doc, gcc, sparse and smatch). None of the patches =
in
>> this series have been tested. Yet I'm asking you to consider at least th=
e
>> first patch of this series for kernel v4.16 because it fixes a locking b=
ug
>> in one of the SCSI patches queued for kernel v4.16.
>=20
> Himanshu and team: Please review!
>=20

Series looks good

Acked-by: Himanshu Madhani <himanshu.madhani@cavium.com>

> --=20
> Martin K. Petersen	Oracle Linux Engineering

Thanks,
- Himanshu
