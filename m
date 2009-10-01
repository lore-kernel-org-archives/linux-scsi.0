From: Yugendranath R Singh <yugendranath.s@hcl.in>
Subject: [PATCH] drivers/scsi/mvsas: mvsas driver supported device list to
 inlcude Adaptec ASC-1045/1405 SAS/SATA Controllers
Date: Thu, 1 Oct 2009 20:35:28 +0530
Message-ID: <4CA9DA403FFEC64AA62B3C295F8D47B7212674D868@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:44953 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZJAPGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 11:06:00 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Ying Chu <jasonchu@marvell.com>, Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>

Hi,
Please find the patch below which adds the Adaptec ASC 1045/1405 controllers to mvsas driver supported device list, for kernel version 2.6.31.1.

-----
diff -uprN a/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c b/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c
--- a/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c       2009-09-24 21:15:25.000000000 +0530
+++ b/linux-2.6.31.1/drivers/scsi/mvsas/mv_init.c       2009-10-02 00:03:53.000000000 +0530
@@ -653,6 +653,7 @@ static struct pci_device_id __devinitdat
        { PCI_VDEVICE(MARVELL, 0x6485), chip_6485 },
        { PCI_VDEVICE(MARVELL, 0x9480), chip_9480 },
        { PCI_VDEVICE(MARVELL, 0x9180), chip_9180 },
+       { PCI_VDEVICE(ADAPTEC2, 0x0450), chip_6440 },

        { }     /* terminate list */
 };
------

Thanks,
Yugen
HCL Tech.


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
