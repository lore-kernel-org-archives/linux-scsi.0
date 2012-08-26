From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] target: remove unused including <generated/utsrelease.h>
Date: Sun, 26 Aug 2012 08:38:22 +0800
Message-ID: <CAPgLHd8f+HHquyGiGo=UQ-QLOB=uE37fkDPCDSi7zjiK_89=Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:39092 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab2HZAiW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Aug 2012 20:38:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>


From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <generated/utsrelease.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_fabric_configfs.c | 1 -
 drivers/target/target_core_stat.c            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ea479e5..bca737b 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/fs.h>

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 3d44beb..cb6b003 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/string.h>
-#include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>

