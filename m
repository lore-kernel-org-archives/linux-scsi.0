From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 00/37] qla2xxx: driver updates
Date: Thu, 4 Jan 2018 06:13:10 +0000
Message-ID: <0EE5335A-9558-4E9C-BEAA-A4F24EF96BFE@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
 <yq1mv1uw4dz.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0049.outbound.protection.outlook.com ([104.47.40.49]:3040
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752015AbeADGNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 4 Jan 2018 01:13:13 -0500
In-Reply-To: <yq1mv1uw4dz.fsf@oracle.com>
Content-Language: en-US
Content-ID: <E4C9CB1F493E224C8833F533D556DD49@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Martin,=20

> On Jan 3, 2018, at 9:59 PM, Martin K. Petersen <martin.petersen@oracle.co=
m> wrote:
>=20
>=20
> Hi Himanshu!
>=20
>> This series contains number of improvments in handling of switch
>> registration commands in the driver. Switch commands are now submitted
>> via IOCB patch asynchronously instead of mailbox interface.
>=20
> Applied to 4.16/scsi-queue. However, ...
>=20
>> 17 files changed, 2891 insertions(+), 1131 deletions(-)
>=20
> Next time please don't submit a series this big. It is really, really
> painful to review. Especially when some of the patches are huge.
>=20
> I would much rather have 3-4 sets of 8-10 patches scattered throughout
> the development cycle. Or a slow, steady trickle of bug fixes with maybe
> a few bigger "new feature" series of logically related patches posted
> separately to facilitate review.
>=20

Understood. Will make sure to send out smaller series for future.=20

> Thanks!
> Martin
>=20
> --=20
> Martin K. Petersen	Oracle Linux Engineering

Thanks,
- Himanshu
