From: Rudhresh Kumar J <rudhresh.jk@gmail.com>
Subject: [PATCH] SCSI: DTC: Fixed a coding style issue on pointer
Date: Tue, 30 Jun 2015 22:29:55 +0530
Message-ID: <1435683595-5958-1-git-send-email-rudhreshj@cdac.in>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: schmitzmic@gmail.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rudhresh Kumar J <rudhreshj@cdac.in>, Rudhresh Kumar J <rudhresh.jk@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Fixed space coding style issue on pointer

Signed-off-by: Rudhresh Kumar J <rudhresh.jk@gmail.com>
---
 drivers/scsi/dtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index 4c74c7b..edfe848 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -186,7 +186,7 @@ __setup("dtc=", dtc_setup);
  *
 */
 
-static int __init dtc_detect(struct scsi_host_template * tpnt)
+static int __init dtc_detect(struct scsi_host_template *tpnt)
 {
 	static int current_override = 0, current_base = 0;
 	struct Scsi_Host *instance;
-- 
1.8.4
