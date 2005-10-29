From: James.Smart@Emulex.Com
Subject: [PATCH 14/15]  lpfc 8.1.0 : Add owner field to struct pci_driver
Date: Fri, 28 Oct 2005 20:30:05 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A5D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:11729 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750942AbVJ2AaI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:30:08 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0U6Dp018572
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:30:07 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add owner field to struct pci_driver


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1709,6 +1709,7 @@ MODULE_DEVICE_TABLE(pci, lpfc_id_table);
 
 static struct pci_driver lpfc_driver = {
 	.name		= LPFC_DRIVER_NAME,
+	.owner		= THIS_MODULE,
 	.id_table	= lpfc_id_table,
 	.probe		= lpfc_pci_probe_one,
 	.remove		= __devexit_p(lpfc_pci_remove_one),
