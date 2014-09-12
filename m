From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 11/11] megaraid_sas : Driver version update
Date: Fri, 12 Sep 2014 18:58:03 +0530
Message-ID: <201409121330.s8CDUPsi022503@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0098.outbound.protection.outlook.com ([157.56.110.98]:55616
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754688AbaILN2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 09:28:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Resending the patch. Addressed the review comments by Tomas Henzl.

Driver version upgrade patch.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
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
index d8cc922..f6a69a3 100644
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

