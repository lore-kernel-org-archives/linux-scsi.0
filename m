From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] mpt2sas: remove unecessary if statement
Date: Sun,  5 Jun 2011 19:45:45 -0500
Message-ID: <1307321145-21789-1-git-send-email-Gregory.Dietsche@cuw.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Dietsche <Gregory.Dietsche@cuw.edu>
List-Id: linux-scsi@vger.kernel.org

the code always returns r regardless, so if(r) check is unecessary.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index efa0255..26577ef 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3796,9 +3796,6 @@ _base_make_ioc_operational(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	}
 
 	r = _base_send_port_enable(ioc, sleep_flag);
-	if (r)
-		return r;
-
 	return r;
 }
 
-- 
1.7.2.5
