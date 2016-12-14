From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V5 11/11] megaraid_sas: driver version upgrade
Date: Wed, 14 Dec 2016 17:13:08 -0500
Message-ID: <1481753588-101811-12-git-send-email-sasikumar.pc@broadcom.com>
References: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35644 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933891AbcLNWNz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 17:13:55 -0500
Received: by mail-qk0-f169.google.com with SMTP id n204so37205762qke.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2016 14:13:55 -0800 (PST)
In-Reply-To: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com

Upgrade driver version.

This patch is depending on patch 10
This patch is same as V4 and there is no specific update for V5

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index d2dc340..5412759 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,8 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.812.07.00-rc1"
-#define MEGASAS_RELDATE				"August 22, 2016"
+#define MEGASAS_VERSION				"07.700.00.00-rc1"
+#define MEGASAS_RELDATE				"November 29, 2016"
 
 /*
  * Device IDs
-- 
1.8.3.1

