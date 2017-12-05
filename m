From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v3 00/22]  qla2xxx: Bug fixes for 4.15-rc2
Date: Tue, 5 Dec 2017 05:28:09 +0000
Message-ID: <E2C1FCEE-E4A1-4942-A711-730ABF4E4A4D@cavium.com>
References: <20171204224517.3409-1-himanshu.madhani@cavium.com>
 <yq1k1y16heg.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0048.outbound.protection.outlook.com ([104.47.37.48]:16800
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751052AbdLEF2L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Dec 2017 00:28:11 -0500
In-Reply-To: <yq1k1y16heg.fsf@oracle.com>
Content-Language: en-US
Content-ID: <7CE6D8E2A4B3844EB02556F973BCE05E@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,=20

> On Dec 4, 2017, at 6:24 PM, Martin K. Petersen <martin.petersen@oracle.co=
m> wrote:
>=20
>=20
> Himanshu,
>=20
>> drivers/scsi/qla2xxx/qla_def.h     |  49 ++++----
>> drivers/scsi/qla2xxx/qla_gs.c      | 230 ++++++++++++++++++++++++++++++-=
------
>> drivers/scsi/qla2xxx/qla_init.c    |  69 +++++++++--
>> drivers/scsi/qla2xxx/qla_iocb.c    |  13 ---
>> drivers/scsi/qla2xxx/qla_isr.c     |   7 +-
>> drivers/scsi/qla2xxx/qla_mbx.c     |   3 +-
>> drivers/scsi/qla2xxx/qla_mid.c     |  42 ++++---
>> drivers/scsi/qla2xxx/qla_os.c      |  78 ++++++++++---
>> drivers/scsi/qla2xxx/qla_target.c  |  60 +++++++---
>> drivers/scsi/qla2xxx/qla_version.h |   2 +-
>> 10 files changed, 405 insertions(+), 148 deletions(-)
>=20
> This looks pretty big for a series of bug fixes. Are all these patches
> really candidates for 4.15 and stable backports all the way back to
> 4.10?
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering


Yes Please. I would want them back ported to 4.10 since these issues were d=
iscovered in combination of 4.10/4.11 kernel.

Thanks,
- Himanshu
