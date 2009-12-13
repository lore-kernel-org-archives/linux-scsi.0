From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 3/6] [SCSI] mpt2sas: remove unused #include <linux/version.h>
Date: Sun, 13 Dec 2009 22:05:35 +0800
Message-ID: <1260713135-3308-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:44074 "HELO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753437AbZLMOFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Dec 2009 09:05:50 -0500
Received: by pzk1 with SMTP id 1so1720163pzk.33
        for <linux-scsi@vger.kernel.org>; Sun, 13 Dec 2009 06:05:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <linux/version.h>('s) in
  drivers/scsi/mpt2sas/mpt2sas_base.c
  drivers/scsi/mpt2sas/mpt2sas_ctl.c
  drivers/scsi/mpt2sas/mpt2sas_scsih.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    1 -
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |    1 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6422e25..91f69c4 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -42,7 +42,6 @@
  * USA.
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 84a124f..44edb71 100644
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
index efabea1..4981da1 100644
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

