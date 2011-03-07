From: scameron@beardog.cce.hp.com
Subject: [PATCH] hpsa: fix incorrect PCI IDs and add two new ones (2nd try)
Date: Mon, 7 Mar 2011 10:44:16 -0600
Message-ID: <20110307164416.GK12760@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40802 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1CGQoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2011 11:44:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org


My first attempt was botched, got the wrong PCI Device ID
(used PCI_DEVICE_ID_HP_CISSE, should have been PCI_DEVICE_ID_HP_CISSF)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c30591f..09a529e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -89,11 +89,13 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3250},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3251},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3252},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3253},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3254},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -113,11 +115,13 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3250103C, "Smart Array", &SA5_access},
-	{0x3250113C, "Smart Array", &SA5_access},
-	{0x3250123C, "Smart Array", &SA5_access},
-	{0x3250133C, "Smart Array", &SA5_access},
-	{0x3250143C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array", &SA5_access},
+	{0x3351103C, "Smart Array", &SA5_access},
+	{0x3352103C, "Smart Array", &SA5_access},
+	{0x3353103C, "Smart Array", &SA5_access},
+	{0x3354103C, "Smart Array", &SA5_access},
+	{0x3355103C, "Smart Array", &SA5_access},
+	{0x3356103C, "Smart Array", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 

