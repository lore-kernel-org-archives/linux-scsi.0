From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 06/43] qla2xxx: Fix stale mem access for IRQ name
Date: Wed, 20 Dec 2017 20:41:26 +0000
Message-ID: <7355C56A-5B80-45F5-8BAA-475349318A0A@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-7-himanshu.madhani@cavium.com>
 <1513787959.2603.19.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0089.outbound.protection.outlook.com ([104.47.41.89]:59708
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754428AbdLTUl2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 15:41:28 -0500
In-Reply-To: <1513787959.2603.19.camel@wdc.com>
Content-Language: en-US
Content-ID: <A0A83A6E71DDAB4E8D4DA11C1C71B26B@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Dec 20, 2017, at 10:39 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@cavium.com>
>>=20
>> IRQ name pointer for INTx/MSI was pointing at stale stack frame.
>> cat /proc/interrupts will trigger stale mem access. Fix it by
>> creating dedicated space for IRQ name.
>=20
> What stale stack frame are you referring to? Just like in the first patch
> of this series, I don't see any stack accesses being removed by this patc=
h.
> Is this patch useful? If not, can this patch be left out?
>=20
> Thanks,
>=20
> Bart.

will drop this patch.=20

Thanks,
- Himanshu
