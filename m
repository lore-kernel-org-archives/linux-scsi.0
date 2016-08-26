From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 14/17] smartpqi: update Kconfig
Date: Fri, 26 Aug 2016 11:45:30 -0500
Message-ID: <147222993045.31214.7239145609904440085.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0059.outbound.protection.outlook.com ([104.47.40.59]:35462
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751691AbcHZRB4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:01:56 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

The aacraid driver will not managage Microsemi
smartpqi controllers, but will still manage
older aacraid devices.

Updated help section.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
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

