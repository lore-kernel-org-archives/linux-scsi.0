From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scsi: Fix typo in pmcraid.h
Date: Thu, 16 Feb 2012 00:48:38 +0900
Message-ID: <1329320918-2745-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
List-Id: linux-scsi@vger.kernel.org

Correct spelling "thresold" to "threshold" in
drivers/scsi/pmraid.h

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/pmcraid.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index ca496c7..e1d150f 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -857,11 +857,11 @@ static struct pmcraid_ioasc_error pmcraid_ioasc_error_table[] = {
 	{0x01180600, IOASC_LOG_LEVEL_HARD,
 	 "Recovered Error, soft media error, sector reassignment suggested"},
 	{0x015D0000, IOASC_LOG_LEVEL_HARD,
-	 "Recovered Error, failure prediction thresold exceeded"},
+	 "Recovered Error, failure prediction threshold exceeded"},
 	{0x015D9200, IOASC_LOG_LEVEL_HARD,
-	 "Recovered Error, soft Cache Card Battery error thresold"},
+	 "Recovered Error, soft Cache Card Battery error threshold"},
 	{0x015D9200, IOASC_LOG_LEVEL_HARD,
-	 "Recovered Error, soft Cache Card Battery error thresold"},
+	 "Recovered Error, soft Cache Card Battery error threshold"},
 	{0x02048000, IOASC_LOG_LEVEL_HARD,
 	 "Not Ready, IOA Reset Required"},
 	{0x02408500, IOASC_LOG_LEVEL_HARD,
-- 
1.7.6.5
