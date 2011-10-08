From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] be2iscsi: Move driver Version
Date: Fri,  7 Oct 2011 19:31:12 -0500
Message-ID: <1318033872-5900-6-git-send-email-michaelc@cs.wisc.edu>
References: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1JHA0G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 20:26:06 -0400
In-Reply-To: <1318033872-5900-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

   This patch bumps up the driver version

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index be0e0bd..b4a06d5 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -34,7 +34,7 @@
 
 #include "be.h"
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"2.103.298.0"
+#define BUILD_STR		"4.1.239.0"
 #define BE_NAME			"ServerEngines BladeEngine2" \
 				"Linux iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.7.6

