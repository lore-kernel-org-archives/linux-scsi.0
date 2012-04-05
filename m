From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: Patch adding to scsi-misc-2.6: [SCSI] pm8001: Add support for PM8008/8009/8018/8019 SAS/SATA HBA.
Date: Thu, 5 Apr 2012 09:07:40 +0800
Message-ID: <4635AA101B044B22AEB5C6C0AD84D307@usish.com.cn>
References: <FEB196E0808DE0408A6E24DF8A0BB09326B32C6173@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:50359 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEBH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Apr 2012 21:07:56 -0400
In-Reply-To: <FEB196E0808DE0408A6E24DF8A0BB09326B32C6173@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Sakthivel Saravanan Kamal Raju' <sakthivel.sk@hcl.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, jejb@kernel.org
Cc: "'Anand Kumar S - ERS, HCL Tech'" <sanandkumar@hcl.com>, "'Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech'" <satyasrinivasp@hcl.com>


Hi Sakthivel Saravanan K,

Glad to see more people working on pm8001 module, your work is very wel=
come.
I think changes should only needed for files works for all 8001/8008...=
,we
should leave 8001 specific as it is. Detailed comments need
Patchset show up in the list. Let's see if James has more comments.

Best regards!

Jack
________________________________________
=B7=A2=BC=FE=C8=CB: Sakthivel Saravanan Kamal Raju [mailto:sakthivel.sk=
@hcl.com]=20
=B7=A2=CB=CD=CA=B1=BC=E4: 2012=C4=EA4=D4=C23=C8=D5 23:21
=CA=D5=BC=FE=C8=CB: linux-scsi@vger.kernel.org; James.Bottomley@suse.de=
; jejb@kernel.org
=B3=AD=CB=CD: jack_wang@usish.com; Anand Kumar S - ERS, HCL Tech; Srini=
vas Naga
Venkatasatya Pasagadugula - ERS, HCL Tech
=D6=F7=CC=E2: Patch adding to scsi-misc-2.6: [SCSI] pm8001: Add support=
 for
PM8008/8009/8018/8019 SAS/SATA HBA.=20

Hi James,

We are going to provide support for 8018/19/08/09 other than 8001
controllers on pm8001 driver. So we would like to change the existing n=
aming
conventions of pm8001 to pm80xx. I hope this is fine and there will not=
 be
any concerns on this. Any inputs are highly appreciated.=20


Thanks & Regards,

Sakthivel Saravanan K=20
HCL Technologies Ltd.
Chennai (T.N.), India


________________________________________
::DISCLAIMER::
-----------------------------------------------------------------------=
-----
-------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and
intended for the named recipient(s) only.
It shall not attach any liability on the originator or HCL or its
affiliates. Any views or opinions presented in
this email are solely those of the author and may not necessarily refle=
ct
the opinions of HCL or its affiliates.
Any form of reproduction, dissemination, copying, disclosure, modificat=
ion,
distribution and / or publication of
this message without the prior written consent of the author of this e-=
mail
is strictly prohibited. If you have
received this email in error please delete it and notify the sender
immediately. Before opening any mail and
attachments please check them for viruses and defect.

-----------------------------------------------------------------------=
-----
-------------------------------------------

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
