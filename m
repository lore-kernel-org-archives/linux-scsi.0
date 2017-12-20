From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 03/43] qla2xxx: Use IOCB path to submit Control VP MBX
 command
Date: Wed, 20 Dec 2017 20:39:38 +0000
Message-ID: <75BEF7BF-0463-4983-AC37-05C18117796F@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-4-himanshu.madhani@cavium.com>
 <1513787365.2603.15.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0084.outbound.protection.outlook.com ([104.47.41.84]:3904
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754428AbdLTUjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 15:39:40 -0500
In-Reply-To: <1513787365.2603.15.camel@wdc.com>
Content-Language: en-US
Content-ID: <6C0F78BEA1F98546A46DDDF9F1637A1F@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Dec 20, 2017, at 10:29 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
>> @@ -536,7 +541,7 @@ struct sp_name {
>> #define SRB_NVME_CMD	19
>> #define SRB_NVME_LS	20
>> #define SRB_PRLI_CMD	21
>> -
>> +#define SRB_CTRL_VP	22
>> enum {
>=20
> Please keep the blank line between the #define block and the enum definit=
ion.
>=20

Sure

>> +/*
>> + * qla24xx_control_vp
>> + *	Enable a virtual port for given host
>> + *
>> + * Input:
>> + *	ha =3D adapter block pointer.
>> + *	vhba =3D virtual adapter (unused)
>> + *	index =3D index number for enabled VP
>> + *
>> + * Returns:
>> + *	qla2xxx local function return status code.
>> + *
>> + * Context:
>> + *	Kernel context.
>> + */
>> +int
>> +qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>=20
> Have you considered to use the kernel-doc style for this function header?=
 See
> also https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt.
>=20
> Thanks,
>=20
> Bart.

Will update to kernel-doc style for the header.

Thanks,
- Himanshu
