From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 005/103] loopback: Only build tcm_loop as module
Date: Thu, 21 Jul 2011 00:04:41 -0700
Message-ID: <1311231979-6631-6-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.154]:48313 "HELO
	nm9-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752004Ab1GUHFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:05:50 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

The tcm_loop must be built as a module.  It cannot be built in.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
---
 drivers/target/loopback/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/target/loopback/Kconfig b/drivers/target/loopback/Kconfig
index 57dcbc2..1bd6a65 100644
--- a/drivers/target/loopback/Kconfig
+++ b/drivers/target/loopback/Kconfig
@@ -1,7 +1,8 @@
 config LOOPBACK_TARGET
 	tristate "TCM Virtual SAS target and Linux/SCSI LDD fabric loopback module"
+	depends on m
 	help
-	  Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LLD
+	  Say M here to enable the TCM Virtual SAS target and Linux/SCSI LLD
 	  fabric loopback module.
 
 config LOOPBACK_TARGET_CDB_DEBUG
-- 
1.7.6

