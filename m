From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V6 11/11] megaraid_sas: driver version upgrade
Date: Thu, 22 Dec 2016 20:19:54 -0500
Message-ID: <1482455994-8047-12-git-send-email-sasikumar.pc@broadcom.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

Upgrade driver version.

This patch is depending on patch 10 and same as V5

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
