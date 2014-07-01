From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 4/4] megaraid_sas: Version and Changelog update
Date: Mon, 30 Jun 2014 17:19:58 -0700
Message-ID: <1404173998-24363-5-git-send-email-aradford@gmail.com>
References: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47828 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaGAAVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 20:21:09 -0400
Received: by mail-pd0-f181.google.com with SMTP id v10so9075758pde.12
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2014 17:21:09 -0700 (PDT)
In-Reply-To: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

James/linux-scsi,

The following patch for megaraid_sas updates the driver version and Documentation/scsi/ChangeLog.megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>
---
 Documentation/scsi/ChangeLog.megaraid_sas | 13 +++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h      |  6 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/scsi/ChangeLog.megaraid_sas
index 91ba58e..2741efe 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,16 @@
+Release Date    : Thu. Jun 19, 2014 17:00:00 PST 2014 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+			Kashyap Desai
+			Sumit Saxena
+			Uday Lingala
+Current Version : 06.803.02.00-rc1
+Old Version     : 06.803.01.00-rc1
+    1. Fix reset_mutex leak in megasas_reset_fusion().
+    2. Remove unused variables in megasas_instance.
+    3. Fix LD/VF affiliation parsing.
+    4. Version and Changelog update.
+-------------------------------------------------------------------------------
 Release Date    : Mon. Mar 10, 2014 17:00:00 PST 2014 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 2e2fcb2..bc7adcf 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.803.01.00-rc1"
-#define MEGASAS_RELDATE				"Mar. 10, 2014"
-#define MEGASAS_EXT_VERSION			"Mon. Mar. 10 17:00:00 PDT 2014"
+#define MEGASAS_VERSION				"06.803.02.00-rc1"
+#define MEGASAS_RELDATE				"Jun. 19, 2014"
+#define MEGASAS_EXT_VERSION			"Thu. Jun. 19 17:00:00 PDT 2014"
 
 /*
  * Device IDs
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8f62b30..222bab2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : 06.803.01.00-rc1
+ *  Version : 06.803.02.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
-- 
1.7.11.7

