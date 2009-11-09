From: Srinivas Naga Venkatasatya Pasagadugula <satyasrinivasp@hcl.in>
Subject: RE: [PATCH] drivers/scsi/mvsas: Support for Adaptec ASC-1045/1405
 SAS/SATA HBA on mvsas
Date: Mon, 9 Nov 2009 17:53:28 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF3C29B73DBF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <4CA9DA403FFEC64AA62B3C295F8D47B721268A6601@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_6B62480106F2B34D8404CF2FDAA4D9EF3C29B73DBFCHNHCLTEVS06H_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.mail.hcl.in ([203.105.186.27]:46065 "EHLO gws07.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820AbZKIMsz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2009 07:48:55 -0500
In-Reply-To: <4CA9DA403FFEC64AA62B3C295F8D47B721268A6601@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>


--_002_6B62480106F2B34D8404CF2FDAA4D9EF3C29B73DBFCHNHCLTEVS06H_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi James,

Please let us know the status of this patch. We have submitted the attached=
 patch on Oct-15 didn't get into 2.6.32-rc6. Please consider this patch to =
include in rc tree. =20

Thanks
Srini.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Yugendranath R Singh
Sent: Thursday, October 22, 2009 3:13 PM
To: James Bottomley
Cc: linux-scsi@vger.kernel.org; Andy Yan; Ke Wei
Subject: [PATCH] drivers/scsi/mvsas: Support for Adaptec ASC-1045/1405 SAS/=
SATA HBA on mvsas

Hi James,
The attached patch submitted on Oct 15 didn't get into 2.6.32-rc5. Please l=
et me know if there are any issues so that I can correct and re-send the sa=
me and get this included in subsequent rc release.

Thanks,
Yugen.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Yugendranath R Singh
Sent: Tuesday, October 13, 2009 9:45 PM
To: linux-scsi@vger.kernel.org
Cc: James Bottomley; Andy Yan; Ke Wei
Subject: [PATCH] drivers/scsi/mvsas: Support for Adaptec ASC-1045/1405 SAS/=
SATA HBA on mvsas

From: Yugendranath R Singh<yugendranath.s@hcl.in>

This is support for Adaptec ASC-1045/1405 SAS/SATA HBA on mvsas, which is b=
ased on Marvell 88SE6440 chipset.
Signed-off-by: Yugendranath R Singh<yugendranath.s@hcl.in>
---
Patch being sent as attachment, as my mailer would mangle the contents if s=
ent inline.



DISCLAIMER:
---------------------------------------------------------------------------=
--------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and inte=
nded for the named recipient(s) only.
It shall not attach any liability on the originator or HCL or its affiliate=
s. Any views or opinions presented in
this email are solely those of the author and may not necessarily reflect t=
he opinions of HCL or its affiliates.
Any form of reproduction, dissemination, copying, disclosure, modification,=
 distribution and / or publication of
this message without the prior written consent of the author of this e-mail=
 is strictly prohibited. If you have
received this email in error please delete it and notify the sender immedia=
tely. Before opening any mail and
attachments please check them for viruses and defect.

---------------------------------------------------------------------------=
--------------------------------------------

--_002_6B62480106F2B34D8404CF2FDAA4D9EF3C29B73DBFCHNHCLTEVS06H_
Content-Type: application/octet-stream; name="mv_init.patch"
Content-Description: mv_init.patch
Content-Disposition: attachment; filename="mv_init.patch"; size=530;
	creation-date="Mon, 09 Nov 2009 17:32:07 GMT";
	modification-date="Mon, 09 Nov 2009 17:32:07 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtdXByTiBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9pbml0LmMgYi9kcml2ZXJzL3Njc2kv
bXZzYXMvbXZfaW5pdC5jCi0tLSBhL2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9pbml0LmMJMjAwOS0x
MC0xNCAwMTo0MDo1Mi4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9zY3NpL212c2FzL212
X2luaXQuYwkyMDA5LTEwLTE0IDAxOjUyOjE0LjAwMDAwMDAwMCArMDUzMApAQCAtNjU3LDYgKzY1
Nyw3IEBAIHN0YXRpYyBzdHJ1Y3QgcGNpX2RldmljZV9pZCBfX2RldmluaXRkYXQKIAl7IFBDSV9W
REVWSUNFKE1BUlZFTEwsIDB4OTE4MCksIGNoaXBfOTE4MCB9LAogCXsgUENJX1ZERVZJQ0UoQVJF
Q0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTMwMCksIGNoaXBfMTMwMCB9LAogCXsgUENJX1ZERVZJ
Q0UoQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTMyMCksIGNoaXBfMTMyMCB9LAorCXsgUENJ
X1ZERVZJQ0UoQURBUFRFQzIsIDB4MDQ1MCksIGNoaXBfNjQ0MCB9LAogCiAJeyB9CS8qIHRlcm1p
bmF0ZSBsaXN0ICovCiB9Owo=

--_002_6B62480106F2B34D8404CF2FDAA4D9EF3C29B73DBFCHNHCLTEVS06H_--

