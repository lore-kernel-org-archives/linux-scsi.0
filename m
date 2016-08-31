From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 13/15] smartpqi: update Kconfig
Date: Wed, 31 Aug 2016 14:55:24 -0500
Message-ID: <147267332435.22907.1799843354700145245.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0060.outbound.protection.outlook.com ([104.47.36.60]:29328
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753517AbcHaTzs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:55:48 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

The aacraid driver will not managage Microsemi
smartpqi controllers, but will still manage
older aacraid devices.

Updated help section.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/Kconfig |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index 5d77a80..97e159c 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -37,7 +37,6 @@
 
 config SCSI_SMARTPQI
 	tristate "Microsemi PQI Driver"
-	default n
 	depends on PCI && SCSI && !S390
 	select SCSI_SAS_ATTRS
 	select RAID_ATTRS
@@ -47,4 +46,9 @@ config SCSI_SMARTPQI
 	<http://www.microsemi.com>
 
 	To compile this driver as a module, choose M here: the
-	module will be called smartpqi
+	module will be called smartpqi.
+
+        Note: the aacraid driver will not manage a smartpqi
+              controller. You need to enable smartpqi for smartpqi
+              controllers. For more information, please see
+              Documentation/scsi/smartpqi.txt

