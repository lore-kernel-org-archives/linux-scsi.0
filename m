From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] scsi_dh: Fix return value of scsi_dh_attach()
Date: Fri, 18 Nov 2011 00:34:24 +0100
Message-ID: <1321572864-23628-1-git-send-email-richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
List-Id: linux-scsi@vger.kernel.org

scsi_dh_attach() should return a negative value on error.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 include/scsi/scsi_dh.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index e3f2db2..e07ab10 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -74,7 +74,7 @@ static inline int scsi_dh_handler_exist(const char *name)
 }
 static inline int scsi_dh_attach(struct request_queue *req, const char *name)
 {
-	return SCSI_DH_NOSYS;
+	return -SCSI_DH_NOSYS;
 }
 static inline void scsi_dh_detach(struct request_queue *q)
 {
-- 
1.7.7.3
