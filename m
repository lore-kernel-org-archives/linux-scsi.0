From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: qla2xxx: fix spelling mistake of variable sfp_additonal_info
Date: Wed, 16 Aug 2017 09:51:20 +0100
Message-ID: <20170816085120.10136-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to variable name, sfp_additonal_info should be
sfp_additional_info (add in missing i).

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c14fab35fc36..916f685872aa 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -452,7 +452,7 @@ qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 			uint16_t peg_fw_state, nw_interface_link_up;
 			uint16_t nw_interface_signal_detect, sfp_status;
 			uint16_t htbt_counter, htbt_monitor_enable;
-			uint16_t sfp_additonal_info, sfp_multirate;
+			uint16_t sfp_additional_info, sfp_multirate;
 			uint16_t sfp_tx_fault, link_speed, dcbx_status;
 
 			/*
@@ -492,7 +492,7 @@ qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 			sfp_status = ((mb[2] & 0x0c00) >> 10);
 			htbt_counter = ((mb[2] & 0x7000) >> 12);
 			htbt_monitor_enable = ((mb[2] & 0x8000) >> 15);
-			sfp_additonal_info = (mb[6] & 0x0003);
+			sfp_additional_info = (mb[6] & 0x0003);
 			sfp_multirate = ((mb[6] & 0x0004) >> 2);
 			sfp_tx_fault = ((mb[6] & 0x0008) >> 3);
 			link_speed = ((mb[6] & 0x0070) >> 4);
@@ -507,9 +507,9 @@ qla83xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 			    sfp_status);
 			ql_log(ql_log_warn, vha, 0x5067,
 			    "htbt_counter=0x%x, htbt_monitor_enable=0x%x, "
-			    "sfp_additonal_info=0x%x, sfp_multirate=0x%x.\n ",
+			    "sfp_additional_info=0x%x, sfp_multirate=0x%x.\n ",
 			    htbt_counter, htbt_monitor_enable,
-			    sfp_additonal_info, sfp_multirate);
+			    sfp_additional_info, sfp_multirate);
 			ql_log(ql_log_warn, vha, 0x5068,
 			    "sfp_tx_fault=0x%x, link_state=0x%x, "
 			    "dcbx_status=0x%x.\n", sfp_tx_fault, link_speed,
-- 
2.11.0
