From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 5/5] megaraid_sas: Version and Changelog update
Date: Wed,  9 Jul 2014 15:17:58 -0700
Message-ID: <1404944278-11535-6-git-send-email-aradford@gmail.com>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60607 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbaGIWT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 18:19:26 -0400
Received: by mail-pa0-f44.google.com with SMTP id rd3so9924071pab.17
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 15:19:24 -0700 (PDT)
In-Reply-To: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

The following patch for megaraid_sas updates the driver version and
Documentation/scsi/ChangeLog.megaraid_sas.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Adam Radford <aradford@gmail.com>
---
 Documentation/scsi/ChangeLog.megaraid_sas | 14 ++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h      |  6 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/Documentation/scsi/ChangeLog.megaraid_sas b/Documentation/scsi/ChangeLog.megaraid_sas
index 91ba58e..18b5709 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -1,3 +1,17 @@
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
+    4. Add missing initial call to megasas_get_ld_vf_affiliation().
+    5. Version and Changelog update.
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
index 6db5c12..a2263fd 100644
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

