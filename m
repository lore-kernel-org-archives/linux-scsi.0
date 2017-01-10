From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V7 11/11] megaraid_sas: driver version upgrade
Date: Tue, 10 Jan 2017 18:20:53 -0500
Message-ID: <1484090453-7091-12-git-send-email-sasikumar.pc@broadcom.com>
References: <1484090453-7091-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35267 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932757AbdAJXVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 18:21:38 -0500
Received: by mail-qk0-f172.google.com with SMTP id u25so575678312qki.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2017 15:21:33 -0800 (PST)
In-Reply-To: <1484090453-7091-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com

Upgrade driver version.

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
Changes v6 -> v7:
-None

 drivers/scsi/megaraid/megaraid_sas.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 21c48e1..ba9fbb7 100644
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

