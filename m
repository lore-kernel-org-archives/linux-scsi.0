From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] qla2xxx: Fix typo in qla_bsg.c
Date: Fri,  3 Feb 2012 22:15:25 +0900
Message-ID: <1328274925-1809-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: andrew.vasquez@qlogic.com, linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
List-Id: linux-scsi@vger.kernel.org

Correct spelling "curent" to "current" in
drivers/scsi/qla2xxx/qla_bsg.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index b1d0f93..a1c6a16 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -745,7 +745,7 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 
 			if (elreq.options != EXTERNAL_LOOPBACK) {
 				ql_dbg(ql_dbg_user, vha, 0x7020,
-				    "Internal: curent port config = %x\n",
+				    "Internal: current port config = %x\n",
 				    config[0]);
 				if (qla81xx_set_internal_loopback(vha, config,
 					new_config)) {
-- 
1.7.6.5
