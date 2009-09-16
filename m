From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 3/9] [SCSI] mpt2sas: remove unused #include <linux/version.h>
Date: Wed, 16 Sep 2009 21:06:43 +0800
Message-ID: <1253106403-1808-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f176.google.com ([209.85.216.176]:40610 "EHLO
	mail-px0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZIPNHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2009 09:07:55 -0400
Received: by pxi6 with SMTP id 6so3979614pxi.21
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2009 06:07:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <linux/version.h>('s) in
  drivers/scsi/mpt2sas/mpt2sas_base.c
  drivers/scsi/mpt2sas/mpt2sas_config.c
  drivers/scsi/mpt2sas/mpt2sas_ctl.c
  drivers/scsi/mpt2sas/mpt2sas_scsih.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c   |    1 -
 drivers/scsi/mpt2sas/mpt2sas_config.c |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c    |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c  |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d95d2f2..2a98a5d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_config.c b/drivers/scsi/mpt2sas/mpt2sas_config.c
index ab8c560..bf48d7f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_config.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_config.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index c2a5101..1d870a8 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 774b345..44a2146 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -41,7 +41,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
-- 
1.6.1.3

