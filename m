From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/5] qla2xxx: Add module param ql2xenablemsix
Date: Fri, 13 Oct 2017 18:52:31 +0000
Message-ID: <EE884809-2674-4801-A74A-2784467F4B09@cavium.com>
References: <20171011203650.23629-1-himanshu.madhani@cavium.com>
 <20171011203650.23629-2-himanshu.madhani@cavium.com>
 <20171012071957.gb2zobb7jqsuv4cq@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0061.outbound.protection.outlook.com ([104.47.41.61]:3526
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751279AbdJMSwe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 14:52:34 -0400
In-Reply-To: <20171012071957.gb2zobb7jqsuv4cq@linux-x5ow.site>
Content-Language: en-US
Content-ID: <264DD88788B7B1418BC8191A626C850A@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Johannes,=20

> On Oct 12, 2017, at 12:19 AM, Johannes Thumshirn <jthumshirn@suse.de> wro=
te:
>=20
> On Wed, Oct 11, 2017 at 01:36:46PM -0700, Madhani, Himanshu wrote:
> [...]
>> +int ql2xenablemsix =3D 1;
>> +module_param(ql2xenablemsix, int, 0444);
>> +MODULE_PARM_DESC(ql2xenablemsix,
>> +    "Set to enable MSI or MSI-X interrupt mechanism.\n"
>> +    " Default is 1, enable MSI-X interrupt mechanism.\n"
>> +    " 0 -- enable traditional pin-based mechanism.\n"
>> +    " 1 -- enable MSI-X interrupt mechanism.\n"
>> +    " 2 -- enable MSI interrupt mechanism.\n");
>=20
> Maybe qla2xirqmode is a more appropriate name?
>=20

Sorry this one slipped out of my sight. The reason I used "ql2xenablemsix" =
was because driver already
had this parameter in code until few versions back where we removed it. Sin=
ce existing user are familiar
with this module parameter name, it would be easy to keep that same.=20

Let me know if you are okay with the name or prefer new name instead?=20

> --=20
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Thanks,
- Himanshu
