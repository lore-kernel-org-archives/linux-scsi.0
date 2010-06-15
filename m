From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 23/23] bfa: update driver version string
Date: Tue, 15 Jun 2010 11:53:12 -0700
Message-ID: <1276627992-15285-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:44704 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870Ab0FOSxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2010 14:53:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vravindr@brocade.com, rvadivel@brocade.com, kgudipat@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Update driver version to 2.2.2.1

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad_drv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 11b0c1c..c0a0a9c 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -46,7 +46,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "2.1.2.1"
+#define BFAD_DRIVER_VERSION    "2.2.2.1"
 #endif
 
 
-- 
1.6.5.2

