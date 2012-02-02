From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scsi: Fix typo in mvumi.c
Date: Thu,  2 Feb 2012 22:34:43 +0900
Message-ID: <1328189683-1722-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: standby24x7@gmail.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Correct spelling "resouce" to "resource" in
drivers/scsi/mvumi.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/mvumi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 88cf1db..787d9bd 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -122,7 +122,7 @@ static struct mvumi_res *mvumi_alloc_mem_resource(struct mvumi_hba *mhba,
 
 	if (!res) {
 		dev_err(&mhba->pdev->dev,
-			"Failed to allocate memory for resouce manager.\n");
+			"Failed to allocate memory for resource manager.\n");
 		return NULL;
 	}
 
-- 
1.7.6.5
