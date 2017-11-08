From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [patch 2/2] scsi: mpt3sas: remove a stray KERN_INFO
Date: Wed, 8 Nov 2017 09:03:17 -0700
Message-ID: <c153aa212e6c8918020602fba7e975ce@mail.gmail.com>
References: <20171108083819.u2yufaeamh2vffac@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:47596 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbdKHQDT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 11:03:19 -0500
Received: by mail-qk0-f181.google.com with SMTP id m189so3926395qke.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 08:03:19 -0800 (PST)
In-Reply-To: <20171108083819.u2yufaeamh2vffac@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Chaitra Basappa <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Thanks.
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: Wednesday, November 8, 2017 1:38 AM
To: Sathya Prakash; Suganath Prabu Subramani
Cc: Chaitra P B; James E.J. Bottomley; Martin K. Petersen;
MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
kernel-janitors@vger.kernel.org
Subject: [patch 2/2] scsi: mpt3sas: remove a stray KERN_INFO

pr_info() has a KERN_INFO already so the second KERN_INFO isn't needed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 3a9438a1704e..b258f210120a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8683,7 +8684,7 @@ _scsih_mark_responding_pcie_device(struct
MPT3SAS_ADAPTER *ioc,

 			if (pcie_device->handle ==
pcie_device_pg0->DevHandle)
 				goto out;
-			pr_info(KERN_INFO "\thandle changed
from(0x%04x)!!!\n",
+			pr_info("\thandle changed from(0x%04x)!!!\n",
 			    pcie_device->handle);
 			pcie_device->handle = pcie_device_pg0->DevHandle;
 			if (sas_target_priv_data)
