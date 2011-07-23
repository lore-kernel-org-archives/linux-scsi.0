From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH] tcm_fc: remove duplicated #include
Date: Sat, 23 Jul 2011 16:21:39 +0800
Message-ID: <1311409299-2096-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46215 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GWIVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 04:21:51 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so4899732pzk.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 Jul 2011 01:21:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include('s) in
  drivers/target/tcm_fc/tfc_cmd.c
  drivers/target/tcm_fc/tfc_conf.c
  drivers/target/tcm_fc/tfc_io.c
  drivers/target/tcm_fc/tfc_sess.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/target/tcm_fc/tfc_cmd.c  |    1 -
 drivers/target/tcm_fc/tfc_conf.c |    1 -
 drivers/target/tcm_fc/tfc_io.c   |    1 -
 drivers/target/tcm_fc/tfc_sess.c |    2 --
 4 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index a9e9a31..2aa2d5a 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -45,7 +45,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/target_core_tmr.h>
 #include <target/configfs_macros.h>
 
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index d63e3dd..8781d1e 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -48,7 +48,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/configfs_macros.h>
 
 #include "tcm_fc.h"
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 11e6483..8e2a46d 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -54,7 +54,6 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/configfs_macros.h>
 
 #include "tcm_fc.h"
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index fbcbb3d..dbb5eae 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -46,10 +46,8 @@
 #include <target/target_core_device.h>
 #include <target/target_core_tpg.h>
 #include <target/target_core_configfs.h>
-#include <target/target_core_base.h>
 #include <target/configfs_macros.h>
 
-#include <scsi/libfc.h>
 #include "tcm_fc.h"
 
 static void ft_sess_delete_all(struct ft_tport *);
-- 
1.5.6.4

