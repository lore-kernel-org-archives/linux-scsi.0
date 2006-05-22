From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 2/8] zfcp: (cleanup) remove useless comments
Date: Mon, 22 May 2006 18:15:49 +0200
Message-ID: <20060522161549.GA25236@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:2309 "EHLO
	mtagate2.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750951AbWEVQSX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:18:23 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate2.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGIMQR142642
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:18:22 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGJM2o127938
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:19:22 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGILLR015032
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:18:21 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: (cleanup) remove useless comments

Removed some useless comments.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

342b987b57dd0ca0b255453453473cede801879f
 drivers/s390/scsi/zfcp_erp.c  |  218 -----------------------------------------
 drivers/s390/scsi/zfcp_fsf.c  |   20 ----
 drivers/s390/scsi/zfcp_scsi.c |   46 ---------
 3 files changed, 0 insertions(+), 284 deletions(-)

342b987b57dd0ca0b255453453473cede801879f
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index e2dac3d..f57440c 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -221,13 +221,6 @@ zfcp_erp_adapter_reopen(struct zfcp_adap
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 int
 zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear_mask)
 {
@@ -241,13 +234,6 @@ zfcp_erp_adapter_shutdown(struct zfcp_ad
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 int
 zfcp_erp_port_shutdown(struct zfcp_port *port, int clear_mask)
 {
@@ -261,13 +247,6 @@ zfcp_erp_port_shutdown(struct zfcp_port 
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 int
 zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear_mask)
 {
@@ -802,13 +781,6 @@ zfcp_erp_unit_unblock(struct zfcp_unit *
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status);
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static void
 zfcp_erp_action_ready(struct zfcp_erp_action *erp_action)
 {
@@ -1346,13 +1318,6 @@ zfcp_erp_strategy_check_action(struct zf
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_strategy_do_action(struct zfcp_erp_action *erp_action)
 {
@@ -1528,13 +1493,6 @@ zfcp_erp_strategy_check_target(struct zf
 	return result;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_strategy_statechange(int action,
 			      u32 status,
@@ -1576,13 +1534,6 @@ zfcp_erp_strategy_statechange(int action
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static inline int
 zfcp_erp_strategy_statechange_detected(atomic_t * target_status, u32 erp_status)
 {
@@ -1595,13 +1546,6 @@ zfcp_erp_strategy_statechange_detected(a
 	     !(ZFCP_STATUS_ERP_CLOSE_ONLY & erp_status));
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_strategy_check_unit(struct zfcp_unit *unit, int result)
 {
@@ -1632,13 +1576,6 @@ zfcp_erp_strategy_check_unit(struct zfcp
 	return result;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_strategy_check_port(struct zfcp_port *port, int result)
 {
@@ -1668,13 +1605,6 @@ zfcp_erp_strategy_check_port(struct zfcp
 	return result;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_strategy_check_adapter(struct zfcp_adapter *adapter, int result)
 {
@@ -1754,13 +1684,6 @@ zfcp_erp_strategy_followup_actions(int a
 	return 0;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_strategy_check_queues(struct zfcp_adapter *adapter)
 {
@@ -1799,12 +1722,6 @@ zfcp_erp_wait(struct zfcp_adapter *adapt
 	return retval;
 }
 
-/*
- * function:	zfcp_erp_modify_adapter_status
- *
- * purpose:	
- *
- */
 void
 zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter,
 			       u32 mask, int set_or_clear)
@@ -1909,13 +1826,6 @@ zfcp_erp_port_reopen_all(struct zfcp_ada
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:	FIXME
- */
 static int
 zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *adapter, int clear_mask)
 {
@@ -2360,13 +2270,6 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 	return ret;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_adapter_strategy_open_fsf_statusread(struct zfcp_erp_action
 					      *erp_action)
@@ -2535,13 +2438,6 @@ zfcp_erp_port_strategy(struct zfcp_erp_a
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_port_strategy_open(struct zfcp_erp_action *erp_action)
 {
@@ -2556,15 +2452,6 @@ zfcp_erp_port_strategy_open(struct zfcp_
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- *
- * FIXME(design):	currently only prepared for fabric (nameserver!)
- */
 static int
 zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *erp_action)
 {
@@ -2680,13 +2567,6 @@ zfcp_erp_port_strategy_open_common(struc
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_port_strategy_open_nameserver(struct zfcp_erp_action *erp_action)
 {
@@ -2803,13 +2683,6 @@ zfcp_erp_port_forced_strategy_close(stru
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
@@ -3012,13 +2885,6 @@ zfcp_erp_unit_strategy(struct zfcp_erp_a
 	return retval;
 }
 
-/*
- * function:
- *
- * purpose:
- *
- * returns:
- */
 static int
 zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
 {
@@ -3119,13 +2985,6 @@ zfcp_erp_unit_strategy_open(struct zfcp_
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static inline void
 zfcp_erp_timeout_init(struct zfcp_erp_action *erp_action)
 {
@@ -3321,13 +3180,6 @@ zfcp_erp_action_enqueue(int action,
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 static int
 zfcp_erp_action_dequeue(struct zfcp_erp_action *erp_action)
 {
@@ -3422,13 +3274,6 @@ zfcp_erp_action_cleanup(int action, stru
 }
 
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:	FIXME
- */
 static int
 zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
 {
@@ -3445,13 +3290,6 @@ zfcp_erp_action_dismiss_adapter(struct z
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:	FIXME
- */
 static int
 zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 {
@@ -3470,13 +3308,6 @@ zfcp_erp_action_dismiss_port(struct zfcp
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:	FIXME
- */
 static int
 zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
 {
@@ -3491,13 +3322,6 @@ zfcp_erp_action_dismiss_unit(struct zfcp
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	moves erp_action to 'erp running list'
- *
- * returns:
- */
 static inline void
 zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
 {
@@ -3508,13 +3332,6 @@ zfcp_erp_action_to_running(struct zfcp_e
 	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
 }
 
-/*
- * function:	
- *
- * purpose:	moves erp_action to 'erp ready list'
- *
- * returns:
- */
 static inline void
 zfcp_erp_action_to_ready(struct zfcp_erp_action *erp_action)
 {
@@ -3525,11 +3342,6 @@ zfcp_erp_action_to_ready(struct zfcp_erp
 	list_move(&erp_action->list, &erp_action->adapter->erp_ready_head);
 }
 
-/*
- * function:	zfcp_erp_port_boxed
- *
- * purpose:
- */
 void
 zfcp_erp_port_boxed(struct zfcp_port *port)
 {
@@ -3546,11 +3358,6 @@ zfcp_erp_port_boxed(struct zfcp_port *po
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED);
 }
 
-/*
- * function:	zfcp_erp_unit_boxed
- *
- * purpose:
- */
 void
 zfcp_erp_unit_boxed(struct zfcp_unit *unit)
 {
@@ -3564,11 +3371,6 @@ zfcp_erp_unit_boxed(struct zfcp_unit *un
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
 }
 
-/*
- * function:	zfcp_erp_port_access_denied
- *
- * purpose:
- */
 void
 zfcp_erp_port_access_denied(struct zfcp_port *port)
 {
@@ -3585,11 +3387,6 @@ zfcp_erp_port_access_denied(struct zfcp_
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-/*
- * function:	zfcp_erp_unit_access_denied
- *
- * purpose:
- */
 void
 zfcp_erp_unit_access_denied(struct zfcp_unit *unit)
 {
@@ -3603,11 +3400,6 @@ zfcp_erp_unit_access_denied(struct zfcp_
 			ZFCP_SET);
 }
 
-/*
- * function:	zfcp_erp_adapter_access_changed
- *
- * purpose:
- */
 void
 zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter)
 {
@@ -3629,11 +3421,6 @@ zfcp_erp_adapter_access_changed(struct z
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-/*
- * function:	zfcp_erp_port_access_changed
- *
- * purpose:
- */
 void
 zfcp_erp_port_access_changed(struct zfcp_port *port)
 {
@@ -3662,11 +3449,6 @@ zfcp_erp_port_access_changed(struct zfcp
 				zfcp_get_busid_by_adapter(adapter), port->wwpn);
 }
 
-/*
- * function:	zfcp_erp_unit_access_changed
- *
- * purpose:
- */
 void
 zfcp_erp_unit_access_changed(struct zfcp_unit *unit)
 {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 4a35960..4475e41 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1929,14 +1929,6 @@ skip_fsfstatus:
 	return retval;
 }
 
-/*
- * function:
- *
- * purpose:
- *
- * returns:	address of initiated FSF request
- *		NULL - request could not be initiated
- */
 int
 zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 {
@@ -3656,18 +3648,6 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_send_fcp_command_task_management
- *
- * purpose:
- *
- * returns:
- *
- * FIXME(design): should be watched by a timeout!!!
- * FIXME(design) shouldn't this be modified to return an int
- *               also...don't know how though
- *
- */
 struct zfcp_fsf_req *
 zfcp_fsf_send_fcp_command_task_management(struct zfcp_adapter *adapter,
 					  struct zfcp_unit *unit,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 4b4041a..118cf0f 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -151,14 +151,6 @@ set_driver_byte(u32 * result, char statu
 	set_byte(result, status, 3);
 }
 
-/*
- * function:	zfcp_scsi_slave_alloc
- *
- * purpose:
- *
- * returns:
- */
-
 static int
 zfcp_scsi_slave_alloc(struct scsi_device *sdp)
 {
@@ -185,14 +177,6 @@ zfcp_scsi_slave_alloc(struct scsi_device
 	return retval;
 }
 
-/*
- * function:	zfcp_scsi_slave_destroy
- *
- * purpose:
- *
- * returns:
- */
-
 static void
 zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
@@ -364,15 +348,6 @@ zfcp_scsi_queuecommand(struct scsi_cmnd 
 	return zfcp_scsi_command_async(adapter, unit, scpnt, NULL);
 }
 
-/*
- * function:    zfcp_unit_lookup
- *
- * purpose:
- *
- * returns:
- *
- * context:	
- */
 static struct zfcp_unit *
 zfcp_unit_lookup(struct zfcp_adapter *adapter, int channel, scsi_id_t id,
 		 scsi_lun_t lun)
@@ -481,13 +456,6 @@ zfcp_scsi_eh_abort_handler(struct scsi_c
 	return retval;
 }
 
-/*
- * function:	zfcp_scsi_eh_device_reset_handler
- *
- * purpose:
- *
- * returns:
- */
 int
 zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
@@ -615,13 +583,6 @@ zfcp_scsi_eh_host_reset_handler(struct s
 	return SUCCESS;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 int
 zfcp_adapter_scsi_register(struct zfcp_adapter *adapter)
 {
@@ -668,13 +629,6 @@ zfcp_adapter_scsi_register(struct zfcp_a
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	
- *
- * returns:
- */
 void
 zfcp_adapter_scsi_unregister(struct zfcp_adapter *adapter)
 {
-- 
1.3.3.gd5e3d

