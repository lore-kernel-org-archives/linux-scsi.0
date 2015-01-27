From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 02/10] qla2xxx: Declare local functions static
Date: Tue, 27 Jan 2015 10:32:43 +0100
Message-ID: <54C75B3B.5050803@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0080.outbound.protection.outlook.com ([207.46.100.80]:26638
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895AbbA0Jcr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:32:47 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_iocb.c | 4 ++--
 drivers/scsi/qla2xxx/qla_nx.c   | 2 +-
 drivers/scsi/qla2xxx/qla_nx2.c  | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 2e2bb6f..e1c2a57 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -405,7 +405,7 @@ done:
 	return rval;
 }
 
-inline uint16_t
+static inline uint16_t
 qla24xx_calc_ct_iocbs(uint16_t dsds)
 {
 	uint16_t iocbs;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a1ab25f..fb0f514 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -680,7 +680,7 @@ qla24xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
  *
  * Returns the number of dsd list needed to store @dsds.
  */
-inline uint16_t
+static inline uint16_t
 qla24xx_calc_dsd_lists(uint16_t dsds)
 {
 	uint16_t dsd_lists = 0;
@@ -700,7 +700,7 @@ qla24xx_calc_dsd_lists(uint16_t dsds)
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
  */
-inline void
+static inline void
 qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
     uint16_t tot_dsds)
 {
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 54cb2ac..4e33c28 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2298,7 +2298,7 @@ void qla82xx_init_flags(struct qla_hw_data *ha)
 	ha->nx_legacy_intr.pci_int_reg = nx_legacy_intr->pci_int_reg;
 }
 
-inline void
+static inline void
 qla82xx_set_idc_version(scsi_qla_host_t *vha)
 {
 	int idc_ver;
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index ed4d6b6..d804d82 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -561,7 +561,7 @@ qla8044_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 	return buf;
 }
 
-inline int
+static inline int
 qla8044_need_reset(struct scsi_qla_host *vha)
 {
 	uint32_t drv_state, drv_active;
@@ -1605,7 +1605,7 @@ qla8044_set_idc_dontreset(struct scsi_qla_host *vha)
 	qla8044_wr_reg(ha, QLA8044_IDC_DRV_CTRL, idc_ctrl);
 }
 
-inline void
+static inline void
 qla8044_set_rst_ready(struct scsi_qla_host *vha)
 {
 	uint32_t drv_state;
-- 
2.1.2

