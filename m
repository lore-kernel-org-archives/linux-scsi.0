From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 11/11] megaraid_sas : Driver version update
Date: Sat, 6 Sep 2014 18:55:55 +0530
Message-ID: <201409061328.s86DSDCl013432@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0084.outbound.protection.outlook.com ([157.56.110.84]:32224
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751368AbaIFNl7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 09:41:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Driver version upgrade patch.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index f99db18..a49914d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.803.02.00-rc1"
-#define MEGASAS_RELDATE				"Jun. 19, 2014"
-#define MEGASAS_EXT_VERSION			"Thu. Jun. 19 17:00:00 PDT 2014"
+#define MEGASAS_VERSION				"06.805.06.00-rc1"
+#define MEGASAS_RELDATE				"Sep. 4, 2014"
+#define MEGASAS_EXT_VERSION			"Thu. Sep. 4 17:00:00 PDT 2014"
 
 /*
  * Device IDs
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 50d69eb..9137027 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : 06.803.02.00-rc1
+ *  Version : 06.805.06.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
-- 
1.8.3.1

