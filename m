From: <kgudipat@brocade.com>
Subject: [PATCH 10/10] bfa: Update the driver version to v3.1.2.0.
Date: Wed, 22 Aug 2012 19:53:45 -0700
Message-ID: <1345690425-22255-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:59170 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab2HWCyN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 22:54:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_drv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index d1511d8..1840651 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -57,7 +57,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "3.0.23.0"
+#define BFAD_DRIVER_VERSION    "3.1.2.0"
 #endif
 
 #define BFAD_PROTO_NAME FCPI_NAME
-- 
1.7.3.rc1

