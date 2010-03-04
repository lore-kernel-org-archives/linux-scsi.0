From: <kgudipat@brocade.com>
Subject: [PATCH 01/32] bfa: Update the driver version to 2.1.2.1.
Date: Wed, 3 Mar 2010 17:41:35 -0800
Message-ID: <1267666895-20284-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:47616 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab0CDBmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2010 20:42:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:

	- Upgrade the upstream driver from 2.0.0.0 to 2.1.2.1.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_drv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 172c81e..26e5774 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -46,7 +46,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "2.0.0.0"
+#define BFAD_DRIVER_VERSION    "2.1.2.1"
 #endif
 
 
-- 
1.6.5.3

