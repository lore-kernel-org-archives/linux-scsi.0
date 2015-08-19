From: John Soni Jose <sony.john@avagotech.com>
Subject: [PATCH 2/2]  be2iscsi: Bump the driver version
Date: Thu, 20 Aug 2015 04:44:31 +0530
Message-ID: <1440026071-27748-3-git-send-email-sony.john@avagotech.com>
References: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:50763 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752540AbbHSGtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Aug 2015 02:49:18 -0400
In-Reply-To: <1440026071-27748-1-git-send-email-sony.john@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: John Soni Jose <sony.john@avagotech.com>

 Bump the driver version

Signed-off-by: John Soni Jose <sony.john@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index afcd55f..9ff4fd6 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -36,7 +36,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 
 #define DRV_NAME		"be2iscsi"
-#define BUILD_STR		"10.6.0.0"
+#define BUILD_STR		"10.6.0.1"
 #define BE_NAME			"Avago Technologies OneConnect" \
 				"Open-iSCSI Driver version" BUILD_STR
 #define DRV_DESC		BE_NAME " " "Driver"
-- 
1.7.1

