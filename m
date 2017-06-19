From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 2/6] qla2xxx: Add FC-NVMe command handling
Date: Mon, 19 Jun 2017 16:37:55 +0000
Message-ID: <2B3C244C-66F1-4A00-ACF0-CC5BAD9FB1E2@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-3-himanshu.madhani@cavium.com>
 <20170619082033.GB3752@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0045.outbound.protection.outlook.com ([104.47.42.45]:16136
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750780AbdFSQh6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 12:37:58 -0400
In-Reply-To: <20170619082033.GB3752@linux-x5ow.site>
Content-Language: en-US
Content-ID: <4210D70D119A604A8A1701B3053FEF4C@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>


> On Jun 19, 2017, at 1:20 AM, Johannes Thumshirn <jthumshirn@suse.de> wrot=
e:
>=20
> On Fri, Jun 16, 2017 at 03:47:40PM -0700, Himanshu Madhani wrote:
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
>> +static void
>> +qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req, void=
 *tsk)
>> +{
>> +	const char func[] =3D "NVME-IOCB";
>> +	fc_port_t *fcport;
>> +	srb_t *sp;
>> +	struct srb_iocb *iocb;
>> +	struct sts_entry_24xx *sts =3D (struct sts_entry_24xx *)tsk;
>=20
> No need to cast from void*
>=20
>=20

Thanks for Review. will fix this in v2.

> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>=20
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
