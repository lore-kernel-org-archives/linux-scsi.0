From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: RE: [PATCH 1/1] [SCSI] mpt3sas: Remove unneeded version.h header
 inclusion
Date: Tue, 11 Dec 2012 14:30:57 +0530
Message-ID: <DCD177647606E9419ED923E0C8C4AA7223E75BB253@inbmail02.lsi.com>
References: <1354528817-28894-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:54529 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab2LKJBE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Dec 2012 04:01:04 -0500
In-Reply-To: <1354528817-28894-1-git-send-email-sachin.kamat@linaro.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sachin Kamat <sachin.kamat@linaro.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>, "JBottomley@parallels.com" <JBottomley@parallels.com>, Support <support@lsi.com>, "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>, "patches@linaro.org" <patches@linaro.org>

James,

This patch seem to be fine. Please consider this patch as Acked-by: "Sreekanth Reddy" <Sreekanth.reddy@lsi.com>

Regards,
Sreekanth.

-----Original Message-----
From: Sachin Kamat [mailto:sachin.kamat@linaro.org] 
Sent: Monday, December 03, 2012 3:30 PM
To: linux-scsi@vger.kernel.org
Cc: DL-MPT Fusion Linux; JBottomley@parallels.com; Support; Reddy, Sreekanth; Nandigama, Nagalakshmi; sachin.kamat@linaro.org; patches@linaro.org
Subject: [PATCH 1/1] [SCSI] mpt3sas: Remove unneeded version.h header inclusion

linux/version.h is not necessary as detected by checkversion.pl script.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c         |    1 -
 drivers/scsi/mpt3sas/mpt3sas_config.c       |    1 -
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    1 -
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    1 -
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    1 -
 5 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 04f8010..d5e8463 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index ce7e59b..1df9ed4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8af944d..5b0d4f8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 05f8045..ac9dbc2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index da6c5f2..6f8d621 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-- 
1.7.4.1

