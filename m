From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 1/7] megaraid_sas : Driver version upgrade
Date: Mon, 10 Nov 2014 17:51:14 +0530
Message-ID: <201411101224.sAACOcKw018039@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0072.outbound.protection.outlook.com ([207.46.100.72]:6552
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752298AbaKJMgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 07:36:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

megaraid_sas driver version upgrade

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index a49914d..f3eccf1 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -33,7 +33,7 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.805.06.00-rc1"
+#define MEGASAS_VERSION				"06.805.06.01-rc1"
 #define MEGASAS_RELDATE				"Sep. 4, 2014"
 #define MEGASAS_EXT_VERSION			"Thu. Sep. 4 17:00:00 PDT 2014"
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3..36f463c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : 06.805.06.00-rc1
+ *  Version : 06.805.06.01-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
-- 
1.8.3.1

