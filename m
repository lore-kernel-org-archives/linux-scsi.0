From: "SRINIVAS NAGA VENKATASATYA PASAGADUGULA - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: [PATCH] SCSI: Support for Adaptec ASC-1045/1405 SAS/SATA HBA on
 mvsas
Date: Tue, 24 Nov 2009 20:07:39 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF467E786AA8@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.hcl.in ([203.105.186.28]:39806 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018AbZKXOiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 09:38:21 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: "ayan@marvell.com" <ayan@marvell.com>, "kewei@marvell.com" <kewei@marvell.com>


From: Srinivas <satyasrinivasp@hcl.in>

This is support for Adaptec ASC-1045/1405 SAS/SATA HBA on mvsas, which is based on Marvell 88SE6440 chipset.
Signed-off-by: Srinivas <satyasrinivasp@hcl.in>
---
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index c790d45..cae6b2c 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -657,6 +657,7 @@ static struct pci_device_id __devinitdata mvs_pci_table[] = {
        { PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
        { PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1300), chip_1300 },
        { PCI_VDEVICE(ARECA, PCI_DEVICE_ID_ARECA_1320), chip_1320 },
+       { PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },

        { }     /* terminate list */
 };

--

Thanks,
Srinivas.

DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
