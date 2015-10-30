From: Benjamin Rood <benjaminjrood@gmail.com>
Subject: [PATCH 3/8] pm80xx: add ATTO PCI IDs to pm8001_pci_table
Date: Fri, 30 Oct 2015 10:53:26 -0400
Message-ID: <1446216811-2248-4-git-send-email-brood@attotech.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:34795 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbbJ3Oxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2015 10:53:38 -0400
Received: by qgem9 with SMTP id m9so63090522qge.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2015 07:53:38 -0700 (PDT)
In-Reply-To: <1446216811-2248-1-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

These PCI IDs allow the pm8001 driver to load against ATTO 12Gb SAS
controllers that use PMC Sierra 8070 and PMC Sierra 8072 SAS chips.

Signed-off-by: Benjamin Rood <brood@attotech.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 2106ac3..feaf504 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1181,6 +1181,20 @@ static struct pci_device_id pm8001_pci_table[] = {
 		PCI_VENDOR_ID_ADAPTEC2, 0x0808, 0, 0, chip_8077 },
 	{ PCI_VENDOR_ID_ADAPTEC2, 0x8074,
 		PCI_VENDOR_ID_ADAPTEC2, 0x0404, 0, 0, chip_8074 },
+	{ PCI_VENDOR_ID_ATTO, 0x8070,
+		PCI_VENDOR_ID_ATTO, 0x0070, 0, 0, chip_8070 },
+	{ PCI_VENDOR_ID_ATTO, 0x8070,
+		PCI_VENDOR_ID_ATTO, 0x0071, 0, 0, chip_8070 },
+	{ PCI_VENDOR_ID_ATTO, 0x8072,
+		PCI_VENDOR_ID_ATTO, 0x0072, 0, 0, chip_8072 },
+	{ PCI_VENDOR_ID_ATTO, 0x8072,
+		PCI_VENDOR_ID_ATTO, 0x0073, 0, 0, chip_8072 },
+	{ PCI_VENDOR_ID_ATTO, 0x8070,
+		PCI_VENDOR_ID_ATTO, 0x0080, 0, 0, chip_8070 },
+	{ PCI_VENDOR_ID_ATTO, 0x8072,
+		PCI_VENDOR_ID_ATTO, 0x0081, 0, 0, chip_8072 },
+	{ PCI_VENDOR_ID_ATTO, 0x8072,
+		PCI_VENDOR_ID_ATTO, 0x0082, 0, 0, chip_8072 },
 	{} /* terminate list */
 };
 
-- 
2.4.3

