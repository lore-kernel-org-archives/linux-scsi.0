From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 19/25] qla2xxx: Replace ql2xexchoffld & ql_dm_tgt_ex_pct
 parameter
Date: Mon, 22 May 2017 17:39:12 +0000
Message-ID: <9E2AEDEB-CDBF-4F17-BE3A-DFADF44933EE@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
 <20170519215344.2168-20-himanshu.madhani@cavium.com>
 <1495236443.2581.17.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0064.outbound.protection.outlook.com ([104.47.41.64]:34936
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1760523AbdEVRjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 May 2017 13:39:15 -0400
In-Reply-To: <1495236443.2581.17.camel@sandisk.com>
Content-Language: en-US
Content-ID: <B977FFBD2D8B6846A82058A9C9446143@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,=20

> On May 19, 2017, at 4:27 PM, Bart Van Assche <bart.vanassche@sandisk.com>=
 wrote:
>=20
> On Fri, 2017-05-19 at 14:53 -0700, Himanshu Madhani wrote:
>> [ ... ]
>> -int ql2xexchoffld =3D 0;
>> -module_param(ql2xexchoffld, uint, S_IRUGO|S_IWUSR);
>> -MODULE_PARM_DESC(ql2xexchoffld,
>> -		 "Number of exchanges to offload. "
>> -		 "0 (Default)- Disabled.");
>> +int ql2xtgtexchg =3D 1024;
>> +module_param(ql2xtgtexchg, uint, 0644);
>> +MODULE_PARM_DESC(ql2xtgtexchg,
>> +	"Number of target exchanges.");
>> +
>> +int ql2xiniexchg =3D 1024;
>> +module_param(ql2xiniexchg, uint, 0644);
>> +MODULE_PARM_DESC(ql2xtgtexchg,
>> +	"Number of initiator exchanges.");
>>=20
>=20
> [ ... ]
>=20
>> -static int ql_dm_tgt_ex_pct =3D 50;
>> -module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);
>> -MODULE_PARM_DESC(ql_dm_tgt_ex_pct,
>> -	"For Dual Mode (qlini_mode=3Ddual), this parameter determines "
>> -	"the percentage of exchanges/cmds FW will allocate resources "
>> -	"for Target mode.");
>> -
>=20
> Hello Himanshu and Quinn,
>=20
> Renaming internal variables is fine but renaming module parameters is not
> acceptable. Please don't do this.
>=20
> Thanks,
>=20
> Bart.

Will update patch to preserve module parameter.=20

Thanks,
- Himanshu
