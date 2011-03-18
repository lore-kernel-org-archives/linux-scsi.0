From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 8/8] bnx2fc: Bump version to 1.0.1
Date: Thu, 17 Mar 2011 17:13:37 -0700
Message-ID: <1300407217.644.411.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4417 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1CRANv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>Nithin Sujir <nsujir@broadcom.com>

From: Nithin Sujir <nsujir@broadcom.com>

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index d869a4c..b6d350a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -62,7 +62,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.0"
+#define BNX2FC_VERSION		"1.0.1"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 38a00fe..2056890 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -21,7 +21,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Jan 25, 2011"
+#define DRV_MODULE_RELDATE	"Mar 17, 2011"
 

 static char version[] __devinitdata =
-- 
1.7.0.6




