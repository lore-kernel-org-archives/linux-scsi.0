From: ravi.anand@qlogic.com
Subject: [PATCH 08/11] Updated Comment at the head of the func's
Date: Tue, 7 Mar 2006 16:35:53 -0800
Message-ID: <11417781482672-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:8946 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964857AbWCHAf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:56 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_init.c   |   57 ----------------------------
 drivers/scsi/qla4xxx/ql4_inline.h |    3 -
 drivers/scsi/qla4xxx/ql4_iocb.c   |   12 ------
 drivers/scsi/qla4xxx/ql4_isr.c    |    3 -
 drivers/scsi/qla4xxx/ql4_mbx.c    |   36 ------------------
 drivers/scsi/qla4xxx/ql4_os.c     |   75 -------------------------------------
 6 files changed, 0 insertions(+), 186 deletions(-)

dc84ce7aef7791a98b973bc98156d2830052f46d
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 7fffcd4..73f6de8 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -52,9 +52,6 @@ ql4xxx_set_mac_number(scsi_qla_host_t * 
  *
  * Returns:
  *	None
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 void
 qla4xxx_free_ddb(scsi_qla_host_t * ha, struct ddb_entry *ddb_entry)
@@ -81,9 +78,6 @@ qla4xxx_free_ddb(scsi_qla_host_t * ha, s
  *
  * Returns:
  *	None
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 void
 qla4xxx_free_ddb_list(scsi_qla_host_t * ha)
@@ -114,9 +108,6 @@ qla4xxx_free_ddb_list(scsi_qla_host_t * 
  *	The QLA4000 doesn't care, so just default to QLA4010's requirement.
  * Returns:
  *	QLA_SUCCESS - Always return success.
- *
- * Context:
- *	Kernel context.
  */
 int
 qla4xxx_init_rings(scsi_qla_host_t * ha)
@@ -171,9 +162,6 @@ qla4xxx_init_rings(scsi_qla_host_t * ha)
  * Returns:
  *	QLA_SUCCESS - Successfully validated M.A.C. address
  *	QLA_ERROR   - Failed to validate M.A.C. address
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static int
 qla4xxx_validate_mac_address(scsi_qla_host_t *ha)
@@ -227,9 +215,6 @@ exit_validate_mac_no_free:
  * Returns:
  *	QLA_SUCCESS - Successfully initialized local data
  *	QLA_ERROR   - Failed to initialize local data
- *
- * Context:
- *	Kernel context.
  */
 static int
 qla4xxx_init_local_data(scsi_qla_host_t *ha)
@@ -342,9 +327,6 @@ qla4xxx_fw_ready(scsi_qla_host_t * ha)
  * Returns:
  *	QLA_SUCCESS - Successfully initialized firmware
  *	QLA_ERROR   - Failed to initialize firmware
- *
- * Context:
- *	Kernel context.
  */
 static int
 qla4xxx_init_firmware(scsi_qla_host_t * ha)
@@ -434,9 +416,6 @@ qla4xxx_get_ddb_entry(scsi_qla_host_t *h
  * Returns:
  *	QLA_SUCCESS - Successfully update ddb_entry
  *	QLA_ERROR   - Failed to update ddb_entry
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_update_ddb_entry(scsi_qla_host_t * ha, struct ddb_entry *ddb_entry,
@@ -515,9 +494,6 @@ exit_update_ddb:
  *
  * Returns:
  *	Pointer to internal device database structure
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 struct ddb_entry *
 qla4xxx_alloc_ddb(scsi_qla_host_t * ha, uint32_t fw_ddb_index)
@@ -564,9 +540,6 @@ qla4xxx_alloc_ddb(scsi_qla_host_t * ha, 
  * Returns:
  *	QLA_SUCCESS - Successfully built internal ddb list, if targets available
  *	QLA_ERROR   - Error on a mailbox command
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static int
 qla4xxx_build_ddb_list(scsi_qla_host_t *ha)
@@ -663,9 +636,6 @@ qla4xxx_build_ddb_list(scsi_qla_host_t *
  * Returns:
  *	QLA_SUCCESS - Successfully (re)built internal ddb list
  *	QLA_ERROR   - Failed to (re)build internal ddb list
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static int
 qla4xxx_devices_ready(scsi_qla_host_t * ha)
@@ -841,9 +811,6 @@ qla4xxx_initialize_ddb_list(scsi_qla_hos
  * Returns:
  *	QLA_SUCCESS - Successfully updated internal ddb list
  *	QLA_ERROR   - Failed to update internal ddb list
- *
- * Context:
- *	Kernel context.
  */
 int
 qla4xxx_reinitialize_ddb_list(scsi_qla_host_t * ha)
@@ -878,9 +845,6 @@ qla4xxx_reinitialize_ddb_list(scsi_qla_h
  * Returns:
  *    QLA_SUCCESS = Successfully relogged in device
  *    QLA_ERROR   = Failed to relogin device
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_relogin_device(scsi_qla_host_t * ha, struct ddb_entry * ddb_entry)
@@ -908,9 +872,6 @@ qla4xxx_relogin_device(scsi_qla_host_t *
  *
  * Returns:
  *	None.
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static void
 qla4010_get_topcat_presence(scsi_qla_host_t * ha)
@@ -1083,9 +1044,6 @@ qla4xxx_start_firmware_from_flash(scsi_q
  * Returns:
  *	QLA_SUCCESS - Successfully started QLA4xxx firmware
  *	QLA_ERROR   - Failed to start QLA4xxx firmware
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static int
 qla4xxx_start_firmware(scsi_qla_host_t * ha)
@@ -1210,9 +1168,6 @@ qla4xxx_start_firmware(scsi_qla_host_t *
  * Returns:
  *	QLA_SUCCESS - Successfully initialized adapter
  *	QLA_ERROR   - Failed to initialize adapter
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_initialize_adapter(scsi_qla_host_t * ha, uint8_t renew_ddb_list)
@@ -1294,9 +1249,6 @@ exit_init_hba:
  *
  * Returns:
  *	None
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static void
 qla4xxx_add_device_dynamically(scsi_qla_host_t *ha, uint32_t fw_ddb_index)
@@ -1338,9 +1290,6 @@ qla4xxx_add_device_dynamically(scsi_qla_
  * Returns:
  *	QLA_SUCCESS - Successfully processed ddb_changed aen
  *	QLA_ERROR   - Failed to process ddb_changed aen
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_process_ddb_changed(scsi_qla_host_t * ha, uint32_t fw_ddb_index,
@@ -1436,9 +1385,6 @@ qla4xxx_process_ddb_changed(scsi_qla_hos
  * Returns:
  *	QLA_SUCCESS - Successfully logged in device
  *	QLA_ERROR   - Failed to login device
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_login_device(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
@@ -1483,9 +1429,6 @@ exit_login_device:
  * Returns:
  *	QLA_SUCCESS - Successfully logged out device
  *	QLA_ERROR   - Failed to logout device
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_logout_device(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
diff --git a/drivers/scsi/qla4xxx/ql4_inline.h b/drivers/scsi/qla4xxx/ql4_inline.h
index 0ba7919..bd4dd42 100644
--- a/drivers/scsi/qla4xxx/ql4_inline.h
+++ b/drivers/scsi/qla4xxx/ql4_inline.h
@@ -17,9 +17,6 @@
  *
  * Returns:
  *      Pointer to the corresponding internal device database structure
- *
- * Context:
- *      Kernel context.
  */
 static inline ddb_entry_t *
 qla4xxx_lookup_ddb_by_fw_index(scsi_qla_host_t *ha, uint32_t fw_ddb_index)
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index d123bb7..2621011 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -26,9 +26,6 @@
  * Returns:
  *	QLA_SUCCESS - Successfully retrieved request packet
  *	QLA_ERROR   - Failed to retrieve request packet
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_get_req_pkt(scsi_qla_host_t *ha, QUEUE_ENTRY **queue_entry)
@@ -77,9 +74,6 @@ qla4xxx_get_req_pkt(scsi_qla_host_t *ha,
  * Returns:
  *	QLA_SUCCESS - Successfully sent marker IOCB
  *	QLA_ERROR   - Failed to send marker IOCB
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_send_marker_iocb(scsi_qla_host_t *ha, ddb_entry_t *ddb_entry, int lun)
@@ -194,9 +188,6 @@ qla4xxx_free_pdu(scsi_qla_host_t * ha, P
  * Returns:
  *	QLA_SUCCESS - Successfully sent marker IOCB
  *	QLA_ERROR   - Failed to send marker IOCB
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_send_passthru0_iocb(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
@@ -359,9 +350,6 @@ qla4xxx_build_scsi_iocbs(srb_t *srb, COM
  * Returns:
  *      QLA_SUCCESS - Successfully sent command to ISP
  *      QLA_ERROR   - Failed to send command to ISP
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_send_command_to_isp(scsi_qla_host_t *ha, srb_t * srb)
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 6569888..4a7b199 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -745,9 +745,6 @@ qla4xxx_intr_handler(int irq, void *dev_
  *
  * Returns:
  *	None
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 void
 qla4xxx_process_aen(scsi_qla_host_t * ha, uint8_t process_aen)
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 823c4c2..094d16b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -36,9 +36,6 @@ extern int qla4xxx_eh_wait_for_active_ta
  * Returns:
  *	QLA_SUCCESS - Mailbox command completed successfully
  *	QLA_ERROR   - Mailbox command competed in error.
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_mailbox_command(scsi_qla_host_t * ha, uint8_t inCount,
@@ -248,9 +245,6 @@ int qla4xxx_mbx_test(scsi_qla_host_t * h
  *
  * Returns:
  *	qla2x00 local function return status code.
- *
- * Context:
- *	Kernel context.
  */
 int
 qla4xxx_issue_iocb(scsi_qla_host_t * ha, void *buffer, dma_addr_t phys_addr,
@@ -323,9 +317,6 @@ qla4xxx_clear_database_entry(scsi_qla_ho
  * Returns:
  *	QLA_SUCCESS - Successfully initialized firmware ctrl block
  *	QLA_ERROR   - Failed to initialize firmware ctrl block
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_initialize_fw_cb(scsi_qla_host_t * ha)
@@ -431,9 +422,6 @@ qla4xxx_initialize_fw_cb(scsi_qla_host_t
  * Returns:
  *	QLA_SUCCESS - Successfully obtained DHCP IP Address
  *	QLA_ERROR   - Failed to obtained
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_get_dhcp_ip_address(scsi_qla_host_t * ha)
@@ -492,9 +480,6 @@ qla4xxx_get_dhcp_ip_address(scsi_qla_hos
  * Returns:
  *	QLA_SUCCESS - Successfully retrieved firmware state
  *	QLA_ERROR   - Failed to retrieve firmware state
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_get_firmware_state(scsi_qla_host_t * ha)
@@ -531,9 +516,6 @@ qla4xxx_get_firmware_state(scsi_qla_host
  * Returns:
  *	QLA_SUCCESS - Successfully retrieved firmware status
  *	QLA_ERROR   - Failed to retrieve firmware status
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_get_firmware_status(scsi_qla_host_t * ha)
@@ -585,9 +567,6 @@ qla4xxx_get_firmware_status(scsi_qla_hos
  * Returns:
  *	QLA_SUCCESS - Successfully retrieved ddb info from firmware
  *	QLA_ERROR   - Failed to retrieve ddb info from firmware
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_get_fwddb_entry(scsi_qla_host_t *ha, uint16_t fw_ddb_index,
@@ -682,9 +661,6 @@ exit_get_fwddb:
  * Returns:
  *	QLA_SUCCESS - Successfully set ddb_entry in firmware
  *	QLA_ERROR   - Failed to set ddb_entry in firmware
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_set_ddb_entry(scsi_qla_host_t * ha, uint16_t fw_ddb_index,
@@ -741,9 +717,6 @@ qla4xxx_conn_open_session_login(scsi_qla
  *
  * Returns:
  *	None
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 void
 qla4xxx_get_crash_record(scsi_qla_host_t * ha)
@@ -803,9 +776,6 @@ exit_get_crash_record:
  *
  * Returns:
  *	None
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 void
 qla4xxx_get_conn_event_log(scsi_qla_host_t * ha)
@@ -908,9 +878,6 @@ exit_get_event_log:
  * Returns:
  *	QLA_SUCCESS - lun reset completed successfully
  *	QLA_ERROR   - lun reset failed
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_reset_lun(scsi_qla_host_t * ha, ddb_entry_t * ddb_entry, int lun)
@@ -982,9 +949,6 @@ qla4xxx_get_flash(scsi_qla_host_t * ha, 
  * Returns:
  *	QLA_SUCCESS - Successfully retrieved firmware version
  *	QLA_ERROR   - Failed to retrieve firmware version
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 int
 qla4xxx_get_fw_version(scsi_qla_host_t * ha)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 27aabb9..746814f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -164,8 +164,6 @@ qla4xxx_stop_timer(scsi_qla_host_t * ha)
  * Returns:
  *	None
  *
- * Context:
- *	Kernel context.
  **************************************************************************/
 void
 qla4xxx_mark_device_missing(scsi_qla_host_t * ha, ddb_entry_t * ddb_entry)
@@ -245,9 +243,6 @@ qla4xxx_srb_compl(scsi_qla_host_t *ha, s
  *
  * Returns:
  *      None
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static int
 qla4xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
@@ -310,9 +305,6 @@ qc_fail_command:
  * Input:
  *
  * Returns:
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static int __devinit
 qla4xxx_probe_adapter(struct pci_dev *pdev, const struct pci_device_id *ent)
@@ -479,9 +471,6 @@ probe_disable_device:
  *	pci_dev - PCI device pointer
  *
  * Returns:
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static void __devexit
 qla4xxx_remove_adapter(struct pci_dev *pdev)
@@ -506,9 +495,6 @@ qla4xxx_remove_adapter(struct pci_dev *p
  *	pci_dev - PCI device pointer
  *
  * Returns:
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static void
 qla4xxx_free_adapter(scsi_qla_host_t * ha)
@@ -556,9 +542,6 @@ qla4xxx_free_adapter(scsi_qla_host_t * h
  * Input:
  *
  * Returns:
- *
- * Context:
- *	Kernel context.
  **************************************************************************/
 static int
 qla4xxx_iospace_config(scsi_qla_host_t * ha)
@@ -660,8 +643,6 @@ qla4xxx_config_dma_addressing(scsi_qla_h
  *      QLA_SUCCESS - Successfully allocated adapter memory
  *      QLA_ERROR   - Failed to allocate adapter memory
  *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static int
 qla4xxx_mem_alloc(scsi_qla_host_t * ha)
@@ -731,9 +712,6 @@ mem_alloc_error_exit:
  *
  * Returns:
  *      None
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static void
 qla4xxx_mem_free(scsi_qla_host_t * ha)
@@ -811,9 +789,6 @@ qla4xxx_slave_configure(struct scsi_devi
  *
  * Returns:
  *      Pointer to corresponding SCSI Request Block
- *
- * Context:
- *      Kernel/Interrupt context.
  **************************************************************************/
 srb_t *
 del_from_active_array(scsi_qla_host_t * ha, uint32_t index)
@@ -849,9 +824,6 @@ del_from_active_array(scsi_qla_host_t * 
  *
  * Returns:
  *      None
- *
- * Context:
- *      Interrupt context.
  **************************************************************************/
 void
 qla4xxx_timer(scsi_qla_host_t *ha)
@@ -1001,9 +973,6 @@ qla4xxx_check_for_disable_hba_reset(scsi
  *
  * Returns:
  *      None
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static int qla4xxx_do_dpc(void *data)
 {
@@ -1143,9 +1112,6 @@ static int qla4xxx_do_dpc(void *data)
  * Returns:
  *      QLA_SUCCESS - Successfully reset the firmware
  *      QLA_ERROR   - Failed to reset the firmware
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4010_soft_reset(scsi_qla_host_t * ha)
@@ -1266,9 +1232,6 @@ qla4010_soft_reset(scsi_qla_host_t * ha)
  * Returns:
  *      QLA_SUCCESS - Successfully reset the firmware
  *      QLA_ERROR   - Failed to reset the firmware
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_topcat_reset(scsi_qla_host_t * ha)
@@ -1302,9 +1265,6 @@ qla4xxx_topcat_reset(scsi_qla_host_t * h
  * Returns:
  *      QLA_SUCCESS - Successfully reset the firmware
  *      QLA_ERROR   - Failed to reset the firmware
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_soft_reset(scsi_qla_host_t * ha)
@@ -1337,9 +1297,6 @@ qla4xxx_soft_reset(scsi_qla_host_t * ha)
  * Returns:
  *      QLA_SUCCESS - Successfully reset the firmware
  *      QLA_ERROR   - Failed to reset the firmware
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_hard_reset(scsi_qla_host_t * ha)
@@ -1375,9 +1332,6 @@ qla4xxx_hard_reset(scsi_qla_host_t * ha)
  * Returns:
  *      QLA_SUCCESS - All outstanding commands completed
  *      QLA_ERROR   - All outstanding commands did not complete
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static int
 qla4xxx_cmd_wait(scsi_qla_host_t * ha)
@@ -1432,9 +1386,6 @@ qla4xxx_cmd_wait(scsi_qla_host_t * ha)
  * Returns:
  *      QLA_SUCCESS - Successfully recovered adapter
  *      QLA_ERROR   - Failed to recover adapter
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_recover_adapter(scsi_qla_host_t * ha, uint8_t renew_ddb_list)
@@ -1555,9 +1506,6 @@ qla4xxx_recover_adapter(scsi_qla_host_t 
  * Returns:
  *    Not Found : 0
  *    Found : 1
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static int
 qla4xxx_eh_wait_on_command(scsi_qla_host_t * ha, struct scsi_cmnd *cmd)
@@ -1592,9 +1540,6 @@ qla4xxx_eh_wait_on_command(scsi_qla_host
  * Returns:
  *      SUCCESS - Adapter is ONLINE
  *      FAILED  - Adapter is DEAD
- *
- * Context:
- *      Kernel context.  Assume io_request_lock LOCKED upon entry
  **************************************************************************/
 int qla4xxx_wait_for_hba_online(scsi_qla_host_t * ha)
 {
@@ -1631,9 +1576,6 @@ int qla4xxx_wait_for_hba_online(scsi_qla
  * Returns:
  *      SUCCESS - Successfully aborted non-active command
  *      FAILED  - Command not found, or command currently active
- *
- * Context:
- *      Kernel context.  io_request_lock LOCKED
  **************************************************************************/
 static int
 qla4xxx_eh_abort(struct scsi_cmnd *cmd)
@@ -1661,9 +1603,6 @@ qla4xxx_eh_abort(struct scsi_cmnd *cmd)
  * Returns:
  *      0 - All pending commands returned
  *      non-zero - All pending commands did not return
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_eh_wait_for_active_target_commands(scsi_qla_host_t * ha, int t, int l)
@@ -1714,9 +1653,6 @@ qla4xxx_eh_wait_for_active_target_comman
  * Returns:
  *      SUCCESS - Successfully reset target/lun
  *      FAILED  - Failed to reset target/lun
- *
- * Context:
- *      Kernel context.  io_request_lock LOCKED
  **************************************************************************/
 static int
 qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
@@ -1787,8 +1723,6 @@ eh_dev_reset_done:
  *      SUCCESS - Successfully reset adapter/bus
  *      FAILED  - Failed to reset adapter/bus
  *
- * Context:
- *      Kernel context.  io_request_lock LOCKED
  **************************************************************************/
 static int
 qla4xxx_eh_bus_reset(struct scsi_cmnd *cmd)
@@ -1847,9 +1781,6 @@ qla4xxx_eh_bus_reset(struct scsi_cmnd *c
  * Returns:
  *      QLA_SUCCESS - Successfully reset target
  *      QLA_ERROR   - Failed to reset target
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 int
 qla4xxx_reset_target(scsi_qla_host_t * ha, ddb_entry_t * ddb_entry)
@@ -1909,9 +1840,6 @@ qla4xxx_reset_target(scsi_qla_host_t * h
  *
  * Returns:
  *      None
- *
- * Context:
- *      Kernel context.
  **************************************************************************/
 static void
 qla4xxx_flush_active_srbs(scsi_qla_host_t * ha)
@@ -1943,9 +1871,6 @@ qla4xxx_flush_active_srbs(scsi_qla_host_
  * Returns:
  *      SUCCESS - Successfully recovered host adapter
  *      FAILED  - Failed to recover host adapter
- *
- * Context:
- *      Kernel context.  io_request_lock LOCKED
  **************************************************************************/
 static int
 qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
-- 
1.2.4.g9201-dirty


