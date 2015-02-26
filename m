From: Yannick Guerrini <yguerrini@tomshardware.fr>
Subject: [PATCH] qla2xxx: Fix trivial typos in ql_log message
Date: Thu, 26 Feb 2015 22:49:34 +0100
Message-ID: <1424987374-11148-1-git-send-email-yguerrini@tomshardware.fr>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org, Yannick Guerrini <yguerrini@tomshardware.fr>
List-Id: linux-scsi@vger.kernel.org

Change 'Fimware' to 'Firmware'
Change 'enalbled' to 'enabled'

Signed-off-by: Yannick Guerrini <yguerrini@tomshardware.fr>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 drivers/scsi/qla2xxx/qla_mid.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e59f25b..5bb57c5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5364,7 +5364,7 @@ qla2x00_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	blob = qla2x00_request_firmware(vha);
 	if (!blob) {
 		ql_log(ql_log_info, vha, 0x0083,
-		    "Fimware image unavailable.\n");
+		    "Firmware image unavailable.\n");
 		ql_log(ql_log_info, vha, 0x0084,
 		    "Firmware images can be retrieved from: "QLA_FW_URL ".\n");
 		return QLA_FUNCTION_FAILED;
@@ -5467,7 +5467,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	blob = qla2x00_request_firmware(vha);
 	if (!blob) {
 		ql_log(ql_log_warn, vha, 0x0090,
-		    "Fimware image unavailable.\n");
+		    "Firmware image unavailable.\n");
 		ql_log(ql_log_warn, vha, 0x0091,
 		    "Firmware images can be retrieved from: "
 		    QLA_FW_URL ".\n");
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 5c2e031..ca3804e 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -788,7 +788,7 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 		rsp->msix = &ha->msix_entries[que_id + 1];
 	else
 		ql_log(ql_log_warn, base_vha, 0x00e3,
-		    "MSIX not enalbled.\n");
+		    "MSIX not enabled.\n");
 
 	ha->rsp_q_map[que_id] = rsp;
 	rsp->rid = rid;
-- 
1.9.5.msysgit.0
