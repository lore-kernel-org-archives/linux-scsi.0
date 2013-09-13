From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 3/3] fnic: Incremented driver version
Date: Thu, 12 Sep 2013 17:45:43 -0700
Message-ID: <1379033143-1482-3-git-send-email-hiralpat@cisco.com>
References: <1379033143-1482-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-2.cisco.com ([173.36.130.13]:11791 "EHLO
	mtv-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IMAuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2013 20:50:22 -0400
In-Reply-To: <1379033143-1482-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>

Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index db7a950..528d43b 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.5.0.23"
+#define DRV_VERSION		"1.5.0.45"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
1.7.10.4

