From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] tcm_fc: remove unused including <generated/utsrelease.h>
Date: Sun, 26 Aug 2012 08:37:50 +0800
Message-ID: <CAPgLHd8UgUtKdzPz+LvzTV2WUhxC7z_Bd__NQMt4F6B8DyDK4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40435 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2HZAhv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Aug 2012 20:37:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>


From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <generated/utsrelease.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/tcm_fc/tfc_cmd.c  | 1 -
 drivers/target/tcm_fc/tfc_io.c   | 1 -
 drivers/target/tcm_fc/tfc_sess.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index b9cb500..4d44ad3 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/slab.h>

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index ad36ede1..d051102 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -28,7 +28,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/slab.h>

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 87901fa..a0e3cee 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/slab.h>

