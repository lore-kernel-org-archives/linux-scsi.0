From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 22/43] qla2xxx: Add switch command to simplify fabric
 discovery
Date: Thu, 21 Dec 2017 00:04:00 +0000
Message-ID: <2F089C2E-D871-4FEA-B09D-3C0B7D03E15D@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-23-himanshu.madhani@cavium.com>
 <1513793377.10760.169.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:7027
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755838AbdLUAED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 19:04:03 -0500
In-Reply-To: <1513793377.10760.169.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <086F3231E090E048B347B4576DE7B3C5@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Ewan,=20

> On Dec 20, 2017, at 12:09 PM, Ewan D. Milne <emilne@redhat.com> wrote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
>> @@ -4915,12 +4941,32 @@ static int qlt_24xx_handle_els(struct scsi_qla_h=
ost *vha,
>> 		}
>>=20
>> 		if (sess !=3D NULL) {
>> +			bool delete =3D false;
>> 			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
>> 			switch (sess->fw_login_state) {
>> +			case DSC_LS_PLOGI_PEND:
>> 			case DSC_LS_PLOGI_COMP:
>> 			case DSC_LS_PRLI_COMP:
>> 				break;
>> 			default:
>> +			    	delete =3D true;
>=20
> Nitpick:  git quiltimport complains about the whitespace error
> (space before tab) on the above line.
>=20
>=20

Thanks for review. Will fix in v2

Thanks,
- Himanshu
