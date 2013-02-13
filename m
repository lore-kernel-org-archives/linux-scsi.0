From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 10/10] fnic: Incremented driver version
Date: Tue, 12 Feb 2013 17:01:05 -0800
Message-ID: <1360717265-14130-8-git-send-email-hiralpat@cisco.com>
References: <1360717265-14130-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:6230 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab3BMBG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 20:06:59 -0500
In-Reply-To: <1360717265-14130-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>, Brian Uchino <buchino@cisco.com>

Incrementing driver versio after bug fixes and new feature commits.

Signed-off-by: Brian Uchino <buchino@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index acec42a..b6d1f92 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -38,7 +38,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.5.0.2"
+#define DRV_VERSION		"1.5.0.22"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
-- 
1.7.9.5

