From: "Rangankar, Manish" <Manish.Rangankar@cavium.com>
Subject: Re: [PATCH] qla4xxx: fix spelling mistake: "Tempalate" -> "Template"
Date: Wed, 26 Apr 2017 04:39:22 +0000
Message-ID: <D526222D.394C8%manish.rangankar@cavium.com>
References: <20170425213710.20588-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0065.outbound.protection.outlook.com ([104.47.36.65]:31200
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1948071AbdDZEjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Apr 2017 00:39:25 -0400
In-Reply-To: <20170425213710.20588-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <CAA4EAE20B7C3E4F9015A10EB86D2B4C@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, "QLogic-Storage-Upstream@qlogic.com" <QLogic-Storage-Upstream@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


On 26/04/17 3:07 AM, "Colin King" <colin.king@canonical.com> wrote:

>From: Colin Ian King <colin.king@canonical.com>
>
>trivial fix to spelling mistake in DEBUG2 debug message
>
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/scsi/qla4xxx/ql4_init.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qla4xxx/ql4_init.c
>b/drivers/scsi/qla4xxx/ql4_init.c
>index 4180d6d9fe78..5d6d158bbfd6 100644
>--- a/drivers/scsi/qla4xxx/ql4_init.c
>+++ b/drivers/scsi/qla4xxx/ql4_init.c
>@@ -389,7 +389,7 @@ void qla4xxx_alloc_fw_dump(struct scsi_qla_host *ha)
> 		goto alloc_cleanup;
>=20
> 	DEBUG2(ql4_printk(KERN_INFO, ha,
>-			  "Minidump Tempalate Size =3D 0x%x KB\n",
>+			  "Minidump Template Size =3D 0x%x KB\n",
> 			  ha->fw_dump_tmplt_size));
> 	DEBUG2(ql4_printk(KERN_INFO, ha,
> 			  "Total Minidump size =3D 0x%x KB\n", ha->fw_dump_size));
>--=20
>2.11.0

Acked-by: Manish Rangankar <Manish.Rangankar@cavium.com>
