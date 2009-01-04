From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [SCSI] remove unused #include <version.h>'s
Date: Sun, 04 Jan 2009 11:13:48 +0800
Message-ID: <20090104105242.C999.WEIYI.HUANG@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:4183 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZADDNr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jan 2009 22:13:47 -0500
Received: by ti-out-0910.google.com with SMTP id b6so9149698tic.23
        for <linux-scsi@vger.kernel.org>; Sat, 03 Jan 2009 19:13:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Removed unused #include <version.h>'s in files below,
  drivers/scsi/cxgb3i/cxgb3i_offload.c
  drivers/scsi/fcoe/fcoe_sw.c
  drivers/scsi/fcoe/libfcoe.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index a865f1f..5b464cf 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/if_vlan.h>
-#include <linux/version.h>
 
 #include "cxgb3_defs.h"
 #include "cxgb3_ctl_defs.h"
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index dc4cd5e..13b37eb 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/init.h>
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index e419f48..7ff93dd 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
