From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 19/19] be2iscsi: Driver Version change
Date: Thu, 22 Jul 2010 04:31:07 +0530
Message-ID: <20100721230057.GA9866@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:26068 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755292Ab0GUXAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 19:00:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	Changing the Driver version number

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 6cfa55d..90eb74f 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -35,7 +35,7 @@
 
 #include "be.h"
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"2.0.527.0"
+#define BUILD_STR		"2.0.549.0"
 #define BE_NAME			"ServerEngines BladeEngine2" \
 				"Linux iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.6.5.2

