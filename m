From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/6] qla2xxx: Add FC-NVMe port discovery and PRLI handling
Date: Mon, 19 Jun 2017 16:37:16 +0000
Message-ID: <9F6663D3-E46A-4831-8509-B814B3DE0253@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-2-himanshu.madhani@cavium.com>
 <20170619080910.GA3752@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0063.outbound.protection.outlook.com ([104.47.42.63]:36832
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750878AbdFSQh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 12:37:28 -0400
In-Reply-To: <20170619080910.GA3752@linux-x5ow.site>
Content-Language: en-US
Content-ID: <D816D1854A323D44BEEB594E4EE037E8@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malaval@cavium.com" <giridhar.malaval@cavium.com>, "Trapp, Darren" <Darren.Trapp@cavium.com>


> On Jun 19, 2017, at 1:09 AM, Johannes Thumshirn <jthumshirn@suse.de> wrot=
e:
>=20
> On Fri, Jun 16, 2017 at 03:47:39PM -0700, Himanshu Madhani wrote:
>> From: Duane Grigsby <duane.grigsby@cavium.com>
>>=20
>> Signed-off-by: Darren Trapp <darren.trapp@cavium.com>
>> Signed-off-by: Duane Grigsby <duane.grigsby@cavium.com>
>> Signed-off-by: Anil Gurumurthy <anil.gurumurhty@cavium.com>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
>> ---
>=20
> [...]
>=20
>> +
>> +	if ((fcport->fw_login_state =3D=3D DSC_LS_PLOGI_PEND) ||
>> +	    (fcport->fw_login_state =3D=3D DSC_LS_PLOGI_COMP) ||
>> +	    (fcport->fw_login_state =3D=3D DSC_LS_PRLI_PEND))
>> +		return rval;
>=20
> Minor nit, superfluous parenthesis.
>=20
>=20

Will fix it in v2

> Anyways,
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>=20
> --=20
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

Thanks,
- Himanshu
