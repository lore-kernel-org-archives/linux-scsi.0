From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 0/5] qla2xxx: Patches for scsi-misc
Date: Thu, 26 Oct 2017 03:48:31 +0000
Message-ID: <0C70897A-1079-4B40-A61D-BDBBD2BA0465@cavium.com>
References: <20171013163407.8038-1-himanshu.madhani@cavium.com>
 <yq1fuai1nfi.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0077.outbound.protection.outlook.com ([104.47.32.77]:5964
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751973AbdJZDsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 23:48:33 -0400
In-Reply-To: <yq1fuai1nfi.fsf@oracle.com>
Content-Language: en-US
Content-ID: <DAB8B751394A40458C95E0CAED5CC8A2@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,=20

> On Oct 16, 2017, at 8:08 PM, Martin K. Petersen <martin.petersen@oracle.c=
om> wrote:
>=20
>=20
> Madhani,
>=20
>> This series adds support for INTx mode for qla2xxx driver. Also, adds
>> support for N2N login for FC-NVMe.
>>=20
>> Please apply to 4.15/scsi-queue at your earliest convenience.
>=20
> Several of the patches had bad whitespace. Please run checkpatch before
> submitting. Also, you did not apply the review tags you got from
> Johannes for v1.
>=20

Appreciate the feedback. Will check for those misses more closely for next =
submissions.=20

> I fixed those things up. Applied to 4.15/scsi-queue.
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering

Thanks,
- Himanshu
