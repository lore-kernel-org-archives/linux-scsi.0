From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 8/8] snic: updating driver version
Date: Thu, 17 Mar 2016 00:51:17 -0700
Message-ID: <1458201077-10211-8-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-4.cisco.com ([173.37.142.91]:10964 "EHLO
	alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676AbcCQH5j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:39 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

updated driver version to 0.0.1.26

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 8ed778d..31cb20b 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -41,7 +41,7 @@
 
 #define SNIC_DRV_NAME		"snic"
 #define SNIC_DRV_DESCRIPTION	"Cisco SCSI NIC Driver"
-#define SNIC_DRV_VERSION	"0.0.1.18"
+#define SNIC_DRV_VERSION	"0.0.1.26"
 #define PFX			SNIC_DRV_NAME ":"
 #define DFX			SNIC_DRV_NAME "%d: "
 
-- 
1.8.5.4

