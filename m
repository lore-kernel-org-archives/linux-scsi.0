From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v2 3/6] cxlflash: Removed driver date print
Date: Mon, 14 Dec 2015 15:06:33 -0600
Message-ID: <1450127193-48109-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:43345 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbbLNVHc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 16:07:32 -0500
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Mon, 14 Dec 2015 14:07:31 -0700
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0645119D8026
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 13:55:31 -0700 (MST)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tBEL7Q0v28508380
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:07:26 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tBEL7Oav030755
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 14:07:25 -0700
In-Reply-To: <1450126293-47440-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>

Having a date for the driver requires it to be updated quite
often. Removing the date which is not necessary. Also made
use of the existing symbol to print the driver name.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 3 +--
 drivers/scsi/cxlflash/main.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 09fe252..35a3202 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2585,8 +2585,7 @@ static struct pci_driver cxlflash_driver = {
  */
 static int __init init_cxlflash(void)
 {
-	pr_info("%s: IBM Power CXL Flash Adapter: %s\n",
-		__func__, CXLFLASH_DRIVER_DATE);
+	pr_info("%s: %s\n", __func__, CXLFLASH_ADAPTER_NAME);
 
 	cxlflash_list_init();
 
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
index 6032456..7e2d0e1 100644
--- a/drivers/scsi/cxlflash/main.h
+++ b/drivers/scsi/cxlflash/main.h
@@ -22,7 +22,6 @@
 
 #define CXLFLASH_NAME		"cxlflash"
 #define CXLFLASH_ADAPTER_NAME	"IBM POWER CXL Flash Adapter"
-#define CXLFLASH_DRIVER_DATE	"(August 13, 2015)"
 
 #define PCI_DEVICE_ID_IBM_CORSA	0x04F0
 #define CXLFLASH_SUBS_DEV_ID	0x04F0
-- 
2.1.0

