From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] scsi/megaraid.c: pci_module_init to pci_register_driver
Date: Tue, 13 Feb 2007 18:01:56 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229920F78@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40951 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209AbXBNBCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2007 20:02:04 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>, "Kolli, Neela" <Neela.Kolli@lsi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


ACK.

--Sumant
 

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Richard Knutsson
Sent: Tuesday, February 13, 2007 4:41 PM
To: Kolli, Neela
Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Richard
Knutsson
Subject: [PATCH] scsi/megaraid.c: pci_module_init to pci_register_driver

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
808a1b8..0aa3304 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -5072,7 +5072,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid
root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
