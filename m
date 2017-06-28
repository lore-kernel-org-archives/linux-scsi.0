From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 1/6] qla2xxx: Add FC-NVMe port discovery and PRLI
 handling
Date: Wed, 28 Jun 2017 21:23:54 +0000
Message-ID: <85036153-277E-4F9D-9328-665D73B2F68E@cavium.com>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-2-himanshu.madhani@cavium.com>
 <1498684545.2769.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0049.outbound.protection.outlook.com ([104.47.36.49]:36608
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751515AbdF1VX6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 17:23:58 -0400
In-Reply-To: <1498684545.2769.17.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <A3DB8E5D8BBC7F43925720D8C3819DA6@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Hi James,

> On Jun 28, 2017, at 2:15 PM, James Bottomley <James.Bottomley@HansenPartn=
ership.com> wrote:
>=20
> On Wed, 2017-06-21 at 13:48 -0700, Madhani, Himanshu wrote:
>> From: Duane Grigsby <duane.grigsby@cavium.com>
>>=20
>> Added logic to change the login process into an optional PRIL
>> step for FC-NVMe ports as a separate operation, such that we can
>> change type to 0x28 (NVMe).
>>=20
>> Currently, the driver performs the PLOGI/PRLI together as one
>> operation, but if the discovered port is an NVMe port then we
>> first issue the PLOGI and then we issue the PRLI. Also, the
>> fabric discovery logic was changed to mark each discovered FC
>> NVMe port, so that we can register them with the FC-NVMe transport
>> later.
>>=20
>> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
>> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
>> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
>=20
> I just got a whole load of bounces from this: you've misspelled Anil's
> email address (h and t transposed).  It looks like a generic cut and
> paste, so could you fix it for next time?
>=20
> Thanks,
>=20
> James
>=20

Sorry about that. Will fix this up for next time.

Thanks,
- Himanshu
