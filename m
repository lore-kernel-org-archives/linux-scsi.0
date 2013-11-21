From: Sangeetha Gnanasekaran <sangeetha_g@hcl.com>
Subject: ATA PASSTHROUGH command support issue
Date: Thu, 21 Nov 2013 12:37:49 +0000
Message-ID: <F9AEE99A65F8B04980BD286E8FF728861FAEBE40@chn-hclt-mbs04.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.hcl.com ([192.8.186.130]:40764 "EHLO GWS07.hcl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3KUMiD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2013 07:38:03 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Krishna Bilash Paul - ERS, HCL Tech" <Krishna.Paul@hcl.com>, "Anand Kumar S - ERS, HCL Tech" <sanandkumar@hcl.com>

Hi,

We are implementing utility for testing ATA compliance of drives.
We faced issues while sending some commands using ATA PASSTHROUGH suppo=
rted by libata.
Below list of protocols are not supported by libata and hence we are no=
t able to send =A0commands which follow below protocols.

Protocol field value		Details

0					Hard Reset
1					SRST
7					DMA-Queued
8					Device Diagnostic
9					Device Reset
12					FPDMA
15					Return Response Info

Can anybody give us input as why it is not supported?=20

Thanks,
Sangeetha




::DISCLAIMER::
-----------------------------------------------------------------------=
-----------------------------------------------------------------------=
------

The contents of this e-mail and any attachment(s) are confidential and =
intended for the named recipient(s) only.
E-mail transmission is not guaranteed to be secure or error-free as inf=
ormation could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or may contain viruses in t=
ransmission. The e mail and its contents
(with or without referred errors) shall therefore not attach any liabil=
ity on the originator or HCL or its affiliates.
Views or opinions, if any, presented in this email are solely those of =
the author and may not necessarily reflect the
views or opinions of HCL or its affiliates. Any form of reproduction, d=
issemination, copying, disclosure, modification,
distribution and / or publication of this message without the prior wri=
tten consent of authorized representative of
HCL is strictly prohibited. If you have received this email in error pl=
ease delete it and notify the sender immediately.
Before opening any email and/or attachments, please check them for viru=
ses and other defects.

-----------------------------------------------------------------------=
-----------------------------------------------------------------------=
------

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
