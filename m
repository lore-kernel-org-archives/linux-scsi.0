From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 14/43] qla2xxx: Add option for use reserve exch for ELS
Date: Wed, 20 Dec 2017 21:40:05 +0000
Message-ID: <F326042C-617C-429E-8AD3-6EC47CE411BF@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-15-himanshu.madhani@cavium.com>
 <1513788825.2603.28.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0074.outbound.protection.outlook.com ([104.47.40.74]:39712
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751955AbdLTVkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 16:40:07 -0500
In-Reply-To: <1513788825.2603.28.camel@wdc.com>
Content-Language: en-US
Content-ID: <E9D71CEE64B59C48B666C9994B0D0144@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,=20

> On Dec 20, 2017, at 10:53 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
>> +int qla2xuseresexchforels;
>> +module_param(qla2xuseresexchforels, int, 0444);
>> +MODULE_PARM_DESC(qla2xuseresexchforels,
>> +		 "Reserve 1/2 of emergency exchanges for ELS.\n"
>> +		 " 0 (default): disabled");
>=20
> Same question here as for another kernel module parameter: does this have=
 to
> be a kernel module parameter or could this have been implemented as a sys=
fs
> attribute?
>=20
> Thanks,
>=20
> Bart.

This does not have to be module parameter. Let me work on changing this to =
sysfs and
submit in next series with the correction

Thanks,
- Himanshu
