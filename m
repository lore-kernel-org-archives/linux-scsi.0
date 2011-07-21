From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 002/103] target: Minor header comment fixes
Date: Thu, 21 Jul 2011 00:04:38 -0700
Message-ID: <1311231979-6631-3-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.bf1.yahoo.com ([98.139.212.183]:24918 "HELO
	nm24.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751988Ab1GUHF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:59 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Reported-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    2 +-
 drivers/target/target_core_hba.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f5516a1..1b5d78f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1,7 +1,7 @@
 /*******************************************************************************
  * Filename:  target_core_device.c (based on iscsi_target_device.c)
  *
- * This file contains the iSCSI Virtual Device and Disk Transport
+ * This file contains the TCM Virtual Device and Disk Transport
  * agnostic related functions.
  *
  * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 0b8f8da..ddf5ae0 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -1,7 +1,7 @@
 /*******************************************************************************
  * Filename:  target_core_hba.c
  *
- * This file copntains the iSCSI HBA Transport related functions.
+ * This file contains the TCM HBA Transport related functions.
  *
  * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
  * Copyright (c) 2005, 2006, 2007 SBE, Inc.
-- 
1.7.6

