From: "Patro, Sumant" <Sumant.Patro@lsil.com>
Subject: RE: [RFC][PATCH 39/75] scsi: drivers/scsi/megaraid/megaraid_sas.c pci_module_init to pci_register_driver conversion
Date: Fri, 18 Aug 2006 20:03:26 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229674EA3@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422715AbWHSCD2@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Ack.

Thank you.

--Sumant

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Michal
Piotrowski
Sent: Thursday, August 17, 2006 6:28 AM
To: Bagalkote, Sreenivas
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: [RFC][PATCH 39/75] scsi: drivers/scsi/megaraid/megaraid_sas.c
pci_module_init to pci_register_driver conversion


Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff
linux-work-clean/drivers/scsi/megaraid/megaraid_sas.c
linux-work2/drivers/scsi/megaraid/megaraid_sas.c
--- linux-work-clean/drivers/scsi/megaraid/megaraid_sas.c
2006-08-16 22:41:01.000000000 +0200
+++ linux-work2/drivers/scsi/megaraid/megaraid_sas.c	2006-08-17
05:21:09.000000000 +0200
@@ -2854,7 +2854,7 @@ static int __init megasas_init(void)
 	/*
 	 * Register ourselves as PCI hotplug module
 	 */
-	rval = pci_module_init(&megasas_pci_driver);
+	rval = pci_register_driver(&megasas_pci_driver);
 
 	if (rval) {
 		printk(KERN_DEBUG "megasas: PCI hotplug regisration
failed \n");
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
