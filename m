From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 9/9] fnic: Incremented driver version
Date: Mon,  9 Sep 2013 13:31:53 -0700
Message-ID: <1378758713-22443-9-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:4271 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3IIUgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:42 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
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

