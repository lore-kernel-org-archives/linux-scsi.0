From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 3/3] fnic: Incremented driver version
Date: Mon, 25 Feb 2013 16:18:38 -0800
Message-ID: <1361837918-23282-3-git-send-email-hiralpat@cisco.com>
References: <1361837918-23282-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:36140 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759709Ab3BZATJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 19:19:09 -0500
In-Reply-To: <1361837918-23282-1-git-send-email-hiralpat@cisco.com>
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
1.7.10.4

