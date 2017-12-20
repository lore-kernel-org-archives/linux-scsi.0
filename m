From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 02/43] qla2xxx: Fix NULL pointer access for fcport
 structure
Date: Wed, 20 Dec 2017 20:38:13 +0000
Message-ID: <FA09399C-53E4-4042-B4CC-303FAE980035@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-3-himanshu.madhani@cavium.com>
 <1513787192.2603.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0086.outbound.protection.outlook.com ([104.47.41.86]:33452
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755557AbdLTUiQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 15:38:16 -0500
In-Reply-To: <1513787192.2603.12.camel@wdc.com>
Content-Language: en-US
Content-ID: <BD3DEFD58F18304A987FFCBDA88E3095@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Dec 20, 2017, at 10:26 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
>> From: Quinn Tran <quinn.tran@cavium.com>
>>=20
>> when preocessing iocb in a timeout case, driver was trying to log messag=
es
>       ^^^^^^^^^^^
>       processing?
>=20
> Bart.

Will fix in v2 of the series

Thanks,
- Himanshu
